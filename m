Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F570CCFA04
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 02:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3DEA8E0003; Tue,  4 Nov 2025 21:29:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEDF48E0002; Tue,  4 Nov 2025 21:29:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B758E0003; Tue,  4 Nov 2025 21:29:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8CA8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 21:29:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DF30B5CC1
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:29:45 +0000 (UTC)
X-FDA: 84074972730.28.A6E96AF
Received: from mail-m93245.xmail.ntesmail.com (mail-m93245.xmail.ntesmail.com [103.126.93.245])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23FAA180002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 02:29:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=seu.edu.cn header.s=default header.b=SgjWg6jJ;
	spf=pass (imf16.hostedemail.com: domain of zilin@seu.edu.cn designates 103.126.93.245 as permitted sender) smtp.mailfrom=zilin@seu.edu.cn;
	dmarc=pass (policy=none) header.from=seu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762309783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LcRHFkNUNb4BP3TxxcV+q8/C0VDrALX19FW40WNd0fU=;
	b=3mq8fJZqDR/8L2ilKRIoDgt7egHHKtrca4hiaTCMyvSrgy9MA8+L9PrAkqjAisGR36/T7t
	J9fABBjnVHro5flz6zxbzwmon8evUUFZLbuqJ4ZvSbLwCNR2aUecL2RtEb8X6x31c1u209
	y4E96i1ciTQicckgJSrUPXYklWjCbH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762309783; a=rsa-sha256;
	cv=none;
	b=zlNJqc5bNQzjtQXfAKoxnHbjuBfHycqiJ/3DwbsMyK18Sw1t/jtZeJwlq8Bo9zwK+0STRz
	QsOBornQIxpZ/JZIbjoo4ZxusCtsAv7IkZs/VQqhGMWE/ttAM1rjubYOOr/PVv2nuKHX3s
	1RUXoCfDdFg+522ncLXtUUiZ1JbFIo0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=seu.edu.cn header.s=default header.b=SgjWg6jJ;
	spf=pass (imf16.hostedemail.com: domain of zilin@seu.edu.cn designates 103.126.93.245 as permitted sender) smtp.mailfrom=zilin@seu.edu.cn;
	dmarc=pass (policy=none) header.from=seu.edu.cn
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2869c975e;
	Wed, 5 Nov 2025 10:29:36 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: viro@zeniv.linux.org.uk
Cc: brauner@kernel.org,
	jack@suse.cz,
	kees@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Zilin Guan <zilin@seu.edu.cn>
Subject: [PATCH] binfmt_misc: restore write access before closing files opened by open_exec()
Date: Wed,  5 Nov 2025 02:29:23 +0000
Message-Id: <20251105022923.1813587-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9a51d923e503a1kunm720395536d221e
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZTBhDVk4aHxlITEwYHR1NGVYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJDQ0xVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=SgjWg6jJ8wpyCmGsWH3WTVRLOG3JzbweeWqjDcGDpbonlNJWyIFDP4Lt0u/yuOsGM9lInXLigVcnDDepki4vvA+Nb5jyFwvqwpt10FOi/iZ3WLgu2g6HhZ5o5IV07TysvZl+wCJeOllRwbp4mBntB8hyqV7hYUVxuwshUpeGVhs=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=LcRHFkNUNb4BP3TxxcV+q8/C0VDrALX19FW40WNd0fU=;
	h=date:mime-version:subject:message-id:from;
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 23FAA180002
X-Stat-Signature: 7diq17gokt6akp449m3fro6mzifodwc4
X-HE-Tag: 1762309781-563022
X-HE-Meta: U2FsdGVkX1/ZSc/alLwpYa9UM+Bb1RoRXmw0hBlr/Y02H4lEsOHRLzKOtXqlb0K8kX1BEMbNOyXIKzBtGKZfUmNcDtvIn8EjVKRbvn8Lmt53z00Z4GBe8v2c6yH50cWIidJ9o92M8cRsshHO2qIuyohxnV8hnCpadPx4VfAdzo55BE5xh3OJ62bjQLXNFkuVgJ/iJt0ZEf6eOKDPk8YAc18OwXwQv0tVcGtrzSUyHZSPERx7/h1cLgwB+h/GM4fUcnwa8/mUlOQp7imv7wPkToMSm87YazBhaZ35+X3rpu5Xn9IiFbpEPq/Q0Cf3eikxZklDM2tzbiOjniWa1/vlb8CzAQHYAwxQ+aPI3uuyRSUVymg4jtCkr9tIpdnpF5uyGoZvL1iP0Br17bZrH4qfFN7yi2gqeOzCbYfRnGwZ3LwPje1X3NnNM5LZ05BB0nQoQtvVDsYsoT6/qhHO8FijE7OiZ1GSdYZUuWEZZfECcEj41SKVB7Ig7ttRbySRQd9g1hvbWGzkVzLOu4u/kBAcBaYDlhHxd5QdZm3Jl1J1miNPFsILrGBnG3vl5qHyp1kxrSMGZI0+6S4b5T9MDrtmh2EZBfjXBDgfc/GGqZOGPJX6nZVu3MldWM2KLwgf6oXtLF1IyMv5mPiLWkBLaT4SBQcWEXsnaIwY1cxcOV7PoFjebC83n8BkFjbSnETLPdWcO9sst8aJ31jHT2QvvLwpTArAeF4H3A75tY5SQO2CQWfPP/gFTPvr7MjkePiIrTon7LEusBnywM4zW1fmjjEObceYd7nsbbRZCiIR3qENvsTksH/xbq+n1aQpGqEMYAJ7qquIspskM3iF7NKbYInNFINuYK5xxEW8CtW761YVuAnSZCW6vd9Toj4Y84StnyKZn0VXDTlFUolff/CSRPzB8a4qX/4ZeHGWArgmV6n6dADJfdr/UNfr81cZOHhx7EdAMkYRrTN/8qVpBrlPhsA
 LCgSbt67
 oMnY1iJuy2427cA1TDfnQepw+nd+Nc39q+nMadvifmzG50dj31ENliy93mpV2ITBpM6snc3q8Qb9Vc5Ot2N1NhTY3H9eAKL2t8p184aJqVfZp5LygPlcOQ5Sw3AeYvhpsv84Q76Q7QWqcA1/R5KZlVBpJZz5o3AsOHLcrRoUOEZsM2LBHP6TdsEPoZ5cM21JS59VtU3NLW1BFAr5rB/mMH50T/LdAkbyeCXvhnqYFCA16jCDgvMCNuvaZw7g5dRDCI5GxieavTv3L9iHUgieWoM4Xjh2F60MWOOq+KojE7Ix/K4I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.041218, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bm_register_write() opens an executable file using open_exec(), which
internally calls do_open_execat() and denies write access on the file to
avoid modification while it is being executed.

However, when an error occurs, bm_register_write() closes the file using
filp_close() directly. This does not restore the write permission, which
may cause subsequent write operations on the same file to fail.

Fix this by calling exe_file_allow_write_access() before filp_close() to
restore the write permission properly.

Fixes: e7850f4d844e ("binfmt_misc: fix possible deadlock in bm_register_write")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
---
 fs/binfmt_misc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a839f960cd4a..a8b1d79e4af0 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -837,8 +837,10 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	inode_unlock(d_inode(root));
 
 	if (err) {
-		if (f)
+		if (f) {
+			exe_file_allow_write_access(f);
 			filp_close(f, NULL);
+		}
 		kfree(e);
 		return err;
 	}
-- 
2.34.1



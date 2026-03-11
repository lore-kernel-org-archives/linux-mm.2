Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD7FFD88D8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 02:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63F86B0088; Tue, 10 Mar 2026 22:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3CD86B0089; Tue, 10 Mar 2026 22:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D856B008A; Tue, 10 Mar 2026 22:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E80C6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:07:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 333221B7DAC
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:07:01 +0000 (UTC)
X-FDA: 84532144242.01.1E84116
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3BF0E4000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 02:06:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GFawb3gi;
	spf=pass (imf01.hostedemail.com: domain of rob_garcia@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=rob_garcia@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773194819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=11rxilNzodvuvzCLO3MeHRDznxrP0FHOC7bmEuqJ1b8=;
	b=JqLvmBzzx1G+Vuk2cCmMK1uXvr6kHhWb9Ps/M+pxEfpAsz1XrRxioqJHNKWCUf1uOPPgjt
	G+r3J+nZvmSeULedKVSaRmvOEHkwQn8ZmAJ1oauA4t7kM16A91pYPzEL7qCdclsuZyuE1i
	zRGU5DSSZ2wft1WlaI2mEmt7n2zYLCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773194819; a=rsa-sha256;
	cv=none;
	b=BpRcOx/SkrDBY/OkaSjlg3ZhBe+FqAPANQj7E/AOkybgPsjNTPCv7JoMK50kHMLvaiFnmZ
	l39OpC3RZZ4rbDO4+i/e4JvYEF10jhejdLzhmJsB/fBv94TNZQff9Baoed6Lb68YBQrKyr
	XM4RXUrJThg9iaHCWLK+2TtAZtbOO+U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=GFawb3gi;
	spf=pass (imf01.hostedemail.com: domain of rob_garcia@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=rob_garcia@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=11
	rxilNzodvuvzCLO3MeHRDznxrP0FHOC7bmEuqJ1b8=; b=GFawb3gikhiyWsj5on
	PJquTZ2rs7aDllf5iGz3f3JX0tjcgLPoclScVyPz84iKOWkZ575hVjGRtKa+1fmZ
	hYcxy+zRAB9xlXpcJfuPFV5OgEJGj7+LCCoDAX93ZmzNYjgmwSdVLpLhBjKxMy3u
	lImlppAKKWayCknO2mUtsCL7g=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wAHRmQlzrBpECQpAQ--.39464S2;
	Wed, 11 Mar 2026 10:06:30 +0800 (CST)
From: Robert Garcia <rob_garcia@163.com>
To: stable@vger.kernel.org,
	Zilin Guan <zilin@seu.edu.cn>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Robert Garcia <rob_garcia@163.com>,
	Jan Kara <jack@suse.cz>,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Helge Deller <deller@gmx.de>,
	Lior Ribak <liorribak@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6.1.y] binfmt_misc: restore write access before closing files opened by open_exec()
Date: Wed, 11 Mar 2026 10:06:29 +0800
Message-Id: <20260311020629.465757-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAHRmQlzrBpECQpAQ--.39464S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw4fGF48tw1UurW8AF1DWrg_yoW8WF4Dpr
	W5K34UtrZIqryj9ayvyas8XF15G3Z7Gr12vr4kWw1xXF1rXrs0gFZ2g3yj93W0y397A3yF
	qF4rC3sYyryUAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UoCJQUUUUU=
X-Originating-IP: [60.247.85.88]
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbC5QZDrmmwziZAtAAA3L
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3BF0E4000E
X-Stat-Signature: trxtto5dbi7jkhcbueyrw1gro8557xat
X-Rspam-User: 
X-HE-Tag: 1773194817-309667
X-HE-Meta: U2FsdGVkX1+fVdQgvfPqvtlyKnPYmcDKQ/RXJHDWw6gzp1z8aRmjFSsL4s1tNp9D9VpvPXSeckXEL7igIcm0Y9h4INQxDUmZzYp00MrAsUv50MbUhn1CpT+8bppGENT9p9yNTMYEoZRIbG5g72/DJ6wbcac+siI26RoAvoVtV4QiZAy8DA3Yhw+4xfbyGKugf2BalZ3+/Y64FvxvDbFdfujQ4m0azUnm2PDnbj2YCX/Ld/K5X/45nZsYssSpBd/myHkHbptSR4+mPhKeiNAIMITcCwJmoHPWPbO22L0zSmUqYSu9UtEFHiEymMyafMLCEPjayH5i3UBsHWcRxFeNE15hzJkZn+urv916rZ15FHmBiUuC3b89PHTXT7bWRYPUxHDv+JlYeXKF6rIu+vUNV8WANELRiuHZ46NGO5T5yDRIJopT0CG8xUmn2T2RjZv3TnKNPlbgQzFgL09aGRbIGkS6vR//oMhyIIFllqGQlLnTg5L5aZ7DAIgQU/OlH4Y0C01zerkDHRMwWi38Gu8ud8xxF8+DbRMoMYsgK2Fkp5pVrX6TfciO91LxGTc0FAGHoCPuhtPHgmpf5ELvKrJKjzhxXFU6uSOB5OUuLVRtcwh7DcJpU258Bo3trdJ8KQ1ZkzxMxQhISCZgzONz5N04bQW6kzJou/SeudfPcATFNSTXhmvYPXud/z7M16unARGJ95bQXzIz2X6P4FXmweC8nwxjU6n608fEx0kBV3S3NpAJEl9XD4wudyZpwcAZ5oSSWbg+8SGjU8a09Ct6QDzOC2pPB42lCFNSQoXp1jt+wGl2RkATouitcPoSd039+/X5PbncYHfSpX9Sr+ciCY4EtxAmLUeH14CgTaAsKkuh0csBc/eNZSzM6iRYqqPT9SCxMc/kV9mb71xBlRSTSK68uoHLdHFoaVBCG49NChtelkMC3+7QU9LD1PJpIWFxI6Uhns0cGbkxPIH32VrvbJ9
 0Waf8x2H
 iPvYZvZokOZxEbPYlI4VZmnCP0aFsKIeOUR6zqHejI4Xhx1y6ODEkN03BplDj16CDuwaBVWZxQIpWeRF1+dJzBkZIU3GGuKEirid3oYXzKoehT1aN+5j57/1NcCU20BXY8U3AJwqwBX9R4XLpqM3agcuvb1X6yDlb3SHfw1h/S2J6SkNFKajtYtzSCwf6eXfxuw3GUaZjiFYP+LPR/NnLEECvvkcQLNvWG9F4jtBYnHBMjRuJ2M8f8Sg9OJpxV5+1lax7B48ImFc8UnTCrFXSg+aY1v/KEytHUMG+AEmqFrN5ZmjSKX8JFdAWtd4VKDPS+RPOHfbGTrhCUp3JzWXnaZ88yUrObaM46Ic9c1dc3kK9rwfrAnQRD5+eylAUMAyBopg0+2vgTz4Jbv//lFyNCMfkxzArFSN4y3k1fXAhgq7GE3uBo5pWpCeH5KcU/2b1kVca8NfHE4O/CfQU3PIpoD4ZtF+VW2P32Rs9HKvxsH1VvtFgonK8PsduLVjc9gTTsltOH/SuxR+ZYOFdN+jjP4kmV/kRkgtHtVFb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 90f601b497d76f40fa66795c3ecf625b6aced9fd ]

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
Link: https://patch.msgid.link/20251105022923.1813587-1-zilin@seu.edu.cn
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ Use allow_write_access() instead of exe_file_allow_write_access()
according to commit 0357ef03c94ef
("fs: don't block write during exec on pre-content watched files"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
---
 fs/binfmt_misc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 740dac1012ae..05c235309421 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -816,8 +816,10 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	inode_unlock(d_inode(root));
 
 	if (err) {
-		if (f)
+		if (f) {
+			allow_write_access(f);
 			filp_close(f, NULL);
+		}
 		kfree(e);
 		return err;
 	}
-- 
2.34.1



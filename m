Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB112D1F9A0
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 09:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB916B000D; Thu,  4 Dec 2025 04:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3886B0011; Thu,  4 Dec 2025 04:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32826B0012; Thu,  4 Dec 2025 04:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC1A76B000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 04:44:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1E731608EF
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:44:52 +0000 (UTC)
X-FDA: 84181304424.29.F0DE035
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5B3671C0012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:44:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcHgjceE;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764841491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Md7YEG8EeK6zCXkGgB3TAg2CV3Idn2v18gZ8hGgmdKs=;
	b=gFfo1uR+jJeB+i/XvfQyb+CD9IpIkLu1ANCpnwxnbQddFz72er3psl2fehy+Ok64FyRfen
	8zfzG2IsJNDFk96vS/l0muUFVxUQeLBtVKDTPGwfM6fJJhJsZ8zBWiX128e+n6Nevw0rNI
	39SonHJOlgso40CFtdctaPTtEBmyQt0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcHgjceE;
	spf=pass (imf21.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764841491; a=rsa-sha256;
	cv=none;
	b=olTi0ilfOwTXEsr1oH8Iq35UHzVicjNO04Gdz9Ir9r9mUvApzlXfaooXYQ8ZRFESvFfHXR
	ERS9IjKCUrvejz08A0O5icg/G4xOrQYtNcUvUd9LZDOHXid/6qsIbQ1kPOifIgmlokWk/4
	76LasRBy/68YrknS8PcYkHkfyDpkObg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A96C6001A;
	Thu,  4 Dec 2025 09:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3DDC116C6;
	Thu,  4 Dec 2025 09:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764841490;
	bh=jlmiccTMN/1Oqk4mzHOf5koXbzDGcyAl4fechJYospA=;
	h=From:To:Cc:Subject:Date:From;
	b=dcHgjceE/S19b53sOprVYiTrlqI/08Mr6v7CS1nGxHSNxHrep2exo1uQTYKX7KGHW
	 dowxAtgAVci5tsKjhNLZYk0pN00xbr1bmkM9htxqLXRHNlOzI0GVliDk88GUOTRtlF
	 0X0ZAJNnFSwRY2XxY0PgIdELvibm1oh9yAfC8de845ZNxsHgv8wjKoI8E245tuDMU3
	 P6UMFqzlGEydIFy8eUQOvE9MPBTF+1YWuYexKqq2JiOz3oxBndm7d4/ctV5s49ko+z
	 R7/+wGlD8uOWfxDImL9/CXHbOEVHSehnd0/QhGsTzm7a38DHI5uxsgEgwpZIwoJx3K
	 Q6sy5TVSZ5L4w==
From: Arnd Bergmann <arnd@kernel.org>
To: Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Guo Weikang <guoweikang.kernel@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: shmem: avoid build warning for CONFIG_SHMEM=n
Date: Thu,  4 Dec 2025 10:44:40 +0100
Message-Id: <20251204094444.1030143-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aeyqfwtjy5xy1stzxkkp4ixowgjyubzd
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B3671C0012
X-Rspamd-Server: rspam09
X-HE-Tag: 1764841491-339101
X-HE-Meta: U2FsdGVkX18x893R2pFEcVcIp7r3nvwbY3qSJ0WFWnfQLcUdH9Y0CXyu9bA3S1+HVlBAJXXlCb+5gAoqQ6sxX3MTJdZ6RZ3sB0uDgMkHQHouk17BnzCk05rJAxu89alk7RHCmyrpcEDzuH1PUtq1GXsw/F3J2KvMacrcIBT21ofrmw0W73bRosoyTkGP5zGUMaCeYvqzuq4o3/6aMPFqJ7KPRTPM1/gvLd4AFbs0QZH0xWpJyjYDnO1rppkFa66BK0cLUi05QfK/yyn17L2L9K/mlOp1TSnFJNGHDfZS41ufNasWaAGpDGIivNKyV2utZDDFcUBCPBvhKEZ+5rkGVHufrF6DS+78whYD3uWtuhXaNeRVsPYjG90VnZbJcF0FF2I9VzktNl+/PoOKKd6yxyDtMziNVU5TXmwL0c8+DL2r+bgR4Y1F10838fmK+y3zfdcPouYKLc81i8fMDokJgE6o3XOHzS7dink4gbis5EdVrdV4qdFLJkedCYhWrWMMGezqHi9MHQQwDrWU+sFX/PWvBDaxirC5ElE0dV+UwtQr1iEWBGXfmItziFTbn8IgcsngB6p/22N40BXvN+goRbpvBmaBat1+BeExduT9mmdvcMqI3r09pS8taLtXd3oMETrzeJQ7ej8cV+lOmIv6uGJ/Fmcw1fvZG7CIygqrfRxzN2vFEkHopspYQzG46rUHS8iJsXtxaGDHWsbMR/aWXwQ19kOY9S1Ia2jQMa/xPS7xcsZPNA03rSoyPc070LLzMHfrVCOBq67dF5vxUOTVunnsV8uWOiNQLQNU36ituVFY9moI8ujhl1pXbe9K1hdg4dvSVl/WokKs7S9ywksyTcSoieyKFVy+6lfVBJZV9oLNelxbZm3OCSKATl1Bmj13o7xMJbxZDxmEYzTImJuMXXniAHepNQFSQ6DMC3Bzd0+Z2QhnShrWgVvwCv0yJMb++dsM+zm94aXfTBnzGGc
 a3tcA1Wl
 g6+5ZwoYc5aJzsJcoZpMMSWNF7bSeLGGCcCZ8Op/S10yA146vpQ8waR8+IIcrCrgyLKRbyOymZDgGKerQtJ5DrOmi/YHhzEngNxwgGujBN0wq3janTumIK/vbVBDj9NBntSxNnvJJ2Itc0ag0nQ/OpwsgW9dDXo5zYr8wgMgMb02BzuJdoSlp+0xEf8QW7L0HOpk7lxYaZ6RwNtYRS9Zdp1wXGnph/F48SpW+X20LPcRS4J+NIHWeQ5dTiBzei6fVeYP2eTmGinEtNAL7yz9EAH+ttsWey7MF27wRu483rXR/J6l655b9VwfklIAbvNwMUkOv+l31urm82II9ahgfZ9EnR8aBitqoyVx/pf2KbHGlsB0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

The newly added 'flags' variable is unused and causes a warning if
CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
into does nothing:

mm/shmem.c: In function '__shmem_file_setup':
mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
 5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
      |                       ^~~~~

Replace the macro with an equivalent inline function to get the
argument checking.

Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 mm/shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3f194c9842a8..93746270c459 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5794,7 +5794,7 @@ EXPORT_SYMBOL_GPL(shmem_truncate_range);
 #define shmem_vm_ops				generic_file_vm_ops
 #define shmem_anon_vm_ops			generic_file_vm_ops
 #define shmem_file_operations			ramfs_file_operations
-#define shmem_acct_size(flags, size)		0
+static inline int shmem_acct_size(unsigned long flags, loff_t size) { return 0; }
 #define shmem_unacct_size(flags, size)		do {} while (0)
 
 static inline struct inode *shmem_get_inode(struct mnt_idmap *idmap,
-- 
2.39.5



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5E8AD2F036
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FCBC6B0089; Tue, 27 Jan 2026 09:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45C746B008A; Tue, 27 Jan 2026 09:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0B26B008C; Tue, 27 Jan 2026 09:38:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB4D6B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:38:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D05805632E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:34 +0000 (UTC)
X-FDA: 84377999748.17.07E970D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2FD218000C
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iX4++nwm
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769524712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppkYoCuCIwbG08Yog1w1PKZoiZaGtf8kK0Yf9zB3YpY=;
	b=0s++Fcj6Wf7RAROOQNtyW2L01YIpiFJeFNc1aTq+V4aAs7TKR0V/xD5ve3v17+OOS77d5J
	sc7i3hFdZ5ebRnEUTVDGLlEa2f4kS977RbvcP1TrfGSmLraZrQ9pRzsfFrvHxOdcFtsVq4
	n038KY2JYXd+UY30R2kJcCvuCRrxmUY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=iX4++nwm;
	spf=none (imf16.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769524712; a=rsa-sha256;
	cv=none;
	b=GTpctuTOFtVJgKrTR5zNZ7Jhp1BIKO1VmhBE2OxXUR5AwJAmx7UyxXQw5XpdXAPP+jR9Um
	SczsV54PLDBXvOXAD6A6/2maOPzZgrjpXBcFGC3JFYFhwNJPpIoZu4KgowzXSaQkrg5N4h
	9gDY1cRaM0k/Omtwq9jQ3aqn3T3HIu4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ppkYoCuCIwbG08Yog1w1PKZoiZaGtf8kK0Yf9zB3YpY=; b=iX4++nwmPyyfA9UIOdjH2mSyHF
	Jw2TGQpc8CK0TuxKaivM6Ut1YtVbgkbzz3i3OipDWGK/y+dAKh7mNRsBXJ8zervKp/6Lvwvttv7ua
	gpLVJIg7nxpG1pYMkk5BS6CP2UkJy29go0G0f7Z/bMW9azK6R/HIabSTttfgVNQgOlY5y73+1yX/S
	IW8vnoYDW55ogz1sEiRiLP1WCMgYx1bDxh9nhVi1OWH86QDcakpQL3RlqLERmnzp3inqkuP+A1X83
	kiSjwDCgJsXldxyoxN6lI3Y5KBYRQnMYjiaAOdU7Q7gsuFynTlFee3TrEixgHNAm3IcI5tzfszHLU
	EOU/w3lw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkkD3-00H3b9-MS; Tue, 27 Jan 2026 14:38:26 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 27 Jan 2026 06:37:36 -0800
Subject: [PATCH v6 1/4] kho: add size parameter to kho_add_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260127-kho-v6-1-56f9396681c2@debian.org>
References: <20260127-kho-v6-0-56f9396681c2@debian.org>
In-Reply-To: <20260127-kho-v6-0-56f9396681c2@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-f4305
X-Developer-Signature: v=1; a=openpgp-sha256; l=9092; i=leitao@debian.org;
 h=from:subject:message-id; bh=nk3yyun6LiJx2hB1RVium4TTK98kuuyYqMmz5Tx1hAc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpeM3Wnk5kJhqw21vjInix4DA5gZacK/0QQ2Ckq
 LMAStNlioyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXjN1gAKCRA1o5Of/Hh3
 bTdBD/9jXaXJvc23pY8B3+/fv4tKZqlbkoijG6RR/T1DyACmP3943c/gwoIZTcJCUTl5/bup/vE
 aBSptIjtYz4+FZGzu37omfjUU6frY+vS6gE8Nwx97zMuxAA1jfW6fAvLvDagyYgfzSUcV/6g0X7
 5RxDmj0OVaiq08orWHyfYZUY61MEy/o76114FYj3qyDbUm6L+sdwyRnEP2AqXQeCSMfPw2DWMda
 YDxLQLgAnF/icmdLKuXGXk99fZuVG30yDhaLw6V8tc4IRBVLSIwX9Z9NGOXSELi2Ke7Zl49DoWY
 6lKFAl2GOuJHC8DpEtUdRNMpJhNxV9E9/Ik+535Ii3rnpoUEGE4lhic2VVsE5rCvJ0tBMh/Cn1a
 DP9Thcm1qx9U5U5Nkf9jNam0u4NcWSG4t0WAwImyzG0HiGfv9NEuORY00yPIKWzcflg0+rkcsq+
 E8A3/O56XS63mqGh1LrEOyz4ALG+4uFcZ3vPMMFQBNbTJZJNLFGlsH5yjqS58hZfTrwckS4NsNr
 tulrzon/DE7epcWHop6o3YwRgUK9dHG7/erTuPmxUQ1hUGm1RLGUG7YtCpCNBGXXAlYiVaADzQv
 PK60F5iE4CTZGqaO03nweNEwHqhF7VdYF+Led+hvM0XEZLUfifHmAQwXhOEUxncXOubJY7J3ffH
 1LFeYfAkNugoiTw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: B2FD218000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 3s4rsmyoithddmer51c7eqt1459duuqj
X-HE-Tag: 1769524712-969413
X-HE-Meta: U2FsdGVkX18C9vULPFoBesBvQwetNjsrmCl0s7p3JBbDb2VFosQdQSixLEQlNSxNgJMSTWBPA167E6FsKEzceQhHJGZVJ22CV/lgpl21tTeUdJ1DOHypHax8haHVf5OYJTza5MZ+7b09puUIZmJE5H6PsFuiIfmbEl6upRTOiuO767uGtXFiQIit/P1DK3J8JKcUVUDZ7d9yUnWsAhTgv5/ZtmRkNolTi3K/w6Gk8GRYYmcKzB558y5BwdehBmiY9sgcoRf00jweZYb+vaZ7FfcZ6GK8P8RSX3ctqlYIWtLkyqaIeLT+e86qPu3g/Q0yIYG49GBT1XTcJ//S5odhF/81+uUD1u4rHpOkYcC66rm4Wk9QhBUhn+i03N+9j/X+sjS6SnRKtudtdqOS8Tn0BLw1w+0r86wNZnVdax3YGNHiCL+TrQAaVa7OsZObWLDbhQKA3Gna40zp6FmPuh/sbDBpJrE6r7lJUhxT7JvM3J4Q0fMl0cdXPUvoG/jmBGn9mwxqbXSnL/LRQr89KijNmYw75O0k3XUGkHSqUGj/rqU6RQtwFjYEo9K9u3QSAQmkPh8YntkxrZSe61gVTQjYi6lAlydenruWvIm37wCkTjl7iBhBU2PGLSABJ5LktbAkDe1eBDYP6YBYlNLulWTaKkhS3JJSW/xSayJpzssrMQbE3iCP3ontElTJojw0vc3gNT54T5PsMCgehTOlEfU4cVLEPu4ijaK1YdSUeA9Ob2dfa4OFe74Z/8fmbxgckvbC3iPKiJj8o/p0OL4j3RtH4ytXfRYH61BTqDmQMOZgd9XOWSZ/saNY7itVmswnKJuwJrOd4yWB7dnAckymOxNdsHsISlph2FkhaRnM+rqKHH/Nf7BqxUxVc7Sktt75/OtA8NAEEzbXlepU3A6PobBTsk0xQQyI79sRsmPvPhFBJYCH3m96APr3LBLjAnD3xt4nA6E94ANPjjWCyzBszPY
 /M4yWsAD
 oltzvszYaOOu2jwdzWxWgE1DbH6oIDrj8LzDJ0EfBj8lOvu64qbxBM1z70yvsmEyuJ5fts494aXKPijAuQBhlMz4DUjgYL6TLOPxNLHyFsBtlVqDOtSAxLu8iLfrCObuLHgSHdOUhCIuOcEkfh+k/jiSJLzUFzY9/YIsmA7hzgEeILg/LwGcvo+YVALjCL2B6a2lmRP2U8JDwdA2olM2GQH/nGtUcR3p9cfN1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_add_subtree() assumes the fdt argument is always an FDT and calls
fdt_totalsize() on it in the debugfs code path. This assumption will
break if a caller passes arbitrary data instead of an FDT.

When CONFIG_KEXEC_HANDOVER_DEBUGFS is enabled, kho_debugfs_fdt_add()
calls __kho_debugfs_fdt_add(), which executes:

    f->wrapper.size = fdt_totalsize(fdt);

Fix this by adding an explicit size parameter to kho_add_subtree() so
callers specify the blob size. This allows subtrees to contain
arbitrary data formats, not just FDTs. Update all callers:

  - memblock.c: use fdt_totalsize(fdt)
  - luo_core.c: use fdt_totalsize(fdt_out)
  - test_kho.c: use fdt_totalsize()
  - kexec_handover.c (root fdt): use fdt_totalsize(kho_out.fdt)

Also update kho_in_debugfs_init() to compute sizes using fdt_totalsize()
for the root and sub-FDTs it processes, since these are known to be
actual FDT blobs.

Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/kexec_handover.h              |  4 ++--
 kernel/liveupdate/kexec_handover.c          |  8 +++++---
 kernel/liveupdate/kexec_handover_debugfs.c  | 15 +++++++++------
 kernel/liveupdate/kexec_handover_internal.h |  5 +++--
 kernel/liveupdate/luo_core.c                |  3 ++-
 lib/test_kho.c                              |  3 ++-
 mm/memblock.c                               |  2 +-
 7 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ac4129d1d7416..abb1d324f42d0 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -32,7 +32,7 @@ void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
-int kho_add_subtree(const char *name, void *fdt);
+int kho_add_subtree(const char *name, void *fdt, size_t size);
 void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -97,7 +97,7 @@ static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	return NULL;
 }
 
-static inline int kho_add_subtree(const char *name, void *fdt)
+static inline int kho_add_subtree(const char *name, void *fdt, size_t size)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 8a2b2a7e50fc6..ad2da9e4e6a04 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -726,6 +726,7 @@ static void __init kho_reserve_scratch(void)
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
+ * @size: size of the blob in bytes.
  *
  * Creates a new child node named @name in KHO root FDT and records
  * the physical address of @fdt. The pages of @fdt must also be preserved
@@ -737,7 +738,7 @@ static void __init kho_reserve_scratch(void)
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt, size_t size)
 {
 	phys_addr_t phys = virt_to_phys(fdt);
 	void *root_fdt = kho_out.fdt;
@@ -762,7 +763,7 @@ int kho_add_subtree(const char *name, void *fdt)
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -1402,7 +1403,8 @@ static __init int kho_init(void)
 	}
 
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt, true));
+					 kho_out.fdt,
+					 fdt_totalsize(kho_out.fdt), true));
 
 	return 0;
 
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 2abbf62ba9424..64970c88c483c 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -24,7 +24,7 @@ struct fdt_debugfs {
 };
 
 static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
-				 const char *name, const void *fdt)
+				 const char *name, const void *fdt, size_t size)
 {
 	struct fdt_debugfs *f;
 	struct dentry *file;
@@ -34,7 +34,7 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 		return -ENOMEM;
 
 	f->wrapper.data = (void *)fdt;
-	f->wrapper.size = fdt_totalsize(fdt);
+	f->wrapper.size = size;
 
 	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
 	if (IS_ERR(file)) {
@@ -49,7 +49,7 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 }
 
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, bool root)
+			const void *fdt, size_t size, bool root)
 {
 	struct dentry *dir;
 
@@ -58,7 +58,7 @@ int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 	else
 		dir = dbg->sub_fdt_dir;
 
-	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
+	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt, size);
 }
 
 void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
@@ -130,7 +130,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt);
+	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
+				    fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -138,6 +139,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
 		const u64 *fdt_phys;
+		void *sub_fdt;
 
 		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
 		if (!fdt_phys)
@@ -147,8 +149,9 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 				name, len);
 			continue;
 		}
+		sub_fdt = phys_to_virt(*fdt_phys);
 		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
-					    phys_to_virt(*fdt_phys));
+					    sub_fdt, fdt_totalsize(sub_fdt));
 		if (err) {
 			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
 				ERR_PTR(err));
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 0202c85ad14f9..a51f97f0fa0e6 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -30,7 +30,7 @@ int kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, bool root);
+			const void *fdt, size_t size, bool root);
 void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
@@ -38,7 +38,8 @@ static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 				       const void *fdt) { }
 static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
 static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-				      const void *fdt, bool root) { return 0; }
+				      const void *fdt, size_t size,
+				      bool root) { return 0; }
 static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
 					  void *fdt) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index dda7bb57d421c..a4721813dd994 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -172,7 +172,8 @@ static int __init luo_fdt_setup(void)
 	if (err)
 		goto exit_free;
 
-	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out);
+	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out,
+			      fdt_totalsize(fdt_out));
 	if (err)
 		goto exit_free;
 	luo_global.fdt_out = fdt_out;
diff --git a/lib/test_kho.c b/lib/test_kho.c
index a20fafaf9846b..f2d7d9108cf41 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -143,7 +143,8 @@ static int kho_test_preserve(struct kho_test_state *state)
 	if (err)
 		goto err_unpreserve_data;
 
-	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt));
+	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt),
+			      fdt_totalsize(folio_address(state->fdt)));
 	if (err)
 		goto err_unpreserve_data;
 
diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a809..91d4162eec63f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2510,7 +2510,7 @@ static int __init prepare_kho_fdt(void)
 	if (err)
 		goto err_unpreserve_fdt;
 
-	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt, fdt_totalsize(fdt));
 	if (err)
 		goto err_unpreserve_fdt;
 

-- 
2.47.3



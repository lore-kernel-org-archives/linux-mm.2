Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28DAAF3C24E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C83A6B008A; Mon,  9 Mar 2026 09:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685796B008C; Mon,  9 Mar 2026 09:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6396B0092; Mon,  9 Mar 2026 09:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7DA6B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:42:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8F1F1392C3
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:29 +0000 (UTC)
X-FDA: 84526639218.11.85DF668
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id F31F7140009
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ubhtqgy4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9ZZhOrRGryuFNle00hDqS1xUJYiiR7dmjtWIiWkagc=;
	b=8KIOmE41H7Hr5AZJmgWYUuAGQC9W7ITdAZrkEmPiWrLdCYcmArdF9mY/MitnxDTJgxlwG8
	PQ/PR4r9Go0tH/dJgq2t6Lf3rDjJdOJQx2zBGDcy5RfxPkYJyDjKYY3M9D2JNbcoC3E1Rf
	FA1OJKX1V/7bW71bTrAWAhQw0Ul50Ks=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ubhtqgy4;
	dmarc=none;
	spf=none (imf23.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063748; a=rsa-sha256;
	cv=none;
	b=nCS/ActaPj3AR1JQL5SOT5iSvhgiDJ8ouvf6HYPBNcHxPzx4A/cyLa1dup3ugDEFJPNjKE
	fjX5NvDtwHsXvGnRzX3Qf3rOKeslPn1VGBKcnbSvLI0DIxYpKUKgy1eViCraX4xOlSNuXG
	6RpgsuM/RMp9K/iG7386SiBWPS0pHPs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=/9ZZhOrRGryuFNle00hDqS1xUJYiiR7dmjtWIiWkagc=; b=Ubhtqgy4HMwanqCg2PYREW8y45
	C7UCIT1SQKJXy9BmmpvP/cBYRX9MA4G/OF3A3T5Maak+/vnK+mMpR/VhZW4o71GoratWh6eIztgDP
	QSq2MSWMrhZA/eYyq7badpL2BM4Ops2gdIUfhKYs3krh0I8UsVbSOc8RXxkjxqb8AYO/pMTbWLvxt
	BgE+PxqqHDGp+soUuW+AwfEqcLa2AWjUycizw7Yc09L/5PjkQOzhkEI0ZScPKxQfrlceE/gCUYplw
	9b/mNMsQgvKllBOrc/auV7DRv4mPtAeNTVm5Hki5JrrQ4drb0eAcUDKLaTE6aGzYllNlBpfTYI+rj
	9zgDh7Jw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzasG-002G3H-5V; Mon, 09 Mar 2026 13:42:20 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 09 Mar 2026 06:41:44 -0700
Subject: [PATCH v8 1/6] kho: add size parameter to kho_add_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-kho-v8-1-c3abcf4ac750@debian.org>
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
In-Reply-To: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=9284; i=leitao@debian.org;
 h=from:subject:message-id; bh=aU0aIKTD5Anicm9v3gMTJTcMaA4+bBorKPfkcBjPpeQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprs4ydBOVZ3Yk/BUJ+QELIZEuEZLFQIhio9Yca
 2h0XKXcDiqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa7OMgAKCRA1o5Of/Hh3
 bQ9kEACUcvuCGCaVsyjc7znsMxQtUt+CeEDKYnkHGl9+c72+2NVpRZM22wMADYwSpYyd7h4rhW8
 lDrZ4Bk4CAY2rha7FCH43wLRRvuEuAitusS0x+U8p6UDpBqZyZTWbJ2Ov443LvyA9Ifu7oa7MG8
 fjKrYWQGtJ0EAxOdfuoZCGaP6/R/Lt4M9GGW5Tz2ayh1vxjfdjQvp99J/BWH+8k1HonZVb5if/h
 an9Zte9i686AXecTnFdGMOCgZV+egnivY7X9aHJtrC+BsEpYLOCJAFKi5AkkwrD8J4Y8Xsvfj8q
 2zryyhx2UBPhCB7w/wv9741Sjce/dRs5HcSWNWKboqmkK8vvXO+0P0RqERHIrtzOlAnlBzOjgOC
 5XkNrR+8myuX7WsFaY3LjZrh4ld04QSgJkFwMWmirMAzS7nepf01f1LB7A6goGRRriJ2ZkhYzAx
 wHAs3ObVG8Pd6eym5X6pngGW9PZ+MWAR+7RbDVs5prll29q41y929rdCeL+Si41Olu34iCoHWGk
 jQZkDEliMJlII0k57J2uA2h9WXOdFXQsiMWKw+Mk6NXSbcU705nIYEnuD9W6ffriSZeH4EYy4ln
 sdwxXqP09ZJ3sO6I5YOPWYJ2ZZOPp0BFCbyjGPBFRWQ3udhT038Bg9mTJxdMG5N3SnkCU/+RUJE
 ZohD9f2CIAd9xCA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F31F7140009
X-Stat-Signature: fy3z5eixkkoi1eqgpyjy7idc5yjc5qo6
X-Rspam-User: 
X-HE-Tag: 1773063747-100966
X-HE-Meta: U2FsdGVkX19o/Ki+T3lmou9ZBjq+7Ym2cXYeYPBznTNQSy7p9BwWgtNlhlPeAM22O4Mky3fFcTxTo2CuZUvJZACwIaPiQf7c7QrESoBnJSZ/+3ZHEqKihH17ofaO3qF6lHwfUJzL2wsebnFLGNPMRgpXzTAIkUjDKLUIbtsYCv/RFhrs7hX2SQYvcMImakDsRNPAGhpydhKW6IVBK843cSROE0gs3HGkcg8DvZHK4QcfenlMjLz2ETiQ7AZcxctq5qsHoLyQO/2NxVgv6gZs1jrkF1QUQ5AXtEUi0XeD8aJ/czFcrvyQm1nqocS7m1OCeesCsw6JKk1+X8OjPbKFs1q0UoTSmIPoC7CNJp9F+47DIFUXIVXb1bEAOIn0hue4pSZ04Mi6y6+Ooop/ES9vJzo10TZVv6AbD4UsQK2Mzd4I5nIKrtl/hxAgCIXeNypZsgE2LBvtpzDmIxf88vykvfONTx+iptOZDjc92yHteWmvFox8oXdU+bVafaX5N/Waf2fGYutwR5wKKp+xscUJ4tXgYWbmczlNkknaxSb5TefaJGYV/PEKbs6VKm2W5H/ICdsjemBFVBbavH6ssS7fwo0L3Ru8Rf8JA1gX35ieiSXM9vs/aX+HtrEFeJQDRMfK0UWY7zZt+ISvkISWdNDKolwqViIhgvAp07OunSKODlA16WbkWjVG/doSB8WPtvkm0K8i2OGu+bnCysv+IodWzk1ECJaCIuoUMPDmQAOVH7uIQ4gwu+edHHCOu8pgBjizPlmxkgLfda79ZPzQNf/mP0M495LtSeGpKakNepBzwMJL9AEnr2KnbfVZQ9qRphQH3nkJDJasZMFdp737bhcYxEXqayfabEOHXKKLFw2MYRiKRYkRmSTHmQ8tuPhxvNkxP1vQRBEpCSZOQNoboSB0dyMNLXD0+yqIcfBjNdNcD2hsoxQ1lQTglKgDZMkzPCOLSJHvqHmfJbWYG58xCJU
 UzMB1wok
 lgXVc4wAVBmdwdnUiJDLFpRX8G/ZMlZ7nXADFgrfXRFNx5TM1ZdfSk2tjNQ6IEpY9HVMgoalmckmuzU7Sxa/XjiZ6EQAWBB0mdxm8udVHYn0PrLhlTVxL56Fpc26haF2UDGjBNNBf1kVFWKAg+ZeEmB6W/7op24I+/XMOlWFaAIl+nkRd1DEsPOQu5N8Wt00ntzJgKidMgauF3ehqTcGBxQUnWxosvhlSemKU
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

Also update __kho_debugfs_fdt_add() to receive the size explicitly
instead of computing it internally via fdt_totalsize(). In
kho_in_debugfs_init(), pass fdt_totalsize() for the root FDT and
sub-blobs since all current users are FDTs. A subsequent patch will
persist the size in the KHO FDT so the incoming side can handle
non-FDT blobs correctly.

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
index b64f36a452965..55bdc5d2d1929 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -752,6 +752,7 @@ static void __init kho_reserve_scratch(void)
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
+ * @size: size of the blob in bytes.
  *
  * Creates a new child node named @name in KHO root FDT and records
  * the physical address of @fdt. The pages of @fdt must also be preserved
@@ -763,7 +764,7 @@ static void __init kho_reserve_scratch(void)
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt, size_t size)
 {
 	phys_addr_t phys = virt_to_phys(fdt);
 	void *root_fdt = kho_out.fdt;
@@ -788,7 +789,7 @@ int kho_add_subtree(const char *name, void *fdt)
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -1452,7 +1453,8 @@ static __init int kho_init(void)
 	}
 
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt, true));
+					 kho_out.fdt,
+					 fdt_totalsize(kho_out.fdt), true));
 
 	return 0;
 
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 3f395fbd978f4..b5a1e09ca8f14 100644
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
@@ -112,7 +112,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt);
+	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
+				    fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -120,6 +121,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
 		const u64 *fdt_phys;
+		void *sub_fdt;
 
 		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
 		if (!fdt_phys)
@@ -129,8 +131,9 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
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
index 9a832a35254cf..2a28cb8db9b0a 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -27,7 +27,7 @@ int kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, bool root);
+			const void *fdt, size_t size, bool root);
 void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
@@ -35,7 +35,8 @@ static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
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
index 84ac728d63baa..04d06a0906c0e 100644
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
index 7ef9e40618696..2631824373152 100644
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
index ae6a5af46bd78..29e12ea2a854c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2488,7 +2488,7 @@ static int __init prepare_kho_fdt(void)
 	if (err)
 		goto err_unpreserve_fdt;
 
-	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt, fdt_totalsize(fdt));
 	if (err)
 		goto err_unpreserve_fdt;
 

-- 
2.47.3



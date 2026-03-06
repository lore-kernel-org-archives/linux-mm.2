Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAA1F0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153C16B008C; Fri,  6 Mar 2026 07:39:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107D56B0093; Fri,  6 Mar 2026 07:39:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033BB6B0095; Fri,  6 Mar 2026 07:39:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E609D6B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:39:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9884E8BE13
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:39:54 +0000 (UTC)
X-FDA: 84515595108.13.8B63341
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id A2899140007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:39:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="MTAQI/o5"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jPQeI5iP3IUgbGEOnO1hH1SOYsnp9o5xyKhbpyewiY=;
	b=dqtBiCD1tCdSP3Es4N+EIP/xjFJHQWqALb4A649OEU0A5IMJzUIr+UBoPcax4RqpkD/htS
	72s/uJvS3GlTDyGC/05jPdBz2BrBvZD4nPf8BBxUQ49Qy7LauAQ85FLcqmI2YQOcq7kCCV
	Zq1EVcR8WEO6Wd+xD7KFD0qgRbyHvJA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="MTAQI/o5";
	spf=none (imf26.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800792; a=rsa-sha256;
	cv=none;
	b=7CGOQ+ssGOX/PdrePa0EKoSBrEwqMU1l423wFbf+T93T64qmjaAdUo0lu+PErR9yS4LR6t
	pZ7eZ2NmO0caeRJ/8YzfqqlBLD50G18SjiQ+N/wVmqyNzrieXPeLR4uPnbqE6CzPHuvZfs
	/7CncQ6WoRGXl8DUJjuBXufY8oFAeWA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=7jPQeI5iP3IUgbGEOnO1hH1SOYsnp9o5xyKhbpyewiY=; b=MTAQI/o5Y/id2t27NCQhGVgayc
	3aPClizN8r9PBlf3ZltBKLzXx4p5twH5vFtYD44R1k+G6JGRbuDK7or6f8MdbUHC4IU/08V3RcFWa
	VF6vnZSf1EErtObcG8DwG1L2x65j7gCOLdtLLr00TPVZthoF/3EfSlAFvYoMIBABMz2Rn/kl74WyU
	Bb94Sv6OBK5hLcfmOHGteH5AHQswa16ur1Ro7XwvSSmTu6UZgJzsEaMc0hTXsBv+sQMBa/3JsvShD
	WVslXBUtYz2TB5NDWPP8nShDN40HZzyvHdzJoJwFU0HtAGVhKkNGpPy2VpzT0eBzi+be3Yrq9dj6V
	NnGe4i3g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyUT5-00HVQx-IB; Fri, 06 Mar 2026 12:39:47 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Mar 2026 04:39:21 -0800
Subject: [PATCH v7 2/6] kho: rename fdt parameter to blob in
 kho_add/remove_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kho-v7-2-404d14c188bb@debian.org>
References: <20260306-kho-v7-0-404d14c188bb@debian.org>
In-Reply-To: <20260306-kho-v7-0-404d14c188bb@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=9178; i=leitao@debian.org;
 h=from:subject:message-id; bh=7TBdPTTYw0zoMn471vRtwsNMfp1d8kR2nSnZkv9zjn8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqssGIKZGmNU3hCa8g+ly8QAVPqzEA2R1Rg2uN
 KR/bNTpMK+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaarLBgAKCRA1o5Of/Hh3
 bUByD/wOMNonG5IbxBIjvypv0cfOhp/C09PFjscftPB7DDHHdzuVeGg022d8R2Ir2LZxv+H/2CU
 Xxvu6aZ5/EBb5LZjFs9ZNAkwpajLgU+2NNpBlEXsRDvdq1HMICdgzGgonajCLlykT4QBXFZb4Kk
 gY5issaX5MSr3s27QJN6U0cPH/UFfA392XzCtMbXTftbB+zOyMVY0RJnTyD+0JzGZqQmNhzRtBQ
 uT7AHGkmeXhwZ+TqeQoTerxq0JAJw8ocqHejB1fTJGmJGA2OdAjTpbRSmWRTStJn/HF/aHuZAhN
 oNSU3Cajhy1PigzDUyrjc5sX0CGjIJFTofyXYveETtl/tRBOH+3WeyckmRXjBpsbCbB0Np5LTLH
 oJQ18OWWOgKx9UOiUs8qdTT2ntoyX75kboQJysmAXfvp/5Bx0yAds5UFJcXtt55g9vf1k2qfV3G
 yC2BPIujO/Ep7qZPv3AMb89rN83jUxjgz+zYrTH2BjB8xb0cWh3CwvVBQ3jKZF9tYxDCXcalhvn
 cY8yxgRuliGPFh7gYNma+UNr0knvfBRuQ/p1hiH8RSCy+hTFGfGjkKMYri17mVdEg6mmB6lyJEG
 Xw3hTuyVoKQSvnVbZt2sXdCLeRyqzsGlO+ZIVLHv7GMVlLhuRqtJq5GbwWz1u4OoDcw5jX5kkca
 3Oo28hnVjvR8lFQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A2899140007
X-Stat-Signature: uox4att6g9jkj4878hthswxen564s8fd
X-Rspam-User: 
X-HE-Tag: 1772800792-937232
X-HE-Meta: U2FsdGVkX18CF9l+v2H97M/xV2dr9U2sTKKIGYDOLC+RjhjlO/N5rpxch3Z7hhv6Vzy9raUy0gf+2JmX8407H/n8yd27Orfg5WtDYWSuKgTpH8wUVrFvH1AH87lk1suvE0TJYiBK+wXS6sTG9Es6cxl4CaX5DyiwB41bh4n7V9725x9xeEHwUGWmJqQOXHx6UpwD8K2CvQqKO6OdbpRvR0Bf/sAkSd17dgiVfMcOdZzNA5D6MnwWgqYY1HQlE3nOWJMTedtw1Cz+iDnM6IoUg9dsWOX+8Sivbxa/DnBy1XoXzut3FS48OhWmV+5DRl9yy65BRCyGuDI9qL0aQs6bSqZ6VzyJbiE9AFVoifp5CNMsV/J+iOT3oVLtyJFhh/nPmWyYnwkwSZtrTWTXF5c3SWYI/kz+6NYcmhcIqhsbmVRFsRKebRfuI2t8sPUxW99ieM4aA9e++sEgmi21o5ZSSMqh7qwiagiQlSvUWJtoxdEC/W1xm0AfLUDAAn5A06yDf3O0X/8N5DwZ8oNjHyZN/P7CoO4+pnw3OPQ1luiqdPom0VukQ3cMpp+8unRaj9Ls43Z4Ob8PCVVsRiiR+y3clndCyGeH1MQEHwieHMXnTqIGRUXm3wG7aSkjQjF2ZGf11N1RQ5hrnReb5FNibGJwX/FeWUg+M1klAVSaXoyRHbIPAEIVdCWUMDkvbto3XtTNPEw7GZ6X/RxSsmsNoVKv6dRhGA9ROdFRq8/Ssg0KIcsbNHBmje2/l2Nk9Ynl8lz4OmrrA6ssQj3igcuv8hJmEzHy2P68Pfpq04VJXZI4TGF7V5g70LFG50o9XLELQGOKJri4zUtEtAyqiPgHglrtZCzgsVyBtQs+YN2Dab+Czzz2iHiywjovFg9bBiq77VGaKJoaBxcnA1ibRmceWevFv893EwDKAJfvBHOT+yDNRStvQOdndezYGxg6eo5+VyfNEg+awSoULKN7Ptf0fBv
 q7N6f/MU
 tGDFInyU7giuSUGoqcSSENUP27PngJd6aJPvRFAHrBBnn5eE1gx0xd8+RYGKuXFASl9kIACZ6B5S77k1y5uuNQmZTIRfKIokshsOaVo5qdrrHc+H36tuzZA9CEobyZu+XPi74WDUKQjD5eNDKVjG4PiduZkmyzIyrSi/WK5fJltxnHySyqzYZzWbWTlS/odwwHjUNxJPTD3ybV3g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since kho_add_subtree() now accepts arbitrary data blobs (not just
FDTs), rename the parameter from 'fdt' to 'blob' to better reflect
its purpose. Apply the same rename to kho_remove_subtree() for
consistency.

Also rename kho_debugfs_fdt_add() and kho_debugfs_fdt_remove() to
kho_debugfs_blob_add() and kho_debugfs_blob_remove() respectively,
with the same parameter rename from 'fdt' to 'blob'.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/kexec_handover.h              |  8 ++++----
 kernel/liveupdate/kexec_handover.c          | 25 +++++++++++++------------
 kernel/liveupdate/kexec_handover_debugfs.c  | 25 +++++++++++++------------
 kernel/liveupdate/kexec_handover_internal.h | 16 ++++++++--------
 4 files changed, 38 insertions(+), 36 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index abb1d324f42d0..0666cf298c7f4 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -32,8 +32,8 @@ void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
-int kho_add_subtree(const char *name, void *fdt, size_t size);
-void kho_remove_subtree(void *fdt);
+int kho_add_subtree(const char *name, void *blob, size_t size);
+void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
 void kho_memory_init(void);
@@ -97,12 +97,12 @@ static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	return NULL;
 }
 
-static inline int kho_add_subtree(const char *name, void *fdt, size_t size)
+static inline int kho_add_subtree(const char *name, void *blob, size_t size)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_remove_subtree(void *fdt) { }
+static inline void kho_remove_subtree(void *blob) { }
 
 static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 55bdc5d2d1929..ebaf3104c36ab 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -749,13 +749,13 @@ static void __init kho_reserve_scratch(void)
 }
 
 /**
- * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
+ * kho_add_subtree - record the physical address of a sub blob in KHO root tree.
  * @name: name of the sub tree.
- * @fdt: the sub tree blob.
+ * @blob: the sub tree blob.
  * @size: size of the blob in bytes.
  *
  * Creates a new child node named @name in KHO root FDT and records
- * the physical address of @fdt. The pages of @fdt must also be preserved
+ * the physical address of @blob. The pages of @blob must also be preserved
  * by KHO for the new kernel to retrieve it after kexec.
  *
  * A debugfs blob entry is also created at
@@ -764,9 +764,9 @@ static void __init kho_reserve_scratch(void)
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(const char *name, void *fdt, size_t size)
+int kho_add_subtree(const char *name, void *blob, size_t size)
 {
-	phys_addr_t phys = virt_to_phys(fdt);
+	phys_addr_t phys = virt_to_phys(blob);
 	void *root_fdt = kho_out.fdt;
 	int err = -ENOMEM;
 	int off, fdt_err;
@@ -789,7 +789,8 @@ int kho_add_subtree(const char *name, void *fdt, size_t size)
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
+	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
+					  size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -798,9 +799,9 @@ int kho_add_subtree(const char *name, void *fdt, size_t size)
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-void kho_remove_subtree(void *fdt)
+void kho_remove_subtree(void *blob)
 {
-	phys_addr_t target_phys = virt_to_phys(fdt);
+	phys_addr_t target_phys = virt_to_phys(blob);
 	void *root_fdt = kho_out.fdt;
 	int off;
 	int err;
@@ -822,7 +823,7 @@ void kho_remove_subtree(void *fdt)
 
 		if ((phys_addr_t)*val == target_phys) {
 			fdt_del_node(root_fdt, off);
-			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
+			kho_debugfs_blob_remove(&kho_out.dbg, blob);
 			break;
 		}
 	}
@@ -1452,9 +1453,9 @@ static __init int kho_init(void)
 		return 0;
 	}
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt,
-					 fdt_totalsize(kho_out.fdt), true));
+	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, "fdt",
+					  kho_out.fdt,
+					  fdt_totalsize(kho_out.fdt), true));
 
 	return 0;
 
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index b5a1e09ca8f14..7a100f2bf3947 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -23,8 +23,9 @@ struct fdt_debugfs {
 	struct dentry *file;
 };
 
-static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
-				 const char *name, const void *fdt, size_t size)
+static int __kho_debugfs_blob_add(struct list_head *list, struct dentry *dir,
+				  const char *name, const void *blob,
+				  size_t size)
 {
 	struct fdt_debugfs *f;
 	struct dentry *file;
@@ -33,7 +34,7 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 	if (!f)
 		return -ENOMEM;
 
-	f->wrapper.data = (void *)fdt;
+	f->wrapper.data = (void *)blob;
 	f->wrapper.size = size;
 
 	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
@@ -48,8 +49,8 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 	return 0;
 }
 
-int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, size_t size, bool root)
+int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
+			 const void *blob, size_t size, bool root)
 {
 	struct dentry *dir;
 
@@ -58,15 +59,15 @@ int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 	else
 		dir = dbg->sub_fdt_dir;
 
-	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt, size);
+	return __kho_debugfs_blob_add(&dbg->fdt_list, dir, name, blob, size);
 }
 
-void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
+void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob)
 {
 	struct fdt_debugfs *ff;
 
 	list_for_each_entry(ff, &dbg->fdt_list, list) {
-		if (ff->wrapper.data == fdt) {
+		if (ff->wrapper.data == blob) {
 			debugfs_remove(ff->file);
 			list_del(&ff->list);
 			kfree(ff);
@@ -112,8 +113,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
-				    fdt_totalsize(fdt));
+	err = __kho_debugfs_blob_add(&dbg->fdt_list, dir, "fdt", fdt,
+				     fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -132,8 +133,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 			continue;
 		}
 		sub_fdt = phys_to_virt(*fdt_phys);
-		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
-					    sub_fdt, fdt_totalsize(sub_fdt));
+		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
+					     sub_fdt, fdt_totalsize(sub_fdt));
 		if (err) {
 			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
 				ERR_PTR(err));
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 2a28cb8db9b0a..0399ff1077750 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -26,19 +26,19 @@ extern unsigned int kho_scratch_cnt;
 int kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
-int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, size_t size, bool root);
-void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
+int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
+			 const void *blob, size_t size, bool root);
+void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
 static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 				       const void *fdt) { }
 static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
-static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-				      const void *fdt, size_t size,
-				      bool root) { return 0; }
-static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
-					  void *fdt) { }
+static inline int kho_debugfs_blob_add(struct kho_debugfs *dbg,
+				       const char *name, const void *blob,
+				       size_t size, bool root) { return 0; }
+static inline void kho_debugfs_blob_remove(struct kho_debugfs *dbg,
+					   void *blob) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUG

-- 
2.47.3



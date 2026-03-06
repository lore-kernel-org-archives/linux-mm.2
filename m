Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4456DF01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:40:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A406B0093; Fri,  6 Mar 2026 07:39:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB226B0095; Fri,  6 Mar 2026 07:39:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A158D6B0096; Fri,  6 Mar 2026 07:39:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB726B0093
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:39:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BAC813B1DB
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:39:59 +0000 (UTC)
X-FDA: 84515595318.13.70BC152
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 412F7C000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:39:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=otTFmNzP
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BhE/kAyP2PMNYjVkf7VWvL5e+VPagJ0YxqGnWHCRq+U=;
	b=D6kieVvRmlw520uggiVPrnlWgJmaZg55yco8uwmNStKUI88tclZiYXb84Oov+oNh3ZtjjZ
	NSY0sE6RxWcNmDl06sigoPZ3xnWMAJqhMzgU7bvjctQDOL5wW6rz32MwimRl1kwrNaVJuu
	a1J7QOTKBSqX8uLnuPFxz7K0fOnqR4g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=otTFmNzP;
	spf=none (imf22.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800797; a=rsa-sha256;
	cv=none;
	b=qhYylgC+kMbIPLKgxySdZ3+bv+vzqvTLIrRvAr44yjT+9te5ARhxm6b6XuG0r0dEtfBx9E
	JL+KTYSs3b1qem9HcJBdM1HBJlg1Czv3RYXZrOUZn36ubkTjbbVTnjGK4vfbgpsprVDQEv
	Qo2f+gqPu9rC/ROcYS/98sCtY96FPuI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=BhE/kAyP2PMNYjVkf7VWvL5e+VPagJ0YxqGnWHCRq+U=; b=otTFmNzPd7YM26o9dFWndy2jPm
	syzmZNvKrdueC/JBHgsO2f3v9JoR8xugHxv5fEx3H8BAs/CU53elqAj9DQ5QAmjct+F8jOvh+MqdC
	rHZrMxpF2Q8tPyABTCTv/CukKCTnaRsKsMFsZXKgwbYtaNvmLMyUaUeIhr5Bulg7NkXqZTvFx7Aih
	QAFmWemNks0GmVla99JsL7VtKNlV0rW3rOTN0ZwgRIRzIFZqTpydnNF39B/aJNsezRwUxKapu+Iz1
	36PibsBkOI/MBnu35jNALK4kKE6UsDxvCoROvPP0plrVykCpvZp8htU0OCY5na58XLNF2Z+dNpim9
	wNsmNQ2w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyUTA-00HVR9-1n; Fri, 06 Mar 2026 12:39:52 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Mar 2026 04:39:22 -0800
Subject: [PATCH v7 3/6] kho: persist blob size in KHO FDT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kho-v7-3-404d14c188bb@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7293; i=leitao@debian.org;
 h=from:subject:message-id; bh=SCRWzBzn9iJWzcyHMXkCR/smhQiBHZEHRDsJ6N05VTs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqssGJ2ZzRQn7CHLdGRWOkEqcEMCc2WgNTIUfO
 rcE++1Jb5eJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaarLBgAKCRA1o5Of/Hh3
 beRdD/4ndO7EJhwQP5T/1HuZorU8UvNdcgrME6SbRYx078Rnqo/eaP/0Q4iaB4VXYAVfzdgXTFk
 vrOIwL7SsuYiIEfhiIlbIbH7pZ9Wl9WW7n9f+cptxzHEsJlIazkpDo/NdM0XddA7s75ftK4bVoF
 yNTStYv99M2Ozt3ZDKJW4m5yLYSh6GNBEolTu9AaECy8Gwl6uE7NBtPRra2AAdZD60/rcRxfQRT
 Tz5uj7D5wXYKYxSAN3iREssM+claNxo+RoAGMNwHDZ25tCDNmp2EvyMnsP/PzxRVjn4a8Ufxcc1
 T8zTh6xWZkYJgln/twWzdzWWv5KOTk2cyj1ygeLjGJxO7abylNz8Wba9RSfgqRG912/Wh4ABfUp
 iIBZ3p8IRgj7Kpx5TcWCkHr6NuparF+KMRrZfo9w3TW6G6dTJrIeVbVMSYU1WeWlrczPdfkCDer
 VUzwZK4ijCoNumo6ubxZI+gEvA9yeMyrhRaNqebY7JlrgaWp9HgSoBXHB3ejmyP9qBN812Ufdyl
 iABe2Ew0vMudWk52iYlQymdFtxaeJkS3rG443NJXoAvOrYo06pNK72RRLMI6vvxEt4guIzPePIl
 Q4sO2SbPobAUC44aEmOYZ3tI+DzvjgIaSoMP6EkyO7JOhgoaSWPcrkoo2NTV4DbLObZoIbXl7qJ
 +BT22k9C4zgnpiw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 412F7C000F
X-Stat-Signature: owyade79a7pe1dr6jfcfbumtryyjkn9p
X-Rspam-User: 
X-HE-Tag: 1772800797-150392
X-HE-Meta: U2FsdGVkX194IH91wVLT9YL6EgSGU/ce4rFLEZ89SgkYZmhqyUEkIc/g8hcQXfLNAZDee9HLBZs+QfCgGFmKEO+xXnBRJzdSV73hXzz+2nfUbTpkIZ1vOY6aE1Wv+uTOO2PW8MNZ5A1xuG5Er2u8UDV5m//dUsGONOndG/JN+e1OjAAV7FGy16OkssMFrO9/TWeznp5VfL5nmeOqFTF60QO8563FgIkltt9ooQInxDRPEDKyRgeOU42CXHg1vpRLoka+hrrPoGQ1hJo3eFxg7uob9eBvPerxQkPX4RiSi2HVhAwJT+Ckk6LBovcUAyqo6ZD6ACgKDD73ZW65kAeICsqrE240HPOkm+zx+fJTYSTqFHB/XzXF0iWPxiK8cjAcuBri0+6jOFk5t3kj320Xrj77Fe+/OydsuHzTQ7LBpon0imwkGOiXBuGZHeyHaWdsuU64K31dX/OH6e7bJr8ipA98iALzSZmkpKSSHg88dVs0q8Bsm1LxjPbSYpESeBC8nPCQoKxtOt71YK3ki7dRfBFm92hMeya9kBi8mB/vTUWqwIfPeQJ7TjQ+16ExeUJhy6hnxbzCXb6cfe84ZSKTbqELmCMfpMNpgXz517bVfc/bIdIYqNqEaCZPiekRNJzgsPgfBWeyrwpOXVNNHgTXaeBzp6FxLiQgAyQozK8v0s5H/YGurc1F+9wlagJiZDkvNPX6cGoA+ytBb4xbp4ukd7kWj+xj+ZqnMCg/TbPgeztk9BTFu6AhYUI6yJoyWtrlTr7koliphIl7ofOCrM4y0bTgCKWkYWBy63Su86sXUdUnCnhS+Xqq+KqvChsZcpmja7oMaYAKdSRMfEvr44m9af8YyB5Cj7hFKc8+mJ6Zr9BYtvlZXl2yxnKHy93FUIMSNkPIUk1E+RFNDnLecEN8rqVI3DeZwlUi7uRkcPDO4V8qgxhldD2IyHyk0eZ4Ov3nin/sU09iqtc3lfmRb81
 C47X0Th5
 hhpV1zUgxTKSwXIJoSOhaE+ruz605w3F/zKz+bLgXBQ3ZWU2NT4dt3e5tkvQrc3geEb2vQWvlnvf7FBUF1EXx6ZftYNwB2dx8a/q691hiazihCe9OF1NY7t8GfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_add_subtree() accepts a size parameter but only forwards it to
debugfs. The size is not persisted in the KHO FDT, so it is lost across
kexec. This makes it impossible for the incoming kernel to determine the
blob size without understanding the blob format.

Store the blob size as a "blob-size" property in the KHO FDT alongside
the "preserved-data" physical address. This allows the receiving kernel
to recover the size for any blob regardless of format.

Also extend kho_retrieve_subtree() with an optional size output
parameter so callers can learn the blob size without needing to
understand the blob format. Update all callers to pass NULL for the
new parameter.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/kexec_handover.h         |  5 +++--
 include/linux/kho/abi/kexec_handover.h | 12 ++++++++++++
 kernel/liveupdate/kexec_handover.c     | 28 ++++++++++++++++++++++------
 kernel/liveupdate/luo_core.c           |  2 +-
 lib/test_kho.c                         |  2 +-
 mm/memblock.c                          |  2 +-
 6 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 0666cf298c7f4..8968c56d2d73e 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -34,7 +34,7 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
 int kho_add_subtree(const char *name, void *blob, size_t size);
 void kho_remove_subtree(void *blob);
-int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
+int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
 
 void kho_memory_init(void);
 
@@ -104,7 +104,8 @@ static inline int kho_add_subtree(const char *name, void *blob, size_t size)
 
 static inline void kho_remove_subtree(void *blob) { }
 
-static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
+static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys,
+				       size_t *size)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 6b7d8ef550f98..15bf7a5be8cf1 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -47,14 +47,17 @@
  *
  *         <subnode-name-1> {
  *             preserved-data = <0x...>;
+ *             blob-size = <0x...>;
  *         };
  *
  *         <subnode-name-2> {
  *             preserved-data = <0x...>;
+ *             blob-size = <0x...>;
  *         };
  *               ... ...
  *         <subnode-name-N> {
  *             preserved-data = <0x...>;
+ *             blob-size = <0x...>;
  *         };
  *     };
  *
@@ -78,6 +81,12 @@
  *
  *       Physical address pointing to a subnode data blob that is also
  *       being preserved.
+ *
+ *     - blob-size: u64
+ *
+ *       Size in bytes of the preserved data blob. This is needed because
+ *       blobs may use arbitrary formats (not just FDT), so the size
+ *       cannot be determined from the blob content alone.
  */
 
 /* The compatible string for the KHO FDT root node. */
@@ -89,6 +98,9 @@
 /* The FDT property for preserved data blobs. */
 #define KHO_FDT_SUB_TREE_PROP_NAME "preserved-data"
 
+/* The FDT property for the size of preserved data blobs. */
+#define KHO_FDT_SUB_TREE_SIZE_PROP_NAME "blob-size"
+
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
  *
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index ebaf3104c36ab..e52615fdd5e4b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -768,6 +768,7 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
 {
 	phys_addr_t phys = virt_to_phys(blob);
 	void *root_fdt = kho_out.fdt;
+	u64 size_u64 = size;
 	int err = -ENOMEM;
 	int off, fdt_err;
 
@@ -789,6 +790,11 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
 	if (err < 0)
 		goto out_pack;
 
+	err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_SIZE_PROP_NAME,
+			  &size_u64, sizeof(size_u64));
+	if (err < 0)
+		goto out_pack;
+
 	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
 					  size, false));
 
@@ -1311,16 +1317,17 @@ bool is_kho_boot(void)
 EXPORT_SYMBOL_GPL(is_kho_boot);
 
 /**
- * kho_retrieve_subtree - retrieve a preserved sub FDT by its name.
- * @name: the name of the sub FDT passed to kho_add_subtree().
- * @phys: if found, the physical address of the sub FDT is stored in @phys.
+ * kho_retrieve_subtree - retrieve a preserved sub blob by its name.
+ * @name: the name of the sub blob passed to kho_add_subtree().
+ * @phys: if found, the physical address of the sub blob is stored in @phys.
+ * @size: if not NULL and found, the size of the sub blob is stored in @size.
  *
- * Retrieve a preserved sub FDT named @name and store its physical
- * address in @phys.
+ * Retrieve a preserved sub blob named @name and store its physical
+ * address in @phys and optionally its size in @size.
  *
  * Return: 0 on success, error code on failure
  */
-int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
+int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
 {
 	const void *fdt = kho_get_fdt();
 	const u64 *val;
@@ -1342,6 +1349,15 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 
 	*phys = (phys_addr_t)*val;
 
+	if (size) {
+		val = fdt_getprop(fdt, offset, KHO_FDT_SUB_TREE_SIZE_PROP_NAME,
+				  &len);
+		if (val && len == sizeof(*val))
+			*size = (size_t)*val;
+		else
+			*size = 0;
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 04d06a0906c0e..48b25c9abeda3 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -88,7 +88,7 @@ static int __init luo_early_startup(void)
 	}
 
 	/* Retrieve LUO subtree, and verify its format. */
-	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys);
+	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys, NULL);
 	if (err) {
 		if (err != -ENOENT) {
 			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
diff --git a/lib/test_kho.c b/lib/test_kho.c
index 2631824373152..aa6a0956bb8b7 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -319,7 +319,7 @@ static int __init kho_test_init(void)
 	if (!kho_is_enabled())
 		return 0;
 
-	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
+	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys, NULL);
 	if (!err) {
 		err = kho_test_restore(fdt_phys);
 		if (err)
diff --git a/mm/memblock.c b/mm/memblock.c
index 29e12ea2a854c..4f4bf1a9d7900 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2533,7 +2533,7 @@ static void *__init reserve_mem_kho_retrieve_fdt(void)
 	if (fdt)
 		return fdt;
 
-	err = kho_retrieve_subtree(MEMBLOCK_KHO_FDT, &fdt_phys);
+	err = kho_retrieve_subtree(MEMBLOCK_KHO_FDT, &fdt_phys, NULL);
 	if (err) {
 		if (err != -ENOENT)
 			pr_warn("failed to retrieve FDT '%s' from KHO: %d\n",

-- 
2.47.3



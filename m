Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4811AF46453
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B141B6B0206; Mon, 16 Mar 2026 07:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEC366B0208; Mon, 16 Mar 2026 07:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B106B0209; Mon, 16 Mar 2026 07:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9019C6B0206
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:56:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E9E41395EA
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:22 +0000 (UTC)
X-FDA: 84551773404.10.D65A166
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 744A64000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vVGp+VIt
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlcVx0W0VtTFst28aefWpydWDS6cGWkZyYfBnt7a02Q=;
	b=S8aG/ZdaR3TM/mKvhUHspV2FFcfkrK5I92DzvBzvm55cRBSPgfbaF2j7iJXxIw26MSC6sq
	OoVDduxZrET5qln10XTt0YoitqDdE7ZMguaVhpe60IKMXNltgzPmHPFM85J5jEQoTxIIzH
	9nv+XVaEAUkO1ubX/7kxg0XTSHVxMIk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=vVGp+VIt;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773662180; a=rsa-sha256;
	cv=none;
	b=6Vru074VZ4xJ7Y/+dtiVjnmZau5VDy2cht2FepWzhwEWiAzXqALkgcYGqtHeXmzdNOSMPJ
	FKgnhocX6FtgFhEVrE+x01G5zHhr+tw0H/XQK2Jf7NB+sa5N2/CKiVX+iqVI/hnBBmyytQ
	O1qT+j7WEGPUX44T0Z1Mi8EWGY1Buvg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=zlcVx0W0VtTFst28aefWpydWDS6cGWkZyYfBnt7a02Q=; b=vVGp+VItaaV2p2pJiYKm9hxnD8
	LBsdzLfpw1Q+Rb2HUtT1dfD02BZgvsivANkiRByFgANPC5hIqrFTxpSUSPQyHFefXJk7fd6KJdN3M
	zNYCl+RZxxDkn9tMJEHFhJ9Ln4qKTXsVGMUMdLXYE1roDErharYaqo/ewk+FeWlMx/HDwxnqhFsdt
	8yjg3ClOovkMacIJkRTAhrrukU9+o0nkMFkN+hBbi8qu6t+glTa1J74NINgkqlkS8k8AwML6h7utf
	kouLoohDDijyV5iuof9p3WomB0lW0yBuJwezY/4dKUrCgFMbB4uawJ84bAg50Axz/O2ljj6HWZFYT
	wraXQvFA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w26YV-0025zJ-RG; Mon, 16 Mar 2026 11:56:18 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 16 Mar 2026 04:54:33 -0700
Subject: [PATCH v9 3/6] kho: persist blob size in KHO FDT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260316-kho-v9-3-ed6dcd951988@debian.org>
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
In-Reply-To: <20260316-kho-v9-0-ed6dcd951988@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usama.arif@linux.dev, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=9060; i=leitao@debian.org;
 h=from:subject:message-id; bh=051C+wlXXANkMIKsppb0xbp15xPloCr4ParEX+3dVfQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpt+/QAagOvEjH+4Kb2F7XeWd2dYke4ca0A+WRu
 CzHwqqx3/iJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabfv0AAKCRA1o5Of/Hh3
 bY1HD/9cURrNPM32kFPiGDQtiEdASq3a5nKciMcaXLOzru3nUFWMZZnNH7QhUq5Jn6WbCTAmAAl
 ajbvSmAtmF8NrE5+YLR7i+v3S0+BusZYY+oSpbZOufwpDS4cGWp3CUlxi6NdIbwEhQV6DQCeyjm
 oBZSmj4JChL0bDjbH4nfb2ekMQ3iI8PrKCNA87R1oztt/3pGqQ3c0ZLCKeeU60YTbmwj87yRw9J
 txXGBquXuW5HVbB+bxk3EOBygn8ZtUEId1x/ep9nSpwFDL02v7BBcFH5JvBnM5pgRJU3/2xrFgQ
 Ab3trrYYHQJrta3wDbxCCIKOs3U9NyFxtPIWVKzkOiA900xZdZrY4wc8jIGRkh9Qjw1FWneazwN
 ZGyjZwH/73MXUzZpiN1DTJIVkOSgKlUqTUytp5MGOqoI1na8I4ZlrFlg94GRNspRzghLz3gARm/
 2ss4+aWnDsPeHcURukMGGGfDmSS4BiMoEg/suPzJG1ZcfQtyuIM2lGb14OKRSk7aIYANZBOBX8J
 ja0cmHEJGf5kqwSD1EWhrljfIV2RyowPR9MPaxiw7CVdrS5bgrBQ3Py/lbRdra51cDM200pMYS9
 N3BOgK9IybNBWtnxHQe7pFf76IqpTrkz08NiiDE7QTsKz/u4diwBKDIVZSP7tjwMCvL4ylFfFBq
 iqH42we+pFwcsaw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 744A64000B
X-Stat-Signature: sdyuut59c5dbc5i97fak46yptrtroysf
X-Rspam-User: 
X-HE-Tag: 1773662180-417400
X-HE-Meta: U2FsdGVkX1/9ZoWzLsQy1kzD8qNC0Y33o5oayuS4maBVR8hxGDCknrwO+DVW7DiAOHYsgm2Bo3C1+qMc6VZaI9hwJju72l5SNRcvKGPIz+haxkJvwhYiTMnPQbIA6GM6ovOXUvByfmAmW7jlwoZyGh/dwxQGISi7HObRuROYKre2+WCT2Tc5BwEpUlLO1btSMU9rajgW+Be15SeXQ4Rvxv/BQHiSjof1lPYPacPVShsin/OEGLwamUM02EqFJZ5vey9PD0DX4oJ4vAuRn10DBtWY7bPXw0+Uk3m8x7ov8ii2dos/NQwx3emo4tVnKuKLij/eM2pS9/o6RpmC+7aN/2GpWu6y+UneCJvmu5ZyiaNTUvvF9tumkf0esg8ihigna8ZG/DAYv1igRz5/McWbdoAk2nMfpKLMtKAEvF2QRLPFag+sShaGlQPMqzs5oswTiIg5CghcyvVe7erimcYYEKlR3UP6OuPsvCJ2VtOmDmaQZNDfXVFIEEqdJBpIMoTxJjYqDkE1PZnK/fv61Fyda0HFVpGMThW5zPepjcNaxPAz8NF1lOtDrMMCDggsq41/ykjtCb13RgmPEihwtgzIxbpWgxMbcafxek+ChyNVty6pR3m39qGu2FmHkuKp9uMPYqci4Kx5ElUh4SSn4geB4j1F+6RXfaUkOQbDcT8iO69s7K+D9UWTPu7ZsYBZMVibY7HJ3P6lwViHLC2UhFgnH1/ELgIFDDbnpWnKazuRkaVGs/B6xbYRYN//hSY80vbquFIYeD1px9Qg2jRQK3HHMpAgbUrAkyWS6ljDlXQS8yOt5pe7bG/KpA==
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

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/kexec_handover.h             |  5 +++--
 include/linux/kho/abi/kexec_handover.h     | 20 ++++++++++++++++----
 kernel/liveupdate/kexec_handover.c         | 27 ++++++++++++++++++++++-----
 kernel/liveupdate/kexec_handover_debugfs.c |  3 ++-
 kernel/liveupdate/luo_core.c               |  2 +-
 lib/test_kho.c                             |  2 +-
 mm/memblock.c                              |  2 +-
 7 files changed, 46 insertions(+), 15 deletions(-)

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
index 6b7d8ef550f98..7e847a2339b09 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -41,25 +41,28 @@
  *   restore the preserved data.::
  *
  *     / {
- *         compatible = "kho-v2";
+ *         compatible = "kho-v3";
  *
  *         preserved-memory-map = <0x...>;
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
  *   Root KHO Node (/):
- *     - compatible: "kho-v2"
+ *     - compatible: "kho-v3"
  *
  *       Indentifies the overall KHO ABI version.
  *
@@ -78,16 +81,25 @@
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
-#define KHO_FDT_COMPATIBLE "kho-v2"
+#define KHO_FDT_COMPATIBLE "kho-v3"
 
 /* The FDT property for the preserved memory map. */
 #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
 
 /* The FDT property for preserved data blobs. */
-#define KHO_FDT_SUB_TREE_PROP_NAME "preserved-data"
+#define KHO_SUB_TREE_PROP_NAME "preserved-data"
+
+/* The FDT property for the size of preserved data blobs. */
+#define KHO_SUB_TREE_SIZE_PROP_NAME "blob-size"
 
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 54fe59fe43acd..b768fb7b41280 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -768,6 +768,7 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
 {
 	phys_addr_t phys = virt_to_phys(blob);
 	void *root_fdt = kho_out.fdt;
+	u64 size_u64 = size;
 	int err = -ENOMEM;
 	int off, fdt_err;
 
@@ -784,11 +785,16 @@ int kho_add_subtree(const char *name, void *blob, size_t size)
 		goto out_pack;
 	}
 
-	err = fdt_setprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME,
+	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME,
 			  &phys, sizeof(phys));
 	if (err < 0)
 		goto out_pack;
 
+	err = fdt_setprop(root_fdt, off, KHO_SUB_TREE_SIZE_PROP_NAME,
+			  &size_u64, sizeof(size_u64));
+	if (err < 0)
+		goto out_pack;
+
 	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
 					  size, false));
 
@@ -817,7 +823,7 @@ void kho_remove_subtree(void *blob)
 		const u64 *val;
 		int len;
 
-		val = fdt_getprop(root_fdt, off, KHO_FDT_SUB_TREE_PROP_NAME, &len);
+		val = fdt_getprop(root_fdt, off, KHO_SUB_TREE_PROP_NAME, &len);
 		if (!val || len != sizeof(phys_addr_t))
 			continue;
 
@@ -1314,13 +1320,14 @@ EXPORT_SYMBOL_GPL(is_kho_boot);
  * kho_retrieve_subtree - retrieve a preserved sub blob by its name.
  * @name: the name of the sub blob passed to kho_add_subtree().
  * @phys: if found, the physical address of the sub blob is stored in @phys.
+ * @size: if not NULL and found, the size of the sub blob is stored in @size.
  *
  * Retrieve a preserved sub blob named @name and store its physical
- * address in @phys.
+ * address in @phys and optionally its size in @size.
  *
  * Return: 0 on success, error code on failure
  */
-int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
+int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size)
 {
 	const void *fdt = kho_get_fdt();
 	const u64 *val;
@@ -1336,12 +1343,22 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 	if (offset < 0)
 		return -ENOENT;
 
-	val = fdt_getprop(fdt, offset, KHO_FDT_SUB_TREE_PROP_NAME, &len);
+	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_PROP_NAME, &len);
 	if (!val || len != sizeof(*val))
 		return -EINVAL;
 
 	*phys = (phys_addr_t)*val;
 
+	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_SIZE_PROP_NAME, &len);
+	if (!val || len != sizeof(*val)) {
+		pr_warn("broken KHO subnode '%s': missing or invalid blob-size property\n",
+			name);
+		return -EINVAL;
+	}
+
+	if (size)
+		*size = (size_t)*val;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index cab923e4f5c8d..b416846810d78 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -125,7 +125,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		const u64 *fdt_phys;
 		void *sub_fdt;
 
-		fdt_phys = fdt_getprop(fdt, child, KHO_FDT_SUB_TREE_PROP_NAME, &len);
+		fdt_phys = fdt_getprop(fdt, child,
+					KHO_SUB_TREE_PROP_NAME, &len);
 		if (!fdt_phys)
 			continue;
 		if (len != sizeof(*fdt_phys)) {
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
2.52.0



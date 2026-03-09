Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96524F3C263
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6906B0088; Mon,  9 Mar 2026 09:42:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EC06B0093; Mon,  9 Mar 2026 09:42:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEA106B0096; Mon,  9 Mar 2026 09:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9F996B0093
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:42:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A4BE1401C7
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:38 +0000 (UTC)
X-FDA: 84526639596.15.9D005BA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id B637140003
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ce0ODBoe
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EKYiyJc2pJTId+ldlpo0ZDLrgplXezO3UOz8MUOHHDk=;
	b=iUD7pADKAEDNUj+QctYY1XTSoK8U6WKsvI2SVe2LUejUjc097a0tla+Yn4HbRVDPP0X4Rn
	jqqB+nHYHhs9YaLq6FLAGWLqTV0NrKXMJX2rVnq1xbHPJyRbiBZlFP5AQTpQtklvMqqRhK
	mYSlpakS+X5YG7UNxbJBlmK6UxKEbsk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063757; a=rsa-sha256;
	cv=none;
	b=DIQEJCYVokjv6ZsVgj+ZxjuLeed67bJ/ukLoQrUS/dFuiW8Aecj+6BDur48yQcBZTHBIZI
	XalOWURnBgnXaOCjM0Ipbdl5U9+c8XnL0kTLtjgyE+fGkvi2BQOXIbJ3KLZAqymF6rZvQx
	NoLh8qfSy90mjhmPCGfUrTlnUZ+oBVU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ce0ODBoe;
	dmarc=none;
	spf=none (imf04.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=EKYiyJc2pJTId+ldlpo0ZDLrgplXezO3UOz8MUOHHDk=; b=Ce0ODBoeTLUkw2GDjIX+TE/apq
	hs9NMI8U3pQ/r9k91L9p4putmJhOMMfUP1HBCk5r1y0RQx8LBLuDhSdYUb61jxDDJTfzj4AOynmOh
	3CiepRCrLuw3koKtlqaH9vGpWrtANO8oUhwb1OVTM8Tyy3KmDwCalGTC2j2pbdAJc3djfE3tRMfv/
	1NwJI3ULOWhACH6H452hBTsXh/6vh5bozKxRkWMsTe72HiLv+eE8MTCJOc+Qf2fk4waV4l93evGVS
	2nTBMISlCbv+IrpLxENh0o97GMbC+gOW68aa/OJonjF0nUk8+pm1OiB/uejXh0moteYPaOeHBhrCi
	CN76lGdw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzasO-002G3d-CS; Mon, 09 Mar 2026 13:42:28 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 09 Mar 2026 06:41:46 -0700
Subject: [PATCH v8 3/6] kho: persist blob size in KHO FDT
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-kho-v8-3-c3abcf4ac750@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8235; i=leitao@debian.org;
 h=from:subject:message-id; bh=u26q8+424ryPZEmQMXhYg2CGtc4uVC9Yg6zN9YqpvT4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprs4yZ+R2PEvk3C6myQX9u+605PCBk1NmnfWrT
 1G6bFo2c++JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa7OMgAKCRA1o5Of/Hh3
 bfSWEACl5uvGO0nE7tsUZ2bnuyNeoKjAT2ZPG9CarGKMFgDS4OnBKRyrlvqrFS6ZDYajMmI3gNO
 i5rOD3G/nuNifuByKm9SDuyhElTgIYjKOBg/CrwhWBdLdcTu9IsNvrlvE3aNUKQhAivEWEuPqMb
 wzPFhvTAfwg7wZ+/E8QhvJbZEyleiy7yW/7XMNyXZI34hkCm1Fg1QvYfGSmERMXaig+NSxWgPTl
 W+aJqQlQT8usiwCHNLA2QarHv3W7c5NJBf/8mJzIIZMUILv3mzi2vm8fFk8M0xbhDlMR/x+zr0M
 fwmMEwEs8+2cnZ+YpXgh6Dl6yyKpy8elEctki7rrVm9/KyLAofm+wty5LsBGiWSQzAfyHh9pLoe
 jh/+l96OsmXF3hIRJt1oAWshd3gyQBbksI9bC5eethWgb+dgzaYwYbOsnXbS2Zlm4dOXmyJT9DR
 xdlYexLV9zQCKkt2nEpp2+kE23pdP2kbCXO+sFwpebSDOdcSYlBBiklk8YJHGKnSCdz5QTrtDyB
 nZqcTGE2ajVvYRG2y0Dd77JPXseCSbG70m0FULyLXOUPaUoXNjcjjbP5HQ2l/K850F6Ae69A0kS
 mbcoBKVyE+6H9rugxWZBp2EQB27wL5E7FZMdv2ZmjO2ZjlU8RmjPIqhEW88sc7SSxWgAr02N40y
 VZRtuqutpp5721g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B637140003
X-Stat-Signature: 1o3sc6grq1zd4nxrpnmba58jr976oa48
X-Rspam-User: 
X-HE-Tag: 1773063756-236415
X-HE-Meta: U2FsdGVkX1+ZPIxdM5tUbEp2s4Otv7ZZnjnebGJP3PTeZv5UZblY33tTQcRKwCRl7bUxvxyvRrRVe/wW0V5ZzOD/wStxHht3m8dn0m/rwXSrzn73S5LKO/dcY4fb+KiEyWxX7FrEGI/uSrUdwlRRZNkCaRFPGR/cCGI47DQk4MfClNimAouv4plrPUFiEwch6F3BkOTgv6dp1oACS5IsArVb8aRNXDTFNSkeONVSFvnsQp24jQIzsjTDfKVyHrVlCjleR41LUg4ey/LIBdTadOnWb8WLS7ONfL6B8bjNVZPp7Hv+aovmdnRyfyta8j6af/OUnlg3l7Q/WB89xZimfjroiO97VTnAxyUJa0PjP7jrrwQMoZRLgiwqG1tmggWR0ysQTz7FH0YqVJSiJXKBW3xJn6y1mfHYSJwjiE04nb4Zoqesr76pDkemmkS1Xu3ZQ+HzNTHt3+Wjd7kpkVLfveWmlJfk5PXYxgZAFqMjS+QpK5EJJWsItgPkdc9oKkh4jbPolORFAKUUxhyEJxAm/1MTLl8ySlo4O6SC+OUa5tcGVhdA2JSwhTKq64KspAfouSuMpotFjZDqSPZfLgJPdLGwx2VMtXahUbGcLYZHoes6Y5khjQ5LrSQx/XkLhqf1mIY3xD0NHsua6nXO1JAnG4/6rEMp6qTkYnIv5jOOE4b9/6HZ8oBeDrP5ONiZahmYBSeblcCsPurVXByUF3UuuV8AUiLe96Y0Vcw1+9gS+FcyIniE3ucrqPWkepJp6p+GEj303M0JtzXch4/GSQB2fisPQ0bV/T4qJBxsqOJKiFrDYOFpP7z6KAYm7Z+SUkLXiuy0+aP8g4XVMdA+iHoKMW2reRLRJJjlliO4Vm9D38TJ63K3EqnzkSo7FDm1+vHH9cyef1rlj1dnZP2hyFQaoOCa5yhfmKPN6Tjj/ZcTce9CM7odzBJo//zfx4wCUKkcPpzLEgSOey/147B4prk
 uVUi77zW
 ARuIrakyvB0ICz/yHeq81ZCO8Hw+Ei7y6NeGn75RvDvgTgRFOu09r5keHEE9VZX21Xny7qA3PShUJG1rd5A443Ay1KJDP0GS74poisnKh5cCwVHe8vnxkUx1Swco829dFadRtUnaHS/KnNAGmG5bSrRS5IjYiF+eMSNva
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
 include/linux/kho/abi/kexec_handover.h | 20 ++++++++++++++++----
 kernel/liveupdate/kexec_handover.c     | 26 +++++++++++++++++++++-----
 kernel/liveupdate/luo_core.c           |  2 +-
 lib/test_kho.c                         |  2 +-
 mm/memblock.c                          |  2 +-
 6 files changed, 43 insertions(+), 14 deletions(-)

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
index 54fe59fe43acd..1f22705d5d246 100644
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
@@ -1336,12 +1343,21 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 	if (offset < 0)
 		return -ENOENT;
 
-	val = fdt_getprop(fdt, offset, KHO_FDT_SUB_TREE_PROP_NAME, &len);
+	val = fdt_getprop(fdt, offset, KHO_SUB_TREE_PROP_NAME, &len);
 	if (!val || len != sizeof(*val))
 		return -EINVAL;
 
 	*phys = (phys_addr_t)*val;
 
+	if (size) {
+		val = fdt_getprop(fdt, offset, KHO_SUB_TREE_SIZE_PROP_NAME,
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



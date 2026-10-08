Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC207CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472CB6B0096; Thu,  8 Oct 2026 05:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC2A6B0099; Thu,  8 Oct 2026 05:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2850C6B0096; Thu,  8 Oct 2026 05:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF3E16B0096
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:41:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24F18C04DF
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:41:35 +0000 (UTC)
X-FDA: 85298966550.13.5D81B33
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf09.hostedemail.com (Postfix) with ESMTP id 90D42140003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:41:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=eDi4i1wi;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf09.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791452493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcj4CJIKTlRP5Sqz8Cj1lm93y+NSog/f4qUrLurHSMQ=;
	b=tb+QI2w9WMswrX1T/IRWWK7cqzlkthNfV5QWlZrzWgncxmA+JnLl4gRRbGoSt6LyGkRjD3
	o+1wyYbkUlNrUeOIgKF7kuY8i8IZ6Z2PuLdQ6rODSl3nfMvLNsVN9VighqHOtLcHXHYtgw
	c1s7Qe+PndK+4Ays27pemVEJ/DcIkHk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=eDi4i1wi;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf09.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791452493;
	b=ysxqlTdrGJlJbUaIxjwTxKWtUo8rlEcQMI8D5eBbgRfiNIjgmlYN5vE9cqKbNpgtdFIb/t
	iZNNrR8letsWPM8Ts5VIcsIXyrdGli7ewu/pXE8R31njvwHUatOnZOSggE4XOsYbC9INnF
	OKU+Nj5otGjouTAuHkqLWsrpgS2jk0w=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261008094130euoutp01675500b1c5c8c1238d8040867f1c75f7~chIxzRJlg2286322863euoutp01V
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:41:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261008094130euoutp01675500b1c5c8c1238d8040867f1c75f7~chIxzRJlg2286322863euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791452490;
	bh=fcj4CJIKTlRP5Sqz8Cj1lm93y+NSog/f4qUrLurHSMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDi4i1wiaqlSZuvPdDEVLffyOOUZBCTxxOBgp3HcpnWv9yWuRXbJ7UplXtjzVKlEa
	 mCTSnhdTienlIz0svuyFQRHPRMpliZB6B+CECffmczaLHMnCM8Y+u5PslKQs0eRzLP
	 PqGrd+mf4iPaDfCVSw/SEY5lj9YmOPUjKx7aZRDQ=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea~chIxiyNzn0260802608eucas1p1A;
	Thu,  8 Oct 2026 09:41:30 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261008094129eusmtip24bf105f8ff4d5a7d2a5277c3e2437fa7~chIxDISsi0972409724eusmtip2F;
	Thu,  8 Oct 2026 09:41:29 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Mike Rapoport
	<rppt@kernel.org>, Rob Herring <robh@kernel.org>, Saravana Kannan
	<saravanak@kernel.org>, Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Wandun <chenwandun1@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2] of: reserved_mem: allocate and map the reserved_mem
 array early
Date: Thu,  8 Oct 2026 11:41:23 +0200
Message-ID: <20261008094125.3197971-3-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008094125.3197971-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea
X-EPHeader: CA
X-CMS-RootMailID: 20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea
References: <20261008094125.3197971-1-m.szyprowski@samsung.com>
	<CGME20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea@eucas1p1.samsung.com>
X-Stat-Signature: 75w7ygq3o8dq5kgt1xgr4qaj6bbkbujm
X-Rspam-User: 
X-Rspamd-Queue-Id: 90D42140003
X-Rspamd-Server: rspam08
X-HE-Tag: 1791452492-708128
X-HE-Meta: U2FsdGVkX19WfXKuPxe/NYbFX8kSkesw1utvwb04ZmredKwmZm3WInO/mHh2iJULjXh/6aUyoJFvRw/K25eOsqn93U9kuFkVAB3r+jJjk/1SDbQsLV+LIYT3tQGc6lmfBCZaRr5ZoqmVp46vaEmpeep4agTtkeLjnPwRoWYoPV5lgOQ00GIvz0GXvssrurj5WHG38ToCx50RykYfOZDB1y1ViHHiRtDvDYvf5Rxl0jqwsk8QB0+KSn5fZWPlPFUGq1GPW0Se8TL6abXu9Z7hoCzosgbx83XBcKQrDgZklsvDZ37IRBJenToD9eMe6irA5RIzJAjDsxrvSfeOjD5feVtfSUZLmwbHZshmF/jQiOTflwsF0vl2dGi8wCqdUdge9Wz4Hu9DL6G9vzju2QEreesAwh8U3MdajLwBN/JyPxsfHCefyleYGOlToRkl/AC2lWQdTUaByzo51wkdyemOz68SkCXPqnE0WMPaq6/mg1ROKVfVOPH50UdBE0e0SMfhXR0BrAJnpyZTGsMZAmBQKqZWAIuJmR2xJt0IaMAU2eTcRqRiKv2gMOPXu7bySVvfHYnz96I6ANdAOePCZwtTjQ9A0KflUUKTdWXXFFl0Rd5tOjUEgrebMII3Tdkb+8up+3WOYWgKKXLQLYlUXnfYU4qGRA/HpT1XjqEUy6KVe3JmtFqeV7wdTNFJu/xtVTOkE2na41KOKinvH3ZV6TqEDIZjCzaek+dv+5khs4w7e3vdaOzd/NXK7gAmVF74Oe9kyb9PvkzzvMttMgT/LmmvNRdi4amf632ayJB1qjEIfmZuQosekWe8oB4+naYZgxssMB+ZAA/bajlN7bcOevdus6DlFgEOzilWhmuaTnY7A5M35OfgDYp3a4sOyTw65rkxQ+av8zBG1ZbrLOBURcK9hv/TZASEYoxZtY40fKVw+idW9+40Uuib/9/UqRe396seZ/yavmt+MJ412cNY+KJ
 Q9/LLa/l
 YW1G9cX0GZkwXQZrYj93Zge43ksRQxY/TY4Tz5pw/2lTYq54mKX81CwyRYZboX3lN1RlZG+1MB8vtxK2zoAm7RscyUcND65OGzl47ew0nPyitNsmk/l/hHfMsiwkwrWRYcdtJKk/BA0Nidkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Get rid of the static, limited-size reserved_mem array and replace it
with array allocated by memblock_alloc_raw() and accessed through a
temporary early_memremap() mapping. Such mapping is needed for some
architectures (like ARM64), where linear map is not yet available during
early boot scan. Having a single, writeable array with all reserved
regions removes the need to perform two step initialization introduced
by commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
memory regions are processed"), so all regions can be processed
directly during the early scan again.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Link: https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
Assisted-By: Claude Opus 5.5 <noreply@anthropic.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/fdt.c             |   3 -
 drivers/of/of_private.h      |   2 -
 drivers/of/of_reserved_mem.c | 251 ++++++++++++++---------------------
 3 files changed, 96 insertions(+), 160 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index ecc923102622..a58efdcbac7f 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1283,9 +1283,6 @@ void __init unflatten_device_tree(void)
 {
 	void *fdt = initial_boot_params;
 
-	/* Save the statically-placed regions in the reserved_mem array */
-	fdt_scan_reserved_mem_late();
-
 	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
 		fdt = (void *) __dtb_empty_root_begin;
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index 0ae16da066e2..895f868b4cfa 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -9,7 +9,6 @@
  */
 
 #define FDT_ALIGN_SIZE 8
-#define MAX_RESERVED_REGIONS    64
 
 /**
  * struct alias_prop - Alias property in 'aliases' node
@@ -186,7 +185,6 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 #endif
 
 int fdt_scan_reserved_mem(void);
-void __init fdt_scan_reserved_mem_late(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 300fb236ab59..6a5e53243bb7 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -24,12 +24,14 @@
 #include <linux/slab.h>
 #include <linux/memblock.h>
 #include <linux/kmemleak.h>
+#ifdef CONFIG_GENERIC_EARLY_IOREMAP
+#include <asm/early_ioremap.h>
+#endif
 
 #include "of_private.h"
 
-static struct reserved_mem reserved_mem_array[MAX_RESERVED_REGIONS] __initdata;
-static struct reserved_mem *reserved_mem __refdata = reserved_mem_array;
-static int total_reserved_mem_cnt = MAX_RESERVED_REGIONS;
+static struct reserved_mem *reserved_mem __refdata;
+static int total_reserved_mem_cnt;
 static int reserved_mem_count;
 
 static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
@@ -59,56 +61,48 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 }
 
 /*
- * alloc_reserved_mem_array() - allocate memory for the reserved_mem
- * array using memblock
+ * reserved_mem_array_map() - make the freshly allocated reserved_mem array
+ * accessible during early boot
  *
- * This function is used to allocate memory for the reserved_mem
- * array according to the total number of reserved memory regions
- * defined in the DT.
- * After the new array is allocated, the information stored in
- * the initial static array is copied over to this new array and
- * the new array is used from this point on.
+ * On some architectures (i.e. arm64) the linear mapping is not yet usable when
+ * the reserved memory regions are scanned, so the array has to be accessed
+ * through a temporary early mapping.
  */
-static int __init alloc_reserved_mem_array(void)
+static struct reserved_mem * __init reserved_mem_array_map(struct reserved_mem *array,
+							   size_t size)
 {
-	struct reserved_mem *new_array;
-	size_t alloc_size, copy_size, memset_size;
-	int ret;
+#ifdef CONFIG_GENERIC_EARLY_IOREMAP
+	return early_memremap(__pa(array), size);
+#else
+	return array;
+#endif
+}
 
-	if (!total_reserved_mem_cnt)
-		return 0;
+static void __init reserved_mem_array_unmap(struct reserved_mem *map, size_t size)
+{
+#ifdef CONFIG_GENERIC_EARLY_IOREMAP
+	early_memunmap(map, size);
+#endif
+}
 
-	alloc_size = array_size(total_reserved_mem_cnt, sizeof(*new_array));
-	if (alloc_size == SIZE_MAX) {
-		ret = -EOVERFLOW;
-		goto fail;
-	}
+/*
+ * count_reserved_mem_nodes() - count the nodes that might need an entry in the
+ * reserved_mem array
+ */
+static int __init count_reserved_mem_nodes(const void *fdt, int node)
+{
+	int child, len, count = 0;
 
-	new_array = memblock_alloc(alloc_size, SMP_CACHE_BYTES);
-	if (!new_array) {
-		ret = -ENOMEM;
-		goto fail;
-	}
+	fdt_for_each_subnode(child, fdt, node) {
+		if (!of_fdt_device_is_available(fdt, child))
+			continue;
 
-	copy_size = array_size(reserved_mem_count, sizeof(*new_array));
-	if (copy_size == SIZE_MAX) {
-		memblock_free(new_array, alloc_size);
-		ret = -EOVERFLOW;
-		goto fail;
+		/* static regions use 'reg', dynamic ones use 'size' */
+		if ((of_flat_dt_get_addr_size_prop(child, "reg", &len) && len) ||
+		    (of_get_flat_dt_prop(child, "size", &len) && len))
+			count++;
 	}
-
-	memset_size = alloc_size - copy_size;
-
-	memcpy(new_array, reserved_mem, copy_size);
-	memset(new_array + reserved_mem_count, 0, memset_size);
-
-	reserved_mem = new_array;
-	return 0;
-
-fail:
-	pr_err("Failed to allocate memory for reserved_mem array with err: %d", ret);
-	reserved_mem_count = 0;
-	return ret;
+	return count;
 }
 
 static void fdt_init_reserved_mem_node(unsigned long node, const char *uname,
@@ -169,6 +163,7 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 
 	if (size && early_init_dt_reserve_memory(base, size, nomap) == 0) {
 		fdt_fixup_reserved_mem_node(node, base, size);
+		fdt_init_reserved_mem_node(node, uname, base, size);
 		pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 			 uname, &base, (unsigned long)(size / SZ_1M));
 	} else {
@@ -381,143 +376,89 @@ static void __init __rmem_check_for_overlap(void)
 	}
 }
 
-/**
- * fdt_scan_reserved_mem_late() - Scan FDT and initialize remaining reserved
- * memory regions.
- *
- * This function is used to scan again through the DT and initialize the
- * "static" reserved memory regions, that are defined using the "reg"
- * property. Each such region is then initialized with its specific init
- * function and stored in the global reserved_mem array.
- */
-void __init fdt_scan_reserved_mem_late(void)
-{
-	const void *fdt = initial_boot_params;
-	phys_addr_t base, size;
-	int node, child;
-
-	if (!fdt)
-		return;
-
-	node = fdt_path_offset(fdt, "/reserved-memory");
-	if (node < 0) {
-		pr_info("Reserved memory: No reserved-memory node in the DT\n");
-		return;
-	}
-
-	/* Attempt dynamic allocation of a new reserved_mem array */
-	if (alloc_reserved_mem_array())
-		return;
-
-	if (__reserved_mem_check_root(node)) {
-		pr_err("Reserved memory: unsupported node format, ignoring\n");
-		return;
-	}
-
-	fdt_for_each_subnode(child, fdt, node) {
-		const __be32 *prop;
-		const char *uname;
-		u64 b, s;
-		int ret;
-		int len;
-
-		if (!of_fdt_device_is_available(fdt, child))
-			continue;
-
-		prop = of_flat_dt_get_addr_size_prop(child, "reg", &len);
-		if (!prop || !len)
-			continue;
-
-		ret = fdt_validate_reserved_mem_node(child, NULL);
-		if (ret && ret != -ENODEV)
-			continue;
-
-		of_flat_dt_read_addr_size(prop, 0, &b, &s);
-		base = b;
-		size = s;
-
-		if (size) {
-			uname = fdt_get_name(fdt, child, NULL);
-			fdt_init_reserved_mem_node(child, uname, base, size);
-		}
-	}
-
-	/* check for overlapping reserved regions */
-	__rmem_check_for_overlap();
-}
 
 /*
  * fdt_scan_reserved_mem() - reserve and allocate memory occupied by
  * reserved memory regions.
  *
- * This function is used to scan through the FDT and mark memory occupied
- * by all static (defined by the "reg" property) reserved memory regions.
- * Then memory for all dynamic regions (defined by size & alignment) is
- * allocated, a region specific init function is called and region information
- * is stored in the reserved_mem array.
+ * This function is used to scan through the FDT and count the number of
+ * reserved memory regions, so the reserved_mem array can be allocated with
+ * the exact size. Then all static (defined by the "reg" property) reserved
+ * memory regions are marked as reserved, memory for all dynamic regions
+ * (defined by size & alignment) is allocated, a region specific init function
+ * is called and region information is stored in the reserved_mem array.
  */
 int __init fdt_scan_reserved_mem(void)
 {
-	int node, child;
-	int dynamic_nodes_cnt = 0, count = 0;
-	int dynamic_nodes[MAX_RESERVED_REGIONS];
+	struct reserved_mem *array, *map;
+	size_t array_bytes;
+	int node, child, cnt;
 	const void *fdt = initial_boot_params;
 
 	node = fdt_path_offset(fdt, "/reserved-memory");
-	if (node < 0) {
-		total_reserved_mem_cnt = 0;
+	if (node < 0)
 		return -ENODEV;
-	}
 
 	if (__reserved_mem_check_root(node) != 0) {
 		pr_err("Reserved memory: unsupported node format, ignoring\n");
-		total_reserved_mem_cnt = 0;
 		return -EINVAL;
 	}
 
-	fdt_for_each_subnode(child, fdt, node) {
-		const char *uname;
-		int err;
+	/* First pass: count the entries needed for the reserved_mem array */
+	cnt = count_reserved_mem_nodes(fdt, node);
+	if (!cnt)
+		return 0;
 
-		if (!of_fdt_device_is_available(fdt, child))
-			continue;
+	array_bytes = array_size(cnt, sizeof(*array));
+	array = memblock_alloc_raw(array_bytes, SMP_CACHE_BYTES);
+	if (!array) {
+		pr_err("Failed to allocate memory for reserved_mem array\n");
+		return -ENOMEM;
+	}
 
-		uname = fdt_get_name(fdt, child, NULL);
+	map = reserved_mem_array_map(array, array_bytes);
+	if (!map) {
+		pr_err("Failed to map memory for reserved_mem array\n");
+		memblock_free(array, array_bytes);
+		return -ENOMEM;
+	}
+	memset(map, 0, array_bytes);
 
-		err = __reserved_mem_reserve_reg(child, uname);
-		if (!err)
-			count++;
+	reserved_mem = map;
+	total_reserved_mem_cnt = cnt;
 
-		/*
-		 * Save the nodes for the dynamically-placed regions
-		 * into an array which will be used for allocation right
-		 * after all the statically-placed regions are reserved
-		 * or marked as no-map. This is done to avoid dynamically
-		 * allocating from one of the statically-placed regions.
-		 */
-		if (err != -ENOENT || !of_get_flat_dt_prop(child, "size", NULL))
+	/* Second pass: reserve and initialize the static regions */
+	fdt_for_each_subnode(child, fdt, node) {
+		if (!of_fdt_device_is_available(fdt, child))
 			continue;
 
-		if (dynamic_nodes_cnt == MAX_RESERVED_REGIONS) {
-			pr_err("too many defined dynamic regions, skip '%s'\n",
-			       uname);
+		__reserved_mem_reserve_reg(child,
+					   fdt_get_name(fdt, child, NULL));
+	}
+
+	/*
+	 * Allocate the dynamically-placed regions only after all the
+	 * statically-placed regions are reserved or marked as no-map. This
+	 * is done to avoid dynamically allocating from one of the
+	 * statically-placed regions.
+	 */
+	fdt_for_each_subnode(child, fdt, node) {
+		int len;
+
+		if (!of_fdt_device_is_available(fdt, child) ||
+		    (of_flat_dt_get_addr_size_prop(child, "reg", &len) && len))
 			continue;
-		}
 
-		dynamic_nodes[dynamic_nodes_cnt] = child;
-		dynamic_nodes_cnt++;
-	}
-	for (int i = 0; i < dynamic_nodes_cnt; i++) {
-		const char *uname;
-		int err;
-
-		child = dynamic_nodes[i];
-		uname = fdt_get_name(fdt, child, NULL);
-		err = __reserved_mem_alloc_size(child, uname);
-		if (!err)
-			count++;
+		__reserved_mem_alloc_size(child,
+					  fdt_get_name(fdt, child, NULL));
 	}
-	total_reserved_mem_cnt = count;
+
+	/* check for overlapping reserved regions */
+	__rmem_check_for_overlap();
+
+	/* Switch to the permanent address of the array */
+	reserved_mem_array_unmap(map, array_bytes);
+	reserved_mem = array;
 	return 0;
 }
 
-- 
2.43.0



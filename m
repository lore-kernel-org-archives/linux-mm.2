Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FA9CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F606B0099; Thu, 15 Oct 2026 04:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156B86B009B; Thu, 15 Oct 2026 04:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06DC06B009D; Thu, 15 Oct 2026 04:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D19936B0099
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:33:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5B121208C9
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:23:38 +0000 (UTC)
X-FDA: 85324171716.23.7A9C193
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 34194180003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:23:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=nBwA+4VB;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792052616;
	b=h3Ow1VhDw5nQlBRY6/3j1h34aA6aJt/roP1Pa5zp0a/SfhQeqaLjJQ1Q+5QY+4eufM8OGy
	SwEm6GtjmOxexu15g9oj3BLusG2dQMXuekdzu/tsXS3ei7Apz9gqFJ7D1a8hs3lvDYvJAX
	AjUPSwv5hR7wDZOjq/8uRTmlqq0245Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=nBwA+4VB;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792052616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh/D/XtcwOEb2lFDL9N6ZsPr2jYj9OKQH3ofJmvD4TU=;
	b=keynQWXotaVwNp+fYYZ5cvZ+GE9c1V7Z0NYDLXui/z9P9EgyiYP39vG9eXDIW5vYWeqNJX
	BMq6c2EHN67zUMvTg90EQLWGdP/THgXodzlIZ7opcRau4zbsyo6Fnva8OMdT5UQXoiDUII
	oIroPasjzqumARRSI8zkggFAzn8OBAo=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261015082334euoutp01dd1bb36225772415732627f3e8a8e93e~epluafP5E2870428704euoutp01N
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:23:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261015082334euoutp01dd1bb36225772415732627f3e8a8e93e~epluafP5E2870428704euoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1792052614;
	bh=Gh/D/XtcwOEb2lFDL9N6ZsPr2jYj9OKQH3ofJmvD4TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nBwA+4VBNlqht3W7Uv7e4a2QVZK+BlFrK7RaSUB90vC9htPGAQtKCZkTQlluiBHCm
	 lorjGt5gSW0n5YICOzgekvcvh+a09cOsdEwVl+7qfLR4YS5V+FNxYsC4FYv+G4F1eM
	 B6P9jeSz5koPGw43GLX8VSbburQaVld1d4f8eDe0=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261015082333eucas1p2ab2904e28a33bf2c74f5c7c9befeedb8~epluPDN1C0970309703eucas1p2O;
	Thu, 15 Oct 2026 08:23:33 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20261015082333eusmtip18d052a9d331f85b470d76937f1ac5dca~epltvk0jh0067000670eusmtip1j;
	Thu, 15 Oct 2026 08:23:33 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Mike Rapoport
	<rppt@kernel.org>, Rob Herring <robh@kernel.org>, Saravana Kannan
	<saravanak@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 1/2] of: reserved_mem: group allocation helpers together
Date: Thu, 15 Oct 2026 10:23:11 +0200
Message-ID: <20261015082315.56876-2-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015082315.56876-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261015082333eucas1p2ab2904e28a33bf2c74f5c7c9befeedb8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261015082333eucas1p2ab2904e28a33bf2c74f5c7c9befeedb8
X-EPHeader: CA
X-CMS-RootMailID: 20261015082333eucas1p2ab2904e28a33bf2c74f5c7c9befeedb8
References: <20261015082315.56876-1-m.szyprowski@samsung.com>
	<CGME20261015082333eucas1p2ab2904e28a33bf2c74f5c7c9befeedb8@eucas1p2.samsung.com>
X-Stat-Signature: mhis3y58ckgt8fux4ireqkwh1duen7xx
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 34194180003
X-HE-Tag: 1792052616-632333
X-HE-Meta: U2FsdGVkX18LtT7DwpqAKC0KmkzKlvki9d9p+mm/mu4c4f2F/h7XDs/PmXwy2T8ECXOmlYG/Y41cdRBxZcd8Ezde4h8yuKD2m3ETrkGqXDxo/evUMROEjol7lHZwuftSNnRz55mqS730IVcDqtUhSZtn+5BSkPDdCV7wio88vzqiVRslJE7236WVT5LF+KV2hBf+FHQkozrMDzAMDD5/90XFHGjU++fY53QG6Ja/sd1DVOP5/7NOoIQ9oa5lWdCryptgNCGE3vIpaHALQxLaKLkUE9h8lDn16yas+xTGAc0xmGKSI8Hapb7bdh+qOLd5k8wWWEW9UDKu9vMZnFFEEUWYBPl+lwq2ZtH0PvlgAVLFz2+im6ODUjqxqd6IsEgo4hPQb6oVLxjGL+dTPk03m/WlxY9oH0YGdual6IiP9Zxme/GWDV7uJmvL75usDEBkRUPPrZWwSUrBQ8EtUkvZV62TZ42cfbHFJkG1enMD0uW4MkYHU3dyrA0d3yrvD0ehUER2jkLNo7GwU+eL15CqcTVXe537lvVK+5qR7LRAAwMMJhRvZCWi7ik1dCRecDdeH+Fq001XgEyz83xCmfGND6FTS/B5cMOZMmWrDuIYAgb/BYgOTSleUk+WDPhq/bTxXX1YTAefTKqDLb2epEWxNyI6QFEBZA7cRjfAH65UnfoXOFzwUu0yTt/LwjoCaxz4G2Pt9I5CXAUEZoKy9gtZAgIvx1sItgMWmw9lPDe/UIq/gfFJPS8+NC8e1gMFbVq7RJ06/oKiVqn919igOjOz2KM1sdu8hZ8pD1Q/pTzKl81XnwKchSheDioNAFn4QCUvI4YjeMqi8MD/2wX7YljLxM8M292ONyeC1ptr9OOD25fcEo9csUW6gzi5ucsqEWnPAXgJ6GAy4AXTxcrAuHabiyjecUicbdloK+bAz5sY6PACFMjRbyxizoTw3UVSsqCG71mpBiB3jN/KXqW64Wt
 4SHtU6cg
 WdlRpHyYWp7JqaAdZAP/oJIjd6D+i5BLcmlfhqb3BPhEYkADvFGi4dWSMLZ5gM9H+Dj4DEpqwa45BH/tNJ3hFjzVX4qNTkZT6N6YF5pJCCsEXo6vefBnR8jCIRZy01CU7zHTaY0tIoTaXYEFPd9dt8bJsKMVFEdYIWjSbEU09BZ66gqZH1GDuO/t/Sv1hIa6DkU3bCBWV7dIKQg+h2ysAkaoC3iSLzIP4eiK63vi9Ey76rSJk2dxvrUXho/qWMzNxMzBN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move __reserved_mem_alloc_in_range() and __reserved_mem_alloc_size() right
after __reserved_mem_reserve_reg(), so the functions that reserve reserved
regions are grouped together and defined before their use.

No functional change.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 262 +++++++++++++++++------------------
 1 file changed, 130 insertions(+), 132 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 8c9d6395d6a3..300fb236ab59 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -178,6 +178,136 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 	return 0;
 }
 
+/*
+ * __reserved_mem_alloc_in_range() - allocate reserved memory described with
+ *	'alloc-ranges'. Choose bottom-up/top-down depending on nearby existing
+ *	reserved regions to keep the reserved memory contiguous if possible.
+ */
+static int __init __reserved_mem_alloc_in_range(phys_addr_t size,
+	phys_addr_t align, phys_addr_t start, phys_addr_t end, bool nomap,
+	phys_addr_t *res_base)
+{
+	bool prev_bottom_up = memblock_bottom_up();
+	bool bottom_up = false, top_down = false;
+	int ret, i;
+
+	for (i = 0; i < reserved_mem_count; i++) {
+		struct reserved_mem *rmem = &reserved_mem[i];
+
+		/* Skip regions that were not reserved yet */
+		if (rmem->size == 0)
+			continue;
+
+		/*
+		 * If range starts next to an existing reservation, use bottom-up:
+		 *	|....RRRR................RRRRRRRR..............|
+		 *	       --RRRR------
+		 */
+		if (start >= rmem->base && start <= (rmem->base + rmem->size))
+			bottom_up = true;
+
+		/*
+		 * If range ends next to an existing reservation, use top-down:
+		 *	|....RRRR................RRRRRRRR..............|
+		 *	              -------RRRR-----
+		 */
+		if (end >= rmem->base && end <= (rmem->base + rmem->size))
+			top_down = true;
+	}
+
+	/* Change setting only if either bottom-up or top-down was selected */
+	if (bottom_up != top_down)
+		memblock_set_bottom_up(bottom_up);
+
+	ret = early_init_dt_alloc_reserved_memory_arch(size, align,
+			start, end, nomap, res_base);
+
+	/* Restore old setting if needed */
+	if (bottom_up != top_down)
+		memblock_set_bottom_up(prev_bottom_up);
+
+	return ret;
+}
+
+/*
+ * __reserved_mem_alloc_size() - allocate reserved memory described by
+ *	'size', 'alignment'  and 'alloc-ranges' properties.
+ */
+static int __init __reserved_mem_alloc_size(unsigned long node, const char *uname)
+{
+	phys_addr_t start = 0, end = 0;
+	phys_addr_t base = 0, align = 0, size;
+	int i, len;
+	const __be32 *prop;
+	bool nomap;
+	int ret;
+
+	prop = of_get_flat_dt_prop(node, "size", &len);
+	if (!prop)
+		return -EINVAL;
+
+	if (len != dt_root_size_cells * sizeof(__be32)) {
+		pr_err("invalid size property in '%s' node.\n", uname);
+		return -EINVAL;
+	}
+	size = dt_mem_next_cell(dt_root_size_cells, &prop);
+
+	prop = of_get_flat_dt_prop(node, "alignment", &len);
+	if (prop) {
+		if (len != dt_root_addr_cells * sizeof(__be32)) {
+			pr_err("invalid alignment property in '%s' node.\n",
+				uname);
+			return -EINVAL;
+		}
+		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
+	}
+
+	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
+
+	ret = fdt_validate_reserved_mem_node(node, &align);
+	if (ret && ret != -ENODEV)
+		return ret;
+
+	prop = of_flat_dt_get_addr_size_prop(node, "alloc-ranges", &len);
+	if (prop) {
+		for (i = 0; i < len; i++) {
+			u64 b, s;
+
+			of_flat_dt_read_addr_size(prop, i, &b, &s);
+
+			start = b;
+			end = b + s;
+
+			base = 0;
+			ret = __reserved_mem_alloc_in_range(size, align,
+					start, end, nomap, &base);
+			if (ret == 0) {
+				pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
+					uname, &base,
+					(unsigned long)(size / SZ_1M));
+				break;
+			}
+		}
+	} else {
+		ret = early_init_dt_alloc_reserved_memory_arch(size, align,
+							0, 0, nomap, &base);
+		if (ret == 0)
+			pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
+				uname, &base, (unsigned long)(size / SZ_1M));
+	}
+
+	if (base == 0) {
+		pr_err("failed to allocate memory for node '%s': size %lu MiB\n",
+		       uname, (unsigned long)(size / SZ_1M));
+		return -ENOMEM;
+	}
+
+	fdt_fixup_reserved_mem_node(node, base, size);
+	fdt_init_reserved_mem_node(node, uname, base, size);
+
+	return 0;
+}
+
 /*
  * __reserved_mem_check_root() - check if #size-cells, #address-cells provided
  * in /reserved-memory matches the values supported by the current implementation,
@@ -316,8 +446,6 @@ void __init fdt_scan_reserved_mem_late(void)
 	__rmem_check_for_overlap();
 }
 
-static int __init __reserved_mem_alloc_size(unsigned long node, const char *uname);
-
 /*
  * fdt_scan_reserved_mem() - reserve and allocate memory occupied by
  * reserved memory regions.
@@ -393,136 +521,6 @@ int __init fdt_scan_reserved_mem(void)
 	return 0;
 }
 
-/*
- * __reserved_mem_alloc_in_range() - allocate reserved memory described with
- *	'alloc-ranges'. Choose bottom-up/top-down depending on nearby existing
- *	reserved regions to keep the reserved memory contiguous if possible.
- */
-static int __init __reserved_mem_alloc_in_range(phys_addr_t size,
-	phys_addr_t align, phys_addr_t start, phys_addr_t end, bool nomap,
-	phys_addr_t *res_base)
-{
-	bool prev_bottom_up = memblock_bottom_up();
-	bool bottom_up = false, top_down = false;
-	int ret, i;
-
-	for (i = 0; i < reserved_mem_count; i++) {
-		struct reserved_mem *rmem = &reserved_mem[i];
-
-		/* Skip regions that were not reserved yet */
-		if (rmem->size == 0)
-			continue;
-
-		/*
-		 * If range starts next to an existing reservation, use bottom-up:
-		 *	|....RRRR................RRRRRRRR..............|
-		 *	       --RRRR------
-		 */
-		if (start >= rmem->base && start <= (rmem->base + rmem->size))
-			bottom_up = true;
-
-		/*
-		 * If range ends next to an existing reservation, use top-down:
-		 *	|....RRRR................RRRRRRRR..............|
-		 *	              -------RRRR-----
-		 */
-		if (end >= rmem->base && end <= (rmem->base + rmem->size))
-			top_down = true;
-	}
-
-	/* Change setting only if either bottom-up or top-down was selected */
-	if (bottom_up != top_down)
-		memblock_set_bottom_up(bottom_up);
-
-	ret = early_init_dt_alloc_reserved_memory_arch(size, align,
-			start, end, nomap, res_base);
-
-	/* Restore old setting if needed */
-	if (bottom_up != top_down)
-		memblock_set_bottom_up(prev_bottom_up);
-
-	return ret;
-}
-
-/*
- * __reserved_mem_alloc_size() - allocate reserved memory described by
- *	'size', 'alignment'  and 'alloc-ranges' properties.
- */
-static int __init __reserved_mem_alloc_size(unsigned long node, const char *uname)
-{
-	phys_addr_t start = 0, end = 0;
-	phys_addr_t base = 0, align = 0, size;
-	int i, len;
-	const __be32 *prop;
-	bool nomap;
-	int ret;
-
-	prop = of_get_flat_dt_prop(node, "size", &len);
-	if (!prop)
-		return -EINVAL;
-
-	if (len != dt_root_size_cells * sizeof(__be32)) {
-		pr_err("invalid size property in '%s' node.\n", uname);
-		return -EINVAL;
-	}
-	size = dt_mem_next_cell(dt_root_size_cells, &prop);
-
-	prop = of_get_flat_dt_prop(node, "alignment", &len);
-	if (prop) {
-		if (len != dt_root_addr_cells * sizeof(__be32)) {
-			pr_err("invalid alignment property in '%s' node.\n",
-				uname);
-			return -EINVAL;
-		}
-		align = dt_mem_next_cell(dt_root_addr_cells, &prop);
-	}
-
-	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
-
-	ret = fdt_validate_reserved_mem_node(node, &align);
-	if (ret && ret != -ENODEV)
-		return ret;
-
-	prop = of_flat_dt_get_addr_size_prop(node, "alloc-ranges", &len);
-	if (prop) {
-		for (i = 0; i < len; i++) {
-			u64 b, s;
-
-			of_flat_dt_read_addr_size(prop, i, &b, &s);
-
-			start = b;
-			end = b + s;
-
-			base = 0;
-			ret = __reserved_mem_alloc_in_range(size, align,
-					start, end, nomap, &base);
-			if (ret == 0) {
-				pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
-					uname, &base,
-					(unsigned long)(size / SZ_1M));
-				break;
-			}
-		}
-	} else {
-		ret = early_init_dt_alloc_reserved_memory_arch(size, align,
-							0, 0, nomap, &base);
-		if (ret == 0)
-			pr_debug("allocated memory for '%s' node: base %pa, size %lu MiB\n",
-				uname, &base, (unsigned long)(size / SZ_1M));
-	}
-
-	if (base == 0) {
-		pr_err("failed to allocate memory for node '%s': size %lu MiB\n",
-		       uname, (unsigned long)(size / SZ_1M));
-		return -ENOMEM;
-	}
-
-	fdt_fixup_reserved_mem_node(node, base, size);
-	fdt_init_reserved_mem_node(node, uname, base, size);
-
-	return 0;
-}
-
 extern const struct of_device_id __reservedmem_of_table[];
 static const struct of_device_id __rmem_of_table_sentinel
 	__used __section("__reservedmem_of_table_end");
-- 
2.43.0



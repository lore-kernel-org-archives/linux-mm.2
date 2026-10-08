Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B67ECA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A3F6B0098; Thu,  8 Oct 2026 11:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2A8F6B0099; Thu,  8 Oct 2026 11:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39276B009B; Thu,  8 Oct 2026 11:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE086B0098
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:24:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 098951A02CA
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:24:55 +0000 (UTC)
X-FDA: 85299831750.21.3378D17
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7A7A74000A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:24:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ZNXTK+bR;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791473093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh/D/XtcwOEb2lFDL9N6ZsPr2jYj9OKQH3ofJmvD4TU=;
	b=KIXa/hVH1oRsTs2yYe4T+huwniwDUV0aHwl/CmdH1Rp/ZTijMGEMc+ojORr5PB6co8BEML
	71gCw9pxWLGm83I67pqT8IDZLI4C1ySt6bw/ygBXVLoxqRk4Kuc8hvioWL/MTRdBVhBKWX
	yg0WbMpSFRYIgsb4mNoGLNvJlQkno4M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ZNXTK+bR;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791473093;
	b=pHnnwvCltqdx3oMUMAAkLGvLHIx0pMSBiQ474nofwU49KcwJiyYW/StvHEM1iC6JMiUufL
	SnOG7iwis2fC8HvP/rbioQ52vu4VGV2Wtvdsxxe7PY7loEm6RICcx8TeiEfJ8eEPLtdpHq
	Iv2SaI6XUlhncmfQVb1rBayme0CoJhs=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261008152450euoutp0259ca8691c6c60f68e8fa4766372ac1aa~cl0i49xbq1875218752euoutp02d
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:24:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261008152450euoutp0259ca8691c6c60f68e8fa4766372ac1aa~cl0i49xbq1875218752euoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791473090;
	bh=Gh/D/XtcwOEb2lFDL9N6ZsPr2jYj9OKQH3ofJmvD4TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNXTK+bRDcZNuRp1ruLh3T4PBJHlWGtDymBQuqsK3zV6pvYSi7J36IvRwkVgMv90n
	 LopUGvCj0+RBBACYDeMVrd7zboRBY4MSevTelXlttXvH/rYmJKaodfZIZMHYNHmK10
	 pPc8IVI/itQ/PunsLWL+MICIZirlVN+xdwrN+aLg=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261008152450eucas1p18776bd3641d591541c75f768295d79a8~cl0ilV80a2326223262eucas1p1O;
	Thu,  8 Oct 2026 15:24:50 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261008152449eusmtip2120622daeef91ba8bdebdc3053f62f4e~cl0iGxbNk0398803988eusmtip2D;
	Thu,  8 Oct 2026 15:24:49 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Mike Rapoport
	<rppt@kernel.org>, Rob Herring <robh@kernel.org>, Saravana Kannan
	<saravanak@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 1/2] of: reserved_mem: group allocation helpers together
Date: Thu,  8 Oct 2026 17:24:00 +0200
Message-ID: <20261008152403.766439-2-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008152403.766439-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261008152450eucas1p18776bd3641d591541c75f768295d79a8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261008152450eucas1p18776bd3641d591541c75f768295d79a8
X-EPHeader: CA
X-CMS-RootMailID: 20261008152450eucas1p18776bd3641d591541c75f768295d79a8
References: <20261008152403.766439-1-m.szyprowski@samsung.com>
	<CGME20261008152450eucas1p18776bd3641d591541c75f768295d79a8@eucas1p1.samsung.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7A7A74000A
X-Rspam-User: 
X-Stat-Signature: 9dkee75zphzfppm18kxjpsmh3e8yzfrr
X-HE-Tag: 1791473092-54766
X-HE-Meta: U2FsdGVkX1/DMdNqYyIWbPdGpTlpP53VHaQ3qRsnRO9g9xgKPbgppzVfHEVWhi+PW4JggprtVvvNedBzKvmnoVk5uadTm2Caqk2be+49aRJ6wQ0u2f6Rd/jag068DmrKNh2NkF1YEoJBTbfd7Oo8L9zWO5ywMwCwxkMoXgUw6myU7ipPwHpLZ17iPABHuQ6LWruP+dUypIanK/BbVVt6/LFWx5XOqkfqNK1cmWRyXCpnqBtiGM8gQICwu7tGEAd4wWcMJbe9DUa0aL5aiN+lPjMxzAQOsFay46MJaq3mqy0FopjVOGN5D1QVTTg1q6h5ml8P0nad6TACOsR8l5P4yle9lLRnqChMA3AC2XIRv41W0fAe2IhxUXh85UHbSVronVHDCnC9AMp7mAOs0MmM/Q1UtTce4XDrxeD3aH1AIyXTbTQsakjGDcIMhlOIUUHwmDHF3fecV+3qXjxicU+FcxL5IYuyvmtBIcXbq6LWm50T1KO6WzcNNBkq0HrnEl1zK0om3Oxcy74cfN2kE3N2bRZMMpmuhNhEzDWrr+6rKAIF/DM59NkBMvZTW8/zLQeXIHdoedaYVt7u5WddksefEjngGLFTTy052oOPLdC6wuX4NJbHoEc1CYFBxJYMmrBCRZSnK4H87kUo2K1cMlA5AMH4aucHKIFeSpj7ya0Nryw3E7nP3EonFrsEjtT/yefwJyiX/h+xA7Mvdqc94R/CqzU0Mao289I7tsOTif27S/WzU32J3HXqY3F6IW7vuQNDmWZOzypCtyknf45Nz4IDgvMLkBucHlu9U0rCFudvlnM05fQYl0dnnqduDHRW1/RBrufvd7tAr3MmEPwbkZXTj2vPwjXH+JIwk/9NenPNBPKXz2wOQLPIxLlUdlKYBlMhZUxC2u8L86+jmMtzRA9bZZH1QSSjlMfLs+MyH4spmJ73BeJWPhITWliFqGemPATRyE/m3LFMkAU+iv7lOXX
 SnWvGKXN
 pjXmBsEBXr/Co2pQNTZTIn1tIT0kDPJ4k73pUwsUYsqpAPdXGR4maUOXEd7NwUsB51gczbIkF2fuA4t/1LsvDND2Up87Gr5oq3j3MYiMhVxQrZ6ANMdm/vO/ibJ2agJzPjaJXd7OM7yBlZuSXnm9JomZ6ZyO3r5VM+ptFc5wlwRG9sjGmglX9JTKMEUvgLzYIjY7rL9mnGV59NcxWtKL1psJW7+UoiTrkz2uh6M41L03SdDjbG/DJwjRev6r5/8KSbttbHHJzUgJudTU=
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



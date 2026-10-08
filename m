Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 121ACCA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28BB6B0095; Thu,  8 Oct 2026 05:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD98E6B0096; Thu,  8 Oct 2026 05:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B72E6B0098; Thu,  8 Oct 2026 05:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41BFE6B0095
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:41:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8EDF4017B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:41:34 +0000 (UTC)
X-FDA: 85298966508.29.FD99E66
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf30.hostedemail.com (Postfix) with ESMTP id 40C7480006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:41:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=uk1cBAH6;
	spf=pass (imf30.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791452492;
	b=gHlNIVxYAR4wFUDvfMLv8kmZ3SnjUo+Y0rSjYcMSWo8ptq9ZhqGab2bUUvy5EsM9Q2XxTZ
	2g/B0K18vSdqzzRLvimnWBdefm2DddeM/qeJjRNCSDJRcYvAs03VKeITaBux0IS/seyoOE
	yuay+gLx3/S69RiTNe7Zl+bAE0YdYDY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=uk1cBAH6;
	spf=pass (imf30.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791452492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gh/D/XtcwOEb2lFDL9N6ZsPr2jYj9OKQH3ofJmvD4TU=;
	b=tU9Sz5VHdIM26curx+FXamM5PmDGQFaD0NgiioZZSOmuB7Nxq9fmA61Z+6QY6T0i0Vxc/3
	Oj9TUYqeoIK/ki972Bv6B4n4mvWtPxVZ08jWKL3cGzo9s311mkFpdeee4BP1Ew23/sCYg1
	9zY2A7E4cc8CbBH0avMJaGVFzFKV6g8=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261008094129euoutp02643e1b53a74780775cac0fe45c85fccf~chIxOYqwW2642326423euoutp02H
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:41:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261008094129euoutp02643e1b53a74780775cac0fe45c85fccf~chIxOYqwW2642326423euoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791452489;
	bh=Gh/D/XtcwOEb2lFDL9N6ZsPr2jYj9OKQH3ofJmvD4TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uk1cBAH6NjDLaNZNUt5pvyqiWwZNL8GO3Ou9+60tp7LcN+gRm3Yr3z1XUcb1ZR/wo
	 yzZvZpPRfQeB0c5EWfoTY4HGxz/9UnFgMdATpgebPO6qP4VLb4uqc0CmFZ5Ql5yOHW
	 LYGU/x+XWY+fiJnY15/MmOOat3Zncby1fDnb7kAA=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261008094129eucas1p1070329b8d0a61d3b7f0cafa9ccaced8c~chIw9yIWR1979819798eucas1p1u;
	Thu,  8 Oct 2026 09:41:29 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261008094129eusmtip25b23f369c0045728ed33f581406eff74~chIwe21NW1207512075eusmtip2K;
	Thu,  8 Oct 2026 09:41:29 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Mike Rapoport
	<rppt@kernel.org>, Rob Herring <robh@kernel.org>, Saravana Kannan
	<saravanak@kernel.org>, Oreoluwa Babatunde <quic_obabatun@quicinc.com>,
	Wandun <chenwandun1@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] of: reserved_mem: group allocation helpers together
Date: Thu,  8 Oct 2026 11:41:22 +0200
Message-ID: <20261008094125.3197971-2-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008094125.3197971-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261008094129eucas1p1070329b8d0a61d3b7f0cafa9ccaced8c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261008094129eucas1p1070329b8d0a61d3b7f0cafa9ccaced8c
X-EPHeader: CA
X-CMS-RootMailID: 20261008094129eucas1p1070329b8d0a61d3b7f0cafa9ccaced8c
References: <20261008094125.3197971-1-m.szyprowski@samsung.com>
	<CGME20261008094129eucas1p1070329b8d0a61d3b7f0cafa9ccaced8c@eucas1p1.samsung.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 40C7480006
X-Rspam-User: 
X-Stat-Signature: a58dszzkpkubntmby1uehibr63j33m5n
X-HE-Tag: 1791452492-238950
X-HE-Meta: U2FsdGVkX1/YzOGEJyexVOXawqs1h051Z2wHystNZ21YpnvGk/4SAvTtojSaibj/qzcDziBQEJc44ukJ/h2UPMlx54ryxaXVoSsoY1dlg/Z2OUbwjSYSTyEk/Nh4uEfTyTUiHPEd0bdKxOaPLKq9mysjlF2gnXrl6AJcWEWaG797Qfwxn9/kiYypuavGHekombuvmV61jJtFNNjopBSyaHjotpmXyo/1ZrbCjzefUqlxiXIS3D8OMfzxBDVrX/U2nF6fMzzNGKLgJxh1Vl/tkN028JNGoNRSw9nQ5HfAAUaqMHy8oreL4jp6FKj/44jJFDIbDVyCDnIKaKLpYs6Ur6l6/ejwhLOjM6siSPEvgL8lSszFsZjyW1/kJNOizfWcCVee6PMmv3J6WKgRXwLYCiu80ecDrexRRBWyiZr/Q04bjpZeAd+bKK71c3s6g/nK0kp+1B/oRBquAsRgtOKrFr8PX7GJZjg9oDK4Haf1Aa3+gnHRAHw8u+zjvvFpEFoXEKaut/8XXM5xJY0VeEoRCrzK2dDluyMvkjw5BdnEqDeeX1MKnfgjAZe4K9BmRj7Eb8ji/z+RKH9A+06ounfF4j2vXadn1O9PqJ2FFdPQUKvtDLLieIlfzcbbKSd5+LmAPuQh3bapQzg/fTJiBctf8wbsdK0AgehW+xC8MMoYEjKxA9u5pI4pZjJx0mGdNPfNoYAtlUFuOqcOZt76AbE+EYaMlfVWdmPRI1Byn9xEDDBvKbztYDqdHjBSkmTK6eQ+BGMmXWxBYCWZXaD5UbCFQmcR63xanG9hIEmPXC9LiaVjZO9as3U0U5qpENMyiw0Cjx3dkZlAzS4F75BjKIseKvbj6UnrK7cRfggaV5UHyGzsVRQ5TzOjuWsHMqQXpCCD7KPjPplojw/LafRv1EE+LADzUfdsIGkXIlACPO9LDGYt7aFeSDlAmaRWy1J3HzzQCzm8gUwZVJTzoGzcSnW
 edrDh/Br
 7BHMBe+ou1QCjRnc/Y+Bxev46qTFwB0/AkG+JG0bh7bXT5zbcbMfY+Hf5h4JF3QJHGhOqYQD/0a+v5LbX8dL5IwvImIdASnYJEFsSr7OR+/30X/yu7+S0GIKGvSP0S82xt5Z0c6kQFhUTp4Y=
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



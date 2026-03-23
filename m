Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C482EC01B1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3A46B0098; Mon, 23 Mar 2026 06:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A566B0099; Mon, 23 Mar 2026 06:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEF56B009B; Mon, 23 Mar 2026 06:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 270AC6B0098
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:09:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7C6D1A0AF6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:17 +0000 (UTC)
X-FDA: 84576905154.13.926AFDB
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf10.hostedemail.com (Postfix) with ESMTP id EA824C0008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=CKfa4HmP;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zbv558l0JXbA/evotEn7j2Yp5sFsNk7kEVzz156NoGI=;
	b=xIEIquOvSeS19FomxfyI+unqIqQ6vw66Bxmfn9d6sGC0lYy6XOZcomQXponZighuDawfUz
	gXJiunAfFMy0ipKiEx+ktljJ51sfHnWyEomv2624JFVRcJIL5HIS6qyLszbuek8nDpXHAZ
	UE9nsiBH1heALnGmc9Ee3sJrvRBxzZU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774260556; a=rsa-sha256;
	cv=none;
	b=RQoXSA0Kc6AeV1aUVOWgvD68hXgFkz5jai7vHwZykkxfvW+aOeK7FZDy24tzK5cIHWwIrh
	K8F8jZj13JXxH1DKhU1N9IAwI4YnFna/11lgFPSXREnxNFq0NwRJhDaVcv1K3C6/QFEC1T
	1enMvYuIzVAIePzSfCvnFRZMe+EOoyk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=CKfa4HmP;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf10.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260323100914euoutp020879d7d833e291904b54b6cc5c6d12ce~fcJLQxmxC2466124661euoutp02E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260323100914euoutp020879d7d833e291904b54b6cc5c6d12ce~fcJLQxmxC2466124661euoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774260554;
	bh=Zbv558l0JXbA/evotEn7j2Yp5sFsNk7kEVzz156NoGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKfa4HmPLdhrTKj9GAspBvrBdZaibIjlc7dUnoD561qJf5/RTtdU/sTy1rczsDI+R
	 Leqf8l2WKtGdnQCymPl7H89+cf2fGRfVc0Gmp3a0BMoo+7dWtguHdJUZNBPTcI/aLJ
	 tTYxSkfX/ofWAYEZFiLJlVPLmphBJ7jgJdRScHiY=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260323100912eucas1p1aadb718d2c0eea3404aa5be379ae21c1~fcJKGQmYG2578125781eucas1p1t;
	Mon, 23 Mar 2026 10:09:12 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260323100912eusmtip20108a44eb532b22a6560aefbc89b4f9a~fcJJjxuTO0899908999eusmtip2j;
	Mon, 23 Mar 2026 10:09:12 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 7/7] of: reserved_mem: rework
 fdt_init_reserved_mem_node()
Date: Mon, 23 Mar 2026 11:09:01 +0100
Message-Id: <20260323100901.4079171-8-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323100901.4079171-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260323100912eucas1p1aadb718d2c0eea3404aa5be379ae21c1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260323100912eucas1p1aadb718d2c0eea3404aa5be379ae21c1
X-EPHeader: CA
X-CMS-RootMailID: 20260323100912eucas1p1aadb718d2c0eea3404aa5be379ae21c1
References: <20260323100901.4079171-1-m.szyprowski@samsung.com>
	<CGME20260323100912eucas1p1aadb718d2c0eea3404aa5be379ae21c1@eucas1p1.samsung.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EA824C0008
X-Stat-Signature: cyf61hkwzipt1t7y6fznweypz81488hq
X-Rspam-User: 
X-HE-Tag: 1774260555-339767
X-HE-Meta: U2FsdGVkX1/zsN8+Vs9qnOUUvUehWjfEFIddLqV2jSgl5byT6WrEQdJgJS/JCRN8iucjUYBrWUhdPljFRl/wyQdwR6I5tz8XMo+9kbjCNez10HHHYDo7h5yrG9j3vPbGWiL3uvjvb8970qu56zWhOb4e0UvbdVReIfzMkFJM/inTjbtczCUKmvTpI4jXKiFeCy8o/YSBmktmD1pUyrFGSIb/U6MWOMonTul6JYF1LlYYaYkT9w0SQPAyZlDYFOZWnYQYjGq/lBu65RhzTZPxANwRTtR8ZAHpkjzs+FKTWzqPXxkqHM620I48Hx/n2oFwE2Q9rRlDA5dvur1GAXBgpp3beQtWZ/BOfAgW9tFH0FQUIfHuj6b/vUtA1K0O7AlgPCzJUYU8H56axvn5xnJLTEcKdz7SIOJ/0BP/vSI35es/hDGSOWoPWP1AisEU+z/dsBougx4RbizkBQ/gaG5ZfNRSPnId9k2redtDXADc5AW/7UyQM1ARA2sQ6+zZJi1v8upuwrAUupCZIWp3o6UMjo9bI7mLCQ3vkJ78ftODvVCYCyxTmr+r5zu7cIieH5Yo6TERlLRgR4AVo39Ovi2gHffWRNndvs8dSH3S2w++LBUE4VjrptOJsE9CIbiVtGHkZvpFJEu18laUvfPcdKhMH2W3U/prMa0exgQ3yCwnk1fbEopvXt9ldA9aQb+mripIilB/lYT5GACTcEM1iBoh5zCM1AuPCr44dlxjHT4hom8T/sSQIGwMzWeNl7sZbqQOh4RF11owwVCqVr+wdNTMcTnoZOKJA/WmOdVAIG2q29UiU9aD80VYxLeDvPd/gkxyJLhp+/5AK/hSEbGwOdOg/ocKp8CVE86e0oUPIuD4RJ5HoKwxUK7WuDZVyFG2YJcob7FoOnOPefpFzMd472nkxAaufLxdxst7+T1Rau7ek/BRO4Q5CMxj08LbsYPWMfyCfLmqCHO+2vY0jPdJTqI
 dbxPRAyI
 +2ImJImWYVH2HlpvKhU/rmzaYhwj7SS2Ev5y6+qPC25iYCFg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the content of fdt_reserved_mem_save_node() to
fdt_init_reserved_mem_node() function. Initialization is no longer
performed in two steps as it was initially, so fdt_reserved_mem_save_node()
name is a bit misleading and that function now performs full initialization
of the reserved memory region.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 60 ++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 801451d034fa..661116034692 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -102,36 +102,13 @@ static void __init alloc_reserved_mem_array(void)
 	reserved_mem = new_array;
 }
 
-static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
-					      unsigned long node);
+static void fdt_init_reserved_mem_node(unsigned long node, const char *uname,
+				       phys_addr_t base, phys_addr_t size);
 static int fdt_validate_reserved_mem_node(unsigned long node,
 					  phys_addr_t *align);
 static int fdt_fixup_reserved_mem_node(unsigned long node,
 				       phys_addr_t base, phys_addr_t size);
 
-/*
- * fdt_reserved_mem_save_node() - save fdt node for second pass initialization
- */
-static void __init fdt_reserved_mem_save_node(unsigned long node, const char *uname,
-					      phys_addr_t base, phys_addr_t size)
-{
-	struct reserved_mem *rmem = &reserved_mem[reserved_mem_count];
-
-	if (reserved_mem_count == total_reserved_mem_cnt) {
-		pr_err("not enough space for all defined regions.\n");
-		return;
-	}
-
-	rmem->name = uname;
-	rmem->base = base;
-	rmem->size = size;
-
-	/* Call the region specific initialization function */
-	fdt_init_reserved_mem_node(rmem, node);
-
-	reserved_mem_count++;
-}
-
 static int __init early_init_dt_reserve_memory(phys_addr_t base,
 					       phys_addr_t size, bool nomap)
 {
@@ -316,7 +293,7 @@ void __init fdt_scan_reserved_mem_late(void)
 
 		if (size) {
 			uname = fdt_get_name(fdt, child, NULL);
-			fdt_reserved_mem_save_node(child, uname, base, size);
+			fdt_init_reserved_mem_node(child, uname, base, size);
 		}
 	}
 
@@ -515,9 +492,8 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 	}
 
 	fdt_fixup_reserved_mem_node(node, base, size);
+	fdt_init_reserved_mem_node(node, uname, base, size);
 
-	/* Save region in the reserved_mem array */
-	fdt_reserved_mem_save_node(node, uname, base, size);
 	return 0;
 }
 
@@ -619,21 +595,34 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 	return ret;
 }
 
-
 /**
  * fdt_init_reserved_mem_node() - Initialize a reserved memory region
- * @rmem: reserved_mem struct of the memory region to be initialized.
  * @node: fdt node of the initialized region
+ * @uname: name of the reserved memory node
+ * @base: base address of the reserved memory region
+ * @size: size of the reserved memory region
  *
- * This function is used to call the region specific initialization
- * function for a reserved memory region.
+ * This function calls the region-specific initialization function for a
+ * reserved memory region and saves all region-specific data to the
+ * reserved_mem array to allow of_reserved_mem_lookup() to find it.
  */
-static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
-					      unsigned long node)
+static void __init fdt_init_reserved_mem_node(unsigned long node, const char *uname,
+					      phys_addr_t base, phys_addr_t size)
 {
 	int err = 0;
 	bool nomap;
 
+	struct reserved_mem *rmem = &reserved_mem[reserved_mem_count];
+
+	if (reserved_mem_count == total_reserved_mem_cnt) {
+		pr_err("not enough space for all defined regions.\n");
+		return;
+	}
+
+	rmem->name = uname;
+	rmem->base = base;
+	rmem->size = size;
+
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
 
 	err = __reserved_mem_init_node(rmem, node);
@@ -643,6 +632,7 @@ static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
 			memblock_clear_nomap(rmem->base, rmem->size);
 		else
 			memblock_phys_free(rmem->base, rmem->size);
+		return;
 	} else {
 		phys_addr_t end = rmem->base + rmem->size - 1;
 		bool reusable =
@@ -654,6 +644,8 @@ static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
 			reusable ? "reusable" : "non-reusable",
 			rmem->name ? rmem->name : "unknown");
 	}
+
+	reserved_mem_count++;
 }
 
 struct rmem_assigned_device {
-- 
2.34.1



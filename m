Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72677FEA839
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4CC6B0098; Wed, 25 Mar 2026 05:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83E16B0099; Wed, 25 Mar 2026 05:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C6D6B009D; Wed, 25 Mar 2026 05:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A58D6B0098
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:00:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52422C2A00
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:39 +0000 (UTC)
X-FDA: 84583989798.25.5F1EDA1
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF12C40008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ivAGQBxD;
	spf=pass (imf17.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJvoL7Svez6wRSfUGCmBuRi8m+f/G0Wc/DykecDJV2k=;
	b=y/KDQopQRylJ2XWL/TkowETpGEaP69TNLoC6YZJOhzkQ7OH71sSjzCDPdH/HTzFjPQNFXo
	cdFzdzUiTKSiOE5+O+pGvRdP20ThMyMey3w7bQTviPGt4Z7yEapOh+UVRbN9bHLqQphqX3
	Z0RTPadSuP73Yp/SMeqs8nac1rD1hvM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=ivAGQBxD;
	spf=pass (imf17.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429237; a=rsa-sha256;
	cv=none;
	b=BhySU2JP394uGdy2AgODocYDStD4U5qwvoR6rLQ5u810xFB1TIAMgSCyGOAiUya133VLiY
	PEVHWrk4zLtT0lAnkp3M0LvRx2ABRpY4SrZZuwMDPkIczTApbHZ2MD6AlEIBupaCaf8LkB
	Dj+RWSOZb7YPoyocz2Qe+il8JK7gIlc=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260325090034euoutp01f308af0d7f323d8f7876caef7bf96bc0~gCfzh7Dn82273022730euoutp01J
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260325090034euoutp01f308af0d7f323d8f7876caef7bf96bc0~gCfzh7Dn82273022730euoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774429234;
	bh=VJvoL7Svez6wRSfUGCmBuRi8m+f/G0Wc/DykecDJV2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivAGQBxDvj1e/LcGA0Bnu3dhxJuZBzp4M50oH5+6E4DArMz/uHngUdD86AE9LeJHH
	 OXmv5T08PnWBDe8tdbqg5gTg2SnZvZqDytFG6Kss0aytHGJ6g34RCOiYvl2bJo6kgv
	 5E2uKEWqIPu7qiux7fKT1zXT+dcmMuXs6s0Ee/zE=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260325090034eucas1p2fb10744edcc6cf8550e9855973492a00~gCfzU3Jn23169331693eucas1p2i;
	Wed, 25 Mar 2026 09:00:34 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090034eusmtip15244f1412a032a5a834b55e8229409f2~gCfyy4X3J0318403184eusmtip1m;
	Wed, 25 Mar 2026 09:00:34 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 7/7] of: reserved_mem: rework
 fdt_init_reserved_mem_node()
Date: Wed, 25 Mar 2026 10:00:23 +0100
Message-Id: <20260325090023.3175348-8-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325090023.3175348-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260325090034eucas1p2fb10744edcc6cf8550e9855973492a00
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260325090034eucas1p2fb10744edcc6cf8550e9855973492a00
X-EPHeader: CA
X-CMS-RootMailID: 20260325090034eucas1p2fb10744edcc6cf8550e9855973492a00
References: <20260325090023.3175348-1-m.szyprowski@samsung.com>
	<CGME20260325090034eucas1p2fb10744edcc6cf8550e9855973492a00@eucas1p2.samsung.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF12C40008
X-Stat-Signature: 8qppuxpohh5yfe5tmzhe5k655c1hpueb
X-Rspam-User: 
X-HE-Tag: 1774429236-929714
X-HE-Meta: U2FsdGVkX18Q+jlXemnxwGp9V/fFjjoL3jMFOUCVwHmKRBfshvS/gvvtuHOwglwZEMBCtYhA4/9vvYXoIxIziR+gCuKZ/gl0wSRrET4AMu7T2+Oc6vFTgIcQciWkypjXvhB5/C74SkADNiaq8tzdT8YUmB/LcW5ym7Wx2sw++pTUzsNwHqV6BYy8otg9A02bXwaT7VMF1KoOaNs9wduF4MXAucz/YDskSOxtPiEwmR1DIVjOft9ilc1xgiLN1qdYnjyjO53g74nMTvFfdSJYSGQ8dsmj1CLBFEH/QFlpThIsixXlmFIqePcOh5vQASCw0smv+ZYWTFkGhc714sKJS/7gHdMEMIcPWOnNYYoaEgjwYDKBZw2guJhj7NRmkpYB0+XonTijSBoOUQ2dHi3G08iIp0LRqXUhKWbLxxeDuhLBX8GR3w9zsuPzXdKlWuJqsmcPR3I9GLjG/A6/hPlt37SCSSV3iZt3hc1d2soba2m7YFj6tQ+80/udjYTo8dHPHEr7Cm/j1S+as7SM6h/GU/B2qcKIDpABXyYfIjwKY2UAakDSgjsNMf670EB4oLTN9CdlBv+/Vth/G2DKgKqnmPVdPg2nkbwSmDdzUsR6dudPpZlZkUaBXnx74STXDOfjUoDpkuC6LmHcdwEOp0xMybcmyLc/30xt2cWC2KDqqtpTjilah5u0G6OaiVk4Xr7jCqtlkeJUt4jgbWSkF/F0/Ho1SDebTws1IdZEr+9nlLxudce+r/5u0oFQv1H6n+fVeVY1NOEcnHTDZ6tJ8Bu05i0VgcaRmvpe35E4MUX244OTuEQBOBrz7nBJYaiG3ULR/zUy2e/iVHUlYE7w50OzIg1gDnZdjmCzUuMje/rdADMaT+aNeUSVm/fniV7DFrs1fB9/RxqN62h57CUr165zAXS8KG5KIAZp8jJybNfQEvde5i/tKemTSrayLNnY9nAgIzwfF6leKe6tgZFFHi7
 IEmYr51R
 8R5nlUSYpk9vCNeuGJ8dPvSLdLQzSscW0lTZGWRA2ElJxK2+ZuNWPIp1vS9wCjPZI7rUt/4i9zOyeZ4GrdHpDSPrGoPkd/LbhXCCZMQTbXcMPC56+j6pmLl3XN82riiJwaq3mITcraj1Qp8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the content of fdt_reserved_mem_save_node() to
fdt_init_reserved_mem_node() function. Initialization is no longer
performed in two steps as it was initially, so
fdt_reserved_mem_save_node() name is a bit misleading and that function
now performs full initialization of the reserved memory region.

This also fixes the problem of keeping pointers to the regions, which
failed to initialize, what might cause issues when such region is
assigned to the device.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 62 ++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 34 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 037e3d74dde1..8d5777cb5d1b 100644
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
 
@@ -619,30 +595,46 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
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
 	if (err != 0 && err != -ENODEV) {
 		pr_info("node %s compatible matching fail\n", rmem->name);
+		rmem->name = NULL;
+
 		if (nomap)
 			memblock_clear_nomap(rmem->base, rmem->size);
 		else
 			memblock_phys_free(rmem->base, rmem->size);
+		return;
 	} else {
 		phys_addr_t end = rmem->base + rmem->size - 1;
 		bool reusable =
@@ -654,6 +646,8 @@ static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
 			reusable ? "reusable" : "non-reusable",
 			rmem->name ? rmem->name : "unknown");
 	}
+
+	reserved_mem_count++;
 }
 
 struct rmem_assigned_device {
-- 
2.34.1



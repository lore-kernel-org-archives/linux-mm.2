Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C02F105F7B1
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DF56B0095; Fri, 13 Mar 2026 11:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A203A6B0098; Fri, 13 Mar 2026 11:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79CEA6B0099; Fri, 13 Mar 2026 11:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50C5F6B0095
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06A6AB6166
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:18 +0000 (UTC)
X-FDA: 84541370676.09.7A19198
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2264D2000E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="fKPW/S6+";
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773414496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rktRrrVukWEfNnrdm/R8KEtwrP6KWG+D26ZM/qAdblU=;
	b=5hxNQWZBHaqIlFwIUNjIshh/OGKXliR5kPwLvYFqh9cJz1XOX4/vAtGpBgcVXtuXpFpaLa
	8mS70Go5026ajZYqr72uq4xkev/K0J4tncTwj390l3phPLi1VcdBq6Sw1q/+rS+YNGuvL/
	/s9BA2thHlXxv39lbGbGVl/XpdHTrkY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="fKPW/S6+";
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773414496; a=rsa-sha256;
	cv=none;
	b=gZI0C3u5YOp104HpiIRMDZ7MCgOWvs3ikK+bEHUNMAiqGqcOfC5Dk/7A8UJKQO+RmVhGOm
	TNepX+7eeH/hpTAP0E5SPiEm8Ugh4Sw9Ayk4LR+9SVTIKck4rzOHlpb6uRVEcwIEoXK7DF
	Elf0iDt0SOsp+77ve6pqTYgVxSWW/xQ=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260313150814euoutp02f637c4382894fc0fb097d6a0ab02c17f~cbxYfOmkK0098000980euoutp02D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260313150814euoutp02f637c4382894fc0fb097d6a0ab02c17f~cbxYfOmkK0098000980euoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773414494;
	bh=rktRrrVukWEfNnrdm/R8KEtwrP6KWG+D26ZM/qAdblU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKPW/S6+kFIGl7cXPWpT7l9ATPs3Yyz8LWlnjiGSJHPq3Rm4cxYSoh+4ndkTJ0B6a
	 2AYD5Z9CGaGU2rk7yQfMyS/liBfc0CaPCZcFkB+PkUvlartOwfPJft5ioPzrxsWmsq
	 sfgDoJrOlswdoerCICXXlzDi3SZ1/T+CJyjR+ZtQ=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260313150813eucas1p275aa47663c75455fbec8f6a315c03f38~cbxYNSt030094900949eucas1p2X;
	Fri, 13 Mar 2026 15:08:13 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150813eusmtip161eb6110ea66f1653196ef72d58ae921~cbxXpGXW91821718217eusmtip1b;
	Fri, 13 Mar 2026 15:08:13 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 6/7] of: reserved_mem: clarify fdt_scan_reserved_mem*()
 functions
Date: Fri, 13 Mar 2026 16:08:01 +0100
Message-Id: <20260313150802.1121442-7-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260313150802.1121442-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260313150813eucas1p275aa47663c75455fbec8f6a315c03f38
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260313150813eucas1p275aa47663c75455fbec8f6a315c03f38
X-EPHeader: CA
X-CMS-RootMailID: 20260313150813eucas1p275aa47663c75455fbec8f6a315c03f38
References: <20260313150802.1121442-1-m.szyprowski@samsung.com>
	<CGME20260313150813eucas1p275aa47663c75455fbec8f6a315c03f38@eucas1p2.samsung.com>
X-Rspamd-Queue-Id: 2264D2000E
X-Stat-Signature: wat837q8q8fjpz39tekyeit3hn15eht5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773414495-483378
X-HE-Meta: U2FsdGVkX18slseBIjXz47iWY1drrea34VnXf9DiKWxYodBS9FyCr6tPYJCAssPjR7xlUT2zH/cIFvcFJw0vXTy2h8AgVS8yDNPBgZhkWqR16x4XfrcCXxPQDWGVK9ZUr6jKHqvBk3rcd8zVzqAN2tffn1C2nVoW+FIdcUr98EPcSLOOkIqaVqo3jFKnaIWo1s4kvwz1yoTEma3Cv40C35Ip5QXhsXlYBIpXcm7gsOes3nWPP4iS3rx9G7Y2Sz/i56aPKQYwwkaQGJeWfnKcLSE+1GNk34NgHx1kYhVIUxoTCkmPpv5Zj/Iqrdencxhs1oZa49mMsXuFrsuwdqARJ+yKHQ73XbzpIYOENOIc54YTEXv+pJbxUXfjVlamX6ZeVPvDV+OxKshFaUmcdnAkKx/mK7JUR7RM4qTwhlU6A3nKpjRMqY5Wwc+Mnx0MxGCQhdS2Zq65IDVuDzIGtHVFbUsrzYIfb/JqewAUTmFFWmwckul49cbjtAV6aw21o76Jvw3K4XNNhWNqGOfWadyj1tCXfP12/JOwHfmlcwBTWvvscAqcvr7LjikEe1HxaHWWE+OXONbUKFg2Vh0K1z2U3KLFEBIDnw6Zri786yGhmbKSHdZn5CBGgOIo9iCANJpG8aAtU32JUKyDpP1pJD8JvWmW3c0BXvK+8HRjeC6aYZ/Py2lv3K438oA2CiOJM7DrdOwD2LlQA9OPzewtWvVmjWwes/QNpFWubjvRjUukEXctvUvz3hiOMH1+IiYgL52MRqW5cR+7R9Gd4wkWrH61yEBhw5w0lwFI/7ZRzcplvUWfIP70MMGZNYt8y5I6TS18toc9zIfysPOVQoc6HWtbdUvC//XG2dOr7HrPtlhsGmsnk70rtOBP5Aq+Fw45BWAZjyd8BkWIY6mTIk+SUbg6oxZxLs3gEMQDdHJ84CSJfBIqx8EIDrNkt1qFqHF8K02pSsKP1yUBxvgzYhCN2TQ
 C5DOV+Lp
 1S9kvBI8kUalryQ+6g0Qi7fqKPH0If49JFO/qgnUVyx0f0ZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename fdt_scan_reserved_mem_reg_nodes() to fdt_scan_reserved_mem_late()
to clearly show how it differs from fdt_scan_reserved_mem() and update
description of both functions.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/fdt.c             |  2 +-
 drivers/of/of_private.h      |  2 +-
 drivers/of/of_reserved_mem.c | 24 +++++++++++++++---------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 331646d667b9..43a0944ca462 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1274,7 +1274,7 @@ void __init unflatten_device_tree(void)
 	void *fdt = initial_boot_params;
 
 	/* Save the statically-placed regions in the reserved_mem array */
-	fdt_scan_reserved_mem_reg_nodes();
+	fdt_scan_reserved_mem_late();
 
 	/* Populate an empty root node when bootloader doesn't provide one */
 	if (!fdt) {
diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
index df0bb00349e0..0ae16da066e2 100644
--- a/drivers/of/of_private.h
+++ b/drivers/of/of_private.h
@@ -186,7 +186,7 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
 #endif
 
 int fdt_scan_reserved_mem(void);
-void __init fdt_scan_reserved_mem_reg_nodes(void);
+void __init fdt_scan_reserved_mem_late(void);
 
 bool of_fdt_device_is_available(const void *blob, unsigned long node);
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index b8d4fbcde3b1..229573d6dacb 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -265,16 +265,15 @@ static void __init __rmem_check_for_overlap(void)
 }
 
 /**
- * fdt_scan_reserved_mem_reg_nodes() - Store info for the "reg" defined
- * reserved memory regions.
+ * fdt_scan_reserved_mem_late() - Scan FDT and initialize remaining reserved
+ * memory regions.
  *
- * This function is used to scan through the DT and store the
- * information for the reserved memory regions that are defined using
- * the "reg" property. The region node number, name, base address, and
- * size are all stored in the reserved_mem array by calling the
- * fdt_reserved_mem_save_node() function.
+ * This function is used to scan again through the DT and initialize the
+ * the "static" reserved memory regions, that are defined using the "reg"
+ * property. Each such region is then initialized with its specific init
+ * function and stored in the global reserved_mem array.
  */
-void __init fdt_scan_reserved_mem_reg_nodes(void)
+void __init fdt_scan_reserved_mem_late(void)
 {
 	const void *fdt = initial_boot_params;
 	phys_addr_t base, size;
@@ -328,7 +327,14 @@ void __init fdt_scan_reserved_mem_reg_nodes(void)
 static int __init __reserved_mem_alloc_size(unsigned long node, const char *uname);
 
 /*
- * fdt_scan_reserved_mem() - scan a single FDT node for reserved memory
+ * fdt_scan_reserved_mem() - reserve and allocate memory occupied by
+ * reserved memory regions.
+ *
+ * This function is used to scan through the FDT and mark memory occupied
+ * by all static (defined by the "reg" property) reserved memory regions.
+ * Then memory for all dynamic regions (defined by size & alignment) is
+ * allocated, a region specific init function is called and region information
+ * is stored in the reserved_mem array.
  */
 int __init fdt_scan_reserved_mem(void)
 {
-- 
2.34.1



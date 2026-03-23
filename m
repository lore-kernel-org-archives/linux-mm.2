Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60053EC01BA
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BFC6B0096; Mon, 23 Mar 2026 06:09:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34626B0098; Mon, 23 Mar 2026 06:09:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4686B0099; Mon, 23 Mar 2026 06:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B77866B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:09:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75E371B904F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:17 +0000 (UTC)
X-FDA: 84576905154.13.FAE7F2E
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51CB514000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=UHfUkb9k;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774260555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnpG/ghmAqbS6QKwZNF5IxO0PeBEQO07aIL3Tp2D5sY=;
	b=T1aWJlVApTVQtazvARK/Q9xx4f7uHrhtFrnsWVf1+Fu+HdpqqhPkBda3Oj0WONH8W7rYlv
	8IF1xoWxpZ5MSTQUmlaUNrP7IDjhxReJ9YoJJTccmtmgle1TpOpiGyPIaZwuOXPp8+vQUw
	PVdpBzuThLOeWhkurQBjSvtbzwRQkuM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=UHfUkb9k;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf26.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774260555; a=rsa-sha256;
	cv=none;
	b=d09lPh7aTHpU/hvRx3PCyvGgQlZ0b5ksWkaf9f8sUyH04vcC0iOrQbInfuRoaiVayAExax
	VT+OWzn0R9tQlr2ZeZyHFSsX4OvhTbBCIFpdfk9n6Rz7J3FYBp+jWFgOtaW6hteKTM0saj
	4uOByWp048xmdA7s80VqknGRuPhxlF0=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260323100913euoutp01a8bd487c8145eef0e3692f8eae2dfb09~fcJLHxYdy1424614246euoutp01l
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:09:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260323100913euoutp01a8bd487c8145eef0e3692f8eae2dfb09~fcJLHxYdy1424614246euoutp01l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774260553;
	bh=XnpG/ghmAqbS6QKwZNF5IxO0PeBEQO07aIL3Tp2D5sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHfUkb9kS4qK4UFqzsMWMgRbI8ts5NH3kGxBRoEQvaWLidowE7aktyejFPQc1YDtG
	 QXU6hvsaNGPcRY8KeYyttHl+qXaq58vsCarJ6QXnI3E3Je+R6gpQZL2xv23CcIeq0B
	 zQR7HevGq64g4pZwxkyK/VX0R9mdZ6B7BQgZ1T7s=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260323100912eucas1p1f13cc5bfc49a119c7f1e0d6bd754d42c~fcJJeUWMb0541705417eucas1p1O;
	Mon, 23 Mar 2026 10:09:12 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260323100911eusmtip2884e9a5ebc23eed9d8cea4e2a5e97500~fcJI7eMUO0421504215eusmtip2T;
	Mon, 23 Mar 2026 10:09:11 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v2 6/7] of: reserved_mem: clarify fdt_scan_reserved_mem*()
 functions
Date: Mon, 23 Mar 2026 11:09:00 +0100
Message-Id: <20260323100901.4079171-7-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323100901.4079171-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260323100912eucas1p1f13cc5bfc49a119c7f1e0d6bd754d42c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260323100912eucas1p1f13cc5bfc49a119c7f1e0d6bd754d42c
X-EPHeader: CA
X-CMS-RootMailID: 20260323100912eucas1p1f13cc5bfc49a119c7f1e0d6bd754d42c
References: <20260323100901.4079171-1-m.szyprowski@samsung.com>
	<CGME20260323100912eucas1p1f13cc5bfc49a119c7f1e0d6bd754d42c@eucas1p1.samsung.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 51CB514000A
X-Stat-Signature: 64mqswqykpmg6cb9nmuo5kocbcu3itbu
X-Rspam-User: 
X-HE-Tag: 1774260555-41683
X-HE-Meta: U2FsdGVkX1/AAQ4gdg60QHGkM7V/sCUfqbE00VE9XliYhzW21trTaYylSv7O83BZhHA9D9Iz8lJRXCebhYcfTQabie6pxJwZ4njXBW/oIV+gj1jJrEYlESCWLl11W7igr5NgCxcJqT8PISRMHKn3n0jExawku1YIJs6NdcaQbh19PN5j70iNiM2RdmxGn7CBW894JLqL/UvB0Xy3Sa1GMY/pQ+vACho18u83+0kcsjixy1Y1+h3dR5UN7Zi+CJUCxZ//WKAGxxJ+uXyuhVCYqEoIo/Bi5jj5U1C1tcaW/hiZYYj88AW4rKYA0Noa6ruva9s4sxgnlLkMBrEWW+dOpxRWrxfaNaNyALzqx6NkBIyo4A68NPw4IieNVeCX6tNXQKGcCvH/cG1poZsIzsZSTDvSnGqD0kuOuVO5QmThta0qGe7rTu3cliPtezkjzJ9jjKa3DUmuPjxfwBohrEtjyklS1fTmxeZb8iCFX4Jb+SLF22u9oiLMZgTKPGnov4QONd4KhtA2nBCSO1xef316MQbflw3fmq+zn2IDCR/JRZ90HqPj8dUyHG2RgUDqR5pDE+b6qUkVMtwW0lHdeGU0Aro5+x9EzSYcHm4TWtOmf3PCPCEzYC49+I+sUVuqgo92yLd59CRDC5lecRfrsw7P3lnnDfFO7lNwBzNsP13aUIohTsOdvXET4jVfm2oekumxGLRPT31Vo4KD5EVSYNjh6kPtp7bWz/fWvOMtp9KoyXL2DMp3q/WejI7JtLhYgZC9cY6En7SSRzCpLlUNDgzSaR0eKxCvXyfWdpI7Mrdds/RFkKgKdBdjR8n+mXJBPOdc6/DFqusv4T/rZ+zH7zRAZf4DkMLe5usLJdHQYLRQ4cgv8LqqtZSz7lPopwr+wxmerlJxzi3Yq3wN4C1fWvCDxovcAGHD0fD4xhJT3BAfqxl7YTpKY647hDBGwn1uo2wov75nZjWI5Hh8c3ukIEi
 71BTDYfC
 rzOtQ0NavC3iSna4sFejc0x4VxUpfY7Qw/ghWIdFWFG2lvoV+EJdvlqMug10vDsOBof+URPBJ3FxaNGSTEIc5/qy/ZuQYjOYeCPEemmLDL3BJM3zXvwmvrUAc/SKyipoquieJd+q35MmSxlk=
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
index dceaf19f31fb..801451d034fa 100644
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
+ * "static" reserved memory regions, that are defined using the "reg"
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



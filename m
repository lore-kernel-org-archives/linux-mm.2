Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A43B0105F7B4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C346B0096; Fri, 13 Mar 2026 11:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C226B009D; Fri, 13 Mar 2026 11:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C766B0096; Fri, 13 Mar 2026 11:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0AA6B0098
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:08:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F3315628B
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:18 +0000 (UTC)
X-FDA: 84541370676.23.B31F688
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id 33A9F100002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=M+Ahlbkt;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf14.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773414496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNRB2bVdaO0e0Tm9fiFGo+z5sEqF/mw7wNSwebObrUM=;
	b=ZX3fI2bbCwEM3XivF5Ac5evFO9FixlS/hvGFwzT0pqCu5fYJm1gnHKN0unR9YPz53V6dh3
	RSM52/pBw3oa0BbdFhMtmz2ygwdSREVBo/dASabACwycayxtvVr3WS5ahq4JY/Q5FAGG+F
	UkK59zIwnrS95uHGrE041hKmYYqCmKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773414496; a=rsa-sha256;
	cv=none;
	b=0oqgD04zYHuXwx5gkwJvpReJgqd9TQxtpEgg6qkjy8aYkfipOxKrDGwtbxCnq0CNiGwlFA
	mAos8dSHctFBhP9R3IzYQDhj/N87q3BeTHAECWCH1XSCJN5cdoAjiBtUG/6IOTQEGnPdpO
	h3Oyrl76AlX/NrPId/9C8SOQVzVxlfM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=M+Ahlbkt;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf14.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260313150814euoutp02938b707e453e03452d51c13a5875e558~cbxZHYj3k0455304553euoutp02G
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:08:14 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260313150814euoutp02938b707e453e03452d51c13a5875e558~cbxZHYj3k0455304553euoutp02G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1773414494;
	bh=cNRB2bVdaO0e0Tm9fiFGo+z5sEqF/mw7wNSwebObrUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+AhlbktAAP6vXnQqOHdc6IrEP9wUOjgwkSn5Pxeg6L74TN7ffySVmi01+RS41u8q
	 uf9mYtDtvr71K1GQyR0jojt9AWBWV0irDY/YbTRIpSWwECB7m+qCGa0g0DvFpSQBJG
	 YMxq9zd/ny6Q9VOKji09HbvsaFE8SntHxgSUhUIc=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150814eucas1p14203b667c73825e16a3d5d6430e5e7b6~cbxY39fhn2140221402eucas1p1Z;
	Fri, 13 Mar 2026 15:08:14 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260313150813eusmtip117becfbcee6e6475d5e56b0134cdcd73~cbxYTOPyE0187001870eusmtip1H;
	Fri, 13 Mar 2026 15:08:13 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Saravana Kannan <saravanak@kernel.org>, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH 7/7] of: reserved_mem: rework fdt_init_reserved_mem_node()
Date: Fri, 13 Mar 2026 16:08:02 +0100
Message-Id: <20260313150802.1121442-8-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260313150802.1121442-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260313150814eucas1p14203b667c73825e16a3d5d6430e5e7b6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260313150814eucas1p14203b667c73825e16a3d5d6430e5e7b6
X-EPHeader: CA
X-CMS-RootMailID: 20260313150814eucas1p14203b667c73825e16a3d5d6430e5e7b6
References: <20260313150802.1121442-1-m.szyprowski@samsung.com>
	<CGME20260313150814eucas1p14203b667c73825e16a3d5d6430e5e7b6@eucas1p1.samsung.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 33A9F100002
X-Stat-Signature: ikqe614c7qkjefrwjkupk9rwnuuo4ubk
X-Rspam-User: 
X-HE-Tag: 1773414495-772779
X-HE-Meta: U2FsdGVkX1/Pim1E+LT9sKlb2M7JQtpLwTD2LxpIaGCqVlOXX93OcY6ZqrcRXyq6JB3RySgqp/hbMwSl191p+fOCxZ/BxZC5eugF0oJTchTUB7Gj7UDIhKuuQYC2+VlcMIwb/g04e+fOBObCH6J0sUI3d5FTjhNWdHwCHes2ydpedBIsG+3IgWu+qyZLsomaD07JKqRrwIGE9Zwb5K0JgwrECorDzB0T5CszBUEprtVr4S9ilp/lBh0VAmuYrdEVSD5osteSSMIAJa+fsetKzGvWr4jKrtxQR8pR0H42WGDGooLd4bYOIJKWwNQxfsKEZ66g+4z1OKRTD8c155LXaXfDvluhb4gcC4/ftdIH6NZ9+W87BGerCxxXzOOurN0Zwd2+XPcnVPz+myv8JvnrmscXp+XbGHMiy8gQCB4Nz7VS24xC9RqAxn3ib+gGqgCLTYN5dYfokUxDZtlGBKQTHivDftOkFPDPZiwLo4m6u4NTpXVBk1PcmN9QA2NdydMMSiStSUGiOrzIQZFKuXhshGq42xV/8IWnW3+ZN+K7WH9ovjBaJeizYeOVSdDQWupFfr0rO36Cr1GfNX+65q7ExMZ8lxKZ6QWcAiRHiC1f+1ANleEPZBo/u6nx/nf5W13yKMIJTu9awVO3Kh4aC3jKC8+SmpbDzrg1cfDKXontzrnENmgFmniU1JoY3WLeLhL9gRL6AZmzUJcdnRi0F+x0eRmeZD8YPr3MMQ2SjXScHLa/meab+tsDFMf5LltXjMc0+aVnGp5+qQosfAzg3WhC6XAqeSCOoiXOwKc7Sv6i5dRP0p/rJVIcFgXi5CELf7kaZ6bj6LEG6z1SBsQzEr5dtM51hgApVwrtoT5ggRfj2SNXDJaJCbsp5HPAVrzsJo+P6PYCnZvRC1qi3+SHzE1lZhF1tP0rliHqDoHxRSZmn+3pvhcSdFi7ZCKJJWOZCEdH1IwYU6WVZtFsGAfcZC3
 pHD758BQ
 hwda1mznMxBM3wYoD+90Ix1Tn2jrxoI9uCUhmWut6tgYXrS0=
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
actually perform full initialization of the reserved memory region.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 58 ++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 229573d6dacb..7146c1ba6ae1 100644
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
@@ -316,12 +293,14 @@ void __init fdt_scan_reserved_mem_late(void)
 
 		if (size) {
 			uname = fdt_get_name(fdt, child, NULL);
-			fdt_reserved_mem_save_node(child, uname, base, size);
+			fdt_init_reserved_mem_node(child, uname, base, size);
 		}
 	}
 
 	/* check for overlapping reserved regions */
 	__rmem_check_for_overlap();
+
+
 }
 
 static int __init __reserved_mem_alloc_size(unsigned long node, const char *uname);
@@ -515,9 +494,8 @@ static int __init __reserved_mem_alloc_size(unsigned long node, const char *unam
 	}
 
 	fdt_fixup_reserved_mem_node(node, base, size);
+	fdt_init_reserved_mem_node(node, uname, base, size);
 
-	/* Save region in the reserved_mem array */
-	fdt_reserved_mem_save_node(node, uname, base, size);
 	return 0;
 }
 
@@ -590,21 +568,31 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 	return ret;
 }
 
-
 /**
  * fdt_init_reserved_mem_node() - Initialize a reserved memory region
- * @rmem: reserved_mem struct of the memory region to be initialized.
  * @node: fdt node of the initialized region
  *
  * This function is used to call the region specific initialization
- * function for a reserved memory region.
+ * function for a reserved memory region save all region specific data to
+ * reserved_mem array to let of_reserved_mem_lookup() function find it.
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
@@ -614,6 +602,7 @@ static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
 			memblock_clear_nomap(rmem->base, rmem->size);
 		else
 			memblock_phys_free(rmem->base, rmem->size);
+		return;
 	} else {
 		phys_addr_t end = rmem->base + rmem->size - 1;
 		bool reusable =
@@ -624,7 +613,10 @@ static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
 			nomap ? "nomap" : "map",
 			reusable ? "reusable" : "non-reusable",
 			rmem->name ? rmem->name : "unknown");
+
 	}
+
+	reserved_mem_count++;
 }
 
 struct rmem_assigned_device {
-- 
2.34.1



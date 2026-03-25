Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F2FFEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A406B0095; Wed, 25 Mar 2026 05:00:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6BD6B0098; Wed, 25 Mar 2026 05:00:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF006B0099; Wed, 25 Mar 2026 05:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC4546B0095
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:00:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE918E0799
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:37 +0000 (UTC)
X-FDA: 84583989714.20.644A581
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf24.hostedemail.com (Postfix) with ESMTP id ABA90180005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=vJh1PR6R;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf24.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429235; a=rsa-sha256;
	cv=none;
	b=WruHBhLO9HbCfM3QB8efgczhNpgrzs0N58ugLH68OY6K4t/3QS60B+OAZZHlb6lSG+8mHi
	u3RTbkict6m0phhL7weexTDPQ+Hdly/bx4CRiANUdE3ujYqtwBy1JaEQXCYMtBe+ozXPZR
	9rqpk32YWu+lJoeYNj1JKeKAtRacduY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=vJh1PR6R;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf24.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VLOktVyCw/sFKOWYlySyASENC5MrPmRSGXG0sIJP9g=;
	b=QTprp5VbPqQwjCsGiMrXZedbPhXcfgNSkU2cj/fBip2ecLVWcNxWG8dS8DdXhwezXWs30l
	0hI18KrxTXbWPyDGtamFNvrwK4X1AbQaEf/Xul5QSOkWf74Vz9g5nI57iTVFVD8g4s39xB
	S+0Tj8vmWWJO0734MIBocpVQCjQwnZM=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260325090033euoutp011281493eedeef4198972d158d3da5fec~gCfyWOy_12240722407euoutp01f
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260325090033euoutp011281493eedeef4198972d158d3da5fec~gCfyWOy_12240722407euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774429233;
	bh=7VLOktVyCw/sFKOWYlySyASENC5MrPmRSGXG0sIJP9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJh1PR6R/JJrJQT0Yy9l+oeTPEAESSNCukDx8KwAlQ0GZ83nScB+YYStOxYHarYF5
	 38ruH8knTj16gvDc6w1pszGt9x+8I83y9dwgNu42HujE/IEf4c04y2aRycomHynjls
	 Ylhjzmkrrf/26hDTlzhr2iz+5tJvJmZYcQvMZGnQ=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090033eucas1p1715349936f9737a7bc7968351fcab7f5~gCfyEzQz70601006010eucas1p15;
	Wed, 25 Mar 2026 09:00:33 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090032eusmtip1584a0042647e55c92d56f1e00b3a2c3d~gCfxiiw4T0281802818eusmtip1-;
	Wed, 25 Mar 2026 09:00:32 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 5/7] of: reserved_mem: rearrange code a bit
Date: Wed, 25 Mar 2026 10:00:21 +0100
Message-Id: <20260325090023.3175348-6-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325090023.3175348-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260325090033eucas1p1715349936f9737a7bc7968351fcab7f5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260325090033eucas1p1715349936f9737a7bc7968351fcab7f5
X-EPHeader: CA
X-CMS-RootMailID: 20260325090033eucas1p1715349936f9737a7bc7968351fcab7f5
References: <20260325090023.3175348-1-m.szyprowski@samsung.com>
	<CGME20260325090033eucas1p1715349936f9737a7bc7968351fcab7f5@eucas1p1.samsung.com>
X-Stat-Signature: 538pjpt4emd9gx58pbfrhjitnfs4hti1
X-Rspamd-Queue-Id: ABA90180005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774429235-604790
X-HE-Meta: U2FsdGVkX18SXi0XLRXSnNnV3C1gRab600OXpizJ9Zt/cEvIPVXAnWEt1qaco11+nQdHKjXrKeAyDAnVvkHXLbqpSEJUpxD2Qjf7XGuSjSSnUBl3h2ONgrMQXTzHJ3vE0GEpGVbWGV29HHTAZDpEkp8edOo4zp2z6BWnO4h80DkipbLJONhEyKos//cI1hjm1/7EJizJyPlPB6kzhgRiwVs7qXWPDN5FrYy/oVG/YU0wjxJYqjUbbiuyWU45pIqq45Efw46aZf7yMHQLQ37guwaIJ7jT6PZSKpEril8wmJDA+RpAG+2FaMk4wsWPwb+2d6zFN/aZiTLW+o7mwtqywUn7VbYN/gNg4AmKImECTlZUxy09DEXmtuShTs2vHHulXTGJw0srAPZSq2YfpBlivYETd3/+qYbVnSbcEA2v+C27j7MXLQnQ7RpOwyoCJZ0gs/IeIWCMC7jcxVuQqlAPx9CcouYJkGakVGDqjg0oqeR++Slu3md1pbDQjDsJ3vpKk4u8ObyVVO+o9YLoZZYwy6ihDFeNW0gY52xX3AByoSe7a4Br4RFjfR6WvD+KeONjRdbxuy0kz0LeDOz4aRkLd7ra8DpED8ItuUtAkVmnvi93a7aMwHmy2gfIAXODhTeSkldq6Z/NT5YN/ZPEjcCcRCeZXzS95Rxmx6A/bEt5IbzaZMOO8W4BCd5Bnt0p/8R5LF8pptVMDiEPIca7BrK/cJ84wAP2FImfuFNxJMFVfQGgjF8D5eScFF1K2oemGiBcDNLU310VHO9OWN5ydGyFigFg9vddlZMzyAwf98IhmUKfiBAcINbjargprsddaioJavjIutC7ig0IZgLF8hIZ4CAEYI9DWOWZp6JM8dSi7zgZSqUUO7gVxUQB/gd7HJzeQow4gaymVRmAC33vx/m6j7l45sLJA4FnGEt02K8iPKE4LK0DDW/VODuBCjsMt3OlWAO3GORqPnfTdFjdZtB
 ZwmJB5ND
 Zom68hCrHajaeJHmFJAsGJTc3+edM1crQP1StbXThTOvoyOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move __rmem_check_for_overlap() and __rmem_cmp() functions before
fdt_scan_reserved_mem_reg_nodes() to avoid forward declaration and keep
related code close together.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 99 ++++++++++++++++++------------------
 1 file changed, 49 insertions(+), 50 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 5dd585bcf8a8..f9b6d3ebcc20 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -214,7 +214,55 @@ static int __init __reserved_mem_check_root(unsigned long node)
 	return 0;
 }
 
-static void __init __rmem_check_for_overlap(void);
+static int __init __rmem_cmp(const void *a, const void *b)
+{
+	const struct reserved_mem *ra = a, *rb = b;
+
+	if (ra->base < rb->base)
+		return -1;
+
+	if (ra->base > rb->base)
+		return 1;
+
+	/*
+	 * Put the dynamic allocations (address == 0, size == 0) before static
+	 * allocations at address 0x0 so that overlap detection works
+	 * correctly.
+	 */
+	if (ra->size < rb->size)
+		return -1;
+	if (ra->size > rb->size)
+		return 1;
+
+	return 0;
+}
+
+static void __init __rmem_check_for_overlap(void)
+{
+	int i;
+
+	if (reserved_mem_count < 2)
+		return;
+
+	sort(reserved_mem, reserved_mem_count, sizeof(reserved_mem[0]),
+	     __rmem_cmp, NULL);
+	for (i = 0; i < reserved_mem_count - 1; i++) {
+		struct reserved_mem *this, *next;
+
+		this = &reserved_mem[i];
+		next = &reserved_mem[i + 1];
+
+		if (this->base + this->size > next->base) {
+			phys_addr_t this_end, next_end;
+
+			this_end = this->base + this->size;
+			next_end = next->base + next->size;
+			pr_err("OVERLAP DETECTED!\n%s (%pa--%pa) overlaps with %s (%pa--%pa)\n",
+			       this->name, &this->base, &this_end,
+			       next->name, &next->base, &next_end);
+		}
+	}
+}
 
 /**
  * fdt_scan_reserved_mem_reg_nodes() - Store info for the "reg" defined
@@ -565,55 +613,6 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 	return ret;
 }
 
-static int __init __rmem_cmp(const void *a, const void *b)
-{
-	const struct reserved_mem *ra = a, *rb = b;
-
-	if (ra->base < rb->base)
-		return -1;
-
-	if (ra->base > rb->base)
-		return 1;
-
-	/*
-	 * Put the dynamic allocations (address == 0, size == 0) before static
-	 * allocations at address 0x0 so that overlap detection works
-	 * correctly.
-	 */
-	if (ra->size < rb->size)
-		return -1;
-	if (ra->size > rb->size)
-		return 1;
-
-	return 0;
-}
-
-static void __init __rmem_check_for_overlap(void)
-{
-	int i;
-
-	if (reserved_mem_count < 2)
-		return;
-
-	sort(reserved_mem, reserved_mem_count, sizeof(reserved_mem[0]),
-	     __rmem_cmp, NULL);
-	for (i = 0; i < reserved_mem_count - 1; i++) {
-		struct reserved_mem *this, *next;
-
-		this = &reserved_mem[i];
-		next = &reserved_mem[i + 1];
-
-		if (this->base + this->size > next->base) {
-			phys_addr_t this_end, next_end;
-
-			this_end = this->base + this->size;
-			next_end = next->base + next->size;
-			pr_err("OVERLAP DETECTED!\n%s (%pa--%pa) overlaps with %s (%pa--%pa)\n",
-			       this->name, &this->base, &this_end,
-			       next->name, &next->base, &next_end);
-		}
-	}
-}
 
 /**
  * fdt_init_reserved_mem_node() - Initialize a reserved memory region
-- 
2.34.1



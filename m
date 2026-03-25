Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8940FEA833
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0DD96B0096; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8FE6B008C; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F326B0095; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6157E6B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:00:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 247D21407A9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:36 +0000 (UTC)
X-FDA: 84583989672.04.41F4113
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id E442580011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=FY5iUkMt;
	spf=pass (imf02.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDkZBH8D9QGZmacGWO/wLlPET8ve8kNAHImwlz5MpvM=;
	b=idfUoyz9VrIrIxXz+PwxVEz3v22Xxs5p970mQhQjaGzqXmp15wRKcnk4815oVA2Yv3jgKm
	uaL9BHTj7pCmunIyQNLKJuCHhnfsGEaLgFW+fE7Xf1tZ6OIkl1B3zj9fmIgpYS4COdLRBo
	onazHBO/lZrcGoyQ6yd0R8vgw9WNHug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429234; a=rsa-sha256;
	cv=none;
	b=69wFjIGqzO75T0FsKqmX7iAvI3oRhtGmZYpyrx+mTaT9xXH0Ywml+TrM9kDDdHrF/sNG79
	zFdYG6jP0lYy57RrdwA71MbaxvDVUO1DkrGSz2TdWO4DmTGkCMtAw20QwMFtbVkKwXg/nW
	hKOuoTYBKGdystJPaCJH8H+XDlsaSwk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=FY5iUkMt;
	spf=pass (imf02.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260325090031euoutp02da97643c035d21d42c57166ecb450de1~gCfwbTHAw0097700977euoutp02L
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:00:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260325090031euoutp02da97643c035d21d42c57166ecb450de1~gCfwbTHAw0097700977euoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774429231;
	bh=qDkZBH8D9QGZmacGWO/wLlPET8ve8kNAHImwlz5MpvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FY5iUkMtR9ARTfG7/tVvrcKFos/ZapigxegUHHHt0vVky5lQ6qCjTliLvuGask1oQ
	 21IwycinJ4E1/p2/flJXeKCCStkMrEvvF8uaS2bNbvl9sZI5ui9VowP/SNvPuwSh2c
	 8+0fWXCDgF7ZVqkiXWdFAzAcncbLr7/irtU2PxMc=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090031eucas1p185465a9f6f2a06a4b1d0cb2b13a92aef~gCfwMvlkl0601006010eucas1p13;
	Wed, 25 Mar 2026 09:00:31 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260325090030eusmtip1a3370e43b1c03e214df9fdc959e30922~gCfvqWu7e0170001700eusmtip1S;
	Wed, 25 Mar 2026 09:00:30 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Rob Herring
	<robh@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Saravana Kannan
	<saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Robin
	Murphy <robin.murphy@arm.com>
Subject: [PATCH v3 2/7] of: reserved_mem: use -ENODEV instead of -ENOENT
Date: Wed, 25 Mar 2026 10:00:18 +0100
Message-Id: <20260325090023.3175348-3-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325090023.3175348-1-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260325090031eucas1p185465a9f6f2a06a4b1d0cb2b13a92aef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260325090031eucas1p185465a9f6f2a06a4b1d0cb2b13a92aef
X-EPHeader: CA
X-CMS-RootMailID: 20260325090031eucas1p185465a9f6f2a06a4b1d0cb2b13a92aef
References: <20260325090023.3175348-1-m.szyprowski@samsung.com>
	<CGME20260325090031eucas1p185465a9f6f2a06a4b1d0cb2b13a92aef@eucas1p1.samsung.com>
X-Rspamd-Queue-Id: E442580011
X-Stat-Signature: my5entqephoww7jinzuwtntyaboyku44
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774429233-157863
X-HE-Meta: U2FsdGVkX19wh9vTaNRmInCmyZITW1JS891gF45jk1P0wWYhWAKoRa8ty0gB23QBmx3hNWPuwpzQG9eRa5ojiEgYwTafDGq4nTBo/przpfPbI3zZW3K7v3mms5xW1rilmnSllX50VKdxfnr8PADEWY6gNpcl0dD+0wtqmoz2l3jo3Z2ROZCjAlwD41ddzBY5iuTAghU2GlN6r1gWxEzEMnnm3sAqPl5GKQKAUxJE1uIlBsrixUYZ0iWVptyzRGGzVqdeE4GceGtds6BC93fPLyUJwwkJh/avzhN9Up8bn13/PckUum+aGrqqIvTJhPiiwTB+FIscv5JMokAjTFGvv5E7io+hlcqqOAWSm8GZ+J13REzCAwpMuOqjkAvNtvTDM8fO47Ymm2aFeAGbIH1ioAN09dfK2dGB9eLEGx+JWn2+082XvOTu6FGqGXyuVwoLT4egS+o8I8vEwm/hwjXe31udcNCvK1Uv4niQpScO7IwbpEX4uYpZ81vYSRrgc5/S5RZa5XeyXro8wK8I1SpNNNwA3A1naf5BcRtk6Cuy6/+G7YvhWOB8UDkJ6ZF9rvaJu+qdy7aEp+cmtuVXUXnD7PQfDpQznh1qCILhGKmlsU4hcOMchSXE0GCKzDMB7Muon6TmRg8TNz4BzamYgwlAk95RjfEtINDt29Ylb6/CecUWSnqWn2hAEg27H9urA4J5TKtD8Nu0/RoydCx/knGECjIWQctjwr/pS6oT63qRZrVVusaGarmT7FL2ImoZsWt5vt01bHs/OfcFIfVN9gDlMuYW1pCRlL/iSUVgwjQA0SDRyinv9SEf3L0pCKlHpg0rme6csrD03odDL3KGaepEazdCwog+7tBO00442/3pMXG87lVml5zo3F6owC2bV0Kqhlq9w1qd6X/P6YlQs8C16gA3uGpjb6DNp3T/plqRpZvp24lmgEdlNR1aiHRUaLwUuKKkAlFzdOJd0endLLv
 X0duGSke
 g7oopHVyRxXR6WeK7fHIVOKkrQhPDWJTGDA8KmT/AoQMwk/fbyeAtln1DzrY8ghz7ClQz3JxzByfqHlVfJNfF6wKZ+Cn7DIU64GF8C1VOuiBLiq6ou7QSD5R9Y4APnQBL0PlwmOZZZh+sESs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When given reserved memory region doesn't really support given node,
return -ENODEV instead of -ENOENT. Then fix __reserved_mem_init_node()
function to properly propagate error code different from -ENODEV instead
of silently ignoring it.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/of/of_reserved_mem.c | 7 ++++---
 kernel/dma/coherent.c        | 2 +-
 kernel/dma/contiguous.c      | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 6705b7afebf0..9aff460a0420 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -488,9 +488,10 @@ static int __init __reserved_mem_init_node(struct reserved_mem *rmem,
 {
 	extern const struct of_device_id __reservedmem_of_table[];
 	const struct of_device_id *i;
-	int ret = -ENOENT;
+	int ret = -ENODEV;
 
-	for (i = __reservedmem_of_table; i < &__rmem_of_table_sentinel; i++) {
+	for (i = __reservedmem_of_table; ret == -ENODEV &&
+	     i < &__rmem_of_table_sentinel; i++) {
 		reservedmem_of_init_fn initfn = i->data;
 		const char *compat = i->compatible;
 
@@ -574,7 +575,7 @@ static void __init fdt_init_reserved_mem_node(struct reserved_mem *rmem,
 	nomap = of_get_flat_dt_prop(node, "no-map", NULL) != NULL;
 
 	err = __reserved_mem_init_node(rmem, node);
-	if (err != 0 && err != -ENOENT) {
+	if (err != 0 && err != -ENODEV) {
 		pr_info("node %s compatible matching fail\n", rmem->name);
 		if (nomap)
 			memblock_clear_nomap(rmem->base, rmem->size);
diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index 34621acbd3c5..64f9ba618e19 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -370,7 +370,7 @@ static const struct reserved_mem_ops rmem_dma_ops = {
 static int __init rmem_dma_setup(unsigned long node, struct reserved_mem *rmem)
 {
 	if (of_get_flat_dt_prop(node, "reusable", NULL))
-		return -EINVAL;
+		return -ENODEV;
 
 #ifdef CONFIG_ARM
 	if (!of_get_flat_dt_prop(node, "no-map", NULL)) {
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 81a2fa4971ee..e6fc6906b5c0 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -483,7 +483,7 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 
 	if (!of_get_flat_dt_prop(node, "reusable", NULL) ||
 	    of_get_flat_dt_prop(node, "no-map", NULL))
-		return -EINVAL;
+		return -ENODEV;
 
 	if (!IS_ALIGNED(rmem->base | rmem->size, CMA_MIN_ALIGNMENT_BYTES)) {
 		pr_err("Reserved memory: incorrect alignment of CMA region\n");
-- 
2.34.1



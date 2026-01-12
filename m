Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6756DC9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A00D76B0092; Mon, 12 Jan 2026 10:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957616B0093; Mon, 12 Jan 2026 10:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A336B0095; Mon, 12 Jan 2026 10:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 713CC6B0092
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:10:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 423148BB5D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:30 +0000 (UTC)
X-FDA: 84323648220.17.FFBB650
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf11.hostedemail.com (Postfix) with ESMTP id A34164000A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AvPdTXIv;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768230628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sok3w+EKcWG8672Zt1cWgHM+04imj24Z0uUlURlgNQ=;
	b=fMrtRejqPImuTWh+GDQuv/CR9/981fhfCF7vdRGWWMKgEYyn0rh3qoE8WsOHiEQOOC1w/9
	zb/mmNtgebER+w9ZldWQGdLgETpyzzrz9Q8mFmA8c8mghhADE4bdOGIORehwBH0OfG4dUi
	sSVuJZkDw4xzplP+ni0VZjGRN40tShs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768230628; a=rsa-sha256;
	cv=none;
	b=PSc+XWuoh5C263Y45msNKZFLXdULge6rEuyLfQIVLkKOiorl3mhCaF8Z22MXY29HUr1L1z
	d3H4oFfZvGF2Oy0YySdNveTNis0Zk18Lr8ZWyCgiT0vF1lWL3AqWorYQQ/z+5gfuj+pvAG
	a/WdRqRdWZo8OPTRbzoBd3mXerdcO3k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=AvPdTXIv;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3sok3w+EKcWG8672Zt1cWgHM+04imj24Z0uUlURlgNQ=;
	b=AvPdTXIv1NJmmXXm6nadLRtyixPKm1JNWVr57QBNUtQOLY8Bom/dG2cSUbvN7weFeNmJnStYU
	MjN4LUCgBwFjLhMOL5gxQX1MG0l8iCeg+jGUkHuz+qfSs8e4n5ggggtiAd1n5U99GLoVbwPbBY9
	vOPJ0jf4yBxL9F/KPnvJWx4=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dqbMD150fz1prKM;
	Mon, 12 Jan 2026 23:07:04 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A01872016A;
	Mon, 12 Jan 2026 23:10:24 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 23:10:23 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 4/5] mm: hugetlb_cma: optimize hugetlb_cma_alloc_frozen_folio()
Date: Mon, 12 Jan 2026 23:09:53 +0800
Message-ID: <20260112150954.1802953-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A34164000A
X-Rspam-User: 
X-Stat-Signature: f3gyd6xt73474ksr6r9ws81ep64yzjtr
X-HE-Tag: 1768230627-122861
X-HE-Meta: U2FsdGVkX1/2WLglv9fjKTLVNdKHG/eqwEUO6Iu1NQKPkLSncGDgRSq7EZNN0Kk+SdXBXIXNbftOuleN9ih8fx3OCC7LuCIV91bBzbv5jlHrqDmIwRKdJfltM0wOmUhP8HH+rYxZ6g91ayOm5UqkWO67YhWrueNm1qFIsihu2eAnasdRoBPk0pey/vbMM58XyxPppPm7iNmt+faMpBsGi4Lz84kmqvL55+JrGdajQ4dYU6xCKYCzpo1fwSmkZJ0RAAhrrjsb/iu3Z4ONK1VZR/s9P+t+uxPLp5GYT/w+C+BUi2w5do80GuRfs+pUtwGg5PT1QTh6bspM02EfoBPj1hGTqs+fHztdFS2xpfjkqAu2TFo68PI/YtQkIaYV8CXig0haRAZ1rBtFUykXPbtDhmOisaJ4S+4iCHMR8KaRUxEhTglQRniSqjFMXYIFlS9UAOq0eIDSfAot6hb094z8GF0Ql4QtpKRHen+r4LSlkU/LHkFRBtKe3kBPusoOOKCpvHefml4/j7dLnpBVFbo1QUXDKad8mlRuBKYAi/+pgqVcFUvYksUIXl8xvrxfeZdNlcvfK+9pNF6Ow3lKCiJ6L01/gDrhHgVsaaRy9wvAhAe3pEDTx127vOAi5EgnUfgqQQQV65lGrl2wAbPxTB6Y8moVj/S0tJ6Y8c2y0bhtqIlZHvrelUkwP0Ox31FRon4KODre3ziud75bBQV2TFC9Os4kJX7F2fCWIkW4i2L9iOoAfFwEtWx1s17lePUvDJxY3v7YdBUFax1yWixOUYDXb0ql2Qyw9+S2tSvbwd/nzSD3vBl3tZa29b7Ck7evVyej6LzSEqG8Q7TPYNN4F4dASbCRdmxvAIzu4xeVNARA6P/pumyFBnhCaVox7fH5YCVhaIU5+8uQGhIxTTcYybXgsooOKL/1314GlkAoxcbdpMuolcMXVc4ZMR32qd+0CYx2SgT1RTJGtfScf3kWrbc
 IiIQnQ2m
 3YOx0QWQjEgU4QTfLUvI4OFzxxPHztAAVF6Qpj2qdCQOiosdtSc97c6Xrft13DSgRBUNrGZ1kLtEIWFddIfgmvaI9ccRXse8hwP0XxWvGf9pN6QSqwwwWMJSoV70BR/k92LYTw412J83xI4brVAirYzsOGFZc0UW7VM2JrH64MbOWZWEIF4bSYc/N0Lf8lpLLgjkvmj7w8lrpQsNSvUjMOcSb46HndCJbG0syzqZtUrvUnC8+GSnKGBE8B/rOWCUGwajljL2ALJS9AAuM0RhFm/wRxNNVIGtm02cKnYmetds8g6oP+LUz5hX13xOR7zzvIFo8nrxLvjfUYIkhU2YgI/SxOcVld+pbUa6ncQ8k6BfRjiZ1bgKssRRLgqOXLTBFoU26H0Onqvb+4SFnqc88KRtMkzfVL3b+TexwX6T2DMkrrZTnoHDl2KZnTEfmGyCWhSeqjcD9izsD/7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Check hugetlb_cma_size which helps to avoid unnecessary gfp check
or nodemask traversal.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb_cma.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 0ddf9755c090..d8fa93825992 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -16,7 +16,7 @@
 static struct cma *hugetlb_cma[MAX_NUMNODES];
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
 static bool hugetlb_cma_only;
-static unsigned long hugetlb_cma_size __initdata;
+static unsigned long hugetlb_cma_size __ro_after_init;
 
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
@@ -31,6 +31,9 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	struct folio *folio;
 	struct page *page = NULL;
 
+	if (!hugetlb_cma_size)
+		return NULL;
+
 	if (hugetlb_cma[nid])
 		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
-- 
2.27.0



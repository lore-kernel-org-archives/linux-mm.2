Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC86FCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1286B00C0; Thu, 18 Jun 2026 05:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113B36B00BE; Thu, 18 Jun 2026 05:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFF676B00BF; Thu, 18 Jun 2026 05:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 707486B00BA
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:29:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F110BA062B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:29:00 +0000 (UTC)
X-FDA: 84892509240.25.0625D23
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4F8CAA000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:28:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qWBSUDbP;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774939;
	b=6gjXJ+VlhLb7zu/LyVSiqugF6LpSWgFtjUmM1z1Ycv6vfvpKVJfrMVHYPmt56lvOJYA98o
	47oqo5bAXWiJyZ84Cv0pN8q8318HavXI82Ea6RF2FSi0AJsV5eBNC6pnhrWfhYk7rtPoWk
	K/BsWVKMbsnbxM5Wesnt+fu++oXU6fU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qWBSUDbP;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hx5gS3E1/ZODRUizRiLrWQ0XJGL6B/MkR/sUODC1Lsc=;
	b=5WpFSKpVruoPrVhvlLzcIgje/sVGoqmFAlQliqVbHCub0+QHDe3zcti5Ec1xjut6OqIbFo
	m7JBnln1LnhlUAdTHc5+zBg4b2My9BP6UGS6J5w5ZgV1gyri/3MYYAbC65blz8FNW0qrT7
	geCGxm2tSv55z93wtYQtXMgzIv5vcGw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Hx5gS3E1/ZODRUizRiLrWQ0XJGL6B/MkR/sUODC1Lsc=;
	b=qWBSUDbPnpNI1YZiqBg2eWGvWya4cPUjzfFxeUrb9CeKvL+28+pBl+wefP3wGdhIprZCkR+UW
	DJ1TgMj+vg6pcOj6YrXZ8XN+1yCrQ2CyLdv8atdP7TgTmuVa+gFzpjokpTDNf0H1bb4kApnK3oM
	hwviyPMjbBQUF4xR0Auun1I=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4ggwDr0DWnzcb3n;
	Thu, 18 Jun 2026 17:20:28 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A5C340576;
	Thu, 18 Jun 2026 17:28:54 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 17:28:53 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 2/4] mm: mprotect: use walk_page_range_vma() in mprotect_fixup()
Date: Thu, 18 Jun 2026 17:28:43 +0800
Message-ID: <20260618092845.3905740-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4F8CAA000B
X-Rspam-User: 
X-Stat-Signature: 1e4wwebipsc9ewbur3pwwuipb47obzu6
X-HE-Tag: 1781774938-32480
X-HE-Meta: U2FsdGVkX18fPlUpryQzYk8H9Po3rqXs8NMv6dXdMHZx9AXhxnXTZiX+9B1h2hxq+3lRknLHue8oC1TuV5iuv5PrSf3DlhBpjKYcyeQ54ED3auFNE/iP1IoD5RdU/LJy3KXgTx3oJ4p2+8gn1TlTuNCV6XYfGOlrElRZkKtUiWbO1IDUPHlkx5UHLhKGw2hUJEsKdS0WOO3/p88r0DMwCEFPZFOzBUg5yTUK761NYF0uUJf5qrQP3mNHVDoKend4Ri4byJL5cqNjfqIucT5U69k9GF+iOXzSN5+rQm/HoFkPCdUhnPcSze9gkryzX89Z5zi0CB4BLZX21DO2Y0iiXQtGVDAWqC9ARcB+8u2jXZmUdyfJWN1eP00sYjmAOr9a5QGEAmPifILJ1kceyuLKf7+8Ss5dTZkLhCqsBQIvKHSR9PvkUY+mb7+EVP8jXOcA2kcfYIJc+FI1RBSS//h+KchlcUHPnI204emxEcGwwQVLEmTVGsZcZrTXC3Kqe7p/+UDNXC9oUcUCyOTssL+qh9Xqp28bD5vT1ukX5m9mKDn6hVVGsufX8nuOTrV5D02QjLOMAzCPUMc0FcEjKzl5WgUmOBA5cXT89po4jL9YPzAnmnc8wQHbONBKgewXU59dgj0wlBJYd9r40DEV3hGyVMX2Fqx5FGnsQMBEI0c5z9SPkWwIncu6KCZ/j1uisJaRXT+Xk3eTJ/JZC4zFDV3/59Yh7LpV52YQfXK4VgB9VDNeEUczfJezJqU2sKHjNTjPS3l45RDrqFnUZiOgjgb8pLg3aS6HQXreDDLqiU2YPXCAjjIHlFrh7qhEdNza4kYWaBj0CTWuwU6zosvm4wzLXojIHSBb7ee7WuPAp+hOni1SXoi5DvQhBWXYZYaN9E0ITrqlxn9GPEkPQYTOJ9kJQzWjRsxAniS2p+OOETDEfR1Hei+igX1CElIztVOeXQVT6sXupWt75h8vy3Na2KA
 lEticmZp
 xnayCSy5+fmoXiW2CFiSNjlQzvdkC0jQV9+A1j8VoZVJ14m+4cmKX8b6Nf1lMF7k93mBtJSNFjBVSwlKb4DLqHNb4Wea7ULp0R5JepuwwQhkLspq6MltmlcVK2IKkn03r60x1uXTyhfiySxqpLRGOBevVSGtyElIx0lg6DNKHmGwXoyTmKxcyFnttdfK1Gwurir3PpnwhLPMBj89wE+slay0x7skpYkfKfAToh+/9UTOnWPJS9iAbCLvX8h+3ph4sJV9amKMmQLzKu6KCbQVjmKUYObILRoR/AWMHqXQO07vFk8ElPkLWuobXe5Qd9bLroQXl0HGoGvKr6i2PLOsb74cNxNGWXguUoDRdKOMlzy/TiIo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mprotect_fixup(), the PROT_NONE PFN permission check uses
walk_page_range() to walk the page table. Fortunately, the caller
always passes start/end that falls within a single VMA, the
do_mprotect_pkey() iterates per-VMA via for_each_vma_range(),
and setup_arg_pages() passes the whole VMA.

Note, walk_page_test() isn't called in walk_page_range_vma(),
however, prot_none_test() in prot_none_walk_ops always return 0,
so it's safe to replace walk_page_range() with walk_page_range_vma()
to eliminate an unnecessary find_vma() lookup, also remove
unneeded prot_none_test() too.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mprotect.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028c..b1595450e241 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -708,16 +708,9 @@ static int prot_none_hugetlb_entry(pte_t *pte, unsigned long hmask,
 		0 : -EACCES;
 }
 
-static int prot_none_test(unsigned long addr, unsigned long next,
-			  struct mm_walk *walk)
-{
-	return 0;
-}
-
 static const struct mm_walk_ops prot_none_walk_ops = {
 	.pte_entry		= prot_none_pte_entry,
 	.hugetlb_entry		= prot_none_hugetlb_entry,
-	.test_walk		= prot_none_test,
 	.walk_lock		= PGWALK_WRLOCK,
 };
 
@@ -753,7 +746,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	    !vma_flags_test_any_mask(&new_vma_flags, VMA_ACCESS_FLAGS)) {
 		pgprot_t new_pgprot = vm_get_page_prot(newflags);
 
-		error = walk_page_range(current->mm, start, end,
+		error = walk_page_range_vma(vma, start, end,
 				&prot_none_walk_ops, &new_pgprot);
 		if (error)
 			return error;
-- 
2.27.0



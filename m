Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5777C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2056B016C; Thu,  2 Jul 2026 22:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8396B0174; Thu,  2 Jul 2026 22:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 907446B0175; Thu,  2 Jul 2026 22:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 446676B016C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:08:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 327101C7669
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:45 +0000 (UTC)
X-FDA: 84945831810.15.CB83D08
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id 82D2220002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UaMMeUw9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3qhlHagUKCFMACvv819916z.x97638FI-775Gvx5.9C1@flex--praan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3qhlHagUKCFMACvv819916z.x97638FI-775Gvx5.9C1@flex--praan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783044523;
	b=CTVBPbdStawNHf7MDXH/yNWietXFfc6VeSxwzdxw8SLumdeEN00dDObxs+zEzZJingUyjw
	U6fq/jGPOn2Zc+N1H2gS5sAbT65wcAwtU2Q9e7hBxZPbKLpxWsC9wG+beiVyBkl806Y5C2
	7dSrcg3bXyaKnxN0ei0U3L71uGgMUsI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783044523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twAjwEQPJQoMPii2nLtsAn0UlOpk5gfqaTEPYw4GO2E=;
	b=RFrw6T73G0dtH2YVDkNNMeQtP0PWo7FZpp27Af4eR/pqJq6vKaRVAFnCIGTnMZ7SW1BbO7
	WgFOwf8R70JX9KNq7XG7d1kMFKsOGJFZU0hekkUky0EdvIBlqpyuRO58uZ0BU9b6kV7Ie6
	JTY46OoQ03v2BrQISA/MMBXIITABXAU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UaMMeUw9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3qhlHagUKCFMACvv819916z.x97638FI-775Gvx5.9C1@flex--praan.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3qhlHagUKCFMACvv819916z.x97638FI-775Gvx5.9C1@flex--praan.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c88ad1558f4so107087a12.2
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 19:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783044522; x=1783649322; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=twAjwEQPJQoMPii2nLtsAn0UlOpk5gfqaTEPYw4GO2E=;
        b=UaMMeUw9yRRm+FrCYCiQfX5HH7uKizyPCyV3jLrSBECzJAN/1iSYPctNwq/GXQQcBK
         ZH/CZxof2rldRYuQoihD6djY/llnadCUVaYXZStvDXw+Q0orqOloNAreQnQluoUZh/zi
         /O0zaDwO88A1W/i4Z/S3a9YBdei/uJEodbzOIiCcLMvXyX1eQaEmFcye7HpjY8JXJp1s
         P9awFXoSwy/f0eMQUJM269RzOOH/tRLYz24sV4Rb+e9i35kgrODw3asPS9QhAViQfyYK
         MVXHFjUkh4Lxd2r4k9N1w+I1j4dTDEyOWjTYZu/XV7Wjj9biv/+Uhbpkg92ItAWfrAfp
         nDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783044522; x=1783649322;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=twAjwEQPJQoMPii2nLtsAn0UlOpk5gfqaTEPYw4GO2E=;
        b=PlbUJGphH+Upk4+N9iEPJfQgR73YFEsEYdcyscsb6bEZQWW54X9qfRTv9j8s3pTbRN
         7skqANA6v1UH9WXH+21Z5kIvXhawNN/ghE+15V1kHj5RApYv9ZTknxddTH0sBOFaGIIv
         KZ0KaAAzJudi8DRJrxVBQCwr1zA7b5Mi6IO2ZhpQm4lrMJFnT9Vh2PJNrhdfqFKRLIAq
         1LHCAaNKWe0OO1ds0eBG/1ASPjRzfDdk54BAOo6TvgdJNml3VOV26Ob/MF3TBCPa9NPN
         zvBRECEC9lAZmaqj7dUXWHeaiMVo/LuJQWBVHFqkWzNv9pgKOaPoppLqhRkvSFUQCUnD
         u1Ow==
X-Forwarded-Encrypted: i=1; AFNElJ+bBbB6Igm58x/9BXK4jLSYkOq1oXZ25npJDuwVDFQ+x3NZn4qUSmE+qApSYCNK75vY4c6NPUWT1A==@kvack.org
X-Gm-Message-State: AOJu0YzGCr6ZrcntZAP7RaISI+r8DSsVxaamNLkAOjmx/qwxM6JWTE6h
	g8g3d4epAmILJhf9H12kAmHrAnFKRSVe4qm0djA3AuUlTrmoDgJk5IbU4R+HM1E9/0YxiAPMo5K
	AYw==
X-Received: from pfbhx24.prod.google.com ([2002:a05:6a00:8998:b0:847:8ef2:f06b])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c8d:b0:847:81e2:2468
 with SMTP id d2e1a72fcca58-847c0674f36mr8855060b3a.4.1783044522128; Thu, 02
 Jul 2026 19:08:42 -0700 (PDT)
Date: Fri,  3 Jul 2026 02:08:31 +0000
In-Reply-To: <20260703020832.1731864-1-praan@google.com>
Mime-Version: 1.0
References: <20260703020832.1731864-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260703020832.1731864-4-praan@google.com>
Subject: [RFC PATCH 3/4] kho: Implement page-aware refcount restoration
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: d75mmdy68dgoyarmtxr5i5j9mutwif7z
X-Rspamd-Queue-Id: 82D2220002
X-HE-Tag: 1783044523-8287
X-HE-Meta: U2FsdGVkX18+WETzawVckEKaoFNIXuKZ9Za1nj2LWQbDEkOmLoDVfY+izGETaFJt0quEEwXS/QfU8CL/kBKkt+izj7VeMkf6nQDVnbye6s+F7ARlZ764O43rSA5WUqfO/ZgAaAoH4DcIJrhQ1XPKzgfTmp8WZP9l9QqjjvrSl6HNRl/R2P5UNTldHbNFadk4C93SBtQZuo1MlPFR5JcnNUYiCbwf0o13DCRD4WIsjmjkIeFXRXFvAbs1hqXXOu39+9/gmw7kkYSJNyvPPTFiVVO54k58ix3yh551dxe4Vk0EZe58epUtEzM6J4Utj+R4kyc1rb3XR/8MXEZdXjP3TA7hyznxlQmJtT5zaraOv9U60N+o7CXiDJF+0iwB2Rlv6EhRICIEnBoUHHjr4RZIC1ZGfOEkeOywoMxT1cBWIYkRl9xk3/zeJUPbAey79ziXpVeNPYx6DZ097/JynSBZAwBIZH4FR9wycO/xk4ZnU3vqPycA/5qYvSExQA9HSYwllLANuUqj3BgeqTk3QtzoWgePJ6MN+IC1fNJ0bQarS2HfutO+uQ1vLabFr/IfGOel5bRdbdzbVio3uEOrsjX0SbwP91KOxw0Uvi0YSA1/iW2HIvxNmKMmCr8SYqkf0WU6LGk2Q4VaYwTRWWjny1uPu6bGkG65P423VfNPcLJwiBbHZER8BQnMt6Tn62CQYCPO1waony7c7ZRg8T8qRfn64itHxolRds0iGdBeuUI9lA9kvEb9B+Clu4e4exXNYra8IYcGET3Z7IRk7GICc8P5FtyKTFw1LjxywrRCrwlm8v6QyZLnJ+6TSeblgRFs5zR93xN+xhjyMWkfRvTJQlHOizq0QentzJNKEsT2gmlWTedS0h6tiOLcf362TDUzGmHfyFqqQh8SMYrRlAxsXbY7S06jE8WfbLFrHSqUf3+MdJgLu1GlyD7YYk1CAVoLDZ9qmZouUWk5t6cDFlXICWF
 vbFQA1q6
 u2M63vx0GH++Y4IruvdGw9M6RxTG5ppf9L1br7fnrOM7udqh4q1zj48DMRbje8/jh9LECTfMlOD+wraTJAXWCwfYgAaa5i6bC/L8gJMOmoiT1TXnURoMnr7V8t8mxhB8a4CJJmiE0qiQmWW5YIL7EZ7Ed8wwsr/ElYUFQUoY8u6hJxIg+qpzJCd6yf8Hp1ta6xyBgUPJe9XbBWKxAH6Kg8i4uELUXwueiELMzfOXeV4NDXBGv/jvTqhn5NGwbMmQ+d/kJ4d70XloOH8jCQBu46Yf8qC946wrhqoCxorsc3vz/vv9+kdQI89AVNYeJCidZqBCxiEYMB4P4q5vtdullB6uypOvNoXR3tb/Tl+kjcdvDtbnO7MoMZ3Exi1sj7Yv+TsIzaroCRZzVOn6nRvxNvcAyCN59cGoPNQzrAEK6Jo1jgTiwsDjNP8IEMV8QMHGyU6wLPArdZrSeISK6Pg4pnuWoUsEnxeLXn4oIpN179DiosurrmXuR6J1C6IZfGi8DoqHqnNuoYoDiDwNx1C0+3Zbbh/DD3J3rx4mH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The KHO restoration logic currently forces a refcount of 1 on every
page of a multi-page block. While that is correct for split pages, it
violates the expectations of the buddy allocator for high-order
non-compound pages allocated by kernel user (like the DMA allocator),
where tail pages are expected to have a refcount of 0.

Update the restoration path to respect the preserved page type stored
in the page->private metadata. For KHO_PAGE_CONTIG blocks, only the
head page is given a reference count of 1. For KHO_PAGE_SPLIT blocks,
every page is given a reference count of 1.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 kernel/liveupdate/kexec_handover.c | 35 +++++++++++++++++-------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index d6e81f72fe5d..f6ca5e24c740 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -375,11 +375,18 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
 }
 EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
 
-/* For physically contiguous 0-order pages. */
-static void kho_init_pages(struct page *page, unsigned long nr_pages)
+/* For physically contiguous pages. */
+static void kho_restore_refcounts(struct page *page, unsigned long nr_pages,
+				  enum kho_page_type type)
 {
-	for (unsigned long i = 0; i < nr_pages; i++) {
-		set_page_count(page + i, 1);
+	/* Head page always gets refcount of 1. */
+	set_page_count(page, 1);
+	clear_page_tag_ref(page);
+
+	for (unsigned long i = 1; i < nr_pages; i++) {
+		unsigned int count = (type == KHO_PAGE_SPLIT) ? 1 : 0;
+
+		set_page_count(page + i, count);
 		/* Clear each page's codetag to avoid accounting mismatch. */
 		clear_page_tag_ref(page + i);
 	}
@@ -387,16 +394,7 @@ static void kho_init_pages(struct page *page, unsigned long nr_pages)
 
 static void kho_init_folio(struct page *page, unsigned int order)
 {
-	unsigned long nr_pages = (1 << order);
-
-	/* Head page gets refcount of 1. */
-	set_page_count(page, 1);
-	/* Clear head page's codetag to avoid accounting mismatch. */
-	clear_page_tag_ref(page);
-
-	/* For higher order folios, tail pages get a page count of zero. */
-	for (unsigned long i = 1; i < nr_pages; i++)
-		set_page_count(page + i, 0);
+	kho_restore_refcounts(page, 1 << order, KHO_PAGE_CONTIG);
 
 	if (order > 0)
 		prep_compound_page(page, order);
@@ -421,13 +419,20 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 		return NULL;
 	nr_pages = (1 << info.order);
 
+	/*
+	 * If we want to restore a folio, but the memory was split in the
+	 * previous kernel, something is wrong.
+	 */
+	if (WARN_ON_ONCE(is_folio && info.type == KHO_PAGE_SPLIT))
+		return NULL;
+
 	/* Clear private to make sure later restores on this page error out. */
 	page->private = 0;
 
 	if (is_folio)
 		kho_init_folio(page, info.order);
 	else
-		kho_init_pages(page, nr_pages);
+		kho_restore_refcounts(page, nr_pages, info.type);
 
 	adjust_managed_page_count(page, nr_pages);
 	return page;
-- 
2.55.0.rc0.799.gd6f94ed593-goog



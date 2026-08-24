Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E26F8C61DB4
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769756B0095; Mon, 24 Aug 2026 11:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656496B0099; Mon, 24 Aug 2026 11:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AAF76B009F; Mon, 24 Aug 2026 11:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F342F6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:29:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 698D814017B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:39 +0000 (UTC)
X-FDA: 85136547678.08.86C4558
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf24.hostedemail.com (Postfix) with ESMTP id A9CFD180009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WPezMAUt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3YGOMagYKCLMekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3YGOMagYKCLMekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxtYpttAkkFeNCs4heKfMrvlAQRBvH9LjM7sWbysPCs=;
	b=lJ8pAWPmX0LF/zuNlnDq3PLRiqiqOfwBLo5tYr+frxix69ZBdymqDAd5Id0q+tRzZWz0qj
	zZUPuTewv/ohio7d2hlzwI7oHQBc1HcnKHfmt1PbrPCywQEnhbTHeScb9a1oQ54S5ABLi9
	bt8ck64Q45MiO15y5bu2hNS53gEgctQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WPezMAUt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3YGOMagYKCLMekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3YGOMagYKCLMekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585377;
	b=qvfDlOaTg3Wb7k4Z+F3HZIH3QIrEsnaM22MHZ4fc42174+nVBjKF66yEpC4oyRNOV2XUPY
	2rgOGqn6N95sdjOuSZMmvUlkPnrymcT+4tvuSjEnaGApTOSvcwDR5JWtn5xFoIOH56fyXh
	qfWrG7KewO8OyOa5/xLvC2E4iS2e02c=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c20e5890680so124434466b.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787585376; x=1788190176; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XxtYpttAkkFeNCs4heKfMrvlAQRBvH9LjM7sWbysPCs=;
        b=WPezMAUtgsizyWZyN3dog791lebu4TkN2cHqwW1w/DOZz0CWH0xR/hgck89EnRM5nD
         LAW9NM3QFh0g5vB6ivqzqCG9FxyqcNQ7qo2J84e0JM9pib8i6SUTbi6vAfb2XHD8Eabl
         MT/cWUAth4OjqScuiHJoShXKhIB27rkG7lufK5Ar/zroDOApf2cHTnUcP9H1tigO5LQA
         IqdsWUcwQ0Nj8NsNHWZokIN0jwm884giP+yLtH2eYbg8Bll0r2Bsf3d547s6NSAmWTYu
         yMTm4FMYhQc5oX3GOxxtmyxyDyZ/be7mbFzW123ib9ms7VY0J2PYfqjGrIzcwYpfhGGE
         nXXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585376; x=1788190176;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XxtYpttAkkFeNCs4heKfMrvlAQRBvH9LjM7sWbysPCs=;
        b=CkHDFrCTQXg7+xulsFoPdr3Fg+Bvwi9gzHrqm+9nh5iFBCAlXFNgjbz7w2jDuxGaKG
         u8sLQrpSguOKiQ9d1nUVdnQOa3y5dIpCC4btNjSMzhApHXJRnjEP/40gPiJBrM9GxAct
         Bpt8+6SOp0zmmCQzOCwhWd4/e+ttV8AJrzfy+KBoED57zERDOs8WzJd2dIY+iVlYp0KC
         Nm0Q05ae+e4S9Ky30dZ1OaZnwzzzZS7yAsEIwF3S6qE6ngfomv1p1Qa1uRkSkDv9y/2r
         dqQsWUIQUSowPG9ZlqOQzg8wRFr/xF++L+2nNIOJqthjSNNgAapX/CuS1GX/FaegHhQx
         yHRw==
X-Forwarded-Encrypted: i=1; AHgh+RqPYQGFEvxBdN6zmTKuZWYMRQb2ynduK+a/Dg3UML3benW3ElT7yeVnUyCluHxqQdkZJZmDAbib2A==@kvack.org
X-Gm-Message-State: AFuF++kE+wtoc/hItwCROPVKlQTYmowkb+mOLKnugKG7D1Q7E6964x8N
	C4cbmBU3xAOF1FlXDoG1umFxnQah5g6MW8fxj3lTxVXhJy+Y8KkVlDc8UzulctHrmt8DyY44NzO
	s9yXV+w==
X-Received: from ejcfb18.prod.google.com ([2002:a17:907:3a12:b0:c21:94a2:c168])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:c245:b0:c24:6f95:4f0e
 with SMTP id a640c23a62f3a-c2492719d94mr2282288466b.18.1787585376193; Mon, 24
 Aug 2026 08:29:36 -0700 (PDT)
Date: Mon, 24 Aug 2026 15:29:28 +0000
In-Reply-To: <20260824152932.1583506-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20260615234220.3946885-1-lrizzo@google.com> <20260824152932.1583506-1-lrizzo@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824152932.1583506-2-lrizzo@google.com>
Subject: [PATCH v2 1/5] swiotlb: enforce pool nareas and nslabs invariants
From: Luigi Rizzo <lrizzo@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <lrizzo@google.com>, 
	Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dragos Tatulea <dtatulea@nvidia.com>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: A9CFD180009
X-Stat-Signature: p8auwdmky6uqhhjriuujwa4zy3mxgbzi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787585377-928187
X-HE-Meta: U2FsdGVkX19dVrcxI2pnY14UHaWv7Y2Ta5ivCzKh923oS7haeHihnPc3cWlRyQEIVnd62tK4rOcz3hc9EfYQ0A8arn1JKwBZDTrO1hmYYK8z36wOSeF0wK3XfCvk4uXAx6RSjQNSh6JTDWz3oVU8Yc0FrNQIU4ZxAzAW1q8tvsrcgJKzWu4+1bLyUExP0uyu2XPGcXPYMyDS21TOfc/x6X60HcLTFvqExD5X+TsjZb1t9aPJzc3BeG6I/5vNQdC4ZYrnZZgyr0mDJEOi1JTKA9KKpg1eFqOIJ2dWVQbRr3/CHCkZ3XOUZBioOC8nMJ4Vnrgy9+7aYwrca8cqh27jrC00K3hTxhTPHEl8n7cHd4gvuqw1W8WztjMZ2RNEb0he2kSM+EIlgt8utZSXEd+/k39+yhUDSvTwZMGck2XxnD8haLP/Oel3YffsURvibmM5Lh1n0NSPss3V+5xxSt5NRpU2tDeSh0UKg8PFrHHJfKDbh6B1ZSDxB60znqVtcD518h30kOPEHV/1Fj6yABObTGYovgUjCIHD+2ijtF/5YRfOU0ix6roFMDuvIGHEWLsoS6pcw/ozbXmbA4LNP1RIR7IUwbaiPx2h0AnRhWl8ZcsG0eH2ZE3whJrYEEz/Oz5dZnIdD/DgLiRaWLC5pAeNHCZv82cTeiQDPXnW64WlMrm3KHKEfLod2M491Hic9GXlvQneiiaSMiZ22tI9YFf1XY6l0wZM2Yew++5qCIo0qPOU3kZM2hhH20nySIAfuaTdxrVc9EfYpSBGJANfplEnAOBt60va/JXUgC5yRNsW+UlX0wXlkZ0mBqayRoX9CXLD1QYnIts5JTPmsGxMoOexsUJTJ+Xp4tvC4UQmeGP3CzBQurLXBVyq+ES/Bu40QTF387u+mrQ7p8d8BN9ovxEg1MVPiW/XnS+gLRRJ+JbOpc/7bP4ZAcRwbX7sk0IW8DuWedFsYELDHlUgYepzt/I
 oETwTrtq
 kzeD+oTuI6yLT8adq0KO+IcTnAU/dJiPnvupDpKxhdEO0v3BZvF2JdmFM/c24TTlXQE2jslBlJpCkfUqP92At9AOLLGVxCMUR0D2dXSWCn4/N+4b+/Mledxx6kqsfgBGtzZtGtrki95WIU/Idl2Oda3fxMOAlleJsuvk3qSAZY1ynbXsZU1Ugp6WzFWZknS4eOYWEuwdzmJEQKJZ2mDfXYmPfF0G7Bha9xcBCPlyfrk+EZoqaE02Pppm5rJ0AnYvBrQB4+J0pbDsKb62B4NVlh6kfRqtD5H3Ua6e0VZC5VL26ljeGvGEmCloHMAwCtBY9myudIR9JQGz4JB1GhgBVUxrmo+5MPPK6nScNWwWYKOpRg0WXWBLkXFoVaWfRLZ6Jl8bX1URD5EXbNinJPhw88KunW228QouZ2m/9DDDsJ/apFc2uCGaJT4bLM2O7rpHvxQ0bujTwTGzB2FmtGt4fy/VQhFO75gy1ojrdJMxFHYU9YfSvSpxpBrk+A6sO4XDAinHrleR+LsHd1nrj4AQuXU7vuXMoswGKeBFZG6cRQAXxyIFoEAtjQgIsrEbk+nu0pUTAbro7+i/ZQvc32FkOwUMXxZbSAbzkRWSS529BVtFDxO1GFHEBfYkN9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The SWIOTLB allocator relies on two runtime invariants across all
pool initialization paths:

1. pool->nareas must always be a power of two so that a slot's area
   can be located efficiently via bitwise masking (index & (nareas - 1))
   instead of integer division.
2. pool->nslabs must be a multiple of nareas * IO_TLB_SEGSIZE so that
   each area contains an integer multiple of IO_TLB_SEGSIZE (default 128)
   slots, preventing contiguous allocations from crossing area boundaries.

Enforce these invariants consistently during early boot, pool
initialization (swiotlb_init_io_tlb_pool), and restricted DMA pool setup.

Fixes: 8ac04063354a ("swiotlb: reduce the number of areas to match actual memory pool size")
Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 kernel/dma/swiotlb.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 1abd3e6146f45..8e4bd9d47735a 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -33,6 +33,7 @@
 #include <linux/kmsan-checks.h>
 #include <linux/iommu-helper.h>
 #include <linux/init.h>
+#include <linux/log2.h>
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/pfn.h>
@@ -176,7 +177,7 @@ static void swiotlb_adjust_nareas(unsigned int nareas)
 static unsigned int limit_nareas(unsigned int nareas, unsigned long nslots)
 {
 	if (nslots < nareas * IO_TLB_SEGSIZE)
-		return nslots / IO_TLB_SEGSIZE;
+		return rounddown_pow_of_two(nslots / IO_TLB_SEGSIZE);
 	return nareas;
 }
 
@@ -269,7 +270,16 @@ static void swiotlb_init_io_tlb_pool(struct io_tlb_pool *mem, phys_addr_t start,
 		unsigned long nslabs, bool late_alloc, unsigned int nareas)
 {
 	void *vaddr = phys_to_virt(start);
-	unsigned long bytes = nslabs << IO_TLB_SHIFT, i;
+	unsigned long bytes, i;
+
+	/*
+	 * If we have multiple areas, ensure each area's size is a multiple of
+	 * IO_TLB_SEGSIZE slots by aligning the total pool size down.
+	 */
+	if (nareas > 1)
+		nslabs = ALIGN_DOWN(nslabs, nareas * IO_TLB_SEGSIZE);
+
+	bytes = nslabs << IO_TLB_SHIFT;
 
 	mem->nslabs = nslabs;
 	mem->start = start;
@@ -1813,7 +1823,10 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 				    struct device *dev)
 {
 	struct io_tlb_mem *mem = rmem->priv;
-	unsigned long nslabs = rmem->size >> IO_TLB_SHIFT;
+	unsigned long nslabs = round_down(rmem->size >> IO_TLB_SHIFT, IO_TLB_SEGSIZE);
+
+	if (!nslabs)
+		return -EINVAL;
 
 	/* Set Per-device io tlb area to one */
 	unsigned int nareas = 1;
-- 
2.55.0.766.g2966f0265a-goog



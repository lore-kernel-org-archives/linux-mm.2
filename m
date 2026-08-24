Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4D78C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76CD16B00A7; Mon, 24 Aug 2026 11:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BE66B00A9; Mon, 24 Aug 2026 11:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4846B00AA; Mon, 24 Aug 2026 11:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA336B00A7
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:29:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97F111201A3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:44 +0000 (UTC)
X-FDA: 85136547888.17.24319EB
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf03.hostedemail.com (Postfix) with ESMTP id D63852000F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MGq4Dow5;
	spf=pass (imf03.hostedemail.com: domain of 3ZWOMagYKCLgjpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3ZWOMagYKCLgjpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPV7mwpWvFlRgLJpo7McYGSN9ACQlDljrVAQMeggU7g=;
	b=6/gO0rZnkDLjebxgTOp7OoBwiI3e/Io8VsI0IMxfZIqbXM8yPLhGCDYZxPMzoVaIH1uUoQ
	XWl9ZYvELiLfvRvSGMCbn28eBQA67masJ3tThMf81EsE/rg+WOHoWDrtU1HcOjEu1JSSo5
	RORYzuLFqTksUkEMz/B1dP9TJlcAysk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585382;
	b=psRumGiyvBpjwK9eZqGc+ci94V1pRWEmre+jGvJ0ZFGXXb64rJ9vxHTC6JlMQ+M2NBY6kQ
	zojIBGiRP+1iDhkMdazmYlyNwsfJZVdyXHZnErjhYs0X/YO575MDjoNkNGJSsIMK1Dc7OA
	7gVoVQsTsz5yrvA3e5caXmqWu8J5uXU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MGq4Dow5;
	spf=pass (imf03.hostedemail.com: domain of 3ZWOMagYKCLgjpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3ZWOMagYKCLgjpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a17c83732fso3839933a12.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787585381; x=1788190181; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JPV7mwpWvFlRgLJpo7McYGSN9ACQlDljrVAQMeggU7g=;
        b=MGq4Dow5PWYzj6SY95qekBebURY+/U73LZhoJx7TSrsUtO8iy8p/UkyiV0sNwfbi9j
         0gLTki8FbA5IChIZ2X/lEyPUSYmopiLqgeZ2st8FQpmXxIrAmTl0pDH37baC1fFoGUHD
         HrbOmrrdGAy+TsTt16/DZ/1qGFPfuoOB5/YSf5Dfzf/ilRbbGOOzkjvXf+WT4nspBwuw
         +jt6cKyGJ3/TimELRrVi0HGh6kj1rsoBwSt11iCjx2+llSybEDu7vB1ez7oN0Is/5K+e
         cKEHNFHEN0upl5TpR0e4MWkkXE3Fwo/8JWHTEXDTId9ehTyJvvnDAR5p1mxrySr2rFkT
         rHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585381; x=1788190181;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JPV7mwpWvFlRgLJpo7McYGSN9ACQlDljrVAQMeggU7g=;
        b=OuwfVhLW6uDtukeEaCrzGc5cMV2PGN5IrAIPoE1M4mYJGMZb4GNJnpezN1GzW3/zWZ
         30q88KcQFfOoZbBpAnW1kCdB6P6goKV0h8x0fjDVwYP2z762wE0Drv4EF+z/okS1Z7PN
         xDHQiqWyL5M+CDb4yAsCAtaYJa8xfKrV4L7F6zI/LH0iElUE6JGxZ2DevxoDAmUZSFnL
         UgwBl197ZbjQsBzZytg8qIZIaewgbCfzlBWGMt+X8yBjctmwVpx8B5SW6Eo6HBj8HKxc
         TSZW2lBZLxZnNsS/3Jmm173/gLnUQ49zK1aEcpVopc9goJxP90Wtzh5HiXQnd9U3vXTm
         9xog==
X-Forwarded-Encrypted: i=1; AHgh+RqlE16zAg42OW1HzcxZhUJ1cGFHISia2iuSff7QsKP3TVWqMw5NDbR3OICpG4A1/Cx/Dfn5hC1iew==@kvack.org
X-Gm-Message-State: AFuF++kuj2+QXDZvce8QMqdcEu+iHC6mUmMH9sJd9UZ1cOuAcu0PewzH
	v5wq2p1GmmOLgV/UISxkkQTMyacnv1bUUG+tE9pZt3HWFI6i9VTyaAY5V68qZKtRu56tnfriYQX
	LrvqxgQ==
X-Received: from edro3.prod.google.com ([2002:aa7:d3c3:0:b0:698:6d8c:dd8e])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:321a:b0:6a3:f3dc:d7f3
 with SMTP id 4fb4d7f45d1cf-6a42f216053mr33518684a12.16.1787585381419; Mon, 24
 Aug 2026 08:29:41 -0700 (PDT)
Date: Mon, 24 Aug 2026 15:29:32 +0000
In-Reply-To: <20260824152932.1583506-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20260615234220.3946885-1-lrizzo@google.com> <20260824152932.1583506-1-lrizzo@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824152932.1583506-6-lrizzo@google.com>
Subject: [PATCH v2 5/5] swiotlb: Implement RX nocopy with fast recycling eviction
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
X-Rspam-User: 
X-Stat-Signature: e5wsrc79dwz3a3sfrgjhzokzgxupyp5i
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D63852000F
X-HE-Tag: 1787585382-637204
X-HE-Meta: U2FsdGVkX19s2cVJnCHAZYMzLfGcJe9Gh5sRDz6xsJkdBx2i0Tqho4r3SNddUUBId8Xfk5xDmYi15fgCWLaG0g0md9wIwkRQ5pnwu0IZaF80HngxP0pB0WG6HTWTXVZzYWfthRetzPb2gBNozdqmG2Vzq89fGxAQLzDuqjJfK9reDxgjIXN6+0ytazwqYzuJ1K2LHiyYrHNblR3Cp/N6eSajWRVC1Bnh7VOLpcGUH1Hg7/821HsL0U9+qmCKEKtaDvhrDvyKQ/gisaV7FnMa9/P1YOj/rS1y01hRPoCAobzJLBBqiQ+lVbuRHUTWID+U8t6QdhoXRhlvdOZ4zl7orDmYv5yV32D+WiptGW4B9J/3psRGWYjOaqYmYiE7roa+DsuHixRrzVg/x2Te9PUcJalW+pnAp2PscFjBkKZPLMmMisYhnvEUXaN7tBaoNnEGyJzP8kWPXWyscZa7sLNt6xkdUVAwIn05DnuGJQRPz2Bo6/V5YGic5bI6afOfiO1ABrs8RJbkozSqy3XLjUl4kJmS/BlN6d777+r+YlLlFjmIdXZTm+IVmCdkPAMZD1GNJdvu3q4jgMy7m2pa2Y5N5zAeVBfsY2PVmAhCCc67UaVTFUVX/OlafwK3/HxQMRz36Hzwwh6J98P3Bvgu7X3QTUok51mLsbsa/xcBld1B9kjXIafCrfpFHn/I4w2n7b4ZdDyt9EYt8eiVao7kW2E5KCtM1hRTcDXEsgBXilBK2tBs/Sq4OEz3rry9KiHM0gsoMmR388RfuOnWIvtO+miJQ8LqjgKLwCtI5uKYAk8PlNjWxPy8stOGemr/vkOMOMfOsBb2dl5+ryrsrD390tLk/bhNMpz9T13cui4KYRSofBFer8yZuklEZ+Ya3w+kjiRPIs0l0d3A8eDOM6GGwP1ea1MUIaaChUYl9bNvbbK9cy5sMSQ1rKpPRSVEmSlh8+EUzd6w1N0VQwl4s1yGYQC
 lgB1S2uy
 DY2dhUcX0iYqcrIHnR56fpHZGn7ltSA2ICt/MhRDBnu/3TbFWcVAgB7aMl7oDYuKcTisVeB2qlwzClGUGQSjUXpopY7opnapDQO9QPPfLbNl2oOcQzL0XvxVnQohhfUIpBRaE5hubbpbmFPs0dZ4Qf/ocnKep7TUiE0uXFDBTdSK4py+yVmwD03mbBd1SxANS8JJgrO/4ushUIW4o8821bK4zswSeRNKF2sfCClvVmoNA+AYB6NBRmbREg8ARme5pgN7aci/NPD3SKp0GHrv54tyIe/uKGrsK+7csWjJQ8PXJyG4w00DNZ3Y7qi/Qi9smmB2Wx9pvxCp24JVpgFaDvnwkzJUPftRpI+UhtYixEtBP7tuGld3OPRllgeaMvjmO+TCSVvMIT27IXpv4YcMMn5Jv5gbbyk2A43lGeEPbg60g6ao+qC5/bKEBgykMQIJ41Iu61FZX/bqI5zoOOfuMsyznH56WLXXa279ZuWzuYYHE9NlwVfxfiimpZJPfZXmZtEzUk7KnDuYjOq28q1Gc6AGOI7oAO5iXGoQ5e7R3E9W5LVG/VtsUFcpz/Bk94Sw2MAlwwHMH2Fc2tcX8z3H7plkeXXNz3uSR79lZESWUG1zNMHLVtqvX3m7tr6jWoVLhbe1SClRRm/B/hQBNkxkXm9MS8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Conditionally divert receive buffer allocations in page_pool
to the SWIOTLB page allocator.

This only happens when swiotlb usage is below the threshold set by module
parameter swiotlb.nocopy_rx_percent (default 0, range 0..90).
A value of 0 disables the feature.

To prevent existing DRAM or SWIOTLB pages from circulating indefinitely
in the lockless receive ring after changing the parameter at runtime,
__page_pool_put_page() checks residency against the active parameter
state. Mismatched pages are immediately evicted back to their
respective allocators, achieving rapid, lockless mode conversion across
active network streams without requiring interface or queue resets.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/swiotlb.h |  1 +
 kernel/dma/swiotlb.c    |  5 +++++
 net/core/page_pool.c    | 25 ++++++++++++++++++++++---
 3 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 3baf52e6572d0..f4597fd01c52d 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -205,6 +205,7 @@ void swiotlb_destroy_compound_page(struct page *page, unsigned int order);
 void swiotlb_safe_put_device(struct device *dev);
 
 extern unsigned int nocopy_tx_percent;
+extern unsigned int nocopy_rx_percent;
 
 /* Track epoch (number of delete operations) for leaf device info. */
 extern atomic_t global_device_epoch;
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 7b818a796ff96..91f175c34a34e 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -129,6 +129,11 @@ struct io_tlb_slot {
 static bool swiotlb_force_bounce;
 static bool swiotlb_force_disable;
 
+/* enable nocopy rx swiotlb and set the percentage of buffers allowed for it. */
+unsigned int nocopy_rx_percent;
+module_param(nocopy_rx_percent, uint, 0644);
+MODULE_PARM_DESC(nocopy_rx_percent, "percentage of swiotlb buffer allowed for nocopy rx");
+
 #ifdef CONFIG_SWIOTLB_DYNAMIC
 
 static void swiotlb_dyn_alloc(struct work_struct *work);
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 50ee550fef73a..fe8839a7c70a8 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -19,6 +19,7 @@
 
 #include <linux/dma-direction.h>
 #include <linux/dma-mapping.h>
+#include <linux/swiotlb.h>
 #include <linux/page-flags.h>
 #include <linux/mm.h> /* for put_page() */
 #include <linux/poison.h>
@@ -578,10 +579,16 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem, gfp_t g
 static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 						 gfp_t gfp)
 {
+	unsigned int pct = READ_ONCE(nocopy_rx_percent);
 	struct page *page;
 
 	gfp |= __GFP_COMP;
-	page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
+	page = NULL;
+	if (pct && is_swiotlb_active(pool->p.dev))
+		page = swiotlb_alloc_pages(pool->p.dev, pool->p.order, gfp,
+					   pct);
+	if (!page)
+		page = alloc_pages_node(pool->p.nid, gfp, pool->p.order);
 	if (unlikely(!page))
 		return NULL;
 
@@ -616,8 +623,9 @@ static noinline netmem_ref __page_pool_alloc_netmems_slow(struct page_pool *pool
 	if ((gfp & GFP_ATOMIC) == GFP_ATOMIC)
 		gfp |= __GFP_NOWARN;
 
-	/* Don't support bulk alloc for high-order pages */
-	if (unlikely(pp_order))
+	/* Don't support bulk alloc for high-order pages or nocopy SWIOTLB */
+	if (unlikely(pp_order || (READ_ONCE(nocopy_rx_percent) &&
+				  is_swiotlb_active(pool->p.dev))))
 		return page_to_netmem(__page_pool_alloc_page_order(pool, gfp));
 
 	/* Unnecessary as alloc cache is empty, but guarantees zero count */
@@ -835,6 +843,17 @@ __page_pool_put_page(struct page_pool *pool, netmem_ref netmem,
 {
 	lockdep_assert_no_hardirq();
 
+	/*
+	 * If runtime nocopy mode toggled, evict circulating buffers immediately
+	 * back to their respective allocators rather than recycling them.
+	 */
+	if (unlikely(!netmem_is_net_iov(netmem) &&
+		     swiotlb_is_nocopy_addr(pool->p.dev, page_to_phys(netmem_to_page(netmem))) !=
+		     (READ_ONCE(nocopy_rx_percent) > 0))) {
+		page_pool_return_netmem(pool, netmem);
+		return 0;
+	}
+
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
 	 * regular page allocator APIs.
-- 
2.55.0.766.g2966f0265a-goog



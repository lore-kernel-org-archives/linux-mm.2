Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C839D39418
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 11:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692FE6B0088; Thu,  2 Apr 2026 07:26:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643246B0089; Thu,  2 Apr 2026 07:26:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559A66B008A; Thu,  2 Apr 2026 07:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42D186B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:26:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4EB659DDC
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:26:53 +0000 (UTC)
X-FDA: 84613388706.12.A55F0EA
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 08F5112000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:26:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=IwJ+ViV3;
	spf=pass (imf29.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775129211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hy/twRPYhbiir+MS1ZezR/NKFm6OHeTxxqJZFQB9PJY=;
	b=QR/z90On1IzZ5Ei3u8nN27dXpgMbnoP1HY4rkrJ8CuO6DNAQj1hsovBudqGegm5NvfKw3W
	drDhCyGW0XOdUwbx+InN9Q6GNFGAr1FNVHZTyIc9U2XtDXj4T3TlgZBATYHujrHg5UB3+I
	bLpjmwwPgFblo0zQVAKzSIesfZ3CJqA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=IwJ+ViV3;
	spf=pass (imf29.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775129211; a=rsa-sha256;
	cv=none;
	b=Nb3URhj/uqPq97MgnqvlvHvPpjEy3QUKhmjGzMCDeZI31kbtl16qV6xWUoxhP0AH4R7h5p
	mbliyEU1p8ucKQ9xBxCCFCoXKVzeHPxCjqGBg/HWF649osoOD6cXhCw3ifM0gqxUligy2R
	tIL6fCpAnjBkopXjAoFBA5fEJ9DKJ8Q=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260402112648euoutp01403ca42bf49d47a421efd202ca6c6e03~ihpxLoeG22288822888euoutp01y
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:26:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260402112648euoutp01403ca42bf49d47a421efd202ca6c6e03~ihpxLoeG22288822888euoutp01y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1775129209;
	bh=Hy/twRPYhbiir+MS1ZezR/NKFm6OHeTxxqJZFQB9PJY=;
	h=Date:From:Subject:To:Cc:In-Reply-To:References:From;
	b=IwJ+ViV3fVn8ffILzN1+oSKTdtPlqtT21PrIkH5/BQMaj/8kI/qfGXWbxMYJDctiz
	 i+YraefNVbY5fJzfoHlOr9B8zKq8rn1DA2V//EveiyX9g3bzwvUb4VC52OoJNuQdrq
	 82Tb77fuTcDwpqFGKil3reo97r1qMVk14qCuPFk8=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260402112648eucas1p2d6d3dffafe14d15bb776935b734d3e19~ihpwrX8Mr0663806638eucas1p2s;
	Thu,  2 Apr 2026 11:26:48 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260402112647eusmtip247f6a1ea586e1f285f816be2bae2700a~ihpvrdsMm3271332713eusmtip2X;
	Thu,  2 Apr 2026 11:26:47 +0000 (GMT)
Message-ID: <73ef4f64-498e-45a3-bea0-2a5f11e71b28@samsung.com>
Date: Thu, 2 Apr 2026 13:26:46 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2] dma-debug: suppress cacheline overlap warning when
 arch has no DMA alignment requirement
To: Robin Murphy <robin.murphy@arm.com>, Andy Shevchenko
	<andy.shevchenko@gmail.com>
Cc: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-mm@kvack.org,
	harry@kernel.org, vbabka@kernel.org, akpm@linux-foundation.org,
	stern@rowland.harvard.edu, linux@roeck-us.net, hch@lst.de,
	Jeff.kirsher@gmail.com, catalin.marinas@arm.com
Content-Language: en-US
In-Reply-To: <75f65aa7-4f89-4ef8-8941-51b1d54d1ad3@arm.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260402112648eucas1p2d6d3dffafe14d15bb776935b734d3e19
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260327124211eucas1p10425a28f67736d2043e7e4dd77d58e72
X-EPHeader: CA
X-CMS-RootMailID: 20260327124211eucas1p10425a28f67736d2043e7e4dd77d58e72
References: <CGME20260327124211eucas1p10425a28f67736d2043e7e4dd77d58e72@eucas1p1.samsung.com>
	<20260327124156.24820-1-mikhail.v.gavrilov@gmail.com>
	<6270d4f0-85e4-496d-8db4-87ccb791ca4d@samsung.com>
	<c9ded35b-fc10-47d8-bfaa-cecb4fa91add@arm.com>
	<CAHp75VdrGk=foAzQBJNRNDZ1yfFY8p-tC_ApM8_gN4EehpmN_Q@mail.gmail.com>
	<75f65aa7-4f89-4ef8-8941-51b1d54d1ad3@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08F5112000B
X-Stat-Signature: up38e3r57iyj8rjxnpgrqsrq3t8ttcx4
X-Rspam-User: 
X-HE-Tag: 1775129210-316885
X-HE-Meta: U2FsdGVkX1/96fqU82RRedIHut23G0bRYz9J2pidJVftWWhWDx/pihSMEN2vr9laahLeD6bVFxtdNM28ZUG3zVyXLzQiy7cgjPZ0sScqEWb3ws4D6ybO1UHt9PEG3x/xcDW0cHmEZJBEA1H8F+LlXSFThULo9cd5p5icWWOCKi0eJLrxFGGRL0LJTdUiPOXIEN4TQdIDUINSgCpsdP3wq0ZNZ1U5nOc1Aw47hNlb0p3K66kVsIrHZSdkGX4eQKaT8oyiZqaBTSlPNgIIs7WZy/4LtN5IYoxUismTQs2rITX8KnSeVMvd1okxfoPPEeYcZqEJiVhPBdFEKK8JLOrwaGSyJRjKawHEJpol4wXM7yaB+tIGowdwQXiJefIjMbbu8TQ+jM6BHGK5cutxQyoKIV713Bf6YMRA9imbCIzoRKcbaPBki56GBW/mfAgIJ7wBTLifMz5d383hKFIBv9buFR/18kbi0X+P5qHcCzteI4z8x4eNolGzwF7WbkuxCinT6OjryFjy8aaBIyTcR3ddXZxlEhwELJ/XSBFfe2K5DyqhnvdEXW1c7QPy3tcB8N6T0690KdWhPHpP8BpA1S+wuAe0FS7S20Af/U/NNtcf8kJZqYGGjyEECW6qJhIG97tyG6Xw262SRVTtw9ti2bznpj6bM2ycgT8P97PDZRFGCiNuRALj3bH1+WMn3T7H6Qa2MFHsu+D+KS+6hiTzJnEawGo/MDJFy81bl+PY3As3nv8Q+JmLBY7t1cILE2EMrzsijtvAlHSF65E8MNNgj3K3P4rVjW9+OwLqvD4uWS7tj1xsUxf/pmJgeX4oEP/xjLZNw0LHwQczHwguFgKA3xhokBHg4ckIe5dMJXStPjcq0oBWFhkaJFHqrSqb/Xc4EjGxI/itkj5jtgxSDI5SvKO9TfDwxuB6zJnKMl06APgcg1741d9uGnsgsoAg+kJsA8j+s9Bq4zEy3sByiEv0mzX
 HMsNUpev
 5TGJCtVilJgELs5U1+yseV5dKQTH2Law4u+mcPbD9Xv9d9Mu1jdMnvYGoEY15hw/0UOLtZATlOX2FBz1g7gOvT6gNFCZ7MKNc9RxgikhvoVAtBaCe3zLJo/MTmx/jJR+2CnNX3/kHRjFlMP8JF+f81BwLx49Hf6jgCiXrMem3Y3Y94atanIq7vcIjspodxW7vrl7UHcRDNYXmsD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.04.2026 17:26, Robin Murphy wrote:
> On 2026-04-01 2:25 pm, Andy Shevchenko wrote:
>> On Wed, Apr 1, 2026 at 3:11 PM Robin Murphy <robin.murphy@arm.com> wrote:
>>> On 2026-03-30 8:44 am, Marek Szyprowski wrote:
>>>> On 27.03.2026 13:41, Mikhail Gavrilov wrote:
>>
>> ...
>>
>>> TBH I'd be inclined to have CONFIG_DMA_DEBUG raise ARCH_DMA_MINALIGN as
>>> appropriate such that genuine false-positives can't happen, rather than
>>> effectively defeat the whole check,
>>
>> I dunno if you read v1 thread, where I proposed to unroll the check
>> and use pr_debug_once() for the cases which we expect not to panic,
>> but would be good to have a track of.
>
> I had not seen v1, as I took the last 3 days off and hadn't got that far up my inbox yet - I guess it's at least reassuring to have reached similar conclusions independently :)
>
> The fundamental issue here is that dma-debug doesn't realistically have a way to know whether the thing being mapped is intentionally a whole dedicated kmalloc allocation - where we can trust SLUB (and DMA_BOUNCE_UNALIGNED_KMALLOC if appropriate) to do the right thing across different systems - or just something which might happen to line up by coincidence on someone's development machine, but for portability they definitely do still need to take explicit care about (e.g. struct devres::data).


Right, the debug code cannot distinguish them. I'm still convinced that increasing
ARCH_DMA_MINALIGN when DEBUG is enabled is not a good idea. I also agree that the
current exceptions for DMA_BOUNCE_UNALIGNED_KMALLOC and dma_get_cache_alignment() <
L1_CACHE_BYTES are wider than really needed. What we can do about it?

For the (dma_get_cache_alignment() < L1_CACHE_BYTES) case I came up with the idea
of reducing the check only to the dma_get_cache_alignment()-size overlapping:


diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 86f87e43438c..9bf4b5c368f9 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -418,13 +418,13 @@ static void hash_bucket_del(struct dma_debug_entry *entry)
 static RADIX_TREE(dma_active_cacheline, GFP_ATOMIC | __GFP_NOWARN);
 static DEFINE_SPINLOCK(radix_lock);
 #define ACTIVE_CACHELINE_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
-#define CACHELINE_PER_PAGE_SHIFT (PAGE_SHIFT - L1_CACHE_SHIFT)
-#define CACHELINES_PER_PAGE (1 << CACHELINE_PER_PAGE_SHIFT)

 static phys_addr_t to_cacheline_number(struct dma_debug_entry *entry)
 {
-       return ((entry->paddr >> PAGE_SHIFT) << CACHELINE_PER_PAGE_SHIFT) +
-               (offset_in_page(entry->paddr) >> L1_CACHE_SHIFT);
+       if (dma_get_cache_alignment() >= L1_CACHE_BYTES)
+               return entry->paddr >> L1_CACHE_SHIFT;
+       else
+               return entry->paddr >> ilog2(dma_get_cache_alignment());
 }

 static int active_cacheline_read_overlap(phys_addr_t cln)


For the remaining cases (DMA_BOUNCE_UNALIGNED_KMALLOC mainly), based on the Catalin's
suggestion, I came up with the following idea:

diff --git a/kernel/dma/debug.c b/kernel/dma/debug.c
index 0677918f06a8..f9b6a989ac15 100644
--- a/kernel/dma/debug.c
+++ b/kernel/dma/debug.c
@@ -18,6 +18,7 @@
 #include <linux/uaccess.h>
 #include <linux/export.h>
 #include <linux/device.h>
+#include <linux/dma-direct.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/ctype.h>
@@ -590,6 +591,14 @@ static int dump_show(struct seq_file *seq, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(dump);

+static inline void dma_debug_fixup_bounced(struct dma_debug_entry *entry)
+{
+       if (IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
+           dma_kmalloc_needs_bounce(entry->dev, entry->size, entry->direction) &&
+           is_swiotlb_active(entry->dev))
+               entry->paddr = dma_to_phys(entry->dev, entry->dev_addr);
+}
+
 /*
  * Wrapper function for adding an entry to the hash.
  * This function takes care of locking itself.
@@ -601,6 +610,8 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
        unsigned long flags;
        int rc;

+       dma_debug_fixup_bounced(entry);
+
        entry->is_cache_clean = attrs & (DMA_ATTR_DEBUGGING_IGNORE_CACHELINES |
                                         DMA_ATTR_REQUIRE_COHERENT);

@@ -614,9 +625,7 @@ static void add_dma_entry(struct dma_debug_entry *entry, unsigned long attrs)
                global_disable = true;
        } else if (rc == -EEXIST &&
                   !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
-                  !(entry->is_cache_clean && overlap_cache_clean) &&
-                  !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
-                    is_swiotlb_active(entry->dev))) {
+                  !(entry->is_cache_clean && overlap_cache_clean)) {
                err_printk(entry->dev, entry,
                        "cacheline tracking EEXIST, overlapping mappings aren't supported\n");
        }
@@ -981,6 +990,8 @@ static void check_unmap(struct dma_debug_entry *ref)
        struct hash_bucket *bucket;
        unsigned long flags;

+       dma_debug_fixup_bounced(ref);
+
        bucket = get_hash_bucket(ref, &flags);
        entry = bucket_find_exact(bucket, ref);


What do You think about it? Both at least allows to detect errors like multiple,
incompatible mappings of the same memory.


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland



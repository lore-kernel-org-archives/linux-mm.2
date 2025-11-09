Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A1ACCFA18
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 02:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB188E000F; Sat,  8 Nov 2025 21:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B4F8E0003; Sat,  8 Nov 2025 21:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E753F8E000F; Sat,  8 Nov 2025 21:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE6AD8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 21:08:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6722A13BD74
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:08:08 +0000 (UTC)
X-FDA: 84089433456.30.060D609
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id 58EB640006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 02:08:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DXSgWEG6;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762654086;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRHokLAF/q17VZFE2sUBBiNZnx7Ac3gofK115AlTtXA=;
	b=WuP3RjDj7HCMQZVv1DwxfX3VuQ7ssbQaIj0dd5apWIZs9LET/p+87b82aWucszYXvh1wZR
	CRO2JUoujRRg6A8t2dhbrzTMz64cCzXLCCBi/IKFO29rDDYrlVJFVejeopuYMCdzW0/B94
	rVzf8fBnQzy5b3bh7SEVlbyMyjdYgQs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762654086; a=rsa-sha256;
	cv=none;
	b=lhUqvjoLfAudqZzXs2YbAinucjxArsBvmj1Iz8FBzW9r2xEtyCfLOoTe7eZl6N/11dVp5Y
	sSB5286EZuudyRq7mXuYzXXHNj5ys63nvBUfkkAA4WkoFDhqa9hc5Df8rGX+xiCfVvrpt+
	ewXN1jGcLzZXAt4/RNKyw5HUP8nymN8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DXSgWEG6;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640b4a52950so2962832a12.1
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 18:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762654085; x=1763258885; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRHokLAF/q17VZFE2sUBBiNZnx7Ac3gofK115AlTtXA=;
        b=DXSgWEG6NFsSe6nHE4oN4HGqxcjyg9p2BqEtkPWbhXzvYgEfEiNuL9vAR0oNrwCY1u
         IbQDJLYOpRpziC1ypzvimL4Ole+VqhOBlMBgy7oZgbM956DDU0Is53NNuJR0NOjq5KZo
         o6IXfhwbwWf3GHHh958EnKNQLRBt7UVdMi0/rdt2wej6Wy8U7oKDom6GUCtu+7TUoj3x
         caebw/Emd1o3zLA/tMspvZqI5wWXIcOBzJU/QXxvpFMUUpRoeB1aQK2+h2HIGrKCA0dU
         t/04IXLpiBvbUueJTWpL9e0OQWzOsoiZKM2cnSPT9LslqjhBkdwFnJ0dMViYxHaUW1vL
         Be5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762654085; x=1763258885;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IRHokLAF/q17VZFE2sUBBiNZnx7Ac3gofK115AlTtXA=;
        b=opAC+UUyRo3U5cBg7iG/eqF2BZq/aJE7NoBetJMzKLXmBEIV2wXdxe/+z9+QVlJJb/
         nn26X4d5SSR0QHTFWbF/Epv/WD8+S3Zoo785RZbRHYRd6irPF9RZCrAWehk03Czg2Lsc
         lruQE0f5sYVTyLfIcggEHiGGWSY14jNOROdV9t9aPUP1DOSSqkdnFjKKuT8yL0BOgH6U
         tB1Uw5zF7wc4JFccUAH7hbW+Vf2sgMs6WZqrG46Ro2A5BrBq4dcX+Wn8Wj1MyYshySEn
         3LVmHv8zOa9UOwMOpwDB5aFEeUCkoia7W2LvQSubHdnQbjcsUOBh8BI6NzY6CQDNnS1P
         sq2w==
X-Forwarded-Encrypted: i=1; AJvYcCVahYYBzRxZkPdw55hXqfvPtUA/znEm4285ooKX8ComhkTzln3wqYSyNr2dDSOSog/0/24d/NpvrQ==@kvack.org
X-Gm-Message-State: AOJu0YzMP2M/WjWN4sCO2MOGX0ANMadlHZskOmkdTKhmFFcq4wFmQVh+
	gmsoPArSgbQQXUKuz/4ubEMbWe4RUaZxWjfjLrHKG6oZQvGhtvmgmMDr
X-Gm-Gg: ASbGncvXz4U077Y2L/vfoOWRKoNmZejh1pSXChpm7x7pDdqmbe1W+Ug9IdFsaISqAtV
	hyXi3otMm7Gznl34qrSw6NF0dpeZFV26PlH2mQDLHLy1MVseparc0xD0APAbu6MTG5Du0H1AJmb
	bLBypwVz9s9ZZ9ZeLmAO/fBAM7yOaMq7jc063Lm/FJP0t2f1rM9FU3dOUWXMlsMzzfTL6vJlbAT
	SJl2xNW6qAbAop5exBAjUEHoCIOFQtY6gn0FOZmaxy7ldubslj1A7P/k891g1XniklYVes6tGd+
	CcnLyIycgpzojxoKvJm7UhOAlu4jkIvK8PemCqa+Tjf4gXYIPQFPiIydor4tylELV+cKXa8d7xp
	t1QS5fyleLScFzjN6IJaTq7j6Lt+gwYLobhrOYzi1hp2PTob54CzeRPULXQ4M8tR3T4SX/KEJFj
	RepZd8qfcu7g==
X-Google-Smtp-Source: AGHT+IFrhdbOBBwtJnhpa649VqXf7OJPVe3tNdIF6HQRQ4eHrJ1sdTvERcEapOjyZYnSHioMgX+QYw==
X-Received: by 2002:a17:907:3f97:b0:b70:f2c4:bdf2 with SMTP id a640c23a62f3a-b72e02dc592mr362361766b.23.1762654084427;
        Sat, 08 Nov 2025 18:08:04 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf9bd72bsm674183466b.49.2025.11.08.18.08.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 08 Nov 2025 18:08:03 -0800 (PST)
Date: Sun, 9 Nov 2025 02:08:02 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
	rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
	cl@gentwo.org, jglisse@google.com, surenb@google.com,
	zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
	mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 12/15] khugepaged: Introduce mTHP collapse
 support
Message-ID: <20251109020802.g6dytbixd4aygdgh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-13-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022183717.70829-13-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 58EB640006
X-Stat-Signature: 86rxugts5n9x8ds4sy37rcnyi4rrfhbu
X-HE-Tag: 1762654086-455822
X-HE-Meta: U2FsdGVkX18jNZU5MhlzqvAWZU6jx3UnQk9wca0Oq+0a8ekGoqBDFJnYKWXxLWtz/PnaxKS5kKgNKaJnDeSBwFe9p1FTi/3Km/sea3MgQyEXk7kTTl76MVjg/MWfcnOqN4prHIvxOMGCZJW6FRAo1juZQtmkpRPLObNabfk+3ml+qKwX7dK4BbCoxu7pK+RzocrenwjaX8/h0IiJ52Ha36c4TVew8ML9fYc49SMkSq4rW/K3eENb1vryxvly/tMqn4PkDo+e+6kC2P7FXsMzRXeX8EBnNKkVuQfM4shlc45511lSnUIERKuka/B76e1ebytbT1m3xbamDJVwZu3ae2LGD9N7tdpoSXCYYqx9HJWZMl3aTLfZ1/5+KzbJQUwP1E2kazjeOfwtX9DMrSeBU22hHj3WeF2uXKtBSfXxf3snbSQf2tkoeXdnIZMsRs1n2YCrb7v+wjVFDyqYJy1w7/vriS+FBo8CcA0aXgJbwMlmdnBuBuGUFcU932fess3+EfPa1IefUXW5KMpzpe+ApLFmqx/g8i35TIjCXaW4KN3p1V0JmjHcinuCZ9RMK5UlpwSw/oe+WTd3LTJCASigT7KjVU88OzVigVrcMqAaLU+aXumgASKJ5uvOtEnGlm7Qu/Macf9W95uffaaHV/gnT3SBHwPjq2Y0fI+jSQlhGQy461E9CY9Xa0J1PjwC73aCS6csKbWWbioG/YHa6tT9SGvbzCQwwfP3nU905i7L3vtvBTUIEldoE1VPARXBUzvnOrVPUOcGZ/EThtZl9opIxmHL0sXLhDjKI+V/ipY9+gwUjmAyWFS8gJlcKsJhFIf5S101NsnepWqIDcMzZX7+Lnpn8cLr7bP4E3ucS7f/IFGOlO4yPcuZfgY6YeEudMo4UMHvRNE/wJ60oswM8ukjgf6EffL0nT3gDzwNzutsjtuuxt2w+8SN6FuUU1YOWDKRbSncf4HdsZFPkChcwVC
 6OBCROLn
 +0zxnE9Upl3bjUnEZsEucUK6WvfXaWisEOM3AkRBLhnX8lFRvImAtbSRZ263zLveQtK+/7jcJ+200AxnP/NP51+BaWReMiSubxi0uZUlSlPrPamAGAXThCBG8j731tAZh/uu1CgjI9vcC+6JAalqme0GMDIL1LPHJKL9sDv8EndB2xWaM1zc2ryJByrPoZi3HqMNpbYKNtPuWeS7LtUTgkv/gV3nasxdGS6Zx70B8GY9M8oak3pY4FFG6xfFyO4fsGVoazcI1b5tPWTp9crAzN+Nscf1SKBWhOBpoNEu08wmRCwVMy1NBfnB9d4VUnm8WAfbEL5ip7CxY2SClEstjAd26aXEUJKNWfKRVZBkTuzu6upABv1+/dTKJpZI71FjkxW7P2knyJePxrRxZaH62CDZpcbtCvDbqD6/4FKSkexYB8iswqVpaGwkL8qlnt2hTmy1rnHdxe/sCzpHKB1R7CtwrYyyP70I8Q749QFoRBh/etRIK2iOzThuoNdH9EAKPL1hnYXlxL4m4yQafk6YqEeCovr2mK891b4sqD3QyKs0sDHHGI/vzvJphlVSDZzvF1Fcs0vkQ+zf9Xh6mKT13dZxW9NoP4rsRbpJuEmKLhV1c0KoM8uA3CmvOjjLCjx9Hpr1LCKnraTm6ihp8xndnQ+4gyodgs9Vot7V+dVbuCHpWVYIC6+ta+RtJ89m21gDQEGIOaf2wZ9REdIUtiu1wX34rEZNdcKVinKSDI04rtKn9Bg6BG+sfPPjUMfug2eEurp02jPkrEZ8yhyY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:37:14PM -0600, Nico Pache wrote:
>During PMD range scanning, track occupied pages in a bitmap. If mTHPs are
>enabled we remove the restriction of max_ptes_none during the scan phase
>to avoid missing potential mTHP candidates.
>
>Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
>and determine the best eligible order for the collapse. A stack struct is
>used instead of traditional recursion. The algorithm splits the bitmap
>into smaller chunks to find the best fit mTHP.  max_ptes_none is scaled by
>the attempted collapse order to determine how "full" an order must be
>before being considered for collapse.
>
>Once we determine what mTHP sizes fits best in that PMD range a collapse
>is attempted. A minimum collapse order of 2 is used as this is the lowest
>order supported by anon memory.
>
>mTHP collapses reject regions containing swapped out or shared pages.
>This is because adding new entries can lead to new none pages, and these
>may lead to constant promotion into a higher order (m)THP. A similar
>issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
>introducing at least 2x the number of pages, and on a future scan will
>satisfy the promotion condition once again. This issue is prevented via
>the collapse_allowable_orders() function.
>
>Currently madv_collapse is not supported and will only attempt PMD
>collapse.
>
>We can also remove the check for is_khugepaged inside the PMD scan as
>the collapse_max_ptes_none() function handles this logic now.
>
>Signed-off-by: Nico Pache <npache@redhat.com>

Generally LGTM.

Some nit below.

>---
> include/linux/khugepaged.h |   2 +
> mm/khugepaged.c            | 128 ++++++++++++++++++++++++++++++++++---
> 2 files changed, 122 insertions(+), 8 deletions(-)
>
>diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
>index eb1946a70cff..179ce716e769 100644
>--- a/include/linux/khugepaged.h
>+++ b/include/linux/khugepaged.h
>@@ -1,6 +1,8 @@
> /* SPDX-License-Identifier: GPL-2.0 */
> #ifndef _LINUX_KHUGEPAGED_H
> #define _LINUX_KHUGEPAGED_H
>+#define KHUGEPAGED_MIN_MTHP_ORDER	2
>+#define MAX_MTHP_BITMAP_STACK	(1UL << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
> 
> #include <linux/mm.h>
> 
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index 89a105124790..e2319bfd0065 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -93,6 +93,11 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
> 
> static struct kmem_cache *mm_slot_cache __ro_after_init;
> 
>+struct scan_bit_state {
>+	u8 order;
>+	u16 offset;
>+};
>+
> struct collapse_control {
> 	bool is_khugepaged;
> 
>@@ -101,6 +106,13 @@ struct collapse_control {
> 
> 	/* nodemask for allocation fallback */
> 	nodemask_t alloc_nmask;
>+
>+	/*
>+	 * bitmap used to collapse mTHP sizes.
>+	 */
>+	 DECLARE_BITMAP(mthp_bitmap, HPAGE_PMD_NR);
>+	 DECLARE_BITMAP(mthp_bitmap_mask, HPAGE_PMD_NR);
>+	struct scan_bit_state mthp_bitmap_stack[MAX_MTHP_BITMAP_STACK];

Looks like an indent issue.

> };
> 
> /**
>@@ -1357,6 +1369,85 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long pmd_address,
> 	return result;
> }
> 
>+static void push_mthp_bitmap_stack(struct collapse_control *cc, int *top,
>+				   u8 order, u16 offset)
>+{
>+	cc->mthp_bitmap_stack[++*top] = (struct scan_bit_state)
>+		{ order, offset };
>+}
>+

For me, I may introduce pop_mth_bitmap_stack() .

And use it ...

>+/*
>+ * collapse_scan_bitmap() consumes the bitmap that is generated during
>+ * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
>+ *
>+ * Each bit in the bitmap represents a single occupied (!none/zero) page.
>+ * A stack structure cc->mthp_bitmap_stack is used to check different regions
>+ * of the bitmap for collapse eligibility. We start at the PMD order and
>+ * check if it is eligible for collapse; if not, we add two entries to the
>+ * stack at a lower order to represent the left and right halves of the region.
>+ *
>+ * For each region, we calculate the number of set bits and compare it
>+ * against a threshold derived from collapse_max_ptes_none(). A region is
>+ * eligible if the number of set bits exceeds this threshold.
>+ */
>+static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
>+		int referenced, int unmapped, struct collapse_control *cc,
>+		bool *mmap_locked, unsigned long enabled_orders)
>+{
>+	u8 order, next_order;
>+	u16 offset, mid_offset;
>+	int num_chunks;
>+	int bits_set, threshold_bits;
>+	int top = -1;
>+	int collapsed = 0;
>+	int ret;
>+	struct scan_bit_state state;
>+	unsigned int max_none_ptes;
>+
>+	push_mthp_bitmap_stack(cc, &top, HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER, 0);
>+
>+	while (top >= 0) {
>+		state = cc->mthp_bitmap_stack[top--];

... here.

>+		order = state.order + KHUGEPAGED_MIN_MTHP_ORDER;

We push real_order - KHUGEPAGED_MIN_MTHP_ORDER, and get it by add
KHUGEPAGED_MIN_MTHP_ORDER.

Maybe we can push real_order ...

>+		offset = state.offset;
>+		num_chunks = 1UL << order;
>+
>+		/* Skip mTHP orders that are not enabled */
>+		if (!test_bit(order, &enabled_orders))
>+			goto next_order;
>+
>+		max_none_ptes = collapse_max_ptes_none(order, !cc->is_khugepaged);
>+
>+		/* Calculate weight of the range */
>+		bitmap_zero(cc->mthp_bitmap_mask, HPAGE_PMD_NR);
>+		bitmap_set(cc->mthp_bitmap_mask, offset, num_chunks);
>+		bits_set = bitmap_weight_and(cc->mthp_bitmap,
>+					     cc->mthp_bitmap_mask, HPAGE_PMD_NR);
>+
>+		threshold_bits = (1UL << order) - max_none_ptes - 1;
>+
>+		/* Check if the region is eligible based on the threshold */
>+		if (bits_set > threshold_bits) {
>+			ret = collapse_huge_page(mm, address, referenced,
>+						 unmapped, cc, mmap_locked,
>+						 order, offset);
>+			if (ret == SCAN_SUCCEED) {
>+				collapsed += 1UL << order;
>+				continue;
>+			}
>+		}
>+
>+next_order:
>+		if (state.order > 0) {

...and if (order > KHUGEPAGED_MIN_MTHP_ORDER) here?

Not sure you would like it.

>+			next_order = state.order - 1;
>+			mid_offset = offset + (num_chunks / 2);
>+			push_mthp_bitmap_stack(cc, &top, next_order, mid_offset);
>+			push_mthp_bitmap_stack(cc, &top, next_order, offset);
>+		}
>+	}
>+	return collapsed;
>+}
>+
> static int collapse_scan_pmd(struct mm_struct *mm,
> 			     struct vm_area_struct *vma,
> 			     unsigned long start_addr, bool *mmap_locked,
>@@ -1364,11 +1455,15 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> {
> 	pmd_t *pmd;
> 	pte_t *pte, *_pte;
>+	int i;
> 	int result = SCAN_FAIL, referenced = 0;
>-	int none_or_zero = 0, shared = 0;
>+	int none_or_zero = 0, shared = 0, nr_collapsed = 0;
> 	struct page *page = NULL;
>+	unsigned int max_ptes_none;
> 	struct folio *folio = NULL;
> 	unsigned long addr;
>+	unsigned long enabled_orders;
>+	bool full_scan = true;
> 	spinlock_t *ptl;
> 	int node = NUMA_NO_NODE, unmapped = 0;
> 
>@@ -1378,16 +1473,29 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> 	if (result != SCAN_SUCCEED)
> 		goto out;
> 
>+	bitmap_zero(cc->mthp_bitmap, HPAGE_PMD_NR);
> 	memset(cc->node_load, 0, sizeof(cc->node_load));
> 	nodes_clear(cc->alloc_nmask);
>+
>+	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, cc->is_khugepaged);
>+
>+	/*
>+	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
>+	 * scan all pages to populate the bitmap for mTHP collapse.
>+	 */
>+	if (cc->is_khugepaged && enabled_orders == _BITUL(HPAGE_PMD_ORDER))

We sometimes use BIT(), e.g. in collapse_allowable_orders().
And sometimes use _BITUL().

Suggest to use the same form.

Nothing else, great job!

>+		full_scan = false;
>+	max_ptes_none = collapse_max_ptes_none(HPAGE_PMD_ORDER, full_scan);
>+
> 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> 	if (!pte) {
> 		result = SCAN_PMD_NULL;
> 		goto out;
> 	}
> 
>-	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>-	     _pte++, addr += PAGE_SIZE) {
>+	for (i = 0; i < HPAGE_PMD_NR; i++) {
>+		_pte = pte + i;
>+		addr = start_addr + i * PAGE_SIZE;
> 		pte_t pteval = ptep_get(_pte);
> 		if (is_swap_pte(pteval)) {
> 			++unmapped;
>@@ -1412,8 +1520,7 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> 		if (pte_none_or_zero(pteval)) {
> 			++none_or_zero;
> 			if (!userfaultfd_armed(vma) &&
>-			    (!cc->is_khugepaged ||
>-			     none_or_zero <= khugepaged_max_ptes_none)) {
>+			    none_or_zero <= max_ptes_none) {
> 				continue;
> 			} else {
> 				result = SCAN_EXCEED_NONE_PTE;
>@@ -1461,6 +1568,8 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> 			}
> 		}
> 
>+		/* Set bit for occupied pages */
>+		bitmap_set(cc->mthp_bitmap, i, 1);
> 		/*
> 		 * Record which node the original page is from and save this
> 		 * information to cc->node_load[].
>@@ -1517,9 +1626,12 @@ static int collapse_scan_pmd(struct mm_struct *mm,
> out_unmap:
> 	pte_unmap_unlock(pte, ptl);
> 	if (result == SCAN_SUCCEED) {
>-		result = collapse_huge_page(mm, start_addr, referenced,
>-					    unmapped, cc, mmap_locked,
>-					    HPAGE_PMD_ORDER, 0);
>+		nr_collapsed = collapse_scan_bitmap(mm, start_addr, referenced, unmapped,
>+					      cc, mmap_locked, enabled_orders);
>+		if (nr_collapsed > 0)
>+			result = SCAN_SUCCEED;
>+		else
>+			result = SCAN_FAIL;
> 	}
> out:
> 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
>-- 
>2.51.0

-- 
Wei Yang
Help you, Help me


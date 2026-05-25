Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED9C7CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DCC6B0005; Mon, 25 May 2026 10:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F116B0088; Mon, 25 May 2026 10:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20D86B008A; Mon, 25 May 2026 10:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8ABE6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:15:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34B481C0386
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:15:07 +0000 (UTC)
X-FDA: 84806139054.25.002BD85
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id BF923C000F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:15:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zd4WLsk9;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779718504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itKpTuLYIUvP30cNjWVOPkjnvKVCYDW9rRvfBThd6oI=;
	b=bKVI5h4j6DyRSSgsOHiwWz76zIzwb3RdINc94ce9jwBFgKIRZhke4BQX7pclvZLSVJB7Hs
	oL9NE12w1syeBBk3OuZ7l7DBbWbSI0CkSvb9uzhVdWwtogtB2DfWYPaSea1vEzrw1ISlRd
	RQAZtIvc7J7zJN2i6Vj6dG2h1TGRnVc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zd4WLsk9;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779718504; a=rsa-sha256;
	cv=none;
	b=2yMMy9O9Nd4or2eZ/BWnlzGE0LKPCUqBe5vEJtDnpeLkS753CpGp10MxYKHtOwX3eSsFo1
	f6K6wl+dIOJsMEhgOxP9/8jVk1d4QLIhx2X419H1HU19iXbcaD3arSNox2NhsIuLvDGv9+
	ol212wlEwOEkmVo6UsGNjHzbe7brzyc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779718504;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=itKpTuLYIUvP30cNjWVOPkjnvKVCYDW9rRvfBThd6oI=;
	b=Zd4WLsk9uBDH2eySIZ7eL6N/P+fh3q15ZnI1gw/AuOg95VebkLPl8asBl8d/NJELuN+GmD
	nMBW+fi7wlw2Na+0jWQ+CFBzN6G3i3UosGNleGDWIVTj8uYm/UXgUAF9fpKxk1oAWSsm85
	6q160ZKOD5w/E21NgZf/s2WIaP8zZYs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-xASu2U4rM3KtU6FIW_vKxQ-1; Mon, 25 May 2026 10:15:02 -0400
X-MC-Unique: xASu2U4rM3KtU6FIW_vKxQ-1
X-Mimecast-MFC-AGG-ID: xASu2U4rM3KtU6FIW_vKxQ_1779718502
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso6626676f8f.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 07:15:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779718501; x=1780323301;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=itKpTuLYIUvP30cNjWVOPkjnvKVCYDW9rRvfBThd6oI=;
        b=a+gxAqFjhdGzSevU+5/jarve0M14bZtkf6brvmdRzAXRk+NTprDhcJAX01dij2fSzM
         kgUGJ7ZJDAhHmnrqErW7j3wPiWsYGnBdPlu/K0itQB5DZxfn9tQQeKokC5lbOQqwEhJH
         Rs26+++rthtU7/MdCD4IZhym6AxMJmtE88PVPO9LOwPT3v9izQE7uMpM/VvipOB5zLr6
         it+SxFRs+t6MJMqwxwgfjzqXGH5D4B+zy//q1w+c9eBwYqMqTh35g1vqLwalbvRksQAo
         ZqYI8u7m/p6CKE6RkkoLVA0aydipVIslfuky1c7k+a6RcCvvNF9juuMLxfZqdT6JEmVD
         F42g==
X-Forwarded-Encrypted: i=1; AFNElJ8s1VkpSnt4BzKquMZoFEBpeACcexH/IIluoH6lx/2Je7OfiiyRUGj5+qzzZGBOWHrjZJVAf4vDEQ==@kvack.org
X-Gm-Message-State: AOJu0YxO2QzacazKbJK2lbiZA3VNQaIJdrkWtODV/03wqBdt8uQHwbWO
	y2VBUSmF3FAqFwOI02s0ZV98Ml/Oq6g+7L1gTrLvsRIHZ6rEZZdf43qeyuRBwaQOI4J5SlewBxT
	jYEAOX1AbFt7rrCwY3IusE5+8fWXlRe0jPaaRp769p2gHvBp1XP0j
X-Gm-Gg: Acq92OHEtVS4AvC04GGwxCr5m+BEUS6vOPwUrMVLKvHuUBeX0FkHk+0pbuDjFcpWOfx
	yHqMrcnOamVQ9vxBhaxy09FlBqG+w2wyuAesx6xKTjl67fhYbf6/0VfcNv4/OYxKUg9LOYq4sRl
	yJ3t2AtBzSSnNpDr1ULGnYRrHkA/1zyDNibr44I5FeghQFW7C+nYaeRFNwVJcclz3CSMy23Ldi9
	nGLo3YBlWmpR0QG5kzoGYL3De2y4lNod7vExj1jCak8DGWxVwQHaXl69aiJOgt1F/p3luQV1ylw
	hWY63QQVCo3g4Nz74xChnTWx4R/psrZcQoUsbdT3TKgS62Up0qfauJZSVyOb10OXJtxS7cTsvvT
	8J3HTYOeNIxQCbtC0xsr+BEA=
X-Received: by 2002:a05:6000:1882:b0:44a:2cb3:b633 with SMTP id ffacd0b85a97d-45eb3681134mr25369602f8f.12.1779718501181;
        Mon, 25 May 2026 07:15:01 -0700 (PDT)
X-Received: by 2002:a05:6000:1882:b0:44a:2cb3:b633 with SMTP id ffacd0b85a97d-45eb3681134mr25369452f8f.12.1779718500520;
        Mon, 25 May 2026 07:15:00 -0700 (PDT)
Received: from [192.168.1.144] ([88.147.84.123])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d48e23sm26489805f8f.20.2026.05.25.07.14.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 07:14:59 -0700 (PDT)
Message-ID: <2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com>
Date: Mon, 25 May 2026 08:15:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 akpm@linux-foundation.org
Cc: aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260522150009.121603-12-npache@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p87bL2XcyIkUu8wm1mwY5pzdGBaAGA6mtBjOO1JaF3E_1779718502
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k9zh7ystobmwsu7g9grhdpgr7jceqejq
X-Rspamd-Queue-Id: BF923C000F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779718504-661119
X-HE-Meta: U2FsdGVkX19MjozJFtSYm3mvKL2AMRH2crNDK+KNQeZaaDvE3hahTXyMpIroBlAQSEY3ogCLijYCpu9nfmc9CGOvwXXQJzhRm1OObPjy+F1XyZwUieMgVJktnp/loe73aCNnX2y2HNnyVT810JAYqfTScPfeD9i4zyfgWEFaNir/90799puE0UCyDMIRDrXtG6hwC0GOEfdinGnvBSXVLj0NlR/mdI+5E8wA16mHDGl8zElF9JEw6BN/lpMxY8+xkeKjkkTIu1ilTtfzy7z8jfjLG+cCUhHl9YuVfjpdz4Fb6V6Pqm42WXL7s0rlZNP5yDL7S74/ge1bhMueWm5f/JTtCUd+nlvXlLKYFb3K7ZMVgiy2lkehMxue0o0O+ZDOKGYL+O/H6dMnm75GBZdLgIkKKf/aor8SbVhi8N/IJ7sq8461tCNJqOvGzsyCEqCd7Kt+Coae9lwcRtsh5oM0d7FXcuW4JceeDSpCce1KoZU20f+a1LH3BBu5HFaMVdwAbhACbXNDfSVYRFbt+iBoud+eVQthltBStTQj90FQOk92buxFxCr6g0puaSuttkdbxaqzcRRYz1NnuYnqVjsnxRE2zKQdlQQkhqmbhBKkvYNjAMjTQx5JIyGdFMUJRpGONYM01/JRmtGtLglFZLlYaotj2hFrM7fL6UDfKrscVNroIkQ3hgKJ5W6CeP+0qM0LWzxVu5DFFcER7ZtS2Ev+a7CQenjh+JzT1P5KGruQr1HJBSOCeE+ZDYozOyvVj2PbUPjEScXiS2m8V1ZtL2adpOkx4K+/wGVd8d7ocuFpSx4E+BjJOWmV7+7TL5LPj81SdEIZS+Oi8i9eps2GlN1O45YzxC88Ha7ytb3UnQ8AXKjMN54DOhdGPqXlxyFm05akVFtBkJQiAtr/MREnmb121K4zxP1Z1NtSrBQUXPobzt9Gzn/5092ovy/RYY9PMkb5ie/m2DIZzbCE3qRugdj
 mTN7VmCC
 /uPy9Pjwxfn3VsJcKLaMjkxzp+ZnUbHZX1ugs7QKsWuMTtueJJuGoKxsdujvGFLK7uuJ98YSjRo27mmEcyT510K6QafJT+5usJEmHbiXIbZNKgrNavuUm7bU74azZhsHPu0VDCkqPU541wlFPy8MY5I65KHz+1V7VgTHww5GxQs43W8nfsQjqEiZ6k8uO4jUZIEOGPWPMLUSHJYitsohhF+OVc9H0aDHHZIquLpO9/sQQyNfmAnhx/bhAyPImTARQ5hVkLOsdUbNkKp+5Nw08B0TEKdpQ3v2Pm9coGdBSuIte6Nu639C0o113iMyIyX8lUjyF9IfrgBZCuUMF9bCjKT5fiswYTlYSFuPWzcW/XZG+akKTvTlaaBihYPDitIXkK4mMVt1BrhWKU4YH5wMStByPsa28FBoaJmBV+aQdOEcgzBICV2CAyU9QsBIz9nyGbSO0fDWLuXi+lNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 5/22/26 9:00 AM, Nico Pache wrote:
> Enable khugepaged to collapse to mTHP orders. This patch implements the
> main scanning logic using a bitmap to track occupied pages and a stack
> structure that allows us to find optimal collapse sizes.
>
> Previous to this patch, PMD collapse had 3 main phases, a light weight
> scanning phase (mmap_read_lock) that determines a potential PMD
> collapse, an alloc phase (mmap unlocked), then finally heavier collapse
> phase (mmap_write_lock).
>
> To enabled mTHP collapse we make the following changes:
>
> During PMD scan phase, track occupied pages in a bitmap. When mTHP
> orders are enabled, we remove the restriction of max_ptes_none during the
> scan phase to avoid missing potential mTHP collapse candidates. Once we
> have scanned the full PMD range and updated the bitmap to track occupied
> pages, we use the bitmap to find the optimal mTHP size.
>
> Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
> and determine the best eligible order for the collapse. A stack structure
> is used instead of traditional recursion to manage the search. This also
> prevents a traditional recursive approach when the kernel stack struct is
> limited. The algorithm recursively splits the bitmap into smaller chunks to
> find the highest order mTHPs that satisfy the collapse criteria. We start
> by attempting the PMD order, then moved on the consecutively lower orders
> (mTHP collapse). The stack maintains a pair of variables (offset, order),
> indicating the number of PTEs from the start of the PMD, and the order of
> the potential collapse candidate.
>
> The algorithm for consuming the bitmap works as such:
>      1) push (0, HPAGE_PMD_ORDER) onto the stack
>      2) pop the stack
>      3) check if the number of set bits in that (offset,order) pair
>         statisfy the max_ptes_none threshold for that order
>      4) if yes, attempt collapse
>      5) if no (or collapse fails), push two new stack items representing
>         the left and right halves of the current bitmap range, at the
>         next lower order
>      6) repeat at step (2) until stack is empty.
>
> Below is a diagram representing the algorithm and stack items:
>
>                              offset   mid_offset
>                              |        |
>                              |        |
>                              v        v
>            ____________________________________
>           |          PTE Page Table            |
>           --------------------------------------
> 			    <-------><------->
>                               order-1  order-1
>
> mTHP collapses reject regions containing swapped out or shared pages.
> This is because adding new entries can lead to new none pages, and these
> may lead to constant promotion into a higher order mTHP. A similar
> issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
> introducing at least 2x the number of pages, and on a future scan will
> satisfy the promotion condition once again. This issue is prevented via
> the collapse_max_ptes_none() function which imposes the max_ptes_none
> restrictions above.
>
> We currently only support mTHP collapse for max_ptes_none values of 0
> and HPAGE_PMD_NR - 1. resulting in the following behavior:
>
>      - max_ptes_none=0: Never introduce new empty pages during collapse
>      - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>        available mTHP order
>
> Any other max_ptes_none value will emit a warning and default mTHP
> collapse to max_ptes_none=0. There should be no behavior change for PMD
> collapse.
>
> Once we determine what mTHP sizes fits best in that PMD range a collapse
> is attempted. A minimum collapse order of 2 is used as this is the lowest
> order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>
> Currently madv_collapse is not supported and will only attempt PMD
> collapse.
>
> We can also remove the check for is_khugepaged inside the PMD scan as
> the collapse_max_ptes_none() function handles this logic now.
>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>   mm/khugepaged.c | 181 +++++++++++++++++++++++++++++++++++++++++++++---
>   1 file changed, 172 insertions(+), 9 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 64ceebc9d8a7..d3d7db8be26c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -99,6 +99,30 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>   
>   static struct kmem_cache *mm_slot_cache __ro_after_init;
>   
> +#define KHUGEPAGED_MIN_MTHP_ORDER	2
> +/*
> + * mthp_collapse() does an iterative DFS over a binary tree, from
> + * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
> + * size needed for a DFS on a binary tree is height + 1, where
> + * height = HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
> + *
> + * ilog2 is used in place of HPAGE_PMD_ORDER because some architectures
> + * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build time.
> + */
> +#define MTHP_STACK_SIZE	(ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER + 1)
> +
> +/*
> + * Defines a range of PTE entries in a PTE page table which are being
> + * considered for mTHP collapse.
> + *
> + * @offset: the offset of the first PTE entry in a PMD range.
> + * @order: the order of the PTE entries being considered for collapse.
> + */
> +struct mthp_range {
> +	u16 offset;
> +	u8 order;
> +};
> +
>   struct collapse_control {
>   	bool is_khugepaged;
>   
> @@ -110,6 +134,12 @@ struct collapse_control {
>   
>   	/* nodemask for allocation fallback */
>   	nodemask_t alloc_nmask;
> +
> +	/* Each bit represents a single occupied (!none/zero) page. */
> +	DECLARE_BITMAP(mthp_bitmap, MAX_PTRS_PER_PTE);
> +	/* A mask of the current range being considered for mTHP collapse. */
> +	DECLARE_BITMAP(mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> +	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
>   };
>   
>   /**
> @@ -1411,20 +1441,137 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
>   	return result;
>   }
>   
> +static void collapse_mthp_stack_push(struct collapse_control *cc, int *stack_size,
> +				     u16 offset, u8 order)
> +{
> +	const int size = *stack_size;
> +	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
> +
> +	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
> +	stack->order = order;
> +	stack->offset = offset;
> +	(*stack_size)++;
> +}
> +
> +static struct mthp_range collapse_mthp_stack_pop(struct collapse_control *cc,
> +						 int *stack_size)
> +{
> +	const int size = *stack_size;
> +
> +	VM_WARN_ON_ONCE(size <= 0);
> +	(*stack_size)--;
> +	return cc->mthp_bitmap_stack[size - 1];
> +}
> +
> +static unsigned int collapse_mthp_count_present(struct collapse_control *cc,
> +						u16 offset, unsigned int nr_ptes)
> +{
> +	bitmap_zero(cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> +	bitmap_set(cc->mthp_bitmap_mask, offset, nr_ptes);
> +	return bitmap_weight_and(cc->mthp_bitmap, cc->mthp_bitmap_mask, MAX_PTRS_PER_PTE);
> +}
> +
> +/*
> + * mthp_collapse() consumes the bitmap that is generated during
> + * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
> + *
> + * Each bit in cc->mthp_bitmap represents a single occupied (!none/zero) page.
> + * A stack structure cc->mthp_bitmap_stack is used to check different regions
> + * of the bitmap for collapse eligibility. The stack maintains a pair of
> + * variables (offset, order), indicating the number of PTEs from the start of
> + * the PMD, and the order of the potential collapse candidate respectively. We
> + * start at the PMD order and check if it is eligible for collapse; if not, we
> + * add two entries to the stack at a lower order to represent the left and right
> + * halves of the PTE page table we are examining.
> + *
> + *                         offset       mid_offset
> + *                         |         |
> + *                         |         |
> + *                         v         v
> + *      --------------------------------------
> + *      |          cc->mthp_bitmap            |
> + *      --------------------------------------
> + *                         <-------><------->
> + *                          order-1  order-1
> + *
> + * For each of these, we determine how many PTE entries are occupied in the
> + * range of PTE entries we propose to collapse, then we compare this to a
> + * threshold number of PTE entries which would need to be occupied for a
> + * collapse to be permitted at that order (accounting for max_ptes_none).
> + *
> + * If a collapse is permitted, we attempt to collapse the PTE range into a
> + * mTHP.
> + */
> +static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
> +		unsigned long address, int referenced, int unmapped,
> +		struct collapse_control *cc, unsigned long enabled_orders)
> +{
> +	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
> +	int collapsed = 0, stack_size = 0;
> +	unsigned long collapse_address;
> +	struct mthp_range range;
> +	u16 offset;
> +	u8 order;
> +
> +	collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
> +
> +	while (stack_size) {
> +		range = collapse_mthp_stack_pop(cc, &stack_size);
> +		order = range.order;
> +		offset = range.offset;
> +		nr_ptes = 1UL << order;
> +
> +		if (!test_bit(order, &enabled_orders))
> +			goto next_order;
> +
> +		max_ptes_none = collapse_max_ptes_none(cc, vma, order);
> +
> +		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
> +							       nr_ptes);
> +
> +		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
> +			int ret;
> +
> +			collapse_address = address + offset * PAGE_SIZE;
> +			ret = collapse_huge_page(mm, collapse_address, referenced,
> +						 unmapped, cc, order);
> +			if (ret == SCAN_SUCCEED) {
> +				collapsed += nr_ptes;
> +				continue;
> +			}
> +		}
> +
> +next_order:
> +		if ((BIT(order) - 1) & enabled_orders) {
> +			const u8 next_order = order - 1;
> +			const u16 mid_offset = offset + (nr_ptes / 2);
> +
> +			collapse_mthp_stack_push(cc, &stack_size, mid_offset,
> +						 next_order);
> +			collapse_mthp_stack_push(cc, &stack_size, offset,
> +						 next_order);
> +		}
> +	}
> +	return collapsed;
> +}

Hi Andrew,

Can you please append the following fixup that reverts one of the

changes requested in V17. The issue with the change is described

below.


commit 1e099144dfcdd28e3b3b50b32535798db53866aa
Author: Nico Pache <npache@redhat.com>
Date:   Mon May 25 07:38:59 2026 -0600

     fixup: fix potential use-after-free of vma in mthp_collapse()

     Between V17 and v18, one reviewer (Wei) brought up that we are not 
doing
     the uffd-armed check until deep in the collapse operation. While not
     functionally incorrect, it can lead to unnecessary work.

     We optimized this by passing the vma variable to mthp_collapse() 
and using
     the collapse_max_ptes_none() function to check the state of uffd-armed
     preventing the wasted work later in the collapse.

     mthp_collapse() is called after mmap_read_unlock(), so the vma pointer
     can become stale. Remove the vma parameter and pass NULL to
     collapse_max_ptes_none() instead.

     Signed-off-by: Nico Pache <npache@redhat.com>

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d3d7db8be26c..a901db5c9201 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1502,9 +1502,9 @@ static unsigned int 
collapse_mthp_count_present(struct collapse_control *cc,
   * If a collapse is permitted, we attempt to collapse the PTE range into a
   * mTHP.
   */
-static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
-        unsigned long address, int referenced, int unmapped,
-        struct collapse_control *cc, unsigned long enabled_orders)
+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
+        int referenced, int unmapped, struct collapse_control *cc,
+        unsigned long enabled_orders)
  {
      unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
      int collapsed = 0, stack_size = 0;
@@ -1524,7 +1524,7 @@ static int mthp_collapse(struct mm_struct *mm, 
struct vm_area_struct *vma,
          if (!test_bit(order, &enabled_orders))
              goto next_order;

-        max_ptes_none = collapse_max_ptes_none(cc, vma, order);
+        max_ptes_none = collapse_max_ptes_none(cc, NULL, order);

          nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
                                     nr_ptes);
@@ -1749,7 +1749,7 @@ static enum scan_result collapse_scan_pmd(struct 
mm_struct *mm,
      if (result == SCAN_SUCCEED) {
          /* collapse_huge_page expects the lock to be dropped before 
calling */
          mmap_read_unlock(mm);
-        nr_collapsed = mthp_collapse(mm, vma, start_addr, referenced,
+        nr_collapsed = mthp_collapse(mm, start_addr, referenced,
                           unmapped, cc, enabled_orders);
          /* mmap_lock was released above, set lock_dropped */
          *lock_dropped = true;


> +
>   static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>   		struct vm_area_struct *vma, unsigned long start_addr,
>   		bool *lock_dropped, struct collapse_control *cc)
>   {
> -	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>   	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
>   	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
> +	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
> +	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>   	pmd_t *pmd;
> -	pte_t *pte, *_pte;
> -	int none_or_zero = 0, shared = 0, referenced = 0;
> +	pte_t *pte, *_pte, pteval;
> +	int i;
> +	int none_or_zero = 0, shared = 0, nr_collapsed = 0, referenced = 0;
>   	enum scan_result result = SCAN_FAIL;
>   	struct page *page = NULL;
>   	struct folio *folio = NULL;
>   	unsigned long addr;
> +	unsigned long enabled_orders;
>   	spinlock_t *ptl;
>   	int node = NUMA_NO_NODE, unmapped = 0;
>   
> @@ -1436,8 +1583,19 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>   		goto out;
>   	}
>   
> +	bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
>   	memset(cc->node_load, 0, sizeof(cc->node_load));
>   	nodes_clear(cc->alloc_nmask);
> +
> +	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);
> +
> +	/*
> +	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
> +	 * scan all pages to populate the bitmap for mTHP collapse.
> +	 */
> +	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
> +		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
> +
>   	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>   	if (!pte) {
>   		cc->progress++;
> @@ -1445,11 +1603,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>   		goto out;
>   	}
>   
> -	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> -	     _pte++, addr += PAGE_SIZE) {
> +	for (i = 0; i < HPAGE_PMD_NR; i++) {
> +		_pte = pte + i;
> +		addr = start_addr + i * PAGE_SIZE;
> +		pteval = ptep_get(_pte);
> +
>   		cc->progress++;
>   
> -		pte_t pteval = ptep_get(_pte);
>   		if (pte_none_or_zero(pteval)) {
>   			if (++none_or_zero > max_ptes_none) {
>   				result = SCAN_EXCEED_NONE_PTE;
> @@ -1529,6 +1689,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>   			}
>   		}
>   
> +		/* Set bit for occupied pages */
> +		__set_bit(i, cc->mthp_bitmap);
>   		/*
>   		 * Record which node the original page is from and save this
>   		 * information to cc->node_load[].
> @@ -1587,10 +1749,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>   	if (result == SCAN_SUCCEED) {
>   		/* collapse_huge_page expects the lock to be dropped before calling */
>   		mmap_read_unlock(mm);
> -		result = collapse_huge_page(mm, start_addr, referenced,
> -					    unmapped, cc, HPAGE_PMD_ORDER);
> -		/* collapse_huge_page will return with the mmap_lock released */
> +		nr_collapsed = mthp_collapse(mm, vma, start_addr, referenced,
> +					     unmapped, cc, enabled_orders);
> +		/* mmap_lock was released above, set lock_dropped */
>   		*lock_dropped = true;
> +		result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
>   	}
>   out:
>   	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,



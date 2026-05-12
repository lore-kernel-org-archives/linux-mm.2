Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B341CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 15:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8820A6B0088; Tue, 12 May 2026 11:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8323D6B0098; Tue, 12 May 2026 11:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 747D76B00A5; Tue, 12 May 2026 11:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61CC46B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:44:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE4271A053C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:44:36 +0000 (UTC)
X-FDA: 84759190152.27.C6C8D7B
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id B3EDD8000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:44:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bsdoq2ap;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778600674;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nv4qmA+sqyfYzE92vZNdsUTE214TmpdPKsUH6wG5Qt4=;
	b=qlKQHsR/vT1gn85Z7cBNP8+jFKfFGVxUrkjN9cojhC8otO5+R7dnUeTg8f6CZNrOILfGEh
	/+vgbfBXLJ8E/iSs67hQ1TO7bFp6Bn0X0cYF3Itxao25HEedek4qmij2uxo8ycpObx5LBg
	bODEElvIWmwy3D6Vd38/WsnjqsXkkDw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bsdoq2ap;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778600674; a=rsa-sha256;
	cv=none;
	b=yRO0+5buKSQqJV05zJB//4OrAfeJnRqz7vT8bELmJHGtRZFPgSGFH/0wUndHiYFP4YQSVz
	FalXMJI0UVvyCx0V2C628dKLUE/RgCm/4MZp/C8ercqm2HJbWo0/5yNVH/FkLch4L4XWoS
	PvKqI//E03v579/akW8SsEvXsHd9Zlg=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bd124546379so295810066b.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 08:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778600673; x=1779205473; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nv4qmA+sqyfYzE92vZNdsUTE214TmpdPKsUH6wG5Qt4=;
        b=bsdoq2aph9dsZcESeGB6xXZW8o37cxqlicyShGvb0Fkn32aNbxyVC13iGscGvNqysn
         W5T+VUx3CAwvaNXydtULjyAFpzuAluvGANK1OoLq52HRwbdp16Dvhx9aRBI1Qy4JiIk6
         Z2Lf5t9FJfpNWhFQG++ARcAXvdYtOWVRZt7IPwgDTEHsRCR5wpeM3ppBLlK6lqsWY+16
         F7EJ2Wh1ksst5X4UnxqQSCBOGGUV1KZeDFglLTWHvsQxhsGNZ01xhzc36ZQ/i+zyLmt+
         RDgW0ffcJNRQfNIShGU/NPBDrbznfKtzOMZ664Lo+IsJdopAQkaIy/0h4xww1EWdDUQj
         10cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778600673; x=1779205473;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nv4qmA+sqyfYzE92vZNdsUTE214TmpdPKsUH6wG5Qt4=;
        b=kHHxvbUerH17gaRjvAbkkgGlzcnlRG/svyJ1YKM2nA3VurxLS3RQQd4bZX1VZ6OXWR
         +E8O/oauduvj7JSNV8jvVpknEV9iCAdWdReKb0h1Y6vmMyJ14kLSqg9oR1/eAwFpdCqV
         MVioR8LwL8Fxwf1mQVSseoQfJT6rRFspUQGHu8biqx2qHEXdQTHqy/zoI7OLACsnoTsC
         wFtlTUaXYQx00I3yDoFnnnqy61c0AUPPG1X6rhD4mnkFZjTbcOQPn/sH5nKhS9J+iqMl
         Sk3kmARAvV4Me8TntfqLWI1D4POoURaWq45ZSzm3zmea+9HW14rat3l4H1b4Dp9r4Vbm
         fu/w==
X-Forwarded-Encrypted: i=1; AFNElJ+NLb/Rgd2WWJSA+r+5R1WZMsMBasAofNH8vN9WaTFToBdyBuLksenXDu5rCPOBbzKsfgx6yffyrQ==@kvack.org
X-Gm-Message-State: AOJu0YzW4q9QiD/wwbrziQ6GKYr0zjdKRt98ehcFBBOr3Ml/GuckVNt+
	rxn4uHk1zxEUy6mqjdzXZRvXGljgELPYVhjs94BzWRxbZR9imNJOt9hk
X-Gm-Gg: Acq92OEA2NnWP9Q321aXNZ+yOS1tdLYQrtwLo4hPa8qs2DKID8n0ku+/Ctca3fB2023
	aCERTm7clVcjhbtV7omIW8WH/nhYHQpZWL5BIIVWUe/v217o+Pf+AyurldVoJIYxKdv4SKKG+Yq
	fekNFp6r4zHSVerRnwIxfhmwq0/EXSKOwWa2awaFAKSadxy9KNzhAKPbm5c7Fee3VYDcPITHchQ
	GC2p64EOZmvareLmYUvmC1FVh3G8WD2UsxRqJ2DCc6S0ot/g2BhYg1oXcM58cutrzdc0T/dgWYt
	lW0Bdj4Y22OjymdeYN7F5zh93+9DCuBYf+eV+GaJ4bZ16VKNX5RV0/o8aKMl87YnqgKpF/YJRNo
	JiXupVn7ASV/SjzYOR0VUuEqXYT/eBQwrv2JE1WQCqv8eRIKIDZp0JGVp98hnaw3BlSkBiA5Dmy
	T+gsP7offfg+RCY4pmflGxmw==
X-Received: by 2002:a17:907:1c0d:b0:bd2:ed0:90f9 with SMTP id a640c23a62f3a-bd20ed09163mr410838466b.30.1778600672517;
        Tue, 12 May 2026 08:44:32 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcac11b7084sm687780766b.28.2026.05.12.08.44.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 May 2026 08:44:32 -0700 (PDT)
Date: Tue, 12 May 2026 15:44:31 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com, akpm@linux-foundation.org,
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, byungchul@sk.com,
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
	jack@suse.cz, jackmanb@google.com, jannh@google.com,
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org,
	lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com,
	pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
	rdunlap@infradead.org, richard.weiyang@gmail.com,
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org,
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com,
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <20260512154431.jxcs632mqqatqtsw@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260511185817.686831-1-npache@redhat.com>
 <20260511185817.686831-12-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511185817.686831-12-npache@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B3EDD8000A
X-Stat-Signature: t5mjqs955go74ghquyf84fwwdeu9uaza
X-HE-Tag: 1778600674-746423
X-HE-Meta: U2FsdGVkX1//zZDIPkyzrPuswO+K5Mfrh5z3cxNlzMxjICnc7Xe+mXcQnhD2pWvDbv9TD+Xba3nNHh5V5lXIUI/k41f3ac+0w+9cyhIQT9PF37OdZLmt0ExRa+Y/cJigpG0JYdf0PwbmK+7z5BD9uZEMdvDkNtja2MQN8wTUfAecilY90NThsyuoUQ2LVx8aYs3zCRzAFi4tmarKVxbevPwIHIMnREGI9KvGSJFT4i0jTd6vCGZBzs3rvx1jQaVY264VBmi34sFbEni3CzYvPspMAs0Quk7LQsAQzlre+JdnmFO+gxo6Qs13/HbTa3Avv5JreTZFr8ztWf9jqCRJtza74WoLq9avqeNOJgANoU+kgsj5qVNoAQZZZsPrNZojCW7p8PafaGcE1IaT084Vrw+VmBOGiK8VRqbyQ2LJc4mSMEkzLbCFvs1kzhe0bmR/aPDCfb7LIL9AJPlax33wL0Fd3dd7L2xsRbE79hxf7CAfo4F0CaFgBwjtk1f9b4cHO5R6foeidHmEoFV5p7/pzundEZefTnTTOOq/m16j6PWwO2aa+uHBC9NzRjBnxU0ItaW/Se8ywpUJJrdmEzAPw0/Je3CvQ+fG//UHV41D/zOBveEyT+itCEzcPKdgccVhAOdDXJDkpd4NQIImfWQI6WVilpGUk6biZV6X/SICnlDlZUzpZdM3HFl+p3PUZz5tg+HLcXfJkrsXoxusdhzlDNa+54L0zFUQe2YMJl8clHocN6GAlzlFlD9HPiG414wwVeuSRs4UqIYGrfiDgEtjXmruJNfHtSgWkctpceWsPfOyrQosVCR7ap2+DHkQ8o0IDb6s+aLyjN71reitkndUzQWiobB4rd/u5hTx1ucucDrGJkC2kdB3VUq1GZWazee0JjXbVKrkq8LihmBn4jWAo4eKfZ3LBokQThYbqviA/E+E4Sp2kHmBCGuDiivLcrIUnFD+OUI1M9UXuYztGgM
 yXhprzI1
 Uz8Dj3i9rkOL98tglkCQYDlhbLzB/Ato19mdW7x2uhu+81ntHm8Rn/rj5fKyAlynPkm0wYxNUE0PI5esqLW1jl+vW5V+G8M9xrzejTxGiBQPsCaaNdzIxtg73qpOkwBq6SWYLHoMmnwIybC6N6vV1PJIRDOC/CU0u3H4RsfJy3F/ePhU3cakyIC9XNBqpgBSX5kqbVUvZdMSv/dUagAkrlB5kdIQ8pfLj8BBg8fk3ET8HCxw/cQFR3XNmlPdDkxiLobJUlKeLvLqiwQ7M0T2d8SocW3veNOgiz/IslxNoDegNfB7mdaCTVa/spchY5qJdk42kebGsqWgVJsGXfsvRvyD7qK+kKOZldvRDSp/rRAi7qY0cogK9ivZ/95UZLj4cJQ+UPhbdSAVdTHKpT/z2jg3fQrLlK7wbu6peP0OGo6C1prUg7iMLOQpUpHDJJ0yjy1co77rMS1Q11NIkPgOhlAe0P9lpPsoATBjPn6jUQ7MuyqXIldbzRyxc0f9BP6KHoW9VqLP4MYHaQpjKMXqgrueJB1bFNNmomCftVC9bPzlz9Otl9vvbh5jGzVzAItrxE5/49OQ/QQt5rjvBrutzkTwmxU4R6hvFrbK08mD5UD9G3gAD+JXgOzLAbGzf9rQI88qs8ljYg69TIPU0X9uaDFC6i0BJvSm2a7pj//pHA7saXkVmso1Lq50qIa2lL7Y7P3UW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 12:58:11PM -0600, Nico Pache wrote:
>Enable khugepaged to collapse to mTHP orders. This patch implements the
>main scanning logic using a bitmap to track occupied pages and a stack
>structure that allows us to find optimal collapse sizes.
>
>Previous to this patch, PMD collapse had 3 main phases, a light weight
>scanning phase (mmap_read_lock) that determines a potential PMD
>collapse, an alloc phase (mmap unlocked), then finally heavier collapse
>phase (mmap_write_lock).
>
>To enabled mTHP collapse we make the following changes:
>
>During PMD scan phase, track occupied pages in a bitmap. When mTHP
>orders are enabled, we remove the restriction of max_ptes_none during the
>scan phase to avoid missing potential mTHP collapse candidates. Once we
>have scanned the full PMD range and updated the bitmap to track occupied
>pages, we use the bitmap to find the optimal mTHP size.
>
>Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
>and determine the best eligible order for the collapse. A stack structure
>is used instead of traditional recursion to manage the search. This also
>prevents a traditional recursive approach when the kernel stack struct is
>limited. The algorithm recursively splits the bitmap into smaller chunks to
>find the highest order mTHPs that satisfy the collapse criteria. We start
>by attempting the PMD order, then moved on the consecutively lower orders
>(mTHP collapse). The stack maintains a pair of variables (offset, order),
>indicating the number of PTEs from the start of the PMD, and the order of
>the potential collapse candidate.
>
>The algorithm for consuming the bitmap works as such:
>    1) push (0, HPAGE_PMD_ORDER) onto the stack
>    2) pop the stack
>    3) check if the number of set bits in that (offset,order) pair
>       statisfy the max_ptes_none threshold for that order
>    4) if yes, attempt collapse
>    5) if no (or collapse fails), push two new stack items representing
>       the left and right halves of the current bitmap range, at the
>       next lower order
>    6) repeat at step (2) until stack is empty.
>
>Below is a diagram representing the algorithm and stack items:
>
>                            offset   mid_offset
>                            |        |
>                            |        |
>                            v        v
>          ____________________________________
>         |          PTE Page Table            |
>         --------------------------------------
>			    <-------><------->
>                             order-1  order-1
>
>mTHP collapses reject regions containing swapped out or shared pages.
>This is because adding new entries can lead to new none pages, and these
>may lead to constant promotion into a higher order mTHP. A similar
>issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
>introducing at least 2x the number of pages, and on a future scan will
>satisfy the promotion condition once again. This issue is prevented via
>the collapse_max_ptes_none() function which imposes the max_ptes_none
>restrictions above.
>
>We currently only support mTHP collapse for max_ptes_none values of 0
>and HPAGE_PMD_NR - 1. resulting in the following behavior:
>
>    - max_ptes_none=0: Never introduce new empty pages during collapse
>    - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>      available mTHP order
>
>Any other max_ptes_none value will emit a warning and skip mTHP collapse
>attempts. There should be no behavior change for PMD collapse.
>
>Once we determine what mTHP sizes fits best in that PMD range a collapse
>is attempted. A minimum collapse order of 2 is used as this is the lowest
>order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>
>Currently madv_collapse is not supported and will only attempt PMD
>collapse.
>
>We can also remove the check for is_khugepaged inside the PMD scan as
>the collapse_max_ptes_none() function handles this logic now.
>
>Signed-off-by: Nico Pache <npache@redhat.com>

[...]

>+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>+		int referenced, int unmapped, struct collapse_control *cc,
>+		unsigned long enabled_orders)
>+{
>+	unsigned int nr_occupied_ptes, nr_ptes;
>+	int max_ptes_none, collapsed = 0, stack_size = 0;
>+	unsigned long collapse_address;
>+	struct mthp_range range;
>+	u16 offset;
>+	u8 order;
>+
>+	collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
>+
>+	while (stack_size) {
>+		range = collapse_mthp_stack_pop(cc, &stack_size);
>+		order = range.order;
>+		offset = range.offset;
>+		nr_ptes = 1UL << order;
>+
>+		if (!test_bit(order, &enabled_orders))
>+			goto next_order;
>+
>+		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);

I am thinking whether there is a behavioral change for userfaultfd_armed(vma).

collapse_single_pmd()
    collapse_scan_pmd
        max_ptes_none = collapse_max_ptes_none(cc, vma)
        max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT                --- (1)
        mthp_collapse
            max_ptes_none = collapse_max_ptes_none(cc, NULL)     --- (2)
            collapse_huge_page(mm)
                hugepage_vma_revalidate(&vma)
                __collapse_huge_page_isolate(vma)
                    max_ptes_none = collapse_max_ptes_none(cc, vma)

Before mthp_collapse() introduced, userfaultfd_armed(vma) is skipped if there
is any pte_none_or_zero() in collapse_scan_pmd().

But now, max_ptes_none could be set to KHUGEPAGED_MAX_PTES_LIMIT at (1), so
that we can scan all the pte to get the bitmap. This means
userfaultfd_armed(vma) could continue even with pte_none_or_zero().

Then in mthp_collapse(), collapse_max_ptes_none() at (2) ignores
userfaultfd_armed(vma), which means it will continue to collapse a
userfaultfd_armed(vma) when there is pte_none_or_zero(). 

The good news is we will stop at __collapse_huge_page_isolate(), where we
get collapse_max_ptes_none() with vma. But we already did a lot of work.

Not sure if I missed something.

>+
>+		if (max_ptes_none < 0)
>+			return collapsed;
>+
>+		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
>+							       nr_ptes);
>+
>+		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>+			int ret;
>+
>+			collapse_address = address + offset * PAGE_SIZE;
>+			ret = collapse_huge_page(mm, collapse_address, referenced,
>+						 unmapped, cc, order);
>+			if (ret == SCAN_SUCCEED) {
>+				collapsed += nr_ptes;
>+				continue;
>+			}
>+		}
>+
>+next_order:
>+		if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
>+			const u8 next_order = order - 1;
>+			const u16 mid_offset = offset + (nr_ptes / 2);
>+
>+			collapse_mthp_stack_push(cc, &stack_size, mid_offset,
>+						 next_order);
>+			collapse_mthp_stack_push(cc, &stack_size, offset,
>+						 next_order);
>+		}
>+	}
>+	return collapsed;
>+}
>+
> static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> 		struct vm_area_struct *vma, unsigned long start_addr,
> 		bool *lock_dropped, struct collapse_control *cc)
> {
>-	const int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>+	int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
> 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
> 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
>+	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
> 	pmd_t *pmd;
>-	pte_t *pte, *_pte;
>-	int none_or_zero = 0, shared = 0, referenced = 0;
>+	pte_t *pte, *_pte, pteval;
>+	int i;
>+	int none_or_zero = 0, shared = 0, nr_collapsed = 0, referenced = 0;
> 	enum scan_result result = SCAN_FAIL;
> 	struct page *page = NULL;
> 	struct folio *folio = NULL;
> 	unsigned long addr;
>+	unsigned long enabled_orders;
> 	spinlock_t *ptl;
> 	int node = NUMA_NO_NODE, unmapped = 0;
> 
>@@ -1429,8 +1579,19 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> 		goto out;
> 	}
> 
>+	bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
> 	memset(cc->node_load, 0, sizeof(cc->node_load));
> 	nodes_clear(cc->alloc_nmask);
>+
>+	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);

Would it be 0 at this point?

>+
>+	/*
>+	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
>+	 * scan all pages to populate the bitmap for mTHP collapse.
>+	 */
>+	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
>+		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>+
> 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> 	if (!pte) {
> 		cc->progress++;
>@@ -1438,11 +1599,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> 		goto out;
> 	}
> 
>-	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>-	     _pte++, addr += PAGE_SIZE) {
>+	for (i = 0; i < HPAGE_PMD_NR; i++) {
>+		_pte = pte + i;
>+		addr = start_addr + i * PAGE_SIZE;
>+		pteval = ptep_get(_pte);
>+
> 		cc->progress++;
> 
>-		pte_t pteval = ptep_get(_pte);
> 		if (pte_none_or_zero(pteval)) {
> 			if (++none_or_zero > max_ptes_none) {
> 				result = SCAN_EXCEED_NONE_PTE;
>@@ -1522,6 +1685,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> 			}
> 		}
> 
>+		/* Set bit for occupied pages */
>+		__set_bit(i, cc->mthp_bitmap);
> 		/*
> 		 * Record which node the original page is from and save this
> 		 * information to cc->node_load[].
>@@ -1580,10 +1745,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> 	if (result == SCAN_SUCCEED) {
> 		/* collapse_huge_page expects the lock to be dropped before calling */
> 		mmap_read_unlock(mm);
>-		result = collapse_huge_page(mm, start_addr, referenced,
>-					    unmapped, cc, HPAGE_PMD_ORDER);
>+		nr_collapsed = mthp_collapse(mm, start_addr, referenced, unmapped,
>+					      cc, enabled_orders);
> 		/* collapse_huge_page will return with the mmap_lock released */

collapse_huge_page will return with mmap_lock released, but mthp_collapse()
may not?

> 		*lock_dropped = true;
>+		result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
> 	}
> out:
> 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
>-- 
>2.54.0

-- 
Wei Yang
Help you, Help me


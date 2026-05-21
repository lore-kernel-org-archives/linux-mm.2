Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17F28CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 01:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51DCC6B0005; Wed, 20 May 2026 21:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D00D6B0088; Wed, 20 May 2026 21:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD3E6B008A; Wed, 20 May 2026 21:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28CEF6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:55:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C18C81C01B7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:55:17 +0000 (UTC)
X-FDA: 84789759474.06.550B114
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id A3A0C80003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:55:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qo1pOdXa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779328515;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dx+EA16FOvOOYuZb6isfGNz8chKsPLjR9rgc7G5/NOE=;
	b=04L1415CIU9MxLTiAJBNsZ49xs9UNKvGjhWYaNcUwbTYIWUaFwdNH732Pl4LCbWTLYDDm2
	lWbvJbGBqQgKy5xvjOxoW/yO14VcOuvXkbX1uVBC94rKPn5X4YweCg0ET0IXncMbXLGjt5
	AnlpxDmA48swJsxxJpT7qApcWOWzABA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779328515; a=rsa-sha256;
	cv=none;
	b=BSuJ+Iog0Ps8SwCwuNHsdOiW77jzQ8JtOt1+KjVw4R4gNBLshxO/KK7pVPh6XO99GNgWnc
	jRHnJof929+/7SP20E+UX4bXHOBPK+bDH07nc8VbmcuM8XT1qJ8mMgQdWUP1t4/XKuKLNC
	s8bOgBrAxKs68CYyIGVCCbw8OI1ZDIE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qo1pOdXa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bd01481e592so809098966b.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 18:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779328514; x=1779933314; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dx+EA16FOvOOYuZb6isfGNz8chKsPLjR9rgc7G5/NOE=;
        b=qo1pOdXaswmv4X5Co9iwfq80KQi6Ss+AJo2m/Ut9mQmpq4fyt48lE9o38rJ1Dk64jj
         AYtfFeqjHuLNQld1F1LUMXdAxxniwjy8NX/obvIEpEWIQEFot/dkBqImVD7ck8ISqgl7
         vrY2TWW/5IZInqclG/7d2mAG2rGX5MOyo55Ecm3otsJsrZvCVupYnvLos+uO6c4r89mc
         Nis9c97ddTHg/funBf/f7fJ98mP1JmrKc4y5umYHptBqI9gF2lbeFA5VIM0JXytd1GTj
         AIvmvmGWSf5eH9vu/sAfYFmxZ7PZObx3631vEpPpOM0X/D+GPul1p8hANRXcXZxXUlXx
         sk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779328514; x=1779933314;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dx+EA16FOvOOYuZb6isfGNz8chKsPLjR9rgc7G5/NOE=;
        b=jjQ2epTe4RpjFgCPET21sVDAKKWTJabYHgRAmqUmRUluAwf2Wwt9F7owVsgEw1mp4o
         8ktfEUx/GDpArk7Szm3+YSx4s5WOSbVG3aM5vfMpklAky7s9fon7kev0OjK+uADHduq8
         +UBScslytiFnmHB9IbqwFSYriZ8yATArNDxqjaxiA4EdgmMzIr75rt2kGYTqti1Fg0AP
         HAYHm8LFbfT2PTgtkfXa0TU7CFlepZ/M1Nwc0FO21V+rhYyddsrqPhfM1scavojCjAaI
         RFTTJqvYD9xDq3LVfy/MB0KOoOXvjFPFwPZn127obrTQliAbjmXtbrhte3RvG/fqPEam
         wF9A==
X-Forwarded-Encrypted: i=1; AFNElJ/m7g0HVNnHz5h0NdZkCw1IXqXZz74WRtxND6dq0BAd7G3SZL+YHUkPz9ozU2f6jDk3hH1KG0i0MQ==@kvack.org
X-Gm-Message-State: AOJu0YxveIC8nMDP2y80WlqEBMl1uObUaoq9ugo6avAPnlqnqfnpnfFW
	2YUQP2Ii+mxedWuqtfgccnsJJrHLwUFWMQJHFwIqSmWtuYJv4jau9ySV
X-Gm-Gg: Acq92OHjV7kK/Koez5itfWzP/XmVlZzPBlEXtrLwBLvQTrVihcr0T5JO8s+bzJXrexX
	54d7TxtvoVJRXtSS8Llg5sUQCyYQeIexN6JdIA8t/kywN3bxZtB5CBdd4WjYgqJb+qbs/97ntYR
	Y5EuZMyBJRIepvuxhL1f1NfGkTwrq981fKjMTFCSGvDiNYk0ijuw40MjGxO5qnuhEl7YtfXRdsp
	fqKQgRV9RqoqzNGS2t00HxvwjAk9wImoK43CzuwdHsOVJRoTLymP05BMGBzfxstMbyDdcx3ujq8
	cF3X4C/CtyhAVID5pNWIjeLZoCe4I8sH2nOTYeiWOdyLfVI67Plho7QQPPb57ngcppTE3uQy7Rl
	05hCKd4WWhAsZYbHajeczf42KdJOqOkJOtqhNRTFmEg6/KzZphfJvA3SxfkECm1cR85hJkBZL2S
	/maGwtOrO5ZjnDdpW8Cu3Wog==
X-Received: by 2002:a17:907:a2cf:b0:bd0:125b:cbb2 with SMTP id a640c23a62f3a-bdc1357047bmr30416366b.7.1779328513576;
        Wed, 20 May 2026 18:55:13 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4bd1116sm929340166b.10.2026.05.20.18.55.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 20 May 2026 18:55:12 -0700 (PDT)
Date: Thu, 21 May 2026 01:55:10 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
	akpm@linux-foundation.org, anshuman.khandual@arm.com,
	apopple@nvidia.com, baohua@kernel.org,
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
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org,
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
	sunnanyong@huawei.com, surenb@google.com,
	thomas.hellstrom@linux.intel.com, tiwai@suse.de,
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 11/14] mm/khugepaged: Introduce mTHP
 collapse support
Message-ID: <20260521015510.k4p22m365q2wqkro@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260511185817.686831-1-npache@redhat.com>
 <20260511185817.686831-12-npache@redhat.com>
 <20260512154431.jxcs632mqqatqtsw@master>
 <CAA1CXcD2KPKFrwCZd2PatQhf_e1nrvCguPD77GcNOVPFZLvsew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcD2KPKFrwCZd2PatQhf_e1nrvCguPD77GcNOVPFZLvsew@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: A3A0C80003
X-Rspamd-Server: rspam04
X-Stat-Signature: wsj53gk1qmafaiat6mhgpwgmq1dghgti
X-HE-Tag: 1779328515-197862
X-HE-Meta: U2FsdGVkX1/jhrpa2G4T1+co5tN0WMTuIqj0onid3U1X6NINNYrzaL4eEw2EPn17YBHoERvwUE+jEKHkyfn3E1NoXJNM17dJoVvzmi1Creiy2DrajRvhEM2bwj/PDB/6PBZ+E2R4VLXTJzzZ0VUIMN4bsW4kIbjOgNBYNOXuMBJ64beNzOgzRO1D2IFtlTWcxXeOoPURQMGDtKi3caaWbh+KLY8j8T78Uxycb5/gBQJVp3W0loNkuegun5qn6uVjkbbPCj78b/cqohcfpu52QsTfobZ8n5g8GVWbFOyM+BVfcUBbPOBMC5nYBdIrKtpO5bFNiD9PBpO11sPOtODmE5slA3QkjHhHEaQotuqqW5Qn/QCqfrpS+ms503Sp3c6jRTS5I+GwIAFjBV0fNrF9PNVPXfAgDw56hxTyun0Ohkq2OZACvGNLo+Fv2VPvVglzYiBVN3RPRteSEB9hTc/+FohxmYespqTOVcN755DZmg+vzoOzhEFr0l1spRvwa+oYyPPZkx++iHAUgkQ+QR84PNVVZlhqL+HR7k4GSl4lk8j+DxyqQqG83kuj4mBoB1+gqZLKAztRGi7+sO11TdU6twGu0lAoqMpTfIaTiTnvWKJxewDH703m8pajIIZGXluZTu6rc6oBFgBdZLhGGl7ABpMUnH+K5b6Dtxqq/LrqBzyXW/VCXAzl4IUoLox5hOaGl0s5JGhPGGQYkSgQ1HoM9Bi49NUBfiWakf7RLSWJbowJ005zgyM0pzpSkCE7M10FyKayka8ZLC1IDktsi4StcnqfXb2S30x2Xd0LIwKV7uxfL7ZPaQg+6V3f+n36QF1IdDDNykPBBp0LHstGByEHa6GF1DrBxOr3eJz+2qtBM5pohvFMvxehIa1sdiB+bUmrPMd1+/0EAt7rh8VE5zOhXwrgw+8JRRz/AkVXbriN8D9RrSSRDb0zSCht8k+Q9rPp8oRgWDNPhc7EDXMSsxz
 UURyrJYD
 vYq5dmPxBJY7rD2A3qcS7O6T4zOLwSTnZt5uvplSp5fqK0UMgZnSmYa6Qjhb51dS3Oz4hoBaqSli/1hDJ5H/AFLgMC0FBGT2VqQhmxYlcEUp6jq2grA5uTPz/cK01zsugjffGz14OB7jk5W3aMJIjXy3c+TCIJMrwyyBCu6j9aBWgqr12mzUBCWeMdu0kSnl6iNT8EInMxtWI5RRhdHD2VfV3si6XRm5RMhHSirtY8BX868fq0Bk8F+y2swsxp5zaLn0sgn+6tH9ZcwFSn3OQkSpFrye8rAPCrL6xRFcdP6w5vEpzxYhv4GXruZ+6e7bkPeGObNCCu/nJfo6nqe9BUwcsE80pl/Jyh9vWo7xFTXiqyCb4sXggcBIUmY/rmwiBd7MaMeJzCVZqYWOYVqeXQBB4ZFJUzL+RB+gAJMhiPCy1zn0nzRLBjnW+sZGwe42S9Iu8K0P5FL/e72BZdrBzPmGdSd+LUwviQd/sOkkV6NGafFE/5CnHFihfacyx85dTUbW3nfLmNF6+xqjI+HuxW1d8kwzB8hBb3ra0NUyzzSsatWuVQt3EPa+TbL8N0lSwkO33wFESsuamWowk1IrQH5oI4QBX/B4oj2t1vrwVA8qUqvWnGyu3NXXrZxbR20KvRpnlR8bnrVLLLgHB67lzloKnehVhm30Q7fYw1A6iIl6x2aOMOM5QP7HH1DP1MBd0tyL+AW2Mveg6snAXKjTB2vorI+T6Q1bnDF4A32JwWiOq2P1uxVts5hia7i1dvVPqFeCtQ4k56Z3i5jEuiIFLVWAqBWziBw/GvYwUJ99EUnKn97IuyCO07psYKXLzzVVUH6OD0So8WeBF8KNuNN9jXlpsXhT6e8DTtMhKrh/RsNTnpY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 06:05:31AM -0600, Nico Pache wrote:
>On Tue, May 12, 2026 at 9:44 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> On Mon, May 11, 2026 at 12:58:11PM -0600, Nico Pache wrote:
>> >Enable khugepaged to collapse to mTHP orders. This patch implements the
>> >main scanning logic using a bitmap to track occupied pages and a stack
>> >structure that allows us to find optimal collapse sizes.
>> >
>> >Previous to this patch, PMD collapse had 3 main phases, a light weight
>> >scanning phase (mmap_read_lock) that determines a potential PMD
>> >collapse, an alloc phase (mmap unlocked), then finally heavier collapse
>> >phase (mmap_write_lock).
>> >
>> >To enabled mTHP collapse we make the following changes:
>> >
>> >During PMD scan phase, track occupied pages in a bitmap. When mTHP
>> >orders are enabled, we remove the restriction of max_ptes_none during the
>> >scan phase to avoid missing potential mTHP collapse candidates. Once we
>> >have scanned the full PMD range and updated the bitmap to track occupied
>> >pages, we use the bitmap to find the optimal mTHP size.
>> >
>> >Implement collapse_scan_bitmap() to perform binary recursion on the bitmap
>> >and determine the best eligible order for the collapse. A stack structure
>> >is used instead of traditional recursion to manage the search. This also
>> >prevents a traditional recursive approach when the kernel stack struct is
>> >limited. The algorithm recursively splits the bitmap into smaller chunks to
>> >find the highest order mTHPs that satisfy the collapse criteria. We start
>> >by attempting the PMD order, then moved on the consecutively lower orders
>> >(mTHP collapse). The stack maintains a pair of variables (offset, order),
>> >indicating the number of PTEs from the start of the PMD, and the order of
>> >the potential collapse candidate.
>> >
>> >The algorithm for consuming the bitmap works as such:
>> >    1) push (0, HPAGE_PMD_ORDER) onto the stack
>> >    2) pop the stack
>> >    3) check if the number of set bits in that (offset,order) pair
>> >       statisfy the max_ptes_none threshold for that order
>> >    4) if yes, attempt collapse
>> >    5) if no (or collapse fails), push two new stack items representing
>> >       the left and right halves of the current bitmap range, at the
>> >       next lower order
>> >    6) repeat at step (2) until stack is empty.
>> >
>> >Below is a diagram representing the algorithm and stack items:
>> >
>> >                            offset   mid_offset
>> >                            |        |
>> >                            |        |
>> >                            v        v
>> >          ____________________________________
>> >         |          PTE Page Table            |
>> >         --------------------------------------
>> >                           <-------><------->
>> >                             order-1  order-1
>> >
>> >mTHP collapses reject regions containing swapped out or shared pages.
>> >This is because adding new entries can lead to new none pages, and these
>> >may lead to constant promotion into a higher order mTHP. A similar
>> >issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collapse
>> >introducing at least 2x the number of pages, and on a future scan will
>> >satisfy the promotion condition once again. This issue is prevented via
>> >the collapse_max_ptes_none() function which imposes the max_ptes_none
>> >restrictions above.
>> >
>> >We currently only support mTHP collapse for max_ptes_none values of 0
>> >and HPAGE_PMD_NR - 1. resulting in the following behavior:
>> >
>> >    - max_ptes_none=0: Never introduce new empty pages during collapse
>> >    - max_ptes_none=HPAGE_PMD_NR-1: Always try collapse to the highest
>> >      available mTHP order
>> >
>> >Any other max_ptes_none value will emit a warning and skip mTHP collapse
>> >attempts. There should be no behavior change for PMD collapse.
>> >
>> >Once we determine what mTHP sizes fits best in that PMD range a collapse
>> >is attempted. A minimum collapse order of 2 is used as this is the lowest
>> >order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
>> >
>> >Currently madv_collapse is not supported and will only attempt PMD
>> >collapse.
>> >
>> >We can also remove the check for is_khugepaged inside the PMD scan as
>> >the collapse_max_ptes_none() function handles this logic now.
>> >
>> >Signed-off-by: Nico Pache <npache@redhat.com>
>>
>> [...]
>>
>> >+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
>> >+              int referenced, int unmapped, struct collapse_control *cc,
>> >+              unsigned long enabled_orders)
>> >+{
>> >+      unsigned int nr_occupied_ptes, nr_ptes;
>> >+      int max_ptes_none, collapsed = 0, stack_size = 0;
>> >+      unsigned long collapse_address;
>> >+      struct mthp_range range;
>> >+      u16 offset;
>> >+      u8 order;
>> >+
>> >+      collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
>> >+
>> >+      while (stack_size) {
>> >+              range = collapse_mthp_stack_pop(cc, &stack_size);
>> >+              order = range.order;
>> >+              offset = range.offset;
>> >+              nr_ptes = 1UL << order;
>> >+
>> >+              if (!test_bit(order, &enabled_orders))
>> >+                      goto next_order;
>> >+
>> >+              max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
>>
>> I am thinking whether there is a behavioral change for userfaultfd_armed(vma).
>>
>> collapse_single_pmd()
>>     collapse_scan_pmd
>>         max_ptes_none = collapse_max_ptes_none(cc, vma)
>>         max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT                --- (1)
>>         mthp_collapse
>>             max_ptes_none = collapse_max_ptes_none(cc, NULL)     --- (2)
>>             collapse_huge_page(mm)
>>                 hugepage_vma_revalidate(&vma)
>>                 __collapse_huge_page_isolate(vma)
>>                     max_ptes_none = collapse_max_ptes_none(cc, vma)
>>
>> Before mthp_collapse() introduced, userfaultfd_armed(vma) is skipped if there
>> is any pte_none_or_zero() in collapse_scan_pmd().
>>
>> But now, max_ptes_none could be set to KHUGEPAGED_MAX_PTES_LIMIT at (1), so
>> that we can scan all the pte to get the bitmap. This means
>> userfaultfd_armed(vma) could continue even with pte_none_or_zero().
>>
>> Then in mthp_collapse(), collapse_max_ptes_none() at (2) ignores
>> userfaultfd_armed(vma), which means it will continue to collapse a
>> userfaultfd_armed(vma) when there is pte_none_or_zero().
>>
>> The good news is we will stop at __collapse_huge_page_isolate(), where we
>> get collapse_max_ptes_none() with vma. But we already did a lot of work.
>
>Good catch!
>
>As you stated we eventually ensure we respect the uffd checks. So
>there are no correctness issues, just the potential for wasted cycles.
>
>At (1) we only do this if mTHPs are enabled. If that is the case, the
>only waste that can arise is at the PMD order, as that order respects
>the max_ptes_none value.
>
>I think one approach is to gate (1) with the uffd check as well. That
>way, if mTHPs are enabled and its uffd-armed, max_ptes_none will stay
>at 0, and we bail early on the scan early if any none_ptes are hit.
>
>But then we lose the ability to collapse to mTHPs that are uffd-armed,
>where the PMD has none/zero-ptes and the mTHP fully has 0
>non-none/zero-ptes.
>
>ie) assume a PMD is 16 x's [xxxxxxxx00000000]
>where x is a populated pte and 0 is not
>If we guard this scan (1), then we will never check if its possible to
>collapse to the smaller orders.
>
>Let me know if you see a flaw in my logic, I think it's best to keep it as is?
>

Yes, gate it at (1) is not a proper place.

I am thinking whether we could pass vma to (2)? So that we could respect
uffd-armed?

>>
>> Not sure if I missed something.
>>
>> >+
>> >+              if (max_ptes_none < 0)
>> >+                      return collapsed;
>> >+
>> >+              nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
>> >+                                                             nr_ptes);
>> >+
>> >+              if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
>> >+                      int ret;
>> >+
>> >+                      collapse_address = address + offset * PAGE_SIZE;
>> >+                      ret = collapse_huge_page(mm, collapse_address, referenced,
>> >+                                               unmapped, cc, order);
>> >+                      if (ret == SCAN_SUCCEED) {
>> >+                              collapsed += nr_ptes;
>> >+                              continue;
>> >+                      }
>> >+              }
>> >+
>> >+next_order:
>> >+              if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
>> >+                      const u8 next_order = order - 1;
>> >+                      const u16 mid_offset = offset + (nr_ptes / 2);
>> >+
>> >+                      collapse_mthp_stack_push(cc, &stack_size, mid_offset,
>> >+                                               next_order);
>> >+                      collapse_mthp_stack_push(cc, &stack_size, offset,
>> >+                                               next_order);
>> >+              }
>> >+      }
>> >+      return collapsed;
>> >+}
>> >+
>> > static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>> >               struct vm_area_struct *vma, unsigned long start_addr,
>> >               bool *lock_dropped, struct collapse_control *cc)
>> > {
>> >-      const int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>> >+      int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
>> >       const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
>> >       const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
>> >+      enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
>> >       pmd_t *pmd;
>> >-      pte_t *pte, *_pte;
>> >-      int none_or_zero = 0, shared = 0, referenced = 0;
>> >+      pte_t *pte, *_pte, pteval;
>> >+      int i;
>> >+      int none_or_zero = 0, shared = 0, nr_collapsed = 0, referenced = 0;
>> >       enum scan_result result = SCAN_FAIL;
>> >       struct page *page = NULL;
>> >       struct folio *folio = NULL;
>> >       unsigned long addr;
>> >+      unsigned long enabled_orders;
>> >       spinlock_t *ptl;
>> >       int node = NUMA_NO_NODE, unmapped = 0;
>> >
>> >@@ -1429,8 +1579,19 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>> >               goto out;
>> >       }
>> >
>> >+      bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
>> >       memset(cc->node_load, 0, sizeof(cc->node_load));
>> >       nodes_clear(cc->alloc_nmask);
>> >+
>> >+      enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);
>>
>> Would it be 0 at this point?
>
>If your question relates to the issue you brought up above, then yes,
>max_ptes_none would be 0 if it's uffd-armed. We must recheck the
>uffd-armed status before modifying it to 511.
>
>>
>> >+
>> >+      /*
>> >+       * If PMD is the only enabled order, enforce max_ptes_none, otherwise
>> >+       * scan all pages to populate the bitmap for mTHP collapse.
>> >+       */
>> >+      if (enabled_orders != BIT(HPAGE_PMD_ORDER))
>> >+              max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>> >+
>> >       pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>> >       if (!pte) {
>> >               cc->progress++;
>> >@@ -1438,11 +1599,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>> >               goto out;
>> >       }
>> >
>> >-      for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>> >-           _pte++, addr += PAGE_SIZE) {
>> >+      for (i = 0; i < HPAGE_PMD_NR; i++) {
>> >+              _pte = pte + i;
>> >+              addr = start_addr + i * PAGE_SIZE;
>> >+              pteval = ptep_get(_pte);
>> >+
>> >               cc->progress++;
>> >
>> >-              pte_t pteval = ptep_get(_pte);
>> >               if (pte_none_or_zero(pteval)) {
>> >                       if (++none_or_zero > max_ptes_none) {
>> >                               result = SCAN_EXCEED_NONE_PTE;
>> >@@ -1522,6 +1685,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>> >                       }
>> >               }
>> >
>> >+              /* Set bit for occupied pages */
>> >+              __set_bit(i, cc->mthp_bitmap);
>> >               /*
>> >                * Record which node the original page is from and save this
>> >                * information to cc->node_load[].
>> >@@ -1580,10 +1745,11 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>> >       if (result == SCAN_SUCCEED) {
>> >               /* collapse_huge_page expects the lock to be dropped before calling */
>> >               mmap_read_unlock(mm);
>> >-              result = collapse_huge_page(mm, start_addr, referenced,
>> >-                                          unmapped, cc, HPAGE_PMD_ORDER);
>> >+              nr_collapsed = mthp_collapse(mm, start_addr, referenced, unmapped,
>> >+                                            cc, enabled_orders);
>> >               /* collapse_huge_page will return with the mmap_lock released */
>>
>> collapse_huge_page will return with mmap_lock released, but mthp_collapse()
>> may not?
>
>We are now releasing the lock before calling mthp_collapse, which
>subsequently calls collapse_huge_page. Even if `collapse_huge_page` is
>never called-- say, because enabled_orders is 0 (which should not
>happen) and all collapse orders are skipped (never calling
>collapse_huge_page)-- we still return here with the lock dropped.
>
>I think this is sound. Let me know if you think differently.
>

You are right. I missed the lock is released in previous patch.

>Cheers :)
>-- Nico
>
>>
>> >               *lock_dropped = true;
>> >+              result = nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
>> >       }
>> > out:
>> >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
>> >--
>> >2.54.0
>>
>> --
>> Wei Yang
>> Help you, Help me
>>

-- 
Wei Yang
Help you, Help me


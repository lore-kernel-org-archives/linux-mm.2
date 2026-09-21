Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7F6C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04C36B00B0; Mon, 21 Sep 2026 12:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADC976B00C8; Mon, 21 Sep 2026 12:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CB196B00C9; Mon, 21 Sep 2026 12:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A89F6B00B0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:21:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E523BA0252
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:21:25 +0000 (UTC)
X-FDA: 85238284530.08.AE92CCF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9FC60140013
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:21:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pUf8M6np;
	spf=pass (imf26.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790007684;
	b=mIVV7InYUrRDdQOL4F3u/iLYr71P97iIEVN5rPGKbPy23rXvv/ZSaPMfeR7ubLituxYYy7
	i5HdhKiYcLpECHnhJlnlLUssYp8dsXPzFFrPamKJiROZl6zSZQOdGzts07pJ0YURwsGK9w
	KEn66hjL7OlwvgYTG/e2X27FMZ5vC6s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=pUf8M6np;
	spf=pass (imf26.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790007684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/p/wcPtAYiIR16GkUrLsbGWfaNUG1APNWwlFrFY+MPk=;
	b=5EUB4DQu2thbttKOBK/bTj8u6Nh3EyVot3V+v8zjub7psBShz9EAgsJRNdPGCY6oxx556A
	VgDF1IsUj5NaVUKH9KpvuttuN8jya7RkJWjHggOlWh47vOKAviPH2ugin4BV73zvwvytOi
	zyVkp4GKfaNEpnNjQ+rZB0g+H+is1fU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=/p/wcPtAYiIR16GkUrLsbGWfaNUG1APNWwlFrFY+MPk=; b=pUf8M6npYUllN36pF1Jjui7cUH
	0cJnXOLLz8IMSoZFJYPgc5lro6QvvcAllD8kT8yvE2oXFQprRQN7QLqZcTyDV+/8rFVjXMhuvVI4c
	mWHFSIlZyvQAbCSPpjRnrW7h03Dt13F+2Qa/Di9V411h9xwD421wQBb0B8hrQkPwEnoZSwLlA8b3c
	Kfkv8In7DpmocmZwhpAHIvZc9azVaZuBZ7uGZh5Y7LrzlnECHlH4ORj71wjsVVkvIkxXQY7w3Ow7z
	53Tv7T57hxQw+gODKEoIK9DtM5Pxbl1EDRuIQGHtUrD4gv23z7yDTkKGm1qzW6a6kZ4r/O3ZyUV15
	Yc6W3yIg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8gl0-00000002oNa-486R;
	Mon, 21 Sep 2026 16:20:43 +0000
Message-ID: <c0c67459-6b75-4bcd-b068-3752e23afbf6@infradead.org>
Date: Mon, 21 Sep 2026 09:20:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 21/21] Documentation: mm: clarify behaviour of
 compile-time folded page tables
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
 <20260921-dummy_ptxp3-v1-21-cd40cf68242e@arm.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260921-dummy_ptxp3-v1-21-cd40cf68242e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9FC60140013
X-Stat-Signature: 1qd7qmrspig6wdxd8sqh9opfz9cn9uwg
X-Rspam-User: 
X-HE-Tag: 1790007682-221507
X-HE-Meta: U2FsdGVkX19BcBNW2Ki5WnLIATASt9RZKe2HcBDLcuQySMCTbF6O0NcOnLDKbEhC5XLrV1tpEjbiqokWE8iR00LqvwtwMgrPXEO8OMcHBs3uxnkx8xmvEZz/ZE+d4efzbX4Co6vfiUhAp6tXR7k+CBlSPXuWAlxfgtu31FiYNpj70pBK3bF0Xq7CVIS3TD9/Q3GAikiAB3Wh+Ay/MFLC7W9ljoxWBa/v4lhw3XHWFTQqoL+1aaaOaBogXSFXwio8gPs4sGxbFAechETHivHyYyMJlUueo4SFDsQeh7fa23itG80M76OL1eD7zIK+Dze1Wtkq9fX7f4sm8K8A6NKVnnGxKRk8k6t6tqgqqlcImUGgklIJ1HbdJCK2rlYCLMWOtJVmJufYhEnTYQLBF2Q7VPC2tTeVBplNUHxdM6nWMpuD9UYjRUhcppdJaNEQAX/md3apSuTKDJ0qa/yGdrolv8NIcZ0/OsIo65XGNEZ/4T3FZ+tvh32KZFKf82c+tTG0Esz92KPfELPI1TBt3/ta0CquUuI+mh2mz+dyZdYyc+chtmAKPbqnv6hArVJkKtNo8STNattS437DpguA99CqKCsZbYpxVx2526GEpbMffsfXNH6mrfLRyNPCDK56DnUxvUTFHPQnaJTNLl1WpBgJl0eUymqhXYQ5mu3xx3aKQ28iRHALPgDtkqIMJyMLcGDnY+Zb8rYyEblWX9EJobOblByt0BnvQmC6sXoVcON7drx1fWeerqNpolGEZexutg2llJbq+MGJ5CKXJxcb+KlkdV5XP6mIWaMSm74ScqXgtoNntDsKP7SMIHOHdH9exZf5K4BguqkK3bf4ntbLWngg4yYmp+D92oQlSrHxbPTg7jgevifEVPTxjFCxbymsGu4CcX6aSHvVglrBFK0BTg4f6GQLIutOFXnyepexBHCkxlPZytEFBNgo0E/vCUIjJLLnLQNb911vMNWoP3hXx3u
 s4m3nwA4
 0pLxtq7CCUi6SDpOkC3KN/J/pzYEsEKQqKRuLj70bWEoelm/WDbq6w+bxt2HcQ/jKf8bDPFn61guQJxHn7HhhMGZQdveI78qjc2sseBhnq+XwUsZ5sM3riaeMWDTVlyo07qoPw01iemYhopovlaSNMrM9Au7tPVLA38TmnpXcft9J7n+8BScjbgu6tWjud4YPCZMqfNeFghwzSDjPNn+DJxyL7OR4NhMWReRaAGkH8BKIXSD0KJpzPrLSyAVWIjjYaE0RaPlxB8Zsq/Nhs7farh2uRnL08diFyd+YyMbyjEhAmXqkh/Tj7UMmwNRqEfHIsAM8D9wT2oRniSA4FFyXbuD6Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 3:55 AM, Yeoreum Yun wrote:
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> Compile-time folded page tables are not necessarily easy to understand, and even
> people the were once familiar with the concept might need to refresh their memory.
> 
> Add proper documentation, including a nice diagram, for the current design.
> Mention details about dummy functions, including the recently changed pXdp_get()
> helpers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Documentation/mm/page_tables.rst:197: WARNING: Bullet list ends without a blank line; unexpected unindent. [docutils]

See below for a fix.

> ---
>  Documentation/mm/page_tables.rst | 84 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 75 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/mm/page_tables.rst b/Documentation/mm/page_tables.rst
> index 126c876282509..84f2715c7de0a 100644
> --- a/Documentation/mm/page_tables.rst
> +++ b/Documentation/mm/page_tables.rst
> @@ -143,15 +143,81 @@ pointers on each level is architecture-defined.::
>  Page Table Folding
>  ==================
>  
> -If the architecture does not use all the page table levels, they can be *folded*
> -which means skipped, and all operations performed on page tables will be
> -compile-time augmented to just skip a level when accessing the next lower
> -level.
> -
> -Page table handling code that wishes to be architecture-neutral, such as the
> -virtual memory manager, will need to be written so that it traverses all of the
> -currently five levels. This style should also be preferred for
> -architecture-specific code, so as to be robust to future changes.
> +Not all architectures support 5-level page tables; while for some of them
> +the exact number of supported page table levels is known at compile time,
> +others can determine the number of page table levels at runtime based on
> +hardware support and address space sizes.
> +
> +Generic page table walking code always assumes that 5 levels of page table
> +exist. To make page table walking code not have to worry about that,
> +`compile-time folding` and `runtime folding` of page tables are used.
> +Compile-time folding is mostly handled in common code, whereas runtime folding
> +is exclusively handled in architecture code.
> +
> +This description focuses on generic compile-time folded page tables; for
> +architecture-specific variants, some details can vary, however, without
> +affecting common page table walkers.
> +
> +When walking folded page tables, all upper page table levels up to the supported
> +level are skipped in page table walkers: this is achieved by (a) treating
> +entries in upper page table levels as present and pointing at a page table; and
> +(b) having page table walkers cast the entry pointer to the next-level entry
> +instead of dereferencing that table. From the perspective of a page table
> +walker, the entry points at itself.
> +
> +Assuming compile-time folded 4-level page tables, to achieve (a), pgd_present()
> +and pgd_leaf() are hard-coded to indicate a present page table entry that
> +points at a page table, and to achieve (b) p4d_offset() and
> +p4d_offset_lockless() simply cast the page table entry pointer to the next
> +lower level.
> +
> +In the current design, this is further modeled by having the P4D have a
> +single page table entry::
> +
> +        PGD
> +  --> +------+          NOP4D
> +      | ptr0 |-------> +------+           PUD
> +      | ptr1 |-        | ptr0 |-------> +-----+
> +      | ptr2 | \       +------+         | ptr |-------> ...
> +      | ptr3 |  \                       | ptr |
> +        ...      \                        ..
> +                  \        NOP4D
> +                   +----> +------+           PUD
> +                          | ptr1 |-------> +-----+
> +                          +------+         | ptr |-------> ...
> +                                           | ptr |
> +                                             ...
> +
> +Note that the arrows from PGD to NOP4D represent page-table-walker
> +transitions, not pointers stored in the pgd entries.
> +
> +Using p4d as an example, `nop4d`/`p4d folded` translates to the following:
> +
> +- p4d is considered folded into pgd; both are operating on the same page
> + table.

     table.
(add one more prefix space to align the indentation)

> +
> +- Most pgd_* helpers are hard-coded dummy functions that ignore the passed
> +  pgd_t values entirely. Exceptions are pgd_val() and low-level helpers
> +  set_pgd() + pgd_page_vaddr(), which effectively translate to set_p4d()/
> +  p4d_pgtable() to keep existing arch code working.
> +
> +  Architectures must provide p4d_* helpers (unless further common
> +  compile-time folding applies).
> +
> +- PTRS_PER_P4D is hard-coded to 1. Architectures must define PTRS_PER_PGD.
> +
> +To avoid reading a value that will never be used but cannot be entirely
> +optimized out, compile-time folded page table code also makes pXdp_get()
> +return a constant dummy value.
> +
> +In common code, this only affects pXd_val() when used for printing page
> +table entries for debugging purposes. As we don't want architecture code
> +that uses set_pXd(), pgd_page_vaddr() or pXd_pgtable() to accidentally
> +operate on dummy values, the compiler will error out if it detects that the
> +helpers are used with dummy values. For a folded level, pXd_page() must not
> +be used and unconditionally triggers a compiler error. Architecture code must
> +instead call the helpers on the proper first page table level: e.g., set_p4d()
> +instead of set_pgd().
>  
>  
>  MMU, TLB, and Page Faults
> 

-- 
~Randy



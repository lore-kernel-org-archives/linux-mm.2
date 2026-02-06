Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A9A0EB28FA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8E3F6B0089; Fri,  6 Feb 2026 04:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A625A6B00A5; Fri,  6 Feb 2026 04:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A8B6B00A6; Fri,  6 Feb 2026 04:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 807206B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:36:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E1C6BAEBC
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:36:35 +0000 (UTC)
X-FDA: 84413526750.27.2AD24EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6F36D4000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:36:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RtXyxhUl;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbsPNX8uMtQVdsLlBiz/HRfYJplJxOfhh9yHv9SyhNw=;
	b=d3Gk1a6aspgVuaZ8CNMxThhJomRgAjIkxcBxIdHi4lXT8Mc27Kpz+l8dLmOyG+p3kUUXxe
	D2dyg8XEqpYOJTE0k0nOL5S2hjtMJc3Esj91VvrubV8jIvUIWXwyOe0WZn97pTZL4tLdqS
	ha98bmBGtL5dIrNRTVCKc1mt5bjYtCE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RtXyxhUl;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770370593; a=rsa-sha256;
	cv=none;
	b=3mEh3iqf0nwFjsubfkjDZEoFumViW9nrbqIoBz18i+fFp7XrjMkclHszggCy7dpbUVJrEV
	tpHe0NI9Y2/wiqZwRJVIxuk8P1kSBsAi8uXuXIjl1FBMeosLsraRiuy3ddaT815UJ609GY
	Q7ZKhUs71kKYGaeb6odgoxoP2DDUo94=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37C5B42AE0;
	Fri,  6 Feb 2026 09:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F87C116C6;
	Fri,  6 Feb 2026 09:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770370592;
	bh=l8Fj/023PJxXbH0Z5uzpECT9RXbJgRSHplYgq+pm8fs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RtXyxhUlqdIqL97gdfK2G+tqkx4gG1wk6EyIvfQ2g11VN/Nv2NzFaLMYlDc5LAnS/
	 l5ceRRf8F169VZTzH2MOPFGaFb7YLAoodmqdt/qnaXbloi/wZgWPxDdYjx22j9eU1D
	 YNwGiBfVKXOq/YqTvIvudoetXoLHYAD4v+2OYgyWH9yPme1IYRAPvRAHxkf7sYa3w5
	 YpPccUUgm7tDakvcDeKkBxafXTwsxHphbGcO58DJ94+ntRtweAEDEAo0A/KWpOiWv5
	 YnHYlJesvXMrFM0/97ZkvQsnSeZsdjqa2su1C9DyTaMZUgx9+JJyq+hzZPYlUnLKvM
	 dpZPjx10HeldA==
Message-ID: <3fcbad05-bef2-486a-8d9b-7010a91c85b8@kernel.org>
Date: Fri, 6 Feb 2026 10:36:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 11/17] mm/hugetlb: Remove fake head pages
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-12-kas@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260202155634.650837-12-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f53xsmspsr7fwpycg9os3erwie5sg58j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F36D4000A
X-HE-Tag: 1770370593-932983
X-HE-Meta: U2FsdGVkX1/acPgdWKAiGZ9QtPySNOSCGvrDdM3w5pIBSqERJxGqcqXgitZntA12aoz67mvS7ai59cxoh9ru96e5pJsCxgABzvv7RhOfsHXq9as0qiusU3PSlU7LEF8yOg3mk8YbTQ491NUmUdmg0/lU0J/g/oQ6X2t4wcj8VkjwSENWLvsteU8VzyCzc92Q40x5wZ2n3fLql0zbEXGB6DP4neJC2lAgBL5i2u+buh9UzQP3sjyeISKzSJHnuAPnWnfZ9a56Qibt/DzNykK/WbGhmI018kl1wl/vz5vbvzt+CdbyGQ6lSsOlEF1UTI/qkGrW/WR9eIqUCEvhQcnbIodW5NLxKUfRG/Xvm/xtA0Wz4Yn8aCKHkQHIkl+VqVwnA/VtqQcHT/AiI9AybVidMi3FT85sJO1UUGZpv079UaroW7h/3JKYO119707I7EmYIpy+koNV+4eVAh60D0/9Q/ZTm4ax6Xc1+XXMyAABhIn4cI0aT9dRueQyxfyFxFUqHp4c7yfQAxbafFg9raC7Qo4pafRrPus/GRqi89LBeXXzURayMRbyVoiEnDvt4JqnKbczFHgVmEJ3Nj+Aw1VN3/xlGSvaj8IbPqhUrSsFYZcqVyhUXI6LbTfRgH7JTc3WzK+wueGB5hyLp6QwMf1AhpKTiHzAcsyB0Rma6pPT3Auyge2ut4ckWs/MTy6YQb5c203dco/94IoWiWyP0gIwTd9rQvDUsQj17F9U1HBTtK9KWBJ2oHuOrtdQwf12GR3HP1acBkb8hKoi50FZIhD62B+I4Xk341SvVvsFHpqW4VsgqoW4q+1m6Kia32YvCULEkB3R1i6I0pnTvNpNg2Ler9zAydH5bQdTLANiBjCANW/7R7luC9f7M7OzwuM/1Ti0jnlpJo8sEbj9FrRGP8OqBkqGK0JjHSTIPhI4LRV9/UFtMX+NQnKQTzxg8Aa9Jq++eDbeT+vn/u0oiLmsXbc
 7BAaJ5kA
 J0Ddgvqbnnt/B0N526CyMjDMNZlBlDoKQvwtHrMLf1XDC3PUfC3ssfFjMcvALlrsUAo99FUqk97/uAFOA/PKkzYNVm5WHkL/MjcZ6349l4q5FR/rzlUAoeoHZ4/KmFpQSVDPgQKnUWx2ZswTinlS+wzUzYH+Hs86xV4j9EmjKnG2mcf2s2wgCYDiwcfS2qj5wx2eOdnd6BTlBjRqUK7rRlkFy1ZY39EEr+R6vCM2DKDIWsDOd+Uxi/WPLqZSD4kTvw4ZByR6Mzi5D3z+gS4Ja+rPVT2YllrVjBntapl20aPqOr/H9Uyj9yHGiNG7o+82RIctj/857yrCXYl4sN+KiNoO3vw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> vmemmap pages for huge pages and remapping the freed range to a single
> page containing the struct page metadata.
> 
> With the new mask-based compound_info encoding (for power-of-2 struct
> page sizes), all tail pages of the same order are now identical
> regardless of which compound page they belong to. This means the tail
> pages can be truly shared without fake heads.
> 
> Allocate a single page of initialized tail struct pages per NUMA node
> per order in the vmemmap_tails[] array in pglist_data. All huge pages of
> that order on the node share this tail page, mapped read-only into their
> vmemmap. The head page remains unique per huge page.
> 
> Redefine MAX_FOLIO_ORDER using ilog2(). The define has to produce a
> compile-constant as it is used to specify vmemmap_tail array size.
> For some reason, compiler is not able to solve get_order() at
> compile-time, but ilog2() works.
> 
> Avoid PUD_ORDER to define MAX_FOLIO_ORDER as it adds dependency to
> <linux/pgtable.h> which generates hard-to-break include loop.
> 
> This eliminates fake heads while maintaining the same memory savings,
> and simplifies compound_head() by removing fake head detection.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

[...]

>   #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index a39a301e08b9..688764c52c72 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -19,6 +19,7 @@
>   
>   #include <asm/tlbflush.h>
>   #include "hugetlb_vmemmap.h"
> +#include "internal.h"
>   
>   /**
>    * struct vmemmap_remap_walk - walk vmemmap page table
> @@ -505,6 +506,32 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
>   	return true;
>   }
>   
> +static struct page *vmemmap_get_tail(unsigned int order, int node)
> +{
> +	struct page *tail, *p;
> +	unsigned int idx;
> +
> +	idx = 

Could do

const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;

above.

> +	tail = READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
> +	if (tail)

Wondering if a likely() would be a good idea here. I guess we'll usually 
go through that fast path on a system that has been running for a bit.

> +		return tail;
> +
> +	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
> +	if (!tail)
> +		return NULL;
> +
> +	p = page_to_virt(tail);
> +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +		prep_compound_tail(p + i, NULL, order);

This leaves all pageflags, refcount etc. set to 0, which is mostly 
expected for tail pages.

But, I would have expected something a bit more from 
__init_single_page() that initialized the page properly.

In particular:
* set_page_node(page, node), or how is page_to_nid() handled?
* atomic_set(&page->_mapcount, -1), to not indicate something odd to
   core-mm where we would suddenly have a page mapping for a hugetlb
   folio.

> +
> +	if (cmpxchg(&NODE_DATA(node)->vmemmap_tails[idx], NULL, tail)) {
> +		__free_page(tail);
> +		tail = READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
> +	}
> +
> +	return tail;
> +}

[...]

> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -378,16 +378,44 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
>   	}
>   }
>   
> -/*
> - * Populate vmemmap pages HVO-style. The first page contains the head
> - * page and needed tail pages, the other ones are mirrors of the first
> - * page.
> - */
> +static __meminit unsigned long vmemmap_get_tail(unsigned int order, int node)
> +{
> +	struct page *p, *tail;
> +	unsigned int idx;
> +
> +	BUG_ON(order < VMEMMAP_TAIL_MIN_ORDER);
> +	BUG_ON(order > MAX_FOLIO_ORDER);
> +
> +	idx = order - VMEMMAP_TAIL_MIN_ORDER;
> +	tail = NODE_DATA(node)->vmemmap_tails[idx];
> +	if (tail)
> +		return page_to_pfn(tail);
> +
> +	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
> +	if (!p)
> +		return 0;
> +
> +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +		prep_compound_tail(p + i, NULL, order);
> +
> +	tail = virt_to_page(p);
> +	NODE_DATA(node)->vmemmap_tails[idx] = tail;
> +
> +	return page_to_pfn(tail);
> +}
> +
>   int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
>   				       int node, unsigned long headsize)
>   {
> +	unsigned long maddr, len, tail_pfn;
> +	unsigned int order;
>   	pte_t *pte;
> -	unsigned long maddr;
> +
> +	len = end - addr;
> +	order = ilog2(len * sizeof(struct page) / PAGE_SIZE);


Could initialize them as const above.

But I am wondering whether it shouldn't be the caller that provides this 
to use? After all, it's all hugetlb code that allocates and prepares that.

Then we could maybe change

#ifdef·CONFIG_SPARSEMEM_VMEMMAP
	struct·page·*vmemmap_tails[NR_VMEMMAP_TAILS];
#endif

to be HVO-only.

-- 
Cheers,

David


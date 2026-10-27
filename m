Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1368606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VNcfMMVw
Received: by kanga.kvack.org (Postfix)
	id 9CD836B06D6; Tue, 27 Oct 2026 08:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D0D6B06D7; Tue, 27 Oct 2026 08:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846D16B06D8; Tue, 27 Oct 2026 08:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63D336B06D6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:07:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5788120A16
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:07:21 +0000 (UTC)
X-FDA: 85368281082.26.8D47029
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 19D8640006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:07:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VNcfMMVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793102840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qa5CSr7uQIwst0qSmysxe9s+lZC1h4R1TF3I9gk2Z6Y=;
	b=E/jAjBW0OdDcT5jHDe4hI02wmruXitWdvmdI3MBHTkLHGZ0yo1kCmfAP9S2XIVRT/Zsyvy
	p0zNOPdS3XfyttLyeLyOyvGrJngIHpkvqPU7xhzNuSS+5kTRB5Gvdsg4Nj7jciKOlcRpyt
	UAnLvbwMw1ngwGS/PhL/fbMgGUdpBzc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VNcfMMVw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793102840;
	b=uB1JJ+V/74WY2MsDfhcaX/QbX63gGKxwuFoW6AoSol1hVJ9PzsJt6Oo/PUFPhjCaVV3R+K
	486XzLMU+aDLWYLeCoGc03SkTomdG4JZZQDG7LjjB4ycqBsH/Y6iAkJqO1uQSgN51kqPXB
	fiGGiWRye+KWlwK+7EF3R4zoRVvAGCU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4723442B12;
	Tue, 27 Oct 2026 12:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6E71F01825;
	Tue, 27 Oct 2026 12:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793102839;
	bh=qa5CSr7uQIwst0qSmysxe9s+lZC1h4R1TF3I9gk2Z6Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VNcfMMVwwOoyBO3YNPRzJKXAMnN7tgWXQW2Ac3SuUxS4/5Wb1RvIZ2DlTJz+fjbtl
	 RAJeHkUSBr2T/riaHmgrwr/aXpSi0J7PaE2oei8gSy5QA/B0F72CnGOs0gn2mr2dUK
	 8vklYkOVhmKznj1r4zloDuNVEuGEMzt5OcuF26V8Q0Nny4dNOyET1f+VMt9djx1aig
	 pWnytNsfWekIVlH2EDDB3dGkmzytn7LB0V7t/s0RVtv7rSofF9HbwIAnSse9itcA3z
	 KcViAEaPuT0diDjiUxIIPbHu5BlGOgbOV8yc+xkGR93Hf9LmM9uCyuLEl6QzL+A649
	 EGHAy08LT3TTA==
Message-ID: <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
Date: Tue, 27 Oct 2026 13:05:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
To: Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auCKv_omLGRc6wv2@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19D8640006
X-Stat-Signature: hx9kp9fbpeikmeuhwwugoppqyp84i51x
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793102839-765246
X-HE-Meta: U2FsdGVkX1+T+FltBiMiFGdtPHfPFQiT242132FZPWwYiHgGX5pk8XpErsdcL/wd2QhXNS76DKsl5jniiMGbDWb8/MabQhYQTFNg+OogrS0D8kmPeee+2Jr0A7+pYfGmzwdXPHT9QABgb7f8XkpUc0/dft+NCH6nrOoBLyP0eAsgD4eVlEKS1aGZJyZD4dq0jQTNsrst0knyth7T8BpfPMQ/dxuLooBPvG7UGrnSdQi95FmB2FHVdGhCDDYWFnj/nO4fqFDApICXkRWkOCuOP40x0SzOc0HplXULoOSTvR3/1/QncpwhOBWribxjVxyWROHyY2fQfUDXcI4uOIS2TTxNZ0OkUHLSFHRxTr5rUELoHzz4iywGeD/YntFyqiqfCwTQ1/HGZ9qZTd0xhjO2B2YO2XMe0uLbJcVrtbz15xXI6C3cy/N6zHcc8zYSqW5SLHdszY9WDnnO4ETIvzRXCVJFfWsgeNyxnbUuFKdIbiMKDuNGoeCgj9RsdAKPRs75qj5JiTiHfKDcAsp4xYdZpIjGtrBg0dTYXU8UNfHTS991JasJCJIEQ4CuEJ5t9cjOElpLKTV08robJtot9oDY0WBLJ8ifVsxxyrY0bLCz9KCtBY0xwL0ISG55rIRkiTO4QZQf5W9bDZuhKXFFFLPd0Dxk7dIb9zzRHR2wUdLXHVMXHAaDnHkymw9qavoQrQqiY3WZWrXhxx/uzH5sDjcxezzigLlHbNQ0J3JM1CASgglevIlRgKmcaTr2JEjCHKOMzDOgd74l3BJ2J9exb3sBEZMDmra3jF/4MDD4v+Bv7iPv5aPi/DUw6lqQ6+fXE/28pOcT0M5VXuwSyN97wFt5U2gswfFcwgQY8N1Bv8ng7UmfWtZX4FdzU640MXpo/8/X4PnqAdu6It1lowms9h2uduefDdVsT4diNoHIAsQJx2Yz373LCgibtN1rApIA+H8jySFWsbUYJvgGc2ok/Id
 9jsTLspv
 l+HYNKxzbq16pCcvSMtOorLNYFYMvXAgbWH49TyKgfAuLMVWXUJn/DR3zs2JTBOMtm/MyOw30E/Cg7tOZJ/vKhq2z3MbiVxV3jg/ARKIHw6ZbtDr8lqHqVOmn+F8hquDMVrPM8zR8jk2yg/DcT3/wJYyH+tqLgmp2CajTq6SZ91289xx8YfyhQ5G2cU3zXgrhtzCPQAnw33KN10HohXgHZbPRxLBVphrLTqf4qBPzwB0oLlwKeEnEursjfNfcBrnZwchQ4ww+cihlkTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 13:00, Kiryl Shutsemau wrote:
> On Tue, Oct 27, 2026 at 12:00:28PM +0100, Peter Zijlstra wrote:
>> On Tue, Oct 27, 2026 at 12:37:13AM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> I'm sure x86 folks will have an opinion :) . Let me CC them whether something
>>> like that would be acceptable.
>>
>> This looks quite terrible, doubly so because I have no idea what its
>> trying to fix. Please try and justify this insanity.
> 
> Fair enough. Here's some context.
> 
> HVO (HugeTLB Vmemmap Optimization) frees most of the memmap of a hugetlb
> folio by remapping the struct pages after the first vmemmap page to a
> shared page, mapped read-only.
> 
> Every lockless get of a page reference (e.g. page cache lookup, PFN
> scanners) relies on page_ref_add_unless_zero(), which is
> atomic_add_unless(&page->_refcount, nr, 0).
> 
> The page can be freed and reused between finding it and the get; the
> zero refcount is what makes the get fail. The race:
> 
>   lockless get                        other CPU
>   c = atomic_read(&page->_refcount)
>   c != 0
>                                       page freed
>                                       page allocated as a hugetlb tail
>                                       HVO remaps it read-only
>   try_cmpxchg(&page->_refcount, &c, c + nr)
>     -> write fault on read-only vmemmap
> 
> The refcount is zero by then and the compare fails, but LOCK CMPXCHG
> writes anyway.
> 
> Before v7.1, HVO mapped the tail vmemmap pages to the head vmemmap page
> of the same folio. The first struct page in each of them read as the
> head, with PG_head and the head's refcount: a fake head. A get on a fake
> head of a folio in use always tried the write, not only in a race, so
> page_ref_add_unless() checked for fake heads before the atomic.
> 
> Back then, the race above was closed by bd225530a4c7: rcu_read_lock()
> around the read and the cmpxchg, and synchronize_rcu() in HVO before the
> remap. The refcounts are already zero by then, so the get either
> finishes its cmpxchg before the remap or reads zero and bails.
> 
> Since v7.1, tails encode the head as a mask instead of a pointer, so
> tails of the same order are identical and HVO maps them to one page of
> real tails, shared by the zone. Fake heads are gone, and every read-only
> struct page is a tail with a zero refcount. The race is not gone, but
> 32c440d67e6c and 01b1d0ffb6f7 dropped the RCU on both sides anyway, on
> the wrong belief that it was only there for fake heads. That is what
> David reported.
> 
> One fix is to put the RCU back. It works, but it means rcu_read_lock()
> around every get that goes through page_ref_add_unless_zero(), GUP-fast
> included, and synchronize_rcu() on hugetlb allocation and freeing,
> including surplus allocation at fault time. So I am exploring other
> options.
> 
> The fixup is one of them. With the new layout, a fault on that CMPXCHG
> can only be a write to an HVO tail, so the refcount is zero and the get
> fails, and the fault only happens in the window above. With GCC the loop
> compiles to the same code as before; clang adds a SETE/TEST per call
> site.
> 
> Writing this, I just realized that we have another option -- map the
> shared tail page writable. A failing LOCK CMPXCHG writes back the value
> it read, and the get never changes a zero refcount, so the race becomes
> harmless. The cost is the protection: the page is shared by every
> hugetlb folio of that order in the zone, so a stray write to any tail
> silently corrupts all of them instead of oopsing.

Right. Without HVO we would just corrupt pages in the single folio (which is
also not nice).

I'm also questioning whether we need this RO protection all the time active.

-- 
Cheers,

David


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1D2CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01CA76B008A; Wed, 14 Oct 2026 09:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F046B008C; Wed, 14 Oct 2026 09:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23786B0095; Wed, 14 Oct 2026 09:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC8ED6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:47:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 251C2160560
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:47:44 +0000 (UTC)
X-FDA: 85321359648.22.B550F5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 64D1B80010
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:47:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WEfRCoC+;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791985662;
	b=il20Df1xUwX46zxRBQ+ISAPswhQ5Y42R25LVCaReCCij286J7OmC8e2o91Uz06oYk605KA
	3WCDzAqFaQEPiZx3Re1S3Te/0SyKjHTwio0WuD+p84t5Gt8RnLRxWeX009YDfeBkMDcxhf
	KtlpvTlmOaMywyPT7Y9exz/X6cFYMs4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WEfRCoC+;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791985662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C7rEAmv2Y4mVbuWnXY5QYs9VkJecL6pHhI1EYgfL8BE=;
	b=DFJnjqt8Egu7uddHJpNVwWSiDJy6TFyyEvlNlTedCEMoB3FYZzV391RXVrgBvPgWwlpnKI
	ohzfsc/CkQ5jrvSxbtE4Hung/ubpexePagUuRGanj8nGwfweF4UInbeVm8CgCBlUeTrzVU
	4qHKR9+u8OCuxQlqpApmDab72zfta5k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D2E9360218;
	Wed, 14 Oct 2026 13:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5C41F00A2F;
	Wed, 14 Oct 2026 13:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791985661;
	bh=C7rEAmv2Y4mVbuWnXY5QYs9VkJecL6pHhI1EYgfL8BE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WEfRCoC+R3VRrxONOgWNcznZLQiKqTuza5mYVnkNZuvaQoJ9OUJ9u2bqGA65Ahlwm
	 HsZ5UrIVN/WL2No64DEttz0LSGxtBqmQgZKB+Z5Oe07i82Iwe7JSIdkrISY/7d83M/
	 8MkYEPtjHBOxPpkVnSNu6pRBNs84vL5TKqoQlI3RUGDLOWqHuOYGYpvz97Om9ePedo
	 Ht2EI32ZEgkgx3m5155e5WDtDL3dq2EM0KgRyr6OJuydmjvO7tdyXmT9QU4uGY61XB
	 jArsOcU/tAqClyseUQkjxH2GgXkM4QaSXMzEpEVH3JWuKR7hk5JuPMeuLGXbk0GMmW
	 tLwBdlMc7waSg==
Message-ID: <06930044-4bcb-4478-8a6f-2dd3cf6d290e@kernel.org>
Date: Wed, 14 Oct 2026 15:45:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Ying Huang <huang.ying.caritas@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Chuanhua Han <hanchuanhua@oppo.com>,
 Kiryl Shutsemau <kas@kernel.org>, Kyle Zeng <kylebot@openai.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
 <as4kvHe9IFZH5qrC@gremlin> <9add8400-66c1-47e9-b5af-7a4081ebf3c4@kernel.org>
 <as-BZibPscw4cxsD@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <as-BZibPscw4cxsD@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 64D1B80010
X-Stat-Signature: iofgaj14bqsbxusodny3eteee5mtin8m
X-HE-Tag: 1791985662-524023
X-HE-Meta: U2FsdGVkX18R/LrTWgEXU1qdp445mIYAwxnt9m+RYY/lD5Php1j0EFi/HVIfbvinT4uH//gX7xEWqTiq+1NPkTmhqeLaWhPkL8UNRubFu8q5nGAgC1lJt4Ht7UEOM6QnrLpHOXa7yCJnBxjoJZ9oKlpLze8uQFNGnF3TIfIxxwb+2eCROG8bO4VCy4YRMrWnDR+UW69rczepfJBI3mLi6qMSpsqS7V6FvcxMju/c+wr1Qz2RRkgk3sNticzaDe9Cd1crDmgMYDmDwHpSfpiT5OOWVEdaR/ejzO7YrNXOShunBBGCMPpoEGfU66nKQU5Qmo+tm9sfyDa9H5o5Xo4gmuxTgPrdYAi/o6HDvmQZbR6yMflaVsn1K6+KXrWdsDnyEcdW83rNWppQXgXfJhWhN2mNXWgfaZ6iCI9UxVt+4DHY3ZwU7Sq2iX5S3kSEiZ6c4lC49VvyREhn8coaepwz3sNCA50LGclcnvtf32KRKM7ATatYRUvZMasNQSPXHCOyQW01HHjDNdlpreazTKN34zN4p/SrnruQSIaOwqbYDmbXXARbl9HKEI9VuYg/ik6YeX03QRbT9zmat4j0K0xspHmPcP9oHHnd4AWhnniXeBTKQQpt5byc/B2FRh4FspydZEPCQlovKa0BrPQIPzle8D9YAFfbYsVoMKTHOW+K0h5vVKEdnok9fzkI/BkBla/DtzPhrZ4GtSWBt/cpi4r2UEbFI2xrXT1t3GQ9UY3qObtFQmzcTTo3GkSB0ZCN/1aUn9lDQi89dWW5Dr2i8lcXRp0CMV4Q+1Ol865YnOJ4BmmELL+3AKp0LL/2ANfWRV64/FmvUXnnjp6mFV4JCC+1m4Ezs0zZyhBZ8QexMgkoybEszXMfFAX+2H5fiv8J6rS/5DGWlLnKk7Xu08Tb9Kgjk3GVNUAk6qJ7ZVN8giZ8Huki0IQq7ldKKc2zYEnMGwaBLFHCtVwtbWQqXmA9M7V
 qzF0tbcc
 c+IkwMdEGKoGQko/c8d/tIbo9nV4S9c+EtZcmoWYTE21xZwMK16DEbJoxZdw4c+nvN7wQ4V7Kn+wi567cM0e0t80bv93wfESUCBQ/bipoHTlXePVz8cjeau51waIKZlxgj/HQMg8dZxT7gTp8PKGe1Jbz1L0oxBF0N1Y3GEVyRJJPa62GTvklE6aymoJbnlGGFC4XivSTpBOzboEu8Je0Gj6S3PwWOLPYlyf3sUPLDEDRqFs1q0EI8MKr3FDZW6VBelQvgtAmUz1vxlZ3XjqaGt6G6zb4Pcb5MayU3pVKxo00eDUZbKJiq1B+Cvlx530rw4s4yoDpYFxEyI7udEJvcSSxdJJ8/mM3iMYso8CN7dCOmFp7VxjHyBLi4QzBFfagYZ3M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 15:27, Lorenzo Stoakes (ARM) wrote:
> On Wed, Oct 14, 2026 at 10:12:06AM +0200, David Hildenbrand (Arm) wrote:
> 
> Since I'm convinced the logic itself is correct:
> 
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> This cycle is brutal enough not to hold up fixes :>)
> 
> 
>>>
>>> I know it's a static function but kdoc here might be nice given the number of
>>> params, including 2 output parameters.
>>
>> I had that, but decided "not worth it for an internal helper".
>>
>> Is anything here really that confusing to understand in mm/memory.c context? I
>> highly doubt it.
> 
> I mean I found it pretty confusing :)
> 
> But this is a nice to have it's not a big deal.
> 
>>>
>>> I don't love the name - to me it implies to me that you're scanning the range.
>>>
>>> Maybe clamp_folio_pte_range()? I guess though clamp implies it limits an input
>>> range.
>>
>> Ugly.
> 
> Yup, fair enough.
> 
>>
>>>
>>> Maybe get_folio_pte_range()?
>>
>> I can just call it "folio_pte_range()". Slightly similar (but different) to
>> "folio_pte_batch()"
> 
> OK that works.

Ok, let's do that.

>>>
>>>
>>> This is trickier :)
>>>
>>> I guess you're doing this in case either bound is right at wraparound
>>> somehow?
>>>
>>> But then couldn't the +1 push you over the edge?
>>>
>>> Oh wait no, because then vma->vm_end would have to equal 0, which would
>>> fail the other-place enforced invariant that vma->vm_start < vma->vm_end.
>>>
>>> So it's pmd_end that could overflow, hence the -1, +1 dance.
>>>
>>
>> Yes. It's fairly common, though, to handle clamping of exclusive ends that way.
> 
> Right, it took me a while to figure this out though.
> 
> It involves an implicit assumption in there too, that _one_ of these values is
> known not to overflow.
> 
>>> #define pmd_addr_end(addr, end)                                         \
>>> ({      unsigned long __boundary = ((addr) + PMD_SIZE) & PMD_MASK;      \
>>>         (__boundary - 1 < (end) - 1)? __boundary: (end);                \
>>> })
>>
>> As replied elsewhere, I had that, but decided to open-code as pmd_addr_end() has
>> very weird semantics with folded page tables, where we just don't clamp at all.
> 
> Hmm how so?
> 
> The logic seems, at a glance, equivalent?

It's the following thing that adds confusion:

include/asm-generic/pgtable-nopmd.h:#define pmd_addr_end(addr, end)
       (end)

I think we have to assume here that with NOPMD we will never end up in this code
because large folios will not apply (each PMD table has exactly one entry as of
today, so we cannot map large folios .... I think).

I can try condensing that in a comment and cross my fingers that that is the
case. I tried that now. and codex review already tells me:

  • [P1] Folded PMDs can reach this helper — memory.c:4948 (mm/memory.c:4948).
The comment’s assumption is false: arm64 with 64 KiB pages and 42-bit VA uses
folded PMDs and supports THP and
    NUMA balancing. Here, pmd_addr_end() returns vma->vm_end without clamping. A
large folio remapped across a PTE-table boundary can therefore make
numa_rebuild_large_mapping() walk beyond
    the mapped PTE table. The previous code explicitly limited this to pt_start
+ PMD_SIZE. Cap the forward distance at PMD_SIZE - (addr & ~PMD_MASK) as well as
the VMA and folio limits.

Let me see if there is any truth to that ...


[...]

> 
> As above, I tagged it, for the purposes of a fix let's just get this in.
> 
> But no, there's not overthinking IMO, it took me a long time to understand what
> you were doing here, and there's a lot of implicit understanding in there.

What I am saying is that I don't agree with adding another two const variables
with names that are less intuitive than just saying the computation. Let me try
to improve the comment:

/* Avoid address wraparounds by not adding/subtracting beyond limits. */

-- 
Cheers,

David


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FCA0CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 14:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954F98E0007; Thu,  2 Oct 2025 10:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9058F8E0002; Thu,  2 Oct 2025 10:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842AF8E0007; Thu,  2 Oct 2025 10:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7231E8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 10:05:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B57BB9D3F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:05:13 +0000 (UTC)
X-FDA: 83953346106.20.04575BF
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2E75A1C0016
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:05:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CNVvnxRq;
	spf=pass (imf18.hostedemail.com: domain of 3lYbeaAgKCGoRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3lYbeaAgKCGoRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759413911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEqoonS/rPWcCApF7kzwVCksNrnIyl6aIHb9y9yvEE0=;
	b=rHzf34VzjIWOycShEnG+DpnDGtn3mdw5dPdp2XDmvrLDmj0p4WpuWO7LO+vxvaJtnXDYHW
	rsFwagvePbvud4U2cke/8Sp2aNHZqcsiimOe1pQ6krvkeLNL2D1hJRl+e0Q2i6FaSxH7uV
	0+L3NZvCdeYu9RUDYzQAd4FnVv4D260=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CNVvnxRq;
	spf=pass (imf18.hostedemail.com: domain of 3lYbeaAgKCGoRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3lYbeaAgKCGoRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759413911; a=rsa-sha256;
	cv=none;
	b=iKJsZbU6mdG+PIFxLq50oj5oGvhBWIaC0fRH/bB6HeQEbYzOCAueqIBj7E7H/KXbHREFos
	eV5MVJOVkWLho/i3N32gDhyZ4TvXJZSsurvqiFboagkqcjfqrYTe7teRIyOEcjKIC8rtWp
	kivlai8y9MNnv61QnmB+C1ciDZFn5IQ=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b3cd45a823cso103453766b.2
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 07:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759413909; x=1760018709; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bEqoonS/rPWcCApF7kzwVCksNrnIyl6aIHb9y9yvEE0=;
        b=CNVvnxRqRksZhN2Np16q7QKvarVEYHQwYx3WmK6XPvMcuMx8z9mAqtQynw1rW1+Sxq
         GM9SCLZoXZOej3OXQpeeuvJBHJcr9sV8pLUJ8ibVey1wPJmQIXizx75JBWz/W3n2rnNS
         FGu3daUNJ6fk0EQQh5rAset5uMHkbB55hw4uZ+7CIfQH24CD6hbFTwFzzwNdHegYzVrn
         WpC31HkZx3Dyilhc16YVjarPUjytX5Gup2YHCyua4MnpEfJHOrJZsuf9cNfNJ/qHuGS9
         ktS83wmLCuUDqrHdFCt8ENxgeEBPOlkefRFXe+9DGkQH/50GYUwCxpaDhC7VimPqj8H4
         d+nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759413909; x=1760018709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bEqoonS/rPWcCApF7kzwVCksNrnIyl6aIHb9y9yvEE0=;
        b=oidW3IWA0znRcWcS43KT9ILHA1p0NH+r3OI9cewyXPlpF3LRnL1iF9IoEr/cvBDXya
         LlLtGlpiKXhIc7YegIYj0534iu3RUIRyLXVO+b8Tsnu3GLho1gROG//L4gJ3iasrZ+2b
         AwgVcryXhDsROkbrSAhFIMatrriyTHaDF2l48btCpzycNkvcE3vqFm9qTq3ZPxSFZG+Q
         ubO7wZVMggXpwQscN0fGLZNxkemvHh3EQkAam4SLUN/2qQ/+KssuJRD36OpifFECdBms
         QTrRZUKji+WzjxDRbIKPDAOhf6axWfh/VeV5R52YmlaVNc5mWgsKT2cX7uM0ckJIOgxN
         k4Hw==
X-Forwarded-Encrypted: i=1; AJvYcCV0Sh7H5gGCglB0DPF+vF33hFsGdaYwCizhxAW3O4mIMumvnVwQnm3wac3MlVMXI3HgwuY+0Cemyg==@kvack.org
X-Gm-Message-State: AOJu0YzQKMHkjjwsFK6CyQvdQg4PQbny6C79Wp/6G9L6wsLbEeeTGatF
	oPa5krE0dJsOPxWCG016PzaEpscbdsGs/W6kavM5W/giAtj8AD4fSRZI24u+sDgw5gu9qJvRhgK
	Li/YaHxOp+KRPQA==
X-Google-Smtp-Source: AGHT+IFZaIaqkBKm5mBtTwxMyCC+T8dmRoB9gmf06e1kohCn27zyB8OOh5hVAnGNK78Fss7kY+bx//IvMfh2IA==
X-Received: from ejcsa14.prod.google.com ([2002:a17:907:6d0e:b0:b3c:76f3:6f73])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:948c:b0:b40:33ec:51ea with SMTP id a640c23a62f3a-b46e2436380mr865342866b.6.1759413909288;
 Thu, 02 Oct 2025 07:05:09 -0700 (PDT)
Date: Thu, 02 Oct 2025 14:05:08 +0000
In-Reply-To: <b0fb40f6-8baa-498f-bb88-50113cb80f53@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-4-2d861768041f@google.com> <b0fb40f6-8baa-498f-bb88-50113cb80f53@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD7W6FACMRPU.BXJCZU93UMVQ@google.com>
Subject: Re: [PATCH 04/21] x86/mm/asi: set up asi_nonsensitive_pgd
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: <peterz@infradead.org>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<mingo@redhat.com>, <tglx@linutronix.de>, <akpm@linux-foundation.org>, 
	<david@redhat.com>, <derkling@google.com>, <junaids@google.com>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <reijiw@google.com>, 
	<rientjes@google.com>, <rppt@kernel.org>, <vbabka@suse.cz>, <x86@kernel.org>, 
	<yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2E75A1C0016
X-Stat-Signature: wrjchas9ykh96kgutmtet5eawg8mj9x4
X-HE-Tag: 1759413910-298088
X-HE-Meta: U2FsdGVkX1+CprhhLZQSXHKL9eGcxNV2nFgOWRxTTbYdiu1EaTeHlnfsV8R6kFVZvP4iBvrrsswi7gKwRnwqCsDbFXgZu7ZGhhYhPZMf01EfhC5lSxJQESSgeORfcDtwYvOthgZYcvCppYkBCb7wTjzHURRea726qExZLCPVVPlUDn1kcSQJOVqY+6weyl8t1jqxFGXIVvXQA3Py6VGll1rqQYlQ8EpXQNM0MRqNAu6uTjHHO7/qGGqwjYMJuwSw8bTnIk0UpwDWTM0UX0RCoJQ0Ox6+F7Ynt4kL7fzBpZXNkIC+3f29Utg6Dtc2qoEZEpEtAL1a7diKBRI9NkR+/3gzk1IVC4g7VoVgiSxvu0vCjiTzIVHr4Az/7zOaRRyRNZEUNunHas8KIAcO02oTziHZj75P0+LHfmubgfprimOIPb6iR6GZiYNzZupH5hMGgnBONcaLogx8H6FasmaCcPcRH1A0Q/Jf6Ni48hKOO1uavWiPA/ynW3rqFzqIf1CL5Bpj9NE6G/LF1Ey1uwobj4642GNzkYwJ6cBldVY3MHUxtw+lfS+qnfWqt75knyE+2ZbkeNegYxDlQAoaZELu6HfN5KBXfHwenHZ3mkCDDWszWK2SfWw78hvePp5adcVxbzhNBrXEJlB3aZh/HUVU3b9iNs99y83G+NJSV/7w3g4kkpo83VAnCMr2tww+t9n89K9vVKNdDUtSbaWE9TU8O/FD44A/Vino7qHiQXVb0XcQxo90BZutak9JomjDzUGCkzcGwOHCxyD6dfJ4LOhQ8sSomNn0MX/hblkJbT0cLL1872llKWuN3KZnIlL82gx5vULgu+IRWgbyYVLKL+bMg5V/1lGl/T7/EW0IIRyK974yUammwXe2xKqrEIioA9AfWu628TRub2qLqvnZahnkyfnhb70qqpY7SPTD/FMbGArEa/ykYpZCGv/sdmNLOnwrxYKQsQ4b29c9EObWAFS
 q2aV/32P
 d0OXVQeYjkLxnssS11hgLPFuA6KeDZUgr9GcLOicK3Pl+9laY2QJvWMl4FbhCZuVnxpQTaCIfgMk7XxAa+XCnb0SVKmxT2/e5SisxljsW+vVK3Oh4zIG+juyVX3Zej55zqww/PAsxqPy5QAjISgp5r1F8Y840yxz0o16+OXPO2GssJzKMPEnof3p879gAWJyMaPjy8LJ8iVQ7VOrIaWwixlr+f+bQjSlcSIyawt9BZz8QygT/AntDdse2i6XXcA3apMD0IGera+CyU9rfyFLaaftW08EtXAtzvY1opfIw6zikQmluuv+6YHDYNlvV+Ozzf6k2cyXhyEs73ZVZ/GoV+rCYGXPPHWn7Tvp7RxAkDDMfrOk3q5BnEaJpFXjQtHepCH8EP7na82nO0ZueZQBLwsVUhYOb2FJj3HTR6F0frV++emtFfbUYz9Pm0ri+NVRvfmb3cNsFXawNXvraYueamk0F7+680/EPe/PlBpmvXipWRzJ3UUDg9cJWFFnyMROLvvQ7gsq7y9I7GTfYBBsry+ewVN0gBUGgPPNxjkRldlL0ahsxcOzTWn7WwzQZiM/iDYkyIwUCHArHjYRNH0B/9bZvW/d0tnleNGrVL8Pfuy58NAY+4hV+gfJ2TA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Oct 1, 2025 at 8:28 PM UTC, Dave Hansen wrote:
> On 9/24/25 07:59, Brendan Jackman wrote:
>> Create the initial shared pagetable to hold all the mappings that will
>> be shared among ASI domains.
>> 
>> Mirror the physmap into the ASI pagetables, but with a maximum
>> granularity that's guaranteed to allow changing pageblock sensitivity
>> without having to allocate pagetables, and with everything as
>> non-present.
>
> Could you also talk about what this granularity _actually_ is and why it
> has the property of never requiring page table alloc

Ack, will expand on this (I think from your other comments that you
understand it now, and you're just asking me to improve the commit
message, let me know if I misread that).

>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index e98e85cf15f42db669696ba8195d8fc633351b26..7e0471d46767c63ceade479ae0d1bf738f14904a 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -7,6 +7,7 @@
>>   *  Copyright (C) 2002,2003 Andi Kleen <ak@suse.de>
>>   */
>>  
>> +#include <linux/asi.h>
>>  #include <linux/signal.h>
>>  #include <linux/sched.h>
>>  #include <linux/kernel.h>
>> @@ -746,7 +747,8 @@ phys_pgd_init(pgd_t *pgd_page, unsigned long paddr_start, unsigned long paddr_en
>>  {
>>  	unsigned long vaddr, vaddr_start, vaddr_end, vaddr_next, paddr_last;
>>  
>> -	*pgd_changed = false;
>> +	if (pgd_changed)
>> +		*pgd_changed = false;
>
> This 'pgd_changed' hunk isn't mentioned in the changelog.

Oops, will add a note about that. The alternative would just be to
squash this into the commit that introduces phys_pgd_init(), let me know
if you have a preference.

>> @@ -797,6 +800,24 @@ __kernel_physical_mapping_init(unsigned long paddr_start,
>>  
>>  	paddr_last = phys_pgd_init(init_mm.pgd, paddr_start, paddr_end, page_size_mask,
>>  				   prot, init, &pgd_changed);
>> +
>> +	/*
>> +	 * Set up ASI's unrestricted physmap. This needs to mapped at minimum 2M
>> +	 * size so that regions can be mapped and unmapped at pageblock
>> +	 * granularity without requiring allocations.
>> +	 */
>
> This took me a minute to wrap my head around.
>
> Here, I think you're trying to convey that:
>
>   1. There's a higher-level design decision that all sensitivity will be
>      done at a 2M granularity. A 2MB physical region is either sensitive
>      or not.
>   2. Because of #1, 1GB mappings are not cool because splitting a 1GB
>      mapping into 2MB needs to allocate a page table page.
>   3. 4k mappings are OK because they can also have their permissions
>      changed at a 2MB granularity. It's just more laborious.
>
> The "minimum 2M size" comment really threw me off because that, to me,
> also includes 1G which is a no-no here.

Er yeah sorry that's just wrong, it should say "maximum size".

> I also can't help but wonder if it would have been easier and more
> straightforward to just start this whole exercise at 4k: force all the
> ASI tables to be 4k. Then, later, add the 2MB support and tie to
> pageblocks on after.

This would lead to a much smaller patchset, but I think it creates some
pretty yucky technical debt and complexity of its own. If you're
imagining a world where we just leave most of the allocator as-is, and
just inject "map into ASI" or "unmap from ASI" at the right moments...

I think to make this work you have to do one of:

- Say all free pages are unmapped from the restricted address space, we
  map them on-demand in allocation (if !__GFP_SENSITIVE), and unmap them
  again when they are freed. Because you can't flush the TLB
  synchronously in the free path, you need an async worker to take care
  of that for you.

  This is what we did in the Google implementation (where "don't change
  the page allocator more than you have to" kinda trumps everything) and
  it's pretty nasty. We have lots of knobs we can turn to try and make
  it perform well but in the end it's eventually gonna block deployment
  to some environment or other.

- Say free pages are mapped into the restricted address space. So if you
  get a __GFP_SENSITIVE alloc you unmap the pages and do the TLB flush
  synchronously there, unless we think the caller might be atomic, in
  which case.... I guess we'd have to have a sort of special atomic
  reserve for this? Which... seems like a weaker and more awkward
  version of the thing I'm proposing in this patchset.

  Then when you free the page you need to map it back again, which means
  you need to zero it.

I might have some tunnel-vision on this so please challenge me if it
sounds like I'm missing something.

>> +	if (asi_nonsensitive_pgd) {
>> +		/*
>> +		 * Since most memory is expected to end up sensitive, start with
>> +		 * everything unmapped in this pagetable.
>> +		 */
>> +		pgprot_t prot_np = __pgprot(pgprot_val(prot) & ~_PAGE_PRESENT);
>> +
>> +		VM_BUG_ON((PAGE_SHIFT + pageblock_order) < page_level_shift(PG_LEVEL_2M));
>> +		phys_pgd_init(asi_nonsensitive_pgd, paddr_start, paddr_end, 1 << PG_LEVEL_2M,
>> +			      prot_np, init, NULL);
>> +	}
>
> I'm also kinda wondering what the purpose is of having a whole page
> table full of !_PAGE_PRESENT entries. It would be nice to know how this
> eventually gets turned into something useful.

If you are thinking of the fact that just clearing P doesn't really do
anything for Meltdown/L1TF.. yeah that's true! We'll actually need to
munge the PFN or something too, but here I wanted do just focus on the
broad strokes of integration without worrying too much about individual
CPU mitigations. Flippping _PAGE_PRESENT is already supported by
set_memory.c and IIRC it's good enough for everything newer than
Skylake.

Other than that, these pages being unmapped is the whole point.. later
on, the subset of memory that we don't need to protect will get flipped
to being present. Everything else will trigger a pagefault if touched
and we'll switch address spaces, do the flushing etc.

Sorry if I'm missing your point here...


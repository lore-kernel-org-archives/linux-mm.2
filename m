Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 351FBCAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 17:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93BE78E0005; Thu,  2 Oct 2025 13:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9136D8E0001; Thu,  2 Oct 2025 13:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829468E0005; Thu,  2 Oct 2025 13:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E04F8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:19:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3202FBA39A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:19:58 +0000 (UTC)
X-FDA: 83953836876.21.C79904F
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 33450180009
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:19:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fquu9jZy;
	spf=pass (imf06.hostedemail.com: domain of 3OrTeaAgKCGsSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3OrTeaAgKCGsSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759425596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/f9RjnNhFPseqCNbW6l/omlX3YYRMtWpLdbNIAZycA=;
	b=g5n7CUY1fE+j9ZYsv6Wlts4pK2hSQ7Tpvune/aC1du8VlJmE5lFzThkBTL3XVvPxLOvqg8
	whoPseD0v2e1pO3m/nVH7iWVgyX3WA1prCM7Lxha56/ylL2Rzn2zVuJ7DzE7vP4/mqIJZb
	jhY/BErWCLSbsu/CJwh2jp35+Q3c8eU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Fquu9jZy;
	spf=pass (imf06.hostedemail.com: domain of 3OrTeaAgKCGsSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3OrTeaAgKCGsSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759425596; a=rsa-sha256;
	cv=none;
	b=h+/c+adZdDQxP+CQvpqL2w7Ecj4QJ1z7z+/JKPo5MlJrx1K8h3uGw/zeHdOGYp2Jcpu0gC
	fN3K7kMjg5a2mgSvD6rLOlHlbQiEvUsI2a0KV26D4nCawl18wBXEJAgEC0PCsss4FeUcGo
	TXr4qnqYy8FjKGJL0PuV3oxyJAy0u84=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ee888281c3so1050736f8f.3
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 10:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759425594; x=1760030394; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c/f9RjnNhFPseqCNbW6l/omlX3YYRMtWpLdbNIAZycA=;
        b=Fquu9jZyGiQ/VWn3rdluxBOtB5G4bEYyVt/p8ya5Kmx8pOpVDHmwNRinvBdH/70oil
         LVEyBQ58UOLIzlqRRHa4NS9azgzvO6zw7z9GIP96eNRQIdpdXdAgOwEQLCsV/evaPHgV
         gfp7/e5BUm5r3WwfpCIfU1fmRbPF4TO33id58q8WRdfbCCORElAuZEvjuUKKgrKmJXf9
         hBPpBryILr5uBY2AHYLMaWxRmqnCtIYAFXxON5MzcdsQh0uivn4rS6B1j+TXvaqyfUbr
         WW0FdY2S4Bzb/z5yXHWzfQkkdUOTPloZLEZ/GiVMzIdJxW5fB4l9whlpaRNQSpBbPKWy
         uY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759425594; x=1760030394;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c/f9RjnNhFPseqCNbW6l/omlX3YYRMtWpLdbNIAZycA=;
        b=BlJUFzLfvtHF82DNfGfaw2Zc9xipBLdoEhjr9d3GvvbezSE6n67nuURHOisQf1/A4A
         mCbfWorJqqaSCE5KrVLMtaFg5E1JutJPlvpJU9OJGcbqyhhbDbpfihrAvh9uwIRipTQY
         eGOpGUqOgo7fmiFC70gkma7EZvjgGB5jut3OVsEnRpqnjtRhOY2+uIOuqBo46IWRgZig
         PT7kVOg4ejmdNiVukcGsKO24s/aGlq2CViFi/sS+IDKM5nnfGWUDjG0Lkqxw6ABMRS4H
         s/hUNvC3BM2k0eGAPWdDVzQVv8cIC3HxuWLkjv7lmZKjFeFLI6bZuR97v94tg4eVU+bw
         4q/A==
X-Forwarded-Encrypted: i=1; AJvYcCWrKfzVbQn31naexD30N1yrNt293sYoSwbcWFdOVlTYVtWyRXN/G7diHBOie7rF5suJZ8FqgFA6Cg==@kvack.org
X-Gm-Message-State: AOJu0YylrWjaLwJAMbRAyu+Ci89I1s52WtOLYXSsZ7I/F+t32GOT0Zkj
	DuAgW/YmMEh+8wCio2ctxQf+d6KROuN/P5jUG68521qUNEnLQqkoAmkVPOUDzmbjWG/90i/3Ca/
	gsjplfJIfjDO8bw==
X-Google-Smtp-Source: AGHT+IGNJco/NMaeL5XlYH4pZ0xGoNdRmsQSt9z3k6S15d8LeR/Op1kMCUmxnZKhb7lNdaawLVzb8IJKvGEvSQ==
X-Received: from wmbz25.prod.google.com ([2002:a05:600c:c099:b0:46d:712:e422])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c0ce:b0:46e:59fe:a21b with SMTP id 5b1f17b1804b1-46e711043c2mr426345e9.4.1759425594691;
 Thu, 02 Oct 2025 10:19:54 -0700 (PDT)
Date: Thu, 02 Oct 2025 17:19:54 +0000
In-Reply-To: <9502454a-8065-4a65-9644-2b7fe0ec5f7f@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-4-2d861768041f@google.com> <b0fb40f6-8baa-498f-bb88-50113cb80f53@intel.com>
 <DD7W6FACMRPU.BXJCZU93UMVQ@google.com> <9502454a-8065-4a65-9644-2b7fe0ec5f7f@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD80BJMZM5EF.4V737FVJY4F3@google.com>
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
X-Rspamd-Queue-Id: 33450180009
X-Stat-Signature: 5tzbead3r6wgxri7tskgn57s9zr7saps
X-HE-Tag: 1759425595-750141
X-HE-Meta: U2FsdGVkX1/cNDptXh8oNm13J6bEHtYy0h09fZjQT+4dcj9Q/aln+ltabH3lwgniwGVdM6i0LM1pLeriNo2Hu+gnMhO7LL0u0jVo3dpPphlmuHYZx4GKAAwKCK+eExBw5rMmA9sSRmuadX8+B6pP5PrtQWKfZ7lS1MsXzRUbfA+K5+mt4wM9nsunWWntA0to1vYJCGR/t/s5eQV/NJomQ4lvYBW9uoZmQQGNJgQRAdfxBFH09Fjz2pu5sYEc29dXXKTWTTGFyp38BXRLPaqH+SdkQ2i8pUsPfg6NiRwx/Cb142ljWl+VvuwzD5Z0nYphfx8MZErrRBDiDf09yj3fkeS/kl2Nv/bdUUldkD1rOavpMpZ2thyQcoF/ggPloyZ8Jvllg+hir6iJM2TCXPLHf82lFkky7iZtDM4KrNqbQxfawlOpDbYpdRuXpk157uUQiC9sPZ2/WpfQZ/ig6knBPZoWDRurfM4NUSfdOgx5s6n8AR+TJeIUz5fXImfOpJWV1FNzla7sKpPiEbhRRnGIrll8ZuxGHXZRy5aCrLK/L9WwwQoKUdzHoTZKBe+jwZJCmvpfjy2GjXf5aAmiczCmbcUEUxkqIhg8KZsk2EEtZjWwkkN+kncGMYRndmbnSu3O8mnqPJc7zLW+nzlF6W5annbp/t5P2DKBgyDN1goAyYmNK5izyn+/rnm6G947H0cxF1hgsq2tM8kW5jGzNgom1KWVC22xZ0BIk03YytdvcHu2laaFZfQt+ckdWpeKvN5NwrLzbBInyc7Xl/QZwipbgj5bGhRDni8GmSk29sBUGQP+VaxLgAujIhztAP0gh8PtJ5rNsTGHuKyw0gvQBtRe/Z+i6/BdJt3d5RyKnVB3uXRjcuZi4Pt3xz2Eaes1qozdl9h9zTXtOQqP0F62tthZmI2oYv7r5S1ZEYom8Eg5v29h7zYSRR4UsY2fN2a+09waapdGMDcoMTrpHGu8bVj
 ck7Rz9aF
 7BOFf+GZVgO21dTpHix/+FnMV38mnOLDmqGg+w7pmYSd5GDV3xH0ATyERS9YlflMmtDvP7OY+OT3sYS3uG+NgHVNccIjDqg/4EcHecDqvuq8b5wjX5MPMa5Vt9dqYE1AI4Gvv7SZP0KMUXmaYwA0v7q6jITx/fdtqFSDepg6wYXo9p2VsCjl+z/cUx8uimzEmUa+Itwn66CTiwUF8kD+++ZeIw6Fu32/OfaQi/bPQM3fKoJ+K0Nz8cu+XV7qn2YwEXG6RfzLWCwhdl40j4pOcWeV3UCk798mxWMJuXGITt7cLMQjnWrC00ZA6M9mP/W6kFSDYOUwe002JL1S2Lo8YqMD7wR6HC3IISiANMRu9eFG/9P48Qkmvu5RBx1S7hEjHGBnXCzgpRL3xrcjzX+pXCZv/mn4Vf/kvIFV05d0UrNxBaS6WqlYo0vTevV3I3z4W45/1l40pHFnOvAdXqsWi3my59bzFBMafm11RsTUToIOtld2qSt8C/hoo6RzEJ3tOlb/mNIkgfWCiGs7jgUA2QX1jMhx3cApZLvgUaFyb2kPEGEUEdCaI6JNoOnQGf2Un4N8c6UbMdVzqfmA/5Tjhx1B1gPL+o9Gh5rB9Yy5LtRYNNdCIw328QWb87g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Oct 2, 2025 at 4:14 PM UTC, Dave Hansen wrote:
> On 10/2/25 07:05, Brendan Jackman wrote:
>> On Wed Oct 1, 2025 at 8:28 PM UTC, Dave Hansen wrote:
> ...>> I also can't help but wonder if it would have been easier and more
>>> straightforward to just start this whole exercise at 4k: force all the
>>> ASI tables to be 4k. Then, later, add the 2MB support and tie to
>>> pageblocks on after.
>> 
>> This would lead to a much smaller patchset, but I think it creates some
>> pretty yucky technical debt and complexity of its own. If you're
>> imagining a world where we just leave most of the allocator as-is, and
>> just inject "map into ASI" or "unmap from ASI" at the right moments...
> ...
>
> I'm trying to separate out the two problems:
>
>  1. Have a set of page tables that never require allocations in order to
>     map or unmap sensitive data.
>  2. Manage each pageblock as either all sensitive or all not sensitive
>
> There is a nonzero set of dependencies to make sure that the pageblock
> size is compatible with the page table mapping size... unless you just
> make the mapping size 4k.
>
> If the mapping size is 4k, the pageblock size can be anything. There's
> no dependency to satisfy.
>
> So I'm not saying to make the sensitive/nonsensitive boundary 4k. Just
> to make the _mapping_ size 4k. Then, come back later, and move the
> mapping size over to 2MB as an optimization.

Ahh thanks, I get your point now. And yep I'm sold, I'll go to 4k for
v2.

>>>> +	if (asi_nonsensitive_pgd) {
>>>> +		/*
>>>> +		 * Since most memory is expected to end up sensitive, start with
>>>> +		 * everything unmapped in this pagetable.
>>>> +		 */
>>>> +		pgprot_t prot_np = __pgprot(pgprot_val(prot) & ~_PAGE_PRESENT);
>>>> +
>>>> +		VM_BUG_ON((PAGE_SHIFT + pageblock_order) < page_level_shift(PG_LEVEL_2M));
>>>> +		phys_pgd_init(asi_nonsensitive_pgd, paddr_start, paddr_end, 1 << PG_LEVEL_2M,
>>>> +			      prot_np, init, NULL);
>>>> +	}
>>>
>>> I'm also kinda wondering what the purpose is of having a whole page
>>> table full of !_PAGE_PRESENT entries. It would be nice to know how this
>>> eventually gets turned into something useful.
>> 
>> If you are thinking of the fact that just clearing P doesn't really do
>> anything for Meltdown/L1TF.. yeah that's true! We'll actually need to
>> munge the PFN or something too, but here I wanted do just focus on the
>> broad strokes of integration without worrying too much about individual
>> CPU mitigations. Flippping _PAGE_PRESENT is already supported by
>> set_memory.c and IIRC it's good enough for everything newer than
>> Skylake.
>> 
>> Other than that, these pages being unmapped is the whole point.. later
>> on, the subset of memory that we don't need to protect will get flipped
>> to being present. Everything else will trigger a pagefault if touched
>> and we'll switch address spaces, do the flushing etc.
>> 
>> Sorry if I'm missing your point here...
>
> What is the point of having a pgd if you can't put it in CR3? If you:
>
> 	write_cr3(asi_nonsensitive_pgd);
>
> you'll just triple fault because all kernel text is !_PAGE_PRESENT.
>
> The critical point is when 'asi_nonsensitive_pgd' is functional enough
> that it can be loaded into CR3 and handle a switch to the normal
> init_mm->pgd.

Hm, are you saying that I should expand the scope of the patchset from
"set up the direct map" to "set up an ASI address space"? If so, yeah I
can do that, I don't think the patchset would get that much bigger. I
only left the other bits out because it feels weird to set up a whole
address space but never actually switch into it. Setting up the logic to
switch into it would make the patchset really big though.

Like I said in the cover letter, I could also always change tack:
we could instead start with all the address-space switching logic, but
just have the two address spaces be clones of each other. Then we could
come back and start poking holes in the ASI one for the second series. I
don't have a really strong opinion about the best place to start, but
I'll stick to my current course unless someone else does have a strong
opinion.


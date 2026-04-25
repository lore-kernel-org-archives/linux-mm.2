Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D487FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 06:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFEE6B0005; Sat, 25 Apr 2026 02:47:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070C86B008A; Sat, 25 Apr 2026 02:47:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2906B008C; Sat, 25 Apr 2026 02:47:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7CCD6B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 02:47:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 75E671C0242
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:47:25 +0000 (UTC)
X-FDA: 84696146850.12.A917C23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id AE22240011
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 06:47:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MIvRBM5m;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777099643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTnmvDOF+zipoH6c8bg7zu9UADgs5nUPMZTB3zeNDdc=;
	b=2jsE35hdw9kPEuNeZUFn0Q6VCqAV/TemtaVUAW5dN8WBU3YAWDawJ2X6FusQKA0mFYJSym
	Vg0r/Q8MV3DK6vvRXaqJJ1YNA4vgns3SueLxDomGU42nFKTFi2NuNrg61IX7WWyXPC1pbb
	aX/pyH2MuDmvdIWxDjHZD4DVbjLtot8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MIvRBM5m;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777099643; a=rsa-sha256;
	cv=none;
	b=FvLpBV5q2+XIBePSmAgpwcl00aGPsnAETE537MdGAHdVWod3Wb2/0VVV9RPiMw56Rqfk7e
	//YHLjgcyP0miR09WrDHNEjct4k096n/fDJebddYRKlvDgxBLOd+VpHCZnFX58HXGFwQUl
	7jwn+bEAF+LChrSipdA5r3jWVREzrl0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9768A60052;
	Sat, 25 Apr 2026 06:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A28C2BCB0;
	Sat, 25 Apr 2026 06:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777099642;
	bh=Qdw6w3wNTsj1mPRlJXca8cl67BuW4C+HLS7hqpixnCk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MIvRBM5mIMO4duMrxyQfXbhFAhzQnVJLFSQ8HzKDddIcbQYD6zxitNjepTmYL02Ly
	 +mkYuMdUD70e/qzuzxhJFCNveB+fL8/kWIo9qTSlAZzEs5MswVqPqe4xX3COd7YjlP
	 CqnEAVW/jsygw6regCWVQU7mqxQy7sl9qnG59FRkR71PecB9RF1N0iuVSKsIdTk+GH
	 EKz6gFV/y3WGwrgbBVK8KWG79TZqeqWx1Png+77ryElIHvU7INDxR2hMSOiNy4uS71
	 qDTjfvASyJcz0l5y/9zucevkKSb+YdsxNziBEV7VYdRtXsMX5G9QF9xjxwQwPI3Xvz
	 GfyvrJB1amKCg==
Message-ID: <2e664019-f161-44d9-a3fa-74c4d8290345@kernel.org>
Date: Sat, 25 Apr 2026 08:47:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/7] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Liam R Howlett <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <02e35414-8c30-4753-9403-432d90263f39@kernel.org>
 <17902B08-7487-4FC8-8EBC-268CE5F3E1B9@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <17902B08-7487-4FC8-8EBC-268CE5F3E1B9@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE22240011
X-Stat-Signature: 787angmwycf8sfecu8dc9taaaeh6c479
X-HE-Tag: 1777099643-723480
X-HE-Meta: U2FsdGVkX18HtIM8rxiL1S6uTmrI/Cz5rjpqrf0jBPuBfOfLrOZkBFX8SO2DqRy1mfmiWeP59qGcgZTB5MiyLq9PBmb3gSu+X40OI+VRp2l6vHWrsF3GVj1QP4PKR1qmLky5aDgchRKCaN7DeiyGDRtzATCoDwDzHDu0VA9YlpFQS0qba1OSRSpD0FHJJOfuYlQpmMaoONlHPsK9WNVUIYoY0yb6BJKiakbZSL02B4j5ugzkU0H7kazk150s0ff6lMmqH/7N2rAUdZ3bOf9ZW623lgQQE0KgiFvjxhXiLJ1/QmS8M9nQVlCpKR1InYj99KI6fUGUc+YO0iirw3EN5YPn6TFWaXe2ezdPYVx3zg/rpjoIecdNEnkr0j+R8TNKG1P/KVFiebGRtTD0z+wyKJpcXP6ZThMDEJeEzTgWThvghyN9ALhdMMcioipv/kYh0VmF1bxJ91TXdDaY7NNrhExKs6x64XZS/dnNiX5dFb0k/LcOLJAjFcQMTd76oY5X0xtrUQWxog/HdtVGGKzrGWt9kCrR5VME5RCDIhjFPtOaV1/wRaNjU3+tFF679OGE8OxWJ4rLp4/MBiUjQG5lVTq+gadeI2skD/HZAeR3MjF34hOHSqpZf8wdWOKUBNYT8n0+v7RGQF8oAKljoRV14y10VH1bc4ZbirwL1d+VFMURqK3P0rL1NkvblBtdH8v0mqO9gh5ZdZDTApsKPriKJMLmQsm5iu/Aj0hPHe9IxAH9R4gADnsnI8/Gqn4RQGeD8yXDSP8i39uHvCpVteXFsQ3rMM+cb02TpyQsvOriANkysB2pRS0ck1zsO93RpaoqLsic8wxbJFEAYjQ1Ig5mwaDUvjLrR8aEHdDyibl+onTaNmEWbLapNpsAI5PpXkAYbZOJEpD4wW6FHrPEOABbD5EQZu/FhCPTucqodZ5ldIa6Fx/zqQRbxl19G1d+52Uboh2VZyO+RwtdtrBYZjo
 tqhwuBS1
 HxYgwsg8Jbh2VWjyjD4XJ0F+PRRJKnpEAGsI91fBVsmCTmCWgfDC7e7dh2hdWNlrJ8Qw8YeJPOhyBT06egJYz0RPpG40v7WHth1OpGvMgWGkRfZ0sgOVgg8glq9Bz3/wJH/gPRV/QZIOLH+AUJI2ez1SXUEX6n08NbJKy6nDS7lp9Wyn6tB4t6PcOov/98qklXrfr8bM9EPG71c+PkgoQhYhnTEOyZfrs/WV3zQZzIC6kxBHhmfw5IcFjiT22VriDgSkTPw0rvjiI0/98GVFwUr3CBEQ/yYhPMnD3lPvdM7hZwjm5WxkT8gXWcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/25/26 08:20, Muchun Song wrote:
> 
> 
>> On Apr 25, 2026, at 13:48, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> ﻿
>>>
>>>
>>> Hi David,
>>>
>>> Sorry, I missed the 1GB hugepage scenario earlier. Given that sparse_add_section()
>>> operates on a scale between PAGES_PER_SUBSECTION and PAGES_PER_SECTION, the pfn and
>>> nr_pages parameters wouldn't be aligned with the hugepage size (pages_per_compound),
>>> but rather with the PAGES_PER_SECTION boundary. Do you think this explanation makes
>>> it clearer? In the interest of code clarity, do you think the modification below
>>> makes it easier to follow?
>>>
>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>> index 2e642c5ff3f2..ce675c5fb94d 100644
>>> --- a/mm/sparse-vmemmap.c
>>> +++ b/mm/sparse-vmemmap.c
>>> @@ -658,15 +658,18 @@ static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long n
>>>        const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
>>>        const unsigned long pages_per_compound = 1UL << order;
>>>
>>> -       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages,
>>> -                                   min(pages_per_compound, PAGES_PER_SECTION)));
>>> +       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
>>
>> That here makes sense. We can only add/remove in multiples of PAGES_PER_SECTION.
>> I think what we are saying is that we want that check in addition to the
>> existing min() check.
> 
> Right.
> 
>>
>>>        VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
>>>
>>>        if (!vmemmap_can_optimize(altmap, pgmap))
>>>                return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
>>>
>>> -       if (order < PFN_SECTION_SHIFT)
>>> +       if (order < PFN_SECTION_SHIFT) {
>>> +               VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
>>>                return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
>>
>> That makes sense as well, within a section, we expect that we always add/remove
>> entire "compound"-managed chunks.
>>
>>> +       }
>>> +
>>> +       VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
>>
>> And this is then for the case where a 1G page spans multiple sections, where we
>> expect to add/remove an entire section.
>>
>> So here, indeed the "min" makes sense. I guess we also assume:
>>
>>    VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
> 
> Yes. But this one we do not need to explicit it to
> assert it since at the front of this function we have
> 
> VM_WARN_ON_ONCE(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));

Ah, yes. The alignment checks + VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
however imply that.

So you could simplify by using that check instead of the pfn_to_section_nr() check.

But it's still early here ... so whatever you prefer :)

-- 
Cheers,

David


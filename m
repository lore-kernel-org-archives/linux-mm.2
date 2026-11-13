Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D91606A88E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MlJaG+26
Received: by kanga.kvack.org (Postfix)
	id 7AEA56B00EF; Fri, 13 Nov 2026 15:16:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E2E6B05B2; Fri, 13 Nov 2026 15:16:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683956B05B4; Fri, 13 Nov 2026 15:16:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17AB06B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:16:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5FC5A1602AA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:16:43 +0000 (UTC)
X-FDA: 85431203886.08.BEF4DCD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 891C94000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:16:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MlJaG+26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794601001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKkv9aRrifNAGJc7MyvqqHZiCveTQdE+78aZDKlRtY0=;
	b=KEKgPzeflndvfChq8pY3YEqoZOz4t5M2qWgxavMDy0z8lnj42e8q5B4rRnOWuJHt9w2d3V
	AU4nmKEbtdQXwEuK/Fk+UrgOXWVeXoMOAgxamiIK9z0L6lcanoNlZTS/NIXtWOMm2NGyVS
	eAXzxJ+hcmHU0oouXAYr4K7U8+q4VMM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MlJaG+26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794601001;
	b=WcbxEYnBWWUKfY5bg/LsKv6bbVsB324eZdfqYFvEY1vmQdTioKzLfF+plfF92kqqMprJiX
	bfZPbrw97m/jSNkdA8Q1nyfDXLU6axRRkMHw3URxuXgcgVD5Ph2/SUsSNW+BPFexk4xQH4
	pleUkWGqQbT+lxp79fmmnCq9G6Njijk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E8E6436E8;
	Fri, 13 Nov 2026 20:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9021F000C6;
	Fri, 13 Nov 2026 20:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794601000;
	bh=XKkv9aRrifNAGJc7MyvqqHZiCveTQdE+78aZDKlRtY0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MlJaG+26pUn/pdo1RaZ9nEujevXFvGBMFdUcVls6aQJjSIjiWHUQuEp5CD3UR/yr2
	 Skup1V3gUNFG3v6+1obY1FN1BkZfbo0+tzLJ6Y/exf2o+80pB+GDyGvRTT7iPLuMMh
	 eTjQGaZe588wJGyiWu/I56o1vYlSBLJD0ZrhINkL7KbdrVuCs0smZfYVzeO+bN6KKK
	 TiBEsjzZGAsx2D1wULksACe+AbAJjWNYgpVzB25nzbRGCFQKhlNqem9AibWGfzTQ5Z
	 Ic6KqIRnYbD4DgZTlSGYLFXX8C6V2RCHAbWXBT1f8zfXd5cRJrUQsJks/Qb3Oy6fO+
	 emQKqpNvt3Tyw==
Message-ID: <3744f956-8179-45f3-9d87-c99c82b2f8db@kernel.org>
Date: Fri, 13 Nov 2026 21:16:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm/huge_memory: find partially mapped shared
 folios with NO_PAGE_MAPCOUNT
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Joanne Koong <joannelkoong@gmail.com>
References: <20261111113535.330078-1-azpijr@gmail.com>
 <4411389c-2246-4af6-9b34-10d3f259aeb4@kernel.org>
 <e9033159-ffd5-4c84-b355-964687b75226@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <e9033159-ffd5-4c84-b355-964687b75226@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 891C94000A
X-Stat-Signature: wia4pz1moserp33wfm1fj9dtgdd86mfe
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794601001-90764
X-HE-Meta: U2FsdGVkX19jcOxtlg8Dbcsunr19Q8y7Y4/5J7t3JzNAZNhmfnSVcj0FTUl1tmiW237NegZxREWM1J5lNQrlS1umMSr795T/G/KuedmWHTT+zcrTJtsrHOv93J/KeEUCf3C+lahHFMWuYyJZtXc+VloUUEJG50DNE+71BcDvSgTn2qKxto9xl721b4NgVaawwFaieEL5V/g7F9TXYUvjn3iPA6Qfj1RC2uAnnc+Jl/i8XLjPCJFNG60Ha1lt+SH2J6x4nyUDbHgrXYU+WBYx0cDy5G90R3qaRxw4sBBYWiVygQqK1yonkG4eqn2bMBHIyqArq69yqhxgEllXCdzTU6OaGtlm/cYRIGTtQh0/I1PPDAXFBgaDe26AqEktiUAquK+fZo7AxExVH6Be7nyzX/7YBu+hywU2dXA8HypHedEVH4szJA9g0yfrJqatgAbWP8ZWslRTNtX0VNYac4/3bZ2utFW7tmaPkUu8aACsSsGM/x0fmMrmt4mMSIWdlgYpRMqRNFxRRQ9DV5pKdIjFghOZTSkBCjklIxqcmCv9POIW5dcR+WcSyHyEcQyXbjMnd1t2icM5IdoC6vWa51Tc3DHaHRewGObNuZnGGREbOsMBaewX/1Rz6ZeBicJJ5v/JiF5ZyGUKUvQF1K3BTtITfXhO2Smwx6HhxHXuf8UJv58CY1zZEzde76obXRI/9dcByRlqBPFqXOy01DqPcDoHr9QDb/0aw4ov17SaWg7iPmcbvy17EWxcv/gWesFb5pT+TRQheW/EK63LpUznVSOZrR59wtvMHeB4mvz39panqECSQTzw7KqgwMd3c3yJuAytFoYmG11q8omk+upccwsYV/Ba3Bg26xyUZTk8s4G/gz+VTCXAnPWhbfX9xSEybivDWZV2TnCnMkL+4zuri9oipaM5sTz2JZtyPXixCpSYzGts+1VnFL1unBJbxIMqB/1UevBJuBQUHefBvJyichf
 x43s4BgD
 J/r4aS9SM0sicQRbMdQr/kokGxe1u8AJGR7fI1j373o2uj2i5rJgJxt+ROUWa1AfHDbCXBqeSWzi8DfcqR7wUA+AGYT5NC0GcHnm2S2FIE3umzKDxR6j0zPI/NfrPAUT2gEvK6kcs0UxqRHTLb5ppS/SVrW117THZ7jzykcrRc4gvTqlIFPDBIG+Sl8hm4PCfiaw5dpMvFj2qkeQYToPXWLa6HFvvTs+ORzxWB3fcZCjI4JBTmatKPBzCMdlcV7k0qY4yMA3RU8LZU6AzrqLaw/O62fh8DH9ykse03g/p7ZJuNtOID5xlmMOe+ApnzwqFNE0Iymt7bXR8BwB0U3iqTf7wZkoRof+MYpi2UtZ1kEwolYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 14:03, Jose A. Perez de Azpillaga wrote:
> On 11/12/26 1:46 PM, David Hildenbrand (Arm) wrote:
>> On 11/11/26 12:31, Jose A. Perez de Azpillaga wrote:
>>> With CONFIG_NO_PAGE_MAPCOUNT, an anon large folio mapped by several MMs
>>> isn't seen as partially mapped while its mapcount stays at or above the
>>> number of pages. If parent and child zap the same half of a THP after
>>> fork(), that half is mapped by nobody, the folio is never queued for
>>> deferred split, and the memory stays allocated until every mapper is
>>> gone.
>>
>> If you follow the history on this, in e.g., some raised in my talk
>>
>> https://share.daveh.de/s/bQsDpD7xigJ6wD8/download?path=&files=LSF_MM%2726_+Deferred_folio_splitting.pdf
>>
>> There are a lot of questions around this.
>>
>> In particular
>>
>> (a) Is it really relevant in practice. The only way you can trigger this if a
>> folio becomes partially mapped *after* fork (by parent and child unmapping the
>> same pages), and the child stays alive. Once the child is gone, the folio is
>> only mapped by one process (e.g., child quit), the folio is properly detected as
>> partially mapped.
> 
> I don't have any relevant evidence in practice. found it by just reading
> and testing in qemu. that is why I sent it as RFC.

Ok. Because I would really be interested in real-life scenarios where it is a
problem.

It's only relevant for long-running parent+child combinations. For short-lived
children (e.g., fork+exec) it's irrelevant.

> 
>>
>> So you need a long-running parent+child, and have them both do questionable things.
>>
>> (b) What is the overhead from having way too many folios in the deferred split list.
>>
> 
> I don't know yet. I only measured the walk in a TCG guest, nothing on
> how long the list gets

That would be really interesting. I assume there are some cases where a simple
fork+exec would already add pages to the deferred split list even thought they
are briefly after fully mapped by the parent.

> 
>>>
>>> Patch 1 moves the split_underused_thp check out of
>>> deferred_split_folio(). Patch 2 queues such folios as candidates and has
>>> the shrinker walk the rmap to see which pages are still mapped.
>>>
>>> 512 MB of THPs with the same half zapped by every mapper, memory freed
>>> by the shrinker:
>>>
>>>                                 before    after
>>>   2M,  2 processes                0 MB   252 MB
>>>   2M,  3 processes                0 MB   237 MB
>>>   2M,  2 children + parent PMD    0 MB   244 MB
>>>   64K, 2 processes                0 MB   252 MB
>>>   64K, 3 processes                0 MB   252 MB
>>>
>>
>> Again, we can create nice scenarios that are likely not relevant in practice
>> (such as 512 MB THPs, lol), but so far I doubted that this is relevant in practice.
> 
> that's 512 MB in total, not the folio size. maybe I should have
> clarified it.

Ah, 512MiB of THPs, not 512MB THP, Yes, that makes sense.

[...]

>>
>> Maybe one could track it a bit broader? "any page in this set of 16 pages is
>> present". Reclaiming a single 4k page from a 2M folios is barely worth it.
>>
> 
> yes, that works. maybe with the group size scaled to the folio, so the
> map is one long on the stack and 64K folio still gets one bit per page?
> 

As an alternative, could we also just look for the next page incrementally?

Like, start with offset 0. When we see that, move to offset 1, when we see that,
move to offset 2 ... and once we saw all pages that way, stop the walk.

I'd assume that, as long as VMAs don't get remapped, that should likely work in
most cases, right?

> however, maybe if I don't have real evidence, better drop it?

I'd be very interested in an efficient way to test if a folio is partially
mapped, and where the holes are.

Knowing about the holes could guide a targeted buddy-like folio split.

There was also the idea of letting folio_referenced() for that purpose, when we
area already doing an rmap walk.

-- 
Cheers,

David


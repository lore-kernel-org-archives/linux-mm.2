Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 204DFD32D99
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591226B00AB; Fri,  5 Dec 2025 16:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568A96B00AD; Fri,  5 Dec 2025 16:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A57B6B00AE; Fri,  5 Dec 2025 16:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4686B00AB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:35:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0D9688316
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:34:59 +0000 (UTC)
X-FDA: 84186722718.19.550798A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1818FC0004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:34:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gh8ajqRA;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764970498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZ22Y+HvgVG7y/fRMxlUcTppE5xJHccjbNmRWDH4csc=;
	b=Y7GS/ND/HsP4p7PwisRLgXkrsiXHg65HMTK54Ib0dGjcJQKMDbD5uPCo4p3oAtZDTlEVkM
	8jAkoNOHbPkIpHhDmdTzWDw+q+0GD4gixNBQUsf7JU2XHgMv80FCxfr4JGprg++ymc0Iur
	bjFNNWcqT83GrKzrHaK9d8dvSV+NffU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764970498; a=rsa-sha256;
	cv=none;
	b=krfHdk7YIvIZ6HZxrHrqbfLzOlwpfeMmIO7tQA3HwYmO1u2+PjCvvEwFaM5ew89E3wfa4f
	AqV5LrEX89eZCLPQUogIu0M1dX4w6Dm83/SO49R2X2NkCSejzlmpWo15ownGp6xh3vUBUP
	JQ9dg2KdIC4UdUW6LgJUWZCtKUyXIXU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gh8ajqRA;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70FD360156;
	Fri,  5 Dec 2025 21:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8AEC4CEF1;
	Fri,  5 Dec 2025 21:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764970497;
	bh=pIWFu1CpvEX7ARO6h8yJ5dcbxsEBwILGEiRBs91Q2JU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Gh8ajqRAdx3KnvpVzycs8kZ9NxVSF8yjDJuVXe53wnCjS5LnpIVL4+aNqaWp288YU
	 3w0PoKfc1wCSHDVk2USqz1GQ63BPL+4hGYC0lMXJCmyUe3nYS/QCa+mC/Aaj9+n+4U
	 HTuA6pi7Bown/zCHdd/J3ZDu9FdIms8EeWa+ADYhQGMS4ttS/+EVpklKpMBf54v6rD
	 pcOvrW2sLm2HOhYl5uLML5TvP5QNZR4jouoaz8cKPQByQ+JSHmscjNsZ2+iMNoMcRK
	 tG0vltG31lDKB8ZRsNGy24xJbpSlfjc0ejInjaE2Pbxff++sAEke6sszaQsK5Fzx+5
	 Fb/VLbA5rUxNw==
Message-ID: <1b659d59-b1c1-4910-baab-0eef7cda234f@kernel.org>
Date: Fri, 5 Dec 2025 22:34:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <e1c50f7e-cec4-4676-b5d6-f6446cd64ba5@kernel.org>
 <bdie34dgpltxd5ayvjvqkusx4thdrrebgllvwp333psfuu4vgj@bkfxg2c5sfr2>
 <01e5d0b3-dbf8-4f77-b38a-f48c46f7c31e@kernel.org>
 <ysvhofzg5mdtvxfujdsmffkuqna72pr52ehrpglmlhxnvwstas@xurgptkgtnbe>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <ysvhofzg5mdtvxfujdsmffkuqna72pr52ehrpglmlhxnvwstas@xurgptkgtnbe>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1818FC0004
X-Stat-Signature: igk89xrd6qqtcrfjdjr38xczkqgg51um
X-Rspam-User: 
X-HE-Tag: 1764970497-674656
X-HE-Meta: U2FsdGVkX1+aBRhpRQp9ivUsL3WVxkxM24fkVxyQUDklOVLI56D/ea558RFaPow5f29yphR3byvHZV3w3mv9dsWYUfWFBYefwTQ5y5f8dduMyI8aIfxB+SAsc2b+PrZrJ5rBT4a3rD+pdlABzIParxPAg/jMo58qkhhi3NMXxOrZOD+yHz1S+Ecu4cNNh9HxTA9m80+g9ZGjiPkB5pAterSpIllVQ2NTXw4Lqfyi7XMjR+JZbIuQiPKvqOxAevTlbsNnD5NsyWtHsUBfykLYmKzA6JEXxz24tYNlvjR1pvwVycKfF8Ck0EkVW5Ee0i8XHs6uzEcYWlVk4A/wwQwQERGjBurPWBXX34YYIF/jPGU+pnKY8oBRgyEMiAmsM1cLVlGmSyK4/YGfbaz9Y4MOP2Taf3Qp9SKxtLahlXMVM2kRWwHp5EYM9P8qUYY/soMk7mMuwvO6YI2qgC56ep5E0nBpQWFOkjuEI3IOvmp+jylP9a63zhioWILYFCvYjiplI2HNGGt27hukVF5ndZV1/5MDk4xpLxBLw/FbbrbNAbAZt7m4P9NCovi0MS7Le8s+naAM8V3DtYZ6F56GLp46t4WXNv+nrWO4mNF1M73ljRqbab0AAP0dHN2g5tGfJlVvV5zKqWrlBx0i/XMnQbDJ+6QV9zh5/lsPKfwEAG1RSTS9lz5QGG0ZTPG4cna2X9CMIWZ8oAnbqrKmlKTCo6V0fcTAxuIYFmUKJqy42lo16pm0hVIYAofP9cG9y2zMs9fuLe2hCepMzN+9pWtI2xdNoY7qxkN8TOfBtn/YY/G6tAQmUzik9aJW9zE8AEZ+jtzGCnrsCY40gl7ovjvbvMPWxv63bdlphyv6pnt9RadRvLNJ3gwGG3n3qt6eiVsaIcV80qUszblN9AkiZsl2gI8si62spaXdQJv287LXYg4ElKon2j/nuMZXd6OSbPEsRxj4wDP0R9o9cv/dVHyaomC
 v23IoGAu
 S8UmmKcgK+u4LEsRy6BfRfT7ADEuIWO3K45RRthBr+NqKnG9gXrq//sGpzD9ljNN3axI1ZaisaeRY/WFZJO53JyeP9VySvIlivQEOjpMk3rqnM4oPPAlTQcscOFwBRG7bOAcNDA2LF1JNH4Ai34Qz9rWJ5FLRXEx1ZiMB/Cyd+Ov8krm9DFb2idLxBOuKwZD8B3y/1aLT5AMh7Z8HpraOddNqOnL45eP5a93kZ7c8vBWTfqEaSJJPnfQCYATLPPxwEPzK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/5/25 21:54, Kiryl Shutsemau wrote:
> On Fri, Dec 05, 2025 at 09:44:30PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/5/25 21:33, Kiryl Shutsemau wrote:
>>> On Fri, Dec 05, 2025 at 09:16:08PM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 12/5/25 20:43, Kiryl Shutsemau wrote:
>>>>> This series removes "fake head pages" from the HugeTLB vmemmap
>>>>> optimization (HVO) by changing how tail pages encode their relationship
>>>>> to the head page.
>>>>>
>>>>> It simplifies compound_head() and page_ref_add_unless(). Both are in the
>>>>> hot path.
>>>>>
>>>>> Background
>>>>> ==========
>>>>>
>>>>> HVO reduces memory overhead by freeing vmemmap pages for HugeTLB pages
>>>>> and remapping the freed virtual addresses to a single physical page.
>>>>> Previously, all tail page vmemmap entries were remapped to the first
>>>>> vmemmap page (containing the head struct page), creating "fake heads" -
>>>>> tail pages that appear to have PG_head set when accessed through the
>>>>> deduplicated vmemmap.
>>>>>
>>>>> This required special handling in compound_head() to detect and work
>>>>> around fake heads, adding complexity and overhead to a very hot path.
>>>>>
>>>>> New Approach
>>>>> ============
>>>>>
>>>>> For architectures/configs where sizeof(struct page) is a power of 2 (the
>>>>> common case), this series changes how position of the head page is encoded
>>>>> in the tail pages.
>>>>>
>>>>> Instead of storing a pointer to the head page, the ->compound_info
>>>>> (renamed from ->compound_head) now stores a mask.
>>>>
>>>> (we're in the merge window)
>>>>
>>>> That doesn't seem to be suitable for the memdesc plans, where we want all
>>>> tail pages do directly point at the allocated memdesc (e.g., struct folio),
>>>> no?
>>>
>>> Sure. My understanding is that it is going to eliminate a need in
>>> compound_head() completely. I don't see the conflict so far.
>>
>> Right. All compound_head pointers will point at the allocated memdesc.
>>
>> Would we still have to detect fake head pages though (at least for some
>> transition period)?
> 
> If we need to detect if the memdesc is tail it should be as trivial as
> comparing the given memdesc to the memdesc - 1. If they match, you are
> looking at the tail.

How could you assume memdesc - 1 exists without performing other checks?

> 
> But I don't think we wound need it.

I would guess so.

> 
> The memdesc itself doesn't hold anything you want to touch if don't hold
> reference to the folio. You wound need dereference memdesc and after it
> you don't care if the memdesc it tail.

Hopefully.

So the real question is how this would affect the transition period 
(some memdescs allocated, others not allocated separately) that Willy 
might soon want to start. And the dual mode where, whether "struct 
folio" is allocated separately will be a config option.

Let's wait for Willy's reply.

-- 
Cheers

David


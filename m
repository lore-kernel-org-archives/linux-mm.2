Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104E41098792
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7865C6B0155; Fri, 20 Mar 2026 10:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736E96B0158; Fri, 20 Mar 2026 10:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6261B6B0159; Fri, 20 Mar 2026 10:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE466B0155
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:33:55 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F21C61A0229
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:33:54 +0000 (UTC)
X-FDA: 84566685588.15.466EB7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4EC1B40013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:33:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m040ISdA;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774017233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2F3LmFYgz/IO1qdw8D5sw1nCML0e7Tg4mGt3tYCtNas=;
	b=F4kQn8k+XJ1X5DXxjkGf2H6rCn390EEC3P8TsqspQQWD6unYMnhb+w45otwADtiDqpaQdl
	oAOCiGCdZVAlYLpJ36MJaq7dKSQZ+Um+Gk8P3f4M4nZI/einkNoNOu2egMVuvPWNrTZgjH
	dftYDsls2L520qd5t3rq4yP09Hq+49E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m040ISdA;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774017233; a=rsa-sha256;
	cv=none;
	b=VeTN3IxgD57LJ7SHCfFPVk2+j8pL0rTJORJ1lkkHa7RNowjef2hRHAEYmv9Y1dv3ZgJ5nw
	P0E0lt+GOohpxJ037nzmlzC1pyjRGeSXRBGUzDYlYse42Y0tnTzS6mYKwz2kW6VRyISmTw
	TrziAiEqfU97N4lcoS2OlsICt/Xdq3Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 966DE61865;
	Fri, 20 Mar 2026 14:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BC8C4CEF7;
	Fri, 20 Mar 2026 14:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774017232;
	bh=woNciVcFPVPKMQT5S/73G3cJUwtRkApIxOo1qnPR/fA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=m040ISdArhiK15Wt+g2CXOlAvu3bmHrRHpsjRNyEr+5iQN0VHvwWEumgevnywYjgK
	 7RWgfS9f7qIpRldtep2k0MvPI0QGqwKqCkowgyPujUSov0ZTUfaNdgWzIENX/xaDfl
	 7KwtQ6jZ/xdWEyJiuF0eTiDqfIjbOAFNn46yoa/BTGzlgCGZrV/+ZgYsk39dWsQjPN
	 FVFgBH4utS0kC2+I0NUEdiK2vL204Cde0ej3BOxGLMSKBAewmL8+8P4xEz3Pjq2opg
	 e9UWBA1ff3zHWLPMxoUWuPcHIvLstFIWFd76R/3VL243g31wdj13Plvlj75qRli5Jk
	 7cC+vmQ/cIGEA==
Message-ID: <38379a16-d596-4266-ac3b-1dbee5356add@kernel.org>
Date: Fri, 20 Mar 2026 15:33:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] vmalloc: Optimize vfree
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-3-usama.anjum@arm.com>
 <e59ab258-7331-412c-b490-657e32ec1fe0@kernel.org>
 <b7959d34-6e7d-45c2-a674-f32afd057068@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <b7959d34-6e7d-45c2-a674-f32afd057068@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4EC1B40013
X-Rspamd-Server: rspam08
X-Stat-Signature: t88stq3kqhhbqniuj4ta4kpdm9n74q9x
X-HE-Tag: 1774017233-161227
X-HE-Meta: U2FsdGVkX183YXrIJA2pfR/vdbJb5TP9XCh2JmnfQO+VncmPhv4irNB8Heg/upcrmwjL4zntWD3poNgcMQg4ygkOqLRdlXeHV0aEqSxV8E+E9haCvyLmAt/2Gutd9ShXtbrvazBPGVKU+kuBfSjOY+zumpZpqjqRNz+bCN8Ux954v7JFGLJenlN6VsacSgeSjpGC2JvuSQ0h23qweiPQi+yTnk92Fx0TkB3klxwet3bbFmG6hEfWf7OCPidE6mZrN8dOZRDdgL+gtO470nhawd8MkWYU76ZYHU0nJwnPhrKdkrnmM0gqGiASTbq9FmC9MQyLlbG0NdOk/32yUtI474mG4pW6xhC21ZHvAlLABqF+SAldSEMV3gyezLmIC1G4M2Z8gDvAsq0orUL/uhJxY4DnMUFt3Ci+mK28Tih7Sq2f+aE2L46FKjs9S5IhU8JzYPjJnRgoGutrmcd6TveRTK3DZJXK+5NArtnDrMlEVJ0P94YFGTdKLA3DREN+Erkwxyj75+SWiP3jg9RTgdJPc9KGwLAEgFBReC/G4grUFTzkWvSUBPTzfRyn2XqHA9yDV7CzyEAPI4syrbL/uCsrBmUQ3rKPL1fAXghwdu+MZgdOMxRXqkqg/SOnAZAs4v2F6KtcuwVqj0g0axxNamvFbLRm7ulPXsDG4ouVsh4HAviG1fzpRuOWCYZdjhrCASGHLjDJw2n/MWsDjpNHoLcQCXLi8Hohp9gU5ATsj0HYt1yoMz0uAmxYcApKw5ZZd//n+ZwwnNJKE9G7kplUsARwW4ljKFsdZoEVeTqo2HhftNS+NP8Swf6T4xQnnkW1meB+TFV0EOYWht2EhXoteWsnWub4BfPgk4RPOsT/LV75uU8Kw1r3e9/3J845kDmXsuZPflXm96D7Z7KCO6FctjUMGpuCecWUgqwEI2r4H5sK9jEw7pGgsnYGtZM22GIR8Gnbx+fbrTktG5QRoAqJLwY
 atphIAeG
 jgHFcaDLktx3ixLPS8lMJwNBLJOdhVb1nqek3YDyszMn1XYIcmVbjpivBRYHFdehmwcMe88KY3E2WC9zShgHhN4Rvcfqmox6FokZ23R5b3lHb4qib5Lr0zyQEvyK//MTG1YLTF1aMU1zS7Q3lhHiw92H8yi67+05i7vAdnmOvnQ2KBYKNiSYP0S2zpm5cyDUt+Hd25pj6VxPJQAw8+aWGamv0FznSo4cCHJZLc+N9uIi51/DkqP7Q5TSd+o6FzmVp7rFq8L9x6E/QQXn31UipqXU7O3iLtJAW6Sx0oakChWZLX2vr15i2la3KBqVRDXoDTWpELo3RZ5HevA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 09:39, David Hildenbrand (Arm) wrote:
> On 3/16/26 16:49, Vlastimil Babka wrote:
>>>  mm/vmalloc.c | 34 +++++++++++++++++++++++++---------
>>>  1 file changed, 25 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index c607307c657a6..8b935395fb068 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -3459,18 +3459,34 @@ void vfree(const void *addr)
>>>  
>>>  	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
>>>  		vm_reset_perms(vm);
>>> -	for (i = 0; i < vm->nr_pages; i++) {
>>> -		struct page *page = vm->pages[i];
>>> +
>>> +	if (vm->nr_pages) {
>>> +		bool account = !(vm->flags & VM_MAP_PUT_PAGES);
>>> +		unsigned long start_pfn, pfn;
>>> +		struct page *page = vm->pages[0];
>>> +		int nr = 1;
>>>  
>>>  		BUG_ON(!page);
>>> -		/*
>>> -		 * High-order allocs for huge vmallocs are split, so
>>> -		 * can be freed as an array of order-0 allocations
>>> -		 */
>>> -		if (!(vm->flags & VM_MAP_PUT_PAGES))
>>> +		start_pfn = page_to_pfn(page);
>>> +		if (account)
>>>  			mod_lruvec_page_state(page, NR_VMALLOC, -1);
>>> -		__free_page(page);
>>> -		cond_resched();
>>> +
>>> +		for (i = 1; i < vm->nr_pages; i++) {
>>> +			page = vm->pages[i];
>>> +			BUG_ON(!page);
>> 
>> We shouldn't be adding BUG_ON()'s. Rather demote also the pre-existing one
>> to VM_WARN_ON_ONCE() and skip gracefully.
>> 
>>> +			if (account)
>>> +				mod_lruvec_page_state(page, NR_VMALLOC, -1);
>> 
>> I think we should be able to batch this too to use "nr"?
> 
> Are we sure that pages cannot cross nodes etc? It could happen that we
> have a contig range that spans zones/nodes/etc ...

Hmm single order-3 allocation can't but we could be unlucky and get the last
order-3 from zone X and first order-3 from adjacent zone Y.
In that case the loop would need to also check same zone/node.

> Anyhow, should we try to decouple both things, providing a
> core-mm function to do the page freeing?
> 
> We do have something similar, optimized unpinning of large folios,
> in unpin_user_pages_dirty_lock(). This here is a bit different.
> 
> 
> So what I am thinking about for this code here to do:
> 
> 	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
> 		for (i = 0; i < vm->nr_pages; i++)
> 			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
> 	}
> 	free_pages_bulk(vm->pages, vm->nr_pages);
> 
> 
> We could optimize the first loop to do batching where possible as well.
> 
> 
> free_pages_bulk() would match alloc_pages_bulk()
> 
> 	void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
> 
> Internally we'd do the contig handling.
> 
> Was that already discussed?

AFAIU some of Zi's replies hinted at this direction. It would make sense, yeah.



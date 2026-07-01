Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B81E9C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 18:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A164A6B00A9; Wed,  1 Jul 2026 14:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EDEB6B00AB; Wed,  1 Jul 2026 14:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE776B00AC; Wed,  1 Jul 2026 14:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9266B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:14:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2A431C7401
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:14:11 +0000 (UTC)
X-FDA: 84941007102.28.BFD23D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E34E240007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:14:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0A4txTL;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782929650;
	b=szPfMaQZJ0qz5MPyqQGxecj6mv1dWs8U/WxJeNZlQ2acE5Cy+wNPWY06R9MaoXRBy6PXDw
	urqSSQz/S2e5Lf0JU1fDdAtRZ8LG3EQpVWKaGCc2w3jHYRV06iY+ggw3sqO3TuFUYZvaBa
	4NSDiAJczGXMLqX1SdJIp01jzJL0XbU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782929650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PD5z0B3KLuf6QAzSmxugLBPawi7CkWU61EppSSVzf20=;
	b=k52qh4DJBVQWTMl6AaMLccQI7JUtzpFwWxlJe1SIAD/uMACqFiemIGszrUve7hoWKj1YE6
	eMJ+Ua161A3DniNZP3Q0sT7ar0uwXuHulhBvJo1vHVpLQA0GytI/J4o06QHLa0keB3qgIl
	b7U+isrCd0uxm8peNPs91bRA5KTKB3U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0A4txTL;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D736D432AF;
	Wed,  1 Jul 2026 18:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747CD1F000E9;
	Wed,  1 Jul 2026 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782929648;
	bh=PD5z0B3KLuf6QAzSmxugLBPawi7CkWU61EppSSVzf20=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=o0A4txTLWUptFpeU/Mi/BSpuDwvTNfldwpIE0TgrDcVds8g2WEZSvOpqN79Bj6sM7
	 MiLa10CAFyo5XQs5YFP7qj3yEr993E93vOH5j9XG1oDhdpvtskD3+WpW4PdOthV405
	 c6Nh+LhhVwMCiX2nr6J9mSNQapr+We1913hqbqEzLJyEFJ+PO42yv62MPP4gXIqAkI
	 kRugLLa+JS8uo00oe6fQ2C44xoUkkaczdGmkM44VrdfqpNK9KpG1Ukue27iFZvRNIp
	 SjuqYpm3ozd+EpwkuPwC1wG9/tlGQAHHszpp7PSJhafVckY+ppJdfafOnESkohjRpQ
	 09eQC530kPvpw==
Message-ID: <c00f2d42-83f7-4417-aaf8-aed0bf1e28db@kernel.org>
Date: Wed, 1 Jul 2026 20:14:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: compaction: support non-movable compaction for
 pageblock requests
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-3-hannes@cmpxchg.org>
 <e36dad58-d259-4533-be08-50d667d5144e@kernel.org>
 <akUyEgKMryy6TntY@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <akUyEgKMryy6TntY@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E34E240007
X-Stat-Signature: qem37osc11odcrh6peuk73hd99wazcyu
X-HE-Tag: 1782929649-967533
X-HE-Meta: U2FsdGVkX1+CAfGX4Ddo7XDtgl9wrbxosHK08hm8ULpMttvZ1drc6aYRDW1FneczoZtrNxdkfTS4vsi9ODaPBsLdAVdLvbSo/jdSIk88cu4afWTrfeADH9MBVHNtwmbN1vdEldV6pyAiuWRYp3Sax4A6HaBb03GKAoqFzIAKS0QrQXOiGFapVilqNqc3Lt6Wgjo7dI/IHAPjtksuFZZM46K+QqjGXGZ4dqL7cG/iPTHpnx0upujE5yY8n+z9x4PS5jC9nrs+qGbxqENb5CuSP5FL5bmQMeaOVe2aNWyZOLcMb+me4e+svpZNr03vgIf0+0WKcZjvw9OYBqeGUprHuyld1m0/YRp/J5CntTPQWOyUHwiWCdfI/suOa5+j2LNLxxEdwKvMtV3Y0veZuQDrXP0R25/3uG05Ty2EqxOztpN2fL+4/qmGr6SPp9OPVBWk9ErMhb7mdwQzrCtnps2kkmng8dd1iKs32eg5vHxOYTJy6yC1DIbjGD124wGGLuzJKNjmLa6n0iQRaFvXajAeXDdeXIpYTld2ib9e18d1RMPQxW45ZqG592bwuWMM3UWxP7jeSgWzKMISQ9lkItj5ibcJ+H+VNJzzylbfYvc8zjhu8u8AZ8C1UQyYU6z/N8CKDtahwkxpWIpS3kNKpXGh8tzwUqLf/RjCSFcajuO0Mzrrm9OXf6YCMvafTcGn2b8Kt0+WD1ijXjbN04VZ9dXIl6XId+uDimj1OLgR4MfwCIFZv+OF5YvqaE4TTxCUvwZ09pU4TZnoVaM8gBhVm17zS5ies7+VBmLGpEjBLfvx3bYXBPpP+L5t6HFZnaK9nZps0l2ckgSriHvPJVqTDvEjrtJxt9WfYubB4ll/TwdjawHEF93NxC0wSsabe/KTM6KkYSsgX/LC9LB9lP8roN40ZDxLFONdsocySe8mdkS2n/rhI1HmMPdsom8NmhHcNjOl1E2y6N41dKuIVGLgQ/C
 ut2X0d8z
 Z56UH/yiNougy7R+e1TqKuG+zAwLxHUE9QjeiHZwU3aCh51R+6moAoWgJQ3q9SXPl+PzEuzAEXXPYIZQ7e5wZIJ4Ub/4JiMad3JNbdAbELRAwZ9xoxbdWgfvW0y10fZxUzI+2whVdP0opkbn+eXBbXGsjev/mSq+MQXm/m4Si2soTHP+xJS/s/e186Ex3XuxxAf/RI/iikfEC+kFf4mGbzDjduT1NnL7I8by1+oNKHz3tp3GjvjPomcnnWmM1OAXbhbh0xqJoNGq3gkgwgYIYjrcNt/A3SPT1rUAtg5wZA3+J3j8DiFaK/lwAHhiZduFtIjEtDJfK+LdKYlAeHADRgpxvNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 17:28, Johannes Weiner wrote:
> On Wed, Jul 01, 2026 at 04:19:29PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 6/26/26 20:21, Johannes Weiner wrote:
>> > While trying to fix a reclaim storm in defrag_mode, I noticed that
>> > non-movable direct compaction is extremely inefficient.
>> > 
>> > When searching for space to evacuate, compaction only allows blocks of
>> > the same type as the incoming request. This is to prevent migratetype
>> > pollution, where a small non-movable request frees space in a movable
>> > block and provokes the allocator to fall back and pollute it.
>> > 
>> > This protection is reasonable on one hand, but the downside is that it
>> > makes non-movable direct compaction nearly useless: if we get the type
>> > annotations right, by definition there aren't any movable pages inside
>> > the non-movable blocks it is allowed to scan.
>> > 
>> > With defrag_mode, the goal is the production of whole blocks, which
>> > are essentially type neutral: __rmqueue_claim() will convert them
>> > wholesale on alloc. This makes type mixing and pollution a non-issue.
>> > 
>> > Fix the pollution gates to take the requested order into account, and
>> > allow whole-block requests to scan blocks of other types.
>> > 
>> > The only exception is CMA blocks. That type is sticky and these blocks
>> > cannot be claimed to other types. Continue to be strict with them, and
>> > allow only explicit ALLOC_CMA requests and kcompactd to evacuate them.
>> > 
>> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>> 
>> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Thanks!
> 
>> > diff --git a/mm/compaction.c b/mm/compaction.c
>> > index f08765ade014..7df3a85d43af 100644
>> > --- a/mm/compaction.c
>> > +++ b/mm/compaction.c
>> > @@ -1381,12 +1381,33 @@ static bool suitable_migration_source(struct compact_control *cc,
>> >  	if (pageblock_skip_persistent(page))
>> >  		return false;
>> >  
>> > -	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
>> > +	/*
>> > +	 * Background compaction produces blocks for the zone at
>> > +	 * large, with no particular allocation context. Allow all
>> > +	 * block types, including CMA.
>> > +	 */
>> > +	if (!cc->direct_compaction)
>> >  		return true;
>> >  
>> >  	block_mt = get_pageblock_migratetype(page);
>> >  
>> > -	if (cc->migratetype == MIGRATE_MOVABLE)
>> > +	/*
>> > +	 * CMA pages can only be taken by ALLOC_CMA requests. For anybody
>> > +	 * else, vacating a CMA block consumes free pages the caller
>> > +	 * could have used, and produces free pages it cannot.
>> > +	 */
>> > +	if (is_migrate_cma(block_mt) && !(cc->alloc_flags & ALLOC_CMA))
>> > +		return false;
>> > +
>> > +	if (cc->mode != MIGRATE_ASYNC)
>> > +		return true;
>> 
>> This now stands out as uncommented. Can we come up with a rationale? :)
> 
> Let's see. Originally it came from here:
> 
> commit 9927af740b1b9b1e769310bd0b91425e8047b803
> Author: Mel Gorman <mel@csn.ul.ie>
> Date:   Thu Jan 13 15:45:59 2011 -0800
> 
>     mm: compaction: perform a faster migration scan when migrating asynchronously
> 
> This limited async scanners to movable blocks. By keeping them to the
> most productive space, it keeps their latencies down.
> 
> But then there was a follow up here:
> 
> commit 282722b0d258ec23fc79d80165418fee83f01736
> Author: Vlastimil Babka <vbabka@kernel.org>
> Date:   Mon May 8 15:54:49 2017 -0700
> 
>     mm, compaction: restrict async compaction to pageblocks of same migratetype

Aha :)

> This made the migratetype filtering about preventing block
> pollution. The patch quotes reduced extfrag numbers.
> 
> So now we have a block pollution guard that we apply only if... the
> scanner is latency sensitive? :) Is this actually desired behavior?

Yeah indeed I was wondering in this direction.

> Another way of looking at it would be this:
> 
> 	/*
> 	 * Allocation fallbacks can spread migratable pages
> 	 * into non-movable blocks.

But also vice versa, non-movable pages into movable blocks? (without
defrag_mode?).

>  This is high-effort,
> 	 * low-result work. Restrict it to sync scans.
> 	 */

Works for me.



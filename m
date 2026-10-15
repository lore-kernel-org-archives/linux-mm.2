Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C40CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 19:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3876B008C; Thu, 15 Oct 2026 15:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 184996B0092; Thu, 15 Oct 2026 15:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073866B0095; Thu, 15 Oct 2026 15:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFDA06B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:27:56 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56EF94015F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:27:55 +0000 (UTC)
X-FDA: 85325845710.13.92F3F22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF94840007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:27:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BfWMtmm2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792092473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTUQn3LMk0w+yeTdUpwCQsIY+GVhDkIh+sgZRNspeMg=;
	b=sgyeaTnywrP7JJvbqWhxYodX+q5z9vHB0ux+lUnh2GAiBTBzMQe8dj3ooNDgi08YWpiVsG
	seQ7271/lA/5ToAc3n9KD7HXiFR0O+pIvXVOjAVbmKW4EhE704CqEEfmzXcgMQ3BZfp/LT
	cC/8iKDnJ2YXQOD0zsr4h2J+DtV0JwU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BfWMtmm2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792092473;
	b=XJ1j1xKwhfo0eAm8kjxuMhZK46F6LOX4ZTvp4pG3VK/Nkpm9WF+OxkFq+r6KTNLZE22CXj
	t0IfFRMgSBOqaPImZhdmM+8+bB1ufjpUGCEoHL8augd4zPrU+nzPl1RXWxjuZj5Byn6yJP
	Hfs1TsyXoVWZ3uwauizcGIvxOhFvcIs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4393E601F1;
	Thu, 15 Oct 2026 19:27:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38471F000C4;
	Thu, 15 Oct 2026 19:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792092473;
	bh=aTUQn3LMk0w+yeTdUpwCQsIY+GVhDkIh+sgZRNspeMg=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=BfWMtmm20yej46/YB4w/DGRwaPN+XM7OPRbg/ih4WLX+Z6SmQltw9AhB4OqcPLlZN
	 liXQTmMzMK3HxH6cKn/tFWlknlXMgiPBzmnrb2ezp3exxyTiRd75vEY2YHnxfklsIN
	 fmfrPR7vTBWgQ9ppLGILa+ve3rn+wyEktN+GeAMEfq88BzKlhXiCN8+tfcmIAAMEe7
	 6fiq0GjALPpZ/5+sgSczSsDnxxLtysNGK/DJoI9uK4IH+V/NWeJVWFOn4DcMzghNKV
	 6a6rLV8miiOyX1WfwNP6IDt9AgmXfCaMYiUjo6sOvczpv1T5JrGpON8Wxeg2LMZ87a
	 xmkaOEKa4ME0A==
Date: Thu, 15 Oct 2026 21:26:47 +0200 (CEST)
From: Imre Kaloz <kaloz@kernel.org>
To: Andreas Larsson <andreas@gaisler.com>
cc: "David S. Miller" <davem@davemloft.net>, 
    "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
    "Mike Rapoport (IBM)" <rppt@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, sparclinux@vger.kernel.org, 
    linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] sparc64: flush only the aliased page, not its
 whole folio
In-Reply-To: <61ab29d3-929f-49de-bb64-5a49318ede00@gaisler.com>
Message-ID: <c74a2d45-2267-b380-c7fe-b6a2d3f8251b@kernel.org>
References: <20260928132102.1707-1-kaloz@kernel.org> <20260928132102.1707-2-kaloz@kernel.org> <61ab29d3-929f-49de-bb64-5a49318ede00@gaisler.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-2075810683-1792092412=:25347"
X-Stat-Signature: jhu3yeho4fkbike3cxmck31ba4a7akp8
X-Rspam-User: 
X-Rspamd-Queue-Id: BF94840007
X-Rspamd-Server: rspam08
X-HE-Tag: 1792092473-354794
X-HE-Meta: U2FsdGVkX18G2YESu0PNY+pwmL3YoDEQBCe3Ddrfk4qOfBdLRIOjwFNs/Rg7SVSzFZZcDhT3xOUNTlN0Cerq5SeY4OkZWPRYUQoio5E8zKAV6oL43wHwJFtoylnEH4uO+dbaBpiaE1Ec7KoiWfQ+FlxVdkD7Pvn/VBBopTPSi1W7qLCCmBxpJxEjZLl0BkAoT3HiTBr+Wc5rB82FTJOqXt+dBgA9Asr9Jkb9aVJbDMPsdUBDfEk/ixphTJW1/X1qf9ze0yoL4Eyr++QhAsD7p9ykscy0xNBB3v9SDa6vVTHP/CJkQifeKnDb9UeQcaI+lPc0lC2OASpatVYNH0W0OQ8Gzi+FUZL6ogUmYezzW7x4z4a7ifZ9Enh7nM/KwAd5t7aTIIEZ+El3IAdWKHJlZJCQ4uePOKsMZEZF8GB2RzADDs668mOSv6+C41pLeVm5DwmUjQow47sP4wnhKSf+bfHcXETfj8d6aeCr7xnKwCg4TFElcDEp9mPc876ldUpyOuKOqCdzdpJlzXF6dZZ5Rljt/xs5PCzc68yVuD0xeutHJd8R1QFohlEPEKNFdWzDUYR0H3gc3xgYDghm+bHcQE+nA4RkQZ7ADj95iCQCGr4gM6fAvLqztxfm/5t1xM6XaXyN894rflTo6EArS6fBvq5PazhBLq5JDI/zCrUBW95Jo3hh3AElwrjuN7EtvqRiv04ACtwho0TqPw0lqt7eJ+N3VbAN1vZFpSo2GcJWXrzfBzj/WVTPOSTqbQcLBC1gGggP8z8uJhuOxRqka31B0lYBXZNY4VypR6Vulm+s5V9QT9/LeVlLmy7YTCun6atukyEx33mJiJFc788gPaMOHJffIFYmeslmv+cKDX1mfNicM3XLVFjud4Pl3hZDUCIeG0WI7B2impVEFuNIhj8+c1MoSooXNskfCizlKvOAyUx0PUeKNER0kzgnkIF/WwPRLDnrr5qRaDp8+S32cUk
 ZmPuc0/g
 w6boVK0A7kKhm8iSFTdkggv5VKmb3y5zPUVFTYtP/AtgdzELr91o8C6KAi3UUsn2XiKI0ghvdQKnshp7COHnrte3qE3Sj8tfNxpQtYPhuNouL93so/nOVHTeDa3j6xNx7zwNL2nTkuP0SGCyk63WzXtNY2n190Ftf0HZnWZgJwB/lvTTyD3jrhEqV4LokrV3+TnXPKGwaLYft9nwZD7MyDBUVNiBC9HTrLNtxPpj3FkLviDrHQvoDbmJV/+AsfgrHlBUG0Cjlu6yrJedwXJPx+AA3CL5ScJzUtm6aimg4jg9K2L4cBOcCwl6QMQapVwU9o9reoWeIW4SdWTKjHNV1VFRIhSx0L1sH965C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2075810683-1792092412=:25347
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hi Andreas,

On Thu, 15 Oct 2026, Andreas Larsson wrote:

> On 2026-09-28 15:21, Imre Kaloz wrote:
>> Since the conversion to folios, move_pte() and tlb_batch_add() flush the
>> D-cache of every page in the folio a single PTE maps.  Both run once per
>> PTE, so moving or unmapping a range backed by a large folio flushes each
>> of its pages once for every PTE of that folio, and each page flush is a
>> cross-call to all other online CPUs.
>
> It would be good if the description of what the patch does uses present
> tense, but past tense for what was wrong before the patch, or was
> otherwise reworded to make it clear.

Will do.

> The cross-call overhead is not true for all sparc64 machines and only
> for SMP configurations.

Right, it's only on SMP and only on sun4u CPUs whose D-cache can alias;
on sun4v flush_dcache_folio_all() returns right away. I'll say so.

>> Only the page the PTE maps can hold lines at the old colour, so flush
>> just that page, as before the conversion.  flush_dcache_folio_all() has
>> no other users and becomes flush_dcache_page_all() again.
>
> This could perhaps be a bit misleading, as multiple PTEs in the range
> handled by the caller can hold the old colour, could it not? Rather it
> is the traversing of the whole range one by one in the caller that does
> the trick. What do you aim to add to the previous description with this
> paragraph?

You're right. What I wanted to say is that flushing the page each PTE
maps is enough because the caller walks the range one PTE at a time, so
every page gets its own flush. I'll reword it that way.

>> On SMP QEMU guests, apt rebuilding its caches through mremap() triggers
>> RCU stalls and soft lockups in move_pte().
>
> Past tense or rewording here as well as this patch fixes this.

Will do.

<snip>

>> diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
>> index 0837ebbc5dce..6712eac4baf1 100644
>> --- a/arch/sparc/include/asm/pgtable_64.h
>> +++ b/arch/sparc/include/asm/pgtable_64.h
>> @@ -946,6 +946,9 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
>>  	set_pte_at((mm), (addr), (ptep), __pte(0UL))
>>
>>  #ifdef DCACHE_ALIASING_POSSIBLE
>> +/* Without pte_batch_hint(), move_ptes() calls this once per PTE, so
>> + * only the page this PTE maps can have lines at the old colour.
>> + */
>
> I'm not ecstatic about implementing a function that in the general API
> can be called for multiple ptes, even though this never happens on
> sparc64 as things stands right now. The code paths that saves us, from
> commit 0b5be138ce00 ("mm/mremap: avoid expensive folio lookup on mremap
> folio pte batch"), was "only" added as a performance regression fix.
>
> Perhaps the best logical solution would be if move_pte() got an added nr
> argument just as get_and_clear_ptes() has.
>
> Barring that, the comment should not describe why the change is ok, but
> rather descrive the code as it stands after this patch, that it depends
> on only being called for single pte's, and that this is accomplished by
> using the default pte_batch_hint().
>
> I would prefer the nr argument though, but that would go outside
> arch/sparc. Comments from mm people on this would be great.
>

I'll rewrite the comment that way.

I like the nr idea. Since sparc64 is the only user of move_pte(), it
would be a small change: move_ptes() would pass nr_ptes, the generic
version would ignore it, and sparc64 would flush every aliased page in
the batch. I’d still keep it as a separate patch on top of this one,
though, so the fix can go to stable as a plain sparc64 backport.

Matthew, Mike, Andrew, would you be fine with move_pte() taking nr?


Thanks,
Imre
--8323329-2075810683-1792092412=:25347--


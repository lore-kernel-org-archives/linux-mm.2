Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F368BC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:38:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04F896B009E; Mon,  7 Sep 2026 09:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027C46B009F; Mon,  7 Sep 2026 09:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5AD56B00A0; Mon,  7 Sep 2026 09:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B54F26B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:38:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39C90140111
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:38:29 +0000 (UTC)
X-FDA: 85187070738.22.2CCE413
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4650220002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:38:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIhGnb09;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788788307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXPx7jZphY5xscJdBWYKC7jM8mTT70+S+YQbgVrwjUo=;
	b=yEo3uhI3GVKo2UjF06Tlwqn/tjNYxrn12mbb2v0PE83ruMp0DiX0qNJeSZkJ2mo9QreL2y
	rRfJzTPfgy1rn6FJoSPgZ1wL1qnKK5HwbLHJGAzx0GFaDOlYhQ4cgQdH8txe2arvGljnce
	XUvXrz2DJgeKu1sHhQeAR92+/I+VDMI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788788307;
	b=DLOB7GyCfdbvXLHoVZs2JV00kkzf4MxoH02LvC0qxyk0NmC4q3bGHxIc68O42uTlNZhIgt
	uw+47JmZQrP4WjbURqvkkZ0JkJYVUoAB74W7Xt/BUCJdx45wYkNv7YKc0BYRhKu81Iwhtq
	KJGfFC5VDfk08xggPMrJ4kRHOFQ75W4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIhGnb09;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AB5E414D3;
	Mon,  7 Sep 2026 13:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FDA1F00A3A;
	Mon,  7 Sep 2026 13:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788788306;
	bh=NXPx7jZphY5xscJdBWYKC7jM8mTT70+S+YQbgVrwjUo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eIhGnb091U2uURjovnjh38jpYJErL03yA/HrTFhuT85aqKHGa6GXC+EKQ3/1KU+Gx
	 NfkiOxg2HbvLPgCVvyrpCb9jCnSy0OWCDPvafTfQuOhV0CcnCYPNDQSbxX7NUj4mcV
	 DW46WMStXI+74xxObP8fsymvDcr+WnNLd+N/DCHvuYLnqv2O4GSL8oxF47HfGPy9+1
	 gHkyLUv4Ku+0TX26Afgd+2SP9/LmVOVzEpZlBeVh94HcImH7Or54zqBTJEMwfnV0bn
	 t5G8bLK0LFoan3X46Nes6TIer84z86LCj85MI9LxcriQaSaHSJLCuku2s/2Ez/3ihr
	 hUousIHrZ6fgQ==
Message-ID: <8d73f087-42e2-454c-8e5f-93c1b64cb969@kernel.org>
Date: Mon, 7 Sep 2026 15:38:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] mm/slub: introduce slab parking to reduce
 list_lock contention
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, harry@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Pedro Falcato <pfalcato@suse.de>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
 <20260824122513.3829-2-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <20260824122513.3829-2-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hsjfxxxp1ubwfkseomxfwkqpksx8a34j
X-Rspamd-Queue-Id: 4650220002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788788307-335126
X-HE-Meta: U2FsdGVkX18oW1HrD4OuS+7hvvfuXN/EbhNH+KJmqNt2usvoUSnFvufsrpEhvpkezPvlviAsVY2n4IiYN63QH/nej4L3rYjbTPzJxYHqQvjnf8Ff58/YQAciBeKxcCOiMzwZZ1XGfK56xNgVc9TzUzQ7ZqgX4+1iC39rrQ8ePJY0N1hsfYrJZGqNb5elic+6f5h3ojB+12cfhg6c9edfPQFN1Q3tdBryuOuIiJLPXOC59TCbcneqjsDjrRDfwIAEvLm6chqH/ETwiRKU3Xukmefb1Xnd+239zHjHfIYWglbry/SGIPo2XRsDfSG8gq1yWeIhEXPhTxFGBuu5uEEVTEioTfY19QQTXpgt2JgJVW0Og3QSn4oWBgqEX++cUra31eBSQawsFfcRHcd4mOquKWEoS4XBXWvedqTHvE1MIQUdGUWM3fCjWbe4bwLjhsPpkJm0vQY36Gvz7XIs7u0jZ6PjsdR45H4GdAKJDdcq97308qZ0zVYDAfpSJ51fJjOAGwQ0TEz47PP+pCRwyiPzmDDxFetLclyImLEE9MlWPIQEG+4mU0s/jTE6mrhIXEhQ0maJexQWQUmcrIA3hBEd4NcTX1TZaeydsSmw3urG49kr9MMrHjeruiV3x4YvCi9KNCv6frKojfv6p6GkTxLIGf4RpV2TEKNGMENGR9t3x7sQsdRl6gr9F1OzwwUKeSJTd8ZjSquZHJMNWihCabXA06heCF0Z0bJ2yoO8rJXsfbvXg6/rbRFC01927hpguQaEpemodKIYK9OFMsM8X42rA03tqw3OjTbRYHKEuZ+zaZOMZN4O8sXQynRH1t/pvorte4H2RztnIgB2SYCRD6XB2MHRhu/EhUS5fmJIHNQJSRCg+kBOEexoQktdwWzOne6o0caFfK2Odo8HVENL49EiKaJFiCtjbrJZS36ANfIP9E6hVOv8a426ZdL4nldmOC8BZ1l3lj9hAQGp8An3nop
 yPl0X2Ok
 7EFDWO0rFeStgvHrP1mhRBeEb0PH/H+hNd7aNtaAoeIyBS4buOv05hhIgGbczE1zFQ0Z07Q/QKphQGHbFBAcroJbCQm8PXJDKnlVTWQ9orjzbabqw08FY6J+7kj7sVXRd2t8Z9qR9XUiIOw76eXd6uHUC8OFbxDp6/kFHZKOiMXdSfXa8fCQi/Bxli+tPMRK4GDuJk9AXnIf3dYSASbcDuswc2eOWazLYGGXDrT8bstdS6FZGSevOlmK+lb7olQ+j+qvpSueZKpFQ+AgSsovM/qQDex+YOXVrRGHCfhsrFf8OFBfybEiepdlr3X+XxoqpNQGcFzRKQWsv2kA5Dw764zajCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/24/26 14:25, Hao Li wrote:
> Introduce a mechanism called parking to mitigate lock contention in the
> free slowpath.

Interesting!

> In the free slowpath, when __slab_free() transitions a full slab into a
> partial/empty slab through a free operation, it must acquire the list
> lock to add these newly freed partial/empty slabs to the partial list.
> 
> Why must partial and empty slabs converted from full slabs be added to
> the partial list? Because only by doing so can the sheaf refill or alloc
> slowpath see these partial slabs and allocate from them. Therefore, the
> list insertion must be performed, which requires acquiring the lock and
> leads to heavy lock contention under high concurrency.
> 
> Analysis of profiling data from the will-it-scale mmap1 benchmark shows
> that full -> partial transitions account for a large proportion, second
> only to partial -> partial.
> 
> With extra instrumentation added to __slab_free(), the following data
> was collected for the maple_node cache (in counts):
> 
>   partial->partial    843017414
>   full->partial       550719384
>   partial->empty      17459564
>   full->empty         2

That's a lot inded. I'd be careful if it's some specific aspect of the test,
i.e. lots of parallel allocations followed by lots of frees, that wouldn't
be that common in realistic workloads. But worth looking into at least.
If it's this kind of pathologic behavior, then I expect changing sheaf size
as suggested by Pedro wouldn't help much.

> Since the fundamental purpose of __slab_free() is to make newly freed
> partial/empty slabs visible to the sheaf refill or alloc slowpath, these
> slabs can be temporarily stored in a staging area in a lockless manner
> instead of making the free slowpath contend for the lock. The sheaf

However the lockless manipulation is still going to contend on the
llist_head. But perhaps it's limited enough in both users and lenght of
operations to make a difference.

> refill or alloc slowpath then checks this staging area first when
> allocating objects. This achieves the goal of making these slabs visible
> to the sheaf refill or alloc slowpath while allowing the free slowpath
> to operate locklessly. This process is called "parking".

I'm gonna pull a David Hildenbrand trick here and question the name :)
It seems to me it's an (extension of the) partial list, but lockless.
Parking would suggest to me that it's put somewhere aside not to be used, or
something.

> Parking occurs in only one case: when __slab_free() encounters a full ->
> partial/empty transition and the trylock fails. In this case,
> __slab_free() attaches the slab to an llist locklessly, instead of
> waiting for the lock unnecessarily.

It could be interesting to also see if skipping the trylock completely
(another cache contending operation) helps even more. Also whether moving
the llist_node to a different cache line than list_lock (and fields
protected by it) helps even more, or not.

> Conversely, the process of moving these parked slabs from the llist back
> to the partial list is called "unpark". Unpark occurs in four cases:
> 
> 1. Sheaf refill or alloc slowpath: This is the core case. The sheaf
>    refill or alloc slowpath must see the parked slabs, so the first
>    thing done after acquiring the lock in the sheaf refill or alloc
>    slowpath is unpark.
> 2. Cache shrinking: shrinking also needs to see slabs in the parked
>    state.
> 3. Cache destruction: kmem_cache_destroy() must also see parked slabs,
>    which is obvious, otherwise memory would leak.
> 4. delayed_work (see corner case b below)
> 
> Why is this scheme correct? Because paths entering the sheaf refill or
> alloc slowpath can see both slabs on the partial list and slabs on the
> parked llist, while allocation paths that do not enter the sheaf refill
> or alloc slowpath would not check the partial list in the first place
> and naturally do not need to care about parked slabs. Therefore, whether
> an allocation takes the sheaf refill or the alloc slowpath or not, slabs
> on the parked llist and slabs on the partial list make no difference to
> the allocator. This visibility equivalence is the core of the scheme.
> This analysis also shows that the scheme does not affect the utilization
> of partial slabs or lead to increased fragmentation.
> 
> Corner cases to handle:
> a. Parked slabs may become completely empty. Therefore, unpark must also
>    check min_partial and free excess empty slabs instead of adding them
>    back to the partial list.
> 
> b. In rare cases, the system may go idle immediately after slabs are
>    parked, and the sheaf refill or alloc slowpath may never run
>    again. These parked slabs would then remain in the llist until the
>    next sheaf refill or alloc slowpath performs an unpark. To
>    solve this problem, add a delayed_work named unpark_work to add
>    parked slabs back to the partial list when no other path unparks
>    them.

OK, but is this a problem that needs the delayed work? If the slabs are
still partial, they would just sit on the partial list rather than on the
llist, but it would cause no extra bloat?
It could be a problem only if free slab(s) got stuck on the llist.

So I'd try to avoid the delayed work as it's quite a red flag. Periodic
flushing of alien arrays used to be a very unpopular part of SLAB
implementation. I think there might be two ways:

1) submit the delayed work only when transitioning partial->empty slab on
the llist. Would likely require flagging slabs that are on the llist.
Hopefully this will limit the submissions to negligible amounts.

2) remove the delayed work completely, instead __slab_free() would perform
the "unpark" immediately when detecting partial->empty slab transition on
the llist. Would need flagging the slabs as well.

I guess 2) would be preferred unless it compromises the benefits too much.

> On will-it-scale mmap1 with 192 processes, throughput increases from
> 29237910 to 35585663 (+21.7%). native_queued_spin_lock_slowpath drops
> from 44% to 30% of cycles and __slab_free() disappears from the lock
> profile. alloc_slab,free_slab drop by 52%, and park_slab equals
> unpark_slab exactly, confirming no parked slabs are left stranded.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>



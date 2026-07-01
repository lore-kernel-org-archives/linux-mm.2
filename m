Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F7E0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03A536B00B0; Wed,  1 Jul 2026 12:55:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C696B00B1; Wed,  1 Jul 2026 12:55:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E44A86B00B2; Wed,  1 Jul 2026 12:55:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABF536B00B0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:55:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 213B48DCA1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:55:00 +0000 (UTC)
X-FDA: 84940807560.03.6648D99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57022C000F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:54:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIi48hmX;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782924898;
	b=SkuCueCqAoLUt2OMtDJx0LSTmrM11EIxfBtTWc8qPAtqAsVxytEUZpx8kE3PGsoKKMoLwF
	YJka7amO6jwaJIQztR7562il6SIUYeQPIpJ6KWHFAtEJtaGRGZ0hjvP0KH/j9tJx25Zd+W
	HUjaceyZ7k/E/dHR/luDUweI776CCFk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782924898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87Wni51q7tV3DEcX7N0ywWkBdDM6S1XyRH7FSeJhsxg=;
	b=w3+tX8viCMk0eLLy45ghQjbGMPcJdsaPwCfxXhwmuiajIfDUbQteAZaO3cHZDXlfR6Q8MI
	fInCE1qqttcB9NgYf6keXfwVrhhe7LzakS9dWQVYEkyf8M757qKH+APwclhJJjviViUsgR
	aocIFeruTjoVxkBAt8ZgxJ76knKOuNU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MIi48hmX;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A075416B7;
	Wed,  1 Jul 2026 16:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E881F000E9;
	Wed,  1 Jul 2026 16:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782924897;
	bh=87Wni51q7tV3DEcX7N0ywWkBdDM6S1XyRH7FSeJhsxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MIi48hmXsvy9gv6zAWRL5MXmswZhWZ0M1QqKS9FFSgETxRmTX2oSFqeGqE2qU5kxG
	 k9280jpyr+SZh9okxydz/S4PDEhFalWWrTJP/ntLSe8r0V21zOn2UlDwojqVFcdpaD
	 yyWSQDMkpPtx5d/6NZvWAggJEGl5tipOWNlOHf3Pta2mG9GhmIt4Diw/gQg+R+gOfk
	 /QYH5/pPDy2FBtljlx1gcdfhfp5Ty2fRnXNHbwg6rVzYbrXUFjn8qPij2nGrnfbgE4
	 MywQ1ESFcJnXMuWQ0En144bm6nFQOV27fZo894EdmNDXtLGS3mWP40g2X5YldmHHDh
	 WB3BMJhUXFyQA==
Message-ID: <43b4c503-14ba-4e88-b56c-caf5ef0597de@kernel.org>
Date: Wed, 1 Jul 2026 18:54:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_init: handle alloc_percpu failure in
 free_area_init_core_hotplug
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, kernel-team@meta.com, osalvador@suse.de,
 akpm@linux-foundation.org, rppt@kernel.org, mgorman@techsingularity.net,
 hannes@cmpxchg.org, vbabka@kernel.org
References: <20260630214039.2263562-1-gourry@gourry.net>
 <b8baae33-d551-40fe-abb5-287f3711dd80@kernel.org>
 <akUszCySPFA7IRlb@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <akUszCySPFA7IRlb@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wfan5odztua9m4ab3iujys9hkhmea6iz
X-Rspamd-Queue-Id: 57022C000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1782924898-504176
X-HE-Meta: U2FsdGVkX1+Xm3YCxslok7WkX6qKK7arxrFO+ptJlbs4Kue8CMyh8GMiE+9gEXVggrGa5GkPwQevaSz6Dr2O0E36m29cC6nmalQEmoALco7qfdkMdhDilLLQfphxWg3NdHPBnO38FF+tt4W+u+YE4DAQzkb2zLGbxQvkINiQU4e3mwyWPemRcPNtlWXaPjztn5LCnZlvGqJPbSeUxoZMCOOOaq3kHNE3CrXaByj1Yh/E0M7uooMHqnd8muFZClCUYJ7Bets6qMb38KK67+ymFCiJB+zHh9J9ALWgCgJaecxzJUWqE3NRL/JX5X37PK7ZBmUjp9dow4Al3/zI/xSUYcZCaWjMhATzzBqM7w4YNrWJS1HtS44lvuPjVYaQAv41W2aZ7QZkfOORIuo1dR5jhSWkpCDnNiREHQOf2Zj+86y0gXKePJJ0snw1WPoOVvzK/753Pck7G9Qt8pMsDOtGBKgz9LrNmEU1r2Ft+Fp4Ky9oQaqah/UyictcEXb54T6xDpRIfi+Jp1FWtfNZqmgV942Yza0ignb3LLUtsLUhaf/VGSklmNao60V7ogzDdbPNrII2r6qEyFB4j4cDf4VajD+uxgNdH3oUTNYtjBKjEBzj4caLPDVIAtaNte3wH7SW5nxuR4VoLzkNbBwurMa5sOIyVXkHOzkSKiXhy49D0AuSz8u9fT2+bGUVVZtHUOFSWtorhPpEqrtTjDozCj0wYvDvuzBP/adohymtTUb0AUKYw7rlIag/ZSG2sxa1h+D9iGCMDpuuDMeLXb2NP83UoFJA0uuYOREMvJ1QbEo1v+TjWoBz6c6rx80f6ufNGlJsIYcFoRSheX0oFbvBADK0YfM1GmLXFO8MwzJxMKnSrPD8aulLWR7qOF0oEXJQdhEFQXhtHLG3MkA+4LTxDom+TIrVXoRQCuDGb9ztCnIV2bsAvOB/V+/2LtOIjiRljFO1hd5eirHfPFk1yoAP+3l
 mUbvyroh
 PupiWQYyq5f/VDmF6wcnbD6mQV5H8EodX5C5bfgJIP/CSo09KvhqQH2bfpPVnKChOJM7UGTqKrDgsfRz+d8naf2fld2jTCkmD+C6l+EvrxHO9ytfoeRL6yuCGTN4c/7P7GbpVpcgDp0g94Tgp2DCaGxRzBwYr/2uCiikTA4R2C93w7MAM1UX0I7gLgN0F31inI4/HD4DQeLP/ZjCMazdITbFjEyVtk32zoRUzqTbShBB/lViCZH7V1+s6VbR0I0c0TX8PujF4rwgeLf0b5e2GOzRdXfj5wvpl6pEsJM66IaYMzaLymwN16Wtwfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/1/26 17:05, Gregory Price wrote:
> On Wed, Jul 01, 2026 at 10:35:41AM +0200, David Hildenbrand (Arm) wrote:
>>
>>>  	 * The node we allocated has no zone fallback lists. For avoiding
>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>> index 306ea5c13f54..37fd64ce144d 100644
>>> --- a/mm/mm_init.c
>>> +++ b/mm/mm_init.c
>>> @@ -1536,7 +1536,7 @@ void __init set_pageblock_order(void)
>>>   * NOTE: this function is only called during memory hotplug
>>>   */
>>>  #ifdef CONFIG_MEMORY_HOTPLUG
>>> -void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>>> +int __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>>>  {
>>>  	int nid = pgdat->node_id;
>>>  	enum zone_type z;
>>> @@ -1544,8 +1544,14 @@ void __ref free_area_init_core_hotplug(struct pglist_data *pgdat)
>>>  
>>>  	pgdat_init_internals(pgdat);
>>>  
>>> -	if (pgdat->per_cpu_nodestats == &boot_nodestats)
>>> -		pgdat->per_cpu_nodestats = alloc_percpu(struct per_cpu_nodestat);
>>> +	if (pgdat->per_cpu_nodestats == &boot_nodestats) {
>>> +		struct per_cpu_nodestat __percpu *p;
>>> +
>>> +		p = alloc_percpu(struct per_cpu_nodestat);
>>> +		if (!p)
>>> +			return -ENOMEM;
>>> +		pgdat->per_cpu_nodestats = p;
>>
>> Is there a need for the temporary variable?
>>
> 
> at start:
>     pgdat->per_cpu_nodestats = &boot_nodestats 
> 
> So need a tmp to do the swap/revert/etc

Reviewing too many patches today ...  makes sense.

> 
>> Also how to handle cleanup on error? Or why can we skip cleanup? (what happens
>> if we get another call to __try_online_node()  later?)
>>
> 
> -ENOMEM ->
>     hotadd_init_pgdat -> NULL
>         __try_online_node -> -ENOMEM
> 	    pr_err("Cannot online node %d due to NULL pgdat\n", nid);
> 	    try_online_node -> -ENOMEM
> 	        __add_memory_resource  ->  error_memblock_remove:
> 
> Basically we're left exactly where we were before we made the attempt.
> 
> Another call should work just fine after a bunch of dmesg spew.

Okay, so the additional pgdat_init_internals) should be ok.

Makes sense to me, thanks.

-- 
Cheers,

David


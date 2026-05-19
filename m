Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B676CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C46B6B0005; Tue, 19 May 2026 11:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 975186B0088; Tue, 19 May 2026 11:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88A3D6B008A; Tue, 19 May 2026 11:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76C046B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:00:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 211FF1C03F4
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:00:24 +0000 (UTC)
X-FDA: 84784480368.20.EE755B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3408820017
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:00:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=geXqvDvc;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779202822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXTUo+55KXSJHEjaCrHNqZaEVSSrbio+OgV3+S0i2tQ=;
	b=7YWcOjVmA2uEVentrj8S2Mo2N8CfqrWydNCNkOeyuh8/jNl7qqFLvLK0xJFhUPhgn49IbI
	xzwiQAgHU6fzjh9rvk14Pk6h07YOYQ9sKX5hVIqSSscTIqC8eKNkekCnRj/jrCo83PsS9r
	EqbX5JkH4fHNuhWW3RfEcKZYIEDpMaQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=geXqvDvc;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779202822; a=rsa-sha256;
	cv=none;
	b=fcNnxdtRxqln5/Af0LlvkkLvEmjNRuooXI0ZpDuwp23dAmPifVfzMXp75V5xHuCxJO8eSy
	cn9FlKfQvrGfkKrrsSuBsb4THCpxR0uXsKr/dz4QIxbQpaDxMJAq1ZcrECYGF/JW3YiyVm
	eycHI4tkPb8KgMa4W7xycP49a5zjwsc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DFA04005B;
	Tue, 19 May 2026 15:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CFFC2BCB3;
	Tue, 19 May 2026 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779202821;
	bh=+vafbmR6P35W1uPb6vJ+4sthJQy6Z+LMEd69JGdKiKk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=geXqvDvc1oWGQxvj2TsovQelBq2ywdFPQQyYsBI1gbg/54JH5yOlGnKHwpy7p9vkF
	 TdCxavWRyTcebE5FHmsC80cTvkB7WwU1i1KqXF1pVjXN/REheRLvXKNAqxxmZS4aac
	 Bxo7kUGhPNOoeu+TazCiFDcAlYpEswO1jkxsCxE+LvNEU9Y1QBO5p6bdeCCobUkxJA
	 qPGi/Y2+/SWGU5ENPe5NohU0O/B87AVeJUS1WOh9hdeBWIgaW4u5/xrOwSV6WXlPjo
	 KfkGyMw6/yK5w6c4CNRqXDLyu6pW1F//hGETczuAbuppSVtbsihiso2Q/JjGEfgSTP
	 J4aW7D6RB2LGw==
Message-ID: <ca8e655d-5fe7-4957-8a36-6667616be8b6@kernel.org>
Date: Wed, 20 May 2026 00:00:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
 <aguiSnY3ie1y4nEl@linux.dev>
 <4e296262-fbbf-4ac7-aecc-3ef831583704@kernel.org>
 <agxszIIN6FtK0fEb@linux.dev>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <agxszIIN6FtK0fEb@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3408820017
X-Stat-Signature: b3xtffbuhsswza6gdreoxfq9fbipqu3m
X-HE-Tag: 1779202822-851889
X-HE-Meta: U2FsdGVkX1+NNlxu/rVkzTgSnd/n5rL+HS3E+sBOQKUZllnYrTO2vkbiSYFdPeJFgKwb0SURpqjJqkPrUZvkUhUOZiWmfOfyniIqi+emvNz56PosI5CK/NsCGYtvz1BvqHiLV0pWJ6qNU8XF6f7cF6jON5Koot+HcAFNlyzRbcnBMyDVgQgb1JvDxgSnb1xibvagIx6Zx/TZZ/nXbipdZBuLNHmwCrjiz287grq/E81nvQ2F7bbNPCQ7rxqtFKGEWEtW+03hLMl3EuP7gBXR2nLgI5FwcV+9Z/jrn2aDy/v0ZOP/x8jvRifVjG2SnnXn82lOqpKYtZc+kO4P4LvynsQltQOMY2JYY0JDGe+p3zMi/N2cyPvbQSzGmgR6uw/oF8CZVlUidTnpXfC+ofSeILqg3+RG9nWpTPVmIKuvFsWt0PGhRtvoYXrACHT02/6WU7S5xY3s00qvY71A4CDDdFCdz9nxd6kCJD0gUKKhlv9OcmcTf5MWibjfryOg46Lq0JvOOZQ+tJJ+jeisn8gANoH8+tlEwpzSdfLEMGYy5XTN3wKs9u1B9Pg2nBMa++AtZRxWyTSKFWuQYzEJp9idDoQHPmMLu9DTiXIykG28kA2lTIlsIxlxC6SEOeFlT4FMo+3bnL3XQttm7E31SQWK1ilQ3rY+n/fzNVqPASOr9ztyvnv8rFNAyCz2kxN3g0YM++PvF+w6calUzf8Bj/H0HZFTlP2IYS3l77Su28aUXbM8FlwNy10KGjh+n3qMgykr/6neBfTvS2F1LlqZgQA0NXp9d9ifljeypEWmtHcUnAfggS1LpWoYC2Cb4dPswbwA/Kk3f0fHeK984kCpzSZmMmYMT1DdrEvyZxk3NuDng12Y94gDeASmqQ/0gcDWGUPI2nNTFNq3K+qBxJrrquq/pcfiot6OLpP3LjUsfZqQowLKxi8uXgfwmVztg13gm9tgNb5I5c9tqUZB904kk5V
 rACIOp/+
 P1blzqcu41U9PvsXOGpNj8DexXNUA4i1H1gBFiI+hTMpaiRSHj7v5uKYGj1Rc2NqQldsX/GixJRgsw+trE5VBlb+0MK5XWbOsFRk1bPHv+BWmvpzNgKm3EJs0ujbSPWZ3YPZEetS0dBzd/tzztlQA6z02bYmaWzgsyWQZIcw8c37YCuNnsXan76x0JqhOkWkUS/jntJXNiz0gegRE0e/k0gKVzgpn3sEyaaGGCuR6u2OKBgfJIdB/K0HJ+yd3Dqribn6m/WGVd/xdXZjQXSRFkKiHB/7MN7stbmUh5DVZ+ZsklNgeb2euoTq6kQrfllCHMdp0fDR87hUpR+UQ2utHqhb7pR0f/KEAyXVfBj0GsSjyomXVw1uYHSB6EDmavl/o7cajbIDPsLQwjh/byWWgBlePEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/19/26 11:02 PM, Shakeel Butt wrote:
> On Tue, May 19, 2026 at 03:46:51PM +0900, Harry Yoo wrote:
>>
>>
>> On 5/19/26 8:41 AM, Shakeel Butt wrote:
>>> On Mon, May 18, 2026 at 03:28:27PM -0700, Shakeel Butt wrote:
>>>> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
>>>> per-node type") split a memcg's single obj_cgroup into one per NUMA
>>>> node, but the per-CPU obj_stock_pcp still keys cached_objcg by
>>>> pointer. Cross-NUMA workloads now see a drain on every refill and a
>>>> miss on every consume that targets a sibling per-node objcg of the
>>>> same memcg, producing the 67.7% stress-ng switch-mq regression
>>>> reported by LKP.
>>>>
>>>> stock->nr_bytes are fungible across per-node objcgs of one memcg.
>>>> Treat the cache as keyed by memcg in __consume_obj_stock() and
>>>> __refill_obj_stock() so siblings share the reserve. Compare via
>>>> READ_ONCE(objcg->memcg) directly: pointer-compare only, no deref, so
>>>> the rcu_read_lock contract on obj_cgroup_memcg() does not apply.
>>>>
>>>> Sharing the reserve without re-caching means bytes funded by one
>>>> per-node objcg's slow path can be consumed/freed under a different
>>>> sibling, leaving sub-page residue on whichever sibling was cached at
>>>> drain time. The pre-existing obj_cgroup_release() path would WARN and
>>>> silently drop that residue, leaking up to nr_node_ids * (PAGE_SIZE - 1)
>>>> bytes per memcg lifecycle from the page_counter. Forward the residue
>>>> into a per-node objcg of the same (post-reparent) memcg at release time
>>>> instead, so it can be reconciled later via a refill atomic_xchg or
>>>> another release; the chain terminates at root_mem_cgroup, whose
>>>> page_counter has no enforced limit.
>>>>
>>>> Please note that this is temporary fix and will be reverted when
>>>> per-node kmem accounting is introduced.
>>
>> ... because once per-node kmem accounting is introduced,
>> "stock->nr_bytes are fungible across per-node objcgs of one memcg"
>> no longer holds?
> 
> Yes
> 
>>
>> And the follow-up plain is to revert this and address it with a multi-objcg
>> percpu stock [1], similar to a multi-memcg percpu charge cache we have now,
>> right? (regardless of per-node kmem accounting's progress)
>>
> 
> Yes

Thanks for confirming!

>> If this temporary fix imposes other potential correctness issues, would it
>> make sense to land [1] in mainline before the next LTS release and skip this
>> temporary fix?
>>
>> [1] https://lore.kernel.org/oe-lkp/agtPMpQK2jXdQAY4@linux.dev
>>
> 
> The full clean solution might take one more cycle and I think we can not just
> ignore 67% regression on 7.1.

That is valid point, unfortunately.

One more thing I have to ask... for v7.1, wouldn't it be a safer option 
to revert the per-node object change and re-introduce it once we have a 
cleaner solution?

This change was introduced in v5, but the implementation before v4 had 
been exposed in -next for a while, and I think we don't have enough 
justification to keep the per-node objcgs change, at least for v7.1, 
given that we have an unexpected last-minute regression and
correctness concerns (albeit slight).

-- 
Cheers,
Harry / Hyeonggon



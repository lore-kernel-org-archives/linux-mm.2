Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2EA606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jSWOy8LJ
Received: by kanga.kvack.org (Postfix)
	id 3F6FE6B0789; Tue, 27 Oct 2026 10:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE2F6B078B; Tue, 27 Oct 2026 10:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E54B6B078C; Tue, 27 Oct 2026 10:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 082F86B0789
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:25:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4165840A27
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:25:43 +0000 (UTC)
X-FDA: 85368629766.11.187B87B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 67E6F40011
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:25:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jSWOy8LJ;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793111141;
	b=Jrxnrhn5J4qAZMlkiNwCzsX5aVJ0vBXuyBL7UYQzGaKRb0mB+Mkf945e5tnFO88R6UexUz
	KLnuzVHc91Pmp9C54rWOtyeTOaK5YuIPNIWFIHkmAu+6qhbevXNCzx4Npug25Lv+Lueja+
	cf7RHjVkJ3lPYaytG3RyrKwNifpS664=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jSWOy8LJ;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793111141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFhjsSzjrSaqA5+aCRY0bUwXIe0fg6PlHgdKnIMoQmM=;
	b=SV3G3XB13icxa+/+1v+fB8waDq9/indl0fj+fNYGohMAToWWZNsvhRzW3P9/Xf1yGKcGcF
	zAzjVfUEaHbRnEPt/piqQJoMNsy5XhaErDhJ5/XCivB1TOb3F6bh6dStvMYjnS1Yclu2CC
	rZrWFi2ZOePGf+Q+ARBTduBzWX2RNb0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A55584093B;
	Tue, 27 Oct 2026 14:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 624761F01825;
	Tue, 27 Oct 2026 14:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793111140;
	bh=PFhjsSzjrSaqA5+aCRY0bUwXIe0fg6PlHgdKnIMoQmM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jSWOy8LJkxSak6c4LrJF2hwurtL3ucz2THXT6d0oHTxI9m1wovlLyhOJHhUd6RTa/
	 cggsX+CFEBWxuO8U3lTyg83IQBx8Inwaoaf/1TlTOWKe8f8XEAe5mInFdhIlEJOFnY
	 Kn5ebNwLb/95HniTpqjyuCnviZysgwKWv7Ot5WGh+X/t7wcwUJpUzqLsDjrjWMixsX
	 5lwZjWuypADQXVuRKqWalOX+tgIbIJFVhCDXwwzsQXzk30xvIGOpM3MEV+MA95F23E
	 yyz++iSrSpqSDlNfloyjH+X5bES8Sq5NEKpag51F2qXPPI+MKig2kmr1qEa0c/doy5
	 xIHsem+WCwhZw==
Message-ID: <1c61eeb7-5fad-46e5-9643-e99050b9042d@kernel.org>
Date: Tue, 27 Oct 2026 15:25:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: fix pfn walker races with memory offline
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, osalvador@suse.de,
 muchun.song@linux.dev, iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com
References: <20261027042204.3741307-1-gourry@gourry.net>
 <01d7d54d-0047-4eb6-a1d2-5b3f113f26cf@kernel.org>
 <179310071902.664110.12994053710961856591.b4-reply@b4>
 <9051ac3d-60b9-4ed2-b781-b7191898bc83@kernel.org>
 <179310895201.1491991.14362391061932133491.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179310895201.1491991.14362391061932133491.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mzodwgdpwq1d31e67jp556ji8axgk7p9
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 67E6F40011
X-Rspam-User: 
X-HE-Tag: 1793111141-730050
X-HE-Meta: U2FsdGVkX1/GULCC8tsCW8W9xOH+eogYuywpBGj+3aVJa8NVEfOy6/LIjZrWEYA02qnqBGI8Exyfqwm1tlgIbNiOIrvExwRYBBlq8IasgvPTWKuOnwujwqlTtaiZKiH2CPOAUL2YcUtt6ZNiKgwc75naTtIG9z1izTzRDbKLK1iGxWz1B69PPN0SUksh3bdM9BDBxjsBbVMwVzqvs7MUnLCBvSWKc0jWaE2myN9IfsR7NzNh7Yqb3Ka4o8Gx2wFX1Txtdk/RjEbU5zN/G0uL00WE3UpOzsMCVHa/C/K22tYCoi7hNcdcPjgu8WAnt/B33SSlCzhKP5VT4M5EZTHwsPOcZ1C/5B+2EmpeScHu9ryOFgduVKIMYvjbs3zbYe8EIQkt/kCYKRP8yktXIpLNffFWOKXTGWvflG1Pd+EZnRI/bUI3Lix9Tsj3OBxJeplkebUjCe+9ioxa/dLqRAbRztoUXsT1taFye+K6atSgMjXCbWCD0LNR4ZfAppYjBlglF5cKildrLHNrapDOSMaq5JCDLTq+S0RdPJVrpuYTUAmY3M+9dgt8zpMorgcx10yvJzEjdKO7DUrJO81MYjI+uvLB8nKub6idBZ7W8cANktv8sE+pHN+R6jE85SIAB/dPgkkntLYjr8xuBnR8CfANDRB46trFNbJb+ZZGTCkUJFb8ZC6iMtL9e7GnliUUTNHhRAiLlQ1cXGKEW/coi7mWwYc39JzrMDRkO/k30aEm+/9nIB6OWwtMidhMOY5AcbxUXmKqzyEyuoNxXCz1DUdDpkuaunmgNHV5VCXaXRTBe12JP6D1PipVymf32smnCJUOqJAirckSRsqfqqvoHLJqU8OqIv1+1FKgFTK9u2rOBbes3r2Hetb111pdgUU82/fAZyC6ejyJ5+Z8y9DkMT4HNR4Kvh0Nsn4RS1Iqs9kR3r2uo5CqxBQQHttL9/U4KPt1pyQ53xouUKjFOf5hB0X
 PJ9zimw5
 XwVQMl8LBlhsV7qw6DpRpslh3qkZcEDsxzCG+6r2LyXvvxT9HNrHKe76G+erPb6aG9TTHmpNaBaXAlbxvfUK7IE4BLJZoeiQWGrbhZmUC77tn+ovqVm9uwhZkPM9v2RM9aM+FZcw54WxsBg4bBE4jV++G+GJOBv4DKBrzZ6YxhD1muDhKvpcwmiZCahzs/BVykxAR8hq8GlGMCVzjPjgF1DaDVJK2GF1iQUwskTrAS/Y66dhlO3dvDNT160DDx3MimMnAKApIiH1RZYGB4Pe1UvPvLR6vqSH8AXVGQjyv/9No6duxrI71e+8BC2SEkfonGAkxbLkOK6SZXBmQ+6mAIxhSbfF4f80wv56wqfGqZuxgKMpxfAlwTCxFjCVty4bjAxV9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 14:49, Gregory Price (Meta) wrote:
> On 2026-10-27 13:51 +0100, David Hildenbrand (Arm) wrote:
>> On 10/27/26 12:31, Gregory Price (Meta) wrote:
>>>
>>> I actually have a reason for these fixes other than "bot said bad".
>>
>> So you found them on production kernels?
>>
>> We did not have a single real report of that for probably a decade or
>> even longer in production.
>>
>> Recently, we had the single first report about the compaction case from a
>> stress test (no production):
>>
>> https://lore.kernel.org/all/20260903095543.3752338-1-yuan1.liu@intel.com/
>>
>> "We are not sure whether this race is reachable under realistic
>> workloads or only under this synthetic stress test."
>>
>> Where I motivated that we need something clean.
>>
> 
> tl;dr:
> 
> while these are ai-generated, I'm not posting untested, unreviewed
> schlopp for the sake of getting patches upstream.

Appreciated.

For this long-standing considered low-priority thing in particular it is
reasonable to go back in time, see how often it was raised (quite often by me)
and how often it was actually reported (I found one case).

Then discuss the high level design in more than a single sentence :)

Discuss why we are not using it for other pfn_to_online_page() users, how it
interacts with zone->contig etc etc.

There really isn't a lot on the design in the cover letter.

> 
> I actually care about this issue.
> 
> ---
> 
> Some of these don't show up as crashes but instead as hung offline
> attempts (GFP_KERNEL landing on movable).  That shows up as our
> hypervisor just failing to overcommit / guests hanging.
> 
> The compaction/alloc_contig bug is one I've seen in production.

Right, but I suspect that's "[PATCH 4/6] mm/page_alloc: don't undo another
isolation in alloc_contig_range" which is *not at all* related to "mm: fix pfn
walker races with memory offline".

> 
> I've seen a handful of NULL derefs in production i suspect are the
> zonelist derefs, but it's hard to say (they're rare enough that we
> lose the dumps before someone has a thought to pull them).

That would be interesting to know.

> 
> I expect this will scale up as we increase the number of VMs and
> the amount of hotplug we're doing.
> 
> For clarity, we use ballooning + hotplug as a combo:
>  - ballooning to do cooperative overcommit
>  - hotplug to defend host stability when the overcommit ratio is extreme
>    (basically deflate_on_oom because a host stability issue)
> 
> We're pretty aggressive about ballooning guests to squeeze them and
> dropping the balloon to hot-unplug that memory when a guest is cold.

Yeah, that makes sense.

> 
> 
> skippable side note on virtio-balloon/mem:
> 
> I have some improvements to virtio-balloon and virtio-mem that allow for
> handoff from balloon directly to mem for hot-unplug without having to
> drop the balloon, but I haven't posted those (and we don't run those in
> production, so this is not the nexus of crashes).

Do you mean free-page reporting or actual balloon inflation/deflation paired
with virtio-mem. I hope not the latter, because that is just disgusting.

> 
> Similarly I have another extension that lets the host set a "NO_ALLOC"
> bit on the zone so a balloon-only system can provide the host a way to
> defend against mass deflate_on_oom events (we prefer guests to OOM and
> have the host to kill them due to PSI, rather than threaten host
> stability). Also not in production and not posted, but there have been
> a lot of experiments on overcommit here.
> 
>> The thing is that the race between offlining and actual memory removal
>> is extremely long. Poisoning is just a mechanism to find these theoretical
>> issues that could cause issues faster.
>>
>> And with all the other things going on, this has lower priority, and I
>> wanted to get back to the AI patches I have once the other thing is sorted.
>>
> 
> Sure, I realize I'm pushing this out during the merge window, but I
> felt it reasonable to get some thoughts on whether these fixes are
> worth considering for the window.

Just a matter of priority. I think this should be tackled in clean way indeed.

> 
> If the answer is no just put em on the back burner. We can carry
> fixes as-needed.
> 
>>>
>>> I have a reproducer for every single one of these (and the other
>>> series) - but a handful are unreachable due to a 2-statement read
>>> being emitted as a single read by the compiler (which can be undone
>>> by a targeted compiler flag). Those were included for completeness.
>>
>>
>> In general, I think we want something that will protect all
>> pfn_to_online_page() + zone->contig thingies, not just selected ones.
>> We discussed in the past using some sort of rcu for that.
>>
>> get_online_mems is usually the wrong approach.
>>
> 
> Agreed, although the PFN walks seem genuinely harder to wrangle into an
> good rcu shape.

And that's where the overall design needs to discuss this and how to resolve it.

:)

> 
> get_online_mems seems like the backportable solution, but i can see not
> wanting to have to go clean it back up later.
> 
>> protecting individual pfn_to_online_page is just whack a mole. Likely we want a
>> way to check whether pfn_to_online_page() is called from the wrong context, and
>> maybe we need a variant that can be called from "wrong context" for a good reason.
>>
> 
> Agreed.  Although I fear the structural fix for this will have uglier
> performance issue than we think.  Then again, maybe it doesn't matter
> (if you're doing a PFN walk, then you're likely already doing something
> stupidly expensive).

Which areas are you mostly concerned about and from which piece do you expect
the overhead?

> 
> Where i'm largely concerned is the page allocator and the
> compaction/contig code not taking a regression.
> 
> For zonelists i've ended up with something like this:
> 
> @@ -1461,7 +1466,7 @@ typedef struct pglist_data {
>          * Generally the first zones will be references to this node's
>          * node_zones.
>          */
> -       struct zonelist node_zonelists[MAX_ZONELISTS];
> +       struct zonelist __rcu *node_zonelists[MAX_ZONELISTS];
> 
> ...
> 
> static inline struct srcu_ctr __percpu *zonelist_read_lock(void)
> {
>        return srcu_read_lock_fast(&zonelist_srcu);
> }
> 
> static inline void zonelist_read_unlock(struct srcu_ctr __percpu *scp)
> {
>        srcu_read_unlock_fast(&zonelist_srcu, scp);
> }
> 
> DEFINE_LOCK_GUARD_0(zonelist_read, _T->scp = zonelist_read_lock(),
>                    zonelist_read_unlock(_T->scp),
>                    struct srcu_ctr __percpu *scp)
> 
> static inline struct zonelist *pgdat_zonelist(pg_data_t *pgdat, int type)
> {
>        return zonelist_dereference(pgdat->node_zonelists[type]);
> }
> 
> With this the zonelist cookie checks evaporate, but you still end up
> with guard() at every walk location - not great, but better i suppose.


For "broader" things that are not just a simple pfn_to_online_page() user, we
could also have memory online/offline sync in more efficient ways using the
memory notifier.

It's also tricky, but maybe for zone->contig + compaction the better solution?

> 
> I was hoping this could be sunken into the zonelist walk macros, but
> I haven't seen that pan out.  I've been spending a lot of time auditing
> that code for private nodes as well.
> 
> 
> On performance:
> 
> I've been hammering this with will-it-scale and a bunch of workload
> tests on a variety of hosts and have not seen any obvious regressions
> outside of powerpc (which i can't test directly, but SRCU-fast requires
> atomics for powerpc from what i can tell - so it will eat overhead
> without a fallback... if there is actually any hotplug ppc hardware out
> there to care about?)

So the big problem is the overhead on the read side for srcu?

If we can find something else to suspend compaction, we could maybe switch to
rcu for the remaining cases.

Now that I think about it, I recall why I didn't fix this earlier :)

-- 
Cheers,

David


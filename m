Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9BDECA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 19:57:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318F86B0088; Tue, 29 Sep 2026 15:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA696B008A; Tue, 29 Sep 2026 15:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0946B008C; Tue, 29 Sep 2026 15:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED4D86B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:57:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5BD6A16055D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:57:07 +0000 (UTC)
X-FDA: 85267858494.24.B21E1C9
Received: from dog.elm.relay.mailchannels.net (dog.elm.relay.mailchannels.net [23.83.212.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id DA0211C0004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 19:57:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=Wufqs1OW;
	spf=softfail (imf21.hostedemail.com: 23.83.212.48 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790711825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxMsgv7QdRgYyE7jsfFXudm4dBWFzhEls+snUKxmoRU=;
	b=Wu54ZZsPLdxjR1j/RdUN92Ekw4S1GhASW20IoDYzL7ojAik0r1+Nrf/wvv3xH94uqKntEk
	qfWmXxd6j9qjk/8qRq0wM7WSD7x7iuOVsu1mMHNqxrFv5KRLU+hz4lkO1wy8yexJrd1V2u
	p/b9Lp9hKzvuMJPnL+jtuajMgUDoKyw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=Wufqs1OW;
	spf=softfail (imf21.hostedemail.com: 23.83.212.48 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790711825;
	b=dEO6gIJ72yuVXm4VFyDMguxhwHornyaQCmXkbGmL2uoplbd12rQxI4W2EemeD5xyKHuC9g
	fGZSRH978uzf0/RFqzlCe0m2JY2YM1aDeGICYzHH3YYNaXLKkOPugW2S/ru2T/rzGZDUQf
	ioyY6TBdUYP0Zq161ToLiWi2VNU8O18=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 62A62461434;
	Tue, 29 Sep 2026 19:57:03 +0000 (UTC)
Received: from pdx1-sub0-mail-a258.dreamhost.com (100-96-12-141.trex-nlb.outbound.svc.cluster.local [100.96.12.141])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 9E87146245A;
	Tue, 29 Sep 2026 19:57:01 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Macabre-Lonely: 6e3c9a745d573fba_1790711823248_166122602
X-MC-Loop-Signature: 1790711823248:766552379
X-MC-Ingress-Time: 1790711823248
Received: from pdx1-sub0-mail-a258.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.12.141 (trex/8.0.2);
	Tue, 29 Sep 2026 19:57:03 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a258.dreamhost.com (Postfix) with ESMTPSA id 4hvTTl6pZXz105F;
	Tue, 29 Sep 2026 12:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1790711821;
	bh=pxMsgv7QdRgYyE7jsfFXudm4dBWFzhEls+snUKxmoRU=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=Wufqs1OW8EeFlMwH86dA7lMFChW+V71vN4GvQEGx6Wgec0NC9jrdmz/lRuqgexRSx
	 RTlgxRRpmdsHRxPiEbbb+sb3IEXp+j8fauEEPwK2UMpkZ9vk37HWXfC958FLlHVuYx
	 bP5cTJk1rPIjWZuqhDAMPH57tlykgQp7cQ6HI5ZuWbCyqm40bx3vmZMdVwEJ2i/fh8
	 rkSQhTLzOfKN2r/ClRgGxciqoUj5yN9JE8NpZ1kvbr3Rn4p9zZgJmp3fNEIEbDYrBA
	 WiQgTvf3KgSmzRPzcUrqkPF9h6utTg37UAImktqDrGWw8dgFIn1MCRg4nhzTVDvNEU
	 CuVa82E56bZBg==
Date: Tue, 29 Sep 2026 12:56:46 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jic23@kernel.org,
	dave.hansen@intel.com, gourry@gourry.net,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, nifan.cxl@gmail.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Message-ID: <20260929195646.4ttbl22clnrrktg7@offworld>
References: <20260728054356.291998-1-bharata@amd.com>
 <20260925021226.52kpnmvfylw73dz4@offworld>
 <31442591-d020-47b5-8f1c-b87fb632c226@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <31442591-d020-47b5-8f1c-b87fb632c226@amd.com>
User-Agent: NeoMutt/20220429
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DA0211C0004
X-Stat-Signature: b1aqkwxeifyhxikskc7gjwurs6dnbnmq
X-HE-Tag: 1790711824-322337
X-HE-Meta: U2FsdGVkX1/FCU/bB3u76JZYMsbxVqeq7V+AQjvlv7b2OUkyRB5gP+0qYN/HhmL28Ohf2MvxmU32pAxw2hzFXSl3HqgadBrNB2qDtJH9ee1rLrY5I2uYSMc2ixVDGdKhFT9RTnhwUwtjosbuYrsQG2iwfnW+7H5wQyMLBj6DUNkCnUG+5moMEYS7fazfKtt3QQ5rOzCxVBjDe/Yanc0Awhto1CfCxcwH3nklY989ordfSsk1ckf70HK/ur5siV1MRUBAYmhZcYis5DWNX0NaFPs1ffx9MWKRrEknQbziaXVnKq5cw6f6WsquVr6SR64sBYl2uB2ggiJACwgjMbVkI6DKZF9Jiemtt3LELSe09hIe3pj7ura+eG9Bm52YeECnNaWOCqAywMZGE4HolmqSjo+68qI8wWCIyGdfglFRHaAnPCvon1/1CRAOfX0VVMBgXzJNW1pbotcXUCrEP2hcg4ltpF89ZGkBAj7YlzSMw5adzOqHgLJZTzI35qKQSFNplrx9zXUElgPxRR+LEV8Vdiw6rlm/Oa5wS5fP3C9+7NgihyHhmcbS5PJKqWYdJBDbOCaIbzM2YfUSZhlR4iH4ltB4hzBuECoWcINFm7LCs6BZFhGHITzFZkvv8MrmLfmQlAL6lIERY4uirOH2ZGPppkl6neYkM5Me+cQYTLtOm6LdA1VzNeCFIWhzQmvNh3UuVAh2BnXZ2Dqb1FVg0RR04HfAnNOw+Uzr+sO4OXz/S+YXavEtULR/xqVDVtksQ0SrHqIib7eCQgnDvu9M//tJOaYdU8Ftrqkq9OW80btp3ENnIEZgVMy4dTdFgbsHtF6oPQd1YaePwAQ5HZdj4g0qi2pjgbIAm2BxLtfzxhNuWW4L7AfVt1QKAvAI36ZJ3JiLVtOi34ESy83u5Sje3H6w4afpjoAxkJZN/Y+LUMi7dgnK5W4ET7ehfup+NIOpaT3nvIOT5OBtFfkBPCtVgZX
 JCZlZIxV
 lzGKMCT4yuDqhafHWOFj3VMZkmUx9h4cYnXdqb5YGwXS4GLFSF6AIasTOdJog0Ffuqsf4IebohFANd/EzIT+GUC1uOoswm6FD7kXSSV23Js++X9G8IaCi4tq8CgZRldeNQxr1b/gcD0HAor6vHJayOe7EvUFMfdZVDo9tNecP3fLgRIOMjR1iUcNrIwVA1LPiF5axuDIBvedfh8EYnUbYLrc9vxlxPIpiGpNcW9IEBgFN1rcPBBYhIt0Qe4SnnMoT+TrzZdtIqPV9mb7+OtNbayoptyeC035vjNKzNr5n3b/XdWNirJN2EEsVIxew363fEU081w5sQh+auP/Dv+Y2KlVZOy836Tk3wtALLuS8BOfOG9Bw83jEw53sH8u8PmvoN7xqo+E0mG3dj4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026, Bharata B Rao wrote:

>Hotness promotion engine
>------------------------
>This is not something that was written for pghot from scratch, but instead it is
>the same hot page promotion engine that is part of NUMAB2 which is now
>generalized and moved to pghot. So this is not the complexity that pghot
>introduces afresh.
>
>So considering all these, I see pghot as a light-weight and low-overhead
>mechanism to track per-PFN hotness and do async batch migration. Initial
>versions had fancy double data structures; a large hash a small binary tree of
>promotion-ready records and associated synchronization mechanism, but that is
>all past now.

I think we are all in agreement that the async batch migration is wanted.

>
>pghot interface for sampling
>============================
>pghot_record_access() interface was designed keeping the existing NUMAB2 source
>in mind. It fits that and it fits other sources like IBS Memory Profiler. So
>sampling sources report an access and the shared promotion engine acts upon it.
>
>But for sources like CHMU, from what you describe, I gather that a bulk
>reporting interface plus an indication to bypass the engine to treat the PFNs as
>migrate-ready, is what is required. Should those migrate-ready PFNs go through
>the regular pghot tracking (getting into section hotmaps to be picked up by
>kmigrated) or even that should be bypassed?
>
>However, in the context of PTE A bit based source, I have often thought about
>extending the interface for
>
>- bulk reporting where more than one PFN gets reported.
>- indicating the bypass options (frequency check bypass, recency check bypass etc)
>	
>NUMAB2 has to perform better in pghot
>=====================================
>pghot is about a sub-system that makes it possible to have multiple sources to
>coexist with reuse of common hot page promotion engine.
>
>NUMAB2 source resides within the scheduler and the promotion engine is also part
>of the scheduler. Through pghot, I am separating the source (NUMA hint faults)
>from the engine and moving that existing engine into pghot, to a common place
>where it gets reused for other sources as well.
>
>It is the same NUMA hint faults and more or less the same engine and hence my
>main objective is to ensure that there is no regression during this move.
>Additional performance optimizations can be done to the engine itself separately
>but that shouldn't be the baseline expectation from pghot.
>
>Is moving hot page promotion out of scheduler into a dedicated system, a good
>thing in general? I believe so as scheduler isn't the right place for it to
>reside. However I would like to hear from scheduler folks on this.

So two of the autonuma balancing og authors are scheduler experts - and iirc
*the* reason back then was locality. And Peter has already nacked the IBS
stuff in the past. But indeed the batch async part would be good to get nack/ack;
albeit the cgroup charging situation.

>
>Do we even need a centralized hot page promotion engine?
>========================================================
>NUMAB2 is good and serves as a good baseline for any new source that comes up.
>But with different kinds of sources becoming available, do we want all of them
>to  duplicate the hot page heuristics and promote hot pages on their own? I
>thought that may not be preferable and hence started this effort.

What are these sources that will become available?

>CXL HMU may not need the promotion engine,  but IBS Memory Profiler needs. It
>needs a promotion engine with full recency and frequency considerations before
>promoting. I don't think an arch driver like IBS Memory Profiler should be doing
>hotness heuristics within itself but instead be using the existing engine. In
>fact in my early posts, the driver based on primary IBS instance was feeding the
>"access sample" as "NUMA hint fault" to NUMAB1/B2 so that rest of NUMA
>Balancing/Hot page promotion engine just worked. But I think pghot is a better
>approach than that.

I agree that the IBS driver should not be doing hotness heuristics, it's the hw
that should.

>
>Why full pghot? Isn't async batch migration enough?
>===================================================
>Some of the above reasons apply but during the course of iterations, I have had
>implementations of just the migrator (kmigrated [1]).
>
>If every sub-system/source has intelligence of its own and just wants to
>handover a list of pages to async migrator thread, that's not much of an effort
>as this implementation showed.
>
>But then if some source needs rate-limiting and another source needs only
>hottest pages to be promoted, then again we overlap with the existing NUMAB2 engine.
>
>Then if we want to be slightly generic and want two sources to complement each
>other or the promoter to differentiate between lukewarm vs hot pages/regions
>then we may have to maintain hotness records and may soon end up with something
>similar to pghot's hotness tracking and reporting mechanism.
>
>Hardware sources have to out-perform NUMAB2
>===========================================
>Different sources will have different characteristics and capabilities and will
>help different workloads differently. So it is the choice that one could
>provide. Sometimes sources can complement each other as well.
>
>What IBS Memory Profiler has shown is that it can match and/or exceed (for
>Graph500, ptr-chase, llama) NUMAB2 with no hint faults overhead [2]. Also please
>check the initial XSBench numbers in my inline reply.

It's all about the numbers, and the ones you have just don't really sell - which is
one of the reasons this has been going on for years. If numa balancing didn't
exist, then maybe adding all this would make sense. For the XSBench I don't think
making decisions based on the non-overcommitted case is worthwhile.

>
>Cost of an unused source
>========================
>Not all the sources are required for every situation. Sources can be disabled at
>compile time or not enabled at run time with no cost or effect on other sources.
>But hotmap allocations would remain as a static cost even when no source is
>enabled (built out at compile time, the map is gone; sources off at runtime, the
>map remains)
>
>Tracking granularity: per-PFN vs region
>=======================================
>Often times this question comes up when pghot is compared with DAMON.
>
>Firstly, the baseline that we have (NUMAB2), tracks hotness at page granularity.
>To support this, pghot started with per-PFN granularity. Naturally two concerns
>come up:
>
>1. Memory overhead: I have shown the numbers above. It is lower-tier only and
>not much IMHO.
>
>2. Scan/CPU overhead: pghot started with scanning all PFNs, that was expensive.
>Then it introduced hotness bit per memory section so that only those sections
>which are marked hot are scanned. Now I have added (yet to be posted) a
>sub-section level hotness tracking where a hotness bit is maintained for each
>fixed 2M region within a section. This has considerably reduced the CPU overhead
>for kmigrated thread. While the ptr-chase numbers that I shared with the
>separated out IBS RFC v0 post of IBS Memory Profiler [2] does show the kmigrated
>utilization numbers with sub-section tracking, I plan to have some more numbers
>ready for LPC.

I look forward to seeing any new numbers you have. Region granularity is certainly
more aligned with willy as well as chmu.

>I am beginning to feel that this may be a good middle ground between real
>region-level tracking (where all pages of region are promoted irrespective of
>their real hotness) vs scanning at sub-section granularity but performing
>per-PFN precise promotion.

[...]

>I would be interested to understand more about how you ran XSBench, the
>parameters used, the promotion stats, if demotion stats etc. Do share when you
>get time.

The actual command is 'XSBench -g 90424' so only set the gridpoints, everything
else is default, so total ~44Gb footprint. I don't have the vmstats currently
(I do not run these benchmarks) but will share them once I get them - I can
affirm that demotion is in fact enabled, so full TPP up and down.

For the chmu: 32GB device (1:1 dram and cxl), this is with a 4k unit size, 1s
epoch, reporting mode is always on, threshold value is 1024.

The numa balancing mode was set to 3, the rest used the default values:
pghot_freq_threshold=2, pghot_promote_freq_window_ms=3000,
pghot_promote_rage_limit_MBps=65536, kmigrated_sleep_ms=100, kmigrated_batch_nr=512.

I also have numbers for two more benchmarks with a real chmu, with basically
the same numab parameters:

(i) TaoBench almost 2x throughput, going from ~250 qps to ~480 qps, vs NUMAB3.
     (dram:cxl is 16:32Gb with a 32Gb memsize, num_clients=2, clients_per_thread=75)

(ii) Graph500 only shows a smaller ~20% improvement vs NUMAB3 (bfs mean time drops
      from 5.0 to 4.15 secs). This was for a memory ratio dram:cxl as 64:32Gb. The
      algorithm is BFS, edge factor 512, 16 mpi processes.
      (mpiexec.openmpi -n 16 ./graph500_reference_bfs 22 512)

>
>I did a round of testing to compare base-NUMAB2, pghot-hintfaults(NUMAB2) and
>pghot-hwhints (IBS Memory Profiler). I am still experimenting with options,
>placement etc but here are my initial numbers:
>
>Non-Overcommitted case: XSBench working set fits fully within toptier but starts
>on lower tier before the measurement phase

Those are nice numbers, but I don't think this is the methodology to use...
It is more representative for the workload's working set to be > total dram and
therefore spill into slower tier(s), instead of artificially starting in the slow
memory and moving up. Do you have data for the over committed case?

Thanks,
Davidlohr

>(XSBench -s XL -g 238847 -t 64 -p 60000000 -l 34, footprint ~116.56 GiB)
>
>			Runtime (s)	lookups/s	Promotions (pages)
>base-NUMAB0		498.6		4.09M		0
>base-NUMAB2		422.4		4.83M		30.5M
>pghot-hintfaults	329.6		6.20M		30.5M
>pghot-hwhints		109.2		18.69M		2.7M
>
>Same amount of pages promoted by both base-NUMAB2 and pghot-hintfaults but
>runtime is better with pghot. This could be the benefit of async batched
>migration showing and no adverse effect of losing cache locality.
>
>pghot-hwhints shows good results. As I said this is just a first peek to the
>experimental numbers, I should have more concrete numbers and conclusion in LPC.
>
>[1] Kmigrated -
>https://lore.kernel.org/linux-mm/20250616133931.206626-1-bharata@amd.com/#t
>[2] IBS Memory Profiler RFC v0 -
>https://lore.kernel.org/linux-mm/20260924062206.319314-1-bharata@amd.com/
>
>Regards,
>Bharata.


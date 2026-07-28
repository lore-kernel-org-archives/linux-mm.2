Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB5E1C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 16:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F0A66B007B; Tue, 28 Jul 2026 12:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7DF6B0088; Tue, 28 Jul 2026 12:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BACD6B0096; Tue, 28 Jul 2026 12:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF136B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:55:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFDF5A0406
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:55:46 +0000 (UTC)
X-FDA: 85038787092.16.259AA0C
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3849EC000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:55:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nzriWRMo;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785257745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5JlP6ioUX+/TbxbJL0DU8jGeR7d++HxnQJa+9ff9G4=;
	b=ERINx1GOqYeNI9JQQ7uD2ZOIq2wsuc5OIjDW5VA271c9+jp38eD7J92v0dmCtyYO/5ShHj
	fPyCBrdIUYx3dcxArR0clAHH2GDLCB9w02xlqAKp+NtJJ/Sj1MWx3cC5LmK7Z4DJMbs1vu
	ZAS2323oXmPgnQHI8nLBoXuax5IrcrQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nzriWRMo;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785257745;
	b=AbWTe6JjEBm37HjVQcbziE8/Xia6XOMHJE+IYHITsGl3G1Iwtf5ZDlJJ17SmcGU1e75CKP
	eqR39MP9Ez/UVZDR7P4uiNSwd0ypQv3ZpYO3UqYjKHdjKy0HBIT3frzu1LQ13juPO3NOdC
	Um4SGHh/uzqEUTkGhtQFP61cm2oKHkU=
Date: Tue, 28 Jul 2026 09:55:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785257740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r5JlP6ioUX+/TbxbJL0DU8jGeR7d++HxnQJa+9ff9G4=;
	b=nzriWRMoPg/hlP/vXaFpykit9EB3DnLvs8Agjmn21AqnYWpvMInnIAWS8vM5GTeHOWuVBA
	GIjg2BePJN+1JkLrhCPwC3yKVQVWuo3/+KZhKYvXxcAsZnmqH6tLTUSwLSG+LlT3DPP9f5
	EG9bfe3zO9W22+H2NrI3/c7wWCR0gro=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Darren Hart <dvhart@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, =?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Yosry Ahmed <yosry@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Nhat Pham <nphamcs@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Robust futex causing memcg OOM storm on exit
Message-ID: <amjeUV3dAn7KPQgK@linux.dev>
References: <20260723001908.4046643-1-shakeel.butt@linux.dev>
 <amds50dIVOiQNz0k@tiehlicka>
 <amd6N4DVzZkl90cs@linux.dev>
 <ame7Q-0eVRrtt34j@linux.dev>
 <amhZ645Nhj856JfO@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amhZ645Nhj856JfO@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3849EC000A
X-Rspam-User: 
X-Stat-Signature: a5akubkimn8pqqdkmcraitcqk4caurud
X-Rspamd-Server: rspam04
X-HE-Tag: 1785257742-256273
X-HE-Meta: U2FsdGVkX1/dFjszuhzVLkT9q+v6S6YfJf7SJYBytWyr5w37z2Y+emp1GuPD0jSy6eaHzLJjUfhx475u8UmxkRyy8EsH8xrhAY4HnVdld0Ld1lwwEgYMKFLdVZRHWeuS3/IY1Qs95AaD8/Cu6ma4E3S1TmF3vB83U1uT7uhbLAZxhI2y9lJAhoGEcX3blruLFR/FSkaGKJLfv8+SLKw+dt7NtPaATXCUgmHjjBP3BTvyVjDQZpiCaqEcukFsf9ZQ+qm0OYgUJloxDVQ38666rHJTv9U9YqsACBWNl091QcpM6KlTeNbM1pUeY3Fa3ycRtT4IsxY+1VyimC2oLHkXZANrEZo4VSk+9VV9cECpvxDhdBlYaUfzTvX5XuKwbkqC1j15xCrwadDAMK/FKklEPA48k4CHpEVNWGV1aeyoaZMQfECVHN9BDxGScf7oQzCh0SSqBxO90sfFGyOJSiGk2QlcjaqEDaGnblPTjh+ofco2D0W0kelM83AfS3IzY8lt5hSQWWPC7CDJsyxhu1P4s9KQltKTBoWoIZlV0xQF57dZFB3kgNcq7a5T547f3NDhO3NlPnPQyco6ARjLGZ1Xu0ACLR44ftdW48idTwuD6ZUQYhtHsIxSmM3OsyrmjOsbteMC/XmrvVGAQjnkx4+oygvKxJtz3wiemNZvprPhpPnFY31RKMCmP+YdfydGH+NDEhY5oZ/8fgeL/CCAEt+KKpZwH/PpfU8hkGUKJe547FBcDSm8hL87DO58xdf1mIDzEh05SrUAb/tKyXOlHUAR0df2QZNqp1xKaZqk5VebTyiSaiWIixrsB8NY20jZgJJlhiQkEl9YA9EuiAXv538lhKtStf2jpWazB4D325g++Eku+2MV6+lDZcNj4MS+1PjihJNIl7X/piDrxcGe1HWV+H2Ri61n8w09F5AMTdit7hYm90T7s29YCtdO/YKPAVux3JYYOt7cCrIt3FDybiQ
 BhlVBPsc
 nDOwk5lbBT2ZToBusNKVbzjFiFmvazHfVugSOy2l4V/Dux5GRRRDfUM830SdrttG5zyg+xMqqN6t/tp5+33ZP3DaysLA/PMjlQKvSRLtXceYuplvf3nbVOOR3jafEdGpu7NrAoKgkI0Hr6HthIH1wUVWY80NThsnWaDTi4HmcAF8N/C6sReSXHzuZzpWjsHcNNTTIIfzvSslsukS7d9deaNgXtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:27:39AM +0200, Michal Hocko wrote:
> On Mon 27-07-26 13:48:58, Shakeel Butt wrote:
> > On Mon, Jul 27, 2026 at 08:38:37AM -0700, Shakeel Butt wrote:
> > > On Mon, Jul 27, 2026 at 04:36:23PM +0200, Michal Hocko wrote:
> > > > On Wed 22-07-26 17:19:07, Shakeel Butt wrote:
> > 
> > [...]
> > 
> > > > 
> > > > TBH I am not entirely happy about this approach. It effectivelly reverts
> > > > a75ffa26122b ("memcg, oom: do not bypass oom killer for dying tasks").
> > > > It just makes it lockless. Assumption that a dying task will do so
> > > > quickly and with bounded resources has turned wrong on several
> > > > occasions.
> > > 
> > > That's why I kept it as RFC :)
> > > 
> > > > 
> > > > On the other hand I do undestand the contention issues and I can imagine
> > > > that the existing solution doesn't really work well for huge thread
> > > > groups that all end up lining up on the oom_lock just to learn there is
> > > > nothing really killable anymore because they are the oom victim...
> > > > 
> > > > Would it be just safer to bail out only for oom victim threads. This
> > > > would narrow down potential runaways for oom victims which should be
> > > > more limited than any killed/exiting task. It would also give the oom
> > > > killer/reaper chance to work. WDYT?
> > > 
> > > I will give the following patch a try with the reproducer I have. I am still
> > > improving the reproducer as I am still not able to recreate multi hour slowdown
> > > yet. I will report back once I have some results. 
> > > 
> > 
> > I have some results with the reproducer I (AI) wrote.
> > 
> > Setup: 20k threads, each with its robust_list head on its own page in a
> > large anon region pushed into a zswap pool (writeback off, so it's
> > unreclaimable and pins the memcg at the limit). On the OOM-group-kill
> > every thread faults that page in futex_cleanup() -> do_swap_page() ->
> > swapin charge -> memcg OOM. A separate thread holds mmap_lock for write
> > in a loop so the oom_reaper can't reap the pool -- matching the host,
> > where the reaper was blocked and the memcg never fell below the limit.
> > 
> > I tested on next-20260726 as baseline and then tested your suggestion over it.
> > For baseline ~48k no-victim OOM invocations serialized on oom_lock; ~40s to
> > drain the 20k threads in a VM (hours on the host, where each invocation
> > was a dump_header over netconsole). With the patch the dying tasks stop
> > entering out_of_memory and the storm is gone.
> > 
> > With the following suggestion, the threads of dying tasks stop entering
> > out_of_memory but the exit time doubled as each thread has to decompress the
> > page from zswap.
> > 
> > 	if (tsk_is_oom_victim(current))
> > 		goto force;
> > 
> > I also tested by replacing goto force with goto nomem and the exit time halved
> > i.e. ~20 seconds. Looking deeper it seems like each thread is still going
> > through the reclaim loops.
> > 
> > Just for testing purpose I moved this check along with goto nomem just before
> > the reclaim fuction i.e. try_to_free_mem_cgroup_pages() and the exit time falls
> > below 1 second. I think what we need is to detect early that the cgroup is
> > unreclaimable and the threads of exiting/reaped process should just return with
> > enomem.
> 
> Do you mean, something like this?
> --- 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..66f1eebf8c22 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2648,6 +2648,18 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!gfpflags_allow_blocking(gfp_mask))
>  		goto nomem;
>  
> +	/*
> +	 * OOM victim still needs to charge memory to exit. OOM reaper should
> +	 * help but it might fail on mmap_lock contention. If the victim is a
> +	 * large thread group then all exiting threads might compete on oom_lock
> +	 * just to learn that there is nothing really killable anymore. Bail
> +	 * out early and fail the charge to expedite their exit. They are
> +	 * considered fully reclaimed by the oom reaper and they shouldn't contribute
> +	 * further charges.
> +	 */
> +	if (tsk_is_oom_victim(current) && mm_flags_test(current->signal->oom_mm))

I simply had tsk_is_oom_victim(current) check here. I assume you want
MMF_OOM_REAP_QUEUED in the mm_flags_test() above. Do you want me to test with
this additional mm_flags_test() as well?

> +		goto nomem;
> +
>  	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
>  	raised_max_event = true;
>  
> 
> -- 
> Michal Hocko
> SUSE Labs


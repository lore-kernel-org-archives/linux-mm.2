Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A463E9A77A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086276B0089; Tue, 24 Mar 2026 08:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0369D6B008A; Tue, 24 Mar 2026 08:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8EB66B008C; Tue, 24 Mar 2026 08:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7F656B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:20:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8950FBF6E0
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:20:07 +0000 (UTC)
X-FDA: 84580863654.08.1233515
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B649D40010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:20:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E176/AhE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774354805; a=rsa-sha256;
	cv=none;
	b=jc07ll/TzbPBI0A2DJmKlRATurEVfoWmydUfs7KMN/npIuqTgfDq+CG6b/qyn+DP83o1B/
	vJIzEXhTMOM0bGSpocwDcHqhBOvcxxqrWQPxzHb0bfKharnwZ0MaamZYmOCdDc08+QQkpo
	YwGsFAmMPmllVQJV9cTnFx8tpx+9+1g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E176/AhE";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774354805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEYdWnUD2ZPVDXYs0LwGK118K8x9BhLsK6qjIHtqfdw=;
	b=pfFXI5GPd5LGEkT/lFU/GKgOPcD1D6mhaW44Z7/tGKIlsCg8dKlFB2JVkaxfY5kanWlYYI
	zkrs4Kn0D3OApHqTiEW8njpXWPW0aPjzaKj2I06brCiEgOjEmDCRTPFDwR0UZBWop9jwym
	YImP0G8ap4SLtOoSMU0bK8p8MMWr/54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 833F2407BC;
	Tue, 24 Mar 2026 12:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4B3C2BCB1;
	Tue, 24 Mar 2026 12:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774354804;
	bh=nBpcshDUXGsdJq19WufZSbR45lWJYXUT8cWL/8Uyqxg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E176/AhErzCouvY3ETmgNShe8DY3jmhd2QAAePt1i+d8smXGBpjT73b+WJ3HX8mTx
	 W+7sIromtOyZ6uD6pJX+avK8yrfPe/G+8jjRTQ6pkYoVho9fXlNnmKUykIbnTLkO1O
	 O+UeQGhB49v0Ibm+X+oogwRU5Dh9ehpZui5UjS+jP/8pe3zjbvP2K+l1iG+h38j1E4
	 b1ExbsQO2EyJ39LjR9jyzBvQjifLZYFQRqZs3rRyIplBFd7Z0sfVFUGw5o3GjOGCmR
	 C9Cu1ccXhRPQ95nqNOOgvXks0UkOEqIdHWk6UdR1CxV/pzOEsG2A0X6nsLmjQwc0hQ
	 D1aY8EKqE6OoQ==
Date: Tue, 24 Mar 2026 12:20:01 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 1/3] mm: memcontrol: correct the type of stats_updates to
 unsigned long
Message-ID: <095a503f-6967-45f1-99c0-03d4fc3baf0b@lucifer.local>
References: <cover.1774342371.git.zhengqi.arch@bytedance.com>
 <74022705dc8d5209ff7e603a178044fe4cfbae09.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74022705dc8d5209ff7e603a178044fe4cfbae09.1774342371.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: 9otgs5oq8z3srb5cbxnwf5auaxoie4uh
X-Rspamd-Queue-Id: B649D40010
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774354805-140882
X-HE-Meta: U2FsdGVkX18H9rhrzcjjC9GBTqEdsQvcrkMYxWxyjdbFYl8pGNkYnnTkfWLFsvayd1M+yB4OpSkIWUFoygTO8Hdj1Bi3/3NDOh/TcyBV8uOZOynhrkeTrAq73ZMdH1oz4GAyL++7xG7pgXV+akkYIPqZk6b4hzb75dpnA1klY5If4BigdhXtiXFW8omwApsWvn5F8Cn6J4G4qjvdYf/AbDDX1vhW55guK4gyUudsDdbxtiVMjXmYTlxXK7ZH90GuHixqvBn45oonrTPiBPwCrUkR5hw5/rGBpTPqRdfuuNqi1+uSykU653amEfYQNzDnVL9uLxLtOItAbtNQ1ahcd7v+L8XvdgWtCNtGOdQxyxKAq7q4q1tBwITyFsZJNDr9ADrUZEwV3QrnBVypkYD/r/BfnfzcBGiASDNTOY+FBs88LOi4fziN9+tmU3TCrX6AG0Er7EL7IXUSDXjNgXtCQGDsdotv0FNZW+6yrvMJQJU6UYc65bohCOzKAc8jtDmRAXreKJdgNCbKFjNMX/32SWs31iheuEjtUYBUex9uCtL8GwGcJzrBodKbtdxcJFzauNFyNd6RfPkQ5x3fONwkXAe1+6k+lVesTYA9BaIg+FbmDIWQvwBg6G8DT43xyrjKmTERivgGXI9cN3cba/ChrU1CiKvtVtU78KSqjCYnFpiicZjToTkv6bOxN5zP5aplEu1pd6BQUAbz+/u1HoShmm//PIUs3a4T7FLy3yXHGmLd8D4Z3YQEYqmyAc8bI35rMP7w/h7v/rkM09eA1ATpHhsE7qNudIGKuEha96dobWqKfa0w/X4IZKB/EcDkP5nuNqnwwkK1ehM7tuGEVQCs0HNh8wwMMge+qxvkCGOp3sI8+IMAc2yTtVHtIaST9atvdez494BYgC+2V1KPnkZgmhOQtU/by3PXhySJJwrdMopEHjwlHBIVo8MfMLzVkiqxf95SPgcnZ1ZzodHOklI
 AsyjWQJX
 UKo6JqlQK5YZ//hBmGweAIxfDkX35gw5BXfQ5IlFiI53DIvRTG3Rc20kJ4RKRM7yWz8D86nPD9xSglAeKdnixgU074fnKpm+so970X5SbNGdxLTRKqIclBa4qO5bmaGEH9orJmGIB/cZ/6LY4fymk0JZpnU8cWkQsPc/CuG09J5PKPas9c82A0ekAkRWH1+BXnXY/Nj5sUbKVqE4nN5zm4vZEAXoAVnlmdccvsLvqLDaF0XU17rwlCSNn5P4YyRKIQEyi1b7LlfmsxXpxQsFU1KUB8M4RVZfW247GkP+QvpJssNhTk4IJtm2IW03eN8CbT1D8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(-cc old mail)

On Tue, Mar 24, 2026 at 07:31:27PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> Now, the memcg_rstat_updated() is for vmstats_percpu->state and

Now? Did this change? If so, please put commit here in commit xxx ("blah")
format, I don't want to have to try and look it up :P

> lruvec_stats_percpu->state, which are both of type long, so let's change
> the type of stats_updates to unsigned long as well.

Is this a bug whereby before this could be overflowed?

Or are you deciding to make these long now? Because it seems that are
proactively making this change _yourself_.

This comment message needs a lot more explanation.

>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  mm/memcontrol.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a47fb68dd65f1..7fb9cbc10dfbb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -608,7 +608,7 @@ static inline int memcg_events_index(enum vm_event_item idx)
>
>  struct memcg_vmstats_percpu {
>  	/* Stats updates since the last flush */
> -	unsigned int			stats_updates;
> +	unsigned long			stats_updates;
>
>  	/* Cached pointers for fast iteration in memcg_rstat_updated() */
>  	struct memcg_vmstats_percpu __percpu	*parent_pcpu;
> @@ -639,7 +639,7 @@ struct memcg_vmstats {
>  	unsigned long		events_pending[NR_MEMCG_EVENTS];
>
>  	/* Stats updates since the last flush */
> -	atomic_t		stats_updates;
> +	atomic_long_t		stats_updates;
>  };
>
>  /*
> @@ -665,16 +665,16 @@ static u64 flush_last_time;
>
>  static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
>  {
> -	return atomic_read(&vmstats->stats_updates) >
> +	return atomic_long_read(&vmstats->stats_updates) >
>  		MEMCG_CHARGE_BATCH * num_online_cpus();
>  }
>
> -static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
> +static inline void memcg_rstat_updated(struct mem_cgroup *memcg, long val,
>  				       int cpu)
>  {
>  	struct memcg_vmstats_percpu __percpu *statc_pcpu;
>  	struct memcg_vmstats_percpu *statc;
> -	unsigned int stats_updates;
> +	unsigned long stats_updates;
>
>  	if (!val)
>  		return;
> @@ -697,7 +697,7 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
>  			continue;
>
>  		stats_updates = this_cpu_xchg(statc_pcpu->stats_updates, 0);
> -		atomic_add(stats_updates, &statc->vmstats->stats_updates);
> +		atomic_long_add(stats_updates, &statc->vmstats->stats_updates);
>  	}
>  }
>
> @@ -705,7 +705,7 @@ static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force)
>  {
>  	bool needs_flush = memcg_vmstats_needs_flush(memcg->vmstats);
>
> -	trace_memcg_flush_stats(memcg, atomic_read(&memcg->vmstats->stats_updates),
> +	trace_memcg_flush_stats(memcg, atomic_long_read(&memcg->vmstats->stats_updates),
>  		force, needs_flush);
>
>  	if (!force && !needs_flush)
> @@ -4406,8 +4406,8 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
>  	}
>  	WRITE_ONCE(statc->stats_updates, 0);
>  	/* We are in a per-cpu loop here, only do the atomic write once */
> -	if (atomic_read(&memcg->vmstats->stats_updates))
> -		atomic_set(&memcg->vmstats->stats_updates, 0);
> +	if (atomic_long_read(&memcg->vmstats->stats_updates))
> +		atomic_long_set(&memcg->vmstats->stats_updates, 0);
>  }
>
>  static void mem_cgroup_fork(struct task_struct *task)
> --
> 2.20.1
>


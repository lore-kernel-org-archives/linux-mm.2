Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 615A6606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gICNuPGD
Received: by kanga.kvack.org (Postfix)
	id 85C576B0A03; Thu, 22 Oct 2026 18:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80CC46B0A04; Thu, 22 Oct 2026 18:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D5046B0A05; Thu, 22 Oct 2026 18:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 518526B0A03
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:50:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D89F21402F4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:34 +0000 (UTC)
X-FDA: 85351757988.27.3FDBA5A
Received: from mta0.migadu.com (out-242.mta0.migadu.com [91.218.175.242])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1F78C1C0006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:50:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gICNuPGD;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792709433;
	b=dnvm9DjRQ+MdUFmYQ10xiK6nbLlNq+v0+dpOdiSipFDBMOQvJELtvabO7REZAbGcovDwsN
	aLOrQ9zvhXGEKix3/t45E07so5DefqzPAOXuUY9nOqAeqIYWoZ4yJX3tW7rCLa9Wl8ktY3
	9Tgpfrh4wiBMgn/jSiqOPDxjaaZT6xI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gICNuPGD;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.242 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792709433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8US3Njl6hx2/4kDUNZ/BNMckCrpYecKlAGjtmzYsKE=;
	b=2q8JuPD27OZEEBVh7KatQ4rgE4GfDX7A4+WsYiASheeruQpA+nUbTLyT8viWacKz48gq6N
	Oo6/K0BZs6bb79V5vAsWDrO9ZzCYXI3ERMQlGEZ3VXEMyb4SEM4vl+HkQp4GoAsEBua6YB
	SOSLDkcVdEYnrNyKbGyXj0s8uNx5DOc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z8N3xcKMxNTi1EWBslKB7dxo6vt+jRhpNiYdPAZnB1E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792709428; v=1; x=1793314228;
 b=gICNuPGDvueeF44RY5rIv2l9hF5zKz+KCTLb6vuE0E1M69p3c3zi5GEx05f6N4OepHg4ZaaZ
 CZ30RwxBX4cj4gjwC9Q+EtY5I3Mr/L0X04alkEpS0N4DsbULeGR1C39TSZlVLKOenRymIqhAeoC
 AIv5MouwP6ctDNGUnB2xIJxc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ea09b4d72e656f1e;
	Thu, 22 Oct 2026 22:50:27 +0000
X-Mizu-Trace-ID: ea09b4d72e656f1e
X-Migadu-Flow: FLOW_OUT
Date: Thu, 22 Oct 2026 15:50:22 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] memcg: reduce cacheline contention between lruvec
 stat updates and LRU lists
Message-ID: <atqSu4oxGogRaWSn@linux.dev>
References: <20261022223930.138779-1-joannelkoong@gmail.com>
 <20261022223930.138779-2-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022223930.138779-2-joannelkoong@gmail.com>
X-Stat-Signature: 5j911knhkrtzjsm4nd5zrus8aa9srzei
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F78C1C0006
X-Rspam-User: 
X-HE-Tag: 1792709430-637578
X-HE-Meta: U2FsdGVkX1/zIHJ9mY61uoGQBm1JquhrmRHs5U5vhSlhvV0ck5XXHxHMryzIApmQQMFNWi1CCeA/YW85C9MXv6Mfq1iXtVZ6UG/d8LPO/WzRRXrIEbQbevfwXKetU2a69SlP6vKTyULIpRjp72k5zhATlYI6DUxVUOClxCQZmeClMseVfCeTyiOPLYWipRa7KeZlcP39MSEXZ2jCafhNZx7F1MUNKob+KSbFtDt3jSLmk5EbjgsAjlB5ll0WWe4GKHh6eQ121NEXSNRUzjIHRdTpI+MdYrXDexTHoFmSxK5A+0yOag5100nuGHoz/qOTn84TcHGr/jL3mgNzTBs8GCNxZ7wJKLDphe05bPF34YrZp+eKB6bs1JIQWF8cAHTEQdT3B8sITDKPVr1PyoVb58aFpMQn4hNsJXp7xwM0nWWlsRFQ30o6WCaqjXY7eO+5kJJEBMZ/ZWqDWICwAjN6Q0Bc+v8CqvXvreYpeSU1iGrM3dDOXmfRSK+aXuV1xcgeI/wVppzMRYotSPxFOA8R5HQdTAuCqVM+Z6OFFWtViq3N5mnOe63GHslZDHnUk3Mwg14pSHoFkTYtOemZejjMZC8KtwO6k2mkxbroxKNzzytHYU6pRdYuFpSeA7Arx2A2qSbRHNohR1lOZVkJM1hQgsIzTObCNxIcLiltJJdYOxWafmgLLmZylsGcNEBz5unbZ2OZgqT+8oFvREIFCk2xgrGyloZhOJakz69b/Za+IrXoWrSMf8oJNaNxLVNGvnOiF4uH4lXgvnccWj7JCHRPZ5jwQiQy3tGNjTc+qxJwi4XNviYoPCTzzfBrbXEONje/xlmVS8hmC25tCCacsyV4nrrkU7eAkqg9Xhb+JV8ecgg4KLuVJVvtA9m/ey3bc41GV673JUY15z/EF8jVmziyWdNLxkdsBHND1Agn2UU3JiRt/fvw468J+2Uk8gGUw1w5P4MHcl/YRZtxx75dr07
 q7QNYl1V
 PUJGdu6ap1zf+ZDQMBW0hZScuwJWGBkRVuS1yHMD1SWtZ32NzcEpJa6l0ZZYQ/gUat8J5Jc0eZ/hJsI+Fz/h8+q3mq7fjCLq28htNvUEDttXFNhwwm57550CdWLrs7Le6kd1zR5uyeABKl5QLD1sUrzwiGbTpnryQCSEqf+VdXc1cWTdS5ZZK6IPyybrbIUMDuW5kNF7BLeflyZRA3GbZj/jYmvqb88VRrmnU/iLnvv4/YBs0B0xJBI8rNj6gLxhD+nrpr7auF5UcDM0XcZhHYOxwnc5nNcEdIYqzEquuDF1O4BSc0eKgWJFEvruA0RlO7ByAr03nV+E2QTwA4IGPoZkXAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 03:39:29PM -0700, Joanne Koong wrote:
> Every memcg lruvec (per-node) stat update reads the memcg and
> lruvec_stats_percpu pointers in the first 64 bytes of struct
> mem_cgroup_per_node. These updates are extremely frequent (eg these
> updates happen several times for every page that's faulted in, freed,
> dirtied, or written back).
> 
> The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
> on a different cacheline from the lruvec, but Intel CPUs do spatial
> prefetching [1] and fetch cachelines in 128-byte aligned pairs.
> Depending on where struct mem_cgroup_per_node lands in its slab, that
> cacheline can be paired with the cacheline holding the LRU list heads.
> 
> When this happens, every stat update also pulls in a copy of the LRU
> list heads cacheline, which is written to constantly by other CPUs under
> the lru_lock. The stat update has to fetch it from another CPU, which is
> unnecessary overhead since the stat update doesn't use the LRU list
> heads at all. But even worse, the lru_lock holder then has to invalidate
> those copies and wait for the acknowledgements to come back before it
> can do its next write, which makes the lru_lock critical section longer
> for everyone waiting on the lock.
> 
> This was found when analyzing the output of perf c2c for a benchmark
> where many threads fault in pages in one memcg. It showed the first 64
> bytes of mem_cgroup_per_node as the most contended cacheline (over a
> third of all HITMs and 5x more than the lru_lock cacheline) even though
> there are no writes to it. A quick experiment adding extra padding so
> that the cacheline no longer shared a pairing with the LRU list heads
> showed that this removed most of the contention, which confirmed the
> cause.
> 
> Fix this by moving the memcg_pn_cold group, which is only touched when
> the memcg is reparented or freed, right after memcg_pn_read_mostly, so
> that the read-mostly cacheline is paired with the cold cacheline
> instead of the LRU list heads.
> 
> Results from a multi-threaded fault/free benchmark in a single memcg,
> run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
> pinned to CPUs showed average pages faulted in (and freed) per second
> across all threads, over 7 freshly created memcgs per run:
> 
>                      before    after
>   shmem, 20 threads  4.74M     5.59M   (+18%)
>   shmem, 80 threads  7.94M     8.66M   (+9%)
>   anon,  20 threads  3.04M     3.08M   (+1%)
> 
> [1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
> (bottom of page 62/800)
> 
> Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/memcontrol.h | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 69e1bcc67c58..69ed283f7db9 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -95,6 +95,17 @@ struct mem_cgroup_per_node {
>  
>  	__cacheline_group_end_aligned(memcg_pn_read_mostly);
>  
> +	/* Touched only when the memcg is reparented or freed. */

Let's add a comment here why we placed this block here. Mainly about the spatial
prefetching intel CPUs do.

With that, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>



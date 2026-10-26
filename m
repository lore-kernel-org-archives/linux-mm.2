Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11382606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=dHoE5g6G
Received: by kanga.kvack.org (Postfix)
	id 2DD356B05B0; Mon, 26 Oct 2026 05:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267506B05B1; Mon, 26 Oct 2026 05:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F976B05B2; Mon, 26 Oct 2026 05:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF8A96B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:29:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5438C067F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:29:44 +0000 (UTC)
X-FDA: 85364255088.30.77BE3A1
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id B7DAC40003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:29:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dHoE5g6G;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793006983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RsawiG6L+7MbIfpDDEJd12nG5n3sYWkrFkopCA9f4hQ=;
	b=DWW5hLH2mVM+fmhYUEcB6QtJKBmpTp56TO09sAQoCmKQFLUmbu5zC0TC5xUd2uayLaB/jJ
	MgcdDLwwt4VoosHHUkeB8dtkhnbhrD+S4iuvfpD5zOVKyJ9Cn9G2O1hL5Rl2hEG6iNOAy8
	xnBCs2N8Or7+W86qoaqs7lxy8h9CXF0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dHoE5g6G;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793006983;
	b=kh++K1UNnKQ2I4ge/McPyfGnQF8ZNSIsnTVNAp4kMz7iXzOwaeOV6tvHWiSFVUbDQwdlhX
	I2HIG8gmtNje6o7xdd6TW5mHlP3hTHNMBYC48JrOdsbGm4BbKlOavX6MeAMfEXTNoMC2tY
	kd9LpKf4c//xBPzsf0FxtOkBHHwhxhQ=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a549cd7fd2so8461015e9.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793006981; x=1793611781; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RsawiG6L+7MbIfpDDEJd12nG5n3sYWkrFkopCA9f4hQ=;
        b=dHoE5g6GgnktKH7Jr7TGF0MI4qpqRb+R/+Rl1OCk3Wgt1dqrJgxMTaOsrHaTr8iXrX
         YSrYJQlIuQbvZPjPjislFG6TI6nOfNPaCNz4TkOQvZYmi7gY1MG9Vd8HIJ/ZRU6Egbud
         12owTonZ011iOJWaRCVucoh75Sx0dbAYBW1swxniZ/e++Dj/eXcwfwJpvMLMHwuOd8I4
         JuSapamDwIMoARqGtGUgi2R7tkDPvGKuoYcLEaINtZjdnwRNHxLT8JA4F/Eb5/5PtLQr
         FmScGMbCyPenHA2D9avG/gzNeGGAfoV/hQJBiXJnWKWuGk6O0TUKeHdyPVebNBcX4EMd
         8ayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793006981; x=1793611781;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RsawiG6L+7MbIfpDDEJd12nG5n3sYWkrFkopCA9f4hQ=;
        b=W5FB0u2AcUufbdX1GhhR/zGsV6ATgEcVxFIXyRI0twAy6fc+0cHCdcJfjTS+aerxvT
         G0gkggrG73qqSNAMw7fqSh13y5+6KxtUTkxQywOeIzYfOIXFyz2rYONWYMYTA89gR5ZF
         EeSHQ9uz2zM1XS8outTts0wyZnWIXYU8haAZBb9ejOrtuYtIlJzJfmsLYZdJl+Rjc2Yx
         kaifcl9KSxZoK0X17TIhBfgPbz/q9mWMKzysAdFGLaWaCyXuUkOzbQbmgTUwErWv5DzD
         CAPrJdIzdRzUn+ZGaZo6FEonMvwpzpuahcbQ+N0/k+K/JIBrhyBOy3ihQtIyjSW4XAKB
         knQg==
X-Forwarded-Encrypted: i=1; AKwUvBxBxFKvuz5yJrQWpm6tZUQR0W8sIwtoDE5VEVvrp7A+zF+h0yc/7AyJLM9bwBKK4dsWaWrdWZs8og==@kvack.org
X-Gm-Message-State: AFq9FYLaYUrhoOwoMf9/VsUC1NFH46NnJRtYmYt+xkROuoAJZLlM0Ohp
	YCJNTKzaFXzu43tXoHF07e6ec87j+DU3ohxsbszt8otpgVPsMVqO+IdB+6UJplYm0+o=
X-Gm-Gg: AYBFou3/p/IkA67xJ6i/Rn17MUaG2vjHCBx29H7uh0fTnCmwnfkiDuNbSbM0G02Ku8r
	OCbqEo5PE+6oBeNckOO4aGQi2DbowI8xN+8o2WaVpltflZZKbMT/eVtH01aUM2kaDyvuRSA+OO5
	cEXc3mZe7qgsrkTgT7+el/AhiJmPn1wyXk0sCiAnKEyJfXXCV5ykpbDpQO8Z1txfZO1cqcioXRg
	LzhFG6IS0v3Y6XqvaQEcyOC0fWDS4msn08dzVrCfEHZiH6xVF2zkuiVjwLsJ1W9TvIvg3Et6iCS
	66XFWfoS5Sp9BlQWrc9SE30SX1/nOkn51rKCFPKYBnYFjIlJzorV4G4sQdYyLrT7ffbGp70+Ran
	ZcQljAVkzAoQCYHmTvCquS064aBxFYeRJJZhwvBK9t0sEIWlUUnV0UbT34yUUCC0K95Mht7I0km
	ylNxvBAGoXIlci886E6U2egZaj1QcQO9ej/Utn0T2zZszhBiX7UkoXyYYgLlJ5yW5Xq3lnykgGr
	4WhtTEksRfRcyA9P8zXLGAfMQMi8MePfAOgl4RIysBWzklzFwlLvqPDtQdT58xFgsZphg==
X-Received: by 2002:a05:600c:3e14:b0:49f:c5aa:9ef4 with SMTP id 5b1f17b1804b1-4a35ae8806amr117990415e9.8.1793006981265;
        Mon, 26 Oct 2026 02:29:41 -0700 (PDT)
Received: from localhost (109-81-20-177.rct.o2.cz. [109.81.20.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a08dcbfsm122433365e9.2.2026.10.26.02.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 02:29:40 -0700 (PDT)
Date: Mon, 26 Oct 2026 10:29:39 +0100
From: Michal Hocko <mhocko@suse.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/2] memcg: reduce cacheline contention between lruvec
 stat updates and LRU lists
Message-ID: <at8dg75u4qmQKZ9M@tiehlicka>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
 <20261023195417.1391216-2-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023195417.1391216-2-joannelkoong@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B7DAC40003
X-Stat-Signature: 1z6tbapuferbf1nfx1zdbfnisiem5k9e
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793006982-768434
X-HE-Meta: U2FsdGVkX19RNn69iGpJ/INvvf2PfFmimZTLp5qLVCO9K3fYT/6ntXYLsl9wRIF1zPZrV4+8mnF/gpeo2J4y48v7mA+rck70Y6erKiXselintFze9UDqLofhttXZ3Ka69pi+cOpWnKtqH/TK6jFVvne4YxeGd3s23stTvu4aM/CL2hRg3O5yFy74w0VIQYMuBPX79DQ/JdoJ7GjRny/LcUFe9R84d8/iblB8JHNj9Cs+TQai6V4jTNz4LryC5XZZemK9cSfPK7L9HYgMqzMutUxKqK/Ju+cx84RJRm9SI43GhWwlyD5K0ZH9HMoENNnmZpRLvtX+XAgYLirpEYOOfE9t35+UOlg1wkvzXigppt0uK/LfRTnLPJfh7pS/jFvnfQiijkDMc0MN0cDnaehFvXgY59JkcbMr00SGj9NQircAp/G5ZRCq0f7pojJzD9i0iKjc9l1t25SjkZ8r5Wr/V7oeGR6OfRbyVPzm4fCDabD611MdiJh0qHRE1M0qHyJz43BukAW5eP0JzVFz4DVImv0KSOF+dcpkCxcQmb6x6FdzSvfg87omxs3ReI/RAUfnbJ52xEc6G1gAUXBG8i8akKHqDbXkyX2k+giYepyDxcKeFcL1ubDVkA4lZWV2gpKY4SXwxUgk0oZQXjV2gt2/LJnWCxj2wxlf7eMzgdcoryNroMjZZcW31H1K0npqW5TShKTUt+lcUl4KscMj2gAdUC4mk/SrwK2wZhcpjKxYm/cgUkQh36OT2J21W0ZNB477Yxa5encY3LLFAJvYup+s8HOucV+F5BatbTacFCB0ZcyS+c0KUWmrTJRLKBNmbPmNGDr9eNbDcD2FoG6YOedHi+StvNEIyNgGcyeKpakotCg4TR4UzqUyr3GsITk+ZXivLdHCgXUI6X8c8LCfQjViGtlCeQ2I0K37A7OdizRUxZRDkspnD8w402kgmwcuN4w3RONsq4UMxt9KA9pJAe2
 s7nVIfMO
 0cWxzBAcGNrcRQinECA6izL/MgAcxLAgPM8vMWEbMcCDJW6RK7MFCw70w00PLhVI/WRff4YxdxPZ5+jA06QIYA7R6bU+T9btV7qf2WBytxPt3qEE2aXqnFKX9Hy9cilyzL2GDvnOxvuagbgv0sxtLNZL0/ORO7zeqQXZSphfKL0h9xDcWKdJeY8K47PPsCk33OLPVqdFPT8u96FVysijdAtIJq8o4bCxEDThthV1Cj9sExBUW3kmkIF10uWJsilB4sz4QGjUVPPpCjZhNh7xSxI5+5RqY9E+ekNgRNjw6M4U9Af4Dvt+ul7okzuWV3/CCCoSHDubUzZf8UJQNj0cyGCfdcG71AGauBkjzl/wm/kmpRH/E5NortxtMR3+xc2/hLFxoI5q8hPuNfD5wgnaxjsvY5pyXmX8jedHRI/cIvE2ecTRcZw1dOeFBhY0EmZwR8gQ/NdcTxMzPdg+YSMoMR+8UzJ2cPW0olnRBZL9KijhgsJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 23-10-26 12:54:16, Joanne Koong wrote:
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
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h | 29 ++++++++++++++++++-----------
>  1 file changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 69e1bcc67c58..6139195b7fa4 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -95,6 +95,24 @@ struct mem_cgroup_per_node {
>  
>  	__cacheline_group_end_aligned(memcg_pn_read_mostly);
>  
> +	/*
> +	 * Touched only when the memcg is reparented or freed. Placed right
> +	 * after memcg_pn_read_mostly because CPUs with spatial prefetching
> +	 * (eg most Intel CPUs) fetch cachelines in 128-byte aligned pairs.
> +	 * This keeps the read-mostly line, which every lruvec stat update
> +	 * reads, from being paired with the LRU list heads, which are written
> +	 * constantly under lru_lock.
> +	 */
> +	__cacheline_group_begin_aligned(memcg_pn_cold);
> +	/*
> +	 * orig_objcg preserves a pointer (and a reference) to the original
> +	 * objcg until the end of life of memcg.
> +	 */
> +	struct obj_cgroup	*orig_objcg;
> +	/* list of inherited objcgs, protected by objcg_lock */
> +	struct list_head objcg_list;
> +	__cacheline_group_end_aligned(memcg_pn_cold);
> +
>  	/*
>  	 * Keep lruvec on its own lines. Sharing them with lru_zone_size[]
>  	 * regressed, see commit f59adcf59332 ("mm: memcg: add cacheline
> @@ -114,17 +132,6 @@ struct mem_cgroup_per_node {
>  	atomic_t		slab_unreclaimable;
>  #endif
>  	__cacheline_group_end_aligned(memcg_pn_write_hot);
> -
> -	/* Touched only when the memcg is reparented or freed. */
> -	__cacheline_group_begin_aligned(memcg_pn_cold);
> -	/*
> -	 * orig_objcg preserves a pointer (and a reference) to the original
> -	 * objcg until the end of life of memcg.
> -	 */
> -	struct obj_cgroup	*orig_objcg;
> -	/* list of inherited objcgs, protected by objcg_lock */
> -	struct list_head objcg_list;
> -	__cacheline_group_end_aligned(memcg_pn_cold);
>  };
>  
>  struct mem_cgroup_threshold {
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs


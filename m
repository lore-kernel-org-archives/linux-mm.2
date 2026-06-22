Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E5BCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45156B0088; Mon, 22 Jun 2026 19:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CCB6B008A; Mon, 22 Jun 2026 19:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59F96B008C; Mon, 22 Jun 2026 19:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 851936B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:40:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED3C3120317
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:40:46 +0000 (UTC)
X-FDA: 84909170892.23.46A34A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 686AD40009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:40:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KeExKt/s";
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782171645;
	b=M01ewB1pfQRHjg3rfE0+1O5GZfgc2gGyrEjNJCC0UV8iDfCeEfO3bUjCicncFRGl2U53/Q
	F6u24H5byC4LdKQFyiitte3COek+tunq7rXYNM6q1rfZ3X3DArWYvu076LJnY8mSOR5eaC
	jbKi9pS2mExs+zUsybFmc/AVDe1zFKo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782171645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sv9Tq2vRtt61KjPpmgHARNzg92y5Jh8UgXbipP6SZQs=;
	b=tpAdx8/OQLSZl7t2p7T8eedO/sbHMGIB21q/lJuZvlrzsxArHY16TUmZmNZUVGD94/Xe97
	97E0LqBYat7oyHcgba2P0je9r0carNuBNP0ZATCYNzxiSW30xsAzEImYJ7/OKfXJSR/kQF
	WI0Eak/juOLH3j6wNhDN0L/qrnuUS+E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KeExKt/s";
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B29446001D;
	Mon, 22 Jun 2026 23:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39A41F000E9;
	Mon, 22 Jun 2026 23:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782171644;
	bh=sv9Tq2vRtt61KjPpmgHARNzg92y5Jh8UgXbipP6SZQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KeExKt/s0Md5O/braMSh2VUEZbCyQzb4H2AwXtoJsnepuNmEFxtyWflyUv5xSsLz/
	 JE/X20Z/0mruDLtWOVClcLNKytskY4fb7tY2dwipXhLObh4/6ng/+cuCo6NeXBaLFC
	 yCefmD64EHEEtZUK6frDS29L/EH8hlbTVmlJ3zG/R4xEVH0jzhjeXUDdCMRJ3ZFo/A
	 z08YizsJCBNQ/K85yU6+retrB+l/RIBgr/VrbyOBH9EF/+oVElfz8ntrc6oFGgwj/L
	 mU8fMtyGz9+UDMqro5W4wP0/cDb8H0HEaJ8ZqLUYTkrceG4HfZRsk9iFjsPOWoXeCo
	 3w3ZIfchpunzA==
Date: Mon, 22 Jun 2026 23:40:42 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v4 3/5] mm/zswap: Implement proactive writeback
Message-ID: <ajnHJhvWxeR1DbaP@google.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-4-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618044857.69439-4-jiahao.kernel@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 686AD40009
X-Rspam-User: 
X-Stat-Signature: z1fun5b3n6tr1w3hom7km3dnmggi1hff
X-HE-Tag: 1782171645-662687
X-HE-Meta: U2FsdGVkX19qUpGIdKiMCMK3i6k+SaCuBD/cPPKnJod88/tthpadIFETgNFBsXYENNwX/I8ZUGe8vnJgwniJxsZ/sG5dNK++hpY6//lW3I19VrNNTbyN59m9yzFzPOyK4W24naUxPJ12Rh0T0kPyUPqBeO8Kb9qtal3u3KlM2RpRg+3yJdeDQdC7y1vrvXcNTA9mGEno6rRQXz+xiktmlI2V2BlSlQeQ43q6KRb0kdkmFz0zwFzmd7YaFoydgNPCkViuZftSsRMgAPQmMOT3G69qcTxE/svF/CEC0GSwSw4lNBpzfh2WFRhcaWswVaYIRFGPss0mh8ychm31Unk7ywkHzJDNQeZaoBGQuLNEn5W5OnmOvat8d6tbaTqUv57A9+bmHHiMSveccTMq6UyKsn4hF7g6RDaL5uw/44j8+7r3AtxPa7k1sLSoNPTkyfb13vuXmiXrngFdFFHx6rQmn0NFc1QZ2F0Nf5y/PpT+wWBQx6+COG4fABJi4H/Ww5gIjO7QPSGR4X/zgBD9v4EMWL/6D2hwuGAZqlF9Q0mtRoT/+i/ULyDghwLVWjrSs/YBG3qXlBRw8USicj0WvrAd5jc0jIlez4oDIKTngRd7yiYuJdvsgqEenBuJ8P8MZinQYZ2such6kvA/OEmQAgAzfhzI0A8wkFlaj1n4gFbyUG/Z7KcLTxck97entlZzWWHkzup7Apu6qsZFwGa3rpt3yyccERMIIoRFEbuXdWmsha/F2kEBFiShwwzdNM0fzE4wz4Pv028tZ1f1eE/+K35PZiXVyfLGiBq62OmvNXPL6Uw0BAHk1JT58OlkH3W2U3VH4RjqpcyL9rGeaEtzEp7h0M8SuNix1UH4VSc2ANy+VSsEzD2FWlOYap87mwaXDXr5CJN11NwEBwyuGHnjubCPr/2hf2j29LW+nCXdCzhsplF1+5JZQLeGL+0UywhJ6wPzKEG37KaRSkV4EorVJwH
 xtRChu1w
 Ye/E/nahGCNq7cAhE9UP78l8el8Iceg6N30cQO0QAYYG2fVsJmd5PWM4qYcPcO7eGy5ks0jwyIzRsNkvxZQInQVjlblWBz7vKYSrL+oopQYNjbt5nZEyZrSjW4zK0Yyey0Dscrb/5lZZCkmHRFmlp/VOEIrMa3V0j4L4fQYks7m/N9qHcS13iuUoq4bkIKmOHyRBi6ER9pbKWWhxHg0MvLnKYyY+so6NkdgJ8B3QJ0mhjaACqy27u5lsDkqVcJhCQpMQWR3y0stcifnGJqt66pHnfYqQ7kkdQTwhcXdiN/Y9jzIrVipazYDpNQapSD0Z4NX2WWJVSMMQYS13HDbBPfWzPoZMbiDO6GFfDfCNAriV7XBeBejUl4qpMp3VFVwYx1OMEvSCBSP+tiZFHgXxQ8YEnnPFT1DbIFxPLxW49wa9VrkKTwFH54LSo5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 12:48:55PM +0800, Hao Jia wrote:
> From: Hao Jia <jiahao1@lixiang.com>
> 
> Zswap currently writes back pages to backing swap reactively, triggered
> either by the shrinker or when the pool reaches its size limit. There is
> no mechanism to control the amount of writeback for a specific memory
> cgroup. However, users may want to proactively write back zswap pages,
> e.g., to free up memory for other applications or to prepare for
> memory-intensive workloads.
> 
> Introduce a "zswap_writeback_only" key to the memory.reclaim cgroup
> interface. When specified, this key bypasses standard memory reclaim
> and exclusively performs proactive zswap writeback up to the requested
> budget. If omitted, the default reclaim behavior remains unchanged.
> 
> Example usage:
>   # Write back 10MB of compressed data from zswap to the backing swap
>   echo "10M zswap_writeback_only" > memory.reclaim
> 
> Note that the actual amount of compressed data written back may be less
> than requested due to the zswap second-chance algorithm: referenced
> entries are rotated on the LRU on the first encounter and only written
> back on a second pass. If fewer bytes are written back than requested,
> -EAGAIN is returned, matching the existing memory.reclaim semantics.
> 
> Internally, extend user_proactive_reclaim() to parse the new
> "zswap_writeback_only" token and invoke the dedicated handler
> zswap_proactive_writeback(). This handler reuses
> zswap_try_to_writeback() to walk the target memcg subtree, draining
> per-node zswap LRUs through list_lru_walk_one() with the
> shrink_memcg_cb() callback.

I won't comment on the memcg interface as this is more-or-less a
placeholder until an interface is finalized.

> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
[..]
> diff --git a/mm/zswap.c b/mm/zswap.c
> index e29f8a61412d..28200552dde3 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1423,6 +1423,27 @@ static struct mem_cgroup *zswap_iter_global(void)
>  	return memcg;
>  }
>  
> +/*
> + * Local iteration uses a local cursor to select from online memcgs
> + * under @root in a round-robin fashion.
> + *
> + * Pass the previous return value as @prev to advance the round-robin
> + * iteration, or pass NULL to start a new walk. If exiting early before
> + * the iteration completes, the caller must call mem_cgroup_iter_break()
> + * to release the cursor reference.
> + */
> +static struct mem_cgroup *zswap_iter_local(struct mem_cgroup *root,
> +					   struct mem_cgroup *prev)
> +{
> +	struct mem_cgroup *memcg;
> +
> +	do {
> +		memcg = mem_cgroup_iter(root, prev, NULL);
> +		prev = memcg;
> +	} while (memcg && !mem_cgroup_tryget_online(memcg));
> +	return memcg;
> +}
> +
>  /*
>   * Walk the memcg tree and write back zswap pages until the
>   * (lower_pages, upper_pages) window closes, or abort encounter
> @@ -1430,16 +1451,23 @@ static struct mem_cgroup *zswap_iter_global(void)
>   * - No writeback-candidate memcgs found in a memcg tree walk.
>   * - Shrinking a writeback-candidate memcg failed.
>   *
> - * For shrink_worker(), it passes lower=thr and upper=zswap_total_pages().
> - * The @upper limit is refreshed in each iteration by re-evaluating
> - * zswap_total_pages(), and the window closes once the total falls
> - * below the threshold.
> + * For shrink_worker() (proactive=false), it passes lower=thr and
> + * upper=zswap_total_pages(). The @upper limit is refreshed in each
> + * iteration by re-evaluating zswap_total_pages(), and the window
> + * closes once the total falls below the threshold.
> + *
> + * For zswap_proactive_writeback() (proactive=true), it passes lower=0
> + * and upper=nr_to_writeback. The @lower limit is advanced by the
> + * compressed bytes written back via shrink_memcg(). The window closes
> + * once @nr_to_writeback pages of compressed data have been written back.
>   */
> -static void zswap_try_to_writeback(unsigned long lower_pages,
> -				   unsigned long upper_pages)
> +static int zswap_try_to_writeback(struct mem_cgroup *memcg,
> +				  unsigned long lower_pages,
> +				  unsigned long upper_pages, bool proactive)

As I mentiond in the previous patch, this is the wrong abstraction. The
function is extremely tighyl-coupled to the callers, and needing to
pass in things like proactive makes it even worse.

It should be limited to reclaiming one batch of pages from a memcg, and
the retry logic. Everything else (memcg iteration logic, scan goal
checks) should be in the caller.

[..]  
>  static void shrink_worker(struct work_struct *w)
> @@ -1490,7 +1536,7 @@ static void shrink_worker(struct work_struct *w)
>  	/* Reclaim down to the accept threshold */
>  	thr = zswap_accept_thr_pages();
>  
> -	zswap_try_to_writeback(thr, zswap_total_pages());
> +	zswap_try_to_writeback(NULL, thr, zswap_total_pages(), false);
>  }
>  
>  /*********************************
> @@ -1736,6 +1782,19 @@ int zswap_load(struct folio *folio)
>  	return 0;
>  }
>  
> +int zswap_proactive_writeback(struct mem_cgroup *memcg,
> +			      unsigned long nr_to_writeback)
> +{
> +	if (!memcg)
> +		return -EINVAL;
> +	if (!mem_cgroup_zswap_writeback_enabled(memcg))
> +		return -EINVAL;
> +	if (!nr_to_writeback)
> +		return 0;
> +
> +	return zswap_try_to_writeback(memcg, 0, nr_to_writeback, true);

The memcg loop should be here, together with a check on the written
bytes to check if the reclaim goal was achieved. I think nr_to_writeback
is also very confusing, it's really the reclaim target in bytes divided
by PAGE_SIZE. I think you need to pass in the number of bytes to
reclaim/writeback directly.

> +}
> +
>  void zswap_invalidate(swp_entry_t swp)
>  {
>  	pgoff_t offset = swp_offset(swp);
> -- 
> 2.34.1
> 


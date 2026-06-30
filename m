Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89273C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 00:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34DEE6B00B8; Mon, 29 Jun 2026 20:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF996B00B9; Mon, 29 Jun 2026 20:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE5B6B00BA; Mon, 29 Jun 2026 20:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0E6B6B00B8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:16:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D51E71402E9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:15:59 +0000 (UTC)
X-FDA: 84934661238.11.3D7D4F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 53E511C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:15:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ym0n7Pya;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782778558;
	b=s4SnwhoNXHGvZyKVoIczIfXChmyQdysUZCGl3Gk3kYavQpgdbzy4nPsi8sko2WYQ25xzhs
	k2Qtum/pEdGJbO38cVSvZ/GpmdSxfLn0nda5pOo8/BcWDXEsoYxx3jDAuxelL5JBE7FcS+
	WM1KOfVf+21OBLRFvmFGzow2zeAt+wM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782778558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nit+uzLYWcVxRwAjtLptONbY2sqNp7YD9OQCLbyeu3I=;
	b=7jcjtVT9zsT2oqRJ6XQQYSYAyHjwXMRsnuNgDkJ6N2uyhrZxk5NmHI5GCcxQ1XjioTxpN8
	pz9Pmy5GF/7/HDloPnyJdTJR9M18VRPYAQ9lZ6wGIbXP0zeRa6gDe2rZrtjDyZa2CfcDqC
	046Y/k40gzQASmDhvI0qne6RT2UN7lg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ym0n7Pya;
	spf=pass (imf21.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBF96600C3;
	Tue, 30 Jun 2026 00:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120C21F000E9;
	Tue, 30 Jun 2026 00:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782778557;
	bh=Nit+uzLYWcVxRwAjtLptONbY2sqNp7YD9OQCLbyeu3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ym0n7Pya/hmGoFn+s2yhXdiWd+CDg0SoF3vlWaxBZSZskDXBd4h90B+/e5hUuAhpA
	 4qBMRuFEC507FHg+64KRw5Sgar6T0BdO0SkQCFC0bm7k4V8y76jVdReXYRNLCiXG75
	 qk/i3I1rIgiyM+GvBfBp0ZyJ8MuN/iJ0hiuIbsAm3z4mApNY8byS7HfTbGYcd8nA2L
	 MzV0m8rl0Zq/R2JIZbPIkqYFjWk8gvBne/uPcrN31dJ7SZ1WxND0Ypc39YoG+lyRRx
	 2CWjSXP/XE3MhuPi8x5eCPU13OnYNxAszYPztscIDNYPK3i2zHGFlMOWTs+Ir81CeQ
	 0jAzW1Ae4rUpA==
Date: Tue, 30 Jun 2026 00:15:55 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
Message-ID: <akMJ8UfeZXrVe5LN@google.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629112032.20423-5-jiahao.kernel@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 53E511C0003
X-Stat-Signature: onnoheg6rqfnr44d43s6h8113ghdt7zr
X-HE-Tag: 1782778558-942772
X-HE-Meta: U2FsdGVkX1/Q6HAd75TrT7v2M3QCCxXAVPYIWq00QqeFq2PlSa575M86Plj6APRtw3qtBHC+pmxm2svrrdCOLXdnJWZbSTGeaADTSDAmSCluURvXSIQMc5WN350p98WOtDoFghJDw+INX04HeEIhJNGS2hVGl6Ed4CqFce3M7/23bcROsofGCXIdsJbFJesaKyVYMDW+X4ObY5GixGbhQDVF/GTz3/8uElMsSOSnrgP5OrZA59j5s66YE7cnHaCgCzpHCLL95oPZ5EVP8d6YTE/AMe7pR5dOoIbLs6jL3vgQmh3mWJWyhB5sQLQjMPUdOPXxhP6BxFkj9jHv9OzEeKgycFUhETnQpxAEDFrC9rUK1+6WzrN4+r2791YxqwTs/weEXC6OuhxfW6b5Y664sOy8fwBjujX5SNfVZEtwSizuMslvY9aJv+R/6q47hSlnGruTEkrCRaps7WQ6B0kdTZVD+a6G7ddmIkIEoMw494nYkJFMalfOZpbOiggKHyIH2RmdDm3aUjOHB28i+LjI55Mw2GBebmawJYniIE6f2HbxdodpyR2MPr3ykZ6pqTSwWNmOexJGmngPOoTIZwf5WuBsdoTzk//T8LjtaT1Bwgt1K8GnY545Ve1l0n6FRIQxxhA+M7qVSHjYnMXM/7Ih3FgfB90hfCOb54RRdu9eWNq77XD+efXvhUw1efZSNkmMbjA1Dz5mbaB4ZHJ+LiJir9Ev3JhP93eVD7IuMEMzEIij6nF0Vd9TFdWUu4cUwFyHexfr/kCCLJQb5hpUwLGzf3kF8qhkfWWeM6AxNgX/B590XBnx5lfp0rXEnw2pwMIAp1+kDwNSIL0i7rZL/6kMwXOg/h0YZU+K0hEe9wTfSu9mQLbwizG3wuBLlinl+3Cd62VgLjBbsyi+p7ELrc+CJt16Dscqx1v2w+kn3lqgypK0Y1CJk3c2tg/M3SvrmYbg/sdii9DZeRQlrgobZ5E
 KeEsDYif
 4k2xlFYHY7EqKqE5DyE+Nsz0RK0EqU05BSztufCX97q2rknt6Ns1fCxpyu5vzlA00eLV79Go5DZ9fK4+ByrN0/pSIkmy45Va1byh+WbYZ2TSuCMU3QZlaWvxMkXbpRFkihFfOBXoL7bv85QQ/U7VImS0KzPZdavUmuYGX5YS97I4ZnzOb+Qspt9KE8/1ZwbPnPbRbtD93TcreG/IK/JYVhOZuD67XNrQtOYK0vsGy8udY17OogOv/+J6t25U9jIOl6YFAx66nDE9g59SGf1HOjzwHSnGg/KhdbfQtP5GvksQK2fSQmgzFJiG0vMx3821bQ76A3NogWYrvw1BdNvtnehAOFInR2h7NxrtiB+EbSMrFpeTZx8aaIgyvYk2fV8c5CIKNiipthidjB2iljri19Qz1ZJW80MiV6Fq00RCRsrtdp7koafIS9DcgbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 07:20:30PM +0800, Hao Jia wrote:
> From: Hao Jia <jiahao1@lixiang.com>
> 
> Zswap currently writes back pages to backing swap reactively, triggered
> either by the shrinker or when the pool reaches its size limit. There is
> no mechanism to control the amount of writeback for a specific memory
> cgroup. However, users may want to proactively write back zswap pages,
> e.g., to free up memory for other applications or to prepare for
> memory-intensive workloads.
> 
> Introduce a "source=" key to the memory.reclaim cgroup interface,
> currently accepting the single value "zswap". When set to "zswap", it
> bypasses standard memory reclaim and exclusively performs proactive
> zswap writeback up to the requested budget. If omitted, the default
> reclaim behavior remains unchanged.
> 
> Example usage:
>   # Write back 10MB of compressed data from zswap to the backing swap
>   echo "10M source=zswap" > memory.reclaim
> 
> Note that the actual amount of compressed data written back may be less
> than requested due to the zswap second-chance algorithm: referenced
> entries are rotated on the LRU on the first encounter and only written
> back on a second pass. If fewer bytes are written back than requested,
> -EAGAIN is returned, matching the existing memory.reclaim semantics.
> 
> Internally, extend user_proactive_reclaim() to parse the new "source="
> key and invoke the dedicated handler zswap_proactive_writeback() when it
> is set to "zswap". This handler walks the target memcg subtree in a
> round-robin fashion and drains each memcg's per-node zswap LRUs through
> shrink_memcg(), accumulating the compressed bytes written back until the
> requested budget is met.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> ---

Before going through more versions we need to figure out if this will
pivot to be a proactive demotion interfcae for swap tiering.

> @@ -7869,9 +7872,12 @@ int user_proactive_reclaim(char *buf,
>  	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
>  	unsigned long nr_to_reclaim, nr_reclaimed = 0;
>  	int swappiness = -1;
> +	bool zswap_writeback_only = false;
>  	char *old_buf, *start;
> +	char source[16];
>  	substring_t args[MAX_OPT_ARGS];
>  	gfp_t gfp_mask = GFP_KERNEL;
> +	u64 nr_bytes;
>  
>  	if (!buf || (!memcg && !pgdat) || (memcg && pgdat))
>  		return -EINVAL;
> @@ -7879,7 +7885,8 @@ int user_proactive_reclaim(char *buf,
>  	buf = strstrip(buf);
>  
>  	old_buf = buf;
> -	nr_to_reclaim = memparse(buf, &buf) / PAGE_SIZE;
> +	nr_bytes = memparse(buf, &buf);
> +	nr_to_reclaim = nr_bytes / PAGE_SIZE;

Nit: if we keep this as part of memory.reclaim, we probably want to
choose clearer names (e.g. pages_to_reclaim and bytes_to_reclaim).

>  	if (buf == old_buf)
>  		return -EINVAL;
>  
> @@ -7899,11 +7906,26 @@ int user_proactive_reclaim(char *buf,
>  		case MEMORY_RECLAIM_SWAPPINESS_MAX:
>  			swappiness = SWAPPINESS_ANON_ONLY;
>  			break;
> +		case MEMORY_RECLAIM_SOURCE:
> +			if (match_strlcpy(source, &args[0], sizeof(source)) >= sizeof(source))
> +				return -EINVAL;
> +			/* Only zswap is supported as a reclaim source for now. */
> +			if (strcmp(source, "zswap"))
> +				return -EINVAL;
> +			zswap_writeback_only = true;
> +			break;
>  		default:
>  			return -EINVAL;
>  		}
>  	}
>  
> +	if (zswap_writeback_only) {
> +		/* source=zswap and swappiness are mutually exclusive. */
> +		if (swappiness != -1)
> +			return -EINVAL;
> +		return zswap_proactive_writeback(memcg, nr_bytes);
> +	}
> +
>  	while (nr_reclaimed < nr_to_reclaim) {
>  		/* Will converge on zero, but reclaim enforces a minimum */
>  		unsigned long batch_size = (nr_to_reclaim - nr_reclaimed) / 4;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ba01bf0e44e9..9cda96f05508 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1713,6 +1713,56 @@ int zswap_load(struct folio *folio)
>  	return 0;
>  }
>  
> +int zswap_proactive_writeback(struct mem_cgroup *memcg, u64 bytes_to_writeback)
> +{
> +	struct zswap_shrink_state s = {};
> +	struct mem_cgroup *iter = NULL;
> +	u64 bytes_written = 0;
> +	int ret = 0;
> +
> +	if (!memcg)
> +		return -EINVAL;

Can this ever happen? It would be a bug in the caller.

> +	if (!mem_cgroup_zswap_writeback_enabled(memcg))
> +		return -EINVAL;
> +	if (!bytes_to_writeback)
> +		return 0;

Do we need this? I think the loop will just never enter and
mem_cgroup_iter_break() will do nothing.

> +
> +	while (bytes_written < bytes_to_writeback) {
> +		long shrunk;
> +
> +		cond_resched();
> +
> +		if (signal_pending(current)) {
> +			ret = -EINTR;
> +			break;
> +		}
> +
> +		/*
> +		 * Use a local iterator to walk the memcg and its online descendants
> +		 * in a round-robin manner. Upon exiting the loop, mem_cgroup_iter_break()
> +		 * must be called to drop the iterator reference.
> +		 */
> +		do {
> +			iter = mem_cgroup_iter(memcg, iter, NULL);
> +		} while (iter && !mem_cgroup_tryget_online(iter));
> +
> +		shrunk = zswap_shrink_one_memcg(iter, &s);
> +		if (shrunk > 0)
> +			bytes_written += shrunk;
> +
> +		/* drop the extra reference taken by mem_cgroup_tryget_online() */
> +		mem_cgroup_put(iter);


Can we just use mem_cgroup_online() instead since mem_cgroup_iter()
already graps a ref?

> +
> +		if (shrunk == -EBUSY) {
> +			ret = -EAGAIN;
> +			break;
> +		}
> +	}
> +
> +	mem_cgroup_iter_break(memcg, iter);
> +	return ret;
> +}
> +
>  void zswap_invalidate(swp_entry_t swp)
>  {
>  	pgoff_t offset = swp_offset(swp);
> -- 
> 2.34.1
> 


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3039FCC9A2
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 23:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B0216B0005; Mon,  9 Mar 2026 19:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1679A6B0089; Mon,  9 Mar 2026 19:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0940D6B008A; Mon,  9 Mar 2026 19:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED7E46B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 19:35:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 95DC2C1966
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:35:36 +0000 (UTC)
X-FDA: 84528133872.07.9F891B7
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf18.hostedemail.com (Postfix) with ESMTP id CFACD1C0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:35:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VTcCMmh0;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773099335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcUZHIoP/8rVVvTMfjJZuqQNgHOSfG8EEoqKfNdISjo=;
	b=Nqh6VfeAHoPEijtLA306iSX5qnzNZj6qdt6PKYwhM5B9ObdYuUMKTj4OUROR0pzskYxglt
	w2dHQtLtMrqYDI8gBWbJ+0O1mgGLdPa3EsGtbBDjw1A+y9Hs1g24DUx69lOXNXiSZAO5iT
	FtGn/XwpJj/p3GOwJ6Uhz6lo5PwPkig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773099335; a=rsa-sha256;
	cv=none;
	b=58EqZYH5vc2JEGIcRu1q47te+bNZ4QUUEwNzZAfN4yLbalK6lRNAF6afv9huPuPwLT2GH7
	OnNDtQdfpQqeOdIUuGcrErq5Elv4RbDO47yP007y825D0WnnXExDrNs+WrucvfFv04LFRf
	8nzi3MeMwA4vlYcFHQ2dBQHEwlmmdEw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VTcCMmh0;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 9 Mar 2026 16:35:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773099329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qcUZHIoP/8rVVvTMfjJZuqQNgHOSfG8EEoqKfNdISjo=;
	b=VTcCMmh01vAkOgpbdITzQKUfGBwJyxxIUHL9dTLptYFWWKdUefCRn8yKynWdEQISF3sh9Y
	u2C/Kh8xkLnJuT+K+Zsi2qHDmUNbs8XNMxiO2jbYtz7I+d9IlVeq8GmfQN9LqFRWoLDYKu
	aWf9StgOUuywlW4g8ai+CM4I5wXtq4g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com, 
	vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com, gourry@gourry.net, 
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com, 
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org, muchun.song@linux.dev, 
	zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev, surenb@google.com, 
	virtualization@lists.linux.dev, weixugc@google.com, xuanzhuo@linux.alibaba.com, 
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aa9Yq5zWBu9lCu_4@linux.dev>
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307045520.247998-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CFACD1C0005
X-Stat-Signature: 4jofmaqobwbowau6y15etdjoxy6tkc6k
X-HE-Tag: 1773099334-268785
X-HE-Meta: U2FsdGVkX1/s7oe9TMLVXSSzdxEZpZqrH6Q43KaHxDRgwnlvRp6MA3hNlRLQMSlej2d7pkgqVfU4MH19bj1U/D7cS4QNauTQsjL10yDwzZlM1CQT1bVeLaZSf0150O8Lc3vlPtDdmijxBM24cs2qiNeVsEdTVsTf1xelMJdjO3H6Pquq8JK1vKYyuA0RPPLwAXtc+sjtTQUqmklqslZKz2fyTLQdG0Q01zFbUXiOJEWvbWYWyiJPwxk9C7wItgziRPs+X6q4HC4Zjsx1IgN5EN0gjk+Jj55wdGGcTyJ0PDFtyqFrCqGPa1dmbFIZxbXDz/puAEXlvAUZENXsoWm0nq3bPWgOCPJp5uRZoFOEJW8b4SAMXOdQr1Ofmj5QNgAawcvwJ6gbru1NkOkzqhlDhwMyI7PLWerXmXkhNa2o3iZYWVfrPJ+cYIYb946OfqbvtaEgBkuM2MukAoJS8GCCMR2v0uLLXXdoH4oe9bSfufI2tW694JFsRpXEFA8MQ73brcVNib3Cjg1FJ+PrLtz4vv/B5Z9Ufq+yeaNza5ip7NkuDLk6LwAXGNgO2hD1ZiAXDunxi0AboyoQO9PCpeo5m9dX/2lGGFNEQaRTOQc//9ks5YmrnsemLvUZ1v8+ko+wnwGlpT+9s72F5Ieb7I2UVuJlwDblRIyGBfxw4No+3OlHtuiR+I5KN4Eb5Wnnaj8N0Z5FSi+VgyNTysbmvZIs+34ol2oklO3o/SRHnnigDzUVi8hekZoFb8GjtvY5wi7M0y6mXL9Ix1LPBOE+wH90Mtne7K/QNcUDFef5J123K4fV5UyAK/TXqFIOIdChXZpI4cKW7jomQCKL7zS0K3XO7qfKevW5me44Ti/hs+9hTWGriUUFG8Pw0HvkmeQN2L1wNUudrfKp3MDnBNdzw8FdrrZ/77hdrmd+NMC6GrKHrK6yNxI4MZYNdWwMEhqqzF/4yOollf0LDWghd4faEef
 Dh3fAgqL
 +iGhA8G1nFPIOd+3jSFobfQWQ3lwWEIpBYNCgZFijeAYmnSVtn9z1/JaBwpsXFVeDGhPdBu3r7mD7a9BCf/rcQPBcOokHOdbbixfznWZGDv8rOP01ewCt2eQn8mhnoueDT9gx9Q+ZKeouckkVVakBQRdN6sI7yv0IqSVwhSouXPmuDCWFUESarMHTZxEDuZlZVIng9LImjLcvTVc5WKYPBPUGcpC+zjWUont32hG1RGsqct7UMnkLJ/CIyYjz4EUndPizgFjHftN224Tmk1Np80XGk9LVMP3loGxj9unHx7Ng2O6nYTpPCi6vzk4Mnb4SspJB8k70QFUca5A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 08:55:20PM -0800, JP Kobryn (Meta) wrote:
> When investigating pressure on a NUMA node, there is no straightforward way
> to determine which policies are driving allocations to it.
> 
> Add per-policy page allocation counters as new node stat items. These
> counters track allocations to nodes and also whether the allocations were
> intentional or fallbacks.
> 
> The new stats follow the existing numa hit/miss/foreign style and have the
> following meanings:
> 
>   hit
>     - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>     - for other policies, allocation succeeded on intended node
>     - counted on the node of the allocation
>   miss
>     - allocation intended for other node, but happened on this one
>     - counted on other node
>   foreign
>     - allocation intended on this node, but happened on other node
>     - counted on this node
> 
> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
> in /proc/vmstat.
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> ---
> v2:
>   - Replaced single per-policy total counter (PGALLOC_MPOL_*) with
>     hit/miss/foreign triplet per policy
>   - Changed from global node stats to per-memcg per-node tracking
> 
> v1:
> https://lore.kernel.org/linux-mm/20260212045109.255391-2-inwardvessel@gmail.com/
> 
>  include/linux/mmzone.h | 20 ++++++++++
>  mm/memcontrol.c        | 60 ++++++++++++++++++++++++++++
>  mm/mempolicy.c         | 90 ++++++++++++++++++++++++++++++++++++++++--
>  mm/vmstat.c            | 20 ++++++++++
>  4 files changed, 187 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7bd0134c241c..c0517cbcb0e2 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -323,6 +323,26 @@ enum node_stat_item {
>  	PGSCAN_ANON,
>  	PGSCAN_FILE,
>  	PGREFILL,
> +#ifdef CONFIG_NUMA
> +	NUMA_MPOL_LOCAL_HIT,
> +	NUMA_MPOL_LOCAL_MISS,
> +	NUMA_MPOL_LOCAL_FOREIGN,
> +	NUMA_MPOL_PREFERRED_HIT,
> +	NUMA_MPOL_PREFERRED_MISS,
> +	NUMA_MPOL_PREFERRED_FOREIGN,
> +	NUMA_MPOL_PREFERRED_MANY_HIT,
> +	NUMA_MPOL_PREFERRED_MANY_MISS,
> +	NUMA_MPOL_PREFERRED_MANY_FOREIGN,
> +	NUMA_MPOL_BIND_HIT,
> +	NUMA_MPOL_BIND_MISS,
> +	NUMA_MPOL_BIND_FOREIGN,
> +	NUMA_MPOL_INTERLEAVE_HIT,
> +	NUMA_MPOL_INTERLEAVE_MISS,
> +	NUMA_MPOL_INTERLEAVE_FOREIGN,
> +	NUMA_MPOL_WEIGHTED_INTERLEAVE_HIT,
> +	NUMA_MPOL_WEIGHTED_INTERLEAVE_MISS,
> +	NUMA_MPOL_WEIGHTED_INTERLEAVE_FOREIGN,
> +#endif

I have not looked into what these metrics mean but these are too many, at least
for the memcg. For the memcg, there is significant memory cost for each metric
added to memcg.



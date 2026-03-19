Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6BE91075274
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A896B042A; Thu, 19 Mar 2026 03:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2526B042B; Thu, 19 Mar 2026 03:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F2E6B042C; Thu, 19 Mar 2026 03:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EBC16B042A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:56:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C40658A8FF
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:56:53 +0000 (UTC)
X-FDA: 84562056306.15.D539006
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2BDD21C0003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:56:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=kEMuBnl5;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773907012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s8A69keN0dzb00KIbKoLnTjne6XlDApP9njkXdbia9M=;
	b=yq2H7x/qbqz15tKL+pApmReNoyAA6Gospoy3V+367fLTuLg5NTWwziQpiDgbiH1krpumj5
	dA+nEqRyQtpUEP+srt4v1fLXPOgObESoLL/hkbIIWolV7Gyk3VNE2zunUynoPIIdB7i/MH
	qEOoJ7fx0ggADAOiPkPGS+GdpnAnhfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773907012; a=rsa-sha256;
	cv=none;
	b=nIHGExH3oqEa7AzkGLy2pGoklNBhacBdDU/fOQZiZJhTLbdY+ywmzEwdqoLjQKYdl/9YRp
	eGu5FTTVHAH+/ss7/ArFhwfHrNpppTpimKk7RRK7aB5KtUFoMMjxqQ48C7g5rFriOnG6wz
	BiQbA6wR19ExwE9Dx/hXoSlL6/gtNns=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=kEMuBnl5;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=s8A69keN0dzb00KIbKoLnTjne6XlDApP9njkXdbia9M=; b=kEMuBnl5QdgU2yGgwfMddW2g5p
	VLX/fnB8GUBtoa0nqe9dfZwrYsqfbEz9RB9gGgt/P0dDr2YcnKNxfN/HMD/y21qYcO9V2lGz8QbPV
	s4o1WzhrWSr23X18Whfz38aFl1qyitlAD0ID6MBLNDNHzrDJgQDKDWRVllbg95qKyJ1etUU7ta06+
	Sze/wW8OLJh0rocRdaV0H2nRNLPmarQOJz3a3iCgr6NW2iqrx6D0PhA6AxnCY9aXsFPZ3A4gbvxtx
	dOL4bASOmjGuVvXm4YOz5TYUNRco6AhAc1//laLG7EvTPVHD004g4y6nm+aqaDGYeQbpweoSVQ7wO
	ajBWtQwg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w38Ex-0000000CyQr-2Ztq;
	Thu, 19 Mar 2026 07:56:23 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id F141F301BD5; Thu, 19 Mar 2026 08:56:21 +0100 (CET)
Date: Thu, 19 Mar 2026 08:56:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com,
	cgroups@vger.kernel.org, chengming.zhou@linux.dev,
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org,
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org,
	hughd@google.com, jannh@google.com, joshua.hahnjy@gmail.com,
	lance.yang@linux.dev, lenb@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev,
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com,
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com,
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com,
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz,
	weixugc@google.com, ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com,
	riel@surriel.com
Subject: Re: [PATCH v4 09/21] mm: swap: allocate a virtual swap slot for each
 swapped out page
Message-ID: <20260319075621.GR3738010@noisy.programming.kicks-ass.net>
References: <20260318222953.441758-1-nphamcs@gmail.com>
 <20260318222953.441758-10-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318222953.441758-10-nphamcs@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2BDD21C0003
X-Stat-Signature: fshwi9b36hhophq1i6eyaxagiwmgjjak
X-HE-Tag: 1773907010-265413
X-HE-Meta: U2FsdGVkX18W+yp+ccjYIb0m/WWrJcHxlB31cwyz8UEKOBljxQiECvTryJu10ywvOUVNdirUfzC9fH7tZiXMjPH1cjv4oUiTB1nmvZ1goul8b+FsXmJvr9eVrLNxcgltfnlKKy71cFMYmVCthGY36XvPOhlshOg7ve4jJLoMx3fiBcDCql/aPWRULtKIZ4GtWVu18Xj5dffisKFBLrWKoqiXP21vV2XnFnA9dk6Pp99n+R+oopu/tzzDN9OSg76B+45Mr2qbJjszSfG7dOzKSeoTzBwMCjVjcMTv5jfHu3Ti+DAcHvN++aT9atyPeUebVgysWkYXSBckE5J23JO2ufau8cbhYj2q0tAbUCQGjYFyUUL6cH+t/ziy+r4y897KJZ9vqvGjQBQtoINNf03V/B7R6+f8xEa2ICSJ/PsAgCfoz6vCpo8MRzGau7BkkhOhzFQJyvPR8PNtDJgxpeAL84VzBeHU3Qn+rismE/AQMpRM2eCVd9sqMtqd5gnyjtcTXJm/SdFxXH7x6bW0Y1irMjzyOMTcwCftD026Vl0VtjYeYVORbh2K0MLuNoHVVsZW1uzsqjz7lvqsM/mrJ3CvbOIvtYLKStb528aLJ1Yvz6ChXsj72w29AiQzui03njR3Fc/4AaEPtoX1+SLH55dV+rq1FzOAkf5IlzkSdoM0dZKdj5E/GTk98bhdopcidoCIXjO2yhXUEFb1BVOnvEjo8wGjMPKj72in09lgGiRasVuPqU9pD3BMHE27loB0KxSyAINkUGRAweBh9GeK6oHLdxsn8NgcQ16DWLXOXbNUxqEGHrNLfvBF8sAPpVdE3GXUP++AjF7zbF+jyNWrDN0YxkA6qct8DgTfjc5nTmwzQERbwR6xgytQPgGXziaRXHYdxIzi/WbnZlYZ7tqD4da/xFGgOtPbqLOllTWv8n9z4a34UFKXkmp4nzV/OmUOC+hO3UqnzQEjUI0rxZZ/7j9
 bjmGwH7J
 X2ikWwLDKti6DnGzyPn6efZRh6QW+hC8FnBbOM/nY9uHG/PTx26RBdbnRx2aOpnBbDRkX1/zWqzTaXuOPw9HhmweCa/YPtxehLRm6nGff9i09ZIksNkRWytPWvf9kzyqCE6ryGM3VqjVu++bLQALLo+IGqpP2/59ca70NNWVnGcf+bQD9zgu+bVhhRXavawf6Wk8vDdfD6dEA38gjP7s7u2gqqMRsN2iBABgBxjPFMsjWm3AzOm0aUI2iwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:29:40PM -0700, Nhat Pham wrote:
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 62cd7b35a29c9..85cb45022e796 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -86,6 +86,7 @@ enum cpuhp_state {
>  	CPUHP_FS_BUFF_DEAD,
>  	CPUHP_PRINTK_DEAD,
>  	CPUHP_MM_MEMCQ_DEAD,
> +	CPUHP_MM_VSWAP_DEAD,
>  	CPUHP_PERCPU_CNT_DEAD,
>  	CPUHP_RADIX_DEAD,
>  	CPUHP_PAGE_ALLOC,

> +static int vswap_cpu_dead(unsigned int cpu)
> +{
> +	struct vswap_cluster *cluster;
> +	int order;
> +
> +	rcu_read_lock();

nit:
	guard(rcu)();

> +	for (order = 0; order < SWAP_NR_ORDERS; order++) {
> +		cluster = per_cpu(percpu_vswap_cluster.clusters[order], cpu);
> +		if (cluster) {
> +			per_cpu(percpu_vswap_cluster.clusters[order], cpu) = NULL;
> +			spin_lock(&cluster->lock);

This breaks on PREEMPT_RT as this is ran with IRQs disabled. This must
be a raw_spinlock_t.

> +			cluster->cached = false;
> +			if (refcount_dec_and_test(&cluster->refcnt))
> +				vswap_cluster_free(cluster);

And this... below.

> +			spin_unlock(&cluster->lock);
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return 0;
> +}

> +static void vswap_cluster_free(struct vswap_cluster *cluster)
> +{
> +	VM_WARN_ON(cluster->count || cluster->cached);
> +	VM_WARN_ON(!spin_is_locked(&cluster->lock));

This is terrible, please use:

	lockdep_assert_held(&cluster->lock);

> +	xa_lock(&vswap_cluster_map);

This is again broken, this cannot be from a DEAD callback with IRQs
disabled.

> +	list_del_init(&cluster->list);
> +	__xa_erase(&vswap_cluster_map, cluster->id);

Strictly speaking this can end up in xas_alloc(), which is again, not
allowed in a DEAD callback.

> +	xa_unlock(&vswap_cluster_map);
> +	rcu_head_init(&cluster->rcu);
> +	kvfree_rcu(cluster, rcu);
> +}



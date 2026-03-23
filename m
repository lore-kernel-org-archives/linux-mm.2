Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D7ECEC01A1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7676B00A2; Mon, 23 Mar 2026 03:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE0A6B00A4; Mon, 23 Mar 2026 03:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BDEB6B00A5; Mon, 23 Mar 2026 03:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87BE06B00A2
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:53:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5087513BF0D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:53:17 +0000 (UTC)
X-FDA: 84576562434.02.5E85F5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B11FC4000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:53:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NoUOiYcw;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lw+23Z2qf2U/xRX85WmKeXeTVc90/3xX0OxyQLkOTuw=;
	b=O2fSSEySZLdjfSmtyfdbQvEfY58qBdcgLrp1n+4WNvx5w53j2xCJ6j9zATUvy1aMKm8BCB
	7wSjYMX5TcqDbZ9rdGpQ+/mXKZ05Qq+BHiujCplm8kD+kBqVL2WgNF0WmMV1osqchxtwFh
	OyUwL/fBnzFdLRVVhDWxNxndqoBUlkQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NoUOiYcw;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252395; a=rsa-sha256;
	cv=none;
	b=FSO36SzArQvMjO9aDiXKq9+5O3CFzs6nfJdWct3V+S20vUGZ+u6ay03rKczusU2lN7fZNL
	rG0B+RWLPgN5Ll9r7cqGwF+ybC8++NyEsLPo1ytv7T6nQ78QfD9GLpLnivE1FOO+krCbZY
	3NvWS7rYC9GDu1DT5nwPDvbvwRMKluQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 304EC60051;
	Mon, 23 Mar 2026 07:53:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1A8C4CEF7;
	Mon, 23 Mar 2026 07:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252394;
	bh=ep0hDSwCBGOnuJvxJme1oMbAirhVZHXupMETu8snQ4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NoUOiYcwo/H7w+dsYAyFCvOVNzzuboDFucLEAGhVJsh7zhirN/JAuNuWb0IChI9YA
	 9vacG2nDCrg4TOJCH796WyyHEbOdUj3Aa+3UtJY1Dfadu4cwp7rNVm3Sm7lQiFtaip
	 jMomh59jceywvp/GIcqbU0lzcwFWAN1r/xkmxSD7p/xu7/U4U3WkKGImyP7YS7t9NH
	 R4jDo3sditHBH6CeIMfspKwqM2K8ekpeVDT6WOasAdfhcDqeQ0MQmD0j4BDk5p4+1G
	 4kXhH2gwBcnwv0DFDxUPMmYMGdOUpmSvIENx8GDttcQfl6Z68qPMvt8k4kpdZy5Ntr
	 C5f2nbGbZY1dw==
Date: Mon, 23 Mar 2026 16:53:12 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
	usamaarif642@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v6 30/33] mm: memcontrol: prepare for reparenting
 non-hierarchical stats
Message-ID: <acDxaEgnqPI-Z4be@hyeyoo>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
 <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e862995c45a7101a541284b6ebee5e5c32c89066.1772711148.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: 19cudwcgycr1u1euu8y3kkiaydafjkin
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B11FC4000B
X-HE-Tag: 1774252395-254946
X-HE-Meta: U2FsdGVkX19BwtlTzl9jFOFz/Szj65GKNWUpV6sETG78tUGePa91yTH38fZcEPOtdv/RaVH4m0LN84deLOl274Ya5npv2eJWhnHWHrdMFyBL6ZoJBKQ9eg2Nwe6m7eMrzjOwnuxyACiYi+WgPcjesCHRh9k0Eo1OtuNk3UCj/f5R9S1vRCmKYgHrniiWDJE/EE9c5EmyMW0Uo4Y5BEPSUsRrpFeL6yixNEih5AT43QZ0jLNcNuC5VtiTwVlXLQNOJ4V6Ecfhd/jRgpiWcAtECRBsUBUeNhEKwL2cNrNz0yRyRDSO94uj+Lqfm4dax3qveRQqPdxghvOHkiyYs9s0A5RMokc6/NV5BVPyp3+BdX7KsL2ZqrtCCMJlSQRVrWQFIKaIAZ8h/YgB8gk20ev83b/UcbkGF0UW0PKK4JDekxWndTHUQAuIQKa3eCzq5l5Z2QlSLDG/xOtTbkkevI+NAFeX0OQaYtefuvaxC9wrF+/Oc0/cewOh0IIDLGn35QERPj042D00tYBN+EY8lgdUv37Cxbxy8LA3fd7is7UK6gUhSIw8mZ8a9f7Tax+FgX6Hh3JHMhoHznfe++96+1KfxJVZ2jwf8euU48IYbCXQsB65ZJqPe3GomFs+DwuJ+UVPn1RCIna8DfubsVCeJrwWvDi5k0lFd6mkmJVJwzMVWx/ddBa6n8hxnHklm6OAgNlQphRnj/QPVfj0430lWqqBjeDDyXToHe1RnDd2Z1FgTqDGIxp2xVRR/a/QDFTflJaHlNATHX1vsNtjbGMLNT4WuBFsSdbgUfTD8MehNODtvAe0xjdB/Pchxf1/AxH++n1L/1daVvew8JfsHHOY/n5kMOQydxPnQuBqzq2ZeJTDkYP0SVb5SeizY9VnxP0uM2BIOYLWHxgyJseOyPInnhu94P5wPA+FZuQ9BS+dNtxaznPrJLi7WrNw8B1v7eblQPYsKnhM7RP+nYD5wj3HlkX
 EGVFpfdy
 3d5g1D4KbeCh0zqF8krLELE/LuJH7nnwt40np+yeK98djvFXQrBLYyCe4QR3k+SrVZv+vetPGI5FjTyyg/SXY8nq9Rnbpj+H3NGfeTc92yXtdpcWRx6p51tWctbxFHZNKWpRxv8ljmagcs325bwXmHC0FEmVSELS0vVwkKEuHow8qx00dpKUtqKkZoRTVlXzjbRcxABB3TrEEHX7nv2EbX4FwoOyx1/0mz0OsAVl+DSrAovrnErb6ax3ZdKf+Cv1r06/GjflGcuaTzx+sqOYvzTPoZDhpYX0I5Iz0dCAoOUOfVaU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 07:52:48PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> To resolve the dying memcg issue, we need to reparent LRU folios of child
> memcg to its parent memcg. This could cause problems for non-hierarchical
> stats.
> 
> As Yosry Ahmed pointed out:
> 
> ```
> In short, if memory is charged to a dying cgroup at the time of
> reparenting, when the memory gets uncharged the stats updates will occur
> at the parent. This will update both hierarchical and non-hierarchical
> stats of the parent, which would corrupt the parent's non-hierarchical
> stats (because those counters were never incremented when the memory was
> charged).
> ```
> 
> Now we have the following two types of non-hierarchical stats, and they
> are only used in CONFIG_MEMCG_V1:
> 
> a. memcg->vmstats->state_local[i]
> b. pn->lruvec_stats->state_local[i]
> 
> To ensure that these non-hierarchical stats work properly, we need to
> reparent these non-hierarchical stats after reparenting LRU folios. To
> this end, this commit makes the following preparations:
> 
> 1. implement reparent_state_local() to reparent non-hierarchical stats
> 2. make css_killed_work_fn() to be called in rcu work, and implement
>    get_non_dying_memcg_start() and get_non_dying_memcg_end() to avoid race
>    between mod_memcg_state()/mod_memcg_lruvec_state()
>    and reparent_state_local()
> 
> Co-developed-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  kernel/cgroup/cgroup.c |  9 ++--
>  mm/memcontrol-v1.c     | 16 +++++++
>  mm/memcontrol-v1.h     |  7 +++
>  mm/memcontrol.c        | 97 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 125 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 23b70bd80ddc9..b0519a16f5684 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -473,6 +501,30 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>  	return x;
>  }
>  
> +#ifdef CONFIG_MEMCG_V1
> +static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> +				     enum node_stat_item idx, int val);
> +
> +void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
> +				       struct mem_cgroup *parent, int idx)
> +{
> +	int nid;
> +
> +	for_each_node(nid) {
> +		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
> +		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
> +		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
> +		struct mem_cgroup_per_node *child_pn, *parent_pn;
> +
> +		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
> +		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
> +
> +		__mod_memcg_lruvec_state(child_pn, idx, -value);
> +		__mod_memcg_lruvec_state(parent_pn, idx, value);

We should probably change the type of `@val` from int to val to avoid
losing non hierarchical stats during reparenting?

>  #ifdef CONFIG_MEMCG_V1
>  static void __mod_memcg_state(struct mem_cgroup *memcg,
>  			      enum memcg_stat_item idx, int val)
>
> @@ -769,6 +857,15 @@ unsigned long memcg_page_state_local(struct mem_cgroup *memcg, int idx)
>  #endif
>  	return x;
>  }
> +
> +void reparent_memcg_state_local(struct mem_cgroup *memcg,
> +				struct mem_cgroup *parent, int idx)
> +{
> +	unsigned long value = memcg_page_state_local(memcg, idx);
> +
> +	__mod_memcg_state(memcg, idx, -value);
> +	__mod_memcg_state(parent, idx, value);
> +}

Same here.

Otherwise LGTM.

>  #endif
>  
>  static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,

-- 
Cheers,
Harry / Hyeonggon


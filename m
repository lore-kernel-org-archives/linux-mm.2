Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AA4C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1996B03F6; Thu, 13 Aug 2026 04:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAA66B03F7; Thu, 13 Aug 2026 04:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B76E6B03F8; Thu, 13 Aug 2026 04:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 450606B03F6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:24:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D70AC405F9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:24:19 +0000 (UTC)
X-FDA: 85095559038.01.2F5F9C0
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id C594D120004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:24:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=A4JnWsF9;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609458;
	b=CdKpavYrafbIYvMkNb6uvZ4qK6PxrRF0ML/2P+iSxhVe4jPjM1AqkmKsrnaC/ZSzISoDMW
	7zxuFh6pdgkiRe/SjZQKBjKq7hFPTfvUKYRfZDlXxDuby8Yb3bOHkTDWveXfstWC9dGzzv
	0M9kri1P0ndB+x5SE2ApcWOOjExd2gU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=A4JnWsF9;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKDZCSHjP7mlpTM3aYwOKTi5yJouVyjW3+0PVCUUuYE=;
	b=VonVyx17CCV6oJxtby27xGpbtn4CxTfvgiv9in8MPe2wXeieQwinfV7+kF4qv3JFyCtPel
	kHtRrPfkLetvTGUWqgLZZ00lpXuFKo/HjuPgy+1QyA87XVe1LOZAh2FM0uOaGR4j2zPtJl
	2iVM0x/UEMFwKSHkagBShqJav1z7OlY=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47db714766aso383011f8f.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609456; x=1787214256; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eKDZCSHjP7mlpTM3aYwOKTi5yJouVyjW3+0PVCUUuYE=;
        b=A4JnWsF9DEY40hso3pKHCFdnBQSt22YfYJrAm7uK6az7QFMpId8giwLWNC2CXMVyO/
         u28rDeAwWRSB0MagAJG2Pclk0rbZ0DaKNK1MNgi1h8sM/BxlOU/zdE929j6xxO2BwGQo
         40u6/rR9MKYgcP+p8ilY6KHRpAhV9bx/nmrkPhT/PkTqJxBrOfNwH5V99tBNQZleAIx0
         SubVy5XreKwis7mwVKoZ7gKvEVh9XW+HUVHYVKeEwYQzDJMe9FdjSvHj3xpr7BvOGeoP
         MgRH6/lXeq9I92kh8YnNwEjfVhoUtObmZIeDHu+EyykGd1AR/BCbyH2XyGKRdjQR2Sii
         xQKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609456; x=1787214256;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eKDZCSHjP7mlpTM3aYwOKTi5yJouVyjW3+0PVCUUuYE=;
        b=CLtuEQODND1qutzuHVVRTF7Y6jIuZtbPtt8y6MOEGuDfND8mkiQbuHLuXRMVllMEIV
         FcZhSLgJtP1gVc4XDYFkTBOj1RbU4xVAm2B9BClprH0EwuboHHmqJ7Chw0cXvzlwAzTR
         KfHwQuCuTft6P7YtqRatcJHJW2qwG878ZKFHf5HG6N8EdmrN45GZTsP6pmp1ibgdSUAP
         hRnGkuRqrFhiIH9C5BS5cnHNcfle5wiS6vvzmFaTr8aBuUQzhUmZpiCA+++R1b9Vh7LP
         ubIqRGk0heivAEYl4yeG/9EkHUKLfwZRmyrPaxzgN5Enp4RCkJOLnWMq/avdfDMmmT9+
         JY9A==
X-Forwarded-Encrypted: i=1; AHgh+RrCibcRpM8SRnLrv1PScx6eEm4xjp8ed0Ak4EuaLiiNz2iG34l4ti/1ea/k8HP48ppFP+XcNnk5BA==@kvack.org
X-Gm-Message-State: AOJu0YwiSP3Q8ygvfMNxqVYFqMydAeIqtNwO5RXEAoJJtFOKWNkBOr/v
	EYNd1TwkT6dK83Dhb7TtvtruQHkkZTl26q3Zwf+Cq3QLTAfx00phpCJuwEyyZjnFj4o=
X-Gm-Gg: AR+sD13veqtN1rVS9SaF22lVRiFBoteb6KQ9knE67cs5LobvObPCJ8nKGfzmmngQVVf
	K3enu8RJDZxDYHUr5T1XpNABVBgBMBGq+XBvV6hkofJqe5uN7oJHAzFqPorZUxUJSomfR7CYinj
	4oSXxbD0QThzW31DQtm4RBpuiV5sM1J0Ij/OQmlqyStXejKtiUl+Hq/Du19tD+VuVM/TqjbxSe0
	NG4urEkIRBCK4Y0fGxMRRSzfH5f4HtxJmfq3RQgW8WkuzGmkDrChi7Rg3sGG2fPqAuSNteRn2uz
	viDK9ChcDHgCKeurKPuGFIYkpGb2FLoiPKyoNTcmDNUMGlPX1YAW+j8ekhj/UTxlRQs/1rBq+VC
	7+9gbyK3yP3QmOoumhZ9i3JXxB7OOpcHizTyXip/zm1QmJFsJTg4opOfAeQIIBpF6FwiZ92hWVZ
	qaBLaohmhPkX/c45h0bN3GcUOoFXHyJNz+KJfCnjjjAWSS6ryibKagQfJeL5183FWuBC4Ua34=
X-Received: by 2002:a05:6000:4022:b0:47f:8cd3:4bed with SMTP id ffacd0b85a97d-4815a5bbdbemr4876389f8f.5.1786609456219;
        Thu, 13 Aug 2026 01:24:16 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5c2842sm4349620f8f.35.2026.08.13.01.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:24:15 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:24:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] memcg: remove v1 soft limit reclaim
Message-ID: <an1_LgFQRT7oeskJ@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-3-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-3-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: C594D120004
X-Rspam-User: 
X-Stat-Signature: 7sjf5pixj8ikhmhxph5hgsqr8n7rpsp1
X-Rspamd-Server: rspam06
X-HE-Tag: 1786609457-713376
X-HE-Meta: U2FsdGVkX18dnV1zHB4f8p9p3e0UdZSr5OYVoLvbVsD7Sa6nj/xzxBaSNDJOEVKsf/LQLn2SDZxXjhr0oE/Q6M8iC3Fcvh+B/xFJr01iXHAQzoXFmSeZ36OhWsuGyXxBQ+BXFU+cCt7Q6eYHRWrTn8Eu8ECD7COciVicmCRqcSSoL/bRTiqyoyuc4W88X8A/aOGD3fonlDw5REuc7s/1qYIPhCIbsxP8LbUl1zz3rVI1/visjbskog1xupPG9i+z66uoEm2jYxLQcQc6pKYFEZkb3Hw3i5TzhCmvzZXXeHbdRm3igVS0PjIXGrAjOX3/eN2ZqQKQ9n9liAFm4fnSUzcqyybjiqi0m6ZIq6eghIFo5SZ1dqRqyhbNaVYZ48TM3We5oLVastRmT1pzkKT4TtTf7sBVBldh0itV/qYh+6xIEUlvbxmZFkP/Jeby3iJUo5CZIKmDobGDMSgaC8MjrNJdHlfsxDB2lBvOy8C1lhBn62YggzcFiAXOYiJ3tFIqJFyvcGblsNUG16DZB+eMA4lJLzIEHsCo4Srn2kE6mex5fXEx3IXmHNx/qtBBvYotPFSINBL1+cypSINC8/9djO3hUJfHh/DJfMgfTOemi743vQRPq0zcIovxAHMXbaxjf7EeFhq5NvGPDFZbfF9BvaRWvuz7dDcMavAt92yHj/FcLzw+bEZ3xnnx2Oq8YZm+Qi15ZUZ2yXPA4WAjueNkye7vT3MY9L4TH8SV+9xP05KQXoBtyE+drXUuiyghspPEzMwrHpfg76mX5neeRo65sdfMey1sE3L1yyc1Ulpx4ouAUygoOhJJeZroSQQJ/3QyU3BE1K+RNJK2xNK25A/XkFmsupdmpoWCMGKUMr0z0ojs1yhXt1vf7C1KyWgylZSUhEdJwm+Wi1irFba7TCc2XKQmulGUVpO+njOfGLSfF/2qo7fhuVIgM81DYfUMcKSogkm0qENOR+46FADQ9tS
 yITdarbF
 sPGvzCHDnbJ5modK09eJncLQBoXfMfYc7M7Awa0lxWIHohrvxqfXkbdNUzf7zqKhVxXOU3sMG6AiW/Ba/EgYvYe561tZWISJOdyrjMl7NCfM7uM60ejMc8iCWw6+xOIjg+K+TDEQ0lHyp+K7Hir3pY5nqTx8hJ9w0RdFOXw8oAlWZ/8TcVYT01MFrzn6LpdYsnqrX/MvSpRqkTlCgrb8SSaNfAL3IS88LqbinK6j+MBhaBmXmMNjMwzxwXXu2B3821Z8TiOnBPZDK8qKI48qkh/G6Lg6JM1vadx6Bnh710xkUbp/+qWI+qdryU1qtSWvC2PuHth9+VnbKoGCdYloisgAWBX9I962BUNBHBQa98goyHzop/yetS3t8IlM3eNrIR9WyLJ1yyn6fpD3P8/ZMxGfRobykn0z9pvTB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 13:31:56, Shakeel Butt wrote:
> Nothing can put a cgroup on the soft limit rbtree anymore, so the tree
> is always empty and both callers of memcg1_soft_limit_reclaim() are
> guaranteed no-ops. Remove the reclaim pass from direct reclaim and from
> kswapd, along with its implementation.
> 
> In shrink_zones() this leaves the global reclaim branch with a
> last_pgdat check that is now redundant with the identical check right
> below it, so drop it and move the explaining comment down to the check
> that remains. That check could only ever fire once last_pgdat was set,
> which implies first_pgdat had already been assigned, so skipping it does
> not change which node consider_reclaim_throttle() gets.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h |  12 ---
>  mm/memcontrol-v1.c         | 175 -------------------------------------
>  mm/vmscan.c                |  39 ++-------
>  3 files changed, 6 insertions(+), 220 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index e78bc98ab229..7b02f1b3bb88 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -1927,10 +1927,6 @@ static inline bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg)
>  /* Cgroup v1-related declarations */
>  
>  #ifdef CONFIG_MEMCG_V1
> -unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
> -					gfp_t gfp_mask,
> -					unsigned long *total_scanned);
> -
>  bool mem_cgroup_oom_synchronize(bool wait);
>  
>  static inline bool task_in_memcg_oom(struct task_struct *p)
> @@ -1951,14 +1947,6 @@ static inline void mem_cgroup_exit_user_fault(void)
>  }
>  
>  #else /* CONFIG_MEMCG_V1 */
> -static inline
> -unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
> -					gfp_t gfp_mask,
> -					unsigned long *total_scanned)
> -{
> -	return 0;
> -}
> -
>  static inline bool task_in_memcg_oom(struct task_struct *p)
>  {
>  	return false;
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 05ef55cae4dc..b38b8d0f7f51 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -34,13 +34,6 @@ struct mem_cgroup_tree {
>  
>  static struct mem_cgroup_tree soft_limit_tree __read_mostly;
>  
> -/*
> - * Maximum loops in mem_cgroup_soft_reclaim(), used for soft
> - * limit reclaim to prevent infinite loops, if they ever occur.
> - */
> -#define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
> -#define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	2
> -
>  /* for OOM */
>  struct mem_cgroup_eventfd_list {
>  	struct list_head list;
> @@ -233,174 +226,6 @@ void memcg1_remove_from_trees(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -static struct mem_cgroup_per_node *
> -__mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
> -{
> -	struct mem_cgroup_per_node *mz;
> -
> -retry:
> -	mz = NULL;
> -	if (!mctz->rb_rightmost)
> -		goto done;		/* Nothing to reclaim from */
> -
> -	mz = rb_entry(mctz->rb_rightmost,
> -		      struct mem_cgroup_per_node, tree_node);
> -	/*
> -	 * Remove the node now but someone else can add it back,
> -	 * we will to add it back at the end of reclaim to its correct
> -	 * position in the tree.
> -	 */
> -	__mem_cgroup_remove_exceeded(mz, mctz);
> -	if (!soft_limit_excess(mz->memcg) ||
> -	    !css_tryget(&mz->memcg->css))
> -		goto retry;
> -done:
> -	return mz;
> -}
> -
> -static struct mem_cgroup_per_node *
> -mem_cgroup_largest_soft_limit_node(struct mem_cgroup_tree_per_node *mctz)
> -{
> -	struct mem_cgroup_per_node *mz;
> -
> -	spin_lock_irq(&mctz->lock);
> -	mz = __mem_cgroup_largest_soft_limit_node(mctz);
> -	spin_unlock_irq(&mctz->lock);
> -	return mz;
> -}
> -
> -static int mem_cgroup_soft_reclaim(struct mem_cgroup *root_memcg,
> -				   pg_data_t *pgdat,
> -				   gfp_t gfp_mask,
> -				   unsigned long *total_scanned)
> -{
> -	struct mem_cgroup *victim = NULL;
> -	int total = 0;
> -	int loop = 0;
> -	unsigned long excess;
> -	unsigned long nr_scanned;
> -	struct mem_cgroup_reclaim_cookie reclaim = {
> -		.pgdat = pgdat,
> -	};
> -
> -	excess = soft_limit_excess(root_memcg);
> -
> -	while (1) {
> -		victim = mem_cgroup_iter(root_memcg, victim, &reclaim);
> -		if (!victim) {
> -			loop++;
> -			if (loop >= 2) {
> -				/*
> -				 * If we have not been able to reclaim
> -				 * anything, it might because there are
> -				 * no reclaimable pages under this hierarchy
> -				 */
> -				if (!total)
> -					break;
> -				/*
> -				 * We want to do more targeted reclaim.
> -				 * excess >> 2 is not to excessive so as to
> -				 * reclaim too much, nor too less that we keep
> -				 * coming back to reclaim from this cgroup
> -				 */
> -				if (total >= (excess >> 2) ||
> -					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
> -					break;
> -			}
> -			continue;
> -		}
> -		total += mem_cgroup_shrink_node(victim, gfp_mask, false,
> -					pgdat, &nr_scanned);
> -		*total_scanned += nr_scanned;
> -		if (!soft_limit_excess(root_memcg))
> -			break;
> -	}
> -	mem_cgroup_iter_break(root_memcg, victim);
> -	return total;
> -}
> -
> -unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
> -					    gfp_t gfp_mask,
> -					    unsigned long *total_scanned)
> -{
> -	unsigned long nr_reclaimed = 0;
> -	struct mem_cgroup_per_node *mz, *next_mz = NULL;
> -	unsigned long reclaimed;
> -	int loop = 0;
> -	struct mem_cgroup_tree_per_node *mctz;
> -	unsigned long excess;
> -
> -	if (lru_gen_enabled())
> -		return 0;
> -
> -	if (order > 0)
> -		return 0;
> -
> -	mctz = soft_limit_tree.rb_tree_per_node[pgdat->node_id];
> -
> -	/*
> -	 * Do not even bother to check the largest node if the root
> -	 * is empty. Do it lockless to prevent lock bouncing. Races
> -	 * are acceptable as soft limit is best effort anyway.
> -	 */
> -	if (!mctz || RB_EMPTY_ROOT(&mctz->rb_root))
> -		return 0;
> -
> -	/*
> -	 * This loop can run a while, specially if mem_cgroup's continuously
> -	 * keep exceeding their soft limit and putting the system under
> -	 * pressure
> -	 */
> -	do {
> -		if (next_mz)
> -			mz = next_mz;
> -		else
> -			mz = mem_cgroup_largest_soft_limit_node(mctz);
> -		if (!mz)
> -			break;
> -
> -		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
> -						    gfp_mask, total_scanned);
> -		nr_reclaimed += reclaimed;
> -		spin_lock_irq(&mctz->lock);
> -
> -		/*
> -		 * If we failed to reclaim anything from this memory cgroup
> -		 * it is time to move on to the next cgroup
> -		 */
> -		next_mz = NULL;
> -		if (!reclaimed)
> -			next_mz = __mem_cgroup_largest_soft_limit_node(mctz);
> -
> -		excess = soft_limit_excess(mz->memcg);
> -		/*
> -		 * One school of thought says that we should not add
> -		 * back the node to the tree if reclaim returns 0.
> -		 * But our reclaim could return 0, simply because due
> -		 * to priority we are exposing a smaller subset of
> -		 * memory to reclaim from. Consider this as a longer
> -		 * term TODO.
> -		 */
> -		/* If excess == 0, no tree ops */
> -		__mem_cgroup_insert_exceeded(mz, mctz, excess);
> -		spin_unlock_irq(&mctz->lock);
> -		css_put(&mz->memcg->css);
> -		loop++;
> -		/*
> -		 * Could not reclaim anything and there are no more
> -		 * mem cgroups to try or we seem to be looping without
> -		 * reclaiming anything.
> -		 */
> -		if (!nr_reclaimed &&
> -			(next_mz == NULL ||
> -			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
> -			break;
> -	} while (!nr_reclaimed);
> -	if (next_mz)
> -		css_put(&next_mz->memcg->css);
> -	return nr_reclaimed;
> -}
> -
>  static u64 mem_cgroup_move_charge_read(struct cgroup_subsys_state *css,
>  				struct cftype *cft)
>  {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index be6bd26e8c57..032b14793d91 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6429,8 +6429,6 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  {
>  	struct zoneref *z;
>  	struct zone *zone;
> -	unsigned long nr_soft_reclaimed;
> -	unsigned long nr_soft_scanned;
>  	gfp_t orig_mask;
>  	pg_data_t *last_pgdat = NULL;
>  	pg_data_t *first_pgdat = NULL;
> @@ -6472,35 +6470,17 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>  				sc->compaction_ready = true;
>  				continue;
>  			}
> -
> -			/*
> -			 * Shrink each node in the zonelist once. If the
> -			 * zonelist is ordered by zone (not the default) then a
> -			 * node may be shrunk multiple times but in that case
> -			 * the user prefers lower zones being preserved.
> -			 */
> -			if (zone->zone_pgdat == last_pgdat)
> -				continue;
> -
> -			/*
> -			 * This steals pages from memory cgroups over softlimit
> -			 * and returns the number of reclaimed pages and
> -			 * scanned pages. This works for global memory pressure
> -			 * and balancing, not for a memcg's limit.
> -			 */
> -			nr_soft_scanned = 0;
> -			nr_soft_reclaimed = memcg1_soft_limit_reclaim(zone->zone_pgdat,
> -								      sc->order, sc->gfp_mask,
> -								      &nr_soft_scanned);
> -			sc->nr_reclaimed += nr_soft_reclaimed;
> -			sc->nr_scanned += nr_soft_scanned;
> -			/* need some check for avoid more shrink_zone() */
>  		}
>  
>  		if (!first_pgdat)
>  			first_pgdat = zone->zone_pgdat;
>  
> -		/* See comment about same check for global reclaim above */
> +		/*
> +		 * Shrink each node in the zonelist once. If the zonelist is
> +		 * ordered by zone (not the default) then a node may be shrunk
> +		 * multiple times but in that case the user prefers lower zones
> +		 * being preserved.
> +		 */
>  		if (zone->zone_pgdat == last_pgdat)
>  			continue;
>  		last_pgdat = zone->zone_pgdat;
> @@ -7161,8 +7141,6 @@ clear_reclaim_active(pg_data_t *pgdat, int highest_zoneidx)
>  static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  {
>  	int i;
> -	unsigned long nr_soft_reclaimed;
> -	unsigned long nr_soft_scanned;
>  	unsigned long pflags;
>  	unsigned long nr_boost_reclaim;
>  	unsigned long zone_boosts[MAX_NR_ZONES] = { 0, };
> @@ -7268,12 +7246,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  		 */
>  		kswapd_age_node(pgdat, &sc);
>  
> -		/* Call soft limit reclaim before calling shrink_node. */
>  		sc.nr_scanned = 0;
> -		nr_soft_scanned = 0;
> -		nr_soft_reclaimed = memcg1_soft_limit_reclaim(pgdat, sc.order,
> -							      sc.gfp_mask, &nr_soft_scanned);
> -		sc.nr_reclaimed += nr_soft_reclaimed;
>  
>  		/*
>  		 * There should be no need to raise the scanning priority if
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs


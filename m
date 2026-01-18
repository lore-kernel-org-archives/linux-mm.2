Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F30D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 03:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936DF6B008A; Sat, 17 Jan 2026 22:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA4D6B008C; Sat, 17 Jan 2026 22:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9276B0092; Sat, 17 Jan 2026 22:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B25F6B008A
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 22:25:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13A9A13A934
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:25:43 +0000 (UTC)
X-FDA: 84343644966.26.4201C1D
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3D8B3140008
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 03:25:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ulS1dAzu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768706741; a=rsa-sha256;
	cv=none;
	b=kJk5TGHJjml9StKtkj0obvQZDlNQN6JjrAwbwJ15hmYiVZSoy3UfcsNKfqDAKQE1AOCXje
	19jmWdgR7JGFpK5g6wP7caFQLi+Y0A2qxtPj8mdj55beSXlKjtd8uSjbevb3DvgDf5Wq+g
	tTJeOvYzy0l56XtZW9r1UtORDtAb9X4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ulS1dAzu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768706741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOjm92Bmm9If80y0Ir53rgHqAP/jGW2esiVFGBiZN8U=;
	b=NW6bkQwW4wWKLG/VyxIMR7BXXdRUV2PauoMrIHLNXWa0xMnbNmWs4HzsSg+dW15D1fsLe1
	nLW2QZ0n2LFW1ct+djLMttz51Qc+Yl/YwUb6YEGKQpTmtp/26+Dmt2RiiJweZlNZo64AMZ
	vDojRkFzdlJnDc5y+Oo0s2A0dG2zQ+Y=
Date: Sat, 17 Jan 2026 19:25:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768706739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UOjm92Bmm9If80y0Ir53rgHqAP/jGW2esiVFGBiZN8U=;
	b=ulS1dAzuKiAgFJwBt/gzqOeA5ZGpdnNMd/F8Tx2/s+ej8pM20sjEHc3HX9isw1DNrQdkkT
	CVMAhGzehScOj6P9ca08ntBtYkA6FMqKcRPBNxQVje4mokPiYVFi+GN/g6ZQQjDMUNKLiY
	S3xuVDYGfQPmFzvUuW/4sarCM0UuxCo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 26/30] mm: vmscan: prepare for reparenting MGLRU folios
Message-ID: <kp4tov2zwphl23wpp5punfgh73st5grrlswsfmfk52yu45fz4d@22mwy742k2yq>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92e0728fed3d68855173352416cf8077670610f0.1768389889.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: mjpk59a3m1bhwi87ym853oq6nuosdzrb
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D8B3140008
X-HE-Tag: 1768706740-948789
X-HE-Meta: U2FsdGVkX1/CyzdgfZ8EgyTpLZQtXCJy418hPMFgEkbYPDzUrJH8VqK5tqN4H7JQSaiHFFYCVKl9MBtHlgbazsYgfxvUeomjcasXGxzvWTB5Xg0lTtZTUg5MSeEInRZ5k9cQ73sp1xUnC1jZpdfFEmvwqHb6MNQjUL5eTPB6gFy8Ndb0jILAZ0JTrZqzYbEz5Hipt6QbsnWHegnWuL3aDqAFGuJc6O6P9+LcwZbU7+a/+TJzzqTe11NqyWMg9lVXvNC45GTaOch7SkyWLeTZKTCzJcm8enIfZzfZ4quPiiKCP/YHUl8ZmXAEc+ZDXFFt7kf74ZHWKGKNeFZJ1i5Zx7kIRs64UgMn2vteZj4lL+vWEAW6dtOu5q0nEsX+acUsC1saQPBnJnDHz4GsiK3df3D8uNi8vsScwoRhqC5Na7MJOvqa0WoCyxeHVo+FfBpc1Ksq7SOI2DEw4OGpjFU+ONF8LpoB6vIv2YwRlHAORJPHrPb5MdoCGOm1B2HhjrReEsa0Hv0AOoVvR5QZA6Hb1jwWVOSfUtYm4iJLqiqg6CzkSp+3939/rBeLa3OZV8MMAcSYnD3Y3StbcZYOF0Cz2eeoR6lndW1YrDKDYAiniBuyroHnSGefSc4d0dN6nGPkOkeHKy1VJXndWyV0RLIvKxT3thbyLU7ykEJGtnFF6W13PC0/zThdwo40101HH6LLD4tGwkJPaMZWhY+UtA7JyaNSePTr+geLTl3zVqFl5cWp12jQU8a7tmFQY0XsVz+u4phz1I6rFAyQIAhppqgQyQukR1Y8nuyPQRK/1PPi6fJH1LG+0R3yTFVqT2xBpkvc0kT5XufcwevUeKcGVnrep/Po9bkomqAiJp5+jhpcXJjbC5HbpoFker8ZziOUhUN/7cPnUUIAv/cMAb4730/eXFk6TQui3DQsojoqsS6++jiYc/8/BM2eKAjP2VRnDNmLWfNeOZkfp88t5qHwGri
 WbqpB6mP
 A/NbZDdjS3VGmqV8Am7zV8w2uFkQZsaVhLwdq/LT2yTM42QCYgtlkBE6pWJ6w0Yigwx1coEKsxjLEnXxoCQ6nixFUj9+OZAca0prIYErHjDTuncFZNfSMvIgE36ng2PXI+ztX8f7hl2Kg8WaJzweBFnrzpdSvJ4t1myrBfO1SNelKuRQO5FcYz8MJebUhF/fk8X0rCs7xMIBy3hw95GAGZVajSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Axel, Yuanchu & Wei, please help reviewing this patch.

On Wed, Jan 14, 2026 at 07:32:53PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Similar to traditional LRU folios, in order to solve the dying memcg
> problem, we also need to reparenting MGLRU folios to the parent memcg when
> memcg offline.
> 
> However, there are the following challenges:
> 
> 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
>    number of generations of the parent and child memcg may be different,
>    so we cannot simply transfer MGLRU folios in the child memcg to the
>    parent memcg as we did for traditional LRU folios.
> 2. The generation information is stored in folio->flags, but we cannot
>    traverse these folios while holding the lru lock, otherwise it may
>    cause softlockup.
> 3. In walk_update_folio(), the gen of folio and corresponding lru size
>    may be updated, but the folio is not immediately moved to the
>    corresponding lru list. Therefore, there may be folios of different
>    generations on an LRU list.
> 4. In lru_gen_del_folio(), the generation to which the folio belongs is
>    found based on the generation information in folio->flags, and the
>    corresponding LRU size will be updated. Therefore, we need to update
>    the lru size correctly during reparenting, otherwise the lru size may
>    be updated incorrectly in lru_gen_del_folio().
> 
> Finally, this patch chose a compromise method, which is to splice the lru
> list in the child memcg to the lru list of the same generation in the
> parent memcg during reparenting. And in order to ensure that the parent
> memcg has the same generation, we need to increase the generations in the
> parent memcg to the MAX_NR_GENS before reparenting.
> 
> Of course, the same generation has different meanings in the parent and
> child memcg, this will cause confusion in the hot and cold information of
> folios. But other than that, this method is simple enough, the lru size
> is correct, and there is no need to consider some concurrency issues (such
> as lru_gen_del_folio()).
> 
> To prepare for the above work, this commit implements the specific
> functions, which will be used during reparenting.
> 
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Suggested-by: Imran Khan <imran.f.khan@oracle.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/mmzone.h |  16 +++++
>  mm/vmscan.c            | 144 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 160 insertions(+)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 1014b5a93c09c..a41f4f0ae5eb7 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -628,6 +628,9 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg);
>  void lru_gen_offline_memcg(struct mem_cgroup *memcg);
>  void lru_gen_release_memcg(struct mem_cgroup *memcg);
>  void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
> +void max_lru_gen_memcg(struct mem_cgroup *memcg);
> +bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg);
> +void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent);
>  
>  #else /* !CONFIG_LRU_GEN */
>  
> @@ -668,6 +671,19 @@ static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
>  {
>  }
>  
> +static inline void max_lru_gen_memcg(struct mem_cgroup *memcg)
> +{
> +}
> +
> +static inline bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
> +{
> +	return true;
> +}
> +
> +static inline void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> +{
> +}
> +
>  #endif /* CONFIG_LRU_GEN */
>  
>  struct lruvec {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e738082874878..6bc8047b7aec5 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4445,6 +4445,150 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
>  		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
>  }
>  
> +bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
> +{
> +	int nid;
> +
> +	for_each_node(nid) {
> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
> +		int type;
> +
> +		for (type = 0; type < ANON_AND_FILE; type++) {
> +			if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
> +				return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
> +				      struct lruvec *lruvec)
> +{
> +	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
> +	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
> +	int swappiness = mem_cgroup_swappiness(memcg);
> +	DEFINE_MAX_SEQ(lruvec);
> +	bool success = false;
> +
> +	/*
> +	 * We are not iterating the mm_list here, updating mm_state->seq is just
> +	 * to make mm walkers work properly.
> +	 */
> +	if (mm_state) {
> +		spin_lock(&mm_list->lock);
> +		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
> +		if (max_seq > mm_state->seq) {
> +			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
> +			success = true;
> +		}
> +		spin_unlock(&mm_list->lock);
> +	} else {
> +		success = true;
> +	}
> +
> +	if (success)
> +		inc_max_seq(lruvec, max_seq, swappiness);
> +}
> +
> +/*
> + * We need to ensure that the folios of child memcg can be reparented to the
> + * same gen of the parent memcg, so the gens of the parent memcg needed be
> + * incremented to the MAX_NR_GENS before reparenting.
> + */
> +void max_lru_gen_memcg(struct mem_cgroup *memcg)
> +{
> +	int nid;
> +
> +	for_each_node(nid) {
> +		struct lruvec *lruvec = get_lruvec(memcg, nid);
> +		int type;
> +
> +		for (type = 0; type < ANON_AND_FILE; type++) {
> +			while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
> +				try_to_inc_max_seq_nowalk(memcg, lruvec);
> +				cond_resched();
> +			}
> +		}
> +	}
> +}
> +
> +/*
> + * Compared to traditional LRU, MGLRU faces the following challenges:
> + *
> + * 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
> + *    number of generations of the parent and child memcg may be different,
> + *    so we cannot simply transfer MGLRU folios in the child memcg to the
> + *    parent memcg as we did for traditional LRU folios.
> + * 2. The generation information is stored in folio->flags, but we cannot
> + *    traverse these folios while holding the lru lock, otherwise it may
> + *    cause softlockup.
> + * 3. In walk_update_folio(), the gen of folio and corresponding lru size
> + *    may be updated, but the folio is not immediately moved to the
> + *    corresponding lru list. Therefore, there may be folios of different
> + *    generations on an LRU list.
> + * 4. In lru_gen_del_folio(), the generation to which the folio belongs is
> + *    found based on the generation information in folio->flags, and the
> + *    corresponding LRU size will be updated. Therefore, we need to update
> + *    the lru size correctly during reparenting, otherwise the lru size may
> + *    be updated incorrectly in lru_gen_del_folio().
> + *
> + * Finally, we choose a compromise method, which is to splice the lru list in
> + * the child memcg to the lru list of the same generation in the parent memcg
> + * during reparenting.
> + *
> + * The same generation has different meanings in the parent and child memcg,
> + * so this compromise method will cause the LRU inversion problem. But as the
> + * system runs, this problem will be fixed automatically.
> + */
> +static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
> +				     int zone, int type)
> +{
> +	struct lru_gen_folio *child_lrugen, *parent_lrugen;
> +	enum lru_list lru = type * LRU_INACTIVE_FILE;
> +	int i;
> +
> +	child_lrugen = &child_lruvec->lrugen;
> +	parent_lrugen = &parent_lruvec->lrugen;
> +
> +	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
> +		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
> +		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
> +		int dst_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
> +
> +		/* Assuming that child pages are colder than parent pages */
> +		list_splice_init(&child_lrugen->folios[gen][type][zone],
> +				 &parent_lrugen->folios[gen][type][zone]);
> +
> +		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> +		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> +			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
> +
> +		update_lru_size(parent_lruvec, lru + dst_lru_active, zone, nr_pages);
> +	}
> +}
> +
> +void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent)
> +{
> +	int nid;
> +
> +	for_each_node(nid) {
> +		struct lruvec *child_lruvec, *parent_lruvec;
> +		int type, zid;
> +		struct zone *zone;
> +
> +		child_lruvec = get_lruvec(memcg, nid);
> +		parent_lruvec = get_lruvec(parent, nid);
> +
> +		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
> +			for (type = 0; type < ANON_AND_FILE; type++)
> +				__lru_gen_reparent_memcg(child_lruvec, parent_lruvec, zid, type);
> +			mem_cgroup_update_lru_size(parent_lruvec, LRU_UNEVICTABLE, zid,
> +				mem_cgroup_get_zone_lru_size(child_lruvec, LRU_UNEVICTABLE, zid));
> +		}
> +	}
> +}
> +
>  #endif /* CONFIG_MEMCG */
>  
>  /******************************************************************************
> -- 
> 2.20.1
> 


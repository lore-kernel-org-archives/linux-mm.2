Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E95E9C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:40:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBFD26B0128; Mon, 17 Aug 2026 22:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FE36B0136; Mon, 17 Aug 2026 22:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5F0F6B0137; Mon, 17 Aug 2026 22:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98D216B0128
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:40:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 122FB120A0E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:40:44 +0000 (UTC)
X-FDA: 85112837208.10.49BAEF2
Received: from mta1.migadu.com (out-45.mta1.migadu.com [95.215.58.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 74F0A100003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:40:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c2dFeVSl;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.45 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787020842;
	b=PBI/qHXD8QmV8L0NulFDI8NnWaTB37owu+J8/PxDZJH6lBbhtUFYMgMJw1PP/F8tqBcmlF
	SM0khzfX/dqNVM+0f1jvHgAmUMy1HXcPlG1xQI6noHtFU/mzqxPgz5RyIMTemTaflfZYTe
	+Z7QdmuJWOEm78pvZcPN0ClqIHviZYo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c2dFeVSl;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.45 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787020842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0D7RKj5tkFqpfcxXWG7HKLB3AcEgTi4vs7vo5/zBsmM=;
	b=5g3WmK1X/kGp6xrBIeNjhnzEFA0GJl3ds+kz1G0ylz/52DQY+BizUA+sslPCWTDhpPoANs
	d69N6Yy0eYM5f4I820w5qzE30/glsPsI4qdsIWfORMdmNw0atWZrSlY0rxokp9FD4KC3N4
	J+hHGN9fCYy6u+sH3DC4toavJ5+DMrk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VjTzbzJ5U7fulfyPD/S6iBjuQ+IHP/erX76i5LQT7Og=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787020839; v=1; x=1787625639;
 b=c2dFeVSlgzJ1LnSRu8P9fBpSd4jqTo2vYQvM6hdrbUFBIIDrVmSnSro3n02v+JSv8ezhn66w
 plwXV3TZatHPXhHqounD+WSYxk87PcuyIo6T6F6zBqMuG36jem8Kzo8YAQChd6LWLmnna+X4SMr
 u+88g73pEEggZp4uzZs6Gf6Y=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 0adc373bf01fa8f4;
	Tue, 18 Aug 2026 02:40:39 +0000
X-Migadu-Flow: FLOW_OUT
Date: Tue, 18 Aug 2026 10:40:35 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC 04/15] mm/mglru: make generation page counters atomic
Message-ID: <aoPGI__XtDJ08I96@MiWiFi-R3L-srv>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-4-4d8dad39dad6@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-mglru-fg-v1-4-4d8dad39dad6@tencent.com>
X-Rspamd-Queue-Id: 74F0A100003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: h8qphzxe4c36ayk46e5qddc4u5hhq9uz
X-HE-Tag: 1787020840-127960
X-HE-Meta: U2FsdGVkX1+MgQjt9Jf5g/ZhPjrQba8CmkP01yDdyzZ6O/ubv7865LDbmkOkn0jYaPV960fG3QnSMIVbQwVKrdweLd7lmPuMpX4HKow0YP3QDEWE7x9/IPUHUpxxTAz+ID39wdf46pac3P9IGOIQ6tN1Qd2/zAmhtJqXfK77No6jgkksBjbPMJ/eGGH2cAJJTMJd/km4gmPO9fYYfVfmRx3MXxeJDboUJcjnk+uNM4tj4/PNQ/p7tdfs18zaAZHDwAeF23U5MAuSKBMnPhfw7fk+HC0owFjp/HYG9gRTuK5LvhNRS2C/V7+mLi8LZwpQWn870komcpx2IMWysvZ1ICqLr9hh8RIc20RvFTqmAoi1hqMIrLdc+yCrlNBONR2a/rbd81BKQVng+scBV44/keYi63P2Hpey987fyC1Ldb50JAh8lmCAqaMq0apxv92dZ5BQolFDPltkzYt5CwsaRUf7vj927V0mi8zf+oS54a3IXQDlb/B3CQS2BSDMArpNOvk+jzCjZeZ60n/GMu5wRMHTnnIKNSvs0Go6dNc7SLCLVGgcN5AlcyRafv6p9lEw3Ugre08qbzSVIdF3+RV7JUWAL35+TfwAylC2S/QgdRKsurjFyV39INgwc6qQcsmMAGpRzAv4hpd0E5ws6BRcrU0lOJ8fLTC0QsWjiwvklHm2FKIYUBnNqw3yyONyUdvLhBRDXd8tHkrUv/up0klSoBsMZqMjiAXYSBIlBOW2y3W8/DEB2jjOn8enmR2Bm9sW9J0UDOnEPoQexr8yEFkc0o5Lotd6QgsLoRq/inJZQTZ8uSmDHw2xJhpXxgudYLUSKkEzSszAmcVPGibi4tx1oDHbaRR0CxO+o2dTWVRaZVYoc04GQ5m9n+9yyZBlrsU5ntR0CMUvjUjddRg7+YDTx1hY+WGE9UF3djakIgFRERG2h1PqC/R3q8H4sWu0UJDAw4ld8YhDvuTIttrVgXN
 mYiJpcve
 m7QQIoHVZ4WOqxTrzhTiX94J1+bb0Zd7V1DvV4K7p+woX9TzDFUfAx4nPDKwk8wcu10kb74s3qucs8RBcX6hZs8gLAXBc+WoBVvmaZ78iYdYEWdSQ6jPSyuo0jYcF6wSqv/FNTgx8GOknPULpQWUaACI+cWz2RqJRsRw7OYyooz/g5jWQFPuyK/myQyZmc6DCr0VgDnRJivwNfUD3/FWau5YZvpiTi2Hxd2TCdFISefx0tTl2EwLplF/Kw7oCkc1lWxAIrOP/zuAGrji5b8Hmh5Q6rhxBIisV4lsNnio3oLXh8a6MUWfqzhs7/CBzD4adj6pW8RCHDRHvm6B0Eg+nbqGZFE4IkO2SEtjCO0QDwFlMd5wl0D8qbFO56+PyO0JInBqVDVh0USxKkOjCwnKuXdO44ftP9XcjbkEWBNQECYm6WuYLhyzWk7DSsGy5d4ZhAgSMXHQUmIkV+22mUU2yo6H/wekCRQOgsQkbt51q8NwyR22E3TnZ5a5YahrlXB5WOnwg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 at 03:47am, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. There is no risk of overflow. The reader always
> compares and uses zero instead if the counter values are negative. It
> follows final consistency.

It's better to tell this is a preparation patch, and who will use them
in the coming patch or function. Otherwise we can't see why we need it
if it's no feature change.

The code change looks good to me.

> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h |  6 ++----
>  include/linux/mmzone.h    |  2 +-
>  mm/vmscan.c               | 20 ++++++++++----------
>  3 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 4076e3f7dcc8..018a2f54a5c9 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -245,11 +245,9 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
>  	VM_WARN_ON_ONCE(old_gen == -1 && new_gen == -1);
>  
>  	if (old_gen >= 0)
> -		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> -			   lrugen->nr_pages[old_gen][type][zone] - delta);
> +		atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zone]);
>  	if (new_gen >= 0)
> -		WRITE_ONCE(lrugen->nr_pages[new_gen][type][zone],
> -			   lrugen->nr_pages[new_gen][type][zone] + delta);
> +		atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zone]);
>  
>  	/* addition */
>  	if (old_gen < 0) {
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 8048c6b0544d..4225dab760ba 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -572,7 +572,7 @@ struct lru_gen_folio {
>  	/* the multi-gen LRU lists, lazily sorted on eviction */
>  	struct list_head folios[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
>  	/* the multi-gen LRU sizes, eventually consistent */
> -	long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
> +	atomic_long_t nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
>  	/* the exponential moving average of refaulted */
>  	unsigned long avg_refaulted[ANON_AND_FILE][MAX_NR_TIERS];
>  	/* the exponential moving average of evicted+protected */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f5b0a7c63a3a..b02d2ec8ff4b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3354,8 +3354,7 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
>  			continue;
>  
>  		walk->nr_pages[gen][type][zone] = 0;
> -		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
> -			   lrugen->nr_pages[gen][type][zone] + delta);
> +		atomic_long_add(delta, &lrugen->nr_pages[gen][type][zone]);
>  
>  		if (lru_gen_is_active(lruvec, gen))
>  			lru += LRU_ACTIVE;
> @@ -4044,8 +4043,8 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
>  	for (type = 0; type < ANON_AND_FILE; type++) {
>  		for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>  			enum lru_list lru = type * LRU_INACTIVE_FILE;
> -			long delta = lrugen->nr_pages[prev][type][zone] -
> -				     lrugen->nr_pages[next][type][zone];
> +			long delta = atomic_long_read(&lrugen->nr_pages[prev][type][zone]) -
> +				     atomic_long_read(&lrugen->nr_pages[next][type][zone]);
>  
>  			if (!delta)
>  				continue;
> @@ -4163,7 +4162,8 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
>  		for (seq = min_seq[type]; seq <= max_seq; seq++) {
>  			gen = lru_gen_from_seq(seq);
>  			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> -				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +				total += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
> +					     0L);
>  		}
>  	}
>  
> @@ -4598,7 +4598,7 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>  
>  	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
>  		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
> -		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
> +		long nr_pages = atomic_long_read(&child_lrugen->nr_pages[gen][type][zone]);
>  		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
>  		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
>  
> @@ -4606,9 +4606,8 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
>  		list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
>  				      &parent_lrugen->folios[gen][type][zone]);
>  
> -		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
> -		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
> -			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
> +		atomic_long_set(&child_lrugen->nr_pages[gen][type][zone], 0);
> +		atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][type][zone]);
>  
>  		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
>  			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
> @@ -5650,7 +5649,8 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
>  			char mark = full && seq < min_seq[type] ? 'x' : ' ';
>  
>  			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> -				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +				size += max(atomic_long_read(&lrugen->nr_pages[gen][type][zone]),
> +					    0L);
>  
>  			seq_printf(m, " %10lu%c", size, mark);
>  		}
> 
> -- 
> 2.55.0
> 
> 


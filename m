Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E33D4CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07966B008A; Tue, 13 Oct 2026 23:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8506B0092; Tue, 13 Oct 2026 23:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C666B0095; Tue, 13 Oct 2026 23:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3596B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:31:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F100C03FD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:31:46 +0000 (UTC)
X-FDA: 85319807412.12.46F75F6
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6A3CF40008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:31:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Os93pohr;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791948704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7BQHnCl1gEvX7JPtUvz0Jdg1gFMMCVAGeJWHXGn5Ns=;
	b=lypKCR+QRs4mnsG/n+pFlQ8oqCQ/sKS4+V+uWjums3j/s27uV275a7d5UGxRyACficqwEj
	V60yEVsRCi25sPJOUkZkOFQnU4a6nGoTFYldR+O6oFPSTWUXxVjcqGFDYKcCN4q+jtmNaF
	Q4A5mvwEi5p2r28EccGLM/MnhR6FSoA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Os93pohr;
	spf=pass (imf01.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.7 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791948704;
	b=vkbwqmEuPO4DrPU/Z4WIlc3Eb/tEnGjyCvMKDIIO9UK5ogUq2zXTkKnjI+gPCM29PRQXbx
	cebyj+Mc2ZqBSslo0k0+gKqnUHz7wi4YSfqnUHMJ0cxbb2CffPl6DKOpf7g+6zViSjdGN/
	Z5HywRaoynA/QzRJ6tJeabFkWj7gPsU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7nLeFA/bAdRYnvnosyy/9MVUz4nRvM/yvpEd+4hsF5Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791948698; v=1; x=1792553498;
 b=Os93pohrJMA3pJN/YAR6ZvupufOI3bV9hjlKE2Y9KhXa0hsDYh/qrcmrivRnMw36qvqgwL6/
 FCSzPGz3WrwuZsKrIlBvtGGao7/ZGwLaxPeOzgS62qCzrPT0XUT8ipatvKz0rrX//XAnUlyXmgo
 ryj84OjGR8K4h80s9y/2rZFE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a6e6d0226f5ae1d2;
	Wed, 14 Oct 2026 03:31:38 +0000
X-Mizu-Trace-ID: a6e6d0226f5ae1d2
X-Migadu-Flow: FLOW_OUT
Message-ID: <a64f6a98-de70-4004-aac0-312cb05aaf92@linux.dev>
Date: Wed, 14 Oct 2026 11:31:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Max Kellermann <max.kellermann@ionos.com>, akpm@linux-foundation.org,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
References: <20261012205447.2717801-1-max.kellermann@ionos.com>
 <20261012205447.2717801-4-max.kellermann@ionos.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261012205447.2717801-4-max.kellermann@ionos.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A3CF40008
X-Rspam-User: 
X-Stat-Signature: n1ikbb8k5z5xzaiyh3phdza6k74gsdpi
X-HE-Tag: 1791948703-56892
X-HE-Meta: U2FsdGVkX18ig5gQQS/IYohOTTsXPa6jusIkgr/yTi5VyhtYLFbtliLTCxZfr4Bzx3LNq2yw7KIaiVawet1+1DZ+9HZ5qeC4mnXybgUedZAXke/47R3b7ZJtxIVndjsFYThznm68JY4GsO9FepyzTRNAhRDdbU8yTQv0Ah+5uuX85kYRWkTE6qfH3XkFlc5cfqU1wlYU3k3iHxnJB/F2ooN2iKAAK+ZZr4kdQCn6XR3KDqmG1U1k5LIWIZETFVqS8kPfUdaaWUfU/vSPJgZI4oFv/t8Wy/aLYx0iykk0OAo/zAxMm/mbxUH0DFfjeoWlHJJvPR2SfzDmi6wDmDkSQWyzI2uuTGScDSPShGNsZBKvjDu2HlhVoDUoJcbCOmd5pglQnFbwow/SJ2jVODPslrv5+pSXwAUi/S7KMrtCLK/ujIZJzAxiI7ujdBvloOWYjcHt0cSbMwjshsCcaVWA/TmJKDV8UkFOr5jtdFJo5ee2Q5T7O/YHXwG9JfLc2gLd48cUUiZcm8y1REf20tVc6rF2rlbI2YFF9n6+L/zfqnr8UOPw5YRosrMASrzGjFUt/dxma94312+bHoTC6YyIY2WSHExB7tfQ3Dsa4ynSi0W9e15QFpDHuf/Cn7dRxWUsKBx3NP0pxWJYrfsjACl0zmp6iRoeN9zbsVUxAW6CrGCeE22VapdBRG+uIVT+i5nJP3UhgNvN6wDHED3398Ff68CiXyntJHaF9Y9nDulJSj5KuKqZRexrsLHpO+suZ/TPcx0FPMX5jkaibGFz8AQrTseRDjJpN+QEu3gO/Iom144t5muYIHGqFuZEjEBhPQfXZYNb5taWKTrlfS7+3prd7e4We49/r6Svhy2CI622xJnRxLyUTKsBdirp8RnEigd8dOkBuxGWSYHPdVRO3quidsXWlmzOzrQxGbNK3HBTl4b9ept4zDxVf/jTDulBkG6RbonJLhNpRAPTgvhRvDY
 pMqbIhEy
 CZkYQSp9jGxXHU3pnutBvEQFMkPl7ypQ1K31Q32nYtW6t1K3kmdgvXpAkpCl3poCS2rjJ/QkSV3AfjKcpGPqVe4JjAIu6JAyy8NR5YZkrKYUOipKsEEvV1nDjZIhO6vv/auAfcrjm+TfN/xmUygUPAmg4nrqyhoNdTYWVOTljRT3y/gmltaN1Q1sbscR5LJ0uItYM1ciukZQOoLAUf3bDrHh8nekQBTG3soq7n+FN4sJPVCNKj++j4NzA0ABqR9nvAje3uKkilvu9ChSZwe/cZq6xE2nqjXCq7PX4WQletaKqq6vcIzH+cCsCsCobAZM5NZoH6H3dE93RlgBnSQ7bPWA+4Am84fnsAhlZlqifeTKDMtvC/S6J66H4l5/0dHCuLtLN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/13/2026 4:54 AM, Max Kellermann wrote:
> Rotating or onlining a memcg currently uses hlist_nulls_add_tail_rcu()
> which walks the destination bin to find its tail while holding
> `memcg_lru.lock` with interrupts disabled.  With thousands of cgroups,
> this takes a long time and causes severe lock contention.
> 
> Cache a pointer to each bin's last node, making tail insertion O(1).
> This requires remembering the bin number (but the new struct field
> occupies a hole, so it does not grow).
> 
> In a micro benchmark that creates 1500 cgroups and repeatedly writes
> `1024M swappiness=0` to `memory.reclaim` in 8 threads, the request
> rate increases by a factor of 9.5 and the average duration of each
> write request is reduced by 89%.
> 
> All writes return EAGAIN in both runs; the benchmark measures the cost
> of reclaim attempts that cannot meet their requested target, not
> reclaimed throughput.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>   include/linux/mmzone.h |  4 ++++
>   mm/vmscan.c            | 24 +++++++++++++++++++++---
>   2 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 94f9c3ff5416..9c1c1f153d1f 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -586,6 +586,8 @@ struct lru_gen_folio {
>   	u8 gen;
>   	/* the list segment this lru_gen_folio belongs to */
>   	u8 seg;
> +	/* the memcg bin, protected by memcg_lru.lock */
> +	u8 bin;
>   	/* per-node lru_gen_folio list for global reclaim */
>   	struct hlist_nulls_node list;
>   };
> @@ -683,6 +685,8 @@ struct lru_gen_memcg {
>   	unsigned long nr_memcgs[MEMCG_NR_GENS];
>   	/* per-node lru_gen_folio list for global reclaim */
>   	struct hlist_nulls_head	fifo[MEMCG_NR_GENS][MEMCG_NR_BINS];
> +	/* last entry in each bin, or NULL if empty */
> +	struct hlist_nulls_node *tail[MEMCG_NR_GENS][MEMCG_NR_BINS];
>   	/* protects the above */
>   	spinlock_t lock;
>   };
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3d4bc12cf18e..69976df5d537 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4384,21 +4384,37 @@ static void lru_gen_add_memcg(struct lru_gen_memcg *memcg_lru,
>   			      int gen, int bin, bool at_head)
>   {
>   	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
> +	struct hlist_nulls_node *last = memcg_lru->tail[gen][bin];
>   
>   	lockdep_assert_held(&memcg_lru->lock);
>   
> -	if (at_head)
> +	lrugen->bin = bin;
> +
> +	if (at_head || !last)
>   		hlist_nulls_add_head_rcu(&lrugen->list, head);
>   	else
> -		hlist_nulls_add_tail_rcu(&lrugen->list, head);
> +		hlist_nulls_add_behind_rcu(&lrugen->list, last);
> +
> +	if (!at_head || !last)
> +		memcg_lru->tail[gen][bin] = &lrugen->list;
>   }
>   
>   static void lru_gen_del_memcg(struct lru_gen_memcg *memcg_lru,
>   			      struct lru_gen_folio *lrugen,
>   			      int gen)
>   {
> +	const int bin = lrugen->bin;
> +	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
> +
>   	lockdep_assert_held(&memcg_lru->lock);
>   
> +	/* pprev points to head->first for the only entry, otherwise prev->next. */
> +	if (memcg_lru->tail[gen][bin] == &lrugen->list)
> +		memcg_lru->tail[gen][bin] = lrugen->list.pprev == &head->first
> +			? NULL
> +			: container_of(lrugen->list.pprev, struct hlist_nulls_node, next);
> +
> +	/* Keep next intact for readers that still hold this entry. */
>   	hlist_nulls_del_init_rcu(&lrugen->list);
>   }
>   
> @@ -5883,8 +5899,10 @@ void lru_gen_init_pgdat(struct pglist_data *pgdat)
>   	spin_lock_init(&pgdat->memcg_lru.lock);
>   
>   	for (i = 0; i < MEMCG_NR_GENS; i++) {
> -		for (j = 0; j < MEMCG_NR_BINS; j++)
> +		for (j = 0; j < MEMCG_NR_BINS; j++) {
>   			INIT_HLIST_NULLS_HEAD(&pgdat->memcg_lru.fifo[i][j], i);
> +			pgdat->memcg_lru.tail[i][j] = NULL;
> +		}
>   	}
>   }
>   

Hi Max,

I've also submitted an RFC patch that addresses this issue.

https://lore.kernel.org/all/20251119083722.1365680-1-chenridong@huaweicloud.com/

-- 
Best regards
Ridong



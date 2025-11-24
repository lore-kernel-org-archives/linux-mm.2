Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE93CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 03:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC4A6B0012; Sun, 23 Nov 2025 22:53:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4D56B0022; Sun, 23 Nov 2025 22:53:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01166B0023; Sun, 23 Nov 2025 22:53:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC3056B0012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 22:53:04 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 755C0B7148
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:53:04 +0000 (UTC)
X-FDA: 84144129888.06.C5A8955
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id C552E140002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:52:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763956382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eiG+2PDmFRoLeENZZdhx+i+HDY9jkdOtfLf3cKGdR+Y=;
	b=fiHHsLYFOZzYugRgoFobAHK3t06QYyubriUWuyHciPEJGsc0RTIYBhyVE9Sr4kP17wRuRA
	8/oGwTtYKriX+vzEHkGjJ+UjsOssu4xJ67kUmjwJTGl/6s60Ik4cdQaD9YD+2XTdaZhWYv
	KNoZyO2oePfF8p8eVRTr+OitKDPJMsQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763956382; a=rsa-sha256;
	cv=none;
	b=dGGsN0VKUJy1bf6j/6bkVTzP1ZMRPBkptlfD9P/rXincc4MKkeTuxs5HZHWe+0GEYJV8j2
	KBUnETDUOr+ax20+fGUEgx0X/KaWqI4J/oOYy/Pm1yie4lhNvBas7qjqZbM0LPmPDv+joY
	DoOyOVtI0xonFPxqqoNrWMN3PRRxJEA=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dFBjF2LDLzKHMPP
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:52:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 7E4E21A1B63
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:52:52 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgCnA3qT1iNpUe1GBw--.16826S2;
	Mon, 24 Nov 2025 11:52:52 +0800 (CST)
Message-ID: <e114418f-a71c-4538-af5e-4a39bc42c04c@huaweicloud.com>
Date: Mon, 24 Nov 2025 11:52:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC -next] memcg: Optimize creation performance when LRU_GEN is
 enabled
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251119083722.1365680-1-chenridong@huaweicloud.com>
Content-Language: en-US
In-Reply-To: <20251119083722.1365680-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgCnA3qT1iNpUe1GBw--.16826S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKFy5Zw43Cw1rtFWrWw4xXrb_yoWxZr4UpF
	Z8G3sI9a95Jr13tr4aqw4DG3ZI9w18XryYvry7Ga42kr13Gry8Kw18Kr4DAFWrArZ5urs7
	WryYgw1UGayUKa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C552E140002
X-Stat-Signature: sbxp7z1pnyupzpsonypuwttc6utggi7u
X-Rspam-User: 
X-HE-Tag: 1763956377-770331
X-HE-Meta: U2FsdGVkX1+CTIjwV4VQ8mYeNzUUe0xC8l5wqirzwbyoBKYgLpouYu034J6BA7mL0uYoFPF9UvF3eZH5PU8PA/vziyuLw1nWcuoYPL0DXKydob4sOW+gTa2DbKV5sKB4+r6DE2rHqec+whhZbiN/vgQs2CBRQlFHSeS7Oaxy/6a1v3/aw0VtWb8lbBQuWtjdB5ae2OGehZJ2fevsbi9x8aCxMRkfQbhCz8CfbszSf+o+TROy0pzv+ZYSlMorPSnQmoDQZzq0cbRKUifyrO4eO/4nILjRn7WOjlPPGsdOS6zHvHFHXCl+xiG/1VBfe/zQstXM4+FBYAkF53fRFzvQeq30m/e9c7lBrK6k3UEAgrJiSzh3HuXpXIuRoPs2TA7uVSLichcgq1o6yMFqbNEO29fajsLzom2fpaV0ZRVXkflEVkcjR93ARDU0VNbsvogvOFhU8cyFW7C4z2CXM4ipEiDXT5XchIak2YT3+GVSs3nJr27u0Jj29n0LqQUNKPvT/Osyil98QzpXbSHIxfzGeBmVv6xxm/vukIdapA6PnVsNwvTGMFNQYAEe3Ul0mZBRbgYzI3kpwri5lMA+40xXTO8IB+TR0btTI6Xrh2XpNKZm4EBR4SmVVGgRE87I4wvoErzbsrukwWCW7N1auLZhaChRF5Gr+ZM/3pzQnF92TxpBTLTz0LvRvrk4LYQyoFkAhD16HgaZLyp7qVcI7FNfP1nF0YxuT2TTgcoYU9P71dtsPBDwpc7s5wrlEpU4JhB5JYBMYnFjbSATtT3hzksmX3cxuF0r2iEmJQewASSdqTIUG9d+9799dwQN1/q6rEv/DSWEfuVTduZXFm8MgzCkVu8U5pknCNDISmMnDSTPnWQAI/ZhrNySUG8o2TrBloNIeCIUGIuPSoQD2yvezJh2R80cQsVf+SfZmjhzloC/tcAC45wAhKYY+lH/e17fiYLE0m0ulx+5M/Vnm+ZJ2nq
 fQEjl5L0
 uFn8SNYN+sE3CXD/aZoCuuQm0Nw3ZDdTUzZNSPVicaw8WwxU3KRMz6SxBsrUROCeLTq/wGa/YxKFQ6sYqqbo7wKRULK6CCmXCyJfSZFw7t8nlyqmYIDET3pUAehjjK7bWiYS44VQWVrArI0NMtVjMayu0u/FzJp1MeS4M4+MuXrCvnnK5S4JwFKCGdqhY/ha059aFe/OYkRgUli4dza+fZxCw8FbviyG5d14B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/19 16:37, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> With LRU_GEN=y and LRU_GEN_ENABLED=n, a performance regression occurs
> when creating a large number of memory cgroups (memcgs):
> 
> 	# time mkdir testcg_{1..10000}
> 
> 	real	0m7.167s
> 	user	0m0.037s
> 	sys	0m6.773s
> 
> 	# time mkdir testcg_{1..20000}
> 
> 	real	0m27.158s
> 	user	0m0.079s
> 	sys	0m26.270s
> 
> In contrast, with LRU_GEN=n, creation of the same number of memcgs
> performs better:
> 
> 	# time mkdir testcg_{1..10000}
> 
> 	real	0m3.386s
> 	user	0m0.044s
> 	sys	0m3.009s
> 
> 	# time mkdir testcg_{1..20000}
> 
> 	real	0m6.876s
> 	user	0m0.075s
> 	sys	0m6.121s
> 
> The root cause is that lru_gen node onlining uses hlist_nulls_add_tail_rcu,
> which traverses the entire list to find the tail. This traversal scales
> with the number of memcgs, even when LRU_GEN is runtime-disabled.
> 
> Fix this by adding a per-lru_gen tail pointer to track the list's tail.
> Appending new nodes now uses the tail pointer directly, eliminating full
> list traversal.
> 
> After applying this patch, memcg creation performance with LRU_GEN=y
> matches the fully disabled baseline:
> 
> 	#time mkdir testcg_{1..10000}
> 
> 	real	0m3.368s
> 	user	0m0.025s
> 	sys	0m3.012s
> 
> 	# time mkdir testcg_{1..20000}
> 	real	0m6.742s
> 	user	0m0.085s
> 	sys	0m5.995s
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>  include/linux/mmzone.h |  4 +++
>  mm/vmscan.c            | 78 ++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 75 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 4398e027f450..bdee57b35126 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -513,6 +513,8 @@ struct lru_gen_folio {
>  	u8 gen;
>  	/* the list segment this lru_gen_folio belongs to */
>  	u8 seg;
> +	/* the bin index this lru_gen_folio is queued on */
> +	u8 bin;
>  	/* per-node lru_gen_folio list for global reclaim */
>  	struct hlist_nulls_node list;
>  };
> @@ -610,6 +612,8 @@ struct lru_gen_memcg {
>  	unsigned long nr_memcgs[MEMCG_NR_GENS];
>  	/* per-node lru_gen_folio list for global reclaim */
>  	struct hlist_nulls_head	fifo[MEMCG_NR_GENS][MEMCG_NR_BINS];
> +	/* cached tails to speed up enqueueing */
> +	struct hlist_nulls_node *tails[MEMCG_NR_GENS][MEMCG_NR_BINS];
>  	/* protects the above */
>  	spinlock_t lock;
>  };
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8890f4b58673..6c2665e48f19 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4299,6 +4299,66 @@ enum {
>  	MEMCG_LRU_YOUNG,
>  };
>  
> +static void memcg_lru_add_head_locked(struct pglist_data *pgdat,
> +				      struct lruvec *lruvec, int gen, int bin)
> +{
> +	struct lru_gen_memcg *memcg_lru = &pgdat->memcg_lru;
> +	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
> +	struct hlist_nulls_node *node = &lruvec->lrugen.list;
> +	bool empty = !memcg_lru->tails[gen][bin];
> +
> +	hlist_nulls_add_head_rcu(node, head);
> +	lruvec->lrugen.bin = bin;
> +
> +	if (empty)
> +		memcg_lru->tails[gen][bin] = node;
> +}
> +
> +static void memcg_lru_add_tail_locked(struct pglist_data *pgdat,
> +				      struct lruvec *lruvec, int gen, int bin)
> +{
> +	struct lru_gen_memcg *memcg_lru = &pgdat->memcg_lru;
> +	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
> +	struct hlist_nulls_node *node = &lruvec->lrugen.list;
> +	struct hlist_nulls_node *tail = memcg_lru->tails[gen][bin];
> +
> +	if (tail) {
> +		WRITE_ONCE(node->next, tail->next);
> +		WRITE_ONCE(node->pprev, &tail->next);
> +		rcu_assign_pointer(hlist_nulls_next_rcu(tail), node);
> +	} else {
> +		hlist_nulls_add_head_rcu(node, head);
> +	}
> +
> +	memcg_lru->tails[gen][bin] = node;
> +	lruvec->lrugen.bin = bin;
> +}
> +
> +static void memcg_lru_del_locked(struct pglist_data *pgdat, struct lruvec *lruvec,
> +				 bool reinit)
> +{
> +	int gen = lruvec->lrugen.gen;
> +	int bin = lruvec->lrugen.bin;
> +	struct lru_gen_memcg *memcg_lru = &pgdat->memcg_lru;
> +	struct hlist_nulls_head *head = &memcg_lru->fifo[gen][bin];
> +	struct hlist_nulls_node *node = &lruvec->lrugen.list;
> +	struct hlist_nulls_node *prev = NULL;
> +
> +	if (hlist_nulls_unhashed(node))
> +		return;
> +
> +	if (memcg_lru->tails[gen][bin] == node) {
> +		if (node->pprev != &head->first)
> +			prev = container_of(node->pprev, struct hlist_nulls_node, next);
> +		memcg_lru->tails[gen][bin] = prev;
> +	}
> +
> +	if (reinit)
> +		hlist_nulls_del_init_rcu(node);
> +	else
> +		hlist_nulls_del_rcu(node);
> +}
> +
>  static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
>  {
>  	int seg;
> @@ -4326,15 +4386,15 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
>  	else
>  		VM_WARN_ON_ONCE(true);
>  
> +	memcg_lru_del_locked(pgdat, lruvec, false);
> +
>  	WRITE_ONCE(lruvec->lrugen.seg, seg);
>  	WRITE_ONCE(lruvec->lrugen.gen, new);
>  
> -	hlist_nulls_del_rcu(&lruvec->lrugen.list);
> -
>  	if (op == MEMCG_LRU_HEAD || op == MEMCG_LRU_OLD)
> -		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
> +		memcg_lru_add_head_locked(pgdat, lruvec, new, bin);
>  	else
> -		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
> +		memcg_lru_add_tail_locked(pgdat, lruvec, new, bin);
>  
>  	pgdat->memcg_lru.nr_memcgs[old]--;
>  	pgdat->memcg_lru.nr_memcgs[new]++;
> @@ -4365,7 +4425,7 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg)
>  
>  		lruvec->lrugen.gen = gen;
>  
> -		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[gen][bin]);
> +		memcg_lru_add_tail_locked(pgdat, lruvec, gen, bin);
>  		pgdat->memcg_lru.nr_memcgs[gen]++;
>  
>  		spin_unlock_irq(&pgdat->memcg_lru.lock);
> @@ -4399,7 +4459,7 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
>  
>  		gen = lruvec->lrugen.gen;
>  
> -		hlist_nulls_del_init_rcu(&lruvec->lrugen.list);
> +		memcg_lru_del_locked(pgdat, lruvec, true);
>  		pgdat->memcg_lru.nr_memcgs[gen]--;
>  
>  		if (!pgdat->memcg_lru.nr_memcgs[gen] && gen == get_memcg_gen(pgdat->memcg_lru.seq))
> @@ -5664,8 +5724,10 @@ void lru_gen_init_pgdat(struct pglist_data *pgdat)
>  	spin_lock_init(&pgdat->memcg_lru.lock);
>  
>  	for (i = 0; i < MEMCG_NR_GENS; i++) {
> -		for (j = 0; j < MEMCG_NR_BINS; j++)
> +		for (j = 0; j < MEMCG_NR_BINS; j++) {
>  			INIT_HLIST_NULLS_HEAD(&pgdat->memcg_lru.fifo[i][j], i);
> +			pgdat->memcg_lru.tails[i][j] = NULL;
> +		}
>  	}
>  }
>  
> @@ -5687,6 +5749,8 @@ void lru_gen_init_lruvec(struct lruvec *lruvec)
>  
>  	if (mm_state)
>  		mm_state->seq = MIN_NR_GENS;
> +
> +	lrugen->bin = 0;
>  }
>  
>  #ifdef CONFIG_MEMCG

Hello all,

Is anyone interested in this issue?

Any better ideas or suggestions are welcome.

-- 
Best regards,
Ridong



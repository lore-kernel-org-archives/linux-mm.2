Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B92E01088E62
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 01:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4BEB6B03A3; Wed, 18 Mar 2026 21:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5CF6B03A4; Wed, 18 Mar 2026 21:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9DC46B03A5; Wed, 18 Mar 2026 21:40:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3F196B03A3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:40:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C82E1C794
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:40:33 +0000 (UTC)
X-FDA: 84561107946.23.FDC0E6B
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4FB8E40013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:40:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773884431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tjUYeZpRs970Jc3wj/ZWdp0NvCSkf0+RuI1NIqYglPM=;
	b=bPrAQbbYQZL/UpGmx5f198g51E83Jru3wwUULBIV/5k91JcrguoYKcAV0SQDnmNDl5NxjQ
	odivRwrPLfNfSzAmWCj7Oqo5+7UAFp5TYIqGdyhm0655VITBTWe+/QTUwLqV0CJiwJ5nW/
	EJE16CfGZ8+tjzQN9YDKZrgdGM6cKWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773884431; a=rsa-sha256;
	cv=none;
	b=gNdiZu/9vsl0yJJ38Ai9hSVMXPGCMXHXSdEr27BaNj57S7mdNpMg/MqhQxfU0EKjYGi0Mh
	LH231iZXlISU/gkh5e73Qq5B59Qi+Aw8Sxlh30FPtPE/WcyfhgKb0hWt1I8Ym+RLHtUTJ2
	PNOdFL+Sd0HZGA+RjFwoNxGvlnVtjNI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fbpKQ0hb2zKHMKg
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:39:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id ABBD340570
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:40:22 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgAnBVIFVLtpEyeiBQ--.15013S2;
	Thu, 19 Mar 2026 09:40:22 +0800 (CST)
Message-ID: <9f982344-1137-4d8a-9186-b1b130dc15a6@huaweicloud.com>
Date: Thu, 19 Mar 2026 09:40:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm/mglru: consolidate common code for retrieving
 evitable size
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>,
 Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260318-mglru-reclaim-v1-1-2c46f9eb0508@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgAnBVIFVLtpEyeiBQ--.15013S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF1rCr4fuw1UZr4xXr43ZFb_yoWrZF1UpF
	Z8Cay2krZ3Xry3trZI9r4kZry3A3yftryUJrZ7A34SkF13tF97tw17C34xKryUurWDur1S
	v39rKF1UCw4qqFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspam-User: 
X-Stat-Signature: x5qicffy3x85jrmwu8wbpbqpmejnb7dx
X-Rspamd-Queue-Id: 4FB8E40013
X-Rspamd-Server: rspam03
X-HE-Tag: 1773884427-842921
X-HE-Meta: U2FsdGVkX18tOn9lILDAMaJmnCbt6S+/7hcSBjX7kRJ4guWmjNoa5z2a5QA+wN8/kpaO+2mKgN5OmyTg1/HYuW70AEXD0zzQSk7ejzxX2s4vvMD/+uXCXoyhkHHl2oMSe58ZTeFf3pd+L8o102Zm+YIdAofSzxtURa5C+b9UNKx3D9osB8goxe6NzKi4pKSCptKUhjlD0m7wHFwC562hxNrzCwJuKdL9rkIaQLfytoNBobD5rtCxwJmMyi7uxSifaIzJqF5ljg9N3BvJn7l0nAcp7tM6BfY8HSbpynIamp0GDkTcnocG7jm4uT74yM8ss7Dw4YRN0s1oOkeyosnzvB2wYaaw12+AY0Qc7b3IpfpKeiTVE+/RM9XKc/ozswDoWGDJHwTcS8QeRirNZk88iP0cgKJVsk6utyVz2RsVDnaHnf3xLl4f3qzl4hNo+uRRoInxrMwhqU5GC6QNkTqTyQ/McInTpsJaZ5zocM2Af4TLxqJULCIZZG960XrWrbAsBUhAhxai+46x/asXUSHPJJYBqzNA+Xwbw5MrJ+Fzht8xHoowu7HoTgFY9YEvL5PjMKY8cdHGGeVrVEnoGokIdM/KnxUYE+CUJWWgGj6qf5Sz23L7zp9wqCp4Ut6H7XhhLK/3bE3/ERjeoimUw4UA1kkNrdqxzWSfCQgKIVmvzd2US/0B8ODXlUJ/potit+/MJJYzdvOMKQ1BduRObzU/o4+UfY5H1twINBkQlG2Ja9fdqcmmMvhE0EZIrS0KGq1p7B85+nliHTNv0gu8QcPZNzmLmPbi1S8qwarTSi/PfWrZD+dUkPrUZRZre595XVqB5bUqSz6dx1AZX0k21O8pDr2NF4g7g6izkZwT6ABOhKoThF8bnEU3fugQEQgHIUAkCAAYDUZQnM5P6TrvuT6CJisn5jE8fpkU9AYmGJDZDX0GRHs+I/Wfpx5oDQYX5d+RouaHvmHq5p8VqxevZ32
 Adq/il+B
 Y9W6zzMx1oJQK6ZTq3TR8j/GejQMBmI4fX/4k/lVFLplJM8gRXsghFVxfEeakKKPIyBrfs/Oi/c/dq68kKIuHChlDfEnTDoxkuvdrmIo7vqTVWJCiXWooRwsOIdvsJ0baRWFjkSX/ChknPfPOioOzqwt4et66aC3i5nepclSe/qTgEjdl00EZM5y0c26+hA1srFR5ar/4e9poRl95GvaWDEMUXPYos9/YWUtkpWtXceJEoow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/18 3:08, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Merge commonly used code for counting evictable folios in a lruvec.
> 
> No behavior change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

> ---
>  mm/vmscan.c | 42 +++++++++++++++++-------------------------
>  1 file changed, 17 insertions(+), 25 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..d7fc7f1fe06d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4078,27 +4078,33 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
>  	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
>  }
>  
> -static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
> +static long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
>  {
>  	int gen, type, zone;
> -	unsigned long total = 0;
> -	int swappiness = get_swappiness(lruvec, sc);
> +	unsigned long seq, total = 0;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
> -	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  	DEFINE_MAX_SEQ(lruvec);
>  	DEFINE_MIN_SEQ(lruvec);
>  
>  	for_each_evictable_type(type, swappiness) {
> -		unsigned long seq;
> -
>  		for (seq = min_seq[type]; seq <= max_seq; seq++) {
>  			gen = lru_gen_from_seq(seq);
> -
>  			for (zone = 0; zone < MAX_NR_ZONES; zone++)
>  				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
>  		}
>  	}
>  
> +	return total;
> +}
> +
> +static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
> +{
> +	unsigned long total;
> +	int swappiness = get_swappiness(lruvec, sc);
> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> +
> +	total = lruvec_evictable_size(lruvec, swappiness);
> +
>  	/* whether the size is big enough to be helpful */
>  	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
>  }
> @@ -4921,9 +4927,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
>  			     int swappiness, unsigned long *nr_to_scan)
>  {
> -	int gen, type, zone;
> -	unsigned long size = 0;
> -	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	DEFINE_MIN_SEQ(lruvec);
>  
>  	*nr_to_scan = 0;
> @@ -4931,18 +4934,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
>  	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
>  		return true;
>  
> -	for_each_evictable_type(type, swappiness) {
> -		unsigned long seq;
> -
> -		for (seq = min_seq[type]; seq <= max_seq; seq++) {
> -			gen = lru_gen_from_seq(seq);
> -
> -			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> -				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> -		}
> -	}
> -
> -	*nr_to_scan = size;
> +	*nr_to_scan = lruvec_evictable_size(lruvec, swappiness);
>  	/* better to run aging even though eviction is still possible */
>  	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
>  }
> @@ -4954,7 +4946,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
>   */
>  static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
>  {
> -	bool success;
> +	bool need_aging;

I have suffered a lot because of this name. Thank you.

>  	unsigned long nr_to_scan;
>  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  	DEFINE_MAX_SEQ(lruvec);
> @@ -4962,7 +4954,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
>  	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
>  		return -1;
>  
> -	success = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
> +	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
>  
>  	/* try to scrape all its memory if this memcg was deleted */
>  	if (nr_to_scan && !mem_cgroup_online(memcg))
> @@ -4971,7 +4963,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
>  	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
>  
>  	/* try to get away with not aging at the default priority */
> -	if (!success || sc->priority == DEF_PRIORITY)
> +	if (!need_aging || sc->priority == DEF_PRIORITY)
>  		return nr_to_scan >> sc->priority;
>  
>  	/* stop scanning this lruvec as it's low on cold folios */
> 

-- 
Best regards,
Ridong



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 296E3FF492D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 01:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4538B6B0092; Sun, 29 Mar 2026 21:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BB26B0095; Sun, 29 Mar 2026 21:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3680A6B0096; Sun, 29 Mar 2026 21:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27C5A6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:57:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA4DFBA8ED
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:57:23 +0000 (UTC)
X-FDA: 84601067166.05.489D426
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 756F5100004
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:57:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774835842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DgzQs6FR+q7kw1pq69FqeWlK9u4/6CvPCjrTlYhfE8Y=;
	b=Wf34qoLjh3tHLizlQ8iq8oJI7ICYax2XDVzna3RxHLJF89S7c85OMY9hWRzNdhlcnZLHyL
	DXzIs1S03aJ497ZUKo/KB8pRRIEdfrDwHtnXZ30nwKLSqsbkBtHaVvfSRzH1Q7gG+YuCR7
	rId/qwYkmH6Hh0HVSI+pWxtZMCvsVDE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774835842; a=rsa-sha256;
	cv=none;
	b=7t8uSViLEDY24ZMmJNab/W6OyRR8q4pU/wqa0zjgPlmlxt+M2FeoOcQOm2q5wDF4DPuSS1
	StG9f98PicrD1d4U8v6M9teZrPTEmBSrPqYIaU0JpKjGT/FjH1PVOlYrwzjEonCu2ZXAFP
	Ufmwx2yXx+zrJepuayy5Ugqor65+dc0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fkZ9P2qmRzKHMMT
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:56:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 3726140593
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:57:11 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgBnk1B22MlpprzMCg--.50062S2;
	Mon, 30 Mar 2026 09:57:11 +0800 (CST)
Message-ID: <0334f1bd-8f76-4531-8c1c-d6bcba9a0b87@huaweicloud.com>
Date: Mon, 30 Mar 2026 09:57:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/12] mm/mglru: rename variables related to aging and
 rotation
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
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260329-mglru-reclaim-v2-0-b53a3678513c@tencent.com>
 <20260329-mglru-reclaim-v2-2-b53a3678513c@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260329-mglru-reclaim-v2-2-b53a3678513c@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgBnk1B22MlpprzMCg--.50062S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF18GryrCFW8uw1kKFy7trb_yoW5Cr47pF
	WDCayUArWrJrWYg3WSyFsY9a43A3yftry8JryIyw1fGF1SgFyfJw12kry8tFyUu3s3uF1f
	Z3yjk3W8Gw4jqFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	bAw3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 756F5100004
X-Stat-Signature: 8p6t5wh6qxibo5aao4hoc8p6t51k1bjj
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774835836-124577
X-HE-Meta: U2FsdGVkX18kW7L1+WNWTqBwWpWzJTRbHv3ywQR1krAdRHOKZfz6J6NYtOTMrIG/u45ZMC3C4DMizUeHpFBlHbNAZ4NRlQcCRqc7lOh8RCwP6AR+ped8QiDOAmZwvqCcI1w/AMOiezcbL24dGNBV+N0VNcXiSrz0hn2QcdCLWXpT4bFnD/IWlktmi7XzB3k+hB9tI8CnshHgY/lhV5pHALQVO3qqf77J1f9M+Hw/Be+0zmd4Zdn2jmvyBZOZTlrDRnk+aQL6PA7eA8X5XEjq6QgR63PEka0T5ly+4CBnHafg/+hLQyWWetA92LK08t3K4vS7TnYdEWKjbFhVN6a5YX1hwTUqe5+kT8Lshi+4YDNysIUK7uxoldAcRT0NcDW5we3lM+d1tNshdrRkvuSCPcSdbotq6hBOUakhR0jiobbpsSfdkH7+/KaLPsimlEtfUe7OI9VwjhSCL/bErct67ReFUYlXnmLPw3Np/JMg2cbf2i2Cef/k8odrczJTAuzUBpmoZpg5Uvm0MkPx0+1GCG6+7lR/W2Uhuc+Y3G6R4XBGKSp3el3u7xJgQVdP+QjyLIrK+fSbm3uCY+fhszDbVCGUjKvvGQAPdC/j+v9uwZaN1gCjqdimhHqUAU7kNHSM6y2Ef7tsHzasCWVz8eT9y27//1pncNlDbQv3+/2cSFQbHdNP4QujJtuaXMh1U+VjzsuC/XYBEWw43j9JBsTOlzT350Dnp7ADisZgQnTl3cZDXkZHJ0QBTD+LFFh6Qn8SdQm78aU+5/L6VWVMnz0o94RC4TBNj3+MArQfSdwEv0r7lO1eYOANyPH52z7W3afMCKZfv7feNzxvalZQozOj71ZXY3J3xRyS5DO6gydQ19CN8P449qvu7TOszkeBsJArVycEDe5HUkepOZU90xW9EZfIprcDvJw7ThjNukZqk+1EJ3gyaEoUTS0sKu29MhTjPfRJGDRo7goPedubi1Q
 I5Z7nAPG
 nowuzLsyWMMX1oapIQoZAJ5UUQPtdafR29aVlOqvUagQ+9a/+W68IU0JeQygQdXeo0eDtyMnB0vWengoe+SE/lp9vE6oJ81J91URZepfPwjcpvHqUabxV93Nv8gh15hba2o97AljhXYPj8ohGWhqDOquf6msR3Eif647yHhW06wsBO04/LISIqImA2y9t6xGtRJM3/Sc/Uq4zXMWFNGwAr7aFCPxXaUk81hN9jtJNQZUWM36KFj6ZBE2Rbpq9QqKnX9C6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/29 3:52, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current variable name isn't helpful. Make the variable names more
> meaningful.
> 
> Only naming change, no behavior change.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index adc07501a137..f336f89a2de6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4934,7 +4934,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
>   */
>  static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
>  {
> -	bool success;
> +	bool need_aging;
>  	unsigned long nr_to_scan;
>  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>  	DEFINE_MAX_SEQ(lruvec);
> @@ -4942,7 +4942,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
>  	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
>  		return -1;
>  
> -	success = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
> +	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
>  
>  	/* try to scrape all its memory if this memcg was deleted */
>  	if (nr_to_scan && !mem_cgroup_online(memcg))
> @@ -4951,7 +4951,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int s
>  	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
>  
>  	/* try to get away with not aging at the default priority */
> -	if (!success || sc->priority == DEF_PRIORITY)
> +	if (!need_aging || sc->priority == DEF_PRIORITY)
>  		return nr_to_scan >> sc->priority;
>  
>  	/* stop scanning this lruvec as it's low on cold folios */
> @@ -5040,7 +5040,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  
>  static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  {
> -	bool success;
> +	bool need_rotate;
>  	unsigned long scanned = sc->nr_scanned;
>  	unsigned long reclaimed = sc->nr_reclaimed;
>  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> @@ -5058,7 +5058,7 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  		memcg_memory_event(memcg, MEMCG_LOW);
>  	}
>  
> -	success = try_to_shrink_lruvec(lruvec, sc);
> +	need_rotate = try_to_shrink_lruvec(lruvec, sc);
>  
>  	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
>  
> @@ -5068,10 +5068,10 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
>  
>  	flush_reclaim_state(sc);
>  
> -	if (success && mem_cgroup_online(memcg))
> +	if (need_rotate && mem_cgroup_online(memcg))
>  		return MEMCG_LRU_YOUNG;
>  
> -	if (!success && lruvec_is_sizable(lruvec, sc))
> +	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
>  		return 0;
>  
>  	/* one retry if offlined or too small */
> 

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25189105D9AC
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 09:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234516B009B; Wed,  8 Apr 2026 05:32:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B756B009D; Wed,  8 Apr 2026 05:32:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 121AA6B009E; Wed,  8 Apr 2026 05:32:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3D526B009B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 05:32:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A43121A0A8B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:32:28 +0000 (UTC)
X-FDA: 84634873176.01.56EF972
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id A09D340004
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:32:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775640746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SWjtnMgZoeasyrNY7V1zJ8cVg/oywv2EZTEtMrFO3eY=;
	b=U68R5CDq6V3Cp7zCs6VAR+pX7aTVW0H8Y+450kiBe9rk7KtZOc2oxpSaNf0guBv729nMim
	R2Gh7I1AHwUeQCjXBTuCAYQtnC0gxBoHiUU1aNTzPz2tdo0r9yQMXvkfdxJlJttKqxD+0X
	zSbVkr3ZuPurAXvv6nFGQqC/tBjoS4E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775640746; a=rsa-sha256;
	cv=none;
	b=dOO0KbnLdTPE5Aq0SILQDXWs1b3mZrfrn6VuxjCQbmsjHSy+RTGbynGHSbS8tc56MpKIdT
	QD58TNLGLCkZIBJyfyk0sxDvnKyYEvVXPRvoNCAewPWGO7JGH9lAJQh94pSC53oSP2voRj
	QzZMN5MeQ9BOlU5Pc2w9yAi2NrJ76F0=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4frHr813qbzKHMYX
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:31:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 931E34057D
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:32:20 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgCngEujINZpbMVlDw--.41855S2;
	Wed, 08 Apr 2026 17:32:20 +0800 (CST)
Message-ID: <41c80e21-44f1-475c-9708-b088fcf0d0e5@huaweicloud.com>
Date: Wed, 8 Apr 2026 17:32:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/14] mm/mglru: don't abort scan immediately right
 after aging
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
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
 <20260407-mglru-reclaim-v4-7-98cf3dc69519@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260407-mglru-reclaim-v4-7-98cf3dc69519@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCngEujINZpbMVlDw--.41855S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF15CrW8Cr43JF43Zw48Xrb_yoWrJFWxpa
	93Ga17AF4kJr1aqanIkw409r1S93y8Gr45J345ury8C3y3tFyft34akr1YvFy5Awn5Z3y3
	XF4YgF18W3WjvFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Queue-Id: A09D340004
X-Stat-Signature: k78w3ctwsz1qgzz44gco4w3xrq5apuwc
X-Rspamd-Server: rspam06
X-HE-Tag: 1775640744-937740
X-HE-Meta: U2FsdGVkX19sj0EO0ll/Cq7gDzw83Aq8qy4EbUyy5qrTISuBP0EIzBBs3joeb9lXgKoBjWT241762qAu44/eEtOgb7AbwjQUAUDOjh3FWcETTEC/IpHWpxnwFkx7UwEsCtP+C/WI+cdoLSLBIsLhbyB7lhR0gL1h3XKcuJWB1L4dOQTvk+sR0jxKoVnYPcd+QOuXlzHUtGtQpF3ZSPTfHHfAZFa7vBsrRpPiTZ9T1o1/JNubx6q1cDFVO8Rt9FIRnTADkyaomxv1VQp4GIzha+D6W1a7X+xsxDsC7YKJUpUbqfvOg8hAd/jx8lkZgTQ3FJtO5xF2hNwr0n4nAsaLsM04zmP54AnlPcDWhXD2BdB8X8F8mnUiXUDzhiXHzeLiq0YZ7gNJA0zQbP0IJoHEJehQZ35Eowuz5tjNNzYEdCsFKSbMSqAddqA+pqWErFf9iIzn6+RVsb4XuM1IUDseonuFIrAtpeupAHc3aAqkvC+061zSnAtdY6x+tWCenIduOtCRy+7aIznpLdVkAmBu+aru42yISTTfsebcwaDcj1THEdm0ZKuI8jvpFUGQooNxLcQblqbxRaBlFF7iGhQHR6UPiiU6TRrByYAzcHiCAcIFL/FQHSWiK3DI8seh4XC2P+G0OrSW621CPEd0AKykU1R8gejpTrIgA8uSkwLQpThzj3AZAIWEuBpNcSDtz3oubGjCXJE6egk5ADvw6In4inh0Idys3NzfFJNuPaL6wWhGVmZ2fnKxMiEWp0P5SYt/QZ4NLLa13aGTNiA4DIgrqPfYoHC2LOxw2W7A4ZfhC1hwWQlA6kok8cIZC9vr/k2WbfWd8Dlrv4gS19ROwhk+WeH4uzHUOJTfE3p12g2iedTa71s0n/SlOcrzjHdGTVMeZEyrS9xxeCjg9FUDtqHr/8xHGrb8h2B+Ko/vHOxkvq485t4PoGJ+1PoIDxIsmwL3dBopTZ6PVAPgW6JQ4XN
 /wuBF0/I
 vDZR//mD8fvpaJKkZ0g/N+QuY1Cc6bT/QLZ5Be1W/7K2agCSHIuv9fM6kzspEQMTReyu9MqkratZigXnmKxOAFG45Cm+1dWgz5DNVSY1vniZDoDKHprLmuDtByqsBXoazg7ivQgAxMHKBycotk7c6o+sBWl/teNxlQk0F8UhPJR5FFazmXqNAMk1DzGpkCuhmHLcu5Ep17foVKUTaunICFpBCQciGmT7iJlcApjR60+fmKBbWXpElZmJGt013Gb9G1GkN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/7 19:57, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Right now, if eviction triggers aging, the reclaimer will abort. This is
> not the optimal strategy for several reasons.
> 
> Aborting the reclaim early wastes a reclaim cycle when under pressure,
> and for concurrent reclaim, if the LRU is under aging, all concurrent
> reclaimers might fail. And if the age has just finished, new cold folios
> exposed by the aging are not reclaimed until the next reclaim iteration.
> 
> What's more, the current aging trigger is quite lenient, having 3 gens
> with a reclaim priority lower than default will trigger aging, and
> blocks reclaiming from one memcg. This wastes reclaim retry cycles
> easily. And in the worst case, if the reclaim is making slower progress
> and all following attempts fail due to being blocked by aging, it
> triggers unexpected early OOM.
> 
> And if a lruvec requires aging, it doesn't mean it's hot. Instead, the
> lruvec could be idle for quite a while, and hence it might contain lots
> of cold folios to be reclaimed.
> 
> While it's helpful to rotate memcg LRU after aging for global reclaim,
> as global reclaim fairness is coupled with the rotation in shrink_many,
> memcg fairness is instead handled by cgroup iteration in
> shrink_node_memcgs. So, for memcg level pressure, this abort is not the
> key part for keeping the fairness. And in most cases, there is no need
> to age, and fairness must be achieved by upper-level reclaim control.
> 
> So instead, just keep the scanning going unless one whole batch of
> folios failed to be isolated or enough folios have been scanned, which
> is triggered by evict_folios returning 0. And only abort for global
> reclaim after one batch, so when there are fewer memcgs, progress is
> still made, and the fairness mechanism described above still works fine.
> 
> And in most cases, the one more batch attempt for global reclaim might
> just be enough to satisfy what the reclaimer needs, hence improving
> global reclaim performance by reducing reclaim retry cycles.
> 
> Rotation is still there after the reclaim is done, which still follows
> the comment in mmzone.h. And fairness still looking good.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c673830f4ba8..354c6fef3c42 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4979,7 +4979,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>   */
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  {
> -	bool need_rotate = false;
> +	bool need_rotate = false, should_age = false;
>  	long nr_batch, nr_to_scan;
>  	int swappiness = get_swappiness(lruvec, sc);
>  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> @@ -5000,7 +5000,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
>  			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
>  				need_rotate = true;
> -			break;
> +			should_age = true;
>  		}
>  
>  		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
> @@ -5011,6 +5011,10 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  		if (should_abort_scan(lruvec, sc))
>  			break;
>  
> +		/* For cgroup reclaim, fairness is handled by iterator, not rotation */
> +		if (root_reclaim(sc) && should_age)
> +			break;
> +
>  		nr_to_scan -= delta;
>  		cond_resched();
>  	}
> 

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong



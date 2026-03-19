Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DC491088E5E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 02:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81276B03AB; Wed, 18 Mar 2026 22:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32166B03AC; Wed, 18 Mar 2026 22:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920366B03AD; Wed, 18 Mar 2026 22:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1196B03AB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:00:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3082D5830E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:00:24 +0000 (UTC)
X-FDA: 84561157968.04.DB44749
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8701C000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:00:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773885622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J0OejHYfnW7j+5W75xnadmTlmZ5CdrUsZH5XW8+Apbc=;
	b=ot/vtT0gJups3dYi9IPG437EASIwUkwk89CXPjqGPir1aW8VTnFi3NG3NL6r5AaO8dt/2n
	CT/6thZRFlK9LjFIG0WOOmxICA9j1v0ExGApp2bBIK4UTmt+sVCQrqycYOtVCLhPTbUO0x
	jCWdH4KtxfNrG1TZhd50+zf4T8Rc4uM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773885622; a=rsa-sha256;
	cv=none;
	b=nbv3xOZfuOcL5DcmyGQIP6wmYS1cEf9T+99aGUaX6L3pKb2t2/Egow4ClrV5UJITyCZesL
	XyD79rPU5VJ70RfnD7uH5hzAypaW6tvhx4EKajU4Rb6JibB8wGy2+UQiUi+Q3A2LFRmlVP
	rbjB4zgZ8M4nX0H+eWKbSSWHTlKbiyI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fbpmK3M4BzKHMJy
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:59:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1A2954056E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:00:14 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgCnf0qsWLtpemy2BQ--.22894S2;
	Thu, 19 Mar 2026 10:00:13 +0800 (CST)
Message-ID: <013e34b3-abf4-4794-8cc3-d6735d4fb156@huaweicloud.com>
Date: Thu, 19 Mar 2026 10:00:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] mm/mglru: relocate the LRU scan batch limit to
 callers
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
 <20260318-mglru-reclaim-v1-2-2c46f9eb0508@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260318-mglru-reclaim-v1-2-2c46f9eb0508@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCnf0qsWLtpemy2BQ--.22894S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF18tF1kGr1kXF1kKr15Jwb_yoWrXr1UpF
	WDCw42yrW8JrW3KFZ3Xr4kuF43CFWrKryUJrWSvr1akFyaqFyfG342k347trWUury8AF10
	vasrGF48Wa4jqFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D8701C000E
X-Stat-Signature: 8ieod9i6rndxai95dr3xtkd981hbgn4u
X-Rspam-User: 
X-HE-Tag: 1773885618-371982
X-HE-Meta: U2FsdGVkX19J7bCvZaKRObgoGKhIEI4kiOC5C1/c35RG++l9uLhwKkkh5ZQsv7Y3/PpwZ53cUN8AI1NQNDee/zXowshDwpZBLJF6mzVPpneEP3bhhxs/Dw0XSnJmUY7BcvBVcnAtgN0fJJl1/P9u0eN+OLkqKWzHDP3Ac/YcoCZbuHGDz44u8ZwyjYBExLaeJ+q33MZmcPDQMPZuonwZyW/ZaM9U+4Ygqs5Mvo5SBXudQsX88W1RZSgbw+jevjJowdoLP53HvqPigTlW2o0dyUdChQ2zzAf4QGueoa+aqMpLry2BTXu3kWLKTn1S/QrAmISriFuA0AmTaiVIwufkrTn5GjYPRHvuMlzxHnZHyPWFLespCUYGhK1uQ3u8pMHz22KtsUV1x210jHTUg6cTNvK0bPu20+OLk/yR1AT3F8Wxz6Jni2ESoQlFgsnd93jRnWbjT4rtGi5xeOvKkpp9rU7irEEHfYoYALlglRyAataev8hQ3eE8L8431ruBzBq/9/hkJE9fiGQLzH5qbX7S0SQdpNEppqqMEwaxpelCNoanrIssZHBst/uxrViWkiwUWsbukJxt7bNlh/iNsp7fHiw6ApqJF9sPP+BFaT8tDuKoYOyhQ6XVlja8rPg+QyAP+gn6z+K7tHD9p5gHhWttYzIRmzDkIa9LJzlhZDpmLvyTvZIl5xGzdabNm/r3rVbOIJZoT6BPxazQA8XnWcvwFr6NtXEv41rGMnp9AMA/EwaXDIxzyi5NxyxiosUWMi7IMiBuZ86MUofYZaUN2uEQRZXuZJGP8otGuILtuv75AJZemThVfCkibPQdtwHAzLtFwgj9xZxRgaBZJFbqvKg0LF9FQZdIAUPJ/ATcNLXmPAMbixEZTyN8PDmcTypq3bcCo0OAuzjBy4JnKIfie82VDKJUK2L4BPF8QL7EENZEi8N832PJjl/mOlqkXPdWtOTK1QUkTwDxEEZHzAvXC+g
 VdGx5sty
 4g7gqRTA6WxEl6qO6GUWRwl3/9syOaL20GF55mhZJ+ZPsW0H8LHtrragr2/rOzM7PjAUGc3LvHAtQaYmZukIyIIUpAzlnetPQQH37pdfs+UFHxtC0khY63a8TMqseTU7ciBt1Z85K712qqPIi4T0VBY2XNnOGU4Qv5pcyj7UcNKyz01XK2Uu+syNELneYza3/vMd6KVVea/Zy6EFgaq5JFXyvgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/18 3:08, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Same as active / inactive LRU, MGLRU isolates and scans folios in
> batches.  The batch split is done hidden deep in the helper, which
> makes the code harder to follow.  The helper's arguments are also
> confusing since callers usually request more folios than the batch
> size, so the helper almost never processes the full requested amount.
> 
> Move the batch splitting into the top loop to make it cleaner, there
> should be no behavior change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>

I prefer to keep it as is.

If we move min(nr_to_scan, MAX_LRU_BATCH) out of scan_folios, callers
(potentially many functions in the future) would need to handle this logic
themselves, which seems unnecessary. The scan_folios helper should remain cohesive.

Thanks.

> ---
>  mm/vmscan.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d7fc7f1fe06d..d48074f9bd87 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4689,10 +4689,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	int scanned = 0;
>  	int isolated = 0;
>  	int skipped = 0;
> -	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
> -	int remaining = scan_batch;
> +	unsigned long remaining = nr_to_scan;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  
> +	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
>  	VM_WARN_ON_ONCE(!list_empty(list));
>  
>  	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
> @@ -4745,7 +4745,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	mod_lruvec_state(lruvec, item, isolated);
>  	mod_lruvec_state(lruvec, PGREFILL, sorted);
>  	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
> -	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
> +	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>  				scanned, skipped, isolated,
>  				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>  	if (type == LRU_GEN_FILE)
> @@ -4827,7 +4827,8 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  
>  		*type_scanned = type;
>  
> -		scanned = scan_folios(nr_to_scan, lruvec, sc, type, tier, list);
> +		scanned = scan_folios(nr_to_scan, lruvec, sc,
> +				      type, tier, list);
>  		if (scanned)
>  			return scanned;
>  
> @@ -4999,7 +5000,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  {
> -	long nr_to_scan;
> +	long nr_batch, nr_to_scan;
>  	unsigned long scanned = 0;
>  	int swappiness = get_swappiness(lruvec, sc);
>  
> @@ -5010,7 +5011,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  		if (nr_to_scan <= 0)
>  			break;
>  
> -		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
> +		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
> +		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
>  		if (!delta)
>  			break;
>  
> @@ -5615,6 +5617,7 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
>  static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
>  			int swappiness, unsigned long nr_to_reclaim)
>  {
> +	int nr_batch;
>  	DEFINE_MAX_SEQ(lruvec);
>  
>  	if (seq + MIN_NR_GENS > max_seq)
> @@ -5631,8 +5634,8 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
>  		if (sc->nr_reclaimed >= nr_to_reclaim)
>  			return 0;
>  
> -		if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruvec, sc,
> -				  swappiness))
> +		nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
> +		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
>  			return 0;
>  
>  		cond_resched();
> 

-- 
Best regards,
Ridong



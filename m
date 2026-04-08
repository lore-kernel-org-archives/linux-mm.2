Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49325105D996
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 03:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687D36B0088; Tue,  7 Apr 2026 23:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65F516B0089; Tue,  7 Apr 2026 23:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C2F6B008A; Tue,  7 Apr 2026 23:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4576B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:12:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EBF7D140881
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:12:16 +0000 (UTC)
X-FDA: 84633915072.15.DDA7353
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id CA16D100006
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:12:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775617935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZP9VtDCIdTrW+zgFkYssyeZTDbuEZgcPZOgrjuwIt4k=;
	b=R3qwkN2RRH0mru2j0t+w37eBycEITTAA9Z41yIgN+ExrmHoBn3ZMwZjvnQTHVsh5PC8oqV
	hpAbSUuAfoPUyZk/KAnlx2QIYGMRS21fx5o4RbUH38ehO9msyIIJsk4JAqe7+uBl1wZW+T
	UCM8yRUSp3f5Ra25hyGp4MROfdMO4qQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775617935; a=rsa-sha256;
	cv=none;
	b=TeHSTvUFdzZ/VUF2RjKfu2YIrwDK/ulnZVsyfKmlAPJhRCskN1MfhGVj8THsfW1CIe+D8J
	u+xJeL2p90HHgBkkwa1yEqIsQdUE4fH5soXg3d1ugdITQDCbPlWZXAK3QdgEZBbagKoNbz
	fMnp9SvsEzpgFaRA1bblns+d2tyj3cE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fr7PR4McQzKHLyl
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:11:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A0FA840590
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:12:07 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgBXg1CGx9VpuP0NDw--.48788S2;
	Wed, 08 Apr 2026 11:12:07 +0800 (CST)
Message-ID: <8ee6d7c6-bf9e-41c7-9e04-69ad3e1a21c2@huaweicloud.com>
Date: Wed, 8 Apr 2026 11:12:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/14] mm/mglru: relocate the LRU scan batch limit to
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
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
 <20260407-mglru-reclaim-v4-3-98cf3dc69519@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260407-mglru-reclaim-v4-3-98cf3dc69519@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgBXg1CGx9VpuP0NDw--.48788S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZF18tF1kJw4ruw47Kr1UAwb_yoW5Kr4fpF
	WDCw42krW8JrW3Ka9avr4kuF43CFWrKryxJrWIvr1akFySqFyfK34akr1jqrWUCrykZF1r
	Za47KF48Wa4jqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Queue-Id: CA16D100006
X-Stat-Signature: ejoabmiob8gu4aaccm1k3fpksg4cbedi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775617932-862540
X-HE-Meta: U2FsdGVkX1+nVDKE1mOWY1Xyhr8bJzobaOvzRd/lQ3Kyn9N9DbjR+8J8mRNkeCfwpETVWy8RH12ESTi9rHuhK0aDfDQUh35+VSMdqErst4JJVeGI8WdUzPb0YAaOl0cHF1TOKyIPCcJZbjuZR+hJwUokRwmaVoaPlzuUl8rsY7lO34Z2lv590a2dpg/uRlJraIlRL6SZYGA4/3z5q06w/7v15bmF2IvsWbbg2QK9NFzFcMRRhzSirWpZAxeMWMLAlb1gw1Xunq+RzEQ1BQE4KdKjqRSqrOOCpxL67Ki3NwODp+GjnhiLlBvMX13Kfp5JvjcBwj82g2pCRpNfr57va6zpccaKoOVnrnz0FOMNVVdTfmJOHukoVPu/BGvPuUDmSZOV4dQSOSGrkVMY/I5i7/5QjWIVK+YMT+FuTRl90Ev40WitlZgDKtmzAHuoDzapEcisHYoZ3qnyqoaddHnEyJJG+oXM9ivsCiTrZmug6EIFXmyx+1lehyt9QjnFye/6y/S+6qzIkg4s1ogJU04YrTkatmt1Q/FdTvZZo5s/xhPpZr2+smGhgrYE0sbrD4DY/2WyCIWFk8zAYK5d5/vLtllS9jJPtAy2beXiVq0WPW77vFSFI6L4ZHE095YwNxZZzL3JOyBk8GF/BrnrmjJVOqpqOWmem+jM6bHXTdl76VqAKhEcDfcCsCeDZqs4MNjAh61CB0MDeuT5qbv5CJePge6r8VxYqaDKNmfuGReRRF7crixW3/BhYfrwxoWSTmWM4/r6NJye8YlLCjM9tTzjLADTziBQ1tR63PmViK3UuIelUHAKXKKLFDIqwAsh9evGTDkWjyxXprwFQftlMHWfntDOciaNUOv+hdn8ozq1mtwRJYrzN3XXrK0R5JoI25t5pc49/Lcx5Ub/WmFwrH8W/jd/7hmordQCaFA4zCjihMuXal7Nh5rFmcRNNgwddMmlVUEg2U/9ynBZID4622V
 QxTKzTQ0
 SFMTWiinwWxY39LTk0gbMF8j4VSdd8MdVK98DxE2cjd03GN0urkXLfE6inw9hOBBBHyPBXxhYlj5a06sr6l1ByljaW/w2DA1ni214xwubWELmvDNCeOR/udL/C7oPhB1jEvW+pTB/h9hHzJMcBG+yFwCIANOLYjuou9CZXi5Lhj8X0VwudHOQzevLXwlpIx74y/BETF+3deVs6cbPNreDucuDKCspB8HmMgRRB2P6srPLrI/XJ3D8Hj00In1yNxllT7/bnLZbqUEDBVohhvUwBcXM+r38dsjlN2XNppmx/21fZagoEyJQX/K6Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/7 19:57, Kairui Song via B4 Relay wrote:
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
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f336f89a2de6..963362523782 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4695,10 +4695,10 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
> @@ -4751,7 +4751,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	mod_lruvec_state(lruvec, item, isolated);
>  	mod_lruvec_state(lruvec, PGREFILL, sorted);
>  	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
> -	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
> +	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>  				scanned, skipped, isolated,
>  				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>  	if (type == LRU_GEN_FILE)
> @@ -4987,7 +4987,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  {
> -	long nr_to_scan;
> +	long nr_batch, nr_to_scan;
>  	unsigned long scanned = 0;
>  	int swappiness = get_swappiness(lruvec, sc);
>  
> @@ -4998,7 +4998,8 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  		if (nr_to_scan <= 0)
>  			break;
>  
> -		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
> +		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
> +		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
>  		if (!delta)
>  			break;
>  
> @@ -5623,6 +5624,7 @@ static int run_aging(struct lruvec *lruvec, unsigned long seq,
>  static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
>  			int swappiness, unsigned long nr_to_reclaim)
>  {
> +	int nr_batch;
>  	DEFINE_MAX_SEQ(lruvec);
>  
>  	if (seq + MIN_NR_GENS > max_seq)
> @@ -5639,8 +5641,8 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
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

LGTM.

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong



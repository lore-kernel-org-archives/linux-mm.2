Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69ED3CDE010
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFD16B00A3; Fri, 26 Jun 2026 00:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25F2E6B00A4; Fri, 26 Jun 2026 00:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1216D6B00A5; Fri, 26 Jun 2026 00:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D10A36B00A3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:30:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 463AB1C5FC3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:30:10 +0000 (UTC)
X-FDA: 84920786580.05.02BD1D2
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by imf25.hostedemail.com (Postfix) with ESMTP id EEFB6A0002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:30:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=rRqSG9XS;
	spf=pass (imf25.hostedemail.com: domain of peiyang_he@smail.nju.edu.cn designates 54.254.200.128 as permitted sender) smtp.mailfrom=peiyang_he@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782448207;
	b=7VX6LJk4l9GQ/JMzc65SGneIyqZLA6NWW2Zsa2IRx/MS1JBWD2TBvKaikk/CyYsaE52iGR
	k8pkfqxROYBfPhPlPA9JoqKMHKfsXzk11BUsaU4hO8rlZX/L2VbS+w8i8jq3MHmbUbJsDy
	ezzYFvfa7XE5YBiji9FL5K1oEK/d3/o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782448207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RH0r+gJK/hrMReWaxOhejWDetrJqcWbDHN59/lZ4GMI=;
	b=i7RzQspGe+U6xOAaz1kq7fDbGSkWpksS7D5OTDFTbOKwztg4x+NPog+Kp+3ONYgUzAL+Ua
	ovmoRvfN0+0zX5sKKq998qbrkckrRnE2BGPHw9uWpurrrv3DWpAmB23fI4pFfjuU4GogOJ
	oUM2BB5i9jK2QG9SpxJP23rK+51pI9k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=rRqSG9XS;
	spf=pass (imf25.hostedemail.com: domain of peiyang_he@smail.nju.edu.cn designates 54.254.200.128 as permitted sender) smtp.mailfrom=peiyang_he@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1782448173;
	bh=RH0r+gJK/hrMReWaxOhejWDetrJqcWbDHN59/lZ4GMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=rRqSG9XS2tA/lETanCwhVIirdtIbBpPu8xsvZAuymDO+RQgTfaw5oomIYAU/n4+3+
	 QIguttQFcDdlV/wnyHCCzJcRoVXsqcyUhkRPvBzRbEVjrU/wEvcY91aWgCs4gx7GBL
	 c4EPa2vv8hEu208WmfJUer3c7ieu/Et+5+d809Lk=
X-QQ-mid: esmtpsz18t1782448164t05174eef
X-QQ-Originating-IP: 3vmW18UC5VRy9qFdv+3iD2vOii7CqpvCeFhM/CgLWYA=
Received: from [172.27.139.54] ( [153.3.21.155])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 Jun 2026 12:29:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 16061476251147071744
Message-ID: <0559695533E1C70F+31684237-e405-48da-ad8f-4ba7ff4ddb38@smail.nju.edu.cn>
Date: Fri, 26 Jun 2026 12:29:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Qi Zheng <qi.zheng@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, kasong@tencent.com, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org,
 muchun.song@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
 ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <20260625151554.55105-1-qi.zheng@linux.dev>
Content-Language: en-US
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
In-Reply-To: <20260625151554.55105-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NEtAzFYxEdvUA3ZdKHCgnI8Opmdniu9SYbYVHHYV7wE8C4a248iotVnv
	rjX9QIVvU3cxb/gn+BpyVAPJiTo87x7Q8afplw6SIV7IQ2+YtoUvc6/MSN/JWMGZxeQirQi
	YnkQ93w7U5tUiHsPjNZMh2LX6eEE5QLxq8jnJLhT0K6/9+p5Hf0NMPUSE8nW7UmNp93yshN
	bMCQjn5bzuSM/vjuLdq1AKIu9OQNthLvzTKjnpOXteZdZtKz5A1pmRrou6oHHsbLbok2Pzb
	fUxl0znhG8Rt2wIf+7be44uVzI2ZYxlj5FOYjwQVF0QIfyFlcDTG1jaLbzicrU4Kagx3/od
	l/NNsORnkhCQkZJpKOwH2jo8BCfMSEYqA9BEfeQhI0g0H9+h5ZoIIPPdrtxnCDYZPR+m3/v
	40suU6ICZRjW0tllLr2xT6kG0jEfeaZv01kQA39SQWN2QsfTM7ijQIbf9DOtVx+TW6XAszY
	xKmvqkoOysj/CxvAnkK8gZLkhWBYIchI3oxu+SvD17x7eugCyGuOcZL2rfxfCR+kVCHf+ek
	FUTRIybag0TtF4TK0iGwLh4RpiVrPRdoa3c4JQ94lrHf6/kODvKA7CGPk76rn4XJ5L3m1ua
	v6sNQtDUdp/QvF8eTLp/jBIhgZ3NST+/Kmu6a659q98gctuUAXRkbCLue589IruQtoUi3Do
	Wz2LXhIfiwYLUn1BxOjI33y0Vf2CO+b3HJQdUeoeWGruBPh/+CUNqC48Ql8yI1W8FNxlCMZ
	VqoBSI7LuDOZXkyV+PAXiaJQn10zsLb/W45orl++z89WZL7lFmgDCnMGXH/qCoa80akNY9n
	T4lZUOe2kj/tEyqIG0KfkATisZGjjf2GVB/XYCL5N7qcr7TSvsFSDfOX4fFxjVt3OcVcOS+
	ZLA231eWHwzhBIECAsECjyYafsj+pLz30lKEnqEQ6WOqXiSIEPNr2DHdExMETUH5bYTdf2M
	Su91+Q0hnn5h1VXLtJqrQt3jzYiklMQ9i9HqbHMb0zs6JxpJ9YgwYxHNRbS+dPEtlVv3J0j
	Xq8xnBmTRNpSqTm3S2njgpVNvVS1K6QygAscWn9BAq6K4bRopQxE8/tyOZF8Mlrg7xonpH+
	KIaP5k5g+2SpAh12vmKmOre49JLcrTbB02/xzyxGh6PKV7YdHMDpaDvVHbyBs4Ia16ST0zj
	pFEk
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Stat-Signature: duj1ecctndtaskfj7ats6ntg1364yna7
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EEFB6A0002
X-HE-Tag: 1782448204-168910
X-HE-Meta: U2FsdGVkX18RREk3ETA3/uXSURkYy8AewdsxAs1u5L6Rsf+Fv7fiFabmEtR+FALTiJpjd/8vuO4GXheMIGu2HWM2NuVfcMO+SHB/VesUsWpZceiTF65Lc4aaTdlDjZNZeHj0ZlOjXvpm0Xt6lqf6WuBqr5b9NEW1oP/SeMh9U07iPobsp4S+Yb24jDAaVzcoT0I34wMtDRmKqnIL4fhkP2cRjsWohMPgRwrVMMTmfyXL/b0+IAhCRvZZMFXybDiKLZmyRL6FIWvB0R8N6wG656qaExzKUH2yfeLQg0l2GDiJmDTkRkHz6dKOFkICs7hiXasKwqDou7KYwOZmz4ZFqJQ7qrHovr/ElRjkShEAnSm9JLzeSEeHnMs1p6HrGaNzI/qGkSrNGKnS0G9Ub77qay4enppRfKUf4etcw6IAyTi6fIlwcZ+wuvzPjGVw3Nr4RO2PNAQEJuJStlc1zTRAVFPyThsDnkYCuufZvqIvCriajFsowFBmdI9cm+byT75hCf+bhPnZn1dticwZfsqoYJhYV4ZPKVoU6L1mmvTB6ayTWCZaR7h9MAJ2kADw8ckh+c63LoyXcWyaiBN+6n7YpXgX/9SCh1Fk9Wgnu/vLfAOFDmCUaXKD1ZWqguHnnGcT2kenBMElL4j+9NlksjANv4zKsFduYUPHU6+M9IA3q8oQPh77kiDfUZBl5clZWWFVvk11Cj9p1/sEjX5Tg15ksmlQ3db+SL+xV13Tl97p8hIRYCQUEoCvDVujjv4S3TaKLrvAeZHbz/K9zCJInjTQF70q2Fi2lgc6uIChQ1HagBsFjkQbgpEozRc2bEZ4q4tEV9jZyM3btCIK4tczxmapL0wSBpzPGyiFQOJF0mxbnC9erva0S9pCUUAaKIfck8ytttO72w8o4JRPOkkb/vKRmfqGqg0YKZWSzFuQgP4VLda6LbbkJL813Qwj4/5qLJvKsIVZ71mtT+nmwRE0AbI
 quylUnOM
 eJTDZYGEqTyrHn1nFZpkTeECc4DpzZ7bV3jqmMaAb+rjliCNEBfRt49txduIFQm4DENico4zmoIOaSCZVzPP9MYv0VG3hND3SdQqcnKuHWSmFjPfo/2oisRICrPP8rfGggKaSeynna4N4C6IEGBaz6E3zk3R6/CcEiTsEc1HxNboWB1HUH+EhocTZnO9NpUr64Z8NzmsZUQ6mQOWpYskkzW8oNMy5j91aX5TDCiPJYw0Sq8DZ0ge+10zdPQxFnn7mbpMkhXtgYWOY3ME2toKphOWdTfFP04XBhosFH5jVol0tCFIm2ltzG5ZFT4i3UkwDGkMbVhdYCWqXSBZaxq8IdfoWaN394vJ68GOmitMhMXn4bJuhq2UOHOK4tYM2c1vkIkOyNoCNcnt0b0rieDaz6a5akJ9LlgNYPqxsNdBUnc5FiTUFSBrmsvSuh6LBrE0tuDwZOGVWIk0xo4rxoTMpwkcVbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

I have applied this patch and tested it against the PoC, the warning is not observed anymore in the kernel log.
Thanks for your nice work!

Best,
Peiyang

On 2026/6/25 23:15, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec lock.
> The reset_batch_size() later folds those deltas into walk->lruvec under
> the lruvec lock.
> 
> The page table walker can run concurrently with the memcg reparenting path
> as follows:
> 
> CPU0                           CPU1
> ====                           ====
> 
> walk_mm
> --> walk_page_range
>     --> update_batch_size
>         --> walk->nr_pages += delta
> 
>                               mem_cgroup_css_offline
>                               --> memcg_reparent_objcgs
>                                   --> lock lruvec
>                                       lru_gen_reparent_memcg
>                                       --> reparent child folios to parent
>                                       unlock lruvec
> 
>     lock lruvec
>     reset_batch_size
>     --> child lrugen->nr_pages += delta
> 
> This will trigger the following warning in lru_gen_exit_memcg():
> 
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
> 
> And the user-visible impact of underestimated nr_pages in MGLRU was
> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
> reaches zero, but there are still more pages.
> 
> To fix it, make reset_batch_size() check CSS_DYING under RCU before
> flushing the pending batch. A non-dying memcg keeps the original lruvec
> stable against RCU-delayed offlining; a dying memcg redirects the deltas
> to the first non-dying ancestor.
> 
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
> Changes in v3:
>  - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
>    (suggested by Harry)
>  - update the commit message (suggested by Harry)
>  - temporarily drop the previous Reviewed-by tags
>    (since the sync method has changed)
>  - rebase onto the next-20260624
> 
> Changes in v2:
>  - update the commit message (pointed by Barry)
>  - collect Reviewed-by
> 
>  mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 38 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..1ec8c23c72b9 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3262,10 +3262,44 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
>  	walk->nr_pages[new_gen][type][zone] += delta;
>  }
>  
> +#ifdef CONFIG_MEMCG
> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> +{
> +	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> +	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> +
> +	rcu_read_lock();
> +
> +	/*
> +	 * The memcg can be NULL when the memory controller is disabled.
> +	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
> +	 */
> +	if (!memcg || !css_is_dying(&memcg->css))
> +		goto lock;
> +
> +	do {
> +		memcg = parent_mem_cgroup(memcg);
> +	} while (memcg && css_is_dying(&memcg->css));
> +	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +
> +lock:
> +	spin_lock_irq(&lruvec->lru_lock);
> +
> +	return lruvec;
> +}
> +#else
> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> +{
> +	lruvec_lock_irq(lruvec);
> +
> +	return lruvec;
> +}
> +#endif
> +
>  static void reset_batch_size(struct lru_gen_mm_walk *walk)
>  {
>  	int gen, type, zone;
> -	struct lruvec *lruvec = walk->lruvec;
> +	struct lruvec *lruvec = lock_batch_lruvec(walk->lruvec);
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  
>  	walk->batched = 0;
> @@ -3285,6 +3319,8 @@ static void reset_batch_size(struct lru_gen_mm_walk *walk)
>  			lru += LRU_ACTIVE;
>  		__update_lru_size(lruvec, lru, zone, delta);
>  	}
> +
> +	lruvec_unlock_irq(lruvec);
>  }
>  
>  static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
> @@ -3779,11 +3815,8 @@ static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
>  			mmap_read_unlock(mm);
>  		}
>  
> -		if (walk->batched) {
> -			lruvec_lock_irq(lruvec);
> +		if (walk->batched)
>  			reset_batch_size(walk);
> -			lruvec_unlock_irq(lruvec);
> -		}
>  
>  		cond_resched();
>  	} while (err == -EAGAIN);
> @@ -4867,9 +4900,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	walk = current->reclaim_state->mm_walk;
>  	if (walk && walk->batched) {
>  		walk->lruvec = lruvec;
> -		lruvec_lock_irq(lruvec);
>  		reset_batch_size(walk);
> -		lruvec_unlock_irq(lruvec);
>  	}
>  
>  	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),



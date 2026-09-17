Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A65CC88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 16:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306346B008A; Thu, 17 Sep 2026 12:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DECC6B009B; Thu, 17 Sep 2026 12:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C546B009D; Thu, 17 Sep 2026 12:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC64B6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 12:20:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 630DFC03E6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:20:12 +0000 (UTC)
X-FDA: 85223766264.16.FD35427
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id E91D010000B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:20:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d8pRWvyF;
	spf=pass (imf05.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789662010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nb+0cojbEAyK8TGRBzLK8l83EOixpqcagNWfFDhOHak=;
	b=2VcHPeP6RD/b9wsgcypSLIvhpXUEwz7sMwwcrw7NEy63RZu50tFcrafK2LWyFGZIMOHImO
	QXaa/ln451ZW9hG0bwb9XvdPYPGs83eXqtO9vDgCd2LBfl3OBMRJTx34puIdCT+sc/Xagm
	Ud3KF5bGOHbT51Go5wBgWe8x5Owc7NQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789662010;
	b=nU7boh+DDe9vLGoGzyGrfrD/vEggFvgsJ+gqNDH3MSoMwVYxYHVb1bgdGg5jEA/T40Zx2l
	cP/gzUVK6vVVaXcsX7TCDGi6qv+t+oWqgSxVuAw1Q2FzkV+MRzAsVG4czpzzu+JA0LdYc1
	soZp6mqutFtFyVtZ22jKPiTLolqLTZY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d8pRWvyF;
	spf=pass (imf05.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nb+0cojbEAyK8TGRBzLK8l83EOixpqcagNWfFDhOHak=; b=d8pRWvyFcOG/jj1FbSmrzWq965
	B+9sYnTbXATIY8ZEWg1Jj/TVFjAY8Y0YQLAtNuIhYxyW7EHab1OaLSrqtI0fCRMmqE0gJ96q/53Vm
	8Gjz8uj9+HQn2jeTqgVopG886BvnaKFKAGVwQqDuWDY3SsMPTcR9KMBYd4OSPQ38i8OcaDZn5GCxB
	4IuitwTQyiJV5IsrDhdfvWlp4xPAS5Zy32HbTP9u5vM8mxRJbihDWaN6TN4WZoKomOY0bEOszyZ08
	HbsxgHPKlTP4jy5TWSS9WCwhO+KNVVRFmKye+F8RuxH0/wXYkpk+H0zE9UxIWKg8erJj9iXQpxZHF
	lF29JHfw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7Eq8-0000000B0Sy-3mMV;
	Thu, 17 Sep 2026 16:20:01 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CBD72301BD5; Thu, 17 Sep 2026 18:19:57 +0200 (CEST)
Date: Thu, 17 Sep 2026 18:19:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, mingo@redhat.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
	hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] sched/numa: do not let VMA PID activity gate
 promotion
Message-ID: <20260917161957.GO4121339@noisy.programming.kicks-ass.net>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-5-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911001826.2109390-5-gourry@gourry.net>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E91D010000B
X-Stat-Signature: xngpqzubt9777szjmyxuk7m8cpyp867d
X-Rspam-User: 
X-HE-Tag: 1789662009-407844
X-HE-Meta: U2FsdGVkX1/rrpWVYIsxGC/biKc6eVrKvToyXBVtF5rV36wSq9G8gNwzslXp7vEdLJYW1AoOBtMwZcPdN3HdQGa4Fffkuxu/swEztprPAhi6AjTCPkl0yrKnEtQ884+JkC8WD8nwTTLi6/LqZOAxW2pVutIOheZrBS9j8T+3NzpR6lQQeC8XB6OfkOeQJZLX3673D56SNOmoICwlF3f77yOpDtJfMPGX6rHov3stKbDdbAbI354saPi6iSLkoLX2YwOEqa+z5RpHzicYVY3AiJR1Pg4RsYdlNzVHg9EECId7CVKQeWvbEL8da/IsKg2W6yByO0Qm8CEylH+g+crXqHHSonjK1JG01yoQ1QRWSosFTeZ3jYi/ekFYjqXgq1ZfFtaRfsHB5ZoO8oaZ5xPeMMKe4erFSvBsoU1wOM/vvGJOVGumNJ3YHQ+UCLou5smSlI2c0yatLzwUt9LqKm9kGjcA1v9AIVSgudFUGwvS2WcMFF5DGCBHe5Aum/be7FzU9+U+/PfH6/McPsY7lOXkmL70EHxKekPuB0oxTZ8OX7ecnMsLH+qEsKFbagmbN2xcCspFAzK2YftxISWLJledJTN6xbYwnn/OFXfwGC1retyCg5x2D1xS3koGaSCRAaDouUTPorTdjHsFvo/rdBOCv4OnMvcQ93eqXQcskxLVrcROEHg4Lp65PQ3cNglQuDcT+we7QNRRfm75lqL9umBl0O5OLBA4doGQyp9XUyTQyNqMvswhl6yskEK8Jg2fZ8+6RFAXSlMPBZIzJROu2TFTcoUms3Llluxiwt/xygbWSnR+aY8kJELpqyP4U3recRmp3RWk5ix4FvDhguGxP7qnx4Nu7Kp5Hd5XRK97LDZuF/3TEi+795x6h+qT8U5DJvdF9AiQOfgbLI7H9sMnHHgUkEjqWHg0KJEgI2iVxICrEIVSAWlxV4nEZ4ar1Jf+y8V6Rw66Q9XSuNH5GP8dmV6
 +vWt04S/
 pP7TpGM6apuoD5k0hbA2xVNSWAfalcAKHHGJwiBFnHoAr250wg73XSg+BUDAL7VP+fVuPkFdwm16561SXraUs3rwuZUMFvvUas7EbP4oi7nWdmaY+d/Fyh/CxpMU0kK/LknVhqj6jApjyfKiS1rawZqJria5jm3D91VQcCqyWMXj05k3DrOfTI5RVMSX2pFGeRFojaBHU80sEGUq9IxwlmAib6iOwxnl+qEBeidDo5mS0PM8nXxjesPfHlZOShxd0K0JTbFd2iQ3obqQ2l5esgsvd20l6eEKSrjScXrQEplv5fiWGJzgc8vC1noOzTNA4L/1kAzULxX5JfS6pB+krrpciAQv40wWXKIyLpzxqiBtGUo4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 08:18:26PM -0400, Gregory Price wrote:
> From: "Gregory Price (Meta)" <gourry@gourry.net>
> 
> Commit fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
> skips VMAs without recent PID activity. Since only NUMA hint faults record
> that activity, the filter can suppress the fault needed to promote hot
> slow-tier memory.
> 
> In tiering mode, scan PID-inactive VMAs using promotion-only scans.
> Reevaluate this choice whenever the scanner visits a VMA and pass it with
> each protection walk.
> 
> Record socket-placement scans in prev_placement_scan_seq. Promotion-only
> scans still update prev_scan_seq, but no longer postpone the starvation
> fallback for placement scans.
> 
> On a host with 768 GB of DRAM and 256 GB of CXL memory running two roughly
> 430 GB database workloads, a large shmem VMA occupied each scan while 2,537
> other VMAs covering 84 GB were skipped as inactive. A hot 20 GB hash table
> remained entirely on CXL before this change and was split evenly between
> DRAM and CXL afterwards.
> 
> Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/mm_types.h |  7 ++++++
>  kernel/sched/fair.c      | 48 ++++++++++++++++++++++++++--------------
>  2 files changed, 39 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 5413bd10fff2..9f042d6ad465 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -803,6 +803,13 @@ struct vma_numab_state {
>  	 * A VMA is not eligible for scanning if prev_scan_seq == numa_scan_seq
>  	 */
>  	int prev_scan_seq;
> +
> +	/*
> +	 * MM scan sequence ID when the VMA was last scanned for placement.
> +	 * The starvation horizon in vma_is_accessed() counts against this, so
> +	 * promotion-only scans cannot postpone placement indefinitely.
> +	 */
> +	int prev_placement_scan_seq;
>  };
>  
>  #ifdef __HAVE_PFNMAP_TRACKING
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e636e8de53f1..6d1da13a2ef5 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4085,6 +4085,10 @@ static void reset_ptenuma_scan(struct task_struct *p)
>  	p->mm->numa_scan_offset = 0;
>  }
>  
> +/*
> + * Decide whether this VMA should be sampled for NUMA placement.  In addition
> + * to recent accesses, periodically allow a scan to avoid starvation.
> + */
>  static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
>  {
>  	unsigned long pids;
> @@ -4101,22 +4105,13 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
>  	if (test_bit(hash_32(current->pid, ilog2(BITS_PER_LONG)), &pids))
>  		return true;
>  
> -	/*
> -	 * Complete a scan that has already started regardless of PID access, or
> -	 * some VMAs may never be scanned in multi-threaded applications:
> -	 */
> -	if (mm->numa_scan_offset > vma->vm_start) {
> -		trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_IGNORE_PID);
> -		return true;
> -	}
> -
>  	/*
>  	 * This vma has not been accessed for a while, and if the number
>  	 * the threads in the same process is low, which means no other
>  	 * threads can help scan this vma, force a vma scan.
>  	 */
>  	if (READ_ONCE(mm->numa_scan_seq) >
> -	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
> +	   (vma->numab_state->prev_placement_scan_seq + get_nr_threads(current)))
>  		return true;
>  
>  	return false;
> @@ -4142,7 +4137,7 @@ static void task_numa_work(struct callback_head *work)
>  	unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
>  	bool vma_pids_skipped;
>  	bool vma_pids_forced = false;
> -	bool promo_only;
> +	bool accessed, scan_started, promo_only;
>  
>  	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
>  
> @@ -4278,6 +4273,7 @@ static void task_numa_work(struct callback_head *work)
>  			 * first scan:
>  			 */
>  			 vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
> +			 vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq - 1;
>  		}
>  
>  		/*
> @@ -4307,17 +4303,30 @@ static void task_numa_work(struct callback_head *work)
>  		}
>  
>  		/*
> -		 * Do not scan the VMA if task has not accessed it, unless no other
> -		 * VMA candidate exists.
> +		 * The PID filter must not gate promotion.  Scan PID-inactive
> +		 * VMAs in tiering mode using promotion-only scans.
>  		 */
> -		if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
> +		accessed = vma_is_accessed(mm, vma);
> +		scan_started = mm->numa_scan_offset > vma->vm_start;
> +
> +		if (!vma_pids_forced && !accessed && !scan_started &&
> +		    !(numab_mode & NUMA_BALANCING_MEMORY_TIERING)) {
>  			vma_pids_skipped = true;
>  			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
>  			continue;
>  		}
> +		if (!vma_pids_forced && !accessed &&
> +		    !(numab_mode & NUMA_BALANCING_MEMORY_TIERING) &&
> +		    scan_started)
> +			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_IGNORE_PID);
>  
> +		/*
> +		 * In combined mode, only VMAs the task uses need placement
> +		 * samples. Without tiering, every VMA reaching here does.
> +		 */
>  		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL) ||
> -			     vma_is_ro_file(vma);
> +			     ((numab_mode & NUMA_BALANCING_MEMORY_TIERING) &&
> +			      !accessed) || vma_is_ro_file(vma);
>  
>  		do {
>  			start = max(start, vma->vm_start);
> @@ -4345,8 +4354,15 @@ static void task_numa_work(struct callback_head *work)
>  			cond_resched();
>  		} while (end != vma->vm_end);
>  
> -		/* VMA scan is complete, do not scan until next sequence. */
> +		/*
> +		 * VMA scan is complete, do not scan until next sequence.  A
> +		 * promotion-only scan reached the end of the VMA but did not
> +		 * sample placement, so it does not count towards the starvation
> +		 * horizon in vma_is_accessed().
> +		 */
>  		vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
> +		if (!promo_only)
> +			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq;
>  
>  		/*
>  		 * Only force scan within one VMA at a time, to limit the

Not a fan of what that tiering code is causing :/

But I suppose this will do; Mel?


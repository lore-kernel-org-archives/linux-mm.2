Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A06A1061B17
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 17:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4BC6B008C; Mon, 30 Mar 2026 13:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79BEE6B0095; Mon, 30 Mar 2026 13:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9266B0096; Mon, 30 Mar 2026 13:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB136B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:27:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1464C8C430
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:27:28 +0000 (UTC)
X-FDA: 84603410976.29.E854EFA
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1005CC0008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:27:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8yCZRzt;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774891646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OO7Tgkj9snKYIN+eALWc04Er7B0Y+whGBalzwx4T62U=;
	b=KY6XOeJgLyXd+uHmvJRSVRWPizDI1mMkdNGGDiNG4zUorCd2B6HxNc73uoegU0J+TAaEVo
	tsEnvfrcqK8Ve0hfmkOoNGoYkszRl930CDCVSA9ab7s2GfuHT/Y6LtI+MKdmqL4VZdDghS
	sOBzjFGzT0CxD/NpT5fNM0ZyKHZ4Di4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8yCZRzt;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774891646; a=rsa-sha256;
	cv=none;
	b=U3eyVa3SmcLYA3W/o/C6s85q9r8cYw7Z0bruV81AdCfJo6+ysMYAO5SbC2VWDFQ5CYcHsU
	o27IFgQ/TvgOKe5wdf52BwOTrlcJ5orBbKxxGeY3TKYHSOc9aTN6fYGh7JqJYYcHwVvUex
	G2BjRuqLkRjPM14sRJX4ECfPSWbl5DY=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a12cd0bd79so5587515e87.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774891644; x=1775496444; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OO7Tgkj9snKYIN+eALWc04Er7B0Y+whGBalzwx4T62U=;
        b=I8yCZRztLQeAg+SUk0CACuwg1xYqdM5jLd1Qppyn4/mMRD5td08g4Z/3aZQ6h/1D7I
         trclPZaJdNsHjo9SgtxzwIJtRSCG4FYcrb5xKZmyvj+6t/Ms5Ro/om6GKDY2yeTS2XEK
         fLSQDjEwXIyrBT0STvm3yDOFnrKch/JE3WwnTEsv//3bdjwWh1zNizw1O36z7vMbi3+1
         hQIg9w4jIUZQ1RRoc8dU6hZymWOrFRbEr995LTm7Gh4vSC/g65dddxaoLscQCmIv0gcV
         C5F481GKxnqdA9HQWZop7fAppYcya0nlsQWXfiHvb4Al8ZVRc3FH2OlGBdIGIT9PE96P
         kS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774891644; x=1775496444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OO7Tgkj9snKYIN+eALWc04Er7B0Y+whGBalzwx4T62U=;
        b=cSzHOFA8iniccrluV9r0yfkorIOI9Sn/jNVTsaqNSdX4Wp+wsr+V2o5/1H9MiKu0Hw
         IqhdHLLzI7/sq+my6YYtxjdhtwa3Br9++gqD/MuNMeR+i6S8vE8NLr3Dn7/yGWugJfxc
         8Ka1gLevgZL74/IfcvmuoxgTnoGoPgwtCUU4wjp10WLQqEBbnl+mGpp3ymgvgpQ5Yds4
         gccKHzD9qYYQLud2tYG7ziOnPmOWk+40ili9FK4HPFjjl2m4VHBsvYQBJKlcX2qec1uj
         KlyliDSWk3An2kqZ8M5bMuR7uAyBbZTaOGIx8eHxYfbPnadXGnb7bLQTKuVw0NLoATPo
         6WvA==
X-Gm-Message-State: AOJu0YzMqMG6FlfZTN6p4ei5P7o7VF5LkwtEpO1T6FJLj2mKbXwwpOuu
	ZI2aUEkibJ/s2Dz0tTX4Vce8zdHJEEvw1pRFfwsB/bowniPyjX1cYiox
X-Gm-Gg: ATEYQzyZiIY+i8RvwsRIyVWN5qgtnw7MlJ2CTNn7BajfnEIAyVxJr+2xHmnIRzpcBzb
	mHVbLhi2m/t8SEZydu6s5L4m1bEEVBB0karAbr3IA53GZ3voIzwRoXl7dXUsRedw4TLIFUliftD
	uj67yGS0huDpKB7BlhEBjlHMPCf6QfuTsivtRy9x+fPODFOvTEOGm+RRCfXtstKgK72drUp7Fuv
	E8W3yIaOXSa4qRrfBl4t1irok4DS7NLvtTH7uzA1WrzzINaTkUe6HtO4/4L/yc9uMC7lgkBZDJs
	TRkDBnstD5N7rg9go0vGNKxabeQ/Nxh3DxvHNMLoGC8fipijq2u2/Rcbo29dOnxRDhVXAZld9bO
	X5VD+ijUp5Z+NOfh6se9API+nu6xg76kbzQO17MjiLuWxAsOPS3qCfFsdS1Oennwf
X-Received: by 2002:a05:6512:31c7:b0:5a2:790a:e6eb with SMTP id 2adb3069b0e04-5a2ab93144dmr4099711e87.39.1774891643669;
        Mon, 30 Mar 2026 10:27:23 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b144f75bsm1789260e87.60.2026.03.30.10.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 10:27:23 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 30 Mar 2026 19:27:21 +0200
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH] mm/vmalloc: Use dedicated unbound workqueue for vmap
 purge/drain
Message-ID: <acqyeRAzcPiDZLCY@milan>
References: <20260330160552.485430-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330160552.485430-1-urezki@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1005CC0008
X-Stat-Signature: 4se8579o3hqdddhg579ktdbjipr5j9dt
X-Rspamd-Server: rspam06
X-HE-Tag: 1774891645-631710
X-HE-Meta: U2FsdGVkX19HZ0yEIijROMxntUwt+680q+VPQwqPzmwCVC7Fsv9WTxbeOrt+3Sqhrs9bfAqBkmQC38rumJmU2OLg8cKOKiKwBGMnkBZnLYbagj1M0UwxZhTAt0s7m8vzwv5rRWBtkZ86P3DX5KT1ZVcs9RZThUGTKRnQ9U5kZGfzrpaX0P+Y+0Cg8ycluCpE0jK2CUVeE5/vGOBf0pAVOUm4fCgZ/Pd4XTbbgqm8IO8LsvdU3j4kp0YrKsk1aqAYM8RfFoNUs4koNbHW7gDYn9vGActqSdhOfw6vKw5l7tQJZFznAkmtJKDKBVOi+gyFN4VDudduwHGb3COnJmWvrsYomWDM+mnUDiegSJiBZCM7kQkks9W+BWuSwNPgYDPsLQSbX0b9bGADruGfWLqoHnLzMVsbT/zVvjbAQ19PS6YHRQiy1wXKsfHbkVx7yAySHP3szzRIyNeeuAM/SFenAAywIjmaKYB63Ed+ZxRCJsl2BrqZyGkqmbM3Anlgg/0i+oFqfkdBLaY8DE7vPzGYb0NQLj9TJJgW8dQlNWJFz4XM7xWXj95Se5fiNPe4m6/uYv/mnAtXA6oYG4dZQqUCFhfGc9PX2viJVSXkDjdDCq3RlGBqfO2tl45kE8t8RpzDOiOv+my/EmDeg6m891Gxp/C3yz/cM6vkj8AlhMRYepNtQxCSXBd/wwzM7giuCggvszybSfhOsobfnB0Cl9ozLgU72iGtgl0PvUMVsVjyVSq9IZnNqncl7KMV4bY/gNL+7CyP6A+3E13bjvEDJVJ/Y+iJ7M6EDgWHpq9jRYPmDH13QLcmORKjzoMG9OCHPQqvXYIr8SbwQMQ/NjpXkIgCu2FikVZbmiorrIDJD1vk4/+ojhyqm9A5fhaJpgyOw/5XlLGZwRvYdsM9Sn2+kAjSx4p2fhQNvIL25GErW/soTi9rkRGfg9Pruan9ewFq5YKNRP8Mr8bmYTAoMQJ5mLA
 uXl6CDaP
 5ikQ7vYgheF1J8d0GP4SWU9TAtkIte20Pl3KMg/GSOY0DanO15HttqYWJv6t3enbyNIG8eAPChZp9eF83f95MQe47T7F4iwT+1IGf/onSylZDp/n/YmjSIyLmw3oucdp+BmI6zyUhJjQUFfcTONUjpCFCG2hEN9NsuSucRnVHtRksa2GV7Wzc8LR0RX3FMv4CJauS5lkfzmgqrDMy12h97EdhqBndDkh2KuA4sTBOD0/63Rpv7qcT1RwRyvKP3v6GMlAx2BqifvEnzaMVbQuhPYMNn+2iSwbGw4FZa0eNrrJuBlsUaYq8IRYzc1zsd7FG5sxf56iLTZ814N7lbtBIe5ndoskxHkWcbpLadD0cp0gPh4fEYy04nDjfPnmCTIjfqFpi7/L0cxhgMb7lOXRpLA3TlMNYEe7W2DfOuuyihAe0juM+weiXPtzCnGiAaHMJdHOwlt3elHmAiOo5CMzKlwncx8JYS0/DaLfGhBHRiYoa4lui5rMDLhE+2AhQUM2/g18p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 06:05:52PM +0200, Uladzislau Rezki (Sony) wrote:
> The drain_vmap_area_work() function can take >10ms to complete
> when there are many accumulated vmap areas in a system with a
> high CPU count, causing workqueue watchdog warnings when run
> via schedule_work():
> 
> [ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> [ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> 
> Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
> run this background task on any available CPU, improving responsiveness.
> Use WQ_MEM_RECLAIM to ensure forward progress under memory pressure.
> 
> Also simplify purge helper scheduling by removing cpumask-based
> iteration in favour to iterating directly over vmap nodes with
> pending work.
> 
> Cc: lirongqing <lirongqing@baidu.com>
> Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 63 ++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 39 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..7c1ab4a57409 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -949,6 +949,7 @@ static struct vmap_node {
>  	struct list_head purge_list;
>  	struct work_struct purge_work;
>  	unsigned long nr_purged;
> +	bool work_queued;
>  } single;
>  
>  /*
> @@ -1067,6 +1068,7 @@ static void reclaim_and_purge_vmap_areas(void);
>  static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
>  static void drain_vmap_area_work(struct work_struct *work);
>  static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
> +static struct workqueue_struct *drain_vmap_wq;
>  
>  static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
>  static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
> @@ -2335,6 +2337,19 @@ static void purge_vmap_node(struct work_struct *work)
>  	reclaim_list_global(&local_list);
>  }
>  
> +static bool
> +schedule_drain_vmap_work(struct work_struct *work)
> +{
> +	struct workqueue_struct *wq = READ_ONCE(drain_vmap_wq);
> +
> +	if (wq) {
> +		queue_work(wq, work);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
>  /*
>   * Purges all lazily-freed vmap areas.
>   */
> @@ -2342,19 +2357,12 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  		bool full_pool_decay)
>  {
>  	unsigned long nr_purged_areas = 0;
> +	unsigned int nr_purge_nodes = 0;
>  	unsigned int nr_purge_helpers;
> -	static cpumask_t purge_nodes;
> -	unsigned int nr_purge_nodes;
>  	struct vmap_node *vn;
> -	int i;
>  
>  	lockdep_assert_held(&vmap_purge_lock);
>  
> -	/*
> -	 * Use cpumask to mark which node has to be processed.
> -	 */
> -	purge_nodes = CPU_MASK_NONE;
> -
>  	for_each_vmap_node(vn) {
>  		INIT_LIST_HEAD(&vn->purge_list);
>  		vn->skip_populate = full_pool_decay;
> @@ -2374,10 +2382,9 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  		end = max(end, list_last_entry(&vn->purge_list,
>  			struct vmap_area, list)->va_end);
>  
> -		cpumask_set_cpu(node_to_id(vn), &purge_nodes);
> +		nr_purge_nodes++;
>  	}
>  
> -	nr_purge_nodes = cpumask_weight(&purge_nodes);
>  	if (nr_purge_nodes > 0) {
>  		flush_tlb_kernel_range(start, end);
>  
> @@ -2385,29 +2392,25 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
>  		nr_purge_helpers = atomic_long_read(&vmap_lazy_nr) / lazy_max_pages();
>  		nr_purge_helpers = clamp(nr_purge_helpers, 1U, nr_purge_nodes) - 1;
>  
> -		for_each_cpu(i, &purge_nodes) {
> -			vn = &vmap_nodes[i];
> +		for_each_vmap_node(vn) {
> +			vn->work_queued = false;
> +
> +			if (list_empty(&vn->purge_list))
> +				continue;
>  
>  			if (nr_purge_helpers > 0) {
>  				INIT_WORK(&vn->purge_work, purge_vmap_node);
> -
> -				if (cpumask_test_cpu(i, cpu_online_mask))
> -					schedule_work_on(i, &vn->purge_work);
> -				else
> -					schedule_work(&vn->purge_work);
> -
> +				vn->work_queued = schedule_drain_vmap_work(&vn->purge_work);
>  				nr_purge_helpers--;
>  			} else {
> -				vn->purge_work.func = NULL;
>  				purge_vmap_node(&vn->purge_work);
>  				nr_purged_areas += vn->nr_purged;
>  			}
>  		}
>  
> -		for_each_cpu(i, &purge_nodes) {
> -			vn = &vmap_nodes[i];
> -
> -			if (vn->purge_work.func) {
> +		/* Wait for completion if queued any. */
> +		for_each_vmap_node(vn) {
> +			if (vn->work_queued) {
>  				flush_work(&vn->purge_work);
>  				nr_purged_areas += vn->nr_purged;
>  			}
> @@ -2471,7 +2474,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
>  
>  	/* After this point, we may free va at any time */
>  	if (unlikely(nr_lazy > nr_lazy_max))
> -		schedule_work(&drain_vmap_work);
> +		schedule_drain_vmap_work(&drain_vmap_work);
>  }
>  
>  /*
> @@ -5483,3 +5486,15 @@ void __init vmalloc_init(void)
>  	vmap_node_shrinker->scan_objects = vmap_node_shrink_scan;
>  	shrinker_register(vmap_node_shrinker);
>  }
> +
> +static int __init vmalloc_init_workqueue(void)
> +{
> +	struct workqueue_struct *wq;
> +
> +	wq = alloc_workqueue("vmap_drain", WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
> +	WARN_ON(wq == NULL);
> +	WRITE_ONCE(drain_vmap_wq, wq);
> +
> +	return 0;
> +}
> +early_initcall(vmalloc_init_workqueue);
> -- 
> 2.47.3
> 
I will send v2 to prevent progress lose during boot.

--
Uladzislau Rezki


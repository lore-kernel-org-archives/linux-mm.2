Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4DDEDF04C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 07:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CAF6B0093; Thu, 12 Feb 2026 02:29:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3D26B0095; Thu, 12 Feb 2026 02:29:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0666B0096; Thu, 12 Feb 2026 02:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6AA6B0093
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:29:32 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0490A1B4177
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:29:31 +0000 (UTC)
X-FDA: 84434979384.16.1A8651D
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01119C0007
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:29:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Bc524Vit;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770881370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=587vbBvDprUYK6+gAj7UCfYA0MqK2wMUAauQ0TnCSkk=;
	b=TlgO0TqJ0LsIaSz3tuO/fleQDJypzZu30c9FezDtCn07pGQnYvL1YAixiHcmABWRQ0ZhRB
	kThpX22DqWgbZwp2OquY+CSpYOI+Sa0OHgydFZWPi02ukcbKYgS3e+IMUGQLSdWOdWmU2d
	0mjWbCJRAGBn8yhzzoPRYyEvr6TKha0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770881370; a=rsa-sha256;
	cv=none;
	b=V089DYFp6rd2P057cGHYTasud28MDSKvRQdpZ55VWe4s/WHLzY7em37PBxp1/PWSY3C2BB
	G4jC2j0Av1Q1CX3BmV6+Llea7IOdv4qHp/88IFLFiJ/9XLw+x4ha1X/Bx68f8jTCaUOY8G
	fHyEwhjj1Q9vlKiTNl/tiTGrqeD5+8g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Bc524Vit;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4806ce0f97bso24432525e9.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1770881368; x=1771486168; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=587vbBvDprUYK6+gAj7UCfYA0MqK2wMUAauQ0TnCSkk=;
        b=Bc524VitkBt9skP4TiJ6YRM1HGx7dY49vTNvKLUnAMS0CPNKvr8uhsSzqlueTMFRr1
         2AZjUN21OhnO1k5IFF+TDR1NRymMHsyz3Mlxft5RS9sJNAf6x3mVQ336kUxFQ1j0kIl1
         D6GijMG4cDd6pWn90FpS0At/ZqTxrRJ4IjVosPXCU/bTNhGQwxTHoSYtozVhp6h1nSdW
         jwG6OU+7Pu+RjTZ3xfS8YmcSkITT3svKdVXJvEzH8axDEVYfjDBdlGNPcT9rYuC8qeFn
         Bx6Y/8QrJ0UYu3qWma2u7TsUtXir7PouJNm/bY57k2Zo/xaO8zbVImo5guy9p9cYWG5O
         SKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770881368; x=1771486168;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=587vbBvDprUYK6+gAj7UCfYA0MqK2wMUAauQ0TnCSkk=;
        b=HJAq/ajXdLNNzScKf119LKLS3/hD3FXLk0smigC3xyXoE05O+p/G5Kip2meW78E4ei
         71EBAg9vWcHW1jEOdmeNEFGJxc1xTqHQ1kOxX/m/R352/YXg8yiFOIbZtOPFZCxlVjwm
         l04zwqrNX3GQaLDw1A2+4vlcLZb7Y4FCtTe9FcEMfkTbRFeN2zhFOArcW2zDZcNFBKMV
         QoraFQCrAEB+UgIPLzOGyqAU9+LfEUnL6pTRebZPKAj3DsM7sHFhoRipvG/CpNE7Uirt
         NFk/clYEpd6oma4O/R1mlTTEllYjStFx+A+bmYeTMAAlEJl+z3pWg4p5AxisqCFORdw1
         r3QA==
X-Gm-Message-State: AOJu0YzZ12rNnsxcJToDSPUpPHVlxvkKCYscjqV3I/VdWynvfM/Nov5s
	y/X4dvANx0MJeauodB2TC4Kt77PcGW2i78Nw07DFH7GCec5ovkqG6XcYGPt3vYBK067hJpTxVOH
	7LDXN
X-Gm-Gg: AZuq6aKjY9Nf0pL6aWHb+r0P3ZFOiFU9fcVoNmorAN9pG+T+YdfmOubb5zlL/bxzq6M
	8Hykr0MHNR7IurvXl1HUSmrXh1efW7W50DyJm/wBPomz+/7ai8Yl8hhAkt68XPoaZMOUoyghngA
	YlKdmf3RAD6FmKIdz09slyZcLh392eH47H9tV1yHZMjNUuF30Pdfrxd7+oNI9It2hbMunQUtb8D
	lm6lpLpxTwMVLPrSOcJ85bHMqCOhLLi2O7UZpU61rJfdJ0mfPTEGD0BzahkTmPzi15LaVWvecL8
	qFsDPDdGfUTsepT0tFecnrzclkoeSeD7ruw+sfHzA13qy6carZBQKacSJLPMI3gjBylbIHisjON
	am5WY+lFuW33HleVUlO92ccYM9ozk81WfwBcoGSg3+54vc5KVlICwpywvO/bMGEwILLF19GTi0T
	YsU+u5wCGgw7L+/+VNuljKoDnEa4ugZWQkdSNC
X-Received: by 2002:a05:600c:3f06:b0:477:73e9:dc17 with SMTP id 5b1f17b1804b1-4836717f09fmr15988475e9.35.1770881368188;
        Wed, 11 Feb 2026 23:29:28 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4835b9768c9sm69077875e9.2.2026.02.11.23.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 23:29:27 -0800 (PST)
Date: Thu, 12 Feb 2026 08:29:26 +0100
From: Michal Hocko <mhocko@suse.com>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH 2/2] mm: move pgscan and pgsteal to node stats
Message-ID: <aY2BVsYlPa4QMbUC@tiehlicka>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-3-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212045109.255391-3-inwardvessel@gmail.com>
X-Rspamd-Queue-Id: 01119C0007
X-Stat-Signature: 9c5pswy5qqjdz6a63iesfo8bpkiigpjo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770881369-88197
X-HE-Meta: U2FsdGVkX18rp72ZYiE/zCBfPFTXpb7nZEcNcT5xdXKEAljEzuakD3cjItFSEtIjQKZOV7sqf9Qtin0PGySYVa48mlL224Umuh4tBfmUMjSCPsA86HaWWj8guVeS/FYCvxLPeCx9Y5MOvrmHP/RLB6ZFJ48TEGAUmoT8t+csOjE3n33m7sumf/ffP8WdCqJzn1BcqGq01NEY9hLE8mbRMqYYMZJDE5YAH76OF3vpplPDCG+f/6cmNe+nrz6IHsRltQnS09bB1mUGoyu0gwEXFbwMd6zWdDIs/5Z08Nyb6r6wO1js84blp7Vgyu5T5/7T0dOqRcSu97veou2DcDfRNGaA/19JLU6SqLCia/66S6B1MthW03bSUc2LqPbzz3hIJNxOlK122GsvaqPBpbW/y/0pXv74UiDEj/9ZDG/62pVqMhgIanY9MTWY4cq1rFPlwudf3lXImzduIB41HHhfCzPqe/mnNrz6VvjLc3tzGPqgpnyf5Cs1+VCR5WerYwyXvBSVKpr8P8ctxYX1fTMLM8J1g5Huu+MhaWWzmrIMKp+JjF4l2EaboSOhIlYSIPq3dzECArF78VZ3Dtqzua+ylYTFI0fnrAdiU0xZIjcWAsO00JkIluWhiPYdXrSoypITgMRwJoeDgCOAq5W2PTxvJoM2JHC0lvhxCMGzuVhCAaZwnaACeTdeRGBAABpTcvyp1iYH6BE+bf5wIzbndp4u83W52ylPFXX6lgECPtc+NLEnMk1N/u3EHgkym+jRmHDxbTzaxtP7sQ1QBkM3F5ZxfTiEHxssv+BV9FZesXkiCvdE4EkSWqg7HV1BSvOMUDPoe/265umqogWAsl+IexcNh1aS53BKaFmifzfPJ9Ib+sSQGW4bgGmO4m+cG9ljvpyzJeVlQ6p0FIaXAY9ezP8ulTx5NhhcffCXrkDRbU+I9yWUERqxYjt4/NixR/8jGCLkDRmDfZfztA4mNiF2BJN
 vWfcdtMN
 nM2RW+PyimEm7DSrYHAI/cCDC0Es+f2es0ryuoKDqWCsBPN5L6naJYCeuFSB0iCFz6vyNBZoAKakQhUbWX7YsNX/5zu7ddpU7NX+1eYAxoC9+8O0ANY4eDwSoRyLrqZnNSjlYhYQzXYntfi+WIr12a9O9O9CuEdppbng1hdp4nnEe4ukE+1GfI5U3it+HT8FpUZPJpOJTvpeCK7oiVrw5lnm3zh3fQj818YxLHun2TFxaqe+4ZfRSrQIluEbYHq/bfJt422fqA+LzgJvPTmDtDbrzuc6jN9wJMUB1wviCBkGBpBtfYW3L/Gtgt4Kq7AoMJf035FBGy7gjhXU0REjXqd+JAjyhS+qNpD9jX7r1Lt3h5puB7OCjrsHWGS4ifbU6tsGECpHc4U9jCGWa2p0EqeKstT9swJaJWNWmSwUbUao1P5EKFhZ/UT1QGMQvggWrI79yGN7Bs4PGs+RW0kVwvYPRlydzNkxgE7uMCX28m8rHES3gK1/+YvvSdWbOeJdidt933nyiJDmPfjrveVPIZBkWojGrcxyD79Cp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 11-02-26 20:51:09, JP Kobryn wrote:
> It would be useful to narrow down reclaim to specific nodes.
> 
> Provide per-node reclaim visibility by changing the pgscan and pgsteal
> stats from global vm_event_item's to node_stat_item's. Note this change has
> the side effect of now tracking these stats on a per-memcg basis.

The changelog could have been more clear about the actual changes as
this is not overly clear for untrained eyes. The most important parts
are that /proc/vmstat will preserve reclaim stats with slightly
different counters ordering (shouldn't break userspace much^W), per-node
stats will be now newly displayed in /proc/zoneinfo - this is presumably
the primary motivation to have a better insight of per-node reclaim
activity, and memcg stats will now show their share of the global memory
reclaim.

Have I missed anything?

> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  drivers/virtio/virtio_balloon.c |  8 ++++----
>  include/linux/mmzone.h          | 12 +++++++++++
>  include/linux/vm_event_item.h   | 12 -----------
>  mm/memcontrol.c                 | 36 ++++++++++++++++++---------------
>  mm/vmscan.c                     | 32 +++++++++++------------------
>  mm/vmstat.c                     | 24 +++++++++++-----------
>  6 files changed, 60 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 74fe59f5a78c..1341d9d1a2a1 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -374,13 +374,13 @@ static inline unsigned int update_balloon_vm_stats(struct virtio_balloon *vb)
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_ALLOC_STALL, stall);
>  
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_SCAN,
> -		    pages_to_bytes(events[PGSCAN_KSWAPD]));
> +		    pages_to_bytes(global_node_page_state(PGSCAN_KSWAPD)));
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_SCAN,
> -		    pages_to_bytes(events[PGSCAN_DIRECT]));
> +		    pages_to_bytes(global_node_page_state(PGSCAN_DIRECT)));
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_RECLAIM,
> -		    pages_to_bytes(events[PGSTEAL_KSWAPD]));
> +		    pages_to_bytes(global_node_page_state(PGSTEAL_KSWAPD)));
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_RECLAIM,
> -		    pages_to_bytes(events[PGSTEAL_DIRECT]));
> +		    pages_to_bytes(global_node_page_state(PGSTEAL_DIRECT)));
>  
>  #ifdef CONFIG_HUGETLB_PAGE
>  	update_stat(vb, idx++, VIRTIO_BALLOON_S_HTLB_PGALLOC,
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 762609d5f0af..fc39c107a4b5 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -255,6 +255,18 @@ enum node_stat_item {
>  	PGDEMOTE_DIRECT,
>  	PGDEMOTE_KHUGEPAGED,
>  	PGDEMOTE_PROACTIVE,
> +	PGSTEAL_KSWAPD,
> +	PGSTEAL_DIRECT,
> +	PGSTEAL_KHUGEPAGED,
> +	PGSTEAL_PROACTIVE,
> +	PGSTEAL_ANON,
> +	PGSTEAL_FILE,
> +	PGSCAN_KSWAPD,
> +	PGSCAN_DIRECT,
> +	PGSCAN_KHUGEPAGED,
> +	PGSCAN_PROACTIVE,
> +	PGSCAN_ANON,
> +	PGSCAN_FILE,
>  #ifdef CONFIG_NUMA
>  	PGALLOC_MPOL_DEFAULT,
>  	PGALLOC_MPOL_PREFERRED,
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 92f80b4d69a6..6f1787680658 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -40,19 +40,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		PGLAZYFREED,
>  		PGREFILL,
>  		PGREUSE,
> -		PGSTEAL_KSWAPD,
> -		PGSTEAL_DIRECT,
> -		PGSTEAL_KHUGEPAGED,
> -		PGSTEAL_PROACTIVE,
> -		PGSCAN_KSWAPD,
> -		PGSCAN_DIRECT,
> -		PGSCAN_KHUGEPAGED,
> -		PGSCAN_PROACTIVE,
>  		PGSCAN_DIRECT_THROTTLE,
> -		PGSCAN_ANON,
> -		PGSCAN_FILE,
> -		PGSTEAL_ANON,
> -		PGSTEAL_FILE,
>  #ifdef CONFIG_NUMA
>  		PGSCAN_ZONE_RECLAIM_SUCCESS,
>  		PGSCAN_ZONE_RECLAIM_FAILED,
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 86f43b7e5f71..bde0b6536be6 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -328,6 +328,18 @@ static const unsigned int memcg_node_stat_items[] = {
>  	PGDEMOTE_DIRECT,
>  	PGDEMOTE_KHUGEPAGED,
>  	PGDEMOTE_PROACTIVE,
> +	PGSTEAL_KSWAPD,
> +	PGSTEAL_DIRECT,
> +	PGSTEAL_KHUGEPAGED,
> +	PGSTEAL_PROACTIVE,
> +	PGSTEAL_ANON,
> +	PGSTEAL_FILE,
> +	PGSCAN_KSWAPD,
> +	PGSCAN_DIRECT,
> +	PGSCAN_KHUGEPAGED,
> +	PGSCAN_PROACTIVE,
> +	PGSCAN_ANON,
> +	PGSCAN_FILE,
>  #ifdef CONFIG_HUGETLB_PAGE
>  	NR_HUGETLB,
>  #endif
> @@ -441,14 +453,6 @@ static const unsigned int memcg_vm_event_stat[] = {
>  #endif
>  	PSWPIN,
>  	PSWPOUT,
> -	PGSCAN_KSWAPD,
> -	PGSCAN_DIRECT,
> -	PGSCAN_KHUGEPAGED,
> -	PGSCAN_PROACTIVE,
> -	PGSTEAL_KSWAPD,
> -	PGSTEAL_DIRECT,
> -	PGSTEAL_KHUGEPAGED,
> -	PGSTEAL_PROACTIVE,
>  	PGFAULT,
>  	PGMAJFAULT,
>  	PGREFILL,
> @@ -1496,15 +1500,15 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>  
>  	/* Accumulated memory events */
>  	seq_buf_printf(s, "pgscan %lu\n",
> -		       memcg_events(memcg, PGSCAN_KSWAPD) +
> -		       memcg_events(memcg, PGSCAN_DIRECT) +
> -		       memcg_events(memcg, PGSCAN_PROACTIVE) +
> -		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
> +		       memcg_page_state(memcg, PGSCAN_KSWAPD) +
> +		       memcg_page_state(memcg, PGSCAN_DIRECT) +
> +		       memcg_page_state(memcg, PGSCAN_PROACTIVE) +
> +		       memcg_page_state(memcg, PGSCAN_KHUGEPAGED));
>  	seq_buf_printf(s, "pgsteal %lu\n",
> -		       memcg_events(memcg, PGSTEAL_KSWAPD) +
> -		       memcg_events(memcg, PGSTEAL_DIRECT) +
> -		       memcg_events(memcg, PGSTEAL_PROACTIVE) +
> -		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
> +		       memcg_page_state(memcg, PGSTEAL_KSWAPD) +
> +		       memcg_page_state(memcg, PGSTEAL_DIRECT) +
> +		       memcg_page_state(memcg, PGSTEAL_PROACTIVE) +
> +		       memcg_page_state(memcg, PGSTEAL_KHUGEPAGED));
>  
>  	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
>  #ifdef CONFIG_MEMCG_V1
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 614ccf39fe3f..16a0f21e3ea1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1977,7 +1977,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  	unsigned long nr_taken;
>  	struct reclaim_stat stat;
>  	bool file = is_file_lru(lru);
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  	bool stalled = false;
>  
> @@ -2003,10 +2003,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  
>  	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
>  	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
> -	if (!cgroup_reclaim(sc))
> -		__count_vm_events(item, nr_scanned);
> -	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
> -	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
> +	mod_lruvec_state(lruvec, item, nr_scanned);
> +	mod_lruvec_state(lruvec, PGSCAN_ANON + file, nr_scanned);
>  
>  	spin_unlock_irq(&lruvec->lru_lock);
>  
> @@ -2023,10 +2021,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  					stat.nr_demoted);
>  	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>  	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
> -	if (!cgroup_reclaim(sc))
> -		__count_vm_events(item, nr_reclaimed);
> -	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
> -	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
> +	mod_lruvec_state(lruvec, item, nr_reclaimed);
> +	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
>  
>  	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>  					nr_scanned - nr_reclaimed);
> @@ -4536,7 +4532,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  {
>  	int i;
>  	int gen;
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	int sorted = 0;
>  	int scanned = 0;
>  	int isolated = 0;
> @@ -4595,13 +4591,11 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	}
>  
>  	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
> -	if (!cgroup_reclaim(sc)) {
> -		__count_vm_events(item, isolated);
> +	if (!cgroup_reclaim(sc))
>  		__count_vm_events(PGREFILL, sorted);
> -	}
> -	count_memcg_events(memcg, item, isolated);
> +	mod_lruvec_state(lruvec, item, isolated);
>  	count_memcg_events(memcg, PGREFILL, sorted);
> -	__count_vm_events(PGSCAN_ANON + type, isolated);
> +	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
>  	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
>  				scanned, skipped, isolated,
>  				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
> @@ -4686,7 +4680,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	LIST_HEAD(clean);
>  	struct folio *folio;
>  	struct folio *next;
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	struct reclaim_stat stat;
>  	struct lru_gen_mm_walk *walk;
>  	bool skip_retry = false;
> @@ -4750,10 +4744,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  					stat.nr_demoted);
>  
>  	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
> -	if (!cgroup_reclaim(sc))
> -		__count_vm_events(item, reclaimed);
> -	count_memcg_events(memcg, item, reclaimed);
> -	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
> +	mod_lruvec_state(lruvec, item, reclaimed);
> +	mod_lruvec_state(lruvec, PGSTEAL_ANON + type, reclaimed);
>  
>  	spin_unlock_irq(&lruvec->lru_lock);
>  
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 74e0ddde1e93..e4b259989d58 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1291,6 +1291,18 @@ const char * const vmstat_text[] = {
>  	[I(PGDEMOTE_DIRECT)]			= "pgdemote_direct",
>  	[I(PGDEMOTE_KHUGEPAGED)]		= "pgdemote_khugepaged",
>  	[I(PGDEMOTE_PROACTIVE)]			= "pgdemote_proactive",
> +	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
> +	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
> +	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
> +	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
> +	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
> +	[I(PGSTEAL_FILE)]			= "pgsteal_file",
> +	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
> +	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
> +	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
> +	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
> +	[I(PGSCAN_ANON)]			= "pgscan_anon",
> +	[I(PGSCAN_FILE)]			= "pgscan_file",
>  #ifdef CONFIG_NUMA
>  	[I(PGALLOC_MPOL_DEFAULT)]		= "pgalloc_mpol_default",
>  	[I(PGALLOC_MPOL_PREFERRED)]		= "pgalloc_mpol_preferred",
> @@ -1344,19 +1356,7 @@ const char * const vmstat_text[] = {
>  
>  	[I(PGREFILL)]				= "pgrefill",
>  	[I(PGREUSE)]				= "pgreuse",
> -	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
> -	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
> -	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
> -	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
> -	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
> -	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
> -	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
> -	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
>  	[I(PGSCAN_DIRECT_THROTTLE)]		= "pgscan_direct_throttle",
> -	[I(PGSCAN_ANON)]			= "pgscan_anon",
> -	[I(PGSCAN_FILE)]			= "pgscan_file",
> -	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
> -	[I(PGSTEAL_FILE)]			= "pgsteal_file",
>  
>  #ifdef CONFIG_NUMA
>  	[I(PGSCAN_ZONE_RECLAIM_SUCCESS)]	= "zone_reclaim_success",
> -- 
> 2.47.3
> 

-- 
Michal Hocko
SUSE Labs


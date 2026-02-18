Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA002E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 07:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2835C6B0088; Wed, 18 Feb 2026 02:57:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206946B0089; Wed, 18 Feb 2026 02:57:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEC86B008A; Wed, 18 Feb 2026 02:57:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E88226B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 02:57:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C65D56902
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:57:30 +0000 (UTC)
X-FDA: 84456822660.08.B07D94C
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf23.hostedemail.com (Postfix) with ESMTP id 76D35140007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:57:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pm2+gpey;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771401447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpno25uXms+t+fmEpT7TLhoJyOfpWVBIuL5TX2/ER8Y=;
	b=y0/YgmPFFkGZW0tFZBhS3Ab3+TPxjtsfdRozV7ioa2hM0zTCmo7Rv7tH0tVihgncQBjCc1
	QRwzc1yL9Noi6eIqvemAEihhHe7Mqcoldr/274iBwg4lCGB10gMWjc7N1ni7auD7Ia024v
	bUiodSCqOgeIceZMjtzWSD2uc2VyCAA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pm2+gpey;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771401447; a=rsa-sha256;
	cv=none;
	b=8bdakAO8UpA4xrr3k2qRrg+TO/FI6IrUiBWgWX0c+OHuBfZI+IqcusO1h0rBwsqB8Wnhi2
	P2BzmWeJAhSfnFbHaLlolBlPk9ZlFNdfbQaL6OMKlVvASZEYM+/K49G9ZAUMKhFJPuds+P
	qUnNlEdCewyp+8b4deQYBBWC4YhvMks=
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-48069a48629so47096145e9.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771401446; x=1772006246; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fpno25uXms+t+fmEpT7TLhoJyOfpWVBIuL5TX2/ER8Y=;
        b=Pm2+gpeyKQf1NHHBgMAEuHuwSR2cNOmvndp9Yy1s4/ulK8ty5e6HgTafHmGx5DLur1
         rBfwc9NnAKDhIi725wkmf+3yCWoVQTiMDiCf3OKW8lWAEQ2FvbwNPx+aqVJmX6Lu+CpF
         tenwYD3zscbSxImL7rnEiQlTf5Lf/1W4gc9qP+yA8b4WRlv2XA8iFNdW2TxowdoN1PSg
         wADodOSMWBjykcSuHdzvLhPNsN0NbLj1kv4nheT3ASGbPXLH4lv0DimmuKmOYHD03NxR
         4qRjhFKhsrtQ45F1spsqqv7m6m5EzhYOjRyQLesFzf8Mb/I14H/hqSdfyt3p4cF8ANgF
         F8UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771401446; x=1772006246;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fpno25uXms+t+fmEpT7TLhoJyOfpWVBIuL5TX2/ER8Y=;
        b=FLbr3kHo+gGlYplHIp9j0xk+Uga3fe3GvyFXOH9a5I8Z7iMtFC/KugZW+jPl6hLiWM
         7BSmjpSR+eNg/A7DTkm9HhMU8oJrVjVG3y89dEQrUUnPdpbPQo3Fsn9LKptsibQDm4bd
         DzOpb6i4KpbqZWb5H0EQYk6lv2tkPNiPH50aRnp0nzBGhIJqbuw2EhLa5eRZPhybZ2vs
         AwYekbmu9QUXRLs5BwAEt3zLzAATGBkDDBDSUcvXFwVbn38wLerwtiNaf92b8dWmgBk0
         EBhzvSnGTokWLZSPtS+Cdt2mxV6AfnDv2UcgHljdC1+JHpQfDNnKMnUKWphbCGvkHG64
         Zs5w==
X-Gm-Message-State: AOJu0YxqmKERoiGG5FabV5c+Hi7vS3dhMO0zD/T5WsVqGVXyhylhSwW4
	r1385svluWnzGA+ZNLmtggaTMERaT3Nwe5ayNjjSVUTrxLnT5mvwuRa6FY1cLPNlMrM=
X-Gm-Gg: AZuq6aI0gwK+XwRXT4hFB3W0pGg0oEyNSegkBZumhJh3cUqEWXtMThtgCHq0j/HnaeZ
	x2qjM5I+4SFbpT0TPkxK6681D2ASWruQOgyP/gWyULKU+Z/5Wtf7y35/a9wrhLYb3Ulc9cqIsoT
	A4BMDmrl6COToQT4k96hbnX7/IP4tcdYNEFsNTB4OKyjPwptkzsuCxn6JDl9xSF21pALxgOCbgO
	/4fMIBQ7POpqC74qwdIXmrhT1vSdyLgsXNDu7q6i3bkAgHrmhImbelZS12icYoKkroZBxcAX6jv
	4dLIngba+OhKkXTli/3VFUT3Rz19j5oKL+ZA5GhQd2dKYBiretwOC92uW2geyyXohUEraqolF+s
	Hm1eubQz8DoQ5THWkMSKxLG/1a9hfHnqdhdufde5o0zPAtEo8O+qJmyYUSWW1NbFa/6C0KrqVii
	L+1Rsvi8bRv3+8e4w4GzTrzIcNs1dnEr5gn0YF
X-Received: by 2002:a05:600c:4f44:b0:480:4b59:932e with SMTP id 5b1f17b1804b1-48373a0a0c2mr261425485e9.11.1771401445651;
        Tue, 17 Feb 2026 23:57:25 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4836aa0847asm639059985e9.3.2026.02.17.23.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 23:57:25 -0800 (PST)
Date: Wed, 18 Feb 2026 08:57:24 +0100
From: Michal Hocko <mhocko@suse.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, mst@redhat.com, vbabka@suse.cz, apopple@nvidia.com,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
	eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm: move pgscan and pgsteal to node stats
Message-ID: <aZVw5AN85m_bO1ed@tiehlicka>
References: <20260218032941.225439-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218032941.225439-1-jp.kobryn@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 76D35140007
X-Stat-Signature: 4b7sa9oh648gd8wfpjmmy6exmk97t5or
X-HE-Tag: 1771401447-648513
X-HE-Meta: U2FsdGVkX1+b5j8kjBwocmHjEdlajU2gHNQOOgDTc3JMg1u20WurTtQI1/l8yHwB3aoD6vyvTHZaP4jT/nDi6YfBcZw9YkhnugZiHTo8F/Fz2jFADnyziUOEpsdRA23h5JlQGy6wBggo9eiKm0jonCrMMYvLafD3+hrIX0uHI1Q/prYiW+zgI8Z9dnUsTirwK0y7bDmsR5bgKRxfejhyFTDLv8Uligxx2PsOrFA5gbbjWQ82aUOpnAIk3lxMX8CRtZPsG7M2JKG059TWfxgVRzM/oOi5pvnJBP/Qqaf/4dxKfLDteFVuUcpw1tu+JsTrt3xFWJVC18bOCynp0TpE/271P3FbQ4tSmPEN02WlE858TTcF21JgZXzQYv8ogtPnvKFjon08MAH3GtzdubuVENNI4IW9anBX0E6Hi7VvMniIM0A6zInl8PMvGU5dOtED5asi2f9b0FGElwmQ78PNhJ2AQ/TApHvZxjZlkc5NF37R0EqiYUA+MwwHcAw/qrJy8Xruh+ZWWlFunhJPqWQ5rOK1t8t1DfeiP8qOUsDrC1iBChGpfQp0YsBvmh+2gwmpCeQbSyTvoB99MHsG5NNG523MrM6gGQbhc1/8oG0p29dX6WHrTew2wtjorEld5g+RR6ZpShNJOfsmpkVv9roJrRf4q+Rs6I8j449RI3NQ1hXYJpnIN84pPQRq3r2pcPZ0rNcuds76KEhvoUlvPOM3sOQ+MaO+NQodpzmbUmX9yuMUU3hKB7lgDlbHV6RI4m0icPUgKV7FcK1Ur8m1wCgHqlU8/m7iU5IcNywn2XXfoWk29ygoDAb1h91oEst3+xIECAJzbSwIrwZvpJwdq4RdJ3qtp6xF7P88WkZN7JLB9+etPYsj7KZgkC30ouYiW/nJY8LSJD1tG+TZP+Go5sPFPV9yZi8l5uvvoVjFC2PNElx0E8BNl+okZ76WTjzn9DOOM/JJNoawUJVH5G5pWZ3
 JTQmPVC3
 U1yrR3fjsRQBk+CcPJ8WHLH1yzzDCFBukhTI+Darq/1EMVXfeENtqeAkYAjJJ/jbzpC1uTgnO9U4Mqz9AAybZIgjtlUich249+7qxX9hgb4nMxWYYB3Bk3Zh7TVYWojS2WJ8HeBzM4ZcknldSQwOiFoVWrIB/55fLl6RyAEw1cIgeqJ3sHbUqyoHbMxriVFekRfIrqld6YTza1hdUv0wenvdtjyI+Qrl+Hi05kmYHR7Ll6JF/cDGypMrR4zhv62BcbbeIudn3G1EquqzNEITg52BSMW40l2xsPeNBo173/AUtLIKVclEjNg4qLAWmYquS8gcm80ha4gv+JD488cejE88mUsxsvVwdFA89t4E+rCC4//KWM1EzmqJUnNJSmWfh5ZEzc2b49aKipKn8bDbOwODJIgNXzwk8lwDWMtu/Uv9JkVUUZrPnklXZWhzazBJiXwlL6Cr6FYhZ8zZ9vahwiwGaHEd0AMBwYrUAVS/l+z8QoX8KE6OzFUOpuNc6tG8LENR8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 17-02-26 19:29:41, JP Kobryn (Meta) wrote:
> From: JP Kobryn <jp.kobryn@linux.dev>
> 
> There are situations where reclaim kicks in on a system with free memory.
> One possible cause is a NUMA imbalance scenario where one or more nodes are
> under pressure. It would help if we could easily identify such nodes.
> 
> Move the pgscan and pgsteal counters from vm_event_item to node_stat_item
> to provide per-node reclaim visibility. With these counters as node stats,
> the values are now displayed in the per-node section of /proc/zoneinfo,
> which allows for quick identification of the affected nodes.
> 
> /proc/vmstat continues to report the same counters, aggregated across all
> nodes. But the ordering of these items within the readout changes as they
> move from the vm events section to the node stats section.
> 
> Memcg accounting of these counters is preserved. The relocated counters
> remain visible in memory.stat alongside the existing aggregate pgscan and
> pgsteal counters.
> 
> However, this change affects how the global counters are accumulated.
> Previously, the global event count update was gated on !cgroup_reclaim(),
> excluding memcg-based reclaim from /proc/vmstat. Now that
> mod_lruvec_state() is being used to update the counters, the global
> counters will include all reclaim. This is consistent with how pgdemote
> counters are already tracked.
> 
> Finally, the virtio_balloon driver is updated to use
> global_node_page_state() to fetch the counters, as they are no longer
> accessible through the vm_events array.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  drivers/virtio/virtio_balloon.c |  8 ++---
>  include/linux/mmzone.h          | 12 ++++++++
>  include/linux/vm_event_item.h   | 12 --------
>  mm/memcontrol.c                 | 52 +++++++++++++++++++++++----------
>  mm/vmscan.c                     | 32 ++++++++------------
>  mm/vmstat.c                     | 24 +++++++--------
>  6 files changed, 76 insertions(+), 64 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 4e549abe59ff..ab945532ceef 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -369,13 +369,13 @@ static inline unsigned int update_balloon_vm_stats(struct virtio_balloon *vb)
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
> index 3e51190a55e4..1aa9c7aec889 100644
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
>  #ifdef CONFIG_HUGETLB_PAGE
>  	NR_HUGETLB,
>  #endif
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 22a139f82d75..1fa3b3ad0ff9 100644
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
> index 007413a53b45..e89e77457701 100644
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
> @@ -1382,6 +1386,14 @@ static const struct memory_stat memory_stats[] = {
>  	{ "pgdemote_direct",		PGDEMOTE_DIRECT		},
>  	{ "pgdemote_khugepaged",	PGDEMOTE_KHUGEPAGED	},
>  	{ "pgdemote_proactive",		PGDEMOTE_PROACTIVE	},
> +	{ "pgsteal_kswapd",		PGSTEAL_KSWAPD		},
> +	{ "pgsteal_direct",		PGSTEAL_DIRECT		},
> +	{ "pgsteal_khugepaged",		PGSTEAL_KHUGEPAGED	},
> +	{ "pgsteal_proactive",		PGSTEAL_PROACTIVE	},
> +	{ "pgscan_kswapd",		PGSCAN_KSWAPD		},
> +	{ "pgscan_direct",		PGSCAN_DIRECT		},
> +	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
> +	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
>  #ifdef CONFIG_NUMA_BALANCING
>  	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
>  #endif
> @@ -1425,6 +1437,14 @@ static int memcg_page_state_output_unit(int item)
>  	case PGDEMOTE_DIRECT:
>  	case PGDEMOTE_KHUGEPAGED:
>  	case PGDEMOTE_PROACTIVE:
> +	case PGSTEAL_KSWAPD:
> +	case PGSTEAL_DIRECT:
> +	case PGSTEAL_KHUGEPAGED:
> +	case PGSTEAL_PROACTIVE:
> +	case PGSCAN_KSWAPD:
> +	case PGSCAN_DIRECT:
> +	case PGSCAN_KHUGEPAGED:
> +	case PGSCAN_PROACTIVE:
>  #ifdef CONFIG_NUMA_BALANCING
>  	case PGPROMOTE_SUCCESS:
>  #endif
> @@ -1496,15 +1516,15 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
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
> index 44e4fcd6463c..dd6d87340941 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1984,7 +1984,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  	unsigned long nr_taken;
>  	struct reclaim_stat stat;
>  	bool file = is_file_lru(lru);
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>  	bool stalled = false;
>  
> @@ -2010,10 +2010,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
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
> @@ -2030,10 +2028,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
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
> @@ -4542,7 +4538,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  {
>  	int i;
>  	int gen;
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	int sorted = 0;
>  	int scanned = 0;
>  	int isolated = 0;
> @@ -4601,13 +4597,11 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
> @@ -4692,7 +4686,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	LIST_HEAD(clean);
>  	struct folio *folio;
>  	struct folio *next;
> -	enum vm_event_item item;
> +	enum node_stat_item item;
>  	struct reclaim_stat stat;
>  	struct lru_gen_mm_walk *walk;
>  	bool skip_retry = false;
> @@ -4756,10 +4750,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
> index 99270713e0c1..d952c1e763e6 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1276,6 +1276,18 @@ const char * const vmstat_text[] = {
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
>  #ifdef CONFIG_HUGETLB_PAGE
>  	[I(NR_HUGETLB)]				= "nr_hugetlb",
>  #endif
> @@ -1320,19 +1332,7 @@ const char * const vmstat_text[] = {
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

-- 
Michal Hocko
SUSE Labs


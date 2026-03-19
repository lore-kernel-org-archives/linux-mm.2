Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F8AC1075286
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 09:39:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B726B0453; Thu, 19 Mar 2026 05:39:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54CBE6B0454; Thu, 19 Mar 2026 05:39:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43B156B0455; Thu, 19 Mar 2026 05:39:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9E46B0453
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:39:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A291DB992F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:39:55 +0000 (UTC)
X-FDA: 84562315950.27.BB021FC
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id E0396180006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:39:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ca7sKreO;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773913194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPJD16xk4xVRQCSfYQVv7FDGYNI5YyFRNJXX+Lbi858=;
	b=6x66SUy6RH856iO4TCeT+6J2j6FL7FhiOAfhXvciQlR/0SWSlpgYV+eGfVCRiFIqCWO0Af
	y8BO0ml1xjRDvs9ffbjdYCslAoa+NzzSoudPr70JX9H+iElRgNkWL4tD3inHs7Wyud0hbl
	LFPqMXFD2wYSpuyDBNiuoRm/CelxXug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773913194; a=rsa-sha256;
	cv=none;
	b=eBg3jufBgzFKEcguHZv0e6bkHzXLqv0VgeHNQFx7qaXiuTJ/YLswBFiLyVEQnxwIc0+hku
	9Fe6j+T63puYHXmzyRa1zsA7ZvuQbeZwI3Hgc60qVBAtctO6NpTxGI6ZyF2AB7fGdVxfHF
	JRvtNkVn1QzrqNF5wYRYUSuiD1rmV68=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ca7sKreO;
	spf=pass (imf24.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a27daa652fso555489e87.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773913192; x=1774517992; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bPJD16xk4xVRQCSfYQVv7FDGYNI5YyFRNJXX+Lbi858=;
        b=Ca7sKreOH3+d+wyOKuKZJi8F41VEI9oBDf3+f0GCXdMN1Gt/cLHhX4kKvvhj+77Pza
         OiXd9tbgBxXEcgEv84VM5oK/gBsCqYEJx0C8JdZSp4P2+ru6njxPsWGk9HmHwbjvf3oJ
         8KJZajP5oZMdq5dYbW0tKsL8PugnaeSgwC68eRvw+FkNwSM36X8q3AytTkd9xF0vkhBd
         mxuYXVU619lWakihh2E+LoaL8taVK0Opt2ld/nyyjovE23a4CZ31XX+9d6LmaFyjjUHd
         XTVnypdZuYjnzfPGkQdIAadJmCZe3wQSv0lEFSsEnDyB8tVNT+1V4bTvn/Fm6vf89wgI
         puvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773913192; x=1774517992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bPJD16xk4xVRQCSfYQVv7FDGYNI5YyFRNJXX+Lbi858=;
        b=QuQXv0QBlA9tA2MbCoiKOmmK9g1NWdkAcXnuj+GxWSD7iK+797zPrqm3LnT6iNjgdV
         2mUk9kxCAejh8cG6Qo8jPD1eKmNCT1z5A06cywOH6zbn57ZmmvBV16QQhO6bpCV3kEOb
         J+I0z/IMAOT6xBHcKfyFX628p0h5Rb/nWJRXOi++a7pZdmVWflyCpeYSwGBy4rxLviP6
         yxKgkNrA19sbu0nuCQ6RroynMsXGijMT4BXDrEtmcD7bRprzniUF0Y2oYhcRWeRf2t/u
         pcYv6r681pE6iibUjLsbFmY2aEPXekJeCML3fyzUk166DWKHapSxL9mjEMUhPexDA+bD
         QP+g==
X-Forwarded-Encrypted: i=1; AJvYcCVdR0cyEb0Lg1U1BT1KarDqf+t97ksMXvlpkS6nBcHbtv7zk9rTTeiqaK+ggw/uxBXGrLNH1J/yHQ==@kvack.org
X-Gm-Message-State: AOJu0YxoN8I9/InwgZTsWv6iOfnFCGnMkY9URDEEa9OvihWzaQr0oHPG
	kCqwnWiDaCrfibcLySAlI9ZglZ+hIopgYn0lF65UDJNtGu/9aLgi1GQJ
X-Gm-Gg: ATEYQzxTwhqqnTilUgBvGj/mr3Z+P4i52phD5lefLIPTLd5KzqNqR1InfRssmzIsxDN
	SknJcrXAAjSfKJH69NhxiT6LKXw77PPcH9Wp6pwgDP5pgJD1jPh9W1rfZQ3VUZizHAypjXEjO2T
	ZJBjgx5f1Do/DMJsu0XrOYzebF2KvSSe+qQqeHoBqpUim4QPPmZTjGygUh7pf9iFjt6hc11qFUx
	yl1mhqqJZWgowA6pDXxstE9cjZxProPL0trr3ZkciFABbQDdVOL8b9dq9VfXGU9mwVXQf8pZp/J
	l26YRDUvGOy9XXLOm0nXV8HIkKGt0WaaTvtnWHH5+xZs04XN5OwKIpI5rB/RyXhNJcw1uaasQOq
	NCuJTRtJhIu/7cx7/VBYhLseUHkScY+ledH9PnAKGKIEsBvptzpp1Ex8BTRRq91V8OJTCrLIFKL
	n0Ukh/KZkcmtNyYRpNb7+dSntzdYUX0SaFZDzcPuxle8rQ5i0KUxcb+DExHb5g
X-Received: by 2002:a05:6512:1153:b0:5a1:44ba:c96e with SMTP id 2adb3069b0e04-5a2796bf5f9mr2741424e87.38.1773913191579;
        Thu, 19 Mar 2026 02:39:51 -0700 (PDT)
Received: from pc636 (host-95-203-23-144.mobileonline.telia.com. [95.203.23.144])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a279c6e4c0sm1098794e87.39.2026.03.19.02.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 02:39:51 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 19 Mar 2026 10:39:49 +0100
To: lirongqing <lirongqing@baidu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmalloc: use dedicated unbound workqueue for vmap
 area draining
Message-ID: <abvEZehbufg4amhQ@pc636>
References: <20260319074307.2325-1-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319074307.2325-1-lirongqing@baidu.com>
X-Stat-Signature: 9zgka8uyxzteffgj4bcw6xwihomw6pab
X-Rspam-User: 
X-Rspamd-Queue-Id: E0396180006
X-Rspamd-Server: rspam12
X-HE-Tag: 1773913193-790707
X-HE-Meta: U2FsdGVkX18SLd5rySZnsZHMJL3lEvM+Nv7lNF9AHS+9p1MgT/mm7JPW2durPPB0FYtI766PY0HlAZT22avBxHGmD/svXS0FviuUa33Pw23wptfwGU3mjwmwziYI8/ozgFNICZtMa7dSsdhYnTT56h2EqSQOgb4b3MesPs5oQG6kslP2yE5tekaFn/IxqeqC8T0JRr3W25H4tnrc8U15Hd1UuxaDNjFfJMtVW029jPIYBoM0Zff1Oa9ckTALbv+o0JIDHXDjYRY/LEx5lpmBVJn/Oah0uy7I+l9t+tojY1/Fz+RSdAFpros5Cvwymnp8uLup/XVP/CxRVCD5eaSc04TNxBF8tNS0dEJON5SRRhRT5hoOaM4fWD9C4p3rXRBwl9U3ijcD9UZ07lxrEKjeYKWAYCfO057uZX5Eksa07unjQnxHzigkoRkQ+i4Nt5PD/ADiDZJ9vCxV8ne33yi3wokC/eko7QCh1mx3PcYT2xyYY+A6kDRp4NVUFB6vBaKVZGm21kQo8jDnYQEaeePMPEg0biP5E1XDxl1FgvgvzLRliclxIJgGm3PmvsHoEwx3fO4zUK9BlHXAepA5NqPMiMrjQzrU1iMOxirHL6DHGYntW1KHEAN/dzXGTjfYCHuvjHq+Y+0Pv92JGUPpc+YNScROUcwcSsVBwBCNfvNbcboem4h4/sz3jFC9l7UKlx9HSoLLGWK7//FaCQCE207nU5WqjSXsH6Dnwf+bIwm+egwhI1oWq9tHymn2jgonxtJcdSZgX5OCllmsrnNXEGWxvDbC4tcEo68bjwO4uh0fpFc+r6pjKyGanvVm7S09sMSxRBV/bcc/rV3iRjPxJhOZJwyt2AD7WpiwN+Euad8v5ZriuHKyhWooO0KkBtwztvDglCCaVCgW3+2MBbB4FI0NOWJxSzRqkPDIKVTHPNMh6T7z7ZJhpRDRTLaN5y2y2fu36unIGYt8djsRPEq8C1p
 tW+04am8
 Lqjnc/PEhzXZFqEVz8LOD9PhMBEAjQVJst0GkDR8w8LUp7b/DOItSnmLFh7fOVg1TvPzvNDOQiWwj06g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 03:43:07AM -0400, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The drain_vmap_area_work() function can take >10ms to complete when
> there are many accumulated vmap areas in a system with a high CPU
> count, causing workqueue watchdog warnings when run via
> schedule_work():
> 
> [ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
> [ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
> 
> Switch to a dedicated WQ_UNBOUND workqueue to allow the scheduler to
> run this background task on any available CPU, improving responsiveness.
> Use WQ_MEM_RECLAIM to ensure forward progress under memory pressure.
> 
> Create vmap_drain_wq in vmalloc_init_late() which is called after
> workqueue_init_early() in start_kernel() to avoid boot-time crashes.
> 
> Suggested-by: Uladzislau Rezki <urezki@gmail.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> Diff with v1: create dedicated unbound workqueue
> 
>  include/linux/vmalloc.h |  2 ++
>  init/main.c             |  1 +
>  mm/vmalloc.c            | 14 +++++++++++++-
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index e8e94f9..c028603 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -301,11 +301,13 @@ static inline void set_vm_flush_reset_perms(void *addr)
>  	if (vm)
>  		vm->flags |= VM_FLUSH_RESET_PERMS;
>  }
> +void __init vmalloc_init_late(void);
>  #else  /* !CONFIG_MMU */
>  #define VMALLOC_TOTAL 0UL
>  
>  static inline unsigned long vmalloc_nr_pages(void) { return 0; }
>  static inline void set_vm_flush_reset_perms(void *addr) {}
> +static inline void __init vmalloc_init_late(void) {}
>  #endif /* CONFIG_MMU */
>  
>  #if defined(CONFIG_MMU) && defined(CONFIG_SMP)
> diff --git a/init/main.c b/init/main.c
> index 1cb395d..50b497f 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1099,6 +1099,7 @@ void start_kernel(void)
>  	 * workqueue_init().
>  	 */
>  	workqueue_init_early();
> +	vmalloc_init_late();
>  
No, no. We should not patch main.c for such purpose :)

>  	rcu_init();
>  	kvfree_rcu_init();
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55..a52ccd4 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -1067,6 +1067,7 @@ static void reclaim_and_purge_vmap_areas(void);
>  static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
>  static void drain_vmap_area_work(struct work_struct *work);
>  static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
> +static struct workqueue_struct *vmap_drain_wq;
>  
>  static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
>  static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
> @@ -2471,7 +2472,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
>  
>  	/* After this point, we may free va at any time */
>  	if (unlikely(nr_lazy > nr_lazy_max))
> -		schedule_work(&drain_vmap_work);
> +		queue_work(vmap_drain_wq, &drain_vmap_work);
>  }
>  
>  /*
> @@ -5422,6 +5423,17 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  	return SHRINK_STOP;
>  }
>  
> +void __init vmalloc_init_late(void)
> +{
> +	vmap_drain_wq = alloc_workqueue("vmap_drain",
> +						WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
> +	if (!vmap_drain_wq) {
> +		pr_warn("vmap_drain_wq creation failed, using system_unbound_wq\n");
> +		vmap_drain_wq = system_unbound_wq;
> +	}
> +
> +}
> +
>  void __init vmalloc_init(void)
>  {
>  	struct shrinker *vmap_node_shrinker;
> -- 
> 2.9.4
> 
Why can't you add this into the vmalloc_ini()?

--
Uladzislau Rezki


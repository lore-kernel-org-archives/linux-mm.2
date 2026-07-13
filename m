Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 271CCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1156B0005; Mon, 13 Jul 2026 06:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152E76B0088; Mon, 13 Jul 2026 06:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043956B008A; Mon, 13 Jul 2026 06:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2D176B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:07:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B96C140A9B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:07:00 +0000 (UTC)
X-FDA: 84983325000.04.3FA0CC8
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5C728C0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:06:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="BYV89C2/";
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783937218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vaLYxWzQpErVcY7Rt38G1DE6Q5Yue9eCJtuT5mqHvNM=;
	b=tXZ8lYdObFsqZPbEZigHFKaB7DM8NiFQqNdxExzGFWDpD3sRIPrd3nIlrsway/LDjv9dyA
	S/jpg4E+kd5zP9SWLP6t0b7bsWM/OWRyySrkRqPZyOHBUUTTYNfsybjC4azE9WGljJYdWb
	zjQDoyrAQxg8gNjBsbMjjI20njC0el4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="BYV89C2/";
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783937218;
	b=tOtn8iVgsDTcJpjNbd4NG2N0M10ahBaFmYb3YOTE3AkFXbz+871rnRAIiseOo2OZRmcx8L
	bhiz/jwwBRUpuZId6j42nQpx4r0z9k1wAvpdBrrAVSeOix2+nciEJzyC6himh9ETZn4LJE
	zEX09HVdWcx+Q29uX/UtKdwD5vuwGHw=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4720f3bf164so1988451f8f.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783937217; x=1784542017; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vaLYxWzQpErVcY7Rt38G1DE6Q5Yue9eCJtuT5mqHvNM=;
        b=BYV89C2/Dw8nHbr6UpR4Gkn8xiBlGHAChbZIN9nDwJnYSy9ADTnib3yaA0yPq4y4hw
         2RvlK1ZQ9809PfWJQzbzcbansWHjTXQ1MeKeauYM8ca5n2TXJUft8D9ppzFbve2gShyM
         8W5F+O7JqUvD4GaVI1XLFve0ygDeFHfrUgJu3AgHOvhZkE/VyRaDJniMV+sQwEByEK/v
         qozAmycygD6IMJMCnRfmU8Jeyoawd2YlOuZA9u8n88/NQMG5FMw3bTqzCKQuxVj2nEyf
         FY5E5lD3ON/uZvZ8o5b2/T4sNlIszw4t1E4oO5H5c1990Lb45vguQWBbMgRKedMTH/ON
         SSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783937217; x=1784542017;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vaLYxWzQpErVcY7Rt38G1DE6Q5Yue9eCJtuT5mqHvNM=;
        b=TizouUcuMRgaFCh2Ofk95OtOFSwHtJJzw+pE6ktBPpKPgB2R4/DLfywHwz7L8ZJzyP
         W4CvcZbhzv4GCimZ2FltoGJusARsegtQ/WB37/7gvpJgALbUvi+HK6goDeFUvwZUXOx0
         3OqnM5AMFVQSiI5SYnkzm8fkXThNJLPVANG9UxTW0T9UErvQG+TXXPSXq4sl0mnKLwRB
         ALo1xm4kdxHFRWndiwIduacGasEpXpey+pYZANdJZrpiyOKq40uOtQlLCpX730Wradqv
         er9M6VelP21RuymLzUOuglmNCY9lLGC2ePBYWritXQGewGGPKFmPAA7rQYO7+/3fkHXe
         qNLQ==
X-Forwarded-Encrypted: i=1; AHgh+RrrFsrGR54cB0mOam0pQbHoMkcUjPiV8pVsErrP2jcTxS86pG4F9cRJx9Id7F6iK1L+0EZzghE2Lw==@kvack.org
X-Gm-Message-State: AOJu0YyWSioYeoVojvusiWnC2uwm/fd5FgjTMWvqAQOghrKiOpupmFpB
	iNZTHH6GnrR2H3vHHjHo2G3xQ41QU6npkT0+ao+L4Bz5VSImNY4FWVO8FNOF164LYh0=
X-Gm-Gg: AfdE7cnsCaD1HaC6o1d9rLLg8Ms0Crjto0hF/yblXaRg6mQCdZdICUtkMFH9vWS6X83
	AFlEX3TVn9z2MvL54HGwtgC6q24XTtaFi2iwANRACPAqw5VSMPMkbIKT0fwh2EXGS0gV7f8TMie
	lCNoP28m9oWKyZdOjgZdY4cE7YT61DWhC6xQXjGFTvV9oU7xvWf7u43Twac3DOfNByJb+3Rk5rz
	KEqaWRVSDgBuul+G3nKYqBHD4UPRYtV6TzK4Og5M4yUd32xR9lYgL9H2qRF+zKG5BYbR2kWp9ib
	iqQV0pw2Yw6d5tbqZwUFs9+WyUnEJjZ7dVDaPdLq9h+NBT3liZFJjQmNHh0GS+ZADyGq3lGT8bm
	PtAghdZ4dXe6+Gc0oiqNpmGlvPCagsIQ9rPIet9blOnY0qbHXFuo+2/7Gpzh3YavtVsxbuP1O4v
	wr/unrQitZsoGwaILD3Pg4X0VzCl6z+rhGKA==
X-Received: by 2002:a05:6000:2f86:b0:46b:70db:2113 with SMTP id ffacd0b85a97d-47eee0b8778mr16404780f8f.0.1783937216714;
        Mon, 13 Jul 2026 03:06:56 -0700 (PDT)
Received: from localhost (109-81-90-85.rct.o2.cz. [109.81.90.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d843csm83341119f8f.14.2026.07.13.03.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 03:06:56 -0700 (PDT)
Date: Mon, 13 Jul 2026 12:06:55 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix wrong linux-mm list address in
 deprecation warnings
Message-ID: <alS4v5spUF224idW@tiehlicka>
References: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713085756.2973549-1-guopeng.zhang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C728C0005
X-Stat-Signature: hyaw31fzwyw9qp7bfgri3sifs1qnxbxx
X-HE-Tag: 1783937218-308550
X-HE-Meta: U2FsdGVkX1+nx9bnca6R0iAAiibL8W/D1Vsy3+d3SIFRQJNAxIp/xoW6YrPQ28Hep5syw0AZiYuxUOaIVqdYOu1LAKbPvYRxJfexpg5v+4v7cYQ0feUSQF50CdblH33Mx2pF4oadUUmYn5iDZrDAeGWGDnPg0G2qk1OR1ZwpBlAaxQ3cyKg9/j295HWDP5noPIXosBWB8xeVK3qZLAYM0078wK2LXlwXuR61kZtkBmhUdas4Q/1WdcCQPHmxZ6m6VX8tjjri0uRY01qUmCvkMTkWTLBD9msOXi2JTuby6qFVefWryARrNQ36is94g+anUNSMf80ZFjHpkRK31HjQ9IhZdcNW8sqXtNOGJ9Q3dRhGuEqecwj4MBP3mSMIMl7L2HLY+LsRzudaWwI8ASAvR78zxsSdc1aNXBQZrF+z4feWb9nba/WGfDhNWE/gPOHf3sZgYvtqprj4HW3GdpVW8KVlOdF0dMivulh7595tVm703re01d5yrCZdnfKulOY8YhAKOWrEJVVkBR4xpQZpGzrI4nGWlZvvVulgPUtVpE7TThgrIxIQ9qgNGc/GSoMkLCqAWqYmNnUPaRSexP+X0RywISKnEtKNCfyN8F5t7igN+V9l/okb9c7yS6ZB67Dfx+L3vVF5XLHpUcOzt6/NjzwS5LbIewF9zrOKHvvxQXUQHaRZz8QHp7J69XyHdTe0haLpnXpA05cs4KP2YnCI4E0RCY74CrpPeRizGpfHRZc/Z1zh2ajHlRFYNpfmQW8kpFv+eY207VJuv06Kd8BgnWSCgD/E9vZFlMw1bU/EXWPSDCxJdZrbWozn5w47fn5QJ1xyivWhrazFo93uDMXacC4INClW7sfe3srj3PD4XeYfri2GYRQPBkoqdwmSx3b917dQYtPz8hfLcNXT+I+j3Lrv4tbtfqbBwNrsrlI2KCXDu/lBWYJMNEZkXU8ksHNrAc3wQg57CUfTzXKWrBo
 4q5PdLzi
 /PUG2tnmTeoHAijI1ESssAX/UkQJCUQq+g5bFR0lejoD3tjtBwG7jcpYDu+k/UxLhncqgqBlglpd80nbVDhgzNrJM0l/hR++NPcyH/2zOf8STpeORCiVzVlQJJMZhZWXIERpVvd1JrNU1/G0K+p5UF4ixRr1nxrhqHnPBFGLiGGAR5nAmX4pGXUfJ6UjXlrzeVmFeciJaC5MGWgeM63B+tc4vaTV6vl+xK1J0+ojC7Nk5XBSSqt98CSFX/7wHfdmGVq+ZCLJrYw37ClvJSeGCI+xjbmptDvsF10BaY5pPddgAixf5VAHVqrxRzrrQ46JjdhFcTAs4IdrhDFr8NaGlPaZnOJ3zMIHnv5WYwm9tdXlEjI8Qjdo3RURtDjQirLFxt3v1bjq6uFQo7v6fj2T0ssbkqk8EfjRFjfIP6oaCo3BAUvMCDvVWn1AR/CaQNMScg4Y17StHv7G4ntpR20gGQPiXm8adNnVuNhbkGMEn9wm7NHqo4Ke7nufP5myrLOBZ32bjvuz4uJGWYWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-07-26 16:57:56, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The deprecation warnings for memory.oom_control and
> memory.pressure_level use linux-mm-@kvack.org instead of the linux-mm
> mailing list address. Remove the extra hyphen.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks

Altohough this is not a critical fix we would like to have that address
correct also in older stable trees so I would recommend backporting to
stable as well.

> ---
>  mm/memcontrol-v1.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index e8b6e1560278..178e1466d898 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -1182,13 +1182,13 @@ static ssize_t memcg_write_event_control(struct kernfs_open_file *of,
>  		event->unregister_event = mem_cgroup_usage_unregister_event;
>  	} else if (!strcmp(name, "memory.oom_control")) {
>  		pr_warn_once("oom_control is deprecated and will be removed. "
> -			     "Please report your usecase to linux-mm-@kvack.org"
> +			     "Please report your usecase to linux-mm@kvack.org"
>  			     " if you depend on this functionality.\n");
>  		event->register_event = mem_cgroup_oom_register_event;
>  		event->unregister_event = mem_cgroup_oom_unregister_event;
>  	} else if (!strcmp(name, "memory.pressure_level")) {
>  		pr_warn_once("pressure_level is deprecated and will be removed. "
> -			     "Please report your usecase to linux-mm-@kvack.org "
> +			     "Please report your usecase to linux-mm@kvack.org "
>  			     "if you depend on this functionality.\n");
>  		event->register_event = vmpressure_register_event;
>  		event->unregister_event = vmpressure_unregister_event;
> @@ -2340,7 +2340,7 @@ static int mem_cgroup_oom_control_write(struct cgroup_subsys_state *css,
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  
>  	pr_warn_once("oom_control is deprecated and will be removed. "
> -		     "Please report your usecase to linux-mm-@kvack.org if you "
> +		     "Please report your usecase to linux-mm@kvack.org if you "
>  		     "depend on this functionality.\n");
>  
>  	/* cannot set to root cgroup and only 0 and 1 are allowed */
> -- 
> 2.43.0
> 

-- 
Michal Hocko
SUSE Labs


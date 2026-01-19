Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75661CA5FFB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 08:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D811C6B012E; Mon, 19 Jan 2026 03:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D55D16B012F; Mon, 19 Jan 2026 03:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62386B0130; Mon, 19 Jan 2026 03:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B10526B012E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:00:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C565D210F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:00:08 +0000 (UTC)
X-FDA: 84347965296.01.8FD4038
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2026BC0006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:00:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QpedhKQB;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768809606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jye8WAd/vE4qqlECAOAdbFTMAIss/HS1MRQD2Sijk8A=;
	b=OgekIpAxvlUoAr/ma2ss77PLxbN0VTduXqDwlwOGWc4s82m6Hga7+vcV+nGY5mBKZOMraH
	zebgG3qjPQctxS6FogFdUh1ue0uBRyb+Ul2lKJvS5qvjCOdf/C5H27U0WLgKdAwKkNlcpu
	9602TivAhkMmc0BR56inEUqjAgeZHgI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QpedhKQB;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768809606; a=rsa-sha256;
	cv=none;
	b=GOu/2LkcmjrRZhnGySiETPz51k6/ROwnWxTWy2+cc/AIlPGJZBLVCX05JwXC2RkuBqI9L6
	lPbbglcutXwr3+CYMiWIbNVJM0+UlC0bWW/jQtYzivY3+shXwV78sbSfORUVxoY34jPUw/
	qZFhOnc4J5upL2uXt5cAE4MX2WDDn9Q=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47d63594f7eso26602455e9.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768809604; x=1769414404; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jye8WAd/vE4qqlECAOAdbFTMAIss/HS1MRQD2Sijk8A=;
        b=QpedhKQBRfCuH7XgPJg7OAu9i/6oXt47shUpJ1RLzyjeCBknOUILqCP/njnU+MdYOV
         zYJSt1HEdHWmreybYf26BMVnjSYJT4ytrZhJuBGVm/16hzxxlSlEVED/0oK4BBh1dJHy
         TtHhovXU83aWzEb4/dA6uhpL8rXh1Ty5/ymhgfCwAc39RU6gE1g6WE0xu6EXlNWemlEi
         /VMVrmI2TZSOx2OlRn/GK5hyMPi76GVXMJKJ3JAw7HtAJxNt9L4ie4JXDcivP2Z+ewgL
         NywjTnWtYahZQ0+yJxNmHyLYAM9K4wCVgMM3mjdG+nB+yRazGlt+Ko1/SmylTuh26Ans
         a5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768809604; x=1769414404;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jye8WAd/vE4qqlECAOAdbFTMAIss/HS1MRQD2Sijk8A=;
        b=hVXJ3G2BO7CBBTwXy53/a3vDvtUhCnWRXs85A24mM+We8wHzxMCaWtPgShO1P03vsr
         O+Nicx49aqhdb8NDZqP/sg995MBGfd8gCQ/1XB2/KkTdmsIvkO1C+TuZDyof0vh3vh/0
         hS0lM7PHMgU+MDC3eNGgpUAJIeovBGyCIeXpq/qTCrjtoNWPJUt0oK4qlschw6sr7rzk
         0Q8iD3qVsvyx/XOebvp5U/fkI/pS1YVPmIkhyK4GW70UDxu8mPjlAjqO4US7LDEqKt1v
         K+A3op6/h71+aSJ/sb1RvgnpkPh2bI80K+RPynVrRlNdVs7bZ1vI33kwtPl9uT+kurqo
         cnug==
X-Forwarded-Encrypted: i=1; AJvYcCV3sqopplKpPLjvIt3KFcnS6KQY3yx1rcfA+rFbwxf7NEgfiK+sCHASLazC72X7y5kocxgJV4+iOQ==@kvack.org
X-Gm-Message-State: AOJu0YwBi4E+OpaQ6G7xyFdXGtHmEE27zGxkMvi5cEwznQ4HVFJV+7C2
	UDIEQrhLIHF+fai/fhsrw1DgH1zyu4UFLuUMw15dZiKDd9605h5Qbk3b1I3lCs6S/3A=
X-Gm-Gg: AY/fxX4CpudrhMkNiY+MqPu9dN0qj/296Nl8CjHO16uArCzFxfjEOvesRUOUnedwVT7
	goyGQ9ilj3Y6AvnaccmA2emWNe1fSGMUgwqCPMWguoBbCYI3bPem/riHBeTG/6NyZft87cr0jZQ
	afVEG1ZLJfPO7RVfdJKvBuO9GnGW/Y4ueNlp2vet5pMV2TK3N/+8ZQ8vnaEq0NZCAHzNXu4/6yW
	hL5qMNuGaWjF7KLvS3ZOGqpHzYdsp3t/4itXbY0hX7Fn1nPmUenHjcYWWvEknuL0oJJ6ntpVqRc
	HSA9xCxqtwn3LqaZC3MD5H/XY+x52mNZ4kbqrWYukwKfPq6Dau7v3G/YTFfTGz0RNMFkeyEZizo
	KzkrAixPHsqQhKcvwl61KGdF7UXq8Nbt9yhNBe9CVlefDxbTyByFydsjLBWYHyh4micvEDqxFmS
	fSZA6eJ1838PZOYS7FwfMzLg7+
X-Received: by 2002:a05:600c:3b90:b0:477:9392:8557 with SMTP id 5b1f17b1804b1-4801e33a93amr121328725e9.18.1768809604358;
        Mon, 19 Jan 2026 00:00:04 -0800 (PST)
Received: from localhost (109-81-91-169.rct.o2.cz. [109.81.91.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4356997eb2asm21670271f8f.37.2026.01.19.00.00.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 00:00:03 -0800 (PST)
Date: Mon, 19 Jan 2026 09:00:02 +0100
From: Michal Hocko <mhocko@suse.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Davidlohr Bueso <dave@stgolabs.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: Restore per-memcg proactive reclaim with !CONFIG_NUMA
Message-ID: <aW3kgrVhWQEyGM-G@tiehlicka>
References: <20260116205247.928004-1-yosry.ahmed@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116205247.928004-1-yosry.ahmed@linux.dev>
X-Rspamd-Queue-Id: 2026BC0006
X-Stat-Signature: ufhxd6kwnk9ro6bo8boyscbfczz8you6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768809605-571481
X-HE-Meta: U2FsdGVkX1+Cha8jSHANVodQHihBHsupeT4XDfeUgQWIyqzukQf7TsmEQzHfGyo/CNyvmKZ/WIqzu3N7xQJxQvdDI3BBGKxlDcJuuxT+ZO1gOW7MgdkxiRDT0+HXdr9hSn8qQFeMcOeZ+4TB4L1ZFox/YbNsk58YsA8NUPcrnlneY0pwHfikYJDTDTuZZ+d+yNMLaYkTutlad47FuUB1I2FomE5d/0z5+IYeLqwjvE2n3tlnXINoGiwhSiRnRXSYdrMPKNvIlMEjzHV4UZjidvQThz5t5wZhmqwsIgPN0CtYQ+jQThFeOnZUgHdJ4vWuYGPe66alIKkfhgF/FTo/wyen0h8kLFDQ5B/NsF1JkvqIq+3xAEC4Tu8DoZIGI9nSYfiZEgrQnvErCY32BBpEXp5ZGxNgpFNjTKh5E+PmZ2w8gWYre0rIO8OB8b7RO8ob9WoBO80OAVnB4U4lRfavWTV2x8CrCTpEgB2QiGJ2pgoaTZbBGMXpFqkqDOQD65O5IKVilwmZN2TryACKK/W+GKC6uSUrTS0KCxB7f6WaOVOzKFA6JWZQdCrpn+FP6RgSNKJodQcvY0VGsYbYPOYGRpGAsoFNwsPh5PbTyxghY/VWAwXY3KsDnwycteI49mRZJQ/CgHlZg9roeyCjfN1BCjxqoAazTne60/Lf+zncTyFpte3zwgxpCtx/CpTkdCEgobhPOvOfVt8x8TzEpkftIxuRr8ikSkUD9AU30TtH9xYoF4/pIRIffIDTcbuUSYZqutY0R55zAu/FRTU4Kc4JzEOjIMYzBBMlbTc92JPWC7Jg39jCc3vU58pU2fXanhsxAnu6Y3aY7roFK2PWcP2LVq/CrKXNuUC7RVx9W5XB1+2FN43grczfUjgzPQd4nWfIWYhuwhLJ6mB97IpzcEHIIvxj9c1WnlVYP3QtDZsih0GrdLG0lhhFNu7/yzYCu76dYYBVaoQVwCHeKzw3lyB
 rz+Kp/wr
 DgG2ipy0lIXG6e7OY6p7u4woeguHqw3wJOxQ70tB2LsrYdh2q4YOW3jNF5M1puA4RAfzR0D3jFoeTUbPTsBWCX2pW3r1kiki8T6NpMgRlfdht5pXjTb0yyV9JGwfz6tAKHEJonjzVMZg+bPHAf2L1J97aV14R3ogLFPhv2HvEeDf2sFMT0VatIiO+52OijFURieECbukRvWrpvCNMxcliazfOg2j4lf1wt7FdjAPteeMFT//3qEFHeukT19V8q9+dZPy8XjETbFDsHxkPu4lF/IQvlX7Urd9oSynon0MZr5jJ49W0Nqozx8plFwnhEIVxq0aQx/o1JBKbgnrTKd8LLmWhq6ylbux2Zhk/ZqZK0ti6hRsz8D/Pli+yLtNkJeH0/rAr1tTER0hUsrKcjLCLxn8KOeVDC9saHW1MRMQBY9eEXzHeQSCW/S0qpG1qHNP2a8ogzr+wCOo61wzwOxCQKzs2LlgpqMnXbEtznBhmKGRhhr2IVbmC+zk4budWtJvEWRzr+8ZWgo6grkdJsdMMgimn4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 16-01-26 20:52:47, Yosry Ahmed wrote:
> Commit 2b7226af730c ("mm/memcg: make memory.reclaim interface generic")
> moved proactive reclaim logic from memory.reclaim handler to a generic
> user_proactive_reclaim() helper to be used for per-node proactive
> reclaim.
> 
> However, user_proactive_reclaim() was only defined under CONFIG_NUMA,
> with a stub always returning 0 otherwise. This broke memory.reclaim on
> !CONFIG_NUMA configs, causing it to report success without actually
> attempting reclaim.
> 
> Move the definition of user_proactive_reclaim() outside CONFIG_NUMA, and
> instead define a stub for __node_reclaim() in the !CONFIG_NUMA case.
> __node_reclaim() is only called from user_proactive_reclaim() when a
> write is made to sys/devices/system/node/nodeX/reclaim, which is only
> defined with CONFIG_NUMA.
> 
> Fixes: 2b7226af730c ("mm/memcg: make memory.reclaim interface generic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>

Ouch.
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks for catching that up.

> ---
>  mm/internal.h |  8 --------
>  mm/vmscan.c   | 13 +++++++++++--
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 33eb0224f461..9508dbaf47cd 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -615,16 +615,8 @@ extern unsigned long highest_memmap_pfn;
>  bool folio_isolate_lru(struct folio *folio);
>  void folio_putback_lru(struct folio *folio);
>  extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
> -#ifdef CONFIG_NUMA
>  int user_proactive_reclaim(char *buf,
>  			   struct mem_cgroup *memcg, pg_data_t *pgdat);
> -#else
> -static inline int user_proactive_reclaim(char *buf,
> -			   struct mem_cgroup *memcg, pg_data_t *pgdat)
> -{
> -	return 0;
> -}
> -#endif
>  
>  /*
>   * in mm/rmap.c:
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7b28018ac995..d9918f24dea0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7849,6 +7849,17 @@ int node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask, unsigned int order)
>  	return ret;
>  }
>  
> +#else
> +
> +static unsigned long __node_reclaim(struct pglist_data *pgdat, gfp_t gfp_mask,
> +				    unsigned long nr_pages,
> +				    struct scan_control *sc)
> +{
> +	return 0;
> +}
> +
> +#endif
> +
>  enum {
>  	MEMORY_RECLAIM_SWAPPINESS = 0,
>  	MEMORY_RECLAIM_SWAPPINESS_MAX,
> @@ -7956,8 +7967,6 @@ int user_proactive_reclaim(char *buf,
>  	return 0;
>  }
>  
> -#endif
> -
>  /**
>   * check_move_unevictable_folios - Move evictable folios to appropriate zone
>   * lru list
> -- 
> 2.52.0.457.g6b5491de43-goog

-- 
Michal Hocko
SUSE Labs


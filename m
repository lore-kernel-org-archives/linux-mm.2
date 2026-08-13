Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08D0EC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22AE26B0201; Thu, 13 Aug 2026 04:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202786B0204; Thu, 13 Aug 2026 04:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119B86B0205; Thu, 13 Aug 2026 04:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA3DC6B0201
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:28:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 838B18056C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:28:03 +0000 (UTC)
X-FDA: 85095568446.29.4381F8B
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id A70EBA0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:28:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RTMs+Hj4;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xCzIN0PcYx5XXua8zBFfrYvgdot2po1J62TlNHtY8vs=;
	b=bj9MZId0xHMfX75oeSTFW6cDIWs9BieNJ1nPoe6dsbdk+1a0WDRyezwSbtet5D2yd2Rm+U
	aqp2SBjYL9Yc6xrmTHaS2OwmTWK+nOxZ8XNmGCVTYWWutlHG8NC6ggMWxNfTzmq8Y817Ge
	cFhDC6BWdsm2K5wLPIYoP6oiM6gSR2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609681;
	b=cUCPduYua5yofpGXlGyTo15RCH2LKwqG0K3pLr2OazzTpu8SnawVb7Z+LaCgzmgCBiCsxo
	cRamhPJ1MSqcYst2VlgBktCY05l8YzyCXNVlgsy+jHLeH084s4n8C866EtWGkzOBqkE89s
	nmzvU98SjNRKZzGlTbJp6nwrBD4JPeQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RTMs+Hj4;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f96c5b722so948142f8f.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609680; x=1787214480; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xCzIN0PcYx5XXua8zBFfrYvgdot2po1J62TlNHtY8vs=;
        b=RTMs+Hj4Uf3MPjYAB6zQAY22AtbKwxAmE0c9SVAGPb0iVeiu29xYK6fAKfUeqbPM8z
         lPM5fKAT9NmKvqstsp0bVh/D0B4Ho5MGOxWAYzkIDvtFtk7UADVrAlZyvosW6p0bqct/
         B/bLGBatudpjwJ7BlUKfWbIMgTmU7vUtZEiZSP6+tl8YsTpu5CT3GlQDYivQ9/Od3Ajc
         rCbzgzIXQ4Bk4wtn+K70t9oYMIcgPtL37aWbTIzDLOXD+EZCBIkpneWvsi7aA79WPx9q
         /phTVFr4IP3k0esi5G+9EG4BDDX5nURpeX6OCu8RV3vPPqTSB1Udvy0pr+9ZTUUPGb7Z
         tsBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609680; x=1787214480;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xCzIN0PcYx5XXua8zBFfrYvgdot2po1J62TlNHtY8vs=;
        b=hvCtBdUK5UeXDh12jV47+GVvElOY9daWl6LNxFiKdnz79FaVhdBz8dKXQpdWOxNzfl
         T7DBKbdeZ1EPZfEiM0/5gnnhssNoa54mykBopmpIlR5Kwp0seTQZRwVAtSjmz5vR6P9u
         T9L0nc3CI1eZfhuwYBXrLyuNn9fjyvPtrajrwIcPNBznKTPqjGHFgp4OSleY1MZbxyJy
         NWrmuLoGixuP3jsH1NNOXl3/D5MnSxplPhIWljRPJyg3Pkju4VKiOeWCjh8YFl+eEI8r
         OF5U/dZ6rRHgelB49JnKCbQorpo1zr9lw9XtMpRY7I82E+eaI6lZq3EtkATxDYuEFF6N
         A1qg==
X-Forwarded-Encrypted: i=1; AHgh+RruvlNzHhOj64PkxO836UTIt9//7uM1RO+w/Ss6jHF4RWo+k+9FLH+047BgVE2o8/L4jI/+ksTMNQ==@kvack.org
X-Gm-Message-State: AOJu0YwL5zzmbkm/5FPPXIS8WnLPxIcIC0aTmIbbFJ/6c/vFnoX+G3wb
	HeDdg3dJhH4OrjPokGdUuGv4v0ocUTe6p33z2nIBhe0tXxRnRsgW3wahEcxPRrSwIww=
X-Gm-Gg: AR+sD107oz1SbsUdnD1w1lcXNYH3mkL7L39whGijW88EfgRKSFhA8ObzuFXuqDF6xJp
	9bTckKsDP2RIStStj0TuUNCgy9ozmxH2aSn4LBj9Ak4xEc/BOcmAOZMNzCAqasdmQUfs+7Iegj7
	BGDZ5B+VMPD0QmtdlBO2jsN6iXN7MI407Z30LI4XmuNjo5i6y9xYTKM1aPq9+eqIXrbXDoS66Ov
	B/9m9kbamAVSOUw7arMhnxVZiZdrDW0Cp6OepVV94welw4WUHd/OOo6CaNA1VqskHW1g2+1IC1s
	TonwXg/dketoFih6dcLo4tJVVz9WDmyp28B3jZjn5C1om/jBC7qnQzBhUZ3GHYBh6hpjl/0ULpC
	A06LOXDpJXTxGyjM927UwKzKbQ/gZujE+mMlw5J+9pYwOk82e6RfOejPV8bQ+jWl0rN71Ry5OuX
	YAhL31pRtdXeKlfx79UKWccg5lzMvH8+3iWOuL/72O+LanpQTptIwRP2GeWzP05Bm1kp7mxQo=
X-Received: by 2002:a05:6000:4919:b0:47f:b51d:f0ec with SMTP id ffacd0b85a97d-48159eea06cmr5670939f8f.15.1786609680354;
        Thu, 13 Aug 2026 01:28:00 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5b6c2dsm4071055f8f.26.2026.08.13.01.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:27:59 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:27:59 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] memcg: remove mem_cgroup->soft_limit
Message-ID: <an2ADz06jCDm65Kd@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-9-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-9-shakeel.butt@linux.dev>
X-Rspam-User: 
X-Stat-Signature: sb5ynw6pcoetac4omnqrw4aizjgnem6f
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A70EBA0003
X-HE-Tag: 1786609681-347826
X-HE-Meta: U2FsdGVkX18o3MQYmcnLHpM6mj7OWdAwiM46FQOylRVvE6Ff1CD4Ia08PUOkQqUjhkP2MWroipPmwPxr9fihr9kUsAvonsxLpmmW5Zqg9mjsejxEWOyUtgZW4QYvmwrNxlCEEnBNN4JMk43uz3fC7YGArLXit0070jFsZZsPzdUIlPq353ZtlE/gMvt2/vsuyF+OGEL3RnCXnGOrGqZP4x9XlIHKnnkfxZBnHtuCSFRzpRH3Ln8Yjib16FMQ9YrFey+MOPf181gPsLzyhEH9sPnHcKOHVvr0RC7qJivphh4Q0ZnVy0zJ6mNLKWiQDYkX+ubeqqP4MS3QxbV4Xx8Kx73jYxpNgBbEOdJFvCckGC3ddLZ4VL94PbP5vm5Oi1gwbH5NIT3Mxws0U1fmpwzTZziX6tNsdFfBk5vxUIHOcdeh3fcONvWlCHTBB7HQG6CA4ZiIuGxpN9LIzmRJBACN9YJ89IQPBQmHrtiNELyz0dN75+L+saNwJrhLSbTWbqXu72oRCzm7q+GYmoGB1TcCVaLpiOvERT4KOfMJJ7N+iHMg4SV4iab1Iw0pksjjfUQEFQtMyJ598pC7dgWmrAbgfMLCg+57VyWvlbqlJTlKnL9YrVF/fw61GbKERdv3i6/p9rxeygRfgGM6ZDgDd7o4r2QhsqwvIvzijjFq8ULSqW8f8PaOHBKsYBYnDxN0B7nMSl/xK2YpC8O3r+jxV54BoU/ejc5UbVZkyr8C4Qt88g/iVi10dOEsAEJ+sj4lmK618lDCvSaNdAERpo5PWS9ZK+LUwVpGV6/gQ2enl1Ezs6/5TGaT2SRHveMPYbf2QG0fD6z6/d6TrtMdEQMrCB5x4A1JnvpR/Jx7MtIJ1Q7/GpAML5oWd8y6scTmlesyXIRV0nW0iFaHFQDJyZVqdt2Y65JzehfikWZNaW3nsemVkmyc+1faK2TeMOzwAJRYcKkSLxDSHa8E4JMuG7eOwjN
 yEOanZfB
 GPZxdGDtdqCma2fGEb7+JopbRHgXvbtDCdkd7gVxHCiiezmdIfN5T3ZaFJ5CUgfzytw+00mSAtXohTkGIUMR+i4zLh0Es+RJnyK3xDNYUhzfifYZDnT/68rLalxfb6GvizNgIEIOhVD2dWHzeqrAeLS3exDCjupQetW+9Lw+JUdCy07VK7Gqh9T2aZADcmRFCOHFQyyXFkFlp2KDI5p+QkktfsmpphByl1r95LxrPrhBGou/h4O/3MSXmFxeLMcA9EtQ+9yPuTuHyuJY6FWABdwTk/EgECYKqBGExk4TKtKhbA8bWfsIAACa84RoPnZ0iktPzzPHSmxL0LA8Z3LJBkqQhFlf5mJPs0USMvz1cN+In5V4JlYdMkTPE5YGBrNsge/ilOTDy7BNAnvulv6vFxhQbGxV7rIHSBfZGQH3HnrRB2gvGBI4O47zGQ1YApZaWyhqVpBT+pmP7VrLceCclN6hwzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 13:32:02, Shakeel Butt wrote:
> Nothing reads it anymore, so the field and the helper that reset it on
> css alloc and css reset can go.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/linux/memcontrol.h | 2 --
>  mm/memcontrol-v1.h         | 6 ------
>  mm/memcontrol.c            | 2 --
>  3 files changed, 10 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ce24e04967d8..526da1d869ed 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -275,8 +275,6 @@ struct mem_cgroup {
>  
>  	struct memcg1_events_percpu __percpu *events_percpu;
>  
> -	unsigned long soft_limit;
> -
>  	/* protected by memcg_oom_lock */
>  	bool oom_lock;
>  	int under_oom;
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index fd611e66859a..f48d0e22e615 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -42,11 +42,6 @@ void memcg1_free_events(struct mem_cgroup *memcg);
>  
>  void memcg1_memcg_init(struct mem_cgroup *memcg);
>  
> -static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
> -{
> -	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
> -}
> -
>  struct cgroup_taskset;
>  void memcg1_css_offline(struct mem_cgroup *memcg);
>  
> @@ -97,7 +92,6 @@ static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true;
>  static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
>  
>  static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
> -static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
>  static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
>  
>  static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b68f1f16ae54..ba3ef821553d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4222,7 +4222,6 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  		return ERR_CAST(memcg);
>  
>  	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> -	memcg1_soft_limit_reset(memcg);
>  #ifdef CONFIG_ZSWAP
>  	memcg->zswap_max = PAGE_COUNTER_MAX;
>  	WRITE_ONCE(memcg->zswap_writeback, true);
> @@ -4429,7 +4428,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>  	page_counter_set_min(&memcg->memory, 0);
>  	page_counter_set_low(&memcg->memory, 0);
>  	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
> -	memcg1_soft_limit_reset(memcg);
>  	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
>  	memcg_wb_domain_size_changed(memcg);
>  }
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs


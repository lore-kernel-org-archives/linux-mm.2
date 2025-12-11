Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6678D41C1F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 10:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8AE6B0008; Thu, 11 Dec 2025 05:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3810A6B000E; Thu, 11 Dec 2025 05:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F586B0010; Thu, 11 Dec 2025 05:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 14B1C6B0008
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:49:05 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5A3113524E
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:49:04 +0000 (UTC)
X-FDA: 84206867808.06.59B143F
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 87CE6120015
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:49:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dJn5fM1t;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765450142; a=rsa-sha256;
	cv=none;
	b=fjCnPZaYTQ5V3ZCeMP9ImEYG4y9PwryYs6/xxxT9sdvwe343mXYYc+pcSQFx87Qgk0QB/r
	gpsl7MZ/MGwZNccp0/cpsyhHLQn+pevtGQyLZlmGFBxfQuIWEptRjg+gh5HfEExUH9s1Ug
	tTmwPY0e20+W6JXmuqIgIBVk0wTOqrw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dJn5fM1t;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765450142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Id+mKyK2rpQjMmy5lZn1vycT1sBmx/sBfGFCg09yGQU=;
	b=6dlPoBkaP1k8ZkdCVT2bI1AiaLBO+SVmM1YpZddyqJFon9w1vneFtneuTg8WysoICxbxnZ
	0t1LzfpceVZwzqZRJ1vbLfpo0yr72zz1MVe8V6myhrBQIoIGLhkG2idfsB4SvQgFqR4XAI
	PHcT4XOygSnyMrin0AjrvJfo0TNesdg=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477632b0621so4776385e9.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765450141; x=1766054941; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Id+mKyK2rpQjMmy5lZn1vycT1sBmx/sBfGFCg09yGQU=;
        b=dJn5fM1tCVBM8fXtKmDMJRjY+Nja7qSyQiHH6q2jnM9b+7evZYxbHl51MBTnLO9Wyc
         TiMoNoLfHPRK8aUIpnVHwZZqzKgFHlrQsomX5AaEYgDoqzQVtk+NPepiC0HSUtP8rk0e
         k2yn6KJkLtlP7aUxtifn9TrFfwF1hbdcd5rXXpomO0gENxGm83WZwlLtvUoCcR4XqRzP
         JxpyJReMrXoWd+VX7/kAxCg0630gxD7dKeL5DyR5UpYr7uJSJ7KY3LDMCv7x4JALLTpJ
         b5TO5JPSVmUuRk2/OKNFgNpAlKZTBo1lDYafKL780s2S7cQb2SJndMA84pAT1cQYiKsd
         NoDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765450141; x=1766054941;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Id+mKyK2rpQjMmy5lZn1vycT1sBmx/sBfGFCg09yGQU=;
        b=Wcgj2xSmWpcOtLd46gEcHOQ6NxnEbYWY8YvRyBNNhc3beSfh+B/mK09VHWq66q1QZL
         fZYT1SiP3Mqh6Lb4wjX0yyc66d8lUJ4xriVUfOL+4XpQpf/ZrXCJhjbXJyW3yc+UTiNA
         fUBa1uVsZ1ks5R9cqtdg9EUVQyR3CfR6Y2USlacpSNST46QYHwRPm72RUDxivZ6sQyw/
         zGImJtk6TLfI7iDIeQZNzjqIo2WdQ82ogM9j8oqHrT5rgS2l144Ge3BuOsL1iiqEN9rZ
         biX/tjP9ib4nzXQ2jwK4/qxn+DXzEBujo8SdgRkAa15RuBT1tl9vZ3nLOfvfD2Fu82vu
         bp0w==
X-Forwarded-Encrypted: i=1; AJvYcCX3IPfnWncOawPzFxfvzPYS8smXUn28T85uqH/4qKatEE6GQwDNe9WPO24e4i1t1SHs9rWmzBNPwg==@kvack.org
X-Gm-Message-State: AOJu0Yx5qqHJQMEXoPBr9iVjUE+Yt4DDg7fvcb4dfsrAdXeLXWLK7JTh
	PL1sW+uqHQ4TnMHJByW54rVkKDD9Yy5gcvb/yy+JVd3DafR4yUp3huQQRZCKFZiOoAE=
X-Gm-Gg: AY/fxX6e/rD0nmpncFRZpkY0+cNVK26KFcDg16B301nGYTHLI1lZGA/S7I5mCQ+mc5g
	A6Lm3KG+ZpDv2OIgSEKHrWldARdr+gxfQb/UyFdqKmI14B8v+yV7OdtfANzmRFskFrJI1uwfVQg
	aPLeohYPete8lxBPBYd9dMo1FzYdUs6sjoDG527k3EWwE70i69BZPZTYox9im8LEYUiXubtH2DV
	44hSVTpdTKxYVde7FiZPTimlFSSezci3+4fj/r/fGdlaOyZR65+hZyt1qPtU+T6feAg1NdbMO/X
	pVTgRUkv6c3Nwl0VGQPGGmKUjafdz/0EzdQvarNYdQSYLslcpM1TLWKRKNEzsjq21QrgcvOqXf9
	tNq0lt7IgNtvDTRUoRMnT6QXhrou1RJJyh114b5vGa21LqqZ6yECPCgA8JeaoL7psOncqtOOQOg
	dXoIP8WmbDAhgfUDB1PHmqiQ==
X-Google-Smtp-Source: AGHT+IEBLP4GufhuQ9ivk06ROp8MdpmTBKZZfneqKF/kFhPRh8XsQe0Q9OfzTGlG+nMO6BdDjT2lXw==
X-Received: by 2002:a05:600c:4685:b0:477:63b5:6f39 with SMTP id 5b1f17b1804b1-47a856249e0mr47088695e9.19.1765450140799;
        Thu, 11 Dec 2025 02:49:00 -0800 (PST)
Received: from localhost (109-81-21-76.rct.o2.cz. [109.81.21.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a89f05cebsm10241835e9.19.2025.12.11.02.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Dec 2025 02:49:00 -0800 (PST)
Date: Thu, 11 Dec 2025 11:48:59 +0100
From: Michal Hocko <mhocko@suse.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lujialin4@huawei.com
Subject: Re: [PATCH -next v3 2/2] memcg: remove mem_cgroup_size()
Message-ID: <aTqhm67ouVl8CHQG@tiehlicka>
References: <20251211013019.2080004-1-chenridong@huaweicloud.com>
 <20251211013019.2080004-3-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211013019.2080004-3-chenridong@huaweicloud.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 87CE6120015
X-Stat-Signature: 3op3mgtidqt4445s18k34bedn47cfqtf
X-Rspam-User: 
X-HE-Tag: 1765450142-715205
X-HE-Meta: U2FsdGVkX18WS4L9V9JWuQZJU6DaAr2e/SInqZJW/odKPd88DtN0k+7eEX94eu3zMrsFVTenfVvaZd5zwSYBeezrka29enYGrHXMlZt5TivCqKCnw3gY19sTDVAZPCq13ZBfhHLFgBMKLx6JVzl3+JcEPp7vHDwSele9T6pELCcE2mqPtG9UzvIjb2oXOfYZxlAVE6y4e9HjjV7t+YM0rmKUb0sY7CLUMdP1pLqfjraY8I+rwFApEgK9Mc7TdFdlBcq3AV3P/WVrjLCGFMatVCH6tbH5dpBuwsMt10u17BLRzkEfBPpOoHiUh9RmLpUEthQbtYXlPk8wUix8MCmI/h2J0PfLYwVgyr5PWGDLCyYFYcvsApdG22w00/oiTjS/n1QP1JZbcLNyQgWfiaooibR6142Ft8JvbLlwfQCVi4NqldPX8T7lT8kbZ72c/ZWx3v+L0L+LXfQrvK5uSLI7p61k7JeaGMEBOoGMEuoLpwh4/jue789ccFuaawA4+4ezVn0EaBZh26+SBTY3uuVoJoK85cNrJL9DG9fLlymeABLr+8rbBsg+HMPdzSYTZakQFrv6FepJV+s1ZEi23OzLJKljzkFyz/p/Y6GtKj+tbz09ZerS03hNnIl8B0d3BREsC+s+9xepUqUPrvBLs70Ty29gSQWsBDFjCy6tg+ySwI2Aj4W57FKbdQtDBJqfGIneXKk7tRPoMm9cD7bafKKGJPnYKNiqaH1cKHR2/k4nlAc9hp1j4PcGkAl164zH6xXPL89YvIySGozAOSlzhJUwCTOOcxuHhUru5BKuGDYeexdTePxNjjHdZGjH9yhmfZqVRtxrS7ehUdyEc1Kpy8RKaBVi23Dnr5SAbC9Bt0s4YYtrOUgRoaixJqtbyDKnTFTCBQ94HD7rOiK+Zcw8jv3pTb2ltd14Zoooa1NO6U+ZbJxzJvndk/x2KBE4JSVr41tfhtLgUsSfIzrgzoKmn1k
 d7brl30s
 E/74UeJ9RBp4kNVzoGUjqrzM+IpYA0iHcRb8e/uUEIt482o+SFZlYpqxYAy4jnJmmPLTzm6jRZfYk6aggMaDrOUV7ANO4gqI0aPKp3RgFcohKCdLwBnZLY0/7MbBqB/xezUA1MydWG97RxCE7hiOGMso235cwVG/CmnSDJVhuCvSi55xkB7KDLTl+4sao/nubm6vYYzry4ejw77Xwlzj64hUsnclRtv89ZYNdlvZJahjIi5FNNv7jC1X/UJrIEMkWwKiM7gK1BmLzAJi6pZ7KST2zn5JZ6pO6L+jRqldZkmMdYEmFX1LsDCB8nZ31ZNB+feBwD8PWNXd+ltOZIHNLGR5Cuwz98DNi9Wgk5sFCLp3c6BJdSaXTPdq29TEvIm3w85uXhfwjBAzwDgKLWKQHQuuzOvhj5witmCB+nCTsmKJAO+R1rKqr8qsDFbosv3dcDxMP84G3NdvxIrJKIVx0NEcM59/Hvit6TuBLCIeFd0T5kPztc3gfey/S2aqkW9lTKG/09NWQSRY+Xkw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 11-12-25 01:30:19, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> The mem_cgroup_size helper is used only in apply_proportional_protection
> to read the current memory usage. Its semantics are unclear and
> inconsistent with other sites, which directly call page_counter_read for
> the same purpose.
> 
> Remove this helper and get its usage via mem_cgroup_protection for
> clarity. Additionally, rename the local variable 'cgroup_size' to 'usage'
> to better reflect its meaning.
> 
> No functional changes intended.
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Yes, this looks much better.
Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  include/linux/memcontrol.h | 18 +++++++-----------
>  mm/memcontrol.c            |  5 -----
>  mm/vmscan.c                |  9 ++++-----
>  3 files changed, 11 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 6a48398a1f4e..603252e3169c 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -557,13 +557,15 @@ static inline bool mem_cgroup_disabled(void)
>  static inline void mem_cgroup_protection(struct mem_cgroup *root,
>  					 struct mem_cgroup *memcg,
>  					 unsigned long *min,
> -					 unsigned long *low)
> +					 unsigned long *low,
> +					 unsigned long *usage)
>  {
> -	*min = *low = 0;
> +	*min = *low = *usage = 0;
>  
>  	if (mem_cgroup_disabled())
>  		return;
>  
> +	*usage = page_counter_read(&memcg->memory);
>  	/*
>  	 * There is no reclaim protection applied to a targeted reclaim.
>  	 * We are special casing this specific case here because
> @@ -919,8 +921,6 @@ static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
>  
>  unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
>  
> -unsigned long mem_cgroup_size(struct mem_cgroup *memcg);
> -
>  void mem_cgroup_print_oom_context(struct mem_cgroup *memcg,
>  				struct task_struct *p);
>  
> @@ -1102,9 +1102,10 @@ static inline void memcg_memory_event_mm(struct mm_struct *mm,
>  static inline void mem_cgroup_protection(struct mem_cgroup *root,
>  					 struct mem_cgroup *memcg,
>  					 unsigned long *min,
> -					 unsigned long *low)
> +					 unsigned long *low,
> +					 unsigned long *usage)
>  {
> -	*min = *low = 0;
> +	*min = *low = *usage = 0;
>  }
>  
>  static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
> @@ -1328,11 +1329,6 @@ static inline unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
>  	return 0;
>  }
>  
> -static inline unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
> -{
> -	return 0;
> -}
> -
>  static inline void
>  mem_cgroup_print_oom_context(struct mem_cgroup *memcg, struct task_struct *p)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index dbe7d8f93072..659ce171b1b3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1621,11 +1621,6 @@ unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg)
>  	return max;
>  }
>  
> -unsigned long mem_cgroup_size(struct mem_cgroup *memcg)
> -{
> -	return page_counter_read(&memcg->memory);
> -}
> -
>  void __memcg_memory_event(struct mem_cgroup *memcg,
>  			  enum memcg_memory_event event, bool allow_spinning)
>  {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..9a6ee80275fc 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2451,9 +2451,9 @@ static inline void calculate_pressure_balance(struct scan_control *sc,
>  static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>  		struct scan_control *sc, unsigned long scan)
>  {
> -	unsigned long min, low;
> +	unsigned long min, low, usage;
>  
> -	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low);
> +	mem_cgroup_protection(sc->target_mem_cgroup, memcg, &min, &low, &usage);
>  
>  	if (min || low) {
>  		/*
> @@ -2485,7 +2485,6 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>  		 * again by how much of the total memory used is under
>  		 * hard protection.
>  		 */
> -		unsigned long cgroup_size = mem_cgroup_size(memcg);
>  		unsigned long protection;
>  
>  		/* memory.low scaling, make sure we retry before OOM */
> @@ -2497,9 +2496,9 @@ static unsigned long apply_proportional_protection(struct mem_cgroup *memcg,
>  		}
>  
>  		/* Avoid TOCTOU with earlier protection check */
> -		cgroup_size = max(cgroup_size, protection);
> +		usage = max(usage, protection);
>  
> -		scan -= scan * protection / (cgroup_size + 1);
> +		scan -= scan * protection / (usage + 1);
>  
>  		/*
>  		 * Minimally target SWAP_CLUSTER_MAX pages to keep
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs


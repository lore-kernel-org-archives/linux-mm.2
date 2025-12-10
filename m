Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 512BBD2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 08:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 762206B0006; Wed, 10 Dec 2025 03:02:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712DF6B0007; Wed, 10 Dec 2025 03:02:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 628856B0008; Wed, 10 Dec 2025 03:02:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 517086B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 03:02:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9C86C043F
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:02:01 +0000 (UTC)
X-FDA: 84202818042.21.985E51C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id B14538000B
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 08:01:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fckKPeqN;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765353720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DkVuj9mbdsClta7Votk9X9DX3sJA8TqrW8wJK43sNi0=;
	b=kbqa/l2HnU0fL98fdjx/RcfT+pK9VKR6mu1gZckUSguMKZskaPX+UZGeWpeeLG0tEDe4Gi
	8f1UszOaKik/BoO+kmTVSJWB47VBsjexWQiv/MSBv07prqbdG8Us2RID48NQGYRCXyepeN
	mLVcn6MOUZ8eCivBjP0J11Mz1sQIFHs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fckKPeqN;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765353720; a=rsa-sha256;
	cv=none;
	b=WTugK27rMjFa1IFbRxgvCLY58aba5MQzxRf/MIqkoUUnz4oxAlQuHPyM0WiSGX8fXKgBOc
	twxiTNLKnai1ZSztvNGXmo/NRqHBptoPIOGXriXRnWOlas+aV6kKEqjTRdduRMuEGFdmoF
	fA6exxoSNjz9oMlRkkjY/WnFsCVb8zg=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4779ce2a624so83482585e9.2
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 00:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765353718; x=1765958518; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DkVuj9mbdsClta7Votk9X9DX3sJA8TqrW8wJK43sNi0=;
        b=fckKPeqNlalJQUtrHpehK47QU6Yc3lJyFQ2+Ov81/T/5sV+V1uXbCd+8enwgr50JM0
         mDIQCX1lxPcLMWhYJlESOpRkJbowTMZ/Ik2NvIgnCpyckW09+heCX5xFyZAXHk8Xw+NJ
         13Ev9ABj5EoU2mTwhhLFGcM5yzsRAq7lgu42kW/LGMDw8mA5hC0x2CjAP0ZnTnWIqhsi
         5cvgMmEfL9OUA54WaEZ8cEQAW/tJNitaPr+88oSpU3GgHLFPM/Y3sYg+PfdhqqJIA/Jb
         iNqf22nkVtcurMChYZu8oQil3z0sOvnjW7UQgAZ2QyOlAIDM83sjrDeMG6EXxqrZhIF/
         ICZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765353718; x=1765958518;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DkVuj9mbdsClta7Votk9X9DX3sJA8TqrW8wJK43sNi0=;
        b=YHPS+VjmHZ2M4BIxBLEl17JRD4qtUC272rEESB1AFs0p4y1iF2bnyWId/6kfn4LLpb
         zUZ8haGz5VkHjfFiPv34uLPE/lSTCDC4li4SGed5V8VeXU2T8H1Xe+xEP5b54gmy0jLm
         mbEwYvr1ztXX1+DjMaxdTizMxlzzLt164OyQh0fDrmosyV6w10jEX9nnTGUWBL/eR2fe
         zkVVgWc93nicDtsIgPp4rz5wRZphEP7E71+a3avbZQmQt0uWA5Ka2x90fUqIBmmmT/0I
         uM9tmkv+lnaUYYlMLBXEvMM6sja+ERjljgq7RpaoMW9Y3b2DTFl7jxjXivKGXhHp3ewC
         +26g==
X-Forwarded-Encrypted: i=1; AJvYcCUJvF1L+iBP94cZR/hivNQDIQuHKWImgg4+1e+eijGNDp5USUltBC3i/AMXLKuH0I46f7LB3vvNfA==@kvack.org
X-Gm-Message-State: AOJu0YwnBuwy82EGyICo6NvN7CmfCNENj2WomJTTy4bZ/xAXnmRRznyI
	6Ux7Lge54XgF92So44SlUWg5+xTJoWxzPfMmrnPJiiH4YS8nfizmS5HA3xeGoEXYnfo=
X-Gm-Gg: ASbGnculKfR3ACC9F86gSRO6oQgu3UdpPs8gVItBGjLRg9br9fOYBYnWgRTMsjO0Iy7
	+XHYWzsUSw5fNYGQJqEq3nIk3dP/+7JBDtviG4Wdy2L44Vf/prLd+1AsI3VhRmlhyijM3mPNDDG
	skOdHte8lr3cgc/QK0Ai/CBTwk2g/VQ7P4eoek25Rk0fl+XoGkYifAvo09PsMyf43JFtlaz5OCR
	ORhqqmcFUHcOrOTtr8MRT04j5H1xL8cyFID6XQcdyFuC2aGIqq73ti+XUuCl76iiSHzALsJoCXR
	sG6+UyKH+xYi5JxrH/XnC8ufCVq3MnJS14H6kpxpKV+40TT7pudErBrjVYZynHdjuTlXpbG5Hdk
	kS9I4O9CQMqt6+d2OqEjeTSSZ2SgyeRnGLGF4K78MVfYGul9eN6BtHwKDEBYvO0CxoUTR9eP6m1
	I6fIdplpsFTOSVQFsbvHe4hM+S
X-Google-Smtp-Source: AGHT+IEy/SB+X1dvqUJNoBvVJAi+SW3SwFAbjV31jUhKRSf9pIbkpxwopdcXvKFxbuwv92aXLPBn+A==
X-Received: by 2002:a05:600c:c165:b0:477:6e02:54a5 with SMTP id 5b1f17b1804b1-47a8378cdf5mr12959395e9.18.1765353718060;
        Wed, 10 Dec 2025 00:01:58 -0800 (PST)
Received: from localhost (109-81-30-110.rct.o2.cz. [109.81.30.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47a82d31ec4sm32888435e9.8.2025.12.10.00.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 00:01:57 -0800 (PST)
Date: Wed, 10 Dec 2025 09:01:51 +0100
From: Michal Hocko <mhocko@suse.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	lujialin4@huawei.com
Subject: Re: [PATCH -next v2 1/2] memcg: move mem_cgroup_usage memcontrol-v1.c
Message-ID: <aTko72qBxxm2YzHT@tiehlicka>
References: <20251210071142.2043478-1-chenridong@huaweicloud.com>
 <20251210071142.2043478-2-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210071142.2043478-2-chenridong@huaweicloud.com>
X-Stat-Signature: qugbhdtztxydm1m4n5fzsudt1ba5ag3f
X-Rspamd-Queue-Id: B14538000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765353719-853040
X-HE-Meta: U2FsdGVkX18LiDvk4D/df2UzfRB+LrbMDi9SMHskeJrND6bKNAr86I8zmF/57UxPdynpoVI35C+BLWXKbcyq+1QdnCaSjpPgCtfxDSEH+DnuvqEET21Zz88d9F50D6iTyIJI67zW1EKvsat373rQLsqPl3yW0R0DKaZm2Iv3z9LjMHHAwrA9iBwDobVcHQhq5OnzNr84nmW+kdOZDsnn+4w6LrzcaEa28Q8qdVsaV00g99ViivslWSuuYP/4/vrcF7D5bHBIP0SajGVLcWGseVmGMhFc33W44Ez8rTeTx4YHrrlKSgBWsUIB2mQOpoBASjtTo215C4t13ULb1klsr1BvPYhUWr1nV+8QyYFRw0j1Vkl2BA2HARV0cqkvx+W+bQyZt6QuDNG65GKs1iNvDEeTBuMYuebw8SdE2ilZ2i++xPO8VubwkHsl1C4c/P7tBTfY5kP4F+CjTDoQsn555UzrUPyLZUIhkJEZr97tOAbiwdfxw7rXHwQFFTZQc8PM+Pvb1xf0wXj71kfKDa6LHMTueUMjboETzaHfPkJ21caGEq/lfAe7fuTs7CmGL//5XfezJEeJ/VqjorETtWVqu5FTqyrmZxmVu6EKR1V39DZoBa55NkDzJ8cO21pG+q83WwOg+cXsCtvE3wzvygODJfGN+A2yLkmE0XVnIHtXkc8G2PzjRaXwFzHvx+lXTjgM+/UtE0AWFWgSJhLVMcy3GVgvHmibibYEoAm/1Dv4Wg1MxOKLdp43HxloJw4tsZYOJ4Wli8zYfT233hXcHqdrss8YVLya9ENMRYNnbzvn18rTFYYcA5hqb/R+U2uw7v6RZplIMkHNcKFlAykH2x6QsQiA7RfKGMaFKivygltmFLVODEMsvPTGYA/Ko5YDQ1Bm+0mUATLpZMkJWYRDQFM0f53TvGqsBRD/qN9a+0XbNaCsZqzuI9W229PtB6jLU9VlK1z2z18Ahrs2shU/awS
 VN61bJR9
 mP3LeISqOlmVpPLMigJmuUz5SN4AUmuk0d9JRx2k0/KfHyURVfvletSpMdg0eUfGT69nNjHzdnTQXzWwq8+U8C3Ex2ibS0+EAnUkgYUHQpJVYQwo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-12-25 07:11:41, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> Currently, mem_cgroup_usage is only used for v1, just move it to
> memcontrol-v1.c
> 
> Signed-off-by: Chen Ridong <chenridong@huawei.com>

Makes sense
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks

> ---
>  mm/memcontrol-v1.c | 22 ++++++++++++++++++++++
>  mm/memcontrol-v1.h |  2 --
>  mm/memcontrol.c    | 22 ----------------------
>  3 files changed, 22 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 6eed14bff742..0b50cb122ff3 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -427,6 +427,28 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
>  }
>  #endif
>  
> +static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
> +{
> +	unsigned long val;
> +
> +	if (mem_cgroup_is_root(memcg)) {
> +		/*
> +		 * Approximate root's usage from global state. This isn't
> +		 * perfect, but the root usage was always an approximation.
> +		 */
> +		val = global_node_page_state(NR_FILE_PAGES) +
> +			global_node_page_state(NR_ANON_MAPPED);
> +		if (swap)
> +			val += total_swap_pages - get_nr_swap_pages();
> +	} else {
> +		if (!swap)
> +			val = page_counter_read(&memcg->memory);
> +		else
> +			val = page_counter_read(&memcg->memsw);
> +	}
> +	return val;
> +}
> +
>  static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
>  {
>  	struct mem_cgroup_threshold_ary *t;
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 6358464bb416..e92b21af92b1 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -22,8 +22,6 @@
>  	     iter != NULL;				\
>  	     iter = mem_cgroup_iter(NULL, iter, NULL))
>  
> -unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
> -
>  void drain_all_stock(struct mem_cgroup *root_memcg);
>  
>  unsigned long memcg_events(struct mem_cgroup *memcg, int event);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2e49f4ec9e0..dbe7d8f93072 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3272,28 +3272,6 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
>  	css_get_many(&__folio_memcg(folio)->css, new_refs);
>  }
>  
> -unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
> -{
> -	unsigned long val;
> -
> -	if (mem_cgroup_is_root(memcg)) {
> -		/*
> -		 * Approximate root's usage from global state. This isn't
> -		 * perfect, but the root usage was always an approximation.
> -		 */
> -		val = global_node_page_state(NR_FILE_PAGES) +
> -			global_node_page_state(NR_ANON_MAPPED);
> -		if (swap)
> -			val += total_swap_pages - get_nr_swap_pages();
> -	} else {
> -		if (!swap)
> -			val = page_counter_read(&memcg->memory);
> -		else
> -			val = page_counter_read(&memcg->memsw);
> -	}
> -	return val;
> -}
> -
>  static int memcg_online_kmem(struct mem_cgroup *memcg)
>  {
>  	struct obj_cgroup *objcg;
> -- 
> 2.34.1
> 

-- 
Michal Hocko
SUSE Labs


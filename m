Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78ED1C44532
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 01:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870106B0093; Wed, 22 Jul 2026 21:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8996B0096; Wed, 22 Jul 2026 21:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2126B0098; Wed, 22 Jul 2026 21:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC7D6B0093
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:59:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C226CA0D50
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:59:43 +0000 (UTC)
X-FDA: 85018385046.02.1CC245E
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 88E6E100006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:59:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Jnvp3NAl;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784771982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ME39BOUsgETsp9b9ZszwmQSxDI6GW0t/fX+N/500D9c=;
	b=GGfXwzhJgV8AJDePRmK0TOLALL7yAGNddzcBljQ9syLifBzjl0rHsGrSv1gSwyw7HiWbzw
	aFR/LpdOfYg2BFHAEAchdzuPCPhKR1Gm7iY8jUrRuLo7cmCqSNvgJuED9yz3W9vdqgdCu0
	9wi+LMSW2pKa2mLvjwaH3dMT3LzhvcA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Jnvp3NAl;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784771982;
	b=G6grsrCpvNjymoKG7a9hucsK4y0uGu6P35qKMjDC29hLmWCuYkCJSptiRIWvMmQfiqQ5tK
	ihWwstxgNYO5VNTXzskq4lesOaZSDZbFkcBExIw0YaB7f85wXl81EIXlCYQ9XN6iQAS+0q
	J0/a8MoLemykoaVq1cNXvaDKpV3/tGE=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c08df8513so500711cf.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784771980; x=1785376780; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ME39BOUsgETsp9b9ZszwmQSxDI6GW0t/fX+N/500D9c=;
        b=Jnvp3NAlAcQ6ULu93Kd7ms8f4bPLJevueLTPFvPAXiriEUzT2GX9pHEnypkoC0d3U9
         4GMKI9a/CP5ffKX1XB8xIiv79Qmdjohs6ZziqKeM1BTERrnD8ruxbQIb5GiLxRAAhGAO
         xDTAnlGgJGlmBWM6Wy3GAia8QOkMgEEINH4WmI4+ZWd2DduCrthgdndeXehSEqwgd98N
         CFeM2sJ6aOPtZeESs060iddCT6coIvbQTGBcWSQHxdsaz505XA0qheAK/LpTYNl4jJQv
         6dM0ZMtTvvwcOt9SgxNFVPhHh2bftXF6vnSkh4SHMh66l5BdVqNsfx8LmO4Yl0PabdwX
         wsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784771980; x=1785376780;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ME39BOUsgETsp9b9ZszwmQSxDI6GW0t/fX+N/500D9c=;
        b=Mm6FAuGpt3IKvDpZHtnhwlTFriR6o+Ui60SRBT8CIMAr67Y1EBWJ90qbTQWtzxjcaj
         vKyHygRtuakjDh7+ipoMdNPT/AtIU2BI3KWlWQMUvj1/EwS4PkFCFjdw99pqptITmFVH
         Mx6/tp/KbisaYrzqe7Cmk4ZeVQCXV9GkjQhhH9b+eoWKJS5gCU4AqvtLT1sdTusDvwWc
         Uf/fHjE3BaKU3Kpxx4Hpni/YqqqxlDNUCD6CiA4NvdT7LdKbfY4Xx8kWh8TwVblP/EeK
         M3n5XHV3pirHbRnY/9uKoYV2ld2ieegmrs8I1dq9HyQ6T+8E3wNhnyDoXwbqRmcSLunI
         5c3w==
X-Forwarded-Encrypted: i=1; AHgh+RqOTOoSWuUx/QPPRg3gKtOKHsTzq10r7dK84TIZo3B0h2WqlKGz/Q9zCuGkVfYbOnQWjBdkBtOI5w==@kvack.org
X-Gm-Message-State: AOJu0YyvXAR77ii9yd6PzX6DJJIfR88qhvP/ZfK/wRNz/VeNBPoDsK23
	drEgVtOPl3KrUz6XMPNwH8B5eCEcH3CPaw6jnS9LuOVQq2Zmln8ejWNyzL5shQaoMI0=
X-Gm-Gg: AR+sD11sMqzEGpzus/QG8y4CRdCGXypeqiuQ0JR5oVm2fZcm418fQsMXDoX5OoOohjg
	bTpxYvOp1QXO6iARwwuh6yub25LUdYt6ezSK/QYUVt8CaaoTUWArjxiWt8jk3VP3taNXsdiHKzn
	YzpRK0dpCWVYNIU7HuSobyhvL1cp2awtDyjPhemXAmVH5ks85Cw83GVszQoCroTzNX126dgHX14
	tdhVFDQ8lLjgc7t5xnsJ6sxVv7yq9yqNDZk7CwbOSy7uoG60abbbws0TcvsII4iQ4Bs+QNQZc1e
	l1AFJZAfvqKitHsGtUrvb86zz71W9CXv4ksDjfJI8oFmeE20HYRqDxLA8GqS4sok4YZ8betmbEj
	0xLwpmvrTI0UyQSGGRdK5Amz0WIlkgQwk3cwtyKZzLvXiX3jIaQrx4FGEt+RWV1fakJe3IDSbFQ
	jy
X-Received: by 2002:a05:620a:440f:b0:915:8f08:5fa7 with SMTP id af79cd13be357-931036d2152mr124807685a.52.1784771980540;
        Wed, 22 Jul 2026 18:59:40 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba9e18aesm34212396d6.25.2026.07.22.18.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 18:59:39 -0700 (PDT)
Date: Wed, 22 Jul 2026 21:59:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 1/2] memcg: move mem_cgroup_swappiness and
 vm_swappiness to mm/swap.h
Message-ID: <amF1ii74RlzKiepO@cmpxchg.org>
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-2-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716031729.1064007-2-ridong.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88E6E100006
X-Stat-Signature: 7c3dfn1ezhrfpkxdqud74qmx6xz4178q
X-HE-Tag: 1784771981-132707
X-HE-Meta: U2FsdGVkX19J+GaDFSUM9Fd0pRbCu98l19KjDnhlOvBXFMtItWQeT+no5Vd6rbNrGZeX81jK15zFPI/iki8VlO1exbpJYaYsouqqhvsuIeD/CSpVEeYl8S8NTmUv1QuJ++VA6UHiLCe45N4wcWFsFuVid32oMADbX/wfntP1bzRmBfUQ4aUmW+024zamAyrqQaWEDOhnoINCQLCbaP+0kYmRWZe7Nqw5XoDcKghXTSYT9oh3cTlrmr94mMO5iVdDuFsdhnMLoFn2uXfVBMA0WqjMMsu7wYvHTTXRBGUc372SFDr3rN3qKXY52ghCQQ9CXtWwiyj8XnFqJCaZPTFPoohtM2O/8tQxLb+mrqiJwRaTgYPE2+CxRxdH021jmZzzXatJAcKAEmSdhE/Ux7N04VslPpwdHJR3yhfBE88i1BnJqju3Z5WWbPYF4NeeNpBE1ctDkKif0Vww37zD0/QA5WjTA9hYvlq3bLvOKDjoLYqc5MUeEu7nZ2k+315VaC8k8OECojQOfcp26BV2mYXyG8hdNK6lQyeBVvUWVywiUR5oOoVCK5qxkMgPYK6wALuh7fCaiklWVBnC/w8mdCL3X5088faEmTFByCRevf3Uk6G6hh7J32UbEsGIEf3LdEz9SBOy0qhfZCn0IUlJ7TBNgHiu2ziOhDbzsFD5ZU7tpGMEm7YtcUVxcO02E7FlPrzlNA6oyFzUbqk39lhsE4cNDHTWskXXS+BSrFlm5OxRg/a8DbJtKxNrCKDh+0MUaPI/NyHqe83QBM2Y09jmv1tBq3/UT1dIvLmkzoYNVeLmzZMHITu8JSnqJtpcRBELBJzRYJsigayzftkFzGfsVKc/z7r/R4vLnR5I/vowybq2m6RzTZRP5xIIYpYGg5SIVysycxEffnRVspXB5kjDDRPKVPye71cVevjP53+V3a4t41m97ACUguv8ib2cC49MzbmYBpKaO5G2/5WFY/lbIok
 ke3hZn8x
 fz1Qyp8pl5H3LQX4voZHM3OYmcnpQSDkBVsDGAyi15nplTAQP6Ew3CnD1sJ32pC2y6uaeF37YUq7CP5A/lOuaxgzKDaiKH6/xOTWIbGLD/wCdGgmglc1LzHpL+fiplrdA/VWOHFsZnz7n9M13e+0Cny077iHGBsH9+9aiEZvkqSukBQbUaa860SL1+xgHxORkFlHY2gRaHR4/GMkoK65pHKka6bEEIvqWaLOqkv/6tOJ/3dm5DAqeKIsjreZbjHQ1C6e+ditAiWBo2+5sgbLxRfp2onFk7KuNI29wIy00//SAWMNyXkBA2ycl9IWQFcMSFlCM5y/ohsQiEYoHw7/z4X1DywzSsqb8hi7+nxyBC1wGhBLOZyp7KUXD57YhrGMvGpKNJtJm7cp/jMldviUAp7EfGSbBq8CjViAgFacYQBj+vz7ZWP4vUaTvfvvPyaFTPZlVekOktavqUGaDc+zBpejSrjnXnuEeaDbu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

One small suggestion:

On Thu, Jul 16, 2026 at 11:17:28AM +0800, Ridong wrote:
> @@ -76,6 +77,25 @@ enum swap_cluster_flags {
>  	CLUSTER_FLAG_MAX,
>  };
>  
> +extern int vm_swappiness;
> +
> +static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> +{
> +#ifdef CONFIG_MEMCG_V1
> +	/* Cgroup2 doesn't have per-cgroup swappiness */
> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return READ_ONCE(vm_swappiness);
> +
> +	/* root ? */
> +	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
> +		return READ_ONCE(vm_swappiness);
> +
> +	return READ_ONCE(memcg->swappiness);
> +#else
> +	return READ_ONCE(vm_swappiness);
> +#endif

How about:

#ifdef CONFIG_MEMCG_V1
	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
	    !mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
		return memcg->swappiness;
#endif
	return READ_ONCE(vm_swappiness);


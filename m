Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3EBD68BE4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA36C6B0088; Thu, 18 Dec 2025 08:32:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A26A86B0089; Thu, 18 Dec 2025 08:32:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE0F6B008A; Thu, 18 Dec 2025 08:32:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3856B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:32:53 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 26A4C133C21
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:32:53 +0000 (UTC)
X-FDA: 84232682226.06.0F7429D
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id CC5BB140013
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:32:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=eJgbVHQP;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766064771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQWA//U94w+RfVBDi+XEBJcp+dqWUOXxb8pArjVqn04=;
	b=b05isjkVrdfYs9w7KnltXYuMHiNwwDh8ncOpnJu4dyMvkUvlSZhUGGAWK13Gg9IU7KauUq
	LC53T98ghuW17jJOvMIzYm23hKZU+FpE4YeORHrZ1w7uUpH3wWhjcAhtITGDBInNQY4XzO
	vGhRrupwCGG4vFfdUoDEXjiTdOexQcc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=eJgbVHQP;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766064771; a=rsa-sha256;
	cv=none;
	b=D3YLdBRL7gb1MSxkrNjRFhMoI4S2F51g2bv4cRqUqA/WjWNTI71gcIt2rccligkIvRdM6k
	Pb8JaunEDiHQMhOEbeb5X6kEvoXok6I78qO6wKUE7JsPMNtmy6r6oGPdLIxl6y+zzNCIf9
	0Iy4PZ6FOhI+tIZY507fpWaJsilHh30=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b9d2e33e2dso94680585a.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766064769; x=1766669569; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQWA//U94w+RfVBDi+XEBJcp+dqWUOXxb8pArjVqn04=;
        b=eJgbVHQPHQ3NJg3eeuo3BDPN0UMlXid0uBGq9Q6gdokEdI82L6GoeQAz48OMOhoEcr
         ytU6DR74LsfhO3/K73HfYyb7f01bzqqpp/oqEp7xTDY2FXv22iG31XAadF4/pSFp5cDf
         TmCGcuYHfXCb1tn97FunJ+izbZWuyLYCW4441sIFL1yKhQVmStb+48dWJsJ/QcLRHRBh
         1WLFsyCY6v6pz1+qQD8pOwx3k5XiXfZp1dwD7yZyBfoWhUTl/cqZpTLRBHcCsEFWTaJM
         58GSecfvUftQQw1vqIuMLaLcq5E/N3UrY7uRsYY4L8udUP880lqlpvM+oeRQPdePmNdU
         H1KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766064769; x=1766669569;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQWA//U94w+RfVBDi+XEBJcp+dqWUOXxb8pArjVqn04=;
        b=F2rOmrKGoCRrt3URcVWRe0ms5DfeecBij2n44GrOt/6m8qR6toEY6i3DgkNXqSl2E+
         o5Akkbgs06lNU27byCOeyrknUh780bsY3pro0f4c+LBjLNJ658IYSS65gtQut8oqkf7N
         YlCcnX54RaExBhBj27LRUIZEiSuLvYTHrYNKR6oSkDt9SnbDexUn6WY494t982WzOKJS
         if/nAKCkNSbQmfKMcvxwKIhOvgFAl783lSdjZ0PqaNL++1RzZr8/xG6VWqIrX8hDpwNz
         0bqW1zaTZfZaEwxYyZHa5CbYhTIe/uR+JtSVQnZPE9tEN9uQfCyzqSlLxiPHlFPGHEnV
         X7AA==
X-Forwarded-Encrypted: i=1; AJvYcCV251Geq3dSYE5aAR0gVOXrMrqi91zTu4bgPGaBf4WfbyOrh5eKvZcqgbMylmIYraetV/7UdIV6TA==@kvack.org
X-Gm-Message-State: AOJu0Yw36XmFUBz+pRKdBH74KtSvFjT4+J9az6GEkzGXanbmW1kCH/j0
	XlHVkGd6BubqJdoxOY4PyOmflR3Oiepqy/Xr6A9VLkQWgI+E8FlW9QXxxoNYp5maixo=
X-Gm-Gg: AY/fxX488qypV2zx1rSUVQUflq7sOgSrC6Cr4VkRfmmExX3hNX5fmTLn/EN7mCSZqun
	4v8N4CKz1Bq07sg9HqOF/2oTPnjL/NnFDe9/IM52cUhJ706lv2zymsr07XnyTtjOVkgdmnphygB
	vi5Yj0nz9zEyn/zaWjBss+tLlPR714DKohLIvworKvmXSepV9yhS3eladzf41C6xtb/605086xp
	Wjzg89NmfM/bGq5mvFg347ms8Dmj8rj4OJi90/5nfEgLrQQ8J5roapqzSIQ4Ar8RSLsx29Q0pDM
	lqiSRHnvRttX65y/SHyguxLzt6TJVCHevkfTG/0P9v03THKa2zt4mznemnF9tz0NeHpv5rskHqT
	CFGC5r2S0uAEGdGtsl75aJjShGnfV/v8WGdSTOktXBocq7vNHmK0dD3R58eFAnQe2oxJs1+prJ0
	tFlc3W1wvHnQ==
X-Google-Smtp-Source: AGHT+IH3FUksskKCGR1DNGkk10snBCU32vYx1Rd56tm0XXUZfGBDWgz7+GVVqCXyzIf14zAp0WBPFg==
X-Received: by 2002:a05:620a:319d:b0:8b2:74e5:b11 with SMTP id af79cd13be357-8bb3a39c0d7mr3122332685a.82.1766064769594;
        Thu, 18 Dec 2025 05:32:49 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeb5d5fb7sm170608885a.7.2025.12.18.05.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:32:48 -0800 (PST)
Date: Thu, 18 Dec 2025 08:32:45 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 24/28] mm: vmscan: prepare for reparenting traditional
 LRU folios
Message-ID: <aUQCfdnoLQDLoVyg@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <800faf905149ee1e1699d9fd319842550d343f43.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <800faf905149ee1e1699d9fd319842550d343f43.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CC5BB140013
X-Stat-Signature: j73bksqf6yyf34sdqkfus4gigmm5fhc5
X-HE-Tag: 1766064770-350458
X-HE-Meta: U2FsdGVkX1/Xf9bwDt8IZuQ63jbI4cWz+Kg7YnJrpjn+Td73Vu9m0DW615V9l+vN4af7GFRxUl6dA0JYSNyntnKYWzS9KrSXBPkenKjawwuVQ/b7HvTw9gzoEb0KHuOEl+mweDwq/HdfT1S+v8L6NDgqdKyqznW2wuwVbO7KoD/ChTYfZzGT6VCjB89isFLLStZA85PGslwnqNljg3YgEzrooUL2mwHx9xKdWt1LqKpCG75T8VN0oajucD5diYxQKZ1IlP5k6qdfwG1xB+j6QmbTI5hC8IPo7F7Kxa+1BZYIX453AJs2VefB5YyfoD8AGnqLtNS/EYu/rLTWBiM27sOMy1aNP+57ZtzBczZR8GUpO+maRnZTQUHr+9COrRey/fU+CJZrbGNipBPBulrmhbHE97LWw9c+JRmlCfjyC+C6muzf30lsR9aenRSzK/wXG6+NoMHphgONcULMfuWkZVu3NwzPVBjBIfsY2llqJdzuJLhmUaRx5jAl90wsBBf/+LZDlYQs6BtQSDQR71aPl2zCRwTfBiykMlgvEam3TNJLnPFM3wdujgYbDif4ccqMje8RQ4TLG80epghJHBmkLUkWdpDjno1eayLAh0sOY0kA0haKYMpYPBK8i6jXXvGxCZHNMMlElBrIEETNGigwCn2zvsUY+A1l1yDWJoYOPQzGMmhLQY4jsxd9n6pTFWJ4OZXMvMwZ5atJ1ZmRjpVskhbwE6jFWFWi5nSWQz2Zim+wxXIJ+r2ZC1Arv1CMH+WPF4XuVPPEYnn0d/yE2ZcOXDQMkBjBq9IFErYKts+eV+sfjVuRXRJXHzqctw4rWojp2NmUMrqP8qhSUoroiQl8h8DwlWFgUAp1jqq7rzg7Zs6DOA6DGrW1Ql6Ytv7IOlXjXe4yc1C3NxnXklinaVmUgAL7o3HrQYDl7cgth+4LYcqCLMbiCamob5/r6wEJ2/f/NzUU9JxEAFTkgbNJcLF
 jjm6ZTEg
 BGdngPYjb2iqZYHHdP121yB/RWjkCkDS/cjvo9/S1Zogf44OlMahTHZyfaSjIaDPj39Tr8ZKOeYFRgq800LxG4aFr6XQI42WNyuvjyH6Rz0XJA1lJU9CfJoZXaOoqnWQTJJIVepmtEFtY5HFP+5NUOTJ5Hf4aNrAMJp98eqJd0ih+CzcogHB2pYNnx44SsKFPcnlvqq/WYcSfw9sqRzwUM0dP+r3+h58kMprEc6u27HkPIIjmPOeKdzxgujjTJ986GB0IOr0M6hvXbXRZ7mF1eFUg07WYUKWxwsI/gUxxzttq+VE0hGYyJxENv8RUzv17IksADJ/p21iyYToOxO0r2uNEAewgLbtprJJ/+NgfaCYus2inZMgSSUKrTY1Sb5xWjIpGtGklq4fGURMZhJGu9rTNnegGMsHT7fnBKyapjQRVOZbWxHQZZbOQwTm0wIUu6M5oIXhnZPc+GY/gk8PHYss/5oyOjwjiK9PP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:48PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> To reslove the dying memcg issue, we need to reparent LRU folios of child

     resolve

> memcg to its parent memcg. For traditional LRU list, each lruvec of every
> memcg comprises four LRU lists. Due to the symmetry of the LRU lists, it
> is feasible to transfer the LRU lists from a memcg to its parent memcg
> during the reparenting process.
> 
> This commit implements the specific function, which will be used during
> the reparenting process.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Overall looks sane to me. I have a few nits below, not nothing
major. With those resolved, please feel free to add

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> @@ -2648,6 +2648,44 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
>  			  lruvec_memcg(lruvec));
>  }
>  
> +#ifdef CONFIG_MEMCG
> +static void lruvec_reparent_lru(struct lruvec *src, struct lruvec *dst,
> +				enum lru_list lru)
> +{
> +	int zid;
> +	struct mem_cgroup_per_node *mz_src, *mz_dst;
> +
> +	mz_src = container_of(src, struct mem_cgroup_per_node, lruvec);
> +	mz_dst = container_of(dst, struct mem_cgroup_per_node, lruvec);
> +
> +	if (lru != LRU_UNEVICTABLE)
> +		list_splice_tail_init(&src->lists[lru], &dst->lists[lru]);
> +
> +	for (zid = 0; zid < MAX_NR_ZONES; zid++) {
> +		mz_dst->lru_zone_size[zid][lru] += mz_src->lru_zone_size[zid][lru];
> +		mz_src->lru_zone_size[zid][lru] = 0;
> +	}
> +}
> +
> +void lru_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst)

I can see why you want to pass both src and dst for convenience, but
it makes the API look a lot more generic than it is. It can only
safely move LRUs from a cgroup to its parent.

As such, I'd slightly prefer only passing one pointer and doing the
parent lookup internally. It's dealer's choice.

However, if you'd like to keep both pointers for a centralized lookup,
can you please rename the parameters @child and @parent, and add

	VM_WARN_ON(parent != parent_mem_cgroup(child));

Also please add a comment explaining the expected caller locking.

Lastly, vmscan.c is the reclaim policy. Mechanical LRU shuffling like
this is better placed in mm/swap.c.


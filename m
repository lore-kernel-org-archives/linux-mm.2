Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A051DC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A957D6B0095; Thu, 27 Aug 2026 13:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1FAF6B009D; Thu, 27 Aug 2026 13:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0556B009E; Thu, 27 Aug 2026 13:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6035D6B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:21:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3B71A0152
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:21:46 +0000 (UTC)
X-FDA: 85147716612.03.4E78E75
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id C893F20002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:21:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=oakA8L7s;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787851305;
	b=QRRfjP4f1Q9+kapV9rID1nlaQiT4aVfz/RQ6QmDzOLfPCDQ/sAMsAtVV1PYjLptpB/+DLR
	sb+L3rop/ft3a34y8/dr8xUr0v7PbQIIzkmdyyelNjC4UGWhvLNRvznj0+QbGDPT5zs1Pl
	IOr9ebhnLPz9PIbvDPRwpZhq4gD60aM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=oakA8L7s;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787851305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrXvqZ4Uoqu6reOsdn9gvEt7CTtol+8nWaGWRJaprE0=;
	b=ZKc1z3MJhQvSa3C7xquVxnM+3BwJirPNCkJ6lijYZ3GrSE8Nwy94fz4HG+RYrO30qAIzMk
	5AhvdQZuZx5Cq5tz4PV2cV8CRE/Y/9DI/6QIAPKyHz6kCyYY8YewgeSwHS/o7zCUJwbccj
	3CVR7yf7Z6wGT9RegiN4h+oTM/5aiCs=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-836c718715fso843097b3.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787851304; x=1788456104; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xrXvqZ4Uoqu6reOsdn9gvEt7CTtol+8nWaGWRJaprE0=;
        b=oakA8L7sAk8KK8D6cIRRDCv46gaQBdera/d61XoC21M4lPP4J0Zya9OvkN7pkUQf8z
         1ekeXrr6FojYpOTa5Pxa2aEwXlgxeawCaV9pb6Yu/ReX595yC/mxXmrHWHN2rGzY4TcR
         qohLY+n/X7UG39lxHyEgpuQixMsD2VHHFAiBHOSS45cxgsGwuOSIiALI0rcBq/NKi28m
         DgyOVvfYivBE4NVcvSiCJWk1qSNjUjweeBI6CgrAzBIZDmmZ/3NxPe0g/v4HHjS+4VEj
         PdYYxrDf/2YTGK2PWqTEn2PT9bBWZQe4DfWEOtdTWL2nID7lVQV8RaoMt60CO3NVtIaT
         /kKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787851304; x=1788456104;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xrXvqZ4Uoqu6reOsdn9gvEt7CTtol+8nWaGWRJaprE0=;
        b=Dr4OX4SZkTZxsiZZNMScICwUhZRty7fRGFkkCV+P5FzAxnMGrrE6wccPIO1r/7EaLZ
         L5zLaoizEZsbLELrDa5Mdr8gGOSbKW2Moj8bDwtM14tPxjt/4B8qkd3WGQ1Xk/EPOFJJ
         Q4u5WKUDAuBz8MLXRDgCq3dGfZiIVbm+46PM4NqgICtG1dBj/Oz69WXa4l4BbJx2Rw1x
         PlexkCJT5V4nxjL9Q1RnCkWws+Nz3853IE7GCVcSU4QXNhFkbPUo8t/niYEp6+a5eIFV
         LT8Gc+Zv0vI29bf/N8AEGo8LdxN779xwM73ZROauZIVqYNjYkOS0vcosELpKXY2C69Jw
         /vZA==
X-Forwarded-Encrypted: i=1; AHgh+RozJ2jwUIfaCAhnXvcd0ObPUBbFLitoPn2eINQBV0x7S9mkLQzKcFHMprDmnVAKlKBAu3yo/Z7A/Q==@kvack.org
X-Gm-Message-State: AFuF++nr3c6VF+SZUgnmHK+JdW5/kYcw8Et/L5b2eWaj8h7WR3oyYqSX
	xVe8b4sV8G0VbWmO4zkH8cjW3ELXS1KMFUT2437HVG4/W9b1TruOc9XashuIOGMkI0U=
X-Gm-Gg: AR+sD10jk6lsZFe2nme+HI+kjDiuErRqV2RmCnZfGxHM+s6H9nRpa6HSBVAvdkdH30O
	klU/zSnZWJy8U5qMTYSR6DYJz4X1EW9dv/nxkaeCCRi8JyVEDid3upeaxvmvGYQge39UjxHWFJK
	v93OTW26jVtvAQiSZ2xVbePaV8Y1qap24xxBkB6Xmdy4BXVahIHO9WvLSqocb20XRsSDg4vb61u
	CBeVLcBed7g+DwQ2MgoL7obq0YfL8Mehw1Df5VSPVP1nyJd5CzQMbk1Z/Fdf4yNnq+BMPKRL4Z2
	fc7ry9onDr5h/cZV4XW7pD5pZuoYtXSnDkKBxtmDgnI6p11LSbzBUvWPI99/cRrSeiuwi7ngkjo
	/myhVUX16hN+/uazFYtJ2sqVmPR7Krqzme4EjvUZxRHTWyt2D+m6A0/oLk6Jl8BUYUyrY7cTOpp
	wwyM7Z5//+3pUjSTKT2X1BJzbPFfwdXd4P1vxJ7opNIiKMn0u0WSMWCLf0Lc9R
X-Received: by 2002:a05:690c:4004:b0:85a:a905:ecf9 with SMTP id 00721157ae682-85d65ee883cmr4829107b3.2.1787851303687;
        Thu, 27 Aug 2026 10:21:43 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85b6143eee3sm13944617b3.31.2026.08.27.10.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 10:21:42 -0700 (PDT)
Date: Thu, 27 Aug 2026 13:21:41 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Yu Zhao <yuzhao@google.com>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
Message-ID: <20260827172141.GF3004@cmpxchg.org>
References: <20260826133054.88529-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826133054.88529-1-ridong.chen@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C893F20002
X-Stat-Signature: db639ytkkhsnmup7i6qg5rr9wnk5hbbu
X-Rspam-User: 
X-HE-Tag: 1787851304-255097
X-HE-Meta: U2FsdGVkX1+ZPUL+3/Avi8PdEeREvzrLCwZU10Cpy3xPcHG4v/lv5CPDbauhb1STvZmYWvmAqvHUtOxDUItk0lek8tGCr0+RQ//wt9E94QGUqlcQoLQyhzTIfEpfdrykSEV/C4KHVgcBVzWn+oFwUsQo7HZ0UVAl3Knqyxe4JmEew/rUcYR3ksVOV9mPiU8X5imq6UqdsDLy3n+FF2yLK4tmYJyi69PIxIpry2p0/XdrzN0+v2Ny/s0bTM8x228RcLHR1G8gE4J0Sb28A4jyIh45dXDy6YbxujDgqpjom7IYsYQbhBQFNCs27Cfss3HrzS/UJjLfkWASXzn2NcjqEQsrd4hT/w7GVJirKws7BwpKtgYkBR+7r0bvv6H4wgunuhHdDIWh9rMJfaJ6sUden9/dYwJYfA95hl8tdXqDAvfDsMFHducGs4PrbgGgvTNgnWcj2yHoUV7IHUam8qwUC66EMnW1YM9fXgvHB3lNnHDAkSGsa2ceA8Y3XBrKExOpW7/r59d+eFhB+VybFLmNKtDYQ3L0PUzEYKC33lYjhHdxPOPI+GfHAPKUz0x9yB6sZbzt1h3WvX/8h8ApcubnoqgMWSZAdhi8WrdGg9CuVTNFRruKn+DGRCRQiPhECvD8vP00QGcbRbZBbliksucUuTRikCnAgal+zEfL9/ApYCckjLlXRNZ1cLbMn0xpmW4JfHMmqDu3jBhpOZkLdfsDLUTuwcjmSD7v4Yo6My3waIDZTA9We/uoAIgr/+rv62Zpso3xdB6vHO/YpEPS6axmxIF9eujoT3btYATpb90pmHLyLpglPO+qTqdwkHYlCdZhx4jmE1yMMJl3RZb3TOA57FCrWawXOoux7N2nKqYkHCKYFywEoNnUCiIJeuHkhVLZuaqQYroNkwqH6irEJ+ZdnyqyqjGBP3xI6LmSMzpkfud7I9H5IWEX0onnBoH0XXPfYsL+jGQcuptDETJZLXD
 nchHt2Z8
 0dkULwz17jXdr4RalTyJEAYJPsw0pwjkVHMdOnhCy8OGngX6ZkGPCjRdH4KpNgHhIeE2h5rE2rPlte/1mOAVH0Gt+MBAHzQWso3+MdDYfkomgWnGilLszEYMu9Bo8VbS7yigg1lZ9HtdR7uyrHyrTjaaNsMcuJD0e506YG2bjyVX6ApiLK5OeerVEAiXDNrJdv6CVHfGok2P1qn3ICt0vgGs6LF2CDR54jx3zt5ADX++e+h8sQkB6SiS+uUGITOHQndYgkN8OP0SnC9Rb2gSkleadDpUDskSnp/Mjkw7eK0m1y4+iks8c6pDGyLPkralHicEOd5vf6rrOrRAViozCmI5vRzhVBYFlk5bVBS3q4tgBscQY3lz1TVkY5BJuJRoAvgvMfP+Nrm/4mFXu9PSlWB2fe6Bbt2Kdhwwb6sNOum1ZU6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 09:30:54PM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> memory.min/low is silently bypassed for MGLRU during global proactive
> reclaim (writing to the root memory.reclaim) and global direct reclaim.
> It can be reproduced as follows:
> 
>   # echo 7 > /sys/kernel/mm/lru_gen/enabled
>   # cd /sys/fs/cgroup
>   # mkdir -p a/b
>   # echo 100M > a/memory.min
>   # echo +memory > a/cgroup.subtree_control
>   # echo 100M > a/b/memory.min
>   # echo $$ > a/b/cgroup.procs
>   # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
>   # cat a/b/memory.current
>   222650368
>   # echo 500M > memory.reclaim
>   -bash: echo: write error: Resource temporarily unavailable
>   # cat a/b/memory.current
>   6070272
> 
> memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
> protection.  The traditional LRU path is not affected because
> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
> visits during a top-down tree walk.
> 
> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
> moved the protection computation into lru_gen_age_node(), which only
> runs for kswapd.  Non-kswapd global reclaim reaches shrink_one() through
> lru_gen_shrink_node() -> shrink_many() without any protection
> computation, so emin/elow remain stale or zero.
> 
> Introduce mem_cgroup_protection_path() which computes emin/elow along
> the root-to-target path only by iterating through the cgroup ancestors
> array top-down.  This avoids the full tree traversal that would be
> needed with mem_cgroup_calculate_protection(), limiting the cost to
> O(depth) per memcg - typically 3-5 levels.

Right, because of the memcg-lru...

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5198,6 +5198,48 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>  	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
>  }
>  
> +/**
> + * mem_cgroup_protection_path - compute protection along root->memcg path
> + * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
> + * @memcg: the target memory cgroup
> + *
> + * Walk the ancestor path from @root down to @memcg and compute the effective
> + * protection at each level.  This is safe for isolated queries because it
> + * ensures parents are computed before children.
> + */
> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> +				struct mem_cgroup *memcg)
> +{
> +	bool recursive_protection =
> +		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
> +	struct cgroup *cg;
> +	int root_level, i;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	if (!root)
> +		root = root_mem_cgroup;
> +
> +	if (memcg == root)
> +		return;
> +
> +	root_level = root->css.cgroup->level;
> +	cg = memcg->css.cgroup;
> +
> +	rcu_read_lock();
> +	for (i = root_level + 1; i <= cg->level; i++) {
> +		struct mem_cgroup *cur;
> +
> +		cur = mem_cgroup_from_css(cgroup_css(cg->ancestors[i],
> +						    &memory_cgrp_subsys));
> +		if (cur)
> +			page_counter_calculate_protection(&root->memory,
> +					&cur->memory, recursive_protection);
> +	}
> +	rcu_read_unlock();
> +}

Please wrap this in a #ifdef CONFIG_LRU_GEN block.


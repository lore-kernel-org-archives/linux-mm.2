Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD6CF531E9
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B181F6B0092; Wed, 15 Apr 2026 05:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF136B0093; Wed, 15 Apr 2026 05:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2C526B0095; Wed, 15 Apr 2026 05:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 921656B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:11:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 516E41B8198
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:11:18 +0000 (UTC)
X-FDA: 84660221436.04.739523F
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C94810000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:11:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=drMAOFhu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776244276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=niwzD+HTaVSeyOYRpZrIOJZYYAYWhLi1x8LzB4xVLGE=;
	b=rcpQZSwsnFjqhbcwdYDhLz+g+Weq9N8YieroyyYvygC1Kk+qLD9Qto7f3zJ/ejv1DPPKmW
	3+kiUrC9u83wSQoOkrTJevunA4RGCdz90DMpvSTlOZY93yuDdvIxqjo30TefP0WQJHnyAJ
	CvSta4K0pVYaBbbbDgTA1EkXGhlUnwg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=drMAOFhu;
	spf=none (imf14.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.53) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776244276; a=rsa-sha256;
	cv=none;
	b=kSHlqqoxzXEr5kKPP/iJOoGKcxNtcX61b8R4dTa1PrlV/xziWuVKzfgEl+FOjmZQDvWyTl
	B2xvCUaS0x4gMkotp3FjUdztBti60QNY32ohWIeZd5PkkodM1Vd5LWXdDathHaeFNWycqK
	MbFe0yLZQ4m27A2qzi5zbrPm6lbyNs0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4888375f735so64461105e9.3
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1776244275; x=1776849075; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=niwzD+HTaVSeyOYRpZrIOJZYYAYWhLi1x8LzB4xVLGE=;
        b=drMAOFhuGp+y5yra9rnkbMQfRG+SvOJf3Ew02utGrXa0NF7nrk+hPq97LQYKQJsShr
         ekifREo64uxDQYmWZhD57tf4vD16QXRTo1vw/blmtlSHt6oM5S0jhxbJG/HZrKQOmu1R
         L8ZMRJna/t6itebmNUgGRBtahZZoIsI6/iaaDJZtG4lxAIOeDkTmsdgSZkAaZwtzW13l
         UOY/+V+1MTMYgZzrfbn0Ju59bQvibe5iumuRz83SJ31Rw26DCm9ucQIpBKVudX4kEOXk
         dKRZYYEKlY2Q+XjV9vcmaNc3EgIndZuwTr+/s8ihlcwywt259TWsJ1QAe6x6w9bZwc5C
         eSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776244275; x=1776849075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=niwzD+HTaVSeyOYRpZrIOJZYYAYWhLi1x8LzB4xVLGE=;
        b=A+fj+muBzWUXh/MsRRHVQVGnJzhqovOa1fQFlhJu3N2k0YB0WkO+NXNFKxUsly0m+Q
         kk7x+jtAqIYAcqncyoRzzyYsVmmSt8/Z5oIPPLMTtY9Ty/QtHXrpx8vpEV/747HitDNY
         oLfvtsowlQbYyjiK94obR1R2X13MHX35o2o4w5gMRh8CE5j1eI3KkE5xZg/6FxV7Iy1B
         A8KUp0oCyk+HkF9z/KbamT2e5hlCqmmk7vewU5kYueObxEP2ogVK1zRMeYG8yDGzooBm
         1/7lhZWvyng2gV7/v4YKqS00u5ZPOU5HnFQx7NzLwAEks7jNsq8YprT40Pf/AsiGYaH1
         h+Vw==
X-Forwarded-Encrypted: i=1; AFNElJ/nLhNsIJq7nxU0ZaNnsPpttaAvjoN7zAe7L9c7sYKLetQKr09k8LSa8ENdxq6o8zX6WmJoaGcaBg==@kvack.org
X-Gm-Message-State: AOJu0Yx/dezoOBla0IJmteOcBhKf6cNbcgNQDefbNXSvbtjtXZa/F5eJ
	9YTEktTpWTijiFOEu9CpP0wic9YG125zn1SMGaTwyRjX58ypKYjXMZNhQdBRhlLWctY=
X-Gm-Gg: AeBDiev2Y5W9AAGru/bwVQpM7S0rZ4k79hH4HAP4qbMMI8WgS+AUOB4Hwufm0vG7BOl
	6gvXDnmakzTztDBHgQTLGsxDWgjtD8FoBgFC6vjr4G66U7eNnAjqezF7XvAIwXdR5ISUzJA7LFv
	4dG6NrxxO4qSw1K9It5LLIczP/x8IG8WXMED1NwKUhrvvX/XYj6/qGcRyy/75qlDEZgxZhJvaB5
	1coHbWpDGogrGo8N/wq7RE3RyK4Um9JrLIJFhWhUpMoj4kHcxA7jlzW2tS6tlz+IDbTesy/fa93
	9E6e49cBUrFgugSk8aRfYFivJyEPuaIPTT8bfDpt8RAUZplMOvV0E+USMCjfV0aKEE5UOiCuU7i
	NavkKOJjINpe1KMOBNpg4hBREVnzcCjrohPUyApTD0YX0iPtsycUvs9qClmKBZs+ylRQgvkmBXQ
	7YhQKjYKTXTiDea4X/xPkweAFtHXi1mgs=
X-Received: by 2002:a05:600c:8b6b:b0:488:be21:54b9 with SMTP id 5b1f17b1804b1-488d67ce792mr300007505e9.8.1776244274651;
        Wed, 15 Apr 2026 02:11:14 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:ec8::179:23a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f1d60ec2sm35799535e9.0.2026.04.15.02.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 02:11:13 -0700 (PDT)
Date: Wed, 15 Apr 2026 10:11:12 +0100
From: Matt Fleming <matt@readmodwrite.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <ad9SVxWIP4FN1c9D@matt-Precision-5490>
References: <20260410101550.2930139-1-matt@readmodwrite.com>
 <6ca33173-145b-43aa-8a8a-34985d375246@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ca33173-145b-43aa-8a8a-34985d375246@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C94810000A
X-Stat-Signature: d7qw175ifpxqbigdx4xjnj7x3q7349oi
X-HE-Tag: 1776244276-700843
X-HE-Meta: U2FsdGVkX1++dCtPnnj8LXgfZyU+e/5nc/WQjjcJU9qoZT/mtRpJfQjWQmobR4gmPQiE16mHxGyWAHFJdIHddoKFsJkbENsZZyfHR9mIZe+UzS6z/Rud/CVeuG6TVza7FwMvhVzYCb6NS9Db3meYIwMNrqCmHzpCd1ibfKQqqO1+nkkiI7kLKH5WRWqPFDaMEMV+cCJ5WomJud6FVsYU2n8hV8I5zjFtJWGnOAUHwrF7GjoUfwMPp5bxcBCWBeQf17v+wNsh4NcWZIm+EMFCD+zbQdR7rs3CleH6Ss4gsPhBMS+1cpm5pNxFZ/KAJe3isw9pt/Pn+H/zaYnj8t1GDbuqqpxz7D98Gr8Uv6O8i2YWbxE2RohQh9FCr1laDfufzC/VUgOFgOkCznJKFaBmGjOPoSEVt2Tuj0AYH4ZraXkt1TLubntIHrFfgG1UlmpuXd4/KZfzW1OWZLi+kHRNU3K1HumbipvMO1kGF/hbj6t5SQ/Xhbb9aCJhyNPqXpyFnrLo2fxaafCd5lTZrKVmK3ZxQfyKBA/NdlRicU0N8EG1tmzO4OVBrZBaJIAax9Ow0NUrwyOfxWQanFyqguSh+PwbTVOy21uvGUSMd4sx5oPszHF+pi4nPLi7k4eY5bgPqA7tm9ou9nZ0hOlzLBjoa21aQwroRo53sd6tv1V94PTiWJrw2XQrCd21hZIVaAjDa11GY6Ia4dmI5rDSAL+OnpleSacHHilSdKyZ4hK2V4ZICjnoxVQEX9IMz4EoqPqJp60HPYBvBtM3WauhQBgCCdlAHzaksFvRg48pE4kVrQEjZgozM1sHxqalYZSnKAg75DqNu2GrV5UnIr+xV2cfDUGeb+vgg/MknIavy1CS+fE3q5CH68XswYE1xZF4LhegPIoav5fquF7TkI6eKQ3hJQFm7LItEx1NJq5OEPGPdjPeQmprK/i/DHgDlfJLE4gP5RO2R7evVnkwNicMREt
 Qr6zgqPp
 yFKRONcHNMBoOgMHpybkc9V5p66fDa1JJmYTQE9yJWJw2YMBESXOu1I1auxNlo7fs1GEllbKiFlFF+43nmcjaC8L5/rUB+nmrdMwWSAd1EugmIItnfJBVOO/N70jF7pNrSE5dil1f5/uIFE5hwX9gAhF9gZ5yrfKyTaGpfC5gQ1zyi2pLMS0lN/79XJp2LO7BnJZuZBSRBzkpcsbLDN8oopdQhx26H2uFS0mx27QaF1akS9PokLBfXHu+peQvCqi7NjhaeB2c2OSje1Cm/urs54Vh8Fnia/MjA81Xok2XsQGWmHdM6fapTPTFKeIE0B2ZF43x9CjSEHEX2uCti3ukFg+lwz205niURw+jGINKas87vR0qLhXCh+aDL+p+xUkbwzLGfeHqnLZk9VLSkGZGkUl043V/2RsltAzEaGRb3sT5jngW9E7NsL5pt515v0SySLCdqvM2l6BAPcOvUDM1K9dyTK9aoYu5kkM6JBoR/SqdofiA0VR3r/tEgF9I68Pw4QrnLzUFPtrt6lQiPYMGC0TuQudp8yw157PbPpiiM/EjKrQEZDxQPAjleKYoTFqXkdAwi+i0K09nP9X1PWEr64YMvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 05:38:19PM +0200, Vlastimil Babka (SUSE) wrote:
> 
> Hi Matt,
> 
> so have you tested it for your usecase with zram and have any observations
> how it helped, what values did you set etc?

Hey Vlastimil,

Yeah I've tested this out. So far, results have been positive -- I see
system-wide OOM kills when memory is low and direct reclaim occurs, but
not so many OOM kills that the SRE folks have started screaming at me.

I've only run with the proposed 1% value so far. I also ran a bunch of
benchmarks alongside a memory hogging app that peridoically touches
anoymous memory.

Workload                     rpp=0              rpp=1               Notes
----------------------------------------------------------------------------------------------
Kernel compile + anon hog    Completed, no OOM  Completed,          Global OOM confirmed from
                                                Global OOM fired    __alloc_pages_slowpath

Memcached + anon hog         282k / 2.30M ops/s 562k / 3.53M ops/s  Global OOM killed hog,
                             No OOM             Global OOM fired    then benchmark ran faster

Pure fio (5 reruns each)     median 3710 MiB/s  median 3702 MiB/s   No reproducible regression
Mixed fio + anon hog         2747 MiB/s         2915 MiB/s          Global OOM killed
                                                                    unrelated services

reclaim_progress_pct=1 seems to help in these memory exhausted
situations, and doesn't appear to cause a regression for the pure file
workload case.

If you have any suggestions for other tests or benchmarks to run I'd be
happy to do that.

Thanks,
Matt


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C84C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB8CA6B009D; Fri, 21 Aug 2026 04:31:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90146B009F; Fri, 21 Aug 2026 04:31:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA62D6B00A0; Fri, 21 Aug 2026 04:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 956746B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:31:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A013DC036B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:31:12 +0000 (UTC)
X-FDA: 85124606784.10.AC3B078
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id A68B680002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:31:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Ii/RDnDv";
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787301070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VAHzhpOzsSEr244aJxDSo4vPO1nJblSYlEfL1siC080=;
	b=TYJX1mPX+A20fbkPQaTF3RGlu/VBCTkOLh3oB/dnae8SI5byXZ0WMExr0MPzUZw3E7b9vX
	1OgSe8SB04YKcS79BhwRjOdLuZeE5oLjvOhTnWaU1/c6Ia0iUAqRI/ndLVzIXP5+5a0r0G
	zboOrm2tpgqZnKv/rKt3Gox6wF3FEHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787301070;
	b=hG0Tx5veF7vI2K6GKI80ZSOJRTq6bprio8L5qFgp8fsETElBbT3O4LBsPkL1YeLVe1ewT2
	sLzCRNPIEAg/AbCvF190kU2MvQzELXe0DirihDeJpngfZckqo+1YGWCAv2J4MkF2Dm+ok8
	Mx34maocHKYIJZDVvZQJ6UJAqGcL1fI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Ii/RDnDv";
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c160420289bso111736466b.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787301069; x=1787905869; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VAHzhpOzsSEr244aJxDSo4vPO1nJblSYlEfL1siC080=;
        b=Ii/RDnDvtKrpYK4yFvGYqIgy1KE/Qj5d+nQc4OND8Old2Ugd0nLDZePMlcwaWkJGia
         yeO40yf9jmFLjIS050ENCtv73G0hIqKf2tNeGCoXoo4S2WPUpDpErV5UnEraXVglW3U/
         n5If868Az3Ffu9Oc0JREJLAJH/sLbhIY4F816+55BUv+uQwkqErzg38+7pc9In0iV4nZ
         uz+7V4AGXYPcPmILh6IYlnfxvxIQTxZVyXdKHkGMrCWMw4qtI6SFX217Z38BZWHwXWD9
         lAFhxlJx3gWXiB1FYjw00YnftmWxEaMR4O9IyaGcwkWXKulv0J9S1mnIgH4yT/BTwooA
         Jjug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787301069; x=1787905869;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VAHzhpOzsSEr244aJxDSo4vPO1nJblSYlEfL1siC080=;
        b=ZmH3IQb0IwkU2fv/aRVkHTQJh4q3fPcT/m4GffP3Xh6D4TNiwjF8opo9cuAC7LZtOP
         eNSmZk4jWhNZKFfnb4MxesBGXxMQcn+lA81mkUz0DYOBVQ5yoqSiJG/gyF5+dk5UUoGc
         Xa+mN2QVMm9VUuyoefYAU62ExjQPkmNruYTMeROfp5YQOCG8torwtEs3xKCYO4GJRwSs
         eq3jyGYiyqovP6/HFy435zYOqFenFmUzYJfMZK+RZSN6EqKK6S8c7pVv80upUjglDqNR
         2vwfPRcMV+98ryqO2mZGcwxNPeo56MxjO6TLG7uCM2knffHvc2FjboVnK/RC8pD0bT0Q
         kdCg==
X-Forwarded-Encrypted: i=1; AHgh+Roif6wy7sZh3/51Z0Myf1sGPcSkyCUpcMwROYhh33THWo5swJB5tjZkkhQO5j+tW7WfZCqBVJUYeQ==@kvack.org
X-Gm-Message-State: AFuF++mkJZeYA4jJIp/LVQHXC/A4gtqUQLJbxUG/00poCL6V3c0weC+F
	hOgD4CYWUs9Tp56x7fKbfOeciFS86F5FXWN7a5QpI+KEBqkL9A9U+o3pOA8kxJKpCwo=
X-Gm-Gg: AR+sD115G6OZwlHt8SkWLZT3DVm1FlnjqKPxmlBRtaHIpkHqZXBAMKhh+ja5kqNqSMp
	8wkdSHHq/n+nKWG4TZRU6Zf9lIi2KL0c1ugvxlQUxjEV/gKX6T9Y+STfMJuhobffsm2mSKHKE7/
	1xfQYDfyxwmCmlfV6CvvT+k07vrYjsmGEtlOPcH3OTbC5uQVNpY2mLnjavRFCCxW3QIacVHH+8R
	RVpemsg6+ATNFnotBHXGRlXNxajfBai6/2Zs00oOJXLVW/K4fo3PcEWv3/Ezlq/ppjo1S6QGsXB
	9kSbNT/nTaNJLUcU1zwrECToO3tDYk3LGxr+40GacdB4ycqd6tM72cIbOM4fS354Zwq7LzsG4Sv
	lUpBTzbsfucCP88TS+P7e+UAVV29u3mlACRhe3xt7XYNkdQHVfnEeoUHIU3yhUCuiT4J6LKuEqq
	qmi1xwrPsGM0pyhAGbGn82Tr30Fobe/IQIFtxmOYtsqA0W0pI5gibyatz4Y2tuNmnZsnPabF1WG
	g==
X-Received: by 2002:a17:907:e00c:20b0:c20:23f8:99a5 with SMTP id a640c23a62f3a-c246a6a402cmr349309766b.15.1787301069301;
        Fri, 21 Aug 2026 01:31:09 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24591979e6sm424948966b.33.2026.08.21.01.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 01:31:08 -0700 (PDT)
Date: Fri, 21 Aug 2026 10:31:06 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aogMyu5R_DZRqp2J@tiehlicka>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821081741.1340277-1-ridong.chen@linux.dev>
X-Rspam-User: 
X-Stat-Signature: knm7m8i75hroakubrgp7qz5sxnmm1jjq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A68B680002
X-HE-Tag: 1787301070-125819
X-HE-Meta: U2FsdGVkX19eNKTxvT1y/pfTSXOCLKGm9AJNSb0VXJy6lP+cLe2uvrXhCRAaoI31UPiL5QNt9QAUJNy1nApOn85l+LKwy1eX6OGGiTWVGz4QuP/QSJUKqm8ec240aCoVy+QI9utfu7qpOOYG7i35wopHpNrHh0lFEKAETC+8PYtLOO1qR6Olv6zajNR7G8uGjQMEbDI7dtuTbgOTzcwcXGhrrXsW2hqskKVYPuDEJJLp/Nu+THe02zewTAA6LVa8HuCxCw6bIY88SvK6hV9LgIqv7jwLWvGQ+ZZoAxScfRIdiQ0BtwZEd3O9u3b6CJl1+PbJU6zgljrnYjC8IlpYSXI5iWM6BXPp8jEtX2ZI2vnuiOmGJ6JX8atiGFIINNTWdytLq0/bkkQvSaKSrObiq1/8UUwZNcPJPwjeOipvzgjkYwgxCSqHUd3vYe/kBKP1hh8zAyCscpZUB3p2/NRM3bkgCDCvuhpiIPVAGi92AoVf8CsLqFePJb7rH2CGK6FAfMD+uzcnrsJhZcKqgadRxv4XyqpvrJQHGhmQCqitocbk6JY8qmj9c+W5vTBlX3D3TMRzipUHtBOg09K4O0ItJ3COIq1c3HAddYdSDpW9NHV9kWOMmD6m2B4N8lB0GwcZMSHsU3JqXsPTyLQ7U4li8tF+PDBMTV1yLbN4N6lA9FP3W+CnKk8d2e3rhSZCG7VRFa3DIxyNFQS0eqj4rvPsQT4/uiPF0SIVC8bGnD9X7SkN3JKjyt1bJu5ilzNt/x/L0iKghRkzFcV2yBNWIyO1iU9hpFDd8SJ3Ti7CIm5eEnV9YRYHo+q4JIsUcDZWBRpDN2okhU1QLSilvRqMhz1rDz+wrXTapALfYUgk3x4ryui2cOxv9orY/sAVZ4fP6d5KceICHe9uxEWFUKorZE4t8AmmvZPbXxaeSuK7PRS7jgOT9+brBI/sHuE+szvtCoGXAOwyW8wX1KVyRfKOhe4
 0t/EhjDI
 04ZuBlpjDf5NXQBpyW2nOMp3Tz+feXiNNeICf0mmFmHZj4DjDytk2VZraydRbYJE/b9VlS9iGwhAuhLGkSLKKuNdsxeGq5DLXHVcQTe/v+Hn8fLkfuFfXjzj+f37Vsfh5y9/YKgB4/Yw9juYkIyPFvjuM2+4iIeZ81dSyvWDPkwPdhiNFS4FK1O2TPmmmXDo95D5wVIAQsDjXKP1+deu6xpVeISxnzWuukRu4slgeMHv1mDfLdNmJlQnEWQWWuWFQ+zd/QE7Qdvyho75fTN2IE1wAbCIuPWWQe+heNPa88CuT+QeA3WJtzoUy9Zn7BdZcvbQ9cQ6RghuEl2jpGh7CPyqAnMrxTdnK6N3QedpdIByb9ZOHsBaOk0YZBfPlSiDlhLtj+NJSh3piChM6t4z5iI9EomA23EYTsNiyISyD8CZJEssKAbXqzMjemw80olhFt3a6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 21-08-26 16:17:37, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> min_unmapped_pages and min_slab_pages are documented as per-type limits,
> but node reclaim treats them as one combined gate: once either is
> exceeded, shrink_node() reclaims slab, file and anon together and pushes
> the other type below its limit. Per-node proactive reclaim reuses the
> same gate and fares worse -- with page cache and slab both under their
> limits it reclaims nothing and returns -EAGAIN on an anon-heavy node [1].
> 
> This series gates each type separately via two scan_control flags
> (skip_slab_reclaim, skip_file_reclaim) set only on the node reclaim path,
> drops the combined gate, and extends node_reclaim()'s early bail to check
> anon. The flags default to zero, so kswapd, direct, memcg and drop_caches
> are unaffected.

You are explaining what but missing the most important part _Why_ do we
need to have this addressed? Is this just addressing Sashiko review
refernced below? Is there any real usecase where the current behavior
matters?

> Tested on QEMU (x86_64, 2 NUMA nodes), A/B kernels differing only in this
> series.
> 
> Proactive reclaim (echo to node/reclaim) on an anon-heavy node, file and
> slab under their limits:
> 
>   metric              before   after
>   -----------------   ------   -----------
>   pages reclaimed     0 MiB    254 MiB anon
>   return value        -EAGAIN  0
> 
> Node reclaim (zone_reclaim_mode) with one type under its limit -- the type
> under its limit must be left alone:
> 
>   type under limit    before          after
>   -----------------   -------------   --------
>   slab                645 scans       0 scans
>   page cache          83 MiB scanned  0 MiB
> 
> [1] https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev
> 
> Ridong Chen (4):
>   mm/vmscan: only reclaim slab in node reclaim when over min_slab_pages
>   mm/vmscan: only reclaim file pages in node reclaim when over
>     min_unmapped_pages
>   mm/vmscan: drop the combined limit gate in __node_reclaim()
>   mm/vmscan: do not skip node reclaim when only anon is reclaimable
> 
>  mm/vmscan.c | 89 ++++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 67 insertions(+), 22 deletions(-)
> 
> -- 
> 2.34.1

-- 
Michal Hocko
SUSE Labs


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5884C4453D
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 03:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA546B008A; Thu, 23 Jul 2026 23:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AF06B008C; Thu, 23 Jul 2026 23:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5799A6B0095; Thu, 23 Jul 2026 23:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C11D6B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:47:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 937C6120267
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:47:27 +0000 (UTC)
X-FDA: 85022285334.12.21325E8
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 83A37140003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:47:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UsWH2ZJp;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784864845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnO8IVbS/xiFlAYBjblWiXkuYuos7gLxr/7vW4NvRfU=;
	b=wVc4/yRHMTtQE6d9Y1BWGC6Rz6lU0cqLc+/vHImOiypWDxZzfiUC4Ho5EgYgC9jl5MCEfl
	yVzCjatkXOKjz6r14GPBesl66PJsxPXBITxISTylTYdRtngHCyP7xjhwSyT/s94gHd5bCa
	cZ+oQpblImAsJdf2bqgFVAVmS1A5KIs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784864845;
	b=vNrHTD+xF/hWubkkSNJ88zBrE5NYAAdl0sDF0u6GcKULNiVdXr/5y2i7JHNMM2WaPwiV9h
	kh0bI2RSjNX2ctPIDe3meaY4b2JhQ8ZxBm8+WDi8RNAVKZO4RBf3cU5lOQSJqcdFxv0xIn
	/w2HIZ9SwsOJJo4ff8DOO0NAs6Et23k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UsWH2ZJp;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <02c1c551-0a0a-4cc2-96c3-5ec0d9f71086@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784864843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OnO8IVbS/xiFlAYBjblWiXkuYuos7gLxr/7vW4NvRfU=;
	b=UsWH2ZJplnwBFimh4I2eVGiyoLQlRQ/XzolSlIZ87NzTJ8R/t77YBmFitCXzb+KsebRRZP
	UWCUSN5vbPS5AQhAmw9SLkjYSWpF9C3SkNjMzRKvi/D1M0dpAwBeucz5v/od/IUZPJniza
	Xx0s9z6pyoR9eaYxg0NlDdRQxvZqUdI=
Date: Fri, 24 Jul 2026 11:47:15 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mglru: fix memcg protection for global proactive
 reclaim
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260723130559.2343690-1-ridong.chen@linux.dev>
 <20260723165804.f4899595c0523bb16af292fd@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260723165804.f4899595c0523bb16af292fd@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 83A37140003
X-Stat-Signature: kh6jxd3zzcwgkkg74fxw1ru1gnieqs9g
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784864845-478801
X-HE-Meta: U2FsdGVkX19Zy7MVjfFdcpiMzf9KYiy9Q+8gLHfb81S70mRNCQ9QaAymx3bjtmquGAE51pjN2rzAdeRGhyy8A1GtkoSitw7zc/H7O/QkvrUCLCy+kvNm6skhx+mRiVuTL/RNyLu06RII4wzBk83MFxtoWhGb43CaGa45gOrN9L9qJ6EhSyPWd9xT/JzxFNKT8DE6v/ADSivg2iql+6+OSASQBldeaoLJmcCOFWeNM+QUVGvqjk9XHGd7RVz0WJQiXBLcRn78UVIJTW0EHLsYdvJuclm0D14uwrGSY+A4RIRJU0F7R3PSVQDJQ8o2ZHk4QO223YJyp/mASSfBkSeCi/MeM7hkMfDbJz69OL6CtBljZ0+ucUACv1RuSpEzLu2wUtdf5geAesP61TINxuDXpJy5FfsqoaYwZ+HzHUGoK4c4bnOuZHQCpxq/F2CeW1QG9RcVWAkw69DEXTSMnD1NbBO5+k2FEGuD4/4eALW6Odd9s7zckU4SDJ3Bi6CLuFJ2y0POZuvAooDTHB7v6Zf3DAYKpFjERGJ9M94uXapIKBtYBtb910Ecw8IZRPhN3EoJEzCyf7aYRYs0MQ1bdDm+j80J/qtJ5ZHQhgd9u3PyK15PpwfbLIazZQ4fag5Xps2ytIOKRlBvf+GqWJCvMYEY6H3qEJz9W+ZYs384wYtvKVq0Sez/mlg/bYDQZaIVQw+rV7ZJlWNq603dIbDjpTzC+mESRf3JrbvD9eEjJxKzGFqtZP5HOA6pJNcoYPSPO5PuXHJBzjHkrQoQ7KpLtWoD+wwegXyNCRxS4+YE/WsSPM8Gtrwv4xw9SWeS0XM8qYlicf908Qfe91d6tLeX9Vflg5C7uU7Kqji3iHV5i+29J1kkV/yu5Pr/BEzqJtDQ3b8N5ca8idKg+JTYQF2Vmhrm0sCG15iYhRfKFR77LJIvNUNCVwHPKV9vbWLd446Nj9Db2mdPKrAXr0eF8t3ugmd
 3VEg9yUr
 pPodO2yqf2Nk5gNGukDJrBu5RZuMkQnVsVld09bWSeM+PaBhb00gv3SdsYYF6UrsjLNiUPsH0cAmuxB4YxCGrWDND3EomCpenz+cRSH8g+gFK4/O+ygHl7da9oxKl3iLOnsrYhJ6ImnP3jbccVPn6jm9LJu9tYLCZeN1zd4MvC9dRRnmrEwqDBzWtI+DKyIAlhTc6UjIZvR+gRuwX8FA1lfcEuJFHpkHljOf7I2bdJkVIo4KqIOATpykDi+p2IXeTNx6LJO+b6HuuF2UB35npbNcThQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/24/2026 7:58 AM, Andrew Morton wrote:
> On Thu, 23 Jul 2026 21:05:59 +0800 Ridong <ridong.chen@linux.dev> wrote:
> 
>> memory.min/low is silently bypassed for MGLRU during global proactive
>> reclaim (writing to the root memory.reclaim). It can be reproduced as
>> follows:
>>
>> ...
>>
>> Factor the tree traversal out into update_memcg_protection() and call
>> it from lru_gen_shrink_node() for the non-kswapd path, so the protection
>> is computed before shrinking. kswapd keeps computing it in
>> lru_gen_age_node(), which also needs it for the min_ttl OOM check.
>>
>> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> 
> Do we want cc:stable on this fix?
> 
> Sashiko said a couple of things - the memcg ref leak looks real:
> 	https://sashiko.dev/#/patchset/20260723130559.2343690-1-ridong.chen@linux.dev
> 

Sashiko said:

   When breaking out of the loop early here, do we need to call
   mem_cgroup_iter_break(NULL, memcg) to release the reference?
   Since mem_cgroup_iter() holds a reference to the active cgroup css, exiting
   without dropping it could cause memory cgroups to leak and accumulate over
   time, eventually leading to kernel memory exhaustion.
   [ ... ]

This is a bug introduced by this patch, and we will fix it.

Regarding the performance regression:

   Placing update_memcg_protection() inside the lru_gen_shrink_node()
   non-kswapd path forces every direct reclaimer into an unbounded full
   cgroup tree walk.
   Will this cause severe performance regressions during global memory pressure?
   All allocating tasks entering global direct reclaim would concurrently
   traverse the entire memcg tree. This could lead to massive css->refcnt
   cacheline bouncing and system latency spikes, scaling negatively with
   the number of memory cgroups.
   Could this full tree walk be optimized or deferred so direct reclaimers avoid
   iterating every single cgroup?

Since MGLRU global reclaim does not iterate over memcgs in the same way 
traditional LRU does (which traverses the hierarchy from top to bottom), it 
appears we are currently required to walk the full tree, similar to what kswapd 
reclaim does.

Does anyone have a better approach in mind?

-- 
Best regards
Ridong



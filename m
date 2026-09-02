Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA94C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6196B00D5; Wed,  2 Sep 2026 15:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7E76B00D7; Wed,  2 Sep 2026 15:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99786B00D8; Wed,  2 Sep 2026 15:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F06F6B00D5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:40:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1556C40368
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:40:19 +0000 (UTC)
X-FDA: 85169838558.09.B972D02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 57C2C1C0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:40:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2hmEHzbA;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788378017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LgInFhPoAEPM/8+81aICGdqQBdcuVnYwUlt3bosDlig=;
	b=y54Xvf++l5asMr1zZoJ/v1KjbpkGzssHtSKuWReg5qRSASTtQz29Opsd7g42foLSzAXg7+
	/2T4pnvUkpfM65RLTaCDR2yrVQr168v6amWMS6U6OxhTansXqj1DheoQb3S6ZvI6nf5+dv
	vc3A6b37OgDy+amjUjpmrQk94ovq/d8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2hmEHzbA;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788378017;
	b=KlffARFWkXALFrzFOVmsB1qDabR5KSxUwXnNj3hqXqyNCPqHMrPHXOKDr2lkv0NS/F+wu7
	9D774HgObYlcUyiVjfqaSkCAwX9KGAxdE9Y8n6VbBYgkfV5u1LCYm+cfrThBDOkwGUhn5J
	sLhYETNKJNT8C9Pj4K2KBV0qG0K/yGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D36D26022E;
	Wed,  2 Sep 2026 19:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E9A1F00A3E;
	Wed,  2 Sep 2026 19:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788378016;
	bh=LgInFhPoAEPM/8+81aICGdqQBdcuVnYwUlt3bosDlig=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2hmEHzbAOvrPbWny4gsMa4pFCXw2fu7NnwHYKSeo8vYE1AmVgwZcRVEUdhbnP5woy
	 V851HqJHR1v6PxgVUXWG2gV44zFL/XJ+yDG2CXOFYsTpvaLemczlnxDYMoMB6ofE5Y
	 BG89Zuk5GkudzQCP/LHSB/o+qw3tH3IATSXj9knc=
Date: Wed, 2 Sep 2026 12:40:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, tjmercier@google.com, Meta kernel team
 <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/8] memcg: remove the v1 soft limit
Message-Id: <20260902124015.ec0e73154b93b69b62873e26@linux-foundation.org>
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w9jwbktd4g31cxpmw9erbq58qj6on8gk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 57C2C1C0002
X-Rspam-User: 
X-HE-Tag: 1788378017-397210
X-HE-Meta: U2FsdGVkX1/G/Apv07weS5tjQFa17dlJvKnbRS2m1jWBVwF1LBgZY/M02yiWRDVqwyNn3e9ud/BeTpLK+UCzIiXjwMsXiypAv7cBA/kpH3GMbJqdaFZeUOuz4jlJIM7mJV03xlrCPF/6vz7HxaKDxa2LKHVtmIvkeW7nIQtk26ii3gjIIJrzbaxnNWMaVyRgKUzkpi4zNJitR5qqTVGDZrbhDsGHF4CqQPQqOsQeIJLH+Q7egQZEQNJbz4FXKciINGca1gZDTEgv2FIYXePGwsNu3kS3TNPUNYYrxEYiRRfqjIXS30LxqPaFJOaxh+HbVdWzkuCg7sqSZUeW4+AtGioB53PRoa4G46v0ten36O8Hk+lndVO6GBm+fpMYzwRLvmA467tAGKR8DyyBkiLU0+qWet9BpdKdmTqnWWcOdnxEX6dg6cTDknhjjiIQxcuMfbVXwOoM6jSK30+WxsJ+xBLG4gm6k6fMZLErAARkvDRDtVUBA9d+aPQ4/mCtXm4vfFFBL3bvDJFFsWyhDTaDbnB7Qw0eW2gC6NlX7/612LLX8WmX6pRsyC2cOQmRYoQsUbAiv1v1u2tgYT9YLlADTfR+4e2ZI2q1ClOAtDxS2LOhJpZIc6zx61zSr9Mg78wfbfGQ7husGTbgtJJH15QRpSExONnlhHM6jSK5qrtCs9/SZ8O5rjrgF6uY8ILtdO8H3Iuk+wd4t3l8rgpYfoReMe9k1pQ9BHjYTJ3aeCOZtHdMSnhA361hrIxcP5QabHUyqbk6HT1vLZOkb66XmPvWA6d11f70VVaakFinlYTPjiVSg/owVL6865qmfIbq3Gghvc7k/lX0ZmeGtBGt0sW5zbfhU3FOrl2L7a36Vvswu0RDn+Qy61aCesb3F5j8hXNuJQzbNn/EViGgNKy+DdNSsBW6oJn3bfQ8L7FVsWUNKadzjfSFIP0sJbNm72nazWu5hrdjOTwZZLcsCslmqU4
 KOTMU+0k
 Kt5nL8PRPAhxmuBz0HXM6YFDmTI5FpsEIfUPafRLu8Wt1rpgrS6C0UAAP4sC6VEt8GV3R8vQg03GDdVfJ4mfun+h/NqcmRxUPJ02q5LlYQxJB2UinR5WR+QaNusXtd6bYwZld8jlKV0PL2J3x9AQ2MR8AXyW3QJB5tR4MuFrNXrK1un7IL5xK3wAfw8MGh6eLlJNbnc5g4uldTiqhNMtWl/nrKwdhoAEewX0Xx88btKyLzfh23jKM7THIE8VeTMZmwdWM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 10:43:03 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> The v1 soft limit was deprecated in v6.12 by commit 569c4f62d84a ("memcg:
> initiate deprecation of v1 soft limit") and nobody has reported depending
> on it in the ~21 months since. memory.low and memory.min in v2 have
> covered the same ground for far longer.
> 
> The knob has since been made inert by "memcg: make the v1 soft limit knob
> inert", already queued in mm-hotfixes as a backportable fix for a syzbot
> report [1]. Nothing can enter the soft limit rbtree anymore, so this
> series just deletes the machinery that is now dead: the reclaim pass in
> kswapd and direct reclaim, mem_cgroup_shrink_node() and its tracepoints,
> the per-node rbtree, lru_gen_soft_reclaim() and the MEMCG_LRU_HEAD op, the
> per-node tree fields, mem_cgroup->soft_limit, and finally the v1 event
> ratelimiting which is now down to a single target.
> 
> memory.soft_limit_in_bytes itself is untouched: writes stay ignored and
> reads keep returning the maximum value.

Thanks, I updated mm-unstable.

> Changes since v1 [2]:
> - Dropped "memcg: make the v1 soft limit knob inert" (1/9 in v1), which is
>   already queued in mm-hotfixes, making this an 8-patch series.
> - Collected the acks and review tags. No code changes.

I've confirmed that v2 made no alterations to mm.git.


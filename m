Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B9ECD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B9E6B0093; Fri, 22 May 2026 18:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3BEB6B0095; Fri, 22 May 2026 18:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79036B0096; Fri, 22 May 2026 18:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A71B06B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:06:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4C7D792D1D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:32 +0000 (UTC)
X-FDA: 84796440624.23.3BF4652
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7EC2840003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LTT0rWI3;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aitoRh8af8hU9OmkzJFXm6Hu0+SgnlMA/xdSbDz8UH4=;
	b=AfQBHvmmFwrcupDTZpTVEA5uw37kh1zUgWiG83Fg6O9IgyjxjpzTkkjwj0+XDlgxrSku/1
	p87AHg4VzqwfbI+4VZLWIigh3IlfzK7VrAnZX75XfIctAE6UIbyN/cV5cLaBZTTIWZG+gT
	CfSXVok36tz/NznU4zpSqoliQmNPP4E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LTT0rWI3;
	spf=pass (imf01.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487590; a=rsa-sha256;
	cv=none;
	b=oVPCASZgz0WP/Viptdv6H8nbt6+P7oIMBriNX0bZMqvRazHolsBsO8Vib9FNzaKESyD0NL
	9oFIz9w0iURFwFPglX1WgofDh8p4SELLhj6PIl4LyZ1RJ+RBwkjPvkmmE/QOknlmiLypZh
	LscgC7O+iyfXSqcoo5jVRp6wRGcLSSw=
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-69d79fc48d2so1357334eaf.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779487589; x=1780092389; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aitoRh8af8hU9OmkzJFXm6Hu0+SgnlMA/xdSbDz8UH4=;
        b=LTT0rWI3KpncZ+sPKOOHQ5fDF/Ja5K6jqxOX7smM5wALAxNFcYtWLJY0fa9NQ+20m3
         KDsGqcJwNEyQ3CyZRISYItXtKvbfzI/nyYk4JkwyCRynisAGWdnaBWxCGcYkM5CCsqjw
         sswcTwy1t/RCGBw4UNcAAPpmQ/IMo43iDGbSd5unhxeV4Gdq/3vTnncOJaH8si3Rrg8W
         44wufas2esl9McSdxX19bR3jRWYlLxcN4atvngmyW9yAhlpYWZjsBkiZeXBc9I20FDkM
         HOtrUQ85Mt+a9HKSkjssoRAN60O6zl6p2UGSZ76EqhmlJhoFOa48VJSzXmbkaYIV0t74
         exqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779487589; x=1780092389;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aitoRh8af8hU9OmkzJFXm6Hu0+SgnlMA/xdSbDz8UH4=;
        b=IwSZX5H4OXb26wiktJLcxayqtJHbSMIZRav0vedzFc/jSfY3ubBac+y1WyY+NYUXW0
         U9j0S1BJ3khDR796gjk6iuVlb84fPf6a1LpryUd14f0shiHQVvb7PyrHx85qwc+7MXco
         jyQVee5/BC257UwZ51dF4U1czv8RpA1G8usvrDyzb5YlqbzYlRmiPXqnbjMdi/NN1hjM
         VE9x5MheZwX8DvZAb3AALIdPxlfSizLEVTN3AXEHQ3N8yY5q3SizeFgXSD551fzj3zjm
         X7+SXUjcTk1E2tpIuUPoSWXEN1bwEa4WabkjFV9XFq04E91evmAGuOqJOUrt/owz3uA0
         L6Cw==
X-Forwarded-Encrypted: i=1; AFNElJ/YkzdHoNfMbHRFlv6qJaNweF249/h5wn0j9NT95sjpBJ/XmbYv7YZTEhISTupB1Gvn5WDYdtuBXw==@kvack.org
X-Gm-Message-State: AOJu0Yz/Col7l9Mxqi6ijHNRmRd9xWKVtxsjdvwuHuwhC0pr2WU5QIf5
	Szr5nbjGoEhHcSiVfwerO2EH2nh7yywoBKv2jcMpxhaxeby8dCmt0LdI
X-Gm-Gg: Acq92OFo+Pu5POGCnUJvXdse5Md2w3+QYuXcGp2lV7tzRCH9xQG57UEgv7i+TW2bkwZ
	s5+VZ66nVKrfZPoFQvOdQB+Dpv+Ub5drQYMifOu11j9QsyvxNpY2yoHextjkfVv0ntCos/LjorF
	1Bmh0x1KWqETdev9/Bdzq4ae8Np+e8svvAg8UGFQ9DQyjIlTDuzVSfaE4ZY29BcIQ5ol5bUkLGP
	kkvlL6EwICxIrwEL88RNJJBq1tJEoHBIvXSfppMeMEGd8X+9e5tbgR+QgU5fWXUYMv23vxzpImi
	mOwgXKzgBlVwm0bto1OtrSD5i/qV9TKM6GwBemUB/QSEY93PT6KgXnLeXbJwwRjI8r4rjnjChsQ
	U/PF8nNrEsNGqtJKBmgUvT+8QUSEKqO8h+fwy4oWSxPZ3MVTJtq6g3LvkPe+dZ/FWTXMWSBfFrl
	sGtD6X5Mvf6HvarhZBX3V+ak4wPhooD3MFMLOA56+GgHHPmiLNqoeBTw==
X-Received: by 2002:a4a:d813:0:b0:69d:7bdb:ade2 with SMTP id 006d021491bc7-69d7ec28651mr2091887eaf.32.1779487589309;
        Fri, 22 May 2026 15:06:29 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b635e373fsm2879308fac.8.2026.05.22.15.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 15:06:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/7 v2] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Fri, 22 May 2026 15:06:18 -0700
Message-ID: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7EC2840003
X-Stat-Signature: ib8pgwi1s5gyo7y7wq8ip96awxkd7ebg
X-HE-Tag: 1779487590-924028
X-HE-Meta: U2FsdGVkX19j4GqhV5juGmT09MptZ1FKXuS02Z2zft/OlMiXiY4r/F5WgTzOgM6+SX2Y7R1mkM6w1hxc0Y3Fms3iVaPPq2TaPCjnHZ8e9PVLEfNfQJhecdOlLHfzzwIX+M/n5oUE9Oz8zlYcaF8R//TR5qa1zep4GpKSIXQPNwWgNfEuQ2NuoTWmgPnIlokIuDhlRkO4oFT6SO3xdIb90A5R4ZxevAsiEV2hDC0vj6OKVent0hnGR8Zc/i0P/td8DNEeKKsfZQ5I1D5aZ6V9AIsp2GX9PgCRHYAYwxmiM0Kjv+PmuG2vlv540n4EXzkwYnuII6ySkwCyNmkCvUmnQJKlzPdjoOvguxbRqI7cT3XIQ+8t1P2gE4/cQMAaTmQGw25Wi6XU66vAwKmbdBZzEuD6HRJ80sCAHmLO+6WjHk7TtEdQdK9nx3j0CKOkC66RqnaBOGLbXbnW9k+qOyQuWljNf3TZ1MXWdIr3AqwAnVWwueLSd9DlVYyQtmqrHKZ+cwgvZl5QF6fqvKIWyPJSG55q3hDfDNHbOMzBG0GSum7Z43sj0sJFc/askkDf1Of/3n5DTecfY95Rxs0kDE6OWgcRX1BWsh53QbGJgSUZDnBRjTAikQZZmpH80v75WYfuDEZ1Qy/GmTZy16zw4LcWZ2gp6US9DgFuWU6CHJz2rQCy3XhWYZkqqFFYgFchhQZpRr94cHJbq4J9m6FWfGtbVVyue1jDLoUAw9svvvsaTj1sX9VG2Egxl/M5niL4+bsHOSAnltcaQLmhReFo+Pj83JBEF/cZ37sWT7k14XVW7aSJ53mrGsz2t7gSVQpoeV21WhFnN3AlGCkc6z2a5sZbijYD8fjd3Vjm1n9KpgUA+ieAoVugY4yZD3SZGG5KkvkXAHMidsGMVNDJfvUaS2S92xUEhIiXcd/QuN6YYIVrosqJ3wFYi/F6Z2zZQxuf8yvON4PhSPu24kyW4VuqpNx
 ytrNWZWX
 clWDLOv9veWMxKznNewt/5e9zE+qVqpjteUhsGao9/n39YOGjYbC1e9zvbbgaaxc648x/rC8vrA1JdvIAxd0b9s1ntXF1GiCX0zS/YdJDH32jI5pMwq1jzN+ikWF6Nk7bth8aV+6JKEBxp7uWqwQNmGOLU/hG+SSLNGIfzXSzrNDoCPgRLBJZzOBbR91QEgK/eN+WTMZBBJmbIN6PeM089WnUgAlqCGAZ0OzHVk/h2IsJL0P8dvxqC/GyBKBZSRBfs2ibjAnJQFVDEd8L+Nstxh9x71rSG2OGXhyNhi7aFXpMiRXvGq0Kl2GM3OKpPBmGnSrkTeEqtEm+STbHZFktdh1KGb9Pwn/zo5QAQmf6cI28PhqhMvEAlmT+yOPEdfNmCBjVoVNL6TSw8FLSFE8TC0JjBksS9HPLmtCUQN4xr/Cf0BwmLb8zvMj32gOE119YZJQfP/Fkn/Kdb8Ug4DVcYUZTJdqOY5jOnR2HhhtZ4WfZAK+Dj7Z8Q7dnXzmxJFlJ3jROE/+w+En9EEHbDZ5b5rxpDpX4yzes6MvIiLFoJC4ul1h3942hy8TE5kVgRUAY4wGY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
allocations, allowing small allocations to avoid walking the expensive
mem_cgroup hierarchy traversal and atomic operations on each charge.
This design introduces a fastpath, but there is room for improvement:

1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
   more than 7 mem_cgroups are actively charging on a single CPU, a
   random victim is evicted and its associated stock is drained.

2. Stock management is tightly coupled to struct mem_cgroup, which makes
   it difficult to add a new page_counter to mem_cgroup and have
   multiple sources of stock management, which is required when trying
   to introduce fastpaths to multiple hard limit checks.

This series moves the per-cpu stock down into the page_counter which
consolidates stock limit checking and page_counter limit checking into
page_counter_try_charge. This eliminates the 7-memcg-per-cpu slot limit,
the random evictions (drain & refill), and slot traversal.

In turn, we can add independent stock management for additional
page_counters in each memcg, which is used in my tiered memory limits
series to add a new page_counter to track toptier usage [1].

The resulting code in memcg is also easier to follow, as the caching
becomes transparent from memcg's perspective and managed entirely within
page_counter.

There are, however, a few tradeoffs.

First, the bound on how much memory can be overcharged (and remain stale
as stock) is raised. Previously, it was fixed to nr_cpus x 7 x 64 pages.
Now, it becomes nr_leaf_cgroups x nr_cpus x 64 pages. On large machines
with many cgroups, this could be significant. There are three qualifying
points: (1) larger machines should be able to tolerate the additional
overhead, (2) the stock should not remain stale as long as the
cgroups are actively charging memory, and (3) a process would have to
migrate across all CPUs to incur this upper bound on overhead.

Secondly, we introduce some additional memory footprint. The new struct
page_counter_stock adds 2 words of extra overhead per-(cpu x memcg).

A small change is that for cgroupv1, reported memsw usage can be lower
than reported memory usage, if the memsw page_counter overcharges to its
stock whereas the memory page_counter does not.

Finally, to keep the above memory footprint limited, I opted to not
embed a work_struct into page_counter_stock, but rather decided to
trigger synchronous stock draining, since the drain operation is rarer
now, and only happens under memory pressure and on cgroup death.

Performance testing across single-cgroup, as well as 4-cgroup (under the
7 memcg limit) and 32-cgroup scenarios on a 40CPU, 50G memory system
shows negligible performance differences. In the tests, I repeatedly
fault and release anonymous pages using madvise(MADV_DONTNEED) to
stress the charge/uncharge path, across 30 trials of 50 iterations.
Metric here is time it took across each iteration (ms).

+----------+--------+-------+-----------+
| #cgroups | before | after | delta (%) |
+----------+--------+-------+-----------+
|        1 |    352 |   353 |    +0.283 |
|        4 |   1198 |  1217 |    +1.585 |
|       32 |   8980 |  9027 |    +0.526 |
+----------+--------+-------+-----------+

Further testing on other stress-ng microbenchmarks also agreed with
these results.

v1 --> v2:
- Dropped stock returning on uncharge to preserve same behavior as memcg
  stock. This resolves some race conditions present in v1.
- Fixed many race conditions between disabling page_counter_stock and
  in-flight charges
- Restructured drain_all_stock to iterate over all CPUs first before
  memcgs, to reduce the number of synchronous CPU work scheduling
- Optimized cgroup v2 further to drain only on the first child and skip
  the root mem_cgroup
- Dropped RFC
- Wordsmithing cover letter

[1] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/

Joshua Hahn (7):
  mm/page_counter: introduce per-page_counter stock
  mm/page_counter: use page_counter_stock in page_counter_try_charge
  mm/page_counter: introduce stock drain APIs
  mm/memcontrol: convert memcg to use page_counter_stock
  mm/memcontrol: optimize memsw stock for cgroup v1
  mm/memcontrol: optimize stock usage for cgroup v2
  mm/memcontrol: remove unused memcg_stock code

 include/linux/page_counter.h |  16 ++
 mm/memcontrol.c              | 286 ++++++++---------------------------
 mm/page_counter.c            | 140 ++++++++++++++++-
 3 files changed, 212 insertions(+), 230 deletions(-)

-- 
2.53.0-Meta



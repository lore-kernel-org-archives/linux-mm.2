Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB78DC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66716B0093; Tue, 11 Aug 2026 16:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16B56B0095; Tue, 11 Aug 2026 16:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2CEE6B0096; Tue, 11 Aug 2026 16:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E0806B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:32:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01F2E4024B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:13 +0000 (UTC)
X-FDA: 85090135788.10.BD6A59F
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 399758000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hJdyV2V/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FWnFGqElf/csDRiK6I4mDw+7j8seyhKcgH4/RRRu6wE=;
	b=d41b+2M/I6eQ3c97ryKjCqyodMcGg78eKgzu8wPn9hFzKnxVp6PtT2HE9hPqBkCNAneZPk
	LPpM2vnEAJeDZhk89Q41CDJsDIKGpxlwl+4qEDT3ZvGslA8qs/ksorFgWwmlAc0C6tfxgo
	ZX3CJetoxsw4r8fCBsPjJQDZ8f3yjys=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="hJdyV2V/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480332;
	b=Rl5W5xNcb5t9fkMqMdusgul2/VwAwMrpIZajPPkiDg7T0eWg2bUUP/gSHxVr5ZiCILSI6S
	P+lClW1fy5r13GT/Z4tsC+v3Q32/FVcEm21Vb31ChbO8e9QA03qhLKAMvNnrJKYyZyIB6W
	jyYKhCRuPGu6KlMUfibP1k3IkQBOVVM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FWnFGqElf/csDRiK6I4mDw+7j8seyhKcgH4/RRRu6wE=;
	b=hJdyV2V/fCVmAUZkkxcgdZ1M6VBcojoHPorKmJhnTGyg572foFi7egfRFEgklvDIFq/r5k
	HX0CSnj+WRNAdrxajrE5wArWkQZQxJA0rof40HMXtJjju9POr9BYE9Afk2W2TXqz8PdwV/
	C4ZXoEzUeHvjZg/XRvK2HN5LqhvNaLE=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH for-7.4 0/9] memcg: remove the v1 soft limit
Date: Tue, 11 Aug 2026 13:31:54 -0700
Message-ID: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 399758000C
X-Stat-Signature: t6119wszuy3w4fguqzchzg3esc31xsh6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786480332-133991
X-HE-Meta: U2FsdGVkX1/6KCyBnIkErVgS9sbUsURGq95RGxIjty5LM4mbnMmBaK87kPM8RhB7RmAwPuA6WNlXvOO7FYyp0uwn4gsOjocPBlRl6Fi5xptjErYHNLIOVlabkE6m7Hh2U1XGD/VKvuUR/KdQpWWDuElQe7dAjOovbtnTpr5TKwZnKsUA0AuV4YdRuw0r2QeTzpWHOEOtjQSqT7ORyKzOCtI+7khQduCOqiOzLDAaX2DNDsSJWNG5B/b1H0KAC4tuoecqY3flTH3hMurMdtyXEjYIxT4EyGrl5wX/gY1VTfVEgE0eHFrJYBeRPDcRJnSvA6lR28H4uO6lL4ED6VNq0HAa7BsSXgQezRNpb6N9n3zQkowX91tfoiFg3DYU3H1m9GNepOWjI6uxgB/C8EdyU8ofdw22hPVe5Bs1SRsSSVDiLN1I5zw0OWvKGTckdTXYrv+dumNbooaQNV38PN+sKGX0ssyh6bFh+mFM6D81iOmUqydahIu6mqktfIoDZQms9y93L7vPKV7hEPYRFnCGVqXa1CCdoZzWUD8kCaHVxE6WVdT1K5HHo600leVlTnvnvEVnTPhln0M/7zCUPHoc3/+b+TUyGoZ628vcpI0jfLCHBlpww2eMYBno11LgyD/gPxMGKszKuCR8MTcMG+OZnOpJXX7jij8a0JFj+aVdnxdZxqAYAKxnG7BN7telCW2GIukMdp+7yni8f+tllVkqwLLauHqQ+DDNLwjBQt8os4KWKoUjBECStD25g1quj9GhnhYlSCwpZHlKWnxEvWqZ4kC9bpnNy1k533HikuncshIxTq4Df4RTO1idAZZsep6EVsHR/Rk3HmtCuWakDmd6ztej8BjLbeV31iE+ND8Jg544voZ/y1I/beAnR9u8R9GhHLW35F9n2pOpxGMvGeubzhKoe383sN5gC/wZ+DtddZv+mSWy1W4jAMdSUmhFxcMqpZJP0k2Z3c4wDebbF8z
 gU8j4+Gi
 Cfc1PAIKSq3/8JCV4hGjMojNLaIbqYbMWyUytcrYL8vTteFIpeInr371cCvSnSNfSlm5K5j0rHIHa0JC9qKxrHNiPqePGMK02RO3VZJRxyRXRrDtQ5P72ts+coXs4kZ2qdSiKq1pM65YANUnaiGHabrNCGEYPRfRFOTwCluwsGWoQ1dUj9E5JaR7hni85E7OEbgvifam1lpGMndjLqo4UL6IzydterEIM9IlmdsZIXmlY6cmfgNdB5GQZUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Syzbot reported [1] a set_mm_walk() warning from kswapd. Soft limit
reclaim is the only thing that runs shrink_lruvec() from kswapd with a
target memcg set, and thus the only way kswapd can reach
lru_gen_shrink_lruvec() and in turn set_mm_walk(). The offender,
mem_cgroup_shrink_node(), has long carried a "Only used by soft limit
reclaim. Do not reuse for anything else." comment and a priority hack,
and it simply never got taught about MGLRU.

Rather than teach it, let's delete it. The v1 soft limit was deprecated
in v6.12 by commit 569c4f62d84a ("memcg: initiate deprecation of v1
soft limit"). Nobody has reported depending on it in the ~21 months
since, and v2 has covered the same ground for a long time with
memory.low and memory.min.

Link: https://lore.kernel.org/all/6a7a6929.b50370da.49fe0.005e.GAE@google.com/ [1]

Shakeel Butt (9):
  memcg: make the v1 soft limit knob inert
  memcg: remove v1 soft limit reclaim
  memcg: remove mem_cgroup_shrink_node()
  memcg: remove the soft limit reclaim tracepoints
  memcg: remove the soft limit rbtree
  memcg: remove lru_gen_soft_reclaim()
  memcg: remove the per-node soft limit tree fields
  memcg: remove mem_cgroup->soft_limit
  memcg: simplify v1 event ratelimiting

 .../admin-guide/cgroup-v1/memory.rst          |  49 +-
 include/linux/memcontrol.h                    |  27 --
 include/linux/mmzone.h                        |  30 +-
 include/trace/events/vmscan.h                 |  14 -
 mm/internal.h                                 |   4 -
 mm/memcontrol-v1.c                            | 435 ++----------------
 mm/memcontrol-v1.h                            |  12 +-
 mm/memcontrol.c                               |   7 +-
 mm/vmscan.c                                   |  96 +---
 9 files changed, 66 insertions(+), 608 deletions(-)

-- 
2.53.0-Meta



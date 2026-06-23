Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FD6DCD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E946B0088; Tue, 23 Jun 2026 14:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27936B0093; Tue, 23 Jun 2026 14:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF7C6B0095; Tue, 23 Jun 2026 14:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B970E6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:01:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF62C405F7
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:28 +0000 (UTC)
X-FDA: 84911944656.17.8E4FD95
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 28462140013
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:01:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lhxb8J5F;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782237687;
	b=O/h/cKEEhlfe8TNjSaAfW5tDe9CAzD9wxVaGk59UsjMyLib/bboYfV/4mMz0rRlfBEcPme
	cCB9V2KMuVhk4iy8hLxS3aQvejFeXvuAhg2yKiUMfY1U2HigLRd/fKshVsoB15us2MPMoO
	5uwMb8R95M0JCh6WkWshrIkVh+MIRJ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782237687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MY1Ldz3B6HlKyVZ18RU6aMWYK7T1s/vC+KTUQ9kZi20=;
	b=luA7Ibs7wSkizXPkr2ifuqNnCuYn+MePh0N1hOtvDGZh0wHDgdRX1hHmt+/9dV1tVPwIPR
	R+aUAwntkFJxp7V1aWINPk49GskO5Usk69rHaKuEleiCxoSucHc44iA89Gz0yC52k9OvfC
	8DFrT4FOmaDcJeYMZpyrSRM6AgUXvy8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lhxb8J5F;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-44755d837e8so155741fac.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782237686; x=1782842486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MY1Ldz3B6HlKyVZ18RU6aMWYK7T1s/vC+KTUQ9kZi20=;
        b=lhxb8J5F6AMuuHKM7y6c8ZPpsFG70cmtiW6bR3rBb14G4fROFCxQk75c4vVTNM3R1/
         z+LE+XLebEU5K3esPbi0eaWJS3o8OJOWdyTNCRc1K/wbf3In4JympWoREwxtvvleh7ms
         y/oQc62hPaktIsB6ey+mqyGWv+WEA9FEkLJVZllhn9eoJKE5YlW61pl4mdVLwgO8IeRN
         9pynyhxCxJ8KTGQmtsYUm2Hyd8CJMPwln1yzkhW7yvBJgXtt62xZ4p7CfsdX+5HGhc0W
         BTgm/NHoSjWQjrp+uhpxNrM1WH+YRV8yUbVf4q3S2Db5ML8OILvQnkNawGQTk1JwRzYN
         bzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782237686; x=1782842486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MY1Ldz3B6HlKyVZ18RU6aMWYK7T1s/vC+KTUQ9kZi20=;
        b=dGU3uoPWlviC1n+wsl56vI7E48sRXaFJw4GxK9yoHhd5R/PHin4j8P9ywp9K6vf5W1
         bM2ay8IBm3pCdYDMGMqJZzkPywFh3gXm7iWMHYAms9OE6SKci/qFHmAbDUvfPA7Uojpp
         xqAU9/1396XxSm5UsLXqaTvjZB53ujFaghO6J+iQwlMEda7e60Gjw5UAJVNxmd9p56fr
         8Rqid1Y+8gtFmxy22fNQPmMo07GBqWxDEZ+4leXYFECXRDqDf5UOjx32jNgkui/OM82l
         GZxV/SA90smBL8iBgU4kZWgpBmshEe06TSxVcnb7pAfLnY388g/p+hbuI6Y8ftIatnzq
         kPMQ==
X-Forwarded-Encrypted: i=1; AHgh+RoPReh9VjrauH1ouiHSs/9wlbwTQ6BgS1Hwc4+uSQFnf3XSXtnbBVWlKEUjq0wPG+DQDtK6N9rxkA==@kvack.org
X-Gm-Message-State: AOJu0YzC+j6eqoeRHZpm/EUiGMQMFhkJ6zJA/57HC3D76C6JbpKlTDMi
	j4yj2ZxRfL7Vb8e9v4MNGGkDM3wsyQKs+0OwHBmXNsKTiQ4Wwr2XXcS2
X-Gm-Gg: AfdE7clG2HmyyNrRmNLbJ61hn90H512uk+ySnP7/I59lxcBXqPi9bNAMZq6ZHFPuXj4
	f9W+1TzbUbQnNruuCq+2e2wwf+XK8I6NX+75zn9ui1SmSI3/Zr1R4brGMJl1jOrukF8BnqFZyya
	NCzYfpORosI1x9+cV3V8paT2RF4pT6Fg6KAShLkQbzNZv4E7+XQZsd0EGu1O+gi8cXhFwtroHi9
	HssRS0e5L6SL6FiS0u0H7rneKSkGXMD27Ke5gxh4XuhBozyhq+sjrZWWlBV/Y4/hfoA4N7RnLbo
	+VHuUoDJayW0EHFQXOiONItzR/4BMelIJR36F8unJnwfNwCbXg3GpD2mn67pBVOleaQcbiXsyxp
	fEneed3oyaqTYTwN5qvvzrPNGQlBrgBhU0b+AFUT1rLZfS2EYBxEiihNuGFrV1sty8ujSyAe2ah
	XfdResaH2+KDQFUlClI6zaE+caN/MjhNhiQLIGOY70xeU=
X-Received: by 2002:a05:6870:638c:b0:43d:3790:46c with SMTP id 586e51a60fabf-44707ef2b82mr16146481fac.29.1782237685727;
        Tue, 23 Jun 2026 11:01:25 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5a::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472ecd3b51sm8900432fac.7.2026.06.23.11.01.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 11:01:25 -0700 (PDT)
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
Subject: [PATCH v4 0/5] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Tue, 23 Jun 2026 11:01:18 -0700
Message-ID: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: eqyspmmdyqzi4ore9eh5ezepfe7rufcd
X-Rspamd-Queue-Id: 28462140013
X-Rspamd-Server: rspam06
X-HE-Tag: 1782237686-210892
X-HE-Meta: U2FsdGVkX191xUmq+rzt/1ovlpqsagxoQAce6dFSEgpBCSih7NPnei3/qcyoqdmN0Y3bp7YxSFHc1ACrRPOhC8SdHeFN5hJZ5UATS+wSkxdAuYyR8DD1/vbnvQbCY1m2SxrannEBxZaIbjeJKeiQneGgJsJKECucPxDRPiwHaKWPBR6Lr7wBOGbFSZaqM8PqsU8IYlOb+k/KO1dGPM02L2NHnxtYduRG+CQdweHnzjNMqsufvtFnLrlI3ZHNoW0d7OkgHqJ3/LTGUaqp3Bb5Hy9SOT2rWFxfcYpTpkedVYM6TOg9yP2rNzHwstn08pf3O3rB21GT8Yt7RGQQBBWcnIYNbyQBlT9OMnTCVRz6vn+Dcn3wG7N1MpBksSHLSKsU9Vb8cdTX/OnLCZRxlJT9RKvPXzFJYP7qX1iLpLv30R1XYRRgEC6J0/fMZLTQzpS25VST/IZd2tD/YgjxGmYTLkB81NbvZw/sH6BzqlF5oAre4X9p5vrk1sievN6LYC/QFSoI5Cb1oYcKI5XKu3YJAU43WpJbFYjbdENpqf7pE1bXn76ifFsmG6CPlmLADECmvUArlO7f8cxpbE7alqykb82yqgwhryLpMTrmllUADX7Vba/B9dn0dQTG1IOQBKwYxoG24jb3NxcnICVp0NTAiIu4zTUfntfZTeZNjkqK8AGPfhbpssP41r8Sz9sSpxbtwouBMFUC7zEOI/N/to5yzDUB1pcdVhINerZ0FBiDY1n2S1sNs5N+dWkS6qjWJEPzW/gZQiGgdCX8+3q/63nbLe63dLp0wZJRZl2adStmk4jNQBW6lyD8gzN9OyOxtEThyrokZBnYIz1ZB3wPGqTHhfWA5GGK1QjEmZHmLWtCQoDUUBQTIAcNTIsoSneYSLuJ/1xiNrEy2QD0M//Akv0C/FdfaV/NAi2OGHff/IRfIZwPE1Jn2VPrDgvDZ+DSBMXrONj2t24T8WRZIWBF9zc
 vK/TdKNN
 jDHZrJIG9ZTXu8eBbUy+YXIv+K/Xq4+NoA/yamdaOUAGKqlgvnujEmbRXffWM+9ZCdiBfc5IVbh8w2If706D6+GSMpnuO/wrID1tpCRSIyfeZYTDVAYwVnzK59Jmei8WQ0qKrzPQLnvZZM3c29pya6+qKhZaB3Ub3hnBnLurUEgXudgAiLgifRQpyKYvwzrb2FLij0HU0RK9t8PX7Zu4ByIMOsMx58mq8SZdxFc/WoGmbLf0tHcXhiarmH78XIFyKhRN9/riyEHpZHE860QtCM4NqewwuxZiKb57kVJ5XCZqPTHCNYZVrTDojijv48AYXyPFJ4YmGUgSHMa+bYfNoUvhjFcuibK3z1XgAqD7KjnKkyfuEUMcflnOdeAwd2n4NiGfA9NeQy69zkEcvbe35uVCHdTcSVb7LHNGUT7QjE3oC+d4nQpPUa/qrVV8DGCWC+7vnefmfxBkK9wc148njDHn9VtgpsA27MmhkkC4za/M1TIfe+z5Nm/WsuvDxjE/phMo03Ih/KM1eVy9mlrv06AIMxkfSmR3ONHnevgd7ATq+Xyc33JEwjx0ceexlnsFH1Sx1tc06JrVYHFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is intended for the next release cycle.

v3 --> v4
=========
- Reduced memory footprint by 4x, from 16 bytes per-(cpu x memcg) to
  4 bytes per-(cpu x memcg). Each page_counter_stock is a thin wrapper
  around an atomic_t.
- Removed locking completely and uses atomic operations to use stock.
- Removed synchronous work_on_cpu. All work is done via remote
  atomic_xchgs.
- Added a patch to flatten page_counter charging in try_charge_memcg
- Split page_counter_try_charge into stocked and non-stocked variants.

INTRO
=====
Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
allocations, allowing small and frequent allocations to avoid walking
the expensive mem_cgroup hierarchy traversal each time. This fastpath
offers real improvements, but there is room for improvement:

1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
   more than 7 mem_cgroups have stock present on a single CPU, a random
   victim is evicted and its associated stock is drained.

2. When one cgroup runs out of memory and needs to drain stock across
   all CPUs it has stock cached in, those CPUs will drain all other
   memcgs' stock present in that CPU. This leads to inefficient stock
   caching and cross-memcg interference under memory pressure.

3. Stock management is tightly coupled to struct mem_cgroup, which makes
   it difficult to add a new page_counter to mem_cgroup and have
   multiple sources of stock management.

This series moves the per-cpu stock down into page_counter which
consolidates stock limit checking and page_counter limit checking into
page_counter_try_charge_stock. This eliminates the 7 memcg-per-cpu slot
limit, the random cross-memcg stock drains, and slot traversal. We also
simplify memcontrol code, since we no longer need to maintain separate
draining functions or manage the asynchronous workqueue.

In turn, we can add independent stock management for additional
page_counters in each memcg, which is used in my tiered memory limits
series to add a new page_counter to track toptier usage [1].

There are a few tradeoffs, however.

First, the bound on how much memory can be overcharged (and remain stale
as stock) is raised. Previously, it was fixed to nr_cpus x 7 x 64 pages.
Now, it becomes nr_cpus x nr_cgroups x 64 pages. On large machines
with many cgroups, this could be significant.

There are 4 qualifying points:
1. Larger machines should be able to tolerate the additional overhead.
2. Stock should not remain stale as long as the cgroups are actively
   charging memory.
3. Getting anywhere close to this overhead is difficult and rare. It
   would require processes to bounce across CPUs and refill stock.
4. These charges are not "real" allocated memory, but rather accounting
   done in memcg; they are easily returned on pressure.

Secondly, we introduce a small memory footprint.
The new struct page_counter_stock is a wrapper around an atomic_t,
which adds 4 bytes of overhead per-(cpu x memcg). On a 1024-CPU,
1024-memcg system, this adds 4MB of overhead. Smaller machines will
see much smaller overhead.

One small side effect for cgroupv1: this series decouples swap for
the memory and memsw page_counters. Since stock charging can go out of
sync, this means that users can transiently see memsw usage go below
memory usage.

Finally, by moving from asynchronous workqueue scheduling for draining
to synchronous atomic_xchg, drain_all_stock holds the
percpu_charge_mutex longer while it performs the work. This means that
chargers may be more likely to be unable to grab the mutex lock and
exhaust MAX_RECLAIM_RETRIES and OOM, in theory. In practice, I have not
been able to replicate this behavior in my experiments.

The series was built on top of latest akpm/mm-new as of Jun 23 2026,
which is cdad4d4e4fc2e "mm/swap, PM: hibernate: atomically replace
hibernation pin".

TESTING
=======
I tried to demonstrate the worst-case overhead this series introduces
by writing a microbenchmark that pins multiple cgroup jobs to a single
CPU and repeatedly faulting and releasing anon pages using
madv(MADV_DONTNEED) in each cgroup. The data was collected over
30 trials of 15 iterations. Metric here is time each iteration took (ms)

+----------+--------+-------+-----------+--------------+
| #cgroups | before | after | delta (%) | variance (%) |
+----------+--------+-------+-----------+--------------+
|        1 |    112 |   112 |     0.000 |          1.1 |
|        4 |    443 |   451 |    +1.806 |          1.1 |
|       32 |   3512 |  3584 |    +2.051 |          2.0 |
+----------+--------+-------+-----------+--------------+

It appears as though there is some small regression, although the
magnitude is similar to the coefficient of variation (stddev / mean).

CHANGELOG
=========
v2 --> v3:
- Dropped the cgroup v2 optimization, since it could indeed lead to too
  much time held with the cgroup_mutex. Instead we let the stock
  accumulate in the parent cgroups, which is not so bad; charges can
  still land on these cgroups, and if we ever reach the mem_cgroup
  limit, we can easily return those charges.
- page_counter_disable_stock no longer drains, just prevents
  accumulating stock. The actual draining is done in the free_stock
  variant, where we know for sure there are no in-flight charges.
- Reordering the page_counter_disable_stock path to disable before
  draining as to prevent accumulating stock first.
- Skip isolated CPUs when draining synchronously
- Rebase on newest mm-new
- Wordsmithing

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

Joshua Hahn (5):
  mm/page_counter: introduce per-page_counter stock
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: introduce page_counter_try_charge_stock()
  mm/memcontrol: convert memcg to use page_counter_stock
  mm/memcontrol: remove unused memcg_stock code

 include/linux/page_counter.h |  19 +++
 mm/memcontrol.c              | 280 ++++++-----------------------------
 mm/page_counter.c            |  90 +++++++++++
 3 files changed, 155 insertions(+), 234 deletions(-)

-- 
2.53.0-Meta



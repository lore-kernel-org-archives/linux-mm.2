Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49BCECD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 19:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3406A6B0005; Mon, 25 May 2026 15:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0A86B0088; Mon, 25 May 2026 15:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DFA66B008A; Mon, 25 May 2026 15:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCF56B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:05:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1BDFA01BE
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:04:59 +0000 (UTC)
X-FDA: 84806869518.11.775CB05
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id E9E75100014
	for <linux-mm@kvack.org>; Mon, 25 May 2026 19:04:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BLQbGwHz;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779735898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZsiSNZGlI52E7JWBNAgrZcZTSVxRjmA7Low1cc7dass=;
	b=qN68yr1bq/diZw/taP/66zuCqDTJFO7DjM67C1FPhCr1XX2Pus8hXDua4K70pwYbVZcHIC
	ithgAoiDgscUrMEnvQyVpFwfk2pMLdOX1ifVLqt4hsYi+HR+Ugf7GFTyalTeftbBAEKS0p
	1HFJBhvlQBulB6DLaHhdwpH3JQ4iY+E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BLQbGwHz;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779735898; a=rsa-sha256;
	cv=none;
	b=zr42+0FExPt+29Jc+cSDam8OhEGTN5+jHz1WySw0iviED+JGQwN32df3uobYSlaoEat74u
	886NkHeOKaH0wcRBl+D6TEOtSD3J1cdTcIvGtsfoH3F4rl1D+0ydr76AiIfkbhb8ecFdpt
	Fo1u+lHeWI5MWY3q996QogXle+uIlG4=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e568ab0bc5so10684490a34.0
        for <linux-mm@kvack.org>; Mon, 25 May 2026 12:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779735897; x=1780340697; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZsiSNZGlI52E7JWBNAgrZcZTSVxRjmA7Low1cc7dass=;
        b=BLQbGwHzSQR7MbXBhWgRh5GO7IEf8UUnaETC/IWHbaGNr64szInunYPWpQjrheg4Ma
         i5YHvmIkuCULs/uxYHt4hdnmdU5KUNtlYL7CdPaI4uWX8vMXmSzIbi9B+h5pwu88MpKR
         efl+x+R8ENvwqj8+xuRYwTDtOh/0umCN37C8Wmjp10bs/9H0d8/azVqxTWLFP5f/bLjm
         eUvx7GkYKKQPLTvR4AqLdb3eotGy5l/lME8RjVhTFRNBTCgnANB1YEdOkwIRQt+LPD09
         HGn70qM7f7TEbnX/aaTJ9zLr+FvpWFaTZnLGBRCf425gVaTrD+ELVftH+5bJyUYdmJQZ
         60bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779735897; x=1780340697;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZsiSNZGlI52E7JWBNAgrZcZTSVxRjmA7Low1cc7dass=;
        b=SPr2CLLcKEvDCo1g4Wep5EcesmTjdV0E3qZ/mGHPNH541524qH+bagdzbdE25OerDO
         dzLLO1SDI5/bspLUejq7F4iWAOfjx8DcsYoWjRmRbDvrs+fpeYxe+T4NM5mB9ApGfQWy
         DO013k1UI3lXwbQceyiayVNYIgBcMjjDLsUus91J0N59QR4qh/7xhn+h9nSBqob/Lg0M
         Ls72kzsJcugqOjjgmI8/NAZ49xquxboVEUZAzjV029LGjMecBlBpMnGNoeMmPUGvOoKu
         fTA/OrwLHy5ZVMr06A6ah9Idukm4dV0bYP7g/zRWj7ixuyLwokhUSlcsODYtkBsf/0KM
         PooQ==
X-Forwarded-Encrypted: i=1; AFNElJ/fV2Ote6DRHDpHZTM3aDNM/X8v8L2aLTapHev0kyiHc9JACeLzfuA3AlDQ16pQSiBC5vIe4V1q1Q==@kvack.org
X-Gm-Message-State: AOJu0Yw5MroUkgOVXV2dIBiML6Amt6bYVbSuwavjR9vI/WmvyYwwXeVK
	69vL0ntpH32Isr0em5kUS50x3xvc6IOZ3Qp6BLpXWeNC4IrPyb19346f
X-Gm-Gg: Acq92OGpowHgXhes5tRUVgYLhnO3RY3iP7HQVtu87G+bd+QSIq+GOFkzE2dAS57WcBh
	F9y8SxlUI7AKfUlJkLOzZLaLAxCUlIFYnooHQlhl10//Hjyb/5vbCIq8AxkXw34zDg+zf3oIpLO
	KHryddqdMRaHQHg+bvBrStGGQc0+cVqot0P1K1bJHnFQY+a5DVoiZTRkHRVrXTmWOXUTVnOxMQX
	wime410o70TxHaR+3EVI7QuqfNyZyn4MFoHmYeKtw2WX3MAwz22hdSnW5B9OUCygrv6wGxr6Yhn
	z0Q/seJjKUJiJT+LTz3YqzZTvQsBcynPB4EkJkK7GaOYs+jsAbBAvHkrFI6udWej2goltJyCxRz
	7beNeZp2uTcMDobAZ6pGN7FzkL56QURU8ww76720zXInIEQxWvYoJRoWKxv8d6Re/hejHhZKe1s
	TAN7tNbBpEeI0NGXQT/loAbv80rBcSehA9V2JQ6x+DnMd9f6wSq2He7Q==
X-Received: by 2002:a05:6830:41:b0:7e6:50c4:e954 with SMTP id 46e09a7af769-7e650c4ff36mr836626a34.11.1779735896872;
        Mon, 25 May 2026 12:04:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5d::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6060b2dffsm7751933a34.0.2026.05.25.12.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 12:04:56 -0700 (PDT)
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
Subject: [PATCH 0/7 v3] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Mon, 25 May 2026 12:04:47 -0700
Message-ID: <20260525190455.2843786-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E9E75100014
X-Stat-Signature: dwj9jbepchoh1o4qk5pbq5toqd93soh3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779735897-481948
X-HE-Meta: U2FsdGVkX19b9X7tRJK24bXCXgNyO6ds3qMfDmLyZtn14D4j8CTvjHG2OqQZLb7i4DBT/7qs7Iy5/ldUz/07HLAi5kQSNc0Kd9m3ueLsYiaDT0w5WgZmLCTk9qRhsus9F77xbpXs5M7592JSWrpLYbyuVy9JPNhJsZVb9XnGi1ml8M+Uvxxh0AiNrAKPPjWTRoBSeb9X7lH78xlDKFkngPfxVIiB75WB1Y01EVIA+/3uX6S7mAJg5eLRS4tTppsVT8QG9CUtVMYdsKsGMT5qf6xgDS8r5FZecWRHK1xRH5C97JrPGkfxzpCPTx6o5BdkFHizub3oEmmXwxWO6uNAYAC4tvFbjiQeEzg04IvPIfm+XQ9JkDIzNPY/WuI+KUDJUtCRiGOqx5a2kMVGRdPsJWuhPwRlPDUFsYOULYsajv22HJ+OrVbG+5vz1bw0yKOAlLaDBL+14WxC3AUU4inX+5iTjggptM1TnOM8M0Cxc8rzTsEyBqsXw587aWM4ji4ny8jliU0MdbDPLW3UpVPawfha7Htq+yj3Yd1EyOpZ+Wt8dIrhxSgVrcvPZm/OCo4RI7DAgD1VECmAJs8JxyanNvtTVTiqzDo5gNGrsQIQv7symzJI8NkGbqldtx2JuTRStm5TBS1KyfrAYq3KdUbrz5r4UqUvCKpb0qo+FBiOj/Z3Gn308hx3IGMO2qgD5zlSeQOXDtdjT1T2KNteMUeBUwhTOpTs1MKQvO6/jlNdhfaIOXTGnSAVlKiZcWUh9sOsrtXSt2AeRysQVXf/uxu8pYsYfJLIVScjgwDnxVyfmD0RVh/A8ktkD8sXn5UfgMLohfiRtnCkvuQQy5WV8A8lYO/EBWcebpQbPfi8lLBHiYrDtQ16C40mCKpQIXZQvAg4fJP/XYxhpe7cEqTGgdQ3KMkiioFuV0hxZ0UdHpgeP3EDu7KOqXWnHsPeo3Y/WNLVendogDicvR/lTOhuBEO
 TfqvTYKw
 P33/Utio4ymgIJfqza8k/Ii2LAr80VKX7zvR7N5Zl0y7k5X/4vD5yoMVgvHh9L8CheL5wUUm/lCsQh4jqAQQa56msoHuCDCFvTiEcIyctFX3AkVAwN6omQBdSazcNgyQNN6lYrfoGKV2m72ElJh8bv1pnRDZS7WLUmAXVkp6zneo880nLJCzIgZT7eDRnmCKgk9cFGzoi/7hfvPFtaGzFswhgljygxj+bdPxZlm7FEHxWmtHxm29fLW+w2EHeoPg4WHRqPAd7iKpNmBhuv3In8882TsRQwOYASP1o9OHaC5rqpJ946oJiP0mfe98XJ2BB4cL5p4+johKHZROVu9M76YDh98Nsc+O9sNy+asYv335wb7x5wK6/kRPf82dEVs4Vfcg9ZexeXidE5V90ex4P0YDEQ9NSFNsMLXBbSTZgAMoSu4ESSD5ePagm/4Qh1zVZrMB55LZwlNZh4JFEn9OVG90llBZ8pTfqprPuAMsU/u9V1RwDm7qgt1buvFY2C1yU3OPb2oz8NMQZO7sMDOsVRVgn8gaVJhiv06hA2sLnM2JpWEurCt7SJB8Ubdy/aTlOIwrH
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
stress the charge/uncharge path, across 40 trials of 50 iterations.
Metric here is time it took across each iteration (ms).

There are two testing versions below; the only difference is that v3
is based on top of mm-new, and v2 is based on top of mm-stable. The
"after" on both sides are similar, but mm-new and mm-stable have
different perforamnces. 

v3, tested against mm-new
+----------+--------+-------+-----------+
| #cgroups | mm-new | after | delta (%) |
+----------+--------+-------+-----------+
|        1 |    357 |   358 |    +0.283 |
|        4 |   1245 |  1214 |    -2.430 |
|       32 |   9281 |  8970 |    -3.470 |
+----------+--------+-------+-----------+

v2, tested against mm-stable
+----------+-----------+-------+-----------+
| #cgroups | mm-stable | after | delta (%) |
+----------+-----------+-------+-----------+
|        1 |       352 |   353 |    +0.283 |
|        4 |      1198 |  1217 |    +1.585 |
|       32 |      8980 |  9027 |    +0.526 |
+----------+-----------+-------+-----------+

Further testing on other stress-ng microbenchmarks also agreed with
these results.

v2 --> v3:
- Rebased on top of latest mm-new, May 25, 2026, since the previous
  version could not be applied for Sashiko review.
- Re-ran test numbers

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
 mm/memcontrol.c              | 289 +++++++----------------------------
 mm/page_counter.c            | 140 ++++++++++++++++-
 3 files changed, 212 insertions(+), 233 deletions(-)

-- 
2.53.0-Meta



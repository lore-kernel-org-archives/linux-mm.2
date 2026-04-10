Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C650F45A0D
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 21:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 886DF6B0089; Fri, 10 Apr 2026 17:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837846B008A; Fri, 10 Apr 2026 17:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7275F6B0092; Fri, 10 Apr 2026 17:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D26E6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:07:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA684E3422
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:47 +0000 (UTC)
X-FDA: 84643882974.16.ABF2982
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C710180005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:07:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Zf2Ci/Ln";
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775855266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OMjyo1BeE8Sjl3rJFGc/7waGNwkRpFV9y7vNe0a0k/I=;
	b=a1P2HlfYLBluEOCjVD/JZ2p60XnPY5l4PsXNxOHyhJdZQ55Kg0Qud5b3QoOGdRenan5v9m
	3BT5gN3bBJZFrJbylBtQ75LTINafXbKEFiBde2CUI6TgZcgjzxGoJyHSRUUaN9xonUHXVE
	OfTbRVMxKl98zGRKsXpQyAYs+HqFkWc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Zf2Ci/Ln";
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775855266; a=rsa-sha256;
	cv=none;
	b=X04sPqmafBUrOnP4VQzXsfZZpslurkCy9BjmyH2c+31H7EzZT+4d/Hfy94RaAJOs8pvsFw
	RZgrq5LUvgr97bI5d4ZxW6qUh9aD8EB+NhhEDMOvx0OUL089iHhSXA8RkRHLwd0TMQNpGG
	lAwsrnqEFheIJpex1isAf5qSq7h34Mk=
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7dbe437b072so1375397a34.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775855265; x=1776460065; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OMjyo1BeE8Sjl3rJFGc/7waGNwkRpFV9y7vNe0a0k/I=;
        b=Zf2Ci/LnZ40V8UomkZ7q5AFbK4pN3ICyXkQAXVvWWsMXDGw73H12b0YS4DeN7CKMKU
         k0msSMiWvp1RlJ0bipR9DoCsE6Fx3N1bSi+X/yabwfrI0bBbd3NkisiXx9W+ChB0nZcS
         MiAl61CiZRdxImW9YAmIVI/SGIzssffd1ctDs2LdkTVybp2r1Q58K0GGWZZr5El3rSeT
         IN67lARI3IAzxA9NNgL04u3miuXw1hA1+s35+07burJdBKuSxtuEO4XazBhvIsqxvMzr
         5OROcOZM83CqF1RAzmezpSa8Xa+JnlSDu9rN8t2a2M3nLBgWk/mGcoYK5RSaYD3sX7AA
         UT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775855265; x=1776460065;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMjyo1BeE8Sjl3rJFGc/7waGNwkRpFV9y7vNe0a0k/I=;
        b=knxA7zsfJxwg4Jrpumo+ZV3g2kELLnX81026uvKlgPYo5EGaoYrDp2FpFHEJz58OL/
         i7NFkXmJZC7plRLZMl+V66n9b5Wmu58Hd4Hp2L8856zU8Y8MmtgKOhXb4e3qqND2CTQ3
         ZWMWVmlrNiThBIaOO+Wq2qmo/ghEvzEFmhdqpfUECEo/alj/D6pYwb4t2d1htfQ6Rbn0
         ceeGEuEb5imfnD4QeuugNPBhAPdpquDeXD8YMwsK84k1+M2PSYmIGwTHy/WOmB6ErSKO
         16Y2ikP0mRyI9Mkh8h12VCVd7QVgGwlE2Q+sm5E+vyiTqOpuIyPXF7ZPoxnI2cG3t65J
         hG3w==
X-Forwarded-Encrypted: i=1; AJvYcCVH+T+bOgT+YaLlB4vqcAlbkD/6iGS8S8gGP0LkGVp2rDg1QxhxByvfRoGCkBhlIR+tVop32dt6sQ==@kvack.org
X-Gm-Message-State: AOJu0Ywc8PHu/cCT6jQHXauGsCoDmPZ/6EQS57VsX8orJHMwHZGnQCJ6
	i9OZeRhSqj003w8hQcybgLGR6rDnrYoopNnRKFhHj0+4HIYcBKGxL8t/
X-Gm-Gg: AeBDieuqcZFMUuDg2WinREIP6l7OJBz8sDqCvVrS690IO2jnGwrJxiDuZUvTKsZss0w
	uR5EjsiY8A7kAU/JCwIGdxB+WBFjiqY19hFMbv63ZBlBonNBvA/Uy1n5smccNAEYa5xiq4Ezj+d
	L/NmpUPTqRU7HMEyti0hnP2W1C7VLlLBXS3BN6rBY8TicncqcDI4BNftUjE57fHHhxipTNl+/cm
	csIzXtVqMSKsV6nYNRDr6qrx7n0FxBGiwfOUz7XpNl3EetERML2dviN1hDN03EQFz9qSBCNGoUn
	4d2HDGiCzZTpujLXS22zSOKztcxr1hv4D/+GloiQgp5+tBXPys4oaVLvAqm31hnAbjU6+P6/j89
	zI/BHXaDhmaFkHQ6e0d6JvHOlE6fiH1kVnnp2RzS+7mpiHT5eYubkV2sZCQt6BqMvV8gLjlLfjY
	wSD9FPLM7Z0vQSGpKiagT5nA==
X-Received: by 2002:a05:6830:6b06:b0:7d7:4fc7:21a with SMTP id 46e09a7af769-7dc27ceee0cmr3297522a34.13.1775855265063;
        Fri, 10 Apr 2026 14:07:45 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc2660ef75sm2708244a34.10.2026.04.10.14.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:07:44 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
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
Subject: [PATCH 0/8 RFC] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Fri, 10 Apr 2026 14:06:54 -0700
Message-ID: <20260410210742.550489-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C710180005
X-Stat-Signature: wjnjztk1hwtsbrt184qiyxh9ehc3ekgc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775855265-187969
X-HE-Meta: U2FsdGVkX1/S/QSodW4hpd+YJDfZc6u4tjK9LS9aWLvNdGQnAmqgDHmuHD1kj81vUKBlz8TdCG5wJ0PaSC3mdlHyfKo2oJOOnCQVmPGES41/8thnVCt7ZaXzQZoi5voVzKhOtZ2YITJL3Gka9asYmIZut1vuFXCoKPhjoaAxwJmtjxR5iX29OcDjiXaba+Y5Jsdfh4JgpVbzIfadcLMofpy/qx51uwCvoA5OPzzvM3tcHw6CWLscLd5a+KIrFMsPQoczMFhwPmSaMBKh6g34Lj5JV9ZHz2Tw2oicJF43QG2A21q2W+1HzfKw+1/ZgKMXiyoiMroZQ7l5j6FicOvm5SY5TPyAo/jzXQkbag4WMO1DLSlTT5NOda4oMU13ImgZoxXeuVLbOvlfpcf01KMqHGhnUQU1ASNxdpzDhVkyhNCLmuYFJRhbqwfQaTHNX7w5JYWk8N9jfUO0zbP+GfFd4yXiuwyiPB1NS0PH1SoP9iIZiNP2k1dAEH/fgrW2LRxCXOVdV3uGu0Yt8KFYgYPdxlTDMlza/JZzdBRs/f/owKOUfuAPdVDpojIv/ZCo5ylNa2Zda5MCXWs0kMeOiyapvd0Nq63HWHpxjKL+2O1ploRZQSu8mwqfDTUB/3tswCPN8x7OOV9QIXm0CESRlKcj8/RjEE90B0JckALeyG53FVS+DuPEy7NZktRhGq/9eZ+4hJ/jGuMFCpWOKC11S9/WvW89aRclN7BG1TrDheVHfNRDVQmOgc0uekraOOTpHWTHnfJQ3C17Bo3KoWTEYjbAEMXaStjv8RHqDjNtk3qxep/d+rgCEDOGtOqK8bZu5egRiP2Nkv6/mONS1NKWVnnmnUBNskmJ6ZP/ZnaMD8C7KaJERC4XORTnJAuuNtAq3ASEkfuIzSAHpPoCOMz4yCu+nrRYZHz592aiUYxfoyojQZMZ/9OIhRn/CiJ6g8r2qzq/JDSXVqXGYmOXG1kDjkW
 QLgy5f/r
 lWr/auykEF/23N2qCNo4sKhGufc4ZVGVgySjr7luMyHly4qXGc8+6/eGoUK8nxI0k16iwnJo0RDlAi1ZvXAIVGczi232Xx/m921j4SEn7Im+CSx4tv8u5GVJ2hie5zvfzNrA4tqaZQ4Mmxx59B+Hcf7L+g1jZzthuT9f8gbbSVTbin9hivHArCamfuChp8xKhazD8HcfLc4Zpo6EJifCaeivDWmhowNewEBLSK0sofpobpdb2s6QEsOT+s2aLWGjerPSCkX4TbJ+lUb77RRsJIxTHfusM5hRA37V6dofiPtvI5/6Uea0dcvTF/IPH0m7NjP+f4pF+2vhU95ijME3lFyjYKiKbS8W4Ixb3qDkmb221TWxdfmQtxr0kCOpE5vOJa0EHz6ZwacaQSX+pVSpui/aNbIJWwOwcS3/sRQPNeH6bQedMkAB+kSGjPpi/q37qc2FeI4UK+UV83Nd+7C4F1xHC/zdc/gtWNSlT6Y/Ia4OU/O0701gSP7VC4wXYUEuW+p/F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
allocations, allowing small allocations and frees to avoid walking the
expensive mem_cgroup hierarchy traversal on each charge. This design
introduces a fastpath to charge/uncharge, but has several limitations:

1. Each CPU can track up to 7 (NR_MEMCG_STOCK) mem_cgroups. When more
   than 7 mem_cgroups are actively charging on a single CPU, a random
   victim is evicted, and its associated stock is drained, which
   triggers unnecessary hierarchy walks.

   Note that previously there used to be a 1-1 mapping between CPU and
   memcg stock; it was bumped up to 7 in f735eebe55f8f ("multi-memcg
   percpu charge cache") because it was observed that stock would
   frequently get flushed and refilled.

2. Stock management is tightly coupled to struct mem_cgroup, which
   makes it difficult to add a new page_counter to struct mem_cgroup
   and do its own stock management, since each operation has to be
   duplicated.

3. Each stock slot requires a css reference, as well as a traversal
   overhead on every stock operation to check which cpu-memcg we are
   trying to consume stock for.

This series moves the per-cpu stock down into the page_counter, which
consolidates stock limit checking and page_counter limit checking into
page_counter_try_charge. This eliminates the 7-memcg-per-cpu slot
limit, the random evictions (drain & refill), slot traversal, and
css refcounting.

In addition, it makes independent stock management scalable for future
users. As a demonstration, this series also introduces independent
stock management for the cgroup v1 memsw page_counter, which curbs
the likelihood of the worst-case scenario (traversing both the
memsw and memory page_counter hierarchies).

One change that should be noted is that draining is simplified to use
work_on_cpu() for synchronous remote CPU drain. This eliminates the
need for backpointers and embedded work_structs in the per-cpu stock
struct, which minimizes memory overhead. This change over the existing
async drain scheduling was done since the drain operation is much
more rare now, only happening under memory pressure and on cgroup
death (as opposed to the previous arbitrary scenario where more than
7 memcgs are charging to a CPU).

Performance testing across single-cgroup, as well as 4-cgroup (under the
7 memcg limit) and 32-cgroup scenarios on a 40CPU, 50G memory system
shows negligible performance differences. In the tests, I repeatedly
fault and release anonymous pages using madvise(MADV_DONTNEED) to
stress the charge/uncharge path, across 30 trials of 50 iterations.
Metric here is time it took across each iteration (ms).

+----------+--------+-------+--------+-----------+
| #cgroups | before | after | stddev | delta (%) |
+----------+--------+-------+--------+-----------+
|        1 |    446 |   441 |  5.097 |    -1.195 |
|        4 |   1832 |  1822 | 11.897 |    -0.582 |
|       32 |  14730 | 14739 | 54.089 |     0.061 |
+----------+--------+-------+--------+-----------+

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Joshua Hahn (8):
  mm/page_counter: introduce per-page_counter stock
  mm/page_counter: use page_counter_stock in page_counter_try_charge
  mm/page_counter: use page_counter_stock in page_counter_uncharge
  mm/page_counter: introduce stock drain APIs
  mm/memcontrol: convert memcg to use page_counter_stock
  mm/memcontrol: optimize memsw stock for cgroup v1
  mm/memcontrol: optimize stock usage for cgroup v2
  mm/memcontrol: remove unused memcg_stock code

 include/linux/page_counter.h |  15 ++
 mm/memcontrol.c              | 269 ++++++-----------------------------
 mm/page_counter.c            | 173 +++++++++++++++++++++-
 3 files changed, 224 insertions(+), 233 deletions(-)

-- 
2.52.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA09C88E54
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2DF6B00A4; Fri, 11 Sep 2026 04:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675706B00A5; Fri, 11 Sep 2026 04:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B6856B00A6; Fri, 11 Sep 2026 04:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 352A26B00A5
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:01:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FB0AC013E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:23 +0000 (UTC)
X-FDA: 85200736446.22.272CAA9
Received: from mta0.migadu.com (out-137.mta0.migadu.com [91.218.175.137])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7843C1C0009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dHNE8/Cn";
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113681;
	b=xSYvsRJ8lV6XNKgOb0c0EiG3XzX9AO04fAkM3itQ5wdNRYFEmg756YayB1GCqlfDcOf6/Q
	iPtlX8hdzkbFunV3TwPq7FeMjWneKthdonDwzjcd1wbv7onqVzFlXDVYIS0DJ+Aly7moys
	1qrGqzYJiQDbFWlCnNIvke+I0hMjn1M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dHNE8/Cn";
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.137 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vhmro5AfKrMJgXwz5T7kiuFN5hfsA1tCS2xq6WtVCf4=;
	b=aOJR3jS3vI+eQt4AVzs+A1rbhljcCuDaa/J2zSNSJIi8mLIh0NGxzYBRKNEMZ1ezbdg1j2
	NnS9ETCXaQzKxC/gWexT4lLbzy64h3NCR21+7nr8XeaVhRJIsvUb9+E+hC43OtDInTaM8V
	gPgdFOMEHYXsVxEACOF982N9SKdKwLA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OKkfFQ/5u1ZQ06ulHO9rwS0KYJDTzNO4EMxRVAB2baU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113672; v=1; x=1789718472;
 b=dHNE8/Cny96RhIuRk/dZscC6RK6INg30/jQLti7Lei1AJuy3BkbEVjfLE+F5Gw/I2SWdpQhq
 D4UAFvpHdAy3eIi9Cjq4HkZUL/uR+B38NyhGzoTkzUscVomIsRZUSK7CSdcE5Lp3LY1buxd5D6w
 SUEORgoSuF2ywt4EskN09jm4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id bcd983cb8d37cc8f;
	Fri, 11 Sep 2026 08:01:12 +0000
X-Mizu-Trace-ID: bcd983cb8d37cc8f
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v5 0/4] mm: workingset: fix the shadow node budget under MGLRU
Date: Fri, 11 Sep 2026 16:00:47 +0800
Message-ID: <cover.1789096175.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7843C1C0009
X-Stat-Signature: o4xijwa1ezfygu9wsedzibz6gp5ou83x
X-Rspam-User: 
X-HE-Tag: 1789113681-265904
X-HE-Meta: U2FsdGVkX1+MzaXt43GcWoidjqWmSwOpTWjNgOlR9YsHRD9F3nTOr7Mq/fhvjLRvAEhz71m+nBoAIlRuEnXrzrjxepEVAGrrQniGZkouvf7afdeAUMY8kQgE2y7oOQVlRl8xUmBYTmtEJ/7rMEolgdxzg5iAEhI5raF5A5WQP3MZumwBsL2nCAibcWunCrmqfk1CbIdAtak7F20d/5b0TE8I43qf53oQpgz3D1Z7Mwn+MVCw0RBEUKYAkwwNL32lwkn3lJuqElFU5v/qLWqr3Jl+HNVWnfqrwmRwtlyFx/4cmQAxSF+V8SXwInEjv/y0Fsw+grSC/S2B20USmJTIx1lywxssa9vM8eh4Oq4PPDZ4ws+9LNtAa+qX+I9gaVa0Sm+lLRzUhBgOG0++ppPylnX4EJXjVcvX3i/QphCAZSZXRTZUt+xt03s/JoKJ5UM3n9L8FfR8P71LLP887B7ol3ZeTXXMyXuPPCwuWOfvdtxuTtYwGNyVkMevBB+gz8fiJkItlqEel2Dk+J76SGxfSndqgpFkqB3EcedwDl8/9ijtZYd6xkCZJHRFDtdlhJGz8Zv2vNqDSo2qsxipvUQoISxzzGxAYXUcjKbPUKqg+YAeuy3oi9SLCK68ItvPsOBFeVJwC9OgLRcaUSBJjwZ7FTYaiQnnMmCg5eq8L1wD/tGcxqKKDoio06aNZPy/X9ZWGnpiPcMUVGc+ig0G2G7XoML9R2zn1EPOjai115mhBSQlq29AzJYO5hhwZxgBgGe6IqBvIjGC1ptzVKwMmKMt0r0xxqp/u1SdoYAZqMr3t+7vnsYZazk156ObJ1v1MChfN7WzeW/WIaRsB7NjhnMXQyiB4xpMHb959nhQLyAoAeiKlWx0HF6njUXUu1kg/YrYYB1txiQRBYT7+8FtAsxD3U3kZwED4bybGSUyMEwvWcOi5tX21J5304vP8pOREiwEbb2Mky7MuiOAgvQxw9c
 eij5norW
 kPmUHO2d1+usqF4kBcCg8iI5UVZWP3TeIxZrRH9oSdTqGzptrfhPQHTnaCzyliZNe4Ld1H2J2on9gF1laRDO+fpgBonBbcucknsqfePLTs9v2xF6fHO7iqgO0An+caBzvGurhBu3AopRShWQaMpTDzR9gVFzi1y2ufBZDrC/KLWyehX+VXzC3uIx1XYnlXsDnRpJDFHLGd++fr6O+g29JY3uiuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
number of lru pages") broke the workingset shadow node budget under
MGLRU: lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never
maintains, so count_shadow_nodes() sees the evictable LRU lists as
empty and the shadow shrinker reclaims eviction tokens almost as fast
as they are created, losing thrashing protection.

Patch 1 extends the dying-mcg stat redirection (previously cgroup v1
only) to all hierarchies, addressing the reparenting race that motivated
7404bd37cfbe.

Patch 2 then switches count_shadow_nodes() back to
lruvec_page_state_local(), which both classic LRU and MGLRU maintain.

Patch 3 recovers the performance.  Patch 1 added an unconditional
rcu_read_lock() to the stat update fast path; patch 3 checks
memcg_is_dying() first and takes the RCU lock only on the rare dying
path.

Patch 4 closes an accounting gap that patch 2 makes visible: on cgroup
v2, reparent_state_local() never moves the dying memcg's
non-hierarchical lruvec stats to the parent, so the parent receives
the uncharges without the matching charges and its state_local
underflows.  Patch 4 reparents those stats, mirroring cgroup v1.

Performance testing
===================

The test script and the raw results are available at [1].

Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
configuration, medians reported.  Workloads:

  w1-anon-churn: single-threaded anon fault/charge loop in a memcg
                 (MADV_DONTNEED + re-fault, no reclaim).  Every touch
                 is a real fault with charge and memcg stat updates,
                 so it stresses exactly the fast path patch 1 changes.
                 This is the meaningful signal: it is not reclaim-bound,
                 so the small fast-path overhead is not drowned out.
  w2-file-churn: file read loop under memory.high pressure
                 (reclaim-bound; the differences below are within
                 run-to-run noise and are shown for completeness only).
  w3-reparent:   reparent accounting sanity check.

w1-anon-churn (pages/s):

                 classic LRU          MGLRU
base             4393028              4377122
patches 1-2      4385996   (-0.2%)    4352887   (-0.6%)
patches 1-3      4381832   (-0.3%)    4377053   (+0.0%)

w2-file-churn (MB/s):

                 classic LRU          MGLRU
base             8277                 8226
patches 1-2      8226      (-0.6%)    8123      (-1.3%)
patches 1-3      8157      (-1.4%)    8294      (+0.8%)

w3-reparent passed on all kernels.

The small overhead visible with patches 1-2 comes from the redirection
added by patch 1; patch 3 brings w1 back to the base level in both LRU
configurations.  The w2-file-churn differences are within run-to-run
noise: that workload is reclaim-bound and too noisy to expose the small
fast-path overhead, so w1-anon-churn is the meaningful signal.  Patch 4
only touches the memcg offline path and is not exercised by these
workloads.

[1] https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a

Changelog:
v5:
According to the comments of Andrew, clarify the performance testing
section: the w2-file-churn differences are within run-to-run noise;
w1-anon-churn is the meaningful signal.
v4:
According to the comments of Andrew, Fix "follow-up patch" to
"preceding patch" in the commit message to match the reordered series.
According to the comments of Sashiko, add patch 4 to reparent the
non-hierarchical lruvec stats on cgroup v2 to fixing the state_local
underflow.
v3:
According to the comments of Shakeel, reorder the series per review,
add Fixes/Cc stable and the user-visible impact to patch 1.

Hui Zhu (4):
  mm: memcg: redirect stats updates of dying memcgs for all hierarchies
  mm: workingset: use lruvec_page_state_local() to count lru pages
  mm: memcg: skip the RCU lock when the memcg is not dying
  mm: memcg: reparent non-hierarchical lruvec stats on cgroup v2

 mm/memcontrol-v1.h |  5 ++--
 mm/memcontrol.c    | 72 +++++++++++++++++++++++++---------------------
 mm/workingset.c    |  5 ++--
 3 files changed, 45 insertions(+), 37 deletions(-)

-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9883DC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915076B008C; Fri,  4 Sep 2026 05:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6226B0092; Fri,  4 Sep 2026 05:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB676B0095; Fri,  4 Sep 2026 05:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD666B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:46:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CECD9A357C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:46:15 +0000 (UTC)
X-FDA: 85175599110.27.1FDC75C
Received: from mta0.migadu.com (out-158.mta0.migadu.com [91.218.175.158])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF19320002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:46:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a58wWKwg;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788515174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CbnT+F0C1qqew6PZYkZby1F3LSjQu2CmBRPQtZ1JRkM=;
	b=i5GEghD6+Taj1EO158LD/7CKEmu/2N41SiBCZV9BCWI1JB5lQFc0CpHAukZJyN4tIgswLv
	u2j7Dc+Z8yyuF8dMOBeVBTZKS1SdH7+uEWL2cC7npimn4axbHhpHjaXBD66HngTRWE9eYd
	3rJDXjoxxyjX8GsWl0bYxEF+gX88/6Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a58wWKwg;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.158 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788515174;
	b=4qTW/VS88Wjp9dWcOeBgzdCKWk+Vw9bhmlQd9fwxXLvyRi4vy7TeAR2yfioRDsQxJ/plCO
	Q0nbxKFWutZ6qXyHhs0tURYjwNhlGpEOtRjeO2uGrR/EXQIcEmMvVJ2iAcM7oXrx8xDK52
	Z0w1IH3TB2/rN0JVl642bHVmfFRFfnk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l/Ow3opJmMzhmqvzKXqorsr7GYrL7d+S+qdRXbzW95c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788515172; v=1; x=1789119972;
 b=a58wWKwg8mGKUOXAGK3r67R8fcGl4gcyLW2rQhTxK7/SpiR9YtaInuDp8V6rpE+m/wKz+b19
 eaOWj3nsFVHJ+GyeB39dt18FJcyJJwCKDO66vuiK2xw3uAYuZPS9GOncohcIeeI0VgM699HJdsZ
 J+PwbVqiKrLRWL7sN0QjgFqo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5d1dfc6f5b4389c6;
	Fri, 04 Sep 2026 09:46:12 +0000
X-Mizu-Trace-ID: 5d1dfc6f5b4389c6
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
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
Subject: [PATCH v3 0/3] mm: workingset: fix the shadow node budget under MGLRU
Date: Fri,  4 Sep 2026 17:45:53 +0800
Message-ID: <cover.1788514750.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h7814mixxjmy4athpac8gjk4arhf9uuj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF19320002
X-Rspam-User: 
X-HE-Tag: 1788515173-635258
X-HE-Meta: U2FsdGVkX1+K5LydsMhtMh5hjKKJnNsJG5Ee0BlMlfqdSiMSUJ2SbAYUUWGWyJP2B8E9NOQPvB1H+DiAL/a5hzZCuRrZ0UD+nVRMX1LxLcgFVyUsi6PzpcXc5CDbYytF/Kcm1/9ADOkO6IL90KFvG+OL3LFQ7MQcIxJSd/7f/yweSef70q95x0+LY3XaAMYluSGglt8Q0RI6DjCgAzFIgBSjUKFHbpXeIIBFw/Vs0BV7MbPWCP+zwsT27hk8UwHfLPnXl9PuQuu9tOZ/YKeTm9kcA+2BGHHq9LikSIm64+gxlGJHmqPB82lnpCakq9ivcq2fFmW7exX7lSIvNi2srzCoq2FC5BPx0xvfA75D6ol9JzpxWf/pWtUSVPnMB8BmjIeF5D3QOEgUtmWwih8Y3zINY6ZfP1xJYXWAKdCM+b7BlvIgWFnD87upnTj2RGXEUPouVj97c1xlyRvyqAOaRN5n560F2HA03LiJkshNNhCx5y8juKvVbVzF4xEH0535vxbfZKbGHosoQY4UxtCi9fi4srtYd/VwqboUDOIriVELr/S0Gy8UFNVSxs0cfdi4nR+zSOFIaQPtw9b18knZb1/EzDl2kFgOvVPiIrivzaEW4kJ47G1s4wEvsi/nutHuuCu/a+tbSddIMcihEp9FRStGeYzQENtqLpzYQwW2MEVdAkExjL4GGpcKX9DRH3wq4QLr2zjuP7bT2qmceSbTHrmjocZc1juFSyGywB97OyqAhE6NY3xDPt1e/cwzHyL5nNVKUAGNw8wXh9RzLKw0vZsbqg9eUuUTPVbhggq7ltoVE2KIu/GuawxeMDC5DFoc3I2Q6LxBdsphqvzoVOCZWjVdTj5ExuUa8SBUx3DbrHtPGH9X6+oTt1nFMDaa1HlGUAEK1BkaoJOiJnSeMJWyoDYqiLQz0RnekzqbGCk1ssPrOa09xEmBwgTF5QLcvBy1UnNBnvWkQ9EyZFpyaA6
 9ve7IUY+
 PucI+FvHy8+pnqt6FaQTXM6fgoJf4MGJeM3xDxr2ETcF7bHTO1DSDEqikefUcaKLC2CsS8L1VWhjRfFbpAIzNSn+GecSgHklHtu/kKV33+szQHaYubksxT+2Z/s8UUeeQ7fU/WAKJQ8bTt6YyrWiTJ2VgbV1nsanzg0CaBGyedPOjvCAYYJt5G0C+V4TXEimsMSANKSLYpkJHgteTdriHCHwLkRlM/23MrgK41bO2h/U2dgdjmX8Y8Wq7sDbRNzRN0S2d
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

Changes since v2:
 - Reorder the series: the dying-memcg redirection now comes first and
   the switch back to lruvec_page_state_local() follows it, as
   requested.
 - Patch 1: add the Fixes and Cc stable tags and describe the
   user-visible impact of the bug, as requested.
 - Collect Shakeel's Acked-by.

Performance testing
===================

The test script and the raw results are available at [1].

Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
configuration, medians reported.  Workloads:

  w1-anon-churn: single-threaded anon fault/charge loop in a memcg
                 (MADV_DONTNEED + re-fault, no reclaim).  Every touch
                 is a real fault with charge and memcg stat updates,
                 so it stresses exactly the fast path patch 1 changes.
  w2-file-churn: file read loop under memory.high pressure
                 (reclaim-bound, noisier).
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
configurations.  The remaining differences are within run-to-run noise.

[1] https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a

Changelog:
v3:
According to the comments of Shakeel, reorder the series per review,
add Fixes/Cc stable and the user-visible impact to patch 1.

Hui Zhu (3):
  mm: memcg: redirect stats updates of dying memcgs for all hierarchies
  mm: workingset: use lruvec_page_state_local() to count lru pages
  mm: memcg: skip the RCU lock when the memcg is not dying

 mm/memcontrol.c | 30 ++++++++++++------------------
 mm/workingset.c |  5 ++---
 2 files changed, 14 insertions(+), 21 deletions(-)

-- 
2.53.0



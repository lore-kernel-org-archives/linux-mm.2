Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DD01C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC0A6B008C; Mon,  7 Sep 2026 23:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE086B0092; Mon,  7 Sep 2026 23:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0356B0093; Mon,  7 Sep 2026 23:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C094F6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:41:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A9528033A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:34 +0000 (UTC)
X-FDA: 85189195308.12.55B7E75
Received: from mta1.migadu.com (out-62.mta1.migadu.com [95.215.58.62])
	by imf29.hostedemail.com (Postfix) with ESMTP id A23A4120004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:41:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aPWfvkUy;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.62 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788838892;
	b=NzgWMIha36W7BD2gvj8QcURZnz9UNA8t4Ov32kXosDmPNsudZ0X36GsU29Lu7CNN3j+auo
	RlvxDMBjDOJFxlqQy+dyT4AU+0PQBAufqOvobY9cwIYPRzuUFxNDVjI9RpkEDfNHpJSYo+
	J3LIZ/rzVgb/amhmCma/Ooif+73K2bU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aPWfvkUy;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.62 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788838892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=INzK9uIckUJVIvDMjfQLRrGuPk7S+Ee2RpolHj9spmI=;
	b=CDAzSOPi8iIAD2ATuygB9OpCbw+ebbKHgg+BsUhhIC2br2pg2NUqnG3ZH2CL0LDdm6qtFR
	iKvKYvXYygiYMeq5RhFOsJlo9+K2BGiGD03XLNezW7pKx5RmJMNv/hwgiltTaIOePEeNLh
	UGFhknVVASNxiQca5wqqeIprU9BZNBs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nz77HtyT1E9SAWjePbr3tA2EChE5CYUU4QmxpcLu6z0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788838889; v=1; x=1789443689;
 b=aPWfvkUyXzY8VsxxwbswTIE7mQi0QqNICMmJpbd2tXskxvLDZKEOYQx3vgi5se5zLSKwuWmE
 jPGflZ0Aya0Eg3IzmXnW2TfS8dEpng4zMiT24uJurJO2O42/blZVzDhX5Zijq2p9LbneGDCHQLl
 9ccgDzalSG/ZZxcAalDMQPGo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 074fc28e9a8b36e4;
	Tue, 08 Sep 2026 03:41:29 +0000
X-Mizu-Trace-ID: 074fc28e9a8b36e4
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
Subject: [PATCH v4 0/4] mm: workingset: fix the shadow node budget under MGLRU
Date: Tue,  8 Sep 2026 11:41:10 +0800
Message-ID: <cover.1788837625.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A23A4120004
X-Stat-Signature: hfz79q4e3h5atxazuocnf8yzhpwpofbh
X-Rspam-User: 
X-HE-Tag: 1788838890-539887
X-HE-Meta: U2FsdGVkX19ELcPxwPVMmCwbvLM563gRXzu4Z3hs/04XOSjxAtQwaNz/oVSGDhz7f5gbDTm/NJlgMDV1eKcBIFpG5POvlucEP3XEX9ONNbGXs64Ablx4QQ23hO/sjQXLEoMCDxGL6wCHx3SYT/6vvBDcq4sDGBlQWXSj9HuggeDzzp17s06+1jUNoqIfsv1tD0bc89SMBhxsGrN+HVcFZd9T78lnFWOEJkT+SwnoNqMHsiIdErDZz41XN1bYtlCaLH1dpj+BMtRdAYl5ne7C0aRmbtaH1eAPVak0Frr77OfWt3qIn31sHB0BbYQ+VkOY5t6EAS+VX8hx7c96MGwemWwfcilpussbvMo4HA40GQy5llGtevhjhP42t0KJvEHkNLgVFpN2pvPTsbhhmYmRHSTUOVGaF/aoOb3GYBGpWRhZ8fv/yCLg+TTXYGDaHZ/WV4dZsklc8Gkj11vyErknlQscgZgS9ZAqiVYw+21Zxa5TpMSKK/uwSMEnyAitJKZR/eBPuFqYgWCPSGImXVWRhp8DH5RQweew1UWL8TiMdNsE0FyAM1AGs9HInSCr9eOQHGOSHik0sGW4XG1yJWpSHvqBS4EE8T7S3m5qG81BDB96vIUTk6Ab0jqjaAogdVsEhXwPErmvtku9ZvmO0h7B0ae7K9bNhrUK1h0hO8KpW0pz8Tgg+4YkTHDrX+1skiPrqRTYQ4RkiffCz1tzwwiOL5xCsNz/5etc8AaqM9dcnizOf73vzZg4pPVYyOqeA2hhHubJswPUJ35SMEVeRK4v9gfMcqsjkmLbplul+fvDovHpsdet1ZMeX9CXOLMPpEDvT1+SMZkwx+KjuRyDckUw7BLTbC9SayPtWD2/6VbwPGMs6y/mdfc7stSWoR6SgLdyOQP5AHFUpzkdc1haNI8jQtbO8jEf8Y+VGkLE1mKVCqwQPjxl/CVOz/nsALOL93rj6iL47eJ4rIxjCl4+hUM
 JrldISCz
 wd6fJKYEuv/40W/LBqJDHEnDF5yPO1j+SN/L/olQn3fx7VcCOuL3fTFC8k6Ft/v9RBOe8gjuemVffiKGNCk+AKW/HBYtO7R4t6S3A9c71s95iZDwCORex82zEy/2NBENSfHLf4n89B64RJqi4paCcPUj2FsRDrE334iUCLiJX04m0BcuMFCZv/+cG4o2DOUvmas5f9vmnArjJg6PHZrwC9c9j8w==
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
Patch 4 only touches the memcg offline path and is not exercised by
these workloads.

[1] https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a

Changelog:
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



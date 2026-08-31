Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AF56C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:46:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7A66B0088; Mon, 31 Aug 2026 05:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F506B0099; Mon, 31 Aug 2026 05:46:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE006B009B; Mon, 31 Aug 2026 05:46:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5A46B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:46:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1191F803DB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:37 +0000 (UTC)
X-FDA: 85161084834.20.668B748
Received: from mta0.migadu.com (out-157.mta0.migadu.com [91.218.175.157])
	by imf20.hostedemail.com (Postfix) with ESMTP id 284051C0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:46:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LVprdE3U;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788169595;
	b=3AWEv494omCunfAc7CfhFKWRD4vc3Dd3YAlEMrZYIilKBdyFdzkjeTqQDQaDc1hSWKqWVv
	+yankrVIfe8TRI/tYLlRQ3kRrF/VbXIFrnr/r9lj7VymjDIqDvjPFciMbSzwFg7cLsc/mZ
	PnpVKKAtFRE9wt/8ShZvbTdxfYH+lB0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788169595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SHTQh7YAxUXwUXiRr8/gStlx7ps1LpU+wTdJ7Z2vmco=;
	b=zsaJtAOp66OIo+iUOWCgkYIMFDRoWhs1Ry2NZ/eVKSR8A8BQCTrgDO2OdZOUDRavXRH0Mz
	RA+2JFLPrEOOrhgs9dB+E5/t6bF5M4/sBGN4uVIFn9UWoEnAd+mVF9D3qdAW/nP77UiaMN
	WPo/5TbhRCDt4/sLZXp9mQlIuadDccI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LVprdE3U;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.157 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AF4DD4VVRvODeKZk9FQinottqHGc5UMNhNCLJuS+ivE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788169592; v=1; x=1788774392;
 b=LVprdE3Ub8HO29yourlyTGlfgZbpOFAnHCkNfh7v77RZgWe+bRfXJGw8ujZhmy9rzG5HAduv
 4w1CWWR5yqy55Sqny5U3xmGEUxhKeY+NusZ3F73Tr7P3FHamp3KNBxfEEFr8lRa0OqMs+2BQOom
 3EhfzPJjhDd7GRJM71l4B7so=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 22025baba8b5f51b;
	Mon, 31 Aug 2026 09:46:32 +0000
X-Mizu-Trace-ID: 22025baba8b5f51b
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
Subject: [PATCH v2 0/3] mm: workingset: fix the shadow node budget under MGLRU
Date: Mon, 31 Aug 2026 17:46:08 +0800
Message-ID: <cover.1788169145.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 284051C0003
X-Stat-Signature: 79edna8dmu511c4f9dq6bzrrbzuh9etq
X-HE-Tag: 1788169594-928928
X-HE-Meta: U2FsdGVkX1/45z5RzoHoa20nTS7gYIkavZ9/9ueA0Iz+qBD9hhuaVG4zyWmzF6iPuMT+PjWLy05iGLzs1AYLijXlnk9BtdrIhVgUPZrn1TXcqK224+z6Y6SR8ueJx6mgwZd4TQ5RSbsR2m1XO2R8BuW1B1AQskS8n07qBbJuLpS5FlzlgczwipJqCvRjt9pHJ0LnRgPcosfFn8CdPyLfibi/AOb8J0qMc0rs9UQLD44r145qPIDKlQU1NkoK+hi0nTPtOA0TfHDnUN0ChWWrWJepjgXpv+sJcCuYE5Ha5wRXzwR5YOwyKrGM1P1kUypxfvPgIwt7WhT+KCKbLH9BLEfB1mWn54iAVP1t6nB/OjTkSEaSKqExfEjjKIXQULu9rwnq/A4VZz1Kan72tRy/D1ITSeGgKdLzau8hVMZSnN1hwRRiwqkYboMjjxYVU2x6+/dRAl73UUTjOC4NXFDgE6+9M0a921otcERZ/P5J3DwiMl3+aT78q8vlt7s6iRrN14tn3VsPkLsnAcKipR2kuUlxKHdNYjcbvq0Esz0fdRfniaPuAWy9aW67c+Q3fr9HH9KNoKzVDvrqq+7UCq16vvcSjT9VGl45SvSTZnnMMEtXkM2U/rpBscYVMVI3oMHGHpT+h74OoQDHYjyIPnfD0/8Yr/t96HwHGFIL9cjQbwDRBZiVRDKcwC4BBuqEYXkrK1CriQH9QQ0Yas01Hsw8qirLGgxfW8PP1ZhYuZ1Jd5P8674KgJ/AOzsfippgs5KHfdiSM2hfX4641/riB1H+B3uuRiT8agLrjwQY+2nnJlqr1Dlyco4R5IxvP+5wjJav2z6NlQwfxtlsps7t1d1sJROX47QcTg4EGQJb3fQIb+pHrJKtzWEd1oRIiqj1COyfxnily5QPdkJ4YD8nU4zQHUA9Rm1RjXHuTDB7ExOlSFSJQ81WuYdbDX8QFjvFVEuZKniF4vXArckBkrFmSqA
 pNVNYnuS
 ZxdtRVRWmY+E3p7O2qDGl63pWk/6qkkvnG36dKynt7NLSTYauRkKOZb//eO9Cu3YICOUAwUP1PmSObmq1Fzgkk6MWzgda6zdEmPUf3pCFPnmz+WqKI1RG+QG7qnC+8RUcK7Xxb8kauonXPhuM9ygvb/4idFvTHHPQ4wsSEl/B7TK3kqAGEcQVJK8flfe6BGjkul4WxFf7mFpU1enPUMKwIbLzkw==
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

Patch 1 switches count_shadow_nodes() back to lruvec_page_state_local(),
which both classic LRU and MGLRU maintain.

Patch 2 addresses the reparenting race that motivated 7404bd37cfbe:
patch 1 makes cgroup v2 read state_local as well, so extend the
dying-memcg stat redirection (previously cgroup v1 only) to all
hierarchies.

Patch 3 recovers the performance.  Patch 2 added an unconditional
rcu_read_lock() to the stat update fast path; patch 3 moves the dying
check out of the RCU read-side critical section so the lock is only
taken on the rare dying path.

Performance testing
===================

The test script and the raw results are available at [1].

Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
configuration, medians reported.  Workloads:

  w1-anon-churn: single-threaded anon fault/charge loop in a memcg
                 (MADV_DONTNEED + re-fault, no reclaim).  Every touch
                 is a real fault with charge and memcg stat updates,
                 so it stresses exactly the fast path patch 2 changes.
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

Patch 2 alone shows a small overhead, most visible under MGLRU (-0.6%
on w1); patch 3 brings w1 back to the base level in both LRU
configurations.  The remaining differences are within run-to-run
noise.

[1] https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a

Hui Zhu (3):
  mm: workingset: use lruvec_page_state_local() to count lru pages
  mm: memcg: redirect stats updates of dying memcgs for all hierarchies
  mm: memcg: skip the RCU lock when the memcg is not dying

 mm/memcontrol.c | 30 ++++++++++++------------------
 mm/workingset.c |  5 ++---
 2 files changed, 14 insertions(+), 21 deletions(-)

-- 
2.53.0



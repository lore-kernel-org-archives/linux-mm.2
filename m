Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C781C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 02:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4C36B008C; Wed, 19 Aug 2026 22:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36EFE6B0092; Wed, 19 Aug 2026 22:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E0E6B0095; Wed, 19 Aug 2026 22:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E42FD6B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:48:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5855C1C1A35
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:48:45 +0000 (UTC)
X-FDA: 85120115010.26.64C6C0A
Received: from mta0.migadu.com (out-235.mta0.migadu.com [91.218.175.235])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3FA9F140003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:48:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tGBAT/nE";
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787194123;
	b=co/Xp+W0rnA5wmW2MstZX/A2FClmZ2Cf2/k8/XmMNx0PJ9zWgM2ZXYyAvgEzX/bfSUyLAj
	Q3Q1aEBg2GwYy8VVWCmwbcZOzHCgknNelP7nShFUrGUNg8zLv4YKTTpZXYu1PJWSKAQurH
	LjYu9ttKdiX4AJDYYotGSyFPFdIvjeM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tGBAT/nE";
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.235 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787194123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3qJYuTFURBSBlhPX5iAyTaCCGZGyCF6nISsi0n0ER1A=;
	b=l44zw7AadijYSA0AIjzGxSI0BIpOsFt7X8k14S9jzl8t+VTcgopJ41NWqBe6Y8I3yt3wKC
	1glgMeSLKk+5AJmhW/dGAekNxNozB5Rmwb8qRI4Co6FbpONBGEEVqZPcFvHJoZS2x3XiS8
	XcnvTny/QUqlgSWKuRtbCUL1LXgP3V8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bKhUkXEqGv90J1vw0cE7EUs5ijqf/z30Rg7S8EZpNag=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787194121; v=1; x=1787798921;
 b=tGBAT/nEIh6cHBSLsxX8/HVhYjrvT5jfvQu5Dwc3B9iER037olyxiGyGepU0G7l6Uo2hPFQo
 aZT3GwbjVFe0TaR/INcyDBnKLUm3jm5kJjgLih0diQK07Lx589ifpbP5PT+cCT/UB5fxF88+7Zo
 zZYL/ajAuqN9ha9M2E1J6jVU=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 164f2e45294aaef1;
	Thu, 20 Aug 2026 02:48:41 +0000
X-Mizu-Trace-ID: 164f2e45294aaef1
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable v4 0/2] mm/vmscan: fix NR_ISOLATED accounting and throttling for MGLRU
Date: Thu, 20 Aug 2026 10:48:13 +0800
Message-ID: <cover.1787193916.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3FA9F140003
X-Stat-Signature: 4m4smkih81keg1fzxaxzaq83wdkjwsmt
X-HE-Tag: 1787194122-413559
X-HE-Meta: U2FsdGVkX18WhO5vl+e9ASJe0PWXfGUMnHokEiMgovAfhLpl+4IPTIpCFV4y1p681VpCj/H8N3ukb/uqNs4MNBWrVBKI/766QzaxXyAIb0hfCFi2W8eNHWvMBVGD40IqbTcfTYfqBvrpT7nZpFPvl6B1i0PgCa5I3zcn2ZDnZo707fwzlLsuitaWUmtZl3GxNY1WUEl5pG4QmpIbO8/kO+BKxFscYdiB2jBdg5j8GNg6ABqM5W5jIF1eD0bzgfm0UVTrkygjgeCYRAwdOCKH9bBBKIZGCazyStr6fQQchWidImnvD1iboiZBmRagInFNO/ym4moxKPGsnQwAmmXQ0tLsynF72mBaTBWUiVCWyDInr/nL4AhoYJXOPnMviu8qshQdhzzA/pW9Rm/LsqSgjPRb6HwwyD188wLEn5DAb/W6X3197+8TncLupt9RupRD9qDDiSgNqk0R+HrfymN/myjdoqUF5q/q5IyrHoTEFMfzA5pTMos564M84Bp+z4W8Uz6OtrqFDRltyllMWjfF9/mxbCBwARaxkDurnQ7YqnglUv/dCdHbdUrkvKYzcNJRVkMLlzrrR5gN0S3Z5+753Fx1hxCsJ/Lanc71l2y589wEAgvSS48Sdm+Vt+K95HN/EcaAaQ4g4bvNrO6j1ri+sxiMqRMhqy0c6NkcNDcHBjvP131eIx/FqpL6ufvW4lcMxxoENQch6Duyi17RjADVDvEaiZHYp0GnuloLjM/y3eF2JhCde2wfa0zvzNC+u0WAsZVSqh4RaJGKDtfBxA9ZY2inY6aZo7rs0y2KT4bMCR4kJi20vIuiOLIxyr8BSkmFVgy1BGTqD5KiAtpEkc9kRF4QF1LTbNOQrgLX5tHpYm+ZFh0Z7LVU36mCdYJvQJMf2NFUD6JnlFo+bYt3EgQ2tM6uJar2HT8ndEtaJ14uiWuw1zq461OtQeFEwNyycuvT3BR8p8Cv6iBV1V3fEqO
 VOEzxHb6
 mBPBvPUY0nIzR2i9lMAfuhK2LC03p+INo6BLZrJFpW2Ui7m1orHEYp/9iwX2kWipaTS77LySQqB2tVuHVPou8mh9lhPTT8P+3RA+O4NpKFEadbM0SLPuun8W+IMpSMTW0MQtb9+N35BqRsD7psm/0N/3Lch0Vvb0bfHcUIf9W+U8bIIfedq2q34aDwerzjFoFJGSQiJD9AzMJLwpIgGTr9D5oT3biRwAGeL+xDB8exTuWVxLr7Wr+i5spW+Q1kWxQmlhc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

The legacy reclaim path updates the NR_ISOLATED_ANON/FILE node
counters around isolation and throttles direct reclaimers via
too_many_isolated() when isolated folios pile up.  The MGLRU eviction
path does neither: evict_folios() isolates folios without touching
the counters and never consults too_many_isolated().

Patch 1 updates NR_ISOLATED_ANON/FILE around isolation in
evict_folios(), reusing the existing nr_isolated.  Without this the
counters stay at zero while MGLRU reclaim is active, so compaction's
too_many_isolated() cannot see the pages MGLRU has isolated.

Patch 2 adds throttle_evictable_types() and calls it from
evict_folios(), before the lruvec lock is taken since throttling
sleeps, leaving the legacy path untouched.  The MGLRU check differs
from the legacy per-list one in shrink_inactive_list() because
isolate_folios() picks the type to scan from the refault feedback
and may fall back to the other one: it computes the set of evictable
types that are not over-isolated and only sleeps when all of them
are, waiting once for concurrent reclaimers exactly like the legacy
path.  The mask of the remaining types is passed to isolate_folios(),
which restricts both its initial choice and its fallback to it, so
isolation never lands on an over-isolated type and a type that is
merely over-isolated never blocks the reclaim of the other one.
This way the MGLRU eviction path backs off when isolated folios pile
up instead of thrashing the shrinking LRU lists - the scenario the
too_many_isolated() check exists for.  A dying task fakes reclaim
progress exactly like the legacy path so it exits reclaim quickly.

Testing
=======

Test on 8G RAM qemu.
The reproducer confines stress-ng workers in a 192M memcg and swaps
through dm-delay (300ms write latency) so pageout is slow and isolated
folios pile up; the workload is intentionally extreme.  nr_isolated_*
is sampled every 50ms against the per-type too_many_isolated
threshold (inactive/8), and throttle events are counted via the
mm_vmscan_throttled tracepoint.
The test scripts and test log are in [1].

Test 1, reclaim throttling, parallel direct reclaim in the memcg:

                             before        after
throttle events (ISOLATED)        0            0
  - from kswapd                   0            0
nr_isolated_anon peak             0         3166
nr_isolated_file peak             0          174
  - samples above the
    too_many_isolated threshold  0/1088     89/1077
pgscan_direct            1540044096    858332151
pswpout                   6299497       725819

Without the series MGLRU reclaim spins on the shrinking LRU lists
while nr_isolated_* stays at 0 and nothing is throttled:
pgscan_direct runs to 1.5 billion and 6.3M pages are pushed through
the 300ms swap device, i.e. the memcg anon is recycled over and
over.  With the series the counters are updated and the
too_many_isolated threshold is crossed (89 of 1077 samples).  Only
anon is over-isolated in this workload, so the throttle never has
to sleep: it stops reclaimers from isolating more anon and has them
fall back to file instead (nr_isolated_file peaks at 174 instead of
0), and anon isolation stays around the threshold (peak 3166).
Scanning drops by ~45% and the swap-out storm by ~9x: the reclaimers
stop hammering the shrinking anon LRU while the slow swap device is
still writing out the previous batches.  kswapd stays exempt.

Test 2, counters visible to compaction, same pressure plus
compact_memory in parallel:

                             before        after
nr_isolated peak                456         2232

The "before" 456 is compaction's own transient isolation; reclaim's
isolation is invisible.  With patch 1 it becomes visible to
compaction's too_many_isolated().  (Compaction's own throttling
threshold, (inactive + active) / 16, is about 25k pages on this box
and needs more pile-up than the box can generate; test 1 shows the
same too_many_isolated() check firing on the reclaim side.)

[1] https://gist.github.com/teawater/d3968aac92eb6bd1378beb54a82933f4

Changelog:
v4:
According to the commens of Baolin and Barry, rework patch 2:
drop the throttle_is_throttled() helper extracted
from shrink_inactive_list() and leave the legacy path untouched.
The new MGLRU-only throttle_evictable_types() only sleeps when all
evictable types are over-isolated - v3 throttled as soon as any of
them was, which unnecessarily blocked the reclaim of the other type
and passes the mask of the remaining types to isolate_folios(),
which restricts both its initial choice and its fallback, so that
isolation never lands on a throttled type.  The v3 gate did not
constrain the type actually isolated, so the fallback could still
pick the over-isolated one.
Re-run the tests and update the test log.
v3:
According to the commens of Baolin, remove the redundant nr_isolated
check before restoring the NR_ISOLATED_* counters in evict_folios().
rename the extracted helper to throttle_is_throttled() to avoid
confusion with the existing wake_throttle_isolated() naming space.
Use for_each_evictable_type() in the MGLRU throttle to check each
evictable type's isolation instead of only the type returned by
get_type_to_scan(), since isolate_folios() may fall back to the
other type.
Re-run the tests and update the test log.
v2:
According to the commens of Kairun, Rebased on mm-unstable.
Split into two patches; patch 2 is new and adds the
too_many_isolated() throttling to the MGLRU eviction path, which v1
did not cover.
Add test infomations.

Hui Zhu (2):
  mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim
    path
  mm/vmscan: apply too_many_isolated() throttling to MGLRU eviction

 mm/vmscan.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 5 deletions(-)

-- 
2.53.0



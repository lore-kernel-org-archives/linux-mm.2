Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD9EC61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323326B00C6; Wed,  2 Sep 2026 05:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D31D6B00C7; Wed,  2 Sep 2026 05:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1E16B00C8; Wed,  2 Sep 2026 05:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5A9D6B00C6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:12:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 560431A0123
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:12:07 +0000 (UTC)
X-FDA: 85168255494.01.7FD1B2D
Received: from mta1.migadu.com (out-89.mta1.migadu.com [95.215.58.89])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4F5D64000D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:12:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pd3bDnjo;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788340325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HvgowtiWK1T3fUkc1MkUIit5mO9BNMQ6wPlaTtYXeAg=;
	b=vsEIpSXSts16zsqqalJsXfShxS5SgnC/7b0MsKi/nTAxibzCGVSh7claikdJdCIVU0w0xu
	R9vsZBKmUXNAJhMn2w0v51TsqG/lanxbok8QQm45NEFI5y25ajdyLklSudtYv40x3f4kJl
	JvasmedeqEAszVR6u34pGzQTxpXgIkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788340325;
	b=QQL0lBG7SBoWsIjPL1Zh93WZOc4yl+1UfvqwOmHQm17g3Xtkvwaot2KWgl/YDDhK1IH714
	Usx59FXAnb0S1YI+usTl9i8BrrxX8FQIcZRUwgRHe1Wjv6qp1LTyFthwk9Rbi0m92iOgR8
	4nEgVl0WnscXZ0QktnagSOy8Z0IProI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pd3bDnjo;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vjtUhJMEfixNV5GdVj21HxMSfKmeVVOYFnonEejTGgg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788340324; v=1; x=1788945124;
 b=Pd3bDnjo7AjK8iRCyRsHFqapX0RMm14z4eqMwouhvDL+64GJsZfXl/z6y5nsSAdgNz8NkwI9
 L1nL8ERqD2oMsHa16rYFj06cC5dI3f8mwJZ80vO4SjEKbGwY0xfYVMSF1OB3Gwku4cRSP4tnsDP
 QIJJJSN5gTIVE1HNvmOJWNPg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9dc51a52a9da3238;
	Wed, 02 Sep 2026 09:12:03 +0000
X-Mizu-Trace-ID: 9dc51a52a9da3238
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
Subject: [PATCH RESEND mm-stable v5 0/2] mm/vmscan: fix NR_ISOLATED accounting and throttle MGLRU eviction
Date: Wed,  2 Sep 2026 17:11:24 +0800
Message-ID: <cover.1788339549.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F5D64000D
X-Stat-Signature: w9zr3axaw8ttwkizwbhudzcn6rutttf5
X-HE-Tag: 1788340325-224323
X-HE-Meta: U2FsdGVkX1/xb/YmdvSRsbvD3O2MqYAMFSShQdu3sv4VezX0s7vzHmMk4EAbk0dU7p58Fx+0EUwNF8CcFRKdn1eUOlN6DcHXirwru5qM5XSh5NsvWNZplJ775jjq1WbdWw4NnnibIuL4M3AT6TYg90zmdTvHud63fiE42LZDcG0Iv1T7faXP5U2XYe9twmmmQNE8eREsWIOLhFp94wPsolQo5t7F09Mdimefb44nBRyqXIcYNfFscbom6zR+wzYGYH49+7/N4ChqItJGkUmBOfZaRhp8GDBhMFNcqQOWKv4y6JijXZbrNfHIF6FPWhlnv7P2GptHQJfvsVl6VY0JIbIPEZcHBBW1EGSMP+wAesFJAnKsEzPa5okyGgbABp4IVMbi0dIsXl6BYWhfPEIZKOvp8H/mYMYh1uUoy8zOe/YA2sI38v5i9giloqaypi/EHeeF1hb095raXiSwoxEc577xIa3IQr8gIM9MgEN0Fc8b44jcrYS+xTl55vBLY1r1KimZZNHdbF4C8obHNRflsq7PWC++It1Rm0myHIgaZGHScWFGf1CgRsS/xv8tHnij6dKchxvljnGZUP2ExA1WUYDazqQAW/r6t5LWgjSAor65ClrDUv/0H5d2vu4sLlImNbwL7UtLMdJkCWCVRrS5zPKseNkQLc4qjVSCGR5Q6UMPk4us4Fa1Xt216JfAWz9nwqCFdhoQvkRQ/a74KYNIWN+IujlmPDyDI6S10NZc8A6JRnQhCwI1RpbeJWSj3umM2BFD+lIPaDACK3QoeK5NAAS81889yuhsgKF6nHoB3fk7GO70ONmTQ+H/MpaANczIxgsFMKYV848Y1XQWcdLfNYN1ARUSvhaVGNJg0h/II0eNQYACk7pYVQ1XHgk/XXPq35LqW978C4GS0/A6B8hVPOmX5OrZYAKQOkk48/A8xwMOBEfs9COdtv/NCBI5fUeC4XBNknxmb0+0fzIyRmI
 LegrTVvq
 iBArdnuzRu2k55/dA+9o9uYQFu4ujCCTvEPW6i+vMTvLQzULGg8kC/MtGzukqukU6eKL94el9/OBWUleWW8UNRLL+imKoLMMNpoNcS6vP2sVsZDZBY21nO9syHO8CHimPaJJkt/QZUyWogFp+piVPAsUpEVhVFGRoUc0EyiI8fsYBlXVFMKWIsq3shjUSH7BEbyTJ8YrzSUG6iwwFlrVVp7ATS9QsTD1WJwneKslxj8NdiNF6QOmGl4JmyoOGAeXO+99q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Previously the patch was based on mm-unstable, which caused issues during
Sashiko apply.
So I rebased it onto mm-stable and resend.
Thanks Andrew for the heads-up.

The legacy reclaim path has two mechanisms around isolated folios that
MGLRU lacks:

1. NR_ISOLATED_ANON/FILE counters are updated when folios are isolated
   from the inactive lists. Compaction's too_many_isolated() relies on
   them to decide when to back off. The MGLRU reclaim path never
   updates them, so compaction cannot see MGLRU's in-flight isolation.

2. shrink_inactive_list() throttles direct reclaim via
   too_many_isolated() when isolated folios pile up. MGLRU's
   evict_folios() isolates folios without any such check, so many
   concurrent reclaimers can over-isolate the same (oldest) generation,
   leading to unnecessary swapping, thrashing and premature memcg OOM.

Patch 1 fixes the counter accounting in the MGLRU isolation path.
Patch 2 adds a per-lruvec throttle, mirroring the legacy behavior but
adapted to MGLRU's per-lruvec contention and its dynamic type
selection/fallback.

Testing
=======
Two test scripts are provided to reproduce the problem and validate
the fix. Both are available at:
https://gist.github.com/teawater/3ef51251f2e91a5a600e3d26bb477e34
Test environment: 10 CPU / 8GB QEMU guest, MGLRU enabled, a 16MB
memory cgroup, anonymous working set, swap backed by dm-delay (50ms
read/write delay) to slow swap-out and lengthen the isolation window.

mglru_iso_repro.sh (64 threads, 48MB working set, 60s):
Drives concurrent direct reclaim inside the memcg and measures scan
efficiency, throttle events, in-flight isolation and throughput.
Neither kernel OOMs at this concurrency; the value of the patch shows
in reclaim quality:
                        unpatched       patched
  OOM kills             0               0
  mm_vmscan_throttled   0               35645 (all
                                        VMSCAN_THROTTLE_ISOLATED)
  nr_isolated peak      0 (invisible)   230
  total touches         246,499,132,369 301,456,426,692
  scan efficiency       0.0261          0.0194

The patched kernel completes ~22% more work in the same 60s: the
throttle keeps concurrent reclaimers from trampling the same
generation, so less CPU is burned in reclaim. Note nr_isolated is
always 0 on the unpatched kernel - the over-isolation is invisible
there, which is exactly what patch 1 fixes.

mglru_iso_repro_v2.sh (192 threads, 48MB working set, 60s):
Raises concurrency to the point where over-isolation becomes fatal:
                        unpatched       patched
  OOM kills             1 (task killed) 0
  memcg oom events      51              0
  mm_vmscan_throttled   0               512292 (all
                                        VMSCAN_THROTTLE_ISOLATED)
  total touches         0 (killed)      682,300,003,972

With 192 threads the unpatched kernel cannot keep reclaim ahead of
allocation and the task is OOM-killed; the patched kernel survives the
full run and keeps reclaim making progress.

Changelog:
v5:
According to the comments of Kairun and feedback from the test scripts,
make the throttle check per lruvec (new nr_isolated counter) and skip
empty types in the allowed mask.
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
  mm/vmscan: throttle MGLRU eviction when isolated folios pile up

 include/linux/mmzone.h |   2 +
 mm/vmscan.c            | 173 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 162 insertions(+), 13 deletions(-)

-- 
2.53.0



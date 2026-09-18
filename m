Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6EBC88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3686B0099; Fri, 18 Sep 2026 04:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194286B009B; Fri, 18 Sep 2026 04:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D21E6B009D; Fri, 18 Sep 2026 04:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D04876B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:07:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1CEB81205C1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:07:43 +0000 (UTC)
X-FDA: 85226154006.24.C6337E9
Received: from mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
	by imf02.hostedemail.com (Postfix) with ESMTP id 44AA680002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:07:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fLKMwaM2;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789718861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CR3bafdCGqufTRFQvpqbfnC4WTTR3eKosEUB+VyPU/Q=;
	b=IXdDdf2Py+rfQfn98JBZVbYRKXpji5KGa49ipBJQm9MzSi3eZzYrkRFaVHXt1csagZFgtJ
	QR8IE8+0wen27pqjt2dN1kbwpKELQbOmY4C+rJb72g6P8Xu0QGBHCPZuj7ARobB80PkNQM
	AQIJKhperdOBp/RvCubNtfrRKIAwazg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fLKMwaM2;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.8 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789718861;
	b=aqkJxebGu7VTI2dTrwcUZYBM2W9naN6fuHfK6d5Rk08mK18ddZt4C1T5H2q3STczK0m3cF
	RJke8rYZ7UBGYF6rULZhBiajAAoLZhhpGshCyRuBjpS++3elfQze/MI3cFp7cpDlJi1d5Z
	cBuhANNuH7Kkf99Yv29vkuui+QEhIsA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E0Nmroful7jb3ppWghs4YpOSpLIFZgz+UAPsmrbruq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789718859; v=1; x=1790323659;
 b=fLKMwaM23PNgO1xMELdXzMdDD+TPIEVnTAK4etDczmiEQhaLnBMyFLJhyiXasyDiBVgFYNu/
 31XCXaaBREKTLIjB6skmhp++bMkEGOj0IS0gIGNPDrIktXyIC7kGnxTFXsTw94Ucue5hZZ3jbPH
 xt0t1onecmKE+pUrnHdoJUyA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 950ab51559f25ce3;
	Fri, 18 Sep 2026 08:07:39 +0000
X-Mizu-Trace-ID: 950ab51559f25ce3
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
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
Subject: [RFC PATCH RESEND v5 0/2] mm/vmscan: fix NR_ISOLATED accounting and throttle MGLRU eviction
Date: Fri, 18 Sep 2026 16:07:18 +0800
Message-ID: <cover.1789718658.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zi9m7gof6kictkucp5po33tfq3nuisgf
X-Rspamd-Queue-Id: 44AA680002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789718861-233345
X-HE-Meta: U2FsdGVkX1/g6nLRprvW25kh3mk/lyG8CfYrA1qm21g//iaCAMP3k/fsRl73G4iG4BPzH+R1GJcsrdDZF3jTB+6rTJMCvQKDvku4NgWIpvt8lyWllzy3D+9UWYOvMtSI/LKM5grX3TL/+yn6s3lHCJwoqT0hrNK4Cm4eybv9/8kcninCdvMlCjKmr8D8l8CoTSG+0G1D4Cym4rffAI8cGkBqbDxcP8sIKymtnHwXW7fSpzYZ0j+7+wJtZyNKX6Hy5WGn1w6lutZ9qufx7MWii8+Zj3uc+gKdg+VX5hnfaIFbmSFLGaR+x+nN8efKUVb3/Sotdy+1/P6ln8ZXFEEIfKs6rzaGryZpFwfYD35NXgKLPyUr1ZU3+owSutDFsE9+QlY09aZuhuMESIrTeYeLZXTJloFiABAJ9MHPTrhMtMJUGi/hnuIcerAY51aynextEH6q1GDi+qfHyQ23UCyHiwAF8kS2MNON29vzcDiYeVY75OY+2uK6IohrfiXT0R+NEy9xVfihgm98JnZmR2GtLAS5i6vSpqbmk7LcPjRYCkrg3sl/sBw/caShm8q6UD6sqfEX8LcWKNqmz/FpafYWOIe1NtEJMChbylTnGnuuQH/LQiW3jkNbzaMjQsrRRY9DA3bUDe4K0sLvddz+u3hSGBhBsTutrzf72mzRIVvS7edITT7vww0q/LYdsI2RPD2bG2PFKEJCaZJYQR9o+aqTdLlPLd5lZK8R6UoCbiMuSxw9jN28rS6ytQqOyh5JywbFtgC8CwqCws9Ui+xMRmTWU5GiTH9jpe0GXW3U5j6cqDG55NKutBHd7aTQO1DhvMmiSaUIxAL5Qf4zjhlZih/z9MeevYEpp5BEbUIb9Ci0lqtAST3Ry00XjPxLk0c2XOzqx4IeSmSyB7AdHK8QiCPvd3T6F6dilyM1svwKxznwq3ejrGcClxef7FSrKatNfJysFgyQvW88d/qI5Kr4TTJ
 2ysZYErs
 jKaSjVHjJ+igXdAERc5tl5/we1SB/OtwOPGui0p/Oavfi9A2L/FEWGnvh75bmHvm8J8xUH5g8sZI6A+f+KcHdsyYbA0TJvEWnvBV/OIvY5Oeu/TIXHOx7EsbmeaZvQ+3HctCPICoRMvRi3Ovdwz1fmzV6MEXj/62g70MW2Hxa2ccPbKUmZdPGLXC/gQ/4RtIzAkTfmi5wGtEW9GaDBI4roFO0MJZF0XGw/lD4t9S4t1OP4g+mNTUkXxRDgsKfK383IWmI
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
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71E2EC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80BC86B00B1; Tue,  1 Sep 2026 05:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2C26B00B4; Tue,  1 Sep 2026 05:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9DD6B00B7; Tue,  1 Sep 2026 05:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40E546B00B1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:12:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB3E81602D7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:12:54 +0000 (UTC)
X-FDA: 85164628668.11.1B3002B
Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	by imf13.hostedemail.com (Postfix) with ESMTP id C684B20007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:12:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w3P3R7xm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.251 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hs+gOGJmmkIpCAWNcnMw+iU58wyWYGqU54nHy7KfOo0=;
	b=Q+WtHw39+IAqpw+5vIeJcmIIVa96nc+5DO32Qw24GjjrunqB6qwTTu1k+YWC9yA66pZH3y
	/TU0tGU88dKdlB9qhSP0uZhbk2DX7xsjuKGp9jm3LrPOHc0KJylLHCjRJsj/+MnUA4ARFj
	5Zmko9enu+gMFciZlvrr5SeCH8Lsc4Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w3P3R7xm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.251 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253973;
	b=Tlx1UsiXnwXGzsY3rEMbifgbXITIzvNKIvGkJMW1yA3H+vm/EcxPFZSwQZL9/ZjWNsvKqo
	dKirR3/idu4BftFzo9vnT7bNbUan2eyR8Why2ZXQj6WOqalkJ+bUV4DyXALVqkX7B6CEzS
	vXM3GL76Z3EXcBC+jHI2KxIzSgFQxAE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ync3oaXQFeDmvdvInCFE69w3yCf9prxEpyRyz5+hcKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788253971; v=1; x=1788858771;
 b=w3P3R7xm7+VOapD1gXkPQzHXzMURGra/uOwTYFvK4GqslMsbdgo6bIv9hKMLS6uoToFK9lwM
 nyxMZbzRvYOjupitwPA2a+VwSseQmSuy50kPXz4DDDI7U7OZBhvckN2npFqT9aXHhigOyQrMM7K
 UzYeq1NnBOD0jz/FmGxvf7MY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fc9290d0f79b515b;
	Tue, 01 Sep 2026 09:12:51 +0000
X-Mizu-Trace-ID: fc9290d0f79b515b
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
Subject: [PATCH mm-unstable v5 0/2] mm/vmscan: fix NR_ISOLATED accounting and throttle MGLRU eviction
Date: Tue,  1 Sep 2026 17:12:17 +0800
Message-ID: <cover.1788252038.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C684B20007
X-Stat-Signature: xqo1ai94p4qn4oqpukqmdpkprn36mdxd
X-Rspam-User: 
X-HE-Tag: 1788253972-300056
X-HE-Meta: U2FsdGVkX1/j74V1Z+8y7nOBfmUPWsp2eMYGEegijZtqN4V5HeQbitzVE1kYiHortk8uTt5PiK33bemUkrwbTY9mbwuoJmT366ngSIUWzTbXb1AeM8wnrlyKNAntIGKimmCus2uKCptXqhZllKBDVXlFsxy4k5AAGmH0lMLvEkdJG0P+H4ZkJp0QHuN9V5H0zUKqfxytEneRnBbz6BN2ll9vgSHR8aWTQQtCD0AxSIkyie7CrhDLEdPqf+jEeRY7NPBrv7Fyvub5IiZAQ9Kyltdyengia6J+rrcoCHO0WeZd2LMRyRQlzz+CxzyxfQrK2u5bzrjE6+1SnR4GDXjWUnr4Rya9KS32S1oWn/ExmirNhrdmCoDGmMUAg3YRx03uq+HQpqgMDR34Jgc3doNSk3UE8T3hKKrX0wf94rMhS1rSs2Jfz2Nclp5l+fnOGv4NalMIXJVCeZb/wO7Im4xEE1FAIBPwaDPJlpperuUHm+cP7bohhzmvjMU4raMUEUEBS6AKm+FFtXOGpBEsKII6b+pPNNaNfVYKsRT0jCl9FG/DsvltowQjoAr3iSr5AidgngU0VB8ns6v4WG87+DjCLQIaacGjoD15aQy8jj6ZghZkhPbQZpEiaRWMnIei/69NsaL9LL/VLC75+GCkiLIlEJW7f9EsOLH1Az8iJlVfbKpiYkgjpqm4y0a48iUvQjQqCCLPSKX7nfEG/BiWX10bLqkGiPe6bG/0gJPphTLs0xjtFVI81NZEMf4x5PkfOOSFJtHvcjT6tMg+DshNfq4f9UhFIKL2Kvs0AQTzretNF6Rcot2s5Wn+MarzrsmQMD7kGAAH6iTEan7b4mEsgEP79JD2QPwb3or0C+Aih6gbmT7KsyWPdN7Q6H6dL8SNY143b4gKNqgr1otcw2ea+KXqOhrJpSlYUO2tc9DRrdpnq/biEUj1d7Fp1dxId8dZ7L3XZEehIGelyV5tZGeSFdY
 pP5p9kTh
 o4OIJsdDXbCe42O9jQjYO5gLrViCRxVc6dRHeBp3A1aMVXJ9HO31M1DdP0zNmMvwa4loSDG3Jlk4sLd868bBBqNQbvXwwjf7VLKzvW7dGj8m1ZaR3Yf/hHgTuDYWhxhCfPI1EpOkX19Mzh139FhUegGtaKuY8/Oumhh/N9kDkRO1wNT6ohtZAPIS3WZLIwu4FTKQTZtt6QBWAnRpDvjQJigOydnPl+O67oG+F8iZ4U7pV8W4nrgVXMNO9LxasKsEr/GDn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

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



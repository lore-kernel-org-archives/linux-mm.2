Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A5CDC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 12:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFEBF6B04A2; Tue, 18 Aug 2026 08:49:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5DA6B067B; Tue, 18 Aug 2026 08:49:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76D56B07CE; Tue, 18 Aug 2026 08:49:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B429E6B04A2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:49:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D7AEA0C40
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:49:48 +0000 (UTC)
X-FDA: 85114372056.26.4C95FD7
Received: from mta1.migadu.com (out-68.mta1.migadu.com [95.215.58.68])
	by imf18.hostedemail.com (Postfix) with ESMTP id 367581C0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:49:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JKqb5xpU;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787057386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i4YAClEIcR2spEyAsFXSw5ZoCKwmereFE3Rctzp9OEA=;
	b=YlPlkGduEzpITo+2dafbgnB3oQiLaFH9k/dFqXec5AgSOwz+U6iURaVvS7J1XzFYVcN7Ga
	peJg6tWE2BAKcC9SHY6MfUIwsdPDzIiPHj/mv76P+goughE0azuXknvWRj4QPwGEbDOmnU
	oQU4xUBMN45o5biua73hxlsw3oVWkXI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JKqb5xpU;
	spf=pass (imf18.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787057386;
	b=8JSvLmk8kQWhl3ymuDg8FDGlsgbT9SjxeAlTKOVYjVMU68pBWQdd7RCy5VDYwsPZ25fr/4
	XG5x3RckFbb09bLYNAoEbh/YEaI/50CYHIXwC8Bv4546bi2hySM9RgOqXV4O4iQciKaVZs
	x385n+JpbEKDTwM5vqIgRURTCzsbF94=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WrdvhNIs/76p08YQHs7pDu53eddRmYXbRgACIw7TFno=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787057384; v=1; x=1787662184;
 b=JKqb5xpUqvlRPvBzUTgb3XqpiZVsHR13/96vvAKKaLml6ujkCBBGX2ey2aAnooiPArkeWFAd
 XtY3xjkAHXdiAKJubyc+jD5Zur8yw4b3Qk1TVRMpkFF5L8mO8DA0ZIrKXXsvgXOITRdnj3uQGr9
 uORBvU//rUnTmPAiIcdZkQyU=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 0c819b097754d81c;
	Tue, 18 Aug 2026 12:49:34 +0000
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
Subject: [PATCH mm-unstable v3 0/2] mm/vmscan: fix NR_ISOLATED accounting and throttling for MGLRU
Date: Tue, 18 Aug 2026 20:48:55 +0800
Message-ID: <cover.1787056208.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 367581C0009
X-Stat-Signature: 8q7dsjnkwmbfh3phb8nrt9w8bpg4mpny
X-Rspam-User: 
X-HE-Tag: 1787057385-522770
X-HE-Meta: U2FsdGVkX1+c0Z52+658ZrfA9XBvhNpgeKNrg2xiYlajlzOJuyWcYXNkpYVW7SCzK8icUy8z8WJHpqGJo2AAYwGIYxf1u8hfScRr+ZZZjdRcwWYc0yscJMELuCum5G0Psk5DnkmAqDdfpcIf4BtOUFt4z/yXbBhNZsNhIgyJBDssWoOcmwHlNqOf2gwNHUssTD2pE4wo/Ntj9N3YhPQ+MOLuyzBWkCWMRwKV0ylcLLzL63XpEk4dMpg3cB3AjY8/bYmY1B8O+7GMxYg0FI50bwJQkrDzh7N5s/e45qRQofsavR5rQrTRD5P9dbOY9wadH+SA3FZsDhbIhvz6aBLF7SQuPomF6dKzgwHPbOgFVOz1KYD66ce7jxUXP1E1c9lpL9nWLgDGZC4KGKgcVaUZKgv5E5g6Uy7C1Ed8tq4nOkFFDtmdgJGIanQzCV2nOZsC/dXq99eEwn3M1Py6hw5qivNb7qdBWWO/7xOaUyLbh7g+eVUn/K+tO6O45FPuscmKFVKdrXFDQ28XBDhJyQAVaUXfHggJ2EuUtVAZRSDHf0Qs37qK9JJl7NxYXpT/ry1/hgY1DR/NVVeyFwgcMimBhQvTkqksbbDMeoGNsAkZfDBCnadmjflHVx5x1OYvQlDMiHipy8+Qjgti64mknYtexq6/FrXG8pwp8Xbo7tDvWoZWIu6eu6uP6VfCTdfrDd/99vHNtk0mvvZla/5Iy21g2xTWUKSlhRVARElXbRHZxAp2xQI2HjD0GSMEjSkQonjvu1KErR8V/Xi/HgPAyanGsFXPdLAQOkOK9enLcTHCoQ26hu6eKY1RnJBcvRdf2aZ5WD2YMJbFZw8569cyFuFJ9TMmY8DquPtDHrsPw9n7GtYYVYq8uhwd2pKF8wvCJXJF7ayFI3e7AmzR3rIpK3AUFG4EUYjhAmEPi3f5NkR4r//3IfPM/aFURL2sXgRR40me1LJSTvHNJn3UZwf8ZZx
 QMZ/aeoU
 BBNq0g6/ZTc4pkwU5J2wENslUpvttQg24bEO0aCrA3b8/jbgtc6tHGet7oLDIy/oXZyjMQCkdyhAiNmqcsQJsnrQJ7vH4txfzIV2RLA6bpBqiYyxnAqux8FxGHUGGE+jbUqGF1On11ibPnOzL8fiGu9dtHMem7cfKMEm5XIY8ImY8fOextJvfWwOpCjXPFA3is8s5kjCpgLa0ZXmepvpXiTMw2RP6xQEkYlE+uoCbsdF0YihKr5ktZ5QHytcDmygnFAvm
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

Patch 2 extracts the throttling loop from shrink_inactive_list() into
throttle_is_throttled() and calls it from evict_folios() as well, keeping
the two reclaim paths unified, in line with what was done previously
for writeback reclaim.  This way the MGLRU eviction path is throttled
when isolated folios pile up instead of thrashing the shrinking LRU
lists - the scenario the too_many_isolated() check exists for.  A
dying task fakes reclaim progress exactly like the legacy path so it
exits reclaim quickly.

Testing
=======

Test on 8G RAM qemu.
The reproducer confines stress-ng workers in a 192M memcg and swaps
through dm-delay (300ms write latency) so pageout is slow and isolated
folios pile up; the workload is intentionally extreme to force the
throttle path.
Throttle events are counted via the mm_vmscan_throttled tracepoint.
The test scripts and test log is in [1].

Test 1, reclaim throttling, parallel direct reclaim in the memcg:

                             before        after
throttle events (ISOLATED)       0       512488
  - from kswapd                  0            0
nr_isolated_anon peak            0         1450
  - samples above the
    too_many_isolated threshold  0/1086    293/1057
pgscan_direct            1253539938    148299282
pswpout                   3383673      6502879

Without the series MGLRU reclaim spins on the shrinking LRU lists
while nr_isolated_* stays at 0 and nothing is throttled: pgscan_direct
runs to 1.25 billion with only 3.3M pages swapped out.  With the
series the counters are updated, isolated folios cross the
too_many_isolated threshold (293 of 1057 samples) and direct
reclaimers are throttled; scanning drops by an order of magnitude
while pswpout goes up, i.e. the reclaimers back off and let the slow
swap device finish writing out the isolated folios instead of
thrashing.  kswapd stays exempt.

Test 2, counters visible to compaction, same pressure plus
compact_memory in parallel:

                             before        after
nr_isolated peak                59         2271

The "before" 59 is compaction's own transient isolation; reclaim's
isolation is invisible.  With patch 1 it becomes visible to
compaction's too_many_isolated().  (Compaction's own throttling
threshold, (inactive + active) / 16, is ~23k pages on this box and
needs more pile-up than the box can generate; test 1 exercises the
same throttling mechanism end to end on the reclaim side.)

[1] https://gist.github.com/teawater/d3968aac92eb6bd1378beb54a82933f4

Changelog:
v3:
Accoding to the commens of Baolin, remove the redundant nr_isolated
check before restoring the NR_ISOLATED_* counters in evict_folios().
rename the extracted helper to throttle_is_throttled() to avoid
confusion with the existing wake_throttle_isolated() naming space.
Use for_each_evictable_type() in the MGLRU throttle to check each
evictable type's isolation instead of only the type returned by
get_type_to_scan(), since isolate_folios() may fall back to the
other type.
Re-run the tests and update the test log.
v2:
Accoding to the commens of Kairun, Rebased on mm-unstable.
Split into two patches; patch 2 is new and adds the
too_many_isolated() throttling to the MGLRU eviction path, which v1
did not cover.
Add test infomations.

Hui Zhu (2):
  mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim
    path
  mm/vmscan: apply too_many_isolated() throttling to MGLRU eviction

 mm/vmscan.c | 76 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 12 deletions(-)

-- 
2.53.0



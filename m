Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13DDC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D8C6B0093; Mon, 17 Aug 2026 03:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04C46B0096; Mon, 17 Aug 2026 03:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42746B0098; Mon, 17 Aug 2026 03:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B4D506B0093
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:11:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B3C21206E2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:11:45 +0000 (UTC)
X-FDA: 85109891370.11.E96AD8C
Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 72FA11C0007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:11:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sobgg+Ef;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786950703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A7E5MNh9u1nwfx2jSc4rNB6T/TE8YoicrvQOjyysAvQ=;
	b=MyEq83HCpgrvz0s2+WVMkwpSFcl7KemeoMdP7BSCvMxsM37B4dnaTN1KtLCeAWzojGOom2
	b3KfN+/TTXq2JYte28UnSh5IuMlZF2xmXoPCYYSTDhytydbi9heBXqeOMgQDIcle6dtKJb
	Ql3oU2gFH5zvZDCGIluxPJIg0NakoGU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sobgg+Ef;
	spf=pass (imf21.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786950703;
	b=fGTzARF7ox00br/Lnl1vqiqWNMVCGQSByCqz8B+IBf3pPD4USiYDNMhdAwHsf7joforbj1
	e9XX5L9ZrMQFy03g/CZjPT/IPYQfnd2xNw5OT7W3ggI3NCT3CuM3QKxcv0q0WTcX/54gE5
	QV5Jb+mmZiXfTY/ZPrJ86WCenuDmzTU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fD49dsTg8jKka6RcPvdvEUs8O3U0mhIuolE9NHAVDZ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786950700; v=1; x=1787555500;
 b=Sobgg+EfinEhe27Skx7s7Ptq75J1IcSxpx3dyO2GbHaoiNuLnXznByHpQda28B2sAeWNNcLI
 Sz4oTRuy5GyIKBMZyJANLbLgW9hxL2N9QmOHEjUFoQtchs4v6sKeBMKNbl5W5pQrcmACRoM82f/
 KMkusgGvkxjWwIbldaZd+mCM=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 8808c3c6d6410fc6;
	Mon, 17 Aug 2026 07:11:30 +0000
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable v2 0/2] mm/vmscan: fix NR_ISOLATED accounting and throttling for MGLRU
Date: Mon, 17 Aug 2026 15:11:17 +0800
Message-ID: <cover.1786950138.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1a8bn5ahskyqcjtde5ibwr9jz8wjwrgz
X-Rspamd-Queue-Id: 72FA11C0007
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786950703-112666
X-HE-Meta: U2FsdGVkX18gei1a690kCXGxJj4TheNE4fkskWc00692GlrabtBtZpXj/d+uBsinCO5c148iMvIdQro65uZiJ+BSqykFoD939P80gCaW2mRzk/y2v8Nyyy2i3sBW+MocyHh+v4+09Hgi7VcVBP+sHMuL//v1gTBdHuoVLkSh9z2GqyTqnzsM3lwn19v9Wr7oEmNteMSwZCa/CCmwVHg+xSbCpsuxxcASidRkvrFB9fnXC5aw6EzGtLz68VVMTGrYoIB/6SxZiy4YUoVGM/p3QEgCvvptyWE0n/l2kJ3qBxvtPMID+70p4n40dpxrCpLeGX4a74TaYDxyJGjv3LDK3cBwFZHTkFEiAd9rLVve9wZyMeLqlpXfI5s6LJnrvuX0qhDtDE4/G9W7sRAhUYYQuKzReSJoJJBW6ianKEwyM4SRanUd1GEKFkbzu/zm52u0peOMwkx8986HazJeN6wuETJ/g69BRpCBKv3OYRPaCZkSXhqxcA7fS3Ma6jsOEwdn0kUuPXBRfDXzGJYKV7PNXxaO4Vnb1pyBOa21RiyYEuvp5zNBw79fxyb5pTObJN8bbhYblvmesszlYAmaiDVsODgC6KiOcpOtIllsjgk8r9SYWvl9I7SszftljDu4dsOTEYXjTJxmJrtVNQ41bmA5tc32kICWpYZzBaWfcnmGusk3llNjHsVKHDDDwtyujaA8NqndjD2hW54v02i6c1yE4xUPdmWg6QaXKjRi9hhnr+HejdB7wejuXg/cRgDfDisHq21ZfjhZWfv44wyYgYqG60+eXKb+WBwxMZLLeOlviFO3y7cNcTC9n4omLOQXFNQUNEoWKKGiDTkC0LnAyxQH8ipWAd7veVxlbYBN8I0/GptKgP5o129RU25dbVnJ0R2pE4pdtE+i2Bk/JyE9qScHcGh0cTkIoRQMMmJXIMUSrd9K6Z7wOBaPU9i7HvFA3hSAv8KdjT9UJR5fhd6g/yz
 OzU5AVbW
 Q/KftOibKe+v7edUrqoKl7gRbjBHEkGHBoWwSa1RTJZBNjC+0ggLi0HpB2oUtVpuxAVMB52rkGI12lQQuEm4auWl9mtcz1Sae6yys3RhqTx7xGMua+j7Dc3ZpJnd3FM2OKQAEeYXaygYsvgdTynAMUNl1YPsyghljmvCfhuQUe7JR0UomfGoDolJ/2yncog3RP9bWEk9t26ktVNsIu9y1YOufZVRhaBrepsuFgnLYGvAjBMm5v49QYJ8TAeZu9qZ4SEoy
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
throttle_isolated() and calls it from evict_folios() as well, keeping
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
throttle events (ISOLATED)       0       512472
  - from kswapd                  0            0
nr_isolated_anon peak            0         3670
pswpout                    3383673        87134

Without the series MGLRU reclaim swaps heavily while nr_isolated_*
stays at 0 and nothing is throttled.  With the series the counters
are updated and direct reclaimers are throttled (the pswpout drop is
the reclaimers backing off); kswapd stays exempt.

Test 2, counters visible to compaction, same pressure plus
compact_memory in parallel:

                            before        after
nr_isolated peak                59         1093

The "before" 59 is compaction's own transient isolation; reclaim's
isolation is invisible.  With patch 1 it becomes visible to
compaction's too_many_isolated().  (Compaction's own throttling
threshold, (inactive + active) / 16, is ~23k pages on this box and
needs more pile-up than the box can generate; test 1 exercises the
same throttling mechanism end to end on the reclaim side.)

[1] https://gist.github.com/teawater/d3968aac92eb6bd1378beb54a82933f4

Changelog:
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

 mm/vmscan.c | 74 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 63 insertions(+), 11 deletions(-)

-- 
2.53.0



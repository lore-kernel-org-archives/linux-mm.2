Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFABF60A261E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UxXWpp96
Received: by kanga.kvack.org (Postfix)
	id B1FBB6B05B2; Tue, 10 Nov 2026 15:20:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1066B05B3; Tue, 10 Nov 2026 15:20:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B78E6B05B4; Tue, 10 Nov 2026 15:20:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 708586B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:20:45 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B0FEA0B0A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:39 +0000 (UTC)
X-FDA: 85420327398.30.FC2F140
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5E25680006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxXWpp96;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HGHMI3Nx0h6Lh52y7eI24JzQXy85XaR4p0stT74UYFg=;
	b=ZZ9dQzVBqFcYmYVJZJj3JM2f69hUyzbu2I3Mzif98a2jPZTN/x7EXF4hNEi83vTDdC+L4L
	DWYc5DLK0db28vAOAPqhtem+lPbE1PzMupl2Ks2fWulD5ZIwYjx9Qfh/hj1cbchNXxHoiY
	mDx750nxbwo2De1pNZeAyLBQOGvp79s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UxXWpp96;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342037;
	b=nuUttU6/HnMd3rQ5VRXO1pSZ+k4GKpUXySoOLSGTRjnOf2BdvSmLzluax2vu9KvvaMM6JU
	X5yYyj6HSVZj3yIAPffrbKq+9rD0X2oVSppc7qZxCSch6v0zaU2cUXm2XwviGaImNj3BpK
	exo2JCxAgbMg8DqPhJ99PPl7wkQx7vw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A7612469CD;
	Tue, 10 Nov 2026 20:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3EB1F008A1;
	Tue, 10 Nov 2026 20:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342035;
	bh=HGHMI3Nx0h6Lh52y7eI24JzQXy85XaR4p0stT74UYFg=;
	h=From:To:Cc:Subject:Date;
	b=UxXWpp966az3XWO29pH4Q+roZVRThHYA2/Tao0GwSWbdkwc7/jL9Da3aUVo58Y0B4
	 p7e0X992VeUGG+M2yTD57RquvLM64rnIehDRy6C39oQ58adZ/Z1DxlBodlTj1oOoG8
	 KNFAj78s4zYYB3h5elSxcxgDwpQ4Rr7dL/magEz2khgzZnMRfC3ppsszOaz2GCgOKF
	 UDKByDz5nY5rD+gWeswqcMx0J40It4c24YSgHbZdGIQ70niQD7NKfuYKq5LbEMUq/C
	 J6IOswUSEvHe1hP3sm+yvCt5HZZex6vsFcyCsdn/3n383IaTezsRjkUBr/hVqsKYlC
	 RZog/9eV1umWg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v6 00/15] mm: mglru: fix swappiness behavior
Date: Wed, 11 Nov 2026 04:20:10 +0800
Message-Id: <20261110202025.25736-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5E25680006
X-Stat-Signature: wnd7rzbqzh11ysu51rxqctzqfjtshiie
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794342037-577220
X-HE-Meta: U2FsdGVkX19lLSe8F578WUsQF9z6ZZZDK4SbYPs4ov/PUMqRLL7N/MmOJNBWgCAMF2gcZNZQvQ2fEvqjnBRuKdQxpYPrIJkEaWtX+cndtfhCSavCl1PkKm0a+/u4Lm+QbtkR3HBqX8ju/fHBgcpaEtQi7OblRNMP9MsHQ8tLKIk8sCaCNXzepIL68i3V95REeTwRmOcH4ualef0G5aKfzekDYvh7bIuKHZDZ7dOsCJ6PMcnNOfcyy43xRVine9ec03kjGB6/rD1yrfKQHYgeHbLSOLuHXWIC7fEpS01hyyzk0LpDink3vnBHcy5p0DotonYMOR3bxK8IBsYA9M098wBKTwnNY4iTyWA9v8V04xot7aYwID11N1oU8QXY1TnttNbJW0K+3QaxOlTrr2GWmgf9YquKv1HVASZkVjeBSQ79GFY/dGaz1tBZWVsFlTiANnIxCf8PRyAFp3XodAVNYx1JTUSVGmr1LI0XAEzKNHik6q/N2ewUv6XPq8cGfiZLk0Pz0/FZsGRBSSHT+6/mN024uKgv/WgL6cgwVk0jwrr7EEziaAt5bwdfXsDBBTk4LHpnSgo6PG9SJ43WqWgMY8JuWj8p0zrUsmNsM5h3TkRAF+8WMMvc8+jERQJ+X9Jf4vamzua8V816ToSIgRG8IPeCBeTGC6C+i+7ZDkPeSrAZcwPyas4XUl3JbbYVtmh6LIj/04bioVgt4lSXxgavhqC8unp2EP1NS+EH+KSB10ORDnIsKrmwK7H02iSSTCxvYyga9vf127gVc96T+YfCgK9ILQfRAiWGOAAtHVOskJDJjjbvfniKr6kRyhfaWetOvoeNsaQqDESTBtXH3aKzygmRDJCvTcaTj735lmWDgZqsSja2aWtfEfuW00Fadthl+m5wLBejV+Lw9OksLpSgwky60eyiH9i9hVR7e9wFQBNx5x9bomS0O0dp2TQmQ+l+JI1zkh0ILxm3oEEd476
 dCtBhqIT
 P+sojO3O6qz59N+XCN+iBbyL6VpxPlT774NuHIkj4BBw8KCXI6fGhDmpLUCjRtRRo2bURyIpnHX1M+QDGPhm8UO1wQlm8hP35phDrjfpDMu9biASuVZsGcgGH7J8VGl2EZuRf+8+5kSmdRX0IuRKDnNgybSEj58QIeG7IQW8zTFD162S/pFZj089UbyIh7FyNjvAj10ip47yTOGHUc8wfEfwaaJah+7EpUyv5J/Uf5GLUlNM6T5YhBVgWiczjn0d3/szxueJFqB1HeBUJgsLoh7VyRka7/cK7QpnuUQ+8jVFFMecAMeUm/268Cc8MgaA0Q/wQ3iHIVjb5jh00UUKFGyuqvomMW9qRqDkFMiVaVPkdgLOYV4PeUtRAbWyBZVJVPPXkTrMRVocEUPjeS4eztPKbBNZeiZ5YX3im1HkalFrfm4s6FGenkK0jWGGXrjfgUT45
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Classic LRU respects swappiness, while MGLRU only weakly
honors it when selecting the scan type. The fallback logic
can easily override the bias established by
get_type_to_scan(). As a result, swappiness has a much
smaller overall impact when changing from 1 to 200, as
shown by the data presented later in this cover letter.

In this patchset, patches 1-8 from Kairui introduce a model that uses
refaults to determine nr_to_scan[] for both file and anon in MGLRU.
For each reclaim operation, we calculate how many file and anon
folios to scan, similar to CLRU, rather than relying on
get_type_to_scan() and fallback mechanisms to decide what to
reclaim, which have proven rather unreliable in honoring swappiness.
This model also allows scanning and reclaiming from the two youngest
generations, including the youngest generation itself. This can help
resolve OOM situations[1] and reduce the need for aging.

As Kairui mentioned, the OOM reproducer was demonstrated
previously [2], and that series was merged in v7 [3].

The problem was largely alleviated as described, but not
completely fixed. Under higher memory pressure, the system
could still hit OOM. Before this series, Kairui could still
reproduce OOM after hundreds of iterations. With the fixing
patch in this series applied, the problem no longer occurs.

Patch 9 from Barry fixes a cold/hot inversion exacerbated by patches
1–8 (which also exists in mainline) and improves reclaim efficiency.

Patches 10-14 from Gaofei and Barry optimize aging based on folio
distribution imbalance and improve reclaim behavior at extreme
swappiness values such as 1 and 200.

Patch 15 from Bo Zhang addresses the GFP_NOIO issue in MGLRU.
After the patchset, the results track CLRU across the full swappiness
range (see table below), with more file scanning at low swappiness
and more anon scanning at high swappiness.

After the patchset, the results track CLRU across the full swappiness
range (see table below), with more file scanning at low swappiness
and more anon scanning at high swappiness.

pgsteal_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            6,620,680     745,968       7,200,993
36           807,807       508,974       536,154
71           553,144       417,700       430,877
106          402,880       402,474       360,526
141          240,293       337,797       305,636
176          187,682       330,045       229,553
200          0             343,949       0

pgsteal_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            4,436,199     2,671,934     5,362,520
36           2,858,117     3,032,747     2,743,947
71           3,042,392     2,827,735     3,204,163
106          3,292,622     3,184,314     3,150,825
141          3,612,869     2,999,000     3,489,850
176          3,827,154     3,134,127     3,708,769
200          13,825,283    3,269,753     14,403,938

pgscan_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            11,853,625    877,311       14,766,000
36           1,016,826     582,783       617,127
71           662,823       474,772       478,840
106          496,374       451,285       377,093
141          277,109       382,604       322,931
176          206,261       372,059       233,651
200          0             393,608       0

pgscan_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            20,804,386    5,847,747     7,501,764
36           17,830,330    6,740,075     6,197,057
71           18,357,293    6,126,194     7,074,152
106          19,938,920    6,431,355     7,555,448
141          19,609,579    5,997,762     9,211,098
176          21,612,749    6,071,032     11,058,694
200          44,776,474    6,544,125     29,993,141

refault_file
swappiness   CLRU          MGLRU         MGLRU+patches
1            6,523,070     667,302       7,122,634
36           722,110       431,585       459,100
71           477,062       340,241       352,834
106          327,610       324,747       283,673
141          161,827       265,959       230,350
176          115,551       258,515       162,880
200          0             268,049       0

refault_anon
swappiness   CLRU          MGLRU         MGLRU+patches
1            867,728       552,829       1,408,397
36           419,635       657,745       555,600
71           536,299       611,345       701,640
106          580,742       693,689       692,630
141          706,151       639,850       817,103
176          706,499       685,086       893,704
200          4,693,850     733,273       5,462,849

With a normal swappiness setting (without extreme bias), I
see almost no noticeable performance difference between
the two versions.
For example, with `swappiness=60`, the average results
over 5 rounds are:

metric          W/o patch     W/ patch
real            1m49.273s     1m49.269s
user            25m33.186s    25m33.695s
sys             3m41.851s     3m40.779s

[1] https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure
[2] https://lore.kernel.org/all/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/
[3] https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/

v6:
* rebase on top of mm-new(a lot of conflicts due to recent active mglru
  developments);
* only count eligible zones below sc->reclaim_idx for
  lruvec_evictable_size() and lru_gen_imbalanced();
* GFP_NOIO further fixing by Bo Zhang, exclude unreclaimable type
  in lruvec_evictable_size().
* Add Kunwu's reviewed-by, thanks!
* RFC v5 link:
 https://lore.kernel.org/linux-mm/20261022220203.91911-1-baohua@kernel.org/
RFC v5:
* Remove the aging optimizations, which have been merged - thanks for Baolin,
  Baoqun, Lian Wang, Kairui, Kunwu, Ridong reviewing on this;
* Add Kairui's model for determining nr_to_scan[] for both types.
* Fix cold/hot inversion for rejected folios - Barry.
* Improve and clean up imbalanced aging, and optimize extreme
  swappiness values of 1 and 200 - Gaofei, Barry.
* Address the GFP_NOIO issue in MGLRU - Bo Zhang.
* RFC v4 link:
 https://lore.kernel.org/linux-mm/20260812121658.69965-1-baohua@kernel.org/
RFC v4:
* Clean up isolate_folios() based on Baolin's feedback. Thanks!
* Further improve isolate_folios() and scan_folios(), including
  handling of exhausted reclaim types.
* Add fixes and performance improvements to inc_min_seq(),
  and reduce lock contention.
* Improve the handling of imbalanced aging and remaining
  generation-based aging.
*  RFC v3 link:
 https://lore.kernel.org/linux-mm/20260731083843.37811-1-baohua@kernel.org/
RFC v3:
 - Added Ridong's patch of improving isolate_folios() readability;
 - for lru_gen_imbalanced(), apply some suggestions from Zicheng
   and Kairui, considering lruvec size and use macro;
 - drop "mm: mglru: only fall back when reclaim is running at high
   priority"
 - mitigate aging for balanced swappiess value(near middle 100)
   as swappiness bias is less a concern for them; but slightly
   increased aging overhead might not be good.
 *  RFC v2 link:
   https://lore.kernel.org/linux-mm/20260726122123.7614-1-baohua@kernel.org/
RFC v2:
 - Quickly address a few issues raised in the Sashiko comments so
   reviewers can ignore v1 and review a cleaner version instead.
   https://sashiko.dev/#/patchset/20260726012946.18684-1-baohua@kernel.org
   Thanks, Sashiko!

Barry Song (Xiaomi) (4):
  mm/mglru: Avoid placing rejected folios below populated gen
  mm/mglru: Restrict eviction accounting to eligible zones
  mm/mglru: Reduce LRU lock contention by shrinking folio batches in
    inc_min_seq
  mm/mglru: Make swappiness=1 file reclaim more aggressive

Bo Zhang (1):
  mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO
    allocation

Kairui Song (8):
  mm/mglru: report evictable sizes per type
  mm/mglru: extract lruvec_populated_min_seq() helper
  mm/mglru: reclaim from the oldest populated gen
  mm/mglru: lift the forced protection of reclaimer
  mm/mglru: skip zones above reclaim_idx instead of rotating them
  mm/mglru: return for unavailable anon reclaim earlier
  mm/mglru: balance anon and file scan budget by refault rate
  mm/mglru: lift youngest gen protection for higher priority

lyugaofei (2):
  mm/mglru: Run aging when pages are rare outside the youngest gen
  mm/mglru: Avoid prolonged anon reclaim with swappiness=200

 include/linux/mm_inline.h |  22 +-
 mm/trace_vmscan.h         |   4 +-
 mm/vmscan.c               | 472 +++++++++++++++++++++++++-------------
 mm/vmscan.h               |   5 +-
 4 files changed, 334 insertions(+), 169 deletions(-)

-- 
2.34.1



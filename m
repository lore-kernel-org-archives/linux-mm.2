Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29275606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DOlnrJEN
Received: by kanga.kvack.org (Postfix)
	id 37CA16B05D4; Sat, 14 Nov 2026 15:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306F36B05D5; Sat, 14 Nov 2026 15:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CEB26B05D6; Sat, 14 Nov 2026 15:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E11B06B05D4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:08:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6388E4010D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:16 +0000 (UTC)
X-FDA: 85434811392.21.E6BF483
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B7CB520003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:08:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DOlnrJEN;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3I9GMuQ4koTWMmC1a0y1hzNB/jsgqGShcvnACFMvVh8=;
	b=fd4QY0LmDGYngOvBrs80Byy4PCEWHkHRcwlACqWxvB9gZPs2i1Yc/vwbTOUWCVrgPMCg1Y
	35xAvldXnsxGDjjgs9AoDgsfY6wbzXaf7MGLZK/E0W2LLzCLlRrusn1z1tqXCJJxlCtKzT
	+Jua2pjuMDN7CQoFpGsBcHR/x4tiSAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686894;
	b=8WhqhIg23DwOn9CUJ6Ga+56p3Fo5yDD2txLVhKcQyNEiQa++tsWabym2HwaK16B04+QH3W
	i2ABayrWS/Ml4IH8pKFgD3ZDRint/6vvfsbiA2iUr7EnhLHhHUr5sK2KSZQKI4PDYmx+uM
	SQO56oe7/hQX+jMUMqFs0+LhFMd7zZs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DOlnrJEN;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4461041661;
	Sat, 14 Nov 2026 20:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FABF1F000C4;
	Sat, 14 Nov 2026 20:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686893;
	bh=3I9GMuQ4koTWMmC1a0y1hzNB/jsgqGShcvnACFMvVh8=;
	h=From:To:Cc:Subject:Date;
	b=DOlnrJENwYVKGy6yIHLGDukT26XNSSkFjZ7D+ZPqsV5kMyqCjb3gi6widIknUAyym
	 Zfh+vTzcHHENkjdhyzZN1TT5g0SQaR/fBrvfwbuCIARF8mhRwLljRPXarUI/nVPAk7
	 h2aaFPsCqalyi0S5XrY+yzqIvmcmGy6T3LSdvvML8FVOCp6eb0V1w73lSCUieXuhQq
	 EJlrdt5k8FPb+J5o4UL0QjIbOnxo2erPTOollaIcTq8kIr1WWQUPPUV0ngdoX9fJEq
	 o6wGf05+hGXvqaj1T6RTacNC6ax6WLZHwE1KIkJZcpunp+PXnen+hRrNDm5h1qUtU6
	 MmEKVIcrg5F/g==
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
Subject: [PATCH v9 00/16] mm: mglru: fix swappiness behavior
Date: Sun, 15 Nov 2026 04:07:47 +0800
Message-Id: <20261114200803.23129-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B7CB520003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hyg6tyq4ogu9is445xnwdbr5hp7ree65
X-Rspam-User: 
X-HE-Tag: 1794686894-826986
X-HE-Meta: U2FsdGVkX1+yV+aOYe+MOLo15VziBSiK3FjloPtt2sIZ4eNrcqU9d+jnTgGoAAaFAKstnLyRmlK5B+VTpjhStM9wIQAFCtf006inS9gCN1lD5NHxuqpaC9njrBxA9S4HDEeuwNM1ivGKZg3Oh9pV1Wdg6Jqjj5ZNRYx1AkO+kyDu8pWAqC9GRYg7ag+/B95TAHnzVYp4dsV6q5+BqoRMisMX1XkXDqHfVv6lQp1BG6bT0xcR24mFYUdFpdYRy4KjDCEEjdu5wVDQsn4oaAkrHsq5y8qJbDOgas+HdZ4vILITeWZsCPPmXrgKwArlKdaxPJhMNS9PmnHwZSTrUCc1NmGobaLTAtXNo/7G/XYjDiC/CNwbSRnoFGX2fwd9OPbbNfe+kk6eptG555+9RJSXneUK+hNibjLrND80EGN16tJX0yT2g6E5y07ztM9tib/0EqN3vKKV0lmP+DGFC7dJArYVLU/67IO04FnT+ml8A+qsruS/4TXAjMtl6KHZqc3f4cj702hWAEfgwl+3og7IBSDRxl094k2THlhrHCb56zly1M99gn8H+wnXzefDr3lCGA1tZTpmUyhVvdojIz2eJqjtPZfqVPdDFEOM9jNC+AI8GdoHnwsV2/dyNtrV4WjW/DE9QUrJR+ddcdhaP8n1rmsnMg6qMrZxrSse7dsgj00sMqdFmo8EeeOuPcU7CChMsfIlIMb55gPlEeZXiXhdFIZmDxJFWNDW7V/79WZJF0fUX0aOpSUELb3Ukxev/Y4z0qvCUuURscMFFDWeN+L/m1qa897UrccOp0lOaH7jbC1+g7o7bREJu6wy8/R7qpf/DQqi2RkbzdI/Qu0UqniEqo8elfbhelFq97GQjBZB992vmT0H23GvBBz5t/8U37VLGv8qBqnMW6MIAQhGZPtAYureYBrVzW1Tkh85Q6QJ4uYCV2Or49EJbD33mga/JzxGUKYzvrPXo0rT23rW9Bb
 2gMeFelv
 +zxtZFW7QssN8AaBFkDMlAMZYucTkjjSKaygnbGjkVdNA8yg+qVTRetopD89L0ZyeujUznUWwJK4tCQ8T7XIZZXwmHlKazzvNgKDCTygQISABWu6iT2tAzI3J4EVRvHTbgNW8HjnmVReTgymYhSjD8irOTeHO1XKznQ6injb9aYeTKeRfccn+oJrnoTuZM3p1xvx12BCyJb3Cj77i/FQQ1k6NCVSQpfj4Qfqtr2NFDdUFAOHnFlZpoIhQr3Qm5ghY12NZotUMom/ny/WJ1EgIVijPbiXRbjWgtsw/IhRBdPSR3KlRCA8AwWDTVn+AQztOBf38+/Aobj1R65J15E6fdpwdwxCIzRQnvcjICI2KkdY6PT5T7WSFOgqdh1LCK5A1pv6frZEgV74WrekIkpUqPZlo8GmMqVRB7iCJolO4qbB2M8fxvcRadN+9iHr7Yx/n4364
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

Patches 10-15 from Gaofei and Barry optimize aging based on folio
distribution imbalance and improve reclaim behavior at extreme
swappiness values such as 1 and 200.

Patch 16 from Bo Zhang addresses the GFP_NOIO issue in MGLRU.

After the patchset, the results track CLRU across the full swappiness
range (see table below), with more file scanning at low swappiness
and more anon scanning at high swappiness.

pgsteal_file

swappiness   CLRU          MGLRU         MGLRU+patches
1            6,620,680     745,968       6,197,601
36           807,807       508,974       564,256
71           553,144       417,700       420,008
106          402,880       402,474       363,635
141          240,293       337,797       312,624
176          187,682       330,045       238,722
200          0             343,949       0


pgsteal_anon

swappiness   CLRU          MGLRU         MGLRU+patches
1            4,436,199     2,671,934     5,011,932
36           2,858,117     3,032,747     3,039,483
71           3,042,392     2,827,735     3,132,431
106          3,292,622     3,184,314     3,238,658
141          3,612,869     2,999,000     3,306,901
176          3,827,154     3,134,127     3,714,411
200          13,825,283    3,269,753     14,481,445


pgscan_file

swappiness   CLRU          MGLRU         MGLRU+patches
1            11,853,625    877,311       13,108,154
36           1,016,826     582,783       657,973
71           662,823       474,772       457,686
106          496,374       451,285       390,056
141          277,109       382,604       329,819
176          206,261       372,059       246,141
200          0             393,608       0


pgscan_anon

swappiness   CLRU          MGLRU         MGLRU+patches
1            20,804,386    5,847,747     6,936,021
36           17,830,330    6,740,075     5,975,744
71           18,357,293    6,126,194     6,797,243
106          19,938,920    6,431,355     7,602,990
141          19,609,579    5,997,762     8,540,965
176          21,612,749    6,071,032     10,532,510
200          44,776,474    6,544,125     30,296,434


refault_file

swappiness   CLRU          MGLRU         MGLRU+patches
1            6,523,070     667,302       6,118,731
36           722,110       431,585       486,604
71           477,062       340,241       342,746
106          327,610       324,747       286,465
141          161,827       265,959       233,860
176          115,551       258,515       171,174
200          0             268,049       0


refault_anon

swappiness   CLRU          MGLRU         MGLRU+patches
1            867,728       552,829       1,368,563
36           419,635       657,745       636,567
71           536,299       611,345       689,528
106          580,742       693,689       707,227
141          706,151       639,850       753,779
176          706,499       685,086       934,553
200          4,693,850     733,273       5,491,234

With a normal swappiness setting (without extreme bias), I
see almost no noticeable performance difference between
the two versions.

For example, with `swappiness=60`, the average results
over 5 rounds are:

metric          W/o patch     W/ patch
real            1m49.273s     1m48.836s
user            25m33.186s    25m33.368s
sys             3m41.851s     3m38.388s

[1] https://github.com/ryncsn/emm-test-project/tree/master/file-anon-mix-pressure
[2] https://lore.kernel.org/all/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/
[3] https://lore.kernel.org/linux-mm/20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com/

v9:
* reduce one iteration for lruvec_populated_min_seq();
* let lruvec_is_reclaimable() count all zones, for min_ttl;
* refine lru_gen_imbalanced(), AGING_PRIORITY macro, roundup/down swappiness;
  per Kairui;
* let evict_folio_lists() return "drained" per Kairui, thanks!
* one bounded retry for scanned=0 and reduce concurrent aging
  for no-populatable(drained) aging;
v8 link:
 https://lore.kernel.org/linux-mm/20261113185541.70203-1-baohua@kernel.org/ 

v8:
* Fixed Gaofei Lyu's name;
* for debugfs proactive reclaim, use DEF_PRIORITY;
* refine no-populatable aging (limit frequency, allow an aging
  after eviction returns 0 scanned)
* refine "restrict eviction accounting to eligible zones" for
  potential premature OOM;
* Collect Baolin's reviewed-by tag, thanks!
v7 link:
  https://lore.kernel.org/linux-mm/20261111232603.9934-1-baohua@kernel.org/

v7:
* fix a build error of bisect and address some other sashiko minor comments;
* add no-populatable aging;
v6 link:
  https://lore.kernel.org/linux-mm/20261110202025.25736-1-baohua@kernel.org/

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

Barry Song (Xiaomi) (5):
  mm/mglru: Avoid placing rejected folios below populated gen
  mm/mglru: Run aging when one type is drained
  mm/mglru: Restrict eviction accounting to eligible zones
  mm/mglru: Reduce LRU lock contention by shrinking folio batches in
    inc_min_seq
  mm/mglru: Make swappiness=1 file reclaim more aggressive

Bo Zhang (1):
  mm/mglru: Avoid scan anon while swapcache is low for GFP_NOIO
    allocation

Gaofei Lyu (2):
  mm/mglru: Run aging when pages are rare outside the youngest gen
  mm/mglru: Avoid prolonged anon reclaim with swappiness=200

Kairui Song (8):
  mm/mglru: report evictable sizes per type
  mm/mglru: extract lruvec_populated_min_seq() helper
  mm/mglru: reclaim from the oldest populated gen
  mm/mglru: lift the forced protection of reclaimer
  mm/mglru: skip zones above reclaim_idx instead of rotating them
  mm/mglru: return for unavailable anon reclaim earlier
  mm/mglru: balance anon and file scan budget by refault rate
  mm/mglru: lift youngest gen protection for higher priority

 include/linux/mm_inline.h |  22 +-
 mm/trace_vmscan.h         |   4 +-
 mm/vmscan.c               | 514 +++++++++++++++++++++++++-------------
 mm/vmscan.h               |   7 +-
 4 files changed, 364 insertions(+), 183 deletions(-)

-- 
2.39.3 (Apple Git-146)



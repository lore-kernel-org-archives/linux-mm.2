Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB070C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D1A6B011A; Wed, 12 Aug 2026 08:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174BF6B011C; Wed, 12 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2526B011D; Wed, 12 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D653E6B011A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FA9D1A0382
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:07 +0000 (UTC)
X-FDA: 85092519414.25.C5E2A07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id BB85540010
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaOFY2VE;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537085;
	b=5bANs0iPphUaqL/3MNr252PzIaDplejpEgdPmqmCAMLUhhkCvnCytS1oRQqkgdTE0oIEpv
	Lk2u6MrEEeZBCCogTSETVabjrqNnFaHyKbZRtMj9Nd2Ss3K+4qurIoPI2TSvebZY0mVX8s
	rnFtLc6lxldsqfk8xX1oOD/KN8PhQQQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaOFY2VE;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=u1SenVFyKZZwxAz2ZqXzklSHgSjg5R41Zkn5KFFaVGA=;
	b=3ZzFIu8w+CFHksYvQrkSDmMkKc5iuha+ovHN9prhMLHpblBQjDls/NmbY3YrEfCXEmhdir
	6HKmE4KnFd0thMW6BXI6UrAnPaQfMoAaHbZiblX+9ngBghjpUDSnLWeUGRCYb4FZYdrseY
	UsxuGlKarVr8jYSlBu+utHRTj5ajGmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4379C60A85;
	Wed, 12 Aug 2026 12:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B261F000E9;
	Wed, 12 Aug 2026 12:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537084;
	bh=u1SenVFyKZZwxAz2ZqXzklSHgSjg5R41Zkn5KFFaVGA=;
	h=From:To:Cc:Subject:Date;
	b=UaOFY2VE4sSbsSWQQKCLB9QR94ASuSRJD1QzdVaMScEeaR47eM7hEgeM5Cyd/rNEX
	 SZAtIZ5fuiF2QvGrOWeGV2GGfGwG6rrhZKEddzwHkIC1GIiap0Xn8jA0H161wbV5EN
	 oRZXyR+pSV9NF1CMMVuNN0QAjXHmpkW5nvzTl2b8O1XdjscDu2G4MtIzpqhrflWSFT
	 6gp8ZoO6cmnobA9HM/5qSlvMHUWeOaXnJpu8W32CdcTu6d6jg+SU0rfnifHtHy28az
	 bcJx+wuSIayQJ1CKEKBMMSmDYX2WjvzJG9DivaQrKZxyyMYTuUBkjSm0GwRqulW26A
	 e7jcW5s3noH6g==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 00/16] mm: mglru: fix swappiness behavior
Date: Wed, 12 Aug 2026 20:16:42 +0800
Message-Id: <20260812121658.69965-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB85540010
X-Rspam-User: 
X-Stat-Signature: mqjsuizkc9g6qby54yk5x76nusiq886u
X-Rspamd-Server: rspam06
X-HE-Tag: 1786537085-218683
X-HE-Meta: U2FsdGVkX18ylcLs4VX1ump9xgBzcm//n8+9lIgVFkB03PMJl3nyjxIOgNknKvIOX8m8LwED+2FcNJOdpkDc3bk/5/5g296y0ib/M2wA+GbajxXMDDiAgg+FJKNC/rkh2XyqYWBc3NTuyJON1/+HEXudwaiA78uP/HhVuH4yAKZovoCau6z4mzLOqr4xM3YlnIfpJeljIoZ4WstkjxB+IuuEgv5yLrKWlX04+pQ4hjSmZTLT261IvgGrA8dwhbHRQMsNAubdA3Aflc4EZoF82n/UIDJTMaPDLwi+dcY5dvAsv0DZs3uwqivaNFQtYMFMeo1wmkgRp/9B+VR5oBLDCbGaVREEgmvhSbLkcwejW0BsWi3k9dqScDyTduC/kce2/ye90ik8Vw7PkdpZw2wuRTahJoWVtc/MqoG+yYEmccMu7/JK1amdRRDsld06V4RWCBLdKJuf5ENFuSWjCBku3TI2bed+9Moajbs2X++H8UiHjf+EBSEIIkjbTw5SM1ZBfkNxQHothK4OtFojUK5sTqgfvQgsayOkY1KxTPcX515GKcNDczGOoMp/pvUnbJxE+9K0T/1jILZNsxSHaaxvj5TfmEZaFF68305BFKSja4I/LS7XTMGrJGm0OLgsKatnhCEQPZiEMZiiQpsHTn3kIwdK1WvsMqKajz04r7ID84g8C7/7BeCOw5CRthWYoSg+XHE+d78VkSy9nckuPOmodE5mzGa92aWEqyGVBUsG7e0LuE/iFJkpm8fACtLbrd2rLFF0qhU30jtmgcPdvaMJRlsIUACzCMBFcR1zDJuZxjlTQNBgy8blLsb8PapZNSYY97K6556GIK+cP6MYJlzhnoyNhylTQQofgRvjRPVxiV/YRxr7GMdFxe9fn8MyWOngYQduLkNLQIzIjhiy0nwMCTFthi1DOGEL7lvZPP7/M+dLKhWr+HquqDPpNJPGgRP40Y0SK8vvBi3XfiJz9UX
 00V+EbHr
 bO4QPkiXfSpweoPV6pGQ0Bg+6ruybXMpc+y4eh0llnelcjwi7nAO3/KlkT5rsJNwhULLsaJoEN6IOeDdBgERlJPLjzTq7Mm+7HCnxh7nt3aIv/gwO5lEPDBcLTd9ukb71udEw5rV0s3L5Kr/NhUiVFMifdjtsoIOzat3DsF9OYIHP1rcGAgaWmy9VhzhBFnk4YEqzGzAspJsyJ12fbCCtiZxhPutYYGgwNEk27g/ZQDwkVaH6m2wfKd9L14MccY3usdLCmdu1T091RGd4bwPDX6WP+AjrLk1AHguuVTDioTvUUke0fJXTTEesl93qtP/r5KFVTEUNIsSD/6xH5UpK2mz/YYMiEDhSz7mbd6ArYDajcADKPPD//x/g8vA3QnO7DyDsMC11ckOAGKV2b7iOKViGwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The active/inactive LRU respects swappiness well. Anonymous page
scanning and reclamation increase roughly linearly with swappiness,
while file page scanning and reclamation decrease accordingly.

For example, with extreme swappiness values such as 1, the
active/inactive LRU performs much more file reclaim, while at 200 it
performs much more anonymous reclaim with little or even no file
reclaim.

In contrast, MGLRU shows little change across different swappiness
values, especially at the extremes of 1 and 200.
The data below was collected while building the kernel in a 1 GB
MEMCG with -j20 and zRAM configured as swap.

                         pgsteal_file

Swappiness      LRU        MGLRU
--------------------------------
1             10788341      760931
36             1101082      526479
71              683084      406540
106             465165      380845
141             292018      361058
176             207810      332329
200                  0      349617


                         pgsteal_anon

Swappiness      LRU        MGLRU
--------------------------------
1              4305108     2594416
36             2790004     2984411
71             2692223     2965396
106            2844429     3039293
141            3101425     3087067
176            3394419     3110359
200           13210927     3080592


                         pgscan_file

Swappiness      LRU        MGLRU
--------------------------------
1             18718146      887478
36             1485019      610943
71              849670      460520
106             561680      433057
141             368688      404839
176             234273      375214
200                  0      400190


                         pgscan_anon

Swappiness      LRU        MGLRU
--------------------------------
1             29683174     6008050
36            27142699     5960053
71            25804052     6278323
106           26582642     6416301
141           28199275     6349025
176           29360048     6277269
200           62517850     6295609


                         refault_file

Swappiness      LRU        MGLRU
--------------------------------
1             10693128      587183
36             1018405      343244
71              602508      247697
106             388580      224246
141             216110      200426
176             127306      175176
200                  0      189009


                         refault_anon

Swappiness      LRU        MGLRU
--------------------------------
1               593074      540688
36              231609      654679
71              263264      642920
106             286477      640700
141             331410      634729
176             390750      656967
200            4120283      642881

This patchset respects the type selected by get_type_to_scan(),
which uses swappiness as its gain. It does so by running aging when
the preferred type has few or no reclaimable folios, allowing more
folios of that type to become reclaimable.

As we begin to respect swappiness more strictly, inc_min_seq()
may be called more frequently. While this function resolves cold/hot
inversion issues, it may itself introduce additional cold/hot
inversions, which are addressed by this patchset. In addition, we use
batching where possible to reduce the overhead of inc_min_seq().

Patches 1–3 improve readability and enhance the exhausted checks in
isolate_folios() and scan_folios().

Patch 4 increases the impact of swappiness on type selection.

Patches 5–10 fix potential cold/hot inversions and use batching where
possible to improve the performance of inc_min_seq().

Patches 11–15 improve should_run_aging() with additional generation
and imbalance checks, particularly when few folios remain in the
reclaimable generations.

Patch 16 reduces the batch size when moving folios from the oldest
generation to the second-oldest generation in inc_min_seq() to reduce
lock contention.

With this patchset, swappiness starts to behave more like it does
with the active/inactive LRU.

                         pgsteal_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             10788341      760931        1974207
36             1101082      526479         620248
71              683084      406540         414207
106             465165      380845         365887
141             292018      361058         335876
176             207810      332329         306476
200                  0      349617          10569


                         pgsteal_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1              4305108     2594416        3204425
36             2790004     2984411        2895280
71             2692223     2965396        2766936
106            2844429     3039293        3105011
141            3101425     3087067        2989129
176            3394419     3110359        3183651
200           13210927     3080592       13354629


                         pgscan_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             18718146      887478        2753870
36             1485019      610943         712969
71              849670      460520         471135
106             561680      433057         419504
141             368688      404839         374698
176             234273      375214         340775
200                  0      400190          10880


                         pgscan_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             29683174     6008050        5645754
36            27142699     5960053        6056810
71            25804052     6278323        5877296
106           26582642     6416301        6397449
141           28199275     6349025        5951263
176           29360048     6277269        6076458
200           62517850     6295609       21506939


                         refault_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             10693128      587183        1836987
36             1018405      343244         443893
71              602508      247697         245171
106             388580      224246         202345
141             216110      200426         178638
176             127306      175176         141618
200                  0      189009           5003


                         refault_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1               593074      540688         800149
36              231609      654679         609397
71              263264      642920         582514
106             286477      640700         653094
141             331410      634729         636040
176             390750      656967         667461
200            4120283      642881        4126464

It could be brought even closer to the active/inactive LRU by
ignoring the potential cost of inc_min_seq() and allowing more
aggressive aging. For now, however, we aim to balance the benefits of
respecting swappiness against the overall system time. Across almost
all swappiness levels, the kernel build workload shows that MGLRU with
the patch achieves lower system and wall-clock times than the
active/inactive LRU.

                         sys time

Swappiness      LRU        MGLRU+Patch
---------------------------------------
1              7m42.831s     6m15.160s
36             4m51.991s     3m42.020s
71             4m29.953s     3m39.259s
106            4m34.790s     3m48.321s
141            4m43.026s     3m42.552s
176            4m54.383s     3m46.840s
200            8m11.063s     7m28.910s

                     wall time
## Swappiness      LRU        MGLRU+Patch

1              3m08.386s     2m01.631s
36             1m54.989s     1m49.887s
71             1m52.556s     1m48.879s
106            1m51.885s     1m49.942s
141            1m52.143s     1m48.916s
176            1m51.925s     1m48.703s
200            2m02.300s     2m00.487s

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

Barry Song (Xiaomi) (13):
  mm/mglru: improve scan_folios() exhaustion detection
  mm/mglru: retry the same type once if isolation fails due to races
  mm/mglru: boost swappiness responsiveness in get_type_to_scan()
  mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
  mm/mglru: batch update lrugen->protected in inc_min_seq()
  mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
  mm/mglru: exclude folios promoted by aging from protected in
    inc_min_seq()
  mm/mglru: move folios from oldest gen to second-oldest gen from head
    to tail
  mm/mglru: batch move folios to the second-oldest gen's LRU
  mm/mglru: skip gentle reclaim at DEF_PRIORITY for extreme swappiness
  mm/mglru: run aging if the preferred type has no reclaimable gens
  mm/mglru: dynamically scale aging threshold in lru_gen_imbalanced()
  mm/mglru: reduce folios pulled from the oldest gen in inc_min_seq()

Bo Zhang (1):
  mm/mglru: remove redundant gens <= MIN_NR_GENS check in
    should_run_aging()

Ridong Chen (1):
  mm/mglru: improve readability of isolate_folios()

lyugaofei (1):
  mm/mglru: run aging when pages are severely imbalanced across gens

 mm/vmscan.c | 289 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 233 insertions(+), 56 deletions(-)

-- 
2.34.1



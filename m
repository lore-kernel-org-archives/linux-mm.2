Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14462F44857
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 12:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C856B0089; Fri, 10 Apr 2026 08:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42DB66B008A; Fri, 10 Apr 2026 08:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343486B0092; Fri, 10 Apr 2026 08:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21CDB6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:44:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BADB2591D5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:18 +0000 (UTC)
X-FDA: 84642614196.20.3CD0752
Received: from outbound.st.icloud.com (p-east2-cluster5-host4-snip4-1.eps.apple.com [57.103.79.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B936100014
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:44:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=VZHJ1nQa;
	spf=pass (imf14.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.54 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775825056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8zAKW7TKIdYtRCrdMYYdB7ruxsvi8/ixARgZcc3HuzY=;
	b=2HkroBRqioRZ4gRiAkno9SyFLaSB19579/1agipD6uRGrpqRCevDYTto9iMLKuUihl6Lpf
	blHeEAdoHbuiCe4B675FcPfgv+hlYibjsbPB3brH11OclBur9cRp0UsnzcTLtVqiaLNtxJ
	BnAi3htraL58u98sYV7lLcTX1QXCmi4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=VZHJ1nQa;
	spf=pass (imf14.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.79.54 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775825056; a=rsa-sha256;
	cv=none;
	b=up64lrBCySfIed2SxP0Zz6PPfVg1pUnTWGCLKD3/DDaaYO4xvOoRanD8KuwpJ0sfjKSYni
	b8kEeZHzgWRqDELsFdrS8PqVzcTU8PibLx49peXvZCtaoc36s2mCLtm4diSigTDIBpztI3
	VXLo/Cos8UzbNzPe2ZUXg2R39SA8abI=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPS id 35938180035C;
	Fri, 10 Apr 2026 12:44:12 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1775825055; x=1778417055; bh=8zAKW7TKIdYtRCrdMYYdB7ruxsvi8/ixARgZcc3HuzY=; h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:x-icloud-hme; b=VZHJ1nQaGwER5pdoNL+xnmFDpR3bOrZqlvLOO0URIDF3FxXV7vhizUaWMLFY5KSPURPta++qCyMig0+wL77mym3e3kdxaSJy8uPbheD14KYoiwQl15BGqvs4w7ecIBqqW3QZkQsIw4GE+rnd5cPKF9wI37d/WULHO37Dg4zcSmzCIIZEXLfLvQSEX1TmSNk2DL85zIk2sGKAfeIkIsTk/Hme21pliENaT07+fii1VS1os2iGIgKOhxN0Q8JvXuiYXT8VNBqjHkv3c26lA4lmxnxuiYFDb3DanDg+PV1QkfJaqG3D6jTTHGJjZbIabD1B9uDCmBh4m7QnLOe8aj0hEw==
Received: from [21.6.122.162] (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-0 (Postfix) with ESMTPSA id 0B5CE1800181;
	Fri, 10 Apr 2026 12:44:04 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Subject: [PATCH v3 0/5] mm: batch TLB flushing for dirty folios in vmscan
Date: Fri, 10 Apr 2026 20:43:58 +0800
Message-Id: <20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAI7w2GkC/3XNQQ7CIBCF4asY1mIotFhceQ/josAgk9RioCWap
 neXdqUxLv+XzDczSRAREjntZhIhY8IwlBD7HTG+G25A0ZYmnHHJBFNUd6PxdOw1df2UPG2VcAw
 aqWslSbl6RHD43MTLtbTHNIb42h7kal3/W7mijIJuHdijrToFZzR9mOzBhDtZscw/AC5/AV6Am
 glouBC8MfUXsCzLG4ad4xrwAAAA
X-Change-ID: 20260309-batch-tlb-flush-893f0e56b496
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775825044; l=4105;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=O5ktmk+TLv9rz1J+bLjEiohACE86R8x9048z8wYN4I4=;
 b=Qe5FdIHImhiR0XAGDGfa72dcBPU/IRjGupJlQzoAdyNjl6fbz6o7UCJ7Tke1VwRcua/u9ZO8T
 nfMGX6o+L/GCSCkEHHQGaX64jkW56N66CXZUsjkJ29mygcZBvrR1i/H
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-GUID: LVApXZZHrRNHwHEbxJLFoAMXamTelL-e
X-Authority-Info-Out: v=2.4 cv=VKfQXtPX c=1 sm=1 tr=0 ts=69d8f09d
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=v3ZZPjhaAAAA:8 a=GvQkQWPkAAAA:8 a=k3ryPfxwKlxrfAMZny4A:9
 a=QEXdDO2ut3YA:10 a=J82S1U87d15UFHHUFZS8:22 a=yLjSXO_LiVxs9JEHLWbQ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEwMDExOCBTYWx0ZWRfX4qGg5eeMrMwc
 cDBxlZvO2WD/E54nkqzd18+4ITfbqAnWgoeJvA9g7LDu0EvuLH4KfBr41H2zeu/WsKXAVFL2Xtc
 WIIi1SaTgL5dh1pi2A/Ik+MU9QLpzn/QQnNEOCehUYyw6snXXoi8YCVwrqT3OPHvGfTDY/qdPEQ
 rOFmwFqroNn5HLOHZElNlA9NnfuTE470Nqom7xBfm5COABoK39wH/ThDxo3xZX+HD4VZQxXTrdH
 r2drVc66qy1/dwFobGtGbr60stcBsy9GrfsidizmleQEpz4Kep4AYrHBLoYnp7iZjoshiSk70is
 z7j+QZodZvHWWEUW9B+60FrEQBiOkiPCR6N6nx95EB6zx5/V2OwLo9urUhWN20=
X-Proofpoint-ORIG-GUID: LVApXZZHrRNHwHEbxJLFoAMXamTelL-e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-10_03,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 clxscore=1015 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 mlxscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2604100118
X-Rspam-User: 
X-Stat-Signature: jo8hazkmmemm9f8kktnkt5dhbi3wecdy
X-Rspamd-Queue-Id: 9B936100014
X-Rspamd-Server: rspam09
X-HE-Tag: 1775825056-912268
X-HE-Meta: U2FsdGVkX1+lYoxfmvTmS2tNpHpx08aqLsu2mVK/P9AiWodIlJN+A2DWUS9cx58vZ+tLFS3q9wtJOQFUwfJSJioa7Xkpf9SABN2XOynIma5ZJcoWAF9RoddytQ8t/I3+KoSvD4H1klIRxo1W1yeAu3TzeRBaFM3D+pLViMvQhJnMYApM4kBgy9LIbcFXyplm0KflzY0bB1S6f9oFqG8cqKW9y8GD79oZ6MF6mahys1QcRWYDWb1KfPoQJhNrtYJ4O28Rz6mUqrRRizSBhcsLMJhEDhKPLnIj39af1l5c44e+S+njxFs6I4g9h7uIj/G1q6bSf+xotcm/xX1gJrL3B3Zwpxl4GOK5kGAehIkHbnfRjDguH250h7H+MG0BJbRq7NDxv5tPUu1wrXwXFz7tcsHbmSqWgtp0bhoKiiI+v6P2D286ZI5iISzGsha8hC64EMyKpngMgXP45kIl1rNhLUnHMy0bYNvnnGqcXC5faIJCe2qtgpRtRA1bauIjB6wEkBUBcmGdSGDx8AAY89rYhYHlHxM5BRAd45O1/jdULO8US3FO6gNYNE0f2GKKnC4ikL0b063Ve08A3pwaP3rB9sHa3aWzEvXBUl3Qi8M8WWsxQR09eCHjxqnGNXwGb/GJr4WFrDTcEcL7pgjEkgbAogILJ+rFgtB6UVvzyyjrxFAqbhFuJ9V/FdXc+1rYyPiOYw8SEfcFtMZ4QauvOvt9HahazCy053ZsJdeVH2GNOFQIYT7gckJ3fEqWlCxUkPh+BTUm55Gw9+ZBcTluZkhjmxJNPxgamJyjQ1S+d8djhFrfs2qSG6dQd8bZzhwPB5ron0UuUahYbiuII2CFyKdi/yZYf+fh9LCYFy5Y2yrK74NnBHjChT6/h7SRWNEK/PPgInDaSwOPPR9XZRM95vaQ+aNAYtXJMvfA95Zg6o6h2sK9lfLd4J5u6V3iCmxO5tf02rHqIkQwg20f5NZh7Ld
 ODek4x7f
 IxV4nsPUpGMkRhcMUDB5X7mjvcmb2f05sP1qxZhQ9qus7v4qz5fLZ2yifIJ2i0TYRDvjPcKIZI7fNriXevhXr13RmLP1clM7gljDhwjCxcifxH0+FvQPdYNPJXmf7Qvae6uorB4imaR53kLPkGtkMEBVTNTc78b/BnUQgBcNlY57fRMUcNSkq2HWCi0Yx5uOPxz5I3SPLQqsxE4PVH+KElpyFEm7qyrQSOH8QGtDosfOGkkBAE1XogEu08kkE0Yi7byshPxHiJlHbnbLo9qzsQ2NEMV+HYyJH0GyPFSizq2HDyKedCE9VL0gxGnOAHHxaokodFmfrXhgkh5ttnyJdeS9ZcFg9Kwj+WG57Yf0IO6pLvA2VtE6o0uB9ReWGW9sunRySqthfwHbOkjG56hgbVwNdUKZ3fwisUPrS7wqgXE4QnLGbbhhuQnByAY9MghkY4RtWqoI9nJHbm4I2ISpzwFp6Hnr8fTmHHd1gIJZjMBZbSHz97tcurDeLBm8LVpU8eAU5EMoTZ1v6e1xtml2nnXEaH55mOW1H22h2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces batch TLB flushing optimization for dirty folios
during memory reclaim, aiming to reduce IPI overhead on multi-core systems.

Background
----------
Currently, when performing pageout in memory reclaim, try_to_unmap_flush_dirty()
is called for each dirty folio individually. On multi-core systems, this causes
frequent IPIs which can significantly impact performance.

Approach
--------
This patch series accumulates dirty folios into batches and performs a single
TLB flush for the entire batch, rather than flushing for each individual folio.

Changes
-------
Patch 1: Add nr_reclaimed to reclaim_stat so shrink_folio_list() can be changed
         to void, giving a consistent interface where all per-pass statistics
         are reported through reclaim_stat.
Patch 2: Extract the folio activation block at activate_locked into
         folio_active_bounce().
Patch 3: Extract the pageout() dispatch state machine and the folio-freeing path
         into pageout_one() and folio_free() respectively.
Patch 4: Extract the TTU setup and try_to_unmap() block into folio_try_unmap().
Patch 5: Implement batch TLB flushing logic. Dirty folios are accumulated in
         batches and a single TLB flush is performed for each batch before
         calling pageout.

Testing
-------
The benchmark script uses stress-ng to compare TLB shootdown behavior before and
after this patch. It constrains a stress-ng workload via memcg to force reclaim
through shrink_folio_list(), reporting TLB shootdowns and IPIs.

Core benchmark command: stress-ng --vm 16 --vm-bytes 2G --vm-keep --timeout 60

==========================================================================
                 batch_dirty_tlb_flush Benchmark Results
==========================================================================
  Kernel: 7.0.0-rc1+   CPUs: 16
  MemTotal: 31834M   SwapTotal: 8191M
  memcg limit: 512M   alloc: 2G   workers: 16   duration: 60s
--------------------------------------------------------------------------
Metric                 Before        After             Delta (abs / %)
--------------------------------------------------------------------------
bogo ops/s             28238.63      35833.97          +7595.34 (+26.9%)
TLB shootdowns         55428953      17621697          -37807256 (-68.2%)
Function call IPIs     34073695      14498768          -19574927 (-57.4%)
pgscan_anon (pages)    52856224      60252894          7396670 (+14.0%)
pgsteal_anon (pages)   29004962      34054753          5049791 (+17.4%)
--------------------------------------------------------------------------

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
Changes in v3:
- Patch 5: Replace folio_test_lru() condition check with
  VM_WARN_ON_FOLIO assertion, as PG_lru should never be set for
  isolated folios
- Patch 5: Add comment explaining folio_batch reuse-in-place
  technique in pageout_batch()
- Patch 5: Rewrite comment above folio_unlock() to explain why the
  folio is unlocked while batching
- Link to v2: https://lore.kernel.org/r/20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com

Changes in v2:
- Fix incorrect comment about page_ref_freeze
- Add folio_maybe_dma_pinned() check in pageout_batch()
- Link to v1: https://lore.kernel.org/r/20260309-batch-tlb-flush-v1-0-eb8fed7d1a9e@icloud.com

---
Zhang Peng (5):
      mm/vmscan: track reclaimed pages in reclaim_stat
      mm/vmscan: extract folio activation into folio_active_bounce()
      mm/vmscan: extract folio_free() and pageout_one()
      mm/vmscan: extract folio unmap logic into folio_try_unmap()
      mm/vmscan: flush TLB for every 31 folios evictions

 include/linux/vmstat.h |   1 +
 mm/vmscan.c            | 462 +++++++++++++++++++++++++++++++------------------
 2 files changed, 293 insertions(+), 170 deletions(-)
---
base-commit: 7c5507fca017a80ece36f34e36c77e2bee267517
change-id: 20260309-batch-tlb-flush-893f0e56b496

Best regards,
-- 
Zhang Peng <zippermonkey@icloud.com>



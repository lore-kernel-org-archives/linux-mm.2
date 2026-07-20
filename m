Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDE9C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201616B0088; Mon, 20 Jul 2026 01:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1E76B008A; Mon, 20 Jul 2026 01:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A13C6B008C; Mon, 20 Jul 2026 01:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB8FF6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:07:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52E2C1406D9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:07:55 +0000 (UTC)
X-FDA: 85007972910.02.8749996
Received: from outbound.qs.icloud.com (qs-2001j-snip4-11.eps.apple.com [57.103.87.103])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5F89E140009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:07:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=lHOFL3u2;
	spf=pass (imf23.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.87.103 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784524073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Faah87vbG2GYUTT4eqViFuxusWFFNof64ld9zeyq33w=;
	b=8pF/0/ESg124HPNuxpt5K6PSczAG5YnyupbMupUinbKQq5LVKHCmeXcU4q7Bl1IkSYVaZ9
	O0KANDWRyt+sus68ahBNev8Sson8HxLwyMRDEkuxuhAlLiMNjLTFpK4EqPGdZChQmH2O1k
	GYAW/wkYCUMR0uFqGhLXIxcbh/0xRZM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=lHOFL3u2;
	spf=pass (imf23.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.87.103 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784524073;
	b=oyxBPNFj6rmw4JD1Adf0Cuy8t3wCQdya4CywQkGEPSvAaQQE0aGa4RhoxTFyWFhCLqB+W2
	lyvU6SfoznUkAM9aPr1ZFfdLamJ+W69TjjUUZp8pmgcCoUhKqrEOcXip3xzwrsT5UUqyR0
	aAXDtLyufSP+de1kkZFblxHyiufP5dU=
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPS id E8F691800105;
	Mon, 20 Jul 2026 05:07:50 +0000 (UTC)
X-ICL-RepId: 019f7dec-6004-78c9-bc25-08be6376e19a
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHVwGXRxCCkEdXgBLVxQEAlodRw5AHVYWWAhOK1sTVRdGCRkIXR0ZHldQXgheH0wcHQ5YBhICWkUBXRcDVxxWRVwYQwldBVccHRxERVsTVRdGCRkIXR0ZCEcfCjADQg5WA0MHRQAtGRxXUF4IXh9MHB0OWAYSHVAcDlEFWwBGCU8BXRoJUwRaEB4ZWwkfFlUNQAUaHQddCVVXDw5fAREJHAMJAQlyGVoUXBhTRVEfVEYTGU4bV01QG18CQg8=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1784524072; x=1787116072; bh=Faah87vbG2GYUTT4eqViFuxusWFFNof64ld9zeyq33w=; h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:x-icloud-hme; b=lHOFL3u2/cCUBMIkacRG+0ZdK85P3yDqpgxeBC7wk24a4VA+zFdS4B2yV2Rs9QlFeQtmvwcV5a8cC856TBVlBXrQ4EPmRJigjdkJrRe51XrLOfp15P90zD26tshxLd9D45UVN9hwNWvO3Lt52/gzM9rBX11nDxHK4EfXvSkKQlxKYwAxfJcDURRSwIa1dvm5UyHIKt0TC4TmTz+3aMBtZPemVRtZISOUnG9MhScj4sjXewWKthvzkM7iW+2RmUWjkdvTNBaHAp61BI4KrgHAwTRRgvhiIYunrG0jUM48IPmUgP/RVbDbGki/e3FkHh824FTBBXyJavJXuX8XojMqyw==
Received: from [21.6.122.162] (unknown [17.57.155.37])
	by p00-icloudmta-asmtp-us-east-2d-60-percent-7 (Postfix) with ESMTPSA id 10BF3180009C;
	Mon, 20 Jul 2026 05:07:44 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Subject: [PATCH v5 0/5] mm: batch TLB flushing for dirty folios in vmscan
Date: Mon, 20 Jul 2026 13:07:37 +0800
Message-Id: <20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABmtXWoC/3XNTW7DIBCG4atErEs1MEBMV71HlAU/Q4zkxpGxr
 USR716STVqhLN9PmmfurNCUqbCv3Z1NtOaSx3MN/bFjoXfnE/EcazMJ0gCC5d7Noefz4HkaltL
 zzmIC0sYra1i9ukyU8vUpHo61+1zmcbo9H6zisb63VsGBk+8SxX0UztJ3DsO4xM8w/rAHtso/g
 DQtICugAElLRKmDagB8AUpAC2AFUgJvIzrUwjWAegFa6hZQFehw39lonA8A/4Bt234B21JFc3I
 BAAA=
X-Change-ID: 20260309-batch-tlb-flush-893f0e56b496
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784524064; l=6066;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=Zop4bLuKGY4EXfmtgnIN25YeRP2tMQYyb08aLDvFxlI=;
 b=bvrZ2TAzja8w975UPXyeyf+3/CKdznk/k58Ik06iZLmK1bkIL9rF6idOYGQZLyxvZnFVRvyQ3
 gzqQA63pNt7D+6GwkSCCnGudZb+bHRtaVUFhXWih9GwRb2FFUBPdVEE
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA1NCBTYWx0ZWRfX6x1mN5KQ40cw
 i9ASRQfKj5SIlyxieqgxTmVVWpJRJNyGq94Pu4yUAu7hX6KwRgOwEiVwtDKnbRoD1USkYUVnZQC
 PNhSXX5ywSSQhqdNV46vorD94tDlHocZCmY7LC+PhGlydWfTUpRH3/feiNSvASQtIT8MLRCWCkk
 44PbFYKE2jb7GcOW/HkKWBP2Jr/ojdxmxF2vnLHYDacKRys+fyMAcaxQuhxufcc4u6V63A4MzMf
 PyaHRQ1eKJuVe9SAVwR1/UP6ggIK8sy5qMkPOISNV2lBVEwW9KB3zMhBJQfs0pEm4ui7+4kNh7G
 XlOUa7UD5CJVhN5Qyhd
X-Proofpoint-ORIG-GUID: WgQ5csdCtwnSb1QqCn-nwVaHcFFfnm38
X-Proofpoint-GUID: WgQ5csdCtwnSb1QqCn-nwVaHcFFfnm38
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5F89E140009
X-Stat-Signature: ghq438i4zmtya55wrbmsyzfdobkbkprm
X-HE-Tag: 1784524073-497825
X-HE-Meta: U2FsdGVkX1/mbsM5rjwfatrIsJTVn2Xj7NAUZvL8M9Eb8tAt3jqjkskAZPpxaUA0SEvBSUlsN0+nAPYgceQE7kyIkQiBH/zkJGnglvm9TxhSBVOuEj1Y7kh5q/+UdalT82fZi5/525Etm6f78SwvZwK+pQTzxIcrxvzeeoKSG9v0KmtVf10egkbPJVejH7r/7/Up+PUpfjXLreN8X3dnQUIXSIj+MUsDm9djYpYCfnqQ9rJzbzGzdFRM2ovcKT3lLZnXlVX0O/cyHMDOFw1luDj5whkDooEBHlRjgcIEEzahGaTMOdFaJRFToDhlxQyP8fUH61cJD79oU4w++azmeOfj3EPATuYYAosyrH5gHJFpDE1Mt8WhgseG3Uw2lqoKqc3aiayMC4t/yerzmm2Yg/iUFgQ3R1U8rknVn0aLvNmXn1eaRaFFYAXhm6DzgYUfXINb72xX45A+eTCdq8umEhcFoWA1XBmB2KdOsjC52O7mgE2O/xRXAWl2wsg/6WMUcYEvk7O9rmjx8gMvX6kNeXoWXYtzR62QzcPAgDsnECtYLd22L2DEo9m/OQZFaGYhDFprYsOR7iaVmmgH/soQwfUaYHio3/KQAb93gIJSrsba5Yke3VZ2EW9uZj1nRyGj3kJJht1olSrSS24LAERolczni2uzxRj1PJ28bZ9kjB2qBvfPzSWuc3xXT5UZ+Dy7HP9aKsQTqx5MIvg3YFuEoCYfOqukJx/F6EzVG2PBhMl+gYfeRFw7IFWVPMgCE9otuqw+nz9o1MGdIx0DwUKRJIrZLgeeWKQuR1Z5QOFa4a0zlVHGrCsYJ+DcDGk7z5jm/u9zxuBF2ekR/M6kiL8oGmfGcRvNV3QkjUb6/2C4CIVRST4qjE0wnGf/QuMRLcthxLW687flR5CCU8mypa4EaIzS4q80nvimGzt0QQww8umgF7cUJAuHrhBnBHvhgm9H7sLHrWiQPqRdKAf9svR
 fqWXB+Gd
 x11DXCiVBLsY0lmcJpxFJeaxOWDizDbT7pBdpZvfV1SqHZB5EjykScNtuRZ3N2x4bmuQdPw8PEBlT4mPqkqSz74fzbVv6+rLH8XfXzF3v0M5z0y2lTfzoRtzwARxylwRttGocwKs+g5ngevsX0TK7TjX3P/gFx0EPiJ4QEKE3vOCjNzgwm40mZASAC4kKUXpoDmYlXG3yKRfZUuy2dKBSmdWRchOfrytOlkkAzcq03Xvv/0M3aDx9dApKFkDSMR5simGf82N/WMLfEIapZkJKZ3F7dq6njiTtZuGe2oncpPNpH/jdN0BGDoe04HmQMKyvqd3KdFsQ8H/ARwlh8ZFk/TtE55O7yecBO9zEs90CPa987mDtAUGLityLCVglAi9j5/eahGRcP/a5aU9e2nXke5+FtPILfkxc+IFw4D8EdEPwvM4CHCGn/i7T+RrSHIW8/SNp
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
Patch 1: Extract the folio activation block at activate_locked into
         folio_activate_locked().
Patch 2: Extract the folio-freeing path (buffer release, lazyfree,
         __remove_mapping, folio_batch drain) into folio_free().
Patch 3: Extract the pageout() dispatch state machine into pageout_one().
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
Changes in v5 (addressing David Hildenbrand's review on v4):
- Patch 1: Drop the nr_pages parameter; use folio_nr_pages() inside
  folio_activate_locked(). Add VM_WARN_ON_ONCE_FOLIO(!folio_test_locked)
  at the top of the function. Turn the VM_BUG_ON_FOLIO(folio_test_active)
  into VM_WARN_ON_ONCE_FOLIO and move it to the top.
- Patch 2: Rename folio_free() to folio_try_reclaim_free() to make the
  reclaim-specific role clear and justify the bool return. Make nr_pages
  const. Add VM_WARN_ON_ONCE_FOLIO(folio_ref_count, folio) at the free_it:
  label. Drop the now-redundant "swapped out as a whole" comment and the
  "else continue" after goto keep_locked.
- Patch 3: Rename pageout_one() to folio_try_pageout() for consistency
  with the other helpers. Fix continuation-line alignment.
- Patch 4: Fix continuation-line alignment.
- Patch 5: Replace the in-place folio_batch_reinit() + walk pattern
  with a plain local array; @fbatch is now only read during the walk
  and cleared once afterwards, so its invariant is never temporarily
  broken. Add a comment documenting why each recheck (writeback, mapped,
  dma_pinned) is required.
- Link to v4: https://lore.kernel.org/r/20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com

Changes in v4 (addressing Barry Song's review on v3):
- Drop the "track reclaimed pages in reclaim_stat" patch; keep
  shrink_folio_list() returning nr_reclaimed directly. Avoids touching
  the function signature and its MGLRU evict_folios() and
  reclaim_clean_pages_from_list() callers in this series.
- Rename folio_active_bounce() to folio_activate_locked(). The new name
  reflects the precondition (the folio is locked) that callers care about.
- Split the folio_free()/pageout_one() extraction into two patches;
  make pageout_one() return bool so shrink_folio_list() can see whether
  the folio was reclaimed or kept.
- Move the !folio_mapped() check out of folio_try_unmap() into the
  caller, so folio_try_unmap() is only invoked for mapped folios.
- Link to v3: https://lore.kernel.org/r/20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com

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
      mm/vmscan: introduce folio_activate_locked() helper
      mm/vmscan: extract folio_free() from shrink_folio_list()
      mm/vmscan: extract pageout_one() from shrink_folio_list()
      mm/vmscan: extract folio unmap logic into folio_try_unmap()
      mm/vmscan: flush TLB for every 31 folios evictions

 mm/vmscan.c | 455 ++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 293 insertions(+), 162 deletions(-)
---
base-commit: d0b709f436b2788a10407624688ab8327c5ce18d
change-id: 20260309-batch-tlb-flush-893f0e56b496

Best regards,
-- 
Zhang Peng <zippermonkey@icloud.com>



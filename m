Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA000CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78AF6B0005; Mon, 25 May 2026 10:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E298C6B0088; Mon, 25 May 2026 10:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F106B008A; Mon, 25 May 2026 10:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1FD36B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:57:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5DAB916047C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:57:40 +0000 (UTC)
X-FDA: 84806246280.14.6BB842E
Received: from outbound.pv.icloud.com (pv-2006g-snip4-3.eps.apple.com [57.103.67.106])
	by imf17.hostedemail.com (Postfix) with ESMTP id 58FDE40004
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:57:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=WL2xXZbD;
	spf=pass (imf17.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.67.106 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779721058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OAUuBP6zkRebfLM9QrJNQqWjPs6p9RgPPzOO239E/ck=;
	b=myyMNBvENfB5AY/rmtP/SM83FcjDMavLmrs18EQaldwafkFpqOznaE9/daYbNU/xNk0OA9
	J+8isSdTxSpXDHW5Vi8jBWTV9FqYHc368UO3KUgYkYdpgiXaLPouyr/cq+7j+iburNLb72
	QAxUyd/0zAiWG83L4/7ypgFXqt762vg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=WL2xXZbD;
	spf=pass (imf17.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.67.106 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779721058; a=rsa-sha256;
	cv=none;
	b=5Sf+Gj1YgV7MyvTbvuXjvQdOXKF5HuX/qQ/l/9B7I6CJKisgN/ShVeP9HsX5CnqLHOXOwk
	l8O+ht8GepQSJE57pLm1+U979Wwr717Y2s5fkaEUIzLPKRMsbk/PjRT/+8CiXeIudj/fng
	oP+qoN/3rqV6mWQ0qbRzf/JltkGosQ4=
Received: from outbound.pv.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPS id 854AC18000CA;
	Mon, 25 May 2026 14:57:34 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhMHV8FRQNBF0kFWBcOVk1DEUMdUhlfH1cTVhR3AlEcVg1XQ1QEX1BfHA4EVAddBV1WUAJaS0ATBEoDTV8OXh8EF0YZVQRHHl1WQxsZAlEcVg1XQ1QEX1BJDEFQbFoARxdIHV0ZWW9QXRwOBFQHXQVdVlACWktfGV1FD18HWQRADEoGQFUKRhNRVUcBVUZUHEwLW0BBXx9AFEAAWg9SVkZYGlBdBytbE1UXRgkZCF0dB1hHFEcODxlaFFwYUw==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1779721057; x=1782313057; bh=OAUuBP6zkRebfLM9QrJNQqWjPs6p9RgPPzOO239E/ck=; h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:x-icloud-hme; b=WL2xXZbDHfckumcujmISoBTb0+ebl00pFJnjao/mVaivpM/w9SuSxcjX4vG1YYS48KR8Ki48KrE8qz29mgphIc/Uq8sdCdiEEZeumscvO2vgRMokdsD7iMysjaZ2ONTaNb4ClTf6B77SHgdK++pIUciMsiABfNuKvuoLhyl+BdBVU6zws7wGPqsqFG3xPvWxhbPQRKWYcUL4WHaXNKNPyCbVmz7RjEXv6DSfF/hxlbkqw0EEiF7QUz/KDf6od85K8WB2rwILOOhArJh4dDrMO+cOoAMX98SI3V486OEY9DcSb3I4eWQyU8v7BwdJk1OgUccOyb/NAWIYg58C9T7tDQ==
Received: from [21.6.122.162] (unknown [17.56.9.36])
	by p00-icloudmta-asmtp-us-west-1a-60-percent-11 (Postfix) with ESMTPSA id 1E81B18000DB;
	Mon, 25 May 2026 14:57:29 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Subject: [PATCH v4 0/5] mm: batch TLB flushing for dirty folios in vmscan
Date: Mon, 25 May 2026 22:57:16 +0800
Message-Id: <20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAExjFGoC/3XNTQ6CMBCG4auYrq1pOwWpK+9hXPRnKk2QGgpEQ
 7i7hY0a4vL9knlmIgm7gImcdhPpcAwpxDaH3O+IrXV7QxpcbiKYKBkwRY3ubU37xlDfDKmmlQL
 PsCiNVCXJV48OfXiu4uWauw6pj91rfTDyZf1vjZwyiqby6I6Oa4XnYJs4uIONd7Jgo/gCRLkFR
 AYkAywEgCis3ADwASRnWwAy4D0zyoGGgusfYJ7nNy8/EtAxAQAA
X-Change-ID: 20260309-batch-tlb-flush-893f0e56b496
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Qi Zheng <qi.zheng@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779721049; l=4808;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=epQ75hDz8fPcEanafT01Qg369ugHk971lZ+Otj3CC44=;
 b=DjtCtFc1JD+bCh256+Arqjw7+Lt7OYL7htaFYuFbBtdOfNOPKRxC+KotCu04Is44zTT0w9zY+
 xO2ssK0/4fGDBYoNOPbJPvo+Scv6IxK3RQD7Xa1ix7fqA4OH90CXK1a
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Proofpoint-ORIG-GUID: pP4-XyGgm3Sm6KTo5vIjR22dSHqg4hmN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTI1MDE1MyBTYWx0ZWRfX/Uqrh5nTTwWF
 jeuHNlgMgUVO3ppncAJF6edAR/RJYsBEGZNkqMJgK36Pnwwt0YHjUWhRo4diNAMe2BS3wRqtshV
 vB+TuDE38c5VdzXDV1zRL5ME3N0DySo+1TRbAkG01ZiHZ4BmmRbiwWgKQlzsbveNJXSQyZQOuDf
 1dMg981z5LGkvyQaHPGmiMOdQsOH1SXhcShybWi53MQSSKcn/eiX/g/xT6SB0RclfG5FfzTPZkr
 5/NKezvLnQzXUXgt7YZYgceHB0Nw8jyxP0WhbC9GckIbQcPy0RYEUm0FoJsE6RxZi9CvCW4X+8Q
 Plmy0OQtVDHx33lcn5Te8iD7ll61X+ehP7er/HYs2dp1ifUSuXT655CdW8A5mA=
X-Authority-Info-Out: v=2.4 cv=N7Yk1m9B c=1 sm=1 tr=0 ts=6a14635f
 cx=c_apl:c_pps:t_out a=azHRBMxVc17uSn+fyuI/eg==:117
 a=azHRBMxVc17uSn+fyuI/eg==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=v3ZZPjhaAAAA:8 a=GvQkQWPkAAAA:8 a=k3ryPfxwKlxrfAMZny4A:9
 a=QEXdDO2ut3YA:10 a=J82S1U87d15UFHHUFZS8:22 a=yLjSXO_LiVxs9JEHLWbQ:22
X-Proofpoint-GUID: pP4-XyGgm3Sm6KTo5vIjR22dSHqg4hmN
X-Stat-Signature: uk33epogdy3x1gnu7gpmj7bbx69o4u8g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 58FDE40004
X-HE-Tag: 1779721058-514138
X-HE-Meta: U2FsdGVkX19Dalxy5YGWea6mk0VfCtsYnK58oe0P9tC9Q20triP3CWN9KxfwN7BsQLjAMCJkNFx3JXHRfcD789JC55MoM8x6sfWLREXUi2xhdEaEJdZULGIj2q7ei4WdfVSzpIf1JWPqR3wc6vB2atLM8DNaPJMmd3rOR2i1wIb/wZdViWI/J2JqumsLnEgYA/p4SpX5mEQVLKN8JrZHbGnSSO/D7NMlt7rjmd0uQMenSAuREMckpnBkf2/Jve29jczms5q28vO0ihqwGSdScaYTXhfStKvyQzjBwB6mGqRiS/lS6h9MlHMiaXwUQvbokjlm0dc/8icEuZ/vxAnial5V3LMUS7o/fRwk0Tc3InVdh0PVldbBevxpoPzVDp4NKpZmsyDZsZRLDZ7Hb3qya/NhE67f+z6axZY8JDiv38dxbaayJBu1FL+pP+b+QQDJG0ZO5T2UhghPhxAoqTAmz05J9mLnZuqh0AZMqHuL3gD0k0oKwoFYPGPopo3tlLjZaD8JBnbbcjI6kHglR9tejKt9wTdJFX1gVko4NItPYZ0ykT3rjeuCIQTM/SmeTm5a3bOMfhyng2VzLaVbKoVRMtMPYzw4fdCEqcxtf3SlPePtGL8ehnraffVEjswEC+uVZzzZDBeOx68+Qw09dpbwEBVj7/fz8NL7BYHGfxha2nZLUZ8qa7yUn9FNApZZQGD1m6RvHRiXBe98FGWMzftTYxCSBSHDuAv6Vosvuh2YVe8et+7GhpMf1GbDV+mxShjx7LnyYnun2hVQsIaYLBy0fcSxKO4KVPAHQL4MDYnbzjM/nf36rJGyDLRYD8vfJ+LDUcRG0oqU2enUKMC8Rr9ckb5990Ugu/1a9x7ZBkc+VMsO466ZCuaE0HLAp7pRFRe7XJ/j9oaPmTvrAeIi/aoZjsc4e1/G3yj18AbW4Q0jZfPvxeUKxD0Th+7PV4mQzdHUJDRo1+jMK9JBb+/AKIL
 c5bnHWed
 41UBfwv22JsLCudtzn9G4bibRqVx2nAU0Lt72XjsxRnPoZrYXLLtVgfNaDJF9CSC4Do3Q84Acmo6IJfWQurJVScyEILrWi2SKJO1idG7zztCQNlNKLfqhQ2zQyYAk3NbOnBrVDgo+zHkHh9ob505linNJIqyxip5SQOMqNmI3A7vP5GOj2lC6qVmmuDFC4HRW382LF++tb9r3gjW2bB3iZKqVBUm1fMLRZ0DdAr4ZiS/f1nS4zYzR/M2xR6vMPQBvClC+hj/crb6ovI1n3KyHYPA33F5bou5+DN9I1XqmnhluTDhDslVISEEgCoIX24nHJWWJaJhwJ0ahhvL0jbYOxAqUUGd31ZLN2IKFOQfw1jCIXDigVIsxrYerAwv67uI02XpAdoV97TFDGGjMkcHR25HP9R8O1I5T4m3Ms/jabIhz4QzODS0U3cT7q0mf56pS6dfL0Ks3P6newx/HDJoTJTprTXwfwalFxLul4MFveQRsxahn8il7uroe3sNt3Ig22fhoSYeP3gZAu0SBxuTuW5QHV/iJ36y0RR9V
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

 mm/vmscan.c | 448 ++++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 285 insertions(+), 163 deletions(-)
---
base-commit: d0b709f436b2788a10407624688ab8327c5ce18d
change-id: 20260309-batch-tlb-flush-893f0e56b496

Best regards,
-- 
Zhang Peng <zippermonkey@icloud.com>



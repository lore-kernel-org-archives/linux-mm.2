Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C921094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACADD6B00FF; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5076B00FA; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942416B0101; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 833AB6B00FA
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:05:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4588A13B406
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:56 +0000 (UTC)
X-FDA: 84570848712.18.2B0CB10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6DCAC20005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:05:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=obDZAN93;
	spf=pass (imf03.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116354;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5YRjRniLwzmwCEVE+CYSsB6l87VcZ4LSTHKJ+29BlYI=;
	b=LuQ1iifktG6vPQRJSrXK7gQ7LptPkP6AM4vLrZKHrjPnD8yXadj1v3dh7mO16tVoTBlSId
	6zEzVmOnYx1oWBnji/jcFyuZjj4G1NV+yVaOnoA0QzqELOZOia/5H0HDW+4qV7bQ+WB74b
	NJdYk01p/mAp0S2M0f0cbqXqgCnIQZs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=obDZAN93;
	spf=pass (imf03.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116354; a=rsa-sha256;
	cv=none;
	b=eQ4QmT22lo4nlWIGrlQ9Z9wcZgcTPmWKeJajLAehXVE47C3OJk11MkCoa7X1LbBGR011LR
	qNe+D7la2W9C7KOqTrhQPywtR5CvJ0d8RP42hbkZGUNnQK6pkwpIJvD5J9xY0rbd2ZMwfm
	xR5X8nH5X2Zu1xNEplzBDI91BGpKaVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7655F438BB;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AE9BC19421;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116353;
	bh=OhJ6m0lpatyIq6sZRtm+wGagQyf0DsJv6xzT7RU8Vrg=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=obDZAN93f19msBUHx30lyAab2UQPPTeVZx1Nhb4l/zRdYv2nGEtLAnU86ryEhnzXm
	 7mCJwBxv9WUUxkwxXk9fPrP78TGNSp8kO9IekDbPXppyxaYhu3yoiQ/8eXQbmgXXil
	 CJ6GaJyVxFt1uxNMvgtGxhrZ821WqATxC105Csmex6H+sLUKlMfmaUDk7/PkmaGRuD
	 9KYtvd3PusVGCJmPOBGx2318O7Yc0MeN6HeuYmW+WyWf+RpY9lYU1Q8uRZeRuFu8Ay
	 Uge1j0G52jCLaLo0I7s4XmQ2+CcocYx60WLmI9SCLIHJnJHaF0b+YxoXosP1HRBlWo
	 0dql4tyTeK9xQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40B7B1094478;
	Sat, 21 Mar 2026 18:05:53 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v6 0/6] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Sat, 21 Mar 2026 23:35:45 +0530
Message-Id: <20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPndvmkC/3XOTWrDMBCG4asEraMwGmsUu6veo3Sh31rEsYpUR
 Nvgu1fJykR0+Q58D3NjxefoC3s53Fj2NZaY1hbqeGB21uuH59G1ZgioYADk9aqXJVle5hzXCwd
 pMGg1jlpI1kaf2Yf4/QDf3lvPsXyl/PPwq7hf/6Wq4MClcj4Eqcic/etvmtNVx+UUV3bHKu4B2
 QHYABwtTsIpEAA9MOyBqQOGBhBNENzoPHrTA3IHiP4D2QAr2hSMIUnUA7QHzh1ADTAmmEDSEqo
 nYNu2P/9KvpqyAQAA
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774116351; l=4768;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=OhJ6m0lpatyIq6sZRtm+wGagQyf0DsJv6xzT7RU8Vrg=;
 b=uwYvANP/dja0XGFc7KlThSjjiiUtFnlvvTx6n2pI02IFSq5+z9+gNj9xc0G811cv0ZQwGbrSD
 d4T3tkkXceaDpZH6EQaUXZPlEE2R2r/qV2pUR3gllJjpOmCJH6Q//65
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 6DCAC20005
X-Rspamd-Server: rspam07
X-Stat-Signature: gg94g34qzx7s3xqpmgy7b1u8jwrxjded
X-Rspam-User: 
X-HE-Tag: 1774116354-193654
X-HE-Meta: U2FsdGVkX1+FWWRu0yUeRLk63pBW9zTyRSvYHeogJmwPUvdjiXYT2ZJ3czWf+EA2at1Tr3lE+9GzGJV+KHyOjxx13D6um/Qv3MqcNY8nAih2Ro85ykHUZ6RGYmQIvK+PrCiZu4EZ/6aEsULM7GQ8MFBlqo0JzgRX/0a9eaG+vtpX9fSGgoa7xfVTeschQMd+gIykIzjB+wUCg1Cq+JDHo2IzmCJUwR3JyoTfuUPDl+ZJq5XngsRh5W+y5MH3edKukSsDWmoJvhhgA47qJuXUDqupRzjNCSl+A/VbBSbz2/aVslsaLpNjtcb80Zhs7mdfMa89uF/jiiOCT+YGTFFKkFtVuIKFXWNib4mbfeNgVA1+Gi/mEJxR+1sSl2xQ8pkzSl79OMs7u6Ps4ve1baOP4yuZjx0zUeHfndW3kTDClSkqK4jrHV3c3wUBjQWKUM05e9Nb+Uy3FuKLIdzQi8wdQRwW3yd8uqILO6eIVL95BcYI0e5GWwiccFKA9z7u982R2R53+CA5hZjsjTikwBX8uQ7nB45NtZvYcdgYuzgi7WaLys4m/m18YPIzYIb08TrbVlp1ueGYg/35M3HjoX/4+qJVZ5tM/FHGb/Fe190TStsWFUlV+Ocpa+E1zLfWA3IH0G/6k9ZwYgGj5LzNe8LQLehF03bnZMbHQNtZCyjC/qE0JpQuxxJGX2VNl5LMCACm22atGRpxtfpElqyauRWXvQVTHtv/DjvnP6H+Rm4kc6LYTZexSOG7V8zElFqJAh9wLPr7MmGoU/pONd0kAlSZsK7k2Wpo69oSEgxIy0SKHyIPQ1JZ7+4KfacssjfGQr5Wgs+ptwOZQrUSzdgYe9RZqF343Q/3rK8a2hy6BHVu6Vr8BxYGca90KcCnnrIIIgi/NlV2ptu01uRbkyzZjDvTNFaL+dFp2yQX0jKipJokjKeHsOwX35fAiNZjfzipgbITOnVeRLijd3yMxLKUOMH
 GJu2zU99
 QQFy7kEa+ngrWJv0KlPuqMEuQ3sB3WMvetd4fLwbuCMsaQmMB6HqUsPY7ZrybpMvAjeUU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series implements the TODO in vrealloc() to unmap and free unused
pages when shrinking across a page boundary.

Problem:
When vrealloc() shrinks an allocation, it updates bookkeeping
(requested_size, KASAN shadow) but does not free the underlying physical
pages. This wastes memory for the lifetime of the allocation.

Solution:
- Patch 1: Extracts a vm_area_free_pages(vm, start_idx, end_idx) helper
  from vfree() that frees a range of pages with memcg and nr_vmalloc_pages
  accounting. Freed page pointers are set to NULL to prevent stale
  references.
- Patch 2: Fixes the grow-in-place path to check vm->nr_pages instead
  of get_vm_area_size(), which reflects the virtual reservation and does
  not change on shrink. This is a prerequisite for shrinking.
- Patch 3: Zeros newly exposed memory on vrealloc() grow if __GFP_ZERO
  is requested, preventing stale data leaks from previously shrunk regions.
- Patch 4: Protects /proc/vmallocinfo readers with READ_ONCE() to safely
  handle concurrent decreases to vm->nr_pages and NULL page pointers.
- Patch 5: Uses the helper to free tail pages when vrealloc() shrinks
  across a page boundary. Skips huge page allocations, VM_FLUSH_RESET_PERMS,
  and VM_USERMAP. Updates Kmemleak tracking of the allocation.
- Patch 6: Adds a vrealloc test case to lib/test_vmalloc that exercises
  grow-realloc, shrink-across-boundary, shrink-within-page, and
  grow-in-place paths.

The virtual address reservation is kept intact to preserve the range
for potential future grow-in-place support.
A concrete user is the Rust binder driver's KVVec::shrink_to [1], which
performs explicit vrealloc() shrinks for memory reclamation.

Tested:
- KASAN KUnit (vmalloc_oob passes)
- lib/test_vmalloc stress tests (3/3, 1M iterations each)
- checkpatch, sparse, W=1, allmodconfig, coccicheck clean

[1] https://lore.kernel.org/all/20260216-binder-shrink-vec-v3-v6-0-ece8e8593e53@zohomail.in/

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
Changes in v6:
- Fix VM_USERMAP crash by explicitly bypassing early in the shrink path if the flag is set.(Sashiko)
- Fix Kmemleak scanner panic by calling kmemleak_free_part() to update tracking on shrink.(Sashiko)
- Fix /proc/vmallocinfo race condition by protecting vm->nr_pages access with 
  READ_ONCE()/WRITE_ONCE() for concurrent readers.(Sashiko)
- Fix stale data leak on grow-after-shrink by enforcing mandatory zeroing of the newly exposed memory.(Sashiko)
- Fix memory leaks in vrealloc_test() by using a temporary pointer to preserve and 
  free the original allocation upon failure.(Sashiko)
- Rename vmalloc_free_pages parameters from start/end to start_idx/end_idx for better clarity.(Uladzislau Rezki)
- Link to v5: https://lore.kernel.org/r/20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in
- Link to Sashiko: https://sashiko.dev/#/patchset/20260317-vmalloc-shrink-v5-0-bbfbf54c5265%40zohomail.in

Changes in v5:
- Skip vrealloc shrink for VM_FLUSH_RESET_PERMS (Uladzislau Rezki)
- Link to v4: https://lore.kernel.org/r/20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in

Changes in v4:
- Rename vmalloc_free_pages() to vm_area_free_pages() to align with
  vm_area_alloc_pages() (Uladzislau Rezki)
- NULL out freed vm->pages[] entries to prevent stale pointers (Alice Ryhl)
- Remove redundant if (vm->nr_pages) guard in vfree() (Uladzislau Rezki)
- Add vrealloc test case to lib/test_vmalloc (new patch 3/3)
- Link to v3: https://lore.kernel.org/r/20260309-vmalloc-shrink-v3-0-5590fd8de2eb@zohomail.in

Changes in v3:
- Restore the comment.
- Rebase to the latest mm-new 
- Link to v2: https://lore.kernel.org/r/20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in

Changes in v2:
- Updated the base-commit to mm-new
- Fix conflicts after rebase
- Ran `clang-format` on the changes made
- Use a single `kasan_vrealloc` (Alice Ryhl)
- Link to v1: https://lore.kernel.org/r/20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in

---
Shivam Kalra (6):
      mm/vmalloc: extract vm_area_free_pages() helper from vfree()
      mm/vmalloc: fix vrealloc() grow-in-place check
      mm/vmalloc: zero newly exposed memory on vrealloc() grow
      mm/vmalloc: protect /proc/vmallocinfo readers with READ_ONCE()
      mm/vmalloc: free unused pages on vrealloc() shrink
      lib/test_vmalloc: add vrealloc test case

 lib/test_vmalloc.c |  62 +++++++++++++++++++++++++++
 mm/vmalloc.c       | 121 ++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 154 insertions(+), 29 deletions(-)
---
base-commit: 3b9bd243689fa0ab95062ab53f6c5aff90272056
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B554FFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0279D6B0092; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F187F6B008C; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C315C6B0092; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98E0F6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 064F41B8CF9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:29 +0000 (UTC)
X-FDA: 84705463458.10.65D8E7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E7C80C0008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/wAYNIh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777321467;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2Ai4Km380hFUiuAj7+ePAIVy2/JJiH8ff6gLiNniMX8=;
	b=LmFYPxm3vttw6Q8cuiC1u5dMt2AuYyIjvWbSkEeZGi3pG791pgiDqJ2AfygmtAg1ShzBDp
	GAzKN6S5Ah68oPxM8YxmxyNlK2k0I7XchKl4SMG0UTbLG7lN5r5bL0P29+dqsoSWORkIE8
	6qgntKm5r63WZUVxXCvslYMJ3ozC2SE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777321467; a=rsa-sha256;
	cv=none;
	b=cUhOBPanifaH7UwWAF54tJC7TjOJvBL0b2lA8J/mttgYug+QuT9J5hRu3BxjZGuxwO0ixL
	T6ElwBxROhGJdicbEdQfGjEGguKlAGsnuyh+9KDXdN3UL8yPORB22+rweREBInoBZrKNR6
	pISRi0NXmcXotu2mZwXil/y8mjDvbj0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="E/wAYNIh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F3E6240286;
	Mon, 27 Apr 2026 20:24:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFFC0C19425;
	Mon, 27 Apr 2026 20:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777321465;
	bh=/vbwUZlEvQW84DNFF37oYxnG9tvXZo2w8ipSb1Z3yhE=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=E/wAYNIhV4ISRRuKXfcztAq6qQjZLbGsLRx1sTXt5KI9cg/WRjVUi1N4YOPmIixe/
	 rheNUng86a/7k++7t++/7blk/s75FoC0OvCY1rInjE7RrWBEZhg11+gmZqXXUxyfGI
	 Mjfn13MJLY+1EdY1elTH8IV42yAhhGcbf5wUFptVPNqW3NMSzDomF2Jzc3tIAD5hKE
	 RRaggm4BYUr1n6lSxSnf6UNe7vfBB/eilTa9jc0fE7ktab+NS1jQw9b/z3on8nfaLs
	 HngYthXhsQxO+Frjl4/XsP9UWnDIzCmfQEeS/P0tx1Bp8ABghWM8IJyMBL8TpQENKq
	 jM0l317jT253w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AE3FF8870;
	Mon, 27 Apr 2026 20:24:25 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v12 0/5] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Tue, 28 Apr 2026 01:54:15 +0530
Message-Id: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAO/F72kC/3XSzU7DMAwH8FeZeqbIceN87MR7IA75pBFbi1pUA
 dPenXQXIjyOtuRf8rd86da0lLR2x8OlW9JW1jJPtRD4cOjC6KbX1JdYGx0CKhgA++3sTqc59Ou
 4lOmtB+kxO2WME7KrQ+9LyuXzJj6/1Hos68e8fN0e2MTe/ZfaRA+9VDHlLBV5nZ6+53E+u3J6L
 FO3Yxu2gGQAVgBNQCuiAgHAgaEFLAOGChBZyNHEhMlzQDaA4D+QFQiijoL3JIk4QC2gGUAV8D7
 7TDIQqjuAagAUDFAVAIXBaa9D8sgB3QI8gt4jQFLoTaJoBg6YFuARzA4E5UkD2RQ1B+wvIIFHs
 PsOMpmYvbU6Gg4IaAWeQdQd9MNAmqxQFLO7QzTHKBE4sV9jcNGABzA0/CGu1+sPsrMFlT0DAAA
 =
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777321463; l=6375;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=/vbwUZlEvQW84DNFF37oYxnG9tvXZo2w8ipSb1Z3yhE=;
 b=2Ntb+k//yx8QwJXeldKc/dtUE3xI+gBZYj+98N9m1twGdvVBYPZpSegt/58A3629yLTygym7g
 wo/NtfZgpFdAXNXlzPKIUc5kXcqZfv3WOOju79J/9Uu1ymXxPfGV6pH
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7C80C0008
X-Stat-Signature: jakbpq8e6wtgdini8t7yb6pqi1wgziku
X-Rspam-User: 
X-HE-Tag: 1777321466-469254
X-HE-Meta: U2FsdGVkX19uBBhdc2+UsMIMg7Jw3K/ssoUD5DL3VCOU5nujRdV+jcPBhPLIAORDdJ8M2qcwQmH8GujWoZOi5rm06mnH042iQQRrVeA6heqHmkmxp4hcF5MGk+YRejceyKx0CrVMZ714hbbBZypXdHtHTFs7DMZlNR8vMFc93XoA038UiZrnuMw/MpdrkZq8ftWTT36sT2xOBfR6iD6jD08LrtAkB7/4cttPfycGcDo7g+YVybKnki0XZ/2D3InHJQeTTPzuKGxYubf6YksDwD7b5CmdIx6g1mIeNQAB6HYoWf5XAx1Ffzu2KLTEvigAKwjwqoMK4YoXgvhf7L3irQ9Aqc3XGVPKB5giB1MwhQfcIRRgHXmRs+musiMc7PYxK2pEuR7IGK4UoPOusf7+O492eSnHZgakRlbeilRe4T7rnA/j6UfG1vrXpfKHIr6bXd0paKSHGC1RODXGeg8dVXDJULNzM2oP/ikXbp5TbJx/4MdhdxEqA1NlxwN25hMIssnUoEC3waepQyOdZmetsximIbIRLVi+Det/nux4MdId/DA8shNVw9sV2vegQkSf2aDcRLiux1jr+hPNM8QY9sJ2ZX+/7IlimCcqwe8eRriyFw8CwhvPEsWWbIJJhF9sj0jf97fgw3l6vsop+D2pNBFBkUSGSCkLuR4Kj57S+kRUes7kmVOU3UXxjLYZ8H9QTAEw2xQfd8sW3C507jhCmcWiCYs1Ejm0ZW/ZavzevKvWKBAixhp2Apljy4Pf5LsGH506QpEz3Mlf5gbjV/wsWIW6gWWuu8fXVgG31LNJHT9KnoqYLl+tHNd1VfGNqG1tcp+XwTV6gphvtUKDROtAn58Kv0mdOCH6k21ipnX7BcByILxFS/UcLuqW6UM2hIx2KL6WBuDFLkmHmXg15dIwn1mx0qPsf4Gldip/h1i3MlQTxqdPjPQPOmzuupoSkaFswAl72DwtS49QFOO9/ce
 Jy/voreQ
 SL9n2UU476rQ06d8eUY2OJ4vYeEs5GsnDL5Jpu/iv/pAE1zF1qFqHHa4SdR2JQlzGoNM3hc14ZqizWr+YAY2Y0cRZLxCI2T4Yg/kLYVAtM1ldY8XvmsJOX5aSnZHGHYGJYtRyrrIMNU3w1jFqjYTLgfCdWjDouipxRW5qf/+mbdtmuRjTNRZGBckx2743qGBTut1hrzQkEAmN1lhtOr5X8eZzi9TkZjyHx560+KN0Ac2ua0mGCtiIeeX1+V0D3PjatToG7EbjBr59R7cKSTJMV/7qDABEgTonjX+PrcYvY54r9eC9LaZFlK7qTqA0V5+P0vs+tZ+14nAgCm3jrWXwsBUPw/BKmW4id1V5bsFlCxEBox6FbGzUGxxIcaKqgh5ubdd7Nw1sV5AdHUTUEWrruy4dDPkGm0YDslU0q2r57wX0TZwvGRVfScnSU9kKdFgaTML2
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
- Patch 2: Update the grow-in-place check in vrealloc() to compare the
  requested size against the actual physical page count (vm->nr_pages) 
  rather than the virtual area sizes. This is a prerequisite for shrinking.
- Patch 3: Update vread_iter() to derive the vm area size from
  vm->nr_pages rather than get_vm_area_size(), which would overestimate
  the mapped range after a shrink.
- Patch 4: Uses the helper to free tail pages when vrealloc() shrinks
  across a page boundary. 
- Patch 5: Adds a vrealloc test case to lib/test_vmalloc that exercises
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

Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
Changes in v12:
- Rewrite vm_area_free_pages() to use free_pages_bulk() 
  following the upstream vfree() refactoring.(Andrew)
- Drop Reviewed-by tags from Patch 1 due to the rewrite
- Rebase to latest mm-new
- Link to v11: https://lore.kernel.org/r/20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in

Changes in v11:
- Prepare vread_iter() to use vm->nr_pages instead of
  get_vm_area_size() (Uladzislau Rezki, Sashiko)
- Drop (size_t) cast from nr_pages << PAGE_SHIFT (Uladzislau Rezki)
- Link to v10: https://lore.kernel.org/r/20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in

Changes in v10:
- Reorder vm->nr_pages to the beginning (Alice Ryhl)
- Link to v9: https://lore.kernel.org/r/20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in

Changes in v9:
- Remove READ_ONCE, WRITE_ONCE and drop commit
  about show_numa_info. (Uladzislau Rezki)
- Update the commit message in Patch 2. (Alice Ryhl)
- Remove zero newly exposed memory commit.
- Link to v8: https://lore.kernel.org/r/20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in

Changes in v8:
- Strip the KASAN tag from the pointer before addr_to_node()
  to avoid acquiring the wrong node lock (Sashiko).
- Rebase to latest mm-new.
- Link to v7: https://lore.kernel.org/r/20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in

Changes in v7:
- Fix NULL pointer dereference in shrink path (Sashiko)
- Acquire vn->busy.lock when updating vm->nr_pages to synchronize 
  with concurrent readers (Uladzislau Rezki)
- Use READ_ONCE in vmalloc_dump_obj (Sashiko)
- Skip shrink path on GFP_NIO or GFP_NOFS. (Sashiko)
- Fix Overflow issue for large allocations. (Sashiko)
- Use vrealloc instead of vmalloc in vrealloc test.  
- Link to v6: https://lore.kernel.org/r/20260321-vmalloc-shrink-v6-0-062ca7b7ceb2@zohomail.in

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
Shivam Kalra (5):
      mm/vmalloc: extract vm_area_free_pages() helper from vfree()
      mm/vmalloc: use physical page count for vrealloc() grow-in-place check
      mm/vmalloc: use physical page count in vread_iter()
      mm/vmalloc: free unused pages on vrealloc() shrink
      lib/test_vmalloc: add vrealloc test case

 lib/test_vmalloc.c |  62 +++++++++++++++++++++++++++++++
 mm/vmalloc.c       | 107 ++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 156 insertions(+), 13 deletions(-)
---
base-commit: 4f7b2cc1ad8719d55a8de9675a0aca65cb17c364
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>




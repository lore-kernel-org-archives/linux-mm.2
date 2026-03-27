Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AEF510ED643
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93F76B0096; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6B26B00A0; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73566B0096; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 904616B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3824FBDEFD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:43 +0000 (UTC)
X-FDA: 84591368526.05.FBE30E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D565A000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="D/MhzzJq";
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G1r0p9SLKV6dnOXxoRV/RidwmH7OQccbfzpH3rxBRxc=;
	b=PzVmN5oA9lACk1/FIIdqFPowkaBNWLoZYmXfxtYm5XXBWR4XFGv9Opv9bM1wQepxzDFTe4
	b8Goen2cFrfpFmpFdNVMfvCCwrF1RJAREIj6KOI7VNDrh/x9m8Nai7XOKLF0it3rzDa2qw
	McJg8eHtVGcJu62tkh4wpVP8PS4Kpi8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774604921; a=rsa-sha256;
	cv=none;
	b=HssFwZLWOqypto7+QKP7U7kcxgKwKwoNTdQRyiGBcPhjV0MGV8stall/FY35pqNzaIGYve
	X+tvPzX4kq4sNTMVS5eeACT7IRknP40u6LWiJJ9hfqrZxEZ2tMtLDpSNQk7+JyQIFIIBlw
	PwQG0ue1mHk7Y43lv+u9LzRuYZbP4Jw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="D/MhzzJq";
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4254F40DB8;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D0A5C19423;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774604920;
	bh=+TJvotV/1YDLcmByd8IU2fgFVMxaHE1F+vCxCRlc09c=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=D/MhzzJqbO68yUUawqfp55rmMOB2DROdxg3HKYHhVbm4N046GZSfIJOxkOkXqzOFl
	 bSPn/X5yAz8kr4E3LbQ083T61Ibcv73aKSrmjMHc/9h4Wc26SryeqhbYYVeTJx6bNi
	 +oeTNG7qwsvAjyBafXeDd0lDFUuEs8OQeV5qb1hp4ZVYL4PiIDbXLy2RXdhUYkLJaI
	 ijd8dCJyFLyhyjKYfd4L3RwGlfvrAD0uIwluag2rS2Z0NaqjMVrpKh9Kr7dpavUBHF
	 8r+ZXK8MQEalY3vq53/Rj5cpn3Gj1s7cvKySUzOvR6MzHI4vLWA+4cXWjh/yALh/6q
	 c9Q9RiHjaj6vw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0140B10ED644;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v8 0/6] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Fri, 27 Mar 2026 15:18:36 +0530
Message-Id: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHRSxmkC/3XPy07DMBAF0F+pvMZoPPErXfEfqAs/xsQiTVCCo
 kKVf8fpysiwvCPdo7l3ttKSaWXn050ttOU1z1MJ9unEwuCmN+I5lswQUEMHyLerG8c58HVY8vT
 OQXpMTlvrhGSl9LFQyrcH+Hopecjr57x8PfxNHNd/qU1w4FJHSklq5Q29fM/DfHV5fM4TO7ANa
 0A2ABYAbcBeRA0CoAW6GugboCuAUj2kaCMh+RaQFSDaD2QBgihV8F5JpVpA1YBpAFUA75NPSga
 F+g9AVwCKBtAFAI3BGW8CeWwBUwPtBHNMANLoLalou9/Avu8/RnKjjzQCAAA=
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774604917; l=5566;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=+TJvotV/1YDLcmByd8IU2fgFVMxaHE1F+vCxCRlc09c=;
 b=w0rxUYcQMKZaAz/3JxUGKLJy3ZCYctCWHyCgW4Q5EzLD31GSyDpeUBhVVGq0SCvdAVgxq1pgS
 bFuDYcx3bgnDTr7LmRw/vRIRjD/LyIejbcVO7KOIPc5hSmYPq2LyDGJ
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam12
X-Stat-Signature: qc91p16hhdngfy6f34zh8yojccwy1gxo
X-Rspamd-Queue-Id: 2D565A000D
X-Rspam-User: 
X-HE-Tag: 1774604921-624748
X-HE-Meta: U2FsdGVkX18q4KNCY1EegproxvElP1PR+7gzhfNkdtmacY72S6VAmTKaMLpzCPxY46XPVERTmyRNknbcZZnLRWGX8ZIw/DrDVQDcHZhhdUOJFZx1x+lnGxgmMaqbVYkkm7xsSvHNXCU1RtZhlXvnailipCNFHBOaWt98hh8WGDIfUo/OpO5mQabw2e9XuZO6GrPPaiavjpgTpXm1aEtd7dgGvWMUweEChPcdcPMTyDjG5lMEnwwzGsRaycdNT1qUoF+q8zJZBPEcaKmjI5r86l9M4XwtEDgp1hQL7a9RjDaJa4Lx7MHfieAe8sp7nvHtM4K3oEemhWgwvitwg0PGIx0bOLNUgGajxZGzqQgHngW6MngfTA7UFovp/ddBTOQfi3d0aU18j7QAOKi8h1nKPIjyTrc2rumi6OJetekykKrtGqSKmtCeS61zQgPvHdGnA5ONdc7hAq7RQrw46mUO8WgxGteq5J2fcDAv68lcMl5RHX/QbrObxbTVEc5y0gvGNxcxpTGQdpkayakxyEIQJbD8mp0shaGBfNLQ1eoX4G408aPUqyIi/NN1hYblryjqdiyZi4TBACmZhxQMvfmOzufE6tCS9TNP7mFn0Jv7Fe+VyiRylLrqVl15lWyVilomL/JYDHlnJ2ek3opxU/f46YOCBEbIQt9cpquzLZs0VNjK+8J/krUn+OMqhczW4WzQhz1QEqIeYvpqyE0aM3KwHxeoEzrqiWWHY9mst6f74MBVXEEXvfmKwtN/TD8UwbYRMP4XQ27qFLcQ5WqrxDuxTlvuaZvWKUA/Hb+DHseE5KxiHeV3m98l+5XDLpPEgSr4i3TgJbuL0cLdtHJBcTE9igQ45YP/igaiOoQ0dpB3TjoIw4rrnSwiifEI14FpAK36ukZWHWgduAeJN0rZUZrTPtu0jJPMVl1LwRT9rNdBEMA8Wc5b/QQeFunnDBmezwgE2JIuoktZlxGa0yPUCm9
 5Jo9+qVN
 ix+LFNx70cOeThMyLsXgEAxLSLpjTBcBJFueOejGspdQq7MG8wzl/Q7Y5zeK0HwrRfAB2sPBIoXMPWhWczrSnCtQ9x2DoTYGGkUqlKPeCcm6FZ0hY9QTRcxpZLoPps0BRye8L8OwwiG8LVqzMcftRtLYs+ySnQHKTx2AxowHK3Nc180bvXK6zJXJW+TXiaOc56GXbJxCL0Mwmld0ViBgb0uVAJzObShAN+YH4DpZiDQ3YzJIGUuCd+n6mpHYH4L3BVA7mtpb7bvQoaqve1YKjlAeepmX1u1feGP011D0hM2cOqMkNw7YwyCpMO1mQg4WoPNjdLyPfLcgMYyTSzZNT4V6ZTjLjkS0tHNiLZm9u9T+XvaOKxdftfgwDRzoXuYifZO210uMV0cZMOLQf7FdSLyp5SNqI8czEE4Y8364Ik7X7TQoG/HiK+a4WLpoMGIgjc3Hx
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

Suggested-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
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
Shivam Kalra (6):
      mm/vmalloc: extract vm_area_free_pages() helper from vfree()
      mm/vmalloc: fix vrealloc() grow-in-place check
      mm/vmalloc: zero newly exposed memory on vrealloc() grow
      mm/vmalloc: use READ_ONCE() for vmalloc nr_pages status readers
      mm/vmalloc: free unused pages on vrealloc() shrink
      lib/test_vmalloc: add vrealloc test case

 lib/test_vmalloc.c |  62 +++++++++++++++++++++++
 mm/vmalloc.c       | 143 ++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 175 insertions(+), 30 deletions(-)
---
base-commit: f46991f1780ef97efff3b668627b763581032067
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>




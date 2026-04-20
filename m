Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123A7F5A8A2
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 16:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42ACA6B0089; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F99C6B0095; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD8B6B0092; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 074656B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:57:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91BCCC3483
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:22 +0000 (UTC)
X-FDA: 84679539924.09.D17C5B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7F6AE14000E
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:57:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AyKABs7J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776704240; a=rsa-sha256;
	cv=none;
	b=OspXHUU52U4uyeyceR//nb2kdLOKHVDYEaTlzOK+D4z4IjupwQ4VdDZsUxcfshk5O2QvzP
	0o7AUc9fhvJm1Yozs9EWemO0p/JdCrm1bKzGKV64LHW1OlgD1KbYYbqeKVInQlli1R82eG
	I8NafDnoyqjgidFiavPh7TjNCQJf0Dg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AyKABs7J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776704240;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QF1vpoSJyfgOydyOzswUIpOlUbTYvQEmXjHBtzDino8=;
	b=3BTPwQsaSPF/Jo/Otv5IC2Skzwz2CyXJWdlU+npOoJB4Aze50f6loFzDaL+Y/vvmZJqLJQ
	OB0ZaOvZpTc2OQOPwawwGehzM2POB49REPCSFrSIkZq+i/nEtrtJ4npeD9Q1u3Ge6EmHm5
	kS473kC4oSzFcd4EwmOqXxJy4ERYXrA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6993743FCF;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43A1FC19425;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776704239;
	bh=a/eGynaEpRz7wkViM8K734IGGUdqnv9E3or0+KxAdiA=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=AyKABs7JKToaBjaJvZoNPoY2FufullaljBZBkgeD5F76TGL2h3knDDqGAbiwg4DRs
	 9Jo9tvf0fsM+RnMUmEo44CbkOXbGvTnS1WlfsvRjpvBX5iA0D8KGS0Zmvx6ONLxKdg
	 uIgY3eSpn4qZ3eIymMlZseZsMU3i7qJintiVUQ9XLXqjIaHwLQMDrROooAVcHqI7N6
	 5k1J2HrH9HayUBeiqkhVN3Jc2NIXZiqMT1WrUxATveKDHeJQUohK6pGJREFuCKuI6h
	 2DkPLdXxmSa5dqEbXEFFWFeLVokQBII0RcOkjV6wOEjc6U3sq5ZGFC+u03eCXlOp4X
	 NMYwHHNgh30rg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32165F55805;
	Mon, 20 Apr 2026 16:57:19 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v11 0/5] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Mon, 20 Apr 2026 22:27:08 +0530
Message-Id: <20260420-vmalloc-shrink-v11-0-cad80b00853a@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOVa5mkC/3XQS07EMAwG4KuMsibISeM8WHEPxCJPGjHTohZVw
 Kh3J50NQYalLfmzf1/ZmpeaV/ZwurIlb3Wt89QKIe5OLI5+esm8ptZgEqSGASTfLv58niNfx6V
 OrxxUkMVra71QrA29LbnUj5v49Nzqsa7v8/J5W7CJo/svtQkOXOmUS1Eag8mPX/M4X3w939eJH
 dgme0ARQDZA2iidSBoEAAWGHnAEGBqA6KAkm7LMgQKqAwS9QDUgijYKIaBCpAD2gCEANiCEEgq
 qiFL/AegOkIIAugGgZfQmmJiDpIDpARrBHBEgaxlsxmQHCtgeoBHsAUQd0AC6nAwF3A+ggEZwx
 w8K2lSCcyZZCgjoBZpBtB/wYUCDTmhMxf8m9n3/BqEmKLr6AgAA
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776704237; l=6058;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=a/eGynaEpRz7wkViM8K734IGGUdqnv9E3or0+KxAdiA=;
 b=dBRX7CqsIutUBDFJ9z5STdxUxUGuixfsRBjF54OKmW/COmrLciHg0ESXUCQX8zv15O5ilSF2r
 oRxAH0gQUvaCJduA62J9YwVbUbWl9rigbm6TCmJE+ZgRobFqf0x0gi1
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam10
X-Stat-Signature: 3wruztgqpwft3qmwaxawjh4ip89h1che
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F6AE14000E
X-HE-Tag: 1776704240-858417
X-HE-Meta: U2FsdGVkX18ysKB2elBTefrmMslRG+1DfyPbjcIDSX4Sh9OqbYS3ht1BYgrcEXBiJTuntPEQG814PGkcUmY3n7GCHaAElRG1yVTNhUBcHX8aH7hQ4J+6FeOpBK7yQz7hMIeC8QAaDzMg9174TPj/f9sajKhADKifLCogN5SEn8GyDHXtZX8ylGLQJp4MvwoiEtijQJXI7CYjVnckI4bLpsAL7DDThMa0qnTP9voSKvGNIJrVeBEtFZwkrVfisfcyQfEKgXsbqpzTXroRlAePtd9l45SOj4eTNf8Yv2Lnm8H3MRrmfB5Va2j59Objj1CAy0GYIQUyI2Th4v6AA6ahnK7piZlVjy20pkriS48qwLYK5DPCVtUXzjHhYViAfQ1SiVIsqvcErSEwm40LIZ04IHLRNf/XM0a6Calt517jsIFlZyLjQtYu02PxWUjFvmImCpbY16rTraVj2SQdedQ5UP42yB0YTg6vzrCe5qogLZDBeup7WBzMsoKcMsDaxJqz0zOX4+BiTbv7Mf64pkxJKU2Xx4qVOE9pbmqUG87LM2isOmREjGAlLp+l4fZjnOCdbxUW4b13f9Ot3+i749/v/jUP6mEKXc9hvw7Qw7H9zWd5qUvKUbu1DmdqWVeUh4cI8yfsGATQffD2W+17BOrqv43L41qOJMg/tyOHkUTpVv08Q+gAnjRHgaeOrhw5kBWEFRygfXX2XTh5XVg4WEqP707dEuY+/2+RPtODNXulzmpnS4OrtkMnzWrSpZp4XpCSE+ysZlp0T9VCm15Pzr3YShgGaQbkM87Zp7YXSwtEoLfus02UCKTcWKxA9GGjBwtFHBJ6URJqJNGB5xERItB7xXEazvVbxnbE/GHoQdWSbLN0axmVrcTpsOQC8FJdy5g1QxmjwKau7C4TawjqS7JBD9lbDGWuhM9+VGtl2a4vps3UrH8WxHg4wiTi3kUsGenAV1B38gDk391llAyEXMJ
 nMsXf8UW
 lPQi2rs2kzPqp1M+cJuc25b49TpCIYgzZMgu5sQUrH3sh+PD+qjLje/eWyaXFX6aACOTfKKYJ2TruC582Pnx8iuf+7pF5Aaq6oAlRQmGW8rUZmnqyV1emrrT4wYSl5etQtudI9Huc0ZsMAY30V5tCsWTS9meoM17mYlcwQcIMchSodCBg0smFNtgWrABBnK80h6naak4amFWmk2pk8QSrUQqTMMC0bkBw/PfsYxxWPLzAAMb5WvaUTVounl1uSI/xdEUvcJDZic1tlh1sinWa3CHqPnwjHYKhOqY+Ck3VNSb07u8HPNp4MM4VkpYtmxEWAYPehv9tYNxAWh81+A3nZOyojDjnwQ1syuM8BzOrFr8X2xV1gs4MXvDcjP8b1JWkJl8gxeUTpVPzbP2aXTiqSNxvbuj/35qcLqe3T/A8sIhhAhsDjU6T66sC27jzftVrOJZI
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

 lib/test_vmalloc.c |  62 +++++++++++++++++++++++++++
 mm/vmalloc.c       | 120 ++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 162 insertions(+), 20 deletions(-)
---
base-commit: f4279f87cd6c82ebdaccdc56f38e7b80ca7fcc03
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>




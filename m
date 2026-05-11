Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33F76CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52D96B008A; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FDC6B0092; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E53F6B0095; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF336B008C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA9C3405CD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:42 +0000 (UTC)
X-FDA: 84754435164.24.E459FE4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D60F5C0009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YW3A45lo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487461;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3n9EIs1PZd3g/4L197BcweXDoMLIb4a1GX/V+q88JiU=;
	b=KiWuSsAr5bczqroIuDI6RmEQbKiJc/PKCdZRa4tPWlko656oXh2RBPyWzaxEpVbqrb3Qw0
	nqkDZ+a+pi5WunFXwruZWdW/KRKllvICgrXY+NroFfVzZq5z7pIpzF22eczFPjVS14RKa4
	k/Huwj4FKd9hkkkIGKiMVwNV98ZLh3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487461; a=rsa-sha256;
	cv=none;
	b=iulD91Iz3Kao4Q2T7HHCNxy4SBdEOGJ8b8pxoyGRacF+CQCBEXFvxtotGHwvjhGsFbz2PF
	LqOHrxvwxVVdl6bhsiIWHEMq5fWBVKEtKDM7ZQUvueMrtqUTkJ2zraQlbSpYfmg2yc2FhX
	huThvwPNH29xH+yNM0bIJh8EC/G4nJg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YW3A45lo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AAF1041A47;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8732DC2BCB0;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487459;
	bh=SvuXqptQt9nPmld8/PMy1TBngrAvTLG7sZtYZYk7amc=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=YW3A45loz/zTHoqJ+cd/98WeaiMvKA43MXajRfiOg0UMaHUC3xg5hIgIELJj1+u2I
	 JdgyFgiVTkro7JuNrSAamfKmll16ZFNlHVANGIOYJFEqkObm2EZq2wywrWIk0sDQiZ
	 4ekrzofjzC7UpQxZrcM2egac1XeWjEYRrt7p7V/JQ4YuLhENqkILJh2H+Jd2en8JRA
	 4qsNScfFID72vTkj0u+gfr6SYxT6y6aFe6mcp2sGPVaIgj617r3EN0w5nrxYSn5/2a
	 Zs3G8b/bPxCNjdZtEvUrtTHeM4i6/4SYbvlE+tNm7IkfmKP0sMda9NkOquvB/bKIR2
	 63WkLgmPw07Zw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7112FCD3427;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v13 0/5] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Mon, 11 May 2026 13:47:28 +0530
Message-Id: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJiQAWoC/3XSS07EMAwG4KugrilynDgPVtwDsciTiZhpUYsqY
 DR3J50NQR6WtuQv+S2fhzUvNa/D4915WPJW1zpPrRDy/m6IBz+95rGm1hgQUIMEHLeTPx7nOK6
 HpU5vI6iAxWtrvVBDG3pfcqmfV/H5pdWHun7My9f1gU3s3X+pTYwwKp1yKUpTMPnpez7MJ1+PD
 3UadmzDHlAMwAagjehE0iAAOCB7wDFANoDIQUk2ZcyBA6oDBP+BakAUbRRCIEXEAeoBwwBqQAg
 lFFKRUN8AdAegYIBuAGiM3gQTc0AOmB7gEcweAbLGYDMlKzlge4BHsDsQdSAD5HIyHHC/gAIew
 e07KGRTCc6ZZDkgoBd4BtF2MEpJhpzQlIq/QXTHqBA4sV9j9MlCALAkbxHYE5YT+z3KKGx0wrR
 rEn+Jy+XyAwwy4j+AAwAA
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778487457; l=6689;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=SvuXqptQt9nPmld8/PMy1TBngrAvTLG7sZtYZYk7amc=;
 b=db7GVEyhprtcroEpTQee4MgBbsop8ITBJgzvdofJTV2dC9+y0a4LGUAMSxyHtUCjD/utdC8rZ
 ffEeapJOxAXAajss2MI2Y+YkIDyTJ3IXoUeqD1AxstOaz65dawOuBiA
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D60F5C0009
X-Stat-Signature: 3i3tkz75soak9nffjrji1qt3m73ayftf
X-Rspam-User: 
X-HE-Tag: 1778487460-90733
X-HE-Meta: U2FsdGVkX196e9pYvE0KmfWnx6Xp65nR5JTxIMUAT80W9H813xhNfGUbwbDdqWUzvcKE35LKuFmq57isyLebbppYXHY6jy5kfNx4rnTIq4TA2oIOQSHad/6JDM1+nCrg+in9tY2zGeIp69fmwdi7TfXXglLF4LDXE3yLiNfugqkW9HtFcHyCZ6ZNe2KccjKcncQysJfsDOQFgPi7Jv8YEBXvdEqcUyt5BLNzS2Z1RIuSQ1OLNHt/MaKFZD1bjLPKtoENXejr+Ln157NZGrFkaVFfOiam75ce9bpgmVm0RmkUOk+2KbuHArQ8LV+WfuCnLht6j3DTI4zB5qziE3em4FB/cEfZGO+zu0A2W/g/iDViijsAtZyNcsv7mXLgqihm95R+jsY7ohtIy8m3xtMkWqcVJ827Ddt/c1FOKSmG7rbmhCq7x6RfSu6kC8J/KonbFcVy1qo8M0rXQff8+t6yq93TdSsgJSIwwdXgC0K/KArEXdbbxWiO7k78dAwKEa9PhM5xhcRWdmYw8m+Cxqh9jfA7tYdTxZrQe3hDh9JUAfFm47ZHLjhSWl68eOK6gQLnvV/5UaZcCf6GdLvEZ8GskE8JnuXeo6LtRnpWhY74laOQMB0w+0RFc1Tn1VtLXtf6QVC1qU4WoV82raPilpbMPUzqfyHYdHUX4KODJnyeMSaYnuZk4QAZMq3wwu2Qln+dohoKp3WXrbrPAa4gcOdJ6DM0NhljCGWxWnOD0CRcIdwcEkZweVlO+LuAHwbDG6W5gULA2+7tLdkQEvYOP+Cp16ytbr99DhUrcsasCzgjOMldSlurKZ6C1COrb0hBRYn/DAPwoTITjNLeO3+jg2y8bgOKiwVztxTAKlsgxfjoGoZmRqtuLUmib0xZQP2RhCiAtyr2U9o2AaxXYavwbq7302x9OI9b4nENs3fEdy21XzdujBmBytGaFfRY6fmPiCYE0YEu9bj4MjT8VJE2/FM
 xC3kmDJ0
 TwpXHS33Vo+Kk5yQu8F0JH9/NNh2xDl3dtMZhG+WWYPv/nQIQ6C+95cdDiDopElB9JlyzfFuavZKxZKPAuVeK0Thl2r6ngUD7aq3dp4Q2ZqtM1/co7tHJCk3S/ZV51saK+qNyWoqThUm5ai8UTH/EVMJ2krkgqz11e8eQOJGf5Ohev9dGCQRF2gZXFU/OQMW+8+j7m0hTPIlm82NtsHZH1N7qPYuDdkVd/fIxGT+vgZylJIIHtv9t+x7Uli2RTOVYEIDN2VtvYE39j/0J0+/mAM4EAC7sVATfdgUuYW8bvlOz1JwEnKXMC5nyWiUhIwfMHvoeVlyHspT9ZekyvQnnVLLq2n8MBH4J6LYQP8J3XIoVvffdTy4j4w7azEnJfpty7Ed8/bxtrfz+sKUOewcluUPl5bFKBEe8IRC9mVnvteh3DFTmlkZNNW3b7X+0tJrhPnxQgmQJ5hzi5FaWNTwJmadVZCPSO9+FrEUgLh0KgSW96yJNTi/MdobKk3uwrI/4uWZNbEev++HfTqnFBQH5mREW1BFjH811ASoJkEyjxyExALJkAShWmAwDFNWc3Jho8Ngjx0NVvl+EtbI=
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
Changes in v13:
- Collect all r-b tags
- Resubmit for Review. 
- Link to v12: https://lore.kernel.org/r/20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in

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

To: Andrew Morton <akpm@linux-foundation.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

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
base-commit: 7505bb13a9bb1f214310915ccc06643119fdafc9
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
--  
Shivam Kalra <shivamkalra98@zohomail.in>




Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57AC91076381
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 17:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBCC6B0092; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA8D6B0096; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649E46B0095; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1156B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:16:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5C1DAFCF4
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:52 +0000 (UTC)
X-FDA: 84610641864.12.84F8A49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5061C000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 17:16:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BHF2LsJB;
	spf=pass (imf22.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775063811;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lrGaXZa7q9BJYISJ8JZCcyfBRUnBy5om+AklJ3fwTzk=;
	b=w1/mQRxGMaNoPS3ESDoX3SB8gAuyaIbFJ093mL1+L1bLiYHlJW2qJJKs9TlBy2MolqYfUc
	crErPOdNgPttc3YLL3QKvTNIC+VPS6cUgDznMT1N0WzaUVa0OjVZtrGcnOpQq0BZy8nzwu
	CF6n/oGqezfgEeuo1c2410PUgkhKaWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775063811; a=rsa-sha256;
	cv=none;
	b=H+8F5dW6E+mrMSvSVO6cfZyrD0eltLsY3vaBln3XXlbEHiU6uc67u50fvSToASJX/5I9Ov
	kCCPmDAwTxrwJe4z4xVzzWNZtfQIDlcydaW76UcZb51xSh6lZIx/25fdcD3w6PoFAxYmg2
	fbZmNpecjBE9H1JYEtkUciEtCCem4LU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BHF2LsJB;
	spf=pass (imf22.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6C2442DC5;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA7B1C4CEF7;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775063809;
	bh=Mi9R4u3lZc00+hP0YhV+QFhEHE6cFT/fYerPqhKLNAg=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=BHF2LsJBDQrF5Rl7TOjfHUiRH3dpVR1GWWzlMcXVRdNjRg88TxA/nuH0tpZQCLlED
	 +YXCgAKKAvFqU4ssl107d+lETjlMV3DuKND81o38KMb03E1aK4RRgB+wq1I+riQ7ot
	 5FDyoyKw+eliOYvD206W72l9goGhdIPHfBT/Jo9MGLyNGtbRtugeE/bwyu71D53KQu
	 PlyZLfPaPQlPmeSVCn7HqTisjPIqnxpVwEm8FGI+eP8cd/uWpeYjXAKIgw6PZYSYJ1
	 RzlC5fuxGKjlGt2ALmZAZY4cOcUmUMml8h1cyYCxij4k+6ennD5Kgn5tG6AlIy8Rml
	 +24/JrXkE6DlQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E65A1076381;
	Wed,  1 Apr 2026 17:16:49 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v9 0/4] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Wed, 01 Apr 2026 22:46:32 +0530
Message-Id: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPFSzWkC/3XPwU7EIBAG4FfZcBYzTBmge/I9jIcCgyXutqY1j
 brpu0v3hEGP/yT/l/lvYuUl8yrOp5tYeMtrnqcS+oeTCOMwvbLMsWSBgAY6QLldh8tlDnIdlzy
 9SdAe02CcG5QWpfS+cMqfd/D5peQxrx/z8nX3N3Vc/6U2JUFqEzklbchbfvqex/k65MtjnsSBb
 VgDugGwAOgC9ioaUAAt0NVA3wBdAYh6SNFFRvYtoCtAtR/oAgRVquA9aaIWoBqwDUAF8D75RDo
 Qmj8AUwGoGsAUAAyGwXob2GML2BpoJ9hjArBB75ii61rA1UA7wR1AMJ4sUM/R/gb2ff8Bi1sLh
 XUCAAA=
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775063806; l=5371;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=Mi9R4u3lZc00+hP0YhV+QFhEHE6cFT/fYerPqhKLNAg=;
 b=FM8tzE01dzz+t7eQbf/IJh3MbSsxbVwMnbOU3+5oxRl54okCRP27G8YwkjlxtvPelqoPIfX56
 ETb0nSG8TDfDa+9zDhsePpM/JxSGTn6R2tp6ECsi+1OX1q5v41dA2+r
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: D5061C000E
X-Stat-Signature: yczomgphtnntb6gkocet7zbarhykc9zf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775063810-460917
X-HE-Meta: U2FsdGVkX1/1HT5hSOI9g3QZ6rZKaHbze1kcTiQP/8sONDyQvw60pWclUI8ZqwUe4A/zZH7IxtW6hLuNMg8ivyCOR5UeyF/6xjNSJIWCRMwZkyo9QPZ7+F/MY9b/Xxu5KXIlSTq6exAN8jJs5uOgr9BY6WD+IIQzCobm2oOFSm/yZDP3ecDx3ngHNF/XA+9tKLehFyRrq0qzMCPgC40wvALYGorY73RmPsuuV/rPwueoRXnx2/dOZ3VCb6fU2fp0KLZogjXuIhBw9sn7sa9fxYSt/FrEtsLEbz5LBt4Ns4Garqwe+whms7wWOwYZNsmu6AvAa7LKXqG5zr+0eEpATKwdQE9CfGZK+GDNm+M2vjq7e4ncni1dRWnsr0vsF08eTjiEJtJg+L7zrwU54da0LzrPVJvC4wiJjxG7PRAQNs59l+fmAS/hUR8eOaM7a6cNVg4e1cQdpAqOa1YUpdFmTJmfKklM+LE24dhsREtFw5b0noF0j/1YabJ6O3iDba21+PsfVJiF4Kfj28nLDTItxOQjcjY3yCZiSuxvVda6YxigFCO4rLzk7AiFd6eKCTaze/2QUR1US1fXacTxytUh3IH3f2pAza8IJ+bHVvaeI9UBQepurK121EC45WS1KWf6DAY4Hv+3vntoaRpBNeZzo2+WaI/tbFpxvi8znlrrcUiT2wnMk23l4HtzmyQkFJvy8D9QYeGdo8gX7+gCx3yVtuBOV/55QGWYga7bKLJt6R9sjNLm9et9beUfpemS7j1QbQaezBLnxOvnwnC5GbZZcWBFBv0+w/UJZm/nBawNUxGYUXKF639lpFNHX/p/o+moobCUmMG2ZTDz8izMextqB5w2sPoHKLB38FhlyOqhAX4ImeR9/7QM+vX4pLpHL6+/2Ae1T2/JTHfQMa+6eAeiwIZPITXIgziyTOGajlcznbni/g8eNxL8g7UjUj9c4bwD9kTlodtLW2zBgALHffE
 prbZCJQM
 OVWv6YlJN+2pDDZGncSVD/9i4uUqT8Euem+V+ikYrgfrwnprYBsv6PnQpu5J27z6pP84uv4x7RWr2gQMaac5YNbxmf19ITbABki4+xH61GXIFwcsGKn34Pj3TMmF6jBT5oOKzzgR9iyq8w3QbIrDX3L1jwf6lNOalpWr61P20XGd43psL4u1yRT5Y/aiZrgOvJdikz223ORWyh/kATDffiApk9L63peqNBJgyed3QvLEDnLDa3Btv+xCet0xJlUZ1lApTqh1fJibAVo3GFi/kPW5ErISFm/y/xpC1NoIz77+rRvGcVgg9GsooWl02TeTc0Xdc03zsqfg/TDNix7j8RYk9l9tvbiZzBbPgOCPEbpAH1ycoE8vGGGmls0MLgiREqNyHhZZiz7kWSS/PBWbwT7jcMnAqlnC8ZcyeGvgefKuY7+WxsRTHsg+sOZBBGdSc1euH
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
- Patch 3: Uses the helper to free tail pages when vrealloc() shrinks
  across a page boundary. 
- Patch 4: Adds a vrealloc test case to lib/test_vmalloc that exercises
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
Shivam Kalra (4):
      mm/vmalloc: extract vm_area_free_pages() helper from vfree()
      mm/vmalloc: use physical page count for vrealloc() grow-in-place check
      mm/vmalloc: free unused pages on vrealloc() shrink
      lib/test_vmalloc: add vrealloc test case

 lib/test_vmalloc.c |  62 ++++++++++++++++++++++++++++++
 mm/vmalloc.c       | 111 ++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 154 insertions(+), 19 deletions(-)
---
base-commit: 54c9d0359b180b34070aa7ff8d9428fa3db8acbb
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>




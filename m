Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD97CD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4BC86B0096; Tue, 19 May 2026 08:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD3FF6B0098; Tue, 19 May 2026 08:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CF56B0099; Tue, 19 May 2026 08:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA70E6B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:12:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70A6B1C0E73
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:34 +0000 (UTC)
X-FDA: 84784057428.19.808CC78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 54AEF140009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:12:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XlMC3i8Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779192752; a=rsa-sha256;
	cv=none;
	b=hFn0Z08Kt+My6GofWTB0IE1LMp7r6aN3YnxUB6QTm3iisT8LJ+9stGKgCberJQbUIJ+3Mz
	76OLIoEOffomQO7VZMfuthrhg1nAbHzvej/Tnrb/mJHfoBBU5C9j6UTtW0jJsJbZY0Ne9v
	R4GnwZxoMI4TWN6iJ3jC6n0yPTQ9zxM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XlMC3i8Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779192752;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yxc18SUcZR8oE9Q4stXAhAHEVFFCo1QTf4lz+8ryYeo=;
	b=H8EQDI2oxiLCVKdnOjJoXzvV3uCNARS3e6l2q6G1/yy8WYGux9bAdfXcvQ/2goZ61qME/G
	z9805blKmROk2Fr0fzdIhJfJVmdFcFLVcncC7zpGza5Gizk2Nc/Ma6TOr76xRd/C/OhYvX
	KtOdA2CivJkNvhUoLBMpRanl5j5004Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 417D342DE1;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F06CC2BCB3;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779192751;
	bh=txJm4HOKhxmJ2vzYiuNeV73AcFhE33k97zNtzKsMCRE=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=XlMC3i8Y6MVhnGsH1dZbvbEWDPSekbpuLyKIURvWJWHbSl3Ck+1xkh/kd7LtvjFxG
	 SIECRBHHwGZ7lTOB1dIq2hef+YVM3x8yqaHpd0Gwn2jSRAD0bwC+Di6YymKhXXZUbZ
	 V+8ZwjZBGqxqKQy5PCPuS7369PLXC6RqUXRZQcKkENf7fM001kv0+tSdRao4QirtYL
	 BForcom7/ZEK3QFJgqP1kQ6UZoUzfJ9lRAfp9nzGKLL4rs8w9GauETupCdzCkUh8pO
	 s/r8KpB9gW+OmaQUUKOCnHryY1uMe+7LR73sSd313hOBy1ZUL09ISkL7E+4x5gmjBM
	 LkfVhfRh/Z04A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B02CD4F5B;
	Tue, 19 May 2026 12:12:31 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v14 0/5] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Tue, 19 May 2026 17:42:13 +0530
Message-Id: <20260519-vmalloc-shrink-v14-0-70b96ee3e9c9@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJ1TDGoC/3XTy07kMBAF0F9BWRNUVXb5wYr/GLHwc9qi6aBkF
 DGD+t9x2GBUPUtb8rFv6fpj2srayjY93n1Ma9nb1pZLX6C+v5vSKVx+l7nlvjERkAEFNO+v4Xx
 e0ryd1nZ5mUFHqsE4F1BP/dDbWmp7/xJ/Pff1qW1/lvXv1wU7Hrv/pXacYdYml1q14WjL07/lt
 LyGdn5ol+nAdhoBLQDqALlEHrMBBJCAGgEvANUBZg81u1yoRAnoAUD5At2BhP0oxMiaWQI8AlY
 A3IEYa6ysE5O5AZgBIBSA6QAYSsFGm0okCdgRkBHsEQGKoegKZ6ck4EZARnAHkExkC+xLthLw3
 4AGGcEfM6jsco3e2+wkgDAKMgP2GcxKsWWPhnMNN4ihjJpAEkcbU8gOIoBjdYugkXCSOPqoErr
 k0fY24Q1iKCSjHAUejTRa9d+QyNrgfxLX6/UTgm1iDcMDAAA=
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779192749; l=7065;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=txJm4HOKhxmJ2vzYiuNeV73AcFhE33k97zNtzKsMCRE=;
 b=2nlUVHqf8OKtcJiFfsuyHHS+Csr0Tv8//UdGLcQNk574bX5j9U90+wEfRmSlTyHj0F87yaiat
 sZzdl7yYrulCzQOME+2leQpVS2tqFr9aQZ2GaV5oy5hg+Oh2Z9WeItO
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: xjahzwnrbfx514i1mnj9zje3318mohbq
X-Rspam-User: 
X-Rspamd-Queue-Id: 54AEF140009
X-Rspamd-Server: rspam07
X-HE-Tag: 1779192752-775575
X-HE-Meta: U2FsdGVkX1/f9Y9Gs7so7lGZQfdgqg0EQUGVCGCj7BsuP6Cnr5XuFOkNhsbNIocH0mJUyjN8pFSLoTuyfHv42tCIU1TVyJ3GVzCuJIZGzPYJ5IEGjX7obn1qbvmqin9c/Qwzs6aVAH2uC6Qi80kPQVWmn+cAN+pAPxhhhNFKd566whC1WoId/mEi43VE4dimiNgKWOZjIXCWqBSBKD1XctWZLT1k9FU6f/QWiqpcjKrblk4jaGyjq8AwoMybXR9KXN8cLQy9OgcfjhCRV3/je0uWFboj2II2unQtB6HPpBl8UE9FdDUNGBMkEjb1I0QrEW+MDprRYd4RG85tRkeP0WjhRdNxOCH6YtatrEEkB4EOoVKouBfe2kl1DSclFO1cGtEwpuAjO88RjwP9/wTfwK3KcUeW4vcAXG6jDZalhOFiBaZKxMp8XnE6iCc4LqRjMuPjWIjeTKXXA2ztyz2h6Z7BgIp9trL0PEHvTjtUilsyC08VxDqEcAyOTqSuKJ0V+Ue1giMphVHM3aQsMRqfewhylJDaAx+ed/FvT1yj135V7SgmdxheyD4ZZte526ameU92ANwVpybbfag8NZWMLxbDh7ds3sBWugRLGFsiGseDAqLEd96viODFbFFq45Skm0esQiqimn/ywoC38oZY72kaPbrM6ewXVmkZ4yzRNszXrZdaim5SpP66ovzAD1T5g2YPyhdqZfQaBU7/2Bh10zWw4VDeqEzhdhKtrESH4u+c51AbTfoPnZL9UafsXwdWz8616hjnI6v2tSk6RMht8921yEJ4FKGNbAEgjMM4hMlV+bsYi6m5PEITZhuct+t75ZfBunsL1B8KyuRfxKn+UfVEiw1d8i768Bj3tyH9WLluPOvVSPQkytKnWJrdO6GSjmgtGgjheg43p2jWcDUInrVwcW0k4OWhqK0HmDQPYrhMwboBmsnNhKAZU/7koGav9gyMjjYvvdg/2THMKqm
 8w7TfHNv
 a1mOnNV1kARAWfJH4IG0m1q11doa+RFqLvlx6mt+jltElg8/stt5jFJgswvR9JVilNWuoPylfzAOeK6lSaLneS21D7sNjohBOybRwoznIs4Svhd/KEbOhVlSx3JQofaEl6307PZG10J0WTZ7Mrba06pZ11u5GGhhJC3y5be0uLlss7SpAJY9cBuqKXXE5DMs0L/fN+9m4On/WbdGwZw+HIDuF4TMxI9wk9UoDtsE2Tpdc45A3bMxlsdteEfu0PwRwWhkvcyT1nuUyH3n5b7eMZJnZKRI3hIcu9jQd4yCxK8pGBJON1h9vXlaQJg8dDpcCQTmg4JGuLsrGDpL9gM7Mh+DyGtFXyqk3yJIztx7wyDz0L5jiUs3nkvZOfUQcNWkpwGkz3l42jRxh835wMppT1v3Ti9ilEn7TF9fEBHoTU9REJRxhxHDdAp2pelWjFY9Qk7wO61cLM7IJxh2sy+6SwyqGVw1XssD9O+Nv8hzsFBG+vpKahqrifswdaZv0e/ZqJf9+w3zcO9I5tjSRxxG2URUxjfpcJ764Wugeo0XB4vO3t+0Z6LyWUWE8G8BN3+I9bFMGrUPfx9Pr+MEr8ln7akReoQjGxT5JuPmzZMw7e4XxiVxgzLRfM0lICfwhszsGbnNGqHOFXcaAWiZqhFNTUuNnqr07N2tZuC3b
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
- Patch 3: For VM_ALLOC areas in vread_iter(), derive the vm area size 
  from vm->nr_pages rather than get_vm_area_size(), which would 
  overestimate the mapped range after a shrink. Other mapping types
  (vmap, ioremap) don't set nr_pages and keep using get_vm_area_size().
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
Changes in v14:
- Scope nr_pages usage in vread_iter() to VM_ALLOC areas only;
  vmap() areas don't initialize nr_pages. (Sashiko, Uladzislau Rezki)
- Link to v13: https://patch.msgid.link/20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in

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
      mm/vmalloc: use physical page count in vread_iter() for VM_ALLOC areas
      mm/vmalloc: free unused pages on vrealloc() shrink
      lib/test_vmalloc: add vrealloc test case

 lib/test_vmalloc.c |  62 ++++++++++++++++++++++++++++++
 mm/vmalloc.c       | 111 ++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 160 insertions(+), 13 deletions(-)
---
base-commit: a277a07d19bffcad38dea57bc234d0810a328657
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
--  
Shivam Kalra <shivamkalra98@zohomail.in>




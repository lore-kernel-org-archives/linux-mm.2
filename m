Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29CA1E9A75C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 10:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693216B0005; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643E86B0088; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5808A6B0089; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0506B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 06:00:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB4E61A0CA7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:35 +0000 (UTC)
X-FDA: 84580512030.30.AA19153
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 10B7318000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 10:00:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AQxa5EEO;
	spf=pass (imf24.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774346434;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R50l8Qd2bK2l3oh1pEzx2cIWol/ezwxGVZWqLjN5Mjs=;
	b=lO/uJ3vZcI1D89N5L1u3nb946VWO+VQiEJC58GsvcUa8iWQkeP6n7UOTXnYghJAPA74NXF
	1Q4NeUzOXPY+OX07lHNvvgZsQVYNwT/LLyzYV4kPsK4RbcdFz767MkhGPiOisg4vG344oo
	V9CFXr7QyPCV86TwecXaBdFRTGIrMxE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AQxa5EEO;
	spf=pass (imf24.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774346434; a=rsa-sha256;
	cv=none;
	b=dXtxX6YYirAJctFAOFVPyqO+mhnso9gtt0LP1r45PnF7OCCSh+FY/EvNXpexVfyxuYpff2
	B6jWnC72OwJa+RlK1RIu9Fc9OTq8I5VS5GuPp9CYxM62qlZYmtWUXFoXpKwh9cYexGM7Vv
	6aCkCYOPWlolv3/KnRnnOLwxnWx7S3s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB054403FF;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 911CEC2BCB2;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774346432;
	bh=e6dIGEo7f/+1NfLq6ugPJOKFJUxC8pwekRAu/N6BZPo=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=AQxa5EEOWKCmb2jIrjVuLx505zSzB9FvyQeXUU1zyKwgtxkYSCF+4knhi4V9TYDs/
	 UExbDLUPaEkexZ+q5pzWyuLS8BFwLA7Oi/pgyh0eKjCQrfx14vmgkXE9VkuWX746ak
	 p8RO3sCv1l2bsj3ZqiXlQkUuVxL9VRfXSn6F2WuunfS+aFZzNcssfxa4hNsetG7YgQ
	 wnIMUOMEBL2QIrHfze2MTdkVe+B25wU1PMHwNo8UZzRPAXPJv+NfkLWaQCXF5MfD3B
	 pQdoQFC6ZKFuhIsC+mI6G9KF2LMDNc6fecSh68Un4nies/g/F+OHZjLn9BNsVISOai
	 J2AAGI+Rp47OQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA69E9A759;
	Tue, 24 Mar 2026 10:00:32 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v7 0/6] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Tue, 24 Mar 2026 15:30:25 +0530
Message-Id: <20260324-vmalloc-shrink-v7-0-c0e62b8e5d83@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALlgwmkC/3XOy07DMBCF4VepvMZoPPEl6Yr3QCx8JRZpjGxkA
 VXeHbcrI8PyH+l8mispPkdfyPl0JdnXWGLaW6iHE7Gr3l89ja41QUAJEyCtF71tydKy5ri/UeA
 Gg5bzrBknbfSefYifd/D5pfUay0fKX3e/stv1X6oyCpRL50PgUhjln77Tmi46bo9xJzesYg/wA
 cAG4GxxYU4CAxiBqQeWAZgaIMQCwc3OozcjwDuAjR/wBljWpmCM4EKMgOgBNQCiAcYEEwS3AuU
 fgOwAZAMgGwASrVZGWW/wN3Acxw+w5wC78wEAAA==
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774346430; l=5260;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=e6dIGEo7f/+1NfLq6ugPJOKFJUxC8pwekRAu/N6BZPo=;
 b=X35WFyaifuy2TYWC/Ep7XyQSNK115tVYS3zE/2935HlypgBLoNCPhYZqxN2Jr9l/AB0ECCEK9
 sBFLCKJoztMCWbHm40vABWXlFaKlagOqY2kdhJDP6YOk7np9fuF33zk
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 10B7318000D
X-Stat-Signature: cbuuyp9ymnwks3oong1b3bcqw13otnkh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774346433-419042
X-HE-Meta: U2FsdGVkX1+IFoYw8eyCsrqPIjb49UzdWQcjlILsXZYKUCiGdbU+CXrUwMgYLTQaitHkD2fcovM5S3zNg9GAeL/IfFg0fi3OYQnouTHpXyxDM1PajecqGpW9UdgqRp64pdndrbL5nwnAczDQOVuQUvTYk7870xM2ZEiVeAbUUX3ojJSgEoCeMdBdtIfhMkVyrY17JPcz6BFMqQDD2x4oNyL6QLSQiehF2SMa356BPGg82Ofk7UCGs8VwYGUeyx345pvZCaJxxe4j1hGe6hXlezDl3O53zFpltgnE2UmzvVbpmbnsKkePZB1TI7qGLz6hQgFm/vq6TsgOZftklEKmyPwKn7iUMD/gvXzoe6mD9CNzIAPmfTMQuGIE0rngEqDa2Ks27vwSg/fgczO/ftpgfQvfpgqdw7KeRmqCDCKj39xOKKoBRNzVjew0qpqHj1jWhPypChJM28kW/ccBJT5yKogzCstonYhl47nbDD+w3wDxf1V5JgCZapCjQt+WVe841BOwiiM9wHWummnqMf6qd45gWD+F0YnNuXzgCfSxytNyyhe2+XYlraPstjm456cIpH44PtMzEz+vPsyMDfb8CP2xHCGJ0TO8U1Y2xVI4mhJh5dVyTuxQ634u369KxE736+GD1at3gZuFZlLT09JV5MDwh4e8EWYYN7nOjZ5I/swJP4rVD8aqtTSmE65lld3y7qe+WWlc7529KTc/17jAadIt7pBIGzCMcum0cIDgMI7O7L0Bithow9tqh1aAa/FR+uyLlp/4JELz4uD5j2j9iFpnMfHl0fR2s5XZeGFWNwugkp2y1/ov990HGNLlENNZSBbNZ01om/vUvLOk/EeOziAq1pFxieBLGk6dZzCOtZJ2TJFLPe/OtrmJrARLJma3VE2SVjWOm40HAC2j5sg3h/Yrt5mAlDszQ1ZLqrA3pt7DWvtzr0G09aB/VO0wsRWQ+2aIAoUDVEnlMPH2u9Z
 gB97//6l
 Zm1XJ0jD6nVuRsfuyfx16FKzmzLScUzXhRZyYlqTEQBsON17KQwhD/SRaa1Jg62MMdvoT
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
base-commit: 02b045682c74be16c7d1501563f02b0e92d42cdb
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>




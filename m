Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB3BF105F7B0
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 09:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06F06B008A; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D223B6B0096; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A925B6B0092; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 803746B008A
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:06:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 165CB1A08A7
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:06:10 +0000 (UTC)
X-FDA: 84544086900.12.7C74A2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0411B40011
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:06:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IzrDyOWS;
	spf=pass (imf01.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773479168;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yfJjirNmbDjgUCaFWq3pmQz0TU70vjbGuKYnOzC3wtY=;
	b=ilifYmRPyj5ZcNojHjsRM2mw9HuChyoM28YHOHc8fc92on79SLOBPnWtQu67ll/tG9RdMX
	h9bEPsRqyC8/j0/tGz+HoKqK3JAW/zvaXA0ddwyTLRFY7F1+lOx+95qR+OuKMRcgV2Z0j3
	AHnIHd08Mm2iHSSLPQ7U8oMEGCvo3ZA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IzrDyOWS;
	spf=pass (imf01.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773479168; a=rsa-sha256;
	cv=none;
	b=6I15v6YSooVy3d3bvGfmawu322HjGE3Y0v2/AiuWqlITsy+baTTGej/hoJZlTDXhB4Jhej
	R/vFVQdhmUjgqlXT7qVefLaLH0PfIrXTLMphggtcG6PvEAk3so0mcoLuDYTw7CbHJblibD
	p8k2K2yW5wsFeZl1eXxzO3DtBhB24JA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9DCD40313;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9098DC116C6;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773479166;
	bh=FpWmOp0KrMNBjh4gR56azZfEz9z4IdeZPVymGFzqY4k=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=IzrDyOWSA8ccGC7TBidzm3PGS99uNHQsya5UjJ3K4excCRvHYl7aD1XhYUfF+tprE
	 3W08mHVxB8UGDI78xGWJvlbKRimeW5jTE+QWFuZL3leU9RxFWvtWfQLVA1WffXqBRH
	 cvRc510RDSR+GhO1sIDimwy0zFGJdlCnM890fY1Z+d0W4aS1gkzD9jWf+P7w9GO0Ei
	 6Mc3A6GxmDEg3bYMKD07ih218HJeRliq3d3GSmh9szkkguGT+e9C6e617gn1rZ3foT
	 No7U18qQdXfeWJe0PN1rh01K9RPrCytU1+nk1d7Or9g8fFdY3cpcTUa+KLANEM6fZ1
	 4YZeMJ3BJT4ew==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 869A5107BCE9;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v4 0/3] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Sat, 14 Mar 2026 14:34:12 +0530
Message-Id: <20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIwktWkC/3XMza7CIBCG4VsxrMUMU8ppXXkfxgUtw+nEWgwY4
 k9676IrTePy/ZLveYhEkSmJ7eohImVOHKYSer0S/WCnf5LsSgsENFABynyy4xh6mYbI01GC7tB
 b0zRWaVFO50ier29wfyg9cLqEeHv7Wb3Wn1RWEqQ2jrzXpu7+aHcPQzhZHjc8iReW8RPQCwALg
 E2PrXIGFMASqD6BdgFUBajrFrxrHCF138A8z0/7/oNpMAEAAA==
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773479164; l=3149;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=FpWmOp0KrMNBjh4gR56azZfEz9z4IdeZPVymGFzqY4k=;
 b=e2prkkhIrcliRDFynHQBoXYTe7vpo2xtunw0OR910D+c/ibdQa4FAC33JhJx9Dnw8+zWOfr2I
 7gP21Z3WRcJBPU2CGo4ZHCBDBbZ2zMk/fnYzChdxC5pZZZxefIbyydi
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0411B40011
X-Stat-Signature: m5wzx16xhkepmaow6cbk1g1zcbij6t1t
X-Rspam-User: 
X-HE-Tag: 1773479167-377491
X-HE-Meta: U2FsdGVkX18ShQYJZU61AwhBeINjtSMdd4L9pn/30scSzI7KTvUaXf8QDaap37gJlZsntXytlDukZEj9apODGvLOGkQv8+11emy6AhYJI61oV61kacm6WMlgtlcRlKK7UxVR/23ae/Z2M54xJ6fSIN1WErr//CI/k8VMsMLpHGXiPwWAhKBwal93DtnJB+B0daZBKmIsmYbhg/RzPMChvkNF6T1zrMZD2EDHXelrCw8qI6ghM0A48zHszxDxNCeGXKxdZ2VX5xRSP/EVhnJHOFT3HSpqa2k8xz+MdkHS+nl1wn/nJIPEhoNMjzHzHhK+bF53leNH4DDjvfQIc3/67PSpjInD+R1lUB0gZXRYLglIGmnQLqfP2eMma1jgvBe/STY2eVPWf4dXgQaqor3+wd7ri5SoqN0y6vrH14D3mJW5po93dWSTCqFvsdf+nm9Vpha0iuwA9ym+VbRMe1/77zUxlemOF4LbyDN+3Q4Du7VMgSO4+Ix6yP0sIpngONlNxTL0/kFpsQQqb7J9OVeDxsRjf1nFlshDvAC8hB86EKleRywrXtZBBZCx8ZTvSAvgYMige7jjblyrwZfhPKcFT3yfZTMP+uD9/BTa/ZEU1ub5PKVfCX6Zf2N5Px3hc/xoojzQsnU7sl4Q3v070I+J3JfKqZg02lyUNTPDbMxBBK/KrGksrCffvb4O/8zCuR/xx+cwiUsYbcOQ2Ew6mvAS3nu4wfPR+kOqR4pNNd5P3zhdv5gpvEL2en1WApG5Fd2hqWBldI0FMo0eRuxUW7hNmi+jf0M26O3vslFKItKgGWPsOkzRGG79cJ2PS4dRz+YJ3TNIwdN+YHx5NaR+4V6L7d2QgDfv0osHb4zGyb7kOJIg8pJxcbwOqFykczjA2kl4ml997zMggwg/EOTdSwvsbJWcjdPmUMbbUMNYJHPJ0pRJKlJEUNarXIJLmiSZjkfwIlNUcwwLLKto/jMTm9V
 8QltZBID
 LSEjrgymQD+jvh/SkM+0I2UFBZTZzgNxeN1631vGguMUKsoE+z2l7IdWIKmkbubF/djGMqBlXNdwKarln56EVG20q2eMYaJcDaJKGwu2tixZ2cUb8sFLj8Jjei4fULprvgtg/3JE6/KAa2sdpw0gZ12hP6+G7+AN5LWtO3Tb3vKpzNYB7AfkGxfCxbTJdIetBtIPA03T7tirOt4vma2C5dId47mb9aC7dZwk0VGA3uwWiEztfXVorKCDEyVqrz09pXRvuCAHUWd0l5EBfL4hWAbFU+RWtYBGm571glVcqCB8gqb0LU5+VeoJ6SG5shw/nVK6rtAtuvDAGT8XeE499bargJCBAibD0OlPpqnVyrPfiMPbHI8heYFT9Pnye9XW38mbz
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
- Patch 1: Extracts a vm_area_free_pages(vm, start, end) helper from
  vfree() that frees a range of pages with memcg and nr_vmalloc_pages
  accounting. Freed page pointers are set to NULL to prevent stale
  references.
- Patch 2: Uses the helper to free tail pages when vrealloc() shrinks
  across a page boundary. Skips huge page allocations (page_order > 0)
  since compound pages cannot be partially freed. Also fixes the
  grow-in-place path to check vm->nr_pages instead of
  get_vm_area_size(), which reflects the virtual reservation and does
  not change on shrink.
- Patch 3: Adds a vrealloc test case to lib/test_vmalloc that exercises
  grow-realloc, shrink-across-boundary, shrink-within-page, and
  grow-in-place paths with data integrity validation.

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
Shivam Kalra (3):
      mm/vmalloc: extract vm_area_free_pages() helper from vfree()
      mm/vmalloc: free unused pages on vrealloc() shrink
      lib/test_vmalloc: add vrealloc test case

 lib/test_vmalloc.c | 52 ++++++++++++++++++++++++++++++++++++++++++
 mm/vmalloc.c       | 66 ++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 99 insertions(+), 19 deletions(-)
---
base-commit: 593fab843afbd6800243552aebcc61d02d3cdcb2
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>




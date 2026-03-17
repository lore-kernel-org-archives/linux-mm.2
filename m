Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF9ABF3380F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:17:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB8C6B0005; Tue, 17 Mar 2026 04:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2306B0089; Tue, 17 Mar 2026 04:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1BCF6B0089; Tue, 17 Mar 2026 04:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9B6B6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:17:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B3091C96E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:17:41 +0000 (UTC)
X-FDA: 84554851122.19.DF7496B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 965D44000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:17:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ghh7dCdg;
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773735459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G8b6fU/145wvEnulw160YeyPC/wYY7GOWc3fvvUnMfg=;
	b=s297SG9t5aatLeSy57Le9AbGmR3LITAyvk871rIcSg/bOiDnjkUiZqmAzQKyWevJYYM7bZ
	CzvKM+Wey6jLjUanNXCCV+bxykmqJcEsxWSbYVATLmjninBCHrOdZFk3iQ4uyNw2j0lGPH
	14QzWPU6UcyTZBX+oldnAiUrA7EXYSM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ghh7dCdg;
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773735459; a=rsa-sha256;
	cv=none;
	b=7tkP7epWejVzkCTEQNSxeZslTxbMl78jz4PGk74hVONgWwzhw0my+Nlzf14JdCizOsTsFd
	/76ovE3EhWQEIt2m2MKqzH1jrL4sB89gnlqmQ/ONNOJivSqeipuBn2Hw0RxPJluyfm3CCY
	far8oKCWPd6BQ8Q3VVd3c/MD6h69EqM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E47A460127;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 924ADC19425;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773735458;
	bh=RisNgPVkJ2DmLymS1Pnu8hBXRm1dphIY+WY3EUkz0dk=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Ghh7dCdgZZfbQaifqddWMutRG6k+wwD+rAm1Z2oM9VpQvXari/4XkjK6ac7Y9FLim
	 DHUfHQOorHbONOKb+sU6Yhle3tMGoHT+q5NMhsfKzFHN3XTjqhK5FPx6ravQvgPIZB
	 ZxuR1hM7i3yg2hUuRR0rpfTFrNw2z2BlRVYlcjYeoL/ewG4lTXQNxnXoiElqOdxhD+
	 DVJYcSGiUI5XaKDjk+/zvo4eFM9YHck3OuMhgnwxMivze3NWWOyyQYPtd6WycDPYU1
	 c/ocX9mZKXCgV7NG5EBAARDCxOcMT6IOhpT8sKBBZdP390mbz0atEPBqUOzEpSHI3E
	 psSmpLE5zSUqg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825ECF33810;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Subject: [PATCH v5 0/3] mm/vmalloc: free unused pages on vrealloc() shrink
Date: Tue, 17 Mar 2026 13:47:32 +0530
Message-Id: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABwOuWkC/3XOwU7EIBDG8VfZcBYzTAHbPfkexgOUwU7sFgOGq
 Ju+u+yeaojH/yTfL3MVhTJTEefTVWSqXDhtLczDScyL295IcmgtENDCACjrxa1rmmVZMm/vErT
 H6Ow4OqVFG31kivx1B19eWy9cPlP+vvtV3a7/UlVJkNoGilFb45/o+Sct6eJ4feRN3LCKR0B3A
 DYAxxknFSwogB4YjsDUAUMDjJkghjEQku8BfQBU/4FuwKzaFLw32pi/wL7vvydWuwxxAQAA
X-Change-ID: 20260302-vmalloc-shrink-04b2fa688a14
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773735454; l=3389;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=RisNgPVkJ2DmLymS1Pnu8hBXRm1dphIY+WY3EUkz0dk=;
 b=vq8rG2UAkpSPEXrOKqhYAZXPkT4gBEYlpeIhxkGE+9c/VjX8AxjbATOPskhzKea5U6KtWKBwo
 FXHzsHuk6hCAw/2Pa0y968p1hcZpT2I/DAXRTtmtwk4sJf340RJY6aY
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 965D44000D
X-Rspamd-Server: rspam07
X-Stat-Signature: jobdsf5e5bwz9ubgwo8b56q19ntik6sn
X-Rspam-User: 
X-HE-Tag: 1773735459-189313
X-HE-Meta: U2FsdGVkX18g3vKYNMNonwvK4/sQQgAy/dN4zh4Jlp/Ord0eES28z3d12Zqep+tT1uVF48X/76kVDFN2wFk7Aj2ZUBuwkYZHuu2CzY9TdpBbs1W2bIUeUpATCvXGlPv/AIn3JsCesJ7UVD2fUN9rhCusrYVJiB5Kf3jH12EZ4xVsWy7nxKWLq0bSbq9dpNUsyvdoS0uirO++1iy5I/k/xCM7wXxw+I2Yxh5qFChvBLpMVzCQNFT8DSlCtcFPgwZdWbMcWZWY76tiFLYKf9RhrvdFH75OUiX27TbHiR2CCRCEcCPqsIH0IYo8T5R/jl0eBy2JrQ9pRr4YTpe4diWFE+/BK/b/KzktWyHy+n5ce5qmMDztgwAm2/DDOzg34KgHLAz+rx7BbGCzoI8INHyBru/Zxt+f+dv/JNFBRyQ5qoGWC6QUDVINR37NRFf3TCkFKxf9yeuV3j2k3M8tqYeqsWc8CCYklucbefDrEtkFiOYsbmGILzz1qUSu4/wKFr4Bt7liU+RqMf39SfIBUE+8GWbTgkXPbxWbwpPpbCXf4I1UUTzlDhzC8Htpc8w6Edp7S3OfGjKiFKsmuTCBMXm2Nf45MMFlRbIbYc4hSj543ibGjpYLkLPG5uME6WxlRnf0EmDBr20Q9XB82dLrSEiRKEdk9usbHmv/j2FbaBv7FGfH+mFIFojRVopTEajyXI0b3NIMXErjN0PMIVCL4mIrIUQuTJXY6uV/gQDSk3FZbFxhl3sxw+zCU/M7Zlckw0Oe0e5KzFMAyca7rlaYI1hcakCtHGp0IHWaYUZS+C87MxnTt8bXHUSvQmJWi5NhSVzbaNjyFt9CDuKJJA7APuVt2Z6pKzEAO40OArAEr8s/p9XHuBpot9gH0FKnjFv0W5a4pXJ9/QhF2j7cdko0hdTg0OS4lABeMFJkMDs6eJPUrZhziu3C7emOv2XBtJRYoXi8mxirDVNLYtMkTO5QIUI
 kpDbgbG3
 w2eRgz0v48kKvxuEiMWJm/ZmOMiQe/Pp6ChkoUu1DufvH4I5NBcR9Mb9j02R2enGMdMis+s5AZLYD1TZA2RJuwY+kzhjjU10ORDGbTST8RGMldlFUnmHl6//FLkE9e3J4j9jmHG7G53TFio4rKxOIKteAi6Yw/SwC3md5M1X2uTYCuJ2bLS5ZHcmakbnEuQXA85jMUk1iDMQaWNJCFcyBz6ZeJf7yhMqLhdIwh4HOenHXbPCobrgPzN7T6RhRd9YcFtCoxTRet/eTU1ZqGLkPkwW6ZXbk6T4sw1tELZuisq9pnad9QgVKIY4p2k8MZFNcdDTeQBMnG1a3aEMfMN4ikHaA1KdpzoIa8hyPHU6VP6qgJneNGcj5tuBBRrg1xJxK/IFs
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
  since compound pages cannot be partially freed. Allocations with 
  VM_FLUSH_RESET_PERMS are also skipped. Also fixes the grow-in-place
  path to check vm->nr_pages instead of get_vm_area_size(), which 
  reflects the virtual reservation and does not change on shrink.
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
Shivam Kalra (3):
      mm/vmalloc: extract vm_area_free_pages() helper from vfree()
      mm/vmalloc: free unused pages on vrealloc() shrink
      lib/test_vmalloc: add vrealloc test case

 lib/test_vmalloc.c | 52 ++++++++++++++++++++++++++++++++++++++++++
 mm/vmalloc.c       | 67 ++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 100 insertions(+), 19 deletions(-)
---
base-commit: 7d47a508dfdc335c107fb00b4d9ef46488281a52
change-id: 20260302-vmalloc-shrink-04b2fa688a14

Best regards,
-- 
Shivam Kalra <shivamkalra98@zohomail.in>




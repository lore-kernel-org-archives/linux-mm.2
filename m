Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE21FFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 11:35:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2644E6B0092; Thu, 30 Apr 2026 07:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23BB76B0093; Thu, 30 Apr 2026 07:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E106B0095; Thu, 30 Apr 2026 07:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBC5B6B0092
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:35:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87AB14010C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:35:29 +0000 (UTC)
X-FDA: 84715016778.10.C20F61E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B2E3780011
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:35:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IX7NHood;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777548928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuMCZXQ3LxsWc0DzOBRQwhMSlFtqM3IFq1rVtVhAr3s=;
	b=6EpFzIOawEjF4aLvYDYCKL/1AQz+P8hC5iS4mxLgpmims1rcyiJI4Ku/DTzqgZPAvoZCwI
	NoBygDyfc5VjV7mU8JeI/u/hNNR7CKSVCd3eSnLlfrOfShNvHZ+DdeyRk4g0oyLFOdJj0s
	bNgLM3skDkjLveS2Cam8mJ6jJT4sUUs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777548928; a=rsa-sha256;
	cv=none;
	b=4R/TLqrLXWpHXIWmH28MpBhx3KLeBW6n6fEzLJmDdx956ArCBQHyovW4I18fnJFtM1JnsR
	qEzu2cwBdhYSAbmPQQk6knUNHWyYhTru7biBOM16o6/jzT9iSLHN7AoaB7HYm4NjXhOvBm
	nlSXjcs0b5kZLDL6kUzYa95uN0ig7mk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IX7NHood;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A99C5442F4;
	Thu, 30 Apr 2026 11:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127F1C2BCB4;
	Thu, 30 Apr 2026 11:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777548926;
	bh=bisZnB1OIt5GIX54D6y0n4Kk5oWYXeYGQtm/I2nETOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IX7NHoodLLg0dGiTyVYt9H9YfLJOCH4NlBZZzkdOwmyBN6XzfYNywvIAWNfRyEwM8
	 NLLIJQrM8tHvvk+CzwKIIyrGfqAu0yNtZ5r3xF2QwkDfGXPInSTPd8jqiYRPOeE4r+
	 U95kWfcDOBUkGJlmmQqRZepGt/HoiWvKf6Lu3aou7A1WtVK1yP6hgOz9kEjPYb55mw
	 MNBzqVHMMvQygmzCf45orrd6109MeQJemSZkZ9NEhmQAm7241maVM9xm2lfyJkrZ5W
	 XdNABd5FOByoIzzgCabKxA46asJSyutcg4cxltqKk7h5/84IMruzC/1lETnTTw5XWE
	 4NPyQqyYjxW0w==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] userfaultfd: make functions that are not used outside uffd static
Date: Thu, 30 Apr 2026 14:35:12 +0300
Message-ID: <20260430113512.115938-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260430113512.115938-1-rppt@kernel.org>
References: <20260430113512.115938-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B2E3780011
X-Stat-Signature: sp8dg7qbpe4fikwhwiy9gszm47rrfj89
X-Rspam-User: 
X-HE-Tag: 1777548927-76728
X-HE-Meta: U2FsdGVkX18IOCIY1eJwqNUC2tgQewk7lxWD0Yi3AcsHiCd6oEAv9wwnnArZv9/W3WAnD2kWKBPHhv5hSd1D6wHudLxh2z9C5lycaOtXIzpCRYKsZNplFD9S7qiQvZUovady+Iq4KuhH1tvYT5TduDa777eW2+Rk6egFs2UkDm3x8BjcK2vOSGe9iD4ICj6P1BKtuyTIKBAWeAQNqfBl0v+3OskXi93chjcTvM1Zh53+efiKm3py8MAFWADN2gv7CUdh35dMCSmj6fQbhBG5LMX7Dl/wo3O3bbgi6GjY68Ra+r6IsBfOnbqUDT9PjTpUUMsm+KKVPkCq2GRDbFA9iYBVJ4B2VDAVz9icQVWfW5cLrnAApFRIR6HMqucPt1yyLf0OOpxgqbimP58VlHiAVf1zDFsB81DPvfQLpjZQd9jcvaEdh2BWDnJM6SeuYFPvwt+aLjgoC0gCSxUbKlA3TdQcp+llUJjrlB3oJWXArZWWTV+kPTNjcuzrovqJXTpauqpleDJv9R2Fi2seIMuyfDoUwI1BvsSVxOC1O+f8yaEpSIFWttmlu2+4KTGrvlhuVfMbqM8G9io/AwYUSvVQof9jEk81DL34LExztgBsSnY81zQMbo20uZ7OpkUuvEhxfdCvztpXcoGv7f9aSvGT6Eke+oT2o2l9PnA+tfkvkzg03bVF7yrmnI1WmJz5SHTiHOe/jBvSlLiPQNM2TS/dyqliFq6EBUEgHF0fkYL64H22Jqx10l2FGsnHOHmUgAabmtarnNC9o3Y0N3pc0MBxys14FnfHCsF73DvvO9fPDwOQawyrqXRzbaW3bT9TXJC72rNQa35GwIoeTaFzUzt1IJI2Gp1cUzquWB+plzbhHALUvrJfQhlPN/af+Qa4LjOsxgJezqplUx9Qn0Jtc0IU7JC7htjl8xFfHiak0neRuKVDOudtL8GQkt03kiWdDM+WOocbLaa8ztHPBYRhWBI
 UC47l3Kw
 nzWwfBUpbIK1eCO9ha/oiyEt8SUqi8CRkXlaZZRawwEwEHm84wKONhvWI4kU36wHJ0dL/aeYJTr00f2GvWsLiBJF8tlCuKkuLRrnbO8T9FTUx35dLYrFySsARRLSWYLF8sPtXprxzR9mVYXk6zmdGJwsWjGtFnZ7tZ6C1XWw5lFXxZvMyPmck5yP8cMiVHcnqeIBZo7vEWct3FiMyHUHxGq5JVB83LfQEfhYXGayZiAMMt0PZiHUQ2Sj8J63lK1fIBNqPI+Nli5mxmlY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

After merging fs/userfaultfd.c into mm/userfaultfd.c, several functions
that were previously shared between the two files are now only used within
mm/userfaultfd.c.

Make them static and remove their declarations from
include/linux/userfaultfd_k.h.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Assisted-by: Copilot:claude-opus-4-6
---
 include/linux/userfaultfd_k.h | 36 -----------------------------------
 mm/userfaultfd.c              | 24 +++++++++++------------
 2 files changed, 12 insertions(+), 48 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index d2920f98ab86..3ec8e1071673 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -147,26 +147,12 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
 /* Flags controlling behavior. These behavior changes are mode-independent. */
 #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
 
-extern ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
-				 unsigned long src_start, unsigned long len,
-				 uffd_flags_t flags);
-extern ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
-				     unsigned long dst_start,
-				     unsigned long len);
-extern ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long dst_start,
-				     unsigned long len, uffd_flags_t flags);
-extern ssize_t mfill_atomic_poison(struct userfaultfd_ctx *ctx, unsigned long start,
-				   unsigned long len, uffd_flags_t flags);
-extern int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
-			       unsigned long len, bool enable_wp);
 extern long uffd_wp_range(struct vm_area_struct *vma,
 			  unsigned long start, unsigned long len, bool enable_wp);
 
 /* move_pages */
 void double_pt_lock(spinlock_t *ptl1, spinlock_t *ptl2);
 void double_pt_unlock(spinlock_t *ptl1, spinlock_t *ptl2);
-ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
-		   unsigned long src_start, unsigned long len, __u64 flags);
 int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pmd_t dst_pmdval,
 			struct vm_area_struct *dst_vma,
 			struct vm_area_struct *src_vma,
@@ -239,9 +225,6 @@ static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 	return vma->vm_flags & __VM_UFFD_FLAGS;
 }
 
-bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
-		       bool wp_async);
-
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
 {
 	struct userfaultfd_ctx *uffd_ctx = vma->vm_userfaultfd_ctx.ctx;
@@ -271,25 +254,6 @@ extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
 
-void userfaultfd_reset_ctx(struct vm_area_struct *vma);
-
-struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
-					     struct vm_area_struct *prev,
-					     struct vm_area_struct *vma,
-					     unsigned long start,
-					     unsigned long end);
-
-int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
-			       struct vm_area_struct *vma,
-			       vm_flags_t vm_flags,
-			       unsigned long start, unsigned long end,
-			       bool wp_async);
-
-void userfaultfd_release_new(struct userfaultfd_ctx *ctx);
-
-void userfaultfd_release_all(struct mm_struct *mm,
-			     struct userfaultfd_ctx *ctx);
-
 static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 {
 	/* Only wr-protect mode uses pte markers */
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d0cf44aec1c4..f089ffa39722 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -958,7 +958,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	return copied ? copied : err;
 }
 
-ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
+static ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			  unsigned long src_start, unsigned long len,
 			  uffd_flags_t flags)
 {
@@ -966,7 +966,7 @@ ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			    uffd_flags_set_mode(flags, MFILL_ATOMIC_COPY));
 }
 
-ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
+static ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
 			      unsigned long start,
 			      unsigned long len)
 {
@@ -974,7 +974,7 @@ ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
 			    uffd_flags_set_mode(0, MFILL_ATOMIC_ZEROPAGE));
 }
 
-ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long start,
+static ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long start,
 			      unsigned long len, uffd_flags_t flags)
 {
 
@@ -990,7 +990,7 @@ ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long start,
 			    uffd_flags_set_mode(flags, MFILL_ATOMIC_CONTINUE));
 }
 
-ssize_t mfill_atomic_poison(struct userfaultfd_ctx *ctx, unsigned long start,
+static ssize_t mfill_atomic_poison(struct userfaultfd_ctx *ctx, unsigned long start,
 			    unsigned long len, uffd_flags_t flags)
 {
 	return mfill_atomic(ctx, start, 0, len,
@@ -1026,7 +1026,7 @@ long uffd_wp_range(struct vm_area_struct *dst_vma,
 	return ret;
 }
 
-int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
+static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
 			unsigned long len, bool enable_wp)
 {
 	struct mm_struct *dst_mm = ctx->mm;
@@ -1856,7 +1856,7 @@ static void uffd_move_unlock(struct vm_area_struct *dst_vma,
  * in the regions or not, but preventing the risk of having to split
  * the hugepmd during the remap.
  */
-ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
+static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 		   unsigned long src_start, unsigned long len, __u64 mode)
 {
 	struct mm_struct *mm = ctx->mm;
@@ -2031,7 +2031,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	return moved ? moved : err;
 }
 
-bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 		       bool wp_async)
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
@@ -2088,12 +2088,12 @@ static void userfaultfd_set_ctx(struct vm_area_struct *vma,
 				 (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags);
 }
 
-void userfaultfd_reset_ctx(struct vm_area_struct *vma)
+static void userfaultfd_reset_ctx(struct vm_area_struct *vma)
 {
 	userfaultfd_set_ctx(vma, NULL, 0);
 }
 
-struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
+static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 					     struct vm_area_struct *prev,
 					     struct vm_area_struct *vma,
 					     unsigned long start,
@@ -2132,7 +2132,7 @@ struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 }
 
 /* Assumes mmap write lock taken, and mm_struct pinned. */
-int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
+static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 			       struct vm_area_struct *vma,
 			       vm_flags_t vm_flags,
 			       unsigned long start, unsigned long end,
@@ -2196,7 +2196,7 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 	return 0;
 }
 
-void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
+static void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
 {
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *vma;
@@ -2211,7 +2211,7 @@ void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
 	mmap_write_unlock(mm);
 }
 
-void userfaultfd_release_all(struct mm_struct *mm,
+static void userfaultfd_release_all(struct mm_struct *mm,
 			     struct userfaultfd_ctx *ctx)
 {
 	struct vm_area_struct *vma, *prev;
-- 
2.53.0



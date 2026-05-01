Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB57BCCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 14:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3736B0092; Fri,  1 May 2026 10:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08B016B0093; Fri,  1 May 2026 10:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBC706B0095; Fri,  1 May 2026 10:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D87D56B0092
	for <linux-mm@kvack.org>; Fri,  1 May 2026 10:54:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92B7FC01A2
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:54:51 +0000 (UTC)
X-FDA: 84719147982.01.52A0611
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DEC268000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:54:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCx05Sw0;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777647290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f7k0KUruSveZJ/IkOObUURajw6CqYK96ArxPI6dtReI=;
	b=yjEoNtURE1smoK4ApMKecW/6vFE+0SgbEvoA/X8vdtxp/sa/DNP4bqEsuHTK70R1bfjMSF
	gS7GTRirGE+rWWqq2L2fuzVLeEPPJJr3peMIc226tr2QbHUU3QXVO8+r5yT7ZipvkM18xn
	XH8mdtHTQHbxYA5U5TFGZ4PCPFE8LgU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777647290; a=rsa-sha256;
	cv=none;
	b=q/cqdH42OB0pBcHX1CzVGfVPgGlZBlBKiUCsSdUUrxOHzrb1HD+523Xc/SAb2px5BwyBRE
	KOTTmNDAu69DNPvIgKKsX/8Kv80ow18IOOSEee1CZ/s1yt47Vv0yX+0+Lpbd1HVpoWfAdC
	dZ58Kr9YQYUXvxCgE36fZCkn0mLhp4I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCx05Sw0;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC77A40C4F;
	Fri,  1 May 2026 14:54:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B876C2BCB9;
	Fri,  1 May 2026 14:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777647288;
	bh=5SKZQUdvLCgdrr2A8dDIA0/4sVkU+pl/7mroxhxPIco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FCx05Sw0xx5sB3qH7305LqCulTUq/FBW31rxs6AI4NIfmLMwNdzJMySWM6KzpMDi4
	 TuKP0FP79LwvRx5G3KSuqkICuGAEfVVGvdILAqUQk29PkTfDltDGOXNWLiKStyRt5I
	 gBpvo/4b+UOLR7e2SsTvbfrOsqBfNke9XlRm5nF/CMBM7M1+xv3+kwUe360cd8ajUo
	 9Wsro3kw2LzaDDxOpKZVqtoIyDY8AO5+QT+iR/134LJHogXwl79dubPQ5dzdTtNCnl
	 z3ys9/IYM6WPLjhCa37X7O9kEUIyY0U+grO/demmrJ3iGCeDfSm0g/lUCPgMrrZIM+
	 ug2dj4bsz0/MQ==
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
Subject: [PATCH v2 3/3] userfaultfd: make functions that are not used outside uffd static
Date: Fri,  1 May 2026 17:54:33 +0300
Message-ID: <20260501145433.156211-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501145433.156211-1-rppt@kernel.org>
References: <20260501145433.156211-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DEC268000B
X-Rspam-User: 
X-Stat-Signature: xjignd54woc3i1o1z53uf3dcicojkutb
X-HE-Tag: 1777647289-944602
X-HE-Meta: U2FsdGVkX1+mykwM2A0tr/ir/iomfGu6D32AQSRNDh6IAEqcE0l3pPJ0ZrYchejtRzLBQ3CY+yDwcy58F5lwW95mGSs370TAVWR/0n2TSsf/wz32pvL/9wGtBuBFq9GTTetNhqezl5k4XairgR5hgpsFD00zLnGArUatoUbHeaw7hnNqaH/Mwkj6l04DYi1042xZ/hSMozCJ0aaYMX8+TBlcRE2Xg83K6+XhhMeUp+ZnW1pTJH8rgKt7RWo5cdOKBLznHG+K5IhZMM9vXG+WQMv+6j54GCFAaiwGVi+QPHY0bfJd669umt3WqkYcWu5ni9mdaumIjDRq6SQps68HOKdg8hxQR2lKqa8Pn0IngtSSPBwvwxRs20k9oHDbUYlmS29k7qceD0pNYgF9RkPb/CcE+5CHyGcF0sNBCaYrIWoushUurohybI+yDNaf8igLWVel9K3RgA7emiqaxdbs7BBuPcIaH86yxcYPT34I2CzpvdinkKblvuH/fg1+mjWk0q+w6cwOW0rH7q62D6g8f5cmQCY8pAO8gPxxtNwjb59XKH2rDsc4auRjnz7mozIgvnOn5l0UqPIHIC0+sHPK3UGoKW/P5bKCkkuNtkO1MlTgKIVg8NhATPPAk3FVRT256GkkxvgrQ1sCxH20JVupPDFjoUfu9xyRdaOTiFdQMO0t5nkqfay8dwFA4f6It1I+mrmDqAWdhWwa1GUkMLd71GFBXsbUzmcQNvYW5+O1tVCSyqfCjvWV1d2B/IZJV6MG+pM5NPEzDKZyNBOM9yw0kFldJ3wbJfg4ZB8n6fjT+W2G1Kfi3jF49MOMjS+8PqJuI/Mw64lJTLKVqZV3cjzYrNiuoWOxMAZYuBhjHPVf9VfvNRJ6pVvzJc1KI82NzmxqvaHJ9EEf9w7RNi50a/yut9TEN/G2e38HgQZfOMVPHL+QD/PFlKcSkdhtYPJfEwmlyZsPfWSM/0XwVVNO7uY
 Vw0RwvIQ
 LlyuglmMdiLvG2wnx/CRLOOLVj7OORh+oTz7qw5eyACAx0YBoekJG5AyOYCYct11HvAzxwTPlHmwex/y1niU4AMTO/Mls+hHGHZeTi9a503qRs2mZe214E89kqHq65IOmxmkOeCZiWUQG8VQpyHs7Uh/MldZA2oKLaAxF1xSF420mQTPynlEAR2VTAPv3Z7Bz2PITX+/Gd/7EubbJfshi9X7tpBAh9MC7ZfG2juRRYPPmWaI00uKgT1vLnZHvZ8XeI4IY3q/s6X+Flig=
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
index 720690f058d7..a6ebf89ff657 100644
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



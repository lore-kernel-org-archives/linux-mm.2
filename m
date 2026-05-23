Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9467FCD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB8C6B0099; Sat, 23 May 2026 13:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082B76B009B; Sat, 23 May 2026 13:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18276B009D; Sat, 23 May 2026 13:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCC076B0099
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:38:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 94DF21C0463
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:38:14 +0000 (UTC)
X-FDA: 84799393308.17.D4CEB85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0E89C80005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:38:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFIl2lmr;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779557893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNvtcknWhE4vwNMhrCv/cGBpuDimRjFo+5pvkhpsK0o=;
	b=6eUAiZl6/eDkyRRttCg9EgU6hraUGcdSLe2Hi0QC4FRAb9qk1JcHdVG4/iTYfmNFmPOIay
	xko3ZaUbDn3/Ax0H3s+m9eVJv2gegqe++PAOKi+uj9iyRXvPOqo8IFXMxRcrMfZjnZxTqu
	ceLuxj7FvdAN0F6nrD4CD8l6veC8w18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779557893; a=rsa-sha256;
	cv=none;
	b=mgP+HJkYFMINRPQ+Y9IdNF7XJA8p9MDumeL6GFuCw/tHLxUpkI9evqxIU5tF4YcJIEX9QF
	tuSAE5bywRhvLzFBg62TOI8zPNdTzI3DvLaERmrpwk8VMXdu4d8803z2OePXnxIGpgcRSE
	DM3MT6zpmuOMBlOsqyDO1XJunzPloH8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NFIl2lmr;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BE0360055;
	Sat, 23 May 2026 17:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957391F00A3C;
	Sat, 23 May 2026 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779557892;
	bh=vNvtcknWhE4vwNMhrCv/cGBpuDimRjFo+5pvkhpsK0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFIl2lmr61pjy1KICkcGKl01UQ85uqUzRwgyq3NUuX9qzzh9/13q54d2aQa1DWfHI
	 bCvmddifTHqG7ZdY24CJTM1HJ2ehbZUg1PEspjjjbyLB3XzhI27aEA0UW0Zg3xWsDR
	 EPkRIJgEJ9fjBskfJi1ehO+0HJ9yXKYmfjQhxoqKor7QE22s5Cv8kXJgrc62yKmRKc
	 TcIsApXHUtiSxkkI+xC38UWG5RHlCz2EN+t67KLIlRtu2gPijNT8D9WcDT70hONCHP
	 HeTvsgxPL51YaWzzqpVcq7kU0jrFRGXut46BdaK8o3woViQQQGI2RLIVRVOSvuECP/
	 rzREiHCTvYLUw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/2] userfaultfd: make functions that are not used outside uffd static
Date: Sat, 23 May 2026 20:37:59 +0300
Message-ID: <20260523173759.3964908-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260523173759.3964908-1-rppt@kernel.org>
References: <20260523173759.3964908-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E89C80005
X-Stat-Signature: cu1tbj1ii9t8mmmbebyy3acf63memzmy
X-Rspamd-Server: rspam06
X-HE-Tag: 1779557892-952909
X-HE-Meta: U2FsdGVkX1+BJ9zCtt7Ojtz/lEqoKvKoLykr77H66tVPhHiqS09GIF4vwjWudPQQDHdx8KEgpVkdXJvgLByeMkMDbhQ8215Gi+01Fh1f4LuhlINwt+ejdTT0j2MNPrMUsyv/MI6uCCPUV9XuEzbIIrBL33an2Q6CbbEZrkTYuoOq9aQb4y79oLkD3gx1Wz1des1ZWee4+D2C6UguY1VG//+S3Ie/CRzIwnQSxQHnaoTUSypnj6MC+C5XE1BVVo0fH3Mhzajp/ZZ/+eiNopr2PLPKuIZH3m5DOt2UKEw5YSvuttGytgXfFC9PqMH3AjyBOoXDhRIcZJCBlTdkq1K2picHVCJnz9yVqp7iRKmlO3jIMhzRsrzo4n55urc7Vh/PTI7vaHA2xsX7YchVmwY4j69PUvuxhxfyYX5pDQnPIa1/N7kz/70ENc8LOLTznpzFpqDXZNhWCohaW0Of4wY1lqIc9xUpzqwq5V+N+ZNs/pRvW2PSQHXSdS0iM5QbAGYidEyzCHTUYf1UJ/E1deq0PUJQbxOiB0AMsWELash9JlhZdRtXb43d/cZtT/aWK5EoKaoiU9ZAE+wjJ4/yNpsTRmRGO7D/YvhkiPXRhmuD20tg+XequNcNPk5Y3m2Md0na8DYkkd/TYxBiUQmao66lb0ADE20i0aKfGJcRAkRuKPddc5Io0GPiuhn9G88jY3V1cL26M+IoPuuoOyJdf0t2KJNhpMwvw8Ll03RYTLjqPhKpknO8ho7dXONHnO+dBZNFkTo8Dy1Gf+YAHAymL7wz+tJVlDzUMqqnVtvjQTyOsxbBR7mwBVU6IrhVlQKFODh5NqgEZ71YL7Yy4wJJ9FsYfOXUimmzxQP1l4I3tdjzIjUnWyeo0m+w7lBF/pdUf0YgLnOTWiCrq1xCSDpB2+JOaGfZYFBIOl7md9W2+25F1lfk7JK8WdCyCq0wtNw/lEQ0qWoBz85fO2DR8ABPdNl
 A2KYBPYv
 YPT8RycenkCd5obcgzniLel0i5QeaP7TeKiSsizrh9g5+8E7d4ryd4UQ8mxDwykXSQfOj8sY81fpRnDNT3geZunTj4cWJY1ryooWnXghbQvDZiyMVUqtmrFOSiy8H7P2bmtpC/Oy/IRWKmrVHql2EPpLmZA5kOjNYlz730UyEIUNWiGebVyAf+77AugVVMLPy1Awg/aqKlWn7NAeKAJC4E+jxKvoESZnkV/qTvdJHhNyEE5kdM1Gtj24A7JinJUJCpE9zLl8x8XTgf+I=
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

Assisted-by: Copilot:claude-opus-4-6
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
index 80319bda6d9c..35b206cc9aa6 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1026,7 +1026,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	return copied ? copied : err;
 }
 
-ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
+static ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			  unsigned long src_start, unsigned long len,
 			  uffd_flags_t flags)
 {
@@ -1034,7 +1034,7 @@ ssize_t mfill_atomic_copy(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			    uffd_flags_set_mode(flags, MFILL_ATOMIC_COPY));
 }
 
-ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
+static ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
 			      unsigned long start,
 			      unsigned long len)
 {
@@ -1042,7 +1042,7 @@ ssize_t mfill_atomic_zeropage(struct userfaultfd_ctx *ctx,
 			    uffd_flags_set_mode(0, MFILL_ATOMIC_ZEROPAGE));
 }
 
-ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long start,
+static ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long start,
 			      unsigned long len, uffd_flags_t flags)
 {
 
@@ -1058,7 +1058,7 @@ ssize_t mfill_atomic_continue(struct userfaultfd_ctx *ctx, unsigned long start,
 			    uffd_flags_set_mode(flags, MFILL_ATOMIC_CONTINUE));
 }
 
-ssize_t mfill_atomic_poison(struct userfaultfd_ctx *ctx, unsigned long start,
+static ssize_t mfill_atomic_poison(struct userfaultfd_ctx *ctx, unsigned long start,
 			    unsigned long len, uffd_flags_t flags)
 {
 	return mfill_atomic(ctx, start, 0, len,
@@ -1094,7 +1094,7 @@ long uffd_wp_range(struct vm_area_struct *dst_vma,
 	return ret;
 }
 
-int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
+static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
 			unsigned long len, bool enable_wp)
 {
 	struct mm_struct *dst_mm = ctx->mm;
@@ -1924,7 +1924,7 @@ static void uffd_move_unlock(struct vm_area_struct *dst_vma,
  * in the regions or not, but preventing the risk of having to split
  * the hugepmd during the remap.
  */
-ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
+static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 		   unsigned long src_start, unsigned long len, __u64 mode)
 {
 	struct mm_struct *mm = ctx->mm;
@@ -2099,7 +2099,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	return moved ? moved : err;
 }
 
-bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
+static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 		       bool wp_async)
 {
 	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
@@ -2156,12 +2156,12 @@ static void userfaultfd_set_ctx(struct vm_area_struct *vma,
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
@@ -2200,7 +2200,7 @@ struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 }
 
 /* Assumes mmap write lock taken, and mm_struct pinned. */
-int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
+static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 			       struct vm_area_struct *vma,
 			       vm_flags_t vm_flags,
 			       unsigned long start, unsigned long end,
@@ -2264,7 +2264,7 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 	return 0;
 }
 
-void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
+static void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
 {
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *vma;
@@ -2279,7 +2279,7 @@ void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
 	mmap_write_unlock(mm);
 }
 
-void userfaultfd_release_all(struct mm_struct *mm,
+static void userfaultfd_release_all(struct mm_struct *mm,
 			     struct userfaultfd_ctx *ctx)
 {
 	struct vm_area_struct *vma, *prev;
-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 923591099B3B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94A46B01A8; Fri, 20 Mar 2026 15:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BDB6B01AA; Fri, 20 Mar 2026 15:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6146B01AB; Fri, 20 Mar 2026 15:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2DF76B01A8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 677128B4DE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:41 +0000 (UTC)
X-FDA: 84567456162.11.06A28FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id AB1DC1A0011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r7Lwht9+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBHmzvjB0HBrrqu6dkvU7Xr80teA5AGkgxmHrBsxf7c=;
	b=NEPPCxZvCL9eDEeKCKqKKsvHlZ/geLEqdlvP7kLCZ0KpmYn0BoDJncMbLukyOu8A1TQtsz
	zrUiRK1Ca8bsTe0RNRu9fP2R9EsraLIND7R/EJ/5XVx0Ez84fUpVpyxi67uNup3WbMYeMz
	qNaVkgeWGogvlPTrj4g8Zj2XrPdYVfo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r7Lwht9+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035579; a=rsa-sha256;
	cv=none;
	b=hDlopD/Q8WGK74uWf6daP8ky06KRzu6/KShtbacGD7aILHFoT+vLTn2q/zs5/7dxpNG3Or
	/SgX/UTlC1hYSFHEJf1OgqzouYhxh+XiTJmJWxi2xQmRZDWpkKREQuO+tHxVpPlT4tSJJO
	hPGtrracVQjcA0rVykJ+grtVuOe+UZM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 486E561858;
	Fri, 20 Mar 2026 19:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D08AC2BC87;
	Fri, 20 Mar 2026 19:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035577;
	bh=mtxNzBBUKJYuZHY0i6poPtAf2sXpjk4MijTQlmTdsUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7Lwht9+pf6T3ayIWKnBIAWgq30rcHApgwCJf7VIipmDLjJrnA6Kc3xfVV2oAn+aS
	 EL/AIsxbuEZBctxQLYA4esE0Cb9unjlbgKfm7jCvnAUZoeuWaB15ikKN3qS/qY0QSj
	 KBkh+oUifUS9ZhRkDbmifaOw9a4zycBrOBqHw4EzjQTH8wSLTr3/3wLI/xLf3A7SZT
	 tjJoWNUVn9ZNWc2uoeb+rILFBerJyh5FKIojL53f+2lApxWxOcC5OrgtvEIw43DxPj
	 C64YVDx6UXPke1ivDHxUWFEFuOgperSQRKN948zxjfX6R+GuSYy0hC85aY6FwrHlqI
	 34AvdumiaPqAA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v4 23/25] mm/vma: convert vma_modify_flags[_uffd]() to use vma_flags_t
Date: Fri, 20 Mar 2026 19:38:40 +0000
Message-ID: <51afbb2b8c3681003cc7926647e37335d793836e.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB1DC1A0011
X-Stat-Signature: z3rndk7nfuzw9u1b3ofcaq1edwtsfs58
X-Rspam-User: 
X-HE-Tag: 1774035579-660976
X-HE-Meta: U2FsdGVkX19+RFWvp1ivu9ciJLRcoSErvkFhA0RGCV5BJwMwQ9m0RgSKzjuBhKezYvmn4sikPMUa0wMdoYtAAU63LtQC0766qJMuyiXsOVQRUpDWj/sVN33vsrx3ktmCIJVhZkSSdGik6Mbkd6qx/O9zvMZ0dY93Il4li4MusSrHHuu6ND7u/HAmwtCrMTIndhrhHoRfmRlobirvRykz1tINSjyTEeKArHj/8gXjmXwPwu2pJE+tZee3u4xM7qihVEcRnOn+MVdLoe4lOckrsmookZqDfo+JFPzMyYhV/gTwMV2TL/UVf1gp9x/VxO8M4H6BAZXBeGWO0+iGwA+UU37I+xvKfL3vuLkHC39UhetGRBbThrEkaXFAGzLZh+ds1OE6H12oIiJSrArOyoL8pvfcfstJed/9oyL+e4kx70aY2HXCrOfa4O/iTNz/xtQUa6RtvNTC/XyJBRVHuBVlWFBplLN+R7RulSVJ7rPmH1/W/oSUy8LY2cgO0mAzogC4ZxZQkEp9VVP2gDuF+SLODFDRdLp+8xvYAmm1877LqvHSkHHCntOwNwicUSmZDzyY9++8gH3N/TDC0zdVGGAy3H0SobX6e6yH0g6hiIj6vRpBV97/Z1i++5S0tv9EwlD5ciyCURfD2jWj1dF2Z28AXes+mMwV/PfNzUC41t6IZlo9ebT30meXO069Xmnxi54roPkAMlujwd6zInVGyTpYg0lq5+eT7nMnsskEhGxLlxzGcTik7w3X3jIshs+qtvMhd4WpfTs0DHnsk8uiPD0/1UKLqfeVN9o+25Crf7E8OkMlweP/9EQwH7sRUqfZgD8qWK7iiapDWDVAfyJrt+wq6qdS0f+hMMnkT7hVJG2EXlltDwgWkRmOicUNI01se532pDS/pmSAVRAZUdl1icaxAfmdhWELEbsZB4ub+IV5lrIA6rn/IcuzezTdyfINrPQ62yB4d4rfmsadQj1P6cR
 Vhb19WtJ
 ZknjDcime8+ZaMJKTrXyVQ4hlA60yiJHmwvKB8XNUkul0uOiE4WQQA4Tb1tlP0R1QEX0wPKASpwmLvjULUkXicjVe3/un+7+45HnwYd+Cc43AffCWffOMkh53JuzNwIjSkgX745uitEqrDFvgLbD1lKBMqsvgwNL79hzYTaCQQreeeq8k79VfjuzRjZTUbB1AsSEYeOTnCpODsPy4PAEIIb07XOc/8gbYH44pBE9NPLNSeJ4Wt1Ak7A5JzLE5c/LrnNE/x9Jm5tfHVTzuv2GBYoT6rSSGdLKPRr7CBXSxy3gB8s2rwYHof94u6uMy5sSyhyoyBRJOpWdQz0LRefwPRlD5KQl08AEvLfHKlQk0GsnW95aVDHc8bE4Jc8mlGz75Ddi2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the vma_modify_flags() and vma_modify_flags_uffd() functions to
accept a vma_flags_t parameter rather than a vm_flags_t one, and propagate
the changes as needed to implement this change.

Also add vma_flags_reset_once() in replacement of vm_flags_reset_once(). We
still need to be careful here because we need to avoid tearing, so maintain
the assumption that the first system word set of flags are the only ones
that require protection from tearing, and retain this functionality.

We can copy the remainder of VMA flags above 64 bits normally. But
hopefully by the time that happens, we will have replaced the logic that
requires these WRITE_ONCE()'s with something else.

We also replace instances of vm_flags_reset() with a simple write of VMA
flags. We are no longer perform a number of checks, most notable of all the
VMA flags asserts becase:

1. We might be operating on a VMA that is not yet added to the tree.

2. We might be operating on a VMA that is now detached.

3. Really in all but core code, you should be using vma_desc_xxx().

4. Other VMA fields are manipulated with no such checks.

5. It'd be egregious to have to add variants of flag functions just to
   account for cases such as the above, especially when we don't do so for
   other VMA fields. Drivers are the problematic cases and why it was
   especially important (and also for debug as VMA locks were introduced),
   the mmap_prepare work is solving this generally.

Additionally, we can fairly safely assume by this point the soft dirty
flags are being set correctly, so it's reasonable to drop this also.

Finally, update the VMA tests to reflect this.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h              | 22 +++++++++----------
 include/linux/userfaultfd_k.h   |  3 +++
 mm/madvise.c                    | 10 +++++----
 mm/mlock.c                      | 38 ++++++++++++++++++---------------
 mm/mprotect.c                   |  7 +++---
 mm/mseal.c                      | 11 ++++++----
 mm/userfaultfd.c                | 21 ++++++++++++------
 mm/vma.c                        | 15 +++++++------
 mm/vma.h                        | 15 ++++++-------
 tools/testing/vma/include/dup.h | 22 +++++++++++--------
 tools/testing/vma/tests/merge.c |  3 +--
 11 files changed, 93 insertions(+), 74 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 86a236443364..fb989f1fa74e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -959,22 +959,20 @@ static inline void vm_flags_reset(struct vm_area_struct *vma,
 	vm_flags_init(vma, flags);
 }
 
-static inline void vm_flags_reset_once(struct vm_area_struct *vma,
-				       vm_flags_t flags)
+static inline void vma_flags_reset_once(struct vm_area_struct *vma,
+					vma_flags_t *flags)
 {
-	vma_assert_write_locked(vma);
-	/*
-	 * If VMA flags exist beyond the first system word, also clear these. It
-	 * is assumed the write once behaviour is required only for the first
-	 * system word.
-	 */
+	const unsigned long word = flags->__vma_flags[0];
+
+	/* It is assumed only the first system word must be written once. */
+	vma_flags_overwrite_word_once(&vma->flags, word);
+	/* The remainder can be copied normally. */
 	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
-		unsigned long *bitmap = vma->flags.__vma_flags;
+		unsigned long *dst = &vma->flags.__vma_flags[1];
+		const unsigned long *src = &flags->__vma_flags[1];
 
-		bitmap_zero(&bitmap[1], NUM_VMA_FLAG_BITS - BITS_PER_LONG);
+		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
 	}
-
-	vma_flags_overwrite_word_once(&vma->flags, flags);
 }
 
 static inline void vm_flags_set(struct vm_area_struct *vma,
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index bf4e595ac914..3bd2003328dc 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -23,6 +23,9 @@
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
 
+#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
+				      VMA_UFFD_MINOR_BIT)
+
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
  * new flags, since they might collide with O_* ones. We want
diff --git a/mm/madvise.c b/mm/madvise.c
index afe0f01765c4..69708e953cf5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -151,13 +151,15 @@ static int madvise_update_vma(vm_flags_t new_flags,
 		struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
+	vma_flags_t new_vma_flags = legacy_to_vma_flags(new_flags);
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	struct anon_vma_name *anon_name = madv_behavior->anon_name;
 	bool set_new_anon_name = madv_behavior->behavior == __MADV_SET_ANON_VMA_NAME;
 	VMA_ITERATOR(vmi, madv_behavior->mm, range->start);
 
-	if (new_flags == vma->vm_flags && (!set_new_anon_name ||
-			anon_vma_name_eq(anon_vma_name(vma), anon_name)))
+	if (vma_flags_same_mask(&vma->flags, new_vma_flags) &&
+	    (!set_new_anon_name ||
+	     anon_vma_name_eq(anon_vma_name(vma), anon_name)))
 		return 0;
 
 	if (set_new_anon_name)
@@ -165,7 +167,7 @@ static int madvise_update_vma(vm_flags_t new_flags,
 			range->start, range->end, anon_name);
 	else
 		vma = vma_modify_flags(&vmi, madv_behavior->prev, vma,
-			range->start, range->end, &new_flags);
+			range->start, range->end, &new_vma_flags);
 
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
@@ -174,7 +176,7 @@ static int madvise_update_vma(vm_flags_t new_flags,
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
-	vm_flags_reset(vma, new_flags);
+	vma->flags = new_vma_flags;
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 311bb3e814b7..8c227fefa2df 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -415,13 +415,14 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
  * @vma - vma containing range to be mlock()ed or munlock()ed
  * @start - start address in @vma of the range
  * @end - end of range in @vma
- * @newflags - the new set of flags for @vma.
+ * @new_vma_flags - the new set of flags for @vma.
  *
  * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
  * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
  */
 static void mlock_vma_pages_range(struct vm_area_struct *vma,
-	unsigned long start, unsigned long end, vm_flags_t newflags)
+	unsigned long start, unsigned long end,
+	vma_flags_t *new_vma_flags)
 {
 	static const struct mm_walk_ops mlock_walk_ops = {
 		.pmd_entry = mlock_pte_range,
@@ -439,18 +440,18 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	 * combination should not be visible to other mmap_lock users;
 	 * but WRITE_ONCE so rmap walkers must see VM_IO if VM_LOCKED.
 	 */
-	if (newflags & VM_LOCKED)
-		newflags |= VM_IO;
+	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
+		vma_flags_set(new_vma_flags, VMA_IO_BIT);
 	vma_start_write(vma);
-	vm_flags_reset_once(vma, newflags);
+	vma_flags_reset_once(vma, new_vma_flags);
 
 	lru_add_drain();
 	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
 	lru_add_drain();
 
-	if (newflags & VM_IO) {
-		newflags &= ~VM_IO;
-		vm_flags_reset_once(vma, newflags);
+	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
+		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+		vma_flags_reset_once(vma, new_vma_flags);
 	}
 }
 
@@ -467,20 +468,22 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       struct vm_area_struct **prev, unsigned long start,
 	       unsigned long end, vm_flags_t newflags)
 {
+	vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
+	const vma_flags_t old_vma_flags = vma->flags;
 	struct mm_struct *mm = vma->vm_mm;
 	int nr_pages;
 	int ret = 0;
-	vm_flags_t oldflags = vma->vm_flags;
 
-	if (newflags == oldflags || vma_is_secretmem(vma) ||
-	    !vma_supports_mlock(vma))
+	if (vma_flags_same_pair(&old_vma_flags, &new_vma_flags) ||
+	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
 		/*
 		 * Don't set VM_LOCKED or VM_LOCKONFAULT and don't count.
 		 * For secretmem, don't allow the memory to be unlocked.
 		 */
 		goto out;
+	}
 
-	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
+	vma = vma_modify_flags(vmi, *prev, vma, start, end, &new_vma_flags);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
@@ -490,9 +493,9 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 * Keep track of amount of locked VM.
 	 */
 	nr_pages = (end - start) >> PAGE_SHIFT;
-	if (!(newflags & VM_LOCKED))
+	if (!vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT))
 		nr_pages = -nr_pages;
-	else if (oldflags & VM_LOCKED)
+	else if (vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT))
 		nr_pages = 0;
 	mm->locked_vm += nr_pages;
 
@@ -501,12 +504,13 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 * It's okay if try_to_unmap_one unmaps a page just after we
 	 * set VM_LOCKED, populate_vma_page_range will bring it back.
 	 */
-	if ((newflags & VM_LOCKED) && (oldflags & VM_LOCKED)) {
+	if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
+	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
 		/* No work to do, and mlocking twice would be wrong */
 		vma_start_write(vma);
-		vm_flags_reset(vma, newflags);
+		vma->flags = new_vma_flags;
 	} else {
-		mlock_vma_pages_range(vma, start, end, newflags);
+		mlock_vma_pages_range(vma, start, end, &new_vma_flags);
 	}
 out:
 	*prev = vma;
diff --git a/mm/mprotect.c b/mm/mprotect.c
index eaa724b99908..941f1211da0d 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -756,13 +756,11 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 		vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
 	}
 
-	newflags = vma_flags_to_legacy(new_vma_flags);
-	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &newflags);
+	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &new_vma_flags);
 	if (IS_ERR(vma)) {
 		error = PTR_ERR(vma);
 		goto fail;
 	}
-	new_vma_flags = legacy_to_vma_flags(newflags);
 
 	*pprev = vma;
 
@@ -771,7 +769,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * held in write mode.
 	 */
 	vma_start_write(vma);
-	vm_flags_reset_once(vma, newflags);
+	vma_flags_reset_once(vma, &new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	vma_set_page_prot(vma);
@@ -796,6 +794,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	}
 
 	vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
+	newflags = vma_flags_to_legacy(new_vma_flags);
 	vm_stat_account(mm, newflags, nrpages);
 	perf_event_mmap(vma);
 	return 0;
diff --git a/mm/mseal.c b/mm/mseal.c
index 316b5e1dec78..603df53ad267 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -68,14 +68,17 @@ static int mseal_apply(struct mm_struct *mm,
 	for_each_vma_range(vmi, vma, end) {
 		const unsigned long curr_end = MIN(vma->vm_end, end);
 
-		if (!(vma->vm_flags & VM_SEALED)) {
-			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
+		if (!vma_test(vma, VMA_SEALED_BIT)) {
+			vma_flags_t vma_flags = vma->flags;
+
+			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
 
 			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
-					       curr_end, &vm_flags);
+					       curr_end, &vma_flags);
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
-			vm_flags_set(vma, VM_SEALED);
+			vma_start_write(vma);
+			vma_set_flags(vma, VMA_SEALED_BIT);
 		}
 
 		prev = vma;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 77b042d5415f..ab14b650a080 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2093,6 +2093,9 @@ struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 {
 	struct vm_area_struct *ret;
 	bool give_up_on_oom = false;
+	vma_flags_t new_vma_flags = vma->flags;
+
+	vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
 
 	/*
 	 * If we are modifying only and not splitting, just give up on the merge
@@ -2106,8 +2109,8 @@ struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 		uffd_wp_range(vma, start, end - start, false);
 
 	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
-				    vma->vm_flags & ~__VM_UFFD_FLAGS,
-				    NULL_VM_UFFD_CTX, give_up_on_oom);
+				    &new_vma_flags, NULL_VM_UFFD_CTX,
+				    give_up_on_oom);
 
 	/*
 	 * In the vma_merge() successful mprotect-like case 8:
@@ -2127,10 +2130,11 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 			       unsigned long start, unsigned long end,
 			       bool wp_async)
 {
+	vma_flags_t vma_flags = legacy_to_vma_flags(vm_flags);
 	VMA_ITERATOR(vmi, ctx->mm, start);
 	struct vm_area_struct *prev = vma_prev(&vmi);
 	unsigned long vma_end;
-	vm_flags_t new_flags;
+	vma_flags_t new_vma_flags;
 
 	if (vma->vm_start < start)
 		prev = vma;
@@ -2141,23 +2145,26 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
 		VM_WARN_ON_ONCE(vma->vm_userfaultfd_ctx.ctx &&
 				vma->vm_userfaultfd_ctx.ctx != ctx);
-		VM_WARN_ON_ONCE(!(vma->vm_flags & VM_MAYWRITE));
+		VM_WARN_ON_ONCE(!vma_test(vma, VMA_MAYWRITE_BIT));
 
 		/*
 		 * Nothing to do: this vma is already registered into this
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    (vma->vm_flags & vm_flags) == vm_flags)
+		    vma_test_all_mask(vma, vma_flags))
 			goto skip;
 
 		if (vma->vm_start > start)
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
-		new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;
+		new_vma_flags = vma->flags;
+		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
+		vma_flags_set_mask(&new_vma_flags, vma_flags);
+
 		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
-					    new_flags,
+					    &new_vma_flags,
 					    (struct vm_userfaultfd_ctx){ctx},
 					    /* give_up_on_oom = */false);
 		if (IS_ERR(vma))
diff --git a/mm/vma.c b/mm/vma.c
index 9d194f8e7acb..16a1d708c978 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1710,13 +1710,13 @@ static struct vm_area_struct *vma_modify(struct vma_merge_struct *vmg)
 struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
 		struct vm_area_struct *prev, struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
-		vm_flags_t *vm_flags_ptr)
+		vma_flags_t *vma_flags_ptr)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
-	const vm_flags_t vm_flags = *vm_flags_ptr;
+	const vma_flags_t vma_flags = *vma_flags_ptr;
 	struct vm_area_struct *ret;
 
-	vmg.vm_flags = vm_flags;
+	vmg.vma_flags = vma_flags;
 
 	ret = vma_modify(&vmg);
 	if (IS_ERR(ret))
@@ -1728,7 +1728,7 @@ struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
 	 * them to the caller.
 	 */
 	if (vmg.state == VMA_MERGE_SUCCESS)
-		*vm_flags_ptr = ret->vm_flags;
+		*vma_flags_ptr = ret->flags;
 	return ret;
 }
 
@@ -1758,12 +1758,13 @@ struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
 
 struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
 		struct vm_area_struct *prev, struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, vm_flags_t vm_flags,
-		struct vm_userfaultfd_ctx new_ctx, bool give_up_on_oom)
+		unsigned long start, unsigned long end,
+		const vma_flags_t *vma_flags, struct vm_userfaultfd_ctx new_ctx,
+		bool give_up_on_oom)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
-	vmg.vm_flags = vm_flags;
+	vmg.vma_flags = *vma_flags;
 	vmg.uffd_ctx = new_ctx;
 	if (give_up_on_oom)
 		vmg.give_up_on_oom = true;
diff --git a/mm/vma.h b/mm/vma.h
index 1f2de6cb3b97..270008e5babc 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -342,24 +342,23 @@ void unmap_region(struct unmap_desc *unmap);
  * @vma: The VMA containing the range @start to @end to be updated.
  * @start: The start of the range to update. May be offset within @vma.
  * @end: The exclusive end of the range to update, may be offset within @vma.
- * @vm_flags_ptr: A pointer to the VMA flags that the @start to @end range is
+ * @vma_flags_ptr: A pointer to the VMA flags that the @start to @end range is
  * about to be set to. On merge, this will be updated to include sticky flags.
  *
  * IMPORTANT: The actual modification being requested here is NOT applied,
  * rather the VMA is perhaps split, perhaps merged to accommodate the change,
  * and the caller is expected to perform the actual modification.
  *
- * In order to account for sticky VMA flags, the @vm_flags_ptr parameter points
+ * In order to account for sticky VMA flags, the @vma_flags_ptr parameter points
  * to the requested flags which are then updated so the caller, should they
  * overwrite any existing flags, correctly retains these.
  *
  * Returns: A VMA which contains the range @start to @end ready to have its
- * flags altered to *@vm_flags.
+ * flags altered to *@vma_flags.
  */
 __must_check struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
 		struct vm_area_struct *prev, struct vm_area_struct *vma,
-		unsigned long start, unsigned long end,
-		vm_flags_t *vm_flags_ptr);
+		unsigned long start, unsigned long end, vma_flags_t *vma_flags_ptr);
 
 /**
  * vma_modify_name() - Perform any necessary split/merge in preparation for
@@ -418,7 +417,7 @@ __must_check struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
  * @vma: The VMA containing the range @start to @end to be updated.
  * @start: The start of the range to update. May be offset within @vma.
  * @end: The exclusive end of the range to update, may be offset within @vma.
- * @vm_flags: The VMA flags that the @start to @end range is about to be set to.
+ * @vma_flags: The VMA flags that the @start to @end range is about to be set to.
  * @new_ctx: The userfaultfd context that the @start to @end range is about to
  * be set to.
  * @give_up_on_oom: If an out of memory condition occurs on merge, simply give
@@ -429,11 +428,11 @@ __must_check struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
  * and the caller is expected to perform the actual modification.
  *
  * Returns: A VMA which contains the range @start to @end ready to have its VMA
- * flags changed to @vm_flags and its userfaultfd context changed to @new_ctx.
+ * flags changed to @vma_flags and its userfaultfd context changed to @new_ctx.
  */
 __must_check struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
 		struct vm_area_struct *prev, struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, vm_flags_t vm_flags,
+		unsigned long start, unsigned long end, const vma_flags_t *vma_flags,
 		struct vm_userfaultfd_ctx new_ctx, bool give_up_on_oom);
 
 __must_check struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 58a621ec389f..9dd57f50ea6d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -871,16 +871,20 @@ static inline void vm_flags_reset(struct vm_area_struct *vma,
 	vm_flags_init(vma, flags);
 }
 
-static inline void vm_flags_reset_once(struct vm_area_struct *vma,
-				       vm_flags_t flags)
+static inline void vma_flags_reset_once(struct vm_area_struct *vma,
+					vma_flags_t *flags)
 {
-	vma_assert_write_locked(vma);
-	/*
-	 * The user should only be interested in avoiding reordering of
-	 * assignment to the first word.
-	 */
-	vma_flags_clear_all(&vma->flags);
-	vma_flags_overwrite_word_once(&vma->flags, flags);
+	const unsigned long word = flags->__vma_flags[0];
+
+	/* It is assumed only the first system word must be written once. */
+	vma_flags_overwrite_word_once(&vma->flags, word);
+	/* The remainder can be copied normally. */
+	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
+		unsigned long *dst = &vma->flags.__vma_flags[1];
+		const unsigned long *src = &flags->__vma_flags[1];
+
+		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
+	}
 }
 
 static inline void vm_flags_set(struct vm_area_struct *vma,
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index 44e3977e3fc0..03b6f9820e0a 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -132,7 +132,6 @@ static bool test_simple_modify(void)
 	struct vm_area_struct *vma;
 	vma_flags_t vma_flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_MAYREAD_BIT,
 					     VMA_MAYWRITE_BIT);
-	vm_flags_t legacy_flags = VM_READ | VM_WRITE;
 	struct mm_struct mm = {};
 	struct vm_area_struct *init_vma = alloc_vma(&mm, 0, 0x3000, 0, vma_flags);
 	VMA_ITERATOR(vmi, &mm, 0x1000);
@@ -144,7 +143,7 @@ static bool test_simple_modify(void)
 	 * performs the merge/split only.
 	 */
 	vma = vma_modify_flags(&vmi, init_vma, init_vma,
-			       0x1000, 0x2000, &legacy_flags);
+			       0x1000, 0x2000, &vma_flags);
 	ASSERT_NE(vma, NULL);
 	/* We modify the provided VMA, and on split allocate new VMAs. */
 	ASSERT_EQ(vma, init_vma);
-- 
2.53.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CD7606A338
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 13:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ULIbK9KT
Received: by kanga.kvack.org (Postfix)
	id C7C096B036B; Fri, 23 Oct 2026 09:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52086B036F; Fri, 23 Oct 2026 09:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B680B6B0371; Fri, 23 Oct 2026 09:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E87A6B036B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:48:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 084B1C0426
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:48:01 +0000 (UTC)
X-FDA: 85354019562.20.D0187EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4808320005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:47:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULIbK9KT;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792763279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+2xd0wNhUvtRJM9PIax6dYFGe76M4ZIId4t8JfMr9E=;
	b=dC98i8J1gSAO99zXyfCbVkXeh9ILSctyxVv3rNBaC6fRQuE4jUoaGYkY+309gjwYQfRq1y
	+QzB011R4nvieGRTM7RxMp9reqPXDffri0D0a3VtyWHLJsYOrisGWOOdJVBpeWjvaRSR7i
	6trtJS5EAV1e57y4dQeP44UqCYno1ck=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792763279;
	b=T0XKRmykco1K71yfqgcd2gQg8lhURQZSmeACq+sht+r6y2KBu0aHSsFAnb4YirFevgOuAo
	Mt7VhuF+gBR8n/0cJtNaMOILnn6I7FMIfMHyS6IXecKt5iGv3SEjKa6+ysqT5Zmg3jG0mv
	6cIFiru6HpOdsNzk6DD+ip3SpmGnXxU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ULIbK9KT;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9C1060142;
	Fri, 23 Oct 2026 13:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79F21F01828;
	Fri, 23 Oct 2026 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792763277;
	bh=a+2xd0wNhUvtRJM9PIax6dYFGe76M4ZIId4t8JfMr9E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ULIbK9KTPOHpDUadsRNnMl5O6kk75de7hBkv4iIBuzKcWWEwQTU7ZGRirlbigf5uF
	 lN4p2ia3/J+3XYBQCxCvpwaj17j6rHyg7el7CRBLxkPvr4jOSj+3Ca5RMFI0OKqnFl
	 fgsox4Cu0JKiadvmn8SR90Ide+9NU73+bv1g3m10xI6Xk6RpxFstWJdOj6FDd4/b2H
	 8LcQiBrIIISzdYFDEFEeHIQA2zpa/PRamh6DkVanoZBx2rDPWf3IsVn7H62YiJGWFh
	 4PqPoiRmCg7yL3aPjotVUxxje2ky/uyDJqAB8IRGqzPucH/g+BM/fblUtyDygdC5Eq
	 VxiWQpGJvq7uQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 23 Oct 2026 14:47:27 +0100
Subject: [PATCH 1/4] mm: do not unintentionally overwrite atomic VMA flags
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-fix-vma-atomic-v1-1-8ff4fae1fc85@kernel.org>
References: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
In-Reply-To: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, 
 SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
 Colin Cross <ccross@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=17590; i=ljs@kernel.org;
 h=from:subject:message-id; bh=4Daw+dhWYM4ghHrVvdRNbkZ36ibTHQpK3cskj99W+ng=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJup7Z0pXfoVbbbPe2uPnH52GvP+76ftAIM6xwF6tPkt
 Wem2Yt0lLIwiHExyIopsjz/Ir4/SCRsXucFfzeYOaxMIEMYuDgFYCKCXxj+KS47cfWP0qnXD65z
 vb1/tlPWfdsCYf43k5b+M5it+9T83h2Gv1JFbOpTC+pvL1neIakdtGr7hBi+/V8W+5y+5/BQZvG
 kHlYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4808320005
X-Stat-Signature: 6ohoss6m1irgk981p5szn7hfk6wpzcxy
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792763279-35311
X-HE-Meta: U2FsdGVkX1/4ItSpDGTd+i194LxTLC8C+xU7oXpOXGfEZhPtl9NwcAaeaneDC6ddgVIDJzcvphDYSysEb+rKGbgxHtUeE9N1D2e9lAPP9n++ElATPQu8ZCSqEnRKX65ijsKNeVFcBtWFkH7XPRIPOpYZosETJ7L2fHqRbZAA5IIaDUqQX/AjvqLv5xhpsmv81lwvGkwbiLi3A/LRgnEoiwR0Bp+l8T7HShSCDZoSpWhgPjwY+C3eMAZavZIKO2xQfR7vY4j8toLONiOdwazwbAnrj1Vezk4HelMCOzkEac0DJ64aCeeMEcG3N/SbLIM5HFskRMot/FeHqPJF2OcOySY8tFjHl6Pe89qd+gPP2J1QLSmdguC609DqjKY3aWtTJbd5cAPoo0uWmSLxj2UYKoHz1AgwsBadLeQL9CtntoldKgn7j1CweNhqNL/jE0adPFFvIEsxIvzuwMCUlYSf1q0Y1WIW+MiPxnAcQl7mpuDQOaDDT2lUq7IIJiqGsSZRUzrLKQKiDlN9iCvMz38+zfmuCU44KFivqF6dSqw7Mj5+n2plTYxjENeh+1MOy1vLiInk1FjeVMF8E+5zwlzwmCLTSHZbC/qcZcD77g9YXTOLCQLAhrh6VWjHdN/ilTEvHmfYV4ywBHUdHmrzoJi1VGWFE30URivMtHUpTDxa3AMFWgTF1VuxCOTVOkq7HRJ9wNuGTiV1Q8tV2WrjjrxMxFinBYrudFBSbIiyo/qJYLxWJ/sMOBJ1V9IRTtGdo/iU/KljFPe1o+GDtKUSaao700Ejgrb/4lZ2YT1wa2Y6UuzGfIFyPGqtT852BTao+BOt5bNfTfMRzrwUpT8gh0cHnpUt/P9YtuN8l2I5eA10c3+CRFa0dr/xVEA24FRNIVgCJmUG4gGOyPKHWWXudMCTnBLhlWEws02t8CLxXXBJxZhFkia0ZVtEvYxBzoHzaYXkXbc6uhvZV5Ze7SK2ii9
 JLUFVOH/
 pJXvl3WzfUcO4ofIqD59/OtwI5XlaZ68LLFaM0TkkdCxy1v7ryHHL0mXQ1Cc51B/x3hh9vQGblZtMdSsxF0pJv2mPEHNFuSBunUK5bRyUPnfXKDuxDCdhIhMg/iKL3bDWWsyCC70pr4QTi7M6J4AqdYJ+DuaZFM47sPzcQdu/TUsq1CyXhoc48z4dHDkyoL7vIX/qGedv4qwtttvNiHtJ/gcqitD5Jh9JRdNrxsR84Vx6fK8lZqSsUwyQbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

madvise, mlock and mprotect take a copy of a VMA's flags holding only the
VMA read lock, later writing it back under the write lock (in
madvise_update_vma(), mlock_fixup(), mlock_vma_pages_range() and
mprotect_fixup()).

This was done on the assumption that VMA flags cannot change with a read
lock held.

However this changed in commit 2ab7f1bbafc9 ("mm/madvise: allow guard page
install/remove under VMA lock"), which allowed VM_ATOMIC_SET_ALLOWED
flags (currently only VMA_MAYBE_GUARD_BIT) to be written concurrently under
a VMA read lock.

The actual write itself is safe as this is done under the VMA write lock
at which point no further concurrent writes can occur, however at this
point the stale flags mean that these callers can unintentionally overwrite
atomic flags incorrectly.

The consequences of this are significant - a missing VMA_MAYBE_GUARD_BIT
could result in page tables not being copied on fork (the vma_needs_copy()
check can return false) or being overwritten on file-backed THP
collapse (the file_backed_vma_is_retractable() can return true).

Resolve the issue by always taking care to retain existing atomic flags
when overwriting VMA flags, replacing the inconsistently named
vma_flags_reset_once() with vma_overwrite_flags() to do so, and always
invoking it when flags are overwritten like this.

Reads are a problem too - madvise, mlock and mprotect all compare VMA flags
without a VMA write lock held via vma_flags_same_pair().

This has more serious impact, as concurrent changes to atomic VMA flags can
cause two sets of VMA flags to be wrongly considered different.

For mprotect and madvise this causes a useless split, but mlock is impacted
more seriously as it can result in mm->locked_vm underflow.

Fix this by updating vma_flags_same_pair() to disregard
VM_ATOMIC_SET_ALLOWED VMAs - VMA equality is the same as VMA mergeability,
and atomic VMA flags are disregarded when comparing VMA flags for merge -
so this is justified semantically.

Additionally, remove the redundant vma_flags_same_mask() and the unused
vma_flags_same() as part of the change, and replace VM_ATOMIC_SET_ALLOWED
with VMA_ATOMIC_SET_ALLOWED, using the new VMA flag API.

Finally, update userland VMA tests to reflect the changes.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h              | 166 ++++++++++++++++++++--------------------
 mm/madvise.c                    |   4 +-
 mm/mlock.c                      |   6 +-
 mm/mprotect.c                   |   2 +-
 tools/testing/vma/include/dup.h |  76 ++++++++++--------
 tools/testing/vma/shared.h      |  16 ++--
 6 files changed, 146 insertions(+), 124 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 35f5fc43861a..5f82be0fcde5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -602,7 +602,7 @@ enum {
 #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
 
 /* These flags can be updated atomically via VMA/mmap read lock. */
-#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
+#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
 
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
@@ -987,22 +987,6 @@ static inline void vm_flags_reset(struct vm_area_struct *vma,
 	vm_flags_init(vma, flags);
 }
 
-static inline void vma_flags_reset_once(struct vm_area_struct *vma,
-					vma_flags_t *flags)
-{
-	const unsigned long word = flags->__vma_flags[0];
-
-	/* It is assumed only the first system word must be written once. */
-	vma_flags_overwrite_word_once(&vma->flags, word);
-	/* The remainder can be copied normally. */
-	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
-		unsigned long *dst = &vma->flags.__vma_flags[1];
-		const unsigned long *src = &flags->__vma_flags[1];
-
-		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
-	}
-}
-
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
@@ -1039,48 +1023,6 @@ static inline void vm_flags_mod(struct vm_area_struct *vma,
 	__vm_flags_mod(vma, set, clear);
 }
 
-static __always_inline bool __vma_atomic_valid_flag(struct vm_area_struct *vma,
-		vma_flag_t bit)
-{
-	const vm_flags_t mask = BIT((__force int)bit);
-
-	/* Only specific flags are permitted */
-	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
-		return false;
-
-	return true;
-}
-
-/*
- * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
- * valid flags are allowed to do this.
- */
-static __always_inline void vma_set_atomic_flag(struct vm_area_struct *vma,
-		vma_flag_t bit)
-{
-	unsigned long *bitmap = vma->flags.__vma_flags;
-
-	vma_assert_stabilised(vma);
-	if (__vma_atomic_valid_flag(vma, bit))
-		set_bit((__force int)bit, bitmap);
-}
-
-/*
- * Test for VMA flag atomically. Requires no locks. Only specific valid flags
- * are allowed to do this.
- *
- * This is necessarily racey, so callers must ensure that serialisation is
- * achieved through some other means, or that races are permissible.
- */
-static __always_inline bool vma_test_atomic_flag(struct vm_area_struct *vma,
-		vma_flag_t bit)
-{
-	if (__vma_atomic_valid_flag(vma, bit))
-		return test_bit((__force int)bit, &vma->vm_flags);
-
-	return false;
-}
-
 /* Set an individual VMA flag in flags, non-atomically. */
 static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
 		vma_flag_t bit)
@@ -1302,34 +1244,24 @@ static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
 	return dst;
 }
 
-/* Determine if flags and flags_other have precisely the same flags set. */
+/*
+ * Determine if flags and flags_other have precisely the same flags set,
+ * excluding atomic VMA flags.
+ */
 static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
-						const vma_flags_t *flags_other)
+		const vma_flags_t *flags_other)
 {
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other->__vma_flags;
-
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
-}
+	vma_flags_t diff = vma_flags_diff_pair(flags, flags_other);
 
-/* Determine if flags and flags_other have precisely the same flags set.  */
-static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
-						vma_flags_t flags_other)
-{
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other.__vma_flags;
+	/*
+	 * Atomic VMA flags may be set concurrently under the VMA read lock, so
+	 * are disregarded for equality testing purposes.
+	 */
+	vma_flags_clear_mask(&diff, VMA_ATOMIC_SET_ALLOWED);
 
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+	return vma_flags_empty(&diff);
 }
 
-/*
- * Helper macro to determine if only the specific flags are set, e.g.:
- *
- * if (vma_flags_same(&flags, VMA_WRITE_BIT) { ... }
- */
-#define vma_flags_same(flags, ...) \
-	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
-
 /*
  * Test whether a specific flag in the VMA is set, e.g.:
  *
@@ -1436,6 +1368,78 @@ static __always_inline void vma_clear_flags_mask(struct vm_area_struct *vma,
 #define vma_clear_flags(vma, ...) \
 	vma_clear_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline bool __vma_atomic_valid_flag(struct vm_area_struct *vma,
+		vma_flag_t bit)
+{
+	const vma_flags_t mask = VMA_ATOMIC_SET_ALLOWED;
+
+	/* Is this flag allowed to be set atomically? */
+	if (WARN_ON_ONCE(!vma_flags_test(&mask, bit)))
+		return false;
+
+	return true;
+}
+
+/*
+ * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
+ * valid flags are allowed to do this.
+ */
+static __always_inline void vma_set_atomic_flag(struct vm_area_struct *vma,
+		vma_flag_t bit)
+{
+	unsigned long *bitmap = vma->flags.__vma_flags;
+
+	vma_assert_stabilised(vma);
+	if (__vma_atomic_valid_flag(vma, bit))
+		set_bit((__force int)bit, bitmap);
+}
+
+/*
+ * Test for VMA flag atomically. Requires no locks. Only specific valid flags
+ * are allowed to do this.
+ *
+ * This is necessarily racey, so callers must ensure that serialisation is
+ * achieved through some other means, or that races are permissible.
+ */
+static __always_inline bool vma_test_atomic_flag(struct vm_area_struct *vma,
+		vma_flag_t bit)
+{
+	if (__vma_atomic_valid_flag(vma, bit))
+		return test_bit((__force int)bit, &vma->vm_flags);
+
+	return false;
+}
+
+/*
+ * Overwrite the VMA's flags with new ones, preserving atomic VMA flags in the
+ * process. The write is done once and once only.
+ */
+static inline void vma_overwrite_flags(struct vm_area_struct *vma,
+		vma_flags_t new_flags)
+{
+	vma_flags_t atomic;
+
+	vma_assert_write_locked(vma);
+
+	/*
+	 * Preserve the VMA's atomic flags, which are kept stable by the VMA
+	 * write lock.
+	 */
+	atomic = vma_flags_and_mask(&vma->flags, VMA_ATOMIC_SET_ALLOWED);
+	vma_flags_clear_mask(&new_flags, VMA_ATOMIC_SET_ALLOWED);
+	vma_flags_set_mask(&new_flags, atomic);
+
+	/* It is assumed only the first system word must be written once. */
+	vma_flags_overwrite_word_once(&vma->flags, new_flags.__vma_flags[0]);
+	/* The remainder can be copied normally. */
+	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
+		unsigned long *dst = &vma->flags.__vma_flags[1];
+		const unsigned long *src = &new_flags.__vma_flags[1];
+
+		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
+	}
+}
+
 /*
  * Test whether a specific VMA flag is set in a VMA descriptor, e.g.:
  *
diff --git a/mm/madvise.c b/mm/madvise.c
index 75b409e97dbf..b2e00efcaa54 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -158,7 +158,7 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	bool set_new_anon_name = madv_behavior->behavior == __MADV_SET_ANON_VMA_NAME;
 	VMA_ITERATOR(vmi, madv_behavior->mm, range->start);
 
-	if (vma_flags_same_mask(&vma->flags, new_vma_flags) &&
+	if (vma_flags_same_pair(&vma->flags, &new_vma_flags) &&
 	    (!set_new_anon_name ||
 	     anon_vma_name_eq(anon_vma_name(vma), anon_name)))
 		return 0;
@@ -177,7 +177,7 @@ static int madvise_update_vma(vm_flags_t new_flags,
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
-	vma->flags = new_vma_flags;
+	vma_overwrite_flags(vma, new_vma_flags);
 	/*
 	 * If the vma become good for khugepaged to scan,
 	 * register it here without waiting a page fault that
diff --git a/mm/mlock.c b/mm/mlock.c
index 67ae9b18b923..1c70a7829394 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -432,14 +432,14 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	}
 
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, &walk_flags);
+	vma_overwrite_flags(vma, walk_flags);
 
 	lru_add_drain();
 	walk_page_range_vma(vma, start, end, &mlock_walk_ops, (void *)lock);
 	lru_add_drain();
 
 	if (lock)
-		vma_flags_reset_once(vma, new_vma_flags);
+		vma_overwrite_flags(vma, *new_vma_flags);
 }
 
 /*
@@ -494,7 +494,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
 		/* No work to do, and mlocking twice would be wrong */
 		vma_start_write(vma);
-		vma->flags = *new_vma_flags;
+		vma_overwrite_flags(vma, *new_vma_flags);
 	} else {
 		mlock_vma_pages_range(vma, start, end, new_vma_flags);
 	}
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 754333698c1e..e18d4e12fc34 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -833,7 +833,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	 * held in write mode.
 	 */
 	vma_start_write(vma);
-	vma_flags_reset_once(vma, &new_vma_flags);
+	vma_overwrite_flags(vma, new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	vma_set_page_prot(vma);
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index f449129ea97a..815401b19c57 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -366,6 +366,9 @@ enum {
 
 #define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
 
+/* These flags can be updated atomically via VMA/mmap read lock. */
+#define VMA_ATOMIC_SET_ALLOWED mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+
 #define RLIMIT_STACK		3	/* max stack size */
 #define RLIMIT_MEMLOCK		8	/* max locked-in-memory address space */
 
@@ -895,22 +898,6 @@ static inline void vm_flags_reset(struct vm_area_struct *vma,
 	vm_flags_init(vma, flags);
 }
 
-static inline void vma_flags_reset_once(struct vm_area_struct *vma,
-					vma_flags_t *flags)
-{
-	const unsigned long word = flags->__vma_flags[0];
-
-	/* It is assumed only the first system word must be written once. */
-	vma_flags_overwrite_word_once(&vma->flags, word);
-	/* The remainder can be copied normally. */
-	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
-		unsigned long *dst = &vma->flags.__vma_flags[1];
-		const unsigned long *src = &flags->__vma_flags[1];
-
-		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
-	}
-}
-
 static inline void vm_flags_set(struct vm_area_struct *vma,
 				vm_flags_t flags)
 {
@@ -1037,27 +1024,24 @@ static __always_inline vma_flags_t vma_flags_diff_pair(const vma_flags_t *flags,
 	return dst;
 }
 
+/*
+ * Determine if flags and flags_other have precisely the same flags set,
+ * excluding atomic VMA flags.
+ */
 static __always_inline bool vma_flags_same_pair(const vma_flags_t *flags,
-						const vma_flags_t *flags_other)
+		const vma_flags_t *flags_other)
 {
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other->__vma_flags;
-
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
-}
+	vma_flags_t diff = vma_flags_diff_pair(flags, flags_other);
 
-static __always_inline bool vma_flags_same_mask(const vma_flags_t *flags,
-						vma_flags_t flags_other)
-{
-	const unsigned long *bitmap = flags->__vma_flags;
-	const unsigned long *bitmap_other = flags_other.__vma_flags;
+	/*
+	 * Atomic VMA flags may be set concurrently under the VMA read lock, so
+	 * are disregarded for equality testing purposes.
+	 */
+	vma_flags_clear_mask(&diff, VMA_ATOMIC_SET_ALLOWED);
 
-	return bitmap_equal(bitmap, bitmap_other, NUM_VMA_FLAG_BITS);
+	return vma_flags_empty(&diff);
 }
 
-#define vma_flags_same(flags, ...) \
-	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
-
 static __always_inline bool vma_test(const struct vm_area_struct *vma,
 		vma_flag_t bit)
 {
@@ -1106,6 +1090,36 @@ static __always_inline void vma_clear_flags_mask(struct vm_area_struct *vma,
 #define vma_clear_flags(vma, ...) \
 	vma_clear_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
+/*
+ * Overwrite the VMA's flags with new ones, preserving atomic VMA flags in the
+ * process. The write is done once and once only.
+ */
+static inline void vma_overwrite_flags(struct vm_area_struct *vma,
+				       vma_flags_t new_flags)
+{
+	vma_flags_t atomic;
+
+	vma_assert_write_locked(vma);
+
+	/*
+	 * Preserve the VMA's atomic flags, which are kept stable by the VMA
+	 * write lock.
+	 */
+	atomic = vma_flags_and_mask(&vma->flags, VMA_ATOMIC_SET_ALLOWED);
+	vma_flags_clear_mask(&new_flags, VMA_ATOMIC_SET_ALLOWED);
+	vma_flags_set_mask(&new_flags, atomic);
+
+	/* It is assumed only the first system word must be written once. */
+	vma_flags_overwrite_word_once(&vma->flags, new_flags.__vma_flags[0]);
+	/* The remainder can be copied normally. */
+	if (NUM_VMA_FLAG_BITS > BITS_PER_LONG) {
+		unsigned long *dst = &vma->flags.__vma_flags[1];
+		const unsigned long *src = &new_flags.__vma_flags[1];
+
+		bitmap_copy(dst, src, NUM_VMA_FLAG_BITS - BITS_PER_LONG);
+	}
+}
+
 static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
 		vma_flag_t bit)
 {
diff --git a/tools/testing/vma/shared.h b/tools/testing/vma/shared.h
index 97cd7a679dc1..646edf367d7c 100644
--- a/tools/testing/vma/shared.h
+++ b/tools/testing/vma/shared.h
@@ -51,17 +51,21 @@
 		      __TO_SCALAR(__val1), __TO_SCALAR(__val2)); \
 	} while (0)
 
-#define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) \
-	ASSERT_TRUE(vma_flags_same_mask((_flags), (_flags_other)))
+#define ASSERT_FLAGS_SAME_MASK(_flags, _flags_other) do {		\
+	const vma_flags_t __flags_other = (_flags_other);		\
+	ASSERT_TRUE(vma_flags_same_pair((_flags), &__flags_other));	\
+	} while (0)
 
-#define ASSERT_FLAGS_NOT_SAME_MASK(_flags, _flags_other) \
-	ASSERT_FALSE(vma_flags_same_mask((_flags), (_flags_other)))
+#define ASSERT_FLAGS_NOT_SAME_MASK(_flags, _flags_other) do {		\
+	const vma_flags_t __flags_other = (_flags_other);		\
+	ASSERT_FALSE(vma_flags_same_pair((_flags), &__flags_other));	\
+	} while (0)
 
 #define ASSERT_FLAGS_SAME(_flags, ...) \
-	ASSERT_TRUE(vma_flags_same(_flags, __VA_ARGS__))
+	ASSERT_FLAGS_SAME_MASK(_flags, mk_vma_flags(__VA_ARGS__))
 
 #define ASSERT_FLAGS_NOT_SAME(_flags, ...) \
-	ASSERT_FALSE(vma_flags_same(_flags, __VA_ARGS__))
+	ASSERT_FLAGS_NOT_SAME_MASK(_flags, mk_vma_flags(__VA_ARGS__))
 
 #define ASSERT_FLAGS_EMPTY(_flags) \
 	ASSERT_TRUE(vma_flags_empty(_flags))

-- 
2.56.0



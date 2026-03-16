Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B42CF506CB
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23AC6B0266; Mon, 16 Mar 2026 09:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3C26B026A; Mon, 16 Mar 2026 09:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51F96B026B; Mon, 16 Mar 2026 09:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBA3D6B0266
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:11 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F40B892F7
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:11 +0000 (UTC)
X-FDA: 84551956902.28.CED3E8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B222E18000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jMFk18sm;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qNTRboQnFOzEcDZWjE5gbTfa/sTE7nhGfdbNQAdviM=;
	b=xUmL0CkKjjXOOy/NWad42Kcq3oI52RztQMzSxclz150/mwGtdkGCBYPndebsEsu2XRB3C9
	5U0lvZKwjQNfxlgdZUw/57+WyzBZlznHE1Q2zgvsVTuNE/F12+dtABZ/NPsP+TPIY1i93e
	CsunDEeqlUEpjf/VOCuVu4fwxwGm5dM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666549; a=rsa-sha256;
	cv=none;
	b=5i9YOtfDUfVgTQ/nulYBPezojtzqoyKzrWnZd91A+6cEyZ7lu2KqwLpWq+EGtMhTpMsfpv
	26/xLOEaosduGq9zofz4aOU88kdfYlXOOHrq4jOmWiezTgHsrUmBK/uHrw23UlbH5rEUGq
	teISWANO+PN+Aar8UVgsJgBabEKVk/Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jMFk18sm;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C2D6240E2A;
	Mon, 16 Mar 2026 13:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F7CC19421;
	Mon, 16 Mar 2026 13:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666548;
	bh=dFX8i/GTSiNIxM80Lt/6wl8nx+eQNgs3hUpoH1nEJn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMFk18smoAUK8/iQkecF/D+k4Fm8bjm4Y62bOngadQJFJO1eJVtoUoR5yvb3TpnvH
	 ItcJfNDFkaS1hwr4umR0dz77y2yJonPNOkkbygIC+3M31JRdxx3KLCvdl3UDA/zZ6K
	 L+0cwUopOhiHs4KgH7ynZ8pIwu1Tp3n8f32OxxH7D7bd8n8pwBMzux42iD1c1g0IS4
	 uV6AtCA6ZBPSvitBDr2wuTXw9nkPvQbhj5g2jSmtki81HIxoFhtbkfIqpdmkHCWhpS
	 AGs8UgsjIrqKTJRrPvT1zGlgYCd0YWmkxw2g4T75jcce9dXreobooxdi2hl2Y/gEKb
	 0AtmwCo/kr82Q==
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
Subject: [PATCH v2 05/23] mm/vma: use new VMA flags for sticky flags logic
Date: Mon, 16 Mar 2026 13:07:54 +0000
Message-ID: <005cac3e37830a33f473edc780a5dae5e00a3845.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B222E18000A
X-Stat-Signature: cognquq1y88ocqj17n1xhpn4bn1pcfhn
X-Rspam-User: 
X-HE-Tag: 1773666549-323818
X-HE-Meta: U2FsdGVkX194Je4FaIOcJKEcFks+3sclaZXAyEPoAyydwTRIYC2N0Z1k3u+7LIU8nVk29zXERtN47+C2rsNfQc8nwcZwAOJLHUCmD70MxXmjAdZCz3kgAamiS7w69ePEJXaqI364nnx0M9kKTJzCQdsmyWiETye63TVwxQ68Dq70U+livaVypZ0Op0nDKy86JCh4ZchOIa2KEgKWkxPIqiVfSuoW2HDWgGBF1DAKNwmu3+6vEYbAF8RS7KXKvJZhp87vCFlgDDY5gT6PsuW8q93/UCiY8fnpqJdNTRx+NKoteikA97SQpMlYf4Ugg5xUgDz/8dIvQiNwe/iSzNr//U1Lu19qzaWmqyT6Q7BEuMdqiGqg07zjN1EKSFp+zD280oKysEOjGZ+mEePcQjPIYL22kLhmFJ+9nfjOlYXUasqkNfGHvCMz5relWzYzwb+bDd5D+nB0WAGub08Fhwb/87EEUBZucU+zC8GosoLXInUe98mi7JeCuzGSVfalxUt/FkIH4sww6LuFB42YiIZWZkWZFrQAlU2wKtprk/3CxNYTtHZD0gzIQVoPoQxf4y/30YcBxumIBz96hRpt175mXJrdK0z11mylLABWPGg6Rlj4VR8iFlCoA5F0OViAXJJTIwFnSKirme1w7hCE6D6QsW4wgw4ZooqRDNo96oUcDg0+unmpeFsOFmloba5cLNUcBb9jtbltKsZ33Lpt6BK3qgJShZDzT8qQkZfm1bZ5ILRM74IKx+bORzh19WgNBWc62ajkNgb5bqp1rzG/F7STLEuC2+HWglZnv+W7g+H8ooM+Gvw8rofaAOVLfbcpluIFcVK/vLIpS6fEtQ+oJnuStrdKK/1YeLC/gkCE/mGUrmQEnX6Svgt8e97A1U4mGdIlrlhvW3LP+634yeVNe4I1fHWM1tDVpig74g3wSeL8dzxR4Wmq0KzMGAVrnnU+yP97hKUEJm94XB4v/6zC6Uj
 dfVbaxFt
 twbbv6dyYHxHEc9qfM4rMr9u5ivo0E9v6wlazlArtr6ifL7i5hDzQdUQ158W6DqgVtgO21icTNx6J4F/O172avb/EKFXTMYbgCE0xytcP3vvhNAc0lsBlE9uZiAHf1qm2Oe+TCqQsFGVvoaDFKNb4lWWW/U5pUspiiAw04EyjwJCSq8b86RNgiPX+7ZHX2YbIJC6FvPygxtcboTCRP7AAlu7yk/QQtgsfMPB4u/IHNOcvVLUMpMVr5+/AmYOnEqxgp36z7CZk02hqFjbo8SqkOLyt9b4NLBtAj27GlBrVsRzaQI3Jwu6s9yr75g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the new vma_flags_t flags implementation to perform the logic around
sticky flags and what flags are ignored on VMA merge.

We make use of the new vma_flags_empty(), vma_flags_diff_pair(), and
vma_flags_and_mask() functionality.

Note that we cannot rely on VM_NONE convenience any longer, so have to
explicitly check for cases where VMA flags would not be specified.

Also update the VMA tests accordingly.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h                 | 32 +++++++++++---------
 mm/vma.c                           | 47 ++++++++++++++++++++++--------
 tools/testing/vma/include/custom.h |  5 ----
 tools/testing/vma/include/dup.h    |  9 ++++--
 4 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6d2c4bd2c61d..b75e089dfd65 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -540,6 +540,7 @@ enum {
 
 /* VMA basic access permission flags */
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
+#define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
 /*
  * Special vmas that are non-mergable, non-mlock()able.
@@ -585,27 +586,32 @@ enum {
  * possesses it but the other does not, the merged VMA should nonetheless have
  * applied to it:
  *
- *   VM_SOFTDIRTY - if a VMA is marked soft-dirty, that is has not had its
- *                  references cleared via /proc/$pid/clear_refs, any merged VMA
- *                  should be considered soft-dirty also as it operates at a VMA
- *                  granularity.
+ *   VMA_SOFTDIRTY_BIT - if a VMA is marked soft-dirty, that is has not had its
+ *                       references cleared via /proc/$pid/clear_refs, any
+ *                       merged VMA should be considered soft-dirty also as it
+ *                       operates at a VMA granularity.
  *
- * VM_MAYBE_GUARD - If a VMA may have guard regions in place it implies that
- *                  mapped page tables may contain metadata not described by the
- *                  VMA and thus any merged VMA may also contain this metadata,
- *                  and thus we must make this flag sticky.
+ * VMA_MAYBE_GUARD_BIT - If a VMA may have guard regions in place it implies
+ *                       that mapped page tables may contain metadata not
+ *                       described by the VMA and thus any merged VMA may also
+ *                       contain this metadata, and thus we must make this flag
+ *                       sticky.
  */
-#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
+#ifdef CONFIG_MEM_SOFT_DIRTY
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
+#else
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#endif
 
 /*
  * VMA flags we ignore for the purposes of merge, i.e. one VMA possessing one
  * of these flags and the other not does not preclude a merge.
  *
- *    VM_STICKY - When merging VMAs, VMA flags must match, unless they are
- *                'sticky'. If any sticky flags exist in either VMA, we simply
- *                set all of them on the merged VMA.
+ *    VMA_STICKY_FLAGS - When merging VMAs, VMA flags must match, unless they
+ *                       are 'sticky'. If any sticky flags exist in either VMA,
+ *                       we simply set all of them on the merged VMA.
  */
-#define VM_IGNORE_MERGE VM_STICKY
+#define VMA_IGNORE_MERGE_FLAGS VMA_STICKY_FLAGS
 
 /*
  * Flags which should result in page tables being copied on fork. These are
diff --git a/mm/vma.c b/mm/vma.c
index 4d21e7d8e93c..15d643eee97f 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -86,10 +86,15 @@ static bool vma_is_fork_child(struct vm_area_struct *vma)
 static inline bool is_mergeable_vma(struct vma_merge_struct *vmg, bool merge_next)
 {
 	struct vm_area_struct *vma = merge_next ? vmg->next : vmg->prev;
+	vma_flags_t diff;
 
 	if (!mpol_equal(vmg->policy, vma_policy(vma)))
 		return false;
-	if ((vma->vm_flags ^ vmg->vm_flags) & ~VM_IGNORE_MERGE)
+
+	diff = vma_flags_diff_pair(&vma->flags, &vmg->vma_flags);
+	vma_flags_clear_mask(&diff, VMA_IGNORE_MERGE_FLAGS);
+
+	if (!vma_flags_empty(&diff))
 		return false;
 	if (vma->vm_file != vmg->file)
 		return false;
@@ -805,7 +810,8 @@ static bool can_merge_remove_vma(struct vm_area_struct *vma)
 static __must_check struct vm_area_struct *vma_merge_existing_range(
 		struct vma_merge_struct *vmg)
 {
-	vm_flags_t sticky_flags = vmg->vm_flags & VM_STICKY;
+	vma_flags_t sticky_flags = vma_flags_and_mask(&vmg->vma_flags,
+						      VMA_STICKY_FLAGS);
 	struct vm_area_struct *middle = vmg->middle;
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next;
@@ -898,15 +904,21 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	vma_start_write(middle);
 
 	if (merge_right) {
+		const vma_flags_t next_sticky =
+			vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
+
 		vma_start_write(next);
 		vmg->target = next;
-		sticky_flags |= (next->vm_flags & VM_STICKY);
+		vma_flags_set_mask(&sticky_flags, next_sticky);
 	}
 
 	if (merge_left) {
+		const vma_flags_t prev_sticky =
+			vma_flags_and_mask(&prev->flags, VMA_STICKY_FLAGS);
+
 		vma_start_write(prev);
 		vmg->target = prev;
-		sticky_flags |= (prev->vm_flags & VM_STICKY);
+		vma_flags_set_mask(&sticky_flags, prev_sticky);
 	}
 
 	if (merge_both) {
@@ -976,7 +988,7 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (err || commit_merge(vmg))
 		goto abort;
 
-	vm_flags_set(vmg->target, sticky_flags);
+	vma_set_flags_mask(vmg->target, sticky_flags);
 	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
@@ -1154,7 +1166,10 @@ int vma_expand(struct vma_merge_struct *vmg)
 	struct vm_area_struct *target = vmg->target;
 	struct vm_area_struct *next = vmg->next;
 	bool remove_next = false;
-	vm_flags_t sticky_flags;
+	vma_flags_t sticky_flags =
+		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
+	const vma_flags_t target_sticky =
+		vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
 	int ret = 0;
 
 	mmap_assert_write_locked(vmg->mm);
@@ -1174,10 +1189,13 @@ int vma_expand(struct vma_merge_struct *vmg)
 	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
 		       target->vm_end > vmg->end, vmg);
 
-	sticky_flags = vmg->vm_flags & VM_STICKY;
-	sticky_flags |= target->vm_flags & VM_STICKY;
-	if (remove_next)
-		sticky_flags |= next->vm_flags & VM_STICKY;
+	vma_flags_set_mask(&sticky_flags, target_sticky);
+	if (remove_next) {
+		const vma_flags_t next_sticky =
+			vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
+
+		vma_flags_set_mask(&sticky_flags, next_sticky);
+	}
 
 	/*
 	 * If we are removing the next VMA or copying from a VMA
@@ -1200,7 +1218,7 @@ int vma_expand(struct vma_merge_struct *vmg)
 	if (commit_merge(vmg))
 		goto nomem;
 
-	vm_flags_set(target, sticky_flags);
+	vma_set_flags_mask(target, sticky_flags);
 	return 0;
 
 nomem:
@@ -1950,10 +1968,15 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
  */
 static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *b)
 {
+	vma_flags_t diff = vma_flags_diff_pair(&a->flags, &b->flags);
+
+	vma_flags_clear_mask(&diff, VMA_ACCESS_FLAGS);
+	vma_flags_clear_mask(&diff, VMA_IGNORE_MERGE_FLAGS);
+
 	return a->vm_end == b->vm_start &&
 		mpol_equal(vma_policy(a), vma_policy(b)) &&
 		a->vm_file == b->vm_file &&
-		!((a->vm_flags ^ b->vm_flags) & ~(VM_ACCESS_FLAGS | VM_IGNORE_MERGE)) &&
+		vma_flags_empty(&diff) &&
 		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
 }
 
diff --git a/tools/testing/vma/include/custom.h b/tools/testing/vma/include/custom.h
index 6200f938e586..7cdd0f60600a 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -134,8 +134,3 @@ static __always_inline bool vma_flags_same_mask(vma_flags_t *flags,
 	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
 #define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
 				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#ifdef CONFIG_MEM_SOFT_DIRTY
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
-#else
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
-#endif
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 44f77453ee85..e5fdf6f5a033 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -338,6 +338,7 @@ enum {
 
 /* VMA basic access permission flags */
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
+#define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
 /*
  * Special vmas that are non-mergable, non-mlock()able.
@@ -363,9 +364,13 @@ enum {
 
 #define CAP_IPC_LOCK         14
 
-#define VM_STICKY (VM_SOFTDIRTY | VM_MAYBE_GUARD)
+#ifdef CONFIG_MEM_SOFT_DIRTY
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
+#else
+#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
+#endif
 
-#define VM_IGNORE_MERGE VM_STICKY
+#define VMA_IGNORE_MERGE_FLAGS VMA_STICKY_FLAGS
 
 #define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_MAYBE_GUARD)
 
-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A98106ACE1
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D756B0092; Thu, 12 Mar 2026 15:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9553A6B0093; Thu, 12 Mar 2026 15:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E1D26B0096; Thu, 12 Mar 2026 15:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5866B0092
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:16:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E86A8A457
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:49 +0000 (UTC)
X-FDA: 84538368138.10.51492A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6B4771C000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O+OujBKE;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gq++wDEUFNJQWemiTiWJTbrSGfuuoFHTP0GjuMTFMdY=;
	b=wfZH4akKFLVx/aLMqBW2GOD0bbkjYYzhudz1e/tyNBjCi5wH5Bds0W0D7JRP05cpnncxL0
	u8pIpHqolOo0bgYOuIgy3wiTyviFYc7xk8dnMg8Oaqwkm1re02NaUGfHgtNyDebQAU0wmW
	4Fl8tm6mWf6F4fwT397MAs7kGAKPcfs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343007; a=rsa-sha256;
	cv=none;
	b=yTq8C7cyRAEXi5EwO0vIYtzLRqSs3OXFiHD3ligg1cKGASHDM4DOPQQDv9YAUdToNceMf8
	aQ7QxV7ShmLG8rHR1N+3PXM3RrRNZn5LzqGdUQtFrr7lWVeJX600ANmeUTGRlX79nxVqAr
	p57Xu5Yv5wbjnJxYsTSFLa0P2K88Rgk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O+OujBKE;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C0FB444EB;
	Thu, 12 Mar 2026 19:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF99C19425;
	Thu, 12 Mar 2026 19:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343006;
	bh=27TjpYbSJCAt3p0fvuF6wB/K3CgnOl6cTI+KsNTsFvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O+OujBKEkZlxUGcx/64AARbUIuVorUrCKe2i2FYV4ky4XnE+a2QJ63hp6j94am0sN
	 FQsDNw01iw4/wtEut3K+s+w1nQ6ALYKtr4CTIP53EIei1YYXaWiamb0YlPs9r3ivwG
	 UNf3ghtO0g8kLukmBLZwdPwZZGWFLjwRTau518tV1TTor1T7TkPIsEEfR2J7xQBTBJ
	 3/C4oeYzsg06Jt9FnXQYd+GybD0f9If5f/2z8AaR6Kzs08y2NLWEeR7XOtAjCO8CoY
	 zQnzX53pZDYqZqZ4SVbEsP1dB+UPj5aOnRzVmZqbaPXtKdldH3I7aMgOBB9HAjoMnK
	 OTDcLiiNep1mQ==
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
Subject: [PATCH 05/20] mm/vma: use new VMA flags for sticky flags logic
Date: Thu, 12 Mar 2026 19:16:03 +0000
Message-ID: <1c1de926ad498edf8fa4fe9bad3783e922b62aab.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B4771C000E
X-Stat-Signature: 6icr1oj69nwassk8rujey9gqk8cbwkfx
X-HE-Tag: 1773343007-620987
X-HE-Meta: U2FsdGVkX1+pTF/2gkRFV+bLZYimS7V8Wnztc+A1EPG+YPX0ANyIv3tm8FJZmf3/aRQ0BE161z6sbPkEuKWkkCyE9X5YZWnO8RE7QuFU+Ugo+o8otIKwJhpfiyfiCEJrWXmZwd6BCY94/zNkcslk6mbCUlqrZOGdHv1TpFFWnkFeOW8vHDDHHfh14MA3BjZ8qZTJZowAXZYprx5GQavxzAKY3TRnH/uXlrV0uQWsSgB/HJ2U1TCfVuXsaxUhVrEVd+UkTmS9m2EzRbav38Qw1FjM37GnaKSdyOs5G7BVRxQlQAeVGNZbWe6rg7AG/bWD+Tbuq2H2khwvO6P8dT4VHW8h++JQUUR/Ac0Q7L6AEf3F84pulh652mnL+kA1m+AJUQ6r1PnSxdonQiMwaTB1KE8dPajIsC1Ks8i28u8t2LzIeYV+rro2Ozu85nAeHky5RWCxkFcFmg/Kb/Xzf1cX0Y5OSKJMYiDer1semnxC+BqfX3qykWUgYbqcbZ7KKCxeKXjxxmg6Xp+pc7hSLsAEhx4bRMeGDuNoZ2zvu4m0pzvnAYe3oLeJiUbQtIDoy92gILA7ZlYJPVctznzJ2JIKe6qbbaI6IhmsYOrJROnv0dPmGqUTH1MGLiMUGSZ6ZXBmGh0Un4NoZJf8hsBWm+D8ZDXyCnMuLOsy6oY6fR+aroyBcxQb8S3XkyNTGvTb0NeAXMC8+f0G9IkSikwe+xByEkUNEjKOFwrafOrd0k6Q3xbcncq/qMsVxFKaZ+KpZSCZ+YPyVc6TkUNqqPmVZvUGfpmNDh9V0LstcJ/KWNY6QKjv0ZJ2qvFoBfl2n2yPDaCSDHWMM5peZaDND2sLPOKZAfOafEp7A+UPBo4TWeEaBu+KiOMlz7XW32uf020tQrERpAngpwCBYqSEMakidqdPXUEiszh9npitzq1bKO8VPb6L3PsA2XFfZrGC3pTJSw1wvC/nVhlzvO8ACo5jfP/
 NCsNLynu
 bsbQTuDIACWgKpQKXcQZNiBFy7PKNPRKJy0szslkDdYG8u3b7Z+Eau1HOoaVsqkX92XUkSpGTed4TkWtACb1JhGBap7Gr0z0Een5qy4dKzIlnczKPQIggjgIy8HHEqs44lfZpl31Mi68idjm520dHRw/W6L4kQm8gVBSLhHa9w8lENJRCN+K5WOVN5JTW6vjhPJEq+hlA6yJAgxgjJCJGlSYgaEiO5Oo+MVw8L8CFffEf8NjksWYq7++MQ8VAcVEMY7/+5qMY8qhORyC/BoiZTWHi7Rnc0WTw6wa3MG9jsuifqBhR3bvpfEM2WA==
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
index 3d82e53875fa..7acd2f0237eb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -542,6 +542,7 @@ enum {
 
 /* VMA basic access permission flags */
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
+#define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
 
 /*
  * Special vmas that are non-mergable, non-mlock()able.
@@ -587,27 +588,32 @@ enum {
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
index be64f781a3aa..6168bdc772de 100644
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
index da84f54cf977..6f43bbc494e2 100644
--- a/tools/testing/vma/include/custom.h
+++ b/tools/testing/vma/include/custom.h
@@ -132,8 +132,3 @@ static __always_inline bool vma_flags_same_mask(vma_flags_t *flags,
 	vma_flags_same_mask(flags, mk_vma_flags(__VA_ARGS__))
 #define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
 				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
-#ifdef CONFIG_MEM_SOFT_DIRTY
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_SOFTDIRTY_BIT, VMA_MAYBE_GUARD_BIT)
-#else
-#define VMA_STICKY_FLAGS mk_vma_flags(VMA_MAYBE_GUARD_BIT)
-#endif
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 005cef50704f..069910f63b84 100644
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



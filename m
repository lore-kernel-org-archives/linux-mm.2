Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF627F506CE
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C756B028A; Mon, 16 Mar 2026 09:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E98D6B028C; Mon, 16 Mar 2026 09:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8BD6B028D; Mon, 16 Mar 2026 09:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA826B028A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:10:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CCB861C0CE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:59 +0000 (UTC)
X-FDA: 84551958918.20.C43CD68
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 386E1A000B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owVvgHdQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+pNmAF7DTWwAyqDRRIVCiElw57a2F7eTZ90xEYXMTls=;
	b=twYKnuPVdkr9BqiIMfDAQtX98uPu5m0uOTap445gll6b5QXJxjp3yxIfoGvmv0AwPZFXOP
	f2ZNgb13aVzAL8rXfsvuq0MsHt3X4+ZdfI/1fge3RQiLKWCY1fMswm9MjKbeMm5WHJfFAT
	99HHmmjOs8ETrfYsq6pKLQ0p3yw7V+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666598; a=rsa-sha256;
	cv=none;
	b=4GBUK0xihihabO0wp9OFhnyrNSiIjzVvizWKuLChnXWknPz61NZLNL3ERSq2c7XKo56GUs
	j02KTg+pv+W1DWZaOVcz+7DU2Pma63u0s3KeJ0SUrG4VDPvcTV1kxW0PwO0ZlHjHq4R7t9
	Oh10qFmRTH11sFmkfu20Ritp3xPv8Ws=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=owVvgHdQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81F406111A;
	Mon, 16 Mar 2026 13:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96089C2BCB0;
	Mon, 16 Mar 2026 13:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666597;
	bh=ZfseWqRX8Yx8edZ7CGc34zafbzETmc7olmc931lf7fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owVvgHdQ3wFpRGJQepgqx/wRcH31KkpN5fXewjuldA3jvkwmBTE8PsoB/VsczA3lJ
	 vFtYRYCqOENUYc56owMDmWHlzj9cB3aYgB/t/h4wHLt290Uf1huSF+DRqcPBvdfO6s
	 Q74Nsa6miupzJ6w0Ot73dIrWb5kGDoK+fJbEKSU15DiOQ89ab3HztjYXdXsquoFjJi
	 jeFdPiw08NNFjq7DTqtmjF+8cW9SXSx6z/G9sP/N/mehrfJqEvK4YvgnaKDqFUwcDS
	 YD495CVEsqIuZZAB/BoljuxWOITj4i+zMb5jDkjm+WmYTfhRZhxLkGY965MZRv/DUi
	 H9Izz/ThFT+6w==
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
Subject: [PATCH v2 22/23] mm/vma: convert vma_modify_flags[_uffd]() to use vma_flags_t
Date: Mon, 16 Mar 2026 13:08:11 +0000
Message-ID: <0737c1b5e3b3688ec3839058b95203c9e7622de9.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 386E1A000B
X-Stat-Signature: njsbxdzu5rtztr336hpds3hi6rriyyhw
X-Rspam-User: 
X-HE-Tag: 1773666598-35050
X-HE-Meta: U2FsdGVkX18z3pZPguYOjyeE3UjraWi/cpSFxqJRZg4UuGty1yEArV4tjCNevx3s10fvmYKyxqpIekmRo9WaDu4XwRv0VZLOtY2+YCGKZYAZCxa86fcDLqeekGArwkZutbZ0s9NLDCGnDUczVkRCOJ8MFEzs7uOcbdWbgoVirmnyoIe90gfr/LoUpyp14B/sZqZE6iC/TiMInFaS2EV+W8+3hCGyz3JAvYwq0BxLkBPfPKi4L/DFgYsz5AM7mB9lWR1YlHO3ayQ2h7mnWMdCtCHuMxNvuuSpf88p9LgS9MoOOhsyASTlFXKI8GnNgxB/354GpFaP6KvqaBPjI7qA0vLGCYQZeFryayOqHy8Me0PqUfIJjozpAY3yrGVBbZPlHVhVYm6eVUDTYIH/hxViBCGAWi+jg90ln3mA/UbjXyzgqc/C6hx6zITydtYpIRO+gZlVuiSv+oTum2tCw9PU0AOy836aDi0ysiGnvFxhVKHSr8ndGT8wUWFLbwYZazIGr+I/LhCrBkjCLQ7idbtNGRDdSk+JYgWR76/O3m6xDpLS7VV1N1nzGgKTBgcQgq+VhT8R3noLF0//ijdVhsDuo7KXcNcj0u/3ro4ahbTea56u4QyvgmMr7MExpPD+9Q2fAwd5w0dryNlqXTfR4O5/KExGSRYZVjG8CaxTxWBf3mCFJyEo2aOpQcAy+eqHnUQghNejsB+qo3u4ThCN1Qqircc7qkdiW6XWsj8/3BiblmSohrF0lk/bX22yVVLaxb6tSo7H8O1EQdB6byHO1L+okJupSugldaRG4v1DUxCKE1Tj+2xntUXJDyM6j8bx7caK5o8F55tNn6IiRdLHCDKywWen/CBNLofMhVv4mkofPuxkosyHkQ3CbHx9LG5zTlin8YDNef00Sp5+6RIGRTYgY+7OjAkVAyqVfv16iXpDUeE35VZQTD4PRuNRDBYTurkdlocAnR2HhpgT//9d0tl
 X9LrE73o
 oAhC3O5vsu82PrxV4HD3H2KHmtY5h6NetuUzoQpFTz6VIhVkLO5tWOeL9apt1QT+qYSjyigNwL9OFIfT9ctxEE3CcjGGRp9lDPs+wezzFtLUcy8WMEqeO+2as7Hmy0vkzm/iAygGWXaPsYFBNISMfwr7fK+mjCF6LvqKN0Y69e6q0dC51PRsQcP85TxQqC49uBvKww5M8h0utN7SQubiMsr0IU5H6qwDA3dRgQAI+wdI8SOPZVQbWu3T63c8wZxFqen4i0etNn/MSEaVSVDn4RqJU2QzGuD596on3mzZbwxqneajacnEAHpS8WkmT1RpdLrCP7xzD6F5JnVSWlkqiZNZSqDCoEaG12vtc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the vma_modify_flags() and vma_modify_flags_uffd() functions to
accept a vma_flags_t parameter rather than a vm_flags_t one, and propagate
the changes as needed to implement this change.

Finally, update the VMA tests to reflect this.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/userfaultfd_k.h   |  3 +++
 mm/madvise.c                    | 10 +++++----
 mm/mlock.c                      | 38 ++++++++++++++++++---------------
 mm/mprotect.c                   |  7 +++---
 mm/mseal.c                      | 10 +++++----
 mm/userfaultfd.c                | 21 ++++++++++++------
 mm/vma.c                        | 15 +++++++------
 mm/vma.h                        | 15 ++++++-------
 tools/testing/vma/tests/merge.c |  3 +--
 9 files changed, 69 insertions(+), 53 deletions(-)

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
index 311bb3e814b7..6d12ffed1f41 100644
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
+	WRITE_ONCE(vma->flags, *new_vma_flags);
 
 	lru_add_drain();
 	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
 	lru_add_drain();
 
-	if (newflags & VM_IO) {
-		newflags &= ~VM_IO;
-		vm_flags_reset_once(vma, newflags);
+	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
+		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
+		WRITE_ONCE(vma->flags, *new_vma_flags);
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
index eaa724b99908..2b8a85689ab7 100644
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
+	WRITE_ONCE(vma->flags, new_vma_flags);
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
index 316b5e1dec78..fd299d60ad17 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -68,14 +68,16 @@ static int mseal_apply(struct mm_struct *mm,
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
+			vma_set_flags(vma, VMA_SEALED_BIT);
 		}
 
 		prev = vma;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 510c6dcb9824..9aea5822e78e 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2094,6 +2094,9 @@ struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 {
 	struct vm_area_struct *ret;
 	bool give_up_on_oom = false;
+	vma_flags_t new_vma_flags = vma->flags;
+
+	vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
 
 	/*
 	 * If we are modifying only and not splitting, just give up on the merge
@@ -2107,8 +2110,8 @@ struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 		uffd_wp_range(vma, start, end - start, false);
 
 	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
-				    vma->vm_flags & ~__VM_UFFD_FLAGS,
-				    NULL_VM_UFFD_CTX, give_up_on_oom);
+				    &new_vma_flags, NULL_VM_UFFD_CTX,
+				    give_up_on_oom);
 
 	/*
 	 * In the vma_merge() successful mprotect-like case 8:
@@ -2128,10 +2131,11 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
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
@@ -2142,23 +2146,26 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
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
index 456c8e2cc5bc..f52fe7f9bae4 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1709,13 +1709,13 @@ static struct vm_area_struct *vma_modify(struct vma_merge_struct *vmg)
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
@@ -1727,7 +1727,7 @@ struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
 	 * them to the caller.
 	 */
 	if (vmg.state == VMA_MERGE_SUCCESS)
-		*vm_flags_ptr = ret->vm_flags;
+		*vma_flags_ptr = ret->flags;
 	return ret;
 }
 
@@ -1757,12 +1757,13 @@ struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
 
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



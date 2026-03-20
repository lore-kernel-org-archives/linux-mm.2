Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27F41099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F360A6B011C; Fri, 20 Mar 2026 15:56:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0D266B011E; Fri, 20 Mar 2026 15:56:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22CE6B011F; Fri, 20 Mar 2026 15:56:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D29ED6B011C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:56:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78D7B1DBCE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:56:52 +0000 (UTC)
X-FDA: 84567499464.06.2E1D0CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C630F4000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:56:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oHu1iIaD;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774036611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eH+lF3DsYQg10YJACe8d4HP9oKGSpGl0WwoSsVRRUzI=;
	b=xjPBNzkjBjxseaK82f7lg5BeGeUthOMASe+MYQPz+/RYBloFncHuoV0HuDJcMnDK9RiKsd
	PP3kkr7GlVcCeRKGuWbaCBs1iHIAzFP3oTXB/GzalttWBBnAnQmvNPLUj/aoqXzkDiibyo
	sBaOk7W9E0BsTECesMK7p0SElDe6138=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oHu1iIaD;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774036611; a=rsa-sha256;
	cv=none;
	b=7cbmPZGwiMaoe/ch/jQHGUIC2YMxmhZhYreXTjI/rc++suhCReaIVkNLq8aF3L7/WO4n3D
	L/05VQBvNRCEfqf55oFv4uiiZ+rzVr6oKc3K7oeztTklSKIrhdQIDtrpo3qOmWxEhM9rrB
	pozk5B/fCC719+1ixITas70LS1My/aA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F60841784;
	Fri, 20 Mar 2026 19:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5EEC4CEF7;
	Fri, 20 Mar 2026 19:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774036609;
	bh=LKrgpfKwmWI5Hg0tjL/sG/ayUWE0EjUljcbdrX6qjaA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oHu1iIaD1c8+N5EEXiAifxJInrM70H4yjmiFgxSXgLi+71ohYV12gifq8+a2nU2px
	 p48V9CZfD1mp4jyrfUp9eEy3Ga3ofXBh3zTM64zIa4xHEgSIzKpQTILlbDP/adsioC
	 0Q1vxPdJ7/9HXC2iUZCdf9e1QCnOUsvW7RLc5H7o=
Date: Fri, 20 Mar 2026 12:56:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Kees Cook
 <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vineet
 Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian
 Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Dinh
 Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin"
 <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Michal
 Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley
 <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 selinux@vger.kernel.org
Subject: Re: [PATCH v4 00/25] mm/vma: convert vm_flags_t to vma_flags_t in
 vma code
Message-Id: <20260320125647.f6be89a9f40b37b71e511423@linux-foundation.org>
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C630F4000C
X-Stat-Signature: 37hjphme9frmaregkgrjthz64qx3cffd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774036610-22438
X-HE-Meta: U2FsdGVkX19nxsCzPF7gZXJZScz9RRk4qPg6PFIaOq7p+VXaXAz9QjeLxTLGQl0vmXiVvc85lgjYNd7xF6Oe33RsFKk6jC1S3Bo1Hbn9hSZAvvOowtnUj9Xg/9oeCirh1nqEjRc94ZS+B5ol0hL4Vanon5N+aqxwxOIt9paJ++tK0oXeWPHUzyLPs1aDvuZv/Kyu3M/BM+Rv1VMGRhA0X7T7ZqKCZx14CenZuKb+qfGGqaCxXpdzOyzki8y74U0FkH1DoYTYr5oBPaO30S8ZJMNSbD79kKAoK0g1OTJkbSI6YjWv0+H8gbLHzV9/uQJjlJWhQaVJC8qjiAFjwPyZOnTxSvz7AenVx2eD2MQtOa49IcabKOQF34nZO3GJ5pdbNzZutasusB7Ok0HMm6ITMscGEtYHwVCrZkW6i7/vt+TAioIJ/858a9Hwcj3FH+uGvOXxDGXExr5GJTNZVVO/qi1c69crqeAypchzOJik08UFJtYyEaEIBBfqyTZrSQR6ngpbsdxVAKg7ts1wNIIiGk+CxaQJwS3sc7Zn470OCX4H2sd9XeCrJsRT+aTV1oHn0YCD1PthDQ6qXfRxDxIxdPInX8HonUFOCKfo4D3Y9+d3nl5BwFpuOCYPdqwTgmFEGyWqhVxfrIeGt5gU55Go84Yxd4sprHczLaGJd4gSLEmfPVvyBaAhrk94mBkE1gWK8FA6CKr71qF9/QSe/uQ+kFh6QwlSnWS3bwkRaaBbQaWxN2b4pLa2z6mjDkgJC9h7CEQY9RBzQqjjtNYSVcuL5FqYAtw/icb+C+tUkKCUp/H5f6uyNdyw6VSBY3rk3O9uWlmUJsWMuEbfQmPyjhav26OXNwxMlt/2nqK/qRJxRv/pjzmFsSxEqSgjym+3oqkA0YMgvXKkL7Zv9twFK/EejSo6CMtClngMbsYdml0KhvsBDovAgcLHRxPesu9OAXpgS7a3coqElZrsGP7nEp1
 A4tjJ8rv
 YdeDpyev4C0pPwEsBOccxSgqo57FcYEWZDLggPDbpZOHpksAu4xdxbxEZbZYpoSwzoOPkU5tMC0LssHridCqV6JHQ6SqC8RhhBjGeU8enlZtPdaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 19:38:17 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> This series converts a lot of the existing use of the legacy vm_flags_t
> data type to the new vma_flags_t type which replaces it.

Thanks, I updated mm.git's mm-unstable branch to this version.

> v4:
> * Propagated tags, thanks Vlasta!
> * Removed superfluous parens around vma_test_any_mask() as per Vlasta.
> * Converted masked functions into more understandable equivalent form as
>   per Vlasta in 24/25.
> * Redefined VM_SPECIAL using vma_flags_to_legacy() as per Vlasta.
> * Fixed whitespace as per Vlasta.
> * Added vma_flags_reset_once() as per Vlasta.
> * Expanded 22/23 commit message to describe why I'm replacing things as
>   per Vlasta.
> * Added bitmap_copy() to test headers in order to implement
>   vma_flags_reset_once().

Here's how v4 altered mm.git:


 include/linux/mm.h              |   26 ++++++++++++--------------
 mm/mlock.c                      |    4 ++--
 mm/mprotect.c                   |   14 +++++---------
 mm/vma.c                        |   11 +++++------
 mm/vma.h                        |    6 ++----
 tools/include/linux/bitmap.h    |   11 +++++++++++
 tools/testing/vma/include/dup.h |   22 +++++++++++++---------
 7 files changed, 50 insertions(+), 44 deletions(-)

--- a/include/linux/mm.h~b
+++ a/include/linux/mm.h
@@ -554,10 +554,10 @@ enum {
 /*
  * Special vmas that are non-mergable, non-mlock()able.
  */
-#define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
 
 #define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
 				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)
+#define VM_SPECIAL vma_flags_to_legacy(VMA_SPECIAL_FLAGS)
 
 /*
  * Physically remapped pages are special. Tell the
@@ -959,22 +959,20 @@ static inline void vm_flags_reset(struct
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
@@ -1442,7 +1440,7 @@ static __always_inline void vma_desc_set
  * vm_area_desc object describing a proposed VMA, e.g.:
  *
  * vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
- *              VMA_DONTDUMP_BIT);
+ * 		VMA_DONTDUMP_BIT);
  */
 #define vma_desc_set_flags(desc, ...) \
 	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
--- a/mm/mlock.c~b
+++ a/mm/mlock.c
@@ -443,7 +443,7 @@ static void mlock_vma_pages_range(struct
 	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
 		vma_flags_set(new_vma_flags, VMA_IO_BIT);
 	vma_start_write(vma);
-	WRITE_ONCE(vma->flags, *new_vma_flags);
+	vma_flags_reset_once(vma, new_vma_flags);
 
 	lru_add_drain();
 	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
@@ -451,7 +451,7 @@ static void mlock_vma_pages_range(struct
 
 	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
 		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
-		WRITE_ONCE(vma->flags, *new_vma_flags);
+		vma_flags_reset_once(vma, new_vma_flags);
 	}
 }
 
--- a/mm/mprotect.c~b
+++ a/mm/mprotect.c
@@ -769,7 +769,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 	 * held in write mode.
 	 */
 	vma_start_write(vma);
-	WRITE_ONCE(vma->flags, new_vma_flags);
+	vma_flags_reset_once(vma, &new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
 	vma_set_page_prot(vma);
@@ -784,14 +784,10 @@ mprotect_fixup(struct vma_iterator *vmi,
 	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
 	 * fault on access.
 	 */
-	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT)) {
-		const vma_flags_t mask =
-			vma_flags_and(&old_vma_flags, VMA_WRITE_BIT,
-				      VMA_SHARED_BIT, VMA_LOCKED_BIT);
-
-		if (vma_flags_same(&mask, VMA_LOCKED_BIT))
-			populate_vma_page_range(vma, start, end, NULL);
-	}
+	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
+	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT) &&
+	    !vma_flags_test_any(&old_vma_flags, VMA_WRITE_BIT, VMA_SHARED_BIT))
+		populate_vma_page_range(vma, start, end, NULL);
 
 	vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
 	newflags = vma_flags_to_legacy(new_vma_flags);
--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -2343,7 +2343,6 @@ void mm_drop_all_locks(struct mm_struct
 static bool accountable_mapping(struct mmap_state *map)
 {
 	const struct file *file = map->file;
-	vma_flags_t mask;
 
 	/*
 	 * hugetlb has its own accounting separate from the core VM
@@ -2352,9 +2351,9 @@ static bool accountable_mapping(struct m
 	if (file && is_file_hugepages(file))
 		return false;
 
-	mask = vma_flags_and(&map->vma_flags, VMA_NORESERVE_BIT, VMA_SHARED_BIT,
-			     VMA_WRITE_BIT);
-	return vma_flags_same(&mask, VMA_WRITE_BIT);
+	return vma_flags_test(&map->vma_flags, VMA_WRITE_BIT) &&
+		!vma_flags_test_any(&map->vma_flags, VMA_NORESERVE_BIT,
+				    VMA_SHARED_BIT);
 }
 
 /*
@@ -3001,7 +3000,7 @@ retry:
 	gap += (info->align_offset - gap) & info->align_mask;
 	tmp = vma_next(&vmi);
 	/* Avoid prev check if possible */
-	if (tmp && (vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS))) {
+	if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
 		if (vm_start_gap(tmp) < gap + length - 1) {
 			low_limit = tmp->vm_end;
 			vma_iter_reset(&vmi);
@@ -3054,7 +3053,7 @@ retry:
 	gap_end = vma_iter_end(&vmi);
 	tmp = vma_next(&vmi);
 	 /* Avoid prev check if possible */
-	if (tmp && (vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS))) {
+	if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
 		if (vm_start_gap(tmp) < gap_end) {
 			high_limit = vm_start_gap(tmp);
 			vma_iter_reset(&vmi);
--- a/mm/vma.h~b
+++ a/mm/vma.h
@@ -529,10 +529,8 @@ static inline bool is_data_mapping(vm_fl
 
 static inline bool is_data_mapping_vma_flags(const vma_flags_t *vma_flags)
 {
-	const vma_flags_t mask = vma_flags_and(vma_flags,
-			VMA_WRITE_BIT, VMA_SHARED_BIT, VMA_STACK_BIT);
-
-	return vma_flags_same(&mask, VMA_WRITE_BIT);
+	return vma_flags_test(vma_flags, VMA_WRITE_BIT) &&
+		!vma_flags_test_any(vma_flags, VMA_SHARED_BIT, VMA_STACK_BIT);
 }
 
 static inline void vma_iter_config(struct vma_iterator *vmi,
--- a/tools/include/linux/bitmap.h~b
+++ a/tools/include/linux/bitmap.h
@@ -55,6 +55,17 @@ static inline void bitmap_fill(unsigned
 	dst[nlongs - 1] = BITMAP_LAST_WORD_MASK(nbits);
 }
 
+static __always_inline
+void bitmap_copy(unsigned long *dst, const unsigned long *src, unsigned int nbits)
+{
+	unsigned int len = bitmap_size(nbits);
+
+	if (small_const_nbits(nbits))
+		*dst = *src;
+	else
+		memcpy(dst, src, len);
+}
+
 static inline bool bitmap_empty(const unsigned long *src, unsigned int nbits)
 {
 	if (small_const_nbits(nbits))
--- a/tools/testing/vma/include/dup.h~b
+++ a/tools/testing/vma/include/dup.h
@@ -871,16 +871,20 @@ static inline void vm_flags_reset(struct
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
_



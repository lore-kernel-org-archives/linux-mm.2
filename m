Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4BC81099B3B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35A256B01A4; Fri, 20 Mar 2026 15:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4816B01A6; Fri, 20 Mar 2026 15:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FB86B01A7; Fri, 20 Mar 2026 15:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECBEA6B01A4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1A1514037F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:36 +0000 (UTC)
X-FDA: 84567455952.20.B703B5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 373FC14000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q59qqbfk;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrYK9SeP+xmP+xx2YWM11Rsl6S8Mh5l/Y3xtgjj3Zpk=;
	b=L5qkCdGDat1u7Vsj30TXQQNghUUrAMU/ZC7V5625R5cudW+12+uVpRC7Hah6UqG62TIGNT
	ewvgE1M8Vw+2WmH+hJ5uWLjFgUhUNc+60CVDxro2ZNaD3eqbQcqrKcar3M/2u1qJzBTZjy
	BtCWkM/GoDC9VEp0wK2zOk69aSEuc+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035575; a=rsa-sha256;
	cv=none;
	b=3z022RIGNpTwlNYka0FGbI0yeHdDKhW2A7qHob+mdYHKbDETBfreW+69qNkZ/1qp98ERhj
	ahF4l2vLg28eAfhkp5j8Ecz9gCpkAfQfcLHL0jAUje/JQmQ5faNC/5JCaQqXqp99Br7vbz
	c96zzez/pIhxH4FIpDCcZFhxsRFbVSY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q59qqbfk;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 514B66184C;
	Fri, 20 Mar 2026 19:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275F6C2BCB5;
	Fri, 20 Mar 2026 19:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035573;
	bh=GS26yemJRp4WGgd622BkAQW70iHNpN1ji8DjZ9UUaoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q59qqbfkBTeE6wXXEpJnLAIVeXz3C459bADVmHodISvStijZodCm6VuUiKZKMuMlu
	 waflKkttPJmdnVxyaSobsnpMAXzxck3a1h/9DqTF4M/wCSQoWz5KDR7IPS4AhIPFUg
	 JgiQQvA1b8CiVqAyxh8NZ0TYfRx1T02ILBxdIGoFH9S33pgmLpNQ0j1faDjM5HR23d
	 b+jozQS5I9SdbsvOiIWI5BMYbkCUQ6Er41Er0LbrWA5a79fSU4XAyjKEmStIle/nBl
	 mwqwsjPMg1trzzEMV40tyGfn7c3FkFhFoqXOm+LgN0xDhI/yGZyGtYfBOu6wd+JoD2
	 v1cpUVQJvKgMw==
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
Subject: [PATCH v4 21/25] mm/vma: convert as much as we can in mm/vma.c to vma_flags_t
Date: Fri, 20 Mar 2026 19:38:38 +0000
Message-ID: <5fdeaf8af9a12c2a5d68497495f52fa627d05a5b.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 373FC14000F
X-Stat-Signature: xmint31ifgpmyoz1fnfy1x3xannum68o
X-HE-Tag: 1774035575-722056
X-HE-Meta: U2FsdGVkX1+pZ0ubu6hE6lrKabVK7BFIyvRCdoLCf7yzsi4B/ASV2zCisxdGoY72ZtCYDq/SJlJlmtqqtYlReFSDdwQrWbwfBBNuyLU1zsQbmeYgkulaulS48jwjzqw1BrnfFO2nlvfx9Hsx88h8wXo2lTsGhe2qbUL9+gH5wYLtKpTbv0CROrJtZZFtt6Ohzd2JHEUUN50LtWH0UTzrm80wIU/ZJCc0nw1rMYmKWhtHbQZ7yqZveEKLl8jIdCQdUg2Ok52MX6NbdL8vCI9hPbtgXwzejhvUs+ouh1QnT9PiJUipSUCZj1n3OrzlfzAv1IPf6UdI07yKZAZrulG8+oBArCEKzrJ0Qj9kN1jzzxv9Q5rXCN10aRU5YoAV9loA/rpHGt/qcKMDpl26u4VeQ3c8vJKiyn6m1v3hOxx3c6sWNCoXDEyIQ7n5a83rXeMKIkoZdzglrLtx2ynvifg7bLoaOzpahKADyoNuQdoQcvOPeXLbJHe2vwo6wrEslvF1x15Qo9Yccj4gzOPnXNbh0TplaB2qF2VDPlCv2//tcbZJOTWdQlg5vSX1PW9PurIUYAIu05eCfZVx0baog0ELCMJskpBiUiVgYh+mtwTWe/mdSUDIGpT87AJANNloOHQXFpRqddyRdleMf/sv7G/Wrihey8lpTAwiEgIaZ9wzFeudU/IC/qBeoCqYzLRbsZHGuRP7HgessWHNe3BnyN/NMn85OEnBFUgx+4gnSy5u7BeoYvmFuGltnKZwZlMRR7PsDgc2saX1G+nP+3NhSbZyG1y3WPZ9yG/7UZa5HsQ3bpNQNvFNS96yy/7UARFRXE0mom7DRhQN8ocwSmoLpCfkQRejxzjuE/+vftfO2m3PWPvcCH9tePCXSMavSxhn2MAuDI8XNzWN9FTRBTJPozQp9OlAbuYaEkRMLzdbX1BS0IOift1Ldw+YzS0pMNg+SNl/8PEsh/PnziIossBoLtD
 tpPRKWW+
 3sj/EU/6tO/f3T2jpPrcWp3InUahKvX8CbFU6tNzDoi13egNRZOxoB8COb1tGhOMi1nIusGER41lvrwO5HHdtpuOSC2DvAeTJPSLuLPNH9w+rwNRDG718HSmb8m7rFpn/BT8JNvOcLYS8WlMD/s9XKNffMze3eFcspAwXQh2CjvZXObX7pYRup7CgysNTfzAl4gKMrXQIFd1xt7fYWWFWyCPz3gsw6cY6lUUTFkrvkIwrftN/oMMDC7e1ZAhaYAW5/CWl4e7KWDnmq9zfdabP2aE35IBC3mp5pBNYpq0nmqpsUSSn+arDlxUeaMmCDo0poJBLel3k61pMCKUsHn7N8nrdLNKbRFrAWU5v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have established a good foundation for vm_flags_t to vma_flags_t
changes, update mm/vma.c to utilise vma_flags_t wherever possible.

We are able to convert VM_STARTGAP_FLAGS entirely as this is only used in
mm/vma.c, and to account for the fact we can't use VM_NONE to make life
easier, place the definition of this within existing #ifdef's to be
cleaner.

Generally the remaining changes are mechanical.

Also update the VMA tests to reflect the changes.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm.h                |  6 ++-
 mm/vma.c                          | 89 +++++++++++++++++--------------
 tools/testing/vma/include/dup.h   |  4 ++
 tools/testing/vma/include/stubs.h |  2 +-
 4 files changed, 59 insertions(+), 42 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d3585999aa0b..86a236443364 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -463,8 +463,10 @@ enum {
 #if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_ARM64_GCS) || \
 	defined(CONFIG_RISCV_USER_CFI)
 #define VM_SHADOW_STACK	INIT_VM_FLAG(SHADOW_STACK)
+#define VMA_STARTGAP_FLAGS mk_vma_flags(VMA_GROWSDOWN_BIT, VMA_SHADOW_STACK_BIT)
 #else
 #define VM_SHADOW_STACK	VM_NONE
+#define VMA_STARTGAP_FLAGS mk_vma_flags(VMA_GROWSDOWN_BIT)
 #endif
 #if defined(CONFIG_PPC64)
 #define VM_SAO		INIT_VM_FLAG(SAO)
@@ -539,8 +541,6 @@ enum {
 /* Temporary until VMA flags conversion complete. */
 #define VM_STACK_FLAGS vma_flags_to_legacy(VMA_STACK_FLAGS)
 
-#define VM_STARTGAP_FLAGS (VM_GROWSDOWN | VM_SHADOW_STACK)
-
 #ifdef CONFIG_MSEAL_SYSTEM_MAPPINGS
 #define VM_SEALED_SYSMAP	VM_SEALED
 #else
@@ -584,6 +584,8 @@ enum {
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+#define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
+
 /* These flags can be updated atomically via VMA/mmap read lock. */
 #define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
 
diff --git a/mm/vma.c b/mm/vma.c
index 9362860389ae..9d194f8e7acb 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -185,7 +185,7 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
 }
 
 /*
- * Return true if we can merge this (vm_flags,anon_vma,file,vm_pgoff)
+ * Return true if we can merge this (vma_flags,anon_vma,file,vm_pgoff)
  * in front of (at a lower virtual address and file offset than) the vma.
  *
  * We cannot merge two vmas if they have differently assigned (non-NULL)
@@ -211,7 +211,7 @@ static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 }
 
 /*
- * Return true if we can merge this (vm_flags,anon_vma,file,vm_pgoff)
+ * Return true if we can merge this (vma_flags,anon_vma,file,vm_pgoff)
  * beyond (at a higher virtual address and file offset than) the vma.
  *
  * We cannot merge two vmas if they have differently assigned (non-NULL)
@@ -850,7 +850,8 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	 * furthermost left or right side of the VMA, then we have no chance of
 	 * merging and should abort.
 	 */
-	if (vmg->vm_flags & VM_SPECIAL || (!left_side && !right_side))
+	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
+	    (!left_side && !right_side))
 		return NULL;
 
 	if (left_side)
@@ -1072,7 +1073,8 @@ struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg)
 	vmg->state = VMA_MERGE_NOMERGE;
 
 	/* Special VMAs are unmergeable, also if no prev/next. */
-	if ((vmg->vm_flags & VM_SPECIAL) || (!prev && !next))
+	if (vma_flags_test_any_mask(&vmg->vma_flags, VMA_SPECIAL_FLAGS) ||
+	    (!prev && !next))
 		return NULL;
 
 	can_merge_left = can_vma_merge_left(vmg);
@@ -1459,17 +1461,17 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		nrpages = vma_pages(next);
 
 		vms->nr_pages += nrpages;
-		if (next->vm_flags & VM_LOCKED)
+		if (vma_test(next, VMA_LOCKED_BIT))
 			vms->locked_vm += nrpages;
 
-		if (next->vm_flags & VM_ACCOUNT)
+		if (vma_test(next, VMA_ACCOUNT_BIT))
 			vms->nr_accounted += nrpages;
 
 		if (is_exec_mapping(next->vm_flags))
 			vms->exec_vm += nrpages;
 		else if (is_stack_mapping(next->vm_flags))
 			vms->stack_vm += nrpages;
-		else if (is_data_mapping(next->vm_flags))
+		else if (is_data_mapping_vma_flags(&next->flags))
 			vms->data_vm += nrpages;
 
 		if (vms->uf) {
@@ -2065,14 +2067,13 @@ static bool vm_ops_needs_writenotify(const struct vm_operations_struct *vm_ops)
 
 static bool vma_is_shared_writable(struct vm_area_struct *vma)
 {
-	return (vma->vm_flags & (VM_WRITE | VM_SHARED)) ==
-		(VM_WRITE | VM_SHARED);
+	return vma_test_all(vma, VMA_WRITE_BIT, VMA_SHARED_BIT);
 }
 
 static bool vma_fs_can_writeback(struct vm_area_struct *vma)
 {
 	/* No managed pages to writeback. */
-	if (vma->vm_flags & VM_PFNMAP)
+	if (vma_test(vma, VMA_PFNMAP_BIT))
 		return false;
 
 	return vma->vm_file && vma->vm_file->f_mapping &&
@@ -2338,8 +2339,11 @@ void mm_drop_all_locks(struct mm_struct *mm)
  * We account for memory if it's a private writeable mapping,
  * not hugepages and VM_NORESERVE wasn't set.
  */
-static bool accountable_mapping(struct file *file, vm_flags_t vm_flags)
+static bool accountable_mapping(struct mmap_state *map)
 {
+	const struct file *file = map->file;
+	vma_flags_t mask;
+
 	/*
 	 * hugetlb has its own accounting separate from the core VM
 	 * VM_HUGETLB may not be set yet so we cannot check for that flag.
@@ -2347,7 +2351,9 @@ static bool accountable_mapping(struct file *file, vm_flags_t vm_flags)
 	if (file && is_file_hugepages(file))
 		return false;
 
-	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) == VM_WRITE;
+	mask = vma_flags_and(&map->vma_flags, VMA_NORESERVE_BIT, VMA_SHARED_BIT,
+			     VMA_WRITE_BIT);
+	return vma_flags_same(&mask, VMA_WRITE_BIT);
 }
 
 /*
@@ -2450,7 +2456,7 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 		return -ENOMEM;
 
 	/* Private writable mapping: check memory availability. */
-	if (accountable_mapping(map->file, map->vm_flags)) {
+	if (accountable_mapping(map)) {
 		map->charged = map->pglen;
 		map->charged -= vms->nr_accounted;
 		if (map->charged) {
@@ -2460,7 +2466,7 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 		}
 
 		vms->nr_accounted = 0;
-		map->vm_flags |= VM_ACCOUNT;
+		vma_flags_set(&map->vma_flags, VMA_ACCOUNT_BIT);
 	}
 
 	/*
@@ -2508,12 +2514,12 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 	 * Drivers should not permit writability when previously it was
 	 * disallowed.
 	 */
-	VM_WARN_ON_ONCE(map->vm_flags != vma->vm_flags &&
-			!(map->vm_flags & VM_MAYWRITE) &&
-			(vma->vm_flags & VM_MAYWRITE));
+	VM_WARN_ON_ONCE(!vma_flags_same_pair(&map->vma_flags, &vma->flags) &&
+			!vma_flags_test(&map->vma_flags, VMA_MAYWRITE_BIT) &&
+			vma_test(vma, VMA_MAYWRITE_BIT));
 
 	map->file = vma->vm_file;
-	map->vm_flags = vma->vm_flags;
+	map->vma_flags = vma->flags;
 
 	return 0;
 }
@@ -2544,7 +2550,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 
 	vma_iter_config(vmi, map->addr, map->end);
 	vma_set_range(vma, map->addr, map->end, map->pgoff);
-	vm_flags_init(vma, map->vm_flags);
+	vma->flags = map->vma_flags;
 	vma->vm_page_prot = map->page_prot;
 
 	if (vma_iter_prealloc(vmi, vma)) {
@@ -2554,7 +2560,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 
 	if (map->file)
 		error = __mmap_new_file_vma(map, vma);
-	else if (map->vm_flags & VM_SHARED)
+	else if (vma_flags_test(&map->vma_flags, VMA_SHARED_BIT))
 		error = shmem_zero_setup(vma);
 	else
 		vma_set_anonymous(vma);
@@ -2564,7 +2570,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 
 	if (!map->check_ksm_early) {
 		update_ksm_flags(map);
-		vm_flags_init(vma, map->vm_flags);
+		vma->flags = map->vma_flags;
 	}
 
 #ifdef CONFIG_SPARC64
@@ -2604,7 +2610,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 {
 	struct mm_struct *mm = map->mm;
-	vm_flags_t vm_flags = vma->vm_flags;
 
 	perf_event_mmap(vma);
 
@@ -2612,9 +2617,9 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 	vms_complete_munmap_vmas(&map->vms, &map->mas_detach);
 
 	vm_stat_account(mm, vma->vm_flags, map->pglen);
-	if (vm_flags & VM_LOCKED) {
+	if (vma_test(vma, VMA_LOCKED_BIT)) {
 		if (!vma_supports_mlock(vma))
-			vm_flags_clear(vma, VM_LOCKED_MASK);
+			vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
 		else
 			mm->locked_vm += map->pglen;
 	}
@@ -2630,7 +2635,7 @@ static void __mmap_complete(struct mmap_state *map, struct vm_area_struct *vma)
 	 * a completely new data area).
 	 */
 	if (pgtable_supports_soft_dirty())
-		vm_flags_set(vma, VM_SOFTDIRTY);
+		vma_set_flags(vma, VMA_SOFTDIRTY_BIT);
 
 	vma_set_page_prot(vma);
 }
@@ -2993,7 +2998,8 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 	gap = vma_iter_addr(&vmi) + info->start_gap;
 	gap += (info->align_offset - gap) & info->align_mask;
 	tmp = vma_next(&vmi);
-	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
+	/* Avoid prev check if possible */
+	if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
 		if (vm_start_gap(tmp) < gap + length - 1) {
 			low_limit = tmp->vm_end;
 			vma_iter_reset(&vmi);
@@ -3045,7 +3051,8 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	gap -= (gap - info->align_offset) & info->align_mask;
 	gap_end = vma_iter_end(&vmi);
 	tmp = vma_next(&vmi);
-	if (tmp && (tmp->vm_flags & VM_STARTGAP_FLAGS)) { /* Avoid prev check if possible */
+	 /* Avoid prev check if possible */
+	if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
 		if (vm_start_gap(tmp) < gap_end) {
 			high_limit = vm_start_gap(tmp);
 			vma_iter_reset(&vmi);
@@ -3083,12 +3090,16 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	/* mlock limit tests */
-	if (!mlock_future_ok(mm, vma->vm_flags & VM_LOCKED, grow << PAGE_SHIFT))
+	if (!mlock_future_ok(mm, vma_test(vma, VMA_LOCKED_BIT),
+			     grow << PAGE_SHIFT))
 		return -ENOMEM;
 
 	/* Check to ensure the stack will not grow into a hugetlb-only region */
-	new_start = (vma->vm_flags & VM_GROWSUP) ? vma->vm_start :
-			vma->vm_end - size;
+	new_start = vma->vm_end - size;
+#ifdef CONFIG_STACK_GROWSUP
+	if (vma_test(vma, VMA_GROWSUP_BIT))
+		new_start = vma->vm_start;
+#endif
 	if (is_hugepage_only_range(vma->vm_mm, new_start, size))
 		return -EFAULT;
 
@@ -3102,7 +3113,7 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	return 0;
 }
 
-#if defined(CONFIG_STACK_GROWSUP)
+#ifdef CONFIG_STACK_GROWSUP
 /*
  * PA-RISC uses this for its stack.
  * vma is the last one with address > vma->vm_end.  Have to extend vma.
@@ -3115,7 +3126,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	int error = 0;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
-	if (!(vma->vm_flags & VM_GROWSUP))
+	if (!vma_test(vma, VMA_GROWSUP_BIT))
 		return -EFAULT;
 
 	mmap_assert_write_locked(mm);
@@ -3135,7 +3146,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 
 	next = find_vma_intersection(mm, vma->vm_end, gap_addr);
 	if (next && vma_is_accessible(next)) {
-		if (!(next->vm_flags & VM_GROWSUP))
+		if (!vma_test(next, VMA_GROWSUP_BIT))
 			return -ENOMEM;
 		/* Check that both stack segments have the same anon_vma? */
 	}
@@ -3169,7 +3180,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
-				if (vma->vm_flags & VM_LOCKED)
+				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
@@ -3200,7 +3211,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 	int error = 0;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
 
-	if (!(vma->vm_flags & VM_GROWSDOWN))
+	if (!vma_test(vma, VMA_GROWSDOWN_BIT))
 		return -EFAULT;
 
 	mmap_assert_write_locked(mm);
@@ -3213,7 +3224,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 	prev = vma_prev(&vmi);
 	/* Check that both stack segments have the same anon_vma? */
 	if (prev) {
-		if (!(prev->vm_flags & VM_GROWSDOWN) &&
+		if (!vma_test(prev, VMA_GROWSDOWN_BIT) &&
 		    vma_is_accessible(prev) &&
 		    (address - prev->vm_end < stack_guard_gap))
 			return -ENOMEM;
@@ -3248,7 +3259,7 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 		if (grow <= vma->vm_pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
-				if (vma->vm_flags & VM_LOCKED)
+				if (vma_test(vma, VMA_LOCKED_BIT))
 					mm->locked_vm += grow;
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
@@ -3297,7 +3308,7 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 	if (find_vma_intersection(mm, vma->vm_start, vma->vm_end))
 		return -ENOMEM;
 
-	if ((vma->vm_flags & VM_ACCOUNT) &&
+	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
 	     security_vm_enough_memory_mm(mm, charged))
 		return -ENOMEM;
 
@@ -3319,7 +3330,7 @@ int insert_vm_struct(struct mm_struct *mm, struct vm_area_struct *vma)
 	}
 
 	if (vma_link(mm, vma)) {
-		if (vma->vm_flags & VM_ACCOUNT)
+		if (vma_test(vma, VMA_ACCOUNT_BIT))
 			vm_unacct_memory(charged);
 		return -ENOMEM;
 	}
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 93ea600d0895..58a621ec389f 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -267,8 +267,10 @@ enum {
 #endif /* CONFIG_ARCH_HAS_PKEYS */
 #if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_ARM64_GCS)
 #define VM_SHADOW_STACK	INIT_VM_FLAG(SHADOW_STACK)
+#define VMA_STARTGAP_FLAGS mk_vma_flags(VMA_GROWSDOWN_BIT, VMA_SHADOW_STACK_BIT)
 #else
 #define VM_SHADOW_STACK	VM_NONE
+#define VMA_STARTGAP_FLAGS mk_vma_flags(VMA_GROWSDOWN_BIT)
 #endif
 #if defined(CONFIG_PPC64)
 #define VM_SAO		INIT_VM_FLAG(SAO)
@@ -366,6 +368,8 @@ enum {
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+#define VMA_LOCKED_MASK	mk_vma_flags(VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT)
+
 #define RLIMIT_STACK		3	/* max stack size */
 #define RLIMIT_MEMLOCK		8	/* max locked-in-memory address space */
 
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index b5dced3b0bd4..5afb0afe2d48 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -229,7 +229,7 @@ static inline bool signal_pending(void *p)
 	return false;
 }
 
-static inline bool is_file_hugepages(struct file *file)
+static inline bool is_file_hugepages(const struct file *file)
 {
 	return false;
 }
-- 
2.53.0



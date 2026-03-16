Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 083E3F506D0
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 13:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61A536B0270; Mon, 16 Mar 2026 09:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C49A6B0272; Mon, 16 Mar 2026 09:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C1E6B0273; Mon, 16 Mar 2026 09:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7416B0270
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:09:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 068BC1C1C2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:23 +0000 (UTC)
X-FDA: 84551957406.28.9476D53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4C2E51A0018
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 13:09:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xy/c/IpZ";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773666561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LcyvyxIOLVdYaAU5Bxn0i4OubCwHTKQhVNhc5NrCdg=;
	b=35GInydYHPIxoElWUZ6BNaB3dI2YvQJym0PdxqbruhQJYfmRsotB64SuAg83XQ+8is/U4o
	vAgK4kImB6E7TfUuntf0NHxqTQuQzYJboq2X1o1WOxaMkJ5ZWVALO/yKy7rSvu//BFIv8M
	PF59aqdbiom0/l0KEKt934QnGlaHDdQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773666561; a=rsa-sha256;
	cv=none;
	b=oK6Avh39EClALkcDT2IH3uJNtutbienzBLPMDK0BzYN9QBxXt7JKvs9pfIdnIOcbpgtf5k
	PKygBX1pnA9o0dCrEX51z9RHMi6mwi5sdUnJmI4Ft2OWjq3SNpfxidwkglfjhQrBvr97Nf
	PKtchhHZtHaTduNdvHu0Oxrtq/DUHr4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xy/c/IpZ";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E60F445AE;
	Mon, 16 Mar 2026 13:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE75DC2BCB2;
	Mon, 16 Mar 2026 13:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773666560;
	bh=clA2hZhQDNrIO1dM44PAOkABP99g52R3GtrWkpxAR4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xy/c/IpZIUxm55aUoykLnZ9rg1z3+wPemjW8L3j9aCEf5laGdvf2g8gr3B4uB8CY2
	 Z42GIKZ/xbhwcqdrs0zIeq90pBb9JLWxZzSJgDSOSvA24/Qps6nn8YoVEA7UpXg7mP
	 gcm1n7yFiY6JOZcj2c74H20NUG4s8BJXQ/g5cS+aNgtt/PeQIAfZ1FtYev4+0wwXim
	 z6NFaqju/tKpzFNuAmSkRw+ar4vxAScQn9A4anOoWFlXJ9ltzQBE7j5Grob3bqILOK
	 QJnL8nttaKHGg4lUYoNL1V5wdV62h2qON/owIuR3ynv8TyemD1LwuJ1CzrK504O1Jp
	 pmEcVWp1HxS8w==
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
Subject: [PATCH v2 09/23] mm: unexport vm_brk_flags() and eliminate vm_flags parameter
Date: Mon, 16 Mar 2026 13:07:58 +0000
Message-ID: <ba7d1eae0208551c05f4a2015133b926d6650484.1773665966.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773665966.git.ljs@kernel.org>
References: <cover.1773665966.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sjtj8xshnjjghiuxartoj54sk7gc54s4
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C2E51A0018
X-Rspamd-Server: rspam12
X-HE-Tag: 1773666561-726994
X-HE-Meta: U2FsdGVkX186JiRU0tvYhaGt6cAqMnZsiPDRtdQrw5gbUy1buNNBSUjEzgU18+FUoe1q8Flu/BjqvDGRDNV9eK6wh/jcmZvdRP5GvL/IwJX/aO7LDl+6WuzuaInumHypnzUlzxRPqNE+Z22MRSRB0RjIFfAT1CuqeKdy2U/gMJseDNOqnAMBAOq+pSZ6/wgoKT5PoOVrIDfYV8gKmSXvpuwMfYBUT+czff82hkVfezdSnPEAFzugc7VzGvCJRPkLVEw51thTqGO5Q6hln819FNmzVVhIvyMQj4xhgBnh5BbAXTE0BMpTSwI9dLc1G5hxHsy4jwznzt7nDG0vmqqkoR7MpB9dOu8ROqfUSLfEK+Ev/eGtlaapwn2xx9lG6YZAGXRLmfStzpcxz4J6C+nGLrdK8vVq1laJfB0MLQw/cP71uaEUkH4oUPseF2qHTjN7e4/Bacv2puRwwzWqf1x08Cb9gmNOhJoq1R4e1XkaJgk0T0R+cYw3hYF66eiA2Ti26/U0EoUVzsSS6flDDUMlmJIcbGMQiD2RhyhtbCAph2X5v6IiW6VS6TfCchhyF0LlQql+bQZiuw9ms9tzAjLfg4BTngrnJ10cLcxpcwydOWyWupFpDmvEXHJWyiG/Hj0UfGQ0eSrjDm3/Nu5rP0zSsgcV0LsmXOHztnLhXy+ddgGNGUjAxAngNbGJn3MBgZU5e2jl+LM8mRAt/8o5Wzx6IurJTddwo8KSJ0hw4w5jEZlWjH4ZDt0LI3FTraa9AtO8zK8mYcse9/fDkoN40Wf2Uo1RBwJB/PS9YTBu72wIlBz7VOxoBN4j5j4DOMg90gSFydz/R6gk+iJzHoeCHo+P1V936JTWcs0b12LLIxL4E1pRVzTdqV5aDqz+LuUXG53JRBpQBy9wR/tjAmOkgItCLdRO/lppKoEx+2hnh0S/GAZIN1MWfO2yqnlzxuQTI/AcAyB9Y2LG37NtYHqdtjB
 y/XwN24K
 LcO+qxXOTP9/ceM4ZOBP740Cwe0uAnDTlCAYLeu16jdkOcPiEUdXXAZ2FNkVdoOL0eoke+XqgntOEXPGhaVtgFidhPw+SvYZjkUYHCYxUiu4DfWOtzABMmIWWD0nkssmQUlB5v7Ih5TdrxRpBAqugCN0Rd8qYSGx6MAg0X3a7IFHYEAFmSIyDXP7sWJYxxjFuDhgUtIV2ay32/xpmhqlDy2QJAT3+xXX8PvjwWugJ1NdC01UM7uhvQvoeroZ9vADGSJfBd005ElIn7zwCPmC5rZGhT7V5s/pDFor5KNo0S91sroMeUIa/O7W6EdnKDbGdwIifwIFk8wYn6tf15IRoFpQh9vxtHQILz+Nx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function is only used by elf_load(), and that is a static function
that doesn't need an exported symbol to invoke an internal function, so
un-EXPORT_SYMBOLS() it.

Also, the vm_flags parameter is unnecessary, as we only ever set VM_EXEC,
so simply make this parameter a boolean.

While we're here, clean up the mm.h definitions for the various vm_xxx()
helpers so we actually specify parameter names and elide the redundant
extern's.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 fs/binfmt_elf.c    |  3 +--
 include/linux/mm.h | 12 ++++++------
 mm/mmap.c          |  8 ++------
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fb857faaf0d6..16a56b6b3f6c 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -453,14 +453,13 @@ static unsigned long elf_load(struct file *filep, unsigned long addr,
 		zero_end = ELF_PAGEALIGN(zero_end);
 
 		error = vm_brk_flags(zero_start, zero_end - zero_start,
-				     prot & PROT_EXEC ? VM_EXEC : 0);
+				     prot & PROT_EXEC);
 		if (error)
 			map_addr = error;
 	}
 	return map_addr;
 }
 
-
 static unsigned long total_mapping_size(const struct elf_phdr *phdr, int nr)
 {
 	elf_addr_t min_addr = -1;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0c35423177bf..42d346684678 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4005,12 +4005,12 @@ static inline void mm_populate(unsigned long addr, unsigned long len) {}
 #endif
 
 /* This takes the mm semaphore itself */
-extern int __must_check vm_brk_flags(unsigned long, unsigned long, unsigned long);
-extern int vm_munmap(unsigned long, size_t);
-extern unsigned long __must_check vm_mmap(struct file *, unsigned long,
-        unsigned long, unsigned long,
-        unsigned long, unsigned long);
-extern unsigned long __must_check vm_mmap_shadow_stack(unsigned long addr,
+int __must_check vm_brk_flags(unsigned long addr, unsigned long request, bool is_exec);
+int vm_munmap(unsigned long start, size_t len);
+unsigned long __must_check vm_mmap(struct file *file, unsigned long addr,
+		unsigned long len, unsigned long prot,
+		unsigned long flag, unsigned long offset);
+unsigned long __must_check vm_mmap_shadow_stack(unsigned long addr,
 		unsigned long len, unsigned long flags);
 
 struct vm_unmapped_area_info {
diff --git a/mm/mmap.c b/mm/mmap.c
index 79544d893411..2d2b814978bf 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1201,8 +1201,9 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
 	return ret;
 }
 
-int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
+int vm_brk_flags(unsigned long addr, unsigned long request, bool is_exec)
 {
+	const vm_flags_t vm_flags = is_exec ? VM_EXEC : 0;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
 	unsigned long len;
@@ -1217,10 +1218,6 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
 	if (!len)
 		return 0;
 
-	/* Until we need other flags, refuse anything except VM_EXEC. */
-	if ((vm_flags & (~VM_EXEC)) != 0)
-		return -EINVAL;
-
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
@@ -1246,7 +1243,6 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
 	mmap_write_unlock(mm);
 	return ret;
 }
-EXPORT_SYMBOL(vm_brk_flags);
 
 static
 unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
-- 
2.53.0



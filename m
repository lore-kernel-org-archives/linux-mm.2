Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98B1106ACE4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574326B0099; Thu, 12 Mar 2026 15:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF876B009B; Thu, 12 Mar 2026 15:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236EA6B009D; Thu, 12 Mar 2026 15:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 130036B0099
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:16:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF8898AC15
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:58 +0000 (UTC)
X-FDA: 84538368516.25.7BDC454
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 542FD1C000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:16:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n0QPCRke;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773343017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3Z0Z91WHJkKd/xutz7osZMQJaPmSBH1q7d7uQI8KbI=;
	b=WyAiaxuqFozrMZ3NxjAh6IK4lg5NvjxZm9++uNNsfrOoswvSoLlX42xHJk8v3wToYndioj
	o0jXxWtIaB3/zUduaMS6Pi/VRuEmVnZWaWFmLHq9v2Ewf8RV9ylq4YRPt1h0go9bFAovzX
	N5W5KLrwyEH6pxUfBvC1oac041/p5no=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773343017; a=rsa-sha256;
	cv=none;
	b=LKg5WBtnIjSGPSojJlcf4oFur0fDvAcXxL2Wurv7cbAjTCgAkNjan7cm6+/9zG7MuEq+W0
	VbJkCVZS0yJkC4QfojTcyLOWVky6w7vl2qw5Cu4xya3UKc8y9zWM8XhhZ36agSKn3Qtl/7
	mzSFNRnUYAsWCO8TYBlZy5JL40sJLfE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n0QPCRke;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7A6874451C;
	Thu, 12 Mar 2026 19:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2682C19425;
	Thu, 12 Mar 2026 19:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773343016;
	bh=+e1g977jTwjB+zEC2CJ+9F2tdTBXCV682f8unTTGMIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0QPCRkeZvOSpKttJbEMNGISp72NEhokKKRJJynYNTBZF0zDW4IGMN6vFnvuI0AeL
	 3EHrqxJ/4P1fH7oHlI0ZTp/YdO/rxVan/+0cHwGZOFjKvhCEuJOKVfWPsytnz1UYcQ
	 /ketSHre3DxPHmd7Zqlvad/UzaNh80MG0UQsGOE++mK2lbfcuvbsOIwyTdc1bKeZEv
	 ploIKrt7Ql3mhXhW9mNao+RPmeJnsKqDzTsd3v9UQ7FrVEOWe4NFJC1fmr6CsvmvN9
	 yrLf9PDi2Jf3ksfsXwZzcREwtaTz8b4npfCrCiDMeTxUmM2KOj5zs1ynl/P5gBf7jE
	 mEU03T7+JW3yw==
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
Subject: [PATCH 09/20] mm: unexport vm_brk_flags() and eliminate vm_flags parameter
Date: Thu, 12 Mar 2026 19:16:07 +0000
Message-ID: <d1b222f47c2e52e6bd2b5b077c27ce27913abac3.1773342102.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773342102.git.ljs@kernel.org>
References: <cover.1773342102.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9ia7nqosqipojhawityx9ini1pdhpk85
X-Rspam-User: 
X-Rspamd-Queue-Id: 542FD1C000E
X-Rspamd-Server: rspam12
X-HE-Tag: 1773343017-276405
X-HE-Meta: U2FsdGVkX1+W558Rle5esNWR0UMPVlrZ9KCzwczwKhX+lBwrqB61vE2X/IHwtF4wxUqAhxX4WP3GCA3yeUnjOjF4nS06eumpKsInJPXwaM3+s/ZowM1inrhXoVM1wYmwOrnv0CuT5S27zSnEXoMp26qPMwdIyHuFk6izlh47Aoe6BurQfetlb9s+ZmyFzz9NDh2N7cVDHQOkH0VzBfpKt1Ro7MTGgrH1Oyia68g2ws2pLRLkoCpv0hYQKcLls1vmNqdx5DoS07g/dHA3hozIHib0MJ9r9Ei79ZQTzQ+mwh7ObI+UFr/NSYUHGUlt4/FqX00SQmf/TZni3ePh00ZY6tMmrCKQvp7Vj+vkAS8VTwMb6xgCWETgyfj4iDKs6tWtrzRj1YMxwZbdh3ioZsPuz+9LpinRBoWYkds3dWomIzJ/W6pTeKj1PYYv6bsJ57aA7zWGN25rFDNTrG5XAoFe2msfGtvmZ0KkRE8BCH6jH/hShUmWvN0JF2MtcMEq8PtuOrzTG8d2oDGB2UFqVID4OozTqH49UbkzfxflCEDiTU7YFvlS51kK6tEMrF/17LFP7LtSyi6KhTykDwbjmD+hUBt6P+WUANki5gdaN0cW3KNZUuqjfs+PmF5MksDplqGxFyAB0zyFLYd+CBtBOqaeK7mektUqK1QYl9NX2gPJ2wLukeMLkjlm0DIiG6fMA+e6YCxdl2328jTcAeL1QzB+QVjQR3QQ3A9t5qKguo7j0Zf9HaYTGkS7icfN/c0R6ILooD4QfMiPEm4VastG/H0M4Kdu/araUSKFH4cjeFEp0+XyN5CPFOsvysSG1Tppf8bF9OEX0rpHwosUVfn2gsYt+ezONWCATOCc/gMIPvglRaN50UBh8Fhi5yE7v7sUfhoKROXgI0ggru3OCanODudxEngyDHK2aLnQL1V6reFHFdctH4sVIoKv7MngYU3UXxWOsm8A2eUBGIzPm5AxWkA
 KakByhYP
 YYdlz8MPRHL/qGj0yJqXSykgc80oXmh/v6IO3+xYiJ30l7GaCVhYDaUiuunP98Hq7gUcIU2IitBbWdGM=
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
index 5a287e58c1e6..2c16c744d49d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3985,12 +3985,12 @@ static inline void mm_populate(unsigned long addr, unsigned long len) {}
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
index 843160946aa5..2a0721e75988 100644
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



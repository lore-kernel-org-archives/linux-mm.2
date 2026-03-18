Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C85E7103E198
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2686D6B028E; Wed, 18 Mar 2026 11:51:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FCC6B0290; Wed, 18 Mar 2026 11:51:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108256B0291; Wed, 18 Mar 2026 11:51:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0EE36B028E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:51:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B95B11D933
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:08 +0000 (UTC)
X-FDA: 84559622616.16.6D88389
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 231AE180007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:51:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qRmRwK5E;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LcyvyxIOLVdYaAU5Bxn0i4OubCwHTKQhVNhc5NrCdg=;
	b=G0tB+zbQtjtK4HSN/K2SaI9uMCnbFWG/AfUxaFvD3EqbKwf3jjioWHXaLusGaBojnGKyZS
	Cc8gRWd/B1TNVG0+fjTWLHItgpcxOI8U62IYywLMlpiykjqSv+EdFWLL4gPvZRv0BaNvL2
	gJhoJGCx33Tl+H4YVnQX5H8OnMrPDEE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qRmRwK5E;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773849067; a=rsa-sha256;
	cv=none;
	b=oZTD3JmpJvUJ3x9l95hzWRrtb1iQssc2Dec4Zp6i0UqrCQLRuEADdGGKqDejKzT0i8z+Mh
	CmVJPMmOq9BNaToipcjD8TeAk+KpKGKimYvc6wxOpqBRNPe2YumhPYUjBmvaR2ZnMrSWH5
	+5m/hELxpX1y7pQpQ6390XbtXCP0k20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F6ED60097;
	Wed, 18 Mar 2026 15:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89945C2BC87;
	Wed, 18 Mar 2026 15:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773849066;
	bh=clA2hZhQDNrIO1dM44PAOkABP99g52R3GtrWkpxAR4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRmRwK5EHKlQwjSTRVwAErmzVWakMjusf90wdgyO+urvmE3hrp/3Pi8VanuwLCxXs
	 oezhBV1dQ/m2/dCjcbXHDYlAufAN/N0UVWQicDXNYQh2MHtRFduQPbG5spjHiU6Sxg
	 yWLXRMCxWItFAjCmENz0C20y9c3cnZN6eaj0sfOkXStiqcgcy7ojb+rggCowKX72T/
	 0XDisaTDD5BLm3pIfLOvQeLQ3rlG3HqSoKcH1/AQz8hst/N7DR65yS69DX0XgLbkuw
	 pc7/oVI+01jmzr1mpJV1sIMnbXf825eQ/+CxWisYftsLG9yIkQy6PeQ2ym1YWWLFII
	 XXVqcd1aeZ+Dg==
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
Subject: [PATCH v3 09/23] mm: unexport vm_brk_flags() and eliminate vm_flags parameter
Date: Wed, 18 Mar 2026 15:50:20 +0000
Message-ID: <297c7690f17257ba11a7b8c94fe54709a64d89fb.1773846935.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 231AE180007
X-Stat-Signature: 3bfnspgz8bxpgcjm3yr4i8qn7hdc3h5s
X-Rspam-User: 
X-HE-Tag: 1773849066-26091
X-HE-Meta: U2FsdGVkX18iL3gcEis5yuS/eCI8eAY3NDHlmaUXuj9yLS95fUrQHghYtAtWLlVOBy/mflj80liLZvf41sSgZKtLKprk2ZfzZ15KG5pO5qRMmP6KNxzDqVIBOnp6DRhOxPehKkPxTLVDCYjPQnGc65gk36cxDgd+Uy1jzfySC8HIrtA0Re7+55aYIRcmZ6cOFlZCCDmdIn6HCTn+JNqTkoukQInDaeW395ORUrM0XMmCzF+lMKJQyfE920ZAWrdWFAqLT0LoYrhnAN5AIi+CROtPjeZzNdzTWoS174QZ0+q7f1X4JunNAuSP45SSJo15yFkgkz6I/qOH6B9XxfKdTqiRPgK2tHip64Bt5sAzj+iopl7OElo3hW2BIezDyCjPSbajkxL16s9xhvU+O/dF9sdgQbQ72jSvVekk68Z/BMAjcDddg013ZvDeSHgkQn1n1/48udsZpxnQWcE/0K9aeI4gVoLsMLbkYvoLSvlpKbiMoW2XHKEOrqEpGA5ZXP5Ue1Nlg8tVfqA2fwybyFb7gXIfgNcWyJDu2dYYaLE+8Zb0xwrxH0UTON0fi7ShHwf+b1Zw7g5lG9JTrG/yHo7d0h/1xlr6AvRJu1kZfJXyRkMZ0RxPUhSpgpi5epo0DFYj9WVg6/+TPRPf18lhgnyolBAeKyRlDg7Rlboap51wlxfa1/u5rehffIaCpdyNnUX1HJYWKYKwOl9pKpn01Q92Nrdkhrte/jbE5Ms3yWc6us4YVOkc4UmI6DW/hRgLaDIfR2cbY3PZeyZfwRRre7QrPejsoz5xAm7/QeFH+8JQwHO3IXbDu2g3rbtdvuCYNOpHkh6viWl/oaJ6/x+b0K9FAtpqjaogDyrkbHvI2KXSWUVJyHgrqHvuHM8VihNGJAiyZOHdoead5FgsPh0EijY/cQGohMGZIIpMkFXMjiL+0NUq/yQsOFMIUDMinR45N4cZ1NqKeH/qhqL4d/mdZpv
 D665exj2
 SE32JS8MvNxst8OqrP1O+rGI2u7sNAvHUZOcGDU3yihK9I8CCQqFhm03X6tdF7+3Ew+ZSITSvR7dWAQ/6SdZFyMOF1YG0C2UojT1CvWIyNixNi9TsYPUVbUnnkbIzT9+gmrvFBDOYutXucLEone0XPfm+leP0uKSt4UOlZDgp3kBCK55Kav27qDFZGSLAcqqCWEXQS3TGt/cbaXy1CgPi6hdwKWTDy8R8gxzwU6PpnR0FJ9olu9uhD05n3H42806bDZzR0P7VcMBfjIgRTnIuC4YBhYydF16uGVobTYk3mzqC4+kDBUEDSLk2969nUF9/mMtyoxS3bNHWXPV5jajVNr7C/8K/TsTsa/JQ
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



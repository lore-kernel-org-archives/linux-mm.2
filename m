Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451211099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94CD46B016F; Fri, 20 Mar 2026 15:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929D16B0172; Fri, 20 Mar 2026 15:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC866B0171; Fri, 20 Mar 2026 15:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6666D6B016B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4388AC19CE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:10 +0000 (UTC)
X-FDA: 84567454860.13.3A12283
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7D249C000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uhu53cZC;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Bh1w+z0JWOqUddQi7wko3Cw3Y50TUDCTLtrQm/GK+I=;
	b=nzLEcMcBLfZO7Rk++UyheMe1j8Mvh+/vKXz6oTTVGsi5JdG59gVYqvFwNG1qdpdJXrqtND
	IaH9XnEmrVJSsCprJ32nFjJiLDHnnztn2Xa2GtgGQCjzYPrCEmR+xA8URlWah1f9mRqy6j
	p1TE44znh5nhiYUS63JgCoHiEHIQ3zo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035548; a=rsa-sha256;
	cv=none;
	b=Ey+buRUoGD9XT7gPxUi7jFxuVEi8KwuUwZGs9PI1W1sCyRyg28xsar+C6cGZiHFuVLEIVA
	PgxXwc8g0I7bTJaD80DPoTCeb2QcMwEQwS+IK7YZ4YABeyKgXmp4pWKOltXoSYZ7HGQXtx
	WkpJzidlNH8ipfKPHdTaU9VWCWILWJ8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Uhu53cZC;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2A0840A5D;
	Fri, 20 Mar 2026 19:39:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0929DC2BCB0;
	Fri, 20 Mar 2026 19:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035547;
	bh=86x1e2KlqpteSaaM7lejP1Bl+dRpcwhLokvktrA9jqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uhu53cZC/i9jnIgNtZl9DHyCJPNP7M2+7D0KPd9H0fOR7q4bemzt8shuQyEUWwhgw
	 1ceG+HynjH/FwHZBb0jwxNV8M1Q8u6YMdqWyVhbOh8oWKDv5uQ4TGn6HzZegbrrAqH
	 4TZ1iaZ6kqLTGCKwcLPz/ya6pD3aVyEPJTuAeq1ihituF+qqu/HxmZnuwCKmTMcuKw
	 7SqEgTRKI6Q9dEnoOjZp4wk31l0zJ8YG/iHBXji2ff9HJpgBY20Q6q9JQccuLxQsOQ
	 hGqeIqAOlGLcNYOfBJ7exBVzVbmnejqpV+UXJ5zxhlED6Nvu0YgE/UA8CGIIK7x8cD
	 +7qbaWZY4pG/g==
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
Subject: [PATCH v4 09/25] mm: unexport vm_brk_flags() and eliminate vm_flags parameter
Date: Fri, 20 Mar 2026 19:38:26 +0000
Message-ID: <7bada48ddf3f9dbd3e6c4fc50ec2f4de97706f52.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xoj6adamfisqhhgegaeuq8k4agb4ae56
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D249C000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1774035548-491046
X-HE-Meta: U2FsdGVkX1+EvQyiCNeW/8L12+lhHmSwCU1gzUm43Mwq6Myan+bY2IEBXbpTWtxAhSwEXSHf7l4i6r6CVcA1/AyeP10diOCx2ZRUS1db/iJ9BXEp2Bg/6XHeudXXGhfcGUxH1NCNVuvWuIrpYxmT+yRnySn0Z4ucJ6uMx8OijF5BRn0vvNwAUV6prbSWSA74TKSDrRjw5zeBV66b8EAP06u4XSP+SNQ4fVUUInCxYdFbMMfI1KvDb1GbWJbsQ8e/20rVAuetFasJZmfPWZDibZ+BXQmOzMwHc3O0XVW4PzhIy63G5n6DzThRQ5EL2i6vsWmSvL/X8d9UD8BdGV7rzFw1iEZpphSbcUg/Igb1Z3Yf36jXrkKmhyhCs2rku7nhSHUIoQjaCDdksWXIeb2ntDII3QjVkfYhzjHwhNcA1V2d8/i/vaeDfcWkZENG7kQwBHQ7hXxWsjliVRnXQ4/ZLalj6z+0GaYcMzOvYRlB2eLRGL/yZutA3jIB+oOzRXS/xt6y0MkzoaAx702wHK2M82141HJ3x8Z95vjkWp2ap+xcSt7n015A10x4Lufq7D/C481HXC+PZyib5qGbXM3lSqR9htI+9e/rJIWH0Z9czSQnVdyePsvRRH4so9bSCFH4yxMvIS16V/+0+463PO81f1msbAsCaVvMnRmhIP6OMZehEOBmN3oSvmTYInyM5KlLgLtRGp44HXPzFkvGB3E7m/KpCjAXFnf79RzvvgoUBFs4+Sre6Y9Tywi2zLeCrk0sA6EWHC3umi0JI67SWn18VSl9NCNvzsgjqrit2BXKBZ7X4sXYZon68cIQzj/TPs5YubJ4Gi7aVvrVUvx5jWkgbahbl/b0QcCkyo50Jq3/6dXTX9798qg42rG0V5plbmvwMWHFjrl6/Q1GklZr8BHA0qK1Ad6HClkVqcsffbhXOMmq1KqAR1FFPK6k0tZk53KrfMJV1lZe5SU8W9b7L3L
 Q5BjZjkc
 /GdthlZMs8luBAHD931mJXreN+aX3r0+Kywqc0xvJggqWUL7M6B6AHXkwrs0annHGx85smdOkfC4s8YVYY63nBICJ+kaxdUdcP7JyUW0g6xVMxmLtTccibD1bQYyRrYkpoyf8CtkyOvKTj6fizDmf79DYCzfzvPQgxdERI2RxmLyTsx+wmfX7DjZFakrtDSGnaU78Dlo8JJo3CtGg96N5qkEvJ2YhQDZ8Vx4MkvsNgTISVM5Cc1lV2vv49CfUJnKvw+BN9CBdSNQyeacFiA2rYKrmr4IhUhOl1wUrpHi4T4JWwyWbiVy6Hno7hOy5klsw4sCy2gUNHHmLzOCrC29CKc3NtkcVqZHvvyRA
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

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
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



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F22FD3777
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40BF6B00C0; Wed, 25 Feb 2026 11:34:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8C696B00C2; Wed, 25 Feb 2026 11:34:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7396B00C0; Wed, 25 Feb 2026 11:34:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1786B00C0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:34:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 274D61A0674
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:42 +0000 (UTC)
X-FDA: 84483527604.26.576D702
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4043414000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:34:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=whFKrp33;
	spf=pass (imf26.hostedemail.com: domain of 3niSfaQgKCLcgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3niSfaQgKCLcgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPQ+misXJTr57F+MdFkoDJ+8mZ8TPh1m44bWqZ7xGK0=;
	b=o8SqffMdpMGGvF1+1A6PIQDOVq2kGpA9oqRC6LdmQuEln8DUvT86dTlguBkmz41yOiBrpj
	rwT7aNgn/K64BllcnBVxkj9ozumqDXH1MTj57UsNw9vUfeS17b2Gu1oHHXoN7etj8EKzVg
	yiojdBfxz/jzl4MeOpzRDOKxy9db5nc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=whFKrp33;
	spf=pass (imf26.hostedemail.com: domain of 3niSfaQgKCLcgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3niSfaQgKCLcgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037280; a=rsa-sha256;
	cv=none;
	b=IhFXGpmdpbjfJIprFAvzHTDHvbJdBnaW9pFRQMibKdjKq4I95o7rbhWULBcqhFhLW3P7ah
	4O7rK1yq2ru+T/fYnM+wyXVGP3aBYxSFrpf5gkUeHhQMQHGO1zMt9XO30deO6nmRGQpteG
	sqQY92VXzwcodhCc4mBBaaSgiKokc6U=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43768240a29so1011181f8f.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772037279; x=1772642079; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YPQ+misXJTr57F+MdFkoDJ+8mZ8TPh1m44bWqZ7xGK0=;
        b=whFKrp33YafOIF2HKGneA/IWdlk4xjLlVib83Q0LvZ1MCQA85075IqpSVcRDVxZQhc
         7C3g93UTcALXZ+LdubpT0YJMh6JLuOVl5AaCMqwuLiT5kyUaK2oV2503MXCz8wZtbDuk
         KGQntfomp6W/Oa7o7SaKJbNrZqz3WkplM/Y/nlzXNnhzD/406CYAxgi6QEGUt+kYM1Mt
         sDAjzDuHFuwn3QJAOzEEDt5g41liVSjDyQVYlh1jplsXPZBMQokF716kziMp85xgpRWB
         meh8Nm89WWYSc0mffyu14z+9IbBT/9Ho1B3X6LdFy0+vetlxrXpqNkemREnY5ZCd6AUX
         gFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772037279; x=1772642079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YPQ+misXJTr57F+MdFkoDJ+8mZ8TPh1m44bWqZ7xGK0=;
        b=JXlxF8VHsESjHqIOYGMH5zQ5LI6Ib7cIXnpOUlYs6fnVWTEC7F74AypB7LEdEekwIp
         0qr7tzWBUG3jqzOgyV4BqAa7XPqmDQEqVmiAnBeJyBRGe5n2IKdnD2WsSGb5t15HRYs4
         Nj8B7/rUvQQEtjpe7/kfI+sSXfLTtuDusrjMGs9Raa+IccrPTwcdN6K4hpuEUrXe4ldg
         FCOvs8docg61YJu47zyQJisOpQSs/JvFOBnIuR4rIgRt3ALTKhbjhJePaIaqHvZpEMIg
         JJPhthmCmyF1nEUXHdr06EmQNUBScaI+N3AV3p/Es5tdyQGuLfWIiMnXeZSwTrEZ5Tnz
         XjJA==
X-Gm-Message-State: AOJu0YxB7WQdpmRvWHmGO72vmzPKn2ENkKRdZeegzofHGbYt/7H6Kltk
	Mk1DIOUvNCdXdSovuChGS5K0UdlevVnrpzIJmSr6grkYtVL6+DvP0OohwXBcj/6gs483mxCHPV8
	AjC+8OV9cR7lItA==
X-Received: from wrsg1.prod.google.com ([2002:a5d:46c1:0:b0:436:332e:b900])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1a89:b0:437:9ab5:905e with SMTP id ffacd0b85a97d-4398d83e509mr8718335f8f.11.1772037278494;
 Wed, 25 Feb 2026 08:34:38 -0800 (PST)
Date: Wed, 25 Feb 2026 16:34:27 +0000
In-Reply-To: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
Mime-Version: 1.0
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260225-page_alloc-unmapped-v1-2-e8808a03cd66@google.com>
Subject: [PATCH RFC 02/19] x86/mm: Generalize LDT remap into "mm-local region"
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4043414000E
X-Stat-Signature: 7r8hdc9azzogpnp9eeqr4c7muwz1nt53
X-HE-Tag: 1772037280-760314
X-HE-Meta: U2FsdGVkX19awwcyJkAchzmkCtfefwj0nYCQNyceco5ev9QJq9JIhedJZCmst7vdWSPRDi+G1Sh/Fhf/vC3eMBc4g7kEAq9KUY7h5aE4sOKFwdpdLNwE1n0lSe25GWw6h8Tte/wN1CCcuxlmvm1jn3CbnEVb4b3vi+NzTu2GGEsO+8BpSQm/95jU4btcTXe7v4ocGXMpQp5bl4GoDOJJp3jMwNxqkvpfiQMaH7E+dbjYwtnxqGYP7Oe7OZtcLJdVAGKhZC0PQvS6FSQrDeEvN/yw8Q3bZ1gEvthH8RGJB6ApbB6zuA7B7SYnt9QX8VqUQDPVwJ+qQOQB1vLi1e9N6nnohHIbOuBdwxQUkOtWgyH+VYwx3MM/h8LC+TuyW7MZNtwlXHlOJEnRKwIlYo1fwvdY1AkxrrbD4VCP4e5CzbDyWitPZE7gwRlyCOfkYuVVfyrjOwTouMROKzKKTYcSW5IAAYdGtXHSqL80wVa7UApo9rCw1TNprzrBN2hxsYsa/lSU9SMzKIzJeliELo2zOPRnjbH1omdBKFyglk9nrfzJbsJrwNlRiljyQPxOtK6ODk/PG9biF/X8VHWDi5oP8udxZOmCWwmGaEvGWfKZDsJD4C0dCq2WPfJCMqgFDpZe0CGFj216eoyIwZKY+lYhWlAT0DrQbY31b2rD21EocFdaxW+B7ea0Q3I/2ZsA0AAmsO0rTM7ZQQ6MZNa3XDyKuvqx3gFWpyW4Q9lZuBhJsIov6Dg0r6TehwkVbuUt36qCbDEGdio7Dtd5n0VmSPV6jT1ucxUF8khvZwzGrMEsbeYcw3aNM41SXnMvoHTfvpGtzR6woRnBt7tNgNCJJvEyp5UhlHQp3Z0dtI8tCmjEgx7pyX3e4jc4vYRAoSHKd9XAZFegTf877WPTwpRvJMiUGN2o4P2AHrUflO/mrvE4F3ca7MNtd36HhWXSWxEcMdnQG1eb/fi3Xknb25ZYmDd
 Fkg7L6uC
 CTp1ZucgJAi53+Hwql4LOFMdq1G/HuPPsLqxxxSAjDxe79TXxo1Si9ommt4qEyTxJ9IUlW0yB8JJD3xJ9wu38j3exzcGwMT64zrFb5xpwwi//Mj+b604jwSLkDInQcxjJn2Zfwo56zQ7koGBHc/EPKA0TbytWBoUatthqKqCyhCISwW3qqUCOohloyNiSjDnm5FQml1LHdHoNqBc5ICA4hWAJpHvwnMBO9ScdzbxFtsQenbl7DNokqc1/+Y1qDY/F/evJawScYltJhyGXECcs/Gz794vOoALdZRqD5MApvqW9kh0pExr9oC9qwcEB5Ykh5lgq+1NamaY2orMSJk1QerFZGKXmLRpjoHDBmONjCDG1KL6VWD13CuA05eTYFIuojCdnUX6Sor7MMHHx3JRE093QJ+Sz1Qdk+RJLnUALMqcuP66oK81O9IyKatc2ApIW8uBXeyT4TdMRwS/tenISRFddOO3beYiTJQ5jpsg/kfzo71cnyKcXUpF0tHmmpOiynjo03sVL5hvRiARDq9fELdEHYGjqfPG23ii8M62rG9TeS8rno9g2f5yQwLfWXZ5qGp/GxA1bspH9cItTzlr/aW8r0FSFf8j0dhVYtvTChnp0QE4hIBBMHP85JVYqJwCXWifEnWnJSDCE1Zxqrq+NsNTygm/uZSoMp1CRyxpJtsJPjLnWSxhLqP+uTWeTy2dr2MLrJjcYxoAcC89a3o55cDrWDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Various security features benefit from having process-local address
mappings. Examples include no-direct-map guest_memfd [2] significant
optimizations for ASI [1].

As pointed out by Andy in [0], x86 already has a PGD entry that is local
to the mm, which is used for the LDT.

So, simply redefine that entry's region as "the mm-local region" and
then redefine the LDT region as a sub-region of that.

With the currently-envisaged usecases, there will be many situations
where almost no processes have any need for the mm-local region.
Therefore, avoid its overhead (memory cost of pagetables, alloc/free
overhead during fork/exit) for processes that don't use it by requiring
its users to explicitly initialize it via the new mm_local_* API.

Freeing the pagetables in this region is left to the mm_local_* API
implementation and deferred until process exit. This means that the LDT
remap code can be simplified:

1. map_ldt_struct_to_user() is now a NOP on 64-bit, since the mm-local
   region is defined as already being mapped into the user pagetables.

3. free_ldt_pgtables() is no long required at all, it's handled in the
   core mm teardown logic in both PAE and KPTI cases now.

2. The sanity-check logic is unified: in both cases just walk to the PMD
   and use presence of that as the proxy for whether an LDT mapping is
   present. This requires an extra null-check since the page walk will
   generally terminate early in the KPTI case.

TODO: Agh, this is broken under PAE, looks like I had totally forgotten
that KPTI supports 32-bit? Even though there is 32-bit KPTI code
modified here. Oops.

[0] https://lore.kernel.org/linux-mm/CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com/
[1] https://linuxasi.dev/
[2] https://lore.kernel.org/all/20250924151101.2225820-1-patrick.roy@campus.lmu.de
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 Documentation/arch/x86/x86_64/mm.rst    |   4 +-
 arch/x86/Kconfig                        |   2 +
 arch/x86/include/asm/mmu_context.h      |  71 ++++++++++++++++-
 arch/x86/include/asm/pgtable_64_types.h |  13 ++-
 arch/x86/kernel/ldt.c                   | 137 +++++++++++---------------------
 arch/x86/mm/pgtable.c                   |   3 +
 include/linux/mm.h                      |  13 +++
 include/linux/mm_types.h                |   2 +
 kernel/fork.c                           |   1 +
 mm/Kconfig                              |   7 ++
 10 files changed, 155 insertions(+), 98 deletions(-)

diff --git a/Documentation/arch/x86/x86_64/mm.rst b/Documentation/arch/x86/x86_64/mm.rst
index a6cf05d51bd8c..fa2bb7bab6a42 100644
--- a/Documentation/arch/x86/x86_64/mm.rst
+++ b/Documentation/arch/x86/x86_64/mm.rst
@@ -53,7 +53,7 @@ Complete virtual memory map with 4-level page tables
   ____________________________________________________________|___________________________________________________________
                     |            |                  |         |
    ffff800000000000 | -128    TB | ffff87ffffffffff |    8 TB | ... guard hole, also reserved for hypervisor
-   ffff880000000000 | -120    TB | ffff887fffffffff |  0.5 TB | LDT remap for PTI
+   ffff880000000000 | -120    TB | ffff887fffffffff |  0.5 TB | MM-local kernel data. Includes LDT remap for PTI
    ffff888000000000 | -119.5  TB | ffffc87fffffffff |   64 TB | direct mapping of all physical memory (page_offset_base)
    ffffc88000000000 |  -55.5  TB | ffffc8ffffffffff |  0.5 TB | ... unused hole
    ffffc90000000000 |  -55    TB | ffffe8ffffffffff |   32 TB | vmalloc/ioremap space (vmalloc_base)
@@ -123,7 +123,7 @@ Complete virtual memory map with 5-level page tables
   ____________________________________________________________|___________________________________________________________
                     |            |                  |         |
    ff00000000000000 |  -64    PB | ff0fffffffffffff |    4 PB | ... guard hole, also reserved for hypervisor
-   ff10000000000000 |  -60    PB | ff10ffffffffffff | 0.25 PB | LDT remap for PTI
+   ff10000000000000 |  -60    PB | ff10ffffffffffff | 0.25 PB | MM-local kernel data. Includes LDT remap for PTI
    ff11000000000000 |  -59.75 PB | ff90ffffffffffff |   32 PB | direct mapping of all physical memory (page_offset_base)
    ff91000000000000 |  -27.75 PB | ff9fffffffffffff | 3.75 PB | ... unused hole
    ffa0000000000000 |  -24    PB | ffd1ffffffffffff | 12.5 PB | vmalloc/ioremap space (vmalloc_base)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e2df1b147184a..5bf68dcea3fee 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -133,6 +133,7 @@ config X86
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_AUTOFDO_CLANG
 	select ARCH_SUPPORTS_PROPELLER_CLANG    if X86_64
+	select ARCH_SUPPORTS_MM_LOCAL_REGION	if X86_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if X86_CX8
 	select ARCH_USE_MEMTEST
@@ -2320,6 +2321,7 @@ config CMDLINE_OVERRIDE
 config MODIFY_LDT_SYSCALL
 	bool "Enable the LDT (local descriptor table)" if EXPERT
 	default y
+	select MM_LOCAL_REGION if MITIGATION_PAGE_TABLE_ISOLATION
 	help
 	  Linux can allow user programs to install a per-process x86
 	  Local Descriptor Table (LDT) using the modify_ldt(2) system
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 1acafb1c6a932..9016fe525bb62 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -8,8 +8,10 @@
 
 #include <trace/events/tlb.h>
 
+#include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
+#include <asm/pgalloc.h>
 #include <asm/debugreg.h>
 #include <asm/gsseg.h>
 #include <asm/desc.h>
@@ -59,7 +61,6 @@ static inline void init_new_context_ldt(struct mm_struct *mm)
 }
 int ldt_dup_context(struct mm_struct *oldmm, struct mm_struct *mm);
 void destroy_context_ldt(struct mm_struct *mm);
-void ldt_arch_exit_mmap(struct mm_struct *mm);
 #else	/* CONFIG_MODIFY_LDT_SYSCALL */
 static inline void init_new_context_ldt(struct mm_struct *mm) { }
 static inline int ldt_dup_context(struct mm_struct *oldmm,
@@ -68,7 +69,6 @@ static inline int ldt_dup_context(struct mm_struct *oldmm,
 	return 0;
 }
 static inline void destroy_context_ldt(struct mm_struct *mm) { }
-static inline void ldt_arch_exit_mmap(struct mm_struct *mm) { }
 #endif
 
 #ifdef CONFIG_MODIFY_LDT_SYSCALL
@@ -226,10 +226,75 @@ static inline int arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
 	return ldt_dup_context(oldmm, mm);
 }
 
+#ifdef CONFIG_MM_LOCAL_REGION
+static inline void mm_local_region_free(struct mm_struct *mm)
+{
+	if (mm_local_region_used(mm)) {
+		struct mmu_gather tlb;
+		unsigned long start = MM_LOCAL_BASE_ADDR;
+		unsigned long end = MM_LOCAL_END_ADDR;
+
+		/*
+		 * Although free_pgd_range() is intended for freeing user
+		 * page-tables, it also works out for kernel mappings on x86.
+		 * We use tlb_gather_mmu_fullmm() to avoid confusing the
+		 * range-tracking logic in __tlb_adjust_range().
+		 */
+		tlb_gather_mmu_fullmm(&tlb, mm);
+		free_pgd_range(&tlb, start, end, start, end);
+		tlb_finish_mmu(&tlb);
+
+		mm_flags_clear(MMF_LOCAL_REGION_USED, mm);
+	}
+}
+
+/* Do initial setup of the user-local region. Call from process context. */
+static inline int mm_local_region_init(struct mm_struct *mm)
+{
+	int err;
+
+	err = preallocate_sub_pgd(mm, MM_LOCAL_BASE_ADDR);
+	if (err)
+		return err;
+
+#ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
+	/*
+	 * The mm-local region is shared with userspace. This is useful for the
+	 * LDT remap. It's assuming nothing gets mapped in here that needs to be
+	 * protected from Meltdown-type attacks from the current process.
+	 *
+	 * Note this can be called multiple times, also concurrently - it's
+	 * assuming the set_pgd() is idempotent.
+	 */
+	if (boot_cpu_has(X86_FEATURE_PTI)) {
+		pgd_t *pgd = pgd_offset(mm, LDT_BASE_ADDR);
+
+		set_pgd(kernel_to_user_pgdp(pgd), *pgd);
+	}
+#endif
+
+	mm_flags_set(MMF_LOCAL_REGION_USED, mm);
+
+	return 0;
+}
+
+static inline bool is_mm_local_addr(unsigned long addr)
+{
+	return addr >= MM_LOCAL_BASE_ADDR && addr < MM_LOCAL_END_ADDR;
+}
+#else
+static inline void mm_local_region_free(struct mm_struct *mm) { }
+
+static inline bool is_mm_local_addr(unsigned long addr)
+{
+	return false;
+}
+#endif /* CONFIG_MM_LOCAL_REGION */
+
 static inline void arch_exit_mmap(struct mm_struct *mm)
 {
 	paravirt_arch_exit_mmap(mm);
-	ldt_arch_exit_mmap(mm);
+	mm_local_region_free(mm);
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 7eb61ef6a185f..cfb51b65b5ce9 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -5,8 +5,11 @@
 #include <asm/sparsemem.h>
 
 #ifndef __ASSEMBLER__
+#include <linux/build_bug.h>
 #include <linux/types.h>
 #include <asm/kaslr.h>
+#include <asm/page_types.h>
+#include <uapi/asm/ldt.h>
 
 /*
  * These are used to make use of C type-checking..
@@ -100,9 +103,13 @@ extern unsigned int ptrs_per_p4d;
 #define GUARD_HOLE_BASE_ADDR	(GUARD_HOLE_PGD_ENTRY << PGDIR_SHIFT)
 #define GUARD_HOLE_END_ADDR	(GUARD_HOLE_BASE_ADDR + GUARD_HOLE_SIZE)
 
-#define LDT_PGD_ENTRY		-240UL
-#define LDT_BASE_ADDR		(LDT_PGD_ENTRY << PGDIR_SHIFT)
-#define LDT_END_ADDR		(LDT_BASE_ADDR + PGDIR_SIZE)
+#define MM_LOCAL_PGD_ENTRY	-240UL
+#define MM_LOCAL_BASE_ADDR	(MM_LOCAL_PGD_ENTRY << PGDIR_SHIFT)
+#define MM_LOCAL_END_ADDR	((MM_LOCAL_PGD_ENTRY + 1) << PGDIR_SHIFT)
+
+#define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
+#define LDT_REMAP_SIZE		PMD_SIZE
+#define LDT_END_ADDR		(LDT_BASE_ADDR + LDT_REMAP_SIZE)
 
 #define __VMALLOC_BASE_L4	0xffffc90000000000UL
 #define __VMALLOC_BASE_L5 	0xffa0000000000000UL
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 0f19ef355f5f1..86cf9704e4d57 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -31,6 +31,8 @@
 
 #include <xen/xen.h>
 
+/* LDTs are double-buffered, the buffers are called slots. */
+#define LDT_NUM_SLOTS		2
 /* This is a multiple of PAGE_SIZE. */
 #define LDT_SLOT_STRIDE (LDT_ENTRIES * LDT_ENTRY_SIZE)
 
@@ -186,31 +188,30 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
 
 #ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
 
-static void do_sanity_check(struct mm_struct *mm,
-			    bool had_kernel_mapping,
-			    bool had_user_mapping)
+#ifdef CONFIG_X86_PAE
+
+static void map_ldt_struct_to_user(struct mm_struct *mm)
 {
-	if (mm->context.ldt) {
-		/*
-		 * We already had an LDT.  The top-level entry should already
-		 * have been allocated and synchronized with the usermode
-		 * tables.
-		 */
-		WARN_ON(!had_kernel_mapping);
-		if (boot_cpu_has(X86_FEATURE_PTI))
-			WARN_ON(!had_user_mapping);
-	} else {
-		/*
-		 * This is the first time we're mapping an LDT for this process.
-		 * Sync the pgd to the usermode tables.
-		 */
-		WARN_ON(had_kernel_mapping);
-		if (boot_cpu_has(X86_FEATURE_PTI))
-			WARN_ON(had_user_mapping);
-	}
+	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
+	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
+	pmd_t *k_pmd, *u_pmd;
+
+	k_pmd = pgd_to_pmd_walk(k_pgd, LDT_BASE_ADDR);
+	u_pmd = pgd_to_pmd_walk(u_pgd, LDT_BASE_ADDR);
+
+	BUILD_BUG_ON(LDT_SLOT_STRIDE * LDT_NUM_SLOTS > PMD_SIZE);
+	if (boot_cpu_has(X86_FEATURE_PTI) && !mm->context.ldt)
+		set_pmd(u_pmd, *k_pmd);
 }
 
-#ifdef CONFIG_X86_PAE
+#else /* !CONFIG_X86_PAE */
+
+static void map_ldt_struct_to_user(struct mm_struct *mm)
+{
+	/* Nothing to do; the whole mm-local region is shared with userspace. */
+}
+
+#endif /* CONFIG_X86_PAE */
 
 static pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsigned long va)
 {
@@ -231,19 +232,6 @@ static pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsigned long va)
 	return pmd_offset(pud, va);
 }
 
-static void map_ldt_struct_to_user(struct mm_struct *mm)
-{
-	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
-	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
-	pmd_t *k_pmd, *u_pmd;
-
-	k_pmd = pgd_to_pmd_walk(k_pgd, LDT_BASE_ADDR);
-	u_pmd = pgd_to_pmd_walk(u_pgd, LDT_BASE_ADDR);
-
-	if (boot_cpu_has(X86_FEATURE_PTI) && !mm->context.ldt)
-		set_pmd(u_pmd, *k_pmd);
-}
-
 static void sanity_check_ldt_mapping(struct mm_struct *mm)
 {
 	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
@@ -253,33 +241,29 @@ static void sanity_check_ldt_mapping(struct mm_struct *mm)
 
 	k_pmd      = pgd_to_pmd_walk(k_pgd, LDT_BASE_ADDR);
 	u_pmd      = pgd_to_pmd_walk(u_pgd, LDT_BASE_ADDR);
-	had_kernel = (k_pmd->pmd != 0);
-	had_user   = (u_pmd->pmd != 0);
+	had_kernel = k_pmd && (k_pmd->pmd != 0);
+	had_user   = u_pmd && (u_pmd->pmd != 0);
 
-	do_sanity_check(mm, had_kernel, had_user);
+	if (mm->context.ldt) {
+		/*
+		 * We already had an LDT.  The top-level entry should already
+		 * have been allocated and synchronized with the usermode
+		 * tables.
+		 */
+		WARN_ON(!had_kernel);
+		if (boot_cpu_has(X86_FEATURE_PTI))
+			WARN_ON(!had_user);
+	} else {
+		/*
+		 * This is the first time we're mapping an LDT for this process.
+		 * Sync the pgd to the usermode tables.
+		 */
+		WARN_ON(had_kernel);
+		if (boot_cpu_has(X86_FEATURE_PTI))
+			WARN_ON(had_user);
+	}
 }
 
-#else /* !CONFIG_X86_PAE */
-
-static void map_ldt_struct_to_user(struct mm_struct *mm)
-{
-	pgd_t *pgd = pgd_offset(mm, LDT_BASE_ADDR);
-
-	if (boot_cpu_has(X86_FEATURE_PTI) && !mm->context.ldt)
-		set_pgd(kernel_to_user_pgdp(pgd), *pgd);
-}
-
-static void sanity_check_ldt_mapping(struct mm_struct *mm)
-{
-	pgd_t *pgd = pgd_offset(mm, LDT_BASE_ADDR);
-	bool had_kernel = (pgd->pgd != 0);
-	bool had_user   = (kernel_to_user_pgdp(pgd)->pgd != 0);
-
-	do_sanity_check(mm, had_kernel, had_user);
-}
-
-#endif /* CONFIG_X86_PAE */
-
 /*
  * If PTI is enabled, this maps the LDT into the kernelmode and
  * usermode tables for the given mm.
@@ -295,6 +279,8 @@ map_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt, int slot)
 	if (!boot_cpu_has(X86_FEATURE_PTI))
 		return 0;
 
+	mm_local_region_init(mm);
+
 	/*
 	 * Any given ldt_struct should have map_ldt_struct() called at most
 	 * once.
@@ -390,28 +376,6 @@ static void unmap_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt)
 }
 #endif /* CONFIG_MITIGATION_PAGE_TABLE_ISOLATION */
 
-static void free_ldt_pgtables(struct mm_struct *mm)
-{
-#ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
-	struct mmu_gather tlb;
-	unsigned long start = LDT_BASE_ADDR;
-	unsigned long end = LDT_END_ADDR;
-
-	if (!boot_cpu_has(X86_FEATURE_PTI))
-		return;
-
-	/*
-	 * Although free_pgd_range() is intended for freeing user
-	 * page-tables, it also works out for kernel mappings on x86.
-	 * We use tlb_gather_mmu_fullmm() to avoid confusing the
-	 * range-tracking logic in __tlb_adjust_range().
-	 */
-	tlb_gather_mmu_fullmm(&tlb, mm);
-	free_pgd_range(&tlb, start, end, start, end);
-	tlb_finish_mmu(&tlb);
-#endif
-}
-
 /* After calling this, the LDT is immutable. */
 static void finalize_ldt_struct(struct ldt_struct *ldt)
 {
@@ -472,7 +436,6 @@ int ldt_dup_context(struct mm_struct *old_mm, struct mm_struct *mm)
 
 	retval = map_ldt_struct(mm, new_ldt, 0);
 	if (retval) {
-		free_ldt_pgtables(mm);
 		free_ldt_struct(new_ldt);
 		goto out_unlock;
 	}
@@ -494,11 +457,6 @@ void destroy_context_ldt(struct mm_struct *mm)
 	mm->context.ldt = NULL;
 }
 
-void ldt_arch_exit_mmap(struct mm_struct *mm)
-{
-	free_ldt_pgtables(mm);
-}
-
 static int read_ldt(void __user *ptr, unsigned long bytecount)
 {
 	struct mm_struct *mm = current->mm;
@@ -645,10 +603,9 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 		/*
 		 * This only can fail for the first LDT setup. If an LDT is
 		 * already installed then the PTE page is already
-		 * populated. Mop up a half populated page table.
+		 * populated.
 		 */
-		if (!WARN_ON_ONCE(old_ldt))
-			free_ldt_pgtables(mm);
+		WARN_ON_ONCE(!old_ldt);
 		free_ldt_struct(new_ldt);
 		goto out_unlock;
 	}
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 2e5ecfdce73c3..492248cfadc08 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -375,6 +375,9 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
+	/* Should be cleaned up in mmap exit path. */
+	VM_WARN_ON_ONCE(mm_local_region_used(mm));
+
 	pgd_mop_up_pmds(mm, pgd);
 	pgd_dtor(pgd);
 	paravirt_pgd_free(mm, pgd);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806d..118399694ee20 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -904,6 +904,19 @@ static inline void mm_flags_clear_all(struct mm_struct *mm)
 	bitmap_zero(ACCESS_PRIVATE(&mm->flags, __mm_flags), NUM_MM_FLAG_BITS);
 }
 
+#ifdef CONFIG_MM_LOCAL_REGION
+static inline bool mm_local_region_used(struct mm_struct *mm)
+{
+	return mm_flags_test(MMF_LOCAL_REGION_USED, mm);
+}
+#else
+static inline bool mm_local_region_used(struct mm_struct *mm)
+{
+	VM_WARN_ON_ONCE(mm_flags_test(MMF_LOCAL_REGION_USED, mm));
+	return false;
+}
+#endif
+
 extern const struct vm_operations_struct vma_dummy_vm_ops;
 
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3cc8ae7228860..dbad8df91f153 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1919,6 +1919,8 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+#define MMF_LOCAL_REGION_USED	32
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
diff --git a/kernel/fork.c b/kernel/fork.c
index 65113a304518a..ee8a9450f0f1d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1139,6 +1139,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 fail_nocontext:
 	mm_free_id(mm);
 fail_noid:
+	WARN_ON_ONCE(mm_local_region_used(mm));
 	mm_free_pgd(mm);
 fail_nopgd:
 	futex_hash_free(mm);
diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687e..15f4da9ba8f4a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1471,6 +1471,13 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config ARCH_SUPPORTS_MM_LOCAL_REGION
+	def_bool n
+
+config MM_LOCAL_REGION
+	def_bool n
+	depends on ARCH_SUPPORTS_MM_LOCAL_REGION
+
 source "mm/damon/Kconfig"
 
 endmenu

-- 
2.51.2



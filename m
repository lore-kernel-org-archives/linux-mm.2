Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163DEC4450B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51BF6B00BD; Tue, 14 Jul 2026 10:06:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29DE6B00BF; Tue, 14 Jul 2026 10:06:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18986B00C0; Tue, 14 Jul 2026 10:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89B866B00BD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:06:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B9CEA03EB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:15 +0000 (UTC)
X-FDA: 84987556710.17.62597A0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id DE9544000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UsBpoovP;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrTKSUYe+o4yYeiHIfdmZfk/VD/VvZ4yWrfSjmZcls0=;
	b=gutdqouskxlQZKgj6zCRd1Cj/89/lcciemkLFC7AsN6Gi7z7wDupCIyTcf3UH1a0+aekG0
	9THz656OL+WspjiDayE9MrvSXJZnyBXcNpCcvubCOyuB2TlxjNtMxQgumHhQgUd5EfNB2c
	oZlsTCnkT4b0ZAKEOAUE7LPQ6RUxVe8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UsBpoovP;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037973;
	b=Lt7Nkaibafj7CLADdZ6CYrXcbBkY6rY8Ho0ittCUT2gect6LtdqChJykxoqeSd33ooicda
	/Lc/9FDLTCIj1y6QyT9ClFPyTWVg7kb5KhWfrfd5IO22zJCHlgetGJVW3wDITzuqX1xSpZ
	x+mATKm+6HN4PiYvLoHZNcn+Wy2cowU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C95291691;
	Tue, 14 Jul 2026 07:06:07 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 923CB3F7B4;
	Tue, 14 Jul 2026 07:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037972; bh=wjWPKE4gokVm0n43Fz8OrYiTdEX4ZJIt+9rA3rzslZA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=UsBpoovPpZ85RSIZfXEnSBfVHOZtFnPkX47Kj5gg3LsgzJNhCVgTUWCtTOeVOPaNp
	 HKjlV2fnQGGYMeGqcjyozlJa7a3QA1IlDMrT8hf3JRzN2w2i+9FSRlqOzr8/QB6/Qf
	 Q0z0BAmzTk1fTpNEZ3NiarWVCe9KoxmszHFZ5aSw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:57 +0100
Subject: [PATCH 08/22] powerpc: mm: use mm_is_kernel() for kernel mm checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-8-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2458;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=wjWPKE4gokVm0n43Fz8OrYiTdEX4ZJIt+9rA3rzslZA=;
 b=mGXIMwx7mP+wc+PdjO+ERefisoZsiZf5NJNBVQYllixOIGkiZykJ/6wIrBXI36cbJ4lbGAtZA
 wL42KEsLctGAHh95szgDEyWgp6+51aO6Iy65UQOmRkiEbYbzhv701ws
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE9544000C
X-Stat-Signature: 5kjtmnipf1kja11hre9rag4fudk9knjt
X-HE-Tag: 1784037972-776787
X-HE-Meta: U2FsdGVkX18mdQEG6ii0P+5ebqkDIO5u4dC1T40HCkMHwvEWws+xhmrX4jPgnSnWLIdrWO3HG7T3+ZZMuKdzHx62T8sGv2cnSB/q/gGmV3dbpAJ1qz/ZyfbJnIDVJHVJdmzvaQUV+ee+tgwxx7SgxpwBvpdexjGj5HtuKIChkHiXeo6yWWyk/mU5LmMk1NC3M4Cl3M1AZSQYUFzAZdoacBhCxL/JWoAs9rbBVcwF5dX8PbZ5lgQcawj9lAr95acVXF9YV9vihWt5XfRnztg9QrUmASUOuC+Q9y2CD+oGr+LIWQ8GW7QnuNZIncJ9Yh1ePU9Zx1aQh1cxb9tspEYN87NXu0JQ4EL/fiIZ66Yeochsz1elxgmxFIk5ghRJj6q/7KfkTzW0o6uevOg26cRvHO2HGzstjplxOgeFFkrQ/7zuuy14EK0EezQCfzhYdjWuFmE56x5e0qBMh0WPAZOW/1tx50aB5uVVdzdYpLFrVfdAW2kFuvIiLilJuXQfsI/eTxc1TFN1PoKH3N4YmVLuyLwdrUMDM0t/fXG9Wrc2bA0aRAKM4hg/BKflzxDXAeHcvyVhExn2gzsj0zMnPR7OCjPqp0gjAV36vQ12QTQrnBe1fJl4qJ6BanEyZoUWX/Bx8ZKJzGM6ki5rcryiH8CskQlLieaLvKLSDxSV89+rL7jIzc86LeaVdNcow/6WQG4qE/BJtiFe+nH2JN0LcyiI2RCZ/TcJCT7xMSY7GcCv0dNP5m4Vcbtz+tRwb5a119ugXhqbltcTa3jBhF0Iq2xb3zzmxSr69KoAQ9m2ge/nGOJrm7c5VDOGED4Hz/lXlQk2KUivZJTpxlzDJ0tUmQHtATwNBoOcxroEpM5Yega/cJieHHVwNo9zlPEQFgfNvgjWNM9fOCvCQU6KRexgpNWiAIEpzWPPmhmnfi/njJzGWwh0tqfPY4Z9J1wqg5vS+DpUX0HFLkTX9AGhx9/zkof
 FUOJy8Uy
 16dzIB7kX/Y4dk7Kh0fGDKUCUYB02+cfwPhzlmfJulkNYAkk8xGo8TALe/A2JdKnxKtJsZDu6v2AeyxRMyvLHDNN7mDiQh9jFtQEzCd/WoxQKr6+vcBDHeRWaWQdQCGoFsThPfnX6pXaSm9l5Jllg0zyjvRAvJUvwukX7s/wlvdCf0iygOG5kmZ9Oe12CY5gIacJ9H3ekv5aD4VtfLmluUIbJJa+zw/yeCbij6s8rrcOeatRnpDqPDg3MfPzeIOIDfIaTv5D1shqSfOyb6DHIdmXZmbTyQ19lMvdJ8ybJrr5QlfYug5XSHOnM5m1oy84wHXkynsDZwO+j2TiViby+ECN+Zqg4a6TyVfj37N7VeJc7PNL+Jpidke6BzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

No functional change, as only init_mm has MMF_KERNEL set for now.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/powerpc/include/asm/pgalloc.h | 2 +-
 arch/powerpc/mm/book3s64/pgtable.c | 2 +-
 arch/powerpc/mm/mmu_context.c      | 2 +-
 arch/powerpc/mm/pgtable.c          | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/pgalloc.h b/arch/powerpc/include/asm/pgalloc.h
index 3a971e2a8c73..88acccc5b06e 100644
--- a/arch/powerpc/include/asm/pgalloc.h
+++ b/arch/powerpc/include/asm/pgalloc.h
@@ -7,7 +7,7 @@
 #ifndef MODULE
 static inline gfp_t pgtable_gfp_flags(struct mm_struct *mm, gfp_t gfp)
 {
-	if (unlikely(mm == &init_mm))
+	if (unlikely(mm_is_kernel(mm)))
 		return gfp;
 	return gfp | __GFP_ACCOUNT;
 }
diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
index 85ab6723c8f2..eb365f7c8907 100644
--- a/arch/powerpc/mm/book3s64/pgtable.c
+++ b/arch/powerpc/mm/book3s64/pgtable.c
@@ -395,7 +395,7 @@ static pmd_t *__alloc_for_pmdcache(struct mm_struct *mm)
 	struct ptdesc *ptdesc;
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp &= ~__GFP_ACCOUNT;
 	ptdesc = pagetable_alloc(gfp, 0);
 	if (!ptdesc)
diff --git a/arch/powerpc/mm/mmu_context.c b/arch/powerpc/mm/mmu_context.c
index 3e3af29b4523..b51934c511f3 100644
--- a/arch/powerpc/mm/mmu_context.c
+++ b/arch/powerpc/mm/mmu_context.c
@@ -48,7 +48,7 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,
 
 	/* Mark this context has been used on the new CPU */
 	if (!cpumask_test_cpu(cpu, mm_cpumask(next))) {
-		VM_WARN_ON_ONCE(next == &init_mm);
+		VM_WARN_ON_ONCE(mm_is_kernel(next));
 		cpumask_set_cpu(cpu, mm_cpumask(next));
 		inc_mm_active_cpus(next);
 
diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index a9be337be3e4..d04f4fecfc7c 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -393,7 +393,7 @@ void assert_pte_locked(struct mm_struct *mm, unsigned long addr)
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		return;
 	pgd = mm->pgd + pgd_index(addr);
 	BUG_ON(pgd_none(*pgd));

-- 
2.51.2



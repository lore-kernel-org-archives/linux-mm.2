Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5199606A330
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=arH33Iw+
Received: by kanga.kvack.org (Postfix)
	id 03E7F6B05EF; Thu, 26 Nov 2026 06:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015376B05F0; Thu, 26 Nov 2026 06:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46AF6B05F1; Thu, 26 Nov 2026 06:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4C676B05EF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:19:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6ABF81C4508
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:50 +0000 (UTC)
X-FDA: 85477025340.10.EBFA491
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id AB54240006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=arH33Iw+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691988;
	b=mWoXvCxbpwnHh48ZFz80ZJnqzYqFN5a+73fl/Sow3lpH+mE0Pd4J9eANCi9NHfYUfa1W04
	cH08nzA+CtdNjiTyZUelrfW3V6K9dsvmq5A9846B0+jw8UdTOH4GyQECp+xJt4+U/O/Nj2
	aJeWdZ7jDl4YV+3ox9ZM7nXRA3hU6fo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3baBQY1vcim/LIuBDd2iS5vp7cN9wnC3Urh2E32RyUQ=;
	b=HK5pmXKWD65QVt7apz6FBUCF6NdAORMnv0awTVeWlf9vq74AkJyIOh5veYOSTo/zZl4wMs
	BS6/5wLEGmAfWU8mH61XEIihVIunk9K+j9bibgn8NHWILHtozDU1eQuvKrDayYO2jEwRKs
	KLHka6W8a/RK9o6wGfH1sIClyr7Q/r0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=arH33Iw+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EE5DB43BED;
	Thu, 26 Nov 2026 11:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3021F008B2;
	Thu, 26 Nov 2026 11:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691987;
	bh=3baBQY1vcim/LIuBDd2iS5vp7cN9wnC3Urh2E32RyUQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=arH33Iw+PdWr+zlekYtf5nt+Op90L1TFCAIp15UEy+JOD/BMr6gM82izCzHJ1j53x
	 Rf7Bd3XB7buR8nKFBjOykUN3NzH886rFBdFTBPFTBNhX8nMAbZ26UqYbx9bGLW+g3i
	 /sQ2LSWtOosQOua5U2835M+MrgzYeEUFMalhl41+LsupVwAVt0II5/HrUmhS4p0NSh
	 NQAllOapJ7m1dfpO7PW+vkvGZTmiNe52cT0vTejwfyJiRSIEKrJTLRp8aAuN4g45//
	 GvISaE7BPJ/Lhx5ZN5KxgnwBOhwRJdneHwiwJQvKiPXC9/6nLeJSOz+UOUnwYZx5zs
	 1+Ng3jE8359qw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:46 +0200
Subject: [PATCH RFC v2 33/54] LoongArch: use pfn_is_nosave() to exclude
 firmware ranges from hibernation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-33-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: AB54240006
X-Stat-Signature: i5ohz58gieik63ubij55omapw7z8i7qh
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795691988-616323
X-HE-Meta: U2FsdGVkX1/FU1+e2LUaIHCvDRY5oJMrdCdzZKYBGp0LAoL38E7KtVuJ1846PGWY7gWCsT5M7jZPyy3m8iUQZttMHf/dHQfQczZnYDlx4GS8sVU+XAUfmsdkmKUay6k96zrSGvqql25SXbEnEnDBbOSV6gkTpeo9y/1QiS0NW4yTS74g0ZOyfNOP/ZBkd3TpJmrYBG+PyC1IkVQZVKoRWCuEd0IOjkRvxsW7Q36ztykiLN8Wb54n7U0q3G1VAYwExoFPjBpYEShwmZnn55ymopHGhvKRHv6I0jCNIBp6tDJLi94V/qxxiBQFxDgd8YRXeiwxMdbvUzRXbFJcrPH5i+Mh3JG/0ijhNFQyJtKc7VPAnuUADy30yb85JNVMZdQzfy0mkyoz8Gr5v37JXdvrbx6ag1K9pKsBWwuoZwEGhTa9G8pcVgB12JhdlBBw9djyZfuPCGq68DdgEbdPeIt0Zh8ODRuqKPlr5k6lbTh6hgCEkKboIFqekS7UAjcNUxEr19TMIUEID/xJr4HgBh7+LsORdynAnaLQMpQXhE0PDyFrm6IJ3Fysxme8wspVHQsdG/vHOlsbWLTZMQfmD8oM2Ng0kg1yxdsQsoqgf2zZDsayAZxoX6BmtoLovABhsBciX4hnAiYCg4u009e5F40NH25RdlTwG7lSjMmYGbDek1pg6ea+t79Mt/LjXovBC6Nk0iSNK7GOglSOb5H+tsjf0cQ9EZlBf72oUPS0trAOmAdWI/7dtwA1CD8lGPmNmGJkAjI73VU7q/K6KFvftsspdIRfEUesVT2uvU+vii0ydGHtgLKcmekaeTAq2fJ7lnanhvvkU3zHLNj20Df6Q5UbaGTNJPWz20WCSiAP/UClkFUEL67a7ZQzLpwVIJzx7o0/VoPxGuKF1QN9Q17mmECnQhR+ju9GD3XxRJsJirMbqmbDLQA6lvs6AQUxEcKFYINFgMjxJ4ykyN88SIHq9KK
 yAFbdIAN
 FHLMu7ZBfNVJT18TXoDqHYSaHd4bV1qtta+eh2men0z6uXICw8Os7KwayXCTyPJI2cUqXYgirwrAbcOb8devasNwoi34NITaKhKxIw5ynpfcIH/OURrpuNL17OfMLXtPpLC3DAU7Ao7ub+pKPrWaJv12NhAh7H4XyNFFuW9B7zJfqG+Xwl7C2tfugQnkZxG1MBcSzPPyWv/lV9GtDPZYZ9HhKIdHCVs25Dpuvkz+FUtqhqv4ReE+FOV55A2jy4y3Ad4DT99454wcdWGG79ygAOKq5EfyXFbPIU6WnWYL45nXaLc6AbIusZhBaAfZpHU7I65yxEKRWoY2N8hxl3cfxDaTclGFQlvXya2Ety6hMquaspYJ2qVmAxvxLyAjboWeThiXs6SX2yOrddyvfTwC7kdClxDuQox9i1HpTW4ogb7k5k/DaDbzUj0iwqoY6dmclJYCRBrFA+09LL6bsqcqVN/kydsWYzzxrOGJGJyNw39gj7ywKPhRPco2gTsqr8GVpi14FcpTt8Owkbkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 619b52777a49 ("LoongArch: Fix kernel_page_present() for
KPRANGE/XKPRANGE") made kernel_page_present() filter out firmware pages,
such as EFI runtime services code and data, to prevent hibernation from
saving and restoring them.

kernel_page_present() reports whether a page is mapped in the kernel page
tables, while excluding physical memory from the hibernation image is what
pfn_is_nosave() is for.

Move the check for firmware pages to pfn_is_nosave().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/loongarch/mm/pageattr.c     | 3 +--
 arch/loongarch/power/hibernate.c | 6 +++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index a7dcff40f759..a728db40f9e0 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2024 Loongson Technology Corporation Limited
  */
 
-#include <linux/memblock.h>
 #include <linux/pagewalk.h>
 #include <linux/pgtable.h>
 #include <asm/set_memory.h>
@@ -168,7 +167,7 @@ bool kernel_page_present(struct page *page)
 	unsigned long addr = (unsigned long)page_address(page);
 
 	if (addr < vm_map_base)
-		return memblock_is_memory(__pa(addr));
+		return true;
 
 	pgd = pgd_offset_k(addr);
 	if (pgd_none(pgdp_get(pgd)))
diff --git a/arch/loongarch/power/hibernate.c b/arch/loongarch/power/hibernate.c
index 3de38ffb11c3..65dbf1aed4a7 100644
--- a/arch/loongarch/power/hibernate.c
+++ b/arch/loongarch/power/hibernate.c
@@ -4,6 +4,7 @@
 #include <asm/sections.h>
 #include <asm/time.h>
 #include <asm/tlbflush.h>
+#include <linux/memblock.h>
 #include <linux/suspend.h>
 
 static u32 saved_crmd;
@@ -44,7 +45,10 @@ int pfn_is_nosave(unsigned long pfn)
 	unsigned long nosave_begin_pfn = PFN_DOWN(__pa(&__nosave_begin));
 	unsigned long nosave_end_pfn = PFN_UP(__pa(&__nosave_end));
 
-	return	(pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
+	if (pfn >= nosave_begin_pfn && pfn < nosave_end_pfn)
+		return 1;
+
+	return !memblock_is_memory(PFN_PHYS(pfn));
 }
 
 extern int swsusp_asm_suspend(void);

-- 
2.53.0



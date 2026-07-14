Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4B3C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A86D6B00BB; Tue, 14 Jul 2026 10:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F636B00BD; Tue, 14 Jul 2026 10:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BCCE6B00BE; Tue, 14 Jul 2026 10:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B3DC6B00BB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:06:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB7E0A03D5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:06 +0000 (UTC)
X-FDA: 84987556332.26.3441A06
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id F22C9120015
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gLbEbpAv;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037965;
	b=KqRnNxjs2WtGxqDMgNacaxyA+p72eF0DL27iV+jSgSusexK37XY66xakviiIFia585hh16
	WriOx/apsNRFa3rv57s+lILlZDg8f7Q8CBHkVX7o9FE8U6VnBspYQ0jXFEKRPMWt2YhNyS
	CQmgF74PNzJpGfYY4nwnGEjWBk4iAJA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gLbEbpAv;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oa1CtGB6O+ipLkqxSVLPYawR7pVmeA+m5qsDYuMHpVY=;
	b=fQhM96KV+cstmIVFCeqWSdFHbLo9c+0iuDjbHGdZhYAG90TZ7NHj/hamhg5EJazoiRyYyH
	SIVaz8rZxeKvRB91Fq0kB9NwHRM9uuoDABHdRyXbfyi/TizCSjsImoDVGxJHlU97xLNlT+
	mT3TzE+HFCyTWnw7Ulx7DLCRc7cBHfU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0839A1595;
	Tue, 14 Jul 2026 07:06:00 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4CBA3F7B4;
	Tue, 14 Jul 2026 07:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037964; bh=n3wqVkoRE0XrCf49SeUd/3zMbBniK8cKIbHpgqpyHxU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gLbEbpAvFzCqe/uk00cuBVEyk86ImDFUKg9+DAxOfE+6fXLZiWwmczq+TYqacIij9
	 dzObBv+9qrGLnOJGKWs94LTFpTVFSye5m9UY9LBRCiPUb+bTNDGQ4mEUs5d8asduh+
	 urPZbHaQ9KgT1hC0YSHV6N5wgcZRQb27Ns4Uao8I=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:56 +0100
Subject: [PATCH 07/22] parisc: mm: use mm_is_kernel() for kernel mm checks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-7-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2128;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=n3wqVkoRE0XrCf49SeUd/3zMbBniK8cKIbHpgqpyHxU=;
 b=NiOLSLM4Bju3NE/MJk1JSg+adlOz6kSqOBN5Q1Ojo91j2+7DutkOZ20lco5JkeakYm3HADh4V
 WLZkvqMg2QAA0cYBkRVmiWNUb4u1J8+jQygFQcLGfYdNrt+hwaqOb94
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F22C9120015
X-Stat-Signature: 39zwbhqfdp47tbid6nqcpn4bryp7u3ex
X-HE-Tag: 1784037964-17819
X-HE-Meta: U2FsdGVkX19JVg/wpK7Xv1FmiMuG3aXxaHg2SJAI3Y/DP3GEhtPbGVwHv5vN9hBgH0xOTLwJ+mDJLlRK7hYVhzUSKracgIYrTHAok4EF18gsPhynrZAjdKU3Pg4XzradMi23pwSkMUcALasAAioJrWG7EONZF+E8XkACu2NbDGiI06QtZmxsY/uEZiSe7Qaww5TQaUFISEdfqAYR+kOOXzo23Ze/CCdhmYg9jaoAIJsQquvekPYMApwtdKMyoWJbNQwvTlEnFJZVBIC8c/QEKRzhdnqwZEuklgZtkLgg8Z2ehnOijjOHp2fVeQ+lGMCE5tp7ar7bijMU5INgVTj+BGwfdRPonkEt4dAFe21F7abJjOLKXGxoOOz+uzpgH71lHtoHiADL2uX/gbG+7XyPhLXgBuBWPQVBK1I+786EDihJGb/8QBgUOtQPM4oHEImhRrM9eh8MIPZjeCQfbq9a5I4J42oD6xXYiWVSsc8NnXuLJgPo0KTmDVkveR6SqSgiDY3aqrCqq4+vsvHlXptMMKogiVsJvDM2pBwGMLSW9DphORvXREEP/bM+oeZY5J6fd99k3nZSv1dsP86SLFc6icZpO1qJI4pBmm8fsWeYFOdd/3sfLLcd0sLOASPXGg2moXHTVZb9Dd0xL8Ob9Z3+jOzF3r/TmL4J8I1y9t6JgINKjqnQCip+yhk45TeEMqgiW+z4UssDKL/3Ivs+tDih1SJeajpmj6E4VIr/HC849jVOp1rC/DayoCzqT0p1q/9vQbZ+TXNMGCrGwcFhvY7s+RC8JHbGEFDn1pCviGeLAeaLEzuthsKiC2s8Nm8Ri9hS14L3l8d/SL3lU1tr3/Jx4shWEJHo92YyUEEWEwyVMZzPRjVOfYidHNRkBNtgH7Z57W0Mw22S0i+jz5bWMMZxEoe5y4Po7fzCZX3BYMClsHmJqLt1U2TMDYyqyslYfNhHJ/BSLEBYUOLc5L62kPN
 b0kVZSPE
 b3FA8/bvOqqspN+v8U88Iw5rWqhazSxJItsKV4ANKYhwtfTcizLcI5zz+optvAg+jQ5oWVST3DQm5uTjoBw7DXqfEPKE8lFIZK2S7bglrYaKqc0nef2QDcsyrTObDYULUKgwfMBOV9stuzBlnWVCtvh2LQeYKbK3PoRK4EJyY5RJ8HGu/QdzKDs1n0G7BPt83T7uaUkftRHJqfV6xiPqxKYLjzXfrg+poX8+Z0J5kqgvqQpYS/0PnOZlxmP+c4+MSf+RyB+/4B9Lh/fpnkdpUseWKAgY4CzC5RvlEnBpHd3L73ZRWN2pKuiG+JLiAzvXF5jWVEz5736VPyGrho3COMN1D1ANLnMedGoi7FUbGv5iUIEZE3JRJ+xkKeA==
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
 arch/parisc/include/asm/mmu_context.h | 2 +-
 arch/parisc/include/asm/pgalloc.h     | 2 +-
 arch/parisc/include/asm/tlbflush.h    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/include/asm/mmu_context.h b/arch/parisc/include/asm/mmu_context.h
index c9187fe836a3..e265da67559e 100644
--- a/arch/parisc/include/asm/mmu_context.h
+++ b/arch/parisc/include/asm/mmu_context.h
@@ -87,7 +87,7 @@ static inline void activate_mm(struct mm_struct *prev, struct mm_struct *next)
 	 * already, so we should be OK.
 	 */
 
-	BUG_ON(next == &init_mm); /* Should never happen */
+	BUG_ON(mm_is_kernel(next)); /* Should never happen */
 
 	if (next->context.space_id == 0)
 		next->context.space_id = alloc_sid();
diff --git a/arch/parisc/include/asm/pgalloc.h b/arch/parisc/include/asm/pgalloc.h
index 3b84ee93edaa..9f09cc4fa5dd 100644
--- a/arch/parisc/include/asm/pgalloc.h
+++ b/arch/parisc/include/asm/pgalloc.h
@@ -34,7 +34,7 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 	struct ptdesc *ptdesc;
 	gfp_t gfp = GFP_PGTABLE_USER;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp = GFP_PGTABLE_KERNEL;
 	ptdesc = pagetable_alloc(gfp, PMD_TABLE_ORDER);
 	if (!ptdesc)
diff --git a/arch/parisc/include/asm/tlbflush.h b/arch/parisc/include/asm/tlbflush.h
index 5ffd7c17f593..a5a6cfff295c 100644
--- a/arch/parisc/include/asm/tlbflush.h
+++ b/arch/parisc/include/asm/tlbflush.h
@@ -35,7 +35,7 @@ int __flush_tlb_range(unsigned long sid,
 
 static inline void flush_tlb_mm(struct mm_struct *mm)
 {
-	BUG_ON(mm == &init_mm); /* Should never happen */
+	BUG_ON(mm_is_kernel(mm)); /* Should never happen */
 
 #if 1 || defined(CONFIG_SMP)
 	/* Except for very small threads, flushing the whole TLB is

-- 
2.51.2



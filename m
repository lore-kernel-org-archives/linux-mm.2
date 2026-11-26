Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC005606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YQX4Vlfz
Received: by kanga.kvack.org (Postfix)
	id 3241E6B05F4; Thu, 26 Nov 2026 06:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC396B05F5; Thu, 26 Nov 2026 06:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2120D6B05F6; Thu, 26 Nov 2026 06:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECD5F6B05F4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:20:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68BE41403E9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:09 +0000 (UTC)
X-FDA: 85477026138.05.AC79C63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CF4B38000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQX4Vlfz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692007;
	b=3SfaI+UGSS5hm3vxo7N1tsdFKtXdWTPTKHxdsBHAmUj6ImagwmwKpj78lHOvxqHhf3qv34
	gxgW01UT9yyUBDTcHrmTrjuRc3HCDEWoMhDSE16Rvr+1QU0Umso0ByVhxgeqeSw8ob3Jwk
	MHJp9Ng5IVlBJxNyP4d+60NTekU24n4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcovJ7fKpwSIau6n7YhDhlDaqqn2o0CpIonYbQhgs1Q=;
	b=EeI/PNphXbTVypm9503VYpaHWzU/sEGsO8WjjfF+UYIVuGgdPcgXYReiIxwVCvXUAfLwQA
	dMRdPesC/xELbo3doKTXsSUOA2TnIw7Nyu9Mf4TVv101jcMZVP8t3FXPRe07lUgy6rfSB4
	o9CuriY4rGGj3diFwH0fCmTapKVkeps=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YQX4Vlfz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F5BF630FE;
	Thu, 26 Nov 2026 11:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291EB1F0089E;
	Thu, 26 Nov 2026 11:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692006;
	bh=TcovJ7fKpwSIau6n7YhDhlDaqqn2o0CpIonYbQhgs1Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YQX4Vlfzncbu4ByMDCKIDOkYYuSMz8GiefAX4fx/EY+K2NBxvpNvsiNjKehGukcK3
	 lYy3m1CGX662GRgnQjDUdbqu7M4DZmesh3UjBMBBpadd+prI19r4f7zsZRkeynMYjI
	 xsqqk0eHRRZvHrMs/B6xCL2yudop9ANQuRk+Uwk6lNeuZmstf+gkjHcxLeG0C07xGd
	 Jso+S6uzBcWs9Srk4u6wHwIrfto5nZZkQZ2G7x16qj3IaMAxz77wxlvKOemicCLn+0
	 HxT7UKA95ELqMw6kAI+RO/k1BXqNlkMdNJ9XqukHBM6bTLzSCsIcXL/BxoHIhzTAYJ
	 imaUFPSKUcSjA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:48 +0200
Subject: [PATCH RFC v2 35/54] LoongArch: drop the huge page handling from
 set_memory()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-35-723f1e33c3d8@kernel.org>
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
X-Stat-Signature: h44jdrbpyahjuhpxqx85r66kqabidbqm
X-Rspamd-Queue-Id: CF4B38000B
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795692007-857358
X-HE-Meta: U2FsdGVkX1/p1movFybOatR6WuwgMbbn8mFc0Kl2TkG2iHd5nRAO/5+lc8UyMZucGFHnYL9f2iDRbHYMBDbTOwIB9TfRjGGkGTrHp1YQNLTM0pyIOK+KO/TZNeyUYD4GrKEJDMab6ylueL3AzMa0Z1p8Vu4zUvW2+rGQpUMnx5+ta3Wd+cTd7c5yphXxrMDyKaKOnJXfXOi33hWFDQHI/FuheP5WWtAwYqqgBaitXpFcQfLK7rjTyK7llWdtcQqodwak2LZu4UEPpprQvOkCC5TJGAxjjTblaHsdB281ckCkd/1LovWzZfIDtJBzI/f1Vx+Y8GhSmIc6Aop/mrvwIEzF5UzDqE+OBMW2Fc6WswspZJsaj9MJPtF4cGskw4xWk1C8f7WkbvadopZDRnXPGkoo051ia4AWRa3S3XjRpIa7Uz7m6GBArAikrqsvJ2vfER8W/667CJRbKqqEMdAi3IIgR7HOD88mDfwBLYe7dgPKyUBk9tjejpfKEQBTOgGY4k0hkzlmeo392oPbDTvd5sMc5L1Sr9pdPFDu2PQ+CTY2PILqxuzJUEXIXhLAzRX1IFo7YABrd9LWXrn2tHNMundLxlv8gGsaWT951VeIH3EY7o+bvAl+uuGYK8nkfugLSxwMq/606qnLc51gWowUNbGJNM/xqEFfLJKTvw8xfFtday6rJ0TA5DY7uLc9Cu9p7ucey8TYmOuvJFyMwhGXG2CCLwde5xnc67/eX0GsXPuIE753BN4bg4t9Cqvk+z2/74ARZWfL23dkptTdA4lmTWkDY2FGuCHmmrLCCfpcMk92WaNFNOKsE73fkmYxwkDtmpblUDX6uhArJXh3iX/n3za3ltrttIDaytEqKI8QzPFjUnakRR4VzSfRD9W9S+NlRSZ1pa4r4Y838IRKNAIljVU2kYvrqjy7typckD6GFv6AmWD/5HzpMSyDaPRpBT00cvWVih9Qnl8u8kcmLVH
 k4FZwHiF
 isWOoBc1vGHaT6MZqmb66vkNPDFeGDIing4nk+g1y2W+uUSU81oL21NtP7X3ICeY+QjPLCaFNZbZdXZMW0HKSbtPpl1N+kvb7EGigJ39x5GfFmwTZTbk0aCnt26KXt4sGDeHi6+7VpY4cvfXXlelDeXScdsaOQSEeim8fwqurhzwzr/U+J1nrBfNpuv+JYWe488Awh21nHAUSQiNt7SlOPxkH9dgQQFRrPapHBL/a7pQcs3LZ2RtxoamQqVQaLiS+3bKo+AEdRVUYE1zlHy6Y/rHH0uC48nZT8huFAJSC8lbYx8ZZgTG4Ab5XYf5/kQ5Aja5QGYWxn6pcKz3qPgpLtD2kMqTmXBTm5MWkoyeduv5kULqqEPLqeUtIZC7X3a4bysKEMJq693uDzmc5BDLP7pbBLIxC8p/Vqa7rhiLvDZnOgcBCsmVmxRyTbEkALyHfZfdeZg7QXk96nNxuV0JNLncu9rA71IS6f9CSRXFIhpYhb4jm59OuItdte5bTjLFBus5MOPvGqDsok4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

set_memory() never finds a huge mapping on LoongArch.

The direct map and the kernel image are in the direct mapping windows,
which have no page tables, and set_memory() skips them.

Everything in the vmalloc area is mapped with base pages, because LoongArch
selects neither HAVE_ARCH_HUGE_VMALLOC nor HAVE_ARCH_HUGE_VMAP.

The only huge kernel mapping is the vmemmap, and nothing changes its
protections.

The PGD, P4D, PUD and PMD handlers of the set_memory() page table walk are
dead code. Drop them.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/loongarch/mm/pageattr.c | 56 --------------------------------------------
 1 file changed, 56 deletions(-)

diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index 7283059d6e1f..11cea93c7415 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -24,58 +24,6 @@ static unsigned long set_pageattr_masks(unsigned long val, struct mm_walk *walk)
 	return new_val;
 }
 
-static int pageattr_pgd_entry(pgd_t *pgd, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
-{
-	pgd_t val = pgdp_get(pgd);
-
-	if (pgd_leaf(val)) {
-		val = __pgd(set_pageattr_masks(pgd_val(val), walk));
-		set_pgd(pgd, val);
-	}
-
-	return 0;
-}
-
-static int pageattr_p4d_entry(p4d_t *p4d, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
-{
-	p4d_t val = p4dp_get(p4d);
-
-	if (p4d_leaf(val)) {
-		val = __p4d(set_pageattr_masks(p4d_val(val), walk));
-		set_p4d(p4d, val);
-	}
-
-	return 0;
-}
-
-static int pageattr_pud_entry(pud_t *pud, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
-{
-	pud_t val = pudp_get(pud);
-
-	if (pud_leaf(val)) {
-		val = __pud(set_pageattr_masks(pud_val(val), walk));
-		set_pud(pud, val);
-	}
-
-	return 0;
-}
-
-static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
-			      unsigned long next, struct mm_walk *walk)
-{
-	pmd_t val = pmdp_get(pmd);
-
-	if (pmd_leaf(val)) {
-		val = __pmd(set_pageattr_masks(pmd_val(val), walk));
-		set_pmd(pmd, val);
-	}
-
-	return 0;
-}
-
 static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
 			      unsigned long next, struct mm_walk *walk)
 {
@@ -94,10 +42,6 @@ static int pageattr_pte_hole(unsigned long addr, unsigned long next,
 }
 
 static const struct mm_walk_ops pageattr_ops = {
-	.pgd_entry = pageattr_pgd_entry,
-	.p4d_entry = pageattr_p4d_entry,
-	.pud_entry = pageattr_pud_entry,
-	.pmd_entry = pageattr_pmd_entry,
 	.pte_entry = pageattr_pte_entry,
 	.pte_hole = pageattr_pte_hole,
 	.walk_lock = PGWALK_RDLOCK,

-- 
2.53.0



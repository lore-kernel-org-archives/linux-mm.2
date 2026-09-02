Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328F5C624D6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ADBE6B00CB; Wed,  2 Sep 2026 07:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45D646B00CC; Wed,  2 Sep 2026 07:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329616B00CE; Wed,  2 Sep 2026 07:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 067636B00CB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:58:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8456012019E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:16 +0000 (UTC)
X-FDA: 85168674192.21.17CE39F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id B78F840002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=krO2cV0w;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTVkw3ab/CFKRCPfMcchLiqENpkcFUwtICs+m7pnNZQ=;
	b=fyJ4xHSKDgp3ZQ8k+p2VrORqFtHrkaNorUGoAkWGlnEQCY4IEPvp4t0DM8dy4uY7Eteq46
	Xqct8QnGNhGhj54K8CP0rzVyhNMLKXMq0idZJYLocCkoN/3g8Yvvs1SCcrtoNmPr9IeDnw
	Ym+1WPLOk/nrEf7UYw8IKGRnBDRyr7Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350294;
	b=VUGIIiWrqxU7PqvjXtD3OnVstApQjqoVLjfwVHjd319siflXYk/4yIqocDemUFxNX5hvEs
	gUxKgM3HmBFW/9CBWlI53nn/sMDihr2YVjYtaiIOpcpI4wYsqvNrgaQlP4jxHcWmsNQuGu
	WzzhVBbWeEs50NGKntbVAWC3cUSbYc0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=krO2cV0w;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1EBA71D70;
	Wed,  2 Sep 2026 04:58:10 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AEF93F85F;
	Wed,  2 Sep 2026 04:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350293; bh=lMx8oDxLrRJvH9eMXBjYWF4f+9ZOpE9Y518eoKaPMJE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=krO2cV0wUbHoNz4HiaCO7WUC3BC407rFyRRBRidPDVLMxsiarl33hEi5TdBmSfdAe
	 bp001uGnvUM1OPwKydsZG2MF9KK8CeaZyIGT4eRDw5V4mnQ/BGbKmieKcomRbkNsOO
	 CBFUA5OOE9OOa3d84FuizOQSQ6+w2BL4az9e0MS4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:15 +0100
Subject: [PATCH RFC v3 13/21] x86: mm: use pgtable_level enum in
 effective_prot_pXd()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-13-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2103; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=lMx8oDxLrRJvH9eMXBjYWF4f+9ZOpE9Y518eoKaPMJE=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7orgNlXXrDglsxwFE6HkLoSMOcv+hn/RGo5
 OZ6Np01hJGJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO6AAKCRBt1cPRWsUx
 M6wOC/4jh3pwjU1HOyorFYcxwSr12oxSEh2yyO74vVtlI7NHpYX5RUUsEZYTnG7+qkDv6ow2iGZ
 AmD3S0ZBxZOzZv9316P62wrPLZu+N3mv3CRuoY27dQMaReBMceQ+4a2CinVFRCeQ7E8m6YIVk5O
 fro0sHSel4RIL4bWa5rTIGwerRJl1goYmC75WreM/MYuWJL9fYxHraDTdlqR0RNnFE4gqF80Jgs
 4TXQWJxntju4OCT7na2A1iAhwi+TjtYBPuj+OQUT0ds/9dAZMHzM6isjqvaOSBhSxnnYfCreX22
 bIQgyPKV3lI59hX7t0N7MG8fUyfmZiMKbPaY7VeioNA7Uswd+OSBeEXQYLmX4ZXfMx/qi5w198K
 t83/WRBdsBEQeChKPf05sHb1SVA5a260F4YS5f6T18Mq2g6xHN41XtDkUgU9rLheidhBTkRZ93w
 LncxMkb9iEoBk6h2+9ACSJ73MImH+il0LpD5x3Akn/XsjQWHN76L6I8KnDsqy5cVwct7g=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B78F840002
X-Stat-Signature: btkuz34888wkzyekek4jphwifhoco7az
X-HE-Tag: 1788350294-164410
X-HE-Meta: U2FsdGVkX1+nQORqFkE6DYAzmQgeDZFexAdg3VFlU83O6S33DSugW6vdJWRZVqAmoGLcCxL86a8EZyO/Douk7Gp8VOjHPbKKabdwkNcmJideefCq5dEr4pKwAaIhRt9hXHuWxO9egYUXUUtEK+NNFJwm41Ek1Sqb7AnZCDGUxHIGVEljznqcL9b4SPoYKKvKQSHvuOZ341JACOoo+seCl6KxLjFAEnlb52M1ePpn1UCX18Nd5gknZG7ePPkFqEf5j2o0f9yiwBbpvUJxRSjmi1Yr5IU6uliEIz+ZUwOSNPt0HJtbHut/y0Y1i3hXiTRhYyhXvyFjKTr5cxdDuH2FCObpP78MrjxYdDmLU1OFRu9nAG3Eqf11VBzR6Kyc2OsSglfeTw+5w8Ck8eUFAKClxIgsPcr3A0YZjvhAQr4X6eVdwi2Fk7wKsr3PzAuc9Rw24Oz67bwHcm2/2YfUPXf455uTzp1fhTuYYjp27MoPznH1CvCaLVZ7EOpKz5yvBUK+H2fNZUjoOhon5FT4cSYf/Tf6yR/XkfurBJdN3UTcg9iDVnf+qBgqxBUYxr1Xxiz/j74km3+KDSXI2PylCfYOT6LqNnIjqEvyYcCKlImJ29LIcZoagU4Tmhxst+sUj9HfqdPRwzLeDYYTJBXt/0kZmMUGDujvPuRXdRkZT/utuxRGEazKIlguaFd1zosT79KlVtuz3gGntqExPwkqmDbTriYnQ0Np0Mm2DqDTuS889wUfvpnCiF/3SDHYHi01Xr0NRScUVtM+qqBuNRo/y75LB/xxgnZcLlvCsIfDRgJpbnP4JKivUDsiZu29We2eycFq8HOqXx/WiJb2T2gGY3C84/oEmq+ZzXdKjGEELSZFzcKbyDDNzdZQ4KdwlgVSTk1uq49tE6d/zHKQ6pPRsm8KYtkiz/eBP96Yy/4qIdyQDfsbeCw41LWHAm7YHco6J7IGy1c11sGVA4YAE+jMtT0
 2f6MQ27L
 aty6LtMMTuic7kKH9YbPewFlbDQJr/ZKfHhOY6OhEqb1LnKI1SsSSDq2vldpQiesSLeRUxfCP12t5W0rtjzXdwZb5ApP69+9X1BQBlaDOCt1CEQpQ4ug3TG323qAiTGNX6H+J3wpqYYY1jMil20CvRV3QrJ818LdyJRrewo3oCpmC+pZyBX7x0YubiT6j3OwwcWTceHrFJSOdRhJLz6RpYhQeCVkFqD6yNZtG0o+zxIdBq3XmNzsKY1HV+TkL95rGJ4/Laa33sXoCfMO+pvNl6VmDi9mt2o8IvBYRf/ZQorAo5nE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of using hard-coded integer in effective_prot_pXd(), use
pgtable level enum.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/dump_pagetables.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 2afa7a23340e..a18a61e732c3 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -248,13 +248,13 @@ static void note_wx(struct pg_state *st, unsigned long addr)
 		  (void *)st->start_address);
 }
 
-static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
+static void effective_prot(struct ptdump_state *pt_st, enum pgtable_level level, u64 val)
 {
 	struct pg_state *st = container_of(pt_st, struct pg_state, ptdump);
 	pgprotval_t prot = val & PTE_FLAGS_MASK;
 	pgprotval_t effective;
 
-	if (level > 0) {
+	if (level > PGTABLE_LEVEL_PGD) {
 		pgprotval_t higher_prot = st->prot_levels[level - 1];
 
 		effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
@@ -268,27 +268,27 @@ static void effective_prot(struct ptdump_state *pt_st, int level, u64 val)
 
 static void effective_prot_pte(struct ptdump_state *st, pte_t pte)
 {
-	effective_prot(st, 4, pte_val(pte));
+	effective_prot(st, PGTABLE_LEVEL_PTE, pte_val(pte));
 }
 
 static void effective_prot_pmd(struct ptdump_state *st, pmd_t pmd)
 {
-	effective_prot(st, 3, pmd_val(pmd));
+	effective_prot(st, PGTABLE_LEVEL_PMD, pmd_val(pmd));
 }
 
 static void effective_prot_pud(struct ptdump_state *st, pud_t pud)
 {
-	effective_prot(st, 2, pud_val(pud));
+	effective_prot(st, PGTABLE_LEVEL_PUD, pud_val(pud));
 }
 
 static void effective_prot_p4d(struct ptdump_state *st, p4d_t p4d)
 {
-	effective_prot(st, 1, p4d_val(p4d));
+	effective_prot(st, PGTABLE_LEVEL_P4D, p4d_val(p4d));
 }
 
 static void effective_prot_pgd(struct ptdump_state *st, pgd_t pgd)
 {
-	effective_prot(st, 0, pgd_val(pgd));
+	effective_prot(st, PGTABLE_LEVEL_PGD, pgd_val(pgd));
 }
 
 

-- 
2.43.0



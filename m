Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984CAC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58FB96B0099; Tue, 21 Jul 2026 12:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 518EF6B009B; Tue, 21 Jul 2026 12:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457636B009D; Tue, 21 Jul 2026 12:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1376B0099
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B01921201ED
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:11 +0000 (UTC)
X-FDA: 85013305902.25.DA81C26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id F11604000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6oC1Y2Y;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651050;
	b=UZXjmHfvbgKekbgvCuUR+LEjrHViwZHfRn/dEuApIUsnmrkbFmczXOURvsCGSE55tVnvG3
	5TPVbxmgBRWeNOWEc8VtSqdP8W/BBNtnVxL/J4fTJIH/spLnJIvqVNZrZ+Re9mfMOmz/H/
	wC3295xLpzliqhfpLVPlD4DbQ4U3uJY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6oC1Y2Y;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Wguk/FKFbBfgrue612K7C908fnjMdpbMIygxr4WCGE=;
	b=WD474Dl5pOYhlNVw9iTFOrcAzkcttz1tD7W0dzC2id1LpBHPyh3JCHEkNrzzM7iqxT8Zw4
	ZRs6DFnIGfQDV74yA0HHREHxaDaLrXMbJOouV6ojYA8pp+hhl/zAF36SJ3ZdIMKZSbbT+0
	X3ZG24A2LEJpGSexmrGd8Kf6XYjBRRc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AE8642446;
	Tue, 21 Jul 2026 16:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9301F000E9;
	Tue, 21 Jul 2026 16:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651049;
	bh=0Wguk/FKFbBfgrue612K7C908fnjMdpbMIygxr4WCGE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n6oC1Y2YhkB33kl+lY/6bGcVcuCS/W837kNYiwgxRqaeUrDEn9g39wd1GM4MW8px3
	 oNj01sZ9u1lNDGqVzzXPfNa0Ea/Of96eh0QA4sqNpYWUbnY+yJky9ikCkzQmMhSxr9
	 6IvRG18RVe7qXyX3xCvW9Zz65lUPSfZFPe2svum1imsJKQRJfRIjxXtjMjE7tfR/Jy
	 YWYTcZ6iEPaaL37jM9qxoRu089n2DJI97hm3OHoC2zBYISI0/0uZFBSFN6Fh4t4EJs
	 J4dwYxv2Gk/8dIJughDCqh3Los59MNzkVdM9/sO0CdNg41rIY3YGtWzd8PgrLXK3a9
	 J9gqKimG7Gp5A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:27 +0300
Subject: [PATCH RFC 04/18] x86/mm/pat: use page table accessors for
 effective RW/NX bits
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-4-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F11604000D
X-Stat-Signature: pce379jru8o44kdaw1995qqdby4a9aea
X-Rspam-User: 
X-HE-Tag: 1784651049-63462
X-HE-Meta: U2FsdGVkX1+FcV7UN3h1Tz9xNj1LUMwKBASYP3HuzqLi7clW0b4QxIhfJUxrkazSsGpBMBq410x7A/i16nMvHh0G7BT5SrAqdPk5wpWg+cTD7vh3BFdXPiXbYWEu97eg2RRn054sY2r3/55TdO/Kl5itIuISFsd5NBnMWN0/UUuHvqHDTwAHK9SpjVt1Ym6lMsg3rpN2dgPW3ilvxMfy39BDhGcbBhZxG+XI+mIHkKPrberxpSr5YbDyfTmiya2pueTM8/pbPnw8Ub5ckaD/va57Kq6FGZ0ZgLsDLvpxl752Oh2hGs6bmWwIfDO2mFCLzEeKcbqf3vE2ut49MicSEES3dyQuBdxk4imWZupm2BEdjFXI0D0bc3IPaDvWWRfW4QiVxsjqSAZy+oDi2GPqntMP6cf48qs2C6t/r6ov66rbn8r4hrDRGbHVUUrE6fonJPM9XnaoRHaBQhfgIT6kpRQtlf1S9aCSO2E4UTL+cwECqCM2k9y5t0+PImIrDyYbkgve/yGil1XY2DNrXMDtyN6qvsi1mlHUSq9/payomecJl1uFKdR8dLacne2t7LV6xlSD4KXfR+lGo5+VdJQzntLlzHMuUc9uXTWzoxjCFFKzr37JI4v1rs55HGbh+UGUbMLkCBzC73q1QsT0Cfq3+FRP7q4mxomqjo93v7JwS8Mfrc6kbtDLW7Ran/gJOw4lk8mPgeHwMvB9XpFx2X8OlNez3lcn4/wPCUdMOdoJjH7jksanbjUtk9oqEp8tBDGVO4z2//4sbxGhovqW0bX4VSLakVaNJVtoIuUqPKRq4YMPQek/V9Gt7MKKYYnWtrTN+glrqvSD16VvwxtMJ3IjQ2xMfYWYOVZsdrcbpGiJ39+PfiPZnslfI43ottGw9mExaQPqJViN5QcxB6a62iG5YUxsD9YisAcUDo4Lf9PDfiVKroCw+8b6WxhhumvMPJZ2eUR8HnCx2jbe146R8JK
 2HCQi9Tv
 H0CNKCAm/flnFurTmm/vY5JcbEqZdbVs+UUQXQwzUIhYqLw9axEdZXSnI8zZV1s5/1qxds0qooTqlNZWyaycfM+FjxU7ymE8DEJjbBJr5HtNy+QMrDFD4MhpQXmiOsVGVEg0slFAT7UciZKhFx/vdHvOZxZvVDMUNhWc+9kmBtjZu72xfQ6/+C08Bzu8pCYOaaOyr//7vWS/ikyAwbevZNUi8ld4lkejVw5cJCEC7KIebC0tKFqL3xatfKHrD2vZwJzowiISNE9fkZbk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation to moving core parts of change_page_attr() to common
code, replace open coded checks for _PAGE_RW and _PAGE_NX bits in
lookup_address_in_pgd_attr() with pXd_write() and pXd_exec() accessors.

Add x86 implementation of pXd_write() and pXd_exec() accessors and
provide generic stubs in include/linux/pgtable.h.

The stubs follow the existing pattern and BUG() if they are called.

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/include/asm/pgtable.h | 36 ++++++++++++++++++++++++++++++++++++
 arch/x86/mm/pat/set_memory.c   | 16 ++++++++--------
 include/linux/pgtable.h        | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index ac295ca6c92f..497aaf08ad36 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -227,6 +227,42 @@ static inline int pud_write(pud_t pud)
 	return pud_flags(pud) & _PAGE_RW;
 }
 
+#define p4d_write p4d_write
+static inline int p4d_write(p4d_t p4d)
+{
+	return p4d_flags(p4d) & _PAGE_RW;
+}
+
+#define pgd_write pgd_write
+static inline int pgd_write(pgd_t pgd)
+{
+	return pgd_flags(pgd) & _PAGE_RW;
+}
+
+#define pmd_exec pmd_exec
+static inline int pmd_exec(pmd_t pmd)
+{
+	return !(pmd_flags(pmd) & _PAGE_NX);
+}
+
+#define pud_exec pud_exec
+static inline int pud_exec(pud_t pud)
+{
+	return !(pud_flags(pud) & _PAGE_NX);
+}
+
+#define p4d_exec p4d_exec
+static inline int p4d_exec(p4d_t p4d)
+{
+	return !(p4d_flags(p4d) & _PAGE_NX);
+}
+
+#define pgd_exec pgd_exec
+static inline int pgd_exec(pgd_t pgd)
+{
+	return !(pgd_flags(pgd) & _PAGE_NX);
+}
+
 static inline int pte_huge(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_PSE;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 328805933d4d..8a1782f5de3e 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -729,8 +729,8 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 		return NULL;
 
 	*level = PGTABLE_LEVEL_P4D;
-	*nx |= pgd_flags(*pgd) & _PAGE_NX;
-	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
+	*nx |= !pgd_exec(*pgd);
+	*rw &= !!(pgd_write(*pgd));
 
 	p4d = p4d_offset(pgd, address);
 	if (p4d_none(*p4d))
@@ -740,8 +740,8 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 		return (pte_t *)p4d;
 
 	*level = PGTABLE_LEVEL_PUD;
-	*nx |= p4d_flags(*p4d) & _PAGE_NX;
-	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
+	*nx |= !p4d_exec(*p4d);
+	*rw &= !!(p4d_write(*p4d));
 
 	pud = pud_offset(p4d, address);
 	if (pud_none(*pud))
@@ -751,8 +751,8 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 		return (pte_t *)pud;
 
 	*level = PGTABLE_LEVEL_PMD;
-	*nx |= pud_flags(*pud) & _PAGE_NX;
-	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
+	*nx |= !pud_exec(*pud);
+	*rw &= !!(pud_write(*pud));
 
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
@@ -762,8 +762,8 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 		return (pte_t *)pmd;
 
 	*level = PGTABLE_LEVEL_PTE;
-	*nx |= pmd_flags(*pmd) & _PAGE_NX;
-	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
+	*nx |= !pmd_exec(*pmd);
+	*rw &= !!(pmd_write(*pmd));
 
 	return pte_offset_kernel(pmd, address);
 }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 3889bc2a1f76..4b42ac5c27d9 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2105,6 +2105,46 @@ static inline int pud_write(pud_t pud)
 }
 #endif /* pud_write */
 
+#ifndef p4d_write
+static inline int p4d_write(p4d_t p4d)
+{
+	BUG();
+	return 0;
+}
+#endif /* p4d_write */
+
+#ifndef pmd_exec
+static inline int pmd_exec(pmd_t pmd)
+{
+	BUG();
+	return 0;
+}
+#endif /* pmd_exec */
+
+#ifndef pud_exec
+static inline int pud_exec(pud_t pud)
+{
+	BUG();
+	return 0;
+}
+#endif /* pud_exec */
+
+#ifndef p4d_exec
+static inline int p4d_exec(p4d_t p4d)
+{
+	BUG();
+	return 0;
+}
+#endif /* p4d_exec */
+
+#ifndef pgd_exec
+static inline int pgd_exec(pgd_t pgd)
+{
+	BUG();
+	return 0;
+}
+#endif /* pgd_exec */
+
 #if !defined(CONFIG_TRANSPARENT_HUGEPAGE) || \
 	!defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 static inline int pud_trans_huge(pud_t pud)

-- 
2.53.0



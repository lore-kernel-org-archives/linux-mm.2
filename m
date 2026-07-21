Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDCFC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347786B00B0; Tue, 21 Jul 2026 12:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324D16B00B2; Tue, 21 Jul 2026 12:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235446B00B3; Tue, 21 Jul 2026 12:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9CBF6B00B0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:25:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6992FA066D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:13 +0000 (UTC)
X-FDA: 85013308506.25.146CE31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C2200A000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:25:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knGmISKm;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Js+8Q33VygYQF2f+rI8d1hZYY9K88zAKgM98T6HPJCQ=;
	b=6y0z1sMKRpGCJAUth1mzb/4URWNFSkzk1+jVZ9bkcJK6PMtC85ABjMmZchlbGYbcHOIROm
	IxcKi8ebLBwsreaGY+blvX6XICSBy/jCFdIL9N71/Pv/WC8VHA5D816z+UFkinZTJHmW6M
	RdgYXA3SFdGU4DOgvjYNPDU0aNlK1vc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651111;
	b=WKC9XOH6M9gwP6gbaRaeVz98APyeh8kPPorBIWBDvma+WseG/uiLCRgjZA1Rfd9fRZzpcC
	5W3m4iiHh/boT9mBqsfjgamovqgSELs7ZiI1NCo525wI1dwJFSu2zN0OtThyeESHgoi5Xe
	JBJclIeYGFnmLaKlZ0or7FBX21ETOkY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=knGmISKm;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6228060A59;
	Tue, 21 Jul 2026 16:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87D31F00A3A;
	Tue, 21 Jul 2026 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651111;
	bh=Js+8Q33VygYQF2f+rI8d1hZYY9K88zAKgM98T6HPJCQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=knGmISKmG/BpTGf3mdF+taH3r3WgwshVgHqiOn1OH7w8ZYPlLuFE1bw2SEYXNLgFT
	 ZyhqpGWWKo19TQ3MPPpXN+GZPwI0a6+0Nci6x9wHqb6uUW6JiWzba+ApDnZJf8ebDl
	 Jl6wIGrMr3jcCsZgsR04vjHPe49jvu/tZiS3IgvaIi/vR5zFqNBHxbiHhI+58vmGN/
	 J7a7AySwjBFN3RDHpaRdeuwiD6tZomFKQmhbp5v/q4xpv6bwFW1vKs98kH77A4iB2q
	 v+XGDbzsk5M2bG4ybuFIGo6+igguIhVbekdTaiDHY+xnY7pWGwk9KZ9DHSXNrCfNom
	 WPO73fe4BpyCg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:36 +0300
Subject: [PATCH RFC 13/18] mm/set_memory: read page table entries with
 pXdp_get()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-13-2c1fc62306b3@kernel.org>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C2200A000C
X-Stat-Signature: yoi9pwk8gcans3whjw75qrcogo4rx8in
X-Rspam-User: 
X-HE-Tag: 1784651111-180973
X-HE-Meta: U2FsdGVkX1/31Ga8CAV33pC8XshjmFgcGm4C8qgpBV8LtM4GVK8TzTfD0JjOuRpl7u5Qsq4jKJSrcOqpmlB3D995blD3C320+G01rPv0pKUznVo3h6SV8XyKGAfzvh/EO0eVg2E8Bxy3b7iiDhejqBhswbpkmeCrgy1b0sf9VfmiB033Y2s3sklXScIseShWv3m5RdgWBNOhXLJ1HtaIb3GtbegcmdCSQf60MUmbC9YX2SpyJIH/1cJIJ+8ErA+wcGneUxki097poD6GgVYtUi3KvJ3p4AXc7AREdDWKKuHtDBll/GbaiaGTMwtxyCI56WdSt+dXJxF/Opn3i/ih9RNcQ749AXYN0BCoXP69NziNHM83dANqQTKsfqzmsrlhcWA2Bs7MvRrFrDUgCSZ5PZ61BZeRdCpnoevk/u4wVq5vQYF3CwscLfcGQNW5vs2zndUWQvGd3o/LQfZmDhOyV8jjroxfe9O1lzsrkof3Mau5HKPRQch+duGB0SME2GKu9yHlTeIoy0OL6OLZpO1mKAGuipA+92ofDihgDlTM5IQTde7rApgjJoKtCuc1z+Jg5avV2cJ9tHnB2OqLxmroCm6K+XqbbNq48iUUp4EbVO0T3xEW5pzIsqLpEOM5j7d/DUxh98+NPIXa6gZjKA8cXhx+CO0dMTD27DhaWsLAyjtAvYHqxfRGftolS9DwDEeNkuppP086VfAfcxAlvSWaw7/YQdCHVQaSFzEjH3DUo6q4ObOeYi1e3dWkUROiVMbxtE0jJ4owh3UVNgvmbwSo9jWCFdmC2irzXCHZSBUDTtJxcayjIKsaTexzxypaCkul1BjupTXUqaRdrbw/Ai+Exu9k8P1MLVOEvrRvNc9UHqoIDZYyEC/Uww096l4y31YT3sh04dtr6AwjmExks2xiCIx1taVYzK7XFe0z4kfov9vElBs9hOxTLTv3Edsc061uWlqcfauOSlyifVBPhP1
 gyGrFurd
 GvheZRy4dC1m/q4yY7WFGvTfPs+HsxTb10ihOsSyEK7fmfLzjRWAjSAPYTMxZiKnNS8KU9zIK/LInLfd/Ex2c00jEnzh9lfm6m+pknV81F9VN1aYFdU0LOet9B5N62EFb6+gawXFIkS8yhu3YXVSUjP89RJjO/7cDmNdBplGCj00LUwJP7JCrXVYxgf8c5tMfZRzxOvJn7paG5jdlYxcAQQWvwrzuX6KguxVOpN5vyZqAnHP6C4qEZ2tynbFoszkqDLWPtqDrON/DPtZhd+1B6TKQqxC7lMOgobs87yuxdtOvM5MiTiqUNMekMFcXPf9CWrmZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As a preparation for enabling generic set_memory support in riscv,
replace direct dereferences of the page table pointers with pXdp_get()
accessors.

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/set_memory.c | 56 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/mm/set_memory.c b/mm/set_memory.c
index d2846804e4e6..1a7e63512981 100644
--- a/mm/set_memory.c
+++ b/mm/set_memory.c
@@ -51,58 +51,62 @@ unsigned long cpa_addr(struct cpa_data *cpa, unsigned long idx)
  * the level of the entry, and the effective NX and RW bits of all
  * page table levels.
  */
-pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
+pte_t *lookup_address_in_pgd_attr(pgd_t *pgdp, unsigned long address,
 				  unsigned int *level, bool *nx, bool *rw)
 {
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
+	pgd_t pgd = pgdp_get(pgdp);
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
 
 	*level = PGTABLE_LEVEL_PGD;
 	*nx = false;
 	*rw = true;
 
-	if (pgd_none(*pgd))
+	if (pgd_none(pgd))
 		return NULL;
 
 	*level = PGTABLE_LEVEL_P4D;
-	*nx |= !pgd_exec(*pgd);
-	*rw &= !!(pgd_write(*pgd));
+	*nx |= !pgd_exec(pgd);
+	*rw &= !!(pgd_write(pgd));
 
-	p4d = p4d_offset(pgd, address);
-	if (p4d_none(*p4d))
+	p4dp = p4d_offset(pgdp, address);
+	p4d = p4dp_get(p4dp);
+	if (p4d_none(p4d))
 		return NULL;
 
-	if (p4d_leaf(*p4d) || !p4d_present(*p4d))
-		return (pte_t *)p4d;
+	if (p4d_leaf(p4d) || !p4d_present(p4d))
+		return (pte_t *)p4dp;
 
 	*level = PGTABLE_LEVEL_PUD;
-	*nx |= !p4d_exec(*p4d);
-	*rw &= !!(p4d_write(*p4d));
+	*nx |= !p4d_exec(p4d);
+	*rw &= !!(p4d_write(p4d));
 
-	pud = pud_offset(p4d, address);
-	if (pud_none(*pud))
+	pudp = pud_offset(p4dp, address);
+	pud = pudp_get(pudp);
+	if (pud_none(pud))
 		return NULL;
 
-	if (pud_leaf(*pud) || !pud_present(*pud))
-		return (pte_t *)pud;
+	if (pud_leaf(pud) || !pud_present(pud))
+		return (pte_t *)pudp;
 
 	*level = PGTABLE_LEVEL_PMD;
-	*nx |= !pud_exec(*pud);
-	*rw &= !!(pud_write(*pud));
+	*nx |= !pud_exec(pud);
+	*rw &= !!(pud_write(pud));
 
-	pmd = pmd_offset(pud, address);
-	if (pmd_none(*pmd))
+	pmdp = pmd_offset(pudp, address);
+	pmd = pmdp_get(pmdp);
+	if (pmd_none(pmd))
 		return NULL;
 
-	if (pmd_leaf(*pmd) || !pmd_present(*pmd))
-		return (pte_t *)pmd;
+	if (pmd_leaf(pmd) || !pmd_present(pmd))
+		return (pte_t *)pmdp;
 
 	*level = PGTABLE_LEVEL_PTE;
-	*nx |= !pmd_exec(*pmd);
-	*rw &= !!(pmd_write(*pmd));
+	*nx |= !pmd_exec(pmd);
+	*rw &= !!(pmd_write(pmd));
 
-	return pte_offset_kernel(pmd, address);
+	return pte_offset_kernel(pmdp, address);
 }
 
 /*

-- 
2.53.0



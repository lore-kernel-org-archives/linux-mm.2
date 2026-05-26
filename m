Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A34CCD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330606B00B7; Tue, 26 May 2026 13:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA7F6B00B8; Tue, 26 May 2026 13:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181726B00B9; Tue, 26 May 2026 13:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB9356B00B7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B869C1A0453
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:39 +0000 (UTC)
X-FDA: 84810333678.30.6859C31
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id C9B1E100009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fTfDGdb6;
	spf=pass (imf14.hostedemail.com: domain of 3iN8VaggKCPUXoaY+dfqdlldib.Zljifkru-jjhsXZh.lod@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3iN8VaggKCPUXoaY+dfqdlldib.Zljifkru-jjhsXZh.lod@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqWf3aIh9jwoRDW7ej6OaYtUXPKSIApXmlGfcanpMS4=;
	b=vp6aa1aqbImFLUqr3KYgxLXQa8cq0An91g8Pqt43mKUG6VtAiKrQnftTipHtwSZVspROTS
	Mf3dcWcE5HvPQJfR/FTFKoe4/fmhCklaZhhhJxjOH2hLDOeFpNOoFoCB2sP96Ub1jUY2fd
	PzPVdEaTax4N8Ky+1uWNrel28gzYo9E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fTfDGdb6;
	spf=pass (imf14.hostedemail.com: domain of 3iN8VaggKCPUXoaY+dfqdlldib.Zljifkru-jjhsXZh.lod@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3iN8VaggKCPUXoaY+dfqdlldib.Zljifkru-jjhsXZh.lod@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818377; a=rsa-sha256;
	cv=none;
	b=Nfcw/YLzwp/+SEQ9l+MyIwx4cHiZBj9mI4MNOGvi5LF4EgC4xAVkXxBnA3wAiQPWVAvW8v
	a/f5cAcuDWYR58oahkrMyW56LYz5wlM7vLvDGH9A1KN8HLpI6rOgB3wlPNNpB/asgDr8pG
	4rj8+bkrtxeINYs9BJ21G6T0Q4wfDY4=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-688b055e937so3002010a12.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818376; x=1780423176; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZqWf3aIh9jwoRDW7ej6OaYtUXPKSIApXmlGfcanpMS4=;
        b=fTfDGdb6GSBJDjlplOw1zxCusIkMhTHg6itmvzHBx/kPs4Y5brpFsGn44jJt4W0hWb
         40TDexbfFU5oC17sh/xWEzEwqkonBYeSUnQmhp64/RIHdbAqj7a9Varh1l8/AWVs+7LU
         yDLC7c8Z77KmK6ID1BsTlSY3IWeWIHgpmrZXZ7dGJCo2AF8XTcms4tHJkXMjDgmrG6Ea
         6bsP1EOWrex/CShkrs5uX0gfpEfMFpdYP8hLktaiMfCVBjpsff8btlqf2NzyUga6a3Yq
         kK1j12hAybkMPhqnYpvDSNC3A8DTuhFwZMqvvE99jY91zdRHRz5DIuCljv0dpHZyMwZ/
         R5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818376; x=1780423176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZqWf3aIh9jwoRDW7ej6OaYtUXPKSIApXmlGfcanpMS4=;
        b=XM9U+vjL5WAwAVgqSgAoMqNZ6F5ksma1hDLBaL7ulIXCB2LRwpEX9bZ/J17+qbCyuF
         MX2w02BVEoZYTxVWLlesd3MoJ55SdjN4tEHELIBhyKbV/nt+cwJ+Hr14KjonaOeRmprU
         vti/4fq0vQfBU5clSAo9dtArJ/S7PUb2KWvPp7mQRY+eSUTUhS7IdToZvjYVADhLjwSk
         zm//D6403UsFo4D/0EK1Emm1RzOky5GW9Sy74BZlvjyeVUTOqoxQl45IU9Q1ueD2quhT
         ziiGJ7ru2ObCylFjnPslJCJWZFE/+9t1mbxbq1E0z1qtA1xujlvnIBGxPiJDV0n/uLGf
         MCXw==
X-Forwarded-Encrypted: i=1; AFNElJ8WgRFN6Sdd84diEaLolfTu1/ekU3qbUtGIYFIeEHYdgd1VMRfQr/q6KUz3RfYx1VTWOuhO2gjHWg==@kvack.org
X-Gm-Message-State: AOJu0YxinWtJ0unK93h0cFt1PCrGj+sQNf/rXc05r6M/xoSDK4VmEavV
	hdvFZDvc+2NepQaCFDjsCb5ebcHZvQleR3bSTmshylCw6T4y1DdW/UNF0R4U1MIHc8L3tco3gA=
	=
X-Received: from edqv21.prod.google.com ([2002:aa7:d815:0:b0:67b:7c67:1fa3])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4348:b0:674:5b2c:d42c
 with SMTP id 4fb4d7f45d1cf-6889c406b3cmr9914567a12.3.1779818376178; Tue, 26
 May 2026 10:59:36 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:59 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3562; i=ardb@kernel.org;
 h=from:subject; bh=UEzDYeArIhcNSC2frPncytSQGHg972cpOAqaWBBxbIk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fnq9X+pUBo2wreeSOJ9dXiQeemVxk13k2m0KUYbfu
 fQXzIvuKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABPRzGRkWNkdW18r/eqia85v
 tUMNMXXf3V+K+oQl+nh/av96UvTZBEaGFv6biY3/V70q4frOvkbMYcPfR2skZm6tkJiyR9TynUs ZOwA=
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-29-ardb+git@google.com>
Subject: [PATCH v6 12/15] powerpc/code-patching: Avoid r/w mapping of the zero page
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9aqgcd8hp1rh41wsrcp1c9bc1d5f6849
X-Rspamd-Queue-Id: C9B1E100009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779818377-258225
X-HE-Meta: U2FsdGVkX18zSLkid1byfDNLXb2zF3RY5ZiLm1ESYttdcUOi4sX3Z5vDt9Epq6UkPQ/LXtkR8oa3OoaVGr18Xu4/+0m7qc2udt6n/Jssyaaqtlogj8fyheaLhuQ79pYcO4KPS9NeGW5SyWgp5ZjRIJRpHpCWnYv3cGURn3+49TzfFqqPgvkCv8LrHvqnct6/ZkV2Q8SPeFSGGvpf4m8pP08OQywllPhHUNdjfFRUpnmQ9LrKAHFjAXHTM6/sdMaFYKAsdy0WrnbwXwRYawJvGTn+llLadrwVHO+Juf/pAf5JgtAB/LOGwlo2r+tVvJD5U/b8AzhqCVUFqKviE/JhfhKosYXiwPuCBwZE/O5JERTUJ7jUGX933RyOnAVolgEhsgLw8YghgmLv3DxfZFul3l8oqvpznIV/FHPwHGT2yjJkqdRAC1kOgSMzzcjvPvI8yJeBrZMJWvW/bmlHOMYJV2FD2sDCdLSYmIQzbNyFAD34dsKax4BuqypUUYmXkzoV5GhgEZ6adfoaiXLZ+va5/BFf3dF6PCj70J6u9+R6r4qWtPvnheqm5/ioxzYFvVTY7+ejI1zvUOWh5GX8qghZPItzSc8C5QEayPV2lPKAGGYpKmtarIcTEsugFJzQELYgAp/k8Od38PzdlpbERIHzJFcDOq4UECTsPO23m8UD8yi31udU6BbUwehyIGGz4K+D9VEkB2NogL3iI+dqi8XFirl4ZlFhrjS8bpGIk31hNMVWnDx10319iB/Fa3eW7WhCZobj1tt8iySFvzyvKiwgfCT421v1y4gO6IWJCV4mt1vdEIRDHqf8zzhbL0MEYj3ksgPvX8cqXW5au0vR0lx52jYU4HSQV+Lz7kfdpGgv/psRq3RVAQ1hfdQT147AmKqYdRSI9z+C9s1b558wG2BF+s4ZzJg+CfEXxZYXUyoFhpZpg4dT4Sh+Yi5D1YEtdew8jAZIsWrjYvJt6nGxc+5
 5K3rmERG
 OEEnoDaeYFXdciu/7PQvsPGjYKfgWKAh90MWkYUNCHRZgDJoKVfLJXd7aRxnYcklzUWWdHUPAeYx11GpgfZ/fCW40bpxNtECeFvUzB8kBGQBwY79xac6PXkX0Sqe+6XqwWVqO9WYti3BOSwolwY4o+jnov9NVtXqbpOeVt4OGqXmthh9F2e4dAukd8eCWhkETiabUPioTRVhO0tTis9hA9QGUDgMQwCT6wSl4Rof7sl+hhqwdsr2biuTgbf57orYQF5uva9e3pWjrUJCpS31C6PUMc0sk84Qtf/5BmqaYgm6OVlh9bjaF1I6ywuy21MTXc3AUhg6JfN+E3NsHrRo+kVu0d+Y+amvucB5VJHirNKwtfrHkbckLjtbBkOtRpn24r8Dq/hCONb6JKXusn5et/f1Ek55CXtGu48Fwum3bwCT/QfD23cVAA3Is+B3xTvpo4mjiBq0x+vRRlAe0Ttd/aAfyG/OfCTmMWvdPgfm9tDHYkGz58MXdbu+AHDu3ahY2paf/BXJD0Rg5JmzZomeO6YoqhE3abxjdvgh1aF+hsyXxljyroxRDiAtHgJY3DxLdO9UTNdXEVpiVwx4owuEu2AVHGERXWGPT7PmmibfZ4GEeyLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The only remaining use of map_patch_area() is mapping the zero page, and
immediately unmapping it again so that the intermediate page table
levels are all guaranteed to be populated.

The use of the zero page here is completely arbitrary, and not harmful
per se, but currently, it creates a writable mapping, and does so in a
manner that requires that the empty_zero_page[] symbol is not
const-qualified.

Given that this is about to change, and that map_patch_area() now never
maps anything other than the zero page, let's simplify the code and
- remove the helpers and call [un]map_kernel_page() directly
- take the PA of empty_zero_page directly
- create a read-only temporary mapping.

This allows empty_zero_page[] to be repainted as const u8[] in a
subsequent patch, without making substantial changes to this code
patching logic.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Link: https://lore.kernel.org/all/20260520085423.485402-1-ardb@kernel.org/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/powerpc/lib/code-patching.c | 52 +-------------------
 1 file changed, 2 insertions(+), 50 deletions(-)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index f84e0337cc02..44ff9f684bef 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -60,9 +60,6 @@ struct patch_context {
 
 static DEFINE_PER_CPU(struct patch_context, cpu_patching_context);
 
-static int map_patch_area(void *addr, unsigned long text_poke_addr);
-static void unmap_patch_area(unsigned long addr);
-
 static bool mm_patch_enabled(void)
 {
 	return IS_ENABLED(CONFIG_SMP) && radix_enabled();
@@ -117,11 +114,11 @@ static int text_area_cpu_up(unsigned int cpu)
 
 	// Map/unmap the area to ensure all page tables are pre-allocated
 	addr = (unsigned long)area->addr;
-	err = map_patch_area(empty_zero_page, addr);
+	err = map_kernel_page(addr, __pa_symbol(empty_zero_page), PAGE_KERNEL_RO);
 	if (err)
 		return err;
 
-	unmap_patch_area(addr);
+	unmap_kernel_page(addr);
 
 	this_cpu_write(cpu_patching_context.area, area);
 	this_cpu_write(cpu_patching_context.addr, addr);
@@ -233,51 +230,6 @@ static unsigned long get_patch_pfn(void *addr)
 		return __pa_symbol(addr) >> PAGE_SHIFT;
 }
 
-/*
- * This can be called for kernel text or a module.
- */
-static int map_patch_area(void *addr, unsigned long text_poke_addr)
-{
-	unsigned long pfn = get_patch_pfn(addr);
-
-	return map_kernel_page(text_poke_addr, (pfn << PAGE_SHIFT), PAGE_KERNEL);
-}
-
-static void unmap_patch_area(unsigned long addr)
-{
-	pte_t *ptep;
-	pmd_t *pmdp;
-	pud_t *pudp;
-	p4d_t *p4dp;
-	pgd_t *pgdp;
-
-	pgdp = pgd_offset_k(addr);
-	if (WARN_ON(pgd_none(*pgdp)))
-		return;
-
-	p4dp = p4d_offset(pgdp, addr);
-	if (WARN_ON(p4d_none(*p4dp)))
-		return;
-
-	pudp = pud_offset(p4dp, addr);
-	if (WARN_ON(pud_none(*pudp)))
-		return;
-
-	pmdp = pmd_offset(pudp, addr);
-	if (WARN_ON(pmd_none(*pmdp)))
-		return;
-
-	ptep = pte_offset_kernel(pmdp, addr);
-	if (WARN_ON(pte_none(*ptep)))
-		return;
-
-	/*
-	 * In hash, pte_clear flushes the tlb, in radix, we have to
-	 */
-	pte_clear(&init_mm, addr, ptep);
-	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
-}
-
 static int __do_patch_mem_mm(void *addr, unsigned long val, bool is_dword)
 {
 	int err;
-- 
2.54.0.794.g4f17f83d09-goog



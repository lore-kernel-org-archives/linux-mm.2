Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D45CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F516B008C; Tue, 26 May 2026 13:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09056B0092; Tue, 26 May 2026 13:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9276B0093; Tue, 26 May 2026 13:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA9D6B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 654C01C039C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:26 +0000 (UTC)
X-FDA: 84810333132.25.D98D132
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 800A3180004
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i24lqB9T;
	spf=pass (imf24.hostedemail.com: domain of 3et8VaggKCOcJaMK+PRcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3et8VaggKCOcJaMK+PRcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yyd3IudRVUHVyeM6Sgx7GyCvuriuV9w8zEGgNDuF+gw=;
	b=LOWsugWhA0O+IQg02JQo1UzAQlVJCZAN9WB6lpjQVEWcOI+3w9QTjh7P4v4rjq7iIX+ZqZ
	IOBaqt4RTKttqWG6NW8SDyavopBZWE5XquRnmIQqge3S/E6HuvE3jkgYweCH0CUs5OH5uk
	7rKTCcbJku89ahcDSES/getSmUUr8s4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818364; a=rsa-sha256;
	cv=none;
	b=Go7c6UYiKOGJjE5NI5WDBEtwe1O51+Ipsumxm9T3pKvqC79wHp0GZeo3jcff0grPZS32Yb
	gnMUwEnjuFs171SA8Phvlcq6lHWgc4u6Zt3UT9rjMt5AjXPPoyt8WkHWE3FZG6cn8ldCiX
	eh9fKw73HzpCCiMGyiEjWuv0aofRhgc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i24lqB9T;
	spf=pass (imf24.hostedemail.com: domain of 3et8VaggKCOcJaMK+PRcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3et8VaggKCOcJaMK+PRcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4411a2c034fso9938160f8f.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818363; x=1780423163; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yyd3IudRVUHVyeM6Sgx7GyCvuriuV9w8zEGgNDuF+gw=;
        b=i24lqB9TZJhu0MVeZCoJ3oXGWaT+NXK1LkNitEipoaoAnh7El00LhCD5k7tRtiYQmN
         S3i660Mj8pYSEDs4gs0se0Gcocm/JRzsQne5EEBmT9Kh/hvvp1GYVpV/SE/Z1jvlcYQI
         eQgld3d2C4GzQ/IeRqPfInSLPQ1RMjObk7CCxXeAO3K9Eiwu+9tY4DbPW6iGP15HNo/H
         mDxsXe0lQyGZ2kcAwIueaQbMZzGN+yKya4+JPut/66kq+dCbW4nKxvWV6NwIF/tWzOXC
         xCIzOUopWWnLjSrUzMFg9TCvBQcQ3OYFyM6APkFt1OZqrqNCflrbFWM3VfoJTe5fKorV
         4acg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818363; x=1780423163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yyd3IudRVUHVyeM6Sgx7GyCvuriuV9w8zEGgNDuF+gw=;
        b=lFWugI8kg+sHA/uE8O28D2+TGWskNX3nYLYx4p36ISNKh9S9ZkXqzrw5hAuTr3AfiE
         i+KWKwtIhJ73q7J5uzT9dJvs3KmUtRcdl3Fhb+HJU6/JNXZztJThThpSn4OACknV2l/W
         j3wtZhmELbRlBS1v6dqtT26/h9jzqMOQjIo8PpfK42RlYCANhWdOs+s6s8X6YYPUIhcD
         QOWYcSDU+OoKwB8x8wJtxjLZUk2yoM4ctaqpVsbFpkBkm/1HDwV4BrAC1jPoWNA2Fb9y
         T+ZopByitsYv4p5y4wSOiu1zewdkT+wL3dMW3K+MXQqhlNqnwHRepW7/KHB48VOX9eGc
         i94g==
X-Forwarded-Encrypted: i=1; AFNElJ9Ymh/gvf+CvscSyauhPA0I4Cw43PYS0jJsUBl1IR3+c3qwR7kQiVnc3Ki51wrTiXI3X+ZiKF5ahQ==@kvack.org
X-Gm-Message-State: AOJu0YyIBtFxOchU71vdSfyugLYA67LzNp/rAqLv0vKLKcA3Hfro4t8i
	xk5XDCd20aJBXoljoIRoWo66UtGa8ezeKr0z3f1KBiI6HEUOTjZE9dzwvZts23d4MGApiV377w=
	=
X-Received: from wrwy1.prod.google.com ([2002:a05:6000:1081:b0:44c:3df5:500e])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4917:b0:43d:dd:8ca4
 with SMTP id ffacd0b85a97d-45eb36ab5c9mr33376312f8f.14.1779818362409; Tue, 26
 May 2026 10:59:22 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:49 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3439; i=ardb@kernel.org;
 h=from:subject; bh=vIIm6COov+NQzX2nIS8cvw7su4mTKmzskcBcPmulqnI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fpS02zOfRUy3961i3vC1b7n+Evm+/R38NgG/DlrXZ
 Qm+/ezWUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACYyZREjw8TXaqzPetiWhH24
 cp5p0vNHbzoXsV7Pm+XWwVYqvcHR9SUjw6wVekazft8qKTufNy9Z5jRL5boX02v9d1fyMKbXF/Q c4gAA
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-19-ardb+git@google.com>
Subject: [PATCH v6 02/15] arm64: mm: Drop redundant pgd_t* argument from map_mem()
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 800A3180004
X-Stat-Signature: moq9ugazjaxxk44nkdohppxuecqsmx86
X-Rspamd-Server: rspam06
X-HE-Tag: 1779818364-892721
X-HE-Meta: U2FsdGVkX18cprIF8B64LZYB5o8t1GPu06E7uEOHL75YR5T5mzsiTBWSraLzgBHh0jtFxmOt8iVxR6y25cspK71JwedGxs0uafDXTU8sdr+C1UcCQ66FOQHISmLc+QAQnqp3u/Nj72+R/97IQ9QgSbo2yx54qk1j8JoA3/3If21+9g+xLAD0I7bEmACJsuqg54FY605I+qjwLLhC9DKGQl3bDI1i7MVaKU9qRLPLmnv1tV+Ftzj2zrgjbVjz3WcSylf3IE4x2rRNTgOXfLa8KnAfjzvljt2SpjssKRr5UvalYzitiDMiLvae0MbgWXVmB9YrKmgggUumKqghxJIEjyNHvhPTraDv99Pp3HMuijqDrgy1xJi92G4C3prYNt5M99k3bHSQDxmrmqTBzQjtgLglADWMiaeS2ZR7nBXZt9y+JaLAnYl6+wEhXQv2S1iknQuZ29384xQh4UFooS0usW8YL0App1mf5tNiy/cQVmnWmER45lmUyANAJzYWWDauz3MeSeRqbQunjB0s4x/keF9gpq8kLw6e9hLxI2z+cn/DU4LjKIcuKF7c/wiDeYCRFzkDImLB/5alTll/zP+9voorGU7cPk8ngrvhKjuOMBHiOix1LuZ141viUz8CZSjlZkeX+09t9xyGjw/t4tt4MKxcsgbgKxwCootG/KRhOnb76bblf0q0KF6msfTYEe/N3wlRelTg+rfagkFfeeeN4YW50EeAjXixHNkXZw7K0OMt9zePi0hKhFBTdGl3TCYG+aKUlAPerGcJataMb4Bo/0wkHtTuGlHQA58wwxHH1zginRj17NC3V/rh8K+PX9rjhdS7JkyCd4BTm1oseUk3nAyz8C4f4/xFExI2Yp8ZCLPnGM9u0O6MiPUVIIoPj8IsQmzlSME1D0yTMpR3PoTqLAS2w1BEgspyOHFmwDo/oDgLLBOiGPKa9JsdIoxgfEynT0Hw93tuNa/qhUt+Hbv
 j318gh2w
 T4mXE8M2Tchvb82g9SVwUhxRDf69iMGnSmmcF59JjaUdL/l+zSdo8U26go55IRdnBFfSHXWQgicvv4g3Ih2LiDmHFe+2fUVmxr20bgqZJ+aP6FNR+LqeV7LcM43E4c6tcKBVf5kj2fuVS9o4UA+GiK0puUD6ggaaXk/GMYe3tE9TGSFa92W30va6pOkPmkYtO6QtOSw+Fu1g4nlTWKiCJjYATdO4wN6XBP6F6KCEK8//GDT78CD//PMJACtlSXJ71UN+Eiws7m+i/M74bMwdrGH2KDVIu2B9aXw/z/K5GTWuHXT7+T5KlK+2Gzs3rNiEFOcC6p8MHYYvy/OA0V1ZReE7v8XJcq9NVyS3FMbT60G9lEJyRCpfTdIrhe08e7aMDgkaOeQqQCYe/SvUSVFFpK1nhMLsLBFat37SbDHB3CAHoxeSTqxRMBks1w+ZNeg3rwQvv+fhWiowYY14QYbi9AgvEeW4qfQZavHrseFJv7lwVQOfdXR8Ub7KcH1JIOjD62KQL6FKdk2ElGwuEzheRVNiNbsujMlfCnKyaK8ir7xuYHwJW+YkaTY2DlKmSW70SmJZHN+gR/Nl2vZeET2i8B2gCEwaFH/fPkwfeN5jpQ3mMu1A0josl5FSNBKeCbEEHHZ/JDdFtq7XduIrfqJK0kADL0LNT7fc7taiaG4E4rtHhuuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

__map_memblock() and map_mem() always operate on swapper_pg_dir, so
there is no need to pass around a pgd_t pointer between them.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 25 ++++++++++----------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 112fa4a3b0eb..aa0e2c6435f7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1035,11 +1035,11 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 	flush_tlb_kernel_range(virt, virt + size);
 }
 
-static void __init __map_memblock(pgd_t *pgdp, phys_addr_t start,
-				  phys_addr_t end, pgprot_t prot, int flags)
+static void __init __map_memblock(phys_addr_t start, phys_addr_t end,
+				  pgprot_t prot, int flags)
 {
-	early_create_pgd_mapping(pgdp, start, __phys_to_virt(start), end - start,
-				 prot, early_pgtable_alloc, flags);
+	early_create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
+				 end - start, prot, early_pgtable_alloc, flags);
 }
 
 void __init mark_linear_text_alias_ro(void)
@@ -1087,13 +1087,13 @@ static phys_addr_t __init arm64_kfence_alloc_pool(void)
 	return kfence_pool;
 }
 
-static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp)
+static void __init arm64_kfence_map_pool(phys_addr_t kfence_pool)
 {
 	if (!kfence_pool)
 		return;
 
 	/* KFENCE pool needs page-level mapping. */
-	__map_memblock(pgdp, kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
+	__map_memblock(kfence_pool, kfence_pool + KFENCE_POOL_SIZE,
 			pgprot_tagged(PAGE_KERNEL),
 			NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kfence_pool, KFENCE_POOL_SIZE);
@@ -1129,11 +1129,11 @@ bool arch_kfence_init_pool(void)
 #else /* CONFIG_KFENCE */
 
 static inline phys_addr_t arm64_kfence_alloc_pool(void) { return 0; }
-static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) { }
+static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool) { }
 
 #endif /* CONFIG_KFENCE */
 
-static void __init map_mem(pgd_t *pgdp)
+static void __init map_mem(void)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
 	phys_addr_t kernel_start = __pa_symbol(_text);
@@ -1178,7 +1178,7 @@ static void __init map_mem(pgd_t *pgdp)
 		 * if MTE is present. Otherwise, it has the same attributes as
 		 * PAGE_KERNEL.
 		 */
-		__map_memblock(pgdp, start, end, pgprot_tagged(PAGE_KERNEL),
+		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
 
@@ -1192,10 +1192,9 @@ static void __init map_mem(pgd_t *pgdp)
 	 * Note that contiguous mappings cannot be remapped in this way,
 	 * so we should avoid them here.
 	 */
-	__map_memblock(pgdp, kernel_start, kernel_end,
-		       PAGE_KERNEL, NO_CONT_MAPPINGS);
+	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
-	arm64_kfence_map_pool(early_kfence_pool, pgdp);
+	arm64_kfence_map_pool(early_kfence_pool);
 }
 
 void mark_rodata_ro(void)
@@ -1417,7 +1416,7 @@ static void __init create_idmap(void)
 
 void __init paging_init(void)
 {
-	map_mem(swapper_pg_dir);
+	map_mem();
 
 	memblock_allow_resize();
 
-- 
2.54.0.794.g4f17f83d09-goog



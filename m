Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB0F606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Td7WQqa3
Received: by kanga.kvack.org (Postfix)
	id F31B86B05F1; Thu, 26 Nov 2026 06:20:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F093B6B05F2; Thu, 26 Nov 2026 06:20:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F206B05F3; Thu, 26 Nov 2026 06:20:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5FA6B05F1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:20:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D94AE1C4611
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:59 +0000 (UTC)
X-FDA: 85477025718.27.878F378
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id AC614140005
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:19:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Td7WQqa3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691997;
	b=AOt9rNOJcw1RKU+7P8CcZ1wY0qpji0dQW3yH79Cwit7UQObL/SRSeTnG3VcBMql3/Db5YR
	4GzE5ph/3Fyo0E5ohOpKhXGs2NSN2cx1KRZJ4aZlJuWfUUJOcj5Ewg28/MnUe2G4+d7Gcr
	8CS2NOGimHZvgscOYPIkjVAqulJHPIU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjHPKIVW3NJ7hgK/PWATF9K0DetPjPAzIieyOSxd4IY=;
	b=01adVuhf/uINIWwjtWi/V3i5unyS43o/n8jZejS9I7Xcn5fNpNT0kMYs5SGf0lNmJ7WqyG
	QBMjjiXQGU+pLms6ZzPoBO601mqPvCKpYCVS1OqmYXLGEzOBmKs565XNE/donic6+amoeq
	Sxmo5Btmwb4IKxvoNZDyz+GaqjgClaM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Td7WQqa3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 035DF41AE8;
	Thu, 26 Nov 2026 11:19:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD1F1F000C0;
	Thu, 26 Nov 2026 11:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691996;
	bh=QjHPKIVW3NJ7hgK/PWATF9K0DetPjPAzIieyOSxd4IY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Td7WQqa3c7ClvHl+OoEBfCYgP/n9WHRuAztnd/C+dWFx/SKyzf+rot9DehsBhdEMR
	 XhXHzNONCqJnzktHcCzhsfRDZommDkcJRNBgrcK5izNOUg12XwVVEbLxKxPwcdg96C
	 Xl3Viw8y3ZSm0/uWV18pSGWunvgmjwPqYGaPkfo+V0AWmO70GciFkYKDvcqzBBfPed
	 ctZTYZalj6ONgdxp/Rpub5hd6TXezAF/ggB1Nb4/cI+LVmxeD4StvrlxIEMNlT+TVE
	 oOptv6/WnyWRCi5WfRuMwlrbjSFlyQfXsQ/Wxn6Hzybs66OymbziDAuPFND4Y1ib3g
	 lTQWRh5WHeHKQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:47 +0200
Subject: [PATCH RFC v2 34/54] LoongArch: stop pretending LoongArch supports
 set_direct_map APIs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-34-723f1e33c3d8@kernel.org>
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
X-Stat-Signature: bt5r1m133cm95pjy1xazk1zzzuedfrzp
X-Rspamd-Queue-Id: AC614140005
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691997-847990
X-HE-Meta: U2FsdGVkX19COSHQ3hodZYuruhdAc66Sib43AJzw2crFPKYDtcNcFUoNInIJJh5cjq1ngQFaTCr+ZG1/FEhugua4PbTvMEg9Wykf3sovWIYUqUeF6hjOq47VT6e0vKsO86wCsPdQnU4N4cocyvugGGDbQi2yyXSckDpg/tdHeiyCeYEQmFhivddOAz3jbshYm6NLKvOXiUS3KHVUXNp1XIxoSLRoBpE4WpN7J4vriqtfVFWnHPpMPFrb65cd7YeUyX2vdZhJ9NEevx39l9Ht6UkMBLcol+wEKGJBxwknfmO4RLeYfAQKT84Aumc2MU4hFPxSvUjklvFqeFXV80khKNTUr2k69CV1deNlkVAXLCjeA5+n7VVChB7YReOyu8OQgp03ZIkXrh8Hj3dkqIWTzYRO+k3Q+tCjAqidaQR4w22OMipFCeYLyE/8cgk7C8C/aBB04lHUqdwzH6oQOWiFDe8EqD1ELIJhZwidau0/p6Li4lKPYNejP8lJdSxpQ3gQCA7CRHkHS1X/mSFXs5G5//HYYAILjMVdaC+VS7QVxq8E66EDmCo/RT3Ly7EP89dUREmxTzqAupNDZ5FfQLGao63TqkVtPT2fIbdL2+S4X1+7ZOgxCijU3Iv395ss17eeDakarCHsMna+ncdYWd2g3XMGUYV8SStD+ybIH/20DD/Xdx8lsATgCpWRL7K1UxoNVEsWuxlJ4xriDQQ/XO6oB2VB7IcrR+dMDAhxcRI7RZH2P9es0Kq7S+/hYTxCMKvujIkxhcpkSAg8TislUKJRD9TIGwQ8jmFE3y8S9LUCmUNVdoSMc5/eFvogoHs7gdsnMOjzdKD4XMSduCX+WeQY+cYMDQFtXOI6ZafEZAXij235nr1fLKzRI/nj9RjZq+QS1TQ2aji9eHXv/OY8Xv9qDYd1NcbrPbhRJAb0XwmZJSK8IEyffW0BsnmRMZG+JQdAgY6rN8pTlsviHOCWvyD
 W4Lh60F9
 hLF+/7D9CvTAERhkjV9ZhqGTi9v5/diNL1iRHWZdV41xlJyK1qKokOLqzYqP1aT1bc+MW8lnx7MZr2T1J93gX1yp33yqNYoaPbg9obDu9kTHREPfYZJfzIh4GPTJd+stA05X4FxrCjw9d9bEbK7kwTrJuzgk3HBasfUppmChbaNE8UJrYyOPDHyCL+81oimkflhUKKhTRvmyxO1YaQufJG1axcpWxEcwgrVnnrKt8smPaXnk09XuBtl0t0lCWNtWAKR4OBb30yxSn2y3yxJ8V4LlpdshLgjQSEtaHsCEUvjhNMvMzw252dZfOc1a4WftGq829Sw4rA1ahYb/TlaFBEEHgMTEzA4QZVp6WMITI6/vGLj6P2mJ5k4/kDkIZiw7D0FZrsR9bsf5Cj09bl1BYwe/EXzh8AhNuswj/DrfmoicvxDwFMmGtV87WjxA/He/1h7E3Ih+kze5mPaCPoDwJiqUffYZWdhX33XYv+3hfyoTwACCZNREmybB5TbW646EuFEHNr+f75R3AsGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

LoongArch selects ARCH_HAS_SET_DIRECT_MAP and implements set_direct_map*()
APIs to allow coexistence of hibernation with KFENCE, see
commit f04de6d8f252 ("LoongArch: Add ARCH_HAS_SET_DIRECT_MAP support").

However, LoongArch does not have page tables for its direct map to begin
with. It maps the physical memory with a hardware window, so there is no
way to change the permissions of an individual page there.

Protection of KFENCE pages is handled outside the direct map: they are
mapped in the dedicated address space area and their virtual address is
explicitly set with set_page_address() to keep page_address() working for
those pages.

Selecting ARCH_HAS_SET_DIRECT_MAP enables secretmem on LoongArch, although
without the actual ability to modify the direct map, secretmem becomes a
limited memfd and does not provide the security it promises.

After the rework of the temporary mappings in the hibernation code [1],
there is no need for LoongArch to pretend it supports direct map
operations.

Remove the set_direct_map*() implementation and stop enabling
ARCH_HAS_SET_DIRECT_MAP.

Removing support for ARCH_HAS_SET_DIRECT_MAP effectively disables
secretmem, and memfd_secret() returns -ENOSYS on LoongArch.

[1] https://lore.kernel.org/all/20260917-hibernation-v1-4-7f7dfae3dbe0@kernel.org

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/loongarch/Kconfig                  |  1 -
 arch/loongarch/include/asm/set_memory.h |  4 ---
 arch/loongarch/mm/pageattr.c            | 60 ---------------------------------
 3 files changed, 65 deletions(-)

diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
index b5ed4881d3c0..bad699e2847f 100644
--- a/arch/loongarch/Kconfig
+++ b/arch/loongarch/Kconfig
@@ -27,7 +27,6 @@ config LOONGARCH
 	select ARCH_HAS_PREEMPT_LAZY
 	select ARCH_HAS_PTE_SPECIAL if 64BIT
 	select ARCH_HAS_SET_MEMORY
-	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UBSAN
 	select ARCH_HAS_VDSO_ARCH_DATA
diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/include/asm/set_memory.h
index 4bb01172fbc2..64c7f942e8ec 100644
--- a/arch/loongarch/include/asm/set_memory.h
+++ b/arch/loongarch/include/asm/set_memory.h
@@ -14,8 +14,4 @@ int set_memory_nx(unsigned long addr, int numpages);
 int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 
-bool kernel_page_present(struct page *page);
-int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
-
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index a728db40f9e0..7283059d6e1f 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -156,63 +156,3 @@ int set_memory_rw(unsigned long addr, int numpages)
 
 	return __set_memory(addr, numpages, __pgprot(_PAGE_WRITE | _PAGE_DIRTY), __pgprot(0));
 }
-
-bool kernel_page_present(struct page *page)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long addr = (unsigned long)page_address(page);
-
-	if (addr < vm_map_base)
-		return true;
-
-	pgd = pgd_offset_k(addr);
-	if (pgd_none(pgdp_get(pgd)))
-		return false;
-	if (pgd_leaf(pgdp_get(pgd)))
-		return true;
-
-	p4d = p4d_offset(pgd, addr);
-	if (p4d_none(p4dp_get(p4d)))
-		return false;
-	if (p4d_leaf(p4dp_get(p4d)))
-		return true;
-
-	pud = pud_offset(p4d, addr);
-	if (pud_none(pudp_get(pud)))
-		return false;
-	if (pud_leaf(pudp_get(pud)))
-		return true;
-
-	pmd = pmd_offset(pud, addr);
-	if (pmd_none(pmdp_get(pmd)))
-		return false;
-	if (pmd_leaf(pmdp_get(pmd)))
-		return true;
-
-	pte = pte_offset_kernel(pmd, addr);
-	return pte_present(ptep_get(pte));
-}
-
-int set_direct_map_default_noflush(struct page *page, unsigned int nr)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-
-	if (addr < vm_map_base)
-		return 0;
-
-	return __set_memory(addr, nr, PAGE_KERNEL, __pgprot(0));
-}
-
-int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-
-	if (addr < vm_map_base)
-		return 0;
-
-	return __set_memory(addr, nr, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
-}

-- 
2.53.0



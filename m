Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47FEC5DF97
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 11:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FF6F6B009D; Sun, 23 Aug 2026 07:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AEF46B009F; Sun, 23 Aug 2026 07:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F9E6B00A0; Sun, 23 Aug 2026 07:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2905A6B009D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:46:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6094802D4
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:46:39 +0000 (UTC)
X-FDA: 85132356918.04.4425C77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0353240002
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:46:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YsjqYLR2;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787485598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4tutYZL3rGYJJvWCursgBu/wlu5o4SWbU3bprQruhA=;
	b=Nmgs5csdqH+d5qSro5SGGMU3m/YZS5O69kyfowmAJAtTuR4LhrUKo2S+0fVJxTMsF3fcV9
	acBBGUgyzpi3v+vD6AZwEvu7cQ+l0JFLuFoVwB91Npc+U4T9WLfVGWJhozxXUUj7UvcXKa
	9dmTNe4P1tZYi6ZKtr917Kvc4IZ2fBs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YsjqYLR2;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787485598;
	b=uDU4raMMDW6/VIj+IcFCMcSXKCPvrV9hEmOO/cMVK4KO0NeTyYUliHUGX/mWeIWIJuyywF
	ouxKIJoJBvoREOIAm3SJqpVYGDDo5x9atOwLBjY9lF+uOuHs1gXz5Dlh3fjga3I6pXuTCZ
	L0ulI04FL0VhKjPdUTYi8oGhSQ4xWSY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F339600C8;
	Sun, 23 Aug 2026 11:46:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9916A1F00A3A;
	Sun, 23 Aug 2026 11:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787485597;
	bh=Y4tutYZL3rGYJJvWCursgBu/wlu5o4SWbU3bprQruhA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YsjqYLR27iduvSJJYP3R0Ezqu87cSSsKoRS1CScIHvvJv/J1F1beP/IJuAXqNiylv
	 ykJTLr6zzWCD3cF5BVwxBxDsZ49T0vRDLnEiH/1UWHmv2o4d2Mb8Bntioxo83Tl9FE
	 OlmEhv3RdkZ8XSVqEeEeRIAfkki4vdEtVlwHDsrMCaJoGG8/SI99NlSjWZWMp57fHd
	 na9y5aKiXZD0i4vZ30jaMnlS+yxc6Isvdm2QBAQzTRPhsHkWKe2Z8oK9PEhCRvKUZl
	 l8vWCK8NPGvmmwiEZoeQ+itxDrjG56hIOSZGMWwec0HNGU9eUFHaXpGnsNs3p5SS82
	 EB6gGyMcAlTPg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 14:46:12 +0300
Subject: [PATCH v2 1/6] set_memory: add number of pages parameter to
 set_direct_map APIs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-execmem-set-vm-perms-v0-2-v2-1-b013a37d84b3@kernel.org>
References: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
In-Reply-To: <20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Pavel Machek <pavel@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>, 
 Will Deacon <will@kernel.org>, x86@kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 loongarch@lists.linux.dev
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0353240002
X-Stat-Signature: 8ixqa6r5iym4uzagb1stn7z8gw73b47i
X-Rspam-User: 
X-HE-Tag: 1787485597-175991
X-HE-Meta: U2FsdGVkX18LdjYQkTSP7O0+cjgMwrdkmBWIVGvtvYgjFgLGvTewghBLgSUFHTlweCpY0+NHDqWsuw+wsTS9/0rGNqWCUEe1rkk0ErycXd8W9jgMyPqOL4Q5UOOqZef0QrsuLKA+OrvSDOkfkpbNMHkyo8KRP5MbYcJSGP2wa3K0oZgU+baxhsxY20rExm4AhbBmLRUnWnK+Vw42Pk7OvS25w4FWRyiaItaIQ3qqGteDikAee/A5jQ1cfAhKmjj3CkLf2YGY1/UrBqYitgCkuek+HA0X4YLJCPaWQkU3dFm/Gbo0rOPR2vOTBoN/nRqFR330Y14WlRuqsJflHiNhq+e7A2zgBUih3hhfSxo1ewDRU4f8t99W2UvMrGqbVWoKya35vr7zgB30hCDup9utxRsoHhGAnDpnI04oLEBheKXAwLx3rLTW5PLy3XjOo/wUhVzEljhW6XYJ+SymlAiw0iq1C2e/VpmF/9dFJtzNNcZqnf3TDjyMKHMZ4IHvho8Wo55Mz5S+9Q62UvL3E6RPpGOxdhgFoosLdyPTWcKfaxWggX88qw0hnoLO6YilkyWTWjC3bGw6s5k32OBC1BmU8nxWXA81gIwrtAwtwKTBoK1mvfctz4aTvlOIkPkLo5k5GhuakeNOgkudNWbKsKSuvMn+GLvnDyXpUwlK9aAxLTdmyt9o0NRf4+8vhQEQVLEdixXOtOjwr/iLz8GKsPKWkx8t7Y7q3jHo08+JdKAGz14x8Zz/OUV+PbhdnIiD+M6vMMWs9LFjybWoJaFrWlEEzwmkZ5N1UwpjAF8gm7tmKafd9oj22+LKQURWKzMqfRRI/KWGX2DNWhWxmQVzGrLMdyUKv3xVqKNuVuIwmCOukPvfph10x8mfwLyb5SSIULswqGwVlfO2+udLvram8xOI9oWRdTJNXm9JN8hZhcIzsW9fCJrSycEOL4/UKmQOTJ+kiQZQ05fp5+A3vYttJcx
 2mK/Qz/X
 QtMniz11evOMpLcgOOgET2wEkkekS9gN/4f44Ycyju9ePEICeLU+A/Nx8irpokg3n4bpq/cSiqaBkuruXWawwELHH/DubsWi1SLvKKbw9BcYC95XynCN6NLN5wX44GdCYyNBBjjl+NKW5MLLXKYSZCY4K/kXxZynZYIGe5ZWvQ2x/7bOJFlCmDOawwvsHAh6d6M1lusLc/tK3ysgiFPu7hyKz//jSydYu0vxznBp4O5sFXSVy/0NMquMU1dFPaLHK4PigTOY6QMVDJRalYw8cKTva8Y3z58G1HGUb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When set_direct_map APIs were introduced by the commit d253ca0c3865
("x86/mm/cpa: Add set_direct_map_*() functions") the single page
parameter made sense because the initial callers (vmalloc and
hibernation) had sets of unsorted struct pages that required changes of
their mappings in the direct map.

Since there is an increasing demand for direct map manipulation and it
is also desirable to be able to update larger physically contiguous
mappings, for example an entire large folio, extend set_direct_map APIs
to receive number of pages parameter.

As there is still only a handful of callers, change the existing
functions directly and update all the call sites rather than adding
wrappers for single page case.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/include/asm/set_memory.h     | 4 ++--
 arch/arm64/mm/pageattr.c                | 8 ++++----
 arch/loongarch/include/asm/set_memory.h | 4 ++--
 arch/loongarch/mm/pageattr.c            | 8 ++++----
 arch/riscv/include/asm/set_memory.h     | 4 ++--
 arch/riscv/mm/pageattr.c                | 8 ++++----
 arch/s390/include/asm/set_memory.h      | 4 ++--
 arch/s390/mm/pageattr.c                 | 8 ++++----
 arch/x86/include/asm/set_memory.h       | 4 ++--
 arch/x86/mm/pat/set_memory.c            | 8 ++++----
 include/linux/set_memory.h              | 6 ++++--
 kernel/power/snapshot.c                 | 4 ++--
 mm/secretmem.c                          | 6 +++---
 mm/vmalloc.c                            | 5 +++--
 14 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..b07fd4e026ea 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -11,8 +11,8 @@ bool can_set_direct_map(void);
 
 int set_memory_valid(unsigned long addr, int numpages, int enable);
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
+int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..db8d60a84d14 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -251,7 +251,7 @@ int set_memory_valid(unsigned long addr, int numpages, int enable)
 					__pgprot(PTE_PRESENT_VALID_KERNEL));
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages)
 {
 	pgprot_t clear_mask = __pgprot(PTE_PRESENT_VALID_KERNEL);
 	pgprot_t set_mask = __pgprot(PTE_PRESENT_INVALID);
@@ -260,10 +260,10 @@ int set_direct_map_invalid_noflush(struct page *page)
 		return 0;
 
 	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE, set_mask, clear_mask);
+				 PAGE_SIZE * numpages, set_mask, clear_mask);
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int numpages)
 {
 	pgprot_t set_mask = __pgprot(PTE_PRESENT_VALID_KERNEL | PTE_WRITE);
 	pgprot_t clear_mask = __pgprot(PTE_PRESENT_INVALID | PTE_RDONLY);
@@ -272,7 +272,7 @@ int set_direct_map_default_noflush(struct page *page)
 		return 0;
 
 	return update_range_prot((unsigned long)page_address(page),
-				 PAGE_SIZE, set_mask, clear_mask);
+				 PAGE_SIZE * numpages, set_mask, clear_mask);
 }
 
 static int __set_memory_enc_dec(unsigned long addr,
diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/include/asm/set_memory.h
index 55dfaefd02c8..563aab92896e 100644
--- a/arch/loongarch/include/asm/set_memory.h
+++ b/arch/loongarch/include/asm/set_memory.h
@@ -15,8 +15,8 @@ int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
 
 bool kernel_page_present(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
-int set_direct_map_invalid_noflush(struct page *page);
+int set_direct_map_default_noflush(struct page *page, unsigned int nr);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index 614ccc7afccb..43ad2a104f19 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -198,24 +198,24 @@ bool kernel_page_present(struct page *page)
 	return pte_present(ptep_get(pte));
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, 1, PAGE_KERNEL, __pgprot(0));
+	return __set_memory(addr, nr, PAGE_KERNEL, __pgprot(0));
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
 	unsigned long addr = (unsigned long)page_address(page);
 
 	if (addr < vm_map_base)
 		return 0;
 
-	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
+	return __set_memory(addr, nr, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm/set_memory.h
index ef59e1716a2c..db1d0ed82b69 100644
--- a/arch/riscv/include/asm/set_memory.h
+++ b/arch/riscv/include/asm/set_memory.h
@@ -40,8 +40,8 @@ static inline int set_kernel_memory(char *startp, char *endp,
 }
 #endif
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
+int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 3f76db3d2769..20ef95b1d0c3 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -374,15 +374,15 @@ int set_memory_nx(unsigned long addr, int numpages)
 	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_EXEC));
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
-	return __set_memory((unsigned long)page_address(page), 1,
+	return __set_memory((unsigned long)page_address(page), nr,
 			    __pgprot(0), __pgprot(_PAGE_PRESENT));
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
-	return __set_memory((unsigned long)page_address(page), 1,
+	return __set_memory((unsigned long)page_address(page), nr,
 			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
 }
 
diff --git a/arch/s390/include/asm/set_memory.h b/arch/s390/include/asm/set_memory.h
index 94092f4ae764..6b0aa9147ed8 100644
--- a/arch/s390/include/asm/set_memory.h
+++ b/arch/s390/include/asm/set_memory.h
@@ -60,8 +60,8 @@ __SET_MEMORY_FUNC(set_memory_rox, SET_MEMORY_RO | SET_MEMORY_X)
 __SET_MEMORY_FUNC(set_memory_rwnx, SET_MEMORY_RW | SET_MEMORY_NX)
 __SET_MEMORY_FUNC(set_memory_4k, SET_MEMORY_4K)
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
+int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index e6f788696dd1..02d992b251cb 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -387,14 +387,14 @@ int __set_memory(unsigned long addr, unsigned long numpages, unsigned long flags
 	return rc;
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
-	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_INV);
+	return __set_memory((unsigned long)page_to_virt(page), nr, SET_MEMORY_INV);
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
-	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_DEF);
+	return __set_memory((unsigned long)page_to_virt(page), nr, SET_MEMORY_DEF);
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 4362c26aa992..0c4235d159f4 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -86,8 +86,8 @@ int set_pages_wb(struct page *page, int numpages);
 int set_pages_ro(struct page *page, int numpages);
 int set_pages_rw(struct page *page, int numpages);
 
-int set_direct_map_invalid_noflush(struct page *page);
-int set_direct_map_default_noflush(struct page *page);
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
+int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 422ce7fba00c..9022354e26e9 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2673,14 +2673,14 @@ static int __set_pages_np(struct page *page, int numpages)
 	return __change_page_attr_set_clr(&cpa, 1);
 }
 
-int set_direct_map_invalid_noflush(struct page *page)
+int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
-	return __set_pages_np(page, 1);
+	return __set_pages_np(page, nr);
 }
 
-int set_direct_map_default_noflush(struct page *page)
+int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
-	return __set_pages_p(page, 1);
+	return __set_pages_p(page, nr);
 }
 
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 3030d9245f5a..0b77f1d7d8b9 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -25,11 +25,13 @@ static inline int set_memory_rox(unsigned long addr, int numpages)
 #endif
 
 #ifndef CONFIG_ARCH_HAS_SET_DIRECT_MAP
-static inline int set_direct_map_invalid_noflush(struct page *page)
+static inline int set_direct_map_invalid_noflush(struct page *page,
+						 unsigned int nr)
 {
 	return 0;
 }
-static inline int set_direct_map_default_noflush(struct page *page)
+static inline int set_direct_map_default_noflush(struct page *page,
+						 unsigned int nr)
 {
 	return 0;
 }
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d933b5b2c05d..89a8894dd260 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -88,7 +88,7 @@ static inline int hibernate_restore_unprotect_page(void *page_address) {return 0
 static inline void hibernate_map_page(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
-		int ret = set_direct_map_default_noflush(page);
+		int ret = set_direct_map_default_noflush(page, 1);
 
 		if (ret)
 			pr_warn_once("Failed to remap page\n");
@@ -101,7 +101,7 @@ static inline void hibernate_unmap_page(struct page *page)
 {
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {
 		unsigned long addr = (unsigned long)page_address(page);
-		int ret  = set_direct_map_invalid_noflush(page);
+		int ret  = set_direct_map_invalid_noflush(page, 1);
 
 		if (ret)
 			pr_warn_once("Failed to remap page\n");
diff --git a/mm/secretmem.c b/mm/secretmem.c
index d29865075b6e..b073b780bd10 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -72,7 +72,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			goto out;
 		}
 
-		err = set_direct_map_invalid_noflush(folio_page(folio, 0));
+		err = set_direct_map_invalid_noflush(folio_page(folio, 0), 1);
 		if (err) {
 			folio_put(folio);
 			ret = vmf_error(err);
@@ -87,7 +87,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			 * already happened when we marked the page invalid
 			 * which guarantees that this call won't fail
 			 */
-			set_direct_map_default_noflush(folio_page(folio, 0));
+			set_direct_map_default_noflush(folio_page(folio, 0), 1);
 			folio_put(folio);
 			if (err == -EEXIST)
 				goto retry;
@@ -151,7 +151,7 @@ static int secretmem_migrate_folio(struct address_space *mapping,
 
 static void secretmem_free_folio(struct folio *folio)
 {
-	set_direct_map_default_noflush(folio_page(folio, 0));
+	set_direct_map_default_noflush(folio_page(folio, 0), 1);
 	folio_zero_segment(folio, 0, folio_size(folio));
 }
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..22566e0b6e38 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3358,14 +3358,15 @@ struct vm_struct *remove_vm_area(const void *addr)
 }
 
 static inline void set_area_direct_map(const struct vm_struct *area,
-				       int (*set_direct_map)(struct page *page))
+				       int (*set_direct_map)(struct page *page,
+							     unsigned int nr))
 {
 	unsigned long i;
 
 	/* HUGE_VMALLOC passes small pages to set_direct_map */
 	for (i = 0; i < area->nr_pages; i++)
 		if (page_address(area->pages[i]))
-			set_direct_map(area->pages[i]);
+			set_direct_map(area->pages[i], 1);
 }
 
 /*

-- 
2.53.0



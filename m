Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0D25C5DF98
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 11:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B866B00A5; Sun, 23 Aug 2026 07:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2CB6B00A6; Sun, 23 Aug 2026 07:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C099E6B00A7; Sun, 23 Aug 2026 07:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 927B06B00A5
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:47:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B109C02D6
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:47:24 +0000 (UTC)
X-FDA: 85132358808.27.A59DD7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 63E4FC0002
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 11:47:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GR+EPnx5;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787485642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfbXl9VbJJ1Sdgb3CrdMLA7PizvK3A5LrpuhhYPyjKk=;
	b=WWNN3dfvzuFvAMfzrzFnx886d/1pSyG0PAgdFFny854bP2IBqrtt0BzjgFnD2lVGOBv4BG
	F0mewggQtwzjYpok20D5g0saNXJ7Dww/kKWR+uaxcih4ioD+WHFvtTi8zgeZXXmZoLH95c
	X+0lOC/zAqMj5EExoo/yKMYmtXUljpI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GR+EPnx5;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787485642;
	b=u7jpHiJ0lLwpgy+Cfnm29ZHzcbUyd+n68mKrlte7s7S1982Is7zrShsEFLwWmPVe+uawmM
	huzSaFVc/FV8yXoKpHXZx6oe6X/hSkTeX2w7AOYgUys9WPpXOWB+adRK0JvcGRI3T5BVhZ
	JJfVI0c9qQ+utVfeWLwOM63nStAhf0I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07BEC60052;
	Sun, 23 Aug 2026 11:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556CD1F000E9;
	Sun, 23 Aug 2026 11:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787485641;
	bh=rfbXl9VbJJ1Sdgb3CrdMLA7PizvK3A5LrpuhhYPyjKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GR+EPnx5JjY2y6j2cwBoRe0ZQZtjiH2t4gW4CnhBU2dF6EGQ33O3EG4r/XGhlIllJ
	 Nst1G2RRcvVnDgOs+kdrsPo+ejiCqMxSMT3q8IasWBptn0CaCORZMotXXqGrNG+dyU
	 4lt9XqVoCJW6Q53Y3KDib+kzow6QjVst9U8Sj9RsiHQw5+cRbFos337JWxSqAryu4+
	 u8qU9iTiUiyiI0D7T4HZ4fgUXdy1voMsKSF/kTKGtA5hn5O/8+OQoRG+vrG+RsA5kw
	 JqABmzemuKva4V8kAFXy8rgAovNcAraYmYYzFnwEJZTx4MnIBVew+F1qpb8B85epVg
	 bwj5C14j/M9KQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 23 Aug 2026 14:46:17 +0300
Subject: [PATCH v2 6/6] Revert "arch: introduce
 set_direct_map_valid_noflush()"
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260823-execmem-set-vm-perms-v0-2-v2-6-b013a37d84b3@kernel.org>
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
X-Stat-Signature: e8jzcuhj6zt65mkwrdg31du1qbxqrkpk
X-Rspamd-Queue-Id: 63E4FC0002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787485642-574115
X-HE-Meta: U2FsdGVkX185UNNapTtTCAkC6frr53Axv3jaNUC7Fe+DOGt7yuS5QW7gd9845+ZMjK/P5gLce7KswFqnRnQiHsFGxmvf0plcv9zaHhyqDhDpGTRxvqMBtme0i5frDWsgu7yEmury1wSOfxUukwPq32ht+PX+kouNaySNjBAmRnbfTIIRZUdWTZkhJBkvMuDrOfBWOoc9q9DkiwJHGi5f1/nsx7zx8h0Tvc4GZin35XhByIER6bSElV+5whZcGqgQDmCtY9uHG/5DeSYB1G7n4iL5zoBikihxb65M8P15EJ9K1umSo6uC3cUpqiX4W+x31275IGNc8M7sFIdIvi6qkO0FlyT/uFkWSFQoEm951cnyn7HqOd5M6utTL7R8K3HU67a68EK1wG+P2tEbXS6VDeKtWeNCZlS0RJVo7l2V3ZA/iftBYFN7DBYay6hkyXkQI6hZOIxLwSJJXz2FC4JmnnZ3WL8oPnCWV4Tc61gpD6LlYVuwpIbEvhBQxuKMKSWVqUkgRZlYAiwn3J+FCHwGm/F+LHlw0Du10W0LdQ+eCqy01bmLBsmWHIbOr+IjjSgnkhQIGtIm3ORh5wTguS07oSpWwDGAAWNQmfAss8acr63688az9QQZnIbuWfAwqeqoM4bb/pEIVvW8amaW4NFyaWOyXDxXla72ZcDcNJO9iZJvGAqmL5MiobXLcD/MPrZ4brVD7n+sJrpxRPyQJqsnup4oWwguVbiIE6rhOEcDPamfpf2QNDK9FygaoExtQmAkReqUFiRPcV/O4tjBId6zMJjwm47RQfQynO/jkR7ePVKDLUZ/c6utkcIrEwn8bthTy0OaWb87z32cXAggYw33K0vBH8qqcazxfdKUWmsi2ws+EiSaW62EwF+uXkP+MHc+//kN8gUAzVlqqHY/hQAyavBk1Mo+WneAq8/OVAVC7IyYZDNrzyfIHAhZimWoFh569nHLrzQMVI3/8AXMay0
 33OofJ0w
 wWRgFFPG5+lXzheGox9u2Ng0Fm59th1eijFC3PyqFkzed9g1dkzGZcDJKMRW7i73vLGuV+UfnmvynFxJcYyaSE57pFGjP8w8cYuZdCR7mtcz3sS+ksqMa6fPAAFxyfZ4zEwxtSJ6bcE4CwWqKxLd3/pUQD/yZc1ta2ui0gPsKBV2ss/zuxmxVjUqGDUGBuFXLJj1558U7nuihgwOepGBmaUtxQOTZ7fgVF3P6iMkbMnRab6IaD+QWOn0pBMVdmobM+ZHVQ8kWNZJpny0+rVcXoV3GxjDEBGJb0SZ3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 0c6378a71574 ("arch: introduce set_direct_map_valid_noflush()")
added set_direct_map_valid_noflush() to allow updating the direct map
for a physically contiguous range in execmem.

As Brendan recently pointed out [1], this API is confusing because on
arm64 it means that is sets VALID bit in ptes, while on other
architectures it is an analog of set_direct_map_default_noflush().

The only user of set_direct_map_valid_noflush() was execmem's ROX cache
freeing path and it was switched to utilize VM_FLUSH_RESET_PERMS for
resetting permissions of the direct map alias.

With the last user gone and with set_direct_map_{invalid,default}_noflush()
accepting number of pages as a parameter, set_direct_map_valid_noflush()
become a copy of set_memory_valid() on arm64 and a duplicate of
set_direct_map_{invalid,default}_noflush() on other architecture, it is
safe to remove set_direct_map_valid_noflush().

Also drop a stale comment in arm64::__kernel_map_pages() that Linus
bothered to add when merging changes containing set_direct_map_valid_noflush()
to his tree.

This reverts commit 0c6378a71574daa6cd1534ad42a956e3262756c7.

[1] https://lore.kernel.org/all/DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev

Reviewed-by: Brendan Jackman <brendan.jackman@linux.dev>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/include/asm/set_memory.h     |  1 -
 arch/arm64/mm/pageattr.c                | 16 ----------------
 arch/loongarch/include/asm/set_memory.h |  1 -
 arch/loongarch/mm/pageattr.c            | 19 -------------------
 arch/riscv/include/asm/set_memory.h     |  1 -
 arch/riscv/mm/pageattr.c                | 15 ---------------
 arch/s390/include/asm/set_memory.h      |  1 -
 arch/s390/mm/pageattr.c                 | 12 ------------
 arch/x86/include/asm/set_memory.h       |  1 -
 arch/x86/mm/pat/set_memory.c            |  8 --------
 include/linux/set_memory.h              |  6 ------
 11 files changed, 81 deletions(-)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index b07fd4e026ea..0091ba12200e 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -13,7 +13,6 @@ int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int numpages);
 int set_direct_map_default_noflush(struct page *page, unsigned int numpages);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index db8d60a84d14..132938b32eb1 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -355,23 +355,7 @@ int realm_register_memory_enc_ops(void)
 	return arm64_mem_crypt_ops_register(&realm_crypt_ops);
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-
-	if (!can_set_direct_map())
-		return 0;
-
-	return set_memory_valid(addr, nr, valid);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
-/*
- * This is - apart from the return value - doing the same
- * thing as the new set_direct_map_valid_noflush() function.
- *
- * Unify? Explain the conceptual differences?
- */
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	if (!can_set_direct_map())
diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/include/asm/set_memory.h
index 563aab92896e..4bb01172fbc2 100644
--- a/arch/loongarch/include/asm/set_memory.h
+++ b/arch/loongarch/include/asm/set_memory.h
@@ -17,6 +17,5 @@ int set_memory_rw(unsigned long addr, int numpages);
 bool kernel_page_present(struct page *page);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c
index 43ad2a104f19..a7dcff40f759 100644
--- a/arch/loongarch/mm/pageattr.c
+++ b/arch/loongarch/mm/pageattr.c
@@ -217,22 +217,3 @@ int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 
 	return __set_memory(addr, nr, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
 }
-
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	unsigned long addr = (unsigned long)page_address(page);
-	pgprot_t set, clear;
-
-	if (addr < vm_map_base)
-		return 0;
-
-	if (valid) {
-		set = PAGE_KERNEL;
-		clear = __pgprot(0);
-	} else {
-		set = __pgprot(0);
-		clear = __pgprot(_PAGE_PRESENT | _PAGE_VALID);
-	}
-
-	return __set_memory(addr, nr, set, clear);
-}
diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm/set_memory.h
index db1d0ed82b69..e9f9960c1947 100644
--- a/arch/riscv/include/asm/set_memory.h
+++ b/arch/riscv/include/asm/set_memory.h
@@ -42,7 +42,6 @@ static inline int set_kernel_memory(char *startp, char *endp,
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 20ef95b1d0c3..5b3cf326455d 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -386,21 +386,6 @@ int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	pgprot_t set, clear;
-
-	if (valid) {
-		set = PAGE_KERNEL;
-		clear = __pgprot(_PAGE_EXEC);
-	} else {
-		set = __pgprot(0);
-		clear = __pgprot(_PAGE_PRESENT);
-	}
-
-	return __set_memory((unsigned long)page_address(page), nr, set, clear);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *data)
 {
diff --git a/arch/s390/include/asm/set_memory.h b/arch/s390/include/asm/set_memory.h
index 6b0aa9147ed8..e3562bf0c1aa 100644
--- a/arch/s390/include/asm/set_memory.h
+++ b/arch/s390/include/asm/set_memory.h
@@ -62,7 +62,6 @@ __SET_MEMORY_FUNC(set_memory_4k, SET_MEMORY_4K)
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 #endif
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index 02d992b251cb..f46a666bc5c7 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -397,18 +397,6 @@ int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 	return __set_memory((unsigned long)page_to_virt(page), nr, SET_MEMORY_DEF);
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	unsigned long flags;
-
-	if (valid)
-		flags = SET_MEMORY_DEF;
-	else
-		flags = SET_MEMORY_INV;
-
-	return __set_memory((unsigned long)page_to_virt(page), nr, flags);
-}
-
 bool kernel_page_present(struct page *page)
 {
 	unsigned long addr;
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 0c4235d159f4..39271a5ea925 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -88,7 +88,6 @@ int set_pages_rw(struct page *page, int numpages);
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr);
 int set_direct_map_default_noflush(struct page *page, unsigned int nr);
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 9022354e26e9..a6b2912a4837 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2683,14 +2683,6 @@ int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 	return __set_pages_p(page, nr);
 }
 
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
-{
-	if (valid)
-		return __set_pages_p(page, nr);
-
-	return __set_pages_np(page, nr);
-}
-
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 0b77f1d7d8b9..3fe293cfed8c 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -36,12 +36,6 @@ static inline int set_direct_map_default_noflush(struct page *page,
 	return 0;
 }
 
-static inline int set_direct_map_valid_noflush(struct page *page,
-					       unsigned nr, bool valid)
-{
-	return 0;
-}
-
 static inline bool kernel_page_present(struct page *page)
 {
 	return true;

-- 
2.53.0



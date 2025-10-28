Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBD5CCF9EE
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48038012E; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71B880131; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BEA8012E; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5551B80130
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23D34B89FE
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:27 +0000 (UTC)
X-FDA: 84046969734.04.AEA251A
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4B052C000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=f4sGwxQZ;
	spf=pass (imf22.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upK8e2DaCyurvlV2au3C3EMKO53/pyTE8SEh3elz5uk=;
	b=Cs+lebc3iYgPoVynAx/fzmyUUPZIzrP8sZnHO5rOYpcuZbgvgZq4WpO47l0OjqeX2WQadL
	ZwBG2tLDiprQ4hn2ZI+uOPjCIx4KVFQHsTDwPbJDfKlDhZNSv6RbMf2BS6IY9VxtuQvzuH
	n5XKMTHj64AdbhxR7ts0mtyf3Yr6oMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643045; a=rsa-sha256;
	cv=none;
	b=yzbqdauqsrp5YS3E7JiiH33218Mw5z38gPmS+GicirzF48r26K5YjumsNxeeHCITxgkl8G
	252zPP/lPYG52mCQI4BoE4S41R+cC+qmqZw2B8z/GaiVuiZl7GcdOxOuQpYimvGnCTRB2G
	tAXfd1S1W77wGBMAOiC6GhexgLh999U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=f4sGwxQZ;
	spf=pass (imf22.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643043;
	bh=dydLLqvv9GfPDw2CeThambI3wNtkxs7fMg/amODW+pI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=f4sGwxQZpk7mblNTexMQtkekFpAHFYAQrtXOCJ/5kdC9miO83xedGgFpC5+8P9VsD
	 FnkEQCobG/Fwu0j2tKtfV8f3JpnF1Hz1cZTD+BrsAXmsD1l2h2dNFnuz3Pn0az+5rg
	 deu3+/bnFxLedVyg7+dkWj1EMj8oZL0QouL3vCOI=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:41 +0100
Subject: [PATCH 06/10] um: Remove fixaddr_user_init()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-6-e930063eff5f@weissschuh.net>
References: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
In-Reply-To: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
To: Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Kees Cook <kees@kernel.org>
Cc: linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=3743;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=dydLLqvv9GfPDw2CeThambI3wNtkxs7fMg/amODW+pI=;
 b=FE436oxVhFe82l0jtHD/HvpcwSmrp0Hh5AuY180kd9J+qoZp3cVjbhqXIPrPYxLyuvokqHzrV
 9kUcalb4qCOBnlsULjIBymngzXQ+6WLimdvyCFPdni/Bql4qjjT7o2T
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspamd-Server: rspam05
X-Stat-Signature: 5pd5p1bwpfchy9jojehe8zdtkig6mkzp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B052C000C
X-HE-Tag: 1761643045-302893
X-HE-Meta: U2FsdGVkX18rQtJ6qCTwW1KUp3Hm5UlqOB1A5X3zTnQB+o2zUjGWYdFVxuYOeokN8hK+6eko5A9yjF0K0odts6pAPjSRoR18JNBpk7tOLRoXpK1UuLk98x1iJpDTebQR+QiOhB6zzb6FO/R517X6RyOGvx5pL1QctZf5NsJpxPlL9VX92nnupJutD0SuKp62Wt9HMJwVS5stT5AYVUQ8scqOTZsM3f6wyXsSsRa93SbeBLanNjEuJrvTz7Rg1hNUiNKpP+LUmanCreI5ALzHQHX2QzGx01Ipkf8Q7PoMnJUj5yIPLbi8et+Nvoc4TNvO+yNTS/hLLV3Kdq4XX5eD4A7jozpA3YaJW+8OOxWfSrhsepPgpt2fTrxzCAybhhxPyHOXo4WWWNFyqgIeG4qudlzAJZK/YTsiF+YNLkM51qrv8+iNqbN6ccVgB/hFLfvcKhXJsfKux7RFgfIPJU8clc1MUG6AlIzkJLdeh8nps6QlBLhSwCaiAQKXbNHdBmFkjEZfIFY7snc5Y1mUFh+Rnj3kOU2lvyNdYek+25Keeosf9jz7fIqmcpyESZg1MB/e0w/CzTaZpVm5GRPppOZ4qjPhQSMZSx6mvVLMf4YQwxS1+9P2DlbaFnlqHCXnafa6W1T92i9RONN8hDB8lIoQL1By/7mZUKmCjHdrbY3GYQzceuL7HglQCfwwgumgNRQ6ST/rUQuKn3pvuZ4/ievhc7GrOZ5zHocX93jAP+F56S6H4VqL6ozI6MT2YelvjM/8l/qigZ68NCGqbsnbagz6yrfZoDr3P4Zvq1sUamQW20xF+RGbwKCV14k64g9W+VOIfpZvXAiQ97XqYIBA4d3g6AXdLd24gHotxhksc7TSuwW01dfgqzBrX5F6RhgscOCrrKUdZ8KCakuucAxEGegxiW1w82HlK9MC5jHKcHpHCJwgbHIIcg9YabtCayUvVKuQAJ4liGxKwMvRSOHdg2H
 V+dsaEkj
 EBNZBX2FQuhhq4EJztQSzkKcSvRGZcQP3YGM50yMpgDYgbZg0Jh0TEdubvffJQSvJ35d/4kqd4oFICb3mjfD+QTN8ldC7FVk9HBye2p1/umD2I/6SEN+8QizWmGxifmgtxMHSZrS9MK9qoZQ2rnDPkbth9BF8kDVCkiA6BFS0krJDbYkBUUfDB8Jb7ELuEyEcHycBx+EyaXaVt3c5yZC5hJN59MBJaBCsgAfRajrLf8Jy0UGy/QfoFmSr+YdI88KaZJdusdewHkYUTk/wwNa3/UR0ShL1LlzJp0/+DCgx5ouewbJdL/0EycrE5DFkAMe6YZbOdhwq0k5XnHlbDTm/N5wYhoG3XSPZ+pMy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the removal of the vDSO passthrough from the host,
FIXADDR_USER_START is always 0 and fixaddr_user_init() is dead code.

Remove it.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/um/kernel/mem.c | 107 ---------------------------------------------------
 1 file changed, 107 deletions(-)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index dc938715ec9d..39c4a7e21c6f 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -84,109 +84,6 @@ void __init mem_init(void)
 	kmalloc_ok = 1;
 }
 
-#if IS_ENABLED(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA)
-/*
- * Create a page table and place a pointer to it in a middle page
- * directory entry.
- */
-static void __init one_page_table_init(pmd_t *pmd)
-{
-	if (pmd_none(*pmd)) {
-		pte_t *pte = (pte_t *) memblock_alloc_low(PAGE_SIZE,
-							  PAGE_SIZE);
-		if (!pte)
-			panic("%s: Failed to allocate %lu bytes align=%lx\n",
-			      __func__, PAGE_SIZE, PAGE_SIZE);
-
-		set_pmd(pmd, __pmd(_KERNPG_TABLE +
-					   (unsigned long) __pa(pte)));
-		BUG_ON(pte != pte_offset_kernel(pmd, 0));
-	}
-}
-
-static void __init one_md_table_init(pud_t *pud)
-{
-#if CONFIG_PGTABLE_LEVELS > 2
-	pmd_t *pmd_table = (pmd_t *) memblock_alloc_low(PAGE_SIZE, PAGE_SIZE);
-	if (!pmd_table)
-		panic("%s: Failed to allocate %lu bytes align=%lx\n",
-		      __func__, PAGE_SIZE, PAGE_SIZE);
-
-	set_pud(pud, __pud(_KERNPG_TABLE + (unsigned long) __pa(pmd_table)));
-	BUG_ON(pmd_table != pmd_offset(pud, 0));
-#endif
-}
-
-static void __init one_ud_table_init(p4d_t *p4d)
-{
-#if CONFIG_PGTABLE_LEVELS > 3
-	pud_t *pud_table = (pud_t *) memblock_alloc_low(PAGE_SIZE, PAGE_SIZE);
-	if (!pud_table)
-		panic("%s: Failed to allocate %lu bytes align=%lx\n",
-		      __func__, PAGE_SIZE, PAGE_SIZE);
-
-	set_p4d(p4d, __p4d(_KERNPG_TABLE + (unsigned long) __pa(pud_table)));
-	BUG_ON(pud_table != pud_offset(p4d, 0));
-#endif
-}
-
-static void __init fixrange_init(unsigned long start, unsigned long end,
-				 pgd_t *pgd_base)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	int i, j;
-	unsigned long vaddr;
-
-	vaddr = start;
-	i = pgd_index(vaddr);
-	j = pmd_index(vaddr);
-	pgd = pgd_base + i;
-
-	for ( ; (i < PTRS_PER_PGD) && (vaddr < end); pgd++, i++) {
-		p4d = p4d_offset(pgd, vaddr);
-		if (p4d_none(*p4d))
-			one_ud_table_init(p4d);
-		pud = pud_offset(p4d, vaddr);
-		if (pud_none(*pud))
-			one_md_table_init(pud);
-		pmd = pmd_offset(pud, vaddr);
-		for (; (j < PTRS_PER_PMD) && (vaddr < end); pmd++, j++) {
-			one_page_table_init(pmd);
-			vaddr += PMD_SIZE;
-		}
-		j = 0;
-	}
-}
-
-static void __init fixaddr_user_init( void)
-{
-	long size = FIXADDR_USER_END - FIXADDR_USER_START;
-	pte_t *pte;
-	phys_t p;
-	unsigned long v, vaddr = FIXADDR_USER_START;
-
-	if (!size)
-		return;
-
-	fixrange_init( FIXADDR_USER_START, FIXADDR_USER_END, swapper_pg_dir);
-	v = (unsigned long) memblock_alloc_low(size, PAGE_SIZE);
-	if (!v)
-		panic("%s: Failed to allocate %lu bytes align=%lx\n",
-		      __func__, size, PAGE_SIZE);
-
-	memcpy((void *) v , (void *) FIXADDR_USER_START, size);
-	p = __pa(v);
-	for ( ; size > 0; size -= PAGE_SIZE, vaddr += PAGE_SIZE,
-		      p += PAGE_SIZE) {
-		pte = virt_to_kpte(vaddr);
-		pte_set_val(*pte, p, PAGE_READONLY);
-	}
-}
-#endif
-
 void __init paging_init(void)
 {
 	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
@@ -199,10 +96,6 @@ void __init paging_init(void)
 
 	max_zone_pfn[ZONE_NORMAL] = high_physmem >> PAGE_SHIFT;
 	free_area_init(max_zone_pfn);
-
-#if IS_ENABLED(CONFIG_ARCH_REUSE_HOST_VSYSCALL_AREA)
-	fixaddr_user_init();
-#endif
 }
 
 /*

-- 
2.51.1.dirty



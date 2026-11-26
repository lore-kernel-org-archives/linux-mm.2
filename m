Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325A8606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JJTmgF9h
Received: by kanga.kvack.org (Postfix)
	id 42CA66B05C9; Thu, 26 Nov 2026 06:16:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4051C6B05CA; Thu, 26 Nov 2026 06:16:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31ACC6B05CB; Thu, 26 Nov 2026 06:16:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCDF66B05C9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:16:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B5C5A03EB
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:31 +0000 (UTC)
X-FDA: 85477016982.18.CA31DC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 66E3A40006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJTmgF9h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691789;
	b=gqXoZ3DOuiFnN2loCLNzuFzLZbEkLYh3L6V3SN2ymg6QiwevDZNI7VBQgHHxekPFz3Ap8v
	i5j/1dT/0NVa+kW/Whe2V/NmWfqCK3mwo3ZBOEELhfdBDR7awcqH2ffV8opBnl+/Th5LW6
	w5pFzPOt1b5yfTm529jrrVTYChyKxSM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7+G25h7JB/VdJKGT10uzFSZXJehzXr1o5C1pbOXKCo=;
	b=BzBFNcAUzFGY6ln6TDHUdqBqFFlslU4JuXncGDsRINGK5IKtNG0gVzWZoxPy60zaCxIHlP
	akAe7yXLOasKF9fnidfpEsMj8qecbncfHqmofFetidBgxoExDR6i9hYK75hA+X/s1VBfgP
	y8UJgPs3qvLQRQJyr7uxCLm1xJyjEXE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JJTmgF9h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6332628FB;
	Thu, 26 Nov 2026 11:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64B31F000D1;
	Thu, 26 Nov 2026 11:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691788;
	bh=g7+G25h7JB/VdJKGT10uzFSZXJehzXr1o5C1pbOXKCo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JJTmgF9hCDloI4+C9h9XvD40HTS73PHevQ/AL1GPsnk5uRiOh0Xtwz/5NgaWA3TQd
	 MhWF3uq8pOpyod+MeWUnBV+pluBsiCPrOiXQ6Gy2JuHY+eeB136zaAgdmRIBRHpArj
	 xX9Pj8dnVkGzTfZ1P+3Xe8N9xqP1v86DauxGOJeKSJiIJcAHVE4MUggm1zKcR/bMrC
	 CjoZMblWz3YnlXQU2MAi0Kp4nkCN12bw+vipoHgMvlvtK0322zGJ5Ja8RESYSBssgy
	 BfJ8zyrYkmvuNYpAy8Ir0rc+KgNMUwONUWMrt3fK4eOR3FMphFviDpfly9rHAYJEip
	 NLfXyYa2Uo6/w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:25 +0200
Subject: [PATCH RFC v2 12/54] x86/mm/pat: introduce
 change_page_attr_pages()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-12-723f1e33c3d8@kernel.org>
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
X-Rspam-User:
X-Stat-Signature: mqi96ue65fckbfw1u9abdqqddr9p9arj
X-Rspamd-Queue-Id: 66E3A40006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691789-330171
X-HE-Meta: U2FsdGVkX18s9mvXYt6oiTZA7LiyqpQl3nW0ATe7TTcfZXBfxH6lAwaFtCd6jy7RCRoEGeJ9K54bZNU2tktvYEIIC89yAQbfcE/bB1vA9Es0ZX2EhgLBFyQknKiqI9ADtJsB3G9kkCxMVk4oKcQkX+N4Jk5vRpeiJNY8YSpMTJg1PzFaqxOV5uQ2x9vOGelleLyU0mMoMez3HPESIdeWBp510kbnDqXzcgShPRhH3REOPr635oXwE5uLy6uCFO++AFag9GMFATcjqj0hdDGhVhAmzExxxoh+AaGFicxNkDFsLqjNT5TCS8079wzFCfASmqF02Ml4y/vaGxRD40gfY+riCz9OLjV9ORRmMvf6NvCMvvQe9s8iTewwF5EZEHYGBWk51w6fz54TvSsn+vQ0zje/IB9Dkt1lNKiDj9pZ/eBosUPNeEE92aRJOtiBCyaZZiiZ2UwP/pLvp5gNPDXTl3jMTYRU4fAAH1D10oUN7eAeM5DGz5plkKmSsMfk5+YtX4269tdO0JcHDkkJpMrneViCYxXLNq2G4oMOqus7vXDSleDsX19XZzFdJsKdTi/F+niII4JIr0PtW9hlwxI44JuB6FENZ+Ykmmua2TbyfQdTZAgCksMcuWzITSkh9qdpvk1p/JF09bWVgZiTQBgSSx4SdbuoXwezkd5C6/JGGbaBU/jVBF9wmS5u3goHi9x8W4uDTvFjF1+b3Qd0BmC7j9cErVWJLMvAWiwpjZqvLB23wcdaVS8Ag5wUAPcrrdiw3C8cB6IjolJqlrpNTqruJ7yfYNi70S4ciKB56hTejEBcRbYAF0bXqD1jT/jnVVMNj0Y72DkUEEuLMSrZtJ4g2ZYcXHWjfBNyBITfY4MktVE5C6SZfUQELZUTj+d5v56ktka8xRupL2aw1Ixi1z4CTewNyihDr4K15nv2fQ2vBu9Oob0MtxpHQDWgs+M4YkmrGtPk3TeKg4Qq7CPZHSu
 9QAYBP4w
 maLV7Fjk1Ylz/wIyuzmvgei3uxMJmNYiusmtaN8iUzS1x5/FsUTn/bAPnaxihsit7WaSBO6YUpHzRFQu7/DWOsRUGImgKjS1X6XM8WTmIZhH4Ivm7xihEtEes1VWBukYZCxDJgo7jagl96PVhiNbkUB/6hM3Ao5BtOjgNmOuzote9duY9+oCkh8Tg/ze+WGd1xksadNRNmNuoIMsFuyESJuJj0mnbRXWVtMVT06f/n+yPk5Nep1aRncV/kwO9PUToIHzt24gAOt6K/2cPU/uusb7AddjOZxgh7HpEtyajBxdN/dGVP7t/vpQ/L4QcaaYpwClxfcy/b8zvDmVPlOBrbc9sz5aWQ4F8sFEcxrmIHCOa9ZeN0aEe/pydzR41MN8VSPm/XJFtoeKIVMAaZ5CeBoiVHn+grSG+thoNhcq05NnUN1/soyEYi5GTGQdgA2h/FxKConOutwDzbIEhSoJCSclSZ0Syu4O/pfejpSwikfJDyqLZJvoNCAWEEARVrvhmIl2TiZFqnRHanfs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CPA takes either a range of addresses or, with CPA_REQ_PAGES_ARRAY, an
array of pages.

CPA_REQ_PAGES_ARRAY is used by set_pages_array_*() APIs to change the cache
mode of the direct map of the pages.

Changing the cache mode of the direct map is very x86 specific and no other
architecture does it.

With the upcoming move of the CPA core to the generic code, it is best to
keep arrays of pages in x86, so that generic core deals only with ranges
and is simpler to reason about.

Besides, its current implementation is suboptimal. CPA walks an array page
at a time and splits every large page it touches, even when the pages are
contiguous. For instance, TTM passes arrays that may contain high order
pages.

Introduce change_page_attr_pages() that changes the pages that are
contiguous in the direct map as a single range, so a range that covers a
large page keeps it, and drop CPA_REQ_PAGES_ARRAY.

Purge the vmap aliases once before the ranges and flush the TLB and the
caches once after them, as before.

change_page_attr_pages() flushes once for the entire pages array, so the
flush can no longer take a struct cpa_data. Introduce struct cpa_flush_req
that describes either a range or an array of pages, and use it for both
change_page_attr_set_clr() and change_page_attr_pages().

A highmem page has no address in the direct map. CPA looked up address 0
for it, which on 32-bit ends in the "CPA: called for zero pte" warning and
-EFAULT since commit 16ebf031e8ab ("x86/mm/cpa: Add __cpa_addr() helper").
Skip highmem pages.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 191 ++++++++++++++++++++++++++++---------------
 1 file changed, 124 insertions(+), 67 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index e1abc0d1d143..5e3c1152d202 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -49,7 +49,6 @@ struct cpa_data {
 	unsigned long	pfn;
 	unsigned int	flags;
 	unsigned int	state;
-	struct page	**pages;
 };
 
 enum cpa_warn {
@@ -72,7 +71,6 @@ static DEFINE_SPINLOCK(cpa_lock);
 #define CPA_REQ_NO_CHECK_ALIAS	0x01 /* Do not search for aliases */
 #define CPA_REQ_COLLAPSE	0x02 /* try to collapse large pages */
 #define CPA_REQ_SPLIT		0x04 /* split large pages */
-#define CPA_REQ_PAGES_ARRAY	0x08
 
 /* cpa_data::state */
 #define CPA_ST_FLUSHTLB		0x01 /* the TLB needs a flush */
@@ -309,15 +307,6 @@ static inline unsigned long fix_addr(unsigned long addr)
 
 static unsigned long __cpa_addr(struct cpa_data *cpa, unsigned long idx)
 {
-	if (cpa->flags & CPA_REQ_PAGES_ARRAY) {
-		struct page *page = cpa->pages[idx];
-
-		if (unlikely(PageHighMem(page)))
-			return 0;
-
-		return (unsigned long)page_address(page);
-	}
-
 	return cpa->addr + idx * PAGE_SIZE;
 }
 
@@ -400,13 +389,33 @@ static void cpa_flush_all(unsigned long cache)
 	on_each_cpu(__cpa_flush_all, (void *) cache, 1);
 }
 
+/* The pages to flush: @numpages pages from @addr, or those in @pages */
+struct cpa_flush_req {
+	unsigned long	addr;
+	struct page	**pages;
+	unsigned long	numpages;
+	unsigned int	state;
+};
+
+/*
+ * A highmem page in @pages is not changed, but flushing it is harmless:
+ * page_address() returns NULL or its kmap address.
+ */
+static unsigned long cpa_flush_addr(struct cpa_flush_req *req, unsigned int i)
+{
+	if (req->pages)
+		return (unsigned long)page_address(req->pages[i]);
+
+	return req->addr + i * PAGE_SIZE;
+}
+
 static void __cpa_flush_tlb(void *data)
 {
-	struct cpa_data *cpa = data;
+	struct cpa_flush_req *req = data;
 	unsigned int i;
 
-	for (i = 0; i < cpa->numpages; i++)
-		flush_tlb_one_kernel(fix_addr(__cpa_addr(cpa, i)));
+	for (i = 0; i < req->numpages; i++)
+		flush_tlb_one_kernel(fix_addr(cpa_flush_addr(req, i)));
 }
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
@@ -417,20 +426,13 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 	struct ptdesc *ptdesc, *tmp;
 	LIST_HEAD(pgtables);
 	int collapsed = 0;
-	int i;
 
-	if (cpa->flags & CPA_REQ_PAGES_ARRAY) {
-		for (i = 0; i < cpa->numpages; i++)
-			collapsed += collapse_large_pages(__cpa_addr(cpa, i),
-							  &pgtables);
-	} else {
-		addr = __cpa_addr(cpa, 0);
-		start = addr & PMD_MASK;
-		end = addr + PAGE_SIZE * cpa->numpages;
+	addr = __cpa_addr(cpa, 0);
+	start = addr & PMD_MASK;
+	end = addr + PAGE_SIZE * cpa->numpages;
 
-		for (addr = start; within(addr, start, end); addr += PMD_SIZE)
-			collapsed += collapse_large_pages(addr, &pgtables);
-	}
+	for (addr = start; within(addr, start, end); addr += PMD_SIZE)
+		collapsed += collapse_large_pages(addr, &pgtables);
 
 	if (!collapsed)
 		return;
@@ -451,7 +453,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 	}
 }
 
-static void cpa_flush(struct cpa_data *cpa, int cache)
+static void __cpa_flush(struct cpa_flush_req *req, int cache)
 {
 	unsigned int i;
 
@@ -462,18 +464,18 @@ static void cpa_flush(struct cpa_data *cpa, int cache)
 		return;
 	}
 
-	if ((cpa->state & CPA_ST_FLUSH_ALL) ||
-	    cpa->numpages > tlb_single_page_flush_ceiling)
+	if ((req->state & CPA_ST_FLUSH_ALL) ||
+	    req->numpages > tlb_single_page_flush_ceiling)
 		flush_tlb_all();
 	else
-		on_each_cpu(__cpa_flush_tlb, cpa, 1);
+		on_each_cpu(__cpa_flush_tlb, req, 1);
 
 	if (!cache)
 		return;
 
 	mb();
-	for (i = 0; i < cpa->numpages; i++) {
-		unsigned long addr = __cpa_addr(cpa, i);
+	for (i = 0; i < req->numpages; i++) {
+		unsigned long addr = cpa_flush_addr(req, i);
 		unsigned int level;
 
 		pte_t *pte = lookup_address(addr, &level);
@@ -487,6 +489,17 @@ static void cpa_flush(struct cpa_data *cpa, int cache)
 	mb();
 }
 
+static void cpa_flush(struct cpa_data *cpa, int cache)
+{
+	struct cpa_flush_req req = {
+		.addr = cpa->addr,
+		.numpages = cpa->numpages,
+		.state = cpa->state,
+	};
+
+	__cpa_flush(&req, cache);
+}
+
 static bool overlaps(unsigned long r1_start, unsigned long r1_end,
 		     unsigned long r2_start, unsigned long r2_end)
 {
@@ -1949,7 +1962,6 @@ static int cpa_process_alias(struct cpa_data *cpa)
 
 		alias_cpa = *cpa;
 		alias_cpa.addr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
-		alias_cpa.flags &= ~CPA_REQ_PAGES_ARRAY;
 		alias_cpa.state &= ~CPA_ST_FLUSHTLB;
 		alias_cpa.state |= CPA_ST_ALIAS;
 		alias_cpa.curpage = 0;
@@ -1978,7 +1990,6 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		alias_cpa = *cpa;
 		alias_cpa.addr = (cpa->pfn << PAGE_SHIFT) +
 				 __START_KERNEL_map - phys_base;
-		alias_cpa.flags &= ~CPA_REQ_PAGES_ARRAY;
 		alias_cpa.state &= ~CPA_ST_FLUSHTLB;
 		alias_cpa.state |= CPA_ST_ALIAS;
 		alias_cpa.curpage = 0;
@@ -2024,9 +2035,6 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa)
 		 * preservation check.
 		 */
 		cpa->numpages = rempages;
-		/* for array changes, we can't use large page */
-		if (cpa->flags & CPA_REQ_PAGES_ARRAY)
-			cpa->numpages = 1;
 
 		scoped_guard(spinlock, &cpa_lock)
 			ret = __change_page_attr(cpa);
@@ -2061,7 +2069,7 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa)
 
 static int change_page_attr_set_clr(unsigned long addr, int numpages,
 				    pgprot_t mask_set, pgprot_t mask_clr,
-				    int in_flag, struct page **pages)
+				    int in_flag)
 {
 	struct cpa_data cpa;
 	int ret, cache;
@@ -2079,18 +2087,12 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 		return 0;
 
 	/* Ensure we are PAGE_SIZE aligned */
-	if (!(in_flag & CPA_REQ_PAGES_ARRAY)) {
+	if (addr & ~PAGE_MASK) {
+		addr &= PAGE_MASK;
 		/*
-		 * in_flag of CPA_REQ_PAGES_ARRAY implies it is aligned.
-		 * No need to check in that case
+		 * People should not be passing in unaligned addresses:
 		 */
-		if (addr & ~PAGE_MASK) {
-			addr &= PAGE_MASK;
-			/*
-			 * People should not be passing in unaligned addresses:
-			 */
-			WARN_ON_ONCE(1);
-		}
+		WARN_ON_ONCE(1);
 	}
 
 	/* Must avoid aliasing mappings in the highmem code */
@@ -2099,7 +2101,6 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	vm_unmap_aliases();
 
 	cpa.addr = addr;
-	cpa.pages = pages;
 	cpa.numpages = numpages;
 	cpa.mask_set = mask_set;
 	cpa.mask_clr = mask_clr;
@@ -2151,29 +2152,88 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 static inline int change_page_attr_set(unsigned long addr, int numpages,
 				       pgprot_t mask)
 {
-	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0,
-					NULL);
+	return change_page_attr_set_clr(addr, numpages, mask, __pgprot(0), 0);
 }
 
 static inline int change_page_attr_clear(unsigned long addr, int numpages,
 					 pgprot_t mask)
 {
-	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0,
-					NULL);
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask, 0);
+}
+
+/* The number of pages from @pages[0] that are contiguous in the direct map */
+static int nr_contig_pages(struct page **pages, int numpages)
+{
+	void *addr = page_address(pages[0]);
+	int n;
+
+	for (n = 1; n < numpages; n++) {
+		if (page_address(pages[n]) != addr + n * PAGE_SIZE)
+			break;
+	}
+
+	return n;
+}
+
+/*
+ * Change the pages in ranges that are contiguous in the direct map, so that
+ * a range that covers a large page keeps it. Purge the vmap aliases once
+ * before the ranges and flush once after them.
+ */
+static int change_page_attr_pages(struct page **pages, int numpages,
+				  pgprot_t mask_set, pgprot_t mask_clr)
+{
+	struct cpa_flush_req req = { .pages = pages, .numpages = numpages };
+	struct cpa_data cpa = {
+		.mask_set = canon_pgprot(mask_set),
+		.mask_clr = mask_clr,
+	};
+	int i, n, ret = 0;
+
+	if (!pgprot_val(cpa.mask_set) && !pgprot_val(cpa.mask_clr))
+		return 0;
+
+	kmap_flush_unused();
+	vm_unmap_aliases();
+
+	for (i = 0; i < numpages; i += n) {
+		n = 1;
+		if (PageHighMem(pages[i]))
+			continue;
+
+		n = nr_contig_pages(pages + i, numpages - i);
+		cpa.addr = (unsigned long)page_address(pages[i]);
+		cpa.numpages = n;
+		cpa.curpage = 0;
+		cpa.state = 0;
+		ret = __change_page_attr_set_clr(&cpa);
+		req.state |= cpa.state;
+		if (ret)
+			break;
+	}
+
+	if (!(req.state & CPA_ST_FLUSHTLB))
+		return ret;
+
+	/* On error, flush everything to be sure */
+	if (ret)
+		req.state |= CPA_ST_FLUSH_ALL;
+
+	__cpa_flush(&req, !!pgprot2cachemode(cpa.mask_set));
+
+	return ret;
 }
 
 static inline int cpa_set_pages_array(struct page **pages, int numpages,
 				       pgprot_t mask)
 {
-	return change_page_attr_set_clr(0, numpages, mask, __pgprot(0),
-					CPA_REQ_PAGES_ARRAY, pages);
+	return change_page_attr_pages(pages, numpages, mask, __pgprot(0));
 }
 
 static inline int cpa_clear_pages_array(struct page **pages, int numpages,
 					 pgprot_t mask)
 {
-	return change_page_attr_set_clr(0, numpages, __pgprot(0), mask,
-					CPA_REQ_PAGES_ARRAY, pages);
+	return change_page_attr_pages(pages, numpages, __pgprot(0), mask);
 }
 
 int _set_memory_uc(unsigned long addr, int numpages)
@@ -2222,8 +2282,7 @@ int _set_memory_wc(unsigned long addr, int numpages)
 	if (!ret) {
 		ret = change_page_attr_set_clr(addr, numpages,
 					       cachemode2pgprot(_PAGE_CACHE_MODE_WC),
-					       __pgprot(_PAGE_CACHE_MASK),
-					       0, NULL);
+					       __pgprot(_PAGE_CACHE_MASK), 0);
 	}
 	return ret;
 }
@@ -2342,7 +2401,7 @@ int set_memory_rox(unsigned long addr, int numpages)
 		clr.pgprot |= _PAGE_NX;
 
 	return change_page_attr_set_clr(addr, numpages, __pgprot(0), clr,
-					CPA_REQ_COLLAPSE, NULL);
+					CPA_REQ_COLLAPSE);
 }
 
 int set_memory_rw(unsigned long addr, int numpages)
@@ -2359,7 +2418,7 @@ int set_memory_np_noalias(unsigned long addr, int numpages)
 {
 	return change_page_attr_set_clr(addr, numpages, __pgprot(0),
 					__pgprot(_PAGE_PRESENT),
-					CPA_REQ_NO_CHECK_ALIAS, NULL);
+					CPA_REQ_NO_CHECK_ALIAS);
 }
 
 int set_memory_p(unsigned long addr, int numpages)
@@ -2371,7 +2430,7 @@ int set_memory_4k(unsigned long addr, int numpages)
 {
 	return change_page_attr_set_clr(addr, numpages,
 					__pgprot(_PAGE_KERNEL_4K),
-					__pgprot(0), CPA_REQ_SPLIT, NULL);
+					__pgprot(0), CPA_REQ_SPLIT);
 }
 
 int set_memory_nonglobal(unsigned long addr, int numpages)
@@ -2535,11 +2594,9 @@ static int _set_pages_array(struct page **pages, int numpages,
 	ret = cpa_set_pages_array(pages, numpages,
 				  cachemode2pgprot(set_type));
 	if (!ret && new_type == _PAGE_CACHE_MODE_WC)
-		ret = change_page_attr_set_clr(0, numpages,
-					       cachemode2pgprot(
-						_PAGE_CACHE_MODE_WC),
-					       __pgprot(_PAGE_CACHE_MASK),
-					       CPA_REQ_PAGES_ARRAY, pages);
+		ret = change_page_attr_pages(pages, numpages,
+				cachemode2pgprot(_PAGE_CACHE_MODE_WC),
+				__pgprot(_PAGE_CACHE_MASK));
 	if (ret)
 		goto err_out;
 	return 0; /* Success */

-- 
2.53.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D63606A326
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cSDndUUz
Received: by kanga.kvack.org (Postfix)
	id 84B556B05C6; Thu, 26 Nov 2026 06:16:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822CE6B05C7; Thu, 26 Nov 2026 06:16:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7390A6B05C8; Thu, 26 Nov 2026 06:16:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42A8D6B05C6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:16:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C8955A86B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:11 +0000 (UTC)
X-FDA: 85477016142.28.6D4184B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 228C5180014
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSDndUUz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691770;
	b=e9p39ITF19/NXmdAYBGw8eEiyjMQTq7VPzHBNrKlPaxW8ctjuSvMV6tbvd3ZLR9seAhSrd
	EbLxJXQNfD+yHv3DifSg1q3vAMG6ES8zIz/J2XK8i44Z2oer599/o2uCLkYA7OYM3OrVXo
	XHQEQVl9yrFk2O62ZhuexDgv3hOebf4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=es5ACbySNcsOn5mifmn0sw17oD0NBxslOJGoEpu9y4U=;
	b=o6d4DCYt0mM1ZfV43iMx285sWPynKmsZBbdLtB450GBRBc1tRcIBbSOKJpu0fJPzg2fo3k
	QtyK8Iy9RGJbksIFH/NhkE/6ozRHQ0hzIiw26ZgmsohDWIzEYys5PTTv4Inagt7qp8/Ig4
	gyqrGPGwvJ2GpJKJNV8i/Lu3XGYmKrQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSDndUUz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 914B562A0A;
	Thu, 26 Nov 2026 11:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6301F000CA;
	Thu, 26 Nov 2026 11:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691769;
	bh=es5ACbySNcsOn5mifmn0sw17oD0NBxslOJGoEpu9y4U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cSDndUUz9ltRjMWCc1xwCEbOkpe05ultR/LXhUlE6AUSFKfFr+U81WBg1NHJJziN4
	 5BpdWRlhz+dlZkpO0lsm0H8cShz7Xnd+ejDNsr78OZzzhH2VF1SACE9rPuhGkVY1Nm
	 X+JoHHWwKD3W4o+1CnThn7LJ/6BYObVfQsC7W53zeqwXLDZQ8PylSlK0mBA3ZnEg9/
	 YvA8qnUsuE0+ARzPIvKeaVKp31kZDSgUCVZIba9Igp7V+pk6uLJiT2ShBKarTJ0eIg
	 OKdfCkFnY6Z6Ap3nQZc387ovnsZL8wGv72Ts13Qf0gU8AtHbY3uD18PHegoZJ6ivBN
	 6kbaQuYg5fydA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:23 +0200
Subject: [PATCH RFC v2 10/54] x86/mm/pat: stop using CPA for
 debug_pagealloc
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-10-723f1e33c3d8@kernel.org>
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
X-Stat-Signature: i5zwbeq4hyi4ct89y3ete3tgi1ouxohz
X-Rspamd-Queue-Id: 228C5180014
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795691769-933621
X-HE-Meta: U2FsdGVkX1/r6W3ILo7otKVZcAQmtcXNainYId3x0Fwr3Xhc8lD1ctUq9XUP7fuphqoBCJG8bZdaEGBJWq/HKWztZif7OAxT13ahCtaN5ga5JdGmpoQps+DfLhX7Ukhc14x/mEIYTWlkVL8s9hGZKmP7PDSJLHcc4xakESpnxrbfM2t+UV95lb9Edmg4rd9menGn2YSBM0j2nRy6QhWi08afWUur5ocaDUE+3TOO9uiUiQgeBifxlnfOxAK+oO7YP755rGppISNF3wkkVm5YlrD9i2SqdP5MteSPw6mNYC00DroP7msd01EtB9BJ383WDmvHQZUJk4V8v/hc5UrUIcHwwJQWQFCid6dKalk5W7Xd9ZNe+m2kMKwvJfH0mqKLpYIQVB17d0nCoKnyOWxcfwdSVFsjIfruWjWbV9+w91CRDONguZQ0Jl4TN8U8Px7kZqwvgWQyq2UT7zp+cxr6QDk9I99GKd95BDWLoRJ2lqxdd+NgK3QaE/8JJKpGyPxRjD46eGqOA6JSxUkKo27VDU8jAUfxPXRcEP5NsS4LCQiZIMsvU99shmrVqZDECGNA1pxMPlMSdTYt4LKhiEsSlQLbIpt9tbb0myflR6EwT21sEZaC/VQLKkSwbRkO4nuWmPae94DFsbLNx7MYh+UdMlME9NoQzJEZCsCZlVI1ulgzTASGka6ZvWKFi1tFA1sJzfdVEsK6vXCJNDcMcPlJifMhYvZWymkIz6kzoInXifguk/zttsTYABPJ3G8jkzqD3eTnifN4O1gPTzokqLmQU4G9b/4bSmdPQuZTeocV2VWJf2lmy8kku+bqWOX2BQLDNWH6F7qK8oWu5qFgjlvL3vk/KYl9IZdPRKVfVJH65ggg6vyGnIYEeobRadSPk2oEg3b0Z74n6AJo3uCtYr5gvCVafF56iXjes7Kl5z3+mcMiAyRpzUwQ6VxkW9QzD8/fZSut2X3UrzBnWfshwa0
 Nk9w8/NM
 FYCqDNlMD17ulrtjnlPmm5q/7Y3oWMnauFhp/EahJRlFtwZ1TyYjxeLUx+Cp/pqT5ran9BntuuCBapjswlzjIraw84UyJF8TrK6JOvJpUGx6wdhEf0FN7v9Q+oXgJWPeHm5t21mxpqVf3ZMR8XPStoM/Fz+7UVAWkR/ImLb+VEtxD9JyULGZSoS0Ff4yj2GCH2TIhtCBoF8vx1a+5IZ4fdvg0rv9JttHCM7kf3O/2SWCWt+zGaDeQ2dh+xMBVwYmjFeAeK+zsFWmFIUvGLHnrtNt+Mqiq8NoMrvTc0WrlF4tBGxlxd6RPXj2WHjHBHhtGG2BkgVXc4VKsfIyW6TgNKB4I2gf0qEl3H0/3hoMP+4a3/pc2hdTEplUuTWozWRSD6sFzJHPnW3T38AnpOOqeLOk0M3IperjloG5EXOXRvlIhwBh3s7+fT0lifXo090gENhAp6CJ74oeEcdo4ajD/PWCc3YgijxE7OkDzXqasz4GHzz0ayEWlHWcpHmfMKPQS/16N2yvmS//Kmog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With debug_pagealloc, the page allocator unmaps pages from the direct map
when it frees them and maps them back when it allocates them, in whatever
context it runs. It does that with CPA, in a mode of its own.

That mode is the one exception in the locking of CPA: it skips cpa_lock,
and every request checks for it. The exception is easy to get wrong:
commit 5fce67641a3e ("x86/mm/pat: Don't gate cpa_lock on
debug_pagealloc_enabled()") dropped it, and commit 7da514d819a0 ("x86/mm:
Fix and document DEBUG_PAGEALLOC") had to bring it back.

With debug_pagealloc enabled the direct map is mapped with 4K pages, so
mapping or unmapping a page always updates a single existing PTE.

Update the PTEs with apply_to_existing_page_range(), like powerpc and riscv
do, and drop the lockless mode from CPA.

Every request now takes cpa_lock, so cpa_inc_4k_install() does not need
data_race() any more.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 77 +++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 44 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 87c7c7934b42..c3af82788879 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -72,7 +72,6 @@ static DEFINE_SPINLOCK(cpa_lock);
 #define CPA_REQ_COLLAPSE	0x02 /* try to collapse large pages */
 #define CPA_REQ_SPLIT		0x04 /* split large pages */
 #define CPA_REQ_PAGES_ARRAY	0x08
-#define CPA_REQ_DEBUG_PAGEALLOC	0x10
 
 /* cpa_data::state */
 #define CPA_ST_FLUSHTLB		0x01 /* the TLB needs a flush */
@@ -165,7 +164,7 @@ static inline void cpa_inc_2m_checked(void)
 
 static inline void cpa_inc_4k_install(void)
 {
-	data_race(cpa_4k_install++);
+	cpa_4k_install++;
 }
 
 static inline void cpa_inc_lp_sameprot(int level)
@@ -2014,7 +2013,6 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa)
 {
 	unsigned long numpages = cpa->numpages;
 	unsigned long rempages = numpages;
-	bool lock = true;
 	int ret = 0;
 
 	/*
@@ -2024,29 +2022,6 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa)
 	    !(cpa->flags & CPA_REQ_SPLIT))
 		return ret;
 
-	/*
-	 * DEBUG_PAGEALLOC is special; it is called from any context the
-	 * page-allocator is, which violates the normal cpa_lock locking
-	 * rules.
-	 *
-	 * However, since it is part of the page-allocator, things are still
-	 * properly serialized by the page-allocator locking and the fact that
-	 * when a page is owned by the page-allocator, it isn't owned by
-	 * anybody else. That is, you *SHOULD NOT* be calling cpa() on memory
-	 * that isn't allocated.
-	 *
-	 * Additionally, DEBUG_PAGEALLOC ensures (per probe_page_size_mask())
-	 * that the kernel mapping is 4k pages, therefore there are no large
-	 * pages to split/collapse.
-	 *
-	 * Furthermore, the page-allocator strictly manages pages that
-	 * *exist*, avoiding pgd_lock.
-	 *
-	 * Therefore, it is safe to not take cpa_lock.
-	 */
-	if (debug_pagealloc_enabled() && (cpa->flags & CPA_REQ_DEBUG_PAGEALLOC))
-		lock = false;
-
 	while (rempages) {
 		/*
 		 * Store the remaining nr of pages for the large page
@@ -2057,12 +2032,8 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa)
 		if (cpa->flags & CPA_REQ_PAGES_ARRAY)
 			cpa->numpages = 1;
 
-		if (lock) {
-			guard(spinlock)(&cpa_lock);
-			ret = __change_page_attr(cpa);
-		} else {
+		scoped_guard(spinlock, &cpa_lock)
 			ret = __change_page_attr(cpa);
-		}
 		if (ret)
 			goto out;
 
@@ -2651,14 +2622,14 @@ int set_pages_rw(struct page *page, int numpages)
 	return set_memory_rw(addr, numpages);
 }
 
-static int __set_pages_p(struct page *page, int numpages, unsigned int cpa_flags)
+static int __set_pages_p(struct page *page, int numpages)
 {
 	struct cpa_data cpa = { .addr = (unsigned long)page_address(page),
 				.pgd = NULL,
 				.numpages = numpages,
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
 				.mask_clr = __pgprot(0),
-				.flags = CPA_REQ_NO_CHECK_ALIAS | cpa_flags };
+				.flags = CPA_REQ_NO_CHECK_ALIAS };
 
 	/*
 	 * No alias checking needed for setting present flag. otherwise,
@@ -2669,14 +2640,14 @@ static int __set_pages_p(struct page *page, int numpages, unsigned int cpa_flags
 	return __change_page_attr_set_clr(&cpa);
 }
 
-static int __set_pages_np(struct page *page, int numpages, unsigned int cpa_flags)
+static int __set_pages_np(struct page *page, int numpages)
 {
 	struct cpa_data cpa = { .addr = (unsigned long)page_address(page),
 				.pgd = NULL,
 				.numpages = numpages,
 				.mask_set = __pgprot(0),
 				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY),
-				.flags = CPA_REQ_NO_CHECK_ALIAS | cpa_flags };
+				.flags = CPA_REQ_NO_CHECK_ALIAS };
 
 	/*
 	 * No alias checking needed for setting not present flag. otherwise,
@@ -2689,17 +2660,35 @@ static int __set_pages_np(struct page *page, int numpages, unsigned int cpa_flag
 
 int set_direct_map_invalid_noflush(struct page *page, unsigned int nr)
 {
-	return __set_pages_np(page, nr, 0);
+	return __set_pages_np(page, nr);
 }
 
 int set_direct_map_default_noflush(struct page *page, unsigned int nr)
 {
-	return __set_pages_p(page, nr, 0);
+	return __set_pages_p(page, nr);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
+static int kernel_map_pte(pte_t *ptep, unsigned long addr, void *data)
+{
+	int *enable = data;
+	pte_t pte = ptep_get(ptep);
+	pgprot_t prot = pte_pgprot(pte);
+
+	if (*enable)
+		pgprot_val(prot) |= _PAGE_PRESENT | _PAGE_RW;
+	else
+		pgprot_val(prot) &= ~(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY);
+	prot = pgprot_clear_protnone_bits(prot);
+	set_pte_atomic(ptep, pfn_pte(pte_pfn(pte), prot));
+
+	return 0;
+}
+
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
+	unsigned long addr = (unsigned long)page_address(page);
+
 	if (PageHighMem(page))
 		return;
 	if (!enable) {
@@ -2708,14 +2697,14 @@ void __kernel_map_pages(struct page *page, int numpages, int enable)
 	}
 
 	/*
-	 * The return value is ignored as the calls cannot fail.
-	 * Large pages for identity mappings are not used at boot time
-	 * and hence no memory allocations during large page split.
+	 * This runs in any context the page allocator does, without locks.
+	 * The allocator owns these pages, so nothing else changes their PTEs,
+	 * and with debug_pagealloc the direct map has only 4K pages (see
+	 * probe_page_size_mask()), so their page tables are never split or
+	 * collapsed.
 	 */
-	if (enable)
-		__set_pages_p(page, numpages, CPA_REQ_DEBUG_PAGEALLOC);
-	else
-		__set_pages_np(page, numpages, CPA_REQ_DEBUG_PAGEALLOC);
+	apply_to_existing_page_range(&init_mm, addr, numpages * PAGE_SIZE,
+				     kernel_map_pte, &enable);
 
 	/*
 	 * We should perform an IPI and flush all tlbs, but that can

-- 
2.53.0



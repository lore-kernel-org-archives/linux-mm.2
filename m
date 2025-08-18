Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F482CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38348E0042; Mon, 18 Aug 2025 08:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FD28E003F; Mon, 18 Aug 2025 08:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE8E8E0042; Mon, 18 Aug 2025 08:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95F088E003F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:44:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5344BC027A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:44:51 +0000 (UTC)
X-FDA: 83789847582.03.7DB5574
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2D00314000E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:44:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="s0+rC5/i"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755521089; a=rsa-sha256;
	cv=none;
	b=8r5WG2Q4rjtTGGuxGtsmWegCDSuy3zeRh5GXb0yzE3qTpVHbwxdyfVm0RvV3IBjGIJCctF
	PBKILKw4Kos9T81by5xQQxvqjCG2cg+yBwUfSPxLWxdxYBmuij/Rlj/KpTPHPePKPUu545
	ubv8KrbG58ybapsoLDIrKUk+wEvceoA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="s0+rC5/i";
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755521089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QW8hqhTX8yt3ss6p2bOWGGDZ9wC8Lyuga+9TEJk5CV4=;
	b=qQ3lBBMazmffARLQgi1UlwT9JQWBrRh3lKs1q1eZjE/3sf6ogLTsKKpJzLRHdkRSEkiRks
	rSSx76wmL4IGC2PTJPNo3mVgZ9GhuSG/YZ42QQM5XtW9Eit447JRrlTwhst/q9uV1wNmBJ
	geQh1cCNft7q/CywTGXgImyIvC8STzM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QW8hqhTX8yt3ss6p2bOWGGDZ9wC8Lyuga+9TEJk5CV4=; b=s0+rC5/i9gW3LxcmgWafV8OQWE
	vDEp1UTgRc78+/yvEPR8UhfkKJpJ0vn1Kqkq76ofg4PLf3g7/zPpYiB8fb6aGV8HNI+vTzC+BiEDH
	vlVPnqbxH5d4CR64Xn514viQfl6RQFxfV0aNWHX95LE/euA3e6MKITSyfmlS+cquWEYpNkFReYnoV
	C9INQOG1UB+FqQBQ7QTl9TY1HmdjhRcOLTKF29yEN95SuNkgSlmD70JhBXO91Sk8koXkqo1skjewG
	d/LIikObCArWjaq+NeyoaDnNaGhEy5Hi4kOWGTcnjfRXxXSJ2UvpD5sI4TTDAlkgFSw0rfdP8NOb5
	hEdQETXQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unzED-00000005wkl-2XGW;
	Mon, 18 Aug 2025 12:44:45 +0000
Date: Mon, 18 Aug 2025 13:44:45 +0100
From: Matthew Wilcox <willy@infradead.org>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 166/188] arch/arm/mm/flush.c:307:41: error:
 incompatible pointer types passing 'memdesc_flags_t *' to parameter of type
 'volatile unsigned long *'
Message-ID: <aKMgPRLD-WnkPxYm@casper.infradead.org>
References: <202508181807.zhZF5TQ0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508181807.zhZF5TQ0-lkp@intel.com>
X-Rspamd-Queue-Id: 2D00314000E
X-Stat-Signature: ziquh55p7ks75zhzkrrmzg9otdingcj7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755521088-829409
X-HE-Meta: U2FsdGVkX1/IH0KYubNHGh3EIvcYWsm/Kkr1rm947u1ct+ViYs01C1vmNP36bReqO71aw2pK0VLx0+J8JT5DZU43kDO34MYgHWA2klxtdRdlGi7R3wbzuCVGIsrNAXagl/d36C4mm6Zf07578UTIWqJw/rEUBZD9qmA0Fch9HVrzR5VCmYL6YssLOP9+0TAyQ3flf9qklChzCDWthQBCWZOti5PAZ5BSLfu3ryk0F8p7GzgvjKb3YNnDpxqbVPBd+uZBzyR0NQcBZ682Nv5+VgpowmPCyLtCuP9QlulrhJd9nvI64zPQg5HLufUhHCcEgR4YNr0YEHpQnktMBQLYxRBi8H0VvXPj+0EqNCpuQr5zs46qkLl3yAq7wSJ00v6T5J4UtvgK8yrq+/755yTtrk+y/Ar+ZiX37iQpWrVPrFZhm9DU3JQ36VELJA4BGUodWxz+xHjDQsjjq6nlqIpEp065hIS5EPtjZ9BxLAaCDqLdsD9Y/4PF7FmWMbYMLtVCfmU1bNFjWr/0gkw/kku9gYhLD5w9jPAvdcPsMn6NYX2XMwBQMZfCB31KKgFo3zRFz9FcUo1/qZhxW3q+R0mXvKnKOAIWoa6Z6Xr3bqkaeZvmFI+oelD6GkfyNZ+rd+Q/Da+bQbrWp5Ql3XZ26GUvL21W/e+pmHSL4wGS9lg7iCsnHWxwwxj3mftcvyYTHjjR5t9Qka0Dh4tQf/0C6UqJsukdnWZHpAR/kaJonIc/7p/+9F9cOIJ9A1ORmrZMs1du5BEqkwWc4x6rtf/Zr4EdgmW8oNWfwl1j/QJgNeruezQkuDAuXq9osrbQObZiBFN3RXvp6i1wTRbBuUM1DliMSFYPu9Yf+c3mHaiWMm7e09lAyjgo3FoKpVMXVO9HIT4M8439ft+6yJH9pHNXOjSdq60LP2srkWREsK5gx423rYmnBdlUkCeMWp/2R92ES1CZ5OT6NAoGKpQ2SKRtCnq
 j82m8AKr
 GcARWi9TIoOBulUZ0wdVsVKu77HcsTLEcX2IR15HLPTvghBOxY3veG8qWV5bLymgwIaXn5422E9x6TC067XGZGsEZARtDwqZ5K/D+3Lazsg5tWM1qyn+KrBHb+SlBYtB5kAlHdPYmQVpNQnmWy2qdV36fsoR2Qigd3/DGVYtfkHO0SI42mWGteNVuOUTFxrXY2QWi4sC5xszUfEJ0lrbPBfRW1DLjYgzHmkIdVz5c012MnHQlfEhFYV97daGS+vayFRct1haeg80WkSzKaP4KCo5Z/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 06:17:13PM +0800, kernel test robot wrote:
> >> arch/arm/mm/flush.c:307:41: error: incompatible pointer types passing 'memdesc_flags_t *' to parameter of type 'volatile unsigned long *' [-Werror,-Wincompatible-pointer-types]

There's a lot of similar things to fix across a lot of architectures
and I don't have cross-compilers for all of them.  You're going to get
a lot of errors here, so if you can add this patch to the tree before
testing on the dozens of builds you're going to try, you'll save
both of us a lot of time.

From c3b882bf4a14d6fcf6cf8be533bee4251ade8040 Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 18 Aug 2025 08:42:22 -0400
Subject: [PATCH] fixes

---
 arch/arc/mm/cache.c                    |  8 ++++----
 arch/arc/mm/tlb.c                      |  2 +-
 arch/arm/include/asm/hugetlb.h         |  2 +-
 arch/arm/mm/copypage-v4mc.c            |  2 +-
 arch/arm/mm/copypage-v6.c              |  2 +-
 arch/arm/mm/copypage-xscale.c          |  2 +-
 arch/arm/mm/dma-mapping.c              |  2 +-
 arch/arm/mm/fault-armv.c               |  2 +-
 arch/arm/mm/flush.c                    | 10 +++++-----
 arch/arm64/include/asm/hugetlb.h       |  6 +++---
 arch/arm64/include/asm/mte.h           | 16 ++++++++--------
 arch/arm64/mm/flush.c                  |  8 ++++----
 arch/csky/abiv1/cacheflush.c           |  6 +++---
 arch/nios2/mm/cacheflush.c             |  6 +++---
 arch/openrisc/include/asm/cacheflush.h |  2 +-
 arch/openrisc/mm/cache.c               |  2 +-
 arch/parisc/kernel/cache.c             |  6 +++---
 arch/powerpc/include/asm/cacheflush.h  |  4 ++--
 arch/powerpc/include/asm/kvm_ppc.h     |  4 ++--
 arch/powerpc/mm/book3s64/hash_utils.c  |  4 ++--
 arch/powerpc/mm/pgtable.c              | 12 ++++++------
 arch/riscv/include/asm/cacheflush.h    |  4 ++--
 arch/riscv/include/asm/hugetlb.h       |  2 +-
 arch/riscv/mm/cacheflush.c             |  4 ++--
 arch/s390/include/asm/hugetlb.h        |  2 +-
 arch/s390/kernel/uv.c                  | 12 ++++++------
 arch/s390/mm/gmap.c                    |  2 +-
 arch/s390/mm/hugetlbpage.c             |  2 +-
 arch/sh/include/asm/hugetlb.h          |  2 +-
 arch/sh/mm/cache-sh4.c                 |  2 +-
 arch/sh/mm/cache-sh7705.c              |  2 +-
 arch/sh/mm/cache.c                     | 14 +++++++-------
 arch/sh/mm/kmap.c                      |  2 +-
 arch/sparc/mm/init_64.c                | 10 +++++-----
 arch/xtensa/mm/cache.c                 | 12 ++++++------
 35 files changed, 90 insertions(+), 90 deletions(-)

diff --git a/arch/arc/mm/cache.c b/arch/arc/mm/cache.c
index 9106ceac323c..7d2f93dc1e91 100644
--- a/arch/arc/mm/cache.c
+++ b/arch/arc/mm/cache.c
@@ -704,7 +704,7 @@ static inline void arc_slc_enable(void)
 
 void flush_dcache_folio(struct folio *folio)
 {
-	clear_bit(PG_dc_clean, &folio->flags);
+	clear_bit(PG_dc_clean, &folio->flags.f);
 	return;
 }
 EXPORT_SYMBOL(flush_dcache_folio);
@@ -889,8 +889,8 @@ void copy_user_highpage(struct page *to, struct page *from,
 
 	copy_page(kto, kfrom);
 
-	clear_bit(PG_dc_clean, &dst->flags);
-	clear_bit(PG_dc_clean, &src->flags);
+	clear_bit(PG_dc_clean, &dst->flags.f);
+	clear_bit(PG_dc_clean, &src->flags.f);
 
 	kunmap_atomic(kto);
 	kunmap_atomic(kfrom);
@@ -900,7 +900,7 @@ void clear_user_page(void *to, unsigned long u_vaddr, struct page *page)
 {
 	struct folio *folio = page_folio(page);
 	clear_page(to);
-	clear_bit(PG_dc_clean, &folio->flags);
+	clear_bit(PG_dc_clean, &folio->flags.f);
 }
 EXPORT_SYMBOL(clear_user_page);
 
diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
index cae4a7aae0ed..ed6915ba76ec 100644
--- a/arch/arc/mm/tlb.c
+++ b/arch/arc/mm/tlb.c
@@ -488,7 +488,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 	 */
 	if (vma->vm_flags & VM_EXEC) {
 		struct folio *folio = page_folio(page);
-		int dirty = !test_and_set_bit(PG_dc_clean, &folio->flags);
+		int dirty = !test_and_set_bit(PG_dc_clean, &folio->flags.f);
 		if (dirty) {
 			unsigned long offset = offset_in_folio(folio, paddr);
 			nr = folio_nr_pages(folio);
diff --git a/arch/arm/include/asm/hugetlb.h b/arch/arm/include/asm/hugetlb.h
index b766c4b373f6..700055b1ccb3 100644
--- a/arch/arm/include/asm/hugetlb.h
+++ b/arch/arm/include/asm/hugetlb.h
@@ -17,7 +17,7 @@
 
 static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_dcache_clean, &folio->flags);
+	clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 #define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
diff --git a/arch/arm/mm/copypage-v4mc.c b/arch/arm/mm/copypage-v4mc.c
index 7ddd82b9fe8b..ed843bb22020 100644
--- a/arch/arm/mm/copypage-v4mc.c
+++ b/arch/arm/mm/copypage-v4mc.c
@@ -67,7 +67,7 @@ void v4_mc_copy_user_highpage(struct page *to, struct page *from,
 	struct folio *src = page_folio(from);
 	void *kto = kmap_atomic(to);
 
-	if (!test_and_set_bit(PG_dcache_clean, &src->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &src->flags.f))
 		__flush_dcache_folio(folio_flush_mapping(src), src);
 
 	raw_spin_lock(&minicache_lock);
diff --git a/arch/arm/mm/copypage-v6.c b/arch/arm/mm/copypage-v6.c
index a1a71f36d850..0710dba5c0bf 100644
--- a/arch/arm/mm/copypage-v6.c
+++ b/arch/arm/mm/copypage-v6.c
@@ -73,7 +73,7 @@ static void v6_copy_user_highpage_aliasing(struct page *to,
 	unsigned int offset = CACHE_COLOUR(vaddr);
 	unsigned long kfrom, kto;
 
-	if (!test_and_set_bit(PG_dcache_clean, &src->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &src->flags.f))
 		__flush_dcache_folio(folio_flush_mapping(src), src);
 
 	/* FIXME: not highmem safe */
diff --git a/arch/arm/mm/copypage-xscale.c b/arch/arm/mm/copypage-xscale.c
index f1e29d3e8193..e16af68d709f 100644
--- a/arch/arm/mm/copypage-xscale.c
+++ b/arch/arm/mm/copypage-xscale.c
@@ -87,7 +87,7 @@ void xscale_mc_copy_user_highpage(struct page *to, struct page *from,
 	struct folio *src = page_folio(from);
 	void *kto = kmap_atomic(to);
 
-	if (!test_and_set_bit(PG_dcache_clean, &src->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &src->flags.f))
 		__flush_dcache_folio(folio_flush_mapping(src), src);
 
 	raw_spin_lock(&minicache_lock);
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 88c2d68a69c9..08641a936394 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -718,7 +718,7 @@ static void __dma_page_dev_to_cpu(struct page *page, unsigned long off,
 			if (size < sz)
 				break;
 			if (!offset)
-				set_bit(PG_dcache_clean, &folio->flags);
+				set_bit(PG_dcache_clean, &folio->flags.f);
 			offset = 0;
 			size -= sz;
 			if (!size)
diff --git a/arch/arm/mm/fault-armv.c b/arch/arm/mm/fault-armv.c
index 39fd5df73317..91e488767783 100644
--- a/arch/arm/mm/fault-armv.c
+++ b/arch/arm/mm/fault-armv.c
@@ -203,7 +203,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 
 	folio = page_folio(pfn_to_page(pfn));
 	mapping = folio_flush_mapping(folio);
-	if (!test_and_set_bit(PG_dcache_clean, &folio->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &folio->flags.f))
 		__flush_dcache_folio(mapping, folio);
 	if (mapping) {
 		if (cache_is_vivt())
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 5219158d54cf..19470d938b23 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -304,7 +304,7 @@ void __sync_icache_dcache(pte_t pteval)
 	else
 		mapping = NULL;
 
-	if (!test_and_set_bit(PG_dcache_clean, &folio->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &folio->flags.f))
 		__flush_dcache_folio(mapping, folio);
 
 	if (pte_exec(pteval))
@@ -343,8 +343,8 @@ void flush_dcache_folio(struct folio *folio)
 		return;
 
 	if (!cache_ops_need_broadcast() && cache_is_vipt_nonaliasing()) {
-		if (test_bit(PG_dcache_clean, &folio->flags))
-			clear_bit(PG_dcache_clean, &folio->flags);
+		if (test_bit(PG_dcache_clean, &folio->flags.f))
+			clear_bit(PG_dcache_clean, &folio->flags.f);
 		return;
 	}
 
@@ -352,14 +352,14 @@ void flush_dcache_folio(struct folio *folio)
 
 	if (!cache_ops_need_broadcast() &&
 	    mapping && !folio_mapped(folio))
-		clear_bit(PG_dcache_clean, &folio->flags);
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 	else {
 		__flush_dcache_folio(mapping, folio);
 		if (mapping && cache_is_vivt())
 			__flush_dcache_aliases(mapping, folio);
 		else if (mapping)
 			__flush_icache_all();
-		set_bit(PG_dcache_clean, &folio->flags);
+		set_bit(PG_dcache_clean, &folio->flags.f);
 	}
 }
 EXPORT_SYMBOL(flush_dcache_folio);
diff --git a/arch/arm64/include/asm/hugetlb.h b/arch/arm64/include/asm/hugetlb.h
index 2a8155c4a882..44c1f757bfcf 100644
--- a/arch/arm64/include/asm/hugetlb.h
+++ b/arch/arm64/include/asm/hugetlb.h
@@ -21,12 +21,12 @@ extern bool arch_hugetlb_migration_supported(struct hstate *h);
 
 static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_dcache_clean, &folio->flags);
+	clear_bit(PG_dcache_clean, &folio->flags.f);
 
 #ifdef CONFIG_ARM64_MTE
 	if (system_supports_mte()) {
-		clear_bit(PG_mte_tagged, &folio->flags);
-		clear_bit(PG_mte_lock, &folio->flags);
+		clear_bit(PG_mte_tagged, &folio->flags.f);
+		clear_bit(PG_mte_lock, &folio->flags.f);
 	}
 #endif
 }
diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 6567df8ec8ca..3b5069f4683d 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -48,12 +48,12 @@ static inline void set_page_mte_tagged(struct page *page)
 	 * before the page flags update.
 	 */
 	smp_wmb();
-	set_bit(PG_mte_tagged, &page->flags);
+	set_bit(PG_mte_tagged, &page->flags.f);
 }
 
 static inline bool page_mte_tagged(struct page *page)
 {
-	bool ret = test_bit(PG_mte_tagged, &page->flags);
+	bool ret = test_bit(PG_mte_tagged, &page->flags.f);
 
 	VM_WARN_ON_ONCE(folio_test_hugetlb(page_folio(page)));
 
@@ -82,7 +82,7 @@ static inline bool try_page_mte_tagging(struct page *page)
 {
 	VM_WARN_ON_ONCE(folio_test_hugetlb(page_folio(page)));
 
-	if (!test_and_set_bit(PG_mte_lock, &page->flags))
+	if (!test_and_set_bit(PG_mte_lock, &page->flags.f))
 		return true;
 
 	/*
@@ -90,7 +90,7 @@ static inline bool try_page_mte_tagging(struct page *page)
 	 * already. Check if the PG_mte_tagged flag has been set or wait
 	 * otherwise.
 	 */
-	smp_cond_load_acquire(&page->flags, VAL & (1UL << PG_mte_tagged));
+	smp_cond_load_acquire(&page->flags.f, VAL & (1UL << PG_mte_tagged));
 
 	return false;
 }
@@ -173,13 +173,13 @@ static inline void folio_set_hugetlb_mte_tagged(struct folio *folio)
 	 * before the folio flags update.
 	 */
 	smp_wmb();
-	set_bit(PG_mte_tagged, &folio->flags);
+	set_bit(PG_mte_tagged, &folio->flags.f);
 
 }
 
 static inline bool folio_test_hugetlb_mte_tagged(struct folio *folio)
 {
-	bool ret = test_bit(PG_mte_tagged, &folio->flags);
+	bool ret = test_bit(PG_mte_tagged, &folio->flags.f);
 
 	VM_WARN_ON_ONCE(!folio_test_hugetlb(folio));
 
@@ -196,7 +196,7 @@ static inline bool folio_try_hugetlb_mte_tagging(struct folio *folio)
 {
 	VM_WARN_ON_ONCE(!folio_test_hugetlb(folio));
 
-	if (!test_and_set_bit(PG_mte_lock, &folio->flags))
+	if (!test_and_set_bit(PG_mte_lock, &folio->flags.f))
 		return true;
 
 	/*
@@ -204,7 +204,7 @@ static inline bool folio_try_hugetlb_mte_tagging(struct folio *folio)
 	 * already. Check if the PG_mte_tagged flag has been set or wait
 	 * otherwise.
 	 */
-	smp_cond_load_acquire(&folio->flags, VAL & (1UL << PG_mte_tagged));
+	smp_cond_load_acquire(&folio->flags.f, VAL & (1UL << PG_mte_tagged));
 
 	return false;
 }
diff --git a/arch/arm64/mm/flush.c b/arch/arm64/mm/flush.c
index 013eead9b695..fbf08b543c3f 100644
--- a/arch/arm64/mm/flush.c
+++ b/arch/arm64/mm/flush.c
@@ -53,11 +53,11 @@ void __sync_icache_dcache(pte_t pte)
 {
 	struct folio *folio = page_folio(pte_page(pte));
 
-	if (!test_bit(PG_dcache_clean, &folio->flags)) {
+	if (!test_bit(PG_dcache_clean, &folio->flags.f)) {
 		sync_icache_aliases((unsigned long)folio_address(folio),
 				    (unsigned long)folio_address(folio) +
 					    folio_size(folio));
-		set_bit(PG_dcache_clean, &folio->flags);
+		set_bit(PG_dcache_clean, &folio->flags.f);
 	}
 }
 EXPORT_SYMBOL_GPL(__sync_icache_dcache);
@@ -69,8 +69,8 @@ EXPORT_SYMBOL_GPL(__sync_icache_dcache);
  */
 void flush_dcache_folio(struct folio *folio)
 {
-	if (test_bit(PG_dcache_clean, &folio->flags))
-		clear_bit(PG_dcache_clean, &folio->flags);
+	if (test_bit(PG_dcache_clean, &folio->flags.f))
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 EXPORT_SYMBOL(flush_dcache_folio);
 
diff --git a/arch/csky/abiv1/cacheflush.c b/arch/csky/abiv1/cacheflush.c
index 171e8fb32285..4bc0aad3cf8a 100644
--- a/arch/csky/abiv1/cacheflush.c
+++ b/arch/csky/abiv1/cacheflush.c
@@ -25,12 +25,12 @@ void flush_dcache_folio(struct folio *folio)
 	mapping = folio_flush_mapping(folio);
 
 	if (mapping && !folio_mapped(folio))
-		clear_bit(PG_dcache_clean, &folio->flags);
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 	else {
 		dcache_wbinv_all();
 		if (mapping)
 			icache_inv_all();
-		set_bit(PG_dcache_clean, &folio->flags);
+		set_bit(PG_dcache_clean, &folio->flags.f);
 	}
 }
 EXPORT_SYMBOL(flush_dcache_folio);
@@ -56,7 +56,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 		return;
 
 	folio = page_folio(pfn_to_page(pfn));
-	if (!test_and_set_bit(PG_dcache_clean, &folio->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &folio->flags.f))
 		dcache_wbinv_all();
 
 	if (folio_flush_mapping(folio)) {
diff --git a/arch/nios2/mm/cacheflush.c b/arch/nios2/mm/cacheflush.c
index 0ee9c5f02e08..8321182eb927 100644
--- a/arch/nios2/mm/cacheflush.c
+++ b/arch/nios2/mm/cacheflush.c
@@ -187,7 +187,7 @@ void flush_dcache_folio(struct folio *folio)
 
 	/* Flush this page if there are aliases. */
 	if (mapping && !mapping_mapped(mapping)) {
-		clear_bit(PG_dcache_clean, &folio->flags);
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 	} else {
 		__flush_dcache_folio(folio);
 		if (mapping) {
@@ -195,7 +195,7 @@ void flush_dcache_folio(struct folio *folio)
 			flush_aliases(mapping, folio);
 			flush_icache_range(start, start + folio_size(folio));
 		}
-		set_bit(PG_dcache_clean, &folio->flags);
+		set_bit(PG_dcache_clean, &folio->flags.f);
 	}
 }
 EXPORT_SYMBOL(flush_dcache_folio);
@@ -227,7 +227,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 		return;
 
 	folio = page_folio(pfn_to_page(pfn));
-	if (!test_and_set_bit(PG_dcache_clean, &folio->flags))
+	if (!test_and_set_bit(PG_dcache_clean, &folio->flags.f))
 		__flush_dcache_folio(folio);
 
 	mapping = folio_flush_mapping(folio);
diff --git a/arch/openrisc/include/asm/cacheflush.h b/arch/openrisc/include/asm/cacheflush.h
index 0e60af486ec1..cd8f971c0fec 100644
--- a/arch/openrisc/include/asm/cacheflush.h
+++ b/arch/openrisc/include/asm/cacheflush.h
@@ -75,7 +75,7 @@ static inline void sync_icache_dcache(struct page *page)
 
 static inline void flush_dcache_folio(struct folio *folio)
 {
-	clear_bit(PG_dc_clean, &folio->flags);
+	clear_bit(PG_dc_clean, &folio->flags.f);
 }
 #define flush_dcache_folio flush_dcache_folio
 
diff --git a/arch/openrisc/mm/cache.c b/arch/openrisc/mm/cache.c
index 0f265b8e73ec..f33df46dae4e 100644
--- a/arch/openrisc/mm/cache.c
+++ b/arch/openrisc/mm/cache.c
@@ -83,7 +83,7 @@ void update_cache(struct vm_area_struct *vma, unsigned long address,
 {
 	unsigned long pfn = pte_val(*pte) >> PAGE_SHIFT;
 	struct folio *folio = page_folio(pfn_to_page(pfn));
-	int dirty = !test_and_set_bit(PG_dc_clean, &folio->flags);
+	int dirty = !test_and_set_bit(PG_dc_clean, &folio->flags.f);
 
 	/*
 	 * Since icaches do not snoop for updated data on OpenRISC, we
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 37ca484cc495..4c5240d3a3c7 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -122,10 +122,10 @@ void __update_cache(pte_t pte)
 	pfn = folio_pfn(folio);
 	nr = folio_nr_pages(folio);
 	if (folio_flush_mapping(folio) &&
-	    test_bit(PG_dcache_dirty, &folio->flags)) {
+	    test_bit(PG_dcache_dirty, &folio->flags.f)) {
 		while (nr--)
 			flush_kernel_dcache_page_addr(pfn_va(pfn + nr));
-		clear_bit(PG_dcache_dirty, &folio->flags);
+		clear_bit(PG_dcache_dirty, &folio->flags.f);
 	} else if (parisc_requires_coherency())
 		while (nr--)
 			flush_kernel_dcache_page_addr(pfn_va(pfn + nr));
@@ -481,7 +481,7 @@ void flush_dcache_folio(struct folio *folio)
 	pgoff_t pgoff;
 
 	if (mapping && !mapping_mapped(mapping)) {
-		set_bit(PG_dcache_dirty, &folio->flags);
+		set_bit(PG_dcache_dirty, &folio->flags.f);
 		return;
 	}
 
diff --git a/arch/powerpc/include/asm/cacheflush.h b/arch/powerpc/include/asm/cacheflush.h
index f2656774aaa9..1fea42928f64 100644
--- a/arch/powerpc/include/asm/cacheflush.h
+++ b/arch/powerpc/include/asm/cacheflush.h
@@ -40,8 +40,8 @@ static inline void flush_dcache_folio(struct folio *folio)
 	if (cpu_has_feature(CPU_FTR_COHERENT_ICACHE))
 		return;
 	/* avoid an atomic op if possible */
-	if (test_bit(PG_dcache_clean, &folio->flags))
-		clear_bit(PG_dcache_clean, &folio->flags);
+	if (test_bit(PG_dcache_clean, &folio->flags.f))
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 #define flush_dcache_folio flush_dcache_folio
 
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index ca3829d47ab7..0953f2daa466 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -939,9 +939,9 @@ static inline void kvmppc_mmu_flush_icache(kvm_pfn_t pfn)
 
 	/* Clear i-cache for new pages */
 	folio = page_folio(pfn_to_page(pfn));
-	if (!test_bit(PG_dcache_clean, &folio->flags)) {
+	if (!test_bit(PG_dcache_clean, &folio->flags.f)) {
 		flush_dcache_icache_folio(folio);
-		set_bit(PG_dcache_clean, &folio->flags);
+		set_bit(PG_dcache_clean, &folio->flags.f);
 	}
 }
 
diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index 4693c464fc5a..3aee3af614af 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1562,11 +1562,11 @@ unsigned int hash_page_do_lazy_icache(unsigned int pp, pte_t pte, int trap)
 	folio = page_folio(pte_page(pte));
 
 	/* page is dirty */
-	if (!test_bit(PG_dcache_clean, &folio->flags) &&
+	if (!test_bit(PG_dcache_clean, &folio->flags.f) &&
 	    !folio_test_reserved(folio)) {
 		if (trap == INTERRUPT_INST_STORAGE) {
 			flush_dcache_icache_folio(folio);
-			set_bit(PG_dcache_clean, &folio->flags);
+			set_bit(PG_dcache_clean, &folio->flags.f);
 		} else
 			pp |= HPTE_R_N;
 	}
diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index dfaa9fd86f7e..56d7e8960e77 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -87,9 +87,9 @@ static pte_t set_pte_filter_hash(pte_t pte, unsigned long addr)
 		struct folio *folio = maybe_pte_to_folio(pte);
 		if (!folio)
 			return pte;
-		if (!test_bit(PG_dcache_clean, &folio->flags)) {
+		if (!test_bit(PG_dcache_clean, &folio->flags.f)) {
 			flush_dcache_icache_folio(folio);
-			set_bit(PG_dcache_clean, &folio->flags);
+			set_bit(PG_dcache_clean, &folio->flags.f);
 		}
 	}
 	return pte;
@@ -127,13 +127,13 @@ static inline pte_t set_pte_filter(pte_t pte, unsigned long addr)
 		return pte;
 
 	/* If the page clean, we move on */
-	if (test_bit(PG_dcache_clean, &folio->flags))
+	if (test_bit(PG_dcache_clean, &folio->flags.f))
 		return pte;
 
 	/* If it's an exec fault, we flush the cache and make it clean */
 	if (is_exec_fault()) {
 		flush_dcache_icache_folio(folio);
-		set_bit(PG_dcache_clean, &folio->flags);
+		set_bit(PG_dcache_clean, &folio->flags.f);
 		return pte;
 	}
 
@@ -175,12 +175,12 @@ static pte_t set_access_flags_filter(pte_t pte, struct vm_area_struct *vma,
 		goto bail;
 
 	/* If the page is already clean, we move on */
-	if (test_bit(PG_dcache_clean, &folio->flags))
+	if (test_bit(PG_dcache_clean, &folio->flags.f))
 		goto bail;
 
 	/* Clean the page and set PG_dcache_clean */
 	flush_dcache_icache_folio(folio);
-	set_bit(PG_dcache_clean, &folio->flags);
+	set_bit(PG_dcache_clean, &folio->flags.f);
 
  bail:
 	return pte_mkexec(pte);
diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm/cacheflush.h
index 6086b38d5427..0092513c3376 100644
--- a/arch/riscv/include/asm/cacheflush.h
+++ b/arch/riscv/include/asm/cacheflush.h
@@ -23,8 +23,8 @@ static inline void local_flush_icache_range(unsigned long start,
 
 static inline void flush_dcache_folio(struct folio *folio)
 {
-	if (test_bit(PG_dcache_clean, &folio->flags))
-		clear_bit(PG_dcache_clean, &folio->flags);
+	if (test_bit(PG_dcache_clean, &folio->flags.f))
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 #define flush_dcache_folio flush_dcache_folio
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
diff --git a/arch/riscv/include/asm/hugetlb.h b/arch/riscv/include/asm/hugetlb.h
index 446126497768..0872d43fc0c0 100644
--- a/arch/riscv/include/asm/hugetlb.h
+++ b/arch/riscv/include/asm/hugetlb.h
@@ -7,7 +7,7 @@
 
 static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_dcache_clean, &folio->flags);
+	clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 #define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
diff --git a/arch/riscv/mm/cacheflush.c b/arch/riscv/mm/cacheflush.c
index 4ca5aafce22e..d83a612464f6 100644
--- a/arch/riscv/mm/cacheflush.c
+++ b/arch/riscv/mm/cacheflush.c
@@ -101,9 +101,9 @@ void flush_icache_pte(struct mm_struct *mm, pte_t pte)
 {
 	struct folio *folio = page_folio(pte_page(pte));
 
-	if (!test_bit(PG_dcache_clean, &folio->flags)) {
+	if (!test_bit(PG_dcache_clean, &folio->flags.f)) {
 		flush_icache_mm(mm, false);
-		set_bit(PG_dcache_clean, &folio->flags);
+		set_bit(PG_dcache_clean, &folio->flags.f);
 	}
 }
 #endif /* CONFIG_MMU */
diff --git a/arch/s390/include/asm/hugetlb.h b/arch/s390/include/asm/hugetlb.h
index 931fcc413598..69131736daaa 100644
--- a/arch/s390/include/asm/hugetlb.h
+++ b/arch/s390/include/asm/hugetlb.h
@@ -39,7 +39,7 @@ static inline pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 
 static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_arch_1, &folio->flags);
+	clear_bit(PG_arch_1, &folio->flags.f);
 }
 #define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 47f574cd1728..93b2a01bae40 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -144,7 +144,7 @@ int uv_destroy_folio(struct folio *folio)
 	folio_get(folio);
 	rc = uv_destroy(folio_to_phys(folio));
 	if (!rc)
-		clear_bit(PG_arch_1, &folio->flags);
+		clear_bit(PG_arch_1, &folio->flags.f);
 	folio_put(folio);
 	return rc;
 }
@@ -193,7 +193,7 @@ int uv_convert_from_secure_folio(struct folio *folio)
 	folio_get(folio);
 	rc = uv_convert_from_secure(folio_to_phys(folio));
 	if (!rc)
-		clear_bit(PG_arch_1, &folio->flags);
+		clear_bit(PG_arch_1, &folio->flags.f);
 	folio_put(folio);
 	return rc;
 }
@@ -289,7 +289,7 @@ static int __make_folio_secure(struct folio *folio, struct uv_cb_header *uvcb)
 	expected = expected_folio_refs(folio) + 1;
 	if (!folio_ref_freeze(folio, expected))
 		return -EBUSY;
-	set_bit(PG_arch_1, &folio->flags);
+	set_bit(PG_arch_1, &folio->flags.f);
 	/*
 	 * If the UVC does not succeed or fail immediately, we don't want to
 	 * loop for long, or we might get stall notifications.
@@ -483,18 +483,18 @@ int arch_make_folio_accessible(struct folio *folio)
 	 *    convert_to_secure.
 	 * As secure pages are never large folios, both variants can co-exists.
 	 */
-	if (!test_bit(PG_arch_1, &folio->flags))
+	if (!test_bit(PG_arch_1, &folio->flags.f))
 		return 0;
 
 	rc = uv_pin_shared(folio_to_phys(folio));
 	if (!rc) {
-		clear_bit(PG_arch_1, &folio->flags);
+		clear_bit(PG_arch_1, &folio->flags.f);
 		return 0;
 	}
 
 	rc = uv_convert_from_secure(folio_to_phys(folio));
 	if (!rc) {
-		clear_bit(PG_arch_1, &folio->flags);
+		clear_bit(PG_arch_1, &folio->flags.f);
 		return 0;
 	}
 
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index c7defe4ed1f6..8ff6bba107e8 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2272,7 +2272,7 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 	start = pmd_val(*pmd) & HPAGE_MASK;
 	end = start + HPAGE_SIZE;
 	__storage_key_init_range(start, end);
-	set_bit(PG_arch_1, &folio->flags);
+	set_bit(PG_arch_1, &folio->flags.f);
 	cond_resched();
 	return 0;
 }
diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index e88c02c9e642..72e8fa136af5 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -155,7 +155,7 @@ static void clear_huge_pte_skeys(struct mm_struct *mm, unsigned long rste)
 		paddr = rste & PMD_MASK;
 	}
 
-	if (!test_and_set_bit(PG_arch_1, &folio->flags))
+	if (!test_and_set_bit(PG_arch_1, &folio->flags.f))
 		__storage_key_init_range(paddr, paddr + size);
 }
 
diff --git a/arch/sh/include/asm/hugetlb.h b/arch/sh/include/asm/hugetlb.h
index 4a92e6e4d627..974512f359f0 100644
--- a/arch/sh/include/asm/hugetlb.h
+++ b/arch/sh/include/asm/hugetlb.h
@@ -14,7 +14,7 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 
 static inline void arch_clear_hugetlb_flags(struct folio *folio)
 {
-	clear_bit(PG_dcache_clean, &folio->flags);
+	clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 #define arch_clear_hugetlb_flags arch_clear_hugetlb_flags
 
diff --git a/arch/sh/mm/cache-sh4.c b/arch/sh/mm/cache-sh4.c
index 46393b00137e..83fb34b39ca7 100644
--- a/arch/sh/mm/cache-sh4.c
+++ b/arch/sh/mm/cache-sh4.c
@@ -114,7 +114,7 @@ static void sh4_flush_dcache_folio(void *arg)
 	struct address_space *mapping = folio_flush_mapping(folio);
 
 	if (mapping && !mapping_mapped(mapping))
-		clear_bit(PG_dcache_clean, &folio->flags);
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 	else
 #endif
 	{
diff --git a/arch/sh/mm/cache-sh7705.c b/arch/sh/mm/cache-sh7705.c
index b509a407588f..71f8be9fc8e0 100644
--- a/arch/sh/mm/cache-sh7705.c
+++ b/arch/sh/mm/cache-sh7705.c
@@ -138,7 +138,7 @@ static void sh7705_flush_dcache_folio(void *arg)
 	struct address_space *mapping = folio_flush_mapping(folio);
 
 	if (mapping && !mapping_mapped(mapping))
-		clear_bit(PG_dcache_clean, &folio->flags);
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 	else {
 		unsigned long pfn = folio_pfn(folio);
 		unsigned int i, nr = folio_nr_pages(folio);
diff --git a/arch/sh/mm/cache.c b/arch/sh/mm/cache.c
index 6ebdeaff3021..c3f028bed049 100644
--- a/arch/sh/mm/cache.c
+++ b/arch/sh/mm/cache.c
@@ -64,14 +64,14 @@ void copy_to_user_page(struct vm_area_struct *vma, struct page *page,
 	struct folio *folio = page_folio(page);
 
 	if (boot_cpu_data.dcache.n_aliases && folio_mapped(folio) &&
-	    test_bit(PG_dcache_clean, &folio->flags)) {
+	    test_bit(PG_dcache_clean, &folio->flags.f)) {
 		void *vto = kmap_coherent(page, vaddr) + (vaddr & ~PAGE_MASK);
 		memcpy(vto, src, len);
 		kunmap_coherent(vto);
 	} else {
 		memcpy(dst, src, len);
 		if (boot_cpu_data.dcache.n_aliases)
-			clear_bit(PG_dcache_clean, &folio->flags);
+			clear_bit(PG_dcache_clean, &folio->flags.f);
 	}
 
 	if (vma->vm_flags & VM_EXEC)
@@ -85,14 +85,14 @@ void copy_from_user_page(struct vm_area_struct *vma, struct page *page,
 	struct folio *folio = page_folio(page);
 
 	if (boot_cpu_data.dcache.n_aliases && folio_mapped(folio) &&
-	    test_bit(PG_dcache_clean, &folio->flags)) {
+	    test_bit(PG_dcache_clean, &folio->flags.f)) {
 		void *vfrom = kmap_coherent(page, vaddr) + (vaddr & ~PAGE_MASK);
 		memcpy(dst, vfrom, len);
 		kunmap_coherent(vfrom);
 	} else {
 		memcpy(dst, src, len);
 		if (boot_cpu_data.dcache.n_aliases)
-			clear_bit(PG_dcache_clean, &folio->flags);
+			clear_bit(PG_dcache_clean, &folio->flags.f);
 	}
 }
 
@@ -105,7 +105,7 @@ void copy_user_highpage(struct page *to, struct page *from,
 	vto = kmap_atomic(to);
 
 	if (boot_cpu_data.dcache.n_aliases && folio_mapped(src) &&
-	    test_bit(PG_dcache_clean, &src->flags)) {
+	    test_bit(PG_dcache_clean, &src->flags.f)) {
 		vfrom = kmap_coherent(from, vaddr);
 		copy_page(vto, vfrom);
 		kunmap_coherent(vfrom);
@@ -148,7 +148,7 @@ void __update_cache(struct vm_area_struct *vma,
 
 	if (pfn_valid(pfn)) {
 		struct folio *folio = page_folio(pfn_to_page(pfn));
-		int dirty = !test_and_set_bit(PG_dcache_clean, &folio->flags);
+		int dirty = !test_and_set_bit(PG_dcache_clean, &folio->flags.f);
 		if (dirty)
 			__flush_purge_region(folio_address(folio),
 						folio_size(folio));
@@ -162,7 +162,7 @@ void __flush_anon_page(struct page *page, unsigned long vmaddr)
 
 	if (pages_do_alias(addr, vmaddr)) {
 		if (boot_cpu_data.dcache.n_aliases && folio_mapped(folio) &&
-		    test_bit(PG_dcache_clean, &folio->flags)) {
+		    test_bit(PG_dcache_clean, &folio->flags.f)) {
 			void *kaddr;
 
 			kaddr = kmap_coherent(page, vmaddr);
diff --git a/arch/sh/mm/kmap.c b/arch/sh/mm/kmap.c
index fa50e8f6e7a9..c9f32d5a54b8 100644
--- a/arch/sh/mm/kmap.c
+++ b/arch/sh/mm/kmap.c
@@ -31,7 +31,7 @@ void *kmap_coherent(struct page *page, unsigned long addr)
 	enum fixed_addresses idx;
 	unsigned long vaddr;
 
-	BUG_ON(!test_bit(PG_dcache_clean, &folio->flags));
+	BUG_ON(!test_bit(PG_dcache_clean, &folio->flags.f));
 
 	preempt_disable();
 	pagefault_disable();
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 7ed58bf3aaca..df9f7c444c39 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -224,7 +224,7 @@ inline void flush_dcache_folio_impl(struct folio *folio)
 	((1UL<<ilog2(roundup_pow_of_two(NR_CPUS)))-1UL)
 
 #define dcache_dirty_cpu(folio) \
-	(((folio)->flags >> PG_dcache_cpu_shift) & PG_dcache_cpu_mask)
+	(((folio)->flags.f >> PG_dcache_cpu_shift) & PG_dcache_cpu_mask)
 
 static inline void set_dcache_dirty(struct folio *folio, int this_cpu)
 {
@@ -243,7 +243,7 @@ static inline void set_dcache_dirty(struct folio *folio, int this_cpu)
 			     "bne,pn	%%xcc, 1b\n\t"
 			     " nop"
 			     : /* no outputs */
-			     : "r" (mask), "r" (non_cpu_bits), "r" (&folio->flags)
+			     : "r" (mask), "r" (non_cpu_bits), "r" (&folio->flags.f)
 			     : "g1", "g7");
 }
 
@@ -265,7 +265,7 @@ static inline void clear_dcache_dirty_cpu(struct folio *folio, unsigned long cpu
 			     " nop\n"
 			     "2:"
 			     : /* no outputs */
-			     : "r" (cpu), "r" (mask), "r" (&folio->flags),
+			     : "r" (cpu), "r" (mask), "r" (&folio->flags.f),
 			       "i" (PG_dcache_cpu_mask),
 			       "i" (PG_dcache_cpu_shift)
 			     : "g1", "g7");
@@ -292,7 +292,7 @@ static void flush_dcache(unsigned long pfn)
 		struct folio *folio = page_folio(page);
 		unsigned long pg_flags;
 
-		pg_flags = folio->flags;
+		pg_flags = folio->flags.f;
 		if (pg_flags & (1UL << PG_dcache_dirty)) {
 			int cpu = ((pg_flags >> PG_dcache_cpu_shift) &
 				   PG_dcache_cpu_mask);
@@ -480,7 +480,7 @@ void flush_dcache_folio(struct folio *folio)
 
 	mapping = folio_flush_mapping(folio);
 	if (mapping && !mapping_mapped(mapping)) {
-		bool dirty = test_bit(PG_dcache_dirty, &folio->flags);
+		bool dirty = test_bit(PG_dcache_dirty, &folio->flags.f);
 		if (dirty) {
 			int dirty_cpu = dcache_dirty_cpu(folio);
 
diff --git a/arch/xtensa/mm/cache.c b/arch/xtensa/mm/cache.c
index 23be0e7516ce..5354df52d61f 100644
--- a/arch/xtensa/mm/cache.c
+++ b/arch/xtensa/mm/cache.c
@@ -134,8 +134,8 @@ void flush_dcache_folio(struct folio *folio)
 	 */
 
 	if (mapping && !mapping_mapped(mapping)) {
-		if (!test_bit(PG_arch_1, &folio->flags))
-			set_bit(PG_arch_1, &folio->flags);
+		if (!test_bit(PG_arch_1, &folio->flags.f))
+			set_bit(PG_arch_1, &folio->flags.f);
 		return;
 
 	} else {
@@ -232,7 +232,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 
 #if (DCACHE_WAY_SIZE > PAGE_SIZE)
 
-	if (!folio_test_reserved(folio) && test_bit(PG_arch_1, &folio->flags)) {
+	if (!folio_test_reserved(folio) && test_bit(PG_arch_1, &folio->flags.f)) {
 		unsigned long phys = folio_pfn(folio) * PAGE_SIZE;
 		unsigned long tmp;
 
@@ -247,10 +247,10 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 		}
 		preempt_enable();
 
-		clear_bit(PG_arch_1, &folio->flags);
+		clear_bit(PG_arch_1, &folio->flags.f);
 	}
 #else
-	if (!folio_test_reserved(folio) && !test_bit(PG_arch_1, &folio->flags)
+	if (!folio_test_reserved(folio) && !test_bit(PG_arch_1, &folio->flags.f)
 	    && (vma->vm_flags & VM_EXEC) != 0) {
 		for (i = 0; i < nr; i++) {
 			void *paddr = kmap_local_folio(folio, i * PAGE_SIZE);
@@ -258,7 +258,7 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 			__invalidate_icache_page((unsigned long)paddr);
 			kunmap_local(paddr);
 		}
-		set_bit(PG_arch_1, &folio->flags);
+		set_bit(PG_arch_1, &folio->flags.f);
 	}
 #endif
 }
-- 
2.47.2



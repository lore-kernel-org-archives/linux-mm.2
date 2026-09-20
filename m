Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACFDC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 07:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78EEE6B0088; Sun, 20 Sep 2026 03:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740396B008A; Sun, 20 Sep 2026 03:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6555A6B008C; Sun, 20 Sep 2026 03:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2CE6B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:04:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1DEE403BC
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:04:42 +0000 (UTC)
X-FDA: 85233252804.27.87BB16B
Received: from mta0.migadu.com (out-94.mta0.migadu.com [91.218.175.94])
	by imf16.hostedemail.com (Postfix) with ESMTP id A89BA180007
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 07:04:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YcGvSh8Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YcGvSh8Q;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.94 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789887881;
	b=SV4+wvtl+sJADoAEol6yNvhP3xLoOuI05GsnUWSaNoHxWjWzc6bsynFsoGfakbHoFi4WpQ
	wLWxxLEq9O/nD4eLSRhv0502tc6psLGeJxrycA05ZnoPdiC2OJE9tQQWC8xszEJFjW9yKQ
	vQqwf1FYg7LJroz9B52ywESfe85DtW8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789887881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bM6amltTQhBYPAMN5a79kJyFJcFla3bjsxZnRyljbew=;
	b=HCTjfNVxhZ1W2YIoTGWktx8IV4STgXlspsL3wVo95HNKt55hpfuXJ833/id+oCqjgeHFXc
	iXPT/hdeAVN3lbYdFSQjKbWneSZmkskPmF/eWWHlUjKSWN/4LHmFEOh+R1iUrVUIwTCfSz
	NRqmPS3AbvVb6PUk1/hIUNy2sf3VdLA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jIL5Xm0hBwRJq72+13iYyBKNUWWSaRe7RMggUGRje9U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789887878; v=1; x=1790492678;
 b=YcGvSh8QsWadQB0J+34j8xfNqv5nMkEJSQzAOxQT6GAzk8K1uktWkjhY03kKaFJz7dxoRUCD
 rQqNQRrnpZVQNk65eQLwAsmc5OlJjgJiMStY9eZRQHOzUS8JblST78ioZGc2cBXaErh3S+Df0LT
 9ZHr4fF0IRbyMTNgTsWAe5hE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cd1bdbb1ac128f27;
	Sun, 20 Sep 2026 07:04:38 +0000
X-Mizu-Trace-ID: cd1bdbb1ac128f27
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Muchun Song <muchun.song@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH] mm: Add CONFIG_SPARSEMEM_CLASSIC
Date: Sun, 20 Sep 2026 15:04:06 +0800
Message-ID: <20260920070406.95354-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A89BA180007
X-Stat-Signature: 4idgnmx6osm17rh8ke8ik3mnbhtwzzr3
X-Rspamd-Server: rspam01
X-HE-Tag: 1789887880-679261
X-HE-Meta: U2FsdGVkX19WCsCgTiIaMju/ASGZPMg2QSwC3YF1+M1S2ksQ9WFZUfekjWczbe45SQr+JCoWtITtEo12pXWUBZuTcqTA3tmp79WHCBdg71n5l5wyGHMAv6K3REeImGylvUNUkr7Ex6qYsaOPWOabMLOiTHBDzXBy6mfqU3nuALXkBBNpD1b2pvE54E78kiYWMasbWKJx4L90DvKkOZkbkDrs28SHOHeFm6JyBDy064MH89GQtTwgE/0ydnalzYlgRfkQq1bssPfz3ZORUiZSS/125XiQ2nW/e2pp6EBiEHskknR8u+XKeg0mbCX7JhwSSYCP20Ac20o1qSwQzPaVbeZK2ZExJ+B/FGglK4B0FtUP3gP9ZVyaj2SeBsnhi0L7sI359Cfl1RqhB7D7ME4ut4itqUBy7F7I32iutxIfXmZjPRS/AoLkAdL4Nt+jfmoYfUOyb01f35TjSR7+ofXJFWTUAYtrrdPiZINlhI+eHRr4aZLFxAIQW/esPvLssPCrUMQZUFTJQh9Ub0IKu/P371CtzBL7yT8y7NyQe8gzbzKG1qxME4BUE4pOG+L1lFjY09sptjw2640b6nSl3zwgYGfC8UC3+PBQzi2/xGN3gv/6shr57i83tVu7miUM7D+41Vl0Uz2EJofxfDNt5QxKEtCJBXMjL+XItpGSkN4j/bQzeFfydr7Sq0UDFFIq7WBG2O2Km9E9MzoiXgJAJn9BfhT0NanyrWI5Re9OSiX/9QIIxzn8fu1oBdSGoy6NXL6Vuv4j5lNcejPrLvazTf6h0pFYTRi7zwBCAzNN0Ot+yn2TDhWYKhTTdAhIdteUin6QvxV/QDmBAVpNFG8tpgc2CRF1nvtpYdLyT0G5vf6ZyGgwK7ciNulyEWUEd9khHwk/5XzBN5gedakrTyQvtPz/ytl66T6h/KFnqlT7/Z7QcQwsW04NlqhV0nH6Zx5O+kMIPjvFlvv+fzxbzEzaNk6
 B48s7hGM
 THObDiNenwk65v+GKq/Kg1I96h+o5p5cU3bOD+baOBBZifkgCKSF/WQCnf/628iO3T7/mVbQxte23WJBsxdYJWsbnjtVYpVzwmJfOZABp2rQHGKDV0ukrLa8F3DxKZFq98V3OKP26tHe2y2yx9r2oq+poTlGBJXEmk4u8KVydg8bGWueGUM5ilsJjsr+Hb/5LMWLjrf/peHvp3lmdS6t19KF+lWqxGgIzOzV+yUU4JhjVNs4C/CWPd2UVZRb7YFT+DQVMTfTtM5H7BXubyS1tC3O9XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Several MM paths identify classic sparse memory by testing
CONFIG_SPARSEMEM while also testing that CONFIG_SPARSEMEM_VMEMMAP is
disabled. Repeating the compound condition obscures the memory model being
selected and requires the local SECTION_IN_PAGE_FLAGS alias for the same
state.

Add CONFIG_SPARSEMEM_CLASSIC as a hidden derived option and use it at the
conditional sites. Remove SECTION_IN_PAGE_FLAGS and test the new option
directly.

The x86 32-bit vDSO build starts with the x86_64 configuration and then
undefines CONFIG_SPARSEMEM_VMEMMAP to emulate a 32-bit configuration.
Kconfig-derived symbols are not recomputed by the C preprocessor, so define
CONFIG_SPARSEMEM_CLASSIC there when CONFIG_SPARSEMEM is enabled. This
preserves the existing behavior.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  3 +++
 include/linux/mm.h                            | 12 ++++--------
 include/linux/mmzone.h                        |  2 +-
 include/linux/page-flags-layout.h             |  2 +-
 mm/Kconfig                                    |  3 +++
 mm/util.c                                     |  2 +-
 6 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
index 72a92cb9b53d..3e07389c4d2b 100644
--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
+++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -20,6 +20,9 @@
 #define CONFIG_PAGE_OFFSET 0
 #define CONFIG_ILLEGAL_POINTER_VALUE 0
 #define CONFIG_NR_CPUS 1
+#ifdef CONFIG_SPARSEMEM
+#define CONFIG_SPARSEMEM_CLASSIC 1
+#endif
 
 #define BUILD_VDSO32_64
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ae56d6a2c9f9..b786ee73a20f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -201,7 +201,7 @@ static inline void __mm_zero_struct_page(struct page *page)
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef CONFIG_SPARSEMEM_CLASSIC
 bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
 #else
 static inline bool page_range_contiguous(const struct page *page,
@@ -2531,10 +2531,6 @@ static inline bool is_nommu_shared_vma_flags(const vma_flags_t *flags)
 }
 #endif
 
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
-#define SECTION_IN_PAGE_FLAGS
-#endif
-
 /*
  * The identification function is mainly used by the buddy allocator for
  * determining if two pages could be buddies. We are not really identifying
@@ -2805,7 +2801,7 @@ static inline struct zone *folio_zone(const struct folio *folio)
 	return &folio_pgdat(folio)->node_zones[folio_zonenum(folio)];
 }
 
-#ifdef SECTION_IN_PAGE_FLAGS
+#ifdef CONFIG_SPARSEMEM_CLASSIC
 static inline void set_page_section(struct page *page, unsigned long section)
 {
 	page->flags.f &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
@@ -2823,7 +2819,7 @@ static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 	ASSERT_EXCLUSIVE_BITS(mdf->f, SECTIONS_MASK << SECTIONS_PGSHIFT);
 	return (mdf->f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
 }
-#else /* !SECTION_IN_PAGE_FLAGS */
+#else /* !CONFIG_SPARSEMEM_CLASSIC */
 static inline void set_page_section_from_pfn(struct page *page,
 		unsigned long pfn)
 {
@@ -2833,7 +2829,7 @@ static inline unsigned long memdesc_section(const memdesc_flags_t *mdf)
 {
 	return 0;
 }
-#endif /* SECTION_IN_PAGE_FLAGS */
+#endif /* CONFIG_SPARSEMEM_CLASSIC */
 
 /**
  * folio_pfn - Return the Page Frame Number of a folio.
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ebbda6f31139..c83529ad6e35 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -68,7 +68,7 @@
  * memory sections).
  */
 #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
-#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#elif defined(CONFIG_SPARSEMEM_CLASSIC)
 /*
  * Only pages within a single memory section are guaranteed to be
  * contiguous. By limiting folios to a single memory section, all folio
diff --git a/include/linux/page-flags-layout.h b/include/linux/page-flags-layout.h
index 760006b1c480..536003b364a7 100644
--- a/include/linux/page-flags-layout.h
+++ b/include/linux/page-flags-layout.h
@@ -49,7 +49,7 @@
  *      " plus space for last_cpupid: | SECTION | NODE | ZONE | LAST_CPUPID ... | FLAGS |
  * classic sparse no space for node:  | SECTION |     ZONE    | ... | FLAGS |
  */
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef CONFIG_SPARSEMEM_CLASSIC
 #define SECTIONS_WIDTH		SECTIONS_SHIFT
 #else
 #define SECTIONS_WIDTH		0
diff --git a/mm/Kconfig b/mm/Kconfig
index 30170a936f1f..c7bbcf086f21 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -461,6 +461,9 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config SPARSEMEM_CLASSIC
+	def_bool SPARSEMEM && !SPARSEMEM_VMEMMAP
+
 config VMEMMAP_OPTIMIZATION
 	bool
 	depends on SPARSEMEM_VMEMMAP
diff --git a/mm/util.c b/mm/util.c
index c5ee52aede1e..6910b47ca415 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1590,7 +1590,7 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 }
 #endif /* CONFIG_MMU */
 
-#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+#ifdef CONFIG_SPARSEMEM_CLASSIC
 /**
  * page_range_contiguous - test whether the page range is contiguous
  * @page: the start of the page range.
-- 
2.54.0 (Apple Git-157)



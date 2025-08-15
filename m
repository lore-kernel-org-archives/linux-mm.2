Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D04CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951F390021E; Fri, 15 Aug 2025 04:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902288E0002; Fri, 15 Aug 2025 04:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818A690021E; Fri, 15 Aug 2025 04:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 681D28E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:56:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AB3D160882
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:27 +0000 (UTC)
X-FDA: 83778385614.28.E7BE8B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 827DF40008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:56:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVwW9tmb5gTq+YlEpTle3BPj+uH7Ei3te9pgTf125wg=;
	b=m8iRkAiRMm+0+OjGuS0eKgzrDLab6biOPsuQYbASoAOTm7rV/dcEyVDcgfOHMytGFhK6lq
	AeFUP/OvUsf+5waGOc1wy1qMXzxCWFPGGLB8FW/eQl3gEPtsL+wCipy6LOFbFy3aT7iP/3
	wBlCvp7ZgtD2c37xY27w5GSW7XYapXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248185; a=rsa-sha256;
	cv=none;
	b=2cEZM/ggWQXx4VOCpqwxo/HMy1fIRaj8BPUQbS8u4uMCKjmMnAtss8DFouK7AoWRHGrC8t
	zZPo34GKmJH+DLIBDDCd3t6RW3i002RRKDnf1Bfln+SgzhSjXFw/ioQu4wBbWCxqineqo7
	jrfTdLyVjgSIGtJD5iwYoU2P11zxwD4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 834CF497;
	Fri, 15 Aug 2025 01:56:16 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28E7A3F63F;
	Fri, 15 Aug 2025 01:56:20 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 12/18] mm: Allow __pagetable_ctor() to fail
Date: Fri, 15 Aug 2025 09:55:06 +0100
Message-ID: <20250815085512.2182322-13-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 827DF40008
X-Stat-Signature: mdzwdhzy5jtm3bbu7pxoggj3ru9b3gzu
X-Rspam-User: 
X-HE-Tag: 1755248185-195988
X-HE-Meta: U2FsdGVkX1/jD3h3SDDXRDMMYczyiVXAgIJGFA1ha6kdKrWP0nVuatwk6EyYxGhvLFDwC6AGaabS/2wFLdhoGA0PClwBTRCTkocBS+T6x3TmXQqg2tt444+ffLpngACpQxG2xXGcUbFN8wOSn6mIwql1NyY9svmj7aCQq3xupNMsoNpaH4xRrGyvVCcEGmghZ2pSfc5fVg3MPZHDmWVgTkdxmmEGD3KzsvKge/GREazMaW4Jk6mBM9ivUPmOTIz/cZk63WxE+RNkXUkcolxcykRb73DWmUwYlWWibhujoK2v79nmRghIXQDxeWDEc/M2jeg5mBJLKRkacdbYQnIXsrxSv5+lpDN5aqSp0q/YJO9l4lX8Pbaenr5BTn8wuNuZDdlb2dPM86EfS+u/M42uzkoZyb4vSwkIyiLGNvbCTy0zCbLMG/QqCEg9frBhw4FsV0pUtWb8Ba/leX5lKDwBJ99qeBcaGsgqptnwOo/nG2MSfn311ufSCNZTFUGnQPzw/cqvvNtYBx2UVbWhVknROTxK23Hv+jL/38kr1+s0b8FRP3kDBLsYX+44nw6v5E+T5iTGi0bo0PVTqlAWJNG7EMq2kuzAybjMcAkmNuGBa9V1rqYLsB8++YbLDKwdfbyjIyIWxkgbm9vDs2zoQsRJfM6QyoQbeciq95lFGhspnxqP1L3Pcs0NcWdPtakcR/sZ/3hsiYnC0kRkj9NkrFUYCK/HNg2s7N5cjYFEeoM+hwZTk1BYW02Q5LTOhWYwez0Dp/YAkBlZazib7y2+Wwy2qSbVmRoBNE/BFQMfELSgo6zp/3cWmkUhWcT3uQwSLUBTH1GKxBfHD0C5SLZoTMzf7BAUi4pYIF50zJ8kKB/WGo8eMehM5fSl376KGUHgsnwCZJ/8mefrR/IKRdMUx7DsOhuR2Vq8kQ8o7qrqiZCyBL0+BLE2k1kZ2Q0HkUfPqsHqBTM1dLffmQ9rHXAQHJ9
 65inmGyG
 4znCZaDINGgOAONQ13KXgbVbA8uL8y9p2+ZhL1hq86JzJwTlvQjBXI+U9h/H4R9RCVpp3BCW7Vg/pJuuWoMPFYyEZx7TXZaIgwgvgfg3tne39+UE9KGwnGyGv060rDK9NptytudmJTL3F6vOXwgFqMXkNSS5ksl/ztiH/hwhNhoq+6JQWaR38Tyrgs/RFRe/82WLJrAbpGXs49xteAI1KmHiuyxT+cXpEwbtztzn3jWccSPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for adding construction hooks (that may fail) to
__pagetable_ctor(), make __pagetable_ctor() return a bool,
propagate it to pagetable_*_ctor() and handle failure in
the generic {pud,p4d,pgd}_alloc.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/asm-generic/pgalloc.h | 15 ++++++++++++---
 include/linux/mm.h            | 21 ++++++++++-----------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 3c8ec3bfea44..3e184f3ca37a 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -178,7 +178,10 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
 	if (!ptdesc)
 		return NULL;
 
-	pagetable_pud_ctor(ptdesc);
+	if (!pagetable_pud_ctor(ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
+	}
 	return ptdesc_address(ptdesc);
 }
 #define __pud_alloc_one(...)	alloc_hooks(__pud_alloc_one_noprof(__VA_ARGS__))
@@ -232,7 +235,10 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
 	if (!ptdesc)
 		return NULL;
 
-	pagetable_p4d_ctor(ptdesc);
+	if (!pagetable_p4d_ctor(ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
+	}
 	return ptdesc_address(ptdesc);
 }
 #define __p4d_alloc_one(...)	alloc_hooks(__p4d_alloc_one_noprof(__VA_ARGS__))
@@ -276,7 +282,10 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
 	if (!ptdesc)
 		return NULL;
 
-	pagetable_pgd_ctor(ptdesc);
+	if (!pagetable_pgd_ctor(ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
+	}
 	return ptdesc_address(ptdesc);
 }
 #define __pgd_alloc(...)	alloc_hooks(__pgd_alloc_noprof(__VA_ARGS__))
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f4dd96f3db91..d9371d992033 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2973,12 +2973,13 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
-static inline void __pagetable_ctor(struct ptdesc *ptdesc)
+static inline bool __pagetable_ctor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
 
 	__folio_set_pgtable(folio);
 	lruvec_stat_add_folio(folio, NR_PAGETABLE);
+	return true;
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
@@ -3001,8 +3002,7 @@ static inline bool pagetable_pte_ctor(struct mm_struct *mm,
 {
 	if (mm != &init_mm && !ptlock_init(ptdesc))
 		return false;
-	__pagetable_ctor(ptdesc);
-	return true;
+	return __pagetable_ctor(ptdesc);
 }
 
 pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp);
@@ -3109,8 +3109,7 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
 	if (mm != &init_mm && !pmd_ptlock_init(ptdesc))
 		return false;
 	ptdesc_pmd_pts_init(ptdesc);
-	__pagetable_ctor(ptdesc);
-	return true;
+	return __pagetable_ctor(ptdesc);
 }
 
 /*
@@ -3132,19 +3131,19 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
 	return ptl;
 }
 
-static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
+static inline bool pagetable_pud_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
+	return __pagetable_ctor(ptdesc);
 }
 
-static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
+static inline bool pagetable_p4d_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
+	return __pagetable_ctor(ptdesc);
 }
 
-static inline void pagetable_pgd_ctor(struct ptdesc *ptdesc)
+static inline bool pagetable_pgd_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
+	return __pagetable_ctor(ptdesc);
 }
 
 extern void __init pagecache_init(void);
-- 
2.47.0



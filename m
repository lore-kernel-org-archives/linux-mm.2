Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B972F3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75BC6B00D3; Sun,  5 Apr 2026 08:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4CCB6B00D4; Sun,  5 Apr 2026 08:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62D16B00D5; Sun,  5 Apr 2026 08:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B80736B00D3
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:57:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A90613BF87
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:01 +0000 (UTC)
X-FDA: 84624502242.10.7F5B553
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9BC8820011
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:56:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Tws3ok9I;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393819; a=rsa-sha256;
	cv=none;
	b=KxTughOa/rD5NSAcs6xJMO5NaYw1fYlFr58j/X2lcZzuFjtTrChgdQHA5RhayyH8qQmVbs
	W3MTfLVlNYoI4Eei4KOagq6r+j+zCnOtbfnxbWOGDmOMSWNZThnhUb8+AwnoJyd3DQ5lj4
	BemjlcHuj6yRo11kNeCbpXpADhTxiIc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Tws3ok9I;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6htym6+MXjsCESpIggFByDAobBonwD3F5r0quJbwaas=;
	b=FNNqIRlkizcKw51AuS9UdAGTPjDEG+bTeQr90GajC8ttjr/ydmndi753xz6TLHND79cXN2
	M1rC7HY2S6VNNDfjK2ty699Q/hh/0IyCly7Bz+SXYhZy8HN7Q0NWKT3IpaYanntialEpf+
	MCBbKJi5fvTNhTj43XbCiD9Z4GAfeh0=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-358ed696623so1323540a91.0
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393818; x=1775998618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6htym6+MXjsCESpIggFByDAobBonwD3F5r0quJbwaas=;
        b=Tws3ok9I/DQ6guKvD8VAVV8RX/p5kjaTlA81VRHKYC7mRRx369F+9yXzMwLF5EZiMA
         PN3IrBxcUrs9k3hYIi0H8Oy4c80lwtIfUM4Pg2dP2yuT/yz0dgd0s+J+S13FylCbFp3H
         cc37ZML5nJYq1wggdGx7qXaAWKhGhtap0HY89MXOhbZzAHg15KCLXSRb1UI3zZEap7VZ
         3WSL3V0mV0psT80dBhuAkkvN4nQd/blzsXSy78XbJJ8FGWaUM++0yGuttaT+Lctn0pqb
         TdC3UIbj2aBxWJUBJwrmD3Vcs1p3ln3T+VYpqsjhoDEgOPWyTiEBN4HhLOz6xFElY0h4
         pVWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393818; x=1775998618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6htym6+MXjsCESpIggFByDAobBonwD3F5r0quJbwaas=;
        b=K7s6Mu6H7Gs8MLSU0nC3srNwiPCnqNTeDJNTiAPmp3L43Ri+qBk9FTG9CDoTC/WbUH
         hJN0AHAUPFqo8KPvPkchdoH4h795KxXA+/Ixs28FfRxGCQRG76nGK6wScROVWKf5FIQg
         tO4HZFL4ms4o9HjduuzPuBrtq0fZqeHDw1kqWJpsOT5AWn0E+VJjrw/hIUT8qvBn6v9z
         IcgHNmUItzdatMPhKUXydeep2XsWBPZZXz+D/O8rGSbXD74QRd49jYvocsv0EAtqrxsX
         mzyaAjxw4a6d2WA4XPbfFazgHt5ZIr1esFhfXGJ4lKzj7pD9AZA5LG23rLjia+dR22jR
         B+ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDogSdmfOQ5qISph3z/pwKtvzms16POp18G+QpgJUIKHzzyrStTJePVV0QIQVTaq0lMD2KF1PjOA==@kvack.org
X-Gm-Message-State: AOJu0YyHKdH/Oo02mj8mAP0i0STVYREvtfI2En9oOH/kh8FFgPIPAd8r
	r6EGHHPafQPDyv2+84qI4i3uLHdM4TspooqA1ROymbOm5gYGLDkBlcB1/1NurK+P4fQ=
X-Gm-Gg: AeBDiesQp1kNqq9ZguFHKzV6Sd3T2YI/myDroyGUvQFFphooovoBauJyYJPOTrz+vkZ
	lUBC7w+9e8QaJbthsXGDXDXQoDGXdQAtQtxDDAqkXkJCN+V1eZxppxtehAHl+Wj9IvKEGgEt/Va
	1Ox+kDwdcD+gKV3x7TbZCOcIRh8P40sZ13tEFgzySYpQ+Tx6ymwK6Nfw5hJFYgt20S3wFGKKpNJ
	iSyykRGICBaFjNu/dij89qQwwlHIuRvcj7gK1o0/Ia+trOkIZiR4eV8ID0QUBCHlae+8s1BoDXm
	Uuy0SmAbTkWogvkoCDGmQHbebCmuENnDuP9cu+Py/HHKgkMn8wKCeu6YRziD0eXHKDjlx9uvfqd
	g/igLMuasKEk+8cm0/hTc4kmfgX2uE6GxVkerw22o8Mj+F9EB524IyDwPH7Chw3GJZDcNBY64Dc
	001BygLagnxCu+Fl5+hyCPnPFiAIfqsgP4NvSDdQjHkxo=
X-Received: by 2002:a17:90b:3809:b0:35d:9560:3efc with SMTP id 98e67ed59e1d1-35de68ce84bmr7967133a91.14.1775393818406;
        Sun, 05 Apr 2026 05:56:58 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:56:58 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 33/49] mm: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
Date: Sun,  5 Apr 2026 20:52:24 +0800
Message-Id: <20260405125240.2558577-34-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ubs9giny39a4i8yhuh3wc81xs5wnabg
X-Rspamd-Queue-Id: 9BC8820011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775393819-671195
X-HE-Meta: U2FsdGVkX19PH5f+tEl3T/w6Gx069yPTRqYlwEAhuJheitjeQ+WnGa4+vK5kEr8J5wRVcQQ8R0fML3GXJNXJ3zTIyTTzjcf+dWfwLcpeG7iXW6O/xcUo5geBpcUzNQCly5bU9/vAxbt9Qk/FCgKzIHrukalkZ/SsbTOqgGL+CjOJU7yxxdjn/XVOpnpsGXeQyor4jlC5UvdWHkSZ89C4MA5IuI92bPnaE0y0e9MxAg/v0BRZak26pekyOLE6zbZlSp09RKJq5K65IxEK4I1Xa2s97nskdrkUBF98u7AwhZsqxl79Yvs6+Qd8Z9N6uCebsyMH6ZTAmCugPAh/Ct/7LJ4G3yKYgL8P2fQM4YI7ITm6oiodv80N2ZKSKeYjFRvbDcoR9+JLlUQY44FtFUqR1cCQ6R80m3wChPMJElaix/lhxqS3/P5UWQIPvx/+WespDW2KEOa6fEPLYtTwpgCKr8WAshKS/+TsQp/km7DdJy0UGGj+fBTTTJeJ2qzfGDab4pyx5ARccwJAuQyy25Sl8+q7eSlPp+4kSo36bj8qp/M1Gpe7bPelVjqN0lF0GTGnASwin7tJbGCysi6Zi/ourRD7KP+O2S4QGlwYneiqwZmw9UqbJ2yN2CRUdEDwkRhE5KMp9qRZW1GC1PY+n8GT7WSCL2uZnmdoX53odDnyEcb8eTAW+xwuT5rxiXlwadivIkXt/eUkKv6ibbf3Aohdc7PmWYsyZsvPnNPrzCWe5vgA7p9q84bVN0yfV6b7LzIgvx5HPeRpRVYox4Xn+8XNUIs3H25Ce6UDbNS6jfpV63DsMGJnWV6+KaVqKuPiey4HIEt6d956ohWq4UJ2uNu/bT0ofVB65GU/edceOlrvtqoWIQ1m+XBc1PVg4umPP+j1CVC1RLoUOs9eoIgGkcEHjpBt6xqA+e+ppaxnHbMiLjLs9g9QOry2tMVtuz4d5Y+TYpsYvQhgGPS6lFKi9C7
 OtSRYCtO
 geT/Cykx3jWMoFwogvUKFib4TEfUBWJuN73r7mDNmdtrRaoaAgQna/G8UArdM++NrdQLC4YCOLxn++34IZGpuGOVwUU2eH2hzwn23pXyneO+FhJ6SaRov901IEXuVPOZbS1drh4rBrrux6pJESv6uuS/oQYJDxgEMS1A9AYh1VMfqaxgXiqvymcJKrtpx+d0P/3tdrAR6nBW6JeqNcSkXTl7kdOCeEmB+vzzTmX9UQIrlLORLECPWkMAAInVVkHCOGfdwRe/79kiuDBxSDToeIqzG4b9HLZQ4PCslU4R1uH5N002yqrEZ2A+HwEenpiSlrI4IBU91fNMFulljoZWHt18umvx2OwIvmx+vPfioa0stETR/Mtio1Wec70s/ame1PXxIGNYnn08mbLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, the vmemmap optimization logic in mm/sparse-vmemmap.c was
closely tied to HugeTLB via CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP.
With recent refactoring (e.g., introducing compound page order to struct
mem_section), the core vmemmap optimization machinery has become more
generic and can be utilized by other subsystems like DAX.

To reflect this generalization and decouple the core optimization logic
from HugeTLB-specific configurations, this patch introduces a new common
Kconfig option: CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION.

Both HugeTLB and DAX now select this generic option, ensuring that the
shared optimization infrastructure is enabled whenever either subsystem
requires it.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 fs/Kconfig                 |  1 +
 include/linux/mmzone.h     | 33 ++++++++++++++++++---------------
 include/linux/page-flags.h |  5 +----
 mm/Kconfig                 |  5 +++++
 4 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index e70aa5f0429a..9b56a90e13db 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -278,6 +278,7 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	def_bool HUGETLB_PAGE
 	depends on ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	depends on SPARSEMEM_VMEMMAP
+	select SPARSEMEM_VMEMMAP_OPTIMIZATION
 
 config HUGETLB_PMD_PAGE_TABLE_SHARING
 	def_bool HUGETLB_PAGE
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75425407e0c4..6edcb0cc46c4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -102,9 +102,9 @@
  *
  * HVO which is only active if the size of struct page is a power of 2.
  */
-#define MAX_FOLIO_VMEMMAP_ALIGN \
-	(IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP) && \
-	 is_power_of_2(sizeof(struct page)) ? \
+#define MAX_FOLIO_VMEMMAP_ALIGN					\
+	(IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION) &&	\
+	 is_power_of_2(sizeof(struct page)) ?			\
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
 /* The number of vmemmap pages required by a vmemmap-optimized folio. */
@@ -115,7 +115,8 @@
 
 #define __NR_OPTIMIZABLE_FOLIO_SIZES		(MAX_FOLIO_ORDER - OPTIMIZABLE_FOLIO_MIN_ORDER + 1)
 #define NR_OPTIMIZABLE_FOLIO_SIZES		\
-	(__NR_OPTIMIZABLE_FOLIO_SIZES > 0 ? __NR_OPTIMIZABLE_FOLIO_SIZES : 0)
+	((__NR_OPTIMIZABLE_FOLIO_SIZES > 0 &&	\
+	  IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? __NR_OPTIMIZABLE_FOLIO_SIZES : 0)
 
 enum migratetype {
 	MIGRATE_UNMOVABLE,
@@ -2014,7 +2015,7 @@ struct mem_section {
 	 */
 	struct page_ext *page_ext;
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 	/*
 	 * The order of compound pages in this section. Typically, the section
 	 * holds compound pages of this order; a larger compound page will span
@@ -2194,7 +2195,19 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
 	*pfn = (*pfn & PAGE_SECTION_MASK) + (bit * PAGES_PER_SUBSECTION);
 	return true;
 }
+#else
+static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
+{
+	return 1;
+}
+
+static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long *pfn)
+{
+	return true;
+}
+#endif
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 static inline void section_set_order(struct mem_section *section, unsigned int order)
 {
 	VM_BUG_ON(section->order && order && section->order != order);
@@ -2206,16 +2219,6 @@ static inline unsigned int section_order(const struct mem_section *section)
 	return section->order;
 }
 #else
-static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
-{
-	return 1;
-}
-
-static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long *pfn)
-{
-	return true;
-}
-
 static inline void section_set_order(struct mem_section *section, unsigned int order)
 {
 }
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e03d816e8b9..12665b34586c 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -208,14 +208,11 @@ enum pageflags {
 static __always_inline bool compound_info_has_mask(void)
 {
 	/*
-	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
-	 * makes a difference.
-	 *
 	 * The approach with mask would work in the wider set of conditions,
 	 * but it requires validating that struct pages are naturally aligned
 	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
 	 */
-	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+	if (!IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION))
 		return false;
 
 	return is_power_of_2(sizeof(struct page));
diff --git a/mm/Kconfig b/mm/Kconfig
index 3cce862088f1..e81aa77182b2 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -410,12 +410,17 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config SPARSEMEM_VMEMMAP_OPTIMIZATION
+	bool
+	depends on SPARSEMEM_VMEMMAP
+
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
 #
 config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	bool
+	select SPARSEMEM_VMEMMAP_OPTIMIZATION if SPARSEMEM_VMEMMAP
 
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
-- 
2.20.1



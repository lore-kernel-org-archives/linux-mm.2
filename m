Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0394CD4F3F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C196B00DF; Wed, 13 May 2026 09:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533036B00E0; Wed, 13 May 2026 09:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449E16B00E1; Wed, 13 May 2026 09:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30CC76B00DF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F29E2A00FB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:04 +0000 (UTC)
X-FDA: 84762432048.16.961B3B7
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2D8EC1A0016
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hMUWFHs7;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LpwPxpfie30YAMOHUn6jeAG+IgoJLqSekICSQMqQJSE=;
	b=SFQ1x1SbixU4pNp8pWTzOOoX/fMD9EpqThXNIBL8hPQoHfX4ffVWe1dzorzhSFY/v/map0
	uCDi8Buf3nOUT192Ljzm+fmC5+Z83wLVi/LG7UhQ5p/epil5zHggygCwkrVuv1OfwoFmJt
	0ybjMRAmTFNJbIOILoVIJBfZvM0hXTA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hMUWFHs7;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677863; a=rsa-sha256;
	cv=none;
	b=FFmeYPyny23N2F4LWfmUI9duc5125iR1snszLQeBkRZebRB8g8zGBOeEl0wouYfpdCXgYm
	bshDoXg2kYhfEMEUf+wey1PotgSL41GG7RJjJsUVyEQbw/CWSUnZWEvYDUMb5pJyQa2gLL
	hW870wGcsEpEnWLM0D63Z+7Z03kIQNc=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ba3e3c4f87so61593675ad.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677862; x=1779282662; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpwPxpfie30YAMOHUn6jeAG+IgoJLqSekICSQMqQJSE=;
        b=hMUWFHs7NWnyRZVSay4A3W89dMiQ8kDLEfuVT9YxPBwNUkCKVVZU9yxISk9PtBS2Qz
         CyGFDiOdHxZ18mQ8/xKXXDPkGR9F6zjfFwzP+gzva/iKxyGs9zd213gYYpUcJztIXT/1
         SYP+kOoB5Dehqkhsui9hLtf8YLOY38OlLVAyvbHlrecY+BCagYBODHRtHys2gskS7pEN
         cy0yRnWsdye0my6Tnk4lWZTfO4COx2KdChq1L2Bt/TGTrp3WSdfEqsEP7VY5FsZm0zs3
         hqRB8Yw5Mf+250AdINqt7XPJpoehN3/eYnscv8wrUyPI6ZwB1luSMkB+euixDrhjJEe+
         NoPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677862; x=1779282662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LpwPxpfie30YAMOHUn6jeAG+IgoJLqSekICSQMqQJSE=;
        b=E/rAz75xqA92iYo9UZPiEru9MpmwPmVg1S9prQyFfEnOdeH3YtU2kFr3NqDlgCIv5e
         ZPRX/0Uamuj3ImJTYaHi/SCkjYilRCnfTI8IDyYPmVeHg3ncx/tvUolGmV0NIHRFzcdw
         Z4WKMOlB4MaGkOb5s68MeEiGV+Jvx7t+2MXBeCj5uDWSUfQ3c/KSaAa+kfDt5ZrS0I5k
         5hT/sS9P4rdnIqOnOwxwvwPKjjQQdzbybnbPsifqBeoa+QErGjEEjbv/j9AKOeD9HkKf
         bRRsSXj9Er3+tyv4DonBhGQy9WdOtTpipjBRKqzihmCChXOCzFZTxn9ZhvT6A4CfAS7H
         SE1Q==
X-Forwarded-Encrypted: i=1; AFNElJ8+o8FkhQ1J2MynnxtJ6UP2lJ1VDqdMAxuj9BMSX4rweg6YKH6NPhx9+zpNSlkKUxhT1z7onpu5LA==@kvack.org
X-Gm-Message-State: AOJu0YxYgFKpPR38jQRKDtqnLsphX6MwVOkwVrCFvaaPnW4gT4IQ0BIK
	VZPnKzzta9WaOt7KNSPGSElOBjusIIpRhF18eecKuR61XFZlALO3TE/niQKshyhwAm4=
X-Gm-Gg: Acq92OFhlbR/6De5zXAtOiSLrTfUlOUqhvm1EtUHi676m+r6l+dMAMNrNijcfMWplrc
	55+tZ99AMWgOzODK8TzSaAO7fQEyvGlfJPySoroHQFAA9HBJHAvy6K2szHaxW1rZYqCEG1in4F/
	1F9USRuUdBz2mVfSEZnQY0/YJaN2ubaOOqLmwemt+t6HEqdxtuS3woxHXcZ72gpj+W7boqjwNvK
	3ChX0DjQq1X/37DrinR98TeS8A8nPp0P9S6Hv5hQVHpZaRaLPXqr9vD7SlL7ZQgtCKWdSLfD3sE
	20F9y5+uRBqvzXIYtK3tSenUlEtAt4x6oviBwcOpYdZ0Gu0l4Nh7plKUTgQzS3B5e//FyKQiHBs
	ody+doBKN6Q6yrnUyPaJ/u6nSI8grwOGk6Dawze96vxq9BD1I7ZAjjqVxKqfFXj42dNPCm7oTzv
	Jwg3bc2wLq/E24AwXGs3vUqv8wD+BE8+SVigypA+/SwG3JhyjMc0A9brxcnYI=
X-Received: by 2002:a17:903:22d0:b0:2b7:abc0:3bd7 with SMTP id d9443c01a7336-2bd2716ecabmr35771225ad.9.1778677861863;
        Wed, 13 May 2026 06:11:01 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:11:01 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 38/69] mm/sparse-vmemmap: Introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
Date: Wed, 13 May 2026 21:05:06 +0800
Message-ID: <20260513130542.35604-39-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D8EC1A0016
X-Rspam-User: 
X-Stat-Signature: ushujgi1yyngxaadmjtk5krp37rpf3iz
X-HE-Tag: 1778677862-428562
X-HE-Meta: U2FsdGVkX18fqCeSkhGGPUWD7iDIAgXMqj+PsoHP4iNkkCr8htvDiSHtzoDiwBcV309SLkHxPmqnnyS9ilLPWv1wm9V/Tny8Rx+B3YNrfHUCxJxjLohkaaZ/oLITTOT6i3mF1xo6KcP/jI4zd9V2XbWKQWaTkaGIFew2osWdWz0AyaR3f2KKRAG48vJTDXizML1SHR5VzokqpOU43AhL3IYl61zuZBRVkO1if0/WwdBAvYyeAg+f/jNCpG292NQvxaMQSVbeQmHQJJVnEqENyNNJblLBk8uxxDOK5QUUlQPaXpNc1Ia/Be40dnvX92wViMEgFw5PMYBY4LFZjrKHB0lHo3YerrKIYHSlEnleN/Y3utYdUy33QQYR86S2889Ey9A5cg8J2z8F29IVx+c7t30zvQgUvOBqAUhe6P5rglQvJeydiSrZVAXBP+uD/IllGZy4Ap7io1uOevA4p+ZnJn7OOKezikyf26vj8pXvVdgiXz+bfrBHO88MlGC7ZLVjKgWrejclHm64SdMutUfXuDY/gLzrTlXTUNO3FTwdBKpgqCO5c3Y0CWbp+bESlC/V5e71MvyXEgANbOPE/FhF/NiixmO1mF+ArzWejwzAhF2dgM+cN5Qyks05ihvjNYik6fzbTKEZXyLn0KgSXpYuMDVaCNdN/qL3wVbzbj8vBj1IaFigoisQO/6FFrhRFWdwr3oK1bOGGqhyTi9GMYLiNtL47nILrZ4ZB/XLwz3u7OpIdUGiWjpCQ9dGZcvmVDcQe18ioX/m9I7F4y/sfA9igXIZIJi0hpzh9hIsZjyy810BWXgfZsKlGxlDKeCwe4kaA9WHibR2VJLAvyTv9EMQJvIOFpYx7G+nwHgTmZ6IdIs85Pbs/XRjOAkJIdxp/Xk+yXyt0HQwmnVRbB15GsEJDng74FIhV0+gs7uWpT5jSwpyraxmse0JfoMhFZxGNYgjRQXb4+OAiyK8vPu2pSU
 vpuWQDib
 zOiZy7UuIvgdUbRzyiVevDBKwcLYBJLycyHbj1Z9GQht0izUlEXFovaZRQUTgaou5QFWsGlODHt5XxEvNQ5zhk2yAfYbJrCpxq9TO2bkbrhVKUs6girROU94H5jEVit1yNUybxN/roEHgJKV1N0d7l6Yz6sY31MM3UVn6OU/eogH4lbFKFYpmA0BSiGLt/jjnE3VUr4xREj1KX/eip0OV6JwcVgVKu3vTB8eogrc8tNGfkISMTOXurEmIqp+A1Ys+ZN1HnD73NZMIDNOiNu0z5fGr4o0oe2NOQCToIyeQhyJhJ3/2vy6rLN34vf9pOcel8VvL6nvFJrKD9bs9qZSuCBAx2oKk7A/pZTf2DTFBHpTPqZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic sparse-vmemmap optimization code is still guarded by
CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP, even though it is no longer
HugeTLB-specific.

Introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION to represent the common
vmemmap optimization infrastructure.  Have HugeTLB and DAX select it,
and use it to guard generic optimization code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |  2 +-
 drivers/dax/Kconfig                           |  1 +
 fs/Kconfig                                    |  1 +
 include/linux/mmzone.h                        | 33 ++++++++++---------
 include/linux/page-flags.h                    |  5 +--
 mm/Kconfig                                    |  4 +++
 6 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
index bc3e549795c3..5f8424eade2b 100644
--- a/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
+++ b/arch/x86/entry/vdso/vdso32/fake_32bit_build.h
@@ -11,7 +11,7 @@
 #undef CONFIG_PGTABLE_LEVELS
 #undef CONFIG_ILLEGAL_POINTER_VALUE
 #undef CONFIG_SPARSEMEM_VMEMMAP
-#undef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+#undef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 #undef CONFIG_NR_CPUS
 #undef CONFIG_PARAVIRT_XXL
 
diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index 602f9a0839a9..60cb05dce53d 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -8,6 +8,7 @@ if DAX
 config DEV_DAX
 	tristate "Device DAX: direct access mapping device"
 	depends on TRANSPARENT_HUGEPAGE
+	select SPARSEMEM_VMEMMAP_OPTIMIZATION if ARCH_WANT_OPTIMIZE_DAX_VMEMMAP && SPARSEMEM_VMEMMAP
 	help
 	  Support raw access to differentiated (persistence, bandwidth,
 	  latency...) memory via an mmap(2) capable character
diff --git a/fs/Kconfig b/fs/Kconfig
index ccb9dd480523..f6cee1bbb1fc 100644
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
index 9b87d798a365..5285d53b0c53 100644
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
 
 #define __NR_OPTIMIZABLE_FOLIO_ORDERS		(MAX_FOLIO_ORDER - OPTIMIZABLE_FOLIO_MIN_ORDER + 1)
 #define NR_OPTIMIZABLE_FOLIO_ORDERS		\
-	(__NR_OPTIMIZABLE_FOLIO_ORDERS > 0 ? __NR_OPTIMIZABLE_FOLIO_ORDERS : 0)
+	((__NR_OPTIMIZABLE_FOLIO_ORDERS > 0 &&	\
+	  IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION)) ? __NR_OPTIMIZABLE_FOLIO_ORDERS : 0)
 
 static inline bool order_vmemmap_optimizable(unsigned int order)
 {
@@ -2033,7 +2034,7 @@ struct mem_section {
 	 */
 	struct page_ext *page_ext;
 #endif
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
 	/*
 	 * The order of compound pages in this section. Typically, the section
 	 * holds compound pages of this order; a larger compound page will span
@@ -2213,7 +2214,19 @@ static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long
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
 	VM_WARN_ON(section->order && order && section->order != order);
@@ -2225,16 +2238,6 @@ static inline unsigned int section_order(const struct mem_section *section)
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
index c26d2d2050d5..ddd10cb4d0a3 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -410,6 +410,10 @@ config SPARSEMEM_VMEMMAP
 	  pfn_to_page and page_to_pfn operations.  This is the most
 	  efficient option when sufficient kernel resources are available.
 
+config SPARSEMEM_VMEMMAP_OPTIMIZATION
+	bool
+	depends on SPARSEMEM_VMEMMAP
+
 #
 # Select this config option from the architecture Kconfig, if it is preferred
 # to enable the feature of HugeTLB/dev_dax vmemmap optimization.
-- 
2.54.0



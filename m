Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33D5FCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F368E0002; Mon,  1 Sep 2025 05:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0398E002D; Mon,  1 Sep 2025 05:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0D28E0002; Mon,  1 Sep 2025 05:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A710C8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74833BB46C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:49 +0000 (UTC)
X-FDA: 83840134098.05.9D7B360
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf13.hostedemail.com (Postfix) with ESMTP id ACDFB2000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=JKOk92D8;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718387; a=rsa-sha256;
	cv=none;
	b=kj1xLyJCfIlFZpSvaqqh1V9tFi5fskLBk+ZrlhUWerdpIey2Bsy6QvH6NMfb28CoakH7rs
	u1U7Zp6cxXDduoqVz2K0ClFbOz5Jv4EcURvdYB0TQAnuHWSEyAqw8QgxxDqQQUnH5roB46
	q01Ak9GgzzN9JrSPfX4emIzXuc+eOmk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=JKOk92D8;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6Ls6t35aYYluwAFtTSG43pL4pzA4jbKsfNN9ofH+0I=;
	b=wHeojUtvgDlg+nFaxhfK0af+RaPI/eO4aZJGgvLC3mfdZdW77B/i+YbHFPciQp3bVFcGRY
	FO32ATmr8ZVebIxCWj+O+pTNoMArSXuoAkk06WQLjBvMoKlBIpt/+l38aqtkd1nl7TbK6U
	Yc7w4M0T+ysOV31LdswRuwho0Iv1ssQ=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afede1b3d05so694670666b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718386; x=1757323186; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u6Ls6t35aYYluwAFtTSG43pL4pzA4jbKsfNN9ofH+0I=;
        b=JKOk92D8B7TnMs0eiUKWrX/dlZDFt6nVUPUK+56ezQper4Fb+SeciriaLWbOCaOeZb
         dRQnPvKU2k4SkCCZF8uiElhh94JLx8o1/R6sBMUyww3wrn2EhkuszZUcDkXfPTv3HlzH
         ty2c82mhbgSsJq6yQoRPgmHKRTBUasawJ3IUvR2S3ivYLF0W+S5baTgfDassI07cCCsn
         YIYlewv1ZM3UVu7xbO8h9tJAWUVqfWVJc2Ton4uXGmyVBWizUcQky3jjCsCHRAeIyHR4
         Yd8UK51VQ+W93r0y/AXoBq5OA2YfSZ0iHqoBCrHU3ACNY5KWN0VoLrm85UkXWjQkt0HO
         jJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718386; x=1757323186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u6Ls6t35aYYluwAFtTSG43pL4pzA4jbKsfNN9ofH+0I=;
        b=Ap4U0AONAwZq4PkpbSsmmm2VnKhRFvCZf0oNsJnfhdAXrLbEuYnFxEjFTPLsWPlwyL
         toqBUpzGImOmzA3vKq3ktN+IYzlGNL7PvOEQgvlm/zJ01mBNinHK0BqDXaPsLeue9yAi
         e2CWPLn0mH0q4Hb7ARVQtGGmlb+XPp9tt3xqIc2a4S8G2MdE8B6OAPWUi25Ah+oA1xtv
         c7fnF0DTzdgU0FQUwzDBFfXMIAMT/oMrvoNGyM1IaOx+ofuZ2ovGRbgSBynZvj5rrlm/
         N4VMM7Jb7+i+eKR/eNtry9eSWeRqeR0QFWiVGZq8tAhrKYoZhQnsfLfKRLaX7wQs/6CJ
         OVjQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsO3Bh4YCPSj0OahDC/FCCLLAE7dusfZHEYt7IJ9qa+Pl4nwz8XZMWWCgGqDg6aMUd0myeGIQZbA==@kvack.org
X-Gm-Message-State: AOJu0Yy4zKC7NkgfWJg6OL5QT4XCRdAkED4qtCs183gBziE3f5BgoFM7
	cTyNTrKJF/+Z4bGeZlitIWxoEIr8K0YKWTMYGelCw3wf06el1Ar6boD++SrEIdyIAC8=
X-Gm-Gg: ASbGnctW8zueAwmv2KWZBylC+qMFhzi1MRNK+5kth+Ij6QI/br9ggl4zBDJnN5vjSLX
	mXr8gb3xmUhhgGBMHqLVeCEC6bcRRKh7CbYeb34e/VCEwYZAJ7wXs+fg+vzZR5Ttz9oPWMzQoge
	59G+0gxxg4TkCcMdegfsgBMIKI+Y9rXx8+wp+F7ovLOJqwYyyCFkyogtWtey2yoqemUUOrLm+dm
	l6+oz3KMdUUyRL6WWaAfIxwfLhjmlpPyBFvCe0mHv7Z+KSXwj/GbnzD4duWmLpUsg5QgWz7nRKS
	oQuuS1OEfqnGe8Rr0RphyXovG8UNg9iEzYXQg4q9aopadpwgiiuaF+Gs3qOOHHkzDE7GB4+M38Z
	q+p3xo4kiUPfVQDQIFCBzySTKZNPb5XTyZHNbqEp4njuvVnQh1+Eg4jgMUwIEaCIhxlfylt7Z+/
	6fTAHNS5e2ayoUTNPYlhsK6A==
X-Google-Smtp-Source: AGHT+IEW+p/yFRXmmN9eW8x4AeaBg7N2/sFlQYebSPLD3vubNbtOgyDoyxrNrPhIPQlzogfakGVp6g==
X-Received: by 2002:a17:907:94c9:b0:b04:2f81:5c35 with SMTP id a640c23a62f3a-b042f817f8cmr232585266b.34.1756718385988;
        Mon, 01 Sep 2025 02:19:45 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:45 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 12/12] mm/highmem: add const to pointer parameters for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:15 +0200
Message-ID: <20250901091916.3002082-13-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ACDFB2000D
X-Stat-Signature: z99zuiuigi6f9bwmidn43c4id6rmq9pf
X-Rspam-User: 
X-HE-Tag: 1756718387-996311
X-HE-Meta: U2FsdGVkX1/W1RPPoxS0FKhJfb0MbFiMCIlgZIvBzrDbmNRWKIegPjNLWM6R/ZBcIRGQCt/vmv+UeQc7IoKd764K1lAIyYlfRIVFadkKMMVqi+5l9FG2xIQqWsdXydKr4V/+cDTvzo5RlxzgoUF2iWho7KHxpYtJi5WohPLupO8o7LdUL8EKkKxzdqDp5DnRECIRr/8S0GhuJN2sbDJ3XB23IbbIhewUYr+ArdogT1Tvgj0o52vpM3WCN6oXAkPpnzktbBAZYkR81LTpKKrnj+neAD/FyQrEZASvDo91i8+eMifJ6rq/di6uemKvEuBau36Nv2iM6gEcy439XVkuK5w+vjoylQ9lTQeSEmq5vs/HKjEwovrv2yzMn0WoKNrlINhudVjkw5BdeR7sIRA1lM8kSHg0WyuS2OiuBrWrK5eRnAbyoV5iWaoIWtFy4vMO5L+KfICqiMTOFhPmbLW7X/a6Ac36EijUIHuU8LLiSoTTJKVDEp8T+GapzlRGKJhffVQBnSsz8wAYFQpnhlsKcCoaFZK8Ya9chn/dKsmxFPmovQzldiFvIKN7dpzbh9YHq6XTkTgXHrN+SMF62pNoZ5RJWxbvJd8W7BesR44Jfif7sT7UrCCMEU8T4QGCv+vTTg33MciXIiHx7y8DZgy0KyLhOugMpUamMrG/webOF6DOBnXZi8NvDkUdrIvRX1plY2IaziwTKq7qGbk76SCmImA0ToQjQWVvIGJ3Mlhncf+qnVFkk+uFuFoVeI0jfsmi1sPc8v1+gVuFNNPNH+cxR00D4KjOw24vfggHZKvjkoNUKSVDKltva37XLKMRxpHRQ1t5bRkDOUKe+2qQzp4zw6uiFcomPMpDM/ihNAFRZG2aUau/0lJXXI6UWOLgWoJjLRM+VOIwG7ASWz656n766TYH/bV6gnAoML9lk9DZ2s+4Cl6soctyIVj9VPUupi4L1xS/Ul4vtTW9CIpjBai
 hSElN9qm
 kGMReeFvV8/stQsidULbRncp9+9s9egPl7GGKmgr5Inmm32lKfWXzICL1MMAuIASwhLxRK7hHycNdPB4GE2yBOuNupWn++K63nIwBDLMJw0gyWuPcikfIjtai5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory management (mm) subsystem is a fundamental low-level component
of the Linux kernel. Establishing const-correctness at this foundational
level enables higher-level subsystems, such as filesystems and drivers,
to also adopt const-correctness in their interfaces. This patch lays
the groundwork for broader const-correctness throughout the kernel
by starting with the core mm subsystem.

This patch adds const qualifiers to folio and page pointer parameters
in highmem functions that do not modify the referenced memory, improving
type safety and enabling compiler optimizations.

Functions improved:
- kmap_high_get()
- arch_kmap_local_high_get()
- get_pkmap_color()
- __kmap_local_page_prot()
- kunmap_high()
- kunmap()
- kmap_local_page()
- kmap_local_page_try_from_panic()
- kmap_local_folio()
- kmap_local_page_prot()
- kmap_atomic_prot()
- kmap_atomic()

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 arch/arm/include/asm/highmem.h    |  6 ++---
 arch/xtensa/include/asm/highmem.h |  2 +-
 include/linux/highmem-internal.h  | 38 +++++++++++++++++--------------
 include/linux/highmem.h           |  8 +++----
 mm/highmem.c                      | 10 ++++----
 5 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
index b4b66220952d..023be74298f3 100644
--- a/arch/arm/include/asm/highmem.h
+++ b/arch/arm/include/asm/highmem.h
@@ -46,9 +46,9 @@ extern pte_t *pkmap_page_table;
 #endif
 
 #ifdef ARCH_NEEDS_KMAP_HIGH_GET
-extern void *kmap_high_get(struct page *page);
+extern void *kmap_high_get(const struct page *page);
 
-static inline void *arch_kmap_local_high_get(struct page *page)
+static inline void *arch_kmap_local_high_get(const struct page *page)
 {
 	if (IS_ENABLED(CONFIG_DEBUG_HIGHMEM) && !cache_is_vivt())
 		return NULL;
@@ -57,7 +57,7 @@ static inline void *arch_kmap_local_high_get(struct page *page)
 #define arch_kmap_local_high_get arch_kmap_local_high_get
 
 #else /* ARCH_NEEDS_KMAP_HIGH_GET */
-static inline void *kmap_high_get(struct page *page)
+static inline void *kmap_high_get(const struct page *const page)
 {
 	return NULL;
 }
diff --git a/arch/xtensa/include/asm/highmem.h b/arch/xtensa/include/asm/highmem.h
index 34b8b620e7f1..473b622b863b 100644
--- a/arch/xtensa/include/asm/highmem.h
+++ b/arch/xtensa/include/asm/highmem.h
@@ -29,7 +29,7 @@
 
 #if DCACHE_WAY_SIZE > PAGE_SIZE
 #define get_pkmap_color get_pkmap_color
-static inline int get_pkmap_color(struct page *page)
+static inline int get_pkmap_color(const struct page *const page)
 {
 	return DCACHE_ALIAS(page_to_phys(page));
 }
diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-internal.h
index 36053c3d6d64..ca2ba47c14e0 100644
--- a/include/linux/highmem-internal.h
+++ b/include/linux/highmem-internal.h
@@ -7,7 +7,7 @@
  */
 #ifdef CONFIG_KMAP_LOCAL
 void *__kmap_local_pfn_prot(unsigned long pfn, pgprot_t prot);
-void *__kmap_local_page_prot(struct page *page, pgprot_t prot);
+void *__kmap_local_page_prot(const struct page *page, pgprot_t prot);
 void kunmap_local_indexed(const void *vaddr);
 void kmap_local_fork(struct task_struct *tsk);
 void __kmap_local_sched_out(void);
@@ -33,7 +33,7 @@ static inline void kmap_flush_tlb(unsigned long addr) { }
 #endif
 
 void *kmap_high(struct page *page);
-void kunmap_high(struct page *page);
+void kunmap_high(const struct page *page);
 void __kmap_flush_unused(void);
 struct page *__kmap_to_page(void *addr);
 
@@ -50,7 +50,7 @@ static inline void *kmap(struct page *page)
 	return addr;
 }
 
-static inline void kunmap(struct page *page)
+static inline void kunmap(const struct page *const page)
 {
 	might_sleep();
 	if (!PageHighMem(page))
@@ -68,12 +68,12 @@ static inline void kmap_flush_unused(void)
 	__kmap_flush_unused();
 }
 
-static inline void *kmap_local_page(struct page *page)
+static inline void *kmap_local_page(const struct page *const page)
 {
 	return __kmap_local_page_prot(page, kmap_prot);
 }
 
-static inline void *kmap_local_page_try_from_panic(struct page *page)
+static inline void *kmap_local_page_try_from_panic(const struct page *const page)
 {
 	if (!PageHighMem(page))
 		return page_address(page);
@@ -81,13 +81,15 @@ static inline void *kmap_local_page_try_from_panic(struct page *page)
 	return NULL;
 }
 
-static inline void *kmap_local_folio(struct folio *folio, size_t offset)
+static inline void *kmap_local_folio(const struct folio *const folio,
+				     const size_t offset)
 {
-	struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	const struct page *page = folio_page(folio, offset / PAGE_SIZE);
 	return __kmap_local_page_prot(page, kmap_prot) + offset % PAGE_SIZE;
 }
 
-static inline void *kmap_local_page_prot(struct page *page, pgprot_t prot)
+static inline void *kmap_local_page_prot(const struct page *const page,
+					 const pgprot_t prot)
 {
 	return __kmap_local_page_prot(page, prot);
 }
@@ -102,7 +104,7 @@ static inline void __kunmap_local(const void *vaddr)
 	kunmap_local_indexed(vaddr);
 }
 
-static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+static inline void *kmap_atomic_prot(const struct page *const page, const pgprot_t prot)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		migrate_disable();
@@ -113,7 +115,7 @@ static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 	return __kmap_local_page_prot(page, prot);
 }
 
-static inline void *kmap_atomic(struct page *page)
+static inline void *kmap_atomic(const struct page *const page)
 {
 	return kmap_atomic_prot(page, kmap_prot);
 }
@@ -173,17 +175,17 @@ static inline void *kmap(struct page *page)
 	return page_address(page);
 }
 
-static inline void kunmap_high(struct page *page) { }
+static inline void kunmap_high(const struct page *const page) { }
 static inline void kmap_flush_unused(void) { }
 
-static inline void kunmap(struct page *page)
+static inline void kunmap(const struct page *const page)
 {
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
 	kunmap_flush_on_unmap(page_address(page));
 #endif
 }
 
-static inline void *kmap_local_page(struct page *page)
+static inline void *kmap_local_page(const struct page *const page)
 {
 	return page_address(page);
 }
@@ -193,12 +195,14 @@ static inline void *kmap_local_page_try_from_panic(struct page *page)
 	return page_address(page);
 }
 
-static inline void *kmap_local_folio(struct folio *folio, size_t offset)
+static inline void *kmap_local_folio(const struct folio *const folio,
+				     const size_t offset)
 {
 	return folio_address(folio) + offset;
 }
 
-static inline void *kmap_local_page_prot(struct page *page, pgprot_t prot)
+static inline void *kmap_local_page_prot(const struct page *const page,
+					 const pgprot_t prot)
 {
 	return kmap_local_page(page);
 }
@@ -215,7 +219,7 @@ static inline void __kunmap_local(const void *addr)
 #endif
 }
 
-static inline void *kmap_atomic(struct page *page)
+static inline void *kmap_atomic(const struct page *const page)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		migrate_disable();
@@ -225,7 +229,7 @@ static inline void *kmap_atomic(struct page *page)
 	return page_address(page);
 }
 
-static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+static inline void *kmap_atomic_prot(const struct page *const page, const pgprot_t prot)
 {
 	return kmap_atomic(page);
 }
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 6234f316468c..105cc4c00cc3 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -43,7 +43,7 @@ static inline void *kmap(struct page *page);
  * Counterpart to kmap(). A NOOP for CONFIG_HIGHMEM=n and for mappings of
  * pages in the low memory area.
  */
-static inline void kunmap(struct page *page);
+static inline void kunmap(const struct page *page);
 
 /**
  * kmap_to_page - Get the page for a kmap'ed address
@@ -93,7 +93,7 @@ static inline void kmap_flush_unused(void);
  * disabling migration in order to keep the virtual address stable across
  * preemption. No caller of kmap_local_page() can rely on this side effect.
  */
-static inline void *kmap_local_page(struct page *page);
+static inline void *kmap_local_page(const struct page *page);
 
 /**
  * kmap_local_folio - Map a page in this folio for temporary usage
@@ -129,7 +129,7 @@ static inline void *kmap_local_page(struct page *page);
  * Context: Can be invoked from any context.
  * Return: The virtual address of @offset.
  */
-static inline void *kmap_local_folio(struct folio *folio, size_t offset);
+static inline void *kmap_local_folio(const struct folio *folio, size_t offset);
 
 /**
  * kmap_atomic - Atomically map a page for temporary usage - Deprecated!
@@ -176,7 +176,7 @@ static inline void *kmap_local_folio(struct folio *folio, size_t offset);
  * kunmap_atomic(vaddr2);
  * kunmap_atomic(vaddr1);
  */
-static inline void *kmap_atomic(struct page *page);
+static inline void *kmap_atomic(const struct page *page);
 
 /* Highmem related interfaces for management code */
 static inline unsigned long nr_free_highpages(void);
diff --git a/mm/highmem.c b/mm/highmem.c
index ef3189b36cad..93fa505fcb98 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -61,7 +61,7 @@ static inline int kmap_local_calc_idx(int idx)
 /*
  * Determine color of virtual address where the page should be mapped.
  */
-static inline unsigned int get_pkmap_color(struct page *page)
+static inline unsigned int get_pkmap_color(const struct page *const page)
 {
 	return 0;
 }
@@ -334,7 +334,7 @@ EXPORT_SYMBOL(kmap_high);
  *
  * This can be called from any context.
  */
-void *kmap_high_get(struct page *page)
+void *kmap_high_get(const struct page *const page)
 {
 	unsigned long vaddr, flags;
 
@@ -356,7 +356,7 @@ void *kmap_high_get(struct page *page)
  * If ARCH_NEEDS_KMAP_HIGH_GET is not defined then this may be called
  * only from user context.
  */
-void kunmap_high(struct page *page)
+void kunmap_high(const struct page *const page)
 {
 	unsigned long vaddr;
 	unsigned long nr;
@@ -508,7 +508,7 @@ static inline void kmap_local_idx_pop(void)
 #endif
 
 #ifndef arch_kmap_local_high_get
-static inline void *arch_kmap_local_high_get(struct page *page)
+static inline void *arch_kmap_local_high_get(const struct page *const page)
 {
 	return NULL;
 }
@@ -572,7 +572,7 @@ void *__kmap_local_pfn_prot(unsigned long pfn, pgprot_t prot)
 }
 EXPORT_SYMBOL_GPL(__kmap_local_pfn_prot);
 
-void *__kmap_local_page_prot(struct page *page, pgprot_t prot)
+void *__kmap_local_page_prot(const struct page *const page, const pgprot_t prot)
 {
 	void *kmap;
 
-- 
2.47.2



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F763CA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961266B0030; Fri, 29 Aug 2025 14:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3326B0031; Fri, 29 Aug 2025 14:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D89B6B0032; Fri, 29 Aug 2025 14:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 674796B0030
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F0161A08A8
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:21 +0000 (UTC)
X-FDA: 83830640082.03.46FFED7
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 575C5A0011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="O/U+xLpY";
	spf=pass (imf25.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vSOWKuEaMDZ+2LJ8LL0JmOu370M3l/3FgriRex4OPk=;
	b=Gde/+H55LmjtpziULwqMNGlmEE6m2CN7g9zAbUXlpTuaeqosZyB2/50mD1i7YaW+PqsRQl
	ZYowstyZzGzfAJ6JaswHfO80jQq0YiMbBXF7024w84bbd03EDuVzkJ2ttn/f9IAFI5GMGj
	XWeF//LAKCtfuxnjQTOdt72Pvwi5iUw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="O/U+xLpY";
	spf=pass (imf25.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492339; a=rsa-sha256;
	cv=none;
	b=lBpFUp9mjiGjzOMHWUE8/+QDcNDjey38rCLATCQi56X97F835QkrFpzIds4zWDCFSUNeAc
	oSntHuxFk8kALpSq56oAKLI7cb7ZX/mD0p3Bi3lMAbmlXRdF4TBdsiuTOJQKOhyDKTupnX
	WAlJoxgvvIzIRLZpPbJJgUmJQjjfXG0=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afebb6d4093so395586666b.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492338; x=1757097138; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vSOWKuEaMDZ+2LJ8LL0JmOu370M3l/3FgriRex4OPk=;
        b=O/U+xLpYAI8Fndsb8BvNVGpoSbofgvD7l9Q/u9aNJFmWZ4mbaPds+SEqyQjoI9Tmoq
         L6mIhahyiONE5PwtQTtMYESqSRrvUUiknMD+AXr1IcNG4h/uPRt9L8Et6QdIfxVJkjId
         CaiAnljIRcbfYksnRAOrPAxAnknE2V+Jm+ohJOLg6NoYtLAvOKZbRgu5kewbnjeptE7Y
         xtaSSUg++WAFeft+i9/Ods2Mwj7lLJi2hVd5wTwfl5TlGvq5WSXSYChLiYSVqL+399J5
         JmuqM5ISbCatzSLT76hHEupqYZx+IsDWCDw7pprMQOK6O+gngfCMG0WkyuPU/xdJH+uM
         PXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492338; x=1757097138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/vSOWKuEaMDZ+2LJ8LL0JmOu370M3l/3FgriRex4OPk=;
        b=UUpRgefQ/7eQ+6tiuqxs27REdv1CBsWvePAZ8NzoadVdKLwJuO0X6050XxYiA3smgv
         B7SLaTRcJvdM4unyTR3f6cKKHmnoID7gB6v7+jqPokUr1/KcGVjLL/kjZWt6AiMxqPpU
         A3L8LVqpxid6cfseu2x8q2h4+MUilu+25n4dW5g8+ofoXc9oH0S0sHZBDBh5JPVLm1G9
         nQfpgEcLRtsRcZf+iaqEx7rVITO6uGjNs48Xp8DrEG5Oeo272rLYU8x1Oz8QDmg5DG+h
         5VdVOEVeEspji/QB98zOYR8kbb+RLtN4kDeH04eHbDK3bsUxjKIFds4I32No52iGzXUW
         i9Xg==
X-Forwarded-Encrypted: i=1; AJvYcCW9tu/pqDMIaSRe2UljU6mTVJKzmpWWF25fgc1BhPTc6VlaZPKb3JtnltQeyarDkIL3R2e8/zJfUQ==@kvack.org
X-Gm-Message-State: AOJu0YygGO/9YymazMVj7k4/h8ydNhXaie3+OJrOmVNq5RjN51Phl0mA
	pVrfWJDe5/al7m3Czb8ItZyYkQLCdZBG9PyV5TjHjj0XLgg26HgMPp9Xw0DIJK2uOns=
X-Gm-Gg: ASbGncumTDmuq29+aYaFpwhxO99WVeKm40EJ5XgKBmGcPnighUBeg204ulAw0oLL1Tv
	fn0/5/VLKKID+9/AHnI5mzTAYqZ2CAGfS4uTrobnRfuaFD9Q7nqVypsoWzmZMNbKQY7PcfVgow5
	9Fc51t7VTYXPiBmoldZeK/3s45HyRnF++CKqMXjGgF/e+7YspsFpM+UVUCqW0G8N8AM0sgvqpUw
	WkK+LuP75QgAk/Z4C3Y5UNOWTro1X7vVIaY03nho/Kl7JZSgZvR52beueh8V627tbZfZF3f7gd1
	03k1WwAaPg26/dEQzYpGtgfKNm8ES45AEz/L69ACF5etVBVsbctWSuv+ZF3A9S/Aes9Cdu8HTuj
	pRCVg5jkaI0TBg5DnbtD0J4uJTY8ZtkZMkp5xBM6/gv9UG9AtSTvdlCqXZhoH6R1G5H7vGpmkTR
	8pPokfejB/lukwvsWZClWpPQ==
X-Google-Smtp-Source: AGHT+IGv0OdLQqUR+bUGZrofMRHPs+UUakVtxtldjW+6bUQQarM/n0M9fQnNeaSck9ADnkUgSV9k7w==
X-Received: by 2002:a17:906:c112:b0:ace:d710:a8d1 with SMTP id a640c23a62f3a-afe2904bbcemr2551164366b.24.1756492337812;
        Fri, 29 Aug 2025 11:32:17 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:17 -0700 (PDT)
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
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 12/12] mm/highmem: add `const` to lots of pointer parameters
Date: Fri, 29 Aug 2025 20:31:59 +0200
Message-ID: <20250829183159.2223948-13-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 575C5A0011
X-Stat-Signature: 8h9kk6bz8dswqz4hyzk1aiq1mrpyfzu8
X-Rspam-User: 
X-HE-Tag: 1756492339-723664
X-HE-Meta: U2FsdGVkX1+DtXI91YxEef+8E01SK2C7VYGR3uNOGJ8kuf0Y+fijFdkK3zvwrYE+02vcMXFnWauANtR/4RILt40nunIM47cN0uFiS9ZHUL7PNVVKn18Kf7vvg9p9ncELqyE2S0sQbB4fwEZ2pJfpG6bpFqYbetjsDi+bTM+2yydp33XBljEG+kzB2e9goKRY4AjS5TCeTiDB5vsQQIWbs4BmUXXZxpzteP9sUvC4ZAm+XMqaIJzx+M7v1xJdmPBDAupwQMfuuL5khxd7T+X63bst5jnFpfekJWxQ6kguBneD3SgjDBQn7wWFQtIiJn6S+JELvXXfr+j/IZftTaqvfeHPUC+Szyd5cHEwMrvjxFHOkUAOWM7vWDMQWGSSDPe1RssUsHhv8huBCLwrqw5wXgSrEG8p2YNeEtOQpvHKKIDvxubm/lCFWagLJyZxQX/exeG2fXWkemYG5nJkNSpwMG0zmodt07fq2lz2hB0BX/tyAeXj8udGqvRcJUXPBBG+i+OGYTb/21rHyAoLAKiSYpwok3vTrnSw4OxsE1QaNXFdG5Fv4HigPlgP2VWTO4ZOGKFMZRwXyqN6lyNUVoni0RFTVPXy27TShBZhQ19OYoCPVkxTcDBvdnFfp8sOv/+Q12iUXDO39uYMVkvUFxVTeWMsvpkESlNIMxfCbf46jjKWxVMOWQsdWild32PKQw5NZ1ikKly1MG0iadzXrptkVAJL6HFJbA2PIWuayCamX+4KHocYYdhnVbAK8H12gNgHSFxS5mP7Vwr4C0EuYw8xDOF24vH8LBkx866laSKSFUUPgs+yNecKyrriUaWOaofuYfJvwZdjYbWOBeGi9GjJS2V9NLZpOljThGKR7gbdJ8ZeJ5fNV8zC7hJMoDp7T/hNfNeIebuw3Qv5KW1CikcG6efxHiuhBDPr4eIOzzkcN5jsOAahw5mm9GtiZUyOSbqXvxXE6F7fizKsV5ahSEf
 RXU0mI3Q
 YtwwVbzvWFxugArh+Y31PumhfDiXDj2qVhqaXzXW0hUFR/Q1CGMukFtDxAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 arch/arm/include/asm/highmem.h    |  6 +++---
 arch/xtensa/include/asm/highmem.h |  2 +-
 include/linux/highmem-internal.h  | 34 +++++++++++++++----------------
 include/linux/highmem.h           |  8 ++++----
 mm/highmem.c                      | 10 ++++-----
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/arm/include/asm/highmem.h b/arch/arm/include/asm/highmem.h
index b4b66220952d..bdb209e002a4 100644
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
+static inline void *kmap_high_get(const struct page *page)
 {
 	return NULL;
 }
diff --git a/arch/xtensa/include/asm/highmem.h b/arch/xtensa/include/asm/highmem.h
index 34b8b620e7f1..b55235f4adac 100644
--- a/arch/xtensa/include/asm/highmem.h
+++ b/arch/xtensa/include/asm/highmem.h
@@ -29,7 +29,7 @@
 
 #if DCACHE_WAY_SIZE > PAGE_SIZE
 #define get_pkmap_color get_pkmap_color
-static inline int get_pkmap_color(struct page *page)
+static inline int get_pkmap_color(const struct page *page)
 {
 	return DCACHE_ALIAS(page_to_phys(page));
 }
diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-internal.h
index 36053c3d6d64..f5fb9dc7963c 100644
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
+static inline void kunmap(const struct page *page)
 {
 	might_sleep();
 	if (!PageHighMem(page))
@@ -68,12 +68,12 @@ static inline void kmap_flush_unused(void)
 	__kmap_flush_unused();
 }
 
-static inline void *kmap_local_page(struct page *page)
+static inline void *kmap_local_page(const struct page *page)
 {
 	return __kmap_local_page_prot(page, kmap_prot);
 }
 
-static inline void *kmap_local_page_try_from_panic(struct page *page)
+static inline void *kmap_local_page_try_from_panic(const struct page *page)
 {
 	if (!PageHighMem(page))
 		return page_address(page);
@@ -81,13 +81,13 @@ static inline void *kmap_local_page_try_from_panic(struct page *page)
 	return NULL;
 }
 
-static inline void *kmap_local_folio(struct folio *folio, size_t offset)
+static inline void *kmap_local_folio(const struct folio *folio, size_t offset)
 {
-	struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	const struct page *page = folio_page(folio, offset / PAGE_SIZE);
 	return __kmap_local_page_prot(page, kmap_prot) + offset % PAGE_SIZE;
 }
 
-static inline void *kmap_local_page_prot(struct page *page, pgprot_t prot)
+static inline void *kmap_local_page_prot(const struct page *page, pgprot_t prot)
 {
 	return __kmap_local_page_prot(page, prot);
 }
@@ -102,7 +102,7 @@ static inline void __kunmap_local(const void *vaddr)
 	kunmap_local_indexed(vaddr);
 }
 
-static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+static inline void *kmap_atomic_prot(const struct page *page, pgprot_t prot)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		migrate_disable();
@@ -113,7 +113,7 @@ static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
 	return __kmap_local_page_prot(page, prot);
 }
 
-static inline void *kmap_atomic(struct page *page)
+static inline void *kmap_atomic(const struct page *page)
 {
 	return kmap_atomic_prot(page, kmap_prot);
 }
@@ -173,17 +173,17 @@ static inline void *kmap(struct page *page)
 	return page_address(page);
 }
 
-static inline void kunmap_high(struct page *page) { }
+static inline void kunmap_high(const struct page *page) { }
 static inline void kmap_flush_unused(void) { }
 
-static inline void kunmap(struct page *page)
+static inline void kunmap(const struct page *page)
 {
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
 	kunmap_flush_on_unmap(page_address(page));
 #endif
 }
 
-static inline void *kmap_local_page(struct page *page)
+static inline void *kmap_local_page(const struct page *page)
 {
 	return page_address(page);
 }
@@ -193,12 +193,12 @@ static inline void *kmap_local_page_try_from_panic(struct page *page)
 	return page_address(page);
 }
 
-static inline void *kmap_local_folio(struct folio *folio, size_t offset)
+static inline void *kmap_local_folio(const struct folio *folio, size_t offset)
 {
 	return folio_address(folio) + offset;
 }
 
-static inline void *kmap_local_page_prot(struct page *page, pgprot_t prot)
+static inline void *kmap_local_page_prot(const struct page *page, pgprot_t prot)
 {
 	return kmap_local_page(page);
 }
@@ -215,7 +215,7 @@ static inline void __kunmap_local(const void *addr)
 #endif
 }
 
-static inline void *kmap_atomic(struct page *page)
+static inline void *kmap_atomic(const struct page *page)
 {
 	if (IS_ENABLED(CONFIG_PREEMPT_RT))
 		migrate_disable();
@@ -225,7 +225,7 @@ static inline void *kmap_atomic(struct page *page)
 	return page_address(page);
 }
 
-static inline void *kmap_atomic_prot(struct page *page, pgprot_t prot)
+static inline void *kmap_atomic_prot(const struct page *page, pgprot_t prot)
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
index ef3189b36cad..b5c8e4c2d5d4 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -61,7 +61,7 @@ static inline int kmap_local_calc_idx(int idx)
 /*
  * Determine color of virtual address where the page should be mapped.
  */
-static inline unsigned int get_pkmap_color(struct page *page)
+static inline unsigned int get_pkmap_color(const struct page *page)
 {
 	return 0;
 }
@@ -334,7 +334,7 @@ EXPORT_SYMBOL(kmap_high);
  *
  * This can be called from any context.
  */
-void *kmap_high_get(struct page *page)
+void *kmap_high_get(const struct page *page)
 {
 	unsigned long vaddr, flags;
 
@@ -356,7 +356,7 @@ void *kmap_high_get(struct page *page)
  * If ARCH_NEEDS_KMAP_HIGH_GET is not defined then this may be called
  * only from user context.
  */
-void kunmap_high(struct page *page)
+void kunmap_high(const struct page *page)
 {
 	unsigned long vaddr;
 	unsigned long nr;
@@ -508,7 +508,7 @@ static inline void kmap_local_idx_pop(void)
 #endif
 
 #ifndef arch_kmap_local_high_get
-static inline void *arch_kmap_local_high_get(struct page *page)
+static inline void *arch_kmap_local_high_get(const struct page *page)
 {
 	return NULL;
 }
@@ -572,7 +572,7 @@ void *__kmap_local_pfn_prot(unsigned long pfn, pgprot_t prot)
 }
 EXPORT_SYMBOL_GPL(__kmap_local_pfn_prot);
 
-void *__kmap_local_page_prot(struct page *page, pgprot_t prot)
+void *__kmap_local_page_prot(const struct page *page, pgprot_t prot)
 {
 	void *kmap;
 
-- 
2.47.2



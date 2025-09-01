Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE9ECA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056E38E0013; Mon,  1 Sep 2025 16:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DF18E0009; Mon,  1 Sep 2025 16:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0D68E0013; Mon,  1 Sep 2025 16:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B29638E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72F4513B442
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:54 +0000 (UTC)
X-FDA: 83841875628.08.6727339
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4E13180011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=iU2cNVg0;
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3uoyKSyOaO3f7nxjstRVXs4aNsGaCK5BZpTMsYSqag=;
	b=QoG8VHHGF7xQ13pnRfTeOEm2DpJSpdB2GseFcaqzPsjoY5aoPt2kliTLd09c0EvHuXrefj
	50N7XamljZ9WedVz3+lILN3O8zXCaGVX0tNrwVzlJ9J8v6kMGuDEFTF2fUi9erhCuPynvv
	17PNysSn7zbdrqswg7UXfug4jZCjQKA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=iU2cNVg0;
	spf=pass (imf06.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759852; a=rsa-sha256;
	cv=none;
	b=v2PEQ9HW7hrtuo3Ho4FdWORmHvpPOSYXoKD2TWEW9GutwhhsyhcIJxpY8IBcwSEwWE3qAE
	2Xv7ttqw1dkKnv1rZUTkvSj9ASc3NS1VAH3ajEDFO/rXAVc+10/1NQa61+6Gw3cFtk2EM3
	2BhVq3h6ZsKCqEw4qxmD/S/HChxPc5A=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b0418f6fc27so235955666b.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759851; x=1757364651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R3uoyKSyOaO3f7nxjstRVXs4aNsGaCK5BZpTMsYSqag=;
        b=iU2cNVg0tLrnACO7AyiArv9Kl8O3k+J5ZpCm8wd1gjyObvOyptC1BksZfveMVIFbda
         F5W/zRXLPm4kojHEeJX3Y4wr1bTzkGKUvErsoeXk9qXphs9CBXDF3hKKbhzsC8ChXTVl
         DB3LSU4TPF4R/dw0o5VqBqkW/h1DPh1hUacd0qMNfx3AgDLM/tinHir4pFk3SUqIcOSc
         zeViHROppfBGSLpRzkpwu0X/ftDS9l8qJubEjjMslt+1eesyskDmNAkK+FfeVxRq7BXG
         XWjBfrssJ20wjZU+jdLoFG/D3u9lZ03K8JmS5h4MFw2mxw1qnhFqiWDXMxAXuoheSZXY
         wZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759851; x=1757364651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R3uoyKSyOaO3f7nxjstRVXs4aNsGaCK5BZpTMsYSqag=;
        b=iG85ziocfCBWuaXgBJ62ExVVmh04bZL9QSoYH36fUtzljXKeyeiR0MSLSDJAoAgWaa
         bfDaYthEMTS4T2klzTBYzwuDrGaTSBuzXuX8Sr/C2hy/DdDdcsdHKbMEp/q1NTQ1I8eQ
         D81vQ3KO+2TVHCPX/GN4ICQVleb1VFMJ9bdEkSLW/Tsm2zPtzMs4RG7LpoeIhBOFaT4P
         e8kyXpEnxcWsRk3j9mW/V+YWEpHWW1hvPqfizQ/DiE8pVuy/Kx+2/7mHSURQoac3BcyL
         qHiPJU3qbtZtTaMy2hIkBAb1BmlgTTUiPJ48xvbbfH+t4gwc3cHwNgzmpYh+DzDnIwfD
         ckzA==
X-Forwarded-Encrypted: i=1; AJvYcCVnq48w+p7z0tHzU3e9aWiYPcbbuL0E7zYsBe2/DoUnk0kSCxaIchHmoaS2lXeUOTbd+qZOQ8V2Hg==@kvack.org
X-Gm-Message-State: AOJu0YwQrKs3LqWZpAtRZHh/yTUx7faB/GqMVHAvwlwwNIrnQBivmwMH
	dxAyHw5fqjYVim+3VqzKVA7T/t59VO+FRmHLQyj7uH1PEoF3L1S1VRTzUZ6hWPyOC30=
X-Gm-Gg: ASbGncvltaLEINQsGQ4ZS7L0Wa4+F7WCsDWEumQ9ny4Gu52TCrKilHBsN8uYhpgdyrc
	JmkKQTvtywf8DAAo1fYmU2rNCVAoAIVq0ANoedqRF0ko5z1XQeyj+yJikRBbTIgq1kTU4Yhjc1M
	DwZlMXMURME49QsWgYoKhgqVZ+88jCgSpW3bNwx50sM26qsrmhttlTRyLfRWuQXyg6GK+zuySWP
	y3nNyQNIWjK51FD4c7MTrBsErE4V54pyj9AOUG3eIgY/V4Yv2A6SfXbo5K6ozGLh1UUtZt8uoSK
	o6iKy1IuJO/zdHBBERHgeZDrlaWJUyq9ClL4hVDMrZsBGwSxSmAf2VUwqAemdEizSBEu5zT/6jq
	K3rJS+exlqGCZ5PG0kPuZCZydf8d/rR6gdYc8A64JIqTeyGqYRggyK0ZnC+VMh7ZmI2SCw0YjVL
	DChRbofmy6VFk8o2hCuRSA4+hwsrBO4q1e
X-Google-Smtp-Source: AGHT+IHpQqCA9H+O3+CE5gTkKZKcF7k6oI5kQsi6mdSUrMDC8NBoCachyUvtoP/lhYVN+0jVOidhhg==
X-Received: by 2002:a17:907:9611:b0:afe:74a3:f78b with SMTP id a640c23a62f3a-b01d98b4c39mr886692466b.59.1756759850966;
        Mon, 01 Sep 2025 13:50:50 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:50 -0700 (PDT)
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
Subject: [PATCH v6 12/12] mm: constify highmem related functions for improved const-correctness
Date: Mon,  1 Sep 2025 22:50:21 +0200
Message-ID: <20250901205021.3573313-13-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A4E13180011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4sgr3jah5iy5fkg6ey4jrbtzu4uh53zn
X-HE-Tag: 1756759852-639516
X-HE-Meta: U2FsdGVkX1+TcSDiiZgG06xIISNupxmKLigGQdPzdXwpK66i2TsrCf1DxbUE8IsOKCNyt6eXgqK2udXAXkcbv5If7ijweeT+qer4fXp6JbiM/V6ozWgvDpsaFgfSxGXg5GtbyUVKCej66Ksk8V3ROsnfk1V5d1ckK1MRf1J3TU8DVlq0ryx2blmRyCtC9javcCwwSwOr+YgZaorwk82OyTGXK5CFuzZZyHYG7LircZPRdnStzTJ3qAlnOu6iXkaZpK6XFQtXzqF5a9IZ8XB/nCRHHY7jd70rM8lk7Fx4F10S7KCljGblgkQM/ea3nvtpKQXGQZoZIQ10Z6JbUY/N8eQ+oxQ15r5DUfvVwfYIz3gGHQXwIBFCf3DRXpPzXagY2vr9mRhmRKhXGjx2RJsfEappjZV0zsGRHWUqpK1ZcArP19fgGOy4C7NGxzK3ISRPukp8Xmex/IqQBRv2Rkbn+tO3ofL0CkTBHhujrsF+suBlkAj5LSAaoCOeimuYH1i2wDdGJa66evbi3Ro0HzANL4cbtD4XFfOxACXZlUJrA5C9YTXHemqrQgCq0eF6OqPLwtnSMNgeQiU2rjca96eW6P/0q3rssO2xCIx6Xn0CRmJePqiMqpmPe6QedJNdTtvslrOnkXhkmAntI2ctw9jh7wR6GHsn6cwYUytT6yTLn8GyFQKcA4bre52IHKC0eZM8N2tAQVDTlqzzQogVnyuYoxlqSyr/t9SYWYPRq8NHaly30bwLrBFVEA5K08fANfz0o5nqxeR/CPM9urgtSu0sXS8hzu5v/K85Wch2USwV54RTlsmVzTslPtsJIT7SbP/BOKbLPR7/BEwwWRREahvL7CeZjiANXwwV5hs5Hyrnj3SjuzR7BDkXnrDjYkuO7aB0MxctH2g4Gf6NDUCpesdxJTKeznUZkvWN7jUqb+SdTtrzN9dWmMFGZCT7+Vc+2M9WhHT5iCllPAbJVM57OKR
 fiYdSSVn
 1oe1z+cQizz3CVUesyG8wp18qUUg0HZQCI5VOFIwG8p00jFBUds7WvwCCOvFziqhG+ucQ1Soyhr0ezuP6Okf2W3V3wskCltcYsUx6INVhNO+E8BtRPavQezyjUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lots of functions in mm/highmem.c do not write to the given pointers
and do not call functions that take non-const pointers and can
therefore be constified.

This includes functions like kunmap() which might be implemented in a
way that writes to the pointer (e.g. to update reference counters or
mapping fields), but currently are not.

kmap() on the other hand cannot be made const because it calls
set_page_address() which is non-const in some
architectures/configurations.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 arch/arm/include/asm/highmem.h    |  6 +++---
 arch/xtensa/include/asm/highmem.h |  2 +-
 include/linux/highmem-internal.h  | 36 +++++++++++++++----------------
 include/linux/highmem.h           |  8 +++----
 mm/highmem.c                      | 10 ++++-----
 5 files changed, 31 insertions(+), 31 deletions(-)

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
index 36053c3d6d64..0574c21ca45d 100644
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
@@ -173,32 +173,32 @@ static inline void *kmap(struct page *page)
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
 
-static inline void *kmap_local_page_try_from_panic(struct page *page)
+static inline void *kmap_local_page_try_from_panic(const struct page *page)
 {
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



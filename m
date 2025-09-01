Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BED2CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241A88E000E; Mon,  1 Sep 2025 02:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2A08E0006; Mon,  1 Sep 2025 02:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 092A68E000E; Mon,  1 Sep 2025 02:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0AE08E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A97A0C06A7
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:47 +0000 (UTC)
X-FDA: 83839662774.24.89D6E3E
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id B0C7A1C0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=G6+pQURr;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmXy5ybFdCA4kdt6JbWaWujSYRHDeDjbcsjL0sLonTs=;
	b=P5/z4uE7Y2mJ/y/hsqgRsb2olF4lIKiT17MDA9TdlR+/FgOra0+Nt+d+ryLMuVFP0UQcMR
	Bijn5Xgt+qApEGdK0vwMFK35bCoYrXpJqom5QOzuOpH6sVstLwrbFQ2ETn5jLLpkh0sZBr
	rxXTklXvAY3eLJwIP+x50YUfgz/13Uw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=G6+pQURr;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707165; a=rsa-sha256;
	cv=none;
	b=l8B7Z43OQ/u5L0hzCV+higccZI0/4KMxlcbSAvmHg3R9hL42izgXnCEsTRK+CJZfLA7ZbD
	d0VYnosy7027eI1VBobUAy4P5NsiS4gZGau8MkT+kGdhMa/Y+sHnosgdLQIwPZCljSxP6+
	4QSLKfSKcZdsVvlPM2LhS2kdpdSOtdo=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61cd1046d42so4815896a12.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707164; x=1757311964; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DmXy5ybFdCA4kdt6JbWaWujSYRHDeDjbcsjL0sLonTs=;
        b=G6+pQURrMlX+rdD0ufB/cSTK23lp+vABMg6Q/147K14fYmK8FJH48PjwuSVpUZRmRL
         jegTt33qrACqdUT/9KPuX3vx+z5DplcAwPP6M27kOWhjfKKL4304cTmkeuaM17tZ6zWt
         J4yLjfXetuE8UoGxjTtlnyF3KfyHlI/HlIe522cUU4srZ1EJGuZKNbVcMl7GpjxMHlzc
         lB5Fz/Jol1BfdqAhcE7Z+hJqBNMqFnlkBtYGUIaumG2Rdi1I5SE0z4wMPWTVQtmDt1WV
         UePyaHFWWO3G3r1h0Zd5nepVeZ208VX/rEtqXwWCwX+yyFpmSZBFOCQ4MFuEWU/zxa1f
         U9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707164; x=1757311964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DmXy5ybFdCA4kdt6JbWaWujSYRHDeDjbcsjL0sLonTs=;
        b=w/wLvInRI2XMVMDK6C4WsKDVg6HyStYki2UzheX7vpY84085GZoTMTrvChTG+97fGx
         eswB6lGuU/t6fU/ntLT1rzin8gFw+3O6RGX5s1FMwKsXIHa7ZME0/FwZQa+sjsO62BMT
         k+knlXU6qGMoIIimW2Snzs1NGymQOPuFCAgJBPXsdPQ9CEXZot2jIMGfPHYwhFN03slr
         0FGCsOF/kKY3RUSvh5aVTMlyccDjap5XvyFoBaGB8dsrVqGAoKQrZMDHWW2dL+4hMOIv
         R/Mp+AABcTYJUmTRxMXM4U2ANOVTgavw6WCZQgY5mTUbxD+jTmuJWnP4nsKr7AanDefv
         1iqA==
X-Forwarded-Encrypted: i=1; AJvYcCWWwcPD5sxVEr9ajfKZqfQXFywGtwlMR+JWS+0n6LsaU5ZVBVwOMS2yUd9bprZjMQOlfwnU6MONGw==@kvack.org
X-Gm-Message-State: AOJu0YzKfi+P9aAoOVi2yL3I/MY+xpAt3J8BQtmZFAGBMOimL/XeHosR
	73tthVqCFf2QRLEz70SerXrM3k9GuxE8wU5+k5JgeqYEi/MynDTVf/Hi7ncpzLW+b58=
X-Gm-Gg: ASbGncsLWnXXHOFMeqxnOVqI02Vc+9ukGoCDK5BrseGaTGfhPqGRhqPOxhlgm5yaWcL
	VVywsFHuM6YJuJ4cYP9KpGUwAClVec3iAMDVzY+SibRA7AA8KRRu2AuIkqQD/e9lemvTu9tfB8h
	dTjdDyHzlXbuhCZNR9mK9KA0ri2oBRNyhMBpG2w41wnXDSeivVsjsYOUiISclNQsawIYAUOqD3r
	6aq8uTM84wKywS/Jo7I42beWvo3ey4nrtKkmTNYLjZ5EjPwoC4UaWzjaRXJlKGyEikPk9aDakY5
	WVksl/50g4NA47UMD626xp0RikxgO1i57PvqPYr0KM5hVAHvNRYbAXRj5d+611DcwqtGdatI114
	6LdbF3hdGC9MfCVmdFkvqMqnZbgE427znR6rQpjujJf4ETd+w5Z76Y18jj/meMOFLDRCotNNMU8
	7ia/C6qO3QCbMZxXsS6JXQMXhqigY12PvY
X-Google-Smtp-Source: AGHT+IGOvhlVbeL/X0mM8+8s766YaG9R11kD+4bMjAZdhRbl7MXM+beHrb1Q0MXfkACExbQP++Cszw==
X-Received: by 2002:a05:6402:84c:b0:61d:1327:9f7f with SMTP id 4fb4d7f45d1cf-61d26869fc8mr7090613a12.7.1756707164202;
        Sun, 31 Aug 2025 23:12:44 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:43 -0700 (PDT)
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
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 12/12] mm/highmem: add `const` to lots of pointer parameters
Date: Mon,  1 Sep 2025 08:12:23 +0200
Message-ID: <20250901061223.2939097-13-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7drzowk9gzpkde8sbo8gxqm3j1t7rds6
X-Rspam-User: 
X-Rspamd-Queue-Id: B0C7A1C0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756707165-590906
X-HE-Meta: U2FsdGVkX18/pHDMleFudtl3mTipyhAlk5pgm40O4igmYl8AjyZXyZ5rc+vNdxrUayrxQxbxJ5GdA3PpQj3vylJJr9nPzicg6ApVq/UgI61nSzrjEeup55XKbcupxVQVtKWi/lJkusPRZgcyB+ibF4PWGo8rAi6+cwaxZUiCYyY1J9CilpY/lz2AqUSb8TFB39CYHOMoBhLtag2Z2HEoTRHd3efIQNXS3ptZ4aY3sU38q2F5Jyqsx9/Jjn0idudo++4j7sGYZL3QJ2mRbsqT2toSpwFxgEIhrK6NHayA5td6MhO5A+cmOKIdYUM2BAfSbk8oxf4q6i8ZpTXS9bdEtnkiydh+SnJSpniAsB6c77s6PaujGg9LJ69I1dNN6JQM5GD6OV44yGmbI3vjXm3zf8bfwLdTsGMiXfDXARre0ahhDp3lc8NrQiiKyKF84W+HexLUw+HXJLyWA/NOUnHs78dQl7ACI2Tu+r8LOQpREm5cVnC70ZNoeYLg+UZgF9TvS0FYpc5qwoO/basqqI1EbTy3ZYVAborI4BsCo4eMmXkljvmkn95K7z1YQ0Yh3Tv1suZtJZfnYjSv4cJyxZbTZsSFMxiUmpbkDBtb9qu4zGgabRKvjxTmjB5hh6pSdqBF65SbaGn+QAa/CCtaau8lfzinJKcPHRXIHAAykt0Or1jaII3zuudLQmcXJlq8p0UXunNOVDP7uwagQjKrwGyOXeorWWPYsJYS6VPH/Kaq3ppZpflnUXLJ1mUc+IUEm7GpTfPX3Wr184Yrs9PICzbgV+s1cVqyrSCJv2OK8ML73VDB5X5hf/V7hnnDpPtU8i2YM+LUtfvCuZo9OsEQ7oqKjLgrPtc6J5YlcEeRZIvpYfe5Ul+armtozencOqUSwhWylCImyq/GUiPPY+b4Ug1atCc0ywaHql9sDuhyPUiURFl6hxIhzfq7wqBHrwc53D5deb3L1hNKmtv1Cyu/S2o
 U2lwB4CF
 XagSkBupUIan0aK+rQ7vo2ds0KKaxluDBsN39y0jt/If6C+iGniWOz2jLDpAFa30EC4ejtwAjV3T8GM1p3hWpXjnVM2Wk/RtbqAc+nU7NrGcE6WmlGVft4YN5tOYLnW7ohl73Ieef0J2966HXyXQignnFu/Wx3cRsRMMm6xyYWuKpWe1Ynz1IJINTif+vR9XD9GQXz8xhBegzIUfis+CcTFQF82wEPVEZJhfgYoL9apNHNibUzywPWwQzhiOkxNP7uumddE6mKkBLTDJjptkOOh+rAfYOvqbFJ8Oj8G6VNzHSSIVPPgbP7PxQkbcX7nAMlffDT3ZXba8R6ChKvhJvYjfBgoFFV1b6Az3jYQIU93ZaDvQweS7Srpa4zm0bEXJfzGRsTQEiIwYU4MjaavWm9siisnJLYu+39Crejy5WlDlfLoOAAd1PrRqPpmwIEDLVIZ66
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



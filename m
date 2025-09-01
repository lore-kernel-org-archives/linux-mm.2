Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD431CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8CB8E0027; Mon,  1 Sep 2025 05:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8FC48E0002; Mon,  1 Sep 2025 05:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3F48E0027; Mon,  1 Sep 2025 05:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C14778E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9129CBB3E2
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:38 +0000 (UTC)
X-FDA: 83840133636.11.6B6D11D
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id B5E9E18000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=efCCSBok;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbwvQejYab/rePViSXLSZNeM/TCyXeV95uglwFlMcys=;
	b=wYKRhIPPB1L2/AR4IjnHlNzW0A4i2p+U00quDvqaazIvFNfKyX/2DZDE37lGva9jjLCL+y
	mp1SE9JfEnhYaG4MLILsjsQ5MhyYj0SHxeE9C/W9gj77TbAx25c/EwrfpQ03sdCIoR/8hq
	ri5Pp0Ia8VyHQqlKFvEkHmIa+1JOykI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=efCCSBok;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718376; a=rsa-sha256;
	cv=none;
	b=BUWZxqNb1culk53Ce4bqYlkuukAub1Bh8N2KOZFllZQA6aKbTCE6ggK1dmKezDpetRFp/g
	GXk+yiNYnOwKAz4QtxdIfjckPTpUfTwV2cSF1Dwgh/BfP8ROF3Mvyk4ClQFBr7YfOX+Bsi
	VJqBvAfleu5oQoiSfVnfJtl+3U+6czk=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61ce9bcc624so4454097a12.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718375; x=1757323175; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IbwvQejYab/rePViSXLSZNeM/TCyXeV95uglwFlMcys=;
        b=efCCSBok5hZ7xxPzBNdvg1d7dwUJoAnw8BDopB2t8cZC7lCz+0dfxQg9WO/fmUgmUv
         Zg34ENpBzKLkBrOTGn7ZNaje5IAkKvqne4PxFcPIpXk1grfi2CxgTKaDy7NetSqJ0JMv
         sdhLtTK6L1BlplBi7+njVQNtffzj+UI9piEvd/ZuedwFWNl+6r5oYVHZtHWsqsL2Qxa1
         1J8lcqOXx7nzuhp/1KPoW09aqCkK3iZBtvrQ/11fZd31C3VTFNyaUlfPGT4y4di5X1rB
         hSK9019P+j87n8Bxpw7Xp4uksD7RBRkK4knCogb6SLPBT0dziJrh8lhZWDsUjQcECbMf
         MPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718375; x=1757323175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IbwvQejYab/rePViSXLSZNeM/TCyXeV95uglwFlMcys=;
        b=lFmvW/b5JGvfLgLQllTKQZOB0f6lKMin+522r9Ql8YgbWSHKITi4WbP3gXD5RYVjMu
         zKYbabxizw5mV27keYd4cEKUPU3hKEIVOtkK0laxYKXh8cHYZ8wKks4nMH2JIfM2UL4X
         HAkbhLOJLuwFA7dnHggxqvJvV0LvfvsuonuGfaBkEpkF349zsSHfkKTFkWH1BbLcW2h7
         Tkm/549Wp3jq5OX9CbchLfBDwcRLU9Ja14/yvxuyD+BeS1i+TJj/l1eOdTL8bt6hGzba
         i0zqiCN8QL8/57rvACTpjYtyecbChcC7XqjSf5Odbjisd3E/5l0KaBmEZU3qhRgMOMQk
         IHJg==
X-Forwarded-Encrypted: i=1; AJvYcCVE9QudgMAfMf0sa/YDmfk8Cuu0s8ODSeFirTsdf0vPaQ5mfKPMWazbg+UmWJU7rThE2fC9gLMmxQ==@kvack.org
X-Gm-Message-State: AOJu0Yx7hC9CwW8vQ0WQBF7bvfUtC6y8Xh8CVfd15TJ0mydb43OFXYHG
	vzhRVHjgis+UcjQY4W2Emhap733Wnm1JHab+rkJ49Ul10jAtvYU7UeYwY1CppwsB5Lw=
X-Gm-Gg: ASbGnctErsTvn0Xsj3+My6OSRnZRcUZpO5P8UnA4kX0ImoVygadZTO1aFW+w5xz5yEc
	zy2920PxY+24PXMncBY56n3bMbNgGuVGwBBL0yOADAff0FLxnO5/3tYN+StDzUy/FNkjhukGi8r
	Lq42oh6zwNlNSq/kOZKcDDT/ZzHhlNofKeEzs3YJgjiIu+OH+QAvba+Ip651p4ElU85JqbhT33y
	ZmAlMz+a/Ad3TW8zjA9gKSCexwYMEM0M2AS98L3AgKD+SDtwJ6O0082m4fQIKMm9MDl8aFhUvyu
	CDjGCYLgJXK20jkkd3pxcHgcQiVrOX4ZDF8QNDMxKnCl6dwshV0B5OLk4MZMl3PtlaA0fmwuC0T
	sklWYU6+8L1iw/UU9udFeva+0nwDJ2jBJKJLlxMR8PP4UFg+qDY2dnH8baQfH8OCXjlfZwX1JQE
	uMcyZfb0nC5Y7xkRUag2JF1999HziR3+Ax
X-Google-Smtp-Source: AGHT+IFjLUezk0MNPBdl2gvK25UHEhY1rnJIkox6nR/OlA7eUuvIfWjMQ4n5LH61nexh9wBub/G+rQ==
X-Received: by 2002:a17:907:86aa:b0:afe:b5fa:2adc with SMTP id a640c23a62f3a-b01d8c7d928mr753689766b.24.1756718374952;
        Mon, 01 Sep 2025 02:19:34 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:34 -0700 (PDT)
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
Subject: [PATCH v4 06/12] mm/util, s390: add const to pointer parameters for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:09 +0200
Message-ID: <20250901091916.3002082-7-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5E9E18000C
X-Stat-Signature: dgkk5xpwy5988jyk89p4n7icsnu61fdr
X-Rspam-User: 
X-HE-Tag: 1756718376-237453
X-HE-Meta: U2FsdGVkX19bfmGWx6JFVJjoC4dy6lja3X6k62UKejx1Ke5/PBsJPMR+9xO7lm6ron7Sd8UtYm7XUvE4D/73Z2eR3+oyu3Lp7Q7loolgU2ew7KJ/5yawGhqLj2hdRROuUULUybtu7oz08JZpOdlGgI+2xUMIz5nFw9JGl0ejqwHGntqO8VUUUirH4brzoVrWxtBgE9/3owMBIizqN+17lW1M3J/bkPpMH6Zwyt948HRM5onUASavwO8k89l3pqHe+af1bL48cheAL8tHFOWKaMBZWoo0CtWTeFk63RLSQF5x0DrrE2xfE7LdLvRf6Lorq9mhOThJP35NTdoXtxFaLy+zGJTLoyITn9tQdohvrlUj+9lbxRz5StzfkrT5A8Dj4GQLYrK0KDP0t8sEEd9xjJcRS0f9Cz4rdqQzjpYxNzw/c6IrE6haj3ZlosmccFL+sZ3hREE5r5qbX239lUt4wcN9Ipx4B8YeewUUIvA+go7bSLwQRyrBfhHjhesyKQPOh6OjT68EOsCUJ8y6PVTGgtflP9VZx08n9Js0/CmOiR9G+CLqNXsZa6Iq+qhdODhg2bmdgi3IF/EY5snesQbrqMbVvpRoRN1ha/kLMHRvswQCHbzhHoFBT5qvwS1tyLAbMVDnEYvuhAQsrqkVKrJt/PXeQhdUHrwqCijuJ6VXc1xhoQAbuGfxYMVIsZ83SExp1FEqlGg1aJuhvs3oQsfktaxD7M5RfA5qjId9+qWslzUzHeoAa+ygzDU1AWvZ51+aNjEvARtYXOJMrmIKwxIGrDD3baIZisFpjixXyY2JbN9zm36BpYkbO3qCjb/L0BkdwTp5MCzhHSlpZDND1yPrkPjHICOOcGQTTtHGAuEsH+M8IMUSA+IJwhHfxm8hnbkHCRmjTDMajzIiYJqrlw6lPQ7hmHyVRxGJ2/8OC01Q5s9M3Aa9FistmBK6ZTANppAuPQZQ5beakm8+yO+t9GT
 jUJLArxh
 O9P8x49yWbKNsiAFK9N4eUcyTJKkPdpf2Gi4oCYezpkmfWwMhXAG8CyX8R+xdY1ltQMKppVSuH2wuWUClMKcqBlJHlMW2jN6zmQ1OIDZJPhli65dqlXgA7WFE/uDwQazeVqBdkpA63mBMh+WE5FcKVHgJc9fYPbkxOR5Sy/wBiLa1aWP3tqmyucg4UXewXbzNaxkuVGvlbPogLueWErCO6KRTWdfD6op1dqXg3MLr7iA02aFf3ZBD2fgh6MIteTkhz6e1mhRsAJTZg2827RLECl5XO/COBSN/+nEb5adBy7kJ3OltS+g3nKmZ6OQvz/QDnWW105/n70IRN1jzPAoVYP/w3Rvd64YIKLeHuOR7+pdofGj0qNx0vTHiiHs/Etea5+hSMHCL314zoHLfXXRXLQqEHhSSqTT39JYIo+xe/IOp9h2ocGNIHJTiKBIBUoeKp/zCvLgzqw0tdn0=
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

This patch adds const qualifiers to rlimit, vm_area_struct, mm_struct,
and folio pointer parameters in mm/util.c and s390 arch code that do not
modify the referenced memory, improving type safety and enabling compiler
optimizations.

Functions improved:
- mmap_is_legacy() (both mm/util.c and s390)
- vma_is_stack_for_current()
- __vm_enough_memory()
- folio_mapping()

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/s390/mm/mmap.c     |  2 +-
 include/linux/mm.h      |  6 +++---
 include/linux/pagemap.h |  2 +-
 mm/util.c               | 11 ++++++-----
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 547104ccc22a..c0f619fb9ab3 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -27,7 +27,7 @@ static unsigned long stack_maxrandom_size(void)
 	return STACK_RND_MASK << PAGE_SHIFT;
 }
 
-static inline int mmap_is_legacy(struct rlimit *rlim_stack)
+static inline int mmap_is_legacy(const struct rlimit *const rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f70c6b4d5f80..23864c3519d6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -986,7 +986,7 @@ static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false
 static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
 #endif
 
-int vma_is_stack_for_current(struct vm_area_struct *vma);
+int vma_is_stack_for_current(const struct vm_area_struct *vma);
 
 /* flush_tlb_range() takes a vma, not a mm, and can care about flags */
 #define TLB_FLUSH_VMA(mm,flags) { .vm_mm = (mm), .vm_flags = (flags) }
@@ -2585,7 +2585,7 @@ void folio_add_pin(struct folio *folio);
 
 int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
-			struct task_struct *task, bool bypass_rlim);
+			const struct task_struct *task, bool bypass_rlim);
 
 struct kvec;
 struct page *get_dump_page(unsigned long addr, int *locked);
@@ -3348,7 +3348,7 @@ void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
 	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
 
 /* mmap.c */
-extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
+extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1d35f9e1416e..968b58a97236 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -551,7 +551,7 @@ static inline void filemap_nr_thps_dec(struct address_space *mapping)
 #endif
 }
 
-struct address_space *folio_mapping(struct folio *);
+struct address_space *folio_mapping(const struct folio *folio);
 
 /**
  * folio_flush_mapping - Find the file mapping this folio belongs to.
diff --git a/mm/util.c b/mm/util.c
index d235b74f7aff..f5a35efba7bf 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -315,7 +315,7 @@ void *memdup_user_nul(const void __user *src, size_t len)
 EXPORT_SYMBOL(memdup_user_nul);
 
 /* Check if the vma is being used as a stack by this task */
-int vma_is_stack_for_current(struct vm_area_struct *vma)
+int vma_is_stack_for_current(const struct vm_area_struct *const vma)
 {
 	struct task_struct * __maybe_unused t = current;
 
@@ -410,7 +410,7 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-static int mmap_is_legacy(struct rlimit *rlim_stack)
+static int mmap_is_legacy(const struct rlimit *const rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
@@ -504,7 +504,7 @@ EXPORT_SYMBOL_IF_KUNIT(arch_pick_mmap_layout);
  * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
  */
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
-			struct task_struct *task, bool bypass_rlim)
+			const struct task_struct *const task, const bool bypass_rlim)
 {
 	unsigned long locked_vm, limit;
 	int ret = 0;
@@ -688,7 +688,7 @@ struct anon_vma *folio_anon_vma(const struct folio *folio)
  * You can call this for folios which aren't in the swap cache or page
  * cache and it will return NULL.
  */
-struct address_space *folio_mapping(struct folio *folio)
+struct address_space *folio_mapping(const struct folio *const folio)
 {
 	struct address_space *mapping;
 
@@ -926,7 +926,8 @@ EXPORT_SYMBOL_GPL(vm_memory_committed);
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
+int __vm_enough_memory(const struct mm_struct *const mm,
+		       const long pages, const int cap_sys_admin)
 {
 	long allowed;
 	unsigned long bytes_failed;
-- 
2.47.2



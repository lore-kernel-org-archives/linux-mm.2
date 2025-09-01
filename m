Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 562BDCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86C18E0044; Mon,  1 Sep 2025 08:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2138E0013; Mon,  1 Sep 2025 08:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C4F8E0044; Mon,  1 Sep 2025 08:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84DF58E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0521285FBB
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:47 +0000 (UTC)
X-FDA: 83840615376.16.E07638A
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id E63DF160015
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=YkpvD2P7;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf08.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKgBVUzyj+6dcxmt1PFXvQk/IZiLcynXJnKCzF2l15M=;
	b=NJCmCC+scgtGnh9Az+g+EETBDNZS6gAAPEnDSLsBYL0QTplYf8i68e3ujAKDgOeazwrwKm
	SKQXK3RjsjVO8ixETw6HWxaaRH12ZNIVTMACKGmseHV/nCLnZyKp8/0zsCzz4EnHotJfXe
	VLiZ1ZaWGw6FXSroJQFgGsxKfA0v8pA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=YkpvD2P7;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf08.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729846; a=rsa-sha256;
	cv=none;
	b=B+ZvRhwgB9hrcqpMZU7GuWElYVBAGwmixC5E0ZXGvV3wwIcTeUktnhYUeDGaLS8MepBeAd
	zQfmsJU0xMnM7tRkuNLdZIvS8Ccq1GYIsGp08f6u+q4Ykfoqp5viJBqPFh/WfIGXXcrKeZ
	krV8pCCZZiYN7csd1eAWvtLSYHsWDg0=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61e8fdfd9b4so2130113a12.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729844; x=1757334644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uKgBVUzyj+6dcxmt1PFXvQk/IZiLcynXJnKCzF2l15M=;
        b=YkpvD2P7ug4+Hud/NvWyAjtYU6HTFnfOyJT+mbiicVkhGRjb9kNUQbnkAeSTnpJCHZ
         cUyjC9GFlyhtgUgCkuRUBZu5TShYpXRzeLtp2aqg8rmIy0LofIC/aCY5cXRVFJQWJ5oV
         wXN/VVrSHBf5mCYElZ6rZwanKG9lqR92Sp74srjTwivNnx6XL3dPAoGnWi9DOrb8Pz3k
         synT9fUdCMnJ+mc45vpg73ODOzG8EqcUNurf7VMcKe4/u86ERWGFYeINrOobRK9bLG2P
         PnmcqiRUPFZwO/4uL+JLvexd8S97vhVBpP8H9UrKNjc0ZerJQtDfWIv6UsZKG1U5LvnV
         wU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729844; x=1757334644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uKgBVUzyj+6dcxmt1PFXvQk/IZiLcynXJnKCzF2l15M=;
        b=RlcEuGYi2XTN8Ke7tmFZnhZcI9DcSFIR3pCJKXe5DVx3xrc7boMAPErBZZ2esH7Zm1
         SXlVuVqoX5KMC5ifNyCfSxtz+3mxZK+K6C8C7FbH4qQHrkYxmjithPwnOOvJ7DJbRBLE
         lzurxPiz+S7fz1c1w0JDYyhJqqnfJ81Wla3MVqKqVsFY6jH8WVD+nxFQlqxrWvs0Lt+D
         1cuf1mYqb/q4yOsnnKOzckc7WAczY9lXoy5tdPY2ty93GSVQQhvQN+oZgnpXQAr3wTJI
         JrQ+rLM2cd9S3lbsgQhP8Gu4A53LK4Ng3sD9srcd7AqnzV85vVRY0XkLWAOrCdAk9ZE0
         jsNA==
X-Forwarded-Encrypted: i=1; AJvYcCWcfapTYbZwobpsL7BqZvHpa7UvNThGFipCmaatH89qEUIfoAlCX6SwmpcaeJZ1imOu/GiYwqLDZA==@kvack.org
X-Gm-Message-State: AOJu0Yy5AgyHpDTt33VtD9/T1gcDdyk2Ejzmh4njN+fB6lXKn2abu9FK
	V+Odu7CIdk6WM01PqwvM1sE05wBYOy1aXtvDeajDxOTHnc+oQoXIaIGkAb/6IQwNeuw=
X-Gm-Gg: ASbGncuqjXydktOQjJkQt1qJcQ+h2GyY4LAMI7CgBAz0DfbwuJJjdmObCSeHKnCsvy3
	62QOUZlW9PhCM7qw3PoGDW2amUuKn2qL4boP/rge44n+KM2GGr/LQA29ENx9YKPBri7jps7HCmh
	nc6vJDtteagdV3AI2o9BmGLHr9SYQEqdxJYgGlmcZgNv9weyiYeeVW2bdYJfKvmE3y6POYeY5s4
	SDCY22sYnGYsvOk/U4BG2KEPkX/exEUbZr0No+93UL64upkt8sRMOTMSYNCzx9zlzITTFkPebgU
	sKs/Lsvkbq8iFMuYz8qPFQSF7biS2PZpof9bTWVkQO4bCzPLRrbZoVEesk/CgiHg9Y3xS+DddHl
	VGL8B5wafcxokXVShJ+MQwUIjWYt1KH0s02uZUNMRAPnvlt0qNDELOeDnNdT/5ykghtZFozWj2S
	WVO43HGW32EowSEtSvzBZ5YDxDlar3zVwg
X-Google-Smtp-Source: AGHT+IEpijDtb0z/0WWEMHXl7q4Rmv4pw1RD0/gKYGC8MsYS/XMq2PnLTln3mfCOBW3uU4B+hzFViw==
X-Received: by 2002:a05:6402:325a:b0:61c:1d41:41bb with SMTP id 4fb4d7f45d1cf-61d22f522e8mr7331559a12.16.1756729844370;
        Mon, 01 Sep 2025 05:30:44 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:44 -0700 (PDT)
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
Subject: [PATCH v5 06/12] mm, s390: constify mapping related test functions for improved const-correctness
Date: Mon,  1 Sep 2025 14:30:22 +0200
Message-ID: <20250901123028.3383461-7-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E63DF160015
X-Stat-Signature: 8npjprkxxauxf7in9htcyqp7z3q54g81
X-Rspam-User: 
X-HE-Tag: 1756729845-693408
X-HE-Meta: U2FsdGVkX19RUwJxCOM9+0/mb1MMzfmrrinEfBiQ4SaBgW6rKCIzCsEFrZOxvHYUGtFa2ud/dRRRKADWngg/6p+lx8/L6AgkEl0gznYWlQbLD49gjjth2dnH0g9uBAoQzJQ/Sxtn9bIcKoYXwlndh7J5aaXzGx8xpdvPcYxpgosuLFbDKHnuLiLx4qCfr4zDuAkq22PoWZmadAW9hZYPz8tdoR3L9hi5rMsiWodoai1T4YwTSlZFuWx8lBRiUpnhqJh6ghfqtpJSdC9Wd+RR6crkNW1rzAt8P7/WLwXU3U67uEwPKoSIVVaGuUiKUbmDvJjsFCsj2PASVO/jfIVCcDJFB4hiwRWwi26wm4R2PTejkrC+7e3YGXpcOU1P2qoRUNWpgGbQD8An5nFXK8mv+oiUmZWF2kpxoYT6Sbnvgge/tNA7ijw1YcSINBRVHQsR4DRjlrkvg6voWZHQAQxwa8INqeHXpnczESk60vqZZte2bfyTCnfB1im112GG9v9swvbVISKCUZ+SEDPqdxE4wt0zor8EdApiP3ffAuxTRF0v/l0XjwY6VpDDNs5l/q34Ny5oE5MUT/hVkI3ZI4D1fHqvY3oLJzVqzWV2BQD9QLnt3lbUh59Ju0prUXbzMVxhVlN+EDAxIqff4p4+pWUmpAWx45tn1uddmzQ96CucRLay8uZ8yxblYMGosUcmIis+HbubCYoxI+o4wyOjSPaY9hWLSyv4zrp3ajkW9mX+BI85KqgDIrL9bVmpW8su6v3QRZ1+l7iwu7gVNBiO//4taPgCRWW5W9PJnru2fmZvIX8De51pEwUQZkyZNxBBiaG6pJySCCFW9txovDj5FhFoeGsW3T4E/27xEpYcjJ+hH5pflq5plwCCaH9/1hbZXsgGvtwE3SjnIVg6j4TXdGKJyjJ/7tVpYNt3kXjxtBNduFutwsni3pl/2sNXo2/PXrxd/EfxZqfuSuUry34ytGG
 duXainDw
 Og3kE7wio797fkco9oW0zp/iJHBzNyiiDQtJSWmkUoOuH9LMq/JRIoN49wVnhGNYQaRgIR2ZycSLyFzPDybsMPUpB05+E7T/UntEUBnDihvCjnpPN/BmQB2e0FyFvq7SMBGsFBhRIXMM2ngT23Aat5j/QgOetjKMXor1EJ7np5uxNF1omO3JSSc4NWltiw+DMXJIaO9Pwkm59AKn6z21dfxyb4QzMIKDptldMOpB2XwkHcsgtb0jHkEuMZbAaAYR393022VKNt9UmeTx/c7SRaYG9E7Eu66DfNhLkB3tcvfKWed4+fQRTHwOPODaUrs7DEWEClBMVFCSwDcUGmmzc17cIqZBhEo56kLvIEsvsCuqibMBDkRX/jSe8RggrtZqocGrsJ6ER2a3K99xBG5XwbU2KWRyutjC8bb667F1IcgpUwOmIjBx0bHOk+fy9WQCaFR2W8MCjcLHWEqfgZCUFHYCpAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We select certain test functions which either invoke each other,
functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

(Even though seemingly unrelated, this also constifies the pointer
parameter of mmap_is_legacy() in arch/s390/mm/mmap.c because a copy of
the function exists in mm/util.c.)

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



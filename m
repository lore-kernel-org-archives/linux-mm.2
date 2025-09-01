Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31290CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6648E002C; Mon,  1 Sep 2025 05:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84F268E0002; Mon,  1 Sep 2025 05:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C098E002C; Mon,  1 Sep 2025 05:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA788E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16BB485C37
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:48 +0000 (UTC)
X-FDA: 83840134056.27.DFB3273
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 31A3A40004
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=OhKc5Ttt;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWR7oxTxdlLJJjGEzgnWnG58Pm+0fE4rR05OeDaJbk0=;
	b=gep1i2mqIoop18uQpZH6OkmhFOiXUw+do97ZSKoYQWXln02VujPQ33n55pttLjcDZs86rG
	RSPuZh3748iUK3Bxffdi5mhh4Be2EWzLbyJnPatWknNmieiNsgwfWNhLDvNOc+e+jndG5k
	neKXwIjhifxVfWWiJCMK0EQlx1Dh61o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718386; a=rsa-sha256;
	cv=none;
	b=c7bnc7Uk2/ackj65EZsFJXbajEXkiub+4FW6Ec6SRnbUyjtGbpov+kDY1OY34JF8QbS/PP
	dbqBsAOJlcxSuxQH/FOgJraNagnNe4oh0PRVOYIgAgmK7VTxg/DCLGvuxaYevGaZV7uwvM
	PUlnaZo9sq6xQ41NbYeGlthHxlgl7ws=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=OhKc5Ttt;
	spf=pass (imf27.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b043a33b060so48124466b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718384; x=1757323184; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZWR7oxTxdlLJJjGEzgnWnG58Pm+0fE4rR05OeDaJbk0=;
        b=OhKc5TttdHLlgmLe4GejEWPWeY8rJZNyHCZt+mol2f18RNbrdb5mo4baRB2A4RuCZm
         6qnOxBoRG9IyERPLqEZOMrYBk0HnXnLKz5nKVu9WVCwPXFRCTEsOOcwrx0rJxfpl3a5s
         l7DcCFLHvk0cnN8X/fwjV++1+cQm1qy3+UX7GdB2y4218DsMivOderXyrAsE70LqG8hN
         uIS/OLRtjg3p+tIeJS1xJdymBb6EYLPi1So3VY1puEggugt1R1sOH0B8RljxN4M9OyZR
         ZL5SCFnWuV1e6Vdg4Dj/aEXoyvV/RadXN+Vc7dVRdbfb74cumohp4ebo5tBaYLX9ow1j
         iy0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718384; x=1757323184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZWR7oxTxdlLJJjGEzgnWnG58Pm+0fE4rR05OeDaJbk0=;
        b=bP2xgy7wkctV9dTKyT/j/etg+u6SXGQ2tjp8uTofSIT9jZgreRoXPvDcM3oM/6uQqU
         q6TMhxBxBwtuM8/lc7yFQszTusx3GV3wF3Uvuc2yuZUiRFYqatG4WXJ2J17vkZFiRXrX
         SzPSIDrDP7pNGYImz+ikk5njQ8rZ3DYAejvW6mBiuf969jBFAhi2PCpnsCkdr/P6sNuF
         Qjz+QHMkd99RIMTI/7gVlcqdUad4UxZckohBsdtd2h4OmoLEYx9T6RBL3JTIotdxfd/U
         BD+CdNvVBU6CBDQXL07DnXeSIiCcyG+Q3PLOpzBckVtG51aNZK4NLuEqYqdqwYJPrB5f
         cReQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmB7rHzMqWd81HK6SneELvtZ/kQmpM0inACS/GQmtit8eOMIQ4fVdx9Z2pzaHbu9PivFHgb7/RNQ==@kvack.org
X-Gm-Message-State: AOJu0YwtOZD/M5g2JE068mBLPPvWg8J+3rQWvGhKldVz5JagObCsllAb
	I5dxLWioI2O703Sryg+AQEsRMQ9QN4osuERFAU/xa93R+nzuhH55SGWv/bE+YaJWxzI=
X-Gm-Gg: ASbGncubozU8U3OBmT8PhGjWsf1fTJ+IIXgaiovARUB+uW3nzytbZl4SBQy2kdUhSL9
	eikhmoFXUMwlOvAcpcHOXbYeatsispaMIykuEdfDvgD0y42V9kbHAQikB8MPrZgMaiwr8shCyDS
	3zbguyATsiUapfygKJ/QGQXsWGDigwqvGPGy0ljT9olXzFIb1ysYhH7c4KIBaqx2nCRtRk7pZ+B
	R12eoqRJ+mUmWNe8QZv2NyMLm0eYjS3rXv4UR3GH4dWk9z/o/prXMZPRmdQvFAefAejXdmjUTAy
	IHGKrND9k4FUEs2GdR4Uo7PrIYxZW2X0WAosRE9N0JfNFqL2PjiUl0QssMKWnzl1hgvx3j010Zg
	juUuyBOTmpH2F2BUMAXXYhcjSjVIEQx9cYfSR7jXlofrTh7a/qJqfTLhsMT9akdolFcihzUzpPY
	GLbCRZLze8Zgc+OtpuYBF84t0pPRVSJpbk4dsEv86e3yo=
X-Google-Smtp-Source: AGHT+IHaglaKkw7QyMbGEsEV4gTcSx4b/Ps7GCifY+uWygIU+PJPwrgvRO0dRVpnqktVCBoBvNUDww==
X-Received: by 2002:a17:906:eecd:b0:afd:d94b:830d with SMTP id a640c23a62f3a-b01e52b79camr796896166b.62.1756718384210;
        Mon, 01 Sep 2025 02:19:44 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:44 -0700 (PDT)
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
Subject: [PATCH v4 11/12] mm: add const to pointer parameters for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:14 +0200
Message-ID: <20250901091916.3002082-12-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 31A3A40004
X-Stat-Signature: 7k9o59idzrwehtsszbo7yukur4jcsfzf
X-Rspam-User: 
X-HE-Tag: 1756718385-828908
X-HE-Meta: U2FsdGVkX19JGtvUGmrkSQl1zY66lGqYfrG+xfRQ8++xR7Gvx3399bqHCySKDXE34HjtfWsKTkNfHVEpDTKX5JS2+XMYJNMeV9Ib7+S7H564gwsDlDPHsoPUCwcAsX9N6RuFzpKcdokkFqJ4St23g3aDeu/SNeuvJLkZJtNAu57cCHunYKD5ihCORJ9wW0zwnjtgwq0KU9eVKxW18/ibgpGP1k+zHHpsisg59mP3HarPvC0O/X9go4BEXXtiQIY+4oGbgKNKoeNxOmKhA2SePd8luop1GPFtFjtk3V4/k+tob0yJqZQZE1ryYUDt3F3sC9tySTi08Yz9Mfw/evpYog/lXK6uZpuzhe3UrZ5Xp3gYv8eEBQIHMO3zVky4OwfMcklp7ycOXgMeglzgM6BkFO7hkqH/12iQeIKDE+HI1FiMQ19efwp6z6Ou13Ei+WdbeFxQTisWqRHjEk8L7Cwe/AuPYpTcyagIH6cV0bsri70DqGCi1rUCqeV42EjwzpZ0q3stNz3CX3kXgBDfCA2MpAXFp0+1S0JW59FhmGq5afcuRb28Um0OwMCVC5WUytu4YbQmcbK0wzBzQzOquITRFZO92dMd1zu0Ls0c5h5d5NMtHnYucIAx4alxCArDVTmijRy7ZrgjMC9DwFFbY7JT/F2pqBuZx9PN26LjMZbVVgoYZd4YwsEqE9z0086arhlcYs0j69EyepWVm4/AZ4tZOWK6Y55dPGaV8KkbM3ttKijkBlYU+jNK+NNNHRNmERE0nDzcMHXjjrveCzr2547HFcn71J/t5TDRmDLqM5edriljHJdiTaRqmgTaMhqOl/nNWslH5LAeMPTLDaqiMSCrjSz0RJ6f9xBeijmH9SOhliwckCPT/pN3fqjD2xILMYAaiweVftH4ELsrlYJ6sZMLsbmARK3UXDfUA6X2GMs3uhx+NWatVItUlZp0WaamB/sj25fObGP8qVdDTPmS7cx
 BYoDFFtx
 sjKFq5XPdnevmDTNV4032Lnuomdj75ai7pdgfP5/x/UMgLrn+eqhq6GR16gxSIUyiUHh2JZsqvFHvYHZWO06eLdSpk7KE2I5kO1Boe6+/+pRleB3Fv/nz1U7uJS1AXirWLgn3YZfuwKp3sqHGnSLeLu3FNIaZ2jjVD1AAbK2Mqk2qOmfPohQlQFh4fP+X/4Lsj0UmNbMuecosjXL2oE2hgQtYowt1jFqI3k1RUEMLh/pFTIr1RiQvcwoNW5jLxsN1oqbKGVtezZPaRBHA4mn8V6ksx/ikf8N9I2+RB3usd+kNWiymd6HBsFbAbxlLgZ3oHZ8g+OkW1ZTDemr8wOW8q30KlTQh0Tf2hro3yo7GlAg0qBM/tsGOZ1OMhBA2KK0OtQWrRdjE7NWWJRljn6GVhIfvOvdLA9nLq0areNm6HncQaR/uawZeA1EOvw==
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

This patch adds const qualifiers to vm_area_struct, vm_fault, page, and
vmem_altmap pointer parameters in core mm functions that do not modify
the referenced memory, improving type safety and enabling compiler
optimizations.

Functions improved:
- assert_fault_locked()
- vma_is_temporary_stack()
- vma_is_foreign()
- vma_is_accessible()
- vma_is_shared_maywrite()
- stack_guard_start_gap()
- vm_start_gap()
- vm_end_gap()
- vma_pages()
- range_in_vma()
- gup_can_follow_protnone()
- page_is_guard()
- vmem_altmap_offset()

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 23864c3519d6..08ea6e7c0329 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -703,7 +703,7 @@ static inline void release_fault_lock(struct vm_fault *vmf)
 		mmap_read_unlock(vmf->vma->vm_mm);
 }
 
-static inline void assert_fault_locked(struct vm_fault *vmf)
+static inline void assert_fault_locked(struct vm_fault *const vmf)
 {
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
 		vma_assert_locked(vmf->vma);
@@ -716,7 +716,7 @@ static inline void release_fault_lock(struct vm_fault *vmf)
 	mmap_read_unlock(vmf->vma->vm_mm);
 }
 
-static inline void assert_fault_locked(struct vm_fault *vmf)
+static inline void assert_fault_locked(const struct vm_fault *vmf)
 {
 	mmap_assert_locked(vmf->vma->vm_mm);
 }
@@ -859,7 +859,7 @@ static inline bool vma_is_initial_stack(const struct vm_area_struct *vma)
 		vma->vm_end >= vma->vm_mm->start_stack;
 }
 
-static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
+static inline bool vma_is_temporary_stack(const struct vm_area_struct *const vma)
 {
 	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
 
@@ -873,7 +873,7 @@ static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
 	return false;
 }
 
-static inline bool vma_is_foreign(struct vm_area_struct *vma)
+static inline bool vma_is_foreign(const struct vm_area_struct *const vma)
 {
 	if (!current->mm)
 		return true;
@@ -884,7 +884,7 @@ static inline bool vma_is_foreign(struct vm_area_struct *vma)
 	return false;
 }
 
-static inline bool vma_is_accessible(struct vm_area_struct *vma)
+static inline bool vma_is_accessible(const struct vm_area_struct *const vma)
 {
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
@@ -895,7 +895,7 @@ static inline bool is_shared_maywrite(vm_flags_t vm_flags)
 		(VM_SHARED | VM_MAYWRITE);
 }
 
-static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
+static inline bool vma_is_shared_maywrite(const struct vm_area_struct *const vma)
 {
 	return is_shared_maywrite(vma->vm_flags);
 }
@@ -3488,7 +3488,7 @@ struct vm_area_struct *vma_lookup(struct mm_struct *mm, unsigned long addr)
 	return mtree_load(&mm->mm_mt, addr);
 }
 
-static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
+static inline unsigned long stack_guard_start_gap(const struct vm_area_struct *const vma)
 {
 	if (vma->vm_flags & VM_GROWSDOWN)
 		return stack_guard_gap;
@@ -3500,7 +3500,7 @@ static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
 	return 0;
 }
 
-static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
+static inline unsigned long vm_start_gap(const struct vm_area_struct *const vma)
 {
 	unsigned long gap = stack_guard_start_gap(vma);
 	unsigned long vm_start = vma->vm_start;
@@ -3511,7 +3511,7 @@ static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
 	return vm_start;
 }
 
-static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
+static inline unsigned long vm_end_gap(const struct vm_area_struct *const vma)
 {
 	unsigned long vm_end = vma->vm_end;
 
@@ -3523,7 +3523,7 @@ static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
 	return vm_end;
 }
 
-static inline unsigned long vma_pages(struct vm_area_struct *vma)
+static inline unsigned long vma_pages(const struct vm_area_struct *const vma)
 {
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
@@ -3540,7 +3540,7 @@ static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 	return vma;
 }
 
-static inline bool range_in_vma(struct vm_area_struct *vma,
+static inline bool range_in_vma(const struct vm_area_struct *const vma,
 				unsigned long start, unsigned long end)
 {
 	return (vma && vma->vm_start <= start && end <= vma->vm_end);
@@ -3656,7 +3656,7 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
  * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
  * a (NUMA hinting) fault is required.
  */
-static inline bool gup_can_follow_protnone(struct vm_area_struct *vma,
+static inline bool gup_can_follow_protnone(const struct vm_area_struct *const vma,
 					   unsigned int flags)
 {
 	/*
@@ -3786,7 +3786,7 @@ static inline bool debug_guardpage_enabled(void)
 	return static_branch_unlikely(&_debug_guardpage_enabled);
 }
 
-static inline bool page_is_guard(struct page *page)
+static inline bool page_is_guard(const struct page *const page)
 {
 	if (!debug_guardpage_enabled())
 		return false;
@@ -3817,7 +3817,7 @@ static inline void debug_pagealloc_map_pages(struct page *page, int numpages) {}
 static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages) {}
 static inline unsigned int debug_guardpage_minorder(void) { return 0; }
 static inline bool debug_guardpage_enabled(void) { return false; }
-static inline bool page_is_guard(struct page *page) { return false; }
+static inline bool page_is_guard(const struct page *const page) { return false; }
 static inline bool set_page_guard(struct zone *zone, struct page *page,
 			unsigned int order) { return false; }
 static inline void clear_page_guard(struct zone *zone, struct page *page,
@@ -3899,7 +3899,7 @@ void vmemmap_free(unsigned long start, unsigned long end,
 #endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
+static inline unsigned long vmem_altmap_offset(const struct vmem_altmap *altmap)
 {
 	/* number of pfns from base where pfn_to_page() is valid */
 	if (altmap)
@@ -3913,7 +3913,7 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 	altmap->alloc -= nr_pfns;
 }
 #else
-static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
+static inline unsigned long vmem_altmap_offset(const struct vmem_altmap *altmap)
 {
 	return 0;
 }
-- 
2.47.2



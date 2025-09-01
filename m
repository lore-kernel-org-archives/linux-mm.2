Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CEADCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F25D8E0048; Mon,  1 Sep 2025 08:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B828E0013; Mon,  1 Sep 2025 08:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C1C8E0048; Mon,  1 Sep 2025 08:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B88C8E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:31:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E72601607F9
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:59 +0000 (UTC)
X-FDA: 83840615838.01.E6B2640
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id E94574001C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GV+KIL1R;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729858; a=rsa-sha256;
	cv=none;
	b=QovXZM4XfFW4DXZDSocMBFMbmdDF0pldGT/antP9TebCiv3+B+e+dltKZfBAewjbZlDP9h
	2M6uOPevsQq1iWyXgyHtdkeAsQLi2QeYp3jURUSur+QgBTamso5MaZiyQHNkqw7y7la+1g
	6EP8RutzFFTKn50sIVnWsrOLaygMmqc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=GV+KIL1R;
	spf=pass (imf01.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7iVmeI4QbKEqLSgMzs/KBDF5kQHVdSmVc3arqRn58E=;
	b=N6iQxw8aP0r8QU7goal8VRwIo4ePqJkUGyC9m7wpl+EulSxxnpZdBF4ygEIdBD8W8FH7Xc
	YjOcfkXaf+P9iTKyWy98kGq4XUeupI8TNYzc3j8XpqcHhR+IMQfrMVK8HhPZllPLSS340m
	KRLVVbjfsFEaIFQxTQxdGXZ8lc51JdU=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61ce4c32a36so6732792a12.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729856; x=1757334656; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W7iVmeI4QbKEqLSgMzs/KBDF5kQHVdSmVc3arqRn58E=;
        b=GV+KIL1RPXFqGTOG1qImLgEXx07N4/947WxMMwo4yBhzZoDlYgD5AKCx0NC+JTj1B0
         sNCo/LrxZAjGttL3FYUHafoNnD6XLO3DvprwiEgwpt05gvvGFaJ/5nusRO31Iuu8ZsoL
         8UrWPT0vaPGgUh19ef6ihSFjq20/11I9balvMsnXtUfx3xcbLnRF6gCbD+Vr4vgSl9XN
         tkptpGfJ/mmsUymKelKnyrCSDBTBqs05kDOzcL9bB7c0c6SlPhgCslQ+Bk1XCoex47kc
         9HFycpl3+1iCIWm8X0nnJh9l0WKSegu+3dV1orLGM3ywMcL4y7H3Q/ynXeRdMeBjKVti
         s/bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729856; x=1757334656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W7iVmeI4QbKEqLSgMzs/KBDF5kQHVdSmVc3arqRn58E=;
        b=PR0mijRhsGzrlzwMqjXo7VjyUwiwnaNkrToycvV/eXWUZNLF0+c380UEGfegQTvVMu
         By34cdWgrikuIRx80PwAWEz0IiCRLsID/TPFAe7uf8P+z7E2hW1fpUwhX9npQC2cNUcf
         9BSeLM06TD5J8mLXx2i26eYoLxdQNCDU9YrlEyIXdefmp5tk+yT3NiwRrDlXnokjXJq6
         UiVXL4x5cc+6VoVt8m2vlb/GI7gJKU3uIImvFEHEQNv+iuMeb29LSEs5DDrSkbY33Ypp
         x/kerSUEX7/9ZMB6SSvncBG6f3ArdWGV7t/89ZBxVt6GAmtcoPIVGYpskg5FwFg0uvk4
         ktoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQNmVRMOjxFq+v7fiF8c44x7J/r86vtwpsPIaT5M2gZM9PdDNf51bB0Q2aaPmEjaZrxtKMXD+Fyw==@kvack.org
X-Gm-Message-State: AOJu0Yxa6BykP1yy6e+KYs5Us9hUR6SZeobvfZoHa8BXZWVJ0tq/jgGb
	ugwVn1QmqSbFsaG8CNEoHRwhTw/+bQliNeLh7F14m9+VSjiYvg31GUiEpso1FisVr9Y=
X-Gm-Gg: ASbGncs4XRMHkdC3r9ny/lGCAUQZuTktAVEDHGOrK+fXE3kSLx9tkVM7HSUKHdswV6O
	ldYd9vzxogueioqjoTMI7bcA2kjrOP0hCmc6bsJQRdo+jvyzJPGnhleLPuWN39FQ1S2YVBCrgEi
	tHQcalaskcZmPU9ERalE8RRgA5jhITgUtgleoGeyt9OgZ87r61ibP2Y0vDAMoHq2cg/ONKSaL7Z
	+3nAHbhYv7iyXAxxvTWtnkldcTXv5ufFPhejW9c4M6oRh+8APzYQOLttMLKxZJc3dkBIWEeRnNs
	uVCyn+0YIXmM9Go0UU+x0AjapUgy/gpaKbv6EeITEIFhJYb96PbqnkpeSiKAayscSB9B/NTvSAp
	9UZVcUBqGJS5SaT2QDKreeWu9OmlAo30YGtj1wWEhTLPMMl5LF9Lmgc3tK0WrW5bXWMMh5BHNf8
	qKPkMK95TyjxnPnxwRsl9+PLS0jMiIiwm2
X-Google-Smtp-Source: AGHT+IFoXjkT5AKVagAxNg7F2t10e+aOutMVefuJzQmttAG6qfcyBYcXqTaEs2cFD41mn40EFxW2tQ==
X-Received: by 2002:a05:6402:354f:b0:61d:2d2b:76ad with SMTP id 4fb4d7f45d1cf-61d2d2b78fdmr6247075a12.14.1756729856194;
        Mon, 01 Sep 2025 05:30:56 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:55 -0700 (PDT)
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
Subject: [PATCH v5 11/12] mm: constify assert/test functions in mm.h
Date: Mon,  1 Sep 2025 14:30:27 +0200
Message-ID: <20250901123028.3383461-12-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E94574001C
X-Stat-Signature: mq4154gfk6kj315rebbp163uurg5m5to
X-Rspam-User: 
X-HE-Tag: 1756729857-12300
X-HE-Meta: U2FsdGVkX1+UM9Trs4KGJLXScM3C0leL8j/JVHxRX1b2bH9tc2CSxH8aUrryQud1jX6gi01tF0nmi9FckNAr71T1JZypZNlGy/pKhwmfq8/ugiWL1u2q16RBXEYeUohliq4Jzh8rCDq/JEJILEhknX6051PX+519Txfm53L9IVqVlteINmt/NY1TXY98T+LJnZkDFd+UH+lV9Hezm6mLd3cuDRq7DE6vH0t+2zvvsQ0PETwRIvZxjZLI5CWIXjH/krrpkjxePYXk3+cC+vnygCNfSeHmY74Xr4WC1/bYeojgo2uRcpOw9X2omopqsr16SxqIPzdvCIeoiYvLGRgZluegh5CB36jjgrpZ1xbGp8Vf4nhuDd2RMjHjp3a3aGLP654a1HwFNTBNnuiIYDITdhlgEb9Do3hU6gxDm3hes5rGIpverFCzLTEXJ/dgEd67fhHDXDgxQdjVGS1kIe2EJzwfCj0R/BF2EZ88Y2oYgBGeiZp3qfkLFrVVhjPZPNBxVdDOdJCdX/zt0s/4BBUsshMwSvUXC3IdxZUC23kikO8q24F8Nlckl50FX3ZXpNzOmSUdYtAAJI5PhPGNIKOAE2DJo6YQaQCJ7jqOw6d3k0z3EGHy8iIojfExtuE2cj2QKhIqXaB/C6A2B6EjRb2mc6TweCFXsN8CeJ8hQumzri9qWDzMHVV7+w7+dfl68ohjfgqh2c72RI9puFE5vwgl+wOA+jJ0vaCeifS4EkYRWYevM5g8k1gvzYbnGqJnwvxtf+oL8GVm3Bdng1UZvPfCCJ/8gB5CJKwq9pwwZdMq8uG2rxrvhl5y/P5YV7PNtXLXWaNuy9yzhcOEKN6qv8c1lcIIqDdWlgGEgnTaBUCEUE/40/Pw51Sca3YMleMV4sA+2z6iFkKK6T+0Hkp0fZQ4pt9odJdU9RGcxS3ZbV8FjQbyqpvikCfmGjYk0kS/nk+lZCmKWXUV83ZWQxwh2Bm
 xCsYogc8
 Kh7WO689L2FATM1Rk1rS3tBMKyAvRGtQ48SJQiXSG6dXMfcSxnUUgv/ENR2FHcf8eaTm8+vRzSD6ApQq4S+jTdQvs5+3SCa/K09FRoEjGqzu74m5ItLa+xjTLT3H+H/n+q2ANSdigXG5bU1ZfKKqMDTHuaaLbp0DreUWivYfh0YmLFgBrLWkks4t1sAI1eK02sIekUyZWJdPj2CpLcqzM/K1V0RdnBNCRa9Z2/J3eFvKZr7mpvLWSLtcrBBhe8I+g8M+TGoIPD6/OykwN2bV3AAu4tEmhsnfAVThGTMu4B/CR2PbfK/RNkLUma3KwWIW3YsJKEa79lfUxWrANHjoFtlnopC1JKO2f8OEN8s/9xseHXvvtpI0Ksqg1eAe0s1ccNPcJg1wii4ZroQYgY3EJdBxu5Z9iDDMtV4PoIvh7ciE8CKfBpEGe7/nXFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

We select certain assert and test functions which either invoke each
other, functions that are already const-ified, or no further
functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm.h | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 23864c3519d6..4cca66ba8839 100644
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
@@ -1839,7 +1839,7 @@ static inline struct folio *pfn_folio(unsigned long pfn)
 }
 
 #ifdef CONFIG_MMU
-static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
+static inline pte_t mk_pte(const struct page *page, pgprot_t pgprot)
 {
 	return pfn_pte(page_to_pfn(page), pgprot);
 }
@@ -1854,7 +1854,7 @@ static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
  *
  * Return: A page table entry suitable for mapping this folio.
  */
-static inline pte_t folio_mk_pte(struct folio *folio, pgprot_t pgprot)
+static inline pte_t folio_mk_pte(const struct folio *folio, pgprot_t pgprot)
 {
 	return pfn_pte(folio_pfn(folio), pgprot);
 }
@@ -1870,7 +1870,7 @@ static inline pte_t folio_mk_pte(struct folio *folio, pgprot_t pgprot)
  *
  * Return: A page table entry suitable for mapping this folio.
  */
-static inline pmd_t folio_mk_pmd(struct folio *folio, pgprot_t pgprot)
+static inline pmd_t folio_mk_pmd(const struct folio *folio, pgprot_t pgprot)
 {
 	return pmd_mkhuge(pfn_pmd(folio_pfn(folio), pgprot));
 }
@@ -1886,7 +1886,7 @@ static inline pmd_t folio_mk_pmd(struct folio *folio, pgprot_t pgprot)
  *
  * Return: A page table entry suitable for mapping this folio.
  */
-static inline pud_t folio_mk_pud(struct folio *folio, pgprot_t pgprot)
+static inline pud_t folio_mk_pud(const struct folio *folio, pgprot_t pgprot)
 {
 	return pud_mkhuge(pfn_pud(folio_pfn(folio), pgprot));
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



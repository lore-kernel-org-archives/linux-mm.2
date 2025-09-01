Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C61ACA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417588E000D; Mon,  1 Sep 2025 02:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AE88E0006; Mon,  1 Sep 2025 02:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB878E000D; Mon,  1 Sep 2025 02:12:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 067588E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A10F4160676
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:46 +0000 (UTC)
X-FDA: 83839662732.12.4CE4200
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id B2D5D180003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NXzkPAvg;
	spf=pass (imf24.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QlbLlerU4Nv7VRATJ1BdVJRZNI5zbhELrg/7ukvkQX4=;
	b=VT82/fGAeK3Qerxb70HrXk96srejWH9tO4ZpzdS0lLDYTvlQ+8RVO13BUYftQqm89nIygF
	uUEUTNF6QkW1FYcAZQnPxCfpSGIs3vlswU+nHGIHPUcIQtpIPTX2q4tfkqbTxNJ2YpfHl+
	NKfEo9C6AHci8ERmPLp/w97lsRumEBs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NXzkPAvg;
	spf=pass (imf24.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707164; a=rsa-sha256;
	cv=none;
	b=uddPrnSNMEd5O94XTZxu3oEcQigZvwHJ7YVssgOaqvdamIB6KOc5kpINot9MhBaD8NbGZC
	QI6DQuLBDaeEYiItxiNj28j/BcmXkYdRhmyHTU2ewm5LSv/0xe7hLHaTXzbjNWQ8WKm3Nt
	RfcRWlN8ISnKGj5UVGFyxJoV7TI2tIQ=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b042ec947e4so76376266b.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707163; x=1757311963; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QlbLlerU4Nv7VRATJ1BdVJRZNI5zbhELrg/7ukvkQX4=;
        b=NXzkPAvgqJe3FOAjFJjZjOs2HtKK8xbsK+4NMlNemJsTeXHBlpw3IVJI905wQSATs/
         Yy6s3hVUCnC3B5wJte+7HdsXevRVhQWOL8Hzajgk/inaW5DHAwskgeFDCX+LlITuj+SW
         ZMZNMQG768J3iTsan7y99TtkoAz7U/08/FUl60rb87bS8oPvHqU4IByrfFohqWpFYmLG
         FL1kMOLcwB2Cgkd9RLtTaxoDK0z3athQ5UU0wmkuz9jgA3lgC+kT2mq1s+VYzjsDqOuM
         jObbLXn5NQwu+YycRbjXifr3cZEtsElrD7/4zAO2GmPiZAm9WWwANvAXBKSGENxZghjr
         kodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707163; x=1757311963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QlbLlerU4Nv7VRATJ1BdVJRZNI5zbhELrg/7ukvkQX4=;
        b=CM62uJNnSGWMGTX7GNdeWxAhn2x8Z8tl4nlPNrwxuscxDgUo/vhKlvIME5WODYVepn
         0AI2I28X74X/FZ0uezKqDE2s9UVQHWTYzQr//bgBdmrmu5w4u6R0N4Ll9NJOiSlYzql2
         SOMnhJ2ei5bb5OrhGCh6FUpjgFo3O1axHFdG2UnzcMaz3mfbcUyROI1aph7oCaXdij6i
         vVjUvNgwPuCCc9WPoPs4o+YWjL2fTROq6G/2MEYKkyIa/k2yzZn1BcpeAqzxfLDy44Ex
         o3Q3b0f5BBvD/XXOgtuvjXz4RTte7YgwN/AfqaLqaJLCf5VSiHIieyiwhmcFyx7/0xz7
         BnoA==
X-Forwarded-Encrypted: i=1; AJvYcCXS/5JuWf/Icjy4xrBj4Lhr2SBYtCOVI3/dhzWGhXHWhwbGa/itE8TqFQ/6LhbT9pOkm3D9XBRUqQ==@kvack.org
X-Gm-Message-State: AOJu0YzqqDZRb9oFpw7IFiSA6KQsTcpZanX5I1dcZOqAXTMcBHZz7pKi
	/WexDPehptZrYWSGKyEhbAsAbiqKAvCj+C7wnZJBKhIjPT3lfu3Rec2lDIGEomXhZHs=
X-Gm-Gg: ASbGncuMdClGpvC0risBeTh6beeESpdX7u6STqWvDtklv538ljB0OB9eHoz1UohsM0a
	W5BcuGVopqrSciXAT7keefb4NJL4z3AFimsIsXoO/h3srBTIV5W7/ifDIg5SNyOclT3UWeKDeBG
	OwU1J2fCV7ZhM0Tmq1Hd6vF+3PoH4vdrTP0HMBCWG/vLCR6MyhMjF318teGtxqksR3oKDvCRETb
	FPfmPigQ9zHwdzjXnPJuEyhVt8juTNS1+PPfMo2ERiDQEZQc9bwDzXBl2vs7lSMlnqHJ9NFjUNK
	V7HfAk/xNvBlgnFF/VfQzlcw94EAU7z6CopjiWnXg7OcyQF+O2ymZot07RqFGS4huUZSacGZnRZ
	M4MLEeuKGfVtD8Ge6HdhhyXs+vjRQmVMD5d7Jgext6JekbLIABUd16f9Jh0J3rczWEkRPudCdjs
	Chjn2U7hf40Lj46VpDVtIvlQ==
X-Google-Smtp-Source: AGHT+IFuOzWwmxNav3f4LNFAuYGBeVPVJ0k4jaWHV2jGuHJcSK02hDH7szBWJDGdSFOD7Y7CmAbx+g==
X-Received: by 2002:a05:6402:26c6:b0:61c:8c66:d134 with SMTP id 4fb4d7f45d1cf-61d26d78f38mr5814175a12.18.1756707163204;
        Sun, 31 Aug 2025 23:12:43 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:42 -0700 (PDT)
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
Subject: [PATCH v3 11/12] mm: add `const` to lots of pointer parameters
Date: Mon,  1 Sep 2025 08:12:22 +0200
Message-ID: <20250901061223.2939097-12-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9eqro44t4qa5ay5kbztb83c6hhj9a1s5
X-Rspam-User: 
X-Rspamd-Queue-Id: B2D5D180003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756707164-977944
X-HE-Meta: U2FsdGVkX1/Nzk/Rn0jXoUvgHaY5yjCH/+dwdnShRd0LkI55trW7xaF8DBaCUUVzsaxgeoP6csgtfwQC5F4OlsXizkUyrkpDH0SPEjAOHW3gUZQ0q40p0OO+9a82H/cpNuk4p28y20Xc76PViVVPrMwiIG2sqWirdCKVRqBZs7EHMpAfM+LtPiCY6zE/7NVeBwMf6AsTH/1xfkcPZw24+4tLkFG2XqWFql//MZnNv6y0kljgsSDny9p+LIYMSDB8WZhLSBDU31kTqP1kz4Onr9E+JuwyOEqZMgLtlNg/czG/KPiyT93lyCk2eFRn9fW4x+0Wq/6eTp9YpqVtogizcDcbQtKK5fSDD2Zo2KmM4TW0dtew7YxNiHjbgcfuxpw2Y9MpO6NJMPlzsSMiTav4l4c8G6N3+7qWi4R6GgmNMQuJTN7SyPCYEYHXd1+uoSTIOZc8qZNx62L4ZsqqyNDJYIt0P0i/1NR0qdffsrJxlo+jP2Ghfx6bY8KOUpYGhx/fuCL7slhN+vUCIc8j5a1qKOnHBbhjmp0ECaqb55reaROiXExAa+T52f+SczkVnhty34w93XOr6HQ3043HSjXgsWEHVO/C3k2EQScEzajTL339bZovj3HtW5gzIhuZzXTeKOZnkdxAT6h60c5qGcAMo9qC+htIkoCqyRUXB8GpTEtL2gR93zdCTKve3BDSJ7GxNECUSGZa1Bs/1BcUkNW5zOXfVSaLu4Ut6hiz0J3UrqIO4R2xchZu6Cdy5b2cKHm6G5Mbj/cwg/flgXvUwAo8DLioxok3R7NrJ4/xEduEsMu43FOuzu96lwg9YnTcBHI29bVFdVDHeL9mRkhLwDwSYn/2QiIZByXvlHP2NWVJrSghrMud9FZLIMGaHRTJaELCvYbBsSZvOlxGCUxnVZ9uJCL6lF5J/ziTGdhNucEFbDoWx8ZRNmGJ/Wx7pIWvq1zWZb+HC2pznCG8nm7Q5kw
 Xr0K8lKq
 nvZO9iMp5J9ONj0h6EvAPT3NSangDXv1FZhlKskhLm+rXsOj93vaJ/8Pz/yqUvH+IKynIgJkGxeAzxxcRiMRyw6M8TfXqVsuWwCB21OtTjTLp9HbQXA2YFHIu+ppGmwXTi68xrzo4/q03Q65r3C6qxB75R63ugkn6Eqd1GsJZO64wpBUV3oLlXTwpmF8gcnKRm/j/wZ2iKw67VN4/VwE70zmKqIupYwfYQHyyUx1MBX6AzIB8one2WqTnOFVkTusyI001iKUEIdkmBi8BrfGJzC9BVqG7u+qyLXHCHt0kcmEz+KVa0jTeQABdFlgr4WQEurbl0HUAqRVobIhfyf3lknRQ+qY1P5XDs/Cno9+74wCE1MDfJg+LVbrMfV8/d+4I0kl4NA1jVfyO53rOmFg3WhYX1MeaTEo6xMQqDb4pjpGvLDm/+9Z41ufZR25bLg9nh+bG
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



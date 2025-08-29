Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12363CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6E26B002E; Fri, 29 Aug 2025 14:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59EB6B0030; Fri, 29 Aug 2025 14:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B821C6B0031; Fri, 29 Aug 2025 14:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A48BB6B002E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BAA41608AF
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:20 +0000 (UTC)
X-FDA: 83830640040.16.45C69CF
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7D50A120011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Kodw9Yy7;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pe6DpLq59T2oGBgvmta3nCEJaBGqnD8+qIkEiE/ndtY=;
	b=M1tLnhoh+1uIXQRUZ3zUy0Rzs/5niSA+8T4XJVrVWpbeOtPLHzC+fyJT7dgXDo3XF01grK
	NGaeCaZZwH8gZbfnj+xfPylhI18Nqz8RZ2icM6bWm21kdeZ9InCE16dpjyIBVgBObR/Q0h
	06OPf6CaLmCDELGTEPaMi8t1kCEcumk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492338; a=rsa-sha256;
	cv=none;
	b=g3w4zdbOmYsX5atCRJNRyfqm8NMS5O2toLAFZwr/g4zgpJcFUFHIWBPMnkcneNWKuMNBxt
	gBniI86um/Tu9o/vugY+X+XO3HpCPyMTyrFJpFAPK7HQJ3wMP6LQVbm9rG2dhLa0ZzackU
	StBBrDo8r665CjnMnfwUCc9QWSoDZKg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Kodw9Yy7;
	spf=pass (imf29.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb73394b4so357514066b.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492337; x=1757097137; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pe6DpLq59T2oGBgvmta3nCEJaBGqnD8+qIkEiE/ndtY=;
        b=Kodw9Yy73nEkIHIRuCwIH+Gkxn7ShqdtUgExMca10aK2iOdR0fnn0wWO3MQjbAMBPr
         ljEhalqyIMP0Wo9TcViitHi1k0L/TWSuMcP+1kBQMltmAQA/5H71MNxG8hdV0of3cC6c
         bqHNBcME+wPqdrajkEkPQI+pbQXRY7qhzxhjW/la8/U5vjLB59Cyx+/P2TQdDA/rf/3a
         S1/Dm8ZGiqzYZyFINUDbIs9Dzry06WrQg8NBGa/oEtaseVL6OcEnlmI+WcWj/lwYKbRq
         j9rZCsbQM2gYc939ojIG18dh4lJ8IJGoQ7qW5mcn4vu3MijzQF5/8+O+3NcRvjP1PBXe
         B//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492337; x=1757097137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pe6DpLq59T2oGBgvmta3nCEJaBGqnD8+qIkEiE/ndtY=;
        b=iuXq6C7RyLJ0yWI17+WTDY3dkO2Nx8PLVIKnakWtWDCBr757oXIr9NY9kQj8lL1Abj
         poUfnUhV/28dxfFHq34DyYO8vKKNeyI9Q9ZUSIqYjWuUupva5/GbAlIDChDjK6Zrm35L
         CzL2NnuEAxx7OivHCkphDH9DwwGmgWawxZL6AnrckxKooDDDSJ75Wz9L7+LwHrJT4Cw/
         Y331jxM2rvlWF1V3oDk8xah3jcwv76gD+u2pkBxR5PPfGMK8nTNsQQfv5P3QaHm9YGtq
         k7HC1M5buRVw7j5zk9j2epkC+76hX1Y76nJPy/zaSvqKb/q5/ws+ir+ir3U2NB5jb2cX
         woFw==
X-Forwarded-Encrypted: i=1; AJvYcCWA5nhirx3KVTDp5UNorNIJVSsARvMhE27Un4KA8caSX3QbF08Fb3lbzFRvNCytqWbYsBDYGzjRFQ==@kvack.org
X-Gm-Message-State: AOJu0Yxs1WLDcXwnHCYo5yxaHS5ZUxK9sTXGuIwA9ro6Gl9/pOQWSWCr
	8VpOAjPZcn1gEMFq9PQzxFms9hm3G1XXDE6XZrEFjjRZwFaTkCb5kTwcUB2FDWaNkUj7Iw6GeYe
	LIDZz
X-Gm-Gg: ASbGncsFLqZAY9NuzX6vPnjCJafVPca1XVqlCcv9XRvHLBJF0rbMfkmjW83LRoQs9ll
	jkTZQ1BC9WV9SGdCrkDfkpG9m+P15dS/t3SEJQOky3Ej13KCMEPWxUOllS04ohfjdrqeIcmWiF7
	So/j7kaMpy1BmMIn8BF/Oa2m0h+DlbFICR73Cu4Q8d6rBCk6QOwvP2CCQQc3mhlL0UnvmLmd4YJ
	AaT6FBpFYzihBG3z/eU6B7gwWmKB+ONkqa2VTF96zKri3HWPAsPBo/Ah0Ll4dimqmJBUVNrL2CL
	P4RHLfFqnFXIwUbwBWybjkszzsLEKmhv/OeS4SI92txsH6HOyXDGhM3SvlgP+Biha6dfkcfRTK7
	60TMfB3yjNztgsIQQFRzfVa3a45c77qKpA9z1RRt4wii0IFy3tEJfKURCTo7su5g5KkOoDzIcBp
	AvLlXW4vwT5iZr2tlE3xeJZw==
X-Google-Smtp-Source: AGHT+IGUAfjuxVvWgJ0jIxnVUYcEnT26Z3aV7rgprRJcq8RNlAdb2W2lc2qvTd0AHP5zAdyY21KVaw==
X-Received: by 2002:a17:907:9687:b0:afe:d48e:34f5 with SMTP id a640c23a62f3a-afed48e3bd5mr851988966b.12.1756492336971;
        Fri, 29 Aug 2025 11:32:16 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:16 -0700 (PDT)
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
Subject: [PATCH 11/12] include/mm.h: add `const` to lots of pointer parameters
Date: Fri, 29 Aug 2025 20:31:58 +0200
Message-ID: <20250829183159.2223948-12-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D50A120011
X-Stat-Signature: wg5gdk64bhhk6ipcaoak8n9e7bhmq8dz
X-HE-Tag: 1756492338-430249
X-HE-Meta: U2FsdGVkX19AQzvISRMpbRdBXmuNFG2+JHXy+ayJq7CC60lOe4jJo+26CVUML3ERV2CCwFXP1FKPKp8/JxkkVUSQTbTpIFyzeFZz+ECKqFVWSWKdHnqoWeu8Nfib2bW/K1nNG/CnD7abisDcnpqAMkYzloPxgLxheJi8gqVg+FaC9HS9mMpiaBVspgpbtqZPa0jxwfOG5GkWen7SKt11m0wPJyBluM/1903/qGAodgUcqmaxbco0fwGBVoO3TpqDcNwPms3622tsMrk03rppPg3OciXc3vsM4UxMAlmieVC/CNNtF1jN+zqTiAaKjZLWoXqc2Eeyjop1ewipgnC5SlbqUyetnFvvlC1IrazTXcOaghjs9DqJxydyGqpuwShbJMVkX1tXOafDlYaKHsxte+hcydGuG4/44jJox+bC3OV6At2+PG4Olb7RodWoXRZ5qgcNIlBgRTorSrOsasKmaij9+ouAjW4g2pKIMN8K4bRlYLa7jaYsrHA/jWya9ePEpOoNvvMNQj62TuCIhZmICqxBaDkI6g9QJVmIIS8ecyuGJ+ben79pR9U0FxLzmdkfp9bz10i1/wCyAGTI9LjmxMXcV88TT1KTQBAH195AW9/MHYvaOF/hUKTVeyCPokaaX9r3QGoswUUOc+yggCdT0T9zeLbVNMC95ctvcqei692RWneSBTs6SZxgTUvj+DGfAJUJRJWwhK8s5EayP3fGHSbilrlpDnDu7xe+P0xTK+TaAYv4UMBIfDgzrWxUExWl3XCMTo7oOihtLHYFCxRojJrivBq7KiO5ujxIJMIjipipvRLzNEf6eMrmbb6BQ2S5klHw2gS3jBkwxSfHN7ovPKKL7D4lAIr1AiWFzzVnZ0dTRBmYOaO4gscqlApDhYcdGdgxWm60KlpObP8YqTBbL4KK14TBoO+BdXKjjZKcOI56HY9TYb/Fn/EMlYmFanpq819Dv5LD+DUxvXfL7Vr
 aUerThhi
 1hL4YZAfoIdIci0Ztf8upvt9dDQ5jWVmYpqbjFgOke9AtiANaqyJhmxafx2KgKRxFJyQK4JmDkLE0Vf3VfUu0eBP0jIyMaZlFpDBJPLRJp6em5aZweoGF41jIQQSzgE0GxCgRzQaPrNji9QfIl+0qlgAPU2+KtL0JAGUX86HdKTnRnma62yrzyoSFrJZxV9HXZovBNDGy3E4pPCY3QwzwsjvEYYs72bv/Z3RnRkQTryhTe5F/2STjWFNg/3H+IZrRdtg9j7xZo5TbN+MMrXVpCqjoBVde6WNP5DrGhG/Eqajq28R1U6TSSm7HOwlMulB9OiCniZhX9hmigA+hcya2vOJcN94d3Z0SMHjsmPpxTHzCqXAMhLXNJeiZjQ==
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
 include/linux/mm.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 48fe838723ed..953368e578f7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
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
+static inline bool vma_is_temporary_stack(const struct vm_area_struct *vma)
 {
 	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
 
@@ -873,7 +873,7 @@ static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
 	return false;
 }
 
-static inline bool vma_is_foreign(struct vm_area_struct *vma)
+static inline bool vma_is_foreign(const struct vm_area_struct *vma)
 {
 	if (!current->mm)
 		return true;
@@ -884,7 +884,7 @@ static inline bool vma_is_foreign(struct vm_area_struct *vma)
 	return false;
 }
 
-static inline bool vma_is_accessible(struct vm_area_struct *vma)
+static inline bool vma_is_accessible(const struct vm_area_struct *vma)
 {
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
@@ -895,7 +895,7 @@ static inline bool is_shared_maywrite(vm_flags_t vm_flags)
 		(VM_SHARED | VM_MAYWRITE);
 }
 
-static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
+static inline bool vma_is_shared_maywrite(const struct vm_area_struct *vma)
 {
 	return is_shared_maywrite(vma->vm_flags);
 }
@@ -3488,7 +3488,7 @@ struct vm_area_struct *vma_lookup(struct mm_struct *mm, unsigned long addr)
 	return mtree_load(&mm->mm_mt, addr);
 }
 
-static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
+static inline unsigned long stack_guard_start_gap(const struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & VM_GROWSDOWN)
 		return stack_guard_gap;
@@ -3500,7 +3500,7 @@ static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
 	return 0;
 }
 
-static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
+static inline unsigned long vm_start_gap(const struct vm_area_struct *vma)
 {
 	unsigned long gap = stack_guard_start_gap(vma);
 	unsigned long vm_start = vma->vm_start;
@@ -3511,7 +3511,7 @@ static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
 	return vm_start;
 }
 
-static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
+static inline unsigned long vm_end_gap(const struct vm_area_struct *vma)
 {
 	unsigned long vm_end = vma->vm_end;
 
@@ -3523,7 +3523,7 @@ static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
 	return vm_end;
 }
 
-static inline unsigned long vma_pages(struct vm_area_struct *vma)
+static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 {
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
@@ -3540,7 +3540,7 @@ static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 	return vma;
 }
 
-static inline bool range_in_vma(struct vm_area_struct *vma,
+static inline bool range_in_vma(const struct vm_area_struct *vma,
 				unsigned long start, unsigned long end)
 {
 	return (vma && vma->vm_start <= start && end <= vma->vm_end);
@@ -3656,7 +3656,7 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
  * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
  * a (NUMA hinting) fault is required.
  */
-static inline bool gup_can_follow_protnone(struct vm_area_struct *vma,
+static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
 					   unsigned int flags)
 {
 	/*
@@ -3786,7 +3786,7 @@ static inline bool debug_guardpage_enabled(void)
 	return static_branch_unlikely(&_debug_guardpage_enabled);
 }
 
-static inline bool page_is_guard(struct page *page)
+static inline bool page_is_guard(const struct page *page)
 {
 	if (!debug_guardpage_enabled())
 		return false;
@@ -3817,7 +3817,7 @@ static inline void debug_pagealloc_map_pages(struct page *page, int numpages) {}
 static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages) {}
 static inline unsigned int debug_guardpage_minorder(void) { return 0; }
 static inline bool debug_guardpage_enabled(void) { return false; }
-static inline bool page_is_guard(struct page *page) { return false; }
+static inline bool page_is_guard(const struct page *page) { return false; }
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



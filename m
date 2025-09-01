Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA47CA1005
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F4C8E0012; Mon,  1 Sep 2025 16:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8BD8E0009; Mon,  1 Sep 2025 16:50:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26398E0012; Mon,  1 Sep 2025 16:50:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE3688E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79530862DD
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:52 +0000 (UTC)
X-FDA: 83841875544.18.B949ACD
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf24.hostedemail.com (Postfix) with ESMTP id 988A518000D
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=YG4ppqPV;
	spf=pass (imf24.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWhGTSQHhd/eK/QU6yjkGMEyVAFgOEBOrFZYGj9rmco=;
	b=r/qIQ8QBTP1Xj+Ig822ysdNyJPeSHn4PWGJVVq6h5vX2H68FjMUccYavZY1thfUXhgsIY/
	3bdm1eaPDulCVM2UwWXv86GlpwEbfFP4na+Gpisi+JSc2WLH2lxTIgsRgjwczkqQHiPfnm
	e/yZS9OsZFZvTQ2OixEIAwTxbctn5SY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=YG4ppqPV;
	spf=pass (imf24.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759850; a=rsa-sha256;
	cv=none;
	b=Cn/F6R6e3cl6mhMRC4kjmHkfz4UpQyMx/hBco6btQH+LT2nj2/fX1yGx6rBr7DvZEm24XT
	U+tRjQgOKn2TJvp+PpCU8klL3VBBiTEJq+7oYTRxuoAPoOciwYygqN3IUsETlQV23Gf8WF
	YoT5Ip7rho+2yPFn3yukp7LMWiBqPkc=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b0449b1b56eso41276166b.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759849; x=1757364649; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZWhGTSQHhd/eK/QU6yjkGMEyVAFgOEBOrFZYGj9rmco=;
        b=YG4ppqPVScospwJOzVzPXM4Kn0xH1ajmwA0yKGziVupMP10sRBskYt4k6lt/P9gPRV
         3vGylCgs/+XeQwPxs4SbwM7SD+zti9tAmZLjelvNloWoglLnvu8OGdnDMs2BWWjkg2ZJ
         yAp8bFaQnDej99CYluZ5mNtIeeXq0UQGXpazrqXKSeoc+KwHMfm2hNanE9CUtch3rjSE
         gE5aHKGumpRizgHfBjmECtArozuX1lV0PE+8bwSTFIqAf/f0sQ2DyEMyOae7N/WWYa2c
         4aTr4C0x436ivfzEf3Q2Uy5/aypk9ZX9zNznXpcusP76J9QGY0clD+bpcnjQqnYxj3Ae
         9OfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759849; x=1757364649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZWhGTSQHhd/eK/QU6yjkGMEyVAFgOEBOrFZYGj9rmco=;
        b=AJvuW4jYJgIp0G97WKLuJ/1jb1QUZawigy4UqtR8iQqItvwP6NAQ0BxbBxTFSlQY+R
         sOHAdpo1DHXsFIezbPlKlOwcaTXFAOtVQRQ2wy4pkdrrgVE/kM2RfA/eYZ++Er26LExo
         S1zxQ+nAeAF26XwqdcRP6W+lJ66l6RgBKI+sbLZ21WyhRzT3H8BnIJOIQabrMQH1oXNc
         mdHjxcN4XxnH68bTb1oyPYiPthCdPpfz+5tgKIY64IzeJj3xbYlMSGVpth5hoNiWdt+c
         HcARnRLf9pVhA9lqtKxSGObjnd6/F+G5HVKc3iyFY6Be62mfwvPBzYEJ+ipgC0PNlPCf
         ZRNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJzDKfFKid10Sc2IBrUCvHh1L6mslzazSfUZTmSoD71210LC/DHZd6T3vzQHngvuUeGDIzJwDX7g==@kvack.org
X-Gm-Message-State: AOJu0YxX0lQj1pTjLItDSfZVBCkhy1U2NjZShvG0/Sy6RA7Vk6yE63Wz
	nW4ULFEYfSaH1ofihBnr29nr/JCXKGGtBXyv9RTYyNmzt2dgyx+7zvxaePDsVJPwTzY=
X-Gm-Gg: ASbGncsVNxTBos9AsKNlp0+sVS4t/A17vrAUdlGnXpEwtLG+Yt8Ma/dKRLdH79VtlPq
	PqOtZ/I2q7DSqo6s/YenEubNgeCyWyI2BdtOjPMYAy2ZKBLy/5DsD2Gh/yc/wbwIbKuIEZqMKX1
	/f/GalUaJ4DK9EYUcTVCxBe6WAJwR39RerdqXWrrWWNGz1AL1GtesnJysMHr/Ld5MgvqkOHY2OC
	z5/NC269bVeIIdjMnTVvA6iaDPEOY7bKu9c3LB38lwiZFSQDb6XQ1oJWZpdEkmcwLpdVr8A2ErS
	baZlorwHlA6AdSJL99q0YZHbX0FHb9/TpETciOAN8Gk4OvoBS9lU7Ej6Ql2Citsj1SUDgIbQwzl
	rdE2EImWj81+msgY7eDd/mkYvsWmZwt2ajGGGzujM3Qm88oW3gcgqsTB0a+EVL0Mbt7sFga9BUL
	XEmHCqoLSRKdRSuluKvu14Og==
X-Google-Smtp-Source: AGHT+IEMQa/HknSd4gH88/51zayuXYOJi/tyPDkVuWYFrGs29hqpFzGFB6MpSNARYjZr5mEqvUnwhQ==
X-Received: by 2002:a17:907:1c23:b0:ae6:efe1:5baf with SMTP id a640c23a62f3a-b01d8a75cf5mr969826966b.19.1756759849048;
        Mon, 01 Sep 2025 13:50:49 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:48 -0700 (PDT)
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
Subject: [PATCH v6 11/12] mm: constify assert/test functions in mm.h
Date: Mon,  1 Sep 2025 22:50:20 +0200
Message-ID: <20250901205021.3573313-12-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mkmwyfci167xpu7zd69657pqw5b5r8ux
X-Rspam-User: 
X-Rspamd-Queue-Id: 988A518000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1756759850-178970
X-HE-Meta: U2FsdGVkX1+1S8RiJTPB2gRMF5cjxPCbuoS/FBqRc/1qRAgGhj3A5jr+BCVFNsHZc70J/SRTMU9umlke5r0zhMCmAJpUFbHQoqbsVK7bwaKOIMZBqy6Hi6X++sJinhI1NoSpHhF0w7U6K/QSQFRPEboxpJm/p/Fzpqf7mx1b+2edpdkfKlcXFxIixF7kkn1vjcnKJ1HxE4fDcldM3FDCpSq2j8QT8+K4C5HzZBuMW1lQ5KTO/Inmmla9z6wefnAp6VVaZ80RDnLjeNW0ZV5Mx5QbiEbr81Ea9gvrvvuY5796rhxXEhaoxrO3M7QFWNjv8MKDXK90JOq89NIkbL709NOsz6hpRH5KG4H2ZXruwCnQpYogm7ajIXIth8Yc8NKjqWq/FCNuxzv2hS1uAMEaCXMbjhh3+AyLlBT2V6KP6UwBDAchEtrjcAbe7tDxA+ksA0O8V+epLfat245L6hDyvVSmzgfz+AVr9166SjVrNLmmYU/EpEFyLBcfRj3HHGL4xpbUjxgpcI5gdb6NHZ8OTGBhLq0SuoJqGR31BWpiSwjvfl46G4u8HMjMczWhNisVUCKG00gPLK3a+LuzSvLcZj4TgN/ouT97DNTTTvKVsUl1fnp16GpQYzj3gWGdWM17LrMj0PA/s4jNBdIAagVo0ICKRq5/PVMfY5GwsGwAo6JgTqK03xlRskF4kIKTd3r4Dd007MBhNOseF4y+qWo5g51bK9+4lzPFqisMX+gExONj4Y6fMzwcaoNj6mjtAnw4ES8pZbnYEsQjQRt4uCL6w3mr6Wv+gYNUuB18sP1ftaacJnaYJJUKVrHCPj2oKORLpBHDGNQ+oXV5xWSVi6OsDSUROhdLwLw8j2j9HYwRsOd4tIaZStPvWHH6Mj9ntnMFyarpFnahmqf5PQOmKBQNugGkH0x3fYUaBoOdObviBFh1y/njOG5ZFLuUlW1pxE41oH4ml8+DvZuYjF0WNbb
 n/M7wxI6
 Y2ek83TCdjX790a3CN+xU5yapk2VjoAg1VmV6Hq3EoJyrWXVYp9MK+z+XWEOaru65Fl7+IAXz+6SWdLI9Ltw5BqKWX1txu8vG6JOujgcBXNh+yOdyw7YYvDjFvsOVOcmHBHS2e81F0t7osNAeXEKG8KuViq0fOjyVcoK9DWSILjGVRdnza2cGCflh6M1Uwbo8mPWtmn/PcDc7wEvXihNVp3syIDHb2cvuHTXEkHBb5I3czian+Gh5Y3zG/3K0rQotmnnMfLyJ1j+yzucyobF+2PDUS+QOr8WO74Bcfo2FtKbDGpd8e87J56IUobYcjX35vv3oPsLO1JqLxJMS/xlK90rXc4Uo5sRIWPEeFGZC7Au5lgtxdfzSzJnRVZGe4Hxb9z32ANLeFX+AUgDdLiuXzU03rpki4zDLbi3dqQoWRXzMtOm+iTH4Xnk6KfpcOZtCVoZ1
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
index 23864c3519d6..c3767688771c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -703,7 +703,7 @@ static inline void release_fault_lock(struct vm_fault *vmf)
 		mmap_read_unlock(vmf->vma->vm_mm);
 }
 
-static inline void assert_fault_locked(struct vm_fault *vmf)
+static inline void assert_fault_locked(const struct vm_fault *vmf)
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



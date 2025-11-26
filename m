Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 588D0D1036E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 06:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8C46B000C; Wed, 26 Nov 2025 01:47:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6626E6B000D; Wed, 26 Nov 2025 01:47:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551196B000E; Wed, 26 Nov 2025 01:47:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB196B000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 01:47:41 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C971B13ACBC
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:47:40 +0000 (UTC)
X-FDA: 84151827480.09.A4AEF04
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1BC54C000B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:47:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QOq9nLA+;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764139659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=7U8rygU2N2QLhP4BhHMFoiK2YoN9zuNbKLxrhlWsJ5U=;
	b=w2JlqWlEErkB0uMG044dFl9m1sZwvvaf0b30s6KK8ABJP0wx61TRG8JrVxpT93um3guYW/
	xSn4waHSja632gIuEg+DKoAvoXyTT1AueI8lhAmF4qJOR1suG0NzwYF+KgYObhjmxwUk2b
	VG3pBZGvbjy43gnXbSdVCXVlegxzUe4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QOq9nLA+;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764139659; a=rsa-sha256;
	cv=none;
	b=2YwUaWI8vSsvFaW3Aj0nPVxam+hSIBHSCTT4aCHhZ7AWfpR8RH43twHn4bBLX1MQGnOqRj
	X2tAestls/YQYViYJhRRHkC0i8DbuzlYoZ9ysKUojkvnKhDvFmHAQbHbHRG9H05Co0jUcK
	NN8Ypy0JdzWkX8kfefRiy++7sKhosuo=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64198771a9bso11303847a12.2
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764139657; x=1764744457; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7U8rygU2N2QLhP4BhHMFoiK2YoN9zuNbKLxrhlWsJ5U=;
        b=QOq9nLA+ovyW6qwxFomGATCeUnZKgziR11OvxbxxNX/3SzHVeycBKOn7IfiwZ0tRjG
         fVED2qk6u8sEB32CWqAsnpEuYRsNYXuxTu2grWdWHoOQgWEuTYnTB5aHnts1liM+7lNx
         Gsw9F2ql0b7nVkpSt/0/cuaHKOQu4RtcDkIab9EvrAS4wy7kT3Yk7DXfJhgowr39sw6U
         PkKuUKAWEa/On8ni4qq4ax4PA7KgZBhZ72S8CoudQBCh2l/AC4iDVRiof/NDhKvz1uYL
         pG8qQrgaWYy3bWbfH4LFAnsh3ahNrlwztpBi4Eiyj9ueVBuFXNAUGHbgHa8Rh0Av5Shp
         7Vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764139657; x=1764744457;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7U8rygU2N2QLhP4BhHMFoiK2YoN9zuNbKLxrhlWsJ5U=;
        b=jkTUWOm7jRgoytCJXLeXzyuAM52lRhCuhDEgWEERCDLKeItOk8rtAtZpkRo/A1nIaA
         VPajqhYUnvuBhgGxy/LusuAj1JbKF0Z1vBxYbSGRjT0B2LQyBfIqdbJ8DSZFZ5jObY9J
         ANZRA5vuUplKT1f2Yb4qQCVOlAGlcD0UfZ0KAaNtU72KnlWugkJxpqvzW92HLWEQfMzG
         mBRUAaIYHuzab53+psHHkQ53s1I8u7P2rnz2O8Q1imTsHbmkU6PRiwGsZQV6XoCD0YpE
         6BCKjXIYzidj+l2nh5z8M9TjpuJQFt6egu0kOyUIVekPJbFimJrl0OUVDPXA8I7+akmM
         qiLg==
X-Gm-Message-State: AOJu0YylQw1S7wCde3bW8m07wqhc+GJEZhgGBTjypgcoyRcAjgzb5rwz
	9WPPPiOHhcUKpcui6JiOhIyBia/0+WNspOUgDEw0bLK1/X1iA6FDKjnN
X-Gm-Gg: ASbGncvN15pKq9rOYQTD+HMnh26RC20xddOUm0i2v2Et5r5wcBaV7Xsy3+iITsk9dYa
	/NvMmoUwLLXyy90PtmO+V39R3xHrZtp5kJJyZu+M1+RiqC3Mq5uT2CmXM5qnfO7g2y8g7c4OKRr
	BJk9CIASx4H0AngiB64YBAoT3S48lTL5Yu4Bc54KK+4gY3QdWnIPeaD4ucqZilw2Jx5BV5MF5kx
	I6CbXigjZEjViwgU4OgPoURQ3Lnm1IcX+zS+1aZ/4Oit8dQHp9Au2iHu8oW5LhGlHstYRYF4yok
	DQF9PRM5dxhjYS+Wnr1eEy7oMoB+rjKZTeazFNniZYjcioNHnPAjVBPwxM1x6BKn0liR2u/3JKz
	Og5N1cs2B325V/Lg2hy07GSfn/fNDcbPJSATMrqV7qsjQx7svkXJvlzi6vr7A0pXXuX/qzSB7uP
	PNAetL3kEU9w==
X-Google-Smtp-Source: AGHT+IFzuJH6sgF0TH9NBrQ/7BV/DHjdqRxzF1px4g7cO/05AqHjyQ67SDat3+b7Uhrb0lDLA937+A==
X-Received: by 2002:a17:907:741:b0:b76:3548:b741 with SMTP id a640c23a62f3a-b767153f880mr2020026866b.10.1764139657108;
        Tue, 25 Nov 2025 22:47:37 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654d73430sm1810972966b.24.2025.11.25.22.47.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Nov 2025 22:47:36 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm: use standard page table accessors
Date: Wed, 26 Nov 2025 06:47:23 +0000
Message-Id: <20251126064723.4053-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: 1BC54C000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ck6aoytn8uieampwdrhgxjj733wa8jut
X-HE-Tag: 1764139658-186006
X-HE-Meta: U2FsdGVkX19IU3zltf9OLpFGoNBfns/vfd3hZMOeQuI55DgjdEAEaowC1kYFqqweqcKxHTz/dDxUKYhXtKy/FMKMgW/NkMyvzLOv4TAYYrbY7mZ0g4wVUavwuItZCvXAJWgy6K8gS1Spv9mjdIVbPaSymwTQfTu2v2ljokFrlmQOHqaS4rJ4k/VEGkFqCBTR4YA3cAZVUUnW0hRRuKv4U7Zp0uLqkF+v71aR5N+rURMwW6RKWuyobvRG/lTqEqCWytO8S1M+dnsOvAp8j0DPPlNZkD8VHiNDsorVus12QwTJ8znEw7ZtsciM8ePjqrz1GgPdnFBCaswRkYDGQWRvomfHamXK4UHI0usyu82q8n345pWwwbqbne6SPuYzevfjqQABRfbqLHbACRldQNktbWcS5/Lt0pdJQ83k5RWNowlLTblZK6NgoiGlDMqMLzs+7zgl8DNnJ0iVMCMpCOkqmXEusW1K+FAZLwH/+OL4t94Du0JSUTEIvhd5OWN1D4baWjpUtJq1jAuc8IS3z7VzQEd9xBawI0ScD+yn4d12sEOyafKf4pebcXRzC6cKnSL0T/m6On4ctigmVxOELDJGB4/Na48EgnEYdGtbOB9zMj5BtufCO2K6IL2R6bzWY/kimnVHjv/ilT5VFxE3VIwSVtyoJ4jzkuFVJWlB6PMfpyBQV/4vGDf070K6toVez2IvGARy5Xs3D3K6J5kCrrSisxFeWoFei42MWGTxwSFDTuKlT/seBTrwUqK6ZA5dY+/vzypcDg18kDiubTRf453Rk68BTMNrljLXXI4AAy+6YKvvCSebew9gVb/p823vR8yFf7iZ0infOEAVVdrX1sppPu+WFfCaXkdSuuilrcYRFf+4PnpbSfYGbbLtW8MJ78sXFmElilemnWRLAbwJPepnaV9zkZ13Ppd/bZ0nIqK6DO+GHILHvR03P/grJQX3jTkwvoqVBfESF95BwNrC9lP
 173cdDsb
 T8F31mzTk/wKpsTWl2KUjwJdpFH8t9Fk9KLNmzMXpiukTYkoYYwCoSHMQV7YG0xIN+09lH0xQW8bEmRZjXXwTu20WNWW/VcgpDgMlGFvRM3q7BsCa+HkwfbbVQpRJOYAs8bNBNjunSvJs3DUaJYUzW+Fs6P/phR49UgSPr4RBkRH3qATs/c9eyIL24zsOQB7VjhR1fpCgnFhZFc/BsFl1WPYTDszs6I1XCxcZF//U1h57s7MlqrK7j4bWyM60bZaPuwZLG9owyPJ58QEpE3wTdnFaayxbHAe/3k71mHrnXQ4aOSHKl5wSDRZLhDErRxGxP45UHyOId5u3Ti28v2yCSvsbOp9JrcZ6i2PeNsZAymUZ01s5miF2XPFTcq8FwuH8X+zEqWzGM1OU8NtBrgtaECckG/SyY8KwZ7QaRwy3rRwIX5Kwvr2Mszp9Kb2zj8+LRjiRl0Uz07iasMzEtGZxPtoJSdOyKhMKnXUKJbtoVSuxTwjsZsFQM+fVSx+0MX/XIYDJrWf+BjJf3+j/R7H/j2/GmCPCNFJN/4NK2o5RrWhHqs5sd+2B6pwgIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use standard page table accessors i.e pxdp_get() to get the value of
pxdp.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 include/linux/pgtable.h | 2 +-
 mm/huge_memory.c        | 2 +-
 mm/memory.c             | 8 ++++----
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index b13b6f42be3c..a9efd58658bc 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1810,7 +1810,7 @@ static inline int pud_trans_unstable(pud_t *pud)
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	if (pud_none(pudval) || pud_trans_huge(pudval))
 		return 1;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d2ac331ccad..dd3577e40d16 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1486,7 +1486,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		}
 		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 		ret = 0;
-		if (pmd_none(*vmf->pmd)) {
+		if (pmd_none(pmdp_get(vmf->pmd))) {
 			ret = check_stable_address_space(vma->vm_mm);
 			if (ret) {
 				spin_unlock(vmf->ptl);
diff --git a/mm/memory.c b/mm/memory.c
index 8933069948e5..39839bf0c3f5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6193,7 +6193,7 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 {
 	pte_t entry;
 
-	if (unlikely(pmd_none(*vmf->pmd))) {
+	if (unlikely(pmd_none(pmdp_get(vmf->pmd)))) {
 		/*
 		 * Leave __pte_alloc() until later: because vm_ops->fault may
 		 * want to allocate huge page, and if we expose page table
@@ -6309,13 +6309,13 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	if (!vmf.pud)
 		return VM_FAULT_OOM;
 retry_pud:
-	if (pud_none(*vmf.pud) &&
+	if (pud_none(pudp_get(vmf.pud)) &&
 	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PUD_ORDER)) {
 		ret = create_huge_pud(&vmf);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
-		pud_t orig_pud = *vmf.pud;
+		pud_t orig_pud = pudp_get(vmf.pud);
 
 		barrier();
 		if (pud_trans_huge(orig_pud)) {
@@ -6343,7 +6343,7 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
 	if (pud_trans_unstable(vmf.pud))
 		goto retry_pud;
 
-	if (pmd_none(*vmf.pmd) &&
+	if (pmd_none(pmdp_get(vmf.pmd)) &&
 	    thp_vma_allowable_order(vma, vm_flags, TVA_PAGEFAULT, PMD_ORDER)) {
 		ret = create_huge_pmd(&vmf);
 		if (ret & VM_FAULT_FALLBACK)
-- 
2.34.1



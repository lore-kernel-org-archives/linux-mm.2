Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2786CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D858E0011; Mon,  1 Sep 2025 16:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB14D8E0009; Mon,  1 Sep 2025 16:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79A68E0011; Mon,  1 Sep 2025 16:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A216A8E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6188E13B46B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:50 +0000 (UTC)
X-FDA: 83841875460.09.DA1C9EC
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id A9ECFC000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=fTpk1+3Q;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759848; a=rsa-sha256;
	cv=none;
	b=JElq6ivsqSYS97ZvOQZ8xzJfe1xqQkso9Raxg5f/DDIf7SdsXigoOBe/JF546EEGXz0yTH
	tawO1wMfTWiLYqUj3huysD8aWqZURA5q+PnZ0mfRDnvkPAYJ8qPZZmcaa4yvf0EaX0jDBi
	3g6nzHGwFiU3IgHc1TVQ9bktk8RJZcE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=fTpk1+3Q;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf28.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKRurRT2BneWHgryFTDswdmsEJpe2aYTsThQQXosiss=;
	b=LGgX8skVhJcEgLyTUvRQVuHZ/cn67bdxgkDOnun8VoEsgXnFs9PyqJ4oFKLrGnNr/SE/Ra
	34O3mtfURyz7rmos4m0cNIXRJ8/VmUhWMYOcq6L4HWtFJEIb8MxhEGSN6BLQKk59jlRzYi
	wXvSXgIJnNUxYXmzWXzBs6B1sSeL6Uc=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b04271cfc3eso186757866b.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759847; x=1757364647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zKRurRT2BneWHgryFTDswdmsEJpe2aYTsThQQXosiss=;
        b=fTpk1+3QtmSAuhomSQHHtJsHrwlRDydurvnoKQLKmKmHBGfLRpWmRxDAgM6DnsPSak
         q+aILoNAO2KLY7EH824PkkLKQ3ps611AfhXpJC3ksm/Ln9HVz/cyH3j4tZMZO2Q+3Bhm
         D/3IhM/YhycDeLitRbcbci3pAXbGwOhTTHf9iw7uYd02ULxSy6FPuifHn/rYE4COfXmO
         7qFUbzZmUO3LGMPB6dTjdjS2flsMLLiEctqoC/XHYy1XGdlzwl8rWUrnNiBxXuWFhWJr
         2O5/Pqy6RIwNdFsKrkxhfjb0mRc/thMkonuBe3fgSZdbXFQ21ITxWy8ILfSgSLCqWTfz
         x8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759847; x=1757364647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKRurRT2BneWHgryFTDswdmsEJpe2aYTsThQQXosiss=;
        b=gQLzzTJpMXWjFCssdUnRWzB73hzyyBgJ12Ufm9wCUILx4FmjtkUfsuD1AJumh1Rrrf
         /ovy0NACQjPbP51cXY5jBwzdm/Bj9Lx6LaRIVjpMvZP0ePF/TcDh/cFRHUBOdNPKwCbL
         TWGyJsHF0yFHu+hKuE6ab3mgS8WytdUJCukGihwh7rXFplO08CSeg7uOpVA2ApZUhIXO
         Q7+OO1U3OXU5+6IWHaq+ruIefiwQFd1QgNDzZ2rwLY4x7p1lJs33YogORGA7vtsn4TDW
         FvdZsVKqu0084Nlo2pZjFsQQMrNDJeGjIoUljRVuKcIPn4cBd07710PW4cOizYoZpw6p
         4KUA==
X-Forwarded-Encrypted: i=1; AJvYcCVWcNe6Gj6okmk54A43Ir649mKcGpk+V3wJ6L8RdLIiFbQdfz8PDjWO/v/JzZMtPKSRrlNachwfNg==@kvack.org
X-Gm-Message-State: AOJu0Yz9BARhN1z5ZKaY/DJ5cjTTGpeZ0ypEjgobFS/6TlBCSPu4jDZV
	dkOIqQl2m2OopbHzhRExj1woI5h4nmnIK83M5ARF4u2oxbVk9LwgUC6yjmX+HNHH270=
X-Gm-Gg: ASbGncs3OOQUYa3/dWGxjhsCaI5qL89ZYaTEj2KjK4kOFDZv+ybvDvLM1LBiLRjOy9M
	f/JHowBjjwppwU+LldssXiVDFgocjqhRc8wRZL1MzlArigNEzp5XA8Jaf1/s1WeQp9m72NeoeOy
	7VB7zBvA7FWVRxwUhkuf+a0AgrWfVkaTocB5IgV6pzH6xzeoszkQnumw20NpyaDQ6otXfzKcdEb
	JP+clwG37GGxxsV5XVdkXkALVAhS0XBr0oeuWr4KgT7NCuWrzqFywsjoKVMHbJkAl2l84vWEnF/
	rCnACI+ldQKlQ5uWsU+nwpsYp8ekCJ5ZytG8V22bEb9+F8sjkqOF2hjSxE75Z+bhs3aSVcbc4Q+
	KS3N54G62Dem1krK8LkB3v/AST9z0vmOmIenKo842J5xaWvcjLn2alPxvurdoee7KKfFD/jWe2z
	KpfKeCVBDJSwSxw8tVzCewvQ==
X-Google-Smtp-Source: AGHT+IHCmCpvv2lfwK+DFxb+meLDHCpwG00GZqDzUwq/QLfpGxtMz0YN/b/xauU+UDddCcikhmU4Cw==
X-Received: by 2002:a17:907:c04:b0:adf:f8f4:2001 with SMTP id a640c23a62f3a-b01d9772281mr939362966b.49.1756759847019;
        Mon, 01 Sep 2025 13:50:47 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:46 -0700 (PDT)
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
Subject: [PATCH v6 10/12] mm: constify various inline functions for improved const-correctness
Date: Mon,  1 Sep 2025 22:50:19 +0200
Message-ID: <20250901205021.3573313-11-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A9ECFC000B
X-Stat-Signature: msy6dbepdg518raow1a8jijrwggazdap
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756759848-203226
X-HE-Meta: U2FsdGVkX183DOxHRA/MIQc9fgGEfuHjdBuXD7Gpwx5ttmuu0ljU0ZoM3gg5nnD0260JByWEdiNWb5BiPl7bR1iYulwZ+5DLANBFXYabOwcCfVWnGA1WCB6i36gB1uTFwB8V958h2qEP9PfEf0s+wuwAQrSSdKkhHQYouZjwuWQRyYBxOqNSSlYKG3e0B5fVe50CqPDh0xNDKeLixjUdmxMw7ZC//fgcP7Gy9CcJNtWEvsrNX1TemL51Y2Jo3OwtPh2OR+YdaQ5frGsjebRscXpt4dOX8Nkfqk2hrv3tZC73Fnw6ssKbTR6NZU/iOjmvnjf0h6Oq+t+XAZ9EDH+h4XQWz/Q75XkHHJpXXAAuqbFK9SfOhCLWR6uqeCazP5iC//ohIKb2b+Gsts18WLD54cOE0GzqVcR8nqi6I4U4na2vPNOT3EsyQdJFIaF8XyrDdgCh9VEeufM8gyUJrLI+J2z2/q1dbWU7Xl1wFTUBnDAK/wFdidtAiGaBS70dPV8MDzy8u9II5yvQUndUYSHnCfHh0naYyJqsuXrDjYLnfTHbAmqUQXQ3B5lI8cYbk+jRYVuhlTrkPSgNGAM+DLTECZ3dbsgxmNmz+1dlHRR9iFQAMLXBH7RwODVuupj/zCiMP71Q+fi4eIDOWAvftzTWJbpuWY6rlmAHhUkYkg4cgk480VG4g2G118MpBAR3X4ZiCnKwuv6FgCOd6hQIl2wFVv2Hs9b5QULjpv0rEEwTqh1sPVbk33PEPtr81JXAXrG6M3t5l7+h/BMcTOoRZRT3NbJ43CbfZHt4MXrGBeQureT5w8XlZwKApfxpAGZ2/hqKmwjmUBMiqWkXuVBCYo86EnT83cYtbWxS9306IE436tSJMmcc+PlGjFAxM+Ia4gkArxcAu86UEi/BdEKUO4llHTA/3P1lu4cj9LFt1K9raQ5Rcf/wsYvWMcCbU6a8Jl0koiJh4S/VlZm6cqH5cZl
 UbtTUnX5
 OF6ckrpQwYTEhp8QjXJfBpecK69a9wr03/1mP7bIOpSFO02rYiHWX0+moR+I42KyZzhHvm35MycHjadv1RRbuJfjC3qta4MNLM484z3jxyLf+q9QxBFDkGzquyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We select certain test functions plus folio_migrate_refs() from
mm_inline.h which either invoke each other, functions that are already
const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

One exception is the function folio_migrate_refs() which does write to
the "new" folio pointer; there, only the "old" folio pointer is being
constified; only its "flags" field is read, but nothing written.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm_inline.h | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 150302b4a905..d6c1011b38f2 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -25,7 +25,7 @@
  * 0 if @folio is a normal anonymous folio, a tmpfs folio or otherwise
  * ram or swap backed folio.
  */
-static inline int folio_is_file_lru(struct folio *folio)
+static inline int folio_is_file_lru(const struct folio *folio)
 {
 	return !folio_test_swapbacked(folio);
 }
@@ -84,7 +84,7 @@ static __always_inline void __folio_clear_lru_flags(struct folio *folio)
  * Return: The LRU list a folio should be on, as an index
  * into the array of LRU lists.
  */
-static __always_inline enum lru_list folio_lru_list(struct folio *folio)
+static __always_inline enum lru_list folio_lru_list(const struct folio *folio)
 {
 	enum lru_list lru;
 
@@ -141,7 +141,7 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
 	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
 }
 
-static inline int folio_lru_refs(struct folio *folio)
+static inline int folio_lru_refs(const struct folio *folio)
 {
 	unsigned long flags = READ_ONCE(folio->flags.f);
 
@@ -154,14 +154,14 @@ static inline int folio_lru_refs(struct folio *folio)
 	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
 }
 
-static inline int folio_lru_gen(struct folio *folio)
+static inline int folio_lru_gen(const struct folio *folio)
 {
 	unsigned long flags = READ_ONCE(folio->flags.f);
 
 	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 }
 
-static inline bool lru_gen_is_active(struct lruvec *lruvec, int gen)
+static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
 {
 	unsigned long max_seq = lruvec->lrugen.max_seq;
 
@@ -217,12 +217,13 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lru_gen_is_active(lruvec, new_gen));
 }
 
-static inline unsigned long lru_gen_folio_seq(struct lruvec *lruvec, struct folio *folio,
+static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
+					      const struct folio *folio,
 					      bool reclaiming)
 {
 	int gen;
 	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	/*
 	 * +-----------------------------------+-----------------------------------+
@@ -302,7 +303,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
 	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
 
@@ -330,7 +331,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
-static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
 
 }
@@ -508,7 +509,7 @@ static inline void dec_tlb_flush_pending(struct mm_struct *mm)
 	atomic_dec(&mm->tlb_flush_pending);
 }
 
-static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+static inline bool mm_tlb_flush_pending(const struct mm_struct *mm)
 {
 	/*
 	 * Must be called after having acquired the PTL; orders against that
@@ -521,7 +522,7 @@ static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 	return atomic_read(&mm->tlb_flush_pending);
 }
 
-static inline bool mm_tlb_flush_nested(struct mm_struct *mm)
+static inline bool mm_tlb_flush_nested(const struct mm_struct *mm)
 {
 	/*
 	 * Similar to mm_tlb_flush_pending(), we must have acquired the PTL
@@ -605,7 +606,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
-static inline bool vma_has_recency(struct vm_area_struct *vma)
+static inline bool vma_has_recency(const struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
 		return false;
-- 
2.47.2



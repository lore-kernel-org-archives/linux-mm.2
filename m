Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8A2BCA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ADF46B002D; Fri, 29 Aug 2025 14:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038396B002E; Fri, 29 Aug 2025 14:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41B36B002F; Fri, 29 Aug 2025 14:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CDE246B002D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FA47118400
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:19 +0000 (UTC)
X-FDA: 83830639998.21.1FE616E
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 98D84140011
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=e1pouE0O;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0olIYmWE+/dr5Hm5adY9R1HGCCQ1xC2gIdwvYkk/po=;
	b=At7+tLDUtxz5KNq4piGdC3fZk7stD7fgwNyynrqNn//Q62h63ia+NFV92y09VCy0LmRTii
	2ei0DBPCp2ypqkVD16cbsh6mS4HuUBkZJCcXyds/d/MhHIa3I9e8Zt2TsE+YZk4P/v4BXn
	0evRkuunhobo7Qd0051HR6MQN3uHvm0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=e1pouE0O;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492337; a=rsa-sha256;
	cv=none;
	b=kB3lCcHxiemUoZmzxJx6S7U+WrgxnL31zeaEQPsDwnpww9MMlWGzGVWfLZnPvf5T+YTFuc
	ULYiXx6fqA+zEb+pZKFpjVJ6UX5gvz9kaB/w6nb78vxpEcuFhJbrhIdqs+0JQjyvTRnn5G
	D7StZdNmcX4Kx2XLQKqAMEe7eVvuM/k=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb7a3b3a9so373562066b.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492336; x=1757097136; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0olIYmWE+/dr5Hm5adY9R1HGCCQ1xC2gIdwvYkk/po=;
        b=e1pouE0OKUuIpxP9Kr/AA+22KtaubrTNdcUaXxNJqS95FSMmH77cwTWrMTxguwJYg3
         0UcnOQNFLw1u2S4T+KQoh6BRWPYh8PFhIbR/sjtx56P1TKKQrFm86FpGcxt3v4H+U/dZ
         QgMUrqE7EPbfb2Jwa5vWK5TmUk7TYsF3Rc4M98FSppZY1yAFLrSCjELd/aav0GJwhSyY
         0SjSCYOKbqA+wt9Hqr126qxOh5rpye7ayK7Pj3G9hKyvEp+JDT+ZyK8u7d5i5C1vWv66
         UEkl3LgCi7jZNWo99Pd9jEEUXZDYwsaLB7upgANm+LmlYGLUITMLeQhQO0/Fv7QWqS4G
         sltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492336; x=1757097136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e0olIYmWE+/dr5Hm5adY9R1HGCCQ1xC2gIdwvYkk/po=;
        b=Y838pF9msE1Zk/LgfLSWqpkbvVyP/tBCWNSLjQqjxLo4L8JowjJYAAsyX5uggxlejz
         gAIfyvl5ShiwlpYx4bxyulab5C6nrIFYeKQSy8H5KR92gA6Z9w63U9byqreb4wDEIAhH
         yrcqSwpSC32CqeMEdA1XR29AMRkG9uxiOaWq/ZVqDSAYOf5l7E7bjlvuo2qZ/Gd5CV+N
         kQbx499qmOmbm2/vySKARxPJBQyNcoosNpVISbO/Lrmuvz1LZViOXczlYSnSFY0MimrY
         WTPsi3blzMFp9XJyigrqNqOyv0e3rkwWT6GtKNu7qmtNLpJ+GzWLlsc5XjnSey0+hQlu
         zTLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMYGm7KM4Dk42YUguzWqta8YEWCbI7Nu+0kaC9n3vcoTXp16upgsayZiA+RjWYkJr71KIv4Do6wg==@kvack.org
X-Gm-Message-State: AOJu0YxLf8InLA3xV5rsLNygmnGnryXEr2eRmEK3hsvCk7zvrylnkL1N
	QZ1yP0t42ELjAw/cqX/6Gohf/g5vCE7GjBlYkM83A4j4mV4fV4f7uFtYwc5ZHFLqzO8=
X-Gm-Gg: ASbGncuAG6vBigSAFlTxHkqS8x8nzrA35BaCO3KKXWDNYehrjZws313tOux4ZKl5DCZ
	R5V/r1yLiwKE7yfXxfVbQChfRbwHsZJg5saCKBDyuECEtonGRnTYRyLwWUI6k1K1oxQtxakTJCS
	ufFgbtAtsDq23GUHI9oxNLL6UdGLAAcKYmkox3T8gX9I4dIwVMy0Y4c9B68vnufVwI36aSdAF+f
	bOOkblRgNa/zXjUJeKCmofx4FjEUG6pHfWw9nhY/nB8iFTfR/DEt5MrhqSxcs/YzzGiyAMraN8T
	imEfnV9wUqvANuH87UNIU4pSdzEyURnd3QuJ6KUdSGiLVMvBWqw0DHacYYfcL2NGu5DynY4Kges
	eXqknnDdioccDJRV1EJlNaAJTDx/1I0wJs7XF3nFhUExUvuPU5fUqW+7AVr3KsxdDuJBvujkfNO
	DAsVVcRAAjY+63VR59R9Pk0Mi6dVid3D5b
X-Google-Smtp-Source: AGHT+IG+akp2S6/jmEqkov0WGAZfNqim0Qj1piYjiMIZdZrxJ9Nq62SrMoJjcQmw810z5k2DCtP7Kg==
X-Received: by 2002:a17:907:980b:b0:afe:e9ca:8ec0 with SMTP id a640c23a62f3a-afee9ca97b3mr620810866b.47.1756492336083;
        Fri, 29 Aug 2025 11:32:16 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:15 -0700 (PDT)
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
Subject: [PATCH 10/12] include/mm_inline.h: add `const` to lots of pointer parameters
Date: Fri, 29 Aug 2025 20:31:57 +0200
Message-ID: <20250829183159.2223948-11-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pg7u85zciutycn1sy6zsfyb34ymyn9jr
X-Rspam-User: 
X-Rspamd-Queue-Id: 98D84140011
X-Rspamd-Server: rspam01
X-HE-Tag: 1756492337-36469
X-HE-Meta: U2FsdGVkX1/P8+7OflkEvGulNUBp/hwVcU5HjR6FBr2qFZdjambS1Ene/kS1ktBW/XL1024Wg3KkM+ZR+FPWASJIRwmvJJZUJHdK28BiOGccS0bSXhZv+p6ugCSB7kKi8mS9JGlPAnhOd9E5S0oP9oySjpyoBu8Cka7UOn/at/LfNvuYzFfbNPuk3LDftrRsMRd3I6Xsxe0Up3joqKBUKsGSN2S3fDVSrBTUMc1hSekqN7DPy3pvVXaweW3xFNEXtjhZavnonD4MRxJlZCGoQA9mMcnOEC/zceJxevvqrAyZJGvQFE+wV6ozRS98gQT4LSuc5Ea25YKkHtivDw4E0wzbzmH1ya2VzUFJIjH/gXns5OBdgE3Fat5xrn6LDRZutl0RGchN3TbV08cgz15BzFY3PzKGberBuFOq2X8AamF3LJzfGn4+3s+YyDY0f6VW8bTbNq+mWwJfXY6ByJaendCAzTNbMTtlmgZCD7UJG0zFCHXKWZp0FTt8ieHyF7Ms9ZsNSX30fCoWmKjJ/1rOGOEu+cuVfwkMncaW8VU9jltlO0QNKQadmoRAh9QIXCy9eBRO1qe/HxVgF4YYqVsl84XWA3kaLRP0sd81uhqBunwug5tdRpM3LZTJ++rW/uEgZYO5LTMemPAlQtoUbkahaWXBB6FbnN9MxZZP0vDyKlgKBAGrGhaGrSXaD3Ef7tPx9+vJUi87no9F+fNHrFHrFYwlNXUZWy3+lOblGEZHBzioK0dXD/9fxfxTV8f48wGdioGdLdLDtsb1/SUCq+kEqK8ycsGBbPjQSErfca8QdqVQlvGquXkW72zDwhrEAAxxoU1knFTQRD5s8H4113u/St436AJnnXqjNL0vAjPG5pXo0wobky4yXDXETSU6Ah7usXBtc9eRZBPWfQvWPgIDmktcqjIoyoczctC8OI2zSSQkGv7+h+jsh/iz3Iwvqsy8vCEkJ2lBwNlzRKI3otp
 Dx2W1hY/
 /2smmQtbkEiYz6998argnQDbS25OcXZ9ge54caq+70zZ+5Fz+Ti+mhTYZrPXAWOv19UNG/NgZCMt5eRh03hkE+L9k4zEeV7FV6IGqP1d+oQEOskfcBs1o2G0yJtBUR8SXpePRUNCbVnd5BvlBZ01NQxlB34WgpTqPNlKr+SrYDV9axbIIhoWRIhC4GFG6OEKGki5XiizjpMDjhwMA3A5ykSV1cCN52b8d5IVT/z+IlvC5e+McOLc5QpKHBDJckFILt47Oo3CwriOLRnjK8mA8bfUGD1baua9qLpifBwA5B+XNwJX57ufD7JvIcv/WM0+KPmdfyq0PuNHaq8Wi7VP9XEpFzHgo7vV3+5dnFHwCUHOwlQw4D7CQ0cG0my656diCxJn/eZ0KzKjOe+NDVt9mTyZWNY+yQRe4FotT
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



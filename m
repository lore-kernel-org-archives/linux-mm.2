Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06F00CA1005
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B188E0047; Mon,  1 Sep 2025 08:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E37F8E0013; Mon,  1 Sep 2025 08:30:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236BF8E0047; Mon,  1 Sep 2025 08:30:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08B7B8E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFC0A1DEDA1
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:57 +0000 (UTC)
X-FDA: 83840615754.05.E74738B
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id E38771C0014
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=BhlRDeMV;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729856; a=rsa-sha256;
	cv=none;
	b=NIOEe7xzkvbERyXDEi+VusAK69XItfHIQTaaGimtSh0xcp0olw14jlKMoWege8ln9riGcw
	wSj3ssS6lBUKeo1kqIGlK7s4uUIt4/ir4P0mYzdc6Ur+brpvnMH5CRiybVQikP3rU5SDEC
	45ZXmSw5YNuw37/8XweB6W8iCZDDl78=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=BhlRDeMV;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf21.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=719Ia0lSRQecbD5eusFA1tVcXf6dgvDvzBCqCYcJwqw=;
	b=njcb93U6e5xtj0LS8CVT5p4uQRjc2y6JxkHHbFQKSsvSsR9JBjKI7zLL10WOOD/10A/ePO
	OsUOwqZbuPf642xQ2cNM7GaVs7uHkinmxq18YL8rboFfvnUVTEG8gL2j6z55cWmDYzsY5d
	2vToZL8eq6Kcw+4KJHLC4d2bu3q8ZJA=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61a8c134609so5461767a12.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729854; x=1757334654; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=719Ia0lSRQecbD5eusFA1tVcXf6dgvDvzBCqCYcJwqw=;
        b=BhlRDeMVBFHN0X1mEnzfqIgcOymUFgFX6s+8uMFcDJkUK2fctKUo5eDi5yXF80OSnE
         QNw+ltqdqDMwlhFC6EZP7h6uVcVFg3q4YQ1qkWxTqK76LT8blVO/S6H8OcfuL2h/0Afn
         bd4QP0ACV/ZRrrFBmecUeaWZt37dX6aHkLg5qjC17dMC1NakkGlRoEH8DgC5KaFzdwqv
         GaYVwCynU0nOfSaw167a2h5IyT7iAQhbQWcABky8oCmK0js7LJNKh0HcRek/rwhlufrf
         o0vJ4zkx8z0Ag60+QNd4w0bEtFnUQP60KDHs4ZYWNaW8sQi86M68hxtM3M7hw2GgmMrb
         nzBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729854; x=1757334654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=719Ia0lSRQecbD5eusFA1tVcXf6dgvDvzBCqCYcJwqw=;
        b=ESIw3Ef2mGT3rpGHLoAgmUdVQvXBJunk9Rr5Oa+DWzstuVIbauvnFLVxlainXrMbt/
         j35rADY01zZBjbc7MkCXVGu0umc4vq6Ew7RRGAKwKEs4GFuKGEqijWJEGna/rGI+UFSb
         gozyPhXwkI7yHdhxNKUuIcW7EYe+t+4dz9763dszRjy3DBOkVNREaVxQjrARk1VK+ur9
         90Lk86urx3e0hGrnlYBsdX0EkHkIPdziTyziP29U7iDPS1y1WOGX3QeaRE6Cd0dCrl+5
         A7TRTNIRcSJfLhteoTjw6ZRIE34AulWgb1AWOBt1tf3vx93kVT1unTJbql/4HQir/UhJ
         tDqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRK5aKHoJ7mjhDvwctc9K4WK68cbU+nZDwoZ4hslCoZrSQWsXoF/MHUcZcJ9TeFzNb9LjlLc+Sgg==@kvack.org
X-Gm-Message-State: AOJu0YyFNyxbQ+opCkCWgyHZ6kunamDL+H0oBJDPv0e31Y9eF+mkeqrB
	1Ql1Q2S6+D+HZIoDVpBYlog8JPgwc0dywezMaPNsB3/9b2/5yTkrYwkGqAogze1n4b0=
X-Gm-Gg: ASbGncsdrdRaEo36KdziXGpWLHwyq7GRA5/tWA3BY1YkxcJW4uzTS93DeBZb612nifu
	+TCEmOpeLS2KIQP5pLdvyWqDirLEOQlVP+OLmqZ6t+klKBHJ0CwJalvlRrbFGk2HS77qT4eWZ7+
	kHPACAehZUDkDG+8DsOCEsBEpkYqRzJkRMpqGwAVuyCXgbZHTiRJZWuwatAEbhvce0JHM0eQ5bw
	ofvGjP7I57njspP18mQPNpdF1trnCoDv5RaG2H/qAxn+nN4F1N2eVYW4YIv25jGWGuzcqQ+2p5t
	/UJUZfapdjwr34zC7Yuzdl62X4UtvKSMC86V2s8xWRpnS+XM0xIiE7Ih2wD5J4FFSJnj/Bbx6GT
	Nmhr3qAS/HCBzoQj8PwohjbvEgBevebeIkpxwykR+qk3/h+pTSX7RLjrPcZtJhboFYYm2H5/IqO
	vnsIWUq46X36mWvT369BOeAlDbemyLCOSLc0rOu43omhY=
X-Google-Smtp-Source: AGHT+IFXpOqRLV7jtUuVW63S0urvzzT2Ybqzsy1IuQBF5NxQ7SlgahydrdjD1p/lIEKi/iaMHlbMCA==
X-Received: by 2002:a05:6402:3510:b0:61c:5cac:2961 with SMTP id 4fb4d7f45d1cf-61d2699455emr6335145a12.14.1756729854314;
        Mon, 01 Sep 2025 05:30:54 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:54 -0700 (PDT)
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
Subject: [PATCH v5 10/12] mm: constify various inline test functions for improved const-correctness
Date: Mon,  1 Sep 2025 14:30:26 +0200
Message-ID: <20250901123028.3383461-11-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E38771C0014
X-Stat-Signature: ayb8xkojssebbgktkiswwk4i3h1ir97m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756729855-255885
X-HE-Meta: U2FsdGVkX18WnY05LOfPa/X26GWhbYtx7JuI64ZDKDlyrXp6RBWRVvF7PeJeyDQ1zHqLVFgUOtpJrNL942HRhk3lEMkHrH79kpoyJ1Gm4WHaXiwbBcOMeAB5W60v9VETIxslg6pL8K89y/NDWBQZbLbjYcsjqS1uOjp50H07IV+L8vnOdQLZSzP8ihrnxlHBjYj0qy0M/A+r4p9qobRc8s7xW7AnsHAhUoLriUYu2zdcfCM1N7vXlUu2zPodJxyq12hNL6NVizDAT7uV1XYTPDsI7P/4nHPfr7kVm0QxZsSadKJ84NnL3XaKmrvqeWgDWV/spCPa62gR9g3qoicV5/PVnOxKIuwE7R1tFC8+Tbcp2wLXn13qodmi/UxobZ70MOk9pVU89EbbvKwsTeGqT0aE1pK06FJP5cTmBFzmbzpKJGDE7GqxlSU159UkJaEb0dZr/rPOiUS8ujYFvHuD66ZvT02G3hHuMR7rX/+4k6LrLi5VqEiev6lAbw16YHp+/mTzR3u1UrJUVGq1ZlM4wkntP/tl3vJZRoL9BzqhgTSuiL0QFmGIT5o5KlLhUPetLGkCLuH36LCgTkWuxUGLbjdreg7fyqHsdfGdprX6+D2ThLssym90NxybGTkc8IwjXtmL33u9Q5C8iIm0pa7RjATkV2MnHXk9MmRn2Djiy30lIntNwzlFvrFz7n++JZtbN1DahxSSsRH5N5UvItLftoRPKnfKpZesqvBg+OPf8bNFKLZneJhtXpROA4C6YRpV6N8gUnZwh8Lbo3+no1SBhNir7H1cLe5/1rd1+3StrTjz3s0+m1aRjOeN+5b4bI/S14C/xvg83iAM8mOUZ+JRAdCr0P1AfCHl2v2x1iu5Gmwp/Ibc7HBWQ1ola+yJEQid0Ec6Jaus53BFSeEASgyXc8AAG3o+0efECuARRLtIVAlFrqR+BWcUBfkOmSgwqwPFz9PAiU59x6SYbncH6sZ
 qyAHjpTY
 9PmNbLt82GjeT2oebcNjaUuB7oO+Efe/3MyXiZqct8BvPQ9Wj4ZhAF0IE5892lawLGAv2OglmtSTNA7mOEqsqEDG1NyD47LBvoECZVmr0CRq4TygOxM2WKnne3iMeuUZHhDIwX5WMjvR/KJ4Y9vTe1O4fMcknldP5PsY+rIBNxs/LaTz2URXR4jxQu9VgVQeJlFmNMCzIZOCV1vnEfEM9SSnFMf+3ZHZ5OEry1T2xmcm1dyQ2ev78NjIpwD/4cN3Xmk7idnAYX4ScRQXY8uKch6/sfTOzrElA1pzPvsmkrgysTw/PiVWwBVq4aL3NN+6v0hX9q0BA6wC21ehWKQBawHs8kKET/GkfmNM2CUvtxPq5R67So4AM4DCdvSYwphqFdn3y5bhoiPW3D8hUWUckTDCRmoQFdnORltFmfU0m5NM6DhHyUFm0SOivcYL81uDrtLH/miMV7gsj2GA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We select certain test functions from mm_inline.h which either invoke
each other, functions that are already const-ified, or no further
functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

One exception is the function folio_migrate_refs() which does write to
the "new" folio pointer; there, only the "old" folio pointer is being
constified; only its "flags" field is read, but nothing written.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm_inline.h | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 150302b4a905..8c4f6f95ba9f 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -25,7 +25,7 @@
  * 0 if @folio is a normal anonymous folio, a tmpfs folio or otherwise
  * ram or swap backed folio.
  */
-static inline int folio_is_file_lru(struct folio *folio)
+static inline int folio_is_file_lru(const struct folio *const folio)
 {
 	return !folio_test_swapbacked(folio);
 }
@@ -84,7 +84,7 @@ static __always_inline void __folio_clear_lru_flags(struct folio *folio)
  * Return: The LRU list a folio should be on, as an index
  * into the array of LRU lists.
  */
-static __always_inline enum lru_list folio_lru_list(struct folio *folio)
+static __always_inline enum lru_list folio_lru_list(const struct folio *const folio)
 {
 	enum lru_list lru;
 
@@ -141,7 +141,7 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
 	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
 }
 
-static inline int folio_lru_refs(struct folio *folio)
+static inline int folio_lru_refs(const struct folio *const folio)
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
+static inline bool lru_gen_is_active(const struct lruvec *const lruvec, const int gen)
 {
 	unsigned long max_seq = lruvec->lrugen.max_seq;
 
@@ -217,12 +217,13 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lru_gen_is_active(lruvec, new_gen));
 }
 
-static inline unsigned long lru_gen_folio_seq(struct lruvec *lruvec, struct folio *folio,
+static inline unsigned long lru_gen_folio_seq(const struct lruvec *const lruvec,
+					      const struct folio *const folio,
 					      bool reclaiming)
 {
 	int gen;
 	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	/*
 	 * +-----------------------------------+-----------------------------------+
@@ -302,7 +303,8 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+static inline void folio_migrate_refs(struct folio *const new,
+				      const struct folio *const old)
 {
 	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
 
@@ -330,7 +332,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
-static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
 
 }
@@ -508,7 +510,7 @@ static inline void dec_tlb_flush_pending(struct mm_struct *mm)
 	atomic_dec(&mm->tlb_flush_pending);
 }
 
-static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+static inline bool mm_tlb_flush_pending(const struct mm_struct *const mm)
 {
 	/*
 	 * Must be called after having acquired the PTL; orders against that
@@ -521,7 +523,7 @@ static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 	return atomic_read(&mm->tlb_flush_pending);
 }
 
-static inline bool mm_tlb_flush_nested(struct mm_struct *mm)
+static inline bool mm_tlb_flush_nested(const struct mm_struct *const mm)
 {
 	/*
 	 * Similar to mm_tlb_flush_pending(), we must have acquired the PTL
@@ -605,7 +607,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
-static inline bool vma_has_recency(struct vm_area_struct *vma)
+static inline bool vma_has_recency(const struct vm_area_struct *const vma)
 {
 	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
 		return false;
-- 
2.47.2



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A76CB1099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7DC6B00C7; Fri, 20 Mar 2026 14:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003A56B00CA; Fri, 20 Mar 2026 14:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE55B6B00CD; Fri, 20 Mar 2026 14:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAC1E6B00C7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 809F758428
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:48 +0000 (UTC)
X-FDA: 84567264936.05.6B6BD0E
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9944D100002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DFSlg9o1;
	spf=pass (imf14.hostedemail.com: domain of 3sJC9aQgKCB0C35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3sJC9aQgKCB0C35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cM20szgm4biveuFYrOn51hJOnijwUTgLJlj/dU7J5NQ=;
	b=U6h34xMWGx7Sk2wGlQYt8BF620tZ/bZMJp4JpU0qm4zCqKfQsYSOt/g6M3TmOW2aRA9WIl
	QM2DmZkpp4ntmFSB11n8SOG9r+o2vk5utK1rAJ+vSiFevf+7eYC/l2ltw0OxYvorEi1xA/
	oS2cFB1eNCKlk0x86qEK67mtk9tFUOc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DFSlg9o1;
	spf=pass (imf14.hostedemail.com: domain of 3sJC9aQgKCB0C35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3sJC9aQgKCB0C35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031026; a=rsa-sha256;
	cv=none;
	b=LDxNkeDc9UN4TJ+aeW3CIy6J4LSXhfNbi325LjrfejGv43tkWc64DwSAGzlKOI5BUQrKEy
	1paiNGIaHsq3kzdZfZoowIJVLEuZIWGIou64HeZCaudFFSwVHQ8F8JQPD+0fX3UTcYrmG/
	gx37orMQJrrxwn7+G/b9tKRWZWeLKuI=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so6326205e9.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031025; x=1774635825; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cM20szgm4biveuFYrOn51hJOnijwUTgLJlj/dU7J5NQ=;
        b=DFSlg9o1zSGdVQe83yPJFPqubrKnZyjG4Da0IKREybTjWBuHx3meLYPN8vUukpGsZH
         ehkRkeoMdS85f8SKDlajsr2id+qh+QaT2lkA4Glwn3zLXRjkKHGLTDjR38XY8/bz+edm
         ltpHqIS79LZcqHju4644RV0dP1w84eejiWy3ZrQVH5MUbdPcdqod3Cm7mNSi69IREzYZ
         Axij+nD7BjI0mMuQYvClxz4D7kj7nJPQS8Z+HP/rIXk8KJMJNUVUIj3diut1gKu6xl3q
         ahGnZLj9n0k0RV3Aq8HcLbXjfTokQ18oYZ8Zr96na9k9vaVm5UVsUAHR6rIoIzxQiJ09
         hy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031025; x=1774635825;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cM20szgm4biveuFYrOn51hJOnijwUTgLJlj/dU7J5NQ=;
        b=j4NM2yl2vvf4++M+azjTatnsgacc5MDuj1htu6JcmHAcThfI/MiJe8h0tOwlmpJSu4
         JD8aqhvpIIVBHEIad9DtREmhQ75DpfrA856ewYW1RZVpBSgXA+hil1GVZOe+SjD9FCC/
         54l2BxDOw9R8/DLgwYuG3dHRWzo2gx9vMKSxeeSJi3e6JiyAc20zrOlSPBXJ255TrNhD
         WmjC42kVEjLccUgr55DzibCq3mVVsjY2VnooOpkuu3So63+8MGgCIGzFtMV6Y1K623K+
         544HXQ5Eo2JhMtEkJn922OXKZ7eFKe2GGlYUkN+3kLe656wjZdpVrKcSGKHdmugH40P6
         Cilg==
X-Gm-Message-State: AOJu0YwMlmJFyaO7gKe97GZ0pwCGqnroNVYjsO+KB6/RRl3JxsMsvEp/
	lmML+jXjtpJO6PBPwPgV2nZjEI1Cx8IQxLyYgNPfV1BRVmpoUIZI+LuPao/udFUOurmF2OREOwA
	Zp5LFQawMVYuqBQ==
X-Received: from wmla9.prod.google.com ([2002:a05:600d:2389:b0:483:2ce9:2b05])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c167:b0:486:fc94:d8f2 with SMTP id 5b1f17b1804b1-486fedbc066mr61577695e9.14.1774031024700;
 Fri, 20 Mar 2026 11:23:44 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:29 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-5-28bf1bd54f41@google.com>
Subject: [PATCH v2 05/22] mm: Add more flags for __apply_to_page_range()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 9944D100002
X-Stat-Signature: d77c1e8o3ohe7xju1s73hecu9ygxwgi5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774031026-736864
X-HE-Meta: U2FsdGVkX1+cLHtwUzQp1ZUJKtegcP8sh7TrrAD09dkEX2TqtShrCQ4HE6TV0cwSegl4D/9BaterGJiD1pzS+1zV+6I9XD0s7vT6mNx2um9fKedBtjHsbokPfJPQaqnfYiPh8tKgFDFfHYXr4+ykrBqwkEkuBw5dsN6rnGL4XrGOnvwUZUx/50cgZYfnqUWuru016v7aBGGrhAIbgZ7MlyzLZjd+Uut9rXOSHV4qVPlldBlAVtRjRA6+74Ls4yOpmkWM42Po0GRmeu95uub3zI9gPB+AH2Pw9d0LWyaveVVwpCPFSzstpTgVqFg1QYZ3yEEpGzH0mOnGbC2017EuYZfXa4aFld0+oGEM+ozDUc+RJ3M4VX48pnTWRtSV0QgiycCH9N0FUlYMxSpliXUKFevuGo6LQbwwPc5IQlmJCkxHBCO8wAKmhvY62H6ItdEnp1+BamIqvsZphX9QJUbDO4n4ymRZNkfd4VOq5kOHta7ES2X3i2Ec8przwn1Gv4CwkmanlY/8US86fRj9tb9vyrrRoHugkRZoe+bwN4a0b8MuFqr/53rXnovDuI8guHtDTMvHEHSgnuFMb4C4sZ+ajKvRmq4FGT3N5JtQRsih/koA7+qbK4tVdevyntGSnefqJIbIElPmbwP3OaK2kRzU2L2NTtgEyRW3BOnRX/4I+uQwvjEDnPOA5yR9grI9l0cL20HPaRbz30wTNoL2lnDGDhqusOX4OeRZJrkkFKlWEXcOTGcMfOSDI5QxZYoFtLS5hpHTdFkLvC0Juw1TnHrRaJX8AjaiCliEUI+d2L7mUaaExbR1Oo4VbEIj24GmO8ICDymvCR22zoAuztteACIWmfdRt30+kWtQM8IRD/IUNmJFo3j07inF58m5VGMPLraZuuZAtbSdsOky+mJQiEQg21rfhWsxi1P9T5FmYT0qQ8LtObtAmTawSALxYr4Tjya9qxzvAzq6U9UdoFqjTGB
 CCNMlafc
 E1etF4Uv8mzBluThoA2M6gOZjZ6j1dqVG7YTN1AHpLmx/SDpaFCQgVL3pZR+x4iJk9wd1DoRKPofTH3j6JV3tcILquaRNe+ZNP/VWNqABX5SDug8s8jio0+VDFp9jtDfgLZuLEGnbfSmEtelkhxycgYSwmbvGZlORh40w4KgE4wP6s+IRNwP8eIn2YhRc47txg/CnRuiIeLE9Ds7C1i1o+fqiJAyfRrQ4JmmgWmJYJXcu0Tz4HNvwBNV8NVgmezI9TH7JaNGTJmwRJeH6RoM3s/gYEgqQGol0QWu4eRZ3zFv81c666GCccyBUjMBbVipDO47tYi3xyAJYbGplKlvUNrah7mnDlqzDzUkwHOhNCKVMhPXOUTTU30UpE14IHT2tZ94Pq2zaq09jgHIShCizwTNQEQeQXfu7iL9eJQto4PreTuWryftOWwvV/MqUAc6Jv2nPVajR2U0AeLqJuHQ2xfPErIeoxHlqkLm+Do8XAUjNpNtVJSaMNzCm4xbO/LntM366SeLpQuO7e6Qv6VrkmY2NMaZT0k6KZMfJlau9oVV2DW+3WF0ek6pxYbGypITtU1D0mOOtzbmsVcd0KZLITHY1hjcwPzjF6tfmDk7PIkS2oi5QF0o1NfC7sxxoZEs3gBg/d2n32nUc4XQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two flags to make this API more generic:

1. Separate "create" into two levels - one to allow creating new
   mappings without allocating pagetables, and one for the current
   behaviour that allows both of these.

2. Create a new flag to report that the caller has taken care of
   synchronization and no locks are required.

Both of these will serve to allow calling this API from restricted
contexts where allocation and pagetable locking are not possible.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h | 19 ++++++++++++++++++-
 mm/memory.c   | 59 ++++++++++++++++++++++++++++++++++-------------------------
 2 files changed, 52 insertions(+), 26 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 4b389431b1639..f4c59534670e4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1872,9 +1872,26 @@ static inline int get_sysctl_max_map_count(void)
 
 /*
  * Create a mapping if it doesn't exist. (Otherwise, skip regions with no
- * existing mapping, and return an error for regions with no leaf pagetable).
+ * existing mapping). Most users will want PGRANGE_ALLOC or 0 instead.
  */
 #define PGRANGE_CREATE		(1 << 0)
+/*
+ * Allocate a pagetable if one is missing. (Otherwise, return an error for
+ * regions with no leaf pagetable). Also implies PGRANGE_CREATE.
+ */
+#define PGRANGE_ALLOC		(1 << 1)
+/*
+ * Do not take any locks. This means the caller has taken care of
+ * synchronisation. This is incompatible with PGRANGE_ALLOC and also with
+ * mm=&init_mm.
+ */
+#define PGRANGE_NOLOCK		(1 << 2)
+
+
+static inline bool pgrange_create(unsigned int flags)
+{
+	return flags & (PGRANGE_CREATE | PGRANGE_ALLOC);
+}
 
 int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			  unsigned long size, pte_fn_t fn,
diff --git a/mm/memory.c b/mm/memory.c
index 7e55014e5560b..9f0ccbbbc4e59 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3211,30 +3211,36 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 				     pte_fn_t fn, void *data, unsigned int flags,
 				     pgtbl_mod_mask *mask)
 {
-	bool create = flags & PGRANGE_CREATE;
 	pte_t *pte, *mapped_pte;
 	int err = 0;
 	spinlock_t *ptl;
 
-	if (create) {
+	if (flags & PGRANGE_ALLOC) {
+		VM_WARN_ON(flags & PGRANGE_NOLOCK);
+
 		mapped_pte = pte = (mm == &init_mm) ?
 			pte_alloc_kernel_track(pmd, addr, mask) :
 			pte_alloc_map_lock(mm, pmd, addr, &ptl);
+
 		if (!pte)
 			return -ENOMEM;
 	} else {
-		mapped_pte = pte = (mm == &init_mm) ?
-			pte_offset_kernel(pmd, addr) :
-			pte_offset_map_lock(mm, pmd, addr, &ptl);
+		if (mm == &init_mm)
+			pte = pte_offset_kernel(pmd, addr);
+		else if (flags & PGRANGE_NOLOCK)
+			pte = pte_offset_map(pmd, addr);
+		else
+			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
 		if (!pte)
 			return -EINVAL;
+		mapped_pte = pte;
 	}
 
 	lazy_mmu_mode_enable();
 
 	if (fn) {
 		do {
-			if (create || !pte_none(ptep_get(pte))) {
+			if (pgrange_create(flags) || !pte_none(ptep_get(pte))) {
 				err = fn(pte, addr, data);
 				if (err)
 					break;
@@ -3245,8 +3251,12 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 	lazy_mmu_mode_disable();
 
-	if (mm != &init_mm)
-		pte_unmap_unlock(mapped_pte, ptl);
+	if (mm != &init_mm) {
+		if (flags & PGRANGE_NOLOCK)
+			pte_unmap(mapped_pte);
+		else
+			pte_unmap_unlock(mapped_pte, ptl);
+	}
 	return err;
 }
 
@@ -3256,13 +3266,12 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 				     pgtbl_mod_mask *mask)
 {
 	pmd_t *pmd;
-	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
 	BUG_ON(pud_leaf(*pud));
 
-	if (create) {
+	if (pgrange_create(flags)) {
 		pmd = pmd_alloc_track(mm, pud, addr, mask);
 		if (!pmd)
 			return -ENOMEM;
@@ -3271,12 +3280,12 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 	}
 	do {
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(*pmd) && !create)
+		if (pmd_none(*pmd) && !pgrange_create(flags))
 			continue;
 		if (WARN_ON_ONCE(pmd_leaf(*pmd)))
 			return -EINVAL;
 		if (!pmd_none(*pmd) && WARN_ON_ONCE(pmd_bad(*pmd))) {
-			if (!create)
+			if (!pgrange_create(flags))
 				continue;
 			pmd_clear_bad(pmd);
 		}
@@ -3295,11 +3304,10 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 				     pgtbl_mod_mask *mask)
 {
 	pud_t *pud;
-	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
-	if (create) {
+	if (pgrange_create(flags)) {
 		pud = pud_alloc_track(mm, p4d, addr, mask);
 		if (!pud)
 			return -ENOMEM;
@@ -3308,17 +3316,17 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 	}
 	do {
 		next = pud_addr_end(addr, end);
-		if (pud_none(*pud) && !create)
+		if (pud_none(*pud) && !pgrange_create(flags))
 			continue;
 		if (WARN_ON_ONCE(pud_leaf(*pud)))
 			return -EINVAL;
 		if (!pud_none(*pud) && WARN_ON_ONCE(pud_bad(*pud))) {
-			if (!create)
+			if (!pgrange_create(flags))
 				continue;
 			pud_clear_bad(pud);
 		}
 		err = apply_to_pmd_range(mm, pud, addr, next,
-					 fn, data, create, mask);
+					 fn, data, flags, mask);
 		if (err)
 			break;
 	} while (pud++, addr = next, addr != end);
@@ -3332,11 +3340,10 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 				     pgtbl_mod_mask *mask)
 {
 	p4d_t *p4d;
-	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
-	if (create) {
+	if (pgrange_create(flags)) {
 		p4d = p4d_alloc_track(mm, pgd, addr, mask);
 		if (!p4d)
 			return -ENOMEM;
@@ -3345,12 +3352,12 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 	}
 	do {
 		next = p4d_addr_end(addr, end);
-		if (p4d_none(*p4d) && !create)
+		if (p4d_none(*p4d) && !pgrange_create(flags))
 			continue;
 		if (WARN_ON_ONCE(p4d_leaf(*p4d)))
 			return -EINVAL;
 		if (!p4d_none(*p4d) && WARN_ON_ONCE(p4d_bad(*p4d))) {
-			if (!create)
+			if (!pgrange_create(flags))
 				continue;
 			p4d_clear_bad(p4d);
 		}
@@ -3368,7 +3375,6 @@ int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			  void *data, unsigned int flags)
 {
 	pgd_t *pgd;
-	bool create = flags & PGRANGE_CREATE;
 	unsigned long start = addr, next;
 	unsigned long end = addr + size;
 	pgtbl_mod_mask mask = 0;
@@ -3376,18 +3382,21 @@ int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 
 	if (WARN_ON(addr >= end))
 		return -EINVAL;
+	if (WARN_ON(flags & PGRANGE_NOLOCK &&
+		    (mm == &init_mm || flags & PGRANGE_ALLOC)))
+		return -EINVAL;
 
 	pgd = pgd_offset(mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
-		if (pgd_none(*pgd) && !create)
+		if (pgd_none(*pgd) && !pgrange_create(flags))
 			continue;
 		if (WARN_ON_ONCE(pgd_leaf(*pgd))) {
 			err = -EINVAL;
 			break;
 		}
 		if (!pgd_none(*pgd) && WARN_ON_ONCE(pgd_bad(*pgd))) {
-			if (!create)
+			if (!pgrange_create(flags))
 				continue;
 			pgd_clear_bad(pgd);
 		}
@@ -3410,7 +3419,7 @@ int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			unsigned long size, pte_fn_t fn, void *data)
 {
-	return __apply_to_page_range(mm, addr, size, fn, data, PGRANGE_CREATE);
+	return __apply_to_page_range(mm, addr, size, fn, data, PGRANGE_ALLOC);
 }
 EXPORT_SYMBOL_GPL(apply_to_page_range);
 

-- 
2.51.2



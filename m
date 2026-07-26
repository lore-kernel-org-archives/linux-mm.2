Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A61C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146186B009E; Sun, 26 Jul 2026 18:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E456B009F; Sun, 26 Jul 2026 18:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B346B00A0; Sun, 26 Jul 2026 18:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C05106B009E
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2507FA05DB
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:38 +0000 (UTC)
X-FDA: 85032355716.27.7288B94
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	by imf27.hostedemail.com (Postfix) with ESMTP id 33BCF40005
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tm/WJWpA";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 35ohmaggKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=35ohmaggKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4dpUyUWVU4SO+yzE3FO0i+T5bpBbji8PRmiEBEU3h4=;
	b=F03Xiob4EXVwKG9FVW/sGwgQvANC5epp0JI2MhzfxpruZjNcwWobRjD9iV7De7UNu24rVg
	208+j6UzvyQjkkWD4nw6oUrLH8CdUSRVuOG8Vy2utIyHUM2Diys9u9fAZM9B2/bWjQ/COY
	4E3kcVOaz2nkLpBsiykk/KGbhYltIrs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="tm/WJWpA";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 35ohmaggKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.221.72 as permitted sender) smtp.mailfrom=35ohmaggKCOsWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104616;
	b=S1mVEQAYqrWBCdDe4Le5RMHX6Yec+P0uyydpqF2VlGBUDhnI0mBYeFa5FPPBv+yoWqwqfP
	D+gDqwIpZx5SOfHZTBZqTgzqA5ikcjfCyhOBWsMRzP3NaLNop+S+D4FLTcgHcMa7pOdzc3
	bPOc3qCO/FSDu4vbq5l+HexwLs/dtTU=
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-473ac08a6a4so1527241f8f.0
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104615; x=1785709415; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f4dpUyUWVU4SO+yzE3FO0i+T5bpBbji8PRmiEBEU3h4=;
        b=tm/WJWpA1Lo1wN0L6/sn/7U0YZpPkPK0jdpHRGU/XY2dOi1vm8T4Y+nHGvdWylr1m7
         Y+WHc9qemQW7AGovWn7fZfVmRYb3omhcPreLM2ia1ByyjPoihbQmmluRDdhFabiGGaZH
         MMn4AL00fZ/p+z7g+/k6IXzkt0RgABdhvgXguUMIKJ3tgyadvVkNm6ZFzjjoUxGvMkro
         q0Ss6wq2zdI21AOIWyWWvZmQcpbBlQ9Z13xrm+lxUyMLP4vO63paCgWM1HBjOrFltMgw
         IDVIxIeNNoQlfBtYR8IpjNFilbXHmYZLMkFQMCcktd5U+UWcjpAzBic1UzYskSWhPnYi
         tORw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104615; x=1785709415;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f4dpUyUWVU4SO+yzE3FO0i+T5bpBbji8PRmiEBEU3h4=;
        b=UUqLcvJVdTKJoOS/mF9JXknnL+mcREjNxBQUMX80xKgO4vt/LQbefVci7xUHffesXb
         GHK3SAjdEXsRJB9AAt0p3znAdxK+8F8KRFlktv9MCNXxoP4vW5K+Ek4fN/C31WZtJgb1
         8rNj4koivoV0DfaajQfVC0hHcWBs3cuzeVd6VN+T+CD2HDlQnu40DMLqQkFf7kXADurJ
         CmH+d52PsWy8cSzRCDQmcIh1gSQkC0pRFZwDQ9P49HCK67eYswqk0/fex7A1ay1IMcod
         36uw4KIYlJn+lO0A/KVlAOUrymhkJIeW0q0Z2W4GvRVrZSn/KeFFJWS/6Y6GjKHcyoHN
         u73A==
X-Gm-Message-State: AOJu0YzftwCnOLf/GD2G2dOZFV391fNDE6qiuzJshTLrqOHfigklLmrv
	l3sU7V/M3Cjj+b/mxIrx0lYKH1ECvVbpkP7UFd3xNTXEZDn5ODYSIxtGv1qv8ESSkMV/Z9pXwBT
	4SiVBksaHY8DLMg==
X-Received: from wmbjz7.prod.google.com ([2002:a05:600c:5807:b0:495:6163:c602])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e86:b0:495:4730:15b2 with SMTP id 5b1f17b1804b1-496b690a8bcmr77698195e9.31.1785104614604;
 Sun, 26 Jul 2026 15:23:34 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:43 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-10-6f5729aa9832@google.com>
Subject: [PATCH v3 10/26] mm: Add more flags for __apply_to_page_range()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 33BCF40005
X-Rspam-User: 
X-Stat-Signature: rorkqda1ftxnkbkwdkxbfnx6ubs9iapx
X-HE-Tag: 1785104616-35839
X-HE-Meta: U2FsdGVkX1+pTzHgGQRqNVqnIq2jMjKygccShCRtuYyBmHitZGZoDpY+PtvZvpwp1aGatFazHyWZ/fNSlkllFEExb9BRdYrxps9SPgCQFn/HqSlUC5u4x/SFey3Qd/L+dY2uBC79PMkAhvspKl0aETPFcCVuCzWEFWMwRIpKzjrXg6ggSAzNcOOIcmHZIjzBAqQTGAf9SnBTzhO6W8d5jpaGYIFqhOBqB1KTE/OGVxlIS8A4qVp7T9pmFukcVJJvbdFEivRUjp34NzhiGCZbjRtdOzPr3cctgDX9kLyQ7DGbdKNZciAsT/LS8fDWoe6XEKOggxNfYTYvHGFpL/5ABypinkXC08ViVvnd4Gs8d7XQCMM5TImd+c14mlp0hY4wFPEkVHgZ5ZrepgS4FKyjlfhT/20WXhevvHXNiLU+pI5rPrZymGH5oEo3mV6afNp3KyYii8nVu6RWdTDfvST3b7gmnAhHh3oZYkAccReFFvusYJEmqM1cDRlIXE/do+Cm5g6L5aKvBq9FI7JT6ZCNNrPbVOS8viehQgvN9dz8qAYV0wqvpERk6wTHA5P9bkQNk0f4T26SG76S9PckkV0hxyruSAuUcrBhUQH8yO5i+iXhf+OlSDGp1mnHR67y5Sgee1fS0hh9Fr/sOSXgAROfBLcAJhj1qSypg9tBLioBlrZf/ztacOgM4QgQxFj+r5S5ZA4LxutqO2y7fRI5THeXKK0jSc3ZMvE7k1TC1u/W9mNl7+7bJpzIf9Py096FYV1RQ8UiX5pIN1xqOc/L3SXtgyCsb19ptfYYHr4dDTTuRFlSOLe/Oe9H36mTg15eXYTPIpBCstq4EmftoQ4AirXbFqQW5V83oVBDl3Uh4IvBoy+Ax9kjiehIu5M8UR++ljlBjxR6gOctHjP54o3F4ahVLC98HIs7eGB6xl8yh2b3PryeQJ2MEQnLpBsbpqWINaVsX4vovEZXzcS3Fo+57Ev
 09QhnZei
 gxCW79mvfR37ty+2vC4nZ9ixw3M1N6se024nPgZwFZZe5hitwojuab6NfOjpdnmnlTmedNquoufPdvxVINK/8BGZ8ustLL5GRGaUZeNjCD0ZpShhob1OnkEnRgiog/BYDgh0P9XSPKQ4FD0qzkhQK3TUi4/QEGakmnkXosCCrC+WWFs6mfH3txSNN1WmeR0zJazRPuZMT0bfaW5En+12cuISUF+APYWa5ZtKkek/dLjeXlYR/rqFeXofOzh4OBAjmD8BLZgeheRPzzhat06OTwSBWnldcoJZg7gzciAztXiNMifLlkvT7V8NtOZ7+V75Jn1MVrj7sv22hQOAX+9OxIbu65u4ev1n9/HtLSCJMil7bzp7c7n7fsU5mS+UqT1X8fSHNxigH5NjuH1psF0iLvCshnsN6MHCBxiEuNTF94p7AFnl0ZZ49ulfgi/8Or4DWNG4gewFqLcLFiEYxgj/+94yt2G6q1KCnYKGHWeqhZ6NtmKE1pREOiKiWQLmAwZ/UHoAhTJSJUJ+xNEmtmnAuCN4Qxlcf//cNf283thN7p0+U6QAc0iKHYRyrxdqS1yOaFNad7am3PEqTU058oa0tEUQlyM/j+lCI8Lfd6DhO7OJnpXO0AT/I6+jD309dcgtFBAwMQvvbdivTW3Q=
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
 mm/internal.h | 26 +++++++++++++++++++++++++-
 mm/memory.c   | 59 ++++++++++++++++++++++++++++++++++-------------------------
 2 files changed, 59 insertions(+), 26 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 395331a12d62d..5a237d9c5fa96 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1662,9 +1662,33 @@ static inline bool can_spin_trylock(void)
 
 /*
  * Create a mapping if it doesn't exist. (Otherwise, skip regions with no
- * existing mapping, and return an error for regions with no leaf pagetable).
+ * existing mapping). This doesn't allow allocating, most users will want
+ * PGRANGE_ALLOC.
+ *
+ * Do not test this bit directly as it is implied by PGRANGE_ALLOC, use
+ * pgrange_create() instead.
  */
 #define PGRANGE_CREATE		(1 << 0)
+/*
+ * Allocate a pagetable if one is missing. (Otherwise, return an error for
+ * regions with no leaf pagetable). Also implies PGRANGE_CREATE.
+ *
+ * Note that __apply_to_page_range() assumes that pagetables for the area are
+ * already initialised down to PMD level, so this only affects PTEs in practice.
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
index c4defefea1574..d00508db1021e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3441,30 +3441,35 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
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
@@ -3475,8 +3480,13 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 	lazy_mmu_mode_disable();
 
-	if (mm != &init_mm)
-		pte_unmap_unlock(mapped_pte, ptl);
+	if (mm != &init_mm) {
+		if (flags & PGRANGE_NOLOCK)
+			pte_unmap(mapped_pte);
+		else
+			pte_unmap_unlock(mapped_pte, ptl);
+	}
+
 	return err;
 }
 
@@ -3486,13 +3496,12 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
 				     pgtbl_mod_mask *mask)
 {
 	pmd_t *pmd;
-	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
 	BUG_ON(pud_leaf(*pud));
 
-	if (create) {
+	if (flags & PGRANGE_ALLOC) {
 		pmd = pmd_alloc_track(mm, pud, addr, mask);
 		if (!pmd)
 			return -ENOMEM;
@@ -3501,12 +3510,12 @@ static int apply_to_pmd_range(struct mm_struct *mm, pud_t *pud,
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
@@ -3525,11 +3534,10 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
 				     pgtbl_mod_mask *mask)
 {
 	pud_t *pud;
-	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
-	if (create) {
+	if (flags & PGRANGE_ALLOC) {
 		pud = pud_alloc_track(mm, p4d, addr, mask);
 		if (!pud)
 			return -ENOMEM;
@@ -3538,17 +3546,17 @@ static int apply_to_pud_range(struct mm_struct *mm, p4d_t *p4d,
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
@@ -3562,11 +3570,10 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
 				     pgtbl_mod_mask *mask)
 {
 	p4d_t *p4d;
-	bool create = flags & PGRANGE_CREATE;
 	unsigned long next;
 	int err = 0;
 
-	if (create) {
+	if (flags & PGRANGE_ALLOC) {
 		p4d = p4d_alloc_track(mm, pgd, addr, mask);
 		if (!p4d)
 			return -ENOMEM;
@@ -3575,12 +3582,12 @@ static int apply_to_p4d_range(struct mm_struct *mm, pgd_t *pgd,
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
@@ -3598,7 +3605,6 @@ int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			  void *data, unsigned int flags)
 {
 	pgd_t *pgd;
-	bool create = flags & PGRANGE_CREATE;
 	unsigned long start = addr, next;
 	unsigned long end = addr + size;
 	pgtbl_mod_mask mask = 0;
@@ -3606,18 +3612,21 @@ int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 
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
@@ -3640,7 +3649,7 @@ int __apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 			unsigned long size, pte_fn_t fn, void *data)
 {
-	return __apply_to_page_range(mm, addr, size, fn, data, PGRANGE_CREATE);
+	return __apply_to_page_range(mm, addr, size, fn, data, PGRANGE_ALLOC);
 }
 EXPORT_SYMBOL_GPL(apply_to_page_range);
 

-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06AC0C87FCA
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 06:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C53F6B0099; Sun, 10 Aug 2025 02:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C206B009A; Sun, 10 Aug 2025 02:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBCC6B009B; Sun, 10 Aug 2025 02:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCBA86B0099
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 02:29:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90D8F116944
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 06:29:20 +0000 (UTC)
X-FDA: 83759870880.26.9B06952
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf25.hostedemail.com (Postfix) with ESMTP id C3C6CA0009
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 06:29:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ta+sb3Lu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3PDyYaAsKCGEKNJDRGFHCQ9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3PDyYaAsKCGEKNJDRGFHCQ9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--lokeshgidra.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754807358; a=rsa-sha256;
	cv=none;
	b=mZKmOMB63GsEPav+lYsES3Cyd306h5J9p7dWXwNYgHUOf2riVXfargUmbCw1RxREDRVvV3
	6Ii39UDmqo9vwTO9pSEnbgImFQKL2pZftuaRfgXl7nzCMyKrwXyHrPDgZlK1IEDtmyGOfH
	KlQ70EpPY8X51qsFTuyvdS+M5K1aAYA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ta+sb3Lu;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3PDyYaAsKCGEKNJDRGFHCQ9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3PDyYaAsKCGEKNJDRGFHCQ9FNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--lokeshgidra.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754807358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LvqkHo491TO4CfV7vACR5Ox7Hqn3CkZaS6CXJLveDig=;
	b=G5YBb88MMryw1aGLWkPWQV6yxIPxw6diY0gUMOP9kZPCohhPCpvTFGZK0+j46PQCwFKQTJ
	+j4zmzv2ikKZhhvouqPZ/R+P4STgXzNu+cJ+ykujTQf7aeGgpPd84T9lsHxz04/fFhvStm
	6xEOGG/wLhLKGarvcAf1cJO0CuogNL4=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23fe26e5a33so52766515ad.3
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 23:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754807357; x=1755412157; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LvqkHo491TO4CfV7vACR5Ox7Hqn3CkZaS6CXJLveDig=;
        b=Ta+sb3LuT5ttfBMiIudoJU93lzu4Mh/3z2Lu2uVrigMvF4QVKIX2CYzlDlvrgW74Sa
         0IhYlmRmW4XwXX8zpn5dTg1ie10bQpWhukBfnuHjz27bhvlnxvI0nKXwHXKiks+M5vm4
         YF0CxzXuksQ3lb3vXRoh3OTl+RyOfJyePmz8pJnM9bAf6yqqZrzb74kBN8lc7MFGxtxe
         6m8fJGXnLVg6j78ccBG0vbOtyxVyyesXgDTknkecG6Ik2VBnUShs/AyyT2reGsotozUI
         ilB3GyOVuEJGo6Py3fM992ucj4WlAMQN463l9vvVYXc06io49B8LU5vhIJqyuI+EIRcA
         cXrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754807357; x=1755412157;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LvqkHo491TO4CfV7vACR5Ox7Hqn3CkZaS6CXJLveDig=;
        b=ts5OU2WOZbNtnSTcfaDsrb77iVTUZ+JZYIX7g2Jmz1DkzBeC81hcJdP22GM8LSenA2
         +GAi7I08jpub7PPl6l9RpE1nj3DbE2OVwXsc11HxuZYaEy29d6WrZxtd07g7LqrsYYo3
         j+KXd0TY10bNUyk0D6EwgSCqMcLmY0YAwkr6nkgtK4jjeHVlwt1FglMJe0QQG4sClZe8
         WiMOmvjW///SvX8AG0V3RNw6uE5TTfpeqwmIRhChvMv/yQC8IrhCtYtwyQhicjQag1/f
         RVPWr0GtaxkLw4SthtlFrJEg2dN4PWURzzc1H2k4bszH6zlCDu2R/AQ1l4rnp6Rzq6ci
         iuxw==
X-Forwarded-Encrypted: i=1; AJvYcCU5P60GH0l9sKuoEPsgCCgvZy9AKaaC4GzFGnPQSnkqbO3UoeQyVSF6bK+fHcs056ctyubY0hD4zg==@kvack.org
X-Gm-Message-State: AOJu0YyFJpnUjAV1JhjvmxPhBvjojuv2gBxl+J7rk51ksBCPecR9EhSp
	fhHvAIEnBSpXbEJI2NqsXyXnKHhyMUrqVR3Jhx20Mya6uGyqHvL/p/6N7wMqieMKPhm833PhFjq
	SvsTMFtq005kweimFdm/d1XiojQ==
X-Google-Smtp-Source: AGHT+IF6ha+C4h/6VsCb5VyOyXNQfdzEspiOgpCSC6ANnbuoLac2T5tFdfi6fcZIyZDuq0JEpinBxeh8+Y2crauzQg==
X-Received: from ploq6.prod.google.com ([2002:a17:903:1aa6:b0:23e:3914:f342])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:da82:b0:23f:adfa:3a63 with SMTP id d9443c01a7336-242c20a34d7mr137414275ad.16.1754807356659;
 Sat, 09 Aug 2025 23:29:16 -0700 (PDT)
Date: Sat,  9 Aug 2025 23:29:12 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250810062912.1096815-1-lokeshgidra@google.com>
Subject: [PATCH v4] userfaultfd: opportunistic TLB-flush batching for present
 pages in MOVE
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	21cnbao@gmail.com, ngeoffray@google.com, 
	Lokesh Gidra <lokeshgidra@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Barry Song <v-songbaohua@oppo.com>, 
	David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6xubsku44y4fh6khfdqu163swrz77h6w
X-Rspam-User: 
X-Rspamd-Queue-Id: C3C6CA0009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754807358-307922
X-HE-Meta: U2FsdGVkX18cVuE4dqx+ZSJ/SI4xG6s+1J63QqItCsVnajmqzdrpBwMfwkvNVNJo1W+5LTag25esWB+zWbxHMZ7GNzr0cjFsh3Ct+X5vp6nWM8mf3z6DBjtw/PLQKANuuKDSXffkwfS3un+FFgqBJoLCyzrMUVgO9U7mXx9P8qp00dIZXFfcEN0wAM4HRXt8YrRYXJ4i6V9buAsrQxXisjAtpfrYLWpTaxjqTOoUMlV7ii4A0f4inPHGhFLvBtbzWEmyKDVMwwte1vrMsPZYJdJFQZXOyTaNGviZcMFlCOAV2DtdKEsjJfgXWZihE1lEnvmVleZY8QGwjQXX87WqUuYwA2h/6xzAy/3abjgp8h0ubwPkk5s/Z/RDznqBhNN0IbBf012xIk8c8G/Q0aRcIAK9b6CSKaeTmQa8Lca9toQ8V44DX5ec8qmVxyOYa1MHOwLvsP6TzhCrEwyXtkgnW4p1YG8FjIohUNfM4LAqmBjhmV3ZSw3lkAX7CosA5U2c2XMHZ37GtpbI630bpl+il+ARE4MSyig78V03zu2jj+dk5xsHshZ95z3DBAG8ulOXhFOioLDGqQ/LqVua4l+kLMxtbWiKvY8wgp3Ck96+Waxw2FwVAoJn+sVqGCZpgwmnHI9PfFJokSOoxkP0rZWE0fhYpy+wjRsOjy1m38IiJyQgU8/06cvAMbUW8FzDm4CycEpJ13VdaeJbCteJbRrLBafZW+4SLS9ouc1E+Djb99trPIYXlstWEXF/W38/CyxvSX/3d+AxfVCIDcZrgMonJoNp75U+G8KGOrvqLQHdpD/34dEjODHznCEGHOv0AbqW0rw/7F7spCzTo5zu1nnLS7bwHnNNKhCd/xZ7IkVSOfO+2inKEAP3x+A7Ojyjjyey2fuoBaAymkAV8V9EfYvqEDvEBjK1Dq5rI8gAmencL277YNPmqTzmr0ub4OjxE+GTcgmFwDcClUC8N7z9K1P
 TD4py7v+
 ocVb39fGT0az6xI/JuKuf3GLvCizRxhEhs8Bx76zC9rjrvBaSHQvNBYk9hSzBYPu7RAsVqJZhNNAPYfqIjOFPlBRwTzZaIHOliZVi037Pqqr2Jt06il0Arww2lazNcmdZjuTPn5iV4lxffWx3TxwYx3sD9gBuTDIvL1D95K4VjezdtpJZBp0GFBg9GhOGn0zAwG/k3FlJQyTBln4/aIPm8iEQDLEC9NL2SHXzA5k6gs4BFYtCC7uYMA5QLArKtcUwtCi2yEANTiw4RVzNxMp+zePWaRn3KGkra3p2HfbyiY7YZ95CgFUJLdnaF/b1n2HZuynqZQuEd8uQ8x6n3QEtRrfJjFMfM26Ukd9pBFS4UeW9Y5TCmARBp9c8ERNdVe1rAGlYieezfWFF8hPIvQwP+L/DtLU9EQuLO3K12rL7H5AfO7Ln7K22hDHdLAopFOoo+4QH5LP8B2uCr/0HrWntcQWwtKcGnYw3h/uF7nqAQgekyZTgjc2zQJksAL9C0OI8YY8KvvnTxaURbC3o7RvIrr4Wvt8LUHqV3f7KtOqKJeAz7CN5vfg3RKakK7ClGxac27skmS2dY9re/6T3RkuOn25eH1CfSPw0zysd4G1BDkoO33IHzZvzf8pFfH1u6BujMOvX7CUGT3dvWQXFIxrN4zQMnHxXsmXbuFmivkGHkGLjjO3rWfkmx2/4cA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
for moving present pages. Mitigate this cost by opportunistically
batching present contiguous pages for TLB flushing.

Without batching, in our testing on an arm64 Android device with UFFD GC,
which uses MOVE ioctl for compaction, we observed that out of the total
time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
~20% in vm_normal_folio().

With batching, the proportion of vm_normal_folio() increases to over
70% of move_pages_pte() without any changes to vm_normal_folio().
Furthermore, time spent within move_pages_pte() is only ~20%, which
includes TLB-flush overhead.

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
---
Changes since v3 [1]
- Fix unintialized 'step_size' warning, per Dan Carpenter
- Removed pmd_none() from check_ptes_for_batched_move(), per Peter Xu
- Removed flush_cache_range() in zero-page case, per Peter Xu
- Added comment to explain why folio reference for batched pages is not
  required, per Peter Xu
- Use MIN() in calculation of largest extent that can be batched under
  the same src and dst PTLs, per Peter Xu
- Release first folio's reference in move_present_ptes(), per Peter Xu

Changes since v2 [2]
- Addressed VM_WARN_ON failure, per Lorenzo Stoakes
- Added check to ensure all batched pages share the same anon_vma

Changes since v1 [3]
- Removed flush_tlb_batched_pending(), per Barry Song
- Unified single and multi page case, per Barry Song

[1] https://lore.kernel.org/all/20250807103902.2242717-1-lokeshgidra@google.com/
[2] https://lore.kernel.org/all/20250805121410.1658418-1-lokeshgidra@google.com/
[3] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@google.com/

 mm/userfaultfd.c | 178 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 127 insertions(+), 51 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index cbed91b09640..39d81d2972db 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1026,18 +1026,64 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
 	       pmd_same(dst_pmdval, pmdp_get_lockless(dst_pmd));
 }
 
-static int move_present_pte(struct mm_struct *mm,
-			    struct vm_area_struct *dst_vma,
-			    struct vm_area_struct *src_vma,
-			    unsigned long dst_addr, unsigned long src_addr,
-			    pte_t *dst_pte, pte_t *src_pte,
-			    pte_t orig_dst_pte, pte_t orig_src_pte,
-			    pmd_t *dst_pmd, pmd_t dst_pmdval,
-			    spinlock_t *dst_ptl, spinlock_t *src_ptl,
-			    struct folio *src_folio)
+/*
+ * Checks if the two ptes and the corresponding folio are eligible for batched
+ * move. If so, then returns pointer to the locked folio. Otherwise, returns NULL.
+ *
+ * NOTE: folio's reference is not required as the whole operation is within
+ * PTL's critical section.
+ */
+static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
+						 unsigned long src_addr,
+						 pte_t *src_pte, pte_t *dst_pte,
+						 struct anon_vma *src_anon_vma)
+{
+	pte_t orig_dst_pte, orig_src_pte;
+	struct folio *folio;
+
+	orig_dst_pte = ptep_get(dst_pte);
+	if (!pte_none(orig_dst_pte))
+		return NULL;
+
+	orig_src_pte = ptep_get(src_pte);
+	if (!pte_present(orig_src_pte) || is_zero_pfn(pte_pfn(orig_src_pte)))
+		return NULL;
+
+	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
+	if (!folio || !folio_trylock(folio))
+		return NULL;
+	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio) ||
+	    folio_anon_vma(folio) != src_anon_vma) {
+		folio_unlock(folio);
+		return NULL;
+	}
+	return folio;
+}
+
+static long move_present_ptes(struct mm_struct *mm,
+			      struct vm_area_struct *dst_vma,
+			      struct vm_area_struct *src_vma,
+			      unsigned long dst_addr, unsigned long src_addr,
+			      pte_t *dst_pte, pte_t *src_pte,
+			      pte_t orig_dst_pte, pte_t orig_src_pte,
+			      pmd_t *dst_pmd, pmd_t dst_pmdval,
+			      spinlock_t *dst_ptl, spinlock_t *src_ptl,
+			      struct folio **first_src_folio, unsigned long len,
+			      struct anon_vma *src_anon_vma)
 {
 	int err = 0;
+	struct folio *src_folio = *first_src_folio;
+	unsigned long src_start = src_addr;
+	unsigned long addr_end;
+
+	if (len > PAGE_SIZE) {
+		addr_end = (dst_addr + PMD_SIZE) & PMD_MASK;
+		len = MIN(addr_end - dst_addr, len);
 
+		addr_end = (src_addr + PMD_SIZE) & PMD_MASK;
+		len = MIN(addr_end - src_addr, len);
+	}
+	flush_cache_range(src_vma, src_addr, src_addr + len);
 	double_pt_lock(dst_ptl, src_ptl);
 
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
@@ -1051,31 +1097,57 @@ static int move_present_pte(struct mm_struct *mm,
 		err = -EBUSY;
 		goto out;
 	}
+	/* It's safe to drop the reference now as the page-table is holding one. */
+	folio_put(*first_src_folio);
+	*first_src_folio = NULL;
+	arch_enter_lazy_mmu_mode();
+
+	addr_end = src_addr + len;
+	while (true) {
+		orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
+		/* Folio got pinned from under us. Put it back and fail the move. */
+		if (folio_maybe_dma_pinned(src_folio)) {
+			set_pte_at(mm, src_addr, src_pte, orig_src_pte);
+			err = -EBUSY;
+			break;
+		}
 
-	orig_src_pte = ptep_clear_flush(src_vma, src_addr, src_pte);
-	/* Folio got pinned from under us. Put it back and fail the move. */
-	if (folio_maybe_dma_pinned(src_folio)) {
-		set_pte_at(mm, src_addr, src_pte, orig_src_pte);
-		err = -EBUSY;
-		goto out;
-	}
-
-	folio_move_anon_rmap(src_folio, dst_vma);
-	src_folio->index = linear_page_index(dst_vma, dst_addr);
+		folio_move_anon_rmap(src_folio, dst_vma);
+		src_folio->index = linear_page_index(dst_vma, dst_addr);
 
-	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
-	/* Set soft dirty bit so userspace can notice the pte was moved */
+		orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
+		/* Set soft dirty bit so userspace can notice the pte was moved */
 #ifdef CONFIG_MEM_SOFT_DIRTY
-	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
+		orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
 #endif
-	if (pte_dirty(orig_src_pte))
-		orig_dst_pte = pte_mkdirty(orig_dst_pte);
-	orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		if (pte_dirty(orig_src_pte))
+			orig_dst_pte = pte_mkdirty(orig_dst_pte);
+		orig_dst_pte = pte_mkwrite(orig_dst_pte, dst_vma);
+		set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
+
+		src_addr += PAGE_SIZE;
+		if (src_addr == addr_end)
+			break;
+		dst_addr += PAGE_SIZE;
+		dst_pte++;
+		src_pte++;
+
+		folio_unlock(src_folio);
+		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte,
+							dst_pte, src_anon_vma);
+		if (!src_folio)
+			break;
+	}
+
+	arch_leave_lazy_mmu_mode();
+	if (src_addr > src_start)
+		flush_tlb_range(src_vma, src_start, src_addr);
 
-	set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
+	if (src_folio)
+		folio_unlock(src_folio);
 out:
 	double_pt_unlock(dst_ptl, src_ptl);
-	return err;
+	return src_addr > src_start ? src_addr - src_start : err;
 }
 
 static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
@@ -1140,7 +1212,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 static int move_zeropage_pte(struct mm_struct *mm,
@@ -1167,20 +1239,19 @@ static int move_zeropage_pte(struct mm_struct *mm,
 	set_pte_at(mm, dst_addr, dst_pte, zero_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 
 /*
- * The mmap_lock for reading is held by the caller. Just move the page
- * from src_pmd to dst_pmd if possible, and return true if succeeded
- * in moving the page.
+ * The mmap_lock for reading is held by the caller. Just move the page(s)
+ * from src_pmd to dst_pmd if possible, and return number of bytes moved.
  */
-static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
-			  struct vm_area_struct *dst_vma,
-			  struct vm_area_struct *src_vma,
-			  unsigned long dst_addr, unsigned long src_addr,
-			  __u64 mode)
+static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
+			    struct vm_area_struct *dst_vma,
+			    struct vm_area_struct *src_vma,
+			    unsigned long dst_addr, unsigned long src_addr,
+			    unsigned long len, __u64 mode)
 {
 	swp_entry_t entry;
 	struct swap_info_struct *si = NULL;
@@ -1196,9 +1267,8 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	struct mmu_notifier_range range;
 	int err = 0;
 
-	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-				src_addr, src_addr + PAGE_SIZE);
+				src_addr, src_addr + len);
 	mmu_notifier_invalidate_range_start(&range);
 retry:
 	/*
@@ -1257,7 +1327,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
 			err = -ENOENT;
 		else /* nothing to do to move a hole */
-			err = 0;
+			err = PAGE_SIZE;
 		goto out;
 	}
 
@@ -1375,10 +1445,11 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			}
 		}
 
-		err = move_present_pte(mm,  dst_vma, src_vma,
-				       dst_addr, src_addr, dst_pte, src_pte,
-				       orig_dst_pte, orig_src_pte, dst_pmd,
-				       dst_pmdval, dst_ptl, src_ptl, src_folio);
+		err = move_present_ptes(mm, dst_vma, src_vma,
+					dst_addr, src_addr, dst_pte, src_pte,
+					orig_dst_pte, orig_src_pte, dst_pmd,
+					dst_pmdval, dst_ptl, src_ptl, &src_folio,
+					len, src_anon_vma);
 	} else {
 		struct folio *folio = NULL;
 
@@ -1732,7 +1803,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 {
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *src_vma, *dst_vma;
-	unsigned long src_addr, dst_addr;
+	unsigned long src_addr, dst_addr, src_end;
 	pmd_t *src_pmd, *dst_pmd;
 	long err = -EINVAL;
 	ssize_t moved = 0;
@@ -1775,8 +1846,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	if (err)
 		goto out_unlock;
 
-	for (src_addr = src_start, dst_addr = dst_start;
-	     src_addr < src_start + len;) {
+	for (src_addr = src_start, dst_addr = dst_start, src_end = src_start + len;
+	     src_addr < src_end;) {
 		spinlock_t *ptl;
 		pmd_t dst_pmdval;
 		unsigned long step_size;
@@ -1841,6 +1912,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 						  dst_addr, src_addr);
 			step_size = HPAGE_PMD_SIZE;
 		} else {
+			long ret;
+
 			if (pmd_none(*src_pmd)) {
 				if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES)) {
 					err = -ENOENT;
@@ -1857,10 +1930,13 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 				break;
 			}
 
-			err = move_pages_pte(mm, dst_pmd, src_pmd,
-					     dst_vma, src_vma,
-					     dst_addr, src_addr, mode);
-			step_size = PAGE_SIZE;
+			ret = move_pages_ptes(mm, dst_pmd, src_pmd,
+					      dst_vma, src_vma, dst_addr,
+					      src_addr, src_end - src_addr, mode);
+			if (ret < 0)
+				err = ret;
+			else
+				step_size = ret;
 		}
 
 		cond_resched();

base-commit: 561c80369df0733ba0574882a1635287b20f9de2
-- 
2.50.1.703.g449372360f-goog



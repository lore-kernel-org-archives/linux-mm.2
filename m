Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0707AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3C98E0003; Tue,  5 Aug 2025 08:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9544E8E0001; Tue,  5 Aug 2025 08:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8429D8E0003; Tue,  5 Aug 2025 08:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7365C8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:14:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F14E91A019D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:14:17 +0000 (UTC)
X-FDA: 83742596154.02.95548C7
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3EDB040007
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:14:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="VXUE/3xE";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3lvWRaAsKCBU695zD213yCv19916z.x97638FI-775Gvx5.9C1@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3lvWRaAsKCBU695zD213yCv19916z.x97638FI-775Gvx5.9C1@flex--lokeshgidra.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754396056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZzF7DGeEUFEW73nufhH2gRERAerFhddc4J1uzX/Ul1Q=;
	b=s0NB8t9gnunlqwAbiEkY5uy5K1k9I+5DW4sk7uIxjvB7FWArPkEySVtP9BnKqN5b2I3ouA
	pEk/NlFTPPBoFAfHphxgJmQiBwgH/arPC7HdXJSY9WklicIQxi61O8uZ9JfWkwrmoLBFrt
	KOXkVe7FjPJd7v/+dHuM0rpGFbtniXw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754396056; a=rsa-sha256;
	cv=none;
	b=ec2b9ajlQULdM2XH86GmcMM194JTX97JZ2liaK2b9Wq9GUSSK8MlV6jzdjAbfkj+YpkAOL
	dfCxJtaXDQlFZTFEKE/vdoE+BYr8BW4rAWjveGieKZnwlsSww3g5y8HhKZ92ch2PGdzuxv
	cbm5PbW+aheh16Mf8m81bQyWoGt4Ioo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="VXUE/3xE";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3lvWRaAsKCBU695zD213yCv19916z.x97638FI-775Gvx5.9C1@flex--lokeshgidra.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3lvWRaAsKCBU695zD213yCv19916z.x97638FI-775Gvx5.9C1@flex--lokeshgidra.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-23824a9bc29so77203305ad.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754396055; x=1755000855; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZzF7DGeEUFEW73nufhH2gRERAerFhddc4J1uzX/Ul1Q=;
        b=VXUE/3xEcRpgiP32rXGP/OypuQ7g14cxXIITYtGKw10GgTmId1vW8JuOp7b44j2gPz
         r6wAl2fJ++yyjyBOomYKJDJOmBzjPPjTSbz/9iFLphnkx6YSIkHhaizvF4a3r2bWoEIq
         PLnDZplKF0Nr50FkcS1q9N+ytKbb8aswTxs/UC45H+J2wkwKBwAL4P4Id3p8VSPvxnci
         8FvQPQnk3+jiM83Zj9KMzxTAdoEiRal/ptEjTJ47HKI4Qy5dwuu4h1fRUvI2HgNQ4pfH
         dcSls/btLvCaUD0rMSnvkqq4MgDx3Bb5XlHXh6InaAcwG8m5a4dF0Pc6zUlxBLi+CYg3
         EX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754396055; x=1755000855;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZzF7DGeEUFEW73nufhH2gRERAerFhddc4J1uzX/Ul1Q=;
        b=OlkT28Gw1luHgL3GkWJH1gR0rLYh0rXcG2QBYQQ9w2w8i8dqcjURDwIWKHf2uO19sq
         uiYd756VxVPvgR+umYmX9a3uO3XAs49MVmeiOAsbc3YruVO83XHoTEpmF1GcZvvlP5l1
         ABHgizY2X9RUEYTjsYpl6aS8QoHeHQDFdJPdGdI5m0451PZr5jo5KwjvUxnaiDpDLoEy
         DF1haVfzHWq557YOcQfhqsE/HbME1hRKRfbgxofvTotg5+bW8Mu+/Vu9do5MM/R5OENW
         jOmdtVzjFr0IDjiTFC23zj+akmZashpm0I4BwhYy1KP+uU5sEkHDGrPZ4gGw9/cV8cYR
         O/Aw==
X-Forwarded-Encrypted: i=1; AJvYcCUeJOGbaqqhsGgrFObKvVce+4ZldC77yMQd16ddkmNxJ/1dFmNQytpwmdc2TzSBAtz86RGEHIAZog==@kvack.org
X-Gm-Message-State: AOJu0YzQjTTszT9i65HcgLtkAs6/ywHlKCagDH5kuTcIoaTGGwTcUHVM
	hGSvZ17UglUcscbeEoXl7xhVWvS75sQ9W7zY8/hzEQqezlnkbucZR5BokCOmHhp7RUNO3xfoL/a
	1D1ECTYtV53K+RkNJcLpO59zmgg==
X-Google-Smtp-Source: AGHT+IF8Oi619hEHx5HgrY25vqiCr2U0ETURa4UydnVdkhJVp1qynSccgxjHXkhCHze+LNmVGPqSRpBTb8yD1JmeGQ==
X-Received: from ploc12.prod.google.com ([2002:a17:902:848c:b0:240:770f:72d2])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e547:b0:240:3bb7:fdc3 with SMTP id d9443c01a7336-24246feb25dmr173782505ad.28.1754396054997;
 Tue, 05 Aug 2025 05:14:14 -0700 (PDT)
Date: Tue,  5 Aug 2025 05:14:10 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805121410.1658418-1-lokeshgidra@google.com>
Subject: [PATCH v2] userfaultfd: opportunistic TLB-flush batching for present
 pages in MOVE
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: aarcange@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	21cnbao@gmail.com, ngeoffray@google.com, 
	Lokesh Gidra <lokeshgidra@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Barry Song <v-songbaohua@oppo.com>, 
	David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3EDB040007
X-Stat-Signature: sn6agmmuzsft6i38f1sx16be434mi3pm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754396056-494860
X-HE-Meta: U2FsdGVkX1/qcCEZIHstgcixbtipRGOzqZA1PX++dOfbVe1hrTKhzdFcRHi2/UnOj3KvYaWsZ6zYjQXTds9KZSLJ/6ttzBhyuYUYqSieXTUg88ArwRbBiXWcOWxSi/JSNLtXWS0AYR8kQxRza4iSQRMuC/15q8OwNP76sffyB2EwnqZkKB/G5+YO6E/QDr+CZss/t8UQdOzrQzUJh1YeVkfKqsnWvzbJdUEvEPuGsNc3FRFNU5jcDBc1sN2wIpwz9++VCmkbMdkBTdg+eLm1vNSR0voDh9CWmTwrnNd/CXQWZSd37E5gfE6Zsoy1rV1ND56AR3OzvhFkOmphWzCbAxVbY9sSYyXlSc/wYC8pJg+JRM4E5N9D6yRQU7LOhPOxFpw9lTN+loSba4RDS1iYVHxxEbh3kfjrMnxBDMBt9G6TW6fFCirELF/Vvsoz7tClVV1AgJAXYKyIV71kNjF8KCRxBNy8hnkukkfuTu7BXjHIW7hGovtwUHZaAHiV2uL48VTrhptBUceP5Tz+jcxUKh8fOqLOsiCPme3oW+2KGHwUjiOZh6cvLmoyuREr0mo+INFNUh/xE6zyYiPs+Rv3aX/vk3fX7FGtXD8UYPfM34p9dMsWR2M195biTfQOubxl3x5MRa5KNxMd0szJN+9DAHLoqRGMQdl63BIFo3aJf0Boi0D19XSr5kwitkzzb61JaYrQe/MjopI/O5OaN0uh5n7G3yyMFDs4IcRoj1Ix5NvfyiQSjSLHqA5RotpXSevrGPRQQubhe8QFEfJwOHCF0z23uIBldmlAqrni7oz6hav79BkWCl2jAv6QUEnXgeU7lAFDzADvtlm5NQu3NqnvdjPhQ1r/LfQ9qSx1UXaHBBqXTYR4+hYBcTOjL42iT4Z57mBeYX3FSy3etM0E3BK8N6IyxLYAIJKzoZY1UbYTToEsd02hvkicYLXvrTblGRmRHLq6dJ5hU5jNZ6c9ESi
 e47HfYbc
 wwqRoWA2oS+UtwKbwqADO19UNFWCV+mOyRGwlcdBlVJqm+djZhRdXZQl5csTAhlG0nUymT9TYzNlLhqZCWGZQgzaEAyZJOzFGabyd3vi7aTETNog/lL032sYGk+SwAnOGMWahdDdrzBF+aJGHUK6ZWmkaJCVXju94Mq9iUOkyXfbzD/YogPK6B+sGtRi/99lzGjkzEn6GFiMlar3nbr3HxYJC3efZS8gmZmcHm5uakMPR6MTxt/yN8S7holQKg1ei1OwVFkzhAnF89MpPEY+f9FYs3jxXXtPontK9Ynng1LitoIl4duFSFvu2RNzm0RLeW/yiKNBLUmnlaDasojQi/Yo69txXRzicBDtxMcBoL/EOAlQdiC5D1se1zeBpsQuC4RSMxXbulIhZWf6VLRqeJmYllDlrLAIsQF3TBj2hqldMYctoSYGIz6p0jhZTqWIGo2mAhcFQZmYEF5ttvkje93TnM3XEZz1Q5Sd9jSZbq8/6IHHUNPyVLhBm/zmlI6eVjKqDxv2pM88HWjQ09ZkUSh/uA8VgpK1Eo1V9oB/rkPfc1iy2+Qf3EHp5t+sYYZckt+ctpTH/lvFLm2t/qrDOHJQIownzqQ6qI5v1KcW3SMbOkOiQiAPv4lDhQonmXn6n+Kw42gstjJJ1lYZO6Yvr9N+50r+T3g/LqDadv7JwQXHgqjdRi19LFXzJbQ==
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
Changes since v1 [1]
- Removed flush_tlb_batched_pending(), per Barry Song
- Unified single and multi page case, per Barry Song

[1] https://lore.kernel.org/all/20250731104726.103071-1-lokeshgidra@google.com/

 mm/userfaultfd.c | 171 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 119 insertions(+), 52 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index cbed91b09640..0ab51bcf264c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1026,18 +1026,61 @@ static inline bool is_pte_pages_stable(pte_t *dst_pte, pte_t *src_pte,
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
+ * move. If so, then returns pointer to the folio, after locking it. Otherwise,
+ * returns NULL.
+ */
+static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
+						 unsigned long src_addr,
+						 pte_t *src_pte, pte_t *dst_pte)
+{
+	pte_t orig_dst_pte, orig_src_pte;
+	struct folio *folio;
+
+	orig_dst_pte = ptep_get(dst_pte);
+	if (!pte_none(orig_dst_pte))
+		return NULL;
+
+	orig_src_pte = ptep_get(src_pte);
+	if (pte_none(orig_src_pte) || !pte_present(orig_src_pte) ||
+	    is_zero_pfn(pte_pfn(orig_src_pte)))
+		return NULL;
+
+	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
+	if (!folio || !folio_trylock(folio))
+		return NULL;
+	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) {
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
+			      struct folio *src_folio, unsigned long len)
 {
 	int err = 0;
+	unsigned long src_start = src_addr;
+	unsigned long addr_end;
 
+	if (len > PAGE_SIZE) {
+		addr_end = (dst_addr + PMD_SIZE) & PMD_MASK;
+		if (dst_addr + len > addr_end)
+			len = addr_end - dst_addr;
+
+		addr_end = (src_addr + PMD_SIZE) & PMD_MASK;
+		if (src_addr + len > addr_end)
+			len = addr_end - src_addr;
+	}
+	flush_cache_range(src_vma, src_addr, src_addr + len);
 	double_pt_lock(dst_ptl, src_ptl);
 
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
@@ -1051,31 +1094,53 @@ static int move_present_pte(struct mm_struct *mm,
 		err = -EBUSY;
 		goto out;
 	}
+	arch_enter_lazy_mmu_mode();
+
+	addr_end = src_start + len;
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
+		src_pte++;
+		dst_pte++;
+
+		folio_unlock(src_folio);
+		src_folio = check_ptes_for_batched_move(src_vma, src_addr, src_pte, dst_pte);
+		if (!src_folio)
+			break;
+		dst_addr += PAGE_SIZE;
+	}
+
+	arch_leave_lazy_mmu_mode();
+	if (src_addr > src_start)
+		flush_tlb_range(src_vma, src_start, src_addr);
 
-	set_pte_at(mm, dst_addr, dst_pte, orig_dst_pte);
 out:
 	double_pt_unlock(dst_ptl, src_ptl);
-	return err;
+	if (src_folio)
+		folio_unlock(src_folio);
+	return src_addr > src_start ? src_addr - src_start : err;
 }
 
 static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
@@ -1140,7 +1205,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	set_pte_at(mm, dst_addr, dst_pte, orig_src_pte);
 	double_pt_unlock(dst_ptl, src_ptl);
 
-	return 0;
+	return PAGE_SIZE;
 }
 
 static int move_zeropage_pte(struct mm_struct *mm,
@@ -1154,6 +1219,7 @@ static int move_zeropage_pte(struct mm_struct *mm,
 {
 	pte_t zero_pte;
 
+	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	double_pt_lock(dst_ptl, src_ptl);
 	if (!is_pte_pages_stable(dst_pte, src_pte, orig_dst_pte, orig_src_pte,
 				 dst_pmd, dst_pmdval)) {
@@ -1167,20 +1233,19 @@ static int move_zeropage_pte(struct mm_struct *mm,
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
@@ -1196,9 +1261,8 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 	struct mmu_notifier_range range;
 	int err = 0;
 
-	flush_cache_range(src_vma, src_addr, src_addr + PAGE_SIZE);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-				src_addr, src_addr + PAGE_SIZE);
+				src_addr, src_addr + len);
 	mmu_notifier_invalidate_range_start(&range);
 retry:
 	/*
@@ -1257,7 +1321,7 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 		if (!(mode & UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES))
 			err = -ENOENT;
 		else /* nothing to do to move a hole */
-			err = 0;
+			err = PAGE_SIZE;
 		goto out;
 	}
 
@@ -1375,10 +1439,13 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
 			}
 		}
 
-		err = move_present_pte(mm,  dst_vma, src_vma,
-				       dst_addr, src_addr, dst_pte, src_pte,
-				       orig_dst_pte, orig_src_pte, dst_pmd,
-				       dst_pmdval, dst_ptl, src_ptl, src_folio);
+		err = move_present_ptes(mm, dst_vma, src_vma,
+					dst_addr, src_addr, dst_pte, src_pte,
+					orig_dst_pte, orig_src_pte, dst_pmd,
+					dst_pmdval, dst_ptl, src_ptl, src_folio, len);
+		/* folio is already unlocked by move_present_ptes() */
+		folio_put(src_folio);
+		src_folio = NULL;
 	} else {
 		struct folio *folio = NULL;
 
@@ -1732,7 +1799,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 {
 	struct mm_struct *mm = ctx->mm;
 	struct vm_area_struct *src_vma, *dst_vma;
-	unsigned long src_addr, dst_addr;
+	unsigned long src_addr, dst_addr, src_end;
 	pmd_t *src_pmd, *dst_pmd;
 	long err = -EINVAL;
 	ssize_t moved = 0;
@@ -1775,8 +1842,8 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 	if (err)
 		goto out_unlock;
 
-	for (src_addr = src_start, dst_addr = dst_start;
-	     src_addr < src_start + len;) {
+	for (src_addr = src_start, dst_addr = dst_start, src_end = src_start + len;
+	     src_addr < src_end;) {
 		spinlock_t *ptl;
 		pmd_t dst_pmdval;
 		unsigned long step_size;
@@ -1857,10 +1924,10 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 				break;
 			}
 
-			err = move_pages_pte(mm, dst_pmd, src_pmd,
-					     dst_vma, src_vma,
-					     dst_addr, src_addr, mode);
-			step_size = PAGE_SIZE;
+			err = move_pages_ptes(mm, dst_pmd, src_pmd,
+					      dst_vma, src_vma, dst_addr,
+					      src_addr, src_end - src_addr, mode);
+			step_size = err;
 		}
 
 		cond_resched();
@@ -1872,7 +1939,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 			break;
 		}
 
-		if (err) {
+		if (err < 0) {
 			if (err == -EAGAIN)
 				continue;
 			break;

base-commit: 7e161a991ea71e6ec526abc8f40c6852ebe3d946
-- 
2.50.1.565.gc32cd1483b-goog



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291C7606A88F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J7BjRmu2
Received: by kanga.kvack.org (Postfix)
	id D156C6B05C0; Mon, 16 Nov 2026 06:04:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70C96B05C1; Mon, 16 Nov 2026 06:04:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FEF6B05C2; Mon, 16 Nov 2026 06:04:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92E926B05C0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:04:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31D5A40966
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:27 +0000 (UTC)
X-FDA: 85440698574.25.22E5C0C
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 688A818000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J7BjRmu2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=nakixii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZX3pkyyq8Bg5+JdrpMjD7+301LPabJjTMnmRRo+l6ag=;
	b=Z1k1abDaAMRIVnwGCSFBMsqTuEIa4N1L9qNb5V1B4uYBcOpDw5qTFS/ITc4WsI7XUSzp1E
	4U/3DzkjHXO/fRHkix5Z6uMQIXPKkNKz8atCRt5bJpRNbJ5so454gHyRsEABJRGlTcuXon
	V9JXFqPQBr2S0F/6WL60/3Gap9Fy8RU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J7BjRmu2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=nakixii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827065;
	b=ahrS98IRqDQVeBYJYf+AclogWDp/3TizYMSdEcPAaOcNI7j/aXvQU7clpC0KjJtfL8FrbI
	mRvW+VuhdKsG5uqJYQBNsINM/nDhv3SzGVkayNAS9nZUMh+1ju+BeISqHND9WOUZ6DRcDb
	pT87r/COia8JY/n2mqW2FgV2DwvD8W0=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1b3ada81853so2886575c88.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827064; x=1795431864; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZX3pkyyq8Bg5+JdrpMjD7+301LPabJjTMnmRRo+l6ag=;
        b=J7BjRmu2nDgeHKHYzPVB1DmlCkF79Y2OnvChK6acV0AjRljpM9MhE9AEQ60S1OmBUI
         ysqi6QfISZT5gC6dTYzpD92Z/kUbqzKZWLXA6Nhf1XYY+RdbNQCOQxsW7Iw76K/ZAjaI
         wqWhaDa9ZOvezAIux/AXsLkik6PEyJTeT0xQUJHrlapRYF3eTp92Z09HLhNbARlKytja
         UDcy7xd7NBiJ1+B+44GzC943oRGA+sqyrJBeKlhTf8hyKjS4RHe/g4lTyYvmqJn4VfiE
         t9by5X0ZeObMj5D/NOMdbe7Pd3rJQOgFFXhhES9Qq0Txfzz2hKMeW9nbltZsY3jq8HZ2
         iBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827064; x=1795431864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZX3pkyyq8Bg5+JdrpMjD7+301LPabJjTMnmRRo+l6ag=;
        b=K4XeGQgYQRXils+lJ6BO4N8VMZ8fT6iPt97bYk9eeVqCOeYWr2KJvCiQ/hTsNAEb4a
         mKzWztnJVMzajBKdKDsJJ7OmRE8GTTSYy5ItrqaP7xGNKPi4EwfeNLa8FDu6D5XSiiGw
         qaB/c8k/kB9QjBD82PDWCiHBLg5QzZ7NXumcyKjrctjPx7Y7bpxQZDKrUK2/5Xh6Efia
         8dfTAjph5gjh6V5xODU+4Pqrc2L/aR9HMW653JnfXMcrD6bpQSUI4pVVWhz0S+Jdvx1B
         40FKvQY4f77hzciizMM/aMYSdXF/Psng19kqqKOwsLT6YVHVf/wJybLvLVh7FGZO9h7f
         5cYg==
X-Gm-Message-State: APuU4Z+e0Lglpl6BMmqGZnjP7XB1NZ+FtHQzfHNenkv8cqHrQ6AJptO5
	hc2TbaBRnRr3zytpEIp2B1HUeKVg2+kIUw9jWfKnuG8EVqkStDuVJ/yjyioJ06Cd9fr1+Enz
X-Gm-Gg: AYBFou0OM6Cx1FSAUUWavaHoY7Nztn3gkyguNibGsezuatf++jQsggJBjRQV4GzhFar
	3bvMklGNQ+52GuLfaCIMq1f1t5V7zs8bvZdZNiaV6xZkFpKlvyEUeaIuFCOtX3SijWIyoPPt0lk
	W9Ze2Qwr417TwGXSNUofyTuy7+MUcv52DIPjP5O+F2XmMwqllgIZL32H4NCHyCVyVdcgwfCbMFG
	IB2MMsAj9btabG+qUpUlaN0cEVu/AxyeiAhdssgdVp00NKmrUt05VgI4N8BNzkv2H7Ed9tM2PyA
	C0Ik0EIiwX9iQZTHP/mE0+6UBYpjQD6D6tHy33aQq1bjxzAkipFMTM8u7XtQl8TWBHTe5RRkigO
	tL9Evz2QU/q1zdbAxjWYHuLFdOmgPoOdxGlXeF9g9S/Hc4j2lBFI3gLZHmNH0cT+D7Ev6bqdF4W
	bsrq+/ftNn6XCMdC1yRYGvHEgAkuwSRGAHkPD+4XZdeA+rqdNJ1Dmt2OaOVMZ5+uaIpJwpe0gHv
	+z8ub1Yd6S07AKTtf0DPhMqDx/tWDJNjBcboQRR/+xevb8NqxL7I6TvsIvWcxD0pBWOMmowUVqZ
	my1Ilw+1ts5l7pHFRCiWMfKUoe6nDrra8KIyHKx4m/3nNHY=
X-Received: by 2002:a05:7022:1e0d:b0:1b3:bae1:f5f3 with SMTP id a92af1059eb24-1b503068228mr8684015c88.6.1794827063915;
        Mon, 16 Nov 2026 03:04:23 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:23 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 09/16] mm: memcomp: batch unmap reserved large folios
Date: Mon, 16 Nov 2026 19:01:15 +0800
Message-ID: <20261116110122.309748-10-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 688A818000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: urhnztnmzcc4nzy1dsp8z988x9ice9nu
X-HE-Tag: 1794827065-278278
X-HE-Meta: U2FsdGVkX19cFe3vEILgf1MFb+WuQaOtd2P56pLijz5JyuRipmWa9LqaiMPEA45odWgVvbkrJqg7kwKLcNv4WUETtbu7lT6NG0AWnbRBCGHRDbKUl9Wl5Jl+Aif/Aku72XorTDyHDWK82jOSVYdjuJRGDfN/Y568Q6+VbzN+tZwGtgz74mWiYtnarP+wtufa/X3T/hhlkoVxLxIzFddTkoT3r7/fMZwg39DhtzLSyVZQZOP2raamg0L5yX9ErGHLA9a5whge0oFupQUWIQzRbSD6aVbS1L3vPRDYaxFD9eftvwkU+xBQYmAr5y+GR1ihGvTFOZlX8pzaGinjhxaaFn3hm9F1/7yTlB5jpnj9a23yPzhv/V0m3WRq2ryAO1cK0cU6DydBLZxb0/Q7BInEqDOuQeqLrAfYdjiJ/SWqTnFVGzbQAzTF5rzfxyaCx6/h2cQsyMrxkGi5H5+VrJu9nJ5T1zzeQw+1zw6SZnfI+1MABnvMMzoX4eahJ8v0I+p43+/hd/xi2ZgBpKtp7aBCg73WDlcceOQ+77qDHQfFWY4/C/rxqcStdKBz0qjjnQnUe+MCsSsxLJT+gO4G/R+dOKJX4N0NV8bpNvMSy7efDbo1h7pS8twS0tn7x6UfAIzB+2Q13DYTdx8m8Md2uOoGU+xQySItUJV/CkPkgyT9/nKHnLbGT+rNFTD+twYp81EhztxhJLOQKsNlNYiJXITi/cg4czdRITKaF9yWHw6HDSJ8WI8WoaijhwMItMBgTWDD6AlfqTaAN1BZngK6YPl1bZxZS7ORSda8HsZi53T6kyRjr5GJVPATkJZT+WLOSke11FmwcyNIUiNVeEayIM7HOFDFljI3ta7f3NuBSAdM+/prVQyOQ4S1myF+Kc5cJCl0EI5MZXecQKMBhZ6DCYqqhnuG+P6pEDA1uts3QzI08m5J6GcRfU0cdXkRmTTFh2q9Jquf8Zt8cH9Y2Zy5t4i
 K/cP9tm1
 kiEc644L7j4m/KAFxL6y2lYp+JURHXbmEkBs39OFSv/JqLRSjul8wZrKgQPYpTqwA9uAEZwWJyr1n1xCFFQbD/qShkKxkGJYbKzUpxgGaQ5AYq7UN8o51yu2u9UuN3ThPrrAY2BNrR0efSLMR0BtDrQp4OWJqnGBaDCQ55CuZXi8gEXMsRGgJwcjGcv0ceR1EpxT1CddoeamlijYIyDfOpOjW3LTIEA/JRaWH+vfnQ5qZlYg4xlSG7FkSHU+umUtXiNJMPyjoCpi0dHKA1vRGim6Rv4A91JhkY+0XnctdU4a8YZUfAIbNp4TDj2LTMVL/e/grM3jOBU3vfXZ4/Zx2oOmwx469k71OSmvNS8rxWf9VT2d1VbWXZrMHiJRA+ksOVow5ZOKTJxkxjqLEkkCCWYFDPSIMnHReJdhMDdOmd4Yi73XXCUWqNM57cRJon/0lK30zJuLvM5xTfemgLA5pK/sZjiL7kpXt4XqP6PxUhcqd4zWjMU6wQ6VjcF4R3sXPtUB4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Batch uniform PTE runs only for reserved memcomp folios. Retain the
single-PTE path for mixed protection, soft-dirty or exclusivity state.
Acquire all token owners before clearing mappings and unwind the whole
prefix when sharing or architecture checks fail.

Keep TLB ordering, notifier scope and the native rmap completion
context.
Do not import the general lazyfree batching policy.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 mm/memcomp_rmap.h | 139 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/rmap.c         |  12 ++++
 2 files changed, 151 insertions(+)
 create mode 100644 mm/memcomp_rmap.h

diff --git a/mm/memcomp_rmap.h b/mm/memcomp_rmap.h
new file mode 100644
index 0000000000000000000000000000000000000000..52cdd471ad70fc27372fa819fc8996d57a3f418e
--- /dev/null
+++ b/mm/memcomp_rmap.h
@@ -0,0 +1,139 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _MM_MEMCOMP_RMAP_H
+#define _MM_MEMCOMP_RMAP_H
+
+#ifdef CONFIG_MEMCOMP
+/*
+ * Unlike the newer generic lazyfree batching path, this backport only batches
+ * a reserved memcomp span. Mixed protection or exclusive bits stay on the
+ * existing single-PTE path. The caller owns folio lock, PTL and notifier scope.
+ */
+static bool memcomp_unmap_exclusive_uniform(struct folio *folio)
+{
+	bool exclusive = PageAnonExclusive(folio_page(folio, 0));
+	unsigned int i;
+
+	for (i = 1; i < folio_nr_pages(folio); i++) {
+		if (PageAnonExclusive(folio_page(folio, i)) != exclusive)
+			return false;
+	}
+	return true;
+}
+
+static int memcomp_share_anon_ptes(struct folio *folio, struct page *page,
+				   unsigned int nr)
+{
+	unsigned int i;
+
+	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+		/* Paired with the memory barrier in try_grab_folio(). */
+		smp_mb();
+	if (unlikely(folio_maybe_dma_pinned(folio)))
+		return -EBUSY;
+	for (i = 0; i < nr; i++)
+		ClearPageAnonExclusive(page + i);
+	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+		/* Paired with the smp_rmb() in gup_must_unshare(). */
+		smp_mb__after_atomic();
+	return 0;
+}
+
+/* 1: use the original actor; >1: complete batch; <0: restored, abort walk. */
+static int memcomp_unmap_ptes(struct page_vma_mapped_walk *pvmw,
+			      struct folio *folio, struct vm_area_struct *vma,
+			      enum ttu_flags flags)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long address = pvmw->address, end, token;
+	unsigned int i, nr, got = 0;
+	struct page *page;
+	swp_entry_t entry;
+	pte_t first, old, swap;
+	bool exclusive;
+
+	if (!folio_memcomp_reserved(folio) || !folio_test_large(folio) ||
+	    !folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
+	    folio_test_hugetlb(folio) || (flags & TTU_HWPOISON) ||
+	    !memcomp_unmap_exclusive_uniform(folio))
+		return 1;
+	first = ptep_get(pvmw->pte);
+	if (!pte_present(first) || pte_unused(first))
+		return 1;
+	page = pfn_to_page(pte_pfn(first));
+	nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
+	end = min(pmd_addr_end(address, vma->vm_end), vma->vm_end);
+	nr = min_t(unsigned int, nr, (end - address) >> PAGE_SHIFT);
+	if (nr < 2)
+		return 1;
+	for (i = 1; i < nr; i++) {
+		if (!pte_same(pte_advance_pfn(first, i), ptep_get(pvmw->pte + i)))
+			break;
+	}
+	nr = i;
+	if (nr < 2)
+		return 1;
+	entry = page_swap_entry(page);
+	token = swp_offset(entry);
+	if (!is_memcomp_entry(entry) || !token || token > U32_MAX - (nr - 1))
+		return 1;
+	/* Each future PTE gets a real owner; failure unwinds the whole prefix. */
+	for (; got < nr; got++) {
+		if (!memcomp_entry_get(token + got))
+			goto refs_fail;
+	}
+	exclusive = PageAnonExclusive(page);
+	flush_cache_range(vma, address, address + nr * PAGE_SIZE);
+	old = get_and_clear_full_ptes(mm, address, pvmw->pte, nr, 0);
+	if (should_defer_flush(mm, flags)) {
+		for (i = 0; i < nr; i++)
+			set_tlb_ubc_flush_pending(mm, old, address + i * PAGE_SIZE);
+	} else {
+		flush_tlb_range(vma, address, address + nr * PAGE_SIZE);
+	}
+	if (pte_dirty(old))
+		folio_mark_dirty(folio);
+	update_hiwater_rss(mm);
+	for (i = 0; i < nr; i++) {
+		if (arch_unmap_one(mm, vma, address + i * PAGE_SIZE,
+				   pte_advance_pfn(old, i)) < 0)
+			goto restore;
+	}
+	if (exclusive && memcomp_share_anon_ptes(folio, page, nr))
+		goto restore;
+	if (list_empty(&mm->mmlist)) {
+		spin_lock(&mmlist_lock);
+		if (list_empty(&mm->mmlist))
+			list_add(&mm->mmlist, &init_mm.mmlist);
+		spin_unlock(&mmlist_lock);
+	}
+	add_mm_counter(mm, MM_ANONPAGES, -(int)nr);
+	add_mm_counter(mm, MM_SWAPENTS, nr);
+	swap = swp_entry_to_pte(entry);
+	if (exclusive)
+		swap = pte_swp_mkexclusive(swap);
+	if (pte_soft_dirty(old))
+		swap = pte_swp_mksoft_dirty(swap);
+	if (pte_uffd_wp(old))
+		swap = pte_swp_mkuffd_wp(swap);
+	for (i = 0; i < nr; i++)
+		set_pte_at(mm, address + i * PAGE_SIZE, pvmw->pte + i,
+			   pte_move_swp_offset(swap, i));
+	folio_remove_rmap_ptes(folio, page, nr, vma);
+	if (vma->vm_flags & VM_LOCKED)
+		mlock_drain_local();
+	folio_put_refs(folio, nr);
+	pvmw->pte += nr - 1;
+	pvmw->address += (nr - 1) * PAGE_SIZE;
+	return nr;
+restore:
+	/* Complete invalidation before set_ptes() may form a contpte range. */
+	flush_tlb_range(vma, address, address + nr * PAGE_SIZE);
+	/* Dirty/young aggregation is conservative; protection bits were uniform. */
+	set_ptes(mm, address, pvmw->pte, old, nr);
+refs_fail:
+	while (got)
+		memcomp_invalidate(token + --got);
+	return -EBUSY;
+}
+#endif /* CONFIG_MEMCOMP */
+#endif /* _MM_MEMCOMP_RMAP_H */
diff --git a/mm/rmap.c b/mm/rmap.c
index 41f1b9f645a261021698d7972649264de391601f..874cf92c1096267a5524b29ab55cc10a901cbcb1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1656,6 +1656,8 @@ void folio_remove_rmap_pmd(struct folio *folio, struct page *page,
 #endif
 }
 
+#include "memcomp_rmap.h"
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -1737,6 +1739,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 		/* Unexpected PMD-mapped THP? */
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
+#ifdef CONFIG_MEMCOMP
+		{
+			int nr = memcomp_unmap_ptes(&pvmw, folio, vma, flags);
+
+			if (nr < 0)
+				goto walk_abort;
+			if (nr > 1)
+				continue;
+		}
+#endif
 
 		pfn = pte_pfn(ptep_get(pvmw.pte));
 		subpage = folio_page(folio, pfn - folio_pfn(folio));


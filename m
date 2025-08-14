Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04936CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9433F900147; Thu, 14 Aug 2025 07:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4FA900023; Thu, 14 Aug 2025 07:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E0C900147; Thu, 14 Aug 2025 07:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59E90900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:39:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28A441360E5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:52 +0000 (UTC)
X-FDA: 83775168624.18.9F14743
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 60690160015
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZurSoaxB;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755171590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2tNODR+gIE1wISYj1B5DIPH8+ubzJqnYNm1qCk1BQs=;
	b=TyUiUOaDRWHmGdFnufbhYM8IklbJH+PFLOlJFYJGfWTtsNfGe2wa6K8/9Bjz825B9w8EsV
	gW4E3+JDAa9m4lvZfh+MrvexB7npvWYT8m+LRvIzPV75sfUXVQZVLIzAXgseaJRZiCNWzu
	BELKfMGkP2R65J2yzcas4VnCqV/MI7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755171590; a=rsa-sha256;
	cv=none;
	b=y9IAmTrszGNUnen/hvjHtgNbn4Zw7cziLUHmOVhr61NOCxImAbIWpYueRggKz4IZVpExgV
	UhNQ5Z7xLbrs95ugov53Kztjf14J5Tf3WoTgjjk54LjziZ1oG3nJAxMvo2cZWe2e0u+G8w
	d2Mk6bjzCFNoHajScRH05lPzPHysfSU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZurSoaxB;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b4716fb320cso620497a12.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755171589; x=1755776389; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g2tNODR+gIE1wISYj1B5DIPH8+ubzJqnYNm1qCk1BQs=;
        b=ZurSoaxBB54kKh+jY5lfDyWS++9loTuMsor9hlT7Oc/312l3kDIsGIi0fflQ7tIiWV
         GKTN/uA73tTD7r6FGNQK6zzjbvNu4cNWvZ3X30LtU8UBW831giuq6mJWeyYG+sucR3gI
         w++qH3pbblfUjIKOBH8T5XL6397Ca3LN1XOqR0lYi4BWen2sYCVHiFbw7vE38ZvM0/va
         fY+dX3Z44NuP1RrdMC3AGJ6XEaHLCkMC4bbv0hhmLxn86X0VwT4qHBfSbjNKP325/k/S
         AXa6kp9e7z7tWoW4Ol+aXLfBQKlwOmvuDCP6fD81p+JQmu5e5eZDw4d9lkdI/Q5xMqM1
         A0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755171589; x=1755776389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g2tNODR+gIE1wISYj1B5DIPH8+ubzJqnYNm1qCk1BQs=;
        b=uJAAsWLb1JPFZfqXicXD1NK4NQ5T3QGsMjTqxlDwEQj0ATDFo2u2PA6F75Ouvq9eBE
         doC91OztADBzPc4QO4fdNgGGjG75XG5cNuK8piUYSEUaam9WVtHnkdXwTddEGsgABTj3
         lA0eBhPgwWdtHQ/1u6Z9D892gc0LOnCNw9ZgUmIAWvDQwr8LEDicLcIZkML7xtLwOhOH
         /onI8ssINqqS04XQObKnu9HGrcLs+VFhWC9+hHBF+pa5fv3/CqsCpsqA7/3PSTnQP1N+
         sWmr9YIUvQPxqFpQFf8mbAS4c3bnxBtvlokwgowIvU57LA43g7jSJRq7pBNQCl9MxoG1
         63Tg==
X-Gm-Message-State: AOJu0YwZt5NUJV1Aw0wOvqhd2ylLWDEzKCfv9bLlDv5bmTH23xhGKn/t
	MBs1NUQlqSqLrelnddPk+6eVTBgiGH1mcDRWCMUUURYjGbpn3qATUKun
X-Gm-Gg: ASbGnctwT2ewOqpV5+KPnDynu4OO9sfJAcHis78qFeemExpfrf29Ucv0jggYB9zltR1
	XppeS42sA7+uxIkLXJ+4rafJzCeEoiyyFuKPNFyZDgj0zF6lH6BBLbEcHiF6eIiQiQvYUabhNgN
	0voNQsP9ojXtVX0iPQNI2RlVca0PokjJEB4MLMRmpoT7d7Wsne4v+YAMwnh8RAe5Qd/dZwj/vsp
	EOj70vxzweVL6LPPXJEghby6d3KILg8n4y1fPNr3ArJcaBTGGD90mUu0fPSxVq0WcG807stlkBB
	oc0O3MgoX4TY96KGj9q0irrNDvtdmsWH52/ccYh9j9U8JCuLFO/tQfk/Y7JZ5k5tHUR61IkRceC
	Rff07M3+tOaAQIXC3ACqb4deBLAI=
X-Google-Smtp-Source: AGHT+IEv/oEQGlnhKqQ5p0Ybl45qr0FrNbXN2QJZLABQwVzSNsQgxKPY+ctDBDLR50hqplRR0nVUOA==
X-Received: by 2002:a17:903:144f:b0:234:b743:c7a4 with SMTP id d9443c01a7336-244586c5006mr42599525ad.38.1755171589129;
        Thu, 14 Aug 2025 04:39:49 -0700 (PDT)
Received: from vernon-laptop ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2430b53d504sm49046215ad.87.2025.08.14.04.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:39:48 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	glider@google.com,
	elver@google.com,
	dvyukov@google.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	shuah@kernel.org,
	richardcochran@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.or,
	Vernon Yang <vernon2gm@gmail.com>
Subject: [RFC PATCH 5/7] mm: memory: improve wp_page_copy readability
Date: Thu, 14 Aug 2025 19:38:11 +0800
Message-ID: <20250814113813.4533-6-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814113813.4533-1-vernon2gm@gmail.com>
References: <20250814113813.4533-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60690160015
X-Stat-Signature: ot6xmetqz9smq155npcfwg9peuhkq4ja
X-Rspam-User: 
X-HE-Tag: 1755171590-534903
X-HE-Meta: U2FsdGVkX189oKdgDYeeVnjGUmHK8lcfEj/Mwt7RtgmIaQKuWRn/lKM64FY8Z81gkoXQXH9ytP9M6QGbVBPY8LETljM0mKHIiHvI0c+VFc1TQE9zs21iWDzxvX2CaLYecFjFTk8BUuwI9qqKxlaDR6sMNIhOtOlnMCrclTavCn5l/5nchfahMMo88W2x9TNITAAjOeirSG4dfqkmyRihxG9gmdvlVIOtOMsysPD/cgAUpP9kMTOUEa8aPzaMLrsot3Lh4tLWY97gXWNIWwo9qOc7gVXme2EQ2K6vpYZAG112ek2mN6Lq8iTimJ8AUb1fXZjrUaIeo3sIRmlevLqr1Yd5VlLdj2B4r8gyHQnVIyRHNKtXcXVESZxzySfyh8EyZcn5g9ymQ0xJccTBwTKbbLEOb7l0mDHcu/m0RKHb7ukQ1NmxJISObqn+jXPKjfmnInqS+5jbkyGCfbpVq526Jku9RR/MUTmHEpO5r/OV3MaF52uSE+aJ8/N72hcf0BI3oQAhQo6HjACF+XL4lBY8rWlSLpLbsqa0ItyhsimYJpJ8DBNlDsfWpQbEZXkHu1qiXGrfmTu/yD7Soq3lhWcRnhGiZgQE1GR6WQgGo60FBteGqw7nJPsGgwBlJzy17DkFQ//QvbBIKNrus8jMecLtmBUdHQA4lLQCQPl6oeU8zHCG/ovZodTuh5GkjYk/09WPXCx3PmKM895crFDcjP2SJ/QeOFqyfjquVZeRDm0se96fdWu29GBaoCRiCzANl6KGQNvWTsY+07JS71MiwrV4Xiu4xj7TLew2qC8whpXiysBYKm5sKhQ98eUMjwcD9cIvyYNxK+XO6yk0VyQiaO6yqAg2jscgjKB2jQjA5Vpt7mmFYp1ERn+Xr2FfYoA+9JZJbfBFXHotMo8JReygb3NITDXLYlhfbvhMdwNxSDDsZ7XcZD25pRbh/HARjjVHyJf53G+DVG9Nd2ewt2fI3gd
 3pamqNpI
 0EqFDmHLZ4Iu94DlcAhU9RSLLqEE2en3NTcS1lAr7zYh2+pMf+At8+O3Kna1VSjXSQOiqHlD2FQTsiT15xLU1MVuBjbCqfXa257IZoaDJOVsiY+uIsL9BJM+q8JdNwNciWbsZmDD5Y3i9gY4VLhSdkvTF/EFaiqbITzO+sEtlihwqwAxr62/0qEGDeEc6kYXMB8Cfj1QnNE+knMdxj1m9OOZV+ikynxpNT8GOv+2fgk5o2KU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for wp support mthp, improve wp_page_copy() readability,
without any functional changes.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 mm/memory.c | 148 +++++++++++++++++++++++++++-------------------------
 1 file changed, 77 insertions(+), 71 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3451e6e5aabd..8dd869b0cfc1 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3551,16 +3551,18 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *old_folio = NULL;
 	struct folio *new_folio = NULL;
+	struct page *old_page = vmf->page;
 	pte_t entry;
 	int page_copied = 0;
 	struct mmu_notifier_range range;
 	vm_fault_t ret;
 	bool pfn_is_zero;
+	unsigned long addr;
 
 	delayacct_wpcopy_start();
 
-	if (vmf->page)
-		old_folio = page_folio(vmf->page);
+	if (old_page)
+		old_folio = page_folio(old_page);
 	ret = vmf_anon_prepare(vmf);
 	if (unlikely(ret))
 		goto out;
@@ -3570,10 +3572,12 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	if (!new_folio)
 		goto oom;
 
+	addr = ALIGN_DOWN(vmf->address, PAGE_SIZE);
+
 	if (!pfn_is_zero) {
 		int err;
 
-		err = __wp_page_copy_user(&new_folio->page, vmf->page, vmf);
+		err = __wp_page_copy_user(&new_folio->page, old_page, vmf);
 		if (err) {
 			/*
 			 * COW failed, if the fault was solved by other,
@@ -3589,90 +3593,92 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 			delayacct_wpcopy_end();
 			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
-		kmsan_copy_pages_meta(&new_folio->page, vmf->page, 1);
+		kmsan_copy_pages_meta(&new_folio->page, old_page, 1);
 	}
 
 	__folio_mark_uptodate(new_folio);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
-				vmf->address & PAGE_MASK,
-				(vmf->address & PAGE_MASK) + PAGE_SIZE);
+				addr, addr + PAGE_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
 
 	/*
 	 * Re-check the pte - we dropped the lock
 	 */
-	vmf->pte = pte_offset_map_lock(mm, vmf->pmd, vmf->address, &vmf->ptl);
-	if (likely(vmf->pte && pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
-		if (old_folio) {
-			if (!folio_test_anon(old_folio)) {
-				sub_mm_counter(mm, mm_counter_file(old_folio), 1);
-				add_mm_counter(mm, MM_ANONPAGES, 1);
-			}
-		} else {
-			ksm_might_unmap_zero_page(mm, vmf->orig_pte);
-			inc_mm_counter(mm, MM_ANONPAGES);
-		}
-		flush_cache_range(vma, vmf->address, vmf->address + PAGE_SIZE);
-		entry = folio_mk_pte(new_folio, vma->vm_page_prot);
-		entry = pte_sw_mkyoung(entry);
-		if (unlikely(unshare)) {
-			if (pte_soft_dirty(vmf->orig_pte))
-				entry = pte_mksoft_dirty(entry);
-			if (pte_uffd_wp(vmf->orig_pte))
-				entry = pte_mkuffd_wp(entry);
-		} else {
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	vmf->pte = pte_offset_map_lock(mm, vmf->pmd, addr, &vmf->ptl);
+	if (unlikely(!vmf->pte))
+		goto release;
+	if (unlikely(vmf_pte_changed(vmf))) {
+		update_mmu_tlb(vma, addr, vmf->pte);
+		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		goto release;
+	}
+
+	if (old_folio) {
+		if (!folio_test_anon(old_folio)) {
+			sub_mm_counter(mm, mm_counter_file(old_folio), 1);
+			add_mm_counter(mm, MM_ANONPAGES, 1);
 		}
+	} else {
+		ksm_might_unmap_zero_page(mm, vmf->orig_pte);
+		inc_mm_counter(mm, MM_ANONPAGES);
+	}
+	flush_cache_range(vma, addr, addr + PAGE_SIZE);
+	entry = folio_mk_pte(new_folio, vma->vm_page_prot);
+	entry = pte_sw_mkyoung(entry);
+	if (unlikely(unshare)) {
+		if (pte_soft_dirty(vmf->orig_pte))
+			entry = pte_mksoft_dirty(entry);
+		if (pte_uffd_wp(vmf->orig_pte))
+			entry = pte_mkuffd_wp(entry);
+	} else {
+		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+	}
 
+	/*
+	 * Clear the pte entry and flush it first, before updating the
+	 * pte with the new entry, to keep TLBs on different CPUs in
+	 * sync. This code used to set the new PTE then flush TLBs, but
+	 * that left a window where the new PTE could be loaded into
+	 * some TLBs while the old PTE remains in others.
+	 */
+	ptep_clear_flush_range(vma, addr, vmf->pte, 1);
+	folio_add_new_anon_rmap(new_folio, vma, addr, RMAP_EXCLUSIVE);
+	folio_add_lru_vma(new_folio, vma);
+	BUG_ON(unshare && pte_write(entry));
+	set_ptes(mm, addr, vmf->pte, entry, 1);
+	update_mmu_cache_range(vmf, vma, addr, vmf->pte, 1);
+	if (old_folio) {
 		/*
-		 * Clear the pte entry and flush it first, before updating the
-		 * pte with the new entry, to keep TLBs on different CPUs in
-		 * sync. This code used to set the new PTE then flush TLBs, but
-		 * that left a window where the new PTE could be loaded into
-		 * some TLBs while the old PTE remains in others.
+		 * Only after switching the pte to the new page may
+		 * we remove the mapcount here. Otherwise another
+		 * process may come and find the rmap count decremented
+		 * before the pte is switched to the new page, and
+		 * "reuse" the old page writing into it while our pte
+		 * here still points into it and can be read by other
+		 * threads.
+		 *
+		 * The critical issue is to order this
+		 * folio_remove_rmap_pte() with the ptp_clear_flush
+		 * above. Those stores are ordered by (if nothing else,)
+		 * the barrier present in the atomic_add_negative
+		 * in folio_remove_rmap_pte();
+		 *
+		 * Then the TLB flush in ptep_clear_flush ensures that
+		 * no process can access the old page before the
+		 * decremented mapcount is visible. And the old page
+		 * cannot be reused until after the decremented
+		 * mapcount is visible. So transitively, TLBs to
+		 * old page will be flushed before it can be reused.
 		 */
-		ptep_clear_flush_range(vma, vmf->address, vmf->pte, 1);
-		folio_add_new_anon_rmap(new_folio, vma, vmf->address, RMAP_EXCLUSIVE);
-		folio_add_lru_vma(new_folio, vma);
-		BUG_ON(unshare && pte_write(entry));
-		set_ptes(mm, vmf->address, vmf->pte, entry, 1);
-		update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
-		if (old_folio) {
-			/*
-			 * Only after switching the pte to the new page may
-			 * we remove the mapcount here. Otherwise another
-			 * process may come and find the rmap count decremented
-			 * before the pte is switched to the new page, and
-			 * "reuse" the old page writing into it while our pte
-			 * here still points into it and can be read by other
-			 * threads.
-			 *
-			 * The critical issue is to order this
-			 * folio_remove_rmap_pte() with the ptp_clear_flush
-			 * above. Those stores are ordered by (if nothing else,)
-			 * the barrier present in the atomic_add_negative
-			 * in folio_remove_rmap_pte();
-			 *
-			 * Then the TLB flush in ptep_clear_flush ensures that
-			 * no process can access the old page before the
-			 * decremented mapcount is visible. And the old page
-			 * cannot be reused until after the decremented
-			 * mapcount is visible. So transitively, TLBs to
-			 * old page will be flushed before it can be reused.
-			 */
-			folio_remove_rmap_ptes(old_folio, vmf->page, 1, vma);
-		}
-
-		/* Free the old page.. */
-		new_folio = old_folio;
-		page_copied = 1;
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
-	} else if (vmf->pte) {
-		update_mmu_tlb(vma, vmf->address, vmf->pte);
-		pte_unmap_unlock(vmf->pte, vmf->ptl);
+		folio_remove_rmap_ptes(old_folio, old_page, 1, vma);
 	}
 
+	/* Free the old page.. */
+	new_folio = old_folio;
+	page_copied = 1;
+	pte_unmap_unlock(vmf->pte, vmf->ptl);
+release:
 	mmu_notifier_invalidate_range_end(&range);
 
 	if (new_folio)
-- 
2.50.1



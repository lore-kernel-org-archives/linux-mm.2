Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA49C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68E9D6B00AB; Fri, 28 Aug 2026 14:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617D66B00AC; Fri, 28 Aug 2026 14:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0DD6B00AD; Fri, 28 Aug 2026 14:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21EC16B00AB
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:38:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AECF5C0509
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:38:11 +0000 (UTC)
X-FDA: 85151537982.26.6D4E107
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id D63E818000F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:38:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dpgnv9WD;
	spf=pass (imf24.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787942289;
	b=GpVl2G2gwDSGzn67eNC57+nAF7eH+R8o8eiqQe2kbRl5TMluyu+RM3RDd/Tn6FzopzyxuA
	nIXzvG48UD0qfPbha2VaTbaNWKfFC5pvg5K4zVTA1WQDTJUHwCqsmtBsX+BWmiUZGwXo6m
	Ed6CaO7ljg1GI1VGgrMweOtXlZGj65o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dpgnv9WD;
	spf=pass (imf24.hostedemail.com: domain of yintirui@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787942289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvYR8hSj3HruxGRZAeIbxinhDfyfRxH1dMC6OkZYttE=;
	b=Q/LID1BDrwHo3IgfvrP57RycSm6xl8v9y9ymL71T63xsG2tG5ChTnyHXHB75mXyBq60Hzd
	KZnmWpQFFcUTIDG8Oa641NrTs+jnFK0d+3XMqzdL0JUp8+EB5TCQuXnL+K8otwRnZ0z6T3
	03HlJB//W00hIFuAloMOgKGUyJjBWKQ=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84864086bfeso1225204b3a.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 11:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787942289; x=1788547089; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CvYR8hSj3HruxGRZAeIbxinhDfyfRxH1dMC6OkZYttE=;
        b=dpgnv9WDUK7sqLHPMES8hiAERkl50HwBgr6wRR1OGoaXKrLGkXFOfCooKYyDhtNVzZ
         6hfZ83cbR+nXDcGqU65GFz4KWww57fTmQTIaCv85NHGEWyYjgjWNIH2Ppl84L1ji4if1
         heQDjkpdz2zLnfewO2a21SESm0RigNl7WXogQxDaIlkIKSE7Onun25pIuZW9BE7uJ/d3
         m/u/hsI7HlCnWxA/aQ/X5D7U9IIEs9XjU2KLhoDeVr09UtlJCpUKgnCwUfkOp9n811nS
         dfyRNFnx1IBjB0e7IQz5nK3Ph6My8NlzD9/c+tz+dZvd8x1wwlDmffm/13lFHl4/SrIu
         aU4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787942289; x=1788547089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CvYR8hSj3HruxGRZAeIbxinhDfyfRxH1dMC6OkZYttE=;
        b=DyKx6pWw0IMk3mn0+fOGAvtL2KCIb8Tl3aY/7c5w2ROOkdyHtFVRGLkfwwrm2gKfnl
         MlksTrYgNTvgPLVIwccgGZCw3cytIBKjRTDj73eMFwXzryIi5ip8uHuglhTiNonXvjzu
         hYtIuY4YlGwkkQsQNi+iyzVBlXay3KT+sgq/m2T+kNYKC14M2bbO3/MmbaHDPpSSD56V
         AEL76tRorIuopsbX7n+/IEP/+ITEdHsSfK/CUUZQCBuCi7Av7t0YKNgu8TEuYQJVY6kj
         Mt5+Dw/IjBcr7kud3E8zFecvZT0LzIerOEvksFWav/fpEVUlIoYYfXoqYubYw6ZRHe4+
         9NAA==
X-Forwarded-Encrypted: i=1; AHgh+Ro94haQ7HjL/zkChlABmy03I6qkgbF6HGXaaLb+NsM2CFuFNdgfyJdyOuSu7gVj9/UNQQ52jjCkMw==@kvack.org
X-Gm-Message-State: AFuF++maK3ws1Q63jBxKB3WkVqxicc1cDd+RVTbqJt2gEANOdZ9EYUmT
	OeD6klEbhIMWO5afeq+0wru6eUUZfBlTpohQNjBljXIZ34ev9wGbx486
X-Gm-Gg: AR+sD12wozfGpB6BZt2WxyyuWbk254eOd1cohWUVJ5oVbdAfZjBQB2e1EkftrD19cJF
	IWw548W7dTGgD2mtVn6TW8m/OgZvzBJxPaxL7F3Xh+nfrVAJQ7akEC75SDx0vLhbOKi3Ljktxrq
	BL0YPEtfW3EXkknOVoq8CWjrG2YlrciBErrhxl6boHOAFRbRsRl4f2iRJLA6oC7uueIC2EpBD00
	D5+cA/RkKn1OgbvQ/UVI05998NfyveSa2vAPOckq6CP6f/2LRj07Uc+c1vfGQluiUzJbkWHjlcg
	7uj31dT9fDEm9qMZW7tlVwAZSPknxSq7dKKdvlCDuaGTpiGvoRe1GsEfZMgJp66TwwrE1SlQevZ
	N468Vj0GMVu8wxVb9kdefj+w02EulD5G8vdNItslJfQ1CTt17XBWI6ORYpgRzy6PJULfNwGY5Tp
	ap1WOdZHBr5HGxcb7Iwkd5AZOlCRoaOwEMXSw32oP+Oy6fW90qZwQLeBQreI5bigd70dKd2BjiD
	M6iZN6ZfdLArxiNMbgOlZRFPvuy
X-Received: by 2002:a05:6a00:414c:b0:848:4754:28e4 with SMTP id d2e1a72fcca58-8562abbefa2mr18993315b3a.15.1787942288449;
        Fri, 28 Aug 2026 11:38:08 -0700 (PDT)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a2ea6fa3sm844230b3a.37.2026.08.28.11.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 11:38:07 -0700 (PDT)
From: Yin Tirui <yintirui@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	"Liam R . Howlett" <liam@infradead.org>,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	linux-kernel@vger.kernel.org,
	Yin Tirui <yintirui@gmail.com>
Subject: [PATCH RFC 8/9] mm/huge_memory: split present and non-present huge PMDs separately
Date: Sat, 29 Aug 2026 02:33:18 +0800
Message-Id: <46d6e131bcae6f4f2c8716c480aab87750a52c76.1787941780.git.yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1787941780.git.yintirui@gmail.com>
References: <cover.1787941780.git.yintirui@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D63E818000F
X-Stat-Signature: 7hqdkkhoibagtgzaz84odtt1jdfpp5ig
X-Rspam-User: 
X-HE-Tag: 1787942289-245803
X-HE-Meta: U2FsdGVkX18rcihFMvaI0bNf82UBquKEHKGVd0vCaa9FIXFxlX5sAF9eAp+dDByupdQ5pkAfzSEavU+7hZEOTMs8zMfU/epMacUJF7RZhz3RsMJ95hKNGtaTkyPsbkO8xcrUqiFP4xej0yClTBbIbtA86sCJCHOqmjHO4To7ezp+pRDV7GY5NQpUZOzXvzdaPsFJ36JzFBK9nZU5MBdVlIZgB3u/fLjMeJV0WEgTWy2XI7c1vSQyPVhHz5PLzyJL3MSnhWYwnq2OXBeDr1WMIwPZLMWpEXaL0JG+9LwonaFYSZCIjb8tAwqEPlIwyTe4hXkherCczyoEpkQva9Rda5SIIcP5HBwmBxYIwF54INvKe5nh0zcMQfeGWvYguMSN3zqLww/Pn2HjXnm0kCSLEUn7R3FE6FSlsbdmGH4cs7yv4bdIISEFTR8rjpB3iAKqRYIrkA+K7LJFwEPHq/DP30LLnajrC4Ts8FEp6895Rn1e9GEL22480GiG5P7yg+Ty0YklfSwsT2xN8ucy0QgGXlRsBu3EcdS6B1aqQmsh6cA4Be/hbFZ7CQRjzlG69bnEjg1sJeWwDXFs1piXBPrRq23z2TaiZqkHqN2Q3VS4uiiAgVuuQOK9UeziY3tuY8PNYZ6moBU+fr1sevqVKz5aVMZIazPv9ERyF8YHS10YZAFFq6LHliqTE6QTcfG1UCEUXe6X06UGZZWn5OdsAgfm0Cp2GZ11BlryxGYFpUBFTzmbQlA29+Ix1u/YQ9tTNbt5L+NsOWnZKHOpe2Mmk4M53N2S36CB6JA9OevpeVJNTKqTH6+Ckx7oBCbLCyXU17pDBtWtmmLnQrnNyZSc/4af+jP8oPlWOuDkkShrEJyE7ettOFNoOoghPCuxx5qp9UUDaIGaellk4TS616rIwGxKGx0HS+g0dXzCZNrMbLM38cEvCo4gKNfidRcoitF1BRx3ZkIYhjk4zi652YuuweE
 D+2U6rXl
 yiLr8J2dc/Hv/eaSaaxsqOD961McLo5kxXPBfbKV3BPe/fVA8DNRwihykAA0BGno0QxtbIH84l0KvJNAvErMXgVKS/AJx2uLoXR3o4Qz9qAnImYglJzMzOlPsZfkPC2YncnpRBQR+dYlO88Rwg2egk5nS5pGFHwaPxeqv2elGtuI9gGR1D+/NRt+6tFsTv2TCQkKExPZLQzCPXzodnRsdS8z8FbOjigh2L9dsLsco4RaD8F+5DRMxh8lBciDblzyEvCpTqKbzWy8wOOyetAlwWlGf33n6//UV50D1V2PSm4FEKODm2574moyMSYUG2RA3JqyeUzsbw+AsNxx2SgyC/qPq6wTCq0TlBAt7QPkyOjTwS5FeeSram0JYApwBotxthvcLWCl44J0P7CFO8ZEOO1nSqw3C/hgc0sCIjMFfA382g5MgC7EMmPa1x4a5Js+r+XIkHZgCd7JX3VvYCoPnyLZtJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the shared PTE rebuild into split_huge_pmd_to_ptes(), then add
split_present_huge_pmd() and split_non_present_huge_pmd() on top of it to
separate the present and non-present cases in __split_huge_pmd_locked().

No functional change intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Link: https://lore.kernel.org/linux-mm/67a655e3-fa23-4d2a-9685-14e6221d5d26@kernel.org/
Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 334 +++++++++++++++++++++++++----------------------
 1 file changed, 180 insertions(+), 154 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 72e2cd1d7672..fdb751a1e525 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3245,143 +3245,31 @@ static bool split_huge_pmd_anon_rmap(const struct split_pmd_state *state,
 	return false;
 }
 
-static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
-		unsigned long haddr, bool freeze)
+/*
+ * Replace an anonymous huge PMD entry with a page table mapping the same
+ * folio at PTE granularity.
+ */
+static void split_huge_pmd_to_ptes(struct vm_area_struct *vma,
+		unsigned long haddr, pmd_t *pmd, struct split_pmd_state *state)
 {
-	const pmd_t old_pmd = *pmd;
-	const bool is_present = pmd_present(old_pmd);
+	/* Present mappings and device private entries hold a PMD-level rmap. */
+	const bool rmapped = state->is_present || state->is_device_private;
 	struct mm_struct *mm = vma->vm_mm;
-	struct split_pmd_state state = {
-		.is_present = is_present,
-		.freeze = freeze,
-	};
-	struct folio *folio;
+	struct page *page = state->page;
 	unsigned long addr;
 	pgtable_t pgtable;
 	pmd_t _pmd;
 	pte_t *pte;
 	int i;
 
-	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
-	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
-	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-
-	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(old_pmd) &&
-			!pmd_trans_huge(old_pmd));
-
-	count_vm_event(THP_SPLIT_PMD);
+	if (rmapped)
+		state->freeze = split_huge_pmd_anon_rmap(state, vma, haddr);
 
 	/*
-	 * FIXME: Do we want to invalidate secondary mmu by calling
-	 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
-	 * inside __split_huge_pmd() ?
-	 *
-	 * We are going from a zero huge page write protected to zero small
-	 * page also write protected so it does not seems useful to invalidate
-	 * secondary mmu at this time.
-	 */
-	if (huge_zero_pmd_can_split(vma, old_pmd)) {
-		__split_huge_zero_page_pmd(vma, haddr, pmd);
-		return;
-	}
-
-	folio = normal_or_softleaf_folio_pmd(vma, haddr, old_pmd, is_present);
-
-	/*
-	 * A non-present entry which is neither a migration nor a device
-	 * private entry is corrupt, and pmd_to_softleaf_folio() has already
-	 * warned about it. Leave it alone rather than act on a PFN which
-	 * means nothing.
-	 */
-	if (unlikely(!is_present && !folio))
-		return;
-
-	if (!folio || !folio_test_anon(folio)) {
-		unmap_huge_pmd_entry(vma, haddr, pmd, folio, is_present);
-		return;
-	}
-
-	state.folio = folio;
-
-	if (pmd_is_migration_entry(old_pmd)) {
-		const softleaf_t entry = softleaf_from_pmd(old_pmd);
-
-		state.page = softleaf_to_page(entry);
-
-		state.soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		state.uffd = pmd_swp_uffd(old_pmd);
-
-		state.write = softleaf_is_migration_write(entry);
-		state.anon_exclusive =
-			softleaf_is_migration_read_exclusive(entry);
-		state.young = softleaf_is_migration_young(entry);
-		state.dirty = softleaf_is_migration_dirty(entry);
-	} else if (pmd_is_device_private_entry(old_pmd)) {
-		const softleaf_t entry = softleaf_from_pmd(old_pmd);
-
-		state.is_device_private = true;
-		state.page = softleaf_to_page(entry);
-
-		state.soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		state.uffd = pmd_swp_uffd(old_pmd);
-
-		state.write = softleaf_is_device_private_write(entry);
-		state.anon_exclusive = PageAnonExclusive(state.page);
-
-		/*
-		 * Device private folios are treated the same as regular folios
-		 * w.r.t. anon exclusive handling, see
-		 * split_huge_pmd_anon_rmap().
-		 */
-		state.freeze = split_huge_pmd_anon_rmap(&state, vma, haddr);
-	} else {
-		/*
-		 * Up to this point the pmd is present and huge and userland has
-		 * the whole access to the hugepage during the split (which
-		 * happens in place). If we overwrite the pmd with the not-huge
-		 * version pointing to the pte here (which of course we could if
-		 * all CPUs were bug free), userland could trigger a small page
-		 * size TLB miss on the small sized TLB while the hugepage TLB
-		 * entry is still established in the huge TLB. Some CPU doesn't
-		 * like that. See
-		 * http://support.amd.com/TechDocs/41322_10h_Rev_Gd.pdf, Erratum
-		 * 383 on page 105. Intel should be safe but is also warns that
-		 * it's only safe if the permission and cache attributes of the
-		 * two entries loaded in the two TLB is identical (which should
-		 * be the case here). But it is generally safer to never allow
-		 * small and huge TLB entries for the same virtual address to be
-		 * loaded simultaneously. So instead of doing "pmd_populate();
-		 * flush_pmd_tlb_range();" we first mark the current pmd
-		 * notpresent (atomically because here the pmd_trans_huge must
-		 * remain set at all times on the pmd until the split is
-		 * complete for this pmd), then we flush the SMP TLB and finally
-		 * we write the non-huge version of the pmd entry with
-		 * pmd_populate.
-		 *
-		 * This must also happen before PageAnonExclusive() is read
-		 * below, see folio_try_share_anon_rmap_pmd().
-		 */
-		const pmd_t pmdval = pmdp_invalidate(vma, haddr, pmd);
-
-		state.page = pmd_page(pmdval);
-		state.write = pmd_write(pmdval);
-		state.young = pmd_young(pmdval);
-		state.dirty = pmd_dirty(pmdval);
-		state.soft_dirty = pmd_soft_dirty(pmdval);
-		state.uffd = pmd_uffd(pmdval);
-		state.anon_exclusive = PageAnonExclusive(state.page);
-
-		if (state.dirty)
-			folio_set_dirty(folio);
-
-		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
-
-		state.freeze = split_huge_pmd_anon_rmap(&state, vma, haddr);
-	}
-
-	/*
-	 * Withdraw the table only after we mark the pmd entry invalid.
-	 * This's critical for some architectures (Power).
+	 * The caller has already invalidated a present entry, and a softleaf
+	 * entry is not present to begin with. Either way the entry is out of
+	 * service before we withdraw the deposited page table, which is
+	 * critical for some architectures (Power).
 	 */
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
@@ -3393,33 +3281,34 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (state.freeze || (!state.is_present && !state.is_device_private)) {
+	if (state->freeze ||
+	    (!state->is_present && !state->is_device_private)) {
 		pte_t entry;
 		swp_entry_t swp_entry;
 
 		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-			if (state.write)
+			if (state->write)
 				swp_entry = make_writable_migration_entry(
-						page_to_pfn(state.page + i));
-			else if (state.anon_exclusive)
+							page_to_pfn(page + i));
+			else if (state->anon_exclusive)
 				swp_entry = make_readable_exclusive_migration_entry(
-						page_to_pfn(state.page + i));
+							page_to_pfn(page + i));
 			else
 				swp_entry = make_readable_migration_entry(
-						page_to_pfn(state.page + i));
-			if (state.young)
+							page_to_pfn(page + i));
+			if (state->young)
 				swp_entry = make_migration_entry_young(swp_entry);
-			if (state.dirty)
+			if (state->dirty)
 				swp_entry = make_migration_entry_dirty(swp_entry);
 			entry = swp_entry_to_pte(swp_entry);
-			if (state.soft_dirty)
+			if (state->soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
-			if (state.uffd)
+			if (state->uffd)
 				entry = pte_swp_mkuffd(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
-	} else if (state.is_device_private) {
+	} else if (state->is_device_private) {
 		pte_t entry;
 		swp_entry_t swp_entry;
 
@@ -3429,19 +3318,19 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			 * pages corresponding to the pte entries when freeze
 			 * is false.
 			 */
-			if (state.write)
+			if (state->write)
 				swp_entry = make_writable_device_private_entry(
-						page_to_pfn(state.page + i));
+							page_to_pfn(page + i));
 			else
 				swp_entry = make_readable_device_private_entry(
-						page_to_pfn(state.page + i));
+							page_to_pfn(page + i));
 			/*
 			 * Young and dirty bits are not progated via swp_entry
 			 */
 			entry = swp_entry_to_pte(swp_entry);
-			if (state.soft_dirty)
+			if (state->soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
-			if (state.uffd)
+			if (state->uffd)
 				entry = pte_swp_mkuffd(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
@@ -3449,21 +3338,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	} else {
 		pte_t entry;
 
-		entry = mk_pte(state.page, READ_ONCE(vma->vm_page_prot));
-		if (state.write)
+		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
+		if (state->write)
 			entry = pte_mkwrite(entry, vma);
-		if (!state.young)
+		if (!state->young)
 			entry = pte_mkold(entry);
 		/* NOTE: this may set soft-dirty too on some archs */
-		if (state.dirty)
+		if (state->dirty)
 			entry = pte_mkdirty(entry);
-		if (state.soft_dirty)
+		if (state->soft_dirty)
 			entry = pte_mksoft_dirty(entry);
-		if (state.uffd)
+		if (state->uffd)
 			entry = pte_mkuffd(entry);
 
 		/* Restore PAGE_NONE so an RWP marker keeps trapping */
-		if (userfaultfd_rwp(vma) && state.uffd)
+		if (userfaultfd_rwp(vma) && state->uffd)
 			entry = pte_modify(entry, PAGE_NONE);
 
 		for (i = 0; i < HPAGE_PMD_NR; i++)
@@ -3473,15 +3362,152 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (state.is_present || state.is_device_private)
-		folio_remove_rmap_pmd(state.folio, state.page, vma);
-	if (state.freeze)
-		put_page(state.page);
+	if (rmapped)
+		folio_remove_rmap_pmd(state->folio, page, vma);
+	if (state->freeze)
+		put_page(page);
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
 }
 
+static void split_present_huge_pmd(struct vm_area_struct *vma,
+		unsigned long haddr, pmd_t *pmd, struct folio *folio,
+		bool freeze)
+{
+	struct split_pmd_state state = {
+		.folio = folio,
+		.is_present = true,
+		.freeze = freeze,
+	};
+
+	/*
+	 * Up to this point the pmd is present and huge and userland has the
+	 * whole access to the hugepage during the split (which happens in
+	 * place). If we overwrite the pmd with the not-huge version pointing
+	 * to the pte here (which of course we could if all CPUs were bug
+	 * free), userland could trigger a small page size TLB miss on the
+	 * small sized TLB while the hugepage TLB entry is still established in
+	 * the huge TLB. Some CPU doesn't like that. See
+	 * http://support.amd.com/TechDocs/41322_10h_Rev_Gd.pdf, Erratum 383 on
+	 * page 105. Intel should be safe but is also warns that it's only safe
+	 * if the permission and cache attributes of the two entries loaded in
+	 * the two TLB is identical (which should be the case here). But it is
+	 * generally safer to never allow small and huge TLB entries for the
+	 * same virtual address to be loaded simultaneously. So instead of
+	 * doing "pmd_populate(); flush_pmd_tlb_range();" we first mark the
+	 * current pmd notpresent (atomically because here the pmd_trans_huge
+	 * must remain set at all times on the pmd until the split is complete
+	 * for this pmd), then we flush the SMP TLB and finally we write the
+	 * non-huge version of the pmd entry with pmd_populate.
+	 *
+	 * This must also happen before PageAnonExclusive() is read below, see
+	 * folio_try_share_anon_rmap_pmd().
+	 */
+	const pmd_t pmdval = pmdp_invalidate(vma, haddr, pmd);
+
+	state.page = pmd_page(pmdval);
+	state.write = pmd_write(pmdval);
+	state.young = pmd_young(pmdval);
+	state.dirty = pmd_dirty(pmdval);
+	state.soft_dirty = pmd_soft_dirty(pmdval);
+	state.uffd = pmd_uffd(pmdval);
+	state.anon_exclusive = PageAnonExclusive(state.page);
+
+	if (state.dirty)
+		folio_set_dirty(folio);
+
+	VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
+
+	split_huge_pmd_to_ptes(vma, haddr, pmd, &state);
+}
+
+static void split_non_present_huge_pmd(struct vm_area_struct *vma,
+		unsigned long haddr, pmd_t *pmd, pmd_t old_pmd,
+		struct folio *folio, bool freeze)
+{
+	const softleaf_t entry = softleaf_from_pmd(old_pmd);
+	struct split_pmd_state state = {
+		.folio = folio,
+		.page = softleaf_to_page(entry),
+		.is_device_private = softleaf_is_device_private(entry),
+		.freeze = freeze,
+		.soft_dirty = pmd_swp_soft_dirty(old_pmd),
+		.uffd = pmd_swp_uffd(old_pmd),
+	};
+
+	if (state.is_device_private) {
+		/*
+		 * Device private folios are treated the same as regular folios
+		 * w.r.t. anon exclusive handling, see
+		 * split_huge_pmd_anon_rmap().
+		 */
+		state.write = softleaf_is_device_private_write(entry);
+		state.anon_exclusive = PageAnonExclusive(state.page);
+	} else {
+		state.write = softleaf_is_migration_write(entry);
+		state.young = softleaf_is_migration_young(entry);
+		state.dirty = softleaf_is_migration_dirty(entry);
+		state.anon_exclusive =
+			softleaf_is_migration_read_exclusive(entry);
+	}
+
+	split_huge_pmd_to_ptes(vma, haddr, pmd, &state);
+}
+
+static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
+		unsigned long haddr, bool freeze)
+{
+	const pmd_t old_pmd = *pmd;
+	const bool is_present = pmd_present(old_pmd);
+	struct folio *folio;
+
+	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
+	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
+	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
+
+	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(old_pmd) &&
+			!pmd_trans_huge(old_pmd));
+
+	count_vm_event(THP_SPLIT_PMD);
+
+	/*
+	 * FIXME: Do we want to invalidate secondary mmu by calling
+	 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
+	 * inside __split_huge_pmd() ?
+	 *
+	 * We are going from a zero huge page write protected to zero small
+	 * page also write protected so it does not seems useful to invalidate
+	 * secondary mmu at this time.
+	 */
+	if (huge_zero_pmd_can_split(vma, old_pmd)) {
+		__split_huge_zero_page_pmd(vma, haddr, pmd);
+		return;
+	}
+
+	folio = normal_or_softleaf_folio_pmd(vma, haddr, old_pmd, is_present);
+
+	/*
+	 * A non-present entry which is neither a migration nor a device
+	 * private entry is corrupt, and pmd_to_softleaf_folio() has already
+	 * warned about it. Leave it alone rather than act on a PFN which
+	 * means nothing.
+	 */
+	if (unlikely(!is_present && !folio))
+		return;
+
+	if (!folio || !folio_test_anon(folio)) {
+		unmap_huge_pmd_entry(vma, haddr, pmd, folio, is_present);
+		return;
+	}
+
+	if (is_present)
+		split_present_huge_pmd(vma, haddr, pmd, folio, freeze);
+	else
+		split_non_present_huge_pmd(vma, haddr, pmd, old_pmd, folio,
+					   freeze);
+}
+
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze)
 {
-- 
2.34.1



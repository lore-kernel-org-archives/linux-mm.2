Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC2A606A334
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QeKY8DZi
Received: by kanga.kvack.org (Postfix)
	id 359F36B05BB; Tue, 10 Nov 2026 12:59:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A316B05BD; Tue, 10 Nov 2026 12:59:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF8A6B05BB; Tue, 10 Nov 2026 12:59:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E31556B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:59:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AC3A40A57
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:57 +0000 (UTC)
X-FDA: 85419972834.01.8F955EA
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id AB1D040009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:59:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QeKY8DZi;
	spf=pass (imf07.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333595;
	b=XyX9Q9Qhp5Eijr5w1gyikpCDxLZ6vnkVsH3o9ccO1RMcQz0xZxMV9TgeHfbdOGrfOgTBqX
	tz5pGsbG4mNFqvs7MQ9QT63Tz+69YMu5Q21m3SUU3CG75BRxW08XHrP6J/wP+fCZpTXtEL
	e7rAEXjd9nntru4Qq2gtyY52gKF7G4s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QeKY8DZi;
	spf=pass (imf07.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5hDUSqbTuz9LFPhC9eqz5SNXuJ9mfPMxk2F/tftndY=;
	b=TzuVV3L6BJSlXuNYjuROVZMEXIEfoI1f7bhq0xa0E6Rl5e6DrkxOJYZFbThyxSuasR1tBa
	HLVWoV0D4ep22ZrOJTuRA5oJmx/+4cmYeppTTNMF44V8MeGSyFT+qhJxK1xnWMmZV1QyvT
	X7h0e1Hb+SLOWpw+5yTfe7bD24aPSog=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1a3c08d6928so4033907c88.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333594; x=1794938394; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v5hDUSqbTuz9LFPhC9eqz5SNXuJ9mfPMxk2F/tftndY=;
        b=QeKY8DZiStK+u/USbwu6ZLGlDu7tIvknRX6C6Xl7v9kazp75tDUWbLuN3w5u6Dr2vF
         AfauREE0hscDjU4a17nSuaFmLErZtwrmXBhBmY9zhN2kaRy5LZFwetSnqp/d27fD7Z4B
         evyn+V1HeTdSeScW/nTvlOTTPN+QNvNHjeGKmKCRKQridByOCPeWsKwDZRMXAErtoJdq
         vVCg8jyDa9u1xH2xgAxpZrRCmE7Ke+YI6KVdiblDFNv1F53ooHSkbgizhWpFWTu2ImHM
         pq0e+SQGPXTjAn3PkgGGIlpMG8b4XSDMDvI0Dhc99x+xBExWkzStYhHePto3d9uIn3Mz
         QIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333594; x=1794938394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v5hDUSqbTuz9LFPhC9eqz5SNXuJ9mfPMxk2F/tftndY=;
        b=AE/mXLL2pJA7+1e4NY8H2BrLiJZ7LiRslZJt/54zivKlION0u0LDL9Mbm1TX+Td7ee
         uKhk1Z5mCxp9ieBtgth5L/wEF9KOMscrjJC70iwoNi7PC7qkuqz9AOwvHmdH/U7S9u37
         EDTJFHBNY/wqFky5xZbny+Me5bktRFqWJm2rGZtCOhQJbNgfwrRZBx87i71T3Vf5p3QE
         meJJyoauGQc8OjV1IGqSq7EwwwgKV69rWHt7Kd9QYJd1IVa/Q9jI3ixkjlQTRt5H0hj/
         TmlsUNNQamGJ7R53wgzRICTDkwbZLuOjXXxV2pSv+Moyac3LMSAEPdFV6atqunJsr3rl
         t8ew==
X-Forwarded-Encrypted: i=1; AL+hErEoeL48uLWeQteZ7j1kcCBuKWdhbfibECjBqnYBMPxub08jPSUKDyB1Dh/ZsZ1NfJRH4WBaAd/BPg==@kvack.org
X-Gm-Message-State: APuU4Z/baOmMSG7otJqX3XRn3tj+PbopiRRP7w2uYCts/Y6hevL9anxp
	NlR6lGHthEE1+mYt7/FHgzqLyFdcQcXJ+C+h/gaYHeU4J3iVuPiBps1v
X-Gm-Gg: AYBFou2mRWVT5kyaw/8GP4MJEHgQeoLmFza4JdZilFT9PkFpnwF7SbUqbis/qnW9xOu
	VqIjZdbp4uast8sgFpaxZZkumAuhcldmWVqDXZ2MFm33unY4w+QHRjd3j2tEYk/OQGF8U5xYZve
	NO3WBkpEYIZMsQokw6vK218Xq6hKGbKwS5oFuyhBzYbQjomK/VqABon35pZNzZLH2e0ndlaFLr7
	ypdz+pTZkBERHIVGdSZs6q5d62pYfDtlOLWOxDL3socix9MLJ3B46oDyA271heTnPQRTy3V6LLB
	9Iq+maB+eRhpudOagR9C69B/MKTH48oozavSvITZv1Yu1xvrOUQBDWAAomu8LZ2vM/NoWHwyAOw
	hL387Q6UdIp2MPd25YmxBSxrbEdsuQxr6aLUk39NFGuVJ6kbFwojFiA5KQhqEE2mnP74KHTAl1A
	Qua/4n1UctkHGyyDl53qXrHiwcO2oQpBMN3B946tF5xIsfKB0J6CxFM7FFZJnlNFCHbq02bZeBq
	Vb38w10qTnIrTPaqBEYeUjSGNmgNOlGs8oubbeX8sprb7012lNBBCBz5NzjgiXRP+R718PG75gH
	lwG1oQoUlzBXLyTkDItRPVA+0cxEJqAjIjpbrRgmPcJ6+HE2jCJHMq+fTcIi
X-Received: by 2002:a05:701b:4554:20b0:1b2:3448:840f with SMTP id a92af1059eb24-1b3b5fda3camr4660963c88.7.1794333594295;
        Tue, 10 Nov 2026 09:59:54 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.09.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 09:59:53 -0800 (PST)
From: Yin Tirui <yintirui@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com
Cc: ljs@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	ryan.roberts@arm.com,
	nico.pache@linux.dev,
	usama.arif@linux.dev,
	liam@infradead.org,
	kas@kernel.org,
	wangkefeng.wang@huawei.com,
	chenjun102@huawei.com,
	yintirui@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RFC v2 1/9] mm/huge_memory: read the huge PMD entry once when splitting it
Date: Wed, 11 Nov 2026 01:59:16 +0800
Message-Id: <20261110175924.2945538-2-yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110175924.2945538-1-yintirui@gmail.com>
References: <20261110175924.2945538-1-yintirui@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7e6e74qkhg7uhnz5pcxnzws9cgthxifs
X-Rspamd-Queue-Id: AB1D040009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794333595-385150
X-HE-Meta: U2FsdGVkX1+YLDjwEZJ6LvzZc9CLY4wxA/kzpUibIDy7gbJb4mJCMEYCoD2NH+7ZqKjKFfO1mfAuoPWqVt5SDQXB2ne8AXHdBEyM6n0zbRdSsSHVcCSJ1vILPpZ0NaYzDJKRFnKeJijoYOm5ms7rwnNflANRyJfksc8edJwCgKYBVDUglx64Ng88+4K97fW+Zpf0jolYpvP9NFd4ZsVDBlI+MPAzW6mBgJ3NBFrUe2g+ayP+86wrDqL9TIf0uc5BXyHK01vBfOJ8BV2/Uapb8SHquk5gce2cf7sggf1F5KgUJe7nSzsWqq4Fx6YKKSjGqHIh8o4LQWpzyhYCslSOI7E4aPxwqMGQDcRC2bXYrfLj0ln5xQrX5aFtPQCBe2zHfB6Hv1bb8dYMIH6Tche5cOsz82eoAzGn6VUESc5BjSyEnhsLRKF1GQPuOCC09dgWEZ9cTTlPDdCU7iIeXEXAdMfGMQgg/fcl4I0Gg/8j+UGWUQaEFQ6PJTV0IDasG6kCQW80WBvgMLRVco25r31K2CqbJo4bT53DCM498DIICKLPvoDP+RTxbMBgdjH4hzDqtu0b5Mc9kxPIIFmfvVosqRwZaCL7qdDkApACKjcw3mHVu6NEKa/2Q1CFr7ivC0bBox/KuAchN+3kaosxpnTDucyCqNljperwo7hu4kohYCubohWT0rDhkefmzr3o6qmv0DRyychcELekC1Av6zVGpz0YJbb//bM3m2YdDwCPUyGWhPj4X9+PU4CTW/+NvgBXzok2Id+4BpwtCUhRKYFJfHmdd+6ymnqUUjjGF3DJIPlb8/QHn7sSjITYw3nJBROJZVm9CWZ70IKHEG+r2WiE1D7KH+dWWIYhySVglVBVxRmXW8TYV6gnraB5o0EQCoyxsSAre9TWOfj9CG02op3ZDk+nJc/0COgbRCGrV0TSB0ApimcT3/8h4iL6QPUJF8uFwCQW7nrBMNxqSw3j1p7
 nruv+Yn3
 jExsmfJaYpziCc+0qUNqilG4qiVXEVIDFUBjveNqnFctpBLoKLbhY1GQN5finx95Ub1v4c4AN73E/8FCdwlFXApFR48PlO96Lcu7FfN+CgC3j7sNLQQ7aQrezhbGWi9iq0rEulyLHoZR3dAWzCcgL60+DJJl7C1O/tK2CPOILLcpy1ePRnwRztA12wEurP67beRsy6N4Wv6nVtW9tdEprvrqJ1hFpAU2VszUvjaqTQRXHovCZNLdyQdwZPtcpdsSpcKBxw5PcIFBY7cvLlCyRZtKHu0drCvd8IygaF3C2RnFNqUgWe35TC2c+2q8wDJhCXW9mh+sxve21MwlRO8kK4l45q2Si017lssQQPUnNGTcoijorSl816h8GkPPJy4YKbv6+IDC7h9VG2kAets/m0vSSkfQzI1F3k/WnC9zKR4UsmAe7TqtupZwT271aOVWGGeGboMBVwRVLNhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__split_huge_pmd_locked() re-reads *pmd several times to classify the same
entry. The PMD page table lock is held throughout, so read it once into
old_pmd and classify from that.

No functional change intended.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eb913acb03b7..b643e264ca23 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3188,10 +3188,11 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	pmd_t old_pmd = *pmd;
 	struct folio *folio;
 	struct page *page;
 	pgtable_t pgtable;
-	pmd_t old_pmd, _pmd;
+	pmd_t _pmd;
 	bool soft_dirty, uffd_wp = false, young = false, write = false;
 	bool anon_exclusive = false, dirty = false;
 	unsigned long addr;
@@ -3202,7 +3203,8 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
 
-	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(*pmd) && !pmd_trans_huge(*pmd));
+	VM_WARN_ON_ONCE(!pmd_is_valid_softleaf(old_pmd) &&
+			!pmd_trans_huge(old_pmd));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -3238,7 +3240,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
-	if (is_huge_zero_pmd(*pmd)) {
+	if (is_huge_zero_pmd(old_pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
@@ -3251,10 +3253,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
-	if (pmd_is_migration_entry(*pmd)) {
+	if (pmd_is_migration_entry(old_pmd)) {
 		softleaf_t entry;
 
-		old_pmd = *pmd;
 		entry = softleaf_from_pmd(old_pmd);
 		page = softleaf_to_page(entry);
 		folio = page_folio(page);
@@ -3267,10 +3268,9 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			anon_exclusive = softleaf_is_migration_read_exclusive(entry);
 		young = softleaf_is_migration_young(entry);
 		dirty = softleaf_is_migration_dirty(entry);
-	} else if (pmd_is_device_private_entry(*pmd)) {
+	} else if (pmd_is_device_private_entry(old_pmd)) {
 		softleaf_t entry;
 
-		old_pmd = *pmd;
 		entry = softleaf_from_pmd(old_pmd);
 		page = softleaf_to_page(entry);
 		folio = page_folio(page);
@@ -3462,7 +3462,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(*pmd))
+	if (!pmd_is_migration_entry(old_pmd))
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
-- 
2.34.1



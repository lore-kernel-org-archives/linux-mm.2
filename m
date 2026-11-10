Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815D4606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PraCURSf
Received: by kanga.kvack.org (Postfix)
	id 9A4CB6B05C5; Tue, 10 Nov 2026 13:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E736B05C6; Tue, 10 Nov 2026 13:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EED46B05C7; Tue, 10 Nov 2026 13:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51EC86B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:01:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 267FA1C448B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:01:17 +0000 (UTC)
X-FDA: 85419976194.12.D102906
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 38C872001C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:01:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PraCURSf;
	spf=pass (imf03.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBX3osvzrvBpUa9EFYcJneROuN57Xe3Iwp54yQOPd4g=;
	b=KkXP+ie+jb7YFGHL12AJGFQiGlskQNtTkBUABlpxFT59S1mrOtObCYDh6VO+fTY7r+0Rh7
	lJnecb2GnvIxcJ2TSLfAkp/CnXTmjkffuMKmboq8NrBZs+ZTPBaeNbOtpLInpETyhP+qTF
	TuPHnNExYxQc4eSYOCMG3jzkoU0/Cxs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333675;
	b=rWdcSCLaxgdV50AIb/hMqCXdg4KyWLyAVTcsp99wikcdDfM7/DH8/oYDfhmjpUhNJ2IEFv
	ell9lCm7J+1xplSXkuIoRkXQp0vEvtabF4oXCqo9g2aWOYiW/HIwmyc6JkhEubcm/m6X1l
	J7ey7gI0PpPffZA2PUXmPXsYyzVWmcA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PraCURSf;
	spf=pass (imf03.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-15dd124bbe7so3080939c88.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333674; x=1794938474; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pBX3osvzrvBpUa9EFYcJneROuN57Xe3Iwp54yQOPd4g=;
        b=PraCURSfk1/N6OzpwJUS9OedffR1YhiUG2JQ5ZUlmo9w8cIVjN5VHM5hXlngjL8CgA
         RTtkuwUevMSK+Th0a6Avll6MAu6mKo/3KMF6z5YS29nXaXPMWtdfVy8nyfhMvHvRwszj
         kVyKT5lOo6ChvFtrhR+RHF1pEM1i7RRwD5vZj+d8tD8qayQC9u375Vm5mHuTJ9vgn3p2
         TC5f+00f+oiAe4Fjw2oiFJnyHAEZgux7gj48Bma3FswHITqrixOC+Zp/2BZot2bsnoxa
         HYltLfLI7Z01uqFN8eFGzwHH4EiaVLYLJj0Ui0ArTkAvZlXrVYeIBH6vBHkYWscydbmz
         5Qkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333674; x=1794938474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pBX3osvzrvBpUa9EFYcJneROuN57Xe3Iwp54yQOPd4g=;
        b=cHz38UhECO8ec3ADLvUIugKuDqxgdt/ZZtEoLlNkfmMGD3NGmL3HmLq10meyca9L7h
         oRVXqYg2sTvtQ2qbqZhMyOEuXyD+qxEBdHSze/3ohXIoLXSCsnNMFeq//pCrJEtNJc10
         BURD2Jv6X0ueOi/tk0ynRuCsKmFcn51gyxuS3eNy9xbvC3G5YmEDo+pVTzKlZZHFKScf
         mZT9uRJbHfRsrr+QyHl57xCObmTy68jmUp99K6a02eOPdY9ntianN+oI7B8CvQg2Cv1j
         EW8D2z92adwb/9NfkzzpIYs3Y+KmPZzwa/3V5Z0ULEWc0SliD4MAiqFm8M1jtEeVxwBM
         r6iw==
X-Forwarded-Encrypted: i=1; AL+hErFYms0MDZSvgei2VKhTYK2RElLhTzj/q8dzJMYPyoyAURz9wpaGAr3HZe91T/fUE+HtzJNJayNNQw==@kvack.org
X-Gm-Message-State: APuU4Z+Ghk0HV7IRNvPm2EV5ELvVMOTIGMxMivkJit9yA75tQdi1WQAU
	zxNLvHBfE3+C+22fpGNSOPDQvH2bsPl7KsNDNeeT2gTx4yJdt9aAiBby
X-Gm-Gg: AYBFou2eczppu0ewRE/u2UgUmDk/LgC9qP6krOCpObQ9U74QLxq5uLTkv29wuW1MiXG
	qdyvEqgZS5+e6hdOrbRGrQQPE/U/0WibstWUw/UZdX/GUVw4rwbpvIP/c0XxqqolrH3dky9ej4y
	mvGupS8oaP+aZFOmP++lJapX/Ai1BQ3/c25Sf1VX2YJTB8XEdwGeO671GIKuSAafGH0aLyph1L6
	2bKXvUI9P2J1B+pZNiGK1FzSidrHLQA46bdepNxtZYJU0NONPPaCwyJ8HAuimHdjT6nlpCZDiXg
	/Vu/0a/h6xMjVC+56z551fph4DtGXpD+WCdrulQJkFr1nyqmHoVQ1N+H/WdzmXYtI7gkGVIEF2+
	Xe8AnQypH3AIr3nsKGbIGcKxNC/OGOIUIWSAeFFh8q0/7DIyFj38h2l/P3AgmRBpIKMPLfqTLWJ
	LYk+xzjIG/GOANbTIJw+MK3bLmptxwmQr7rj5L8FOtVx4NcAuwq0Vk8IYkoF0V1o4D+eTYz+j3p
	Xy3Q/3Cdpd8RVgcd7g92hRys/gUqqR3C+VZQWfDwuungX8MrXN/QkhlreE1j+fnWs+SNDu1jBlm
	B8ERc0hFUKPhpEZmB3DkSMuZBpjZGkQUrRr4o65QTeIw7FizGewGF6AOdwAbgeMGyLOjK947qw9
	zuyKE
X-Received: by 2002:a05:701b:42c1:10b0:19b:1202:77f8 with SMTP id a92af1059eb24-1b3b61801famr4896533c88.32.1794333673663;
        Tue, 10 Nov 2026 10:01:13 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.10.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:01:13 -0800 (PST)
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
Subject: [PATCH RFC v2 7/9] mm/huge_memory: add struct split_pmd_state
Date: Wed, 11 Nov 2026 01:59:22 +0800
Message-Id: <20261110175924.2945538-8-yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110175924.2945538-1-yintirui@gmail.com>
References: <20261110175924.2945538-1-yintirui@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: eai7ohhpdug49zps5ojoszhfezceh8ma
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 38C872001C
X-Rspam-User: 
X-HE-Tag: 1794333675-65319
X-HE-Meta: U2FsdGVkX1+5yTwdr3jBxk2zhGISx82pW/XVqlKERh1zDRVilgR33/Gz4pKcsYd5VjgbAxiuCS81hCDTcZ+16waSo47IPmfg4+vMXGiEZp9Ludh8I0pOIKDqs2S0Fn5/92TNDWUlo2eA8fkEUKiZRYJsM5+dAPBnArlpx7WMmbwT0M2yx0doTnC9S9fbWBgF1MroEPp564imIMmObWmsaQozanDPOLxJoF2UueE8t/rpSEkujzrM3LPihazv+HlTrFAGxPJtUSmsU8/5pKq+iovQ0bu7v2csDYF0IkRDjWBLO61fR225F4LCjqsAAXYPbooPWL7Jx+w/eAjvV2+i1tBLQWwhxrfNECwWQag40V0GXinTM4rARBgTJJO2n3QzU9rpxRtbA2LSGpe2GdM0oOTZ60rgYLogls+Y6+jNTD1MRBb7TDwsrGHrGUsLfssgmGLaBaXUfWocpGqWWLI6IvEVBSIjGAIpAekxhlVwIOsTwW0XUYPiM+RqmO1JJMWzJlAn1sUWuMN1daaCoGrYy7jfCviQifShJTvXK47+vgxkZ21bQHvbMUY5uiQ2R/9xTAfnG/qhRzRPab/yH438ZJGsR62V0mrnEkrCHLERoe/2EsiznDQwppoyaTCtS59KwK96/2zqzO+Bhu537Nk8RUxY8/GBqH/v6FbKLH7oa24wU1eFxjsEU2cTlLapYINJ2ZASupTkBlqXQwSaAMsApOa5IPftwR2GDIyVe66NpbDtCjELT1eQLBLWURGlfWRnn8igIocijhzYyIaj4dme5ersm9YGbS9BZOhaVeg2hEIPMmIsVY04lwEsjEjdaka29ir+qXQbTokNGIg5L7/hWVzQ9yMWb5QqY5gTYRiQ94HUU34KtiZl3y0hanJgDEfQkH7DA+X+Sme+k1Bq86FAoy/Om4/JlV9z9WTNqZpRf+KyL4OV1hDBbvMaZIfrAoRV2aHfwG0sFksP1TvhA+l
 MT7j3oXW
 IFRrD0QeHqXmoS6tam7R+dWQB+eq+HsWF4YaH5bJGKItTXFVj82KfUxzdKZdZKe9FFdqgQwWwDQbQJhKCYm9zTo8AGaGEKdeteqANabrqu918fZltyBHVkHSJILYEKw/FONT1RikdEHUUDK3EqXfIC5apAKVHbFRbaB5UKUOHJuWEfMfmLWPe1D0TXR7G3xmKqAQi6t/RUzJtpgXiLGw5lcS/AvseeV9+DeNo4kLFDHcdUTqgfNxLcagNmH08+Vfv/OccG8d95xTOgrb4i8mz2cb7fEse9q0vTdv3LLSEmPAxcd2/OH/BfMPtA+g1m6KB0x84QtO+KCigc5GS7CYdu0pa7LmSeOk2Wt3l6yh3h1OvwCQ42IBM8Ct6ZWVa0YPQBYMUQMYkfxMPE/EJ76s8Rx0LHOeu8MycYA2fI4S01BrbS3vs2uWHfiLbEWoZ15bmNE/0QI3Sqvdd19w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Put the state read out of the entry being split into one descriptor, so the
read and write paths can be separated without passing a long argument list
between them.

No functional change intended.

Signed-off-by: Yin Tirui <yintirui@gmail.com>
---
 mm/huge_memory.c | 160 ++++++++++++++++++++++++++---------------------
 1 file changed, 88 insertions(+), 72 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5abcd194bd4d..b179dc26dc8d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3239,6 +3239,20 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
 		folio_put(folio);
 }
 
+struct split_pmd_state {
+	struct folio *folio;
+	struct page *page;
+	bool is_present;
+	bool is_device_private;
+	bool freeze;
+	bool write;
+	bool young;
+	bool dirty;
+	bool soft_dirty;
+	bool uffd;
+	bool anon_exclusive;
+};
+
 /*
  * Convert the folio's PMD-level anonymous rmap into PTE-level ones.
  *
@@ -3258,37 +3272,38 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
  *
  * Returns: whether the mapping may still be frozen.
  */
-static bool split_huge_pmd_anon_rmap(struct folio *folio, struct page *page,
-		struct vm_area_struct *vma, unsigned long haddr, bool freeze,
-		bool anon_exclusive)
+static bool split_huge_pmd_anon_rmap(const struct split_pmd_state *state,
+		struct vm_area_struct *vma, unsigned long haddr)
 {
 	rmap_t rmap_flags = RMAP_NONE;
 
-	if (freeze &&
-	    (!anon_exclusive || !folio_try_share_anon_rmap_pmd(folio, page)))
+	if (state->freeze &&
+	    (!state->anon_exclusive ||
+	     !folio_try_share_anon_rmap_pmd(state->folio, state->page)))
 		return true;
 
-	folio_ref_add(folio, HPAGE_PMD_NR - 1);
-	if (anon_exclusive)
+	folio_ref_add(state->folio, HPAGE_PMD_NR - 1);
+	if (state->anon_exclusive)
 		rmap_flags |= RMAP_EXCLUSIVE;
-	folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR, vma, haddr,
-				 rmap_flags);
+	folio_add_anon_rmap_ptes(state->folio, state->page, HPAGE_PMD_NR, vma,
+				 haddr, rmap_flags);
 	return false;
 }
 
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
-	struct mm_struct *mm = vma->vm_mm;
-	pmd_t old_pmd = *pmd;
+	const pmd_t old_pmd = *pmd;
 	const bool is_present = pmd_present(old_pmd);
+	struct mm_struct *mm = vma->vm_mm;
+	struct split_pmd_state state = {
+		.is_present = is_present,
+		.freeze = freeze,
+	};
 	struct folio *folio;
-	struct page *page;
+	unsigned long addr;
 	pgtable_t pgtable;
 	pmd_t _pmd;
-	bool soft_dirty, uffd_wp = false, young = false, write = false;
-	bool anon_exclusive = false, dirty = false;
-	unsigned long addr;
 	pte_t *pte;
 	int i;
 
@@ -3331,38 +3346,39 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return;
 	}
 
+	state.folio = folio;
+
 	if (pmd_is_migration_entry(old_pmd)) {
-		softleaf_t entry;
+		const softleaf_t entry = softleaf_from_pmd(old_pmd);
 
-		entry = softleaf_from_pmd(old_pmd);
-		page = softleaf_to_page(entry);
+		state.page = softleaf_to_page(entry);
 
-		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd(old_pmd);
+		state.soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		state.uffd = pmd_swp_uffd(old_pmd);
 
-		write = softleaf_is_migration_write(entry);
-		anon_exclusive = softleaf_is_migration_read_exclusive(entry);
-		young = softleaf_is_migration_young(entry);
-		dirty = softleaf_is_migration_dirty(entry);
+		state.write = softleaf_is_migration_write(entry);
+		state.anon_exclusive =
+			softleaf_is_migration_read_exclusive(entry);
+		state.young = softleaf_is_migration_young(entry);
+		state.dirty = softleaf_is_migration_dirty(entry);
 	} else if (pmd_is_device_private_entry(old_pmd)) {
-		softleaf_t entry;
+		const softleaf_t entry = softleaf_from_pmd(old_pmd);
 
-		entry = softleaf_from_pmd(old_pmd);
-		page = softleaf_to_page(entry);
+		state.is_device_private = true;
+		state.page = softleaf_to_page(entry);
 
-		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd(old_pmd);
+		state.soft_dirty = pmd_swp_soft_dirty(old_pmd);
+		state.uffd = pmd_swp_uffd(old_pmd);
 
-		write = softleaf_is_device_private_write(entry);
-		anon_exclusive = PageAnonExclusive(page);
+		state.write = softleaf_is_device_private_write(entry);
+		state.anon_exclusive = PageAnonExclusive(state.page);
 
 		/*
 		 * Device private folios are treated the same as regular folios
 		 * w.r.t. anon exclusive handling, see
 		 * split_huge_pmd_anon_rmap().
 		 */
-		freeze = split_huge_pmd_anon_rmap(folio, page, vma, haddr,
-						  freeze, anon_exclusive);
+		state.freeze = split_huge_pmd_anon_rmap(&state, vma, haddr);
 	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
@@ -3390,22 +3406,22 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 * This must also happen before PageAnonExclusive() is read
 		 * below, see folio_try_share_anon_rmap_pmd().
 		 */
-		old_pmd = pmdp_invalidate(vma, haddr, pmd);
-		page = pmd_page(old_pmd);
-		if (pmd_dirty(old_pmd)) {
-			dirty = true;
+		const pmd_t pmdval = pmdp_invalidate(vma, haddr, pmd);
+
+		state.page = pmd_page(pmdval);
+		state.write = pmd_write(pmdval);
+		state.young = pmd_young(pmdval);
+		state.dirty = pmd_dirty(pmdval);
+		state.soft_dirty = pmd_soft_dirty(pmdval);
+		state.uffd = pmd_uffd(pmdval);
+		state.anon_exclusive = PageAnonExclusive(state.page);
+
+		if (state.dirty)
 			folio_set_dirty(folio);
-		}
-		write = pmd_write(old_pmd);
-		young = pmd_young(old_pmd);
-		soft_dirty = pmd_soft_dirty(old_pmd);
-		uffd_wp = pmd_uffd(old_pmd);
 
 		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
 
-		anon_exclusive = PageAnonExclusive(page);
-		freeze = split_huge_pmd_anon_rmap(folio, page, vma, haddr,
-						  freeze, anon_exclusive);
+		state.freeze = split_huge_pmd_anon_rmap(&state, vma, haddr);
 	}
 
 	/*
@@ -3422,33 +3438,33 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (freeze || pmd_is_migration_entry(old_pmd)) {
+	if (state.freeze || (!state.is_present && !state.is_device_private)) {
 		pte_t entry;
 		swp_entry_t swp_entry;
 
 		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
-			if (write)
+			if (state.write)
 				swp_entry = make_writable_migration_entry(
-							page_to_pfn(page + i));
-			else if (anon_exclusive)
+						page_to_pfn(state.page + i));
+			else if (state.anon_exclusive)
 				swp_entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page + i));
+						page_to_pfn(state.page + i));
 			else
 				swp_entry = make_readable_migration_entry(
-							page_to_pfn(page + i));
-			if (young)
+						page_to_pfn(state.page + i));
+			if (state.young)
 				swp_entry = make_migration_entry_young(swp_entry);
-			if (dirty)
+			if (state.dirty)
 				swp_entry = make_migration_entry_dirty(swp_entry);
 			entry = swp_entry_to_pte(swp_entry);
-			if (soft_dirty)
+			if (state.soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
-			if (uffd_wp)
+			if (state.uffd)
 				entry = pte_swp_mkuffd(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
-	} else if (pmd_is_device_private_entry(old_pmd)) {
+	} else if (state.is_device_private) {
 		pte_t entry;
 		swp_entry_t swp_entry;
 
@@ -3458,19 +3474,19 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			 * pages corresponding to the pte entries when freeze
 			 * is false.
 			 */
-			if (write)
+			if (state.write)
 				swp_entry = make_writable_device_private_entry(
-							page_to_pfn(page + i));
+						page_to_pfn(state.page + i));
 			else
 				swp_entry = make_readable_device_private_entry(
-							page_to_pfn(page + i));
+						page_to_pfn(state.page + i));
 			/*
 			 * Young and dirty bits are not propagated via swp_entry
 			 */
 			entry = swp_entry_to_pte(swp_entry);
-			if (soft_dirty)
+			if (state.soft_dirty)
 				entry = pte_swp_mksoft_dirty(entry);
-			if (uffd_wp)
+			if (state.uffd)
 				entry = pte_swp_mkuffd(entry);
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
@@ -3478,21 +3494,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	} else {
 		pte_t entry;
 
-		entry = mk_pte(page, READ_ONCE(vma->vm_page_prot));
-		if (write)
+		entry = mk_pte(state.page, READ_ONCE(vma->vm_page_prot));
+		if (state.write)
 			entry = pte_mkwrite(entry, vma);
-		if (!young)
+		if (!state.young)
 			entry = pte_mkold(entry);
 		/* NOTE: this may set soft-dirty too on some archs */
-		if (dirty)
+		if (state.dirty)
 			entry = pte_mkdirty(entry);
-		if (soft_dirty)
+		if (state.soft_dirty)
 			entry = pte_mksoft_dirty(entry);
-		if (uffd_wp)
+		if (state.uffd)
 			entry = pte_mkuffd(entry);
 
 		/* Restore PAGE_NONE so an RWP marker keeps trapping */
-		if (userfaultfd_rwp(vma) && uffd_wp)
+		if (userfaultfd_rwp(vma) && state.uffd)
 			entry = pte_modify(entry, PAGE_NONE);
 
 		for (i = 0; i < HPAGE_PMD_NR; i++)
@@ -3502,10 +3518,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_is_migration_entry(old_pmd))
-		folio_remove_rmap_pmd(folio, page, vma);
-	if (freeze)
-		put_page(page);
+	if (state.is_present || state.is_device_private)
+		folio_remove_rmap_pmd(state.folio, state.page, vma);
+	if (state.freeze)
+		put_page(state.page);
 
 	smp_wmb(); /* make pte visible before pmd */
 	pmd_populate(mm, pmd, pgtable);
-- 
2.34.1



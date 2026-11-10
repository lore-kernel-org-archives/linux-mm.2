Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96EFC60A260A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YmYAM52+
Received: by kanga.kvack.org (Postfix)
	id B04D46B05C6; Tue, 10 Nov 2026 13:01:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAED36B05C7; Tue, 10 Nov 2026 13:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9766F6B05C8; Tue, 10 Nov 2026 13:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 694DD6B05C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:01:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E13AE160A22
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:01:33 +0000 (UTC)
X-FDA: 85419976866.12.E568D6D
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id E9CA414000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:01:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YmYAM52+;
	spf=pass (imf23.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ervt3KHoX6weTgmM3kRzwEYGukf7U2iehUJ+wpCaJjA=;
	b=oDuNyEkjogbjfUVaSKYy6TTXuyx+7oiQvzxgQ/ODp5l/E+kNYF0/7gKAOfjaRZN0HdLInZ
	lMaa1J7sxW0+1Z1JFfsi4pAyeufiTMawoHBlNVnYPvkPSHA7IEp9j7nPCUdywLGL5wb/Nm
	GzquIT5w/knEjAUcu6R1paJTLIPKqIE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794333692;
	b=693b27l+fsMmccXJGFUZR7GVCCYfLUsVZ0amIZ5WhbvoC5Cs8KzLzQADseiruhdUksC1Gr
	Qs/V2hiMLTQX6k/0kN6YoEwWnibOlH+y65CxfS3NV0T2Xmv391ojZ0+Rpv8bh4ynsVvKy2
	YCdZ4Q6z+cVMy56L5T8GqH1afCXrSso=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=YmYAM52+;
	spf=pass (imf23.hostedemail.com: domain of yintirui@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=yintirui@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1b3acec6677so3569262c88.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333691; x=1794938491; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ervt3KHoX6weTgmM3kRzwEYGukf7U2iehUJ+wpCaJjA=;
        b=YmYAM52+7I4rbAOC+N2mBL4QL1hb1ezzCWDcgiZf7B35Vt9rnXkVMyTzanLTF6AtXb
         TlSWtri2ZP38FOlKXdLV5lzGDb7bAbitGlipCdeDSARZkGryDBG+AYk0lyvCFR57tzhb
         ytyaFcEx7eC8Q9Ji+0ZBdCVWGaPJ+R65wEWX2RmzKwVfoFZhd3cy2Rs9eFGMFyrbwYjX
         AaDUhjrtHFftBoAjMJd78o09q3TyoRWpAlEg9V/e/uqjct48opW3gCcv6L/Qgxzr3hIx
         ZY9nnfrhT7QXp0/bgPZipTvE3qBstGsQTzZc/vvNYE5g0LUwuJO0Q1LbHmXNGESmTvTC
         XHYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333691; x=1794938491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ervt3KHoX6weTgmM3kRzwEYGukf7U2iehUJ+wpCaJjA=;
        b=pXALgWNlSaDMRrkr8RgF6gomzW/1eHha1Kf12uYporTi22+sk1N35vtq8zYNiRZ5kG
         hwc6O2nV8OnjAfOk5JXdT2EN+Q6oyE2qd2oFSmc0JpGayV694nire0v0f3wB0RrPe34U
         ldjwVvrHGplE2OjM7R65Q+iaCIQJtYAt2nBsQtaoSxO6n4l4Bh6DAOt4LlXKoT8qGmoH
         GIOS7OdZsB1URFDqCDwmKwalq09Hui8R9gGzS10XgL/me0KkoV8c8ddpp8w3odv5/aLW
         j9xtcCXfftb9sEGlxGC8vDKeMIXYkOEB90fpxarQtsvEVomKCxgBfgmULjGcvOXSK7Kp
         tB6Q==
X-Forwarded-Encrypted: i=1; AL+hErE9wJBhobev9/gUEB/NHDGyHzCaJQ6FEO4SxDXELii7qrjR910Z5dGqiiYuRWLeNAKxq0ePinPecA==@kvack.org
X-Gm-Message-State: APuU4Z8d68F21u2Ohgdtn1PfoVuwlpAZ6MDZvrSdjJXwY91SkF+lorwT
	Vuu6j5zoV1/81BUZxglxkd/PK3vN/tYAQYRWPP4AablQ6wAUcK4FlmVn
X-Gm-Gg: AYBFou0I01SOENDDARQP52qnxYLgDzaOhHloZONOtlR2UXwuC3KMt/3gqtaw9SBCPFv
	o0P5fPYGePCpMMGXjZwBNShu0n+ewYoFp39p/0WeEJTMS0uL/vg8GE8rQhb1kjX/fgcYFCEjr/T
	DtOl1JKB2/fgnFukPz2uFecBX/u0qcMPvrKK4gRHiBLIzQbRtRnmmegvxQdXZcvZmklO/acDoR1
	rnOJTWubGeTiegzmzywiTw8pYK63U6FtI5SH5XM7QCxHvUFT5nrFb/xDAck4uFHROHELWYCAFzq
	tNk4qYHSGuIAb86cCpQpxon285YjFmXjfmgdtsBUtSTv0yXNrOXivWgskacJ5WFlFDVDPNEspOg
	OqhHm8hFHvneB8XGxSyeAud3iCrZMlosKooivDxpCcqUMzUDZdfEuGBpeWFQAHzVffonAIdzfh8
	vCI+n5ZAFGRhCF43Sm+DS9E9NR8WGgHM08M5tJRnS2xaedjAtvUdTCINZyqeHKl8dCkN3HOE1EP
	/me0tUeIci5JAIjZu5KHIY9u7JMByATcMn6O7Vov2iq+SG7eO5kMEHqQSCypLsBhsdaE78/PeZl
	WuxLk78x+MZPiT0HNUcUX51gpuncEyMOE6epoI1kY5b0TUwN4G6czxJ1w98=
X-Received: by 2002:a05:7022:1181:b0:188:e51:e86a with SMTP id a92af1059eb24-1b3b5f9e98fmr4130814c88.2.1794333690054;
        Tue, 10 Nov 2026 10:01:30 -0800 (PST)
Received: from aig-kmd-01.. ([120.133.49.20])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5b4b90csm7624260c88.14.2026.11.10.10.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:01:29 -0800 (PST)
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
Subject: [PATCH RFC v2 8/9] mm/huge_memory: split present and non-present huge PMDs separately
Date: Wed, 11 Nov 2026 01:59:23 +0800
Message-Id: <20261110175924.2945538-9-yintirui@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110175924.2945538-1-yintirui@gmail.com>
References: <20261110175924.2945538-1-yintirui@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E9CA414000F
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5jyg5oy15kdnc7wgzourfjc4r5ogbjki
X-Rspam-User: 
X-HE-Tag: 1794333691-63130
X-HE-Meta: U2FsdGVkX18wdPOKcoPetazGxeHXtzBuld5BPM0bWymza09jl40Y8gWNLCfvjpmaqtTI3FjzStfEJpTtBwVYan/oxBEVa6eXGuProl1JoNKkrsh5bO4lQ8h2gOkZXxWkkM1oXhFA57eR+hoA/zQZ7ORzA/I9RDLR8Jt8of76F5Obr1cEGvcsqGHGfTz3eptbPxDbgDa17RJRE6/hH4l0+J5ZH37r1EAG/4vugdvZoT1bbBJen60ktHWDZl2Z7vlCq2Fmx3dG/1QqEIM0OJ3+xX9xegP+T1FCnQk3/+pYNvSNfrWp7M8e61MUgzmjTmEU2xum+W575rF5+cqnuQzLwWzCgQwaeFqJndRQkxsC9LyrmgGDOUj/7OtxNj9p6CjNv5DEJDpKK+D4qTRnU4GrRV4VQA62u83TNRdh01jvthPBhCmoyvXUGlnOdD9LfaqCkHUCkYt7BuxeJazcs7KhH3UlbK3j6JuzoVHiKNICQvme7uS9qsddE8u00xJlO7w+fQxyklEj2kHOr++5KpjB/a5um0JfAt91S4DeB4GS0J0u7/K1dhbJ9tIbBC/qdKWPsVPChjpUep8nBBaoAhhIel+88yeZzFH70vLqQC5+tIGLYGfW4O2wXJ3FQ5POBNIxctBQFb8/9FmRBmjNJFCuMzzQFR1qERISs6Z0YCFkn40Q5/n4jyYZiGLxDOJMUJyGa2nCguKHmDQmbCgzQjJ1DUXHBTbFd/8lkG4BzIecVfXnE/oGNJiH/oKl80+5RGukn109NWvGq7Kk8WDB/yiqw1EbP2vcGPFA/vWEzESR3U9eJoXkhMLPFq07GDTZ/bZ9TxS1ITHff8DKc2/vR8D/lkdAYWJIzsBHdPnHT2d/CoRlqyqG0vg5IC8lgM7CH6uEL7QxxbeuiS81K1zQt09q1M5wvZAosUzfk21QlSlOEzmG70yQ0dXKEgiKxDP5mVnpL3GnT+iPGNPtolvL0hx
 fbuE9cjj
 2Zg+aCQBXpQuk/PO/3C+JvBcfdQrylA91UIg95aD6aEyxENO05IEkmpuCg1x+HPQnXmw0wartVE7Vso6QfdLtc8H9Ra6qPZPPYQNYgIeymMiaIfjMdgscgP61UJXxMdPlI51G1/HBd+s1nOtSUGmWS6KPitmc2zFTR1iLZI4uBkuROT0zvO6abA7q2PhJNAH71pYuISAr9wqlxj8WjXBU1otJeVZX0IM3Vz0hfyZ0wwOv3noLXGJp4kJKR9lE+rds60W4oR5IJsAygarmf3+rprNcE3mk0M/bChaVEXau6xMDQKU45rLZnFzpwE95XOeUqh/Bjuviv/4mXqqwLNgTxf1qYc8HFzA87glbKIDQNPtIcrcmx9Dot/O428H/wG1zuLEUy8sCX+SBE366vIaQKPuHVU16sDb4D1iczZ9vrV95th5VlVN7VP87cZhg1SGU85+f+rEVPyg8+PK2ja9t0iBd7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index b179dc26dc8d..5eaf8a87f1ba 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3290,143 +3290,31 @@ static bool split_huge_pmd_anon_rmap(const struct split_pmd_state *state,
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
@@ -3438,33 +3326,34 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
 
@@ -3474,19 +3363,19 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
 			 * Young and dirty bits are not propagated via swp_entry
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
@@ -3494,21 +3383,21 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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
@@ -3518,15 +3407,152 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
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



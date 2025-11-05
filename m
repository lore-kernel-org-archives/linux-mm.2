Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9822ECCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 17:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4B78E000D; Wed,  5 Nov 2025 12:30:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C398E0002; Wed,  5 Nov 2025 12:30:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA2B38E000D; Wed,  5 Nov 2025 12:30:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA2758E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 12:30:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51AABB75AF
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:30:22 +0000 (UTC)
X-FDA: 84077242284.12.68D6CB0
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 68DFB120018
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 17:30:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mealacgx;
	spf=pass (imf29.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762363820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G/i7MZkNHnwcGwYWKTXHoQSCF+TqXVB+QQ7fHjYAukA=;
	b=gyg1JujsiNDbjycUPxWgLzBjHHBpb5JHkfk9lCbwFUVetmEY7lPKtuv1PkaoNHOBfQR/fY
	UzUus+lgoK6yHooVHpziUXvp/eNep7p/6Spas4jQf94YIzPvEw8PrrVUxNJ/mrXWQHlhGx
	Og5MKQmHTljvGz0tjCL9Ig8iFKe6su8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mealacgx;
	spf=pass (imf29.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762363820; a=rsa-sha256;
	cv=none;
	b=RX9MHlyxFFWhGk5Ejq5lJ1INUwxSHdd7SiX+wi+SXdt4JM3Bn8aVK89krEkQgUO4QaqlAM
	y6aYTugpuQXTAOud4D+VOMLnW/sOVsZD71fmYmAYw1Mh0mguaC/B7NKdAHh0QoIKNu143a
	XnRcFLWXiJHGvlRjY8eErbhxMt/wvFk=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7c284d4867eso1945964a34.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 09:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762363819; x=1762968619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G/i7MZkNHnwcGwYWKTXHoQSCF+TqXVB+QQ7fHjYAukA=;
        b=mealacgxwirftgL52hB1DjgSefMVdWMYK6ysI/U1dgUfG7imfGEy5/MAPYuTLaojxI
         57jEqIxpHHyAnsCi6vdGklneN+OWwNuM4hhUVpw4kchiOXODgDTkQ2hie8hVh8mgsTtS
         ewhK2t5WPbu0GAJbshuYUjdQQE6RGHeIi56EJrg4XTIOUQ6dT2wdvq7gtQ4661VVxNS+
         sSU52GS1t1pt3DuvST58u/yKtYach4j+hzHIzNc9smlcyg+935tHs7sULkwP5tVhd39W
         C5spThLFQfUmlz98eX+vBORCkKlHmhPGracD7QbN9SK/HeIyu+lNTmN6Bk+3GdWa7AA3
         auNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762363819; x=1762968619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G/i7MZkNHnwcGwYWKTXHoQSCF+TqXVB+QQ7fHjYAukA=;
        b=XX3xa5PEG4e74lYduFq0XobUq+o95kcMndQ9mA6QTgjNYJKnNuXtJ8AFaceH6tPNAe
         ZePQWXuDFivwJrwVXRFn04jr9C8yW15eloPhdtvF5nNWUtl+thHemQLjk1qn4crbonfv
         nSQFnDELnZrkQVfBcw4CiKxPCyQq2upG7nExQb0dFImnvWf8FNBCqvCoLx/2Ql8QvcBi
         MpRARePNGZZ80CBGH4G5lnRBcfvCwn1ImWcaVrGYNdtDYyAFEGhv/ycB2ibP6v8t2SQZ
         Pe4Cy7Rwswx2mNh5klG65jNwCBxkj5U6DsxPZKUn1lk8ue+YTRkEjDhXfs5DG9avYhhI
         zztA==
X-Forwarded-Encrypted: i=1; AJvYcCW6h79wrgecEbh0axjitRuKS8sgrtITOyrlfmue1AIhcRP/opR9vuaGbHSQKRP/zkpHk/5bVv4RCg==@kvack.org
X-Gm-Message-State: AOJu0YxLcuJarbpDFXTZNY+JoesN5hylpcjeGB/SeufLCoKGE/UC8riS
	Gzmmxp4/2DDA4gnZVrFxRd+VK8HLqbYkkpX7FdBQz6TmLfw/GYPt25ai
X-Gm-Gg: ASbGncuvIx6LzmoDoLaw9MWOksyUpPtrjjZhFZcJlmSHVxbOVt60wRgiFuPSebtv9Yg
	mQHweRCth+1G4tbV7HBBM60XTj92O3WpCjFHA68mS+Eb8dqcKq1UR5sZ//VY047DiRL/cTkyd5w
	e84gDPpBNtb4DIuAVrSVHa9B7uuh82X/FJLBE1QWAnTO74FMuceK02XqEZurILhfArTRdQ//hFc
	/LD4LHrwm12tLTTQaRg34pxbUKEUo66Cq5eXNMNd/5QiQ+zJDbCJFJKOgoGS8aR5D4VOWBgK+86
	O8ttgcKZEE/h6BRNzbGZvDuGsuOe8ZWnOaD6Ml1FXekcrNT2yA6Hp3MfAdw5SbQlX2NO9GzIekB
	UQXF+KJR3I7FoJhdDEoggcglr+tGEuGuNngGnV5Xp5G36yLvdMsgp1BnMMJInLgIxQUmO/CDMeN
	l8XKLiNmzpYXC7rtBoEPt2lZu7Eq9LQBbkv/8KXOG6muNGm/ockmAFlpaP
X-Google-Smtp-Source: AGHT+IGbfNFoEK9x1jFcWstI6BiHgzpe4FTe/whRBvh9s/FjxTvOCYLIbaIAvuJbi6r52ipnPV3d7Q==
X-Received: by 2002:a05:6830:620c:b0:7c6:8c48:924a with SMTP id 46e09a7af769-7c6d1498595mr2812045a34.25.1762363819369;
        Wed, 05 Nov 2025 09:30:19 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c6c25108b3sm2248313a34.30.2025.11.05.09.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 09:30:18 -0800 (PST)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v3 1/3] Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk"
Date: Wed,  5 Nov 2025 14:27:54 -0300
Message-ID: <20251105172756.167009-2-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251105172756.167009-1-pedrodemargomes@gmail.com>
References: <20251105172756.167009-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 68DFB120018
X-Stat-Signature: sdw7doms55f9j5z14ddziypwq9c7yoys
X-Rspam-User: 
X-HE-Tag: 1762363820-681186
X-HE-Meta: U2FsdGVkX1/gW5oVvJOq5Gd/StcoZ/1fnaCcwwfFpaG34xVurVPb/3gDe9iq2mjyZdIf1gwC1iiQHT32LD1alaSdI0+DXe0uGPc/iENtXyHLT5wmO5HXGBxUSTPvF+uQyaDF+ck6ldYuqSfxdziziQRnUuOySNFMocUQ9s0mIC9Lv3K0FvjkOTO8nst3qzC/knAagfJZ6qHl0WigHwdLTb6MVEunEW9/xj0R9L22BrJ7EPPIJCOdvNSKBhAbPysk8UuOI61sVRKxTsMy65gMPHzeyRaZCB/n1LXPhMyveV7fGwjFGV1EtQdT0RjCi3AmJ1F8d8GzDPVMVTgvERbNz5h8OsUFSqDQa3aI9v8c3ZI/4lwSDJKBkTcYW0segM/2cLlFLCk7g3P2vpEgPI5s8xI5xCw6+eW4NrCCYlgQrb7o/c9qPirGdTn5ojvsjMHmYHpNuaQ+40R0iBWkDtb1GZN0L4oiwWYRHT4baZz7YFQrbzJdkXIWxDU2LFMEBtK2TF7ngFIEi9O+ephNtlty+FTZVnjae9lncRj+FFHuGpl9wHA6whRt5IbOQZ237LY3fQ1Ag6lbL+39kfqOcTYNkXTqmnJbFXZZheEaBb5h7Ej1bZnOsYXaMYsOE+AzeLH8eVjx8IYMtwqv6QTYNFPJ3zgEgDCD6zWxdMvyBXaDk7D1RqYEeTHia2ZpXxfitMXTnJ7r+eru+d5gHWoioNPeUvDTc68gpbeIiITC+nMnL0UzmFGEk8xznbzyoZw4ON5UhjgehpEVre5mQvt+B8SvapmX6wkr0320egedYnYv8FatkdVmnIYW/MRniVWAc5+vaa1wea1F0HBG1+H1hJABQ8pdjtFPAPpk5f93au1CIMcz7sgZA0cvPmeLnGFaDAf1RK0z2MX94Kgz/KXRll9JoI36cIQ3pxx3FThKTluz6QF4qe4PsU618gMTss4jY3N6UiYlrBLEAGfZGAjxApY
 X3dvIPri
 uvm55hk1SQXdteeg3wQjhpST+KVeVZj82SaTAj44TvqNh4R1Gg/3z2ixBXai9Sw3STT3z+rABIq4ge/bLdtTlQZ2T6xG7hZhKCHe0JDs6eyWEr8Ke8Kqnj1QDpQQsJXxWpi+bYL14qnHpcFJj265lK2Tlz2M527BMtuYAckvSWEYv4wmcCnDQkGuRMGe1LDHUvzpjnY4sBs+YN05qeE4NYUeYYNTnHwNMBBJptj919Z5sEUIQezc20SZfSB8Ck4nt+Wh1NBhj1AFqfJGr2tkkg/XfhI63RLNasruixZlGCE+9BUX6eTdObUL5qQ0l+v6YUURm68T7BJ4gwe9iZydzvc7dL0/PplLR9EsYlcFS1c/ijdKxjCtIw4YWK2VFM3IrWf/DCLWEwMNQiIKIeW19lq8PJ94WRsWA1updHzDNQeYvuV7qbOBdi79wVSoIH12dVOL67N1FQvP4euyxZw/LMw3DZMo5p4iWT19aQtH/rQWjznk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit e317a8d8b4f600fc7ec9725e26417030ee594f52 and changes
function break_ksm_pmd_entry() to use folios.

This reverts break_ksm() to use walk_page_range_vma() instead of
folio_walk_start().
Change break_ksm_pmd_entry() to call is_ksm_zero_pte() only if we know
the folio is present, and also rename variable ret to found.
This will make it easier to later modify break_ksm() to perform a proper
range walk.

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 64 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 4f672f4f2140..de10ebcf3509 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -607,6 +607,48 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
+static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+			struct mm_walk *walk)
+{
+	struct folio *folio = NULL;
+	spinlock_t *ptl;
+	pte_t *pte;
+	pte_t ptent;
+	int found;
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
+	ptent = ptep_get(pte);
+	if (pte_present(ptent)) {
+		folio = vm_normal_folio(walk->vma, addr, ptent);
+	} else if (!pte_none(ptent)) {
+		swp_entry_t entry = pte_to_swp_entry(ptent);
+
+		/*
+		 * As KSM pages remain KSM pages until freed, no need to wait
+		 * here for migration to end.
+		 */
+		if (is_migration_entry(entry))
+			folio = pfn_swap_entry_folio(entry);
+	}
+	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+	found = (folio && folio_test_ksm(folio)) || (pte_present(ptent)
+		&& is_ksm_zero_pte(ptent));
+	pte_unmap_unlock(pte, ptl);
+	return found;
+}
+
+static const struct mm_walk_ops break_ksm_ops = {
+	.pmd_entry = break_ksm_pmd_entry,
+	.walk_lock = PGWALK_RDLOCK,
+};
+
+static const struct mm_walk_ops break_ksm_lock_vma_ops = {
+	.pmd_entry = break_ksm_pmd_entry,
+	.walk_lock = PGWALK_WRLOCK,
+};
+
 /*
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
@@ -623,26 +665,16 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
 {
 	vm_fault_t ret = 0;
-
-	if (lock_vma)
-		vma_start_write(vma);
+	const struct mm_walk_ops *ops = lock_vma ?
+				&break_ksm_lock_vma_ops : &break_ksm_ops;
 
 	do {
-		bool ksm_page = false;
-		struct folio_walk fw;
-		struct folio *folio;
+		int ksm_page;
 
 		cond_resched();
-		folio = folio_walk_start(&fw, vma, addr,
-					 FW_MIGRATION | FW_ZEROPAGE);
-		if (folio) {
-			/* Small folio implies FW_LEVEL_PTE. */
-			if (!folio_test_large(folio) &&
-			    (folio_test_ksm(folio) || is_ksm_zero_pte(fw.pte)))
-				ksm_page = true;
-			folio_walk_end(&fw, vma);
-		}
-
+		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
+		if (WARN_ON_ONCE(ksm_page < 0))
+			return ksm_page;
 		if (!ksm_page)
 			return 0;
 		ret = handle_mm_fault(vma, addr,
-- 
2.43.0



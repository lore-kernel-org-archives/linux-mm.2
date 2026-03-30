Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D840710D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:57:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC046B009D; Mon, 30 Mar 2026 07:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C5A6B009E; Mon, 30 Mar 2026 07:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33D666B009F; Mon, 30 Mar 2026 07:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0BF6B009D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:57:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B95B813B329
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:57:00 +0000 (UTC)
X-FDA: 84602578200.12.0FDA19D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 983E0180009
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:56:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Wl0/02Vq";
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOw0QU9Oof9RocPvQ9KEFP3H8j2F9DuWheKeh6hVYYU=;
	b=ZAGlyyOKshbAxIAeQ9OqXHuFRYxmyxVNsaQfeWrTJP/ACPAc2FXob4RxBr4hfkP+9up3lL
	NdPbRNd6IkfG9vKK6oFRFOxghGoNsVimew/Nazh8DiWlkmouvgiVKjz53safnKC3uoVQeJ
	hSA+ubRA3SAJOqkf1I0TFMITdbUJmD8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Wl0/02Vq";
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871818; a=rsa-sha256;
	cv=none;
	b=RmaLUqDswcQoR2R71pMsuMf8IB5F+OUXfMGLA9+duVj/KZUQAl84NOjYl7m/SU+SIV/j2N
	14IKMLqyXPC7PdcqWWdw7VFo+imPLWv0Se0ysxG05vjhDHNKiY5XEroMs57ZBUukq4xcIk
	9xSHal5IZnwXs5LFzY69ykFlov5R7Hs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774871818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOw0QU9Oof9RocPvQ9KEFP3H8j2F9DuWheKeh6hVYYU=;
	b=Wl0/02VqE2K4sNsKWuscmARyikfkHw+sSGAos+4plrKDbP4I/daxEKmRShJwOW3gfuaOXs
	toiylIYcMM1mDUTstTakviFvi/wIcV88L23An+ghR5l4aoYpKWhprXHaIsWYUHumWrROp9
	891xFJmbaQkWdTqmIzDHFkwlscdL56M=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-dhU3LDZBMcatinLSJ0T4GQ-1; Mon, 30 Mar 2026 07:56:56 -0400
X-MC-Unique: dhU3LDZBMcatinLSJ0T4GQ-1
X-Mimecast-MFC-AGG-ID: dhU3LDZBMcatinLSJ0T4GQ_1774871815
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38c22faefe4so15746901fa.2
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:56:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871814; x=1775476614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gOw0QU9Oof9RocPvQ9KEFP3H8j2F9DuWheKeh6hVYYU=;
        b=ReeBDIj7fnO4Fud44eySP+1IoPjwOt23jGreCHKXIoqNuk0ZM1r6g+LhjkZ1aHkVMx
         KIyKVPBsEmW8SiHmQYVFm60jP0T7arZTPcnVrnUlMD/furDAXsOx2Wdp08r0QEixQcjv
         R6pMn/vPAR5R+qVRaT1nc5ovBT0stR83/yjq9s0hoxi3F40dIHCFTwT4m4JBqBpRGd3i
         VEmnYk2m3jfILGfadr8iA1JfsQ+ZFtloBV66Y0z1Yhjwe8V01MgVihJwEemR1/eivlmI
         j6mMsA3zub2I1ZK36ZyuEv9JUtPU92ZROJjdDo/kIUXdYmRLmZSszWuoShGDo9E9VdIf
         gMVw==
X-Gm-Message-State: AOJu0Yz3qWwJXX7HPzrIFLG7vcK0OKcG/GPxN9TvmNI5L8Ww65J7TMZ3
	0BG+SGWe5dMAPn3djxTfw/HqAPQUImRCy8MT55EX8MRvrSI16GUDibgpAEmJ+FugncJSLQV+1fp
	HSeFudCnYBzhQomfJ4jxgOuJKpDIhDX7p4BYftoDJzhtfT8QVeIx8K7OMEoBcMnofcqNVzZMWZC
	PMy2tthAeKq+Y4GAGVs10XwmLvm1hWiqVoNVtRQw==
X-Gm-Gg: ATEYQzxG0cqxBZSwMybhm9GDDEyVKtTuaKIiAClpiQY/eEpMV51mpQPjBpsJF6ne39K
	wb5BypLnYMsVfid4CzZfAI02RHUv9/YDSfICBXMWARWhuTJWzjC42++5zYIU9jgRA9eea+tZW5m
	nYu72E/4Z7Tyrj2wa9dbSAIVYFRJHwDVigJhxPF8Z6sOnG7Pfu1tadbm81YhNPlWPk1dTCDP1nM
	G/Z0LNcGPKd9VfIT0B8HryCvYdUMgpKKzf+DtpJfm4F14KvFup3YQkQ6Xf7wP3SLyRzlaAstMP5
	kl4Y2rtSDdFJn2BFubYOySXBoEKTWDMv2Zn1xRsM/mrBhiHertuOhKFQHNtFKf7S3k1MacDTLZU
	LYINBL+idUrhHCKAOshjOU8arP9yPiM6x+dUE
X-Received: by 2002:a2e:ab0f:0:b0:38c:63a9:7522 with SMTP id 38308e7fff4ca-38c73273b5emr35137661fa.23.1774871814423;
        Mon, 30 Mar 2026 04:56:54 -0700 (PDT)
X-Received: by 2002:a2e:ab0f:0:b0:38c:63a9:7522 with SMTP id 38308e7fff4ca-38c73273b5emr35137371fa.23.1774871813703;
        Mon, 30 Mar 2026 04:56:53 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c838daa4bsm16330071fa.32.2026.03.30.04.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:56:52 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH v7 4/6] mm: setup device page migration in HMM pagewalk
Date: Mon, 30 Mar 2026 14:56:09 +0300
Message-ID: <20260330115611.347988-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260330115611.347988-1-mpenttil@redhat.com>
References: <20260330115611.347988-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 40CmWsmG1JQZSaoxf9-q0gPVQv9cHL64JWmjWQHV4ic_1774871815
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 983E0180009
X-Stat-Signature: 84bgmoif7se751iarfttpyxt19qa33uo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774871818-161793
X-HE-Meta: U2FsdGVkX1+6l02t23ZlZSNXqx4aY3wpJYIWC61FtZYjcozjcPigvApJZ8AEdT9ZUpDUXDOgnUckMSy2DVqoPf+yrESUSzjb7aWj5VCvmrN9fENIMqaVUsWw3rEaZtWq0dtdb8btxmZlpva31HcbUukUN0hz4/M5wMXB6JoX3zs5cqR9eZcbmq2E/kncl7Ma+40vNP1SJnIEdpMlTfUGcG999h/sR9bFzYXkTDMszuraCUy1ZiKIIyP/ICmn+osUFHHRG+fiBmeNiygb+07GHmN9fFJmhhJdEXXA1Cs2nhX3/634szQOpUhvq8MrCIHbDUmoZh8hKq5Je0gvTUK7TuazpwtSuemfDliXjVWKG3DwPdWB3ZM5UxOifx0SN5Uk6/jzRy9RqzAwDM4HR2pzqkQekEl19snrrhfRGPHJO+r/tcuQJ4d3SGeM7iXpJwzs17JznEgKAHZjf0K1joNmadTaGk6U+p6X0hIZOBxlxym2LFj25PVRbqz++qYghdsZBq1Dl39rGQKPow4MYLHc/i8gtrDlsS9EahV0DhlaRgfzyZoqTBMIRpu7rQFiHBfoe9LZ7bQYCNwkPOlqsEZZ6FehTzGR5gPOBOx0ahftzH1dAU7I4TcI7/aolE4jP/694L0GFVKKz3Y9XyEW0Xl/X6vV/JEOSUdhxmNgz6I0V1eDsDb51tJJ5cOjiuFZV7P3JgbvuG+xX4QHDCMoT4gSV/Cy/00Jo1G27ab+W+5dzXRd8XU1NVmthcBWMemjZQyy+xfFHU5sLDUUyStD2GjBSMZDHELpsfV0vNtAm8FXOmGPhpNSB1KSoYwmB8CB39k7BKxg1aIW8b6mzG8TUzoSjX/NoONaOxEiogsIlBf0Oe4Lgq1doX326Se32mDFjzczGdOtfwSlUjXKPR57zChXm9ZxicNL8/fYyh1zq/nuiInliQ9QQK0xDolnTWtdsKzKdUe3M4xs3WaD+ZgE0oO
 t0bG8C/s
 oglJxD6OCPd7XVlOAcchbRlXO+hLj4jhk1rT+lGXbgXFs/plEYxiW+l2VSYCadlf/g7cDm0ziAmfz1X1qbFhYmRb/FVfq/xNDMdRhtm/uAfuE4hJD3RkxWTB+NpwrRz3lVUVS/VGfj27qSHeqE+i3m8/k95woAEyoLUKNFiyPn4tTzZi1ns2cH7ZGVnRhYOecWz+CU8HOQDYVgAe0RYrBsmp3zUnzhCETB72KkwtgLIbQDo/4hOoeo6rNAAfHLtbiuiuSbsyg1q/i1BMhjYS3Ka0jEJpys17P8HhSuqn0SDtxOsD5rVQakGJ6omZamw9H9xnMDxchFidTLgB2PC+f3J27OxXMZUnekmgOL0xffzgLde/faG5pstYbDVQ9EDrmMV+GLhd06PNDXPQQQd7AQ+15aGgQNbGBR+RT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Implement the needed hmm_vma_handle_migrate_prepare_pmd() and
hmm_vma_handle_migrate_prepare() functions which are mostly
carried over from migrate_device.c, as well as the needed
split functions.

Make migrate_device take use of HMM pagewalk for collecting
part of migration.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 include/linux/migrate.h |   9 +-
 mm/hmm.c                | 420 ++++++++++++++++++++++++++++++++++++++--
 mm/migrate_device.c     |  26 ++-
 3 files changed, 438 insertions(+), 17 deletions(-)

diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 07429027960a..64d82bd16d3b 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -164,6 +164,7 @@ enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
 	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
+	MIGRATE_VMA_FAULT = 1 << 4,
 };
 
 struct migrate_vma {
@@ -201,10 +202,14 @@ struct migrate_vma {
 	struct page		*fault_page;
 };
 
-// TODO: enable migration
 static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
 {
-	return 0;
+	enum migrate_vma_info minfo;
+
+	minfo = (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
+		range->migrate->flags : 0;
+
+	return minfo;
 }
 
 int migrate_vma_setup(struct migrate_vma *args);
diff --git a/mm/hmm.c b/mm/hmm.c
index 642593c3505f..ce693938e5dc 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -476,34 +476,424 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
 #ifdef CONFIG_DEVICE_MIGRATION
+/**
+ * migrate_vma_split_folio() - Helper function to split a THP folio
+ * @folio: the folio to split
+ * @fault_page: struct page associated with the fault if any
+ *
+ * Returns 0 on success
+ */
+static int migrate_vma_split_folio(struct folio *folio,
+				   struct page *fault_page)
+{
+	int ret;
+	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
+	struct folio *new_fault_folio = NULL;
+
+	if (folio != fault_folio) {
+		folio_get(folio);
+		folio_lock(folio);
+	}
+
+	ret = split_folio(folio);
+	if (ret) {
+		if (folio != fault_folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		return ret;
+	}
+
+	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
+
+	/*
+	 * Ensure the lock is held on the correct
+	 * folio after the split
+	 */
+	if (!new_fault_folio) {
+		folio_unlock(folio);
+		folio_put(folio);
+	} else if (folio != new_fault_folio) {
+		if (new_fault_folio != fault_folio) {
+			folio_get(new_fault_folio);
+			folio_lock(new_fault_folio);
+		}
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+
+	return 0;
+}
+
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
 					      unsigned long start,
 					      unsigned long end,
 					      unsigned long *hmm_pfn)
 {
-	// TODO: implement migration entry insertion
-	return 0;
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *fault_folio = NULL;
+	struct folio *folio;
+	enum migrate_vma_info minfo;
+	unsigned long i;
+	int r = 0;
+
+	minfo = hmm_select_migrate(range);
+	if (!minfo)
+		return r;
+
+	WARN_ON_ONCE(!migrate);
+	HMM_ASSERT_PMD_LOCKED(hmm_vma_walk, true);
+
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
+	if (pmd_none(*pmdp))
+		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
+
+	if (!(hmm_pfn[0] & HMM_PFN_VALID))
+		goto out;
+
+	if (pmd_trans_huge(*pmdp)) {
+		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
+			goto out;
+
+		folio = pmd_folio(*pmdp);
+		if (is_huge_zero_folio(folio))
+			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
+
+	} else if (!pmd_present(*pmdp)) {
+		const softleaf_t entry = softleaf_from_pmd(*pmdp);
+
+		folio = softleaf_to_folio(entry);
+
+		if (!softleaf_is_device_private(entry))
+			goto out;
+
+		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
+			goto out;
+
+		if (folio->pgmap->owner != migrate->pgmap_owner)
+			goto out;
+
+	} else {
+		hmm_vma_walk->last = start;
+		return -EBUSY;
+	}
+
+	folio_get(folio);
+
+	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
+		folio_put(folio);
+		hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
+		return 0;
+	}
+
+	if (thp_migration_supported() &&
+	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
+	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
+	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
+
+		struct page_vma_mapped_walk pvmw = {
+			.ptl = hmm_vma_walk->ptl,
+			.address = start,
+			.pmd = pmdp,
+			.vma = walk->vma,
+		};
+
+		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
+
+		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
+		if (r) {
+			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
+			r = -ENOENT;  // fallback
+			goto unlock_out;
+		}
+		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
+			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
+
+	} else {
+		r = -ENOENT;  // fallback
+		goto unlock_out;
+	}
+
+
+out:
+	return r;
+
+unlock_out:
+	if (folio != fault_folio)
+		folio_unlock(folio);
+	folio_put(folio);
+	goto out;
 }
 
+/*
+ * Install migration entries if migration requested, either from fault
+ * or migrate paths.
+ *
+ */
 static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 					  pmd_t *pmdp,
-					  pte_t *pte,
+					  pte_t *ptep,
 					  unsigned long addr,
-					  unsigned long *hmm_pfn)
+					  unsigned long *hmm_pfn,
+					  bool *unmapped)
 {
-	// TODO: implement migration entry insertion
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct mm_struct *mm = walk->vma->vm_mm;
+	struct folio *fault_folio = NULL;
+	enum migrate_vma_info minfo;
+	struct dev_pagemap *pgmap;
+	bool anon_exclusive;
+	struct folio *folio;
+	unsigned long pfn;
+	struct page *page;
+	softleaf_t entry;
+	pte_t pte, swp_pte;
+	bool writable = false;
+
+	// Do we want to migrate at all?
+	minfo = hmm_select_migrate(range);
+	if (!minfo)
+		return 0;
+
+	WARN_ON_ONCE(!migrate);
+	HMM_ASSERT_PTE_LOCKED(hmm_vma_walk, true);
+
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
+	pte = ptep_get(ptep);
+
+	if (pte_none(pte)) {
+		// migrate without faulting case
+		if (vma_is_anonymous(walk->vma)) {
+			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
+			*hmm_pfn |= HMM_PFN_MIGRATE;
+			goto out;
+		}
+	}
+
+	if (!(hmm_pfn[0] & HMM_PFN_VALID))
+		goto out;
+
+	if (!pte_present(pte)) {
+		/*
+		 * Only care about unaddressable device page special
+		 * page table entry. Other special swap entries are not
+		 * migratable, and we ignore regular swapped page.
+		 */
+		entry = softleaf_from_pte(pte);
+		if (!softleaf_is_device_private(entry))
+			goto out;
+
+		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
+			goto out;
+
+		page = softleaf_to_page(entry);
+		folio = page_folio(page);
+		if (folio->pgmap->owner != migrate->pgmap_owner)
+			goto out;
+
+		if (folio_test_large(folio)) {
+			int ret;
+
+			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+			hmm_vma_walk->ptelocked = false;
+			ret = migrate_vma_split_folio(folio,
+						      migrate->fault_page);
+			if (ret)
+				goto out_error;
+			return -EAGAIN;
+		}
+
+		pfn = page_to_pfn(page);
+		if (softleaf_is_device_private_write(entry))
+			writable = true;
+	} else {
+		pfn = pte_pfn(pte);
+		if (is_zero_pfn(pfn) &&
+		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			*hmm_pfn = HMM_PFN_MIGRATE;
+			goto out;
+		}
+		page = vm_normal_page(walk->vma, addr, pte);
+		if (page && !is_zone_device_page(page) &&
+		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			goto out;
+		} else if (page && is_device_coherent_page(page)) {
+			pgmap = page_pgmap(page);
+
+			if (!(minfo &
+			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
+			    pgmap->owner != migrate->pgmap_owner)
+				goto out;
+		}
+
+		folio = page ? page_folio(page) : NULL;
+		if (folio && folio_test_large(folio)) {
+			int ret;
+
+			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+			hmm_vma_walk->ptelocked = false;
+
+			ret = migrate_vma_split_folio(folio,
+						      migrate->fault_page);
+			if (ret)
+				goto out_error;
+			return -EAGAIN;
+		}
+
+		writable = pte_write(pte);
+	}
+
+	if (!page || !page->mapping)
+		goto out;
+
+	/*
+	 * By getting a reference on the folio we pin it and that blocks
+	 * any kind of migration. Side effect is that it "freezes" the
+	 * pte.
+	 *
+	 * We drop this reference after isolating the folio from the lru
+	 * for non device folio (device folio are not on the lru and thus
+	 * can't be dropped from it).
+	 */
+	folio = page_folio(page);
+	folio_get(folio);
+
+	/*
+	 * We rely on folio_trylock() to avoid deadlock between
+	 * concurrent migrations where each is waiting on the others
+	 * folio lock. If we can't immediately lock the folio we fail this
+	 * migration as it is only best effort anyway.
+	 *
+	 * If we can lock the folio it's safe to set up a migration entry
+	 * now. In the common case where the folio is mapped once in a
+	 * single process setting up the migration entry now is an
+	 * optimisation to avoid walking the rmap later with
+	 * try_to_migrate().
+	 */
+
+	if (fault_folio == folio || folio_trylock(folio)) {
+		anon_exclusive = folio_test_anon(folio) &&
+			PageAnonExclusive(page);
+
+		flush_cache_page(walk->vma, addr, pfn);
+
+		if (anon_exclusive) {
+			pte = ptep_clear_flush(walk->vma, addr, ptep);
+
+			if (folio_try_share_anon_rmap_pte(folio, page)) {
+				set_pte_at(mm, addr, ptep, pte);
+				folio_unlock(folio);
+				folio_put(folio);
+				goto out;
+			}
+		} else {
+			pte = ptep_get_and_clear(mm, addr, ptep);
+		}
+
+		if (pte_dirty(pte))
+			folio_mark_dirty(folio);
+
+		/* Setup special migration page table entry */
+		if (writable)
+			entry = make_writable_migration_entry(pfn);
+		else if (anon_exclusive)
+			entry = make_readable_exclusive_migration_entry(pfn);
+		else
+			entry = make_readable_migration_entry(pfn);
+
+		if (pte_present(pte)) {
+			if (pte_young(pte))
+				entry = make_migration_entry_young(entry);
+			if (pte_dirty(pte))
+				entry = make_migration_entry_dirty(entry);
+		}
+
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_present(pte)) {
+			if (pte_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (pte_uffd_wp(pte))
+				swp_pte = pte_swp_mkuffd_wp(swp_pte);
+		} else {
+			if (pte_swp_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (pte_swp_uffd_wp(pte))
+				swp_pte = pte_swp_mkuffd_wp(swp_pte);
+		}
+
+		set_pte_at(mm, addr, ptep, swp_pte);
+		folio_remove_rmap_pte(folio, page, walk->vma);
+		folio_put(folio);
+		*hmm_pfn |= HMM_PFN_MIGRATE;
+
+		if (pte_present(pte))
+			*unmapped = true;
+	} else
+		folio_put(folio);
+out:
 	return 0;
+out_error:
+	return -EFAULT;
 }
 
 static int hmm_vma_walk_split(pmd_t *pmdp,
 			      unsigned long addr,
 			      struct mm_walk *walk)
 {
-	// TODO : implement split
-	return 0;
-}
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *folio, *fault_folio;
+	spinlock_t *ptl;
+	int ret = 0;
 
+	HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+
+	fault_folio = (migrate && migrate->fault_page) ?
+		page_folio(migrate->fault_page) : NULL;
+
+	ptl = pmd_lock(walk->mm, pmdp);
+	if (unlikely(!pmd_trans_huge(*pmdp))) {
+		spin_unlock(ptl);
+		goto out;
+	}
+
+	folio = pmd_folio(*pmdp);
+	if (is_huge_zero_folio(folio)) {
+		spin_unlock(ptl);
+		split_huge_pmd(walk->vma, pmdp, addr);
+	} else {
+		folio_get(folio);
+		spin_unlock(ptl);
+
+		if (folio != fault_folio) {
+			if (unlikely(!folio_trylock(folio))) {
+				folio_put(folio);
+				ret = -EBUSY;
+				goto out;
+			}
+		}  else
+			folio_put(folio);
+
+		ret = split_folio(folio);
+		if (fault_folio != folio) {
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+
+	}
+out:
+	return ret;
+}
 #else
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
@@ -518,7 +908,8 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 					  pmd_t *pmdp,
 					  pte_t *pte,
 					  unsigned long addr,
-					  unsigned long *hmm_pfn)
+					  unsigned long *hmm_pfn,
+					  bool *unmapped)
 {
 	return 0;
 }
@@ -573,6 +964,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	enum migrate_vma_info minfo;
 	unsigned long addr = start;
 	unsigned long *hmm_pfns;
+	bool unmapped = false;
 	unsigned long i;
 	pte_t *ptep;
 	pmd_t pmd;
@@ -654,7 +1046,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 					goto again;
 			}
 
-			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
+			r = hmm_vma_handle_pmd(walk, start, end, hmm_pfns, pmd);
 
 			// If not migrating we are done
 			if (r || !minfo) {
@@ -723,9 +1115,13 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			return r;
 		}
 
-		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns);
+		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns, &unmapped);
 		if (r == -EAGAIN) {
 			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
+			if (unmapped) {
+				flush_tlb_range(walk->vma, start, addr);
+				unmapped = false;
+			}
 			goto again;
 		}
 		if (r) {
@@ -733,6 +1129,8 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			break;
 		}
 	}
+	if (unmapped)
+		flush_tlb_range(walk->vma, start, addr);
 
 	if (hmm_vma_walk->ptelocked) {
 		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index a4062fd21490..7ca5dc80d39b 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -734,7 +734,17 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	int ret;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
+	struct hmm_range range = {
+		.notifier = NULL,
+		.start = args->start,
+		.end = args->end,
+		.hmm_pfns = args->src,
+		.dev_private_owner = args->pgmap_owner,
+		.migrate = args,
+		.default_flags = HMM_PFN_REQ_MIGRATE
+	};
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
@@ -759,17 +769,25 @@ int migrate_vma_setup(struct migrate_vma *args)
 	args->cpages = 0;
 	args->npages = 0;
 
-	migrate_vma_collect(args);
+	if (args->flags & MIGRATE_VMA_FAULT)
+		range.default_flags |= HMM_PFN_REQ_FAULT;
+
+	ret = hmm_range_fault(&range);
 
-	if (args->cpages)
-		migrate_vma_unmap(args);
+	migrate_hmm_range_setup(&range);
+
+	/* Remove migration PTEs */
+	if (ret) {
+		migrate_vma_pages(args);
+		migrate_vma_finalize(args);
+	}
 
 	/*
 	 * At this point pages are locked and unmapped, and thus they have
 	 * stable content and can safely be copied to destination memory that
 	 * is allocated by the drivers.
 	 */
-	return 0;
+	return ret;
 
 }
 EXPORT_SYMBOL(migrate_vma_setup);
-- 
2.50.0



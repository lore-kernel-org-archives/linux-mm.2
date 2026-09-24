Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45359C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78B296B009D; Thu, 24 Sep 2026 02:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715096B009E; Thu, 24 Sep 2026 02:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 603E06B009F; Thu, 24 Sep 2026 02:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2656B009D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:53:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F69E80267
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:54 +0000 (UTC)
X-FDA: 85247740788.16.5C09554
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5FA7C80002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LtOYRA/c";
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKufge1uGAYO+MtJk2WzsKER/XWhb707zmmEu/uQZ4Q=;
	b=kRk/SkoFpe0ZtSYL/NCBfcS83cuGXBslP1wkDTKDdZjX5rfRhJWuTvnxMVK9NeUA3n/FBK
	VyWReSHXRTKlAa4YJ4/3otPcdVRHebWtOYRxaU0ZpN1XQ70TzOhXVY/0Ne4Xo0njLFcFlt
	dn47KnXpOgMUY871guLweUezegcImaQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LtOYRA/c";
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232832;
	b=zlAfAWJTnLrji/7G4hlSPZ+ZtsLm+O5YTOnkGeXy+yGA6/TE6uNJh79teFEeNxf8GW3U5P
	e3FAnQ5Y3FlqeL+dRb42yehFOOyrLIvjAUMnf3AKXuWPB2ppju2e6q8Uq07awLpUgUL7/e
	Wz3LJx6vPPrtuCOpyQ7GZ7ElrMZWkB0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sKufge1uGAYO+MtJk2WzsKER/XWhb707zmmEu/uQZ4Q=;
	b=LtOYRA/cC6ac6vuo5MVaw4avQXg154tpb35+411NPIa6i0AhUB/OwJNOMpVLLTW9OjynAl
	da0bKBUky5Nu0FRhfpZffTQUkL9IwIWrrhjbSIDMNAWdeeOulv91RHdRcfvjvdccaP3cth
	TsWW7n+Djh8VmuZrEzDbn2ezLzDSp+Y=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-vbjD30PENj6pVYk5zCPz_Q-1; Thu, 24 Sep 2026 02:53:50 -0400
X-MC-Unique: vbjD30PENj6pVYk5zCPz_Q-1
X-Mimecast-MFC-AGG-ID: vbjD30PENj6pVYk5zCPz_Q_1790232829
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3a49a0a32caso7879371fa.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:53:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232829; x=1790837629;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sKufge1uGAYO+MtJk2WzsKER/XWhb707zmmEu/uQZ4Q=;
        b=RZ19LRLyJZtX5IKiwGqUjjabSUBEzcs/ZVyl5laW/lZuedtByakst7WysEwBMZX5Qa
         2U8W8poyTrKRNQU6Bq2QMNwlHvtJcbC/fEPceUp8OYDYEGXC/ok3uJXbAwHMcDbRQTWo
         0MKsU4t8SsnkzBMJTGPJap2rqLxuyIhl7rnfBlKcK+mhv+Sc3dULVQM2z+XxvvucYoDZ
         TmNzemtqD2nA6tCcH649vqCIoPrD1ES5bMDrw+aJYGscwn0zz6AimKHPO+Wu35rzIFCg
         g00AsNIh4/Z4cT8SccBvYm3MPkYk7NB+o2LlXDTWaeV2v7hnIzBZlO9sDox47Za9kHyx
         vE0Q==
X-Gm-Message-State: AFuF++kdRfDVTw7rkMu0Hr6OTQUXCsMIEOfVCecdc1RmxtglbN7l2lc7
	X2JsgBl4OPfOhzSa7/FT/Wmg7G5lYZy8mRG/hftWiN2Hece+3/PvmcDH5i95i2rOlSQln7E9pVe
	0AevXEs/Oh8QCG3jILUR27nd9jdKFVhi/71bn/EvbxyR3di1ZpJxnoX35ANgTKQY9h4L/7DOJjE
	ydVhsXENHeZVcpnDMkctSPrtDc0HbbfBnq0FDXXQ==
X-Gm-Gg: AYBFou2r01d0B4LxaPz1A3KMLNALHsPF+W2jkvpP/ub8YxlfQpuMZtuSHm8m2f2H1yD
	Nor1FlZ89wr6ukhM8pE+a2/pws8pNhjEfsrOGRs51wxRhoNDG3D9si1Ocu51FP03hOtCvy2PMH+
	In5iD1csTFFkd6WX/5PB0Sp/uXVvKb+VdFs9fAVEuCC3ET89fZp43IY75aBVZTbyk/UDL57NFJO
	sls267p0S/3qe87rAjyBHuW/bdvRtIoJpik5BJSzAlM36ipvW6nkwCfCTvWycEb0H9Jv99S73Ha
	JVwg13isVw414SJmmE9bYmRJE/xhi4CvvuTZTD9sV4v3Do1aLHEeFLAClvFlnQsTkHn9Hq8Y7nS
	x1exCqhhtjR+MlcCpYULA
X-Received: by 2002:a2e:a58e:0:b0:3a5:d070:9ffd with SMTP id 38308e7fff4ca-3a63bf294a6mr3893451fa.2.1790232828766;
        Wed, 23 Sep 2026 23:53:48 -0700 (PDT)
X-Received: by 2002:a2e:a58e:0:b0:3a5:d070:9ffd with SMTP id 38308e7fff4ca-3a63bf294a6mr3893181fa.2.1790232828134;
        Wed, 23 Sep 2026 23:53:48 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:53:47 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v15 05/11] mm/hmm: migrate collection in HMM pagewalk - pte level
Date: Thu, 24 Sep 2026 09:53:07 +0300
Message-ID: <20260924065313.899730-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FXJzKVnUIqymJ_8ihdlJE-QnQN4a9NL7H563Xx9LTaI_1790232829
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FA7C80002
X-Stat-Signature: 5wng3tyggxjf9ctf7ca3wu8rbr6bj6on
X-Rspam-User: 
X-HE-Tag: 1790232832-377905
X-HE-Meta: U2FsdGVkX1/w7T2dXUemgwvPvFc2JJL3U4wJou8v+Wew4bUt3qf7klyFt3GJRoIQyF1pFFMl5z4SdMoVP/uzlJYNOdeeFoI1E27WVC2HBeCRlWycolb46THMDTkrIx2BQQsN+k87vpuWYu5edApD81b4tR/dtjwkjOmEHyPxtNlUJPedhYSlFogTAMQIZoV+g3rRysTSy7xjXgu5GJz9+CeQci1CRmtOYIuLBeY0H7N84nt0+ztxM8sRTdzAj7V62z9qSBbqGZNuQCcU8tMM6VcuYPKtRDp0JliGST4rJld0m8sSS/1wQyVIgfslURtxRwcZfv4/PcdIUWLxoi9H+/9XKMQEGXIitQuEZh8vjGaf56kuh7DIygdVJjZF2WSmSh4KpGE+UePTDyIzOrE1KNBIe4p/FKij1/wOwfLUTF70hQJNR8kGRdy04h/YrHPq5lIRCF3BnI3BQ37a5cS+FbrY+1QIQJda63k/cQneVePIf5xASDGgA4qDo8zG8gIQMxNFC9McspuFWdPy5YCJKX5v2QWhd91gYz9rjXVIeNvnbbKEcYwGTotL9ZBRqwfJSWvlrLwwwcF42O5jPIrEkCdD0lM/rxlpol1rf2e7hHR8KcbT9fFB7xULnjafjlqhnrISrIeSBTBY95RkKMjyHrWkb/Trkmod+wmi0VVWylvmxuXy+nI9cO6dqT9v065dcROlMTFHtXAjmMOtjimHarpcrJXt4G/cyt/F+uTQxDj3somdUPUxTIMbnH4jEQ7C5ot+Nzrans55b4E9zo/NBEZPaFl+9kgmc+mVCr9VdWLpgP0t5DQUwvf00fvLQKVStuB6GyKGudIc1iUssRJUiWEVahBKOg7yjZiPrKNAzMXE8YqgbS7GQ3VzFTvNU6oU9eQRRhsf6eUoOyn1656TQU7M0e7QYU5EUuQFzWmSPzuyTpvIOlDUOhNn8cdnmBxC0Hq1iMQaITMW6FGBVM1
 sVKO629H
 RNCZyyZyrpXptU6JPCKOv47Ac41DmHaYZXv8R7fWJFXnma8FWnDPBQaM2lo+3O9U0Z4LedyGCv8bnAqOM/ugg0aqAn3+tkdiZ//RuGMEfXl8vSjGsS0joCvtDACNlmqXkX1jJPM6rgooczivG0SJBEs5y2B85IF7U8gkuFFKmDtAOoU4lT1QXSuQbuUZQtf8azZnkCHHnPcx3nYEhnkhXXnwBFhGDttJdJ3TO4kL4UNqXwixa9cmiu7MfVotCrtH86VXJgasxsepngZ3pTIaEVb950sjJDcaKS4CdyV/xTwjhhhLdc05R9jDIq+S4wVO9MfyS84asJP/5Q5WM4S9dSns9KnDhKdhiI7AbARwLqELi5amfn3DFElI3ZeKzH43Q4WN46LnKDNk73LEUEfJurPfaFS6piOEHnHJxwyhw7K/gGAivNC1UPGu9tTxMSXYPtNndh3FqQvypHV3dlpJ0ZhWZ76xrnuTlJFLd16qYlKpu4U5McqF63bEijA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Implement the needed hmm_vma_handle_migrate_prepare() function
which is mostly carried over from migrate_device.c's
migrate_vma_collect_pmd() function.

Also implement the migrate_vma_split_folio(), for splitting
pte mapped large folios. It is also mostly from migrate_device.c,
with care taken to reference folio before relasing page table
lock.

With HMM pagewalk based migration, the idea is that
hmm_vma_handle_*() are responsible for faulting,
and the pfn collecting part. hmm_vma_handle_migrate_prepare*()
do the migration decisions (with HMM_PFN_MIGRATE), possibly split
folios, and insert migration ptes/pmds.

HMM pagewalk based migration is enabled in later commit, for now
now hmm_select_migrate() returns 0.

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
 mm/hmm.c | 263 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 262 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 25f537c87b5f..a60b66963049 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -491,6 +491,63 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
 
 #ifdef CONFIG_DEVICE_MIGRATION
+/**
+ * migrate_vma_split_folio() - Helper function to split a THP folio
+ * @folio: the folio to split
+ * @fault_page: struct page associated with the fault if any
+ * @hmm_vma_walk: walk in progress
+ * @ptep: pte_t * for unmap and unlock ptl
+ *
+ * Returns 0 on success
+ */
+static int migrate_vma_split_folio(struct folio *folio,
+				   struct page *fault_page,
+				   struct hmm_vma_walk *hmm_vma_walk,
+				   pte_t *ptep)
+{
+	int ret;
+	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
+	struct folio *new_fault_folio = NULL;
+
+	if (folio != fault_folio)
+		folio_get(folio);
+
+	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
+	hmm_vma_walk->ptelocked = false;
+
+	if (folio != fault_folio)
+		folio_lock(folio);
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
@@ -501,6 +558,11 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 	return 0;
 }
 
+/*
+ * Install migration entries if migration requested, either from fault
+ * or migrate paths.
+ *
+ */
 static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 					  pmd_t *pmdp,
 					  pte_t *ptep,
@@ -508,8 +570,207 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 					  unsigned long *hmm_pfn,
 					  bool *unmapped)
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
+			ret = migrate_vma_split_folio(folio,
+						      migrate->fault_page,
+						      hmm_vma_walk,
+						      ptep);
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
+			ret = migrate_vma_split_folio(folio,
+						      migrate->fault_page,
+						      hmm_vma_walk,
+						      ptep);
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
+		if (pte_present(pte))
+			flush_cache_page(walk->vma, addr, pfn);
+
+		if (anon_exclusive) {
+			pte = ptep_clear_flush(walk->vma, addr, ptep);
+
+			if (folio_try_share_anon_rmap_pte(folio, page)) {
+				set_pte_at(mm, addr, ptep, pte);
+				if (fault_folio != folio)
+					folio_unlock(folio);
+				folio_put(folio);
+				goto out;
+			}
+		} else {
+			pte = ptep_get_and_clear(mm, addr, ptep);
+		}
+
+		if (pte_present(pte) && pte_dirty(pte))
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
+			if (pte_uffd(pte))
+				swp_pte = pte_swp_mkuffd(swp_pte);
+		} else {
+			if (pte_swp_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (pte_swp_uffd(pte))
+				swp_pte = pte_swp_mkuffd(swp_pte);
+		}
+
+		set_pte_at(mm, addr, ptep, swp_pte);
+		folio_remove_rmap_pte(folio, page, walk->vma);
+		folio_put(folio);
+		*hmm_pfn |= HMM_PFN_MIGRATE;
+		if (pte_present(pte))
+			*unmapped = true;
+	} else {
+		folio_put(folio);
+	}
+out:
 	return 0;
+out_error:
+	return -EFAULT;
 }
 
 #else
-- 
2.55.0



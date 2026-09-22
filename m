Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33FD6C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678456B00AB; Tue, 22 Sep 2026 01:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 628FC6B00AC; Tue, 22 Sep 2026 01:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0F46B00AD; Tue, 22 Sep 2026 01:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17D8F6B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:35:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A3131C2166
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:03 +0000 (UTC)
X-FDA: 85240284486.04.8E8495A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5DE73A0007
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zb9Az9dY;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OVe9F9UnqicBMpqnz2rAf3G6pQga7qmnVnonC4zTIr8=;
	b=IEtFdLtQqoY594pT9/YJgKDV84IB/IGkZmem5FOV0W1VqEcSbGQa833+F+ZUTxO1sKGu+C
	51fEdWDGdcRsbfEpe8VhfYjbEGtaLi3SKNZFEpoIrP0jEQ1Q4/iZqeZWZHMVazF8xnGZ72
	WxczFofCrnkFHJhBQbzpdqUyt3zEVzo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055301;
	b=s4EZN7wwjVyUmhRU6mIInZ1uIidMo30+1Xmwd0hfPIvNeBDopBu/umzZfDXdJ5uFpNn5HS
	gpGx21osmtL22J0pBMEAkZ7zecd8JBzcdL1NqUGj8IKyz2vYh5BSqle2s6twCA9AmouEG5
	HUCZ9K+3L5gy7Kk2uGmJtOTK3cR6X+E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zb9Az9dY;
	spf=pass (imf15.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OVe9F9UnqicBMpqnz2rAf3G6pQga7qmnVnonC4zTIr8=;
	b=Zb9Az9dY3swZEZQ/31UW2k5RBfNs56Dlas7yzhSDLs30jWdNOfeQDCtm32UtsEoQj+q1ms
	qKTlH1+baoO75yr9pCzdKNayC0qFOZgBgyDw/yHjEjPAiCBhrHJx1CYJKgKXABraunIQ9e
	sO+yslki8c3Qc9p+NvXJaEjLwF1RpHw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-FqD_7p_jOcSGb6ZH__jctg-1; Tue, 22 Sep 2026 01:34:59 -0400
X-MC-Unique: FqD_7p_jOcSGb6ZH__jctg-1
X-Mimecast-MFC-AGG-ID: FqD_7p_jOcSGb6ZH__jctg_1790055298
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5b4ab63ee90so3278005e87.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055298; x=1790660098;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OVe9F9UnqicBMpqnz2rAf3G6pQga7qmnVnonC4zTIr8=;
        b=vrZfHlekEzlnlQjSxQpdfhyvK0dGR3FESu6ZXA4XnehRKgFB5UEcEzWf5//CUE/A5T
         4EFM35UySflxhvtifpcpbDzXV9btp6Q+IrYkeQMzDzdhzVyfvOd3tLnh9C/ss7oH816T
         I5RCBYazDcmAKSP8EMDoo/+ILQuH6UrcIDR1ibv/zF0uWT6lu1Izu7/dZZ+7K2ZX833M
         aZi1yS7dzjw6wYGP1MRV0cW1cNJBwlF1Saq+liUsrJnfh0Ok3/GvohK2ER+EIfNALf2B
         3YcyTlhQE+4e6CXXs7v/WqcRNVbyponsJGX1hfdYr3S1/7HVDtw7i8Adqp7Gr9asPArS
         32cQ==
X-Gm-Message-State: AFuF++mqCkXjJcyW4aofFErQV45ZLic+u4dVPdz83/OOpUfwT5ZtrMds
	D5UrBNEG3iZo4FFR1k1gJB/VRyZGpK5cLrLTzOObwjJMQ3A+b5ydVey5xVBkkFSfODmujskWPQ5
	UAUfEfyX6PtW2Ir2mB/r2yXA5EIcKbd531yj2zJOJvv91WsGyQ/wrvhWPg4DYNRRpMO2Qs39BOP
	+VwZegA29SCu9NpUhihK2Kjsd2TY1/nP+1wNJUUQ==
X-Gm-Gg: AYBFou2IgWI2XnGV2hEwyFuGcgvqAC65cHlY9zciwQrd/XCDZiKZjETP1vBSypUOVSx
	LX+u9zMIyy3pg3s6duj3hKDBWzB35cheHRaGKmufKV3r96bTp2YUTVUWyAkwlB+6evpJZIjGv01
	jor701eMwupuwl04KZSvvZ1M4Fh56G8EEPbC9pE5aCVfFLxPliqlKYq4RLzpqgm/i8EtI8rsI17
	hYxpYdejRpBuTER47DBPhxbKSziQYoAfRRvOQkfQm3zCPKxn+U5HhpA7XoJ+ilmLVz7IGrrOOP/
	44LEwu0OevwS0xm7OyUys2PVYMhZkSDkHDSmre3Z3wjCTA2DMW5BO0cYGHv+CM0VCItaTvtXvOh
	aAtwgCiUl8CnbQDnD4sGk
X-Received: by 2002:a05:6512:12cc:b0:5b6:183c:5c9e with SMTP id 2adb3069b0e04-5b8c1959154mr3783105e87.60.1790055297642;
        Mon, 21 Sep 2026 22:34:57 -0700 (PDT)
X-Received: by 2002:a05:6512:12cc:b0:5b6:183c:5c9e with SMTP id 2adb3069b0e04-5b8c1959154mr3783074e87.60.1790055297099;
        Mon, 21 Sep 2026 22:34:57 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:34:55 -0700 (PDT)
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
Subject: [PATCH v14 06/12] mm/hmm: migrate collection in HMM pagewalk - pte level
Date: Tue, 22 Sep 2026 08:34:15 +0300
Message-ID: <20260922053421.4092027-7-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: v_p5kT3QulUd7abADhGc8C5mvld3CalhGmmm_dMuWZ0_1790055298
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wos47u8th7o789r61qohkbqzc31u5xc4
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DE73A0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1790055301-933796
X-HE-Meta: U2FsdGVkX1/weGuvSz0R0cC+GU+rK193wL6fR8Dt7Rk1m3PkAar58u2WHZ3amBMsbyd+jr6M22q1liaaGBTlMyrhjbPnst8AGrBln+wYvLK/dY8eM4qxa+2TAkaJQvYBWgnvL7rpKNNfuwIZCqguGYtyIIjLfjS9bmlIwir3BrqDf434lxvvtyEEfdz8eC8ffgIcJ0TPTMl6PFK0zEpvpYe4uY5HFtb+UWEopzwwSwphjmTS+zVacrp3c+r3BWzR0VTaa7II/kk07cfSr97No/aIy+WStJsEoroEVL6BGDpa7vRimXl3gjGrz9DS7knNy5+8DEojyrf3QNEwM4rdgDgcVpeanWDxm0CssCahUiIKo3rrdECdEFEnRisQdRcapfJ+nQBwv1Sld1235hozbgq9S282JSzXA2IqcEf3tZz5MXY0GJoDBFoQfMD0AHHhImdUpOGaxYSN318AZ0iv66TRv2Pz8njF4uMFeJYVpZZwCjLpNPjY7odZVDlcJdODJroG2fHYI70fMK5Q3m2BjyVZ5QM24n+sPsx3ACKCBLXMakCd1jyxDSu1fspA2sWifvb10azkmapKqiqmRtuiRNxbI6jV3gKiltzp4/MyQjHlxDPJuxlqFRpxyE4Vuk83DYqxQKVv4kuRFwUfkAdT9vjIMv0BFCdatK3zAJsf3NKmEJbfzU0NcrKAap0ilEgWVCjIjsYT1qW+/NXmIiIk4gfJzGiQ/y+V1AVntDtsDxGJmHOPwzT6sdIlevkbNjHMwbIQB4bbnXQx2Ufv06fXBpXTnEWLUhXyzmqG7cq0drHSC0L9YO0rKRGGc1+xDGnYBVEfOmQc0DSGnWBHS6pMeGJtUW1+tJeFUrdCv+px+vh9et80QneN2rUnkGev23AHf+sitmdR56fbnUgYqT8tap9UPx7KdqpTle0AHLCZMerKy7gabN+qN72NkvHyYed5oqNWDcri+2s2jxBlw0q
 CXRL/nDc
 h5XDZEAVyF/V7sOSSZdlf+8Q/uTjv/4I+GEj9ScaD3ssXv0OXYlNCY3+oM+nbLJ4dBI1hriM0nJruEVLHZNNbRYKWWRr0jsq3/uttYvmHITKgkh8TP4gcUG0/LTD/U9b48gAzlm/D2NIOOYbcwCrfC26b5IZGvpHch5vDtikmoMw02Bc74JdrMyzUH8bEx+APMIbZhezNW630UOU/BXkBCpv+5duePanpqjF2+6O0qEDERKMUX1Y+jZ2vzfWzBI2fqF3QWdG5M8V4PGT7ZrLziXS6xCX2Pl8YlpwashmJBtg1vtoxuYrQVXNa5oEyoJtkMM/ZIgwDPoZsZrnbuGeds3oDFZxtUHyNdaLdhoaEAJvyp7qDk8EMiwSwww7ricloWKI4Kb93EmCMQYv7zJlT+Ft9FplJmeGRGHROlaq5bhBnvaayw4wcoHw+5GgnmPeq4vMSzWkHmrYc0LJNFeFPYZdpKeDN183iIdT59xu6zpc0LX8XSKHBCjvfLw==
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
 mm/hmm.c | 262 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 261 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index e6469ef4ae6a..b3b79d13c797 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -489,6 +489,63 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
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
@@ -499,6 +556,11 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
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
@@ -506,8 +568,206 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
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
+				folio_unlock(folio);
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
 
 static int hmm_vma_walk_split(pmd_t *pmdp,
-- 
2.55.0



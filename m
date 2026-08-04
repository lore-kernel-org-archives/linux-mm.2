Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60CF9C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C046B00CE; Tue,  4 Aug 2026 00:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D78A6B00CF; Tue,  4 Aug 2026 00:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D616B00D0; Tue,  4 Aug 2026 00:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA6906B00CE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DB431608B1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:37 +0000 (UTC)
X-FDA: 85062303354.21.09DF64B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 08686C0009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RKiDBGn/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzj2oXiMIPJc8DDmgyLO85pt6xHacr5zfN3Pc28UGUc=;
	b=028dSuZ4BYPqQxRZJlbbxJCk58FtTJSt1ICbBCPbZQnLcFybaACFhyFua4PoCznoWkXLk2
	GH+tfg7ArPFrTbLASQQfpEPYqZRfRSytyy4QsOm6XZ8QoTWFMUe5o+CSxkWD5kM9ycqKa+
	y958kjkz1Y8htgxuCx6/AgrBZUauHn0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="RKiDBGn/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817655;
	b=TKnLKVq/cOXyQEpE5xNzUfrwnEbVSUcHx7t2S0emmwhd9ndCogoUl7rzxFn1I3sGTwiYsk
	xaJG+XyabUq+MTgo3tj8sPkFl6sSxnv+8oa/8N5/54Z1h5dd+fL222xB/nyjudgRjPa8Ed
	PiWSgQa53YXCYtq8kxNxWxJNswayH4Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kzj2oXiMIPJc8DDmgyLO85pt6xHacr5zfN3Pc28UGUc=;
	b=RKiDBGn/6BMm+h4DEJM39CNLvsFOuJ5UDiG9V4lx38/HjGvLf6PPK039GDgZk6BBmrOZH7
	VMG3DXJsTPqJv9AgNB/gAg2LjzrUr1hfDd/DaqMTJzGSc77SYX5gLjuABpKbS25mRRYhNj
	hvAyD7DJhxLSw/w7GbiigMoDxJ/ryKI=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-yYl9tvBoPimpeL0QX5zlsQ-1; Tue, 04 Aug 2026 00:27:22 -0400
X-MC-Unique: yYl9tvBoPimpeL0QX5zlsQ-1
X-Mimecast-MFC-AGG-ID: yYl9tvBoPimpeL0QX5zlsQ_1785817640
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5b293eca8c4so1996885e87.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817640; x=1786422440;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kzj2oXiMIPJc8DDmgyLO85pt6xHacr5zfN3Pc28UGUc=;
        b=XMuSMBImbcYXem9XhSAusEMAIi/+NajyLyp4B2WDI8uZi5/B/5NW6VpZKUioi1tBpp
         JW4Ta9N7ZW5vxXy8as+vs0qLbgIyaoHPAqHBJPRz/wTGQr8J9Obc/WyIXB02aLEcYCld
         VyTgYi7C0zDsw76yv+m12G95WvKkSxF9Nh40PR08QABcoM7QlJjMErElGKZRal4pCmG6
         H8VeWfnO3tf2IJJL94d8oYY3H5BJp3iH029EfMUIsQzcMFnLtXKpXvdAvOq7aMmnv9D9
         iUSM5jY+EFT4D2gE0Wuvw8QvrF1ajO5gBsTrpZWVW/01hbaSqzBgDTzksKkqpv2q0eYP
         Ic2g==
X-Gm-Message-State: AOJu0YxY0qMzliun7w+QfrD9y3PmEEnl36MOejO5JpDjVEL6tRgsJPcD
	68M1qVVauuhWMfd6vpjkPMZVGmlZuijMyigYZCqNeu+4tiQeMKe+f2IM5/GoGS7WvsEURH1Z5/V
	JuqQoeGYaIjQqzv9sLQ94ouMmVZGI9ePTAwQpkPO12fuosz35QNoT/ybMJrDDHgFBbbstZxz9Pd
	D+S5YiPkShrS1bllGn/yj9WO81eKGSBrlfoe8a1w==
X-Gm-Gg: AR+sD12mWqeCiHdRZHVmlWCoR7LKhZLAevPYjoBwFKpVBZ7SRfh7WOY7jM+X+NrG/QB
	41q/l6teS6D8qgaOjbnXy0h2IDASONKe9GqdYHqudpfTs1PSXineYx2gnia5gJscWI+zf50LMdK
	EwsrfQPLo9h6DIRONxHmsBoF8jrDBw5wbpzkG9XV9mTANFu7prcn6IKoXXEvfjuMdSRL3siJ3hM
	+fIAEiRFX4T9YDRzBaCRBZGkeUYSpGG1bDIzj+JdkOPLZkSFuftkj5ziE59qiul48cwHBO9OrMq
	Es10kAepzl1a7kBlalWBv1VoB5X+wJU/OCghX0UZpVnBcqIGVnCBfPx8LRTUzJm9N//Qxk+72VV
	3Ef0UEva3sL4rZXFh
X-Received: by 2002:ac2:532a:0:b0:5b1:56c7:5753 with SMTP id 2adb3069b0e04-5b2e4f8064emr1809701e87.47.1785817640254;
        Mon, 03 Aug 2026 21:27:20 -0700 (PDT)
X-Received: by 2002:ac2:532a:0:b0:5b1:56c7:5753 with SMTP id 2adb3069b0e04-5b2e4f8064emr1809678e87.47.1785817639563;
        Mon, 03 Aug 2026 21:27:19 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.27.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:27:15 -0700 (PDT)
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
Subject: [PATCH v13 06/11] mm/hmm: migrate collection in HMM pagewalk - pte level
Date: Tue,  4 Aug 2026 07:26:26 +0300
Message-ID: <20260804042631.2175585-7-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VQPOEbHR5rj7Jj8vB3KdfW2w9221-1vo-DzMyCA0WZY_1785817640
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 08686C0009
X-Stat-Signature: s4u5mgqr8qe749xajyuc9fkxphmp3cz1
X-Rspam-User: 
X-HE-Tag: 1785817654-122951
X-HE-Meta: U2FsdGVkX18kgmV4BBe8xpxDaMF1qbeFWJ+z/7vWLsEUv+S+uwwGuMSZwa6EcfD/PF7dM2eFUw+P5uig2zkRhMNFoYLGJrAt90Lvp+Aasg10Vw0FUDlCWA0aj0O6o1VPVLtvaKrFwhSLtSpfswrmCnkKzpAvEB2drdCKARepu3CD25nxcnV+f1i/bfqinTNtk/v01lbXzsMovqGIE31kHdW7fFxfSjsmVbpRz4KEpZs2/dALol7Vs/FBJ6M0GVvJax5vEkkRYVcSa7+HK1LzL/PSoZ0RLemklCvgKbSoP1TdnU2Q30zZrJBu5nskcgSQ0FbahDX1qcXO9SwYUaRfAeiPfdfR6M9/PXxFsWvu0+KgZ1TfX6qase6LWl3TxkJChYHQ5P9BC8DOEzgTU6w1DXlM2+iNrhccXvJEN9KGOo258ht2QPOG6ppMzeXwbeIAcb1ADUdiH+qanYwUAMLErHmj7RogDdxedFt+ugLoH6kflXBZlHur+r5LpYNZAC0eBgyDcxsNYMvlwd9AMm4SvAeOfrvxF+T0uk3f3R4ey6miPDQs44uyw0Jz36kgH+QL9xXO4wnQVCTttkikywOuWG3FXwNUwsVnbX89mhPQZ02wCsAfS8wPmFkj1JmrjWun38Rv8vcW+XfNqUkRN9w/ALMXntOOxmEiHDKn8V0rhIZ8Kg81Gh6QwPWkL72JJBn3/uCZ6U7x/ad0IfpAbZWvPN7MB02/Ajo7q6iqz6lG/50UHQII5xSx4qAz/brWaw1OgiqNnf+i/nU0zasuaWzDYuaEvT7H0mOEAbWldaQ+os8+9ossuH3h+6KBWe5w64jjGxUzt9uegfkLfvqqbza3a9pNhsmzPcGAHbz/bePRpa3SHPaS1leZiC7d/AhF7/ikzXkwy/HScG6nZ/5W9UNTY1mSuCf5BzSO+51I8CrQRAr1ZP1TwdxyBE9aF9XbmKAHyXNucaGtZpgNCrkyNUl
 IN7H6dzF
 h4MrnGROLoIv7HPxx52bWwN0ZJebfjCSJO4idsvzgt23aX2YmRF30874Oq21u1mgNidpMgMek+x3ZnjA0zKhpKqQWUe345ppP08r1kA0XZllScs/hy2zRnR7Z+tVx0UbabZw6Tfo8LKOzHBvULEG7gpU1mqNlUt+rqpDOAJ1i/UCd2d9LgJbHb4iPmoI5tJRQcDjvlq9vKnq8dRKCsH6YYiYmstsCQAtnjQjiZYMDX9+Kjp9ljE8gxFw4AL24zzaNgfgpHT51fJfMYvwtRBuqp+v+sysC/69YpquZ6p4rXDAKdobBo+C3ueH/TrXSsZd2pwYv4w3dZN+NN30+9cjUWO6bFpfriYMZQ9X9sxqqWxEvZd5XYi1qpnQeOT8FgQzQ6Kn8qi3/PGhrzfS2llQh9d+VPUNA9FfLVPW42Ec3r76rky+0LzFqgeK8eWldftqjfPqILDpGWhY86t4w3vrXpX2bbOQcmll22RjBYFoJGAm8OA0U2motPAwYgQ==
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
index 3621d1df51d3..2d902b8bcd58 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -486,6 +486,63 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
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
@@ -496,6 +553,11 @@ static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
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
@@ -503,8 +565,206 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
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



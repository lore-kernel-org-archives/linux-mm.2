Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC4DCEFCBB6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B676C6B00B4; Mon, 16 Mar 2026 02:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6E46B00B5; Mon, 16 Mar 2026 02:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980DD6B00B7; Mon, 16 Mar 2026 02:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85BE46B00B4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2ABC31A0D81
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:42 +0000 (UTC)
X-FDA: 84550937604.05.7701109
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id E17854000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UCBL4NhC;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h9TXgzky6xu4x+J40zN7QzLkU2EMyumfkOS9oZD4YE0=;
	b=gfTitz7Uw54pZVEH2J/scmdO9vmEKMidfi70DeNIO4jgwifVKAzswgF9LI3bFgooI8aHdf
	3MmPPg+9H5F+qEH720PrN1SEWGFw1fDKrjtHUA8uwRKO7wVLKOK7kwa5zulqWz6tyzP0Ck
	6jBgnLbaCiqHCKHJho7dJ/4w9ZWI+wQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UCBL4NhC;
	spf=pass (imf12.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642280; a=rsa-sha256;
	cv=none;
	b=dPUHEEoNmesZv6sTmHQ7yzGvqKa0dPl+EX2am6hLVgev+Ycs7yb/fI8ttq10igXiEsI7mu
	t+zHBn4SjcQxE2QLjUzUBIh1EYZXtOXVdKH58Bgj/aOChMKoA+ZuAgJsxl/G57grGRcPHF
	RkaP/P7S4wCK3/q6K8Y6v5SVzTh6Nwg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773642279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h9TXgzky6xu4x+J40zN7QzLkU2EMyumfkOS9oZD4YE0=;
	b=UCBL4NhCXqMaS7QcynoaBfN7uWRJPG/Ko2YENvLuIwYqqAND8Xcuwk4G9EuypT5ZJKwyhv
	M1XSeE5DlnTU/Q7zB6lL6ByBzEbogvg3jjQ7Lhf9/19D30ONnWEckuRk23CnFXHzfajGF8
	plhIzx1DTsdgfhN/nRFXt9bH/VMDvl0=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-bNAsQZxrPhqvEZr-jS31Tg-1; Mon, 16 Mar 2026 02:24:38 -0400
X-MC-Unique: bNAsQZxrPhqvEZr-jS31Tg-1
X-Mimecast-MFC-AGG-ID: bNAsQZxrPhqvEZr-jS31Tg_1773642276
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a143864ad3so2783771e87.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:24:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773642276; x=1774247076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h9TXgzky6xu4x+J40zN7QzLkU2EMyumfkOS9oZD4YE0=;
        b=TX522CkDTMmrOUTiRmPeymqAHQzkd2GZZ8jMCEdzvAYHh5tF8lMvGNJlTYEYZkteVa
         Zpbkj2W1lzPirHEOmQBiAGMQ+TVo4BWkiNF/eMPX2z+Dl2gDPnEOGK3zxqqpTA4XyAPg
         J6LHc+GTg3tynVvRmS9bPBv4MXn9bcWWDLZl4ceITxTzWehjtPRV/5L+AZrSddgYein8
         UV3dZd0O0XoSyV97A+W+hOwKd1eLsT/5LXFVtlZbkop0A8ESEyulyPPXVCn8v6ABKGQi
         8dtjx+LmG/g17TLtVQZnDHXKfGlHtF8mKCkKVTY/7i0O3j6XFUXn4JK3/A8G/BcthvUT
         WznQ==
X-Gm-Message-State: AOJu0YzJmppgEmG3HMPKtcJZgoBAN1YNC44HDDTukq6dVtr28BXWsNGR
	juzU8X5jXPkXHMFQdqT3cjmoHWy4P/01xfR+wYzBAlnGtXToXpCQ3xNYoZGnxvckLZY+ESDy42t
	S0wq4N86GIwP09x7ZykHWUEzhvd0oNr0nPG6yktGwxsG4dCz6JtLEazQ6iUjRm1V+WNf7Mu7YxF
	5pj+vZn6x2hraPX7UaHtUvQfLqbkqxMHOX7ZZFbw==
X-Gm-Gg: ATEYQzxenggW7rw7+xQ/A7y7NZGQUTwKGL/AvPh790RaEjixUS3h5X/d2pt7LF8kr/Z
	vRItryld5SEdCWoz1VQwgfZBJ4AfY36ILc52dibn4q1jFdc9rDigcTSalkTvkUx2ZQlCBCGULEe
	Sv8Z2cYqdKwSzcDjIYh7KsW/kCw5X/k4Lmai0Vg8uNZqtRj8UAt4y46+HJJPtKkCjdOH8AhLZet
	WaDBpZklDMTAK6aKqthtkPiXmAJbGGOqnWkBbnKlNR+n+0d2DfvDHj/fLI/pXElY+8nu1Lz+zLj
	cfNgxH7yUQ+d1wudBAVI5WDiRHuGGX80YGJ+aPiUFFt760zZlMI7QOX2YDIep4bLopQcm0Xl1xu
	8v8UKqECK04JJlP7UCf7RKBcNc4JTb3BH7S7J
X-Received: by 2002:a05:6512:1393:b0:5a1:2e14:1343 with SMTP id 2adb3069b0e04-5a162b2185emr4513263e87.44.1773642275678;
        Sun, 15 Mar 2026 23:24:35 -0700 (PDT)
X-Received: by 2002:a05:6512:1393:b0:5a1:2e14:1343 with SMTP id 2adb3069b0e04-5a162b2185emr4513237e87.44.1773642275076;
        Sun, 15 Mar 2026 23:24:35 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e692sm3263397e87.30.2026.03.15.23.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:24:34 -0700 (PDT)
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
Subject: [PATCH v6 4/6] mm: setup device page migration in HMM pagewalk
Date: Mon, 16 Mar 2026 08:24:05 +0200
Message-ID: <20260316062407.3354636-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260316062407.3354636-1-mpenttil@redhat.com>
References: <20260316062407.3354636-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jN8fXz4qZDONAzYM8fvSnoqx-UINHok35IkaXPS33jc_1773642276
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E17854000A
X-Rspamd-Server: rspam08
X-Stat-Signature: s9nrui78pe95pmpxd1x19yqee3fb9xug
X-HE-Tag: 1773642279-568705
X-HE-Meta: U2FsdGVkX1+NW8jryHJ+u8SDYVDyas/gFunFpJqYindTMInmFsQsr9GqoGUoxZ2cMAXnqEIcTWzQCkUd+gAljxJaivprwan6HQdg78y8BX9zK5vqU7tUptqUVcVlVAm3ZAi/lZSn9L18+0eK414HMlr2vVU/sQh5SG9V2c7fomZl9uzvJS6ISUw67Ay30wsUcFIQ+pyMRq7nbER7uZtaQ3hUo3wTC/EvmuW98ApmQRQcGp0RIWjewyRpRmFByAcQSsEPngBCLQivyrzbA/WBS9iWPsEpcaiojvqPXiJdNdoZxaX4yyrCeleK1UaEsQDttxjTjRucKGqVj4fbSrlMSzc6ceZEF28lzxIeXTCTZ5WqHzxXTlxau5STWC/nHS83ItLo+eMgEZFJly/YKh9PFCYHe2//h3eNh/bwU4Q6MpNqW+wV4S6OqV26p8KkfCDzi3GVTyO1/xbfGG0IRfFwWyyeotYWg6gaK/DfdOJeOiCPWiotqvogE38cLxuWyV0fulAWaRL7RoYgv9l2IOu7Ziep7crvoE2f/m9jjFK2/6b5cqN0d3H5/KA1ozBFn9Ukt5FOzWAgiu5+l3XYdx24XdnIiGDfBBIJ8apI8yG6PG8cBwhKdx71HfXYj8kYZhVEVjRkDKr7S/TQM4n0UG32UJEbLDIoFUXDcxNmjiP/A53h+b6/DJD1XbSUAPkjJeWp1ZVLkr5GQXgv1n4vqBD5T5gRY4if43BxNIcwLupp7CYaVYO9xDGEcxJamT7h88+Tcpu1PkzKV20whT4ShkG/9aaXlOGq2E2CW9w9MerVYzRnUaP6OrRyWh7GJ4+nwa6s9UbdmVS09w1KrUhjTcIyga9t+++5GQT+RP9D11K4FaaQtg4M0Z/GxvDbfCos2HYjpF2xTA2slz6i+fgzhL1m4zgOVcuOSDVXXrg0qsNkMWLR+fvQl0EdE/kpOTLQIiXA7Vb/9pbhXY53h5bHfJw
 TKSdCgw8
 QoivZU+EDOguyN2Sgj0Zm8wJeSp6k4wnrFd9ZZ7AVnavTW6lXAtsz+rsYuYR6vZM7m14lgbZdBBHyAdEpNv7A0hfCVBTBPBtQC8XuaNvHsIxEem9UUbYA6vnZXZectIN45Bq/jwUJOLD7AxJI8F6ZiTeetiSh8dbwm9m8LOEYmhrLlErd5LCTMINa9gWudCHSEAv6Y4T7MdH7j+vCKnfUmYIJFcYzte9Bge+K0wZgYVf6B4VSaRiV+Ymv1joBEIhlzYfkpxI/wvVuoBiC8W1c9ursPnzl1+mwfiEYTbPfYz74A42k73BOzRXGyQfAdY2kLZfRf45j9LJmJYyr7+D/nsrSkOqCWT6N55oCACt2JbsN3o8JS4PGf12VdfrPH0Q+J/gF6OIdJNf3b1NcbcysyFKfEvZ1P2uCiUDm
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
index 037e7430edb9..9e1081847d1f 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -163,6 +163,7 @@ enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
 	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
+	MIGRATE_VMA_FAULT = 1 << 4,
 };
 
 struct migrate_vma {
@@ -200,10 +201,14 @@ struct migrate_vma {
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
index c302de5b67d9..69d88fe16882 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -470,34 +470,424 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
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
+			*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
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
+			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
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
@@ -512,7 +902,8 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 					  pmd_t *pmdp,
 					  pte_t *pte,
 					  unsigned long addr,
-					  unsigned long *hmm_pfn)
+					  unsigned long *hmm_pfn,
+					  bool *unmapped)
 {
 	return 0;
 }
@@ -567,6 +958,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	enum migrate_vma_info minfo;
 	unsigned long addr = start;
 	unsigned long *hmm_pfns;
+	bool unmapped = false;
 	unsigned long i;
 	pte_t *ptep;
 	pmd_t pmd;
@@ -648,7 +1040,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 					goto again;
 			}
 
-			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
+			r = hmm_vma_handle_pmd(walk, start, end, hmm_pfns, pmd);
 
 			// If not migrating we are done
 			if (r || !minfo) {
@@ -717,9 +1109,13 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
@@ -727,6 +1123,8 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			break;
 		}
 	}
+	if (unmapped)
+		flush_tlb_range(walk->vma, start, addr);
 
 	if (hmm_vma_walk->ptelocked) {
 		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index b320ea3736b4..cef9b644d31f 100644
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



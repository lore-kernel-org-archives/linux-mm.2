Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FDCFF493F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 04:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C1D6B0099; Mon, 30 Mar 2026 00:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053EA6B009B; Mon, 30 Mar 2026 00:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E35B26B009D; Mon, 30 Mar 2026 00:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE2966B0099
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:30:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 908001B884A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:54 +0000 (UTC)
X-FDA: 84601454028.14.AD8EBB2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66DF240005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DY0JX/J+";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774845052; a=rsa-sha256;
	cv=none;
	b=T7vg4mUWJbDYwZllEmgrLDQMMi06Qr38sVRyaWzHVcA12osbSBzTyUotjGJVefEN/YQsoi
	4i6MSGsMORvYFfnPxsU7BnawaQMJF7xNDWdwD6RumE99kZO3iwKhDOvOtqQXgxmw4U8b6a
	68Alu2gm/wZ7ClTsrC7+EeDkul+MYgg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DY0JX/J+";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774845052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZeqZC2GdcLOyIy95ROtdSuij8xUNn/0x/ILBqca+89E=;
	b=5LC1uCdTGjd3BN9DcHd4uf9Hn86dNx5v9RFH0CAs4wyl5pQQJBZGM9kiU7h8BD8AqmmAub
	GxHMJwP7wWr94OfbxVysYSRQzTNjvGZ0Y17LlipahRjQKQBKAFos7GKHKlBoBzXWzr9A99
	uX7wi1EXjI1SBwlTwrfIiUo7kWR6dO8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774845051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZeqZC2GdcLOyIy95ROtdSuij8xUNn/0x/ILBqca+89E=;
	b=DY0JX/J+0CewhS0j784D9bYpmijKSkmbonqeKu2UcspFrQGUNZMlH1DlMGJVgrQEc3I8/O
	5iSI9KT9iJM7C6KPWhInyEC4rqkGggYtct6RdBTjz6JjfiVg3WGFbtsmoo894NA82G4wfH
	Td2dWEWTdIrpkRQ1GSPAYAU3A/HAM/Y=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-JjDbFTPQNxiXf1Kbon-krg-1; Mon, 30 Mar 2026 00:30:50 -0400
X-MC-Unique: JjDbFTPQNxiXf1Kbon-krg-1
X-Mimecast-MFC-AGG-ID: JjDbFTPQNxiXf1Kbon-krg_1774845049
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a12fc1f73aso1617673e87.1
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774845048; x=1775449848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZeqZC2GdcLOyIy95ROtdSuij8xUNn/0x/ILBqca+89E=;
        b=ORiyw348wvwm6XWaUf8SxqaSgZpYjHBg76P0QFJxSdUk6xl963IkfzOTausmGQnEQq
         iBDpsK5eG1r/09LL/lyIuv3iv1OPe1qSkTo+V/qsg9o68fAkEznxlETNmNk4mqlUNGwQ
         et/s7+wMZjcxHGD1igTHIhoo6MWVUUPZCxdSsGos/QBKNnVTukA9SMk86gi8E0vQuSyn
         5+I5vTjsvG8vZ+4T3bUeOUDVTnvFSQGJHadpMWH0qUvDghkIIs0EDhxLQoY59oEGCTwu
         G1NDTI08IkZBzhC8zN0KEwMdpUFdz3Zy9BCznIBruREqK/xwjytjjHpq1+lQVEa4xqUX
         WJ2w==
X-Gm-Message-State: AOJu0Yw/63IK1TUOVdr5DMa3NPstGSa8PdjgSiV/ujrRlJBV9ujdmkmj
	DSmMI3ayYHUUEZ6Zhe4GBLkaJxL6UEgvmDJSaWdwO8O1P1E/ttWVjxO8LIf1azKOhkRqZ2OduZF
	il3Y/yanp6NCKLkE6iEmcfjhHRxU9yaDYiItPmNUICX7Ildkfa4GivxKtkP1F5qFBnYz6lz1GI+
	Fuz3ceTXl1KZplnXchC7TuK/AK72XlIbf1gzXfUg==
X-Gm-Gg: ATEYQzxr8Ukn+4mqpKDNolfs4LL+9o2HHoByj7j5m/tojii8sUrEmvhsXcrexq0I3uT
	B8qn5ZlWUD6joWB4vFQQueLAeTa2XmhxNvMSknpcn+FAj5wqD7oP+ubcx2hbStJkkg+YIpVY/Y8
	4hrgMhsRPHHVOzqpJ48qF2RNSaZI8fAvJMuuGFtLH9lhkMNJz47g3ZHl3alOb6mwAjKKeOmSWDH
	35pPGoFDmRxOCGo+/X1NYgtGL71WjqCzFApDrxsYEGmB8//IY5HqkROqgDKAkvRkDJL8J4RXj6z
	GAqOA770zbWhUPbBn6vus6WgwQjaeyKSzuDyqBNgixmEoezoFXbemh5k0L91KYXGm3PE+fwlZEg
	I0qhP98jV5Du+NgBZDFrdM6iXy1DYBMfUEsoY
X-Received: by 2002:a05:651c:ba6:b0:383:7f85:8eef with SMTP id 38308e7fff4ca-38c74005967mr24326881fa.29.1774845048283;
        Sun, 29 Mar 2026 21:30:48 -0700 (PDT)
X-Received: by 2002:a05:651c:ba6:b0:383:7f85:8eef with SMTP id 38308e7fff4ca-38c74005967mr24326711fa.29.1774845047667;
        Sun, 29 Mar 2026 21:30:47 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c83729522sm12470671fa.14.2026.03.29.21.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 21:30:47 -0700 (PDT)
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
Date: Mon, 30 Mar 2026 07:30:15 +0300
Message-ID: <20260330043017.251808-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260330043017.251808-1-mpenttil@redhat.com>
References: <20260330043017.251808-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: hgg1MV6aufqc8QI9gwaAUkipsJN7WtdKneuAaij682w_1774845049
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: njj9ewdcc93if4dqog53xkoo5h7d577s
X-Rspamd-Queue-Id: 66DF240005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774845052-154239
X-HE-Meta: U2FsdGVkX1/ratu46m4orWCoIFaafyUp7hryqtczbqUpVdeXPX3LanoAcQ9cgt0UQtKFEFk/h3pdfcLXKgcVa1vhX3vhLQg/26uxwK1WCWHYo2KFHjPIhbTqXOAWsaB1wFh98MmfiigtMyFFRhMjy05g92FDvDL7RjZvT+EMQi797+cvbqG87/AZTMo4YcYUBcn5w23Kva+b+2ESUiB8hU2yJ2bCXVe84/dBMRmsglxZxleVRFpuDzLbZ9Iq9a80FNmVHkJIucxCyHlvukzIdBh168aJc5SScdQ6Mhqo3Vw1n/+r9OzQlP11TBA0ZQW1l9PxqFnvrOkSiWM8AT2MKldhMu0ni8eDQrTVd0vCm7ipCq/HFUmtDNPTB6X3HafuWtCwbXXg/ra+U0iGBOmodwnVj1+13zizjwCWaYwlkApP9Z9Fsfrw4XZBEtafhf7V4pUPzmSP0cfQLFrWXQWIJc3KE1zToTjzidmjhhdN69NtkRTKbVBxnZ6wkchMN0ZKsfyc8XZuHqBadlKlXfgoZH7PTN+3u6wxBUDKSduQpYJgML3dBPWEhDq/VsdsFsxEdvk/l19w4xvc6LCEsdNYl0DiSwz+gHL9SgJioD8Q//pLw5jhzIpoHkLnK5ctybLPBGYMPpFPeBVJ8UOwYrcLIWIAF7BVrOrZB3pBiDou6JZLVGU4Piscl29NrwkxEIeTMFrIre/OESDC2ak/E4W6jLMzBmb2ZzP7WDxGVvFNgavTmOKa6NT6LvYz+GQ7fko4gP3fBWnrZXg6QvJd9ANtnrS3mYPg7I9ELrVXlI7bkhaRw1/NQXldZihi+w8ztLeJG9DK8Izy/veeTaEpm08hD2OLVWbxA9KSkTS36kxF6CmzRIi991uwuCxivaSJqa6nigXnp2yN90FeidwciWBF25nDUkbRoRfwQ2GEp1QPfvdTFXpSgc9wZuf/7a2jneOtfgA8mmBEg3Rsx4VR/Ep
 2owCvOKQ
 glUS0eykbaDShdlY7kcrupYIdr2CPFjVztqRL883qh/pM/aT3ofhhJzbyxf13mfYg1woEfcOi7QxB//7jfGjXonioFZpn5DG1yTRCMD43m/TLAfvXHFad4AlVzHLZFnQc3SIsGk9rbbPMBcQLakWmAJEE0N1APbwIWtHA32I0JVQ6Jkgu/gHAKgV1zUNRybW8Fdz0HDf9rxaGa0sv5c8lcf8dvT8iPcSPiy0OmfOCDQRBT8pjrVPoCCCtPD2o3wDji4ZOFZ0Sv8J5QCTZyNE6yVpZE9Ym0nLUjvL5dM68N1sChgL6pG1zAz2YoramlZpMq7+D1A8RwoNdz4sj4oSFQYLJDQiwWU6h1rrxlqCcY9XwFUtuJZl7qzEvo3+hKASZ8WP7fIuK4BWPvNMQYfmhqQUrJ1ejIt0SXMvx
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



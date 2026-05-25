Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EAD6CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709936B009D; Mon, 25 May 2026 01:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691FF6B009E; Mon, 25 May 2026 01:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4D46B009F; Mon, 25 May 2026 01:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 343416B009D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:09:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 021C41C1E4A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:09:04 +0000 (UTC)
X-FDA: 84804763050.09.937DFF7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C68D416000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:09:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gDoGMnHm;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779685742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnOrPYWvLJhqxeq/Rsen85IEvBpCff2lVP7hBQ2BbQo=;
	b=zzhJNvuZSSPEO9ulCgjzbS786Y2bIDMWmmoUQhRJN8xXqCVh2izxlPgs/g79b+rNJctgwm
	esnZAc4UyGXCVoJr5MSKG2SyB689bxw00Lu46J27sHuCeq2AtB9DQkrjs0WgWSzsW7/uhi
	kj1NrqX4GOOp8Y8Oohc4Sl/em/dbXwA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gDoGMnHm;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779685742; a=rsa-sha256;
	cv=none;
	b=tcHzmSEWc8SnYo8up1JTSER+S+b8+TdFwRNByeYMqiV1cKeslKeszPX2QWQcKtQgV5qK+F
	u7mT8jmmu1n1psjLmj4kQ3sB9VpUBdEIv27ZKQLL9Foy1vh2W1kIv/Ek6ALkPDudKFLei7
	vTrmNcMEtwL5SJpwW8g9un8pp066ub0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779685742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AnOrPYWvLJhqxeq/Rsen85IEvBpCff2lVP7hBQ2BbQo=;
	b=gDoGMnHmVQncJFvjGVHGoMShv22Zp8RaQTPCXCAQRujzG1LakMhpxyuC99XrGaZgkE86Q8
	JnnWHF3lyxa/lmCl+PS4ccn01ODVRrMrWGZDK2wurRUzMk9RVRkL/x/qkybOTxQ5ooS9V6
	lqoOnECtKJQsM7Bn3B7IwVf5TTzb7rk=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-UgCsEOqGMtqIcBzKopB4yQ-1; Mon, 25 May 2026 01:08:58 -0400
X-MC-Unique: UgCsEOqGMtqIcBzKopB4yQ-1
X-Mimecast-MFC-AGG-ID: UgCsEOqGMtqIcBzKopB4yQ_1779685737
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-393e7ecef62so37950911fa.2
        for <linux-mm@kvack.org>; Sun, 24 May 2026 22:08:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779685737; x=1780290537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AnOrPYWvLJhqxeq/Rsen85IEvBpCff2lVP7hBQ2BbQo=;
        b=Hxqzn9MGRSyGana6h8CMS8CRMiZpLjQ08Kxsk++mnxokX0XiOb1DutA6R4LMgYYh0E
         S31kUSzSU4S6z+mLGJrnRJPv04r1kFVdvf25UT5ZrFuV/3ihdIrlOjXz8/CFomOo85rI
         tCMhLUXjPCm2vYms3N/LIEDSYLc8ZCpD05Dq3op8dwFWFF8SXNAUZmXEe+2jvo70MMrU
         H8ExOpBo5ZYvIZtosVPhuTNCDQB4+4kthvIdlc5dhUOg+dwE1Ozxd5qnaeL7618KatOx
         uJxmIM1Y3o+rJgR4qPcXz5g0idgqKnfkUAM5GMySr9bytU/tpeWI/+kmBaCoCYZKrK5J
         0Mog==
X-Gm-Message-State: AOJu0YznOZgyb+Vsv9O84WVWt2tf7LLu/SZ905Lskc4pv6YO4k9gFJGg
	11zyPNcJKjlD24p5/tPEKB8BlaiPPPzHiBVwOExom5yU2LrybhCyB0p6vsPaAs5Qux9dVxF621a
	thZMsSIfSnTTAQRAYvEZ6//McJbXM7TIWfNXzrUepr6GLgC88skjVUeMkYCbSnkAdTdNQcdfArh
	ax51P01lroeyrVd+HmHo/lm5+xxUU32FxjvzoWSw==
X-Gm-Gg: Acq92OHXrVnnxqKGQ8GYPbsdqfI03nTbCAeDd8fauRRTQzFxX1PEesZ+7UtiyStNYzV
	OiX941qt8uH85SU4/O8e4ipljT0OmuD9qb4wbfzT+LcPafF32m/uTTEJx824h9ZcSLXFEL2viYf
	KrRUoNmUmNMJJjfxYBJtGbyy838U+qMzF51GoUr12yIBrBKPnuic0sUdNx7mJKGSRViiq6T6z/s
	5rdxRqh07wh6lmpnF10CkTM7la/5KXGou+z74qC/tGizXSM7y0rY1a8fB5D1y/l+Q+zMKQJJNHs
	VjdWkMhhyRxVNcoXF0ioi8TPDvrRC582Cugjgdwt/wUuUDBcaRkze5D+KCVWirvQ979d/7qOo+n
	xOhcfEOacIYlkKSmKSNoR5ijKY9972TXAB3ir
X-Received: by 2002:a2e:be2c:0:b0:393:bffa:d815 with SMTP id 38308e7fff4ca-395d8d3c6f4mr37180191fa.21.1779685736985;
        Sun, 24 May 2026 22:08:56 -0700 (PDT)
X-Received: by 2002:a2e:be2c:0:b0:393:bffa:d815 with SMTP id 38308e7fff4ca-395d8d3c6f4mr37179891fa.21.1779685736316;
        Sun, 24 May 2026 22:08:56 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm20698161fa.16.2026.05.24.22.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 22:08:55 -0700 (PDT)
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v11 4/5] mm: setup device page migration in HMM pagewalk
Date: Mon, 25 May 2026 08:08:29 +0300
Message-ID: <20260525050830.100254-5-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260525050830.100254-1-mpenttil@redhat.com>
References: <20260525050830.100254-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gNxtJLNN5GVA9JSTjOEVAzdbwJkgsaYA6e0qUM8IsN4_1779685737
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C68D416000A
X-Rspam-User: 
X-Stat-Signature: eey87d7wbnfjxe7qbs3xfi8i88qbsuy4
X-HE-Tag: 1779685742-988154
X-HE-Meta: U2FsdGVkX19NRFw2zngN9ADZTqTj8sHBgPkY1Vh+Fg9WdzyKMKhEjSZ5W/RJ5+V5Cep/CA+sYyo+4iDDP9pwh3nr6LGJzKYungGb4KPKY3Jf0lwGY658HWipzXlhH38T0k1nQKFy7HnIMtCDs0CUZcR96CCMPgjEu76iU+QaXguy3MB2Rxl3G+198fT2qyHIdEusnTFfAawIo6etqOrPpf+6GYTXOuyrGR9q2PEI9dUs32uDK0cWWlhngmn/iQImaX0YTelwrstViXx+T2dDEpJ78XIfFP8oUJRFNqfGlR8eJrQtNHjMQg5YUor7iCwDhCoEynPhUn2CNZOxolNPuvyxL107DZp+Fzp4+7UtunyE671Nbc83uqj3yTEHnkBQd/z2bJuUtlq40PEpyHcP/Sw0FQBOX7368/r08Wz+5/1hQrDpz9oJflCSFY7/Ebd/VTfLxICU2QdPswTE3M0L5lGh/PsNDJjI+zObNX4bkzRiSchoHu+IiNTFDaTNG2S4tDiPUBLZ7R23c32nTArYoTFhMYvvjWfcs+7MM8e7iZV37NhAOTQHhPZ/7LThu7unpdrmyVjknVhW3I+Smxa1TZmcGNyK84xBLp4ib/3LzpbwVp6YcYiEyBNIAA441UoRZ88hk+sTh76MdLbT2qNPxMF7rEaBJn+ytNOWL0L70cgIU2z4jCfTP0jShrdEY7etkUFnTaLgiW5jtGi8t+3tzCQM8rhGKrMBBCvSPeFEXiKl8GubtB9VezClE4pBM+TYgP8Y0tWvfwfYpZlo5qmzrzOErPvzfKvKYVinQhywERjkh0nrF/sDpOanGAf+qbw1xjx0gF1AF7R5a31SoKyn3oah+a5xkRaGDoKTz28hgYSQbys/sXvFDXYARoTMWhoKqwt02RBgWsDWBqJwmJ5ymyOo/bTnpVmC2Hng3yiHDy5rEUSX+gEwfHK5yExMwilcPWakrTFLiwvgUOe5Ahg
 lH9tK2Q6
 BC7ys83nj079N94ag6SYPZZBsTWxglSxqNGFHQoK3MWRroJSJfD4m4ieSOqERgs8tx/JyP2j4uFCQvtNjmShmcz7RaZFn7Wq/nHj/Ywa18uAwaaINGQVZaIwIdTMGEHhaXbzcIr8p3Z0kuJZSznigJQBV9EfdhZY+pzAkSXhv5J4wyzEvs86hhHUWjgmNM6ahS7X5Pv2B95B5g0Du11qlvD+PupGqtyxmYpkyzPJBGSFy6u3SAi2A9eYZg35h5P2L73p+l2YSnwfyIB5qBiQ3o4wUTQ6ZCfjp5XxSwXBqpJGoHMqWPc/CzEeRsW8yMjCYo/VR9VuCixbcMKEiqVRELjRdKcc8Z91fMwKWJ2DvRunO+1GhgbxnyOh6jZxcGJq+LS6t2wQ2vpAjvBtdEgXJVFQKSY1kYPYoxBts
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

Also, remove the now unused migrate_vma_collect() functions.

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
 mm/hmm.c                | 427 +++++++++++++++++++++++++++++++-
 mm/migrate_device.c     | 528 ++--------------------------------------
 3 files changed, 445 insertions(+), 519 deletions(-)

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
index ee78764c3e47..0fe880447bc0 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -483,34 +483,431 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
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
@@ -525,7 +922,8 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 					  pmd_t *pmdp,
 					  pte_t *pte,
 					  unsigned long addr,
-					  unsigned long *hmm_pfn)
+					  unsigned long *hmm_pfn,
+					  bool *unmapped)
 {
 	return 0;
 }
@@ -580,6 +978,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	enum migrate_vma_info minfo;
 	unsigned long addr = start;
 	unsigned long *hmm_pfns;
+	bool unmapped = false;
 	unsigned long i;
 	pte_t *ptep;
 	pmd_t pmd;
@@ -663,7 +1062,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 					goto again;
 			}
 
-			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
+			r = hmm_vma_handle_pmd(walk, start, end, hmm_pfns, pmd);
 
 			// If not migrating we are done
 			if (r || !minfo) {
@@ -732,9 +1131,13 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
@@ -742,6 +1145,8 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			break;
 		}
 	}
+	if (unmapped)
+		flush_tlb_range(walk->vma, start, addr);
 
 	if (hmm_vma_walk->ptelocked) {
 		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index deb6c944cf15..26ce7d86fb6d 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -18,508 +18,6 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
-static int migrate_vma_collect_skip(unsigned long start,
-				    unsigned long end,
-				    struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	unsigned long addr;
-
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = 0;
-	}
-
-	return 0;
-}
-
-static int migrate_vma_collect_hole(unsigned long start,
-				    unsigned long end,
-				    __always_unused int depth,
-				    struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	unsigned long addr;
-
-	/* Only allow populating anonymous memory. */
-	if (!vma_is_anonymous(walk->vma))
-		return migrate_vma_collect_skip(start, end, walk);
-
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
-		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
-		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
-						MIGRATE_PFN_COMPOUND;
-		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
-
-		/*
-		 * Collect the remaining entries as holes, in case we
-		 * need to split later
-		 */
-		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
-	}
-
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
-		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
-	}
-
-	return 0;
-}
-
-/**
- * migrate_vma_split_folio() - Helper function to split a THP folio
- * @folio: the folio to split
- * @fault_page: struct page associated with the fault if any
- *
- * Returns 0 on success
- */
-static int migrate_vma_split_folio(struct folio *folio,
-				   struct page *fault_page)
-{
-	int ret;
-	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
-	struct folio *new_fault_folio = NULL;
-
-	if (folio != fault_folio) {
-		folio_get(folio);
-		folio_lock(folio);
-	}
-
-	ret = split_folio(folio);
-	if (ret) {
-		if (folio != fault_folio) {
-			folio_unlock(folio);
-			folio_put(folio);
-		}
-		return ret;
-	}
-
-	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
-
-	/*
-	 * Ensure the lock is held on the correct
-	 * folio after the split
-	 */
-	if (!new_fault_folio) {
-		folio_unlock(folio);
-		folio_put(folio);
-	} else if (folio != new_fault_folio) {
-		if (new_fault_folio != fault_folio) {
-			folio_get(new_fault_folio);
-			folio_lock(new_fault_folio);
-		}
-		folio_unlock(folio);
-		folio_put(folio);
-	}
-
-	return 0;
-}
-
-/** migrate_vma_collect_huge_pmd - collect THP pages without splitting the
- * folio for device private pages.
- * @pmdp: pointer to pmd entry
- * @start: start address of the range for migration
- * @end: end address of the range for migration
- * @walk: mm_walk callback structure
- * @fault_folio: folio associated with the fault if any
- *
- * Collect the huge pmd entry at @pmdp for migration and set the
- * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
- * migration will occur at HPAGE_PMD granularity
- */
-static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
-					unsigned long end, struct mm_walk *walk,
-					struct folio *fault_folio)
-{
-	struct mm_struct *mm = walk->mm;
-	struct folio *folio;
-	struct migrate_vma *migrate = walk->private;
-	spinlock_t *ptl;
-	int ret;
-	unsigned long write = 0;
-
-	ptl = pmd_lock(mm, pmdp);
-	if (pmd_none(*pmdp)) {
-		spin_unlock(ptl);
-		return migrate_vma_collect_hole(start, end, -1, walk);
-	}
-
-	if (pmd_trans_huge(*pmdp)) {
-		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		folio = pmd_folio(*pmdp);
-		if (is_huge_zero_folio(folio)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_hole(start, end, -1, walk);
-		}
-		if (pmd_write(*pmdp))
-			write = MIGRATE_PFN_WRITE;
-	} else if (!pmd_present(*pmdp)) {
-		const softleaf_t entry = softleaf_from_pmd(*pmdp);
-
-		folio = softleaf_to_folio(entry);
-
-		if (!softleaf_is_device_private(entry) ||
-			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			(folio->pgmap->owner != migrate->pgmap_owner)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		if (softleaf_is_device_private_write(entry))
-			write = MIGRATE_PFN_WRITE;
-	} else {
-		spin_unlock(ptl);
-		return -EAGAIN;
-	}
-
-	folio_get(folio);
-	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
-		spin_unlock(ptl);
-		folio_put(folio);
-		return migrate_vma_collect_skip(start, end, walk);
-	}
-
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
-		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
-		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
-
-		struct page_vma_mapped_walk pvmw = {
-			.ptl = ptl,
-			.address = start,
-			.pmd = pmdp,
-			.vma = walk->vma,
-		};
-
-		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
-
-		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
-						| MIGRATE_PFN_MIGRATE
-						| MIGRATE_PFN_COMPOUND;
-		migrate->dst[migrate->npages++] = 0;
-		migrate->cpages++;
-		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
-		if (ret) {
-			migrate->npages--;
-			migrate->cpages--;
-			migrate->src[migrate->npages] = 0;
-			migrate->dst[migrate->npages] = 0;
-			goto fallback;
-		}
-		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
-		spin_unlock(ptl);
-		return 0;
-	}
-
-fallback:
-	spin_unlock(ptl);
-	if (!folio_test_large(folio))
-		goto done;
-	ret = split_folio(folio);
-	if (fault_folio != folio)
-		folio_unlock(folio);
-	folio_put(folio);
-	if (ret)
-		return migrate_vma_collect_skip(start, end, walk);
-	if (pmd_none(pmdp_get_lockless(pmdp)))
-		return migrate_vma_collect_hole(start, end, -1, walk);
-
-done:
-	return -ENOENT;
-}
-
-static int migrate_vma_collect_pmd(pmd_t *pmdp,
-				   unsigned long start,
-				   unsigned long end,
-				   struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start, unmapped = 0;
-	spinlock_t *ptl;
-	struct folio *fault_folio = migrate->fault_page ?
-		page_folio(migrate->fault_page) : NULL;
-	pte_t *ptep;
-
-again:
-	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
-		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
-
-		if (ret == -EAGAIN)
-			goto again;
-		if (ret == 0)
-			return 0;
-	}
-
-	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
-	if (!ptep)
-		goto again;
-	lazy_mmu_mode_enable();
-	ptep += (addr - start) / PAGE_SIZE;
-
-	for (; addr < end; addr += PAGE_SIZE, ptep++) {
-		struct dev_pagemap *pgmap;
-		unsigned long mpfn = 0, pfn;
-		struct folio *folio;
-		struct page *page;
-		softleaf_t entry;
-		pte_t pte;
-
-		pte = ptep_get(ptep);
-
-		if (pte_none(pte)) {
-			if (vma_is_anonymous(vma)) {
-				mpfn = MIGRATE_PFN_MIGRATE;
-				migrate->cpages++;
-			}
-			goto next;
-		}
-
-		if (!pte_present(pte)) {
-			/*
-			 * Only care about unaddressable device page special
-			 * page table entry. Other special swap entries are not
-			 * migratable, and we ignore regular swapped page.
-			 */
-			entry = softleaf_from_pte(pte);
-			if (!softleaf_is_device_private(entry))
-				goto next;
-
-			page = softleaf_to_page(entry);
-			pgmap = page_pgmap(page);
-			if (!(migrate->flags &
-				MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			    pgmap->owner != migrate->pgmap_owner)
-				goto next;
-
-			folio = page_folio(page);
-			if (folio_test_large(folio)) {
-				int ret;
-
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(ptep, ptl);
-				ret = migrate_vma_split_folio(folio,
-							  migrate->fault_page);
-
-				if (ret) {
-					if (unmapped)
-						flush_tlb_range(walk->vma, start, end);
-
-					return migrate_vma_collect_skip(addr, end, walk);
-				}
-
-				goto again;
-			}
-
-			mpfn = migrate_pfn(page_to_pfn(page)) |
-					MIGRATE_PFN_MIGRATE;
-			if (softleaf_is_device_private_write(entry))
-				mpfn |= MIGRATE_PFN_WRITE;
-		} else {
-			pfn = pte_pfn(pte);
-			if (is_zero_pfn(pfn) &&
-			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-				mpfn = MIGRATE_PFN_MIGRATE;
-				migrate->cpages++;
-				goto next;
-			}
-			page = vm_normal_page(migrate->vma, addr, pte);
-			if (page && !is_zone_device_page(page) &&
-			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-				goto next;
-			} else if (page && is_device_coherent_page(page)) {
-				pgmap = page_pgmap(page);
-
-				if (!(migrate->flags &
-					MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
-					pgmap->owner != migrate->pgmap_owner)
-					goto next;
-			}
-			folio = page ? page_folio(page) : NULL;
-			if (folio && folio_test_large(folio)) {
-				int ret;
-
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(ptep, ptl);
-				ret = migrate_vma_split_folio(folio,
-							  migrate->fault_page);
-
-				if (ret) {
-					if (unmapped)
-						flush_tlb_range(walk->vma, start, end);
-
-					return migrate_vma_collect_skip(addr, end, walk);
-				}
-
-				goto again;
-			}
-			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
-			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
-		}
-
-		if (!page || !page->mapping) {
-			mpfn = 0;
-			goto next;
-		}
-
-		/*
-		 * By getting a reference on the folio we pin it and that blocks
-		 * any kind of migration. Side effect is that it "freezes" the
-		 * pte.
-		 *
-		 * We drop this reference after isolating the folio from the lru
-		 * for non device folio (device folio are not on the lru and thus
-		 * can't be dropped from it).
-		 */
-		folio = page_folio(page);
-		folio_get(folio);
-
-		/*
-		 * We rely on folio_trylock() to avoid deadlock between
-		 * concurrent migrations where each is waiting on the others
-		 * folio lock. If we can't immediately lock the folio we fail this
-		 * migration as it is only best effort anyway.
-		 *
-		 * If we can lock the folio it's safe to set up a migration entry
-		 * now. In the common case where the folio is mapped once in a
-		 * single process setting up the migration entry now is an
-		 * optimisation to avoid walking the rmap later with
-		 * try_to_migrate().
-		 */
-		if (fault_folio == folio || folio_trylock(folio)) {
-			bool anon_exclusive;
-			pte_t swp_pte;
-
-			flush_cache_page(vma, addr, pte_pfn(pte));
-			anon_exclusive = folio_test_anon(folio) &&
-					  PageAnonExclusive(page);
-			if (anon_exclusive) {
-				pte = ptep_clear_flush(vma, addr, ptep);
-
-				if (folio_try_share_anon_rmap_pte(folio, page)) {
-					set_pte_at(mm, addr, ptep, pte);
-					if (fault_folio != folio)
-						folio_unlock(folio);
-					folio_put(folio);
-					mpfn = 0;
-					goto next;
-				}
-			} else {
-				pte = ptep_get_and_clear(mm, addr, ptep);
-			}
-
-			migrate->cpages++;
-
-			/* Set the dirty flag on the folio now the pte is gone. */
-			if (pte_dirty(pte))
-				folio_mark_dirty(folio);
-
-			/* Setup special migration page table entry */
-			if (mpfn & MIGRATE_PFN_WRITE)
-				entry = make_writable_migration_entry(
-							page_to_pfn(page));
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page));
-			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(page));
-			if (pte_present(pte)) {
-				if (pte_young(pte))
-					entry = make_migration_entry_young(entry);
-				if (pte_dirty(pte))
-					entry = make_migration_entry_dirty(entry);
-			}
-			swp_pte = swp_entry_to_pte(entry);
-			if (pte_present(pte)) {
-				if (pte_soft_dirty(pte))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd_wp(pte))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pte))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pte))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			}
-			set_pte_at(mm, addr, ptep, swp_pte);
-
-			/*
-			 * This is like regular unmap: we remove the rmap and
-			 * drop the folio refcount. The folio won't be freed, as
-			 * we took a reference just above.
-			 */
-			folio_remove_rmap_pte(folio, page, vma);
-			folio_put(folio);
-
-			if (pte_present(pte))
-				unmapped++;
-		} else {
-			folio_put(folio);
-			mpfn = 0;
-		}
-
-next:
-		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = mpfn;
-	}
-
-	/* Only flush the TLB if we actually modified any entries */
-	if (unmapped)
-		flush_tlb_range(walk->vma, start, end);
-
-	lazy_mmu_mode_disable();
-	pte_unmap_unlock(ptep - 1, ptl);
-
-	return 0;
-}
-
-static const struct mm_walk_ops migrate_vma_walk_ops = {
-	.pmd_entry		= migrate_vma_collect_pmd,
-	.pte_hole		= migrate_vma_collect_hole,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
-/*
- * migrate_vma_collect() - collect pages over a range of virtual addresses
- * @migrate: migrate struct containing all migration information
- *
- * This will walk the CPU page table. For each virtual address backed by a
- * valid page, it updates the src array and takes a reference on the page, in
- * order to pin the page until we lock it and unmap it.
- */
-static void migrate_vma_collect(struct migrate_vma *migrate)
-{
-	struct mmu_notifier_range range;
-
-	/*
-	 * Note that the pgmap_owner is passed to the mmu notifier callback so
-	 * that the registered device driver can skip invalidating device
-	 * private page mappings that won't be migrated.
-	 */
-	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_MIGRATE, 0,
-		migrate->vma->vm_mm, migrate->start, migrate->end,
-		migrate->pgmap_owner);
-	mmu_notifier_invalidate_range_start(&range);
-
-	walk_page_range(migrate->vma->vm_mm, migrate->start, migrate->end,
-			&migrate_vma_walk_ops, migrate);
-
-	mmu_notifier_invalidate_range_end(&range);
-	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
-}
-
 /*
  * migrate_vma_check_page() - check if page is pinned or not
  * @page: struct page to check
@@ -728,7 +226,17 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
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
@@ -753,17 +261,25 @@ int migrate_vma_setup(struct migrate_vma *args)
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



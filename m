Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71BD1C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E677A6B00AE; Tue, 22 Sep 2026 01:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17EF6B00AF; Tue, 22 Sep 2026 01:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0A26B00B0; Tue, 22 Sep 2026 01:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95DC66B00AE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:35:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34991803A3
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:14 +0000 (UTC)
X-FDA: 85240284948.20.E2DD6F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 05330C0008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXHJ5KCA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055312;
	b=isY+fO15s1Dl0h1aL6wd8T7L0UGsjC9W1DSeXnSBf0NETCR4yins4MeXigAKVfIyplnTDB
	7ppmkrzwmZn24gTiyhIFWw96KW+2zGVupbwzfmurasoV15K78O8IDQiZ/1pHARxOpLWjQU
	MfzSLemA9hQ/e/rjG02F83M7kcgoIb0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PXHJ5KCA;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfS04+9MgqTJr7/AuJyf/BgMvbHeqVFk8HMCC4JI/vk=;
	b=YUVeB0FqD3ZsIzdG/7tec+lFYdF6Xj+rlnp3BCWlvuakwX9u31q6HHmP+KoIsDbqXeN1Qo
	Df+JKg1UmOHezpncBOO6xifPax5W3xl0rr7gVQXYT/Yrf3auAJfoCtH1GK0WQVO2NW912A
	V3+hcul8LpZ21Dv0i0KMGm/tSb6kEHo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bfS04+9MgqTJr7/AuJyf/BgMvbHeqVFk8HMCC4JI/vk=;
	b=PXHJ5KCABOnYV7gYljO1rX9sC27ooKUiQNj4HYHhVdyA4/j1d2M116/ZjhEIRAONX9BizT
	4tIhXGD0sddbq/syhvSsCj+q1/k5kgIlvtwkA1QYn/7X6vLdR7OCYH+uEg/RhkWzASCQWo
	0CukFT4hh9Bpddo/qecfRxngltrIDy8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-FEJKRS3qNBq33aJraeHRyQ-1; Tue, 22 Sep 2026 01:35:10 -0400
X-MC-Unique: FEJKRS3qNBq33aJraeHRyQ-1
X-Mimecast-MFC-AGG-ID: FEJKRS3qNBq33aJraeHRyQ_1790055308
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3a49dcb2b24so4762211fa.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:35:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055308; x=1790660108;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bfS04+9MgqTJr7/AuJyf/BgMvbHeqVFk8HMCC4JI/vk=;
        b=pOyqgpJ9NBsaLKAEMsKA4C8Wjoxpgj7gdjyoEWwt31yx0K1CNYq+l8pqA3qlGIF0cz
         niIpN5osvo8KSHXdN5YIJdVVLIufmDDBQd9fW8eiM5SytSZNd5R6Cd2qBSKE7P6gmMv7
         YEc8eEixjFf1vPA7Yii78C5+T3hROXFe5Yi28pceb/8EWpYyiVA4Ya+FpuukhZU/zHzG
         Lf5Ohc4F/O1hK9J2/fYLO7MUqWb+BQDdr9yMQ8EgB72Inl7eKZQGIyDJBobTMCw1QvvN
         qFtTXCgREKE1Nduqi3EpzIvhF19sd70o5q9AMatI4z2B34y1rnD0qLwVZFc1YFPQWiIV
         48pQ==
X-Gm-Message-State: AFuF++kRMLWuseKnCRVrkGXxlSWYe2AyUGiP608+UTizdH9qdrd3xdMf
	ouucMkoVF83TlVDnznKvUDVJieiwaS41sjrn/pHQh/3mPzkIlwv8tji+H/RkXIVBbQtOtgkuevH
	APXcYPPk7VZ7fv3yEqeKaaSNuFVrv0EXi6HxjZcxhKlU9HaSG4PZCT7duU3gOFkmAA6viGVIo8Z
	dX5gBQQ/GhVaniCsHuQ8oAWuh7jwyuOiJe+S8sqA==
X-Gm-Gg: AYBFou2tEX/cvLEMowCEZ4knFULj8yAZEaihLNSQUIUV+juV/3GZ7ygRXg8vHXTESsO
	vP0gWX9rNnauOu/5VIVAGTBgbceoELdm0/Ywtwzhqomi8CExVKvKAfBwnyu6ZAknCNDf9h6EQxO
	oKrgflBtyVbuRbW+HMScUDkAMinBTd616VYcsvgVb24JUvco+C/CSSyyGxU9Kr6dFkbPS0qh+gL
	mBtnO1b0H7PeofBPKY3B4JCXCjPc9tn1/jT2xFJw87B7lFDWV1EDjy++cPKEdZaQEh5xVqez0ec
	aK4r2RKh7SSg5aLzJJh+5/35FtM4mUdZaK7iVEIp/rTkmDwByznpnbwhQXfUF6h8jO4H/K/ItJu
	vasym1NeSy27+moKu80r4
X-Received: by 2002:a05:6512:4884:b0:5b6:10bc:dc47 with SMTP id 2adb3069b0e04-5b8d2945a50mr296484e87.30.1790055308228;
        Mon, 21 Sep 2026 22:35:08 -0700 (PDT)
X-Received: by 2002:a05:6512:4884:b0:5b6:10bc:dc47 with SMTP id 2adb3069b0e04-5b8d2945a50mr296458e87.30.1790055307602;
        Mon, 21 Sep 2026 22:35:07 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:35:05 -0700 (PDT)
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
Subject: [PATCH v14 09/12] mm/hmm: implement rollback for device page migration in HMM pagewalk
Date: Tue, 22 Sep 2026 08:34:18 +0300
Message-ID: <20260922053421.4092027-10-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _BV1NJbELnQwRz2RV-FELB29xlcmxc2t561W5UeWq_E_1790055308
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 05330C0008
X-Stat-Signature: jnnw3wmjf881wtuyywqca3zjn43j8deh
X-HE-Tag: 1790055311-955550
X-HE-Meta: U2FsdGVkX1+VyYSaDfj4XQ85AH6J2DIRg14LA/FI5Ve7FjSAJHVnE8IZiBKvUB0+CZJeF1x34MnjJBzYOTrTbaqcTpjvuWXU8Y4vtIJQ2xtqR8zVU4oDfpOGyhnREr9P8UzLi/V7QTGIP7StVJwZiHnuXo6FTiSypTRaFiF2D7lL5rGYuOyen6LcToiUM1IpQ5lyWZCmYOhDMhXS/Y4RGqeOCpiYDig7BpKLyh74gcMaQkM/RTTO25ZkYFxk1LM+tKBUSkGQJQdbN2icO507vD/QXwgzmeBxPwwWt3nTGwgfB96eqJyB7kZ9XQXIh31yK1aX5CIciI90Go+4N8BFG4xXhxgvMuhP4SrEve9sfzhzNuDCuNqorNAcjGJedjs3zh6RGds/sBvxDW7PYGTpCd7y7IRDDMrIa4sG2qsrv2RlakBdQHWEt0/ANAiXS5u/saHqsgk1S88pYatBIhKCsR0Hs340H7P31sMfkxmgkEnilxYmJCqn6ZK+c2yZbDx1exjvJwtQ/oCETky+b6OLYBqKu+L3mbsq9aQDDiIRRkK6y55k9PtgywHLHIu9Lu0A/4m0bnSWPwfhtPW0hzlxLA7VoTphQTsFOBicRwcHE4jRjNWYUIqA9XmTGu8NIQJCG9uN1mF5i9vvH3hj3qTxL+S7iSmuzJYsGKfTcDunzm4SMf6h6aifj0kEorvN57OKIPenCKy8WjSaR1NuFjfqw6zQ2lmD0q9ETnrIAZGWZhlbas2AOIZJR0KfzIgXwIAL6+JAZezhti9JffOcxo0k9BLA7SvgZSFN7a1nsE/cXzhKXDvR0ebQCiNu2ItCUTEWy5FthHxW5Zqaa5AFfjO5wPpAXLai836oGA8BXpj3D9XHBse5dJiUyytaVdB5qs3Fapml2/RBOaOsxAVfGjJzDIY43qbpv+n9Fs8k1KrILFlKNV0vVTsJpuNWXaRz361BQ3MlzKOIX7kNZtNppLf
 UYvz0p01
 VlKUb3naWxRjx+qfKzwNYRoG/gh3JL359wqAcMzkSu0q30YU892wKkZdg6xgKirNu058yLq0AWYnaCAcgs3pbut2RXpzAuocOOEC8Scq21zb6Io/CvZ1Kg9CznPqNvMxLydinBZ4wz90QX0xhEEuBqmCje4hPjfB+XBpffgoE+wUkAvzoOzovfF06qmSRSzYjIHRJgGkKVMSHCklx7tPtHc0f8zpXYcGyUeu+/mO/gYbd7pxwuuUX83dLOcy33jWwU2qcbJCETDg3vh/p99awLg8HBzlWQ3BA48kv1jgMCDK+dlzugcwS51jQzFmn2B97WyWlpcbgkYGB0OaAmYUm4kpAdU9peDWyBBhoFSJ2MXNPHD+ynJZSuQxKX6dw5ObSa2fzkM8twJ+f+RxHYv9dOzlj4A9P6xIy50WL9AsGRBAhJz8sL/F/5kPhOQgnvseCul9F2t66NpeDwzk6H5wDsMlnCn2nqCFwDRdXjozX88+i2ExP/IeBQaIO0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

During the migration pagewalk, the PTE table could be cleared
and/or changed into PMD leaf or even another PTE table while
dropped locks.

In these cases the possibly inserted migration ptes are gone.
We have to however undo the collecting done so far, so unlock
the folios and drop reference taken.

During the pagewalk we notice such scenarios if going to
recollect a pfn but have already committed to migrate the entry
with HMM_PFN_MIGRATE, in which case rollback.
If we encounter migration ptes they are just skipped to
allow for restart own walks.

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
 include/linux/hmm.h | 22 +++++++++++++
 mm/hmm.c            | 76 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 4f56f3419cb4..b08ebc1343dd 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -111,6 +111,28 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
 	return (hmm_pfn >> HMM_PFN_ORDER_SHIFT) & 0x1F;
 }
 
+/*
+ * hmm_pfn_collected() - is this pfn entry prepared for migration ?
+ * If collected the folio's refcount is increased and the folio
+ * is locked.
+ */
+static inline bool hmm_pfn_collected(unsigned long hmm_pfn)
+{
+	return (hmm_pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) ==
+		(HMM_PFN_VALID | HMM_PFN_MIGRATE);
+}
+
+/*
+ * hmm_pfn_rollback_collected() - undoes the collection of hmm_pfn
+ *
+ * Note for total rollback the folio's refcount has to be put
+ * and folio has to be unlocked.
+ */
+static inline unsigned long hmm_pfn_rollback_collected(unsigned long hmm_pfn)
+{
+	return hmm_pfn & ~(HMM_PFN_VALID | HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
+}
+
 /*
  * struct hmm_range - track invalidation lock on virtual address range
  *
diff --git a/mm/hmm.c b/mm/hmm.c
index a67a23e54551..e64444cbc62a 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -93,6 +93,11 @@ enum {
 			      HMM_PFN_P2PDMA_BUS,
 };
 
+static void hmm_vma_handle_migrate_prepare_rollback(const struct hmm_vma_walk *hmm_vma_walk,
+						    unsigned long start,
+						    unsigned long end,
+						    unsigned long *hmm_pfn);
+
 static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
 {
@@ -109,6 +114,8 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 		}
 	}
 
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr, end, &range->hmm_pfns[i]);
+
 	if (migrate && thp_migration_supported() &&
 	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
 	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
@@ -280,6 +287,8 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		return hmm_record_fault(addr, end, required_fault, walk);
 	}
 
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						end, hmm_pfns);
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
 		hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
@@ -410,6 +419,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 	new_pfn_flags = pte_pfn(pte) | cpu_flags;
 out:
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						addr + PAGE_SIZE,
+						hmm_pfn);
 	*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
 	return 0;
 
@@ -448,6 +460,9 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 		if (softleaf_is_device_private_write(entry))
 			cpu_flags |= HMM_PFN_WRITE;
 
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+							start, end,
+							hmm_pfns);
 		/*
 		 * Fully populate the PFN list though subsequent PFNs could be
 		 * inferred, because drivers which are not yet aware of large
@@ -550,6 +565,48 @@ static int migrate_vma_split_folio(struct folio *folio,
 	return 0;
 }
 
+/*
+ * Due to dropping ptl locks for splitting for instance, would we
+ * overwrite already collected pfns? This could happen when pmd
+ * pointing to a page table has vanished and been replaced
+ * with a leaf pmd, or another page table.
+ * In that case unref and unlock the folios,
+ * the pfns of which were collected from the disappeared
+ * page tables.
+ */
+static void hmm_vma_handle_migrate_prepare_rollback(const struct hmm_vma_walk *hmm_vma_walk,
+						    unsigned long start,
+						    unsigned long end,
+						    unsigned long *hmm_pfn)
+{
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *fault_folio = NULL;
+	enum migrate_vma_info minfo;
+	struct folio *folio;
+	unsigned long i;
+
+	minfo = hmm_select_migrate(range);
+	if (!minfo)
+		return;
+
+	WARN_ON_ONCE(!migrate);
+
+	fault_folio = migrate->fault_page ?
+		page_folio(migrate->fault_page) : NULL;
+
+	for (i = 0; start < end; start += PAGE_SIZE, i++) {
+		if (hmm_pfn_collected(hmm_pfn[i])) {
+			folio = page_folio(hmm_pfn_to_page(hmm_pfn[i]));
+			if (folio != fault_folio)
+				folio_unlock(folio);
+			folio_put(folio);
+			hmm_pfn[i] = hmm_pfn_rollback_collected(hmm_pfn[i]);
+
+		}
+	}
+}
+
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
 					      unsigned long start,
@@ -693,6 +750,11 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 	pte = ptep_get(ptep);
 
 	if (pte_none(pte)) {
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+							addr,
+							addr + PAGE_SIZE,
+							hmm_pfn);
+
 		if (vma_is_anonymous(walk->vma)) {
 			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
 			*hmm_pfn |= HMM_PFN_MIGRATE;
@@ -740,6 +802,10 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
 		pfn = pte_pfn(pte);
 		if (is_zero_pfn(pfn) &&
 		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+								addr,
+								addr + PAGE_SIZE,
+								hmm_pfn);
 			*hmm_pfn = HMM_PFN_MIGRATE;
 			goto out;
 		}
@@ -916,6 +982,13 @@ static int hmm_vma_walk_split(pmd_t *pmdp,
 	return ret;
 }
 #else
+static void hmm_vma_handle_migrate_prepare_rollback(const struct hmm_vma_walk *hmm_vma_walk,
+						    unsigned long start,
+						    unsigned long end,
+						    unsigned long *hmm_pfn)
+{
+}
+
 static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
 					      pmd_t *pmdp,
 					      unsigned long start,
@@ -1142,6 +1215,9 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		if (ptep) {
 			lazy_mmu_mode_enable();
 			hmm_vma_walk->ptelocked = true;
+		} else {
+			/* The pte table is gone */
+			hmm_vma_handle_migrate_prepare_rollback(walk->private, addr, end, hmm_pfns);
 		}
 	} else {
 		ptep = pte_offset_map(pmdp, addr);
-- 
2.55.0



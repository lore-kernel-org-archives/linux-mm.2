Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13EBFC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8754D6B009E; Thu, 24 Sep 2026 02:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84CAB6B009F; Thu, 24 Sep 2026 02:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73BA26B00A0; Thu, 24 Sep 2026 02:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3C66B009E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:54:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8BC84026E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:00 +0000 (UTC)
X-FDA: 85247741040.09.DD6C0FA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 73A29C0007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gbcjIu2c;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JpYqOYoRlVZdrcLlVTpkBL4vVH/KqUerRKv2x17E1pA=;
	b=rMqZPYSGaTBDOEKxxkFdpRzKggMT7Bj0ZfjQ8GYpwGP2d+8lrwPbyruK9sBR0Bc8M2buY6
	6h76V7BDSXUe0BvRcqsX6EeCDE0WOLQhvA1f7Y+l3isAafdkcOFuVmWjfTg6YNmYcT2ddA
	iM7G1lTLQfeCsuAEMG+va1LrpKnLWL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232838;
	b=BGoup9jqqTUcRpb7qweW0sq99Nq4MiHLRRPFeV1NoNGbQiPBWR29eu7QOC7B7CAsOnvv6q
	O0WPADwvmrbBz7DoIhEkOsqR3LoP7xGg0WanFzZWWceORVtIxrI+bpSW70zX8kc4yxxpAb
	PwrH3csngrrridYBB26zC19hZ8cgbJY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gbcjIu2c;
	spf=pass (imf28.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JpYqOYoRlVZdrcLlVTpkBL4vVH/KqUerRKv2x17E1pA=;
	b=gbcjIu2cykL9bbMtAN1SGD7cXtnE0S+ugYJeeUHdwR+79J0DCx8IlF9vnpLPnxGFToIIhn
	P/KFxhTYUYvm/fgfsc6LUNMRMX8f4Z8/9B8KNTtYRfhoJwexjBRtTPt+tEn6QOiJcJM4CE
	7cy5KX1ZfjFFOEBPTFZHZus6DQ9bDVA=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-2Vfy9sQpNoitQK-xRTvinQ-1; Thu, 24 Sep 2026 02:53:55 -0400
X-MC-Unique: 2Vfy9sQpNoitQK-xRTvinQ-1
X-Mimecast-MFC-AGG-ID: 2Vfy9sQpNoitQK-xRTvinQ_1790232834
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3a5b062d0dbso3518701fa.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232834; x=1790837634;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JpYqOYoRlVZdrcLlVTpkBL4vVH/KqUerRKv2x17E1pA=;
        b=lrDnnYCJuTfciE3b3Q41TZHeNRjkxj19I3WKQ3r4PwYaKawF/XjW0RMvyM5liWCClx
         XODQBGdoLU95iy05bv0leP9uUw37SisPJEf/mMXMM0UNGSzPcC1lBBlU615tk5eBoFNe
         YzeGw2il4dbSt5hJ1h04kRSTJbdkxzQf62Bb2UbGIhZEjc0op95P8qPfsPjXmqDZiGqF
         lIFHYvqMScBdP8YtdAW4x5defIbY+cwBDko+k2u3/tFszc4Y/3TklgtjeeSkrsjwQeF6
         OwpqeUku5qCSyfiTMkE9VsllJ98Du1O4MrbkpkmD/rmwz6Jym+JUQaEu87SX1DKNZeFz
         UnnQ==
X-Gm-Message-State: AFuF++kdLWOlmagtZtdrUp4b66JwXEBe8ZYN2engh6RXfjEqqqYmAucb
	W2KqUY/QNNTR+bdH23vLWIyW23d2r/9Rk60sFzq7sJ1yrbMWxLrGE2coRU9XXBNmjg2zNe+riN9
	h1HDjh/LmyPPb8XXEWt7vIHXtK8eMHyxgvOnSN2hF/PrOLGeAobIOa8F/m+tLOXce/8L5NpyYLh
	fe+KsoUgke1YUUt9KwXdgqT4R4C9itd9ODhUk80w==
X-Gm-Gg: AYBFou0c1LWfeISVxyIsrl3DzkVgeJSQsdM+2pzcA1QMO6G9XQmHHg4cEVgni0DDU03
	5DY3u1zcpvgdCWJORybaO8sMYFJyO4M0AVQyyVfaP4md8gzsRo2nfKT4rCdv4uybGiRGiUE5/Yh
	rZuU/qzHDhvQ/h3+xZoRsLJogeCfUA5ErtpfzLssTKC1CUHvtuz9Mfxqx4VuxOFFnCMHncoHL6H
	L3y662VsVo6pBxkwXCu0HlvhhyjAi0AuVMpzLomacRhVHtPQO0US16AWnnO5lmHWqay8o+LTKRv
	+Y6oBrM4UwrNGF4jkXV6ChP4J2Cfd70+f4k8b8tLnvFk0j0xTi9VS15HX/066JmB+BKJ7KYQo/r
	cKmK06HpvAnX6mh2eJjc8
X-Received: by 2002:a05:651c:54f:b0:3a4:9881:8de0 with SMTP id 38308e7fff4ca-3a63bf5cf4cmr3206711fa.7.1790232834254;
        Wed, 23 Sep 2026 23:53:54 -0700 (PDT)
X-Received: by 2002:a05:651c:54f:b0:3a4:9881:8de0 with SMTP id 38308e7fff4ca-3a63bf5cf4cmr3206461fa.7.1790232833678;
        Wed, 23 Sep 2026 23:53:53 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:53:53 -0700 (PDT)
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
Subject: [PATCH v15 06/11] mm/hmm: migrate collection in HMM pagewalk - pmd level
Date: Thu, 24 Sep 2026 09:53:08 +0300
Message-ID: <20260924065313.899730-7-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tThgX7YoYSJJHuX-I7lZs6RYuED4pLbcZifPehkjArI_1790232834
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 73A29C0007
X-Stat-Signature: dip1hwhuy9m8744ntzywbpzf3orarxrp
X-HE-Tag: 1790232838-784303
X-HE-Meta: U2FsdGVkX1/ahqWu1LAo/EAW8wc2A/VFX8V/a2nZkd9V1Jj9xx4Boz+rLz9T8d8h1mzIGCbVHpM1VWjXGiUV7PyDxIibtFEgrGb8YwjtiIisY7dSZ1aXDOauC1ixhP+GPtK9SF/d56e5SSprCkdZ6X3Qwl5itJDjTeifaluF/L+OGfEGc/3MGhxbDer0bOSGjlGXxppcSMlj3YTdyjIEb0nuoWzywLF+qtkPuW2m1lleidDXqK2+fOW7C3DLWvYEiqkjU8vwtWDyCDm5oNIn2E8BCRvsN/e4K0BbtRAv857V5wb3wslvsYIjV1WOQlu8zrQFK2/Dm2eI4QB6+LcFOit11wHG5RTBXs8+KLekz8N1Zi1ky/BESdnxnTE2O5IBCF7jmv8A771PEMAW2Ox4zeoxU73a81XB5Ixoi2SvsecOo2wrxxfTzoBTAgyN4hfCp5eLJj7a2x+PtvTBiJmLxX3bZKOMXIVK9v70utFt1GYifx7r5AgU8wyTvRGyFJoWAQb5ST7YAk4ruYtPybV88v4foWVTn982uJ0EI5851CT28Nz4RisJ6KtCFo+U2JzER/TNKMv//BMxfgiY5md1/bTzN7YIFkhC85vvoxeR7dvr1b/+5IHm6/Qn3hYtoJEZ2eWp+numf0lr4BCY670Wlbli+knkJkX/8niAD3d9+sh5d89+meg5CRFSbnBtrLncvA9JD2gSC312LjeNsX78XwLcFithweI13yobLz+THV8mBtBWT0oJwTityQWYheKTH5Ob0BnZM021/rtykGh3tTqI7wR0PsFIEOuGGQLALXPRYTa7iCKuD53ZiIl3ojNDurMKxyxWBodlTpfmVuQFmT0z6Ktuoszs3d5gmCb5RHnDCSWZ7KWhoz4wH1WD3uSLNUxVjc0x+40J6nQUSd4wP1sJnelBDxtX8yy4+qT4SsZomcGgQhKDrH14DI7vHjQkYBHWISXBqO2ngM2BQo/
 6FSl2vp9
 6VnVNAcWyu3tFATrCzHcQSXIifrWetO7UJHIXN/r5y8j/RuZP5laky+6SetdQOn2O9kAr2t8A9J7gYCqbGOKXxwNRcSY3cjiOub5lY3H27/t2kSO/b2uYgTr48Zc1cn1jsWEot6qG3JH5s5gKnTnkfsDqCbLiItGLqkEtw0WCMyYWnjh3ZA/BxJ+Otr8liNog2OLW8gB16h/aBsuVfQMLvJyALNu9YdZ6EdNZTzL9GuPc2xeiIBJPaH2ZSyXszGoLzganJ6wgPXFl++D+k2Z65qtbbRAeS6FvP8MxEmpYwy2bdoBQ17kDvmeBIAoruytWb2xBE6CNwasut3Hl2c3DbyZN8/JmZHKWo15qlR8Ibro659TFKLQCo51qCACsCzfFruvoo55qJ5k5Zq2pnHqTGYNKmoUQg1lHbEEI55kFmhuZqD6hcLs9iaOX6hLC/NGVY88vg5MsMGU4Atl5TQU3Pewb3Bt5dHfQbbM1pQcOuf9AYH+HKWQbW45zVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Implement the needed hmm_vma_handle_migrate_prepare_pmd() function
which is mostly carried over from migrate_device.c's
migrate_vma_collect_huge_pmd() function.

With HMM pagewalk based migration, the idea is that
hmm_vma_handle_*() are responsible for faulting,
and the pfn collecting part. hmm_vma_handle_migrate_prepare*()
do the migration decisions (with HMM_PFN_MIGRATE), possibly split
folios, and insert migration ptes/pmds.

HMM pagewalk based migration is enabled in later commit, for now
now hmm_select_migrate() returns 0.

Also avoid the problems present in the migrate_vma_collect_huge_pmd()
split fallback path this HMM path supersedes:

      - extra refcount for fault_folio makes split_folio() fail
      - wrong folio unlocked after split_folio()

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
 mm/hmm.c | 173 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 151 insertions(+), 22 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index a60b66963049..ea77429c5178 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -492,31 +492,19 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 
 #ifdef CONFIG_DEVICE_MIGRATION
 /**
- * migrate_vma_split_folio() - Helper function to split a THP folio
+ * __migrate_vma_split_folio() - split a folio and move the lock/ref to the
+ * order-0 folio backing @fault_page after the split
  * @folio: the folio to split
- * @fault_page: struct page associated with the fault if any
- * @hmm_vma_walk: walk in progress
- * @ptep: pte_t * for unmap and unlock ptl
+ * @fault_page: fault page if any
  *
- * Returns 0 on success
+ * Returns 0 on success.
  */
-static int migrate_vma_split_folio(struct folio *folio,
-				   struct page *fault_page,
-				   struct hmm_vma_walk *hmm_vma_walk,
-				   pte_t *ptep)
+static int __migrate_vma_split_folio(struct folio *folio,
+				     struct page *fault_page)
 {
-	int ret;
 	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
 	struct folio *new_fault_folio = NULL;
-
-	if (folio != fault_folio)
-		folio_get(folio);
-
-	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
-	hmm_vma_walk->ptelocked = false;
-
-	if (folio != fault_folio)
-		folio_lock(folio);
+	int ret;
 
 	ret = split_folio(folio);
 	if (ret) {
@@ -548,14 +536,145 @@ static int migrate_vma_split_folio(struct folio *folio,
 	return 0;
 }
 
+/**
+ * migrate_vma_split_folio() - drop the pte lock and split a THP folio
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
+	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
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
+	return __migrate_vma_split_folio(folio, fault_page);
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
+	enum migrate_vma_info minfo;
+	struct folio *folio;
+	unsigned long i;
+	int r = 0;
+
+	// Do we want to migrate at all?
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
+		if (!softleaf_is_device_private(entry))
+			goto out;
+
+		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
+			goto out;
+
+		folio = softleaf_to_folio(entry);
+		if (folio->pgmap->owner != migrate->pgmap_owner)
+			goto out;
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
+			goto split;	/* fall back to splitting the pmd */
+		}
+		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
+			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
+
+	} else {
+		goto split;		/* fall back to splitting the pmd */
+	}
+
+out:
+	return r;
+
+split:
+	spin_unlock(hmm_vma_walk->ptl);
+	hmm_vma_walk->pmdlocked = false;
+
+	/*
+	 * folio_get() above took an extra reference. For the fault folio the
+	 * caller still holds a reference and the lock, which is the
+	 * precondition of __migrate_vma_split_folio(), so drop the extra one.
+	 */
+	if (folio == fault_folio)
+		folio_put(folio);
+
+	r = __migrate_vma_split_folio(folio, migrate->fault_page);
+	if (r)
+		return r;
+
+	hmm_vma_walk->last = start;
+	return -EBUSY;
 }
 
 /*
@@ -958,8 +1077,18 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			hmm_vma_walk->pmdlocked = false;
 		}
 
+		/*
+		 * hmm_vma_handle_migrate_prepare_pmd() splits the huge pmd in
+		 * place when needed and returns -EBUSY to re-walk the range as
+		 * PTEs; any other error means the split failed.
+		 */
+		if (r == -EBUSY)
+			return -EBUSY;
+		if (r) {
+			/* Split not successful, skip */
+			return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
+		}
 		return r;
-
 	}
 
 	if (hmm_vma_walk->pmdlocked) {
-- 
2.55.0



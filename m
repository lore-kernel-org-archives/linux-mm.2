Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D069860A4ACE
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Hv398Jdk
Received: by kanga.kvack.org (Postfix)
	id 75CC06B061B; Wed, 21 Oct 2026 02:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6A26B061C; Wed, 21 Oct 2026 02:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FE96B061D; Wed, 21 Oct 2026 02:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3636B061B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81663A7CED
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:45 +0000 (UTC)
X-FDA: 85345597050.20.15F5B0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 416D4140005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hv398Jdk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/7lyMAdO8fpbuawopvTUkUgysPqZTh82lxmIkmlslk=;
	b=TukMNDvw0BRdy/7hGyyVU/ExRkK2HCdjZ9pB4e77Oe+wPifKCH6bSTaicsIoWjr43jw15W
	ZvAg9iIm/lfkZq0iJO0EgONDuWrkojCdr3KounzXTUMIiWXDsRpANerYMsbioGaoCigH/E
	BQ73EvvII8f3g9gOnYSuY1xrc0NnFtY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Hv398Jdk;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562743;
	b=ypH1f00w24ZRbBYWxayRwtjqdbieXllv8Iv91rg4p1p03Jd2Hlt8n+sljbatm7JQo/gT2k
	mDo33L19H5xkByI7cLYU1vNgPbprcZi1cSewLKK7z0LbQYC/0h3OP+N9h727bJn2ZkOBKX
	fm1ivUD/o+GprlHQwKaLoY/Ab1Y+P7k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/7lyMAdO8fpbuawopvTUkUgysPqZTh82lxmIkmlslk=;
	b=Hv398JdkaivMdNbIkFYLQlLP2GluPez2sNWPUMtfioGdX6fGvKMw+zMMgyuSVEdCsT3f7H
	QsyM3yPQD3JVlOwp8UYOhAdP3h2jBT5CsmJ7puSAAEnT+4OCCCL1XNZxPrHP+XLTjIoShp
	X4+Yp0/hMRKFUYRuZ+1eGDPrkrqHk8s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-316-fEnvGhJvMZOoR66e0jMggA-1; Wed, 21 Oct 2026 06:05:41 +0000
X-MC-Unique: fEnvGhJvMZOoR66e0jMggA-1
X-Mimecast-MFC-AGG-ID: fEnvGhJvMZOoR66e0jMggA_1792562740
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a1dec05668so2433315e9.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562740; x=1793167540;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p/7lyMAdO8fpbuawopvTUkUgysPqZTh82lxmIkmlslk=;
        b=CIXvSHh9XMxI0zy59Yjl5v54tZLeBF7ZYh1vDlIaXscvjMIoBQz2ZXo9muFOcwPkrq
         g3nTp59dD+KeK8aYC9pfyRm/xXxsEcehekiAD1BRgexTkQZQNA0tF2XaysGvltV39K6y
         hvGWcN/k3lImuqCyZKobo9YmehhUA59toyai1VNxqq58gtOeF9Dzdzs6YFw8kWzNXKSh
         j4tqJSCgpIxvKD2jTNp1WFQWqqqGdaRUyxNdM1VSE6ZFLd9E4u0XN0BDIiylG5MXR0nY
         RcPpy/oCQxRvlvLdsrLYoCFjUkFP8XP88Pk2SR4EZvjzgBLtXgZobi34pxj209AAx+G2
         ej9g==
X-Gm-Message-State: AFq9FYI4ANOrjqtGjlHL0/U82cCcqQ6haOCp+Z9M/GoMdlMeKwfYqc1h
	6uf0AiY2zZP/sBnlMBhYl1WxR2znA84VtkMBJgU4b+dNM1KsTPW5yUvQgefROqBoMzmmP1lW3or
	Prz6p0Os29qHYXxJr+I0ySAc/KIFhUKgJNjB5oSkGnd/5zyrJpO6yIKhgdWxNTtOmu1i8oaf/z8
	OeaNJYjzGZ6twb+uob4gbeQkZXOnqbj7VptgXutA==
X-Gm-Gg: AYBFou2hqfUw5/M3c2ZsFNFpwiFrgqI864CAGy6g6wrJINVF8Zxl9km/GtuzPkPg5Wy
	8NqlLc5BgiscJGyeKQFR0iOWkaVXWMos9Ijxy2uVAuaUDW8YMInRUcVLHsP2FJyXtrYLM7DgEdT
	7xI0+hlAL7hyEnHgjUKSvuudu9E3wuuQxMmARG2WdJZbJl/g6Cj1ZxQQrHvmBwe5nf1RK9z3kBL
	Hd+nojyXCcCYHcNJOEPh3pv5A3hFdjBT9fxR3cNcS8XGhkQJOnWxzXCuWHQCVfFGNT3cB+Q39ji
	J08rqjLwa2mrcWMoxWqC9v5gkuANU8pdLHz+AlxptWF7ULkJt32iyIx0LQMQpTdI6o8tBN28Pq3
	sxVQnN3F2s+HrfcVDvYtD0Z4dLLw9PLCp9auN
X-Received: by 2002:a05:600c:4e03:b0:49f:fe39:5bc8 with SMTP id 5b1f17b1804b1-4a1fdd14200mr14867985e9.12.1792562740332;
        Tue, 20 Oct 2026 23:05:40 -0700 (PDT)
X-Received: by 2002:a05:600c:4e03:b0:49f:fe39:5bc8 with SMTP id 5b1f17b1804b1-4a1fdd14200mr14867095e9.12.1792562739786;
        Tue, 20 Oct 2026 23:05:39 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:38 -0700 (PDT)
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
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v16 06/12] mm/hmm: migrate collection in HMM pagewalk - pmd level
Date: Wed, 21 Oct 2026 09:05:00 +0300
Message-ID: <20261021060506.2377545-7-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4Gb5yeSs9NIhyAh4im9EkuOR48GMNTjiPyHPNt2zrtk_1792562740
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 416D4140005
X-Stat-Signature: qugyy7qtnyo7dnexyjkru7mzzuqruq8q
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792562743-829910
X-HE-Meta: U2FsdGVkX188JDRohgXYGbWeyv1BSTgCQ80ODPVSPc6ePzRn2TDMdVVrO43xwJN9EZmRNmraKw0u/HQFfHWu/ki7OY/rKh4vV4DL3WqKwo9fN/xhD28Y+COj0weSDEmd/2iX6NkKiolNGD3CZvdmwy5JB+NKrRuDX9HhNdP582m12JEnlq5CeCkZELjWBepmCKXtVTer0JSXOJE91cR3utXyMfPUdday9GsPycC8AVwbq5FCP1plviUJrwCf82sCO5L+tJEZHWvwNoChJV5bjwaeQ+4PCyarQvYD/gL6B5TDHWZTwhdX42mui/No0gAja07YYWIf71iNXaIxwwJiAnd2Min7YIle4WtqhkOIfBZpR3vksQW/Je/BZ3ROzB2rc3bS2kpiwSBwYmIGG3kTdnjiy19ZVbDta/KsMdz5/mFRKD3m2x8QHJV+S3vj7zQ2gRAuiMZNkyzxQzHILF2IQaVCCORy0h4M67m0VdfA2bKYSVl4cYKtkvAd5hbbaVpqummbdtOfDI7QRtaqYAewi1k/a5kV4y5xH68WZT5KOgiTr8OnTFGNJqCKWztd6xu88BZGFLoe4sW14hn3Bo65jg5vUpHuDDogdh4+7fZtq/7OONMbieGijgP1clF29z4OLfdWNCxTidQx1XAYEWQkcr1VBM77/LTFYRtoP46cUMobs9FpUaxQvYsyiQ+LHLbu0KU1YjKoQzTojoAq5XXfkU6RXPuOxMIV/DNwXUXYGUJ/+SoJY87B/hQDiE2+3jX9N56UnPc7OqtFr02/uGdohw43jvYzgGdWIhcISniRs4uzgKlvfJGzWX8YS9VBffxuhHVy9SLJQsDVFbnI8VI5+Lva6moJj3knFB8AIaeQGgoPJa2GV+5Y3iRbgVYukmyHymnNy+ecsuzQDF+brAWpFn0GzP88HfaA8UvS4+9AQadIh2gsvQ5mnN1PlBV0mk2yNBLRHWzngcOJ0w65WVO
 DU4Oll1F
 haJSYsQ7oYA1dmOLQyYO/1NYd6xI0rG/1MiLLU6MW4XK7ikuQf+aaZOf9LZJyh77V2AZXhCmMoiVFtoGKiU9YLCfogRLYkYZIpIJS3vCE84oPkDX+Ch8LLh9gflFXkeYup/4i9FJoB5e2XF7WJPr1ZIqwT9RUm8tg39p7C3TJgLiBvDqB3sJJD4soMXOZraes3HGsxlOodWUVgwxJ2Xrv5hm/Y40GEPTmOX7E5/2C/m7mPiQfZPY2H6fC0e9QLmKt4rqlhi77Uy2BXKVWkZxXA/wJC3c+3i2LKAKTN/innyxO/fv0hiBbN+z50AmPBkJGi+wMnIG3ZoHCq5IOZn39UrZ3lTaPIGRvsIMQQAwl1W0XzN0R8VmwEQvuqqPebBPNwtY1Ytw6vEtIlkFUnDiUrWFdKWdSMAlxAB1TIVOOnOMYJtZjsNjCO8MErc4zRFSqVUteGZ0vTQtUWG+uZ2gk/Pp0l1QBzF/35pVA5B7occqLZanNEpu/SD1/BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

Implement the needed hmm_vma_handle_migrate_prepare_pmd() function
which is mostly carried over from migrate_device.c's
migrate_vma_collect_huge_pmd() function.

With HMM pagewalk based migration, the idea is that
hmm_vma_handle_*() are responsible for faulting, and the pfn
collecting part. hmm_vma_handle_migrate_prepare*() do the
migration decisions (with HMM_PFN_MIGRATE), possibly split
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
 mm/hmm.c | 172 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 151 insertions(+), 21 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index 0ce947d0e572..5891efee3e18 100644
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
+		return -EFAULT;
+
+	hmm_vma_walk->last = start;
+	return -EBUSY;
 }
 
 /*
@@ -958,6 +1077,17 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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
 	}
 
-- 
2.55.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16554606A33B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=NTC+qGUL
Received: by kanga.kvack.org (Postfix)
	id B7B5D6B0619; Wed, 21 Oct 2026 02:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C9A6B061A; Wed, 21 Oct 2026 02:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9965F6B061B; Wed, 21 Oct 2026 02:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8DE6B0619
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:05:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0D64160467
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:41 +0000 (UTC)
X-FDA: 85345596882.17.071F5AF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9BB2E2000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:05:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NTC+qGUL;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtRC5DeWJYXLXVRSk50CDnIivIc/S25arUI35Q6dKwU=;
	b=TeIu4ONpxbgXfvfArZqutBiiGnyU8XFGRNkBU727SPWE2fOyPEJ10fGP3dcNFfncEC9D/r
	CMBze/S+f256bp4Db3v5olAugDh2z0LtwPn/zPRaz0Jm+KE0zZL/7YNVEBiZrK2M5eg5JR
	zNj9kzIzdGctKaOkyIlCVkJtvY1Ugv4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562739;
	b=SyhGi9R+XwYXRXGzHe+4J6IkmShSnZRXvxuqmEPrH3ON4rpid1G5ZpEpFZe/hdYjOPC/EF
	Fhxc/djon0X+a0cL/6tpgR4cqFxIwPDjhGm7WH9UFegVcLlogu0cDo+J2HhV63CIhfMSnU
	V4GW4EAAGZ9b40TsfNFQuOzRvlCWYic=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NTC+qGUL;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792562739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gtRC5DeWJYXLXVRSk50CDnIivIc/S25arUI35Q6dKwU=;
	b=NTC+qGULGyNZ6mqe7vNgM44F3ixkEFm48cOWEanCkiCsWzue+M3Vgc6y3Z9Zy9V5g3Y2WQ
	1OfYiCHbfG9OR2yWWmJ3I1kPA9lGfioR0qdJAgoCjnQEBGObOAatx45pmDBO0z8ElOeumn
	O6rYhfbQHhdKMAGHzdbqIoebtJCotb0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-489-3v9BZ6KyOwW9P0HAMS8rIQ-1; Wed, 21 Oct 2026 06:05:37 +0000
X-MC-Unique: 3v9BZ6KyOwW9P0HAMS8rIQ-1
X-Mimecast-MFC-AGG-ID: 3v9BZ6KyOwW9P0HAMS8rIQ_1792562737
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-48e17d30a79so185075f8f.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562736; x=1793167536;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gtRC5DeWJYXLXVRSk50CDnIivIc/S25arUI35Q6dKwU=;
        b=qxoKXDIfpQXOpOSndMdh5j6lNe226ss8FbAm89tYkAzh312yUA+uI4HE97PBZ3Q12S
         GeQi0LKLpSdStHZJcdej/SylJMwZXSZ0PImQBtw196BriHN+Q6U5kg1ezyAAFbK0VamU
         jurz4ydFfiyo1wgYcSofGg4njNm8yeD3eQsnexsS16n0087BKpJUl8YLVMBPXaGRAA/1
         gJVLvIY+1D962tFjXD6B39thsemUlMshe5bsn9pphl9GZIJRoeyqoC2KDcymCQXs8TtV
         zyzWLubLCml8oi3TV8aSDpf8tf1a6EU196miGGR1jV65BBT0UgADQwnS3eQNRE8VHQ3Z
         NKUw==
X-Gm-Message-State: AFq9FYJsFaqovS/GQWsHGngGyjrSRVKxPDWf+WZ0SwDsCn3q9N8iVGta
	XWgK4DcK6SOSMGqFbeAIXGC3buczr/7fWokzEDljGsYv0y9BJDUG53dlqvW0YbOET00sscd5yio
	OlrK1kb95R8QXo7Fxzs6XprNOLO+naw/h6B04z0vbSxf219GGLX9nrrjaEonQ2A6dZ7vSkUg9oa
	sA83EumIJVqTwrylhz6cfYAciORR9xJpTq0dFymQ==
X-Gm-Gg: AYBFou1CNOZJkes2j9j44MZ+PSqGhRGQzLuOCUx3M24aSfBrMMtcnmDuvDbwoTzvZ5M
	UT70IKGdr8k0l5GhyeuRDiHgBRBnmAjEO1vZFWroxzM0NsmNood1ZqjARSHfnTcgJnEeZCuZLt9
	WIwK3XUFKcYZfAAnE42R/rQY+lLXQx0tjznhalQzeMXxKQ09qc6KJNRhG+2ftRExBbJGxtOUkYO
	BEdhB9kZIUvlign5M5ftrfmNI6j6FmXntcOHI1Zr0BzdGD7OM24xjRVZodpPDGxawbDxFW1sCk7
	twMAwwbka+ON9RpzCRx0f6dKJHMkOvuTUIN3nfsX98DFo3j4E6dH+3YLA4yYw2a8W4t6oeFmx2U
	IYPNNCrux4Zpqc5+O7kAsT5YZ249Ike1aBBVf
X-Received: by 2002:a5d:584e:0:b0:48e:f07:160e with SMTP id ffacd0b85a97d-48e264f32edmr1555661f8f.38.1792562736524;
        Tue, 20 Oct 2026 23:05:36 -0700 (PDT)
X-Received: by 2002:a5d:584e:0:b0:48e:f07:160e with SMTP id ffacd0b85a97d-48e264f32edmr1555593f8f.38.1792562735959;
        Tue, 20 Oct 2026 23:05:35 -0700 (PDT)
Received: from fedora.redhat.corp (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e254f02f1sm3413741f8f.3.2026.10.20.23.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:05:34 -0700 (PDT)
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
Subject: [PATCH v16 05/12] mm/hmm: migrate collection in HMM pagewalk - pte level
Date: Wed, 21 Oct 2026 09:04:59 +0300
Message-ID: <20261021060506.2377545-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261021060506.2377545-1-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mq2oZZt7gh4MYTdf9CldqOo6rFg7hPqE62xYXsU8lOI_1792562737
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9BB2E2000A
X-Stat-Signature: z8utewtgtyckcag8ytxqrd95pzp3d9sb
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792562739-538623
X-HE-Meta: U2FsdGVkX189cbplXfYPKwdGgtBNCuf67BWtotgEp/M6oGH8IPvDtiaULDSuFk+JBls/R8dCcK7g98h8hhqO13CFWFECBGnDTKiP35sQL0fvOx2s8EoU6P1YM2AFDmIwpZttYixebTRVZCjtNwGrnRe2JTHQhxfo9CmUEVdTbnrej/PLI0s5lNtIPaVnDzByPeq59MjVmQEqDtoEd9emrsVCbD2MxCR3tc5cQlFUUT6OaRng351UIjcBNpKONROXiKgR9XrtbVMUo37GK0avJ08wnGuIQFMpT0V2DESvo87FU2v5ATXWGNOIrUNMwwnFLblFdDfSuXoz8SchrWkBKZUCNORL88ggr8gk9gzblk4Nqm5aHGyrM47qwMLhgzrKNI0Mbjv089OCKqdHas7DIujPJC3sUmrbOTKyYPetvkp1QQO/Hyk23renlgjo6td2tNT5yvWJM+CqhH4viwAcOEWSN9x/jw5I8HKZE5AwP5hyqMZWW4NM0P25V7PSr8lhKoj4U97i+DIrDSKNzdeOy6YXCZxYMOE6gecXYuhAhtv0eag0BTxgPZ5IT51wCgQsnQouUS4picIMV9v6y5S+8ayi8ddiHIAaCGm7lbl7IXRsFyV63kjOOwFdwj7ezlZ5NBDGdz2DobP6h2KqzaLYxzm6G6wdSaEuWWnnOvOPlhh84McRGXqVrI7OfETpd/kyq+stNmOkdgD+z4s+r0WM+Y+EBIguoM9fqQfqPU98kpEhaaKIhHNUAqyN/g3IjngwoAZjThmwoEUnDv/gCCoiCrauULLz7VFKKU20rHhEGaQVqrWiLaqLJXAjWsBu/IVm5EJaFG6NotntxbqYjeE3o3e8uf47yWTKae1tThfc5YSjHiF4lOBlkRWU/+5hx8sFBhSq4sCJwESyluj2io926K5H82Vz+/znSRlODiZMdVBbe3cF6jEAzVsmNFXwh5WmbwkqkFV8ThDkCjMnpw7
 K7E/f0K8
 JMkICamNIRR06AF6/Guvb3mRYVR9jWoN9nvR2pYetox3EZpYZrVWMhKd9Rf9T0OomqDCnYMfoq4Gskoh0LN9zh6VU+l07bWeZwbyNx4DG2HK1HO3gZerEzoJuspsT1AdA41TU3N9999/FNgvN5fe82E4g2JRc6bGYwF+UYzyMjmC7yQpfxqKhXI44369hkUhTlQH5POFsPMUHhgiWu7tGemJ+DCW5zTlL3U6lEPk+JWqNQJbOAWPkxR/gN3w3JZtiRnQ3d409EbUvvHT+m23LrANgCO+6ONq4Kh9DIOmYgWguY4arlFjaywrBcWKV6HwzrNEeG2JJhc1zxhfDhLlgEC/9VsTZyymrOPsBAiSnQCsmSwgrzBynjaJ2ps+eyqwpFpIfaNDpAbDflAtFiB3+/waQ5xg/U8ICG1ExBPbTaFAWBqjzHYD3j6A6IPahhSy4BWVxIQ258kcGE+YJAyDNozgHtDFq0n9KonrUNfayqapChCY+JNzbXMYsnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 119e70dbca56..0ce947d0e572 100644
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



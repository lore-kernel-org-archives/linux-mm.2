Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEB9C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226236B00CF; Tue,  4 Aug 2026 00:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE476B00D1; Tue,  4 Aug 2026 00:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C57D6B00D2; Tue,  4 Aug 2026 00:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1E836B00CF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63912120872
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:38 +0000 (UTC)
X-FDA: 85062303396.25.8F5FCD1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B2B61C000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fu1N0gqp;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=csSbLn2HNgFXzmHTSRr7vcVb4Wk3QmqGPDut2K4sshw=;
	b=RdMCZxXjeKdbB0uLntGK3h+CmzkzJx6P4qlKNndf6jsJbiILfXkxDhOrQqiFbImb8ExEdR
	qn/YVyzqgzu+oufOBPdONTYN+J6ZYPUflwnDe/fGks/MHL61PgC2aSJWoAW/6Dn253mlRH
	CZ5hIUg7mXssDj+IZO8Gj34swnInENE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fu1N0gqp;
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817656;
	b=Uo2vCeuyKwT2kOnEzd8wMUR1qDYrf6+oQyc4yUSvwWN4zviqVqk2k9YULcYK+vC0iSNDAC
	grZkxx7S3Z6c+jtuuNyMDayioN0R9vrLPRUYx1aWDwc6Bk6yECbYzePNl0bVDs2gq+nIuB
	g7btRSGMvC6K/7v+RX8Wf8xj4hoUEzI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=csSbLn2HNgFXzmHTSRr7vcVb4Wk3QmqGPDut2K4sshw=;
	b=fu1N0gqpoLbOm8+rnuXYHIGzf1LGPdp8RCTdhJUbJRhdaWF6RszLR2ZDlY1c2o38FL1ubh
	NQZMn8v9Hzf0cXlP81ZdKh3CueipcL5/Z1NlHmwMfayoTI61gRbE9G5STUMjagWjwyL/H5
	j3RtK7ktRY1dE49GpGvdbzL0vkQwVVM=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-Z2WOJ3aQPBOi5ubtxFQ8oQ-1; Tue, 04 Aug 2026 00:27:34 -0400
X-MC-Unique: Z2WOJ3aQPBOi5ubtxFQ8oQ-1
X-Mimecast-MFC-AGG-ID: Z2WOJ3aQPBOi5ubtxFQ8oQ_1785817653
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5b2a353e6aeso2075598e87.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:27:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817653; x=1786422453;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=csSbLn2HNgFXzmHTSRr7vcVb4Wk3QmqGPDut2K4sshw=;
        b=gWKUOMir3RFvZdTYmzVtIUgdAwp9z65ZCSrmA7bXha27T2ZQ5OEnCfaMicFbtr3TRI
         se4LrhecToO7/mpgbQc/0gCee2Jvo4IT4dPgUZ2AiCzp1x7HapVtkTAqhqJgiiPal5rh
         xIT6JCyfg6yHaGdYHerYpfql5jAqTg2F8H8FPI0Qz2LOA68N5Dbej1syjFKsAlhQP+7z
         D1tEiiLVB1Y3VQTiPbT8K7qhrHHVChMK9EnyIB/4vuomRvVQ4iv3y+Vl/GsCsmHsapmv
         BZBx52HvzJXmpTllsITGzCbcnEBSf2mcXhAThtFwQj6L/CbeWuN6NFcF1KoF7YfbjW2L
         vmAA==
X-Gm-Message-State: AOJu0YziFfDLuaEpNI/SWXN3DjJyyTO/hupIjvIJZQX0mEz/TX9kOowI
	t3SdlE0qzJIBuquWYf7Z8M8GDaTbXPfWyrgXZzqWSCvyLELaXKXsTc2XhrykctwZCvOEVbmrLiq
	y6HdBvK63wFZ+s27PoT9Uqtn6DldI+ZgLtgFKPPEduWiWOgaWo25Ah2hE8Zece2uhKjr5fBrTLP
	ajtl+1oHaXGZb4mF+/nCAQvlsOILlk/9IR2g3zdQ==
X-Gm-Gg: AR+sD12hLcTyF4dnJT8WtlWnSEcoHqpXg0V58ByRj6Y0xhwErB7nQAWGilSdHymUMJK
	oRZVb8aKP5kt6BcQNbRuLZrPe4Cyq+Evrs3xYDikrihEi4SX6kagn4qDeN0FXcRyP7QFXe/WazV
	kOhsfwFKPwXxe+yzB3V2ZkuX1kKTxQM11DkAspIBJnmDWVQFlwdP4is2Rk9xekJT3Or97Aig3VY
	NFfgTOiSVyuDoiFM5gNNwyGvHuz4aBueNZuERgcbmfwhW+FHjyo5pwXDuxOWwHIMkWsP6/B7k7F
	xh3Z/0SQlOWrpua98+gt5uf4mpjBqZ6geQOrJn4X8sYBKPv0KGN04ySQkx22NT31+wRQcpA+SGX
	J81aGFX3erjKtFW/U
X-Received: by 2002:a05:6512:1386:b0:5b1:4e5e:559c with SMTP id 2adb3069b0e04-5b2f2391564mr119411e87.30.1785817652882;
        Mon, 03 Aug 2026 21:27:32 -0700 (PDT)
X-Received: by 2002:a05:6512:1386:b0:5b1:4e5e:559c with SMTP id 2adb3069b0e04-5b2f2391564mr119387e87.30.1785817652298;
        Mon, 03 Aug 2026 21:27:32 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:27:30 -0700 (PDT)
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
Subject: [PATCH v13 09/11] mm/hmm: implement rollback for device page migration in HMM pagewalk
Date: Tue,  4 Aug 2026 07:26:29 +0300
Message-ID: <20260804042631.2175585-10-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OlfDJE_nTn5fVW66yfWPolttyrc10-fD8TbN-SnK8ks_1785817653
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3B2B61C000C
X-Stat-Signature: xg7uhrfzdjnzmhr6f7e3pxh8dtfz6ywk
X-HE-Tag: 1785817656-268656
X-HE-Meta: U2FsdGVkX19jrEiNK7M3AabEsA08hwtgkShpj/SF64sOSZVzCYIMkjfLYDEfluxVzOLZAOCu6NWabN9hN9hPTn3QagnLeH9b37NHxR33yG/iodJa/d49pxqkFSh8b3XY5qEhrHxEyyt+kTqtvkj70yIs+7CN1O8GBkJVMjDR7WT9gu5/h1zCLRRu9qUldEC8qMXXDQ6cVgE1lYS/YYkGYMQkZNto2erBl5kpMjJb45Ylrl1B15bfLTq8HaKIc345Pw7U/3BGj+WC7RYvuntuT+ecbeCYiowbEf9yIFiVJzAkMGPwTOZ3jDmfl/2vJxFoOv1pnCdUF3aWHtk6wXrb0C2mZafPO3jqUS9xh4vaVueEcDwnlEezNOIZU0EsIc/hGA/Y8vT/YgwZqEqZKni5Oz3urJd+09L6TYOsCSJG0LBHZzQqYc1eviisDfoqaYG99LgS+x+UxP6FQOwe3zaOShSAnLGdjJ/QS4o6tPh6DX3LbiOssIexl/xx9/cnp6FrjCL/8Ku4CYzdmGJx2447/y3ykJ44ahRPQUiuzkrj+9LgvD3NSk/abcwgb/++K2OGAYZ4z4OBWszRXSsLOTQJLUHSg6tPJ5KP7Amcx/Wh2T13sxNmX/x0S1Pvj6iY4OOvulKES6m65sQyBYNLaR7N1mmUmC+tsxGBEqofFyABF0G41hcvcj6SZdSeTzgXylfL2TiVnMoYC73ZOAs+kPIVKFp3jf51q0WUDfkoxKZTuC5rh6TlbQ63cLC/bEAVfzrdixyyIOHO1PaqiKo0xx9fnr1nDvjyT6pHek0vxOa7NpxHLXYMVdH15zBa1cf9oSlXCnC6qTsMoKSt1OIrmOv1E7iGb0QZrgKoYoYBMJ0r6Q3oj5lZkAMkVRbByixe7yYr0HKZuUdYAYSpuPKujtQO9QWrCL+/wHx2avQVOyToV/LzDV16NsX0htIJElTj0siwbMf4aTrh6mhJJwjiV0Q
 YHL68zdJ
 MsiPKcOs7g8cnhskKZpiBo9KfopGq1bA2vysfy1DV5KJk68bkVfUBkrQfqB7Afgg/7A8YIlHMe9BKMQvveTKbglSUXkezgqUpsvx4GAl8K7SSXd+IWDFBVLwzuL+25JC313tSsc6GbQQYUly0AYeA2x/PO+YHA3j3033rbSbzxOzMOj1PSNlQE0lO7krR2rlLLSBcdI73pZn/IVikbqicltCU04bFkYAVUccBL7UKSB/Ewbv4FagNdkwl96b6/ZU5yLNxnaW3GcS4S609XZribJdp0RmHBmT90u2gNVUVBUu9ZMm4nuct9kncG/uYJj2vXH+5T/XtfwVVRy0/quxUDfu2Zg2XVQYeCcWSASvt8zRj/6ug49kTIw6eyqOj14Kh8Zz8QwLFbcWwUiW1M1es3vstRzp0tEHVG8JI6eEMxd4VyJXku7bpBfwf1SvS4FUJzBe881D19e99cPadytrUe6wK9iJxxCyy6v7Bm/LZFpR9+Ej/au6LOREt4w==
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
index bfedafc1c143..fbc9bb74d160 100644
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
+ * hmm_pfn_rollback() - undoes the collecction of hmm_pfn
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
index 631f6b4d52fc..03622455302a 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -78,6 +78,11 @@ enum {
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
@@ -94,6 +99,8 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 		}
 	}
 
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr, end, &range->hmm_pfns[i]);
+
 	if (migrate && thp_migration_supported() &&
 	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
 	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
@@ -277,6 +284,8 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 		return hmm_vma_fault(addr, end, required_fault, walk);
 	}
 
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						end, hmm_pfns);
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
 		hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
@@ -407,6 +416,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 	new_pfn_flags = pte_pfn(pte) | cpu_flags;
 out:
+	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
+						addr + PAGE_SIZE,
+						hmm_pfn);
 	*hmm_pfn = (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
 	return 0;
 
@@ -445,6 +457,9 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 		if (softleaf_is_device_private_write(entry))
 			cpu_flags |= HMM_PFN_WRITE;
 
+		hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk,
+							start, end,
+							hmm_pfns);
 		/*
 		 * Fully populate the PFN list though subsequent PFNs could be
 		 * inferred, because drivers which are not yet aware of large
@@ -547,6 +562,48 @@ static int migrate_vma_split_folio(struct folio *folio,
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
@@ -690,6 +747,11 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
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
@@ -737,6 +799,10 @@ static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
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
@@ -913,6 +979,13 @@ static int hmm_vma_walk_split(pmd_t *pmdp,
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
@@ -1139,6 +1212,9 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
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



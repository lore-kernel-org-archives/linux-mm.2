Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC603CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4226B00F5; Wed, 13 May 2026 09:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3954D6B00F6; Wed, 13 May 2026 09:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB1E6B00F7; Wed, 13 May 2026 09:21:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2856B00F5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0710A0120
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:13 +0000 (UTC)
X-FDA: 84762457626.29.BCB10D9
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id EB674100014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W71dOBOR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e4zXGt+6aCEAt5utokxBlmTHRiyLkdnOANcW299C8MM=;
	b=l9sKMlSUbC1mOPK1T1jhFju3mAspYLaYptz1jhX7G2CXT/7s8o63uwphlI1+RoyY2PKOWx
	EGEMp6kj4pPsbEFWf+QKzbfXRh6sr2GSApLxvPaanHZ/zOT+2ZLOxVO5EzHe7OeplL9V8b
	tN1zZanEPz/TZeEJwTt2iJfS37f92kc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678472; a=rsa-sha256;
	cv=none;
	b=FaAX/OGydhy3HBFR0qLr3nmg10iz2xsR26+/4n8OAxycvIBxAs5OD0BSDhzxWDe8ZLfHqr
	mpu5kDpR8Sz2Cb3Bm+tQRZvQk0i0iJClbFVTR0PzxMiAA7GVIx1xY7JNoyJzBbJjJzKMU+
	aMWjayDMKvpjQtsY/56t0ae25vPBB8g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W71dOBOR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3660b84347dso4378445a91.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678471; x=1779283271; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e4zXGt+6aCEAt5utokxBlmTHRiyLkdnOANcW299C8MM=;
        b=W71dOBOR6VsxHuaw/+E7VjoRbMQE6f54YosJkn6QCrzo3JxqJvJZSsqdJHfD0SLZUx
         5dvwSu1u6wx7ly4O1tekcS2d1Yc2ecGs2TvnflWf68CBdVzqlgAxtlrtbz6XEO7Qc2XL
         GHlZpmJDwo5Zr+AlhQjNCWSp/Z1Yz+wurM9v8MgsYT/pkA7YML408ylVFWNUsHCep/pO
         Xn1VywzDNkBOYxF8jdQW+Z2p9rD5uCMblNQ9iyVepTOmmSn2K8f48n9XXWJdoevGBl29
         aEVM2rz7SeF3BNHshCZECdzdkgssC1YbOPP4aDBx8EmXFw+HvlZv9US9+9u11ScEazkd
         zUaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678471; x=1779283271;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e4zXGt+6aCEAt5utokxBlmTHRiyLkdnOANcW299C8MM=;
        b=nlLzbKeNQ1G6rJOTdWBzfZJ2LIeKNMzDA1w35EJDF7ti91ooQrTVI67nJm/ikjNGuz
         erHr974hCmIcZwdcXKc63Aa2YGNDWWlhI08M4lVlK/lmSu4Gp6koSYLjOcJ1PjevrL1r
         mmMuBsgh9bQH437Cm2NdYwHqO8/BrwIOHnHeJg9Fs7Ckw4o14Y9BrFNsZK/ykOJs2o95
         RdsoyVdVHsfbHxPIFFT8d+oGGhnq1MnVCO25pvlf7moCugtCg8LVZj01AaTICK8v9DNd
         1eCzBUt7KXHiJeT+9jCPJ2eiSYDyVCVifBC4jN3u6AHERhjHjR3cZpFPyCBDwsUl8mZO
         tdsw==
X-Forwarded-Encrypted: i=1; AFNElJ9os1WBV6g1utrkPzNzmEFPKrpUPiqd4emNYn7CoWS/1dBLjqeKGbvSdep2Mjy2hzdVRFnDUXr5wQ==@kvack.org
X-Gm-Message-State: AOJu0YwcKsrcp+OqKVsVhgy+zn8w8ebv7vpflPVmCE7VMf2O/WCcLXr6
	6F9i8Bf3HFyeQ4FabICuOLRlzzBEq0PZdSNJuEuPfvFHFjByvVK/vs0zJwhBg/6F644=
X-Gm-Gg: Acq92OGNVQjWctj4LZY8FH+Hc6pEHfAHld6S39bYxI2oJ1rVhg/ogHhjyaZKw87hUnl
	2dC0K34QkkPOumFEyN6O0Wu5h49FV2HncYTW7jEFhP5GBncio/BF8ZGSoaMWn4yOmsApMgVlExN
	KiQnceJifXHWqdzOJsLHo6a+NP0H+Cn0+ETaXRNeGCjEUTTHLBXLxJqACPc5hGLf1QVplq/Zxoq
	f1etImWmuVgnVK9IwkuwqLFSpGWT+F/Lckcb1p2k0sECz+fh5ZSP9FlQ1Nzad/CSJtGIGVNbrW3
	3iRxk8UdwZjYqzNzHjdEyFoXJ9zUhlWJRZ5DkaQrAcMMpBmVGxWeIYZUPCvkQgmut1WBS5nuKUp
	YTwHEWfrW2lCYRi7Q4f0sedXoxpEd7e0pEQlhDHwDCPdXnDbuhb0adXag+NofMCm+rj+BIu+FeX
	X3X1v26pruseHE1+va8jF3EwcOAruiPoKAFNOqWKat5mhGGoSYvnDNOy5iBVr/
X-Received: by 2002:a17:90a:d610:b0:35d:a3b4:2f0d with SMTP id 98e67ed59e1d1-368f3bd73f7mr3546310a91.6.1778678470505;
        Wed, 13 May 2026 06:21:10 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.21.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:21:10 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 49/69] mm/hugetlb_vmemmap: Remove vmemmap_wrprotect_hvo()
Date: Wed, 13 May 2026 21:20:14 +0800
Message-ID: <20260513132044.41690-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB674100014
X-Stat-Signature: sq3a18jwbuj8bm6donxc6cmkdb83aqj7
X-Rspam-User: 
X-HE-Tag: 1778678471-889108
X-HE-Meta: U2FsdGVkX19La8WE++YfutflIkyCUSN5h/QuRR2cbDyJ+rwDBPmG3D1XE+rgWBvvrl0xw8OhjvoqUfg0nGvmgqoDttBqLWhtD7qHqKjhRVPL2ZF7SZ8SBRvjStLjzv3fJsfSIiOH7QWoit7giYwecz5ipTgwMk24B+V9o4YG+1CmoO0mL5rwPp7b2EJOl3n0Siz0vZ6qdmILL/1XSqPbp6z0z0x+HwvrE3DDItocSrHGj/W2EsO1+QEpeXuM26/h2nKd5BRwmXEvlO7DdWxmPlCJn31GHAHCiRSvTciMt0dIeHRSksWvQn2rDxDmnz1TVcZoVQnx3sj6JclcHj70GGYmIQIufFcjH40YoxhdT4UZCuxFs4r4TwH+biMUYTh8mY3V7LACcI+2NuyE0IrYr8xW1evlxu5bJQjDmFPe2TdNUXnOabYSFbfvyMnMKXNmbB/yzSTZQ/SIX0ojv0uP4mUSmcyuUsAy0zvYy2mNF0Grpkwqe6fxAMbfwAGWAkrX94/Ke6goGVHRTG+q4CZgheDDrRcq+sQMZYAbjfJsjCODY0RnC9K5NjgBTQs5IBWaRtYIsIgLGhI16nuF4WXjSGZxP8+3vJwSx1bgy0+pqwf8WeSVoibVlioEfx3ZRQ9Hkrq5N4Pd6VdlG/NvsrfL2uKBMudJa4DHlElaWhvSRBFgfPilEt7uk84PBkyQ5RvSF0N+p+8hWMYDA/N23KcCyB6jxRgqoGzDhKwi2qqpm+kOsyt68HuA+jsFx2qNFc1B7jzoy5nYHqAsaZqFO2G0039uEZPJZJKd+WjsVzOeCeIt4BtTkJrRoRtiV9P1CyOO4+hyp+4j8Fd4dqFgSfXAVd0oqQCbhBuWYzHPqaAmts9GXGVdYKkw3/3Ba0C+qSeFHRmK14hwJTkQ0/xh4F2oSvp9zcTRq7DrTPeJEP18psp8l1a1vvJlvv1lGYtWMqvbLUxyVGu+TBoAFJTeSJC
 5zcwEpHd
 v4xEb04wHJQPE+hhWpSP9DX9cspiaUdm9mqKxZwrYbiRUBBx66myBjVmichjtoU2If1y6r1TrrBxMs75LMozRVtdZiGe9ohCjrvkIKxa1wxlsuj9ghU/FL8zIP7LRWCpEQfb8wggrakg6Nx9zfEkZtnendtKDzIwnz6YECKMHFJLpjSeW8PQl5PNNUsdzt1OI8xyCmaT1ItoHFTe3dTYCK9bol27t9tvcPuo49hOsTGOh0KMKs8/MKXyD2e0SBM+oj/xrW410atMNmf8ttorDpB+rsDv8a4dxcqTH8+55M9ItA03UyOM+yPfKMs5cFEfmfh6/PYDiP51CNhuqYajsa/p/0bBbnKAwVvUGJL4IN+lximE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shared vmemmap tail pages are now mapped read-only when their PTEs are
installed, so HugeTLB bootmem optimization no longer needs a separate
write-protect pass afterwards.

Remove vmemmap_wrprotect_hvo() and the bootmem-specific HugeTLB wrapper,
and let bootmem folios use the normal hugetlb_vmemmap_optimize_folios()
path.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h   |  2 --
 mm/hugetlb.c         |  2 +-
 mm/hugetlb_vmemmap.c | 45 +++++++++-----------------------------------
 mm/hugetlb_vmemmap.h |  6 ------
 mm/sparse-vmemmap.c  | 23 ----------------------
 5 files changed, 10 insertions(+), 68 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 86d7cecb834e..5e38c9a16a0a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4863,8 +4863,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
-void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
-			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
 struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 74770c1648fc..54ef7d12c585 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3202,7 +3202,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	struct folio *folio, *tmp_f;
 
 	/* Send list for bulk vmemmap optimization processing */
-	hugetlb_vmemmap_optimize_bootmem_folios(h, folio_list);
+	hugetlb_vmemmap_optimize_folios(h, folio_list);
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
 		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index d24143dd6051..fce772e95adc 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -595,31 +595,22 @@ static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *fol
 	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
 }
 
-static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
-					      struct list_head *folio_list,
-					      bool boot)
+void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
 {
 	struct folio *folio;
-	int nr_to_optimize;
+	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
-	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
-		unsigned long spfn, epfn;
-
-		if (boot && folio_test_hugetlb_vmemmap_optimized(folio)) {
-			/*
-			 * Already optimized by pre-HVO, just map the
-			 * mirrored tail page structs RO.
-			 */
-			spfn = (unsigned long)&folio->page;
-			epfn = spfn + hugetlb_vmemmap_size(h);
-			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
-					OPTIMIZED_FOLIO_VMEMMAP_SIZE);
+
+		/*
+		 * Bootmem gigantic folios may already be marked optimized when
+		 * their vmemmap layout was prepared earlier, so skip them here.
+		 */
+		if (folio_test_hugetlb_vmemmap_optimized(folio))
 			continue;
-		}
 
 		nr_to_optimize++;
 
@@ -636,14 +627,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	}
 
 	if (!nr_to_optimize)
-		/*
-		 * All pre-HVO folios, nothing left to do. It's ok if
-		 * there is a mix of pre-HVO and not yet HVO-ed folios
-		 * here, as __hugetlb_vmemmap_optimize_folio() will
-		 * skip any folios that already have the optimized flag
-		 * set, see vmemmap_should_optimize_folio().
-		 */
-		goto out;
+		return;
 
 	flush_tlb_all();
 
@@ -668,21 +652,10 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		}
 	}
 
-out:
 	flush_tlb_all();
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
-{
-	__hugetlb_vmemmap_optimize_folios(h, folio_list, false);
-}
-
-void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list)
-{
-	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
-}
-
 void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 {
 	struct hstate *h = m->hstate;
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 0d8c88997066..2b0a85e09602 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -17,7 +17,6 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *non_hvo_folios);
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
-void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
@@ -59,11 +58,6 @@ static inline void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list
 {
 }
 
-static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
-						struct list_head *folio_list)
-{
-}
-
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 5d5cd5f73365..ce1cf5cdf613 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -265,29 +265,6 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
 	return 0;
 }
 
-/*
- * Write protect the mirrored tail page structs for HVO. This will be
- * called from the hugetlb code when gathering and initializing the
- * memblock allocated gigantic pages. The write protect can't be
- * done earlier, since it can't be guaranteed that the reserved
- * page structures will not be written to during initialization,
- * even if CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled.
- *
- * The PTEs are known to exist, and nothing else should be touching
- * these pages. The caller is responsible for any TLB flushing.
- */
-void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
-				    int node, unsigned long headsize)
-{
-	unsigned long maddr;
-	pte_t *pte;
-
-	for (maddr = addr + headsize; maddr < end; maddr += PAGE_SIZE) {
-		pte = virt_to_kpte(maddr);
-		ptep_set_wrprotect(&init_mm, maddr, pte);
-	}
-}
-
 struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
 	void *addr;
-- 
2.54.0



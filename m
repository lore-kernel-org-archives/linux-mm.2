Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D06F3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 057AB6B00E0; Sun,  5 Apr 2026 08:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F356B00E2; Sun,  5 Apr 2026 08:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86E46B00E3; Sun,  5 Apr 2026 08:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAFA66B00E0
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:57:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC6D8160A60
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:54 +0000 (UTC)
X-FDA: 84624504468.30.47724D3
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 02033140002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:57:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kpWDis2p;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8clnDPRP9vVZ4b0lvB2dcHmNampuC1uraKtfe//7Z8=;
	b=OlJov7fPCm0XHBd4BDr1RQ8L7v9cI6JPwoVQ+eJ03ja6yCjUNEfd8eLOe4K5wu3IZO5oAa
	GsMOZZQzqYqdj0Q67uLtto713DT2nlv9LSlqmJXnhqH0Av+adK+gZcgzIdzH0SQmkjvHSl
	ayVH2mcOoLM/BvC8I88qpEZLSsN790c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393873; a=rsa-sha256;
	cv=none;
	b=GShAW/KcFJIy5/aCbhZ71fP3iK1ZuUMkby2UoHK6WtEtKqA7qyDhKlVtGYeok17cWsSk/B
	h6G4uQGuq0PFGvy8KeCCSZQHLzhS60f7MplxTFZHa8wsngiE/QRiE4ki4ES9bOyGDOvQJ2
	ptjk2QihFf0pb7E8MrkpSO1DUrODdzo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kpWDis2p;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35d9f68d011so2030665a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393872; x=1775998672; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S8clnDPRP9vVZ4b0lvB2dcHmNampuC1uraKtfe//7Z8=;
        b=kpWDis2p1bzJh9Xj3+9wIEt6Z6vD90cdU/lhfRjx5bY8eghffF07n9BAodJgz2OLNo
         H29jDpQbC1EmKxaYAGhm73+Qq2mxRloNb6nCK8tW+9QpLPXg+a3Zsl0rjKfYtX0XoH4J
         5z3QLv+pHvl4z+D9nq1KJOktVRZLZJKTGjVxm+znCub7PNDuzPVGowWkE2Ozrq5ozUY8
         DzkiwtHfuTXV2s+P//G+TSw95rqPb0Q+HsA76j4kxp03OxhsMl3Cp6GULcBkrnv9oaOo
         4vp2+l/72+vdxBpdltKGg4fiLXjnmPN5q78ZmoSOiljikA6AivcxRG6l5Xnof3XETE1a
         S7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393872; x=1775998672;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=S8clnDPRP9vVZ4b0lvB2dcHmNampuC1uraKtfe//7Z8=;
        b=KtdEU53oicWheUSm0iQtxToet8h9xWZqYkZf/dbQ/y7fGuK96qHGYFo5tOOV6iA7Nb
         n3NUKrpLaDeIqkXVsy/puGE5BXpbWP5y3mqFocv5tFuxDSFBsptFjrCcjdlL6GhYTErl
         XqA1qUIMwddBSbwy6uPx/9fEILipZ5ozjMGto+sa9uY7dEQq1AUHzbxSS83SLdvsXyyk
         IFn2sgjjlS2QoWnIlGqPmQOMylSVtBfKwNuzvQvHK56DX534KUkMxBNMGwT2NJ5iakgX
         5KuQawtRY9vmE19jb3rLwpjWcN7su5dIK1xYVrc8W6Bo2qIVmD+HBHwY48Q0q4aoCFlN
         se1A==
X-Forwarded-Encrypted: i=1; AJvYcCXe5BZ4/6DGE09WXlvwStRiZMlONgYAalOqmlNAkEhuNLj+l9m07QL9ZVqMlyUpSpt2SABj1DEiTg==@kvack.org
X-Gm-Message-State: AOJu0Yzh79TWDYTqx1K74qweor1Tpx7Aapx4Tw+bK5qvptq21sW2N8nY
	QrSHArp7BcfEb4Qr9a+eK6gFZiBjXM+TRt7hZ3xDpd1rbqDaSHqMq/bJ2SfTWu3oEt8=
X-Gm-Gg: AeBDiesRklrVy77G1yBVHEuWkszAbb2WXGfetdEoqI89aMo6Bt9st/HvqCwkyRJB0jI
	mIB01woemdXYSpaNwuO7RcuuttwoL9sh2RDZ9KEURVnZ4AhMHNwSkeEWHk1fl9TvUmGXTsJmKrL
	n33ZPScTwPZzqgthRrfDSdhJswDFBYmaN5xXczv6AkIGm3aPhn657bCSM29Sk75zsenPTx29tXC
	s5ogLrvpatLbuMguiTCb6Avdl2YkdPrbUyPpjQJh7X0x/vYm1DBxT/nV3hGt372zAwalZv+z1Ih
	7x6FdwabrLmDfrVdOdGwq6fGlYBN0DsBC6EiSAzg2oH+i01/akQXfWnSgcqP/y2UiAKRfJfmRr/
	pqeNA3w3sXvjR8TkRabEeUJD82M14af6fj8DQI1uurqrSnfks4Bcn727Rmnv/NCJnyRiiOUqqez
	Mxf1zh4MZwunhSPu4zYlAyR11Ebrv75U3vYOE218Cs+wA=
X-Received: by 2002:a17:90b:4ac7:b0:35d:a2aa:3b05 with SMTP id 98e67ed59e1d1-35de678f96fmr8947608a91.5.1775393871728;
        Sun, 05 Apr 2026 05:57:51 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:57:51 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 40/49] mm/hugetlb_vmemmap: remove vmemmap_wrprotect_hvo() and related code
Date: Sun,  5 Apr 2026 20:52:31 +0800
Message-Id: <20260405125240.2558577-41-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 02033140002
X-Stat-Signature: s5ean65txnthjt1yz4mu3jgsdqgidq4m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775393872-239781
X-HE-Meta: U2FsdGVkX1/eJWV+sXsvBDeGJtesHDTUAXWfUaW8h9W84yqH0Zgw0+Baq7793bqhwILpYPks9wPrvvznZBCOHgMWj9ntGIcp6ZW3lTG++epES2z2pxgALuZYG0lihOCr6Q5Tj1cZRYpKttnZJlCINEy7qM5rlpNbp3CBBMJRAqKJ5Udi7zxi4bNyLS37ORtEfmVXlXuks371UKrMQKmxEHO88/N3CwrESCkYxURlwUZPuqw4/geg+pjKv9Kzxe1bkpwUNy2Ev7OfQR/ZNTHqAxrz4+MOlGlGGp+D7TY3pHSfbWCBAMiP0ojtsGOxnjtV1H5ZFUJDoDVgZyZLsuucpUvDZ4eiXzZN3T6hXnTM9Pu6BBaHOtvGubqiW07+2V+0DK4xykq0Q/ScoYeu6XYFrrtzcQi4gpwhjypqfQbZCAwMi0mw1I7mgnLSeUf7ixPLJ6s7a7xIfEGfOQXxL4oSIauTo0DBwwEWwRPnAw1LkLTFtRDDd9aaH78mQM1XVfU2OV9tbdyWha991aWqIdL361i6XzxIDU44Tn/X4YYx+Vus+JVo8to4fbfqpNOT/LqDHNpq14GnpL/uuHQKzndC/iWbZv7EVnpc4OEVm0NpHt4orNt333pGZlGnRfJom5z4ZyiPIVS0Otga+ZjTQ4Um/rBDJOi1+ynIlqW5hBqVszrvB5MJXSMWS+HpgnR6NN6bYylo68VYVJP+Mp6iofbBWOt+VrNN5h1fA3QVso1Bwx/U/h+dnHh8Crvkht142c8PAv3ODEOKM4EuAN5xAvTicMMcrmv96xTx3AcAikNcxlukFVPtidnkjPwiyyS1OhaibHaGXmZDoAtTXOTrIqli/KveSvMlC4s5p44qxinKYhVN3MYlu2V5LxHyg3TppWoBBU8MM4heTIGMRVvPJn/WJCz0ZKFFk38N7NeJi0eKNvy5qUQLL0FxuLA1KBB6Ao+X3GKyzp4QRLddeW6YMKs
 de4ufCUT
 ZULEy8hBSU1L7+2y6iLgM6GT4b9M+R83O9rIE4XncydRKkPOtKh/0QkKPMJR/o5oDarOWLswW4pNAW4fSJ63z5c6T0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we have already remapped the shared tail pages as read-only in
vmemmap_pte_populate() right at the point of mapping establishment,
the separate pass of read-only mapping enforcement via
vmemmap_wrprotect_hvo() for HugeTLB bootmem folios is no longer
necessary.

Remove vmemmap_wrprotect_hvo() and the associated wrapper
hugetlb_vmemmap_optimize_bootmem_folios(), simplifying the code by
directly using hugetlb_vmemmap_optimize_folios() for bootmem folios
as well.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mm.h   |  2 --
 mm/hugetlb.c         |  2 +-
 mm/hugetlb_vmemmap.c | 31 ++++---------------------------
 mm/hugetlb_vmemmap.h |  6 ------
 mm/sparse-vmemmap.c  | 23 -----------------------
 5 files changed, 5 insertions(+), 59 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index bceef0dc578b..c36001c9d571 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4877,8 +4877,6 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			       struct dev_pagemap *pgmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
-void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
-			  unsigned long headsize);
 void vmemmap_populate_print_last(void);
 struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone);
 #ifdef CONFIG_MEMORY_HOTPLUG
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ce5a58aab5c3..84f095a23ef2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3226,7 +3226,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	struct folio *folio, *tmp_f;
 
 	/* Send list for bulk vmemmap optimization processing */
-	hugetlb_vmemmap_optimize_bootmem_folios(h, folio_list);
+	hugetlb_vmemmap_optimize_folios(h, folio_list);
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
 		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 92c95ebdbb9a..d595ef759bc2 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -589,31 +589,18 @@ static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *fol
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
-			epfn = spfn + pages_per_huge_page(h);
-			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
-					OPTIMIZED_FOLIO_VMEMMAP_SIZE);
+
+		if (folio_test_hugetlb_vmemmap_optimized(folio))
 			continue;
-		}
 
 		nr_to_optimize++;
 
@@ -667,16 +654,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
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
index ff8e4c6e9833..0022f9c5a101 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -19,7 +19,6 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *non_hvo_folios);
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
-void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
@@ -61,11 +60,6 @@ static inline void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list
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
index 36e5bcb5ba9b..ba8c0c64f160 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -296,29 +296,6 @@ int __meminit vmemmap_populate_basepages(unsigned long start, unsigned long end,
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
 struct page *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
 {
 	void *addr;
-- 
2.20.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F18CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2E16B00F6; Wed, 13 May 2026 09:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A4A6B00F7; Wed, 13 May 2026 09:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0556B00F8; Wed, 13 May 2026 09:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE5606B00F6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 962A6C010B
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:21 +0000 (UTC)
X-FDA: 84762457962.02.640290E
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id C4B3A40018
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OCQnKM8L;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQsJbUbh8y0BvTtiLUFG2twbapHy6ttd2Doxr7AiD7w=;
	b=PBQqyE+LBTDTIcF+bfSFPWfCROfeDLdm6+c9akutea5x/RdLgUI6cM72MohVK8uBWb/0Vx
	UF8erabZtsDcPOK4GZRVlcOl1iMygGJ+bR1FEwPJlt/yY5fZVJuVWUSO7xFeBUBh96jy/1
	AewJl7BaNMkroVx62ZIX/hTP6J2ZGhw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OCQnKM8L;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678479; a=rsa-sha256;
	cv=none;
	b=J2fScEjDB8An3zcsa4v0SFCcQhFR2bsbXVZLwHT1PUEQmjeUM+qBiYkn9mWdjwWb581+N6
	pgl869qfxxTZT5Qi1H9JQe/nAeGogDauif++PHBzsy17a+4gVYXkaLGZp5Nk1dHzZl7bHm
	h6BoOXURiWXzTOtQQpWc9rq2UCnxrFc=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-36622412e97so4353941a91.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678477; x=1779283277; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQsJbUbh8y0BvTtiLUFG2twbapHy6ttd2Doxr7AiD7w=;
        b=OCQnKM8LeolBBGd+CbVil5EhZonbEi0Fd0QMSj4H14QJvvNd1k6HdbozUjmFH0Llio
         pU2F6Zb+evWh9bxEmJ5CkvkJef2jInn3iWrSTeyQv1GoiHudysD2y0Zarcj/+ZZM0dXV
         AGqyw/YGip4JRtbemxVK9RKzjvYPFCGVP8RYQBcGVVkOMQ489fMNGTgf1zvidYPYXaYa
         3q7FeJhlvYE/QY5EuLAlnvSfwxonDqsQFUiwioBHPyYlM9rQlNCLNvidViVEylIEiSyr
         LSOd6WGh5cI7NNEv4/doImuaHr58K4BguUNsv+z1xg93QL9SNuRpxxZXpWcV+Ep0cBBR
         UOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678477; x=1779283277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pQsJbUbh8y0BvTtiLUFG2twbapHy6ttd2Doxr7AiD7w=;
        b=S3w4mgJvetYkZsIdELV1YyX8au3RjJZRDQ43K/5MGETrvLqaYoURQusfsV4JNa6XLY
         V+7cbbFPkDaMnbMcKO3zv6S9GniAu+t5sPeAFsFoI8peCpOw7BRHWsgYmYwUQALtrQ5c
         yA+nrwE1INfAAOrW6187KJuwuJ88W0QHQq1kCSMuUbgAcWQ89kqoVyeMGaRkbRL4XvIq
         2CBRvOFaF7xLpfQz1ttW7b6xNoLMrMQ7xsPVMb0OhdF/1MJq0sjPCE3aEL4RKzjatfIN
         EbbMK9TZAHleuvo8EXLNUQWBhU9G7tQ2gfzLjjE253j8aSuLg/gkIiv6872AeqEyV1FA
         r2nA==
X-Forwarded-Encrypted: i=1; AFNElJ+X2ggqJ+yOQVuAO5ZvV9RQSBr18Un9y2XszGLuCMnQ6rtrf48jqiQM7odwWqy3/oJ3Zigywpq5bA==@kvack.org
X-Gm-Message-State: AOJu0YyVCQc5WaQMOdW8Gl9lUEhIwaAhTok9JlC5H8sZow4bSLEX58pT
	KAxyUcXeLFj80GQoGVfn+ZwgX44s7q5Ic1w5r33n9IZTwcEwXaewYMSsDhVme/u9hPc=
X-Gm-Gg: Acq92OGj5CrSF8UVWBnJ+QG72XAyuOEizAuRYJIrWoCDaEfiYrXDpp6evmC8pcAye9C
	PkVlh7evRHY3UAs+Zn/RDhRhwdoX2oaLkBwXuGqZvq0OiG5pZi37mQub5hK5HkzMnDS0obvP0jn
	+BTdbTlPUCtdzO9yMJvGAoVGSguykmHTv9pWZIiS/wuwPU0zcJvzQ8+ETohqOziZRYgmjYMZPoh
	QuemWIOI0XhIhTPHrOMMHbXuA7HXvfdiBtMHXtZQj7ZUsupFACtwWrWEA3T5rT82lItq2wd06I4
	DCt4ZU2UCYuM9mwH9QZZwa0RCPepH7bYZjCywj7sT4cjzbGcC7emQAKfnhfKQeaYRiBAnDXmnnV
	8rVK8ur2Q5actolXYdqgGholeIwyeZihMNOCrJF6AjgEJvH1GkGgAdaaqd6zZOunX7cYagTJTCI
	K3klC0NvxcYEhhtSJGplgV0TnrbMWO4L42jcJG4QF35EYkT2Agg/baO5BzEwXl
X-Received: by 2002:a17:90b:3f86:b0:366:33a6:9921 with SMTP id 98e67ed59e1d1-368f3a909b4mr3549334a91.4.1778678476572;
        Wed, 13 May 2026 06:21:16 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.21.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:21:16 -0700 (PDT)
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
Subject: [PATCH v2 50/69] mm/sparse: Simplify section_nr_vmemmap_pages()
Date: Wed, 13 May 2026 21:20:15 +0800
Message-ID: <20260513132044.41690-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C4B3A40018
X-Rspamd-Server: rspam06
X-Stat-Signature: npy64a9ic64tz53d5k3zmt9t9wrw8urq
X-HE-Tag: 1778678479-331282
X-HE-Meta: U2FsdGVkX1/Zrnkl6q1k8/bHuVMk49lcl0Bumejh43QywR+BBioghpGBQjNqA6yfHhaZxiIlNfbkZzYvQT+QSQA29tS9F+hIEeGWZZGUpU64gG8QV7VqXetBSaiA1Csu6aAw5BWgb2OWZ3Wfk694h0c4Ex/04aIxEabFEKkD+9Ol9cK1iAiZ1voPQNV6KuNa48eDUn65ZUZXo57kQVHgUiRSIRosRuRQ2YJtEXtQlsBCuy8fwNNwYzUtRfRJEVFA+IHH2ZVZYvkYkMGg+SSMJ2A+caQhWDY+lhUCl2ugetZ98LyOjpnFq9f28WMLURyU3nfVTTw5g8bG8fvesd3uo+HCwsTCwRbJzAnzKvLE6nPDLszhftrcC8sznO9LoKJ3ZRREp33YcC4lmjwBq5HscnnpNMKGLZp9boFbKE2Kd9DfmN54V2aXOz4Lp1RJd841wuBVwWtuSq/IDXYi8ZTAkti1/1fylGYppAhuJNiHE9KbQeOmomxqDI1n2uI1sfquhHfFU3nLMYnm5ZRfxU10hT+AtK++nfUW2eEE1+QDix9YJx6xYvcD48VWjtuII3358qTMyjNRgLS0d1lRoZM7l5uPyrLgh4uCEXnf78wtGNUdDenozWfpvd/FTZpGL8rGShypfFsYMyjv0lCBY6T2sBp95xU2c1JdvtEccxmQ3fH0IoRIDYqUnSNmV1SiynofseIfb/KHkbFS/+E1ITqYRcdfVNz/8BsczBTxJ8+dD4eR5PaXl0KjtxJez3DHu2uKACS2xUOVfXFLgusBLJL88derxvhsmv3Mx7KzmdoLIDbmP/H+JZ6TIWt6bFnxOTENWAvTKNniLibdzC9GKV6EnZoZDbWvRpidljY8FVirJmzx8JacCWHtCHODijS0PdqKFXd4EtX36Li5StumpHxq5Gnu9fwFVddqtljUZ1l2CynKTag01azhYtyqz2LdM0eHVJt9e99fsmNwCrm4MK4
 sT+V5Fsv
 iYf8GM9Q7oQMNSfprvxJDGACsp7hhzkRQp2coCn5FWbsYxM8RoCMHItOWnT/9aCT6AOa+ROyOvbeEB5jZgCr0aaLVxJOCGayK/sgBCcONFA98XFEhjBA488aD42wOsRb5L0RfduK3SfPh9Py321OQPyTjYirQR1Mc0qaN4VBukv8V9xLcx/HshVH+Qbpv5+Dhlee9h7yWDB5dkqf/h3is0APKcoIDJDrfQpn2I75aX2rVTld5lM4/KtQjIbLZDo/f5yQlRLhb9UdsIxVkjcBHVvgW1/nGU7gZBTna+IwOzlqP2JLRhMux9jbMLAOS9iU9xb/7uZ3VbYIrkGQ2snFBYoQb/5L69YwtIlN9YB38o9CEDBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() no longer needs altmap- or pgmap-specific
state to decide whether a section uses the optimized vmemmap layout.

Now that the optimization state is recorded in struct mem_section, use
section_vmemmap_optimizable() and section_order() directly and drop the
redundant arguments from the helper and its callers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h       |  3 +--
 mm/sparse-vmemmap.c |  7 +++----
 mm/sparse.c         | 19 ++++++-------------
 3 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 18276cd15622..06022074ebcb 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -997,8 +997,7 @@ static inline void __section_mark_present(struct mem_section *ms,
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
-int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
 #else
 static inline void sparse_memblocks_present(void) {}
 static inline void sparse_init(void) {}
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index ce1cf5cdf613..793fd4ce1393 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -468,7 +468,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
 						      pgmap);
 
-	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_nr_vmemmap_pages(pfn, nr_pages));
 
 	return page;
 }
@@ -479,7 +479,7 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
-	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(-section_nr_vmemmap_pages(pfn, nr_pages));
 	vmemmap_free(start, end, altmap);
 }
 
@@ -489,8 +489,7 @@ static void free_map_bootmem(struct page *memmap)
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 	unsigned long pfn = page_to_pfn(memmap);
 
-	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							NULL, NULL));
+	memmap_boot_pages_add(-section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 	vmemmap_free(start, end, NULL);
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 6878f8941b4c..3390cb82f114 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -237,32 +237,26 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
-	const struct mem_section *ms = __pfn_to_section(pfn);
-	const unsigned int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	const unsigned int order = pfn_to_section_order(pfn);
 	const unsigned long pages_per_compound = 1UL << order;
-	unsigned int vmemmap_pages = OPTIMIZED_FOLIO_VMEMMAP_PAGES;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (vmemmap_can_optimize(altmap, pgmap))
-		vmemmap_pages = VMEMMAP_RESERVE_NR;
-
-	if (!section_vmemmap_optimizable(ms))
+	if (!order_vmemmap_optimizable(order))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return vmemmap_pages * nr_pages / pages_per_compound;
+		return OPTIMIZED_FOLIO_VMEMMAP_PAGES * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
+		return OPTIMIZED_FOLIO_VMEMMAP_PAGES;
 
 	return 0;
 }
@@ -294,8 +288,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 						nid, NULL, NULL);
 		if (!map)
 			panic("Failed to allocate memmap for section %lu\n", pnum);
-		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							       NULL, NULL));
+		memmap_boot_pages_add(section_nr_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_one_section(__nr_to_section(pnum), pnum, map, usage,
 					SECTION_IS_EARLY);
 		usage = (void *)usage + mem_section_usage_size();
-- 
2.54.0



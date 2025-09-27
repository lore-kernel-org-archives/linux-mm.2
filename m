Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD6CCCAC5B0
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 06:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C228E0003; Sat, 27 Sep 2025 02:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84ED98E0001; Sat, 27 Sep 2025 02:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B5C8E0003; Sat, 27 Sep 2025 02:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EBE78E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 02:49:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B20E43F82
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 06:49:57 +0000 (UTC)
X-FDA: 83934105234.20.9E2344E
Received: from mail-pf1-f196.google.com (mail-pf1-f196.google.com [209.85.210.196])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6189CA0003
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 06:49:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LtdPjSBp;
	spf=pass (imf25.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758955795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0dK0M5a0VXYl0K576x1qZfBs0LVqC3VmNdeb9eiqFqc=;
	b=GcxGqGy7wZ3guJdesYBP7SoTFuHF2rkqfoqVzb2o7H/JAgIBm7wweyDUPpqKbuFY42o/Ht
	tDkDndgf4eCOvhpofgzA9YjdgizFaaZgFFFQCgYPsuWy8VBFoo0rjYCD2zfdnLOB8k+QIM
	UA3+sas4CrgwDe3DgaYfWRxzFFlFovg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LtdPjSBp;
	spf=pass (imf25.hostedemail.com: domain of jianyungao89@gmail.com designates 209.85.210.196 as permitted sender) smtp.mailfrom=jianyungao89@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758955795; a=rsa-sha256;
	cv=none;
	b=FtKwXmVVUKvfncsPOAMjSYzj8LYDK9z+7lP0t1E+AwG52SGYNL5dd3st4X3quAI33XYxpO
	WT9NrrZPWC8Q7uN4Tpg/2FPbSQr+Kd3sPC2OCY9fi1iJDqz21ed5LTkkxmbgXgFTrr0kip
	6rM1hqWtucpGZUvbWQx0GglC5LASl80=
Received: by mail-pf1-f196.google.com with SMTP id d2e1a72fcca58-78125ed4052so737810b3a.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 23:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758955794; x=1759560594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0dK0M5a0VXYl0K576x1qZfBs0LVqC3VmNdeb9eiqFqc=;
        b=LtdPjSBpRp7HxxIsPbc5mA7Yg8mF9EFwT4CEa+KCnHeq49/QwlygjA4YMXXS8y3nln
         2RvjNkEvWAq5Gyw1QObttkoYwBYel88YtvmNkj/yJHyeZ/s9JTIJdndJWkPK/28+x4y6
         t+tPpXqExUF2IYuqqhD7zShV+so5sNaUFqC8VKGKWXdDSDN3daz+fpHor/c2Q25aMpOr
         GcA2R8+NN4zcqvH/gmjF75Ir9DO4O2lyL6vZilRo+z4aXNVgdrHgl1qbLdI9JnWAOsno
         44W8yZcihXBeqEU4jq5p8mEqyhuwIDczx9EVtkJ4PqALhEFO/6LHmaIkT6chUaeI5E1o
         jUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758955794; x=1759560594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0dK0M5a0VXYl0K576x1qZfBs0LVqC3VmNdeb9eiqFqc=;
        b=EaCznBn11QhimF8Lh95JQ7IHX9uBuOLgD3Qia86SHkcuQBh/nq7C/zSMoXYN3WViDm
         yS4Ma1ZpjKf63vLmtADhcyi5DLlLUL1fyYYfF8oxALroCZzl3p59worjEJKfajYKmH/K
         lTGD5wL+5/3WQqFz5InPKWtIILQx1OVNBjYQZsuciJ27sIjo4Pe6iJDe0Wdcgsb//7/E
         LJiU+gaC1H/JoXfl4C/gevi04a9U5dSdihe/q0wj1JJa6iviPz3zHwucoyKDC/xVAeQN
         qcDaHOlJh48TnEE6NKYLgwurW2ALdj2A/CQVzIKZrayF8AlOsryvfi/IhRciUThqg9mo
         1pFg==
X-Gm-Message-State: AOJu0YyB45NTW6uiA/Vq8coCJJRHIvILcCkYy7DV1sQwJYT81AtmhFo9
	VFsFx0HYMBXwaKl5fb+K335xw1X2VQBID/dTMb+vnODzQxYsDfM633ZslnVJAGfe
X-Gm-Gg: ASbGnctPPu5BBBEfrTN2VwqwsykfQNy/RTKR+yoEty+nwyo+dIPO7ajFjihK8QLG4G8
	Dhd1oUViwEspjUUOGXDG93AWxwZeMRWwsWV+A61GPLS30ZSmVJfxgLqxjYzTnOLJeW+9dJ9asaI
	lSDNTW1rhLVua6RvccZGKQO/b4nP1q3f4sVQ/h0qmkSbh4FHJtLDX1Yo8RnfZmHkAT6bGATdcXf
	OX7bYCoZWRMiVi2EVbQzr1fdaun3MUyNeuc/Nemew+zMdkxDuKLbtwS/GZEa3ysppgstZhG+gDJ
	pbC78h+EQ0VZAYHKJP9F+c+AqdZqmlc3oA6MHrCbWWCGhknyhMkTwNf+k5+qlmJNIxUpB1MWuv3
	5WRzGq2kfBb8TzNEhCV61+KMi8IKoMRNIkizhdSG5
X-Google-Smtp-Source: AGHT+IGN+KDwmDhJLMShTiEt7cITIuG26jA2dkSg6OA7Vgs9XkglHCfVFQMh2z0ZKoA1Zl+NyOa0eQ==
X-Received: by 2002:a05:6a20:4324:b0:2c6:85b9:1e0d with SMTP id adf61e73a8af0-2e7c95a4a47mr12842203637.21.1758955793865;
        Fri, 26 Sep 2025 23:49:53 -0700 (PDT)
Received: from E07P150077.ecarx.com.cn ([103.52.189.21])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b57c5574e99sm6248080a12.35.2025.09.26.23.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 23:49:53 -0700 (PDT)
From: "jianyun.gao" <jianyungao89@gmail.com>
To: linux-mm@kvack.org
Cc: "jianyun.gao" <jianyungao89@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mm/hugetlb: Fix some typos in hugetlb module
Date: Sat, 27 Sep 2025 14:49:26 +0800
Message-Id: <20250927064926.1496579-1-jianyungao89@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6189CA0003
X-Stat-Signature: rhqsnhfudf9dd1koccb57j31f4kbkjf9
X-HE-Tag: 1758955795-295275
X-HE-Meta: U2FsdGVkX18brfr7jkqH68KMn4adVPspb0og2AsBD+mHWa3KvHQxaIJV4rn3krRDyq/7cYPuQDMYb64moEGFdyDOWLODHaGczOb7H1clVd41A8RsNYAxjNdKPZ+/sQavWfcZf31yD4FDPlHfwNVatv1NMEMSlXFDYz+tr1iLV9m4U0iDYPVog/nzZeOMfJh+35S6Bd2WDOfD5DrgSMmtnpK38DNnmyY5tx5PvXagykaAUM5ZJ9nGnQR2LJVkeGZwQ5+u7TIf0Ud6coIuyxJosjI0sQcQIVj/DXk5nAp8o92jBbT0uqF+YWlgSfFO/Mn5ZJibk//r7FLDA6hACaBgcznR8OMm55CVBi29TQXta5j2rh3GXGytSTc/nC4oy5JHCbMWuayLri9pTVbPvQSWlveiJN2IeZtzBr0LTkTpYu68TAcfUH980BBI7N/66QMxLZEBA2Gm3fvytWTqr/5gWJ3nX60/kiT7Najw0/pOQ1o173mGlqHkvMxBgxVXrkJkHcb59/KHwWhylKkWeXiU7ziQTQSc1W3nbtRzb27A/o2tEOicwQ7Lxz4JLYMh0OixdeU7wDw455yc4WUAaZPJK9G/eXSIU7WrGbVc75O0bRH6nBrlx+LCdbjf31nn0yjcieOhTG+B5eR7MXCPwbz1GGv1uOjPiXmWq9GEpAujAafzCbB9gxRUUKNC3j9fmZLKTDOBL32DQVrfNTDUEUG7V3Zv+ACzXRMpJmNWJd1Y8eUAOfrKtJdg4e1otXFkbVjrEEwb4Qb3TFaUBWmQWYW/v59Kbd5BZozZ1KsBjpgBMzLhRRmqoszBatkrn2PkqK6KSypI54M9t1K4+ocf6ulW0/IdQsx4WcNJ+1jXGWOrgB4A3juF5nxyI4rGGN1gAxj4TC+lP1B6wiWi0gURupWCNLpNVZVlhbZr2hzh4tV86e2+rDgz3xiDY+3gDi32yAKpcbx0GnxQWL8hnZACVIy
 1ntRUD2U
 BwBT/EzMh7DW8ikTP1vlAXu6G6iGvWbdizNhv65qpDI6Arz0A3gEGn/u7Ja0+/eqasCf3ky5mLuRlHR6ZkOhpeqFDhH6xRKEoMGdcxP4xEfD6QXbQ7ORPqafe9Guh0UlEMk0FNzbUN+o8xUdNVlYnRZrdew6/DXLk7p7iCz+muRKpgSoAVKYUBD3UdiCNKneG3CoI1mwi84sRJB1DcbcDi1zLEkUEhhUudLYHklywlIc07N/MY647pdSEcWmuboO2goc7jL4H9mRQ9O5eaapi13QfO4dcKM9ruuuxhW//7knzaKgbB2wTjRaYnu2S4jARYsiYY4xf9Lw+DXQK4VKA0Efp4q19duyy5JvlNh6yXtaSwKFqit0/rCF381cIqMKndPuBUYbdYMRLE46ERpLNjsmEXBWLRhW9eX7u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are som typos in the code comments as follows:

  differenciate ==> differentiate
  refernece ==> reference
  permissons ==> permissions
  indepdenent ==> independent
  Spliting ==> Splitting

Just fix it.

Signed-off-by: jianyun.gao <jianyungao89@gmail.com>
---
 mm/hugetlb.c         | 6 +++---
 mm/hugetlb_vmemmap.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eed59cfb5d21..8ff9edd09504 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2954,7 +2954,7 @@ typedef enum {
 	 * NOTE: This is mostly identical to MAP_CHG_NEEDED, except
 	 * that currently vma_needs_reservation() has an unwanted side
 	 * effect to either use end() or commit() to complete the
-	 * transaction.	 Hence it needs to differenciate from NEEDED.
+	 * transaction.	 Hence it needs to differentiate from NEEDED.
 	 */
 	MAP_CHG_ENFORCED = 2,
 } map_chg_state;
@@ -5998,7 +5998,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	/*
 	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
 	 * could defer the flush until now, since by holding i_mmap_rwsem we
-	 * guaranteed that the last refernece would not be dropped. But we must
+	 * guaranteed that the last reference would not be dropped. But we must
 	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
 	 * dropped and the last reference to the shared PMDs page might be
 	 * dropped as well.
@@ -7179,7 +7179,7 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 		} else if (unlikely(is_pte_marker(pte))) {
 			/*
 			 * Do nothing on a poison marker; page is
-			 * corrupted, permissons do not apply.  Here
+			 * corrupted, permissions do not apply.  Here
 			 * pte_marker_uffd_wp()==true implies !poison
 			 * because they're mutual exclusive.
 			 */
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ba0fb1b6a5a8..e6f79b2c63ee 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -75,7 +75,7 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 	if (likely(pmd_leaf(*pmd))) {
 		/*
 		 * Higher order allocations from buddy allocator must be able to
-		 * be treated as indepdenent small pages (as they can be freed
+		 * be treated as independent small pages (as they can be freed
 		 * individually).
 		 */
 		if (!PageReserved(head))
@@ -684,7 +684,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		ret = hugetlb_vmemmap_split_folio(h, folio);
 
 		/*
-		 * Spliting the PMD requires allocating a page, thus lets fail
+		 * Splitting the PMD requires allocating a page, thus lets fail
 		 * early once we encounter the first OOM. No point in retrying
 		 * as it can be dynamically done on remap with the memory
 		 * we get back from the vmemmap deduplication.
@@ -715,7 +715,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		/*
 		 * Pages to be freed may have been accumulated.  If we
 		 * encounter an ENOMEM,  free what we have and try again.
-		 * This can occur in the case that both spliting fails
+		 * This can occur in the case that both splitting fails
 		 * halfway and head page allocation also failed. In this
 		 * case __hugetlb_vmemmap_optimize_folio() would free memory
 		 * allowing more vmemmap remaps to occur.
-- 
2.34.1



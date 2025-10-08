Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC10CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0F88E0002; Wed,  8 Oct 2025 05:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6A528E001C; Wed,  8 Oct 2025 05:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93888E0002; Wed,  8 Oct 2025 05:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A91318E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:55:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6DF671A0422
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:55:50 +0000 (UTC)
X-FDA: 83974490460.14.80BDAC8
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id ACCD740012
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:55:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S+tEARiO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759917347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=0QIUQx2vcFr7MGG3evz1dHWpDn/cIwYRaSBxcUSI4a4=;
	b=Y15TqKYml7f4PgjAn6czO4XZ6diBN9mreffegGQNOP1qRHxZCv/GQikJ99Yp5o8gzAMs4I
	/jTzaxKVDvX5ShT6XDRYN6CiqqcT4h6JCyONNiugU34NnzF5Rq2LZgSMsGPVvt8sMuIJbd
	/b6sNIX/xqnuAqjtpTFsRL8zwXkP0m8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759917347; a=rsa-sha256;
	cv=none;
	b=n3UbIC8Br57isLv2RwgXoD2LgB9r9V37g6M4FuiqHsdg2o19Vr+MOpR7Nx0C3PDhiBmB1v
	PkG8GVfVZxeqVDYOYnLE93zFvmjP1E6O/ClCM/1BMYP7EhRVGOMQn8xVzCw67sD5kxlYZ2
	iFZ9FiDPs9sZ7ssz+JFqpns2hnGBWmI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S+tEARiO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3dbf11fa9eso1308499066b.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 02:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759917346; x=1760522146; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0QIUQx2vcFr7MGG3evz1dHWpDn/cIwYRaSBxcUSI4a4=;
        b=S+tEARiOrjsT6H0amDqjUmhwaJXaolWOnh+CqhiwcnA1qIyqg7/taxONBi6X7goVv9
         qop6CyYcF3hsHsGi6j6u1gVrnhrHZXrifIUeQe2bd71u6am27CIeQ47k+7I6ZnvoS8IG
         fhSH8NqwWAcD5RuZ4Yum0UhkaUiPYy0jYVMENqUYloJ0PasBimsLyKyTvIhi2ps429u7
         nT4PQM72E0fz41OS4iNQsUN4MsjXnRzaLkzDQ25T6y54Pu+0w1J7RDhPKfuLH2vTeZR3
         9aiDg2Xeay+9vOi3RScDGdK0/xWLzajBxQ3hQci3fKVc5kjtgf/tmZVXxs9XICTZivWc
         3MTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759917346; x=1760522146;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0QIUQx2vcFr7MGG3evz1dHWpDn/cIwYRaSBxcUSI4a4=;
        b=dm8EPO2J7vwCNeH/mo9vxqfGF4eSfbfzXK3k4IEdNPVfxIrtIrSPhKMtqlj4I+1CAM
         +IVyamVINxxeVXw80MtJEil3fcgAdBSEogVCmeN0A15c5yrejDTKqRwDn+Rk5WAuOLJr
         BECEKf9leoMt24aBz4aB6wghM7pyRekKkEdY/P2E/m+fzwKaueOLA/Swou/2a0JYnYug
         cqdNi6wGyAnW34VnLQrrmYIxbdvEShn/gKr22v+CBRO92m1+arQMxpxL3iyJnBCEnkkx
         ZPB9kxkCcYRK5MXChGjl2Xb+/Jn6S4F3K8h19CLppTXUwfqJZCTSX1uGZtn1KVzWUgeH
         ek+w==
X-Gm-Message-State: AOJu0Yxy66W+Zn+R61TFaswmBm4aXWLpDYewCTst+uchJ4Zh7me1rLj0
	toB49OSSotKVw4EOn8vaJWfKglWfcTdv45iwhLmX5xbFQvDne1cdqe9i
X-Gm-Gg: ASbGnctnobOJaq0Jk5ugMgVPCB50fegR4pdKvzsqY2spYgGxApnAuKx7yNHocF9AMkr
	hrkueJHhDu6W+8V1Rb3m4ipKbY32aDYDdCZUgqyPlgiMP9nI5hA3HByZbovg4rd3+xZMeXPV0fy
	lny8wmbRtloDQ6lCfAsO9g2tCRBRzfJMgYzhxo+mAJoaVB/cChuy8sGsuIumkNdFGFzVpE9/Yh4
	25gLKNs2RUqDxGh80RynWhiQ+Vg+9IUlKDKLOmSiFpzKBIIPEeHG4WfElNq0BQ25yWyMTboD9fz
	fiXM/mYvpyq+qlv7KxZEqQySi4YDQKpdT/a4YjE363t9GLxkMJEvUrIj3Z4rhXdyaCT6VtPvMwi
	TSrPyfgsghkWPHMvfEhDFkDaxhI3+oO0wiBOTAjd/IMZA6aAm9ozLh1Tc1lv0
X-Google-Smtp-Source: AGHT+IE+2DS6uo2XBoZmGkiTNVlDuro4gobXDgIU1ONZStmGw5cgMrMDap66bO6ZA7BkbCKz2sfsdQ==
X-Received: by 2002:a17:906:ee89:b0:b04:25ae:6c76 with SMTP id a640c23a62f3a-b50ac8e51eamr265431166b.47.1759917346078;
        Wed, 08 Oct 2025 02:55:46 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b4865e78242sm1614697766b.35.2025.10.08.02.55.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Oct 2025 02:55:45 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	wangkefeng.wang@huawei.com
Cc: linux-mm@kvack.org,
	usamaarif642@gmail.com,
	willy@infradead.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3 2/2] mm/khugepaged: unify pmd folio installation with map_anon_folio_pmd()
Date: Wed,  8 Oct 2025 09:54:53 +0000
Message-Id: <20251008095453.18772-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251008095453.18772-1-richard.weiyang@gmail.com>
References: <20251008095453.18772-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: ACCD740012
X-Rspamd-Server: rspam02
X-Stat-Signature: mo1tp8jrcijrq461ka3e5f3rnbutg1mq
X-HE-Tag: 1759917347-772976
X-HE-Meta: U2FsdGVkX1+dQBNd13FGLi6z71MgHq6aICncUI+R5V550q3YWGbH0De0f5SmLxYyvryUzOtQTNPU25e5cQibd+NXgHchatgaLCtQw9y38iLhvh1C5hluIy5Gl60eQrkO8qB1D0Uh/ePfwsPJAIIuaglRwNWBUhQyGCF1LU6rLLxrkxKnP/dk6E5air347dU+dQL7C7P/DkZMYeXbs1pukiDyWk0PIrWmxJFRr0ocyUpYGj5gP00TyFoY+qmQCKHUjusSOunWn/g6EP/R9djdajc7TbixgdSH8SWGPRmLUNJEr6Rg15hYuVdhBCmuiZTCH3RuZB3WXlkz/Z1bw0V2+GOHRpppQRBXwOYjR47jpACxkRsQbOKwJb27P2FxPFdkSElMepkDm0t6CXh57YiaTf2ZZDNe3N1D5Fn6B54PUCjJxZI1Nidf3IB9IWi2qFKw3gXr0hhdPrxqT+DBYCNXLg3KyesxNRRV9M0DVBU6c194ZmB4Yu0ndbZDPugm6rfV17fcJca3UHzeoBDuVW5Vrq+esMyhMgfRX6M22mdMQAi8vflTTTWIOFABUByxHMWuM+9nxbqa9B7PfI9TARq8a/ejIkieodOlkrGLQpg1owGnFxjAzhYSpePTQtP38y6wFbDeIUhXXfWj24wUzT7BH3yfyLpqxK5lARFEN6yIP+kqnV6/A+y5weVy0lfB8MhFnakmvMidSnzjiWQv/+eNxMI/cBRocQNMr7vDJ4Kkmsm85SDJ5DAgohJXu+RPiPB0alq0dqeBw7bLzQDsOj8l/Im05rMrpFZa8Wcs6JSX0yVE3v+vMPwHkkMNtQ867kMd01GhU4tdyJo5gWnZGrLWjdDptCk2t0lK5pghq2iJVsHGWRLsibp047ODEY+QH7/3L/HJWS8aEi6jPoUpj8PPQLKldtiKnKRdD/c1ryAZKJ7uznyuc9F1WPPbJgRmaJRgO/NR+S90UfcdyS654Ds
 z+71wQWV
 Ts1c6t+5rYgTPoXmCycDgyL27ygHaKagBZMh1aq1rkBbyu1Q6Eckb3TkhXqxpaXYrhnjlYfD0BiHxCISIlHX4kju3QLFItwV6FFXcVnMbdEeBRKg5C0vXGAJNJP9NMK/th7rGbARUizmqLKmHby5Ysa9FYi3bzDA3LYamslZX4qtzFvNmpRNsDeNtSZMi5vWZNuUEq9COFehR9ABfDfYA0y34o1CkNl5zuPrMQMOu1n1vgl0uRu1oO4k4TBtfy8i1YuClLYU+jvBIl5spiN6FhtQ66JJoNGzXwoaL4d0Ebi9H223XM6cJtiJegMQD+Iu6Hy98B5861kZQLWvZrTgUdRf0LVAywRWTn0UzjPkyfhm7ltJ6vFXxaVy35wPj6yX3JSuBJjw/JZ2Kc6s+EdgWsj7ZXkLgHqHqIhR4VupkXN3aNQhq4DOiyZlnvL/jtpP/at4S4coMDunYs2BtHebflzedJWiaOZq/kBfSC1NrKjqZkbDuXn13JvbyLd9uXpjwfJ8ImZ2KBgOoKXLoCHHfLwy+tYYHmau0T8N/ufHJcrYOvyxkuZtjWfMcevFUjlCksNSrzo++7Ot1ZdKk7FtOOwZSSVkKXev8C7F3Rqwzrfj9z4aP4iEw+YLc5hj6b3Caia3X4pv+Laq4w/omvsIid8ARiOWac5bXupVOKDIQZJfoKK5Aw6T1UeTPfEOsPrMJUfGRqa/mg8PWLgVZUdud/Sp7aeRLFmbaKKbEWe59RmSAn69uDDYGVf5Xcb8s6WmqhkshymM158zp8wI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently we install pmd folio with map_anon_folio_pmd() in
__do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
collapse_huge_page(), it is done with identical code except statistics
adjustment.

Unify the process with map_anon_folio_pmd() to install pmd folio. Split
it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
in page fault or not respectively.

No functional change is intended.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lance Yang <lance.yang@linux.dev>

---
v3:
  * add static inline and put bracket into separate lines
  * rebase on latest mm-new
v2:
  * split map_anon_folio_pmd_[no]pf() suggested by Matthew
---
 include/linux/huge_mm.h |  7 +++++++
 mm/huge_memory.c        | 14 ++++++++++----
 mm/khugepaged.c         |  9 +--------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bb48cb50c0ec..588e3522a1d0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -542,6 +542,8 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -633,6 +635,11 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr)
+{
+}
+
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e86699306c5e..09198906667b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1302,7 +1302,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	return folio;
 }
 
-static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
 		struct vm_area_struct *vma, unsigned long haddr)
 {
 	pmd_t entry;
@@ -1313,11 +1313,17 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
 	folio_add_lru_vma(folio, vma);
 	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
 	update_mmu_cache_pmd(vma, haddr, pmd);
+	deferred_split_folio(folio, false);
+}
+
+static void map_anon_folio_pmd_pf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr)
+{
+	map_anon_folio_pmd_nopf(folio, pmd, vma, haddr);
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	count_vm_event(THP_FAULT_ALLOC);
 	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
 	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
-	deferred_split_folio(folio, false);
 }
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
@@ -1356,7 +1362,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			return ret;
 		}
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
-		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 	}
@@ -1962,7 +1968,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
 	if (ret)
 		goto release;
 	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
-	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+	map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
 	goto unlock;
 release:
 	folio_put(folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..e947b96e1443 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1224,17 +1224,10 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	__folio_mark_uptodate(folio);
 	pgtable = pmd_pgtable(_pmd);
 
-	_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
-	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
-
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
-	folio_add_lru_vma(folio, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	set_pmd_at(mm, address, pmd, _pmd);
-	update_mmu_cache_pmd(vma, address, pmd);
-	deferred_split_folio(folio, false);
+	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
 	spin_unlock(pmd_ptl);
 
 	folio = NULL;
-- 
2.34.1



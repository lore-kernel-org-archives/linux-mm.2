Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EE5ECAC5B8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 00:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A182D8E0011; Mon,  6 Oct 2025 20:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0E28E0002; Mon,  6 Oct 2025 20:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869758E0011; Mon,  6 Oct 2025 20:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0E18E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:50:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0CB7CC077E
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:50:29 +0000 (UTC)
X-FDA: 83969487378.20.A490EEA
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 650D4100006
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 00:50:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GpzYGxmI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759798227; a=rsa-sha256;
	cv=none;
	b=zjF3G8pWdnjrjENlcAbnLF3u1BCcP3L6VqsJgoO/wbCXVOskyBWEkIhx+wIf5BKk6en2up
	qqJFQVpaRCwFUbj/7ET6fCnFOIu3Hok3YBIQWA2paWdZrJ5PHaDMSUkb0QUz7G2FMr8NGf
	UHwSWjdhDAHtLnWkyVwi/Ipc+kLTULw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GpzYGxmI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759798227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=QPIFL1eHI+DwWqXSRn9vp6u/dOQUbP71jmne4Y7hUSU=;
	b=M26UMYOsNdrSCTiCkiXCt/HuT+cjjNjKQSpxpLKqtntxjhn3JipNNKhjuIahYJkf6Ph79w
	Ld4+xt3Q3mJVT2V472JmiWXRd9WLc/QHbrUAzaiMG2MsIl2udyEQZduALPDsw/SRYP6emQ
	i47dIVvOKHtO/4XKxer/KDM4lSvISBY=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b3b3a6f4dd4so1042651066b.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 17:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759798226; x=1760403026; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QPIFL1eHI+DwWqXSRn9vp6u/dOQUbP71jmne4Y7hUSU=;
        b=GpzYGxmIxyV0wr3dHrupy+zMVQCi1DJibq72G1UKSNtD2xYUc25vdk+SIQmz3GKNLG
         K/+jmZJDz07hN8AEKGvGhxCkd1hZRRKkoUpCOyeVHWTdx6taNkvE2ihnZvJr2qbnlxgW
         B2TUS1NIWEMngTFSAX+kQyzU2ssZP2iKDd/9QejcBiyuy5C8qrtRstBkDbEo/itZ1N7d
         bWBywe38F8dl2jL3S7eM+e4RkV7MrtwrQ2t/ZnBpxD2OCvoQkVO24JR6MGVYMluJzCx7
         DcBiwHMMq/UkRHSQZ4OrlkHEt619WdbD7WmQlWCHijACitqEx05aemtbtMDWjFcZtDBX
         JPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759798226; x=1760403026;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QPIFL1eHI+DwWqXSRn9vp6u/dOQUbP71jmne4Y7hUSU=;
        b=c3k+HGN9/QEBvXKUaLMv+1HFnY98IypciGfmZgq5IolUE3yPALU34Gn5uabf+MuzYv
         r+GfaeK+U09ZvNDVH1aKsVOGUkbzFzBaKbOd4xtccLk4YgbJF6ZhUlW/ONgyONiq81tZ
         NmgrU7lAJEmmKwFC4jyiOddzNXiwUKoxjhtwLYoCYVBp9sFhGBLrCoCjuv1VSVge9z/5
         DqJ03YfwwR37txorlAsR5MSoSXF/MpOd1g8Krx8C/A1FszWFwzg+7uLyDyi1CQ7nYJfA
         S4bklQk+Nr6MJ3TP4HrZ2sfzJ13yhsuvSjsLqkK6dnIEMUkx6c4WWCIE3VWIez83OZ8k
         vQ5Q==
X-Gm-Message-State: AOJu0YzSieRu+xtvXVDN+gv4tJRVVe9Jip24oQUvWTD39/ES9ZOxzvE6
	bdarHdsaBC38dMN6Xx5/mpB5O1bXL1IcE7p0VpkiIiB/SifVRVMy84dG
X-Gm-Gg: ASbGncut0Zye/ZUmZ6QDMNgo5ZRwqxUsMisA/PNCCDAmTY++2+5lzZRzhUHWvp3SHfS
	r5LwKiOqp2RIuNgJnOxuibdiG+9GvgDkiAdbQI3oK9DMyRLYB0qZx6TmPc8LESspCZvQRpAkZa9
	uNXPiwcbdmhlEwiNWgR0KriHHmGeCBcgFipvs+wzV4NF9ZU6g0bVdC22nu7h75f0UqSE1pG8eUc
	v0WKjisMjGH5eIlRSnAElao5GaJ4nMu7dwxsL6S7nYXDkED9WPIRR+iJgopKQ7HdeY++CkDpD+l
	30d2Y02rBZQTjT5irKWLstB+XnyC5cgC4Yj8pMBNSE2Uq0rqvptkRhqeD0UNkOSujHeFdtUmC49
	b5a3PBsSee2hpKnMMXQykHUzqGZ1+POdWYySTlokB2JPgTAOZtw==
X-Google-Smtp-Source: AGHT+IGg9YQFW5lrmzTlfC0t5Tj/xLRecAOK4Xx/OFWRs4FoRumoqmCOU9VSKOtDZDmo2w0x7pVJbQ==
X-Received: by 2002:a17:907:2d13:b0:b3e:babd:f263 with SMTP id a640c23a62f3a-b49c1d5e6ebmr1995681466b.3.1759798225760;
        Mon, 06 Oct 2025 17:50:25 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970a60dsm1247354166b.63.2025.10.06.17.50.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 Oct 2025 17:50:25 -0700 (PDT)
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [Patch v2] mm/khugepaged: unify pmd folio installation with map_anon_folio_pmd()
Date: Tue,  7 Oct 2025 00:50:22 +0000
Message-Id: <20251007005022.24413-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: 86nxmya5i9cs14j7jngk9ezs6pwstt94
X-Rspamd-Queue-Id: 650D4100006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759798227-2567
X-HE-Meta: U2FsdGVkX1/uD+3Z8AJW24G1GBvjXqXjyp2dP6ET4RBT2ZIlxcvCHrT7rDf+hmp2nL+Jea9Z/yA96y9lUc5yRPhEDrP1R88KJ23J1qNusXYzLkGBIgAXm8Rc4OTINP82efjHlAbTqiBRRkZ8dZSW3PA3L/n30DAmKXkwAzFPYmmYbUeY5bTnXcvD0WRQNBJMAPOvVXZwS1RPXYTiCeU9updZYyfGz+R5TTdlLFbu/bDQHjOd9GKFlI93eIf0pn4AjhOpr8WajxuhHqSnVMlJYspvjdF6eWab3D6ld+Q/CpqGifukmFF81ukVQTlsMuXws52tGLm9HeRVg3WEMhIBy1AYno5zbv2wPaUaa9r4E4FH1dDKVBYYAqa68d6GWAuqrnf0POgbJ6f1ne5RH+MD8VWDSUDPq/FvKt8ttaNF1x0zc1ASiXuT+sIUu0nwcf3pwKfLPuV7C55DQ8lDztlhBNcgpE2Xa1WaFAOp5TrEFndXsDRZSUJ1//5ZeBazNQXVyphsxgMhpor9kh/kfc5way7CH92rQ2bHSEsoCe+59+Mcavpbeoi9aF57WMQ3liut4MsBnPCwGNXYw6WRvPrmlxw6WYjP0QycM8T5PtFYmaKyX4MebxkvoLJC40CyqtCr49yMW8zLqhRb7CtYCkpX101DgyZofr0Evb6iDEkDn1tI206NdeCaDI+jz5t6XrpZPVlUJYzF2f/8wJMp8HX4/MCJ0TtZOkqE5o+JnLt6dF0QiRsyIpg+7IKpkd5MzLA0d54lISgOp2uapvT4306OFrNS7lvvPsH69tAaAZCKBt+n6xbeUG2oULRwk9vR3kBnj+UQzQCbfdFEpMMR5dEBjdAvI4/f1c5rVKV4qben0ylROvl4Ub4HwMRgVbJi49NND6hwfaHMjqXplKN4xxCW+u+CqdZhzdiQEzuN4dTeiDjIT6UiIIaOaBW1zNwzo+xfSHkJMnXUWXKp2KuZwMn
 VZIP0XXc
 /yUWVOGFmU+MYlWDfW4qa0yeWtCzM3BfzxAsD2ZfHD782TS+hnWfYX4Za1ic/wj8Lx2As0IYnzkfFQDrcJHX7s9iCPH+jb8Jlu0Yq7OaMzX2jeJmsGtQ6KLvdXggJq/mhbARkEeEM2WBRjolJBHe9pgoyFPeVZjWqapjJQ2ew26F7yiKS0pTj6ue22Hkaet965ohPmX2EaKXe4J//QqBgdo0GQPrVT16Vcd3Ggip4pd85Ray1nAypS7AejEz6wKvhiOqfd+WKm5AzADgnvoWQ5U8VxHHGIfb6+Q/4wOHdus5k0JTxnaeyn0AE6BLN/UQBc8mmGhc5a/LW6tf/yeW95IezDmfnJUkQW53vMgZQCsa/uqegmZhRRNfXawn2Utcowg/3JLyt7cvO9pyqDi5pdgk9XeNU3deJH13I/a8h2dQv6EPcJ6gNZYGpJnB97xXElYKaXK4WzZMWWhvIlka8TpoTGIVSlSGV8jRHEhwdRISDDi+RoDpRX4rD+M2ouzlfU+K/NjUN62sY5SGPWuR6F7BLxxA49Z6e7+Tyc7dZVG84cXv9m29QoO1GW8dxd6YssuGfvhZ7jZQR2KhZsZhEbzTWW2stAo79MvEaVUHla0vnk1FBiqgdolDuM8rHYhtihYLgWxiumV4KO2Wdx3AYSLDv9U6T/lfcKy4FBaGebd0Ye1D7CrT1uvrtQ6EyeoNHdIQUmnyQjE0xzeBiX5eA4mT0frHC/ikK94IoJJ5mL+mvgeBUe4D/ISvwN/1liBXKS3R80wVhsp3nGKM=
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

---
v2:
  * split to map_anon_folio_pmd_[no]pf() suggested by Matthew
---
 include/linux/huge_mm.h |  6 ++++++
 mm/huge_memory.c        | 14 ++++++++++----
 mm/khugepaged.c         |  9 +--------
 3 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index e3ed008a076a..277ade3b7640 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -539,6 +539,8 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -629,6 +631,10 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 	return false;
 }
 
+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr)
+{}
+
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f13de93637bf..88960530b1d5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1217,7 +1217,7 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	return folio;
 }
 
-static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
 		struct vm_area_struct *vma, unsigned long haddr)
 {
 	pmd_t entry;
@@ -1228,11 +1228,17 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
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
@@ -1271,7 +1277,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			return ret;
 		}
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
-		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 	}
@@ -1877,7 +1883,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
 	if (ret)
 		goto release;
 	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
-	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+	map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
 	goto unlock;
 release:
 	folio_put(folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f4f57ba69d72..ce7181b6ae4e 100644
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



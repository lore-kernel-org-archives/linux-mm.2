Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E63ADCAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AD838E0009; Sat,  4 Oct 2025 05:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 185708E0002; Sat,  4 Oct 2025 05:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B978E0009; Sat,  4 Oct 2025 05:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA8A78E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:25:30 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88CB85C158
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:25:30 +0000 (UTC)
X-FDA: 83959898820.20.308F8BC
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id D3D9040009
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:25:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A+oaYkHs;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759569928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=mD+bEmoC51bjYGwibc7AIv8PCUzY7DjRjwyOv2XmPAk=;
	b=a5EAudL6wWLU7XM0Z1OLfGxE6G+xOAqbZb+RxwSSNsnjelXgKRmZVmSgoo8zJgNjBJxOXk
	rySpODCJmuHfSyvHS0sfSmRERs0QtkdTbpXg6Am/ZwAus8u2fb6a/LHPoSkY9xRYkgaFOt
	CAOxU9TEjFgpOELjGxmoWLTw3HG1cBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759569929; a=rsa-sha256;
	cv=none;
	b=cBH4SzwbaNj5JXBj4acdrTKBUYJH18X//bNFYkBZ99a0kBYdb1GxTaWWi0KKHT8DovRtYS
	8JZmZS56ZfzIoAokbElBYseZbSIOLsysPh/74bz1taGgJuuylNbMZ517OsLIg46+Ljwc2j
	fcykFw7aPQTaNj6FgCFi/gzfBtI2mIg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A+oaYkHs;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6318855a83fso6337712a12.2
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 02:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759569927; x=1760174727; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mD+bEmoC51bjYGwibc7AIv8PCUzY7DjRjwyOv2XmPAk=;
        b=A+oaYkHsVcH+JyoeWTzsaYAqioUw5nseJ/q0+v38sEQ8xD8jf+BReMWWQPAobUKa9u
         1sjUUND1/ELYar9TTGji4pI24vIzHhaQEbGjo5kENPebusxOCpTwxIjqiYFC0quJCCLe
         AoCJJzVRlOhfCDgiijgGdyV/j0NIGp/KQMWLe70PrjOHJOeax58R57iyJrCrf+x4NMnf
         xsp6zNkZdWwdj3RId3yJqwaQvlTEZ39DruwZy6/CHicKuSDqNswmC1hE9UrNDzweAvmm
         Tftta2ULE3EK2sZX1NrukBhlecFGuubYOhlHeH5JVLldMc9EiJo0M1rZWt7nTM83ayFD
         JX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759569927; x=1760174727;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mD+bEmoC51bjYGwibc7AIv8PCUzY7DjRjwyOv2XmPAk=;
        b=QDWkFgyOXE2ixhWomR/tGREw/UXBXFa8IwqJTTJMlgAW27KurJGvhignYiProTiU4a
         0FMLiM3Ngb7QCTDIil/2SBjfEfaEDuwwzTsCUo8xoFZHB3pQ/L+QOztKdt5bTZvRNqxH
         hmbpgQZrbuK0aUvUXp08F6rzAl+LRFkZsVsKvCJ5TohfNOCJlWhGTXJfFWTZIZliAD2k
         wr0VmxsGzqYr6BqJbnG1Q2zJzTAqcx/0PiuYjBPHjHrMAm0XEi0Hwolwygl40U20Rn/y
         9+Mz7X7MaQ3dcAczqk7Axc0DOgJsCc0wqV06okzTOMKIEXEjaXg80SPk9IkGi/3xC8OA
         ZHZQ==
X-Gm-Message-State: AOJu0YxaPtLL+Qwi4/uSN4ePWZRJS7NcXemPVYLcO+lM212JyCze4xsK
	rB0Z9NVLnGtTskrTNhNaNSAHCf5YOrvBKow7ycdFEWwOkKcPXjg5DBp4
X-Gm-Gg: ASbGncsLNjvX3hkdVjbb3gkCuWkjYASWOGZeFlNGPIGpcpFhUFePFtlWBu63ZjAbRoW
	D1xFWQI4AqAaJcIZCdkPFDRxIYctI+cv5jC7xeA4N4r8j+yLFJVSWv1O1NRG+swBpq6q+uLa7Zc
	l4UGHPnCGt1NRwQhREMnAczx0LuzVMOmC5Ap5lgbLYYUUcc/Ic2Owf0ZkqapF4UtZUSYP/5PUjd
	V+35Y92CSc6uV4exrLJ1pGL3fwBl6RZB0KaChEkGDgoYZDJd5aIXW5ayZZH7bAoqQauQYuyRhTQ
	A58hhEhVhfUbEnHQ6o94nA5EKCf14eOYRCUq/QAlVNemsJzLSz1+ElwDtf7GvAdbOzeOwEOSDTV
	oVAGxan3AuWkvusTL1QYYQhgAYAWKZDlPPFF3GErk+AK4T76jByM9F92t
X-Google-Smtp-Source: AGHT+IFfh8x8xGp/BUtENXowqreQKbaUyHONGGT9S2JahYqSWA8BGTbUCS3W3NPzCBY0wCTwZ4ILvg==
X-Received: by 2002:a05:6402:3511:b0:634:5db4:8fab with SMTP id 4fb4d7f45d1cf-639346cf3b5mr6495646a12.6.1759569926831;
        Sat, 04 Oct 2025 02:25:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63788110224sm5688391a12.39.2025.10.04.02.25.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 04 Oct 2025 02:25:26 -0700 (PDT)
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
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/khugepaged: use map_anon_folio_pmd() in collapse_huge_page()
Date: Sat,  4 Oct 2025 09:25:23 +0000
Message-Id: <20251004092523.28989-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: 5wi9ysyx43pr1s47mgswxp1jum5p3zff
X-Rspamd-Queue-Id: D3D9040009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759569928-541474
X-HE-Meta: U2FsdGVkX1+wI2OoElimjNmjDOasBhromfWe9mLTZyoKyjZAdcrXTv89GBnGuxzBxKeO3DE6od5wFdgWZWU076nimxrbqfVKhxLqZItny2W+fEuK3daZq9Vv6G+osiPuPo7q/TDS0PSgeqbET61mOEbXOCGVeCQODoU1PqVE3eV7Nm5UaRYiKyfYzv1hd1YUZ0StBCUakDBDRCkjFINOv51cO+UGYePtt04JhkGVP7vDFv6Q5LGA6l5GoYO3r3IlTFTRE+Qq1afKk5up1uLrpjgO/x41aSS81BjyFVHuyXAdqYr9mw/4LsNhps1cyxhvD7Hn3FvtzqTjAaT+SJqAOfVaXRHvlxZ/zKO89sC3vIsODWCPc3mjHkgQ2W52y/ahyE0G2UTSnbiptvqC+R28eCSJCwwfQOIR8aYlWTWOAYYnNtEQxFgzeOmvVv0eoKs7f4dnvP5tAh98L4lTJXBRd2Zogt+HqcZYVHWAiS3s60sLURdIfDJYU6KbJHQyXrRHiYi60VGT6lYysJ6ndWKho2CQG2EpYPc1TxIOgkQ6oJJ1l6Bc9gYm/LAaN+FLi8ou1yrmAW6Cvoq78d/T2p20txU61zrPCXA3X0VDgBK3QXa7+sLGXFDkmyx/Ww50fZDhyUWNlgNcC/ZBq407S+WNeHJv5fehBTeiEcBXmeU7PEKpTTLsZqeXk9sTUKvixnDQOSB7Hgu9ex0SkQ5nRfjFSP/B/YbAEDSGaNzrCzqK6WpkX5SUDhb56Hj6cf88dUnvcTocmeMIHzwOvZAjsJ7FWVhCtX8Fn58R3j2xgvjGkCRS7kUzaCRbTYyOUVcriISLtcd8k+rKH0/cv0kTYuOBkSaAZ+W5yEwfAx3gK+23vkSrHTaRGAO3cGl2F+GV1qJomvlMuC4OzrcPBM6H8s3xw2p7H1EyeUUAiwKMNLj3cS+a3nHfqD5cvc+3J+R8b9ItN2OJEY8mdIt5wLWab62
 atBJtmre
 RBGGX1+6fH1qzC12nMLn4KRmY4E1agQy+qnmqXHiLrinhvgg2XrLEaRWYmOj+4Q4DC0Z/6FvnDBxAk7jr1Zz2rS2QUE18MyGvGN6vBXAOao9l7B25GNgLRX3WT7hUaavfrDtPtFiDi1nh7JoKMflmwtOdqbepyc++7lHTQhftRhlzBlTVKCYnAIhqnSwjPlHe4RZ4eDWwF+jFQSGJf5oYYccWsVxS4mwa5WU9uAjLWLOH/GEwYCmvVowkBEu1SUXOFrHmNITPj+Sj79SUqUu8FssIWyuyRvhq05d+dj9pcfinHs14hfcA3onj8OrE2mrtyWe42/cL09JPrEQ4LruY7sgq69L1wyqW6tuiLUluIly7UCCCbJ3SGAF+/HFGKXj8hkNSH/eoialJSNSxL3F0QqiDig8PKdipJvgnggsA8p+YQgS/A9SbKZf6fE/4reEGaQpjuc/l4n6UqDnYgA3uxNjc/nYfF+Jx8Hl1wfD7iIooalr6w60/4LaPcXnmJJZMsBiPCEwxSHtLLD/8xWic4G0RLV4qhKsACLqmETHSQV8J+9LFqe4shQPxPxTK/llEtLaGbDI8QuRtLEw4RXpTNo9T9kMvIgDkDb8Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unify the process to install pmd folio.

No functional change is intended.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 include/linux/huge_mm.h |  6 ++++++
 mm/huge_memory.c        | 18 ++++++++++--------
 mm/khugepaged.c         |  9 +--------
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index e3ed008a076a..becfba48d17e 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -539,6 +539,8 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
+void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr, bool in_pf);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -629,6 +631,10 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 	return false;
 }
 
+void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr, bool in_pf)
+{}
+
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f13de93637bf..bfe38ca60a10 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1217,8 +1217,8 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	return folio;
 }
 
-static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
-		struct vm_area_struct *vma, unsigned long haddr)
+void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr, bool in_pf)
 {
 	pmd_t entry;
 
@@ -1228,11 +1228,13 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
 	folio_add_lru_vma(folio, vma);
 	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
 	update_mmu_cache_pmd(vma, haddr, pmd);
-	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-	count_vm_event(THP_FAULT_ALLOC);
-	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
-	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
 	deferred_split_folio(folio, false);
+	if (in_pf) {
+		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		count_vm_event(THP_FAULT_ALLOC);
+		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
+		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+	}
 }
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
@@ -1271,7 +1273,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			return ret;
 		}
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
-		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr, true);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 	}
@@ -1877,7 +1879,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
 	if (ret)
 		goto release;
 	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
-	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr, true);
 	goto unlock;
 release:
 	folio_put(folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f4f57ba69d72..cd187d10dee6 100644
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
+	map_anon_folio_pmd(folio, pmd, vma, address, false);
 	spin_unlock(pmd_ptl);
 
 	folio = NULL;
-- 
2.34.1



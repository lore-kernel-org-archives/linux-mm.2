Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA1BC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 273266B0088; Tue, 29 Sep 2026 10:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BFC6B008A; Tue, 29 Sep 2026 10:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B456B008C; Tue, 29 Sep 2026 10:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D58576B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:37:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F207804CF
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:37:36 +0000 (UTC)
X-FDA: 85267053312.08.677EEA9
Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7B7178000E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:37:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j2K5EQpy;
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790692654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4/xAz1VLOygf8+tsZJo6ClhlMvD4eb5AgBj+xphaabs=;
	b=6KG1ED1zHc7N4XzLNZpJXHwwX3Z9KGK+XYglrJUcvmrLyLSG4q/dop231caqZB4FYQOCOh
	1hICfjIM5fh6QNBFEbvsDK5v1OWf//z+aCSkzM97iw7aeK0XRAvPz16ZvSHVBgqUJXhAbz
	/Qh8o/Xu9YsCz0N4GXsFmV5CfdTKAjc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j2K5EQpy;
	spf=pass (imf02.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790692654;
	b=OPzdgzemRvKvfgmWPdpdGApbs5gPEV8He5dL9Qos1Ly48ki4ovjPgeQ4y7+1+taCN8t2aO
	h8Fry8sBBXncQXOuUd5p6FGFnhhMWnGjz/YSCoAUiUAY1EZgYI7PLUPUWQKla50GSKc5LM
	BFQifFbcFg5WDz9f+z43pQxxZ6eJPBU=
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0aa9d356eso3369336a91.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790692653; x=1791297453; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4/xAz1VLOygf8+tsZJo6ClhlMvD4eb5AgBj+xphaabs=;
        b=j2K5EQpyRIutlSSU9kbX3zojd+hWmJaytYTZjAmXFLuu5qtg6NldsvFW4R0yWDBn9X
         /eN5QuxG7hcukjsJKoWve+MUB2xt9zgynxgFntmgc/k9OBadQGtGWd6NX2hXh9tqnn7N
         AW3bWCCOY8iiejbKCFWLeEuNEirqjGyrxlb6rJ0mmipTiPyTV9iNYba3b3t6gVNV/p0p
         aCNyt17T/HlZNyVvoRc36q92JKzflj2XBMNZKvZI6faDux+f6B4F8rUMZ5ZZsqmM+/Af
         jTm+VPWbptmE5ZNRpduok52aTOFMr9K1LU9XiDDY/vVTdEE/aMaHTutRVIoHQ8ondIN7
         CKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790692653; x=1791297453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4/xAz1VLOygf8+tsZJo6ClhlMvD4eb5AgBj+xphaabs=;
        b=PTMqeeJLm7DTBvVnZA+I0MeAiOiYYt21tpUKFO1Yms57y1I1HOtRnSofm7x/xzXGCz
         vh5ieSuXj2qj/wMle2fHFrAPeETSLPYb0WhzZh8YYQqXs1YlvkBn+Yep6/qn5kN48XEC
         HEaeb6VMBlCANmcmqCI4tE40ZXKL/pUAn82NcCB9+wGJFZ36ao8JKXMUDz6UatYQBk7t
         NSF8Sv3CsZz+PNCvGNe1E1uBeSf1vtAHSakvYYja+fftzXf7lNAm82oeKJvBwGo82ppO
         M7iII+l1HqNO7Fk8tiGYJjxauzq4Ybh5bTX20NEm93nrCyWE7BsxYY3SVKYotj5vtIaS
         V0tw==
X-Forwarded-Encrypted: i=1; AKwUvBygQXPiI+dF7vG2ZscACMRdyTbiW772OEymmrLnbJj5R5GDYdy284lmrskpPy1TW5Ew/x3oBbWaIg==@kvack.org
X-Gm-Message-State: AFq9FYI8dX56CtrHK49y0CMxFh3y7d9gBN9Xcx7NddgiKK4GKqzJwqNU
	/z4oWsquhMqHRr6SIaqsC5QWgAYzY4FPDH3FbjiMTMMQc6zpwtgRuDfp
X-Gm-Gg: AYBFou0vtwkJaZlCe6sZpWmhrc/at3ASVQbyxKOMOhqrqXuFk3vF+zDpTsw41lhlCzv
	kszorMLFJC9st+EApQu/DLjbSR+rA9lk+JXdNvrqsoJlYE54HocObOoZ6MKYLAcZJMKVg9+bfd9
	8IgMI/3t0TXFrWChXoWsR0wXtukt09FNDKqo6fmZ/RJdDp2KWRapqqCRToxrB4nHnE26j+7d5yd
	/EcEeIuNfdY3GpcyFRbf4kTcZ2FmfQE2jwcYbL4eGgic3VqR7uGIITFKj6esSXaHvVMWROykT0C
	k1uXV0uKFlYPZhdVOlKvF5vw6OSejCluDC6mIRVgVwH0kZJd+iWF3KPetOAiLzLsvxvGOmHcjBu
	6WwjwVrCcH09LFuy+4mKwLNXw5bazxfhamoaOBb5S6YK8WOWGLx+eV6lOE2DtrTor2lhH4qfmwT
	FO4/yRdyHe8DXqbxzUNMKqEJAmxnNgdB9RrhVinF+tj0m7WQmnhLYz8pZagAcWX4Fc
X-Received: by 2002:a17:90b:5486:b0:39e:6a82:afd5 with SMTP id 98e67ed59e1d1-3a098fe75f0mr13422848a91.39.1790692653315;
        Tue, 29 Sep 2026 07:37:33 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a49869b9fasm7333202a91.12.2026.09.29.07.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 07:37:30 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH] mm/memory: remove unused vmf_insert_mixed_mkwrite()
Date: Tue, 29 Sep 2026 23:37:06 +0900
Message-ID: <20260929143707.450805-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: emx5priusuwj1bq757mgtg6uwdmygbzn
X-Rspamd-Queue-Id: 7B7178000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790692654-466901
X-HE-Meta: U2FsdGVkX18rWl6KWvY2m7wwdJxUfrbSEAbyKeVLXfcsxY+ZfA309I1O0mbgLudFHO9LyFCwSPRFl94IwQD9gaa4uky+kPIqcz9uMIsvaZ+PXIVa4RIcQpvcGns7BFg4KvyHeDzICdAaaLHcanNRnUJDO8mHjonZdmZY1y6PbgX+DsnFEpcqKhxQdZorA6XfbO6ygsyYA/gZSLwM4KhfrrsaKQD175VePH7s9RpnA3YQp/6B0hJ+jjHrx9RoZTKlZ3r0uL7yed+Jw+AzcsF8ID2AxyBeb9oSMe6TOeLgFCoOd/VJaIAeirsi3evoabg2HvMrwjh/RDBu/bvwjM2WY4lZSgz7BgGp+F96IOEiJEZdtjsx5iwTMwc+6CRQEk9Y3HmfbHqWx811BSYdG3y1oeKy7AKYH09U6VDBbMmN4kAD1F0eRC7QUu8pzsBeF5MKijF4KqZou8ndjLueW1Qp6e5EC7r3afKTacpLKzemzc0gpFL3j+b8G8qJvaOfQ5x3Qpq+l2/F82o3SdhCSA1z/bFSbuLA+81ZW0Tm/8WI/10PLjBEGp15jf5A+oC1i9jlKfD8dVvKUqN4IVTYIqOliL2ASKUHNDmwalXnuyv9vm6eMKSkvTH/aFTLngYs21Xwy1ti1TOVrmAqSnqhqteR89sZyXkQPsrPrmQsmWNR9ZbUpG0jjgS8d9ozjSBQETDho1GVEGOODkJyXYFf/CTtU72Mq0tZUYFAN9OUHrStdmygaAkGJfvCYMQDsxrUxdpSLnnCUX6ibPYEVqVsdMs8UNRouBPcyRZS/+NNR5JBlTKBsPAHMQ9VCFZmB15XJaig81L8N2g4UoCalZKqfumrKVFsJHSWHpInPQs5Z86ljU1crxEWbjWGVcIkH3aDCc0e6Nz3C8rd2vVqQuvUDKKIBcmiU4qPfhsVVujCiAFJ7xCUq2S+pt3koRtryBR1iKgQWB+MYX0eAwXX1Xp7lSi
 NBqXnxML
 8h3xfKp1H/e6arsV53b+CxQbaJl/C906bqAsgc6a45TMtmQW2fId3eb5CesnyQMnRdQ1yl3Fkc3yl5tnOz1iLOW3N+XJWtzWVFVfAtYjw66FOmuqsK2ohNKWZhWRFPbRpWW0URpaAVmVFDZQ+NkckpObQlMGV9iCXPl+BhMAwZB6QWCyyfQwKbNyQvuzfdE8t4b7foKDq1RkyqgCSdycvXGEdxeU12bWOLAKMY3Jy3EgeDjTF45ng9VEZbTHAoapLbnA8/Jl73MpMo5g6HtFEJPoEhlI5bOS8o2undP9R++xY2Vbpt00TJIpb1/vq2rq7OMTvaQcBYvXjsK5W1QQwgPigyttQtE+jWWgKyOior5ABNCohZ3ZGIfyUfvXuunqVwnQmy06jJGTWrXrc9nPMn/Zfe95rzxH+O230uKHofuJMNDYUdtTSW2WRgVy5Dmkxk+hw8F5AVtTuZGE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 38607c62b34b ("fs/dax: properly refcount fs dax pages"),
vmf_insert_mixed_mkwrite() has no callers, so the mkwrite argument of
__vm_insert_mixed() and insert_pfn() is always false.

So remove the function, the mkwrite argument and the unreachable
mkwrite branches. Also merge __vm_insert_mixed() into vmf_insert_mixed().

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/mm.h |  2 --
 mm/memory.c        | 76 ++++++++++++----------------------------------
 2 files changed, 19 insertions(+), 59 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c038d06825c3..2ac734efd4ec 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5008,8 +5008,6 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn, pgprot_t pgprot);
 vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
-vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 static inline vm_fault_t vmf_insert_page(struct vm_area_struct *vma,
diff --git a/mm/memory.c b/mm/memory.c
index 330cde31bf8b..1f83a26f8733 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2453,7 +2453,14 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 		if (!mkwrite)
 			return -EBUSY;
 
-		/* see insert_pfn(). */
+		/*
+		 * For read faults on private mappings the PFN passed in may
+		 * not match the PFN we have mapped if the mapped PFN is a
+		 * writeable COW page.  In the mkwrite case we are creating a
+		 * writable PTE for a shared mapping and we expect the PFNs to
+		 * match. If they don't match, we are likely racing with block
+		 * allocation and mapping invalidation.
+		 */
 		if (pte_pfn(pteval) != page_to_pfn(page)) {
 			WARN_ON_ONCE(!is_zero_pfn(pte_pfn(pteval)));
 			return -EFAULT;
@@ -2858,7 +2865,7 @@ int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
 EXPORT_SYMBOL(vm_map_pages_zero);
 
 static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
-			unsigned long pfn, pgprot_t prot, bool mkwrite)
+			unsigned long pfn, pgprot_t prot)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte, entry;
@@ -2868,38 +2875,12 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 	if (!pte)
 		return VM_FAULT_OOM;
 	entry = ptep_get(pte);
-	if (!pte_none(entry)) {
-		if (mkwrite) {
-			/*
-			 * For read faults on private mappings the PFN passed
-			 * in may not match the PFN we have mapped if the
-			 * mapped PFN is a writeable COW page.  In the mkwrite
-			 * case we are creating a writable PTE for a shared
-			 * mapping and we expect the PFNs to match. If they
-			 * don't match, we are likely racing with block
-			 * allocation and mapping invalidation so just skip the
-			 * update.
-			 */
-			if (pte_pfn(entry) != pfn) {
-				WARN_ON_ONCE(!is_zero_pfn(pte_pfn(entry)));
-				goto out_unlock;
-			}
-			entry = pte_mkyoung(entry);
-			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
-				update_mmu_cache(vma, addr, pte);
-		}
+	if (!pte_none(entry))
 		goto out_unlock;
-	}
 
 	/* Ok, finally just insert the thing.. */
 	entry = pte_mkspecial(pfn_pte(pfn, prot));
 
-	if (mkwrite) {
-		entry = pte_mkyoung(entry);
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-	}
-
 	set_pte_at(mm, addr, pte, entry);
 	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */
 
@@ -2967,7 +2948,7 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	return insert_pfn(vma, addr, pfn, pgprot, false);
+	return insert_pfn(vma, addr, pfn, pgprot);
 }
 EXPORT_SYMBOL(vmf_insert_pfn_prot);
 
@@ -2998,11 +2979,9 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vmf_insert_pfn);
 
-static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
-			bool mkwrite)
+static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
 {
-	if (unlikely(is_zero_pfn(pfn)) &&
-	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
+	if (unlikely(is_zero_pfn(pfn)) && !vm_mixed_zeropage_allowed(vma))
 		return false;
 	/* these checks mirror the abort conditions in vm_normal_page */
 	if (vma->vm_flags & VM_MIXEDMAP)
@@ -3012,13 +2991,13 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
 	return false;
 }
 
-static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn, bool mkwrite)
+vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn)
 {
 	pgprot_t pgprot = vma->vm_page_prot;
 	int err;
 
-	if (!vm_mixed_ok(vma, pfn, mkwrite))
+	if (!vm_mixed_ok(vma, pfn))
 		return VM_FAULT_SIGBUS;
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
@@ -3045,9 +3024,9 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
 		 * result in pfn_t_has_page() == false.
 		 */
 		page = pfn_to_page(pfn);
-		err = insert_page(vma, addr, page, pgprot, mkwrite);
+		err = insert_page(vma, addr, page, pgprot, false);
 	} else {
-		return insert_pfn(vma, addr, pfn, pgprot, mkwrite);
+		return insert_pfn(vma, addr, pfn, pgprot);
 	}
 
 	if (err == -ENOMEM)
@@ -3057,6 +3036,7 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
 
 	return VM_FAULT_NOPAGE;
 }
+EXPORT_SYMBOL(vmf_insert_mixed);
 
 vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
 			bool write)
@@ -3078,24 +3058,6 @@ vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
 }
 EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
 
-vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long pfn)
-{
-	return __vm_insert_mixed(vma, addr, pfn, false);
-}
-EXPORT_SYMBOL(vmf_insert_mixed);
-
-/*
- *  If the insertion of PTE failed because someone else already added a
- *  different entry in the mean time, we treat that as success as we assume
- *  the same entry was actually inserted.
- */
-vm_fault_t vmf_insert_mixed_mkwrite(struct vm_area_struct *vma,
-		unsigned long addr, unsigned long pfn)
-{
-	return __vm_insert_mixed(vma, addr, pfn, true);
-}
-
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results

base-commit: 1c2b8d2725f84b43fabe3b3e9628c91db8ca6c65
-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F18C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533008E003C; Mon, 11 Aug 2025 07:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BBFF6B0151; Mon, 11 Aug 2025 07:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384AD8E003C; Mon, 11 Aug 2025 07:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24A326B0150
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:26:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C67F0140135
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:42 +0000 (UTC)
X-FDA: 83764249044.09.698BB2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B3D4C0007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BSFR/Fi3";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911600; a=rsa-sha256;
	cv=none;
	b=wYaHN6NxcCX39A14kaLS1hjX9Y9g3qDMljNk4V0hJLcJKcKSa3bjI9+r7zBmKoh/vHSN1H
	IsgoQfxs0ZzA5ERgF//oah5CFLNMdd0WwIMah3s2RfGbM7LAk/GawZDJMGI8aCZUuVmKSU
	CC5whkA9Z35H3uwh64ymIc8/LipYbQw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="BSFR/Fi3";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Htya8lk0ohNZGoVKNkWH4Tb4G28S+mHG9GYTekXNGbw=;
	b=DYvMhKrABOjswoMJFCSnfSWowU0U7oqVXDEzs3gVaxV0MOmEMvZ3vUMEF+gbe+lMw0VPSQ
	umlBv7pP91Pc0Js3hX8Ny/Sv4VQEd1jyFrG5IRayQ3qsIdm74eZRwwD0cpJIc36cYb4bfb
	Sq3dg83EktG5jfl2XaLNJ6msfys2wVM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Htya8lk0ohNZGoVKNkWH4Tb4G28S+mHG9GYTekXNGbw=;
	b=BSFR/Fi34tP9TYXtSKf6EKayic9rWNswzONRojFnyHfcPvfZqbKbk1pYdoZv+k5ZXanlKC
	4pj2xi/Wk1jDEb46x/FoHBY6I0DYUxjAeV1N1okm3WVuall1fJ8kl28ToTSspr0DYwffuY
	xdWkElrZ4TN6nvSt5P+AYfKKi//FXn0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-cfNQEiWCM8KzXHLVt5f1-A-1; Mon, 11 Aug 2025 07:26:38 -0400
X-MC-Unique: cfNQEiWCM8KzXHLVt5f1-A-1
X-Mimecast-MFC-AGG-ID: cfNQEiWCM8KzXHLVt5f1-A_1754911598
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-458bf93f729so22140525e9.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911597; x=1755516397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Htya8lk0ohNZGoVKNkWH4Tb4G28S+mHG9GYTekXNGbw=;
        b=KjR7rKyIkAD+2m+7d9WSA/+on97lclIIGbqLa+fpCguX/xBILADYl8527NS/dsYdZ8
         MiD+uzKx805VJOcLVoicbBFgw79Td2bzKn/MwGbWtvJbMMGLHXnoAd3XJZ1842Rj9nJE
         gw7xuIC8t9vW6HY+tfUgxQe9u5rKjdndFfbqYrfkKm7C27jYessuZx/KSidA6zNc2ES+
         fIWV6touU+3nChPRNXblp2QPCVPjB95Hsoxfye6VsVF+1aE2L0w6ANn6ZDp4zKQqRlD9
         7hzpW+uylBoWjJbVt2O8CyTOcJToOmmz18UhBpgIDx4IhpZzr0fO7vdOvAAfnoJ2Yze6
         Q3FQ==
X-Gm-Message-State: AOJu0YwRqPP4LY+5KIKUAMGGOBCGLc5QNcNx5bK0obTcUKXjZFfXBME/
	5dm12e3SHwYs73rPRdFxDu0AHhYfUIEqe7rewmMi1ru19RYK5N/MS/UoMTJVT7NdCFGSFEMJlEH
	SYp5NmWhc3n42ys6s3yNt4m6de4O9CziqVqk0dP+JEunDE8vfhtUI
X-Gm-Gg: ASbGncvG0dx2M0GS6TmkuwAlMNtF8PxGAZtaJ1sj8Y6TB/73FHCyyJgSQRIJmU6G4EV
	3gLEz34ivpf0rl65HB5U+98/PDAwfiFMuNvBlx669i2+h7yjqQT1L7OXRogoKQyQAmx1E8xWG5g
	/4nGPXlqasPzeyGGUrVafS40lnL53N3T6G2JBV6qx/yDem8OVhnGnilT1xv/9iPnH7E9RBWxcZ8
	pA30rxOg67M6Fuenz1juCV4CODYgZR35ra71C2IxDY87iZlh8AV2C5K8H15TGJZeTJ0D8VdQBWB
	8Cc8hhjS5cR3vdIy378250CSl+1hXEuUGcbbcuh4pAKf2BUkXcc5hLPjPoglbJa22WUouRjkJrS
	8+3PHEV1w+iIOem1Ka83hmtxc
X-Received: by 2002:a05:600c:458b:b0:459:e3f8:92ec with SMTP id 5b1f17b1804b1-459f4eb4176mr127957815e9.10.1754911597505;
        Mon, 11 Aug 2025 04:26:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdNxb5gc4DwQKatpkXot61uX7cGVvKpORGwTw8/tHuwPs0r2lWbt+TytrRicLCoC+zeQmPIg==
X-Received: by 2002:a05:600c:458b:b0:459:e3f8:92ec with SMTP id 5b1f17b1804b1-459f4eb4176mr127957415e9.10.1754911596965;
        Mon, 11 Aug 2025 04:26:36 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3abf33sm40550137f8f.7.2025.08.11.04.26.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:36 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>,
	Alistair Popple <apopple@nvidia.com>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH v3 01/11] mm/huge_memory: move more common code into insert_pmd()
Date: Mon, 11 Aug 2025 13:26:21 +0200
Message-ID: <20250811112631.759341-2-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KNysN5GlAsiR3F3posIZlvifUyJuvzPTStiOkmTAyK0_1754911598
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: ydqifydp11ebgptnq44pxirbnez65fqt
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B3D4C0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1754911600-314484
X-HE-Meta: U2FsdGVkX1/E2NcwXXCDRCfwXqpaoTXfSyvlMdaPuqY7m8TQXpUE2b4b5VDi1Sxhwf/jcqbGyoTF+fb5iynsWFOdSkn/8IryzpMQ6gervo1CgFFi1+EQrLKPpynFIwxJjMLTh3v3KFLVd7OuTUFQCl36Thb6DonDtQxs0Ouigh2kucX701Q/BIc+QrB2L0eVhPn/Lf5ohgr1DEFA5Ggi0He1RENkWecjIMOYIpKt8WEtO3yCLH8i72IfdQ/dV/RzI2HsKS6q7TfEnQzEuPzlEiyz3jqokq14/FqpGkQn0hMjDHH76ChyOwHxUvV9Z4lDZqgSWvngOaLw24wOLVy9valbIQa+70d4cLyLNt4chVsYMMvkwnbIZTVuLAm3Gv0AYwO6+zXuvJqcCfqGecu+HDssX+qR+Cuz8E2IovbOK7F46/IdaF4vEI3SiKDZiZlqLfxvng20avDqR6Oi9FqFVNIepS/q4uOG5aHuR/TR8iQry7er6klX9Eu7WT04efbKNBnFC0aTg7fk2Fir+cpz2JhCWhq4WtE+6ZShN+pBuIQI6//X8D6VCILT+xuaOB1P9gmPHBtQRMsnG/lAAGsJhq78a+FLL1x73eqBDFKPZIORqp7brHKxy0ELBQJ05wVC1PXA/XnAx7zho3geat3J07/RdL9Zdhpoc+E912G8AxiWS5v5BXjW2YUONN8EfMDkiW+NWXbNIaik7e4jahB74aQGB8jq+D+Br6hQ7ke6IIJcODnYeqgMB9wbjr1mEnvTgBOMw0qxhxg9q1kHazL5JzIDJKA80fF2HkDRiqGt0KE6z6S464YmKEu5ZamjWTAKcpv0EeXgiOwB//K3EFIjqVsvIWXweB6H47N8DzxTShPnfZX2O4uwBefx9NzHod5KD0rlU/XuiAwQ+I1ecaJQZkTJmdBq5AfKE71CJXryf9m7+p4GxzGNghHUm8qbibV3qT+Qrl8kCwc74mxdan8
 s4Sr+jPt
 4A/kDkj5KkOk+EF5JWmvZVD/6rgKS2G1FO6tN5wihAipsrPXbTN4VkAAq8ZoQUEK3l5uEE2SCjrbPx/f8aUdD7fbYlRFAGoFrQbs88d1oufiQG1G7Vv2oGBuTRAyKzSDDQ6FfZkb7ZLjgjlBxHDQTrowVugiD9W/grsgmzr/HExvvvb75vOnrU3FetglBKpm94NNs8iTczQscmXOqXJKumcHwu8q2rEWFF5eRKexvohxUSOuWok6BgVYhMe7r39PPUwWi58nIknx+Y6WzvnzwXB8W0Pxclhk74JuiBJAZEOX7NrOcgxuwRB4Tr8kY3LXb3gLFqfOwYfMSSs65+UOqw2KO38MODtuSAkda2SgwVhy2IFdPOPGpmwS7tupFiGsUKsHfbe/48IcJ5Gfyztu7wDXpwgFkCAHalx8kK0778I1YMBM3E6y0nOcLjzs42RhozYdM38AIOGsgDW3U0Y9HLsLUuTAnvpRd/Lj16Em1gmzW3qsASbVKFYdweBEoY57zXUX9IFNkMYiXZT4SQwwSFNT//gOuz1IXa84OGk2HwtniXf36WXf2OZXNXgLiaPR/OBoZEHl0dFuBuSFfJQWSuzWEtYdRiG88tPw9v+4zFQaDbwjmxp+GFYe6Kb6RVh5G4+JIKsonwV/onBeu7XJgJF2UXkKdtcomUStQpatdbH2HqFQXUah6h6FXsf9bO+y3LaoUl94W9cuRiMpN23pJQ6itcJXxRJnYt6FAC4UGvqCOIEA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's clean it all further up.

No functional change intended.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c | 72 ++++++++++++++++--------------------------------
 1 file changed, 24 insertions(+), 48 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2b4ea5a2ce7d2..5314a89d676f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1379,15 +1379,25 @@ struct folio_or_pfn {
 	bool is_folio;
 };
 
-static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
+static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, struct folio_or_pfn fop, pgprot_t prot,
-		bool write, pgtable_t pgtable)
+		bool write)
 {
 	struct mm_struct *mm = vma->vm_mm;
+	pgtable_t pgtable = NULL;
+	spinlock_t *ptl;
 	pmd_t entry;
 
-	lockdep_assert_held(pmd_lockptr(mm, pmd));
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
 
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm);
+		if (!pgtable)
+			return VM_FAULT_OOM;
+	}
+
+	ptl = pmd_lock(mm, pmd);
 	if (!pmd_none(*pmd)) {
 		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
 					  fop.pfn;
@@ -1395,15 +1405,14 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		if (write) {
 			if (pmd_pfn(*pmd) != pfn) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
-				return -EEXIST;
+				goto out_unlock;
 			}
 			entry = pmd_mkyoung(*pmd);
 			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 			if (pmdp_set_access_flags(vma, addr, pmd, entry, 1))
 				update_mmu_cache_pmd(vma, addr, pmd);
 		}
-
-		return -EEXIST;
+		goto out_unlock;
 	}
 
 	if (fop.is_folio) {
@@ -1424,11 +1433,17 @@ static int insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (pgtable) {
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		mm_inc_nr_ptes(mm);
+		pgtable = NULL;
 	}
 
 	set_pmd_at(mm, addr, pmd, entry);
 	update_mmu_cache_pmd(vma, addr, pmd);
-	return 0;
+
+out_unlock:
+	spin_unlock(ptl);
+	if (pgtable)
+		pte_free(mm, pgtable);
+	return VM_FAULT_NOPAGE;
 }
 
 /**
@@ -1450,9 +1465,6 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 	struct folio_or_pfn fop = {
 		.pfn = pfn,
 	};
-	pgtable_t pgtable = NULL;
-	spinlock_t *ptl;
-	int error;
 
 	/*
 	 * If we had pmd_special, we could avoid all these restrictions,
@@ -1464,25 +1476,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 						(VM_PFNMAP|VM_MIXEDMAP));
 	BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
 
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
-
-	if (arch_needs_pgtable_deposit()) {
-		pgtable = pte_alloc_one(vma->vm_mm);
-		if (!pgtable)
-			return VM_FAULT_OOM;
-	}
-
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
-	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
-	error = insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write,
-			   pgtable);
-	spin_unlock(ptl);
-	if (error && pgtable)
-		pte_free(vma->vm_mm, pgtable);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
 
@@ -1491,35 +1487,15 @@ vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
 {
 	struct vm_area_struct *vma = vmf->vma;
 	unsigned long addr = vmf->address & PMD_MASK;
-	struct mm_struct *mm = vma->vm_mm;
 	struct folio_or_pfn fop = {
 		.folio = folio,
 		.is_folio = true,
 	};
-	spinlock_t *ptl;
-	pgtable_t pgtable = NULL;
-	int error;
-
-	if (addr < vma->vm_start || addr >= vma->vm_end)
-		return VM_FAULT_SIGBUS;
 
 	if (WARN_ON_ONCE(folio_order(folio) != PMD_ORDER))
 		return VM_FAULT_SIGBUS;
 
-	if (arch_needs_pgtable_deposit()) {
-		pgtable = pte_alloc_one(vma->vm_mm);
-		if (!pgtable)
-			return VM_FAULT_OOM;
-	}
-
-	ptl = pmd_lock(mm, vmf->pmd);
-	error = insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot,
-			   write, pgtable);
-	spin_unlock(ptl);
-	if (error && pgtable)
-		pte_free(mm, pgtable);
-
-	return VM_FAULT_NOPAGE;
+	return insert_pmd(vma, addr, vmf->pmd, fop, vma->vm_page_prot, write);
 }
 EXPORT_SYMBOL_GPL(vmf_insert_folio_pmd);
 
-- 
2.50.1



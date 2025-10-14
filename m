Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D8BCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF8E8E0111; Tue, 14 Oct 2025 09:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB70F8E000D; Tue, 14 Oct 2025 09:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3E28E0111; Tue, 14 Oct 2025 09:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F21E8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:07:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D03E1A08D6
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:46 +0000 (UTC)
X-FDA: 83996746932.17.9C0CE68
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf03.hostedemail.com (Postfix) with ESMTP id D06C520008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J7feCwDC;
	spf=pass (imf03.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CkpXGKpXKtKlCO5zwgLFmFfbihhvMchmw+GhvR+fLQ=;
	b=zDc7xVF/mNzxieR7whUcdX0E8l9U5VHwZ3EVh2FIwcmseIGOdl5MlRywhB0WUZLw6zI3sh
	0XMxmPxyNIAYukjExB7Gs6NoZ9m26TP7kqwE9o/hstw5FtqumIsajtRfuvIsO6dxP/DY1T
	Ls8JIM/nTDKVZg95pLWo8Aa+J1Za8W4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=J7feCwDC;
	spf=pass (imf03.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447264; a=rsa-sha256;
	cv=none;
	b=EJaA+9v+V4tgepKTTbL1jwWJhFBjkfpZ0Z6JlcHAm6a/qvdHQZM5O7zLX2olfI6MoFM7Mh
	zJUWMug+hK1UzSydAToyp5rmkcd9WSX3lfWmEWf+1FJ012FV9vJgywkPLLUDVjVA9lUb9+
	/0WoQVE0DnbG0+dDWKxgz4bYQpHUegg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760447264; x=1791983264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lfUFBXUxo+w4vJ46hfUjKQJDAze+72p1E8gLDcEic/g=;
  b=J7feCwDCPB3BEyYO/3z/bt4s2KqCpEFxBNAgM98gMKWerd6LbZk3DCgE
   7+l2RDVldsLBHy9GTEBJr9iMZ+KrSWD/xyJIhZkszMBfGrIlGqvGn35e4
   HljXsuqyTi+RVEqhGkSI8mDKQgztFDoda0dzCkdUDMqa8lmrHEx7YdJ7C
   eQymofGC9ZXspg2vCa1mRM4KUkI+Ly/z7IB8YLazR7oPtV8zp3quLiGwp
   ETtvkEfhP4+iDwWRW6lUcQ3kqL5iNvLnCiMxlShrzaFupq5a9wA+yGKyI
   PqkU0bB2OZd1Z/2PAd212McBnHjRHya6uBk1cDvMuf6Plp9Oi+JjX0cap
   A==;
X-CSE-ConnectionGUID: eJxObUDlTnqMW39c9+C3/w==
X-CSE-MsgGUID: 0JbsX8EoSfajhztO+hpqEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62515355"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62515355"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:07:43 -0700
X-CSE-ConnectionGUID: fEakTVjhQOicHC7aB8RVkQ==
X-CSE-MsgGUID: Aj7IYaXoRgOL4s+gZknpVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="182675578"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2025 06:07:32 -0700
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>,
	Yi Lai <yi1.lai@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 2/7] mm: Actually mark kernel page table pages
Date: Tue, 14 Oct 2025 21:04:32 +0800
Message-ID: <20251014130437.1090448-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
References: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D06C520008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f6nxfkajh6szuznbco9zsffmsdsc6d78
X-HE-Tag: 1760447263-657749
X-HE-Meta: U2FsdGVkX1/7cpYCzLEUDNZihWLkAXxQa1qMQQzRKnsPqIseh2CwBCgmgTGEa5NqF6Vxg/NDnZNjFvF2VZeGWKvPTN5XrqYwHH28YhOXm+3ixDQ9Cbm9lr57YmL9HraMuJuf1FC2SPHahvzJtkkNe29dVrt/eh9XY7gqBPKvjr/WmwFslhtTjBuKTElAERdSAEXBB2lUiAek2KK7UnI0AeX5wwKaS4AaTIJdgxgRxR7Y1+WQIIc7JPvagxs87sEVMbdXcVhc+riS8nBL9LB/C6J59CyozN2OKrOPzyb8N/Y/WlF2j5/n2yqzTvVp6utdhchkG8zSxoH/zBgdmCbBzCFmNK/zKpSe7EL48tLBxf+mNpZISaaG6lUCcRSsCNifN6kGIrdbm3k5qGZQpDHu1H/EXS2rAQXyZ00DVXLDBqLKpHrwjH884Cr6Rl3iZwK+f1S/lpx01W4q2W9/jY+GRMqdPYA4PjEprWpyEYy9eC7HBjnNmWPX4Qf9BOvNwIMzehe+AySmi5WVFosHfx1Gl8r22EXMx40OazyMMZ601/msrAua8nRxPjCH/ar+P/E0vKlQm37M31LrvLmSkgV9EkL5uFugtQ80IcdDSL1/KSXs2Jac8buaJwEeZ4Fc7e79HlIc/llACPIJJ9hQrKiHS69XSZ1863pqBcE+tARwmPP8jzfoqYL7bsIaeRx1G+vNwt4nenVMpqeECH9AkLTd147IJS9M274ByY5/TZCKX8xWJr0MICwBtaNaDVUD2xnwviqexgA8NYJufYTnZlOSdmCdmpdpem9F4zigKvfcdgRD7b1iw+kdwhfnfm/Png8nEZuHS5unPXYmBe2Y2aXYwXbLcFbKDC3/NaXNcLgoTZDaYfcqUQNsQnKU/bvXPQyZfigS0exciZuHI5div7AUb1/4SG3bgSizTPs1nQdzSKU8+tNqun3Fc5/GbJ23Qk3ajUgFyGks9o/cEcNsKjp
 jy+w90Wl
 k19WRWJexF4IAuFO9363vRra793zkMSlHjMGbblJ08iMfE1L22P5ipCyMCCCiCZacngCVTOzvjqknk81kIG8spABOAKNNFWGV/xTa4m+j04pzQBSeD3u89DnaqSnFN+wUS6sX2UgCJgsM24LRE7xDaDiNoQDWOCl24FY1PSFU3+mVOWQ0k7okBnrDWxxvECIfMRLfmd3WlK8yWMK8btPkF+Z8Et4gzrhcrzJi35SKNzVPTcXIJhMH/w/GvK51+WIHCMbpDMKNhkm1a5Bid767zRkkCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

Now that the API is in place, mark kernel page table pages just
after they are allocated. Unmark them just before they are freed.

Note: Unconditionally clearing the 'kernel' marking (via
ptdesc_clear_kernel()) would be functionally identical to what
is here. But having the if() makes it logically clear that this
function can be used for kernel and non-kernel page tables.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/asm-generic/pgalloc.h | 18 ++++++++++++++++++
 include/linux/mm.h            |  3 +++
 2 files changed, 21 insertions(+)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 3c8ec3bfea44..b9d2a7c79b93 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -28,6 +28,8 @@ static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
 		return NULL;
 	}
 
+	ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define __pte_alloc_one_kernel(...)	alloc_hooks(__pte_alloc_one_kernel_noprof(__VA_ARGS__))
@@ -146,6 +148,10 @@ static inline pmd_t *pmd_alloc_one_noprof(struct mm_struct *mm, unsigned long ad
 		pagetable_free(ptdesc);
 		return NULL;
 	}
+
+	if (mm == &init_mm)
+		ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define pmd_alloc_one(...)	alloc_hooks(pmd_alloc_one_noprof(__VA_ARGS__))
@@ -179,6 +185,10 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
 		return NULL;
 
 	pagetable_pud_ctor(ptdesc);
+
+	if (mm == &init_mm)
+		ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define __pud_alloc_one(...)	alloc_hooks(__pud_alloc_one_noprof(__VA_ARGS__))
@@ -233,6 +243,10 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
 		return NULL;
 
 	pagetable_p4d_ctor(ptdesc);
+
+	if (mm == &init_mm)
+		ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define __p4d_alloc_one(...)	alloc_hooks(__p4d_alloc_one_noprof(__VA_ARGS__))
@@ -277,6 +291,10 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
 		return NULL;
 
 	pagetable_pgd_ctor(ptdesc);
+
+	if (mm == &init_mm)
+		ptdesc_set_kernel(ptdesc);
+
 	return ptdesc_address(ptdesc);
 }
 #define __pgd_alloc(...)	alloc_hooks(__pgd_alloc_noprof(__VA_ARGS__))
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9741affc574e..15ce0c415d36 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3035,6 +3035,9 @@ static inline void pagetable_free(struct ptdesc *pt)
 {
 	struct page *page = ptdesc_page(pt);
 
+	if (ptdesc_test_kernel(pt))
+		ptdesc_clear_kernel(pt);
+
 	__free_pages(page, compound_order(page));
 }
 
-- 
2.43.0



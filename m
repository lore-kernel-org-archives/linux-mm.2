Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C122DCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28E318E0013; Wed, 22 Oct 2025 04:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265A08E0002; Wed, 22 Oct 2025 04:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2B68E0013; Wed, 22 Oct 2025 04:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6268E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:29:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A886A87C4D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:36 +0000 (UTC)
X-FDA: 84025076352.08.69394C0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C2EE2000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jtIOxvSF;
	spf=pass (imf13.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q1k8EOMOD8OQI4DKStIvSg7oWY3UG6gM9vLaaWPWK+Y=;
	b=Rmjo+G0RfZUMSklaH/sZTKcoMRADXy14KdmohFYwfwOaxY1O+96ucy0OMGprKLfGT/hej/
	Bh68GXF+Ao2/gcXmogQZZfwez0jC4EBVkzH4CIfN3c0I1mJcuJ//Aw0N6dr4XD1o/G3U+h
	QbSP9rw7GyhEmiKmL5u4nddWJKlPdzk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jtIOxvSF;
	spf=pass (imf13.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121774; a=rsa-sha256;
	cv=none;
	b=jOXj99VwXIos+3KXQKOLrTZMdr+6Kz2OGgxTgh8Bfxp+1bLLXTpspCuGqJ2Pank4y7/rOs
	Ze8TH/XuQVW0X6yirPS4NIvEWyXhp0DXrGmLX0iZJAt+KOZFOEZ10Qe3L7mf7JG8hfqop+
	/ubHosNJSHzVsIPkKfOiFDJ6bu8Qumw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761121774; x=1792657774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6/Nv8E+vFyhulzaBjC/GB/VBGNF8clh7bzlNZP5LHAk=;
  b=jtIOxvSFRVfsgMqrosQVDfoja/Ea7lK0lo4rWm67aVvc42W0uYZ5Lk/M
   DAGD1wBE0ZdMDlFZfPlxvbVlhahR+es4nv+MHE/6Xs4Lx8QJq1xG918xl
   RkB28knjoiYaXLii+52i9nj32GfpMQeq9XKEohL0RcRq4Kbp2bLrD2iQQ
   GoDRyJ7cBgMKDYWbFqiVlLQki978WUCuYDj7s0c/2EYNPWEkiNfOUi+yC
   pV3zBZrw1itg5AKLJIU89djBM41QTRMau3aG/FsvPCqgjKa4o5EnpREiV
   jQhig0tXWlYefvkV/GbRxfPcHn2mSVFVILmhtTJ2eLIHguFNABJOmqu4s
   A==;
X-CSE-ConnectionGUID: k8o87NM8RGmipW8OEbu0FQ==
X-CSE-MsgGUID: WItPYjqRRTah2OgLLgXkVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="88729900"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="88729900"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 01:29:33 -0700
X-CSE-ConnectionGUID: qms/D5zxRzOlqkuzqQHGFA==
X-CSE-MsgGUID: zjDxKFmJSg6hP+Fa5Bz5bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183516294"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa007.fm.intel.com with ESMTP; 22 Oct 2025 01:29:24 -0700
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
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v7 3/8] mm: Actually mark kernel page table pages
Date: Wed, 22 Oct 2025 16:26:29 +0800
Message-ID: <20251022082635.2462433-4-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4y3oedsj4wz3uicxrabtbsmdkpsprkpw
X-Rspamd-Queue-Id: 7C2EE2000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761121774-228559
X-HE-Meta: U2FsdGVkX18dJa5xPrl/YO0bcspYEIdjOmAx7G6qwIjDfvYxxT0nBgE0Qj41m9sbsNUQvs3AevaWOmghm6nAc0ZNQ5IfJaZt1p0ItcvAfae14uUz3Rr5yAKxKl60q5PhWeh57RwRm5fLkufXkOCKz134nPuzz/sSTVEZtFVvd1POjgpdvATR4EtQSzR7vqftmFC5M/Hf2Sohfpo+XyGQbs1Wt0IKOL7g8igsdkurchAIke9Xk5GUlXbeZSCwdjJ/CN8/sMsY9EJubDS/gjod7llTZ94oMXE8RQ6wS1PMagaPkKseb3bH1evO4fc8PmbSdKpPGE25YP8uSnidQl9uXgC+X/9+AzVX81kdPEh6D81LbcBG90LXxquqrhPjH/i5jLXmyK1zBRjGENVh+0Nsy/eGMUePBo3/SXa7s1FvflZ9qvcUc33DFB9w4HOdMD/4X6Dw659hlkrki9KdA2Aoc+HHoAEHzPK0cM/DvrXUzvIgJ+SndMkdn2ZYY/fIGKkUHrGkqQsx8ntGQ+d232VMoDctphG9l/JXhZf1POY5cIYaXJ5hhHFAb4G1rhmopC0kjyaSMKqMPKLuaAyw4smAoScPnazYTkHS+3gKa+yEdSjgFtQGCh2PjRuOguiTEjHUUF/tsPugU9lD9nqFKS2ruUaMgbTxvPS5vj9mUmoAn0wbtHqHf22NaMLiJCvFlGETzwXQIM06qEPYXZZeepKlQDYPLjC2SyIwgV47NFrRm9yeMuWL7rX5CMtjn9SCnPvt3DjhaQupgyhSYMR2yvESDAN+HWYsu2m+tLt9NQ3XeZr9GM1N7q7LA1aFZEWCzKCwRMQeooMoKSdHkh64Z31LNBAY8mHxzoAcS/FdkfYPLV1UZUNk/yJijejnGRCHdtHA9TeNtfEbfcaClB+MSP+Newt+MxidFYhOLLNmCvtz29tB5es4KjWWvSPctRYUJjBJjLqJZgya0OOV+Zkynf4
 LLBTZurt
 HpLZOvT8xXLS5Q90gJ+Mzfjsu+pn1MnZqevUSMrdLH1OxSCwcN7tdVTVobT/VHiE/oFbGFghMk3xKq29si/5+nBW+9KLrEZEITS0z8Y72Cuzo5qNfc8kHsFc3V4DbkssTMhr+KZDkeQyO9uC/u0zOwQwlNPiJZW1uXctggHrZgtVlew9In91/tTvcbBu+srVfFprFszYQHk+MQp5K+WYO6HF1vX26fkGHIy3BmdKLD4SCSJwIkZLKypl3aDI87h9iVGFLCulV0wElOKHTXUdTTXrKQpQM00gbyuxR
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
index 354d7925bf77..cca5946a9771 100644
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



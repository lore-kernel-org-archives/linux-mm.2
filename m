Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DBD4CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D60FA280028; Fri, 19 Sep 2025 01:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D117628000F; Fri, 19 Sep 2025 01:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C00B3280028; Fri, 19 Sep 2025 01:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ACFE728000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:42:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52B951404D4
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:47 +0000 (UTC)
X-FDA: 83904905574.24.01BD89D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id 212A410000E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EDCbuFfg;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6Kqef2TZej7RTIAyuTKxKcGVeGm0pefwgkfbXIqAiU=;
	b=3QRhR7M54qFHX5bYq4LsPGhSElbvlrXHlR4RC18y3b4fGVln8v1y19CFufls+IqPIe6QCK
	W+RR39L04cO0Y6GSuZJ7RCUail/c068newbD3UwUWp0Y4Y27ozSbrsGwsur89HXMc/VM7W
	pQO3AcFSnG2zKZ5Pjd0u/XG4k9egSjc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EDCbuFfg;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260565; a=rsa-sha256;
	cv=none;
	b=EUc+BajP/Wco5ur+7cYnQ39v4PDrZob9pRdexU3CLcNvMZ46yjW4XS8jBnCU13xgjlTs6v
	R+/qfAs/yWY2aloFUKjMAm/DrqIzMCaM4E1UzNoMbTIwehECekvm2niECpHKLsnDj8fSjY
	lAJF82oOpubU6nEV7lOZre1cqyUVzPo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260565; x=1789796565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dg5FMFxijPdUqcW/Tef7765KtNVvQQKVcrGVoDEOYaA=;
  b=EDCbuFfgNGumufU3ql2fYJprgEfZYQPQyfeHuI5b6NMmARcwdmnOjRyv
   UJmkj4iYIMeluA3QmIva3uHzt9/Vtb+4oRLF/W0TcgqGjmTb32ElzkCpD
   Ap5v20eQsCmwIuuTXzAkabVhNkuVo88/p2XiVu0m3Lg0K+9/3JyBBjLrq
   caE7yFaUGagK3cKFFxD4eWyUSQAVSN5Dlf3XnSI4YnZaqLJ0ozB8hOIFN
   O9XDNhcVwE7+mmwMuW6Quqa9k/+dLYGgRpwK/GF663gZfYNkHBA1Cxxn0
   7LNDwaa/lnhNEswDPgeFna+SFk2VBTT8L8C/Qwh0AMwc8kxCmu6dSTAte
   A==;
X-CSE-ConnectionGUID: LUf2lmDiSPmcOCKRmu7zaQ==
X-CSE-MsgGUID: R9xmO+86QoaO9HZBnUlKnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="63235744"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="63235744"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:42:45 -0700
X-CSE-ConnectionGUID: oGGKEl6tSHuZAt92ENdozg==
X-CSE-MsgGUID: ogkZWCFtQg6LavjO4eounQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180858596"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 22:42:38 -0700
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
	Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 2/8] mm: Actually mark kernel page table pages
Date: Fri, 19 Sep 2025 13:40:00 +0800
Message-ID: <20250919054007.472493-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250919054007.472493-1-baolu.lu@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 212A410000E
X-Rspamd-Server: rspam05
X-Stat-Signature: fh4j94cka313wuqmk7xk4m3q89855ann
X-Rspam-User: 
X-HE-Tag: 1758260564-819253
X-HE-Meta: U2FsdGVkX1+K2pYxRqOJOY5FgryxJ57U1dJfhHfO3BA4KzAQHth0SaYBNlkHVw6OEzRrKghA6ZmC67kOppxVikneH+xmncWy6ZMq74711dV6BYlrOOlj72nbIBVBhT/dU4aJkUn8d3bn/fOkZHQWO+CN9N/of2p6WwZx+Phf2ypjPHU4pDKh2HV6olxilTWUXkLigER1nsRf4Z3KyaWuSZNOhojchyWMeGw6HFDcWmF/hhYyhBcNC7Rof4il0i6Poajjz1Gu56t9lJNXy7uwWiM+P5bvXd7272wiLhywNbERVkSCFoYd9WHgXFIwBDz90dg5NsLB57B5tDnQbAd49QCH3MZjFBT+ECaLweoh7h2VrGTclwYz6EZhPsF0rTWsA+zWgfUilRhmbcoN9aNeJMrql2/Scq6um6NSdPfzbB+zukHkU3G60ZOK53z8MziAw0248oDlxgekqxoBSjFRZeENorDwn/e2AnGAOu96xN9TI7uslfFz3GSJQ1CqQsg5/2UT9PkM9iFdGp2tIToEYaIhPMvAcYOYPKafhb7cnyVvCfqLxuDLh9YK96yC8dOEi6atI0bt5ecHCusMQWl2Cgh23moE9P+H6BFChwkVVU4OtUs8GNz0nJKaTFbVEuA0rr5gYWcSl3VKuvuVvlmzX0tiNyCWg6yrQIeTh2Ts2o/qiLKSXEBG+9WeCU0s9eqmw7M/Lg2mlLVvzzkdyHw3wW5IQvTCywWs6Pj+ExFGQNzCLYkIX58OE/eWccJaj6WJa7wwdTNeF4EEuSzbiSNLInBiiCrkQqOVqnSaim/xuB0PYLSXEOv47zue4xvakK/pSGetL/DpQxNwSkWtgelzxt+IP4O4rv+TIl2lGU3Ny1IJUPFD6evNAf1+D76pHZvsAueliTAmeFQ1PupR/tLQaGGgw2eKP5OaPuYW5rQ+ZZ9V3vIWd0Au8zTItYC3mY1/GCVChemgrLKCSlrfqE/
 22eG6Alj
 EV5wxcgpHgUROWAm1BkRjOYQ08tOAFjfwPp0phvRFhB+JTOkI4IsEI2B0HncziG4KLBWoj89seiJkWajVYlEsX0gu60Y8kpvch/dLbk6xUCDzZnNGlHwsm5UoUbu1LYY830hXijy6tzchvZLyVZtpad7ZGaHBApgEmCakwRXNXpmBwn0yUzjsop5d982cB/Hrg2Or+iVsWWXniqaKCZFG9Gi9QNYns9/jIf+j
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
index 1ae97a0b8ec7..f3db3a5ebefe 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2895,6 +2895,9 @@ static inline void pagetable_free(struct ptdesc *pt)
 {
 	struct page *page = ptdesc_page(pt);
 
+	if (ptdesc_test_kernel(pt))
+		ptdesc_clear_kernel(pt);
+
 	__free_pages(page, compound_order(page));
 }
 
-- 
2.43.0



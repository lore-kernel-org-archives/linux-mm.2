Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9B39CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9566B0103; Wed, 13 May 2026 09:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480C86B0105; Wed, 13 May 2026 09:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 396796B0106; Wed, 13 May 2026 09:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2557C6B0103
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:21:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3FC91C001F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:57 +0000 (UTC)
X-FDA: 84762459474.17.594EBC5
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 22E3A18000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:21:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fYtuaNIy;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=09ZAgIruVIYnDt/DEHrKUKC/462Uq37TlLUpE9pDl/8=;
	b=1tqlxum2cpYcoTHFz5eCkrdnx6ZWM6xPgankEtnIoJvK428cU06UaXsRCHf3j5YT5w10g1
	zZDL07oKFXAaXfgAHG5O20C9H6jtB5XXhTlBL52SKzXGvCDJfm7qq/fuCSlzTCqroh//4Y
	nk3OrdOTnrUrBUiXjSAFdiuJ8bf64PA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fYtuaNIy;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678516; a=rsa-sha256;
	cv=none;
	b=J6iA202TMWmiaANIX45lIYWptu9WEArxj1qWi4ZbxfNMOICs8SjhHWRvwPmvxynYpmObnd
	Z3x+7ye4yJmGQ8MRS3bMIgO8Cz9IE3C+Qk3wJ7s2u8kIVW5ViD5LL9AwoQs29gGKUTwN29
	Kp7yvmHbhDXJdjl9Xr/Nxp8sVvwny8w=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-367d88b9940so3258793a91.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678515; x=1779283315; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=09ZAgIruVIYnDt/DEHrKUKC/462Uq37TlLUpE9pDl/8=;
        b=fYtuaNIyr5l3i8Yvh1C8QxHuN4JBPtrgv7Se5RSZ1UTErM7Dm0p4eWftQHu5paRQ6X
         Yc+YSBXKReOI3mAhmvfl+Gujc6GSMMKZYRir6cfpenlBB0WMXAkiVslLEh+SLDti1HQY
         eLGpNxykX/0D5J1pNg4MLriTODxvmxQhqkoiWpbd73rLIqRFgvOINktT5ZwdmQvxqqmu
         nIPyXmeZ+scvEvdRYxo/KpJh2+sdqgFQzARGP2iT1pDW7h70YHtxYulEQbV5o9gz0uRO
         s/HL7TVgQ5gjVuJAh5emPgc1GLcNB+D6DkGGsSLVibL1h5dkEN1XJwgmIu2lLums0Vvl
         JY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678515; x=1779283315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=09ZAgIruVIYnDt/DEHrKUKC/462Uq37TlLUpE9pDl/8=;
        b=Um2OflTtYudYj6bg/Xb6VdQsBs2viy3yJJy19qEpJhECgYyiQfAQHtxE4asbgcSWIo
         kBoBY59BX0TjUcLE+rjYbmGWqe5SZIn5ob1LKovSwafz6S0c4UX2ELP4R7y3qrMhXUZT
         tUq+exLjl+S0teu04ICpcsfDghbsRZSEIYlf2aB/Z3NBWs5/VfMEcLXJfZvUt4nRuRg/
         +YE6SYi2hcQvcRH3N3r46TA9UjUV7mHM27yZ9pKNuvHafGpOQojYy3RVdoCbA5Uz1Yjq
         gdCVd7/lGG6/0CJ8SeBwIV3hSbzZVEwMhMdFPUJ5ZtxptB6jk1SaWgoyTlihF0qphv3Q
         EjSw==
X-Forwarded-Encrypted: i=1; AFNElJ/bzDrghsCYNrZDbhoG4JqjWIQ1qeSJJ48/mqA1H4xgWoYLToSPTv6m3JislEBj0aXsJESa8iHJSg==@kvack.org
X-Gm-Message-State: AOJu0YxLIdAhyBdyrUmDSFmctnuHhTDeIxLEWbychh5Pxugnslf+LRbc
	j5wlTc3qUJ6K5pZ7i6fhgX4L5anXvUBFuR7dTOKqKcM3yo0mc6evHT+NfwPlxHmx15w=
X-Gm-Gg: Acq92OGBxXJBxQyagta3jzPIoJOkHHnxsdy2kBjoJAl/1ToEqlXLB+iRYfMbv6H+k4Z
	aE/MW2UoKvClkQQJJb7WVih4vNmislPbcJHe/8uaWV60VdElNPqCz1/yLKnXPg43NHYNhqp93RH
	6h87npMDiVCLGm8NWp5xRPDYuxN7W1Sq3bKX1R9VPAjKVUweiBiNuQRy5lZNdzJKqkTL//5EsXj
	o9Hg5AsSH5t9IcznDPBSKOrt2KDeiYBwuPludyoymhsbALD5dktX4iWB49gN+DSmDeNokeEOSot
	bEnhScp4kJtLeDnmmX5Wi13ynFH+Y5KNmRe8ywey8tD8Ba/Ig3ZySWkVH1im7zgnKkmTFBRIp2c
	n7J5X/y2VCAUMtDdrE0AzqJ6UHhLdLEoyNIeokrMGDNSlmyxcj3jn+zuLQZs8PDEwh9tuurrxTL
	iq3jUr537DBJXk1fVYHHMvZ30A9L9neurHkua/MBVOZ8iYkQLoXlRvKKWh9C9b
X-Received: by 2002:a17:90b:1d4e:b0:368:2289:42cc with SMTP id 98e67ed59e1d1-368f4092542mr3912735a91.24.1778678514599;
        Wed, 13 May 2026 06:21:54 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.21.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:21:54 -0700 (PDT)
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
Subject: [PATCH v2 56/69] mm: Redefine HVO as Hugepage Vmemmap Optimization
Date: Wed, 13 May 2026 21:20:21 +0800
Message-ID: <20260513132044.41690-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 22E3A18000D
X-Rspamd-Server: rspam06
X-Stat-Signature: x1tyymgz3zc3r453o8hd5nikru345pw7
X-HE-Tag: 1778678515-664728
X-HE-Meta: U2FsdGVkX1/gWTDA2jgDkFgfvStqOfkjY1U8RUUeSIg4mEEAqR25YLP/1rhUnK+zl08cVSkoOvJL3LwW0u64/bjze1y0RZu8OQjBq2FJ5GSZ8ptmDzIxg44RqGXYenk/lc+Km6iggPllyfrqL5w9nTWfHENzmiaGc4yVeK5pc0LuqjjWp2acR5TzCxsneV10qfx5CKxY+8Ai8UPfD72YOLsmB5SbpivADeBIJpSj3I7cYTb4jBAhPtEXrcDl7r7pYgGBI3prqoKRmgtTmnveYtPbDhdjE/suvUJbnP2PUSoNfHeNvYKW6P2H6k5ao/5q2h5BWDtA7H2TEQ8E3FbeyBSeOZhhuY7MRKOdX0/sReTt/JpYTQHVVF8e6RQHZElDJKC1OT52S88WUJnAytG+F1PoIuV0RBHx2nTMlNcIOh0fANgbkyYnmzwITYU138qaK0oC4vwCxE/mBrGFAwyDnGYwfk7w9FuGFK4BFVEdoIA52E6Hj5AbWfXyJE/SfwM24x1bYro4PWAQbtrvhJ58/ikHoI5ghf0+R/9A07ofGNR7jXPtVtn2vAhKi0O51xL2HH53/6FJIAq87YamvQNiYpXkvqXo7FDmVkseplLwtYk0a1aprXMVBdq23hxwBme1pVr1R1DI/eaqW7xkTAr5zRqjywkLQpaaWcEseiW1Bv1lQWyykXAu8g/8nZ97lHXypZXyekflF9EJz8lpqcgFCCM2ZXDPTRMq3k7uwt44yx4mTwxpTm+Z7L1sGCofRLiOEzHMGsOalj6SGhuCrBNB7qz9FDQNK+rxg8fhLyjMIYWs6JkJcJY0e+2J+O9KA5iAhRSawj7MXga3PFz5i/srmgK81qvPUJaxDxo4zVNjtSKhw29Fp8uNfB5RnAvXmKvJtyYrkXJv6Kox4Xak0dn/P2Rhap5Xc8K9P/r90ghhDJLYDjD8n3V2H7l0LJp4OCLru8wxKPfq7CBuXU8UVvJ
 vCOFVZcG
 +3MMjlVR4C7kCXYKL3bZ1Tl4iusFFQrH5bY5SQ2DJFYHAaTn+Mvw4LcOots+P6pdR0cwT2jlmCSJoCfktcpEVtUq6JwJE2g3QKgceiL91fvOnlh6PLexF3NawXlozdAHeUDFK+xj72dgAJqz0atPrySONvBAksYNLuOf6X+D/kA1cBR83KW5ZrBRzYWS0LNqKmCksH4Bz3jXiHe6s4ofckmW/KzwhBWBMkZ+wQZXkIkpnyx5mfdD5A/58s3khelg3iAU9BOAoAS8CCuIyl0c8c+5fA4DvyE9ygJ0Vw/BukfmNy1AO3hc1WUgEcPq6tC1k8lbW4UebvAkEyWGNXyWF6hLabg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HVO no longer refers only to HugeTLB vmemmap optimization. The same
optimization is now used more broadly for large compound-page mappings,
so the old expansion is too narrow.

Redefine HVO as Hugepage Vmemmap Optimization and update the generic
documentation, Kconfig text, and comments accordingly.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 Documentation/admin-guide/kernel-parameters.txt | 2 +-
 Documentation/admin-guide/mm/hugetlbpage.rst    | 4 ++--
 Documentation/admin-guide/mm/memory-hotplug.rst | 2 +-
 Documentation/admin-guide/sysctl/vm.rst         | 3 ++-
 Documentation/mm/vmemmap_dedup.rst              | 2 +-
 fs/Kconfig                                      | 4 ++--
 include/linux/mmzone.h                          | 2 +-
 mm/Kconfig                                      | 2 +-
 mm/hugetlb_vmemmap.c                            | 2 +-
 mm/hugetlb_vmemmap.h                            | 2 +-
 mm/memory-failure.c                             | 6 +++---
 11 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0eb64aab3685..2d4cfdcb7535 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2114,7 +2114,7 @@ Kernel parameters
 	hugetlb_free_vmemmap=
 			[KNL] Requires CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 			enabled.
-			Control if HugeTLB Vmemmap Optimization (HVO) is enabled.
+			Control if Hugepage Vmemmap Optimization (HVO) for HugeTLB is enabled.
 			Allows heavy hugetlb users to free up some more
 			memory (7 * PAGE_SIZE for each 2MB hugetlb page).
 			Format: { on | off (default) }
diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
index 67a941903fd2..3f98ca1d7ce1 100644
--- a/Documentation/admin-guide/mm/hugetlbpage.rst
+++ b/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -172,8 +172,8 @@ default_hugepagesz
 	will all result in 256 2M huge pages being allocated.  Valid default
 	huge page size is architecture dependent.
 hugetlb_free_vmemmap
-	When CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP is set, this enables HugeTLB
-	Vmemmap Optimization (HVO).
+	When CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP is set, this enables Hugepage
+	Vmemmap Optimization (HVO) for HugeTLB.
 
 When multiple huge page sizes are supported, ``/proc/sys/vm/nr_hugepages``
 indicates the current number of pre-allocated huge pages of the default size.
diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
index 0207f8725142..d5e350607baa 100644
--- a/Documentation/admin-guide/mm/memory-hotplug.rst
+++ b/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -682,7 +682,7 @@ block might fail:
   ZONE_MOVABLE for increasing the reliability of gigantic page allocation
   against the potential loss of hot-unplug reliability.
 
-- Out of memory when dissolving huge pages, especially when HugeTLB Vmemmap
+- Out of memory when dissolving huge pages, especially when Hugepage Vmemmap
   Optimization (HVO) is enabled.
 
   Offlining code may be able to migrate huge page contents, but may not be able
diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c..9f333970fdb2 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -665,7 +665,8 @@ This knob is not available when the size of 'struct page' (a structure defined
 in include/linux/mm_types.h) is not power of two (an unusual system config could
 result in this).
 
-Enable (set to 1) or disable (set to 0) HugeTLB Vmemmap Optimization (HVO).
+Enable (set to 1) or disable (set to 0) Hugepage Vmemmap Optimization (HVO) for
+HugeTLB.
 
 Once enabled, the vmemmap pages of subsequent allocation of HugeTLB pages from
 buddy allocator will be optimized (7 pages per 2MB HugeTLB page and 4095 pages
diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 9fa8642ded48..44e80bd2e398 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -8,7 +8,7 @@ A vmemmap diet for HugeTLB and Device DAX
 HugeTLB
 =======
 
-This section is to explain how HugeTLB Vmemmap Optimization (HVO) works.
+This section is to explain how Hugepage Vmemmap Optimization (HVO) for HugeTLB works.
 
 The ``struct page`` structures are used to describe a physical page frame. By
 default, there is a one-to-one mapping from a page frame to its corresponding
diff --git a/fs/Kconfig b/fs/Kconfig
index f6cee1bbb1fc..496cfa2379e5 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -261,11 +261,11 @@ menuconfig HUGETLBFS
 
 if HUGETLBFS
 config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
-	bool "HugeTLB Vmemmap Optimization (HVO) defaults to on"
+	bool "Hugepage Vmemmap Optimization (HVO) for HugeTLB defaults to on"
 	default n
 	depends on HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 	help
-	  The HugeTLB Vmemmap Optimization (HVO) defaults to off. Say Y here to
+	  The Hugepage Vmemmap Optimization (HVO) for HugeTLB defaults to off. Say Y here to
 	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
 	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
 endif # HUGETLBFS
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7484e7be7b6d..efb37f2ffec4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -97,7 +97,7 @@
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
 
 /*
- * HugeTLB Vmemmap Optimization (HVO) requires struct pages of the head page to
+ * Hugepage Vmemmap Optimization (HVO) requires struct pages of the head page to
  * be naturally aligned with regard to the folio size.
  *
  * HVO which is only active if the size of struct page is a power of 2.
diff --git a/mm/Kconfig b/mm/Kconfig
index ddd10cb4d0a3..c85ed7d7f37d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -416,7 +416,7 @@ config SPARSEMEM_VMEMMAP_OPTIMIZATION
 
 #
 # Select this config option from the architecture Kconfig, if it is preferred
-# to enable the feature of HugeTLB/dev_dax vmemmap optimization.
+# to enable the feature of HVO.
 #
 config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 	bool
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index fce772e95adc..6f6f1740f540 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * HugeTLB Vmemmap Optimization (HVO)
+ * Hugepage Vmemmap Optimization (HVO) for HugeTLB
  *
  * Copyright (c) 2020, ByteDance. All rights reserved.
  *
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 2b0a85e09602..b4d0ba27b42c 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * HugeTLB Vmemmap Optimization (HVO)
+ * Hugepage Vmemmap Optimization (HVO) for HugeTLB
  *
  * Copyright (c) 2020, ByteDance. All rights reserved.
  *
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 866c4428ac7e..ad6416145667 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -175,9 +175,9 @@ static int __page_handle_poison(struct page *page)
 	/*
 	 * zone_pcp_disable() can't be used here. It will
 	 * hold pcp_batch_high_lock and dissolve_free_hugetlb_folio() might hold
-	 * cpu_hotplug_lock via static_key_slow_dec() when hugetlb vmemmap
-	 * optimization is enabled. This will break current lock dependency
-	 * chain and leads to deadlock.
+	 * cpu_hotplug_lock via static_key_slow_dec() when HVO for HugeTLB
+	 * is enabled. This will break current lock dependency chain and leads
+	 * to deadlock.
 	 * Disabling pcp before dissolving the page was a deterministic
 	 * approach because we made sure that those pages cannot end up in any
 	 * PCP list. Draining PCP lists expels those pages to the buddy system,
-- 
2.54.0



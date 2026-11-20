Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA834606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 17:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZSAv1okc
Received: by kanga.kvack.org (Postfix)
	id BCDED6B05B6; Fri, 20 Nov 2026 12:49:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58086B05B7; Fri, 20 Nov 2026 12:49:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A479D6B05B8; Fri, 20 Nov 2026 12:49:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75BD56B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 12:49:07 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA85780134
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:49:06 +0000 (UTC)
X-FDA: 85456233492.09.2403B27
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9587F80002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:49:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZSAv1okc;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf30.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795196944;
	b=1zBm/cj3Sw78jLlgclCJLRfsi9YPo2uBKB/4lYNb7BBljUeqaEPnQLBMNqnCfmF0bWSh8I
	CAxDBW8Rmv2aYZ2+IlnmvM172xhnotUnmZ1Ng9CyxSfwi8C9lT61CGz/JQYYbnV0PPtx7T
	rvY5ojQZPynbRwNl99jhgVJbLboiM8E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795196944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=demAIIHasGPlnHaxgm+fqtcdUykhBuanFKIB1V/U/sg=;
	b=5yA5ubJl/yVBEiLX6EHTwpjnlZvLsjXDTNd3s/4snp0BoiJYxPf2Ew9TrDww8KjXd1GgYS
	xwmUh4J9gj2MBO3R+cZwr8baSn9wreSEDfW0RgbQFX3ZokZbtttZ7TcNm9Cca3CZlOxgz6
	0oycWtfOkHVRVEzyZc4o1O4MvajU2BI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=ZSAv1okc;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf30.hostedemail.com: domain of "prvs=777ef8cfd=gyokhan@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=777ef8cfd=gyokhan@amazon.de"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1795196944; x=1826732944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=demAIIHasGPlnHaxgm+fqtcdUykhBuanFKIB1V/U/sg=;
  b=ZSAv1okchuRkfrzoxav2pT4/RewVG8Ug1PNe67Ak1/O2r5opQSvxIW7/
   Dx7C2gMiZO2xP2Y7Y3HS7LjHFkJXQBBPRdpnmOh0oWrZqZC1D9QdRpwUK
   hfW9OvzliKpeLlJxfAWVyPDkqFCCTXIXPoscsoDDwMCAe6XgqeWlwPg/Q
   T2Qr6+8kmPJxuMNES0Kg8nx3xWvg51CL2OFamC4swykhkJr8kxFM1Llwh
   AW7lS0zSNr0Fu6I5+PpZ4atvMhHbuPrs4e6FaUEw6kTl77XYeDsn8CXQG
   jrtAURT7jSQsE1mp/5DsWUg3E9J4ERHpbU7leu3BlKsNbCamJ6is5nwij
   g==;
X-CSE-ConnectionGUID: eAxuHap4Tkm7SBrmE2II/A==
X-CSE-MsgGUID: 8j1pk7PXR5qxJHDk8AADmA==
X-IronPort-AV: E=Sophos;i="6.27,223,1787011200"; 
   d="scan'208";a="34618378"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 17:49:00 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:31864]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.36.204:2525] with esmtp (Farcaster)
 id e678e01d-2578-4512-a989-ba10ff20f44c; Fri, 20 Nov 2026 17:49:00 +0000 (UTC)
X-Farcaster-Flow-ID: e678e01d-2578-4512-a989-ba10ff20f44c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57;
 Fri, 20 Nov 2026 17:49:00 +0000
Received: from dev-dsk-gyokhan-1a-87ab81cc.eu-west-1.amazon.com
 (10.253.85.128) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.57; Fri, 20 Nov 2026
 17:48:58 +0000
From: Gyokhan Kochmarla <gyokhan@amazon.de>
To: <stable@vger.kernel.org>
CC: Mike Rapoport <rppt@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>,
	<linux-mm@kvack.org>, Benjamin Tissoires <bentiss@kernel.org>, Jiri Kosina
	<jikos@kernel.org>, Luis Chamberalin <mcgrof@kernel.org>
Subject: [PATCH 7.3.y 2/2] mm/execmem: make sure ROX cache always contains multiples of PMD_SIZE
Date: Fri, 20 Nov 2026 17:47:45 +0000
Message-ID: <20261120174745.3785179-3-gyokhan@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261120174745.3785179-1-gyokhan@amazon.de>
References: <20261120174745.3785179-1-gyokhan@amazon.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User:
X-Rspamd-Queue-Id: 9587F80002
X-Stat-Signature: mm4nos6ijch9qxawd5okhf5gc5rsgc8d
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795196944-609192
X-HE-Meta: U2FsdGVkX19WzhgMrX9NeLCQ/3ChWpSAuZsojviXj38zzFrhfDOfnSutWHdrEqjkm/LsGt52S2k4JVlBqscRl4W+2efiOCYU/ecseFq6vcpixUFLK98F0N3pfh0DGdqtwiPtFWDcZy04YWNJ8aBzlp2f/LyR/DXuyTB6Ri9jejzNLA5TwC0DuCHnZCDki5jEy38xb+C6azaEv4MFUuW2J9tXTbN+J6/oHJkE4dfyhzEmKpL+xrxrZnU2cQAamtxpP1++LetCI1QWMTxpJTtkqi8q/aErxCkoxiuT5VyFfZJX1XLXbDodwsrnqAOWp59PA/XpKD2eOegLl3u3OTo1T1YdJaOxeOCxtzTkPwHv/uQsnwdHiQzA+d3G/u0/SxZ/jJ+gZCrjg6hKlZvacKi1aVAA5tZ5qt7wGEKX8e0VXUfQE3KGblWR3PmjTc4qUnlfVcK/HX3k3cFuW59OZPnW8glq92fcMebDEB6lMHSgh+uxQsVevSqWO+6YxUsVpdorNgTeiaerjrUe5SxDM1+FTCVF7FjCGnd11ZNy6+DW0TFSZYkj/0EAf3wN7yp9WBz9bJ58dgH1cFF6b2V9KkwGmCCaC8mpRHLf0iOBXUYT7fYZj/OA4OOVviwu3ag8xkjcvW99W9cucc3BqsS/slVM+mSgYSxyIImQH/NsfICS7zyQVG4sdZVIqAPCpW8mF5kLlrO0J6XZVWy+f/dSP/nm8HWc5CiYEXLs6zW7hMarUkegERbR9rrmKRVZsYoeSechcnOpQ+Qf4dKi1GUdgnoGzvT33CbAoYIz0Vx2hQn3j1lWcfKc/LXI7B3NNRzUhTcepOCOEv7fzeWMzAWYeYhDtILnQzGimPmF28USAq/gBixtmvpU1Ib4SGoRkJYBFmfgfMB7eYXyizn2rkXm1rvJki2CIPXbOvkKnmMPEQdz/R2VMYAKh3yvFUnsKpz2pOVZXELMiJeId9WDdVo4OrQ
 ZC4L83YB
 EPx10RwUCKUPW/VdjeKuCxQa5hUrn9ztEbSDFp//NfkGJ9LDkw87FfkfvGImgIwhAzT0jJEJpDIU9bNi8SdIzJT8ET3R6ohK3G79iUvjthb/R0wiGaL0Sm+oW9F2FDgp7E6M6TFQpm5FZwJUnERSgalgfdbK1JeUybJI4R1UpthjooFOI7DqzwwohqRUNyCKILi9VBNw6xjFKL1mUUTtz7KF6h5WmAlGHpnH8gvCZKkXbPegqd8HYu/OPoCvJwus21ZFe/XN2PZVa4um7bNqGh2xEXOeyV1UYv8zPgqeAI+7+pHlVM6OhWSPE+w+PbD1+o5b5fYbt74BtI990zn/pLrg0qzNtH1NHLElN/yXHyUSWXKQJQlwWpJ0kNCt2Em8y6idHtL617I0Skw0cOBIcLTgJ+c8/TT/zkuV0HgMja26H/4SnSnsk2358temX7pMyRqsJVUdkR6oF24J8LjMLkFQ6L7Jd3PqlawTdqibcOmRI4OKFFs1VDvhNQSrq+xT4HeB2GdeCeS7AzFG9PF04b8BERnIOpEDMMG7KhYnI5GxxYm9Ca8KkBEARgsK5cGIAVa+HowEVM0MVVT5GGLIW0wZ/4dC7XxipeYRxfz6vab7rKW0MZo30qzbs8A0fiMho8xxEqOryMokj1u+5xrvM404VDI6qvuiP+qNZwBj08Uw8hHnZeGB0nkhmf+tT5Xc53qqPb7IrEgPyVJm2eQUUUOT2WflpCbx2lLcXSv/tzQKbDVnWAerUS2IysgMGK6D5560wtvvAdCRhmwhw1FAB/ergql4l06hCSwqXqFio6msoEjqFMLln8i/UEg5DXCEhcZ/ljGf8VdrGDp49UdFfobiOPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

commit 569db54d8b7a4ec463a62c444de0d6f5f10e9dc1 upstream.

The ROX cache relies on its chunks being PMD mapped.  For a PMD mapped
chunk, set_memory_rox() updates the direct map alias one PMD at a time and
the large mappings there survive.

When execmem refills the cache, it rounds up the requested allocation size
to PMD_SIZE and tries to allocate that with vmalloc(VM_ALLOW_HUGE_VMAP).
If that allocation fails, execmem falls back to vmalloc() of the original
size.

There are two issues with this approach:
* If huge pages are not available, __vmalloc_node_range() silently falls
  back to base pages. The area execmem gets is virtually contiguous, but it
  is backed by 512 scattered base pages.

  Permission updates on such areas split large mappings in the direct map
  that contain those base pages, up to 512 PMD splits in the worst case.

* execmem's own fallback adds a small base page mapped area to the cache.
  This adds the overhead of cache management to these allocations with no
  benefit of reducing fragmentation either in the vmalloc/modules address
  space or in the direct map.

  Worse, these areas are never freed from the cache, because
  execmem_cache_clean() releases only chunks that are a multiple of
  PMD_SIZE and aligned to PMD_SIZE, exactly to minimize the number of base
  page mappings.

Add VM_REQUIRE_HUGE_VMAP option to vmalloc that fails if the allocation of
huge pages fails or if such an allocation is not possible because huge
page allocations in vmalloc were disabled or the architecture does not
support them.

Use this option when populating the ROX cache.  If
vmalloc(VM_REQUIRE_HUGE_VMAP) fails or vmalloc of huge pages is
unavailable, handle the memory allocation outside the ROX cache with plain
vmalloc().

Since the fallback allocation has to return ROX memory, add an
execmem_alloc_rox() helper and use it for both populating the ROX cache
and dealing with a fallback allocation in a ROX execmem_range.

With that, the cache only ever contains PMD aligned chunks sized as a
multiple of PMD_SIZE, and the PMD checks in execmem_cache_clean() become a
VM_WARN_ON_ONCE() to ensure that the PMD mapping invariant does not
change.

Link: https://lore.kernel.org/20260903-execmem-rox-cache-pmd-v1-v1-3-11beb2a3d249@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: copilot:claude-opus-5
Cc: Benjamin Tissoires <bentiss@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
[ 7.3: 4c4b2ed5b783 is not in 7.3.y, so cache chunks keep the
  execmem_set_direct_map_valid() handling: execmem_vmalloc_rox() does not
  call set_vm_flush_reset_perms(), and the populate error path restores
  the direct map before vfree(). The uncached fallback is freed with plain
  vfree(), so execmem_alloc_rox() passes VM_FLUSH_RESET_PERMS. ]
Signed-off-by: Gyokhan Kochmarla <gyokhan@amazon.de>
---
 include/linux/vmalloc.h |  1 +
 mm/execmem.c            | 77 +++++++++++++++++++++++++----------------
 mm/vmalloc.c            | 15 +++++++-
 3 files changed, 62 insertions(+), 31 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index aed121d729b0..6e555e31e622 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -38,6 +38,7 @@ struct iov_iter;		/* in uio.h */
 #define VM_DEFER_KMEMLEAK	0
 #endif
 #define VM_SPARSE		0x00001000	/* sparse vm_area. not all pages are present. */
+#define VM_REQUIRE_HUGE_VMAP	0x00002000	/* huge page mapping or nothing */
 
 /* bits [20..32] reserved for arch specific ioremap internals */
 
diff --git a/mm/execmem.c b/mm/execmem.c
index 3857955e701b..02c061375000 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -51,7 +51,8 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
 	}
 
 	if (!p) {
-		pr_warn_ratelimited("unable to allocate memory\n");
+		if (!(vm_flags & VM_REQUIRE_HUGE_VMAP))
+			pr_warn_ratelimited("unable to allocate memory\n");
 		return NULL;
 	}
 
@@ -168,10 +169,9 @@ static void execmem_cache_clean(struct work_struct *work)
 		struct vm_struct *vm = find_vm_area(area);
 		size_t size = mas_range_len(&mas);
 
-		if (vm && get_vm_area_size(vm) == size &&
-		    IS_ALIGNED(size, PMD_SIZE) &&
-		    IS_ALIGNED(mas.index, PMD_SIZE)) {
-			struct vm_struct *vm = find_vm_area(area);
+		if (vm && get_vm_area_size(vm) == size) {
+			VM_WARN_ON_ONCE(!IS_ALIGNED(mas.index, PMD_SIZE) ||
+					!IS_ALIGNED(size, PMD_SIZE));
 
 			/*
 			 * Preallocate to ensure mas_store does not fail
@@ -289,36 +289,41 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 	return execmem_cache_alloc_locked(range, size);
 }
 
-static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
+static void *execmem_vmalloc_rox(struct execmem_range *range, size_t size,
+				 unsigned long vm_flags)
 {
-	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
-	struct mutex *mutex = &execmem_cache.mutex;
-	struct vm_struct *vm;
-	size_t alloc_size;
-	int err = -ENOMEM;
-	void *p;
-
-	alloc_size = round_up(size, PMD_SIZE);
-	p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
-	if (!p) {
-		alloc_size = size;
-		p = execmem_vmalloc(range, alloc_size, PAGE_KERNEL, vm_flags);
-	}
+	void *p = execmem_vmalloc(range, size, PAGE_KERNEL, vm_flags);
+	int err;
 
 	if (!p)
 		return NULL;
 
-	vm = find_vm_area(p);
-	if (!vm)
-		goto err_free_mem;
-
 	/* fill memory with instructions that will trap */
-	execmem_fill_trapping_insns(p, alloc_size);
+	execmem_fill_trapping_insns(p, size);
 
-	err = set_memory_rox((unsigned long)p, vm->nr_pages);
+	err = set_memory_rox((unsigned long)p, size >> PAGE_SHIFT);
 	if (err)
 		goto err_free_mem;
 
+	return p;
+
+err_free_mem:
+	vfree(p);
+	return NULL;
+}
+
+static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t size)
+{
+	unsigned long vm_flags = VM_REQUIRE_HUGE_VMAP;
+	size_t alloc_size = round_up(size, PMD_SIZE);
+	struct mutex *mutex = &execmem_cache.mutex;
+	int err;
+	void *p;
+
+	p = execmem_vmalloc_rox(range, alloc_size, vm_flags);
+	if (!p)
+		return NULL;
+
 	/*
 	 * New memory blocks must be allocated and added to the cache
 	 * as an atomic operation, otherwise they may be consumed
@@ -337,12 +342,16 @@ static void *execmem_cache_populate_alloc(struct execmem_range *range, size_t si
 
 err_reset_direct_map:
 	mutex_unlock(mutex);
-	execmem_set_direct_map_valid(vm, true);
-err_free_mem:
+	execmem_set_direct_map_valid(find_vm_area(p), true);
 	vfree(p);
 	return NULL;
 }
 
+static void *execmem_alloc_rox(struct execmem_range *range, size_t size)
+{
+	return execmem_vmalloc_rox(range, size, VM_FLUSH_RESET_PERMS);
+}
+
 static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 {
 	void *p;
@@ -470,6 +479,11 @@ static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 	return NULL;
 }
 
+static void *execmem_alloc_rox(struct execmem_range *range, size_t size)
+{
+	return NULL;
+}
+
 static bool execmem_cache_free(void *ptr)
 {
 	return false;
@@ -479,17 +493,20 @@ static bool execmem_cache_free(void *ptr)
 void *execmem_alloc(enum execmem_type type, size_t size)
 {
 	struct execmem_range *range = &execmem_info->ranges[type];
-	bool use_cache = range->flags & EXECMEM_ROX_CACHE;
+	bool use_rox_cache = range->flags & EXECMEM_ROX_CACHE;
 	unsigned long vm_flags = VM_FLUSH_RESET_PERMS;
 	pgprot_t pgprot = range->pgprot;
 	void *p = NULL;
 
 	size = PAGE_ALIGN(size);
 
-	if (use_cache)
+	if (use_rox_cache) {
 		p = execmem_cache_alloc(range, size);
-	else
+		if (!p)
+			p = execmem_alloc_rox(range, size);
+	} else {
 		p = execmem_vmalloc(range, size, pgprot, vm_flags);
+	}
 
 	return kasan_reset_tag(p);
 }
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..3ab7eff25565 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4019,6 +4019,12 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
  * (when prot=%PAGE_KERNEL).
  *
+ * %VM_ALLOW_HUGE_VMAP allocates huge pages when possible and falls back to
+ * base pages if huge page allocation fails.
+ *
+ * %VM_REQUIRE_HUGE_VMAP implies %VM_ALLOW_HUGE_VMAP and fails instead of
+ * silently falling back to base pages.
+ *
  * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
@@ -4044,6 +4050,10 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		return NULL;
 	}
 
+	/* VM_REQUIRE_HUGE_VMAP implies VM_ALLOW_HUGE_VMAP */
+	if (vm_flags & VM_REQUIRE_HUGE_VMAP)
+		vm_flags |= VM_ALLOW_HUGE_VMAP;
+
 	if (vmap_allow_huge && (vm_flags & VM_ALLOW_HUGE_VMAP)) {
 		/*
 		 * Try huge pages. Only try for PAGE_KERNEL allocations,
@@ -4060,6 +4070,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		align = max(original_align, 1UL << shift);
 	}
 
+	if ((vm_flags & VM_REQUIRE_HUGE_VMAP) && shift == PAGE_SHIFT)
+		return NULL;
+
 again:
 	area = __get_vm_area_node(size, align, shift, VM_ALLOC |
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
@@ -4134,7 +4147,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	return area->addr;
 
 fail:
-	if (shift > PAGE_SHIFT) {
+	if (shift > PAGE_SHIFT && !(vm_flags & VM_REQUIRE_HUGE_VMAP)) {
 		shift = PAGE_SHIFT;
 		align = original_align;
 		goto again;
-- 
2.50.1



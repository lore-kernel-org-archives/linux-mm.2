Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F06591099B4A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665766B00E4; Fri, 20 Mar 2026 18:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D7A6B00E9; Fri, 20 Mar 2026 18:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57AFC6B00EA; Fri, 20 Mar 2026 18:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 479CB6B00E4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B933F5890B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:11 +0000 (UTC)
X-FDA: 84567845502.06.0A59169
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0F27A1C0003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HnHEJaPx;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nnenf86gq++6KovwQcTA6Kl5t4MO3U+Iu5fLhnYjUWc=;
	b=VL1NbcMF9GroU+BG+bIZ3aWUYXwBS9ePOeRTfz+dX/KfJeXiIIRXGm04KeBDlg/90+a2rH
	08uX7VG27+dJ8mfCh+TYRz3P9V+MvXSRF8dY9RQrigVieICPbRmSo3Zc6QqvoEu96L6kv0
	5Br5K30RG+V4EGkN10BKVuaLv6v9/co=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044850; a=rsa-sha256;
	cv=none;
	b=3RMpp854QNAmr0a1Sq+iJD2+V8LbrJsGG97nJuJTeRRVp+YJrBiPFtQ2PaYEoajiJll+fr
	v6KiAPTy06tINfnePuKwUP2zj48ACocTJlowE8drbxOA4+zPq25rT73JZqYVAIM0kQ2+c7
	MYrAbst8EBFvSNAMZt5cPvMLzradEW0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HnHEJaPx;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 904DF60126;
	Fri, 20 Mar 2026 22:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2FCC2BC87;
	Fri, 20 Mar 2026 22:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044849;
	bh=nPM2xDzamc7ofaCScsG410PR/QQBsQ3DvwZZV+9GS1k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HnHEJaPxDsHVIvGrxzHc285TLNol1z8REyKULttk7LBtwRgQ91PH1mTrO85MXJHyY
	 WFH/wxwqXRjfho6tYaOu2/MfwuotmjfCmsEnGZtWR9t6ddUZxpBVOs9QOWmQvmwy0a
	 aFiJ6oT7939CIJexqKYA2dnTf44yStx0+tux37YlR4l3yBmoRPT7k27uWmfAUQuEcD
	 8geni0LfN+9k7qbtbxB0ex+mCUMy825GfgzDnLOwZ/nRtaXSOeBKYzFzhArxXXxAIu
	 Gh3l9X4y5slBiaPioaYF/8CdnkJvSUALoiieyOcpGKKd5h1bKtCyau0asJSb7OVFP4
	 OpoN99xFHbZpg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:38 +0100
Subject: [PATCH v2 06/15] mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP
 leftovers for CONFIG_MEMORY_HOTPLUG
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-6-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0F27A1C0003
X-Stat-Signature: yaunt7hfow7w94mxegydc38aqiotcnuh
X-Rspam-User: 
X-HE-Tag: 1774044849-242119
X-HE-Meta: U2FsdGVkX1+yQplANx65gMyHHvi9pL3dAEDFGkNF18A6Ga/baf8dSyxD/pFAxWKkZKAc1UWXGSLHNMOv5NA1RdHejmHzcFMCQmO4TykDJ4ssTDhcuIktCmFcwCY5wuwthFRE6v2L1LE6lti2eJ4TNsSaH6GQW16jJXBdtb/TkHdTFt7h+0IZo57kDGp92Je1OETvt7vpORy5IzJMZp25Hr/N88TU5DkW+xDGLcrIh75hHqAMrzaVhH/S5QmncvEHeZ5LokGROOMS3KzFw2GrLXRxTb/e0jMiiYvIUQiP5JlCcltTo2Z1IGYFzoKEu79rQefSHFCHNHJ3y350VYYbXTWxSMZZnQr3zuJC5CrSisiY3/uG9GDdWMoy1bhXjIWbwi+AfbQjZvbXr5dzrs0yDXo2QOE94byJI55imXi1riE8GYOjFV4zUHuJ1tkrjxiDHMVMqJZhvCSWrkeOEYVqvrRbGvFxhYDyHdO9vaGPUmYp1wKJ2yptDiKk4DN1b88+Mr/x6J5JAEZkgidqhLl3FbeER/4a3r719s1ayzk+JjnWWa/q9G4zY0XQZAtP17R1oE14d2UTghGgkI/I1GN2CRgmoURtoGXtawxsA3kCuKDwChrCWSrJaiJoIZpwpntxibQX5gLIjONtWnagARn6Peom1JpDEn3M6myDl3NOYa/bWHpO14pzMSjpO6Yo8UPe4YU9HjhyVXg3OX2RfONzRTSa2My0hiDYdq0FNCBinXdx7FyAqKqzrSq2+eGrNwV8WhHa5AOQspVmwiH+9e0GfeJ0GMy7bIdWeM2/G2+zg4AryzWPXCuJJc/t4gIwkF8xAI/J1FVsdg3MTQiQXm0A8owl7gUNuim9tJ9fk4zSjQ5WH7Nck6a8DOcIU1J5xtAJPGfTZM21bVsEJfSPBSCR7Z+KLaMiz4NxsyCTCeQcanTz5GKBJzL7CZXua/VJcaBzV4IrflZpwWZnFH6dtLW
 LqeV4ybM
 e4jhXWqI3Mk3oljv2GZn+YqeFd071XaDoRsqy0ffPej4CPtTq0Ri6QU4guuaukKVIj4OuaqYl4rk6ad5PqKjU9i09VTUQNVmNX4C5WeDY0V6U0s9KR77uGRY0+Fa41+ruW0U2MJka1HK0/paZ5fZ5utIXWQCnkZcm7t+h79QJZ1nOmD34KfPZC0GKyuSQzKNJVqz9DtyZv9K1xtC50MbwjPZ3fQsHb6Tn9w2/AtKINd6JLl/CuNSAYphseX+g9HapPEeR0GsWkwCMYQgz9igPSWBBIsU9BBVjF9Md3NrZq83zUAAzrHTkqqipkNjuqHWKB53jFC5YV64dVI0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_MEMORY_HOTPLUG now depends on CONFIG_SPARSEMEM_VMEMMAP. So
let's remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers that are dead code.

Adjust the comment above fill_subsection_map() accordingly.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 69 ++-----------------------------------------------------------
 1 file changed, 2 insertions(+), 67 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 93252112860e..875f718a4c79 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -657,7 +657,6 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -729,73 +728,11 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 
 	return rc;
 }
-#else
-static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
-{
-	return kvmalloc_node(array_size(sizeof(struct page),
-					PAGES_PER_SECTION), GFP_KERNEL, nid);
-}
-
-static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
-{
-	kvfree(pfn_to_page(pfn));
-}
-
-static void free_map_bootmem(struct page *memmap)
-{
-	unsigned long maps_section_nr, removing_section_nr, i;
-	unsigned long type, nr_pages;
-	struct page *page = virt_to_page(memmap);
-
-	nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
-		>> PAGE_SHIFT;
-
-	for (i = 0; i < nr_pages; i++, page++) {
-		type = bootmem_type(page);
-
-		BUG_ON(type == NODE_INFO);
-
-		maps_section_nr = pfn_to_section_nr(page_to_pfn(page));
-		removing_section_nr = bootmem_info(page);
-
-		/*
-		 * When this function is called, the removing section is
-		 * logical offlined state. This means all pages are isolated
-		 * from page allocator. If removing section's memmap is placed
-		 * on the same section, it must not be freed.
-		 * If it is freed, page allocator may allocate it which will
-		 * be removed physically soon.
-		 */
-		if (maps_section_nr != removing_section_nr)
-			put_page_bootmem(page);
-	}
-}
-
-static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
-}
-
-static bool is_subsection_map_empty(struct mem_section *ms)
-{
-	return true;
-}
-
-static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
-}
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 /*
- * To deactivate a memory region, there are 3 cases to handle across
- * two configurations (SPARSEMEM_VMEMMAP={y,n}):
+ * To deactivate a memory region, there are 3 cases to handle:
  *
- * 1. deactivation of a partial hot-added section (only possible in
- *    the SPARSEMEM_VMEMMAP=y case).
+ * 1. deactivation of a partial hot-added section:
  *      a) section was present at memory init.
  *      b) section was hot-added post memory init.
  * 2. deactivation of a complete hot-added section.
@@ -803,8 +740,6 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  *
  * For 1, when subsection_map does not empty we will not be freeing the
  * usage map, but still need to free the vmemmap range.
- *
- * For 2 and 3, the SPARSEMEM_VMEMMAP={y,n} cases are unified
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap)

-- 
2.43.0



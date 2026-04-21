Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CF8FF5A8A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85DC96B008A; Mon, 20 Apr 2026 22:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8363F6B008C; Mon, 20 Apr 2026 22:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74BEB6B0092; Mon, 20 Apr 2026 22:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 632E96B008A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:21:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1098E140BCC
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:22 +0000 (UTC)
X-FDA: 84680961204.24.923D861
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 32127140006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:21:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EJLHhhra;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776738080; a=rsa-sha256;
	cv=none;
	b=cyqg2nm68wdtBkJiJ8+SrfYIeCi5bdj5bqcdxlcqbOz/sXQeVT4ql51iFTXPl71L3YChdh
	l2NKu10qNfad3Yt5Z2mnbA29crqx34Whw7foNbOcjMIsy+pxUOYjUp4gv88Akva9ZdHm7I
	XQV4IzYF+ZtwE9YKBfzfkVkWQC2mPYo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EJLHhhra;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776738080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ll+rBBsFEUHYy/yotCSUgO8Da9y5VqQ+MYajiuV9kqo=;
	b=TfSrT7c4TaF9pDNlWLk72tCMOHvH75DUYWdoGuA87P6YYjZ4oIEpoWAi0yMpt6j8DZ3Js0
	XnrDFLFTeXrarp4Ev2cnYQfYHl3ZwEySVfDO/GT8BXaDAnTDV8X8mgSIGqP0ewZfK0s3FP
	fQpFH620bx9wZdPuq9GDZkpmwMPGon0=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8296dabef74so3321045b3a.1
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776738079; x=1777342879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ll+rBBsFEUHYy/yotCSUgO8Da9y5VqQ+MYajiuV9kqo=;
        b=EJLHhhraA83BuLz/1jMRX/iva0UPVRrdrW6oave6EdNmVj4V5V0+C9ymkRP/w2OVAK
         cUK7y5q/psDR3mNJVJCdIhLqJWWrPJBHRQ7dzHmjnh3oe46kwWXmsQixx4gvv5aDuhmE
         isqTxInhPlXbpUXQywpCfE1rprjzTrqXI8OjJLq81Kp0pDVpACr80a6+v2Kojh5vKDLH
         oadc5OaR806SeZJ4hnFjo2L4qrf+p5Pwd+2v0fFCfKr8zqIpz7QflamDheQsRyVwhb73
         CEL+a0o2eMUpQFS36V7YVtq83yBin7Juk6ukJq/vdKxDwpoQCFztg2k+fSKYtTwfFZ3P
         mtvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776738079; x=1777342879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ll+rBBsFEUHYy/yotCSUgO8Da9y5VqQ+MYajiuV9kqo=;
        b=DWKlShwrT+aFgLzSHk3b4o7ScbJ83kw6SeUdU93JiWZ3mQ22NGQXwpIK80FT4cQssw
         Js79YGhA7lyubIZ2s4zWpkTFmr4bQppbHJqmi1/UGbOgS/RMMzhh+fytOUAKajzCEseB
         IibNmwAOzfcN0a9ke9MNm92UDKMclBwANgcu4gj2FZCN2Bz/Zd4bwX/ZlrOx3oqRit0M
         LQbvJYpfq2m0SmOHR0UxGOlbRr93YQ0UeCIBDjUR1mwUbdTzjJR8Zkt9Z8Z8rOKynWUq
         1EM9G/Gmh7uhk5g/yYy7aoFOjZuUzpT+9ZT7CKkGeUe2Q27oD+sQogJw97WhLDlMSNFH
         zC7Q==
X-Forwarded-Encrypted: i=1; AFNElJ8RHBlKAWkAFvUeG06K+d6hXZbk807nqZWgUFwQgRq3woW08Qbkn6GA5O48csbrKUrIM11EIb2lRg==@kvack.org
X-Gm-Message-State: AOJu0YyqPgt0ETiHYNfStqRDYl9WLwdxmrdH6TbJo5lSoq4PW0drmU/k
	iw1jiJ2stko5OZ5sEVfLAZl2CCJwc8fDHJJGExQjQ1oZcy7WVAphYRvFbgQI0uBKK6M=
X-Gm-Gg: AeBDiesN+rNuCLgMJDiogGmsYgnwJ0yGgbhD3yvJWj+H0ssI1l/ozfBbDn9qoJj+1jq
	MVR6pswAmL/6/9eSS4oXXLc0hZWAqnQkuQPcWFSESuDNRSd8L1ySdzaBNMJmnETYyNU1vVXM9Pq
	pn1loHltfFZQUN3WBnx2qyEvbbXGqmyCEqYHK5LuZSm7sKPxo4xZGJ8m1o4r95/XPOInY8mYdIU
	ICBG2a75KTjbZvo2Iws29nQGAKoUWpxsNx6E6le0QXhIInBMmo2cHiEkJ1pGFlPMKaxCPkfNLdS
	JTnndOkiO5Rl2hhmE3SAVzxjUU3wX+P4tgcCoPfNqR12PwYkw+xEXACqPZqYcMEvXZjd2Qv92oX
	nBnIruwdCJSQQb4KzSTW3esEpgqx/dA1PUsXIgawBFNWIATRRb63l+zllE2C44Rv92+ZRN8mubn
	aSxTXeDSneML3bTM6d45uDR7l548zo
X-Received: by 2002:a05:6a00:845:b0:82f:5125:a327 with SMTP id d2e1a72fcca58-82f8c902183mr17293231b3a.27.1776738078868;
        Mon, 20 Apr 2026 19:21:18 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::340])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f932dabd4sm11538780b3a.51.2026.04.20.19.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 19:21:18 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
Date: Tue, 21 Apr 2026 10:20:42 +0800
Message-Id: <20260421022044.1217503-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260421022044.1217503-1-songmuchun@bytedance.com>
References: <20260421022044.1217503-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 32127140006
X-Stat-Signature: bh79e1fhxbwnpgdijprc1a1ofa6155bw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776738079-466123
X-HE-Meta: U2FsdGVkX1/530SDyUm8dxZlN7f3RzKaZcExPoy0dEwxg5OKJmUyVyD+9Z4Ef1vjzkjORnzIz4BZOxahRNAzO+3x91XL6gA18y/mbEZ43Midq+HQcCMjBDLrLYCcTqtfwcTr/cV/v9meuxYy8WlplF5x/KzEgK7xm4dLpr05QXjUEP5M43W8u/Jx/O0TBb5laOXg0Ox7nV1rrgrZdYTlsY6gdky1zwHboS/ocrqUf4Tm3jkVZueL2UjsF73W4ntA9EQysRTyGDAveO3LNYMHQJe/F2zrRHsqcbXVtSiJPyRJeD/HUqewuOijwNHU2krCVZNmBqts83LhkTcM3UPcBc4hGED8Ylj8KEXr2qwz2RgXcxaJIC4q1C3zk81lIl6dFEvS7J0U3v+im1Ib+N/m8ejgAF2TzPB4+gPdIFEUyYwDq9VClyTS1653PY45zsrgB5huGs3FR3vdBM0gsXJB3ePdHZK+C4Eei2ZlB8oCIL5TE2lYN/BqZqXfILg3X0yzPrNnhi8zZfVClxgOJrr2RjSqnrLJSsYlwRTmtsUXj5VoDo6dDxnDN5+54YqBVt3RBfwyKQC6/7Xac5WEh/gzgdo0lakuvkOvy/HIOE6vGgEKktEPxcKS3w9qkmLRcwec9ohvmWiSWp49JnBSBiDDW152wlUdSMiOFnsgBjlrO//4OxtNpG1kowj4KrUTwW0cHVhjUiYJqnwqRVZKvjgQh98SpwMI2Viw+mLgp+Cjf0gUzWShQQ2U4oD6CZGz89/2R8dwCyOZyGBU9dGBp8mfFvnhnHvLQUcktOBx6NQZC7eX6TZZ2iajqWG5Ob4PEJ40UPFjQFv8Jo2CnoQ4VePeLZHgPWxeNvf6G1kCG2tRbkag552YKECtZVFQKR5DRoF+GF5RKMCUxf5MSW9P7385kskz7JY9dtzMi+eWss9BeHFrYUvhLTo5fWer26movlLKujovjKGJE+YfqHoOYwq
 LyDxWCFJ
 XGMbWRNs2YBcByn4HwC6BJb7/kwmg1WfMgQj2dTrONkgtYhzRdsHTT7ZbcjimrLAfCm6UAdlEkvisnjI9fD74m3N/wlsHLHsCMFpjHIqcuqodjzlaZpRk0S0rpEm+roy5/qw8/JTdbzpd/jrtVqJdxiVz7SEFYrG3OIKf+5Gs4jNVAEPeBDw/Pu/tPc2siKPOeeZvmByFPkcnzUixVDad8I3eL3im+C3CfhWldNgGzfxLGxfrIh8Lm6le6kdeIQhoR07FvxOP8tOc10s6uomR2IMwRuzzC4BdiDTAO3BX6GiTe6qbFXfkwwbrTU+UOWHo0KN02ND8Dv51T1dp6kwra3tlhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the memory hot-remove call chain -- arch_remove_memory(),
__remove_pages(), sparse_remove_section() and section_deactivate() --
does not carry the struct dev_pagemap pointer. This prevents the lower
levels from knowing whether the section was originally populated with
vmemmap optimizations (e.g., DAX with vmemmap optimization enabled).

Without this information, we cannot call vmemmap_can_optimize() to
determine if the vmemmap pages were optimized. As a result, the vmemmap
page accounting during teardown will mistakenly assume a non-optimized
allocation, leading to incorrect memmap statistics.

To lay the groundwork for fixing the vmemmap page accounting, we need
to pass the @pgmap pointer down to the deactivation location. Plumb the
@pgmap argument through the APIs of arch_remove_memory(), __remove_pages()
and sparse_remove_section(), mirroring the corresponding *_activate()
paths.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/mm/mmu.c            |  5 +++--
 arch/loongarch/mm/init.c       |  5 +++--
 arch/powerpc/mm/mem.c          |  5 +++--
 arch/riscv/mm/init.c           |  5 +++--
 arch/s390/mm/init.c            |  5 +++--
 arch/x86/mm/init_64.c          |  5 +++--
 include/linux/memory_hotplug.h |  8 +++++---
 mm/memory_hotplug.c            | 12 ++++++------
 mm/memremap.c                  |  4 ++--
 mm/sparse-vmemmap.c            | 17 +++++++++--------
 10 files changed, 40 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dd85e093ffdb..e5a42b7a0160 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2024,12 +2024,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	__remove_pgd_mapping(swapper_pg_dir, __phys_to_virt(start), size);
 }
 
diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index 00f3822b6e47..c9c57f08fa2c 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -86,7 +86,8 @@ int arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *params)
 	return ret;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
@@ -95,7 +96,7 @@ void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
 	/* With altmap the first mapped page is offset from @start */
 	if (altmap)
 		page += vmem_altmap_offset(altmap);
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 }
 #endif
 
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 648d0c5602ec..4c1afab91996 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -158,12 +158,13 @@ int __ref arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	arch_remove_linear_mapping(start, size);
 }
 #endif
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index decd7df40fa4..b0092fb842a3 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1717,9 +1717,10 @@ int __ref arch_add_memory(int nid, u64 start, u64 size, struct mhp_params *param
 	return ret;
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
-	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap);
+	__remove_pages(start >> PAGE_SHIFT, size >> PAGE_SHIFT, altmap, pgmap);
 	remove_linear_mapping(start, size);
 	flush_tlb_all();
 }
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 1f72efc2a579..11a689423440 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -276,12 +276,13 @@ int arch_add_memory(int nid, u64 start, u64 size,
 	return rc;
 }
 
-void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	vmem_remove_mapping(start, size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df2261fa4f98..77b889b71cf3 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1288,12 +1288,13 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
 	remove_pagetable(start, end, true, NULL);
 }
 
-void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap)
+void __ref arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			      struct dev_pagemap *pgmap)
 {
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
-	__remove_pages(start_pfn, nr_pages, altmap);
+	__remove_pages(start_pfn, nr_pages, altmap, pgmap);
 	kernel_physical_mapping_remove(start, start + size);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 815e908c4135..7c9d66729c60 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -135,9 +135,10 @@ static inline bool movable_node_is_enabled(void)
 	return movable_node_enabled;
 }
 
-extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap);
+extern void arch_remove_memory(u64 start, u64 size, struct vmem_altmap *altmap,
+			       struct dev_pagemap *pgmap);
 extern void __remove_pages(unsigned long start_pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap);
+			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
 
 /* reasonably generic interface to expand the physical pages */
 extern int __add_pages(int nid, unsigned long start_pfn, unsigned long nr_pages,
@@ -307,7 +308,8 @@ extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-				  struct vmem_altmap *altmap);
+				  struct vmem_altmap *altmap,
+				  struct dev_pagemap *pgmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
 		int nid, struct memory_group *group, unsigned long start_pfn,
 		unsigned long nr_pages);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a943ec57c85..6a9e2dc751d2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -583,7 +583,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
  * calling offline_pages().
  */
 void __remove_pages(unsigned long pfn, unsigned long nr_pages,
-		    struct vmem_altmap *altmap)
+		    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const unsigned long end_pfn = pfn + nr_pages;
 	unsigned long cur_nr_pages;
@@ -598,7 +598,7 @@ void __remove_pages(unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		sparse_remove_section(pfn, cur_nr_pages, altmap);
+		sparse_remove_section(pfn, cur_nr_pages, altmap, pgmap);
 	}
 }
 
@@ -1425,7 +1425,7 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 
 		remove_memory_block_devices(cur_start, memblock_size);
 
-		arch_remove_memory(cur_start, memblock_size, altmap);
+		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
 
 		/* Verify that all vmemmap pages have actually been freed. */
 		WARN(altmap->alloc, "Altmap not fully unmapped");
@@ -1468,7 +1468,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, NULL, NULL);
 			kfree(params.altmap);
 			goto out;
 		}
@@ -1554,7 +1554,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(start, size, nid, NULL, group);
 		if (ret) {
-			arch_remove_memory(start, size, params.altmap);
+			arch_remove_memory(start, size, params.altmap, NULL);
 			goto error;
 		}
 	}
@@ -2266,7 +2266,7 @@ static int try_remove_memory(u64 start, u64 size)
 		 * No altmaps present, do the removal directly
 		 */
 		remove_memory_block_devices(start, size);
-		arch_remove_memory(start, size, NULL);
+		arch_remove_memory(start, size, NULL, NULL);
 	} else {
 		/* all memblocks in the range have altmaps */
 		remove_memory_blocks_and_altmaps(start, size);
diff --git a/mm/memremap.c b/mm/memremap.c
index 053842d45cb1..81766d822400 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -97,10 +97,10 @@ static void pageunmap_range(struct dev_pagemap *pgmap, int range_id)
 				   PHYS_PFN(range_len(range)));
 	if (pgmap->type == MEMORY_DEVICE_PRIVATE) {
 		__remove_pages(PHYS_PFN(range->start),
-			       PHYS_PFN(range_len(range)), NULL);
+			       PHYS_PFN(range_len(range)), NULL, pgmap);
 	} else {
 		arch_remove_memory(range->start, range_len(range),
-				pgmap_altmap(pgmap));
+				pgmap_altmap(pgmap), pgmap);
 		kasan_remove_zero_shadow(__va(range->start), range_len(range));
 	}
 	mem_hotplug_done();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index a7b11248b989..40290fbc1db4 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -665,7 +665,7 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
@@ -674,7 +674,8 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	vmemmap_free(start, end, altmap);
 }
 
-static void free_map_bootmem(struct page *memmap)
+static void free_map_bootmem(struct page *memmap, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
@@ -746,7 +747,7 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
  * usage map, but still need to free the vmemmap range.
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
+		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 	bool section_is_early = early_section(ms);
@@ -784,9 +785,9 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early)
-		depopulate_section_memmap(pfn, nr_pages, altmap);
+		depopulate_section_memmap(pfn, nr_pages, altmap, pgmap);
 	else if (memmap)
-		free_map_bootmem(memmap);
+		free_map_bootmem(memmap, altmap, pgmap);
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -828,7 +829,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap);
+		section_deactivate(pfn, nr_pages, altmap, pgmap);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -889,13 +890,13 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 }
 
 void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap)
+			   struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	struct mem_section *ms = __pfn_to_section(pfn);
 
 	if (WARN_ON_ONCE(!valid_section(ms)))
 		return;
 
-	section_deactivate(pfn, nr_pages, altmap);
+	section_deactivate(pfn, nr_pages, altmap, pgmap);
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
-- 
2.20.1



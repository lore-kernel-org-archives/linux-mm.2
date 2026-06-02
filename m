Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48BBFCD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F24C6B00BF; Tue,  2 Jun 2026 06:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0E76B00C0; Tue,  2 Jun 2026 06:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86BAB6B00C1; Tue,  2 Jun 2026 06:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 726766B00BF
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:11:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A7FC92413
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:14 +0000 (UTC)
X-FDA: 84834554868.19.4A8F699
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id D8CD4A0015
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:11:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=c3lGUOos;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ifAYajDzE3bfTkaM223T1RUSqkPH2sIJK1XHV+rXLE=;
	b=Or3yVSiKq9IQiosLEnLT2VLBIbucGZGbGO52S6JsIIWFmj9CjLodCt9VH+CIEweTdZCIPX
	O/Kb4wBXbdgYog2E1nDQLxeIaZDzPz6z55lSTPXNK8NI59WfZNjn5D02NWOaHqGW7GfsQt
	ehodtKGuhIuENYij0MqJCyui8UQ/jGE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=c3lGUOos;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395072;
	b=6hur2ekO/TcskHDVydn87H70koXjrCI45pILt11FhFzTUnICq7e/n0nvGLtWw5jOg9qAYE
	Ayt/7oNiMC90lzwgXK2SqsUUTFjSYEYq8H4yq+hDSjZ1gVVQ/lSL2LdrG7w3PoS5bsZ27Q
	iMs14znSW35VMrcXXmyDHWzN+0vH5Qc=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c8584bbbf2cso2028997a12.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395071; x=1780999871; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ifAYajDzE3bfTkaM223T1RUSqkPH2sIJK1XHV+rXLE=;
        b=c3lGUOoshNnT5tIkiMO+TPaD8OWrQpsRWGpJShV18U4iMpuJlZs9IrtSPrYr85PcXZ
         p6rU8d6p76TrIL0pbokLIOhBxVdhUnJ3AagijrVsdHv7MtQDG3bB4i0S0eXXTg69YOxC
         DUf5beOeavy4txqQL/uAn9cEFhQIiQNXE/RLMH04E4nL21PcJvzruzrmljMxK4UivpND
         3XjYI3xSKzjnkm6fnB8IkbBxWQP7uJGaZFyI8nWixw/HWd998MxyZt6uN5g2q1B2MrKQ
         kZ+RHF+A2/G2SGRO8avo25PpmH3bqCNJNZksmPeQKmrold/GVnB6RnGoBh8XLd6oK/bm
         B7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395071; x=1780999871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6ifAYajDzE3bfTkaM223T1RUSqkPH2sIJK1XHV+rXLE=;
        b=kcjR+lO3HRge6g3HcHn8v9V+hX7ELPMh+mVs4yFMH4w3uTUWz8WNmUSTVUI2oQfYPH
         5UN1gBuVRN2i61dy8IfZyalBZL+HpO2nc2S0eMBJrpNFih0Yr4XPA1prmG0gTtvWYzhM
         5CqR901rv1rPsixy9NGdbj2y5ZmcKRWDY3QOGwTcgWOEm4+ukQ4gI8TjkNvpBDAcc8c2
         iiDJgpT7o4mMJGaf+HCfEb6wUQ7TX8cOh0ScGTLLp5SxhB4INUFXjcL4N0BOhpbYu3e9
         iRfUitl4mw4Hrk8EiYaQEUXluhpiWru9P0NB+UVkmy8QOaa7nBwk/xYqYBeHU77nt0Mk
         kFIg==
X-Forwarded-Encrypted: i=1; AFNElJ/fGTzACUxfNCNy20iIPcy+3DxstmaGoxhfT8HNyzOw84V3FeL9KfNuY0maNwfp0Ff0lr10dXfgWA==@kvack.org
X-Gm-Message-State: AOJu0YxifFHx8ICYq8EA/qA+5Kie9sJkUQ/NTb9LUCIHXAbyx/V4UBDN
	R0JiathCTNt4m23GgkS5t8IpXXOVXWjMDTXTexok6/s0W+VEivVVQs51lWOf1tgWOY0=
X-Gm-Gg: Acq92OH4htbb4yn7ovge3mx2qVr6L6J9fvHAq2CoLhf0oFuht9tOwhhHB3pf/VTfmjO
	J/ds/6M1yVmqBH923j08WYkCOML+Eps++v45R8k+8YIOa2RQHqvfk07vXAI8S4KcJDIL0jB7LhA
	hIZ0CMMz9QalivWTDbdYgwtdP++YEH4xNxoXjfh+4+KNKDP8mKxuFROpBZk46C1lYIZAgvTALdO
	sjVYgYlhFg2hF01USPjmDCNK5OuI00yCt4oZcnlzcq8+r6aUYtn6T3H3J3U7fGe5ukT79AA4YtP
	19KR+rmxuDlk1ULVGSlvF+dI60EnBoF1q3PwiNKUdrpLr0gbgcnOUJbJlqNG9PNdtQyZVIcgIUt
	2RErCpAWpUMDolNqBWBmwXtmQx4/c5b76t+8XeOJERj6bgOM+xsMBUekYNNA6GU8WfwjAuo9m8m
	5NqygVSR2Sf23wSFjIFRbi3KGQYcAQqgugpl2a52iM143CwUVWMJeGVxM=
X-Received: by 2002:a05:6a00:3c91:b0:842:1052:5fe7 with SMTP id d2e1a72fcca58-8422532c951mr13639719b3a.6.1780395070652;
        Tue, 02 Jun 2026 03:11:10 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:11:10 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 04/19] mm/hugetlb: Initialize gigantic bootmem hugepage struct pages earlier
Date: Tue,  2 Jun 2026 18:10:24 +0800
Message-ID: <20260602101039.1867613-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: j6u737yihparzur3ju7byxxs47opr1ir
X-Rspamd-Queue-Id: D8CD4A0015
X-HE-Tag: 1780395071-671014
X-HE-Meta: U2FsdGVkX19a0KZrkL+sLO5tK6bZFTpDJNhsoasAeTosVn2nW7AABblelr7jrLY2msKRVvULg3nY/3mey2Wu5SuusB1GbWvkXgwDJeO4qD6WXDekRdlF+/qY+yp3/jeyxm/vhrzaiDlrjJyv6c7MVckx6Cu+1Ooe1f5tcJdKi7EZJmYGdcN18f6oODiFAu9WiDqs3cdNZ4C+rtlGm5r/IIsdGszrPXW9z51nelz8bodr89hLsC2zbqssH9cqkZRovZV7+S7cT5ZRTflcLEO82uwPCF51tAUaD7S9fsNZPSa33wErLdYmuPjpoQPBONfQmVJQvvp9pnYROjYZAREiCXlgupxZI2Rsc2o+qamgwVgoDO+6nQi7+ZwwIWDStgRcNsQlqAiQDE350wKv8ASFOybojg5/LTYEFKkINa/ggdQgXHnC49ntsrz67xt+2EYffQK44jQCR312xVPHteSQ1WtzAre/ZE/KEsPXdk4B5C+1bvB8rlcmd1f7/ZsQQBKigokYxwofSQfLUeV1uOufmwB+m4peeHqJBHV76bu3LfffMw4hQcigsBEIBMbrOEUHJd0gN/KJ197TYPJDVwf6GKfYpYF7ptB3MN/VH5od32ysDnpuOxum1WG3W14wRQsSzDnS0YnvfxCptND3qikcQ4HZZkszULKA1EXzoy+wUn2bnq3BUOJiyZEMBXrrHnqkt4GGWJ+7GJvgdrpLs8PMXKrYH7E5YSmiJR/v1ZRIFSYzikllkZL6lMiTKWc5KKaUOuVY1VQCeZRl51RywQ3gKEBAhr6wvgfRZimnL1PfUnKWCbefwi7Wk5z1v8MpH3GgtLVpDQS4H9hzeyWLGgJ+Rg2Pt1Zc/mBJWKBH3YPq59y6/eutEVYeVQzTyk36gLuVoSAi9abkeU3HqeqmDrlpA9XWdWRfbi4kutZvz+n1NLplQJ5+suxbCTLBJnUB4FULr5x3izhJz3g7s5LyryC
 wsUTFVux
 RlW5cvhPw9RM1ibuaU7wxmyATVA7ZTs9NVAC0Gtb7ApESJvW7Jy6ucrxZyx2i2gD3AZ1j8sg8B1HGT9viW/7lgD/LwP9yTtZZUVHNiIgR+WI9pph5dzB8v5MEcwMST+mevr21z5wPUyv0OSfWtLXXlbOYhcF9UGGOHSRkrnH7t6Muy0Qk4lejIj8vC9KacXbvBePkPh7BhhjL2RbL9N1N7FMWS0L0yoJq2fvsvFDiOiCm3XulRA5fUoLqkb23qIsPaQ9q8BpohX0r4SPtKwja05KKmYQBpizlA+U1fdw/4z8mEJcwsVPxdJ1dGo09E+M0rLX60VjD276JgbhhAQmzqVql5Did7x1hvZOU6meQu/saQznM9qISOd8Suw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gigantic bootmem HugeTLB pages are currently initialized from hugetlb_init(),
but page_alloc_init_late() runs earlier and walks pageblocks to determine
zone contiguity.

If a bootmem HugeTLB region is marked noinit, set_zone_contiguous() can
observe still-uninitialized struct pages through __pageblock_pfn_to_page().
This may not trigger an immediate failure, but it can make
set_zone_contiguous() compute the wrong zone contiguity state. If extra
poisoned-page checks are added in this path, such as PF_POISONED_CHECK()
in page_zone_id(), it can also trigger an early boot panic.

Initialize gigantic bootmem HugeTLB struct pages from page_alloc_init_late(),
before zone contiguity is evaluated, so later page allocator setup only
sees valid struct page state. This also makes the initialization order
more natural, as struct pages should be initialized before later code
inspects them.

Fixes: fde1c4ecf916 ("mm: hugetlb: skip initialization of gigantic tail struct pages if freed by HVO")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
v2->v3:
- rename the helper to hugetlb_bootmem_struct_page_init() to make the
  bootmem-only scope explicit (per Oscar Salvador)
---
 include/linux/hugetlb.h | 5 +++++
 mm/hugetlb.c            | 5 ++---
 mm/mm_init.c            | 1 +
 mm/sparse-vmemmap.c     | 4 ++--
 4 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 2abaf99321e9..3700c0a1f6ff 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -171,6 +171,7 @@ extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
+void hugetlb_bootmem_struct_page_init(void);
 void hugetlb_bootmem_alloc(void);
 extern nodemask_t hugetlb_bootmem_nodes;
 void hugetlb_bootmem_set_nodes(void);
@@ -1293,6 +1294,10 @@ static inline bool hugetlbfs_pagecache_present(
 static inline void hugetlb_bootmem_alloc(void)
 {
 }
+
+static inline void hugetlb_bootmem_struct_page_init(void)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cd55524c7e30..2bf9fe16abb9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3353,7 +3353,7 @@ static void __init gather_bootmem_prealloc_parallel(unsigned long start,
 		gather_bootmem_prealloc_node(nid);
 }
 
-static void __init gather_bootmem_prealloc(void)
+void __init hugetlb_bootmem_struct_page_init(void)
 {
 	struct padata_mt_job job = {
 		.thread_fn	= gather_bootmem_prealloc_parallel,
@@ -3582,7 +3582,7 @@ static unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)
  * - For gigantic pages, this is called early in the boot process and
  *   pages are allocated from memblock allocated or something similar.
  *   Gigantic pages are actually added to pools later with the routine
- *   gather_bootmem_prealloc.
+ *   hugetlb_bootmem_struct_page_init.
  * - For non-gigantic pages, this is called later in the boot process after
  *   all of mm is up and functional.  Pages are allocated from buddy and
  *   then added to hugetlb pools.
@@ -4152,7 +4152,6 @@ static int __init hugetlb_init(void)
 	}
 
 	hugetlb_init_hstates();
-	gather_bootmem_prealloc();
 	report_hugepages();
 
 	hugetlb_sysfs_init();
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6de3a77eb9ae..1890bda948b8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2338,6 +2338,7 @@ void __init page_alloc_init_late(void)
 	/* Reinit limits that are based on free pages after the kernel is up */
 	files_maxfiles_init();
 #endif
+	hugetlb_bootmem_struct_page_init();
 
 	/* Accounting of total+free memory is stable at this point. */
 	mem_init_print_info();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 8f41b73fb674..db9cfe57e827 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -342,8 +342,8 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
 	 *
 	 * Any initialization done here will be overwritten by memmap_init().
 	 *
-	 * gather_bootmem_prealloc() will take care of initialization after
-	 * memmap_init().
+	 * hugetlb_bootmem_struct_page_init() will take care of initialization
+	 * after memmap_init().
 	 */
 
 	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
-- 
2.54.0



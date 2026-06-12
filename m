Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30EFACD8C9D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971666B0095; Thu, 11 Jun 2026 23:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949286B0096; Thu, 11 Jun 2026 23:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F2D6B0098; Thu, 11 Jun 2026 23:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71C706B0095
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:59:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D5FD1A040F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:35 +0000 (UTC)
X-FDA: 84869906310.04.DF8244F
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id DDE93A0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cdcCfPk2;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bw/+TUFGRb1cb6WBPutvKTpZXTM41uBrQaMLYOSWWQg=;
	b=4tVRMM5mrysTVCiFM1KpcY92+K9mzKqVn8rWQyKnM2eX0Ae5yJPWIYGk+mq1v75WZPG0gn
	NKa5X4HyD45WgesMEjWwrq+vac/et88Du3SrmziR1sSgHddGpco+kJwPpBr72Vm0r1FdoU
	XeVmnlnJDz4cc4qu5i+lIWufoPFdC2k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=cdcCfPk2;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236773;
	b=y9GCtglxOOSuaiRSnFLY4whtMOQST3n3tGsIrTH+SDMCVUJoivKBlzf8cktac8YKyrVmNy
	vvuT/avu6Jn3EtumS6DbTXh2i0AlD1EKqmBUGfBdHZmM4Tsxu74HYlh3UUJ/4Vdk1hUjH2
	Or3keWo+rcFhyJ/Wv9FPWSdIGXBVdtg=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-842cd900ee0so267579b3a.2
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236772; x=1781841572; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bw/+TUFGRb1cb6WBPutvKTpZXTM41uBrQaMLYOSWWQg=;
        b=cdcCfPk218myxUxiRDzxfQLqTiE1+kralHqgeKkl2o/1nQOryKh1zIxK6hJdb0max7
         dRc78242GrXDFb51V1fLpcLY0jZ5TrtTtWAD5K3Mc7kT4R1cTmP4U2qi5g1MHAJYyKBM
         Ve9df7k+zuZWwMjQXaLAb+NsT1i4wAJoGpBmrXLjF00X3sSbH6VffQFojsJZlwp4Ks4/
         uVTjUabdLariGBegzrPAl2Eqg/GugdITTyy5CjtKKZx2zmeCu80nnWG0BwYwpHLnOzmx
         h0zLO93VklCJzzNDssgZMfmWgtstY1Q9DxTdcGIeN7UYUsKjPNMQh/LmphedmvrOd8aI
         4vXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236772; x=1781841572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bw/+TUFGRb1cb6WBPutvKTpZXTM41uBrQaMLYOSWWQg=;
        b=KahQjagEomijYd656Z41uc9+787IM5t2zHs2nwW0DN4ck3iBFoaRD/HHpOTlg+Tb46
         CZg1MLBfN/cf2DAozJlGYrvY0cqcKuexbL79oLQv1/b9isVjy/x4NQ6G70kwZnmtbIQO
         B/7Ucfo/P5SJ004NQStKnhk0y9Wc6++hqUlSL47WfL5+8+3RSgR1SPhu6Z9Y5aajOP32
         0vUpLhluQte1Ur7aw8Djqa2Ou8WstAQ1wBgNPWrpsnqMyDVnaPKbhXPw5G5HHQJOFLpA
         OsB2hNLWK/jf1ylrYtzTN/tJn65BYuxb7yzIHq0Ep5o1cz7xmPe0SbCm0GL1NoyZQ5Un
         PqpQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Z8K726sn3wZQ5tJaoTLZvZWxqhIt/wFHJnomUL8+D69gPo9inoYw0ZsBNWGfx8O/XfeoPiaEhQw==@kvack.org
X-Gm-Message-State: AOJu0YzXtSEZzCT5YOA9J7RoT9k0BckUiw8euOyYdQBql4KIc+aPEV/0
	dDJw6zDtL6rci9KKVfDnRFNJpDGtrbQN/NFwIZdZdvtLuigY/uN5MDIT9/7SUF8a828=
X-Gm-Gg: Acq92OEaVlDuYvCtJKeLVb5trDN1supLOvHSQuBgfVkCkZUPBc1lad4yVUHzjsNe4O8
	2KlMqm9eI/erioXjHk1vAlyCQCtdWRdIb2+gEIOZMSTLzoqxOpfFyhydOk5yRe6LOG2G6PYg2kR
	gaC4crZyZcAreDfdgy12U/mpkxPEokGgppmJJVo3ylk3mukBDPu93BR/qjQ7WcgeHJGvOi41Bxf
	dyYdEcXhFvq+n+yfWgttZNmdnFv6lSXrLV6tnuZ3ANzgrPCodc2qw5pj7FL6dmztuXXkBtqwPu7
	lsGLcrTyQec2VbNwqttR7qVBdLEl4X7Bw9VA9MG2yZrYg0li+TrOBPBMDwbs6872jnxfjjlxfgk
	KPP5OQvz/fwIN0nmGPFap38Py5ldfmZSbUVeAEo34Ni9CTo52zrGesGkoKupIcAzFaSkY7scDtl
	YI5GG9c5vO/H/+2s2ZuobY7enbZFIjvfILsOO1fknh7kw=
X-Received: by 2002:a05:6a00:3395:b0:842:5b1e:5908 with SMTP id d2e1a72fcca58-8434d0795a6mr1106623b3a.25.1781236771699;
        Thu, 11 Jun 2026 20:59:31 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.20.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 20:59:31 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 04/19] mm/hugetlb: Initialize gigantic bootmem hugepage struct pages earlier
Date: Fri, 12 Jun 2026 11:58:48 +0800
Message-ID: <20260612035903.2468601-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: karuc8y83tw8pt3jctdbk55rp4iitcnz
X-Rspamd-Queue-Id: DDE93A0005
X-HE-Tag: 1781236772-839336
X-HE-Meta: U2FsdGVkX1+5U2C6Ixb8GZZrEaHWlwicxiom/OWNAN6CROZShrpzbZM3zdppOyBqz76km6Uya60hxSeivRoIBg7QEfFgGr/gVnx9v+A540xgY7sZPuqvNTGMkKqDp1Sy738TnOul/1WfOhYw5kyyqKr7+94vOHqxRBNgE/xUw1rjWC8LYwZ7UtIZb/b3CCVrQbIvi9uKoSTqk2bwWRRC8C/J10l2vlK/Rkj//OWkOjAYtgHv7im2en01uzpDDI+2gXkdVn1TjnahtBPtPpiu9hgf3FVhoK/26upDLOG9I1O6W+TrE+cJIuOG29bUHVGx1ljxGW9ISsX19MvO7VkbIv8QLRn/3MzhqB+W7D9l+KQB7lJTRmW4mbN6sEZJXzgxbXI01F4K0iyHkC62kua189ldhVAqqerO5Z7SiTM1c5tLCk+C7iRgqEITwMUA/gmJMIR4mbTXgqofz1+QgGLKcWtNzQbcbd6DADg0lRHAquHl8yhHa/XC16LcjH0r6iofEABLAI1kqk6lWvV8t4kdyqlvJsAOwJxlvjdVwnYwdHWH31zimNscH0GlHp45Q+POv5C9IcO2cyv0dgUiLZUZZ6PI+6m1Qqazhcrpvfc9013Kz81vk3OlIz3MN8SIA9uengTqm7R8XI1Z/LjmuyXJrd1AuHIxKuhNMTqYQL51fAX4IrEJIrkpI8LpZ+e5mibGUW8soNTFMi/I4tOl8dp37Fwj1j1U7zZyzIAN4F02DNna3ShTejeeYtV62F7dqV00f1WJVljVnB2F+w3J/tK69eK1EuKTlUJLWCsTc3lr39bMM6+qxIjA9lbXwwHnq5cDCHLZM2XWD4gpDet8BS1TdSTAO4qhjIwiOl1xxupE6+nJUBZLjhLzs477On2Q0CXQmpg1aS51HEBucoFG8RZPPppGHuS1bpKg8jBsPmaLNU0+M5vPZ00KijdDgG43NLgmUc1FlokwQt5hC+9W3q9
 Z2phnZQq
 lZp30yNzB8uc9Y30oXiUvrk4dHDr6jq2upTnlFGx9dJHWQ1ABvaSwsOK9UmRNw2ypEvaKKHl5CwTEcBgGPYIh92JSgCGDp/VrAWGecogsOSCJxZ16zRNs6UMmxkT/d7ncJOMgxzwgwCg3mdnSq79pGyiHVGaw33u5aW5yWVnP7Svuc3LBfdG3OYVi7FGlVkSSjYEy8EFHjCHqjPB8zfiigbmLfwvin4ZEzOFjKslNS0744LpRzA6w9kh2UKu4VeZfG4UpZ3aJoc9PwxCxek5ZjNDmvwDF9ZtWdJ+WcW+bKxdvYuGWCcQ6aQBuWbO8F4Rj+LcmhdglBC4hOqd5SggQ2XWxQ6djqJ9+uSUWHNuwzG+D2TmOZQY8FF43dpG6ivJPkN2LUJ5/mgBzpsOxwZ8m1MQCiiIHwGMlYnZA
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
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
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
index 0f64909e8d20..92e88fca717f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2323,6 +2323,7 @@ void __init page_alloc_init_late(void)
 	/* Reinit limits that are based on free pages after the kernel is up */
 	files_maxfiles_init();
 #endif
+	hugetlb_bootmem_struct_page_init();
 
 	/* Accounting of total+free memory is stable at this point. */
 	mem_init_print_info();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index bb23fb3077a3..6e09000ed3e1 100644
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



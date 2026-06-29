Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5661C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6B46B012A; Mon, 29 Jun 2026 11:04:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6A86B012B; Mon, 29 Jun 2026 11:04:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9456B012C; Mon, 29 Jun 2026 11:04:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 698DF6B012A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D91291C0F32
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:17 +0000 (UTC)
X-FDA: 84933270954.18.1154E61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0BAC320005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f8Tk+me8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745456;
	b=K+09JkhOVRrPUlLJAxBfp316dmqpazpVX5hkt3TIeSlKcGKevai1k3OvXtIZbm5PHsCxg3
	/WvX5gcr//4gkVpkaDSAx3bQoSd4/KSD1ojeXGskVr2rZpbuQX3Yo4evoeS+t3Ns2SGAZ+
	ryMAtQEbz8wpTUq2IY9dGT7N6SRKTpM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBjpCYjBMhPtyo9qr5siyapw3yrhce26q5aj9upqhM0=;
	b=lnBsmI5KoHrk3li0eWNpZ88U3nX4Hwbkqqo2sDnQVF8a2Rvi68DV7cZiJ6QEpTYnfqUuSS
	c+KaI+9qW9mfM1DfPxSM43vP0kJQmWKxiN6nRd3KwooRAdReC6rwfLQZTBDWQO9+tZpDJF
	waQscWCyYNYqNCHcVK3jVU4yKizYuKA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f8Tk+me8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 57A8042AD1;
	Mon, 29 Jun 2026 15:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7791F000E9;
	Mon, 29 Jun 2026 15:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745455;
	bh=MBjpCYjBMhPtyo9qr5siyapw3yrhce26q5aj9upqhM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8Tk+me8Zj8RNMcgJxqwodM0/MF7NT2XcDwCKVDSQifavSEtcC8ESd2ikc84dOzsA
	 pwRy1AzG6jmvXORBr/hXaj0zRm9IfWwSRtxrkr/smPQtwoHVJdeDNxgZJxyeljcRG3
	 co8Ij7CSEDETiJuuG/G03Bcl3Rfq3+DAPO+4orbj8NCBquGGcsw4fkU83kUXrk4xrb
	 xXpgxyMfCeLUPbd1jFakfuwBUKa+RKXiDFacraK+r/A2ZlPUQO85SRKuDQHhTZPt8j
	 C8mY6qX3pg4tWhaV8mFbKgOsKayU4ZXq7BwzBcrpEcRlNG27ST4UaevQi4ZBLoCMID
	 lOUDOVNcBj+IA==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 05/10] mm: introduce and use vma_filebacked_address()
Date: Mon, 29 Jun 2026 16:03:45 +0100
Message-ID: <09a1c7a0bfb2ca4476589af7939332930ed1f93c.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782745153.git.ljs@kernel.org>
References: <cover.1782745153.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0BAC320005
X-Rspam-User: 
X-Stat-Signature: 9zhmmkuib1izqx7ztuhhx6mmzybbmxnu
X-HE-Tag: 1782745455-202211
X-HE-Meta: U2FsdGVkX18cpo53x2R5wy/SDei94nagmXnjjyGm+4ZnVguYmnd17WHe5KcHSERjvPvt1zWwSkxcsdaqLvctzYB0qusd/osNF1RYRghKt2hYnDHtw7Sj6CW4SmaR4FYP3uhgxfdkDD6pRd4WSPsiDASJaA211Be19QLVfR1zjw706EnhQMm/IPB7zVqjLlJztMbxveaQcplzyDiQ5ycYwRN9481m9TmByTx+9UKFMLU/uC78O2yIZE236Bbuk0X3vEaMCIJ8uwK8/t/ePCcbSOA3t5c3o2+v3PeNXxExqJ9gShtsaROMjt5fikwqUdZ1p6gsvU+vPTAusI16S3yo2B6TKxiPg7qnYaYalYFuwlsXkbS3vydIijPBl7eCyyKgGwLA3YYI4I7RW/gJDl2WM+ojUaGufNLKqCllPAPMf7LD9Tvt+elrJNjHiCOzxuR7RZWmqgSZH1GTUwwg9mFP72K8/9qXsctNUhrXnuZkt76x7o2Jt9LsTwX4JT+DWTYqgG0yLoDUUxr72tMszb4WVpTf2Es8x/j6eFEEVXKqLjQY93y6Artd0XS+wpSK3MtgsgB0wIRzToD/mPXb/FpNkMrbsgaC+sVXm8nhVHDuXRbUDkeyYi2OUSg9rtWIG+rWXIsSgviESzPKw0NzZx5PLtJROlhXe+yQAH9aPWNM5rTK4SxVsUQ7JkDVmWPOiDFsSbOS7DeraogM162Fbe/B2R/4XmSmo1onUJgPY/9DRgl6KwiYgkr+c181wtYRM1p3s6WfHDTeovJhGjX6tKqASgK5EF1Ck3ZnefKkFj/0F4b1eukcd4WLjHg65YirZjVHt/xJ/bOauu6q0sUIF+O8EjlsfSepp97l1riqu4/eVFVaVHEGMXaUN1qWj3swG4s4UiY0j3LNVnHSF7eZKr/USIl27MtEeaBBnzk2Xi7LgYtllqRSyyN+kAQEo9lagCl637GbIbDe1rVnf4Mk8sf
 A7xacQTe
 mFolQ3h6O4oE2v1r7ZOjHE32s7s3a2dt1+06AwanIL5WYxe+Meqx0ZSOzPCoik+cX8uGvOfFOEjyofhD7k+g212OIHrl9uYeLA3W/o3MMt0+2Ekc6wyj4R7yv0vcVAa+9BE+n9Mr5mG3QOl/guhsocMG9Fe9fH/cv5KsmhHZPrg/cORHykHG/klpV7YIvxqfP6UNJa+753wPcJBnWafKf5VmQXCYzQVdXaif+XmmyXxZIkviT5Rc7NTrWIse6w5f7N8fIux9HPMr1QtVpsulBDNGThMW32EqWy8iAmw9IDYT5vVEjPzjpZxkXzGOW/yISKRb+RV32wsXD+gq0HpitHs+Y2F/6XB9Xr1IGnQUECAJ12zw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cases where we know that the VMA is file-backed, use
vma_filebacked_address() rather than vma_address().

This lays the foundation for using the virtual page offset for anonymous
VMAs via vma_anon_address().

Also add an assert to ensure that the VMA whose address is required is not
anonymous.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/internal.h        | 18 ++++++++++++++++++
 mm/memory-failure.c  |  4 ++--
 mm/page_vma_mapped.c |  6 +++++-
 mm/rmap.c            | 10 ++++++----
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 8689f560854f..f1e7e6256b4c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1244,6 +1244,24 @@ static inline unsigned long __vma_address(const struct vm_area_struct *vma,
 	return address;
 }
 
+/**
+ * vma_filebacked_address - Find the virtual address a file-backed page range is
+ * mapped at.
+ * @vma: The vma which maps this object.
+ * @pgoff: The page offset within its object.
+ * @nr_pages: The number of pages to consider.
+ *
+ * Returns: If any page in this range is mapped by this VMA, return the first
+ * address where any of these pages appear.  Otherwise, return -EFAULT.
+ */
+static inline unsigned long vma_filebacked_address(const struct vm_area_struct *vma,
+		pgoff_t pgoff, unsigned long nr_pages)
+{
+	VM_WARN_ON_ONCE(vma_is_anonymous(vma));
+
+	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
+}
+
 /**
  * vma_address - Find the virtual address a page range is mapped at.
  * @vma: The vma which maps this object.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index cbdec52b6d23..5b7cf2291b09 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -608,7 +608,7 @@ static void add_to_kill_fsdax(struct task_struct *tsk, const struct page *p,
 			      struct vm_area_struct *vma,
 			      struct list_head *to_kill, pgoff_t pgoff)
 {
-	unsigned long addr = vma_address(vma, pgoff, 1);
+	unsigned long addr = vma_filebacked_address(vma, pgoff, 1);
 	__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 
@@ -2207,7 +2207,7 @@ static void add_to_kill_pgoff(struct task_struct *tsk,
 	}
 
 	/* Check for pgoff not backed by struct page */
-	tk->addr = vma_address(vma, pgoff, 1);
+	tk->addr = vma_filebacked_address(vma, pgoff, 1);
 	tk->size_shift = PAGE_SHIFT;
 
 	if (tk->addr == -EFAULT)
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 2ccbabfb2cc1..eff619180e84 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -347,6 +347,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
 		struct vm_area_struct *vma)
 {
 	const struct folio *folio = page_folio(page);
+	const pgoff_t pgoff = page_pgoff(folio, page);
 	struct page_vma_mapped_walk pvmw = {
 		.pfn = page_to_pfn(page),
 		.nr_pages = 1,
@@ -354,7 +355,10 @@ unsigned long page_mapped_in_vma(const struct page *page,
 		.flags = PVMW_SYNC,
 	};
 
-	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
+	if (folio_test_anon(folio))
+		pvmw.address = vma_address(vma, pgoff, 1);
+	else
+		pvmw.address = vma_filebacked_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
 		goto out;
 	if (!page_vma_mapped_walk(&pvmw))
diff --git a/mm/rmap.c b/mm/rmap.c
index 183603813255..0bdb65852222 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -865,14 +865,15 @@ unsigned long page_address_in_vma(const struct folio *folio,
 		if (!vma->anon_vma || !anon_vma ||
 		    vma->anon_vma->root != anon_vma->root)
 			return -EFAULT;
+		/* KSM folios don't reach here because of the !anon_vma check */
+		return vma_address(vma, page_pgoff(folio, page), 1);
 	} else if (!vma->vm_file) {
 		return -EFAULT;
 	} else if (vma->vm_file->f_mapping != folio->mapping) {
 		return -EFAULT;
 	}
 
-	/* KSM folios don't reach here because of the !anon_vma check */
-	return vma_address(vma, page_pgoff(folio, page), 1);
+	return vma_filebacked_address(vma, page_pgoff(folio, page), 1);
 }
 
 /*
@@ -1321,7 +1322,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 	if (invalid_mkclean_vma(vma, NULL))
 		return 0;
 
-	pvmw.address = vma_address(vma, pgoff, nr_pages);
+	pvmw.address = vma_filebacked_address(vma, pgoff, nr_pages);
 	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
 
 	return page_vma_mkclean_one(&pvmw);
@@ -3051,7 +3052,8 @@ static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
 	}
 lookup:
 	mapping_interval_tree_foreach(vma, mapping, pgoff_start, pgoff_end) {
-		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
+		unsigned long address = vma_filebacked_address(vma, pgoff_start,
+							       nr_pages);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
-- 
2.54.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E625C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C0BE6B0099; Wed, 29 Jul 2026 12:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598426B009B; Wed, 29 Jul 2026 12:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADB66B009D; Wed, 29 Jul 2026 12:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 179ED6B0099
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:49:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A664340775
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:52 +0000 (UTC)
X-FDA: 85042401024.22.8913E1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id CBA612000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:49:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZW4rZyB;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3AnDXjTfE+xQ+f/ssW4LV7/F/4k8NafgCiuZeEmWgjk=;
	b=zfdqXEcsS5HHs5PIo8AUYJLZudJDYzeRj/m+TXWo4E2Ec/jLKbJa9EEIpUS/CRJj9bN5Zm
	wwkZVx6s0dbn9IP2bU46XWzbCirf01vSH1PDjiO8VFHQ80Zqq+OrBKu6q1B7PvNL59S0cZ
	nQHAff8quDvczKezTeCCxQmRlxdxEYc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UZW4rZyB;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343790;
	b=ECgUgIU2jSqZZ5jpGxg6n8sJLoG4tlIe9SoiV6X4BxPfaV5jfn2khTavlmCOefeDPguN4p
	1443Hw7NuIFOEhAkibBt5pRvNf9/W/N2GfmviyfFrgGCDj/GdIcDV6qA2oeJBOFqqUPIYE
	8F+FPfBvU/NU/7uvKm0FDHyppWzRWuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 173EB41675;
	Wed, 29 Jul 2026 16:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EE21F000E9;
	Wed, 29 Jul 2026 16:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343790;
	bh=3AnDXjTfE+xQ+f/ssW4LV7/F/4k8NafgCiuZeEmWgjk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UZW4rZyBFtK+wt1THkIJxDf0KJRLDUfHY6Td2SkZznQ/VaTeeNPWJ3wO3U0cbCep5
	 yUSNfarHWui0tFh3ExN/gtvwMdscWKUUlcWpwHwAEKE+uQv4dGCMrYqNhWI44WzQYr
	 xns4uSV626T/j/q+oeO3YFfcHW2SlYjhGGCs3xQg8OrCB+z1dUpGcNIt0smRDIk6HO
	 602TE8XD+fJt+6XICek+xasZcgrAMdqAO0ceE/BLgICuji4H+Eh+P9YtLHqf8YJC8u
	 N67mNeZKbOq23ViE+JYs9uo+CXOe4xS9XZdQfVuCLnyhahpSCrEE8R7x0WC4uZrnIZ
	 ObzVJ3GTETDIg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:40 +0100
Subject: [PATCH v3 05/15] mm: introduce and use vma_filebacked_address()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-5-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4872; i=ljs@kernel.org;
 h=from:subject:message-id; bh=2t5Mr+R+1YvTkz9Ej+HDVNRXrsa9Y+YAQK2UREEyZVU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H5sVEjI4ry+rvqR/BF2zY0GNmF9lntStlrISS6ey
 x7GvCqlo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPZ+ZLhn1lQ/tmWn+5fohmu
 q7hUKvuVMc7I3eh2rDMqXutq2Oni9YwMe7YsnPGrRuP4H8nJUzl+reTVu/Ts5OZ+3c6Z4UH7W/7
 P4wAA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: CBA612000B
X-Rspamd-Server: rspam01
X-Stat-Signature: 15436au5ixpdnc5dwon57azs1mo9qtso
X-HE-Tag: 1785343790-494929
X-HE-Meta: U2FsdGVkX1/XN6BQHtEm6yRC1577n7s2r9+YDAavaHHzcLPjDXour/GimPIBhbm/APc4y1OfLrOYcWjAD6qtnkZW4mFhjsqytjMnG3hTtUhYN4vSDdvvk7s7CoXl1QPbjltQyFzhKEZTwccRHhNEx7CicoVuA1p4gs7q7mH41GKDSHdBNiXYRPz+qRqj8b4OuDv2Uk5Iq1lCJhFWvpKC5Do4D9i/tldU45hJQi9ilA3OrahtFDY97u7OMp8uqHIpDVNSBv0Ly1bVS4Qc3Tr9XaU8aRBBdGbXuN3PMqbspRA+h8Bu+wbNt1HC87cdzp4y8gjrF8XZEeWrqJcFV2mZU+/tVf5aArdueLZZtZTCASgkEF62ZqUtW4NYkHZdSPL+8gLaCTHYf/MtrPk9bisA6MtUego78qAmCMvEZPa5/BnMqkdQhtMLZqGPF1v9WwF3wQSTUtX3NadcUlFxtpR3KWjnufuPyTqD0aq4O+rfYAEsYWTMem/jq82U7BbiXVgI5w0erUzbZ50kYFwyg9R9FwFsZCCsVNs1RlYkC413jGRIRJ9eFseDxYnJ+EFdy6cbGbTO5l6m+jYAIHvxY2QwdArPzq1/MlqpTOWdqCq0apGy5C+9d+EKzbNh7GmyuKYUCpi5sxx6jqRlXwUCmrXBTIujG9wMupDi/isIu47wEzSXRE0yTPmXVdbaQWxCfZF/hsfE1N61bK+fH58Y3dGbDjOcIoVGyHpIRD4A/joyDj4ErBQrqWMAsJtjCjgCzA0U351GqCQTA/hJOWHJPwaVGKqlkxM4LbItgBH8Cs0nI4qyQttGITYMwunG0BvgW5F0OWtiC2S8LbtNo4rtdKvufubwu53SXceFKZ66IxXdv75QlTjjoSg9eEpVEpL35MSxLG3Bq8b0qjhedDiu+oDAACF8FbAAR7bSY6NvmJYhCp+JKcUO1l2AMY6FOx+LGdnf5oZQ4ZZB4+gRPx4sqra
 PT2cOJlM
 ijOuaYR9KFWxpTg681HF2irUz0/onG4zI26xkkq/yszCqIiRwW+jWuyMdpqi8QtL2AY69UFGfQt8Kw4UjA5yq9VT51uAdlMbU1s6LqZXM9YwM6ovivN+Q1qzsm9mew3IhOUx8/YgBtHfOYv4vWGhYomlFTZ4syeMhAYj9AWUU89x7EMum50YFaqVrkNOINeujnJ7UcKmARJfUwS9nj9w7exc0xE/4xtzSEjRmpxH02liizDHH8tRanQ1wVGnOqcrSr5RqYjcN0SgpYycoiFLFYvbCalJaMcIAIGcAzF8F8+4g7F9hUPaD39EfZsNnjqueW68KJHeV6qngJlQMs3yp2fSWduDnVWpBvi4mBth1otnYaVakenq0IYdzLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In cases where we know that the VMA is file-backed, use
vma_filebacked_address() rather than vma_address().

This lays the foundation for using the anonymous page offset via
vma_anon_address().

Also add an assert to ensure that the VMA whose address is required is not
anonymous.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h        | 18 ++++++++++++++++++
 mm/memory-failure.c  |  4 ++--
 mm/page_vma_mapped.c |  6 +++++-
 mm/rmap.c            | 10 ++++++----
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 0d11eb8e615f..920872904bda 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1025,6 +1025,24 @@ static inline unsigned long __vma_address(const struct vm_area_struct *vma,
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
index aaf14608b30e..a8b03e2920ba 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -620,7 +620,7 @@ static void add_to_kill_fsdax(struct task_struct *tsk, const struct page *p,
 			      struct vm_area_struct *vma,
 			      struct list_head *to_kill, pgoff_t pgoff)
 {
-	unsigned long addr = vma_address(vma, pgoff, 1);
+	unsigned long addr = vma_filebacked_address(vma, pgoff, 1);
 	__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 
@@ -2265,7 +2265,7 @@ static void add_to_kill_pgoff(struct task_struct *tsk,
 	}
 
 	/* Check for pgoff not backed by struct page */
-	tk->addr = vma_address(vma, pgoff, 1);
+	tk->addr = vma_filebacked_address(vma, pgoff, 1);
 	tk->size_shift = PAGE_SHIFT;
 
 	if (tk->addr == -EFAULT)
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index d7670ba4147b..081e483cc7bf 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -356,6 +356,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
 		struct vm_area_struct *vma)
 {
 	const struct folio *folio = page_folio(page);
+	const pgoff_t pgoff = page_pgoff(folio, page);
 	struct page_vma_mapped_walk pvmw = {
 		.pfn = page_to_pfn(page),
 		.nr_pages = 1,
@@ -363,7 +364,10 @@ unsigned long page_mapped_in_vma(const struct page *page,
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
index ad820fe86f7d..5798427d007f 100644
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
@@ -3100,7 +3101,8 @@ static void __rmap_walk_file(struct folio *folio, struct address_space *mapping,
 	}
 lookup:
 	mapping_rmap_tree_foreach(vma, mapping, pgoff_start, pgoff_end) {
-		unsigned long address = vma_address(vma, pgoff_start, nr_pages);
+		unsigned long address = vma_filebacked_address(vma, pgoff_start,
+							       nr_pages);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();

-- 
2.55.0



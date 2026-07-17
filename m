Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6242C44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 18:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719A06B00C7; Fri, 17 Jul 2026 14:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C98A6B00C9; Fri, 17 Jul 2026 14:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9BD6B00CA; Fri, 17 Jul 2026 14:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 177AF6B00C7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:23:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E960C0217
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:59 +0000 (UTC)
X-FDA: 84999090078.07.9C5E214
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA08C4000D
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPaEdbOj;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784312577;
	b=SjiHr8a2A8kzhIljjk8uRAgEo/pdx5bmDscfSy7f062kMNRnF88stmqyAMaCEaKZU6P6pk
	60CFEb35NFlN9GQsaT4jA8Sm+N29cQy2bK0aPUTEnU6f903mpDKigz9C/e5l+BfiCObC4f
	c5C3FDu6EYVaKr5z2XTKKzEciUv8xqw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPaEdbOj;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784312577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWH16RMl+8FexBLFh6ScXidqQvRnE14iA6MdxcccmsM=;
	b=11tyQ3V27jBR03aiW/XrUYKpUR+7xnYmOFaISBFplHqlZzeh3kbCxBmofqJurn/fHaOWI+
	H2eXJ27lstZayHWJYjkisSqGjq+AUfgNHSu6+ljX0fWVzy0P3NQB8HV4y5VKp/2LMErQu1
	4+uBOF4Et2vjq/Q4vuVIAjiAzIaq9zw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22D02403CB;
	Fri, 17 Jul 2026 18:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5BC1F00A3A;
	Fri, 17 Jul 2026 18:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784312577;
	bh=hWH16RMl+8FexBLFh6ScXidqQvRnE14iA6MdxcccmsM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UPaEdbOjipnQeZVXns57A4+tKFRvb0G3mGTTDnuRx8lhCbgfamRLCaxC5Dn2lAje8
	 t4SPcjV+dETPer94Y/Iqfz6M9ip447qkNetc5M5FLbc/UqzIN7wTGRhWh9YS9uYEhV
	 iAkK/p7lNbrlApeUMXnGASP1b+9EKfyLwayGXeRy++ru0UKZFRufVP1DaKO/UaNQUZ
	 +oF/1WnnOI40UWX+brIZq526ZOF9ei1YtlekU/PQw6yde4fOEoMj7e9XgpUEQ7Knl1
	 fFMidcddxj3u9T9UB7/q8wS6OKOp7Gle12Dio9ylJqhlBvG+qGM9P0eEYscfOO3OGM
	 nXM9zkp9iCdsA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 19:19:43 +0100
Subject: [PATCH 05/15] mm: introduce and use vma_filebacked_address()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-b4-scalable-cow-virt-pgoff-v1-5-cf24910ef094@kernel.org>
References: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
In-Reply-To: <20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24910ef094@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4889; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wV4Xs9C/oteickrPVjPK0/HJqNh07r+G5RYKSasgEQI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKiivbOXH1cVvHc5SudNg+3C4v63ja3lnsSvz/x5zTx5
 PvF/xardJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAik4QZ/qnbfL10XjZE0/W8
 z/mtio1177e80F91QO3R70Prtu+WidvLyLBarztkVusfUbGuLh1z95Y9EQ/9VKU9f0lv9XHYE2b
 yjQcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CA08C4000D
X-Stat-Signature: 5ozw9pk45nijg16ixj7qyqeb664aobyj
X-HE-Tag: 1784312577-213657
X-HE-Meta: U2FsdGVkX1+5Pti2XH+utdxJZJsrwb1etb43Oai0xBthvCSQ9dX9V+YfjKoOaj/Zf2koPCT/BbpZZbxXuNSm+2fWaxIJaoOixaZs10RpeyvT/0uF3PbyfYLDN5SdMWLGy7qJGTN2TdGbbVp85KqKn5maUrZWRmNSnnImWsAywQsPU1PdDDitoNnnZq5DJlGu9pjfKCDoL4ccJt+BLHyMSLd1SPGl9/yDNcNFWbyGCg1gC5c6vdaeJAUdWMYu+vrVMboYrlcX98wR0qlHmRSl64nFU4gO+uyTs7lqrx/PUV30meV5r2nFOBPyncYnUJDxuBgcHSdG/vzBsjWE1VTfFHapyedYDuFbvU/VRQxLdDgxNnxa0J5bXAG4HDPvEHy4FT9Ag15bc+qsxyq8Clp/Qf3z8iFK2kw7ozwxiA583X7RIinMWWjwRZK0uH/b7j9bWLTp3qTZ7snyM13YfbG8JR3Ugl1JtIR9vXBG2CoxXIMTnDD+vhxBROQiinUlbHGPoQVd80zEZpLX+CQfCfAEWi9vxKBYXQnSa7nTfPclByC9dqRHVou46RabUe//+7Cll5vLn+UauOBFEvgJ20QvwN96vkQURWce3LmWX7fWaiP3zziC7ucZcDgu8EhEU6IsIYFdbAx7WIRT0b4Cfh5+XHZuGu9sPjttqdtirZDE0jBV/LZ3JWtHkNsRjKefiaxR53uH1+2tztYd2v+hD+dsgNmO11LDvFsYx7g2QB2lVzo+NpDFdnRum71HBAMBsicQE2ZTC/RbDBV6JzNFzadKbw0WY9Wr6Ta8urZTFDmLn5s1BH+zNcyTV9RliljQ819mIJxpkNsbkLuObwZcVteNkusMm/YzLHlbkcvAYpOBx2gZ7UjXGa/gPR3xuNDUu0tlfq87T4tY9C/XUOX9V/QIzD/UEWAZi22lzrJOUzEMPUKGiZyuDOihrPdFUz2ibYxEsTV7yBMZFt8ckY2cNsg
 4XnIjHJR
 O3IDxOjrGfheNjUc2yEmIDswn9KAtC50rOY0hQrT8bit/rV6HnAYWkOKiAbLDlG9CuSoLtr8w7keVlLH8+/sWFdS1LKypucxXoUha3rtLDKb0B19v6+Q5yiIf/DetERdg3HVwtJKnOuWNSWrrmGV0KvAcVULGTQO5A0zs0Fz1cDOCUAziXGimtd1ikXtb39RbteBoR1s0B7eurrilHZq5wiYbvnyrqHpEi9mZCcgK4jTM4i7neh2/pLditF2ch9g0+hWeMReO37kJnO/Gk5uhIp5kboOf68diMOw+tEDNKEx5itM9AyPzmigdMve6jmP0kDer37N0MbsUKz5LG7m/PBMwXvbH2aPQmuVDf189w6qYlAMgigeKzZwVWA==
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

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/internal.h        | 18 ++++++++++++++++++
 mm/memory-failure.c  |  4 ++--
 mm/page_vma_mapped.c |  6 +++++-
 mm/rmap.c            | 10 ++++++----
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 04acfeffa066..73f90aaa979d 100644
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



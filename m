Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527A8C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3256B00B4; Mon, 20 Jul 2026 10:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B6E6B00C9; Mon, 20 Jul 2026 10:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4792F6B00CA; Mon, 20 Jul 2026 10:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9216B00B4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:39:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9095AC01DB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:46 +0000 (UTC)
X-FDA: 85009413972.26.B5386F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D6F041A0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:39:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pq3UG1mo;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWH16RMl+8FexBLFh6ScXidqQvRnE14iA6MdxcccmsM=;
	b=tQKTppoTwQE28bEHzUayayvwNv9LNsJA4K2FOGWkOjYAZc9gfVCmT5UvoRNFAg1kVxsNzi
	AFLOLY2J6BvS06ZS060579l2ZqWw2nLtUHnUqhnZZcXbCRKkP9R0SX9tTmuYW9bNnoPYZX
	ZdQCcC5CTheI+vxgRFDwbQFtWNZorm8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558384;
	b=nsd32RDRoOhkGS1a67i3FzsYrfjJQ44z1O4mQIKwylk0HI3plDobREp7A63ze91piOuC7X
	HLiTvawWisdDMuvuzLpIPI1FcPCQXibfHN1eD3sbWUpp3I8jP0GjX8yNo2qDWxXFl/lWKv
	qbrrW7OES/gQiLp8C6zMomjmhOkP6Mc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pq3UG1mo;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 743B260254;
	Mon, 20 Jul 2026 14:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674D71F000E9;
	Mon, 20 Jul 2026 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784558384;
	bh=hWH16RMl+8FexBLFh6ScXidqQvRnE14iA6MdxcccmsM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Pq3UG1moZojHMbiBRt7zmy3/ar2QOsaqtfcAbqhe4lV/OXg3Awo0NcvaauPsPO41Q
	 vtct8I1EyrHcQ2an97w3N+gtDfyLQOzNOZR+TJJHBvfpT8CDAPnQbTyXU0mFI/b+H6
	 rSKvZJRhlVnsU2wzTWsufuG9CLpAuiHrY2bMeTHkauZH4sv4xqec32RlQq9v/5eBwC
	 6nCX7mxafanhj+uBGN0QEbJMXsjR38UU5vu9QmKCnN+JbeqaMjyMdxmu9Lqr+ZQvkz
	 o6QRYNCO2a2D1peFfo8RCra0KGRAFyWR5s6PogI3P3AoL4Ebg/XNxxV6yYaqdZ78i/
	 TkqJxv7IL9Pog==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Mon, 20 Jul 2026 15:38:31 +0100
Subject: [PATCH v2 05/15] mm: introduce and use vma_filebacked_address()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-scalable-cow-virt-pgoff-v2-5-2d549757a76f@kernel.org>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
In-Reply-To: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
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
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLijN6U3rdteNSjXlwcseHZtlt8JYcydp+ss14kPXGuM
 WPy25rgjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEwk0Y+RYVKBT8/pDWfy67f/
 sEuyfOi194q50dN778Ir954ze8m3RpyR4YX37LrI6T2CEzL/eWw6Kdmd6hsz/2e7fPCiPwxSy7O
 XsgIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D6F041A0004
X-Stat-Signature: njarejc1rf9jwcoi3cox5azw5mp8jewu
X-Rspam-User: 
X-HE-Tag: 1784558384-713174
X-HE-Meta: U2FsdGVkX1/vz/vjSi9TlpIl1Dimfn+I6s9YRm3v35Gjwz17y3nJOVm92MVEpFIO9Fv2lgsbzUMOn20K7U4voGt7UTlMtElcq60r5PgwdOfyqQ0OVba/bDMEU9eAqcq/mOCBMpGx83Sc13zrR93OV9CBP0y+NbvdGngS1Bqj5g3oN+/wAvPTliFjvQpSs0ArkARYYng+BTvciojDQneStBkP+GAVCdWu4Qwl0QvbGTBrakpnmFDAucmpKhvd1G9A6EsgdvOncKW0Wt7JqqTYRvmhdC2UcJRcAdtu+ZPDgD5VPJZcXooHCShxsFS7G8Iv4yk9gT03AabOg7Lsk0/6Yih/rssEeo7FMGAJIIx7zu/xui/0Y1ucPAXapzW9/sJ/4wBRzcnHKhBj39cNP/FTQSW5tHM0r/Iqg5j52cQgUMIlfjXgTSbuPBIMI9go+3/v2csAS3XRAfyhzuyfcEA/LlIdta19yT0eDpARYQYosjhip8M359HE8YlU0uuhb5pT1onErQhtEMM1dgBTpLKUHkFJLU5C5wUyuFmwhpPUf0ehbMWklUzdmwsSFYOmvbnyg03hOTcfA5QBTEcNtEu9gD+OPoFTI+sPfeMiqgXAjp6oMNCmwGAd4jkUI50Oj08d4gwvNt6fYJZzucDGOGXT58M4DOuer27NvxHvwB9AggVbLdHNmWOw7P2SjXrQK/TmH/emHrPhvRHHezmT5g3hhoLkJWNxmLqvwnTVBCyfNFnAQrZ30DxudgziIOmiUgf+yLUf6XU/AVED8qo8+Qhv8uKoyQ6jiAhd+IyIfePFwKTROEReMqA+QLQ6rHVmQgYCYh1w0+uCppWvQsEKC0UR5ldGrrSJUaLsJPAPvPQnH92h1ql4bruQur/MMTXaVKbWptbKx73CHYnPz4nFUHskdynqwTPP1lZzpRasGlzdiN+9vQNXYEh5s2WXN41K/uYcxVGKw4NPv1rl2YJfJFD
 M/GnTo9p
 8wlza14yI1psw0b6Wx0BfzW2ExPNxzCkySfXbviB4SpS7Iys9MMBQ2SwzmSI1at1T903TlAM6nCtnEHEk6Xn0rhucWzJ8Zq9b8j+L6Bzcl3iVE7mfy5hWntNtAVJGrAZoLU3cM6OUhBx/5xpg9u5PDxJvyb6DxwtK6kWpqPar4i0ZavS88bGxv03QJunNE46OHETy8r/kZOACLTCX5V+NMoacm1FIfJQuYr0/ncSsYYLm349mAmnOKgMDeoY+KV3LnIQ6EKSYT444A39Ron5mKPGHETEyP/Bx1qbJdayuStppSCQXlb42z3pEAx7x4RyQ4ccEXuZGfQuBciUMm8nOm0FfDcSqDkDpBJv7ayNWdek2cR7veMaw2Csq2g==
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



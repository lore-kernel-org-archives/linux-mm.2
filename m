Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF3AE99076
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2317E6B0098; Fri, 10 Apr 2026 06:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB2B6B0099; Fri, 10 Apr 2026 06:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083726B009B; Fri, 10 Apr 2026 06:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC09B6B0098
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:33:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BBB0EE3065
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:15 +0000 (UTC)
X-FDA: 84642283950.17.500996E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 12E3740005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:33:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PNexbu38;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817194; a=rsa-sha256;
	cv=none;
	b=cgWMPqKCcnF6LowOkrQTMYzNMSRLdmM5SIinF4vFhuzMq1UfTfseTRGpblxlvT+nhgTScQ
	y2SUQOtysjhZsvGAS4arYLD/CT0JbWVxKM9aGTz3Arpp0TlBAfKlNJPfgUDxeDxw9x6ZFK
	ZBpf5J+CWUDpeDENXnOASI003FoBhSo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWNnVW0/9cBjzFBC2+Ekmae+lvFYUKNLo5kn9Ffd5Ig=;
	b=rWe2U89T1SC0idE9rMeNhjswwPQF7UP+29Lu/rpDCXb9rOJkj68W90h8B4zmQm7pPvwJJi
	WfDkOtYUPT5t7fjyqeZfBD8QSO3cNOdb43wMR84s+SHCfxtpuIXnDalx6Rj+vlfwWCZThd
	oLNwM4mk4UaIOiMex4QQ8ux5M1U2Bmw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PNexbu38;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8890026AC;
	Fri, 10 Apr 2026 03:33:07 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 149533FAF5;
	Fri, 10 Apr 2026 03:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817193; bh=ZjAFZQGht/MkomLmPetxzLAvC/RxdkzRQ9Ld8jFfkCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNexbu38UIpmS8ZurlXAd4ooPHyE+rz9wcSHywjpLXQ11yC1pGXoJoxDKsLldKMPV
	 +zQiwWNDDMKDh/wdoVY1SIGQqe9pwaIOh9+AtTbNIYcDGDb7jywOncX7VWXlg2lV81
	 oRFQlx2HzlW0TrxUet4ELXPGTXdzPGfypmTHRvKo=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 6/9] mm/swapfile: Add batched version of folio_dup_swap
Date: Fri, 10 Apr 2026 16:02:01 +0530
Message-Id: <20260410103204.120409-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 12E3740005
X-Stat-Signature: m8c6a6ichjtb1pox6cet8bx6jpcpd11j
X-HE-Tag: 1775817193-776104
X-HE-Meta: U2FsdGVkX1/GMdltRknY4om2hqGIKqchwP/uPwhbVoHHg/8DYxDWUVT16o08cJtcdHayAMl8L4m8Ppl2fWt8uz9tsQ+MV7OgBNxJv8CtWuaR/xFTflTsjsD7azM4AOVIe4UAhsVldBHcUgGdKfcmWQNVsqb+H1rJKhTQqveLGntcMIVoihFz/MFPskujWjyrBkOsuCzMHwKBK6A61G9JsjgHiiUG0a9m4LEhkBohDHIZxTS1usro8Kbbemv5HMjRFhSwMzbbf5dHuWfuLBPsAh9oZuBOZ7JMt5Ns3D4f8f6l9mmwQDcFQ3kwxUV1yiYW6uZxb3yKplCuv1peZAq6s1uwW04VUS7O2g4vdd5UiuBIi4ZvIzlfnGnGJ9Y9UywuQzt3WFMBGeyso5WnAayE9RQCHuJ1YvZhK0olPzRO4HWBui3y14/2B9DemeaQ1N8oX+br0qiJH11QWgiA+qQW6XgRJyxq+HF+6s7GDUcEz8FDisReFiw8wRS/tmRr/3CrIbfUnW9u2tyOIjGjbxAGKzMWhuw+Hrjhyth/0ja4JX/Ps4M28CHxFkvniBHBJfGEsQLl3PIfP3rnuCPhSf86uyKrzJ1zlHgXR8HajZuU+k0JQYKMgDcfi8L4yqvTecQu6ylWFsQc5kjaFAhj+RK6y7nnwQLijA+B46lRTAXKL1JPMCcRC0COTtvBDLZ7u1Xqx8vFKiPPseNYeKidcvxWcbhCbMB6jQ9tsHCO9ZoBiXS3OWtOg3XOhrcOtZbpjkD5OPYMdP4FG/OXBGsgsULFX8eaiHTEztJqwomuBk59ZNMX2ChRUT1M538jJjHqXjmba9U/0Pl0nLjfdCyhLvyHPzx1BSzfj9rjO9eacuCAOEw2JQOKmMa+Cs5jZSfEwpAvTNfsf73K+vc2NYx0dhZSPAL7bTGF3QCUld08Pwq90q5+pTePTg5flpLrZPxGS98zH9eVFSLVkxubsE5e387
 RCAYrWt1
 hB+s27ob0AYI5RZnXOxoEF/UZHz72BJlymQ+dPgBNEFad2+BHRAR3prXZOfO9ASj4H+Gr7LGDdrNGU8Y/Pu3NnWac9OE0jUNTYwLgr5e7eQKOSOc9VOH16wPQHfVZXS54f+sImE+guX0hfM5DMj9J2k13PgjbVBrk8s0IvzIvsN6esdjhO7Fr4cRjWu0aaGzj4RfszXuhO93VxRuGk4TX4sl7y128AqpQVSHTuXIWk37MaTl1uf1w4gHFj9qxtp6O5E26SDTlwVXMBJYyVSxGgCn3ZoeMGaPSZdio
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add folio_dup_swap_pages to handle a batch of consecutive pages. Note
that folio_dup_swap already can handle a subset of this: nr_pages == 1 and
nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.

Currently we have a not-so-nice logic of passing in subpage == NULL if
we mean to exercise the logic on the entire folio, and subpage != NULL if
we want to exercise the logic on only that subpage. Remove this
indirection: the caller invokes folio_dup_swap_pages() if it wants to
operate on a range of pages in the folio (i.e nr_pages may be anything
between 1 till folio_nr_pages()), and invokes folio_dup_swap() if it
wants to operate on the entire folio.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c     |  2 +-
 mm/shmem.c    |  2 +-
 mm/swap.h     | 12 ++++++++++--
 mm/swapfile.c | 20 ++++++++++++--------
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 7a150edd96819..6412103fcd6cb 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2311,7 +2311,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto finish_unmap;
 			}
 
-			if (folio_dup_swap(folio, subpage) < 0) {
+			if (folio_dup_swap_pages(folio, subpage, 1) < 0) {
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
diff --git a/mm/shmem.c b/mm/shmem.c
index 5aa43657886c3..3f9523c97b9ed 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1695,7 +1695,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 			spin_unlock(&shmem_swaplist_lock);
 		}
 
-		folio_dup_swap(folio, NULL);
+		folio_dup_swap(folio);
 		shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
 
 		BUG_ON(folio_mapped(folio));
diff --git a/mm/swap.h b/mm/swap.h
index a77016f2423b9..3c25f914e908b 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -206,7 +206,9 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *subpage);
+int folio_dup_swap(struct folio *folio);
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+			 unsigned long nr_pages);
 void folio_put_swap(struct folio *folio, struct page *subpage);
 
 /* For internal use */
@@ -390,7 +392,13 @@ static inline int folio_alloc_swap(struct folio *folio)
 	return -EINVAL;
 }
 
-static inline int folio_dup_swap(struct folio *folio, struct page *page)
+static inline int folio_dup_swap(struct folio *folio)
+{
+	return -EINVAL;
+}
+
+static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	return -EINVAL;
 }
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ff315b752afd3..22be05a0bb200 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1740,9 +1740,10 @@ int folio_alloc_swap(struct folio *folio)
 }
 
 /**
- * folio_dup_swap() - Increase swap count of swap entries of a folio.
+ * folio_dup_swap_pages() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
- * @subpage: if not NULL, only increase the swap count of this subpage.
+ * @page: the first page in the folio to increase the swap count for.
+ * @nr_pages: the number of pages in the folio to increase the swap count for.
  *
  * Typically called when the folio is unmapped and have its swap entry to
  * take its place: Swap entries allocated to a folio has count == 0 and pinned
@@ -1756,23 +1757,26 @@ int folio_alloc_swap(struct folio *folio)
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *subpage)
+int folio_dup_swap_pages(struct folio *folio, struct page *page,
+		unsigned long nr_pages)
 {
 	swp_entry_t entry = folio->swap;
-	unsigned long nr_pages = folio_nr_pages(folio);
 
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
-		nr_pages = 1;
-	}
+	entry.val += folio_page_idx(folio, page);
 
 	return swap_dup_entries_cluster(swap_entry_to_info(entry),
 					swp_offset(entry), nr_pages);
 }
 
+int folio_dup_swap(struct folio *folio)
+{
+	return folio_dup_swap_pages(folio, folio_page(folio, 0),
+				    folio_nr_pages(folio));
+}
+
 /**
  * folio_put_swap() - Decrease swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded, must be in swap cache and locked.
-- 
2.34.1



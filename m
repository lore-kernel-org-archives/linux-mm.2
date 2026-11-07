Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E8DB606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 03:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XIC548ok
Received: by kanga.kvack.org (Postfix)
	id 1AEC46B05B0; Fri,  6 Nov 2026 22:53:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160146B05B1; Fri,  6 Nov 2026 22:53:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0279B6B05B4; Fri,  6 Nov 2026 22:53:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD84C6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:53:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4F883402C3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:53:06 +0000 (UTC)
X-FDA: 85406952372.07.2CA4528
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 147D340008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 03:53:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XIC548ok;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794023584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ner3iiszqjA2gB2L+tmjkpwZjCeaE3ezc3JeQhoS9bY=;
	b=0Olzu/bbuINqhOxhw/tjP1qw0iNLPsgEdfOARfXtX6TSAOIL1lsH0Re4IplcpwLQNtAUDy
	GOZ4R0XwcqCGUCr0jFi8KLBDEHpL/txm059DENYb+QAErKEmoylGmWVduzJ8QZ8hPCSQc3
	7PxrNRzpGpe8p+VBOGJL7bL2ZBZZSQk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794023584;
	b=6CDnEDlsvZR6iokAL8Xby8q3xHAVDzLP4QwMIIDVpuRAwTBHsId0gp1EjG2yHaR7ePF413
	AyHlMPpZ7jOjPg8A5QqlvRpxfxyX8YKI9dQgtCjCRv1BajVCDcEP15ARXV7einnjKrd7uB
	4XIS2VJMaR0hOhf8zHN4IF2m8HVdy0Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XIC548ok;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CF1F43816;
	Sat,  7 Nov 2026 03:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943F21F0089F;
	Sat,  7 Nov 2026 03:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794023582;
	bh=Ner3iiszqjA2gB2L+tmjkpwZjCeaE3ezc3JeQhoS9bY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XIC548okmbhMJGvvJaj3PaAegr2ndah8JUK4KO5IAVjSzGWzPFM9FdcTRi5DBqQ4E
	 gj8CNldOz4UC3PkKiPZGegeHkbjEPm1RjSZVBrJien13m7V7ascsvacFjWcv6mApfB
	 5MaWva4dEgWUDpIVZdDk8OBmYxZm7Q3aPtnLexRI=
Date: Fri, 6 Nov 2026 19:53:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Qi
 Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, James
 Houghton <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Yili Zhang <zhangyili01@baidu.com>,
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/13] mm: Decouple folio-based vmemmap optimization
 from HugeTLB
Message-Id: <20261106195302.fd572ac49e52af9e305cbcef@linux-foundation.org>
In-Reply-To: <20261107022756.77731-1-songmuchun@bytedance.com>
References: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: bobcbcn4a8ibfcxt55ay6odq9h8tr6hh
X-Rspamd-Queue-Id: 147D340008
X-Rspam-User: 
X-HE-Tag: 1794023583-996777
X-HE-Meta: U2FsdGVkX1+kPHABd5n6PRT+71JtXwkx6u6OfmgNvAtpGJDGc7w6IbAi/OgLMQRpJyUPIUvLsWVELZJ9krrsotv92t8iGANXmOw1d9DbMAB9HEnr8HsKqcIEQzBSIfGLcGYgmQq0yFyrK9HD2tMG6XP6sUBF0uRyuadoFE/9VXuJhRYF5FWXSaNPsiCbfJR7s8NZ8wQhIywHnS6USWb5xjsY5H8xLGWPPKs1mDAgeaxNmw3qciYMdo54SA67FYud78Nu66k7vtlrc0olMVoua1sv0amI/vBpTKbSdPtbg0Us0XD427Sd3Bo4r7FsZwx6cMqjGO5CZh/yxC/QEoh44gsnPRFo8bpWkksktymzWjbYdtZD18qsnmx7Wj+B4pPtKgi1/BnRd65YOaS4PeNrfUgNk6+dTuoUOfaQhX1nlt0O/6ZCSAPuxnt7dEFKX6r1ORpTKnzwjPfXg4BpYjIAY48Y7mwovMKk8hsF3PG/CnrYaDJ7ORFuUS5WZca62tTxiqwQqmmKfNpMaVeVB29H6dJ6yUkNS+xnj5L9TDEpL651DVPD8JEtleGFdQTDJR3BIZNmhq7E9FXcPLQYtW1FRHi0SY89Oa9Plp9mTXZ4eqJEF2NIaVcUtl6bNfmcdF8lyQ3+umDIgzgv2DrC4K+YOhSVZMtHaTcGaRv8kuM4+2ZISVimB6qENAXjfWGKsQVb6/RKR3X2ahg5gU80noxAVg1SYEIgESIYJ2BrsODqZNKrplk3nFmxnd36DjJBj+8AFW/Xt21YtBvWZEG1DuRXEGnzIAAo7tV/eGOMOJSot+Jkp86yNfuF/rGH9JqFJeeLb9Uw7eVtmo1XaQuBipo+GOCfUJju1sTzY4N5/uA0SSfxPunnHJMaNr1enzIQn+KUReaa0zSpVZIGqzwlknokmFWeBgcoPgac7m6OLqEWnRa6MFgoszRCe+NMIO1TBiowb9iqPvvwrLhCpsMFt6s
 3lUYYJ5y
 czBzzso2J4EU/8ti1g+Bcb1Nclfh3WzN+hh4wA6lGXXSWuVQalMxneMiulUcIMUM7UQkIYcHFyAYNRlw8e9q819trFdEE27rUnjSvpMoYysv6+Stm5Iv0qTjF1mLkgPqpLAMv6HY+AS2weT0qUOTkP1nZJnyDFlMzgJ7S5gW51XZdBnnTZT5+XSCM9+5uM/HoCk2PmNW5mYueSPDERElc0leVLLhwpyCJNd1NcRhcACwYE/fQl/e0bREE21tQuNA5TJcNZbVdE1iaPOmoVhWEp8703tJp+6F9Pnc4LwpEWfgvGPGct2wzxn+qeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat,  7 Nov 2026 10:27:43 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> Hi,
> 
> Section-based vmemmap optimization is implemented in sparse-vmemmap.c,
> while folio-based optimization currently lives in hugetlb_vmemmap.c.
> The latter is tightly coupled to HugeTLB-specific state even though the
> underlying page-table remapping operates on one folio at a time.
> 
> To make these interfaces easier to maintain, the folio-based remapping
> mechanics first need a boundary that is independent of HugeTLB-specific
> state and raw address ranges. This will allow the mechanics to be moved
> into a common vmemmap optimization layer alongside the section-based
> interface.
> 
> This series establishes that boundary through three folio-oriented
> operations, each with a distinct role:
> 
>   - vmemmap_optimize_folio() optimizes the vmemmap backing of a folio;
>   - vmemmap_restore_folio() restores the vmemmap backing of a folio; and
>   - vmemmap_pteify_folio() converts the vmemmap backing of a folio to
>     PTE mappings.
> 
> Together, these operations encapsulate the address-range calculation and
> remapping mechanics for a folio. HugeTLB wrappers retain policy decisions
> such as eligibility, optimized state, batching and TLB flush handling.

Thanks, I've update mm.git's mm-unstable branch to this version.

> v4:
> - Rebase onto mm/mm-new at f735a2c21aa9
> - Split the HVO head-page allocation fix into a standalone prerequisite
>   and retain Yili Zhang as its author
> - Add __GFP_NOWARN and pass caller-selected GFP masks through the
>   generalized allocator and folio-oriented helpers
> - Propagate alloc_vmemmap_page_list() errors directly (suggested by Oscar
>   Salvador)
> - Remove the redundant order check from vmemmap_pteify_folio() (suggested
>   by Oscar Salvador)
> - Collect Reviewed-by tags from Oscar Salvador and Mike Rapoport
> - Collect Tested-by from Andrew Morton

Here's how v4 altered mm.git:


 mm/hugetlb_vmemmap.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

--- a/mm/hugetlb_vmemmap.c~b
+++ a/mm/hugetlb_vmemmap.c
@@ -198,13 +198,13 @@ static void free_vmemmap_page_list(struc
 }
 
 static int alloc_vmemmap_page_list(struct list_head *head,
-		unsigned int nr_pages, int nid)
+		unsigned int nr_pages, int nid, gfp_t gfp_mask)
 {
-	LIST_HEAD(new_pages);
 	struct page *page, *next;
+	LIST_HEAD(new_pages);
 
 	for (unsigned int i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
+		page = alloc_pages_node(nid, gfp_mask | __GFP_RETRY_MAYFAIL, 0);
 		if (!page)
 			goto free_pages;
 		list_add(&page->lru, &new_pages);
@@ -312,14 +312,11 @@ static inline int vmemmap_restore_range(
  */
 static int vmemmap_pteify_folio(const struct folio *folio, unsigned long flags)
 {
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
 	struct vmemmap_remap_walk walk = {
 		.flags		= flags,
 	};
-	unsigned long start = (unsigned long)folio_page(folio, 0);
-	unsigned long end = start + folio_vmemmap_size(folio);
-
-	if (!vmemmap_optimizable_order(folio_order(folio)))
-		return -EOPNOTSUPP;
 
 	return vmemmap_remap_range(start, end, &walk);
 }
@@ -341,9 +338,10 @@ static int vmemmap_pteify_folio(const st
 static int vmemmap_optimize_folio(const struct folio *folio,
 		struct list_head *vmemmap_pages, unsigned long flags)
 {
-	int ret, nid = folio_nid(folio);
 	unsigned long start = (unsigned long)folio_page(folio, 0);
 	unsigned long end = start + folio_vmemmap_size(folio);
+	gfp_t gfp_mask = GFP_KERNEL | __GFP_NOWARN;
+	int ret, nid = folio_nid(folio);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_pages	= vmemmap_pages,
@@ -355,8 +353,10 @@ static int vmemmap_optimize_folio(const
 	if (!vmemmap_optimizable_order(folio_order(folio)))
 		return -EOPNOTSUPP;
 
-	if (alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES, nid))
-		return -ENOMEM;
+	ret = alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES,
+				      nid, gfp_mask);
+	if (ret)
+		return ret;
 
 	ret = vmemmap_remap_range(start, end, &walk);
 	if (!ret || !walk.nr_walked)
@@ -381,14 +381,16 @@ static int vmemmap_optimize_folio(const
  */
 static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 {
-	LIST_HEAD(vmemmap_pages);
-	int nid = folio_nid(folio);
 	unsigned long start = (unsigned long)folio_page(folio, 0);
 	unsigned long end = start + folio_vmemmap_size(folio);
+	int ret, nid = folio_nid(folio);
+	LIST_HEAD(vmemmap_pages);
 
 	start += VMEMMAP_OPTIMIZATION_SIZE;
-	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
-		return -ENOMEM;
+	ret = alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE,
+				      nid, GFP_KERNEL);
+	if (ret)
+		return ret;
 
 	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
 }
_



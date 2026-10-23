Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A00E8606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 03:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=owwUz7Ao
Received: by kanga.kvack.org (Postfix)
	id BBA436B0ADB; Thu, 22 Oct 2026 23:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6AA66B0ADC; Thu, 22 Oct 2026 23:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59F76B0ADD; Thu, 22 Oct 2026 23:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 779756B0ADB
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:47:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1094514022B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:47:06 +0000 (UTC)
X-FDA: 85352505252.24.4749FD1
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id E0554A0005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 03:47:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=owwUz7Ao;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792727224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VNVf0/RTjTbRf57wl1w88rYS317KM33ofoAQG+5nfI=;
	b=0JXXVebqVXy/so4FFgbh88YkwsI+JHKWaMXPPpd35M/0yMa5hPMQUehRvepc2gpK5c3nSR
	7aILQ+m1MsP6nxf9qM6evwphq0QUjM474NvhANPItKPtUiskb9qvu9FHTCNvbrnp99xzFv
	w3nxx1KdWiqnA9FN1TNyigR5M96JP5U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=owwUz7Ao;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792727224;
	b=NPxHuhQn2FQFYIGjJy0aNiNoB74FKb4yuu346rAwy6u8e3G9iB7u9Td1zt0j9+d3nL1dNy
	QeiCHwasTDBFi9ZUiiERuLt3AwIHiM5NKyGxbbdHaJoN/2YHdcxvb+zb6zBIEJXdWCgVL6
	BCz6iriJL0POsyqBV6hCh6WKFbJjnBs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L+H22LxR/S7kNv+P15UOky1GL22rLifgQhK5zAHtVzg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792727222; v=1; x=1793332022;
 b=owwUz7Aox2bPMrctPPRlHZ2j1tPpyK6dWV4mMLTJepn8eVqJOoQhCTdENneeDNAR+fWlfwlv
 Wx0Zt9Nd6dczEbVXud+rFJhiGtBJ7KtfecojapI8sCCq6KPW0oxUNtdvrj3KaR5dijDVdXaS9Yv
 o736bXbls/Y7XgQt/YEnmbLM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 315b90f35bda0009;
	Fri, 23 Oct 2026 03:47:01 +0000
X-Mizu-Trace-ID: 315b90f35bda0009
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] mm: hugetlb_vmemmap: make vmemmap restoration folio-oriented
Date: Fri, 23 Oct 2026 11:46:55 +0800
Message-ID: <20261023034655.37422-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-9-songmuchun@bytedance.com>
References: <20261020115824.823278-9-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0554A0005
X-Stat-Signature: qhk7a35pf6xnz66t7h48tpp7auht9556
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792727223-792024
X-HE-Meta: U2FsdGVkX1+owRNl8mNPFqGQxZK6gJKAPv5Hb86ybkbpDsbgAtqbk51FZNWtQ9OuRWp/8+s0TVzTWZOKecjI7x1GuKgBnPXJUlKT8XAg3Tol7SNbxJEdzTTHFMBd0GjJhUH/gQkcZvIFlzxrwOudVg2mt0S9qzakVTK4MmvT0j7GPw5JGbx0mj2XyGvwIXPRrwJekOq8ImURlJ8g1Lolwb2YwBliptfOXM4oFPPQvZtF3m3QpB6rwt4ADmIV6/rHuIyclw6HYZit4rJhR/foE4c5cFcJOzBTX1U8X6W4BafcVsUcVPm2B09l9eZW5+MVxRrdO4QBYb3kthQBltQJNTioxZ51tqXkUIKrc/2s+kTNAly6WRWqFXLmh9tdtc/e40RnH0QrO86aphnYbAvYMC3EXNDhQYJcuex2LMbZUpxhl5tcZpJ90x58Oem+k1FxEEMDEeIXBBwHo+Hb1y/dJfD51F38oqarQjlmwgfVBrPpCthHbQ5ElwQpe8Q7hC7+dgKvT+BiFNskqPtuYA1K3KyTwcIJAg+YKRdLF7VSuVHLUbybegIq8Nn2Z4plcVRDzoHh1Esj5yVzwT7Nz2kaEoPDkMaUEdEUS72/8o5gCjp0iOE+HuYflifDkWTzZvWoiotA8eDTBmEHiXYohOmXH9lyAZ2ufjeNvEzSHlEHeuuBrty0oDsj/7qymdHIuyFTHy3xcdezU7rE1xkEIBTCKk7Q5IgJqOw5nKi4EH3eAXUHV95rvJsAQpu/9jk9ogTEehPFN4Ugy1yAY9Bf78sDZIiUK1WmVVSuoOHCLcFy7WjlzK2csRR5scjGlkbFlhrryxN8zdCWePKX3VlgXHU/NhPEJQBdB1s8j3ShENhIWREm0QJGBJ+ueXja9fLwHUNIB9AE92ASz42VaHhFVS+yZfVFH+D0DJuBTeeCyxiFgCwSYq+RC+Qw4tpR348FY4/zVZ3A239O5+1upPsxkLV
 +YsuanMK
 wfTaf/5NUiOT9pAG5FsyTNpKU+10JYZh0JVeSJE7j4+oHINhpFnM9PN1PunvzQpQlA/pVn8Zlv5xdRcxZ7q+NunUjtzlE+jD4oGgkXqJGzHZQbyICqG5JFCQWnSt0I7zH1+3P6jSldbSb5lsn9UjBryTsAN25q0AltqY/nDGvYtC5aHx3TBcokijdFa8rXp2nHy/iSxs/KtbTIXPNtvNouIi2qSIIAFKRCbyfVHG4tP2EYhJqbVTjVat58dLPFKgKyLHU6JwbW2iy7whpCz703DSyvyNnPO6ezj6lQ73+2Y5DOd28gG3ktZ4qw8xeLo+qRVR3x1PM+LB1KlaW1ruzyORoDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:22PM +0800, Muchun Song wrote:
>Like optimization, vmemmap restoration operates on one folio at a time,
>but the current interface exposes a raw address range and requires the
>HugeTLB caller to prepare part of the operation.  This splits the common
>mechanism across layers and obscures its natural unit of work.
>
>Make the folio the unit of vmemmap restoration and move the common
>mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
>eligibility and state in the caller and gives both directions of HVO
>consistent folio-level interfaces.
>
>No functional change intended.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---
> mm/hugetlb_vmemmap.c | 37 +++++++++++++------------------------
> 1 file changed, 13 insertions(+), 24 deletions(-)
>
>diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>index b76203e34881..97748a9cefe2 100644
>--- a/mm/hugetlb_vmemmap.c
>+++ b/mm/hugetlb_vmemmap.c
>@@ -360,28 +360,29 @@ static int vmemmap_optimize_folio(const struct folio *folio,
> }
> 
> /**
>- * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
>- *			 to the page which is from the @vmemmap_pages
>- *			 respectively.
>- * @start:	start address of the vmemmap virtual address range that we want
>- *		to remap.
>- * @end:	end address of the vmemmap virtual address range that we want to
>- *		remap.
>- * @flags:	modifications to vmemmap_remap_walk flags
>+ * vmemmap_restore_folio - restore the vmemmap backing of a folio
>+ * @folio:	folio whose vmemmap pages should be restored.
>+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
>+ *
>+ * Remap @folio's vmemmap so optimizable entries are restored from the shared
>+ * tail page back to distinct backing pages allocated for @folio, while
>+ * non-optimizable entries remain unchanged.
>  *
>  * Return: %0 on success, negative error code otherwise.
>  */
>-static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
>-			       unsigned long flags)
>+static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
> {
> 	LIST_HEAD(vmemmap_pages);
>-	int nid = page_to_nid((struct page *)start);
>+	int nid = folio_nid(folio);
>+	unsigned long start = (unsigned long)folio_page(folio, 0);
>+	unsigned long end = start + folio_vmemmap_size(folio);
> 	struct vmemmap_remap_walk walk = {
> 		.remap_pte	= vmemmap_restore_pte,
> 		.vmemmap_pages	= &vmemmap_pages,
> 		.flags		= flags,
> 	};
> 
>+	start += VMEMMAP_OPTIMIZATION_SIZE;
> 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
> 		return -ENOMEM;
> 
>@@ -399,7 +400,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
> 					   struct folio *folio, unsigned long flags)
> {
> 	int ret;
>-	unsigned long vmemmap_start, vmemmap_end;
> 
> 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
> 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
>@@ -407,18 +407,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
> 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
> 		return 0;
> 
>-	vmemmap_start	= (unsigned long)&folio->page;
>-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
>-
>-	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
>-
>-	/*
>-	 * The pages which the vmemmap virtual address range [@vmemmap_start,
>-	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
>-	 * When a HugeTLB page is freed to the buddy allocator, previously
>-	 * discarded vmemmap pages must be allocated and remapping.
>-	 */
>-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
>+	ret = vmemmap_restore_folio(folio, flags);

Nit: we don't use h in __hugetlb_vmemmap_restore_folio() anymore. Could
we drop it from that helper while at it?

Otherwise, LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F084C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848196B0088; Wed, 23 Sep 2026 18:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F926B008C; Wed, 23 Sep 2026 18:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75DD76B0092; Wed, 23 Sep 2026 18:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0736B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:32:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C58D4C0169
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:32:07 +0000 (UTC)
X-FDA: 85246476294.21.FA05CDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 07F4C100007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:32:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X2mNFTAy;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790202726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bxf0qfMfsaxisq5UZ3SzuyCSxoFCjpdy7dNmDjiJt2E=;
	b=aWT8Dpv8TkcMXqRHcikerhJpg7eYd9bBUZlKMac5i5rhfQ3V4qAs8fojHeQ+SsuQ7/AWW2
	t7eaEK9cNeY+8jRQyIHEMDd48iyTAqynRLnFVl0enBP7r5PrQxVwGmcR7YNXSkrp1TqOfH
	F6s8NlhRYbBSzL52qeROJxZh1vS0QHM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790202726;
	b=JDJ70mzvonIft8DmX6+ETz6zXjKyzR5va5w6io7r0SQWrJ4Rgq4YwJFg9Ssr7wjTGfNLKM
	BN+0Phfr0ys6nKavHKvhkzrB1wmJamB4vDIjxuxPzuKUYFgOGEz28n5sLom8FRGt9tAqLT
	QBh3CaHICKqSvva89rcXycx9wqrh5Mw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X2mNFTAy;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E3CB60008;
	Wed, 23 Sep 2026 22:32:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664CA1F00893;
	Wed, 23 Sep 2026 22:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202725;
	bh=Bxf0qfMfsaxisq5UZ3SzuyCSxoFCjpdy7dNmDjiJt2E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X2mNFTAynqJKc99C9i0zaKuzSO/xxQaKys32ItvkJWs1xUAMPG9UNc9soM7xXdidl
	 kiF+VEWg84idMei3OgrybKgm3bRYkchCMj1TFALO/5Z/Fp9E+ueLdy+Kh7DA4BRpxG
	 hEGlP2s/v99pG2eoDmhdkxdaixuUHbsPyFjEGZFo=
Date: Wed, 23 Sep 2026 15:32:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance
 Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li
 <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Yeoreum Yun
 <yeoreum.yun@arm.com>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Shivam
 Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v6 00/17] mm/huge_memory: clean up and decouple the anon
 and file split helpers
Message-Id: <20260923153204.4fbc4a07679561feb4b665be@linux-foundation.org>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: mzgqgkpbcqth6cn3mqn8oqwusp8itndy
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 07F4C100007
X-HE-Tag: 1790202725-407295
X-HE-Meta: U2FsdGVkX18lSbH4oLOWXx+AUXtpGdjnDepuTczZnozKakwgqiAC8xSxsabn7dUCPtstRqcBh+d2QvUJk2QF5ZQ1ebYKzy2P42Z2jpjIcZVdayH85fe7tiu2D6Z44ZpmeKi/jaJpTIdvzygAfti/jgce8KSKv1gfkz9j9bZx6PbK2B9j3yZSYr2jI8irHeNAbddnONIO2VtE6hGZXXT/itPjU7tXFwzST6Rf5Xsen0AgWTxWwtE3u00hSOLpXxu8+Ef+aYByfQmEJITdIiY2Z5+wY/lE1q4D1XO1/VduDfgXSdfEKOf0uQb9GzUbaTbWkA5nu8oTNpGDLWF3EtKFEZvl8etEahhtHFx4IqPeZX9sZWB+f65V+EeqQd7SkUuPOa+oQA0lgXZpkVLpZ6t1Fs8KIlcgu1lk1FOntUhbBpqpxtD7qjnbvUQMfCQsfqZ67hLEcv0JzvKIIyMRFskn/v0q2GdP7YKv/Zf5YeaNstm4NgPP91oBlj9utrvRSzJ9f0RydWClBgspuW/Z6EhBFR1HRc02GIlyHxISTF08OWNiCKUZZsFfES3qMRhZuwPENxWeW+PJmv1lzH71OVT7SS0QQqFG8fAkH0sJFOcjEDrXZ//DBE/a7mF2EquRsqxFd1+Rx3p2cHublYU/za3NQtCoBFCUIRSmmcgWLYLUhTu3LwkCVYAkE+AvG3JTFfD6rhi3DYIgN16n9m0fKCLstLMg8YQzGx5qGNKx8cZ6kXVIGlvLKy0FZX1mgFEbqzvmVxQlnE7kBbQB/a4hozf7dd9hQJe/hwibK6waEbgmHFP7zUqsj4+CI3VQbeCtlVv2t2RNBA7GNytBnwQk4KueFbFkkOEjxQXqVwbsSKLgmf8oIfcj63lv0DePD3hHcQjAP47N8Gbfn3n4i1z49OR5V/eD1ET09zxP2hOoaWIyiLqvlcxNwmwRhh28Xa+ya7/SiMMhWPbsWtPL2dYC3sy
 nvbrBTDb
 dSEKUsBSQJnLflLU+O1unilQ4X0NeIBzeL52q7WuxtO/w5mUrWE0GMjioitk6Tap+8+Nn1uZaKFx8zpm8ekcq/l3teVQFwhEnRCxL69wIJhBnjPLCmF/sRXbW/4mkp0zeK4AhCcAg/M/SZBVIBSv/Uj8V4aoSDgGBnJL1LV+uTHODC657v2YE4ynpybk073XlK7zR9u9bH3eJpT4S1qQuKAVYWSHw63BDDf7qFGRmF9D8Q7d9gY5Hc+87fy4K0qIDi7WMdBwVDPhjBxd7/8n0XeRbpfpw9sAFfPxPFaQF1DHYA/ZP6aQGU4iJ0G+vi1Pgk5eWRxHcedGB6+elFvUommfQellML2XbvxKP6D64p5WXX67NTJxqeWJtLQ6M8y2yivqe11hlofhX9ZsKzYfISsJFg9FSkJQH7vnrLIZwRY7+Xer9r0ZMpzkAS2mGnH9R9ovkz08uahoSSkTwpbdb9TiTeCTYGVUIymKTHCJtfS6ZubLgejIULSBHKrTwYhe2lEiNbc9Tur2lZ75q9WXUgRgF06B1cRLYRt3+WQk6sFRe0qMeidNpUeSDMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 23:32:31 +0200 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> The folio split path handles anon, page cache and swap cache folios in
> one routine.  That mixing is what makes the swap cache split
> restrictions hard to lift and to review. We now support uniform split to
> order-0 only, and no mappingless swap cache folios. And it has left a fair
> number of dead or redundant checks behind.
> 
> This series prepares for lifting those restrictions by cleaning up the
> code first: split the routine into an anon and a file helper, and keep
> all swap cache handling in the anon helper.  The file helper never sees
> a swap cache folio, folio_check_splittable() rejects them up front.
> 
> Apart from two bug fixes (patch 1 and 2) and a slight adjustment of anon
> splitting (patch 12), this is a pure cleanup.

Thanks, I've updated mm.git's mm-unstable branch to this version.

> Changes in v6:
> - Comments updated and make a few variables const as suggested by
>   [David Hildenbrand]
> - Link to v5: https://patch.msgid.link/20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com

Here's how v6 altered mm.git:


 mm/huge_memory.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~b
+++ a/mm/huge_memory.c
@@ -3538,6 +3538,11 @@ void vma_adjust_trans_huge(struct vm_are
 		split_huge_pmd_if_needed(next, end);
 }
 
+/*
+ * A return value of 0 does not mean that unmapping succeeded. It might
+ * still have failed, but remap_anon_folio() must be called afterwards,
+ * for anon folios.
+ */
 static int unmap_folio(struct folio *folio)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
@@ -3555,7 +3560,6 @@ static int unmap_folio(struct folio *fol
 	/*
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
-	 * If that is ever changed (perhaps for mlock), update remap_anon_folio().
 	 */
 	if (folio_test_anon(folio))
 		try_to_migrate(folio, ttu_flags);
@@ -4025,7 +4029,7 @@ static int __folio_freeze_split_anon(str
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
-	int old_order = folio_order(folio);
+	const int old_order = folio_order(folio);
 	struct folio *new_folio, *next;
 	struct anon_vma *anon_vma = NULL;
 	enum ttu_flags ttu_flags = 0;
@@ -4048,8 +4052,7 @@ static int __folio_freeze_split_anon(str
 	 * the reference nor the lock. Anything else needs a reference
 	 * first and folio_ref_freeze() below catches it.
 	 *
-	 * Note a swapped-out THP counts as unmapped here as swap PTEs do
-	 * not contribute mapcount, and they are splittable.
+	 * Note that entirely swapped-out THPs are unmapped but can be split.
 	 */
 	if (folio_mapped(folio)) {
 		anon_vma = folio_get_anon_vma(folio);
@@ -4133,10 +4136,10 @@ static int __folio_freeze_split_file(str
 		unsigned int new_order, struct page *split_at,
 		struct list_head *list, enum split_type split_type)
 {
+	const long old_nr_pages = folio_nr_pages(folio);
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
-	long old_nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg, *old_memcg;
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
@@ -4166,7 +4169,7 @@ static int __folio_freeze_split_file(str
 	mapping_set_update(&xas, mapping);
 
 	if (split_type == SPLIT_TYPE_UNIFORM) {
-		int old_order = folio_order(folio);
+		const int old_order = folio_order(folio);
 
 		xas_set_order(&xas, folio->index, new_order);
 		xas_split_alloc(&xas, folio, old_order, gfp);
@@ -4269,10 +4272,6 @@ static int __folio_freeze_split_file(str
 	folio_ref_unfreeze(folio, folio_nr_pages(folio) + 1);
 	lruvec_unlock(lruvec);
 fail:
-	/*
-	 * If we want to use try_to_migrate() on file in unmap_folio,
-	 * remember to add remap_anon_folio() and adapt it.
-	 */
 	xas_unlock_irq(&xas);
 fail_mmap_unlock:
 	if (nr_shmem_dropped)
_



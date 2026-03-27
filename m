Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E562510BA420
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066726B00AC; Thu, 26 Mar 2026 22:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017766B00B0; Thu, 26 Mar 2026 22:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EF26B00B1; Thu, 26 Mar 2026 22:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1CEA6B00AC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:58:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FBFA1A0F73
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:58:20 +0000 (UTC)
X-FDA: 84590334360.24.B073D47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9F8091C0010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:58:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="j/Vo3ys2";
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="j/Vo3ys2";
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774580298; a=rsa-sha256;
	cv=none;
	b=4Pf7Fks+3WUFcsU1+rMui9EIZtwKLIpNHAmKkrE0DXhXVXfhuy8+FkP8k0GRFd8U9bSVGV
	WG2snKfdSeXwFd8lVc0itMR1JGhHc1eVxruzegmBMNQ7/WbNixbMSruUNrtu1W3XJSeE+W
	U6cGsX1ML34yiX+uWCRbH0YxfYfuDHA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774580298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k2CzznVn4CkfBZu0OBgZKKeMtJqZv0p/LPx59pidWQs=;
	b=8nXmaUy1ZjrrQ61RVaN1OmCa+T/TmBSnVdVvr8I4ykSS9A0hlvHyWB0Ehwfraxdi9laanM
	7q9u92069mmFoWP2/2tbQf0cW+DnkgmyDWVVcezcLRwnuIDa5S6vCX4nancTkcyR940ivv
	JkWQnOQxjA+kwbOEHAl5we/cP0uDLTQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A14E4029E;
	Fri, 27 Mar 2026 02:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30C0C116C6;
	Fri, 27 Mar 2026 02:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774580297;
	bh=ZpNIEcUffsRq1bL9mSuUjHcLakM3o1+hxG4crvmOh68=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=j/Vo3ys2nroHY54igrcUEcoYgsxYsT3vxeiCyy/aOfXJa1yRgskAMVRG73QbfSFFf
	 JM5nLEh474y06NHY6UPYTi/omXySC/awZK0BmobSkQgM8axUdCr4bD26qAKb/5n4XZ
	 I6MCP8QNv6Ig+O/3PIioVHSyf2KK920H2p86r6uA=
Date: Thu, 26 Mar 2026 19:58:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Sidhartha Kumar
 <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 00/15] mm: memory hot(un)plug and SPARSEMEM cleanups
Message-Id: <20260326195816.60110f50cd464d0076aad0ff@linux-foundation.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F8091C0010
X-Stat-Signature: wfwpa1xt1n3wuwtiaf7qebsiyoz9zw4y
X-Rspam-User: 
X-HE-Tag: 1774580298-607947
X-HE-Meta: U2FsdGVkX18PCnYI+d5mSLsLRmk+71Wu043lYnzJ37Kr4V3T7kkYevQxmhYYJw+u3QcK18rGBCvpxcGFEjsq4Uh7RiymCGrU6TXWNdt0JKeadO1eXjNl9TUmwhgjTzbULVFrlVRU15XkYN/MB47B8sWpGEFmLi+AhiFOmABdqztpv85GSLZgQB4S90dGeEXch9GTx7PgotTIkFZv7wP4iZs08dEY5hc8vKI1sfxU09nhqCJNyrzmQNgLLTADLi/UwqK2R76yXVTwx7+HgHN8pl0CcPQBScc44j9n/wlYSydlVOeGPh4X3kvCK2YV4H0kihefYueNw828AAgQAt3GYr4EhFxXCCj6UXB+o0EONKCWvOp/Zm3dar88un3GpcPno1KwUFd9YplkhyhYJwZxwYv2qwGaUAYhxa7L4UcXrwEocGiSYJTQOeDxcZyV50kIEqLDMV63EVvFQz8sesXeWwzcpvNtuS6G+O4nq44bZ7nVhJh/xsf+IcQIPyX0Oxj3ivw+qnDQnORqVJ8LMq5f1aaKdZy5FHgqLBvrJOe8aD1OGvj4/rcq0hKBLTT99te/31KCzar+TCuazZ4cAUbVmfAqWj9Ekul1ew37GCMaqV3CFpv2kEJFBwHgg3dpBudFFKC18+/wgZ84V3kcaDXzrxO3206VrUL77sknHelXEvg1XHJ16cbSU9g1kdXBppkYTQbeUqc3KJiFEFwvz+VAjG2IXbGA1LWZOmfIGtyMirJNUcNdl7dn7BoAf/vh1yklgMdyfYDAQq5B/Bo/wkvQk2u2LMpDVBZPVY9G2VS5/qGD0xW+tSOIHr2CN8QG7Ff2n9OCGGw+I+u2R2Zr55qPQbZXyfeMwwrhybxM8htN1phg/wmqNIWe/K671bOmFbNEp0B3CBBazmD5WGfIDMy87elK+iMTA3R0kAw6k/7JJv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 23:13:32 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Some cleanups around memory hot(un)plug and SPARSEMEM. In essence,
> we can limit CONFIG_MEMORY_HOTPLUG to CONFIG_SPARSEMEM_VMEMMAP,
> remove some dead code, and move all the hotplug bits over to
> mm/sparse-vmemmap.c.
> 
> Some further/related cleanups around other unnecessary code
> (memory hole handling and complicated usemap allocation).

Sorry, for some (age-related) reason I've been sitting on v1 for nearly
a week.

Thanks, I've updated mm-unstable to this version.

Lorenzo, I've assumed that your conditional R-b on [01/15] is now
unconditional.

> v1 -> v2:
> * Added "mm/memory_hotplug: fix possible race in scan_movable_pages()"
> * Update the comment above section_deactivate()
> * Reordered the flags in sparse_init_one_section()
> * Patch description improvements

Here's how v2 altered mm.git:


 mm/internal.h       |    2 +-
 mm/memory_hotplug.c |   11 ++++++++---
 mm/sparse-vmemmap.c |    8 ++------
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/mm/internal.h~b
+++ a/mm/internal.h
@@ -985,7 +985,7 @@ static inline void sparse_init_one_secti
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
 	ms->section_mem_map |= coded_mem_map;
-	ms->section_mem_map |= SECTION_HAS_MEM_MAP | flags;
+	ms->section_mem_map |= flags | SECTION_HAS_MEM_MAP;
 	ms->usage = usage;
 }
 
--- a/mm/memory_hotplug.c~b
+++ a/mm/memory_hotplug.c
@@ -1738,6 +1738,7 @@ static int scan_movable_pages(unsigned l
 	unsigned long pfn;
 
 	for (pfn = start; pfn < end; pfn++) {
+		unsigned long nr_pages;
 		struct page *page;
 		struct folio *folio;
 
@@ -1754,9 +1755,9 @@ static int scan_movable_pages(unsigned l
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
 
-		if (!PageHuge(page))
-			continue;
 		folio = page_folio(page);
+		if (!folio_test_hugetlb(folio))
+			continue;
 		/*
 		 * This test is racy as we hold no reference or lock.  The
 		 * hugetlb page could have been free'ed and head is no longer
@@ -1766,7 +1767,11 @@ static int scan_movable_pages(unsigned l
 		 */
 		if (folio_test_hugetlb_migratable(folio))
 			goto found;
-		pfn |= folio_nr_pages(folio) - 1;
+		nr_pages = folio_nr_pages(folio);
+		if (unlikely(nr_pages < 1 || nr_pages > MAX_FOLIO_NR_PAGES ||
+			     !is_power_of_2(nr_pages)))
+			continue;
+		pfn |= nr_pages - 1;
 	}
 	return -ENOENT;
 found:
--- a/mm/sparse-vmemmap.c~b
+++ a/mm/sparse-vmemmap.c
@@ -725,11 +725,9 @@ static int fill_subsection_map(unsigned
 }
 
 /*
- * To deactivate a memory region, there are 3 cases to handle across
- * two configurations (SPARSEMEM_VMEMMAP={y,n}):
+ * To deactivate a memory region, there are 3 cases to handle:
  *
- * 1. deactivation of a partial hot-added section (only possible in
- *    the SPARSEMEM_VMEMMAP=y case).
+ * 1. deactivation of a partial hot-added section:
  *      a) section was present at memory init.
  *      b) section was hot-added post memory init.
  * 2. deactivation of a complete hot-added section.
@@ -737,8 +735,6 @@ static int fill_subsection_map(unsigned
  *
  * For 1, when subsection_map does not empty we will not be freeing the
  * usage map, but still need to free the vmemmap range.
- *
- * For 2 and 3, the SPARSEMEM_VMEMMAP={y,n} cases are unified
  */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap)
_



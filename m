Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C696FED3F8
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1373C6B008A; Fri, 24 Apr 2026 14:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0356B0092; Fri, 24 Apr 2026 14:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D236B0093; Fri, 24 Apr 2026 14:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D1EAA6B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:41:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95FB51402BB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:41:24 +0000 (UTC)
X-FDA: 84694317288.01.FCBF408
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 260E14000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:41:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FFGMzRxr;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777056083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jMwEKotAvq2OL4OEp6t+lhTaMljgnAVvfhivquqvtU=;
	b=xc/z9xnnpUjr/0X5/byURlHVOC8WJTPWvtTsEKVRXXHRfZXU8KgemTIOaVjbuo9rUXfDMK
	+1UyHEQtXowCghZS6rl5GJdFns6f+/zWDkv5pwgGYMYU5FoAYj0OfqAB3gHjOeXXctDPz+
	tRfZWPLdxAIOF1oyjFvhLUynAONisQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777056083; a=rsa-sha256;
	cv=none;
	b=LKJv+xCx8gw5/fM9P+lkWFqgy/k3xb+URKX7k2FNCGRtkyZMMqLFLIjtm+ti2IHn1zTD5R
	oiEdQ4KD2LMmvzSKpX/nkpZ4kWKyn1pV5OQSJnypp2ixvoff38Y0Qx1g/VBIKncv6sTa7a
	N8FzQ4R/wLIoKUuLCuEdtwKPvFHeLg0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FFGMzRxr;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0jMwEKotAvq2OL4OEp6t+lhTaMljgnAVvfhivquqvtU=; b=FFGMzRxrQI3FU/6XH/nP3cw2bz
	KTetZpzPQ/VUg6/QrjDvqOe4Kl13/C7miXnNFgHRjwkpTrCVViYOVdoKuZBRwmZ79YPuMUmz/XTU4
	hyPOfm9emkeL8t66v2Lm5nrkl1xcHWvytvpkul29rd6HDaMa2wfaumz4p2fAV6kl2shEqmx8lHiG7
	3yqDwh4QyR9k+SJ8mXKdWJ2/PYlkGtdcVclNsYhDUBPetd7muaRzLy2BtB0d9RhpKVsM5RTFS8e72
	AbvElS65WHKkUDrBlyuJAuRDP4OZ0C72Xpve6Q9/yKqPVeDZFjqQ/v4dJEcI/iADLkpRqbxDYMsPy
	nUzhEk/w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wGLSZ-0000000FeLx-2qnt;
	Fri, 24 Apr 2026 18:41:03 +0000
Date: Fri, 24 Apr 2026 19:41:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <aeu5P1bZW3yEH54t@casper.infradead.org>
References: <cover.1776808209.git.mst@redhat.com>
 <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 260E14000B
X-Stat-Signature: d76e1xpxy4ifemhw64k4dfypoyxrwr51
X-Rspam-User: 
X-HE-Tag: 1777056081-179181
X-HE-Meta: U2FsdGVkX1/BRolzy3RHewTqbcsij3d0L69wPCOrQsznVCowZye60olIyynkZr41nh0eW7k90iUuTdHuhl7ijUNkPlbExXfZUH0yv2GSFpOyI8QzuUqufKtfDwrwpZswSviCag8P3F4ltgjnwCL3rUSKwWc3KjIFnGsoY0uHEwyWlj5Lz91YcebgXKLQecOJWdgBKf/A8alKKSJfwoiv14FlehyuUNc5JCo0yg9F4A2LwTDOi8BuaUnvNOPjl5uCmNGBNnQRwvvpubJbUE7jCPVwjp/Cs5dRn0InFAlBGGI308wb7IuCl2v5FHjpwo+eRBLjbe9G0jpbMKWvzdVcyZp7Ja6NfFwFrxP26heof6pnOV4jPSUXbRrVKlaF63JQl1C/CXSAA1+kjrWqQPv7IyTriFNqXqN9TMwqB5buFHcLrssFjQiusqVvmF+ZfVsFjrp02wvE5Hcd8+LDlA9NMzxilrqEPdkrigfifnLK1zIf5zZyW7HZTOmtdExnn8j62CRLNs4X/rKG7h3i45pWytabvrANTsitjQzX6UQJ0uvqInCCLp00yiP7en1OK4Tz0WCZ2NsubE3j6xuzwPDRi5nxfzQtG8NReqvB69vOnMEiNQFVWiVAhJFGHLfi1m35HK1M+mX8Ak+rOV3hs6KGF2g0KDsGF/ZYm49aCPcqB3SYPxrXAkVtwdKw6W0Z20CiCbidOaQFGJGxr85tWKKGh9EONBwZHyNNAxQQLa72gYJQSSTGlZ28DbIS4gyBf7OBHU1PGTrqDgw1iInR5I2xIICRWMMZ5HxoyR2CqUzpDBzydETcVIXycWuFvaV7waAfHfjhXQZN0zpza/gQ2ZeRrdoiUOi8jbMvth4ohJWL9adqCOvt5KkROe0XFVlHr7M2qHugC7LfKdXtAkpmSFemqlNwHAGFTWiksoPfn3VYhjIadvq1POG2D+PTLqBxdicvPK5flIVuW7uMm9bargn
 KQp9EsBd
 DUShOmOyBrLcWVPK64CQnS8WJPqd2TusCTf6sIpu3tXdfYtEy1C9j0aY0xebKrAiki38fIaolzFi+NYiBvgA/lplwbeSFxXy8gvFd4PfkPbpS26HyqvkS9VlCdK9VmXZyMgLEfufdcqyVTO1S67p1R399092WO5BT1IX876d8GcbKhf3puIcpOvVtqoxGptwgagJRzWxFbXIglLhKxj4N3xeAmVvxz4JH0hnn/4Kq6XB5VQvB0AdcQbJQOEnHC5j+21x7PyX3P2ZBNTZGUJydQzWWz9YRBnPhoHjDksDuvcrNuEyrZSvnQKnoNvNudtRUdeHI7QqA65DXfD6jR8+kIHkGIkgs/SGYpTdn9yBoM0lkPOxUIb4iKZtpGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 06:01:10PM -0400, Michael S. Tsirkin wrote:
> Thread a user virtual address from vma_alloc_folio() down through
> the page allocator to post_alloc_hook().  This is plumbing preparation
> for a subsequent patch that will use user_addr to call folio_zero_user()
> for cache-friendly zeroing of user pages.
> 
> The user_addr is stored in struct alloc_context and flows through:
>   vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
>   __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
>   post_alloc_hook

I don't like this.  I think we should instead lift the zeroing from
post_alloc_hook() to the callers of __alloc_frozen_pages().

I don't understand why you want to remove the double-zeroing of memory
when the user has asked for zero_on_alloc.  They asked for stupid things,
let them bear the cost.


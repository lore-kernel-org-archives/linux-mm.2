Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A94A60A2600
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wi3ycDQp
Received: by kanga.kvack.org (Postfix)
	id 331A96B07CB; Tue, 27 Oct 2026 11:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307FE6B07CD; Tue, 27 Oct 2026 11:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F81C6B07CE; Tue, 27 Oct 2026 11:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDC8D6B07CB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:46:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 521FDC0A3E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:44 +0000 (UTC)
X-FDA: 85368833928.09.F3983D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E39320011
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wi3ycDQp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZkvBXJ1M4cprmGAnU9nv4mrWfliu5LNDxbLf5XaiBg=;
	b=MEwtW8OGoZp0KXSQ/gkTx9yda/vWac/ebf86AH0WROycQFyhEta4GR8+6MZdeqIen2xnxn
	Yim8IowBexr3dTG/l7spO6L5v0guKpkz98Jg2dAXAL8YaWe+wllGWnzsu9OJhgJdxe3USZ
	pEHrZe3vPpp8RwkGo+z7kjwg8S62Rus=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wi3ycDQp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116002;
	b=6Plwzj1NL5njamJmVx6YhEA/IX+zwNGSGQi3yB0GhEYxFCv6xqtfn6rnhs0+V5H1a1ZoHV
	8A3hB9rrohLDcGttXkriAn6DDAKS4XuBHQQeaTo0/YUQYmzjEOHkfdTtbEXaxjuL1ny7SY
	6n33+DZEJgwUk0+QXWnJmKfayHX1+GE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0D936022E;
	Tue, 27 Oct 2026 15:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17F91F01829;
	Tue, 27 Oct 2026 15:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793116001;
	bh=JZkvBXJ1M4cprmGAnU9nv4mrWfliu5LNDxbLf5XaiBg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Wi3ycDQpHF+2DIQxiDwQjdSsO80VWcpydnlA755H+EKJMGT8hFyb11qJN+Gseajqt
	 Byo+QhM5RwKb2KaoAkOnY8OD680CD011e5np2eh5OvSj9jNHK1VSl96bA92YWs81BZ
	 yX3UDHGZs7N7CIsp2y4BIuKhbks1JtLfBADzO6vesqXSur5M5wM3ZruF6VCFjA/T9s
	 mGBc39SYbWerm/Qh9VTg2baNXgVabajJy3pjqmbOJOLzT6yK5buRJ4WXMmUbWSOLi+
	 84B7Yp5bQkRwVMiqoZcMxHGwGPo8lfgIOsv6f/Koddk4FP7pNe1Pu1J2b9ZxMjMxIT
	 Z60vbzB3zih/A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 27 Oct 2026 16:46:28 +0100
Subject: [PATCH 2/9] mm/page_alloc: clear ->private of deferred free pages
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-2-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 8E39320011
X-Stat-Signature: qn815nj9iaorj8ydwuprgt67b7ps3njr
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116002-140049
X-HE-Meta: U2FsdGVkX1+pLlbHmMkCcs8ztuqX5L3m3jWC0KjTLzl9dwQm5FbcR3Mhvmpyx4tru2EbepjfxVc2dXhpqOP/jzCddMG9j5RrXeTAtgCOHwzSQ2MBRb1MQe+W7bo5W1WVa68xWb52EAhppthjaUu07GCXQWvrLTXL8zfR0TyH+yw+3i1hS6aTUc3rdogKEl8AXhzHOlbNTnnxQ/d24oqBYl1KHuZ6bZTD/lChQh342p4LWEhCeNtXl9GgKYz0SdD0PRVyPv6UP9l5mmj4Mylf+dSt35zKhd7T1E/4QLwFNH8F91GL1irD6MJSFIepLtrGjV5vI36sw5rdlFkirJmz8BOofD2z3KL2fUAwazdFBWI7M4iE4xDrkkbOVa1pOB+Ihl4X30YEwFSv0kb+DD95xh/Q4P3z9a/sKdEO0l2dE44lEQMeurXs0zYGzvi9RF1otq6R5YID+h4eWmbl9l+Us20bk/igKMlcy7xo0fmWZ71GHRsQXuFx86RNmyCJBAHuyyQFzgqbb6M6TLEgyaCloH0ImFYmzoeiqQwPAY8sqrR9nP5X37Tt+1fbJmQ4F5it5xLG+2FVJ0pnb4TgLhgi/wde/WqaU67SSiGswFxkNmtrga3mm9cLGgUeKuNp+7vBhCThBlvALKhSvPZsv8omw1U2zxLyiuZA0yfblQRci8JfduUC76BARCTA1Og9FxU+kADrNRYDbB7stX1587aYDijCnvSQw8lV3H0VYwn/aOQLEWdM7kouzwlxy6o0h9KaK8X2Cx9blUrYK1pg31o5pGmNpaIrzRGUBOQ+hTXgAwBNxamOp7oM5SNWAsk0xKdzu/47+hUjGma7vlDSCU90WB2/DYIIxCD9sB9U4coY9hllXKFjASpjo8GqNjC222U/2n6hGCtX7KVItDAn/1VBAB90RwE8J451EGLsKdmksL2tlkRVD1vuJC/aovLZbSsHH77iXPvib+YazESLBmf
 sEHXpNuv
 SmIqk7t1I2NbHK7R99VgZ3mdtTXgaMKiX2JbV9VRJm1dyy5OSWex/tV4Vz/TWxjM6mA3FHvO43UieBR+geVQsSC5XeSJXrXuHeAN9LiLBsmRjFHT9P8S4ewTItNhcjs17rYOcFKLl7Fx+pfSUv3xm7Dr0x22nXfEVqczPGDoSQeNu45FCLf8rFESCIaHqQmwTI/kXzK5IOE7ZtGYCKdOTa2ysfJVP7OMxkwuYj+bBcZCbT5awgXPYY31YFQoKuC21FJQdE/YxWvynDtDU8jbXi+8bt4UxQowRldKNGCCIAdBeTGECxC/5ysDS6F2UlYBbyAA0j5am2I7U2Pumb+XxgP64mGxpmIQyJhHh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

free_pages_nolock() and free_frozen_pages_nolock() put the page on
zone->trylock_free_pages if they get neither the pcp lock nor zone->lock.
add_page_to_zone_llist() keeps the order of the page in page->private.
The next free_one_page() which does get zone->lock passes these pages to
split_large_buddy() with ->private still set.

__free_one_page() writes ->private of the head of the resulting free page
only. If the deferred page is merged with its lower buddy, it becomes a
tail of that free page and keeps the order in ->private.

All other free pages which are not the head of a buddy have a ->private
of zero, and since commit 819bfbd47e49 ("mm/page_alloc: remove
set_page_private() in prep_compound_tail()") the allocator relies on it.
When the stale page is allocated again as a tail of a larger page:

 - prep_compound_tail() hits VM_WARN_ON_ONCE(tail->private);
 - with the page checks enabled, __free_pages_prepare() reports
   "BUG: Bad page state", "nonzero private", and leaks the whole page;
 - without them the value is seen by whoever uses that page next, e.g. as
   folio->private of a folio which is split off a large folio.

Only pages of an order above zero are affected. Those can be freed
through _nolock() by the stack depot (order 2) and by SLUB (a new slab
which cannot be added to the partial list by kmalloc_nolock()).

Clear ->private when the page is taken off the list.

Fixes: 8c57b687e833 ("mm, bpf: Introduce free_pages_nolock()")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee013db45ed1..9a4d3352c037 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1562,6 +1562,8 @@ static void free_one_page(struct zone *zone, struct page *page,
 		llist_for_each_entry_safe(p, tmp, llnode, pcp_llist) {
 			unsigned int p_order = p->private;
 
+			/* It may end up as a tail of the merged free page. */
+			p->private = 0;
 			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
 			__count_vm_events(PGFREE, 1 << p_order);
 		}

-- 
2.56.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA33E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D516D6B0096; Sun, 12 Apr 2026 15:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB3D6B0098; Sun, 12 Apr 2026 15:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA966B0099; Sun, 12 Apr 2026 15:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABD116B0096
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:00:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 483A35BCE0
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:26 +0000 (UTC)
X-FDA: 84650819652.02.3E4E286
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D31BA0012
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YB4iR0sb;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcpLtRFkU+wa8/xubTu1n2TbNarDGgtIbzDwSERu55Y=;
	b=AWQHiKYsHl4TKmVG/hfarfiHbkbiPn7zjGss77VtQKjKClTSRW8AKJpIiTaVU5RNgOVAL6
	ummluu1Pps058R/fHDGpDd2TbOMCfLXuaF3sp9jH8UFRzVEq1RTHQS5s1eOuhaXnYdQQ21
	rrll+/lUo9OYFr+GbE1k7ohpPLhQr8Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YB4iR0sb;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020424; a=rsa-sha256;
	cv=none;
	b=eIew0sepMhHNHW2MCxku5OTvM2EA/pWqXpWgeL5X7OYrdcQOvvo9zicrXvYwFHe/tkp/Gg
	LWE74h6QYEG28S4knExAIej0Me9etZI3ECTf9+k76a/N1JYUmgrRVkXkyZ3k2tXrlTYAJx
	/hTyWu9F6GdIAh12lIBr7jcWOBqA8mU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2CC316014B;
	Sun, 12 Apr 2026 19:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43FABC19425;
	Sun, 12 Apr 2026 19:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020423;
	bh=1jHVYet/oe54ZKAneg+n7pyqjRhk04H+YUkgPDqua+A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YB4iR0sbgw8zJtiXrS8IWUbYJCa3vxqiIyKQd3DG46XWAtcsyOav4SlBasiBRWUpp
	 qe0/hyS6ixZnB/78TTE+tZUUHmGgCua+5Ae+b2kx1WEaQHozVkpz9odDDoI2muc9UB
	 PHUYm838J1usr6bDmc+/3cmWyP4pUzts9gKH0ZVsH9YLxCR7bLmrs/wE3Rm5IVlbwD
	 m7bxRkxtv5lDA6b6eEEmWMtrZ/vMvF8QHvtGSbUqZhSVOkolJWtKHvV3SPr7rotNLA
	 jAiL7jEjhNWdZGpF3t9qsrh+AoWfhXgturlGDoSvwBZeALPa6qPYiDvCTH3+frOc5e
	 v1aKBieXzcNTQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:35 +0200
Subject: [PATCH RFC 04/13] fs/proc/task_mmu: remove CONFIG_PAGE_MAPCOUNT
 handling for PM_MMAP_EXCLUSIVE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-4-05e8dfab52e0@kernel.org>
References: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
In-Reply-To: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: ccgykcq7obstcfkm5ssepx1a7pwshscs
X-Rspamd-Queue-Id: 9D31BA0012
X-Rspamd-Server: rspam09
X-HE-Tag: 1776020424-364770
X-HE-Meta: U2FsdGVkX1/bMunKhsdcMDbwf8xQpmVoMjvwvS+PRllMqxKDOG9SY/+HBIAqJRs9jhCpHR9Aj5EIN9cySgqIbqnnlFi6xDnFPUbaPdQ0cEb5+PgxWSgx5LJYHb0HUOSejPG+LXVtCImUwJTjVN+fgeDEq4tp5KYGZk9zV0doUOURg7CckOgzdem6FM+P1wXz0sm1rdb/RnSq+37cmVqdCb3eCUhxOcHwlSh3ESmxXViBZjVnb+hb/xadzFTw5xeSSv+ciPK/fYnhG9W/ZAHytzqEavW+fF00QGdQFzNcvaY61vNnSgQleQ6qbO98Nhqh+xxvZ9ND27snOCxU0lJxoej7SBhuwGIb2A2NB6gmX2QZxBW3bCFnTrSq0YB8U1XTSrysf7CytAJdwUe4Ev0T9sEWgxegKl+7yus7yO8p+It7Czs0RuD9dz1ZghzFRrUsSaKmgCo1yHg29Jd/wOPH2kw1kncMYvB/iecUvAXqBYX3Hj/N+WUZV7AnZ4Eur8/JywvSKlv03bKNhw0FtbQ5NSZjrAXKFlbXz6aLhEvVWjQCzgrqpxq+d9QmBSzdOWt4GRFNfoKopEb5iOUMRQrnIW2RUI0Q+39iYFaIK/SvrV1pV4HIw6E7o08xV6cwvWs4aaq1vGkI/hw8heIm07mDq4qIBltV21nR/JxzCPhjwSo88fes1blwlbe+MHyY8dffIkLfLv5WDwb8ULeTbohswhK1DuAcQzNW1463jpbDq20LQuKcuoO/QOITuuLj1i6S+Jy0q5PTSNcyGEm9erHDqpjqfJ7uFrE/xSj9sruooN7+ehwhEWv52ySbQSZNfx1iJ7F81/oQp3yY1GnWnEM6HMQdSk3Qw26O+grYtiagZB2UwLvvcfOllEO+jnxi7FB/7jAc//GJ7HIFjIvSyf5ILNkPuai8+zfBtrP3MQg200hauNgAGAzLUZSB8P4tWOi5fAU6XONwdV41Z8B1n6E
 R0jXc+eQ
 66td0bHM4xYxIYWYl0zcvuBGNqa3HHSyj2WaiaDNOuvJMUT/EDUBovrtTIJCzx/CrAwI938uqC4bLhOxhnXEHJxBCfB/qI63yXXgq797jKRtIOKYDjg2wLDFnPs3l1Oou7V8oLXC47JZeIyIOn4q7/lC0sydjp0lwX6uQPMq284lOtE6lMXrgOP2lX1hZUU7DUGAFvkrzC6Cu+2AlyR2j9sN3jJ3oWeSoSQE6NBnKwKrrLYpb3hT3CdD3dGsGAyeuFULLVTqtJtP9uKe5VEtOyzjvU9Firb5N6o1Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for removing CONFIG_PAGE_MAPCOUNT, let's always use a
folio_maybe_mapped_shared() to detect possible page sharing, like we do
with CONFIG_NO_PAGE_MAPCOUNT.

Update the doc to state that this behavior no longer depends on the
kernel config, and simplify the doc a bit to mention less details that
are hard to follow.

For small folios and for large folios that were never mapped in multiple
processes at the same time, there is no change at all. For large folios,
there might be a change if

(1) The folio was once mapped at the same time into more than two
    address space, and now is only mapped in a single address space. We
    might detect it as shared.
(2) A folio page is only mapped into a single address space, but folio
    pages mapped into other address spaces. We will detect it as
    shared.
(3) A folio page is mapped multiple times into the same address space. We
    will detect it as exclusive.

We can now remove __folio_page_mapped_exclusively().

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/admin-guide/mm/pagemap.rst | 17 +++++++----------
 fs/proc/task_mmu.c                       | 12 ++----------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index f9478bcbb6a9..67eb04b1e246 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -38,16 +38,13 @@ There are four components to pagemap:
    precisely which pages are mapped (or in swap) and comparing mapped
    pages between processes.
 
-   Traditionally, bit 56 indicates that a page is mapped exactly once and bit
-   56 is clear when a page is mapped multiple times, even when mapped in the
-   same process multiple times. In some kernel configurations, the semantics
-   for pages part of a larger allocation (e.g., THP) can differ: bit 56 is set
-   if all pages part of the corresponding large allocation are *certainly*
-   mapped in the same process, even if the page is mapped multiple times in that
-   process. Bit 56 is clear when any page page of the larger allocation
-   is *maybe* mapped in a different process. In some cases, a large allocation
-   might be treated as "maybe mapped by multiple processes" even though this
-   is no longer the case.
+   Bit 56 set indicates that the page is currently *certainly* exclusively
+   mapped in this process, and bit 56 clear indicates that the page *might be*
+   mapped into multiple processes ("shared").  Note that in the past, the bit
+   precisely indicated that a page was mapped exactly once, and the bit was
+   clear also if mapped multiple times in the same process.  As this precise
+   information is not available for pages that are part of large allocations
+   (e.g., THP), the semantics have been slightly adjusted.
 
    Efficient users of this interface will use ``/proc/pid/maps`` to
    determine which areas of memory are actually mapped and llseek to
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ad0989d101ab..1e1572849fed 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1884,13 +1884,6 @@ static int add_to_pagemap(pagemap_entry_t *pme, struct pagemapread *pm)
 	return 0;
 }
 
-static bool __folio_page_mapped_exclusively(struct folio *folio, struct page *page)
-{
-	if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
-		return folio_precise_page_mapcount(folio, page) == 1;
-	return !folio_maybe_mapped_shared(folio);
-}
-
 static int pagemap_pte_hole(unsigned long start, unsigned long end,
 			    __always_unused int depth, struct mm_walk *walk)
 {
@@ -1985,8 +1978,7 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 		folio = page_folio(page);
 		if (!folio_test_anon(folio))
 			flags |= PM_FILE;
-		if ((flags & PM_PRESENT) &&
-		    __folio_page_mapped_exclusively(folio, page))
+		if ((flags & PM_PRESENT) && !folio_maybe_mapped_shared(folio))
 			flags |= PM_MMAP_EXCLUSIVE;
 	}
 
@@ -2058,7 +2050,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 		pagemap_entry_t pme;
 
 		if (folio && (flags & PM_PRESENT) &&
-		    __folio_page_mapped_exclusively(folio, page))
+		    !folio_maybe_mapped_shared(folio))
 			cur_flags |= PM_MMAP_EXCLUSIVE;
 
 		pme = make_pme(frame, cur_flags);

-- 
2.43.0



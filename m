Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7529ACD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858136B0093; Tue, 26 May 2026 02:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8085F6B0095; Tue, 26 May 2026 02:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E466B0096; Tue, 26 May 2026 02:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61C746B0093
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:37:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 24C8E402D7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:27 +0000 (UTC)
X-FDA: 84808614534.20.35B5067
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6FA2510000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bb0iLLe2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FoOqnyCscEnp0Oy8YoLjbVIzkAS+eWHHkrfQbiJCkU0=;
	b=ZnsOR66Qb7M/d+BywbpzlOZ4m+mQqjFTZn1DhZibg6C7hhAgD8n5aYESB2Gtn2Hbso533y
	xw4nEu3K3KpbAU6MA01EOTU+YqeT8pMbUgSqOiniDZMtdA9cph40gQVA8+4tVJlgTocwFB
	QfBTmGxtKFhDo6zb3LrLuWkcHN7d6qk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=bb0iLLe2;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777445; a=rsa-sha256;
	cv=none;
	b=NT6ZpC1sXk0SMk73wjh76Qy3neZcUwARazDchGRL351Zt9mtXf1jKZH98x0lHfA08M5DB5
	R55SO3JP8RAmq3aqG5PRNLS0gKhlMs38HbsTgHLqpzUpcW342ensqyBflUZrCDkoWxDvtN
	prsWjCDUEO/1kZhA3DSv0kH/rGth+Ns=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78BAB1758;
	Mon, 25 May 2026 23:37:19 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D808B3F7D8;
	Mon, 25 May 2026 23:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777444; bh=vY2yUh8mmoxtj6QqDdl6d8AihpECXUCTi4exwCTeCKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bb0iLLe2oFyblJV+7RK6zsL8Fqqk+HGMEFqP8g4OfTvt+AGJuJHpsw4whZXCQj3Z1
	 edW3ZxoaJA+bt0AxEAZRPphwjAMFfRQIXbeHY4eb/Um4Hm9jtqwT5AbOh8Ho4ZWCRV
	 dpabQC6vYR807c7H6V/IKGsiumaCfojbEJHzG+eM=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 03/12] mm/rmap: refactor some code around lazyfree folio unmapping
Date: Tue, 26 May 2026 12:06:26 +0530
Message-Id: <20260526063635.61721-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6FA2510000F
X-Stat-Signature: edt613nh5gx9g5r9zjoty587a6nnd5ry
X-Rspam-User: 
X-HE-Tag: 1779777445-64627
X-HE-Meta: U2FsdGVkX19T26RKgBpue6J/hiPBeqCAq0IR2A3nS+yiLEdIW2KZInwMvP5LLyU30jYcaqLu6p3c6+qYTYQS3pVOUANPLkBoGDP1lAI03hkH+O0oKygCX/kfjfWeS9Az8lF1FgWXaU5VNDnVPRlyuTb1SFqvASYCKawWfmWWiSf6SVcr6x/+/sdnBlE7N/ArqSuuorhwAgtr+Grn2p7X96Ydearu/e/7TcL8mlVMfOQPZjLHiNQsK4yCN6LMW9xiZHM95pzDO+f50Mc65rp92av8cEIzPqUO4qWPyW/PCVNn69vGzxsGeqRAJw01TXFL4Oa3gHHkjpU3Mr0Du1q0XdeJ1vw7ubvnQF8+/+tjLGQE3A6JEHKTGm8tGb+ZNEWdkrIX12+TaD2T7BWdKdlzvmXfj30w/zy8AU8R5ABHhuhtceypJde8H9wrT+lKUzZHgCqhWEeMdhP5JFDH27YKTQq8tO6f28mdNCJobDkcv6pGAYbb6JR4OC56d6Y1Vhzwa216nvmalz4ZfKFeCbNJJNMhC9HL1YNDnzaLN1uHyviJ53gz0gpbuZRHWzKwcZDyoJmMrvEbOSCvHLumLDYlcpuRdSieRm0h4q616LFUTyx8fLvPvYLJGKPAJ2QU1cqHHubxNEz3M8dFxLRQ7vEtrCmy8dUedtNSNPQgbragfWEvp+189kdEKyWnbBnMYDRVmv+NSlj8bpvSc++KOy4V8sBKLo7oJN7lUpnhDrN/TURODLCT4Gs0cb3cwm7UvpO5FdEIF9aOvcI8VdybXBuljNNmqZCa8o3/PInXhrC2LJFSjHxe+p64JUgcy95DSMAXJR6cnI6LOSw+OP9jrIHKcJjbahQgWGk91LixSwhFa9EDsc7t8a4T4PQTtZTAZimHD3kHtZe3oxa/ncP/4DQ6ABxqPAf7ipVq2PZ0GmvHOWh2jzpsUMPDBBx34PwmEQ+5qh18ukbiepDyWmgR9Dg
 z1iVXp5I
 KMfk0VmsIZEUVJbZAQf5ZIrjljPpLM6La4BD4mAReEYG6gasxSATAaNYIFvJ/M8sWWpCQsr/Lt10gV5ouxNoL2YNtXh4HI/77M0hI57UsAYBmIzt9S6CEyKBRHSE6RRuZ/YTp+1OnJ97HimK7oVzECYqz/NXvUmMH6WzgaP6DhT0HSC6CXfC5CFAcgyz1VU5hERjiQnowqFMxGBy2Or9hPjVHjcv7EtKMaBhTw3uxSxWQpk3q9paxvVIS5+DredbynFjlGQyY+ltDb4y7kmq1jHrRxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For lazyfree folio unmapping, after clearing the ptes we must abort the
operation if the folio got dirtied or it has unexpected references.

Refactor this logic into a function which will return whether we need
to abort or not.

If we abort, we restore the ptes and bail out of try_to_unmap_one.
Otherwise adjust the rss stats of the mm and jump to a label.

Also rename that label from "discard" to "finish_unmap"; the former
is appropriate in the lazyfree context, but the code following the label
is executed for other successful unmap code paths too, so 'discard' does
not sound correct for them.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 88 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 50 insertions(+), 38 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 06ab1158d4cd1..12bbee57f20da 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2093,6 +2093,52 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
 	return ret;
 }
 
+static inline bool ttu_lazyfree_folio(struct vm_area_struct *vma,
+		struct folio *folio)
+{
+	int ref_count, map_count;
+
+	/*
+	 * Synchronize with gup_pte_range():
+	 * - clear PTE; barrier; read refcount
+	 * - inc refcount; barrier; read PTE
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for page refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		/*
+		 * redirtied either using the page table or a previously
+		 * obtained GUP reference.
+		 */
+		folio_set_swapbacked(folio);
+		return false;
+	}
+
+	if (ref_count != 1 + map_count) {
+		/*
+		 * Additional reference. Could be a GUP reference or any
+		 * speculative reference. GUP users must mark the folio
+		 * dirty if there was a modification. This folio cannot be
+		 * reclaimed right now either way, so act just like nothing
+		 * happened.
+		 * We'll come back here later and detect if the folio was
+		 * dirtied when the additional reference is gone.
+		 */
+		return false;
+	}
+
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2279,47 +2325,13 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 			/* MADV_FREE page check */
 			if (!folio_test_swapbacked(folio)) {
-				int ref_count, map_count;
-
-				/*
-				 * Synchronize with gup_pte_range():
-				 * - clear PTE; barrier; read refcount
-				 * - inc refcount; barrier; read PTE
-				 */
-				smp_mb();
-
-				ref_count = folio_ref_count(folio);
-				map_count = folio_mapcount(folio);
-
-				/*
-				 * Order reads for page refcount and dirty flag
-				 * (see comments in __remove_mapping()).
-				 */
-				smp_rmb();
-
-				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
-					/*
-					 * redirtied either using the page table or a previously
-					 * obtained GUP reference.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					folio_set_swapbacked(folio);
-					goto walk_abort;
-				} else if (ref_count != 1 + map_count) {
-					/*
-					 * Additional reference. Could be a GUP reference or any
-					 * speculative reference. GUP users must mark the folio
-					 * dirty if there was a modification. This folio cannot be
-					 * reclaimed right now either way, so act just like nothing
-					 * happened.
-					 * We'll come back here later and detect if the folio was
-					 * dirtied when the additional reference is gone.
-					 */
+				if (!ttu_lazyfree_folio(vma, folio)) {
 					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 					goto walk_abort;
 				}
+
 				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
-				goto discard;
+				goto finish_unmap;
 			}
 
 			if (folio_dup_swap(folio, subpage) < 0) {
@@ -2382,7 +2394,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-discard:
+finish_unmap:
 		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
-- 
2.34.1



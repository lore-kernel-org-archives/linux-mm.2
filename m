Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10C36C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6726B00C7; Mon,  6 Jul 2026 07:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EDF6B00C8; Mon,  6 Jul 2026 07:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6E66B00C9; Mon,  6 Jul 2026 07:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CABB46B00C7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:43:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 599DF168AB9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:42 +0000 (UTC)
X-FDA: 84958167084.19.C48EDEB
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id BE4A24000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jrncYD8H;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338220;
	b=fZcVfOYe92agQ7Mcn6dufhIiN2nqz7+389TPVgh6FpgBgTGoHjSEgCaEhOQ1oa1lw57gZM
	qJGgChZ5ASfHj1jaBkJZI6CnnQyyFocxF43S26uyFft4RMcf6bBcAjaUxhyKN70fjskUFW
	CRFGPTNUlvod4+Kj3VaGqsf2iKsRar8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jrncYD8H;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04h6q4X00YRj/INo249IFppR4NPSnMlpfeg60RHXkVg=;
	b=XZgx5Nc/9xbW5dH2mKVDRzZBX5SWlydIz9AILXnp/UzbYq5otZRVcg13i3JQNCz5IICABT
	nM81PGmKguW60qnKwai+rvXYGjSyDX6OoYDzKjf87gpxMkO3LpicR9snzQqqnPt+HJTAT4
	p1u4og0yaPsDIpNcLBnTVzG+y0A8PyU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338219;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=04h6q4X00YRj/INo249IFppR4NPSnMlpfeg60RHXkVg=;
	b=jrncYD8Ho2kWnTw2hXqw1gb8DtIiqqIXy8XZTE09KHP5gAJbnqKwjEhPSj00+qTP31/rpF
	ulE+06UXLsx8UJ4nUozXDDS4NkD7xMSxKLbDK3KBcWxjkTra7HOJbknXq0tSyy77WlN1eE
	KJz/MOnG/QAsanNHRgRtyFe0iuNAKew=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 2/6] mm: extract mm_prepare_for_swap_entries() helper
Date: Mon,  6 Jul 2026 04:42:04 -0700
Message-ID: <20260706114320.1643046-3-usama.arif@linux.dev>
In-Reply-To: <20260706114320.1643046-1-usama.arif@linux.dev>
References: <20260706114320.1643046-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE4A24000A
X-Stat-Signature: xihqgs3nihm4djuntbr8hejrww8jyd99
X-HE-Tag: 1783338220-830192
X-HE-Meta: U2FsdGVkX18Cp7gCM5g0y3BQJkDaxKGPaUXeXX/mKDa2ed+qQ48kEzUTLWb36PrCovCvAgvO2nXkBOjbWi+gb6RK+Qqj7ZmTeV6B67+mjWJ06vwO9x4WTo3gS/2gqaD24yQyoyONN32Pthsdhvmj2G4ogVo8r06BwESevKFft26qsIEJrD7NJ98WVBDaMiMitzay9ZgdStiS9KR/MsiAKOMEiEOCfbjKr2XVxlPVTHqN3/GYCJ2CJkrvEKfNqt9QTFAUfMnFNX5tfnSbYJLlEetMLdIZNs1/V7M2gWGmk4RzCMSxt/3b/ib2UhWD7q4gBsBCGucmaoqSCSzmX1Avl/tXFUtJ78vK3egUoy7PDJVPqYPZDvj2iZVmhrmWPd9dtLFkdrbJyKhK9DTUzAiCrlO9bX09iVk16zmHAtAqFMowF7WaqdOzLodCh+CRFETmgoYmrq4ANci7aIbdyH6c3zozb9MQdGWvr1tWuZ8IUrX5lBG3F0APj9nRmwTk/fePRhVqngdQoo5hRcVE+x1v3IVpWMehwMEYcdta6TRlSOctrGwbzEegUz7zHeZZEJse+PJfdqAn1fqt3VvBEqR2I8SNrgwUwPAnn534y/H+Z2tCHuR04aJTuJ3wlYEuUBQzCvvNedpjSFtJ/wvqyYaVe01zUe2Z5M+SbCZA1e0G+wUQwn2TR0g2Yh3FTopZfhHdk2Bzu5cfCQk6ggEXNUprJo6MaBKUV89fuD6dpVYKmk4pLxyiqDx8uYsTiC/LorqR16O/zCYJEK+v7Lo8yN/Dtik/1TH09CP/UpEVwhgXr8Gg9+WEfKF+kz7J7WY8VQXU+r3nWeE37slrhnIjGdPiNl+GkGu1ByjptXnm+fY7+vOM3emMgNP9xUdLUmudH3v+9vSlvM2knTjR0g221Z1/HODOhK0mezlhFwdQYVx84sfwvBbI71CxZnyLL/eJlYOrvf7J15J7QBrlB+Lxave
 YffXJd+0
 VozGQ8Q7Ty+ngdyAyE+/4sb9eovJmgngoJyISTM8us0Pv9cuppnkI5HzSrWJYq9tyDOgneMIcnxOWLIiK7MAjFSV6VuM4mUSUwD7VHDSbIBkDj0Exog41Hwb776N6Lgir8y2QFwkREd5TQuy4b2qC1nZiLNQza2BaD1JmxtQTDAYKymRSNJd1HfA6OITbRgwvsK5DgfM05MzeLD7zE8jz/ZKe8W+cLNmJ06lEF/C+tbHSMw42JMmlK9t9rzRIrZ74lk1tPkw0rfhJXn/zyt0hNAYxWr8lE+xTSjYvEdN4nyg69stHyE8RyFNndrHh3NZ+/NmyNM0Eda23N8ysCFfA/7cJpUTFLywJRWFY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a swap entry is installed in a page table, the mm must be added
to init_mm.mmlist so that swapoff can find and unuse its swap entries.
This double-checked locking pattern is currently open-coded in
try_to_unmap_one() and copy_nonpresent_pte().

Move it into mm_prepare_for_swap_entries() in mm/internal.h and convert
both callers so it can be reused by upcoming PMD-level swap entry code
paths that also need to register the mm with swapoff.

copy_nonpresent_pte() previously inserted into &src_mm->mmlist rather
than &init_mm.mmlist, but the insertion point is irrelevant, mmlist
is a circular list and swapoff walks it entirely from init_mm.mmlist,
so only membership matters, not position.

Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/internal.h | 10 ++++++++++
 mm/memory.c   |  9 +--------
 mm/rmap.c     |  7 +------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 430aa72a4575..0360648e5726 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1955,4 +1955,14 @@ static inline int get_sysctl_max_map_count(void)
 bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
+static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
+{
+	if (list_empty(&mm->mmlist)) {
+		spin_lock(&mmlist_lock);
+		if (list_empty(&mm->mmlist))
+			list_add(&mm->mmlist, &init_mm.mmlist);
+		spin_unlock(&mmlist_lock);
+	}
+}
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/memory.c b/mm/memory.c
index a3fcaf8cfe8f..6637c5b13c9b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -953,14 +953,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		if (swap_dup_entry_direct(entry) < 0)
 			return -EIO;
 
-		/* make sure dst_mm is on swapoff's mmlist. */
-		if (unlikely(list_empty(&dst_mm->mmlist))) {
-			spin_lock(&mmlist_lock);
-			if (list_empty(&dst_mm->mmlist))
-				list_add(&dst_mm->mmlist,
-						&src_mm->mmlist);
-			spin_unlock(&mmlist_lock);
-		}
+		mm_prepare_for_swap_entries(dst_mm);
 		/* Mark the swap entry as shared. */
 		if (pte_swp_exclusive(orig_pte)) {
 			pte = pte_swp_clear_exclusive(orig_pte);
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..b93caabd186f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2304,12 +2304,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
-			if (list_empty(&mm->mmlist)) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&mm->mmlist))
-					list_add(&mm->mmlist, &init_mm.mmlist);
-				spin_unlock(&mmlist_lock);
-			}
+			mm_prepare_for_swap_entries(mm);
 			dec_mm_counter(mm, MM_ANONPAGES);
 			inc_mm_counter(mm, MM_SWAPENTS);
 			swp_pte = swp_entry_to_pte(entry);
-- 
2.53.0-Meta



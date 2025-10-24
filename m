Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4FA3CCD193
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 01:57:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427238E0030; Thu, 23 Oct 2025 21:57:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8208E0002; Thu, 23 Oct 2025 21:57:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7138E0030; Thu, 23 Oct 2025 21:57:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5E58E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 21:57:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A3104129055
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:56:59 +0000 (UTC)
X-FDA: 84031344558.05.941CFAD
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4F10D1A000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:56:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761271018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=/KKLetrECdYQKdzbcND8BrfgBEfuh8lqcxAuoVyuyvw=;
	b=qx43rj6i41mgIP+4UrPYSh/2KDJhc6ST1oyUAmUm583DOLi5ezr4h+VyUwShJ1YqjyqG0P
	ckuTb11rtT7bbx6ceP6yGzWdsGwQwFi+9+V3/UAVkx4OK5hTeIOmvl1VrXc/ML3PZ51vwx
	0rB7aJAp0MEXadkLWmQNpgFZsCZsM/8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761271018; a=rsa-sha256;
	cv=none;
	b=7hD+pLIyw/R4mNkVqhwAckvuNmPVqKthVI0cDwJ+MGuU4kMvB22aCfIorIYXHOBFRq4GVn
	OOgDnTZMipNDwXdDKYIyZ0935nMflegwno+O+cWu1lqGiORNCptEBqhti3nAgZMHMONTDL
	+/SkMb4NRB4RTJRmsCUnQtI0hu+xEQo=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ct5bF54zCzYQtrp
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:55:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 937EA1A083D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:56:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP2 (Coremail) with SMTP id Syh0CgCn_UXX3PposwChBQ--.8162S4;
	Fri, 24 Oct 2025 09:56:48 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-mm@kvack.org
Cc: linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	david@redhat.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	karol.wachowski@linux.intel.com,
	wangkefeng.wang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH] mm: do not install PMD mappings when handling a COW fault
Date: Fri, 24 Oct 2025 09:54:59 +0800
Message-ID: <20251024015459.2824162-1-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.46.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCn_UXX3PposwChBQ--.8162S4
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4xury3AFyDZw4DJF4rGrg_yoW5WF4xpa
	yxGa1ayFWfWrn2y3Wxuw4vkr45ZwsxGayUWFyxGryjyF15Gr1Y939Yga13A34UGr4UJFWr
	Xr45Kr909FWq937anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUL0edUUU
	UU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Stat-Signature: p8wgi9a6e89f5y5xme8ofaodoxfg7abm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4F10D1A000D
X-HE-Tag: 1761271014-187481
X-HE-Meta: U2FsdGVkX1+mVIwzxe4ZBzzPZwqES6wgH7biflpNTJoXn05O6L95EhIR/TqnoC4cM/GBtBFlfVKoZUd5ipl9Af96ISNKeBBSAINodASLYXUtutIdMaVQ0qD9ufwbJk/t5ew9wm0uJyKConXK9O/Ghkqm36TOd5W/ykkQgyoP/FdUObHNtPWFwYyVzz7OzXndWl4ZAxzZ1OD6zMUV5aQ+c0RiCneq1yRzN5cgrqHTpuHgHUvmLGDh45mLtEZPEj6SVo0/wXXL4bVmDAIYS/XAWeNKeFFXAOKVIvuCR+4KER1Gj4e22gG4L16llHXqk3vF9PVQcVDeU3Rz+LJH4SoLoLfbiDMLyRxSs0TOyPdvsgJ6yUvikO3Wtcktsa8BKOZ3lbTRC4oNkuNIje14kj6cl7yvHnZSibks58YYhSAxvIPGEmRKgKPelAM9NMJQxLD+GCl7eZ6d6NGOdlveaPs3+FfVvE3WZi3U+eWxVj+bKj6RDWqlHVNNUBOUYsFsMkGX8HvIXO/3FBJtVGqNbPGF5HDe1JEqOEapuVUWen+vqVavqjDMaGYKT2Bxb+L7ZhDyoSsymlQaYZu4JQB/YFW9CFeKY96VJY96lQ3nt4BxmwXJGiHPn86LAsJGw1q6NXkO/9PeTPdRQAfu03pps2S6D248OhhcIDEw8ePfMEEsS/tjaeQhxUTMZ5oqNRm92vb3S+7i54TsMBsQVSmq8YTSYvPsW5DZQmX512U4BM1Hw1fQM7nYITmiU8o26PvtJiRomN4v7VcDfG5fZpfekdYRkUlaF8Sj0QtV5hu53R8raDFPCNG58GZlz66M9WmeY7X/YYzANihzCnhCmzCTSHJjYLjhFWVfRxtt61roZEIk+MPReiGxOMUEKcRLeIJvVVSZ3TQ6GUNg4FIII41xajBiTNpKOQ8VIz6RJI7GhBfc1TZmo8JSROVLfPZFEWyzOZVY0C72Vf3WVLm6JvvHjMU
 MiMk0rOH
 K8yQZpKVltlGnY3r87Wu0YANpBgDJzba9Em/4i7S4lVSDsXNGRrtYFbWqHRQiA+2x6f9JsmA16ID3f0de3rRRQoOohhHu/afxgjxLqjFLn2J7nLtDm1Q6C9gvbtIOlKQpge0ySfTQpEeC8oEJEbJWb21JHcMpEVfutDMi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Yi <yi.zhang@huawei.com>

During the ping of user pages in FOLL_LONGTERM on a COW VMA and a
PMD-aligned (2MB on x86) large folio, follow_page_mask() failed to
obtain a valid anonymous page, resulting in an infinite loop issue.
The specific triggering process is as follows:

1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
   has a 2MB large folio installed in the page cache.

   addr = mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, 0);

2. The kernel driver pass this mapped address to pin_user_pages_fast()
   in FOLL_LONGTERM mode.

   pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);

  ->  pin_user_pages_fast()
  |   gup_fast_fallback()
  |    __gup_longterm_locked()
  |     __get_user_pages_locked()
  |      __get_user_pages()
  |       follow_page_mask()
  |        follow_p4d_mask()
  |         follow_pud_mask()
  |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
  |                            //huge PMD is installed. This is normal
  |                            //in the first round, but it shouldn't
  |                            //happen in the second round.
  |           follow_huge_pmd() //require an anonymous page
  |            return -EMLINK;
  |   faultin_page()
  |    handle_mm_fault()
  |     wp_huge_pmd() //remove PMD and fall back to PTE
  |     handle_pte_fault()
  |      do_pte_missing()
  |       do_fault()
  |        do_read_fault() //FAULT_FLAG_WRITE is not set
  |         finish_fault()
  |          do_set_pmd() //install a huge PMD again, this is wrong!!!
  |      do_wp_page() //create private anonymous pages
  <-    goto retry;

Due to an incorrectly large PMD set in do_read_fault(),
follow_pmd_mask() always returns -EMLINK, causing an infinite loop.

David pointed out that we can preallocate a page table and remap the PMD
to be mapped by a PTE table in wp_huge_pmd() in the future. But now we
can avoid this issue by not installing PMD mappings when handling a COW
and unshare fault in do_set_pmd().

Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page")
Reported-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Closes: https://lore.kernel.org/linux-ext4/844e5cd4-462e-4b88-b3b5-816465a3b7e3@linux.intel.com/
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/memory.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b71847..0748a31367df 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5212,6 +5212,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
+	/* We're about to trigger CoW, so never map it through a PMD. */
+	if (is_cow_mapping(vma->vm_flags) &&
+	    (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
+		return ret;
+
 	if (folio_order(folio) != HPAGE_PMD_ORDER)
 		return ret;
 	page = &folio->page;
-- 
2.46.1



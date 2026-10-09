Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 978F5CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 10:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9B86B0092; Fri,  9 Oct 2026 06:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59A646B0093; Fri,  9 Oct 2026 06:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B03D6B0095; Fri,  9 Oct 2026 06:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2270A6B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:12:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 992621C306F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:12:18 +0000 (UTC)
X-FDA: 85302672756.18.622B4D5
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf31.hostedemail.com (Postfix) with ESMTP id C052C20005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:12:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=B87EFUsA;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791540737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zBSbv2B6IsoFMLLUq2oPWczzDmUPwVCu6gZEUUWAPbU=;
	b=MTYYsVDD29FERPU806Jyv0gy8XUzqE3TmWVOb06ERUSIHGm2bUJ7qSSMXG2XJP336F8WyO
	YwOd9poqIY/2Qo2t2FgRc/MbHlK+gx7/R7LtzcWN4agSxGkJ8Gre2P9Lfjvq6i33bAOynB
	w+yh7o7lbULcA6tcdz6SXaUzPPto/M0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=B87EFUsA;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791540737;
	b=DpNjOWBTmg5EF0rumG4WCHC+Cx0MzqdVXC4jw+zGmt1z5vtL8OpsJgcgzmxi/WOKvPvXeD
	LJ0uY8jOc30SEZH/bU7ETKaoXntv0ehJcKI0PMPiUlRf8rH5dlaFLi8kpYxUG3o8SxGjwe
	8t86qO+Fz/WdHd9YOTt8vteKYvlWIsc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791540733; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zBSbv2B6IsoFMLLUq2oPWczzDmUPwVCu6gZEUUWAPbU=;
	b=B87EFUsAFPor30siFVbvjY8khhf8OwDsonfUR/PTmX+U4DOP1bZLkqFsw7I0xZKqopOxUUvW6CsutcybXgbnXTCfT5eXWsiW+S/N9T9IjlU/wCt7Qj78/ibVktN2jpRleGg14CESofruy7gg95KKDrblPFTMMJYPmWA/Y+rYfZc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XCT5qzQ_1791540731;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCT5qzQ_1791540731 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 09 Oct 2026 18:12:11 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	jack@suse.cz,
	pfalcato@suse.de,
	ayushr@modal.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: memory: fix truncation removing mapped folios
Date: Fri,  9 Oct 2026 18:12:03 +0800
Message-ID: <0d2a1809fa1cfc22ad3df26ec28b2d30e5cdf3bd.1791540483.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C052C20005
X-Rspam-User: 
X-Stat-Signature: n8mw33ag86ycppx7dexbwoo3ct3k7zt6
X-HE-Tag: 1791540735-279518
X-HE-Meta: U2FsdGVkX18qFGF1OVjmElWaKvZZYq92PQNE/ctlq2dJCZHHEh9LB8AXD5KPI4/DZGBEN2pe/jac+Gu/Wga1nOoMR+nQlXnS71S+Xy7Ric7iqPGUT9UBaP1t5sUnt8Qk6J6YSBV6ttKltNL5Bi+5Dt957gZ6kX9TFtJBjlxDRGwt4VhGTvrzqzpbr9QhP45toxWJ02VLghVCni+4vA9lTyIqHLrB02/N0PqppiiG9Eqw2IRMKhaYJDSYTetPiB+8SV/24Xm45h7wzdvZ7qFuup7tBuVTTVoEv1SMFjMp5pYH7q2PPd7gYNq0ysA9BGWYFjfSfu8ZQlserfSxUlqCgQrs3Wj6lP89S9HCtsfAth5YXwwS7PhT+cNthFgo9ZaDxS2MqZ7I3DLcI6R2uMHb1w2HlZ2LUeoLNF3Ozooe8ApkZrRKAiYdkFTwDFm3RaRFNDV+1mRYsg2unZuwt9UeN/+7cJw5qNAH3h3azcjjYJaz/roKcBQbKd5vF8KN1eSQ3SndCcV2VxHckAgYp3fr8rC+J9L13SgasMZHUyx2iSnmKEjrvbUG5AWO3hwJVMSeJJHOKP0mrsvtAWJkymr7ygPPAy7zGkm6A1dVVRX02K637rpSctW9VSb3a1yq2YDd7Ner3l1DB3Drx4YtL8GFHCQsc6Ah/UBQS8Sm19mVbQvcA1yAQlRFc41M42Xz8iVJ/LuZEhHR+2aCQ2cFOlAsCROiEkQMJfVXYaCU254DRMAvW0svZQxBM4mVDcT7tNhdJl/Gh2GE1P91n5iV+PZpX/iHEcO2t6rkCGPT+3Cl4bEcmJNJFBtTS9UpdlLuhr9n88euF2vHmkNqmkwpzxrVYerMjU8eln/6Q8dNDuwX/1CzzWTOi+887aOOrx0MQA1TvVc8/lWrAKih8cDH/4WB0sp10en8HHUOUBkW7cKUE2z9qXrs4CYcOde4hdnTdlhUNZsTvRn17J/n75R67A7
 +pLrKSBI
 vwFDm39Jiltzo6ks5K9p90nmUoMu5+8pfrN3Bs7bAsRIxt9zgrpaFI4/uBhgkwIPZbCOHpbp1qMw7hVBG6zf09z30KbZHy0Skaf3FB0Vgg3Qbs3H2dsBHS4GFVisHyVKMdR8HKOOhnAsoIaGP97o5HMdP5+6AWBJypGlYwId7KAMAFKsiPAsBIzDGEyGLnLFzRgQMIrD29MeNmIP6LzqFXRC+l98V5OlNg7UsEhEc3sMBA9fVB7tSg/wipl2k5SzbzAEWnYt+SllemoYCoEnKAUjXBt830iVcVoWdv6PZhJH+MSYPGtfRWzGhhX6YmtpRwqf/bACnm65xlSP1gxmETlv+SA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ayush reported an issue that shmem/tmpfs folios are still mapped when
truncating them on production:
"
BUG: Bad page cache in process ...  pfn:...
page dumped because: still mapped when deleted
"

I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
branch, and I got the following crash info. From the dump message, we can
see that truncate_inode_folio() is really trying to remove mapped folios,
which is incorrect.

"
[  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
index:0x3880 pfn:0x191647
[  189.171995] memcg:ffff0000cc073d40
[  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
[  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
.......
[  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
[  189.172026] ------------[ cut here ]------------
[  189.172027] kernel BUG at mm/filemap.c:155!
[  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
.......
[  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
7.3.0-rc4+ #277 PREEMPT(lazy)
.......
[  189.183986] Call trace:
[  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
[  189.184391]  __filemap_remove_folio+0x34/0x160
[  189.184633]  filemap_remove_folio+0x4c/0xb0
[  189.184859]  truncate_inode_folio+0x34/0x58
[  189.185087]  shmem_undo_range+0x220/0x658
[  189.185308]  shmem_fallocate+0x2f0/0x470
[  189.185527]  vfs_fallocate+0x128/0x328
......
[  189.187078]  el0t_64_sync+0x184/0x188
"

After analysis, I believe the race exists between truncation and MADV_DONTNEED,
and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
MADV_DONTNEED synchronously releases the pagetable page before calling
tlb_flush_rmaps(), this could cause another thread's truncation to skip
zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
as non-zero. A possible race scenario is as follows:

CPU 0                           CPU 1
shmem_fallocate                 madvise_dontneed_single_vma
  unmap_mapping_range            .......
  ......
  (filemap_map_pages() remap folios)
				  zap_pte_range
  truncate_inode_folio		    zap_empty_pte_table(pmd clear)
    unmap_mapping_folio
    ......
      zap_pmd_range (saw pmd none, skip)

  filemap_remove_folio
    BUG_ON(folio_mapped)
                                    tlb_flush_rmaps(remove rmaps)

To fix this issue, we should move the pmd clear operation (via zap_empty_pte_table())
to after tlb_flush_rmaps() and add a smp_wmb() memory barrier, so that when
we find a pmd_none() while unmapping a folio without holding the PTL, the
folio's mappings are guaranteed to have been removed via tlb_flush_rmaps().

[1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
Reported-by: Ayush Ranjan <ayushr@modal.com>
Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/memory.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 1f5d5f7d39cd..0272217ad7b0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2036,6 +2036,15 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 		}
 	} while (pte += nr, addr += PAGE_SIZE * nr, addr != end);
 
+	add_mm_rss_vec(mm, rss);
+	lazy_mmu_mode_disable();
+
+	/* Do the actual TLB flush before dropping ptl */
+	if (force_flush) {
+		tlb_flush_mmu_tlbonly(tlb);
+		tlb_flush_rmaps(tlb, vma);
+	}
+
 	/*
 	 * Fast path: try to hold the pmd lock and unmap the PTE page.
 	 *
@@ -2044,16 +2053,10 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	 * to ensure they are still none, thereby preventing the pte entries
 	 * from being repopulated by another thread.
 	 */
-	if (can_reclaim_pt && direct_reclaim && addr == end)
+	if (can_reclaim_pt && direct_reclaim && addr == end) {
+		/* rmap changes need to be observed before e.g PTEs get zapped. */
+		smp_wmb();
 		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
-
-	add_mm_rss_vec(mm, rss);
-	lazy_mmu_mode_disable();
-
-	/* Do the actual TLB flush before dropping ptl */
-	if (force_flush) {
-		tlb_flush_mmu_tlbonly(tlb);
-		tlb_flush_rmaps(tlb, vma);
 	}
 	pte_unmap_unlock(start_pte, ptl);
 
-- 
2.47.3



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B965106FD6F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 03:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4066B0089; Thu, 12 Mar 2026 23:46:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367646B008A; Thu, 12 Mar 2026 23:46:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266266B008C; Thu, 12 Mar 2026 23:46:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 15DC86B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:46:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C66B13B8ED
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:46:15 +0000 (UTC)
X-FDA: 84539651910.22.C644AB9
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf16.hostedemail.com (Postfix) with ESMTP id 278E518000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:46:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o+lMW1T3;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773373573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pse2p5q3e0xLdJ46zekTMe3aXUo0Kpovk+dPwCYCKso=;
	b=ejILE/T7t6SquTaYqOMR40tOFpKjSf30PlQ29hyY5La3bVKaagJrFg0uIjhuUoffCt4OjY
	8PZg/28iGUocWf4RL2Tlgd4JbMZeJmTluIzbWmoJ59D+R/jMyLL6ubJZNbE3Z6V+unMpSW
	H97m9lfbPJGJwo1ZqPyHq10xRQemOWw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=o+lMW1T3;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773373573; a=rsa-sha256;
	cv=none;
	b=vHxWJFL+4O4++URykx3sZ4xeOQszs2amUCrfgRcnGVYLD+MgrpggilGaBKP9kSyqFLf2BE
	0MU05b0yNHgKc2hhZUVRn0iFHOXJg4emohxLtxYY+fi7PZW+6qpTSX+x4CSlBFQ5CCyJtt
	IxW+EuscNvsLHHDOD6X7874TkssFAyI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773373568; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=pse2p5q3e0xLdJ46zekTMe3aXUo0Kpovk+dPwCYCKso=;
	b=o+lMW1T3s6fEWObz7hqEcL0T11WE75mNpRZguel+hrt/BEAlBk2KyvOCbtliDkiMuuP88t+LXawWqgbeSMVokLu8HtOA0kOX1OIruL9r/CvqkfVjY7rrb7V6CIvtQCLifb9Rrcq4XxoOQemMSuV3ocv8MOPhCRPx3wJK8IxR7Jo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X-qouLg_1773373566;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-qouLg_1773373566 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Mar 2026 11:46:06 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	willy@infradead.org
Cc: david@kernel.org,
	lorenzo.stoakes@oracle.com,
	kas@kernel.org,
	p.raghav@samsung.com,
	mcgrof@kernel.org,
	dhowells@redhat.com,
	djwong@kernel.org,
	hare@suse.de,
	da.gomez@samsung.com,
	dchinner@redhat.com,
	brauner@kernel.org,
	baolin.wang@linux.alibaba.com,
	xiangzao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()
Date: Fri, 13 Mar 2026 11:45:48 +0800
Message-ID: <066dd2e947ccc1c304b54e847fbe628dccea1d7c.1773370126.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 278E518000D
X-Rspamd-Server: rspam07
X-Stat-Signature: ro7bdsnxit5o6hbeyke6p3xeum5tqhps
X-Rspam-User: 
X-HE-Tag: 1773373571-402660
X-HE-Meta: U2FsdGVkX18lqJzkn23pJrvV4uO9yYah7W0ATgCrJYsbTDDjCv85xhLd8kdwh9EHcEK02toFOmKTn9mgZN7mQsJK0FZpvgKZI/W5MspsUmvr1gyTHYCmVNSKj2D7Gj3CjEe4zWdZsEd+SSfyIjL1MFMhrNzP/4vGjvE7nkULs4NCG8aDQIn8DMeUhrd1RdOvIi5XbRQXVulzahtmG+OpLquE5zhj64cayp5IgiJ/oQ8NZrvEWOfJZ5VFT67al7c5MTLu9nPHwy7A2FOJhNNmLEhK97K/vGbTui5AXnosJZi0NAjkySOc1TvWZCidBWD+xIPQUP7/v8GEXz8c4hUom2AOZZjHwM3c2Ys3Ls/5aqBcUSc9/ajQe25qcwOgepOeG/n90Hp2TUajEh2F7asuTbYQWvZci80KNrxajxtjMUj4gIB6Pkry1CGU9rfuLYyjCB9MZEy/IILdwHN9h04h2bEHp1dG/gwOB4ZxmFJ0GA30l7Ui77KUVkeCAQNDD+bS5KvfS8kOFmmT/NwlWG9xfVtyWZuP0RnU6u+DXQ1oi3RgW+OJhgjf3xTdTntjy6WCIWElVsbSODL9KsGjx6tZ1TUJL1WWh5ASkrpu4NRE/OXTAdkqVcwupd7hg5qSPAFOb+RrWcVJBwGR73wSRTQ0S0A1GZ3K+nPE/MId9IexLX89BTI5HXymfIQr1EJPqvu3oW3+NZD/9QjvPURWgBNgNxxOmYWibdNEbybJV4O/IpocJ25nTH6St12SrJaeEHm8DZTjh3SAizRrHNFD1moTaiLWtSCICX+g+b3u8VXfXb/pXnIKLqWl3m4te+ZkT8iFR3s0G8OrJgC1/MwnsgJtpYzwpYHXPi8TtJwgpTYCInmWpcKVrkHUToEi0oekyRqrxwx31sD26vjGOfeN9Z3+9xqBVHDw/r5v3ObOonT8+UU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running stress-ng on my Arm64 machine with v7.0-rc3 kernel, I encountered
some very strange crash issues showing up as "Bad page state":

"
[  734.496287] BUG: Bad page state in process stress-ng-env  pfn:415735fb
[  734.496427] page: refcount:0 mapcount:1 mapping:0000000000000000 index:0x4cf316 pfn:0x415735fb
[  734.496434] flags: 0x57fffe000000800(owner_2|node=1|zone=2|lastcpupid=0x3ffff)
[  734.496439] raw: 057fffe000000800 0000000000000000 dead000000000122 0000000000000000
[  734.496440] raw: 00000000004cf316 0000000000000000 0000000000000000 0000000000000000
[  734.496442] page dumped because: nonzero mapcount
"

After analyzing this page’s state, it is hard to understand why the mapcount
is not 0 while the refcount is 0, since this page is not where the issue first
occurred. By enabling the CONFIG_DEBUG_VM config, I can reproduce the crash as
well and captured the first warning where the issue appears:

"
[  734.469226] page: refcount:33 mapcount:0 mapping:00000000bef2d187 index:0x81a0 pfn:0x415735c0
[  734.469304] head: order:5 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[  734.469315] memcg:ffff000807a8ec00
[  734.469320] aops:ext4_da_aops ino:100b6f dentry name(?):"stress-ng-mmaptorture-9397-0-2736200540"
[  734.469335] flags: 0x57fffe400000069(locked|uptodate|lru|head|node=1|zone=2|lastcpupid=0x3ffff)
......
[  734.469364] page dumped because: VM_WARN_ON_FOLIO((_Generic((page + nr_pages - 1),
const struct page *: (const struct folio *)_compound_head(page + nr_pages - 1), struct page *:
(struct folio *)_compound_head(page + nr_pages - 1))) != folio)
[  734.469390] ------------[ cut here ]------------
[  734.469393] WARNING: ./include/linux/rmap.h:351 at folio_add_file_rmap_ptes+0x3b8/0x468,
CPU#90: stress-ng-mlock/9430
[  734.469551]  folio_add_file_rmap_ptes+0x3b8/0x468 (P)
[  734.469555]  set_pte_range+0xd8/0x2f8
[  734.469566]  filemap_map_folio_range+0x190/0x400
[  734.469579]  filemap_map_pages+0x348/0x638
[  734.469583]  do_fault_around+0x140/0x198
......
[  734.469640]  el0t_64_sync+0x184/0x188
"

The code that triggers the warning is: "VM_WARN_ON_FOLIO(page_folio(page + nr_pages - 1) != folio, folio)",
which indicates that set_pte_range() tried to map beyond the large folio’s
size.

By adding more debug information, I found that 'nr_pages' had overflowed in
filemap_map_pages(), causing set_pte_range() to establish mappings for a range
exceeding the folio size, potentially corrupting fields of pages that do not
belong to this folio (e.g., page->_mapcount).

After above analysis, I think the possible race is as follows:

CPU 0                                                  CPU 1
filemap_map_pages()                                   ext4_setattr()
   //get and lock folio with old inode->i_size
   next_uptodate_folio()

                                                          .......
                                                          //shrink the inode->i_size
                                                          i_size_write(inode, attr->ia_size);

   //calculate the end_pgoff with the new inode->i_size
   file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
   end_pgoff = min(end_pgoff, file_end);

   ......
   //nr_pages can be overflowed, cause xas.xa_index > end_pgoff
   end = folio_next_index(folio) - 1;
   nr_pages = min(end, end_pgoff) - xas.xa_index + 1;

   ......
   //map large folio
   filemap_map_folio_range()
                                                          ......
                                                          //truncate folios
                                                          truncate_pagecache(inode, inode->i_size);

To fix this issue, move the 'end_pgoff' calculation before next_uptodate_folio(),
so the retrieved folio stays consistent with the file end to avoid 'nr_pages'
calculation overflow. After this patch, the crash issue is gone.

Fixes: 743a2753a02e ("filemap: cap PTE range to be created to allowed zero fill in folio_map_range()")
Reported-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Tested-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/filemap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index bc6775084744..923d28e59642 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3879,14 +3879,14 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 	unsigned int nr_pages = 0, folio_type;
 	unsigned short mmap_miss = 0, mmap_miss_saved;
 
+	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
+	end_pgoff = min(end_pgoff, file_end);
+
 	rcu_read_lock();
 	folio = next_uptodate_folio(&xas, mapping, end_pgoff);
 	if (!folio)
 		goto out;
 
-	file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE) - 1;
-	end_pgoff = min(end_pgoff, file_end);
-
 	/*
 	 * Do not allow to map with PMD across i_size to preserve
 	 * SIGBUS semantics.
-- 
2.47.3



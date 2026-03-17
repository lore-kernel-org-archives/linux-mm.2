Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F5E6F33811
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F796B0088; Tue, 17 Mar 2026 05:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E76D86B008A; Tue, 17 Mar 2026 05:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9596B0088; Tue, 17 Mar 2026 05:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBADA6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:30:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75FFAB9E64
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:30:10 +0000 (UTC)
X-FDA: 84555033780.09.5A0B8A3
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id 32D63120004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:30:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="PgR1b/KM";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773739809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NOPXzgbt6DYvEkPrO9B4OVlwk27lezTRUE3vS2vBtJg=;
	b=iYny6uziVVd0VZ4RNWJyjLuo5QGLiAECpJgyMOJNzuREevS3kpIIkPgBCYoIj6GzQAkqc2
	go9hcKEmH3eKCFKjIDbCp9KZvNjAWk8KhuWDpjIk4y6yEmeAg94JDa117OUZBpFsA/UKL8
	bSLVtqLNOapcMw7iu7Nk6Br92B6q9t4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="PgR1b/KM";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773739809; a=rsa-sha256;
	cv=none;
	b=Qft4HQHgE/eLuQYY03oQWeG0RNmr1E6bfY4BBeNO+iTgUMD7JVbGaFrAY2H0i9f1Up7t5R
	JBH/ptt1i5uYp9A6JCiwHTGUE7Qf7aHAw893Hs2KMg2VHQ8SPjtT/dZhmXJXcMrAeSW1x6
	uicjnE+QrZ2tIagZFpAIjPsWunAizLY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773739804; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=NOPXzgbt6DYvEkPrO9B4OVlwk27lezTRUE3vS2vBtJg=;
	b=PgR1b/KMZs/3YFaqWxPqpgU13UCHkGVjn5fdwOWwTCAeWAHSXeaAH9eJt3voR8IU1rKgRCUzvIwwzwJls3mcTBjT5uR2L6Zz2rjFIKTyCoZUGKMA+VJeF7W03soNPVZkpr6wQfquKFPmax5GhLHTb+5iz02TeaoQi7g1zwN3Kkw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R671e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.Abv.D_1773739802;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.Abv.D_1773739802 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Mar 2026 17:30:02 +0800
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
Subject: [PATCH] mm: filemap: fix nr_pages calculation overflow in filemap_map_pages()
Date: Tue, 17 Mar 2026 17:29:55 +0800
Message-ID: <1cf1ac59018fc647a87b0dad605d4056a71c14e4.1773739704.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 32D63120004
X-Stat-Signature: pkucapj6kdezto3cgapx1ikxcqi3e1je
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773739806-544117
X-HE-Meta: U2FsdGVkX188ELPKfU1CBOni3D2e7mbIXVfLHEjoMHobJierrrHVtY16Ak4HQPhlWnZb0micPh5QD8QMos3T5shM2GSlyOa5sdFaiOplgtX9P+DQHNgoursHDjI0c5S0Q4v9vSz2UL9pC2K43MKrOdqXGQIVgVSrrDowufqVtbJeSoRwJOHMuQMVo+KZbPcMYifnl87N5D0MVoyqyS8g/jtv9t9E3unxLL3sQEJ2bZvROnqG7tyubztTwyO+8baa2QDmp3AHqZZ/wBzDu9Utey8Eo2i7VsXtObIVlcafNkFDbsiURlC9j3fqDTER7SgtABGseqIfAI8InhDBH4nmhWce34ddIfRb/gvUW/J8KKTbAmdepkNoV/48EYfgECa4SbbpWW/pXjr3B7qfNZ3c/GeK4ysUrWf1SXLB1R9pYx4GlVoHspauBn7Bz4NF5vih2yBXPWSLQQqj8fqG9anUmIbA7WEQFRjIDq7acM01V4+fYYnhnuWSNz2N2rlyhc1l1UuC1v9FCpJBSxaVWwJmVUsLtvv+VZ6557iaAd2qnQ53vdlkdmEMdFu9ZS/hGzr8ajRNxYLOY9rCFU8BQnZIBE7IhxcnhRlST6NPvCWOKhTpxgcdCPefENyklmlQ4pPyV7hPRuoFycEHEd98VvF2mVYd57tvbs8CSk68IYjawRp7o16+z9k+Sab+VsW2/pO5a8O22JMD5TXEybxq9ZQ1jFaGJUfIxh1GGVtLHCOPehAzw2BegepZelU+kOoaBXyNG4Tr6tGcQARaglPKER6MJcxg8TeDd7XsOWEY7I1P1RxiVbif0bxwDoguqmMRIs64sC0oResYCTjIDty3N1e1sAUa8pezH3IGMTM2z8tbG5imXpITnbLZlAH59E89u5AwKgFBLHmv3s0YwZ5o+z0UsNqbsfzTP0N/q26weUmwEjY=
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
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from RFC:
 - Add acked tag from Kiryl. Thanks.
 - Add some comments and CC stable, per David.
---
 mm/filemap.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index bc6775084744..598890871635 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3879,14 +3879,19 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 	unsigned int nr_pages = 0, folio_type;
 	unsigned short mmap_miss = 0, mmap_miss_saved;
 
+	/*
+	 * Recalculate end_pgoff based on file_end before calling
+	 * next_uptodate_folio() to avoid races with concurrent
+	 * truncation.
+	 */
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



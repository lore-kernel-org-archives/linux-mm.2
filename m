Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA2B606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W/sNTsP/
Received: by kanga.kvack.org (Postfix)
	id 8353C6B05B1; Sat, 31 Oct 2026 05:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80B6C6B05B2; Sat, 31 Oct 2026 05:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A5D6B05BA; Sat, 31 Oct 2026 05:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EB1E6B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:41:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4BAE1408D2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:41:34 +0000 (UTC)
X-FDA: 85382428908.18.E6A2F92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D0ABA0004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:41:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/sNTsP/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGuRmlgdygObvznbXL/myoAOdC5nWgmQoqR4OnAPidI=;
	b=x/DGVCPp0ifvIxncCmAW4MDW/uaghAy42y7mJh0vhKQrX/M0Yde8aw3kCsvwYt1Vu8lTBQ
	Ex7xHcUdFpgiIL/07q0aZ5ZPokhqj/Hd4LeA6M3vImJ6JQlFVoKljpcs6eaSh9bTcLTYLE
	ZtnzaS+vJwyvPGXKF8G/FnbRd0C/TV0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="W/sNTsP/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439693;
	b=2e8KAw/XYp1u3qefgKEtUlDzwRdNSe8zl5pTgGMZmwiTUBT61MAp7nzoZ03aZ567tXqcVP
	pHaF58SNJ4qksjSQiEOn9FyglWTg0EkSi8ecEf6MKeQX0bMQbFv1SCXso3uWkx/dZdoAg3
	2ne3yVgUiDvVm1yjZyFbd6Ka6oTQNcw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1D57600D4;
	Sat, 31 Oct 2026 09:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E231F000C1;
	Sat, 31 Oct 2026 09:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439692;
	bh=QGuRmlgdygObvznbXL/myoAOdC5nWgmQoqR4OnAPidI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W/sNTsP/7YhZkHsnjMseT8CYQUygcByg0tOChrYtT8xBCVqre4r9jLKJJsMggx5gX
	 87O66sm7yn3O32ivd7YLpmDwG8Eo4Udl9Ytj/BDMvyxadvDwDR+9WBcmZgFKnpejEQ
	 70ZgFWnzXwU/0jds0ZxBqjkNxdU3CUdz/Hvq0B7g9y7DNnylBgDhz+rYwDgHjAP+A5
	 vGLQxFbdxzugXEW1ITC6m/jl4b7P6gn4SO5WpWBIAI2d9s8a/2KLn/rF/1x4pJzdps
	 7DJy3rVDVLPSS0VgtIo7t+cHTsYBa1ODN9LpMPKvOIoUw0nuiuVodjygzS1Js5rRgp
	 +4DTOVCn+7CmA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:34 +0100
Subject: [PATCH v3 05/47] mm/truncate: look again if a folio left the
 mapping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-5-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3484; i=david@kernel.org;
 h=from:subject:message-id; bh=56hchqGFF4LpT3G5ku/YdXRgHAq1wg+bHXHcqlx7eng=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk8tl/gicH2WyJbvsoW1Nmf+vF67QeHk5i1vrZZbu
 e2I5lk4saOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJmPIzMszYWGrxvqj1+WLT
 5e9uGJ3wmDQhevGZSWIBpxobtzYkn2xg+J+2qiUjwiT1iV6bTEZl55kFXalruXcJ1pS81ujTjo6
 3ZAYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 2D0ABA0004
X-Stat-Signature: tef93eo5ahdnu8h6zcskufnqesrinxf3
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793439693-217241
X-HE-Meta: U2FsdGVkX1/PoNUNrAKZq8Ke3Dl0NN4PPQt+lTJ3Td8V07fp5weLK/P/8EaZy9/Kksullys7sPCJ2Rv0k9zm7Z6seYx370L7UFS3KdeVpuAmB4Nvtq9oqgmJwRdYO/8Yr3OHrcrBHGmSFSTCd8rDifQbLOme3SMnmN8U9YE8sst0F88F7/bdGMwXVGu2XbVPeZz5bgBC9KoG7qCgAE33F9jyOb4bHOpPpks634/FVYGSrRP/yAbjoGvq/XRJS4xviAfyY+UypmUSrM78AHHslbXiINXms3hdKh7N5t9nRgoc+2KKhO8OGXSMHaoDs/0ceCxlvSFf5x2xRJcx90N49cJHEGzJPJpmSVUrQUyP4Ncv2qqE7hcZOopN2K7HvP4hp86W4Wk2IVYpLZ9zxtNQ+8DelLqOV3t2ohHV+loWWK/dvwI2VgPUZ/6IQtvoHVNaLyoLZi00NWryDjjkDN1qfJTJBaa1a3asJ3adaJT5ibA7J8e+kTrdiDViAuAu+vqR1JTE25lc5YLsRUXV8lAArMc0D1sxCPWnoMk4+XxpvqoeLyE6JiisANHmFhFsxC0v1A7bfvYrhbM6a1N03U5PjgnguHnrbeoL5boerwQE3nf9g55z/2RUSZTMBQlilXQokSI6VJhHhDsy+8g7md3uZet678hgfd4vNM8PTZtnGeDvhdJ3466uptCOAemBGNQ9EUeiI0Jfy8ynZRnLpYZx5kysTldF+HJ/RInA9h2iqZrh6k5p2UH6YXXMtEJsX+ervFJTFxFY3AEiof2KzrRYOwCC/s42zgjHA85/ij3rKTO0iEEtQLzHLu/sgQZglOd2WI7pSLYmTk6QZYldvl8LKiNSw55ElIo7/20fIUa93TZRHpUi5oI15S62O4Ln71wVE4ttKeF0i6H1t59c+uevolIToHWgDT+hReQuGLpwAstyjnAgqbZmSpWbQnrSl6RzDfHoozdJkIEsU52ufuT
 9w9FtgIo
 akJ+zpG3hPchlqlNUJy5qo7SzfuZcxxWpsO2YjgDz+0fYF8CnC2p6qSoCKaMowHGyCgPWtBw4U0OYAy1ivcNFG9h6DtD/eZ49MkqvqCn/quaKeUcVPiCEB5sS3Qym0jhwXW6lGnRSdCfgRxzLHk3+BlWzJFlHomDSm3oBnn6QgSBZ/7mg85uWLRJrNTkcBbVxBpIcLPD8Mtc0N/2hSxIGnjsd1lzdUfYFp1XGCN7y4wi8BPNUqUIVC7gq1jvLj3uwXodV5Z5R3pqQDVhp9+VLsQu/JfhQGuqY6Lzqj9wX8PuxQH3jk8i7wrGcos38W12ykCbN2uWPf8m7H2FfQns9xjGflei2iz2LXnsvBrQr0Lhgc0hoPrrE61qsaBMJavZUxpTdFyAgN3/iIUVYSfi3WyuHw92p1R5e5sMqsB7zATB5so5S+qN0wwcFwkdB4KV0YpuAaTsRSCMAwJgGSRnieobClgKLOJF3ZO2pj5Pz3TKF7HSFfGh4LfC3XVfLzLF+3foPS2p5ncDbEROs2/fARqa9KqwTLLHDDLrbx91MynpNGiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

invalidate_inode_pages2_range() skips a folio which no longer belongs to
the mapping by the time it has got the folio lock, on the assumption
that somebody else has removed it from the page cache. But the folio may
have been replaced, and then there is a new folio with the same data at
that index.

For most cases, like folio migration, that is impossible. However,
collapse_file() only checks the refcount of the old folios, under the
i_pages lock, and relies on their folio locks from there on. That works for
users which repeat the lookup when they find folio->mapping changed.
The following scenario is, however, possible:

  CPU0 pwrite(O_DIRECT)               CPU1 collapse_file()
  kiocb_invalidate_pages()
                                      read the folio (old data), lock it
                                      refcount check
  the write completes                 copy to new_folio
  kiocb_invalidate_post_direct_write()
    find_get_entries() -> old folio
                                      xas_store(new_folio)
                                      folio->mapping = NULL
                                      folio_unlock(folio)
    folio_lock()
    folio->mapping != mapping
      -> continue

In that scenario, the collapsed folio with the data from before the write
stays in the page cache after the write has returned.

This used to be impossible, as khugepaged only collapsed files that nobody
had open for writing.

Restart the lookup at that index, like shmem_undo_range() does. The same
problem seems to exist in truncate_inode_pages_range() as well when
truncate_inode_folio() fails, so handle it there as well, but slightly
differently: simply check once more through find_get_entries().

Fixes: 1b6444331beb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/truncate.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 733d2713a875a..9e9bf029635cf 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -475,8 +475,11 @@ void truncate_inode_pages_range(struct address_space *mapping,
 		}
 	}
 
+	if (start >= end)
+		return;
+
 	index = start;
-	while (index < end) {
+	while (true) {
 		cond_resched();
 		if (!find_get_entries(mapping, &index, end - 1, &fbatch,
 				indices)) {
@@ -499,6 +502,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
 			folio_lock(folio);
 			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
 			folio_wait_writeback(folio);
+			/* Do not handle errors, we'll do another lookup */
 			truncate_inode_folio(mapping, folio);
 			folio_unlock(folio);
 		}
@@ -760,7 +764,12 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
 			folio_lock(folio);
 			if (unlikely(folio->mapping != mapping)) {
 				folio_unlock(folio);
-				continue;
+				/*
+				 * Folio might have been replaced: look up
+				 * again.
+				 */
+				index = indices[i];
+				break;
 			}
 			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
 			folio_wait_writeback(folio);

-- 
2.43.0



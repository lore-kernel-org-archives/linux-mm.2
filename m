Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D455560A2621
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h5YlBqSR
Received: by kanga.kvack.org (Postfix)
	id 0920B6B05BA; Thu, 29 Oct 2026 16:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048C46B05BB; Thu, 29 Oct 2026 16:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73A36B05BC; Thu, 29 Oct 2026 16:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCA146B05BA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:34:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51CE48043E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:34:46 +0000 (UTC)
X-FDA: 85376817372.04.FF65CE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 867A7120006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:34:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5YlBqSR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8NeWgKC8rFJYZ7CY//H5MJ8mlDLPVUlB7WRXqG52bhs=;
	b=tFb35Cba2ZO9SdrPvdhEMSsCtmytYlRqAHJw34Aw0L7N54PeqYSmcwfE6YcobZocq0G+6u
	PrJCYxWgVWhMlG40CQCWP3oHErNhhh3sCqimjpeanXeT1mU5pIiLPMZmBiefvhIu1DTogo
	FbbPhGlmVOZHoh31stQELc2kZoAe6rQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h5YlBqSR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306084;
	b=oRV9MQkS174FCCThEjWuPWXPHVERsZz56l0cvKIPubTS/Mc6QLCrFSosvlPqYViJM3QAXK
	T+zHVtSHM5mgR1GmfPy0JzY49aq1L9PnxXo8WOCbhCEvchsWvNL19za8uHGEfM8pXNbqU9
	KMg5cpyqjX1RuTa991NFzNIeyJ6sRQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC6004190F;
	Thu, 29 Oct 2026 20:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1371F01825;
	Thu, 29 Oct 2026 20:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306083;
	bh=8NeWgKC8rFJYZ7CY//H5MJ8mlDLPVUlB7WRXqG52bhs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=h5YlBqSRsRQCrhmhb7220/BdTpbl1XOfJ22+z1dVZFlRKfbL+drAxRpvK5BSKbiqk
	 z4Yx0Re+/RHynvRBIbM1ppOnJLhfWmgi513P3ua5Wr9IbSLQ8emJZl3Yi/oNEiOcR3
	 hej0anVMIrPJH6EUcTvHJWuxdJ+OMBQE2DpDrm0QmaVdek3+JEirmytsKmT42UjcWp
	 Cto2aIPZHz2WPdzD6lBNoM479P0R+mPiBjCn083hWSKlAH1IBn8toFkmcHR4qEDSMq
	 3x7FIDUx5x9Hf7AdMTO6otEaq/aNaHmVondhDFgT3OpBGeXkzBP5HUf1Z1lrXn1/5Z
	 r2urf3Jip4tiA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:00 +0100
Subject: [PATCH v2 05/47] mm/truncate: look again if a folio left the
 mapping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-5-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3335; i=david@kernel.org;
 h=from:subject:message-id; bh=8zVtiTIPHUHGhLtYGmDF+TjVfOwqhbOhyrdIJGBJe/g=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer22p+/bitVtd6s75Z3g2zq/IlNg9X5CvRELkVamsm
 V7AxoMfOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjI36uMDHfMu/aWOrHVagjM
 981Tuuth9qL13rEDrMmT/086Jvnv+ytGhh02l8sV7tQmRFyczcXj1TZlj9uXvw4ej0XnNipX1fN
 acwIA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 867A7120006
X-Rspam-User: 
X-Stat-Signature: 5ipw93ff68arzoi6ywh8kujue9e156ne
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793306084-830538
X-HE-Meta: U2FsdGVkX1+wA4fRWGWAMhald9o+6ESp26c71228DZ75m5bL600ivUzngNYpY42pJRQ7MfHozMhW4+jb3kpabLU2FunGA6Op6ZbTITHKQ/6iG1vntEhxNNIjdDfBec7VuTUcRpdbMlq5kd9gAi6GYH8mJefA7NK1nWBVFMgQuhs7qw0dODo09J1HOtklRmuoop7KxA6U54B2TNeaYt1fG1dZd5FIk+K+eFUKt4AOCzaKuGuPgD/IKiy90pHjXxUY/th3F+JDOgN71nXqc7TjKKaFitbb8quAfyGwc2yRcjziraOPP9/WzXnyHbX6qz0JnFmCTyaNsySKNeIUf06xJW00DHLoMSxZ5j6bC/fnTxMe5kFOUcLMP41ZMNG8NlA3QsF0VChmPWQzQQK7+eq0romg0Vi7cZaFm3Yq/fJ8xu/W4ahUTjKkwQJH2mjP5K4hBiIZSSqleSZ8gwhdtHNR4aRvW3LxOOSGe8P1X+9EkA7c78AtywqwvNolaNAKKxW+jO9X3RmOMpyclvPy/dx4ArwTV0nmZFQzkgCFWsSraCMmEE/GL7f83sHlcXmqhdGAEIhj5PgaL75PUnDZ9O/4zJhHdPYmc3IjZ78DcsjkOD+LN9FhwRdrXK/wQoF0Z09Ao30w+3rc24aYBGaa1/ShNCKvL7n5lFJiVJEYpy9ILjQFrHi8FRXfDT1JQ5Rr4UQZAtWvjfKWdM4g4dZgXxsC4BXlDgEuAiWmVj+8DEo6lXIwKp59Uon6WWBiKt7TUx+iwfX46lIevAHqvSk4lNBaml9v96vGLStPEpPo0gxlWiq6wZNgEQKdUGPPt5VbBIKUK/KF6K5EOsCKIr+ivirxuqyvOffiZ5v/e+GpTbOGT8ihyJnJ4JfUb+z1o+QtR52vc2Fa7jMNd8+x5CakhWJpqO/t40ZmYCsuAyO5mrE1078QZMz2q/ZE/2JvhHJreiy9mCFiXx/14q9M1NHkuo5
 xHaUYzog
 oQkhVCQNM8XJ7hRDYHz5YdERSU1PRDXv09ShxYmupmkORBjg/5tLN3UCczihv3jxmL4mVQtnyXuJQR3rAZsWuDIjo8SEJxSS57s70g7jkP2D7SmR8uFwCyJ3LES/SeddlK82oGIC5daKeo+aTFZaygZKeKkUaLhLBDoDdWvj2gzNYOi08ddW3JaucrgUJXjsONKcIvsxTzCMalpUF/IwWgYJoKKorxfrxtXevudqeLR6ErOK/rYaktnM5921GSZ+JPnAnBkACzmpFJI0kJM7BJkftBbSrRCLzkAZHa/34AIOAzz41WqemtUEQI4M8BQlWl1B8R+6xla9RVCyMzVnTblosqHA4nh5VB/nm8/BaOyXHMHIvVqujjQJU8qWzNxEdr1Z30vzY1jtC1aA+L7uNetOTKsmMcdecd897zBzWzkwTOdesrcKTrNSnyBCnH5IiI+nmNgtZOVWc0WgK6D1WBy+IIA==
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/truncate.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 733d2713a875..9e9bf029635c 100644
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



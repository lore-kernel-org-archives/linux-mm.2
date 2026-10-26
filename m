Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1165606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I8iKZ2Bw
Received: by kanga.kvack.org (Postfix)
	id DC26F6B05BC; Mon, 26 Oct 2026 19:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D729C6B05BD; Mon, 26 Oct 2026 19:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C60E06B05BE; Mon, 26 Oct 2026 19:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 915416B05BC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:19:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14F431C425A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:19:32 +0000 (UTC)
X-FDA: 85366346184.24.76D462C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 45C7BC000A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:19:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8iKZ2Bw;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H94VuGtG6BpRFhvFPWMMDLKdr76dloMuoWr2DscOb8Y=;
	b=wVkxvpsuCQfrY3m8OvXigc5RJdtBFJiKPXS43s7QqvOpP+gLo95hO/f90qTak6zX6L8Edc
	V9up/3McWBl+boEkyf5jFvs4QJolnZ9yri7dy155yg/RXOYJIp9JPubyIiFQgDXi9T3MVi
	5BygcYVCKYCcn2EbhYIQyLdcz+sOXNE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056770;
	b=nBCviQB/DIEVCgsSjbolYqMcK1Lc2/18uguxCsRoYRd9EmEojsYEnh/lqCdWlU1+ewUDTj
	DTGRTfjbh7aSLxebvV5CU08yQCaNlg2TABH2YrrqAv0KXaDp9dBzQqU4hqdqyGdc8lMjjH
	V3G8zBJgXFmpNRseOZpucohRtC5mG9Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8iKZ2Bw;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8687143E9C;
	Mon, 26 Oct 2026 23:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213BB1F01828;
	Mon, 26 Oct 2026 23:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056769;
	bh=H94VuGtG6BpRFhvFPWMMDLKdr76dloMuoWr2DscOb8Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I8iKZ2BwWhRlGZKB5MDnIdv4P3Hsc5OC2Y8e+6o+Rsh4VMxS9ryGLhNAlqek22Dzv
	 aOPMjgNb3WIn+nbeA4Bl2OmEam6tNWnp7KP4P7Sq1Otq6EAEt/O6Cj5WgRFOq/NfHL
	 yBlHn5kU3RWZscpHxcqsXYx72K358Q3ElDuWj6xww/Ko7kKUPtLC86boj4WebUtPkx
	 xUkJamkiias1T6VaQVSwXWqfCm0Hp/O1QtXuUJ8+Z9MZCKAh2yqRJSLB67hCMzLNcP
	 SK31F0/mluevSG3880IFFKBePRADDkMxPRbxbohBQaya9pGvGPIvqBFBnXxalxeImC
	 /O0s/E/Fmnv9A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:25 +0100
Subject: [PATCH 05/46] mm/truncate: look again if a folio left the mapping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-5-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3123; i=david@kernel.org;
 h=from:subject:message-id; bh=LCXJvaCAxM8DYeEIbqCybn9PrvO5kcWMg/840Mus1kc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/c8ljL9OqVuwY9+3suFMYJTzv25M8VW/u/KRKH4
 g0d8qyqOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjInEBGhr25c3sdnCbE9kXY
 7Lby7DvHeGTLeZsbTo/qpQ5tmW5moM7wV4x73/kDyy57H/0wL6f0q3Nz/cVdR5zMGn/pftq/I7l
 0AwMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45C7BC000A
X-Stat-Signature: hwip363ii7uxgxr5xf7jfwm3ndn33oyw
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793056770-278432
X-HE-Meta: U2FsdGVkX1+EmRhYCLuJQDyxoI38SO3fnPg/TwbPrNjgMnbjyWsN1GEEKYTw8PBUDu7+dYGxWaB9skEGa0RGAJIPKdAC1lkxGu85YmNy91naay6ZA1moyS2QSFVxD3kn3T1Uk1tWj8lNNxrZhqskVk/w2+xdJawHniwIsHxDjvzcs1qpQ9lROZcQu4K29wSLiShUoUAF6dO/Yb6lEg/eifUqwvfB1luUqJmdMDkCv9vavX369fkFeN6XAuqgrGKuY7HqCtAjtSndYhnGVU3W28WU3TLGagzxyuyFH4pPGQuAXh57L8o8nA1177tLq+wqf5p2m369OLUnXeXq51ckSE3Fjswrciz8yhhATZS71Pa4jk776cDhyLpN7HJK/uOhEe9q5JTRwAptS39IIgbRyobAXx49AhHaTKtnje5ECnXh7zZD1wtUk7dL80CsSuLdwRjVBqAUF2mEsnOne3KCSdM4x5hEUgU6L5/9g5Mw0A4ykjEWzh7BrHau8bCe90loActoeiQ0hQRhWtQEVQXF0oGGm1xbh/F6Tm4/hJzhaQVwk03ea2YJecb20nULwKkmigU6bprjbC5dM5SWn78vNGdl+bI/zvHJH5dm/2U6c8BAFz97QB1krzjc6v3P9LQq/9z9W3wUe+ik2S/IY5lHWUMFrmo9zI9G2MWymfcVppV81W0TU11DxpudTjSJ7sueKHwmAWoJYhWHkKypma3Uy23p59MkFmT65xBvbce1JU/csn2zmcX3X6jFSFFP+jlIbcIQ42BROi+r3fVtJi1qKfHR7VX+eovuxcrD8/HSK8WaZuO7xRLT71VRJYylgkL9ZC1dAVoe08krR1mpNZ1FTXMGbLiwLvNE/A5Bcj+htCEh4okH4Kh8md2D37PqFc6x7XKAuxuXJkEv/JXX8NZs8udZ9W1Mh1h2GUhHaXtv1BNsX6WbXd3KI2zU9PcngGS3XlAcg5pPVjj/Nl4vW9S
 KdMCsmrL
 62ekoLzJjtOqnaFva/qzPzXVCDkSTA0ADJOc990LFBkyO5HM+C7DOgmBXQUoxPbQEGcEshqgyQfGRuv8pbL5qw5T7J+mwA0c29vzxebhbIiV8LKq7xUVnsBvtZ2/4aciFyZ1YLxZahTGZmcI4/Pcp0HBepPRGw8VN7B75/eCKSGzkgdXUGGmjI7AgjEOoU795kKxqulrMYT+mzEziXrUCJjEgbypIYDDgl3FStY7FTLtvY6gSL6mOgXxbafj1gNRqBeOMAFWhchG3Lok5yc95BHwcVBUfXR4km4axSZ0z+5yHh0x+r/ZvJtF4gLB21cndoNRjYFTAVAh8VLC3Q6Mp6Ofzz7ggeP1dJkuJ83pc4GMz1xYUha3cd0PKCMwbn+lI6JjoplouInomb0vrXL9aE0zUsg==
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
    folio_lock() ...                  xas_store(new_folio)
                                      folio->mapping = NULL
                                      folio_unlock(folio)
    folio->mapping != mapping
      -> continue

In that scenario, the collapsed folio with the data from before the write
stays in the page cache after the write has returned.

This used to be impossible, as khugepaged only collapsed files that nobody
had open for writing.

Restart the lookup at that index, like shmem_undo_range() does. The same
problem seems to exist in truncate_inode_pages_range() as well when
truncate_inode_folio() fails, so handle it there as well.

Fixes: 1b6444331beb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/truncate.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 733d2713a875a..6d8c0ec4623fe 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -499,7 +499,15 @@ void truncate_inode_pages_range(struct address_space *mapping,
 			folio_lock(folio);
 			VM_BUG_ON_FOLIO(!folio_contains(folio, indices[i]), folio);
 			folio_wait_writeback(folio);
-			truncate_inode_folio(mapping, folio);
+			if (truncate_inode_folio(mapping, folio)) {
+				folio_unlock(folio);
+				/*
+				 * Folio might have been replaced: look it up
+				 * again.
+				 */
+				index = indices[i];
+				break;
+			}
 			folio_unlock(folio);
 		}
 		truncate_folio_batch_exceptionals(mapping, &fbatch, indices);
@@ -760,7 +768,12 @@ int invalidate_inode_pages2_range(struct address_space *mapping,
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



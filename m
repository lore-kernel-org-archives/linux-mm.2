Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5FA606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EiymOOf1
Received: by kanga.kvack.org (Postfix)
	id E2DB86B05D1; Thu, 29 Oct 2026 16:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05026B05D2; Thu, 29 Oct 2026 16:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4786B05D3; Thu, 29 Oct 2026 16:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ADB3B6B05D1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:38:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB954A0559
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:38:27 +0000 (UTC)
X-FDA: 85376826654.05.7A911C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1BF8C180009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:38:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EiymOOf1;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306306;
	b=562laf2Ct6qAhZvtdWBMT1aMFLm5CNw9ugs5PZQM1/zmXqmr20v3IJhy54sMjUClcZJFhH
	PUPWRk/uShERMU/JtIyQNJc/TuA0vTPbtGZ3VhzXdu9e65FH/F2RbmCXoIVe2usz0yS5rA
	XxWrOMfmJgs2km+y5ul9DsS3qKBaXp4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EiymOOf1;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LChJhAJsDDfexlAYHKUAVHUVDc3GJJuoMEB5JjLFT0=;
	b=YJhV0xIwvK0XxbnAGgvqZWmQt1De47+/SYQVfGfshx1SYNcFM3xALUJkIDSe2GBIz3ok+h
	OPmxoeQsQphNqCRBpUiZAOQmOjC6v3noCX0rMLDJTZ/sPj3w+AfnlmCNvtHjFP1VN2pH5Z
	pTtyAykjJXthO9ZHG0dpSYc40635lZc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 755C5402EE;
	Thu, 29 Oct 2026 20:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB90B1F031E1;
	Thu, 29 Oct 2026 20:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306305;
	bh=5LChJhAJsDDfexlAYHKUAVHUVDc3GJJuoMEB5JjLFT0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EiymOOf1SFIZR07XNBmBtHsUG0/cxXyG65vmryJObOllY9qU0p8fGOUCf9T0+Blo4
	 iuWy5eRyHj0IegzchsZXQD5nozYmCXJ5q1tsWQ0Pc/FYEqnMkThdZp+/zgPF7cbvsw
	 4fT9qHtqSTab/Az1DiexmECSM1KXraeGktomLCs5OoqCWztAfj2WpEt+lSYnm9DMEc
	 kaWnMTeNameuxW6FWQesNXBe1C5PlKeVObJRyok+DLAT6FKviiUGSnCw8Kf7bALfL/
	 R4xYIxQLXDB/0dNyiXHgI14izBnV0Cj3NTEMEO6yOvFAYKUjGO1r6sZe2UYAavVeFq
	 3n5M6kwtAAStw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:15 +0100
Subject: [PATCH v2 20/47] mm/gup: fix clearing folios in memfd_pin_folios()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-20-a64ce7f83abb@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Samiullah Khawaja <skhawaja@google.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1672; i=david@kernel.org;
 h=from:subject:message-id; bh=a21vFMarzFqHDX4BmPSywjRcawxjg3B/znX9a9fmuWg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer21b4iudU8XlwJNx/Lt78dXMqeZrmIou3DJ7uVzhx
 wTzd0U8HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkxUZGhsOfD82yeXHR80KQ
 up/Hmckh/E+sHj0KWM/QuapkQcoXNj1GhhvSVyfdzJlY0VR7+vnOucwCMvL2SZ9a07fNPzllOps
 DIzMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BF8C180009
X-Stat-Signature: zez5b1wc31x67fsorincfaq47twp4r4q
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306305-155464
X-HE-Meta: U2FsdGVkX1/meFl2lKVOsjrX1XG6gjAPLgQ9mg1sew3VBMRcR27shHBkyBUE3NuRtGUfnbpj/+GOfrteWfvnBkIf3p1dug8WC3BianOM/PIh3a3Z0g0Siy747gSeNHdaKla8PU/IKYMqxfzpm3MXOGwqL73dyOO64zaF7C/nx3G0T3W5k4RlxgGbWLshvHA3Rwfl64VpSOBDjR0Eo3+ILDOwQQzpwhcKnqMQJXpUBERrW6QMuGH3SwFY2p8yzwNZ5EEgfYlsjK+QktsE2ro8v8TvXjBJpSDuUlxc0yElE0qNWAFRgDbO+177m9ZbN9Ms6BH9S7Xa9NN6wWDdt/n4KyIxPS3DxQ5oX8ZyTHa0/MwCWLjNc7QGLGilAZjhFnINbva1hCFRhUJ3YHwQQCshZuYFq3/BKlvE5KKoCGOpgjT0FHfVg7h0iZ9X6MckoeG9vvjJx8UuO22qkJA78BVBCaT7/PW2KpCt+rCXX8BE8Ppt9JRjf1nDNZ0EifzYtx4p8y9Xwe97MUmLbl3sKqirBzOZlocwA1rMk5Hm3dS8xRYE7fEwdyC2D36ArcphStRp2V37Oqfi1GtOlHQBWn8GxLnMA8zHOBkzF6fnXnsI+67ld6pS0VaZBEn6RgSM5saCDT6AFc6MWkIWwIINeJPbY5yoPk26zikrQhUiE4HzG46Pd5UFog7+WpKaYacZlHXA2nGmc30P4Q9vN2fUz/rbZ9D4hIwpzbzZpON0WaaR8NCixRaPCpj22/mJ804hB7PGNFgGjfzgaDlrT3IXW9bQSSt9hB9o2K2XS4PTw8Zl0EUAZ5HOi1tEQvk09uQemfDHlmQeZ5Hn+j631KSgcXUwLQee808CiCGcQ+vBkCR7bv2MRnBprLIjyHNaaT2aIRaNSbxvbK+J3Dvczqu4EDa00gdswabFGMnnMJL8gR3rgZ1q27NndKmPBib90o4sWMOQo/IoZoMaYsJvDDGguy7
 LSZv2ak8
 Z5R989JrD8hL/tsJRFAW5wPEsPz94UUAEHSjwOVI1Iea03RF5CPNqZLx2DWP7lTZC5lICImEc0IYHA8z91UUyOcAqmH4oesMw+o48Wb+0cmyrTSHiUYFdMKbe4pHKZvq7zv48mnU8BKaI5WJcLpMBU2IXEcZtd0QrRfC/vIm6UUgIx+MxBQycr5pq/S5Fm3n1wv/PsfXhTZWUX72NQYau9WNG7wuqHvJTvDyUX359GAR287Pa2PSBQB3DJSB9LAMztM5rueN1MIfUaM6o1be60w9ut1qZDCK2pcpLTCku1RKnOzfNmu5zyInr4/RA5Y2jilUVrhgUNEmawOwnvqyb1ADACVBJicWCdIsxeM0R3WMQlfzN+z4IoRW+fWL3w8XlvSqO4OjKsYKUlYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

memfd_pin_folios() pins folios obtained directly from the page cache
without checking whether they are uptodate. However, shmem fallocate()
can leave newly allocated folios uncleared and not uptodate. Callers
such as udmabuf can then expose uninitialized memory to userspace.

Clear non-uptodate folios and mark them uptodate under the folio lock
before returning them to the caller.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify description and comment ]
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Tested-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index f809361227e7..cc4fa18783ce 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3527,6 +3527,20 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 					goto err;
 				}
 
+				/*
+				 * fallocate() can leave folios in the
+				 * page cache that were never cleared.
+				 */
+				if (!folio_test_uptodate(folio)) {
+					folio_lock(folio);
+					if (!folio_test_uptodate(folio)) {
+						folio_zero_range(folio, 0, folio_size(folio));
+						flush_dcache_folio(folio);
+						folio_mark_uptodate(folio);
+					}
+					folio_unlock(folio);
+				}
+
 				if (nr_folios == 0)
 					*offset = offset_in_folio(folio, start);
 

-- 
2.43.0



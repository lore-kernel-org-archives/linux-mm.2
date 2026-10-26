Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD6C606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P4AILRgQ
Received: by kanga.kvack.org (Postfix)
	id DA3F66B05D3; Mon, 26 Oct 2026 19:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B3C6B05D4; Mon, 26 Oct 2026 19:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C914A6B05D5; Mon, 26 Oct 2026 19:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A193B6B05D3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:24:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A931C088C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:24:15 +0000 (UTC)
X-FDA: 85366358070.26.DCBC306
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B2131C0007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:24:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4AILRgQ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vwVoCZbunPi1dkOYnN4mDEZRm3BRTq8xmS5X7w6cP0=;
	b=4gQhi32q9rUjYGmRPdv7OsbfofTd2bDvTrcshtpHIXDHpIY4vRv7RWljRyFdqSWdQ9Fl0G
	aLhVLRgXdMDxSAbwn1sGx0GfuPt44BmWpj6tdE/5t+QnSedmU2jT/imM5x5P5+GYJgpHlg
	8+w2kUoxvjUOCMEtoJHylRKmU5/ujq8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4AILRgQ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057053;
	b=0YxXXtjtrbcROBDAg18HduKD+j7Ubj2XOgeX9saQV7YVBXgM8Uv21UUJ6WA5uaQ+c0BIxl
	baKbWuaB1TISofut8QLVIfqVtMh7Uj+gpzMtqOA+zvxR1WrzbrhrkEr6raIBJhdSi2uoxn
	QSWnwgm54El6TERSHpHbP00EhOrXYG8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B45540D94;
	Mon, 26 Oct 2026 23:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A2E1F01825;
	Mon, 26 Oct 2026 23:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057052;
	bh=3vwVoCZbunPi1dkOYnN4mDEZRm3BRTq8xmS5X7w6cP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P4AILRgQaj254wrERwTFGmRjBWG7uy2v20jCOaBuor4u27mNsgkUFKWatsJDumVTU
	 aiE9TuGAExA2XiuLQZMk5Ccy5Pf0k1lsY1w/uoerD9vH/vSMcihFDTWSu3961I7Daq
	 NR2tu4oCL8YilsZnU3zTrqIIEEGTzFiY6Z3Eg8ewjSRaTMhs8B0d6tJlITa3zX8kCy
	 ErZ7R7QlOE9HaG07lCEecT8R/qxSlqYFRyzI0xlVdI4++v3ZS3QyTHi0gU5Bery53s
	 DUuMVz4LtDXtp1QBbCnCPlhIxw0rZXkaevhunTrcBTmBYnvUtBD4UigNKtQsncyiCL
	 rrpCbfmit2BPQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:40 +0100
Subject: [PATCH 20/46] mm/gup: fix clearing folios in memfd_pin_folios()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-20-6f74bec9a5bb@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1508; i=david@kernel.org;
 h=from:subject:message-id; bh=xxpfXnHcN1JnhyZw3Nbb6nL1MoIOUrIKvtj9v3lNKrU=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu358aIb7XPPhYx3ble/wvHDqWTc98vLTZ2qqbLfOP8
 7GlgcvSOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZhIWjYjw43Ai9auDCevuN2P
 7y3rOM18ZoZ1ww+/Qw8UeS6u0tMr/svwk7Hb5nyg5+enjJl3jFhO15RbZKjfnf81a/G+uPgDGds
 vsAEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3B2131C0007
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: xgg579hffbmxmwy9upnjjpn78dtony4n
X-HE-Tag: 1793057053-36897
X-HE-Meta: U2FsdGVkX18hk0dn+57nc/DzUtEusLugMqzPaytYNNmqZ9zD8dopqWDugc35fSiPRKcsJL6idHsd0g2t/3iP2CXzH2h2n+OVD0OJTqTmVoZKPJ3pZb3S3DJA+BawxtFlXOUcAw5TpkBmZv+y6stYR2AOfQgf+LUo0MmymBmUIs5tekAtkkR7orDoN6QvYz2KH9qiwqiYpDIl+9aTEt8TUx57H8UJss1GliCPYcJThF7ron656uG03xs2NgypEFAp5qTR2Ty7uG4XfAnSCSUqxJLVNIXrTz5cEbEAQtEd4ulYUS76CEaVBDceXiv7fLDuusLe5lIlephI6Y4XrwNzaLyYRyF7I2v8Z9hYEZJQ4TyBViW3r5ge0SlxnETFcdCsC3Zwg3+CIY/GGVMJGHV9BnF9MNHzw3V5S8msDr9vt12sJl+zBKRRmzGKpw1UMBvdS8wCH2YUsHXtCIQdIYL1bMzH5siHbgQ9gZbpy3pOkygYAXX6UfMK6zJoTp4gBAipVGmpOX9COjq983d3+ZdafYjami2rqjIL+G/rX1Is9nlZKvfoZre7fqO+/tjP2rkZkDb/687UjRsG27eBy95MJx7HhhcQJWL/erua6voms1fhUXMzk/nn5e2w+6fo0BhNE49kDx8WFW70jT+QW7ZAGbwpYXUtAAc1xPTvZOaQOHLgnPe/Kz4AMI7xmtArXT4aKfKutEOlGY7NshfN2oaaRwvf/mhu0L4tHe0yGH9gNB4W79rOpfxcdtLne+lJAI+Ir8uQkDLNTuMegAsoJMBWOKytJJCNzVYRvWtQc9OqguN3HkYjdQ/VmbA5n6nfprmzjX6ErKbInuWnbAIOGfGiVUaGcIGIE4Knbx4+Tuo1uzAxhbUWWHH5fQVhFNPGFpbHhcUfZTjxucdGiC0ING3yA0OQti4lo8701uAULA983+xbp6mOhacNsB2W+mgyfJtoUcRqomkd9/OLu3FI9nW
 37lxyk23
 7oN75dy3efjs8t678WpyRDpa8HZAXxhj2SUAB1hOKju4S42Q+dvh8lHMMaUdFCU7rz96aKA64IqTgmXCe0DxlANpQ9EYCHG5Wgc7TPUZZ6Uqc1EZQNSv/sdIupGqEwnN51R2g31rxkxCnjVJYkAbuX34ab9YQwS2fg0CRdu/ZH6piMHoCNCktirdl6t1Ng6EObnnfBNewewX6pCoU3eEKxwv8XeeFjzgcOL9zj4yMaEYJWdorvhACjjeIPnGgBEmxc7jpqNgnzYyGFlej3M6rWJrLG4XQ05Qib/jq6QSnm/wuni261fosTZmkH8uR8/xHBAWminhZqUCJahFR7baIJyiKUji5IExoZ7ZaSr7HhwCSCVU=
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index efc9aa2654625..47e7ae152cdf1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3516,6 +3516,20 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
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



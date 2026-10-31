Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4545606A31D
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I+u/qiUF
Received: by kanga.kvack.org (Postfix)
	id C5A986B00EF; Sat, 31 Oct 2026 05:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A716B05D4; Sat, 31 Oct 2026 05:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFAD16B05D5; Sat, 31 Oct 2026 05:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4B46B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:45:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 134211408BA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:45:30 +0000 (UTC)
X-FDA: 85382438820.19.9E9C23C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 308F3180002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:45:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I+u/qiUF";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439928;
	b=8HNAWvoIVehWUkl8u5j5b1lSd05aE5l0Ej0SCHBOcm1PxL9bXo4u+ZOPlcmnY0FR90XWUz
	gqmLc+OCLn/otBC5trYngMlsXgCfUOIiVQm1d08Xc3/1a9cLqMDyNWnebARFVrwqngbFou
	lR0IAXoNjT3OocThn7BEqDxImme9X1o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="I+u/qiUF";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0fOCg32ZVxaPUOTstAI4PWBunqX+FIUzQ1HDwJNXX0=;
	b=cRhAr91Fy6ldqb8cbeJW/0njOXzTvHwdWum9e1vqnvAhut+jmzQ7HTgvw49pTYOfYItNQk
	FkBzU11/K4HiNtT6K0edgOxGfs7lEu7SRoZl2Y6ubqsnY+7mXyPoidRbNcfHvGmmNkIQ5L
	Wx7gW3f50+al1nZhs0I2r/Qp/WvcVGg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B0184172C;
	Sat, 31 Oct 2026 09:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB241F00A02;
	Sat, 31 Oct 2026 09:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439927;
	bh=i0fOCg32ZVxaPUOTstAI4PWBunqX+FIUzQ1HDwJNXX0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I+u/qiUFq55Bqh/mCzeRdaNEZVbWz2Cez27DLAzD/CdZXTyqmB5bYm+Fl6qEmq2Z2
	 WJvwseUo7zHKYRbWt9Rv4IEnwRIhPvMDh/PKuwrOafaZnW8X/5pqr5Bkq9YF7RmOYS
	 4Zei8laaNlZyX2P2Q6NUKdD1GbEww9ZjP+y70mr1OQYlD1V64LRxmdqoaSomaV2FtX
	 CQ8Ic3S0l1ZmuJLSZ0I7IOLDDtdlEsNfHC7kEu6Ki9oOfT6r3v2JnYREAy6h6bHLWn
	 X/ei8Nn0JLhG5DT/1yTYHYlsyj1adY19h8G8Oq2LvYsF7hvt7JNDTs8gKO6F2XpwYB
	 apJOtNdWZXBwg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:49 +0100
Subject: [PATCH v3 20/47] mm/gup: fix clearing folios in memfd_pin_folios()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-20-d6437171ecc3@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1729; i=david@kernel.org;
 h=from:subject:message-id; bh=xcEwKBas+pY55btjstA9an0JLHBAjCwLiQD85ZwKAMo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk/P5eswTLp9ZXLkC/9lrHE/q3ZEFgpdslmWPqPj/
 eeCtB8rOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIgjBGhvvPd/1JS1pZsSZj
 4YRAc8n5JzsyOWbXbgkOuvGe5XSddzIjw4NFU/SfrmJzfKdh3SrxLb541d9lcemla96uStcJCCu
 cww4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 308F3180002
X-Stat-Signature: 8hyhyceh6bfz8ntqc7h7sk61uk4ebqd8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439928-277836
X-HE-Meta: U2FsdGVkX18tbe/ha/38BJeWtEbAW1ZxaP09EvfN+dSsjr2GhX8bkfRouz1A+jSxOcdwPDaLUnEfsBcXIj4an8ENdk4SK4xbNSK5VYbxR57c5DYWrEdoSv/8oqlbPoiuvTmZVm//jhsyK37ezYbK+WO5IMQJg2B7nleM/hMNoyhqGzpg7KRn2GZnWVG3lEXXuCjn8dQDRdBcz29ss+eVEz9vGYGIkgU9jePWW+w4l+y0dOcCydFMZStSomV1hjz29T5by3NJaY6rUPMrlVETcTqCfkEbeW7RV60tIGgeVrJI8DuQCIWmN48S5m0KsMiT3lKHurKZDbkKEgtrdRn8l3MLZUYJO+sEQDJivUdx5p3K4vG3cLmD/9McnlGhzZUsfo7vzdVKZBdkRtQ++Ac5VIhBVxkhcNpNg4k5MA9ybhcN3vuAZwkJW6/pKugXFwwFvN8HuIWPVHpd5MJ0ibdKQoSOvGFbVOMb6+vYQMeg2rDsjDg4PyyowOFgQhvRAHDJ43vi0QTOD6fD0xBKDsTqyBBpF4HqEo4Msi5JLvvDnTKidmJ2Kp9KNOe8QR9xdNzC71rCH+Uz2IpnoODIgzh4l/VKgKubj+lEL6ci4QP7T8IJlfd1/zQ0YXv4OakHRPcX1YnzQ/j11yqNKnLMyLG7FWX4Krp+Z/iXGOc9TI4JGkPIsNEY2Tt4t3pXsxG0D8iY8ZlD5mdhqOxpJg8FVhS3OkXnmFOKupNPe0xda3ep3ydlk6lj4q+kSgCf5FRJLQsAVoS1JKZvrJBge7vciIWWaWxBekmU1BNNsBocL+6jJdQQ5Val8HWtZ6nkwKP9ZMsA43MU4AsCXeyf9IdcFxmtaUqoxFSsUgKcDS4J0A4DOX4VPeFY+wrjPMdIXiZJzo0Xycq2yAJB9stWxZNyp51t0C3SkQYGKWa8MyxaZsgXmUMi/cVflP8huxDkN3FzmwQykoXStD0O4XN4TojlgF6
 EDmheqbZ
 rY/CvRjMmIPZXT4WOPVOgIzTyiOQnFXpvJxWa1ZIR76sR29LD4yJ9CwqUVyOMif1og/2S8q6iW5ZNcbLxiSJAEf3AxKayA6kBY6hgYom48xLGlNAnMO5+FNkQbvDnsSMgGExk5oEaSMqK2BGf6Rktcgvrh83sQnAssYdGolpwp2H4EOBVma58vlSx6vvhmNEHjAPfVnCd3X2M4jx6Hq40FwMlR5M5FbAQEA2Xdul/9dQH5f3oQVi0quA5YphJBZr/QBSkCtQU63jr6OqkUZ6sPnt5d/1gTFZwJma4LTrL/O0lKBX5q+g1rCkOhE3eQE29v9E1EjKQ4ckQRlWCT9ekSKGUd4rmSXLAhsVf7FdJyn4ULTmDWXYGwedzGXy4av5qWbALL3rTQsMbQ3yPe8inJsYbNIfM3D/lbEyRFINccdX2CmUWMWCfE7IWmLImbzwwAlRa
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index f809361227e7e..cc4fa18783ce0 100644
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



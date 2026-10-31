Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19508606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JhV9oGMq
Received: by kanga.kvack.org (Postfix)
	id 0C2246B05D5; Sat, 31 Oct 2026 05:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072126B05D6; Sat, 31 Oct 2026 05:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D366B05D7; Sat, 31 Oct 2026 05:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD37D6B05D5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:45:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D5A016083E
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:45:46 +0000 (UTC)
X-FDA: 85382439492.25.A9DAA6C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6FC6440003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:45:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhV9oGMq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foIE8/qjRxOslIMIVm5LWTcoDseO7kpGoD14hc0ILxg=;
	b=i2YE6XGtCyPJ7VBRY8DkUwNAEqT33FEUU35hZU2wVF2WEOQHiK4p2OR2ucncHr6lk597yV
	2/t7cs0qluytnfu3+ETmBV4i6gmkfDyLOqLDBlW3Ns983/SFBIOU8jgSLHjLbrBrxnhFro
	edXrCKH0GhVNtQo04KQUGHMzrOG7fuk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhV9oGMq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439943;
	b=isHPrYYETagnbtX39OFG9wO3ZnTFyti4YhQprLvXYN6IuYTFwnU12S1C2eQWgtgrjxU8ea
	aQF5yf4ZzAbzCSZyt32IDGEpPVr7Tad/V0/U2I3z8S2Rc9UgEAcdoJhIUipDWG3sDrUIDE
	ftMgs+indjcPjXPFFHyqG56rSGoBG2Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EFC7C605CF;
	Sat, 31 Oct 2026 09:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56871F000C1;
	Sat, 31 Oct 2026 09:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439942;
	bh=foIE8/qjRxOslIMIVm5LWTcoDseO7kpGoD14hc0ILxg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JhV9oGMqjIuZGgcbHEUsRikcUmJNTkInVxMbDD2McBF1KHRCOovytr11YurFRKmY+
	 bzpFUCXJV07KGchANo9OXAYly2i+TAjzzG2qyAyH0zYRfED/AUnwLW/4JR6ep8DOEp
	 3ob8fsc2zXmkJajPfwx9ACN5aMF4fl4RqsnmBccaStiOm1Ik3W84FuIM9kDgSEnVcs
	 FnUcTU/F9+4T7XCWF7hfPk1mhEKqJzRhHlBbv4kVrzqvgm/NnX6C0xi3dX2J6sa5iR
	 Ryhd7cB6JyGhcESjQmqHd0GH2cyaVRdT7FizFV9PWwZW6Rt8Hkhe6GmVGYIIMTUxku
	 0gFPxVWBEFA7Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:50 +0100
Subject: [PATCH v3 21/47] mm/gup: fix out-of-bounds write for nr_pages == 0
 in GUP-fast
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-21-d6437171ecc3@kernel.org>
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
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1320; i=david@kernel.org;
 h=from:subject:message-id; bh=R62eMdMsJypxqcni0WbltJmOI5kqokR7T4ahYSHS7oQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk9XufzzUt3qVRK79jW/zlzmvMenZ80MsUTHtrnHE
 7tlXOZqdpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRtAqGv6InnopkrO0IDNHq
 7pC+cvvWiW0b+d98XM7UJ9iq53RHYQ3Df69HC3Z+ryqu27DmAne4j/fJiz8+bFvAecZ3t5uDiFP
 eOk4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 6FC6440003
X-Stat-Signature: dzp6m4tmridngoairpwxdx14337hjrwz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793439943-67497
X-HE-Meta: U2FsdGVkX186bb8wkREVdMzv85HGp9h+EFaxziXU04rhbV8Z3RRVqoNGHqe5JRoDEzUv7l5ZpfQ+LlGZbVPB8/GIm0l/bmvcwLR+KSWxRE4ypEAmSyoce1BuFd6MmuhtnVoKjki4vcjfzqw6elIJSRNq/aYw9M2U6ib4RfYmkvzWcTz6fUrJ3ComQpFtfmLS6KAVlltaSh+fxCSo7l1m95jZl1duhYylPvy4KU12ZzavVMQ9vqs1hslOb8PzWWH6bRMXSY1Kdk7uieSV9sp2/wl4BTsuxZxz0WP4lVevNUuOH6CX0hJuWhkF8YhBwAkIZT/jiDiPwPpJiKEHYuO8VQ6NRZOBRi3fsbJpimCJshtmOvBF3YQrhLufcLyOh6ec3FQQ+FwnVA1RjozHXGeH/7FUMzsRVJ+isLBcndMk30XbBf5gq78v7BZO16kHfKKF0bLdzYVOZaS2tZihwQ2qGIQrApcXlVcpknM6PQYaa3KROlKhhYxO4pEPen+OZ1W5aTums2hHCZU+RgqQ+m79T7x2pTfasywysctK4egkoBWB3y70Blfzn04+6/Zumz0WJvCGYf0O4/cuOQoTFx/4azWYXhkgbuVOXAzMI3d/6NbEAEzrKkV5Xp6SoY+l8pBeEABFaluOrlLVxd07vRwKLwV4e1dzcgOj8bsOBLWbnI/6DNydc50hh0exwFMx+rfeW1BxZmcd+1TNBzFcvkkZNpC9AHeHbSgX7eBdj/jZnDwGZDAinnHYaHLPhX7xNPUQkKUit8rYZCw+Ep4sRmNYa9iFsSd02yfy7woaKJ9aERp/rTV5e0jer6rHJOP3b3pkPyZh37xyo5Rwmm1zl9+OYgNPwqUZQyoTUq5kAvjy0GhV6hFH9RGlPCdZlTLEPev7DQrQqvFK4Iolw/mMt1v7sllRCpy2/bYUr7KInabUNPYWBiL1D6QuoelRJ/cORcZ/jAJ0DLZTevRiwORhCeK
 APg//yre
 HM4NgUp800pA9mQZN/yt7K0h7XggikTKqIDUAwRl5yL3DHnMwPGxSyl0QLpkCVixQ7xuAI/QYUS4ywI/HqMgN+DIz4jupCxezJfMPPRuFi+miPuvvj9P+QGwQw6yRCcYBuEpQX0izDikvIqkUJ+tUiwPdfRD71NWe//Es5xo/mrV2Ta10/lCStMAHajMg5SsWQMGULO7eldSl5TbQB3MCZInfDjgxY7ADM6095eF7Rock0ZB5+X6kzgoN5jWrSyiCfLdHm7n3caVuanC5r9VfaC0fmFE4kGAqflnsU7IZsZrPgPhZzMRHOfCBcuUB/nflGdzScX+HgzX3MfoI0lvV4kJp1072JEFABsbpg55gK0k+yUeQ0Ez2GUla0QIDMkgk5pBzpR+eATAJ+Xau1iwwPx/0VEQPy3A9X6uIRl4SjwV1lHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

With nr_pages == 0, GUP-fast still enters its page table walk and can
write past the caller's page array. The old end <= start check caught
empty ranges, but was replaced with an overflow check.

Users such as OrangeFS can pass a zero page count derived from a
userspace-supplied length. So let's return zero for nr_pages == 0 before
starting the walk, just like GUP-slow.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify description ]
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index cc4fa18783ce0..1c2ac7c66c309 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3215,6 +3215,9 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
 				       FOLL_PCI_P2PDMA | FOLL_HONOR_NUMA_FAULT)))
 		return -EINVAL;
 
+	if (unlikely(!nr_pages))
+		return 0;
+
 	if (gup_flags & FOLL_PIN)
 		mm_set_has_pinned_flag(current->mm);
 

-- 
2.43.0



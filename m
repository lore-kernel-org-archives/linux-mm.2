Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98011606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bgiUPxnW
Received: by kanga.kvack.org (Postfix)
	id B77D56B05E7; Sat, 31 Oct 2026 05:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B281B6B05E8; Sat, 31 Oct 2026 05:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A181D6B05E9; Sat, 31 Oct 2026 05:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5016B05E7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:49:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08637A08FA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:49:40 +0000 (UTC)
X-FDA: 85382449320.27.579221A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5126080004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:49:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bgiUPxnW;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440178;
	b=kUishhDM8Hl7FEGZui4PscfiTN66L/Ql9WendyLWeJm8weQlDofBqzVhn4bxa4ypk8zz8C
	eUemEYVj9OdUwb+0pFAJD0u+2LxoYkw0/JlQMBIE7A5oxDsfDRbiJpHnfYx7BTnp6L/XF6
	Tb2BvUzkEtS2XwN+1JyYF98OSb23uGE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bgiUPxnW;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOWqT7E2jlZnxV1djpCyvfyOt0ij9uMBqoxxut+BDGs=;
	b=1SGVctDf72/Wznvx+rRbPudC3oLbTSdA1lJ3oIWmGyps0yRcIVUPXY00kOCkVanq6D4KGj
	aN9GjBb/E09IpMIWwKwUqTEIGhXymMEV/UBY2XHILNYAVkRMZI8QutyaJfJCKQl4bXsZq/
	PAH+tnNfUwC6dOJL9gnifJYtXntwg2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BEA2660628;
	Sat, 31 Oct 2026 09:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C9D1F0093A;
	Sat, 31 Oct 2026 09:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440177;
	bh=rOWqT7E2jlZnxV1djpCyvfyOt0ij9uMBqoxxut+BDGs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bgiUPxnWgw20xW52DyS0zumdr+ezcjL1UDtOGrrrSl0ltBejFbx3s0f7UEhNUGBRq
	 4Gk9HL+8iT02eUm7kFNBMfO9XgUqgsmpIpqN/3bNIWZwlrzDpRrQF2M1VbSW2UfENF
	 Nk62ddSQEeHgNduuIYayvJTjaUUDHE/9XYk9nNQq4h/i8CXq3qE6ylbND93mcepYkk
	 3WpICKfXn+oWmej7+8dRsQRZ0qZwW0ulhCnMnoxYXPypDFjuEal2dEgFD3cp/3BT3M
	 2msoIqABxVPyNKMtiV0kztNaK6WXA4nZU8iM6jKsV6h3pZQ6RAGXpo8tJuEZgJCPlV
	 c6eWTlW26+AEw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:05 +0100
Subject: [PATCH v3 36/47] mm: fix unmap_mapping_range() beyond 4 GiB on
 32-bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-36-d6437171ecc3@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2296; i=david@kernel.org;
 h=from:subject:message-id; bh=qTyO6PBC45dn95yUMdB1b+shzP6oCOwzkg60jjakQ/M=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+KfyDbbTVRv5KnceWdpztENVQydOPb3K8d9Qu92
 HOY1dOro5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIkc2cvIsD7h9Y0t79LnMCiJ
 dbY2rKjkW9Gq+VXYqIGRNdX/3N9f2xkZZn5+o713W1Pd94+hp13vtK5XbHxQ+bEr8jyvQVaObYM
 7HwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 5126080004
X-Stat-Signature: bpk9s44p5m4s6yt1xxzc8pm94zu8hakz
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793440178-384808
X-HE-Meta: U2FsdGVkX1/PELvMkOVV7DUok9ub5whqi7RZw75LT+X2OnQ+Yhpgrih0L+fMw5XpI5cuDF5iH6ImtQuj6/rhTLchVSETLFEwq4fsuxoJVLOcI2ZIuk2JgkTpBJL+mXhfedaBKwJffy1TR55tV8no/DM4ptno+KcIX8O/l3wIENblx7nmvVrcQ2A1OO8zrwYipPgglHXInD8OHtsFRTy7L9N4dFpytZ6WiB0wCnNaYN5vA6KSh19ud3rBNH+YnAtUh4Ol2L+EgAUHAarOXTjQqUbUb/ZBCNaCwFBOy9malcCrr2fRSOpR2p7vDv83XT6zf+PHh/go+N/pqKNEYQtkxniz1HloVAYE2Euc9CpnKdKV344imng+GEkBBdeOLUMJsr/1/FRsAPfmtI61/ywfgH2aZdKI3ChfKByC5vj15xc4BKvN7Ox6GSSwiIpz1Y+uZKmXjSIgKQ6S4Pjus9x3txwChrgxas34Wqxra/g12I+sBHHiKWWEwcAC2xBmTDVgasG/qANNNLOJjf+f9AF+FrbOUevsOZFsmV0QI5sR4F7IdhKjRtXZp/JYO+zi3l6NlMkzB0xqRRpPf9CvNJnKR+LSiiOQyjimr6THOAMCVk1OlvMGrxe8yaXuqIa70fbgg/frpjH1WvTezmZAwuotYtbtoOal+Gg9+l/HHmeSSNfMy/2Gn+qNAPycT3suDpfdHtdXlZfOp6teraZATGvhNAA4T607Otgs2dHkWjfqZVdv4yqw/arvJMnjk/QLwW3rFRLyfj1ssmSXAbcnX8FzKXMgr6DXFg+YIuPherJhwg9kvjqflAz9p9T7/2806mD0JlIiq7jSS9k33gJzhZK7hU8zwp8ccUS7A2yImu2bJiCpVS0UuPlOasLDTXrMKfCtKCsQ7ifhuc6lz9NsLjjjcG1S9pH9njpFUvva/zqd174cURAMDjzEXSr/jL+K5amapFCXijtvBOUwn+i113W
 jKDdrWqG
 dxeXjjbjRCbnZthl01aPjKbIcVA5u3rLBR+gSiBwHCz32Y7qAhu9ATI8Qf9WEmLpBtcPgjbcVVqh9TTVsWz9L4nhMQhikOc4A5wrMRwjYbDKlXUckt5q/kP4gYMfAyARKdukoGCiS1M4KEneTiyxuvwK5WtPRprigXPdpQr5jZFD+qgdbD4Z1+NzMpaPr/cRSKNF/aaPbDbbJythcaPMyg+Jj7VNismxij2r0+fN44+ACycMdEQnYq+Wc3TAeujh6YI5IQFb0EPCn31/SyG90FiZfS7PwvlCAdybJZTvfFE7QQWvX+VE38sZwPLGlsXmeJuFdroC5PjlAWgnnFmqlPVyK/WlUHHg57IRmOloaccfOkE1525zGCfhysDwrgGNJtxB9hNk3p9O65bHF5297CNi9JY3rfP5YAw/A/MuiGzLghLV3G3bfZpf2gar7rCcycTVNljOb46NjXDQFv10ORZEH3sfBZB1Yyp/ZEhpBuyy5RW4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

Commit 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
made holebegin and holelen unsigned before they are shifted, by casting
them to pgoff_t. That is an unsigned long: on a 32-bit kernel the cast
cuts off the upper half of the two loff_t values, so a hole which begins
at 4 GiB or beyond is taken for one in the first 4 GiB of the file.

truncate_pagecache() passes the new size of the file and asks for private
COWed pages to be unmapped as well. If a file of 6 GiB is truncated to
5 GiB, everything from 1 GiB on is unmapped, and what a process has
written to a private mapping of the range between 1 GiB and 5 GiB is
lost: it reads the contents of the file again.

Where the range has an end, the wrong range is unmapped instead of the
right one. The page cache copes with that, as it unmaps every folio that
it removes. The callers which only have unmap_mapping_range() to get
rid of user mappings do not, for example drm_vma_node_unmap(), whose fake
offsets reach beyond 4 GiB on 32-bit, and revoke_iomem() with physical
addresses of more than 32 bits.

Cast to u64 instead. Nothing changes for 64-bit kernels.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ae8d567bc6ba3..732b8f926de6a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4649,8 +4649,8 @@ EXPORT_SYMBOL_GPL(unmap_mapping_pages);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows)
 {
-	pgoff_t hba = (pgoff_t)(holebegin) >> PAGE_SHIFT;
-	pgoff_t hlen = ((pgoff_t)(holelen) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pgoff_t hba = (u64)holebegin >> PAGE_SHIFT;
+	pgoff_t hlen = ((u64)holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Check for overflow. */
 	if (sizeof(holelen) > sizeof(hlen)) {

-- 
2.43.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7593606A325
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KH4pI/do
Received: by kanga.kvack.org (Postfix)
	id AA97F6B05CB; Sat, 31 Oct 2026 05:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80DA6B05CC; Sat, 31 Oct 2026 05:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE726B05CD; Sat, 31 Oct 2026 05:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA356B05CB
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:43:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 040C3A84D4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:43:55 +0000 (UTC)
X-FDA: 85382434872.05.423FAD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2A0421C0004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:43:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KH4pI/do";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439834;
	b=xjYFetRoJtCYOMRBiytAU8c7LEm+Ehhx1pxPzamMiZlvyU9W8wFyDi+bgXa0Ls0y5yLhFd
	ySn+9RgEFuQv9yp6yzpsipMhkuIymF7pI9VFueDNZwje/2gh50/5HlVYsP2yzFAVjBuT84
	6z40mDIFWEl8QlVu4fczJXc0ndyvDLA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KH4pI/do";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2OTaWQfXrVSggRAzexmllu+qraQW9cW0GF8zz7uZPRg=;
	b=E2QYJEzF4I/Y5fxn839l/piSY8jI0OtP9UF7tIvwZIEtfSSpQHbcpFd21TeG+kyLr5AisU
	JLm1tHG8XlnfjpGKpusiDvPl3meYV1htfSqfO4ZO34L9KzkmkhYaIqpDYIKCJ0vjC1oIMr
	5wRpxbRic84rJDqAacWTyxkxJ8nIZE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5086743283;
	Sat, 31 Oct 2026 09:43:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9571F000C1;
	Sat, 31 Oct 2026 09:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439833;
	bh=2OTaWQfXrVSggRAzexmllu+qraQW9cW0GF8zz7uZPRg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KH4pI/doX3eDNZKP9hjfWDVBcMZhAxnMdgNnK8jB2wBHIOt4GUGM9QVUdga+4djCH
	 SFc3dVznI/InHvYr4kCKZLFFjjUrQbsxFdHYXO+EO8goAT+j8khfjWIlatlZxrGm0W
	 IFI0MElx2Iiquzr2GTcq4gWKVPHDWHXTZSWS6hSmKUsarRBLQhUnL0dypB/1HD0T2R
	 Dt3w/2XGVRPeOtZzVMVbMUJfmBsyJanHjWlRjcuBmP8T5R4e9rewjzLRNEoVGEeEml
	 tFIv5hVbeCSQYTjYNfa8efr44JBygWonSKu+nx5LWhhrtfkLmE8DkLZUerOI0jNTOR
	 yy8nZjGtdXSTQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:43 +0100
Subject: [PATCH v3 14/47] mm/huge_memory: fix zapping migration entries for
 device-private THPs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-14-d6437171ecc3@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1574; i=david@kernel.org;
 h=from:subject:message-id; bh=1U0L7v2f26iQXcRLRvM3iifHsSlAqIVV1y+RDTNyPAI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk/TCtvK7fRx+r1Lk869iYg97/LLXlvo8a2Y4sx0S
 5a825MjO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIyreMDLOet6xhTDvEoTVt
 dTzzieu10YJv+HUSgjpE024I+4QdqGRk+PzkTOLuUx5a+9x+MCTvNtjC8fIE5+I1d266vGOviHk
 3nxMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: ta4p9fmfyujykp4cxat99tekbc7jhehp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A0421C0004
X-Rspam-User: 
X-HE-Tag: 1793439834-325699
X-HE-Meta: U2FsdGVkX1+p1Lk9AnoZdkQk75UmoSYZWc6Jr46hwTpqRzGfvTZGYVvnq3czEKiM1I8DDOrYf9lLNbhamAMFdSI5zQUzZ51b2f+j0UPReyP/nF4efHrzRHm/ZozctEjJmdg8Sfy4gEUsKyd3lh99dSpt6PpzJbWVi4+u+mU3Tq7QPDeH6zo07YWvXWdMoUHJ4aL1GWnWltHP9FL14B8QE7cUxzcnmI2mG1M8Rv2yfHW8kerxqeNmTwSVjlpqI4+bFlyhEakH09Ngr0Q3Ti4+8rpOj2xF5pE3ovrzlsEqcYt+aiCM8TVdROalbSxnB13dqJKbC/GMPbwGbvJDAkAeNBFln1ulz7J/oUewFWSkZc8bfYgzCEVt199EPKl/FVjLc8GUvOMIy8KUlUAVtpf5gCAcpFyX9B8sag7KfOBrUTx85GAIQNsE72dBQLEHnCxatVCGtnt6WirBmT0YrwpYr+0PNtSJnG7iYy1UYEaqzOjADkDPMs8FBORfUOtJv+atrYYYXABgEAjpdEqWVCSszfp3PfEADo4bRdr48G89CQSc10zRqesKaNeSdBY/r6NCH1G0b6NirDTnuCcGFH2CoazEgeY9auZA7jKqrpdjVkCDdHvKr4Fy3WoND1X4jzfdpKIOFXKQb8r4lPG1cLRLUWonz56VEiMXQ+EgHlQz03E3pGfRyrwPzQKtZ3Mj12t/d8q7PGbD18Fzk6xr0fmQ8vLQmzTEC0z+zB00+Nu1ulaE5wdGVHymOCVMC2XjMi+gkDZybJV6mikHHmz7mzujXX9FVXRLvu2Ae0hB4Fk7syKc31+D2KeA/iGWlQNQObpOBvVp/W/OfitkKdfArW6g228vK9IVZTIq3k62luN5DGXhViBLoMFSU8IZQ7ztUhlyxtMTtutLtlQz0Cugn2iTGHyNPfduKKQ6D8DHbxPnRQkoSGdmGQpw5nlR9s7I49wwrcL/WOCnSEYs3ZqvmTi
 M29Bi7g3
 B6TVeHvy2LBuZUf/nSYQ/mpBhpzJujYsK35dtn/i5a7c5uyU2QyjGGuQ1vmlSMebpyGTnKMKyGpE14Nt+Th+xkWLxxslZzI76mCgvepVysTkFCnbFSY/3dGxmxAQD1aM1Ui2dqHTzQ4R+g0ujc+Uoas384T4lK2zYCZil9g0NTjli2gm7TTjyDgaj0VTAzYqeKXlt95tD1hsQHktKe+tfxZfrqaL4obhKFAIlnopfBmpTYnwIlMDbv0CXcv4NsbMBdGHYQLsGacmePFFEkhj5tPPiNFJzOt9RZmS3ULEx4v+iuS6TCPxfxNHFsez0u9G6uJXBGyL/kTleFA6fN8HOO2d+EXwGv96tXy9ef3bYRZlzVoKEph+Uwlv3arGa+bO1ahKGLjnodZQB0YFyhxBiKF1vRuEYvtcid1ysq7GXpW9UwmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A PMD migration entry can refer to a device-private folio.
zap_huge_pmd_folio() checks the folio type instead of the entry type,
so it treats such a migration entry as a device-private entry.

Installing the migration entry already removed the reverse mapping and
dropped the mapping reference. Zapping it must not repeat those
operations. Concurrent MADV_DONTNEED during migration back to system
memory can trigger this.

Check the PMD entry type using pmd_is_device_private_entry().

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify description ]
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1d65c4f576f9c..0c6512b33db0e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2493,7 +2493,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		pmd_t pmdval, struct folio *folio, bool is_present)
 {
-	const bool is_device_private = folio_is_device_private(folio);
+	const bool is_device_private = pmd_is_device_private_entry(pmdval);
 
 	if (folio_test_anon(folio)) {
 		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);

-- 
2.43.0



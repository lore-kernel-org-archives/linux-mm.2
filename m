Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21A71606A699
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DVoUES+r
Received: by kanga.kvack.org (Postfix)
	id 442976B05B5; Mon, 23 Nov 2026 11:33:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EC7A6B05B6; Mon, 23 Nov 2026 11:33:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DBA06B05B7; Mon, 23 Nov 2026 11:33:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5D16B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:33:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97DC0160907
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:14 +0000 (UTC)
X-FDA: 85466928708.04.567D6C8
Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7DB27C0016
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DVoUES+r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.102 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451592;
	b=fxOTMBRrDmW8ovQtPO/0lNwZSckInXQSd0Q3z+JWYuIUWValaiJtAdh1w3ZyOU1nwhgG4C
	t8t7LeQgfmMX11PGTbTWnxqDkvO8Hhjvfe/aSB9M8hSF2x4pYV7IrGOP4guyQOVTyOeYz/
	9smgGMF2y29kusxilmqp875xw/iTKKc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwWiH4TsPLewrmvX2AV6vJSDmcGS5DTBi3bpUFUWZos=;
	b=CPYoWpkyFyIubWJYuv6dSjO6jo2idPczHsyhelDhHrzbSMOJDYfT940mFqWs8JviespD2y
	UCX83qcZ2UwI/3sLYXl7TdK5FrBr3w/gg8/ea1YykrLpLfI2Nwj3nAwNv0JROlYm9tuzh6
	LJicoJz+eeISiLfrKY6gVbU3QAQDUIg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DVoUES+r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.102 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jZKaGu0pxutsSN80ekzFiD3bJEXetF6Gf5LZ+jjPkrg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795451590; v=1; x=1796056390;
 b=DVoUES+r/i8B52JHyStfl7du2iLFcOUFHmLbKUJuEhCNalaBU1bCmj04h9PneYT6NM5PXYoI
 iWslqbj8qfiZjfROTe3tpUydS6wuTwi9gBPzEtPP8rWvKcMTEEKUEeLTakQ0MNEg0xyZ4sSziLF
 ecfZl2XYvwpFdk/Gkv8pU3EE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 9be87c2e82eba38f;
	Mon, 23 Nov 2026 16:33:10 +0000
X-Mizu-Trace-ID: 9be87c2e82eba38f
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v3 1/5] mm/migrate_device: avoid leaking folio references during THP splitting
Date: Mon, 23 Nov 2026 08:32:07 -0800
Message-ID: <20261123163301.1568240-2-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261123163301.1568240-1-usama.arif@linux.dev>
References: <20261123163301.1568240-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DB27C0016
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: t5m3jdgyg65hxemmbwgtnkhu5impu3yr
X-HE-Tag: 1795451592-324404
X-HE-Meta: U2FsdGVkX1+2Jj3BJX70XsGPfKDl15qsr3sem9Ykc2KgtdYRqbV729zlewWzR8zNegOboWy+wjgY3d0IFV5FP60msv3GJzU/wpxRjFyMD10NEq9F9wEfON9p1HpRIC3eQ05dcTHz9T+rrG2eGMPVJIOGK883Atw4KIcZ6MgTwy0lu5QRVf/sfcdxIuUXeep2YPjdvlny0SgZ+414lUvCvPtp7gaZ6fB++R8Eqny0zx0knGjAj8TPpLKvNmwhjEPtKnKZLH4w1CZeVvP6ryMTEQSz0qNHKYCJFrP6xn+4uRORNA5p8iqpJZG+VeNUmhdfsUQpGg2vZq81fDtrNH9Sdd2fLfWuX6EK9+F7ERIuA5i6IUmJUgkL47etGHtS3Ytkgctx/LG/oVtuEupNNfpKDEHfB0y9fHFUu441hzgZ3Qou+Z9heqeRV38G+cSNwvt+AGegSDhD6i3dNCkOnn39Rkr7fawVk/tF15NM0K0aciOrBcjvMmHqwwoLynL1bYFz9ABbBET+lO72k7Yt0pL5Y1Yw3B7PkrTU5UmOECOEYSnI/aLMhzli4ZPSPT8A3+0CzsxGBR90/eJJpGWnMJM6eSAoM5/8/FWf1iD7lbzIpZ9ziJrTXXwYpf/ZHEHGXm6wwYbhUciVhB2wAwqvC7xoW8dARsmM2oTu2zLM2G64l689EWflOf9F/g8jvRySHJ2pA9d2f9yFRHZlFhtS2cweSlZNHdTZEBFias4vi6U4CioNWVbcUk0JDRslnVK2mhJ9McvBjHxMzlA+HtYTJcyuyGILsOfngK4MFmPGbRir2fdlvtyuumuduBGVsQer8RLPuE+GJ3ozygGC7pcWgC9GTSFB/MPqAYoYGaLIl1aq2DuRQdXQsH3woOlH218GECA/Cn/41+cya05LjeT7l4GSvcZ0n91EAAFfsXRh1IsGnLnQcxR90YI25KUc/NxcuOKoOSm8egwNY0zbYYfG4YH
 2BOSlSGy
 +RoGmyTUyZuq18zRXuZfh24x/JIPalk+jwjRrpm82xwqOF3HFQzUCzJDCq+a2GvmmQVOigApUOn1LbUfbhryaxdr1nMhyg3EdhQrMxHMJenwdfk9z/yhepD1VJpwT15DnzkpQl7YZp0YNNHzzsaaxumRDRKGMX5A2uPbp6tTPV3HhyqXH8kcvJayJ49odRgPpK6OyjG4eOF8PrF2svnXAoUwTaqvcKXUJhrZnM/eACraeJyXqcCLzyLANFLpmI0/glfK9xFzKzAe2rZYF+JZAkr+hxCjP6Dc5GgJyjgkHVUuGJchxPgcq1sktpatUtNR6Xq3slGU6BX/9W51DDAir6TtxWHEJu+VLMzb+RKpMkz0R35zxJRfErgagJuTnmOZZlxpD61ML84PyA1MsQMRxmEE6WabwROBnWr02dGzZI8m2qKKiJWWktMHTnb2u2gmJgr5MX1RC+xSm557UscxWoCD3CoYsUnnjSZX6RWdgybXnCAPZUDezbQo2s+uXPM20/pPp6TsnJRrymnXuypqWLiLCQO0C1iGos5cuHzNjUgD+rg7AkjY/OddL+LGPWrsI+TqdmL2aa4BoSxlMwwPwU5x3+lmORhi+G5nV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

migrate_vma_split_unmapped_folio() takes an extra folio reference because
split_huge_pmd_address(..., true) drops one when it splits a PMD.

However, migrate_vma only holds mmap_lock for reading. A concurrent
MADV_DONTNEED can clear the migration PMD, or split it into PTE migration
entries, before the split helper takes the PMD lock. The helper then does
nothing and leaves the extra reference behind. folio_split_unmapped()
fails with -EAGAIN due to the unexpected reference, and the reference is
never dropped, so the source THP is leaked.

If a THP is faulted in at the same address inside that window it is
worse: freeze = true replaces the new folio's mappings with migration
entries that nothing will ever remove, and drops a reference the caller
never took.

An existing migration PMD is expanded into PTE migration entries even
with freeze = false. Use that mode and remove the extra folio_get(). The
reference already held by migration keeps the source folio alive whether
or not its PMD migration entry still exists.

Reported-by: Zi Yan <ziy@nvidia.com>
Closes: https://lore.kernel.org/all/DLZ48KMS7YG8.3BTM0UUU8CTU2@nvidia.com/
Fixes: 4265d67e405a ("mm/migrate_device: add THP splitting during migration")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/migrate_device.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 9e19fadfa65c67..3286bb8a4b73ee 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -920,12 +920,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	unsigned long flags;
 	int ret = 0;
 
-	/*
-	 * take a reference, since split_huge_pmd_address() with freeze = true
-	 * drops a reference at the end.
-	 */
-	folio_get(folio);
-	split_huge_pmd_address(migrate->vma, addr, true);
+	split_huge_pmd_address(migrate->vma, addr, false);
 	ret = folio_split_unmapped(folio, 0);
 	if (ret)
 		return ret;
-- 
2.53.1-Meta



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3A3606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K1Nn4T7C
Received: by kanga.kvack.org (Postfix)
	id 060A56B05E4; Mon, 26 Oct 2026 19:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0387A6B05E5; Mon, 26 Oct 2026 19:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90E06B05E6; Mon, 26 Oct 2026 19:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC5D36B05E4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:26:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25C371C428C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:26:24 +0000 (UTC)
X-FDA: 85366363488.24.F089088
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 543324000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:26:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K1Nn4T7C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PtlfpG6u10gaqCyi6SThi6wcZjt4t/Zj3RCdhxUwhA=;
	b=Z3kSck6EVsyG5QWm+NC24UEjN5LkgMShMM19p7eJeGkgDju+BaZrEgLhbX2XP3fHwbxtXp
	uzybQlg0R9wyUTwhsCZx2wX/TMBb9SbcuffC7XsAu2605DAJnKi3DP7/2NSKKNK3nf0+1A
	dkK3KeeBz78ijYOIok16AMEEy5jxBYA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K1Nn4T7C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057182;
	b=Wbl/ODr9XsBwMlztPixGaEHoOMsX/fCIQKl+TVAuKNnKK/5+G+YcMiiUGd85JIayrR5eIn
	0eMzS7aYp2g8WNaXP320e3TWx3M6T4slAbSPeb5rjjOBuipBZjHiDJvbm9Hn7DYO4J1WT5
	sDRM+7MZ6PImauPt1jwDBTAykWzNgCA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90AFE406B8;
	Mon, 26 Oct 2026 23:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 598FE1F031E3;
	Mon, 26 Oct 2026 23:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057181;
	bh=9PtlfpG6u10gaqCyi6SThi6wcZjt4t/Zj3RCdhxUwhA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=K1Nn4T7CfYtFget3vGQ5tqh5P+gMowQusbsxU6FPOYr05AX8FjhpjtzZJU1s9XLjO
	 jhIpVkR7LlOi9/NK/+aMHV/q9rnZSwVWgFgg8Xn/IY0YKsi4SwFVzx63p6q0vfuvmL
	 dKzaebnJK7xNwO5TpYLwq4FFtu01hPHrmFye0XFSIk+fAGQlNKQsMtIgmXKtyFIFUt
	 omUR/6pOX2dMdwtRlTDSyHIckdtBy8B/tGvbQSZSRWsKVk4B4YpKCyLv5TjL3SnCg9
	 097ugjBYp6aYeGIc01XFi1b/Lffz8w5g8pYYQZaNqIjydc4qqWer+OSfwsi/N6ao2n
	 rYY2tC3Coi+JA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:47 +0100
Subject: [PATCH 27/46] mm/mmu_notifier: finish non-blocking interval
 invalidation on error
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-27-6f74bec9a5bb@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3056; i=david@kernel.org;
 h=from:subject:message-id; bh=p9dwbIzcUX5eScRpyy56kabNT2AFLKSYcMGSl/h3pJs=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu358WM3uhAzNDg9vCV4pqO3uvbXxzPPd44JfqPSzd4
 SYuS3hEOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIjukMfyWOb+7pm7WUmfvF
 K7+VT24em2Z4eM4m+Tye40tX10kdnhTGyPB29yWOqXctCw2P+M3+pVqzbrHeIt2Q7d85P+6dKB/
 FX88OAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 543324000B
X-Stat-Signature: 33qdngp84md6qo4nzedx53fop17apqf7
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793057182-429155
X-HE-Meta: U2FsdGVkX1/90Ln8jUvsNSVaYf2nIgY/JLF7idPvDNfjAgbEQ7I4NKgn3082frmECvpF2DPE3Yk+XB/JQegQ/XLRyGL6Xhw6/JLzNDaQcWHTbr6ZRiUU4wS1/P9i0iMfERiEgjq1HK4Y7+DO9vXRf1uGUiKVahCdECzFoWKwulbFEJbFpXgITyYbC+d6I4jkxiif+W40KWGV0uJW6K434h3IUuUryM3V09IlyS7W6truxTywgTSfKn0qNfNC9cFJyAvBXLVfmx03RzqyU3rn3aROsxJ0mc8vfh3EBqJTgk/OaQRfBdpSA90Fts2Q5hsY4kYtfejOrUUq3D7czw7yA5H/Q+EqApUr9ywxjCZzBWsv4HKPPcW+d1S5HrcsqJXfnX+ShFe2hANP5TVTGPDYjfq9bwNGcGu4hzXvO21p79QNFPptUUnPBNCEtZvFmnbFwH0nMIm+5TWIisp88E9OeiLxp/UNT5ir1IlwAtVZqcO+aUqltx1Vd8HazMPEqSrLfZk4M0Gf9z6BhTUNiaHmypfXrt0E9Z0q7jzUAAtZOzxsaEqIjbaey2txOfg1liEOiohWFVGg2GaD0BN0w6A1sOxcZssWFGVRFcVmoAyKBzniearl7eVZNj36aI619pKTBuaCXfhxfGiL6TjTL+la4456OaD9zKR4nWTgdHKXQNF69IpbMgUvDIutg3XYY94CpFuWoKzuKLniyzWfRpSJhowqrw+SKjPPln4hP0dPsjgk49JD+Daoec9DBthPio/RkZs+jJniPQDIMeTB/GQKv/g2ow7NJZZ/FLhyimQb1LTtBeFPeLhwPk/zlm1gLlrLT+2VhVAOhkdlVYfihzFhOc/2aeUZCAT8u7xeC+u1sfeDaB4vC6+eyqw/zOysNAs+s5+l1I0UmEo5Dzxb/k5z7hrgsFaalD4a1NUGOwQvujND6K0ZUgAdq7XkrWhJOl6uVoJx/oejcPIC2DZDG1i
 DqiNoRPf
 tPwRYbBVKFYBLebAIFcp3N7/8jXelYe9nPJKlsrRshPcuc6BFtAMOG/ipWe2QA7pZ3TYkoX6IExtDnCe7iGNbtlXlmjEfSSK4+wdTXXan45+pfDb7iD//3e6jhBOFBj4O9uUnd3old5bAOlTYm3M2HkTIMb/OwGsP20iU5MlElBW0oz0JwSBCI0pI3FKkA08X6Xtbqy6EYWhcrQ1oNKwzcfxMBHUL+iMtYRkVXqlwO9GPDCjXZQs62hS1U7NO8/j5voVlAxFE6kG3M+uGkbBo/qyVkF8+Njyh/gIfpn24KQ8IXY4ZgvrzpNz8Kn+kGJv18y3y6BvqfB2PJBkLpOrykBVLSsgJXvD5h2zAVhqk8ZV3N6M9dCFPfJmboiUEjL3ScBeb8zXmvKF3XjgzFQjT5KaJ8EeY/ARMVhKxFRgoFUoTmjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

When an ordinary MMU notifier rejects a non-blocking invalidation, the
interval invalidation started beforehand is left unfinished: the caller
skips mmu_notifier_invalidate_range_end(). Subsequent interval notifier
operations can then wait forever.

The only in-tree trigger is nouveau SVM, which uses both notifier types
and rejects non-blocking invalidations. Reaping via the OOM reaper or
process_mrelease() can therefore leave the GPU fault worker stuck,
holding a reference that prevents the dying process's address space
and memory from being freed.

End the interval invalidation when an ordinary notifier fails a
non-blocking invalidation, like mn_itree_invalidate() already does when
an interval notifier fails. Make that handling clearer in the
documentation of mmu_notifier_invalidate_range_start_nonblock().

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 99cb252f5e68 ("mm/mmu_notifier: add an interval tree notifier")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: simplify description, update function doc ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmu_notifier.h |  3 ++-
 mm/mmu_notifier.c            | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index a11a44eef521e..5db78e5761c5c 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -483,7 +483,8 @@ mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 /*
  * This version of mmu_notifier_invalidate_range_start() avoids blocking, but it
  * can return an error if a notifier can't proceed without blocking, in which
- * case you're not allowed to modify PTEs in the specified range.
+ * case you're not allowed to modify PTEs in the specified range or call
+ * mmu_notifier_invalidate_range_end().
  *
  * This is mainly intended for OOM handling.
  */
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index df69ba6e797f7..2e20f88e162d7 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -569,16 +569,25 @@ int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 {
 	struct mmu_notifier_subscriptions *subscriptions =
 		range->mm->notifier_subscriptions;
-	int ret;
+	const bool has_itree = subscriptions->has_itree;
+	int ret = 0;
 
-	if (subscriptions->has_itree) {
+	if (has_itree) {
 		ret = mn_itree_invalidate(subscriptions, range);
 		if (ret)
 			return ret;
 	}
 	if (!hlist_empty(&subscriptions->list))
-		return mn_hlist_invalidate_range_start(subscriptions, range);
-	return 0;
+		ret = mn_hlist_invalidate_range_start(subscriptions, range);
+
+	/*
+	 * On error, the non-blocking caller is not allowed to call
+	 * invalidate_range_end(), as in mn_itree_invalidate().
+	 */
+	if (ret && has_itree && !mmu_notifier_range_blockable(range))
+		mn_itree_inv_end(subscriptions);
+
+	return ret;
 }
 
 static void

-- 
2.43.0



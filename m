Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24203606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fg9rhh+A
Received: by kanga.kvack.org (Postfix)
	id F1F0F6B05DB; Thu, 29 Oct 2026 16:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4E36B05DC; Thu, 29 Oct 2026 16:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0A3D6B05DD; Thu, 29 Oct 2026 16:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEDCA6B05DB
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:40:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 416D9C052B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:40:26 +0000 (UTC)
X-FDA: 85376831652.08.3EE3F2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 55C631C000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:40:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fg9rhh+A;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306424;
	b=DkvCp8SW2nBnmO+wtapu/Tqz5ONHTQ5K3GAEazLuRocGZ28i0d7QQkumbuLo7RnqlSTD7o
	clftf96KY53bzyI5IraXdrrrLyxCywjHa0HhaTdODG08gKxwkmpF+V2Ll9JD9CNk39inVR
	7V7j4mj8stZh9zVDcLlDr3x6mKukJbY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fg9rhh+A;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=smP21MNlcpMNK0fftG0qIJjRHMGZkCrdRDzn60iqOt8=;
	b=x+xDoe7KeGWRI8MDYQmj9RXnwcLoc/AubEamXhwx6sJ+KQj08R68DR3n/SjUV6T1uwRCkD
	fu5a/w5qRiCkbbSyZ5Zn054sdWAEtGQ+nqQODe0tebAzucqPBt4y5K2mX+zvmZ1QJqoEtW
	PD8kQ7OG7qUf+1SwmzkcXq/tBFIHb/Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C3C241495;
	Thu, 29 Oct 2026 20:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5921F01825;
	Thu, 29 Oct 2026 20:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306423;
	bh=smP21MNlcpMNK0fftG0qIJjRHMGZkCrdRDzn60iqOt8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Fg9rhh+AMA4eoEvT+YS9smXN/Jw8jNkYUjlh2/WTvhUvRfWpGqVIUbws/nOVgTKcH
	 JmnLtzTywSkKc+tveOiqNJ6sAaVzMCrSBLWOJdYLEPFobnUHjtdPYBFN2THMnyCyVi
	 PHyEgjRW1DEo+LWLMNJptKFTSjq/0eTcrs+9Ajj7tKT++gUkfNirE2kDH09ux5Sv8z
	 mhGvyubr7mt7sR0Wbytg8XF6t3CPX+P+JGjmV2jQWuePXnKYTwkQ/kF0/q6mjtOKtZ
	 2yz2nJlMMeRtr1tWauVtwW/Xm2qaAAW03XxA6ePXGgPASmS5F5R4zEZixe4DeMWgj7
	 VqbGB1iSp0JeQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:23 +0100
Subject: [PATCH v2 28/47] mm/mmu_notifier: finish non-blocking interval
 invalidation on error
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-28-a64ce7f83abb@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3102; i=david@kernel.org;
 h=from:subject:message-id; bh=l+fGHD3i9bA+Hs3jbwzxEm0UnsFEqJuA4y7L3ttzpgI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer21/ytZ3UVrk43nXrzP3PFV7v/ejwcct57Ujb0oFB
 PP7rvPc2VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEmC0ZGTZNDxBhjO2a81A+
 i3OF0eHLq9KU+XwOrDaVypHJYvOV/MnwP9ggYv7qttlnXwRlzdJus1/57fI//zOXnS/a69/6sZ5
 nHy8A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 55C631C000E
X-Stat-Signature: c8kd85jxcre86mycukkbaycgp57bf6e5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306424-508770
X-HE-Meta: U2FsdGVkX1/crvTbbjx94aQgOAKxctMx5Vem3EgYJEWfXtfW9SpNAZxwn2SB+hvI2/H8DqXWRvQeCjV6g2Nw1OLDKsCqcGFNSsYGCr3VP5C7Qb8hxoUtz6r8GkoX4e9ZkNdlqPPqjZ8eUOuqcL5zrWgRt9yiiNubMgN+sOcY6d+FfUC2qD18QPx4ApM7NPk83uOxI+9QU0t1xT8AtwlHgC0JBsRQ4c6ebIfR6qTQI3VAEUf8TlSWA7AmAXzSfwqs5TticqrdEY+N5MABWrTYzy17A9vaOlkbanpVlsCnu6vgk3vt3gY2DccmlSrGQDwvEU0xXjslko0cT2IhlIgfBj9q0KwFKSe+wunS3V9PGrZxCoHs9UyX5+z6pwnueXzKFP25939r6dgPlzAy7JwawMvv1xiqVn+x1CdEunc3scrtirmMIbfA/a43u8WiGw1T6qwN6SNNgZtVk3fm7xXeYaFxKOq+W/Antc45p4QNNLo/tPG8mvRcidCUxFBcnRXtyaOggunwndlld7QdyoV0qSNmSjc1j8WUAvAZJEMuUvDY6fUsTW2qq3ZLyPvgHv9Euz4WGEDVcZ29N16L8LstIBY4oWhdefuZJwGQEGOd3R2jJ7BaGDzogIC5Fc0UiIEXUJAw+3mZaltF3o/JsHD0KKAbjACNTsaYPJEYlBA1WCanf7MVurZbKK/dZKJyiEH+9QsN//aES+uv3j9H0VaHsV/gr59t0IELXGlCuBhEh1CuFCC/ZFjVDEcK+pSf8u5TFg0pSj3brPH3fJ68seCNX6t9Y98OOlR956rSVbe0xn5b7mgo7kxIDkTYoa41dugYopYaSAJeSrlEJtMelqJnqHgLH/its5QGxMNaYKAFVJQBGXWZkAFCgnW8i9h5NWYrOEJiA93nhxZkgEhqHB+1MvlG4pDhLlf4YdNgJoXqZ65pVQd5hQSp2Kkjsi46df8jOY+N4evMl/qvluIDNAJ
 VKE3dpX6
 AVUgD50am3Zk08lIv35o20BzE80xmmAU+OjjekyCRkY7Ax0LoE5exKnbL1K8U5EKhJM5yIGHQHK9J1WoVzwqvw0v3L/GUE09VYdNIxJ1rqoFzSCMH/0R/t69t+Re7D14FqbRxB4yNYG4t70ir4B19IGass8d4yILBcFPzBhEKKo5nBZrkgyoQAxftu9aaRJCyU+jvthlSOj3e4IhPhLuPgEBXhkVmzujpdfzu1URdSeROuZO/Xd3aRfZm80V9v9CXHteYAx4UpPXk28ox7jILW0PZ/i181/Wgzj7YnD87mNYOTgFZfFZB31uYNPfAtao6q/6xXsxvTioD7pD2Q7xeb2Mvl8zUSToQxVbWStI5QQc02JNBcBvNCj2xyBe+kII+Rt9Aup+VY0VY1yyA0tRHnStUEuB3YJXWQQMY9a8opoWKeQE=
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
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmu_notifier.h |  3 ++-
 mm/mmu_notifier.c            | 17 +++++++++++++----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index a11a44eef521..5db78e5761c5 100644
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
index df69ba6e797f..2e20f88e162d 100644
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



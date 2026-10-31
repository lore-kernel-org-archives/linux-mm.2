Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E540606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H+Zu2OmD
Received: by kanga.kvack.org (Postfix)
	id 86D5D6B05C0; Sat, 31 Oct 2026 05:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816C26B05DD; Sat, 31 Oct 2026 05:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705F76B05DE; Sat, 31 Oct 2026 05:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46EEA6B05C0
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:47:35 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D999D1208EB
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:47:34 +0000 (UTC)
X-FDA: 85382444028.23.780301F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 196FD140009
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:47:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+Zu2OmD;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xc81+pQCpvOEFV1SjV2hvWtNjfruVqO4qaaYMBxu1qU=;
	b=cWTwJ9AFJ/zU2Tf4f+SePHaY3P0pL5Ni6h+On355J9jSR3Cz+q4Z7SMUd7oz+xaKXmzW5T
	ocpmdWRP/N8jRJC70PKIKhalfae+cCZK/DyhhjSb5TXvTD9tarrcHQkeDRbUGKxAADn5ME
	AFVrCi01UKZ13QnAs1HU1BqJB2vNRJU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H+Zu2OmD;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440053;
	b=pgB2FaTPgNCJDFWi/KFhibQG7n9+SUYUsk7n+KLRVc41mXZki39zEkjmvHDX1NvWgn3vm2
	eLDUUfRflkypsgZAiAdye2zqNVHpL89RN8OWfOkLW9lKzKpiwVqLlxmZsrhmpKrcb/M8yo
	EjcT3vskOIzfcoFryTJYis1rHvBXdSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DFBA40321;
	Sat, 31 Oct 2026 09:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3531F00919;
	Sat, 31 Oct 2026 09:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440052;
	bh=Xc81+pQCpvOEFV1SjV2hvWtNjfruVqO4qaaYMBxu1qU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=H+Zu2OmDANIogo0KydYV684DDgB6E/JPWdC8WKGejHwloLgYyBl4uyENmjkOgd+6z
	 OpHcmg49k4+J99+rvf3R9wI6eHcjtYL+GrE5zpm+mr76ayPfV9ZLRnX3oK2Y37qgQ2
	 1aYeP4op/vYaWDQOw+1+5AqmWmgTC3hF095aAs2CFn2+kGIewLHko2nddZ74GOdzqr
	 e5nZGqckvv1VpUgOe0qZ+KqE9Ew47LvziANO06udnWQOvHD49NDmNyJBy3EBFe25ax
	 CzMxvJ8U3MUD3xbw/ySjXDB5JQeks8KgBBk5OPWhDWliDuB9GvinW+iv1tqP5vDc5P
	 CGgb4Dm/lalVg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:57 +0100
Subject: [PATCH v3 28/47] mm/mmu_notifier: finish non-blocking interval
 invalidation on error
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-28-d6437171ecc3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3161; i=david@kernel.org;
 h=from:subject:message-id; bh=zlFjez9kL2dtssRVxiCEM6wJKA5W9Xa0kYQZPudLU3A=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+wdVs899LDdv233UvDPnaf8rB/f2qO2Bvdcx/W+
 xUeu+T4oaOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJCHcxMtyOuKqxIr/t32zJ
 XNNZu1k4Pxj8v/h3rZRusULpUtbDVfKMDLsOv2T88yi9dnvL5JBVGziT32oftbzySfi4epSisuW
 pQF4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 196FD140009
X-Stat-Signature: tmkxizgq4ydmnxxpe13wcbu4medo6wof
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793440052-92068
X-HE-Meta: U2FsdGVkX18wHEWBh7BQdSWrDkxjPmddF5B2zzw+K0u8i9bhtG3CuNBGL0Mp8yQ7XKRni62ONgQxZiHtpq/aZ2ESurQwanihuXt6DP0T2ddI7be6U2TyEJeqO0yuLRKMeLPcja9oBkC8efxSeWFjTYl8FpyCtN4DvD7XnIkyq2MA0ZMe6M6SCr407qlINWhoshkEvbZvfuS6TxjSLNI+nDJoKFCMf3k1ahASZ3QXTRr2LXpxpD5TyOLiQJMSaU9hON03ljKj1v022IQYQeQBP49xl7sIbiojcRQWKnnOkeOsoNRcVuDvJAxe6jmOXWbL6B2roOvhQya/EyvF3emh9vZ5Sptb/3dkvcl4WWAywqkHE8xddqoB5/5caV78Wrr8PzOJOJW9pijXqIlCr97wQPunBhhyHcv6u+JIyj7nIeTmSnRYcS6LvW5jjLrKNX16GinhjWvgn5P+5axMU57602BS8W+7pprk9aU+rqW5Wnm3RRyLpJdJrNBxQM5I3y6Xn9+XYZrtzHKjTIeU5oIsG4oturH9TGUEImIYExYE/KJq7aC4fRajJZXcbgpmKzeFA5Xc4ZpBx7ifm3mXSMyU70n31LGNAzClVwTd6sQ5gCnFyzS/zFu5pQwB/K1EqYiITWvpZHWr4zEtfSFDQlHROiXUmMGE6bIr0q4CD3xZggYT/ivIrI9e6Wln4lhoF7T0t41pXJoOgGJu09Ivy9klRyFt0sCdGX8fQ3+O//kJikHFO5bkKK8/PdeTrwS2iMztFfL8c0C2xCV9PCrbWfAJc4iDble5jPJaDUbShPPFG2VUSh3dwplasZ+9l2/NVew37DpSOEEcDHDkMdLQtT73QqvRsUV6xgqjuMaCPeA9O103RE0hNc6AYqJAmceSDStC6iLIaWeKWcfXl2rn7VyQKdnsXBhQ6EQr3p6emWdw8aIETN458SUbTiUq/A+IvptDnArbkGHxtdycNEDgFan
 exj3gIFf
 FnAX/Q0IWZvsIckloHGpFA9s9R5OWxcCVKuH1YqBiNAXCnabhMRqEMfcccZxgYjMy99zzvJ/CtB5q68+GNd+Y6KgsRaw/lFW7onD/PTOUwOqQ5UAVE6QakI9Tpxu4wM7tnMhZdq2T3lutoPKrs6fnfgk7RWTuNmqQAPkyvKzsFK1DMNDOkDIFQNlGhj8yLXv9mMGBasDf3j1F31Zuf3l4uzLOITOvK8WptwWUBIXMKBDr6Rjwg/0BU453RavTYQ/Pxt7wJ8tJHXo9QyyD5sC2kFzj9HuJGYJ11aZMRMBDbJbzZra8n+lgTixsNrOKjXWX+BFrRW8ixAc/8gNpUjaiAIEBi/tgaGGmptBk/NcgNrhb/aAXxugK2O04lEFDHitWtJp31nyYeuLcaDFEpEjAWqGsfLoFaN0pg1a+akvBuL+Dilyd+vrzcL6Z/CgbEbKjS6Mw7A4t+EeiIwr2JIhpd9lc7C8Ccn7DFR8ineQkPeiqpkQ=
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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



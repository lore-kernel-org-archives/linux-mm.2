Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF45D60A3804
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=deQ6JqP8
Received: by kanga.kvack.org (Postfix)
	id 0942D6B05C1; Thu, 29 Oct 2026 16:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C1D6B05C2; Thu, 29 Oct 2026 16:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D9F6B05C3; Thu, 29 Oct 2026 16:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C33B76B05C1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:36:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A85C4050D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:36:01 +0000 (UTC)
X-FDA: 85376820522.02.1C0BFD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7A86E40003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:35:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=deQ6JqP8;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fGHxJQ6UBEKb1MyrsQbaeyi9F3Q1SAWrZUXTnnmA+s=;
	b=tsEca+6Q7r9ftWY7bHMmH9BtTIyWMuzbcZZl/As/K4zr5W2Eg307jXUaiVWn9OvszEmMOV
	hkF6y0Bs2MoyG8iIqOPTvA9LCo8fv28nK/XII+RrG8G4Pb507XGRjwkEbVkhaMe/FcCmq1
	k3DzkThOPpESfWjOepbBED2zLja0c9M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306159;
	b=7tY8EI9+lTZI6BVIZcLN5wx9YVGVovjjPHG0KFh50aWkcVa3MsfqucciS9B/pW9OUvDSKB
	LHVbkoVXYpn3zbkptCjjhWClaCL0dIICL+2/+fUkH952q4/n1oeenbTANp09BmVVFUT+6l
	DnUQcmyTso/1+IYvUJILdGTxf9a/Gzc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=deQ6JqP8;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C38B340796;
	Thu, 29 Oct 2026 20:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349FC1F01816;
	Thu, 29 Oct 2026 20:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306158;
	bh=/fGHxJQ6UBEKb1MyrsQbaeyi9F3Q1SAWrZUXTnnmA+s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=deQ6JqP8E39elc/a/zDI3+44nUc0V+UdqENmn8aSAT3ekcvuHumd/vR6ilUWW0Que
	 489/6FXtF1BOAUvwnNIPwaXfBuawdAl8VT9J80QprdmAlBsAJp0OkQ0aYjMRuAhl+7
	 ZWcI+3x+EWEkxWPsRXduBT/JJHH+tH9AoCoXtpQbiq+gQUi3eroUna1TQZBM6u23OK
	 UsqBgKA8bSEkz2vSeRRFH5PpgSO5IealTYBMlSoTrJvEKvsIZj3PJwJS/p0ba85nXQ
	 PJya3A6K5AyqI9/h427FaLsWkW5tINAXhitEpp8Phx65nPxL5yci6UxOFUXZw00Db4
	 tEzt/Qnn1kQmQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:05 +0100
Subject: [PATCH v2 10/47] mm/huge_memory: fix list corruption when
 deferred_split_scan() races with deferred_split_folio()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-10-a64ce7f83abb@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Mani Tofigh <mt4022@columbia.edu>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3649; i=david@kernel.org;
 h=from:subject:message-id; bh=sU0SgxqnvF4Yi3G1bVV3Axo8VYJH1CcFJAyepsrgHZA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer23dYvp22dKO2if7usK4Vsgdm/zsU/hxlk/O0yueT
 VXbnhJ6qqOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJ7HzNyHCgv/Vn4CU56Qq9
 kgtLyzP83L+8v53ePvtsj0zKS4VmbhWG/5F7BeeW1ygZzmPjEugR2RVgx/0oqm1bLsvSJ37dJye
 XcgIA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7A86E40003
X-Stat-Signature: kc5wr14q3f1dmwixu43cbryn6nwrpqxx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306159-716606
X-HE-Meta: U2FsdGVkX1+AO6lOthzV1H1ptfW/2vmDjAyTuRTt6A3gld3ATpTKAfvWgJDTJi340sasd7UDxHaQ7qhM8cSp51otIWnDoiALXlQpVfpMEoNxNGOArvp55empOlS6MbzyaTGIFy/w4aOUMa3FHCMi++AjXYFwyHUkE2jdpcKfXCItdoMNxNVTAS2xs7YKZ7NPpHMBJBekjbJm2fl89AtHTvHD/YcVxbhn6JyJCZ5GSAYsQfEaH4xbgx//jVWDLg7sstBfocrM2jrMjg2uLSjTqqQh4j4wfq0V+CDUbGdDiM/aWGErezKjRAFWzKQldQLer8oSwECuPF8Eb9Y2HbKmMcFllWtpFCPj3+tWMi0+oCTKua56b+5wp1jdI26FjHWsuq9RHZP1GuZjIR84X5xDu1lXK024D9NjG4xvIolA+ZxwQi2aJCuZxjV5gP73bxgkk1Obgx64kN37t9m6zvEJa7Gwn/1Etck7NJoS0IiRT9KOQCjfL2jnDH3Zqrdse3F/00kMXhFDtRyOROreja4thCIWgY0QuYGJlrnmipydHKTMw8fMjT+xGMKBbUilvtDU/G0lygJgcG3O/SdTbbMEQYcKYBnAs9MNxwxYOXyc3x02jpmRm7ctmFPIOx7amzwehQ9RONLK7Md3wJyOgzQC3/ArsBb6IDWd4P56eQvUPpiTerQqOmtZFVvn9Z7CUiCf8BmNCRQc05B0FE6nFSc9jpwl/y11sZJ2avjtHkvGUcR/L/xX5yuw+PjMNHKQ+4g3sAd2AXoRNA3LYT5czfMLNni6RhTK1DiIFjM5No/aTB4HUAIL8XEtaxn5+WaXcWQDMXp2yNx6Mb6FKc5IludSOWdXb3xCatmGEq5kIxNLQUdtBXf591bVyb2fKzuV3qbuRAI3IR4sFLaB5TuO5gEnAYzRLTUPyU1EU+YObPD/GyG2Rdi7tCLjCXpnZR8OJe0DRgYErNxqxArGxUKuNgV
 A5SkV9+3
 s63svv2nGGzz+JChzXWwaT0JDlLKBrTe74VfHz2N2yx4up1qAMQ8AixIglyCF2eIh62VvJT7P28asMFyQBPfKadr7IqiMUjSxiIsfKMJLBjSNXUnpW8+z5gK/obl0Rh0fk6ncW1Ym4AhpDNjKDdxZlpmqvP+7pkdcvpQ5stRaVN85rlPrESAf1lr8MCzYUfLiGsCL+vAsFXpLjsi8znt2nPNnF8uqOTLpqoYCGstrrC8QPCka42qDi7q9GSOzdH6hoeg0gTwIYEQMZBO0tKQNQCA4S6A89z60AFl5vq1TmV9YMQ7hNgCBvjx+9yQHs8Y7/4DRMyr+xshylMiPXH3cadWkzlF/YkeaTmAs/n6P+EnL0LPod7B40un0YtcHeoFq/DJGE/Nq/uvd6S5MAZSM8vLvsZZMmklPuuYaiSXd6/H5gNbzH1rAR83k4G8nwCa/YgzevBtJomF4wPE9ph2cJlaM8GKpoxKgeofQmzreCCje3so=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since the deferred split queue became a list_lru, the isolate callback
moves the folios it took a reference on to an on-stack list, linked
through folio->_deferred_list, and deferred_split_scan() takes them off
that list with list_del_init() without holding the list_lru lock.

deferred_split_folio() does not know about the on-stack list. It only
holds the list_lru lock when it looks at the same list_head, and it can
run for such a folio: a THP is queued when it is mapped, as a candidate
for the underused check, and is queued "again" when a part of it gets
unmapped:

  CPU0 deferred_split_scan()          CPU1 deferred_split_folio()
  list_del_init(&folio->_deferred_list)
    next->prev = prev
    prev->next = next
    entry->next = entry
                                      list_lru_lock_irqsave()
                                      folio_set_partially_mapped()
                                      __list_lru_add()
                                        list_empty(item)  -> true
                                        list_add_tail(item, &l->list)
                                          item->next = &l->list
                                          item->prev = tail
    entry->prev = entry

The folio now sits on the list_lru with ->prev pointing to itself. The
next removal leaves the neighbours pointing to it, and they still do so
after the folio has been freed. With CONFIG_DEBUG_LIST:

  list_del corruption. prev->next should be ffd4000000270090, but was
  ffd4000000278090. (prev=ffd4000000270090)

Fix it by grabbing the lock around list_del_init() so
deferred_split_folio() cannot race with it.

Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Mani Tofigh <mt4022@columbia.edu>
Tested-by: Mani Tofigh <mt4022@columbia.edu>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..4c0194af9016 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4522,8 +4522,7 @@ int split_folio_to_list(struct folio *folio, struct list_head *list)
  *
  * It is unsafe to call folio_unqueue_deferred_split() until folio refcount is
  * zero: because even when the list_lru lock is held, a non-empty
- * _deferred_list might be in use on deferred_split_scan()'s unlocked
- * on-stack list.
+ * _deferred_list might be in use on deferred_split_scan()'s on-stack list.
  *
  * The list_lru sublist is determined by folio's memcg: it is therefore
  * important to unqueue deferred split before changing folio memcg.
@@ -4665,10 +4664,22 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 					    deferred_split_isolate, &dispose);
 
 	list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
+		struct mem_cgroup *memcg;
+		struct list_lru_one *lru;
 		bool did_split = false;
 		bool underused = false;
 
+		/*
+		 * Sync with deferred_split_folio(), which can requeue the
+		 * folio once list_empty() is true, and sets PG_partially_mapped.
+		 */
+		rcu_read_lock();
+		memcg = folio_memcg(folio);
+		lru = list_lru_lock_irq(&deferred_split_lru, folio_nid(folio),
+					&memcg);
 		list_del_init(&folio->_deferred_list);
+		list_lru_unlock_irq(lru);
+		rcu_read_unlock();
 
 		if (!folio_test_partially_mapped(folio)) {
 			/*

-- 
2.43.0



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A78D1606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IQ31o5OD
Received: by kanga.kvack.org (Postfix)
	id B05FE6B05C2; Mon, 26 Oct 2026 19:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5A96B05C3; Mon, 26 Oct 2026 19:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBB76B05C4; Mon, 26 Oct 2026 19:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E04F6B05C2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:21:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBC3FA7D64
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:21:03 +0000 (UTC)
X-FDA: 85366350006.10.E18063F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 451B81C0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:21:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQ31o5OD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7gX/m+u4UMJmVyrb0f8N/TE7LE/A9ZKgusas0I4Rm4=;
	b=dXhw80rm1yboD1jPjIT73O5t3p4epMEHQXXzLuR7NHHJCOvGVYB/D7Yyudr2VZHlhyof5t
	r/IpWur8m6QIVzXXvqLimJkE1T3hs/sOYiUj7A8j1ijngSE8tU2meKxarpGYyooaadg+hX
	zGsv4NokFUHjKi+xZHakDER+PVJ/BL4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQ31o5OD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056862;
	b=2eoHw+6wzUnjTe08QPwg5vLVM52pLSXD+EY96LDeyLOU01VeK7Y2VuOSnjZ/WDdDXWW1ax
	RV6ntXqxRCTanIwKbWOvNpGUJz4pqD5OP5IyjyKluJTjqO/iYBiGKnCrc+5jYmGikLGp9+
	U9t3eKoSCjCQVt5ouho+Df6lm0K2e/0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9C7160213;
	Mon, 26 Oct 2026 23:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787021F01829;
	Mon, 26 Oct 2026 23:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056861;
	bh=A7gX/m+u4UMJmVyrb0f8N/TE7LE/A9ZKgusas0I4Rm4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IQ31o5ODFi1TCvdbW/Fvb4z47yUoIHd+cPWP+ynS5r1WhTWrbETdppp6UQPnNBNxh
	 z31WeGR52qpW+2aGvMOZCs5WeWoxLP88gk4YFAygcZc4ACUUX8DD2shjSLjzIEH4ww
	 m1+drTX7t/Pun8PbB7rJzwuns6/ninmkX9gfO2PwPlzwVjxssBxEQSKGnBVGupyQVY
	 /ojkBuUvvCBPKQq4m1tQZnwUwQmb1uRNIn7es3b6LdJo5PDEmJVN+FqgnyDzSBqZfC
	 JwiCAmYGedA2dLQJeDo2dtw5ETmwWJu0F1Chd28YsiHToKFXf9A+np6osHuygNVyd6
	 Ml1ekzN/YzLGw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:30 +0100
Subject: [PATCH 10/46] mm/huge_memory: fix list corruption when
 deferred_split_scan() races with deferred_split_folio()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3458; i=david@kernel.org;
 h=from:subject:message-id; bh=r5BGBHRo9GSa/DI+t01ntFYVkxTFpvO09xLdXSpMdfA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35+idE7fMCKc/77ImbcKCVumnHE/1+sj9KHswaGDn
 hZPGvZc7ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiHl8Z/octV9g4Uyis7u5F
 jiNybMWLTzh+1J55SfB7xavkONmzCfMYGRaeXdJmm+57kjNUJnZjr+fGhxucxVWlCw78WmCp27T
 wGxMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 451B81C0006
X-Stat-Signature: ne7yqax1nabcw4qwfxgbst7nd5qr9obh
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793056862-434717
X-HE-Meta: U2FsdGVkX1/sVypKkGU2KFTL944Er/MW+WfP4He2/ARxuQkb0Zl6eknigCBDTC/axiRMC3WRfnIdGHqQQuyUuSFRqnOewbClpOeZwTwaLi9Jg6H5f/HNrCQzy8PXQLEmAOaZkE0xEMWMc2++yyn1YJdujvlKYihM8ZirVPaf2eV4jWXXSLKXpJ0AtTrU74ReAl+phHigW0+kf+vf1NkDuNFlmUzmslAZ+tQslc3HtSZoJUSCjGgSrwkL91JkyT2xqVhyvYQOL6o1JLeXg1NIuXhAK8C2+YYo7fRc5Xx5ymabvg6nE4h0pj+wnCpvZVqGkQWMLD7Kuc6UZzHAMmTPwFuwTuXffQ8TwNLsIZwd1z7mtphisGj8GgLY7iUFEHF7cdiNRUKwBm5A6l64Q05iD0cUcntdaCpWJtLX+3oARC2GiBFHG5rBw14bnr5HO1sHHNkQNfp+0nSrCvtZeb2iJNFYU/f5+mpmipplcWnqBmjpoq+RwyETwiHbSKeKDW5CA7tPomxnnpf20dxrmkJffvGIV/jsnXpzctxPxcs2rFmTrMj9FtJ+VH9FwKcMSVKlF6nT3kaUWHntZQdk1TG4gTAPWx1cCE2fI0AhzJnh0+lZSchHRXvA+UCCJa2FchA9rGZbJ6muFKmqogr000dQjQaUctwC3ikLhCH4imMmeeY6N58sEJJj9D6vqjfDOEgPeBn5pozBPrygEOzAksG9yAldN8uDL8Bi5/95CyOj+W5QfGDEtZAz4FUKNRcAmUvWSyrx9GhAAJeUwWvUFOTeEz74pav6PSg9pci8uAZUCLy23xtGesQPX8S5T/9TnQ10fsaWT7inSaUboSz+YpiE4FEx6h0m3BW1nPpztIwQTp8pr94HgNq6/h0BL2xFPt4D5PePOhxvmcqSk+hAxk8BjcfND/IspOxoeHHi6ODwMPdYUKYW2jOGlO493f5iAH3DR80NFfat2QS100za5wg
 jsGHYA/2
 8cYPukLBdMC5zaVommICUjSvLhRdUgPCE1pvZRBTuhl9JgSIyVT+8Qt4Yi2ekv1HG+Ese4awkkGFk6n2Nxj6qRYsCu0uhPUQrq6hnxxhYFeDFf2lTR1zezqYRMpAS1rG5eHfYjsTOEoTgk41/NStq3q70Ja1pYnm8JXukv+NDsn9mBs4dHA3+9m6KqdhVrdbxlJP+70iWx+UfS5rWFfPpQcDl+NXR9yGyfNvVWX5tdDkXwM31rBQKHWOchnWpenK6X2eAgjoMFNibAQQOA+DQ3n4oqC6Xu/9HR2ZJgrGQcP/eXVCDwwdOZjtpA6J8KQwyPGmCgizQ4c1wNtyxIz/a4trxNSIk4bzRx2fO/coctFCR0Yn0EllJErT+V6JoQ1ZoIsESoIRwenO2zJ9imVzWKibGwVs5qHJXF9k4hNoXdpVmt6Q=
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e86845..4c0194af9016d 100644
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



Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1A9606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SlvOoo7h
Received: by kanga.kvack.org (Postfix)
	id C08026B05C5; Sat, 31 Oct 2026 05:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF006B05C6; Sat, 31 Oct 2026 05:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5656B05C7; Sat, 31 Oct 2026 05:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5406B05C5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:42:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD3911C42D1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:53 +0000 (UTC)
X-FDA: 85382432226.11.F96C6DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1D5F2100003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SlvOoo7h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+l7vL6OppC3xXbuZ+6FYNU9AQPqNjHig+EtP/8oH5c=;
	b=paeoGvGGJsjpL7Hxr76cKOtHPAN+v0fooIdwsGkVCUZpAB3fYBo1o+KRYTZwh1vTyr1XZv
	JvOezrffo9Pe2Bu1rBQLbQoXgJ0IC7UV8RTJJIoResbwDMUNcdAhA9OoLZAVRGDWwgMv3z
	mMH+oVb4AejJJlYQ7oZlCEgCw6o0FHQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SlvOoo7h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439772;
	b=gnKNCd/EbkLEtIllhJ9JyQzN6QTOd9qA6sWT4eyCI3lzkJS9Ns1wqtkPoa4se2b/+D9Cj6
	YqJ+lwlWYQCl2IfydCWocbkSeNCX7QP6GRdeaECVYqRlYYJ4iGbiMEC40wkhWLv6h/JZSj
	DF8XRiu5Kwg/WPPHFub40mJL3OOY+AM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D62842A93;
	Sat, 31 Oct 2026 09:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61F31F00A1A;
	Sat, 31 Oct 2026 09:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439771;
	bh=l+l7vL6OppC3xXbuZ+6FYNU9AQPqNjHig+EtP/8oH5c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SlvOoo7h2NrGSce+EZ0r/TEXEBd2b3M+W3a5ZrbTwYZjlGRtxW/0dAR4JP4GA+76w
	 P+f7bAuUNu1Yv1g1H7D8kFS4QD5s2CZBGegKhPNpITqlN7Ip3qbNZ4cy/WVa1ZlmjD
	 /D2MxgtNqIQyQIzKHKj7qIVDjMAvkJf4rRPteq1rzuV+/rMCJ7D7uysNhe47S8OYi0
	 hM/g0ow18Z8BSkDidvpS/QUBtepf7GfsSShe5dLagt+hSjgLUsSJX9zgTlj9tPN+J/
	 0X8jIEgDjVqkM1UbZ87/UjTXIQyGyjjTepCGPRDVpmowDIpCv4zaqmYY0OHgBX6iW2
	 qTDUniZzh/0Ww==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:39 +0100
Subject: [PATCH v3 10/47] mm/huge_memory: fix list corruption when
 deferred_split_scan() races with deferred_split_folio()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-10-d6437171ecc3@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Mani Tofigh <mt4022@columbia.edu>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3706; i=david@kernel.org;
 h=from:subject:message-id; bh=JLLChxKIypxsdt4WbVQ02kyFhDQ6FU9NlTqVcswW/5U=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk8TMZnE9X4D4/OEzCXBE1Z9d/jC1rw4beqiza7Gr
 ftD/0+x6ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAitXmMDDuD94idilyy2OlJ
 +uw7ca5Hak9PM5FUNfP55rpY7WLg7Z0M/9NvzDOcl7v+Y92qeT0exhK3v3ycJN1/VN6Lyeh+8ln
 l97wA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 1D5F2100003
X-Stat-Signature: 6rubkw45h1x3oun7s93cbo6wnu69a965
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793439771-559849
X-HE-Meta: U2FsdGVkX1/7c4mjTDRISQ4GC54VcqdmC0ScusSRNdRC9jiiHSIApL5lpLD4knS0CSgWoj7tlGCw4IEpc8r/TccfmUbFRhlpwxhsIJZ1P58RMfuBAuA7nm94TLdqsfFaoxm4NdXA18yq9JQ65GegMrko+Qv1xcbk+7Ys5WVfp2tswG425fo04AhOhGDoty/9oDoWc/ozgSIgMGKGYH1/ih/ikGojrZ8ycVlXtbWlUFw8yL3F/aS7qJT66dBXn1tyxEKz9CYppJSEH23XpH0zbgduwgAVwv4RUXkCcxGAtJeXYqFJPYSCrQKriMi5pRxPmhJp/pdEmdJBeDAcwGkZ6RcVaE6UmieFyGJfiGNIvPlcU8BB5ff4ccKJrmK/gMiexHvxgOm3v2BQe1Vw7CXVSVxvl3IhFtuw7xNlD4gfblZDcf2DQ4UEsHc2BQ71zBiAg6RC6kV7nDaL5WVDuCT2N3v5fE9BPPKrWKpICoqaQ6lObutweaqFBWTQPG5kxlbfdTf94vx9QEEpOoeceteHD1tTP4DLq5hhd8eje7dK4GXiTBQ/HcDnNbAWQaifWwABZTfcbflVxJETnGxUFeXf8V1B0RsQ/b5S4MIUBNgEJWhh5jb3AxnAw4MsIoWPvT1XBM8DdQUFQkhjma8E+KB4fnJ/HxwnQM2VRYtYZZ/w5zhnmfEJsLIzfWg258LsKxnAFv5mWUg0WxuY1Q/pYaAsG0CQNrduceODnEt4H8POg634X+AvSsA6l4lUH46eX29YdJ8pvSRDalKtsk2t9jyeZK5yiG7bAP+Zrl9a0CcVooPEbESTznUbNB0aU5+HWJ6Qemb1pr+iLtevKYzRthGzQ228Jz0b7OtVl0FqbVbWO6ObZ9ZkmygUeY5bVEzmK8Apk+XEFI8gmrhyXhZpPdFRybXn2+Ji8ti6QGunjm3bQKdyMEwolquVej5IXbhtkujgtOIdPAa8AWLP4+yTtY5
 vkTkXwGX
 EZ3/toLHlKBdMxTiLzTS5m1q6vpz1agP6FQ+tKlsCZZsNmZaLWBennk5EsNg+VsLjowaAbqNB8dHTiyQ3Eq8gH9/PBJs6ztdnIZs8NqX5o4TYY00n35bAzp/fwbt9XuHODEQWKb6mxbTxi0IeNizxOoeC0HwD98943ZCUj/VKjsLlTngf+lHWv06toI8GLWEkvux3BkR164l68eZeqBvNfTzhxK24EXUzpiDIentzxb1Uc5CTqoIrxdGG52nb4NpHK2o22J2+2LF00gmKE2BjAZ7Y1aXFAVHvobradRD745qkkN6fNo73d+OyUgsM9xhGZCjSCvBQ2B34WCTQHujOLRslr9TrOGkooP/ZJ6eKmIGzAfLLjEQNpyhAwpfjgY67CB3ZZsQ27THamZzhwAPoEoEUoV6BIdrc4fvZ63CTxO4n8zrQYA+wRPEi1pbmwfNBIMaKeO7GrINixhYS82GIqFZzQGDpG9rCjh8a2Uojw05lIpaRg9BBNPRg08VYzbl3n/FML3zcwLrnzasLHHGhRZzwYGxe8ehvm0yR
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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



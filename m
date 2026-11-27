Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77E9606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 03:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BExcfFO8
Received: by kanga.kvack.org (Postfix)
	id D9ED16B05B6; Thu, 26 Nov 2026 22:11:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76766B05B7; Thu, 26 Nov 2026 22:11:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3686B05B8; Thu, 26 Nov 2026 22:11:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AAB2C6B05B6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 22:11:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15323801D1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:11:43 +0000 (UTC)
X-FDA: 85479424086.16.5E570C4
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1944320003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:11:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BExcfFO8;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795749101;
	b=lohEA9cQqzI7e1uiVCUoGtDZTAwjz2cqiNLmkFhvuqaE+DiJgnmZCQJ1Drfde155dNB4rl
	OqdR9cq+cvbJfBvEpgwAQWmSREAmUN6FqMpj7UR2e9QYp6JMe9XR5hqmMRVdiQUVq1P+E2
	zpx5ThWXmqATbBi9nNXLkTsSB6v/cHA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795749101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLy6s88hGK5j+du3i+X25eyagHoKD/bXlCSYcnJCXqI=;
	b=4MpJyR1HDl2EcumKTp0Zuf892MT+liVMGrI1PcQdvDFroxdXYigWKMpPRpw5JgMkRQqLgn
	WHkkcow6vDQzs4B5ac2gecm4yM0WMLQa6DW8P46PX3fydvT4YI41700aDrrhol0eaX2kam
	+2J2CNQKrcUNfmgRJZuMmVm7S3wvUkE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BExcfFO8;
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mwS129j2bdDA3TvDqt7nnA97HmeJ5XYFT/Xya3Wg+Os=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795749099; v=1; x=1796353899;
 b=BExcfFO8uBzHBa/cr2F6b8Hl1DFSV5UobaekrlFF/HEeL4a601ZM9q69nwBEu1rj18kBPR8B
 3beaSgBnWNHA5pJo/ZiHOfzOpYMIVSFBlpflroDyROvr5lnJ5HquekdD9Yr5Xmv6S3YNrU+KWno
 KmzKfBqBBnWOIMbBymianwZk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 455ca9e0193e9786;
	Fri, 27 Nov 2026 03:11:39 +0000
X-Mizu-Trace-ID: 455ca9e0193e9786
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yu Zhao <yuzhao@google.com>,
	linux-mm@kvack.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 2/2] mm/mglru: deactivate anon folios into the oldest generation
Date: Fri, 27 Nov 2026 11:11:10 +0800
Message-Id: <20261127031110.1034854-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127031110.1034854-1-ridong.chen@linux.dev>
References: <20261127031110.1034854-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 1944320003
X-Stat-Signature: ej3qt6d55edrbqebrpxcw3mtjc76kmyr
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795749100-873897
X-HE-Meta: U2FsdGVkX1/kdMUVZYbtGi6L5bFcOMzkRX7NxPYJcGPmnlTkLU0dor7PLLb1R+jEPOrtQosYkVIIioF17BKHN+7xuRWWZcatR2V8YD3HMGvdcWPSObckzBBdddofV0JTd4EccXh2mIoSana0uzcjvjeY9z9BPe8lmWM3DsULCBgNr55p0Ly2sP/qFhQUHSM8/YD4Ov47sBRWB9teFzB/BcUbQzKwYo9aBCzyAsMm5yzTPwTE03SveTghJgFC+wyaK+lrJGJ978u1xMbC30lTFphQOrl+psFMfJsmON+KX5G/zjvSHWj01rNI2J7L6aBa3y6pH6OmOhtcb3RYRKzegsTT4klpLrFVOSSODOaM7OE0SQiPqis7M3vS+TdEM/pByJIRWWZ1gtwKuN/K65UBfg1fxI+jcrQSWpgiOGU6xpLxFJXDfKAuCgAGQW3ike0lZjbUsOKLKyYIt5QSVLbv5xX0XIX4ElnvVb2BsZ+fqr++vt1Y3ukq3tuUZUHeVRThQZiDEPdlAAuR850wFjVXBRsN3JLf4yTNn0dmqM15EasaIsM/ia7X4ThxlPLfz5HrU87VqMBajSLBxRO0wD2dXVfhf7IGXSdUFjz4jdQ90xuYef5mtaTzi0hlDXzPPSRjR81TLOElJLmvAGfV+OGX9rt0QLPJVhECgqfXRAOuqwlFhb6NlfQvsAsEjmx9FiK1KDtrKni/Nbi4n04SJhUyO4dvapxzhezLSet4qCpbz6s1y1JvbwEnHN0nm+8RUh1+5tS9iVejpEMQprkFiRlcrzUvsPC+DdYzojU+GApIr9sf18wjZOFUCSyfd/hZrh3oU9AHTpqypT0beX/U+TpbT4OP4ZWlOrE1Ao/RZPW0C6qY0b7/erxwVMvWm0QG5JLj9eciTzvmg0gbi3QZxxn3TP0/eXs7S1wrklELup8WISgWq/3QM8WhC3zgt8fzPqs0As9CfwgD8LEqGB7Ndgy
 CvMsLZaP
 1yF23+EXNSn/m8wZrZ7djKdsod8YKhiTdZQq74Mg/o3QGcrrAWJs4Dcj6RnY57WAHtTxwG2zKIB38CpwZBzKdfFgN4YH/5S/X0Cn3t2ZMtUCQXJMc2cUEhFHgD2V6uQfM5cpZCANs5b9rMSTq8fu2oOPOwTXW/dUa+1+Uj/cVQmD08SGu38XfXj/7Z0P/EYhE457Iuy6nr1jX3YmMPy/wcrgMJVBqce7AU85BHjgtXqOK6Y/EHH1DIeVVZAmVB4c+gm8ydCc4iA9TqvbT+7UkxPaj9TeO4ESlMjRkw96HAuIwqCGjznxXjbAmfhnEJ9X88dYE7SHhpQeJLjnnr4cV2o0Lq6MhP8fduzjj3L+tyQqE6AvyQW0nntNa6yGbAR7TIoWoLb4dGnAUyjGKyKFJv35BA0ov2WjlRykNQiY6xYGvAC2eUHPxq6A65Uv/yh+0UsW1o8vu1Dus+GZfhjvchM8pcRoAEvgT/DTLffA39P1FXzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

folio_deactivate() is used by MADV_COLD and DAMOS_LRU_DEPRIO to move a
folio towards eviction. lru_deactivate() does that by deleting the folio
from its LRU list, clearing PG_active and PG_referenced, and adding it
back with lruvec_add_folio().

With MGLRU, lru_gen_folio_seq() places a swap-backed folio that is not
in the swap cache, i.e. an anon or shmem folio, into max_seq - 1,
regardless of its refs. So a folio that has aged into an older
generation, e.g. min_seq + 1, is moved to a younger generation instead,
while PGDEACTIVATE is still counted. Other folios go to an older
generation with their refs cleared: the oldest one, or the second
oldest if PG_workingset is set. The ones that have PG_reclaim set and
are dirty or under writeback also go to max_seq - 1.

As a result, MADV_COLD can make anon memory less likely to be reclaimed.
It can be reproduced with a single process in a memcg with swap enabled:

  1) map two 64MB anon regions A and B, and fault in A;
  2) age the memcg once through /sys/kernel/debug/lru_gen, then fault
     in B, so that B is one generation younger than A;
  3) apply MADV_COLD to B only, A is the control;
  4) reclaim the size of one region from anon only:
     echo "64M swappiness=max" > memory.reclaim;
  5) count the swapped out pages of A and B from /proc/self/pagemap.

B is expected to be swapped out instead of A. Before this patch, B stays
in its generation after MADV_COLD, so A is swapped out instead. After
it, B is moved to min_seq. Three runs on mm-new with this patch:

  A swapped out        B (MADV_COLD) swapped out
  0 ~ 190 pages        16384 pages

Cap the generation to min_seq[type] for MGLRU, so that the folio is
added to the head of the oldest generation. This matches the classic
LRU, which adds a deactivated folio to the head of the inactive list,
and is where most file folios already go. Folios that have PG_reclaim
set and are dirty or under writeback are now placed there too, as the
classic LRU puts them on the inactive list. min_seq only advances under
the LRU lock, which is held here.

Fixes: 081488051d28 ("mm/mglru: fix underprotected page cache")
Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/folio.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mm/folio.c b/mm/folio.c
index 7a3394e7c5dc..789875095f13 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -599,6 +599,25 @@ static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
 	}
 }
 
+#ifdef CONFIG_LRU_GEN
+/* with MGLRU, add the folio to the head of the oldest generation */
+static inline void lruvec_add_deactivated_folio(struct lruvec *lruvec,
+						struct folio *folio)
+{
+	int type = folio_is_file_lru(folio);
+	unsigned long seq = lruvec->lrugen.min_seq[type];
+
+	if (!lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, seq, false))
+		lruvec_add_folio(lruvec, folio);
+}
+#else
+static inline void lruvec_add_deactivated_folio(struct lruvec *lruvec,
+						struct folio *folio)
+{
+	lruvec_add_folio(lruvec, folio);
+}
+#endif
+
 static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
@@ -609,7 +628,7 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
 	folio_clear_referenced(folio);
-	lruvec_add_folio(lruvec, folio);
+	lruvec_add_deactivated_folio(lruvec, folio);
 
 	__count_vm_events(PGDEACTIVATE, nr_pages);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
-- 
2.34.1



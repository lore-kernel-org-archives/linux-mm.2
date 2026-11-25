Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70935606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ajrrPX3v
Received: by kanga.kvack.org (Postfix)
	id 9431F6B0968; Wed, 25 Nov 2026 04:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A426B096A; Wed, 25 Nov 2026 04:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809896B096B; Wed, 25 Nov 2026 04:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53B266B0968
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:41:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB90EA89C6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:41:29 +0000 (UTC)
X-FDA: 85473148698.29.3DA5E01
Received: from mta1.migadu.com (out-102.mta1.migadu.com [95.215.58.102])
	by imf26.hostedemail.com (Postfix) with ESMTP id C7592140003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:41:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajrrPX3v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.102 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599688;
	b=KuOAtOJKIpywoireIcW+WJZRP0Gpw6RUhzssoNhBFr8Vt2ZqigiUMNJsuYm8iZzf1h6CKW
	NbD7HOTbK7lSPyHq9PFJdgzNWR/0mFiewAQatiGCGacweSNLs8xJqMffeJ+GpikQPXn6oU
	GTUAiNOMW0D2jxiPvAhgFtyV4CAF8zc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u27ue93XHZWy7BlmGD+XMavkEtJd3bmw43b7jBroaWo=;
	b=6V0KpDGIwq3QtcVERD1eUiKD3TbTk6G6b5Vz3WZsGjEHFtpOOzxIzmT4qqPEJHBj4jE0Zx
	rxwNVWlI8/QiCT03NrDmpqSacruyPXsW+lSjHT59gmKScI99p7UicXjLlXZsR5qe71J0IV
	MI5oRX759R3qn2591lKRyFpbR/1+aOc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajrrPX3v;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.102 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5jxh5YkMStfuc9HHrckmIol/Ng+fZCKahUtHY9yazkA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795599684; v=1; x=1796204484;
 b=ajrrPX3vsKUnUu8ZvLAzNMXvuFTtsMx4QNU0wHxUWNLIxLJ/7KFAMEMfvyBpxGYOWmlzDfX9
 O9v1WcEuRyGsV4u+kD4k0i0qbpxmezC7XqgUohP/nlZJs+jgbNAKtcsTs8tiDUYdktofhpQ0RUg
 VW4Bf1wD0Ywyn2P9pgEBNetA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 585e840d492d5997;
	Wed, 25 Nov 2026 09:41:24 +0000
X-Mizu-Trace-ID: 585e840d492d5997
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
Subject: [PATCH v3 2/2] mm/mglru: deactivate anon folios into the oldest generation
Date: Wed, 25 Nov 2026 17:40:56 +0800
Message-Id: <20261125094056.3973331-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125094056.3973331-1-ridong.chen@linux.dev>
References: <20261125094056.3973331-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: C7592140003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: x5bqmd8pbieoa9gfcaof5hwc7aj81day
X-HE-Tag: 1795599687-783103
X-HE-Meta: U2FsdGVkX19XxhcheAxXlZgqvZZdXYC36cmxt3UFY30WusRnqBiBoGciDUOZtIVPjN2m0ugjBtlAQwOdfhRyRog0qguApm7ZTPXgsDP7n97BlIyJgs1JkZOVyd6CSiRQUwvVf1S5d+YGw0D5idsb9ucrgmprGrvPbQAHPiTE/vV/c2D4voQ20NEh+KOXsqG2ALV/eDVH4d+McYNlmX0065J8mntWM+9FKxpGcUjHqkBxXXvn2Xj2cD7jnpuhFK4xXtfN0L7N0aJhO9dyUpEfp7x+wwN+Q96RpvpgEIJwdFAzt4aUC4GcsBhZyoOcTNjUwXDgaq4fs3CBQwZyw6SvO6oGL1R4JaQaWd9aV6Pvtrf8H1qxB+meLzCDXVY3WhgM+TSfEp7m7Gz+/TLcGP8YmIu64AGyeHzeK/WE1+FygFKDAECW8GGJ0p51I+qbaJICkK9qOsMMOa9vikqlUTMt9GNpSZ/XVrKC7m643n/dD6foWabCLGcqxDBhpM79Ep+8riSDZThrmqwvmmX7G0ANPO+XhBUvkBTATTmdzfeiNlsoXbiPqCg59n4n/w4dxRMJ5OIV0tcg1tL97LBS9avkYNz2do4GT8kqQg/ONKI1gxCJrtA4HNIHhhcvokdQZBrAcMLq/yxSLatYSKNus2vgY6kXE9EhTnRGkDgzTwCcsYozj+cr7RHHKnLZZ3/VjgXDDniI0r+1rpIgGWEEWlPSacu5Edck/Pw8ZV2Y0rJMKaNMHcCgsENScVDtDky3XzQKMO4az3nJIG/7YoJAOPu9/bVXg09BxD+Gn1VMcwz8l6W2MYOT5I7/W1k5CziECcjCs80bxFb/hM30Xn3Ho0y2Wj+mmCPU4cR2ZwK+51/o/P9C07Q6sqCqA0a2hkILA/ZX3wfj0OatshBbGl/6LPZv99xzMRzGDCWH/WMQ4pQEkr40oPidcFzxinLDVtlk+Xu1ysyFmVqQdWmRUgGxI8c
 Mctm7lOY
 dL/YugOBzEGEbS9imI6e/m1LbbtABt9zllTrbrhZu3jtr6tNkFlnkDCX3oBFsDcjA7QJsPxsWFBBSzkXdPHjmxLr325weQP/wjghujKRN1YsP74LR07xrQWNZAHZ+P+PRRk/Cbq0Go7HCyP11jNp3VpBjyHT8xZaYq4lkTYpJeoMwnNlo4yHfSIQdwvhgxqtc3rdYpe+mZ2mE7wDCf7JUwJ4AjGyC+RlpU06+bcXVYx3s11sRuwbeSHI3zaf/mTT9/+D+hwDpyamUyy4EFoynu2ueSOxfH5JMNi7u1M3DgYg+NjGezg2JNTjwoBSc8hIcJFkGJgKIpUtB+/alOz1R1OSgygRAPlTjwUx2cD0obBJg4TetK8PQwa5f1Y51jMEDrdudJHIpt/fGwqe4N/a+RfUPPNc8u/QkhTYPN0GqwUGOq8MA25B6w306t6LjH9itHzJCdI1FISROuPcx1iUsEOoAWm6A4gzH8EDwnfvatntdDLI=
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
while PGDEACTIVATE is still counted. Other folios are placed into the
oldest generation with their refs cleared, except the ones that have
PG_reclaim set and are dirty or under writeback, which also go to
max_seq - 1.

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
in its generation after MADV_COLD, and after it, B is moved to min_seq.
Three runs on mm-new:

                     A swapped out        B (MADV_COLD) swapped out
  before             16384 pages          63 ~ 150 pages
  after              58 ~ 78 pages        16384 pages

Cap the generation to min_seq[type] for MGLRU, so that the folio is
added to the head of the oldest generation. This matches the classic
LRU, which adds a deactivated folio to the head of the inactive list,
and is where most file folios already go. Folios that have PG_reclaim
set and are dirty or under writeback are now placed there too, as the
classic LRU puts them on the inactive list. min_seq only advances under
the LRU lock, which is held here.

Fixes: 081488051d28 ("mm/mglru: fix underprotected page cache")
Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/folio.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/mm/folio.c b/mm/folio.c
index 7521680874c5..0220419612ff 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -525,6 +525,23 @@ static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
 	}
 }
 
+#ifdef CONFIG_LRU_GEN
+/* with MGLRU, add the folio to the head of the oldest generation */
+static void lruvec_add_deactivated_folio(struct lruvec *lruvec, struct folio *folio)
+{
+	int type = folio_is_file_lru(folio);
+	unsigned long seq = lruvec->lrugen.min_seq[type];
+
+	if (!lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, seq, false))
+		lruvec_add_folio(lruvec, folio);
+}
+#else
+static void lruvec_add_deactivated_folio(struct lruvec *lruvec, struct folio *folio)
+{
+	lruvec_add_folio(lruvec, folio);
+}
+#endif
+
 static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 {
 	long nr_pages = folio_nr_pages(folio);
@@ -535,7 +552,7 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
 	folio_clear_referenced(folio);
-	lruvec_add_folio(lruvec, folio);
+	lruvec_add_deactivated_folio(lruvec, folio);
 
 	__count_vm_events(PGDEACTIVATE, nr_pages);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
-- 
2.34.1



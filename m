Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E345606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=BPpTG2/j
Received: by kanga.kvack.org (Postfix)
	id 51F0D6B05B3; Tue, 10 Nov 2026 19:09:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F64E6B05B4; Tue, 10 Nov 2026 19:09:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40EA86B05B5; Tue, 10 Nov 2026 19:09:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 146106B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:09:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 904C31201BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:09:31 +0000 (UTC)
X-FDA: 85420904142.09.E1ECD13
Received: from mta0.migadu.com (out-86.mta0.migadu.com [91.218.175.86])
	by imf03.hostedemail.com (Postfix) with ESMTP id 84A9720002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:09:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BPpTG2/j";
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794355770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Satpe2sJan3JJDVPpUeuek7THsNxkqrFm8p3OavbLMo=;
	b=pqeCiFkfx5ZYXM2FrBneeniJdMhKOr1Z/DfxGzWAnCOGEiOcM+4n/6IHQgYAm2MenfJN9y
	Vhhul6OHSrzTuYXAv3k4PPgDOahV41jB7iI2Ml3ytohYA+CjYqtIxS4Hg61Icl8Xc08Rfm
	vVvZTdfjAzJqMbUVvWS8Kf42e++h3ss=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794355770;
	b=JY30CX7Ho8Yls++O94cSx4YyNDAHinW1PlSLlWmi2JtXGHPNXxbwBxB+o+N649HUHQRLXG
	a2c6Ue5Ml5Nz1kUMAONWXxmYcIy7lQjJJ0IQYBlAqn1tEAKwY8imfGCASfNS3z6jQITbMD
	HD7VNC6wGPeTjEW4iZbkqXFTrtKaBXg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BPpTG2/j";
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.86 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JGCe53txtCdD4ibzW3yg/dD5ngq8trn1hFKLU/CEDQs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794355764; v=1; x=1794960564;
 b=BPpTG2/jWPIF4tZwVdE3aYt+28t/VLVsNNegjFk+KPbrE2MfOcUuQXwWm5qrGvxUo4LR5wrY
 FCzDUcvmkgiNk881NBde9JgBN33Q4wPogUb0z8CSjqs9QwsfkYJExP2wQYZXS85NQbakzRc3wgG
 End/fklScVR7zBDG59N1UoUg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e153a5c284ed39a7;
	Wed, 11 Nov 2026 00:09:24 +0000
X-Mizu-Trace-ID: e153a5c284ed39a7
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Noah Feldt <noah@feldt.systems>,
	stable@vger.kernel.org
Subject: [PATCH] mm: mglru: splice all generations when reparenting a memcg
Date: Tue, 10 Nov 2026 16:09:13 -0800
Message-ID: <20261111000913.22943-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84A9720002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dyof6oqokh9wg38fxz5amzq894i6jgj7
X-Rspam-User: 
X-HE-Tag: 1794355769-256442
X-HE-Meta: U2FsdGVkX1+vuoQfOShdc9VVR4nprg2bMbSH83OeVEgAIjJkTODLC4tfLuHTOCpRgVyyTVKyX5ZnLKv57TS1P2VgZ9W3TuFVnuJa+5Qfqrg5bSQIG7jsebKFTkA5ZvgAtNXtoW8KtuVagk/rEsL+JxaM4054raYVo7pWSdkjeRndiLRXdmZOUHhifJdDZM3vaKrXRnOpYX6ABpxQBhIR4xGKND8pb9rDFGlvFiSQnH/i6u+5Z/NctUreKdlhnHxakuqzfH4wBKcrbccZ2E9cjMrjAD4aOEYN/ZgbRBJsYGMNLzQI3kH4ft8LNfrYfDat6lUcByTD9IvZuCqQEAodhvY6v6H6JUMH7m9ZporD6Ufpb/gKZK54LbpGwccNcqw9PKYeukG0sakvOFWHnskKBdhis80ZHxo5YkzdL4GgqvR6598SLaUN1A3deZ39aGv94YJfdE2U7R++L9sip6n6ukoN0ZSjDXOvudq2wBCuzq67vmPHGJBDx2kSOYAl/LY0GZdx35ECxSxcXwY5ntcRdLSw8TFaEH0G/xyO3ZhdWUAOBYkLIm1fKNELTfSbvsdq3sMkSt3wdvUgrSMk2gXpqMGZnjhxZEiRF0owJcHryGBSIzKccvRJvxzMEUCrm6MZD15TNxn0wZ9L1sGbDvBqOcYJA6+TBOYaridu5+kSzX4KCM0LmINQyozif34ncGfZrjzCYdxfaRy+K+eOPKHIBUFMaQ5hfxD1JNhORoD9qj0kGjwFURunx7mxek+z/04xcZ3KGVqNAJw7TYzxfOuCux+HVsD6vYv6ZWomLVODhumWaz2Yn2bdYUdVyF35vHs/G9gzpra0BYXEnmEsAj1LrD5JXx7KVNUfY8kPybsLDLbfqZ2Q2hgr32tR16EIfmIbkde+lHbEcupJfoI3C2r+88Es9SWlBB0Ol85f4H2Sde574AWUEzjFnLLYcPJfOZQM09fRrnR0OSsbd8FB92t
 6VqpnsGv
 RCLauZvN13kig7B6HJl7wdu7JPfqzkm/AlTrrF7OY5jLt1oVy348ngDxfSfWBCbWZuZJ4WTv5PHq0ZQRCBywnRxlj1MjZMq5kK0X+rBjTkziZ31AcvTV0Sc0jNUQHZVKCh82ZxUPoWKE9hjTp5wULfBtYXxabDkkLwYvBVOKut6oZlq/1n82081bUZfwtahP9hWknWNcxvypdXdSw1M49bhAJ0i0O8v6LicRnHkNIauPHETth/VL97laLa6+VkEgiEKvfTx4cqviIuTT7q5urTkMyEdPlo6gAu/kp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Noah reported list_del corruption on single-node hosts running 7.2.11,
which already has commit bf4ade7dbd76 ("memcg: keep folio's objcg same
as its node"). The bad pointer is an MGLRU list head in a freed
mem_cgroup_per_node:

  slab mem_cgroup_per_node start ff31bfa36a3c9e00 pointer offset 528 size 1920
  list_del corruption. next->prev should be ffacf881ccc70e08, but was ff31bfa36a3ca010. (next=ff31bfa36a3ca010)

When a memcg goes offline, __lru_gen_reparent_memcg() moves its MGLRU
lists to the parent. It moves only the generations (gens) from min_seq
to max_seq, and it puts each list at the same index in the parent.

A folio's gen in folio->flags can be ahead of the list it is on. In the
parent, the same index can stand for an older gen, so the folio's gen
can end up older than its list. Once the parent's min_seq passes that
gen, sort_folio() puts the folio on the list for max_seq + 1, where it
stays until the next aging.

If the parent goes offline before that aging, the folio is not moved to
the grandparent. It stays on the parent's list after the parent is
freed, and the next list_del() on it touches freed memory. This needs
two cgroups on one branch to go offline one after the other, such as a
container and then its pod.

The parent always has MAX_NR_GENS gens at this point, so every index is
valid in it. Move all MAX_NR_GENS lists, not only the gens from min_seq
to max_seq.

A reproducer that drives these steps through the lru_gen debugfs file
gets a KASAN use-after-free on the freed mem_cgroup_per_node without
this patch, and no report with it.

Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Reported-by: Noah Feldt <noah@feldt.systems>
Closes: https://lore.kernel.org/all/20261110132853.71228-1-noah@feldt.systems/
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
---
 mm/vmscan.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..902616a3b755 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4751,19 +4751,25 @@ void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
  * The same generation has different meanings in the parent and child memcg,
  * so this compromise method will cause the LRU inversion problem. But as the
  * system runs, this problem will be fixed automatically.
+ *
+ * Move all MAX_NR_GENS lists, not only the gens from min_seq to max_seq.
+ * An earlier reparenting can leave a folio whose gen is older than the list
+ * it is on. Once min_seq passes that gen, sort_folio() puts the folio on the
+ * list for max_seq + 1, where it stays until the next aging. If that list
+ * were skipped, the folio would stay behind on a memcg that is about to be
+ * freed. The parent has MAX_NR_GENS gens here, so every index is valid in it.
  */
 static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
 				     int zone, int type)
 {
 	struct lru_gen_folio *child_lrugen, *parent_lrugen;
 	enum lru_list lru = type * LRU_INACTIVE_FILE;
-	int i;
+	int gen;
 
 	child_lrugen = &child_lruvec->lrugen;
 	parent_lrugen = &parent_lruvec->lrugen;
 
-	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
-		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
+	for (gen = 0; gen < MAX_NR_GENS; gen++) {
 		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
 		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
 		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
-- 
2.51.0



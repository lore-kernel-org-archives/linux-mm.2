Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39537606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 01:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=HPs7Gvmu
Received: by kanga.kvack.org (Postfix)
	id 5BB386B0937; Tue, 27 Oct 2026 21:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CD56B0938; Tue, 27 Oct 2026 21:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45ACF6B0939; Tue, 27 Oct 2026 21:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 138BA6B0937
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:06:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6CD514085F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:06:22 +0000 (UTC)
X-FDA: 85370244204.28.3058494
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf11.hostedemail.com (Postfix) with ESMTP id F3EFA40005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:06:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HPs7Gvmu;
	spf=pass (imf11.hostedemail.com: domain of 3i0rhagkKCAQxnqivgmivksskpi.gsqpmry1-qqozego.svk@flex--tjmercier.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3i0rhagkKCAQxnqivgmivksskpi.gsqpmry1-qqozego.svk@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793149581;
	b=71PheLCrxDL5w4I0FVEQh29+0XM5Rr9oM1w25Fs6WGVEdIEePcZq2H5hDSWx1AGT5AlSYT
	73FSW+/wJHWLwXdfGKfSgcalv9TitnUqY0qR9k2InNtpuIOE3yCnVGpDUpNMSKbvEbA+F0
	UYMFTHIG9FXufiJwXhMsKiTlQY4SPkI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=HPs7Gvmu;
	spf=pass (imf11.hostedemail.com: domain of 3i0rhagkKCAQxnqivgmivksskpi.gsqpmry1-qqozego.svk@flex--tjmercier.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3i0rhagkKCAQxnqivgmivksskpi.gsqpmry1-qqozego.svk@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793149581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zcW+5YXwpWgAlstk9X4uWBFChO4Av++o92U1iDImK4=;
	b=xpuqirS/z+LUIaG1m7D4xMVnCxAr7c7aAmUpBPGNB+tZJ+xkmDn5r6tbqStZuFgCp43ckX
	8feio8xX2eKKD3Rv04XS69aAftZk1d6iTz0iuDWRTIgUzSwaM2e0fxpKLsXMPSt1x3FCp6
	5YKcTkSM7Pt/UuKUfKvO0fkfi+VJ7+4=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cd8b299b0abso340337a12.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793149580; x=1793754380; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3zcW+5YXwpWgAlstk9X4uWBFChO4Av++o92U1iDImK4=;
        b=HPs7GvmuzcwerHzOBKxN2cLg6EHF8sdXm8xk5I2gHZ6WFwpDJcFSHmDn8IJOz8DElf
         L1Shz+3W5eo7cQIatorEOCB3syflmyM7c0mFJ9Lv6jZUFx0WRhhTuWEF4t+cuBcXmnZS
         NlO7vAayR8+HXwTdYc3r8RcXmiL9zUs/WzMVcIZbMsRbA8qCrEpbM4FrfzwsRYHGuSTr
         L/bYyTo+OO919JJO3LuEFyQyAzl04iY5pu/SkNKIKZ+Tvg0pLXlUPCz30kB4bHNLl1wO
         oEctzHT7X98NsEKqe9IMXMH2C22MFuWe5gqAfVB6CIXWGZFRPm16lEFLGIa2wZSfZ94n
         wFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793149580; x=1793754380;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3zcW+5YXwpWgAlstk9X4uWBFChO4Av++o92U1iDImK4=;
        b=VPT76Toijw1aAXLVo7+vPEJsPESPmgmti3zuPrGjdJk9bk6Jmqq9XfHmblDoRaasft
         ClrJkuJVNIK8MZwI5FLaeAkbgs9uPPUUgcZzLeu8VJmmexSUz7qOH3yfWsSQIeAi2czt
         CpJs7DdiPkOftghiYmNiq+CNuhIA65P95bzzqhZZGbMUEHCHg3Bn5NJiOwngi9JnijpE
         j4v9qbbUmqo2rvyOg8pA4Fc3Jir9uk7V68J1ZHU7VkAOqA62PeojkueM7qc77vb5vsZM
         UtBb3Xa7m96JiUIm2WfaT12AVohRUx7/CWwVsiPCkpcA4FQTbIwPhBOehnFFAcQ22xy+
         nngg==
X-Forwarded-Encrypted: i=1; AKwUvBwhkQXD1NeidqqnZ6rjE1xbbZ5nS5wRoDByqxjfjzTxfAgP9m7A2jQcZMP6oMDC6BRR7lT4MiEk1w==@kvack.org
X-Gm-Message-State: AFq9FYLfOiFzyGxsWaDRoOoYSsHamTEbs+DfyK+3SU2UkMc55NJc53oL
	bQitLz6Zg70P+L4lrAnTaArJKh3QecDIolV1RimdY4uW7sztZDhVE4xgLQWSKWx+ks9fnU3yZUw
	2hIQRQKSRzmXkPqcvUw==
X-Received: from pgbcl22.prod.google.com ([2002:a05:6a02:996:b0:cc7:aab6:f8a6])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:5482:b0:3e2:7225:d14b with SMTP id adf61e73a8af0-3e9023f5055mr675991637.72.1793149579547;
 Tue, 27 Oct 2026 18:06:19 -0700 (PDT)
Date: Tue, 27 Oct 2026 18:06:06 -0700
In-Reply-To: <20261028010611.3929937-1-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261028010611.3929937-3-tjmercier@google.com>
Subject: [PATCH 2/2] mm/mglru: stop rotating offlined memcgs to the old generation
From: "T.J. Mercier" <tjmercier@google.com>
To: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: F3EFA40005
X-Stat-Signature: hdbafqusbka9jecx1e679ktsdog3nwbe
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793149580-519382
X-HE-Meta: U2FsdGVkX19DFRP1FjyhctrXyVsFzdslrE2G/18kPM6q/H5GsR9PNdM+u9OPvnQLtmet5ZDLnsZTO8XOhNNK0X+9H+rhniwUruAPpnTBeJObUpMpmwUElQ7GanLhEMVq0c6XgOOeVpmKZ5dHVgAW6ihYjbkWL0gaCXAMWNWRZusDlEmfDsTSiRR2nHvTZQMD0SKYFMEkPJSTvi99472hMs9sCuGcBkcnx/rGgxNJAquYuWSUbOt47YVDD4aHWrHWKmZcAeYLYvklNs4hzTE0nYiQB3y1tq5nVYxw4e4jYw9LwWnlcai0L6gX96SoQ10RUI1aSrgmzuO3Zc7s/JrQbyidBXiabGUAZz5Fa6uCjqu2VY0dOMAejmd4qty5ocTwAo48hoTGafTDqdvMAjBhuUp5J1EEBmbIpNaNzuI5pQIpoVfiU8jgSn3/AKfJMkH6p1zryhMOeAGoUaWpxgw00DlGiUZ8tNnhRuNT+EAUQRfzHm1jlt2KTbTfDQSJwkB1n5QUPdFFULDTeoHFAE/MxPEOo/TX3p4nUC9jP977bBSjhjvEOE/WkLfPdgxUMuPe63yrPF0wTt9OtASEXWb1L1POpvdMuqXRb0ehDt+L0KALXjUYv7UDNNJ8S8MQMqeSCP97sJWKYwqzwzx3PwDB8XajXCgJwfxL4L2l64rVbg8HdH6UM6yEBtFW+3hIIut6KcJYoTiqvEd7Z1k5dJIQLpJX4PSEfdkWLPFb2L9OWaSVvv0PlS5ontYvSbmJgl6alYw6vgKKhunbTBq+PqYQS89tWpgL/IyxadeLfd/8yUld1llsX3Rian6CxmiyyIBBoyVvW1B0P49eVv9wyN7jq5Prlvs0HhujOov0eledpAS4I7EqmUy4BnEHcfpgDkXXLQnBE5wY7lmHEjKyDabDepECURCIHRl81YwLuxAOVwCYq/MWuINqg+Ik3ItSItzUy4gwiPXDZZD5l0NfIGI
 O3b5Y3Y2
 Qar0vAuhsq0ccCzlJGSwkXGOWWbBwtxv7mYaqfu0ly2jayDFQkPBcjUGRzS6tJ4OEtk6se+aqC21ZQIcHOVCGYPHaSwN8vQT42o1ZG+ZLtB0sL7AA/LCZVgxF/VCRLsFq41920fzGUfVtNWc7XkjavEzGlgcHgss3hzewKJGKVHu1K19zv+BTDPyqGlgswiXF7QphXRSb2NVtM2MHzS3YlGhlWBoDZDMYJpj59rTZ9FkpvjR+ojrpYf0ThP4LLK+pdOuiWgwqjO/XaWpCi8OajY8CMkStxAJ9qCGvsJuuUrb2n7g6afOO3epo7mgO1A/fRTrBjgB7WN5RufsP2uW/kqGcLpjxsj3HMNLvHlGO4oJlDX43IO1k9AP47B2BAh/owqneYR55gVgJR/Jo9/e9tynqG79sEoPAwRqJtTGKBHrEzhah3l7R2liDYp8QumwwZ7lGbbA1t4SQSC34L3CT6wbvw9iJtNf22S1o8w5/mTXywJ/eTNxmh8TRySU5ajhfzxMrwaMkUImS+Bl9OBfaFJj6IXb2IS6A7nCkrDJZnca4tWSVI13BW5M+Cg/DAoJ4ucpvNIIOKF3jN9QLNSC38Kc/m6xrshAB0IRW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

lru_gen_offline_memcg() moves an offlining memcg to the head of the old
generation of the memcg LRU (MEMCG_LRU_OLD), so that global reclaim
visits it first and evicts the folios it left behind.

Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
dying memory cgroup for LRU folios"), those folios are reparented to the
parent before lru_gen_offline_memcg() runs, and nothing can be added
back to the offlined memcg's lruvec afterwards. Putting an empty
offlined memcg at the head of the old generation no longer serves any
purpose and only delays reclaim from the memcgs that still have memory
due to additional shrink_many() iteration.

Remove lru_gen_offline_memcg(), so that an offlined memcg is rotated
like any other memcg below the reclaimable size threshold until
lru_gen_release_memcg() takes it off the memcg LRU. MEMCG_LRU_OLD has no
other user, so remove the op and update the memcg LRU comment as well.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 Documentation/mm/multigen_lru.rst |  4 +---
 include/linux/mmzone.h            | 14 +++-----------
 mm/memcontrol.c                   |  1 -
 mm/vmscan.c                       | 20 +-------------------
 4 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/Documentation/mm/multigen_lru.rst b/Documentation/mm/multigen_lru.rst
index 52ed5092022f..b532ce961371 100644
--- a/Documentation/mm/multigen_lru.rst
+++ b/Documentation/mm/multigen_lru.rst
@@ -234,9 +234,7 @@ the active/inactive LRU (of folios):
 1. It has the young and the old (generations), i.e., the counterparts
    to the active and the inactive;
 2. The increment of ``max_seq`` triggers promotion, i.e., the
-   counterpart to activation;
-3. Other events trigger similar operations, e.g., offlining an memcg
-   triggers demotion, i.e., the counterpart to deactivation.
+   counterpart to activation.
 
 In terms of global reclaim, it has two distinct features:
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7f078ff0dd76..542e465ee7a1 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -626,12 +626,10 @@ struct lru_gen_mm_walk {
  * per-node memcg generation counter, whose reminder (mod MEMCG_NR_GENS) indexes
  * the old generation, is incremented when all its bins become empty.
  *
- * There are three operations:
+ * There are two operations:
  * 1. MEMCG_LRU_TAIL, which moves a memcg to the tail of a random bin in its
  *    current generation (old or young) and updates its "seg" to "tail";
- * 2. MEMCG_LRU_OLD, which moves a memcg to the head of a random bin in the old
- *    generation, updates its "gen" to "old" and resets its "seg" to "default";
- * 3. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
+ * 2. MEMCG_LRU_YOUNG, which moves a memcg to the tail of a random bin in the
  *    young generation, updates its "gen" to "young" and resets its "seg" to
  *    "default".
  *
@@ -643,8 +641,7 @@ struct lru_gen_mm_walk {
  * 3. The second attempt to reclaim a memcg below reclaimable size threshold,
  *    which triggers MEMCG_LRU_YOUNG;
  * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
- * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
- * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
+ * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG.
  *
  * Notes:
  * 1. Memcg LRU only applies to global reclaim, and the round-robin incrementing
@@ -675,7 +672,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr);
 void lru_gen_init_memcg(struct mem_cgroup *memcg);
 void lru_gen_exit_memcg(struct mem_cgroup *memcg);
 void lru_gen_online_memcg(struct mem_cgroup *memcg);
-void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
 void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
@@ -709,10 +705,6 @@ static inline void lru_gen_online_memcg(struct mem_cgroup *memcg)
 {
 }
 
-static inline void lru_gen_offline_memcg(struct mem_cgroup *memcg)
-{
-}
-
 static inline void lru_gen_release_memcg(struct mem_cgroup *memcg)
 {
 }
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a05d9a8baa1b..e2ddf0680e62 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4475,7 +4475,6 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 	memcg_reparent_objcgs(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
-	lru_gen_offline_memcg(memcg);
 
 	drain_all_stock(memcg);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 636152d8c94d..45a2c1021f4f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4538,7 +4538,6 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 enum {
 	MEMCG_LRU_NOP,
 	MEMCG_LRU_TAIL,
-	MEMCG_LRU_OLD,
 	MEMCG_LRU_YOUNG,
 };
 
@@ -4560,8 +4559,6 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	/* see the comment on MEMCG_NR_GENS */
 	if (op == MEMCG_LRU_TAIL)
 		seg = MEMCG_LRU_TAIL;
-	else if (op == MEMCG_LRU_OLD)
-		new = get_memcg_gen(pgdat->memcg_lru.seq);
 	else if (op == MEMCG_LRU_YOUNG)
 		new = get_memcg_gen(pgdat->memcg_lru.seq + 1);
 	else
@@ -4571,11 +4568,7 @@ static void lru_gen_rotate_memcg(struct lruvec *lruvec, int op)
 	WRITE_ONCE(lruvec->lrugen.gen, new);
 
 	hlist_nulls_del_rcu(&lruvec->lrugen.list);
-
-	if (op == MEMCG_LRU_OLD)
-		hlist_nulls_add_head_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
-	else
-		hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
+	hlist_nulls_add_tail_rcu(&lruvec->lrugen.list, &pgdat->memcg_lru.fifo[new][bin]);
 
 	pgdat->memcg_lru.nr_memcgs[old]--;
 	pgdat->memcg_lru.nr_memcgs[new]++;
@@ -4613,17 +4606,6 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg)
 	}
 }
 
-void lru_gen_offline_memcg(struct mem_cgroup *memcg)
-{
-	int nid;
-
-	for_each_node(nid) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
-
-		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_OLD);
-	}
-}
-
 void lru_gen_release_memcg(struct mem_cgroup *memcg)
 {
 	int gen;
-- 
2.56.0.307.g5fe7bd680c-goog



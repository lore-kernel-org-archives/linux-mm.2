Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09652606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WOIX0dy5
Received: by kanga.kvack.org (Postfix)
	id 1E8666B09E3; Thu, 22 Oct 2026 18:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C01D6B09E4; Thu, 22 Oct 2026 18:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF496B09E5; Thu, 22 Oct 2026 18:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D2FB56B09E3
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:03:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57B28A02DF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:02 +0000 (UTC)
X-FDA: 85351638204.16.2A50C40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id AE701A0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOIX0dy5;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706580;
	b=oDgBTuYIYVHmQVm1OHdQe16/oMitFcsB5qDwHXypDXUzOY7UO8B3+MbHfWx3sbrra23cEg
	SYYF90uqRgwALA+v26rnKHtyG2Z3CR3ddqCu7BL3uO9F8vkQqUPu6DFxVg2Y8MUdN0aoN9
	fkm9Hlg8TUCR3MMpBXSDK/0JuHjquCU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOIX0dy5;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Fk/aE6plvRET0JhkIxplBx62u989q4tddIWIjnOMgs=;
	b=6tVdsVn5lwJLijdmI40iRVzSkWZODLHR6Rx0Oub0boETqxyPgctJJIrH1y+FLh0QxJjhJW
	lJ9AtDxbotAMwk6j4Pg0WpiCXyFw3q/1gOl/VeY4f02icT9qN/JhrgTrjDEZfNY5YeohYk
	n/u/PvxUeo6gonVNta0O+3SnV2hMsPw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4773D605EF;
	Thu, 22 Oct 2026 22:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2C41F031E1;
	Thu, 22 Oct 2026 22:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706580;
	bh=9Fk/aE6plvRET0JhkIxplBx62u989q4tddIWIjnOMgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WOIX0dy5cgSndPOgPAQldjDETk22JiUXdVEyYGbp0iSHkphd/STXXnE3qX89ZhYnB
	 rD181A2IsqDtFIFqNfPJw+a63APGdsvgH8mGh8WTrYR1EpbV33/FeUpSwFTfZkq31y
	 ItKEXBT5tUpTRWWhbv7xmdvLTFyIZE/ND5MJga8+9Kh1FyNyEtLfD1WAPBW73to2Xm
	 Hu9reh1OAUtlwxCTTK6Tc7cu88/x2ywxWKbAgd++LSx7pwrhOSgykTAx+KkUGjvIcv
	 UFaACPJpNdtxHNvZr1GMkjr6jGDALaczIKPFXyVPJ8KBkubEXZFkAURaT1OrRii8y9
	 SwJ1hmQSAZeAA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 09/14] mm/mglru: Avoid placing rejected folios below populated gen
Date: Fri, 23 Oct 2026 06:01:58 +0800
Message-Id: <20261022220203.91911-10-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 31ghkc9fo49acd9pr199nyrb771wnqyy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AE701A0009
X-Rspam-User: 
X-HE-Tag: 1792706580-102252
X-HE-Meta: U2FsdGVkX1/zbB6UXKNSqALMFgil1+6mD9eJrjdZ9ughsjFUhGEx0VIFA+BDgSd/tXYGq3bxq5w9I7t+5fK+zemeiuen21ReNIg0fqP8SFYtTEQ4yDSsPzN/vtH1KBdtxdo9boBd3Nn8cqZ6a/2UhA4tGY5omFDq9RgKXc59zVUwypsB4CA7MDUcM1wHn9rafeY5TSD6vdr/O5OkTmOFYgQKGIOdCk5cb7eEUYlZfsOi5iAbB74QMRIZ8mPPXKwiL1cMgF6qMObb8b0tkuG5WRbBlYz5sxmAVuN3dpfcJmuJJDXvthjLvyNvWGBszoRrMgcEFWrCUvibCH5+bCkc1GH3pDZ+qUSLMUMGjYfCRiD/PaT47cK93T+v0uzVFO/bn2/1aVk1sNmqltrlUHua9axLFIB9e7JKPnS1OZExEhcst8DNcK7RckZNClgkXZrYdmFfwTRwz2P+cPkULd6Qlhqvsw6OUTDqw24oN56ekGhSwKlKcAZGJoxjS+hHI4pQGcS11RMR3EVFcX0ijVJoChi0L0VJHbnIDSE/bJabMf/M37mQpwU2PyWmxM+F4nXgquodjSIzHp1fQTG/PHaweD5IndzBLkYPdjv5/MLveKjpt6kucmDeZOB6GZ2tS75SReLWM+34eJabxuSf30MjKEcyuqsDtSQtGvpjZQvTX9aNcz8FKKnjbLbX80FKRJxu+ZuWH6y3xfjSIIVjTmrrM8fNEB8S87q7oPA7Ve9QT22y2JFbDxb6bnpKFzQxMmtm6G20jUYhcloVSsioi80+zlWwdp9WMSMMrbTdo69mwWhV8NvUzkUR8bjHZfaZMu1dSnlQwClMxr4vEcCVUyg0JzDHapsXNlaOXl6KjFvOuMVYRx+uWQTZXT9izMz95H3cM7lG3cH/ICxktE48/jEqxY8Dkhb5/MEg8bQzpmZXDPpzGxuE12j33rQs+5StA2sRCCUm0JwgoWOVk2oOiFm
 xRgUmgr0
 Tv8UFS8zGurIN+npNn5m3UHe6e/+GrlaFOACHi62P2+13qsW6uuk+xWxGY9FRJyFku8SqApi42NL3rcDSjP7NUsZkeazBoNgkrvMjQx+S5SqobaPkci3OEkfI/Ax5EPKNHRYsG8+qs+nkfdKVg503nMtR8JCleam4q60FERCllIukv+KrgBKFRfsNHXrfmbZK5HU9lMYHytq7K8oCgDu2E3lETHZXZcl9ESepG5PtT0eqGcdcZUctJrxZahQv2QalZtpiVozF0ZYByDckQhLzXpNYsOobg6iUB4bXyOKyKgXwoTsU5wTDGYcJlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We used to scan only the oldest generation in scan_folios(). In
evict_folios(), we checked whether
lru_gen_folio_seq(lruvec, folio, false) == min_seq[type]. If so, the
folio was marked active and moved to younger generations.

This was itself buggy, as folios in generation min_seq[type] - 1
would not be marked active by folio_set_active(), potentially causing
a cold/hot inversion.

Besides this issue, the old approach also differs from the current
behavior, where we can scan fewer than two generations.
Now that we can scan younger generations, including the youngest
generation, this no longer prevents rejected folios from being placed
in a generation below or at the populated generation. Such rejected
folios would then be scanned again and again, resulting in extremely
low `pg_steal/pg_scan` ratios. For example:
  pgsteal_file: 2312605
  pgscan_file:  36465693
  reclamation efficiency: 6.34%

We pass `scanned_seq` to `move_folios_to_lru()` and make sure we either
promote the folio or place it in the youngest generation when the
populated generation is already the youngest one.
Also, folio_set_active() is no longer needed.

With this change, the results become:
  pgsteal_file: 2683815
  pgscan_file:  4224244
  reclamation efficiency: 63.53%

The sys time for building the kernel also decreased from 4m30.532s to
3m50.188s while swappiness==1.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 include/linux/mm_inline.h | 22 +++++++++++++++++++++-
 mm/vmscan.c               | 24 ++++++++++++------------
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..f6f4bc9a704f 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -332,7 +332,8 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
-static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
+		unsigned long scanned_seq, bool reclaiming)
 {
 	unsigned long seq;
 	unsigned long flags;
@@ -347,6 +348,8 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 		return false;
 
 	seq = lru_gen_folio_seq(lruvec, folio, reclaiming);
+	if (scanned_seq != -1UL)
+		seq = max(seq, min(scanned_seq + 1, lrugen->max_seq));
 	gen = lru_gen_from_seq(seq);
 	flags = (gen + 1UL) << LRU_GEN_PGOFF;
 	/* see the comment on MIN_NR_GENS about PG_active */
@@ -362,6 +365,17 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
+static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+{
+	return __lru_gen_add_folio(lruvec, folio, -1UL, reclaiming);
+}
+
+static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
+		unsigned long scanned_seq)
+{
+	return __lru_gen_add_folio(lruvec, folio, scanned_seq, false);
+}
+
 static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
 	unsigned long flags;
@@ -420,6 +434,12 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
+static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct folio *folio,
+		unsigned long scanned_seq)
+{
+	return false;
+}
+
 static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
 {
 	return false;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 12aca97be56b..39f77a68be37 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1971,7 +1971,8 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
  *
  * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
+static unsigned int move_folios_to_lru(struct list_head *list, unsigned long seq,
+		bool do_rotate)
 {
 	int nr_pages, nr_moved = 0;
 	struct lruvec *lruvec = NULL;
@@ -2028,7 +2029,7 @@ static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
 		    !folio_test_referenced(folio) &&
 		    folio_ref_count(folio) == folio_expected_ref_count(folio))
 			lruvec_add_folio_tail(lruvec, folio);
-		else
+		else if (seq == -1UL || !lru_gen_add_rejected_folio(lruvec, folio, seq))
 			lruvec_add_folio(lruvec, folio);
 
 		nr_pages = folio_nr_pages(folio);
@@ -2147,7 +2148,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	move_folios_to_lru(&folio_list, true);
+	move_folios_to_lru(&folio_list, -1UL, true);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2258,8 +2259,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	nr_activate = move_folios_to_lru(&l_active, false);
-	nr_deactivate = move_folios_to_lru(&l_inactive, false);
+	nr_activate = move_folios_to_lru(&l_active, -1UL, false);
+	nr_deactivate = move_folios_to_lru(&l_inactive, -1UL, false);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -4910,7 +4911,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list, int *isolatedp)
+		       struct list_head *list, int *isolatedp,
+		       unsigned long *scanned_seq)
 {
 	enum node_stat_item item;
 	int zone_idx;
@@ -4941,6 +4943,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		seq = lrugen->max_seq;
 
 	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	*scanned_seq = seq;
 	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
 
@@ -5135,6 +5138,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int tier, scanned, reclaimed;
 	int isolated = 0, nr_isolated = 0;
 	unsigned long total_reclaimed = 0;
+	unsigned long scanned_seq;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -5146,7 +5150,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	tier = get_tier_idx(lruvec, type);
 	scanned = scan_folios(nr_to_scan, lruvec, sc,
-			      type, tier, &list, &isolated);
+			      type, tier, &list, &isolated, &scanned_seq);
 	nr_isolated = isolated;
 	if (nr_isolated)
 		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
@@ -5172,8 +5176,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-		DEFINE_MIN_SEQ(lruvec);
-
 		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
 		if (!folio_evictable(folio))
 			continue;
@@ -5192,11 +5194,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		 * so this effectively promotes them by at least one generation.
 		 */
 		folio_set_lru_refs(folio, 0);
-		if (lru_gen_folio_seq(lruvec, folio, false) == min_seq[type])
-			folio_set_active(folio);
 	}
 
-	move_folios_to_lru(&list, false);
+	move_folios_to_lru(&list, scanned_seq, false);
 
 	walk = current->reclaim_state->mm_walk;
 	if (walk && walk->batched) {
-- 
2.34.1



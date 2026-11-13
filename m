Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4FAB606B2E4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dkhTZgJI
Received: by kanga.kvack.org (Postfix)
	id C5CBF6B05C0; Fri, 13 Nov 2026 13:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3ABE6B05C6; Fri, 13 Nov 2026 13:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AADE76B05C7; Fri, 13 Nov 2026 13:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77B766B05C0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4CC11C28CE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:36 +0000 (UTC)
X-FDA: 85431001992.23.449588A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 501AF20003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkhTZgJI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ajYCha50EQl9+H9M7bL6r/fZ9jHUuzU39/jgu1TzRj8=;
	b=5y1jYTkCL6SPnxzsrg8LBXIm3fX2wKTd3X3ziscYdXV3icLeV8fSOmgxXLxYGIQaxSrQqw
	f9z3yeiPD+OMz9j3Dy5XO+fX69j1CgBQX03Iga00l6nXwiOF5MqiiOSaZv+L/6AI7cJkJa
	lm9s4OSaYxFM/HoUBk67bXXQ31OBGs0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596195;
	b=3EE5n9HSOghDPEyf4Qz4pdgHIJjzpxXE9OgIFV8S9jCqKQmNs687RHIAwvGJzT9tsO+vbh
	4wfxRqyB8jInfQF7wc+7leTl1JNf+aBkl4jl3sPY74IOAWDlINu/eG4LyhIOeL+ov+JuUE
	gmHJ0ob2QM7V6Z96sVRZgSojoO/foJQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dkhTZgJI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E55D163319;
	Fri, 13 Nov 2026 18:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92F51F000C8;
	Fri, 13 Nov 2026 18:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596194;
	bh=ajYCha50EQl9+H9M7bL6r/fZ9jHUuzU39/jgu1TzRj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkhTZgJIIEUYH1c/lcXkoBppbQxdmPhTzdGaU2x30T6mSbIRIL5f4s4hx5y7EXsZm
	 zp47oGjg6t3aU/+ZkhKa6UmOb09x6s010eQorIL85vCila2VHtWUMcvjUmirJBY5KH
	 KAn6EadC1n9w/KSGZHKpwIucHo09xPfB4N3enqRadnEqz8Idj6z4M6O4LkdLosvDc+
	 LvhiL4lFvLhfRg3vxu9XfC1nhG5xS6oO/JQFfm8plwg1w7C30a1HQAJsNs6fYljDsy
	 6T1TzSMG2tM9wrBRw8I+3z7QyXhT+lerdMHjME5OPFibqMV7IFh0aeyzEpfQK6LpFl
	 GCMXWfPG4CVZQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v8 09/16] mm/mglru: Avoid placing rejected folios below populated gen
Date: Sat, 14 Nov 2026 02:55:34 +0800
Message-Id: <20261113185541.70203-10-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mn5tppxoaap1bq7w6pms6zwyiazk3dtk
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 501AF20003
X-HE-Tag: 1794596195-653054
X-HE-Meta: U2FsdGVkX19D3wa05PJ+W00t+Ih/XRxCmT+UAfTYZ044lA2spF8nNy2VMjvsVff9523xVsm8aSRLZ2ffBKVvLUYk8Sk6jZwVcGDNuI4CPOjzl1v9Z0ERmgJcquZ1PCGxwdw4ceX/jckWsIImF8bMviT2SJj4ymYiegkdJoS5UD58EHKh3xu6zJZQGazbLxl03zfx6n118UqxFsyUCk7qDi9MGgooktyiEGzPK85gxN3OV7eORo5SYxae4daFWqu50EtppA+qLYV51PGvP7ZUfSQUcWth8hvaEB04+N9iq3+pYMpBkxj49bmBuBsTi6IywwbB6cJ9ULI2vQx2m4xPxgE78yBNDylXPqNP3sk3TdrMwJkxUruUouAOA/uERN6s+BnBuNOSVrPgQeFqIfgNaGGoe+vPl9pKE1JZe5MZWmBhshAAVJr+CIABtDO8O1oYBPdJocdRIAhcjhR6JEnVrkeVRuFTHfJyshENR098VgUm/yPBRUpBekxNYy7+xra0T4PXhGcQp4sXMWhSNJYwYmAPdHGICLUtsX7qcA9imugEATlv+BlXEdTWj30d3EFSMAjt3bi7iplDGkjkxyUhk/u+dEgD+66tTIMbyklcuTR01+sNcKAspVNgfEqWxYXU7b3t617BIECsFzIMiGJVeg6lXNIHxX/9PLTPuNc3cbagI/OEFacktL7rD6gJ3DQ/8EUoOTSCIhiQizQ4/2l0fki7g4quz1nk64BQ5oxcXjdWMQOMnYaRBgZI+gWLoGsWgbKepq2xMWq88UPjTijyoufC7BxbLCF7Z30y2gq7YRUHmd8vswbx0WKZkQuMmuulXUH14ekxknsxBsvqnwZ2yFD8l4FjH/FlDobe6d+sf/Xp+/AmDWtSizEGDW5qcJE3U8kkWm0sYAevyrQqkWfjpPXJHjc2+sj6DIG4XIrtc+vSYwTfZeS9da2wA21lUM8oEzhGOwquLfp3bIJa512
 TQu0ow8P
 e2RVmKYvmB7yGvwKRvSiHrIPgAdwJLt0cZxjsj487hgkjMVnUkMib22VF/fFSJ4PrUJ3wTkEJ6OBwb2tsmoImdKXacTR7V5CIspqQj3V53hkVUaoKvKvcuNBv2MecbDOg/JSYcmSCvNeZK3uy8YwG+GmtXZkitOjT03Pzulp7YHHhsRAd5dkMYciAsBs1i4XBv9kxjOSKFYAFy814bGsinULdS52ffBFR/BCPXWoWdjvSyP2PeRUGAFGv7rIzz7tfkmTji+HEV1b6luYkKXOu8GP/P/HqQacqbM94W0pGITXf0wHW9JJHlUddaf7iT/dQpU1T8rdf0RhM9ZY=
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
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
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
index 8e0972db35da..8bdc88748959 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1865,7 +1865,8 @@ static bool too_many_isolated(struct pglist_data *pgdat, int file,
  *
  * Note: The caller must not hold any lruvec lock.
  */
-static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
+static unsigned int move_folios_to_lru(struct list_head *list, unsigned long seq,
+		bool do_rotate)
 {
 	int nr_pages, nr_moved = 0;
 	struct lruvec *lruvec = NULL;
@@ -1922,7 +1923,7 @@ static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
 		    !folio_test_referenced(folio) &&
 		    folio_ref_count(folio) == folio_expected_ref_count(folio))
 			lruvec_add_folio_tail(lruvec, folio);
-		else
+		else if (seq == -1UL || !lru_gen_add_rejected_folio(lruvec, folio, seq))
 			lruvec_add_folio(lruvec, folio);
 
 		nr_pages = folio_nr_pages(folio);
@@ -2041,7 +2042,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	nr_reclaimed = shrink_folio_list(&folio_list, pgdat, sc, &stat, false,
 					 lruvec_memcg(lruvec));
 
-	move_folios_to_lru(&folio_list, true);
+	move_folios_to_lru(&folio_list, -1UL, true);
 
 	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
 					stat.nr_demoted);
@@ -2152,8 +2153,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	/*
 	 * Move folios back to the lru list.
 	 */
-	nr_activate = move_folios_to_lru(&l_active, false);
-	nr_deactivate = move_folios_to_lru(&l_inactive, false);
+	nr_activate = move_folios_to_lru(&l_active, -1UL, false);
+	nr_deactivate = move_folios_to_lru(&l_inactive, -1UL, false);
 
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
@@ -4753,7 +4754,8 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 
 static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		       struct scan_control *sc, int type, int tier,
-		       struct list_head *list, int *isolatedp)
+		       struct list_head *list, int *isolatedp,
+		       unsigned long *scanned_seq)
 {
 	enum node_stat_item item;
 	int zone_idx;
@@ -4784,6 +4786,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		seq = lrugen->max_seq;
 
 	seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+	*scanned_seq = seq;
 	gen = lru_gen_from_seq(seq);
 	max_gen = lru_gen_from_seq(max_seq);
 
@@ -4980,6 +4983,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int tier, scanned, reclaimed;
 	int isolated = 0, nr_isolated = 0;
 	unsigned long total_reclaimed = 0;
+	unsigned long scanned_seq;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4991,7 +4995,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	tier = get_tier_idx(lruvec, type);
 	scanned = scan_folios(nr_to_scan, lruvec, sc,
-			      type, tier, &list, &isolated);
+			      type, tier, &list, &isolated, &scanned_seq);
 	nr_isolated = isolated;
 	if (nr_isolated)
 		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
@@ -5017,8 +5021,6 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
-		DEFINE_MIN_SEQ(lruvec);
-
 		/* move_folios_to_lru() culls unevictable folios via folio_putback_lru() */
 		if (!folio_evictable(folio))
 			continue;
@@ -5037,11 +5039,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
2.39.3 (Apple Git-146)



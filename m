Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5D11606B347
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nmMwfM2f
Received: by kanga.kvack.org (Postfix)
	id E0A416B05C6; Fri, 13 Nov 2026 13:56:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1996B05C7; Fri, 13 Nov 2026 13:56:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7BA6B05C8; Fri, 13 Nov 2026 13:56:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A93346B05C6
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:42 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29DDD1402E2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:42 +0000 (UTC)
X-FDA: 85431002244.12.64CD494
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8011D2000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmMwfM2f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NW8nmh3F61gF8JllerIuj4vC7Vf5nVwoCNHth2XqrMk=;
	b=mNb3Ix3wEbd6soicqSIn2OyxNVkejFL6ZEHMukuYzXhD/QPBOP2mGByb0/bxXsgaxriSIT
	tad4tjBo1F6lKlnKQ4l2XGJrPFiNi2I/aQYwIBgYB3n8OoP8jryG6SKBNaUfxsSR3aisXK
	lqR7YfHroQU60AlL5Gli2l2+VqJVQEQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596200;
	b=2StpeAVLCJAlFH7QpOFZMvfXo6HAiggdE+xLKUKt4i9EeMtcncUzf7467Ab9d4TZksCQDF
	wKFYO9YQEgr6mCFkMHfgQlXwulNnb9vJ371kjbCt8JYQmlBxXaot9HRp1up0EEb4OD1V8s
	cWWQwel947vBi7RoF0rUalB5FcaV1mk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nmMwfM2f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D280C400CC;
	Fri, 13 Nov 2026 18:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7951F000C5;
	Fri, 13 Nov 2026 18:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596199;
	bh=NW8nmh3F61gF8JllerIuj4vC7Vf5nVwoCNHth2XqrMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nmMwfM2fOnmhhn2bfnthfL58t+QqotwcdXDg1Yu4FmA7EJFnZRc6ZKqdsp1ShiERG
	 npdWCP9NL7van4Fc4H8pMh7LQq7Pw8SfTTHsox9ZsRyIiPFqD8/xnfgvUxIyK0feCK
	 ncDWah39lfjfEWnGzkKBiDQciDMeGZv769d0BpeRh3O5Jfyh36fZgQIWU8WeYGncjU
	 Unhdft4P/n0NICrqjCpzl7AuKUV9cJjYXZHvsF+LWnubzOrYu9hSlBtVEcze+v+o1q
	 jHi1NFLjHilJj+ifYu1hJIBR1/I/5en7NdiYlpCENS7X8nmf2smkBhOO5VCTJ6GnJq
	 GPVxHPaPhht2A==
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
	Barry Song <baohua@kernel.org>
Subject: [PATCH v8 10/16] mm/mglru: Run aging when pages are rare outside the youngest gen
Date: Sat, 14 Nov 2026 02:55:35 +0800
Message-Id: <20261113185541.70203-11-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4a7zig6u6mfowtbuu9nd7bcyghc6wi8c
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8011D2000C
X-HE-Tag: 1794596200-978622
X-HE-Meta: U2FsdGVkX1/khnfQwqC6eZ12lyJv5e0bIflrK7m6uESRtU84vQVlKKLYyErO6eedt4gazKBQRQSylFSMcovWS6QfNvX8JUQPYVgGP4u3Sg4MbqGzmnerMzKNzvvS+Sv8vNgsTJ7sEkwhKxsM+LyzKdOnAd6xIzQs2CYjxswdKc5QUX9zCAEHFVNaUARCY9QARmRLhhJbPoYg2dkul5kZvJtXmdYHl2PXffNZDU7qs9wCVeQ1UMEuTrHao58i8HmyDRmlEJRI0De0yQ+3USSi/eEdXnFmX1lelfH/4bb0LhpLhTwvWJ66GPyl62LOso3gdMRAY/k9nEgomSL7DqqQlVDw8JUPy12v4GxdZoV8mKfsKpfcgXCI5xfT2y03BSinq8J9zFbSq3/4tVz7vWrJQ3KWMkoFi+zWek24WEXNrzUNZAVPtC+W+a/vNcl0kRBw/kuzKonHOI6BJ0lQ7oS8NKeVeRupaKnSTZbhO9nXiB7q1l/nN28JRsKl/iKuruGQTMH4Alkzq/aagvFKbnQwt735Vh3GxT+CtVCqTg91YNSbTAo6upQyGhp0r5EHRvfa65PBJqnEk8L8zN0i1p6SY9IVeZOSbqPYxB6WP6NVLq5t7yt0j+/LIal2SNK8EKnvBW64bBh37/PY5u2Uka8dn/JbKrdsX306g5avsTyok87lFmORMOEJ7QRvwSzTtspcSEdDA/kMq9Ug7pit5hSze6bL9PGLb5oq/AJsG/He51a+6fkIq6GWGEwOJvkjOWhMYZb+8eC2nsrjpyaOPhghhw4cGiCfkklbiVyfvs3syOCuEatJ/DTIgWl2Ig0L+qGUZAS8YnbvyM2OggdgtJseSfaV68hyJCc0Kd+mu6WsXEoVLZq725EfEUy/OZ3mCa9R3hpQBaPR/AuFjgk+6ARtdlQ9Wko0awZDhaYcIRUfNC1OVHcYN7XROlZl5PsLpoh8OuImvY1q62IbjZAIqPn
 iyL9k5In
 1iJ1refodXjumAY46pFjib9yMpy37Qjgn8u0iXywjlx96Bbq1/faVNG6qM1VVLFI7Jsqnl3W0/0WNC2uNinRToA7Wt4vHj9f3r7fXGTqVP3tocn5eR+v/Nwx4x9usRB3782o8aG6VVMzMsn2amlLE0nGe5dGAEcyAxx8HVvJ6qQOpbBmIyJa/sTApqoATCeIeRA9SOoUk2pu9Ep7FYAeKLzxjBhOfojUfJkIfEg40GWu5qQ2OLC8jRwUHqdCKuf9jXECdtbXEdo4LuHIirqHnf0MZ9sn5tcO2lkkKdZBcEuAEMN0knaQshiV6F4wOrP6/nhp2SSuFFALM0IM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Gaofei Lyu <lyugaofei@xiaomi.com>

Run aging when the total number of pages outside the youngest
generation across both types falls below 1/MAX_NR_GENS of the number
of pages in the youngest generation. For extreme swappiness values
such as 1 and 200, also consider the balance of the corresponding
type.

This improves reclaim efficiency, especially at extreme swappiness
values, while reducing system time.

To avoid the overhead of aging, we only allow imbalance-based aging
when the reclaim priority is low enough that we might reclaim the
youngest generation.

Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8bdc88748959..59957fab915b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5073,6 +5073,41 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	return scanned;
 }
 
+static bool lru_gen_imbalanced(struct lruvec *lruvec, struct scan_control *sc,
+		int swappiness)
+{
+	unsigned long youngest[ANON_AND_FILE] = {0}, old[ANON_AND_FILE] = {0};
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	DEFINE_MAX_SEQ(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+	int type;
+
+	if (sc->priority > DEF_PRIORITY / 2)
+		return false;
+
+	for_each_evictable_type(type, swappiness) {
+		unsigned long seq;
+
+		youngest[type] = lruvec_gen_size(lrugen, type, max_seq);
+		for (seq = min_seq[type]; seq < max_seq; seq++)
+			old[type] += lruvec_gen_size(lrugen, type, seq);
+	}
+
+	/* the vast majority of pages sit in the youngest gen */
+	if (youngest[LRU_GEN_ANON] + youngest[LRU_GEN_FILE] >
+	    (old[LRU_GEN_ANON] + old[LRU_GEN_FILE]) * MAX_NR_GENS)
+		return true;
+
+	/* Swappiness extremes: the corresponding type matters */
+	if (swappiness == MIN_SWAPPINESS + 1)
+		return youngest[LRU_GEN_FILE] > old[LRU_GEN_FILE] * MAX_NR_GENS;
+
+	if (swappiness == MAX_SWAPPINESS)
+		return youngest[LRU_GEN_ANON] > old[LRU_GEN_ANON] * MAX_NR_GENS;
+
+	return false;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
@@ -5087,7 +5122,11 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 		return false;
 
 	/* better to run aging even though eviction is still possible */
-	return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq;
+	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS == max_seq)
+		return true;
+
+	/* run aging when folios outside the youngest gen are rare */
+	return lru_gen_imbalanced(lruvec, sc, swappiness);
 }
 
 static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
-- 
2.39.3 (Apple Git-146)



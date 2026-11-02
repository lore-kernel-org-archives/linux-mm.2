Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5208F606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nrj6Jq6j
Received: by kanga.kvack.org (Postfix)
	id 612A46B05B5; Mon,  2 Nov 2026 17:51:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56E4F6B05B6; Mon,  2 Nov 2026 17:51:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4363A6B05B7; Mon,  2 Nov 2026 17:51:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19C556B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:51:06 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C17A9C01F1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:04 +0000 (UTC)
X-FDA: 85391676048.26.81CE12A
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id DFF9F40007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nrj6Jq6j;
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793659862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8k0YpciZy/RNGLWCkWb5Euha9kzjWaqxc+X4RS4poFk=;
	b=bszG6SxKvRRyuHLJAJe1/QCJJ4tjkq+Xf1py9wozKV1LWdm4/Qa9hmmLqYC85ti1n7An5D
	g/KQIgTX6AtZcUQzaQojXi92EOPcq2wFyuF8lQcNxNiNIzDeP0Mi0g7rm/S8HU45xTuYnp
	Cy/PV3g+QVUkmWc3Wyscvzd8mI5+Wls=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793659862;
	b=fWVjtbfBrdv3mEFv9n09lLAvdZos/GXm+AaDGfZMnoDNfjaV6hTjtP0BlSIIpaNEzfasgq
	g4CwkJFDj6b5TY7UKuhi/PlRP1YkHB8IOprsF+diIlQq53WfRqajWg0I+o614fG40/LJZD
	DUWRFFNFe2Y1h0+sQ11XsXcdrrQUhmQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nrj6Jq6j;
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b0ca1ebc8bso29624977b3.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:51:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793659862; x=1794264662; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8k0YpciZy/RNGLWCkWb5Euha9kzjWaqxc+X4RS4poFk=;
        b=nrj6Jq6j1Pfcv9B8pN+ZJVPu/rI6zyv6WJGl5F+zmMdBySwDVxgBWvoUlk6dBQgs/y
         WoYRKQokjlDsKyZi90WpRqJZMnph3IvywBjSoWkO5Yz0YvGXrAEvO80G0VXhErnynJRO
         Lo57CU21g55lo/IDNyQmmtOpYDPPnn00ujnfgaI2ZHr4Z3Xy1EwoYkimF4emB6a17BMM
         LVIaz5VZ4WHbLtPp55iweEQyDa1hbT1sDuQyedN0jAJyQ00aYrL6A1irRDO3mg3f1nS2
         OdX6uJEMih0xe2WJiWgMvNtvz2wWhd1a+XGAZLdWy/iqKUzdGne9KDgCoZfS6tt01GUj
         bfQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793659862; x=1794264662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8k0YpciZy/RNGLWCkWb5Euha9kzjWaqxc+X4RS4poFk=;
        b=HDyTl7aIHedeJ9+0HKwuZwZUPpSUVGRNXtQ1ulhTsjwkmVUCX2YYwLomgPToqE+uDf
         tEYEXYzZbh/0CW9xRw1tlRAc6hkdzDu/j9mgm801LRJmrNsM8c6O8ARnk90PaDYCO4kQ
         I9q7BrqFfk3u9UvdhOeLHCny8lFn/7bJaan8PVs7aLOMJHkXp23w0lGpg81G0m/67Pzz
         DYqYoZEQ0EywTfGGLBJJWSvzEP9qZNMsmDOQ/UrlVjJ/cJSYZRwPgYSk2pmkNh0Egst/
         O90ydbDkE/bzZCXAhXCWi2KBmNxi0VGjX/YT+86+xLM1/T5Gc7cQsGEc84j6+s9hv/3u
         JlFw==
X-Forwarded-Encrypted: i=1; AKwUvBxslB8ErUsEGKQNoWZHqcJGjQL2UIemXfxRIGVgkuNA6XqfSVyH0sdq8gStV1YFl8rjJFQu3j5sYQ==@kvack.org
X-Gm-Message-State: APuU4Z9TgW11l2uXvi/Wat74piI5WkOzM0jzYuqJqECcbW5zH595yQFH
	6pcy82zwDra+wnC/Tevwv0tueU80mUfYhCZOtyl/6yb8IcxyQB4Xovnhv3nqug==
X-Gm-Gg: AYBFou1Ja8N55GPU5OVAb+wzwJR2aCkec5N0H8CQVtucJpcB0r9iZKO6S+RcX5ZlS7g
	KjzxY9XpmoaKm3LKlE4Lvz9sFMynS+rzbQA9IJEMhr9x9W/B+nPFGSJ0hK80bC+1ckVrnEe/3KR
	4DK3lnU2vud1BawsyDHkC+Cmw3xoSENIzSbUc4eHGNuAFONiy1MPjOSnYp6VciQXKGECPyqZDS+
	oz1SWBycBCaAnpoQaU/5L9j29mCW8r4q2ZF2dVlAZXhZ0JYsR/HvqBL5uY/Lpn7DKCNiX6uhT3j
	HBCPb7Uk9vtA75a3j+45C9RwnYW7ZGcucKv0bOxaoDIlCCrfHm778Imrc2fmXWVqQqVlVKcxS5H
	5jptuKm4FaCObopz+8D8qr4GzbDg8rJFfZ1kacsO6pQvWl/vZgh96iid2ACwz2IJL9WuejJHJkH
	U9jCXgNTLYnlgW41+mc8kWMxTty1djBzUk1xFCrTUQg61+iFO1GgDZUqjL18j00wm/QB8vPNFtY
	sBifRFwttWKrRJ5dEAJqU1sIq+8Nyt8OL3S/pwgHGCuV14XKyp9X42KyXBjNs5MlRzB/w6iUbko
	voqM+BdpnBhDTbp1z544c86jQ/FodpyA+Vn/sbNW9aS8Z+boijhJD3zeu0ZC6Wap2faEKenqYkl
	nqy2j
X-Received: by 2002:a05:690c:6d81:b0:8b0:8b34:edc2 with SMTP id 00721157ae682-8b2b66c629bmr83714117b3.19.1793659861879;
        Mon, 02 Nov 2026 14:51:01 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b2b71bce56sm60299087b3.44.2026.11.02.14.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:51:01 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v1 2/3] mm: memcg: read root lruvec LRU stats from the node counters
Date: Mon,  2 Nov 2026 14:50:29 -0800
Message-ID: <20261102225030.2743129-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261102225030.2743129-1-joannelkoong@gmail.com>
References: <20261102225030.2743129-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ueaoaot9e87wydxzqk5z3f8umh8ax5do
X-Rspamd-Queue-Id: DFF9F40007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793659862-972850
X-HE-Meta: U2FsdGVkX19E4CJi7j4Vrm/5nsDpczAfJAmCs1Cz2nL+EQprTsiY4e4Fhp46x1UD2no9bFnWocCSLGXdylYvC0K+HULkGBkUFDvdbUWiHwembeGpbYkoTKT/1wOH+MrJ8AmU3y8u3pYB9zxp/hQ/KtYZquu6kIov60WQKN+tdZPYltbWDEgd9HgtUTFry7xbNt/wPdMVEtb/ZaIZiivhA3SrRrCIssxDRPqZ9a1Dw6s3zy0SfIhFrveNHlJxHdcoIxJj1OYw2laHSP63cfsBEV5zDzSwEbHEDNfZAbxYqbh2J7B1ndn489Ctr4Kl0Jq5a4DI2SLM5t+Id4noAljjQ6KSyRVxjlry/O2xoEXxjaGNe9WBDwtFqyOc89b1+Xxa9JFjGLJFyA2VOL51RPAsKxg3gT0fuayPxgkOk/aLM7TYELGoAT1nSP6CFtS74PagjjKuNPJVSzm7LWh793OUtYj6RMj3BsuGPJ35iCY56T53wGDg8hkdlStmCHpBpfqDVJZrVgrbr1096V+lQ71TgylGctzzAyV+62J9mVp1pd3cHKRYTKdZP9YyB9XUZDKYxyMCBJY9JzWphtwz8pPvoBI1peml9E9IaWB9EkhJLs5gNoEzUDvM9Pgml8wNfgiDCE5qrW8/r4DPYu+vC0BXIdJunnKi2fm5wTK6fQMWy7CjAOzE7QzN3ClL4E3G/r8e8mCFBe/Cw9smRl3du95DGp2FPAW6iAiz0w7IsBwBsh1Lv8iNJV9D2vYBdSYx1w1lvdQ0zfccBDGG1um1loG230G5X6Aa/+i0LEIqocQrFplSS8Sy3/OTf/g+89Lu+MRbjTEAJMLR9xO9UbSqjiLpx29S6rpom96kHXFP9uNBCmrc9FRqB9stPAECch9y0+PR23DiyOkdmAetHpyriF+Y/SkDpgqRuHrI/c+KVoPfYRbm3HP/5xm9YBsR6Ahpm7g7EmV6/sbgaCKc/JuF0yM
 uSebnwha
 Il4BKIdywpbpq+aCholMcMC6YrZ3JBQxcYJXCM2q19yA3xt3oqEQg/BTLmAOmUjblyxN8lWwvngBLRQEtELrFAqo2dsPbHkTBUtCo2SruRlehqSTrBbytj4LxIHS2D6X4hAZylR/Xbt9hLMNOEneDIar2Ez/xNeB1pon5nZjDiG64pwo+j468D/cmyLZtu98Nn64aWlCw+1qOdtICcAxlnz6yUXR0W2S3ZLZHUpiH1UpNzXHJ4rSkU0MxqJ6ux/WlRIbffRMn+FzfTATguCBYtPxjJ+xxTf2RGku7nm0tc4Z/+/eLOy6TL9Bfsx2tXoidYvhnOIDm8Np2I3MNxk+xbs1Y72HG96vqrwxAWDvcV8Fjw9S7rbvPhfGNatELozDOrV8tVciDRl5umxxKWg4iQA8S7EvxQFC12HuHUSOUUa1tQkn0PgHw1JPbvNoNBdVSYsGInfiYIHXza911mvPdHl0aSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim and refault detection read LRU sizes and workingset counters
from the target lruvec after a ratelimited rstat flush. For global
reclaim and the root memcg, that flush covers every cgroup in the
system, and the ratelimiting can leave the stats stale for seconds.

For stats that only track memory charged to a memcg (LRU sizes,
workingset, rotation and reclaim writeback counts), the root memcg's
hierarchical value equals the node counter, which is always up to date.
Add lruvec_lru_page_state() and a monotonic variant that read the node
counters for the root memcg, and use them in reclaim and
workingset_test_recent(). Root reclaim and refault detection then see
current values instead of stats that can lag by seconds.

workingset_test_recent() only reads the eviction memcg's own lruvec, so
skip its rstat flush when that is the root memcg. For reclaim however,
we still need to keep the flush (for now) since global and root reclaim
also read the rstat stats of the child memcgs they scan, which the flush
is needed for in order to keep up to date.

On an 80-CPU machine, a root flush took 69us on average with little
cgroup activity and ~0.9ms with 128 memcgs actively allocating (wall
time, including waiting for the rstat lock). Reading a node counter
doesn't add any cost. It took the same amount of time as reading the
rstat counter (~150ns, which includes bpftrace probe overhead).

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/memcontrol.h | 16 ++++++++++++++
 mm/memcontrol.c            | 44 ++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c                | 36 +++++++++++++++----------------
 mm/workingset.c            | 19 +++++++++-------
 4 files changed, 89 insertions(+), 26 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..656bd677dd3c 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -968,6 +968,10 @@ unsigned long lruvec_page_state_monotonic(const struct lruvec *lruvec,
 					  enum node_stat_item idx);
 unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 				      enum node_stat_item idx);
+unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
+				    enum node_stat_item idx);
+unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lruvec,
+					      enum node_stat_item idx);
 
 void mod_memcg_lruvec_state(struct lruvec *lruvec,
 			    enum node_stat_item idx, int val);
@@ -1430,6 +1434,18 @@ static inline unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return node_page_state(lruvec_pgdat(lruvec), idx);
 }
 
+static inline unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
+						  enum node_stat_item idx)
+{
+	return node_page_state(lruvec_pgdat(lruvec), idx);
+}
+
+static inline unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lruvec,
+							    enum node_stat_item idx)
+{
+	return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+}
+
 static inline void mod_memcg_lruvec_state(struct lruvec *lruvec,
 					  enum node_stat_item idx, int val)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ac6c43ea8c5a..938843346571 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -587,6 +587,50 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return x;
 }
 
+static bool lruvec_is_root(const struct lruvec *lruvec)
+{
+	return !mem_cgroup_disabled() && mem_cgroup_is_root(lruvec_memcg(lruvec));
+}
+
+/**
+ * lruvec_lru_page_state - read an LRU stat of an lruvec
+ * @lruvec: the LRU vector to read from
+ * @idx: the node_stat_item to read
+ *
+ * Like lruvec_page_state(), but for the root memcg the node counter is read
+ * instead. For stats that only track memory charged to a memcg (LRU sizes,
+ * workingset, rotation and reclaim writeback counts), the root memcg's
+ * hierarchical value equals the node counter. The root memcg can just read the
+ * node counter directly instead of going through rstat, which requires
+ * flushing. Flushing the root memcg flushes every cgroup in the system.
+ *
+ * Use lruvec_page_state() for other stats (eg slab).
+ */
+unsigned long lruvec_lru_page_state(const struct lruvec *lruvec,
+				    enum node_stat_item idx)
+{
+	if (lruvec_is_root(lruvec))
+		return node_page_state(lruvec_pgdat(lruvec), idx);
+
+	return lruvec_page_state(lruvec, idx);
+}
+
+/**
+ * lruvec_lru_page_state_monotonic - lruvec_lru_page_state() for delta sampling
+ * @lruvec: the LRU vector to read from
+ * @idx: the node_stat_item to read
+ *
+ * See lruvec_page_state_monotonic() and lruvec_lru_page_state().
+ */
+unsigned long lruvec_lru_page_state_monotonic(const struct lruvec *lruvec,
+					      enum node_stat_item idx)
+{
+	if (lruvec_is_root(lruvec))
+		return node_page_state_monotonic(lruvec_pgdat(lruvec), idx);
+
+	return lruvec_page_state_monotonic(lruvec, idx);
+}
+
 static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7ddef3b488b3..fc93a1d8afe0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2379,8 +2379,8 @@ static bool inactive_is_low(struct lruvec *lruvec, enum lru_list inactive_lru)
 	unsigned long inactive_ratio;
 	unsigned long gb;
 
-	inactive = lruvec_page_state(lruvec, NR_LRU_BASE + inactive_lru);
-	active = lruvec_page_state(lruvec, NR_LRU_BASE + active_lru);
+	inactive = lruvec_lru_page_state(lruvec, NR_LRU_BASE + inactive_lru);
+	active = lruvec_lru_page_state(lruvec, NR_LRU_BASE + active_lru);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -2428,7 +2428,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	 * into a decaying average. This ensures currency, as workloads
 	 * change over time, and avoids overflow in the calculations.
 	 *
-	 * Use lruvec_page_state_monotonic() so unsigned subtraction
+	 * Use lruvec_lru_page_state_monotonic() so unsigned subtraction
 	 * yields the correct delta across a signed-long wraparound of
 	 * the underlying counter (a real hazard on 32-bit that the
 	 * clamp in lruvec_page_state() would otherwise turn into a huge
@@ -2440,13 +2440,13 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 		struct lru_cost *cost = &target_lruvec->cost[f];
 		unsigned long rotated, io, nr_rotated, nr_io;
 
-		rotated = lruvec_page_state_monotonic(target_lruvec,
-						      PGROTATE_ANON + f);
-		io = lruvec_page_state_monotonic(target_lruvec,
-						 WORKINGSET_RESTORE_BASE + f);
+		rotated = lruvec_lru_page_state_monotonic(target_lruvec,
+							  PGROTATE_ANON + f);
+		io = lruvec_lru_page_state_monotonic(target_lruvec,
+						     WORKINGSET_RESTORE_BASE + f);
 		if (f == WORKINGSET_ANON)
-			io += lruvec_page_state_monotonic(target_lruvec,
-							  NR_VMSCAN_WRITE);
+			io += lruvec_lru_page_state_monotonic(target_lruvec,
+							      NR_VMSCAN_WRITE);
 
 		nr_rotated = rotated - cost->last_rotated;
 		nr_io = io - cost->last_io;
@@ -2468,10 +2468,10 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	anon_cost = &target_lruvec->cost[WORKINGSET_ANON];
 	file_cost = &target_lruvec->cost[WORKINGSET_FILE];
 
-	lrusize = lruvec_page_state(target_lruvec, NR_INACTIVE_ANON) +
-		  lruvec_page_state(target_lruvec, NR_ACTIVE_ANON) +
-		  lruvec_page_state(target_lruvec, NR_INACTIVE_FILE) +
-		  lruvec_page_state(target_lruvec, NR_ACTIVE_FILE);
+	lrusize = lruvec_lru_page_state(target_lruvec, NR_INACTIVE_ANON) +
+		  lruvec_lru_page_state(target_lruvec, NR_ACTIVE_ANON) +
+		  lruvec_lru_page_state(target_lruvec, NR_INACTIVE_FILE) +
+		  lruvec_lru_page_state(target_lruvec, NR_ACTIVE_FILE);
 
 	while (anon_cost->count + file_cost->count > lrusize / 4) {
 		anon_cost->count /= 2;
@@ -2495,7 +2495,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 		 * workingset is being established. Deactivate to get
 		 * rid of any stale active pages quickly.
 		 */
-		refaults = lruvec_page_state(target_lruvec,
+		refaults = lruvec_lru_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_ANON);
 		if (refaults != target_lruvec->refaults[WORKINGSET_ANON] ||
 			inactive_is_low(target_lruvec, LRU_INACTIVE_ANON))
@@ -2503,7 +2503,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 		else
 			sc->may_deactivate &= ~DEACTIVATE_ANON;
 
-		refaults = lruvec_page_state(target_lruvec,
+		refaults = lruvec_lru_page_state(target_lruvec,
 				WORKINGSET_ACTIVATE_FILE);
 		if (refaults != target_lruvec->refaults[WORKINGSET_FILE] ||
 		    inactive_is_low(target_lruvec, LRU_INACTIVE_FILE))
@@ -2518,7 +2518,7 @@ static void prepare_scan_control(pg_data_t *pgdat, struct scan_control *sc)
 	 * thrashing, try to reclaim those first before touching
 	 * anonymous pages.
 	 */
-	file = lruvec_page_state(target_lruvec, NR_INACTIVE_FILE);
+	file = lruvec_lru_page_state(target_lruvec, NR_INACTIVE_FILE);
 	if (file >> sc->priority && !(sc->may_deactivate & DEACTIVATE_FILE) &&
 	    !sc->no_cache_trim_mode)
 		sc->cache_trim_mode = 1;
@@ -6701,9 +6701,9 @@ static void snapshot_refaults(struct mem_cgroup *target_memcg, pg_data_t *pgdat)
 		return;
 
 	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
-	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_ANON);
+	refaults = lruvec_lru_page_state(target_lruvec, WORKINGSET_ACTIVATE_ANON);
 	target_lruvec->refaults[WORKINGSET_ANON] = refaults;
-	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE_FILE);
+	refaults = lruvec_lru_page_state(target_lruvec, WORKINGSET_ACTIVATE_FILE);
 	target_lruvec->refaults[WORKINGSET_FILE] = refaults;
 }
 
diff --git a/mm/workingset.c b/mm/workingset.c
index 1504f91cdca5..e8620ae1c516 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -483,10 +483,13 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * section (for e.g, in cachestat) - these callers need to skip flushing
 	 * stats (via the flush argument).
 	 *
+	 * For the root memcg, the LRU sizes are read directly from the node
+	 * counters (see lruvec_lru_page_state()).
+	 *
 	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
 	 * still needed here?
 	 */
-	if (flush)
+	if (flush && !mem_cgroup_is_root(eviction_memcg))
 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
@@ -518,17 +521,17 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * workingset competition needs to consider anon or not depends
 	 * on having free swap space.
 	 */
-	workingset_size = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
+	workingset_size = lruvec_lru_page_state(eviction_lruvec, NR_ACTIVE_FILE);
 	if (!file) {
-		workingset_size += lruvec_page_state(eviction_lruvec,
-						     NR_INACTIVE_FILE);
+		workingset_size += lruvec_lru_page_state(eviction_lruvec,
+							 NR_INACTIVE_FILE);
 	}
 	if (mem_cgroup_get_nr_swap_pages(eviction_memcg) > 0) {
-		workingset_size += lruvec_page_state(eviction_lruvec,
-						     NR_ACTIVE_ANON);
+		workingset_size += lruvec_lru_page_state(eviction_lruvec,
+							 NR_ACTIVE_ANON);
 		if (file) {
-			workingset_size += lruvec_page_state(eviction_lruvec,
-						     NR_INACTIVE_ANON);
+			workingset_size += lruvec_lru_page_state(eviction_lruvec,
+								 NR_INACTIVE_ANON);
 		}
 	}
 
-- 
2.52.0



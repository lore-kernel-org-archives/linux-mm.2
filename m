Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC99606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 20:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MCUaebPl
Received: by kanga.kvack.org (Postfix)
	id 0694A6B05B3; Mon, 26 Oct 2026 16:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E1A6B05B4; Mon, 26 Oct 2026 16:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAFB96B05B5; Mon, 26 Oct 2026 16:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD00E6B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:23:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40E0A1A0253
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:23:51 +0000 (UTC)
X-FDA: 85365903462.20.0B52FDE
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6F79E40008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:23:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MCUaebPl;
	spf=pass (imf12.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793046229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=faymWgnFdRC1Ks69YF78/tFXx05sYwA9Q3xwmQUKoUw=;
	b=fpxTEsGTbEntaD4Z9hi5e56T4aimdeZz7NnOMV4pqLOcFSy/4OWqtERc4JshF3BtBvO8ip
	abMD9D/S1dI02cNfoFRW+dV8tpt1clW+dzWpKVyUCSHDyuefs9AaVN+/c7Au8sii9yHneF
	elJET2C348jSMUQBbaeUgY7CYxPYzqU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MCUaebPl;
	spf=pass (imf12.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793046229;
	b=KNDV9FL/KGGLszRpUxNpQL8F9apYgE8H/XXACqmjeaEg/hj4+xlvno6es++Ei7/3sNlfFi
	BCjMKmsYhdhPZxo8K+sSRqpdDOYkA6TEVLF7+JGGpfXdqnrZZeHY64mWD1bvaYBNDHl/L/
	amhaoDIl0hirm1R55c3M+nBEgQ90e44=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-886e61fa30fso1398522b3a.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793046228; x=1793651028; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=faymWgnFdRC1Ks69YF78/tFXx05sYwA9Q3xwmQUKoUw=;
        b=MCUaebPlaOTgzV6qUJTJDVgtPvER/wIOIzwreKARGoHToJKC0ODJENAvJYpCS2GWez
         zuJF7zv8Pk8w6bbpww0s3dmF4ujwm+IBh4CQn19xDu3AhNb69b2l4NiZOG/r0PN6nizC
         0IekunZPn5qrLHo+EEdp4hH6W3HVqksGos7quo98CbB5hFuL8x3GqhGZ49r9mlI9t1O9
         lFJzQ5BHiwBGCNyGNQT0sY5+cM4vMnnuXXUB6JKvqwHiF6vRqYId/l16zZu7LmSB2OpZ
         hRQ65gAvu41wZSenqM3InKB3rr89TMOzAZA7TYlH/UvQEeVY22FK4DMuQ+EkwzDws7Zd
         bnNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793046228; x=1793651028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=faymWgnFdRC1Ks69YF78/tFXx05sYwA9Q3xwmQUKoUw=;
        b=NWc24PFSbXOtQ8srTvqEB4OfQOn4KVRLV9FRGEgOgCz2ctLLy3dnmoXDHu6QbiX+Ah
         K+9w0ZmhfuV3DBTPnIsVTk7qcER6wwkJEB+7kqQ8ylaB/47XtdkpQV3kYgL0O5/oEdls
         zNv+HwXC6ofGggmk65Vd6Mxmwwc7hK2q7/MFi8EZgFIbYkkTfycqOlBET8jfsNER+cWh
         50iLRdGgKRuIMtCS2Zv6UxhjWGVOpKteZ50yZMWtzMGXXFdkpJoJaOZ3bx/2tCZxdxHH
         f2smg49/kexil3tpAdrGHoE0UUnWhgLBj0plAWM/t1D+b58n93eXzncBwyoGQd6EcbKw
         kRWg==
X-Forwarded-Encrypted: i=1; AKwUvBy0Hthxg4TH02PUxsnTiYkg290wV6rb3VyF2BGP48gArM3vxNnfa+NkPRacVxV60UHjf5pVhPD+zQ==@kvack.org
X-Gm-Message-State: AFq9FYLpLX6tqsC1WSvJMlC4Diuq3iiv0U/4wvpHEjg0um+K7Y/7DYf4
	gRinOHCiG9XzuLDikopvBYiXcFqMnaOGo5dCA9nG5EQ6mLz3m1leiw2J
X-Gm-Gg: AYBFou3R/3KiLTZ0HBFuZrosaG1RbTtDQK5D3tWY6xzMUOfPBlpN1osQVIN9is8FVtP
	+ePGy7kVAcxOdJY3gaFPrw5VjO6hIbHiDBwdI4ocmIMeH1xWKjc3GvWgSahxiMTPsO/7LAkNpcg
	thrl1gk2WkeNPkvw+5PthGTO1LoZRghfwlZ1b7BqRASoSmVTARkZM4YMP4GJv4l2b7g5uuhSvQv
	SWfsyXns1EoGjVnJ+Sbx3h3jOq/pd88xUdSKjUC4LHZOo/8DG2yUSN3eQu3naIkvLVu6VKY/qOY
	rsFyxbNR+3o7fiPBRWc8ecjJIFqf09sfyC+YonHZ+IWWCCvBwdH73MOcIsDH9NySYqR8pawWylb
	gLIUqcvkHKTLOOctx1QfXwUm90aIMPpJOtB4fImBMYBwNmLyNwL95zS0QHT560LvV4xyRWQnpwp
	BlHUMkV1ovNHVp39/7I8N72QSKTTkVImPGuCl78Uy04XKhpmXVyDib2Exen1HajdNPf1er93xjZ
	4yqksSCL3YocjZ+J09WuiDVZJ+YLHZA08okTfutuyU+Z9eEIBLQkkwAjw8lJxovxlsnjUksH/mU
	hOkHD3XCQZlWbDNWfPZUGzrmWy3/0tZz7XuNupySz/NEZOMH340ZVYyQ+J/6eIZnqu9ImhOFUqf
	4Q36RkGDN+zN8SGMcIrpurSFy4Q3HS90AvuqH8mFLKmUoMMHuKFLvpwDaSuDZnv2QUtE=
X-Received: by 2002:a05:6a00:12d9:b0:8a0:6860:cb16 with SMTP id d2e1a72fcca58-8a364e52e50mr5448635b3a.8.1793046228194;
        Mon, 26 Oct 2026 13:23:48 -0700 (PDT)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36bb29546sm1627846b3a.33.2026.10.26.13.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 13:23:47 -0700 (PDT)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	apais@microsoft.com,
	rlmenge@gmail.com,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: [PATCH v2 2/2] mm: multi-gen LRU: remove get_lruvec()
Date: Mon, 26 Oct 2026 20:23:13 +0000
Message-ID: <20261026202313.63122-3-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261026202313.63122-1-sidchintamaneni@gmail.com>
References: <20261026202313.63122-1-sidchintamaneni@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F79E40008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8zwqrqptx54bd8on3tnbjrek1d7kiiqg
X-HE-Tag: 1793046229-498579
X-HE-Meta: U2FsdGVkX18th6Qmmy9f1Q8qPZ6+q9ZC7lze2zMfkXYGY/S2f/lbbS4dy0AiH7jUZafd+EJGJUYgTY9nDf8oEHjcgDLCk7OveYOx/fJxTHz86SvStzKZFSLwcju2rG5JHwkKajYr+e5lY07d70lkqrwaBVRU2kuGMI2wtZWelEsiyflzkV2I6JeY/MIJD9pONrfENr3hPoztnTM0pFPRhKRJfhb9qszh4t7VCgRS8UfqJ0WKF1U3ZQOYri5mkD8oPdVAkodqtQfijoYOgyp/ZkVFJc5BdY0VUzcYBtvtcnFJwvVRMhX9wPX2QwRKuvj+jTgQze22zap31YuTgQCfvyss9eEaxnzsjP0HNPrw7ae5+pQPeW9ZkTUcT03pebbww9b0OBoXQK1me1HzKWofPPJAMXHS82yFPwHLkvZ9obUlr/ScP4KwF+vR2hk3bF92+lcMicBIm3VIZsSEQwEijcjCjWmYI6VWtJ5sJOXHatFAEc7Fa/erFxFVfVCKUjkqZY+U3rjynu838xPTPXbdzyOxpCmYe7m8w+4UPJxp2wZJ5fAh2uq8Bm+Oqvcp3elwW16+3QdB0M0OlmhvOXQjX+hnl96+R6hNfw1YNNDzmn+IQGBgRJhwlOL3o0/eaQt0qUDs1+/+z/TySNDHBvbFIuNNQioQoGr3J+EJD+6I+QJ12QeA29GUW8ztZqMwSbsKNCYKpZ8OvO5/caKwu1r6QLyBnlJvpAuJgY36zfsZp6tZv4Vo1enBrrlStbaf4r7F2AKsK1JRsFwLSNMme9qGv96OswZVwjTwYS1BLnkXtDH/Y4zTGc8FSxhwk4E+pp1qxZ8kjfHUfJhMTCDHbqZmz3g5IP6hOxjIOfPL0JearyUJ/NodPXLsF08PKvOHQ/comhEktA7RDOi8YnlEcnUHPVeqz/z6M8C0DUUUlmHrEV6Yt8pCFw1Vbn+RP42ISCM2AmTstkVjywmd19Auyza
 PY8jvOJ5
 9ib5Q9cdKhGfLSwjiEgPoCwwxLM1YQFxjgCVylmq4DjPPYIGvQbbQLYnEoSduDcVvRT/WXJsyiTXeZ3DR4O5qWUCH4CCp3sHSsY06BKNL7Ps4Cz5stsP3IX3FEGD6wxRhEWZ9N+f7AtdR5JaijeCse9O+PbSLdgzYXBAZ8lhwc3+gqY9u16hCPzDpmLUz5cBkaXuB03HIKKqD/gI2ql5lRVw4vk0KYAn2ZDWiWz1Csuy+ukE7e94ulvEY9OXzUE/Ty1Augt8DC2O7+lTgnM9y152qct2qfHiEpvOHSeJoD8xQyj7jVHeTpzcOm3sfklg2ZUbRJ0WEuveXUQ4OZcuigxn6GwxSJZT9w/p1FuuAcxzufpIcIS4ehyqmOund2ic90Guu39BiWExz+yq3aJ3Pn6ZfNi4eGRZlYDaK2Pp0wpwPyVCeLCS9LF6lYP1AZBgkHStKOXdSMZOWg548gwoToZD8zolRLzjn76J7XkrkSicm7/XSPNNhgMjTy44OjnwUR7uBY9IjyG3bpyX1X4z+ewX/cA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

get_lruvec() was originally introduced in commit ec1c86b25f4b ("mm:
multi-gen LRU: groundwork") to guard against NULL NODE_DATA(nid) on
uninitialized NUMA nodes (`return pgdat ? &pgdat->__lruvec : NULL;`).
After commit 09f49dca570a ("mm: handle uninitialized numa nodes
gracefully") and commit 931b6a8b36a2 ("mm: multi-gen LRU: remove NULL
checks on NODE_DATA()"), that NULL check was removed, leaving
get_lruvec() as a thin wrapper around mem_cgroup_lruvec().

Remove get_lruvec() and call mem_cgroup_lruvec() directly at all call
sites.

Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
---
 mm/vmscan.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 99e9f07fa2e1..5767b94fd8e8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2741,15 +2741,6 @@ static bool should_clear_pmd_young(void)
 #define get_memcg_gen(seq)	((seq) % MEMCG_NR_GENS)
 #define get_memcg_bin(bin)	((bin) % MEMCG_NR_BINS)
 
-static struct lruvec *get_lruvec(struct mem_cgroup *memcg, int nid)
-{
-	struct pglist_data *pgdat = NODE_DATA(nid);
-
-	VM_WARN_ON_ONCE(!memcg && !mem_cgroup_disabled());
-
-	return mem_cgroup_lruvec(memcg, pgdat);
-}
-
 static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -2942,7 +2933,7 @@ void lru_gen_add_mm(struct mm_struct *mm)
 	spin_lock(&mm_list->lock);
 
 	for_each_node_state(nid, N_MEMORY) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 
 		/* the first addition since the last iteration */
@@ -2972,7 +2963,7 @@ void lru_gen_del_mm(struct mm_struct *mm)
 	spin_lock(&mm_list->lock);
 
 	for_each_node(nid) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 
 		/* where the current iteration continues after */
@@ -4424,7 +4415,7 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg)
 
 	for_each_node(nid) {
 		struct pglist_data *pgdat = NODE_DATA(nid);
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 		spin_lock_irq(&pgdat->memcg_lru.lock);
 
@@ -4446,7 +4437,7 @@ void lru_gen_offline_memcg(struct mem_cgroup *memcg)
 	int nid;
 
 	for_each_node(nid) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 
 		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_OLD);
 	}
@@ -4459,7 +4450,7 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
 
 	for_each_node(nid) {
 		struct pglist_data *pgdat = NODE_DATA(nid);
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 		spin_lock_irq(&pgdat->memcg_lru.lock);
 
@@ -4480,7 +4471,7 @@ void lru_gen_release_memcg(struct mem_cgroup *memcg)
 
 void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 {
-	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 
 	/* see the comment on MEMCG_NR_GENS */
 	if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_HEAD)
@@ -4489,7 +4480,7 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 
 bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
 {
-	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	int type;
 
 	for (type = 0; type < ANON_AND_FILE; type++) {
@@ -4536,7 +4527,7 @@ static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
  */
 void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
 {
-	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 	int type;
 
 	for (type = 0; type < ANON_AND_FILE; type++) {
@@ -4613,8 +4604,8 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 	struct zone *zone;
 	enum lru_list lru;
 
-	child_lruvec = get_lruvec(memcg, nid);
-	parent_lruvec = get_lruvec(parent, nid);
+	child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+	parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
 
 	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1)
 		for (type = 0; type < ANON_AND_FILE; type++)
@@ -5370,7 +5361,7 @@ static void lru_gen_change_state(bool enabled)
 		int nid;
 
 		for_each_node(nid) {
-			struct lruvec *lruvec = get_lruvec(memcg, nid);
+			struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 
 			lruvec_lock_irq(lruvec);
 
@@ -5501,7 +5492,7 @@ static void *lru_gen_seq_start(struct seq_file *m, loff_t *pos)
 
 		for_each_node_state(nid, N_MEMORY) {
 			if (!nr_to_skip--)
-				return get_lruvec(memcg, nid);
+				return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
 
@@ -5533,7 +5524,7 @@ static void *lru_gen_seq_next(struct seq_file *m, void *v, loff_t *pos)
 		nid = first_memory_node;
 	}
 
-	return get_lruvec(memcg, nid);
+	return mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 }
 
 static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
@@ -5715,7 +5706,7 @@ static int run_cmd(char cmd, u64 memcg_id, int nid, unsigned long seq,
 		goto done;
 
 	sc->target_mem_cgroup = memcg;
-	lruvec = get_lruvec(memcg, nid);
+	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 
 	if (swappiness < MIN_SWAPPINESS)
 		swappiness = get_swappiness(lruvec, sc);
@@ -5899,7 +5890,7 @@ void lru_gen_exit_memcg(struct mem_cgroup *memcg)
 	VM_WARN_ON_ONCE(mm_list && !list_empty(&mm_list->fifo));
 
 	for_each_node(nid) {
-		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
 		struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
 
 		VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
-- 
2.45.4



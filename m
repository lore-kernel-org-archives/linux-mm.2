Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EDD6606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ooMskanu
Received: by kanga.kvack.org (Postfix)
	id AF5FA6B07FA; Wed, 21 Oct 2026 19:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD756B07FC; Wed, 21 Oct 2026 19:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BCBC6B07FD; Wed, 21 Oct 2026 19:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71A4D6B07FA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:56:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C47DA1206AC
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:56:29 +0000 (UTC)
X-FDA: 85348295298.08.BC5AE66
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0F5E2C0004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:56:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ooMskanu;
	spf=pass (imf22.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792626988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9X5fZ/FbtwVEHohDXP7Y9pADWXE7M/FKsbGY4MERs24=;
	b=TgicGAHLs7hKBiLMHz3UK9RxiBl7A/kXT26ey3X+lv+nVcg64kXncTrvlp7h2ccuL8E22o
	WORwh47mY/bcbYdg92aDUQ0pQYfZmoexaUA64x2Sukx1Y04SnHF2WK2H47mPiK2KbVpfym
	ZWWOCljwsa5dWUva47Fs3gOyoENIbTA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ooMskanu;
	spf=pass (imf22.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792626988;
	b=2+HZBd60rqTr1oupmcjZ1rmnMRG6QETFQ8FYDFuG43x059lpx4h+dHVXfu6vVl1SozRg+g
	NPjqT8FUtRoxWfrFDhYTZD1otvgrEFCmIf+224yZ65RJI/AkaQOBaLiIGUOeSyfUeCFUKK
	CgJzZ1D6Qj5dUOM7iBmmRZveYCVagZg=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-89f28c3ac7bso447081b3a.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792626987; x=1793231787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9X5fZ/FbtwVEHohDXP7Y9pADWXE7M/FKsbGY4MERs24=;
        b=ooMskanugfiFxJrt/vHJURUwyKuswqwE1Zpbqome+6uOk2rxpbKhac96zKOptEgwkR
         xIqX673hCYo2vbZCHVUEv9e3gekp4NKRCYuS8yK5fra2Q3js4c8vWib0h7v8JbAcLchC
         oro7LqPP3jMfrfxPfq9tToojlkzkEvfNJuoj8H27/7rRmvOJRxSqDSfcJ5rtrHtx+Z6q
         yjMBPFHLXLNG3JSRFtzXHhF3jsmFl1wm9sEAY9EbO4z2xJ33z9rlRIANz5ZM1hiQRxFa
         yob9PWZmutjyYhcNohvpYARDZQe8INn4L3muHrSm87CkK4I1UpFEemdXoOd/BuHbi8ZG
         wPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792626987; x=1793231787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9X5fZ/FbtwVEHohDXP7Y9pADWXE7M/FKsbGY4MERs24=;
        b=OjKFcpeefdVZXEC5SGokvQZIiCk9nUIj86oDNsOd7DIPP4nUzvEIhF489szEssf+Os
         n+TikMNezlcUKyiNBJC0m9Zy78fF4e6URVod6GUpnh4ess9TuFtonf2wN0+2XhWVyVpS
         E5Rl5lLYyd/nN0MDRkVqLxTiREA53dG3GC61OsZs6el6kSg1T9slGzlmG2Nw5vjCguMT
         nISDS6fFuprgBvmQeZENVdyt+afTj2Y/KpaHg02PRXd3jh/bG1vEN8hD/S2rnlA1JDIw
         m/Ri5xam9bgpXwZJ1CqoEctbQtcfLE/I4LZs600cMOYF/zNAGk47dfEur1NyA3f2QvWs
         Y96w==
X-Forwarded-Encrypted: i=1; AKwUvBw5rESjm2dzJYYp3jTbYwqb57shNjZzzCbVL9J4/BhULtU3TEOrC2S2vZf18demAZuQpOXKTc2F4Q==@kvack.org
X-Gm-Message-State: AFq9FYLGQHskOPVQHxxwmYDPHZgvgodqaLalB/cRk4m5DWj4HgzoJ+9C
	uv61feXj6IOYAeSGC63fB5eoACjnIoUFHpOIcv/JcDrkkCgEK75g//ed
X-Gm-Gg: AYBFou0b6AcS4L50MWj8U29Q8Ico1w5DIveKg73ekcBI6pEg5uEssuMqMCQUTIzAymL
	8MfyUHErY/e53miOhymb+5fknicRy6Ak+y9+ZhJoQJXWJF6x+nMwMd295zWwVbaNdoOHCN0fUmJ
	4iQW/x7BDTnlKo9YJ4pY0CkM5p+r9MDJvxioJqHekJK8zfhjTF1o02dDSHoEub332dZOLVBQO/A
	VvIZsHm2IC2IwyooSAvUg4/Khb7rlZYilGHbDUJHG/5hTVa+EVMallNr2at47l74VcjcoJc7Z1W
	chP5LEQtdTc5mvjcjyXXfcMThsuwNwSh7ARkqpCvvI3tINnx1sU/b1eO0qnbZI5QVSnXFj/e02f
	nyJqmyHSyTIvPqVbQOk78W9DLtlYWNkmcfz5ESOSd6buA88/1Z7KL4cjuJCKuEulM3KIZUHcy2e
	YFoTtxignrfbLMZKyUgur0XpryQ547qokXe+lgSe+S5jgTq+XdfMXK+6vDZPckYoH2zA1RYWEP7
	f1QVgloV5C4wAYmM0ySclK6c7/2nJebaIVdRci0YG0YXSK0RBwRRIpUyx9NokNjCMWVmsFivZW4
	/mDb9yOTQIKsHzYtbY7vRylt4/EP1FhSbiJPEp/pW3541RM2o+/KfY5RKMCEMDMAScvvDC0Kkwt
	fYKTMnMEcIFt3+JGEpKrOv+szdCxxJap8shQCvii8mxpkYngp17zBkihk1HQRf9Nyn+g=
X-Received: by 2002:a05:6a00:4185:b0:89e:9c7e:fd56 with SMTP id d2e1a72fcca58-8a089d1fd3emr2665695b3a.33.1792626987000;
        Wed, 21 Oct 2026 16:56:27 -0700 (PDT)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895fa696sm1366733b3a.45.2026.10.21.16.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 16:56:26 -0700 (PDT)
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
Subject: [PATCH v1 2/2] mm: multi-gen LRU: remove get_lruvec()
Date: Wed, 21 Oct 2026 23:56:06 +0000
Message-ID: <20261021235606.89545-2-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021235606.89545-1-sidchintamaneni@gmail.com>
References: <20261021235606.89545-1-sidchintamaneni@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F5E2C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: sokd6utwx3f1i4ykqqk1893h1c56jm9e
X-HE-Tag: 1792626987-18339
X-HE-Meta: U2FsdGVkX18EZzYLAY85v8ENbOiXORW5b+PQDFa9+kXyEGR8Wr44asHhto7h5Wv0f0CutnKSC2kChCB+CQHmZ9GbnMOua4tFzRa7Fy79e/aJe8nxrUlS8W8updz3IwFIyPX7vM+5x6UqewBvYLgauJNE3bs0AtRFZS9BZ8ZnoDxTAJhsNNfrSWaF/p86gWwDVyL3qyQz6Nq3SFLjLQ1b04Bxa40JtXYVG1LbADu3lEuJ3AmevQJzb7bI31dOrXdNEMvM/vFtEXJslwI6jQ0cS1aT5rYXMPVbBbv+Z7KMbNOVDFi+4e6b9sBFUq2q0glwcce56orqCwdMYIvoR8ZiYxrsorbOciuk15OCfumIBukWY5xp18fwgZYY7qe8kcFyA88u9eHTEw+myCJdjMo4D0CyVvBXCmHKk3q2iALKsKXCJMs7hWBnY3SBuLTzBi4ZWNTpeGl6ZtoqdT6FtGGuPIXsOfvzpNEK0LZUXfOEtxJDBWXpedoCcHxdcWBzfvncrPbBCYZCMenyr6oaWhwxfUEXMih0U+SUGKJZPFxJa24v4ziBL1lQqjkZBVVzjQ3idDROaWnyNWjMyy+r3if7iOwampqipa+DrnTgpgZoXNTQXti9/Q7NuGSOmq+0ITltB0ILuu9PmngypIPT7OFoO9qQqeaq3WrcjiflokU3vJDH/Fkl96RUdtOYAe5XEVfEn0FQKyC7/3JQOaVtwOVQ3ZvFjISMVuXC3IFFsJdnrtXPy1w1VbrHB0KQHM2R+E9E7Bieg4oeIYonCE+c8hOd8OVScDJm2BDYhFDm02E0Pdk3GD0+wS2+PXWwiC0qw5pGP9nsPDF66yaBN5Og0U44bJil9AWwyERSnzzCI6aHuPmwQ45RietStYQDyRgwvSKQaODKx5S/XA4qOHDc3fK4EerA9cavEEOp2Lsm9d4yETFyIzu7xaST8YHnYyw9DxPLscwDNLI1/eTLo9HzxaH
 +HUZQgb0
 7cb6quNygQoCKHSwtzWoGpsnqdjO+by8EFo+9ZruGjRzDynGR2XCQRv0BfQ+in3YcQfRN1YPxopcau+IjRP6V/52a5pG5L3/XtYEpFuZC7fA+/0OieZqogkVQJ9BopUrrBTcZnI7DZQaAS5H1Rzod6xDslWI56OjMkOgXT6JbEtgqkCoeZ/ltGomuYmwK32Fv9O+lFtKE9MYprdzoMsqLB11KQoWuJt9kSLskiQos430LM8f8+NYrD6TxlwN5tC92VF+QuYpgiS89KGTac5eZBjYsdMZYN9N+noMmgRktB+5+hw1VOGZIQoDGqSs00WynvhPuScFkVV+3407BdkYH0rgAG/Duse86wHXRCUbnIyBrsXpS27Abczwqg2UAxMpn3YILSK8fyLX8+HREocVr3/r36Nu/Lih7jdgi5dIeEQx/ZFhDBJY4hzfAjlYxqwtwyJ01a6ZmPbhN3NFnNQXAwgBJrXKiob2GTkyu2JAdn6D/lcBpvDEk/R1oZD6W7UZncy+B
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

Cc: Barry Song <baohua@kernel.org>
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



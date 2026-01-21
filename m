Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EEA0C44523
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:40:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDD936B008A; Wed, 21 Jan 2026 07:40:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA81C6B008C; Wed, 21 Jan 2026 07:40:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8A1D6B0092; Wed, 21 Jan 2026 07:40:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97B1A6B008A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:40:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 32D0087919
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:40:19 +0000 (UTC)
X-FDA: 84355928958.16.47BBCF2
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id 517F340013
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:40:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FXaeL+YP;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768999217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/OqE0ydtm9JkTAiuYuoK4hbHLjWKG5nWVyw4vzq10Y=;
	b=HirQvHutYKzhHXBBJlzPeLBSQI1QLuJHSuEemWbtBCjwaChK2Lh18zlCEPYlSQ5TBg8sO/
	QVwHqKHgHuMkam1J5vMEJcAi1j56KWziMtcEsP4HjPnUk2c/ZfZvAiuAeFv9gqEoFlLlUg
	bwgQXQ3xJbm8YCs5s08D2qqFuRw2+Zs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768999217; a=rsa-sha256;
	cv=none;
	b=T6jSxpHwjXCXAKzXLnfh1QwW6tKb2ycdrdoXs8Ktqvi/ejwL1R+KmbOFToPGnRo0TpanYZ
	T8Gt9vqrXj+9JuUQh/h5iFDFmZ/cukQrHHWO5KBsBQVfnDL6D6xOT/tqXm/w0uyFIAaTVT
	JLphlAZdhBE+3Dy6Kem+XAzLBZykTZY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FXaeL+YP;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768999215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T/OqE0ydtm9JkTAiuYuoK4hbHLjWKG5nWVyw4vzq10Y=;
	b=FXaeL+YPA/JmFJNJXBNvEweyQrlFdOfXe48axrvpijrU//10I6yRcz2r0gEpEw/qP/JWeW
	t8KRG2OxI5b5PhB9BBxnR1zwPG6G2ieHEW46c6c6HTk0bz9Etrn9GRQi4P1dm8p1saIdJu
	YNOBF1YssN94gM/XXAVWojOZGtqtIdI=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] mm/lru_gen: refactor to extract helper functions
Date: Wed, 21 Jan 2026 20:39:47 +0800
Message-ID: <20260121123955.84806-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260121123955.84806-1-jiayuan.chen@linux.dev>
References: <20260121123955.84806-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 517F340013
X-Stat-Signature: 8ee8ziwjyge8xzquadaaeqg88so5cykt
X-HE-Tag: 1768999217-745203
X-HE-Meta: U2FsdGVkX18CF0ZGT4dURigm/dfQzepi8VQbzHNwZcBYMoNRpADzmq6ORoytttxxkI+HjCUtFHwDZuXQ0AeIMv1gSp0Ssuq8JkkTEHbg50MW3I5THQ9MMIMv11UCNJq7mtatTfkfbcH0hoCoEoF/tx2TeheK5g5oA6RsLBIbxb7jqbC8hIOI+DvUK9TNkT99/YqMJ3Nou/IV8cWXVThfgyDX1C1QceCKjJKIiFaQ7LfVCsTGKo1Qs8BB2dfXoirRUzi9pF5ZIG0c7kYyCac7vR2AtUN9b1BNxVvoJodD1wkduDCjgrK44STEA22YHjlB2VKe8V5BNxdfB1HQvHaUc5xyUAkbF0VfhTHeQmobn/XhU11wB6uQiNw3Pe4Jv6JfjpfgD2/sj4p2JfED/Vo23WvIbwvX2+bLvWphskOrWNrqmX3kg1BYV/uWBP5pABXvYPdyC76vLaxmBsVb8eaAfAx658eaXEgHnOMIVpokWvH70TpkBIfD5H46dzq/ruvIo1fJzCL6GpGdQwHw2ZTE1I7mggOf4H4ICi7OlnyqY7MiEv7HKVgOoSO1EQ/w6yqalN9OS3fbjLwUOnYxXgR0HXt595pmgQtOYhbfKyGecwsIAn1v5fMaL1eLHx0C3RxhBVsNfaHxsBYfMYgweRT/JRLdEw6SaGhVCfl+zhjq4XD+En6u2D1n1Ed+vbqgtDPphGwp794FcDaYPrIhX2QS0XT7Y/sx7UYJBe2ASQhpGPVGAzOv9my+r8zX3TGs28OiXZaq0rrMql1LBNTh0UGyyWAfEia0nsWF+QhNX4Tkm7b7eXQKcCn+5onkWmvIslpu0V/QvIS0xm8VkuUFNlWS0gMZYrLLYu2PEJowzy7Of0g8AkPSZxpHFRm19EEQenUmDwGMrnrkyHXMuXkbq6ppxP5p4b2N+gfSL9Z41YNqa17I004pTWkRHl3NAhZlOWXO5Q7Petk6kdxQp73dWFi
 YqprvOPj
 V3khm6GSWkxW2irTEzkRZ6fJWTq233FatqPUQNsXfy4ovER7oBJv4x64BZq/pd22XFCk2MRzzDnl79i0fjCzyPcuEFhfIuG70mPbU4zt/Cg2CWYKtaped7eZUN/3UFSJCABqDBTqfMHtrwDAZraXYDEC03MiAQL5iiUHAG5Iop7n5ElhHk7HZPwYHhTK5PL4/rt1Q1lJJQh4uvsbHpt6ICievWpezuX+B44jDBK56FiILkueSC5xpM9zuYWLTB0XE0HdoYauKv/9MyNbgmss4fCiVB0TP0LsCMDUV8Q2CLSTNPN47j0hsGXkzOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Extract helper functions from debugfs interface for code reuse:

- lru_gen_print_lruvec(): Print generations for a single lruvec,
  extracted from lru_gen_seq_show().

- __run_cmd(): Core command execution logic, extracted from run_cmd().

These helpers will be used by the upcoming memcg interface.
No functional change.

Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/vmscan.c | 82 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 48 insertions(+), 34 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 619691aa4393..8ea5b67daa36 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5397,29 +5397,13 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
 	seq_putc(m, '\n');
 }
 
-/* see Documentation/admin-guide/mm/multigen_lru.rst for details */
-static int lru_gen_seq_show(struct seq_file *m, void *v)
+/* Print generations for a single lruvec - helper for debugfs and memcg */
+static void lru_gen_print_lruvec(struct seq_file *m, struct lruvec *lruvec,
+				 unsigned long max_seq, unsigned long *min_seq,
+				 bool full)
 {
 	unsigned long seq;
-	bool full = debugfs_get_aux_num(m->file);
-	struct lruvec *lruvec = v;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	int nid = lruvec_pgdat(lruvec)->node_id;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
-	DEFINE_MAX_SEQ(lruvec);
-	DEFINE_MIN_SEQ(lruvec);
-
-	if (nid == first_memory_node) {
-		const char *path = memcg ? m->private : "";
-
-#ifdef CONFIG_MEMCG
-		if (memcg)
-			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
-#endif
-		seq_printf(m, "memcg %5hu %s\n", mem_cgroup_id(memcg), path);
-	}
-
-	seq_printf(m, " node %5d\n", nid);
 
 	if (!full)
 		seq = evictable_min_seq(min_seq, MAX_SWAPPINESS / 2);
@@ -5431,7 +5415,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 	for (; seq <= max_seq; seq++) {
 		int type, zone;
 		int gen = lru_gen_from_seq(seq);
-		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
+		unsigned long birth = READ_ONCE(lrugen->timestamps[gen]);
 
 		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
 
@@ -5450,7 +5434,31 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 		if (full)
 			lru_gen_seq_show_full(m, lruvec, max_seq, min_seq, seq);
 	}
+}
+
+/* see Documentation/admin-guide/mm/multigen_lru.rst for details */
+static int lru_gen_seq_show(struct seq_file *m, void *v)
+{
+	bool full = debugfs_get_aux_num(m->file);
+	struct lruvec *lruvec = v;
+	int nid = lruvec_pgdat(lruvec)->node_id;
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	DEFINE_MAX_SEQ(lruvec);
+	DEFINE_MIN_SEQ(lruvec);
+
+	if (nid == first_memory_node) {
+		const char *path = memcg ? m->private : "";
+
+#ifdef CONFIG_MEMCG
+		if (memcg)
+			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
+#endif
+		seq_printf(m, "memcg %5hu %s\n", mem_cgroup_id(memcg), path);
+	}
 
+	seq_printf(m, " node %5d\n", nid);
+
+	lru_gen_print_lruvec(m, lruvec, max_seq, min_seq, full);
 	return 0;
 }
 
@@ -5501,6 +5509,24 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 	return -EINTR;
 }
 
+/* Core command execution - helper for debugfs and memcg */
+static int __run_cmd(char cmd, struct lruvec *lruvec, unsigned long seq,
+		     struct scan_control *sc, int swappiness, unsigned long opt)
+{
+	if (swappiness < MIN_SWAPPINESS)
+		swappiness = get_swappiness(lruvec, sc);
+	else if (swappiness > SWAPPINESS_ANON_ONLY)
+		return -EINVAL;
+
+	switch (cmd) {
+	case '+':
+		return run_aging(lruvec, seq, swappiness, opt);
+	case '-':
+		return run_eviction(lruvec, seq, sc, swappiness, opt);
+	}
+	return -EINVAL;
+}
+
 static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
 		   struct scan_control *sc, int swappiness, unsigned long opt)
 {
@@ -5530,19 +5556,7 @@ static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
 	sc->target_mem_cgroup = memcg;
 	lruvec = get_lruvec(memcg, nid);
 
-	if (swappiness < MIN_SWAPPINESS)
-		swappiness = get_swappiness(lruvec, sc);
-	else if (swappiness > SWAPPINESS_ANON_ONLY)
-		goto done;
-
-	switch (cmd) {
-	case '+':
-		err = run_aging(lruvec, seq, swappiness, opt);
-		break;
-	case '-':
-		err = run_eviction(lruvec, seq, sc, swappiness, opt);
-		break;
-	}
+	err = __run_cmd(cmd, lruvec, seq, sc, swappiness, opt);
 done:
 	mem_cgroup_put(memcg);
 
-- 
2.43.0



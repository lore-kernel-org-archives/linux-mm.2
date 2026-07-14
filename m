Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83926C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39A616B0005; Tue, 14 Jul 2026 08:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377BB6B0088; Tue, 14 Jul 2026 08:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 288AE6B008A; Tue, 14 Jul 2026 08:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E23206B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58AE7A03CE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:15:37 +0000 (UTC)
X-FDA: 84987277914.04.CEDCE4D
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id B15C1C0011
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:15:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf10.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZYc6Pv1xjCvE8AbV03BLquTy+t2F5F206sca1+WE2WU=;
	b=YJvMMG2Dgbib8TJg5mBUvZct4sEtsk8RoAi30b/rTOdqNKhz++zs9ZfYpCktHWk13kSCDX
	jQDRCq7/Xqe+kVYgx5ro3oerlO80Ed2KpvztArMv5vOq678buCz97YWTh2LcN3tGSPrPAJ
	HCiHmHiOS2CXwhGvzSkq7vlNoLmVFd8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf10.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031335;
	b=Z0XF+DlwcIkiaNtjMsSyj1PUjQnYFO9OpI98SDRq0ekKzc1ZbVFgafZL4ZDJJMgExC/nP7
	Ei3rZRXa3hD8N0oUOpzcTGxCLnU4cmpQH7QeEL2WFWmQ38x3rXZ/mISpB5Okn2Wf7bmC2f
	M21kllyf0D+YQxziSeMACevyzjU27N0=
Received: from TW003.hihonor.com (unknown [10.77.199.161])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4gzytp3XY4zYlLgc;
	Tue, 14 Jul 2026 20:15:30 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW003.hihonor.com
 (10.77.199.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Tue, 14 Jul
 2026 20:15:28 +0800
Received: from localhost.localdomain (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 14 Jul
 2026 20:15:19 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: <akpm@linux-foundation.org>, <yuanchu@google.com>
CC: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <baohua@kernel.org>, <axelrasmussen@google.com>,
	<weixugc@google.com>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <roman.gushchin@linux.dev>,
	<muchun.song@linux.dev>, <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<willy@infradead.org>, <denghaojie@honor.com>, <baoquan.he@linux.dev>,
	<kaleshsingh@google.com>, <tjmercier@google.com>, <tao.wangtao@honor.com>,
	<zhangji1@honor.com>, <wangzhen5@honor.com>, Zicheng Wang
	<wangzicheng@honor.com>
Subject: [RFC v2 1/3] mm/lru_gen: add AGING counter and proactive aging helper
Date: Tue, 14 Jul 2026 20:15:27 +0800
Message-ID: <20260714121529.2237261-2-wangzicheng@honor.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260714121529.2237261-1-wangzicheng@honor.com>
References: <20260714121529.2237261-1-wangzicheng@honor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: TW004-1.hihonor.com (10.77.232.85) To TA012-1.hihonor.com
 (10.77.199.132)
X-Rspamd-Queue-Id: B15C1C0011
X-Stat-Signature: ucr5hkomcrwdcwtb6m8ss7b6pjebuaeu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784031334-217627
X-HE-Meta: U2FsdGVkX1/rqUBfB/P09jfmFO/gCSNRUSGxGD3w0LOmu3x/xcKvG3AOfJz8xaC5pwohKO74bQf3zcGKSS/p49YJ0z7w2ojI4hmlswWM/C9wvBnXILmAnO9vz5SEsa5XLvI8S+t7+WgZJ7mKRzV0Nrbr7Wz/Ejg3VcirtIJ//cgSISlKkzXb82VvjEtfYJyMjQgqZU/X87Ids8Vprrt5Gx+tRi48Xnk0/mkBWzUegVQjzIbl9mreqYKK9Vuj3ZFaSulwMl0OYzvLo6FbN3awGOzQkCk9s7SrWplkeeA99wyJwAJz7mTNDYF2wngmuteAhngXNs1KkgOFD+kDtjN6vcQpjSeteng6cUaH1KQCPLDLve9KQTHrjWxUna1MjlhOyKrYDLNhSfTkxaV7h0imm12i9jtoYYMSF8FTaWV4EvjjNRPHpe/ULxLA85fva3li1KgJIYA6pdi0dBEm9+Asw65I6w0PrbIzD/1oC4v+DT5MVYyAVUK5ZwhSMnPPIbb82QE/HxTjm3lrX/FycRDdxZKOPAXCWUpfvcs3U8pj2DSa4s3FR3W5UrdeErHtt+1amTgxiVDhrZg4YxmN+dYIO5cVhhs351OSY+TRUFDa9bIL8fXI2J0P1C12c5GEynr7dUirvYA7cG3/XGwgl7nKL9Cv3zvECYqvVWm2KDvseFrxCX2K+exFQNTPhuGnm02Vu5LhHfiZgxuiZjQP+wEVXIxWvaFklgOQeQOilZ3Qzurlnc1Cpug5rjcktXChiW26feStsvxixydmd5wLToZXqN4qeogkqkRn4DltvaapPz2X4y9HU7H4Oa6VMg67SUB9URG5Wnh7ooMl8qNo3oOofpKDGR9djLCJJHyH9oJcXvoa9x1SJi4rUv2SVSlRJThAngd69x6gdGI3nTWcncWyc+Pt+5oo9a6ntz8hpLKrig/5A9ahe08LlmoRcQTFwiVEnLMQFiwWchigXT+scOT
 eq5gLpi+
 nYYu+ZEQyi7UqlHLcL6qgaGwXWxJkyHLRFT97o7q9teAyCps4Eo1O9nIE7pDzUJPfnWsoWF5rUhxsLFIeqAT6zRKJMdEweCakyI2AsZv7Ahml9agYSQDEk4MuyylcpVVy6LBu4OrXYHFh6Q6094sE5uuEBlz79eoL3Yf4yalVxfZ6um0HLbdX71IVWvBcorEBQ/Uk8j4QmdEoopwDSS5B+xohIZa+bKrpHe9sEKjGTwxI9LQY2sfLhCr2Uwj6PgDy0lHQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the two pieces the rest of the series builds on: an AGING node
stat counter (the observation an aging policy pairs with
workingset_refault to spot over-aging) and a reusable helper,
lru_gen_age_memcg(), that ages a memcg by advancing max_seq without
reclaim (the control primitive memory.aging wraps).

The counter counts every pass in inc_max_seq(), regardless of caller.
The helper mirrors lru_gen_seq_write()'s reclaim_state /
memalloc_noreclaim / mm_walk setup; swappiness comes from
get_swappiness() so anon is not rotated without swap, and a racing
lruvec is skipped (-EAGAIN) without blocking other nodes.

Gated by CONFIG_LRU_GEN.  No user-visible change yet.

Signed-off-by: Zicheng Wang <wangzicheng@honor.com>
---
 include/linux/mmzone.h |  3 ++
 mm/internal.h          |  4 +++
 mm/memcontrol.c        |  9 +++++
 mm/vmscan.c            | 80 ++++++++++++++++++++++++++++++++++++++++++
 mm/vmstat.c            |  3 ++
 5 files changed, 99 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da5..ab5137c272ca 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -323,6 +323,9 @@ enum node_stat_item {
 	PGSCAN_ANON,
 	PGSCAN_FILE,
 	PGREFILL,
+#ifdef CONFIG_LRU_GEN
+	AGING,
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..96add6cd4627 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -634,6 +634,10 @@ extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
 
+#ifdef CONFIG_LRU_GEN
+int lru_gen_age_memcg(struct mem_cgroup *memcg, unsigned long nr_gens);
+#endif
+
 /*
  * in mm/rmap.c:
  */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d978e18b9b2d..e42f97e004b6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -420,6 +420,9 @@ static const unsigned int memcg_node_stat_items[] = {
 	PGSCAN_ANON,
 	PGSCAN_FILE,
 	PGREFILL,
+#ifdef CONFIG_LRU_GEN
+	AGING,
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
@@ -1606,6 +1609,9 @@ static const struct memory_stat memory_stats[] = {
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
+#ifdef CONFIG_LRU_GEN
+	{ "aging",		AGING	},
+#endif
 };
 
 /* The actual unit of the state item, not the same as the output unit */
@@ -1655,6 +1661,9 @@ static int memcg_page_state_output_unit(int item)
 	case PGSCAN_KHUGEPAGED:
 	case PGSCAN_PROACTIVE:
 	case PGREFILL:
+#ifdef CONFIG_LRU_GEN
+	case AGING:
+#endif
 #ifdef CONFIG_NUMA_BALANCING
 	case PGPROMOTE_SUCCESS:
 #endif
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b3e555561417..805e29c499c8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3987,6 +3987,9 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+
+	/* Count every aging pass for over-aging diagnosis. */
+	mod_lruvec_state(lruvec, AGING, 1);
 unlock:
 	lruvec_unlock_irq(lruvec);
 
@@ -5855,6 +5858,83 @@ static int __init init_lru_gen(void)
 };
 late_initcall(init_lru_gen);
 
+/**
+ * lru_gen_age_memcg - Proactively age a memcg by N generations
+ * @memcg: target memcg
+ * @nr_gens: number of generations to age (1..MAX_NR_GENS)
+ *
+ * Advances max_seq without page reclaim on all nodes of @memcg, using
+ * the same lock/walk protocol as lru_gen_seq_write().  Swappiness comes
+ * from get_swappiness() so anon rotation is skipped without swap.
+ * to the next node.
+ *
+ * Return: 0 on success, -EINVAL on bad input, -EAGAIN if a lruvec did
+ * not advance, -ENOMEM on mm_walk failure, -EINTR on signal.
+ */
+int lru_gen_age_memcg(struct mem_cgroup *memcg, unsigned long nr_gens)
+{
+	struct scan_control sc = {
+		.may_writepage = true,
+		.may_unmap = true,
+		.may_swap = true,
+		.reclaim_idx = MAX_NR_ZONES - 1,
+		.gfp_mask = GFP_KERNEL,
+		.proactive = true,
+	};
+	int nid, swappiness;
+	unsigned long i;
+	int ret = 0;
+	unsigned int flags;
+	struct blk_plug plug;
+	struct lruvec *lruvec;
+
+	if (!memcg)
+		return -EINVAL;
+
+	if (nr_gens == 0 || nr_gens > MAX_NR_GENS)
+		return -EINVAL;
+
+	set_task_reclaim_state(current, &sc.reclaim_state);
+	flags = memalloc_noreclaim_save();
+	blk_start_plug(&plug);
+	if (!set_mm_walk(NULL, true)) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	for_each_node_state(nid, N_MEMORY) {
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			goto done;
+		}
+
+		lruvec = get_lruvec(memcg, nid);
+		if (!lruvec)
+			continue;
+
+		swappiness = get_swappiness(lruvec, &sc);
+
+		for (i = 0; i < nr_gens; i++) {
+			DEFINE_MAX_SEQ(lruvec);
+
+			if (!try_to_inc_max_seq(lruvec, max_seq,
+						swappiness, false)) {
+				ret = -EAGAIN;
+				break;
+			}
+		}
+
+		cond_resched();
+	}
+
+done:
+	clear_mm_walk();
+	blk_finish_plug(&plug);
+	memalloc_noreclaim_restore(flags);
+	set_task_reclaim_state(current, NULL);
+	return ret;
+}
+
 #else /* !CONFIG_LRU_GEN */
 
 static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..78ea093428c7 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1290,6 +1290,9 @@ const char * const vmstat_text[] = {
 	[I(PGSCAN_ANON)]			= "pgscan_anon",
 	[I(PGSCAN_FILE)]			= "pgscan_file",
 	[I(PGREFILL)]				= "pgrefill",
+#ifdef CONFIG_LRU_GEN
+	[I(AGING)]			= "aging",
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
-- 
2.25.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CC4CC5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739486B0095; Fri,  7 Aug 2026 05:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E9386B0096; Fri,  7 Aug 2026 05:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8596B0098; Fri,  7 Aug 2026 05:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA526B0095
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:24:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC6DE14029B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:24:44 +0000 (UTC)
X-FDA: 85073938488.29.0C88602
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 128B214000A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:24:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VPfXn6S9;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786094683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOtbSQ2gdBo/G8CsEYhRHsP8d62EaT8RCw0jB8TkVqA=;
	b=tP/c5yYsC1gcitDMgsJzeiYrmLfKZ1ZaQzN+CBu9NldrPOy9In85j5YK4wg+FvyTBEyDSC
	2aq2VX7Q5W0EVHdSQq6nfqj4s9LWjKlPQx4n0aZO0oa6DdQkfe0BYpy7WrznG5gaXwEOWn
	om4WpBs8bpqr1rhOmf3WwmRe5lZAxSE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VPfXn6S9;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786094683;
	b=Jy/Xlf4QXPrmOYreAn7hojKh137WwDPBzxPh5ksSVryf/L92yXHdUVNKIig57tLSdwS4L1
	aRIePKfSyOO+tcG3aleK1anW9aI2QBHFg9lq+VocElAx/7YKCj4aQptAOApiN44wh7ZcX8
	Yl1Tb0aaWY7A+4NQcduG5ECpekPuMN4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786094681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOtbSQ2gdBo/G8CsEYhRHsP8d62EaT8RCw0jB8TkVqA=;
	b=VPfXn6S9MFW3veMYVBqKVrOrEAFQIh8XB7hEn4LTdi3KFoSD5+7t3zfRZyvUAiV9T9pQ3I
	h09UJJxmZ0HD1QZ48K/YPGHUILe74UmTvMmf/Szr2QnrfC9UvE98zv7SgZefiLH/CuSl9q
	cdersJZjpD8z/qTx1XmMyGRpjHLxTLE=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH 3/4] mm/mglru: add debugfs knob to control cross-node empty walk skip threshold
Date: Fri,  7 Aug 2026 17:23:40 +0800
Message-ID: <20260807092343.4123734-3-baoquan.he@linux.dev>
In-Reply-To: <20260807092343.4123734-1-baoquan.he@linux.dev>
References: <anRqew3VikVzxJJb@MiWiFi-R3L-srv>
 <20260807092343.4123734-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 128B214000A
X-Stat-Signature: s3a9zy5pf4ufu6pnhinmuam44bi5r816
X-HE-Tag: 1786094682-373164
X-HE-Meta: U2FsdGVkX1+0PVS4iszZ7NecAmqqcoxpBT4o0Kqx7Pym9yV83YOyA+Xww5BlbLL2y9z49AMWCPPbsOARD+s5HZAu88qwCWRC3FVMD9zlIVP6OJ4hn+hHeAPHOi8SdTtF1jUu8m0pmWi3V15/jMClirEkMjBI/a1PA7Xd05EPNZ9JbU3QLQR0U1nqY5Zd3SBPdwT9vHYZ9y3X1hl+l3Dpqi5ipUSVlMw97bKwNU5jz8JiITmYkmOro0rpW3FFVg/SL5V55z1YdGpYBq66U+x3gVmKHxelCklkYkRfK/iIgjtGnNYn8RLVMrrPWVFb7ktCnnfPMRA4YWgTvdZENCQXO6ZwDbksP5lLaILGmn5Mys47rpsHGt7JTUM6ahAm77a+jf5DyFmlZN318B625okv8n2IUCkr0sUBt5jagoxazBe4iVgM5njOR5Q7gDfQtcUEA8hBqAq1TPCNTvNuShkvjM/R5OKCyRGE2SY5duBd0jRvdKzIfXgwX8kO5N/vKiHpFznlA0dZ+p/CQisg/Sq2oVsLGeqwcBWIMT96rcQSTsUdwuZu+WAz/6m2NNtCrx/XrlrhmiUWvCcGbMagoZnnzZF6mPVLPLYwEDtOWE+brP/WVDST7md7DXd3EyaTsIzksUTnHqka7jVUJJaNk9y8fqfNGKgPTNpJISt0wSPZQZiltbqi3Sh0reHMa6ATXBY/7Exm6ZCu/cm02T1aASQapaJvAX3TpJeiohxD4LllHy0mAqRr8enxSXavNC5+YB53lbygT632uGx98W48POuWMwtxtdOoVae6R2ak1zI4X27JeP9zUxFjcoccdxLbB9tFU/EqN0A/BjjLfArW1s5d4sXbqJC27cbPt+aUkrFUwUHFDgPSM9FLlGG2R1AoPKRwFicQkkRwhslDzG6JyO41vFg6hIKmNHioQ5CeRRC1QxIuddk9cyywca0BjKKdjYoT6IRFY4GVlE2MUYBk+Ha
 04nby4D1
 MLVuQYGkj7jlsCVn27ieC235fwxr+imM6A4kwYwX4M53FqQ+WNkIXZ5W1PSBU/PlaJ7y89gMmMDiU7ielhiANv3pLInCbn/Pw1XQet9rtXVDmkmrNK47gl9uGIOUY3oNHKcJWsKS2X+Fb1FX/t0lCtOF4b1RnID+4DqGYmP/uC53es3VveqjmjHHheeCEu5ZFRK3g4z1nj2JK/S8HoD/2wvhH8W/fAEvy8JRM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the hardcoded MGLRU_EMPTY_SKIP_GENS from a #define to a
runtime-tunable variable (mglru_empty_skip_gens, default 4), and
add a debugfs command to control it:

  echo "skip_empty <N>" > /sys/kernel/debug/lru_gen  (0 = disable, default 4)
  echo "skip_empty" > /sys/kernel/debug/lru_gen      (show current value)

Setting N=0 disables the cross-node empty walk suppression entirely,
allowing easy A/B testing without recompiling the kernel.
Default 4 matches MAX_NR_GENS so the skip window covers at most
one full LRU generation slide.

This is intended as a development/tuning aid for RFC. Whether it
should graduate to a permanent ABI (sysctl) can be decided once
field data demonstrates the optimization is worth keeping.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/vmscan.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c39b392d7b7e..631bcd89b196 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2709,14 +2709,6 @@ static bool should_clear_pmd_young(void)
 	return arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG);
 }
 
-/*
- * Cross-node empty walk suppression. lru_gen_use_mm() marks an mm used on all
- * nodes, so aging on a node where the mm has no memory wastes a full page table
- * walk. Skip such an mm for up to MGLRU_EMPTY_SKIP_GENS generations after an
- * empty walk, then force-rescan to close migration/mlock/NUMA-balancing windows.
- */
-#define MGLRU_EMPTY_SKIP_GENS 4
-
 /******************************************************************************
  *                          shorthand helpers
  ******************************************************************************/
@@ -2927,6 +2919,9 @@ static struct lru_gen_mm_state *get_mm_state(struct lruvec *lruvec)
 	return &lruvec->mm_state;
 }
 
+/* tunable empty-walk skip threshold; defined later, get_next_mm() needs it */
+static unsigned long mglru_empty_skip_gens;
+
 static struct mm_struct *get_next_mm(struct lru_gen_mm_walk *walk)
 {
 	int key;
@@ -2951,7 +2946,7 @@ static struct mm_struct *get_next_mm(struct lru_gen_mm_walk *walk)
 		DEFINE_MAX_SEQ(walk->lruvec);
 		unsigned long empty_seq = READ_ONCE(mm->lru_gen.empty_map_seq);
 
-		if (max_seq < empty_seq + MGLRU_EMPTY_SKIP_GENS)
+		if (max_seq < empty_seq + READ_ONCE(mglru_empty_skip_gens))
 			return NULL;		/* skip: < K gens since empty */
 
 		/* K generations passed → force rescan */
@@ -4273,6 +4268,15 @@ static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc
 /* to protect the working set of the last N jiffies */
 static unsigned long lru_gen_min_ttl __read_mostly;
 
+/*
+ * Cross-node empty-walk skip threshold: skip an mm on node N for up to
+ * @mglru_empty_skip_gens generations after an empty walk, then force-rescan
+ * (closes migration/mlock/NUMA-balancing windows). Default 4 matches
+ * MAX_NR_GENS; 0 disables the suppression. Tunable via:
+ * echo "skip_empty <N>" > /sys/kernel/debug/lru_gen
+ */
+static unsigned long mglru_empty_skip_gens __read_mostly = 4;
+
 static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
@@ -5870,6 +5874,25 @@ static ssize_t lru_gen_seq_write(struct file *file, const char __user *src,
 		if (!*cur)
 			continue;
 
+		/*
+		 * set/show the empty-walk skip threshold: "skip_empty <N>"
+		 */
+		if (!strncmp(cur, "skip_empty", 10)) {
+			cur += 10;
+			cur = skip_spaces(cur);
+			if (*cur) {
+				unsigned long val;
+
+				if (sscanf(cur, "%lu", &val) == 1)
+					WRITE_ONCE(mglru_empty_skip_gens, val);
+			} else {
+				pr_info("MGLRU empty skip threshold: %lu generations (0=disabled)\n",
+					READ_ONCE(mglru_empty_skip_gens));
+			}
+			err = 0;
+			continue;
+		}
+
 		n = sscanf(cur, "%c %llu %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
 			   &seq, &end, swap_string, &end, &opt, &end);
 		if (n < 4 || cur[end]) {
-- 
2.54.0



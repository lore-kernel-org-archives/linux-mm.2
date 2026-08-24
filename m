Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48268C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 07:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AC946B0096; Mon, 24 Aug 2026 03:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5562C6B0099; Mon, 24 Aug 2026 03:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46B866B009B; Mon, 24 Aug 2026 03:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 259E06B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:38:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C3BB1160471
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:43 +0000 (UTC)
X-FDA: 85135360926.27.2CB9BF7
Received: from mta0.migadu.com (out-90.mta0.migadu.com [91.218.175.90])
	by imf12.hostedemail.com (Postfix) with ESMTP id DF97C40002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:38:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787557122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aiVCuCBRK3cltX3s+AhutJ0MI27JpQRF6AMHkZhVR2Q=;
	b=ONn91A9rXbcUoXxjlXuP2zhZFUPtlyLyfDinN1dRCr08W8ScFfWjPb3NzbUdOS/TMKve9o
	D6Ppo4aYA74ahp3yJso5bPeVurCD2s/YRe5waRXI2O1wCYBQA80asqZKjsfxsiT/Z2uybD
	1o6EnS4fqMB/2H8vnsc65gXVsqVtE/E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.90 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787557122;
	b=AmWz5MwvsQQr8DjlvPsI0X1CaGtax+hQK5Mkt+HErDx1qqMR9ETIHEwo44Xj1kOaerIf7c
	P6XE0J7MwVSWG6+Vn6qjmKhxA/c+8nozwcP/hiuL/BmmwPY5onHOTexaYrbJE1EnYXLHS/
	be6KPP/iyTt66H0iIdMnfdUaadb1h8Q=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta10.migadu.com with ESMTPS id 1abddb27e25b8ce6;
	Mon, 24 Aug 2026 07:38:40 +0000
X-Mizu-Trace-ID: 1abddb27e25b8ce6
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	hannes@cmpxchg.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH 3/9] mm/mglru: add debugfs knob for the empty-walk skip threshold
Date: Mon, 24 Aug 2026 15:38:00 +0800
Message-ID: <20260824073806.629593-4-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260824073806.629593-1-hebaoquan@kylinos.cn>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oes79arokbg9a831nummjqe791kb4iuy
X-Rspamd-Queue-Id: DF97C40002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787557121-126426
X-HE-Meta: U2FsdGVkX18fIBzZWyrUKbpueXBUmBwCSpIFnRmo+h72vVsM0CgmLDVLlJtchRwuYC4XQKvMYYpsY/obX8pmv5it2Dz3SiOjFFFp7koy8ZC4OTlxlPbrEuJ/93+JMQI/RO/NcMz6wMt/8f/UgPgrUsDZCV5iVli8fo2H7bPScLydbNlX64NDXbyABMCXFsbmczCdvo+9lb4LrXRopRukbaop7WjcyjLPVPyOg/uPBNmAG94yirqCY1Nr/EvoXNTk0JjB5bxNqrjFI2vZ6KtkOpTCy3T0g5VbXw3IDn5bEJD5Iuj7jwp+ia7Py+zbsdG6R1Mprts63tQDdjybdoqzcIlo2vgMI6YfczLsO8FGHbD0Rsz3Nh212BWmqAkG7xJZKo+Om8SSN1kYVFhqFStjPiChqMgbQHz5eaSAMAMtvcKk4qQdkJTeKaMExD/QcXh/2cie/Yi0IMVu4NCh+A//PzOEgEwgNClse7sM2hnMN6p8Z0Ng3LOTJlaQtJBzLOK9hdA0dm6rWfMB8Vjvir6oUU0e6Ef0ZXwEDngIuDRcs8/3VBZl9s6WnHg5OEXrfptRyzgTi8IIp0NNFteXOBSGboD7bvrcvxQ4S8QTFl9ILBqIHu/b85JsTgDd/ID2LLMGs9y6U9deFepDjbcDDseRFcAlwo7Dk6Z5F49MPl/1m8OiaA4XSw6OvrTtR/5jhvwU5xXTYKkyBA2EGah2LKvU9AEx40jxShB847+KGw1bhWUYBSWVuBl/ii1drxmfTgmLV5XmCpTYVVuvBIERTGrZ4eUA5V1s4FXpEWUDSPnpi1y50jQrCrfNW0n8qrLasTT+MnJHLPeVOi2UbDdWYkVsbLNpyt/sfQ5NGSFESipeeD0vaAbK3XWi3N0j9GT2QOO/IrXpQkwb0NxTJxyXJuxEzSXdVh5pxNUsDwjUHc3lGj6kf3RV91CleDd+VmnhZu4PHrH4q6Pk2iQCp3p10hL
 NwpAwn1j
 FLGwfIFUyMmDhHoMlt60kFXzWD6RDg679j5Czn+mtzjVaHhBNhJoUckibsIs53qXTPaXlBZlSEFhG2KxEO/RhXYTCdQYGHo8dKX9mzAsRC3cOVFc5tN7nPuHIu14RFXCio579Y53m0z51OAkYMYb/u4+ApJ1he2W+sg2jhwJkLhnaV3g7GMtOLlBLuzb4xfD8LmB7cABDDNL5JqR340WCEutUceRWBueNdRZjv/zxstDw38+J294/BcSb/r6YaWx2IBzU6wPplzdy+FGM/CGwuQEYxBxyXYTLeGcgEgGqs5R8RcFlN/pHqHPGbikPhTj9HkA6rHu65L3q/T+xuF36pKgmCaCajpP644jZPTjdwon85ss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change the hardcoded MGLRU_EMPTY_SKIP_GENS to a runtime-tunable
mglru_empty_skip_gens (default 4), set by:

  echo "skip_empty <N>" > /sys/kernel/debug/lru_gen   (0 = disable)

The current value is shown as "empty_skip" in the lru_gen read output.
N=0 disables the empty-walk skip, for easy A/B testing.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/vmscan.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 8 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8ba49683b28..f592f04fe1bd 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2710,14 +2710,6 @@ static bool should_clear_pmd_young(void)
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
@@ -2928,6 +2920,9 @@ static struct lru_gen_mm_state *get_mm_state(struct lruvec *lruvec)
 	return &lruvec->mm_state;
 }
 
+/* tunable empty-walk skip threshold; defined later, get_next_mm() needs it */
+static unsigned long mglru_empty_skip_gens __read_mostly;
+
 static struct mm_struct *get_next_mm(struct lru_gen_mm_walk *walk)
 {
 	int key;
@@ -4266,6 +4261,14 @@ static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc
 /* to protect the working set of the last N jiffies */
 static unsigned long lru_gen_min_ttl __read_mostly;
 
+/*
+ * Skip an mm on node N between re-scan passes: every
+ * @mglru_empty_skip_gens-th aging pass the node re-scans all empty-marked
+ * mms and re-marks them if still empty. Default 4, 0 disables. Tunable via:
+ * echo "skip_empty <N>" > /sys/kernel/debug/lru_gen
+ */
+static unsigned long mglru_empty_skip_gens __read_mostly = 4;
+
 static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
@@ -5676,6 +5679,7 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
 			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
 #endif
 		seq_printf(m, "memcg %llu %s\n", mem_cgroup_id(memcg), path);
+		seq_printf(m, "empty_skip %lu\n", READ_ONCE(mglru_empty_skip_gens));
 	}
 
 	seq_printf(m, " node %5d\n", nid);
@@ -5854,6 +5858,35 @@ static ssize_t lru_gen_seq_write(struct file *file, const char __user *src,
 		if (!*cur)
 			continue;
 
+		/*
+		 * set the empty-walk skip threshold: "skip_empty <N>"
+		 * (the current value is readable via /sys/kernel/debug/lru_gen)
+		 */
+		if (!strncmp(cur, "skip_empty", 10)) {
+			unsigned long val;
+
+			cur += 10;
+			/* require a space before the value: reject "skip_empty123" */
+			if (*cur && !isspace(*cur)) {
+				err = -EINVAL;
+				break;
+			}
+			cur = skip_spaces(cur);
+			if (!*cur) {
+				/* no value: read the threshold via lru_gen */
+				err = -EINVAL;
+				break;
+			}
+			/* kstrtoul() rejects negatives and trailing garbage */
+			if (kstrtoul(cur, 10, &val)) {
+				err = -EINVAL;
+				break;
+			}
+			WRITE_ONCE(mglru_empty_skip_gens, val);
+			err = 0;
+			continue;
+		}
+
 		n = sscanf(cur, "%c %llu %u %lu %n %4s %n %lu %n", &cmd, &memcg_id, &nid,
 			   &seq, &end, swap_string, &end, &opt, &end);
 		if (n < 4 || cur[end]) {
-- 
2.54.0



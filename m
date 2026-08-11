Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D51CEC5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B02D6B007B; Tue, 11 Aug 2026 02:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788266B008A; Tue, 11 Aug 2026 02:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677916B008C; Tue, 11 Aug 2026 02:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 332AF6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:29:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD5C8160382
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:29:38 +0000 (UTC)
X-FDA: 85088012436.18.4082AA2
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id CF0D820007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:29:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LHxK/3HA";
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786429777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=R6sXLJ408Hq3tRWSiXtOW1nD74Q8MEhg+Qm9JG2wrBE=;
	b=bpIvKFwn1a/3m4fFK5O9G3G2LcY5tKyT4izKaqFNGBUM/CvIBOdKiUi756hCCjW5iu+dJS
	wJeAao5yH1jPTDLerJTXNYm+qgEMwQtEEMrrBdJI2NORGaTVRA3Oiw2B+yJXMEyzKBYHrn
	6UHGP476jduDqKrbgSoLWnj9aoFy11c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786429777;
	b=QhIn4fNchhhjPdKcYzTQkjNiVolWiuC8hoo1Q0D3hcns3pNoQKHZ/aVFdRffAGpwcdKlOc
	rgv9C4hkIFADNyG60SDrkRGOJCGOHrQYnKipn6kaTOfiHRSkGLcKkJISkkUb0YEKkDveRN
	EEkSTeKfOQL5VSmRmFqMyLfOcdg1VJk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LHxK/3HA";
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786429775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R6sXLJ408Hq3tRWSiXtOW1nD74Q8MEhg+Qm9JG2wrBE=;
	b=LHxK/3HA2QpmJIWoB4G/6rKq6hy3AXO58UHBA1q4/KQF/FV7NcxX8WfOaErYfb02Mwst9r
	V9OZfxllvcNvpdLqBhWlmzhmTNVmcgT4X4seSxCjm5mDKgAnumwGzd//3zIyskfhnUvBA6
	GiYgGuNpqoxkb8+UTg3vzEmBbxE9TmY=
From: Ye Liu <ye.liu@linux.dev>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm/oom_kill: dump top 5 memory consumers by RSS in OOM report
Date: Tue, 11 Aug 2026 14:29:24 +0800
Message-Id: <20260811062924.4123014-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF0D820007
X-Stat-Signature: 3psotoyymbeic95kefddhybdmm71u44b
X-Rspam-User: 
X-HE-Tag: 1786429776-147531
X-HE-Meta: U2FsdGVkX18lxE04glDkNsT0eA9TkljrZ/Pskzo4hDElN1h2h6M14lON4jos8GgQOlcEEfLDVA0+OLTD4O4Qf7XCdWPyk7wxoAu7kCtfRl/Uwx7clvXSz1XdGlS+H7LEE7t6jpMlIztlhRQLzEdwxv700OSG2RpUtruhMh+Tn8CfoGB903RWsUVllxAbPs1qUP97TBrCH5wZPQDtjE7bTDlbOe4DANsXJx2Y3azjVvkwr53qK6y1ygY1PVTVAJSEpm2fR2Ejrbpe6+qQGNb6uJt9WsGa3UUYoLV2hE7jlpBhjM6Rbp0IyhLqu3aKFAImGjjPDRUCuPgTGwfQ+avDfCXoQxUmKBxXxAq9InT6A+glpfk0U8BTHX/6jalOM+vU9zsm8bKBslPZ7HSw+27+k3qyf4fI0TFOrpVeAiN2zo1cOUlkFh2PEa9r99bFCk48uCjg/G5mze9vAEAzd9XlYwbJoQIaUtcYQ+TPjvkuGy87wWNKJ3IMBMR65/1qWQYLj8+h8ufrhfjarUuDB4dOjM4uFchspoR+z/jkq4aZovh7pPcrLcvCKbl4oMZ0pGaCpdBKKhEuiwG2TLB0tamSPbFlmDA4hI8A4U6pl5uvC82sCNzxzr2zhI0n5K2QlF/kHtLtsnUEjtdH+EUkx5SXGatMhUaKGd9LyTAIZggvIvuk9R3vJCGR51WqKpgQ1GYSmbtWT/dLX0/2X1657dOXkf5Mq+J5n8ONNs2duZMC0kxZoHZ2Dg9CSwsmgY/ruKgQm3d6IFFp+njGEl693EKzD/4I3TtGCYYcHdy8hSlzVMc9Lp03Prpa5oTbhttIjEF+/O7KDUhq2YFqRMBT/G11TQ+eDT4cFlkce79hdEXA6KLTmkHcMmfrjP5HOlL0Yidvy4bqFvgs5so0pDhOp59I9xUiFIi7CQDUCkqphMlKfh1LIrSIgVllfzQK/jtksSTcXDE7Wu4DxorsnHRKGnT
 OIiqdL1x
 UUhXx5TiYolN3r8jOu5FiQ8IOC/pCnckR+HNB8XfSJLxnvo1QF8jDUpBkeqeyV4kNWNHSPXG3y40UsxzlVj50PQp6IDKOW9Qlqy3oT3Lqu7Bm2iuDk5ufTt8zL4tfI/bnsTDJiP8ecLulfKVU7wtE7WJUWxrVEpfkEYrdYx92kKR7msyPfn7NvzH2pjQCOJCyOA8RlaHW1yiLDJNrIV+w5UoFclzdCErcXJ2Ygq2d9eoU0YcWjbsy0sdfnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

When the OOM killer triggers, dump_tasks() prints every task's memory
state but in no particular order.  On systems with hundreds of
processes, identifying the heaviest memory consumers requires manual
log post-processing.

Add a top-5 RSS summary at the end of the task dump so operators can
immediately see which processes are consuming the most physical memory
without additional tooling.  The full task list remains unchanged for
backwards compatibility.

The collection reuses the existing dump_task() traversal with zero
additional locking; RSS is read under the same task_lock that
dump_task() already acquires.  The insertion sort over a 5-element
array is O(1) per task and negligible compared to pr_info() overhead.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---

test:
	stress --cpu 8 --io 4 --vm 2 --vm-bytes 100G
dmesg:
[root@kylinos ~]# dmesg |grep -A 6 "Top 5 memory consumers by RSS"
[   51.670309] Top 5 memory consumers by RSS (pages):
[   51.670312]   #  [  pid  ]   uid      rss  name
[   51.670321]   1  [   7379]     0 13516544  stress
[   51.670328]   2  [   7382]     0 11122123  stress
[   51.670337]   3  [   3861]     0     8158  Xorg
[   51.670344]   4  [   4228]   995     6288  kwin_x11
[   51.670353]   5  [   4272]   995     5903  ukui-screensave
--
[  434.642788] Top 5 memory consumers by RSS (pages):
[  434.642795]   #  [  pid  ]   uid      rss  name
[  434.642802]   1  [   7442]     0 12324420  stress
[  434.642808]   2  [   7445]     0 12318626  stress
[  434.642817]   3  [   3861]     0     4766  Xorg
[  434.642824]   4  [   2693]     0     3963  firewalld
[  434.642832]   5  [   2856]     0     3028  tuned


 mm/oom_kill.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5f372f6e26fa..36a9863b502c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -376,10 +376,55 @@ static void select_bad_process(struct oom_control *oc)
 	}
 }
 
+#define OOM_TOP_CONSUMERS	5
+
+struct oom_top_consumer {
+	pid_t		pid;
+	uid_t		uid;
+	unsigned long	rss;
+	char		comm[TASK_COMM_LEN];
+};
+
+struct oom_dump_context {
+	struct oom_control	*oc;
+	struct oom_top_consumer	top[OOM_TOP_CONSUMERS];
+	int			top_count;
+};
+
+static void oom_top_consumer_add(struct oom_top_consumer *top, int *count,
+				 pid_t pid, uid_t uid, unsigned long rss,
+				 const char *comm)
+{
+	int i, pos = *count;
+
+	for (i = 0; i < *count; i++) {
+		if (rss > top[i].rss) {
+			pos = i;
+			break;
+		}
+	}
+
+	if (pos >= OOM_TOP_CONSUMERS)
+		return;
+
+	for (i = min(*count, OOM_TOP_CONSUMERS - 1); i > pos; i--)
+		top[i] = top[i - 1];
+
+	top[pos].pid = pid;
+	top[pos].uid = uid;
+	top[pos].rss = rss;
+	strscpy(top[pos].comm, comm, sizeof(top[pos].comm));
+
+	if (*count < OOM_TOP_CONSUMERS)
+		(*count)++;
+}
+
 static int dump_task(struct task_struct *p, void *arg)
 {
-	struct oom_control *oc = arg;
+	struct oom_dump_context *ctx = arg;
+	struct oom_control *oc = ctx->oc;
 	struct task_struct *task;
+	unsigned long rss;
 
 	if (oom_unkillable_task(p))
 		return 0;
@@ -397,13 +442,18 @@ static int dump_task(struct task_struct *p, void *arg)
 		return 0;
 	}
 
+	rss = get_mm_rss_sum(task->mm);
 	pr_info("[%7d] %5d %5d %8lu %8lu %8lu %8lu %9lu %8ld %8lu         %5hd %s\n",
 		task->pid, from_kuid(&init_user_ns, task_uid(task)),
-		task->tgid, task->mm->total_vm, get_mm_rss_sum(task->mm),
+		task->tgid, task->mm->total_vm, rss,
 		get_mm_counter_sum(task->mm, MM_ANONPAGES), get_mm_counter_sum(task->mm, MM_FILEPAGES),
 		get_mm_counter_sum(task->mm, MM_SHMEMPAGES), mm_pgtables_bytes(task->mm),
 		get_mm_counter_sum(task->mm, MM_SWAPENTS),
 		task->signal->oom_score_adj, task->comm);
+
+	oom_top_consumer_add(ctx->top, &ctx->top_count, task->pid,
+			     from_kuid(&init_user_ns, task_uid(task)),
+			     rss, task->comm);
 	task_unlock(task);
 
 	return 0;
@@ -418,14 +468,20 @@ static int dump_task(struct task_struct *p, void *arg)
  * are not shown.
  * State information includes task's pid, uid, tgid, vm size, rss,
  * pgtables_bytes, swapents, oom_score_adj value, and name.
+ *
+ * After the full task list, a summary of the top OOM_TOP_CONSUMERS memory
+ * consumers by RSS is printed to aid quick diagnosis without manual log
+ * post-processing.
  */
 static void dump_tasks(struct oom_control *oc)
 {
+	struct oom_dump_context ctx = { .oc = oc };
+
 	pr_info("Tasks state (memory values in pages):\n");
 	pr_info("[  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name\n");
 
 	if (is_memcg_oom(oc))
-		mem_cgroup_scan_tasks(oc->memcg, dump_task, oc);
+		mem_cgroup_scan_tasks(oc->memcg, dump_task, &ctx);
 	else {
 		struct task_struct *p;
 		int i = 0;
@@ -435,10 +491,22 @@ static void dump_tasks(struct oom_control *oc)
 			/* Avoid potential softlockup warning */
 			if ((++i & 1023) == 0)
 				touch_softlockup_watchdog();
-			dump_task(p, oc);
+			dump_task(p, &ctx);
 		}
 		rcu_read_unlock();
 	}
+
+	if (ctx.top_count > 0) {
+		int i;
+
+		pr_info("Top %d memory consumers by RSS (pages):\n",
+			ctx.top_count);
+		pr_info("  #  [  pid  ]   uid      rss  name\n");
+		for (i = 0; i < ctx.top_count; i++)
+			pr_info("  %d  [%7d] %5d %8lu  %s\n",
+				i + 1, ctx.top[i].pid, ctx.top[i].uid,
+				ctx.top[i].rss, ctx.top[i].comm);
+	}
 }
 
 static void dump_oom_victim(struct oom_control *oc, struct task_struct *victim)
-- 
2.25.1



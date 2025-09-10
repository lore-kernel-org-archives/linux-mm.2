Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F44ACA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE438E001B; Wed, 10 Sep 2025 01:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5EAE8E0001; Wed, 10 Sep 2025 01:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF258E001B; Wed, 10 Sep 2025 01:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB1768E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:32:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A14EBB4A1
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:34 +0000 (UTC)
X-FDA: 83872220628.28.7737BBC
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80FCEC000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f0Giqs8r;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3evZkOOAwLovlQ4xAZyrzRxNzWtrzok12LdiaOixdrk=;
	b=78XuOjA2vR23ZBkaKsj7eLRDM9Y0EKREVT9aVBvCStlERfZRW+qmJJl7RHERNH0AH9BVmN
	Ms3kkm8kVjxPoo9TFxeEucwmW4an3HhMbCwbdFAXWjmbpAHdaK+DLdWfICVF0Dy913HJOB
	tTyhQ83PoqqsM2dQ8ZCvXYNBg+NjnWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482352; a=rsa-sha256;
	cv=none;
	b=SQL3N8hXHS42ImIonCmjsRsKRMe3rhyHVT0sztTWrFPfqBg2LVd8Y/J5UUf/Fib3u+36tB
	XO7gkKxHa86I8F4iuLgt+bfUfyLY1fV/2yEH1eu0hPo1WlZBhT3ZcDiKMosBzEr3RsmT1B
	ak2/mF0urmmqhaFFOP+u0zxYUrQ3+cE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f0Giqs8r;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-772481b2329so6681447b3a.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482351; x=1758087151; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3evZkOOAwLovlQ4xAZyrzRxNzWtrzok12LdiaOixdrk=;
        b=f0Giqs8riNjr4sT2D14rCvRvhAQ1/debNWMgFxQkgjOFHNqXTtXSsVqyqJLB2I1+Ue
         PQwKIVwPx1TiDNYIYWZKbilMZvgD/LnU8YTIUZwRyM1PFaknTGNiZUnaM8pDFn3PyMM0
         VVjjmtqdtD1Bo3Ac8ufoc9lYDRh8/t7zojwka0UoA4ZKqoH+zTtZ8w57QHw3pSoK+Uh0
         ST+FEpgO4h9FT7qrl2V4V1OoWe4TyHWZlkoO3JicAJdTtWQg/7O3y27XfiGE8aTlV6k3
         /zEvk5Jyz2osmxL0gmaqbK8UPq90tFFU782L6Dq34+Y8sJu/it/uPpHRO15TE4vz02Ll
         dI5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482351; x=1758087151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3evZkOOAwLovlQ4xAZyrzRxNzWtrzok12LdiaOixdrk=;
        b=Ga3HvXVl4KewB/18F78+mPrAgkZXnawh5uHN9TmGuSgWT0R8s4jS24GV20AuQ4uiqK
         70u8kds5tdowg1zlb+5FRqD5D4ViGvV6d7UfFg/U7beqika9qLEQsM1VsX72ff0n/i1M
         5IrHKfV+ioKWlFAbjLUm8z78t4tCaogdzM9xK52vuF972K2sbVYNR/Vouh0e5xg8itXt
         8sTjTucCbKQJGQSrXhODqlpizNaieUKJqJJL3Xc+LUEUsTU9v8SYz+jTC5VWVv5lSgX0
         W2yGsWXtCMh9PIe1uzNBzrehoBNLV9BgWL34l97hKeekfCSso+QjxGUIaBWaXo42vtEL
         Yv6A==
X-Forwarded-Encrypted: i=1; AJvYcCW731hIZixRkjht8s5FD/k0w6Gg2yK6HLghw6n/qG/DP7VvLg7GI+/+rWxPnRiUxAtlvdxuywjjww==@kvack.org
X-Gm-Message-State: AOJu0YwHfUz8aJMjTTIOyj0mMCFJddNozWrMe9vCoOUqncc9tRYHJqnD
	VNDNrTwgqb3QH7nnEyV16HpJMdhiWvE9EwXpIhfqiDBu7PgMws5/SBxl
X-Gm-Gg: ASbGncu+8zYD48Ze5ovBP7p1eGqEilcV5dZGLOVdN+MkjI2C6JYziOoq+zRuQtiGTyd
	oV9LlYUMeXpwNc59MOHfnM3KTEFlCBXunRPSFsWgabkNw6D3eXs1pp5ZzosZLpeCQeYbxKa0QzX
	4V6pxsFgNWZHRkJCK0PcYdpkdgROXqlui2uVetMUCA5S5vbA0v1q0oa5aXeHY0XWKYwW6qfrb7B
	ip046/Sz5tUIjM2WtSngosohoD5Q+YNrH9diZF7Sa+q6Q3f3T0yLclazpldOgJ2Zjs8q3w11Sax
	o07ZU4CLpq8OLRNZc8UpEnriyCXORpP9q25brgUJOKdJ09D881nYUXTs7InJcihmLCTzQxb7KO6
	So4T9KEC41VUXIB21LhQdzt2qIpqprt+lihiAeMIoSXaPzOrpDQ==
X-Google-Smtp-Source: AGHT+IGgiGpkBgsz8ZnP03+D6W8a7MBFD7GkD9tVVGPHeuidNDi6K7cf2epcquENy/jb+9dIMJJ3hQ==
X-Received: by 2002:a05:6a00:84e:b0:771:f69a:c426 with SMTP id d2e1a72fcca58-7742ddadc99mr21024675b3a.14.1757482351351;
        Tue, 09 Sep 2025 22:32:31 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:32:30 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v3 11/19] mm/ksw: add recursive depth tracking
Date: Wed, 10 Sep 2025 13:31:09 +0800
Message-ID: <20250910053147.1152253-3-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 80FCEC000C
X-Stat-Signature: jw3c99gt8r5j9dq5suntqznw59ph3zh8
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757482352-599891
X-HE-Meta: U2FsdGVkX18T+tdWdet5d9EBUpbQowv/u6cSdpatvwtt2FBV1rk73KfAMbpE1IDscmJpdQTSuSXd7lrStYsqty+R7hgCwrGYYTJjNScvEMqYAjcelpmhfna9Su4Ff8RKSA9+wn66dY5ad/79X9jIXmM9YHEJc3JcVqMhNTd3NAFGOCecJ2lJqf38hO6jBJYGOe78x/7HuCktCFCm6//UX96FIWj5MW0ZIT1/E3mr9rFkWg+KhlLsqp8Hd7yY0l38r7949FZ9GX/12trdPu4j1HJX8p8TyVeKvPGbLWHtHdeJ9eVWffo0zGbxwa1w8nRU/LuOGIVtmaQMG2EThuTcTiafWCnXQe75jL1vnL5DF0DFp3susx5VqAw3sm6il5PMwnRyI3Cj8y/ELRdcUfF1+XIR7HRqarbwevJt4vfJofx8+Ss0gVJob4OtbBya7ot0DittBCxAusBQbupUp8IBSo5tnKYGyBuPtOw2eGtwA6ug60Cp/S2MGECuNhj+DBmyx+Xh5vxhsnZJh2BvQ/WejR2H5AyKXk61FGMEo6pUuPIRRYp9vgBSl74ydW/MHexLFQNS4YM/bumfN9aMxD/6dujI0jNWQ4eFNW2Q8Aftb4roi97Ij7nVG8T0ZDSeDDlWFaX0/QFcNSO863Vlt6sK4ViZcGi0KMSoEGKXzyQd+3HdEL2UlFdKPVSFd8MzaySfQATC/SgIjX1aU9X73Cth4xj5ojjSKbK9olB1sxno0rfX+JyBWN7/Ob7Iyz1syg1y4LQTovu1w5aOOXpC3p0iZa2oTkEa67qUpPD5Lq1/NcpeQGjtY8FbKlGlC3EheqNCqvDBv6GAL0jgHMndtM1qfg1dXu2GEM+11mAECUtA7u1pz0+TV8pHDAuhlDP91MovqgP3QvxXw53xEG5ik69U4JcqgCllWX7Saq/6ISt+Y0oElpxVinifWUPelZQ4LV0ykA2oduw4s8N2o0/llhJ
 jsPbJNqh
 1QcFXYMDg25xx8vN28teDxr7WhrgC/rIFox0Eg5WsSxt9ercAv/YmyeaA2I80Ak+Luog5b0q5ZbPwl/ftrVq+PziJwONOGOQ+wy9OZ30wxwufti8ixO13aiHSG9H4d9LLAzEdT7Z3eXeRJISsOxmQ5jj2nFqk8xbGQsw7Tol2BkmUdxn2dtInEILDL6ypTDVWcarYUcIPADoa4ka5Whlg+hShh4EcnUxjaonJNv0hDey3CXfzQyuJOOeoo6riRnga4GQkgR9USTBQCkZXULS5bxoVvLFZwUYPJvXWnf9FRkGwb54QDarrAXikv1jkelvgI8XMlDlU2gdAbvasgxQxG16cyuk6crDB7Yu317+HW2M6hJ0FDwd3A2yjErVQGzHeNLe8Gu7LF27JmNHUsd8CCISrwrXXEfQJHyvdPxgGJlYenpdS91XKbxY3IYaBWOosHw8zDxtAXWq6+o5hw/iA3YRLtC5xz9IP2s6z5cIy9+jNtGHmV4oj52YB7pymwvyXAXtyyYXnGhrYUf+TbeZHxYg6/N7BgR5XPEYA0O7UfnysJrk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track per-task recursion depth using a simple hashtable keyed by PID.
Entry/exit handlers update the depth, triggering only at the configured
recursion level.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 100 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 2 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 3ea0f9de698e..669876057f0b 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -3,6 +3,8 @@
 
 #include <linux/atomic.h>
 #include <linux/fprobe.h>
+#include <linux/hash.h>
+#include <linux/hashtable.h>
 #include <linux/kprobes.h>
 #include <linux/printk.h>
 #include <linux/spinlock.h>
@@ -15,6 +17,83 @@ static struct fprobe exit_probe;
 static atomic_t ksw_stack_pid = ATOMIC_INIT(INVALID_PID);
 #define MAX_CANARY_SEARCH_STEPS 128
 
+struct depth_entry {
+	pid_t pid;
+	int depth; /* starts from 0 */
+	struct hlist_node node;
+};
+
+#define DEPTH_HASH_BITS 8
+#define DEPTH_HASH_SIZE BIT(DEPTH_HASH_BITS)
+static DEFINE_HASHTABLE(depth_hash, DEPTH_HASH_BITS);
+static DEFINE_SPINLOCK(depth_hash_lock);
+
+static int get_recursive_depth(void)
+{
+	struct depth_entry *entry;
+	pid_t pid = current->pid;
+	int depth = 0;
+
+	spin_lock(&depth_hash_lock);
+	hash_for_each_possible(depth_hash, entry, node, pid) {
+		if (entry->pid == pid) {
+			depth = entry->depth;
+			break;
+		}
+	}
+	spin_unlock(&depth_hash_lock);
+	return depth;
+}
+
+static void set_recursive_depth(int depth)
+{
+	struct depth_entry *entry;
+	pid_t pid = current->pid;
+	bool found = false;
+
+	spin_lock(&depth_hash_lock);
+	hash_for_each_possible(depth_hash, entry, node, pid) {
+		if (entry->pid == pid) {
+			entry->depth = depth;
+			found = true;
+			break;
+		}
+	}
+
+	if (found) {
+		// last exit handler
+		if (depth == 0) {
+			hash_del(&entry->node);
+			kfree(entry);
+		}
+		goto unlock;
+	}
+
+	WARN_ONCE(depth != 1, "new entry depth %d should be 1", depth);
+	entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+	if (entry) {
+		entry->pid = pid;
+		entry->depth = depth;
+		hash_add(depth_hash, &entry->node, pid);
+	}
+unlock:
+	spin_unlock(&depth_hash_lock);
+}
+
+static void reset_recursive_depth(void)
+{
+	struct depth_entry *entry;
+	struct hlist_node *tmp;
+	int bkt;
+
+	spin_lock(&depth_hash_lock);
+	hash_for_each_safe(depth_hash, bkt, tmp, entry, node) {
+		hash_del(&entry->node);
+		kfree(entry);
+	}
+	spin_unlock(&depth_hash_lock);
+}
+
 static unsigned long ksw_find_stack_canary_addr(struct pt_regs *regs)
 {
 	unsigned long *stack_ptr, *stack_end, *stack_base;
@@ -109,8 +188,15 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 {
 	u64 watch_addr;
 	u64 watch_len;
+	int cur_depth;
 	int ret;
 
+	cur_depth = get_recursive_depth();
+	set_recursive_depth(cur_depth + 1);
+
+	if (cur_depth != ksw_get_config()->depth)
+		return;
+
 	if (atomic_cmpxchg(&ksw_stack_pid, INVALID_PID, current->pid) !=
 	    INVALID_PID)
 		return;
@@ -126,8 +212,8 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 	ret = ksw_watch_on(watch_addr, watch_len);
 	if (ret) {
 		atomic_set(&ksw_stack_pid, INVALID_PID);
-		pr_err("failed to watch on addr:0x%llx len:%llu %d\n",
-		       watch_addr, watch_len, ret);
+		pr_err("failed to watch on depth:%d addr:0x%llx len:%llu %d\n",
+		       cur_depth, watch_addr, watch_len, ret);
 		return;
 	}
 }
@@ -136,6 +222,14 @@ static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
 				   unsigned long ret_ip,
 				   struct ftrace_regs *regs, void *data)
 {
+	int cur_depth;
+
+	cur_depth = get_recursive_depth() - 1;
+	set_recursive_depth(cur_depth);
+
+	if (cur_depth != ksw_get_config()->depth)
+		return;
+
 	if (atomic_read(&ksw_stack_pid) != current->pid)
 		return;
 
@@ -149,6 +243,8 @@ int ksw_stack_init(void)
 	int ret;
 	char *symbuf = NULL;
 
+	reset_recursive_depth();
+
 	memset(&entry_probe, 0, sizeof(entry_probe));
 	entry_probe.symbol_name = ksw_get_config()->function;
 	entry_probe.offset = ksw_get_config()->ip_offset;
-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C8E8CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8638E0015; Wed,  3 Sep 2025 20:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7FCB8E0003; Wed,  3 Sep 2025 20:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95D98E0015; Wed,  3 Sep 2025 20:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93FC98E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:23:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9B20160977
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:21 +0000 (UTC)
X-FDA: 83849668602.22.904D740
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8C68120014
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aCqiHI+Z;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=18zaW3moNW/J2OB76TZ6MBmnN/MPkuC7bfXPlyWG+/g=;
	b=smAZ/jHkKPwIf6trw0c3Iu0ZCtzUnN1oIbLJB6H+DnKPUA5+Mzr92bwn3UhT0SoxPVxRfr
	x9sZjrgNeq7cPelFT6XBlfP1cbbVc4Ur93gX0dEt03eEnwOIcAQXFqErxNIIefCmUofp1b
	URRthdBhH21el0GC3bcanuN+URbDO2A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aCqiHI+Z;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945399; a=rsa-sha256;
	cv=none;
	b=ywQwmhYckqwnS1e6FhKpRqCauy+5PdBBXa+uvtrl+46BXWweWeKG/7L7tWOa1xRLz+5DWE
	+CwHy3sjzT3Nv9GeDI25rm05KBl1EhwRfuUHXJB2B0EhK7Ign0il5YHvB0Lqo7TOIFf37a
	pGQsGjbstV1OaJuL/NrqEV20z6fgYdM=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-77290e32e26so61236b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945399; x=1757550199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=18zaW3moNW/J2OB76TZ6MBmnN/MPkuC7bfXPlyWG+/g=;
        b=aCqiHI+ZiSiwedL2uP5y1e8khATxNBy9nc7z7epZ8F8B7OjNZ30CGQPEPoziTOAaQV
         u3bcycWRjm0l2P6BOg0rW2I6ozv3JeUwWX6yiwx4cggjDSPWvvD1HyhPTll2L+tFvpbZ
         YvuH4iiY/Z3iRWIMxwx9hPj4WoJwpt/IN8hxhsmTeZlt8cfDubodojyAMz8KfT826k02
         vUM5CqsOJUmIBQY1NxlTzovmPIsG1cdlpHR6VpxIt1ZbMlw/v81HoJGx5pItxEDDcLdT
         OLf2ATf7LtV2VLPgvEavCS0cdWe2ZwnWFRZJDnWC5HcR9+c2sbGpp0SBIKTrm1LuucXT
         j1Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945399; x=1757550199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=18zaW3moNW/J2OB76TZ6MBmnN/MPkuC7bfXPlyWG+/g=;
        b=DsnVSnsGg68gcLc4nqVHh2KkW4Bm80vyGAK2AbNsSVX8Hq07p6KRAnPD5gpMCXifjx
         7t5fzKKgMWMAo47bMZtVwlpSN/YXKPT7XijhBnU8GwrnDl8kR6dM1h8amMRJ1VsNWe2X
         noxu9mOw034TjpomzD+6r4l2kTsCFpEvnb2vmfuCX9lU4kaKdqG/+zAjr35ulK2qH3wm
         yhu0r30yVmHOQGiKwIJejDme3uxaL7d4x2goYkQXvhvN+2Aqu7GF116P1SHbxwWSCd/z
         nKs7bbvZ3DT0t1LrKXQp1c/vbtUdjz+OQwN187BQf3FxiSKG39ADlMz9ocpD/tWO3siC
         NjHA==
X-Forwarded-Encrypted: i=1; AJvYcCWebyKlCm2CGcswsUF1GTyP6cIsVLy49VvEfXJeBDYt9C5w66KC8qcVk85aloOqlcNGI9suew4YcQ==@kvack.org
X-Gm-Message-State: AOJu0YxM5kvd0FD0xpzI1jFKLo/uSrFGZgmlv2AQMr5KCbWGL1FQSE2V
	xndAluvUW4E9HlpW/lHzJDUw36zWR4Exkh2b2txoQXKLdr84+oQcZn+2
X-Gm-Gg: ASbGncv3euaOh9fLxlpZlwnZYq+nmqfWfkh5NbaOCqKSHEPH2GCGhueiMA4SBKRM4p7
	q5UZvYuqHh67BYTo1bLO9D1YOXfhVComCGxBEUME3Rz6TmPhdTtBTAHI1OfDZTpXEsASmY2dCoP
	94uZSPpUC0ffuDnxoM1c24MZe0I9JVGrBy9CGTHpb0goWWwNBvXrBJ4FJ75TpNRuITRob4uh0ax
	TGIRSB48CKyuE5pmjDQFZxfLVIJe7+bPNBfn4RGRU1bJJXzVebCwfVgPx0XVp0/UdI2hv5Jo13J
	TYxszVpgxxYIdHZTNFFbmYnNuNxgV+CQ0OfByuFrjsjZ/39nbWLnYSU0fih1WBKvplkCpQkE0ZP
	W+yR1k+ewN2R0kwV60qfBJgYy4HlE7sHeacHb4b6P9YWw+d7QhBmB
X-Google-Smtp-Source: AGHT+IFn+y2P+lkSjCxmHbNPVMFNCQGc4aVUADK0EWUrb+8UNHFLYez+kqXUbc2XvO+u3VVteAjfqA==
X-Received: by 2002:a05:6a00:3492:b0:772:5899:eae8 with SMTP id d2e1a72fcca58-772589a2e50mr16425370b3a.27.1756945398629;
        Wed, 03 Sep 2025 17:23:18 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.23.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:23:18 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 10/18] mm/ksw: add per-task recursion depth tracking
Date: Thu,  4 Sep 2025 08:21:07 +0800
Message-ID: <20250904002126.1514566-11-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 59tc67zk5m5tp8o4ouwyxk1t5nbhei7j
X-Rspam-User: 
X-Rspamd-Queue-Id: C8C68120014
X-Rspamd-Server: rspam05
X-HE-Tag: 1756945399-603018
X-HE-Meta: U2FsdGVkX18vIJL1r4NtN9P3WvrxLQOUjycDnQqfqOZAY/eu8e3QfOJoW6fpl4rPiW/w9r4PxNKaDbCK+V3vbz05NpFGNj6JEmxC8HPz1MgFksZK787+zRq4Nl080L46vexGUp1xjNs+/U4A3uls0jFHA7nldngph8WbXmlDAoQoE+ka3fuPaGQZ/MO0k8w3l3xNPyT1291YqeyHaO2NKOpdYwDMgPk63RzwoDiVJcXO5t30Ks6oYpFR58ET6dfjaNv7Y4+3VqsIXKeewFH7bzzDaocYAexxEw8DXnlo4IOMFD4kdIOSG92GyAThgJbgOlOQvtDhxVtySP4gj/l95/6YVVWP/hkM8DVOCcjdzwsLtZyDVoon9y4KbMpAPdg8y15UB83dmWy1lyq0rkaFC5T4z7k8e0ecRtLVgwOZvL2Do5XLYX+juX0Ti7lBeFAV23a5NrFpF28zgzAMHj6anBgVmROePG/+tNwjaS9H7iA6jZDVuwHicDi3/CkBMoE5Htyt2oAGg046qa+v362oc63eQrvF/ZzeM+072G2wxLkhOLWNjyZi0thjqYZOfm965jsQWMTSq+xEQIBTWdhwfvxaZ06juZKJU5tu93NSCte5CXvsnBNuI5b881VEWYfnGoZY+WVDuLB0undtV6f8J/lD8rdWe9ZvsOtD7TpStibmP/amOFtaeKFbtY1pE+G673qd2nV+pm26FeeZe/ekd9z97Kg5bsBg82AWkkSOENtmqAT+nAhod4eyXpGw5XTUpLEmh6I0f/4dE6zJYvdpyh+RoPptM2BYVhXRkv2kZljf1XJptvBUmiUzsH8HJH7F3b9eO+Ze9+NlODN5bbz4wowIvdZM1xFCP+Vt9Gl3uFBif+ZXskx5C0fKN/7NHik9VthUS1bXy6csy4i2yc1lsvFmUFlQpmOIbEBQfv4ByZYoj8NQGteGACf7+yl5Sm/I3LMh8k74oAxyksu4X/w
 PSjxRe+Z
 xdXLM1jeg0fScz8UmX0za/hvOF5F1jNCTOzjv/K+Egt0lPCPXpxs3mWk9PM81oJ/DO0QonHCK9O+Ats9O5GLsPgEiwPnGegAtzQ+fxpOTt7X8Sr1EhvszxCDjTvgpWXAwhIb5tOW+GaeJQT3mGMMIg9tcCKuvieoMTyt/va/Q9OJZt+03ScQk7H9UCbicMbrElJ6UDHi49cNVFSF3vCtJqdZBIYDRgRig14kgUYdDAUhRHjHv76cw9n/f5ZlaBz+4l+zDijk0SSvgO61CrpjOB/WYX2J7FGbEjSpRUrWFPCgIK0EW8e2ZfLfYMGQoF9DLJgfy4xTZvRLNZZfYj99yG/vyCAqcXhNId2CgJT7ThSR6qHrsJJmcncALaNiYSsJan/T2tfg/LRO4P/UVowmxD33YjRahMz/no0QU2wq39IS4jl2QPkw0JWAHfjhKyHTFNjo8LQIU+CzkJvIeAhaJvrSw10BVUeQLUNd5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement depth tracking for KStackWatch to support stack-level filtering.
Each task's recursive entry depth is stored in a global hash table keyed by
pid:

 - get_recursive_depth()/set_recursive_depth() manage per-task depth
 - reset_recursive_depth() clears all tracked entries
 - entry/exit handlers increment or decrement depth and skip  if the
   current depth does not match the configured depth.

This works even across task scheduling or in interrupt context, since depth
is tracked per-task, ensuring KStackWatch can selectively monitor a
specific recursion level without redundant triggers.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 105 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 103 insertions(+), 2 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 00cb38085a9f..8758b8b94f7f 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/fprobe.h>
+#include <linux/hashtable.h>
+#include <linux/hash.h>
 #include <linux/interrupt.h>
 #include <linux/kprobes.h>
 #include <linux/percpu.h>
@@ -12,6 +14,81 @@
 
 struct ksw_config *probe_config;
 
+#define DEPTH_HASH_BITS 8
+#define DEPTH_HASH_SIZE BIT(DEPTH_HASH_BITS)
+
+struct depth_entry {
+	pid_t pid;
+	int depth; /* starts from 0 */
+	struct hlist_node node;
+};
+
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
+	hash_for_each_possible(depth_hash, entry, node,
+			       hash_32(pid, DEPTH_HASH_BITS)) {
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
+	hash_for_each_possible(depth_hash, entry, node,
+			       hash_32(pid, DEPTH_HASH_BITS)) {
+		if (entry->pid == pid) {
+			entry->depth = depth;
+			found = true;
+			break;
+		}
+	}
+
+	if (!found && depth > 0) {
+		entry = kmalloc(sizeof(*entry), GFP_ATOMIC);
+		if (entry) {
+			entry->pid = pid;
+			entry->depth = depth;
+			hash_add(depth_hash, &entry->node,
+				 hash_32(pid, DEPTH_HASH_BITS));
+		}
+	} else if (found && depth == 0) {
+		hash_del(&entry->node);
+		kfree(entry);
+	}
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
 /* Find canary address in current stack frame */
 static unsigned long ksw_stack_find_canary(struct pt_regs *regs)
 {
@@ -119,10 +196,21 @@ static struct fprobe exit_probe_fprobe;
 static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 				    unsigned long flags)
 {
+	int cur_depth;
 	int ret;
 	u64 watch_addr;
 	u64 watch_len;
 
+	cur_depth = get_recursive_depth();
+	set_recursive_depth(cur_depth + 1);
+
+	/* depth start from 0 */
+	if (cur_depth != probe_config->depth) {
+		pr_info("KSW: config_depth:%u cur_depth:%d entry skipping\n",
+			probe_config->depth, cur_depth);
+		return;
+	}
+
 	ret = ksw_stack_prepare_watch(regs, probe_config, &watch_addr,
 				      &watch_len);
 	if (ret) {
@@ -132,8 +220,8 @@ static void ksw_stack_entry_handler(struct kprobe *p, struct pt_regs *regs,
 
 	ret = ksw_watch_on(watch_addr, watch_len);
 	if (ret) {
-		pr_err("KSW: failed to watch on addr:0x%llx len:%llx %d\n",
-		       watch_addr, watch_len, ret);
+		pr_err("KSW: failed to watch on depth:%d addr:0x%llx len:%llx %d\n",
+		       cur_depth, watch_addr, watch_len, ret);
 		return;
 	}
 }
@@ -142,6 +230,17 @@ static void ksw_stack_exit_handler(struct fprobe *fp, unsigned long ip,
 				   unsigned long ret_ip,
 				   struct ftrace_regs *regs, void *data)
 {
+	int cur_depth;
+
+	cur_depth = get_recursive_depth() - 1;
+	set_recursive_depth(cur_depth);
+
+	if (cur_depth != probe_config->depth) {
+		pr_info("KSW: config_depth:%u cur_depth:%d exit skipping\n",
+			probe_config->depth, cur_depth);
+		return;
+	}
+
 	ksw_watch_off();
 }
 
@@ -150,6 +249,8 @@ int ksw_stack_init(struct ksw_config *config)
 	int ret;
 	char *symbuf = NULL;
 
+	reset_recursive_depth();
+
 	/* Setup entry probe */
 	memset(&entry_probe, 0, sizeof(entry_probe));
 	entry_probe.symbol_name = config->function;
-- 
2.43.0



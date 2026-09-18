Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B522C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 06:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077996B0092; Fri, 18 Sep 2026 02:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F3A6B0093; Fri, 18 Sep 2026 02:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7356B0095; Fri, 18 Sep 2026 02:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1D7A6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:59:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC773805D8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:59:28 +0000 (UTC)
X-FDA: 85225982016.26.C6B167B
Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	by imf15.hostedemail.com (Postfix) with ESMTP id DDE82A0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:59:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YdFtWTw2;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789714767;
	b=71Yo86A2pjY2ZwipLBhWZYn6ZNROjQ9HphXn2w34wxVG9oL6y43+THnhFk6NR3RXx6XNEd
	DDsHSZwR6f+FW5tOM80Ix/fstKz6M8WlujFLKKDXmVEAGR0pl3qoX9pw2QKe2kls1u6IQa
	pd+bhu+LbcJ19t/tibJGAb917gnB3NU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YdFtWTw2;
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.148 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789714767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EumA9KZezwmqx4LkvsBGMaWJU54VoP24ZhPQOG7K82Q=;
	b=2HDxVPKZr66Dbf1W+dMWiw9hFA+VRugEIipZwsUTo33KZw/Uw5RJ8cVNV0m/M66uk1wtZ9
	ktl41Cl1eG+9zorRHbeAH7ozRq921f1H96wBfzJ4/6j3siQiNtVaZi8ZcYVE5HeCk68exx
	kD+zNXnPCKhLNy4IYw/duf0rE2U7bo0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=W0yWpOmoDzib5Rm1x8YliOd+9RxKMkDx4q1dFk81TOc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789714765; v=1; x=1790319565;
 b=YdFtWTw2KSolwL7n3FG0tP8R1bXskkQ90ZjBrqY2J9FpC/AxdhZphSFGlqPeUdEL5QNRQimU
 1CJH2kItItgFJ45CSSN5s21NYLksERMhH3C982Onk45FE9EcDv3E5OyJudeUPwdKEHdu/QSm3Ti
 3HyGJu5k/U9I8XKz3ZwnO/c0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 06b45d8891529b42;
	Fri, 18 Sep 2026 06:59:25 +0000
X-Mizu-Trace-ID: 06b45d8891529b42
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v12 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Date: Fri, 18 Sep 2026 14:58:53 +0800
Message-ID: <02f0a8dc45a840d7801ec17e0c1168f7dacf9b73.1789714023.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789714023.git.zhuhui@kylinos.cn>
References: <cover.1789714023.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DDE82A0005
X-Stat-Signature: 14njew15wxmynpkqsodtbybqbenmfod5
X-HE-Tag: 1789714766-928326
X-HE-Meta: U2FsdGVkX1/NzrevLearLfQr+dPpPN8/Q3qqvIxjD7GxcVlFslo1ftNJSPA2+goZmeqEa69fc3T9a9Flz99xwFoTjiW64xkuHsMO/akSmurmqELn+loou7OT6gP8jldEzURg3QeXXZMQEKoScRxMGmiuE8rfCeIyrisGd9r2YnKXvxzA8JCrSH0G1ZXjmbfwJ7hIqx2VxFMTC2r95DUTB05PZXzcIuRh9rlMGDXU+QTQVvhyeWXHGLR7LtxiJhb0m1iSlRsviFKAmsSFCAEepi5EOlwhqICsntD1hvud7Wdh4E4lucGN3gFwWY2QP72Usj91Sz1w5RRJPZOmrstPDlHMmSAAVrO/Cx2oxMVEKhxDNgk6Toqe13VIJfiITyJa+b2bBjmqT/2UFU0KEfJ6rNlXYT9YX+DxBcqTsOo4BD/ijq2cIxCwDVPwQM6W8196oK37rwz/P1Te4YLY9HE2wKHKDQUdP5I+QKs9A8aQnj7wRM/UeCVaKaH4UzUJ+i3Vih43fe/1BXnpL3FhrIf+vEtg+ftolVFrDzUjx6FZ0bNSUA7s6agbIQCeSvEHllxk9XkzJIY16N91gbI3yqKgW3OSWqtfccyMIWyl7/ElvahmBtEDk/YyGetl8V2J3LmjqG9y0+s5DBD1KIy02uWlmJncPrAGSVakPa2k/gLH2tiyG4NqGS1GegOPsySoz/5dDlYhSrX5pjsf7xI8u1B0HqGx4AlAxJQijFB8VugvlpxDzBE8GsrayDr6GJFHBqx+9tkv2bztYucLTtaG9Xt3lLq1Os4KeNBkjohW3M4NQxdW4bGQauiKBJ3h+81lqbg+UOnoKncDUBctW/mCWYV6cKqMTAJaEJXDLq1iz9owZz5nP/mDyp3IrO7g4rI5ewCixfHYZA75+1PTICZDSgl+T6key4RqZLTxhP+m+6D7szkS0XIyBpnlrAkN46TA5dajHw5XTwZ4Eju6Rk4zXLy
 75Bwz98O
 D71oAyj4bsrzZGQwz1C28Gq3fsFsBEOlMzYbq5qLgsEmETLwLsBKNrDor1dep6sqjxxaACmNFIWsInDLCa4AVuDZI55TJZ8a5mATd2SR4hVjJjWmuKAXXtE4bhS5Bpzp8RJZBV00XSy5BbrEIjhBgUZEs0lGVsdY3uQT+/J1sMV8xbaotuVGGinWHS2vy3yzSh5hMi/JZrgyEAuJU5HO3R6JcaMy0V5l5jxw8OxUGo37TAXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

BPF programs can observe memory pressure on a cgroup, e.g. refault
stats via bpf_mem_cgroup_page_state(), but cannot act on it:
triggering reclaim requires writing to memory.reclaim, which BPF
cannot do.

Add bpf_proactive_reclaim(), a sleepable kfunc performing one
proactive reclaim pass on a memcg, like a write to memory.reclaim
but without retrying until the target is reached, so that when and
how hard to reclaim is BPF policy rather than hard-coded thresholds.
The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
as high_work_func() does for memory.high; reclaiming more is left to
the program, which can call the kfunc once per bpf_wq callback and
stop at any point. It is limited to BPF_PROG_TYPE_SYSCALL, because
other sleepable programs may run with filesystem locks held, on
which the reclaim path could deadlock via filesystem shrinkers.

Convert MIN_SWAPPINESS, MAX_SWAPPINESS and SWAPPINESS_ANON_ONLY from
macros to an enum so that they are emitted into BTF and usable from
BPF programs via vmlinux.h.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/bpf_memcontrol.c | 62 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/internal.h       | 10 +++++---
 2 files changed, 67 insertions(+), 5 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..c5d7f29ade85 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -8,6 +8,8 @@
 #include <linux/memcontrol.h>
 #include <linux/bpf.h>
 
+#include "internal.h"
+
 __bpf_kfunc_start_defs();
 
 /**
@@ -159,6 +161,48 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/**
+ * bpf_proactive_reclaim - proactively reclaim memory from a memory cgroup
+ * @memcg: the target memory cgroup to reclaim from.
+ * @size: the amount of memory to reclaim, in bytes, clamped to
+ *        MEMCG_CHARGE_BATCH.
+ * @swappiness: the reclaim swappiness, in the range [MIN_SWAPPINESS,
+ *              SWAPPINESS_ANON_ONLY], or -1 to use the memcg's own
+ *              swappiness.
+ *
+ * Performs one proactive reclaim pass on @memcg, like a write to
+ * memory.reclaim but without retrying until @size is reached. Call it
+ * repeatedly to reclaim more than one batch.
+ *
+ * Only available to BPF_PROG_TYPE_SYSCALL, because other sleepable programs
+ * may run with filesystem locks held, which the reclaim path can deadlock
+ * on via filesystem shrinkers.
+ *
+ * Return: The amount of memory reclaimed, in bytes, or a negative error.
+ */
+__bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
+				       unsigned long size,
+				       int swappiness)
+{
+	unsigned long nr_reclaimed;
+	unsigned long nr_pages;
+
+	if (swappiness < -1 || swappiness > SWAPPINESS_ANON_ONLY)
+		return -EINVAL;
+
+	if (size < PAGE_SIZE)
+		return -EINVAL;
+
+	nr_pages = min(size / PAGE_SIZE, (unsigned long)MEMCG_CHARGE_BATCH);
+
+	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
+						    MEMCG_RECLAIM_MAY_SWAP |
+						    MEMCG_RECLAIM_PROACTIVE,
+						    swappiness == -1 ? NULL : &swappiness);
+
+	return nr_reclaimed * PAGE_SIZE;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -174,19 +218,35 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
+BTF_KFUNCS_START(bpf_memcontrol_reclaim_kfuncs)
+BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
+BTF_KFUNCS_END(bpf_memcontrol_reclaim_kfuncs)
+
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
 	.owner          = THIS_MODULE,
 	.set            = &bpf_memcontrol_kfuncs,
 };
 
+static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_memcontrol_reclaim_kfuncs,
+};
+
 static int __init bpf_memcontrol_init(void)
 {
 	int err;
 
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
 					&bpf_memcontrol_kfunc_set);
-	if (err)
+	if (err) {
 		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
+		return err;
+	}
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
+					&bpf_memcontrol_reclaim_kfunc_set);
+	if (err)
+		pr_warn("error registering bpf reclaim kfuncs: %d\n", err);
 
 	return err;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..44e95e87e3cd 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -74,11 +74,13 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
-#define MIN_SWAPPINESS 0
-#define MAX_SWAPPINESS 200
+enum {
+	MIN_SWAPPINESS = 0,
+	MAX_SWAPPINESS = 200,
 
-/* Just reclaim from anon folios in proactive memory reclaim */
-#define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
+	/* Just reclaim from anon folios in proactive memory reclaim */
+	SWAPPINESS_ANON_ONLY = MAX_SWAPPINESS + 1,
+};
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
-- 
2.43.0



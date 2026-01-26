Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF76C88E79
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 09:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436F56B0099; Mon, 26 Jan 2026 04:07:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE276B009B; Mon, 26 Jan 2026 04:07:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315046B009D; Mon, 26 Jan 2026 04:07:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1DF6B0099
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 04:07:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D290B1B05E9
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:07:55 +0000 (UTC)
X-FDA: 84373537710.11.D98DCE5
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1F7CF1C0002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:07:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=copk9EMd;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769418474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7g40Scui5AeSn6g7k+CN7+mSNdz8zvlZncZCV88NKxg=;
	b=dp8S3bcmjbD4nOpDyZ2zeOCvapYVaeOTb/acNoMUEtQnBte9OkjmkhBoYhEHH/i1TEy0oL
	wc1VXPDlhwjL8v/BlkLC+AyvMxmUvYkflwoHQBEyTPDXoGQzG3bBxlIh8MV/g3ZJQwdMPG
	tn46tAT+qTLY+IxXixCv2odm14/jWIk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=copk9EMd;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769418474; a=rsa-sha256;
	cv=none;
	b=FgycJWEmRrxs0MHMqam996HqXnjgmkDLCCRkA/UPXob0FcpjPi3+HAiylhUNGgJggHrBwy
	s1aasoMzqMSEDqucgjpkKgoUGqVp/l/kV2wXFLbU0C7N+CfGCl/s2RAJ/xTa4vUW17JWFE
	F+M3Yu0m2EEJOEY9fjGikiA/VSfYN/U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769418472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7g40Scui5AeSn6g7k+CN7+mSNdz8zvlZncZCV88NKxg=;
	b=copk9EMdoTHKQbMB3bhBYhXGwamypqLcWjDrVVdI7OAt1kcaier/EpCwd0reXZhKMzXwHb
	TSNpkaVgC5tWZb0CqfTNel02gPK7eyNnRHy9W7mtzwfEGXNExd589AiIzCd+M8oLblM5lA
	8lyEvs3htVy/+iHnCqIN2c3ElghCnBI=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [RFC PATCH bpf-next v4 12/12] samples/bpf: Add memcg priority control example
Date: Mon, 26 Jan 2026 17:06:31 +0800
Message-ID: <a78337e8e3eac1f279cab52db5573e6fbbaad4ef.1769417588.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769417588.git.zhuhui@kylinos.cn>
References: <cover.1769417588.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F7CF1C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: mjeter3rgey96x9fntf9jonn6ny1yzmj
X-HE-Tag: 1769418473-263475
X-HE-Meta: U2FsdGVkX19YQZI/1UQWfsexu4QeMmqA3boT+VH887AHCgC62l6SEi3bByUXlLbC/XhOMdxVX4FZFbCJ50XXumWIMWmCdzkwiTOqLTGyQYMirPz7Ez+/Of+s/67+a9PtckibiVpX67M20wN6Wk3KRwS9jTU7JXMSbc8ix4NTNHfJ086ec54cHCXIedihGY3L9YtvZvQn2IRyFhmjQ3syDuzWc/CZqonAahzlOqX5NyAirfOOsLtn/SZSXadj0OYJCvMSJ1xkyBSdwwUtWQw43gEnGWTdXYc3igtvJQ3sGQHwXkmNuNWECvw2o96Gp2x4J8RBEyArqS61VjCYKmhcGzT5NGCQCJoAacxWjVq8DAbGxEtdq4P4m6rEAWX7x6v1KaPkwmA6uZd+sSkDmfuCjn3hAuv14bBzAstLDB59qYNs4UGM5LnJpfQK+FGa9hp7rbstwiQ+McLRim5ohZRSnLYnTMSbNCDS+poJDObRwU9gABIFrHJ27Nh6Cs3rHlG9l9ifVr0L3mG61t4lRPSkdhrBPYlPAemye6GIKMCkhqUKm0PfRAaCJ0XNI/kE3mk5PS/J4APVyQVS7MI0r9rCaLihXo6z2gD0KCr8o07C3Gn0aidqsf8UsdAhHA84AZdbdOo0j5oxlQMVnkox5UNLMF9ZczUQR2BsWTmBpcKK8gnmAiumlhonUxBvb5xel6WjT8+I0+9/m5CECWSCZRuHPI5BTuq5T0oyl7FSOsZrD8QLaaTaMWeEW0obxYotPbW27WJthsvmMUOE2lBW/yCShJxifVBciZIqu0brywlaC8/Zo7s4dHMUIHXSE23IpUNa6Yr/HGAz4jce5ISOTIwCtJICqPBykOv6H8l54F7tJVJlcgYhDnKnw5+be2Nw5f2z5PQqKwj3irQahnePknvvwY6+iaKcECpzUgwZuLkwINbJVxvm5ZxqjcK8U39vrMKK6ObK5ny0Tc7Vd8DSbKG
 fJQimivr
 aaWkZjjgqhBHWpQ50OWPX6ST0KDbUCsFVy4sm7Uy5uHmBB/nX/aF/EKfxJkbsMpwtWv/86LPRmxfYWHOBgxDinKFIBqn4ees+9yI6zs0h0IEWNrYkalnq849MdOp8xVw8vC5ghBhgJKQbExO0eXNZkGLO3yXoP7HsALMoQJw5JFaiRQiU3hbCXqy85qWS5IZQHLL9iB5vZNe13vyoSk1fd2guztwuGtaW/Utzo5vEe8TPiDvCApCIu3B8L9H/iWTl2ZfG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add a sample program to demonstrate a practical use case for the
`memcg_bpf_ops` feature: priority-based memory throttling.

The sample consists of a BPF program and a userspace loader:

1. memcg.bpf.c: A BPF program that monitors PGFAULT events on a
   high-priority cgroup. When activity exceeds a threshold, it uses
   the `get_high_delay_ms`, `below_low`, or `below_min` hooks to
   apply pressure on a low-priority cgroup.

2. memcg.c: A userspace loader that configures and attaches the BPF
   program. It takes command-line arguments for the high and low
   priority cgroup paths, a pressure threshold, and the desired
   throttling delay (`over_high_ms`).

This provides a clear, working example of how to implement a dynamic,
priority-aware memory management policy. A user can create two
cgroups, run workloads of different priorities, and observe the
low-priority workload being throttled to protect the high-priority one.

Example usage:
  # ./memcg --low_path /sys/fs/cgroup/low \
  #         --high_path /sys/fs/cgroup/high \
  #         --threshold 100 --over_high_ms 1024

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 MAINTAINERS             |   2 +
 samples/bpf/.gitignore  |   1 +
 samples/bpf/Makefile    |   8 +-
 samples/bpf/memcg.bpf.c | 129 ++++++++++++++++
 samples/bpf/memcg.c     | 327 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 466 insertions(+), 1 deletion(-)
 create mode 100644 samples/bpf/memcg.bpf.c
 create mode 100644 samples/bpf/memcg.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e07bb330eae..819ef271e011 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6470,6 +6470,8 @@ F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
 F:	mm/page_counter.c
 F:	mm/swap_cgroup.c
+F:	samples/bpf/memcg.bpf.c
+F:	samples/bpf/memcg.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/bpf/prog_tests/memcg_ops.c
 F:	tools/testing/selftests/bpf/progs/memcg_ops.c
diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 0002cd359fb1..0de6569cdefd 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -49,3 +49,4 @@ iperf.*
 /vmlinux.h
 /bpftool/
 /libbpf/
+memcg
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 95a4fa1f1e44..b00698bdc53b 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -37,6 +37,7 @@ tprogs-y += xdp_fwd
 tprogs-y += task_fd_query
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += memcg
 
 # Libbpf dependencies
 LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
@@ -122,6 +123,7 @@ always-y += task_fd_query_kern.o
 always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
+always-y += memcg.bpf.o
 
 COMMON_CFLAGS = $(TPROGS_USER_CFLAGS)
 TPROGS_LDFLAGS = $(TPROGS_USER_LDFLAGS)
@@ -289,6 +291,8 @@ $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 $(obj)/hbm.o: $(src)/hbm.h
 $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
+memcg: $(obj)/memcg.skel.h
+
 # Override includes for xdp_sample_user.o because $(srctree)/usr/include in
 # TPROGS_CFLAGS causes conflicts
 XDP_SAMPLE_CFLAGS += -Wall -O2 \
@@ -347,11 +351,13 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(LIBBPF_INCLUDE) $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_router_ipv4.skel.h
+LINKED_SKELS := xdp_router_ipv4.skel.h memcg.skel.h
 clean-files += $(LINKED_SKELS)
 
 xdp_router_ipv4.skel.h-deps := xdp_router_ipv4.bpf.o xdp_sample.bpf.o
 
+memcg.skel.h-deps := memcg.bpf.o
+
 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.bpf.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
 BPF_SRCS_LINKED := $(notdir $(wildcard $(src)/*.bpf.c))
diff --git a/samples/bpf/memcg.bpf.c b/samples/bpf/memcg.bpf.c
new file mode 100644
index 000000000000..44087a206a61
--- /dev/null
+++ b/samples/bpf/memcg.bpf.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#define ONE_SECOND_NS	1000000000
+
+struct local_config {
+	u64 threshold;
+	u64 high_cgroup_id;
+	bool use_below_low;
+	bool use_below_min;
+	unsigned int over_high_ms;
+} local_config;
+
+struct AggregationData {
+	u64 sum;
+	u64 window_start_ts;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, u32);
+	__type(value, struct AggregationData);
+} aggregation_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, u32);
+	__type(value, u64);
+} trigger_ts_map SEC(".maps");
+
+SEC("tp/memcg/count_memcg_events")
+int
+handle_count_memcg_events(struct trace_event_raw_memcg_rstat_events *ctx)
+{
+	u32 key = 0;
+	struct AggregationData *data;
+	u64 current_ts;
+
+	if (ctx->id != local_config.high_cgroup_id ||
+	    (ctx->item != PGFAULT))
+		goto out;
+
+	data = bpf_map_lookup_elem(&aggregation_map, &key);
+	if (!data)
+		goto out;
+
+	current_ts = bpf_ktime_get_ns();
+
+	if (current_ts - data->window_start_ts < ONE_SECOND_NS) {
+		data->sum += ctx->val;
+	} else {
+		data->window_start_ts = current_ts;
+		data->sum = ctx->val;
+	}
+
+	if (data->sum > local_config.threshold) {
+		bpf_map_update_elem(&trigger_ts_map, &key, &current_ts,
+				    BPF_ANY);
+		data->sum = 0;
+		data->window_start_ts = current_ts;
+	}
+
+out:
+	return 0;
+}
+
+static bool need_threshold(void)
+{
+	u32 key = 0;
+	u64 *trigger_ts;
+	bool ret = false;
+
+	trigger_ts = bpf_map_lookup_elem(&trigger_ts_map, &key);
+	if (!trigger_ts || *trigger_ts == 0)
+		goto out;
+
+	u64 current_ts = bpf_ktime_get_ns();
+
+	if (current_ts - *trigger_ts < ONE_SECOND_NS)
+		ret = true;
+
+out:
+	return ret;
+}
+
+SEC("struct_ops/below_low")
+unsigned int below_low_impl(struct mem_cgroup *memcg)
+{
+	if (!local_config.use_below_low)
+		return false;
+
+	return need_threshold();
+}
+
+SEC("struct_ops/below_min")
+unsigned int below_min_impl(struct mem_cgroup *memcg)
+{
+	if (!local_config.use_below_min)
+		return false;
+
+	return need_threshold();
+}
+
+SEC("struct_ops/get_high_delay_ms")
+unsigned int get_high_delay_ms_impl(struct mem_cgroup *memcg)
+{
+	if (local_config.over_high_ms && need_threshold())
+		return local_config.over_high_ms;
+
+	return 0;
+}
+
+SEC(".struct_ops.link")
+struct memcg_bpf_ops high_mcg_ops = {
+	.below_low = (void *)below_low_impl,
+	.below_min = (void *)below_min_impl,
+};
+
+SEC(".struct_ops.link")
+struct memcg_bpf_ops low_mcg_ops = {
+	.get_high_delay_ms = (void *)get_high_delay_ms_impl,
+};
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/samples/bpf/memcg.c b/samples/bpf/memcg.c
new file mode 100644
index 000000000000..6d59a722f581
--- /dev/null
+++ b/samples/bpf/memcg.c
@@ -0,0 +1,327 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <string.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <errno.h>
+#include <unistd.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <getopt.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#ifndef __MEMCG_RSTAT_SIMPLE_BPF_SKEL_H__
+#define u64 uint64_t
+#endif
+
+struct local_config {
+	u64 threshold;
+	u64 high_cgroup_id;
+	bool use_below_low;
+	bool use_below_min;
+	unsigned int over_high_ms;
+} local_config;
+
+#include "memcg.skel.h"
+
+static bool exiting;
+
+static void sig_handler(int sig)
+{
+	exiting = true;
+}
+
+static void usage(char *name)
+{
+	fprintf(stderr,
+		"Usage: %s --low_path=<path> --high_path=<path> \\\n"
+		"          --threshold=<value> [OPTIONS]\n\n",
+		name);
+	fprintf(stderr, "Required arguments:\n");
+	fprintf(stderr,
+		"  -l, --low_path=PATH    Low priority memcgroup path\n");
+	fprintf(stderr,
+		"  -g, --high_path=PATH   High priority memcgroup path\n");
+	fprintf(stderr,
+		"  -t, --threshold=VALUE  The sum of 'val' PGSCAN of\n");
+	fprintf(stderr,
+		"                         high priority memcgroup in\n");
+	fprintf(stderr,
+		"                         1 sec to trigger low priority\n");
+	fprintf(stderr,
+		"                         cgroup over_high\n\n");
+	fprintf(stderr, "Optional arguments:\n");
+	fprintf(stderr, "  -o, --over_high_ms=VALUE\n");
+	fprintf(stderr,
+		"                         Low_path over_high_ms value\n");
+	fprintf(stderr,
+		"                         (default: 0)\n");
+	fprintf(stderr, "  -L, --use_below_low    Enable use_below_low flag\n");
+	fprintf(stderr, "  -M, --use_below_min    Enable use_below_min flag\n");
+	fprintf(stderr,
+		"  -O, --allow_override   Enable BPF_F_ALLOW_OVERRIDE\n");
+	fprintf(stderr,
+		"                         flag\n");
+	fprintf(stderr, "  -h, --help             Show this help message\n\n");
+	fprintf(stderr, "Examples:\n");
+	fprintf(stderr, "  # Using long options:\n");
+	fprintf(stderr, "  %s --low_path=/sys/fs/cgroup/low \\\n", name);
+	fprintf(stderr, "     --high_path=/sys/fs/cgroup/high \\\n");
+	fprintf(stderr, "     --threshold=1000 --over_high_ms=500 \\\n"
+			"     --use_below_low\n\n");
+	fprintf(stderr, "  # Using short options:\n");
+	fprintf(stderr, "  %s -l /sys/fs/cgroup/low \\\n"
+			"     -g /sys/fs/cgroup/high \\\n",
+		name);
+	fprintf(stderr, "     -t 1000 -o 500 -L -M\n");
+}
+
+static uint64_t get_cgroup_id(const char *cgroup_path)
+{
+	struct stat st;
+
+	if (cgroup_path == NULL) {
+		fprintf(stderr, "Error: cgroup_path is NULL\n");
+		return 0;
+	}
+
+	if (stat(cgroup_path, &st) < 0) {
+		fprintf(stderr, "Error: stat(%s) failed: %d\n",
+			cgroup_path, errno);
+		return 0;
+	}
+
+	return (uint64_t)st.st_ino;
+}
+
+int main(int argc, char **argv)
+{
+	int low_cgroup_fd = -1, high_cgroup_fd = -1;
+	uint64_t threshold = 0, high_cgroup_id;
+	unsigned int over_high_ms = 0;
+	bool use_below_low = false, use_below_min = false;
+	__u32 opts_flags = 0;
+	const char *low_path = NULL;
+	const char *high_path = NULL;
+	const char *bpf_obj_file = "memcg.bpf.o";
+	struct bpf_object *obj = NULL;
+	struct bpf_program *prog = NULL;
+	struct bpf_link *link = NULL, *link_low = NULL, *link_high = NULL;
+	struct bpf_map *map;
+	struct memcg__bss *bss_data;
+	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
+	int err = -EINVAL;
+	int map_fd;
+	int opt;
+	int option_index = 0;
+
+	static struct option long_options[] = {
+		{"low_path",       required_argument, 0, 'l'},
+		{"high_path",      required_argument, 0, 'g'},
+		{"threshold",      required_argument, 0, 't'},
+		{"over_high_ms",   required_argument, 0, 'o'},
+		{"use_below_low",  no_argument,       0, 'L'},
+		{"use_below_min",  no_argument,       0, 'M'},
+		{"allow_override", no_argument,       0, 'O'},
+		{"help",           no_argument,       0, 'h'},
+		{0,                0,                 0,  0 }
+	};
+
+	while ((opt = getopt_long(argc, argv, "l:g:t:o:LMOh",
+				  long_options, &option_index)) != -1) {
+		switch (opt) {
+		case 'l':
+			low_path = optarg;
+			break;
+		case 'g':
+			high_path = optarg;
+			break;
+		case 't':
+			threshold = strtoull(optarg, NULL, 10);
+			break;
+		case 'o':
+			over_high_ms = strtoull(optarg, NULL, 10);
+			break;
+		case 'L':
+			use_below_low = true;
+			break;
+		case 'M':
+			use_below_min = true;
+			break;
+		case 'O':
+			opts_flags = BPF_F_ALLOW_OVERRIDE;
+			break;
+		case 'h':
+			usage(argv[0]);
+			return 0;
+		default:
+			usage(argv[0]);
+			return -EINVAL;
+		}
+	}
+
+	if (!low_path || !high_path || !threshold) {
+		fprintf(stderr,
+			"ERROR: Missing required arguments\n\n");
+		usage(argv[0]);
+		goto out;
+	}
+
+	low_cgroup_fd = open(low_path, O_RDONLY);
+	if (low_cgroup_fd < 0) {
+		fprintf(stderr,
+			"ERROR: open low cgroup '%s' failed: %d\n",
+			low_path, errno);
+		err = -errno;
+		goto out;
+	}
+
+	high_cgroup_id = get_cgroup_id(high_path);
+	if (!high_cgroup_id)
+		goto out;
+	high_cgroup_fd = open(high_path, O_RDONLY);
+	if (high_cgroup_fd < 0) {
+		fprintf(stderr,
+			"ERROR: open high cgroup '%s' failed: %d\n",
+			high_path, errno);
+		err = -errno;
+		goto out;
+	}
+
+	obj = bpf_object__open_file(bpf_obj_file, NULL);
+	err = libbpf_get_error(obj);
+	if (err) {
+		fprintf(stderr,
+			"ERROR: opening BPF object file '%s' failed: %d\n",
+			bpf_obj_file, err);
+		goto out;
+	}
+
+	map = bpf_object__find_map_by_name(obj, ".bss");
+	if (!map) {
+		fprintf(stderr, "ERROR: Failed to find .data map\n");
+		err = -ESRCH;
+		goto out;
+	}
+
+	err = bpf_object__load(obj);
+	if (err) {
+		fprintf(stderr,
+			"ERROR: loading BPF object file failed: %d\n",
+			err);
+		goto out;
+	}
+
+	map_fd = bpf_map__fd(map);
+	bss_data = malloc(bpf_map__value_size(map));
+	if (bss_data) {
+		__u32 key = 0;
+
+		memset(bss_data, 0, sizeof(struct local_config));
+		bss_data->local_config.high_cgroup_id = high_cgroup_id;
+		bss_data->local_config.threshold = threshold;
+		bss_data->local_config.over_high_ms = over_high_ms;
+		bss_data->local_config.use_below_low = use_below_low;
+		bss_data->local_config.use_below_min = use_below_min;
+
+		err = bpf_map_update_elem(map_fd, &key, bss_data, BPF_EXIST);
+		free(bss_data);
+		if (err) {
+			fprintf(stderr,
+				"ERROR: update config failed: %d\n",
+				err);
+			goto out;
+		}
+	} else {
+		fprintf(stderr,
+			"ERROR: allocate memory failed\n");
+		err = -ENOMEM;
+		goto out;
+	}
+
+	prog = bpf_object__find_program_by_name(obj,
+						"handle_count_memcg_events");
+	if (!prog) {
+		fprintf(stderr,
+			"ERROR: finding a prog in BPF object file failed\n");
+		goto out;
+	}
+
+	link = bpf_program__attach(prog);
+	err = libbpf_get_error(link);
+	if (err) {
+		fprintf(stderr,
+			"ERROR: bpf_program__attach failed: %d\n",
+			err);
+		goto out;
+	}
+
+	if (over_high_ms) {
+		map = bpf_object__find_map_by_name(obj, "low_mcg_ops");
+		if (!map) {
+			fprintf(stderr,
+				"ERROR: Failed to find low_mcg_ops map\n");
+			err = -ESRCH;
+			goto out;
+		}
+		LIBBPF_OPTS_RESET(opts,
+			.flags = opts_flags,
+			.relative_fd = low_cgroup_fd,
+		);
+		link_low = bpf_map__attach_struct_ops_opts(map, &opts);
+		if (!link_low) {
+			fprintf(stderr,
+				"Failed to attach struct ops low_mcg_ops: %d\n",
+				errno);
+			err = -errno;
+			goto out;
+		}
+	}
+
+	if (use_below_low || use_below_min) {
+		map = bpf_object__find_map_by_name(obj, "high_mcg_ops");
+		if (!map) {
+			fprintf(stderr,
+				"ERROR: Failed to find high_mcg_ops map\n");
+			err = -ESRCH;
+			goto out;
+		}
+		LIBBPF_OPTS_RESET(opts,
+			.flags = opts_flags,
+			.relative_fd = high_cgroup_fd,
+		);
+		link_high = bpf_map__attach_struct_ops_opts(map, &opts);
+		if (!link_high) {
+			fprintf(stderr,
+				"Failed to attach struct ops high_mcg_ops: %d\n",
+				errno);
+			err = -errno;
+			goto out;
+		}
+	}
+
+	printf("Successfully attached!\n");
+
+	signal(SIGINT, sig_handler);
+	signal(SIGTERM, sig_handler);
+
+	while (!exiting)
+		pause();
+
+	printf("Exiting...\n");
+
+out:
+	bpf_link__destroy(link);
+	bpf_link__destroy(link_low);
+	bpf_link__destroy(link_high);
+	bpf_object__close(obj);
+	close(low_cgroup_fd);
+	close(high_cgroup_fd);
+	return err;
+}
-- 
2.43.0



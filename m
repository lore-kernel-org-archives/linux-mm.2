Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1003EE9410A
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 03:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E286B008C; Mon, 29 Dec 2025 22:03:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8B86B0092; Mon, 29 Dec 2025 22:03:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB436B0093; Mon, 29 Dec 2025 22:03:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4EF6B008C
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 22:03:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F137E1610E0
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 03:03:34 +0000 (UTC)
X-FDA: 84274641948.05.E67BE6B
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3790418000B
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 03:03:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aAC17qfy;
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767063813; a=rsa-sha256;
	cv=none;
	b=Kao1uvhCSh4nlvdMNx++rVIo3IqXhphqBSnUim3JornPU03XitGkMrAsxdPwEZGgpuOK/P
	hgOpg0dpuDR1lU/gbew4nibh1qs45tMLoF22XWTCEFJowVZLfhPvldWT0MsgSu6gqC4si6
	MbAE0GZXRI06eDOCJdRUUMMI6PdC5UY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aAC17qfy;
	spf=pass (imf06.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767063813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OA1xHAlX8jGoIDI7T9AdSpDDxHJZob75xO1UuERgvis=;
	b=SC2bEbL3ZguV0PU7kWSPVfrNdfgIBGJm84DHFz80/bekf2KTPjp3PPQfexz84ErHJntlS1
	WguwkHLSNLT2oMM1+K9z2Qztt5GylyHRUBTRzoYqFjgJ4Px7U+qQFNC6oYI2d49J1cPujM
	8XcC6byuv1rx1Pf2CiMKlYZ4NrWk+zM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767063810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OA1xHAlX8jGoIDI7T9AdSpDDxHJZob75xO1UuERgvis=;
	b=aAC17qfyZoQB+cS/5NwxZF0kKoblio96ZNb85829MfOGT71IaN940n0GDENv71C+XQYSPI
	2KEoG1hRmsQJxOog/B7O0R8ohrm4kfVkVW4tvjtW7u0OvYgvPkrmghEtTyWKwMAKKxwsuX
	KG7votvdbAAeUu+MAuwoQoFUBme9bU8=
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [RFC PATCH v2 3/3] samples/bpf: Add memcg priority control example
Date: Tue, 30 Dec 2025 11:02:01 +0800
Message-ID: <254767cd4874bbcd167a4a10a142be870ea64f9c.1767012332.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1767012332.git.zhuhui@kylinos.cn>
References: <cover.1767012332.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 3790418000B
X-Rspamd-Server: rspam04
X-Stat-Signature: 4no5buu6hz51tmmebi5iyb3dtg56us6o
X-HE-Tag: 1767063812-947804
X-HE-Meta: U2FsdGVkX19CUN0BI4kDwujDIsld5zqEqVBVTZbwaLgZpKx5A/Hhqb3ZKym7Hd87L5b8uoLb0dii8iF3+xWrMehXikNd99F6cXbXBSxl41OHUD6ruN3I+s92CgS7z1vfusqCDx8VXslUDz9epQP1WRgcbm5ik7+mkwjcj32RnR0NmYVFbRGosaRx5yWSdif6ufDiromGfVnGcLIiagDV4dHXp7C6dICvN/+Iiihgb2pqhWxzaVNiHSIOTKkle2xQZ/UIJc4Hv9JRVYHlluwMV+SYYHsVG7rFyXIinElDpGWGkJtQRyMuQZJ3RbAmHxCQVDRSsoeCi3LkPVYtmNwURkhsAZV9Kfd9lPvXURrtOfYvzkksKAQ9xnE3ZJRqPZmDt6ZIDa48cLdphQRPt3kqSeJMjzd/fcxzRcJFi6Khmd4/f95eaFdi0D4jkeC9mJo5EqEnucVrQKyUu7pegZnGE6eHvqj/nVHu+aTRnJQzqA0PpWWtoxox1A8oKwFG3dsDWyEWVq7IHbcyMdqqGdpHebx+g84uo7k5Ci+7diqu/2pvTUshw2sdx/8WaaDOtPuBBZ08TVHJzftZBrUXnaCfo4DI6YUQgzRqiO8dws9vxqPd2zlUw7tjvUO8srfgi/d5LYGODm089prbpxBNdF9KkBreEcmOatU7jvf1IsugVmJPs7bpbxlSPIXvgaQ41WKOmQcXjOgAr9BX/tL2GjBNgsLteFBszWukZocp+/XcGNjlgSP9HD3GMH6ouJO2y9hisUoxfg6al+FIqteAlLiGPIwlW8JE1uKvwCgjSXa2cW50BY9SRIo1cP8jyvAVSzqhMAhVtMsjaFHS2SZkF3RJBHyBO/EGatltM9zxCDEaJD/8facg+CErYim1XOyf0BV/N5dijp7KwzgDqm/De/FA4m8i1AZuA0bA0IK/cXDv9vvczojvitCylsrh4+wwdjgEfPMBdLjvSpBpjpwOpV1
 cy12R6Xs
 prL9HLheMr5YroVPhma6qNvcQyj3t/PmBn6IbPe8LFiSy0Ei3V2giqbMnD6URUyLx86AS6T+MnLUtM59HY16VpPZ8nTYuRpcRUypj5/d6+LUd8Yty7OYu0BzBXsB4tWuJG1vauu/o9BK92WYD4kLakqNsMcNOpwsKeZ37mtyhCd4osq1lBKBZrJOJbEMNJfkAV+ZbdJSimkfJFR3gUaVnnWCm8zm2xFyILoJ6nlNd0AYxv5GfnZ4nDLErLLPZJhZwhtD7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add a sample program demonstrating priority-based memory
throttling using memcg_bpf_ops struct_ops.

This sample consists of:

1. memcg.bpf.c: BPF program that monitors PGSCAN events on a
   high-priority cgroup. When page scan activity exceeds a
   threshold, it reports additional "over high" pages for a
   low-priority cgroup, causing it to be throttled.

2. memcg.c: Userspace loader that configures and attaches the
   BPF program. Takes parameters:
   - low_path: Path to low-priority cgroup
   - high_path: Path to high-priority cgroup
   - threshold: PGSCAN threshold to trigger throttling
   - over_high: Number of pages to report as over-high

Usage example:
  # mkdir /sys/fs/cgroup/high
  # mkdir /sys/fs/cgroup/low
  # ./memcg /sys/fs/cgroup/low /sys/fs/cgroup/high 100 1024

When the high-priority cgroup experiences memory pressure
(>100 PGSCAN events/sec), the low-priority cgroup will be
throttled as if it were 1024 pages over its memory.high limit.

Real-world test results on x86_64 QEMU (10 CPU, 4GB RAM):
- High-priority: 347,825 ops/sec (unaffected)
- Low-priority: 177 ops/sec (throttled by ~99.9%)

This test does not use PSI for triggering due to the
reasons discussed in:
https://lore.kernel.org/lkml/1d9a162605a3f32ac215430131f7745488deaa34@linux.dev/

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 MAINTAINERS             |   2 +
 samples/bpf/.gitignore  |   1 +
 samples/bpf/Makefile    |   9 +-
 samples/bpf/memcg.bpf.c |  95 +++++++++++++++++++
 samples/bpf/memcg.c     | 204 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 310 insertions(+), 1 deletion(-)
 create mode 100644 samples/bpf/memcg.bpf.c
 create mode 100644 samples/bpf/memcg.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 10508c90136a..91af1f28eb14 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6355,6 +6355,8 @@ F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
 F:	mm/page_counter.c
 F:	mm/swap_cgroup.c
+F:	samples/bpf/memcg.bpf.c
+F:	samples/bpf/memcg.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/bpf/prog_tests/memcg_ops.c
 F:	tools/testing/selftests/bpf/progs/memcg_ops_over_high.c
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
index 95a4fa1f1e44..6416c8aa3034 100644
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
@@ -360,6 +366,7 @@ BPF_SKELS_LINKED := $(addprefix $(obj)/,$(LINKED_SKELS))
 
 $(BPF_SKELS_LINKED): $(BPF_OBJS_LINKED) $(BPFTOOL)
 	@echo "  BPF GEN-OBJ " $(@:.skel.h=)
+	echo $(Q)$(BPFTOOL) gen object $(@:.skel.h=.lbpf.o) $(addprefix $(obj)/,$($(@F)-deps))
 	$(Q)$(BPFTOOL) gen object $(@:.skel.h=.lbpf.o) $(addprefix $(obj)/,$($(@F)-deps))
 	@echo "  BPF GEN-SKEL" $(@:.skel.h=)
 	$(Q)$(BPFTOOL) gen skeleton $(@:.skel.h=.lbpf.o) name $(notdir $(@:.skel.h=)) > $@
diff --git a/samples/bpf/memcg.bpf.c b/samples/bpf/memcg.bpf.c
new file mode 100644
index 000000000000..5c9651ec96d4
--- /dev/null
+++ b/samples/bpf/memcg.bpf.c
@@ -0,0 +1,95 @@
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
+	unsigned int over_high;
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
+	    (ctx->item != PGSCAN_KSWAPD && ctx->item != PGSCAN_DIRECT))
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
+SEC("struct_ops/memcg_nr_pages_over_high")
+unsigned int memcg_nr_pages_over_high_impl(struct mem_cgroup *memcg)
+{
+	u32 key = 0;
+	u64 *trigger_ts;
+	unsigned int ret = 0;
+
+	trigger_ts = bpf_map_lookup_elem(&trigger_ts_map, &key);
+	if (!trigger_ts || *trigger_ts == 0)
+		goto out;
+
+	u64 current_ts = bpf_ktime_get_ns();
+
+	if (current_ts - *trigger_ts < ONE_SECOND_NS)
+		ret = local_config.over_high;
+
+out:
+	return ret;
+}
+
+SEC(".struct_ops.link")
+struct memcg_bpf_ops mcg_ops = {
+	.memcg_nr_pages_over_high = (void *)memcg_nr_pages_over_high_impl,
+};
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/samples/bpf/memcg.c b/samples/bpf/memcg.c
new file mode 100644
index 000000000000..08124f08f3ad
--- /dev/null
+++ b/samples/bpf/memcg.c
@@ -0,0 +1,204 @@
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
+	unsigned int over_high;
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
+		"Usage: %s <low_path> <high_path> <threshold> <over_high>\n",
+		name);
+	fprintf(stderr, "low_path:  low priority memcgroup path.\n");
+	fprintf(stderr, "high_path: high priority memcgroup path.\n");
+	fprintf(stderr, "threshold: The sum of 'val' PGSCAN of high\n"
+			"           priority memcgroup in 1 sec to trigger\n"
+			"           low priority cgroup over_high.\n");
+	fprintf(stderr, "over_high: low_path over_high value.\n");
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
+	int low_cgroup_fd = -1;
+	uint64_t threshold, high_cgroup_id;
+	unsigned int over_high;
+	const char *bpf_obj_file = "memcg.bpf.o";
+	struct bpf_object *obj = NULL;
+	struct bpf_program *prog = NULL;
+	struct bpf_link *link = NULL, *link2 = NULL;
+	struct bpf_map *map;
+	struct memcg__bss *bss_data;
+	DECLARE_LIBBPF_OPTS(bpf_struct_ops_opts, opts);
+	int err = -EINVAL;
+	int map_fd;
+
+	if (argc < 5) {
+usage_err:
+		usage(argv[0]);
+		goto out;
+	}
+
+	low_cgroup_fd = open(argv[1], O_RDONLY);
+	if (low_cgroup_fd < 0) {
+		fprintf(stderr,
+			"ERROR: open low cgroup '%s' failed: %d\n",
+			argv[1], errno);
+		err = -errno;
+		goto out;
+	}
+
+	high_cgroup_id = get_cgroup_id(argv[2]);
+	if (!high_cgroup_id)
+		goto out;
+
+	threshold = strtoull(argv[3], NULL, 10);
+	over_high = strtoull(argv[4], NULL, 10);
+	if (!threshold || !over_high)
+		goto usage_err;
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
+		bss_data->local_config.over_high = over_high;
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
+	map = bpf_object__find_map_by_name(obj, "mcg_ops");
+	if (!map) {
+		fprintf(stderr, "ERROR: Failed to find mcg_ops map\n");
+		err = -ESRCH;
+		goto out;
+	}
+
+	opts.relative_fd = low_cgroup_fd;
+	link2 = bpf_map__attach_struct_ops_opts(map, &opts);
+	if (!link2) {
+		fprintf(stderr,
+			"Failed to attach struct ops mcg_ops: %d\n", errno);
+		err = -errno;
+		goto out;
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
+	bpf_link__destroy(link2);
+	bpf_object__close(obj);
+	close(low_cgroup_fd);
+	return err;
+}
-- 
2.43.0



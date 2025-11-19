Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94785CF2566
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FA06B002B; Tue, 18 Nov 2025 20:35:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDEE36B002C; Tue, 18 Nov 2025 20:35:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF50D6B00A0; Tue, 18 Nov 2025 20:35:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE89D6B002B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:35:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7825613A42E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:35:18 +0000 (UTC)
X-FDA: 84125638716.09.1428803
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id C08B6C000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:35:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l0cWAGhd;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763516117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8dIlCkeLmHRvfs6fUIYZ7yvGZoAG1TWr2WBwtR6cnw=;
	b=eStbCdP7UFinSS3WIjGT8vNOE8MzKXDdrcF8iSeTKvLph88bWK21t8ECKPg7LplJe/RmZ4
	LgINyta/38EA8MP4UayX5V3XIsIgxFTt/CtJWOuikoqo4FNbwYnrmc753kAZclElZsr1yZ
	JSHcNaYM6euq0nmnecVSQWPkIlL2cbk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l0cWAGhd;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763516117; a=rsa-sha256;
	cv=none;
	b=ue6PREHUHSixZiS9c51vYouKeUeWnMmXeILdfNNKySwaS6emieylFc4KCWsc/f85TgxZiz
	PHR04zsKnzufyk1YrtUApEFy0pAEEDV+conwMgQfsxyD15NH2dMQCbCf1vovxo+WYvcvRX
	RSlAJr3Um1nbWko//rR9alFf4b3fA+Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763516115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D8dIlCkeLmHRvfs6fUIYZ7yvGZoAG1TWr2WBwtR6cnw=;
	b=l0cWAGhdWRSC8NfGk4eXSNApKMWN/6jjT/zXj8aYwETERhPKAqw9nf91LKUUVCqiLM+fkK
	mo4lHL3jkthGa0LDFfBd+OXsWrDEQ5bR89bznO6SIPCzUQ0onQosC6w5/0FCn1sjQRk8+Q
	WrAPWxSBABrvy+tLp1sJdnXMjrEnfmM=
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [RFC PATCH 3/3] samples/bpf: add example memcg eBPF program
Date: Wed, 19 Nov 2025 09:34:08 +0800
Message-ID: <b470e1e2e3c1baa97a7bc6637863b3f52336ebb1.1763457705.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1763457705.git.zhuhui@kylinos.cn>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C08B6C000A
X-Stat-Signature: 7jd3z8n9guzcmpoq7m5zntap8cdrwgr5
X-Rspam-User: 
X-HE-Tag: 1763516116-857028
X-HE-Meta: U2FsdGVkX1+lCQUpA+Tl4OO1enRbGYl45Tog9OFSBuOVnMde3mzRpS4aXKYwqF1JxtlUR2LTrVvtsSyEPZUB7lZVvu7EiQIkDgA8YzySWU5YglAwsXwuffZWDD+0N+IE0KQQw5N1SeoDueSbbGAuT5IujLAnEcSfi3WqWe1yFIUlUBAH2EB2VV0wXZ/lRCWwoFnlFiqxdcbKZGIJlMjdDuCloITCbVHSbZv0LJzi8/oYMR1T7lWpuuqE0M6oi2SCiRY5n08QIr12J62y4Arvj1aTwozcSjcOJpwlZLhNQT4Lf1CKxNgwsPP5f57ThC7LbM/wE5t83pNvIHI0X/pEocCh5EH7ty/IPTfl8FFWWh2TKQwSngS/hDHOvuSZs17Po/PQM9L8PbYYrwXzr9s0xuCji0d8FF15EROiD3db7ZvI+pMX0doCCWlEghYk377KkVykQnEapFM1YVIZPuCSOGqCKnL5u4iyjk1H5pTSAx3Qpf64fx+bCW2Ci2BtDQgzkKY0t21loNpNQOTZay5xzKQmzIa0pgGoDiwqBBoxpkbCUTGL8baDi0E2E1b52ZwX8XnX6xi3sjeqWrayfwd3r6Kj1/dwPvae9BzoEXh2VZPOupAUY3IQkmyF4gbgwYVl8VA/UVXZW9LOxXkSHZeYl0ilQJJgAc4g+NS/mdbDVB+u98usBIieP3JHBKJdWux29EkFkTX7+fAO8+d3HrIedjvUC3m5PuNEDD+5HMi4Ny+M/EMO63kifYXMgchPNeCDXQ7u3uoqMKd/zE4u1N18zcsv6nyoCgNCY4SBbtlmYk1gHZuqn+fP1wwAXOHS6O/z2uLNANdeTreh4XZ7n4VZLp+u2kaSamGXEzjGQn9oNLYBQkwzmifZKEYFxNKBdXXXv/lvG9FskAmofP/tx0ef4m5uhe4LFYf93t3Nr4QQdQfZyiYQFcRfnStUrHmG2sTq4Yx8ZaoX3dNgsi8Rvv4
 vwx3zJU/
 tAb+AU9oiJ6r8tBL5lkyoJJrt4y8rrREd9rqSMh69ganOTsQ60O1jaHPDK5E5zX0In7jEW32cFa3ZN04rkoibTQrargevaMTVtADJTo68+Oe6YlehwpOPmYsqKFRxTkZGvGjm87lEVZGQnFfq675FVqIcdyt+Rqky880T6UFw8jplFoColxmnLIm6sLEySQ+c5AnTOeLUuOQEI8GUHhJWEpnJItKtNHb0MNDZpa2UjSSWCeJ9wTAUItTNlq306vpRkTJksBG2IFFgW2ZwHE8KumcTKXPtlHN31CyY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add a sample eBPF program demonstrating the new memory
controller eBPF support. This example serves as both a reference
implementation and a validation tool for the memcg eBPF
functionality.

The sample includes:

- memcg_printk.bpf.c: An eBPF program that attaches to the
  try_charge_memcg hook and prints detailed information about
  memory charging events, including:
  * Memory cgroup name
  * GFP flags and page count
  * Reclamation options
  * Affected memory cgroup (when applicable)

- memcg_printk.c: A userspace loader program that:
  * Loads the eBPF object file
  * Finds and attaches the memcg_ops struct ops
  * Keeps the program attached until interrupted
  * Provides proper error handling and cleanup

Usage:
  $ ./samples/bpf/memcg_printk

This will attach the eBPF program to the memcg charging path.
Output can be viewed via kernel trace events (e.g.,
trace_printk logs).

The program demonstrates:
- Accessing memory cgroup context fields
- Using bpf_printk for debugging and monitoring
- Proper struct ops registration via libbpf
- Integration with the kernel's BPF infrastructure

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 MAINTAINERS                    |  2 +
 samples/bpf/Makefile           |  2 +
 samples/bpf/memcg_printk.bpf.c | 30 +++++++++++++
 samples/bpf/memcg_printk.c     | 82 ++++++++++++++++++++++++++++++++++
 4 files changed, 116 insertions(+)
 create mode 100644 samples/bpf/memcg_printk.bpf.c
 create mode 100644 samples/bpf/memcg_printk.c

diff --git a/MAINTAINERS b/MAINTAINERS
index dc3aa53d2346..c8f32f7dad3f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6356,6 +6356,8 @@ F:	mm/memcontrol_bpf.h
 F:	mm/page_counter.c
 F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
+F:	samples/memcg_printk.bpf.c
+F:	samples/memcg_printk.c
 F:	tools/testing/selftests/bpf/*/memcg_ops.c
 F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 95a4fa1f1e44..d50e958fc8d5 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -37,6 +37,7 @@ tprogs-y += xdp_fwd
 tprogs-y += task_fd_query
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += memcg_printk
 
 # Libbpf dependencies
 LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
@@ -122,6 +123,7 @@ always-y += task_fd_query_kern.o
 always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
+always-y += memcg_printk.bpf.o
 
 COMMON_CFLAGS = $(TPROGS_USER_CFLAGS)
 TPROGS_LDFLAGS = $(TPROGS_USER_LDFLAGS)
diff --git a/samples/bpf/memcg_printk.bpf.c b/samples/bpf/memcg_printk.bpf.c
new file mode 100644
index 000000000000..66c87bf4cbcb
--- /dev/null
+++ b/samples/bpf/memcg_printk.bpf.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+SEC("struct_ops/try_charge_memcg")
+int BPF_PROG(handle_try_charge_memcg, struct try_charge_memcg *tcm)
+{
+	bpf_printk(
+		"memcg %s gfp_mask 0x%x nr_pages %lu reclaim_options 0x%lx\n",
+		tcm->memcg->css.cgroup->kn->name,
+		tcm->gfp_mask,
+		tcm->nr_pages,
+		tcm->reclaim_options);
+	if (!tcm->charge_done)
+		bpf_printk("memcg %s mem_over_limit %s\n",
+			   tcm->memcg->css.cgroup->kn->name,
+			   tcm->mem_over_limit->css.cgroup->kn->name);
+
+	return 0;
+}
+
+SEC(".struct_ops")
+struct memcg_ops mcg_ops = {
+	.try_charge_memcg = (void *)handle_try_charge_memcg,
+};
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/memcg_printk.c b/samples/bpf/memcg_printk.c
new file mode 100644
index 000000000000..a2c5be2415ea
--- /dev/null
+++ b/samples/bpf/memcg_printk.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <signal.h>
+#include <bpf/libbpf.h>
+
+static bool exiting;
+
+static void sig_handler(int sig)
+{
+	exiting = true;
+}
+
+static int libbpf_print_fn(enum libbpf_print_level level, const char *format, va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
+
+int main(int argc, char **argv)
+{
+	struct bpf_object *obj = NULL;
+	struct bpf_link *link = NULL;
+	struct bpf_map *map;
+	char filename[256];
+	int err;
+
+	exiting = false;
+
+	signal(SIGINT, sig_handler);
+	signal(SIGTERM, sig_handler);
+
+	libbpf_set_print(libbpf_print_fn);
+
+	snprintf(filename, sizeof(filename), "%s.bpf.o", argv[0]);
+	obj = bpf_object__open_file(filename, NULL);
+	err = libbpf_get_error(obj);
+	if (err) {
+		fprintf(stderr, "Failed to open BPF object file: %d\n",
+			err);
+		obj = NULL;
+		goto cleanup;
+	}
+
+	err = bpf_object__load(obj);
+	if (err) {
+		fprintf(stderr, "Failed to loading BPF object file: %d\n",
+			err);
+		goto cleanup;
+	}
+
+	map = bpf_object__find_map_by_name(obj, "mcg_ops");
+	if (!map) {
+		fprintf(stderr, "Failed to find struct_ops map 'mcg_ops'\n");
+		err = -ENOENT;
+		goto cleanup;
+	}
+
+	link = bpf_map__attach_struct_ops(map);
+	err = libbpf_get_error(link);
+	if (err) {
+		fprintf(stderr, "Failed to attach struct ops: %d\n",
+			err);
+		link = NULL;
+		goto cleanup;
+	}
+
+	printf("Press Ctrl+C to exit...\n");
+
+	while (!exiting)
+		sleep(1);
+
+	printf("Bye!\n");
+
+cleanup:
+	if (link)
+		bpf_link__destroy(link);
+	if (obj)
+		bpf_object__close(obj);
+
+	return err;
+}
-- 
2.43.0



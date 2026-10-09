Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEED1CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69A236B009B; Fri,  9 Oct 2026 07:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FCEA6B0099; Fri,  9 Oct 2026 07:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4AE6B009B; Fri,  9 Oct 2026 07:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0666B0096
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:23:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D273A031F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:40 +0000 (UTC)
X-FDA: 85302852600.01.1C84F2F
Received: from mail-m1602365216.xmail.ntesmail.com (mail-m1602365216.xmail.ntesmail.com [160.236.52.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id 06E801C000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.16 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/CXQboH7cXpaTmyoa7p4XMmUav+OfEXgXdikTuFLliU=;
	b=n0gimE+dPzwkMjg8gGgWAsaOFP932HuTJYco4WQMs59yaE1dnWugjuWp1saISsmtJvxos3
	VUjv9NS6xeB9iHmHPYy85b9pXUcciT8pCn0Pjst6w6xNVQrCJ36lBGE9eKqKdV7+SXc6CN
	L0NOLT6TKly1hTAGmirQGIjWrSeD9jE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545019;
	b=WqIvTGLQ+mjxjgPTNz8VbnsE3a87CTHvdytznz9sfpm+hhVnvBEZ8I9iHOhMExrRUzBtaQ
	3PA3UCo0nSxQRUcxU+dMBqO+g68grN4GE1e6Z29gfJRb4XQFdalVW/ycY2N1IuSXQhpc7I
	Jj7T4kf1NDU/sx00HDF+g2681FBgiPw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.16 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1fe2901a8;
	Fri, 9 Oct 2026 19:23:32 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	shuah@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH 6/6] selftests/bpf: add tests for the page_owner bpf_iter target
Date: Fri,  9 Oct 2026 19:23:08 +0800
Message-Id: <20261009112308.240769-7-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261009112308.240769-1-zhen.ni@easystack.cn>
References: <20261009112308.240769-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa12067716e0229kunmd33b3e054cb292
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCQx8fVktPGE5JGR9KQhkZH1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 06E801C000B
X-Rspam-User: 
X-Stat-Signature: mxga8y8ag94js3618pdt7i1ct6kxansb
X-HE-Tag: 1791545017-715632
X-HE-Meta: U2FsdGVkX1+QcoHBEEajQh8HRljCB4+kWmWZz3ovkl4O/Y2z6OyextsVcnbaxEDsKrNyX5tKKRSPrCqtgWLZqvIojdUnDscX0EX7bhx8/XQ9EGuicfgHi6LI9CVDdok8ublYq983lmIJaV4VTDtzx1r6ZLjywzRQ7PqI/Tsz9delU/T9AlEyNCn4EQppStK8C4hoAvr9W++EcPesfPc/cbOVKy0nBezQZ6Paj+YPHQxkuTFOQSK6lSu6F103TBVMhnlv8F1J31nRoMLZJfXmTFv7rU6S7eWPBfUvpHkxI4UFEzu4y/SzMhIs9suvK2MhqBeaVcj7tn7adACq+NzWsgrRhr/ix2Un7w4FXgzOnC8hf4RFHE+m8E8EGugfV2HxtMi92p8g0U9WHWsBap21Vap27fc+ICd6NdHc5J4XP1D0bqFyGw1008R0MR39Ym4k+W/oVgq8WzcaDl+Q0HiG8ee78R/vkZy6fosbk3wttvLK0KPaq79gKdsbd6mQlXwzRBmCICz+ynP/O7zW819durNiBU5lHq1bT701DuIjoX++D0l36Y+Jr3kwYLLObEQ/OBYINUmpgLPC0XN05s7zEb3+F8Aozi/tPc2pmd1zTjPytlXOK2ky6v9AFyj7KTbbZcMSSlm7ZkHE+UFmzhoYT5ITOVP/ft8KfhkUqZetbO46k+9H6o7T/CCsuuLr5/DiVqzyKfxMR9rgZiUqX6393repGMf0+YV1vGlowXo7D1HdORkLiJcETyLT9pj/y2dYNDJnirzpK1VGNK9mMMBUDWU/Z86EiqE5z4v7I0BvCrRlQiRIpf+tbMnO38/k0o9L+bvrEExxq10eDLFIxVKgGPyOLmLujiU2/8/N0AvcLzG/f+dxDqhYAYhY2xj7nFQqEqfRXNhsdNFGLhZkpeSTB/r0cWKcYhkJIKTKLDdUNeZpJLRwlYW/WHhTIt9iOgl5X3GNZXFR5MOdvhUnLnm
 L1J5LfNy
 lpRVqDt1oTJ5JYRQGPunW3dUwwp3LkjifWu34GghHPPN4k8p4hXgUKDUTF3lPHI4JKjy+o0XE/oYzYo+11rCQ66HwvqS/QQpyo6MdxrWwmAlgJQk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sleepable BPF program and a userspace runner covering the seq_file
and open-coded page_owner iterators and the get_nid, stack_snprint and
get_memcg_info kfuncs. The test checks:

  - seq_file walk, unfiltered and pid-filtered: records read back from
    the iterator fd match the lines the program printed.
  - open-coded iterator parity with the seq path.
  - the kfuncs' contracts: valid nid per page, a non-empty stack
    trace, and memcg classification.

Skipped when debugfs page_owner is unavailable.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 .../bpf/prog_tests/page_owner_iter.c          | 173 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_page_owner.c | 161 ++++++++++++++++
 2 files changed, 334 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c

diff --git a/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c b/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
new file mode 100644
index 000000000000..a621712272bc
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 */
+
+#include <test_progs.h>
+#include "bpf_iter_page_owner.skel.h"
+
+#define DEBUGFS_PAGE_OWNER	"/sys/kernel/debug/page_owner"
+
+static bool page_owner_available(void)
+{
+	return access(DEBUGFS_PAGE_OWNER, R_OK) == 0;
+}
+
+/* Count link_fd output lines; -1 on error. */
+static long iter_record_count(int link_fd)
+{
+	char *line = NULL;
+	size_t len = 0;
+	long count = 0;
+	int iter_fd, err;
+	FILE *f;
+
+	iter_fd = bpf_iter_create(link_fd);
+	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
+		return -1;
+
+	f = fdopen(iter_fd, "r");
+	if (!f) {
+		close(iter_fd);
+		return -1;
+	}
+	while (getline(&line, &len, f) > 0)
+		count++;
+	err = ferror(f);
+	free(line);
+	fclose(f);
+	return err ? -1 : count;
+}
+
+/* Validate bpf_page_owner_get_memcg_info() results from the open-coded run. */
+static void check_memcg_skel(struct bpf_iter_page_owner *skel)
+{
+	fprintf(stderr,
+		"memcg: seen=%u charged=%u online=%u nodata=%u notsup=%u bad=%u first='%s' name='%s' flags=%u\n",
+		skel->bss->memcg_seen, skel->bss->memcg_charged,
+		skel->bss->memcg_online, skel->bss->memcg_nodata,
+		skel->bss->memcg_notsup, skel->bss->memcg_bad,
+		skel->bss->memcg_first_path, skel->bss->memcg_first_name,
+		skel->bss->memcg_first_flags);
+
+	if (!ASSERT_GT(skel->bss->memcg_seen, 0, "memcg_seen_gt_0"))
+		return;
+
+	/* all -EOPNOTSUPP: CONFIG_MEMCG is off */
+	if (skel->bss->memcg_notsup == skel->bss->memcg_seen) {
+		ASSERT_EQ(skel->bss->memcg_bad, 0, "memcg_stub_invariants");
+		return;
+	}
+
+	if (!ASSERT_EQ(skel->bss->memcg_bad, 0, "memcg_kfunc_invariants"))
+		return;
+
+	/* Every call is either charged or nodata */
+	if (!ASSERT_EQ(skel->bss->memcg_charged + skel->bss->memcg_nodata,
+		       skel->bss->memcg_seen, "memcg_ret_classified"))
+		return;
+
+	if (!skel->bss->memcg_first_saved)
+		return;
+
+	if (!ASSERT_EQ(skel->bss->memcg_first_path[0], '/',
+		       "memcg_first_path_abs"))
+		return;
+
+	if (skel->bss->memcg_first_name[0])
+		ASSERT_OK_PTR(strstr(skel->bss->memcg_first_path,
+				    skel->bss->memcg_first_name),
+			      "memcg_name_in_path");
+}
+
+void serial_test_page_owner_iter(void)
+{
+	struct bpf_iter_page_owner *skel = NULL;
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
+	long iter_count, unfiltered_count, oc_diff, pid;
+	unsigned int printed_before;
+	int link_fd, prog_fd;
+
+	if (!page_owner_available()) {
+		test__skip();
+		return;
+	}
+
+	skel = bpf_iter_page_owner__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "bpf_iter_page_owner__open_and_load"))
+		return;
+
+	/* --- seq file iterator: unfiltered run --- */
+	skel->bss->filter_en = 0;
+
+	if (!ASSERT_OK(bpf_iter_page_owner__attach(skel), "skel_attach"))
+		goto destroy;
+
+	link_fd = bpf_link__fd(skel->links.dump_page_owner);
+	iter_count = iter_record_count(link_fd);
+	if (iter_count < 0)
+		goto destroy;
+	unfiltered_count = iter_count;
+
+	fprintf(stderr, "iter_count=%ld printed_lines=%u total_seen=%u\n",
+		iter_count, skel->bss->printed_lines, skel->bss->total_seen);
+
+	ASSERT_GT(iter_count, 0, "unfiltered_lines_gt_0");
+
+	ASSERT_EQ((long)skel->bss->printed_lines, iter_count,
+		  "lines_match_printed");
+
+	/* unfiltered: every visited page is printed, so the two must match */
+	ASSERT_EQ(skel->bss->total_seen, skel->bss->printed_lines,
+		  "unfiltered_all_printed");
+
+	/* --- seq file iterator: pid-filtered run --- */
+	pid = getpid();
+	skel->bss->filter_en = 1;
+	skel->bss->filter_pid = (pid_t)pid;
+
+	/* printed_lines is cumulative across runs: compare the delta */
+	printed_before = skel->bss->printed_lines;
+	iter_count = iter_record_count(link_fd);
+	if (iter_count < 0)
+		goto destroy;
+
+	fprintf(stderr,
+		"pid=%ld iter_count=%ld printed_delta=%u\n",
+		pid, iter_count, skel->bss->printed_lines - printed_before);
+
+	ASSERT_GT(iter_count, 0, "filtered_lines_gt_0");
+	ASSERT_EQ(skel->bss->printed_lines - printed_before, iter_count,
+		  "filtered_printed_match");
+
+	/* --- open-coded iterator parity --- */
+	prog_fd = bpf_program__fd(skel->progs.scan_open_coded);
+
+	ASSERT_OK(bpf_prog_test_run_opts(prog_fd, &opts), "prog_test_run");
+	fprintf(stderr,
+		"open_coded_seen=%u nid_seen=%u first_nid=%d "
+		"stack_bytes=%u stack=[\n%s]\n",
+		skel->bss->open_coded_seen, skel->bss->nid_seen,
+		skel->data->first_nid, skel->bss->stack_bytes,
+		skel->bss->stack_text);
+
+	/* same eligibility as the seq path: counts must be close */
+	ASSERT_GT(skel->bss->open_coded_seen, 0, "oc_seen_gt_0");
+	oc_diff = (long)skel->bss->open_coded_seen - unfiltered_count;
+	if (oc_diff < 0)
+		oc_diff = -oc_diff;
+	ASSERT_LE(oc_diff, unfiltered_count / 100 + 64,
+		  "oc_seen_close_to_iter");
+
+	/* the nid kfunc returned a valid node for every page */
+	ASSERT_EQ(skel->bss->nid_seen, skel->bss->open_coded_seen,
+		  "nid_valid_all");
+	ASSERT_GE(skel->data->first_nid, 0, "first_nid_valid");
+
+	ASSERT_GT(skel->bss->stack_bytes, 0, "stack_snprint_ok");
+	ASSERT_OK_PTR(strstr(skel->bss->stack_text, "+0x"), "stack_frames");
+	ASSERT_OK_PTR(strchr(skel->bss->stack_text, '\n'), "stack_lines");
+
+	check_memcg_skel(skel);
+
+destroy:
+	bpf_iter_page_owner__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c b/tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c
new file mode 100644
index 000000000000..fada6a314a15
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 */
+
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") = "GPL";
+
+__u32 filter_en;
+__u32 filter_pid;
+__u32 total_seen;
+__u32 printed_lines;
+
+__u32 open_coded_seen;
+__u32 nid_seen;
+__s32 first_nid = -1;
+char stack_text[2048];
+__u32 stack_bytes;
+
+__u32 memcg_seen;
+__u32 memcg_charged;
+__u32 memcg_online;
+__u32 memcg_nodata;
+__u32 memcg_notsup;
+__u32 memcg_bad;
+__u32 memcg_first_saved;
+__u32 memcg_first_flags;	/* bit0 is_online, bit1 is_kmem */
+__u32 memcg_first_path_len;
+char memcg_pathbuf[4096];
+char memcg_first_path[4096];
+char memcg_first_name[80];
+
+#define MEMCG_ENODATA 61
+#define MEMCG_EOPNOTSUPP 95
+
+#define MEMCG_F_ONLINE	(1 << 0)
+#define MEMCG_F_OBJCG	(1 << 1)
+
+extern int bpf_iter_page_owner_new(struct bpf_iter_page_owner *it) __ksym;
+extern struct page_owner_scan *
+bpf_iter_page_owner_next(struct bpf_iter_page_owner *it) __ksym;
+extern void bpf_iter_page_owner_destroy(struct bpf_iter_page_owner *it) __ksym;
+extern int bpf_page_owner_stack_snprint(depot_stack_handle_t handle,
+					char *buf, u32 buf_size) __ksym;
+extern int bpf_page_owner_get_nid(struct page_owner_scan *scan) __ksym;
+extern int bpf_page_owner_get_memcg_info(struct page_owner_scan *scan,
+					 struct memcg_info *info,
+					 char *buf, u32 size) __ksym;
+
+static __u32 copy_str(char *dst, const char *src, const __u32 max)
+{
+	__u32 i = 0;
+
+	while (i + 1 < max && src[i]) {
+		dst[i] = src[i];
+		i++;
+	}
+	dst[i] = '\0';
+	return i;
+}
+
+/*
+ * Exercise bpf_page_owner_get_memcg_info() until 32 pages charged to an
+ * ONLINE memcg have been seen, checking its per-return contract:
+ *  - 0:          buf holds an absolute cgroup path;
+ *  - -ENODATA:   buf was NUL-terminated;
+ *  - -EOPNOTSUPP: counted (CONFIG_MEMCG is off);
+ *
+ * The first online charged sample is saved for userspace to print and
+ * cross-check (name vs basename of path).
+ */
+static void check_memcg(struct page_owner_scan *scan)
+{
+	static struct memcg_info info;
+	int err;
+
+	err = bpf_page_owner_get_memcg_info(scan, &info, memcg_pathbuf,
+					    sizeof(memcg_pathbuf));
+	memcg_seen++;
+
+	if (err == 0) {
+		memcg_charged++;
+
+		if (memcg_pathbuf[0] != '/') {
+			memcg_bad++;
+			return;
+		}
+
+		if (!info.is_online)
+			return;
+		memcg_online++;
+
+		/* keep the first online sample for userspace */
+		if (!memcg_first_saved) {
+			memcg_first_path_len = copy_str(memcg_first_path,
+							memcg_pathbuf,
+							sizeof(memcg_first_path));
+			copy_str(memcg_first_name, info.name,
+				 sizeof(memcg_first_name));
+			memcg_first_flags = MEMCG_F_ONLINE |
+					    (info.is_kmem ? MEMCG_F_OBJCG : 0);
+			memcg_first_saved = 1;
+		}
+	} else if (err == -MEMCG_ENODATA) {
+		memcg_nodata++;
+		if (memcg_pathbuf[0] != '\0')
+			memcg_bad++;
+	} else if (err == -MEMCG_EOPNOTSUPP) {
+		memcg_notsup++;
+		if (memcg_pathbuf[0] != '\0')
+			memcg_bad++;
+	} else {
+		memcg_bad++;
+	}
+}
+
+SEC("syscall")
+int scan_open_coded(const void *ctx)
+{
+	struct bpf_iter_page_owner it;
+	struct page_owner_scan *scan;
+
+	bpf_iter_page_owner_new(&it);
+
+	while ((scan = bpf_iter_page_owner_next(&it))) {
+		open_coded_seen++;
+		if (bpf_page_owner_get_nid(scan) >= 0)
+			nid_seen++;
+		if (memcg_online < 32)
+			check_memcg(scan);
+		/* grab the stack of the 100th page for userspace to check */
+		if (open_coded_seen == 100) {
+			first_nid = bpf_page_owner_get_nid(scan);
+			if (scan->po_snap.handle)
+				stack_bytes = bpf_page_owner_stack_snprint(
+					scan->po_snap.handle,
+					stack_text, sizeof(stack_text));
+		}
+	}
+	bpf_iter_page_owner_destroy(&it);
+	return 0;
+}
+
+SEC("iter/page_owner")
+int dump_page_owner(struct bpf_iter__page_owner *ctx)
+{
+	struct page_owner *po = ctx->po;
+
+	if (!po)
+		return 0;
+
+	total_seen++;
+
+	if (filter_en && po->pid != (pid_t)filter_pid)
+		return 0;
+
+	BPF_SEQ_PRINTF(ctx->meta->seq, "pfn %llu pid %d comm %s\n",
+		       ctx->pfn, po->pid, po->comm);
+	printed_lines++;
+	return 0;
+}
-- 
2.20.1



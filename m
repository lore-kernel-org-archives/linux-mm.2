Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C404CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A67156B0099; Tue, 13 Oct 2026 08:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3DD76B009D; Tue, 13 Oct 2026 08:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B0F6B009E; Tue, 13 Oct 2026 08:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65B346B0099
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:21:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD47F140B38
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:57 +0000 (UTC)
X-FDA: 85317514674.12.B6D7EAF
Received: from mail-m93247.xmail.ntesmail.com (mail-m93247.xmail.ntesmail.com [103.126.93.247])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7DDD72000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791894116;
	b=HFT8uhgwg7GJnll2T10Z0EXL1l0UIfd/oWO86xEKqkn2J6idDH88ea0DJN2IBaKjR1xbIT
	Ch1mheJwLTlCGEr4/c15mdLI9d8lZUQj+7xpKY1qm9sEDRvrLEvC8jbjctMErwNs/ZgyYT
	cSroKDzDNSyNRfPvraPec5Ay1ibz2O4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791894116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6XI3y9KuLL2Kfs83HyG7omnt4X3T5hQtHddJQxCAy9s=;
	b=GdOBqF66ZpuW7ZDgMWnZYbmU2rAUauDHJPksy4VuH1WgQ+0jwDDnaJCPjbwTbLohDxH67H
	2vWa1zHUkKC1/DWAWp/6Pzvfdm/SnJvRovMu6ThW0mbtwt20C4W7nhEASmrZZiCOGoizpW
	BbVRcYkylAn1UlUvR29BAam3zkD7b4Y=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 200407ef4;
	Tue, 13 Oct 2026 20:21:50 +0800 (GMT+08:00)
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
Subject: [PATCH v2 6/6] selftests/bpf: add tests for the page_owner bpf_iter target
Date: Tue, 13 Oct 2026 20:21:25 +0800
Message-Id: <20261013122125.843451-7-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261013122125.843451-1-zhen.ni@easystack.cn>
References: <20261013122125.843451-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1353642440229kunm0bc94a6a526a
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGR9MVhkfSU8dS04eGUNDGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: rs8mzpwzhbiornsnckd73g6fiex1shku
X-Rspamd-Queue-Id: 7DDD72000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791894115-417414
X-HE-Meta: U2FsdGVkX19F9lmU9FR/Iq7S2p++xMHgyo79/ukml8oLnQWX9H+onMJ/Wjw6tKguSp3UnbQvxpnQQMMQpRJ5w3aLwqcqNK9ReAT/ZP11j2HsSLqznj58tkVLB+ui7zxwwAjTgK4HKzQTkBwrPPo0JlA6PgL8IHMh4Yc9g/aIgQ7gEXududdeUbsykLrVFv8P/d2KAL8QtvUI2pe85a2VAMMtGA2T+zkr5OVCd4dTKc6Lx1V2t9PtODXV7jl7WwXVVIC3TT+/LOFNmKCLeb0o1OPM08uutUisYXJbSZrT/kS692sNwDHY8+WUVyNORRUftg5rbO6X+bbfUqfZlX72OYDfJ70Q3N0RBP8guOCs4aZ/vjT8YHabI2lAWCM+BK3kjtro5KoB7PaDB9YmUywtvfnuBnEXnU41/Mhi/zDeqq8NVdgiQx3RuRaObsTbMkItiMUZ6p+LJ+qZBgKtfg50iznluawx4RIClqYlEfFYkVsjbjnv2GvGd+d/yKZr1mbyuQ0fIr2VsbcdVOTnyai71kc+gi5I2S6f9RWsZH5m3vEQ7fgNTueGNgmIq6w1CzoTt9Q5WauBkcvlwvmEV6ulChvwUqsz6h9jyb7kaZMdgjoGFZFJdR+FV0bwhUAOnv8siN5f0W0VG3RGTJ9kqJIU3uwZ5l/9MUub8DZFlcN8dortEde5vQ4AodN3s0dTgXQ0JEYfFA7r3akQb8/oQiLL9FUwYJcJyIc3ldCy5AzAVPAASBAqaq6QwHOYFBUDevS49wNNQ+nTNEKe3i9E0Y825NmSamMSTyUse3TWaLGS59Ic23Qmpe237kH7U1fHEGX5/2OjfvNOSuBAHSq+YnUS0+wtzUXDFi34K5juEMovYQ6Z8IAARduXNoZ4EG7yfT12a/968F//p+718YPsfaPfikxa7w0UHMSdzHTQ7ZGlxSlxRQVl73RhggRY7drpqT2TjPU6PelAIuPkqSvkpnm
 YIC9yjK4
 u34GVaPiA0t7kR60zJKiZYrHVArHf3maesMSrBUgfwfGrLYXAHrn5MGt/twN3gKB98t0ztyPaCxDTDTXK+644zbObbPA6gG/UpzDRHRxSkARf+0OQcwd7/Zk3ACLvMnF1mMEgdkEZcX00qMSOZGux1ctnfp4H2l3RUfHD3aaHUAgfJBl/dz0ftUmW/J0umXx7Qx6ElbjR9qlQQ1OfQRwYTERxlKxbFW340W04Xh0+U4VgA7FzpCF0qSPVlJkxR2P2hMzUL+tIcwu/6b0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sleepable BPF program and a userspace runner covering the seq_file
and open-coded page_owner iterators. The test checks:

  - seq_file walk, unfiltered and pid-filtered: records read back from
    the iterator fd match the lines the program printed.
  - open-coded iterator parity with the seq path.
  - the kfuncs' contracts: a non-empty stack trace, and memcg
    classification.

CONFIG_PAGE_OWNER is enabled in the bpf selftests config so the
program's page_owner BTF types are available. Skipped when debugfs
page_owner is unavailable.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v2:
- Drop the get_nid kfunc coverage.
- Enable CONFIG_PAGE_OWNER in the bpf selftests config.

v1: https://lore.kernel.org/linux-mm/20261009112308.240769-7-zhen.ni@easystack.cn/
---
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/page_owner_iter.c          | 193 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_page_owner.c | 159 +++++++++++++++
 3 files changed, 354 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index ea7044f30adc..731bc3d79881 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -136,3 +136,5 @@ CONFIG_SMC_HS_CTRL_BPF=y
 CONFIG_DIBS=y
 CONFIG_DIBS_LO=y
 CONFIG_PM_WAKELOCKS=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_PAGE_OWNER=y
diff --git a/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c b/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
new file mode 100644
index 000000000000..3684ca308935
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/page_owner_iter.c
@@ -0,0 +1,193 @@
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
+	int iter_fd;
+	FILE *f;
+
+	iter_fd = bpf_iter_create(link_fd);
+	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
+		return -1;
+
+	f = fdopen(iter_fd, "r");
+	if (!ASSERT_OK_PTR(f, "fdopen")) {
+		close(iter_fd);
+		return -1;
+	}
+
+	for (;;) {
+		if (getline(&line, &len, f) > 0) {
+			count++;
+			continue;
+		}
+		if (!ferror(f))
+			break;		/* clean EOF */
+		/*
+		 * bpf_seq_read() returns -EAGAIN when a chunk scanned.
+		 * Not an error, just retry the read.
+		 */
+		if (errno == EAGAIN) {
+			clearerr(f);
+			continue;
+		}
+		ASSERT_OK(errno, "iter_read");
+		count = -1;
+		break;
+	}
+
+	free(line);
+	fclose(f);
+	return count;
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
+		printf("%s:SKIP:page_owner debugfs unavailable "
+		       "(CONFIG_PAGE_OWNER + page_owner=on)\n", __func__);
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
index 000000000000..be2261b713ea
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c
@@ -0,0 +1,159 @@
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
+extern int bpf_page_owner_stack_snprint(struct page_owner_scan *scan,
+					char *buf__uninit, u32 buf__sz) __ksym;
+extern int bpf_page_owner_get_memcg_info(struct page_owner_scan *scan,
+					 struct memcg_info *info__uninit,
+					 char *buf__uninit, u32 buf__sz) __ksym;
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
+		if (scan->nid >= 0)
+			nid_seen++;
+		if (memcg_online < 32)
+			check_memcg(scan);
+		/* grab the stack of the 100th page for userspace to check */
+		if (open_coded_seen == 100) {
+			first_nid = scan->nid;
+			if (scan->po_snap.handle)
+				stack_bytes = bpf_page_owner_stack_snprint(
+					scan, stack_text, sizeof(stack_text));
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



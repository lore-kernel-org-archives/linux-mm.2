Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D4F8606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAC346B06CB; Wed, 21 Oct 2026 07:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83456B06CD; Wed, 21 Oct 2026 07:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99DA6B06CE; Wed, 21 Oct 2026 07:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0DE6B06CB
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:25:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 331A6804A1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:25:05 +0000 (UTC)
X-FDA: 85346401770.12.4249678
Received: from mail-m609.netease.com (mail-m609.netease.com [210.79.60.9])
	by imf22.hostedemail.com (Postfix) with ESMTP id D12EFC0009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:25:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.9 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792581903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JwksEVSehb/mfsR/dwCZxF1qX9fjT9KcXaTcFo9jDRc=;
	b=AlWmb1TGxsstiBUqHd+O9qwNMpnO0zO+JBAeT+WhNY9J5CASbhcStkl8YLeJkBHjyJoK4a
	puaV15QpvAKH2L2OVYjSAzlLxwOTW6Niaaf0c3RM+3BZjclHlA8LX7nySG20QgDB2BKkaz
	VkOxeWMveKZH11UIwjWRqv2jIceqxI4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.9 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792581903;
	b=8AqnoO2HgdfCms9JgdunGFam07iMvJjcVlb7AtA4ocCqcBMhtaqKfg2K+FIAd59MWO9kg6
	og3unocR2y0xRpyQtmQCy1VRanr4QpWElbDJiLBCXSrqjkmZsltxJ+FwsC3m6D1TEiH437
	2GKdfBzfjrKb8wTKXCw/a65g/QTC5fQ=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 204f151b0;
	Wed, 21 Oct 2026 19:24:58 +0800 (GMT+08:00)
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
Subject: [PATCH v3 7/7] selftests/bpf: add tests for the page_owner bpf_iter target
Date: Wed, 21 Oct 2026 19:24:37 +0800
Message-Id: <20261021112437.1799213-8-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261021112437.1799213-1-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa15e3510440229kunme08c1fd526acf5
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTBgZVk9PTUhCSEseQ09LHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D12EFC0009
X-Stat-Signature: 1me5dt56czs9g4qqj7qger31983eg7hu
X-Rspam-User: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792581902-511499
X-HE-Meta: U2FsdGVkX19fc7B8sOvdGwN8BN4m2qltyeqArsRoaOZHraPUOEyEDqK46SgcN3ZujkewzVf73k+JV13nKHSD6MtNdHbBzQ/uEKGQXGavLxEwmz177odD4oJnpducoADEVRYQTsdWt6R37QajaOftXzhq8/rH6iLWBNYRNch08cJJ/ie0BxW8ZQHSNW040mfUWbaS6/OuikePR2nQ1WK8bZ5k/wI60k7HxmtHTin0V1GPPUr3hE/SPjH/5u8IG6rYOdWta12vuyalhSMMhuGqxkgG9/QrAiOolkknnIq/e8Mn2DUzyCxoEZTq9Fz6exrH6Os6U35cn5EH0y2L3/uN9Ye0hRjG/PlUwwjiPFjU92cm+46UNiZnOOMnpwN/nJabVqFK7KIZ56cFZFqrAMqPdhm6u5Ogo5PokXh5XGPhE6eLEIK1SFIoxVuLIQTeRXDoPUqVuMLne6tc0zCdImKfoHtVUazVUqeNThMW/enO/NoLJS+dvW40IwHcoZ+sWsOthr3ll3Y0k2cT0Enq2Pa74xkcQUgQCCDKWvTqsQy0SbwQZhBD/ZeXChwBFpQcu7s/a3mia3DEWRcHVJYxK0Oxl9aJqqsm8LxKaKhiX4PoBtWjo7efO2n5yMurLYTfmajG0lik1xIR2VOjpelts9qCx+LoOvUJbwFADoM3Gk+O7O7svvRjISRfRtniF3uKaJCalLj+JvFPc9tatHo9mgzI6C6ZcXWfZyGuWkmaaCVFGYB1FfSN9kV2+y9fAxuuiFlWehdpLpERz6Tkj3wH08CQmy66btwdbb3oEnrS0WzHFazAeAzpZb65dQsSDCvsBweFCJtGQoNgMqSaJFEB8Fp5i3zhNPi/x5BdnpIvT9Ol591BfE5xCufi1mHrQ1YcuhEQF6FHUd/G6fW4K4vw9v8eaLRUev2QZamVX8nnyhcMBtHnq/V8OsLNE1wBuEiHHqVsxgl5S63AgCzI1yFh0Ou
 OqtSxMWx
 VhBuT+XeOFV7l25xLkZZ6JGsC0/qszCp8wVPT2tBCCep8BDiBAlXOtH4HliFwn8AXp6THPLnLpHOndoK7LQStgwo9MfzoWvRqrfqJLcW3yqxgryCg7noKNjOSu/0Kgcw57Ju+wn6ZGcjitatUwPCA+Ekij9GlWKLgtd3FXySD+YyIdJEgygZ3Wseahfcmx6vfIU/jX6LgHFfvFhoE4WM2cV4C16FdN8YdIvZ9FTvuV5icbYhFkqu00EkfQGklsIL01YKO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Changes in v3:
- Check the ENODATA/EOPNOTSUPP instead of local macros.

Changes in v2:
- Drop the get_nid kfunc coverage.
- Enable CONFIG_PAGE_OWNER in the bpf selftests config.

v2: https://lore.kernel.org/linux-mm/20261013122125.843451-7-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20261009112308.240769-7-zhen.ni@easystack.cn/
---
 tools/testing/selftests/bpf/config            |   2 +
 .../bpf/prog_tests/page_owner_iter.c          | 193 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_page_owner.c | 157 ++++++++++++++
 3 files changed, 352 insertions(+)
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
index 000000000000..1cd99956aff3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_page_owner.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 */
+
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <errno.h>
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
+	} else if (err == -ENODATA) {
+		memcg_nodata++;
+		if (memcg_pathbuf[0] != '\0')
+			memcg_bad++;
+	} else if (err == -EOPNOTSUPP) {
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



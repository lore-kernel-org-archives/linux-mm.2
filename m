Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3A8606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 18:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=bphzNDuF
Received: by kanga.kvack.org (Postfix)
	id 0A25C6B0757; Wed, 21 Oct 2026 14:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D7B6B075A; Wed, 21 Oct 2026 14:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1446B075B; Wed, 21 Oct 2026 14:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5C5D6B0757
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:11:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4480CA0652
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:11:19 +0000 (UTC)
X-FDA: 85347425478.26.4A29593
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6A03B80006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:11:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=bphzNDuF;
	spf=pass (imf02.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792606277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OsbhucexF+rcBAfrmOODWfn/JuMdIRafkiiNr+d0yZw=;
	b=5A8SrYLAYCjYgy9BIpUi3p1TW0XDnM8Wt+6vvLuwCrrmrRY8wkFPoCCwH3l4x7qQacH+X6
	QOKJuI6XvZnMMDLHoF+524qDIn0YXmtK1m9QabgLDdas3lstvgQnsuTmGJdvP+tN7cqDfX
	K8eUF78BZTkWVJtMAqpvISfE719scyw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=bphzNDuF;
	spf=pass (imf02.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792606277;
	b=xvEdm5CKkf0gsTSfpJudzY5Zb+YZYC2LcisgkNGV9jB0ug7Ax+PM8jeek6rCxGm6p1FChc
	Tty/F8hoI7jTXHB0W6jWd6+50GfQqFCM4gPPlNWhRp+Bypmsz7/Rh6Q8gPBZOlpKgAiNGc
	1/tuVV4Gd54XiENWr/Pd9Wqjr9yylXk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=OsbhucexF+rcBAfrmOODWfn/JuMdIRafkiiNr+d0yZw=; b=bphzNDuFUs70GthFHdh
	VBWynZ5FxsGz8H4TEAMcQbU66HWmWkxqvBKaBHRMr5N/qcZVhuXAeMxThsyY+8trgi4n8eVV3KAoF
	3CRXP4gGNAMAG7UXd86ASLhrnylNtfHdUqGtO2o8L8qDVaZ8xTr56LCsNkqg7KDWkgQuLKQT33DSi
	Fnkt3VcWjQCQGhRQQTURXt0Pk7vNjujYMY9JM0WFYt06lRNoBZHP2Nz4RKnu820DwqJt8ESeQOHrZ
	7p8hXfJKPMuubxsW3/0y0V087C8afnPWHHHwXvgh+2q93m22pJZ9hgQWUNpxRv1aj7izo4U5RIesJ
	8jBspQL3QkZFdbQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xJaif-00ANvl-3C;
	Wed, 21 Oct 2026 20:11:04 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 21 Oct 2026 20:10:54 +0200
Subject: [PATCH 2/2] selftests/mm: test fork of a device DAX PUD
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-2-8bd88551f9be@virtuozzo.com>
References: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
In-Reply-To: <20261021-vstor-150143-copy_huge_pud-folio-refcount-v1-0-8bd88551f9be@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6368;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=BeNA8ETryoYJiw28wyqlB0gBoEmrqSoabqrZQEIon90=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq2QA4NM4cK0BSXBvs719jhs+keVlGRHdHBjcML
 wTBgkR55mCJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatkAOAAKCRBRlgpH+WFc
 KtfAD/9QxPEoE+F/QytUzjVMxLm6TvuTIS+leZuqy1dsU6rztem0HhWwd5w4656mYyhJVWZFtPE
 P84j2qHMDV2/6LfwwCPP6BoVMolw0BAbKKeqVPAPQ+2Fj3lkfttcskPevVlHeqZxvRSV6pcVOf/
 VSjHJ3bAkiPZrywR9k1B7N0nA6+uvj5WEQf3uno73/RMT5vH/jABaRxfhLQb2EywjclU41G6iYq
 wLrPPmpToN0oIR0Y2d+OqqZsIyqbgi66kRIiYCFeNXg4Si8LVmfqTs+4DiO1B/l6d/u7Du8R/9d
 A73Sqicb8snS3pbCF9H2Guw6wR43/Dm9t58PK2WGbB1NssBF8OmKhreg8G2ovYf7pJVE6M8Tatw
 K7EIlTnl6IqXcFsNWKBdGy25i+kMYUFXQP3c+Xs2Yzwst67zy72nIZ1vy9JUTZUqE/0V4T4JPiX
 i/AUgo691TA6rzytxstQCYFeuzxYtcnAHSnPxaoVGPTLbYk2t9WhhlBtyUWaL+b1CoBfC571CJC
 V3TZ9b2frpEy7Yx2bSaLXwPVSMfzyeeoYnHSTNuxgsqbFr0DNy86yyA9+WpF7NZoEuE5qERUB80
 Woob7YObg2T/Wh5Bpg4MvDMBhFCsP5QYXPHd2E/bV5WVbN/nHVyUUkDtq71wlRVSfNVB/XUsui6
 zvYyybekvCWG2tw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6A03B80006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xk5n67c3obgzgt8edkr8iw8tg66umrap
X-HE-Tag: 1792606277-19877
X-HE-Meta: U2FsdGVkX18nPuWsYkovnMnwL0uvWjNPK1zYr+EsOytOL25toIFerLLI1AEIUoTrrwoGfOrp0LaXqGNikNmLQDHjRJagUJOeVxL0HK44RK5knhcQr8GjBQNOP5dS5CUH2K1l1ZMz+Btppr7o4Js+p4SrwMtaNXyEQD+wAUseyPdbjot8RkjKvCq4da5M6drnMLnzFOFuNZwrEG7sfnhMrsILn11tplmvFd537Rh/5lVpcrY8xazhg4K/yIEUJf7z/m1VdsFl7gGWcx+Q+cy1HE4Isivx/ZZBfBQPQE14eF+UyqV5uNTPi01VNcMNY79/vdg6jF5EY1FT2Eht525xQ7d8rzNoDP6OP7LXqA1NaJSLwECsbBXvw+u0jfk1l4FCMJqagrPNxy5jgzcMTDdA/mMaI+/e2bWjuVfrDr+g9q92LRRCWVtZSJ5iw1bkxjXwoClljISBnHo5Basy0nvxl81CFFp0Mo4+cIEtceYzGkdXRcaCQaFXU5eXQMCES72Qj2vKTy4aIbfiQ81N4xKhncp5yau6P07XEQDLz1mMWKcMPo0xQuyGi46awNIoYnAHw9Ewbshd7dxsJoXUt91vsiaN31dfhR5KLvEJ1HMd9CUdQT13RrqIDDAlSGKFaSi/TVb7Pg3bUIzzwhdDWNPWYwjuKON3VlU6ScltDtLwj9Uv+7+JFKejb+N0MExFa8PKjT6qQoxWoU2KXkZM7fHYx7zDRLpSfCnAGzg5E2/oZPywzwYJnLsfWszvG/xeGgqjMwZrs8ldMDgxgruMjmkJPMqILpM/F1ST+IdkAf+p71Xv+dNi7/rMb1nExMKYKg2NdTYMDt9exaV2plAMV/h2y5vmh+JGlvM2dMv9w+4EVjI3IT2Vr4/MCQVRn3iqU2rI5AD/8OQF6+7ce6EVrf+riF7am+W8pNGn6txa4sSzafPN+94Mkuu8MKPHcu4IcXjGfTLO6uSuh+Mvgik15+D
 nH7Tb1gI
 3kJHznFviFYTKl+Bz4OTd9ngrDLGweGX2eEu8G0/iRR9c+QcllxX2mf3U+1/089diqjIxQZWxZSI9veY9UTgPfRxjXXBdnY3QxhuV2otIfvcvOe0AULJABxUFPLEUGona2n3DnSem5LfmqMlUUdVkozLsP09YYMcO96BSPZ48wqEQzjFmBGideFsbxY7AnsgRlIo9KwnMiHAE60qy9QekVzvCjU9mFoVIOso/8LeOZL+2pQfdYt3lCs1RRocDAR7i+ynp8YzXkO7gK77509xNLNxHRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fork a process that maps a device DAX instance with a PUD, in a VMA
whose page tables fork copies because it has a guard region. The child
must account the copied PUD in its RssFile.

Without a reference, an rmap and a counter for the copied PUD, the
child's RssFile misses the PUD, and its exit leaves the child's file
counter negative: "Bad rss-counter state".

It runs only on a device named in argv[1] or $FORK_DAX_PUD_DEVICE: on
a kernel without the fix it leaves the device folio's mapcount below
zero.

Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 MAINTAINERS                               |   1 +
 tools/testing/selftests/mm/Makefile       |   1 +
 tools/testing/selftests/mm/fork_dax_pud.c | 136 ++++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   1 +
 4 files changed, 139 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b5cab72d851b..48653704007f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17481,6 +17481,7 @@ F:	include/trace/events/huge_memory.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/testing/selftests/mm/fork_dax_pud.c
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2d5366196e309..86914aaf8e6ad 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += fork_dax_pud
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/fork_dax_pud.c b/tools/testing/selftests/mm/fork_dax_pud.c
new file mode 100644
index 0000000000000..1fcf46341ace2
--- /dev/null
+++ b/tools/testing/selftests/mm/fork_dax_pud.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * fork() of a process that maps a device DAX instance with a PUD, in a VMA
+ * whose page tables fork copies because it has a guard region. The child
+ * must account the copied PUD in its RssFile.
+ *
+ * Runs only on a device named in argv[1] or $FORK_DAX_PUD_DEVICE that
+ * nothing else maps, with 1 GiB alignment and at least 2 GiB. To make one
+ * on pmem emulated in RAM, with CONFIG_X86_PMEM_LEGACY and
+ * CONFIG_DEV_DAX_PMEM:
+ *
+ *	boot with memmap=3G!4G
+ *	ndctl create-namespace -f -e namespace0.0 -m devdax -a 1G
+ *	FORK_DAX_PUD_DEVICE=/dev/dax0.0 ./fork_dax_pud
+ */
+#define _GNU_SOURCE
+#include <asm-generic/mman.h> /* Force the import of the tools version. */
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <setjmp.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+
+#define SZ_1G		(1UL << 30)
+#define DAX_SYSFS	"/sys/bus/dax/devices"
+
+static sigjmp_buf sigbus_jmp;
+
+static void sigbus_handler(int sig)
+{
+	siglongjmp(sigbus_jmp, 1);
+}
+
+static unsigned long sysfs_ul(const char *dev, const char *attr)
+{
+	char path[PATH_MAX], buf[64];
+	unsigned long val = 0;
+	FILE *f;
+
+	snprintf(path, sizeof(path), DAX_SYSFS "/%s/%s", dev, attr);
+	f = fopen(path, "r");
+	if (!f)
+		return 0;
+	if (fgets(buf, sizeof(buf), f))
+		val = strtoul(buf, NULL, 0);
+	fclose(f);
+	return val;
+}
+
+static bool dax_dev_ok(const char *path)
+{
+	const char *name = strrchr(path, '/');
+
+	name = name ? name + 1 : path;
+	return sysfs_ul(name, "align") == SZ_1G &&
+	       sysfs_ul(name, "size") >= 2 * SZ_1G;
+}
+
+static long rss_file_kb(void)
+{
+	char line[256];
+	long kb = -1;
+	FILE *f = fopen("/proc/self/status", "r");
+
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f))
+		if (sscanf(line, "RssFile: %ld", &kb) == 1)
+			break;
+	fclose(f);
+	return kb;
+}
+
+int main(int argc, char **argv)
+{
+	const char *path = argc > 1 ? argv[1] : getenv("FORK_DAX_PUD_DEVICE");
+	char *area, *mem;
+	int fd, status;
+	pid_t pid;
+
+	ksft_print_header();
+	if (!path)
+		ksft_exit_skip("no devdax device given\n");
+	if (!dax_dev_ok(path))
+		ksft_exit_skip("%s: needs 1 GiB alignment and 2 GiB\n", path);
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		ksft_exit_skip("%s: %s\n", path, strerror(errno));
+	area = mmap(NULL, 3 * SZ_1G, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (area == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	mem = (char *)(((unsigned long)area + SZ_1G - 1) & ~(SZ_1G - 1));
+	mem = mmap(mem, 2 * SZ_1G, PROT_READ, MAP_SHARED | MAP_FIXED, fd, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_skip("mmap %s: %s\n", path, strerror(errno));
+
+	/* A PUD in the first GiB, a guard page at the end of the second. */
+	signal(SIGBUS, sigbus_handler);
+	if (sigsetjmp(sigbus_jmp, 1))
+		ksft_exit_skip("%s cannot be mapped with a PUD\n", path);
+	FORCE_READ(mem[0]);
+	signal(SIGBUS, SIG_DFL);
+	if (madvise(mem + 2 * SZ_1G - getpagesize(), getpagesize(),
+		    MADV_GUARD_INSTALL))
+		ksft_exit_skip("MADV_GUARD_INSTALL: %s\n", strerror(errno));
+
+	ksft_set_plan(1);
+	fflush(stdout);
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_perror("fork");
+	if (!pid)
+		_exit(rss_file_kb() < (long)(SZ_1G >> 10) ? 10 : 0);
+	if (waitpid(pid, &status, 0) != pid)
+		ksft_exit_fail_perror("waitpid");
+
+	if (!WIFEXITED(status) || WEXITSTATUS(status))
+		ksft_test_result_fail("child does not account the copied PUD\n");
+	else
+		ksft_test_result_pass("devdax PUD copied by fork\n");
+
+	munmap(area, 3 * SZ_1G);
+	close(fd);
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384ee..7294e1334d1da 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -445,6 +445,7 @@ fi
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 CATEGORY="thp" run_test ./folio_split_race_test
+CATEGORY="thp" run_test ./fork_dax_pud
 
 CATEGORY="migration" run_test ./migration
 

-- 
2.43.0



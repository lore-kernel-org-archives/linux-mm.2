Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5359E606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=LgpaH7wC
Received: by kanga.kvack.org (Postfix)
	id 2EDBA6B07A0; Wed, 21 Oct 2026 16:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4C66B07A2; Wed, 21 Oct 2026 16:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5EF6B07A3; Wed, 21 Oct 2026 16:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D98AB6B07A0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:36:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F3F91C3EFA
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:36:33 +0000 (UTC)
X-FDA: 85347791466.13.B1F513D
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf11.hostedemail.com (Postfix) with ESMTP id 83C1240002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:36:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=LgpaH7wC;
	spf=pass (imf11.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792614991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOyDX5dEPNERoauSrbofATI5mXA9FSAKRwTu8vDD23U=;
	b=ByIygG36bj2nvBN2drtdnpIWLkKWNSAhq3SSKgipRn1QzYceqqhEGahMc4lPEeKNjOPydE
	euh6EjMapySzX3VhvXp2cIFHzpZSCd1FlQHIahbnD+TUWcNI+6c+GwkC3UEMfgHmlxNxdk
	cg00EGlam6jFzOjLvF99my8lLAfXHR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792614991;
	b=V2QcYN3hg3FMH48Q2LDzrPJybtceq0KyEM1ORg1QqB1yX3/ZzeWfcXWVK7NA8lMkeLvQ+t
	W023nZIwEwJA0wSk1YOu7/puG2qOSd2VE29xe07+MD9CJ3nlFBYDxIwk+oPHxPmQHmq58s
	Lh1m6ZJHoDcvOtsg4vRYEcbbgp3Qx5g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=LgpaH7wC;
	spf=pass (imf11.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=VOyDX5dEPNERoauSrbofATI5mXA9FSAKRwTu8vDD23U=; b=LgpaH7wCs81cWgHanKg
	5J7NT3T9Ku7YbxYV6keyUmIzuvv9Sju6TLJC3TUsVTysOv65ijD0Lt/Z3qHiUA87oCj7g7eJAaITQ
	ScOBnUS3nizelnJeFFA8djEOFd5M+AoBhcqxzASY7Kc0xhQz6fkd6gxsgD2WCsToxTxSD34aAeoZL
	9DHJOuYB307Sdho5gGK5e/PdA3IHRME1WMrygQ2yt1dDc7AvqaCHuZBoWoEwtinwXgQ+qeMndkh9e
	C9ztzyer6EJ5Qrtv43MHSwsePC84JaBhL76qVv0PgnfnoUpS3gfCaJ86YNW5F1f9PMIMFIxBBJ6Fm
	dT6QElY5MBLvXaA==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xJcz7-00D9zC-15;
	Wed, 21 Oct 2026 22:36:12 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 21 Oct 2026 22:36:03 +0200
Subject: [PATCH v4 4/4] selftests/mm: test fork of PMD-mapped shmem THPs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-4-66f00b7a564c@virtuozzo.com>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9737;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=bRhjD9Vo+lw+k222NCBCfPr0t0oTlFMKai2BU8dG86Q=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq2SI4LMEpHNb0U38oaO6M9JYbWTExQ1/4OjzDl
 qxJYbyiqXGJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatkiOAAKCRBRlgpH+WFc
 KlxJEADC26pSfjefmw7IIUPxOuf0fsqsAsLVvhvhzEeYqWUcR9OWZvAXaUjOXCgSi1A9YfLALxn
 V5WjHHnLd/FgPV5r2iHOXBCadlLq8c7w7NcyEx8fr5bwmtjTXGy3jEHTVJq82TF3+Gm4z7O4V85
 SMO4cGSe5mDHZrnmKsADj8+vsr68DAvtGjwKgWoXfnCmRMdyGrhyAAbEc/pucSJoHSynzoJ3tL7
 n2N6Kon5wHTREzBZcSQLByuaKaiiCoCjbtcBNWmHdxCvUD8vFlssvsqe2PwFNW3ir1dbnrd7kZx
 nxRNKlpSdzE7aIIl3dA0kBDYg6A7OftrUHu8kS2/V31EtNuLJ6dnCowInQVVCL2GmW8rXw0cXah
 EoE3oGPMKEkwKdUB8DHJL86nGx7k/DIfDl3hwchwiArre/vTuGn/45i4ydRG4k1wL56uPcKd9et
 n8LOL+sgyQ+dWHescqo8GsEMbzgaER+pDoZHZ9yFenZ+HHT3CzrwZDQr/3SJvQKaKulEeOsFdD7
 o7IfRV01WKUNM1cwM8YdyEbnFJcvHEbKpivuI3dhNVWluku0Yef34Wz7DU/NeT58Y5BsBIoNF/s
 2z5U1ocxGg/OXz/pz8Vl0VjpzZgmVQsjiROi0IdO6qHM3YNkh6yAoufjU6qhFhJkj4essCzX9k6
 u05WN/yvHnZP8YA==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 83C1240002
X-Stat-Signature: ono61uhxu11imqw6fue73fi1rw8589yw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792614991-130774
X-HE-Meta: U2FsdGVkX19kCAKzS9Do1FOL0rgK+RNaXT78NmlwWy4EMGLIuV7tKjfQ0ySPwtdboFBoDsrhHJG6PFztUTSopx0XWMYoKKZ7FXvUEQk78shVOerZzPyEkK1OxzcWlj2uGolhKh8gocYBKg9vRTAi4qrmOYIOy/eBaV3YPTZw6L50b16De7AV9F38TK5meNTsPFnbBIXoQKGsT5xYY1cu7qeEnEbSjTN5GvTMqvt8hNeRVu4rDOfF1DaCJGDxodBVJaIcxkFfftRErKMx7Nz5XFXo9fRpn13wXFSEzqFyXKtNd3zwn8P31SY8Qfrsjux3fN6ZMPghjQW+GvJ4Q7/pu0Mnd53hTYqYMRQ64mfx4FnsyAd+F+MkIgGD7cDUKbF5osmbLxJujnDqvrlFr3RGe18UyTwXHT5Fp1qefe0kZxcHQyKydIkK4bL0iOCiHQaDAQzMJAXgIoLSp4+hoFS2iewrzIK+pxfGD8kjaY7hAKt4f2XkIKy9m0bytV3/2PlgYAZaBr8GV6KckQBoFGzFifROhyoOxNszOvoIg1Ky8fsGzNKHMGKgljkGTdkYJlpCtukFZvQCVhPonL0LMXWG+JL+4hhI9USyf2aZ61Bk2utPrEdeVoRHjLPlPvqwkiBiM6V5uCGaFVM81adHTNzTlF9aDuzwqGZMhdB7BgAsjYCUYJNeu3k+9ixVWhGUehnzOvxP+xUcZc7Ntsv7RMVOEe7W44JZTz9v9GVP5J6aAaqvzy0SBmSUGShr0RIGnAKz11mJq883oY/r9FcHYtxqNVTmmm+TzEb0C3vmercjSFy4mbz3CJxTb3OcJIMWIrvXK5toML2Y6v90IGhQJsBPvH5A6WRpzKVk4y6oTZn/fTUOO/2YZ+uYaAvLHSTlUi+3Zzx/ODodFE8zqu/b0538bkCS+eElnGaAsWxY0zjTTE1v2+K0HkRZe/HCMWn+uJKHvASyB1I2feK/Ou8MR7o
 /XeZzEq5
 RcZ3kcz6Q47lHDakkQftDXY16PF/rCU+CT0UbRZka1jL6X6pW4bzv2xUXJtaLy/b1RzNhTmsawWuyUlJiZ0DDqiF28TkRN6Zf5FnFjDaqO4a2NXDx2edVYuFUrcgj+yPJsw5HMjR3rwHh0kcs97dldlNNTZsAYv6wyKgzvhs0CNKosvYIiFcH90ouGOD7C/XF5ZiSNJxdOmJhzrq4QYI6KMcTsrzfvC1i0jnjWDOcj01zWE8a/vhQsdQfIA6A1lu0naKFtyuObw53OswKYrST9tlj7lqBFb40gnZUCcZVWWGVgyGrsQT8YfZQRmbGQ0zFvc41c/zC5hAHj/LfPl2Ed2OtrI9WgIevd/rLZv4q9v92lLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fork a process that maps shmem THPs with PMDs, in a VMA whose page
tables fork copies: a private mapping with an anon_vma, and a shared
one with a guard region. The child must find the PMDs before it
touches the mapping, and its exit must leave the parent's mapping and
the system-wide ShmemPmdMapped counter as they were.

With folio_dup_file_rmap_pmd() adding PTE mappings, the child's exit
takes the parent's share off ShmemPmdMapped while the parent still maps
the folios. Closing the file then reports "Bad page cache", or hits a
VM_BUG_ON with CONFIG_DEBUG_VM. A kernel that leaves file THPs to a
refault in the child skips the test.

The test mounts a tmpfs with huge=always over /tmp in a private mount
namespace, so it leaves the THP settings and the host's mounts and
files alone.

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 MAINTAINERS                                |   1 +
 tools/testing/selftests/mm/Makefile        |   1 +
 tools/testing/selftests/mm/fork_file_thp.c | 227 +++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh  |   1 +
 4 files changed, 230 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7b5cab72d851b..1b5124e7e2bf9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17481,6 +17481,7 @@ F:	include/trace/events/huge_memory.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/testing/selftests/mm/fork_file_thp.c
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2d5366196e309..33ec3b7f4c048 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += fork_file_thp
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/fork_file_thp.c b/tools/testing/selftests/mm/fork_file_thp.c
new file mode 100644
index 0000000000000..76c8d1a0c9792
--- /dev/null
+++ b/tools/testing/selftests/mm/fork_file_thp.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * fork() of a process that maps shmem THPs with PMDs, in a VMA whose page
+ * tables fork copies: a private mapping with an anon_vma, and a shared
+ * mapping with a guard region.
+ *
+ * The child must get the PMDs without faulting, and its exit must leave the
+ * parent's mapping and the system-wide ShmemPmdMapped counter as they were.
+ * Kernels that leave file THPs to a refault in the child skip the test.
+ */
+#define _GNU_SOURCE
+#include <asm-generic/mman.h> /* Force the import of the tools version. */
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sched.h>
+#include <sys/mman.h>
+#include <sys/mount.h>
+#include <sys/wait.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+
+#define NR_PMDS		4
+#define MAX_PMDSIZE	(32UL << 20)
+/* ShmemPmdMapped is system-wide: retry if something else changed it. */
+#define ATTEMPTS	3
+
+static size_t pagesize, pmdsize;
+
+static long meminfo_kb(const char *key)
+{
+	char line[256];
+	long kb = -1;
+	FILE *f = fopen("/proc/meminfo", "r");
+
+	if (!f)
+		return -1;
+	while (fgets(line, sizeof(line), f))
+		if (!strncmp(line, key, strlen(key))) {
+			kb = strtol(line + strlen(key), NULL, 10);
+			break;
+		}
+	fclose(f);
+	return kb;
+}
+
+/* Skips the last page, which may be a guard page, and @skip. */
+static bool data_ok(const char *mem, size_t size, size_t skip)
+{
+	size_t off;
+
+	for (off = 0; off < size - pagesize; off += pagesize)
+		if (off != skip && mem[off] != (char)(off / pmdsize + 1))
+			return false;
+	return true;
+}
+
+/* Child exit codes, apart from what kselftest helpers exit with. */
+enum result { PASS, NO_PMDS = 10, FAIL_DATA, FAIL_COUNTER, FAIL_PARENT,
+	      FAIL_KILLED, COUNTER_OFF, CHANGED };
+
+static enum result fork_once(char *mem, size_t size, bool shared,
+			     long *before, long *after)
+{
+	/* The parent alone maps this much with PMDs. */
+	long own = (NR_PMDS - 1) * (pmdsize >> 10);
+	int status;
+	pid_t pid;
+
+	*before = *after = meminfo_kb("ShmemPmdMapped:");
+	if (*before < own)
+		return COUNTER_OFF;
+	fflush(stdout);
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_perror("fork");
+	if (!pid) {
+		/* Look before touching anything: the PMDs must be there. */
+		if (!check_huge_shmem(mem, size - pmdsize, NR_PMDS - 1, pmdsize))
+			_exit(NO_PMDS);
+		/* A shared retry sees the previous child's write. */
+		if (!data_ok(mem, size, pmdsize))
+			_exit(FAIL_DATA);
+		mem[pmdsize] = 'c';
+		_exit(PASS);
+	}
+	if (waitpid(pid, &status, 0) != pid)
+		ksft_exit_fail_perror("waitpid");
+	*after = meminfo_kb("ShmemPmdMapped:");
+
+	if (!WIFEXITED(status))
+		return FAIL_KILLED;
+	if (WEXITSTATUS(status) != PASS)
+		return WEXITSTATUS(status);
+	/* The child's exit took the parent's share off the counter. */
+	if (*after < own || *before - *after >= own)
+		return FAIL_COUNTER;
+	if (*after != *before)
+		return CHANGED;
+	if (mem[pmdsize] != (shared ? 'c' : 2) || !data_ok(mem, size, pmdsize) ||
+	    !check_huge_shmem(mem, size - pmdsize, NR_PMDS - 1, pmdsize))
+		return FAIL_PARENT;
+	return PASS;
+}
+
+static void test_fork(bool shared)
+{
+	size_t size = NR_PMDS * pmdsize, last = size - pagesize, off;
+	const char *desc = shared ? "shared mapping with a guard region" :
+				    "private mapping with an anon_vma";
+	char *buf, *area, *mem;
+	enum result res = FAIL_PARENT;
+	long before, after;
+	int fd, i;
+
+	fd = open("/tmp/fork_file_thp", O_RDWR | O_CREAT | O_TRUNC, 0600);
+	if (fd < 0)
+		ksft_exit_fail_perror("open");
+	unlink("/tmp/fork_file_thp");
+	buf = malloc(pmdsize);
+	if (!buf)
+		ksft_exit_fail_msg("malloc failed\n");
+	for (off = 0; off < size; off += pmdsize) {
+		memset(buf, off / pmdsize + 1, pmdsize);
+		if (pwrite(fd, buf, pmdsize, off) != (ssize_t)pmdsize)
+			ksft_exit_fail_perror("pwrite");
+	}
+	free(buf);
+
+	area = mmap(NULL, size + pmdsize, PROT_NONE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (area == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	mem = (char *)(((unsigned long)area + pmdsize - 1) & ~(pmdsize - 1));
+	mem = mmap(mem, size, PROT_READ | PROT_WRITE,
+		   (shared ? MAP_SHARED : MAP_PRIVATE) | MAP_FIXED, fd, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	for (off = 0; off < size; off += pmdsize)
+		FORCE_READ(mem[off]);
+
+	/* Make fork copy the page tables; the last PMD gets zapped. */
+	if (shared) {
+		if (madvise(mem + last, pagesize, MADV_GUARD_INSTALL)) {
+			ksft_test_result_skip("%s: MADV_GUARD_INSTALL: %s\n",
+					      desc, strerror(errno));
+			goto out;
+		}
+	} else {
+		mem[last] = 'p';
+	}
+
+	if (!check_huge_shmem(mem, size - pmdsize, NR_PMDS - 1, pmdsize)) {
+		ksft_test_result_skip("%s: shmem is not mapped with PMDs\n",
+				      desc);
+		goto out;
+	}
+
+	for (i = 0; i < ATTEMPTS; i++) {
+		res = fork_once(mem, size, shared, &before, &after);
+		if (res != CHANGED)
+			break;
+	}
+
+	switch (res) {
+	case PASS:
+		ksft_test_result_pass("%s\n", desc);
+		break;
+	case NO_PMDS:
+		ksft_test_result_skip("%s: fork does not copy file THPs\n", desc);
+		break;
+	case COUNTER_OFF:
+		ksft_test_result_skip("%s: ShmemPmdMapped %ld kB is below what this process maps\n",
+				      desc, before);
+		break;
+	case CHANGED:
+		ksft_test_result_skip("%s: ShmemPmdMapped keeps changing\n", desc);
+		break;
+	case FAIL_DATA:
+		ksft_test_result_fail("%s: child sees wrong data\n", desc);
+		break;
+	case FAIL_COUNTER:
+		ksft_test_result_fail("%s: ShmemPmdMapped %ld kB before fork, %ld kB after\n",
+				      desc, before, after);
+		break;
+	case FAIL_PARENT:
+		ksft_test_result_fail("%s: parent's mapping changed\n", desc);
+		break;
+	case FAIL_KILLED:
+		ksft_test_result_fail("%s: child killed by a signal\n", desc);
+		break;
+	default:
+		ksft_test_result_fail("%s: child error %d\n", desc, res);
+		break;
+	}
+out:
+	munmap(area, size + pmdsize);
+	close(fd);
+}
+
+int main(void)
+{
+	ksft_print_header();
+	pagesize = getpagesize();
+	pmdsize = read_pmd_pagesize();
+	if (!pmdsize)
+		ksft_exit_skip("THP is not supported\n");
+	if (pmdsize > MAX_PMDSIZE)
+		ksft_exit_skip("PMD size %zu MiB is too large\n", pmdsize >> 20);
+	if (geteuid())
+		ksft_exit_skip("needs root to mount tmpfs\n");
+	/* The tmpfs over /tmp lives and dies with a private mount namespace. */
+	if (unshare(CLONE_NEWNS) || mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL))
+		ksft_exit_skip("private mount namespace: %s\n", strerror(errno));
+	if (mount("tmpfs", "/tmp", "tmpfs", 0, "huge=always"))
+		ksft_exit_skip("tmpfs with huge=always: %s\n", strerror(errno));
+
+	ksft_set_plan(2);
+	test_fork(false);
+	test_fork(true);
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384ee..454a8b75a3bf3 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -445,6 +445,7 @@ fi
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 CATEGORY="thp" run_test ./folio_split_race_test
+CATEGORY="thp" run_test ./fork_file_thp
 
 CATEGORY="migration" run_test ./migration
 

-- 
2.43.0



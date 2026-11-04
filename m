Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9526076364
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=YKg7EbzG
Received: by kanga.kvack.org (Postfix)
	id 9906B6B05B2; Wed,  4 Nov 2026 15:41:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941F46B05B4; Wed,  4 Nov 2026 15:41:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E14F6B05B5; Wed,  4 Nov 2026 15:41:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 416E76B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:41:47 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC09B1C41C2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:41:46 +0000 (UTC)
X-FDA: 85398607812.08.1418936
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf13.hostedemail.com (Postfix) with ESMTP id F14B420003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:41:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=YKg7EbzG;
	spf=pass (imf13.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793824905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tuSpbmEkfR5NhcJw5pfnLX7U3UGQwCUamJk62bXk0k=;
	b=pbgcTbVkqM+3dP3pCBWSsYZLgZMd/9Aze3FoTebi91JJDdatJw8GrKvgp8+4G9UBwoGF/s
	VpQRF9Ib418IZX9D0CKWHXXANQ90Mbt2FjiRRltaBNyrQIkGQt4JIKhnwyNcMa9xacvcxI
	BenWc0hy/SgfmO1OOSFYbmGigt2/KG8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793824905;
	b=YlAE++7z8AB4OW2VNikPUedDK3ckeU5seBAcisRmvAfcICFcrUG4VFTYM1ufeQT/RiPrEG
	B+dxxmaUNThu6pu/pQ4a/I6e7S14o1Eqt4LIJjgu2wDjtODr58lZOKM2QliIS7IA+z5Ofq
	sgbf2yF03Ff3/dfCu1TkBCwEtF/jx/U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=YKg7EbzG;
	spf=pass (imf13.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=/tuSpbmEkfR5NhcJw5pfnLX7U3UGQwCUamJk62bXk0k=; b=YKg7EbzG6/xavxxD1EA
	Cc0cWVxsIX2uHmopem/3753Spy4uPS8PsQM12VvGpFiq5JlHa5tcfMLIEatLA3tPocrno6c1lfPT4
	eFGb37/eReeK/V7uCONKlPckJECrMXvWCXisZScIWV5eCcanY1/omDVS3U2mKQVj/s1hd0+hpuOd8
	F2j7cTYKIT2sHzkZVPqMJmgCDxEQaS1lNF6pNQZSaxhTn9DE1SqreD9HHQe5INnkTM1lj1rvMg6K1
	l5clWFtCexbQhaAE49j7srKdmpMwQpzVmA8DqjmQe8+cJ0gFlTEcnIfxRxqbYFtDuEZaDurRPz38q
	rv9r5tiJJIiO3uQ==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xOhjB-0018X2-1g;
	Wed, 04 Nov 2026 21:41:05 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 04 Nov 2026 21:40:58 +0100
Subject: [PATCH v5 4/4] selftests/mm: test fork of PMD-mapped shmem THPs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-4-c56d0d26f970@virtuozzo.com>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11029;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=LaNJ6nRiIFQ71fZKaMjBG0yYeXmXdvJPv5bQ40ut68w=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq65hd6fqcGkyzLfAIDPqzv+f1a5VEmIZwnQ14T
 O4+pYZ5FCeJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCauuYXQAKCRBRlgpH+WFc
 Khy1D/wP2cJLtGEslEPmmjDv9/XG68s2H2LqCOIXfNehsv36X/rk9iag0kaBSloS4iVPwR+Ftrg
 wUQi/Lvxp1aaqY6LeA6e67RHqxpvmV/hiJrM7YEnfIWJQ+opB4Ff5NjfBYbd5ICGThBfFL+epiX
 AbO3BCCw8dOQ22FQNvasvFrNmJ4hkvyckqIX1HPj03art8FuaNnqp7IOudjKCd4Xzww5WoHpM2E
 TW1lEOk7E0wvpF0NOz17RnZBfuyaMypcBudp751/cK/ib+PNxyjJs2G95SF89IUASc4FMp0/HcV
 wEmSzoymWrTH6T1xkzs0GAbF1IqC9CLNAvPXNIDowJn4O0npnTdaHkG4m7fO/flZXBOE8bT2X5C
 XQTSyetg52IEIHZZ1CXo7PnnVEx/wSx4V04D84vmiByjxgSHMS311ZG9mgHHHuvBxrLPlblDTDT
 ZwU1p5cs0uID8pnzkT41N13j1aT7Paw5/p1Hvudic5UhNDG5kBQleOLQGWOO0x+eaRtv2i34xt+
 JvEcg3LWw8BQrKItCaUTYpB/jNj+NvrxqFeUv3nGc47KDU1mfCVa/bySGJSTXrNNYgtMB0Wgmtb
 vY86MpIOlJQpHR1A/RUJkAd79hWLjPp1Iv+YKOa0qNyoRWU0+wVcjskBH4z2SgIU8iWSN7u969g
 09G50m1Sj75qywQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Server: rspam06
X-Stat-Signature: 1k4rm6mrf9rtxgimdmrdakrsjbizm6gn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: F14B420003
X-Rspam-User: 
X-HE-Tag: 1793824904-519327
X-HE-Meta: U2FsdGVkX18HFl/lQyBVZlMPEC5w+LnpTkEcNQtODFtEUofqDL6FqtSdychy0goPupZ88ifJM1XaS3B6gNsT8UwoUsrCEOmxbaFOaiAfjOZkmujB8M94UfqD6VX2519Fc7fHa3Td9qGiWhQLzne2hg7WimfnN3syXqHYUKhRbVssT/ntx3p2yrRPzd1FC3F0hz/Qx++wHtoYjkaLhm4M4H3GJ3pg6h0q8WEqOBLAFM/bqXJKidqWWUVtWke/Cwx0ykzq9ewu1tuydnAm6TOvSve4+PGx9YOSBKxtuujibymepeH1xY1t9i/UEiExMi/saXHSCmDMWa7yDRN2dVLo8K2Mbbx1lvzMb+vOO1vjIBgbT+FGQE4Lo/hdcAodO/bmx68/urFAlQx76LB2a9lM39im4IAAPsj+dBj33crj6Z3rIcqyUyi2YzPz8VRxpOKQM0p0J2OS8p4zTXUZ6hade19SdwkMRkbnsPkpBnSh5VL3boCgFE4pct4bQVKNmXtBmQYE4kpWwr6sRgH3mNt+Zpo8ixY+OolXuK7etoRLouS2ABbW3GWNmwIvIfvvQCih+V3o6KudhGVXcM3mpMcjKiC9iq5UA0WrjwyXIIWSdbb33/vMHepC8TWG/TGeLcKb4iqJb9PMzE6+cu0L+In7jLR4WgPNScU3ymXFyuTyz04nZTnGi/VO7ocjuuVI6Y1h+QLUKfJsEeyD8P+rrHGPC7yYv0y9GrG/VaxJ23WeLYJrHhfTrpXkoUBucLgSSdiv+fSZqzadHEo08po6fPpI803NNN2EUMERRRRs/AswijnhD2nUNovbq0FjEOzYYJaJkF76XkcnCeVFUrCvBPrKnflUrlPg1G6mb2M79hXY4Y8qH+vC9z448oUrBZqqsxFJkZapFqO6LTua+8uTeCj2rFctzZMq3nIJJbADzqK73LmLX6Xfr604b33OVxhNlOzRduOruOatpjv8chfCucO
 q93RkfAI
 gB783+sCXhqbMU5YPBj7XyqtfLauShA0tQkXGBK0JL0ZlEd1OTLBepS1fthqk0E0Z7J97DmFfNRZDmC56rOsykPkQeYLg0ZApRN5qSuJv+peum36WSJW2WyexfEifybq8WchcH/6FHfiiWi6geiMHqxDNbr/eW1RLKtzY3UkKjuPp7aBPX3YnrOdKihbYhABeaouw+4UdUQt9BH4VO0J7KggI5FS5hQcCffiZ0KMjJlg2EiI32jlrGxYLPMmG/b2UrZ6PABR29nPWAGQqwXKB+FmRHGf5tN6GGmN7RLugKANtayq4TfnqTbyhCGJCXG28ysaFlST+arAZ2aRz+oCCW4GRB85yBBFhqfV2P16oqYpFYD4=
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
the folios. Unmapping them drops it once more, so every mapping stays
until exit, where the kernel reports "Bad page cache", or hits a
VM_BUG_ON with CONFIG_DEBUG_VM. A kernel that leaves file THPs to a
refault in the child skips the test.

ShmemPmdMapped is system-wide, and reclaim or NUMA balancing can take a
PMD from the parent while the test runs. So the test makes up to three
attempts, each on a fresh file, and fails only if all of them see the
counter drop by exactly the parent's share: the bug does that on every
fork, other processes only by chance. It passes on the first clean
attempt and skips when none is clean.

The test mounts a tmpfs with huge=always over /tmp in a private mount
namespace, so it leaves the THP settings and the host's mounts and
files alone.

Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 MAINTAINERS                                |   1 +
 tools/testing/selftests/mm/Makefile        |   1 +
 tools/testing/selftests/mm/fork_file_thp.c | 256 +++++++++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh  |   1 +
 4 files changed, 259 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065d..1e6c35a30a369 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17859,6 +17859,7 @@ F:	mm/collapse.h
 F:	mm/huge_memory.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
+F:	tools/testing/selftests/mm/fork_file_thp.c
 F:	tools/testing/selftests/mm/khugepaged.c
 F:	tools/testing/selftests/mm/split_huge_page_test.c
 F:	tools/testing/selftests/mm/transhuge-stress.c
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 0ea72e9979347..2489027b2a36b 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -108,6 +108,7 @@ TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += khugepaged_sync_check
 TEST_GEN_FILES += khugepaged_race
+TEST_GEN_FILES += fork_file_thp
 TEST_GEN_FILES += soft-dirty
 
 ifeq ($(ARCH),x86_64)
diff --git a/tools/testing/selftests/mm/fork_file_thp.c b/tools/testing/selftests/mm/fork_file_thp.c
new file mode 100644
index 0000000000000..aaecf7ba6f406
--- /dev/null
+++ b/tools/testing/selftests/mm/fork_file_thp.c
@@ -0,0 +1,256 @@
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
+/* Other processes, reclaim and NUMA balancing can disturb an attempt. */
+#define ATTEMPTS	3
+
+static size_t pagesize, pmdsize, size;
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
+static bool data_ok(const char *mem, size_t skip)
+{
+	size_t off;
+
+	for (off = 0; off < size - pagesize; off += pagesize)
+		if (off != skip && mem[off] != (char)(off / pmdsize + 1))
+			return false;
+	return true;
+}
+
+/* The last PMD is zapped by the setup, the others must be PMD-mapped. */
+static bool pmds_ok(char *mem)
+{
+	return check_huge_file(mem, size - pmdsize, NR_PMDS - 1, pmdsize);
+}
+
+/* Maps a fresh shmem file of NR_PMDS PMDs, PMD-aligned, until exit. */
+static char *map_file(bool shared)
+{
+	char *area, *buf, *mem;
+	size_t off;
+	int fd;
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
+	close(fd);
+	for (off = 0; off < size; off += pmdsize)
+		FORCE_READ(mem[off]);
+	return mem;
+}
+
+/* Child exit codes, apart from what kselftest helpers exit with. */
+enum result { PASS, NO_PMDS = 10, FAIL_DATA, FAIL_COUNTER, FAIL_PARENT,
+	      FAIL_KILLED, COUNTER_OFF, CHANGED, LOST_PMDS, NO_THP };
+
+static enum result fork_once(char *mem, bool shared, long *before, long *after)
+{
+	/* The parent alone maps this much with PMDs. */
+	long own = (NR_PMDS - 1) * (pmdsize >> 10);
+	bool parent_pmds;
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
+		if (!pmds_ok(mem))
+			_exit(NO_PMDS);
+		if (!data_ok(mem, pmdsize))
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
+	/* Reclaim or NUMA balancing took a PMD from the parent. */
+	parent_pmds = pmds_ok(mem);
+	if (WEXITSTATUS(status) == NO_PMDS && !parent_pmds)
+		return LOST_PMDS;
+	if (WEXITSTATUS(status) != PASS)
+		return WEXITSTATUS(status);
+	if (mem[pmdsize] != (shared ? 'c' : 2) || !data_ok(mem, pmdsize))
+		return FAIL_PARENT;
+	if (!parent_pmds)
+		return LOST_PMDS;
+	/* The child's exit took the parent's share off the counter. */
+	if (*before - *after == own)
+		return FAIL_COUNTER;
+	if (*after != *before)
+		return CHANGED;
+	return PASS;
+}
+
+static void test_fork(bool shared)
+{
+	const char *desc = shared ? "shared mapping with a guard region" :
+				    "private mapping with an anon_vma";
+	long before = 0, after = 0;
+	enum result res = NO_THP;
+	int i, drops = 0;
+	char *mem;
+
+	for (i = 0; i < ATTEMPTS; i++) {
+		mem = map_file(shared);
+		/* Make fork copy the page tables; the last PMD gets zapped. */
+		if (shared) {
+			if (madvise(mem + size - pagesize, pagesize,
+				    MADV_GUARD_INSTALL)) {
+				ksft_test_result_skip("%s: MADV_GUARD_INSTALL: %s\n",
+						      desc, strerror(errno));
+				return;
+			}
+		} else {
+			mem[size - pagesize] = 'p';
+		}
+
+		res = pmds_ok(mem) ? fork_once(mem, shared, &before, &after) :
+				     res == NO_THP ? NO_THP : LOST_PMDS;
+		/* Later children get only their own mapping. */
+		madvise(mem, size, MADV_DONTFORK);
+		if (res == FAIL_COUNTER)
+			drops++;
+		else if (res != CHANGED && res != LOST_PMDS && res != NO_THP)
+			break;
+	}
+	/* Other processes can mimic the bug's drop, but not on every attempt. */
+	if (res == FAIL_COUNTER && drops < ATTEMPTS)
+		res = CHANGED;
+
+	switch (res) {
+	case PASS:
+		ksft_test_result_pass("%s\n", desc);
+		break;
+	case NO_THP:
+		ksft_test_result_skip("%s: shmem is not mapped with PMDs\n",
+				      desc);
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
+	case LOST_PMDS:
+		ksft_test_result_skip("%s: the parent keeps losing its PMDs\n",
+				      desc);
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
+	size = NR_PMDS * pmdsize;
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
index a1b45a3dedaee..790a6b6746465 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -433,6 +433,7 @@ fi
 CATEGORY="thp" run_test ./transhuge-stress -d 20
 
 CATEGORY="thp" run_test ./folio_split_race_test
+CATEGORY="thp" run_test ./fork_file_thp
 
 CATEGORY="migration" run_test ./migration
 

-- 
2.43.0



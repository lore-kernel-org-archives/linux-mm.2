Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECABCA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1406B00CD; Tue, 29 Sep 2026 04:02:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51EB6B00CE; Tue, 29 Sep 2026 04:02:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBB46B00CF; Tue, 29 Sep 2026 04:02:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C08C6B00CD
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:02:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 238D01A042E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:02:30 +0000 (UTC)
X-FDA: 85266057660.21.F330DA4
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 287DD4000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:02:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=VnVhAmC6;
	spf=pass (imf27.hostedemail.com: domain of leizongkun@qq.com designates 43.163.128.44 as permitted sender) smtp.mailfrom=leizongkun@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U2U6aDNMw2I8MfaKyLeHZ7LBqc55cwRUPIn/65Z0x10=;
	b=vnjGywb8gn9QLoi28nxQ5Ntw2mNKSJKG5kmMZcyJF3Wu2P2RqBG9DbfkWT5B3zDTwc7TjC
	liTraS25rvYS+nKqXoI3AI651LS2XtFW5l8PE9nsS8fBFSUsPGieoMWBwJ42TdMflJ17E4
	r7R7kcWFEBKCm8TiqLlJeZN4N9G1iUk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=VnVhAmC6;
	spf=pass (imf27.hostedemail.com: domain of leizongkun@qq.com designates 43.163.128.44 as permitted sender) smtp.mailfrom=leizongkun@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668948;
	b=qNyY81+JnybuRY4364VaHQjc/UgEJ56s1ZrwqjCLxBPdwx+tsxg13lE23fvwk7klqIBKsn
	oUPr40ysqeOz7XinMGVBnmqRWM9GOR1vIgi6uGTFhiUSmzpJdfYqCrXoKyuTs8G91OFLZN
	+hNslCO1HysnIqQa804AvBdalHwqXBI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790668944; bh=U2U6aDNMw2I8MfaKyLeHZ7LBqc55cwRUPIn/65Z0x10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnVhAmC6OFKfVxCc/qZNWASfT+zhoRURGBrCS7uWohjNaG/WcjSgPg5yn9oCfmCkC
	 YxemwK5Uh9qomIrD60P+bG73m/druvP4knqyAZeH3bBgNrrTVLBX/zNoWyqS8EUnh1
	 1EruhY2+or0Q4Y1gLXX1FvDug9atinuYs5IpsAdo=
Received: from lzk-B860M-AORUS-PRO-WIFI7 ([2409:8a28:a83:5ba1:514f:5353:e14b:594e])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 92972ED; Tue, 29 Sep 2026 16:02:18 +0800
X-QQ-mid: xmsmtpt1790668938tf8y63gfh
Message-ID: <tencent_DA7DF282E8B3677ADD69D0DE6F5BAFFA4805@qq.com>
X-QQ-XMAILINFO: MKgRZ+o3du7tntlPab5I28cPKMhW2rEO1kFDk0wTprbWqFYs4Lm3jW+lPCH9IH
	 fGMMuQi9HDs1uraogG6V++O6gY2DYaL4tnVxbPKx3r7QFLavtFis4HFXmj7Oss6sgM+1JQ6wQtWS
	 isOP3NvwQ3r/T0aTPIeJIfBlPVjrAJzN2g2L8oVF0id1OHrLFB4/ELn0hu154Lp9ape2kJ57wN5i
	 HYtDM8o635yIVXDCPPBkrN6S9rnge8aVxAbmhKu9eBOtz0ULduN2EVFeGruOEwHLofGHZWYGwCcl
	 uAI5h1Hb10aeyi8eGiCFzy9Q/H5iRoJdTpO2XJnZlT/TfrcDv/6dRRI2xBtnMYBUVkm9Z9+sxXYJ
	 xySSZD+xhskOZMXlG7iZcP0nVTFBzOyXlqDgoOpt2ssYeVQOoU2z/gW6gCy5eT11tHOQXkyHdrVk
	 8lS/SN7AWbJ6ne6eX6we1EFAsFE12/D3Fsrhl1gJgGiU+3//wqzPcHt8oAqAQIkYf9u0GBjOOQ+q
	 7Arp4HRvcdtON4jqmWXdPRV/ofkrQcyBbI+lb0svaIEutaaNfDSu8tqKzoVs7zmmIY/atVHdoRSH
	 MsW2d3o9r5CM205BcYSk5fpcF+uaQbpAFMMYGyCJTdqxD5sFJIuUu0+CjeaAc+tf/PjlIFgPhx2g
	 fDj0Kkryp576A0FDQZoTZT6ryFnyebGPbo1vZu9+l+xvca1wmwDQTLRTcmEs+oxh3Efw4DaNrNzM
	 Csqz5+eRl7TKNjPr3tMMoCIMt0AKwmhiVFJHFKw2MIv7fF7EsH7RL0q5fQSpulMAgvK6MEnKUA2r
	 eZuAjIf0jHN2cGPfAskoow8iObn/6iOUbfG/FtHXkh1Qh7ByxD3d9ehUB+SPOk6uwE2pI/a1/S5y
	 csWvkBUmoLy0YCr7lYUbIANgPVOklCvOAMOOR/kiKrZDnGyBI0rXD6vmUxD13H+UQYzYGtyLaM6v
	 m1RvWXSB8SJxEbgnhsrd22cziZGc1ITIqvv80niXl4WfuCIFPPiUkTCTK7vW7lVtD60qKdZtl6Zg
	 86Z2k4534graKIgO4FF2RoDcD90mjhdWSwSu3Vh13Ga/EN2ESqX4GwNJEpYHRXa4QUZx+quwplW0
	 mx3TEHxde24bP2QaFqqvll+nvZZTZFGxJz880fOBBR1+NE0PReCVNhlny17h22cg5IY8G87zaco0
	 pMMXoro/hZG6FllwPqs3hv7jn8CGs4YPj3ykWU25JypzyYlhfljWJyvGIi
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Zongkun Lei <leizongkun@qq.com>
To: linux-mm@kvack.org
Cc: Zongkun Lei <leizongkun@qq.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [RFC PATCH 6/6] selftests/mm: add hugetlb_swap test, document hugetlb swap
Date: Tue, 29 Sep 2026 16:02:11 +0800
X-OQ-MSGID: <e2aed2a6871ff840ecf4aad877ea4981b0a202b5.1790663399.git.leizongkun@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1790663399.git.leizongkun@qq.com>
References: <cover.1790663399.git.leizongkun@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 287DD4000B
X-Rspam-User: 
X-Stat-Signature: 3d83uit3ii7yyik9omjo4k4b1t9t1i5e
X-HE-Tag: 1790668946-465679
X-HE-Meta: U2FsdGVkX194Rh2wgCPVa//2B25EvAeeTnSLp/XPrjr7eg7wXAJe0vH2ebLj7qtBJvgZg6lwUVxc1LbX8jJZ0i4m6mRwN3XZ75h2ZPOQOh7DtkogAW1X5Z+ZbppL2DHDngpl7iaIH28oLzm58YgX6htI7mhFCu5Udxj6SJYFh2gSjl7+vJyTXX1F0o0JZy2B3kOYsjFtkHhWmy2+nsJIMMCdCOz4dJDwVAuW+bwzVJ4ikq/EfQqONaYBu9m0Hx9Z+8HU/quA/N6RMh3fh9mbiU2KhHqEvuiPz1f3+CKR6M7ATxkWzD+Pby+1pOv3nS4ZYH7jSQurhnzOVBwLjgJCGqzP8qStKidolxOlnYnKD9SkrGVD6xadib1PVPY0Nn8c0lu6VTRaydXT2Yh15RxwsXGNfb95UF+UN4d8eVSoS98UUdNWevosEYEuRDm7pA9A9BgU+TPnTR7S4JbEVSkfWY+TGhcikn1av5YWEY27LZZkQRaloQeTXfMBzG+81A1XeWJ9umLyf1tR3T6F3+iV5XALprsLkPy/3FcAcZ3sQ21FYC1UVhj+E9VUem2grM2Hn2wpjZvH1ZB6mBcb991VaFTKy0zWEGbdc6TjL1vQnDUIqX8GDzsxBl7DAgXgVmV1gzcq2X3b1iAhNAFXQsDXKUBl58gZqVHGiZWEFMP83/SjHcuZqb4jgb8ScQ6dHWayFT2WSb8hP4h43ijSHzI4JewrA3XJuVpQAC+zatSWGOQmeaoI3i1XUOcauGtC7lXJvSuzecAxspPimtvWODBtfgYzpLkPYQ8faEZhXrkCDhQJOliGRGVmObQ78KkffDSSwvymIH350027DBfDqx2c7YtNr/MlPoDvb1T7QUXh5dHIalF1fBWL1om7lgruKtRZj7Ou1EI7+ur+spn+KsOmKLug5zzBpCyvlg5ZYB8TSlwPvZdchN6zAc/GBsTBPLXmkQQBiPGcEAImNlexaK5
 Z0EJiGwO
 7B9yHIfh/nGa9bkBg7S3Y/JbgL/uiZbVdkOMRvzW4j+Dj1cqI4WalnW5+szPjGBWzg7zONZeswDYKuD2++Dp9jqq48/MwsI85yVhne+LJgs2YQQ1SfK+LQxOZuzv7PAzcoVLcY3vFlM5q3TjIvRO+Yaf1y7m19enGJAOpVsiBp+IMmXZc3VYdmBnbJuYl/2LWw8wYTS3UudGdratGT8HUj5suOORupcMZKxST+sc6eV+uipes1sKRZVkwZcfsc1q7tgGdLjUblbMDj2E8JvGL2UDWrQMepKw7mTVG4bZ/fjvHZzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tools/testing/selftests/mm/hugetlb_swap.c covering the hugetlb
swap feature end to end (37 assertions, 14 scenarios):

- anonymous pageout: PTE becomes a swap entry, the huge page returns
  to the pool, VmSwap grows by the huge page size
- fork sharing swap entries: duplicated slot references, MM_SWAPENTS
  charged to the child, COW on write, parent data unpolluted
- munmap/exit releasing swap slots; zap-time drain of the leftover
  swapcache copy after a read fault
- swapoff bringing swapped-out hugetlb pages back in
- pool exhaustion at swapin: SIGBUS after a bounded retry, matching
  the reservation contract
- hwpoison of a swapcache-resident folio: the folio stays in the swap
  cache and the accessor is killed with SIGBUS at swapin
- shared file-backed mappings: pageout clears the PTE without
  installing a swap entry, refault and read(2) both swap back in with
  data intact, repeated pageout/swapin cycles, truncate freeing the
  anchor and its slots (SIGBUS on subsequent access)
- reject paths: VM_LOCKED, userfaultfd-registered and gigantic VMAs
  fail MADV_PAGEOUT with EINVAL
- mprotect/mremap smoke over swap entries
- VmSwap accounting: +N at pageout, +N at fork, -N at swapin and zap
  (regression test for the unsigned-negation zap fix)
- soft-dirty and uffd-wp bit propagation through swapout/swapin

Verified on x86-64 (2M hugepages, dedicated swap device): 35 pass /
0 fail / 2 expected skips (mlock is a no-op on hugetlb; no free 1G
gigantic pages).

Document the feature in hugetlbpage.rst: the userspace-driven
PAGEOUT contract, the size and VMA restrictions, and the
pool-exhaustion SIGBUS semantics a manager process must plan around.

Signed-off-by: Zongkun Lei <leizongkun@qq.com>
---
 Documentation/admin-guide/mm/hugetlbpage.rst |   29 +-
 tools/testing/selftests/mm/Makefile          |    1 +
 tools/testing/selftests/mm/hugetlb_swap.c    | 1118 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |    2 +
 4 files changed, 1149 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/mm/hugetlb_swap.c

diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
index 3cc15d800be1..75b78dea5a2e 100644
--- a/Documentation/admin-guide/mm/hugetlbpage.rst
+++ b/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -88,7 +88,8 @@ the user when the system is under memory pressure.  Please try again later.
 
 Pages that are used as huge pages are reserved inside the kernel and cannot
 be used for other purposes.  Huge pages cannot be swapped out under
-memory pressure.
+memory pressure; explicit userspace-driven swap-out is described in
+Swapping_ below.
 
 Once a number of huge pages have been pre-allocated to the kernel huge page
 pool, a user with appropriate privilege can use either the mmap system call
@@ -469,6 +470,32 @@ errno set to EINVAL or exclude hugetlb pages that extend beyond the length if
 not hugepage aligned.  For example, munmap(2) will fail if memory is backed by
 a hugetlb page and the length is smaller than the hugepage size.
 
+Swapping
+--------
+
+Hugetlb mappings can be swapped out on explicit userspace request via
+madvise(2) MADV_PAGEOUT / process_madvise(2).  This covers both private
+anonymous mappings (MAP_PRIVATE hugetlbfs files and MFD_HUGETLB memfds
+after COW) and shared file-backed mappings; for shared mappings the
+folios are written to swap while the PTEs are simply cleared, mirroring
+the shmem model.  The kernel never swaps hugetlb pages on its own:
+cold-page scoring and swap decisions belong to userspace.
+
+Only huge pages that fit in a single swap cluster (i.e. PMD-sized, 2M on
+x86-64 and arm64) are swappable; MADV_PAGEOUT on larger hstates,
+userfaultfd-registered or locked VMAs fails with EINVAL.  Swapped-out
+folios are swapped back in on access (for shared mappings, read(2)
+works as well).  MADV_WILLNEED has no effect on hugetlb mappings:
+hugetlbfs has no readahead support, so the advice is silently ignored
+as it has always been.
+
+Swapping out releases the huge page back to the persistent pool, so a
+later swap-in competes for pool memory.  If the pool is exhausted at
+fault time, the faulting task receives SIGBUS after a bounded retry,
+matching the reservation-exhaustion contract.  A manager process must
+therefore create headroom (page out cold pages) before touching swapped
+pages.
+
 
 Examples
 ========
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2d5366196e30..b74047ede66f 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -66,6 +66,7 @@ TEST_GEN_FILES += hugetlb-mremap
 TEST_GEN_FILES += hugetlb-read-hwpoison
 TEST_GEN_FILES += hugetlb-shm
 TEST_GEN_FILES += hugetlb-soft-offline
+TEST_GEN_FILES += hugetlb_swap
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
diff --git a/tools/testing/selftests/mm/hugetlb_swap.c b/tools/testing/selftests/mm/hugetlb_swap.c
new file mode 100644
index 000000000000..d8937735b44c
--- /dev/null
+++ b/tools/testing/selftests/mm/hugetlb_swap.c
@@ -0,0 +1,1118 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
+#include <sys/ioctl.h>
+#include <signal.h>
+#include <setjmp.h>
+#include <poll.h>
+#include <pthread.h>
+#include <linux/memfd.h>
+#include <linux/userfaultfd.h>
+#include "../kselftest.h"
+
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
+#ifndef MADV_HWPOISON
+#define MADV_HWPOISON 100
+#endif
+#ifndef MFD_HUGETLB
+#define MFD_HUGETLB 0x0004U
+#endif
+
+#define HUGEPAGE_SIZE (2UL * 1024 * 1024)
+#define PM_PRESENT  (1ULL << 63)
+#define PM_SWAPPED  (1ULL << 62)
+#define PM_UFFD_WP  (1ULL << 57)
+#define PM_SOFT_DIRTY (1ULL << 55)
+
+static int alloc_private_hugetlb(char **out, size_t len)
+{
+	int fd = syscall(SYS_memfd_create, "hugetlb_swap_test", MFD_HUGETLB);
+	char *p;
+
+	if (fd < 0)
+		ksft_exit_fail_msg("memfd_create(MFD_HUGETLB): %m\n");
+	if (ftruncate(fd, len))
+		ksft_exit_fail_msg("ftruncate: %m\n");
+	p = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (p == MAP_FAILED)
+		ksft_exit_fail_msg("mmap private hugetlb: %m\n");
+	*out = p;
+	return fd;
+}
+
+static unsigned long pagemap_flags(void *addr)
+{
+	uint64_t v = 0;
+	int fd = open("/proc/self/pagemap", O_RDONLY);
+	off_t off = ((uintptr_t)addr / 4096) * sizeof(v);
+
+	if (fd < 0 || pread(fd, &v, sizeof(v), off) != sizeof(v))
+		ksft_exit_fail_msg("read pagemap: %m\n");
+	close(fd);
+	return v;
+}
+
+static void fill_pattern(char *p, size_t len)
+{
+	for (size_t i = 0; i < len; i += 4096)
+		p[i] = (char)(i >> 12) ^ 0x5a;
+}
+
+static int verify_pattern(char *p, size_t len)
+{
+	for (size_t i = 0; i < len; i += 4096)
+		if (p[i] != (char)((i >> 12) ^ 0x5a))
+			return -1;
+	return 0;
+}
+
+static long free_hugepages(void)
+{
+	FILE *f = fopen("/proc/meminfo", "r");
+	char line[256];
+	long v = -1;
+
+	while (f && fgets(line, sizeof(line), f))
+		if (sscanf(line, "HugePages_Free: %ld", &v) == 1)
+			break;
+	if (f)
+		fclose(f);
+	return v;
+}
+
+static long read_meminfo_kb(const char *key)
+{
+	FILE *f = fopen("/proc/meminfo", "r");
+	char line[256];
+	size_t klen = strlen(key);
+	long v = -1;
+
+	while (f && fgets(line, sizeof(line), f))
+		if (!strncmp(line, key, klen))
+			sscanf(line + klen, " %ld", &v);
+	if (f)
+		fclose(f);
+	return v;
+}
+
+/*
+ * mlock is a silent no-op on hugetlb mappings (vma_supports_mlock()
+ * excludes is_vm_hugetlb_page), so VM_LOCKED is never set; use the
+ * "lo" flag in smaps VmFlags to tell whether the vma is really locked.
+ */
+static int vma_has_locked_flag(void *addr)
+{
+	FILE *f = fopen("/proc/self/smaps", "r");
+	char line[512];
+	int in_range = 0, locked = 0;
+
+	while (f && fgets(line, sizeof(line), f)) {
+		unsigned long lo, hi;
+
+		if (sscanf(line, "%lx-%lx", &lo, &hi) == 2)
+			in_range = lo <= (unsigned long)addr && (unsigned long)addr < hi;
+		if (in_range && !strncmp(line, "VmFlags:", 8)) {
+			locked = !!strstr(line, " lo");
+			break;
+		}
+	}
+	if (f)
+		fclose(f);
+	return locked;
+}
+
+/* Prerequisite: >= 'need' free 2M hugepages, otherwise SKIP */
+static void require_pool(long need)
+{
+	long free_hp = free_hugepages();
+
+	if (free_hp < need)
+		ksft_exit_skip("need %ld free hugepages, have %ld\n", need, free_hp);
+}
+
+static void test_pageout_basic(void)
+{
+	char *p;
+	long before, after;
+	int fd;
+
+	require_pool(2);
+	before = free_hugepages();
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("MADV_PAGEOUT: %m\n");
+	else
+		ksft_test_result_pass("MADV_PAGEOUT succeeds\n");
+
+	after = free_hugepages();
+	/* allow slack: pageout should return 1 page */
+	ksft_test_result(after >= before - 1 &&
+					 (pagemap_flags(p) & PM_SWAPPED) &&
+					 !(pagemap_flags(p) & PM_PRESENT),
+					 "pageout returns memory and leaves swap entry\n");
+
+	if (verify_pattern(p, HUGEPAGE_SIZE))     /* faults back in, checks data */
+		ksft_test_result_fail("data corrupt after swapin\n");
+	else
+		ksft_test_result_pass("swapin on fault preserves data\n");
+
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+}
+
+static void test_fork_after_pageout(void)
+{
+	char *p;
+	int fd, status;
+	pid_t pid;
+
+	require_pool(3);
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("pageout: %m\n");
+
+	errno = 0;
+	pid = fork();
+	if (pid < 0) {
+		ksft_test_result_fail("fork#1: %m\n");
+		goto out;
+	}
+	if (pid == 0) {
+		/*
+		 * The child swaps in and verifies the data, then writes a new
+		 * pattern: a shared swap entry is non-exclusive, so the write
+		 * must COW and must not pollute the parent's not-yet-swapped-in
+		 * data.
+		 */
+		if (verify_pattern(p, HUGEPAGE_SIZE))
+			_exit(1);
+		for (size_t i = 0; i < HUGEPAGE_SIZE; i += 4096)
+			p[i] = (char)0xa5;
+		_exit(0);
+	}
+	waitpid(pid, &status, 0);
+	if (!WIFEXITED(status) || WEXITSTATUS(status)) {
+		ksft_test_result_fail("child read wrong data after fork (exit=%d code=%d sig=%d)\n",
+						  WIFEXITED(status),
+						  WIFEXITED(status) ? WEXITSTATUS(status) : -1,
+						  WIFSIGNALED(status) ? WTERMSIG(status) : -1);
+		goto out;
+	}
+	/* Parent swaps in again: the child write must have COWed, data intact */
+	ksft_test_result(verify_pattern(p, HUGEPAGE_SIZE) == 0,
+					 "fork shares swap entry correctly\n");
+
+	/* Child writes (COW after swapin); parent data must not be polluted */
+	pid = fork();
+	if (pid == 0) {
+		for (size_t i = 0; i < HUGEPAGE_SIZE; i += 4096)
+			p[i] = (char)0xa5;
+		_exit(0);
+	}
+	waitpid(pid, &status, 0);
+	ksft_test_result(WIFEXITED(status) && WEXITSTATUS(status) == 0 &&
+					 verify_pattern(p, HUGEPAGE_SIZE) == 0,
+					 "child COW write does not corrupt parent data\n");
+out:
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+}
+
+static void test_munmap_releases_swap(void)
+{
+	char *p;
+	long swap_before, swap_after;
+	int fd, status;
+	pid_t pid;
+
+	require_pool(3);
+	swap_before = read_meminfo_kb("SwapFree:");
+	if (swap_before < (long)(HUGEPAGE_SIZE / 1024))
+		ksft_test_result_skip("no swap space\n");
+
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("pageout: %m\n");
+
+	/*
+	 * Fork a child which drops the mapping without touching the
+	 * page.  Both the parent's and the child's swap PTE reference
+	 * (the fork duplicated the slot reference) must be returned
+	 * to the swap device; a leak leaves the slots allocated.
+	 */
+	errno = 0;
+	pid = fork();
+	if (pid < 0)
+		ksft_test_result_fail("munmap-test fork: %m\n");
+	if (pid == 0) {
+		munmap(p, HUGEPAGE_SIZE);
+		close(fd);
+		_exit(0);
+	}
+	waitpid(pid, &status, 0);
+
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+
+	swap_after = read_meminfo_kb("SwapFree:");
+	ksft_test_result(WIFEXITED(status) && WEXITSTATUS(status) == 0 &&
+					 swap_after >= swap_before - 64,
+					 "munmap/exit releases swapped-out huge page slots (SwapFree %ld->%ld kB)\n",
+					 swap_before, swap_after);
+}
+
+static void test_readfault_munmap_drains_swapcache(void)
+{
+	char *p;
+	long swap_before, swap_after;
+	long free_before, free_after;
+	int fd;
+
+	require_pool(2);
+	swap_before = read_meminfo_kb("SwapFree:");
+	if (swap_before < (long)(HUGEPAGE_SIZE / 1024))
+		ksft_test_result_skip("no swap space\n");
+
+	free_before = free_hugepages();
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("pageout: %m\n");
+
+	/* Read fault: swaps the page in but may keep the swapcache copy. */
+	if (verify_pattern(p, HUGEPAGE_SIZE))
+		ksft_test_result_fail("read-fault swapin data corrupt\n");
+
+	/*
+	 * Dropping the last mapping must drain the swapcache copy and free
+	 * the slots: hugetlb folios sit on no LRU, so without the zap-time
+	 * drain nothing would ever reclaim them (pool page + slots pinned
+	 * until swapoff).
+	 */
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+
+	swap_after = read_meminfo_kb("SwapFree:");
+	free_after = free_hugepages();
+	ksft_test_result(swap_after >= swap_before - 64 &&
+					 free_after >= free_before,
+					 "munmap after read fault drains swapcache (SwapFree %ld->%ld kB, free hugepages %ld->%ld)\n",
+					 swap_before, swap_after, free_before, free_after);
+}
+
+/* Take the first active swap device/file from /proc/swaps */
+static int first_swap_device(char *buf, size_t len)
+{
+	FILE *f = fopen("/proc/swaps", "r");
+	char line[512];
+
+	if (!f)
+		return -1;
+	if (!fgets(line, sizeof(line), f) ||      /* header */
+		!fgets(line, sizeof(line), f)) {
+		fclose(f);
+		return -1;
+	}
+	fclose(f);
+	return sscanf(line, "%255s", buf) == 1 ? 0 : -1;
+}
+
+static void test_swapoff(void)
+{
+	char swapdev[256], cmd[300];
+	char *p;
+	int fd, present;
+
+	if (geteuid())
+		return ksft_test_result_skip("swapoff test needs root\n");
+	if (first_swap_device(swapdev, sizeof(swapdev)))
+		return ksft_test_result_skip("no active swap device\n");
+
+	require_pool(2);
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("pageout: %m\n");
+
+	/*
+	 * swapoff must bring the swapped-out hugetlb page back in and
+	 * succeed.
+	 */
+	snprintf(cmd, sizeof(cmd), "swapoff %s", swapdev);
+	ksft_test_result(system(cmd) == 0,
+					 "swapoff %s succeeds with a swapped-out hugetlb page\n",
+					 swapdev);
+
+	present = (pagemap_flags(p) & PM_PRESENT) &&
+			  !(pagemap_flags(p) & PM_SWAPPED) &&
+			  verify_pattern(p, HUGEPAGE_SIZE) == 0;
+	ksft_test_result(present,
+					 "page present and data intact after swapoff\n");
+
+	/* The swap device is shared with the other test cases. */
+	snprintf(cmd, sizeof(cmd), "swapon %s", swapdev);
+	ksft_test_result(system(cmd) == 0,
+					 "swap device re-enabled for the remaining tests\n");
+
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+}
+
+static const char *nr_hugepages_path = "/proc/sys/vm/nr_hugepages";
+
+static long read_nr_hugepages(void)
+{
+	FILE *f = fopen(nr_hugepages_path, "r");
+	long v = -1;
+
+	if (f) {
+		if (fscanf(f, "%ld", &v) != 1)
+			v = -1;
+		fclose(f);
+	}
+	return v;
+}
+
+static int write_nr_hugepages(long v)
+{
+	FILE *f = fopen(nr_hugepages_path, "w");
+
+	if (!f)
+		return -1;
+	if (fprintf(f, "%ld", v) < 0) {
+		fclose(f);
+		return -1;
+	}
+	return fclose(f);
+}
+
+static sigjmp_buf sigbus_env;
+
+static void sigbus_handler(int sig, siginfo_t *si, void *uctx)
+{
+	siglongjmp(sigbus_env, 1);
+}
+
+/*
+ * Pool-exhaustion swapin contract: swap-out releases the pool page; if
+ * the pool is fully occupied when the swapped-out page is touched again,
+ * the fault must SIGBUS after a bounded retry (never swap in
+ * successfully, never OOM-kill, never fail silently).
+ */
+static void test_swapin_pool_exhausted(void)
+{
+	long saved_nr, cur;
+	int status;
+	pid_t pid;
+
+	if (geteuid())
+		return ksft_test_result_skip("pool exhaustion test needs root\n");
+
+	saved_nr = read_nr_hugepages();
+	if (saved_nr < 2 || write_nr_hugepages(2))
+		return ksft_test_result_skip("cannot set nr_hugepages\n");
+	cur = read_nr_hugepages();
+	if (cur != 2 || free_hugepages() < 2)
+		goto skip_restore;
+
+	pid = fork();
+	if (pid == 0) {
+		struct sigaction sa = { .sa_sigaction = sigbus_handler,
+								.sa_flags = SA_SIGINFO };
+		char *a, *b;
+		int fda, fdb;
+
+		/*
+		 * The child sets up its own scenario; any environment
+		 * mismatch exits with _exit(2) and the parent judges SKIP.
+		 */
+		fda = syscall(SYS_memfd_create, "hst_a", MFD_HUGETLB);
+		fdb = syscall(SYS_memfd_create, "hst_b", MFD_HUGETLB);
+		if (fda < 0 || fdb < 0)
+			_exit(2);
+		/* B must fill the whole pool (2 pages) so A's swapin has no page */
+		if (ftruncate(fda, HUGEPAGE_SIZE) ||
+			ftruncate(fdb, 2 * HUGEPAGE_SIZE))
+			_exit(3);
+		a = mmap(NULL, HUGEPAGE_SIZE, PROT_READ | PROT_WRITE,
+				 MAP_PRIVATE, fda, 0);
+		if (a == MAP_FAILED)
+			_exit(4);
+		fill_pattern(a, HUGEPAGE_SIZE);
+		if (madvise(a, HUGEPAGE_SIZE, MADV_PAGEOUT))
+			_exit(5);
+		/* Only after A's pageout frees its reservation can B fill the pool (2 pages) */
+		b = mmap(NULL, 2 * HUGEPAGE_SIZE, PROT_READ | PROT_WRITE,
+				 MAP_PRIVATE, fdb, 0);
+		if (b == MAP_FAILED)
+			_exit(4);
+		fill_pattern(b, 2 * HUGEPAGE_SIZE);     /* fill the pool */
+		if (free_hugepages() != 0)
+			_exit(6);                       /* pool not full, scenario broken */
+
+		sigaction(SIGBUS, &sa, NULL);
+		if (sigsetjmp(sigbus_env, 1) == 0) {
+			volatile char c = a[0];	/* pool exhausted: swapin must SIGBUS */
+			(void)c;
+			_exit(1);                       /* no SIGBUS: contract violated */
+		}
+		_exit(0);                           /* got SIGBUS: contract holds */
+	}
+	waitpid(pid, &status, 0);
+	if (write_nr_hugepages(saved_nr))
+		ksft_print_msg("WARN: failed to restore nr_hugepages=%ld\n", saved_nr);
+
+	if (WIFEXITED(status) && WEXITSTATUS(status) >= 2)
+		return ksft_test_result_skip("cannot set up exhausted pool (code %d)\n",
+									 WEXITSTATUS(status));
+	ksft_test_result(WIFEXITED(status) && WEXITSTATUS(status) == 0,
+					 "swapin with exhausted pool fails with SIGBUS\n");
+	return;
+
+skip_restore:
+	if (write_nr_hugepages(saved_nr))
+		ksft_print_msg("WARN: failed to restore nr_hugepages=%ld\n", saved_nr);
+	ksft_test_result_skip("cannot shrink pool to 1 page\n");
+}
+
+/*
+ * Memory-failure contract: when a hugetlb folio that still sits in the
+ * swap cache after swapin gets poisoned, me_huge_page must keep it in
+ * the swap cache and the swapin path must intercept it via
+ * folio_test_hwpoison() and SIGBUS the accessor; if the folio were
+ * evicted (the pre-fix behavior), the next access would silently swap
+ * in stale disk data and the pool page would leak permanently.
+ * A poisoned page leaves the pool when reclaimed, so this case must
+ * run last.
+ */
+static void test_hwpoison_swapcache(void)
+{
+	int status;
+	pid_t pid;
+
+	if (geteuid())
+		return ksft_test_result_skip("hwpoison test needs root\n");
+
+	require_pool(2);
+	if (read_meminfo_kb("SwapFree:") < (long)(HUGEPAGE_SIZE / 1024))
+		return ksft_test_result_skip("no swap space\n");
+
+	pid = fork();
+	if (pid == 0) {
+		struct sigaction sa = { .sa_sigaction = sigbus_handler,
+								.sa_flags = SA_SIGINFO };
+		char *a;
+		int fda;
+
+		/*
+		 * The child sets up its own scenario; any environment
+		 * mismatch exits with _exit(>=2) and the parent judges SKIP.
+		 */
+		fda = syscall(SYS_memfd_create, "hst_p", MFD_HUGETLB);
+		if (fda < 0 || ftruncate(fda, HUGEPAGE_SIZE))
+			_exit(2);
+		a = mmap(NULL, HUGEPAGE_SIZE, PROT_READ | PROT_WRITE,
+				 MAP_PRIVATE, fda, 0);
+		if (a == MAP_FAILED)
+			_exit(2);
+		fill_pattern(a, HUGEPAGE_SIZE);
+		if (madvise(a, HUGEPAGE_SIZE, MADV_PAGEOUT))
+			_exit(2);
+		/*
+		 * Read fault swaps back in: the folio is mapped again while a
+		 * copy stays in the swap cache (a read fault does not free the
+		 * swap slot).
+		 */
+		if (verify_pattern(a, HUGEPAGE_SIZE))
+			_exit(2);
+		if (!(pagemap_flags(a) & PM_PRESENT))
+			_exit(2);
+		/*
+		 * Inject poison: mf unmaps the page and reinstalls the swap
+		 * entry.  madvise holds a GUP reference for the whole call, so
+		 * me_huge_page's extra-reference check reports MF_FAILED and an
+		 * EBUSY return is expected (the folio is still kept and marked
+		 * poisoned); EINVAL would mean the kernel lacks
+		 * CONFIG_MEMORY_FAILURE.
+		 */
+		if (madvise(a, HUGEPAGE_SIZE, MADV_HWPOISON) && errno == EINVAL)
+			_exit(3);
+		if ((pagemap_flags(a) & (PM_PRESENT | PM_SWAPPED)) != PM_SWAPPED)
+			_exit(4);                   /* mf did not unmap, scenario broken */
+
+		sigaction(SIGBUS, &sa, NULL);
+		if (sigsetjmp(sigbus_env, 1) == 0) {
+			volatile char c = a[0];     /* swapin must intercept poison: SIGBUS */
+			(void)c;
+			_exit(1);			/* no SIGBUS: folio left the swap cache */
+		}
+		_exit(0);                       /* got SIGBUS: contract holds */
+	}
+	waitpid(pid, &status, 0);
+	if (WIFEXITED(status) && WEXITSTATUS(status) == 3)
+		return ksft_test_result_skip("kernel lacks CONFIG_MEMORY_FAILURE\n");
+	if (WIFEXITED(status) && WEXITSTATUS(status) >= 2)
+		return ksft_test_result_skip("cannot set up hwpoison scenario (code %d)\n",
+									 WEXITSTATUS(status));
+	ksft_test_result(WIFEXITED(status) && WEXITSTATUS(status) == 0,
+					 "poisoned swapcache hugetlb folio kills accessor with SIGBUS\n");
+}
+
+static void test_shared_file_swap(void)
+{
+	char *p;
+	long before, after;
+	int fd;
+
+	require_pool(2);
+	before = free_hugepages();
+	fd = syscall(SYS_memfd_create, "hst", MFD_HUGETLB);
+	if (fd < 0 || ftruncate(fd, HUGEPAGE_SIZE))
+		ksft_exit_fail_msg("setup shared memfd: %m\n");
+	p = mmap(NULL, HUGEPAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (p == MAP_FAILED)
+		ksft_exit_fail_msg("mmap shared hugetlb: %m\n");
+	fill_pattern(p, HUGEPAGE_SIZE);
+
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("shared MADV_PAGEOUT: %m\n");
+	else
+		ksft_test_result_pass("shared MADV_PAGEOUT succeeds\n");
+
+	after = free_hugepages();
+	/* File pageout only clears the PTE: pagemap is neither PRESENT nor SWAPPED */
+	ksft_test_result(after >= before - 1 /* pageout should return 1 page */ &&
+					 !(pagemap_flags(p) & PM_PRESENT) &&
+					 !(pagemap_flags(p) & PM_SWAPPED),
+					 "shared pageout returns memory, PTE cleared (no swap entry)\n");
+
+	/* read(2) path: no fault, swap in via the anchor and check data */
+	{
+		char *buf = malloc(HUGEPAGE_SIZE);
+		ssize_t n = pread(fd, buf, HUGEPAGE_SIZE, 0);
+
+		ksft_test_result(n == (ssize_t)HUGEPAGE_SIZE &&
+						 verify_pattern(buf, HUGEPAGE_SIZE) == 0,
+						 "shared read(2) swaps in and preserves data\n");
+		free(buf);
+	}
+
+	/* Page out again after swapin: the anchor must be re-creatable */
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("second shared MADV_PAGEOUT: %m\n");
+	else
+		ksft_test_result_pass("second shared MADV_PAGEOUT succeeds\n");
+	ksft_test_result(verify_pattern(p, HUGEPAGE_SIZE) == 0,
+					 "second shared swapin on fault preserves data\n");
+
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+}
+
+static void test_truncate_after_pageout(void)
+{
+	char *p;
+	long swap_before, swap_after;
+	int fd;
+
+	require_pool(2);
+	swap_before = read_meminfo_kb("SwapFree:");
+	if (swap_before < (long)(HUGEPAGE_SIZE / 1024))
+		ksft_test_result_skip("no swap space\n");
+
+	fd = syscall(SYS_memfd_create, "hst", MFD_HUGETLB);
+	if (fd < 0 || ftruncate(fd, HUGEPAGE_SIZE))
+		ksft_exit_fail_msg("setup shared memfd: %m\n");
+	p = mmap(NULL, HUGEPAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (p == MAP_FAILED)
+		ksft_exit_fail_msg("mmap shared hugetlb: %m\n");
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("pageout: %m\n");
+
+	/* Truncate frees the anchor and the swap slots: SwapFree back to baseline */
+	if (ftruncate(fd, 0))
+		ksft_test_result_fail("truncate: %m\n");
+	swap_after = read_meminfo_kb("SwapFree:");
+	ksft_test_result(swap_after >= swap_before - 64,
+					 "truncate frees swap anchor and slots (SwapFree %ld->%ld kB)\n",
+					 swap_before, swap_after);
+
+	/* i_size is now 0: touching the mapping must SIGBUS */
+	{
+		struct sigaction sa = { .sa_sigaction = sigbus_handler,
+								.sa_flags = SA_SIGINFO };
+		struct sigaction old_sa;
+
+		sigaction(SIGBUS, &sa, &old_sa);
+		if (sigsetjmp(sigbus_env, 1)) {
+			ksft_test_result_pass("access after truncate raises SIGBUS\n");
+		} else {
+			volatile char c = p[0];
+
+			(void)c;
+			ksft_test_result_fail("access after truncate did not SIGBUS\n");
+		}
+		sigaction(SIGBUS, &old_sa, NULL);
+	}
+
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+}
+
+static void test_reject_paths(void)
+{
+	char *p;
+	int fd;
+
+	require_pool(3);
+
+	/* VM_LOCKED -> EINVAL (SKIP if mlock is a no-op on hugetlb) */
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (mlock(p, HUGEPAGE_SIZE)) {
+		ksft_test_result_skip("mlock unavailable: %m\n");
+	} else if (!vma_has_locked_flag(p)) {
+		munlock(p, HUGEPAGE_SIZE);
+		ksft_test_result_skip("mlock is a no-op on hugetlb mappings\n");
+	} else {
+		errno = 0;
+		ksft_test_result(madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT) == -1 &&
+						 errno == EINVAL,
+						 "locked mapping rejected with EINVAL\n");
+		munlock(p, HUGEPAGE_SIZE);
+	}
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+
+	/* userfaultfd-registered -> EINVAL (SKIP the sub-case if uffd unavailable) */
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	{
+		int uffd = syscall(SYS_userfaultfd, O_CLOEXEC);
+		struct uffdio_api api = { .api = UFFD_API };
+		struct uffdio_register reg;
+		int registered = 0;
+
+		if (uffd >= 0 && !ioctl(uffd, UFFDIO_API, &api)) {
+			memset(&reg, 0, sizeof(reg));
+			reg.range.start = (unsigned long)p;
+			reg.range.len = HUGEPAGE_SIZE;
+			reg.mode = UFFDIO_REGISTER_MODE_MISSING;
+			registered = !ioctl(uffd, UFFDIO_REGISTER, &reg);
+		}
+		if (!registered) {
+			ksft_test_result_skip("uffd register unsupported\n");
+		} else {
+			errno = 0;
+			ksft_test_result(madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT) == -1 &&
+							 errno == EINVAL,
+							 "uffd-registered mapping rejected with EINVAL\n");
+		}
+		if (uffd >= 0)
+			close(uffd);
+	}
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+
+	/* 1G hstate -> EINVAL (SKIP the sub-case if no free 1G page) */
+	{
+		FILE *f = fopen("/sys/kernel/mm/hugepages/hugepages-1048576kB/free_hugepages", "r");
+		long free1g = 0;
+
+		if (f) {
+			if (fscanf(f, "%ld", &free1g) != 1)
+				free1g = 0;
+			fclose(f);
+		}
+		if (free1g < 1) {
+			ksft_test_result_skip("no free 1G hugepages\n");
+		} else {
+			p = mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
+					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
+					 (30 << MAP_HUGE_SHIFT), -1, 0);
+			if (p == MAP_FAILED) {
+				ksft_test_result_skip("cannot mmap 1G hugepage: %m\n");
+			} else {
+				p[0] = 1;
+				errno = 0;
+				ksft_test_result(madvise(p, 1UL << 30, MADV_PAGEOUT) == -1 &&
+								 errno == EINVAL,
+								 "gigantic hstate rejected with EINVAL\n");
+				munmap(p, 1UL << 30);
+			}
+		}
+	}
+}
+
+static void test_mprotect_mremap_smoke(void)
+{
+	char *p, *q;
+	int fd;
+
+	require_pool(2);
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("pageout: %m\n");
+
+	/* mprotect must not corrupt the swap entry encoding */
+	ksft_test_result(!mprotect(p, HUGEPAGE_SIZE, PROT_READ) &&
+					 !mprotect(p, HUGEPAGE_SIZE, PROT_READ | PROT_WRITE) &&
+					 (pagemap_flags(p) & PM_SWAPPED) &&
+					 !(pagemap_flags(p) & PM_PRESENT),
+					 "mprotect preserves swap entry\n");
+
+	q = mremap(p, HUGEPAGE_SIZE, HUGEPAGE_SIZE, MREMAP_MAYMOVE);
+	if (q == MAP_FAILED) {
+		ksft_test_result_fail("mremap: %m\n");
+		munmap(p, HUGEPAGE_SIZE);
+		close(fd);
+		return;
+	}
+	ksft_test_result((pagemap_flags(q) & PM_SWAPPED) &&
+					 verify_pattern(q, HUGEPAGE_SIZE) == 0,
+					 "mremap moves swap entry, data intact\n");
+	munmap(q, HUGEPAGE_SIZE);
+	close(fd);
+}
+
+static long read_vmswap_kb(void)
+{
+	FILE *f = fopen("/proc/self/status", "r");
+	char line[256];
+	long v = -1;
+
+	while (f && fgets(line, sizeof(line), f))
+		if (sscanf(line, "VmSwap: %ld kB", &v) == 1)
+			break;
+	if (f)
+		fclose(f);
+	return v;
+}
+
+/*
+ * ksft_finished() requires plan == number of results, so skip paths
+ * must also fill in their counts; otherwise the whole binary FAILs on
+ * a plan mismatch when the environment is unsuitable.
+ */
+static void skip_results(int n, const char *msg)
+{
+	for (int i = 0; i < n; i++)
+		ksft_test_result_skip("%s", msg);
+}
+
+/*
+ * MM_SWAPENTS accounting contract (readable via VmSwap):
+ * +N at pageout, +N at fork (charged to the child), -N at swapin/zap,
+ * with N = number of small pages per huge page.  A mistake in any step
+ * is a leak or a double count.
+ */
+static void test_vmswap_accounting(void)
+{
+	char *p;
+	long v0, v1;
+	int fd, status;
+	pid_t pid;
+
+	require_pool(2);
+	if (read_meminfo_kb("SwapFree:") < (long)(HUGEPAGE_SIZE / 1024))
+		return skip_results(5, "no swap space\n");
+
+	v0 = read_vmswap_kb();
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("pageout: %m\n");
+
+	v1 = read_vmswap_kb();
+	ksft_test_result(v1 == v0 + (long)(HUGEPAGE_SIZE / 1024),
+					 "VmSwap +%lu kB at pageout (%ld -> %ld kB)\n",
+					 HUGEPAGE_SIZE / 1024, v0, v1);
+
+	/*
+	 * fork duplicates the slot reference: the child sees the same
+	 * VmSwap; its exit does not change the parent.
+	 */
+	pid = fork();
+	if (pid < 0) {
+		ksft_test_result_fail("vmswap-test fork: %m\n");
+	} else {
+		if (pid == 0)
+			_exit(read_vmswap_kb() == v1 ? 0 : 1);  /* must not touch p */
+		if (waitpid(pid, &status, 0) != pid)
+			ksft_test_result_fail("waitpid: %m\n");
+		else
+			ksft_test_result(WIFEXITED(status) && WEXITSTATUS(status) == 0 &&
+							 read_vmswap_kb() == v1,
+							 "fork duplicates swap count, parent unchanged after child exit\n");
+	}
+
+	/*
+	 * Swapin returns the count: VmSwap back to baseline (the slots may
+	 * survive as swapcache residue, but the count is already returned).
+	 */
+	if (verify_pattern(p, HUGEPAGE_SIZE))
+		ksft_test_result_fail("data corrupt after swapin\n");
+	ksft_test_result(read_vmswap_kb() == v0,
+					 "VmSwap back to baseline after swapin (%ld kB)\n",
+					 read_vmswap_kb());
+
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+
+	/*
+	 * munmap right after pageout (no swapin): zap must return the
+	 * MM_SWAPENTS count.  Regression test: the zap path once
+	 * zero-extended -pages_per_huge_page() (unsigned) to +2^32 and
+	 * blew up VmSwap.
+	 */
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("second pageout: %m\n");
+	ksft_test_result(read_vmswap_kb() == v0 + (long)(HUGEPAGE_SIZE / 1024),
+					 "VmSwap +%lu kB after second pageout\n",
+					 HUGEPAGE_SIZE / 1024);
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+	ksft_test_result(read_vmswap_kb() == v0,
+					 "munmap of swapped-out page drops VmSwap back to baseline (%ld kB)\n",
+					 read_vmswap_kb());
+}
+
+/*
+ * Soft-dirty bit end to end: present PTE -> swap entry (carried by
+ * swp_pte_prepare at pageout) -> back to a present PTE at swapin.
+ *
+ * Note that pagemap reports PM_SOFT_DIRTY for a hugetlb present PTE
+ * from the VMA's VM_SOFTDIRTY flag rather than the PTE bit; only the
+ * swap-entry branch reports the bit in the entry itself.  So use
+ * clear_refs to drop VM_SOFTDIRTY and isolate the entry/PTE bit
+ * (clear_refs' pte walk does not touch hugetlb PTEs, leaving the entry
+ * bit alone).
+ */
+static void test_soft_dirty_swap(void)
+{
+	char *p;
+	int fd, cr;
+
+	require_pool(2);
+	if (read_meminfo_kb("SwapFree:") < (long)(HUGEPAGE_SIZE / 1024))
+		return skip_results(4, "no swap space\n");
+
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+
+	/* A fresh mapping's PTE is soft-dirty (VMA defaults to VM_SOFTDIRTY) */
+	ksft_test_result(pagemap_flags(p) & PM_SOFT_DIRTY,
+					 "fresh hugetlb page is soft-dirty\n");
+
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("pageout: %m\n");
+	ksft_test_result((pagemap_flags(p) & PM_SWAPPED) &&
+					 (pagemap_flags(p) & PM_SOFT_DIRTY),
+					 "swap entry carries soft-dirty bit\n");
+
+	cr = open("/proc/self/clear_refs", O_WRONLY);
+	if (cr < 0 || write(cr, "4", 1) != 1) {
+		if (cr >= 0)
+			close(cr);
+		skip_results(2, "clear_refs unavailable\n");
+		goto out;
+	}
+	close(cr);
+	/* VM_SOFTDIRTY cleared: PM_SOFT_DIRTY here can only come from the swap entry itself */
+	ksft_test_result((pagemap_flags(p) & PM_SWAPPED) &&
+					 (pagemap_flags(p) & PM_SOFT_DIRTY),
+					 "swap entry soft-dirty bit survives clear_refs\n");
+
+	/*
+	 * Swapin carries the swp bit back to the present PTE (invisible to
+	 * pagemap); the next pageout's swp_pte_prepare reads the PTE bit to
+	 * rebuild the entry -- if swapin dropped the bit, PM_SOFT_DIRTY
+	 * would be absent here.
+	 */
+	if (verify_pattern(p, HUGEPAGE_SIZE))
+		ksft_test_result_fail("data corrupt after swapin\n");
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("second pageout: %m\n");
+	ksft_test_result((pagemap_flags(p) & PM_SWAPPED) &&
+					 (pagemap_flags(p) & PM_SOFT_DIRTY),
+					 "soft-dirty bit survives swapin and second pageout\n");
+
+	verify_pattern(p, HUGEPAGE_SIZE);   /* swap back to present, then clean up */
+out:
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+}
+
+struct wp_monitor_arg {
+	int uffd;
+	unsigned long start;
+	size_t len;
+	int ok;
+};
+
+/*
+ * Monitor: wait for a WP fault event, verify the WP flag, then unprotect
+ * to release the faulting thread.
+ */
+static void *wp_monitor(void *arg)
+{
+	struct wp_monitor_arg *a = arg;
+	struct pollfd pfd = { .fd = a->uffd, .events = POLLIN };
+	struct uffdio_writeprotect wp = {};
+	struct uffd_msg msg;
+	int event_ok = 0, unprotect_ok = 0;
+
+	a->ok = 0;
+	if (poll(&pfd, 1, 5000) <= 0)
+		/* no event: the write was not intercepted, main thread done */
+		return NULL;
+	if (read(a->uffd, &msg, sizeof(msg)) == sizeof(msg) &&
+		msg.event == UFFD_EVENT_PAGEFAULT &&
+		(msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP))
+		event_ok = 1;
+	/*
+	 * The event has been consumed and the main thread is blocked in the
+	 * fault waiting for unprotect; the unprotect must happen no matter
+	 * whether the event content matched, otherwise the main thread
+	 * hangs forever.
+	 */
+	wp.range.start = a->start;
+	wp.range.len = a->len;
+	wp.mode = 0;
+	unprotect_ok = !ioctl(a->uffd, UFFDIO_WRITEPROTECT, &wp);
+	a->ok = event_ok && unprotect_ok;
+	return NULL;
+}
+
+/*
+ * uffd-wp vs swap entry:
+ * register the uffd WP mode after pageout (the order cannot be flipped:
+ * an armed VMA is rejected by MADV_PAGEOUT), UFFDIO_WRITEPROTECT must
+ * be able to set the wp bit through the swap entry (the
+ * change_protection contract), swapin carries the wp bit back to the
+ * present PTE, and the following write fault must deliver a WP event
+ * to the monitor.
+ */
+static void test_uffd_wp_swap(void)
+{
+	char *p;
+	int fd, uffd;
+	pthread_t mon;
+	struct wp_monitor_arg arg;
+	struct uffdio_api api = { .api = UFFD_API };
+	struct uffdio_register reg = {};
+	struct uffdio_writeprotect wp = {};
+
+	require_pool(2);
+	if (read_meminfo_kb("SwapFree:") < (long)(HUGEPAGE_SIZE / 1024))
+		return skip_results(4, "no swap space\n");
+
+	fd = alloc_private_hugetlb(&p, HUGEPAGE_SIZE);
+	fill_pattern(p, HUGEPAGE_SIZE);
+	if (madvise(p, HUGEPAGE_SIZE, MADV_PAGEOUT))
+		ksft_test_result_fail("pageout: %m\n");
+
+	uffd = syscall(SYS_userfaultfd, O_CLOEXEC);
+	if (uffd < 0) {
+		skip_results(4, "userfaultfd unavailable\n");
+		goto out;
+	}
+	reg.range.start = (unsigned long)p;
+	reg.range.len = HUGEPAGE_SIZE;
+	reg.mode = UFFDIO_REGISTER_MODE_WP;
+	if (ioctl(uffd, UFFDIO_API, &api) || ioctl(uffd, UFFDIO_REGISTER, &reg)) {
+		skip_results(4, "uffd WP register on hugetlb unsupported\n");
+		goto out_uffd;
+	}
+
+	/*
+	 * Write-protect through the swap entry: only the uffd-wp bit may
+	 * change, the entry encoding must survive.
+	 */
+	wp.range.start = (unsigned long)p;
+	wp.range.len = HUGEPAGE_SIZE;
+	wp.mode = UFFDIO_WRITEPROTECT_MODE_WP;
+	if (ioctl(uffd, UFFDIO_WRITEPROTECT, &wp))
+		ksft_test_result_fail("UFFDIO_WRITEPROTECT: %m\n");
+	ksft_test_result((pagemap_flags(p) & PM_UFFD_WP) &&
+					 (pagemap_flags(p) & PM_SWAPPED) &&
+					 !(pagemap_flags(p) & PM_PRESENT),
+					 "uffd-wp bit set on swap entry\n");
+
+	/* Read fault swapin: the wp bit comes back with the present PTE, data intact */
+	if (verify_pattern(p, HUGEPAGE_SIZE))
+		ksft_test_result_fail("swapin data corrupt under uffd-wp\n");
+	ksft_test_result((pagemap_flags(p) & PM_PRESENT) &&
+					 (pagemap_flags(p) & PM_UFFD_WP),
+					 "swapin carries uffd-wp bit to present PTE\n");
+
+	/*
+	 * The write fault is blocked by the wp bit and raises an event;
+	 * the write completes once the monitor unprotects.
+	 */
+	arg.uffd = uffd;
+	arg.start = (unsigned long)p;
+	arg.len = HUGEPAGE_SIZE;
+	arg.ok = 0;
+	if (pthread_create(&mon, NULL, wp_monitor, &arg)) {
+		ksft_test_result_fail("pthread_create: %m\n");
+		skip_results(1, "no monitor thread\n");
+		goto out_uffd;
+	}
+	p[0] = 0x11;
+	pthread_join(mon, NULL);
+	ksft_test_result(arg.ok && p[0] == 0x11,
+					 "write fault raises uffd-wp event, write completes after unprotect\n");
+	ksft_test_result(!(pagemap_flags(p) & PM_UFFD_WP),
+					 "unprotect clears uffd-wp bit\n");
+
+out_uffd:
+	close(uffd);
+out:
+	munmap(p, HUGEPAGE_SIZE);
+	close(fd);
+}
+
+int main(void)
+{
+	ksft_print_header();
+	/*
+	 * Nearly all cases depend on swap-out; SKIP wholesale without
+	 * swap (run_vmtests friendly).
+	 */
+	if (read_meminfo_kb("SwapTotal:") <= 0)
+		ksft_exit_skip("no swap configured\n");
+	ksft_set_plan(37);
+	test_pageout_basic();
+	test_fork_after_pageout();
+	test_munmap_releases_swap();
+	test_readfault_munmap_drains_swapcache();
+	test_swapoff();
+	test_swapin_pool_exhausted();
+	test_shared_file_swap();
+	test_truncate_after_pageout();
+	test_reject_paths();
+	test_mprotect_mremap_smoke();
+	test_vmswap_accounting();
+	test_soft_dirty_swap();
+	test_uffd_wp_swap();
+	test_hwpoison_swapcache();
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384e..7e1dfa619b89 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -266,6 +266,8 @@ CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
 CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
 CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
+# needs a swap device and free 2M hugepages; skips cleanly without either
+CATEGORY="hugetlb" run_test ./hugetlb_swap
 
 if test_selected "hugetlb"; then
 	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"	  | tap_prefix
-- 
2.53.0



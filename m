Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0244C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82DD6B00A5; Fri, 24 Jul 2026 18:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33E76B00A6; Fri, 24 Jul 2026 18:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24936B00A7; Fri, 24 Jul 2026 18:30:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 716B86B00A5
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F26691401E4
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:25 +0000 (UTC)
X-FDA: 85025115210.02.7A7D3CB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F438140002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=j9VXakYJ;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoasW0kcbLRMqvkHf+Serx6XJgI4VH5CVkhXEbwylBk=;
	b=s2tTIKqr7WeHxZfmh6LQepzjzvHN0KlelGXwugMCaePTSuy3t3OEiTE6rI4XpxSNugaSmS
	IymHWETkkttrvrgwaA4mCZGtPde6+8Tp3KioC0K2y8Xy89qExhgQU5EF2K2i/yv4dspDs6
	7h6JGSVL2+OpiftSmkt+i0hESEHmrGE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932224;
	b=Xwi33TqRue9CGQM3eJHYsfvv2csOnvGOa5EjUmwiszfjhsb5CJ/0GvwpRmVlKwBlbt6IC/
	JNVPXck99V3ePxFkRLe06ioRrpl68HxhAY9mZnDa5keeP9YzVUEmvV0Dp+qOlJjx9+fXdw
	GHsYhFwmQvXXw4Uwt1ov5QqogFoqq5Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=j9VXakYJ;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QoasW0kcbLRMqvkHf+Serx6XJgI4VH5CVkhXEbwylBk=; b=j9VXakYJJ/PDqAUv2OdbSq8VPc
	aERUc+tTW4sVfW6m5IUzJR0guy+ydhBDDxWUluYcqM7Ez8y6hdimGk6KrqTs70NkVhRpuwOoHQNTu
	ZZFPqJl8o4utuNCC6WlF8tlaR4Ubj2Tjw00gPLLHnWPX6qdCkT0AxX0w/OqaGqTOFzfZw4nZdfstu
	xLIJ5Fcem+GwhEfkimifB3M4xGgfxPk59FCH6H7OwCGjg9ldqWmBsf0njYcEjFIuLlHsJL3NFrnli
	2ZWQkHIA+9Gx53I7ymyXSAOSVoUw9mxYolW5RZrDGQtBj1iyOyEb8mGiLC/FUEeMRVyh2lwbiF3Ba
	jEqHE4Ig==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-2FDa;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC v4 12/12] selftests/mm: add a slow-GUP content and COW test for mTHP
Date: Fri, 24 Jul 2026 18:29:34 -0400
Message-ID: <20260724222934.1463812-13-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F438140002
X-Stat-Signature: 1uuetqfos6pgsz7k65x6fmarnok1fwqe
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784932224-550581
X-HE-Meta: U2FsdGVkX1/fgr56RAKSlU9oq710mJAPuzomRQFS3KfFlKG339nubtF67aI0v2eOfX03K6rE6ESI4sgrxewYjexd5oOuH2yKvsFZhsy7eSwXmFKfZuV54n3r9GwZpE4eUETR5y1S4fUPSFNwQsalGKCzwXtaRNy3GFAIUif7cyTkvhkAXXAUXLV/lnT1qtltC+Nez1qjIBJaN8RMKCWXKfFd1T3Z8RKv120UvKCcTClkpMPeYLNJq7wMCLSTlO0ts6Lx/s+X34Hd7H6aZXHP20DlC01I8ovpI6xWdx0+eyCpVZd0XO/oBvD5koRRme7jplCABsATjczzdcBXVRUTg/3VNFB7/NoivSxC7Fy35n2AfpyJoQQfAh3heBlbU0HrbFeuryAC3FE1B+mLbeazLNBvWbcJank4Tr0ni2PUynCirQftSdfBsEzDvSd3ZaH/VbBwbJ1+GNnR2XwBxK2sv96I68PjX3Q+944kL2VPW7CGXY0QRbTiirVyC9RZO9cyVBk9C2mifnvbRX45sX3X+RJPZBPD+JEP7HnAgbYzNUMwdTjAtkmXlb9VeGrEqONBABr+brj0u1MuaNjMz82Co7N6S7o3FqvrB7agFpJJDRCflnvexYL00CMZSXXP2XBfpbB622MCzunBI3DEavR+0BdL0sTLrR4Pr2vqoGb5k3uCAP6gFGtnJTaWKsbX9nod0wJC2UBUuVQG+iVVGvvqRgk62tt/yx/vzhqH8NpT0IwbF4Es76TAzOzNlOLE+hkOg5VrlIB3E6uKdVK93NVNLtBqsmKjxympjHZZeH/5pdpVfXUkwE6miU4U+GoKe4D+ZffVcdOa+sAQi8MWIVWTLkVhS+E29di+JcGOpsRaya01cyYjs12Dh5ro9l7qBQLyFakavSEqFxYO4WTo8qA9NiDTDwVsMLAcU9eIiJdOiKcZSfwRVLpgsjhFib5Ij0yos1puV0bmmXFY1pbyxy+
 3R0bbG4s
 zqR3UQS7zwvWEIRPRYPmrJSPlPQ1U5fkM9nnrKIamPSENKZGnrS31Z6Xe6RKhombfVFRNKqZFkgM9qBvf0erhkyUw2ljSzjIKDYcPB58iJad8fkVCTD2MIyfomTvAznRrhO77hd8Y+sd7gizxlLMbvFaOdMuBvQxSnBKs33bxUd2sDIyCEXBOrRj1sJlrAOxX24DgKBE9P6RiUmXakMPqGMRlQoexlgsbonO2+8oo0FJenTzEbcuh52YQy3dB6W13cb/ISAfdksaLd9vMVfpq5pmNYqyDV9cnrNDViIbcy9f75gd1ouqT3sLfYESsbYBspOX1tCGvnlcBzCvMdw2cy1QtQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

follow_page_mask() now batches a PTE-mapped large folio (mTHP) into one
contiguous run for the slow get_user_pages() path. A mis-batched run would
hand back the wrong pages or a stale COW copy, which the existing tests do
not catch: gup_test checks only pin/unpin integrity, and cow exercises COW
mostly at PMD size.

Add mthp_gup_cow_test. It forces 64kB-only mTHP, writes a per-page-distinct
pattern, then pins the region on the slow path (PIN_LONGTERM without
USE_FAST) and compares the bytes the kernel copies back from the pinned
pages against that pattern.

The test covers a read pin, a write pin, and COW after fork(): a child
write-pins to force per-page unshare and checks the copied contents, then
rewrites its copy while the parent verifies its own contents are intact.

It also reports how many pages sit in contiguous large-folio runs, so a
kernel without mTHP shows light coverage rather than passing vacuously.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/mthp_gup_cow_test.c  | 213 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   1 +
 3 files changed, 215 insertions(+)
 create mode 100644 tools/testing/selftests/mm/mthp_gup_cow_test.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971..6b917a4f73e0 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -83,6 +83,7 @@ TEST_GEN_FILES += mrelease_test
 TEST_GEN_FILES += mremap_dontunmap
 TEST_GEN_FILES += mremap_test
 TEST_GEN_FILES += mseal_test
+TEST_GEN_FILES += mthp_gup_cow_test
 TEST_GEN_FILES += on-fault-limit
 TEST_GEN_FILES += pagemap_ioctl
 TEST_GEN_FILES += pfnmap
diff --git a/tools/testing/selftests/mm/mthp_gup_cow_test.c b/tools/testing/selftests/mm/mthp_gup_cow_test.c
new file mode 100644
index 000000000000..52ee329d8641
--- /dev/null
+++ b/tools/testing/selftests/mm/mthp_gup_cow_test.c
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Verify that the slow GUP path (pin_user_pages -> follow_page_mask ->
+ * follow_pte_batch) returns the correct pages for a PTE-mapped large folio
+ * (mTHP), including that COW copies produce the right content.
+ *
+ * Uses the CONFIG_GUP_TEST PIN_LONGTERM interface: START pins a range on the
+ * slow path, READ copies the pinned pages' bytes back so we can compare them
+ * against the pattern we wrote.
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdint.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <errno.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+#include <linux/types.h>
+
+#define ARRAY_SIZE(a)	(sizeof(a) / sizeof((a)[0]))
+
+#define GUP_DEV "/sys/kernel/debug/gup_test"
+
+#define PIN_LONGTERM_TEST_START	_IOW('g', 7, struct pin_longterm_test)
+#define PIN_LONGTERM_TEST_STOP	_IO('g', 8)
+#define PIN_LONGTERM_TEST_READ	_IOW('g', 9, __u64)
+#define USE_WRITE	1
+#define USE_FAST	2
+
+struct pin_longterm_test {
+	__u64 addr;
+	__u64 size;
+	__u32 flags;
+};
+
+#define ORDER_KB	64
+#define NR_FOLIOS	16
+#define REGION		((size_t)ORDER_KB * 1024 * NR_FOLIOS)
+
+static long PS;
+static int fails;
+static int tap;
+
+static void ok(int cond, const char *desc)
+{
+	printf("%s %d %s\n", cond ? "ok" : "not ok", ++tap, desc);
+	if (!cond)
+		fails++;
+}
+
+/* Deterministic, per-page-distinct pattern so any mis-order or leak shows. */
+static void fill(char *base, size_t sz, uint32_t salt)
+{
+	for (size_t off = 0; off < sz; off += PS) {
+		uint32_t k = off / PS;
+		uint64_t v = ((uint64_t)salt << 32) ^ (k * 0x9E3779B1u + 0x1234);
+
+		for (size_t i = 0; i < PS; i += sizeof(v))
+			memcpy(base + off + i, &v, sizeof(v));
+	}
+}
+
+static int wsysfs(const char *path, const char *val)
+{
+	int fd = open(path, O_WRONLY);
+
+	if (fd < 0)
+		return -1;
+	int r = write(fd, val, strlen(val));
+
+	close(fd);
+	return r < 0 ? -1 : 0;
+}
+
+/* Force sub-PMD 64kB mTHP only, so faults produce PTE-mapped large folios. */
+static void setup_mthp(void)
+{
+	const char *thp = "/sys/kernel/mm/transparent_hugepage";
+	char p[256];
+	static const int kb[] = { 16, 32, 64, 128, 256, 512, 1024, 2048 };
+
+	wsysfs("/sys/kernel/mm/transparent_hugepage/enabled", "never");
+	for (unsigned int i = 0; i < ARRAY_SIZE(kb); i++) {
+		snprintf(p, sizeof(p), "%s/hugepages-%dkB/enabled", thp, kb[i]);
+		wsysfs(p, kb[i] == ORDER_KB ? "always" : "never");
+	}
+}
+
+/* Count how many pages sit in a contiguous >=ORDER_KB PFN run (via pagemap). */
+static int count_large_pages(char *base, size_t sz)
+{
+	int pm = open("/proc/self/pagemap", O_RDONLY);
+	size_t n = sz / PS, large = 0;
+	uint64_t *pfn = calloc(n, sizeof(*pfn));
+
+	if (pm < 0)
+		return -1;
+	for (size_t k = 0; k < n; k++) {
+		uint64_t ent;
+		off_t idx = ((uintptr_t)base + k * PS) / PS * sizeof(ent);
+
+		if (pread(pm, &ent, sizeof(ent), idx) != sizeof(ent) ||
+		    !(ent & (1ULL << 63)))
+			pfn[k] = 0;
+		else
+			pfn[k] = ent & ((1ULL << 55) - 1);
+	}
+	close(pm);
+	for (size_t k = 0; k < n; k++)
+		if (k + 1 < n && pfn[k] && pfn[k + 1] == pfn[k] + 1)
+			large++;
+	free(pfn);
+	return large;
+}
+
+/* Pin @base..@sz on the slow path, read the pinned bytes back, compare to exp. */
+static int pin_verify(int fd, char *base, size_t sz, uint32_t wr, char *exp)
+{
+	struct pin_longterm_test a = {
+		.addr = (uintptr_t)base, .size = sz,
+		.flags = wr ? USE_WRITE : 0,		/* USE_FAST unset => slow */
+	};
+	char *got = mmap(NULL, sz, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	__u64 ga = (uintptr_t)got;
+	int rc = -1;
+
+	if (got == MAP_FAILED)
+		return -1;
+	if (ioctl(fd, PIN_LONGTERM_TEST_START, &a)) {
+		fprintf(stderr, "START(%s) failed: %s\n",
+			wr ? "write" : "read", strerror(errno));
+		goto out;
+	}
+	if (ioctl(fd, PIN_LONGTERM_TEST_READ, &ga)) {
+		fprintf(stderr, "READ failed: %s\n", strerror(errno));
+		ioctl(fd, PIN_LONGTERM_TEST_STOP);
+		goto out;
+	}
+	ioctl(fd, PIN_LONGTERM_TEST_STOP);
+	rc = memcmp(got, exp, sz) ? 1 : 0;
+out:
+	munmap(got, sz);
+	return rc;
+}
+
+int main(void)
+{
+	PS = sysconf(_SC_PAGESIZE);
+	setup_mthp();
+
+	int fd = open(GUP_DEV, O_RDWR);
+
+	if (fd < 0) {
+		fprintf(stderr, "open %s: %s (CONFIG_GUP_TEST?)\n",
+			GUP_DEV, strerror(errno));
+		return 2;
+	}
+
+	char *r = mmap(NULL, REGION, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (r == MAP_FAILED) {
+		perror("mmap");
+		return 2;
+	}
+	fill(r, REGION, 0xA1);				/* pattern P */
+	char *expP = malloc(REGION);
+
+	memcpy(expP, r, REGION);
+
+	int large = count_large_pages(r, REGION);
+
+	printf("# %d/%zu pages in contiguous large-folio runs\n",
+	       large, REGION / PS);
+	if (large < (int)(REGION / PS) / 4)
+		printf("# WARN: little mTHP backing; batch path lightly covered\n");
+
+	/* A: read pin over writable mTHP -> batches -> content must equal P. */
+	ok(pin_verify(fd, r, REGION, 0, expP) == 0,
+	   "slow read-pin of mTHP returns correct contents");
+
+	/* B: write pin -> FOLL_WRITE batch path -> content must equal P. */
+	ok(pin_verify(fd, r, REGION, 1, expP) == 0,
+	   "slow write-pin of mTHP returns correct contents");
+
+	/* C: COW isolation. Child write-pins (unshares) then rewrites; parent P. */
+	pid_t pid = fork();
+
+	if (pid == 0) {
+		int cfd = open(GUP_DEV, O_RDWR);
+		int a = pin_verify(cfd, r, REGION, 1, expP);	/* COW copy == P */
+
+		fill(r, REGION, 0xB2);			/* child writes Q */
+		_exit(a == 0 ? 0 : 1);
+	}
+	int st = 0;
+
+	waitpid(pid, &st, 0);
+	ok(WIFEXITED(st) && WEXITSTATUS(st) == 0,
+	   "child write-pin after COW returns correct (copied) contents");
+	ok(memcmp(r, expP, REGION) == 0,
+	   "parent contents intact after child COW writes");
+	/* D: parent read-pin again after the COW split still correct. */
+	ok(pin_verify(fd, r, REGION, 0, expP) == 0,
+	   "parent slow read-pin after COW still correct");
+
+	printf("# totals: pass:%d fail:%d\n", tap - fails, fails);
+	return fails ? 1 : 0;
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8c296dedf047..b49a3eb0c205 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -289,6 +289,7 @@ fi
 # Dump pages 0, 19, and 4096, using pin_user_pages:
 CATEGORY="gup_test" run_test ./gup_test -ct -F 0x1 0 19 0x1000
 CATEGORY="gup_test" run_test ./gup_longterm
+CATEGORY="gup_test" run_test ./mthp_gup_cow_test
 
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
 uffd_stress_bin=./uffd-stress
-- 
2.53.0-Meta



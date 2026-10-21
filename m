Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4D0D606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nqmoVkDO
Received: by kanga.kvack.org (Postfix)
	id C8FC66B0781; Wed, 21 Oct 2026 15:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3FD26B0782; Wed, 21 Oct 2026 15:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E226B0783; Wed, 21 Oct 2026 15:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 89E666B0781
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:59:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DDA816055B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:15 +0000 (UTC)
X-FDA: 85347697470.10.7E1BDF7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8BBEF1C0006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nqmoVkDO;
	spf=pass (imf18.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612753;
	b=y1tzNaYvJgWB2yIud+yvNtJnCSJN2VekOhIcQVOQg+FUTneIyLlk75L4pqqI/1HYy4yJrw
	kV5f22m7Q13dCSd3/+Ot2Db/m6lxSqZGJeW4L6vOAD9SFSO89PpMCx7qnMkQzWhCdfT7sQ
	q6j+FFJtmRQ4TjLaWwpxN5cOnisw02g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nqmoVkDO;
	spf=pass (imf18.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KsD1+5qDV4QT7mV8iObkp0UpjNunR2mAhMdpCp7lNXs=;
	b=7yGzkJe67MabT6E0NWoB+fhcu7/0W8pPnWbKrNMNJqOaZXcXVUvagjCi10B5AZJ6J/sLoQ
	yIH10H01r/YKNi6juCxMO5Xd/5bSm5QiTFZFjtmQsj3nYoFxFk8ihGCbVWtkSoglBkqsyU
	YSirHmaa69E/hTNAi3ic2lBsaqY/Xmc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BD3A601F6;
	Wed, 21 Oct 2026 19:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D5F1F000C1;
	Wed, 21 Oct 2026 19:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612752;
	bh=KsD1+5qDV4QT7mV8iObkp0UpjNunR2mAhMdpCp7lNXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqmoVkDOOnG02x+NPAWgyBnquKdWN0g6r3nu8oQY0BFBy4nzd7ZlUldFbwc4Liztn
	 nl+OW9EsEmG/m96pR+Vp++uoolszVmRz6ZW+YgsY+AAvV8Iurw9HMiRDQMttOVSgsO
	 88gFxLl7hScsLTF/nPToKVrVbDCZO0cgE+qNx3OO/MNX3pskiRRLmPEdVsjyYJk41I
	 zC+rIGQ53WZDEb+fO/qRUNWuG87PY1UhuiWZAQsq8DYP6mTYcC8fGRAOQDVbHzYRqZ
	 1K0Q0vSxtu89bJLxNi/Cy352Y4Apkrc9xNYmFRIZWS4YUtwjYzF7WuGl/Sj4yvqLej
	 HGHzOqMpFF5ew==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [RFC bpf-next 6/9] selftests/bpf: Add user page allocation test
Date: Wed, 21 Oct 2026 21:57:55 +0200
Message-ID: <20261021195759.119421-7-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BBEF1C0006
X-Stat-Signature: b35aauhopoqr951y84oueq5rhdkygmet
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792612753-416569
X-HE-Meta: U2FsdGVkX1/GfMtZ6ajKgZgfNFuAJ5zLelm+Ao0ZR+lrY+u9xF86HC9mULl1XCJCo0AOtu44aNz1kOBB1oT3DqaAYKcaojIH8PqT7k3lJsMAycxzrKMZHPtm3+1eqWclh6vSO7arb5483HSRD4bR5LHKCjgTqSSrLHl2dUv/hQ1prQfLv9nrkzOrXYN1hYX5p2huU4SGqEZQ7fIo/w11morXZ5gbBhd/v+jJgdBIeuqwkTJAfp8DZGERwnrRtRIvRSLBXzB+94fcb1WOvASojWTVggu7I2pjCyqCnDjpcbvgblSeKns7IgYmfWGm7Y60Px4jhlAEYRLJ/mF/UjoZRrvKhp/TjW6fhfgxJj8poQ5ulLAx3C57MvwJUFr8yvI1dceXlFwn5egm3+HzX9rOBmP4d3Z0u0snRmWdGsfBtFZWAq3p280WRy0hvG/LmcYAr5P+Z7l536wTxYOd7r/G7vpX36sSbkQD+9YAs9iPjq/8ofpCzFcyanNhPcGiEqL0zqxVEUGt5tc4kJuKMTZZq5nFvNdi4o/YSyXXlPKVCxdvf9ZShu0yNQK3/Wf6VWjVdPuQpMGvV/+pfasVdb0wYKKnEFKQsj1+WoofUz8TSyFt0UF6oJxMdxAXEIvf44/hrTVH4K46akEnFUtKiqNrFST3iwZfdvLdN15LncHiMd86FBw8b3QPb6AJKJ0uI6nWsV4Vpu2NF0fpXnKd2j+TM/fyKyEg/H3/7oS4wPbEG5pWVr7rQpEMCD94tbn3muXYUYbM7aVyg9qjt4UOBOnwqHtSXg2/RB1D+wcfK8BIRFcwS9KxDwmjp4kCrumaxIFHymHN5y0GpA0OEV42Hy0YVkQXo1vPK7isDGhBx5hpqP6KOBF6o5ScxvDDShjNigzNOO/xAhTGEaKOApsxiscT5uwdaZ+wPA3NghS78vaOVNwFAoelUsKxeCce5ilryuvl5vXy34L1dI4+6otpqKe
 xVzFLX8K
 JBvzzHSVNZ07AA+UC0DKI6mQO4/lPvfNGr292EoM5IB0pNyH3lCtT1Cps/l/RXWByX8NaP7StD/VSRE2ZAIU+W3fzh4x1nrLe9hGlE2RZGpnrUwsyWkEIYC7Xq3vYjOuzNc+dB6RpSF2eszhQLGo1WsnLlAHdF5mvvcRmtVpISqppl1Xn5/RtB9pB5r8WiFEFzVMF+TX1agG5ZipiDnnecrM0iO1Hf7UQQF/bCeSkWvLFHsRdrrocexqdBV87IFlQpL13QiS1QniQhTG/jlrB8g1yKRBLweajV/mgbhigaB2ZOpMEX2qe2RdU131MUby+wskKZKePOkHPq/o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check that consecutive allocations remain separate VMAs and
that user page can be allocated again after unmapping.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_page.c      | 152 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_page.c |  31 ++++
 2 files changed, 183 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_page.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_page.c

diff --git a/tools/testing/selftests/bpf/prog_tests/user_page.c b/tools/testing/selftests/bpf/prog_tests/user_page.c
new file mode 100644
index 000000000000..ff51e7c598a9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/user_page.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include <sys/mman.h>
+#include <sys/personality.h>
+#include <unistd.h>
+
+#include "user_page.skel.h"
+
+enum {
+	USER_PAGE_ALLOC = 1,
+};
+
+static noinline void user_page_trigger(void)
+{
+	asm volatile ("");
+}
+
+static bool check_user_page_vma(void *addr, long size, const char *perms)
+{
+	unsigned long start, end;
+	bool found = false;
+	char vma_perms[5];
+	char line[512];
+	FILE *maps;
+
+	maps = fopen("/proc/self/maps", "r");
+	if (!ASSERT_OK_PTR(maps, "open_maps"))
+		return false;
+
+	while (fgets(line, sizeof(line), maps)) {
+		if (sscanf(line, "%lx-%lx %4s", &start, &end, vma_perms) != 3 ||
+		    (unsigned long)addr < start || (unsigned long)addr >= end)
+			continue;
+		found = ASSERT_EQ(start, (unsigned long)addr, "vma_start") &&
+			ASSERT_EQ(end - start, size, "vma_size") &&
+			(!perms || ASSERT_STREQ(vma_perms, perms, "vma_perms"));
+		break;
+	}
+	fclose(maps);
+	return ASSERT_TRUE(found, "user_page_vma");
+}
+
+static bool alloc_user_pages(struct user_page *skel, unsigned long nr_pages,
+			     long *addr)
+{
+	skel->bss->nr_pages = nr_pages;
+	skel->bss->action = USER_PAGE_ALLOC;
+	user_page_trigger();
+	if (!ASSERT_GE(skel->bss->user_addr, 0, "user_addr"))
+		return false;
+
+	*addr = skel->bss->user_addr;
+	return true;
+}
+
+static void test_allocations(struct user_page *skel)
+{
+	void *pages[2] = { MAP_FAILED, MAP_FAILED };
+	long page_size = sysconf(_SC_PAGESIZE);
+	const unsigned long nr_pages = 3;
+	long addr;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(pages); i++) {
+		if (!alloc_user_pages(skel, nr_pages, &addr))
+			goto out;
+		pages[i] = (void *)addr;
+	}
+
+	/* Back-to-back allocations must remain individual VMAs. */
+	for (i = 0; i < ARRAY_SIZE(pages); i++) {
+		if (!check_user_page_vma(pages[i], page_size * nr_pages, NULL))
+			break;
+	}
+
+out:
+	for (i = 0; i < ARRAY_SIZE(pages); i++)
+		if (pages[i] != MAP_FAILED)
+			munmap(pages[i], page_size * nr_pages);
+}
+
+static void test_reallocate_after_unmap(struct user_page *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	long addr = -1;
+
+	if (!alloc_user_pages(skel, 1, &addr))
+		goto out;
+
+	if (!ASSERT_OK(munmap((void *)addr, page_size), "munmap"))
+		goto out;
+
+	addr = -1;
+	alloc_user_pages(skel, 1, &addr);
+
+out:
+	if (addr >= 0)
+		munmap((void *)addr, page_size);
+}
+
+static void test_read_implies_exec(struct user_page *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	long addr = -1;
+	int old_personality, set_personality;
+
+	old_personality = personality(0xffffffffUL);
+	if (!ASSERT_NEQ(old_personality, -1, "get_personality"))
+		return;
+
+	set_personality = old_personality | READ_IMPLIES_EXEC;
+	if (!ASSERT_NEQ(personality(set_personality), -1, "set_personality"))
+		return;
+
+	skel->bss->action = USER_PAGE_ALLOC;
+	skel->bss->nr_pages = 1;
+	user_page_trigger();
+	if (!ASSERT_GE(skel->bss->user_addr, 0, "read_implies_exec_alloc_ret"))
+		goto out;
+	addr = skel->bss->user_addr;
+	check_user_page_vma((void *)addr, page_size, "rw-p");
+
+out:
+	if (addr >= 0)
+		munmap((void *)addr, page_size);
+	ASSERT_EQ(personality(old_personality), set_personality,
+		  "restore_personality");
+}
+
+void test_user_page(void)
+{
+	struct user_page *skel;
+
+	skel = user_page__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	skel->bss->monitored_pid = getpid();
+	if (!ASSERT_OK(user_page__attach(skel), "attach"))
+		goto out;
+
+	if (test__start_subtest("allocations"))
+		test_allocations(skel);
+	if (test__start_subtest("reallocate_after_unmap"))
+		test_reallocate_after_unmap(skel);
+	if (test__start_subtest("read_implies_exec"))
+		test_read_implies_exec(skel);
+
+out:
+	user_page__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/user_page.c b/tools/testing/selftests/bpf/progs/user_page.c
new file mode 100644
index 000000000000..6dd9417463df
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/user_page.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+#define USER_PAGE_ALLOC 1
+
+int monitored_pid;
+int action;
+long user_addr;
+unsigned long nr_pages;
+
+SEC("uprobe.s//proc/self/exe:user_page_trigger")
+int user_page_test(struct pt_regs *ctx)
+{
+	if ((bpf_get_current_pid_tgid() >> 32) != monitored_pid)
+		return 0;
+
+	switch (action) {
+	case USER_PAGE_ALLOC:
+		user_addr = bpf_user_page_alloc(nr_pages);
+		break;
+	}
+
+	return 0;
+}
-- 
2.54.0



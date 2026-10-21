Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0666F606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BYG6kLv4
Received: by kanga.kvack.org (Postfix)
	id 20CAE6B0788; Wed, 21 Oct 2026 15:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7B26B0789; Wed, 21 Oct 2026 15:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28C26B0788; Wed, 21 Oct 2026 15:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE7F96B0786
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:59:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 62D3F16066B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:46 +0000 (UTC)
X-FDA: 85347698772.19.94854BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B5863A000B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYG6kLv4;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612784;
	b=EWZDjwGfX+PRWi+KZt2WczvZlRM1JVwY9uFABP9Jeo022dX51fmWxtcnOyJ/k77K1uKi59
	+W+OTRyWSZAIiPvz/UpSq44ObGHBzItBmsjLMmg6WrTOif1Xmo1L0vsxzXjHC1oU/Xw4oo
	RO7LkUriTxSxxvaR9ZAf1Cyvf68Sm5Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BYG6kLv4;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fiJLJWbXoWyY6A/386yIPXP7rjQV8aKUb+bgkajzRr4=;
	b=0vKrfgDcRBQCPEgBtgw86lQ1WTeovvazmUEb/vc7cZcxcgbkxIGJ7SPPM2OzalwgANTs9g
	KtgmNQswGrSbtuz3CASsMa/K6y8uRF4g+0me4rpoc/VDhBmqL77hQZbS42WNBbhwWJUgH9
	iN3jbBVWI4Rfsztbk8MImqMCInb1gAA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0333843A5E;
	Wed, 21 Oct 2026 19:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48071F000C1;
	Wed, 21 Oct 2026 19:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612783;
	bh=fiJLJWbXoWyY6A/386yIPXP7rjQV8aKUb+bgkajzRr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BYG6kLv4j2Puk+9eO0FeXpoWN0S5OYiv4Z2dAOAp300aRxiMh1caa0v9DwJ8TXxUX
	 FlMSDK0CpLysgrhQ11psU0siBYFKixWQ/FdFqM6WQxzUl2nw6gDZJyxECIXY5lSun+
	 MZzhdFcoRvE0UcLF7rcEbR+axF3cQNo7+qvQmH5a2KCIyBoqq1f/YPy3RepCAJ4xL1
	 ZYLoTkqMQdSKWSnYLptlu24+5OlBYFkYXAAmykYFnnCgfniV2YLitNVOvAvzcgag/a
	 HliuwSFSCmiUkJkqdKXIP5xHceZ5jibgq39fQKTjUCWpVjyzzxU0eps+7XG38X4KAi
	 FF6Def+IAnCWQ==
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
Subject: [RFC bpf-next 9/9] selftests/bpf: Add user page failures test
Date: Wed, 21 Oct 2026 21:57:58 +0200
Message-ID: <20261021195759.119421-10-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eqkegnzyghyhgs1togukzimht9xpwo3q
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5863A000B
X-Rspam-User: 
X-HE-Tag: 1792612784-104131
X-HE-Meta: U2FsdGVkX1/nYhnSQcw5Rf+MRpNiznIXALuOX3kVUZ8kL6y/t+A9YcSzsRXy99Q+KeWpBrT1IpKpMVoJH5IcGDQ2Pf0g8cMkMn29KYo0Cm+gUCGKBqfTqdA9o+3YLqn5PmGF9CNJoKDxvoJXqITfoQ1HivWfX2ftWCjKR8GZ7v3R9VaFnl3EWlTR/sLJ5a54x8H82hDL4tw/Jio2f6nqh3BHceXQKcL66Uqi7w8ZQnXlFdXmL7IfSVOcHYHR1o9eaK1LTuyDa2xeMp04BqeaIyquUW2Hc4sZ5EmOBoZejGVZL1jthtcxR8QhvoFjgVHgfcOaTuA36qUdsGSoV7IZ9e28i5/l5+goZEVWIQ9K+iTg+JLEpPsxNdGq6YLTqUz/TG1TVekSWK6I/zWFfGHDLkvSbwXs8wD5aA1KSkugp5h/rdq8gdiNBCzvuQKy+FJKJHFR1Qtu1DOQVRq4Mm3WvIVPXPVWqyW+v1c1784cjioTHx19QY1Hs3tWuvkCpB31NVphTB/Ee12/EvjOrN2nHTvovkyPxXTCWq9WcTK3+Mk6v6TlgQ5jhR7EF/7FvrPxlewtki3BDUc1+ep3vGtgD9FH13kz3o2ZnMUVLkK8UhUGFl84gMfriaEJBp4QW9cVsMm22gPyFxDre24Cfx3/1AdSQd2kVuxFN1JYXPtSgqfhKMjwMEQjoSxjAF1UVgS2lOBNZa9rCOMwWUO73JOE5VWzlAXDGiB00485r73NDE/rv7uAyto7PkMSXz2tjo7XC1maJeDmMcG9UTADlljo7XJBUs8Y44Xt3Nx0eN6AyNITBTsj9V8QpI8DEKqPr4HZVPGRLPQhEvPzif5M525UDGoboNXVOK0TGhI1wdb0RQHgPu1/COHnFhJx8ZU4f/nSR+Ez+uVS9EMP8gHQ/inCo/V8GobZmar8fAHb4lmZyxlmcd3kv8N/J8MP8cacep11nQAHNNdLO6xS1SLOUhZ
 2w1LfiD2
 cXGYpEtFZnBLWzrwTW9enFu165zgBr4reN7VPTvodjzq7AJTrxFNWsMzrExjTEN3ZmcA+KjdkKgmQ87sxV6ATRwD1l9MyXNhC2yFMLL5TY8oCecz5SrDJaJUmmS4xEMIlYO4J8ydsc/ZVh/yIIUcFXkHSNrkioPKoCMOQ/WH7zNlGvipD6+NzfH9rGprxlWgIASyZ+yc26Qo8DJIZTMMZiC/i6BIaG+L3VxDMJPkTIB1wEbMCq3jfeAxy6+gP+LoZhu6eaiQR/zdzNqYPldDDeiOUPr3Hu8Jmpk/w7lJxr/s/epmf5FTpv5KxVlzsEkrdschvMMvkMpbfbQ75dF5cdUh4Ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Cover expected failures for invalid allocation sizes, misaligned or
unrelated exec requests, replacement of sealed mappings, repeated
execution, bad writes and attempts to restore write permission.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_page.c      | 141 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_page.c |   5 +
 2 files changed, 146 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_page.c b/tools/testing/selftests/bpf/prog_tests/user_page.c
index 74ce52d726ec..107349aace94 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_page.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_page.c
@@ -12,6 +12,7 @@ enum {
 	USER_PAGE_EXEC = 2,
 	USER_PAGE_EXEC_ONLY = 3,
 	USER_PAGE_WRITE = 4,
+	USER_PAGE_BAD_WRITE = 5,
 };
 
 static noinline void user_page_trigger(void)
@@ -209,6 +210,144 @@ static void test_faultable_write(struct user_page *skel)
 		munmap((void *)addr, page_size);
 }
 
+static void test_invalid_allocation_size(struct user_page *skel)
+{
+	skel->bss->action = USER_PAGE_ALLOC;
+	skel->bss->nr_pages = 0;
+	user_page_trigger();
+	if (!ASSERT_EQ(skel->bss->user_addr, -EINVAL, "zero_pages_ret"))
+		return;
+
+	skel->bss->nr_pages = ~0UL;
+	user_page_trigger();
+	ASSERT_EQ(skel->bss->user_addr, -EINVAL, "overflow_pages_ret");
+}
+
+static void test_misaligned_exec(struct user_page *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	long addr = -1;
+
+	if (!alloc_user_pages(skel, 1, &addr))
+		return;
+
+	skel->bss->exec_addr = addr + 1;
+	skel->bss->action = USER_PAGE_EXEC_ONLY;
+	user_page_trigger();
+	ASSERT_EQ(skel->bss->exec_ret, -EINVAL, "misaligned_exec_ret");
+
+	if (addr >= 0)
+		munmap((void *)addr, page_size);
+}
+
+static void test_reject_replacement(struct user_page *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	long addr = -1;
+	void *ret;
+
+	if (!alloc_user_pages(skel, 1, &addr))
+		return;
+
+	ret = mmap((void *)addr, page_size, PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+	if (!ASSERT_EQ(ret, (void *)addr, "replace_mmap"))
+		goto out;
+
+	skel->bss->exec_addr = addr;
+	skel->bss->action = USER_PAGE_EXEC_ONLY;
+	user_page_trigger();
+	ASSERT_EQ(skel->bss->exec_ret, -EINVAL, "replacement_not_bpf");
+
+out:
+	if (addr >= 0)
+		munmap((void *)addr, page_size);
+}
+
+static void test_bad_write(struct user_page *skel)
+{
+	skel->bss->action = USER_PAGE_BAD_WRITE;
+	user_page_trigger();
+	ASSERT_EQ(skel->bss->write_ret, -EFAULT, "bad_write_ret");
+}
+
+static void test_unrelated_mapping_exec_rejected(struct user_page *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	void *unrelated;
+
+	unrelated = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (!ASSERT_NEQ(unrelated, MAP_FAILED, "unrelated_mmap"))
+		return;
+
+	skel->bss->exec_addr = (long)unrelated;
+	skel->bss->action = USER_PAGE_EXEC_ONLY;
+	user_page_trigger();
+	ASSERT_EQ(skel->bss->exec_ret, -EINVAL, "bad_exec_ret");
+
+	munmap(unrelated, page_size);
+}
+
+static void test_repeat_exec_rejected(struct user_page *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	long addr = -1;
+
+	if (!alloc_user_pages(skel, 1, &addr))
+		return;
+
+	skel->bss->exec_addr = addr;
+	skel->bss->action = USER_PAGE_EXEC_ONLY;
+	user_page_trigger();
+	if (!ASSERT_OK(skel->bss->exec_ret, "first_exec_ret"))
+		goto out;
+	user_page_trigger();
+
+	ASSERT_EQ(skel->bss->exec_ret, -EINVAL, "repeat_exec_ret");
+
+out:
+	if (addr >= 0)
+		munmap((void *)addr, page_size);
+}
+
+static void test_exec_write_protection(struct user_page *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	long addr = -1;
+
+	if (!alloc_user_pages(skel, 1, &addr))
+		return;
+
+	skel->bss->exec_addr = addr;
+	skel->bss->action = USER_PAGE_EXEC_ONLY;
+	user_page_trigger();
+	if (!ASSERT_OK(skel->bss->exec_ret, "exec_ret"))
+		goto out;
+
+	errno = 0;
+	if (!ASSERT_EQ(mprotect((void *)addr, page_size,
+				PROT_READ | PROT_WRITE), -1, "restore_write"))
+		goto out;
+
+	ASSERT_EQ(errno, EACCES, "restore_write_errno");
+
+out:
+	if (addr >= 0)
+		munmap((void *)addr, page_size);
+}
+
+static void test_fails(struct user_page *skel)
+{
+	test_invalid_allocation_size(skel);
+	test_misaligned_exec(skel);
+	test_reject_replacement(skel);
+	test_bad_write(skel);
+	test_unrelated_mapping_exec_rejected(skel);
+	test_repeat_exec_rejected(skel);
+	test_exec_write_protection(skel);
+}
+
 void test_user_page(void)
 {
 	struct user_page *skel;
@@ -233,6 +372,8 @@ void test_user_page(void)
 		test_partial_exec(skel);
 	if (test__start_subtest("faultable_write"))
 		test_faultable_write(skel);
+	if (test__start_subtest("fails"))
+		test_fails(skel);
 
 out:
 	user_page__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/user_page.c b/tools/testing/selftests/bpf/progs/user_page.c
index a855b0b46350..530a0be3737b 100644
--- a/tools/testing/selftests/bpf/progs/user_page.c
+++ b/tools/testing/selftests/bpf/progs/user_page.c
@@ -12,6 +12,7 @@ char _license[] SEC("license") = "GPL";
 #define USER_PAGE_EXEC 2
 #define USER_PAGE_EXEC_ONLY 3
 #define USER_PAGE_WRITE 4
+#define USER_PAGE_BAD_WRITE 5
 
 int monitored_pid;
 int action;
@@ -50,6 +51,10 @@ int user_page_test(struct pt_regs *ctx)
 		write_ret = bpf_probe_write_user_faultable((void *)user_addr, data,
 							   sizeof(data));
 		break;
+	case USER_PAGE_BAD_WRITE:
+		write_ret = bpf_probe_write_user_faultable((void *)1, data,
+							    sizeof(data));
+		break;
 	}
 
 	return 0;
-- 
2.54.0



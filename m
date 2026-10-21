Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43A41606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RtpnDB24
Received: by kanga.kvack.org (Postfix)
	id 4C9306B0783; Wed, 21 Oct 2026 15:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0ED6B0784; Wed, 21 Oct 2026 15:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DDCB6B0785; Wed, 21 Oct 2026 15:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4126B0783
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:59:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D1B0A8267
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:25 +0000 (UTC)
X-FDA: 85347697890.27.235D5A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D0F810000E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RtpnDB24;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSq82ODWtlPwv9NWbfrCiBYmC+9lp/ZNZSCghuo9jNY=;
	b=A8YxLpR9pI5WbF3KfbT4qzy4xBbWzOv6wS7iDK1nNUuFn7gRpU27fzX5ObZwLjfyFTcmp7
	IiSRDJPGFFJ4Fc4Oxqy7NCAicDD6wAbRVpJqG/KsaKyWa82pzZM6pEP5+GqWZmmRefGMCW
	qM0vz3ERjZpWesUfFCs7fLu4AnBZRD4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RtpnDB24;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612764;
	b=et4exXeWX8sbJh12yDxES6MxeSm7LL7GwuBtwvMahyWrZa4NOYa9zCObRHW7Bmm9aRWzd4
	OVV1FkofWtHBR0t9l0OzX84YBGS8jAwFAQxeImNOAcsDweQHFQwCsKWFR6BqkULvcZdmoW
	KDSL0mE1FU8pL9OVgh6WIWHW7YvJw7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A4A1C60018;
	Wed, 21 Oct 2026 19:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A251F000C4;
	Wed, 21 Oct 2026 19:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612763;
	bh=cSq82ODWtlPwv9NWbfrCiBYmC+9lp/ZNZSCghuo9jNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtpnDB24temjgYrxtXmGajbdikbJba8pa5HNRYEKjRtbDe5lpXlmEhjDT/sS3jk0c
	 N17fbdBEJm7xxqIX1BJ6QjaCK/nVjh7+zJFpBqv1UAh+PnccxAJD7GxP19BlJUQi7T
	 iw0ooAN/3UZZjFG0/62O06pQtO7pe321v+x1Ul9CyG0+pMvlETHdhK4bpSEpXxf4+a
	 Z7UC8aK/dJ/N8Ixct4rSj0YDBGrDiI0PGZKYmDUd2njpWBiGh5lcTNPt+hplEsDwMw
	 b91NILcHytqOJ2Zc9lAWTRc7l0ekywd/kI8KRKR8QOJRnft4lBDZxZDERNMAuiinkM
	 9mQq6kFMK8cVg==
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
Subject: [RFC bpf-next 7/9] selftests/bpf: Add uprobe user page exec test
Date: Wed, 21 Oct 2026 21:57:56 +0200
Message-ID: <20261021195759.119421-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0D0F810000E
X-Stat-Signature: fwa45zixk3gd471pkr56jbge3zuh1xm8
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792612763-925605
X-HE-Meta: U2FsdGVkX19MJ1/hLwevOiK+PINln/2pG9PIOjf0MbkcGrGn0sJTByMQ43q4muw1zB3JghgzScKpr3ZiB6Og0qveSHrQ82eWjjUuy0hBsXVgw6i/v970QyUWYdk0zRl2wZLHJpZAvX9P5PDWZCwm6HfR2s2TfjCYWPY2LE+EQYkkqjmb2hq4sT9u7yvP31DGKg7LP+rf9aOSjiy2zkYZrn7cnuSNgFlYpFEKmGeiZDmSMcGSLGzhp3rBG8y4zz/Vym4bRkyBiyzOGIhg0CqKaCxWWrdzRiVPk0UtQn0N/jwApmnR0Rw25ZMIaiRH/zlo3LjzC2T50VZ/UULY59yId07cUlwD+xkcveILNvo68Q8jBDZD9/HcF1wrH40kcogcHh4e2E+JwYkYk/uFum2YJpuvlfZ2ZdpaX5ej41ECvVjEfMBAf/2GNlcBg0s3E4JPHJDFb5EVQJfsyt/fOvg6esGTGga1sDFWlcvhzWYB1/3+QkVJzYtsLfVRYaK/VJMYP0e1DCpFDLSECxCFAqtU9kHY8U5n/oHUbCBBlCKltGUscS5ZCKVFM2mMsKkcWKg1Id00Vte3dpMW4NoVtIcPZY6OeBVslOeMHd8bPm1SeC9PcpxX2XzAXjX91GwZZcixa/czb1WB0l52kExyg6j8pyQRz/u+HfTw19co3PHqVZNsoXii9oGVpqfkrfYBhS4mbU28kihpq6H4+Bw6C8E9zm2LJSw0Fps1E4qJ16KmWTYjzoRuGsor3iIHL5DnjIJtebPh8wLnoJqjepF/dwrbvzjDTNhsICa47LznVca77ymIaq5g2Fp3f8UjqBABYr2VF+KPRzKapZYJzrimYqeccZQKNxFyqDvjpHyL2d5bA3BUo/yxdmAHGzGJArmz7dI9Zo6vq/BB7T37NFjI2pqSYMWCKhIu0FjDsWsZmxe108sDxMB2EbHT8G55NVtS98aObWxfe9fOBEP88EUcfkf
 wgJ939Sp
 On6n9SGLBqXmOz0XLxdIopiJUSf22PTVozX2/+MQ0pwBHmV2VgZShOyD9PX97LDzBxZz6xfKvOK97spoQqYVn0mkiwtPg7bGEEszWdr+n/39IvoIQkgi/9jcLoCy0slWryWhlGa+8Cd4D4XxduTEIFcnmmEUZ7hDKN9syTfKW64U9+reD0mj8cBquAJ78a/EPRgeD6SSeNBt3ShyiId6DRH2l92TFP7ANPEFZGjaBmZ8xMfhF9MT0pmvo+NUwGINs90apVToEnS9mDRphisraFWFP67GE//fNRol3BoyVJ8eAvEdTFoVODakhSE+bmLalNhnhF2DaivUAYGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Test executable permissions for whole and partial user-page
allocations and execution of code written into a user page.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_page.c      | 62 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_page.c | 18 ++++++
 2 files changed, 80 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_page.c b/tools/testing/selftests/bpf/prog_tests/user_page.c
index ff51e7c598a9..1b5dff2c8ff6 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_page.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_page.c
@@ -9,6 +9,8 @@
 
 enum {
 	USER_PAGE_ALLOC = 1,
+	USER_PAGE_EXEC = 2,
+	USER_PAGE_EXEC_ONLY = 3,
 };
 
 static noinline void user_page_trigger(void)
@@ -128,6 +130,62 @@ static void test_read_implies_exec(struct user_page *skel)
 		  "restore_personality");
 }
 
+static void test_execute_user_page(struct user_page *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	long addr = -1;
+
+#ifndef __x86_64__
+	test__skip();
+	return;
+#endif
+
+	if (!alloc_user_pages(skel, 1, &addr))
+		return;
+
+	skel->bss->exec_addr = addr;
+	skel->bss->action = USER_PAGE_EXEC;
+	user_page_trigger();
+	if (!ASSERT_EQ(skel->bss->write_ret, 0, "exec_write_ret") ||
+	    !ASSERT_EQ(skel->bss->exec_ret, 0, "exec_ret"))
+		goto out;
+
+	ASSERT_EQ(((int (*)(void))addr)(), 42, "execute_user_page");
+
+out:
+	if (addr >= 0)
+		munmap((void *)addr, page_size);
+}
+
+static void test_partial_exec(struct user_page *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	long addr = -1;
+
+	if (!alloc_user_pages(skel, 3, &addr))
+		return;
+
+	skel->bss->exec_addr = addr + page_size;
+	skel->bss->action = USER_PAGE_EXEC_ONLY;
+	user_page_trigger();
+	if (!ASSERT_OK(skel->bss->exec_ret, "middle_page_exec_ret") ||
+	    !check_user_page_vma((void *)(addr + 0 * page_size), page_size, "rw-p") ||
+	    !check_user_page_vma((void *)(addr + 1 * page_size), page_size, "r-xp") ||
+	    !check_user_page_vma((void *)(addr + 2 * page_size), page_size, "rw-p"))
+		goto out;
+
+	skel->bss->exec_addr = addr + 2 * page_size;
+	user_page_trigger();
+	if (!ASSERT_OK(skel->bss->exec_ret, "last_page_exec_ret"))
+		goto out;
+
+	check_user_page_vma((void *)(addr + 2 * page_size), page_size, "r-xp");
+
+out:
+	if (addr >= 0)
+		munmap((void *)addr, page_size * 3);
+}
+
 void test_user_page(void)
 {
 	struct user_page *skel;
@@ -146,6 +204,10 @@ void test_user_page(void)
 		test_reallocate_after_unmap(skel);
 	if (test__start_subtest("read_implies_exec"))
 		test_read_implies_exec(skel);
+	if (test__start_subtest("execute_user_page"))
+		test_execute_user_page(skel);
+	if (test__start_subtest("partial_exec"))
+		test_partial_exec(skel);
 
 out:
 	user_page__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/user_page.c b/tools/testing/selftests/bpf/progs/user_page.c
index 6dd9417463df..38f6fcb89bc6 100644
--- a/tools/testing/selftests/bpf/progs/user_page.c
+++ b/tools/testing/selftests/bpf/progs/user_page.c
@@ -9,11 +9,20 @@
 char _license[] SEC("license") = "GPL";
 
 #define USER_PAGE_ALLOC 1
+#define USER_PAGE_EXEC 2
+#define USER_PAGE_EXEC_ONLY 3
 
 int monitored_pid;
 int action;
 long user_addr;
+long exec_addr;
 unsigned long nr_pages;
+int write_ret;
+int exec_ret;
+static const unsigned char insns[] = {
+	0xf3, 0x0f, 0x1e, 0xfa, /* endbr64 */
+	0xb8, 42, 0, 0, 0, 0xc3, /* mov $42, %eax; ret */
+};
 
 SEC("uprobe.s//proc/self/exe:user_page_trigger")
 int user_page_test(struct pt_regs *ctx)
@@ -25,6 +34,15 @@ int user_page_test(struct pt_regs *ctx)
 	case USER_PAGE_ALLOC:
 		user_addr = bpf_user_page_alloc(nr_pages);
 		break;
+	case USER_PAGE_EXEC:
+		write_ret = bpf_probe_write_user_faultable((void *)exec_addr,
+							   insns, sizeof(insns));
+		exec_ret = write_ret ? write_ret :
+			bpf_user_page_exec(exec_addr);
+		break;
+	case USER_PAGE_EXEC_ONLY:
+		exec_ret = bpf_user_page_exec(exec_addr);
+		break;
 	}
 
 	return 0;
-- 
2.54.0



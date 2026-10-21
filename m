Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A850606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D19F/osa
Received: by kanga.kvack.org (Postfix)
	id 4A32F6B0785; Wed, 21 Oct 2026 15:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A4C6B0786; Wed, 21 Oct 2026 15:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F8B6B0787; Wed, 21 Oct 2026 15:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19D576B0785
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:59:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20B191C3EC0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:36 +0000 (UTC)
X-FDA: 85347698352.18.B3EF796
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 61496160009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:59:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D19F/osa";
	spf=pass (imf08.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWw7/1YfSaPjxjkdMidM2fyIbOFoLaRyXIcCuxnA6p0=;
	b=NyhYVMEEFEi+RL2UsrhmkO1fl0s6sO0T9D7XRAdaF6O75g6c5UqXrKaR+agLnmMjGwiAev
	uryPoV4+nLreTF7jROiVcb6OhDqMSLIP9ruk/ykksgmWjAoPw1v7fuBuILuWDoKDdzYNln
	mJK9/N86+y1oTyThdcKU+lavIKvwcqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612774;
	b=N6Y5J0KJjXO/anBxrtac0fyVlmu8heqcVvu8lQAfEom4PPW8vBi3JJvQyNbMCe7Y7cRBj1
	hsv6Miqz1F9Emu01Wmak/zl8slVjp+iYRSpMcm9AWkbNYjVpmqUOiR6kxfSFzUTvlkbdMm
	+4wDsWdY4qvTGLqTEM7DjWjC3Rl71As=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D19F/osa";
	spf=pass (imf08.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D56B1601F6;
	Wed, 21 Oct 2026 19:59:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEA01F000C3;
	Wed, 21 Oct 2026 19:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612773;
	bh=EWw7/1YfSaPjxjkdMidM2fyIbOFoLaRyXIcCuxnA6p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D19F/osaO8u6rZpi8wEpsQY0Bxt3uJCEzTCt6jyFTXnzEcQdm8QxKSysS4Uy+Ofa1
	 ztaK2BP11cc7vmO11Hk+NKpsPN3gRTX6Hb2+ZbN7bKKYQENYCm9n8nmz1Uh+aacjyG
	 Gssw9rIx4ANuA7R5wDd2DLe4/eMGOgsek+ZDlSU2QFgUmPhc9cCBMz2LiIAEL++5Le
	 Zlo+vEt6mmCIwrThAsCyMQMSTgzkylLPNgPrOFHv0Mp2vJE25nZAaH2bLyThvMnscP
	 ROCM5JEtW/asy4vQXOB76rK9K1dxgcRL950iv9ceMHsuqrsMYV01CCr4CRPdb6s/aP
	 t/kXI2xa8AvRQ==
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
Subject: [RFC bpf-next 8/9] selftests/bpf: Add faultable user page writes test
Date: Wed, 21 Oct 2026 21:57:57 +0200
Message-ID: <20261021195759.119421-9-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261021195759.119421-1-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 61496160009
X-Stat-Signature: 6e7byersin66snesoj8junfkfqtyfyc7
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792612774-675981
X-HE-Meta: U2FsdGVkX1+dxu+d7VGluphG05bBhN0lSG/OekU65YAnsBGixdaSqyfos1k+1gcxzvjdTDbRAxfTrQkp5HjXhokT6VeSwTVEr+oJCohfz7kBBNmVjVkeyhOk6KdaGechICzJjUoEHU6IyRbIMZgV+5oWnzkLLhMzh2eWjELOEDZToHdxAlK3t+XF8H5UBHqLUxJqlHqkgsrxS6MsZRiXGATTQCz/bWljmRUarNog2+OWpfYhf6NnBxux/780gqKVxQVM59xXIE6665Rq5VAAJHM8phXg6ICbIqOT5juGI+gGmDzqn3aWqt/uCPmRKM9sETk1nAhwMfn0s4JUyny2DzN83bOm3zUPFuuDtDDnb14EA5+HsaEPmYmTYBgKL0D4w8JbgIb3QBKuQy0BgNiuIgTpQmbA3i1p7UR+7xv2e7WwDL+X8uy+JRqKDdfegkoP1gczsxp63ZnnI+P0bx1SkHCbnOhkEHovKKzSFATlJwojotcRqhp6TNaeI7wHx0/7Gi8+TeQVIgf1D9vi6rdBCHvfIZ3TB0vetywlnEgw4QPKzaJwxE88QJPQuA4OuSh2qsfia1HUBDOfCmiYGHEXC1RdRGpJFono/HQafQ4JP0eBq/ANGbIQE1UYryRfgOmJ/XL0aN2RtRnbBh3mL+zM7KRoIR8pdF29C0+GvebDwZucC/XmxN2NDHfuRoFi23KDH5caFhI6GGHdl4ah7ycOJS8QmbjXLtI+LQ+mNhGcGPscfYqfuV3kPsegFQSwPYN++yfh9d1p3+WLtApLt4S25Cna5tlTvpOYiy/X56XJrpI3skffUyw4tmdvfN19lnJTlFkq5IqG4nK8S+xh4ypoDywriWQ5WFiN98Sv67Y/O/qzmi9YNGG/YMDBi5Ie4hCwkhaWmSIbscIAQwj4Cp/T1zx1Bzdz5Z0atGHOTfQ5GTnqwOseNsTKKWpTMVObAoJn7+9gRYYzFWYJ+GkPZ23
 r/OCBppd
 tRLqVnczIQwlyswQ2jOu4EPrUd4IAr3MuvUOPxh/DbLtNG9L4Nq08Y4Ed5LXuHigSgg4oB9BIPBh2XFE9Ry6bXopEGp1JArf8oXhcgNCV8y0MWnIkKZjk0HW4Z5Th4C6gD5yMI14c0y1jpPNSuilFVeGsT07jA6G2aa1AWHJ12dU0VOVWLGxgRmGVntxg/YZimyOOTUQV3oSuGRB2+Gbd0wPBWTI7BqLXIRBKswg2IMR0C1OShVO0zcRSME5erTyzCMnGFRW3NLVlMgnjshC12UNXePDVw+macGR+TXQA/8xi1XgCBKlAalIrICiKJJNhNMwTc6anTvCXFks=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Exercise fault-enabled writes into an allocated user page
and verify the written data.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_page.c      | 25 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_page.c |  7 ++++++
 2 files changed, 32 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_page.c b/tools/testing/selftests/bpf/prog_tests/user_page.c
index 1b5dff2c8ff6..74ce52d726ec 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_page.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_page.c
@@ -11,6 +11,7 @@ enum {
 	USER_PAGE_ALLOC = 1,
 	USER_PAGE_EXEC = 2,
 	USER_PAGE_EXEC_ONLY = 3,
+	USER_PAGE_WRITE = 4,
 };
 
 static noinline void user_page_trigger(void)
@@ -186,6 +187,28 @@ static void test_partial_exec(struct user_page *skel)
 		munmap((void *)addr, page_size * 3);
 }
 
+static void test_faultable_write(struct user_page *skel)
+{
+	static const char expected[] = "fault-enabled BPF write";
+	long page_size = sysconf(_SC_PAGESIZE);
+	long addr = -1;
+
+	if (!alloc_user_pages(skel, 1, &addr))
+		return;
+
+	skel->bss->user_addr = addr;
+	skel->bss->action = USER_PAGE_WRITE;
+	user_page_trigger();
+	if (!ASSERT_EQ(skel->bss->write_ret, 0, "write_ret"))
+		goto out;
+
+	ASSERT_EQ(memcmp((void *)addr, expected, sizeof(expected)), 0, "written_data");
+
+out:
+	if (addr >= 0)
+		munmap((void *)addr, page_size);
+}
+
 void test_user_page(void)
 {
 	struct user_page *skel;
@@ -208,6 +231,8 @@ void test_user_page(void)
 		test_execute_user_page(skel);
 	if (test__start_subtest("partial_exec"))
 		test_partial_exec(skel);
+	if (test__start_subtest("faultable_write"))
+		test_faultable_write(skel);
 
 out:
 	user_page__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/user_page.c b/tools/testing/selftests/bpf/progs/user_page.c
index 38f6fcb89bc6..a855b0b46350 100644
--- a/tools/testing/selftests/bpf/progs/user_page.c
+++ b/tools/testing/selftests/bpf/progs/user_page.c
@@ -11,6 +11,7 @@ char _license[] SEC("license") = "GPL";
 #define USER_PAGE_ALLOC 1
 #define USER_PAGE_EXEC 2
 #define USER_PAGE_EXEC_ONLY 3
+#define USER_PAGE_WRITE 4
 
 int monitored_pid;
 int action;
@@ -19,6 +20,8 @@ long exec_addr;
 unsigned long nr_pages;
 int write_ret;
 int exec_ret;
+
+static const char data[] = "fault-enabled BPF write";
 static const unsigned char insns[] = {
 	0xf3, 0x0f, 0x1e, 0xfa, /* endbr64 */
 	0xb8, 42, 0, 0, 0, 0xc3, /* mov $42, %eax; ret */
@@ -43,6 +46,10 @@ int user_page_test(struct pt_regs *ctx)
 	case USER_PAGE_EXEC_ONLY:
 		exec_ret = bpf_user_page_exec(exec_addr);
 		break;
+	case USER_PAGE_WRITE:
+		write_ret = bpf_probe_write_user_faultable((void *)user_addr, data,
+							   sizeof(data));
+		break;
 	}
 
 	return 0;
-- 
2.54.0



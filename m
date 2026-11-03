Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D274B606A336
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RM0LlK7H
Received: by kanga.kvack.org (Postfix)
	id 05B106B05C0; Tue,  3 Nov 2026 03:00:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032846B05C1; Tue,  3 Nov 2026 03:00:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8B9B6B05C2; Tue,  3 Nov 2026 03:00:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C954C6B05C0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:00:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D9764035D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:34 +0000 (UTC)
X-FDA: 85393060788.11.1D3B565
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id BED58C000F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:00:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RM0LlK7H;
	spf=pass (imf22.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acfNxavyOUjUywz61ozXkej8203ZY4SRCfP5uOVUHGs=;
	b=dEkKX0JZiNkzn/0bztHCVpHCfkHGsZrOAjj826YlIJYoOJClCUriWhur/2W0h+6AEzBize
	tWMVatHrMWyIfYZ5BZTQJUuw/X7ydotBbXMadt8TepwyJOv6OubC8dgoTnC24owM0hwgMX
	jJtvUETvuGbwj2h1v2YGh9/4B8Ze+cc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692832;
	b=VfzZLVe1vodJgVFTtIRPxfRKay7E5UY5ixY5xvpR5mVSo8AzZ/aWT+O+tPE1iIZ9qlM/QC
	/bVj5JAk7mQ2QWka4T2/nsGIVhaI2e0AV0OMYXbRbFoxJ0Nr59zH9uFrJLh90seAkaRfy+
	fLBiq4Zsw9oeMTwpK+fSzDYhqF43QhI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RM0LlK7H;
	spf=pass (imf22.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EC8A605CB;
	Tue,  3 Nov 2026 08:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4CE1F00A02;
	Tue,  3 Nov 2026 08:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793692832;
	bh=acfNxavyOUjUywz61ozXkej8203ZY4SRCfP5uOVUHGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RM0LlK7HR1+Uk9vcexLxxKAkdKcDo5PEM+nxT9wExTy3Zb4SQSsVSvOvKtLgnSbNR
	 a5ER6ZOklKN/8Jt4wYYX4O1xF0sMe4jcCwM9pjQCnYgcYkc+OJTeZfmMvstJbj0y+w
	 QiHq80q1gyDTiRQ8cazHHPgsgoGHXpFCJB+lpER5RN1j683h756e8sBc+q6n6Umet6
	 o70BkJKJsMZvplA29vwYjEnJbCCaaF6KfhlzryILNfhlNhZo3VgLfvpcVgLUxBQEml
	 0C/sw/3M9f0xFJwDxg3fdxvrWLEcd2Jlms1W6+ZPv+X4zQMFfbKRHhs5rWOWYgErv0
	 LSvDVc73qurRA==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: [PATCHv2 bpf-next 7/8] selftests/bpf: Test bpf_copy_to_user kfunc
Date: Tue,  3 Nov 2026 08:59:14 +0100
Message-ID: <20261103075916.100050-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103075916.100050-1-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qw8r53atu51xmeuq3eseyqs8r89amd3b
X-Rspamd-Queue-Id: BED58C000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793692832-445487
X-HE-Meta: U2FsdGVkX1/yfxG1LHlzmguzxMsquRIIPLpoVhWcJhN/O1sX9VIK7TapX50HI6PrVaSoaIrLK+X7nsWE9pT0bL/tbKjjU6Jb4OXSVNQ+DMRPWoVimgFf/hqglvKWExRxs5SwetUSuSxDYq4fpdnW7Szd2Wt63LcoM6J/ocdc4qT75Ff2h9w/+KTY315ETwMvDG0yyXCvzMt130/JUhGk4UzhlFGZ4ufXEQ4rqBPMdEJmRzfYrkGq5qeQ3PnZC8sZzRwRwCzuDKDuv7gy60VU/4OLsC5IyqvodYeaMYW5p3DYlMmrC+ZeeYS+cAVVujY81RyfsU/ivPjGc1cl0sbuDAIqfvN7ANEsUrJ3tNUcF/ZD949AZEFscVRhmtHtW9hSMKV5kzzUpGe5IyMNQkiFNtJK42Ra1hTLJzINFJkvzcaFwuTK5EuQd5AvHmgK2t46hwI088DaXZB+Y2ROC/MWVPsyFkAG3QFZE5GOXDNxKyU2eBatmVHL7oN/QYtqV47z1pt6QhcXiQaiU4oGNVDBk18Ea4emtpeq8Zf4wv/IAPX4Dfi6mvHMUFQSzcbm8bbu7CLe0btLNgg804s4Aww8ERZVV1pNaUAAlAqk4DMSqULjU9DeBjQ0VlFVqBcUiU8LH4IHKzkEz+mrCIEE31Q9xjpfKc1nxMuj59Ph3GxZ9wcoO57xPpyGgdxatjUuyAIRNj6Ges8TaT02EgvVYeArf3Bjt7BRO3GluY4hIIzY5bst3dboN8F6De1VW9ZvllIOg1B8YXzAstci5f9mXDoKFjCLBwfyd+GP7U3cRd+HqgdHXzgCRJ6otGQ2yd8j9pIdY2l0RIbpUV5aZnFEqOIwTKvycFHw0dzDlYX6Y2twO5Gimlz0lsYe7pHMiwlNwEc/hlf8gx5BXJ5uBfieEgJFtiRtCFMXIfHVQxxYy6lwuwC9i7/k4y+Joy6VwgAmOI0UwfNS3dSB53xgxXG/fRm
 dmwZ5sFl
 MZUBskgL4LASNxwPBT/UbQDIKqeWSSVnR1CBZwaQqQcG0JX07IGpCYsSmLQ+rWq7UYHg4wyo42eKnidktPD6XSC2dci16CQzbOw9Dy8sbSSzBWqGcLHEsskEV1VCgmY1bxh/qqfNnKPuUonfGDReT/DiGAv//jClx60qhWiIlSmMznBzizjBAkQcD4gdSH9zJdbm0VHxnTr9In5IAn8wVGQ7zha1M+M8sV93wlgJxDf8GklTCFqb1uMVov67LQrR5qbo2RklJ1x5O8G1zCssjlMjVZER4HclLEfL/NITYtxOaQuPVnEu7bcXr73iRT/8dfg0SzRwntyUA65qn4zVoQrbQZLvYtRtxzVef0HXkuXucNBIS5o+enmPZKpe3LoRWCJN8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Test that bpf_copy_to_user can fault in a paged-out page and write to a
read-only mapping. Also verify that a partial copy crossing into an unmapped
page returns -EFAULT while leaving the copied byte in place.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/prog_tests/user_mem.c       | 106 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/user_mem.c  |  17 +++
 2 files changed, 123 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_mem.c b/tools/testing/selftests/bpf/prog_tests/user_mem.c
index 7fa827298d24..c87620e39abb 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_mem.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_mem.c
@@ -12,8 +12,11 @@ enum {
 	USER_MEM_MMAP = 1,
 	USER_MEM_UNMAP,
 	USER_MEM_COPY_INSNS,
+	USER_MEM_COPY,
 };
 
+static const char data[] = "fault-enabled BPF write";
+
 static noinline void user_mem_trigger(void)
 {
 	asm volatile ("" ::: "memory");
@@ -102,6 +105,18 @@ static bool user_mem_copy_insns(struct user_mem *skel, unsigned long addr)
 	return ASSERT_OK(skel->bss->ret, "user_write");
 }
 
+static int user_mem_copy(struct user_mem *skel, unsigned long addr,
+			u32 size, u64 flags)
+{
+	skel->bss->user_addr = addr;
+	skel->bss->copy_size = size;
+	skel->bss->copy_flags = flags;
+	skel->bss->action = USER_MEM_COPY;
+	user_mem_trigger();
+
+	return skel->bss->ret;
+}
+
 static void test_execute_user_page(struct user_mem *skel)
 {
 	long page_size = sysconf(_SC_PAGESIZE);
@@ -163,6 +178,91 @@ static void test_partial_exec(struct user_mem *skel)
 		munmap((void *)addr, page_size * 3);
 }
 
+static void test_faultable_write(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	unsigned long addr = ~0UL;
+	unsigned char vec;
+	int i;
+
+	if (!user_mem_mmap(skel, page_size, PROT_READ | PROT_WRITE, &addr))
+		return;
+
+	/* Make sure there is a private resident page to page out. */
+	memset((void *)addr, 0, page_size);
+
+	/* Retry pageout until mincore confirms that the page is no longer resident. */
+	for (i = 0; i < 500; i++) {
+		if (madvise((void *)addr, page_size, MADV_PAGEOUT)) {
+			test__skip();
+			goto out;
+		}
+		if (!ASSERT_OK(mincore((void *)addr, page_size, &vec), "mincore"))
+			goto out;
+		if (!(vec & 1))
+			break;
+		usleep(100);
+	}
+	if (i == 500) {
+		test__skip();
+		goto out;
+	}
+
+	/* ..and do the copy to it. */
+	if (!ASSERT_OK(user_mem_copy(skel, addr, sizeof(data), 0), "user_write_data"))
+		goto out;
+
+	ASSERT_EQ(memcmp((void *)addr, data, sizeof(data)), 0, "written_data");
+
+out:
+	if (addr != ~0UL)
+		munmap((void *)addr, page_size);
+}
+
+static void test_copy_to_readonly_mapping(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	unsigned long addr = ~0UL;
+
+	if (!user_mem_mmap(skel, page_size, PROT_READ, &addr))
+		return;
+
+	/* Assert we can copy to read-only mapping. */
+	if (!ASSERT_OK(user_mem_copy(skel, addr, sizeof(data), 0), "readonly_copy"))
+		goto out;
+
+	ASSERT_EQ(memcmp((void *)addr, data, sizeof(data)), 0, "readonly_copy_data");
+
+out:
+	if (addr != ~0UL)
+		munmap((void *)addr, page_size);
+}
+
+static void test_partial_copy_fault(struct user_mem *skel)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	bool second_page_unmapped = false;
+	unsigned long addr = ~0UL;
+
+	if (!user_mem_mmap(skel, page_size * 2, PROT_READ | PROT_WRITE, &addr))
+		return;
+
+	if (!user_mem_munmap(skel, addr + page_size, page_size))
+		goto out;
+
+	second_page_unmapped = true;
+
+	ASSERT_EQ(user_mem_copy(skel, addr + page_size - 1, sizeof(data), 0),
+		  -EFAULT, "partial_copy");
+
+	/* The byte before the fault stays written. */
+	ASSERT_EQ(((char *)addr)[page_size - 1], 'f', "partial_copy_data");
+
+out:
+	if (addr != ~0UL)
+		munmap((void *)addr, second_page_unmapped ? page_size : page_size * 2);
+}
+
 void test_user_mem(void)
 {
 	struct user_mem *skel;
@@ -181,6 +281,12 @@ void test_user_mem(void)
 		test_execute_user_page(skel);
 	if (test__start_subtest("partial_exec"))
 		test_partial_exec(skel);
+	if (test__start_subtest("faultable_write"))
+		test_faultable_write(skel);
+	if (test__start_subtest("copy_to_readonly_mapping"))
+		test_copy_to_readonly_mapping(skel);
+	if (test__start_subtest("partial_copy_fault"))
+		test_partial_copy_fault(skel);
 
 out:
 	user_mem__destroy(skel);
diff --git a/tools/testing/selftests/bpf/progs/user_mem.c b/tools/testing/selftests/bpf/progs/user_mem.c
index a62916ebc0b5..a5dd347a02b4 100644
--- a/tools/testing/selftests/bpf/progs/user_mem.c
+++ b/tools/testing/selftests/bpf/progs/user_mem.c
@@ -17,6 +17,7 @@ enum {
 	USER_MEM_MMAP = 1,
 	USER_MEM_UNMAP,
 	USER_MEM_COPY_INSNS,
+	USER_MEM_COPY,
 };
 
 int monitored_pid;
@@ -27,6 +28,9 @@ unsigned long user_addr;
 unsigned long map_len;
 unsigned long map_prot;
 
+u64 copy_flags;
+u32 copy_size;
+
 #if defined(__TARGET_ARCH_x86)
 static const unsigned char insns[] = {
 	0xf3, 0x0f, 0x1e, 0xfa, /* endbr64 */
@@ -43,9 +47,13 @@ static const unsigned char insns[] = {
 static const unsigned char insns[] = { 0 };
 #endif
 
+static const char data[] = "fault-enabled BPF write";
+
 SEC("uprobe.s//proc/self/exe:user_mem_trigger")
 int user_mem_test(struct pt_regs *ctx)
 {
+	u32 size;
+
 	if ((bpf_get_current_pid_tgid() >> 32) != monitored_pid)
 		return 0;
 
@@ -59,6 +67,15 @@ int user_mem_test(struct pt_regs *ctx)
 	case USER_MEM_COPY_INSNS:
 		ret = bpf_copy_to_user((void *)user_addr, insns, sizeof(insns), 0);
 		break;
+	case USER_MEM_COPY:
+		/* Bound the kfunc length using a local copy of copy_size. */
+		size = copy_size;
+		if (size > sizeof(data)) {
+			ret = -22; /* -EINVAL */
+			break;
+		}
+		ret = bpf_copy_to_user((void *)user_addr, data, size, copy_flags);
+		break;
 	}
 
 	return 0;
-- 
2.43.0



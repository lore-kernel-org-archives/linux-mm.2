Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E444C60A3810
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l4rOQbM2
Received: by kanga.kvack.org (Postfix)
	id 8908D6B05B7; Tue,  3 Nov 2026 11:39:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861BC6B05B9; Tue,  3 Nov 2026 11:39:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74FFF6B05BA; Tue,  3 Nov 2026 11:39:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36A4E6B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:39:24 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1D0A404B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:39:23 +0000 (UTC)
X-FDA: 85394368206.23.384B3CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0479DC0009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:39:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4rOQbM2;
	spf=pass (imf10.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793723962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fE5v4ca1Aufck5/eL12cyLA8FcbOpfZPaD75Cvy3E00=;
	b=ul2efs2tim+dnLf7NhdIDwQGIQC90P7RgZ4zOV3/znZcYJZKGXzWCv9JGimHILI8CrDepv
	JZFS5zFjOKUUSmBg5Tj39eJIqcaNtkzkwyfJpBVbBFqsrIP9UFr8FjXgJgLMOWJTDCo8NM
	UmxnBtsrse0OZgKVti/e5kYR4O8cfrU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793723962;
	b=scRTWkWlVarihACdBNoTODiGweXo7rPkvYAT0cWZOwpqh6QxxLuN1IPB1UvUGZ82w359xS
	k6+MocJcoS86fYq/2W05L5jlynUkHY6WALpf4h/Ef5/7qemRU26rJgy0RlW/qk77tECFlI
	RShV6nrHmqnzi+ri9RXtFMxrbvjPE+Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4rOQbM2;
	spf=pass (imf10.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C8F2410C6;
	Tue,  3 Nov 2026 16:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E72C1F000C1;
	Tue,  3 Nov 2026 16:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793723961;
	bh=fE5v4ca1Aufck5/eL12cyLA8FcbOpfZPaD75Cvy3E00=;
	h=From:To:Cc:Subject:Date;
	b=l4rOQbM2wW+LLPY1yUcUj6FenR+4lJF8foqE1Q3zADJxNCXVyi0Tq5CpRIh+sRhfj
	 elM3tKwEncQRmpCFKatjsz9FXNZ6cbFPIhFnPeIoPMQuFFt/n3+zaQ/UCwKF20Odxx
	 Uvu+DpYv2LGThG8SqR8OZG8nynvkJS+kMB4Ui/db98ca7o8Us5NVeffOeu00QSbgR5
	 SMddDtEhGeQ9qeStps8Crh9+ktrfcdqlXnmF9eCbxmCamiwq38/jFyhjxEwUCpeIwt
	 49br4Wy4LEXUnxrvQx63yauDEqwCZD5PFqYA+9iSMyZwhfQcnCXfpKvbhYv18jbD1M
	 uRnenNWGr9EKw==
From: Sasha Levin <sashal@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/cgroup: test_zswap: use the total RAM in bytes
Date: Tue,  3 Nov 2026 11:39:19 -0500
Message-ID: <20261103163919.641249-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: uagc4e5mhdxjp1mquxbdtxr4o8y8gm6s
X-Rspamd-Queue-Id: 0479DC0009
X-Rspam-User: 
X-HE-Tag: 1793723961-233557
X-HE-Meta: U2FsdGVkX19OxyVmv6L7VyxFRhPmUwMpsWwG9AOUeD5ShYN8ivbu/kr000dl4PjTGHzyfFU8nFwf6VqmtAMsUcDFKkn/+A/iM9KjFRcTEZTy1vIMHTMgvZvj7/mPMPOJgtIdm6TP3sKzgBwVOzM73yb0kdeGSrSEcbgxaRQW9l0afb8HNlAMznQyPpQvgGv492AhbW1CaFqcCkYBIN1cEE+YtGVgmAw3k3SXa0wCu9nodTbx68FNMExNSIRerJjcTuQqYKR1922ju7KNRWjeXDJ30LeLzE5p4RiPnED+atDFqkunzZDe/rDUsP+powIN+1R73C+1t4NrGN/64UQSEHxiy3GNl2yvdj7HQgZybaBTerNhHjEPK9fsF45Tr+xNUr9ZQTwGA10P06LZ1nHT1AyfcDOOFkY8ZUOfKlPNzEupBCTjxe7CGfgGp4zbZoZUdF6nSoYIxXw6w/A1FLhkZD+rrECyeMvmZBE13LSBT7x5H6CcevZtqn+0iuIy8XyCC73OnfiqKJ9TCGuuCSZZEX9fnDHu9x8a3UxaEvdDfPBF1in1MG/h58hk00DP11oPA3/76j8LXHUHV3bp7fxSJKcXKHHqrdYJgvhycSempnhV8TS9QbE2J6bAPoCpnozzx28I6g1VsdFG67Rhnre+326Bb0tby719pSrU7r3b3vFpgwVyxGx/B/C80zNy2UC3iiXVr8J9WbG2upAHMC7Az26dWAWIdvWAskIMP0aD2a9O3eMTLK4RZXWUyHeaB8vCucTHY7y6neiK3ZbTIYX8IrLPZl3RupWZ6tbpayypKRaYjM0EaOuVweZCI9Qkhh5uaSasnqdx5CCKZecu5ds3asjpVsR6tGSmDUhr1gigA8GvLOcFUT3tB1hNFSCNwoemmM9vyVE4Uap12XZZpxwGcTzljPhpX7QLiD2T4nTgYbdEkWE8J+Rh/IdhFro8HpCGNBLVSp41j/wd/sycy61
 kFb0/0uo
 32PMkH7VQmYWiE2/crxKsSUSgTmocyO3f7ph2I805a5cJQShuiIwGwuGSTwTNFYprSHxJQABDNTJLvgbY1EHCpeTndi6V48MceZ1Y8eyx//wDNMIPbRYFnA2mYbv1M++wByIxHHGrPrqeQLk1fVU4vCyAijFrCgvVd77EgkwED/Van4r7w7p/YivVvvDAkeABebbhg1Cc6UrxxBcwA6iItVjzlZrhyDGNLluTsupfpvoYplyqG3YGAzJgPdp2myE7/0mT86di1Qv1kUhYBN6HpNtbiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

test_no_kmem_bypass() uses the totalram field of struct sysinfo as a
byte count, but it is in units of mem_unit, which can be larger than 1
on 32-bit architectures. There totalram also can't exceed GB(4), so the
size check never triggers:

  test_zswap.c:609:24: warning: result of comparison of constant 4294967296 with expression of type '__kernel_ulong_t' (aka 'unsigned long') is always false [-Wtautological-constant-out-of-range-compare]

Multiply totalram by mem_unit as an unsigned long long and use that for
the check and the values derived from it. Nothing changes on 64-bit,
where mem_unit is 1.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Found with 32-bit builds of the selftests (gcc 16 and clang 21 with
-m32, with and without -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
KernelCI's 32-bit arm builds show the same warnings. The changed files
build without them now, and the x86_64 builds don't change.

 tools/testing/selftests/cgroup/test_zswap.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index d50acc1b83ac8..223e2eb1329ab 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -597,6 +597,7 @@ static int test_no_kmem_bypass(const char *root)
 	size_t trigger_allocation_size;
 	int wait_child_iteration = 0;
 	long stored_pages_threshold;
+	unsigned long long totalram;
 	struct sysinfo sys_info;
 	int ret = KSFT_FAIL;
 	int child_status;
@@ -606,10 +607,11 @@ static int test_no_kmem_bypass(const char *root)
 	/* Read sys info and compute test values accordingly */
 	if (sysinfo(&sys_info) != 0)
 		return KSFT_FAIL;
-	if (sys_info.totalram > GB(4)) {
+	totalram = (unsigned long long)sys_info.totalram * sys_info.mem_unit;
+	if (totalram > GB(4)) {
 		ksft_print_msg(
-			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
-			(double)sys_info.totalram / GB(1));
+			"requires less than 4GB total ram, total ram: %.1fGB\n",
+			(double)totalram / GB(1));
 		return KSFT_SKIP;
 	}
 	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
@@ -622,12 +624,12 @@ static int test_no_kmem_bypass(const char *root)
 		return KSFT_FAIL;
 	if (read_min_free_kb(&min_free_kb_original))
 		return KSFT_FAIL;
-	min_free_kb_high = sys_info.totalram / 2000;
-	min_free_kb_low = sys_info.totalram / 500000;
-	values->target_alloc_bytes = (sys_info.totalram - min_free_kb_high * 1000) +
-		sys_info.totalram * 5 / 100;
-	stored_pages_threshold = sys_info.totalram / 5 / page_size;
-	trigger_allocation_size = sys_info.totalram / 20;
+	min_free_kb_high = totalram / 2000;
+	min_free_kb_low = totalram / 500000;
+	values->target_alloc_bytes = (totalram - min_free_kb_high * 1000) +
+		totalram * 5 / 100;
+	stored_pages_threshold = totalram / 5 / page_size;
+	trigger_allocation_size = totalram / 20;
 
 	/* Set up test memcg */
 	test_group = cg_name(root, "kmem_bypass_test");
-- 
2.53.0



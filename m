Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D76C2CD98DE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 04:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB3F6B0099; Thu, 18 Jun 2026 00:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582AC6B009B; Thu, 18 Jun 2026 00:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 499346B009D; Thu, 18 Jun 2026 00:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 173816B0099
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:50:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DECA4067C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:50:07 +0000 (UTC)
X-FDA: 84891806454.30.61FC487
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id A7B8A4000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:50:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lF1D7h4v;
	spf=pass (imf04.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781758205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AC9B5YDsIulRerYhn7rz1eBAPxCjqQ7ZRwn/nMekv0E=;
	b=rIDJE9FigMtXBfysbn9BREjwp06m3gpZGv2/AmbjssYr/pjPwIfKCxNFTD4Cbv2f6zeKne
	oAMr10vsscc24Iyzf+p8rF9qyAF4NZCDZr1kTOGfvhn09RR9R8X6ai1f0PqBtG1JMMvKC1
	mujxs4Y+toxre8MQDjak1G5b1Gr28xc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lF1D7h4v;
	spf=pass (imf04.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781758205;
	b=6y1uvyoqIiJB99SToVLjAF6jsyksnXnoLzCAmfMsGuJi1zEbZ5ELRkBXFuXJUGNEY4UKkT
	0U2zo+L0nZ/BlRe8bPF+PuO1pxhPi8i/KSLZ8vUPsmxTJkLBrN6imR45NfBrF6Nbj3S2Qj
	1FziSFyHM0Qx5GCYGIwudXluHabkTGE=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8419ab3a297so203521b3a.2
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781758204; x=1782363004; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AC9B5YDsIulRerYhn7rz1eBAPxCjqQ7ZRwn/nMekv0E=;
        b=lF1D7h4vVNcs6XSY4uXWNE3C9U7S7GvnmmoA1ukdh1TmMaL/jel22bcQa5k2q7yABu
         OXhhIBHLg40/UVFtysmG4vYelduI5STmapoST4W0lGCcEoUeFkMjGFOkCRgj6GfaLgZv
         p8m1u3ZJI1Y5GRuRkYjUcFo5e1I2NV3gzstyTQhk/eDGQpYTZjkufYdzf7x3VPscbxKr
         kkdAR8FAhSXE2PXsjEfjx0yGm6pFETZCQ55yENoPJJ55QDOS6NVTvtaUdDweAwvnhham
         hgqP5X+bApPvELo/FHLkudkkXPJOBybfbc//I1gFQraB2VpmxogG6IDJNsZRbiO7bthH
         WFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781758204; x=1782363004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AC9B5YDsIulRerYhn7rz1eBAPxCjqQ7ZRwn/nMekv0E=;
        b=UsaETRWlhMC9GrHvKBLinVxwZdWKISuOvQhq6W294cAVlFhNb7ueDOQSAxdyvy3Ibr
         JaszGzkuOUCRtOwENqYEIl931kSM+VQcwaMUlDro1ALl9Xsu0baznVWAvrxtfAlVK7tE
         Z1Q64X1r8erCzC3Cfmv39gg5mHWJ0XUwephJrEN+wAC3BCegu4uXEw4F/UCo72RLuv9k
         nOrHIdl5VN/IgrENLYGKJ9XXI0Gogb74mQuDHv4osLd0sHNaxHA5m6wdpzuWW82NZ/Y5
         fZM9FNfRVWWF6/585OSE6eArVXPCs6YmPFfvDIIWZcyor+vVGxV7gPrKZAtKb6WdgY0F
         Qgug==
X-Gm-Message-State: AOJu0YxCWEPFpC9zyIdM8WKYmtHXiSmyVU1gxtQULs8bHXhbpNbZ4ymK
	ztVd66ZLkJlr04+rF/Trdb4uFKsn87U6WSc8eUTwg+2rvORf5Kc0cqPJMU4L5Q==
X-Gm-Gg: AfdE7cmouN3mnGrjjAV+EZEypXV0ypEpg1u06TVGeVwBeiArwkDMSzIBs6Y34t/P8Ch
	g/y3SGLYavYyp2/fx2QKZq8ihK3hL5KrF/yMltRQEWMlzxcy/RpdgMLur6pHBKXzfifLl0DyP79
	RDECK+Ui7vReVIFbB+Dgwnp5fx+TQLdse4kf/Js4AyLT9oMg6iOYgV/Ewe+K7YhsZe8UGd9Os9K
	0nhs6ToIKaguOEMR6y5PCGDMPX+dhS4DqrAvjP3Teo/95C+2ttXg7KZM5gs0iPVlosBCaqK0+8j
	TTosUKcR2QObr8EOyupZrcUcQlauXgLt9mxmNVXsse8j1246hksu1H/hlZeeRlhgPved7EishbB
	7WWozX76lS+RRb79J6MigtX03/3Ei3S7P8HSfkmWpPzKgAlXnuXUQWFiOiW/lR3MFQaJlzZ5nPN
	qomk1lXei+Cm2KRr271hYj0ssbiZg7oLsVTcRTsTCJkiwvXnhwEeg=
X-Received: by 2002:a05:6a00:66c5:b0:845:31a6:d84d with SMTP id d2e1a72fcca58-84531a6df5bmr4041592b3a.7.1781758204555;
        Wed, 17 Jun 2026 21:50:04 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b020b53sm17214781b3a.47.2026.06.17.21.49.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Jun 2026 21:50:04 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v4 5/5] selftests/cgroup: Add tests for zswap proactive writeback
Date: Thu, 18 Jun 2026 12:48:57 +0800
Message-Id: <20260618044857.69439-6-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260618044857.69439-1-jiahao.kernel@gmail.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A7B8A4000D
X-Stat-Signature: oni7z76p1rkap6h3atfz4tutjdr5x4dw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781758205-585564
X-HE-Meta: U2FsdGVkX19MtmxTrtu/W9ctd05lwOQjO8IeHwLlaa7qzf+6UisDJUfItOaWuhy5crxKo9i7BaahNzETS6ZU5CU0PekR3Js75mUI+WXXOHuIOd/yVMpA+TT6MuQzoWV+bUU8zeJpi26f9YATxdS97F9I+vLByAOsc+jeixeK+ARb2tDE6UWnl1sq4yYC44cu4OGZeM9Bm1fhXs5FxIYOh7URtivgBRdxuF3ESz/7sgK/YC/eGQgCLaGhNvOYGx2PlCIaxloDqE64gaZ0e4ITaM98VJEVqCy3bbexFTYUMH48EjzR2EYqPaw3S9ODtBrhBQrVPWfZJcrn2stE3+L0I8CBiHbsratfgDkAaZWs7XqkuXL+Kp3IiM5LTcDs65w7E0pwG4agcvgNvehUjgkqSHOspm55j2UfYm201C9wDAMO1oQEp5InvmZKDVIwJUTH16qJktlHgedM6mae4I3Y+ewLCrYBl3HMhVCwExOmPdZkyswBZT6zpQcLp0F/9wEpXnIP0s2mlLk7gGFciN8k7s7fcM/OSmP+BpCdQizCT2SMhBO9mx54XuAHvTTG4cSBKN0KeVvajiya1Y6QPrIgTJwAC5H8hOSm7ufpqKKCcjxPkXtDUCuOtgTOHa1EfpctWBAAWwhmGwBaCP8UREYsL2igN+bsAxCv910saeHt4WxwUzsQ2ZfTI3jhaLr0OEUYD8Tlt+K6G+jzhnGb2Es2r6zUv6gk4lKqam+VmUFj01Bx4Q4jRqavtd+23meEdRsl2Q7xEzSrItX0ZF6kX6HHPJoFYSxyUVdiP338VoDTWRVI8ymRVaJhmfU2Zeig5XRHFf9N1F+xv38D5YVtaIUYn/wWw79kSX7s2hhLSkujVFCfhbE4mDji//2EoapGYeFAAP+B22jE4Q2HLfMbohY3R2SyxFyo8+N3/oWtioUiJ+3OaWsXtKaTozp+JUhqpmKTvep/02Jbqmebhxj9As3
 bJRvQMmD
 8ZEftS57h1lEJRW8I6i2goY5klvYz4rYIYpZlGjNPPM7lAf3PzBfp9b2Nd2NbTCqug3iPN62zxod4X4HgZLcu9yygPKa8u/US8XVYLsgdT4c8kqExhgh64Nyk23DvQcDGobYlR8Ku+TO8RbJABgH0rQLUMkuFv65a8a2MwlKHt87OlCt+HACvGeSKB9ZpgffV/izDjIt7z12EeKP687C/je/iAUhoItQutU4o1brsdbEQuEbj6/HjZfU1bs61zTy2+Lgq6lCBsHRhbeQpHtrN6vpUQRlMoDoeCowUo4l9nhWnptZDGtxbhgw1QXb78sgkWD8hauaCauVt04lTgCTYnEoMKnfKJWlTk2y4KNSrnRe48NCVlre2yGzok5K3/TvQWlVqa34pnFu4kO+7lR9USXclbeCXrvt27Ft9fspI5eKIjqoxjvA2Z9pVpFubrR9NWG5aE0YM/2mtvG6vmWKZKbmypoCyfV1GyIyExpQjezyUQHY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Add test_zswap_proactive_writeback() to cover the new memory.reclaim
"zswap_writeback_only" key. The test populates a memory cgroup zswap
pool, triggers proactive writeback, and verifies the behavior by
observing the change in zswpwb_proactive_b. Invalid input combinations
are also covered.

Extend test_zswap_writeback_one() to assert that the existing
non-proactive writeback path leaves zswpwb_proactive_b at zero.

Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 153 +++++++++++++++++++-
 1 file changed, 152 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee79160..9c153fdd3a08 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -60,7 +60,12 @@ static int get_zswap_stored_pages(size_t *value)
 
 static long get_cg_wb_count(const char *cg)
 {
-	return cg_read_key_long(cg, "memory.stat", "zswpwb");
+	return cg_read_key_long(cg, "memory.stat", "zswpwb ");
+}
+
+static long get_cg_pwb_bytes(const char *cg)
+{
+	return cg_read_key_long(cg, "memory.stat", "zswpwb_proactive_b ");
 }
 
 static long get_zswpout(const char *cgroup)
@@ -355,6 +360,7 @@ static int attempt_writeback(const char *cgroup, void *arg)
 static int test_zswap_writeback_one(const char *cgroup, bool wb)
 {
 	long zswpwb_before, zswpwb_after;
+	long pwb_bytes;
 
 	zswpwb_before = get_cg_wb_count(cgroup);
 	if (zswpwb_before != 0) {
@@ -362,6 +368,12 @@ static int test_zswap_writeback_one(const char *cgroup, bool wb)
 		return -1;
 	}
 
+	pwb_bytes = get_cg_pwb_bytes(cgroup);
+	if (pwb_bytes != 0) {
+		ksft_print_msg("zswpwb_proactive_b_before = %ld instead of 0\n", pwb_bytes);
+		return -1;
+	}
+
 	if (cg_run(cgroup, attempt_writeback, (void *) &wb))
 		return -1;
 
@@ -379,6 +391,17 @@ static int test_zswap_writeback_one(const char *cgroup, bool wb)
 		return -1;
 	}
 
+	/*
+	 * attempt_writeback() does not use the proactive writeback path, so
+	 * zswpwb_proactive_b must stay at zero regardless of whether
+	 * writeback was enabled.
+	 */
+	pwb_bytes = get_cg_pwb_bytes(cgroup);
+	if (pwb_bytes != 0) {
+		ksft_print_msg("zswpwb_proactive_b_after is %ld, expected 0\n", pwb_bytes);
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -770,6 +793,133 @@ static int test_zswap_incompressible(const char *root)
 	return ret;
 }
 
+/*
+ * Trigger proactive zswap writeback with the following steps:
+ * 1. Allocate memory.
+ * 2. Push allocated memory into zswap.
+ * 3. Proactively write back zswap pages to swap
+ *    using "zswap_writeback_only".
+ */
+static int proactive_writeback_workload(const char *cgroup, void *arg)
+{
+	long pagesize = sysconf(_SC_PAGESIZE);
+	size_t memsize = pagesize * 1024;
+	char reclaim_cmd[64];
+	char buf[pagesize];
+	long zswap_usage;
+	int ret = -1;
+	int rc;
+	char *mem;
+
+	mem = (char *)malloc(memsize);
+	if (!mem)
+		return ret;
+
+	for (int i = 0; i < pagesize; i++)
+		buf[i] = i < pagesize / 2 ? (char)i : 0;
+	for (int i = 0; i < memsize; i += pagesize)
+		memcpy(&mem[i], buf, pagesize);
+
+	/* Evict allocated memory into zswap. */
+	if (cg_write_numeric(cgroup, "memory.reclaim", memsize)) {
+		ksft_print_msg("Failed to push pages into zswap\n");
+		goto out;
+	}
+
+	zswap_usage = cg_read_long(cgroup, "memory.zswap.current");
+	if (zswap_usage <= 0) {
+		ksft_print_msg("no zswap pool to write back\n");
+		goto out;
+	}
+
+	/* Trigger proactive zswap writeback. */
+	snprintf(reclaim_cmd, sizeof(reclaim_cmd), "%zu zswap_writeback_only", zswap_usage);
+	rc = cg_write(cgroup, "memory.reclaim", reclaim_cmd);
+	if (rc && rc != -EAGAIN) {
+		ksft_print_msg("proactive zswap writeback failed: %d\n", rc);
+		goto out;
+	}
+
+	ret = 0;
+out:
+	free(mem);
+	return ret;
+}
+
+static int check_writeback_invalid_inputs(const char *cgroup)
+{
+	static char * const bad_inputs[] = {
+		"zswap_writeback_only",
+		"1M zswap_writeback_only swappiness=60",
+		"1M swappiness=60 zswap_writeback_only",
+		"1M zswap_writeback_only swappiness=max",
+		"1M swappiness=max zswap_writeback_only",
+	};
+	int i, rc;
+
+	for (i = 0; i < ARRAY_SIZE(bad_inputs); i++) {
+		rc = cg_write(cgroup, "memory.reclaim", bad_inputs[i]);
+		if (rc != -EINVAL) {
+			ksft_print_msg("memory.reclaim '%s': returned %d, expected %d\n",
+				       bad_inputs[i], rc, -EINVAL);
+			return -1;
+		}
+	}
+	return 0;
+}
+
+static int test_zswap_proactive_writeback(const char *root)
+{
+	long wb_before, wb_after;
+	long pwb_b_before, pwb_b_after;
+	long wb_delta, pwb_b_delta;
+	int ret = KSFT_FAIL;
+	char *test_group;
+
+	if (cg_read_strcmp(root, "memory.zswap.writeback", "1"))
+		return KSFT_SKIP;
+
+	test_group = cg_name(root, "zswap_proactive_test");
+	if (!test_group)
+		return KSFT_FAIL;
+	if (cg_create(test_group))
+		goto out;
+	if (check_writeback_invalid_inputs(test_group))
+		goto out;
+
+	pwb_b_before = get_cg_pwb_bytes(test_group);
+	wb_before = get_cg_wb_count(test_group);
+	if (pwb_b_before < 0 || wb_before < 0)
+		goto out;
+
+	if (cg_run(test_group, proactive_writeback_workload, NULL))
+		goto out;
+
+	pwb_b_after = get_cg_pwb_bytes(test_group);
+	wb_after = get_cg_wb_count(test_group);
+	if (pwb_b_after < 0 || wb_after < 0)
+		goto out;
+
+	pwb_b_delta = pwb_b_after - pwb_b_before;
+	wb_delta = wb_after - wb_before;
+
+	if (pwb_b_delta <= 0) {
+		ksft_print_msg("zswpwb_proactive_b did not increase: delta=%ld\n",
+			       pwb_b_delta);
+		goto out;
+	}
+	if (wb_delta <= 0) {
+		ksft_print_msg("zswpwb did not increase: delta=%ld\n", wb_delta);
+		goto out;
+	}
+
+	ret = KSFT_PASS;
+out:
+	cg_destroy(test_group);
+	free(test_group);
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct zswap_test {
 	int (*fn)(const char *root);
@@ -783,6 +933,7 @@ struct zswap_test {
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
 	T(test_zswap_incompressible),
+	T(test_zswap_proactive_writeback),
 };
 #undef T
 
-- 
2.34.1



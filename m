Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD93C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C971D6B0005; Mon, 29 Jun 2026 07:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47F96B009B; Mon, 29 Jun 2026 07:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37646B009D; Mon, 29 Jun 2026 07:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82DA76B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:21:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CCCBA0671
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:35 +0000 (UTC)
X-FDA: 84932709750.06.153EEA2
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD4561A0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:21:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o7D1rOmm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782732092;
	b=mmI7V0D9xj701Y76Kfxp2rChYffiGuXXdcdIE+OV/TpNV6emVV5guP+bF25jfuPlDqMFmT
	Yw5/kDES9Z4a29vTw4HsuwF35qMROsD5Y/klNwMaYL91vpGZqd3l2TXVW4bHqm6Cvk3hfe
	J2fowILxG6QOgqgarGo3j6o8YMcAvC4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782732092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFDvCEsQoPukFv687y8Q7d8QC6mycXohjdzF/lNSz/E=;
	b=bbwPBq4FWgG3x9M8kgSHnSSadkeEnaQFhElZQjUO1uN6aWG61Y+SU5aOBUzH+OOgyO1p54
	bdcAnRmQs9zirwO4ADvM3F5vZMXOvmUegXKqD+szGigkci5Eh/OUtqu2rbnRM66XNqy+FC
	TiT7ksIF7I5afO8frAoSmFw0CBMGVC4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o7D1rOmm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ca11143dbbso3268175ad.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782732092; x=1783336892; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MFDvCEsQoPukFv687y8Q7d8QC6mycXohjdzF/lNSz/E=;
        b=o7D1rOmmaNaU9dku7k8wTfUfM1j6HarXMhRwSpfShZOBtf5fh4c2CFJMjz0BYMG78y
         47HhBAiCUYEH4ubpOU0CGO/2qFcmGHpkiGt7PeZ0wZ/phz/KPjqwZUnQt+zlfL6j2VkK
         b5fW5Jv/RZN4WiHfU1a2nVctRjmGix+hoJeafannTKOzv1qVZg8MMYb5JM6UzyQA0ejt
         0kKKZWuv3xNA4rgKvHrowT0hgTjqlQWClfbvsERbAq3tMlxrhts8GO/5S454ZwSO7Apc
         Uq64bRGsEBBfxZLiwtRaIzANAw6GdfynxELckVYkFOxobKdwbVpZn69YkC3v+/fxINTP
         HKtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782732092; x=1783336892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MFDvCEsQoPukFv687y8Q7d8QC6mycXohjdzF/lNSz/E=;
        b=hD4u8b4vlHSksqzrLDkWjQRxX1nnDpA01sqJjz+UPNstkerzmQs6de51LQWBK3U0EH
         1Jv+cZVamuMn196mTVju1jGni0P5YFGEC2C7yFFI1kB1wWCxv8ytIacO2QMOiE0kYxTE
         x1gchYANvd9JNwQWD9HFkBObal3kp/LDkAVJ1yd9Wer0lPVc818ye3CQaHYZLIFZf0qw
         7gDkZJBvtBSbvZdLTF4Z2NGdCdz9WbyE1OAQwk20PAgVfXI2uUWCX9FCUe101uAjr1t9
         3guic2GFmHgIau7pFjKJBtFQi5zmXQ1C+ATh3cNkKQHZxD4/x3uNyd7vV92+7KVAFfLC
         uHWw==
X-Gm-Message-State: AOJu0Yw15ssVnZPNp/Ir5y0Z5VqzG5V4tKks2v9TUl2U3e3bOaog9P1L
	gEQbHF8mC4u/joceCCX7J11zOH3m/hLZIeWoLTJ6d6TZioll9KIfAlbm
X-Gm-Gg: AfdE7cmjQipff/+7SodlpqrDoEa/cFRGSTJjWSH+lpVhFmzIT8v4xWMDBqHGcogqjt1
	LzsprE/reCddYOofe4+MWmgdq95Xm/Va/o38omXCEcGUjJqCmiGcINxhsnM88ASdu6LbsNLqGQh
	enPLXPFWfIsGDWpODj/fTYkU9kRep5g44yH1EHwMLwTIisiWHrU00Uxkq2cdpChZHMJZxTndMTi
	rE8BdkoiV/PMsPT2gtlQPePBtUoztZXY8B13kwUl8qxs/funoHC93FOCVlSy90TyXPfCSftK05y
	cBAaUuo4W9sEIrZpbSZ8Del5gzUVQ+8q4kEYtCXUt7IVygdXldv7+VIJoKqi9Nu01GTsy9KsHzm
	bIBLqLMuJurS3pOpMCOAoWypzh49PNyGldoDpFzQopg8JFv2Ar5xSUQkgcLfKj7+J5hOEbpBIYi
	y05UGcmW3C3MwmlKAbiVVWuto2vHBSxANignXbx5kn
X-Received: by 2002:a17:903:b86:b0:2ca:e3f:6a4a with SMTP id d9443c01a7336-2ca0e3f6c4emr17005765ad.21.1782732091673;
        Mon, 29 Jun 2026 04:21:31 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63d09f0sm92759085ad.56.2026.06.29.04.21.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jun 2026 04:21:31 -0700 (PDT)
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
Subject: [PATCH v5 6/6] selftests/cgroup: Add tests for zswap proactive writeback
Date: Mon, 29 Jun 2026 19:20:32 +0800
Message-Id: <20260629112032.20423-7-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260629112032.20423-1-jiahao.kernel@gmail.com>
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BD4561A0005
X-Stat-Signature: p6rdd3zeti5xzenn7pic3ffhrodthqy5
X-HE-Tag: 1782732092-212006
X-HE-Meta: U2FsdGVkX18/S+icJCmIQVe3uEAUXHkDIcLcG+ptGkanPe7xgJzLs4LaLiJqNXJCUy0YsCerisN09WOH4CccKaYtfv1T4vozfM8+1t83O6R3jbbJQJ4ebmWl+EJf3riKri2r73L9E6VKA1JJu1+NbciS10CRhbTwget2wLNhCAfwXyvY0Yu4AbUPX7OtA0e/TejXkbMpQ/CB0kHc6SQWkEXZefSqKSZ5v3n9BkCyDQQY+H/RbgnlBHfHJeMgc8Wum9ZlyXBpTpaQY49/ZU1wl9IHXNUCD3LSBFIwMME9iI3YjZbGEDPCLuynI7jKtgZbDPeggXjC7Old+GzNmdsdtv+sQRVUh9wZB2jYLuk52T0k8yHWK2s1EURsOsXZnqgwI0mICpcoH7NWoDib+tBsnbqi+EsxeP7N+6BTPgFHMsFjszA9bmjDazZUTgikvRP809lbBdGnt5Jovb9z6K+PralXeNLdIL76uHKUAgKb6ujpz8dcxa4SyP/hpsUMMNN3bRgPPZS6GdoLGTQj/s7JHdYFtFApsQ3I2TfWESQL8yodGv0L/RLRKx4px/uz6TX5IL6CKBwNtdWgTwAHWrLV5LASih+QCAWClnbH5lYITHpiuPLMKr7fCc15wvQIdUYZL8smV4kOSLrRY7xqJnKLVSCnBHdvWYLdvJBX00izhx9vsqV7AKjjR2wE0UmHydHb0CIEtSegdFDftJED/3jrBHfaELe6AzJLbBrvOQmUrbvXLq/t6YGNu56ecpDCoR+Vupc5FDR8pg1gt1avyJUKge4P/HgB4hwn+cVTkOh/j5Eh5LLOIGBk1CmWOp3f7RQOwZ9T/gvNObEYM4U6QKu9elIaC2HxhpXFOhkU/yypW4n1Z43BtRngWMFFekR39nnRQekUh66nolIoCyVx/4pa8i9nNF2tI7bKnDxopoHVvTn+9C6vBfVln9764P1DWlyDblTu4TNOB62kdir7IA+
 A+x6iIva
 qUmoAdK90tWXXu+f8t9SeHw5YGHlWOXW41Kk/z0K1mWmDMQsqCH4IqOy5rJs1FXpiGVyAZSa08LpaOdsZEOXQl+e8Sb/m9/OjUl2897O7RbnTPZXtdhs6J8edwzs7iW8TZCB5witZRQuG0XQ6NPq0qjo5msifDmomOQNnfzPzUfJVic1Mt9hC84GKKK/8Xy8iPoZi2DnTmGyp9I1IEsJoVRYBp3d5fPJzNIeVa6GVQvq0mo50Gh1/8lVUV9wfFBXYxqXjSZJHgpB9Vzlew6aJceVJoQ/s1L0uoiY7asQECvDjGrNi/vqyCfMplNQv8a9nvaE16gl/5u7YroU7SWVwDxxMJOtaFTwmD2QoC0KpJMHNTfkc92X40+D9M/9vthJ9WubaydS61KXRH9mvcHNocHMA9Wpd8BKuhyuBEeQ2/7ga6VBfJjHduxZOrIW5zUDazeeeRVW5ABL2N3aey4IH92hVnGbrd/+yCSAVyz6ogfCBFic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Add test_zswap_proactive_writeback() to cover the new memory.reclaim
"source=zswap" key. The test populates a memory cgroup zswap
pool, triggers proactive writeback, and verifies the behavior by
observing the change in zswpwb_proactive_b. Invalid input combinations
are also covered.

Extend test_zswap_writeback_one() to assert that the existing
non-proactive writeback path leaves zswpwb_proactive_b at zero.

Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 161 +++++++++++++++++++-
 1 file changed, 160 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee79160..dfd5f24b9d99 100644
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
+	if (pwb_bytes > 0) {
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
+	if (pwb_bytes > 0) {
+		ksft_print_msg("zswpwb_proactive_b_after is %ld, expected 0\n", pwb_bytes);
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -770,6 +793,141 @@ static int test_zswap_incompressible(const char *root)
 	return ret;
 }
 
+/*
+ * Trigger proactive zswap writeback with the following steps:
+ * 1. Allocate memory.
+ * 2. Push allocated memory into zswap.
+ * 3. Proactively write back zswap pages to swap
+ *    using "source=zswap".
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
+	snprintf(reclaim_cmd, sizeof(reclaim_cmd), "%ld source=zswap", zswap_usage);
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
+		"source=zswap",
+		"1M source=zswap swappiness=60",
+		"1M swappiness=60 source=zswap",
+		"1M source=zswap swappiness=max",
+		"1M swappiness=max source=zswap",
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
+	/*
+	 * A missing zswpwb_proactive_b stat means the kernel lacks proactive
+	 * writeback support, so skip rather than fail.
+	 */
+	if (get_cg_pwb_bytes(test_group) < 0) {
+		ret = KSFT_SKIP;
+		goto out;
+	}
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
@@ -783,6 +941,7 @@ struct zswap_test {
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
 	T(test_zswap_incompressible),
+	T(test_zswap_proactive_writeback),
 };
 #undef T
 
-- 
2.34.1



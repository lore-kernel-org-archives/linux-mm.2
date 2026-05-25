Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7AF6CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48B7D6B0099; Mon, 25 May 2026 08:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C666B009B; Mon, 25 May 2026 08:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351A36B009D; Mon, 25 May 2026 08:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25B916B0099
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:23:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE0A81C0153
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:23:28 +0000 (UTC)
X-FDA: 84805857696.13.3DFBEDB
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 19D331C0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:23:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nOjUoQUn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779711807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDMvc5EPEd1kHb+nfQyiXVYziOBu/xsFB5tWsJV33wo=;
	b=iBZu3yERVXVTUlCYHtMNDvpGZknlM4nD/tKaSmEXwmeJYFpn1CyxfdTZxC+HDkCMBdgFJk
	S8JKsfKg0ptEIIM+l67M6iIrThfTdrwC7gfs1hNUf9CksKJ5PSTpw7NN5v361SEKGmwbQf
	9Lrdh2Uy/lw3nVEtrM259YHXUGVHcvM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nOjUoQUn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779711807; a=rsa-sha256;
	cv=none;
	b=bL5puEoZVUe8VaVWWCCuaQ+lqze2pC3isIf0SVr88nDsXbOEJPzHosSmr1w+JVa9RUwTtS
	F7QK1C2qQTVvuoMyzkWC6EbyeraIxvsO9ASX4aNRSQLxU3qBjsJxiPmmS0cHiIfw93oDmf
	fphfeNjM46NorUNWyW82ELekNkyIUSc=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-365cae89bf5so4179889a91.3
        for <linux-mm@kvack.org>; Mon, 25 May 2026 05:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779711806; x=1780316606; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tDMvc5EPEd1kHb+nfQyiXVYziOBu/xsFB5tWsJV33wo=;
        b=nOjUoQUnfDpO9Yeods6hBaKcaucLqf67PmtIVyRHbB73NrVv9jyP/v9aVzr4dyYPyA
         PK5Jx/0Z4jbyvH88zG8Blfo+7tgVLqGHmya8Z2dtwhFqwfYcXX8FYvYBxh08BJmap5lX
         sNnrTvpA1voyV8xnj9fzl75Z1/wxv9Bnm6+tWJkUJSiZtq/DKFshIHx8qh+q6gx+ni7d
         oHAMgg9aW9f/5yo+9hbvHTvDmhz3OVUkH4NIlJANe564iQ6MVh9gG5Fi1SGFwypdikvc
         saxQfwqY4RVvf8LYocIghQEZ4Cvlarwg2hEEwGy/o0jyimOzJ+VV2X4T6GlKtV7IytV9
         1i1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779711806; x=1780316606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tDMvc5EPEd1kHb+nfQyiXVYziOBu/xsFB5tWsJV33wo=;
        b=dU/6brjrQEp89k5p6lOB6UwxmTze9tt7412t7JiEbsJyvOOlUAvMC/tgb8K5JIBv99
         y1LoS4a1bGulhivy4KbTkHtgCd9OXpCkaieV5b87DXxjk7xd5pLuaGMgLUjjvYTHyEj7
         Cb7bAZKmPe7qRZ70MBOTsrxtc9FxpmvX6L0hBE3xNNfDOGiLh5Dx5T7lFjVo2MdPWP4t
         EAr9sETlAjMtsqeMU5+ZM3xzKYp+OfTU/uaTVx8F3034Atp9wsO1/2gT4euGAnaHUOEA
         XldCwUVqlxqJyF09lqFxg3I7HNHkzKeAW/BllHuSTqaaKMSu93wFHjd+IRrxCm9+XgV4
         KzmQ==
X-Forwarded-Encrypted: i=1; AFNElJ/XYjofnNAyv1E3eiDZagClbjReYe+mFhDtsEOKjPB1WAixoyx9HbI9MN6T4NKU+jrOoboGEgLqdw==@kvack.org
X-Gm-Message-State: AOJu0YzUzYx82iUbWJoZL8h89LPCaz6vhRqb3W577KZ9F2jk0OfOCyAv
	Yp2JvX+XOG/Pa+BPxzeBwXtD1Qy5Z+CKk0/Xm0FSCEEUZGwmftFf+m0QKs0bBw==
X-Gm-Gg: Acq92OHLrh8XOpgZQ48Va/wgiHJc/KBNswOCS9qsqfC9oSps+lfVhcxLteSKszGrjyB
	bcXCkW6wkrftp4cegXpsm7kMiJ7gdGrqDcz7hbvARYORFLTv7YUx7PCcbcbb0tnSrcb6JI3zLNN
	FoE42wjFLB8LHBzQE9qNi+45ywq7MPDAKJ+HJETuP87m1iwKlWR3ILICNk+LFa3yb0FvSYu+4lE
	Y1h6Aq5aHG5Qs+lhye4mCuZqxrBsUPC70RqZl14yLT3pe0NPF1alcBeFQy0uggZH2Oyh+MMFHqX
	UUERPjynkrDAdVKI3NSy21+1fYUYmCQ29vVdTxEWMrdqa/6+sNR/5FGK2NZ8A9nJ1JiqswksRcM
	zmc6nnXX7PRCSsFm7JhrjaaJfb7qpk8tvSnx9qvpYkdgV1pnRrprnIhPG6dslnXQfmMM1DbCtw7
	ynWyVSF5NQ+ctG1CILmX8PdRyuLtRo2aMxnHZQ6tbm4tInI8f5x6o=
X-Received: by 2002:a17:90b:2cc4:b0:36a:35df:769c with SMTP id 98e67ed59e1d1-36a67505a3fmr14458568a91.15.1779711805868;
        Mon, 25 May 2026 05:23:25 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a72c913a1sm8999131a91.15.2026.05.25.05.23.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 May 2026 05:23:25 -0700 (PDT)
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
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v2 4/4] selftests/cgroup: Add tests for zswap proactive writeback
Date: Mon, 25 May 2026 20:22:42 +0800
Message-Id: <20260525122242.36127-5-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260525122242.36127-1-jiahao.kernel@gmail.com>
References: <20260525122242.36127-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e794krjxe1w9g5qqf5jfp6f36gbb7wzp
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 19D331C0007
X-Rspam-User: 
X-HE-Tag: 1779711806-529080
X-HE-Meta: U2FsdGVkX1992FdEiE8/Gk3UdXtZBtsRvQXQeemwIJXjV1iAei3B9QrZ/BTj66Dzs4rMlbpwVGPCb4H3ILVn8gB/p6Usmtk3rSzVApytQ12AA5d/FFPiSRo8oou+dzYIWTEkJw2ZaZZEJIonaY1I0SU9KSmFEPaFt/cwBJgrmGGsSc7ady26Zrz8YmlFh1xmEypkybKctOhHgtSabNYimJLx/P94PE1gtF9QIi6QlRVzpPQxPtMHKhjjBmNwP98KfcWLXr0EcML5qssxw+5Z0GgIr6Cb/jDgRkbZG3wSFZEk256rwn/J9Mt4g+o4mu4g87volqJ1hP5mjAjG8EYbnyJXTpQ5QntINzz0fB5RTY+T5U1S6O88fjfK+1XWHbxuUFYLXexdLYBjQXDVcA2zoSddYWe8SdZUaVlOfI9xeMmVU4aepu8w95ryfduElOpy1gKraD5OXrfTluT2RSpZkCz6F320GcD/T79U/rPWJT1z8BSqyH7OrVTMsFfqry1/NCG/nnPgdxvM4DI5NRZ5YgUWpkhPJ3Zt9HWM2QboCJNMM+Q3s1laPAGLRCGbkk/DHQXt58cE+1uo5CJuiwrmn6PlH5wceeBhKjFvJ4T89DYvV80eL9LqJlfnryEsSne2ndScmmxAZaQrGuXB/d4aF7XYPIT0QN5a6XKeCElXHojeW/DNC4FDzyFFWftbNzisEeYi88awDoxhwBzZT4KXEnTHC4lhbIu/3K47/YCLQ+iJBHRuvjbvlJCcVukiRwcNaFI1v8weiPXI4uFRE9I//KE2nP2cNgNy+e37eE4Y7y8jzvwaT+frzSR0Eo8pkOF6QlE8PetGlvQw+C/Tiz4Xi7IEeaUXPhD7cGagHCnDgl3PJg22WN57w6UQe/daILlCpaQDsnge6h0NszjIMotE2JJOIXYEMGemQ3FK2AscJJxo9VNB73TbkIWo+KlhYyT+kgjG7M3395ckj7pOUww
 zRxAj1kv
 DHDNWHLJQyLMit8btDuSzuaWTU8x0dNmBe/hJ2cAa6Tiq/f0RgYKbheGVJwY5zsTe4ccUy9TcgZtbOG0R0eKUFErbYQfOrxalY7HSTwVFVDuC7P/5nOUGAIhsFahIw9hzdAM/Q29HxM37QaUffyTKuRGDUU4Nzq2+685Szbt86tfchaJ62bXPVrAOpOavrFIEuqtYILXLiLNS3yRPSZHc+9UW5bMX0ZYRhBvY7Ln3PuMnARkbdHxA1rsnBa+z4Er6pgjCHG03ws6Usu56zUv8xet5d1BpPiXCKTzluCytxlzMieyGCsdDOLfwZZVf5EyD6ccrro+pJAKzhmOrXpI9wXCMKMTcIfzxsSqNC311J9yWTEov0leuKEFm9PwanZzBnzTrlXDBi8VOCqn7muGM5WJveLDLSx6doumJHQRPS7aKOrpCe1VgFzsM7o8kWJDFfDVld4zIMYEppZhZDvDVDpgi/lVQt5a4HkZjY/JDMNhRW1jGI1dH0IIpY7RCByeBsmU1HGTsKRBUFVlBud/106wHVaheXaZypK5q7i5t9iCKUxBvpYv1P03oF+VhFIl6YMho
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
observing the change in zswpwb_proactive. Invalid input combinations
are also covered.

Extend test_zswap_writeback_one() to assert that the existing
non-proactive writeback path leaves zswpwb_proactive at zero.

Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 161 +++++++++++++++++++-
 1 file changed, 153 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index a7bdcdd09d62..b80ed13bc5e2 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -57,6 +57,11 @@ static long get_cg_wb_count(const char *cg)
 	return cg_read_key_long(cg, "memory.stat", "zswpwb");
 }
 
+static long get_cg_pwb_count(const char *cg)
+{
+	return cg_read_key_long(cg, "memory.stat", "zswpwb_proactive");
+}
+
 static long get_zswpout(const char *cgroup)
 {
 	return cg_read_key_long(cgroup, "memory.stat", "zswpout ");
@@ -323,11 +328,17 @@ static int attempt_writeback(const char *cgroup, void *arg)
 
 static int test_zswap_writeback_one(const char *cgroup, bool wb)
 {
-	long zswpwb_before, zswpwb_after;
+	long wb_cnt, pwb_cnt;
+
+	wb_cnt = get_cg_wb_count(cgroup);
+	if (wb_cnt != 0) {
+		ksft_print_msg("zswpwb_before = %ld instead of 0\n", wb_cnt);
+		return -1;
+	}
 
-	zswpwb_before = get_cg_wb_count(cgroup);
-	if (zswpwb_before != 0) {
-		ksft_print_msg("zswpwb_before = %ld instead of 0\n", zswpwb_before);
+	pwb_cnt = get_cg_pwb_count(cgroup);
+	if (pwb_cnt != 0) {
+		ksft_print_msg("zswpwb_proactive_before = %ld instead of 0\n", pwb_cnt);
 		return -1;
 	}
 
@@ -335,13 +346,24 @@ static int test_zswap_writeback_one(const char *cgroup, bool wb)
 		return -1;
 
 	/* Verify that zswap writeback occurred only if writeback was enabled */
-	zswpwb_after = get_cg_wb_count(cgroup);
-	if (zswpwb_after < 0)
+	wb_cnt = get_cg_wb_count(cgroup);
+	if (wb_cnt < 0)
 		return -1;
 
-	if (wb != !!zswpwb_after) {
+	if (wb != !!wb_cnt) {
 		ksft_print_msg("zswpwb_after is %ld while wb is %s\n",
-				zswpwb_after, wb ? "enabled" : "disabled");
+				wb_cnt, wb ? "enabled" : "disabled");
+		return -1;
+	}
+
+	/*
+	 * attempt_writeback() does not use the proactive writeback path, so
+	 * zswpwb_proactive must stay at zero regardless of whether writeback
+	 * was enabled.
+	 */
+	pwb_cnt = get_cg_pwb_count(cgroup);
+	if (pwb_cnt != 0) {
+		ksft_print_msg("zswpwb_proactive_after is %ld, expected 0\n", pwb_cnt);
 		return -1;
 	}
 
@@ -709,6 +731,128 @@ static int test_zswap_incompressible(const char *root)
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
+	size_t memsize = MB(4);
+	char reclaim_cmd[64];
+	char buf[pagesize];
+	int ret = -1;
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
+	/* Trigger proactive zswap writeback for the same amount. */
+	snprintf(reclaim_cmd, sizeof(reclaim_cmd), "%zu zswap_writeback_only", memsize);
+	if (cg_write(cgroup, "memory.reclaim", reclaim_cmd)) {
+		ksft_print_msg("memory.reclaim zswap_writeback_only failed\n");
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
+	long pwb_before, wb_before, pwb_after, wb_after;
+	long pwb_delta, wb_delta;
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
+	pwb_before = get_cg_pwb_count(test_group);
+	wb_before = get_cg_wb_count(test_group);
+	if (pwb_before < 0 || wb_before < 0)
+		goto out;
+
+	if (cg_run(test_group, proactive_writeback_workload, NULL))
+		goto out;
+
+	pwb_after = get_cg_pwb_count(test_group);
+	wb_after = get_cg_wb_count(test_group);
+	if (pwb_after < 0 || wb_after < 0)
+		goto out;
+
+	pwb_delta = pwb_after - pwb_before;
+	wb_delta = wb_after - wb_before;
+
+	if (pwb_delta <= 0) {
+		ksft_print_msg("zswpwb_proactive did not increase: delta=%ld\n",
+			       pwb_delta);
+		goto out;
+	}
+	if (wb_delta <= 0) {
+		ksft_print_msg("zswpwb did not increase: delta=%ld\n", wb_delta);
+		goto out;
+	}
+	if (pwb_delta > wb_delta) {
+		ksft_print_msg("zswpwb_proactive delta (%ld) > zswpwb delta (%ld)\n",
+			       pwb_delta, wb_delta);
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
@@ -722,6 +866,7 @@ struct zswap_test {
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
 	T(test_zswap_incompressible),
+	T(test_zswap_proactive_writeback),
 };
 #undef T
 
-- 
2.34.1



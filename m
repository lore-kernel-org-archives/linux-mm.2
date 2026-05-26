Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6AFCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1D76B00CD; Tue, 26 May 2026 07:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879246B00CE; Tue, 26 May 2026 07:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790136B00CF; Tue, 26 May 2026 07:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC966B00CD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:46:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CD5A403E1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:54 +0000 (UTC)
X-FDA: 84809394348.21.4E8BAF7
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45972180005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CWh6txkg;
	spf=pass (imf16.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779796012; a=rsa-sha256;
	cv=none;
	b=xOne4cNCZBcMrrQ4Bdm/9jJyxse6sZb2wYn09y+8qE2R0QGgUVHblIbVVVEs6px5ScVkH4
	LPpAju+PbZEQ4k3b0lOEWT9kurFCPsh9z/2oKloSnhoVHIgQLGxGA917Rsl5Lj1O+Z6wD2
	T+0fGLNog250VLrUkO3B3n508eQVeN8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CWh6txkg;
	spf=pass (imf16.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgSgho/uSma27Dv6R9PjYX30l7Y2Ab+qd5YVtfXCHFQ=;
	b=qGnFFjIRSzzkuqvs56d3aNswRiBQTsBOsAZfm9xyFR+tRZpiye6P0e+Z7GQwqBtiWgp0VO
	38BWvYYuI7P8RvzfaYsmpehRtU964wWTYtSIXDI/+R75hQCwxbNqfxiGdaxu2V9SecqfKS
	QCSxSywtjJTVhQAVq9ZzbVBRjHbb6Vg=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c8021c8c42fso4185969a12.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779796011; x=1780400811; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lgSgho/uSma27Dv6R9PjYX30l7Y2Ab+qd5YVtfXCHFQ=;
        b=CWh6txkg4sni3SnVa0qBwA7TS6hYzU4b7hLeyngZ64BXlA0Gs3Hsk/aLf/IbTi+g7b
         VNPA6pLUmI49wNBhrAHENc7LAI4IY09jO7z4Q9UfnU8mTLSPkUDSh7lkqLuVwviAdyVS
         EGgHsn/p0eJ/FbdCIvDm8AOOGdYSHQyKiJU1BbFoVrkqZKCuddI/pw5uuuJ8qWucFDdU
         0DEQmVX5G+1hua5gIUS05hhgY1dD8Vg3sNwe0ZwnAstZ1ci+mjvQA/rH/OiN09eneclx
         SyAzQfVkhyjTjZSrVjzkDGLxiDs96McHXYPwnTipm0o+hdnBmRelh8BoruLAEDO4kEbE
         OyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779796011; x=1780400811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lgSgho/uSma27Dv6R9PjYX30l7Y2Ab+qd5YVtfXCHFQ=;
        b=fh6vx27Ypgttk5M/rLeAhptPQ0KZl00b45FA5tvOHRQbW3YEMuaeTmdCcZxFc22mrR
         JvY7OCxWLcVaIdx50+gMQWmxw5hjHjrYFDtVceE7KCzKxlIN0RN+brHVR4VM5Vv/gB+K
         zNoZJ1twvFD+25b6IEMq8PU89IyJusgUDPZoV1ESZegLup3bXdHdwutcxZzIP4McpA2k
         eSC1KoFAi2+P/4lauNrvtM1a9Muoq/XGiKTnjEIY1IavS0EmjmujWDkl/pQBMWcAbMMj
         enFjG7SNBVa1m8C3tTnQ82gNFhDl0guyBOO+s2bK2kfmLkW20r+/mne+43ZFl9jQoEco
         CL6Q==
X-Forwarded-Encrypted: i=1; AFNElJ/T3tisI5RC/D+y8eJlOsk7EZZozrk5U59v7u4feVx64ji+AwKyq34IXd1Ed93whM5piqSeG2lKRw==@kvack.org
X-Gm-Message-State: AOJu0YxvuNch/Cevn+gBMvRkDbLNj15OL7YZg23F7Du4IlaLS0CPG9EZ
	QQDuyiprlRkHJN3DVrxWw28oiHULLiRlL9G6U/gmVtU151ZtbqSmbeKt
X-Gm-Gg: Acq92OEUyPEZsrE74FioVzCiB357+TMYA4B6lXrel42LR4RnL6wjudG6H4FzQftY9xP
	CxBtOgPtxuawT4wQZPxqj/NUqu4hseNZLt1VcuM2tEvWAZZYGq/medgtIBbZDVWGzSy0lYqNaiD
	wtyluihdSTNtFzHGQZ7UPpFWLzQ1FIZXzVHsEpRaZ9VFNqU+0bJDeTaImpi6tgJIZKWBPwhpT0f
	GIGoJyJJuNkWEK9MOGGcbCjEvaw3FQaDJsaknIBO+cef5GPCb5vjoOqKrhQkRXxNPQfCyPQr8dz
	yDVIPvPvuTe/myMBxikFypuHcWP7vd3XYaTa4lYavKdxLIhtyE/hIjF6sbWWXwTXxHdcf8T3xce
	ZgoBxizCp5iXSnsHrW9vionW1ozSUETuS3GRF4JY6mOVrx5VEVPtvEyQEDGNnrE1b7HtEjiNYkm
	uRhRoWdrCtwfkgcN7d/npvzvvbVvNsaBMYeL67IgozuiYofM4o7F0=
X-Received: by 2002:a05:6a20:7491:b0:39b:8dcb:f36d with SMTP id adf61e73a8af0-3b328f65039mr18535592637.35.1779796010995;
        Tue, 26 May 2026 04:46:50 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852028fe99sm10304341a12.4.2026.05.26.04.46.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 May 2026 04:46:50 -0700 (PDT)
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
Subject: [PATCH v3 4/4] selftests/cgroup: Add tests for zswap proactive writeback
Date: Tue, 26 May 2026 19:46:01 +0800
Message-Id: <20260526114601.67041-5-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260526114601.67041-1-jiahao.kernel@gmail.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 45972180005
X-Rspamd-Server: rspam03
X-Stat-Signature: s3k9menfopx9ic1o7it86i8tzxbqrf8c
X-HE-Tag: 1779796012-307083
X-HE-Meta: U2FsdGVkX1+Io+UQrCfo4AvwOHebODG/Skodd6Uq17TDugKOB78xqqTSVGUH1Ogh+rEpvsAoYT70mV6zu5rYhArgzg+FlxeUzuWdODRlrv+Y0ySt0DB1URDJCqOUM0m/a+0DyfJ7YEGpG26t5ANMptZaQPYeyWXC9C4KaC6gDEYRS9aN6yszQUB/Uda+HykJi/NHDXFfhibI7w0ZX3gvL2+OpOTynup+s4/3kP9PCchlhcpPVuw/mjzxzpRiM6HKqccA65aRbE4Tv70VIC5hizt+DeeET40d4vRu+2Cp/o5XZddKYQIyWWiUQGXHYR+x7nxBnBdEwsiQmhMk7Jm6SJ1L7ZG18We26e/SBCumcwkIJo1mq9m+3rAYkgFtUsHSFmLC2ebUppx3GJ9WRLYxXWzGtSQDJO06RKTdfyF3I4BIq8qeZscQJE9S2xlvyQt8LCqekH1Hw0sQsYnpZrYfvri6ALSHEgxRQh1PpqMV2+8ioIppUC5atIulcKg8DkJTGwfQu6V+vp17AVdhUMkEk7hTZFPBhywWt53fWlk/E7TQZzGO0aVgSY0N386Rw9/tJ3wXV/e1qr72Y7nMvOPTk+BNy/jw0mkCniw5bWKeQ+36Z0eNMU4ZxWLQ0i1Rd06ropXQb+cYPPvOzhI9M3Is0F1T4IiO9arxPtn53XauVH179xwC6rZXblsF3OM6LBm/IH4AqGwT3psKA1xBV4dHTWDi2Uz4S5gm4e8e8ZykBiNUhZjnOl1aw+msxarxbh4sZKO1ypQULDi/PNscFIq21aS/bEfPxOrKjDEPxtC5hEmxsAJ+2Z/TmiB1H+yuF9C0+gIvz+Cn12Mp/BDqdIvJ54QaU1jsvm8yESLwXysJQwYi5bywGVp4iWG0Sfkf5Y0+LJlhhHlaC8/al9z+n+O9fTacMvOq9Nm+ZxN06SmHWO4ZH01Il3HclGD6QBrHZXT1qMpvuEub6vyQLIDqFrp
 qBLebMwn
 ZWPbFARmsmyMCXzg54qrmKDJcU3ezMhpTJwUSCSihCUSZrlz8f1/+zGaqRjhqwtOWXIck9dub8ZhTBxQYp2r5/GouOkbIMdSOSgUL/pZxbgyEWJqfXJUpczEfyAB7E+5U5ndUWW55CjqYZ88FSL1PCzCH8xGwA7cRmZYv2LP7M+emJgIpGA72wzr6T+Eg0LjLct+jciWot3i8OZMD2Yxy3NGegr2+zUJF60p0edKGt1QJY5q8ytL6FIzCSeAWpiDy7IYTk78PgxHpNOXaIWCEfkGk3knkWI+2gK7oAssWgbON+CE7ybbyk1UvYpn05AsJNDI2XILMxoSBmCDJHOod2a+W298rjRp7Ryxrv6zXe7+PMY/WyCiYzRrZO98xSW3RHPsRVukrC3P2sZ4CgZastIirV73kTbRvu2KUep9XgZArmiTVHWsXg8VaJEBgZowbiSJRzg2lc4Ps5QwuJ0Eo7sZV4EyaROxQUvpDzw96PF8CGRapn+o3FBm1FZ8S/lzEFBL1rtozeBntdj8cTX6+X9wXBzzxmQHNgKIhI8G+T30wQTszk2t3fuzp1rV4MFkL1PwF
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
 tools/testing/selftests/cgroup/test_zswap.c | 155 +++++++++++++++++++-
 1 file changed, 154 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee79160..6ab9394a37cc 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -60,7 +60,12 @@ static int get_zswap_stored_pages(size_t *value)
 
 static long get_cg_wb_count(const char *cg)
 {
-	return cg_read_key_long(cg, "memory.stat", "zswpwb");
+	return cg_read_key_long(cg, "memory.stat", "zswpwb ");
+}
+
+static long get_cg_pwb_count(const char *cg)
+{
+	return cg_read_key_long(cg, "memory.stat", "zswpwb_proactive ");
 }
 
 static long get_zswpout(const char *cgroup)
@@ -355,6 +360,7 @@ static int attempt_writeback(const char *cgroup, void *arg)
 static int test_zswap_writeback_one(const char *cgroup, bool wb)
 {
 	long zswpwb_before, zswpwb_after;
+	long pwb_cnt;
 
 	zswpwb_before = get_cg_wb_count(cgroup);
 	if (zswpwb_before != 0) {
@@ -362,6 +368,12 @@ static int test_zswap_writeback_one(const char *cgroup, bool wb)
 		return -1;
 	}
 
+	pwb_cnt = get_cg_pwb_count(cgroup);
+	if (pwb_cnt != 0) {
+		ksft_print_msg("zswpwb_proactive_before = %ld instead of 0\n", pwb_cnt);
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
+	 * zswpwb_proactive must stay at zero regardless of whether writeback
+	 * was enabled.
+	 */
+	pwb_cnt = get_cg_pwb_count(cgroup);
+	if (pwb_cnt != 0) {
+		ksft_print_msg("zswpwb_proactive_after is %ld, expected 0\n", pwb_cnt);
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -770,6 +793,135 @@ static int test_zswap_incompressible(const char *root)
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
+	size_t memsize = page_size * 1024;
+	char reclaim_cmd[64];
+	char buf[page_size];
+	long zswap_usage;
+	int ret = -1;
+	char *mem;
+
+	mem = (char *)malloc(memsize);
+	if (!mem)
+		return ret;
+
+	for (int i = 0; i < page_size; i++)
+		buf[i] = i < page_size / 2 ? (char)i : 0;
+	for (int i = 0; i < memsize; i += page_size)
+		memcpy(&mem[i], buf, page_size);
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
+	snprintf(reclaim_cmd, sizeof(reclaim_cmd), "%zu zswap_writeback_only", memsize);
+	int rc = cg_write(cgroup, "memory.reclaim", reclaim_cmd);
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
@@ -783,6 +935,7 @@ struct zswap_test {
 	T(test_no_kmem_bypass),
 	T(test_no_invasive_cgroup_shrink),
 	T(test_zswap_incompressible),
+	T(test_zswap_proactive_writeback),
 };
 #undef T
 
-- 
2.34.1



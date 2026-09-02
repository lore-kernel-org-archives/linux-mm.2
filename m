Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF72CC624DA
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20BE6B0088; Wed,  2 Sep 2026 15:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB3F6B0099; Wed,  2 Sep 2026 15:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1696B009B; Wed,  2 Sep 2026 15:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8BF6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:45:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF86E40382
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:45:24 +0000 (UTC)
X-FDA: 85169851368.10.C2A2D42
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 40B171C000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:45:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n9s1Sdzw;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788378323;
	b=6A/t6zKbWPpllCi07vAV30obLPwtn4Fpszcwx3Ib8OshoxTU1U2ez4oVqkvTpa6kqXNCIY
	NOUDZXmbJQd7oneKoCf2+grdP5MbC7op07oxbUgsJfDr2Tp/Eh69qpZBcYPVm87Isl39J3
	PVrGRiszOYNPYQCpcSDAsXii899rJH0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788378323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tGCfm32JlUmtMotIy6qoQBTUO4f6h2sqplyq+pgz4JI=;
	b=hnAg+kZN5IS9DK+aN2jjZ5bUnYlNGEypxmzJqXZmCkFVWBw+BsspLPdpbI/+2qZfL0eCXH
	tZL1YCfYn5U7L9EN6d3RhQ4rID/OP4xEoF5hASayNw2fQaTGyoyfAZYv5bdgrdwDRBB8fP
	Jh2Eh7bRFBS0tvlVk7qq1ovu9H/kucQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n9s1Sdzw;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7f4df360cc9so275753a34.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788378322; x=1788983122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tGCfm32JlUmtMotIy6qoQBTUO4f6h2sqplyq+pgz4JI=;
        b=n9s1SdzwUXk+ufUCVl1YiMGkyxZEO0FQ0+rcgfSIpr4Z0b9NCMjLTE0wKMNgft9cFt
         bDdcCdOOxAJbG/OqvB80EcsnrY0yW/OMr0KZAD2ehHfvOOPZhim16RydjlH20rgHw70o
         MmPeqaZXiV4Iu91PKBseDHPYi6LpTzDIgRY31gqNnbcfFBVE9Y8Je41xuPSptVfyMGUp
         TyuvgOoMIZft41qqiF0cvWL9hCyRELtmJpD49IPAjeWcTb1nvGYpG0msDgIgxyoztlsk
         cBapIoPIhJb+T3EeuP/6JdQk6HR9+9/1igNal3hgv6R1R6/KlDsxg1ytE7CQGt/1kT3q
         WxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788378322; x=1788983122;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tGCfm32JlUmtMotIy6qoQBTUO4f6h2sqplyq+pgz4JI=;
        b=DZQrhtADQhgLYTM0333Sirn806nu6AQYZ3lz05KceST9bNSJ6TI14b5Tj0yAgrM2rC
         IikXR2gzPC97rMTsZBh6oi8jGCdgayH39F9+FGZ/aSBoWXillcncdQ+/SxG1BV2YCHEC
         U+tCMXkflZiLcQZiaDDCNFBTOdlg+nBnvlbrRWEYEG1xJjlQIrV0YOCTYpaEeUfWOCuj
         ZoQwfrKCKHqsSWI7htjVlWPer4Our0yRNQbbo9sths7gUYRCqUxHWhrnbqTlkIgC6Wyg
         FikNBV2clpelNhairr95hkzhclkrI45aOQEGNnsEcPedc1hilXrw6+agcS3Z04zqaAeb
         Xwvw==
X-Forwarded-Encrypted: i=1; AHgh+Rq+L/tvesrkZM0yNZwnCg3KvGbgkaxFWawbUNWmsHvb26wJcLPJ9RZyc5UtR8kVkG/cZsxnNo284w==@kvack.org
X-Gm-Message-State: AFuF++mWoHE4+g1JS10nlz3g5LYYVsvLAEnFP2l7ginmcN/d4fVnRBHa
	ZSP/VpFwbIN+zfRzsaP2py4S6p/Z3Od6rWe7/FQSoazzKjCVtkPjZXmQ
X-Gm-Gg: AR+sD126t6qNm192ubBopJ45QeRDHTqIaK3eBYmWlZ9IZ6qA25Fv3SgUWmyreCaPtqF
	sNNLszj1BwBQFK5wQf+idJnkuPbHW4z3XrovZhCtKeYDGTxrOGnkC1Q43y2FpKHQqYc8M/hBPkm
	1k5sSXQjkjlKoH1Pm20s/QQnZK64R4ek65K/7ENokJuaFhVjuf95rIxkUynA6JPTFxeJVc0vj7t
	tOkYOtMrVWVxJzBWvlG/xFY+awWyGrSqooeSeWv3iu/hu1vqeKcGqQY9Thi83vAnZH4h4KAr/6M
	str3csrbf9ROobAvHysatMKIyBxyGK6GxzjIQdJVcKY27+H5C+5COgh2uWBigl7F1BL6FbJ+txr
	nk630Z6VPOifYQQ2brSqm/AnWwf8gjZtSSbWI8eshGHGBquaOBkV86A1uQD98KOo/BGCvsTVnv7
	PYQusCWOTWIg2dKw6u4i5yIFj1i+QM8Jeua+SfflSQBs9wEUUtJbs0fcCqSC1QwCOXRghbiYA4i
	mEJ2D7pzzXcna9ibdc=
X-Received: by 2002:a05:6830:488f:b0:7f4:3902:3a26 with SMTP id 46e09a7af769-7f899b8d376mr1482293a34.1.1788378322092;
        Wed, 02 Sep 2026 12:45:22 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:17::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f74f9ec644sm2999492a34.24.2026.09.02.12.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:45:21 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Krush Chavan <krushchavan@outlook.com>,
	"Chengming Zhou" <chengming.zhou@linux.dev>,
	"Tejun Heo" <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	"Shuah Khan" <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] selftests/cgroup: account for zswap shrinker writeback
Date: Wed,  2 Sep 2026 12:45:20 -0700
Message-ID: <20260902194521.3652178-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 40B171C000A
X-Stat-Signature: n7x11eh7b8t5u7aj7hjb1zndsfm6cifx
X-HE-Tag: 1788378323-255506
X-HE-Meta: U2FsdGVkX18PW7Zu5F36ehsC4vp3PAHhM80J6jOS3L8xwjDR92haS0+Ke2cGqKVT2kzBroIb+MNudfSRVaBq7HswHFQtuOodPeVr113h/OTc7+YQt35bCSw1jUhwO+r0JlRY48+siX5FklcIX181MzCKua2RWXx9aFND65bLGsHgBrpVhcreUjGYActjRPxAiO4hNrubnIfbps7Q6a49PPJQDQKkWGIkLmPtqZPrjzFaWWrdz8u7/8eqiheGD3Xw7vAIatsjh9+KgJZT/YesSlRNhT1uHwB/xpIY5lXGsFueb7quPY39UnX7+pLYp/qc7NZrgy82AJ2N8RYtznYhDVTs5w2lRTa64IFgkAprtwL/q1TU50iXLijLBJEvoZHTV9z9Kd1U4M5ERlRbnka7xssVmJ1bUW+0rCK5ah0R6vzVl42GVj5Pxw93tblxC/6SwypwNUqAElGM8wcmARCwO9ltZ8fAE1az3Pg296cVDvnU4Y+bK+8vkSmTyc4BJ5w5TTYf2bZF//O621un5+IcO9i143mN//JxEuzJx35jVxrfv/JacsXo2vIZ4pfoGrmcob1wSDtoOPodeEYAKckYXH+1YqWww4kavIjDadiGSmrBvfr3K41J5B8wHZyrY3zuH6xz7FbM4H04qxA6nVcELE5QSLOEuKtuHjpQQxoD9aUbkpBHx8tOJ6sQ6ZQVlClG/qnVi7Qf67syHqInsZiHa2/tT16oSJFo1qzVCtEj8fRfrGaJOhBGHWSfqbgFg5ZeTP3EA+jjxMJwWuZJr6Qnd0nzIfzXaD1GUiFPvYPPvfslTco3EvNcgm3GcYHikWx6UW6/l6q2GgQnXnIQnayo9dP0eVL8pipumV7oS5dpZlV0ZdKMm/CoI3h2ViXt3b2zkeRLRf9sOy/8cy7jgaTZJg6PuJGQnmbhD63xR9uNeXqAFlre+T5qGl61WrLmeMIoplKvHdXiDJG5J/EQd/Z
 UtXlmax8
 1/6nIotrbILtyz/oNg7rY4iEj+wKpxnEXurkVOiO16J3Wm9Axh8lcRy/Cj38tdcm0gU3vZwjZVWYGUUBZDHQY6oi2n8W9vX2ojXkF+K7T+HGnuiwpbpLl7dDi8c1FdRUSdHfmRsg6JlbqhXfjk62n2zJ3HpMAaRdW52bKn74PdpuwbRII2Cik0cqrkve52Xwb99IEqQnm/6dyQDz4TN4AcKIS0ggbaaa2GGqVLl87kXp9+y3xZ0hFABYXfFfzUDbTPIQMVvRvalUY0pauEE6QhZxKxTqZ/MAI4IlHjOzTVdLtgF+KeB7+ZnuN8XJ+Z9sCzuP7eY5q/SgkW4pXLMf4GWXhMTG1m3PN5e/HhuCwqsMqPLbQth1uLlsa4YxtTK+awmLb4EakcGW+QtK7mTjZi0jommbA8DuNxqWT6TamPfeZH0i9irqaemxB1LMszC/ordj5a3kfaRj+a3lgOWwoik3hl/FUBVHDTaptGrwCPWBqluunSt+eY4dRxD1zVELMvqPUZL1CAG8uzKYE0Kun56N4dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test_no_invasive_cgroup_shrink selftest checks that when a cgroup
has zswapped out more memory than memory.zswap.max, it does not
trigger writeback for other cgroups. To do this, it compares the
writeback count in a control cgroup and makes sure that it is 0,
and then checks the writeback count in an aggressor cgroup who does
expect to see writeback.

However, when the zswap shrinker is enabled, the victim cgroup can see
legitimate writebacks not triggered by the aggressor. In some Meta CI
tests, we have seen this failure mode happen.

Instead of checking that the victim cgroup has 0 writeback, compare the
writeback values before and after the aggressor runs and check that
the victim cgroup did not perform any additional writeback. Note that
this can still lead to probabilistic failures if writebacks take longer
than 5 seconds, but this should fix the systematic failure case.

Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Reported-by: Krush Chavan <krushchavan@outlook.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2:
- Instead of skipping the test when the zswap shrinker is enabled,
  compare the victim's writeback counts before and after the aggressor
  runs, as Nhat suggested.

 tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 9c5bd503c3f73..1ac7790727757 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -20,6 +20,7 @@ static int page_size;
 
 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+#define PATH_ZSWAP_SHRINKER_ENABLED "/sys/module/zswap/parameters/shrinker_enabled"
 #define PATH_ZSWAP_STORED_PAGES "/sys/kernel/debug/zswap/stored_pages"
 
 static int read_int(const char *path, size_t *value)
@@ -446,6 +447,16 @@ static int test_zswap_writeback_disabled(const char *root)
 	return test_zswap_writeback(root, false);
 }
 
+static bool zswap_shrinker_enabled(void)
+{
+	char value[2];
+
+	if (read_text(PATH_ZSWAP_SHRINKER_ENABLED, value, sizeof(value)) <= 0)
+		return 0;
+
+	return value[0] == 'Y';
+}
+
 /*
  * When trying to store a memcg page in zswap, if the memcg hits its memory
  * limit in zswap, writeback should affect only the zswapped pages of that
@@ -455,6 +466,7 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 {
 	int ret = KSFT_FAIL;
 	unsigned int off;
+	long zswpwb_before, zswpwb_after, zswpwb_target;
 	size_t allocation_size = page_size * 1024;
 	unsigned int nr_pages = allocation_size / page_size;
 	char zswap_max_buf[32], mem_max_buf[32];
@@ -490,6 +502,14 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	if (cg_read_key_long(zw_group, "memory.stat", "zswapped") < 1)
 		goto out;
 
+	/* If the shrinker is enabled, try to let the writebacks finish first */
+	if (zswap_shrinker_enabled())
+		sleep(5);
+
+	zswpwb_before = get_cg_wb_count(zw_group);
+	if (zswpwb_before < 0)
+		goto out;
+
 	/* Push wb_group memory into zswap with hard-to-compress data to trigger wb */
 	if (cg_enter_current(wb_group))
 		goto out;
@@ -502,9 +522,13 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 		getrandom(&wb_allocation[off], page_size/4, 0);
 	}
 
-	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (wait_for_writeback(wb_group, 5000) > 0 && get_cg_wb_count(zw_group) == 0)
+	/* Verify that only zswapped memory from wb_group has been written back */
+	zswpwb_target = wait_for_writeback(wb_group, 5000);
+	zswpwb_after = get_cg_wb_count(zw_group);
+
+	if (zswpwb_target > 0 && zswpwb_before == zswpwb_after)
 		ret = KSFT_PASS;
+
 out:
 	cg_enter_current(root);
 	if (zw_group) {
-- 
2.53.0-Meta



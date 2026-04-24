Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C08DFAD3F3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28DD6B009F; Fri, 24 Apr 2026 00:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9096B00A1; Fri, 24 Apr 2026 00:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF806B00A2; Fri, 24 Apr 2026 00:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDBF06B009F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:03:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 819A11B8FD8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:03:01 +0000 (UTC)
X-FDA: 84692103762.28.925936B
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9E09980014
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:02:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u2UUUdOL;
	spf=pass (imf02.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcJ71eB0Ct26LCodBxWEDWyUKWisA2ZlGgHlF6yt2M8=;
	b=GJz4m6FgmCZI4ZT9VJaKSVMkwLB1o8f5dn0ttc91c7+A9dzx8Hwnrr5wEixFuE0aTZM+xP
	wDpQTdxJD/lp3XUvx1Pt+eWNcve+LUU7MnRTA3lHbt57pDMXcpOM1G4B0fcZvqqVWMjVoa
	3l61JRiwJOrphULlQkvaCsIwko86pL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003379; a=rsa-sha256;
	cv=none;
	b=pYt7auMB7Rjwk2wmddUXO4Uy0aKEgD7R8hzjVveLcYW6TmXyypkTjCYEWbP/wYiOfmNRiG
	CNbq2aW3r6tFgVoUcjwJgu3HVHtPNdN10XjPYlvo25bmnE4Ny/TOkMP7BDBVqbpkMOM3c0
	97tmFuDg9eEwlQ38eg6pwAIDq7czQBA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u2UUUdOL;
	spf=pass (imf02.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VcJ71eB0Ct26LCodBxWEDWyUKWisA2ZlGgHlF6yt2M8=;
	b=u2UUUdOLq/sTdbKir0hjZ104Y8LIJpS74cn7qDT1LzGQvC8x59z4JKTAYYFv+Mi2wy77jP
	0erlRvbTWrp6xVDva3XA8Q9mWdOuWMDPKHx9XMzdrSkIVihGcR7+omGvoVjKtNcjcQJGTn
	HOhQ3z3hpFynAlwnZwurAZ3K3oZ/krY=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	longman@redhat.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	jiayuan.chen@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v7 8/8] selftests/cgroup: test_zswap: wait for asynchronous writeback
Date: Fri, 24 Apr 2026 12:00:59 +0800
Message-ID: <20260424040059.12940-9-li.wang@linux.dev>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9i8b4q34n6tdr1dtqkzao8e7hz9cnxpe
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E09980014
X-Rspamd-Server: rspam05
X-HE-Tag: 1777003379-791100
X-HE-Meta: U2FsdGVkX18EXJZmb1iEh9LuAxNsWRD8L8rHPgXeirsjqBGW9BF0d8TpUAeFFLXPSo1bx1mjfjGIQVMQaTzsMEhkUk3xIWEnx6MtoSxQ8rOgDQjuTlQEWEA/iJxX5LVD7y2ZBKDki74jtmA+hVqZF+EweZ+YXvrSm1CCerWi20fpItla7Z8C0N4vMZe9U2qob251Z76HMGo5BT7THmOj3TEkhpea/KfeLzeRElMts7CheBcf1EVyRG/6z4A/DlSJ110pO6/nT0elMagEVLaXu+p32OUO9evvjcxILSomXayfLBrwhGALRTWfUJ41+l+uD+q5KuuVSKMqXl3MNXY1ujzNuEMYvLLA6lDyvuNsTmnYi6I5y2aB0wfjJSIORln2ULwmBbOoqljXaD8Dh5voK8WFxmOIo0i1+I6CAU0rJPWwPqTHdjc5N2wc8OqxQ34vC1jpvTNOujClrnv2Tbtz61QFyrWzLf9x9b0ASREv85WXqVxR9F4wD+0u1jDtAr2tJz79Es/n4KOQ1YY2pdhF9KN2K83iDBdvWYQbtGQee8JlHIxWfianA4SrH8OHtytP2rlNdfN9Q2IELPC8832OIpUpuMooLeKvI8DRfHLJ4QjOp/YEJ45b+3yr4KmSKryVCi90C0Th7TjcJmu01T2303yX1sBdAGCSR7ubwRxQ3DCofnG9DwLlqL8/rTqu0PGh5KgC8EvetiMboZ4SLchGYZBM0qXJLE2+J5wSP/PixKFfIoIV7UsHpsxSVMJH4QZMyAXA8KwxKKc2SbHHFB3LlNWKyJusXt/u4+BAbLAB500ornRFKtFqPfeOjlg2x1kv/DWCLFCm+21Sd0FeaefCDUrx9YRGVpiMMQFD53nz0pF2oRMODAOmU2lQ4VsR0waqjKVyPeYkDq+zbubcYQ1snyJAJwBjMuldfcv8bY2YV9Ny4+3lvjcnMu0wwoZw2A/C1UmBWwKqCN+DKGqcC3I
 WUZTilBI
 yQCyAqJ9ucaw5PXaB4C7pjzQ90/DwsCq7alrzcCKBmCJ1GGGsm9H4kMrGEAMLo0CHyEfgEtoh/evQ1/0E6YTdFVDk4yJdX3/EYmWqD6V7ZHmE7QYy71fDGIcppv0C6HH9jzXYzraYFEcskpvN23epBl73GkLL/lV45tVhGchJOHwT/1BttLqbjH6Lfo/+ZR0vkqYLWZW1bNi5OZiB9XXJ9qhjLryBzXqaL0oo4WMqbrpwaP2zDyNKFWypdgwG0l2vQzYy8CX5I9Eebo+Y0zpcvJczcswp5Cmvsq33ff+aXq0tBbUlLGGCQ8bdKxoednZPQjVlZ2FR0e2BcSl0YVfAUom/H5RjG4APbxM4XRUX6JTZarUoGqmXDeeFqsvCOx1aw4hRK11N/qNBPXHq8VNuOBvrik7PiPmqEx65KadRa4OvVusqqjaqXg0n9JqdjUP+Wh24MyNTqwu43/JKanHjDKISiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback is asynchronous, but test_zswap.c checks writeback
counters immediately after reclaim/trigger paths. On some platforms
(e.g. ppc64le), this can race with background writeback and cause
spurious failures even when behavior is correct.

Add wait_for_writeback() to poll get_cg_wb_count() with a bounded
timeout, and use it in:

  test_zswap_writeback_one() when writeback is expected
  test_no_invasive_cgroup_shrink() for the wb_group check

This keeps the original before/after assertion style while making the
tests robust against writeback completion latency.

No test behavior change, selftest stability improvement only.

Signed-off-by: Li Wang <li.wang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 5fe0cffb557..49b36ee7916 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -120,6 +120,27 @@ static char *setup_test_group_1M(const char *root, const char *name)
 	return NULL;
 }
 
+/*
+ * Writeback is asynchronous; poll until at least one writeback has
+ * been recorded for @cg, or until @timeout_ms has elapsed.
+ */
+static long wait_for_writeback(const char *cg, int timeout_ms)
+{
+	long elapsed, count;
+	for (elapsed = 0; elapsed < timeout_ms; elapsed += 100) {
+		count = get_cg_wb_count(cg);
+
+		if (count < 0)
+			return -1;
+		if (count > 0)
+			return count;
+
+		usleep(100000);
+	}
+
+	return 0;
+}
+
 /*
  * Sanity test to check that pages are written into zswap.
  */
@@ -345,7 +366,10 @@ static int test_zswap_writeback_one(const char *cgroup, bool wb)
 		return -1;
 
 	/* Verify that zswap writeback occurred only if writeback was enabled */
-	zswpwb_after = get_cg_wb_count(cgroup);
+	if (wb)
+		zswpwb_after = wait_for_writeback(cgroup, 5000);
+	else
+		zswpwb_after = get_cg_wb_count(cgroup);
 	if (zswpwb_after < 0)
 		return -1;
 
@@ -476,7 +500,7 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	}
 
 	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(zw_group) == 0)
+	if (wait_for_writeback(wb_group, 5000) > 0 && get_cg_wb_count(zw_group) == 0)
 		ret = KSFT_PASS;
 out:
 	cg_enter_current(root);
-- 
2.53.0



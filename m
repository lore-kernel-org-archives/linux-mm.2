Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37E92FED2C4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B19A6B0088; Thu, 12 Mar 2026 00:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682606B0089; Thu, 12 Mar 2026 00:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BBE86B008A; Thu, 12 Mar 2026 00:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48BD96B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:06:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C383E1B889A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:06:48 +0000 (UTC)
X-FDA: 84536074896.28.4D5301A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0E0BC0002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:06:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WANJWUUk;
	spf=pass (imf28.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773288407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UQeckx+5U+uTndqi/lDzELfEhZ+lHpEnmQokNC1yUIw=;
	b=nviiwqJoXyu7n2EgdQiLxUTjFKIRS4TabP9tdbLZctKdPQlqaphrZeFrgGNmgsSrnnAB+M
	ANnyQe0aZHJz8evo8ygx5EVBOtLsmpXPfSMMEhSdx6r6HXzLdSMci/9VMWrhGKmr26QI57
	spYbxhw/DBLtgOuQm4NyxA/waXmCCZ4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WANJWUUk;
	spf=pass (imf28.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773288407; a=rsa-sha256;
	cv=none;
	b=xBqzIrkAC9lUJq7tAGqn/D7i4NY5YAl7bN8rmaPMvnu17+Qp58Vc4mqLFkVhiabfZbJRJv
	QZLcoDg7OHCxmvmd5faY5T8L5Fi40jElFRQ8ErCbBg8ftmdaAeyzQxDtim+6AVqBV3OuRk
	IdkYb7lZfdHq5NjPTKLOw1v8ySqs2/E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773288406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UQeckx+5U+uTndqi/lDzELfEhZ+lHpEnmQokNC1yUIw=;
	b=WANJWUUk7+q8nZEHqpLX4NdFV4ciLwuD8B/ofL9on21m5M+DRAqARSwJrrjkZJcNvTqEFt
	OsKyPJpSjZ/VugvAh0SkNfm3SJEHeg2ba6wyp7zzNm5tkjYC8kyakWrohUZ2kECKDrxu7C
	J3nhBq/0j9aafE67z8jayJTazBgCEMU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-60-cUvabXB_PziHMOXoc7NHzQ-1; Thu,
 12 Mar 2026 00:06:40 -0400
X-MC-Unique: cUvabXB_PziHMOXoc7NHzQ-1
X-Mimecast-MFC-AGG-ID: cUvabXB_PziHMOXoc7NHzQ_1773288398
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AC56A1956095;
	Thu, 12 Mar 2026 04:06:37 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91F5D19560B7;
	Thu, 12 Mar 2026 04:06:31 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: mkoutny@suse.com,
	yosryahmed@google.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v2 1/7] selftests/cgroup: skip test_zswap if zswap is globally disabled
Date: Thu, 12 Mar 2026 12:06:21 +0800
Message-ID: <20260312040627.55257-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: smOxdAHci9F9l3WC0uNt33fw6012g5Z7ZSX-cTGsXKI_1773288398
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: thgr4f3yr7nfw8rkanne9p4zah4wq1nn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D0E0BC0002
X-HE-Tag: 1773288406-916390
X-HE-Meta: U2FsdGVkX1/actDFk6lmVqiQxFCAlbiSwYI8guonr6f+6WvosCRXuVx3Uj90h17ICMSXu2Qri8aaBciM5ZnPIu5/l5lwOiSTXJ+CXcMXAQq+a1yv/jwJhjpVLmSKiCcQENtV3AUuPI4yB8M1Wul4aqyEtCoOUnOyzGUSzEYOyl98eIplMT7mlvs7DE2EN8BQdr/HqMlDhwvj5nY5WKFRjqc3DSyP2c2WgvqcNTZjSXz+8FgJ7CBetVHsOnEjYR4MNKbhS0s90cHvcsFQ2DfOKKo2qTRlp8LtxoeAiKPYlS3NBauTPOf6ne2/vkSRzByiZHdKP67JOvcHEwndl+9OSk3mdSfi71Kh7bnSd4kjxg+i5CToejD4TsZXOm7Dr5Y9uCR+/oIUllthOt7ilQfc51w9/o03DCffPfiHZE5q6Ta5PoY3yFAcOUO38TgDU3ZsrOenhBKqysEzZT/WuAm6JQW79tXnHkJSgtRNCMyEoNtqzejVyQ9bIvNRzWXvTH/tD1zaav23C5QFBa4LE6fRDQN0yv6mmbW7Fw3H/OoA48bPhaTtNvRZY/NZvSeNDBvpNshvgC5L/grpeL21bh5SY6WDRP3Xy7Yvidh2VllC74KWJYMj2hD8+oUW+xOunuGX7IMnZ/KoxaVFsW773vaKJ3KvBBqETvd4+AMe2d+ehtkS7j/byDjtoW6PgFEcUJsYCHci5Xw+qAGIoIBw96sVubo0E9rwFuinPYWeSEZxi9bOPXvpFoFdf3CO+Nxz+KFLM0Vhmk9I7EnU/dq4ox0jx813mjxxo/sBl8xSLVQxpNRpT/LOG8m3ctEJM9gVJMY59weMm/DE0J5VcT3trlnVtTYbQL0iGF4RpwFI41uIj5o/fZecbV8ELLxMQLhC6BnDeLDlxrXJpz9P7rMelMl7dDdJzAMGskpRf2Po4L9Ig9mDOEhXbS+tOWJmWEqef22CYRtAI1vnYQVwa9JAUVc
 Mh0vtZAI
 6dcRHcB8waF2vG0IlmR2eXyNMZiI/V0ERCW5+l6yEgViDPtYh54+8lDW+eZph461bV2PaUPyYcIHSWv7p7V0ur7RNZKxv6NoTMwwJYjO0XA6xoTZA4qNzjzBHvWHkm6I5RGEgX08KG4ZRuDLYISrRVIAH93ZPGvK2TBT/+6tlSTncbl1JlydDyLx1YFyGKVgFJC3gFjoKtU2gq56LZJAwx/nfn2yk/nC3i9ismPNrtj6+Y/IL0gorpzTSh66uFLxPanTjib4eqfTkPRvaS4M3Dk9QzP8oRMhU78EVDPA9mFeW8hYHze0wu2Swr8Cf4oBqEnFYgFMvGWzvJtJvJqX/9wgQgqVyxuLkHlq/Z1/o3Aoy3qsQGOtFjXDU0WM/RJSJCqluOzDsqim3LrUOu58xQnCHCZsygso8VIR0/+Tb+U95stj4ztiScSsUsfX25m0Uv8UypawuJpiFMrR/NE8jT36HHpvgaYtbqD8ratsF5lUjRzwqFJUT+BA2M1Y9gn4L24cyJBCrxLFYUUvD4zz40NNYwjOAo5ZCxCy8S6Tu7PLlDbpjoU/J219faIm2j9OkildhTpZEz6v7ub5mRR7pVl1cm3yHoS/ENPic
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, test_zswap only checks for the presence of zswap via
/sys/module/zswap, but it does not account for the global runtime
state in /sys/module/zswap/parameters/enabled.

If zswap is configured in the kernel but globally disabled at runtime,
the zswap cgroup tests will run in an invalid environment and fail
spuriously.

Fix this by reading the 'enabled' parameter and gracefully skipping
the test when zswap is disabled. A helpful hint is also added to the
skip message to show users how to enable it.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
---

Notes:
    v1 --> v2:
        * remove enable/disable_zswap functions
        * skip the test if zswap is not enabled
        * reporting fail when zswap_enabled return -1

 tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 64ebc3f3f203..ec64daaa2f5a 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -589,23 +589,41 @@ struct zswap_test {
 };
 #undef T
 
-static bool zswap_configured(void)
+static int zswap_enabled(void)
 {
-	return access("/sys/module/zswap", F_OK) == 0;
+	char buf[16];
+	ssize_t n;
+
+	if (access("/sys/module/zswap", F_OK))
+		ksft_exit_skip("zswap isn't configured\n");
+
+	n = read_text("/sys/module/zswap/parameters/enabled", buf, sizeof(buf));
+	if (n <= 0)
+		return -1;
+
+	if (buf[0] == 'Y')
+		return 1;
+	else if (buf[0] == 'N')
+		return 0;
+
+	return -1;
 }
 
 int main(int argc, char **argv)
 {
 	char root[PATH_MAX];
-	int i;
+	int i, state;
 
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
-	if (!zswap_configured())
-		ksft_exit_skip("zswap isn't configured\n");
+	state = zswap_enabled();
+	if (state == 0)
+		ksft_exit_skip("zswap is disabled (hint: echo 1 > /sys/module/zswap/parameters/enabled)\n");
+	else if (state < 0)
+		ksft_exit_fail_msg("Failed to read zswap state\n");
 
 	/*
 	 * Check that memory controller is available:
-- 
2.53.0



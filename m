Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD6A8109E546
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56CC76B00A2; Wed, 25 Mar 2026 23:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544DD6B00A3; Wed, 25 Mar 2026 23:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481FA6B00A4; Wed, 25 Mar 2026 23:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 382076B00A2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:28:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6B50BCAC5
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:28:13 +0000 (UTC)
X-FDA: 84586780866.09.1AAB3EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0BAEB100011
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:28:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SKmSXBNa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7qTVQy4P3P+tWAwnSkI8eaROMeV/uij3L4ybuXlnco=;
	b=4wKpIRruBy6Ry6ipT5Eit4Oe+TG34I74ekUkxocXydbv3Nq+0NzIttscsKnYnG86b3O9aG
	g0WxRqx7z+xLRQIkVQerlmFtpCZbPG1N0SkC6AaO5si6l7HORtzQg+6qsxCwcmn03rc1qZ
	GImPgKo/uE3867zIfu5SudWKoyqfYGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495692; a=rsa-sha256;
	cv=none;
	b=LU72+RgWnejYMaQiH5XczbMB5qqGk7spKF50MKbvvfToL2QCDUp0XoMonLTvnGeF47SHpy
	E9saMw+HusDXgU7bBhKyiU88jXJsecAE2MFjsxAiU8C9s/LzrCJ4rG0p94Rsqgg59Bl7/s
	5/6aGWubFecgjWMb1QoZuF8gHPgetHo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SKmSXBNa;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774495691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z7qTVQy4P3P+tWAwnSkI8eaROMeV/uij3L4ybuXlnco=;
	b=SKmSXBNa5/DkiCkXywq3PEUE2tzKxsHPgWw9lZ0n49eX0g1ynCXwc4QNNA1O5DGPlKrkfm
	88mg5vrGcrny1RRpz9+GM0+DDD+C87F3maj3vFdgE9zIBSQqErtEYEZdjJLxhxytLzSDIr
	vPdAfKspCbZCMtzLU44LNx2Py6w9Dsc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-390-g6BzXI2gPqOlcblx0mevOA-1; Wed,
 25 Mar 2026 23:28:08 -0400
X-MC-Unique: g6BzXI2gPqOlcblx0mevOA-1
X-Mimecast-MFC-AGG-ID: g6BzXI2gPqOlcblx0mevOA_1774495685
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8BD819560A7;
	Thu, 26 Mar 2026 03:28:05 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C0731955D84;
	Thu, 26 Mar 2026 03:27:59 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v5 8/8] selftests/cgroup: test_zswap: wait for asynchronous writeback
Date: Thu, 26 Mar 2026 11:26:58 +0800
Message-ID: <20260326032658.96819-9-liwang@redhat.com>
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: xIE6gX7xlSfP3_epMpEwpKQfQczyMY92zlcxPp1fn0c_1774495685
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0BAEB100011
X-Stat-Signature: 1hgk5uc5cjhcys4x4qu7ie4qqbupc9qe
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774495691-360344
X-HE-Meta: U2FsdGVkX18BerEzVq6hdmlhGCSQECYxsq1DyQ3vwcZWZlGGS1O7QKGaPJsonNOb8n/DshzcTm4bBOgNTP0xXb+pALMNuiaovF2J3J2gd8BZvjWyPlb6lTy+vZ2l0ZFM4tprFeMqRXblCd+Xs8jVL/EixI650scqHkmpUCfvsNWIwAZ7BceZ5pd6pNuBA1uOGvKypUhaMT4PYk431QUnl9Zs3L3ChZ4I7CxsOKIAa2NIt2FqwjqLVV9tk0am16mRXDvsdekWNNOpjdbEJMWFSUvr259htjYjXq8qZEC4Sb+YGH3+yI/Uo/bQmsUY4ohua2MqwOFRhTmR2QwiJnnJ41EXVb3S428l91QPib8pykZtQHOzg53ZbHcvWS6ZxiTy9YcEm3PcVo4FId5Kpk0lH6fuqP4W8aVetIBSQz9MGbqhdnGiFtjowKUGM1BH0GDx6uOMgSMvRSTNawoo/TVC99gc2trgvyZ/JP8N1u9wkW5GZPUYnIh37N2eVZ+6x9hlqK4eGd5z6r/qhczpfVMVNizwEk1i1p8XHz/mU0Eqb0ENSepyjud+QgFpOcN+2UQAOguOGGdTLIsyCBuc/oGU05V2r28K68NPYqDRuxSpaWurYSSjwhPkCXKmhQQcQ5jh/TdMVDhDCueD4pSKLqvTNAN//WWPRnw48bD+17e8cjFSXInst7a94nSN6zVBqRKXYmfjSwawDnMpvh8JJ9Og7F5OYj/zv83iV53cZJXByEVzJDqCyPA2q+dPAu5K8ry5t01qv2WacWqn0YWtYf0WP0Pv3QBwoOnC3wVd46X3yNf6rLU3KmBDYoEgIARthbu7yS1Vlx+yzYSZfzR8nmICyKIAYoouGMxn3JTxLo/9486+RJBaVQY8zwx5erce/BZeRivLSvQNOePtw5NI9pX6lpoOlFtGgCzBrfVWvdlF0fx0SOkjesDYrELkeDGghZChPxK1JlvOqSRZGId4CYL
 g7Zb5vvC
 S83zyfjJtEpu6Jmy/ACgfdKwuCpT2+qVVMKcKiTOuh3Xdxn5NqThn5GEC6jILNUQu/L3KtUta5vwpsse5e4hkHSDUs82M1jpn/TseVZegRP6FOlzQTER1BeVR4dwjnawUPR4SlMWeTzTEFCcu3qM7vMQswVSEdpqC5Pf6iWTVoDWRQeUa5Lhl4KSDqTsUN2hYUehnTWtlgdAn6OTjMKFKNCckiPGeuidsmv15EVM1DzgAB3r7MQ0p6FO2HEp2mgVxayeBo04I6Na2VXSHMpYgOU5ah/+RiXDgIfZsopoHczMLwRYfbzEz0X38F0sRzLLM0Rk5/+sAn+Xj/0lTrndhUMg/+fVJW/LHFra03QxzDfVnMV9SjJA4/4TZsdKY5pqpzYEZpp4ymMJHYyqINzmPQHex7OhIt96382kXNeV1p+IVuCRmOpBI+216JS6G0TNs0NxtxaevkJ5EBJBMO6zKKpO5/ks++LV0WpxdJiRnWXxyxgjia7+0lH0DTQ4RcE5Ay1PE56SSaC7FEFIKnsQKC1W+pq2R/si6Xf0mus5QZJEH9cMPWAZIQSZQewQSiJSjG0rkq91ALWSFqp/29QF121DdBTu/AJb1AV5s
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
 tools/testing/selftests/cgroup/test_zswap.c | 28 +++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index e96e316f7c47..e7d5dbc1ef7f 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -118,6 +118,27 @@ static char *setup_test_group_1M(const char *root, const char *name)
 	return NULL;
 }
 
+/*
+ * Writeback is asynchronous; poll until at least one writeback has
+ * been recorded for @cg, or until @timeout_ms has elapsed.
+ */
+static long wait_for_writeback(const char *cg, int timeout_ms)
+{
+	int elapsed, count;
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
@@ -343,7 +364,10 @@ static int test_zswap_writeback_one(const char *cgroup, bool wb)
 		return -1;
 
 	/* Verify that zswap writeback occurred only if writeback was enabled */
-	zswpwb_after = get_cg_wb_count(cgroup);
+	if (wb)
+		zswpwb_after = wait_for_writeback(cgroup, 5000);
+	else
+		zswpwb_after = get_cg_wb_count(cgroup);
 	if (zswpwb_after < 0)
 		return -1;
 
@@ -473,7 +497,7 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	}
 
 	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(zw_group) == 0)
+	if (wait_for_writeback(wb_group, 5000) > 0 && get_cg_wb_count(zw_group) == 0)
 		ret = KSFT_PASS;
 out:
 	cg_enter_current(root);
-- 
2.53.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9835AC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D406B0111; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526286B010F; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414CF6B0115; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 018C66B0113
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76EBF1C0DD9
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:46 +0000 (UTC)
X-FDA: 85042093332.28.419D25D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB5BA180006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcr4TtLE;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336464;
	b=gjI803oxVXd2W4NiyU9ibXOtY+c2Z85717mHl+BwdKKJj4BqWGd2LNDFWCOAetWEUtsEIt
	KFDKyDkxV7R8tcm1YGvC5vpAegTO81SzQJXe489QSk5nIJPlj4xZFIxdiFrY4e7YZ15Mmz
	XabL0dYbkb4a78xOQRKXiKHFGRIlbdk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcr4TtLE;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMEdbVHoJrZwuzmNn8i5Bad/INZcQ1/1hylklN9wYVo=;
	b=4c/TwOquF7czFFzMP8dWJNsX8fUrTzPSPcxY6NgKeMUdBOBjsQLPwEdiMoJrD227hV+u4x
	tXjZQN+iPHe7OufDd1EIPW26iwVB7R0vhLAzeo55EGxx+Wk4/47c7i2Up2us08CnxsMDaC
	7396K++cuzqI32JRyQWZAMGgljLqAzw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AB89600AF;
	Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE531F000E9;
	Wed, 29 Jul 2026 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336463;
	bh=PMEdbVHoJrZwuzmNn8i5Bad/INZcQ1/1hylklN9wYVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mcr4TtLEwYI08+sEBA7Qj3ucQ/+RqsPgHruJ9i70JRLeUkhdzwRrlVfl4g+zu5SaQ
	 XY6qtQsbSvBXJUsy2KE3ezjV7jK/9Z3qtPVxaqVmX+pSbb9Sse3l3BwuPAxcuHOGZB
	 o2j7RF0TTeGnBEHBk3jm/jA1sqthS+PPxDf4BHoiGavgwVcIZ/aDJrIGtJmRxsZnLN
	 NUdJgRCt8nFB2Bk/yplzP7TjG8oO5bOvQaFc4IqaBcZu5o6kCUFB7BgkzLrHp8HNar
	 3VgRKsnrdqPpA/LJy7I0TGMX227cEkXpdq9LdynEUHpL95TE+wENo3K4xTSOgdy9v9
	 4G5HxGwFm2pMQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/6] mm/damon/tests/core-kunit: add damon_commit_probes() test
Date: Wed, 29 Jul 2026 07:47:33 -0700
Message-ID: <20260729144738.90895-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729144738.90895-1-sj@kernel.org>
References: <20260729144738.90895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB5BA180006
X-Stat-Signature: i6dx9n9gqehn3xb6cadj7t4hewcxk9o7
X-Rspam-User: 
X-HE-Tag: 1785336464-123210
X-HE-Meta: U2FsdGVkX18nU9ok59ZH+iiLQzcw2BeKSTnzCGpms/YgSSXqd4beOAtAWVlyZnsreotJEeJS+Tgyu8CbLA7hYHk5oLjTYEc5CPnBoxOsjRgZdiCWRcu0ilHQ5J2lytPcpZiOAcund+Rp/bfSBtk8CfBVe474XPiz/ft0OFi27hvj6yzvTc0Owq3r29zG8sunwv3CuddHN4pzzYuQShJo3+69ayRGotueHG3lUAK2+I63sw6yaLbPIm735M44E/Xhje5sMiE+8lD6cV2cZtxQy7k1q6Pa6vSU4XutQ47v1l0WECYtXoTQsHM2tP4lb3UESQIMnr1KCeoprzTHFHoTktdz44N33VRV7tEc7kURjrtY80yiSY8h864cjeoxIba/xyXfGEwTC3umS6aviZ5yDtFBuCZ6oAl3w3uDJA2aaVrA/9iR8alahlJtFyXyOrO1acgOs6PKJbHAHrqPlsbJM/jRxjOHVpf7/wvupMTiM73Ct9spfB1O402A1nMUJWGdMfL03T749+X8qGbMZjW1nm7B9XOcaVoGKa1FZsB+tqzterZg5cylNtqwVN+zPH7xE0z0DznjE/+Xhbd6UwABPQjsDeXSuDGrSbEWFP8SW23laBI6AeqyD1GoefO8cHT2uDrV8HAK9mo8bbCQT/GJXBHipc9VGMPOENhlCcyVBwHATaGU+yJzmdO3DYGlHAh3BWvWDiOJ/AnnK3ZYNcXhDApQ5QGZgXwkWUVIF8MqXGexBmdUW2RpgPTNjPLCvsvIp5lzW2UKWvEq8oRHi2mBEGDx4rJQWncdMhNxM8JChgR5zax7jqfy6NFVb6Ixpb2Azh/lmDUVBhLgKAg/X6bQqI++uGLkuUdMIALDnXSSHn071clVpcPXn+ZvtLN68jaIpg5V9v7iOA+TU0lubaoYhvkSDg0O/8E9cafUhulXmX+5l/7Tmz7iHD+mx0Ng0gnBugKLUALtSaiMyxiPMEq
 JgvApEcr
 nibz0CVrOffVc0HQr73+WOLjKGTYbbRBuzk89hZswveOkAEvisKB45eY/arjzh0RzIkJ6Qxh/NVka703Eouy/wHz3MAwDF3KIaTdUKNezInkLyKvY6AMwnAQtp2F6h8OKUKFj7UUZVLu0o+0QGw+KqHz/H49pvMuaACdjIrLzk737rmhlz0zG9okPkbkePZGLvtiMJoykFgRkrZjyBQlDa/A3PueAkOuyMCJsc6TV2Hqj5LSSed/O+F8FLUdlY2Su4sZcCpF3vw6U3zC+mXOXO3CFQFZOCVDx92ZOeQozlifQEpwQSYOzu+B9MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kunit test to ensure damon_commit_probes() updates destination DAMON
context with source probes as expected.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 81 +++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ff864402e9c75..d1e8c612fea03 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1393,6 +1393,86 @@ static void damon_test_commit_filter(struct kunit *test)
 			});
 }
 
+static struct damon_ctx *damon_test_help_setup_probes(unsigned int weights[],
+		int nr_weights)
+{
+	struct damon_ctx *ctx;
+	struct damon_probe *probe;
+	int i;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		return NULL;
+	for (i = 0; i < nr_weights; i++) {
+		probe = damon_new_probe();
+		if (!probe) {
+			damon_destroy_ctx(ctx);
+			return NULL;
+		}
+		probe->weight = weights[i];
+		damon_add_probe(ctx, probe);
+	}
+	return ctx;
+}
+
+static void damon_test_commit_probes_for(struct kunit *test,
+		unsigned int dst_weights[], int nr_dst_probes,
+		unsigned int src_weights[], int nr_src_probes)
+{
+	struct damon_ctx *dst, *src;
+	int err;
+	struct damon_probe *dst_probe, *src_probe;
+
+	dst = damon_test_help_setup_probes(dst_weights, nr_dst_probes);
+	if (!dst)
+		kunit_skip(test, "dst alloc fail");
+	src = damon_test_help_setup_probes(src_weights, nr_src_probes);
+	if (!src) {
+		damon_destroy_ctx(dst);
+		kunit_skip(test, "src alloc fail");
+	}
+
+	err = damon_commit_probes(dst, src);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	if (err)
+		return;
+	nr_dst_probes = 0;
+	damon_for_each_probe(dst_probe, dst)
+		nr_dst_probes++;
+	nr_src_probes = 0;
+	damon_for_each_probe(src_probe, src)
+		nr_src_probes++;
+	KUNIT_EXPECT_EQ(test, nr_dst_probes, nr_src_probes);
+	nr_dst_probes = 0;
+	damon_for_each_probe(dst_probe, dst) {
+		src_probe = damon_nth_probe(nr_dst_probes, src);
+		KUNIT_EXPECT_EQ(test, src_probe->weight, dst_probe->weight);
+		nr_dst_probes++;
+	}
+	damon_destroy_ctx(dst);
+	damon_destroy_ctx(src);
+}
+
+static void damon_test_commit_probes(struct kunit *test)
+{
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){}, 0, (unsigned int[]){}, 0);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){}, 0, (unsigned int[]){1}, 1);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){}, 0, (unsigned int[]){1, 2}, 2);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){1}, 1, (unsigned int[]){2}, 1);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){1}, 1, (unsigned int[]){2, 3}, 2);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){2, 3}, 2, (unsigned int[]){1}, 1);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){2, 3}, 2, (unsigned int[]){}, 0);
+	damon_test_commit_probes_for(test,
+			(unsigned int[]){2}, 1, (unsigned int[]){}, 0);
+}
+
 static void damon_test_commit_ctx(struct kunit *test)
 {
 	struct damon_ctx *src, *dst;
@@ -1745,6 +1825,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damon_test_commit_filter),
+	KUNIT_CASE(damon_test_commit_probes),
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
-- 
2.47.3


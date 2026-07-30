Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85018C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948DE6B0093; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866306B0095; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772D86B0096; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 575A66B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE857160891
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:58 +0000 (UTC)
X-FDA: 85044190476.28.BA55F65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 467FD40003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RR5EwBmI;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785386397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=liaC4gsoXyQOSeWbJsXi7paYTFzhMPeKXE7Q3rNWdA8=;
	b=IKRxBrIM+hFc4E7FzAvmhpCm9IHKRg8QOf2JUySwv1boLNfB8HdVq6kNC+Jg884xUUOObj
	uktWTXxhqr5Z0QSYUfqsBLbQYrCuvZLmZrkIxvxM3BrAHeu0qEjSIiK6zj0F1KDOxLNE0a
	tYhDthd5izkEBUTiP2L1xpZf3oyjSuo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RR5EwBmI;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785386397;
	b=C6dX52pGKvjj9x18NNiShXmfVx+iv1Ro27cbP4OcGSo6OGziVY9R2TCk6I79VGcO8IXWKE
	mdIbGyWOygGSG7WSI+npB01rbuLN5mIwIoWfXPfFrOuGqGqWQ/HLKGIaVoZszqxXezCHI1
	F14bO2HnUWa4EC7JJqC/o6qutIL2fp4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 425FC43B39;
	Thu, 30 Jul 2026 04:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280931F00A3E;
	Thu, 30 Jul 2026 04:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785386396;
	bh=liaC4gsoXyQOSeWbJsXi7paYTFzhMPeKXE7Q3rNWdA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RR5EwBmInBmc6wr6EdqCKxSapCPXsS9LvMd1PJuZcOZp+D6SB+pJQ9WVNnrBQOIxQ
	 j7ltUi5IPVTA6F5wMfIE8MxBdoCp92tGku5J1a2ztyR9dwMeSKv9UXH+PAyquRwpUg
	 nSML7ZM9CHpmx/01mVpcBKJF6sDq1gogwPtX1sdNcoKFr8epCiA6afiTcogvXQGYh+
	 nUXc2YkzeIgaT9/EFDrm9B9P/PEhFKCwpZmevXXX7kU9SoWs2OXBAvEMxmrDcBnMHF
	 rUTHgcaY97UfMbtsqPUgXL6Jas9vAG55HiMbxCYBYFgZYsqyoTVy60tEQTdjGA+HdE
	 f6EO03eQeJaCw==
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
Subject: [RFC PATCH v1.1 2/6] mm/damon/tests/core-kunit: add damon_commit_probes() test
Date: Wed, 29 Jul 2026 21:39:39 -0700
Message-ID: <20260730043944.146030-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730043944.146030-1-sj@kernel.org>
References: <20260730043944.146030-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 467FD40003
X-Rspam-User: 
X-Stat-Signature: gep4dqe834pdb1m5erhreo4jr46reexn
X-Rspamd-Server: rspam04
X-HE-Tag: 1785386397-13139
X-HE-Meta: U2FsdGVkX194zRpkR0mD0WU/Omf9/aGMuRtE2IXYXCX1R4NIOYJogsyJUaWOKDqFsH0MmgKflI/P1oIWPxIyUoAVzzbey6c/lbsaRYHidmLp0BqtLyVEtXu8nu738oo7LZuPohFM/drbe9XVOGY/4nZwZG0mQkVYJE4Ya2kzjqSkMjro7m8od/RNgK/7wTW8aGnXz3TezNTQnBHi0gbqHS5KeVI3CqXTHK3BfwPeoA2H1VYX9KLfHcdjMr9b0zIaVFiwce/3alN8zBtUr4Kako9Tb4CmpxvcNNoIVI+aSD8E/zcqi4f71tJMSqK4q2YjGp8Io+7VjmNfcGZCZFgx4pHG4YFrQymhsZp79hahysZ4IKfbeShsaW9FWT3bZ35DfyrC/FXT27n39bj5195EbjRLhUsBAIzgdTXWW7MknDf2vhhVZkmrUIZDv4LCliYGcC3MfS5J0Q2nPzv5EMqx5Y0aVm6HM5Pmg1O3ueaL5S26SW8hFLkrYfNMjpV8PJ8PeSf4B4/IeWr5fZ90qKyjS3zbzsVHJzzCAK3NFijsoS0xh7d5JVq7ZaWi977Byx0GI2u6FF/+nsqZucyRAjji/MqHdErm6wWXv3+bNg4igb5ICVkUCnsmEVRUy6B19F2KxGl0dkqNLaG8Y8Sb2FgUpINsACsQEaFaSSUmQjhqOE/ARSlybZEJJWx4EeBreCzVl1ssefABJxXmZbIy46P1rE1RWxbfqHn/1Rk9gdGhtPrsah5e1Xuo1FLFz+r1QDE5be2sS7mUrkUdDtCdLm0myutTc8emNUFTHYW0LFSUG+z3Kwtm4+hKqgKjm7BnKGNkRbhkck6yS4hMLpwI13oxznD9NT23wn2V3geU60VTIYaSoa8YoY6CmP6XfhhAsaXjkH5G29ZCcrvgwII91Ioa8fVdSSrhKgbSGr2Q0mJdseSN3EoD2Lg7A+a34KbvdVcOLfKVOOclc4Y7A5/8/1Z
 W+VoI50k
 CD2/mQaGwywvHYqtOOQ3w46r+OEsGbJ4k2CM8rAZCJJ28hxy0V7O+2CkFqz4qNcBD9REJ17dtnWZnC/7ak4D6l1UuqC4hcItD8bUU+Xf6YHMiWUpx5X0d1nroSiKfaWzPf6DAt9r96MX+KzCu5ZNHQddX0GeY2xkYT2auXgxIiRiwpYKPO0WXwbs8/Gpp4T0OlOHfOoLKrRZgBWqu7AXdsnZXMY7TRUv8Tm4/NsYKteZet+7sPIhbloAWTAg49+RhpgS8wbyOU4R6W2tHAZ4daiK86n5eFO8jCWooIauo45VSfL4xxY93HHvL/oeTGj3/1ZPr
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
 mm/damon/tests/core-kunit.h | 84 +++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 9cd2be03aeb9b..2ef0609b8d0e5 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1393,6 +1393,89 @@ static void damon_test_commit_filter(struct kunit *test)
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
+		goto out;
+	nr_dst_probes = 0;
+	damon_for_each_probe(dst_probe, dst)
+		nr_dst_probes++;
+	nr_src_probes = 0;
+	damon_for_each_probe(src_probe, src)
+		nr_src_probes++;
+	KUNIT_EXPECT_EQ(test, nr_dst_probes, nr_src_probes);
+	if (nr_dst_probes != nr_src_probes)
+		goto out;
+	nr_dst_probes = 0;
+	damon_for_each_probe(dst_probe, dst) {
+		src_probe = damon_nth_probe(nr_dst_probes, src);
+		KUNIT_EXPECT_EQ(test, src_probe->weight, dst_probe->weight);
+		nr_dst_probes++;
+	}
+out:
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
@@ -1745,6 +1828,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_migrate_hot),
 	KUNIT_CASE(damon_test_commit_target_regions),
 	KUNIT_CASE(damon_test_commit_filter),
+	KUNIT_CASE(damon_test_commit_probes),
 	KUNIT_CASE(damon_test_commit_ctx),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
-- 
2.47.3


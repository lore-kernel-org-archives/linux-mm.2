Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F62CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6B38E0013; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE308E0011; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295528E0013; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1623F8E0011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0DD31A016B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:31 +0000 (UTC)
X-FDA: 84099201942.28.5A86525
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68905180010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I91ZQq0a;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOYHTEBBUG6xZfHTcsyEeHgfnPROZu9zxzAlHU+HJCs=;
	b=JDdijZWdKxf4g44sKn+TEl0iUFu2AZGui0/pki/hsay8TMoo3kxN9b7qMCWzTaw55eylro
	b9wYBCoxbZJxpebh23LDvc0XaMPax0ywp64BYrNrfyW7gYmhHwF7Xdxgit4XQlCVJyFTGv
	1WcJmJ/Pj6wRwix8z5QaYFV+xgyNm6Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=I91ZQq0a;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886670; a=rsa-sha256;
	cv=none;
	b=7aiylM+EsA4y6uWg+ZAuG2tDGAdCEcXkqdDYMNVfVlL6Kb80t5JnLAsYOZFHiFjL1NohcA
	lNzACruOL8WhetV31vCXCla/sLIWhqueYEA+xgjC02d1iRdEVggkbitMl5/d8BMwu6LpNc
	Fq6K+ExbO8yjLBaMHg/LLHJf48XsEW0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AC40160209;
	Tue, 11 Nov 2025 18:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538D4C19421;
	Tue, 11 Nov 2025 18:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886669;
	bh=tky6fX2wXCCUx0aD3orGzGNV89HCs2127JlHIOUkDvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I91ZQq0aHC7IVWjDDARNcxlvg91DU4DWeMAdsQXq9P7alYjccpLNYouaHhVTC3Rko
	 uiyyFpj15TE3NrN9Y9/wxvdmxnT0nKTkvoqPC1c48dhBEKFWhTgnWqRhMNa2fqC5e5
	 7z4VIffRy5a55tWJbJVgPBGJfpF5GQNkYR9TYz0piB4hVprmVQ2LNsbYt1yhrgv505
	 qVWHuIy8hVsDq+EH0zc4aVXFH48Cn/RTEfQcyaTNO869zYfoBfp7KGHZhun+fDCtKl
	 RsXUJHJK6x3Z20TmoCSoogD8jykZ4UtA12nw7xkcflLLQSvGB6nAlS8Aui4vJai0b8
	 lehFzSoWk9TTQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/11] mm/damon/tests/core-kunit: add damos_commit_dests() test
Date: Tue, 11 Nov 2025 10:44:08 -0800
Message-ID: <20251111184415.141757-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 68905180010
X-Stat-Signature: kr14sjk4dibztxp7tfyx3hmfh687rtqs
X-Rspam-User: 
X-HE-Tag: 1762886670-242804
X-HE-Meta: U2FsdGVkX1+WSggs0ES7YpOyCi2wSwDb/aeI81Cx5ugawPivE00jPUcrOq2TF8HUKaBKPsEJSpkuvwh9cExVlzez+xH/lf3vUgscu1JB9JVMDdVyjEtVMFiCtgpgywxQQ7Z24UhfVsXtp/Rr/AaqqKpmGLNuxPL/FW//lXSP2JJ4ju605PXtg2YYv25Wp4/lHcaYombVXIFP9jOTcSD2xKnqLD19c7UMeerD1Qh6zy8+I5klUzpIZ/vcRIRxhdfHuopvcMecSAVXP2lzUaqbVtoqz4UU4tklFnY52zXyGXgrkyifrm0o48pAhIsuoRAT82toiWnOBuRxupHMcbg8NabyuGKMl0xpoRWDQiJPyGNQDmcUPunM/Qs7B8DjG4xHtG2STBrUEW8v1UidjCw6YKykf9gDeucZUkxz5qEG6m7+JgdXxBqyhfDc4gsL/jZzAK2JchOd4wfjBg4mmKB76R1654Gu3xIef/bAO0skVxm0wDXPqfV1MdZFeTdo0T60QQXfePVTlrbqQNMTfVg4mOkm0TtmAq3l2F1yQdhQ4pmUUFJz1eUjItnL+Xw7jycB7lADart6e+nR3uMD/436cEmUa7rKqUlByX/Bw7cQ4L2joxXmKbdLWn7kRPw/aOpdfKl05T1qnjlQA67vpFUl/vsmLBuNey7Y+L5svR4qxJRWF7HBB9KNLuWxK081WhDmlJLnKHjzZazqE6Dxpv7Iu3oWevtUByLFw4HLc3Xtn+Utpz4spwU4BavDCxQj4aU6GP1Jl/MLmoO+755+TDnBYoG99XGbuwCanSEl3DwTsi6UDX0YHiO0SbTLHF1lW8EjdFbckH3MF8FgBUQgOUbA/O4kSOCfUHgRrr0dXrfKnBnRfLTtaCwBKaOAcge6McnFD1OK7pJKRsVKTqaTLWfcHIqWpDq3tmxnFbu7AY7iaFKwXk9gaUxMs57oy41Y/pLktSV5t/gItIH3a90WtTp
 2VZD4+gE
 eGrCbPzf9xI2EqtJSG1aNIOBsgcBF4EmQuLD2LGwEG3h7sjczZXMYAGDlSTiILfz46hlzERaODYSs/IoZ3oLK8YrVVh06XTqe+KnlH9mB2ruksL5rAoGc234cXPfSKx6TlUKS7m+xF8I+LKYEULKIpHBznO4vKFYXZdpfph5hJzJrVDby5Wzmf7s1D65YOAAugT0S71k1KfTiWENgdmyg094kGRkFSlDlDPy1eoCxp99jeT5ykIbGd+44uTP3/AktNq2uw1AKjmt+BjH5/TyrHGOXYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new unit test for damos_commit_dests().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 97 +++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 546e1a09d801..10f2aefc71ff 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -692,6 +692,102 @@ static void damos_test_commit_quota(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, dst.weight_age, src.weight_age);
 }
 
+static int damos_test_help_dests_setup(struct damos_migrate_dests *dests,
+		unsigned int *node_id_arr, unsigned int *weight_arr,
+		size_t nr_dests)
+{
+	size_t i;
+
+	dests->node_id_arr = kmalloc_array(nr_dests,
+			sizeof(*dests->node_id_arr), GFP_KERNEL);
+	if (!dests->node_id_arr)
+		return -ENOMEM;
+	dests->weight_arr = kmalloc_array(nr_dests,
+			sizeof(*dests->weight_arr), GFP_KERNEL);
+	if (!dests->weight_arr) {
+		kfree(dests->node_id_arr);
+		dests->node_id_arr = NULL;
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nr_dests; i++) {
+		dests->node_id_arr[i] = node_id_arr[i];
+		dests->weight_arr[i] = weight_arr[i];
+	}
+	dests->nr_dests = nr_dests;
+	return 0;
+}
+
+static void damos_test_help_dests_free(struct damos_migrate_dests *dests)
+{
+	kfree(dests->node_id_arr);
+	kfree(dests->weight_arr);
+}
+
+static void damos_test_commit_dests_for(struct kunit *test,
+		unsigned int *dst_node_id_arr, unsigned int *dst_weight_arr,
+		size_t dst_nr_dests,
+		unsigned int *src_node_id_arr, unsigned int *src_weight_arr,
+		size_t src_nr_dests)
+{
+	struct damos_migrate_dests dst = {}, src = {};
+	int i, err;
+	bool skip = true;
+
+	err = damos_test_help_dests_setup(&dst, dst_node_id_arr,
+			dst_weight_arr, dst_nr_dests);
+	if (err)
+		kunit_skip(test, "dests setup fail");
+	err = damos_test_help_dests_setup(&src, src_node_id_arr,
+			src_weight_arr, src_nr_dests);
+	if (err) {
+		damos_test_help_dests_free(&dst);
+		kunit_skip(test, "src setup fail");
+	}
+	err = damos_commit_dests(&dst, &src);
+	if (err)
+		goto out;
+	skip = false;
+
+	KUNIT_EXPECT_EQ(test, dst.nr_dests, src_nr_dests);
+	for (i = 0; i < dst.nr_dests; i++) {
+		KUNIT_EXPECT_EQ(test, dst.node_id_arr[i], src_node_id_arr[i]);
+		KUNIT_EXPECT_EQ(test, dst.weight_arr[i], src_weight_arr[i]);
+	}
+
+out:
+	damos_test_help_dests_free(&dst);
+	damos_test_help_dests_free(&src);
+	if (skip)
+		kunit_skip(test, "skip");
+}
+
+static void damos_test_commit_dests(struct kunit *test)
+{
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2, 3}, (unsigned int[]){2, 3, 4},
+			3,
+			(unsigned int[]){4, 5, 6}, (unsigned int[]){5, 6, 7},
+			3);
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2}, (unsigned int[]){2, 3},
+			2,
+			(unsigned int[]){4, 5, 6}, (unsigned int[]){5, 6, 7},
+			3);
+	damos_test_commit_dests_for(test,
+			NULL, NULL, 0,
+			(unsigned int[]){4, 5, 6}, (unsigned int[]){5, 6, 7},
+			3);
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2, 3}, (unsigned int[]){2, 3, 4},
+			3,
+			(unsigned int[]){4, 5}, (unsigned int[]){5, 6}, 2);
+	damos_test_commit_dests_for(test,
+			(unsigned int[]){1, 2, 3}, (unsigned int[]){2, 3, 4},
+			3,
+			NULL, NULL, 0);
+}
+
 static void damos_test_commit_filter_for(struct kunit *test,
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -980,6 +1076,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_commit_quota_goal),
 	KUNIT_CASE(damos_test_commit_quota_goals),
 	KUNIT_CASE(damos_test_commit_quota),
+	KUNIT_CASE(damos_test_commit_dests),
 	KUNIT_CASE(damos_test_commit_filter),
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
-- 
2.47.3


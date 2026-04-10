Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5B1F44873
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C36B6B00B5; Fri, 10 Apr 2026 10:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9257C6B00C0; Fri, 10 Apr 2026 10:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6506B00C1; Fri, 10 Apr 2026 10:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2046B00B5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12953140518
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:52 +0000 (UTC)
X-FDA: 84642857544.28.5D835FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2E8AE40004
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j8rIT6g9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+++C4FbPvLuI+LhwloavFM8OGN025XzDv0RO8kBiFY=;
	b=i+1Cr59D/DdBYjdgDCTUTcaAJZiDSWldfl4zlIC1kndyyGA2qKJX6yUEpC3PieqzLyL4O9
	sjh6GDYMSBeG2J09EqX0LVVTo1/u2zEFb/82KZY3ZnfqpwQQmrl6RVQ2t3cNA4v5/cPSZA
	36wgSD9J+V0jBef0rH3aS/1wyuiQKHo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830850; a=rsa-sha256;
	cv=none;
	b=EY/oUeGlN2i6nKELqxasp9lwSOk+kdwy1/wnyHZ44JeoDMCWipsKLdfYLQxqQNOYPQJgVq
	624mCs395fVzwNLqhu88QK2qYQlhDYTljTXGv60T3Sjgle+TRld2zk9YoRNQmSxnnnTV2y
	SgMTYudm1BBf3ejCtWV4dUPl2mHMZrA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j8rIT6g9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 22BE74458A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB940C2BCB3;
	Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830849;
	bh=t5zJdXrSXfUqeg8E0cFC/+8XELPbXvEetq+3G/tXFao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8rIT6g9MoC6gWi0YoXdTGZJ+Mj4RyQ2nPugKSU7F4vLAllG9GA18qoRQPjGp0hFM
	 CPa4oNRltpHL31jqq6Q/gNyEvh9DWo9kAQ2gybxgUEyGJR0FmmQxEztoA9tZevMtYC
	 0zBjKdAdetGEo8Yka41esJRrCdtRETVCmyAjfvosdmmZOXR+JgwtmyN7F2QDt5JFb1
	 bsUyWjNGlqewo1JdJNtVhwvfjvvz5hI1b8U8FLIXwSDfdvUyNXQ9nIUI1BVPQZ0dW/
	 +jIwqbi/wFQQQpZVltZo1Qcxc3f/Bwxs8hQWEARwhbhX7m9t/+NtTOlpa0XEdRHtbO
	 bqwxbiW2KL76Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 11/11] selftests/damon/sysfs.py: test failed region quota charge ratio
Date: Fri, 10 Apr 2026 07:20:32 -0700
Message-ID: <20260410142034.83798-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2E8AE40004
X-Stat-Signature: 6u8auo156w1hqnk1ktaxmynq889orojy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775830849-784229
X-HE-Meta: U2FsdGVkX194oi1Ww0mDp3Sg6Vvwf9C6MbT6CUamRD+5qAKbHkw+gzA/rLTefXp2KGLkHjKXr9kxE7Ze7yuwGNurJa48YWkxMZd4stmYm0DswcBEK9RhjfuvwQVC4nhvfEVn/Tuvhx8BzUYY6dt8qVMGEFT/yRQXnn4WtSPpB44a5u6TXLLpCNb/fplTiSnK9OvN+lxJkyh/TMpSiMe/PaAkD4W7Vmd5Trr1FIg+YX85doib7L82aeOTSpLA+qKwfeapMTNpWylb6/gkqj9vyGdfJosKdMQ6pckPyVSt8VHE5YbJ+0OmWBy77kgacNaSAYVQAuAZUFUEpKQunycakey6cvDv7WUI+eQytgEQqUOjqvm/Z5xAZMeGOu3jw6s/kkhzJuchCqQLMvfQUvZQFKgBMRWClFgeBvYzUrby62PaginxHSaw5Ti3THcXxULxK/yLAetE7oLDWdpw9g8bF32yhtd2Dsm5ZdTaHp3QslTxVY4xsXFsDHlbbjlisPF/PBy3mShY3RXsXLnqjvuOz7Y4dQ8bx/G0TksPh4cCKojXWe+qGJ849A+5HhqzfmfjOEYmh1o+dnQEcdwtIST/kOOfpYcGhblpL1bs9wffM+t11SEzQLYT0S68u9nPTIrDofM5MHR16hrSvAVOiZLdbpvL1tJsQ7PYcHTl9YWGFkY20hwspJhVlDlUKr2fRZbqsEzXn1d9/IrEylYuHk+bOx4VjZrPP0Bj2am2zJGzW29K2Yj/HMRyH7u6DiunIqcA8MEPAI769bu9uq4EoNrlVQtinEBJxS3x34C7htkrSj3Zv58/7JA8lMuAbUH5Rcgok0t+u9NVD3feiy7v1Gdee84KujgXnQ+PJssfrp9EhEyLrUEtXQfM0Skfm9+pEBpiPU7L4oSliqZZkTC7fgjY4oSPEdSP2oSjoSWPCbYO5zDIk0ntMgHfG4WUqOBSxoHYRIxjcGmchgh2u7z7CYn
 ep7kYrgy
 bRaRT8Ar9fDz9HnHGmNg1rSclh1BlGnvhWnH0T5LiV4m03KCl0TvsBXEXbX56yNAs+DBmjDeQ24qIlWiUNt1NrroCCt8I0S5TwHagMzzKdQeZi9yWpNOE9tQ3QXkLbXNT2yKljAWheAMiTSq2xehA1bpS/S436KyriX+paIjfKoO98/vcyXs9wWb5WF1aO9WzSpxfbU0TjkGEp0fvGPeMBiMLvDO+RY8W1U2CC9ejJ7AewTcgetZRvixn7U+kvZZMoOh6SlSnzyergA8J3PQOhnohResM+K8L/Lte5qSRs71MXYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py DAMON selftest to setup DAMOS action failed region quota
charge ratio and assert the setup is made into DAMON internal state.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 387286dc449d5..cd4d82c852113 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -73,6 +73,10 @@ def assert_quota_committed(quota, dump):
             }
     assert_true(dump['goal_tuner'] == tuner_val[quota.goal_tuner],
                 'goal_tuner', dump)
+    assert_true(dump['fail_charge_num'] == quota.fail_charge_num,
+                'fail_charge_num', dump)
+    assert_true(dump['fail_charge_denom'] == quota.fail_charge_denom,
+                'fail_charge_denom', dump)
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
@@ -278,6 +282,8 @@ def main():
                         nid=1)],
                     goal_tuner='temporal',
                     reset_interval_ms=1500,
+                    fail_charge_num=1,
+                    fail_charge_denom=4096,
                     weight_sz_permil=20,
                     weight_nr_accesses_permil=200,
                     weight_age_permil=1000),
-- 
2.47.3


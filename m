Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 306CCCDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1796B00A1; Wed, 24 Jun 2026 10:20:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89246B00A2; Wed, 24 Jun 2026 10:20:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC5CA6B00A3; Wed, 24 Jun 2026 10:20:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6E8E6B00A1
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DE071A0363
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:35 +0000 (UTC)
X-FDA: 84915016830.03.4D2DBBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9D32F80006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="it/Fw2P9";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310833;
	b=BilcFV4JxdTbH7PexIOk0eyPpsWwakco4bZqNGai6xyzSuk9V72xYI1hMH1GNTwtdZxx0H
	xv2qzd7Zu6+u3r1d9cPyge/tBajFrjX9Qs2LAfEzv2vwTjFKQFP7LgOq5uHpsnihOgL7kR
	qmNM8AAkUEBVVwjJ1B4ni/8G6iehJCk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkNy+Z070qLX1ZPRlqmLyq6fS4C8mG4AOsGTvswsvyI=;
	b=64IAgVToThw0cUmFBVNx/cN/HQGaIrX9Rt9QUXRLtf5mo05mKOUvPlHS93us22Rcaajl1Y
	QXDOZS4VRHjxSy0boEc154EqqE9sej/vhQ2g6Xf8NSybImn8rVnU99Ezvoyo+o1bkzS4JC
	Z97hkMkG+XghyUKVabPQ7zFNBHTiOG8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="it/Fw2P9";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F31760217
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275181F00A3A;
	Wed, 24 Jun 2026 14:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310833;
	bh=fkNy+Z070qLX1ZPRlqmLyq6fS4C8mG4AOsGTvswsvyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=it/Fw2P9teN1xXmEMC0JAVSjsosSVhCjbS6xr5owDv1zQrqZK/zq2x0YW6rSOJaSq
	 NNpgacRhprqqsz2JlLVwUCFCnBXqW7BBO32uQFDVsDfL16qoH1peCUJfLLpYU//BZL
	 Ub9zcOu/jQAlX1th1e1ZO9vyom9NlJEx62XI/CpIQ4HpL00kUiqlR7eXXAOUg0VF90
	 XVN9VKtEIqychBNLbtL0wEHXnDe/C7I+60aYxlEicUeqzfN5GHnV0W/IYSLaPmeb0U
	 Ok+E139ZtA+CuEN+ZNO90+eBdovrjkIfaQSCdccTZyzdEcW/kZ8X9FWLhPsbR++YIk
	 QyhIEfIAPcIKg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/11] selftests/damon/sysfs.sh: test all files in quota goal dir
Date: Wed, 24 Jun 2026 07:20:03 -0700
Message-ID: <20260624142008.87180-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9D32F80006
X-Rspam-User: 
X-Stat-Signature: byuob8kze98qs71yn78p4h5tyafbfkag
X-HE-Tag: 1782310833-391483
X-HE-Meta: U2FsdGVkX199c2x9qVhcJLfInHHkWBIMbcHzv2uFxGkSGweKMGWp3J/K/O7OGvrVFw8PJ1+TmI4D4+mpCoqHvVizN0vHk6qDxGK5vF7hpweFZ6jZzMgY9x5i+D1Sff7j+BUPkFSgzyFkS3lGOVaLPnVCfvHcn7Oi5NvO8FIx1IPpaERqKJfs1CBzceILCFWb/ZGxPXKVTG2Isqu2muja/QjlqKrXLD51siIjWKfTdAO0oYaMOXKkrMVGsCPk3cCkMDNPo/c4zntuFw5vYgJiY4el7HkI8kEiCUt73sBMX5QBmT2iXS8aNTe/GCNOxIHO13DKNuvK8fDzieZwlk8k7Kzk8ZAPCYTAWqpoIhSqn6MXObb9CXSWvFo7RRTVcjQ+8Fl8z8tDbouAb5YLy04FnU+7E3xlyEOCEKM7fi2+Up+8W3/RJ7TdYwLXf8J72ysL0YReAaajdGzNFLd0WUYBbkOuls5a+MGTji0ngtcNjWin05IbVFRgh6Se8ooXI429FxTFv/8ASfwmjXyoBSrEMY/t8AC//aKCGzd7V9IkaHohhoduq9TF50KYjoGFYQBhfXEaJqtH/t0GtfoKHoDExAF2QdMS3IsI+95Q7Lp+OVMFWI9lvccTUnCqRFSFXpFUTyC/B9bkm9kKOcao6xMKY2HNvefxbS2R9jG79uFhQQRHc3Z82DFOr69FJExgeF0cJrBQKTvKPZYBgf6o1BMwNRnbcRb/tYFjlM9+Y6BVjmf1ieQyBEWv3tFBuwKOg4QN+Gb2BHIbZ48+HryDLEnFkNPkQIBExUFvU8GhEwAC4FufYs1LzAZy94n2rHNAttLOtyjognsvbJ4Q9ZC1cHlw4k8zG9dOFce3odT96Yxmz09gKfGnLl9iUzfG7NzgkIjfbWvxak1FPciKJU5YChe9oEbkIfPI0e+Pw+lA7j/c6Wrv8ylHyuRw88nGoyt0NUUadba08SbuCJjTxIDXJjZ
 ZMuJha4B
 +3QzNbEaRnb8x9Zbk/6I+bzqtB6nzqRDGrMsqwuefvxJyHodMXL/4dGXC+wAA3AnVnYvenxxbFLWVZOJM0xzScQHBqVVyCADHTXJH3zawFwgXXT50u+mMFgLhF6JNJWja+wqzoA0S8OCWR3mQRMYkhvQnqp1rFfEBDskNUqpaW/A69cOjvPq3m+mEo1xz2WE2NihlEwjsJkzeUt0G/Bm39PQrWhIMECtJKWFMzuJRHVlFcciVrJposaVvIOGBX8wr9b3hrtlfgF1duza4ZWTvcoJaGKk91Bxjg7gNLnY85NDC4tM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface for DAMOS quota has quite extended since its
initial introduction.  The test case for that in DAMON sysfs interface
essential file operations test (sysfs.sh) has not accordingly extended,
though.  Extend the test case to test all existing files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index cbfababa0bf31..ad3aab240b360 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -199,6 +199,20 @@ test_goal()
 	ensure_dir "$goal_dir" "exist"
 	ensure_file "$goal_dir/target_value" "exist" "600"
 	ensure_file "$goal_dir/current_value" "exist" "600"
+	ensure_file "$goal_dir/target_metric" "exist" "600"
+	local fpath="$goal_dir/target_metric"
+	ensure_write_succ "$fpath" "user_input" "valid input"
+	ensure_write_succ "$fpath" "some_mem_psi_us" "valid input"
+	ensure_write_succ "$fpath" "node_mem_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_mem_free_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_free_bp" "valid input"
+	ensure_write_succ "$fpath" "active_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "inactive_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
+	ensure_write_fail "$fpath" "foo" "invalid input"
+	ensure_file "$goal_dir/nid" "exist" "600"
+	ensure_file "$goal_dir/path" "exist" "600"
 }
 
 test_goals()
-- 
2.47.3


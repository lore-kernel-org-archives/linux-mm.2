Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83273FCC9A6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:06:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C64D6B0098; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8264F6B00A0; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 427796B0099; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23BC86B0098
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF12B1A03E7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:43 +0000 (UTC)
X-FDA: 84528360966.27.3E316A9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7067DC000C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UIvhq/+h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YY3w76yaP1+vxQGh9szEkkcRD1UYMuWGT8JryoousaE=;
	b=eBPGMuDWQUT2r1jB6f0B/8Z8IujlOjMW8ZxF34348aEeOVwL8sMU030vKxnD+qTZdplF+h
	aH7A9r5x1chm7VQEjqpBIvLs1dz1nstHOehf/hLpkgbhc6EVqZJDbFM4dmp0m2E+DEPJGg
	iK0iz9a3DIbfPPbEIuF/itC6uPnWy6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104742; a=rsa-sha256;
	cv=none;
	b=MELy64B+6nUQgmivWFI0cB9y9tEvHO9cwYzyQvhTTBxySwk4JjCbjpXiaWDEOhAWFMK6+B
	t3Im2qVHvl6NbpR66fvcE60vsAhMmaG8jyghju3jhaSI01YTOfuwJA5pCSpnsG9fZXduX3
	0UYHHY9bf5RYrZmJbCUoWgl6gSO75C8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UIvhq/+h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 01D6560127;
	Tue, 10 Mar 2026 01:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5CBC4CEF7;
	Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104741;
	bh=AVTjUet9MVkl4nT/vo+5gBPPg8P0HSyE/9BxBCU3HWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UIvhq/+hQeYCPKpUSP8TXJy821rg4ytdFyEXUI+ixQkl0TJQTits7tVebKPesxw/G
	 Z5HLBb+unJAdHwBLWUZ9NwpWhy9/nbURcBYGy4TFR+nTWjz0Op1C4yNLZqB5xrHNAa
	 9GICtl/JDQ8jxO83MGZlTlmcP2I/qfoadPJ1D6tQBnZlPwFa313go/OyB/OZR8Hwvp
	 XnRGjlKY9wLyxksizKapi9IEDDkcQXL0KvvgurJursHtUbUWla7/5ieBF7RFh8aJBo
	 YkX+ppKXbjeghAvFx20l1dQSBYCfG6GcBb6AHtYhALLXmiUxGRTQA+lf6oq3UGN5YR
	 c5La8jwN0cClQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/11] selftests/damon/sysfs.py: test goal_tuner commit
Date: Mon,  9 Mar 2026 18:05:27 -0700
Message-ID: <20260310010529.91162-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7067DC000C
X-Stat-Signature: af7tn1tfzq9oemf877o4rcmmyeq7w81t
X-Rspam-User: 
X-HE-Tag: 1773104742-485974
X-HE-Meta: U2FsdGVkX18yAysj1mzcZ7KCDgqu3PPOD4M6DS/tntH3JPM+VVjCu+f9T0fzkvYfedsNunziUujv534rQz2njhVdvn8Zu256p7obAEYZruBSdfTxpjQ7Tj6PlaUO1REA504RaIQ88T/qjaKMUFfiiKhhkyjtrU6mPtpBrGRJhtxr/w4bGgkH7jNUtWf+X6Epsohn7B+0Rp0EKMOYFPyydNBzJ2ouBXsdSUwdhbPBblMad96LjQO/mSKbMfJLBHJJjdpGcOdCporAQtqu5pcZ+j+N0FczPRpwTWxx6sE2npgYgFFGUCJVgxBk8goLdQ9Z3uNFoxV+jb0EKrq2R5s50br8NMz+h8f1TIhZWKnL9cbQMqp1VZ0FAoCdaHnAZJuRnO8ISydrJtNQqH8SzQKGA/GIIpiO9iL0VEGR0ba0ROUhthsEwXb9AH9+u8CXUvjYR5n+EGui872stZ8n+wEye3qLEuWBMhd0+duH21PL+rI4yOV49w+kRrDiYCdDvtq7LODm2GmoncgvP1JwXe13MKj2aYMlEoJ0XLr6GdXWcUTDtxVlDE36jHki6H8MhYNQWFVUdLBkUSRsfNAIB11mr7M7DOUURrTXOTBiPnFtOiBFoCh2MvownpfFxKxhoEqUhOhlHa9euOrncNcefet+k/7V4NBzuRmu3+dFwsw7N5K3l/H7a5OgSGKjyPmFqVx5+C2ZbZq+cM7ukVDGRy7nx74b4bEaarlP2e65pfrOThgkke0Dd1AunEpZoUMv1jePFzD1BCVW480HQCrciSBKRY1+YYMghsWHTvzUSZZSltrg1dZV0RCndaP7TegDRdo/ECIH8iAvG9lQUTmL6Z0tf8/vnbILNQ2Zs5PU/yqSaSFxlNWXEbe32JWa8ZmL4CVgrthm0MRnSpKdRHq7OayAwlYvwz20V9qiuTI3PgJiDyK/EzWAwsCzfv+GFOt+v2y4bwKPY+T1fRDnNv4E9zC
 cE2WV9Gi
 xI4FxRunrUukH+yvuXk0rB3941gdJWgBe3Acz5nrNd/O9vbRedxN79vCu3rL/hmrmMEtTrJEeYfk1Ab8LsWDawHxgtJ6gUhw0/Bp+94YXfuCOWNhPkdabXjnmyHhxcwXKKlwJ6i5FnvT8Q5xAFdRAwKAhQAocH8hQBAm2twQcAkojPrLpPr66bkrrP2oWk7AagTWGv/hwUyWJzIRL90RYKejJwE9QxGM3qz3JUiE6eNIfrHPWL3cs2JgHQLRsstlTPMf4c60Z+yR6PUsCG5qOxdIUfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the near-full DAMON parameters commit selftest to commit
goal_tuner and confirm the internal status is updated as expected.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 9cca71eb0325e..3aa5c91548a53 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -67,6 +67,12 @@ def assert_quota_committed(quota, dump):
     assert_true(dump['sz'] == quota.sz, 'sz', dump)
     for idx, qgoal in enumerate(quota.goals):
         assert_quota_goal_committed(qgoal, dump['goals'][idx])
+    tuner_val = {
+            'consist': 0,
+            'temporal': 1,
+            }
+    assert_true(dump['goal_tuner'] == tuner_val[quota.goal_tuner],
+                'goal_tuner', dump)
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
@@ -231,6 +237,7 @@ def main():
                         metric='node_mem_used_bp',
                         target_value=9950,
                         nid=1)],
+                    goal_tuner='temporal',
                     reset_interval_ms=1500,
                     weight_sz_permil=20,
                     weight_nr_accesses_permil=200,
-- 
2.47.3


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4456FCCD193
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 20:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93B38E000F; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E434E8E000D; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D31588E000C; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6BB78E0005
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 790F611A3FE
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:55 +0000 (UTC)
X-FDA: 84012414150.08.C22DCE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id ED6274000C
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FDYx4y6w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760820294; a=rsa-sha256;
	cv=none;
	b=8W+mbGy+YbK1amfYauz11zKALK2XNFn/gBvP4/tM84Kg4NF8yO1uPjsgys9WdkY6gEo5+I
	O0WfYk9SY3+SeN++whSOJBIjvo29IEYEERggmdnR/BX0ZbaScSMt3Cj6DDHTrwYbrrQZ9x
	5LoyjEQuRDYhMUeVJMhUq490UEtCPmE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FDYx4y6w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760820293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyp9COVVewkDgGHqbSuc4KGan96G8yD4i360KepalHQ=;
	b=J68bMGdds+YfFYgyFLBPByOA3bcjeFsnVKEjn81ERazOvEVP6umTdEo1rXltQyKu2ynLGf
	hmCkDgDEo4syQs46fb84gHeG1K2Cypxzn5PBgKS88eqDRmPVARC+Y2w52Pbe3N2nuHB1Ih
	+3gQwkvF1XKH6JLU8mBf0Ov84WmJQQk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6773F60468;
	Sat, 18 Oct 2025 20:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBCFC116B1;
	Sat, 18 Oct 2025 20:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760820293;
	bh=JDAR5vBDfrQKj9l07eWZCbXqGebT8PFUKr3f9iHJS+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDYx4y6wSdB04oRFCmuLkrqCOm3Fdh8tM9f3mb5PxueJPZaw3cNorfkUUjXq3urLg
	 rDb2Tc+3mneR9llm1GcWC8cykf95pS34V1lznO4Fg0mY+vwnvWE75g7wNVHTPFTYvY
	 OBpUeWqpKSiInr6pk+r6ZIRj6JV8O2DL2wiMr312gb9eYm5KC8b3Wr+HC9tlJCpfNk
	 qmtwKre01Sj23dLd0x7T3Q5mgi8UkQT4IUd77sqYhuXR+7n5WMkY+7LQbqA77Q3jZY
	 ZXCR7lZgxHbg/WIEVZCGMM7VnS9CwlHAlTLDrf3NC6paaJ42GTHSvt9WdHtGVHFslT
	 rqedKtWmBI8NQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/4] sysfs.py: extend assert_ctx_committed() for monitoring targets
Date: Sat, 18 Oct 2025 13:44:44 -0700
Message-ID: <20251018204448.8906-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251018204448.8906-1-sj@kernel.org>
References: <20251018204448.8906-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ED6274000C
X-Stat-Signature: 4ibjpi7yk7jps7ofgdmp76swhri53k7o
X-HE-Tag: 1760820293-66399
X-HE-Meta: U2FsdGVkX1+Uj0ut7xUsEF8UvOUZ4HcIiiCrnU+W7LQ/8McQ11uGBfn4uiQSeX9P5rMvkkZgqFc4u9xXqPbV+xJhrT2CaUB00gLnTMmxUNWMDgA+9OXnDcPPwbc1ScNgvrV0L1Rv+AwH66CR8907G37uW8Thg8AjN1n7MBjB44gww1ewq/HXHURWrq9k3Tl0dySlmyT2+GXVFaV2TACQ09DH2dgKsatt1B7NRqqkwQJqcModL+m5wfPbpGeZWCOgyxZhPyZEyWScYx4ThKNg8IzKrLjlboa3JE9SrZfbs5YVEYjgX8ZZmxtQe3xvddTe1vup+US993vn6nI2EmB51C3dhmjsj9Y2UBUyJ6tR/jH3Mn2YRvg3ApaB7ZJMCIXhlLPRXS1/ydgS9MbRPvtHVDQjCELQkJ4GrSTH2Nu6AZYuD08CJxeZWeT2qMGr17/x2FjNSaZVwKj8d2Yvdb8UJ2tED4U0mPyQaUAEPanaY9iAzeDcmcg4tanVw3Y+IwFVvCUScZ/tjpAVzJBP2vcR5V27vClP55Ndw74lPQzVVAe9otUFXEZkivncrOrRxH02hYHfEvETbthDCvX29nOZq5IdJIDSbwi9nLuEsSv63/Jr/LfWBLNzLV1UJzkEKCE1CRJseLNwrlGIQz55s5SDMxmFutIOD9oOnaePeUkDifZDCWg0s3XYzqHGJONKrkzac9bqOqnJqYmZvu1O9ZaIuAtElaQE+ba/+K7lYEdNjjpZHtGRDlGXXmifWH8n/weFMwQjHewoJjwrErFSu/04O0WmFGyGsoIrSFYBdZzx+pD7OClkFkYYbkUDnLaTbui8DVKUoCoLvKZ4bVUrHOvIu+sOmFosmELAiEJvG10RuoR1vK2N7Dq6athF609Bl54/2+3wABQ7uG2ZCLEvu2SJp6EZXQp9bAZeePr+vX1Nd709Lx2ckJlfKgd7Hm6h7VatyHkW+7YQ9H0PcV/fww5
 4geGkV9K
 ChdjSRvIZVpOZpTVE/kelhV3T5zEGK17oA4RWN0+2AoNs+yhQROIlXUVzegkGShNKVzopn/MPpOK1Ly9uaPENqu3foTSTBqDVeBP3hoOlElznIFry+9k/q6D6AQkOrE3VuzKfq3Eh4rbFB45wVNIke8eSyNgDjrhWJNULeMr8C5y3cbG4pK/7nnSox0lL5qMva7LSymNwWiN1GyQLixQZQVfkjtzJmlKVuq4NNEKGaIf/LAFzgdzYRtIcGkOCvYp3FZNA223qdapzMitqObUXLxVR2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

assert_ctx_committed() is not asserting monitoring targets commitment,
since all existing callers of the function assumes no target changes.
Extend it for future usage.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 2666c6f0f1a5..fd8d3698326e 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -164,6 +164,16 @@ def assert_monitoring_attrs_committed(attrs, dump):
     assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
                 'max_nr_regions', dump)
 
+def assert_monitoring_target_committed(target, dump):
+    # target.pid is the pid "number", while dump['pid'] is 'struct pid'
+    # pointer, and hence cannot be compared.
+    assert_true(dump['obsolete'] == target.obsolete, 'target obsolete', dump)
+
+def assert_monitoring_targets_committed(targets, dump):
+    assert_true(len(targets) == len(dump), 'len_targets', dump)
+    for idx, target in enumerate(targets):
+        assert_monitoring_target_committed(target, dump[idx])
+
 def assert_ctx_committed(ctx, dump):
     ops_val = {
             'vaddr': 0,
@@ -172,6 +182,7 @@ def assert_ctx_committed(ctx, dump):
             }
     assert_true(dump['ops']['id'] == ops_val[ctx.ops], 'ops_id', dump)
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
+    assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
 
 def assert_ctxs_committed(ctxs, dump):
-- 
2.47.3


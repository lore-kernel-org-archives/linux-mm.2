Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9E4E63FE3
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 16:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806936B0098; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9436B009B; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1DA6B009D; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 550A26B0098
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 19F951A07EE
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:40:00 +0000 (UTC)
X-FDA: 84621435360.21.A2A41A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91CC3A000F
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZQUJmd2X;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775320798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QO0HMgZR6Q1HucKxNFx50+mXtq1QtftwQyXEIAQyxA=;
	b=VoYb6Yc6hLeaExsUsQv1Iv8w9xKX2MQwm9ByV70lyjjEHrxr5PMQRFBimTBVYYLPgXvt2H
	AEaQPGGZykih5NAcH7WGMTM55PMBP2ockIRgVlb4Y7JeuCHjCbGhUFv0DXywJNl58DDN02
	XNvDEIPifLinvbPqxzkwUBrU3SNPCss=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775320798; a=rsa-sha256;
	cv=none;
	b=MM8hRI7ayqkqUV4r4tIuu6h0DfTnoui2vMe22Jn9YuI5G4Lm9ErjmsOZqr7mk+lMxXAcQo
	eiUfMIPY5k8l2c/RgRycmtD9LwJZ+bnizPZ/Nak60mhqIMetKhmp8obnmwiSr4B1gUzMte
	nsTcGOQ2ZGiD+HlalcGpXe9MlEUUSaA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZQUJmd2X;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BD7660054
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80035C19421;
	Sat,  4 Apr 2026 16:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320797;
	bh=6J24o91UAsIJGEgFo2jYtnFEeYvJuiRUU82+7XJIPqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQUJmd2Xs9M6NmI0n1SDk8BUYsVgCqaSaiNWNu70aAJi2l3s6ppw+2vDbfzGCQZvA
	 Bp2nlhzoASKNWldlyeab3ffe0LXbIgPQbbKQX4kSHkL7k//sNISwgSUUR0DK+XqroU
	 tGKc5Gmv01Kd6SROExK1U05lQzJtgYcdhu3pFT619YC6l+1v+XQImoDQkWKVC4K0b4
	 7EDG0g0bUrYBThu7eQ9S94p4l0zPdjXAXGzpzQlkh7eQB/aBCpSJTdAIYOxaeZFqcd
	 sKF0jmy5nS/42uN47SK4pA1cARMWIVNV3n2HgWaSg5wKMh9W3VrrWnFNv0Udi295s/
	 Od9vjjHXQ+Jyg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 9/9] selftets/damon/sysfs.py: test failed region quota charge ratio
Date: Sat,  4 Apr 2026 09:39:39 -0700
Message-ID: <20260404163943.89278-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: <20260404163943.89278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 3b3w8hqesow7tdib3gt88m48yibjkudi
X-Rspamd-Queue-Id: 91CC3A000F
X-Rspam-User: 
X-HE-Tag: 1775320798-161543
X-HE-Meta: U2FsdGVkX195Mo4+A5meDDw1DlYqV8nC3YgHEeeZ0r5di7xK7guyLYLTiMMJxtyKcrzq1ujvyu339I8WljnUek4lsiSzWDMLrvayGdf+PbNa+a3w4q6DycbJjUDzSaEaydtASY/S/83FwhCscqvDsUwZOwVYkaXMHtbh9u7Zgd/o4Bq7PxioQ7RLrZHyTtSgVz8pz6Wx8IVNQ/wL0YbTXHrMsIV/Xh/Oc2ENaGGdmNwRIO9EaBM9cJESrKY+JcEswrJThqQLFapqioFI8O6q78XxMg/RxjOcTJmIW8PY2DN8e5wekLgEoVcawQVBjrNekkVRaVezZIepfgmqUTBLt0M3EXCamB0d/qmWtolKMlpvd4W90t2dHBijzc2AwchtRMxgsskhXvTIJ9UnhpnLJDCvIj2wCwIOBE8BJJOJMWZs86C71mIv1AfxqAWG35mRQf8P92mSaMSrn8u8xhxWNLgfzZf4k4jL+ntRcPZgkhv6Dpb6/gXLj5UwFavsXhAP5a17odNz+EVqP/5aFqCQMybAKr4R789fZOcYLaylaRIPP5rllVl9y+/CuPw14UtvO6qJA4gjXPo40YDSKCHKnTOl3GXXoFObk/LuWw13JlRNxbCD/z9GOo327lhtGzPjWdmMU6yzZy6t51JgApnCX0JA6KK2LI1sCU3C/AqpZQAk1disA0R5NMztnNR1wJE5QXNZfNB05j2jlP6G6o+bbnTvtRjD2xeSIJJoLqAA5CMN7N+lrSaG4rM3UENXCl70fpgEGpqm/buUC+SWTWRY1JyriiKePj5vOQQM2T4pi8QVCDK7gFXZrjxw4ps8ZcV3ZnZqCejiLHygaqCgnuyrVrvL2w6bcaFn2h2nAJSqbyT8iDogeOm+S3k45+jVyN+/Jlz1tU60ovTiAjjAEKkK2j1SPFK0zeJxT+GG3A6w2qZkJz1OB9WkQU+dqfiNRpdB//gmYWgd1MJ0v12ItLf
 17hat6DU
 tqCcRksnQyVfUAsUI1lYXnAbUMZHDcqdZxGHqPb16eixJtGyCYvwybsCqLBB9JwBoPhJ3m0/A7l84co0qu9BHduJcTlTjxaSuqUXISSxsHiC+qe002E0WwKagCESei7QkGd/SwhLQPZTlsJiObSgRQFvIU+4smKu7kRkv2etZhiKmw2hlnT6Yn75hF17/hrhaamjVT05a52bueAOaCcUasc0rZJ4kdcyu9iT1DX1hMkMG48LJN7gLFBDepSaUEv0elSIdV+uX17N7vMjgxdaE7SEm0dC+EIx/mg40b3MrACh0WQU=
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
index b8d6e0f8fd906..d8d4717128898 100755
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
@@ -277,6 +281,8 @@ def main():
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


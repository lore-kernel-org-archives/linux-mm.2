Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA99F31E25
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DF6C6B009D; Thu,  9 Apr 2026 10:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833DC6B009E; Thu,  9 Apr 2026 10:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7492A6B009F; Thu,  9 Apr 2026 10:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57FCC6B009D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0201314071E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:04 +0000 (UTC)
X-FDA: 84639231810.22.9DAC6FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 610C1140002
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DdiA08nz;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QO0HMgZR6Q1HucKxNFx50+mXtq1QtftwQyXEIAQyxA=;
	b=1gFh93IuU13u1fa1VkfZbAVyNI3fh4rP2m81xqkMCcwLqYwb162fSWpHym2X6KgbNufPDG
	RzQ79OzV0Mc9iOQSezgSA+mSFcfOxVkv8n3kRWY+5gj8d7U9WUI2K3CdDjNaSdf/BiWty3
	xOyXH4VOvobFDBIKEzkL3EGVVc/WVD4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DdiA08nz;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744523; a=rsa-sha256;
	cv=none;
	b=dTpzdnpbO765KYHu6Ce3ajDrceqQdfBsMw6GPFhMVgSiAPiddsDolynfq0bC+aGW7oWfRx
	ip2RuiMqWSD9puaRXysfRtIevmgvde1MX8FFfPOo5Y8NGYmWGlqkQmupqhTu/qYDPtwE3M
	yr4d4AqvkS1T29atB+M8ac4uRTGcriQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0C6760133
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D0AC2BCB1;
	Thu,  9 Apr 2026 14:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744522;
	bh=6J24o91UAsIJGEgFo2jYtnFEeYvJuiRUU82+7XJIPqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdiA08nzY42W5gcsPSMmrHmqg2Bmqq7dj8BUACOLHrnk6Kn0JuA+Ia3qL5/Jq8oDl
	 qJWRVf8VpFZr72rvs8jL9ylsiOx+kIvhPfMFllxLYCXRmEp8GSmKB8Lg8T2l335XHm
	 5UdTqOUm8Q25h/ErEiJC7XOQ+6Fv7Lvg1fzsvf/NcUSINQxhbEyya1A9LxCUtjsEhK
	 7i/eVA+ESe+DHqiopwO4nnOdnqBmPXAfsKAe1US1P92EmZJNoycW+fBNRhwXOuEwIF
	 GSanZCI4Ux/10Ecf0eKSk3iGO1ZT+pV4DaV91rh0WKaPRvnQAFdCZjKX+77UL5lKkX
	 /PdNjYpxW1rmQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 11/11] selftests/damon/sysfs.py: test failed region quota charge ratio
Date: Thu,  9 Apr 2026 07:21:46 -0700
Message-ID: <20260409142148.60652-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 610C1140002
X-Stat-Signature: 8eur1acm95sfqx1ngiymcj5b9ty8p8xc
X-Rspamd-Server: rspam06
X-HE-Tag: 1775744523-326507
X-HE-Meta: U2FsdGVkX1+7nzBhFzg4GeEH56vhKOp5TV8ZH/0PByKoXu36+lBuFqDhLXAZ5bWqduD6J6f/dxcSRfmiMGbDW47hnJKId7gfpsM2dFzf1oU/QeHjHcZJQYVj/pIL7vcXiOuXnATY5t7r2H6j1/9S3xhchI3kkLMfS5rPbundbRx8+g3Zvoh3TcxxcPJ7/kFXUplvnoyBcgIjLlLFGfZb/MkOPo9rX657JsT/RI1XKvTgoHL/8APv1eybd3RsJsXwyPjlGwu/B4KN4ifnI5EQaULgI8LggBIqb8NhEVyQKGi1K2KkH+/iF/msfEeYw/LvLV3BwFJVt2JB8NViVtygyR30uPqzpJBKkzTdkk5tj4uSzsCS2fsrBzEp/kTxalKmpaaTXuBHAz+91T8SUJEDvCV6tEOGaVhGXZItL6gCZGV6GTx78WmDP389ucfIceu0lpaeZmDSxfn7LzfVHd4vk/H3FXkZNiMCAGnZKGqoJdtyUg2SB6FbI02Q2BC9GYYQ0rcEpQL5rNtQYuh0pR/xFRlFMHWLFoc67iyhK/ka+ue+Aj/Ipsg8/XGBwC3Z5hgBR8D2sDIJGfhJkRkR1J8kbPz/K1sspxyYzfNnHU0CxOdW2fM/kB09Ak0RgrRi08BAlTvAec6yUntPr+It/7UgwCNyVHY+yPR01X/ZO7fZQHdAEVf4RNnZFfnZ5TKWvfVPHkIcsBLT/RU8RzSSwXZFcR8baJWb6DhB+PwExhCL7i6wN4zcv8jwcOon2W623qu3a4d1y6sq5g7K6MF+5hXc1CeYe7fS70U2SQSrOQqmCnYWsJ95+iiyw6D+Zqdi1RBXSF//OkRGKWNK38SZhAhcPP96heye40Ft81jVhFkX6Scpb/xdNIfSDmkwc/7HfsVugA6vD9I9EauXlISXEvenaqfnB1MUCR6qMMuSvLz+myfl52okyYtkx9GsBm3A0uYkMYcSN4VUr8pwmhkqJvK
 jNJYwxup
 +XF9fuxaNlxMpa0seXgj9RwafLLlx5fhSqhQ5zmGL/TvaKEO2CMYpS27vacmSxlVsPRZEM/RCzV7/P6v9iDKaSzexE4lOyXbMc6NsYjjOhGcEM0AN6hpLA3n30HzGJA5jaPYyCvbh17tRTyUxNMZSZpXEj4+8sG2KqDnR6YBmoNV9cp6dQ5NA8CAOG+mQsfUiP9cpHvfgU/VaTxU9646tLoAUtwPYpIlRV341Fafpkz44OdoC5K47rMDfBlp/Ylaxqp9Z6nOdCQHHJsvDwagnS+FQMtLeDhbetpRKWyWQS2LUI1Y=
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


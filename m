Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B1CCD5BB8
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438756B00B6; Fri, 22 May 2026 11:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E8486B00B8; Fri, 22 May 2026 11:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B1836B00B6; Fri, 22 May 2026 11:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C07C6B00B6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9A1F407CD
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:40 +0000 (UTC)
X-FDA: 84795468240.26.EB5BCDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4A03B14000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TVwqsxAI;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEjjWBHpUcq7nMlrb1+WzxDoNOgxUnUZ3YjegNS7FQU=;
	b=5aNqEtrNmUPQuRmd2C6l4jni7KfPkY6jt6T8tDMiNkNiS5VhcrcD86y0LIqhe2oclX6Ti+
	O4zgPpHEgTBqRDA8YoEWE2wG+/qEAG41ZoP4gupFHV4RoL7FBy8LyKfYd0MzUzRHPfHOEZ
	EpkOipV/YlMK6FV1GyMIEaxaXxIvy1w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TVwqsxAI;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464439; a=rsa-sha256;
	cv=none;
	b=HaGb8WqgzVl6pADuEJM876pYOprdtbJ2f4tPLBo4grcFyVLIxtIKNGdMiZyZIRESVlfry1
	vHDIRxSMhcs6FBb97Da+is55M7ib2GVQMvl3RuXIEkUsKwvA7pjUCQTurCFmwLOm01w11v
	sg9O+bfV3AUK9MTb7Slcmc4Xp6n67Tw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9ABD60172;
	Fri, 22 May 2026 15:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559E71F00A3E;
	Fri, 22 May 2026 15:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464438;
	bh=iEjjWBHpUcq7nMlrb1+WzxDoNOgxUnUZ3YjegNS7FQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVwqsxAI4/lGot8Xjb2P/G3c9J9Sx3LWGIwYxVqK0iN46+14cuXahZPlKbf4vzFKj
	 SODgre67n8HKv7rlkp/4p5c9NLvTgo2Il+k40IDDUho0sYSVZVCoQojDCljAZRve3f
	 07NaH7dNJxSV2jLhaHrzDqJMp2s/VFnqf8F5eH2LtZmp+fZQvtNPKSW4R8c9pv2zlg
	 86EE7ssiA/FF852zflSN3lS2worR9rs7wNsoHjPIGNRGUCgUuv57XiySpyzkN15caw
	 cCCwOs8ivYUj3w+FO2xWmg8XWTNuWocMUZW9Unf3CAwETj32hXz6u21o7xFuu08B4K
	 ycfGKnpwqEHLg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/14] selftests/damon/sysfs.py: stop kdamonds before failing
Date: Fri, 22 May 2026 08:40:22 -0700
Message-ID: <20260522154026.80546-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A03B14000B
X-Stat-Signature: 8a3bzies9qgj63iwdo9sqw9ihrjbgusu
X-HE-Tag: 1779464439-781163
X-HE-Meta: U2FsdGVkX19eOWth9A3yBMWIpH7gXtq6+zoW6f7j1D52zss7mCJJCXk4oG0qU6syL2XBehEbCPvx07d4yUK1fqd/PXYa/b6XcXWGaCzahT3V/r1qr0M5NJRGbcm9Q4JHPAWtSmKZITXdhLCo8Uj5idtTMM4dJNuJatZ0b8BfzWmYS69cGyRx5/i/UjKljYupD9B6xmQVmhFoIAIeGZmJuNDygo6Q0xr6/wVjwCbp4oHd1NfGj71xgc4WtDzmG0JA30IsDOTq7mq/oNXiXZe1u13ezGkXGfU3fU2H8kmtyVNwG6ZatcniHeijdeGQCmcDW70S6b0gAsKbKNy0Fqm4OXnb1eg8XAjyrC+Hu8fKWABRFXzvBMyVQp3upF3e34600un+6RtoYcKwIQCj9CstI+xFb0xMYJleygaUGaZkKCV1AgRi27QnEEOSiWAQIRACHfDbZVnqWWot2TdEIFl1qLqGlLeJaH5GRaThbO3sfaatXSBLyDOb5F63lxZa3yhntNA9cUvHXGgVwHQ/rd9JbY1lBAJigYSoqiTdibHq3tqbqSofZ4HfOKSNfH4PO8PWUufWP3GJn9TF5nm5MWCc/u9LpDe2fuHZqiN6pB71vQrHln2rwbB4QI3pVsxu5PSGJstWbtlXQBpxBr1Ulwl52/vo+dZActj0W6bUo3f1WFcZJVkA8pNyF5W7FOOeXDWikng+wQyr28G/A3vd79+6aEEd6LISFupfbFxMxF3bTjYnSbdkV/PMBNP/vnwJH9zo0zSlIip+JPYWEgmGtYIQN/4Y+XBHgC42+M1859V70snuKGj6az26ckGsy9kzFgsr8QcNUOmqi9543vYDTDqwSplxKcN1LHrSKcWMiBQjFIe/5R4ogu0Wzv1H0Ichhon0mx9znp28PmXt0oIRwo5Ip+Sa8DBktQ6637nbwPujeEL3uq9Bcw+alk3MN5OIc0Vq00+Wu3M3jOiRguPRhYA
 Ouw8+wCI
 IFUc2kj3LLr//bvmKK8p3Z1kFQXtboGd1+DT6kmSDE7TUfhlXRv+O1cwe0d2lHxOVaJmNln9OQiY90UuBYHxOZbIj6wyWxXZIp/rLw+SxM+8bMcxZuDnwNRkhtv8sUSN/0jYHyJV+0GhiA/ZUwYxNBhSEu+c4NjId7vyb4VlUZMzd5Dao/6k/G1PxaKFpXctelE4Yuj7akKFOCPzIuKlJlNyK5CyJVd7wo/i626ULQ6Lcn1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an assertion is failed, sysfs.py DAMON selftest immediately exits
the test program leaving the DAMON running behind.  Many of the
following tests need to start DAMON on their own.  But because DAMON
that was started by sysfs.py is still running, those start attempts
fail, and the tests are failed or skipped.  Update sysfs.py to stop
DAMON before exiting the test program due to the assertion failure.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index cd4d82c852113..aa03a1187489f 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -24,9 +24,12 @@ def dump_damon_status_dict(pid):
     except Exception as e:
         return None, 'json.load fail (%s)' % e
 
+kdamonds = None
 def fail(expectation, status):
     print('unexpected %s' % expectation)
     print(json.dumps(status, indent=4))
+    if kdamonds is not None:
+        kdamonds.stop()
     exit(1)
 
 def assert_true(condition, expectation, status):
@@ -248,6 +251,7 @@ def assert_ctxs_committed(kdamonds):
                 ctx.pause = False
 
 def main():
+    global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
                 contexts=[_damon_sysfs.DamonCtx(
-- 
2.47.3


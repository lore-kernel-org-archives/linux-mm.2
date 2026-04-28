Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4292FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF6A86B0099; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCFD16B009B; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20546B009E; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7036B0099
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6ADA11C05D5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:36 +0000 (UTC)
X-FDA: 84706244952.05.82DD633
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C39B51A0006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZZcZnAsu;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sVcF7zaH37u0tWHP3HtY1xH4X9u8i3KYqKvRqlaJEQ=;
	b=hO1PgHBluQKZEC+jnLvFMtv2SHjOd6JzJF6YAgUIqhpM383oohJnb8GDEczzYIyXvRRcOS
	5zGBUFdf9YifAc+M1ngZRRp8GsL+7DoEs99cj9hXsfdLz8PFxEkik8fZLx1csnFpozkqhr
	ne5Vp26MTh1M6crW0tRLqAWWn1q2Kh8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZZcZnAsu;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340074; a=rsa-sha256;
	cv=none;
	b=Ej8ldeKezrTMeh1t/XU0tJVyp86KRyPNIrdJPdOaZAuToDCPtlnDcTnyNXoM+ColURaMV2
	/GvDxvuzRIoNex2Lof6QmR3YtSjuZtt0bkN5pEupQbIpnJJL2atokfHj+7BAj6JuQW+xXX
	27Ho5BDapcbrsbapcfLv4PfrKksbaf8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 41DE460133;
	Tue, 28 Apr 2026 01:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE91AC2BCB8;
	Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340074;
	bh=EIRB4p0R7OQMpXCAySjtmt5LRqO984ojhpZfxIiXyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZcZnAsupewrX89PIOmNdOhVn2+tqOay0z0k+NxczHczuwJXZkL1AoRFErP2NRR3h
	 ZVngppoziqRmwTzbPeXG+Zmk93VHdDtxyJ8G0vaH3qhGJDnJQUtEt9EtWYuQjNjWcE
	 R/89iG/BQ8mgkA6w9BoppTli74ZSzaOxvHkijdpIu2sC+ke0TAC76jO5/2lUkMHaKd
	 wHlMBrceCK98vgBAqlonoYeX8uB7gcACQhDvCW7U+ptOijpxvZrqqtKZYtSA94GgPd
	 GbQfpJRI8KMS1lRa/r4ZWKyX4BPpWQpFOst0Sm0HrwF33He1ci2rnEzcqzG/QG2W7k
	 IPXfPt7l45kkw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/11] selftests/damon/_damon_sysfs: support failed region quota charge ratio
Date: Mon, 27 Apr 2026 18:33:58 -0700
Message-ID: <20260428013402.115171-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C39B51A0006
X-Stat-Signature: repbdhg7i3bscptksw77katadooysyf7
X-HE-Tag: 1777340074-964756
X-HE-Meta: U2FsdGVkX19RhRccr0iwzr2Czwv31pRqeDj8Cz3HrdktzUO9WH3wLPtvcOVqfEp9rF3FrnsvS/2/EhJzoeTds6YmaKQ73lXIWWMrbY3+2XMB5imx4nN9J9vDx7c+S3+xFVESSbWfVGPKnpZNzPzIekJ0MDAgGZXOBQ+kHLzMrDdLWEfxjwtayH/QyukLGj5I8DCQRMpLIUAcnE+nc4ffcNDoU+m9f8aqJRirOeXGZj337PjGKxXIHBDCtgLRJ1vcZDaXsOggtZgFyPaZKe68gNFdvMfHkWm2sinGBYDUrMVKk9yfC1NqgbJ55P0cisg/xMIlOV11j5wnhQP43KOPBhaqftQmGOGoB6NL5v+7HW/kmrI2POGlNqjsDULj8ovcGpkkhEDMG/G/BGxAs05uV9K8/NOcuLWuO2XmV0yJ5UiNOeZqMA/w9zfYpjGqoZsIAiWqaEW+VdV/oe21xBfC/CNODcLfFfkLiauueqSXPEXXyyHqUbFjp2qkD/LTyNvsYsDO4dJYcRCP4VJzC9GwACmyKAiGO/khhj05bu6Nj7J24I+Y4oyCtIqpb875ZamDJahLOWtz1eCXJDFgqABoM3orwmf8hizrXgv4GajJ34qo1U/JgsCP1q4+tJyfg4nkXyC1FeV4O6P3hFHOYcFOp2yb74EXdNUf+SNdWvifnZVp66qZ0UdvdJSioOtGSUHUl9/9J/SG1/qdGqKwi04g9NYG5mSPRqDAtIHo9ExTxWLQQ7ARgr7dfoHlMbv1CgRpUcnDb1jNG3z7961hluy0BV71S2DEMsX/BkNapRUztudVDfHhrVm8gXGdzGti5WjFir8hvypCfPJ95bIg0WA+jn4s18J5pPijG0JaHnZWA4Se1UAt6i1dI0ADhfEnKmC2c3i1dZeLuuSb4sG5YnqjQYe5wnZCDKAnNMVh96K7KrGR4HGLJM85bpgLo4Db8InXlPwAaTcIay0033EEQ+W
 nUhyN+yX
 2km0KBPHwpxH7sUHDajIbi0mR2GAVNoDc9RbZbAGd7nYH4m5xL7mNgvY94CV0vFszN2XKZ6kEqe6OA2bPmHeqjZF96YkeVtU5PRYmdmS/p9XgAu9Pusefs5LSwz1gLfoQaeYRjTBalBHiYacYLtlHGEnmugqy2ZvDKgpnZt9eWO/NevIm+EXnglPuYn/+86whT9nuJs1/G/Ke4k9xXMiqzLrUdtWalYgjniiLlC7K+n6+DIgQRoUNLMfdAm1EIstckwEXkEqbLykfOMBtZl18HZ5BFvCVjfDkKlV5LoPltqUFb7S3aWFNikBs5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend _damon_sysfs.py for DAMOS action failed regions quota charge
ratio setup, so that we can add kselftest for the new feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 120b96ecbd741..8b12cc0484405 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -132,14 +132,17 @@ class DamosQuota:
     goals = None                # quota goals
     goal_tuner = None           # quota goal tuner
     reset_interval_ms = None    # quota reset interval
+    fail_charge_num = None
+    fail_charge_denom = None
     weight_sz_permil = None
     weight_nr_accesses_permil = None
     weight_age_permil = None
     scheme = None               # owner scheme
 
     def __init__(self, sz=0, ms=0, goals=None, goal_tuner='consist',
-                 reset_interval_ms=0, weight_sz_permil=0,
-                 weight_nr_accesses_permil=0, weight_age_permil=0):
+                 reset_interval_ms=0, fail_charge_num=0, fail_charge_denom=0,
+                 weight_sz_permil=0, weight_nr_accesses_permil=0,
+                 weight_age_permil=0):
         self.sz = sz
         self.ms = ms
         self.reset_interval_ms = reset_interval_ms
@@ -151,6 +154,8 @@ class DamosQuota:
         for idx, goal in enumerate(self.goals):
             goal.idx = idx
             goal.quota = self
+        self.fail_charge_num = fail_charge_num
+        self.fail_charge_denom = fail_charge_denom
 
     def sysfs_dir(self):
         return os.path.join(self.scheme.sysfs_dir(), 'quotas')
@@ -197,6 +202,18 @@ class DamosQuota:
                 os.path.join(self.sysfs_dir(), 'goal_tuner'), self.goal_tuner)
         if err is not None:
             return err
+
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'fail_charge_num'),
+                self.fail_charge_num)
+        if err is not None:
+            return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'fail_charge_denom'),
+                self.fail_charge_denom)
+        if err is not None:
+            return err
+
         return None
 
 class DamosWatermarks:
-- 
2.47.3


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B4B8E9D805
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E366B00A5; Sun,  5 Apr 2026 11:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C3E6B00A7; Sun,  5 Apr 2026 11:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7006B00A7; Sun,  5 Apr 2026 11:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E14296B00A5
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 965591A0BE8
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:42 +0000 (UTC)
X-FDA: 84624844164.05.B530C0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1680C0007
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBd1tRlR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sVcF7zaH37u0tWHP3HtY1xH4X9u8i3KYqKvRqlaJEQ=;
	b=ra0tJ7i9dcqRXe9Zw2PBdzmQpmaUzIR2plQxoQ1GJv6/58BNyUxXwlsT2mOKIlwZPRGvff
	Knc0IUs9bE/8h1ckDcmwIZvUyDZlCyE2ujd6sB/szVh18VpRNYhrJWO+UQELgSUj/ui+A6
	MW5glof76UaB+05W0CpJlfwpJqytG/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401961; a=rsa-sha256;
	cv=none;
	b=QenhN8UchlFn5Dv87ma7R0XMgTPSD9BoYKBB6er+/pzTEkOlzfVXOyNP1gz4qt2Ft3YYIs
	DsqZoh6Lr7T+XPdsy4VQxKn4vUrtN2Ktyjo6yoZ3avWlt450mMRd34oV9U1Osl5DRlhdLK
	Dn2QRuvExEZ/+ighP7cYyX23or55gbQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TBd1tRlR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F33B44553
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6419C2BCB0;
	Sun,  5 Apr 2026 15:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401960;
	bh=EIRB4p0R7OQMpXCAySjtmt5LRqO984ojhpZfxIiXyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TBd1tRlRVlUqZHJkb40DOR3rwB5ijHVT51HL8st3yLtEpNxnDr+V5LAgnRMS1h9tc
	 bht0kR/NS2eydwDBc5GlVomCWgRW794wKrHKjCJu0XsfbpaL3D73rhO70ToMAL3vuE
	 avJZQ6i1ArYdQ/FPNjN1ZgO5LVoSGSaDyLJb8P0OSecsfu8p6JPlbg8OFi5Ok+SdXR
	 n+HpS2It8SRcWONBGR0ta44BtwsPw6LVWt+Np+OWz0d1uLG2PpIOfpamR88LKOU7wm
	 wziYjYnsnItV8m9AGxYcLVk33LIIOfM8wK2P/4wXK0f0gqm+OA7SceMsuBaWIv9OT2
	 NHzZqGLhifP8A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 7/9] selftets/damon/_damon_sysfs: support failed region quota charge ratio
Date: Sun,  5 Apr 2026 08:12:25 -0700
Message-ID: <20260405151232.102690-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-1-sj@kernel.org>
References: <20260405151232.102690-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1680C0007
X-Stat-Signature: t6fy1aagqawedmmnt8xa1crc7krdw1c4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775401960-783273
X-HE-Meta: U2FsdGVkX19ltVwXFQ606kOp7kYbYjfgoVP96N4uz8hk4GjFIeAWn/bIRjjuLdeQ6TZJ1/PosCHMt/3Hmc4s5Gmtm8nOkb0yL0MSsc7iZ9qNVEU3uCFGQVf/6xmxx581RAUn015WAF5cTW1XocSoxb/+M2PNdxJ9p6o6TV5ie/sZVYEtjEvaqnl+MWZ4J/Cu5e1u48e6SAsSieNa6HsVUHIIeNH8bfUEp1buQ4/rYd8vU3Fg36CalbNasxegTdaTeg1HKnT90A3MS8oKBhd49KSVShxIJVVshfeqKmouN82zfESPddU/BAyfOD0m7FHXMtCtZrsmUpEI8JnDkXNdBGTv9fHRKSJshKGas9AUKNXN8M5SXDB0pDFF+iIzFTLzXTEpjXirkzeFQdom6TFgAzcUdfLH43ksBmI2AEGvnkoryB15ng7G19BZ+ww2Pm/vVTaeKHwdGRFbV1miMYAu6yYNeb66t2xGfkoupZYf+PEIoLYaObQ/Ub4EtK9QeYF614AJ6WZgeKG9TWck6HoUVCaT+F2Ba97en2Zkx2mPAe2To7gAxPyVubyPC4cjdeF442AdLL4Cx4jk4nO3PrLbbRb0+GYFVq98OeIAS3ZsyR8QApYCw6///THIU4P6KRVIbdOaFS9/uhtyriclNdLw/Ne9Mz7doIUGzpzIipRXZ32ZMYajd7LJRwmRzkDOzL9/TtL+1AEdopPq2QyZOhPi9C2UpciguxlQh9WEVatm5TI0UQIVs3YqOrjsEhj3sf1dWDNR5dLPc6w1/op96T6EOwCpEsddU4c1l256dxbnsI0Z9CN6dY7Uc6TZqCzH0HicSUsGyS8QHD5sKCs5L+ZBAiEBcjenqH5f39xGJUHychBv9Rf8HLKN9+gs4b6t/zVjdcW5uCEkT/wRh1qqRz24FoAD5OoRHk2EOTuDwjaAvsCElf3plFScemU/HIdjuZX+Z9adzKW96oJtqZrQyrO
 neTS/3E4
 OJHpTgRr3B3OzrWlqjE+YJ+SNfAiRoEDYOVxv8xWLckfj7EMANDoviEw7uyVbcEwk9o6ffRsU0vfrgaUfUVMxBebgteMEG29Pjtci9NQMnQmab/mxlvf96UTP1KWFJyVLED0b2LWNOqj6PJ/Yca8ZKxMw3OdRCJ9AWBJXsfPMeLHE6T4v/T3hi+OsR0EdlYP2T+l70L0HbCipFPyvuGtgkBFhu+eupwjbNqoo2r+r5pKSk/0tBxWOD2At7i8vQqlhif8GnlE+UPTT0x9LVUlHAJmFYZAJtMgcYtpcPvSsucNR7ZM80juNzxDsv2mzYLQL6fbqmUwaYk7W4MjHOnyoJyKWJgX/4IutiJQZfMxipqqLZPUtY6sgwg1IDQ==
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


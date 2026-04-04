Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 087E0E63FE3
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 16:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3731A6B0099; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D8B6B0098; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F396B009B; Sat,  4 Apr 2026 12:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7D856B0096
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8EF9D59F16
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:59 +0000 (UTC)
X-FDA: 84621435318.18.CFB785A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DF4CBA000C
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i6Vubvum;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775320798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sVcF7zaH37u0tWHP3HtY1xH4X9u8i3KYqKvRqlaJEQ=;
	b=X3+1Z6hvvdd9ymwrbJFkrmKITJivp+CBYEkBZRxy5s+8VRrUK72YeaP7f/2yvCuMkoqGPG
	XIDTU5YNrmlrJ7pJusT3eTqqdETKmfOrB7hSf5jbtTK62GZvKWb9rAKMgEq7MkGoQrNGl+
	h5j0Mtbztx1vBI+fsZ2TFxwlDpjmMRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775320798; a=rsa-sha256;
	cv=none;
	b=A6n60XIC/0aSXOIDaDEUrfUbmbOx5EqhYPCWogVqLeVF+tsKVsTBG9ubebso2sZ8z0J0od
	FKBwjtYfW5LXi8bNh/B1hMhSUVynDEvyB6gUasNNvihi9ICNrWM9+ghEdKhVg5G+4ihv8q
	j6lOPrEl0tR5y9isz3m/PmouYwamXfQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i6Vubvum;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D09B406CB
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52E1C2BCB0;
	Sat,  4 Apr 2026 16:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320797;
	bh=EIRB4p0R7OQMpXCAySjtmt5LRqO984ojhpZfxIiXyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6VubvumcioSchjh+1b19ck1CIzXLp3OIteNf1x5P11TUWwbaPqCHAh7Q4F4ItntZ
	 vKArxr1U2GaVMl5oPmNpkxuaNKFrYDQva9f3nFQeTxwYl+VqobL7e+TBIvwamp2wzi
	 I9E4lQf382pmXXOVvNr/WpqFOa38NYi11cCvgTSE0+OcjwVHygFOHn/dtdGSLv1T3f
	 H67wD5++m0OB9RE+ggR8BWSQ472rISOZHMn51os9FM22LSJCKWn9+s5LZx3+ON9+I8
	 KHIhaebJjzIHMtra/dZVtdYXr2+Jwa7JBWrwlCCJJzKg64bKzA2VNuJHiagOx94IqE
	 +mRMaDzx2TWqA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 7/9] selftets/damon/_damon_sysfs: support failed region quota charge ratio
Date: Sat,  4 Apr 2026 09:39:37 -0700
Message-ID: <20260404163943.89278-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: <20260404163943.89278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: u1ainu416sp79idmb54aajt3j3wqmmic
X-Rspamd-Queue-Id: DF4CBA000C
X-Rspam-User: 
X-HE-Tag: 1775320797-51015
X-HE-Meta: U2FsdGVkX1+tmurEx83T20fxvkpbvOdNEMYD7pFBe8Cn8LCzvSKxrdB4a60D4+neqcLG3dPcLGsBIxWQ6xwE7+ezDORuAtrTWabtjFClNltBD5+QR4ksuAb6Zv/RbVHIyLNBckSmAQOhqnRYA4AO9XGaoHutwjq1Xrr5oQ+w/SOgrTc2gQ97Y9gsGmJmeqwvArouYQBj23kcrEU1/5qCqnHXQMm4xsnrrTuTfNV9fCBrxt2rq1bZXCJyvbpOPtPM4FtseNIGzZ4EZAyJ6hhuROEtvKFdW7bjjV1rer62bDKiqsoizhLZvmmJ0T0hT/+UbE6ZUilr67KF12Qx4tNiHrEi3JIiBFlcnNWvrrQZ+xZwGYppRkZYo4Srn00yr0BBc4Ba4tLy+reeuiotA5hOszDSDWjuNp93t7oU4eTKE/G9NvsmQYbmPeNA8h7G4LgYnFP3IO36QxSPoGA64ocmiDfeTiGJuUw3Ky+Ysjhh8W7XnAjfGBclMPGanaRFoXV1IfTs+OM2CLxWFHf1DLbipQUyYitDMkyuXPjo6eRk3AtG5N4oSkMmw6kdPo8V+MJcSDpUBdsEuSJo+lSSjRtlt91ogsTSzTnRtJvCwJhzvjjtX9l/MTzs3cGAOiX4o6XDCEOfVDswC0mDf9HwV8RWbtnbyXtw8//lShAumxCjPw9yghuP0xBQLS+EU8b+HN5Ze8PLUTzxKx0+dacEAbZGho2upMq+9PXVh4xwTG58tuIugxcAsb28LnaLV4sYeGdq5eHQGG+fdEsk/BnZvWPbnw/FMhomkDaWQSzoaP/vJh7sdP/bMg/BMFpYc4W6gnA2TbU5zS65zfy3gP79eEuvAxlE0bGDLZ0csRpHU8aaJnV47MdKndLKuO80318yNxbO3WCqIP+K4tWn6puheucFeGX9Y1yFsUX4X8hyMP5I+8zWyOvtASywVua3Jye1DvohE6w5CcQB2FMxstSMrR4
 XfITyV0c
 /fKL+LkOffrAkV+hg+HPGCnTOwu5KyoPMrRtx64YJAaYx2rX3lLNDYB/ECMAJ8bKnfIRkE9GlWsihLmwLGywrPS8hcbvX9NY654watTS4Qj/QqrEggx53dVUsoO3+EFfoe1LS1i7W/1bR7KlTfMPLRgZf/A+Xj5x5NpiFETHiR0mdPq/k9fuiCPemmU7P9R9WbKDvvBY+NFk16HCnih3zkjlTyO3XjItvx3QGSoLkRJ5uckPcJbcNgsnDFp2Z3rj9oUOQOqqrF54SADBF8U43Urskzr4gSNjb0HsCqVUDXzkGTaJQAaDl/i4cLSnKzPOVRvl3pdCikGB5j+JQFZCXOQekzlf5N1pfbQKZRUCWuIPSs2IVVvJdUa4sFw==
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


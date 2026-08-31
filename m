Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92018C624CE
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A566B009E; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB516B009F; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF15A6B00A0; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB7E56B009F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:26:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 451E8A013F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:28 +0000 (UTC)
X-FDA: 85161790056.03.C67C8DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 99BE3180007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Em2drk/8";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186386;
	b=ytEbdEbisB0KqyG1QShJGFmYb6LFSfwKEP/7PaaADLpsW1WN0Os19wR+CPppCZsAFTTtr8
	DJDOTAwjtIrIJbU4HPpBw3yjN8xsC23JyZiyTtZy6Njg5Muv+cMfKwQ/NssSJ6LzJIWAEN
	31xs8J0Cj1p2s8JJt0J2gURrIqHCH24=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Em2drk/8";
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Epq3PwHO3KDR58/nXH75JqepBtDLOvPb3QexcmNVybw=;
	b=HtX4SOdHAOzio5T1O/Q09O7G0dznvuUHq/6H8ZG2OY2tPd7xUz4wwPXpsVrzyYZI1JhKLf
	YpluTOney5DH3aNeU3kR8kNEnzKYSMdfRMzQ5OCCq13H9Q+65ypDejdw+xPY4jMdNrivHm
	orMu5+XfyZz5TI08h6ExArOwn3Nkxwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B6C26013A;
	Mon, 31 Aug 2026 14:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A971F00A3D;
	Mon, 31 Aug 2026 14:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788186385;
	bh=Epq3PwHO3KDR58/nXH75JqepBtDLOvPb3QexcmNVybw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Em2drk/829piatKSrCV3QA5FNzUpmoDNkTJymkFxgZCGghcuOO8KN+vmmpxqLBMRB
	 KHQijKDcHukKBQsj4bnDryymd+yQNAjM4XHoL1Qkn7BJFbclE9sljIWB+xz4VYhWf+
	 dFthQ2P7kG+wW+m0cde2PlPDCwbiU6UlRwcPyNBXFo7jrJp7Jk3QzpE5ldqM1NyT+b
	 HhNTI3nT9KJXzIdAfAEjZApxZDqtEXSBcFtH7VLnVRrdXz2aHy7QaMWARDcc82Dssb
	 Q2Uo7yKo54EqjjGyxkAliod+fxNcUI88HA0LxZO8eZ0RUqyH5BPoXG8t1gFsovLP56
	 c+92RHPWXh3SQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/7] selftests/damon: prevent remaining cross-object state pollution
Date: Mon, 31 Aug 2026 07:26:08 -0700
Message-ID: <20260831142611.77572-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831142611.77572-1-sj@kernel.org>
References: <20260831142611.77572-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: e3atmkp1kmjz1ohkz8otst57su3jq1r8
X-Rspamd-Queue-Id: 99BE3180007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788186386-608146
X-HE-Meta: U2FsdGVkX19k9+hq8bkkQhMbADcT08a/dSKZ35+M7HPKYwS4wVekWQO8bLK645vWK2AQZpU4uIHbaLnav9hwuNTpPcUIqpXnvNQ+xPwl6/49p8nqzxzBMx0meCjjEIilbhW+ZP3igNyo7WXONEqPBQ4vtBtDVlxzvx3d8D0qHY91BsgVL0+XxNlVR4ctodV+6KFhLGQbfLzEuylBEtwIcDpfI8plnixD4ue6Op5UXrnWUNnV6fWSRvuHniFIyiL9kFeecdBRsWz2hzEzI7kOoqm8nn5R78wUGfJP2ucF8t2gpIun8utkr6fVww7U+AUXm4P1Rvi7H68XXusoO0BF9Z3RnRrB2C49ZKTPMXSIB33Xljm8eJHfVmphw8MkQhCJ2d+CXVxltSBELBBfOFG+3vru+y67qfBhrYsxqfaRDYqmH05CUibp/dqLSp1GyCqnldDK7uA0lEJJxSx+bh1o6Aqy3UsrDPt2bl9AxbnpYGSSwn2I8ougcSiwqB1QWUX2o++YjBinfNmOTY/RjdDWoNnqcykV+khCN3014BGRYGFH5F24N2j5UPlGI9tp+9xHAWkKQTW7GtffVOG85IWtxo8IekptNmZRulygHyurjDNaoKwfUqtL4xqFSaH1LrIDxSv9oK57chUh6Qso5c5yXzkOZxrEeXBubAl+k+THpR6B4iNMaPnVKcOl23dS9aAf73QBQZrKX+m/gDhjiIvvFGLXOYrB/MKCPj7SyXTdyQ32OIvn/pDh9vB/4X30SsCf2tSpZ7WlSBXuICVg4wMa4bjS4GZDPA7sJxaejRyeniiog6yVAd/ZuBicJ91LTekV4og4aLA/s4Ck9xtwOP3GMlHE+eEoo02xB0fJ43nEQ9x5Tl45xNuf7EAVR00OuBmkZoc2DWSQZjosyNvqCAw7/HwVRU6JCGQJI7BbkrQWY1ETIVNRr15XKAT7ZAE0I1ODVfkY8Kwq6PAQqpzxtcJ
 5Txt8wsJ
 v8cmQiYI6KtAbe0IE1KaqmzZZ8+6ehSq3P83D9XcLvuh9S82ceXi/4CuWOK64wBZJTmRwDwKpCJUhuEOQYbTDBsHNepDZdguxX5A33C/5XriKjhibKJ/nQ+1dl8LTotFNHN7OlGpevqVr+TbT32i0dsYRQsw2Bxurw0s2OsUckU/M/sYVLipPkjwB1IUMIsSdttG+stMQWx08/yBSlJ5mPknfinoKaorlUwnN6omP7IYH87gZrqldcRkcSEBPChH11NKaS2+aCe6G5ymzM+vCpp4fGVcEGPEN/plS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>

_damon_sysfs.py defines constructors with mutable default arguments,
including DamosAccessPattern(), DamosQuota(), DamosWatermarks(),
DamosDests(), IntervalsGoal(), and empty lists.

Default arguments are evaluated once at function definition time.
Damos() instances created without explicit arguments therefore share
the same DamosQuota(), and the other default-constructed sub-objects
and lists are shared in the same way.  The sub-objects keep
back-pointers to their owner scheme, so constructing the second Damos()
rebinds the shared quota's scheme pointer to the second object.  An
item appended to one object's default contexts or filters list is also
visible from other default-constructed objects.

The shared state can corrupt test configurations.  DamosQuota.sysfs_dir()
derives the sysfs directory from its scheme pointer, so operating on
the first scheme's default quota may write to the second scheme's
directory.  The wrong values often match the defaults, so tests still
pass, but the behavior depends on object creation order.

Commit 8319dadcbd81 ("selftests/damon: prevent cross-context state
pollution in DamonCtx") fixed the same pattern in DamonCtx only.  Fix
the remaining constructors by defaulting to None and creating fresh
objects or lists inside each constructor.  Explicit arguments keep
their previous behavior.

Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/38E4AAAAEDFCC283+20260827021515.1316838-1-zhaozhengzhuo@uniontech.com
- Collec R-b: from SJ.
- Rebase to latest mm-new.

 tools/testing/selftests/damon/_damon_sysfs.py | 38 ++++++++++++++-----
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index e6a2265d721e8..f604b7d6530b3 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -321,8 +321,10 @@ class DamosFilters:
     filters = None
     scheme = None   # owner scheme
 
-    def __init__(self, name, filters=[]):
+    def __init__(self, name, filters=None):
         self.name = name
+        if filters is None:
+            filters = []
         self.filters = filters
         for idx, filter_ in enumerate(self.filters):
             filter_.idx = idx
@@ -368,7 +370,9 @@ class DamosDests:
     dests = None
     scheme = None   # owner scheme
 
-    def __init__(self, dests=[]):
+    def __init__(self, dests=None):
+        if dests is None:
+            dests = []
         self.dests = dests
         for idx, dest in enumerate(self.dests):
             dest.idx = idx
@@ -426,15 +430,21 @@ class Damos:
     stats = None
     tried_regions = None
 
-    def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
-                 quota=DamosQuota(), watermarks=DamosWatermarks(),
-                 core_filters=[], ops_filters=[], filters=[], target_nid=0,
-                 dests=DamosDests(), apply_interval_us=0):
+    def __init__(self, action='stat', access_pattern=None, quota=None,
+                 watermarks=None, core_filters=None, ops_filters=None,
+                 filters=None, target_nid=0, dests=None,
+                 apply_interval_us=0):
         self.action = action
+        if access_pattern is None:
+            access_pattern = DamosAccessPattern()
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
+        if quota is None:
+            quota = DamosQuota()
         self.quota = quota
         self.quota.scheme = self
+        if watermarks is None:
+            watermarks = DamosWatermarks()
         self.watermarks = watermarks
         self.watermarks.scheme = self
 
@@ -448,6 +458,8 @@ class Damos:
         self.filters.scheme = self
 
         self.target_nid = target_nid
+        if dests is None:
+            dests = DamosDests()
         self.dests = dests
         self.dests.scheme = self
 
@@ -568,10 +580,12 @@ class DamonAttrs:
     context = None
 
     def __init__(self, sample_us=5000, aggr_us=100000,
-                 intervals_goal=IntervalsGoal(), update_us=1000000,
-            min_nr_regions=10, max_nr_regions=1000):
+                 intervals_goal=None, update_us=1000000, min_nr_regions=10,
+                 max_nr_regions=1000):
         self.sample_us = sample_us
         self.aggr_us = aggr_us
+        if intervals_goal is None:
+            intervals_goal = IntervalsGoal()
         self.intervals_goal = intervals_goal
         self.intervals_goal.attrs = self
         self.update_us = update_us
@@ -703,7 +717,9 @@ class Kdamond:
     idx = None      # index of this kdamond between siblings
     kdamonds = None # parent
 
-    def __init__(self, contexts=[], refresh_ms=None):
+    def __init__(self, contexts=None, refresh_ms=None):
+        if contexts is None:
+            contexts = []
         self.contexts = contexts
         self.refresh_ms = refresh_ms
         for idx, context in enumerate(self.contexts):
@@ -853,7 +869,9 @@ class Kdamond:
 class Kdamonds:
     kdamonds = []
 
-    def __init__(self, kdamonds=[]):
+    def __init__(self, kdamonds=None):
+        if kdamonds is None:
+            kdamonds = []
         self.kdamonds = kdamonds
         for idx, kdamond in enumerate(self.kdamonds):
             kdamond.idx = idx
-- 
2.47.3


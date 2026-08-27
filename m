Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E4CC61DBD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 02:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0CA6B008A; Wed, 26 Aug 2026 22:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80AF6B008C; Wed, 26 Aug 2026 22:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6ECD6B0092; Wed, 26 Aug 2026 22:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90BC96B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:16:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 64266802B2
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:16:42 +0000 (UTC)
X-FDA: 85145435844.20.3E23A01
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by imf05.hostedemail.com (Postfix) with ESMTP id 42632100004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:16:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b="kwUrPv/6";
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf05.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787797000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dY0Ane/g6w6slG4WVya3Y1rgTK4uIbhwmWsfZq4NOqM=;
	b=45W5VptMxp4SAH2zTA59TsABp6fZax+PdlbMX26jsF80JvvZwu6hQCx8mP29Q6OiDdMxAy
	05IwitmK2P8A4KIwLp46MdG0Q3bTeClmjQzL1HmUtrJ43cfdmpv/+8IgidNPhcFUijDu3a
	qhqJD1Kq3FlsIdKecPG6KOXLg73qVt4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b="kwUrPv/6";
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf05.hostedemail.com: domain of zhaozhengzhuo@uniontech.com designates 18.194.254.142 as permitted sender) smtp.mailfrom=zhaozhengzhuo@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787797000;
	b=SPIqXbMZaBpEJip25AlOHD5vkgf61logyc6QLDX9N9UncRPAEV0dqivRzP/d1+kRqcdC3F
	VnKfgZ2O7TERpowWikvf2dqIWr038Zj4YvHsMN4A3dJUfQgep19cG996zk08T7fwv/mCcd
	a+IXVl2Zt/3hb2fNuWcDBLf2iioqR1U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1787796950;
	bh=dY0Ane/g6w6slG4WVya3Y1rgTK4uIbhwmWsfZq4NOqM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=kwUrPv/6dRCuB5xGFEV/4IejvozKU13Y5s4J95ScEC2GfBUewQfXO5w2gAy8Em5to
	 qL8wcqdc25w3jSah/HXKQIJuKPpu6uC4pPs+XlLq3UevXGp0HHoKA+8dlHsm2FzGD8
	 LHHTEWSgxfNbvSq0zHerGhQOb0MdHSOO/x5h8nC4=
X-QQ-mid: esmtpgz10t1787796930ta39a6dc6
X-QQ-Originating-IP: Vr/DIm68OfOsFIB+dMR1e+jE5N+2Xsb6EvYj4ckGA8I=
Received: from zzz-PC ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 27 Aug 2026 10:15:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 9858402169651406958
EX-QQ-RecipientCnt: 7
From: zhaozhengzhuo@uniontech.com
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: [PATCH] selftests/damon: prevent remaining cross-object state pollution
Date: Thu, 27 Aug 2026 10:14:52 +0800
Message-ID: <38E4AAAAEDFCC283+20260827021515.1316838-1-zhaozhengzhuo@uniontech.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MGeqoSbHfHK69bPxTAzoCJdhw2kwrmioHHsWR2DTvlVmG1nTExeaCLmY
	yzvlV+n+exkh3TYHz2ABo5dBBN4WQLdVLhEnu1Z/3KY43UCV242r2NDTQ1qqxIgDTUUeZWQ
	Bpt2v4CgEssYMcGLPMX8hm/m2PgRaZgIp9ERA0dLwN50XptZLf98pxJrL8teIvls/2vlDNc
	3qJGeqksIFJlQjb0Qyixhx8ZgI97KuJGS3uTE3BPryw7lORyxvpchEfzpg46voK1PVUrIvc
	cy/k6OdsYFFF5nOZzdAFpDmQgZV0IRTB4lzc5zisWHtJvSI1e9Rm9HF9GhbFa3SnHBIJcCf
	vcN3cIaBzdvLAWI5V3kWocBHzcy3SQvI4IUMQhNTyTUzrtCW6bVHwuUEXHij0C24GdGgW9F
	I4G9CarW9m4jSK2CrM2Y0XfMJkYBo7+BiyiAJ02a6hRC4rdVWsfmQAZGkZSPUEmGtmOzbCY
	KqkEvhGnfn4kehkwuDY6eT749wO2y4wwkdKfO30sGXNEZG1W0Xa1Wx/ecAhkykcHJ1dKqj4
	1Gb83J8AiGtpHhEeYg1fI+STmR7CsOE32KidDWuOag1Sfj+rJ70UtUQEV70jHXRdV2gO0yI
	wFEU6gMBcU0g+UCFt8ocoOQoN3e4D5/YeK+aCD6btwIICqIf5fG3LEUYOd/ofH0R35epA78
	TX+dezv1L+P0T4aykeUrGEcobQqJJkD+yux7LeUduvjrpJTHly9dUfgLvEpVbQDgfg3W4+f
	ZLAxyj1vkD6c7lMpt5akJc7DN7ngtbnPPTgxjBs+KjxHxwSYdwP+H9Chl9iHUvAlWLHNWeM
	Hzp777pdeRNr7Lz8jo6g6e0ttOIK7eNZpDGrlvMmCONmhkrJDopamsWcFozg2Sw87U7X4T9
	8l8Zn5wVacspNlod9pbswn4kZrVhbR5TZfEWjiXXy0i/k2hI4gOyg+uKvbG2cHSJ8+GIRdT
	3jsPkDMd8FG6r/YTkJDfnjTcUGCiSsy90o+fGzldJvFUDKxIn606/xyD3EkWTx4nHcSo9/v
	1PC1GQ9rXFN/ZCRyXx7H7L/xYr/SUNHKuHz6iDs8jbx/DKSqJO01sN4/zFw4M=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: p9nj9aus1xcuoykwkowaa579sft83y6b
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 42632100004
X-Rspam-User: 
X-HE-Tag: 1787796998-933842
X-HE-Meta: U2FsdGVkX1+0yrL9l54Su6pcfxWAXpbA8HF1831qtOyXdYlTfe0cwFCWXYWqAjdgJa6A03Q1ArSEgFJnQ4BDdoQshg3sErtqb0VPSbAliDmRf2XMUPWkl91RmCmczS4YrxvWfWt81oWFcHcNONW89Vr8q4ojK04Cno4qWFoQ13zLBA5fM/l94tqngAuusmObmn8EJKF+g7r53v6d6GwAtHd0eUvW20fXNNlu2kC/ikxKRabXpLaDn1V9hWT46AFyD2p5sNghhmc7IippSLPFbkPm98psorKuUj2k12ZxSLkChE8ErTe4YqKgdSYN4BYGAdBZhPYM0yUxnFEEy00u/UPjmANSIvTNT/k9Q3l6SmRvVrKy1rftJv47LCxxeA9MhFz1gGY9jfQttw2f1RJpY5fC+l50cdvO4Dw1CJ6tMs4d7M3nPetN/pvgCOl0vFYTlVSiYpLnvH9Z919qQG1F0BI/qssgoPcnyjoSb4q3Bs1dvcpVnFQjbyGmv3L01LJCa4w2a41/o+8EKt4wsAQ2WZZLVKfOLFQpaB9oUgxTIxbkSZqVWbOw4lTJRiLrxggJmyT59FbMidRgCwUT+3WQqZdBDX+N7pVIh1CdlIWdcSAt15s6Qp6dg2yHzEIYKNIJzbQz8K5bvIFWGnCEEMr5tOP55P1XgetzzEUd57Fg9cVWNYiH3vE9Dtkh3V7OCM53bEkS3XlBJdpucGEEERzedyy+txIRhI/SrQ60weU7oIYcRn0relXXeGPm/BgpWcoPOE12XxlhJL8su1Cfi47wDlJS9loSMgYdI1Ygc2ZICv/ssPmUUWl3lQZ7n0DJrI5At9mrCcMBE6/J7Mss/nvZoWblegF7Y/HnB37nxW/i3ifcjQqfhpokOceXo+MeMX3dnKfmD2U+hR98ryJUAgBM1zEgL44YTuQVtOJGCQwrN7tKwPH2+6Trr54fiA2jdVgF3kOyliX9b154fn+GyTH
 QezoyI8P
 XaW7ifLxYjv9j77SrG0S2hQdhn+0oPV6H9F+7eBf6s9aRpoIUBOP8X9BuDwMbZls2Ek2s4Y+ybQYQ6RB85AFLTIRW0KxjP1nDZYVIGJvWQtbLNOuIA99yLUPBvzELF146maKXb+9vj75WMsfG39bssbvmFeCmIuvp+yXD2wVKB4GnM6Jgtfx5dQn3XZ5QP8OJlHhYd93V3K23m+rAPnQHz29QByt8Qnim+wczf4bTGj5kQviv3wxtVNfGXdx8gkGKIWwoZsxzgzDwhf1JqyN8TBcRYDECI+ranIG/sCHCX2eVLbbHuPpCVawOxNfU95KMFtMtZBJOpN94Tj2zF11kKLqU/srKScrCVIBW
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
---
 tools/testing/selftests/damon/_damon_sysfs.py | 38 ++++++++++++++-----
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index e6a2265d721e..f604b7d6530b 100644
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
2.50.1



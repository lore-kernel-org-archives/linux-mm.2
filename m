Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B932CC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1F06B00B2; Wed,  2 Sep 2026 10:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6764A6B00B4; Wed,  2 Sep 2026 10:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4DB6B00B5; Wed,  2 Sep 2026 10:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 006FC6B00B2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:03:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63F99140243
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:41 +0000 (UTC)
X-FDA: 85168990242.20.C49A9DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CF38318000A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=idvUACI2;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7E8/+9tPmws87WGovoxRC/oQMT8cFB9YIJxkAr2MhY=;
	b=D7FbCihmb3KkxWt4Pv61c54rA873GLxgeiHAiyI3k7tr6PAuk4Z5l/reRXE/g6x9FRiarR
	X1gjw6u3l4PFMmFlk0Lh6+VAPwiD8JB/jL1WBfkZSnBQNzrVwZTOTfA3r0Vf59elW+CRUT
	LQ3fRIhiREcECVsO7Fq25x+h1QYSWXk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357819;
	b=ccdpwWMQSbCS1epdds5a0xRg5tqjivbDrQ/N9L1LIKr0n3z63z3n7ZUEL39j5Egm69MvLt
	GsF0F+Ys6PjsuyMD20yWUM0A9kbyIGq2/NKZ58POkFw1KkR327r7HJo9KSmfMvpXL/e51/
	dxSPdGjgtsfyE2r6zRwTUrfgAhh056Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=idvUACI2;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FF716020D;
	Wed,  2 Sep 2026 14:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0AF1F00A3F;
	Wed,  2 Sep 2026 14:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788357819;
	bh=d7E8/+9tPmws87WGovoxRC/oQMT8cFB9YIJxkAr2MhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idvUACI26/k1C0XqqOqWLVI4Rmd9LGPJ9tmtyN0+S0BIaSijEBokM8ybeEcPKqkur
	 oSl27LswLlmXfrrdEo3aKSQOYEMks9MGB4DaSFKN76JIynYpO8lHIcbMn0xj9ErOSY
	 xXaJXh6YEohELcOQIRfkca8J5XKHDp6fegGNeTXAaHV1kxDxxQWMMKA7A1jSwyNmIG
	 k69Eg+VgQiPtbYVCcKn3SI0tWaCENb53qOA0UCH/VkUMmZY37Dy6rLnt3dL72B2wFj
	 nYqf/a8IBpk3u9T7GP1AhBBltHkKBNZsz9GwDzHGSvOt8TMYmPZN0EIAq67hua6vCn
	 iIUu3APb6htcw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/6] selftests/damon/_damon_sysfs: implement DamonProbes
Date: Wed,  2 Sep 2026 07:03:09 -0700
Message-ID: <20260902140313.85983-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902140313.85983-1-sj@kernel.org>
References: <20260902140313.85983-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 74p8igqpx6jubf3rsrqdwxcxusbo397b
X-Rspamd-Queue-Id: CF38318000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788357819-925309
X-HE-Meta: U2FsdGVkX182xct/5fNM68UZZewAOH2YG7tNOWOMvyrQ14HZCT+9dtE7X+YjIbuWK4n7j31OX+Sanigfzma1cCqbIsFMHlVuonGG7TMDc80TgK5P4gkyLoGp4IfxNCTCtRo90mW9yIAkwRD6V5ilrK2AUpTrgynryoHwvDo1uHbZ58xBYq4j7MNqiq9HEahCEE+o5b23IaRBeLPr0bjphwfNFVX1TNzDWMoIjjcDbYaQBvpJMG5lEq68iEKEPrwNza1EzYC/4PgvtPsjRXsBKqF350305Qdjk+Dtjwtd4Wu62tHl9c+9g0wUdpJtKGn93WeD4Du+syffPkO8rMw+Tv/5TamaGCMVjFX7Fl/+gJPoP/GqY1W2EaHjsVaF0iFUV0NDmA/JrvxwGFW+NWlUN1UFD6gbp1dGw4ZOCvEU997y5FURkHPw5ij28d+Zn3mqd/5Sv0zhN0bkFzTQ8v49xiq232dNEKYQ4z07+C54jyyZr4z2dPub8mzkjFCq5zkpGpr9HcR9m05BoOBA/h23xkKucbs4cmcygOXrqNLnetMd95ePU4TPF6epBlahlLuubduhCmR4uVChX2vuYCear0YoLtrWcPiIeM+P1ceMUSo9jUmU+M/s3Rco5xu6QgV4mAdkGH2hIzW34CxUjVm/1YhabJHjifCCK2tF5BUSXnLLGV7oSNk75w0BAbyypzzGKiwItk/7Zr8QUZo/3IReEXd/BVQ3xJz2/C6pNxzpBzl1NIyub1FZ2cFPLY7LKqWwRNmAegfdQZzjbpvgoGJyZi5U0hgFoik2H4KpBAe6CRiri2Wv+o7cXoZWct8OrABvtslVZ7yuvzzCWtiy5lIyq32WOGI2kfhqdXX1YuNjhwKMHd633qRanEA9OlgC4xDI7Gbd8rc91xeBxOtqlgsXZsgLsTrd4VpzK0r7S+1ZDMy7RLF5dqzPlcuZo9bcRFOWyQDd7BL0RUMdFxSPoNm
 ze2b78Cx
 DjMisFERBZi5yHBmC1SJkNZWPTmTjwom4MMLz4ih/YEnO56rvWzql5XgTA/yfCJOIz55Na+7Eng1XKIfeTrpVb7N8c2+Q22tcvqLUuebXMjIKAjH7FoKWKGv1cdcm7VFy+AXr5qFz0ge/H1SWse0NQfeWa0YcoCK9a4yBOShcZ3as1nqVxgsTzP3WZ+V9Gi1EMhfO++cGs6ycnJ7ZnEZYfej9VNJ+N5FXR9426J4qnoXReEqyDGzPMc8p6NIMjpMUea2CwxchfWXTxXOmxxJzCMB+GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend _damon_sysfs.py to support staging and committing DAMON probes.
It will be used for setting DAMON probes via sysfs changes for testing
purposes.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 125 +++++++++++++++++-
 1 file changed, 124 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index f604b7d6530b3..e7095c3365245 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -570,6 +570,117 @@ class IntervalsGoal:
             return err
         return None
 
+class DamonFilter:
+    type_ = None
+    matching = None
+    allow = None
+    filters = None
+    path = None
+    idx = None
+
+    def __init__(self, type_='anon', matching=False, allow=False, path=None):
+        self.type_ = type_
+        self.matching = matching
+        self.allow = allow
+        self.path = path
+
+    def sysfs_dir(self):
+        return os.path.join(self.filters.sysfs_dir(), '%d' % self.idx)
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'type'), self.type_)
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'matching'),
+                         'Y' if self.matching else 'N')
+        if err is not None:
+            return err
+        err = write_file(os.path.join(self.sysfs_dir(), 'allow'),
+                         'Y' if self.allow else 'N')
+        if err is not None:
+            return err
+        if self.type_ == 'memcg':
+            err = write_file(os.path.join(self.sysfs_dir(), 'path'), self.path)
+            if err is not None:
+                return err
+        return None
+
+class DamonFilters:
+    filters = None
+    probe = None
+
+    def __init__(self, filters=None):
+        if filters is None:
+            filters = []
+        self.filters = filters
+        for idx, filter in enumerate(self.filters):
+            filter.filters = self
+            filter.idx = idx
+
+    def sysfs_dir(self):
+        return os.path.join(self.probe.sysfs_dir(), 'filters')
+
+    def stage(self):
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'nr_filters'),
+                len(self.filters))
+        if err is not None:
+            return err
+        for filter in self.filters:
+            err = filter.stage()
+            if err is not None:
+                return err
+        return None
+
+class DamonProbe:
+    weight = None
+    filters = None
+    probes = None
+    idx = None
+
+    def __init__(self, weight=0, filters=None):
+        self.weight = weight
+        if filters is None:
+            filters = DamonFilters()
+        self.filters = filters
+        self.filters.probe = self
+
+    def sysfs_dir(self):
+        return os.path.join(self.probes.sysfs_dir(), '%d' % self.idx)
+
+    def stage(self):
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'weight'), '%d' % self.weight)
+        if err is not None:
+            return err
+        return self.filters.stage()
+
+class DamonProbes:
+    probes = None
+    attrs = None
+
+    def __init__(self, probes=None):
+        if probes is None:
+            probes = []
+        self.probes = probes
+        for idx, probe in enumerate(self.probes):
+            probe.probes = self
+            probe.idx = idx
+
+    def sysfs_dir(self):
+        return os.path.join(self.attrs.sysfs_dir(), 'probes')
+
+    def stage(self):
+        err = write_file(os.path.join(self.sysfs_dir(), 'nr_probes'),
+                         len(self.probes))
+        if err is not None:
+            return err
+        for probe in self.probes:
+            err = probe.stage()
+            if err is not None:
+                return err
+        return None
+
 class DamonAttrs:
     sample_us = None
     aggr_us = None
@@ -577,11 +688,12 @@ class DamonAttrs:
     update_us = None
     min_nr_regions = None
     max_nr_regions = None
+    probes = None
     context = None
 
     def __init__(self, sample_us=5000, aggr_us=100000,
                  intervals_goal=None, update_us=1000000, min_nr_regions=10,
-                 max_nr_regions=1000):
+                 max_nr_regions=1000, probes=None):
         self.sample_us = sample_us
         self.aggr_us = aggr_us
         if intervals_goal is None:
@@ -591,6 +703,10 @@ class DamonAttrs:
         self.update_us = update_us
         self.min_nr_regions = min_nr_regions
         self.max_nr_regions = max_nr_regions
+        if probes is None:
+            probes = DamonProbes()
+        self.probes = probes
+        self.probes.attrs = self
 
     def interval_sysfs_dir(self):
         return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs',
@@ -600,6 +716,9 @@ class DamonAttrs:
         return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs',
                 'nr_regions')
 
+    def sysfs_dir(self):
+        return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs')
+
     def stage(self):
         err = write_file(os.path.join(self.interval_sysfs_dir(), 'sample_us'),
                 self.sample_us)
@@ -629,6 +748,10 @@ class DamonAttrs:
         if err is not None:
             return err
 
+        err = self.probes.stage()
+        if err is not None:
+            return err
+
 class DamonCtx:
     ops = None
     monitoring_attrs = None
-- 
2.47.3


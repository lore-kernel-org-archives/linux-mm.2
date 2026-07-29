Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E49AC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC226B010F; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 666F96B0116; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1776B0113; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECE9A6B0111
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69D731406B8
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:46 +0000 (UTC)
X-FDA: 85042093332.23.1FDA8D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D4AAD80012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNHltkMv;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwjQw1xLqzHqBYImUshrguSPjjDssnEjrh3ssNL9R1M=;
	b=7H4gS5KMsfJsU9kJ8f5YthnKVKuobM2kumTx2Hdy1dlk5lfnO98rh14NCzRLmzMDsz4GK4
	P88DdwvLZRY7xL9LLxuegQSlotqAyqtEHcclIDqQCN5N6AwgTixeTF/Qdk9A+B+Xj0fGVI
	tpvzBh9/Doy68jeUHr9++sCF9tpytVQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336464;
	b=2l3RCqs8CLFwR5EEwGqWtZdWB5EFEBcEtg5Ayc9zG5Rvy2Puj7Wtw00jjX+q9qVBbQ08zR
	stilp21dhEjKZTG0GRx0cbnev0H/TNbk/DO+MEJ0LuklLUC87GXFqoExNq8mzLzgqMI1Xj
	iS+TCjNJ11GaTOH6ZRXfrIqpdTjPWiE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UNHltkMv;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D8DD600AB
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0511F00A3A;
	Wed, 29 Jul 2026 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336464;
	bh=mwjQw1xLqzHqBYImUshrguSPjjDssnEjrh3ssNL9R1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNHltkMvmYCby19ALa5wg7iAKSZrOPnDmKLThfiLsot5LVKn3I/V6RJoFxKld+9Q9
	 uzv6bhF1zedlhP1VAhNYFrt6fS1HFXxRXdjYEFRtJMUfc+x4wIZAmDq2UV0b4B8S9D
	 SD+V1ljngrWJ0h9vRtZEwmj423oTf6w6jdy0GY6p5+KIQR2jLDckDWjiFpF8PyD6rk
	 mtDx7q+uMF70kX/6qoy+7qqR0aZsgdrR8HU+Bf/3l9SDpEZgRhLQaRXlCXq749rhmA
	 E1A41s5XuIusM6c3UfQGGLBj0PD3fglGW4UvzhluJ4emmj4VKtVnWz6HNO0N/1DDkq
	 /ioM5AGPNdtaw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/6] selftests/damon/_damon_sysfs: implement DamonProbes
Date: Wed, 29 Jul 2026 07:47:34 -0700
Message-ID: <20260729144738.90895-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729144738.90895-1-sj@kernel.org>
References: <20260729144738.90895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D4AAD80012
X-Stat-Signature: ax5qyyu9khxgu98rdrony9u58muqznyj
X-HE-Tag: 1785336464-107481
X-HE-Meta: U2FsdGVkX1+nTW5esRhsBK3LxhBJnhTlmdopELUnHC1AHbOabiTPl7RzpcZvcPsm91BnLfcVsgxjWyaEbEtRZ3PTSXO9xIpbiN2LAhYKGJDi3cXiE9MuFrocUl+WhNVRBz3R8wKSJFxfJGFgTRTOY5oknHEPzhmLmZ1RB/WyP47KDDW5RDgJSNS7CFQpYYMB6ELIiCnwam/rorv7Y3N27c+JgUFbG2n3n4XADWNdkhN+OlcvWfCqInoqo/uoY+ObgYCrvC6OFopqbM/X9vmsRI5S66GqDeTvY/rseNKzN/YUk8ioPMAgr5yUB0IvAmkJCIBXohLaA55DgPyz3x1wloIRkqjtRV9t2aOpMj6Ba+46B6W+NPafy4arU5KsygnNpxOR/jqVX3iZTkQvDBniy4/ZLiCyIla6TkZBq7zNrEC1wjxESaDjiH0Br+8yyPZEAnNCQDgT/o0TIgGMpwhfX/2eBxp14JZMdlo7aSU8KvKLDRmXgWwgZmq5yNczkYuekcDdcef7o6qWnX5NHm+GRKmZ/b0+ELcINlKl2fGmfqYGjNRVxqCvD0GipyND6WtCrM5h9wkAEqADQIu8l5UfY/lz1YDYl2SDBZhnRKOlm0/27kgLvSICPiATMO+DmS4lnQIxEIdBANRpDECkcr7o0v+t9BC7cG+je2C1792ze6iHbphduFqRo7JKuLykgbdgD65k34dotwxfUatoi4m3Z7sQLqZdT7mVUwA/HrkgzHoHzlKN4Y5PEx7pALl5CVmpUscEsGVTYpbURkEAZ/xq0eqbNsoYCaSVS35V1Bm1oeRrL5UfCs/oanJfoqy2fw2bbHApKHfpjlqVph8X1kJs7vsHfaujCWq3DmfL0ovy7bo6wWcPMi/f+hQGY8+q+sL8jfQskW5BgrPDRFjy7psmBwKf6GhaL/YlgCLQ+U/emKmOn9l+bmCFf1a0th9G/22VEcH6saGPh/Wfpln29wu
 H7BUcor6
 HcXitvrmBf49GrHvmX5F8X5ZEmtW8eJ4GqnVUPFrzt81krqLKfC1ytfedBc1yKENiSlB6mOeiDv1CLK21CEjdfqltytAzXNygoP+C+cpOFrq8Cl42WkHek+BT9+c/4wpJARUMz0VthwSR2L0DuFOFK/bZJI5/KzSDN5SHQKznlsIvLil1RPVtBIoQ76ZlG7YPh04fnNggJT4Ii2W4Oqn0rQXl3UP45L4bWcy1yJKX58x5zJ13+qHY6Q9YxPv5HQJIcgo2+CeMzop+69kz+GtY8o5X3tbQV9+pklknw/dHZGG5iC5ALhA4piE+ou9cwkd2vKqoLR2fStmazuPrsZFBDoxSL8+qwacs7RvY
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
 tools/testing/selftests/damon/_damon_sysfs.py | 123 +++++++++++++++++-
 1 file changed, 122 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index e6a2265d721e8..d6afb5b2f0a4a 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -558,6 +558,115 @@ class IntervalsGoal:
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
@@ -565,11 +674,12 @@ class DamonAttrs:
     update_us = None
     min_nr_regions = None
     max_nr_regions = None
+    probes = None
     context = None
 
     def __init__(self, sample_us=5000, aggr_us=100000,
                  intervals_goal=IntervalsGoal(), update_us=1000000,
-            min_nr_regions=10, max_nr_regions=1000):
+            min_nr_regions=10, max_nr_regions=1000, probes=None):
         self.sample_us = sample_us
         self.aggr_us = aggr_us
         self.intervals_goal = intervals_goal
@@ -577,6 +687,10 @@ class DamonAttrs:
         self.update_us = update_us
         self.min_nr_regions = min_nr_regions
         self.max_nr_regions = max_nr_regions
+        if probes is None:
+            probes = DamonProbes()
+        self.probes = probes
+        self.probes.attrs = self
 
     def interval_sysfs_dir(self):
         return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs',
@@ -586,6 +700,9 @@ class DamonAttrs:
         return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs',
                 'nr_regions')
 
+    def sysfs_dir(self):
+        return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs')
+
     def stage(self):
         err = write_file(os.path.join(self.interval_sysfs_dir(), 'sample_us'),
                 self.sample_us)
@@ -615,6 +732,10 @@ class DamonAttrs:
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


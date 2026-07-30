Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 032E0C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19BC6B0095; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3186B0099; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91776B0098; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 883F96B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:39:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B14A8087B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:59 +0000 (UTC)
X-FDA: 85044190518.01.CD4EC7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6ACB2100005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GXL1Az/A";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785386397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E612hcebZPtgCEe8tZWqJlrTpBQymzp3zJF2Dzwv4b4=;
	b=f+gap815iw3OeAXt7gG83GeqQ7g0lCOGm+JHxw2ukMwRsbIf7uG9gSMbrVxoU+NBNfd0BF
	X7MXYXQrmZiwmydvUMzl80gFKqi6HjV5Nf+ye41Jz8ksx18goy7p0+zeQq49Eq+Z0+sd5t
	GPJ+qbwpgaXRQTpOzBWW9iWfuVRXdgs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785386397;
	b=VFMHblETayH70N3QHv27FrzY2H+JEyqAsIcsyt9BAM9LLqlty21wbAnic+3vrf2Hr5YTdg
	fSM0SwdShUxM69hz8jQMjx6o+X4eRHAOHILlhlJI0k9UjTazdzAW4yzNtGcnrD1ZngWpSk
	t+lnZOMm4MPbhjiOza3nGZii3PvOuYE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GXL1Az/A";
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2FE0438D5
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E4B1F00A3A;
	Thu, 30 Jul 2026 04:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785386396;
	bh=E612hcebZPtgCEe8tZWqJlrTpBQymzp3zJF2Dzwv4b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GXL1Az/A5Qx0porzJ8JKnyZl5ezJjXdePTc02sfmPUlczN2UdOJRhIfYvAP3670jw
	 SOe2sYZ+ReqonspedCwBQ7iCrDBJBF1c+dgDYjYrk4PtcpWpn6L22W71K+Jeud6X0V
	 WKQyZBigJSs7iC5zzpmvLqx/ZCkMebD4sTLKP6HccuMej5JB7HNBmpD1kqXGo2JxR7
	 2QF0fkVkE0dWmyPXrH+Q/HOdQ1+gGgbPcXCy1hm0LjRzJyuBiKEXhxOb1g68Hjgx6E
	 WSz7kxFoVDhIXfDmtHnNBkDetEnKj6qaR9mbQB/02v5FdCrmbYI4thaWHxKIlAjjZi
	 uSPt5Vs6YI88Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 3/6] selftests/damon/_damon_sysfs: implement DamonProbes
Date: Wed, 29 Jul 2026 21:39:40 -0700
Message-ID: <20260730043944.146030-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730043944.146030-1-sj@kernel.org>
References: <20260730043944.146030-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6ACB2100005
X-Stat-Signature: zfym9347jwt1mof68f63b1ifen9eo98b
X-Rspam-User: 
X-HE-Tag: 1785386397-555568
X-HE-Meta: U2FsdGVkX18zklKC+/M+KHjb03GSOwvy2AmEQfyHgXPYornESDT+aEaTl/5ZS/CF9M+4MBi5uTqkS7dNlCK7UO4t3leUFujlIm32dLWGIyAte2P0jGUbBfg7bbkZ5sqkLyi4gHh8OCNJr5F7xO7mVcvWZZLCOd66LeORxPlo6ofdeLCf9wMfs1HAZLkBmFwEZswDjqU7CcJ5Yd8pnLOs7vbYVgHMyYhIkbMB9BvwITBlS2P6QQNzSl2EaAvZ6BlRyGJtl7w4nah48uMbaC256yQ9jzoYznHizFuIbvBc66X5J5K40XPweqvyK2x7xehCQsgt0sUCS4KjteBhHFKzExle//PtGzmynw/WeiyhBsfSfktXVh8GyTsHG849wNbQaYQ/4x+4K4GRpXmKJ5jFguFRZ17njuex90l6n+M8HAMkYBku8YljKXv8vdzwsNwZxJS6dJvTLCqb4kf1v0LxazKg2gwMuULyP+rTadCNobbfHsQo4fp9OCaEcT+sHCWeGqkXFbA3t6O2gvQuJpveu6mEMCFox+fHrXAjjdTr00ISFwxDRDW7epaZ/0aQkwKQSgHWY9k63Y7SaPrlh/aQeZXMEW53mBVXEPNrdcQfPOeZNn1QC+5Wsmk2RIMVhf9xYJBFMCWnmSLMChye2KLY7gOT0H4kK2NQtMcVTUYTjAEp8SbYjHRd90SWy7rKq6v1c84NwR8vg6mEh4v4Lrj9FyycoVMSkESalfttgRDcFSeBntC6VCR8iDpZ5jRv6eUuCM8oF8N1gD927dWCi6jsC2eWWCvPN07pbZIoR4HjEAA1UZAxItdRcqOWOkZ6JQE8fVOiyYWUyfF9vWb4b4jYXnELT+UVH3TfLjhhdQIcnGh5o+rfVylKfoOwerl51zAcZ4OJGnISbW/0TYZFeu+zOQSPNkqz05g00TXshyY/7aSXG51tBuJdXKe2VfwLbsSlXznV5QuUIi4oH5e7ECK
 XlY+1Ndm
 awV5BAdsi29a5KxkWcmQSofrkm8Vg1fvkdx75XdudfEnvpmNRP6Q98hCJA2OZae/xi60TxhES9RX82866Qu4Pi9hNGG10qSvEkjIxsGYTnomROHsCGu5nP6VIrP/r9kYQyabhO2t1G/t3uNn0+FRfjZymRvECDvtVBXuS8ESROU4BbJQsSD3wPF3s1RsOO50i4NL2iG9x5TTc5GXPQW2lxt1hHqiKcXbpweus2IGfOC4b/RlM6Gz8tBy8+THv1Wv6CVY1xx7H+2mpkbOYE4Nhg9lsbixjmUEMkUDi3dwH6O2CmU67EcOZyrfkYetcSgm9PwTPOCuP7k8FTghuz9a/Dg/MEQv4X6UOQYfB
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
index e6a2265d721e8..94bf0aaae9f59 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -558,6 +558,117 @@ class IntervalsGoal:
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
@@ -565,11 +676,12 @@ class DamonAttrs:
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
@@ -577,6 +689,10 @@ class DamonAttrs:
         self.update_us = update_us
         self.min_nr_regions = min_nr_regions
         self.max_nr_regions = max_nr_regions
+        if probes is None:
+            probes = DamonProbes()
+        self.probes = probes
+        self.probes.attrs = self
 
     def interval_sysfs_dir(self):
         return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs',
@@ -586,6 +702,9 @@ class DamonAttrs:
         return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs',
                 'nr_regions')
 
+    def sysfs_dir(self):
+        return os.path.join(self.context.sysfs_dir(), 'monitoring_attrs')
+
     def stage(self):
         err = write_file(os.path.join(self.interval_sysfs_dir(), 'sample_us'),
                 self.sample_us)
@@ -615,6 +734,10 @@ class DamonAttrs:
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


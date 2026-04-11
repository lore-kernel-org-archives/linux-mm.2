Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AA26F3ED58
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5276B0099; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756AC6B009B; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6453A6B009D; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38D0D6B0099
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07B985B6C0
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:32 +0000 (UTC)
X-FDA: 84646860984.20.F196F01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4FA44180005
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ixGYDx9s;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21sdvKbt5sXQeuruY4QQjY84kL9SegytBsvmB53RIu8=;
	b=qw98uBDpAEHHUaZaQbf7xxOcZtEoxFryHrIa1iCzW5E8ooO+dIO5tm180beDj30sBZlzT9
	Aimlg4cmy8c4CwPdMUxjalQMJvM+rFM0F48njU0ZIIL/WX52fVJ9Du2HI6XtbFRSMCt3HI
	dqofmoM3Xl6AXc3jHLq5vQms89cuBDQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ixGYDx9s;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926170; a=rsa-sha256;
	cv=none;
	b=3qJ04VjBSklulom48GCbCPdt5cdfpLT4UYyoMoAznBuRuARh5QyAfJDrCau8c+g707lpMe
	FCjhIdMXkuoztTG2M7YgtxKFlc99oEnuOIz6ZmDvwhBprKv7cGCUeQiP5u96fig6PszE6u
	l0BSsFRB38y3l4zmypfRZQtC8CqZX1k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F2C84459E;
	Sat, 11 Apr 2026 16:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7698C2BCB0;
	Sat, 11 Apr 2026 16:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926169;
	bh=fJkIAWWlo48QPdeJ9YXUoXHCIlYHiM9shoj6TYfrLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ixGYDx9ssNNPjrfbgiMV4ZJcebZaf3qT0CchkYS2IN72WIq9+MUqVlKZovccRmnWY
	 z5QpD2VLZkBdhiC6qwoi18cTbL6niw6YRBxIDyx0QovyKzsoLTebnlusSotg6xngIH
	 uOba8dYTS+Zc0pUzNhgZFU1yb5TfkFGgrtAunm43K8A4vH5VLLK6WOFJA+eo+DqYDA
	 YZUoVttfjrrwVjWR1y9Ls1t4zvNhxE/IQ1DUgI5EzFw0XBV2eCOqOJnEDN8qyQfdsQ
	 y9/IiLJnl4RQ5yflbRkt69hhQenTF8EVf0Owarxllwpvmk58od04r+VmrV6o++EN4e
	 +g/kf8Ov4TBCA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 06/11] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Sat, 11 Apr 2026 09:48:59 -0700
Message-ID: <20260411164908.77189-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4FA44180005
X-Stat-Signature: t7hduxmae8hpqtw1fx5jj1uacphmhns1
X-Rspam-User: 
X-HE-Tag: 1775926170-468183
X-HE-Meta: U2FsdGVkX19LaK7Hy/LQb65qdHmamaVkQ0BsLb45pmqok0qYV8PQUTMcks/XXbawax3P4iJzpEWzYx6sTcI4g+LhGSRxQ3hBuxEJpix2HX19uMBJ0oqos3NFVT7NoDUDA+dDOIUb5btmztXd+7EtHqTHCIUVXMMY5R9mBpbUKABzaWJtO5LJbN9J2SHnERQBAJSFGV3MoBN7/I71wPzVTUwQW0vdjlp+fjnIxfQtPuj9XYEwKaAhbs54hFY3d57uwh9JK6tUywN3fY2BgpAeXUWt3K8q7nEqM2LA1dmGyx9UXqAY3BLlcuZ/qfJiOYsD+/cVnpFXA2OHHVnGxkRsGV0mSIQ86W2x4HC7wYHs+MaN9lsGoGNi/9ansQhZkEOcldt3riH8mKG5QzH/5F6/lso8F16niVx+ivPcIfZVmmpj/RSQmFaLz7Fff09WY+EyjO4PLQ2cW60MC3c1/yxFJPUmLHwOcv/JPlycv46X9Xcg5Bkox9QYNglDMZGrD4nEdEk7sIAcmAm/OeP9NIGRwsq6es6w2iS6//DkjihR8dcaRjY4XEhrLZ3ulFVADWuEskfnI9ePDB+FkXp1l72MCgi/kluP1Wlj4myTREPSOwfCZuX+vmggN64FpRfG30ZO8iIGMB29o0VLaX5FQt1YCHbWcUSeNd1KwxR3tCRkacQXYwelraAUuu8o76aiykMzUk0p/w1QWeqeKlGup/eI6A7xyQNlnGVnR42Q3Rz/eXI7+BE91yX3cimQO/rECW08FHJ8Plz2BOwGNcG5ZAZB2Vuqr48MyjFfPpRO/pngXIBqzzdUCHrO0azofPCZwGK39XgrdxQBB2ZIE2tSRQCY/vB+TpEFCzapYpZRqtLP5GTEf848QkKB8KOfnK/yFQHYJTl8sQSEZWvI4tfcaRXjysrDSz/cTIYLpFPeZPpPQ+IUahmJOX15ysj2lqd5mzdzL7rY4M6prZ0SY0ZdFNG
 q+ydTBub
 DcQ89Bg8NG8CdGGETp3iL3Oskq/PVpO0m3dOwiTIGzjjwbn77HYGgSDGuvO0MXN8mojDFI5Z3tMbBCD+sfEZSfxemO1pDHmRQWOrSUzjOXAv4c3WzFYiF2o+FvDerZFsW2ce+2vJhwAI1YjPJuRwpxSsECt6lJVzgukBuJYeMFz8032yDbMvEEqIuD68lmmzsQwsVksJ83XJqr4wQxFvX7Jo24qk2FxUye4xtf9d4xYgLNvyINbXSJc2bF0vIHIjFWbtcTzSj0rqYP+HraOAnpDQRjoCmZePw9UqILHNG6sCbYp8MYV//fPAsrxr4Qvj00gbuvPoK7dzO8oF1EN9pqT4NjAka6w87G7ahzXJGKKjYdw3jwKJkFm86RKKNzIpEWtO9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index bfdb717441f05..d5548e460857c 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -84,7 +84,9 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes,goal_tuner
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,
+    │ │ │ │ │ │ │     effective_bytes,goal_tuner,
+    │ │ │ │ │ │ │     fail_charge_num,fail_charge_denom
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
@@ -381,9 +383,10 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, five files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes`` and ``goal_tuner``) and two
-directories (``weights`` and ``goals``) exist.
+Under ``quotas`` directory, seven files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes``, ``goal_tuner``, ``fail_charge_num``
+and ``fail_charge_denom``) and two directories (``weights`` and ``goals``)
+exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -402,6 +405,13 @@ the background design of the feature and the name of the selectable algorithms.
 Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
 setup.
 
+You can set the action-failed memory quota charging ratio by writing the
+numerator and the denominator for the ratio to ``fail_charge_num`` and
+``fail_charge_denom`` files, respectively.  Reading those files will return the
+current set values.  Refer to :ref:`design
+<damon_design_damos_quotas_failed_memory_charging_ratio>` for more details of
+the ratio feature.
+
 The time quota is internally transformed to a size quota.  Between the
 transformed size quota and user-specified size quota, smaller one is applied.
 Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
-- 
2.47.3


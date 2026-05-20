Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D5BCD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 01:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7D36B008C; Tue, 19 May 2026 21:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7784B6B0092; Tue, 19 May 2026 21:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640746B0095; Tue, 19 May 2026 21:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 552226B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:21:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA7E140D6C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:21:27 +0000 (UTC)
X-FDA: 84786045414.04.CDAB363
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 345DBA000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:21:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMZT4khY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779240086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5SUdvctEA/oc8IEKBcOiY6OqbBfPvmo8ZaU8y8FY94=;
	b=YMS+xItROg+lOekO7pyHWZqeCraPS2yLECoz3X0QE3J7nyBWb31hDuIscrrfMHCb6L1+Bd
	KnC+4gki3WS+xub9BrL13qhncTG3UmlNn/4eybUxyMnyxkD1Sf8fucofqjBgzuQ0eBkOP8
	tYsND04fF92rLV8pqog8/mNjmOf1DJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779240086; a=rsa-sha256;
	cv=none;
	b=Ad+Z6+ROrxqbOiNSpKM8RG6SUBRwY3gI9k7Gm+rW2FNZlhhlDzCwaBL2iKvZnoJKRmnQAH
	uz/mslhfelxOmB0tmYx26hr3idgilvgThi0ayBzAZgd0WTPMWvJjMgnkN2CxcAHn2Qg6MK
	dgog1tYPzO5EzkMXbvnpK6SRj/W/gAU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DMZT4khY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 16670437BD;
	Wed, 20 May 2026 01:21:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58DE41F00896;
	Wed, 20 May 2026 01:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779240085;
	bh=g5SUdvctEA/oc8IEKBcOiY6OqbBfPvmo8ZaU8y8FY94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMZT4khYbL3aVRqpSOJtNVRlGSXVDkWy1zEBu++LgurjzZELzjwQDXrgRzBwBHMIK
	 UCWteVanQ2vhP4Ol10ibWnCkC9nQIvwNUNllXshjXRe38hn2df2u5d0/oDB8UxM4QT
	 D3wUN5aw075C59UpGegQRCqJIkJSk0zmcjkxGzyI4snr9r0lRzwQ5nS9UUnREz8XXx
	 c8zeDtLpZzBCVxVangUULH0Q+UoQRvgYRPXDwl1GbcZ/EiMfi1fJHw6OGkNuomjFjl
	 S77eIOaNN9zjRUSFfBB6IRfyAXJkBxVSEkMzbdfQt5eeNr4oFHtZvqwcjxwmqyHV/j
	 11/ezJpP0UEQA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zenghui Yu <zenghui.yu@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH RESEND 3/3] Docs/{ABI,admin-guide}/damon: fix various typoes
Date: Tue, 19 May 2026 18:21:01 -0700
Message-ID: <20260520012104.93602-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520012104.93602-1-sj@kernel.org>
References: <20260520012104.93602-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 345DBA000A
X-Stat-Signature: 9tpzkia54wjwbcmqjnj64wy7p36ejhtk
X-Rspam-User: 
X-HE-Tag: 1779240085-558145
X-HE-Meta: U2FsdGVkX19ugvP3APA5vp4rbwt8fRt1XTEQHjSQ7zjD0ZtYYFV4yWeZpW0Yko9HbsHpr59S2esJ92KskhTXAMtATo3p2PpEml+oPiY4s0TAFDzZRQQ5fbdjrIOLGElq44iUYrtGJaOdvIHp9s52aCFXmhsQPUjf1SQqMZdPJUGLfJxA+e0HupTzcTkDdzULze3X9Wcv6aH0NYbGFewHZ+Kem4nKwHlp+0W1fYJJ7iLD94taanMopSgIT8rn+6dj1LTOv9qS9j1fQ0rBM5GbUdvZamzt9h6i5pvX/hoR1S0PHXIM4S6vGY391cxGptTk+XVGvAZVK1KwdCqkiVJtFJJ6R795xTiaHWm7KpfzS5VvWlpt5WwEEfL1FqpauOQDYKR5AgCoCtJOXwDqjcUUI6wTjY77WF4JvOI15qY0yDPieQxbNJze6XidHG6P3lAJEBzNEMQj5djmKKJ6c7Zwh7Q8pv/8Xc0FIlR0wyNi7bU0ky8EoY9p3ZjhpzeME9Z80cly4HbSBwiz66ZhPbsLiHwjpK1+OVnhgVxdKfcjFUtLq+x2LLeuGxyax73eIJ8s/rkHlrOoNa0wj8ibS5qxZcX9zo1lmC1m6sYFAJJlIOph5VSFN4Puz34bxZH5NZ7FgU1RJuiFudYhwAMOBJiMPf51svmcT9hRhlRmPx2yj5UgDM/B7pxuVhTBs1B1RJ9bPIrgsS0CRMpGI1evbG1oC0X/r0JfhKegcHWiKvUavR8Q29dOdaLT0rVsSH3yOgE3ThokRCbzt+hLVe8pwRdYrmaDBKiBVrThW3ENQmFhjdeUoGv82q1jYIP6Z002EHTRD63n6BB7CRvBLfXfZE7REivWLnUQY2zH8jXRmf7kfnIPtlZjzIFIDEPlgXHmRlAf1V8jPxUlfNw26YF4W94lXwFyJzmVg5zW2HxJ65v3otWb/s7ErjPnlTZCVDdxt+XJG4WPVd7PDwDTDQnymHp
 u+MO5IRs
 4ATtPu7lp8lkPQh2I3DWg0GIxcPgtEi7qdfXaZxJFb2AoXiC5aKFzUlRPx2MnmpW6xrnv2V33IjGRO8pr9josGVtIbkMV8nLz1G+v7EjIp+GkNxetyxn1oK8EkQOI7ghZzibK7xmQAXQXAGQbABhcyWTuO+34trDeb4TMSW+vtab82XGHqgAn/OO6VOvO4SxtBvlX1ypyGnC7IzgE5Yr8UhXn840UOa6mymJIdZ59lB/uXGE7rvOZb/A4KhlKiaBGHzf+0BLsU3eCQ50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zenghui Yu <zenghui.yu@linux.dev>

``damon_target_idx`` was wrongly written as ``target_idx`` in the docs. Fix
it all over the place, as well as the wrong directory count, grammar, etc.

Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260517182624.7167-1-zenghui.yu@linux.dev
- Collect Reviewed-by: tag.
- Rebase to latest mm-new.

 .../ABI/testing/sysfs-kernel-mm-damon          |  2 +-
 Documentation/admin-guide/mm/damon/usage.rst   | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index ee29d4e204ffa..b73e6bc28ea5f 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -452,7 +452,7 @@ Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the maximum size of the
 		hugepage for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/target_idx
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/core_filters/<F>/damon_target_idx
 Date:		Feb 2025
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'target' is written to the 'type' file, writing to or
diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 0d6a27dc97b0a..d46875e603d86 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -97,7 +97,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
+    │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
@@ -374,7 +374,7 @@ to ``N-1``.  Each directory represents each DAMON-based operation scheme.
 schemes/<N>/
 ------------
 
-In each scheme directory, eight directories (``access_pattern``, ``quotas``,
+In each scheme directory, nine directories (``access_pattern``, ``quotas``,
 ``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``dests``,
 ``stats``, and ``tried_regions``) and three files (``action``, ``target_nid``
 and ``apply_interval``) exist.
@@ -492,7 +492,7 @@ given DAMON-based operation scheme.
 Under the watermarks directory, five files (``metric``, ``interval_us``,
 ``high``, ``mid``, and ``low``) for setting the metric, the time interval
 between check of the metric, and the three watermarks exist.  You can set and
-get the five values by writing to the files, respectively.
+get the five values by writing to and reading from the files, respectively.
 
 Keywords and meanings of those that can be written to the ``metric`` file are
 as below.
@@ -500,7 +500,7 @@ as below.
  - none: Ignore the watermarks
  - free_mem_rate: System's free memory rate (per thousand)
 
-The ``interval`` should written in microseconds unit.
+The ``interval_us`` should be written in microseconds unit.
 
 .. _sysfs_filters:
 
@@ -528,9 +528,9 @@ in the numeric order.
 
 Each filter directory contains nine files, namely ``type``, ``matching``,
 ``allow``, ``memcg_path``, ``addr_start``, ``addr_end``, ``min``, ``max``
-and ``target_idx``.  To ``type`` file, you can write the type of the filter.
-Refer to :ref:`the design doc <damon_design_damos_filters>` for available type
-names, their meaning and on what layer those are handled.
+and ``damon_target_idx``.  To ``type`` file, you can write the type of the
+filter.  Refer to :ref:`the design doc <damon_design_damos_filters>` for
+available type names, their meaning and on what layer those are handled.
 
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
@@ -540,7 +540,7 @@ files, respectively.  For ``hugepage_size`` type, you can specify the minimum
 and maximum size of the range (closed interval) to ``min`` and ``max`` files,
 respectively.  For ``target`` type, you can specify the index of the target
 between the list of the DAMON context's monitoring targets list to
-``target_idx`` file.
+``damon_target_idx`` file.
 
 You can write ``Y`` or ``N`` to ``matching`` file to specify whether the filter
 is for memory that matches the ``type``.  You can write ``Y`` or ``N`` to
@@ -731,7 +731,7 @@ show results using tracepoint supporting tools like ``perf``.  For example::
 
 Each line of the perf script output represents each monitoring region.  The
 first five fields are as usual other tracepoint outputs.  The sixth field
-(``target_id=X``) shows the ide of the monitoring target of the region.  The
+(``target_id=X``) shows the id of the monitoring target of the region.  The
 seventh field (``nr_regions=X``) shows the total number of monitoring regions
 for the target.  The eighth field (``X-Y:``) shows the start (``X``) and end
 (``Y``) addresses of the region in bytes.  The ninth field (``X``) shows the
-- 
2.47.3


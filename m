Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E68DDCD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8EFB6B0005; Sun, 17 May 2026 14:26:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40316B0088; Sun, 17 May 2026 14:26:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2EBA6B008C; Sun, 17 May 2026 14:26:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE76F6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:26:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C6398F0DE
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:26:51 +0000 (UTC)
X-FDA: 84777743022.10.4E0898A
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2D05714000A
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:26:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RcCW8HRZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779042409; a=rsa-sha256;
	cv=none;
	b=zCaEDsop3iqZOkYsJMuOSmU/t9sSwcfCwr5TSUiIJbZn9IHVc0A9+5b34WPMA1q65GDWay
	f8M2ywDsf/tUQMJ6rlyvOp/XycSUbh24kn2Ggw0cPv9zDQ9dTNfTQsGQHjMPKujBQ/wtzj
	Ncb0ypQI4ap4352HroN7Z5Y4gdbY+ns=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RcCW8HRZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779042409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V9vGbDjxgZyPY7/BSXSX99pspMvi9Dnp2FUzlVWZm1Y=;
	b=S7jb2fDSJMTml9BUqfI6TWUr/FxVXSEHAyeVHp5dNKqoorLkVQaGYCcuAOxwXRUC9p/B3p
	UlIwRZXd/Z7KSOo4tiKyS309nOgShYe4m+wzPs5v+7lIg7NKnqax9f1e3lh0RwON5N2mlD
	HQW+aasb9POCvFK++IxxS48EezOqnYg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779042406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V9vGbDjxgZyPY7/BSXSX99pspMvi9Dnp2FUzlVWZm1Y=;
	b=RcCW8HRZzzfzqL9uy3GAt1LQZN1SwBPn6GHQb4hzkJKTmYk9RPTR2w8wnRSp2DayqU02jy
	R779rFWkXjHEFULIPuoOVaWVz+OAvGz+bvwB4ZXqr3GQMo26J21+yACfBuXQ9SnA/WPqAp
	iuhtFExuagWeoV+mPjASSal5KPm/220=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH] Docs/{ABI,admin-guide}/damon: fix various typoes
Date: Mon, 18 May 2026 02:26:22 +0800
Message-ID: <20260517182624.7167-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: oirh8yie8ib41c1g9kqzz4yyfc8d95u8
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D05714000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1779042408-459540
X-HE-Meta: U2FsdGVkX19FVTx2wp5QQhLmFT81VOtNtrA8R3vOuzkmFcC7C1EHp3pzQIF/OVbDfZuyFGMigTpuJnyr5BMQR6L1eKhrDdpNhCCjdLjc4OnaUo1YUju7Fo8QFps8gocSlX06j3yO1FObqtjK2inUDTZCkjNoqGBqJde51xVjPpPqLkiNH0WkDakGZSlp0Eq8R6nWYEbTm6OVHQYtG08hlGbebqOC4TQEfX4UTDtp9KywgrZ8/3McR5RHO5r5YudVvggV49Vb0BHHS3gzzE1jXMJTxH5fVudFR0IlnVxQ55GxzZx4+X/A1HHyWPWZR7V2/iAZ45QIJEILqcJYgzwAK079hl1rpwk6lF8AAV+DnpXdV8TUzvEATeTSAcTeZCBVmOW3mRtcTRkpbhFTgZdQgCKGr65Lx2g159X2qscRK6Bye2V6zUSZr4x1EXiqQk1V5ar+ICoWiDYEmojB8uCqpqJIs5e6qYOAszc7lVj3/LoG8t5VvO4n/WOHwDVBWsj5Ph3u+P6jet61iR2by0uXdUSHwXaKJuI0ueMjZa8hbtqmXPen21IDvTG2YzuOfANhgC4JdPaYHFwdy22xlFULg3yvgVZRDVJE6NTVVNXdd+lxhgcHuINvh9q8sqRIKFfZ0r4k7oWDnZlfN7DJLx6drvflpIS6OwbYjLpVUnkwYEy5KzjFpf51/KkeDPfzdz96hwwOkltqZnCEIs4YzKwg9XApUKD81c37QgvK0T/BYunGYzr+4PvZ8KZpilVf6jTn8cmI+bIH7YdB/9FbMKP5wt/+vxOXT+NleBJYEOUeNq/6ZJ7BuU3Q8bRy4ATcuMdRbUmbV0JYr8YHH1CuBOwcmeWVxmdJbXTnJ5QlWRkMggKjugBveB/QE9EHGED0GIg5eK1gauKHp3aV3FY9xh0SnxlesXYV+fPo+xa8YJg/8LL36ty34Hq7Zw1JjRRMcwRv3pCXgubyCLlKF5e4VVq
 ofmihUay
 2bq1sXYkZ4uSECpzwsmxg5t7ODsCyn3038ZDdiqtMnmA5IOkGL1HHY2wss20zE784u0qRPAj+DOL6CTOOVf58kkHWmagz1EpxpYtE9YmH/hztqfr94JiEmTDMcFvFodt8Tu+ZNBLQj7mvHyKvW9CpHf8etbo91AKIfN898cOGaDxf4XDJCx36KaAOPI8bV0xmmcoK7REkxkBYwpqSemBArvVaovhjs75tX4MqlE7eb9r0DNqg6vfbVjo5B1LBvhgZ9TjAAljwd7i3CzQuYAJJfYV8//X5hZLEfKvu33nMDy2uDcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

``damon_target_idx`` was wrongly written as ``target_idx`` in the docs. Fix
it all over the place, as well as the wrong directory count, grammar, etc.

Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---
 .../ABI/testing/sysfs-kernel-mm-damon          |  2 +-
 Documentation/admin-guide/mm/damon/usage.rst   | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 2424237ebb10..40c8843a82a4 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -428,7 +428,7 @@ Description:	If 'hugepage_size' is written to the 'type' file, writing to
 		or reading from this file sets or gets the maximum size of the
 		hugepage for the filter.
 
-What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/target_idx
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/filters/<F>/damon_target_idx
 Date:		Dec 2022
 Contact:	SeongJae Park <sj@kernel.org>
 Description:	If 'target' is written to the 'type' file, writing to or
diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 534e1199cf09..cae622b959db 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -89,7 +89,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
+    │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
@@ -337,7 +337,7 @@ to ``N-1``.  Each directory represents each DAMON-based operation scheme.
 schemes/<N>/
 ------------
 
-In each scheme directory, eight directories (``access_pattern``, ``quotas``,
+In each scheme directory, nine directories (``access_pattern``, ``quotas``,
 ``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``dests``,
 ``stats``, and ``tried_regions``) and three files (``action``, ``target_nid``
 and ``apply_interval``) exist.
@@ -447,7 +447,7 @@ given DAMON-based operation scheme.
 Under the watermarks directory, five files (``metric``, ``interval_us``,
 ``high``, ``mid``, and ``low``) for setting the metric, the time interval
 between check of the metric, and the three watermarks exist.  You can set and
-get the five values by writing to the files, respectively.
+get the five values by writing to and reading from the files, respectively.
 
 Keywords and meanings of those that can be written to the ``metric`` file are
 as below.
@@ -455,7 +455,7 @@ as below.
  - none: Ignore the watermarks
  - free_mem_rate: System's free memory rate (per thousand)
 
-The ``interval`` should written in microseconds unit.
+The ``interval_us`` should be written in microseconds unit.
 
 .. _sysfs_filters:
 
@@ -483,9 +483,9 @@ in the numeric order.
 
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
@@ -495,7 +495,7 @@ files, respectively.  For ``hugepage_size`` type, you can specify the minimum
 and maximum size of the range (closed interval) to ``min`` and ``max`` files,
 respectively.  For ``target`` type, you can specify the index of the target
 between the list of the DAMON context's monitoring targets list to
-``target_idx`` file.
+``damon_target_idx`` file.
 
 You can write ``Y`` or ``N`` to ``matching`` file to specify whether the filter
 is for memory that matches the ``type``.  You can write ``Y`` or ``N`` to
@@ -677,7 +677,7 @@ show results using tracepoint supporting tools like ``perf``.  For example::
 
 Each line of the perf script output represents each monitoring region.  The
 first five fields are as usual other tracepoint outputs.  The sixth field
-(``target_id=X``) shows the ide of the monitoring target of the region.  The
+(``target_id=X``) shows the id of the monitoring target of the region.  The
 seventh field (``nr_regions=X``) shows the total number of monitoring regions
 for the target.  The eighth field (``X-Y:``) shows the start (``X``) and end
 (``Y``) addresses of the region in bytes.  The ninth field (``X``) shows the
-- 
2.53.0



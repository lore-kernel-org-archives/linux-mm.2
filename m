Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35BA5CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02CAF6B00CA; Mon, 18 May 2026 19:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3EA86B00C8; Mon, 18 May 2026 19:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE2D6B00CB; Mon, 18 May 2026 19:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 761A06B00C8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F261A092E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:34 +0000 (UTC)
X-FDA: 84782164908.05.43F1F0E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9583240008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kYki/Wx0";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StcWHKq5cVjmt1v9cZEkpYS8NnTvYOlOpx8onv93C3A=;
	b=KfjoYU2rqYr03C19txmvQ7XLPvhMEnWEEk5ArtopQ6wK+3YnnkqJa2lm/aN8gD85Pj3chh
	5WVrKtP9phfL+sIam3sXu5b+4G/fIHtYTwUwE92tBzomf9e0WgwrmzjxY+itOa8dGwgu3e
	uOqXM0tTCFyvtRI9mc72QArSeagTLAQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147692; a=rsa-sha256;
	cv=none;
	b=6pihcRCqCqquOTs3rbpm0LePegBXV9QjNBJK+LJiZjErpGMzMNrzOba22GcxqRAfgJ2W8h
	WNX4ufBTV4NjwXa/nnHAhYDrAnSHSkkGwBqJqZFa2BW7sKg6to9oL8lq1GJQY2hDVNZvxi
	E6cff2Z+VrrlvOgfunlHfRUssK2klJs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kYki/Wx0";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DE5760123;
	Mon, 18 May 2026 23:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF72C2BCB8;
	Mon, 18 May 2026 23:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147691;
	bh=7jjwSTj0oWvjONIEU6hizSouOGWRpTuxqy3LQsj9UQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYki/Wx0XXVJgKBiW6cFEviE1oaaTeAmamUswBb7Nj79oB4pX/QV4+bmAo8ErWIMF
	 LQ7PR0kapL/4lP90Bkcu1srMFcPDP3GRpljYT+oafXfi4rBfXr145kGW9teb+RrNr7
	 5Qoh3qXYWOkWclcotzKkKarSeLE03ubHKXWFY1KyFXMXeKv21/ikR+IbsPrUaldnAG
	 xsJxq/j62exPyjowPIXpvW33jm1KcLzqa1abnFFFhFEySpHtNNv3FaOMI1wIqG3oVt
	 tmjjcDu9e+jj7WT4v6D7YLWL+eLzTtY9cKgagm4xTUHXw4eheLCI/Xk1wEPlL06Rvv
	 RqWIOSgzqgMzA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 21/28] Docs/admin-guide/mm/damon/usage: document data attributes monitoring
Date: Mon, 18 May 2026 16:41:09 -0700
Message-ID: <20260518234119.97569-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9583240008
X-Rspamd-Server: rspam04
X-Stat-Signature: xgywk6a8ordo5oyhcudwije6r4w67e45
X-HE-Tag: 1779147692-189046
X-HE-Meta: U2FsdGVkX18aAnjC3EEHGKDtPkEKnhFNO7FFUIXUZAcSLZ3iUfP8WWocH9aWw6FVS9abNTw9Kb+16N/8WX/7K4yKbaCGKpp3zziId8dzSDpj5VR603UlsWgAWjsNxMaTWhlOsvkwf6NH5Ic7vfsIFTF5FQAj6LEX6OtyXf8GZQ5/B9/7VSX4ROxI6z/0KZv3qnbOe91IM3QTbV63jJvhmsLvTydHaeDMHBREz/VUADuNsSbmll/WjrzcVrxChed1NYX88zB+8chJA8PPhxDpa9tTIsUTjhgt9UKXr7tQJ50zqWbEjm58Ikx0JzNCXD72K4YxSE7XbZDvJHdOJzjuztFpAFrUMMGqVE2O1Ws90Q11/5GeSGswStmfi3n86tBhaycgwWGizAtvy3m5X58Jkv0uHQlbSqfFUN1s7P7GZshnjaUZ6cl8xXnMGioo1mXDLbTZwELZoaiOGIkImQMcWwSbonXe7zVDTypqxsg4yrxXRGBNFhPEllpos9QLtJa2099Q6G89YlFaMLOXaKcHCfMY9lHBXMQvkBf7LklpZv9EUvvanoQY5b8pkbH/l4JOU6tVrIdHVc+eLae/i7my0wTbf76mNQnNIg5rI0hcYFamwdyGqjXchPHXyxApvNfl8vwrmfnzHwEDRzM8XvwBOcRrd0wrtNUMm0orsnMjUJGtOR/5NHJKxJnFuCyX2hNljUdQprOCpISvBdHjFd+cd/dZALw0/0Y82C98po/uBL14SR7vsT05a9fS51nv+bQegF8kN/09uhpSXsGeynz8xlXFCF2VS++M3LH/TjaqS2QEwYGYCoAVSpu//qiMmO7bkY2gcHdC57isAB48KEbIhOsKYczv0dj9slPvetHbjPfmhOsLBklP6LBDFPKn1y529Y4AFtdN/MLG8W+YlwVw14gQouncdM7WwzQwdFNxNSfObNDeDZEk5ICe/P9POdBkg/SvqTdX/Cd2v51UTEq
 bowkSzEY
 T7JcWpfMhfXCKhvH5ZXf470Yvwycls3cPHdyZxCEGvPLlCmh9adgHb5v8V5jPXoIlYDoSXR3YQRkyTFlelS2rWIWuJTM5qNqR1Tg++YCMdtS4q0+9P+BTHE+zOp0rWCtosJ6UczV3XTt+CA/JCoSOYKMs3+EGLvCf1cIB9ZmPRuFEBGos8OMXIPbCS/T0V54H7ytaksL2+QjQDTNgIR9pZ2BFNRtY7LlAfkVPubt06a/MN9qMGRAthnOgqb6bYL8I/nlh7eJhzmSkmCdJTNxiYhQ3VXa+flYm3ronppOxeSl2TNgTd+tb4Ut6Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added data attributes
monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 44 ++++++++++++++++++--
 Documentation/mm/damon/design.rst            |  2 +
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index c74dfa0ff3bfb..abd38385b3c23 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -72,6 +72,11 @@ comma (",").
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
+    │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
+    │ │ │ │ │ │ │ 0/filters/nr_filters
+    │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ ...
+    │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
     │ │ │ │ │ │ │ :ref:`regions <sysfs_regions>`/nr_regions
@@ -98,6 +103,9 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
+    │ │ │ │ │ │ │ │ │ probes
+    │ │ │ │ │ │ │ │ │ │ 0/hits
+    │ │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ ...
@@ -227,8 +235,8 @@ contexts/<N>/monitoring_attrs/
 
 Files for specifying attributes of the monitoring including required quality
 and efficiency of the monitoring are in ``monitoring_attrs`` directory.
-Specifically, two directories, ``intervals`` and ``nr_regions`` exist in this
-directory.
+Specifically, three directories, ``intervals``, ``nr_regions`` and ``probes``
+exist in this directory.
 
 Under ``intervals`` directory, three files for DAMON's sampling interval
 (``sample_us``), aggregation interval (``aggr_us``), and update interval
@@ -262,6 +270,27 @@ tuning-applied current values of the two intervals can be read from the
 ``sample_us`` and ``aggr_us`` files after writing ``update_tuned_intervals`` to
 the ``state`` file.
 
+.. _damon_usage_sysfs_probes:
+
+contexts/<N>/monitoring_attrs/probes/
+-------------------------------------
+
+A directory for registering :ref:`data attributes monitoring
+<damon_design_data_attrs_monitoring>` probes.
+
+In the beginning, this directory has only one file, ``nr_probes``.  Writing a
+number (``N``) to the file creates the number of child directories named ``0``
+to ``N-1``.  Each directory represents each monitoring probe.
+
+In each probe directory, one directory, ``filters`` exists.  The directory
+contains files for installing filters for the probe, that is used to determine
+the data attribute for the probe.
+
+In the beginning, ``filters`` directory has only one file, ``nr_filters``.
+Writing a number (``N``) to the file creates the number of child directories
+named ``0`` to ``N-1``.  Each directory represents each filter and works in a
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
@@ -615,10 +644,19 @@ tried_regions/<N>/
 ------------------
 
 In each region directory, you will find five files (``start``, ``end``,
-``nr_accesses``, ``age``, and ``sz_filter_passed``).  Reading the files will
+``nr_accesses``, ``age`` and ``sz_filter_passed``).  Reading the files will
 show the properties of the region that corresponding DAMON-based operation
 scheme ``action`` has tried to be applied.
 
+tried_regions/<N>/probes/
+-------------------------
+
+In each region directory, one directory (``probes``) also exists.  In the
+directory, subdirectories named ``0`` to ``N-1`` exists.  ``N`` is the number
+of installed probes.  In each number-named directory, a file (``hits``) exist.
+Reading the file shows the number of data attributes monitoring probe-hit
+positive samples of the region.
+
 Example
 ~~~~~~~
 
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 7fcb726263c1a..937960d2b6d73 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -276,6 +276,8 @@ interval``, DAMON checks if the region's size and access frequency
 (``nr_accesses``) has significantly changed.  If so, the counter is reset to
 zero.  Otherwise, the counter is increased.
 
+.. _damon_design_data_attrs_monitoring:
+
 Data Attributes Monitoring
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3


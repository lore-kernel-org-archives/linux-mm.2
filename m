Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C47CE937E9
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316776B0099; Sun, 12 Apr 2026 12:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1346B009E; Sun, 12 Apr 2026 12:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F686B0099; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C591E6B0098
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 937731B923D
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:07 +0000 (UTC)
X-FDA: 84650415654.10.2403F4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id BB39780008
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZaD/suMf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010806; a=rsa-sha256;
	cv=none;
	b=MEaYDYz6IITdwYtthUcD8G0Kkv6+wi67xZDbOxYtnsGOEIE58RYxbqgqjT5IPaoLbQKjbm
	xOHa3+CzZw4iXSx7NO4QjTqotgh9w7IG7qiprTCRlydSB/JgW4GW2fdhqwbD8sHn80LXou
	cXdTLXblCWCAMM3iBA0qcEQKVF+uKjE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZaD/suMf";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21sdvKbt5sXQeuruY4QQjY84kL9SegytBsvmB53RIu8=;
	b=aQBYJruSbuRQomXyg/Ycx2v8PGM03V3KUOrTSwk3Zd7V+3adtCQJ4DE2kENFysx0oxO4fY
	+nWdrIq0wNAbkBkzLR3An8BOTSXuF1XqwMYYpXykn+ZcYc9eabxqKaPifEGigIslxbnX3z
	i3gNC2555FW3udNEcCgmx5pHg+dO5J8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9ACCE403EB;
	Sun, 12 Apr 2026 16:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE19C2BCB1;
	Sun, 12 Apr 2026 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010804;
	bh=fJkIAWWlo48QPdeJ9YXUoXHCIlYHiM9shoj6TYfrLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaD/suMfgoxLCiyEiqO1QSCibvHvDaViwrivuYx68xc/u4fMM8AOReY6rs6EK6yuS
	 EBZ9xtd1ddpYxDHJ8IcDuHGoRr8XptCuIugwnetWeryPu680IC/7xkhVR0x7nbPkdh
	 FSuzjIdXWjQHOmbaZX1NmevXBQq8u5qqBGGI6fTBogrnxkToNLXs7+XEZzHkFZcdDc
	 wyPq0fgstYPZRtQ1UR+2+eeocXrSGBnI/TASn7MzVhpYENg7xug7w0cG9YJG1bJMEn
	 Quo+RRX/B4zNBbLMP8Exvg0F2+fUQjIqcIqPdBCkumMLH2bpa1cQQMjKp6Jex5ogNB
	 hFAgDSHkVb0YA==
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
Subject: [RFC PATCH v5.2 06/11] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Sun, 12 Apr 2026 09:19:49 -0700
Message-ID: <20260412161957.82835-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BB39780008
X-Stat-Signature: futhomazi5csirdqmhm84gd9m9owkxko
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776010805-386818
X-HE-Meta: U2FsdGVkX1/t17Jx2e0dXvuf7vezpooa/jezApc4U8/DA3pC0lfbse8nBMmnW4sQVdwYDm8qUar7O+739LcKb1p7Y9Xfv4kjvFWRPXg2CTUJXgIo6BimGqxtcp8jRuzrnR0GoS2pEeGij9vDDRn9Xq2c8cu+kB4pNJlgjT6LobJfHa8tx8q4HqAyRO9CY22l51J8WFdHhgB958tv2R5PKUrGum6U9NCslCsKDd4W37VaXl0rizzbH68u08rvZn7Xd7KhGI2n5HKlGv685ioqJxjJjHms6KEKqfjqiDylL5TzYzRXkjQkL9MlwCocbFUmdfHs8OMJsOZ36cuqh7l46PScMFlga87ub+Vu3GwKzVxSQH+BHWmNbw7MTWDZmXor2DyvUCuKhO8sn2En1SlWelsKrRASkhIF3KA85h3+2XYWDXHtTy1Wyq5tf+4GQSRJpnyRvfWNvcHLxKdih6N11JnLyWpLrIpAdCzFEkO05EdvNOE9WZNS+MaUN05SFkbik70uN4iBwPQjVsnO99gE3fP68Waze1heKgWGd1SbV0Wx9cSSoQPyAewP/SnDVD0upWih1etNkQHshHA6sSG3RiweeS24GJS9UeDUrs06wO0SnmcTrjOxHOP44eFFhMIDMpXBAVkKHSeQPI74C3gtQ9szcP1VEc1fyRxGvoNEEB7styFXu6iHqJr/emiWeteOMQDAe0wqzRpD4lWg2F8ubfmbP9Ihjr7tztgbpBfIsh3JJnsVqvP1w4ctyc9Denrk22OYtS5XxDG7jddZJNW+s3uf3MeQYLTPcKis94oSji08af8Ptg9UqCq3qpym6qcgADDSgA5a8vWO/Z7NmArfEgF3lIc1sjYfCTYT1QY80YIO/+Psflej+EZCPqeL/3OOQP0ESyxSC8OpIBEqHLwO5lFa4utwGERWMcVxc7Nkf4Crk1ZNGUSG7WQ/dJZFoitIHxnSEh2UyprdGBHoRwj
 /iLEqMbi
 fUbayn/zWwIYphJk7x1stryZP2PWd0ky8MpoUxNns0CJzEinx4rflxlAShg6gKaVxru9mtDw3jOGiH5lEyGd815gRiNBotXe2GbEn2X+iBi0oxM2t/lkDGHu/C4p30YFU6/mfDp4kgca+jp7mx2Q/q3Nz17abkM3WpgCi1am5Pb5nceEVGDMV2IkAOlSpB1FShSrxjwTxwQ574G05nzVrSHfms/stkMNS2bhgYamyED7JpAjPLw74SyPwZa1uzvK6VEafMgCJppRhR9ReapMuNy3so6/l5NL06tNZj7DCnnqgcNVln81dWBNsZjs7DLVDtDOtX0ob/9/QJxGRnmlByzalby9/WSGeYtk2cYvk6XWFBUcMOjRkuMVqgw==
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


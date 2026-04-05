Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77257E9D805
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 15:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014866B009E; Sun,  5 Apr 2026 11:12:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D7A6B00A2; Sun,  5 Apr 2026 11:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5466B00A3; Sun,  5 Apr 2026 11:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE1966B009E
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 11:12:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8CEA4C3718
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:41 +0000 (UTC)
X-FDA: 84624844122.13.D040F2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D81A940002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:12:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HqRwPwfr;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775401960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21sdvKbt5sXQeuruY4QQjY84kL9SegytBsvmB53RIu8=;
	b=nQ3UYZe2VEsJOnvOBshIN04OKhhNLpXFrQwF2Tf5teS3gFLbh1iRmlCD5BiWXsOvIVCWL2
	7fq4ly+BzWLN6IRxI0lZuS7HigAUMxaJfCbpHMWhB3/hAPXMTdkJMyNPC/W2yRo56iR0eo
	zlce4oagf5zWDTlQbqfxy3FS3Duxlqg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775401960; a=rsa-sha256;
	cv=none;
	b=bnt2Q/Hf2sLzYVfwSQJD1RQLpl1B8vHYL20ij+elIuoDVyW7TTok8dLzs4z8MOLb6ZifTU
	xcqX5JpSSvHW6eVi9qCl9E19fc4mxGoLfVfxJ6V7JcW9eGvIhRbSc4Fkkof6t5ENM0iJJ9
	cHyUK8FfyB330ubclphXIGi/d+G+L+0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HqRwPwfr;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 139A64453A;
	Sun,  5 Apr 2026 15:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC7CC2BCB4;
	Sun,  5 Apr 2026 15:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775401959;
	bh=fJkIAWWlo48QPdeJ9YXUoXHCIlYHiM9shoj6TYfrLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqRwPwfrwhJ/63bWf2vkpgwtkqVRe3uYLDEi9gGJjlNCVqjoJxIB7gNGzAHTGUeaR
	 IJzmDqV4oRrrK4Z+gWcpaOCTvUcOUe4iZ6sKXbM4b9LHyRNqoei4lOB6tykPPvvp5I
	 wLDVwCDwFzE+Wd6P9kS1G9yusffe7qEPtk3JgeJcdK7SSVynnN3AlqCqDP8iTe9oz5
	 oWb2YLy1+3Vu2JXTgFnGC5l/Mc661y4XggMFuhR/vHhntoLSXafb57tlyQpmlgB2aQ
	 kiC5LH5wMM29/RPepVQdkAg1w1L117gR0OrwlXh5xAPTx6DN8c+Q2DzmRha+X6GU5W
	 Og9lNrWXGZ2fQ==
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
Subject: [RFC PATCH v2 4/9] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Sun,  5 Apr 2026 08:12:22 -0700
Message-ID: <20260405151232.102690-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260405151232.102690-1-sj@kernel.org>
References: <20260405151232.102690-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: aczzjmwmntek7b8fb4sewog8mu3nqkez
X-Rspamd-Queue-Id: D81A940002
X-Rspam-User: 
X-HE-Tag: 1775401959-268504
X-HE-Meta: U2FsdGVkX1+0kwVps3Vvpl5wBtiaex1uRagO4wSL6FxsCtLDjwtRmie0JDmKSqgk9Rt8kIVfkyeGoVG0kUyOp2sN1p2laHWInFYYglh2wATSh1V5/iEPm4afCipVKMo0VEd33BnPfhQuw52s3pcC87HFJcmdo31pN7arBdaQsGPLT+rPUFDgbxOI82PNK62rwaczRaDcFxGTX4+RwdADrjgv0SSFAJ3F4jhXnAjtDfEtFJMZaV6D+ad1pvxy1OqJs9Sq6Sjx+yV6ORCdAX8Of9ymUBqzBoDkrDYLNoVsNHctV3TqiA4Gz821ipvKJGv0S9YEwB86oO97Qx9Bs7AAP/CT+Kow2XsDaahVf7od2Yl2L8swXAtlxU0GySFE/wsWOC47jEtTcsa9ghbl2skokt6CnmPIWTv3Hv4vT9cRmpKdnk2Sg/hrFYZtdtH3iHEqNiLuRUT5DJYcpeaux8XUOfg3pCkAcWnnOg0fz2HVosMvzBFhNYVISBesYhzr+KNuQbexDfUwep4+QnxjA4gySoKy3bj0Qvz/DFErhSi4xAIaSIzzR5AnW8ZENMNdenv0BwHGV++guQ+39xYskebtSrgOPj+XpAbLvuodg68HUK3JMFuRVQdH6P9ckD6ZwqWtmo3tuvQ0XymoKlPlD7socHhJxR46iNMJU4429I6nn0lwh/DnGq90veLMrJ5tBfvmMDahBi2AF+cpunJtttknxkcfsbP5CpXTqcfj1BcbJ1Os5Msa7MZq2g97bu7b6UjDJmiN3MCgwhpVVaXHMqdLCUKD4TNqtWMDQ0pH7pt7SOa6YdDalj6Reqdu4c+GbkLRVrALZWMLygFpuKJ7I2gist8bzSPLPITupVwdAJ6BXZXpYoK6DpCvmW4NK3q6LV116/m8TXLpMpU605lxUXAtHd3VExIwv/O8jBWPEi8QrA7Xb0tLbWSBJyTKVt8x+YRYbNrXH5Ozy6unSliME4l
 G80jMwph
 ZZQPnEk2joOB7xSdtBbmVXBZD2R3Nwek5E0qtWar8k2R6sh3ySA3yVolQowJvsAjWsFBwiV5pbBrGWXU3rkJedjYJLw5JMIKwCLKM+k28PUsW+Yj18fuJTlWSew0YDQgutr2DBJqvwTmg3fmOLjvG5gy+qs3JPZryGGT7qNzjP4Lpwgou3wmrCusLHzLvouuaaipWC+bGAOrdMCPwVdI8dO6njHAsG3Z6+ZpAniD0rNlGoOfsvgq4niq8wjtdwOxRyfq5MyJOaY4Xt1uUprdJGMKbkrcU1E5mbzOD8HTu0ggZRq2kK1PC7taxJQ9dY3VIXAmg7qzZ+uCDZQFzoB63t8IgWBVCJY5L7BnwWHmNZqFNCNuX6l/jwc8Kww==
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


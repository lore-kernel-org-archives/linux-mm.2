Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E74BF44868
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99BEC6B00B2; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9254A6B00B3; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 751B96B00B5; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 503B26B00B2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 183F71604BC
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:50 +0000 (UTC)
X-FDA: 84642857460.01.5723C5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 540261A0004
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fFKB4S9p;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21sdvKbt5sXQeuruY4QQjY84kL9SegytBsvmB53RIu8=;
	b=aWTr0XnKHMyp3wxWJsOl5nV3+XY8aAkYA20PG5JaC/3hdK6nMcOOt7YfM5zfdY2O+CP8fe
	6goWp7aXpPH3LV290+QPw9br50CbI5LhY2mMRJ4aKrbVUmxaA765DVlMnDnUeQQpcflYoR
	iF58opoj/I0IPmZlxq4MPEYbpIVPcWQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fFKB4S9p;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830848; a=rsa-sha256;
	cv=none;
	b=5DxrFYlRFu3+vCxekgced/Dy5PoStczd0OBY+aycWFtePc/RcH0N1DCDtkjQHswDG96C6j
	I2mcOALrtz3ctVH3ijJITw4InbJx9k5nY0Kn3nBw6fCLTqx/v0fgnbzrz67VTxHBFmdHpW
	0oAAzP9JPECV6wZsfuZk/easaJ2dQpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AC38445AB;
	Fri, 10 Apr 2026 14:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A766CC2BCB2;
	Fri, 10 Apr 2026 14:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830847;
	bh=fJkIAWWlo48QPdeJ9YXUoXHCIlYHiM9shoj6TYfrLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fFKB4S9pndS8ojZKsfjMcXM27eJslDp78XHI0NS9OmbQ7O7I1QKrZqF/45Re8ylEg
	 SQQxR6sGPFkloqKDy4nX3Nr/Um8QPprePEAvQgQ4DIVuyGzNPF4B6z2PCeQvO4BhcV
	 2VzoRVluXQ6jSkSzftsAjr4egOXBj/HQM6Fq0nCy+A5WdFTsoortEpxVxcmiqAd6zq
	 xSpN9liedp1cllTnDxF2fk7CcIqexh+Nx/AgziEvYnA2YGbiTEH1wn2kW6ScmYG+X/
	 5ZmAaw2unrc42cMKZdiAegmpmGfeG1uUyBA7ke6AFweWGzQo8CCvxZxHoK66sNZeZP
	 VGpzA617ljYIw==
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
Subject: [RFC PATCH v5 06/11] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Fri, 10 Apr 2026 07:20:27 -0700
Message-ID: <20260410142034.83798-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 540261A0004
X-Stat-Signature: miqgbf7hmqri4kf86e4fneu59t9ta3bt
X-Rspamd-Server: rspam06
X-HE-Tag: 1775830848-499684
X-HE-Meta: U2FsdGVkX1/LkE47hI91+k0pvEquwHhDMLHGvNaIXblaPErxCEvtTuhmGvV/F4WzgUcsEkYyoESuIAVoQZKr3tukNeO9C2ckm8hw+x32Avt0/mk37GY4GZS3HZs8ofD7zZT2ExV21ZzhcKYIy4mri2i08PWqh1mQyDK/WnFvdjx3IqHs8/wC5omBUNc8pB7CmmAfloj1+JgJ5dTaZNdezC7zrsXjI7yeTvnIcTSLNBdUxHOWBAf//WxP96iAP+rPy+JvwyMu0+s36GFrPDGRawIp+Vt0WXqIOrV/gIg7LlnymuMOdGV4P8zmOoGLtrAkTf0PbvsVFA4d01H5VascKkDAMwyOJDmfqu3KADCHZtnjvBHlMT9CA8ZTGtkEB0zhD0FbKuTgzeOTH4sa8a6OXz2/W8m7/bzRzWL9QN2aurkObre9Th6P1VsBr4FmMHlxH7bkSx0m1iL4Bfq0LqXg6/Fc1N1kjLCRQpNuWLhJb55xXG49Ecv3z7QO22XEH/FQb82F38fA78b1OASCruvGvBX14KkEOnAprXXas9IAh3FTNHQWn4JkX7Mf2BH3J6K74mQ6Pl6woeYBpaTvawQVmEd+mRp5X9uUN7yzEWzho+IsfCHpxLtQPFJCzJQzsP45xriv81oH2Dr0uUi1YnGC4W+i/Hfqve1eicMe0vrUmtYmvi+ASqcI0iedoplh7LpyFa13i3BqI20/ny7HJDg0o/HreWueIdU8cUXjD2j53oU/ShBiUmWT0uERYPIJJA9IghUk7ntXeQOPh5PCfMmq5WIOscjmjm6es7YB8hIMGES6QbWT9dLqgdnDF1/fFeqAnLDOIzMyIpJWc4O1e/fkKIu/U9EZVCegnC1W+JVU3wsyZiCTaHTrEBrtFomwU9e3e79FbpDuvIbC+ZrzxKsbxlKy79immGCJ59aun6lnikG/7IiVDW8EoKF0ptL2zPq7rW5bmTVWX/4iPTNtOic
 UtZlKaYQ
 h2DKcm1KPgZCbsR80IgMhzoMcFbfn5QzU3pjeiM4CzSypOKdhLRAGXBsDNTy5Fvt2w2Wen2Oec5HXpNaSzcsYnfNbG+xxTqNLPAs/hdYievRJS1RlSAcRqO8iwUX9rZneHGDO+Kldv+CiwvRRLy5HQ7jlXgcWiigny4U7Zg48eW5SscJRRYNXuCSYPGMojlaqW/RjI0/gywV4s4AP1jKKKyy6W7fDBlf/+BMClRWMuJKQ3H3isO5ukW6A7P8QxxzKTIDv6xpsGXgKZBn8XQHYc1qpWAW4G3tG5tLgErIrxgiPdD0RIqJE2YRABCb9wCvi77bmsH3QSHiOFwBDN8E20vMoCwxdIyg4BViumBduc5Z5Nwz9DpmWaQER2Q==
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


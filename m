Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 117E0F31E25
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E206B009B; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491F46B0098; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F266B009B; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF2516B0096
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 979BCBB576
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:03 +0000 (UTC)
X-FDA: 84639231726.20.87C1882
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE4944000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sfMH/rgI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744521; a=rsa-sha256;
	cv=none;
	b=cl1KGqekOoRgUDAVohNQOaoVw20Dq391LKIqadiLXl47gvdYShyaOAnFZHQgJfSdpj32WD
	OZiR/MwtOAXOtWMhhOwYDPLAG0QnmtDWM59556QF4bc8OyPXF/8gND0xlCjlgkm5ryvmRT
	7QHdPAHpUeomaaMhOkSy+cXbFXqkk1E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sfMH/rgI";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21sdvKbt5sXQeuruY4QQjY84kL9SegytBsvmB53RIu8=;
	b=1e2Hv6tXLTj9Jo8clpyxy+MIfkZ0pRkjyZwmejtAJXpDgr8jXtBEvP+bA7MRIHucHMjf2d
	H1fJgkKobi+5fJUUhcApwNbkGfJhJP6lxGDyzbQrrmi7C4AZNOkz9iWiXtt9VNK1qffLoE
	St5lkj7Cy23yILoUxGtHfrh1UsRUqMI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B453A4465F;
	Thu,  9 Apr 2026 14:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67D7C2BCB7;
	Thu,  9 Apr 2026 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744520;
	bh=fJkIAWWlo48QPdeJ9YXUoXHCIlYHiM9shoj6TYfrLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sfMH/rgIG23R2sVZou/u5urM9GEPi+de/rGnn2mbfua0OTdBpCdO/Q5LfZLGQUwPo
	 LrK7xdRuwGKThJTP5bNOOMJXPSYojXqsFGeszk7yh0O1vHR17EI5OKDdB9D2PIXEs5
	 NTaQP5oQq50VF8jzjNccnyE8/uzcxuZC5F+lbKAD0WaNuosq1lqi1wLPNspl1r/mVH
	 2FttddCEr4OchxohDhW842Sj72elGxF0mIhT6y9beNIXOFBcHJDFyw13jRd8i8NId5
	 4E10sR2UjJjAS9MjsabTTC09Bqd5D5kVIIP6ofGGLXabNN+MnRszkJlucctj1qwJbP
	 5vk7mCfBGkLOw==
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
Subject: [RFC PATCH v4 06/11] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Thu,  9 Apr 2026 07:21:41 -0700
Message-ID: <20260409142148.60652-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dhu1kfezsqruz6oyodn7tbyjcqsfyxxq
X-Rspamd-Queue-Id: AE4944000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775744521-148837
X-HE-Meta: U2FsdGVkX19RFvjEd3Wfs3bXSeKywBMdvvqS1WUEzScqSqasCKOInTDcOKl5bqgrdft7fTsgNA8azuQ7z01i0tRZwiKi4whOHggXNJcSIJDXJDH+rjLRmHwIyWklV0/2wIx1wqMbyjDYn9NULTulfaae/rX1eeyU/mh9GPSLg5ojUwWiNlaWtnNdrJXmcW5E6eSF4jnGctz+ML0X7Nn14ldTcxlnHJo6zQxVbystb8cRBCCiFL70+TjeU0QOH3yul+ovnCKszNMyqpQZ9DHxpEC11QGvgDaE9Hd/XRPeuwgdVZKJsDBEHoNWqdHGdinZ7ZdtGQhoLFu3P0ctHcWOm2aB4TX9HoyeUPSKMH2iznqB/N+VyhrEYAwQVCJ1jI3iQPqLWbRXtL2g6ROjK7t2RS8xO417W+KWQPfWGYxb9gzc8q4DAbTBMg3/0hWchT+P1FNESK15M3rIqvR+N1wmLHmtWWKXpUd6EXaQuBqwbjY9k23kTPmN9obUVaB/Qlz4rrduMfiiq593vTYFzpLrT1/MqmI49VRiMlzxfWjOGwmADg3teSkt5RCHEvpowLrLRLLgQI3GN98THBWckjQauh8X0gk8No2U9675WsCo8CZAmg2ex/oMIQFNsZTxWwjagnztV9PjucJi2GWPt5xEhVJlOjThas4tiMCN3eiV/RiR5PWe/Tc420v476/+XXhWJZwyzTJDHv66OJFZCDrCCiz3gxgNN2cTAu33bLTg/CgudeKcAIiXaC3VuPRK5RZHdPJWgEd0b0jvCKWTsXqKx06csxeTwsFxxeRASzqRr3Cf11vxsR1DIwWfUf7PWr3KNBp5HaU58f+S1AR8gJni9sTR5VhnrZyEPx5ScQvWZypGexx7mg6V8QfBSpl0V8iIpR0Waeg8ue8OVnIoorsB20NN9fOTws1fwSowJbZtebCqGO0bV1fmSNmw5KsRpeiyyv/UcyQcwfXyOWXaOzJ
 0g4AVNJR
 MTzt5USBcSU7TvFL8YM//EDQHhwcEb3Nsjm1z9GN0eXMzxBMmIrKATRBOkucjmzS077kcuu2XUVAgU6j8cMFGO3+N2MQRXq8XLhQu0DHzG0Su4PzCHrGwaRDkR8fQ1Pi7bvl1vq5mm3liRyJW2jWB+0kgKQkVtHm8j/vYMosjr13uc+z9R1FxS5k6k3WN0CQ4/7lMGXLmBqM5dXxS8782KPIZZLg7eoK63fc79NsOT6FrRYBga1Mz+CMJi63mC4HMQR5LktLOJijfctJQuWKbm5Ndlv4JnPBoY2X+/DS6oM1EJm3Qxb7KcsZZBNfvBgCxZC4jN1gEdWQ3iaZ93TIMH9vPgkkog2A/sQG/aG/i1R/U97NtTB7tRHPH4g==
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


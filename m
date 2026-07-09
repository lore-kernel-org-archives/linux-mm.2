Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A29C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3B7F6B00A5; Thu,  9 Jul 2026 10:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0ABC6B00A6; Thu,  9 Jul 2026 10:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9660A6B00A7; Thu,  9 Jul 2026 10:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 713A86B00A5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09506C09F4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:13 +0000 (UTC)
X-FDA: 84969412626.12.82FBFE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5B3E2C0009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4231nrm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCjb58wtAAk5F9PdDMQvKlFN0DE7q9fXquVywqvC5OU=;
	b=SF8Ft573is6cgxH/3y7TveG1i6AyWnxIonFzLDcpMUikMbZG2132+IxWdX0NfuIM9VOL1N
	dHG1S/+K5Slgl1mq0R2LWkhhRDRYjWqRwmHHYpqscU/5SKboSR+W34xS6U7Nxw2fb9K12f
	ZzdjysN0u4LXqgZKipeXxKhiT6j3CvY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E4231nrm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605971;
	b=WXIt0r8AfoLiSfvpTCqVfQwofYtw+AuZbMQBuWOYCWx8jo456+2mLi57WXyQ64Ee5UaFSk
	1duWdmmi8YsbTySp7wtZigLtvSqTpLFSkOslm4JQqUHxtBGrjcWJSTZNZCyGs/MXfCVz97
	lvuqYSPM5caiPJ16XwEHhhV+TWL7cQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C59742E4A;
	Thu,  9 Jul 2026 14:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE301F00A3E;
	Thu,  9 Jul 2026 14:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605971;
	bh=CCjb58wtAAk5F9PdDMQvKlFN0DE7q9fXquVywqvC5OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4231nrmhGQ5ukLReRLVDZIAzyt76r360wdxDclPmJDeyjYjGCBKhJtsTzRfnbKjU
	 I+4TC21pOjR0PVu3Hpg259SLeMiFCqYDkTI39jWMsSZbt69rgMFXyT+Lpwynqo4T8+
	 ZQgT21Sh51dG9qNccfgdSRXtUutErpyCIkcsvPsd/IBChclIHkhRgtHp1PR0GSrgyV
	 DQj0+sCMmbPfvhiw6verabX5TA57H6ikmVSjKBBb8TsdmyKeGK16mzbVBU/PEaghPn
	 VqJTgjlw+wFU4pw6MsLNkWGsYOF/ijEaJzTC/HrB2ZUTKy5EI2htVNSH2E94Noi+sC
	 KDH7QE7YevxwA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [RFC PATCH v1.2 18/19] Docs/admin-guide/mm/damon/usage: document weight sysfs file
Date: Thu,  9 Jul 2026 07:05:56 -0700
Message-ID: <20260709140600.90950-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7x6c4x9xqbqa1pddnspw64yo8d8cqgyu
X-Rspamd-Queue-Id: 5B3E2C0009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783605971-86071
X-HE-Meta: U2FsdGVkX19IkHUzrpG1SKqUcDkOaUGl8tTTg1ZzosINTwyS05197bIOYuOQDCbZtu2NQ774z2GVLmNXjrYtU9JypFUEDxeczgLJdu3bdN/Fod7Uc8g7JnGjC04DF7QsuB1EJb5CB+vxvve20aoN5/BIQEZJETlyM0aDr6aDa9aWjx7GZNJmq9fBpXArmHWgrgmyTvjg+32Kdek6wGt8a45Et5Zy4EGn0ugUyvoNRDSeFNTRpObrjKddXCOYr58FeiLtXxTyudUIdFhSO7piV9NWJVsTkWAT6pzZjC1aH/fsgoeJ7PDaulUBKdNDKAW7nS+rj/7AS+y6tmomzJ8YLNARq7H6CNDy4odm2Z6G0wNSF0QD87qz+7OE4/fmYpvM7htOddZ2+bWcMWNSClUy1ElEaxuBkQH2MIKBPbQ+5Oxc7DOA8Iwlu8mhcNfTu+sRblKvyBP4r8ZQdrFcdYrWraxOrWN9B+7ZRSAOCqsM9RAENh0fz06KLj9r/+j/2qslziX8bnMbot4ZoNzfOz0owCSgELMMhIko/tSyZnJIhkTMmgXEW2jCcNDbVXXs7yErL4acn7GVTMy6mt2RcesHBpWwbvTaUGPrQFVYACmEa+TKU3TJi37z4yUI6m7oPncejHXT9xP9fkspJcy5j6aA8vSqysDyWV/+PcJ1HEN83olGzMv64HeDZeEJ/SwVyaDPspmwZAbFRMiIbkaC2qmMN2RlxQEH650aLOxfpXtQPzTRAr6B6uzp7Xopkdr934o3SyWhV+oT0ZHacL8W/DTfdFQ4eRby2j7xnxLKFGEN5YvB020TMDfc0GZzlIyw4Aa9RomQMfA5s0r5w2ntjdxEORJdLAzAqNt0amR6Wkrdf+xuxy7D6xwr1gNE8t8gwNuTZQDg6xuaCLKhlI+KTSE5a8mExo9oShILkKH3XoShurrDqe5z+fda/wLYQalo20hW4V+HcbUptCdg0FTqsp9
 M3RJ6Y8Y
 y7fbNk+mMZf+OLNGGxbTtsc0uOldG5XV5Y8PfxLVaUfydENFaYQCWpJvDmN4eqaxmgM0trz99NQMQOHx1C88E4kgJSqfVEHVdFlGvD8aGfvJmRjySITlYqiNZfGUPAlAlB2twBeIp+WXNB1AKF47l7UVXk6IV4k/1kqcHzdanyRZ1vHCStbM45s/UYbdt9j00m606wxZRzCBZjjActRHlaFhdJfv9aniqTgru20SExRN9m2s8Ov1Yydq7/7wtZx3P54YN17EGbHSkKqthSEW87x65yIK3ERLqi+H7bicxM0BXW7ptQzIeK/wvBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for newly added probe weight file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 ++++++++---
 Documentation/mm/damon/design.rst            |  5 +++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index b2649ea011f93..da5f9afd08aef 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -73,9 +73,10 @@ comma (",").
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
-    │ │ │ │ │ │ │ 0/filters/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow,path
-    │ │ │ │ │ │ │ │ ...
+    │ │ │ │ │ │ │ 0/weight
+    │ │ │ │ │ │ │ │ filters/nr_filters
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
+    │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
@@ -286,6 +287,10 @@ In each probe directory, one directory, ``filters`` exists.  The directory
 contains files for installing filters for the probe, that is used to determine
 the data attribute for the probe.
 
+Each probe directory also contains ``weight`` file.  Reading from and writing
+to the file gets and sets the :ref:`attributes-only monitoring
+<damon_design_attrs_only_monitoring>` weight for the attribute of the probe.
+
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 6d79e7d69be84..aed6cb1cf4831 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -316,6 +316,8 @@ Another way to do this for higher accuracy is using :ref:`DAMOS filter
 information in page level.  But, because it is operated in page level, the
 overhead is proportional to the size of the memory.
 
+.. _damon_design_attrs_only_monitoring:
+
 Data Attributes-only Monitoring
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -336,6 +338,9 @@ automatically turned off.  The access counter (``nr_accesses``) will always be
 zero and not updated.  Hence the mode is called Data Attributes "only"
 monitoring.
 
+Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how users
+can use the mode.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE024C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:15:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074E46B00A5; Wed, 23 Sep 2026 06:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C936B00A7; Wed, 23 Sep 2026 06:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB786B00A9; Wed, 23 Sep 2026 06:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDA056B00A5
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:15:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DD551A072E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:21 +0000 (UTC)
X-FDA: 85244619642.24.9F57E86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B6DC1140006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:15:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXAMQy+E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1gVvDIreHP8ao0G8tKQqDlYq/j2WrsMakNo62d+qXY=;
	b=KLZSS3g5/fR9uTjgZ0j3PFo19x19B88vqgsiRbgURFFaJtqSoKjGy37aLKa+NHZfGPH8YQ
	zOX4VYN8sOYc32Mrh6Ixoyuaf3chZifwEkL0PMn2vpfDhcv5l0Nb5Qr1GvtNBa2jvhuV3l
	VAkRG5KTNRB18VNuEGIAaU90BRixXDg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXAMQy+E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158519;
	b=34wx7Vn2lP5rxmeGDFbjpN/KvptroiIawJSNOL9iaW5I7rXo5I+t3VRDbRBCI6vtD2EO8p
	VEleL/zqsNWI7Q5vc+BdpfrOarqYT1jlBPvVFjEPGq/nu9C5sSPIJ6GSw64HFsomGrjipS
	9L2RHAmjhRUOZWQOdKbUgt/oJLsFWC0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B14B60210;
	Wed, 23 Sep 2026 10:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E7B1F000FF;
	Wed, 23 Sep 2026 10:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158519;
	bh=E1gVvDIreHP8ao0G8tKQqDlYq/j2WrsMakNo62d+qXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WXAMQy+ECbR9upWSg5m7sfptdxReQTIJ+VcV8tEJtuZHBX5pPtdQQpUtBNHBp0Doc
	 tzioFXHYc4MDnaTQjR0PajdwPQJJomUI1kHaClLcMCwHuDpXHcecx0ULs5i16aTTIh
	 IUGraDUXbnGj8gkxEIIxNRnKzw4keHrB3w/lRqMQgj07CVgVhT5vw8b9AtDU2Lp28g
	 IP1JqzstB5ADjIPJFGYhQf8kSUKkKDYL1OjaCG2EyknvacasEJa0xvaUOmCYhpOtYg
	 jguxHJo2h2mFKHLUqNcHypdy6g9MhMFgJVtFlE2wCxm4NSIWdjcXJeMXKIgP+wYjIo
	 w68cHUpPMmaew==
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
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 6/7] Docs/admin-guide/mm/damon/usage: update for quota goal complement file
Date: Wed, 23 Sep 2026 03:14:51 -0700
Message-ID: <20260923101454.5748-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260923101454.5748-1-sj@kernel.org>
References: <20260923101454.5748-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7sbydputtpsnq67b6m4wt95t9ui3yrkq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6DC1140006
X-HE-Tag: 1790158519-535560
X-HE-Meta: U2FsdGVkX1+ZmhTYrGXlzQa19t3PEk1J0+PYQecqmz4iYGKWvFJHj3LHCMOxmE8vQoap6mbB9zrfnre8CMGgrbowK1tE1LWB6JpUuCpjr0uRhoUPvZofM3d4U7ZQmYPgC0pnqrd+MdxXSJo4q0VLsMP10u/TaWFYW4DUHSUOKnDm/cNdDvpnsewYHUXQ+Eiysww8/L4brZIplKBH36uxxDV6DVyjOwheXvR4F6mu0c6intj4mBWc71HZrrIQBSgLhYbu4CxmdYcMnm7IHA0KxV5iTIJyleTGHZn2XW+DCYr/f1jZ/ZxpVbWxnxf37WPKDZiU3ZYNm+FJD7tlUHMvt5T79YQ9RSpDclZ2BR+PlBvJEgnO4S3fYFtOTeC2KMUhnAQzQum1FZlo26HeKhCoVwW8oMLqOoMaMVZINS8aRKNW8xL3OtRNuD+Y+mw/5knIwbtpAJbXJZvDaiykjlmpe3YDcZC3jKS+hounenLejQuVZI/vubuKrLTXoA/zBz5UdD39M7Eg1GVpeOCoaDpTMoKPef6CBUh+piTDSpJP/sgjBiC8QYZnRs+UOx8mc2e5gQIXFAwo/4HoO0vyRF7GPGGHArIYos1U1Rh1ScAjX/HHzRO9ApzhqUHuslK0CLlPuVRU4DWPa3XibdXxXK7MWYDz+wIa9Vh5RqR2A0pM/ZJfq/+VsNoHv2IY9TD/wrdIpQ1oSabK/fUfzyVk78s94EN8loNAL5AIiSEmsPbrnxY72+DIWYBBDv0JjaA/5ULgNb6DVVIxMzqZhmhzz+h2v3GylxU2tnuOpCWWU89XeKZ45t/hVeVfD7rtsXVpp59LtqA+hDyW4/wle4v3abyah3W6i4vXkcPjMvqPGFDx9HkHAOGpF/oxCBLItVo7wnK4RbXj9TA8MI9HP6VnSqKMnKaYkBnWJ4o+UkTTk8UXfcfoFyaKT7tTFgxwAYWh48ek/Qvp7GZfYeD3uLnwo3v
 UBpfH5YO
 jZXN7C3kIaUlJZ6uyGKzn5B7Zn1+NZLmHZJnu2paK+PIXQ+Wv6ggyej+r8d1Ctm9yXAIkir3F214B8g92NY4XFVbP+ooK14gqgLADkpbfI3XvHIoA68nDeeUyDkBGyNR2ZDKGdbbfX6vtEbOnFBmgfhHc8V3LvX9FSbjGYIryGDbHhSd8+WkbkttL9pdBpNuWTlA2N3Km1TQtfTkCd5V9dA/1JxEwDpqIy7ufzchw4ZvczurTPKJAFtCINNBEfJYkPb3HLLnc3lmPqxQtnqRTLiZjuBE2nD3ChxfBakkGC7ScbV2XaElCmIM1fA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added quota goal metric
complement sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index ba4725544856..3d43954c7046 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -98,7 +98,8 @@ comma (",").
     │ │ │ │ │ │ │     fail_charge_num,fail_charge_denom
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
-    │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
+    │ │ │ │ │ │ │ │ │ 0/target_metric,complement,target_value,
+    │ │ │ │ │ │ │ │ │  current_value,nid,path
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
@@ -492,12 +493,12 @@ number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each goal and current achievement.
 Among the multiple feedback, the best one is used.
 
-Each goal directory contains five files, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid``, and ``path``.  Users can set and
-get the five parameters for the quota auto-tuning goals that specified on the
-:ref:`design doc <damon_design_damos_quotas_auto_tuning>` by writing to and
-reading from each of the files.  Because the kernel does not update
-``current_value``, reading it only makes sense when ``target_metric`` is
+Each goal directory contains six files, namely ``target_metric``,
+``complement``, ``target_value``, ``current_value``, ``nid``, and ``path``.
+Users can set and get the six parameters for the quota auto-tuning goals that
+specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by
+writing to and reading from each of the files.  Because the kernel does not
+update ``current_value``, reading it only makes sense when ``target_metric`` is
 ``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
-- 
2.47.3


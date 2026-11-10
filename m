Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD58A606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQ7GIrC6
Received: by kanga.kvack.org (Postfix)
	id ECE186B05B1; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE20E6B05B2; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F9D6B05B3; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A67816B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:06:09 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AD38120868
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:06:09 +0000 (UTC)
X-FDA: 85417418058.30.109BDF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 77D13180005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:06:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQ7GIrC6;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794272767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnZqF6L3cakkpOkBPQ3GBgvr6hmKQH8Z7qMlUUiyM4U=;
	b=ov8wRP8NUsgVsokjDiGBHg/LWH6qsOGH+LXIY3aYGjDq4etQ3lHE6/JQzLGCnWaCzyqPuX
	T35C326HdCvEyUonz5+aXbb3gLSsHj0S37j40eFwZLLP1w/xrP8qhGWr9/g3RVznTadVqJ
	eA9baZXE+Ibx+NxePdFLFCCQBgdyLag=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794272767;
	b=Lh1JUk8f+NXEdssTbHF5U8cFQ2H7uenXlH/DBAJ51eq+kPmqXW9iM5NGTv6zFoTLxFAakM
	ut7LCd/0ujJdvkVeIHM2iZu5JS/+VeZSyLAon29gB+dllM4K3OHKq4qYfi313zYWx3YbnX
	Wggzzb3gBqedRM3eulJFo9DLyfC+V3o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQ7GIrC6;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDFC045C05;
	Tue, 10 Nov 2026 01:06:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425151F008A4;
	Tue, 10 Nov 2026 01:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794272766;
	bh=WnZqF6L3cakkpOkBPQ3GBgvr6hmKQH8Z7qMlUUiyM4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQ7GIrC6oQitZJAS2Cilru5She+e9VUU9yjN58IVZ8n2zsdlYUvQqqYuHEWBQbnCD
	 b3MHGaB24x5nPUUeUJrls3KIDZX/YPf25eF32VjoO99Vy12dnKbENksWixVcZeed2N
	 UpNF2TRN+95z8Ep2ilNoG9UEiLwtODLFR5JdN02vupSxq9NyfycpQiG+2AcUPvyJT5
	 cgkp8p4Jv6ymVWkzMNT6fq7JT7VNVpc4wr2d6ui/+U2tRZUoJbpNt2FrXRWy9lqlej
	 46BiC9eIEPa2UyWlEPpoqeJTdUZDOWRS8523zAxG/LasRcwGBHDnwK54OScaT9gCT/
	 VCw9s0O+WBIDQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] Docs/admin-guide/mm/damon/reclaim: improve language
Date: Mon,  9 Nov 2026 17:05:57 -0800
Message-ID: <20261110010558.104905-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110010558.104905-1-sj@kernel.org>
References: <20261110010558.104905-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: wr6radn3r99hmmmydqsr9rfzweap4r7d
X-Rspamd-Queue-Id: 77D13180005
X-Rspam-User: 
X-HE-Tag: 1794272767-957389
X-HE-Meta: U2FsdGVkX1/b73fJVIUVBYwf+/JQDDwZyCKhaH8vadvor23eZrH0zkLPEO5by9228E+k0787TF28T49IxY8i6DCPm/ZUqnEcyGrWclFA28e/v0ksV3dbq+zyla9ihoKwmmsXrHm1nJ6ruc5ZYwPVp0TFbeAKZdJF1TpZ0ksPx1DVGR0HW0CH9UY/CLcDmuF6To3HcxmmMWmERHVEUzsKDq27YC/Vi8/2w+I6B2+580o2us6cYMBTDYf9Y6fjszFBOIF69O2+P5cdBWRfBnl9aKGIQbXWEm8PeRzHhXyJLnN7koWKuUo9EEcDebdMk737p3AcPnariPalJFzYblVWWdIW49onw7wEhRmYx/UFqOLDFAHC7iEXzsoJVnOFTKocf/z1oLqrK8MOwZQq0SvHwUPpZpfw3YD7xx1h8/J7qzyPjRXZryTXLv2sEoihxx/3PFr84z2ig9wbVi9UysQfOs1kVeMvp9KvSQ0ZslVwHf5Kmg50NEUv2pVgk8sH42ctd+54m+2gIKQpvo9ePwswlrcfkVx1QhWtnBCP8jih83dfh9KH6B9+PqqqeEEAhL1+ksi74pYAjv6W6Bko0gjktbqK58OOfEhEAyntXNOga4beKYhKRqLeqR/t5JlrEgYkF/GYF3p7HANMwqfUBOJbnpPyHz6xE0XU/KNw2jiG6V4KcYzmjTXO8Kl1DHwp3SHLSM5nKrFEPsHvoKdK/F/E4Q91kqPSlPeZMWIzIgGfpo2VSIlC8GrHiDO6TC5QXU2TvztQvIWit0t1NmdiCiXGvmSKrCgN9NXD89sJK+aCVv5SYbZ2WrbqPW1/KNK5Gob9Zx3o1GLKMKA7L8vDevWLaIpQ1cGnLaXRcqf6Am8ugx6s17b7NshL0raPCaBvyL2ydww/B3UAceHqxqwhBgqQs4R/PtX4NErJsM981qpCD5JhJsa6Fu1cG7/Z5dLmJ72cw8qR9dL28jD6BSo1T3M
 lrI+Dm/+
 KgNJAx7iO6qM0pB4ghU+mlN65oJsg5gNwiCufvDSGAVXdHdhr5kYiCfCUmqmC7zsaMFhGJ5agabAR8Oigjev7RJngWEnNwcx2UCzNmSIQCIAnzLLyMhRAXjlrOCqqDd1U5A1GAsHtSUbnNdEkVdBGMJVI9O0wbT5PW7HiHGNTq/Xinr359jJPfYp/Ir1X3wDGu6YTp/niu9opSeeWedgZh2uQw4jUvm743MmPMNta3PRShoMv1YjskjL4Lx85Xh+Tr0ft7qH1ettIRnT6logyE6hDHAXVM8ETWEmST2tE09huETdPVNUizWndRmdA4YhaVJb8opD1adD81stq/OWTcSf07A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Manuel Ebner <manuelebnerli@mailbox.org>

Fix upper case.  Fix tenses.  Replace 'set as' with 'set to'.  Add space
after sentence to make it double space.  Rewrite and refine complex
sentences.

Cc: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v3
- v3: https://lore.kernel.org/20261103120043.100887-2-manuelebnerli@mailbox.org
- Apply two Sashiko suggestions.
- Collect R-b: from SJ.
- Rebase to the latest mm-new.
- Wrap commit message for 75 characters limit.

[v3]
 Combine both patches into one
 Incorporate SJ's feedback

[v2]
 https://lore.kernel.org/all/20261027185938.2526259-2-manuelebnerli@mailbox.org/
 Include suggestions from SJ and Aveline
 Split [v1] into
  [1/2 v2] Docs/admin-guide/mm/damon/reclaim: improve grammar and style
  [2/2 v2] Docs/admin-guide/mm/damon/reclaim: rewrite complex parts
 Fixed an upper case and a missing double space -> [1/2 v2]

[v1]
 https://lore.kernel.org/all/20261015080623.808458-2-manuelebnerli@mailbox.org/

 .../admin-guide/mm/damon/reclaim.rst          | 45 ++++++++++---------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 028947f5da8ec..0ef784df98680 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -4,7 +4,7 @@
 DAMON-based Reclamation
 =======================
 
-DAMON-based Reclamation (DAMON_RECLAIM) is a static kernel module that aimed to
+DAMON-based reclamation (DAMON_RECLAIM) is a static kernel module that aims to
 be used for proactive and lightweight reclamation under light memory pressure.
 It doesn't aim to replace the LRU-list based page_granularity reclamation, but
 to be selectively used for different level of memory pressure and requirements.
@@ -30,12 +30,13 @@ guests could mitigate this problem.
 How It Works?
 =============
 
-DAMON_RECLAIM finds memory regions that didn't accessed for specific time
-duration and page out.  To avoid it consuming too much CPU for the paging out
-operation, a speed limit can be configured.  Under the speed limit, it pages
-out memory regions that didn't accessed longer time first.  System
-administrators can also configure under what situation this scheme should
-automatically activated and deactivated with three memory pressure watermarks.
+DAMON_RECLAIM finds memory regions that have not been accessed for a
+specified period and attempts to page out those.  To avoid it consuming
+too much CPU for the paging out operation, a speed limit can be configured.
+Within the configured speed limit, it prioritizes regions that have been
+idle longer for reclamation.  System administrators can also configure under
+what situation this scheme should automatically be activated and deactivated
+with three memory pressure watermarks.
 
 Interface: Module Parameters
 ============================
@@ -55,10 +56,10 @@ enabled
 
 Enable or disable DAMON_RECLAIM.
 
-You can enable DAMON_RECLAIM by setting the value of this parameter as ``Y``.
-Setting it as ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could do
+You can enable DAMON_RECLAIM by setting the value of this parameter to ``Y``.
+Setting it to ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could do
 no real monitoring and reclamation due to the watermarks-based activation
-condition.  Refer to below descriptions for the watermarks parameter for this.
+condition.  Refer to below descriptions of the watermarks parameter for this.
 
 commit_inputs
 -------------
@@ -66,9 +67,9 @@ commit_inputs
 Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_RECLAIM is running are not applied
-by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
+by default.  Once this parameter is set to ``Y``, DAMON_RECLAIM reads values
 of parameters except ``enabled`` again.  Once the re-reading is done, this
-parameter is set as ``N``.  If invalid parameters are found while the
+parameter is set to ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
 Once ``Y`` is written to this parameter, the user must not write to any
@@ -88,10 +89,10 @@ identifies the region as cold, and reclaims it.
 autotune_monitoring_intervals
 -----------------------------
 
-If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+If this parameter is set to ``Y``, DAMON_RECLAIM automatically tunes DAMON's
 sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
 amount of access events in each DAMON-snapshot, while keeping the sampling
-interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as
+interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this to
 ``N`` disables the auto-tuning.
 
 Disabled by default.
@@ -113,10 +114,10 @@ quota_sz
 
 Limit of size of memory for the reclamation in bytes.
 
-DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
-window (quota_reset_interval_ms) and makes no more than this limit is tried.
-This can be used for limiting consumption of CPU and IO.  If this value is
-zero, the limit is disabled.
+DAMON_RECLAIM charges the amount of memory which it tried to reclaim within a time
+window (quota_reset_interval_ms) and stops trying to reclaim memory when this limit
+is reached.  This can be used for limiting consumption of CPU and IO.  If this value
+is zero, the limit is disabled.
 
 128 MiB by default.
 
@@ -137,7 +138,7 @@ quota_mem_pressure_us
 
 Desired level of memory pressure-stall time in microseconds.
 
-While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
+While keeping the caps that are set by other quotas, DAMON_RECLAIM automatically
 increases and decreases the effective level of the quota aiming this level of
 memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
 per quota reset interval (``quota_reset_interval_ms``) is collected and
@@ -223,7 +224,7 @@ monitoring.  This can be used to set lower-bound of the monitoring quality.
 But, setting this too high could result in increased monitoring overhead.
 Please refer to the DAMON documentation (:doc:`usage`) for more detail.
 
-Note that this must be 3 or higher. Please refer to the :ref:`Monitoring
+Note that this must be 3 or higher.  Please refer to the :ref:`Monitoring
 <damon_design_monitoring>` section of the design document for the rationale
 behind this lower bound.
 
@@ -267,7 +268,7 @@ This parameter is for setting and getting the :ref:`address unit
 
 ``monitor_region_start`` and ``monitor_region_end`` should be provided in this
 unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
-``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+``monitor_region_end`` are set to ``1024``, ``0`` and ``10``, respectively.
 Then DAMON_RECLAIM will work for 10 KiB length of physical address range that
 starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
 
@@ -284,7 +285,7 @@ skip_anon
 
 Skip anonymous pages reclamation.
 
-If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+If this parameter is set to ``Y``, DAMON_RECLAIM does not reclaim anonymous
 pages.  By default, ``N``.
 
 
-- 
2.47.3


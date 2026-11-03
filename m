Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13348606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=oCXj5qzc
Received: by kanga.kvack.org (Postfix)
	id 1DB776B05B4; Tue,  3 Nov 2026 07:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABE76B05B5; Tue,  3 Nov 2026 07:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A0F06B05B6; Tue,  3 Nov 2026 07:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C60236B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:01:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F228403D7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:01:15 +0000 (UTC)
X-FDA: 85393667310.27.A8E4E9F
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CAAF140008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:01:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=oCXj5qzc;
	spf=pass (imf26.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793707273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O9atIHlIh/2xYLtt0bx0cLcke1aRGKizVOlpIySp6oE=;
	b=bLNol+OfvK/HVMV2OEWlUaz7iYvKF+2G1R7mwDKwlS+OicgmY6aFU/AyXZGngV0ybpFhzH
	p4CeqyWwMWuNpPybYtMeksmDr1WurQrIgQa/Zu22ON8NxLIhGrOF4S6H1v2kUCQx2Ey5Sy
	Nju+BywMXSjc3HHvvWvdwOnJBUH2V00=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793707273;
	b=0Yb3wa6bYmJPT1I5loP8Xdy9CpW0VSYFBf0n3MaBscs0ObzkPvliK6OkIio4VSYi7uRvMs
	+6zW+Uo5RWahvziEgVRq/zItSc1zpBhv2sgqRDMs2+tGsHpBJdFDrxTvN7NvH9GF9wcj8L
	NCRnom1bE+iiZOXaO4u5oj6V+ctPIC4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=oCXj5qzc;
	spf=pass (imf26.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.152 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4jJnGY6bz6zKn9C;
	Tue, 03 Nov 2026 13:01:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793707270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O9atIHlIh/2xYLtt0bx0cLcke1aRGKizVOlpIySp6oE=;
	b=oCXj5qzcbMvjvKJrNYqY/ioBLqSxBa8G++IgdAp07ig/AVYcNGqwEe4Y6mQkXYvgsKOXzJ
	GybBTvDJS6n3WSv17sx/I5Uz8wOH9A8A2IBuUi8sAfhX2zu59xuiMdL82HRoN+Re+92qne
	bjrHB2o1AL8uqVUQACYmtHtwZzP4pLb5Fp0+DBUy31knEtICxt+YnvkXsPoS9Q5ZizX2ee
	ltWAOLhXw5fMVXOWuit38T+sgLCWqxhwE0ej6hVYjJY08Cwv1j6OPct5qPxeiUMItLS0FG
	jhxCfU9CaCApLp3vMlNICA9dp6nymGO8ZJwpHQHRt4aO0WwsUZBG1HOz0vdjMQ==
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	Aveline Noir <jm5905938@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] Docs/admin-guide/mm/damon/reclaim: improve language
Date: Tue,  3 Nov 2026 13:00:42 +0100
Message-ID: <20261103120043.100887-2-manuelebnerli@mailbox.org>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: gbwzquqe8o7tfnmr3pdwjcxfgqjuyrdj
X-MBO-RS-ID: 2971e257b0a29a79e8f
X-Rspamd-Server: rspam06
X-Stat-Signature: r4d89f6uarpci3dmp7mhysmzhi6ifirn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7CAAF140008
X-Rspam-User: 
X-HE-Tag: 1793707273-460541
X-HE-Meta: U2FsdGVkX185VRdUAL/pFyAt4mz5SxOp2+0fC6T1HBTE9F42QAnHBw6Wm6neVO3sM7K6gdCZvj4RT9dABfVeEc1laNYsP3Dap4D+SUK1x60hP7W0u8zoX5kQyMoIrhtE75+Vyexu5+OIxLRggIrjZ4NDPxTSJY1+gKPSi+d2S9cq6a57OHg7a1PKDJ2sQzSyrrSkSjJqYcpTjQDfGKBUR6Yxf+fLDx1E/FDwytOkJfs11AkLOo0dqnYxsn1jeWOeppbeH+h6wv6sFtm+0vHRjrSHsr4iNq1imZnshC6AA6C82hbQ6ChcPvj408cTFDTu5BKrm8w+afCLPC/j5d1lqWYRKthgJsAurTuGSlkLI4WzlVsUisKzhtDKkHZ2j+tiLPt6PTC3cUETeUoc3Dt0nOp6Iu2e/YWOhaFHUVSQzuz5YjkOuUXSCeeFyrr0P+OC8QlgqnaHM+pvihg8IqLL/D2XStHICMa3qlI+qk1b2EiC5+TQGzeO2a/4NDgp47TMhumoH87u8xecGCfAPkp7VJxCJanh2K7t39QdDB3N3Kq0P2pXpjXBpKTdivMnUoc4XzUv0zQGNs/tyw1bYd2UTdhXHMWYbVKtLv5JsPjfSG/jLx/YKhS0rhUK989TVy906XWsTgPpbJP3AVDakdLfJjAdpLL0IGzuRu7WjCayPrByOI1xwbegzPyk3vn/ubueeteDTznkItA5Ao/XhgDyIbjCqQ3K1pveMDL8z+nG1LfqoX1LWVOSFMP2j6gMjkzzgTlki1umbJXWKwXbAs72eSOck11vGArdCfDQjPOjhCV1mu4FN6PzWpIyEv+QzYjew07sU6IhefrTxC9n5OPVVQdZHZHQu1sRt3BBu21SKiPDClDlG1jLEjW1JRdilJY4I8oBBjsKTYHw68Lw68X6afH3/52u0OO6KQ/o78aCqBMQlOY72t0/RqMtk52F6Gp/2R0mMmK2GXxpNGNVB2m
 5Cev1ybB
 TTxqQnL57lnGclDmOF10dYg8HRpcBa5qybqE4RboVjHDG1n58qShhcfu925lX+0seK4lnZRniGXcGgn6XNp9KzNkKawv27C5DOA3GcY1xp1yFyrYhKns2u8f4S9Cobh7uu2qT4zmlLVtU4gAvYOgr5V9wBxOfTXb1905LkrfYJmCVbwoQyg79TZzXGa5LXsjjvXzKID4YxqVfrYoCvFP9uWVwbC0wWGvbk+c4IQuA3RjrnruTRh5pkP/yNPq6xs+ud3tP2Nt17dAAofKEce1G0ZxFjBOf9JQ9wNH8TvvhUXg+aMFRp6Aevz2IJoALu9BknCFO1v5egCp0UltjBTNXGgxjXmJf2qSr9kRqhXl0Fu2LfMKshuhL87A8aA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix upper case.  Fix tenses.  Replace 'set as' with 'set to'.  Add space after
sentence to make it double space.  Rewrite and refine complex sentences.

CC: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
That's the final version.

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
---
 .../admin-guide/mm/damon/reclaim.rst          | 43 ++++++++++---------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index e4e2ffa52e..789db7099d 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -4,7 +4,7 @@
 DAMON-based Reclamation
 =======================
 
-DAMON-based Reclamation (DAMON_RECLAIM) is a static kernel module that aimed to
+DAMON-based reclamation (DAMON_RECLAIM) is a static kernel module that aimes to
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
@@ -88,7 +89,7 @@ identifies the region as cold, and reclaims it.
 autotune_monitoring_intervals
 -----------------------------
 
-If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+If this parameter is set to ``Y``, DAMON_RECLAIM automatically tunes DAMON's
 sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
 amount of access events in each DAMON-snapshot, while keeping the sampling
 interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as
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
@@ -219,7 +220,7 @@ monitoring.  This can be used to set lower-bound of the monitoring quality.
 But, setting this too high could result in increased monitoring overhead.
 Please refer to the DAMON documentation (:doc:`usage`) for more detail.
 
-Note that this must be 3 or higher. Please refer to the :ref:`Monitoring
+Note that this must be 3 or higher.  Please refer to the :ref:`Monitoring
 <damon_design_monitoring>` section of the design document for the rationale
 behind this lower bound.
 
@@ -263,7 +264,7 @@ This parameter is for setting and getting the :ref:`address unit
 
 ``monitor_region_start`` and ``monitor_region_end`` should be provided in this
 unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
-``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+``monitor_region_end`` are set to ``1024``, ``0`` and ``10``, respectively.
 Then DAMON_RECLAIM will work for 10 KiB length of physical address range that
 starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
 
@@ -280,7 +281,7 @@ skip_anon
 
 Skip anonymous pages reclamation.
 
-If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+If this parameter is set to ``Y``, DAMON_RECLAIM does not reclaim anonymous
 pages.  By default, ``N``.
 
 
-- 
2.55.0



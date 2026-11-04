Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85233606AE04
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=B2jez2gn
Received: by kanga.kvack.org (Postfix)
	id 9067B6B05B1; Wed,  4 Nov 2026 15:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B80F6B05B2; Wed,  4 Nov 2026 15:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE116B05B3; Wed,  4 Nov 2026 15:30:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4CB6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:30:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9605012081F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:30:50 +0000 (UTC)
X-FDA: 85398580260.18.52C4C8E
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7D9C41C0011
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:30:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=B2jez2gn;
	spf=pass (imf18.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793824248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JIMiU9y0vbuCD/B9Q5lvFFGjmQ5GlwLyj7wmrnkHlyg=;
	b=NRF3j8dM4+BznQ3aYl9C1nRYFg+2yVK3hXTEO+PuKl41xeRxnrj20yns72Lt3I6PaB+UBE
	MjYd0NsGOCCaUaln7Rr7/JaYp5edGPU0/929seX2U9RGKt77hc+KhcyCbi6jpu3ouvK6Tl
	uZNCHFEt7h7H4pHah9q1huNPzFnN4zA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793824248;
	b=3QFQjVW9A8083uUje0KKP3/v0zpc2wleWbwFVjf21dVNUABcOFWMywLZhZKVMhk4WTMz0n
	WT8DhE2YV+hkabrPruK57Vve4oYzzLYExb1zLE422ox8snk+dRdiSZsL/b2+GLPG7fXXb/
	UtdUfVzzqbTzFvkqZ9GwxuQnQnAIzSs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=B2jez2gn;
	spf=pass (imf18.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.171 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4jKcX50jDBzMlCp;
	Wed, 04 Nov 2026 21:30:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793824245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JIMiU9y0vbuCD/B9Q5lvFFGjmQ5GlwLyj7wmrnkHlyg=;
	b=B2jez2gnt5yTgJFBiUcy3vBZd4MMeVLOjZ1E+S0wNg18H1AxJ9ZNSzbcaNEKjgXwITvTho
	s82bYij3bzAz6GSJtqSYYZXXxu8DoB8zDo6Mgiv00t3tupNFo9UX31hBjUyhVKway+P4yn
	0utTnn5NiRMNI+Ua+WuaOhKojsK+odEB0DMvUyeqdap7AkQaB1I3Ud1N+UgPpVkPTdH+Hh
	tP2zgupLJciwpgyUGSpe5+X+2bcXHEpIbIvMpc6i8+agi01uDUAn+TWM++R26ubWJwcCHB
	4YNQ8UVRLnPOniFkG1efNIqO2yCzMP3zLtu9UY4a0b3em/LYvz8gIop5PegiAw==
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	Daniel Pereira <danielmaraboo@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4] Docs/admin-guide/mm/damon/lru_sort: fix grammar and style
Date: Wed,  4 Nov 2026 21:29:58 +0100
Message-ID: <20261104202959.128646-2-manuelebnerli@mailbox.org>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 8310e9f3ba41376803e
X-MBO-RS-META: q14mur6h1s4sx8s85bqojgytr34moh6g
X-Stat-Signature: ejwbbewzriui5jwitahpxwx6b316n8og
X-Rspamd-Queue-Id: 7D9C41C0011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793824248-875992
X-HE-Meta: U2FsdGVkX18vwQihXIqqLLB17fNaaN2+MXkWzGGmQGHro22E3yxnD53JxW9tt2JIslGwU5RuEd9JTfyuI16tcIB8hJ69QB7FTFrH7r4Ctsip01Bq/RNwrceYMsBLMbbbwPsn4qbdUgHGzk/p1gE2ooSRjbEzTE3LaUmA4A7YMDgkyBnXwnjvwW6W6Tb6fvlNZCjg7Y7bFHRbCnOsgq3Q3kaT9VWT1iFOGGdCekk51KqBQwo2trBWLqBwzFaHBt6MqP3z1HQwyNNE9s8stWIJdpUUvlPDMbqXEtBO9uiFtSPmUruFDpsQLFbJ/cFOEHnHe60FyRAkiaW35ovEiD3erVCPs7Ui29SkR3UUjjeZThBsXg2/AlU4nwf1xO+4euVY6DK2P/k89JvGjLZyevMZlljuTMuDrmyhzOWqE3uMAMSGjIiZUdew3rGYwIhswSiVnJ7teQjPCYAeQY+64fEpb1qM8W/BYKlRPeD/fF7o2zHhLK3cAx+QzDbzYEf1+hf0xFcnkQCKSrf4+s4eR+uXmz4q9IWmbQRZTIpnwUGuJnIDaur3yzOS6toOGoa0iD9nEhpbaCZSTYbXDgp973GiiwbsEOT8HoA2eRBzk6yIn/2eL4QGIdrlakhGo5Izlsui69kIQbkgaIr3X+3qxj2U0zIlDaHdtoEGSEOwfNbAJwDpYishmWsXwCNhEvtYKNVNo3ugiDWVNSiDaRxpVwpsteyRyZ3Fc1m8qTXn0a9MA/qkmzuO0lZYmBWCwM8u/HbwsKuE3YAojTs9uS0jamjoUAraZjI9CrHMghHE9CvUVhyZfee3M5lPfppJ78ba5MPBx6fPFe+a2VEE9jgdR3xDJlU+lcfwKiJnS9F/ydkDzyJ8L/cKZQ95IzGtQCgrp0gNBzV9s02MHGPlxhjDSi1VccTWgTAiu8fCssjC7kEjyosgg4V7XiNfWNHR4eAkszPO3uZDElplVES+MtoJY3z
 0Vz+5vy6
 6LGCsQohRAjaBFhp6m3yoECpwixkoLoja1osvs2Zuacz7M7YJunXJDlau2XCDKlOl1GCx577ol5tsRUAHUjJ4sBWw0rTLJ6mjx+Zd2IKvktP4ETUiWDpq0n45Z97vSAJxSHfqDK6EKc0o5YAj8dmRIb6mKXnNpxAm1Eo/R4wlEXsDXpYSdrtco7R4+QOaXX0CR7VoizgYwFa9jpXgsq9MKaMHojiEuW+Hpn3cwZFV6i8luG0l/SV9CXtLA2efYB6nfLLZxjHTxUxXiX2Ft8frTbQnbRgIweYqyGBlZpKDJxKFwi8B9nGTSM+qdQYcEJf+/uRmZilp5GdP/oZLo5/mI7Jdp+wQuMEdXwGztOog8601s5JuQEZNnfMEEan2HrRhAUi4d0qg0B09Pvs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix tenses. Split long sentences thereby improve readability.  Replace
'set as' with 'set to'. Replace [] with () to make the file uniform.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: SJ Park <sj@kernel.org>
CC: Daniel Pereira <danielmaraboo@gmail.com>
---
Daniel thanks for the Feedback.
SJ, could you please reapply this patch, if you think it's worth it.
Thanks
 Manuel

[v4]
 Fixed issues pointed out by Daniel Pereira
  typos in subject, log message and diff
  https://lore.kernel.org/all/CAMAsx6epLXuUjaV3J0=SWAuLvajr4h58DTM9gL+LMmaCyjcxUg@mail.gmail.com/
 trusworthy -> trustworthy
  I think this is in another patch.

[v3]
 https://lore.kernel.org/all/20261017083535.1261388-2-manuelebnerli@mailbox.org/
 Split long line
 Fix path in subject / One-line summary

[v2]
 https://lore.kernel.org/20261015072947.802821-2-manuelebnerli@mailbox.org
 Collect R-b: from SJ.

[v1]
 https://lore.kernel.org/20261013191327.663331-2-manuelebnerli@mailbox.org
 Wordsmith commit message.
 Fixup a few trivial wording.
---
 .../admin-guide/mm/damon/lru_sort.rst         | 63 +++++++++----------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index b93ca9b085..90a6cff893 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -5,20 +5,19 @@ DAMON-based LRU-lists Sorting
 =============================
 
 DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel module that
-aimed to be used for proactive and lightweight data access pattern based
+aims to be used for proactive and lightweight data access pattern based
 (de)prioritization of pages on their LRU-lists for making LRU-lists a more
-trusworthy data access pattern source.
+trustworthy data access pattern source.
 
 Where Proactive LRU-lists Sorting is Required?
 ==============================================
 
-As page-granularity access checking overhead could be significant on huge
-systems, LRU lists are normally not proactively sorted but partially and
-reactively sorted for special events including specific user requests, system
-calls and memory pressure.  As a result, LRU lists are sometimes not so
-perfectly prepared to be used as a trustworthy access pattern source for some
-situations including reclamation target pages selection under sudden memory
-pressure.
+As page-granularity access checking overhead could be significant on huge systems,
+LRU lists are normally not fully nor proactively sorted but rather partially
+and reactively sorted for special events.  These events include specific user requests,
+system calls and memory pressure.  As a result, LRU lists are sometimes not
+suitable to be used as a trustworthy access pattern source.  These situations
+include reclamation target page selection under sudden memory pressure.
 
 Because DAMON can identify access patterns of best-effort accuracy while
 inducing only user-specified range of overhead, proactively running
@@ -28,9 +27,9 @@ pattern source with low and controlled overhead.
 How It Works?
 =============
 
-DAMON_LRU_SORT finds hot pages (pages of memory regions that showing access
-rates that higher than a user-specified threshold) and cold pages (pages of
-memory regions that showing no access for a time that longer than a
+DAMON_LRU_SORT finds hot pages (pages of memory regions that show access
+rates that are higher than a user-specified threshold) and cold pages (pages of
+memory regions that show no access for a duration that is longer than a
 user-specified threshold) using DAMON, and prioritizes hot pages while
 deprioritizing cold pages on their LRU-lists.  To avoid it consuming too much
 CPU for the prioritizations, a CPU time usage limit can be configured.  Under
@@ -63,10 +62,10 @@ enabled
 
 Enable or disable DAMON_LRU_SORT.
 
-You can enable DAMON_LRU_SORT by setting the value of this parameter as ``Y``.
-Setting it as ``N`` disables DAMON_LRU_SORT.  Note that DAMON_LRU_SORT could do
+You can enable DAMON_LRU_SORT by setting the value of this parameter to ``Y``.
+Setting it to ``N`` disables DAMON_LRU_SORT.  Note that DAMON_LRU_SORT could do
 no real monitoring and LRU-lists sorting due to the watermarks-based activation
-condition.  Refer to below descriptions for the watermarks parameter for this.
+condition.  Refer to below descriptions of the watermarks parameter for this.
 
 commit_inputs
 -------------
@@ -74,9 +73,9 @@ commit_inputs
 Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_LRU_SORT is running are not applied
-by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
+by default.  Once this parameter is set to ``Y``, DAMON_LRU_SORT reads values
 of parameters except ``enabled`` again.  Once the re-reading is done, this
-parameter is set as ``N``.  If invalid parameters are found while the
+parameter is set to ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
 Once ``Y`` is written to this parameter, the user must not write to any
@@ -86,37 +85,37 @@ violate this rule, the kernel may exhibit undefined behavior.
 active_mem_bp
 -------------
 
-Desired active to [in]active memory ratio in bp (1/10,000).
+Desired active to (in)active memory ratio in bp (1/10,000).
 
 While keeping the caps that set by other quotas, DAMON_LRU_SORT automatically
 increases and decreases the effective level of the quota aiming the LRU
-[de]prioritizations of the hot and cold memory resulting in this active to
-[in]active memory ratio.  Value zero means disabling this auto-tuning feature.
+(de)prioritizations of the hot and cold memory resulting in this active to
+(in)active memory ratio.  Value zero means disabling this auto-tuning feature.
 
 Disabled by default.
 
 autotune_monitoring_intervals
 -----------------------------
 
-If this parameter is set as ``Y``, DAMON_LRU_SORT automatically tunes DAMON's
+If this parameter is set to ``Y``, DAMON_LRU_SORT automatically tunes DAMON's
 sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
 amount of access events in each DAMON-snapshot, while keeping the sampling
-interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as
-``N`` disables the auto-tuning.
+interval to 5 milliseconds in minimum, and to 10 seconds in maximum.  Setting this
+to ``N`` disables the auto-tuning.
 
 Disabled by default.
 
 filter_young_pages
 ------------------
 
-Filter [non-]young pages accordingly for LRU [de]prioritizations.
+Filter (non-)young pages accordingly for LRU (de)prioritizations.
 
 If this is set, check page level access (youngness) once again before each
-LRU [de]prioritization operation.  LRU prioritization operation is skipped
+LRU (de)prioritization operation.  LRU prioritization operation is skipped
 if the page has not accessed since the last check (not young).  LRU
 deprioritization operation is skipped if the page has accessed since the
 last check (young).  The feature is enabled or disabled if this parameter is
-set as ``Y`` or ``N``, respectively.
+set to ``Y`` or ``N``, respectively.
 
 Disabled by default.
 
@@ -235,7 +234,7 @@ max_nr_regions
 Maximum number of monitoring regions.
 
 The maximum number of monitoring regions of DAMON for the cold memory
-monitoring.  This can be used to set upper-bound of the monitoring overhead.
+monitoring.  This can be used to set the upper-bound of the monitoring overhead.
 However, setting this too low could result in bad monitoring quality.  Please
 refer to the DAMON documentation (:doc:`usage`) for more detail.  1000 by
 defaults.
@@ -268,7 +267,7 @@ This parameter is for setting and getting the :ref:`address unit
 
 ``monitor_region_start`` and ``monitor_region_end`` should be provided in this
 unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
-``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+``monitor_region_end`` are set to ``1024``, ``0`` and ``10``, respectively.
 Then DAMON_LRU_SORT will work for 10 KiB length of physical address range that
 starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
 
@@ -291,22 +290,22 @@ If DAMON_LRU_SORT is enabled, this becomes the PID of the worker thread.  Else,
 nr_lru_sort_tried_hot_regions
 -----------------------------
 
-Number of hot memory regions that tried to be LRU-sorted.
+Number of hot memory regions that were tried to be LRU-sorted.
 
 bytes_lru_sort_tried_hot_regions
 --------------------------------
 
-Total bytes of hot memory regions that tried to be LRU-sorted.
+Total bytes of hot memory regions that were tried to be LRU-sorted.
 
 nr_lru_sorted_hot_regions
 -------------------------
 
-Number of hot memory regions that successfully be LRU-sorted.
+Number of hot memory regions that were successfully LRU-sorted.
 
 bytes_lru_sorted_hot_regions
 ----------------------------
 
-Total bytes of hot memory regions that successfully be LRU-sorted.
+Total bytes of hot memory regions that were successfully LRU-sorted.
 
 nr_hot_quota_exceeds
 --------------------
-- 
2.55.0



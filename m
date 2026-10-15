Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E54CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 07:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A026B0088; Thu, 15 Oct 2026 03:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6610C6B008A; Thu, 15 Oct 2026 03:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FEF6B008C; Thu, 15 Oct 2026 03:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29E006B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:34:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 970F1A093C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:34:22 +0000 (UTC)
X-FDA: 85324047564.06.431F4C0
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf15.hostedemail.com (Postfix) with ESMTP id C64E1A0008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:34:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=WJ0cVWt0;
	spf=pass (imf15.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792049661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5BbSMtY+9Kbz5WrucAlpB74oey3pZ7xFI2/f3PZfg8I=;
	b=u5f71SSwuxAdYHkTrg7MqtikmBCGixi4AAJpBO4ZMKxHd/F+crClcC42+ipbkPhDaKvLsy
	2QKe/d3c+o5i9neZuMUNOyLGwkQpSrvqwr0wpxIH/WHKabF40ZFJcS6vPopjjTEvdsUHse
	MTe7ttlV3EsLRKXrXiXLuNyXkxVIAi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792049661;
	b=gkPgikD7TKrSKHBjMIras/Wak2Ok6Q0WeodIL8ABWN45wMZigFo175Uh3uGr8P5aH/j0M+
	AjSU7MHsg30u3SNUY+rzjnmA7jgtQ/oYxdFBiIFQXCdcbpvutBs2ENj4aK4b4zOjIKGBIo
	JZBMKUEJ91KSESgGmvZ4YfoDmJjKDhc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=WJ0cVWt0;
	spf=pass (imf15.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4j50FP0Y2WzKnNf;
	Thu, 15 Oct 2026 09:34:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1792049657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5BbSMtY+9Kbz5WrucAlpB74oey3pZ7xFI2/f3PZfg8I=;
	b=WJ0cVWt0CO90YoIk8WOSdU9JWWqR/gk+s+jOZKKuzmyqLpiPgHHEqZ6T0iecGzqaJSnhvR
	DopRTNElY6VV6Ad0nF4dK1C/hd7A5GHPZrWTCT8AhnzLPEGPa2AJf9j2vMW+LhmSQiY27s
	3OHQabVF4eNuGaaMUbvFxNTjhZR+zg8S1iXpnQ0aAzTQVu++CVXTkNX/LCXQ/InygRbAe1
	A9Bvou1y1Erdo7j7tTSXaY5pc15GPe3UE86RYEv3kC4EcvLL47m94tlG6UUkrBR6qK9uK0
	jQM7WQ/cgJJKOSQ6zs0oh4OVnESTwS+H4PtZf1354rmuji+E6HyvrxFnpze7SQ==
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/damon/lru_sort: fix grammar and stlye
Date: Thu, 15 Oct 2026 09:29:47 +0200
Message-ID: <20261015072947.802821-2-manuelebnerli@mailbox.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: idn3gxtcdjt6emcbahy53p5jocy9zney
X-MBO-RS-ID: 344519cfb3155f51206
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C64E1A0008
X-Rspam-User: 
X-Stat-Signature: pw586ygse1zzqr6g3teoz3yodwrtq9eq
X-HE-Tag: 1792049660-781633
X-HE-Meta: U2FsdGVkX19R46gXig1pFUU8bIp8VWTtOrdbOthHsVaUcD4fj+wg+dHRJQkFQunuDjUWobfqmC/xK7lKYCi02GrYpTULikv0VkUUhdUPRXHveqMqEkRMu5RsybcKf/gPUchXXqylqWFMEn2pTN9KidBOngoZptyjz0a8tDeVa0r+sazhEOcpJHZh68fdpeaMRL3IJaCdOtYr/liYMgKpzEKsvEp+LPQWJA03IYVCmYKYihIo9L9uVJs2b3+c130CXvRHaePQhuCOXmkmYCc9HmiTGUuj8cxN5Yp+duKqCT0E11k+nZ5k0+0VbgQuRUQ9zZ3cxGxB7YOl9KW5ljV6U02bf7roBq48q1DOyP3jrgNfCOAHMo1A0m124+yulrBUyVJIEf5060z/CJRN6KkEhGha5QWe5iccfJLQkQqATu1xfY4Q4CAfkum8ROvScdFGxhziS3WniOsHiwhhTp/70MR7kPflDtFMzsJkH6/8X54YBbe68kimQ7VSjyzFRysmo3L8BsYTmzLUI7iFRilKunf+8nCVCtXrfdo1I3CT1pcJ9UUMYelRVdQeXadEbZxL4n7Io20rs8TfgrrVqUfbG0Wcpt45WazNoiP+ZwaBWzoK9Zq77aPE6SAKXHXw5i06iL53ZXKQ7l+wiIrWafgEI0Y3RwBOwSnGuw6EB6mGmtOH2kVgnsHVz7Wj/cdW1qSu/JCyvEUGOsmkai4IzHuycEbvj9ohvhN8QccGyNXhoiVBzG1L3DohoaUSzXhF0EQ7CYiqLD5jPg3fArbltoXTdb5zoLA063w+lEw2DG1l+dW6ci5pMv2ppO8665fvHCL4ZLMjZhRzeqES0J4iHb6h+Ilm02w8haCZd7YsmgdMOtBGYiLJGbeQevj8Nme/QqNgqv1sh2ej2goby0+6HrA9ygEBZruoniwH/gKCK1gkIcJFZYyT+3Rep0s5jOdbBDNT9QzUEINu3g70b6t+EiN
 kpIaiUTP
 cdxPuSVLVr6mo54USTjMNHPmeNdH8OccEbl/lErsiGy5nHtB84oo1cWmnJOlqmK6xSN5Aqz3xXFhe95PfP+6wENSM86e2OHlEAsyoS7L7nN85Gdr3RIjcxsuz9LcdCO7562ogWpqiT69ZEDYVCb7OmK10DW3jeyPMwYMfj/CdeJ4bF5p7jv8ckxHmV6bOabbyGnnJYlI8gg58qDAXLPHgEgXlJu31qh1LQ+AHuTg/cNP7uRKI2x7DKX32G5q69ga0lzj2YKW3q9nuZDRdmywP5+k8h40IkLUQ3aGv7Uro8t4+s+qVBqltW3IofWQNfIbQSHqvpmkBegeWdoBJ+T8ONvYN9qkP1HkpCbRK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix tenses. Split long sentences thereby imporove readability.
Replace 'set as' with 'set to'. Replace [] with () to make the file uniform.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
 .../admin-guide/mm/damon/lru_sort.rst         | 61 +++++++++----------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 0c04d238ed..aa4cc90ca5 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -5,20 +5,19 @@ DAMON-based LRU-lists Sorting
 =============================
 
 DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel module that
-aimed to be used for proactive and lightweight data access pattern based
+aims to be used for proactive and lightweight data access pattern based
 (de)prioritization of pages on their LRU-lists for making LRU-lists a more
 trustworthy data access pattern source.
 
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
+including reclamation target page selection under sudden memory pressure.
 
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



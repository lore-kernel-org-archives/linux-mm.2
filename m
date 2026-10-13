Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163ECCC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 19:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDE856B0088; Tue, 13 Oct 2026 15:14:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E826B008A; Tue, 13 Oct 2026 15:14:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C1D6B008C; Tue, 13 Oct 2026 15:14:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 80F5F6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:14:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98C02A01D3
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:14:16 +0000 (UTC)
X-FDA: 85318553712.10.30FE1AF
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90F76A000F
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:14:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=muWw0dm7;
	spf=pass (imf15.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791918855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q7NeGVGhynspdDjN8FsWdiUJ/CHXi08JbRrTumaJC90=;
	b=6wLTIyI6XL/Y5Hxl4jPLRYBU1+iLYH7lfeZQQltQKaNGBRdnuN0oc1HdKIqsaWwYo6av+b
	LjZt7FT4wKzCzzA9U4qwDLHwYnT+UZtAtA4FiSW5fMViaLULGitQw0DACz0mrUPKdeqAE9
	nCLEYAlZHAs93Vzt97psFA9Op+IjBWs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791918855;
	b=rIADluXXFEkNrFfcOTAd8aw0UD466JS0++q4x7tmkZDNVvpQffQlMwhwjKWOt8dPs2lLE/
	USgB2WIN+A0vIBEWfUHCt2u2UsnP+XU8BVe+SxlvnrvWyifO7COQAeF34sbdZNgVSXyYmr
	8IoEoziq5IYb9z7uXtn+w09UgbeWGJ4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=muWw0dm7;
	spf=pass (imf15.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.161 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4j43ss5DwmzKntr;
	Tue, 13 Oct 2026 21:14:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1791918849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=q7NeGVGhynspdDjN8FsWdiUJ/CHXi08JbRrTumaJC90=;
	b=muWw0dm7aDxJ2inMBGAsKwaVUA8f0aCLXZW9dPTK+deZuMTp1v6hyfH/CtQ96NBKXjEMnU
	xdD3YuMMEgMRuJDExLJruslZETFpNFX2yFA/upFYWy0n3uXWNQvAxWiBkJDCHCDhBcMaB6
	DBLmzqzoXrjEkSe7fMpPHtcfwm8imTid3ftA2n+dPucnvnnU2smfysRBEy1a08n2GpF6g1
	PyY785UDE1ifuXsVZvt98ELgCFWgGtxscNUVaRgCrKdKy4D6CBMcqjdw7UqQbHDLQu7zva
	eMY44cA7wmgxM9/AOLQ6wpb9Je2+NTSZoOPt9DwXRWrj2tfRzlM7n/+4+vTUPg==
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
Subject: [PATCH] Docs/admin-guide/mm/damon/lru_sort: fix grammar and stlye
Date: Tue, 13 Oct 2026 21:13:27 +0200
Message-ID: <20261013191327.663331-2-manuelebnerli@mailbox.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: ec553cjhwsjo5srji38ypaakogkmy1mm
X-MBO-RS-ID: 5444562cf99fdf74ba2
X-Rspamd-Queue-Id: 90F76A000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qqgeuif4uk6ajhaidmwitwboijuadj96
X-HE-Tag: 1791918854-22899
X-HE-Meta: U2FsdGVkX18KT1yuIUTimEJezMcdCde2FaAgaDgEXRPociAHPqYoOM6TSbufFO2i1O6PxLcAOIGugZWWEWwmEY4ZAxbiMLJMQyLyaMwgNDuMyKXPEsXZQsTJQABJwVrxQSdZRaLcEcO2xvtpEbtcTMMZtOi2087hSglpbw9UBl0FfFtYwU+SESwUpxmyJZrg95W5+f1iZ/l7M6qqt47YzsjDVVT3TvdUQY3cMtSQK8Nt0kZT3hkzLzzlVBCXOzoLpN44+qDwP6q97CHdHU9OO4OG48ZcFPzY9RW0LGxB8OjnpLGbtB5pgh69fHju1ZNmmhhhnvNYKjboYkK/6TwVottwuMsnLjfwDkCKhYJz4Snhp4MR8X+BPBPXpecbjC5HAzofyJ+caRDxt9AO+qUCCcjtggP4iOpgNscyz1fjHX4wkTpys52HsIt7dravHmJ0mHZQjxffwN7QB7X2PVRmvv6PRaDIY3roVcx1yjdWW5pNgyYbC2Nqt0B/nXtdVSQPxqSRlc0x9srFhu6oGTo2MkVrduAvz2sPgzeayXD3v6eqkMau+94zYQ/WIqTNAc4saInXqaTkGwpKpJsvLar8+zxgga+mzpBdVlW6dwC1/00ocW5yUIl8xq+LZ9KFmcd3Rnq5igobF5O3V98zbfzfQXpDMDwhVQsiGrFWqNPB3LLvK6yB8GwYxbC8CELtCXkXsyTDbG3IVVoJ8zQ8fcuxZJ6QB00tzWQcBecxS5DPmZpsqf8Z+968KceUuHhZj5/F1QaZuygikZCz/stEPhSbvubuJJebBlrwwbQVTxuDISxFL5fPcaolCXEc8G8Bf+QPCIQqcgOZVLCuGh4oozcw7CtTXLk8P+UI6wBpmldUyeAZV2v33K5yyb+7FNRk436GvUAhqyP9r39PFMQZB8NACfKcDWKYN9LTTax9ziZ6haUVx7erWHNwOmO3QJBvhwFEHvstIPeagabi06rKE/h
 UWQkJlSa
 1z+RA7DqzV48jOyLnv6gD8GY6cOoEdNWbzvgCxGKvw2j2/JhiummrsALHTsAVOdTss0a8QRqnVFF65fA/R+ik+Xo9hyqLUb6hV0hqGeSzqSNTj5sdybCP0sNbAh5zC4zWq1Q39j2bi7THEXKWOle3VpubXOD1dJ+W8tu052jyKnG8yWa+9k2ly44TmpO62peJ1OazTaWPGhFAgJrZdott0T/C5429xsFtO1QILXuf18sWR4AQ7+Aq+fwdUZ5q+HWR2XWk3JrGX3lr1RXtufkHQ+51PApXxRb8fau1D+yOsUkIcTCp6Ptyj4/0B1Uc8N+GsMPWX2KmlDeumemA2qGOndnFrvgN/M9AOWOG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mention 'least-recently-used' AKA lru at the beginning
set as -> set to

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
---
 .../admin-guide/mm/damon/lru_sort.rst         | 51 ++++++++++---------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 0c04d238ed..3b6d122887 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -4,8 +4,9 @@
 DAMON-based LRU-lists Sorting
 =============================
 
-DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel module that
-aimed to be used for proactive and lightweight data access pattern based
+DAMON-based least-recently-used-lists (short LRU-lists) Sorting
+(DAMON_LRU_SORT) is a static kernel module that aims to be used
+for proactive and lightweight data access pattern based
 (de)prioritization of pages on their LRU-lists for making LRU-lists a more
 trustworthy data access pattern source.
 
@@ -17,7 +18,7 @@ systems, LRU lists are normally not proactively sorted but partially and
 reactively sorted for special events including specific user requests, system
 calls and memory pressure.  As a result, LRU lists are sometimes not so
 perfectly prepared to be used as a trustworthy access pattern source for some
-situations including reclamation target pages selection under sudden memory
+situations including reclamation of target pages selection under sudden memory
 pressure.
 
 Because DAMON can identify access patterns of best-effort accuracy while
@@ -28,9 +29,9 @@ pattern source with low and controlled overhead.
 How It Works?
 =============
 
-DAMON_LRU_SORT finds hot pages (pages of memory regions that showing access
+DAMON_LRU_SORT finds hot pages (pages of memory regions that show access
 rates that higher than a user-specified threshold) and cold pages (pages of
-memory regions that showing no access for a time that longer than a
+memory regions that show no access for a time that longer than a
 user-specified threshold) using DAMON, and prioritizes hot pages while
 deprioritizing cold pages on their LRU-lists.  To avoid it consuming too much
 CPU for the prioritizations, a CPU time usage limit can be configured.  Under
@@ -63,10 +64,10 @@ enabled
 
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
@@ -74,9 +75,9 @@ commit_inputs
 Make DAMON_LRU_SORT reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_LRU_SORT is running are not applied
-by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT reads values
+by default.  Once this parameter is set to ``Y``, DAMON_LRU_SORT reads values
 of parameters except ``enabled`` again.  Once the re-reading is done, this
-parameter is set as ``N``.  If invalid parameters are found while the
+parameter is set to ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
 Once ``Y`` is written to this parameter, the user must not write to any
@@ -86,37 +87,37 @@ violate this rule, the kernel may exhibit undefined behavior.
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
 
@@ -235,7 +236,7 @@ max_nr_regions
 Maximum number of monitoring regions.
 
 The maximum number of monitoring regions of DAMON for the cold memory
-monitoring.  This can be used to set upper-bound of the monitoring overhead.
+monitoring.  This can be used to set the upper-bound of the monitoring overhead.
 However, setting this too low could result in bad monitoring quality.  Please
 refer to the DAMON documentation (:doc:`usage`) for more detail.  1000 by
 defaults.
@@ -268,7 +269,7 @@ This parameter is for setting and getting the :ref:`address unit
 
 ``monitor_region_start`` and ``monitor_region_end`` should be provided in this
 unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
-``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+``monitor_region_end`` are set to ``1024``, ``0`` and ``10``, respectively.
 Then DAMON_LRU_SORT will work for 10 KiB length of physical address range that
 starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
 
@@ -291,22 +292,22 @@ If DAMON_LRU_SORT is enabled, this becomes the PID of the worker thread.  Else,
 nr_lru_sort_tried_hot_regions
 -----------------------------
 
-Number of hot memory regions that tried to be LRU-sorted.
+Number of hot memory regions that try to be LRU-sorted.
 
 bytes_lru_sort_tried_hot_regions
 --------------------------------
 
-Total bytes of hot memory regions that tried to be LRU-sorted.
+Total bytes of hot memory regions that try to be LRU-sorted.
 
 nr_lru_sorted_hot_regions
 -------------------------
 
-Number of hot memory regions that successfully be LRU-sorted.
+Number of hot memory regions that are successfully LRU-sorted.
 
 bytes_lru_sorted_hot_regions
 ----------------------------
 
-Total bytes of hot memory regions that successfully be LRU-sorted.
+Total bytes of hot memory regions that are successfully LRU-sorted.
 
 nr_hot_quota_exceeds
 --------------------
-- 
2.55.0



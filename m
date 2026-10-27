Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA1C606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailbox.org header.i=@mailbox.org header.a=rsa-sha256 header.s=mail20150812 header.b=bqze+vGG
Received: by kanga.kvack.org (Postfix)
	id 286436B08A5; Tue, 27 Oct 2026 15:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2376D6B08A7; Tue, 27 Oct 2026 15:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14DDC6B08A8; Tue, 27 Oct 2026 15:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D62B06B08A5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:06:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C33AE1A0AC1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:06:19 +0000 (UTC)
X-FDA: 85369336878.07.F7F10F0
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id D64D718000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:06:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=bqze+vGG;
	spf=pass (imf06.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793127978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZwZGLOAfWKshH85BY6sKy8NaWebSZHsenr7NBQaqf0=;
	b=ujcs62bue7Taxj0GCbO0g2SJaVuAYgzdwEfYJ1DLUOJPBwxBwZJ0W+p8tXBNVNzgxKy9W9
	p6cZVZlARd7xV5oDQqE/+8gjGprz+9RQueY0tLX5nzPPjuZfQtLJjZlju737lLIvOaBAO5
	VnOKqVf4bksP9e6qhKnLPz0xQBUHW50=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=bqze+vGG;
	spf=pass (imf06.hostedemail.com: domain of manuelebnerli@mailbox.org designates 80.241.56.172 as permitted sender) smtp.mailfrom=manuelebnerli@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793127978;
	b=kH60wPgLkzi1Z47YOvexjKqc5N//p4PCg2cYCNwClSY7nqxEFCDPbZld8CU3rUFv97nGZp
	b/mmc9xmk6NgPN+yoKW79k2V5M8br3GL5vhHKMwDb2NEjBLvWHAqHDcs+ky7A0gIXtN4kY
	LwN3RRvPx579PWugz7+MEgk1k4EfU8w=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4jDg2H0ql4zMlf8;
	Tue, 27 Oct 2026 20:06:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1793127975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fZwZGLOAfWKshH85BY6sKy8NaWebSZHsenr7NBQaqf0=;
	b=bqze+vGGK3axguN3/po0M9kmYe8rux/EInQM7fauloKRr5ZKX65reg84flboGYO8812Hhp
	cpNY/v/ClsI0FBVpOfq9/4CSypLFZp8Fj7gowwGZwWxOBL87o+vRnSMZxBbaqpKGXyyZF0
	X5CpkZQCot5jAZlQgZpVn8IG73DmvcbL6i5uYqzMSHSBBRCxftsp7DLRYV76GZeYJwbHPB
	TaLi9KjDHAqOvpH7ALx5zLliDq18M+zgGEkGa2sToL0pdcIKXRUmb1qKGDFOV7WRWkj6eQ
	na0oYgj5+uEsXug2/QLBb+9hMDYmzuxC/hFzLYyj+63SwXBsh2bMVxBbBJ4Mhw==
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: manuelebnerli@mailbox.org
Cc: corbet@lwn.net,
	damon@lists.linux.dev,
	jm5905938@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	sj@kernel.org,
	skhan@linuxfoundation.org
Subject: [PATCH v2 1/2] Docs/admin-guide/mm/damon/reclaim: improve grammar and style
Date: Tue, 27 Oct 2026 20:05:04 +0100
Message-ID: <20261027190503.2526945-2-manuelebnerli@mailbox.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261027185938.2526259-2-manuelebnerli@mailbox.org>
References: <20261027185938.2526259-2-manuelebnerli@mailbox.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: xr4xmu89uyguo4usstrpc7595nkkf8po
X-MBO-RS-ID: aeb77b1cf244b61b05d
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D64D718000C
X-Stat-Signature: hcf89kbsp43qsr8mk37we5qj3nf3esad
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793127977-434119
X-HE-Meta: U2FsdGVkX1+gLQquYaJXTz8G/OgcIxHCQukLnS7op47Y1OIRGOr9mZ7UeuO9OlWCc3pPx/uq0watwb+Fx1XP13cV0iAxFQfH5CFPtEWieu4Arcx5IvU90QHkaUkoeCAg2mpNeVtY8Yx9sXjdwXFcUBf3sCu4hqXqjDvGFDiqfuAFnjoT1q8/ljkXtN4h9ZjxZpltPZfZMGiEr6PBUG+38hoC7F9K4wyaz5tyFe7OPu2EhxoOK0u7l2sbunjuqO3Qc+rSum7rlduJuvOdky+/XEQ90OkAM7Eyyss4ivI4u1N0Yi65zXUAgnV8M9r/KdC7AknZhSa0pckfLxK2TNpkh70ML4VkzAEq075Fxok/olZtB5P6SyITsdtYDo6vlSkZ4gYDxJsvNd8OStNG0XYMoVKsi0qVnepm9YXShB2jlfT1ChFVxltcllFxV4ayr393OqjxLhdZgSjGeWKOUAhwjPit/sEQGHfuE7Q9b1+/1LiEjwB6XbNVOWKzU/P8I/FgGxlWGaaKlhj/GV0Suyq+2Y7xdu9xe+CuMBHktPZaHjBX1p/URD/Rb9i8bwivjszkWZoe40bzmzuQrjX0aqroYu6ZPWSOBOjoitiANNT1Nl5y25VQkaOm/C7+8ix2mFUutnz/dudyPZy620NjjDdcEpXihYCvcOgWsd4Mq3ostDOgNHsuwlkpoaEv/th+IQt42/yOloPygd+PmnW58hIZp8oe0PJTjIgk48Glpt6/c8ne0OBrkye2Slj1eeERXFU29rI49D2hFlw9e+67VDGg9BIjUPu9Q7RMG9wbhG234XC0W5NEGhATVWGrjm7CFmOzOsU3NwE9XpY7WoAUeFCTNMeAxJV3+zhGtUeXUrsCCKW88nY6rNprCwpjyAo246/nHRjPpN5poR8FqMDLU1sR3hSJRwR5lOub2aW1wBPSRUgmvZv7vHxu37ZKR1VIa9j3MfTUAzRqMOZ5hWUQsSX
 EJUvJ7ve
 WNrUVq7MDpsjtoNmx8Y8vRWI1SAouTO76wQDWH9t9LJ6g7ovZ/UAqg4hFqpRCEKeGeHpNXh3YlElWFEmlg9K4bQdfAL46SCRmH7MdQxsesJy0IV+6Tcd23MbMZftUsnVeZ6znWYWhuXWOBWTnKNQOvsjqLBGtkjck+pyJcnbI70ujEj1OdfdQ5xPXKbYE1WXI3ZbiqcmJKJOQmbHR4JBdGUl1t0x9nCCgAUZ7pitOOvMWdp13BuPUKZvvjLrGZkp3grO32+vIxRLrnQqjRLt1xSqu+xyQn3YGc6BamoN41AeiqKyLqJvgEXYgJSOQW0iqBybPya8BV6MWCPyKMw0ZlUsDBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix upper case. Fix tenses. Replace 'set as' with 'set to'. Add space after
sentence to make it double space.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
CC: Aveline Noir <jm5905938@gmail.com>
---
@ -113,8 +113,8
Choose as you wish.

@ 20
should be:
-Free Pages Reporting [3]_ based
+Free pages reporting [3]_ based
or
+'*Free Pages Reporting'* [3]_ based
* the right kind of quoting/ kernel-doc highlighting.
Choose as you wish.
---
 .../admin-guide/mm/damon/reclaim.rst          | 36 +++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index e4e2ffa52e..0bab2299ea 100644
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
@@ -30,12 +30,12 @@ guests could mitigate this problem.
 How It Works?
 =============
 
-DAMON_RECLAIM finds memory regions that didn't accessed for specific time
+DAMON_RECLAIM finds memory regions that weren't accessed for specific time
 duration and page out.  To avoid it consuming too much CPU for the paging out
 operation, a speed limit can be configured.  Under the speed limit, it pages
-out memory regions that didn't accessed longer time first.  System
+out memory regions that weren't accessed longer time first.  System
 administrators can also configure under what situation this scheme should
-automatically activated and deactivated with three memory pressure watermarks.
+automatically be activated and deactivated with three memory pressure watermarks.
 
 Interface: Module Parameters
 ============================
@@ -55,10 +55,10 @@ enabled
 
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
@@ -66,9 +66,9 @@ commit_inputs
 Make DAMON_RECLAIM reads the input parameters again, except ``enabled``.
 
 Input parameters that updated while DAMON_RECLAIM is running are not applied
-by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
+by default.  Once this parameter is set to ``Y``, DAMON_RECLAIM reads values
 of parameters except ``enabled`` again.  Once the re-reading is done, this
-parameter is set as ``N``.  If invalid parameters are found while the
+parameter is set to ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
 Once ``Y`` is written to this parameter, the user must not write to any
@@ -88,7 +88,7 @@ identifies the region as cold, and reclaims it.
 autotune_monitoring_intervals
 -----------------------------
 
-If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+If this parameter is set to ``Y``, DAMON_RECLAIM automatically tunes DAMON's
 sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
 amount of access events in each DAMON-snapshot, while keeping the sampling
 interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this as
@@ -113,10 +113,10 @@ quota_sz
 
 Limit of size of memory for the reclamation in bytes.
 
-DAMON_RECLAIM charges amount of memory which it tried to reclaim within a time
-window (quota_reset_interval_ms) and makes no more than this limit is tried.
-This can be used for limiting consumption of CPU and IO.  If this value is
-zero, the limit is disabled.
+DAMON_RECLAIM records the amount of memory which it tried to reclaim within a time
+window (quota_reset_interval_ms) and stops trying to reclaim memory when this limit
+is reached.  This can be used for limiting consumption of CPU and IO.  If this value
+is zero, the limit is disabled.
 
 128 MiB by default.
 
@@ -137,7 +137,7 @@ quota_mem_pressure_us
 
 Desired level of memory pressure-stall time in microseconds.
 
-While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
+While keeping the caps that are set by other quotas, DAMON_RECLAIM automatically
 increases and decreases the effective level of the quota aiming this level of
 memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
 per quota reset interval (``quota_reset_interval_ms``) is collected and
@@ -219,7 +219,7 @@ monitoring.  This can be used to set lower-bound of the monitoring quality.
 But, setting this too high could result in increased monitoring overhead.
 Please refer to the DAMON documentation (:doc:`usage`) for more detail.
 
-Note that this must be 3 or higher. Please refer to the :ref:`Monitoring
+Note that this must be 3 or higher.  Please refer to the :ref:`Monitoring
 <damon_design_monitoring>` section of the design document for the rationale
 behind this lower bound.
 
@@ -263,7 +263,7 @@ This parameter is for setting and getting the :ref:`address unit
 
 ``monitor_region_start`` and ``monitor_region_end`` should be provided in this
 unit.  For example, let's suppose ``addr_unit``, ``monitor_region_start`` and
-``monitor_region_end`` are set as ``1024``, ``0`` and ``10``, respectively.
+``monitor_region_end`` are set to ``1024``, ``0`` and ``10``, respectively.
 Then DAMON_RECLAIM will work for 10 KiB length of physical address range that
 starts from address zero (``[0 * 1024, 10 * 1024)`` in bytes).
 
@@ -280,7 +280,7 @@ skip_anon
 
 Skip anonymous pages reclamation.
 
-If this parameter is set as ``Y``, DAMON_RECLAIM does not reclaim anonymous
+If this parameter is set to ``Y``, DAMON_RECLAIM does not reclaim anonymous
 pages.  By default, ``N``.
 
 
-- 
2.55.0



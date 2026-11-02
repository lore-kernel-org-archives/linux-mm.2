Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164A6606B1CD
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oyLAaRP3
Received: by kanga.kvack.org (Postfix)
	id 5E1E06B05E1; Mon,  2 Nov 2026 10:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A7C6B05E2; Mon,  2 Nov 2026 10:08:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480506B05E3; Mon,  2 Nov 2026 10:08:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E81336B05E1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D283120164
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:11 +0000 (UTC)
X-FDA: 85390509582.08.78BF395
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 76D5A18001A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oyLAaRP3;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632089;
	b=OM7CNcA6GUTX/f7lfrgizaaQaFrRbiufLdy8w+aD9pGU+vGIEfqOkKjoUYZUgX63qiDim6
	QY/5OBlI1faB4GZoDGV45lwPJzM5Ne8woUI2CWZWCm3rlHp39iTi5l3IgLhsZqjGdw7VDb
	lsA+dXTnIlHnbZX+3twdCzK3wRk47S0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oyLAaRP3;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvp3OkVy+SszLWIFkSYWY+dzg8k2mauBxngEG2KoUsA=;
	b=aFJVyH+/GJBzZG69S3GO8fxXu/dEsKL2RssB8pe44CjlQ0VkJFOFtzENrMsknXDA7WaLt4
	v+2goI2JFR9hvwRnpBTABkHUZkCXlIhVGBVd20XIH3a5fSFp+4Hpf2hzV/Kv18em6kFZaD
	Cgk2joJNFJtaX19kK4Y6ZYQXfGoU2s8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3BEA43D93;
	Mon,  2 Nov 2026 15:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A1B1F00A1B;
	Mon,  2 Nov 2026 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632088;
	bh=kvp3OkVy+SszLWIFkSYWY+dzg8k2mauBxngEG2KoUsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyLAaRP3btENumHrPX+z5xEXxdOZy/pbIuW1M7gRdMClADSjHftUTdFQVTHd6hMzx
	 lQruDhXPqS6HtZoJ/AS++mGj2vX2HHiTS8EN3GusMgiLvdXCe2LyDNg9yFWNyWW/q2
	 QKfAA/X2jroapwUQKX9br3DZHeICSCAIdW1KhIyYGSzj38xPmT5tpZtf0IE3biQ/Zm
	 8/2Z93d1VpMCbaYgjWh3xQacoJ7PIe8uozlQmxvjzE+E+lmG8E1xzyH+7mCkbM+u3C
	 b0ywrUC+hmI8O7NnKmTL6WyRTJ0Yup5MbVyzkIU/3yF0LueXd9oWJAZnL09UKztDh+
	 cHpyUwtYwcsAA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manuel Ebner <manuelebnerli@mailbox.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/9] Docs/admin-guide/mm/damon/lru_sort: fix grammar and stlye
Date: Mon,  2 Nov 2026 07:07:55 -0800
Message-ID: <20261102150757.93058-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-1-sj@kernel.org>
References: <20261102150757.93058-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jqhacujssdunswgj396kkfrmeurk3dzg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 76D5A18001A
X-Rspam-User: 
X-HE-Tag: 1793632089-352406
X-HE-Meta: U2FsdGVkX1+SIwFCYtyUSBcxzgldQxTE0hVRZ3a1SwT8I6tUmC9xkb48QGR+OW7q/y3NQn9EQNcxTSvVKghpq6UEjySVJQtzZQisAl5OeETpM2K9itpEHcXUieH3ACmz1v1IS/8Kz20iSRrJtckhIP5Vze4W2HPD4znIUdqzERZ7Qi4EFY67LEF7bWn5Bj9tIR2NklIfB+epr4unxjnCzcZWug/GDEIH0t3k5taTgqsi7FMLe7sd7KDrJdY0YktM/4wB+iLMqPwU/61bcjnQBQcax9tsK/3B/cnEsEnwJ2t+rRiuJevGMowyFQiJLezBtGtJzivjvU8aJetbZtogkMhpGK6hktracesHC6U7BkayyEnDertGVoTNhOKlkuGgNbf8phjCSymDWvXFefqNvyBziw6IJ05vLr5JKR5Qm6gId7czR8SFmlhssiBvx/Ugk2cPnVMplHLLQSZWZItV2ZSdboP5FHF199SLl75wN/TWTbqsPJv3zyH14r+LDTHWVeLbjoLcEHK/ytG3JHDuytynFqAVLfWevIc4xJ7h5NNZux5dyk5RiFphYvQqsZlBa5Ka2zGNX09PsM4nkKTTdzD0EMyA0LZ+FhF+TJrLtrwcshjkAHGWEv3fm7Zxr7YGCcFQ6DTX+wzW3lzCBHlMwzZp7ZyvIxa029/r+tjmQ9kybE7lSc2RF47ApPu5ghimIalRBKDnDCkz93mGB9RdCCfFqcp4HT5/r+dVI1e3+0u41cjW1FKanUo3ydL+ydpQosGJ/9YIUWZszOUAoIarKXr927cUmraIf9EhzsPtjlVsO4mMHY+mi/dnfA++G2OScwR2iGmCLbHh/YQe3t68qILsiIIZGNNSspA7Z93TEkqWUtOXYKEJADgYaa6Mz0H0gzI6r9Aeii2ww6xY61hGWxjqHqe38iLo92oRUoQzWE8ZYCsAbZNFt8UnQ5IAUWjmdqSfC4uBB31XibVrz0n
 naYRSxhu
 USzSb8AzCssvZE6WgF6jJAUolaW6MibP9m6i+EpBfuyVxb5glFIdpy/82ixlMAXQ/rZj5Vw0+Dhcv3X6GoCX2Rj+EE1ZBXppdDZyL/WFG8n4fHWrMP0xDR8Y6JyqOaoW15R5Z8Uj6Gt+vhgAGBZDzbJDhC7K0GELvpeyLapJfQx0BN2kmI10TgxIy/d5uBbw6nYK6m2AKkH5D6vjeC8lYxaBta9wYvaNq6PcngNJpYz3mfn+4gsGmBqduB2vYDE2qbchsmzJoewJKHmTPx+JSsYGsF9k5qbQ8ZgBRBXBN3HOTTJ1RpDFTHuj/PFL9us2ELspf6Mrw5mfhvCgeQ+rPCUnkkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Manuel Ebner <manuelebnerli@mailbox.org>

Fix tenses. Split long sentences thereby imporove readability.  Replace
'set as' with 'set to'. Replace [] with () to make the file uniform.

Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v3
- v3: https://lore.kernel.org/20261017083535.1261388-2-manuelebnerli@mailbox.org
- Rebase to latest mm-new.

[v3]
 Split long line
 Fix path in subject / One-line summary

[v2]
 https://lore.kernel.org/20261015072947.802821-2-manuelebnerli@mailbox.org
 Collect R-b: from SJ.

[v1]
 https://lore.kernel.org/20261013191327.663331-2-manuelebnerli@mailbox.org
 Wordsmith commit message.
 Fixup a few trivial wording.

 .../admin-guide/mm/damon/lru_sort.rst         | 61 +++++++++----------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index b93ca9b0853d2..f1eeb6389c377 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -5,20 +5,19 @@ DAMON-based LRU-lists Sorting
 =============================
 
 DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel module that
-aimed to be used for proactive and lightweight data access pattern based
+aims to be used for proactive and lightweight data access pattern based
 (de)prioritization of pages on their LRU-lists for making LRU-lists a more
 trusworthy data access pattern source.
 
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
2.47.3


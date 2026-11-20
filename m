Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E3C606A50D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KYcyvC85
Received: by kanga.kvack.org (Postfix)
	id 53B3C6B05B6; Fri, 20 Nov 2026 01:07:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512336B05B8; Fri, 20 Nov 2026 01:07:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401A46B05B9; Fri, 20 Nov 2026 01:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 125706B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D55991A0D65
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:52 +0000 (UTC)
X-FDA: 85454466384.08.DF1E610
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4925C1C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYcyvC85;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795154871;
	b=ZrCyk9YDoBsabmaRalU8s2Y0Sm7nlGiOh1TWbxSsHXS/1rj+Wz55W0eIrcnUNttGhI9HDX
	6Pn0tUPNb3D4OqoevvFivocQYILx9nQhrkQLB+tlF4xUyQDNFZ9FaqHJb8Oruf35023IyX
	UEu787KRsSq8ed+4MbfR8PKpj/v5wUU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795154871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTYH3LA1U3FT65ycu+eGiBs1yDDC6Oilxnq9ldGkodM=;
	b=HOqShnPyT2rtXENkeOwLix/xxGxQMQ9vNywN1m5ojCxSg9ANZDMtokhJSNkT7vzr7/JXfR
	SDdzU9kHR+K1asmUFDqgjzzEi9PHmryC5LmKMZZCdvZrYGAqqWMl79yrjvZ5+c/VSHu6K3
	FodvWWL6NRiKlS42xQt08bc5ABJstV0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYcyvC85;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E1B543E82;
	Fri, 20 Nov 2026 06:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473EF1F000CA;
	Fri, 20 Nov 2026 06:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795154870;
	bh=GTYH3LA1U3FT65ycu+eGiBs1yDDC6Oilxnq9ldGkodM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYcyvC85w9H2ONJL80krbPbpt1HtrOP2jmUGpjKKkdh9eaGESe8b91iaT6cPg4Y7g
	 AVlH/JNOewP/5JvKz49jJOQmrrmwZLEHcd2gabw5JRTdN/oX+DET5KDpWUeA1uSHpS
	 e1vCNMBwNJV/AHS0K222kx+iEDz5sRxaZk2YpAqGXngZcCWU5EFtsc2cyWHQXjtIjz
	 vwirGFm5lOALqQTJvM6xvAqP1sfHd7bTEvzma+Rp/n7/81GE/j2PmClBh5shUsks91
	 bAxa9ZCmoIkFZajzLOcmN7A6Lfq8DIx4ZxHTzyll9/N51tdVkOMqytmvPjQbD9cXsr
	 dmkkXfJLA2TKQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/4] Docs/admin-guide/mm/damon/reclaim: update for changed default parameters
Date: Thu, 19 Nov 2026 22:07:38 -0800
Message-ID: <20261120060741.92121-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120060741.92121-1-sj@kernel.org>
References: <20261120060741.92121-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 4925C1C0007
X-Stat-Signature: kkrmz5psbx3ufkruqw9ic7onzsp4a8sy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795154871-690660
X-HE-Meta: U2FsdGVkX19v/fdjv7j0V/LMcMGi6nYN6UO6/seN+KuvtoNhRKr9mxKdzLclGoVTiHVQsjdw1ddLTrXzLQurnynj2SXmY6odgjABhRZ/Ho5xx0S8kBO4hqwEB4zFuHJAlktLNu6KtyPtfsZbly86jceVKMJpLC48ROC0QKHvJOPsgDRqe7hb9FHeHmEENFmcFQmf3ABz1SEga3SMeSyxUqfRBZG8SopsN67vCtIs09PkO4YTlrxQemjyWRDanb+yu449FeXf/UK9l03m6yUQofkJQo9ZHe2X4kUT2fkYvaILExysMxg70WJ52zpkUXHSKfUDaKTuZ0rrGiMr/PaSh57vierzoqzE2dkYA/TdgFlGggGfRZLVhKnL8bKvyRviRqIsBj5tKXMjenU4ilUeLQscOVD4MBd/QoqmN1i70AISnhVzJ8SFAKaaWOfvdhmUMcmOBrVVc3UAi4aq8ZSBc3ZJDLHVQmsJHBmp3JPmQa5rzFQ905XoFuy3SJWWQvYWdFhcPlFAA9IyLPQ31Xsvt371SsjyN9Cog2TPO49b0IuTG2KSJcup9aKm51lT/3s18sh+J+fMm9sh+4Egd12vyIU3wZGowmcOrooYVFxh57cmEJwWgXFIl6K1+0LQEUqPUeXTzgOlhapyGDj8zZmRlEGeHH0uS7DH5tiBaEd/tesuljjUmn0+/W3//6TKUhFq8VJyYpx6wHZDCfwFcvByqHS0vCWYpWt6rf49QWA23rtBbDKFXIHyWCOQOXaFdcfj4xGv2CcVJD2Kkc3EXMQs+1qohW4HwplS81bhUM1iwjckambuk5KEf2X8yFd1Uhxz5RjrFBrJzWLPGfnotON/edUIMEqifwwauj3B2kCXMFjkREBdueKVcgV4cRTegS67b+wtnYZGjA5XzbEOHxD+ZYa/OGX4nHzaISEBSRHQO7R3TZxbXkG+WBPzRGJ1EPR/wV4NplbD9GQIDk1BBbw
 UjLVhjQH
 eAVsXSdng0HVUXtLIpuQ4Rfx8rtvkAI16MYed0hEGMEjU7qh4JDdfsJSULKaxcqBqcc6+KUKk4GUCQtDmp94Iayney6S5GO5JEh75i4NaYQ0C1Vy2CfysSYBljT26EEZRYefkeXq0ULs1eqA3WnE/kyzGjyuCmsXg4v62R2gUsAoIZ2CYJ/DvArseSAxBN45enpVxLuGCVgfBfnrh4YOV6eDuk8U4hmbwAGTIucbX3qcinQ56pCo5TqrOqMaUXY7wJaceIVybNv6sdsu64LR3SKeBN6oh3w7KeG00EwnpQQXPXFLR0IRwT9Dr86kyPt7BIlfNtpETQkprAg7m3P1RgYHnDJWAx90KfgngYK5IEb68ST6tQJCE33rIwB7JiXXutWNa10RTl9u/Xwbzs+hhGAEJqXWKMjE7ss11POTPwxh19LYd6K2IivvzPjL27Rt5Kb4VK2nIoKn824S+BppM1bijIF2fVOoVn2jDTOm8D+6LDGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON_RECLAIM user documentation to reflect the changed default
parameter values.  Intervals and PSI-driven coldness threshold
auto-tuning features are enabled by default.  The free memory ratio
based watermarks feature is disabled by default.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 0ef784df98680..79d24e3819cea 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -95,7 +95,7 @@ amount of access events in each DAMON-snapshot, while keeping the sampling
 interval 5 milliseconds in minimum, and 10 seconds in maximum.  Setting this to
 ``N`` disables the auto-tuning.
 
-Disabled by default.
+Enabled by default.
 
 quota_ms
 --------
@@ -145,7 +145,7 @@ per quota reset interval (``quota_reset_interval_ms``) is collected and
 compared to this value to see if the aim is satisfied.  Value zero means
 disabling this auto-tuning feature.
 
-Disabled by default.
+500 microseconds (0.05 percent of default quota reset interval) by default.
 
 quota_autotune_feedback
 -----------------------
@@ -196,7 +196,8 @@ granularity reclamation logic.
 
 To keep DAMON_RECLAIM always active regardless of the free memory rate, set
 ``wmarks_high``, ``wmarks_mid`` and ``wmarks_low`` to ``1000``, ``1000`` and
-``0``, respectively.
+``0``, respectively.  Use of watermarks is not recommended and therefore
+disabled by default.
 
 sample_interval
 ---------------
-- 
2.47.3


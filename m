Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4466E60D01EF
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cIG6hYuT
Received: by kanga.kvack.org (Postfix)
	id 9D9E86B0607; Mon,  2 Nov 2026 10:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1FC6B060D; Mon,  2 Nov 2026 10:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE4C6B060E; Mon,  2 Nov 2026 10:29:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5B96B060D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:29:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10E594014A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:01 +0000 (UTC)
X-FDA: 85390562082.03.1D4BDC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 77F69180002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:28:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIG6hYuT;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Iir60tzlJxsVWy2tki8NnHL4BFjO7m6tThvakIYkR8=;
	b=jYaEtSknahHlXxCA4QihxJ+VGxgKQj3CKOoXcQCDtK+BWkUg2/oDY+JX/a70h05BdKcp4O
	fV4HuVFPgvM9hbu9/BGbwbVgZVMWGONyCi3f5FeXZPF4ooCyGCsODff+rDq2rxyRO9UKUU
	OaOEjqF5qS3mUcgZL8yILOvm3NOyXfk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633339;
	b=nnCS6SjvNPstT745IZcC9/ILnLd/DFhnGXrq1IXxU8pMoJOhvJ45FX6Svt6Kvhxm+t6m+c
	MPxQWpkT8KtzUhts7cWdjDT6nuLcrx3K66y/tLQr2qHdw75/ZtUCydSxPE3bmJA6Zdywws
	o3QeeT7S1uiNlrob+Qa8VJmPcSLxvr0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cIG6hYuT;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 164EF60A55;
	Mon,  2 Nov 2026 15:28:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7562E1F00A16;
	Mon,  2 Nov 2026 15:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633338;
	bh=3Iir60tzlJxsVWy2tki8NnHL4BFjO7m6tThvakIYkR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cIG6hYuTYA3oYxQcCBL1Ucgfh0dcqu88fjQmfmwEtCA4SjrZlDPVkW61bOTW2KH4O
	 TFLLgrlkBMZmCDjL9VX7XSohjkvHPp/njaI8VXWDsRRafK5UX9q7ASyatOaRpd5X7w
	 yxdJ9bBAWvyTVQsRqPOHO5ChPOLaCmiP6SueKezq2XaMNpm58M8DPC5Xg1jHNy9jwx
	 yHDfect4zO4lscvlnWSqYcVE5gwOLNakrxiVH2tR4jFMtsuW48jhNrIS0WQ18S34K6
	 ukjp5JGkFg6Q8iWhcHRkcGZBgUjH1Ut8ULXh56Ungi1YXCpzJrRAt60+rhQxuuoJJv
	 0AvhLVDaYSpgQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/3] Docs/admin-guide/mm/damon: fix various typos
Date: Mon,  2 Nov 2026 07:28:45 -0800
Message-ID: <20261102152849.96057-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102152849.96057-1-sj@kernel.org>
References: <20261102152849.96057-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77F69180002
X-Stat-Signature: y36jwzr47qcpys9pnzibu8te11uc99mk
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793633339-581245
X-HE-Meta: U2FsdGVkX18U0m8Pa+hZNYFBYdM9qLYibrhm6JYYQ7EekjaNoQESQzwG4kL7guBnMBWNe1aG9Y+vrp9UYrjYsjue5LAQHvFXEUEKBNmjYeBqIlT5Ne8gZ3Q95M6/y97z3Xgu5JseJWdS2CD8MizInJrQr/mLDVuXUpauaxbsqGwuQ06mRa/glQhe+/tB3MFmK0Qw8FvZS1ObItZq9Wy9Snm6NtV+Lra6vehIbjjFzDxBkNJb/t44wPcvMkY5ztXZ3G46y1AXjls2FL/oWQwHcPHCCedrwQJkxKQZPC6iBoHwZxO1KnR8fqY5R99HCCWjkA+VvNMtuP4I4STxNPh6BMs+q667brr2XSb+G0huOubpwLTmzaFZaioZR3ZZBOCioXdmsAyl8sNmKpIIssMyWvNbF2QL/f4xm6HPUBq1iREp4508Wnucos8GBVv1L3rUMbrMWzC1nH6gPgLzRLaTX073wTdaya7CXDP0TvVW1OZLbn7WmDGW1J2v57qOmdJFAeznx1WZsKyD2xl3X1XHi9g3mb8jsKWiILfT0c0XKv++nHPGE5CTfzB+rQhOtzlMwcY3clNh8d+zJS+U9I8Az2XYMVUQRiqo9kOKWZFJF3jKq6nwXWafS+lf+WvUvN27mNuZi7XhLULESrYwFOjktk14fKIuYXPxzbyR4RCSjZcdC9bKD0+AcjCQj72BFWc1xabJBuA18fW4BtESiNT3RadtnVsTcrVKxfxOkqRcO8faBArAtoJ1sofcXeYcKgeEvylbgEcex6hu0DeCaAszUnHf+qMu5xpUlBOFIsc/NamrMQ3WVFsLS/dkRM19S5Itfq+gJg/ntbFzhgnYv0ByHST9Z1SNEFEzuG9xQfdRRM+8lGD6C6fVeNASBAfpmFLQqC5UECHWsH/VlpjEEppbrD754WQnfs52eFn+4dYmw4dRoT+7F3MI43txd05E1RTnQq+rIhrN7LCDwiHi7ne
 EAAgf5GB
 VV+XdRmX6GFJDv5F1bApoF3zXO/TaEkelm75bC9a0kB1DtZ4pqP2m81gTr6nB+ex3dNx/7jd1sQa22r9KdV9Brql336Q624NyP884mEIPi6XRwanUXfRKmxq9WiYDTQ4djFAg/0Vkrx+0X9yAa5RPZViOxWP7D7ov4hBEFS4NX668k4/Um+nmrcnNwQsaANOCjN/0TUftWdfp2FDI7vRMWoqH3RbkMTxzmrLRrSnBWYvBD1/mE+iIzmLfpDGrwwqwW71eFtYflfhn6/IOW3uip0CBE0vSSw5GHF1LUc30LM2NPXfpUA2Q84BeQsJj+TLgI1h0U69K6gsTViHV44lM9eF8fGCKwCjjf2XEl28VMaVCpKV1FpzApSk0x4CKjkqWjWFM03HFWB8NbGJDINsR4DrHB/aTkr8kgK9sTEY8FitVMPVnktHD+B3+hAi1NKKcgYbaQtPhmWynb5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>

Fix several spelling mistakes found while reading the DAMON
documentation:
  * trusworthy -> trustworthy
  * DAMON_RCLAIM -> DAMON_RECLAIM
  * charget -> charge
  * hetmap -> heatmap
  * colun -> column
  * evelenth -> eleventh
  * idlee -> idle

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 2 +-
 Documentation/admin-guide/mm/damon/reclaim.rst  | 4 ++--
 Documentation/admin-guide/mm/damon/start.rst    | 6 +++---
 Documentation/admin-guide/mm/damon/stat.rst     | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index f1eeb6389c377..02ea694426b2c 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -7,7 +7,7 @@ DAMON-based LRU-lists Sorting
 DAMON-based LRU-lists Sorting (DAMON_LRU_SORT) is a static kernel module that
 aims to be used for proactive and lightweight data access pattern based
 (de)prioritization of pages on their LRU-lists for making LRU-lists a more
-trusworthy data access pattern source.
+trustworthy data access pattern source.
 
 Where Proactive LRU-lists Sorting is Required?
 ==============================================
diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 14f9b82b38ed9..028947f5da8ec 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -55,7 +55,7 @@ enabled
 
 Enable or disable DAMON_RECLAIM.
 
-You can enable DAMON_RCLAIM by setting the value of this parameter as ``Y``.
+You can enable DAMON_RECLAIM by setting the value of this parameter as ``Y``.
 Setting it as ``N`` disables DAMON_RECLAIM.  Note that DAMON_RECLAIM could do
 no real monitoring and reclamation due to the watermarks-based activation
 condition.  Refer to below descriptions for the watermarks parameter for this.
@@ -125,7 +125,7 @@ quota_reset_interval_ms
 
 The time/size quota charge reset interval in milliseconds.
 
-The charget reset interval for the quota of time (quota_ms) and size
+The charge reset interval for the quota of time (quota_ms) and size
 (quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
 quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
 milliseconds.
diff --git a/Documentation/admin-guide/mm/damon/start.rst b/Documentation/admin-guide/mm/damon/start.rst
index ec8c34b2d32f3..d98b0eb8e7713 100644
--- a/Documentation/admin-guide/mm/damon/start.rst
+++ b/Documentation/admin-guide/mm/damon/start.rst
@@ -69,16 +69,16 @@ monitored access pattern of the process from DAMON and shows the pattern in a
 human readable format.
 
 The first line of the output shows the relative access temperature (hotness) of
-the regions in a single row hetmap format.  Each column on the heatmap
+the regions in a single row heatmap format.  Each column on the heatmap
 represents regions of same size on the monitored virtual address space.  The
-position of the colun on the row and the number on the column represents the
+position of the column on the row and the number on the column represents the
 relative location and access temperature of the region.  ``[...]`` means
 unmapped huge regions on the virtual address spaces.  The second line shows
 additional information for better understanding the heatmap.
 
 Each line of the output from the third line shows which virtual address range
 (``addr XX size XX``) of the process is how frequently (``access XX %``)
-accessed for how long time (``age XX``).  For example, the evelenth region of
+accessed for how long time (``age XX``).  For example, the eleventh region of
 ~9.5 MiB size is being most frequently accessed for last 3.7 seconds.  Finally,
 the fourth command stops DAMON.
 
diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index 46c5dd96aa2ed..4a9db755a5265 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -81,7 +81,7 @@ Per-byte idle time (milliseconds) percentiles of the system.
 DAMON_STAT calculates how long each byte of the memory was not accessed until
 now (idle time), based on the current DAMON results snapshot.  For regions
 having access frequency (nr_accesses) larger than zero, how long the current
-access frequency level was kept multiplied by ``-1`` becomes the idlee time of
+access frequency level was kept multiplied by ``-1`` becomes the idle time of
 every byte of the region.  If a region has zero access frequency (nr_accesses),
 how long the region was keeping the zero access frequency (age) becomes the
 idle time of every byte of the region.  Then, DAMON_STAT exposes the
-- 
2.47.3


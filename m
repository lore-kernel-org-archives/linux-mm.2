Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F74D3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005D36B00AD; Mon,  8 Dec 2025 01:30:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF9F6B00AE; Mon,  8 Dec 2025 01:30:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99E96B00AF; Mon,  8 Dec 2025 01:30:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C389C6B00AD
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E7E613BF06
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:42 +0000 (UTC)
X-FDA: 84195330324.28.D503714
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D71D3160015
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=StSBOZTR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175441; a=rsa-sha256;
	cv=none;
	b=bIwSNgjrhj9MJR/SjpUG2W1fwpMXghKJDyZ8JFyARw+0quwIp51r7J6+qhX6ooidiW8bTH
	7V4ME8jSp/gNdk2OWZKD4S4yE1bT0RxSMhN6A0Al3RNT3wNi0YLSaiSSLFsr+oqlKw9mJb
	rBQf3A6TCnAioxuP4aV6m4OZPKzINv8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=StSBOZTR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ga6pUOUWxBf8cJW/zE+V9QG90RqHitd4NAzcQwvoS8I=;
	b=DlQMDvOBl0QBilKaw9OAWdrateEwG6Qv1nX0a6Km9DoCihl8DKAKaf9JJBdiKP0KKOFH2W
	nFgaJnywdu0VS+2ZGbE9wa5MRGxu/UO2LTKOxvISSsHPfPxWj+2sc66iVnLbTmOwHm1Qgn
	yl0Blq8GYLy4HQ03iwY9g1M09gy/GZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02D4444418;
	Mon,  8 Dec 2025 06:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB2EC19421;
	Mon,  8 Dec 2025 06:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175439;
	bh=P2SgdyCf2ZU0vqy/RDrIyCr5Bu1z5InvNin3lNvOuEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StSBOZTRBdXApkEJVKfwmFrboFQjqC8MYLknLXOmdgrtgFNEfFPug4wod06n0TzlM
	 Y8QuzC0Gq3JOT8dUBFwR6Qx9y0F0KrPfAEY8XUYd5nDDcbx6V+3Q4fBnP74VG8Pr/F
	 lYTrYA1aiL0qrEx8xfvE5IWHjMD99J/QzETrf9oANE9uBVsuWecK6XBCmzxXxAyFZt
	 r8OCoBqkIhk+XAcaktUDsn9HHy7dF3X4pAW0aLtPYLd8QVy6OwbWaEAeCEKI4XkqiD
	 n8qkFLT/O1CemZfo1ng1PzlIz8YzOFy6N78a4vhQhnO0in7P1mRNOhmEXqhg3laGLb
	 EwcNqZHFCo6xQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 32/37] Docs/admin-guide/mm/damon/usage: document tids_arr file
Date: Sun,  7 Dec 2025 22:29:36 -0800
Message-ID: <20251208062943.68824-33-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D71D3160015
X-Stat-Signature: wzmum1dycsojeaqg1e7r8y8u4eocfd81
X-Rspam-User: 
X-HE-Tag: 1765175440-61097
X-HE-Meta: U2FsdGVkX1+nbk/pkr78qOprdvaYNQRORycfStk+MuPd1PJeFR1PHGKmvBoO6fx8zflE1ScPE5An1V5LP14C8+GmdgLFSl8XHnScLqW+p0np6IPQjH/b0xlyjuKY1rnWuw0Cj1QMM6tXIybUbhMqDn+xsjrQQ+gifsKOW0ZUYm5gakDt6+oJxGCEyRieQUMeYD2yWP5FnzQfx/TxNfVP9/4S8eT2BgYtgz/PEP7eOTSugLIBZbfxE/gtAEVLSdZy5aknmT8Jaa/a5laC5Xby6FbZCswP0s5EJVcSnbJ6XvJTmNt9MGQwuIMXF+DTC5CKiqx+fireU3lm6To+nWfEkrW/60clKRJAYfxFgfF4E9teKGrnySR+bRdRnrM3c+FnUO2VOwx57AB+84HY96Kg3ptiAxb9yqU18hFzf4YiX/tM6RD0fZ5H8dJm2c7ttnVSEQUgEJwp+BrfewRw0h/ZW3/WB/9WKHJ/h4BtXLNqpH6t2Ylg8NYaraWjWN8thZpyaCTAkCO+I3z8p9ikkx2zdQNw/D+vpQ781UgFHzZc+eGyZlKPz7mJzjPSkepww/oomeImN0C+Axh/RgJpTZYxx3edSgLxSwz3ZoDU+xzWPfbPTdA/Tn4PHpmz1hHC87mvi6ImRvwzpCRFBTibw1l//TOnfqGSp8cCgxzDlGk5YJNOC0/yBSRx3Zl23dptER9dJW2PGy7t8pD1q7fjCNbO5MXa/8PTx1za11uKPg/bFTsNF+FUQIh0jqMWquZaLARRhH7L/R9+3j30PbZ18Uio+Q4ur0jqg+wswZg/X6mc7A+ZAmqydBuefhKUs8RziVRn3ECRAywUT0IXJ40O7E/u3FL6Tst8PuF8h6EwlXdhXBG8G7AzHjDgV7/4VohfryHUPAua48XEriTDlEgD/wTc9aCe3Xzh0Dq23TrtRPuZwyhgYMBIltOLlkYF0BmEBjCcrcikFAAP5L6fFHXzDPT
 ZY7HwEYQ
 NSx/DItfdLOk4Ens9r+DiKGwh1bfniOiGv0vX879yRYwXr5TJjdoHrxk7+LSr602XhA68hElU+7tsrrUqXyYEJsZHTOzs2zRJcYGLHDR+vg9KzgYjxdwgU3dGU8OdBrB8dYY7aqe86/95zdATblVt7OGBWKx01MR8HF3Bc1EGCxa7QWOAHmjFYZoFaZ/M7f+DKZyhIJEr3tgGVIAotTc19fLZMs1Ynm785jTEOBS1hcyOTQEiLbZIrPNv5GYJcj4Zzt32aFMJMw4tw9wsqRLJJpYeiCQEJ3SmQcC5piqC+tpDFEfScijyCnYYBBTTT3pmxp8/YH/mT1amaA2UhJNFAKL00JcbEhuJKKFc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the threads based access sampling
results filtering.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 365a4548a5ba..d22d80710355 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -67,7 +67,7 @@ comma (",").
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ sample/primitives/page_table,page_faults
     │ │ │ │ │ │ sample/filters/nr_filters
-    │ │ │ │ │ │ │ 0/type,matching,allow,cpumask
+    │ │ │ │ │ │ │ 0/type,matching,allow,cpumask,tid_arr
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
@@ -260,13 +260,14 @@ context, in the order of the directory names.  Writing ``0`` to ``nr_filters``
 removes the directories.
 
 Under the individual filter directory, five files, ``type``, ``matching``,
-``allow``, and ``cpumask`` exist.  The first three files are same to the
-properties of the filter specified on the :ref:`design doc
+``allow``, ``cpumask`` and ``tid_arr`` exist.  The first three files are same
+to the properties of the filter specified on the :ref:`design doc
 <damon_design_sampling_results_filters>`.
 
-Users can specify the cpumask of the filter by writing it to ``cpumask``.  The
-format for ``cpumask`` input is same to that for other cpumask inputs like that
-for cgroup cpusets.
+Users can specify the cpumask and thread id array of the filter by writing
+those to ``cpumask`` and ``tid_arr``.  The format for ``cpumask`` input is same
+to that for other cpumask inputs like that for cgroup cpusets.  For
+``tid_arr``, users can write array of the thread ids, separated by a comma.
 
 .. _damon_usage_sysfs_monitoring_intervals_goal:
 
-- 
2.47.3


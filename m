Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B201CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 03:38:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22DB98E000B; Mon, 22 Sep 2025 23:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DE598E0001; Mon, 22 Sep 2025 23:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4B68E000B; Mon, 22 Sep 2025 23:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECAA48E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 23:38:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C3D558372
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:38:29 +0000 (UTC)
X-FDA: 83919107538.04.0E0E8AF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf25.hostedemail.com (Postfix) with ESMTP id DCF34A0008
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:38:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ax1T7+eE;
	spf=pass (imf25.hostedemail.com: domain of aubrey.li@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758598707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iJsu/bsWuG3pD72es3/VwEGIqRPyFmuQZmqLVsHUnDA=;
	b=rhybsnrEeWfTJD8ztOSc/uz5LmFVlzRtcP4qfUSVwrslF/qfUVDwlEzxFhLUj1IdvUcjyr
	X0ojbW2q5r6DI9ebOBum16WPGdM5XVfD9IjQ8mkgg7B7wnIUoF6BXfXnvuFpTIM/ZXp+h1
	6GSEkhllILOcghw0w5MNTbOLuBMZH5s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ax1T7+eE;
	spf=pass (imf25.hostedemail.com: domain of aubrey.li@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=aubrey.li@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758598707; a=rsa-sha256;
	cv=none;
	b=kOTce8k3hVfgzU3YogwdR1ZuoAeX2ckCbsL98MpZMhyP/DECTgflzDknnUjDfyO6Xa8tNa
	L/GUZjLIVLDs8Z5QBIPi1ELyUXNvEQycoiD0YPZzfaEk/d/cSr9M3NaJB654WNujIG4RoJ
	P8OXt8k6Hge9VCuryJrSY/YRxer7cYc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758598707; x=1790134707;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FizkU2Y4iQmHbh9eGNnE1mk6hmTzfCGAiCcr2jNaicI=;
  b=ax1T7+eEPSOoeaay0D2l27lRxRZSi+Zf7OXYk2Mdw22InXiuturX2PTw
   Wv6AQknn8Zbi4j0SRyS5TTrBhRg/+SmXQTFowGjR/hKeUBLPcfGuadk6I
   NZH8J4siA3cbrSMOhHONIDU+R9SukliFNEPJWAQvuxJsZtzUnBVqE5e3p
   jCE8rZtvSLb9PUJOtIQvkpEs2tgP7p2dZFcyQ6X6OkScO3AxoX+TGG4uQ
   VDTRbWLxz7sonORxZZtL5J299Wb5I/5HLQFfaJh67pICFEWERbYSRNOnv
   pexCcAjN6uzur3eB7QMGBjx5MESswOSQ6YwFCyuGXirBmWA7ckICn5K2n
   g==;
X-CSE-ConnectionGUID: R5pDWAy/QYqUbVzgjaRMxQ==
X-CSE-MsgGUID: 2OnzHRr8TGyrh/noNfBo+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60810734"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60810734"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 20:38:25 -0700
X-CSE-ConnectionGUID: QmgsTgPHTca/mCjKADKtww==
X-CSE-MsgGUID: khgnW+CHSdObyFHd7PV7xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="176231201"
Received: from alc-spr.sh.intel.com ([10.239.53.113])
  by orviesa009.jf.intel.com with ESMTP; 22 Sep 2025 20:38:23 -0700
From: Aubrey Li <aubrey.li@linux.intel.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nanhai Zou <nanhai.zou@intel.com>,
	Gang Deng <gang.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Vinicius Gomes <vinicius.gomes@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Aubrey Li <aubrey.li@linux.intel.com>
Subject: [PATCH] mm/readahead: Skip fully overlapped range
Date: Tue, 23 Sep 2025 11:59:46 +0800
Message-ID: <20250923035946.2560876-1-aubrey.li@linux.intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DCF34A0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 15rip3gwf83mes5ia3okuwz1gra69r9n
X-HE-Tag: 1758598706-643299
X-HE-Meta: U2FsdGVkX1+HCe6xF7hBWdBjUYYpZ6E6MU/WRl34yrKh6+t4rrkkuEzjtdGbXC56UBjObSwW/zDuUuWWaVcY+3/amGpl7dHsH2zFd8d3ZF/jn53qdTse6pEynVWJcHi8WA3eKyoQJgpwzek1r326fccPjCgQzh+9KhojuHIxfBMrurEgm2mWtY2RRTXxIhk5oDQpOQjtGkTu44PNLBKCNR6vrYvJe3xym6tSF5SoXlIUbFNP5pb4t2JqZqUmcjINsD6WX4mERd0YFPbyHCApnmsoyVqXirnnGUvsM8wbppOsJ2GRfQ+rL59MfVqWaz97LueHmlWpUIAseVZSuPDzNA3ibUAzgO4v+c576seuokvACUpWa64NSdJWl96zlZZMoy4cER1GBCcNNrP7/7MEDBClc4a+PIJddWUb3/WoAhfbkC7CqfPvL3GbhDEuGsPL8M6WiXz/JdwHEYRznpouILCVFgjaBbjRmc6QhF5nKiKhX/YnluoIsuVowLzCHCecR8q3x3egTooFyTEv8osQori9KwGSE0rE514wqlUwvALiyOOHxbzfCW1aokQuKd7QUts9b0dmYow6+0bzfESe438OR0mNzHxYBhL8vficGNlcaMbWTabdiC2QVA1Youxf5JSjKzVf9N5D6eXeqcD5TcNgjHq5rvMaTmcZNxV6dkKcPl1eaG3RNNWKCxSm4+6fg/y1TXYtb+k1CM54ewxnl50hQh6pgVhC9rJRO9dUB5CIgTVb2Hl2aAz63TpHI/fOn9G01Lh5BlI4kukvu4J6ukE1sK8wkN4ZkhHkFmY21A45WZa6g1OU0/GreVXY270K8TfIHn8+ySje+mui84Xmb2WQgNAJjVRjS5YNYwpABum2ruesp1V29Rg8KpLoCJocDBYACkc67pEaYNIXf6PsL44OY1iyQQ616GtklJEd2cCXkOqSNq+w5gyfeB1w3FOhCL19xpu3LSF6tig24FF
 eKdE/tXB
 AOit5AqitK11689ChVaf7sEBqjlBHIeVfqB/UtQ0yq+YBC3jbdHhKUL4tujdqf7Bg8c3LSJ7u0V1sA/bsT0Bl3WFu8PX2hqPofUYQed/QwQUZbxbBv8EZPon97cD/ATmSQ+FXsm1NpPlkoVyNvU4HgpE0XU0Y+Wrt5nu0ELDIO9tn7XOoRRs24jiu1XaSgb9UnrlcFOTOdTodyMwriCIbadudbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RocksDB sequential read benchmark under high concurrency shows severe
lock contention. Multiple threads may issue readahead on the same file
simultaneously, which leads to heavy contention on the xas spinlock in
filemap_add_folio(). Perf profiling indicates 30%~60% of CPU time spent
there.

To mitigate this issue, a readahead request will be skipped if its
range is fully covered by an ongoing readahead. This avoids redundant
work and significantly reduces lock contention. In one-second sampling,
contention on xas spinlock dropped from 138,314 times to 2,144 times,
resulting in a large performance improvement in the benchmark.

				w/o patch       w/ patch
RocksDB-readseq (ops/sec)
(32-threads)			1.2M		2.4M

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vinicius Gomes <vinicius.gomes@intel.com>
Cc: Tianyou Li <tianyou.li@intel.com>
Cc: Chen Yu <yu.c.chen@intel.com>
Suggested-by: Nanhai Zou <nanhai.zou@intel.com>
Tested-by: Gang Deng <gang.deng@intel.com>
Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
---
 mm/readahead.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 20d36d6b055e..57ae1a137730 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -337,7 +337,7 @@ void force_page_cache_ra(struct readahead_control *ractl,
 	struct address_space *mapping = ractl->mapping;
 	struct file_ra_state *ra = ractl->ra;
 	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
-	unsigned long max_pages;
+	unsigned long max_pages, index;
 
 	if (unlikely(!mapping->a_ops->read_folio && !mapping->a_ops->readahead))
 		return;
@@ -348,6 +348,19 @@ void force_page_cache_ra(struct readahead_control *ractl,
 	 */
 	max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
 	nr_to_read = min_t(unsigned long, nr_to_read, max_pages);
+
+	index = readahead_index(ractl);
+	/*
+	 * Skip this readahead if the requested range is fully covered
+	 * by the ongoing readahead range. This typically occurs in
+	 * concurrent scenarios.
+	 */
+	if (index >= ra->start && index + nr_to_read  <= ra->start + ra->size)
+		return;
+
+	ra->start = index;
+	ra->size = nr_to_read;
+
 	while (nr_to_read) {
 		unsigned long this_chunk = (2 * 1024 * 1024) / PAGE_SIZE;
 
@@ -357,6 +370,10 @@ void force_page_cache_ra(struct readahead_control *ractl,
 
 		nr_to_read -= this_chunk;
 	}
+
+	/* Reset readahead state to allow the next readahead */
+	ra->start = 0;
+	ra->size = 0;
 }
 
 /*
-- 
2.43.0



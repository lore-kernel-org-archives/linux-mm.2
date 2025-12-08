Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D89D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 10:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 100CD6B0005; Mon,  8 Dec 2025 05:55:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2486B0007; Mon,  8 Dec 2025 05:55:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A0A6B0008; Mon,  8 Dec 2025 05:55:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE9986B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 05:55:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9092B5C136
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:55:12 +0000 (UTC)
X-FDA: 84195996864.20.F9B1EC8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf21.hostedemail.com (Postfix) with ESMTP id 660951C000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:55:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HFLmpun7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765191310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fPMHQJSTY9xmM6T/8cvtqWn8Bv6tYIQNB4XorzJ49/A=;
	b=AGq7uBFWQctlEM8p/t8WA9fdi/AAsKrwmWpk3kUMTOK3elKHWtBs9/X38h3tfsl0zGF89k
	UcwyO3mR8J1sefUtlkX628HghRZyDgA27JeRM361SJ2wzuEV/As9NxInemaEcl45MPeqXd
	9UXuu426YD/zzY9szEEs4f/Mjn0Pz2Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HFLmpun7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765191310; a=rsa-sha256;
	cv=none;
	b=x7RdFWCAlug/UImllGtNyGEuyvyqPjbXwgBcksX23j1bexvOzyYds1Wq2vcb8ZQjsw/5pt
	aYEqAmuoIpEs8zmPF+tBx3MRzcBLufDxuG1CSD7o7nvbi0rBiKnD5bDB2XLmnym5fkHc9R
	/D7imqK9fpj2lPlh/1Hg0FyOiZpjWNQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765191310; x=1796727310;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eR6tluPg0scmT3evh+gt/RDJtWwlSItlA1pzm/H9EXs=;
  b=HFLmpun7mqYLMT54EaynfdBpst9BdEWZOVpKHNYDp0Wj1902HiO/1pVl
   u0pWlV+1KfaxjNqL4ULOWpJEC01G2x08T+CncgMyE0MrbIOI/UeCYJQvG
   pqRJ6ODq228RSu9EbxHjuxNYLu/0KMRlab35UKlabIihdQ2XPr9xuH3yL
   wPVEq1FZ63gV63rp41mDkTF/S1pA1DM2OQzwgana4QvLh32BVnv/YnSJX
   SPt8x6EfSeoa4r7tXYFkty3LqGifSp2sXQAAlz5Xj1GsFyTeqE6E4sQ/2
   ZVofazd/gmk3hgb6Qto43msXfnQBLS/UMPbOztMwEdc640whd6/z1sI0t
   w==;
X-CSE-ConnectionGUID: DLuxccmdTq2dWflS4yOfJA==
X-CSE-MsgGUID: qCcalTtgRgyR+zUrSqL6yQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67211059"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67211059"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 02:55:09 -0800
X-CSE-ConnectionGUID: rQ5oMGpKSXiK9wbMmzZ9FQ==
X-CSE-MsgGUID: 2QiPkdgaTCSuRBOcCamOFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="200375991"
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by orviesa004.jf.intel.com with ESMTP; 08 Dec 2025 02:55:08 -0800
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH v2] tools/mm/slabinfo: Fix --partial long option mapping
Date: Mon,  8 Dec 2025 16:22:40 +0530
Message-Id: <20251208105240.2719773-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1aki3qos533dtofskj3w3cszg3f7d87q
X-Rspamd-Queue-Id: 660951C000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1765191310-809004
X-HE-Meta: U2FsdGVkX19AdhIRh1cALVfUcBcvC15rlb+LA9v1+sSPx3KX/yzS/y8sMSgUdaLwDnC6gMKmgU5UkFhVizPh5JhKvHERENz2ZxV3DrU5zRkAOePBuNaK5uUX5uj9ZEV/A4HwjVmyf6xMlh9wvsa4ya+ZLj2bMp7Sfn4KWsntN3zig0DnkEyyjdg0y7NUKgioNkzPd9iqW4Zxy+DsLgvDH6+0urhmi0M8uXbYm3j2mgiszp0ysSAvrTS1dKqpiVaB15yuYS1CsBQ6AoStCzEOKf3+LVKhDEKTZKzA++1fCloa36BIBxmrcBy15iOgycdXxUAGHs9WEWv1Ye/yYzUsgpXOMUE4mTzbYljl53E+5Cx27aieAPLvPGJ1G/0lgwuXpMfNcyb/PR6suB9BSxPt6cMk35toprIfO/p1rl/omjB4/ajDHcFsfLQE3DaXfLCdMMDqRCbdCNnhGN4QeaCdfK1tUaF8m30aCl0qhSMDqqFt9zfL4JMRuTgFqSfTJfDj9NyLYAJfqr2d0mkFCX7eaBamNV78RO2Nqsa/HgdLw811eRJYzKFoS2nm4XYlqmN6scGUZc3RXBcAmP9yDKeGZXsckl8MJBPVEBEyE9SP6phytoC7B0XNuKWOMseh53SHLIstuFqS+73QIg1nbQcJIxXBM386opDJlrv+3qQmxMjfn2Dq5aEnC3Sj5E3WCkwkosivRoq+K5jrBktxVnncLVr4E+zdFy/8Ot95bcuxdjXjrg7vbOF/huAdbHW3LInvGWhubxM0P6uBr8olVPXDAOn8h4Y1P3hm1fmLiPabB3mXkxqn/r1JTon/OBH7NfwbGtlI2YuYu3UvxWLuhe4wghdcQc2XUsEfIdtefbKiAKL4aBgYdJk+8cmbx9HoDJjKirhoVECcAJJYFqBa5PVLUa2NPYP4Qvx4gbSspgWqE90zXTUuMbTO37SfMhW7YW3kG0Ruu+MHUHazNF1+dhj
 P1GU5c8J
 yROzlx/C3KV6vLrODdJTbCQv+M5cbuFKzJrFTkkSscr1hXxrHqxBzpItQKwRINIGC2D54nl0sYlyDrBVXV9AvsE4Bx568TIF70xr4eJMWxbOunglob77CmySKvzcWgpXz2MgyP88urtzqY6xg3sC8zWwdc/LhmI6BWs5o7apjaq0D9RY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The long option "--partial" was incorrectly mapped to lowercase 'p' in
the opts[] array, but the getopt string and switch case handle uppercase
'P'. This mismatch caused --partial to be rejected.

Fix the long_options mapping to use 'P' so --partial works correctly
alongside the existing -P short option.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
---
v2: Keep existing -P behavior instead of changing to -p per review
feedback

 tools/mm/slabinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 7c51d283504d..39f7eae7eecd 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -1405,7 +1405,7 @@ struct option opts[] = {
 	{ "numa", no_argument, NULL, 'n' },
 	{ "lines", required_argument, NULL, 'N'},
 	{ "ops", no_argument, NULL, 'o' },
-	{ "partial", no_argument, NULL, 'p'},
+	{ "partial", no_argument, NULL, 'P'},
 	{ "report", no_argument, NULL, 'r' },
 	{ "shrink", no_argument, NULL, 's' },
 	{ "Size", no_argument, NULL, 'S'},
-- 
2.34.1



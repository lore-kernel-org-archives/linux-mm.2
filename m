Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1813ACA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 10:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5810E8E0008; Fri, 29 Aug 2025 06:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A688E0001; Fri, 29 Aug 2025 06:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2C78E0008; Fri, 29 Aug 2025 06:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2753D8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:01:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAA3C1A0642
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:01:19 +0000 (UTC)
X-FDA: 83829352278.02.0B99EDA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf29.hostedemail.com (Postfix) with ESMTP id EB464120008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:01:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IN5GUZ3u;
	spf=pass (imf29.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756461677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Rixk04f1NzE5IpXmbNPYLIRCzJLscIo4IJrHzfWtWRY=;
	b=VT76HVQFrhtrnAH9QvPVdx51UAskIYmyXB6TFeIOf9IFX+kDXJD/LDhlZXncmltVwLRTLb
	RA1WOCKngxNq5ePaZjlOw7zLvBiO52LNBysjPlsgdhHRd4PIqs7nv8hcgmbikR+aGQjGXA
	zfC65Xh8lqNV+3O4wOQxGeME/a3etQg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756461677; a=rsa-sha256;
	cv=none;
	b=PunZHHqC+ZUKl1YpDhjK1IWihxPB0lcOrOGtCEXrOlaOge40LXpqTJkWleWTB34FFkSWt3
	1zgbwx1nFrEGZtHT+rZGP/zGkHVmcyA0LJTy4LgK2OkLrkk6HICe9CmFflHN9akdbZs7eg
	3pAp+5y0Qyui8SwnWT3uXzOpUus1kcw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IN5GUZ3u;
	spf=pass (imf29.hostedemail.com: domain of kaushlendra.kumar@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=kaushlendra.kumar@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756461677; x=1787997677;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LlcNkPbpwO1pwfCHrcrNwgKOjp6zTPPu6M4kAVNxgbw=;
  b=IN5GUZ3ulHZDpkMSlqX/yeadsQA6n7sNb6bjYzbcNOdFwukpUoSjTZjQ
   153lc8ButZbcN4tJX9mEXjZLjAigscnmx+V5ErTcMk6nkSFBJDaMfUL93
   Eqwe5NWH57zB5ptMm27QoUSYVDBPxFiGgaK/XiBjdiAC5ETRG2ML43byB
   Ut2u6egt9uq2SPIBCW+l9mZt0x9RT6VJ0yZ5O7GjkJbgWhS1k+BEXXllM
   w+akHE3R7HnBXNrExsiKJQfu05rLi4yYd5C7qFF3Pnb4+OP9I3rylTCEm
   c9FyynAcSZhUyao5TKxy3I+sISIOR66MIAOTL6eM+RWqd27LEcNRRjMR2
   A==;
X-CSE-ConnectionGUID: 9/VnSD5bRIu2VpkBAzJoyQ==
X-CSE-MsgGUID: Hey8/sWpTTy3II+pe+fd7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="57769878"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="57769878"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 03:01:15 -0700
X-CSE-ConnectionGUID: azarP2c0R3eQRUO6U4RmFQ==
X-CSE-MsgGUID: J+8+ZyTAQ+WJky0COJlv1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174517363"
Received: from baandr0id001.iind.intel.com ([10.66.253.151])
  by orviesa003.jf.intel.com with ESMTP; 29 Aug 2025 03:01:14 -0700
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: [PATCH] tools/mm/slabinfo: fix buffer overflows in fread operations
Date: Fri, 29 Aug 2025 15:29:47 +0530
Message-Id: <20250829095947.1828094-1-kaushlendra.kumar@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB464120008
X-Stat-Signature: i5cinibfib7wc7dd1ir9jyi69t6ijeem
X-HE-Tag: 1756461676-5654
X-HE-Meta: U2FsdGVkX1+S27NMo1Emm6NZEsmMiFtWatsOSY77wF6baIrQBp7V1vHMrhJtoC47Yu1yURyD5ER/NfabDKQCRC147GkzR9XYiVmjZtCXz8CWlyg7mp6z3e0yYSEGOuJrwCk4RG8iP7xOSMVeg046Utq5NuLElJYve/2jJXQ6O2GfayxVgp8X1c8Ey6EDrg8aOii+vYUe3VybkVmRKPL/DGMJzVb9JfXHK3KI+CpdP+donJp0rz/CvOCAc4A54Ni5HMwNUi+u+J2ga/Haz5EsOixdAO7OIsdkg/wyQtOt819g4UGD/Wav9KNMxbTxJDGSgYJTGPxcvGGf2RMuaQZz2lpFlAG1hD/EaGgz4jSZgr/yrym3dDwHVW+rJheMRPKRymkdVpFLkjfgyhMGzLRpw8HZeyYOuBBggUQDpsAxapW3TNdnkzCZMlBbh4VZnjpCeyqMpuqm6fGOqeT2AzahLgQU1zyEbbZvRciusXpa+hKCP37Berr2hqDuJUcs1GpMqbr4fIP1N7Xj8Fqm+xOAvW6tJPk81brhZSkOP0fGaYbzscpC5VYyw52bKoGUXIgIcMq9y5wjTYacVy/VGVHaDiDbBpfIiH8x1RSvvgOC4RWMcpE1rySasMjovKMJ5oVkyvgl/Sl4AMDrXJ6fwvbRNzLdgyeRBckBHqhjBAw+T12irqCqSNpjWIasGoAVkrRKVRUk5P+FChEmiJ5G+eRwcP2nU0MWs/TOvqf3xjpGytxBehe7D2hLoBJ2dKTfqULqNqtY6UcnpdoS+WDumUaGtJYqqIejCbhjgZ0QV3n9+oR70BEKteeztDR5IeB84aOObJtC9DOshnXR3Wo082SXSKUZW6aatgTtDY7Nx0pTMWXE+Ach3155cz8RGotMaFJcARHA0u9kxYPS5u9rRhkUCsZhcp+J6YFZcln7Qyjd+kp7tLhKDqnes/zOOuk+TzvGa2fklgE5UWSybsNVklA
 EsQC5Du/
 2FNIXSHTCpjqX/NPjenjsOxFkqR+hdhKPnuaJNG19YSEesSCi+Y8tFCi9bGO2ABMEp90QGFx1q7rMkXLzqMfTUfKpSoRbasLBqTa1lG0Lkmz2mauU3SHBKDuqsmkYmfDVFPYq17eEck3dVOlLK/2DGPPUknRbA0mtEmTJcNKfAFSNyXI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The fread() calls in read_slab_obj() and read_debug_slab_obj() can read
up to sizeof(buffer) bytes, but then unconditionally write a null
terminator at buffer[l]. If fread() returns sizeof(buffer), this writes
beyond the allocated buffer boundaries.

Fix by limiting reads to sizeof(buffer) - 1 bytes in both functions,
ensuring space is always reserved for null termination. This prevents
buffer overflows while maintaining proper string handling.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
---
 tools/mm/slabinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
index 1433eff99feb..1a7f2874c625 100644
--- a/tools/mm/slabinfo.c
+++ b/tools/mm/slabinfo.c
@@ -228,7 +228,7 @@ static unsigned long read_slab_obj(struct slabinfo *s, const char *name)
 		buffer[0] = 0;
 		l = 0;
 	} else {
-		l = fread(buffer, 1, sizeof(buffer), f);
+		l = fread(buffer, 1, sizeof(buffer) - 1, f);
 		buffer[l] = 0;
 		fclose(f);
 	}
@@ -247,7 +247,7 @@ static unsigned long read_debug_slab_obj(struct slabinfo *s, const char *name)
 		buffer[0] = 0;
 		l = 0;
 	} else {
-		l = fread(buffer, 1, sizeof(buffer), f);
+		l = fread(buffer, 1, sizeof(buffer) - 1, f);
 		buffer[l] = 0;
 		fclose(f);
 	}
-- 
2.34.1



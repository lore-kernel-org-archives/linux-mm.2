Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5775C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 23:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3456B0095; Wed,  5 Aug 2026 19:10:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B856B0096; Wed,  5 Aug 2026 19:10:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0FB6B0098; Wed,  5 Aug 2026 19:10:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BC3F6B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:10:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0227FA222E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:54 +0000 (UTC)
X-FDA: 85068762870.27.608C4D1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id BAC0E10000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kSXx9g0v;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785971453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iugKL66iLcE0ahFbQ5VGJD9xa6YtjYkcaWbCk9ue7Fw=;
	b=Tt+Y8LV9BWWPu047enXqvqZ60oofgvjNZC+s8m+xyVV4QOXe0CQ8QG+PzzZkawasxQbVXY
	7hRz3gYBFm0mssOrLkZ9k5WBlKLX8PYDTrhYPLaCYTyBZUCKmMpFnjIe9OTWfmo0vWUZTQ
	4GRpD/h9ooAMoeZs7L6UBC8zcoqtoRM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785971453;
	b=KC+T1ETxPIfOJ8W48m1UhIeic4xf8SN0hA3zJV18KFPBrOAPq/CIbXyS274KuYwYB3Q1cp
	3gxtEZsZ95w3AGp7wOfs58PHnufBNVZj/nMvbnrEcNwhJ5SlfNjTf1oxZdiVv+rCCvNKcE
	dsR4XALD9Pvp3SSinELuo4MsSuj/r/0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kSXx9g0v;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785971453; x=1817507453;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Jjq0f7O0WvJkLs4JYtXmw67Rzu5MIrXEQREZTu1NqM=;
  b=kSXx9g0vVpWyowDRvoEh2h7Wx1/LaBYfxbzDO4WhRACavNJ/jBnwqz9F
   YDwRnnZtyP01d7+6nfD6/EuZbaWrEq14LuKzs9bDXxC6GFlE2XkM0pk6k
   qfxH+K16wf0WWuM/CuN/dWr5QQ/kDakYXjA4zLM6CFRj+fQrlSgOLniSQ
   B87/aQMqch0BVq7vm2iCZPpNZYpR+aogfWCANF68gOXaf5eVPxGqK72pN
   mVF0a/UY3hEw6LpyIRuy+t2PWyNUu4gDI2XCadApbOex7jLtLvhKt+JYr
   28dzNKLKQfSwfkEXtpUA2/eMMJJ5l/iDg1MlfBfUVTw904M2VSeHOlHTm
   g==;
X-CSE-ConnectionGUID: U++D3HvNQbCmuK6dg5yjqw==
X-CSE-MsgGUID: BwGfUoeXQxiOZl3uWHhYoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="90376845"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="90376845"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:49 -0700
X-CSE-ConnectionGUID: dbZ5mZZVTkeTIfdkt0zbgA==
X-CSE-MsgGUID: 9Pr+QSRTQgSOCeG8Ps6dLQ==
X-ExtLoop1: 1
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:49 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sashiko <sashiko-bot@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/6] mm/migrate_device: Do not write past the end of the src_pfns array
Date: Wed,  5 Aug 2026 16:10:37 -0700
Message-Id: <20260805231041.3791771-3-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260805231041.3791771-1-matthew.brost@intel.com>
References: <20260805231041.3791771-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BAC0E10000B
X-Stat-Signature: toanp6u3kx4datjmin7z4ejifk46up37
X-Rspam-User: 
X-HE-Tag: 1785971452-731538
X-HE-Meta: U2FsdGVkX1+nqxWRjvgQGQ30wnJhFa2zyF9qI5tFL8Mgf7kT8feDyz4AKMTV4EvwBocSfjABsQgUajvIDi7iWXRJc940QIQSw+sNmvS9uKt7c6cp9fbrXy/SgozVNgzkGm70N2z4Pmha2sgenQBVU0Cu3hzGWqOqWCcGooWOJ5fiMfpxj71AYdSeo4gOv0Coehqkzr6CRQJKIRaQJK457pUgqeA1F0HvVza70b16zySGrAC4UaCkB/zK3/kEDRXWfjsHbYg4ToIqWnCkra1RC4ss/KsorPA3dF49y6SLU2p8hdWL3K2ylUDYAPpnvb6os2csRqdsHsgEhaL0EK5Q1uNtZFBCFyXCEX+XuhyYn1x756bBkI5A/Q80S4uthL0Jpa47c9lPqeYXTPGZurYhZ9vMOn3NA3hXaCFnLQGd6eVfkD+uzgIsf8UlM5/rLlLrHT5SgmD9M6LojvQ3iHXus35+21me9gZKUdVloKffPr6KATqK7LU3B8DlFR0O0k1LPxS/sA2k8+cY7RVO3fanO6qFdtqTmcfTUVpqWyJgL58EIbXuICb4pzOlKqisve6l/VgRIJGXZz/vAQds5y6+2AfhvpjSjbk+fVPOmkAGnHdflNWk2R2dbSY87JJZFRPrpLG+a8gMPPcpO7Ia9LckcaSPh8JoPQMB8bF043VBNhQ+zT6QcKInWAEs6L492ZCR4kqluVNZJ65EoD8XMdStXQVW4VX4Cq4PdyyjAfNZAoVTz3kFW0tts2j/0rnSpLor2jrcc+UhLcSiQM/1Xkpi5XDqVGcDbLVM2QEsqkFWGewLGmJFvLeAF6X75rpKth5kVGTvakCSq0jUrL3qd1bmUBX0S4RZtARdQdQIynI3vgeiiaunX3l0BwllFldj00IYln0+JdodjVf3VLLpiFbQsbnWpKMImz08ft10qTz1oCbA/6g4R9CEjMvnRM7z4VwtJiB+66aIbOW/zumOfEW
 bM9qkBvF
 vnnI9q6eVerWTABkjHjDPPefYOqRqGpp/FTxwUnnKDV3DEZD3KFd4f9pyyyUtKRmGk6xlEX2m3K6PO9N7pFjnwcVaTOdFSLUrOw9VMMlfvF+ZPMbISH+ceE9PTk9iWXq+SeIgzOFKApbbAHwrA/FsQTMSJLhHToiiG61R5oDpwt9ErEm06z54VIoq3fCvARmd09Dg2QNzWq7pf0VjkFLjB3fR/oK5lJPb7CCy82MtKQ32iBnNyVMIodksWO9+3kPZK9BIDQ48LMhO4h5sNjYtoEvzd7yTZ63xEPjo5R3ydPAbH+l96OgQeQGDId36XbjcLapO0lmjye7DiSzUn0TnQ3pp6fTgCPRSMin+Nf24M/aRBl5VRlOW4m/D9SQBT2EsbtLl04/ahwndFYGNRiYFH9Zg7p9n/YbO7y8B/ikwjkhNVEWF5Ykb4AuIMZCGgZNj2M7LpFhrDcDF3NCoWHBRID4pcZfUxLePPCJAEDCAFDrw5Q/JJWe/IlFFHzpgKSaY3bHfV50MC/fT+4g5thazYZJGCg65WSL77FaL66teenUZA5sr7jJTGo1eHdnjyKLS7k0Y+Z4mAQqFdEvF/Z+XrC4cyd3DRvfF9xu9MwipA42uXCWALDBVnlN2AUhr6e1mUQw31yc8qrfKS0X6orN7hv/LhgAdaVG5Y2oO2cmTJxH55j4V3/7VTIGxmXGDX3t3+eEIfpYIfO9hkjzWfrHhKNRX8deaUMtF87IS7qY+EVwwaLRMCOEiR+M303FvNnVM+2LMBO8AqiKmWqArt7FKU+ARzZoFmHAvX20J+7TPRsd8Byh/iauRn7P1f2NEeUbNCqoTBGjgbu31+RgOI2xfjBkmIz1KXbyQ+uvH8yl/tFBS672gn1M/fA4/Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_device_range() and migrate_device_pfns() zero the tail entries
of a large folio without checking them against @npages:

	for (j = 1; j < nr; j++)
		src_pfns[i+j] = 0;

@nr comes from the folio, not from the array, so a folio that extends
past the end of the range being migrated writes beyond src_pfns[].
Callers size that array for @npages entries, so this corrupts whatever
follows it.

Bound the loop by @npages. The subsequent "i += j - 1" still terminates
the outer loop correctly: on a bounded exit j is @npages - i, leaving i
at @npages after the increment.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Assisted-by: GitHub_Copilot:claude-opus-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 mm/migrate_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 162d29b2807a..ae9027421b80 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1415,7 +1415,7 @@ int migrate_device_range(unsigned long *src_pfns, unsigned long start,
 		nr = folio_nr_pages(folio);
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
-			for (j = 1; j < nr; j++)
+			for (j = 1; j < nr && (i + j) < npages; j++)
 				src_pfns[i+j] = 0;
 			i += j - 1;
 			pfn += j - 1;
@@ -1449,7 +1449,7 @@ int migrate_device_pfns(unsigned long *src_pfns, unsigned long npages)
 		nr = folio_nr_pages(folio);
 		if (nr > 1) {
 			src_pfns[i] |= MIGRATE_PFN_COMPOUND;
-			for (j = 1; j < nr; j++)
+			for (j = 1; j < nr && (i + j) < npages; j++)
 				src_pfns[i+j] = 0;
 			i += j - 1;
 		}
-- 
2.34.1



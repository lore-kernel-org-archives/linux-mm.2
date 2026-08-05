Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 707C0C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3A56B008A; Wed,  5 Aug 2026 15:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574516B0092; Wed,  5 Aug 2026 15:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463E06B0093; Wed,  5 Aug 2026 15:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 18D8D6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:35:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 953D71A05CC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:46 +0000 (UTC)
X-FDA: 85068220692.12.DAE9D18
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7C6CB40008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:35:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TovmKB2V;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785958544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BmjNo2be7cKeikOm5yF41o8c5ENF9J8dq21/6q/WtK8=;
	b=8YGhpHajV3SXlMeKVQpCqYaZXuL8WgRxEsKgEqBvwZ7mM62YFlJJ3IHEIu6MPxuGItGkCB
	8AWjo//e0z33vAz72gXBR4qxN7b5qEeCyp0U4a3I7sB+Ae+tnd2XKKF3YKWl4vYF1JUlGO
	YCS6rgZq4msWgRC+WWDnt4YR4uJVxKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785958544;
	b=HgnUcV5JeQ211KCIlohQW5QXnd+1RmtYouXaaQuigpi6b8iJ5c+fXt75VIynbl1wwYf/ty
	ZNxgMMRq7Gz0BB4K/aQP3RsnXewYyXvbgcrl6BQ53injR8Vi/kj3w1uCtdmDd6X6u6we2J
	yo4K5lCLKnmdWly8WAD8Wb99x+6c0Lw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TovmKB2V;
	spf=pass (imf01.hostedemail.com: domain of matthew.brost@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785958543; x=1817494543;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sDSmB04u7511d8QYCqjiDsa689yH07QzsyscRbCuKVs=;
  b=TovmKB2VHCZCrwPoVBq/yp+gMrRg/cuqfl5aWOycbnAXRirG88PbAJly
   arWZzTPHLB0xeJlhUHl3zgPQmX2E8Rvg1DRWlmSSvKUjGSAr9xgA0C5tL
   UwTmpI1fFUnx6IR+wXV42nZI+VEzrSKU1LpUl4LZoqh0t0uWEnZo5BDSv
   i7qIzQUlCXQ2E5zRA4SW8iF7i+ky+4RIA21pKdYK+1JAXOaDfXcVsle4/
   XIHxY5Cr0xWGYQWyKt4aacePBgqn+DgQ+xZd5ul9bcTOmIunNpowYwtEh
   fwJT2OXFxKbmJpYP2g9Rb78UsZaIbYkQbng38kbl8ybzY5O66+id1+MS2
   g==;
X-CSE-ConnectionGUID: YcyMwFx2TO6Jwp3p2d/HaQ==
X-CSE-MsgGUID: /UbS1fmPS3KdFYC1GV3J3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="109332914"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="109332914"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:42 -0700
X-CSE-ConnectionGUID: wi5TCODVRw2LpdBi1XBMNA==
X-CSE-MsgGUID: iFC1GBGTRZ6KFQ5eCCRW/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="285263511"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 12:35:42 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] Fix device page migration in low memory fallback
Date: Wed,  5 Aug 2026 12:35:31 -0700
Message-Id: <20260805193536.3756457-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C6CB40008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: yaf9ptusss6aw4ftcedchan5dy69iggo
X-HE-Tag: 1785958543-485057
X-HE-Meta: U2FsdGVkX18uFfSXxaK+V8567QPxrALUBXMocjUxAfuk+pkjmT0fIPYKO+RMWfvIAgbcnbDdsv5SUBYf9lzdRVn/K/vgI3KFMZ4cbzw/oIe69vxAD5f2ke39j7GXk+O3UKYRV1REReWGpd7K0Pvl4KYqdXOrHsP0WW33AqXjfgmljDdNgk5d2nnnKFFFs7FtGzGiqYrdXtDyr61Wwu3FS4IO6Rzz397sbAkGUGJI3yPxL76buEYNMLlyckB3PtM9x5LJi6YJmlhQuZxkbzantwyYQM5dd7d8AdAaQnm6ktIl8ffUlocJOuH+ZLajmc3XhnLYqJGLApk+3Aa3qNbq50Ca+dIqfwG3EacyvDqu514CxDk0vTssHu7s5Cc7YhyLyy4AYLmNoQOwOcwXrJ5YxbXbC/16tKPaA3HGp3gpCfr91DZM7jf3Ahza3Or+B7DvwsqHg6dJhvxoteVGBQZ110DUSDAVzcD0ox3/rHsGTiGgc547q943/8hcLbDbK1qtTMgihTZfxZLFKd7GplOJUlD4FgX7S4mPbc0L/j+XLiMX6OPbIFGZ+M3vieE16fS2edtsQTA/aGqRA86l5HDmucGhLmf0QtfYp9q/suglt26h/OCY01akP/wwyBFYfZPJPzMpH42gozhdTkL6trIe+Xhc+m2NAODgYLRWkczTakJH3f0AjRyNSU3fIIlIwJNgcgp2F/BKwV5ZG5nGN9asKOOLO3pHvr2tT4D2h9h11n2+5EcPsPo6Q7uRdFtpecOn9uMwqskU/P3Zmo2GatjhovjZa1rZsvwnmqKCqfqK+Vtn1usAb6BhUlSzXDpIca+ZKOiy2go3nh+C+CET5wBZiMLTewbPMfGU+RJyIW8usuHTQ14WZRLZ4upYvSOKvPwBMNt/JjP8/p9Dsr/P2i+ZvUz3KQx5ExbR67CXdt+d1RnMht9oaPtVqlT6hmDCJKG79Rcm1HuIDEWvUdHHswL
 UQrmBNuu
 k4HHwchZtmjzlyzbI82/gSIJGu7LYTB8z7/emCHTS4rv9miEuSPpx6inyw0AHSCkkHie94BlR2/vtWHiJTBNet5IYIvAGlXNvwcuKFCFq4lVa+p/jsCmJ7F+JUq0WWCUTR8JryKAphnjyAXxw8ONqrt9Kl+sU/9xreQDIXxBbBxeAidLKFCfUQMbx0q2qGF8US9n8oDrFbLXaJ/GtTb54bh69Lomjim2zQgNhcEZTU+YZsGQgj9ClErSrNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

LLMs made my breakfast, lunch, and dinner. Not really. They served as an
assistive tool while I performed the debugging, testing, and analysis
needed to isolate the root cause in core MM while fixing a known DRM SVM
issue involving THP allocation failures in the CPU fault-to-device page
migration path.

When a CPU faults on a device private PMD and the driver cannot allocate
a compound destination folio, the source THP has to be split. That path
is broken: the CPU fault reference makes the split always fail, and it
demotes the PMD only in the faulting VMA, leaving any other VMA mapping
the folio pointing a huge PMD at an order-0 page.
The latter is memory corruption, previously masked by the former.

The DRM side had its own problems in the same fallback: there was no
order-0 fallback at all despite a TODO saying one was needed, the error
path computed folio_order() after put_page(), and once the destination
is demoted to order-0 the source page array has to be populated per
page rather than per folio head, or the copy stops after one page.

Validation was performed using xe_exec_system_allocator. The issue was
initially discovered on systems configured with an artificially
constrained memory footprint (mem=8G), where failures occurred
intermittently. Error injection was then introduced to reliably
reproduce the failure condition, enabling thorough validation of the
fix. Results were confirmed through pass/fail A/B testing.

Matt

v2::
 - Add assert in 'Fix folio allocation fallback and use-after-put' for
   THP placement invariant which Sashiko hallucinated as a bug [1]
 - Add 'Clear MIGRATE_PFN_MIGRATE on all sub-folios of a split THP'
   (Sashiko)
 - Fix checkpatch issues (CI)
 - Swap cache issue flagged by Sashiko [1] not fixed as this code doesn't
   appear reachable (i.e., dead code). Can address in a follow up if
   needed

[1] https://sashiko.dev/#/patchset/20260805113338.3742178-1-matthew.brost%40intel.com

Matthew Brost (5):
  mm/migrate_device: Clear MIGRATE_PFN_MIGRATE on all sub-folios of a
    split THP
  mm/migrate_device: Fix THP splitting of a CPU faulted device private
    folio
  mm/migrate_device: Apply the fault reference to the correct folio
  drm/pagemap: Fix folio allocation fallback and use-after-put
  drm/pagemap: Add fault injection for higher-order RAM folio allocation

 drivers/gpu/drm/drm_pagemap.c | 164 ++++++++++++++++++++++++++++------
 mm/migrate_device.c           | 129 ++++++++++++++++++++++----
 2 files changed, 251 insertions(+), 42 deletions(-)

-- 
2.34.1



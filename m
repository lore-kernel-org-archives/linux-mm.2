Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB59C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 23:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A496B007B; Wed,  5 Aug 2026 19:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBB636B0088; Wed,  5 Aug 2026 19:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD44C6B008A; Wed,  5 Aug 2026 19:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF716B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:10:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B05011A062A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:52 +0000 (UTC)
X-FDA: 85068762744.11.2A15561
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC871100006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:10:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gl8fzzll;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785971450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bhtmymBQrzXyulvhfPtzyyylU7InbsXqLHdnK0u9ZUs=;
	b=HOKmNbK3EkoQvaoDroKibDmQaWEjU4yDUtaEIABNw6LXF1cOnwd148Tg+Ct7ue3p7jbXbx
	hP/+sCOh4WgqnYpuMUUFCADaQAFdE50DAyWfmSQr/83ZYt4r7JmvliA4qqfqK4IWF1uHgf
	3GalXB2R0H85wox/3OPj51Phzw+yu3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785971450;
	b=3ScmKdOEvtyz4rdflmLmOApzbRigmFeKkeYo8OvSBIe0GIIjj2PgGi5ie93aw4AgWVU9cf
	GAWKzISOm2DHpBTe+xXKId3GzjEL9hRvr2sGZT2ocXh0oq08nfydHr8KgUZmnNFnYpgwrA
	jayNF3J2cnBHcWFOugBtcNDRCE0T65Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Gl8fzzll;
	spf=pass (imf14.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785971450; x=1817507450;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wcrrRa+4I//FxNzlk8YFHVMlyypMuuBxwcQUh0A+gu8=;
  b=Gl8fzzllhdqlyUwfOo8nyWVjrc6oKK4vIvC4vTx5TvtEZulozkjGvUR2
   6iblTLii+VCwg1IjeXYLAzrtuQvgV0Sb+4UoXPkQwjPJ5M8URCrv7sSo+
   8DOtTeRce7OJV9u0LhwOtSym2ZhoYl7ak538htNMPufKs+0stYIuQbP3T
   cHHidEA3/ROSYD8WJP0WdXfpSR4jbZQdkH/EMgGrZhBcVQPquC8enED6L
   frhVaeJUl1QR78CUuRGZpCt1UgMaQcWFpd+Kg5gH399B4nc2xjwiwvtqg
   LsLonswgvPlAOLYmCKZ4BHcF0LRKpPvEy3itpd8vdmCbUrEH6kzMWQQWg
   Q==;
X-CSE-ConnectionGUID: rIiS+EvnThi/M3nOaJo1AQ==
X-CSE-MsgGUID: azJ3yLFaShafFgDrwXVCIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="90376830"
X-IronPort-AV: E=Sophos;i="6.25,207,1779174000"; 
   d="scan'208";a="90376830"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:48 -0700
X-CSE-ConnectionGUID: 3FGNTL4dTl+jHwbqofn0pA==
X-CSE-MsgGUID: Wyo0mZ6BQbGq1+nnfgAAiw==
X-ExtLoop1: 1
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 16:10:48 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] Fix device page migration in low memory fallback
Date: Wed,  5 Aug 2026 16:10:35 -0700
Message-Id: <20260805231041.3791771-1-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC871100006
X-Stat-Signature: zpz1aktp4z943z8xb1a5xfr8a58k37r5
X-Rspam-User: 
X-HE-Tag: 1785971449-748351
X-HE-Meta: U2FsdGVkX19Y3rH90BPR8ZLAtH1PR5sdDUS0PjrFCoqqI+fPf/VqawjZUgR9lT5VFQF9wanQeSswJLPsdvE8ZB7cnIByesP10wdJUarCi358NMy6OZUYnZBE1YHUIgIg/9siWU9qtPrpGGWkcqwZqPsMEx651GgVf5AK0sF4WPiev8V00l0SndkUyn8MtnbckC69xMLHeVuTgf7dZu+XemSw3h0W+XpKG3xE3/cVFiQZ4Ah/pmkpzS/6tPtacoL67qZOINoXL3nnOZH7gWmMQ5u7dZTvJhorkcJ9el0HZT1y9Let1e3qgUjIuITUSU6Ev2NzATD37H9aBV9eIrh+gDOlYuQW0QSZlq6VS5+gEsLIUBHo0VpPbgiDVIZmmZ+C0pewmS8n48WDlVMGji/ZGYDHaAnTpVcwgx7+FCpoqhJ3luPpGdBXpXhig8acTkfztMRfl1nUJ5ctGk86Q6aQrWOUTJEEQSLVtPnQd5T/58ggNphVP/NFJ8Ty8KMw98KHwR2tM9x5f7PITXIMsO+12QRmWL6OeMyR7PAYqdyLz0jUbbGhQEh6DmWFHYzl4/i4qIbAtwtVP1cvQJm69dhUdYGFXxF5ah+hct2p9FC9I8fJRAECpRdBqLSsLJQ0EDrF7I7Ql+EUoI/i1ZG8d2L/a/r8L+OAncjov8HVc3uuwgMYEfCbZfGJSZe+XC6soVHs5ADyClEH7OBGGvCxGzWjapydWDrLnGFcCAPc/QBMPfYeLB7xmRPYvqh1Uyk2b5MenSscApEIMdR5y8Q5YrK+CLqf0ufSxIrFxM8FfDVRW66a3vsqceqkdGyQVCI5ZQym2pza1xKe7sJzJIgCN0GUK+LRGhGkbZqQR6sXpzt74dosU3xGoYDk001lW2aT2xHkeUZqzAmgvj0GLp3oB0qgx4nI96NDZqN/XNQ8263lVLTx74wZPRt+tZBNVuHr1Lwkv3h7Wy1KKsWU/3nnzpC
 pE1tKl8w
 zvQRmniiqxNlrUqrWPK/eBY1In52o4M5PCgGnBlh5Rt6lRhH1xmkGRyT/LJwkbPBB7EeJcVH1w/rl06p37O0fPENyDsNL93IBMAThFdooD0rg2cs8XlO+CigRh7vCK1kF8dmizYXRHr11PfyqK7WTcNidZETr37Gapa7P9L/iQfuJymmdPUZ6m1Oa8/8JXF5WSpTjIrCHk0chHPYtc9PCGdDDSFwiwWzHJtSDzaRD911IJRnjKx4MP/ziQ/y93+sDQDn6KR+TcdZOEgxdHFyGUsX/OZb/3z+arYm16FvXx+N3Ca+BIFH1Qte9Fw==
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
v3:
 - Noticed Arvind's patch [2] fixes some of core issues attempting to be
   fixed to in v1, v2. Verified Arvind's patch works as expected and
   including it in this rev for Intel's CI which is based on drm-tip and
   does not have Arvind's patch. Dropping unnecessary fixes from v1, v2
   as a result.
 - Include 'mm/migrate_device: Do not write past the end of the src_pfns
   array' unrelated fix flagged by Sashiko in v2
 - Include 'dma-unmap pages before handling migration errors'
   unreleated fix flagged by Sashiko in v2

[1] https://sashiko.dev/#/patchset/20260805113338.3742178-1-matthew.brost%40intel.com
[2] https://patchew.org/linux/20260728062832.1107127-1-arvind.yadav@intel.com/

Arvind Yadav (1):
  mm/migrate_device: Clear stale mapping after freeing swapcache

Matthew Brost (5):
  mm/migrate_device: Do not write past the end of the src_pfns array
  mm/migrate_device: Fix THP splitting of a CPU faulted device private
    folio
  drm/pagemap: dma-unmap pages before handling migration errors
  drm/pagemap: Fix folio allocation fallback and use-after-put
  drm/pagemap: Add fault injection for higher-order RAM folio allocation

 drivers/gpu/drm/drm_pagemap.c | 176 +++++++++++++++++++++++++++-------
 mm/migrate_device.c           | 115 +++++++++++++++++++---
 2 files changed, 248 insertions(+), 43 deletions(-)

-- 
2.34.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43468C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 06:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C774A6B008A; Tue, 28 Jul 2026 02:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E366B0093; Tue, 28 Jul 2026 02:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F836B0095; Tue, 28 Jul 2026 02:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6D16B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:28:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DB71120241
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:28:49 +0000 (UTC)
X-FDA: 85037207178.13.D7C7B66
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 285B880006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 06:28:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=golX7a7n;
	spf=pass (imf02.hostedemail.com: domain of arvind.yadav@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785220127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vLschPK/X4XLrH+bMuNH/WDwOJdmzWSKYORl2Ns9okI=;
	b=SMhkQgjr3Gpd4Lw6imhGUFrtpdZp+pk1OudSVl/8hwO57hdjBHkE26aerB9f1LkH5W/qg8
	ffrhZ45J7CXK2KLkDJb0viaLQiRHdZmOwXmPZmqV9r6bLPmhG3sU5o2EMGhEdldJmyQVRY
	T1sNSxQVXAb15D74H0ZvMOOJSfb8A64=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=golX7a7n;
	spf=pass (imf02.hostedemail.com: domain of arvind.yadav@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=arvind.yadav@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785220127;
	b=2MPy5C5tKsS3e9cJrk9Wxb39I0PQwLHWHoGVMuMBRL7hisK7K4SH5dctNciDwg+Zb/GOJx
	RCfOrsqZcfPCs+gPNCKR+/ollYPfHAoZRK+PY2dq5YS2JqMBiRUSEabu5VnByprGTTXup+
	uTI9KivtN6dlCSBW9XXWJ5Sz1uH9sgI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785220127; x=1816756127;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kKygvtH/OzsvbEzhb1WD9p+0+rChW7yxWOwVTVF50wU=;
  b=golX7a7nvJ2hb+KKJoESg8N48fmBbWb7zfuPcd7HtsP6MYoFukJju8/0
   XdBlEM0ok/8zpdnwto9vegsxgwg4NBtrA2amoiDMcIjEKatLlAtllCe9b
   0gYLsQdOjyW2k1xsQBpFID9DaLsduxLrv5oL6d2mRLKMV/nSynfyTeq/M
   YYXEvAuqBSFRdO6DDPKlAFu+73ox7VbGVeAkRb1vLWhY8YocJCTkGdits
   y4n7JsTihGADxOTGPIaEsW+ix1kw7ZAyvIH+uvJO97VMdSovVQ31tzfcV
   hwapseFDctE9rbaHuteO4mVtKMFbTS3SFYkfQ4o4brb7jqbyyhy2SuOuo
   A==;
X-CSE-ConnectionGUID: Jp7z90ukQ3m9ApfoLJsR2w==
X-CSE-MsgGUID: RitVQnWKR92L38ALhkm6mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11858"; a="96383815"
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="96383815"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 23:28:46 -0700
X-CSE-ConnectionGUID: 8rkuG3GNR1OX+PPXZvewPA==
X-CSE-MsgGUID: T+f44TYfSoeVUAE6EBzY1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,189,1779174000"; 
   d="scan'208";a="289575953"
Received: from varungup-desk.iind.intel.com ([10.190.238.71])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2026 23:28:42 -0700
From: Arvind Yadav <arvind.yadav@intel.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	ziy@nvidia.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	balbirs@nvidia.com
Subject: [PATCH v4] mm/migrate_device: Clear stale mapping after freeing swapcache
Date: Tue, 28 Jul 2026 11:58:32 +0530
Message-ID: <20260728062832.1107127-1-arvind.yadav@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 285B880006
X-Rspam-User: 
X-Stat-Signature: kjecfs6me4spu318396g6ocn7m7n3tmo
X-Rspamd-Server: rspam04
X-HE-Tag: 1785220126-837390
X-HE-Meta: U2FsdGVkX1+4NbjUdbp7w1gjqIcWHpGwExwbByi/jVZxkgK30Oxg16x5ksYHKmjwtFkZWj3eR55UgKnFTTOo7zRDEJtsu1V/fSZSIx/4B/yBSMIPaLERow4JvSuv+DBNE6hU/b9nW0OZTWlQY517M7Q9gvTBovrlhCSUI724TsY4NbGUfByhJ0hMYKn81Tsp+zB86CAA7kX+N/o5L7+nId67YRzh+OfjkLq4UCbRp/RsOQ66IgDAkRh2f/f/YFRHoWZQUleXknmNGSIA5edVwmkHuwqcCoG5Ewr1HQowPf9xxrM5GxasmANymanlL+MHVmjV74OUCUbA3Eq7DZR6sGaijwR4CfoN3R1R0CRUkQQ/IxsSrGaT5daHZkYOJ+HX6WnlFWaS2B97Sky2AbtF3I4Rt9qYCxkQGF8X6Lia0RrprJYCJ/HyuCsyDfiuRsiUJng8v2/DbuK5d6IOx8Jfi3W2s7+FR7Q2wSFKUTtonlJx75csdqlyh1MM3hA9J4QcIMAYzL3wkE5KUXrpsSzUSGIXu201mxjOoxfZwx6MQ/RJs8IHMoYFQFli3aUIvAMqaWwRxGQbFh5BH2u8GYEvKJkR6BUT4nOFHfrEJdVPDZxlkc9913ajrjKkMvn33Pyg+ZZvr3zVKtEzM/oGFO7FQZ2Wu7C5rBETzDumCZPloXzFqx4xnFQsqG2mHpfKVPOeyCLXrbLOCqvaXpnGgUkKj8DQJm42Jyl+2TbdSYK3EkgDLzasKGZBMBsa84X5wY7ONaV6ZQYfpCBLWqF5BUXOfKuNR5fDud8RiuBFU9vSGLfh+NgrLUQqcOlesLDo6jCB1JUVLJuWM2eVmZXEeFMG0IT6H/HV47faAhbQu2n+pH1Q9716YLL3pP5y3xDT5RuStcv2tx3ffw83EQQ5k24UFS3yup5HPvki+8gBbBSHQVAizl/sI2t4/ojqdpsTEUUAMSJ24rHu6IQQZUzVqp0
 KjqkbNR0
 Ck+tkoSB+KaKMGp9jMugTlFdAT4kO25eynv/PkVK+HnhCXRQtCQfE0K9qUHVMy1z5VKnMfijGHFKqnMxE9xRTxUn6fBEJ0Rw4zxUS1+i7hzhZ9XjqMWtb/923iU+32wv1bv/LghpRTHL2FEq8UgIcFlvyCkMUcOyMfQNzLOKI+qB2RrLOIMOAdvKkcEBCOQTfHgBY2j+1YgVUvGGCXVUsuM0NcKmC1j1itgtCgo+WoDYJJi/FT6XhkgURg6poDlrgWXub8BBlcPGPwVTMpbso0EC2Vd6j5BWzr8fmu1/a4LL9zsohtbLy5m5QuyeTl9m3MXrmgEUVTEwbLlBHs33s0ZD6l5fUlmYWNcTQ41BzschmKAC9u6rqI/bG9aUGMZTb7hC696O7NUkSWEq+xCRbYBnR9zgISxoNwvpbrQMr/WQJ/QRM+/9NopjEiR3EwfnDWcfqDskaS/oyVluVxV+U73YHLFzep4j7ukvxFFiR72Iwp9pFD97HPlr5N3P6GhNvCxKDkfI85PRWtp4+JO9Wskn7p88ZU/u5LkgpqA9+1usOnT+kqYh/4Qv1HVjDRIGjMmmk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__migrate_device_pages() reads the folio mapping before calling
folio_free_swap(). When folio_free_swap() succeeds, the folio is removed
from the swap cache, but the saved mapping still points to swap_space.

Passing the stale mapping to folio_migrate_mapping() makes it use the
mapped-folio path for a folio that is no longer in swapcache. It can
then operate on swap_space.i_pages with invalid reference accounting,
eventually triggering a folio reference count BUG.

After a successful split, nr still contains the number of pages in the
original large folio, although each resulting page is now a separate
order-0 folio. Reset nr to 1 so each split folio is processed separately,
including its own swapcache removal and mapping lookup.

Refresh the saved mapping after folio_free_swap() so the current folio
state is used during migration.

v2:
- Refresh the mapping using folio_mapping(), as suggested by Zi Yan.

v3:
- Reset nr to 1 after a successful split so each resulting folio is
  processed independently, as suggested by Zi Yan.

v4:
- Re-read each source folio's mapping immediately before
  folio_migrate_mapping(), as suggested by Balbir Singh.
- Add a warning to validate the post-split order-0 invariant,
  as suggested by Balbir Singh.

Fixes: df263d9a7dff ("mm/migrate_device: try to handle swapcache pages")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Arvind Yadav <arvind.yadav@intel.com>
---
 mm/migrate_device.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 554754eb26ff..0e6f00190fd8 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1182,6 +1182,13 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 							 MIGRATE_PFN_COMPOUND);
 					goto next;
 				}
+
+				/*
+				 * reset nr so that only first after-split folio
+				 * is processed below
+				 */
+				VM_WARN_ON_ONCE(folio_test_large(folio));
+				nr = 1;
 			} else if ((src_pfns[i] & MIGRATE_PFN_MIGRATE) &&
 				(dst_pfns[i] & MIGRATE_PFN_COMPOUND) &&
 				!(src_pfns[i] & MIGRATE_PFN_COMPOUND)) {
@@ -1221,6 +1228,12 @@ static void __migrate_device_pages(unsigned long *src_pfns,
 			folio = page_folio(migrate_pfn_to_page(src_pfns[i+j]));
 			newfolio = page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
 
+			/*
+			 * folio_free_swap() removed the folio from the swap
+			 * cache. Refresh the saved mapping before migration.
+			 */
+			mapping = folio_mapping(folio);
+
 			r = folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
 			if (r)
 				src_pfns[i+j] &= ~MIGRATE_PFN_MIGRATE;
-- 
2.43.0



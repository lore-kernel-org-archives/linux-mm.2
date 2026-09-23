Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D231BC98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 05:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0E66B008A; Wed, 23 Sep 2026 01:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61C86B008C; Wed, 23 Sep 2026 01:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77DB6B0092; Wed, 23 Sep 2026 01:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 833406B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:53:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0DCBD406B3
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:53:00 +0000 (UTC)
X-FDA: 85243958520.07.E13B551
Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id CDA27160006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:52:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SbXL1Nkk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.133 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790142778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cDpl+8fAMWXWk3vxBqwwjNppy0bAFDqdJm2qys9c6UY=;
	b=iZhSpoZFbYjPPqHCWsYFsVLBqLH6HuLHaDeJWKhMKiBBz5yJVKP3i0JCP7YmVQiPHordxl
	y443NoL//C9dA+LdLdK9M/WGQ7v+QVGwEumyMKrqbU9G71F7PeCl0EX2wkU+EEpcjGxRgT
	rubG89oMkI6nRkRWxpJ5SZJFMN/GIdY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SbXL1Nkk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.133 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790142778;
	b=B9K4YfQ+LN9bbaxFUEBmg9Ma7MwSaiiRpHshIdMNi9JpRejvxp+WdORerFIreb0QnZeBcQ
	JYBiR+hS0iRxXPs8abG+aRgPOSk/XuuJtV/2O+J0LY3hG5e9fVz0ofh3utSrLivuzO/DyU
	VxFBtwY6kODoxGPou0cvOvHUbULyCVI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GtzyIimaRhdHKGvlttK2axmNG4AJfexvcRRfGpY2ECk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790142776; v=1; x=1790747576;
 b=SbXL1NkkSWY+U7gyzXlZ6xqymEghVCzzdVcfFuqpBUOti+BsDZ/ATK6NoQOWS8zBFSvLJrIe
 fm70YV79Pq0EplWJhQaGDyJ33PvOMlpnpznYrn7R5tjyQSgjFeUjIHtaxbJG/8UvbJmrVMyfNHE
 +j4uSh7oLVlKPsUEVB+P0ekQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b3c3f588ab93e6be;
	Wed, 23 Sep 2026 05:52:55 +0000
X-Mizu-Trace-ID: b3c3f588ab93e6be
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH] nvdimm/pmem: remove test_and_clear_pmem_poison()
Date: Wed, 23 Sep 2026 13:52:26 +0800
Message-ID: <20260923055226.56129-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: moy7o3pqjowygofkoda7nkadr9pcra3z
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDA27160006
X-HE-Tag: 1790142777-225835
X-HE-Meta: U2FsdGVkX19r6SyaTuB8bFR61fh//cZ4WBaBmXIAjvs4ab6H+n+oJMPI1FvBHlBNI8o9mFYLiLoigkq46LoLXbWUEljIxQbDOqNAelmiL/l8IwP0ZXUpJ2TFPwl0ZqAtH8X672fMISCho13zumlQN961MKw3m6w3pE1Y8BX91K4VAM9hi+m/aNhdJHj/dOOach+x97d9ZYwwmR3L8E6kyA46NUGQfJZu2r6neSTcUNM6RIj/ELfXp/NVbh89VdI9ME3xgFoiTLwfG3TlL+/jntAonxwn6uCKvaGsktE+OmLPJM2olIMSZiA2gy11SpU3D6VBTjnmEpBTateDc3RgDoppuNciYeSfETrLLx04YGK2Paz4Qs55f0DylNgC6T+bG9P/0JYTHBOcsALRoCD6LqOq9dnJ2cKLopr0ByHzeFYqy+7+XJg8H0fC3xNBZ4HehH9Le3ZvZLwCiC5+zuicZsCJxyES5WvQXcczuDWk4n7PbSrXZha26Yt3ZL9kCr5QuPBkrFRrj+S73wqMBlWzdSE98WUbdBQHh8KZhphCBrkh05r8SmN6dPJS+zhakpmQxVJz/u8nQMnWODyEcPGcQ1SEHH1PuLIu7uwJlISM9FnHQ5I2Ph2R1Xd9NfHW358YT9DfLoC1uFE6Qf/QrN6EIMsac9bUHGoa7K56VgBpFUlePLTmJY3NNJ1geq9EqlLNk1zISNE8PLGj+aC1A42MB+oBvXSI1ITE0EUP2erHzqDtSZKsBOxsOSvqv0Pz8uGIQ1fiiI9xZ+u6owwmpxgVtPHdsHKtE9Wav3ZxucBUZjqXwR3XoN/nMNs466aQRtSYrfFTTW0uldawT5It4ozdZyGp5e4Cxj9xwktTwPtkXf+bay6svTDItjqYDW2glX+4REdjLPFAE5r4KiqkQfCnlOtsVZT0PWe//NCfDuBext6/Ld/ccuCGaZak8fKUqe1BEqp+ERupavYhmN3FGXP
 mQXM8WI9
 OzNGv0rJYuRif10+GbEst/RbqWsCZ1B5OphQynxTd+cf8kW4N9hLsha7HYIlAyaDbTUPtNPe5BNZ7vP081m1TBEtu/KquqPRcwpZwcRLCp4VRDKv9Yzs2kJxwjLUzqIiRvnnlykvHgNPSmLLzVLE6rOq9ZRVwHitbHg77333a+NQNovUKbOhsbdpbyyf8wf56GBXuSptyION9rC3bW3J6cHv/WjsTxF1iAaPRRRDaEUbigwHM5ZUY0xZyyE6pXGfELzgdsWaF6A3VrJsbTMwnansKRWadlz/OXXfbg9f+TaeAPIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

The pmem driver provides test_and_clear_pmem_poison() only to handle
the CONFIG_MEMORY_FAILURE dependency of TestClearPageHWPoison().
The wrapper has no other pmem-specific behavior.

Define the HWPoison test-and-change helpers to return false when
CONFIG_MEMORY_FAILURE is disabled.  This allows pmem to call
TestClearPageHWPoison() directly in all configurations.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
---
Changes in v2 (David Hildenbrand, Oscar Salvador):
- squash patch#1 into patch#2.

Link to v1:
https://lore.kernel.org/all/20260903053535.17611-1-kaitao.cheng@linux.dev/
---
 drivers/nvdimm/pmem.c      |  2 +-
 drivers/nvdimm/pmem.h      | 12 ------------
 include/linux/page-flags.h |  1 +
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 30a51c365ce8..5fb86595e8bd 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
 		 * here since we're in the driver I/O path and
 		 * outstanding I/O requests pin the dev_pagemap.
 		 */
-		if (test_and_clear_pmem_poison(page))
+		if (TestClearPageHWPoison(page))
 			clear_mce_nospec(pfn);
 	}
 }
diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
index a48509f90196..76870505dd79 100644
--- a/drivers/nvdimm/pmem.h
+++ b/drivers/nvdimm/pmem.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __NVDIMM_PMEM_H__
 #define __NVDIMM_PMEM_H__
-#include <linux/page-flags.h>
 #include <linux/badblocks.h>
 #include <linux/memremap.h>
 #include <linux/types.h>
@@ -31,15 +30,4 @@ long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long nr_pages, enum dax_access_mode mode, void **kaddr,
 		unsigned long *pfn);
 
-#ifdef CONFIG_MEMORY_FAILURE
-static inline bool test_and_clear_pmem_poison(struct page *page)
-{
-	return TestClearPageHWPoison(page);
-}
-#else
-static inline bool test_and_clear_pmem_poison(struct page *page)
-{
-	return false;
-}
-#endif
 #endif /* __NVDIMM_PMEM_H__ */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index ae2ebaed6d4d..3dc79c0c5adf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -655,6 +655,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison, hwpoison)
+TESTSCFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
-- 
2.54.0 (Apple Git-157)



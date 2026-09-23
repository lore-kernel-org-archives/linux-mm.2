Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D72C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 05:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 968C66B008C; Wed, 23 Sep 2026 01:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93FAB6B0092; Wed, 23 Sep 2026 01:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87D196B0093; Wed, 23 Sep 2026 01:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 620B36B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:53:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E39781406ED
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:53:33 +0000 (UTC)
X-FDA: 85243959906.14.474E10E
Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	by imf02.hostedemail.com (Postfix) with ESMTP id D586980008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:53:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xcVDaIA6;
	spf=pass (imf02.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790142812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cDpl+8fAMWXWk3vxBqwwjNppy0bAFDqdJm2qys9c6UY=;
	b=UmdUrECZn0XZRH3LTF0dHO3nrxqYT6mxSRfICwvpKo5T5Q43gAjcdQg1TA0zgq7IOD9kht
	2QHyAYLiTq2Nnn6haJhw07h0tB+PsMQY7gxbcckU4hMUpLnz813OADvwjoRhv9+jcRe6dv
	2oMAg6IxxIYC7pSxnMfi8L494EGF86o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790142812;
	b=sm8ZKwl/EY+1PMpNcV0Oj923WDwRTbdQbygPX/fFO1U3USCnSz1JmHB44/oKtwjiHKACLJ
	CJwp+FAptAz1mvGxh4l204I4A9LGksAQaX1Sgk/R2viUw9DwytkA51x+0G5fTSRZ7YkzOc
	yqLiRN/05zbEdbxgjj8jxzYFaoV6TE0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xcVDaIA6;
	spf=pass (imf02.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GtzyIimaRhdHKGvlttK2axmNG4AJfexvcRRfGpY2ECk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790142810; v=1; x=1790747610;
 b=xcVDaIA6AxJGFyl59gR9e+k4n6ll3IV+Ux5WtvjeEy7Uqvr9qSjbHiEbS4u701fHPsgb4MF3
 3WqOxoxDpUxacdcTKFiA3B63AJSLpbG3pM5hg1XYuBZPCNBId9XqzuCuQ9/OGIUbZEOkcqWxbRE
 3rWw06t2Zb0ebyMbx6R0GkPU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4e0d178c503526e4;
	Wed, 23 Sep 2026 05:53:30 +0000
X-Mizu-Trace-ID: 4e0d178c503526e4
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
Subject: [PATCH v2] nvdimm/pmem: remove test_and_clear_pmem_poison()
Date: Wed, 23 Sep 2026 13:53:18 +0800
Message-ID: <20260923055318.57485-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D586980008
X-Stat-Signature: 4wsqbsbn35wpuu7nioqdtd1fcu9drm68
X-Rspam-User: 
X-HE-Tag: 1790142811-606771
X-HE-Meta: U2FsdGVkX19agD1i0cAHa7jPg1xaTmVVh5T7fleQkO7zEbZy9/AUOkYmd78vWrt+aQ79VrOl31ilrFI5UnUKiKcmn4YwnHf3HoXkgKcsQHJlL6nNNdRYKYif94pq+ae6hfOv3Cc1XSw2Gdp2RzHxs2q6JZfCH6p9cnJisxyh9deFaXcWyLt3wRowF55hs2efceonGAS5jiclViZKU+QCcqQZbaJr+etp+gO+WK63FTEI3FGdlNasJKGofzMeEVnkt+cQrQNwVXhn2PfViyxx+qGkQebbK6eLG5h579qmEyNu8zigS9VKxzM7DtYZ+DsKSchtgeVZ5MVqAYajIRhSsZgIcejkyRkdCMUJyPvap0us2s0imT5F9aC2lApnef+w1ey0aBBUMHO7cPZRiVHgOBixBbiLjg+twcBsLWKJrnBkyPa0eOuT/V7qjXiOH60WRluUbErOZJF3Uz5CI57yFkbROxrtcjxVy7+/6pMG6UxIqqI/jXogNg79t/ZP+44foRx/yQ2ZmCXGm1lreYOTqXNN3ywRi0k1KyhUcSfGe9ds1M4vO0WvxY0O820aNfVB14MwbeERMkrwlk7PqxFXBZR501ieVCmLE+ukwgyXaw+tAAubl8WILCmVuanSM5BmgodOaKy/1EZDKMkj0hI/lhmjdVfyd4FWP+7oQNk3+5cs7qMuRiUDEafbAgV1bs4ZvBizA66/TzbGStnKiuVjFvc8oPpne7G1heUMctfLvv/OGYlvT+kvfcbg9Ck8UhRaJLxVpXzTnwM8kToPM5WCt13GAQWLClIp4hu9tWGrkkbNtaBPH5ebvfNfoBgjHgB0pbqoD+BMpL5KrxgRwmuC/A7zDvjekS3yrz5+8uToOlP9K8C70t0KI0dYabn5ObM1e0gYeUpfOAmytkymmwOlt5xkkwcnUZuXjqPc/qpQ2IhktWUzTnkl9WZTzFHRHimpxQWDR8Y69FfrVp9vz0C
 MPw8t2yr
 av4Z6CK8bWRlprBTEibW3FX9+2Fohy09gRY2U9y67SxKxlTNMNA9wzd6aBKDtW3r2aphS0k0SlWepOxhnqbpacyFv+NTmnUCpE5xqAgquVUKL+neUXKHMUJ92VCBiTxYJuy842SrSJoxk1SipHkN7FpyGZhva1VyopPHFQ1FIAb20xEeky86eXCUXFhQ6qylgMvFz6htvql9zuJsEBFut0ZFRa5UXiUZNDr6o4HKLDUCeOElFVWphvyfyYphas38h6C+ow9qsZfoKrDR1MfFdJlTjatdOxTS3uQDwuEfSxUCzGpI=
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



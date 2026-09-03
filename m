Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11D2C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 05:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB326B00C7; Thu,  3 Sep 2026 01:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BC36B00C8; Thu,  3 Sep 2026 01:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91ED6B00C9; Thu,  3 Sep 2026 01:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8A5A6B00C7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:36:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AFBD7A442E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:36:15 +0000 (UTC)
X-FDA: 85171340310.19.0961A48
Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf05.hostedemail.com (Postfix) with ESMTP id B2106100005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 05:36:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I0HKlWnz;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788413774;
	b=CEPbJm99rGjnlrqGCswYys5asRzZgNfwnZLdBd+tPzIgBfBe4GkDNDDw2KAqFiXedRfMH9
	gm/mV99hC/YAMIYvZex1zjSLcOLRdxSIWpIe5VItWnw+GL844TOw6T9PDIwzrbIEZqUMdV
	hUrFtFD9NrBHRZiFYVpiFnE2xKayllw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I0HKlWnz;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788413774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1OnYacUcHDJFiWDX/P58+q4xMKESLOGZmWe6py83leQ=;
	b=ufmAT9FF9OGm+gB7gv8f1X4J56rXKSzwsbb/jv5O3sFT1hblr9ZI+eygyNgMPYPi4EPSs+
	GiYBJioAeFHiJdofNwwlWJNytrHRMW/D2YKXvP1gwGE3iH5qKaW21ac4sCh9lN4iGxJf89
	voUR5BcPl859DKQqc9r9aPDxrTe9Mpk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XsehUQBu1zymeRNt1s6Ov24fTjL0E26lmzfvGaBn2R0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788413770; v=1; x=1789018570;
 b=I0HKlWnzNX441OhTwD8TwdHY8Hzs5uinU2xuBh2aBiefDqtxQjjTcoixnKyinf4VC6IutfzC
 Z2g/Id1k7kIz2/jlsGbKn6MjEmOgj0N69U1BcgyCZ01gaqd1iiyJiPpp9TJZmHp0jQKgcRvFumu
 0qbZKUcTEYKi8UEU47tZ1oQU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 78007f4d4477b093;
	Thu, 03 Sep 2026 05:36:10 +0000
X-Mizu-Trace-ID: 78007f4d4477b093
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
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 2/2] nvdimm/pmem: Remove test_and_clear_pmem_poison()
Date: Thu,  3 Sep 2026 13:35:35 +0800
Message-ID: <20260903053535.17611-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260903053535.17611-1-kaitao.cheng@linux.dev>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2106100005
X-Stat-Signature: oezfgdpwr8jf9964eogfq7m35yg38dj9
X-HE-Tag: 1788413773-229125
X-HE-Meta: U2FsdGVkX1/GhzsjjNHu9c1pwh19cjPNmjTTOsPQO2tg9IjZpRO4ij4dZp/pJliVLOjlvbGSkU2getX68g0IAVkOj0B8p60Dxb2R1RKw2V+itk1dQmPy320IPZxphjytdK7IVtSzR1igU5AG6GZ3N2nIRfGqjW1UL82Xm1axnnDHUDz5h4EKBgLNu36eRnt+qGfqJC4Focr0mQylhgbg6MdRXxPQFIs5FHYr304BPmyTF7nUY3M2eJZ0rD0Z/Cqzc0Cs+CDjuYmVA1jVvYW4eRsSZ73/+shmOzCdcKTWRJj/Li86BmkfhKVE5ScFBLnpaDJJMw/TwpPKR1bszjJXVAD1MzcsUayUrnqJQjfIy0St0CelzEKh3p4vqgRD8PkzXu4wBlh2+KPs+PJpvZmcvWj3BataiebFM5oAaJ61TKV3ORl03guYHPA/CfngZuWz7EXBgSwdjLaNtA+ug/+32nZLqVuG5dy/+m9Qjr35YjmB6OR4iepU+68mlGA67hijenUDXf552aGaYeCfXJxgmMDmGK4e0K+0bIYOQDuh6iE+rh5azaoZk2rNoHpHsv60ks9e5mVrPSrH36q2WdXoBeUcQ3e1FP8E1KtC+RoYyDixB+UuYCw3jrzuQ3yO9pIDCiYFAXesf+dY+94UdJDM2zIH97kg/LHJBoXfnXx2a4Tzi22iFxXJJWqQABe0afYkMZB0rjiK0x8QOJ3WWI/qj5ZTMHCWIcgaoQ9sClDa20le6+Xg8Z5aaOnttJp2TiaXF3wI/cVRnq2lkGx3/A8fe1s4ctDPZByGX8g4+zoV9sB+dfrjfm8POztq9JdAWEzDRdNXkis0h314MjiZSQh4fHzRAxVD6fAXUe7paD3O18Xc9+UGghB/rKYSsDnG/UQ2CZLGIuTlhUQTbOh2uu7ufsxSrXCacJhDQstAATLbPAnCD0ZOD8uUxB40qrT9TDeDUWNWUY8+oCmwqjwnkgg
 cQ9A/lRZ
 inKRHZYuE6yZk3bDZHfodqiPxk/fqyMRqbWN4WG6gRN3Dd1vCTIVf9CPw7/Xmiq1kkbZLgc/IuKGOa2I7HUT92hWpdX1yy3CdlGdQ4A8jfabWUBRkzbCpfpwferc6DjKETsOVBAoS+p1Fuwdhfw2sffDSCb9ucJzTiWr1CGkkDlvLWHLrJmtX4vpRvREc/Wn85eWWShV7FFB+u4f1qrv/G/lspSSWcqXSaL3u5yWtrQhfh+5v/lOE9NZMareYbTnr5Z7PnRymljHTpyOiQK+Db0n2SQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

TestClearPageHWPoison() is now defined regardless of whether
CONFIG_MEMORY_FAILURE is enabled, returning false when memory failure
handling is unavailable.

The test_and_clear_pmem_poison() wrapper duplicates this configuration
handling and has no other pmem-specific behavior.

Call TestClearPageHWPoison() directly and remove the redundant wrapper.
This also removes the need to include page-flags.h from pmem.h.

No functional change is intended.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 drivers/nvdimm/pmem.c |  2 +-
 drivers/nvdimm/pmem.h | 12 ------------
 2 files changed, 1 insertion(+), 13 deletions(-)

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
-- 
2.50.1 (Apple Git-155)



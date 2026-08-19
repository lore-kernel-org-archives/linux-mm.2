Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EACC5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 08:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318F06B0093; Wed, 19 Aug 2026 04:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0896B0095; Wed, 19 Aug 2026 04:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206126B0098; Wed, 19 Aug 2026 04:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F12796B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:36:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 939F180482
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:36:27 +0000 (UTC)
X-FDA: 85117362414.17.DCE2826
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4717A4000A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:36:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uscxz3lh;
	spf=pass (imf01.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787128585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DXyU34t4JY/bH2qRKqQJeUpV6LNj1+g92OC+ZRS8aps=;
	b=CujQDFrgSFOL5I+emt97mFqYxjK6OwAmyfK0/HY6O1e7h6MvVPhoJfp6FUzv7wIUDX6ZEM
	5cM0664xmvljnYUOstPFE8e6sX02Lv6K7/hquOOV4/MPBjX9X+jWoBbMiaGh01I3BJccFe
	wCtmfHtw7xZWqnhEuPVU1tOARepSaBs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uscxz3lh;
	spf=pass (imf01.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787128585;
	b=TQ+6j4RTFhgygfYbSlda29FrXx8aIV3XtGT+9yy+pMBSzhQX6bhMN1dbQHNbufE0dt3myM
	aHDeSDr0/qlfqmufyL+Ozk6738yK2M8E9Mx0nlqyYq9iclYwr8zyqJe+HSg6q0Z3Jnj6Dv
	l6rn5lE32pL+0ubuusZ2sFRedHEyCK0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=DXyU34t4JY/bH2qRKqQJeUpV6LNj1+g92OC+ZRS8aps=;
	b=uscxz3lhCsitq5NLNYt/HklzZh3fnAAYHe+/hjSFJ4wMTmUoOiY4VaTb6dyYdVdohcsFKn4kA
	iKk4xWQah4ECSWRugdRyfVwkO5porUSmNFQxxE5mrC4/UWFSs1o0xypLhtTI4cL0+PLqIxryHqK
	R38XeqXk8HZvmHW8XhI/sH0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hQ04z1ksgzmVXs;
	Wed, 19 Aug 2026 16:25:39 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 9CD7B40586;
	Wed, 19 Aug 2026 16:36:20 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 19 Aug
 2026 16:36:19 +0800
From: Qi Xi <xiqi2@huawei.com>
To: <akpm@linux-foundation.org>, <vbabka@kernel.org>
CC: <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<jan.kiszka@siemens.com>, <kbingham@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <linux-hyperv@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH v2] mm: drop stale MAX_ORDER references
Date: Wed, 19 Aug 2026 16:20:52 +0800
Message-ID: <20260819082052.3338603-1-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Stat-Signature: etw74ksjdkexqjkbeigedyfu5ouigsyq
X-Rspamd-Queue-Id: 4717A4000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787128584-270685
X-HE-Meta: U2FsdGVkX1+UWyurUZm+HRZ4Q3tasD5eGY7cMVP5dgwIcf5CiplFEa7ZkPgXq6HRqANOpq1U6IqHCrEwjcgsp0pWQ0yefBvtVvCzk5X8x5Fwb4C45qV7ZC0cQdncoK5KxJbJLEUgfNYSA42wXDEU2jGhyGvkyx+TTHveCnhdR4//m4aOrvgd+5V/zztP24sNHegvkY3RrOPd4p1/YZe4ec+h3ZIDwJL0hZiMwAx7tHlN2G/2goQ7ZizjUGk1DRS+xzXoWmIrCShpfMOWZQYLyXYu8dbb/fdXsyPUbpgpWO1m02VAu6xPxhbrzmkohABrbkkzllFiIEsMtfs679dat66kPUgBTUrN+5K5l81nF2tWbh/X3S0GkS7c1WpDmI7zqX3Q2hP7DSTjXenHard+oYDtROkMta3YI+m8foc2JOF1T7Xl3SKoBv4fmwbaiuKnP0KgJSW4J+6oBFoyZH005eW9fxXW/asXHqkXhS/QkkHlkAX9QnlJlw/IKAw4Q0HUgHRVad8RJ9W4q7dd5IQnykQNpQDSUtmBxK2MTeuBuyM3czdgLIfqX9on7xsnGaYbt9GtGWcAdwB56I9EiZ+3wruQZB9duQzU5Q/x/GOETV/lt3db99ChJBRJu+3hmZ0DD2MZZQdpjeYLWi0T4EVrGIpkgEVTtTl92Mt1Gpo9Exl+ACPzrll/JL5frVCmkxIDWJcXeKo+9HtAMYSRBrmxBQu/us6OxyVhfjw+vvEt3fIcoJyHjpb+x68UfAaLZ3yFKnIAIgEDj/QiE96y19i/Y2ZL+laiJ6W00S4zK6cX9GUwuXcUQibICvTMtybmJQ85WzQ5bXMA/M8Y5KIOmHDrrrDA60qSdX76nQ0mDxAVvxSqRGZJwBz09lX7s2kvhLda1cv47UnBAoO8n/Ek6AilYque8AgY15eotDVrUCVeI7OxprxpUGss2lJD0QYIv1kiyW7mTGBZEy5Atq8u1ON
 R9vxYu8p
 nB0gTbvDmT3HHrAo8W4PLGQkG+PoSFJXjOBe89NxQFfIOQp/M1pX42iorjtMUjsMpwaH366POQEM7YgjPuaRtZ6WByyyM5nbNGgKPWjlZOAi6mklUz+hwIFgmPxDPqPir9PtvqPEAW2QGkCOSce1LLYnmg8KdHlBT0XbilS1X/8KPmHxRKc0rtNRh1iLtwHvn3BMWvlXxNS0Xi3npG2Vmiv1zWSLHIeQsU2XHsqyBN4rMo22Xh2ULnEGy2lCR03nrIS58KmFxzy9u+RNRHifiDZ0myKU+LPsKzhRGRkFpfy5yjUYDzqCxqfUKYroUMC1ylHuxvTJ1OA2OJ7udnsRX0ZiLeFx+8QPdCVMU5SSbHaV62q8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The treewide rename in commit 5e0a760b4441 ("mm, treewide: rename
MAX_ORDER to MAX_PAGE_ORDER") left a few spots still using the old
name:

  - two comments in include/net/mana/mana.h and mm/page_alloc.c;
  - the gdb helper scripts/gdb/linux/mm.py, where self.MAX_ORDER is
    a local mirror of the kernel's MAX_ORDER define.

Rename the leftover instances to MAX_PAGE_ORDER so the tree is
consistent.

No functional changes.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
Changes in v2:
  - Correct the mana.h comment formula to 2^MAX_PAGE_ORDER.

 include/net/mana/mana.h | 4 ++--
 mm/page_alloc.c         | 2 +-
 scripts/gdb/linux/mm.py | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 04acb6791dbd..bc331bf9b205 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -40,8 +40,8 @@ enum TRI_STATE {
 #define COMP_ENTRY_SIZE 64
 
 /* This Max value for RX buffers is derived from __alloc_page()'s max page
- * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
- * size beyond this value gets rejected by __alloc_page() call.
+ * allocation calculation. It allows maximum 2^MAX_PAGE_ORDER pages. RX
+ * buffer size beyond this value gets rejected by __alloc_page() call.
  */
 #define MAX_RX_BUFFERS_PER_QUEUE 8192
 #define DEF_RX_BUFFERS_PER_QUEUE 1024
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ee902a468c2f..42b5b41432c5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7803,7 +7803,7 @@ static bool cond_accept_memory(struct zone *zone, unsigned int order,
 	/*
 	 * Watermarks have not been initialized yet.
 	 *
-	 * Accepting one MAX_ORDER page to ensure progress.
+	 * Accepting one MAX_PAGE_ORDER page to ensure progress.
 	 */
 	if (!wmark)
 		return try_to_accept_memory_one(zone);
diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index dffadccbb01d..28d33624c38b 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -56,7 +56,7 @@ class x86_page_ops():
 
         self.MAX_PHYSMEM_BITS = 46
         self.SECTION_SIZE_BITS = 27
-        self.MAX_ORDER = 10
+        self.MAX_PAGE_ORDER = 10
 
         self.SECTIONS_SHIFT = self.MAX_PHYSMEM_BITS - self.SECTION_SIZE_BITS
         self.NR_MEM_SECTIONS = 1 << self.SECTIONS_SHIFT
@@ -233,11 +233,11 @@ class aarch64_page_ops():
         self.SECTIONS_SHIFT = self.MAX_PHYSMEM_BITS - self.SECTION_SIZE_BITS
 
         if str(constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER).isdigit():
-            self.MAX_ORDER = constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER
+            self.MAX_PAGE_ORDER = constants.LX_CONFIG_ARCH_FORCE_MAX_ORDER
         else:
-            self.MAX_ORDER = 10
+            self.MAX_PAGE_ORDER = 10
 
-        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_ORDER)
+        self.MAX_ORDER_NR_PAGES = 1 << (self.MAX_PAGE_ORDER)
         self.PFN_SECTION_SHIFT = self.SECTION_SIZE_BITS - self.PAGE_SHIFT
         self.NR_MEM_SECTIONS = 1 << self.SECTIONS_SHIFT
         self.PAGES_PER_SECTION = 1 << self.PFN_SECTION_SHIFT
-- 
2.33.0



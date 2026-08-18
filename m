Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C73C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 12:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53AA6B07C7; Tue, 18 Aug 2026 08:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05026B07C9; Tue, 18 Aug 2026 08:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DE36B07CA; Tue, 18 Aug 2026 08:39:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9093C6B07C7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:39:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13F9080C2F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:39:46 +0000 (UTC)
X-FDA: 85114346772.01.16A419F
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf15.hostedemail.com (Postfix) with ESMTP id 61EC2A0013
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:39:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cJGXOOz7;
	spf=pass (imf15.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787056784;
	b=BlfAe49nbgXdzrnJlabWXP985SHlAcnFM/5dUIzBjGSUvmODAgbdOW1A1HFmLgknLJMXe0
	B+6PCBmy+pQkYGf33cYiDB30UNJJMCd/n60jLe8EYGIOAXIJa9uzrzAkAIRLXdg9YmKJjV
	tqAgcM0TymZYTFTMTptDXVbS/81xuJU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cJGXOOz7;
	spf=pass (imf15.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787056784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=61EB7xd78VmsW3Vtne3/GVzkEJHCsedf1b4wP+cKgAc=;
	b=tMX3a9jds/11pVBU2PWUcuD9z3kxboaRH9bKmouqS2Ie1XStBqGVKovMxiTYAqQZDPPTFq
	e+qsIJgeNL0ZoFLzf3L/kw9Xr9HLup341khkKntmy5Gc+wHSm75WhQCgcmlFJwFvhM3h/X
	xLkDusY06CjBjaqWFEX/J+LBc+Cpli4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=61EB7xd78VmsW3Vtne3/GVzkEJHCsedf1b4wP+cKgAc=;
	b=cJGXOOz7g4QJkUJsl3S6q/OHVIO2OpSQ12Gwnvx/LDfB7j2e9EmtE+wl+FvTTaNmlXxPZBSoM
	KNe7EYBgpJaWfulSYLlXHEJmvcN4dYRcyiGIBUJ8QEQpm3tmfYJh6RI69VsVdB7Pf0ztoogoZH+
	DH6PmEGQgvfg2NxnkDJIw3E=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hPTX46pPgz1prKd;
	Tue, 18 Aug 2026 20:28:52 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id BC10A4058C;
	Tue, 18 Aug 2026 20:39:35 +0800 (CST)
Received: from huawei.com (10.44.142.85) by kwepemo200010.china.huawei.com
 (7.202.195.178) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 18 Aug
 2026 20:39:34 +0800
From: Qi Xi <xiqi2@huawei.com>
To: <akpm@linux-foundation.org>, <vbabka@kernel.org>
CC: <longli@microsoft.com>, <kotaranov@microsoft.com>,
	<jan.kiszka@siemens.com>, <kbingham@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <brendan.jackman@linux.dev>, <hannes@cmpxchg.org>,
	<ziy@nvidia.com>, <linux-hyperv@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <xiqi2@huawei.com>
Subject: [PATCH] mm: drop stale MAX_ORDER references
Date: Tue, 18 Aug 2026 20:24:08 +0800
Message-ID: <20260818122408.4182417-1-xiqi2@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.44.142.85]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61EC2A0013
X-Stat-Signature: u7ercixjaur8kjgmj1h68gomhqyjd17x
X-HE-Tag: 1787056781-139323
X-HE-Meta: U2FsdGVkX1+OLYhdQMzoB7a5qAtfJ8sPancDWglsfMWhWjQ8k3Hl/WvmHoP214JAFH2fXxvYVv9hSTlYq3kExHOzWIk7AnqIZ1wjGnq310Km37AlkjPA2CQkXtHozZ4ERc67aQKBdouukIpJO2cyO3NjxI/GIIocAIrk1qus7hIXGrRpwK33FnuHdMOkfYY0NMUOn42jcz9MdOUOfiZY97l3bQYcBI3LF8OiMufhhkYqplkPuzoQBKmryXIdpMoKFXfAsqP9SJBOnZWZKDidyjD8XlQqyEVJsxc+XX+ksm+4aGOm8rT2lYAq3Yti9zwciUP2jklu0/0TqWSl9Pn0sjUZhPwfJoisyu1pG2yMW0EG3bc5vtlwwHWR1GHcjqynonM5YH8Fb9+fo1qJWqRIMXApAPRSuhAUxUetQEg5hwHQfevgUiDFLk4HTyamaqHKBmHAfFHlQFGlVxVOesYLa0ixAlfIOozFP5rRMPqsYGmXhvJHtzxc2BjCxgBh3Xp8PdZSHVbB7iXuvEGXgrC0ydGzb9pM+NO5sfJvg9f5xLANTDwe2hDu4sGTEyT4A6s7NOrWshyy23fRMFxqkuZ0gCpZTChVVi5f8QDN1XaT/iCRaUVC29HX9Jkh4aA5+xNreWd6Yv8hocQrRfVsNswo9TQFOLToZzDS/cSEZ6Ie1kM1GStJZFhe836QciOFHjXmWV71PB62J1ac/s9Zp7sVRctCTs/x02x0oBXMRqBCkagDNOIDKeSDDwdN7KJosvW2A56+tN/hT5H9TseY4G0rl4abkkAfMAO6yFhGrlA8LT/PXz4MpDB0/IPFeYuw+u+FCcP/wrRoOlN2jQrcChdBhftmTZ0Van6hx+HtHknRPXTOiVsQ0P9Q0XLfFMW9pTb1wkfAyU1CJNIboAVZ5LkMATIL2JjoimGbo+AHWEadiW5+aE+ZnjmDSOvqZ5+V6WXVdbRQr1L1V788RD7GaOu
 vL4m8yKH
 hsISKZitUbNE4RS6yPEcZrAdFuSCNS1rlyB4XsZRriq0Ncprq1B0cy9wj2rTsooKYFuhZ48XAj4+C31hkVoSTTs8NLeCHPQWbu6Vjka6n86NB1Gf6LU9owH4lT02z6qzYDnBTQEE791dPnNZi1q4rZCz97Q7tHwHg5e4n49xd9xzDIBSjLLHIftb3pb4C4PYsLYJf/MaTyeS0vpZh6JjGIwwFWeJoRyNtjybTTN7I6xVZ2FqK5C+lT9uxOKU4zXqVxjnubY7BkG3gA0k/fJypV2YEfYSoRyupC+76a1QbjHLwLjltBAJWeu/9mktl7se2+2/wncS0mZfhx6p5+ss1tHnZYA==
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

Signed-off-by: Qi Xi <xiqi2@huawei.com>
---
 include/net/mana/mana.h | 4 ++--
 mm/page_alloc.c         | 2 +-
 scripts/gdb/linux/mm.py | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 04acb6791dbd..1d5bed71d6a7 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -40,8 +40,8 @@ enum TRI_STATE {
 #define COMP_ENTRY_SIZE 64
 
 /* This Max value for RX buffers is derived from __alloc_page()'s max page
- * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
- * size beyond this value gets rejected by __alloc_page() call.
+ * allocation calculation. It allows maximum 2^(MAX_PAGE_ORDER -1) pages. RX
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



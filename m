Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92543FD004A
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076376B0089; Sat, 28 Feb 2026 20:47:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21A36B008A; Sat, 28 Feb 2026 20:47:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E566B008C; Sat, 28 Feb 2026 20:47:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D65F96B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:47:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E6D11397E9
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:47:37 +0000 (UTC)
X-FDA: 84495807354.03.24738F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A494340004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:47:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AojH4Y7T;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A5M197EAdkkYCAGNCwKBgSXlRs3oE+n6Zl2QqF4BQ3g=;
	b=Ff+VGbe8zLEgaGe18RKUSJVwnRpvQpy+ZKYfB2yRo4mX6e6JTO659m7nNlbcw+d02ywDnO
	u4IWw7SXsu0s+B11MWPxMlPiGb7GZbEomsc7yTVlUoPC7xF9Cc6wLrPHReC6/uiChyozEg
	f5CRxZ7Vku07VjdWQ8yVVM3c0qtU1gg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AojH4Y7T;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329655; a=rsa-sha256;
	cv=none;
	b=iDSmaXSb9YPBfAGqNoNAAC7L8h8BuKShcI/8nAeUiIqOo9OfsNtp+TGNV8F9UTf9MqvRyu
	duTLzkDKfbmkMj+WlWHQweXfrwEY35kOziZVITH7t6owveDJ018RA4IiFSmaaCRpTM/BFh
	TVl0NvF+jcdfBwPdKRdg/Njfr+w1JKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FB4143DF5;
	Sun,  1 Mar 2026 01:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD95BC19421;
	Sun,  1 Mar 2026 01:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329654;
	bh=8yvGc6/u3APT9EaaIgAuvoGpfEqpmnS6AZAeWpyz+dA=;
	h=From:To:Cc:Subject:Date:From;
	b=AojH4Y7TniYV6cRSFQqnAlN6LL6YT4v6wqOokWxRFErEmk7TtT5lkBIqVeND07WvA
	 5nie0wUduz9JytlkrR7b4ZQBmr6CZ0acKFfE5ZO53eXLgarqnjxA0sTOFwQqqpcFBC
	 CUmUZ7FJOaNoo0AAulGzpam6981l3hVUMBPcVBkOlCWj9WsZq718lA0lLnsonMKMoY
	 y1vxKKVJwdTuv7ks4iMofY3eh4GYw1kcvQeZtZ3nWET+G0ouhGOx2AojmCfAcjPjnX
	 91Msloy85+O9jJoRC75n1bPlAFZPjeVY4Jyi0PhP2TZrSZ4a0maTdEdDCg2BQh+e4x
	 CTcyX4VW7p+jA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	cuichao1753@phytium.com.cn
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	Gregory Price <gourry@gourry.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm: numa_memblks: Identify the accurate NUMA ID of CFMW" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:47:32 -0500
Message-ID: <20260301014732.1711498-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A494340004
X-Rspamd-Server: rspam07
X-Stat-Signature: tdfpe7cox4x9qjuspz7muq7r4wydt4f5
X-Rspam-User: 
X-HE-Tag: 1772329655-107472
X-HE-Meta: U2FsdGVkX18sHhOoYFEQ/82M33Q/rr6DCmndH5nvCgS60R3KMnHuJ25TiG8jvM+e54DPbSxfAtrNTQnV2eDJr6nSu4e4KRUgNWBDSvNt49by1GtgOSVIJiZzHCLC0r1yy7aJJdO3dtNunvgJhJ2RxJuuhuydVw1jwXvRPs28i6Nqe9Br75O71fWrjgDtlqMJM+xaXCBSpPTWnpvrG+gWZ9pdSAURUX8K8RT1pgP6s+M7PV4E+qn/hYQTu0yhkxqyV6I8VFRxKaKCH/12CEHcrAcaQd47UawGBuiP5wqo0jm2eJWW5rEhxKWbDGzI5kQcz/XFls20/BaN/9rPmvIrle37CpKRq6KHxkaat/ZQG2Csc6A/AgREB0UW9oGM00Kg3lLZugEWAwebpERg1gEhBUqibvbvT9AEz51rHX0tbdts2LvtiYnQvRmLT0eSpvc6ezG9IJDFvfjA8kDMXyHSpfKfUGO/x4+izdVZjA3J6KvuhEmwYAm9Z7yLe2kBpZJP7Ch0vtb1s9ycMtXUJoUmP/ptA6FMUzf3bt3lGIj3vUP5G/C5awmiDkkiUdEzf8jgqSgHflkHsch/f88OmH5AKEOTNaDnDsUQuEROcK+EZfsgo0B25pOQPmYO0/dM9WVryPD5xz//J5bk8wOUTnUGjRVKFi2PBpT2NkjF2o82RErQ8iC/iSNYviYYgkW/ts8ABMJhYpv6uHTuqXXW54LVq/MxUIOWdbUWMg9lRmUCTqAYldpGddJGC57dEWIaEKBlM3CRnf6regRybIEMe8QJW1JsexuHkjSIDs3o2GE9oZpM3FkJ43LI9DfWX5U1YN4leuFZ05Chje/YHI0zITbPnpugvVnwIUyVPvS8LiGyzu0Nk5P7tH9EQbdPbIB3ZMhxM4Wvc+vaGIEpbDIKqTN+a9ehDEPwRPsCB4g4lLtaHM7uV5kT9HpEgOxemQjfigYnpFjAPinhZtAoOQimbOH
 k23ZzYaf
 QccHZcRcpR/2fgATFCcW0HkpZO9aHvU3hgPeqPCCCt/x/kTAvZ8m6J8/xV1ro9Z9QTbFElGRstZHHVk4WrstjynxviLo2ZnDIIpu0KzPYiH1wcFswN5I0h9OOgwSYAmb96h1/+LPAGtipj+PqDqFwOlaqm13Q+fBepWdgfkmJ02xkc5mRr0rZLY9JXLxs1fFUptFh7FfZnmQmtYi4+eCEgljxS8g1BOd1RAW5d1Sw92DcyL3e7HGpyoVEnicEvBctt5THkxdh8iLq11G+7gSBZEzq03qLzqSqejOf4rwL+1uU88TLbr45ymuDNdToleCzRC9xkJT3JQQUcfjNR8PE7BSHAmckImXKtqCtzW9+3H+BhFkW9rzF60Wk1WYrEHZ51mS6yUc5PUFPPOg2pRF5vBJd5UZSC0iaocdpr8wTSY3Jw6rrtBno8uGIKlWpQ2WelrFG9BuOVexDoJnCiXNCVpxrHWcED4URGBQHtVdN0RlHNGpxvsQ4ZNgrwxMJ55euF5djtOlH+OeYMFPVJ0Cs3DZ+KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From f043a93fff9e3e3e648b6525483f59104b0819fa Mon Sep 17 00:00:00 2001
From: Cui Chao <cuichao1753@phytium.com.cn>
Date: Fri, 13 Feb 2026 14:03:47 +0800
Subject: [PATCH] mm: numa_memblks: Identify the accurate NUMA ID of CFMW

In some physical memory layout designs, the address space of CFMW (CXL
Fixed Memory Window) resides between multiple segments of system memory
belonging to the same NUMA node. In numa_cleanup_meminfo, these multiple
segments of system memory are merged into a larger numa_memblk. When
identifying which NUMA node the CFMW belongs to, it may be incorrectly
assigned to the NUMA node of the merged system memory.

When a CXL RAM region is created in userspace, the memory capacity of
the newly created region is not added to the CFMW-dedicated NUMA node.
Instead, it is accumulated into an existing NUMA node (e.g., NUMA0
containing RAM). This makes it impossible to clearly distinguish
between the two types of memory, which may affect memory-tiering
applications.

Example memory layout:

Physical address space:
    0x00000000 - 0x1FFFFFFF  System RAM (node0)
    0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
    0x40000000 - 0x5FFFFFFF  System RAM (node0)
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

After numa_cleanup_meminfo, the two node0 segments are merged into one:
    0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.

To address this scenario, accurately identifying the correct NUMA node
can be achieved by checking whether the region belongs to both
numa_meminfo and numa_reserved_meminfo.

While this issue is only observed in a QEMU configuration, and no known
end users are impacted by this problem, it is likely that some firmware
implementation is leaving memory map holes in a CXL Fixed Memory Window.
CXL hotplug depends on mapping free window capacity, and it seems to be
only a coincidence to have not hit this problem yet.

Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
Cc: stable@vger.kernel.org
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Link: https://patch.msgid.link/20260213060347.2389818-2-cuichao1753@phytium.com.cn
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/numa_memblks.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 8f5735fda0a21..3f53464240e8d 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -570,15 +570,16 @@ static int meminfo_to_nid(struct numa_meminfo *mi, u64 start)
 int phys_to_target_node(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
+	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
 
 	/*
-	 * Prefer online nodes, but if reserved memory might be
-	 * hot-added continue the search with reserved ranges.
+	 * Prefer online nodes unless the address is also described
+	 * by reserved ranges, in which case use the reserved nid.
 	 */
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE && reserved_nid == NUMA_NO_NODE)
 		return nid;
 
-	return meminfo_to_nid(&numa_reserved_meminfo, start);
+	return reserved_nid;
 }
 EXPORT_SYMBOL_GPL(phys_to_target_node);
 
-- 
2.51.0






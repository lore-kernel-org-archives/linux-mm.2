Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BABAFD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C589A6B0089; Sat, 28 Feb 2026 20:28:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03966B008C; Sat, 28 Feb 2026 20:28:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2D596B0092; Sat, 28 Feb 2026 20:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A3C206B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:28:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B5E31A0373
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:28:36 +0000 (UTC)
X-FDA: 84495759432.01.478DC69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id AD1F7C0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:28:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGaUrFBy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gvotb5mqYoYKsZEykZCRp5Ub9gysSYDbZ743BN5BGKM=;
	b=XqlIEWPWwcAjdfgKv5j9/3VMM9DVtYB86hB5CqE+01ios6OLYqtB9xZuJL2O8lU5sp79mu
	hp27G/qYNeY0uslhNbY2ASvf7YlHATumf98t5VuJLKJNO+LdDbBjzhxpdALr66/0KCGPvj
	PydeVVDEVsWmJXg4w3AX46cHRNoTn08=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328514; a=rsa-sha256;
	cv=none;
	b=BakaBBBSIvRY9xucOVqN74GxXe8/NoJbGhsy/7naa7MBz3GI2Ukdntff7/UHA96Et1mEe4
	sP+p/7/E3QSKg9K52ibPCg2z0+yv1HgbkZ/i119lXslky90ejHWT9oP6LpA97vKrcSEB6I
	T6+peSmsu38RTrc7oQkDfJYvlIRm+KU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eGaUrFBy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF51A4348D;
	Sun,  1 Mar 2026 01:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C623C19421;
	Sun,  1 Mar 2026 01:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328513;
	bh=8bfwFCO8SIFrbKV1cwycC69fkm4iZipWVhEKQ5L6dcI=;
	h=From:To:Cc:Subject:Date:From;
	b=eGaUrFBycjIxreSz5k8O47OfOVXtrnqaQYRaseR+2Q1urnt/g9M7QSF+wY+bV6+7W
	 c6fyrD9bkONk+3gILyKLscIKyA8XQh8eZJjOqtCT6alE7fWfXE48w7QYpkJw/BarBn
	 rRgtfCrLhUXqB98oB+T3H3ANZsGQ/OaWsfeDJn586cIWRqokJQqO2GBZlA1hhIbUeR
	 p7jMQlRnN8ZR23ryoaJCo2NbCebuK3JHlawmTbKFJmkDf5B/sqU+PWBjUrlM3PSGY8
	 Suh/GdmqS/JWaZtgSncYTGoM+loAt0EC1jtcX0lMKNcxbq/LbxCP5f7kgyzA64GJa5
	 i4BspvJG+rBlg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	cuichao1753@phytium.com.cn
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	Gregory Price <gourry@gourry.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm: numa_memblks: Identify the accurate NUMA ID of CFMW" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:28:31 -0500
Message-ID: <20260301012832.1686293-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AD1F7C0005
X-Stat-Signature: 6k4iedxzqkrmq8tepkif4or1dwnnd1ry
X-Rspam-User: 
X-HE-Tag: 1772328514-826117
X-HE-Meta: U2FsdGVkX18W8fTzTe5Tj3Mw8hVU9NL3hhT1NFRkXblJ/+Bl/SBRm3ETc2q7ftM12kwjfiA4/G+5HnaA2B2tGtzMz2Nd0hVHjwQ+X8P3H+apyVKnslvZw1XNLIEi001xiWiCLCWfWFAzW8IrQ8RCStEdhqIOTCHuPT8QZ4jKOOuGVfrRe+EERDK9GPk5xC5Ze+PIdjXl+9Y/VxwTWc2WtMeBuxhLMoPFi84T//wBWZXkA4AqhcuwXpV1YxGyetPd1J/REsJvL5PhjJY/0mkgqublncQq8159J6d4vsQMW9Z9rzdkMbPgyoy+jXPdCfgyY0ZgNwNbM0QmIF5v/ihQ+6DX4J30ftc89wtqioamT1U1JLm/Sqqyq3lQrZRMymV+P/JehUdtGvQmqt8CMNQ7K4SRQRile0hG3cOrYXdqRLZRLcNuJMQTHzDQ3cbYbNsa+kzkkkVOwosx8iZrfoxYbp72BkpJdTRla+vtirBVPrhtDCuwZUmYCWJXgxh0gAEZv6JC1vynWpjTiWrXeg/kb+XVmNmxf+abcu1QroGbnBV7s6Ad3oSmZbNy0NRa1lzFvA9XlkHdI/T0Ex0NDrOvV+iQOeO7xqjBVsT/wi09vdmDw7+oYIVl2khimb/NqmtIf6lElmDncp09oxyxodOsmQVf9Td/JTi245wSBbToLdy2Lcj6zCOhoCixFZ+PN1H2Xp0dxTYVExF52f6D2Nu7RlhpMWsNaTJo65PlNS6z0NGIfEQV+qIAsfnHOlQkowSxGMqmA1EBEPe2lXNmXWEQz8tCTBkQMk1Wp8CuRqhVpzjGUMzWsMFhtpfLZWjFv+n5ArRwkgq+E3veDWd1bQmosquAsDjIPc7gMXbH3uyU2oX53Up9wlZHSzCJy9bexdc82z4EdaanLBiHjySECh8mz8+dijcoGeteV9LxOpcXN4t3vzQt2hobB+HWlCyBnfLax1jSf7Z4y1V32zQbC9z
 7NcDvRZ6
 LqKCH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.12-stable tree.
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






Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F184EB2700
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 10:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553746B0096; Wed, 11 Feb 2026 05:33:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519E56B0098; Wed, 11 Feb 2026 05:33:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C086B0099; Wed, 11 Feb 2026 05:33:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 325156B0096
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 05:33:34 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AA7C584FC
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:33:34 +0000 (UTC)
X-FDA: 84431814348.12.FC0635C
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8030416000D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:33:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770806012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CLK/9wx3rkTchWgegvbyjXqiHMAL8P0Y+qtrwlxLAHU=;
	b=ebFM+BuS18Vqc4P4VfuRhoq8o8lec5mS5M6pAHNZiT4vOe3XFdeqHECtQ+salHDuWegnvB
	U6oQ8XvQnc0h+eE2HF/3CqeXLrqibtfirRiiweM7PlYd31B4oGRf+TZ6BApHTYO5XbZGGz
	ECrSbg613Umvxr1vZOrG1LTlYTYssxE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770806012; a=rsa-sha256;
	cv=none;
	b=pax+oZOR0pODO/jXb1TV8webPapiYsVR0ki/joKPjwnrP3hNtjQuGLXjB6BGLgYiAR2bZS
	IeEIm/PAxy7Vo7/QJwFgSO01P50Tc9WnWpihlrfn3l4uaatONJkNHn1DY/F1nNmHCPOzmB
	SksOzdTXqE1Oco00mkdpoHcWNQfggdE=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwDHzJj0WoxpaeYHBw--.321S2;
	Wed, 11 Feb 2026 18:33:24 +0800 (CST)
Received: from localhost.localdomain (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAfwDXMO7yWoxptIgaAA--.31566S3;
	Wed, 11 Feb 2026 18:33:23 +0800 (CST)
From: Cui Chao <cuichao1753@phytium.com.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	dan.j.williams@intel.com,
	Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	qemu-devel@nongnu.org,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: [PATCH v3 1/1] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
Date: Wed, 11 Feb 2026 18:33:20 +0800
Message-Id: <20260211103320.2064211-2-cuichao1753@phytium.com.cn>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260211103320.2064211-1-cuichao1753@phytium.com.cn>
References: <20260211103320.2064211-1-cuichao1753@phytium.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwDXMO7yWoxptIgaAA--.31566S3
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQADAGmLkQQCTwAEs8
X-Coremail-Antispam: 1Uk129KBjvJXoWxKw4kGF4fJw17Kr1kXw1rtFb_yoW7GFy7pa
	1IqrZYgF4kGry7GF4kZa1DJr1Sv3ZakF43GFW7CrnxuFn0gr18ur4Sqw1YvFWkGryfC3Wr
	XF4Dtw1Yv3WDZaDanT9S1TB71UUUUj7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspamd-Server: rspam11
X-Stat-Signature: gwzqnm3gniyw4he83tha9544b1st1ci5
X-Rspam-User: 
X-Rspamd-Queue-Id: 8030416000D
X-HE-Tag: 1770806011-166186
X-HE-Meta: U2FsdGVkX18TVYbQlS9AKCWieLNQmkRSceZDXsUFRiwyAAnWy2bkL4+GGtPKVJY0rhYx80DcvFONYgxU+2qiduHKNUrPUL+S7UAHVlDbePiuhDmSQoByeufGWnXr8d5nknBuU86bHYx4VWNhi/sYCkee+tmojqPEcFFIbLy0Vps7Y3ikeTcCKnUDfpWkIZ75k3EABHz0NPDMgR+Z/U2tyvArVkP/vKgK9nCkCQx7/zRpHkmJuoq/B6JcLE2IUEegueq7FSYSo32iF9x2OT8ccM39WmZJO/hYyPD7WM/rKpQPTSAf6R2R7NbRONeyJwFdF0eEzubQvy+C7JajhUcZ0+2uR8ddRCSS1G42vVZrqxKQ4uhihYBCgijlmmLpBTOMPW2REKwxR1rdHHpR6if9S9MrnUBavWceqMmTLb0xcrTm21XoiHlVkKiknd3DaQdQB2PX9bJUTFXd8QHIRPqC6VG7W7CaSu1fDIyV3iiirbEWlVlhI+wJT+BJCaCB9uC8oykuOEW7VOM7qe6+0s6WX4P1Lxei2Pg57Ril7Svpnnhc6bN+wUQzcBi60RzTksOVXMZUNECLVuZe4FFKdOnoRnd9uz4Zs7upi6S3+0suiK1b2R/UZ27wq3+HX4YO5T+RivwHGTCRR8wwPr4J6H/L2kYPE6dLP2xdaPXly7RumGyVouIisDRemM5j+vwCjUitux7qQxrwYmBlKoemHv6eYtDUqWoK5M6k3xUL1zbdBwDxzVYOl3M5AIGzSKxNl7uiZTYjd5Bv/f8dXGhYqMxPZJJEqBhO3vWEKxX/MRNYpABzVpXLqah10HMPyl6zZoi1GwojcLAdnrl8tei26x7SyrR/hu/Ao0y2Cp5LK8yV+ieHNHRwXvyOWKMn++8bT4th6AGXj+NBm7Hjjviw8Zj6Zy9Y5uIDyhh9CN/O5/p5Y7uYQdf/H75yn8lGnYs485xZ1+5oaN/MC1ldkF+jQQ5
 +ddr+M4s
 h2UlQ9R2xZt6DNNyiR9oLwDLe8kv2E0N9yINFaNJbY7NBfNUmFTzsgHaYYBGD/VQSVrYXfv27FYCfghdunZzXfO9+3VL3JHCLRoS/gOawtDAsnfXQfYWlfiDMz+gkVKJShdW49OLJ+jTPKgY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

1. Issue Impact and Backport Recommendation:

This patch fixes an issue observed in QEMU emulation where, during the
dynamic creation of a CXL RAM region, the memory capacity is not assigned
to the correct CFMW-dedicated NUMA node. While hardware platforms could
potentially have such memory configurations, we are not currently aware
of any such hardware. This issue leads to:

    Failure of the memory tiering mechanism: The system is designed to
    treat System RAM as fast memory and CXL memory as slow memory. For
    performance optimization, hot pages may be migrated to fast memory
    while cold pages are migrated to slow memory. The system uses NUMA
    IDs as an index to identify different tiers of memory. If the NUMA
    ID for CXL memory is calculated incorrectly and its capacity is
    aggregated into the NUMA node containing System RAM (i.e., the node
    for fast memory), the CXL memory cannot be correctly identified. It
    may be misjudged as fast memory, thereby affecting performance
    optimization strategies.

    Inability to distinguish between System RAM and CXL memory even for
    simple manual binding: Tools like |numactl|and other NUMA policy
    utilities cannot differentiate between System RAM and CXL memory,
    making it impossible to perform reasonable memory binding.

    Inaccurate system reporting: Tools like |numactl -H|would display
    memory capacities that do not match the actual physical hardware
    layout, impacting operations and monitoring.

This issue affects all users utilizing the CXL RAM functionality who
rely on memory tiering or NUMA-aware scheduling.

Therefore, I recommend backporting this patch to all stable kernel
series that support dynamic CXL region creation.

2. Why a Kernel Update is Recommended Over a Firmware Update:

In the scenario of dynamic CXL region creation, the association between
the memory's HPA range and its corresponding NUMA node is established
when the kernel driver performs the commit operation. This is a runtime,
OS-managed operation where the platform firmware cannot intervene to
provide a fix.

Considering factors like hardware platform architecture, memory
resources, and others, such a physical address layout can indeed occur.
This patch does not introduce risk; it simply correctly handles the
NUMA node assignment for CXL RAM regions within such a physical address
layout.

Thus, I believe a kernel fix is necessary.

Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
---
 mm/numa_memblks.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 5b009a9cd8b4..0892d532908c 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -568,15 +568,16 @@ static int meminfo_to_nid(struct numa_meminfo *mi, u64 start)
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
2.33.0



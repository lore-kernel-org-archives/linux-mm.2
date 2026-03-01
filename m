Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEF0FD0045
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10ECC6B0093; Sat, 28 Feb 2026 20:38:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FA156B0095; Sat, 28 Feb 2026 20:38:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030A06B0096; Sat, 28 Feb 2026 20:38:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7A416B0093
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:38:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95ED7B818D
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:38:51 +0000 (UTC)
X-FDA: 84495785262.22.172BE0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C9E5F40006
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:38:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sq4Zg7m7;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7e4dgtiowU3mgeLkaNPlGYr1VYqOGDVkz85JX6PeB6Q=;
	b=Mrvq1d3iyGxYmnR/G8y6d6+uCvGQ+UQ7X5QYUiyHuDWjLRJyXVqj4m2Sqcmro7FdNiCdLR
	v550aRcocGTBY/V02PuIwId/TVmiF37Bt0GTDpwd24Kn4SC+wsp8HJl3A6yMDz5mmj5FpV
	ZOvSNVmBw+GE25ClkreaF1XOJ4r7Gm4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329130; a=rsa-sha256;
	cv=none;
	b=RzdUxhFzbub1NtUSN18FK67cqn+dEkqllHtelXj2JcDEr8FCt0xftDyGT04I5f7c39yxfJ
	3gba6+eMiVtqv/dzsLAA3kTmjqvrc6TC5Vtee3Qioy3ewyLYECR79lcRGukb1IqifIXL+3
	zzx7i+8+kxfD0c3bKYPymC6ZVWCJUqY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sq4Zg7m7;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88917419F1;
	Sun,  1 Mar 2026 01:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65E6C19421;
	Sun,  1 Mar 2026 01:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329128;
	bh=aSSSAe8uX+SUe9F9B1rdRuVL25CVI9q6RMqwwLKQGTs=;
	h=From:To:Cc:Subject:Date:From;
	b=Sq4Zg7m7gJ9b2SWAiBg2q7L4p9tuSFwHgTQQuwUnbG9Q/6dhaPOWBzcWKADO5AvUU
	 /0gZYmwMNyzV3oKtTn+msdLnEnH0zWy//IyMIaLaQRQdkABKru8LUIUNdmsWQAGEOl
	 U26Ht8b9dkw6oK31XsovtG446gMT3gJA/rpAtm52TCtKo3xlpRhTuBANwr/I/7Tm1R
	 Pdhvg6SEEi0qpDLeOMYtbmAUVhhGJWq/2KisSknxNE9TjrOgR92D2Ibza2vnQCOzD5
	 +BeZh03Tbh0ajnu6srNR5TjtRjTk7seg9QJZ8GKKIoWNNlCM6JOzb/AMquVNReJLJM
	 5YgCh29db4ajA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	cuichao1753@phytium.com.cn
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	Gregory Price <gourry@gourry.net>,
	Dan Williams <dan.j.williams@intel.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm: numa_memblks: Identify the accurate NUMA ID of CFMW" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:38:46 -0500
Message-ID: <20260301013846.1699550-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y6bpq34tofb5twywhommwpzk54u34qhu
X-Rspam-User: 
X-Rspamd-Queue-Id: C9E5F40006
X-Rspamd-Server: rspam12
X-HE-Tag: 1772329129-327542
X-HE-Meta: U2FsdGVkX1/ukbDOxqNl4vInDtNNFxpiVWboye940NgwQKwa3tauMx18ymTDOxdQNwD5iDo3J0t7vizutrSe9BMcV3wgGEvfzYeogrRPz3+bTeTSBNoRONL+7wA4fz8rnadVL76Us+lQw0/mKZy2JFyZiks9Wte2nT+7n1l/FkY8HXnvTSVt1R9GpLmMTAN/JMZEQskpOZKTBH7A8SPPFbbpA4xafLJaPx6r+q3bA0Whl0aJ/qR8OpuMEJfZXR0/k5CgygLax0BaOCLYoWXa64mSGne6VDiUqYzihYRsOZlYnsf9J+9PQNPLiH9IpWy/FRa98saDe1VvYSiiE0N9hqYywbeRIajWra8MMhN/ksyZNGenQ+KlrcjSuCV39aRBhb/gjejTQ7O21y+MmLiphBWYJz5YqVaCigXDyP6CEIYJlfU7cGf+q0JWP5loxQvCgl/RpQHmEcRKIWjIBe4lGTilSPWDKxgUKLES+HkBI8gnnOwuJyZgWtijVJ73GIbr2KU8ls+cY5fqXwqFLB6t/7oWv3iXte2+MVEbe9L7rtHr1c1jgFWuweVorYV82Jc3v4SgaJ28ofTfurD4y0JOhXVOv1hWaJG4eqmND4i3aM2fQbvy2IwtLP0NO7Iidf8lsCHAbQB8TRRIGNMO+C+4ctSGjzYD8Ubs8dTld6wx9kHb6HOcPnM1u03g69D+YOOvWOXdlJM/f2qjO655jJY801bSXzZJKEuLCYXO1BKi5msyra7byxqbvJvuwdqLGfWVKUASYaKZCgDf81MYZOK+Imgc7Yiu73BjW2lyWF2TieZ4rKe4Cfaqi/7V/AE2Z2wf+plDd4P3pMsbKw5cR4VtNpuAWlKY1hC7d1XGWfRqgpFjbD2ffnohS4+q861j03W8a18cM05UYjrf979F54tnhqhXR1y5kquhpQzd7dujHfeIEJbXMr7lA00bqEIq6RtdQl6qdDCWC8cyHbkEKVs
 7ZPIPqtu
 WFwt59JDhRKfdIWoVLjrBIkJ4zjv5Ikxhix6THnmT1VFkqPxBQ5KAvlvsLPtWjR/d/GQSaYvcKh0CkRO0CfaIbaBsjqsPUx1fkT2X8PUvMLQDGcz9+4fHc72UtT9zCIGy8IK8+Z7bL6nGZWAAu6G6wvwXicksalaZtiWmrnvW+eNdDqNQ+7o83+D3OwVUdvmwVUdPLa6lRnufsa1pPyg2EzZhb50HkusPX+tqANb+r1aI2cp3zZRLzBqUp8RBuflGuavXcy5HMNdFzhX7mWXHuTIxXAJ5sy043nNhJ/Qm3HvcleJTk103v44YVTL9iWaxNbl7WsoKa2FTL+X4rbUBUspD0lyJbiblkYIwTTNQ+CaMF+VqyNRHVckfh0pUc804Rm/C18s5YVm7ZrT0RcS+ywsOiYErXIre+79y/6KWX0hdMK5KtCz1+pOH7T4CEGnZVlIA6iw6WCQJ3mwGmfJ4K+54FUDazlxfT0z6iGw8AmWKLRFoqm05Y72RyeAlTRWPwKIBlhXtn4q+Z5lyt+Nfb0rY+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.6-stable tree.
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






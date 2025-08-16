Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417C2CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1FF8E023D; Sat, 16 Aug 2025 03:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C934B8E000B; Sat, 16 Aug 2025 03:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81148E023D; Sat, 16 Aug 2025 03:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A12138E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:37:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 279581177DD
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:37:40 +0000 (UTC)
X-FDA: 83781815880.16.1C78DCD
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5AA39C0008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:37:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755329858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=nHyYUs7c5cPufj+ORxuTJTENVRLZeNseXVnIuV0JDL0=;
	b=pgce4+Mp8lh4fFIu6Da7oF6z7d6lV6zK1V5pmmMrab0SsuXnBHB3Np+b10+syCTGvBeMDL
	9sPxEmklda5NAv+U/SxX+SHzzUNkqfddgwcP2Bmt/9o+6vTspIIRpmsZ+FfroGgMaXwYUX
	youK9uUER1WjS+7zGatujvtk9f9Lzng=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755329858; a=rsa-sha256;
	cv=none;
	b=FQ2XBN7t2jdTXvmokiz3EMBm7yL78FDUbg4NhRtFjSTSDW018xeH5/Zx4JAER/dAyfjaOY
	8wqDiIsRkhpfZinq0PmK/O/GEp1Q9W806EHUyOw3QZPjHx1MKvnkSlhPXldQPt2GM/fdH0
	mYjPRTq2z2eCS7Gp2MLKOd5v3ULavuY=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c3rQ52gM0zqVTs;
	Sat, 16 Aug 2025 15:36:29 +0800 (CST)
Received: from kwepemo100001.china.huawei.com (unknown [7.202.195.173])
	by mail.maildlp.com (Postfix) with ESMTPS id 09FDD140123;
	Sat, 16 Aug 2025 15:37:29 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemo100001.china.huawei.com
 (7.202.195.173) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 16 Aug
 2025 15:37:28 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <robh@kernel.org>, <saravanak@google.com>, <dan.j.williams@intel.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <rppt@kernel.org>,
	<Jonathan.Cameron@huawei.com>, <devicetree@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>,
	<yintirui@huawei.com>
Subject: [PATCH v2] of_numa: fix uninitialized memory nodes causing kernel panic
Date: Sat, 16 Aug 2025 15:31:31 +0800
Message-ID: <20250816073131.2674809-1-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemo100001.china.huawei.com (7.202.195.173)
X-Rspamd-Queue-Id: 5AA39C0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: bqzeefdgb98otakiwaukn64bkp8kp3ds
X-HE-Tag: 1755329856-323239
X-HE-Meta: U2FsdGVkX1+yZphPl6KjOwxkdQQ0Nte8lXL0s3oU+wnceTPv2qq1FVShb0zj+o7RV0NO0lgV/hHpXY63hPv6TYusriU5qwEP+EaKaQJYDD1ZKAbvxHow+46T9BExHwqIOkmYWxbq5ixnz/DtHaCurKLyoM6+85sXfeG1fNlKk14YOpWRQYYiV0hgFV8K/Hr6gAuks6TdVbMbMAXI0WxfIsuz83wSXIEPyEH3u8qOlmcqd1qrTK1LqdvIEv2fatF5uARMa9ADrFUniYd8Uc5ffNdzFtrTcEmIXrIejuQHnHuxp/y4L04I6L23yblyeTpN+GtBA0wsHVMuXnUmp+I/R2tCVWg+5lDPiChRrzv4cI0GcxMU3Q4i6TS8itcGP1mENVYtC+8gYGiFCMhZC9zxk/oOMjT4sbpYT9NLJWSsvOFxy71O1YiIXQVXJutwHQOqEFPP+H9ooyanxbYAZXifEmFs+OZKKh3WrklssS3lvqx0OmZibVq0XOY67lSLB0RrFBSGhYztO8mTD7fqWneH2ks8c8EcwSGmt4G+9hSR8S/xcfmV0/YdHom5m+1/vWCfspmPPv7F9FcOovxA9gS8wQqtWk5+mw4GyU0hVomeTaHHl2hT0eIRa8uAzlHvli/aGSoWn2Ha8sFRTzoa9V/1b2tnCMoWu/1AZePTxb5hNFnGxl83GTiV2yGcBvm8S6u+qvPvUGKMIE0xVDqCJVvFGiOUZbARGKGoqWnDPdR9RnUM2KHsSLVIUyG0hnLJdG73cIPZ1y/k2Z9N2Ymvm5lnbHwwCXTjwNK4JXU++WbvYFrLRAv24kzIT6Jn5/bARb1tkoX5fJSu4rf5EcICLxHOqv9cUkryv3v4rjs+QCmBQ9AIJD5AuyalOH69w6IVv8VRrzVqNM7EpiuJWBhYFR/k6W9SC5x/ILPc5/8TjsIQZ7zqhTLLn3GecBh2BkV5aNzMUztJOam3a3NgCL6eyy2
 ATUqeLKP
 3oAMcE5rzKucBR5mRle9lkrG9EGCp96lNgbJpeH9d8aVZK+4dPiZDJvRhY3c3NBbUWViFo8eogtjsCUAFzLdqOfEGjx8Djhpzjy+iaBW8UI5yOeseRHFLEsDZW8Jv+bgvXl+uOYVERsD6RclM5FOXR5RVIKWHdUU/maX4ukPjv5c5yUmMLOkumXfiZzbG3Osku8GudRyngcFRx5ffJKP+nckonLiqFfouiZFcsOvAZVutobcX1dIKFJhKMiireCp1JBCynGsNUMt1jN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the number of CPUs is fewer than the number of memory nodes,
some memory nodes may not be properly initialized because they are
not added to numa_nodes_parsed during memory parsing.

In of_numa_parse_memory_nodes(), after successfully adding a memory
block via numa_add_memblk(), the corresponding node ID should be
marked as parsed. However, the current implementation in numa_add_memblk()
only adds the memory block to numa_meminfo but fails to update
numa_nodes_parsed, leaving some nodes uninitialized.

During boot in a QEMU-emulated ARM64 NUMA environment, the kernel
panics when free_area_init() attempts to access NODE_DATA() for
memory nodes that were uninitialized.

[    0.000000] Call trace:
[    0.000000]  free_area_init+0x620/0x106c (P)
[    0.000000]  bootmem_init+0x110/0x1dc
[    0.000000]  setup_arch+0x278/0x60c
[    0.000000]  start_kernel+0x70/0x748
[    0.000000]  __primary_switched+0x88/0x90

Cc: stable@vger.kernel.org
Fixes: 767507654c22 ("arch_numa: switch over to numa_memblks")
Signed-off-by: Yin Tirui <yintirui@huawei.com>

---

v2: Move the changes to the of_numa related. Correct the fixes tag.
---
 drivers/of/of_numa.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
index 230d5f628c1b..cd2dc8e825c9 100644
--- a/drivers/of/of_numa.c
+++ b/drivers/of/of_numa.c
@@ -59,8 +59,11 @@ static int __init of_numa_parse_memory_nodes(void)
 			r = -EINVAL;
 		}
 
-		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++)
+		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++) {
 			r = numa_add_memblk(nid, rsrc.start, rsrc.end + 1);
+			if (!r)
+				node_set(nid, numa_nodes_parsed);
+		}
 
 		if (!i || r) {
 			of_node_put(np);
-- 
2.43.0



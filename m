Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FEE5D59F7E
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 08:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CDB76B0005; Sat, 13 Dec 2025 03:31:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17ECA6B0007; Sat, 13 Dec 2025 03:31:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094806B0008; Sat, 13 Dec 2025 03:31:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E770E6B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 03:31:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 824291358B1
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:31:25 +0000 (UTC)
X-FDA: 84213778530.15.8113844
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf23.hostedemail.com (Postfix) with ESMTP id 41ED914000F
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 08:31:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0lnEN7l6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765614683; a=rsa-sha256;
	cv=none;
	b=n15Fu1sWY8kWruiTXavIbAynbc6pOl1fbGMCgLCxm94A5Sr/BHySdruJkyPkIFcEOPe228
	mioVzBx3pzcaast+xIw66OLv4ga7jUXDv01sCMRRp4soD5sBJVpzykHFzITtq48mtTMlpc
	JqKYAk1gVk9aWZp9YA1woPw6iuhpKpU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=0lnEN7l6;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765614683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ORyYkgJ5bq3kFj9dBy+myv+leOi2JbQxMlDPqx5YGb4=;
	b=12vwOAYJU0UCOH1icnLMeDBNr0Nnv94ZogiKEPPRSH3oU6B1N3CcAgxrkFY7YrO6/npj6d
	mxmO8FZS59PsfTRdVZXDN03kuS0gRBuREfI1lHSjs93th1RjCLkggNGDM9QQ+HkUKUT/bc
	ub6jz4P48OMfns32IvOrIKFb+8GvmQk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ORyYkgJ5bq3kFj9dBy+myv+leOi2JbQxMlDPqx5YGb4=;
	b=0lnEN7l6yT5uOvsEwx65pq4dS/1s1ROIfK/QBbzcQuUyQesBG3EN0xA4lay/JKj3PXdAZ0Rks
	cZnECzXIdVV06brz6R3nvUT0IwodAegfwTO0qFXmoQMOvdfk8xxKHJQGfq0PQBCDOVreZ5+/s8E
	jKQICcjgQpUT7WPIgmv8rWg=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dSzx94kKyzcb26;
	Sat, 13 Dec 2025 16:28:29 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id ACD03140158;
	Sat, 13 Dec 2025 16:31:15 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 13 Dec
 2025 16:31:15 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <mgorman@suse.de>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH] mm/mempolicy: fix mpol_rebind_nodemask() for MPOL_F_NUMA_BALANCING
Date: Sat, 13 Dec 2025 16:29:11 +0800
Message-ID: <20251213082911.1509735-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41ED914000F
X-Stat-Signature: k4oei145o8wxir17nyfu74qfn71gce35
X-Rspam-User: 
X-HE-Tag: 1765614681-946831
X-HE-Meta: U2FsdGVkX187zfyd82mVF3sH/MecnBgIdz201AIcYFExLM3d2t4yZmFWQ12TwVmxvR4VAdNkfqoFE6yJYxCm7x/7v6c33rQIyIAiAPSVLB5y1spvn57w4vhtG8RZevktPoCNyXaMbUJNWRCt0o8rEAEDX2ycJ2iaPd8UfKG5NnDb07/ZDE7zMs09e+13FNG3QhwX6lRwcTyxsld+05Ll70TErUt9TthLAdiQ6TUd0kDwSGat+Mwu96hcj6ZBaHIiBcZGskr6d+zCIKLyzlyCKnn7EhBnioiAVYdgPPLhx7tf1YpcwRdatQmRM9KC6d2Sa5Sz3YePMyjXsEs/OAzqT7EOt8xThbuzrw3zHyFBwRUjEiiY+JKk2L0dwSvNp2eITFxyWbKfJRV9FZJyp3KXuvZGDhcxhV1Oj2KJClkXBJiH/i+1JYNeGyD/9IKQvX7kSPTQee2cLsvB2YTE208MooizadOQHSiWZDLhaRF67f/gAvmngwEov+x5G/FJGy4EKcIQNKg+ZzBAkPPK4XlS3mk4Yv15plrFInI4GJxsVch/OUaJgcpVPyg2gaaDlvg7VNhLa40C1hVSjcxVV6kxVRzaKgtQ/jczoJuxArfk5XP8FCvRcQK+sX0+apwZu+EGJVBuyINQztHIxQh9npJh0PpuCPKLnG/WWny+mLCG1iJIF5INdfBdMLGWctsYQ/oAtp/loGZbjnNWUuAKbaxdGRlVRLRnvf6hoHd4q3Q81EBbH9H1wy5lkKJkL0ab5+QwzFDGQEhS3k6EqK8uXh8rSQfANUuHW/alaf9FAIr9V1nb9kyXpIjFBYHqLk032IbSdPv6C+RQ58fH9eQTHSjGscOWhs0mnHCi5hdPJy3+L/g6/OV1D3wzmcBRgiY/4ryeANsm4HVEL4PoImC7VJo1E6EPw5uwIY4bltddlPjYhfRUp3hz9nR11UPfpDqjAkumiLaahx05fNpOCK4IS/r
 yh5FgCM6
 DcnTtyTl6vhJ9/DPUf7qST/1b1IPJYqcshaVVN9br9gWmkZEVWR3melZFCCttG7RhuRbZ8JRt2M8cpRQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When mempolicy is rebound due to the process moves to a different cpuset
context, or the set of nodes allowed by current cpuset context changes,
mpol_rebind_nodemask() remaps the nodemask according to the old and new
cpuset_mems_allowed by default. So, use mempolicy.w.cpuset_mems_allowed
to store the old nodemask allowed by cpuset.

MPOL_F_STATIC_NODES suppresses the node remap and intersects the user's
passed nodemask and nodes allowed by new cpuset context.
For MPOL_F_RELATIVE_NODES, the user's passed nodemask means node IDs that
are relative to the set of node IDs allowed by the process's current
cpuset. So, use mempolicy.w.user_nodemask to store the user's passed
nodemask.

commit bda420b98505 ("numa balancing: migrate on fault among multiple
bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
for MPOL_BIND, the behaviour of rebinding should be same with default
befaviour. However, mpol_store_user_nodemask() returns true for
MPOL_F_NUMA_BALANCING, leading to mempolicy.w.cpuset_mems_allowed stores
the user's passed nodemask instead of cpuset_current_mems_allowed, and
mpol_rebind_nodemask() remaps wrongly.

Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 include/uapi/linux/mempolicy.h | 6 ++++++
 mm/mempolicy.c                 | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 8fbbe613611a..1802b6c89603 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -39,6 +39,12 @@ enum {
 #define MPOL_MODE_FLAGS							\
 	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
 
+/*
+ * MPOL_USER_NODEMASK_FLAGS is used to determine if nodemask passed by
+ * users should be used in mpol_rebind_nodemask().
+ */
+#define MPOL_USER_NODEMASK_FLAGS (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
+
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..76da50425712 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -365,7 +365,7 @@ static const struct mempolicy_operations {
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 {
-	return pol->flags & MPOL_MODE_FLAGS;
+	return pol->flags & MPOL_USER_NODEMASK_FLAGS;
 }
 
 static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
-- 
2.43.0



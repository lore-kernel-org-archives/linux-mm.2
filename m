Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20ABCCCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CD78E0005; Wed, 22 Oct 2025 06:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751538E0002; Wed, 22 Oct 2025 06:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C178E0005; Wed, 22 Oct 2025 06:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 516ED8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:33:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8FC51407D2
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:33:32 +0000 (UTC)
X-FDA: 84025388664.12.4DBEAAC
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012004.outbound.protection.outlook.com [40.93.195.4])
	by imf30.hostedemail.com (Postfix) with ESMTP id 16F988000E
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:33:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rhTlm3Dp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of skolothumtho@nvidia.com designates 40.93.195.4 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761129210; a=rsa-sha256;
	cv=pass;
	b=pyWPl0lRlVcgbTq3QhnUXJ03hbrBu5+TVWaKhhlRHgEnMaEzEsOkJDBDubC+DbefaewCmW
	V60fBnoOD8a+Dg4vQyb2/9q++fV/Ah8Le52H/FIpmwUNRUNfqWbH538nnQ0RyEZnHy8I/L
	PUH1/itiRibTJfBZLksSq28Icror2ro=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rhTlm3Dp;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of skolothumtho@nvidia.com designates 40.93.195.4 as permitted sender) smtp.mailfrom=skolothumtho@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761129210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2zoNPTxvzM0Nvl3Ha//rXxv+LgXCwayC93WgZex9svE=;
	b=XtTVaY0hr+aJv5dvBa8MTkeYXx05b32Ji9ux9fIWhvavMnD1nqkIqZ+lKBhZ/JJR2WDRXU
	XCYB7hhpoZu7xd2GmxNwk4qfMPJN/4qyZsAzodgvl2wOrGQWt40cJ1dK6X0xFLeEp6hKV+
	wn4Bxg5wOWTb29XPdSe0lWmGvY/ttsA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qM3x0WeKkVC5NILdam1CPGo4sMz3/tpAhixaFglTBEFDH0etXRysiscCbjoUu9fZlh8tC5XchgcgOZKS5qLruozvhH8bu5kpphe387YZdvRLYbbx/DOPkEuWjj7SqOhW/SS2TRhCla1S7crEc1JB4WC8WHw4ImRqAExobittmMI8CSkP2D7q7jYl6GP8ZQgE1/w2oTTTUwUP1TtII2BP85BNhrLVU1CGlF7dBfZLYg6z4Zt9QvsZQvgGOquyK6Yldn5PCsKO5rG3AIcChUhU6oVQwK9LZfb94QE78TQ52jRT225gfzBrmOxp6O4SLZmnCsWWtW9tVcYVHUr4gklBYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2zoNPTxvzM0Nvl3Ha//rXxv+LgXCwayC93WgZex9svE=;
 b=Ou+PfvkuFDm9jUC2f3UjXpeDlAnOM5T1xCYvcB0dyQ1MHeS/d3W1WnaDgs5n203jind3VKyDsByoKYRLPQL8ZKVc7L56X+fPDcnZPH0sXGZV7EgCC2W+rVh/qY2HyeTgu9iDiXGCsvLNoHk3r2JroefeAqwgV1xBjZ8ZqsDQVlDvvr2IrIya41wd3Frc4Bcq3bCa3hxGsYoc2TMd3JuIx0KtcKqpGsL0FbO+bwUg9oSlV7SGke7HWk2r5tFQwWtMjTh9LlhVP4e02mvVP7BuVp6jyAhT3b2IgQe2I4eVhZMaO1xk/Wswf+Sw7k8pglzw8w8yk3rHY0boqAqO9vz41Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kvack.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zoNPTxvzM0Nvl3Ha//rXxv+LgXCwayC93WgZex9svE=;
 b=rhTlm3DpugFE4L2DlnaHTEyOPtqEjbzKGtT/kEo4LS6u/LPc07Cat6MobyHaIK5wpHIkidZoDUoMbtIt4fzPU55j9KhOovCJQf1r59k9aChtWzJPegZyPdxYVMEfHCkOk2XZ4Mm09TXhPlEFWb0cuhUu3bsoZh4ejqlxImpbDmeAGSbIV/+5448LicWZK55fmypBYOdQDTbJTN7WFkbg6VS2WdAyD7NPxHYBmV43b5iOHAwlLwc9mWDGxK8L6UgaTVmOuLvTarVRtYF25Wgz6hKVV1Wl4fDhiwbD0oBLYxPw/JxD9bl6BMokRKCSE6ekV/Au9QJRS+CEuLFHfwFwgg==
Received: from CH5P223CA0006.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::23)
 by DS7PR12MB8346.namprd12.prod.outlook.com (2603:10b6:8:e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Wed, 22 Oct
 2025 10:33:24 +0000
Received: from CH1PEPF0000AD74.namprd04.prod.outlook.com
 (2603:10b6:610:1f3:cafe::19) by CH5P223CA0006.outlook.office365.com
 (2603:10b6:610:1f3::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9253.13 via Frontend Transport; Wed,
 22 Oct 2025 10:33:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH1PEPF0000AD74.mail.protection.outlook.com (10.167.244.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.7 via Frontend Transport; Wed, 22 Oct 2025 10:33:23 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 22 Oct
 2025 03:33:09 -0700
Received: from NV-2Y5XW94.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 22 Oct
 2025 03:33:06 -0700
From: Shameer Kolothum <skolothumtho@nvidia.com>
To: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <vivek.kasireddy@intel.com>,
	<jgg@nvidia.com>, <nicolinc@nvidia.com>, <nathanc@nvidia.com>,
	<mochs@nvidia.com>
Subject: [PATCH] mm/hugetlb: Fix incorrect error return from hugetlb_reserve_pages()
Date: Wed, 22 Oct 2025 11:29:56 +0100
Message-ID: <20251022102956.245736-1-skolothumtho@nvidia.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD74:EE_|DS7PR12MB8346:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ede4c20-af30-4c98-b7f8-08de11566d8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TslloTYUkKn0v/JnEkOp3qkq2nFOJF7MR5DA0id2ZsDrKYCC/hcKZ30and62?=
 =?us-ascii?Q?eOROfftS6h9/CXeUC0ao8bgZ/58PoqRHyx6wxid6jgEw1ucqkMyN1PVI9CK+?=
 =?us-ascii?Q?/vfVGP4sb0s8XNmvc81HfRzZCb8aMZzPxj+mSFX+30O1bfgfdUMfbmnhUSwB?=
 =?us-ascii?Q?GZUnZ63fw4ehi5nDxxaAZI9Vpgh+fLMnBaUaAGdaRTXwS+qhH2xkxoa8/Eph?=
 =?us-ascii?Q?OFpIDWTQI/VFpMrGxQkMhN06j0rr+2nA/1z7aCZP+y/qtNJKXvOPwrMquzkp?=
 =?us-ascii?Q?5pb4c2+2sEGh+yZ5r3uNgScMLzAYEcRGzg7ZT72muko4Glysskv6AhJZCQ1t?=
 =?us-ascii?Q?nO4NQo/i5JVGFCvtVlBYFBFKmnHXTp1TqXWzUd9C6pUw3lCKaF6GHemkxiqj?=
 =?us-ascii?Q?sM2HSjWFIjbu7npTASeLCQrdE8N2JjD5f3OFGy73/vWKlE3sY1fp9BeCKHdJ?=
 =?us-ascii?Q?SaT/3ZG6iYIqT19/LjdnKmpyFAVp82C9fU6f+P0dWU4pNXZq4no9F5dEWFQi?=
 =?us-ascii?Q?NNvmgKbclqlnOzptSOlCzTMISZCuZRQZuf4UuC/Hsq3mTTruqXQOv90RVwej?=
 =?us-ascii?Q?fxwV1WzieSd6XzLPgREe7doMEVNt2NpPvfSd2+6DBu6zSexx1VXHH0ckBt60?=
 =?us-ascii?Q?qjDPZLXys/wNuUM3Wazfn2PtPLMONCH6T67LLC/2EyMpCoiYnzRgUJjQVo23?=
 =?us-ascii?Q?MaIZPVeuLWBe8A9R0fYLxFRkU9Rgn/u908zhHdWgwSw6L4YqULNMi3hWbXTb?=
 =?us-ascii?Q?r/6YVQM7F7l9HVPYIbhqCEnAXKTIeBHw3aw+s/8yMvSVcGZf4n8wfIZ2yRsv?=
 =?us-ascii?Q?/KSyqRE217jP8Qq5bONe0iSTIS5ERQi8jbUe6JRjuUmWQ0EhVSFs76j6uj1S?=
 =?us-ascii?Q?IjWAdrU2ZHpAArSxJlNsuhLAJgIO7m138PtyyQhFtqn8vrIKCZ4o8dycSYmG?=
 =?us-ascii?Q?I4AIWfX3iDtDL4dr7N43OhZNRMGnY1ve3eJfzFNmF8yqXzQclYEOqOzXGinO?=
 =?us-ascii?Q?z9ukanh4g0oVO3EvcBnMfzXSwSaCc8KvYAhYrs06NAlkiwofODSO3oHIygxf?=
 =?us-ascii?Q?n46ma2ezDTn3AcICbChd3P5FldQTiEKnBS/T+5mIJFKG8l1BU6v/DdmmlttM?=
 =?us-ascii?Q?mwxGWHF6uTjlQX44o11XeBl4aKmzfo/mGyXt3TO/9PFdpLrpaXztCmUdhXSJ?=
 =?us-ascii?Q?VImQ1kSgAZIKQfYzgc4EHkugT7rkmZdmIOpjo1V3CLSXas+y+2yqdkDVD7/X?=
 =?us-ascii?Q?MG1oL4LZpSApxz29mkpEPJUM0xCiJxfPE50qM4/MUJBCymwlGk2f6IGrsvyW?=
 =?us-ascii?Q?T7O9+UXFyK4vNkibCvW5Cz7Kz3Zqjk0mn1GytuE/2Xz4s43PVM1LfWJlSaln?=
 =?us-ascii?Q?gq8ULhaaKK3Ro5QnUcv2A1+5HuNszGVkGD6UIhvNR2k4aKnU2o7eUIDuEeDl?=
 =?us-ascii?Q?H+ZbEYZuCUY201OqZo9T7kqJ2UfpeRxLUAepDhYAzyQK3sCZZMbgyaF7SYxA?=
 =?us-ascii?Q?BNLZ5DQugU6KT/rnLWlGgxGxCS4P1F2t2f68/moaMC1rWQAuAY+KEHMNXNIg?=
 =?us-ascii?Q?44ca/aX+uGKqwQIenqU=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2025 10:33:23.4513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ede4c20-af30-4c98-b7f8-08de11566d8b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD74.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8346
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16F988000E
X-Stat-Signature: ptoz6fwutz3aq74suz7h9et4i6trakk3
X-HE-Tag: 1761129209-979828
X-HE-Meta: U2FsdGVkX1+iUCHTi0+tDqA6SuvlUyvwXU6svJTl+DT7a7kmC+EsENZQtdiHoRln4bLgoCi7Uy6CIFQvCDH7Yzww+g6mlm0bnzSqTScLahRJn2/a1WjFJBiLoRapRnWOpS2jefdtz5Y78p1kXrJ+mInPX7N0oDJL6kbK0bHlGYBlWumydgB96hOLrGyG0SEZd8T34zHq+vSEAinwrCEfQfE/3LOnZbl8e629CRpT7HNpmB6ea2jQTk8giKp2XHfYRIK+/V1cDncr0pxYGA9Ozk9td98ZZB3P2g1CYWeinUo4uquQOWGX1GsX0w+199ChjG0u56KWDP697RjY2G+TDgvE17aW7T/lKz1HUY6hv4LY71C/ndAofgX5s9k3OMKDoqoe5Odq1vQkQZiwG/ryVMh7dIjuYZ0wWvZgSOo2js2fwrUacpywFQDslu8dAikR5AC87C+AkC4w6w179vcM7BgQrDw+/C7C5BH6sgKr7xEzwLrk3fKkTiSL6F44+EQpOQvYRn4X4JChPL1BF2ql7vi1iGL8BgTh73VLNG7E5ng9QSLpc8o0TUM21X/nMYoYSgsoWMzMCXoC+esIb0M8xDtdSTtXjcYWKrbcSoa2qs8rWiPtXOacDyca68iToWHXpWw7TDYxYiqr++187u1xJBbDqenO2p1gu6o6ORQfwSJyu0sJRXXxf8D7jxUz8KOwXPhppJQtqQZt51WkBWuwlXz7t2PeVVX3BtuhkFonBX4M1BfAZ7IeADW3cmD5Sl/qN7UC+0vy3gygBtQql3qTZi5Yy9FtC0Tw6vkvXcEzh7jcRyo5HPhoP3I3GTt3pMAy22vHWTbDcRsmjKT4AOcAub1KXf1rcI8YWK2KutmHBTHneYnXXSxqQ9e0EhhrU6FlIexzqEt0V+dck73hGjyBc1/NvblQsPDmrES5zO9wKrzgU1VH4FrOI3fpSMH1kZQ+PiHdcIY2/abRBbibnxy
 Xknhtifd
 VWhoFygLCcjiOzZRpep120eAm6dvtZiA5sbiFB48jWv5uzd+4u3wjIbBo9l4GOuZDSyfy/6Fiknmje8tRp6l397qjBXMiJVS3n4epPdTtUt5AQ2lAScRHSdoy8A6jOsw87TwYOD6ytks6xzhVNPupNvCQWGWYAfysfg1obKVp1+DLEjfGTdcrc7ztfmYuXabhq46CGWG9425DJ3k1if17U5idZ0tEme87KGvlCSH2QvC3wKbJaTvV3n0QqRsFMB4nem8SVFI8MJanQ3P682DvCbwYIa7jpIWhY5XFvfoMXj10SsVhvBBS4yvznJPfYuZTmV8t8PSSsKBiMxggMkJlwSCG5KSjX+ETEpyYNR0ko1PLFVdbqtl/+kCoH6FHhUzclDtM2uNzT3xjAhGzeXDuvT/lHBO8I8D9fl7yZy+Szn9sWqoADiZNSPRb9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function hugetlb_reserve_pages() returns the number of pages added
to the reservation map on success and a negative error code on failure
(e.g. -EINVAL, -ENOMEM). However, in some error paths, it may return -1
directly.

For example, a failure at:

    if (hugetlb_acct_memory(h, gbl_reserve) < 0)
        goto out_put_pages;

results in returning -1 (since add = -1), which may be misinterpreted
in userspace as -EPERM.

Fix this by explicitly capturing and propagating the return values from
helper functions, and using -EINVAL for all other failure cases.

Fixes: 986f5f2b4be3 ("mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated")
Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
---
 mm/hugetlb.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 795ee393eac0..1767f7599f91 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7269,6 +7269,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 	struct resv_map *resv_map;
 	struct hugetlb_cgroup *h_cg = NULL;
 	long gbl_reserve, regions_needed = 0;
+	int ret;
 
 	/* This should never happen */
 	if (from > to) {
@@ -7308,8 +7309,10 @@ long hugetlb_reserve_pages(struct inode *inode,
 	} else {
 		/* Private mapping. */
 		resv_map = resv_map_alloc();
-		if (!resv_map)
+		if (!resv_map) {
+			ret = -EINVAL;
 			goto out_err;
+		}
 
 		chg = to - from;
 
@@ -7317,11 +7320,15 @@ long hugetlb_reserve_pages(struct inode *inode,
 		set_vma_resv_flags(vma, HPAGE_RESV_OWNER);
 	}
 
-	if (chg < 0)
+	if (chg < 0) {
+		ret = -EINVAL;
 		goto out_err;
+	}
 
-	if (hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
-				chg * pages_per_huge_page(h), &h_cg) < 0)
+	ret = hugetlb_cgroup_charge_cgroup_rsvd(hstate_index(h),
+						chg * pages_per_huge_page(h),
+						&h_cg);
+	if (ret < 0)
 		goto out_err;
 
 	if (vma && !(vma->vm_flags & VM_MAYSHARE) && h_cg) {
@@ -7337,14 +7344,17 @@ long hugetlb_reserve_pages(struct inode *inode,
 	 * reservations already in place (gbl_reserve).
 	 */
 	gbl_reserve = hugepage_subpool_get_pages(spool, chg);
-	if (gbl_reserve < 0)
+	if (gbl_reserve < 0) {
+		ret = gbl_reserve;
 		goto out_uncharge_cgroup;
+	}
 
 	/*
 	 * Check enough hugepages are available for the reservation.
 	 * Hand the pages back to the subpool if there are not
 	 */
-	if (hugetlb_acct_memory(h, gbl_reserve) < 0)
+	ret = hugetlb_acct_memory(h, gbl_reserve);
+	if (ret < 0)
 		goto out_put_pages;
 
 	/*
@@ -7363,6 +7373,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
+			ret = -EINVAL;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
 			/*
@@ -7423,7 +7434,7 @@ long hugetlb_reserve_pages(struct inode *inode,
 		kref_put(&resv_map->refs, resv_map_release);
 		set_vma_resv_map(vma, NULL);
 	}
-	return chg < 0 ? chg : add < 0 ? add : -EINVAL;
+	return ret;
 }
 
 long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3B9C2A077
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 07:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1226B0095; Sun,  4 Jan 2026 02:22:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481AA6B0096; Sun,  4 Jan 2026 02:22:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331336B0098; Sun,  4 Jan 2026 02:22:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3336B0095
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 02:22:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCA7BB8761
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:22:31 +0000 (UTC)
X-FDA: 84293438502.15.CD2A372
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013036.outbound.protection.outlook.com [40.107.201.36])
	by imf30.hostedemail.com (Postfix) with ESMTP id E0B5480009
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:22:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MD5gLK2Y;
	spf=pass (imf30.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.201.36 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767511349; a=rsa-sha256;
	cv=pass;
	b=jAS9WRm2hm4qPDFr6HeBqWhtOA+PtKdl3krJCLsdf9uBKza0Pn9ZBYeFMzDX1Ehk9g5UW+
	BSmf7hxZxyxVE5imAKCiv4Pdd5kQ8AaFlxDRMwBaGMya37//y2tv8eUMrTgb16f0UC2svt
	WWsrVkHv1LXDk0vO03ugU1Nu/D7aSR8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=MD5gLK2Y;
	spf=pass (imf30.hostedemail.com: domain of Honglei1.Huang@amd.com designates 40.107.201.36 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767511349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rXaMDrheAHGNdF9ZFuEKN9VXrfImIHpR8PjOgr8/Xo=;
	b=dmtRyA/fEl/sZIFyqkzJroDfQlAfXBMCvMBEr9b7mgQJ1mohRD1hl1BGL7PMrK7/BEGJVF
	owqgSE3mRex9qslCGr7LiLB4/or7OKsdDK8defKpHdJkL0GduWYvCVKoIIuglgGV+/eSTo
	orwo4EUPcCDKCxKqBLRhh+M3b8+UeJI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SJBJzxurDsiUR5pchMMCcD31vrkxV8ulj/uVOEnMN/3jmt71YSJnqPmmBxGLRwfJwYqpJr+gEKpLxSxkuQry2hxYkViWwpODiv6yLHm13dMsEWkLFYDdgcKfnM37bp7jQZILtA7r6wN4RGqp58lj+pINWOq3fteueB/LJZPShSthJXC6AU4v4cb5WfzcrYrnVditwejWwKzS39+PABBTIu8GB8oXgdhfNnzFQFh079Nmf2CpXGZGzezJEmFBRxchZ7tB9TXJljaB0i4VrIWSHdrCltCOrmg8GYD1wpTQ7wHVuU8GD+mzohwbhuFu23q5w7US67yCAiMmI8rFl6QDtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1rXaMDrheAHGNdF9ZFuEKN9VXrfImIHpR8PjOgr8/Xo=;
 b=p+iADNnYeoiVEJgL3jb92hJDJ0j8VRjvumb3L1memJ5UXKaU+GeEx2wygSy9XoOov8avmC0O4LP9PvpbNAASw0UvtJ/SVNSqRANGAfOJ3zm9Y7zBgjc5Q7dFnBfL8yOOEalw61hDq28Jq8dLxrisHu9cDhh7arUg0h5in+ejGMAaRLycOflklnhpYxvBag18q5XGinlWD+sQ4fY+6n9mgKiFU/Hur+DDBte0qudNog7W+pn9ZOoiso90kYKRZr9gaFs90en1lzghH2JCy4EuSH51EpI1sR+RSJrlHy2YbD2QL0jc89zpZlD+7hNdeJPlGf/v/ivXzTNX55JTiWvw2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=collabora.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rXaMDrheAHGNdF9ZFuEKN9VXrfImIHpR8PjOgr8/Xo=;
 b=MD5gLK2YtZw4nWr2HxbsL1MubDEK76f2Ci5CeyLozSoTN2q4rF5omTKk8MFC4Hnp8PpqKfHMU7JBhTMaY2MnoNGT6XjUVMgcMqYq9wceLNpVhQrQgWVIMlh4u22yJSSAZbJxVue9LN4Y2cPU5/n82zb8s3aBe/TD6C23gcjDKzY=
Received: from MN2PR16CA0040.namprd16.prod.outlook.com (2603:10b6:208:234::9)
 by MN0PR12MB5714.namprd12.prod.outlook.com (2603:10b6:208:371::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Sun, 4 Jan
 2026 07:22:22 +0000
Received: from BN3PEPF0000B36D.namprd21.prod.outlook.com
 (2603:10b6:208:234:cafe::7b) by MN2PR16CA0040.outlook.office365.com
 (2603:10b6:208:234::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Sun, 4
 Jan 2026 07:22:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36D.mail.protection.outlook.com (10.167.243.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.0 via Frontend Transport; Sun, 4 Jan 2026 07:22:22 +0000
Received: from honglei-remote.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 4 Jan
 2026 01:22:19 -0600
From: Honglei Huang <honglei1.huang@amd.com>
To: <Felix.Kuehling@amd.com>, <alexander.deucher@amd.com>,
	<christian.koenig@amd.com>, <Ray.Huang@amd.com>
CC: <dmitry.osipenko@collabora.com>, <Xinhui.Pan@amd.com>,
	<airlied@gmail.com>, <daniel@ffwll.ch>, <amd-gfx@lists.freedesktop.org>,
	<dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <akpm@linux-foundation.org>, <honghuan@amd.com>
Subject: [PATCH v2 3/4] drm/amdkfd: Implement batch userptr allocation and management
Date: Sun, 4 Jan 2026 15:21:21 +0800
Message-ID: <20260104072122.3045656-4-honglei1.huang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260104072122.3045656-1-honglei1.huang@amd.com>
References: <20260104072122.3045656-1-honglei1.huang@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36D:EE_|MN0PR12MB5714:EE_
X-MS-Office365-Filtering-Correlation-Id: dbdafc04-a411-4df0-4be4-08de4b6200e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JdC2bDb4TNfdQE47d186U5Mgz23WVA9mE7C1+PA4hQgL45l9d7dh7Yunja7J?=
 =?us-ascii?Q?NtA/ckxmg9I+Sp+N2xNVz8b3uhSEmCAAAuIQwEhMsw2RZJ0iAlbBSYMqZ0p0?=
 =?us-ascii?Q?FWpK1IRNMPMTW3YohRSjsLemNJDF6UMBkZonVpOFXVQ3CiO7wU+roPqX3+P4?=
 =?us-ascii?Q?7k7DgT0XGPZLFzNclsANIf51d3l7EnqFeL4HhjrIZi8fvltexLLUK+CQ9Z32?=
 =?us-ascii?Q?pXYQ1HNeRnkuXgaUpEZ6EAu8iEWvNMkOmUK9gCnhSfJRyIAlHH/Ppug+WuLQ?=
 =?us-ascii?Q?IE8kRt4vPu9HDpLh5g9Zkr+YCx/6B0vzP6tCgPI62h42ap1ivNaADDyjFNkV?=
 =?us-ascii?Q?EsvBgQ74ZedYV06Lym/IMCua6jDZBkl2DuFCNf7nzrnNO6XmoB6CjsXMJrBW?=
 =?us-ascii?Q?0C18dvksgXe14aa40VVz6HDg1TCAyBAssQyTIdAWTNTES5mfyk2GYFD84eru?=
 =?us-ascii?Q?VQo01Zfg0vnUJnrydPZGhehzdHznrkg/cZDO8rwWPPKz0xyTTYomGqK7E6Yz?=
 =?us-ascii?Q?6q61ARVIv0Nz6cbyKC2hYYsIM2n4aIZeT7yp5XZzxRzTn4YnGHo8Qkd+szdc?=
 =?us-ascii?Q?Ne/6skoFptLkd+G7t7bdPLUIsrPQerwwZyMLdGk0d/vdE0SLpweNgc1VTUYD?=
 =?us-ascii?Q?mOQFXPItBjMHpZEgYuhxyrHobFxGMeYArhI/hQhkdfWTJUk2zBqzOhki31HF?=
 =?us-ascii?Q?/W8YBc4CMRwnrk7olGT7o/TskZNZ7qV+xkcXAvg+9zUGq9/rUNs8qJdPfbMY?=
 =?us-ascii?Q?fdu+ECrXQGcNYRxcmzO3c80DQc+zJZpgvwEH9fa5F1FmZ3jR4a9UZLkjT0Km?=
 =?us-ascii?Q?qQdcxKHXD+8EOdb0AKT9hk14Hfi/1cP/7B3Pc71xWzD7apRyetnI3VBYhKN3?=
 =?us-ascii?Q?zZVOlbKOpzOmp0lXTaCQwGz4PkyXjBbr8ldgVfFdmC46CyE3PFHFhwGEM9E4?=
 =?us-ascii?Q?CcWgbJV7Mw5CSJGHEM2yDyIVWOTyeZ+NTYC9X9smTlmCFWHyLc8vvnP1R7uf?=
 =?us-ascii?Q?WPfIKoh5m+4bADTRrSAjuZscMFdTyDGcbuWGoA5IKAOzUYR2AM/XJddRcbnP?=
 =?us-ascii?Q?wfKvjQLcGpLTuvMtW36yrElwCfqqJGFDt7TSG6wNcJhAI918oor7u8pDeYET?=
 =?us-ascii?Q?q4tHYJ/wafUdkixs85D0PW18f1QOAA2yi3GsDLvygdSQ37QAkvgmPYY1rlpT?=
 =?us-ascii?Q?1ef3u45k+q3umGLBZi/sFR5uiNJyyacPaKk7FhZBTQqS8PQ0X21JKRT2hpfx?=
 =?us-ascii?Q?lqo6dO32CaUgw6aJQhxpEgAQeCpsozEDosM1h+L4eZEWGargyJOuF6Bg9WFv?=
 =?us-ascii?Q?tccJpGpMAYyOG5RB9RS7AVfGnRvfAa1QepQ1ACTUF2KhaznA/VbOGVHUkFY3?=
 =?us-ascii?Q?Y8jFpABVD2ZIZfYLGF3RhPDkvh8aEjRCGh/YJpl9iFI3xhXv10uxseas+Gb9?=
 =?us-ascii?Q?I0Ch1lBNjCORQDRNA6LMjEdcQy+kCf4Ds2jw9jdixvZwpFEX4ZcYIMjDemAc?=
 =?us-ascii?Q?VtfNAEsSQCHhBaLXVkUIbXPjDyjMGsBqOMuZnHzt+3FxzXs8pRLftDC/zy94?=
 =?us-ascii?Q?eIkPZpUHAAN39VZXfPY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2026 07:22:22.6660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbdafc04-a411-4df0-4be4-08de4b6200e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5714
X-Rspam-User: 
X-Rspamd-Queue-Id: E0B5480009
X-Rspamd-Server: rspam04
X-Stat-Signature: r9a8mg7o5c8bw5a788848tag79k86we1
X-HE-Tag: 1767511348-958449
X-HE-Meta: U2FsdGVkX18VKtDCbtmVBk/uV/c0nCwmJ4llpjeYnfsuKXLmFbYVzvq7Z7DzbZPB8Yw1WfR5Z2+7BIy01nyRBrGb0eIf7n78DlwH7Ohx193uP/Amsu+HOx7rOrInfuGnqDKAD5WbDlYT7yRjs4MrylzbbYu4SJFq3FlJH9x++LKIVEvB1VYrg8QlntlSAMyrTyh25kP9+aeK636dEQ2nMjM//Iia+XsO8K+cyYDOuoBgUuMHsNsPPeK6IJ/qYBSqxIVTcQN4Ok/VWy57SEpVR9YBt6tqWtW9oxFM+g7gnAOGsHpXNGaS6DyDDx49LVW83GlgwlcaCA4JTGe5s5Tuj+1/hkb/TkmdwXyO+1kkb8Cbq7wJPP/m/Uudk/+a0uxG4HV5Tmn0CP8ZoKLkbTbbw+QNvaZQLvMHlORFa27jIsQvcGYt76eH+swa39DGYX2y6gnsliCY2YPnV6LY2TNfa5n5sm291esOqtpTT8H6KDy+gX6NRotCFyz1BdlCvuTb/xOvzNkegZHuApUnplfpjlfogvKJ/bzUDsr8LkmHgf70gJchCOfla3D2k8mYgwWN7ksVLiYgHI/Zf3FLsibuA4u/pAVua2yWfMnV9btJHaUUOhlMfeZKh3/FXVqfdjmHitvU8dex8+gKfeBIUTQjEUjISOxvhOBlaqTpn5wjpl64E5w9XkcQkWgbR7P8vwTvz0KPv6cX1kBRNO5jNc6JV5yiL/mwK1yXt438SKGR44auDF/D4OxZSWEO6R4VFW+8DpNOjfRfaZrqW07gIN5T36G6t7psXsmcQY/YC/Jxm0VqmWFVmFbaFNQkBbxA6R+t+SF7u0MyrM37A1KdJDWFGzNZtOG+4j+PKKmf6ae4VUBJwX26jnxxkZNcVz5CSIGFGPkFS8xaqAqldu7cwRlLXxvWBFoSqo14BvWtAZslJAsYKQ/sGVioZN4FpfAyuFoASokZd8DsVsbr4SHuQyn
 fLd6AY07
 +v0FXMReQFqaKnUOzLt2kaYY9M3in/JPveY3K+1/0s+zaz8gK5A/Bvf22Lt4GQnV00bqPXsZw0DkuXgJudKlFq1aizy6yio4KdU1ajjWTjArFqukvc2J2IvQCo498BgrUQkfWduuGlbwD3pK+ipccjtwScq5h5kwoYKRydRLGj4mh9DkNSBabGHXwUry1qtl+ffyzRZAB1tGBpFZxkbN/2zLHCOuxgglxIWQb4pSwWngkygbx/kkFqdzy5bqIOmenpWyO3ExuEk4+rEpwBqHikz/ZzhDf7A2Gb7JErIZY48a6y9EkohDfpTp4APsUa8PLIPQTmNmkjs5sZkqUPwnWghPBM7PG7Y5Le/eLmWu9jdtwfnqGrTVjoJXR+FxC03CcvtdUchvC4q61b/QzdMnIif85xN439SY0Z1y4ZjsASJnnplREID8bHaxNy4NiBcxBwc9a+QU8k57EYTI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Honglei Huang <honghuan@amd.com>

Implement the core functionality for batch userptr allocation including:

1. HMM range management and MMU notifiers for multiple ranges
2. Per-range eviction and invalidation tracking
3. Batch allocation function amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch()
4. Helper functions for batch page operations
5. Support for eviction and restore of batch userptr allocations
6. Unified cleanup path for both single and batch userptr

Each range in a batch allocation gets its own HMM notifier and
invalidation tracking, while all ranges are validated together and
mapped to a contiguous GPU virtual address space.

Signed-off-by: Honglei Huang <honghuan@amd.com>
---
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 543 +++++++++++++++++-
 1 file changed, 524 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index a32b46355..67a6519dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1122,6 +1122,256 @@ static int init_user_pages(struct kgd_mem *mem, uint64_t user_addr,
 	return ret;
 }
 
+/* Evict a single range from batch userptr BO
+ *
+ * Called when one of the non-contiguous VA ranges is invalidated.
+ * Similar to amdgpu_amdkfd_evict_userptr but for individual ranges.
+ */
+static int amdgpu_amdkfd_evict_userptr_range(struct mmu_interval_notifier *mni,
+				  const struct mmu_notifier_range *range,
+				  unsigned long cur_seq)
+{
+	struct user_range_info *range_info;
+	struct kgd_mem *mem;
+	struct amdkfd_process_info *process_info;
+	int r = 0;
+
+	range_info = container_of(mni, struct user_range_info, notifier);
+	mem = range_info->mem;
+	process_info = mem->process_info;
+
+	if (READ_ONCE(process_info->block_mmu_notifications))
+		return 0;
+
+	mutex_lock(&process_info->notifier_lock);
+	mmu_interval_set_seq(mni, cur_seq);
+
+	range_info->invalid++;
+	mem->invalid++;
+	
+	if (++process_info->evicted_bos == 1) {
+		r = kgd2kfd_quiesce_mm(mni->mm,
+				       KFD_QUEUE_EVICTION_TRIGGER_USERPTR);
+
+		if (r && r != -ESRCH)
+			pr_err("Failed to quiesce KFD\n");
+
+		if (r != -ESRCH)
+			queue_delayed_work(system_freezable_wq,
+				&process_info->restore_userptr_work,
+				msecs_to_jiffies(AMDGPU_USERPTR_RESTORE_DELAY_MS));
+	}
+	mutex_unlock(&process_info->notifier_lock);
+
+	pr_debug("Batch userptr range evicted: range %d, addr 0x%llx, size 0x%llx\n",
+		 (int)(range_info - mem->user_ranges), range_info->start, range_info->size);
+
+	return r;
+}
+
+static bool amdgpu_amdkfd_invalidate_userptr_range(struct mmu_interval_notifier *mni,
+						    const struct mmu_notifier_range *range,
+						    unsigned long cur_seq)
+{
+	amdgpu_amdkfd_evict_userptr_range(mni, range, cur_seq);
+	return true;
+}
+
+static const struct mmu_interval_notifier_ops amdgpu_amdkfd_hsa_range_ops = {
+	.invalidate = amdgpu_amdkfd_invalidate_userptr_range,
+};
+
+static int get_user_pages_batch(struct mm_struct *mm,
+				struct user_range_info *range,
+				struct hmm_range **range_hmm, bool readonly)
+{
+	struct vm_area_struct *vma;
+	int r = 0;
+
+	*range_hmm = NULL;
+
+	if (!mmget_not_zero(mm))
+		return -ESRCH;
+
+	mmap_read_lock(mm);
+	vma = vma_lookup(mm, range->start);
+	if (unlikely(!vma)) {
+		r = -EFAULT;
+		goto out_unlock;
+	}
+
+	r = amdgpu_hmm_range_get_pages(&range->notifier, range->start,
+				       range->size >> PAGE_SHIFT, readonly,
+				       NULL, range_hmm);
+
+out_unlock:
+	mmap_read_unlock(mm);
+	mmput(mm);
+	return r;
+}
+
+static int set_user_pages_batch(struct ttm_tt *ttm,
+				struct user_range_info *ranges,
+				uint32_t nranges)
+{
+	uint32_t i, j, k = 0, range_npfns;
+
+	for (i = 0; i < nranges; ++i) {
+		if (!ranges[i].range || !ranges[i].range->hmm_pfns)
+			return -EINVAL;
+
+		range_npfns = (ranges[i].range->end - ranges[i].range->start) >>
+			      PAGE_SHIFT;
+
+		if (k + range_npfns > ttm->num_pages)
+			return -EOVERFLOW;
+
+		for (j = 0; j < range_npfns; ++j)
+			ttm->pages[k++] =
+				hmm_pfn_to_page(ranges[i].range->hmm_pfns[j]);
+	}
+
+	return 0;
+}
+
+/* Initialize batch of non-contiguous userptr ranges.
+ * Each range gets its own HMM notifier and page tracking.
+ * All ranges will be validated together and mapped to a contiguous GPU VA.
+ *
+ * Similar to init_user_pages but handles multiple ranges.
+ * Returns 0 for success, negative errno for errors.
+ */
+static int init_user_pages_batch(struct kgd_mem *mem,
+				 struct kfd_ioctl_userptr_range *ranges,
+				 uint32_t num_ranges, bool criu_resume,
+				 uint64_t user_addr, uint32_t size)
+{
+	struct amdkfd_process_info *process_info = mem->process_info;
+	struct amdgpu_bo *bo = mem->bo;
+	struct ttm_operation_ctx ctx = { true, false };
+	struct hmm_range *range;
+	int ret = 0;
+	uint32_t i;
+
+	if (!num_ranges || !ranges)
+		return -EINVAL;
+
+	mutex_lock(&process_info->lock);
+
+	mem->user_ranges = kvcalloc(num_ranges, sizeof(struct user_range_info), 
+				    GFP_KERNEL);
+
+	if (!mem->user_ranges) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	mem->num_user_ranges = num_ranges;
+
+	ret = amdgpu_ttm_tt_set_userptr(&bo->tbo, user_addr, 0);
+	if (ret) {
+		pr_err("%s: Failed to set userptr: %d\n", __func__, ret);
+		goto out;
+	}
+
+	/* Process each range: register HMM and get pages */
+	for (i = 0; i < num_ranges; i++) {
+		mem->user_ranges[i].start = ranges[i].start;
+		mem->user_ranges[i].size = ranges[i].size;
+
+		pr_debug("Initializing userptr range %u: addr=0x%llx size=0x%llx\n",
+			 i, mem->user_ranges[i].start, mem->user_ranges[i].size);
+
+		mem->user_ranges[i].mem = mem;
+
+		ret = mmu_interval_notifier_insert(&mem->user_ranges[i].notifier,
+						   current->mm, mem->user_ranges[i].start, mem->user_ranges[i].size,
+						   &amdgpu_amdkfd_hsa_range_ops);
+		if (ret) {
+			pr_err("%s: Failed to register range MMU notifier for range %u: %d\n",
+			       __func__, i, ret);
+			while (i > 0) {
+				i--;
+				if (mem->user_ranges[i].notifier.mm) {
+					mmu_interval_notifier_remove(
+						&mem->user_ranges[i].notifier);
+					mem->user_ranges[i].notifier.mm = NULL;
+				}
+			}
+			goto err_cleanup_ranges;
+		}
+
+		if (criu_resume) {
+			mutex_lock(&process_info->notifier_lock);
+			mem->user_ranges[i].invalid++;
+			mutex_unlock(&process_info->notifier_lock);
+			continue;
+		}
+
+		ret = get_user_pages_batch(
+			current->mm, &mem->user_ranges[i], &range,
+			amdgpu_ttm_tt_is_readonly(bo->tbo.ttm));
+		if (ret) {
+			if (ret == -EAGAIN)
+				pr_debug("Failed to get user pages for range %u, try again\n", i);
+			else
+				pr_err("%s: Failed to get user pages for range %u: %d\n",
+				       __func__, i, ret);
+			goto err_unregister;
+		}
+
+		mem->user_ranges[i].range = range;
+	}
+
+	if (criu_resume) {
+		mutex_unlock(&process_info->lock);
+		return 0;
+	}
+
+	ret = amdgpu_bo_reserve(bo, true);
+	if (ret) {
+		pr_err("%s: Failed to reserve BO\n", __func__);
+		goto release_pages;
+	}
+
+	if (bo->tbo.ttm->pages) {
+		set_user_pages_batch(bo->tbo.ttm,
+						     mem->user_ranges,
+						     num_ranges);
+	} else {
+		pr_err("%s: TTM pages array is NULL\n", __func__);
+		ret = -EINVAL;
+		amdgpu_bo_unreserve(bo);
+		goto release_pages;
+	}
+
+	amdgpu_bo_placement_from_domain(bo, mem->domain);
+	ret = ttm_bo_validate(&bo->tbo, &bo->placement, &ctx);
+	if (ret)
+		pr_err("%s: failed to validate BO\n", __func__);
+	
+	amdgpu_bo_unreserve(bo);
+
+release_pages:
+	for (i = 0; i < num_ranges; i++) {
+		if (mem->user_ranges[i].range) {
+			amdgpu_ttm_tt_get_user_pages_done(bo->tbo.ttm, 
+							  mem->user_ranges[i].range);
+		}
+	}
+
+err_unregister:
+err_cleanup_ranges:
+	if (ret) {
+		for (i = 0; i < num_ranges; i++) {
+			mem->user_ranges[i].range = NULL;
+		}
+	}
+
+out:
+	mutex_unlock(&process_info->lock);
+	return ret;
+}
+
 /* Reserving a BO and its page table BOs must happen atomically to
  * avoid deadlocks. Some operations update multiple VMs at once. Track
  * all the reservation info in a context structure. Optionally a sync
@@ -1880,6 +2130,177 @@ int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu(
 	return ret;
 }
 
+/* Allocate memory for batch of non-contiguous userptr ranges.
+ * All ranges will be mapped to a single contiguous GPU VA.
+ *
+ * @adev: amdgpu device pointer
+ * @va: contiguous GPU virtual address for mapping
+ * @size: total size (sum of all range sizes)
+ * @drm_priv: drm private data
+ * @mem: resulting kgd_mem pointer
+ * @offset: not used for batch userptr
+ * @ranges: array of userptr ranges
+ * @num_ranges: number of ranges
+ * @flags: allocation flags (must include KFD_IOC_ALLOC_MEM_FLAGS_USERPTR)
+ * @criu_resume: whether this is for CRIU restore
+ */
+int amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch(
+	struct amdgpu_device *adev, uint64_t va, uint64_t size, void *drm_priv,
+	struct kgd_mem **mem, uint64_t *offset,
+	struct kfd_ioctl_userptr_range *ranges, uint32_t num_ranges,
+	uint32_t flags, bool criu_resume)
+{
+	struct amdgpu_vm *avm = drm_priv_to_vm(drm_priv);
+	struct amdgpu_bo *bo;
+	struct drm_gem_object *gobj = NULL;
+	u32 domain, alloc_domain;
+	uint64_t aligned_size;
+	int8_t xcp_id = -1;
+	u64 alloc_flags;
+	int ret;
+
+	if (!(flags & KFD_IOC_ALLOC_MEM_FLAGS_USERPTR)) {
+		pr_err("Batch allocation requires USERPTR flag\n");
+		return -EINVAL;
+	}
+
+	/* Batch userptr does not support AQL queue */
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_AQL_QUEUE_MEM) {
+		pr_err("Batch userptr does not support AQL queue\n");
+		return -EINVAL;
+	}
+
+	domain = AMDGPU_GEM_DOMAIN_GTT;
+	alloc_domain = AMDGPU_GEM_DOMAIN_CPU;
+	alloc_flags = AMDGPU_GEM_CREATE_PREEMPTIBLE;
+
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_COHERENT)
+		alloc_flags |= AMDGPU_GEM_CREATE_COHERENT;
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_EXT_COHERENT)
+		alloc_flags |= AMDGPU_GEM_CREATE_EXT_COHERENT;
+	if (flags & KFD_IOC_ALLOC_MEM_FLAGS_UNCACHED)
+		alloc_flags |= AMDGPU_GEM_CREATE_UNCACHED;
+
+	*mem = kzalloc(sizeof(struct kgd_mem), GFP_KERNEL);
+	if (!*mem) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	INIT_LIST_HEAD(&(*mem)->attachments);
+	mutex_init(&(*mem)->lock);
+	(*mem)->aql_queue = false;
+
+	aligned_size = PAGE_ALIGN(size);
+
+	(*mem)->alloc_flags = flags;
+
+	amdgpu_sync_create(&(*mem)->sync);
+
+	ret = amdgpu_amdkfd_reserve_mem_limit(adev, aligned_size, flags,
+					      xcp_id);
+	if (ret) {
+		pr_debug("Insufficient memory\n");
+		goto err_reserve_limit;
+	}
+
+	pr_debug("\tcreate BO VA 0x%llx size 0x%llx for batch userptr (ranges=%u)\n",
+		 va, size, num_ranges);
+
+	ret = amdgpu_gem_object_create(adev, aligned_size, 1, alloc_domain, alloc_flags,
+				       ttm_bo_type_device, NULL, &gobj, xcp_id + 1);
+	if (ret) {
+		pr_debug("Failed to create BO on domain %s. ret %d\n",
+			 domain_string(alloc_domain), ret);
+		goto err_bo_create;
+	}
+
+	ret = drm_vma_node_allow(&gobj->vma_node, drm_priv);
+	if (ret) {
+		pr_debug("Failed to allow vma node access. ret %d\n", ret);
+		goto err_node_allow;
+	}
+
+	ret = drm_gem_handle_create(adev->kfd.client.file, gobj, &(*mem)->gem_handle);
+	if (ret)
+		goto err_gem_handle_create;
+
+	bo = gem_to_amdgpu_bo(gobj);
+	bo->kfd_bo = *mem;
+	bo->flags |= AMDGPU_AMDKFD_CREATE_USERPTR_BO;
+
+	(*mem)->bo = bo;
+	(*mem)->va = va;
+	(*mem)->domain = domain;
+	(*mem)->mapped_to_gpu_memory = 0;
+	(*mem)->process_info = avm->process_info;
+
+	add_kgd_mem_to_kfd_bo_list(*mem, avm->process_info, ranges[0].start);
+
+	pr_debug("Initializing batch userptr with %u ranges\n", num_ranges);
+	ret = init_user_pages_batch(*mem, ranges, num_ranges, criu_resume, va, aligned_size);
+	if (ret) {
+		pr_err("Failed to initialize batch user pages: %d\n", ret);
+		goto allocate_init_user_pages_failed;
+	}
+
+	return 0;
+
+allocate_init_user_pages_failed:
+	remove_kgd_mem_from_kfd_bo_list(*mem, avm->process_info);
+	drm_gem_handle_delete(adev->kfd.client.file, (*mem)->gem_handle);
+err_gem_handle_create:
+	drm_vma_node_revoke(&gobj->vma_node, drm_priv);
+err_node_allow:
+	/* Don't unreserve system mem limit twice */
+	goto err_reserve_limit;
+err_bo_create:
+	amdgpu_amdkfd_unreserve_mem_limit(adev, aligned_size, flags, xcp_id);
+err_reserve_limit:
+	amdgpu_sync_free(&(*mem)->sync);
+	mutex_destroy(&(*mem)->lock);
+	if (gobj)
+		drm_gem_object_put(gobj);
+	else
+		kfree(*mem);
+err:
+	return ret;
+}
+
+/* Cleanup userptr resources during BO free
+ *
+ * Handles both single and batch userptr: unregisters MMU notifiers,
+ * discards user pages, and frees userptr-related structures.
+ */
+static void cleanup_userptr_resources(struct kgd_mem *mem,
+				      struct amdkfd_process_info *process_info)
+{
+	if (!amdgpu_ttm_tt_get_usermm(mem->bo->tbo.ttm))
+		return;
+
+	if (mem->num_user_ranges > 0 && mem->user_ranges) {
+		/* Batch userptr: cleanup all ranges */
+		uint32_t i;
+
+		for (i = 0; i < mem->num_user_ranges; i++) {
+			if (mem->user_ranges[i].notifier.mm) {
+				mmu_interval_notifier_remove(
+					&mem->user_ranges[i].notifier);
+				mem->user_ranges[i].notifier.mm = NULL;
+			}
+		}
+
+		kvfree(mem->user_ranges);
+		mem->user_ranges = NULL;
+		mem->num_user_ranges = 0;
+	} else {
+		/* Single userptr: cleanup single range */
+		amdgpu_hmm_unregister(mem->bo);
+		mutex_lock(&process_info->notifier_lock);
+		amdgpu_ttm_tt_discard_user_pages(mem->bo->tbo.ttm, mem->range);
+		mutex_unlock(&process_info->notifier_lock);
+	}
+}
+
 int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 		struct amdgpu_device *adev, struct kgd_mem *mem, void *drm_priv,
 		uint64_t *size)
@@ -1920,13 +2341,8 @@ int amdgpu_amdkfd_gpuvm_free_memory_of_gpu(
 	list_del(&mem->validate_list);
 	mutex_unlock(&process_info->lock);
 
-	/* Cleanup user pages and MMU notifiers */
-	if (amdgpu_ttm_tt_get_usermm(mem->bo->tbo.ttm)) {
-		amdgpu_hmm_unregister(mem->bo);
-		mutex_lock(&process_info->notifier_lock);
-		amdgpu_ttm_tt_discard_user_pages(mem->bo->tbo.ttm, mem->range);
-		mutex_unlock(&process_info->notifier_lock);
-	}
+	/* Cleanup userptr resources */
+	cleanup_userptr_resources(mem, process_info);
 
 	ret = reserve_bo_and_cond_vms(mem, NULL, BO_VM_ALL, &ctx);
 	if (unlikely(ret))
@@ -2513,6 +2929,50 @@ int amdgpu_amdkfd_evict_userptr(struct mmu_interval_notifier *mni,
 	return r;
 }
 
+static void discard_user_pages_batch(struct amdgpu_bo *bo, struct kgd_mem *mem)
+{
+	uint32_t i;
+
+	for (i = 0; i < mem->num_user_ranges; i++) {
+		if (mem->user_ranges[i].range) {
+			amdgpu_ttm_tt_discard_user_pages(bo->tbo.ttm,
+							 mem->user_ranges[i].range);
+			mem->user_ranges[i].range = NULL;
+		}
+	}
+}
+
+static int amdgpu_amdkfd_update_user_pages_batch(struct mm_struct *mm,
+						 struct amdgpu_bo *bo,
+						 struct kgd_mem *mem)
+{
+	uint32_t i;
+	int ret = 0;
+	bool all_success = true;
+
+	for (i = 0; i < mem->num_user_ranges; i++) {
+		if (!mem->user_ranges[i].invalid)
+			continue;
+
+		ret = get_user_pages_batch(
+			mm, &mem->user_ranges[i],
+			&mem->user_ranges[i].range,
+			amdgpu_ttm_tt_is_readonly(bo->tbo.ttm));
+		if (ret) {
+			pr_debug("Failed %d to get user pages for range %u\n",
+				 ret, i);
+			all_success = false;
+			break;
+		}
+		mem->user_ranges[i].invalid = 0;
+	}
+
+	if (!all_success)
+		ret = ret ? ret : -EFAULT;
+
+	return ret;
+}
+
 /* Update invalid userptr BOs
  *
  * Moves invalidated (evicted) userptr BOs from userptr_valid_list to
@@ -2550,8 +3010,13 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
 
 		bo = mem->bo;
 
-		amdgpu_ttm_tt_discard_user_pages(bo->tbo.ttm, mem->range);
-		mem->range = NULL;
+		/* Discard old user pages */
+		if (mem->num_user_ranges > 0 && mem->user_ranges)
+			discard_user_pages_batch(bo, mem);
+		else {
+			amdgpu_ttm_tt_discard_user_pages(bo->tbo.ttm, mem->range);
+			mem->range = NULL;
+		}
 
 		/* BO reservations and getting user pages (hmm_range_fault)
 		 * must happen outside the notifier lock
@@ -2574,8 +3039,11 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
 			}
 		}
 
-		/* Get updated user pages */
-		ret = amdgpu_ttm_tt_get_user_pages(bo, &mem->range);
+		if (mem->num_user_ranges > 0 && mem->user_ranges)
+			ret = amdgpu_amdkfd_update_user_pages_batch(mm, bo, mem);
+		else
+			ret = amdgpu_ttm_tt_get_user_pages(bo, &mem->range);
+
 		if (ret) {
 			pr_debug("Failed %d to get user pages\n", ret);
 
@@ -2609,7 +3077,10 @@ static int update_invalid_user_pages(struct amdkfd_process_info *process_info,
 			ret = 0;
 		}
 
-		amdgpu_ttm_tt_set_user_pages(bo->tbo.ttm, mem->range);
+		if (mem->num_user_ranges == 0)
+			amdgpu_ttm_tt_set_user_pages(bo->tbo.ttm, mem->range);
+		else
+			set_user_pages_batch(bo->tbo.ttm, mem->user_ranges, mem->num_user_ranges);
 
 		mutex_lock(&process_info->notifier_lock);
 
@@ -2730,6 +3201,34 @@ static int validate_invalid_user_pages(struct amdkfd_process_info *process_info)
 	return ret;
 }
 
+/* Confirm that batch userptr ranges are valid
+ *
+ * Checks all ranges in a batch userptr BO and releases hmm_range structures.
+ * Returns true if all ranges are valid, false otherwise.
+ */
+static bool valid_user_pages_batch(struct kgd_mem *mem)
+{
+	uint32_t i;
+	bool all_valid = true;
+
+	if (!mem->user_ranges || mem->num_user_ranges == 0)
+		return true;
+
+	for (i = 0; i < mem->num_user_ranges; i++) {
+		if (!mem->user_ranges[i].range)
+			continue;
+
+		if (!amdgpu_ttm_tt_get_user_pages_done(mem->bo->tbo.ttm,
+							mem->user_ranges[i].range)) {
+			all_valid = false;
+		}
+
+		mem->user_ranges[i].range = NULL;
+	}
+
+	return all_valid;
+}
+
 /* Confirm that all user pages are valid while holding the notifier lock
  *
  * Moves valid BOs from the userptr_inval_list back to userptr_val_list.
@@ -2744,15 +3243,21 @@ static int confirm_valid_user_pages_locked(struct amdkfd_process_info *process_i
 				 validate_list) {
 		bool valid;
 
-		/* keep mem without hmm range at userptr_inval_list */
-		if (!mem->range)
-			continue;
+		/* Handle batch userptr: check all ranges */
+		if (mem->num_user_ranges > 0 && mem->user_ranges)
+			valid = valid_user_pages_batch(mem);
+		else {
+			/* keep mem without hmm range at userptr_inval_list */
+			if (!mem->range)
+				continue;
 
-		/* Only check mem with hmm range associated */
-		valid = amdgpu_ttm_tt_get_user_pages_done(
-					mem->bo->tbo.ttm, mem->range);
+			/* Only check mem with hmm range associated */
+			valid = amdgpu_ttm_tt_get_user_pages_done(
+						mem->bo->tbo.ttm, mem->range);
+
+			mem->range = NULL;
+		}
 
-		mem->range = NULL;
 		if (!valid) {
 			WARN(!mem->invalid, "Invalid BO not marked invalid");
 			ret = -EAGAIN;
-- 
2.34.1



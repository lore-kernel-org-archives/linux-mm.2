Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AA3C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A308E001E; Mon, 11 Aug 2025 05:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111CB8E000A; Mon, 11 Aug 2025 05:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4828E001E; Mon, 11 Aug 2025 05:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD62C8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:09:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81CC7135915
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:09:31 +0000 (UTC)
X-FDA: 83763903342.19.76CF790
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2082.outbound.protection.outlook.com [40.107.237.82])
	by imf11.hostedemail.com (Postfix) with ESMTP id AC5654000D
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:09:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0ZS+X1YM;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 40.107.237.82 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754903368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W45yesxpn18HlaHWc18OlVJMhy1GtzgV9/IHBn3sx+I=;
	b=zGtJpgo1y/y9y6HzP4ZKQ72JBeIYvFXWO/LmrGpIL5Xz1R8ZJKNMKFrJ23UHD0Wi6qj1qY
	J+4jzLox5uc+7ZMF+tovry926zB7ZSZvJPsWilL+cj+nkQzpGqFuF3rzdY33DTFpoA9Wuo
	NQgQanurzx1iBQmi/3nI+Op0AkH086g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754903368; a=rsa-sha256;
	cv=pass;
	b=MuSrO1diEpG6EmsuECd0Cw95HWP+8aoudKAgqx0AECkWCR5xVFlK5U2UQyRx4wEZqjlNVM
	T7Yh61I2eutruuvG36Rbwfyllxi33ziqLy0g7xC6PT+HZj/cwX6av2pouuBGRN+piqracx
	ekmBI2rVqYLG/LfDhS01+HnyDb7zPJ8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=0ZS+X1YM;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf11.hostedemail.com: domain of shivankg@amd.com designates 40.107.237.82 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l2AGc9vl4RzRMsb2px5t8MjzPbm4uDrqno3/HYmJGz+kDG9InJCjQgQqTeBsmqTLnLYcWNjQkBEyIBAJaX7aspZ0k9er+V6lmq0cJUjo3zC2eNm7ROBrWJ4J4KCFTUuo8y334y39BrTTBm3PXR1TB4nCAvWVVOVXWzObSugJ+8YpFGriIloFKZh2KTs1+vkCcjZ54Ay1GB4LUO/vOYxiD0z70SKss+79Hzh1PW6AEXcMNUUcmtxBX3xbLlI7AxsAy5+129hXuctXrlif/TCCFjMSl9tHKvY/nc8csjeVTbJS6MaU0eF0XHmYwXly+IBA5nk51+E9is/qCeX//chocg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W45yesxpn18HlaHWc18OlVJMhy1GtzgV9/IHBn3sx+I=;
 b=O5eQRPpSRw2x3p8w0GgcPBC06Pphd5Ggpa0EBc8m7vmbBhk3wCUHaEBmesWpee72SNjK6bAUKwud3JM0fAJX66QJSb7RjPBj3JlmAZXu3SdQoFSgXR9u15K3CvwMlghnL8DP9G3NW0+3xW8vpUQ0XQ3wVsDgLvYrLz5hTqVvsuF7GVakFP7iWDTAssV3nMBZF0FwY+Dzn+4gKzBwRDOF6RiI1iOwnnP9NfryTdSnpmRszHtDyQHkwuBuicfOIpZjF3fOjdfkMWL0JqsOZNOVbyY0FgUzwP+od2dMboXIBoVSquXve8aNOWjkgRtqKjIBLsY7MBRolEpp/rLPsRJ/9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W45yesxpn18HlaHWc18OlVJMhy1GtzgV9/IHBn3sx+I=;
 b=0ZS+X1YMP5xHLDTZTm+68FONhNTuOX8hKli2jAMdBocKwfawfBRCrIiH/aGrQ+2z+8NOxdEnqiMyI9+M0VKDe9suE0J5xpyZz3p+zAz6ePZbtpOkiBr0qjXtrhwEXhpVUHU/1C3L9SgETTyCslq6VPBc85mIUwwD9Vxn/fle1Mo=
Received: from BN0PR08CA0015.namprd08.prod.outlook.com (2603:10b6:408:142::31)
 by LV2PR12MB5848.namprd12.prod.outlook.com (2603:10b6:408:173::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 09:09:25 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:408:142:cafe::7f) by BN0PR08CA0015.outlook.office365.com
 (2603:10b6:408:142::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:09:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:09:25 +0000
Received: from kaveri.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:09:09 -0500
From: Shivank Garg <shivankg@amd.com>
To: <seanjc@google.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <shuah@kernel.org>,
	<pbonzini@redhat.com>, <brauner@kernel.org>, <viro@zeniv.linux.org.uk>
CC: <ackerleytng@google.com>, <paul@paul-moore.com>, <jmorris@namei.org>,
	<serge@hallyn.com>, <pvorel@suse.cz>, <bfoster@redhat.com>,
	<tabba@google.com>, <vannapurve@google.com>, <chao.gao@intel.com>,
	<bharata@amd.com>, <nikunj@amd.com>, <michael.day@amd.com>,
	<shdhiman@amd.com>, <yan.y.zhao@intel.com>, <Neeraj.Upadhyay@amd.com>,
	<thomas.lendacky@amd.com>, <michael.roth@amd.com>, <aik@amd.com>,
	<jgg@nvidia.com>, <kalyazin@amazon.com>, <peterx@redhat.com>,
	<shivankg@amd.com>, <jack@suse.cz>, <rppt@kernel.org>, <hch@infradead.org>,
	<cgzones@googlemail.com>, <ira.weiny@intel.com>, <rientjes@google.com>,
	<roypat@amazon.co.uk>, <ziy@nvidia.com>, <matthew.brost@intel.com>,
	<joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
	<gourry@gourry.net>, <kent.overstreet@linux.dev>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<chao.p.peng@intel.com>, <amit@infradead.org>, <ddutile@redhat.com>,
	<dan.j.williams@intel.com>, <ashish.kalra@amd.com>, <gshan@redhat.com>,
	<jgowans@amazon.com>, <pankaj.gupta@amd.com>, <papaluri@amd.com>,
	<yuzhao@google.com>, <suzuki.poulose@arm.com>, <quic_eberman@quicinc.com>,
	<aneeshkumar.kizhakeveetil@arm.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH RFC V10 5/7] KVM: guest_memfd: Add slab-allocated inode cache
Date: Mon, 11 Aug 2025 09:06:07 +0000
Message-ID: <20250811090605.16057-11-shivankg@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250811090605.16057-2-shivankg@amd.com>
References: <20250811090605.16057-2-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|LV2PR12MB5848:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b04328e-e43c-4cd6-4fb3-08ddd8b6c4ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S57Pzl4fFLxA4l0gw9EpJLZWQ3OpvDmaZlTIeQG76u4ZXi4okPlh/vGgy09A?=
 =?us-ascii?Q?XRmZ5tJOgU4MR7TB7gIVzrYtm4pXTHXVVaCMD5BCRo473+m+6dRbfHez5siv?=
 =?us-ascii?Q?fF5FuoSv1i5ZPPOJBI+d2jp1gfzfCGmOOMR226ssMC7oUDThkIvH/vlSV/gN?=
 =?us-ascii?Q?pUY+JJy4WMaajLPpzoxJnonE3KjnPIGvHMGcxiPuxsYORA3xIFSH6dQfqUet?=
 =?us-ascii?Q?ehZnxMkVfqVt7W3OEpOWZOdpI9btiHx/fiLW22N2U5FH4OzdJv51PJsolJ/K?=
 =?us-ascii?Q?ThKWoIvKIS4uoU0WdWaJubQmqAY8XJrPJRJD8aEjG6hZn5PbxNb11HVI5O0+?=
 =?us-ascii?Q?RjLyIq4jx5Dv5zJL4qE4OS9WbLIHpT/lA76IzEFmMgQ+pfMXbvje8AzgcY8c?=
 =?us-ascii?Q?052g/kllcexlIItRZChLZoD/RKu/HWD0KedZHAk/brm8jhwItZSqRBSQB/Vm?=
 =?us-ascii?Q?yvs48rFboakjO/5VT5wKcs+5vc1F/UxQE0m2tW9pzDghgg3HWjmvfQ6R3Ka/?=
 =?us-ascii?Q?8T7mAtJVnjWB4qLU61WRQMSPDydaLmvAaiHpIR1+Xr5xLBd7kkpcxQLliF20?=
 =?us-ascii?Q?l2VFjYeTy5K4ln8Ug68OmAvfElzg/hNoCqOvwmJqD4OwR42RBNuYCJrxPxJy?=
 =?us-ascii?Q?STCcL598eywBO2u/smj9yK083JEmI1RsElrXKE+fXiZ4lqD6ltT1esHNH6tM?=
 =?us-ascii?Q?E515h9UfqMv+/YrbkbVXLdyoTEIAun87AaRZFA8Q0KDwUSTy+lPdL4qHxY+I?=
 =?us-ascii?Q?N6/EYfWd9YtGbtOa4YvJ/7+FIV4tUT+C4EByHPaYSrCi37QkbZnKj9Qpg5dv?=
 =?us-ascii?Q?niOF0rUsIezsGFhnqC637HFQaVdVa6aF0D12OHWWTzFAq2g6348tlyISTUbM?=
 =?us-ascii?Q?iNZjLwv6Mdqm9hwjUz4qfiJHHYHuQVCZa6HjwTD/M33KyhfSLwUOdSFnF/E3?=
 =?us-ascii?Q?A1tk0hYLtdOq6FnHm1ekMbpB9WVmHqnposTwZiOZ5o0iD7cDMfqB61JN02k2?=
 =?us-ascii?Q?/LWVOczttX0j3zLdsqWBlI43Cl9p4QI9uU+DgCV+c8WD5Gr8eGltFsvMvKzV?=
 =?us-ascii?Q?P9bCKeIC4OgOff/oKSBK/EgCwv6VzQXgmHrbm+QMRrLR/xgBMulmqYmQVBBh?=
 =?us-ascii?Q?cxHg4ycZ8h8NQ8kwwsn5H/k/UyLOUJ8qQgiCwv4lV2xLDPYhKRBzq3+lk92d?=
 =?us-ascii?Q?RgCk6hl0cX49bwGOubyIsum8rhyThXhpQm9eNSqWSY6pMpefD7fUtRf83glC?=
 =?us-ascii?Q?MGNjSkZPgkWLWCPJjQVtrAb+B9UxDAhQrtJTnyx45D2Ic5fheNzLQGSc9O0k?=
 =?us-ascii?Q?bpZe0L7llhOjs8CoXi4M5hVjYTg+GyeGT6jtpx7JSjOP30R8ru1OXdDOprR0?=
 =?us-ascii?Q?qpycSrpwA/srfRAJ+JdaSEK3p3YstbuR5gJNO/wfEf+zr/4qMspYcK2/4gLt?=
 =?us-ascii?Q?iBHQpqV/L8MGTVdfKv54C8Y/XqiVQYhUFwrFq5dAQYCa9Agl0cbzaGMHla7V?=
 =?us-ascii?Q?jZkWz0T4pTTZo+9lnBAvdJKpoxntjQWrCZIm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:09:25.3278
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b04328e-e43c-4cd6-4fb3-08ddd8b6c4ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5848
X-Rspamd-Queue-Id: AC5654000D
X-Stat-Signature: w8r7qo4fh6x3k4yt8bgs4m56utc9kfo6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754903368-466930
X-HE-Meta: U2FsdGVkX1+Vcj7hqmCrTp1qQKVfe6hekI+qQu/TSZouRTFQQ6AaQDtJCCWouot6jsKCFe/+sgQ3AQfHd/jp+hUKVrdqsaX8yxm2T0+41y/sZBheDAlqHJVfjEwvscbZ3vovfa/8Y51WSO5Xi99QoqgcAROM9eLQPIYux45PwPgirtkAPkKS0Nq2IKZmL0lZOQUvO3R3kfliZnEQcPQ85zT2YFAxC+/bZ/pP+HM/Yby518SIsFn1dxhc5Bno2XES0jpAayEOKIb14gOHD5MrVHsTDYSStbNIjsDRdhEbTDPp5eNHoZKVAG/YdJM6e2OIp3dqsTYQVGsDNPQz1PJmkRWzevy9JKw63e2ha1AIJoI6ekLMgmvvOMZz21FiSrw/K3YNhG2XCILAznLQAoS4INpvrtaDbyFDZpk/2Y070BA6fIHOMHkH8PmWAaXzpGLPmZg6jsS9ke5YNkenzAq/Cvcg2VmzVd2TRoD43hSVfgkNBm2SpUc7Q8fOxwRVLBhK86GAFPsbNX27/wZEofzfkNumPdRWT//aJ55sIKA4DQbXbvoCTYXYAMX44OJRiASgE0FQhbxMGhuQWijKxOCbbrdPZTuF/7UhA19aA8Y+ZGQx2aGJ0lHkJZ8cWUgPd3WUpE1BFf9PI1PJ/riTVUWNx3Kc97ooMi53Ar8LoFCAgi5CHZa5Jce8ke8tt/X7cclcwbHj8FP+8uI/Isbn754Ule+2Y2V0jB+KKxqgzMNDugbrh2Qu/Ow3xj0ZQZRs0teWU29Wm5Zc+dckeT+fUJBli82E+SyI0hpF6wzuSm2ifs9S6o9HSQg2khPMITo55M/ax3IHwDkBsqGFa0BZDuBEgNZegkEoCswYE4hFCKHNnfK5FwHM9PcTCfbaktXBWuzaOPXUpYx+1UAs2xSj4uTWU2R+2Y49tq+/xSbuqe6M1RjFhenA7mvLejBoSxLeUsRIG0D1sKmFH3nL38jeyFo
 kipVftZJ
 DXIcXYJ+9zODcMDSuolXjsa22QxxkGcwvH3sJ+eVJFTysAX0uUQwe2/2qc28W6rDddw0WG+RlqX04+gJW8+9BsYmgaliSr9XIkHXBG9LTNLj9pI90fQyEN73Nf6sU94l9LXBpJ10CM+2C7StXgP/Vyhlhn/NH3LTXGICiIW7G7PYBieYXGO+tQAapUIdF1GS/fc3oU/aCVYVPRzbn/63KKANTJkjyQzl/lFApjn0QLTSbIVwqT09nlmSBdhK7pjkIk2eKv5VMBbegQmPMbQ0T0xIYHknCmVJUMyNHtnF4owcNaXQZnni0dPfoQ3LwffZFnIGKjImbl9+giNn5jn4ZvEWlj0gkWKbQ71QG9jaV4+sSsDWdy9dqRuxtTSnoc+MjAtjO5/qSv8kXJnzpGXzJFiECBkjDkrNCphiC1f7Ii2gk6NxhXigCUyHhHq7PWkmcQGV1iQ6ULc4wqhXZNiIXqvI2azfF55GAOGOM1T+1M1Rb1LFaeC4UewFwJ/e6Qd05y/zGsbB5W2Vms9vcFeIBj9c1DHKFoi5+Brw06YdHA5NFIqzbkHbDbHnp93+fU6FYPVwlsEcbSOWElXHR4NmhWHAyyNfZK/XgxUE0goBuH0D3jDe+CM0344y6rbUdoq/SbbRJ+XbxphgUJt3CqFVCSsGjXYPBoKAY1WEXn8SqvPv6owRpzvS1Tx9VTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add dedicated inode structure (kvm_gmem_inode_info) and slab-allocated
inode cache for guest memory backing, similar to how shmem handles inodes.

This adds the necessary allocation/destruction functions and prepares
for upcoming guest_memfd NUMA policy support changes.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 virt/kvm/guest_memfd.c | 69 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 67 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0e93323fc839..d9c23401e770 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -17,6 +17,15 @@ struct kvm_gmem {
 	struct list_head entry;
 };
 
+struct kvm_gmem_inode_info {
+	struct inode vfs_inode;
+};
+
+static inline struct kvm_gmem_inode_info *KVM_GMEM_I(struct inode *inode)
+{
+	return container_of(inode, struct kvm_gmem_inode_info, vfs_inode);
+}
+
 /**
  * folio_file_pfn - like folio_file_page, but return a pfn.
  * @folio: The folio which contains this index.
@@ -389,13 +398,46 @@ static struct file_operations kvm_gmem_fops = {
 	.fallocate	= kvm_gmem_fallocate,
 };
 
+static struct kmem_cache *kvm_gmem_inode_cachep;
+
+static struct inode *kvm_gmem_alloc_inode(struct super_block *sb)
+{
+	struct kvm_gmem_inode_info *info;
+
+	info = alloc_inode_sb(sb, kvm_gmem_inode_cachep, GFP_KERNEL);
+	if (!info)
+		return NULL;
+
+	return &info->vfs_inode;
+}
+
+static void kvm_gmem_destroy_inode(struct inode *inode)
+{
+}
+
+static void kvm_gmem_free_inode(struct inode *inode)
+{
+	kmem_cache_free(kvm_gmem_inode_cachep, KVM_GMEM_I(inode));
+}
+
+static const struct super_operations kvm_gmem_super_operations = {
+	.statfs		= simple_statfs,
+	.alloc_inode	= kvm_gmem_alloc_inode,
+	.destroy_inode	= kvm_gmem_destroy_inode,
+	.free_inode	= kvm_gmem_free_inode,
+};
+
 static int kvm_gmem_init_fs_context(struct fs_context *fc)
 {
+	struct pseudo_fs_context *ctx;
+
 	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
 		return -ENOMEM;
 
 	fc->s_iflags |= SB_I_NOEXEC;
 	fc->s_iflags |= SB_I_NODEV;
+	ctx = fc->fs_private;
+	ctx->ops = &kvm_gmem_super_operations;
 
 	return 0;
 }
@@ -417,17 +459,40 @@ static int kvm_gmem_init_mount(void)
 	return 0;
 }
 
+static void kvm_gmem_init_inode(void *foo)
+{
+	struct kvm_gmem_inode_info *info = foo;
+
+	inode_init_once(&info->vfs_inode);
+}
+
 int kvm_gmem_init(struct module *module)
 {
-	kvm_gmem_fops.owner = module;
+	int ret;
+	struct kmem_cache_args args = {
+		.align = 0,
+		.ctor = kvm_gmem_init_inode,
+	};
 
-	return kvm_gmem_init_mount();
+	kvm_gmem_fops.owner = module;
+	kvm_gmem_inode_cachep = kmem_cache_create("kvm_gmem_inode_cache",
+						  sizeof(struct kvm_gmem_inode_info),
+						  &args, SLAB_ACCOUNT);
+	if (!kvm_gmem_inode_cachep)
+		return -ENOMEM;
+	ret = kvm_gmem_init_mount();
+	if (ret) {
+		kmem_cache_destroy(kvm_gmem_inode_cachep);
+		return ret;
+	}
+	return 0;
 }
 
 void kvm_gmem_exit(void)
 {
 	kern_unmount(kvm_gmem_mnt);
 	kvm_gmem_mnt = NULL;
+	kmem_cache_destroy(kvm_gmem_inode_cachep);
 }
 
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
-- 
2.43.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3ECCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056C690016E; Thu, 14 Aug 2025 09:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00780900023; Thu, 14 Aug 2025 09:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC40190016E; Thu, 14 Aug 2025 09:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C48D5900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:50:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 869EB8344B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:50:48 +0000 (UTC)
X-FDA: 83775498576.12.62F1189
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2058.outbound.protection.outlook.com [40.107.95.58])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8418F160013
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:50:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OjeSWdJW;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 40.107.95.58 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755179445; a=rsa-sha256;
	cv=pass;
	b=DHIHWXa3hAkocNMmRJG8NDXbtf+OBVWUb3oCU4OghR/sBxHRmsvnpfLfYZ57HAlPoXzrnK
	/xU2Ys1GSGX7v978So4Ref3MGLWaGD0xHzxq2oin2VVwN7DNb3AFOR24FpfC3gkpTLfeL8
	o7ctBEdlREjHkAgIO704hiDeLAYX914=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=OjeSWdJW;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 40.107.95.58 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=einv3+rK2t0s0MRlA/DPxs/b/mGJeW+10sIn+I67A8c=;
	b=BFj6ymC5Hadg8KdHpogADhuiWSu1oTAI3G3zfizb+it4Ls779GohGEKL82Kzwos1VFf1z9
	LoPaJwASVqGZYHk/+Qo85aPPk+gbrGFligRsy12mvZKxxlumB7MWBw3GxuXKXpdtV6ZYiA
	pt9aaVUkfhnfbZ296iXChPpClgD/v+s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tqZ+yoPomHiaNq4kTT/fqmi3lwu3l4WWS3X74zVnRu+t1He8S/PjgPq/DdbhIjSv3D0Ve/HyKQOEcRkJxNrgwwU9DLNQKR9Hu3n9BxPl7AllbxrvzfDLskKdmqv0ta37ppEEcEdMb8dsjF/PnV2WPF8nFwPvvp79bBswYesPug+nVp2CvHoAM1Dz2EPS89cLo1vitoRnRXrUReYQbfRjzb+viA07eU9hZ8XfyuaOwWUuzl0GwkZIfSpiFL+9g4EFiG2B2YjSb5iXv5bh/XqKs+MAA4eevEqemQlPicgFW0x6XXdXHAWjOJzsaTcG4ZuORZIm+RvdLqK24gLUdzDirg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=einv3+rK2t0s0MRlA/DPxs/b/mGJeW+10sIn+I67A8c=;
 b=GwrRtOiQR4PX/l2jew7xYo3DrBZyekHwN6cEwo6P+ezTE2MoAOUEEZ8HPgyValVTEh7q2y62gsY4pesP3gYnZrrR5CiEQ0Zg+8yFTp7/+t6cYaPBJ7BKkXVwSc2Z2q0M8wpQw/aSvWQebMSa33xsrGzZTq5nrUL0PX1d92+qD3UaxFSVUaUtvIFK6PRFRX7XvLvuxgYa1CuKq+GBgRYvTjB2dz9CO97v/KETLtBvshS0qWaaHGaCfeWmS1seD8uuqVupAOzN6qJU2SSIgYpFui5HnrlMMsWliDOSd6M1CJMQWm6pbTL9m1Yth5gJGCeL8zYV5FJ8yH3A4D1xCYaXkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=einv3+rK2t0s0MRlA/DPxs/b/mGJeW+10sIn+I67A8c=;
 b=OjeSWdJWeOOrP8ZbPnQtaxEcQyiPa6ssajl8JJeTHDUS9icxtXGDd6cQikypLWmxUycz+7vgY3EfT4eMZSBRv6KVrgEKUVQ9kEuCMRZnSOaYtJUPwR8goQ8DN3Ecxwcn23V7sxny+z44Wwi4O4abqSVnlJtDuq1Hkb+R9xUBkZI=
Received: from DS7PR05CA0077.namprd05.prod.outlook.com (2603:10b6:8:57::17) by
 CH3PR12MB7594.namprd12.prod.outlook.com (2603:10b6:610:140::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 13:50:42 +0000
Received: from DS1PEPF00017091.namprd03.prod.outlook.com
 (2603:10b6:8:57:cafe::d4) by DS7PR05CA0077.outlook.office365.com
 (2603:10b6:8:57::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.7 via Frontend Transport; Thu,
 14 Aug 2025 13:50:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017091.mail.protection.outlook.com (10.167.17.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 13:50:41 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 08:50:33 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <rientjes@google.com>, <sj@kernel.org>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v1 4/7] x86: ibs: In-kernel IBS driver for memory access profiling
Date: Thu, 14 Aug 2025 19:18:23 +0530
Message-ID: <20250814134826.154003-5-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814134826.154003-1-bharata@amd.com>
References: <20250814134826.154003-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017091:EE_|CH3PR12MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: 77ab5ce5-5ef7-4a09-9322-08dddb398f12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EZyl1k1funR46aBgPPbg8RgZasr66aOGe3VzD6b+oLV0AsI4yM3OOHN68qD5?=
 =?us-ascii?Q?eOYC8ltEGLCR8WNCZmRnEdUslsG5r9pLhmB1Grtcp2Pzr6LkoOmGquCVGb/0?=
 =?us-ascii?Q?ysW32lg9tx/8GSOCFpO1vUfdvsRPhrfdwxFIxZhhxev7nA9X1WQbzCiqUC3z?=
 =?us-ascii?Q?R2ExnsOYgyTfSsYtVJibk21StcWKfnTQjUqjIIYAXnIcGbPYstkJtkcv2xV3?=
 =?us-ascii?Q?+4RukNdCq/KQpdXjytEsyaShqJGg5G4ElmuoKdrSdnVLnX2Al64jwbjrJYXI?=
 =?us-ascii?Q?sDwFyihCGTwjdDFTVgZe5c5OXJdWZ5XPHS+mRJQckWfjkYEWQhLk04Cik7UC?=
 =?us-ascii?Q?pYClHB1sPpZ8yzlVX9SkgUSJWDk5LpXn33uTsD/x74PWjz76ne2vo5MTK3G9?=
 =?us-ascii?Q?AJHNRF6ws3sEmup9LtKgPQFUKp1B5Dk+WgnUPlMCMhR8vBqAtSsQlfMCDSiO?=
 =?us-ascii?Q?5Z+OJtZyBwp57Ec784w6p/pLWkAe6eXMbOwb1mE1NihgsuZu194cHcBJp75d?=
 =?us-ascii?Q?DgZ/zbBE5nv4KXa58P16N+IVpDHtiRakYpCVZPMSvIly7XKZmjw1FwCM/tO2?=
 =?us-ascii?Q?V9clZ9G75Sr9bWCNZl16+jN+yIuwz0ZPXxVfJHxgsMegW18WxTUh3Zk1d3OQ?=
 =?us-ascii?Q?U4hxe/0uzFXhEq0UJKBR5FHV0R+4T41lzb33oA1CKFeV0fqSdN0Mcq9Q8gRM?=
 =?us-ascii?Q?iMdn6qiBnhrJc9xqkbuCVkrEjyuwSViE9Dme6K1brqjbjaqp72L7JkR33/63?=
 =?us-ascii?Q?GOp3OhLztJnuFJtjUhvICB03w280DFpjNeYcLqEkzg0o5/kCSMxhiaLffVdS?=
 =?us-ascii?Q?GbPe/X8qhdL8SVHvXRnNRIGFiMEbsWHFH2AO8AX9FOhk5yqgQdIpSb7POypn?=
 =?us-ascii?Q?768xdzm9VgRMcbEp0YiOi56sHsfrhdRtTCtWXtia5ulEi15Pj/bSSBRX3ScG?=
 =?us-ascii?Q?tmj6fm3yp0vgWI0c/RJvByQ5qPGoGz62tFh/0XOChNCpE3688v/1t4zLrXVs?=
 =?us-ascii?Q?uEwUjhF/QsbT/CN7XxGBsi8Dp5U/TS9grpdJaRsoKGBpVhEH/d+AJTLQAhqh?=
 =?us-ascii?Q?VN2z0OZ160EHBZtzCfHpbEppoEUvLfhUiQqYgsag8+dYyhJBl38fZc1MCU8b?=
 =?us-ascii?Q?GmruDv7nz78YASMiyyCLJl0kgqHwLTGNl2M9kFrh9VPRvIieH7RP3x79Wifz?=
 =?us-ascii?Q?tND2qus83AOJgts5pQoXo2x9pIXzHNOcb41803lQgHTvpoJhcMS3yKOrg3/j?=
 =?us-ascii?Q?0k4oExPIprwe8bIWOfCL1OvQEbhu7dFWzR9t2ewdMhePe32xxcgBRpzrWAHK?=
 =?us-ascii?Q?Zm0o4zh10LcB0/vR6/eF7f62YVBBJSFg+L7fp+dnC3c8k2tRkaEmYPtvmWp5?=
 =?us-ascii?Q?hdMpHBsK59xMXs4d3BttYOKsmq2F4boVegOb+Uxo+eQgG5mPjACE7HZg2Tte?=
 =?us-ascii?Q?LQM2Kglt4/r11pYWf0jpWDhmlNO8EvgrTS1P0g6sv9R2jsTufInjew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 13:50:41.5644
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ab5ce5-5ef7-4a09-9322-08dddb398f12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017091.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7594
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8418F160013
X-Stat-Signature: gpcta7kifmhsnhqaasj49r7a8f4boz31
X-Rspam-User: 
X-HE-Tag: 1755179445-938920
X-HE-Meta: U2FsdGVkX18wHhxXX4JOCeHOPaNLMhTizVxtumSP3BEtH6ocLCL2VbyOPuZQcn232fJKtEU8SCQU2QEm8RT7G9tu8hqJgKK94H7s8WlYs3Ut54e1/3OVtvxdPoVBicrp05Fw9oqVuO927Y44HwvBMeXxFFH1Kpn18jiWE2V7xEtOS1kOnGyY3piDZBDDSKjEgVwtxkGaeBogqMT7Ib6WBtX7Wj9OF3S1GmgnlKsB0heJh7sHiEB6AyLIZCn9bG0RTR1z8SEAM3VtVqyM/W106ZbIOdfuhuP+NPzZYYEFksg9Q4feYWyWDoabNpub579eG+7ghS+jUIMRlC3WfGoiaemUWKmizlc/mcNKjlV3ActfCkwee/EIdUNFtjnWhrlQdJdqvgnWhbwomUEJOTtrqBKJFsXh5FO2/3Dund4jdUCWulBlgFQBQ30fo5HXBRsxRun7wYefa4GRJk5lJReWvLJXUqttW6hfqshBp/wosT08kaj1lnlB6gQXlqijs2HUNe6HN4L2fvXWo2glppb9Zsj7W+Y/OhpUY8Cyh0t5ATPYekKrDYBX/v4WxG4BnnWyPyWq9RZR6l/lhRlM4oCk+PScvwpPkNYp+MN1CRUSiGrtbdjQ3FcEBN278ZBfY443aEdhYOGeAOiukKyJdMyXDoajKNMrwNdu4NlkzssNNfQQGgCYVR0gbyPFEpjNrzUYfDhsc5RXJjQAgs8xxTkmm1RtgGt5Mq94qcaN3e02onYunY7jm1INye6H582+gvUa2qLtuD5pFZuR4dG55zwz8QSCtxrBLoJ1qXx54LWSQeBHXlAxmQU0yGeDF2wd6VCHlmEart+JqGFPACSdITm/wWTrXsLR6kV5v0TwAfp39ldzgrP18zmQ49OKHZtk+5HkVLGSWdeWVOH/eQBKsz8InGtbrUkjlvVxhYM2Hkp4N/oxfgb+l4P9dv70mEaptrDADhNwHle574XIdjSRf6s
 R4lrQd88
 /cQRvRQ+0/zn1qn0mD47VYJpGegigkHgkALMySgACobpgVT6bANuIA3QpWmBExfp+L5Hr/eWn/Xux34zAaljBg26smuMS7TZTEstCNav9YBKXo2dICuyRDQXi70KxB3stt6P9jlRMl2xoUfbX7Ci79WEYO7AZgK5M/9rfxRMkky7TcYduqoMpwpw6w/TRViaZoM9V6f4euvMlNVjN7Asp1+jY2m8UnD7O1NnhnrClzubOtMWsHrkgMSayK54m1G3kLRMDl74Ae0LKd1gLGsOs3AsPFfHGW3RAr6pWGBRCWkkvYcv1DBArDiEDryR6vULIpOEnagPnoc8F3MBjleN/FSkV6bhH/X9FFxWVrK4Y8Ss60jQEM6xwzHaVp57YeaZVkyub34flhAeE2KdVhKC/abLy9fFZzK8cwLa1tVbFb0443b/ZrdEL8t58ctMXwyr1ceq9q6jIwPG9pgEqdkrnt59PzT+NF4QHUNGzY1iME90EGjl1JvU/g8rTGz1/eILquTLMMMmJu4vkrfc2Dk/gZfHFdlpf5yW3xHobRRr34D7Mop+mThfv9tYwaTrlpxqvmlx/W3pwIHT25q+R0BFE0gdVW7eAGqKCCBnI2SfP5pPsPyRXjWuNhFFNIGqfkCJrQxc0kBchU2d9RPoYUnFpbp+kverKv4X0eflj8NG1wa6zgZPcKe6FNlEk9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IBS (Instruction Based Sampling) feature present
in AMD processors for memory access tracking. The access
information obtained from IBS via NMI is fed to kpromoted
daemon for futher action.

In addition to many other information related to the memory
access, IBS provides physical (and virtual) address of the access
and indicates if the access came from slower tier. Only memory
accesses originating from slower tiers are further acted upon
by this driver.

The samples are initially accumulated in percpu buffers which
are flushed to pghot hot page tracking mechanism using irq_work.

TODO: Many counters are added to vmstat just as debugging aid
for now.

About IBS
---------
IBS can be programmed to provide data about instruction
execution periodically. This is done by programming a desired
sample count (number of ops) in a control register. When the
programmed number of ops are dispatched, a micro-op gets tagged,
various information about the tagged micro-op's execution is
populated in IBS execution MSRs and an interrupt is raised.
While IBS provides a lot of data for each sample, for the
purpose of  memory access profiling, we are interested in
linear and physical address of the memory access that reached
DRAM. Recent AMD processors provide further filtering where
it is possible to limit the sampling to those ops that had
an L3 miss which greately reduces the non-useful samples.

While IBS provides capability to sample instruction fetch
and execution, only IBS execution sampling is used here
to collect data about memory accesses that occur during
the instruction execution.

More information about IBS is available in Sec 13.3 of
AMD64 Architecture Programmer's Manual, Volume 2:System
Programming which is present at:
https://bugzilla.kernel.org/attachment.cgi?id=288923

Information about MSRs used for programming IBS can be
found in Sec 2.1.14.4 of PPR Vol 1 for AMD Family 19h
Model 11h B1 which is currently present at:
https://www.amd.com/system/files/TechDocs/55901_0.25.zip

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/events/amd/ibs.c        |  11 ++
 arch/x86/include/asm/ibs.h       |   7 +
 arch/x86/include/asm/msr-index.h |  16 ++
 arch/x86/mm/Makefile             |   3 +-
 arch/x86/mm/ibs.c                | 311 +++++++++++++++++++++++++++++++
 include/linux/vm_event_item.h    |  17 ++
 mm/vmstat.c                      |  17 ++
 7 files changed, 381 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/ibs.h
 create mode 100644 arch/x86/mm/ibs.c

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 112f43b23ebf..1498dc9caeb2 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -13,9 +13,11 @@
 #include <linux/ptrace.h>
 #include <linux/syscore_ops.h>
 #include <linux/sched/clock.h>
+#include <linux/pghot.h>
 
 #include <asm/apic.h>
 #include <asm/msr.h>
+#include <asm/ibs.h>
 
 #include "../perf_event.h"
 
@@ -1756,6 +1758,15 @@ static __init int amd_ibs_init(void)
 {
 	u32 caps;
 
+	/*
+	 * TODO: Find a clean way to disable perf IBS so that IBS
+	 * can be used for memory access profiling.
+	 */
+	if (arch_hw_access_profiling) {
+		pr_info("IBS isn't available for perf use\n");
+		return 0;
+	}
+
 	caps = __get_ibs_caps();
 	if (!caps)
 		return -ENODEV;	/* ibs not supported by the cpu */
diff --git a/arch/x86/include/asm/ibs.h b/arch/x86/include/asm/ibs.h
new file mode 100644
index 000000000000..b5a4f2ca6330
--- /dev/null
+++ b/arch/x86/include/asm/ibs.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_IBS_H
+#define _ASM_X86_IBS_H
+
+extern bool arch_hw_access_profiling;
+
+#endif /* _ASM_X86_IBS_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index b65c3ba5fa14..55d26380550c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -742,6 +742,22 @@
 /* AMD Last Branch Record MSRs */
 #define MSR_AMD64_LBR_SELECT			0xc000010e
 
+/* AMD IBS MSR bits */
+#define MSR_AMD64_IBSOPDATA2_DATASRC			0x7
+#define MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE		0x1
+#define MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR	0x2
+#define MSR_AMD64_IBSOPDATA2_DATASRC_DRAM		0x3
+#define MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE	0x5
+#define MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM		0x8
+#define	MSR_AMD64_IBSOPDATA2_RMTNODE			0x10
+
+#define MSR_AMD64_IBSOPDATA3_LDOP		BIT_ULL(0)
+#define MSR_AMD64_IBSOPDATA3_STOP		BIT_ULL(1)
+#define MSR_AMD64_IBSOPDATA3_DCMISS		BIT_ULL(7)
+#define MSR_AMD64_IBSOPDATA3_LADDR_VALID	BIT_ULL(17)
+#define MSR_AMD64_IBSOPDATA3_PADDR_VALID	BIT_ULL(18)
+#define MSR_AMD64_IBSOPDATA3_L2MISS		BIT_ULL(20)
+
 /* Zen4 */
 #define MSR_ZEN4_BP_CFG                 0xc001102e
 #define MSR_ZEN4_BP_CFG_BP_SPEC_REDUCE_BIT 4
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcf..967e5af9eba9 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -22,7 +22,8 @@ CFLAGS_REMOVE_pgprot.o			= -pg
 endif
 
 obj-y				:=  init.o init_$(BITS).o fault.o ioremap.o extable.o mmap.o \
-				    pgtable.o physaddr.o tlb.o cpu_entry_area.o maccess.o pgprot.o
+				    pgtable.o physaddr.o tlb.o cpu_entry_area.o maccess.o pgprot.o \
+				    ibs.o
 
 obj-y				+= pat/
 
diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
new file mode 100644
index 000000000000..6669710dd35b
--- /dev/null
+++ b/arch/x86/mm/ibs.c
@@ -0,0 +1,311 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/init.h>
+#include <linux/pghot.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/irq_work.h>
+
+#include <asm/nmi.h>
+#include <asm/perf_event.h> /* TODO: Move defns like IBS_OP_ENABLE into non-perf header */
+#include <asm/apic.h>
+#include <asm/ibs.h>
+
+bool arch_hw_access_profiling;
+static u64 ibs_config __read_mostly;
+static u32 ibs_caps;
+
+#define IBS_NR_SAMPLES	150
+
+/*
+ * Basic access info captured for each memory access.
+ */
+struct ibs_sample {
+	unsigned long pfn;
+	unsigned long time;	/* jiffies when accessed */
+	int nid;		/* Accessing node ID, if known */
+};
+
+/*
+ * Percpu buffer of access samples. Samples are accumulated here
+ * before pushing them to kpromoted for further action.
+ */
+struct ibs_sample_pcpu {
+	struct ibs_sample samples[IBS_NR_SAMPLES];
+	int head, tail;
+};
+
+struct ibs_sample_pcpu __percpu *ibs_s;
+
+/*
+ * The workqueue for pushing the percpu access samples to kpromoted.
+ */
+static struct work_struct ibs_work;
+static struct irq_work ibs_irq_work;
+
+/*
+ * Record the IBS-reported access sample in percpu buffer.
+ * Called from IBS NMI handler.
+ */
+static int ibs_push_sample(unsigned long pfn, int nid, unsigned long time)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+	int next = ibs_pcpu->head + 1;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	if (next == ibs_pcpu->tail)
+		return 0;
+
+	ibs_pcpu->samples[ibs_pcpu->head].pfn = pfn;
+	ibs_pcpu->samples[ibs_pcpu->head].time = time;
+	ibs_pcpu->head = next;
+	return 1;
+}
+
+static int ibs_pop_sample(struct ibs_sample *s)
+{
+	struct ibs_sample_pcpu *ibs_pcpu = raw_cpu_ptr(ibs_s);
+
+	int next = ibs_pcpu->tail + 1;
+
+	if (ibs_pcpu->head == ibs_pcpu->tail)
+		return 0;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	*s = ibs_pcpu->samples[ibs_pcpu->tail];
+	ibs_pcpu->tail = next;
+	return 1;
+}
+
+/*
+ * Remove access samples from percpu buffer and send them
+ * to kpromoted for further action.
+ */
+static void ibs_work_handler(struct work_struct *work)
+{
+	struct ibs_sample s;
+
+	while (ibs_pop_sample(&s))
+		pghot_record_access(s.pfn, s.nid, PGHOT_HW_HINTS, s.time);
+}
+
+static void ibs_irq_handler(struct irq_work *i)
+{
+	schedule_work_on(smp_processor_id(), &ibs_work);
+}
+
+/*
+ * IBS NMI handler: Process the memory access info reported by IBS.
+ *
+ * Reads the MSRs to collect all the information about the reported
+ * memory access, validates the access, stores the valid sample and
+ * schedules the work on this CPU to further process the sample.
+ */
+static int ibs_overflow_handler(unsigned int cmd, struct pt_regs *regs)
+{
+	struct mm_struct *mm = current->mm;
+	u64 ops_ctl, ops_data3, ops_data2;
+	u64 laddr = -1, paddr = -1;
+	u64 data_src, rmt_node;
+	struct page *page;
+	unsigned long pfn;
+
+	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
+
+	/*
+	 * When IBS sampling period is reprogrammed via read-modify-update
+	 * of MSR_AMD64_IBSOPCTL, overflow NMIs could be generated with
+	 * IBS_OP_ENABLE not set. For such cases, return as HANDLED.
+	 *
+	 * With this, the handler will say "handled" for all NMIs that
+	 * aren't related to this NMI.  This stems from the limitation of
+	 * having both status and control bits in one MSR.
+	 */
+	if (!(ops_ctl & IBS_OP_VAL))
+		goto handled;
+
+	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_VAL);
+
+	count_vm_event(HWHINT_NR_EVENTS);
+
+	if (!user_mode(regs)) {
+		count_vm_event(HWHINT_KERNEL);
+		goto handled;
+	}
+
+	if (!mm) {
+		count_vm_event(HWHINT_KTHREAD);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA3, ops_data3);
+
+	/* Load/Store ops only */
+	/* TODO: DataSrc isn't valid for stores, so filter out stores? */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_LDOP |
+			   MSR_AMD64_IBSOPDATA3_STOP))) {
+		count_vm_event(HWHINT_NON_LOAD_STORES);
+		goto handled;
+	}
+
+	/* Discard the sample if it was L1 or L2 hit */
+	if (!(ops_data3 & (MSR_AMD64_IBSOPDATA3_DCMISS |
+			   MSR_AMD64_IBSOPDATA3_L2MISS))) {
+		count_vm_event(HWHINT_DC_L2_HITS);
+		goto handled;
+	}
+
+	rdmsrl(MSR_AMD64_IBSOPDATA2, ops_data2);
+	data_src = ops_data2 & MSR_AMD64_IBSOPDATA2_DATASRC;
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		data_src |= ((ops_data2 & 0xC0) >> 3);
+
+	switch (data_src) {
+	case MSR_AMD64_IBSOPDATA2_DATASRC_LCL_CACHE:
+		count_vm_event(HWHINT_LOCAL_L3L1L2);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_PEER_CACHE_NEAR:
+		count_vm_event(HWHINT_LOCAL_PEER_CACHE_NEAR);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_DRAM:
+		count_vm_event(HWHINT_DRAM_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_EXT_MEM:
+		count_vm_event(HWHINT_CXL_ACCESSES);
+		break;
+	case MSR_AMD64_IBSOPDATA2_DATASRC_FAR_CCX_CACHE:
+		count_vm_event(HWHINT_FAR_CACHE_HITS);
+		break;
+	}
+
+	rmt_node = ops_data2 & MSR_AMD64_IBSOPDATA2_RMTNODE;
+	if (rmt_node)
+		count_vm_event(HWHINT_REMOTE_NODE);
+
+	/* Is linear addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_LADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCLINAD, laddr);
+	else {
+		count_vm_event(HWHINT_LADDR_INVALID);
+		goto handled;
+	}
+
+	/* Discard kernel address accesses */
+	if (laddr & (1UL << 63)) {
+		count_vm_event(HWHINT_KERNEL_ADDR);
+		goto handled;
+	}
+
+	/* Is phys addr valid? */
+	if (ops_data3 & MSR_AMD64_IBSOPDATA3_PADDR_VALID)
+		rdmsrl(MSR_AMD64_IBSDCPHYSAD, paddr);
+	else {
+		count_vm_event(HWHINT_PADDR_INVALID);
+		goto handled;
+	}
+
+	pfn = PHYS_PFN(paddr);
+	page = pfn_to_online_page(pfn);
+	if (!page)
+		goto handled;
+
+	if (!PageLRU(page)) {
+		count_vm_event(HWHINT_NON_LRU);
+		goto handled;
+	}
+
+	if (!ibs_push_sample(pfn, numa_node_id(), jiffies)) {
+		count_vm_event(HWHINT_BUFFER_FULL);
+		goto handled;
+	}
+
+	irq_work_queue(&ibs_irq_work);
+	count_vm_event(HWHINT_USEFUL_SAMPLES);
+
+handled:
+	return NMI_HANDLED;
+}
+
+static inline int get_ibs_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrl(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return val & IBSCTL_LVT_OFFSET_MASK;
+}
+
+static void setup_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset < 0)
+		goto failed;
+
+	if (!setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 0))
+		return;
+failed:
+	pr_warn("IBS APIC setup failed on cpu #%d\n",
+		smp_processor_id());
+}
+
+static void clear_APIC_ibs(void)
+{
+	int offset;
+
+	offset = get_ibs_lvt_offset();
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
+}
+
+static int x86_amd_ibs_access_profile_startup(unsigned int cpu)
+{
+	setup_APIC_ibs();
+	return 0;
+}
+
+static int x86_amd_ibs_access_profile_teardown(unsigned int cpu)
+{
+	clear_APIC_ibs();
+	return 0;
+}
+
+static int __init ibs_access_profiling_init(void)
+{
+	if (!boot_cpu_has(X86_FEATURE_IBS)) {
+		pr_info("IBS capability is unavailable for access profiling\n");
+		return 0;
+	}
+
+	ibs_s = alloc_percpu_gfp(struct ibs_sample_pcpu, GFP_KERNEL | __GFP_ZERO);
+	if (!ibs_s)
+		return 0;
+
+	INIT_WORK(&ibs_work, ibs_work_handler);
+	init_irq_work(&ibs_irq_work, ibs_irq_handler);
+
+	/* Uses IBS Op sampling */
+	ibs_config = IBS_OP_CNT_CTL | IBS_OP_ENABLE;
+	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (ibs_caps & IBS_CAPS_ZEN4)
+		ibs_config |= IBS_OP_L3MISSONLY;
+
+	register_nmi_handler(NMI_LOCAL, ibs_overflow_handler, 0, "ibs");
+
+	cpuhp_setup_state(CPUHP_AP_PERF_X86_AMD_IBS_STARTING,
+			  "x86/amd/ibs_access_profile:starting",
+			  x86_amd_ibs_access_profile_startup,
+			  x86_amd_ibs_access_profile_teardown);
+
+	pr_info("IBS setup for memory access profiling\n");
+	return 0;
+}
+
+arch_initcall(ibs_access_profiling_init);
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 9085e5c2d4aa..d01267649431 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -195,6 +195,23 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KPROMOTED_NON_LRU,
 		KPROMOTED_COLD_OLD,
 		KPROMOTED_DROPPED,
+		HWHINT_NR_EVENTS,
+		HWHINT_KERNEL,
+		HWHINT_KTHREAD,
+		HWHINT_NON_LOAD_STORES,
+		HWHINT_DC_L2_HITS,
+		HWHINT_LOCAL_L3L1L2,
+		HWHINT_LOCAL_PEER_CACHE_NEAR,
+		HWHINT_FAR_CACHE_HITS,
+		HWHINT_DRAM_ACCESSES,
+		HWHINT_CXL_ACCESSES,
+		HWHINT_REMOTE_NODE,
+		HWHINT_LADDR_INVALID,
+		HWHINT_KERNEL_ADDR,
+		HWHINT_PADDR_INVALID,
+		HWHINT_NON_LRU,
+		HWHINT_BUFFER_FULL,
+		HWHINT_USEFUL_SAMPLES,
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 9edbdd71c6f7..5727e4b88258 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1505,6 +1505,23 @@ const char * const vmstat_text[] = {
 	"kpromoted_non_lru",
 	"kpromoted_cold_old",
 	"kpromoted_dropped",
+	"hwhint_nr_events",
+	"hwhint_kernel",
+	"hwhint_kthread",
+	"hwhint_non_load_stores",
+	"hwhint_dc_l2_hits",
+	"hwhint_local_l3l1l2",
+	"hwhint_local_peer_cache_near",
+	"hwhint_far_cache_hits",
+	"hwhint_dram_accesses",
+	"hwhint_cxl_accesses",
+	"hwhint_remote_node",
+	"hwhint_invalid_laddr",
+	"hwhint_kernel_addr",
+	"hwhint_invalid_paddr",
+	"hwhint_non_lru",
+	"hwhint_buffer_full",
+	"hwhint_useful_samples",
 };
 #endif /* CONFIG_PROC_FS || CONFIG_SYSFS || CONFIG_NUMA || CONFIG_MEMCG */
 
-- 
2.34.1



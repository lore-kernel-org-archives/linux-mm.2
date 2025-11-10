Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3596ACCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959978E0007; Mon, 10 Nov 2025 00:24:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90A2D8E0002; Mon, 10 Nov 2025 00:24:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE678E0007; Mon, 10 Nov 2025 00:24:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62DD58E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:24:39 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32E1F13C1D2
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:24:39 +0000 (UTC)
X-FDA: 84093557478.07.0A05AF0
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012044.outbound.protection.outlook.com [40.107.209.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 464E0A0009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:24:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=J7aaShja;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 40.107.209.44 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Csunv4ay0ersKu9D+/xbcPqUb4eanrv3W4tEcydndrs=;
	b=l6+ZQoDVr+mk9t0j48P+gir7UgGeEG0NpIL38N327Bc5BdXoSIwHv7MF0NiXCPKCfL79xN
	oWjYW8BTwN7Xb/oY6ZLggxRJ2fH5U3UYFriZuUIPH9ksG19d91RNozm8bJTsefgtpHoAIt
	N+Xd4VVE/hckDrv00YxLcR8M7a2gnsc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762752276; a=rsa-sha256;
	cv=pass;
	b=V4VAPT2juyaAZNVnMVV2kdHCN+RcAzudusf6COQolkeqmAfPUOoKwIWo7qmnYMrbn4S1Ne
	UJk/feANppUscAtetMCehn2mR+60Li7TDEaGcqaxCwa6tnhwaXE1f0O+DFP10/AJhwlcAA
	kK6zXUWgQTxumdRaJMYqA+wxJCmGTGo=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=J7aaShja;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 40.107.209.44 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X4kS1Zf2qXqi0kWQXTaNQMA5vmjtE8hoAReqoIdo8rE57eLvFajIa04v8NPwbs8QtV2RaUWvZwpPXYSK6fjz1fFkF/N6S8kcLYuk5dQTELTIepHi8Kp4sODUNRO8ibyFMsBy2ADn4OUQPit88zn/6g7Mqacy6tOJFhixl/GEV7x/roV1ROKCXvXM/aqQVbiNtcuedsY8LuFQm+qD0NDpG2hjtLAklFXGEzEZYA5M55yOKA8Q4Up90/ZV7AOkdFOlMobx9h96oLGnxj1K5pb8ZmUcR5tqkuuLTZtiffJeN6W7jdas65uD7PZXE+LoTOc57YEwmf+1jJSq/yMm3IZNOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Csunv4ay0ersKu9D+/xbcPqUb4eanrv3W4tEcydndrs=;
 b=p/iP0fOppOfa1hseFtX7+dVCS9e83apEHujEN71oNL3o62gLzi1qSdeEwkXyOyVbuyFmgxjlVHjDn3Qhbaj85na/siZlqUOAlWfgwMviv1OCS9ixC8FvJ2wPBUxdkIlm9pJpP8r31rjSGLJuggigZ/3jcZ1TqqByFv1rvRWPIvICK1cHzx34g5Ci57atlKapUNWDZ2R/M7toOgfvrNt7IJcNPDxjhsTMYlaONEGe+XoGc1fJznQEE+4TOyn398HQyO0VaYsKXsmlW7FyoDiCQhy1JhHVWK1GHfegNhmg5hSn3kaH+PBvS+3sjsOQV0KTZz9x0NHviJ+wn9bhQ46wfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Csunv4ay0ersKu9D+/xbcPqUb4eanrv3W4tEcydndrs=;
 b=J7aaShja7ZKFIxffQ0eG84o+DBxZJE+4mKHGZhpMvDPvwcXLj0WVhi8IqqVqakX+OuZLegP/R08FBsdluMchRmCTgE/rLF/gBmkK+GxgXmW+aAUq2998EIPdA7Ud7TOzKST7EHuGQuZatM/JgZ3sAYIlDxuICwGHM9KA7CiMGXo=
Received: from BN0PR02CA0047.namprd02.prod.outlook.com (2603:10b6:408:e5::22)
 by SJ2PR12MB9190.namprd12.prod.outlook.com (2603:10b6:a03:554::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 05:24:32 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:e5:cafe::c0) by BN0PR02CA0047.outlook.office365.com
 (2603:10b6:408:e5::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.16 via Frontend Transport; Mon,
 10 Nov 2025 05:24:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 05:24:32 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 9 Nov
 2025 21:24:24 -0800
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v3 1/8] mm: migrate: Allow misplaced migration without VMA too
Date: Mon, 10 Nov 2025 10:53:36 +0530
Message-ID: <20251110052343.208768-2-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251110052343.208768-1-bharata@amd.com>
References: <20251110052343.208768-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|SJ2PR12MB9190:EE_
X-MS-Office365-Filtering-Correlation-Id: 41be58c3-f603-430e-d046-08de20196dd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RlZJbwUgHr7pyJ/sA/zcvofFaxhcdOBndiNcFJSe8otb4N3BE/At+SBwRbiV?=
 =?us-ascii?Q?5ZuSOaN6t0cliqUgOKgtECHKlFz+u+EmghmDro/u9qNL5LDaOcAt4lffAqgY?=
 =?us-ascii?Q?wz+Q77PlX8NA4ZpFoDN6hWfeWQYi/6BnST3bHKO9hHCV2kO2ZEm64AX5eKST?=
 =?us-ascii?Q?oLIZBHsj7uNeI9MmMD/DCT3c2SKwUgQAdxwDHabMp5jNPdscSP48Qf76Llpa?=
 =?us-ascii?Q?V/iPH0Efj6mqdJcnupoFJQ+e2MedudaLpOqK7o/W8hZ249xNKBJze+rZw0UL?=
 =?us-ascii?Q?tXPDTmKEW2x3J+qkyeadbncma4rZdGcEAlGafAISZtMj9L+DMlspEpKhhG4X?=
 =?us-ascii?Q?h7jwYthi2Q5Gd9U+xLsjNCZjcTizeso5lsUsOHvG7pNG62Qo+Fj4+YoZBd+s?=
 =?us-ascii?Q?j7vkXcMpML+G8fuAMyBGLRBFRPqYZtm3i7e9a6BdApxI3LwMTsQ0woKDJupF?=
 =?us-ascii?Q?HBmHZBd6BCarWpAvcKl1mjDIw7GOJpdwMBjMwTcwUjV/EQFvPdyhjj+w/Y+i?=
 =?us-ascii?Q?cqJu7qpSEfxDJe4f8lees84Cmp7GUIXZsiSKOcQKsqFU84yGQDDG1xtVmfGB?=
 =?us-ascii?Q?pUb2S62669CXpUWy18k5OPetmYbtPxrMP1TNd+gIgnxQtPABv+2qEqvJKG5r?=
 =?us-ascii?Q?oEVrzFgRNb/QJuFWix8SgbNHyQjSj5skk5F05Tiy5dha3H2S2fxOWGQ2Tal7?=
 =?us-ascii?Q?7VbEJQwz2E7K6ECZ7YSRXoZX82H2A9lULW3DLRFocn6AHwH60DEOkyQXTAgl?=
 =?us-ascii?Q?y8OYaHKdzotVVO+p/8FZJBM0JpSOI3PyRps3SRHovHDQSAeF9grI0kRzEA+7?=
 =?us-ascii?Q?tC/lOQ8eT9NsGuIDigrILlkvgAyCTyf6U8BHMxN9EmJQFnx8xcLYksAjAEgV?=
 =?us-ascii?Q?CusEzoSbCE1MoRuzBIWVXSGuKXFBxufV43smabD/Z9+v5mkOAckI/+RtTi2S?=
 =?us-ascii?Q?GYKl1hrVcnZ9DQcaa653F3ecLYNkiQ34wuTkCGDuZGVu2k9s+SngozTNxv3Y?=
 =?us-ascii?Q?GH0thVBQC2QveNIkwnAY5qUOXZI6MOHNZE/5z/x3C23TTSU4iUCOWXmkIL2v?=
 =?us-ascii?Q?TozDYwqlX+G0umKmxWnWjtaKEDwHSvRfz3jjudK5titJMwoUxOxbQcjtbxw3?=
 =?us-ascii?Q?yo+NLN3agUrni8AyCCJj491kKsQRaihNZZhPPtNlys9WcGb9vJZHCpRbjcc3?=
 =?us-ascii?Q?6xi0y7xA6IB7yvWGpo6Rbfe5mBtv+k14yYXKe8aarzk6Zd99vJu7NuX/UbcJ?=
 =?us-ascii?Q?tK92skPpyQLZpQQjw31Zz2Pxx7Q/kr4IcVqL2kXvQ+ZyxFZ+9ePo3+Oo5Y4c?=
 =?us-ascii?Q?nh7MrP5pxqfp2lzDP0EQVjOGbV+jZNfug08aKwcKkdLqzpNHpi/wWRntYqdt?=
 =?us-ascii?Q?F6iJg+nlBrIaa7xVGA3tTaWFZSX+IknlbPY0Geli0ZxZThdxyWTRYZRQF9WL?=
 =?us-ascii?Q?aKdaA/55OP6Z9y9biCJPg9yuNqzx+q4KntV7pD2Nsbf/7Sq8WQurSggqeE5b?=
 =?us-ascii?Q?xYDN7CCriaDiq3UbdoFNSV14/F8KD2IhuJ8PzwrVske+l2FKD8rpA9sYPx+2?=
 =?us-ascii?Q?vvpLU1TJzEq3hnhiAuw=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 05:24:32.1631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41be58c3-f603-430e-d046-08de20196dd3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9190
X-Stat-Signature: 1zajgb87hn19ppnmjf96sc965bwa5oeb
X-Rspam-User: 
X-Rspamd-Queue-Id: 464E0A0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1762752276-122801
X-HE-Meta: U2FsdGVkX18Wsnf1bPtaty/wWoFjMmcPYq+gcpZ+lmTcvkzKSIM73VnAcKZu5We3RyMErMO4G7VYDa+IWQiUQ5y0KLdBy5ZYaVVWmKbKbF9lvbr4qd81JXlsJ9KPzlk/pdFnW0XK8VIw5bfLZWrNcygkTDCqj2qTjLP4toz9+L26tAeTCAaGALMfNZ9YFPODHvXM16DJ6G5+BzCRsofDlosN4NR/LCYK4SiZ3lqPwf+RJR2LmYiQbSIIfxvf/Vhr+vQjRZZlRgKhy6N0faTWITkukBplVl/4N0bZJNSNdMiyG3sniD5F8MNhcL7VMThQfblL90Aa+8f9Sa6tbgd8q0kKpcjBgOf5sPPhxQqyyOaIZsKsuUv8AeAPFWxXA/ak3ah3lgqm5MLXLqVZQ0ZV6HW5+by1LgQ2E9PF/NTgNcI+5a6TsLRW2jiqi9pu5IS1gcP1gvxT0l0MpGKY+wlvKyv2oOqxSjjh5wKnwPHCFQyryl2ZtCBtGVwmtLplGcAURyWUrP9JrA5bd78kpg0U0AhIsJhXqPon7QSNTbZ+5S1fcKBPnQv0XbnbdfZpLen3Ybr1MLB6VJ/n+8q1NpdyBG2KnuQgwntWZ/LM87TBzjPSJOts751/EdaEPRaKL3b+r++JsomfX0MmAwNFkU94gutJbNhLWi0HBDaSFztKvM3P7CGV+aLj8uslHwxvAKraHPDdW3VpwMe20JNTN0rDDVJxDNnKBLbq5S67Q3MDR/Qn7g3vQkp7pzuecZWeUIv5JeivwBbgOHrfEURqsJLNHduLBCNx6cC9QILS2U+iDA2Y71dA87QVrpXC7X6dGnWuBqeoTPlCfT4hrMmHpnSR8wUXhsjBOuMe8rHdoiz/H6HTpqgu97l9HauHBmhonfyYbCYfhwQHGsZi84mVbZqp5Dl6oNi54ytZQIqAoHUpIhjjo9f+oBxJylGBjIkC+p7BMXKb4/lS5/XBe5JyNBg
 njNLMMCZ
 0z480ceb2OIGM5AsN2GY9BRqxKK/+ZCVTPO3p0LMNIA41IPvEZaWvF8Ze4fwoZ+emlwbUKjGMHS6aBwnQ8ramBYgqbSoh+Lspn34X4K4lUEpEusHt19wYXfRKxcAnyLUqIOuYrWD8uXg5rtGPWk+YmAQmOpEMaMHJ+COKudQGj229CDzPgahDN+vab480motRKvMTZUjIRARgx10KarbELltxJyUoxjM+0X8ZAist235eYoUZeMWPAfEFeEr9HRWWibQBkjiWo3jk0C/eianwcO5f59DVBntvTCre+rQwT/PEy/4ZgOIOAwzdjLbikGBXQSISZdljfDjssMwu8HpxIqWtDn9PCvNVpbaM8sh2tntDh3fqvhrFwCvxNu3jFfIXpnudIzuJPdHuu3fgENM5YwP2zQCqEMEfihvcdW6l/bh9vkCudNFDQAEz5OvIPhuBuA4DxPpEC56j+/sCyeZWVurenymHm+NxRZZyegQoXrOzHOyz8txx+T/5j7ds7h87xpHNzOdt3QIEAVY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want isolation of misplaced folios to work in contexts
where VMA isn't available, typically when performing migrations
from a kernel thread context. In order to prepare for that
allow migrate_misplaced_folio_prepare() to be called with
a NULL VMA.

When migrate_misplaced_folio_prepare() is called with non-NULL
VMA, it will check if the folio is mapped shared and that requires
holding PTL lock. This path isn't taken when the function is
invoked with NULL VMA (migration outside of process context).
Hence for such cases, it is not necessary this function be
called with PTL lock held.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 mm/migrate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index c0e9f15be2a2..189d0548d4ce 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2644,7 +2644,8 @@ static struct folio *alloc_misplaced_dst_folio(struct folio *src,
 
 /*
  * Prepare for calling migrate_misplaced_folio() by isolating the folio if
- * permitted. Must be called with the PTL still held.
+ * permitted. Must be called with the PTL still held if called with a non-NULL
+ * vma.
  */
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node)
@@ -2661,7 +2662,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if (vma && (vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
 			return -EACCES;
 
 		/*
-- 
2.34.1



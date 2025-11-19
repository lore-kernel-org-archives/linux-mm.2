Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24956CF34AB
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 13:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30D876B002D; Wed, 19 Nov 2025 08:06:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5686B0088; Wed, 19 Nov 2025 08:06:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3F16B00AA; Wed, 19 Nov 2025 08:06:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06CF26B002D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 08:06:58 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A684F1A04BC
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:06:57 +0000 (UTC)
X-FDA: 84127381674.16.DDBCF3E
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012021.outbound.protection.outlook.com [52.101.48.21])
	by imf02.hostedemail.com (Postfix) with ESMTP id 921B980022
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:06:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LKfAR875;
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 52.101.48.21 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763557614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ECEGdV4h59a5+PFe/BMzq/fdFFJ67UTZyon4YfLkUtU=;
	b=e9YI2Y2OpX44R5sDVAMtSbYU/F08sukq+5yakomlZZCvhTsbifHBA6zsVBMnfV+yjQoKto
	r+yNLamse+TZggsPnNBZLM7CM9LiJmWpMZdvzyG3O2hKZBPzktlmp2UM6yOjh44uC08ww5
	gzuBHBut+IFbBDBbaeYklUr2QIfbNtc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=LKfAR875;
	spf=pass (imf02.hostedemail.com: domain of bharata@amd.com designates 52.101.48.21 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763557614; a=rsa-sha256;
	cv=pass;
	b=zM2jNtXUcd3zVtmjiwf3ubOJMYqRlHR+RCVfnh1OnOADYKd4/KCFFpR/vP7GkS2illpgy8
	rUuAU3fEiKK8T32+Z8eG/JWmKFkf5NBFmM8uEwUYekw9AgsmrJuk2nHSyfd8axsLCt0ohl
	jmLjx+5KDfB6Y0TWmzrq7K5BCnUPFak=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pdomClm92cms3MW13qMwxJiPmWXWhfmlDLO6dq1Pp5z56cFLdUxGMg8O55G5rTa0og9OSQVWwjG4qqdP0HcvL1JqVxbunmKACJKAeXllm8yCBf/ose0THqx7lIIxYRT2xDBj89vqZxGfqfVKvr+fX4GDOGyQh63SLjL90KVMmTzpOnrS+FYDEOu6txQnh6cp60BGtPDBj8RqO27fUIRyAVHwPOywUXlqorCIC5vyP+M5u+Sb54eFezlVYFx8kHou0f5gV3oJB0q9aJeT3bXmRjjuxuausZN2GnWbMTrP6O6hxuEsRggB40wg7YdvdqqEI+Eu+zc9WiI0gkGHkd+I8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ECEGdV4h59a5+PFe/BMzq/fdFFJ67UTZyon4YfLkUtU=;
 b=qBQpIjxkHQYKXwvgxyBXosaFtnOKVXnYLnpk0dYGBSJhko0WHsoqBvphPv7unV6u8rjp0e1WSue8X1YEpLQ4ph186nyTFNTKTL07DjQ2A869RDqoN18x/3WFOUIgoWlleAR3oQlV0y5w8NxIjN7y4zZsnE6PlRGgYdIoMbGoPvDZEWXP/nGsS/AXOxbJ7I0PpGIYjfnaDevFbPP5FXh7dIEw8ZcZb4/wkm2lWJUNqbUM8s8614axZa4TJF4Q7oxI9WMYukqVHFCR8kTBrEy2/bfnY2Vk7VK2Dam48ymU/xDEXrEy8JPzRhMwkq1ydSeRCID+dZ2YC7i1NAZ34PHakg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=huawei.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ECEGdV4h59a5+PFe/BMzq/fdFFJ67UTZyon4YfLkUtU=;
 b=LKfAR875aaL+DVjJgbs7Jrqzj0ixPMTfLxvTIBSC7+1NN9Diwlqya7DG9oUUDOhEigqqpcZzN5LsBbhwBgz27BVn1otaruozhtH6qdY10LsN+ljTGReCM/coMGGqnk7RdMoBSC2+Y9fOqNRIOFZgq562kwrDCpOZRKZIFLlDz+8=
Received: from PH8PR22CA0009.namprd22.prod.outlook.com (2603:10b6:510:2d1::25)
 by LV8PR12MB9713.namprd12.prod.outlook.com (2603:10b6:408:2a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 13:06:48 +0000
Received: from CY4PEPF0000EE35.namprd05.prod.outlook.com
 (2603:10b6:510:2d1:cafe::a3) by PH8PR22CA0009.outlook.office365.com
 (2603:10b6:510:2d1::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 13:06:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EE35.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Wed, 19 Nov 2025 13:06:46 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 19 Nov
 2025 05:06:39 -0800
From: Bharata B Rao <bharata@amd.com>
To: <bharata@amd.com>
CC: <Jonathan.Cameron@huawei.com>, <akpm@linux-foundation.org>,
	<alok.rathore@samsung.com>, <balbirs@nvidia.com>, <byungchul@sk.com>,
	<dave.hansen@intel.com>, <dave@stgolabs.net>, <david@redhat.com>,
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <kinseyho@google.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nifan.cxl@gmail.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <shivankg@amd.com>, <sj@kernel.org>,
	<weixugc@google.com>, <willy@infradead.org>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <ying.huang@linux.alibaba.com>, <yuanchu@google.com>,
	<ziy@nvidia.com>
Subject: Re: [RFC PATCH v3 0/8] mm: Hot page tracking and promotion infrastructure
Date: Wed, 19 Nov 2025 18:36:24 +0530
Message-ID: <20251119130624.74880-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251110052343.208768-1-bharata@amd.com>
References: <20251110052343.208768-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE35:EE_|LV8PR12MB9713:EE_
X-MS-Office365-Filtering-Correlation-Id: 0156d9e9-bc02-453c-872d-08de276c7eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AeglHXnugh8yrtH9YWEWE+q9Of5G7x+LkQIMpBuhbtdkNH3/g7KWxkstVCGw?=
 =?us-ascii?Q?SjH+p4psBSpKmhAUduOWIZn+aoUdLKpiaCc063HV64GjdXv8lCqbn3N/zxRv?=
 =?us-ascii?Q?g7vwISMfP7ZHAcAQRcvSn/dZg/cN2x4718oaXZ3zClznx3nhJC0QM4Tu2qjr?=
 =?us-ascii?Q?pT/Hw1s/mjNzLyeWoA8H4Ekrnr5nQBROsbAeuvfeEG2irA/GzmcLSnK2RtAU?=
 =?us-ascii?Q?lfHh1rdVAegmgceDObDFNQefRtTCEI0um72BexraJe8ZLju8Z8GqQEc39yQY?=
 =?us-ascii?Q?QICq9HpldrtVlYfitzUbzXv3omDtz8feWH+QDeCmgfFq89xPlH5QkcZYtDCW?=
 =?us-ascii?Q?1dgJ5bMklKHOSQRjdCmFVcsCHqDaFK8V3bx65OHs7pFR+C0cgm+DL9yXN6dA?=
 =?us-ascii?Q?pj9xHGD957KK4Skl+PC8dc/hdyC/ADhwkKBKBbOdOnO4ubUFjSkOkOtFGRql?=
 =?us-ascii?Q?26Y/oThKSSdenxHKjmGvdNJAnEWbmKSHUnrBZZQHws1rlkVHkDhBXjhLKNH1?=
 =?us-ascii?Q?5V5rIMJnJ34L+mzhxWpMS5LsXAm7SnN1pBBpxIf7FoGSCRLZLP3iZeVwFcPe?=
 =?us-ascii?Q?txK5wkFMyFNYjc8mZsWuY83ggSNtvRDE374hSIrTeBGkqlZFuSA8fWwHvLDo?=
 =?us-ascii?Q?fJBhLJ16xk45UTwH+Ckx6uCN2om5rFCtnZuur63zmp8ZqDYKB5M6JiU/Iel2?=
 =?us-ascii?Q?6EyhBGfJcrpm4+1u1+F51bdn/ziAwy5MAQrNuZYrcJ+fSrN9lwjUt16WaDa4?=
 =?us-ascii?Q?heKtxqJBHyKBpOdgeVKxzg0LYwwnjb/wE5BMibZPCGZsVb0FYXnIwVbSx+tk?=
 =?us-ascii?Q?aua81jXgKvuLsK+c7gVOKXWAoMz+I4BrSXutRvyEG4U4+pmCACVaZxzgPgXl?=
 =?us-ascii?Q?pO3YBT50S+n9B8uvQVG8pe5TpKyR8K9vTw8JY/pSTtwyLxv55t6MH7DPefLV?=
 =?us-ascii?Q?cCSIxcFDoVfH+GhY1KcJ/8Yk/MUMIT+Lxtfc0AABgrIaKImtZYk0bU8fkolP?=
 =?us-ascii?Q?JaTVK/2F9uSqh+sBJMUm1UYCmM+PPgJ51oW/qGJBuPkacWQ6aRmIgAIXV5z/?=
 =?us-ascii?Q?orMYoBpC10Rg3nr8Jw03jnYcGbvLis8SuwpHB1RXbo+GHUYgdklngr8VNdva?=
 =?us-ascii?Q?ohwg0KzA0cX90cedwDN63Rp2b9iY2Fpdik6yA9dU7w43gc/VjrcxXGmF1cAn?=
 =?us-ascii?Q?cEipowBdsFHxwnuUiKWCm8sqzehnGOSKmQcPUbWHW4ukNeKF9GIxqd9B6GVa?=
 =?us-ascii?Q?5jZ4B27t5oWJIiRhU1SoaeIkf8c9inlAb0ABDdUQ8kwhGZPIAeMOy59+B5hy?=
 =?us-ascii?Q?f40/PsHpmjaPm7jsJu9VCSgwzYXe+9CIj/GZaTBfNnKs4xIeCmIcyo9gsSvx?=
 =?us-ascii?Q?4vOVSw9M1z5iwcuZY07yb16jxrbxVtmvZ3CSo9a7HEgqyr6tXcXV6XSoab35?=
 =?us-ascii?Q?bLha5IjbemB5RKF7PR3m7iTbGx1/ROvL4GMnmCxm78hjrx0lx7XzZdXYFdj5?=
 =?us-ascii?Q?UIYVrNqsC7L4PWosBzqoY+ByDgWN+z3Y82vKRqV3uSu00SYHaeqNvWeohO3q?=
 =?us-ascii?Q?sMPCffaa9bUHei6lrcA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 13:06:46.8135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0156d9e9-bc02-453c-872d-08de276c7eb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE35.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9713
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 921B980022
X-Stat-Signature: eny9d5eceg4itmgeagcqs4isz49h5gu8
X-Rspam-User: 
X-HE-Tag: 1763557614-118599
X-HE-Meta: U2FsdGVkX1+eQpA6BFgaIAYXwJaqyFNgoJH/cxR1eHDByfhJAWYAEG82eFwRi6NEZP2JUbKC8S9yaR7cusNJK14UkmgmHk3wdtQ8ItP1JF46X+DU9e/fHsjEe4U4po2sJDWjMfMHyGKdLoHwspPqvajbr0MTAV5NaXsieLOtrxTQ6NL1YVMTOT7QTnm4NcH5B/WFr6HTMRXPB/5B7zl2IMIvqHxmdDZ9A2V/Lr9/TZXFF/rc5wp20ZvimKvQrckSO986VevyciD2xj/6izZXbvnZObTJRl6n9AyWHs3wAXVlDD4VvNyTdy4eYz/IOmbIexoYwxQBi18NU+6cl64LuhWBHHMloU4odHfHaOr6Iei+MhEPCK9jP+bhGQCCKP469yD42wfUErC8ovcWQUome0MLgkq7jQiodAohTT578qcCru7Q2cBnE/iMeJ/A//p+pAM8qxyV9MaPQ3tigdGyzyz8/d5J9VCRtwEGem7jKO60jD7J8OOdzyRsNQIHdsaUd4VMbtb18DTGybYjBN4B3ekM1m6bDLpQfu/KRyJjS5N4xFPXbVpzJgb56wB6aLx/0y0cO8xLgBjUcM4mH+AprjWhy2+SZpx8Q3HLIeDGaCYwUXwh0tFL1ZDzFhgySurYteg7yS8p6sVVDbLHv7GU+4+nBWnb2OB592Ch4Dsd3GhUVkaSnmoE8t4Z8Miej+Hl4pxJSGKuNbseHOwsRsY04A1x2oS6fu4qu2fZBSEYcZZjkT1XfODqqbbZ+PRbV/dEsBZyLO3MiFW6gXPJJZtqNek+18elmDSclxffq9MXQwdbBBc2VzMhTpuw69fELmtD45H9d3rmVUXks7Xb+YXeRMJyJj35pV0iDxLyi1d4NAZiSUqUKRo1j0O3Lm3ecLycFJgN/XHtnjtpcagHSgozSZMtSXcWuXJ8X9t/gkuZSVptEbAgrlhevYskRtMYOT7us+IXH9yQ78dBrpdLUeU
 yTVdoPEy
 joiE2G5pUN9IVYgSN2kYd43RGDqEhp38Wlf0s6UUPOP+hPQ05eBG8UwcEaFOUH7jLIqNZrdGqMxKt5SlP2zv5EE8DsG2WwYm5TuisWc2nNbGHNxz2B1Hik/gVaIDyFbTSwy5siwoE6RPPjGP3K3ZbZpdZYIqRraCSC3Be1rFO40hU+PS3rZzK1TtdI6TmjIFRgnIHFM/BCjEFbHWyfq73ayGOR4Fr44df6hF1ccCLU8BxKDhchED1Xh8KODuyLtNScQrUenvMlc2rpnn7SlgpoM83pf4zq7dXtfSRGll15MxS4zEoEvgnd768LX9fxzBcpbIHpCZ+EvSkC/E12INrfppTMrfdmXHv2UO89sx3SxnkplD4ieiKRh5jTmfpul6N1wQcFIjjbH7xvJTDykRCaVr6UiiCBrosFfJPqt6kkItT2CNrnlFU+sSHtU7i1xk7SjZxM/HrWR9Cw2ktmKc7Hb8htP7zwWkeVJoFENF5LBBPANLvCTlozaYTi5fequGdR0jGMsnBn7VuUJLMPVXH4xhQeQaKot4/aDpq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10-Nov-25 10:53 AM, Bharata B Rao wrote:
<snip>
> Results
> =======

Earlier I included results from the scenario where there was enough free
memory in the toptier node and hence demotions weren't getting triggered.
Here I am including results from a similar microbenchmark that results in
demotion too.

System details
--------------
3 node AMD Zen5 system with 2 regular NUMA nodes (0, 1) and a CXL node (2)

$ numactl -H
available: 3 nodes (0-2)
node 0 cpus: 0-95,192-287
node 0 size: 128460 MB
node 1 cpus: 96-191,288-383
node 1 size: 128893 MB
node 2 cpus:
node 2 size: 257993 MB
node distances:
node   0   1   2 
  0:  10  32  50 
  1:  32  10  60 
  2:  255  255  10

Microbenchmark details
----------------------
Single threaded application that allocates memory on both DRAM and CXL nodes
using mmap(MAP_POPULATE). Every 1G region of allocated memory on CXL node is
accessed at 4K granularity randomly and repetitively to build up the notion
of hotness in the 1GB region that is under access. This should drive promotion.
For promotion to work successfully, the DRAM memory that has been provisioned
(and not being accessed) should be demoted first. There is enough free memory
in the CXL node to for demotions.

In summary, this benchmark creates a memory pressure on DRAM node and does
CXL memory accesses to drive both demotion and promotion.

The number of accesses are fixed and hence, the quicker the accessed pages
get promoted to DRAM, the sooner the benchmark is expected to finish.

DRAM-node			= 1
CXL-node			= 2
Initial DRAM alloc ratio	= 75%
Allocation-size			= 171798691840
Initial DRAM Alloc-size	=	 128849018880
Initial CXL Alloc-size		= 42949672960
Hot-region-size			= 1073741824
Nr-regions			= 160
Nr-regions DRAM			= 120 (provisioned but not accessed)
Nr-hot-regions CXL		= 40
Access pattern			= random
Access granularity		= 4096
Delay b/n accesses		= 0
Load/store ratio		= 50l50s
THP used			= no
Nr accesses			= 42949672960
Nr repetitions			= 1024

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
	 in the patched case. No migrations.
NUMAB2 - Existing hot page promotion for the base case and
	 use of hint faults as source in the patched case.
pgtscan - Klruscand (MGLRU based PTE A bit scanning) source
hwhints - IBS as source

Time taken (microseconds, lower is better)
----------------------------------------------
Source	Base		Patched		Change
----------------------------------------------
NUMAB0	63,036,030	64,441,675	+2.2%
NUMAB2	62,286,691	68,786,394	+10.4%(#)
pgtscan	NA		68,702,226
hwhints	NA		67,455,607
----------------------------------------------

Pages migrated (pgpromote_success)
----------------------------------------------
Source	Base		Patched
----------------------------------------------
NUMAB0	0		0
NUMAB2	82134(*)	0(#)
pgtscan	NA		6,561,136
hwhints	NA		3,293($)
----------------------------------------------
(#) Unlike base NUMAB2, pghot migrates after 2 accesses.
    Getting two successive accesses within the observation window is hard with
    NUMA hint faults. The default sysctl_numa_balancing_scan_size of 256MB is
    too less to obtain significant number of hint faults.
(*) High run-to-run variation, so the average isn't really representative.
    Hint fault latency comes out higher than the default 1s threshold
    mostly, preventing migrations.
($) Sampling limitation

Pages demoted (pgdemote_kswapd+pgdemote_direct)
(This data is not really a comparision point but just providing
these numbers to show that the workload results in both promotion
and demotion)
----------------------------------------------
Source	Base		Patched
----------------------------------------------
NUMAB0	5,222,366	5,341,502
NUMAB2	5,256,310	5,325,845
pgtscan	NA		5,317,709
hwhints	NA		5,287,091
----------------------------------------------

Promotion candidate pages (pgpromote_candidate)
----------------------------------------------
Source	Base		Patched
----------------------------------------------
NUMAB0	0		0
NUMAB2	82,848		0
pgtscan	NA		0
hwhints	NA		0
----------------------------------------------

Non-rate limited Promotion candidate pages (pgpromote_candidate_nrl)
----------------------------------------------
Source	Base		Patched
----------------------------------------------
NUMAB0	0		0
NUMAB2	0		0
pgtscan	NA		6,561,147
hwhints	NA		3,292
----------------------------------------------


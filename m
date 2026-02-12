Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 711A7ECD6F7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D149B6B0089; Wed, 11 Feb 2026 21:11:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0416B008A; Wed, 11 Feb 2026 21:11:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7B46B008C; Wed, 11 Feb 2026 21:11:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADC816B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:11:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5CCDE160710
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:11:43 +0000 (UTC)
X-FDA: 84434178486.16.D875C2C
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013035.outbound.protection.outlook.com [40.93.201.35])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3051718000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:11:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ym1hKb4T;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.93.201.35 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770862300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uO0w7gDqk/Wd/D5YK0j01A0zbKeGQW859m5zTIR5WGw=;
	b=yr2BSfZYwMPeHCCjksIokVBxK+ymOLEkIX4yAjLu2QYrYs+/CfOc6MQlKWaKeUSARUni+O
	HTH8ZJQZ2BpY10Rd0Ts23s+7kLhciqomiV7KnNEQ/dczBxKodvQx7pDIq9fT8UyQR3r56V
	VYZzDCLAggskbEpJodXXguRBA4aUsWA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770862300; a=rsa-sha256;
	cv=pass;
	b=sdFNV8s8qXRSD8O8iyO3f/0D+dKH0nFB114cwu2mduErUMovVpMFal1LwuWLGUNjE+dPEX
	6tAg+ureABZ8jmqvNxba46y5udpIYP559lTGJssHVtXNwsOEIf9vcq1bbkx+B+bgkOCF6o
	kFk1StY7tpO4XE0yrZNy6t9CdwUOaB8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ym1hKb4T;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 40.93.201.35 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oRlZSHKnbhymIrJQPT4OQkQdNfb+CgUMtHiV+JTSezsD/aEDsENCxkOIlhMW7LSVTnm7gf+J8+uwPOUeQaH19zK4GAeOC11/3eLK6y/U1ebwgK1mnjOx5xP0fqL14RPn3jALANXqsaE83yn8n3z9Qgfd9grCi+QL5P9okculEJbZ0pyJyC7TAt2favkxNAXc6Ns1LHvj5kgkIXec2USdyPTvukWRxoO8Iz2VepkjAxSmbCSuJEr500p3V0/lenRzCubKH4oDfLEh3cWQvBdJ9PFjWhrMY5SjN3fuendC8BnLNz0TAQi3IO3FQgvsMYBD9bleKpPeoZLMFPoCQgqU4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uO0w7gDqk/Wd/D5YK0j01A0zbKeGQW859m5zTIR5WGw=;
 b=vluH+to//hDzPM9QreS9H5IfnJcT7Vg9Xqp75L4s6wDZl+0L2Xh2KuZrIYSWfdrtYEwcI5N5Fr+n/7lFhap5JwJSiXpciiLxY8DghHDiy/AX8a1kAPhql4WG6G8eu29W96ofb4exbcAVZRcYKzbtxzttFqN7yUvDBtW08ubNK0g72sirW1oiDN/nLO1pBAQPEU1JpDOmgeQBFLUoue22nkwx2Ete1TFLiSL6tX9yryuGpK4RK+8PKqhg2rc4/mgQAbCGyK7nK9BNj+t+N6AhQDed+RFGsCpL6B+UL63FWzYbyo3IdPsnp1EwIdjrPQezf4wPFW2OQxuueXhuP9ehnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uO0w7gDqk/Wd/D5YK0j01A0zbKeGQW859m5zTIR5WGw=;
 b=ym1hKb4TY91vwyhT/tj4cz3/O6tdPmgKBEyGqxQyHKR6UlYxxiOB9pyHxkHgaqBsKmDDuet2L+lW7U+i1AFJQxsA49Lw/N1gK42UCwvREF3w2DS9UYYifhosZQYOYwQevs3f7j9W82MeBkTqQzxtGMVUm9drVBtkremJmzsyil0=
Received: from PH5P222CA0005.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:34b::16)
 by CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Thu, 12 Feb
 2026 02:11:34 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:510:34b:cafe::8d) by PH5P222CA0005.outlook.office365.com
 (2603:10b6:510:34b::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.10 via Frontend Transport; Thu,
 12 Feb 2026 02:11:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Thu, 12 Feb 2026 02:11:33 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 11 Feb
 2026 20:11:09 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 11 Feb
 2026 18:03:52 -0800
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 11 Feb 2026 20:03:44 -0600
Message-ID: <69ff289a-1574-4d2e-a987-f47f1859aeb1@amd.com>
Date: Thu, 12 Feb 2026 07:33:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 03/10] mm: Hot page tracking and promotion
To: Gregory Price <gourry@gourry.net>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>, <shivankg@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
 <20260129144043.231636-4-bharata@amd.com>
 <7c6d427a-9fe4-4af0-93c8-18ecb2296e36@amd.com>
 <aYypm59N7SlS3Gme@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <aYypm59N7SlS3Gme@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|CH2PR12MB4326:EE_
X-MS-Office365-Filtering-Correlation-Id: 867d62d2-4201-4c15-a601-08de69dc0b43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TFNRL2E4WCtPS2tPSUd0eng1ZldKSWxEdGVQT1d5WlRTdmJXaUlpcjZ1U0Y5?=
 =?utf-8?B?eSt0VFBRcGJZYWRmWVlnZWJ5MEluT09PUjF1UFhIWll3RnR6eGtPN3R3K1dx?=
 =?utf-8?B?N0ZQR0RsMXFoWm1xZHlPVmVZS3NCVGxyMnVIVEpCTm1XM0FzWHcxRWFUdVl4?=
 =?utf-8?B?TWwzVXJJYWUydkhYYXpMeEZsWXJFK2F2VEhPNVRlNDBLUC82Q0ExTGQyS0Yw?=
 =?utf-8?B?RTFMZEpMWkF4MkRzRVQ1K3A3Ylk1NGttbkkra3hSaXljL2toSTdIdFpoVGpB?=
 =?utf-8?B?S0FqTDF1SWFFbk10RGovdFJBTUUrL0lJT051QTJsaEtHKzl6OHVIM2dwVEFr?=
 =?utf-8?B?QVllRkdoeGJsRWk2d0RpYTJtcGx5Qm5TZWZxVUQzUVlKTkJFbjljOHgzNk90?=
 =?utf-8?B?UjlPR1FLdkRYc1RvSnBNQmR4R1JrU2FDTHBRcnBjSW9tRW5yYmdmZ3FvTis1?=
 =?utf-8?B?ZitqSzJVbWRPcG1zRGEzTVN3bFlJeEJrYklMbk5yWWpzYmpndTE4UUNWMGJL?=
 =?utf-8?B?ZEd0QTA2UHlmU1hzTjBSWGNLMTJGT2RUeW9Ha2w5MWZOL043djhUTitkL1JJ?=
 =?utf-8?B?dkFvN3dmWVpZdkl3SDVlQkhmd2g0WTc0UXRPQ0ZjbW9LMkROM3dDN2VWaGw3?=
 =?utf-8?B?VUNGV2RleHVXY051L2pNWmRDZ2pUWmlYOEFRaUZvb1BmZWMxYSt5c2c1ZkVD?=
 =?utf-8?B?eEcyZm9rZi92aCtod2dlbVFOc1lkSkN0cytpM2Z6ZFRPS1dkem1LaWJlWXRs?=
 =?utf-8?B?VlVjZUZjdFE4dHdFRW9uNy9jclZ0RzF3WTF1bzJZTW1vSVlSSzdxTWxxY2lP?=
 =?utf-8?B?Z0Q0MCtEaVNQQW42YTJjU0tXNlFRTVBXSXJKc0pRVnZuVkRaRnZieTZuZ2dk?=
 =?utf-8?B?RllBQWlZWHJJcmp0NWxlb3hGSHVIaGJaT2xtekVIY1dJYm9zejYrUmhmdnFN?=
 =?utf-8?B?UzJjRXlPa2dkYmhiQy80N3NwbnBtdkZJN2JjcVFRcjBRdm9uY3BMWEFGeXNr?=
 =?utf-8?B?bGc1cEpJWENhRGVEeGNBRmNjbUVuZy9WQXBPTHpvTWE5L3o1eGxwRkFUVDFw?=
 =?utf-8?B?TzJjb1N1amVRdkt4bHFsU0RCeCtscTNLbnVPQVAzdHdKM0xEbkVXWHI2UWN1?=
 =?utf-8?B?eEVySWN5b0p5K0h3OVMraFBhMk5TdDZqak5HMXBtU21ObzUzVjgxVm0rcTZR?=
 =?utf-8?B?THBLK245RUxrTnAzeFBEVFNGWWExa3RuL0FTbVFZT0Q1V2Z1MG9BcExGVmdl?=
 =?utf-8?B?QWJlVTRaOVlLYWJxNXJ0Vm1EbzcrbFNHOWRHSTZGVU9mdENDR29oeFhVajVS?=
 =?utf-8?B?eHN5UU1hVVZVTXdON25WSy9mY0liZVovbUJEdGF1VmZoQk5lMnlvMEV0UXpJ?=
 =?utf-8?B?MDl3dVg4dktJeURERXZ4aEdnVVRvd2JnYmtoK0ZkOWNMelh6SEtwQ3UySlRB?=
 =?utf-8?B?OWJPMzk4Zk5EZG9ndi9ITVRpUVU0RWROaHFjTHlGTmFQZFpOV0VvR0kwRVRO?=
 =?utf-8?B?Si82SUxuNTJpZmpENjJQeGFINUZmZXlHMVVQNU90bjcvV1puY00xLy8zQ2Yw?=
 =?utf-8?B?cUY5dEd6NWp0R0xPMzZ2aFJyK29WQzY1Wk1WVmluckdxRnYrQUdIK3VhUnRz?=
 =?utf-8?B?NnAzRW4zVm9ENlpnU29Mc2UyZ2RKaWNKcmsrd3pUcTNPSm02QzVPQ0crN1Fw?=
 =?utf-8?B?aTBSYXZNMFpmVUdDRmJPYVZaYjhDWW5tQVBzWmxOZGMrdzhYdUN1U2dJMnBE?=
 =?utf-8?B?MkF0bGgvL0RKRGE2a2J2RjNualRoTlc5SGpIa0tKRnZpMXVCRFVrdCtxbEJ2?=
 =?utf-8?B?citqbzAyb3dRMEsveDRKYkE4bjMzUG1LNjNqcTE5OVlNRHZmekFSZG15cm01?=
 =?utf-8?B?ajJlWnZtK05qRGc2UG1HekVZZGxwd0xGL0hwVGI2eWlCRkFDL2M0M051bU5J?=
 =?utf-8?B?dXdYRFJ5UnNSbExnTWxOeXRoY1V0WjRvT0g5MUQ1MGU0WnBzOWlsOVRlak5o?=
 =?utf-8?B?SzU2aTB1eFd0Q2tuQW8rOWVZSlg1Rm92ZEc0L2dRS1ZScms4S2ZmNTVLU0Ir?=
 =?utf-8?B?YmhhQzB4ZCtlN05iNlFQdnUvandvdjJEUmxGRit5b0ZQbm92NWtVdnZzbWV1?=
 =?utf-8?B?cEt1aHVPZ1RHRnpUS2ZwVzVmZC9IU1FvbGxoaG54SXh1ODIyRHdPcklIaFdu?=
 =?utf-8?Q?almhEcA+R77iDDWlY7LEEp2BJ24jGV3XS02t6QFB2JH1?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UKWikq60RrfJ0SmFtY/4dFx5/FSbrRGj+uz3rMwCrA8Y7EysQkiAwtDEge2yF30m0X46GVWBR02cOCqkVYE0LnLnOcvp11uKlUaQ6VhYxLUYsERjDoTFEdhHWWOxCFcQczuCYLVDk+GH6o1iqfI6sPzvNASL9PTubFmKekVt22XmnrLyzm1yBVjmJHjlLT2IZ/u2PRkIsbIjxgMOJmmdFisPNIvRkoHzC5/AGSWIEWkkNbGGB0kuOHZME7C6lVgNRkcOlGbjuth8kuKm7kZre5g0RMwRsRqM3A8XberJHBpezv+XzG3n/H8mHK3UtBe1/9E8SoSXZlwhaO/SVD3X6cIDQBaf8yxa2Cx/4BpDZZsuye3B7C63GCbFvgD1zidiIqmjLZlQE4jq/VsFCFgEhGt1YMg/PhsYb4/3HZoml6XvsjGFcxPt5Ut6o1KZy6DE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2026 02:11:33.5140
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 867d62d2-4201-4c15-a601-08de69dc0b43
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326
X-Rspamd-Queue-Id: 3051718000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: h93p97fcink1h6hmqyc817b81tcm8mnu
X-HE-Tag: 1770862299-596174
X-HE-Meta: U2FsdGVkX1+F+Vy3jaoxz7EsFeJthSsPS2MQIFeZfebuf6lG4BxOcvvEo81hJ6P6w+oEy97HWdtx3+C+ESdLox6B3E2tBJyVtaMXJbxmbxuFG2UAj8A1hXI/a69NkwVcCPfOAdnAXB+UD1QDO3Qf7vVU3Ds9WIz6jBe+a9xFq02mcXThq2T+0qc7+JYiiImbMVYD+8RhlMpVn2uZteQxGLwwYKBpb656/yLArZNJpoLUa/4fdVpcvac/ycWyIKn38UKgvqOTo95RF+dy/+oCEXX8kiZst4Xif3AU4k8HXF5Sp821AfnfoanudydkH89bdWbSHTceg7nhgTEJEuoTsRytLo/hsm6CQolahpkiacjCwv8MNEneIhQyH2RsrlRYG9jMRCcHhl3RsFuQe5RRuK711h8AFJC8M2G4zC8jod0xQNS4tg10+kc3MPAle75NoWAh+FRx2vN8EPcz7wBQd8BEW6NeFJ70bd/+2xZenU5Va20nUsbo2q+1///+5wErLEEfS/EPLO7GDjoW+wNc8WqNkTyAJlv1WarQ9a09Gss0MYi/wJd0UCX4LZ//E6nfiWR971Zq65AZBv8+/vy0Zh8AJGsxevTL5Oiph/tOafaNHWzwWzknYernSkGm+XeJg0W7FcO4QJ6DpUY2sVWiM9+gEl959s7MoyGgEg2W15Q0ifFoZ+Kv0fAQUbmwokqDPuW99wXeAkbZiH6pCiuQusV5qvQm+XhM7hlKcM21W02TceRhbAP1Y6hTmUB9oX3xunFMTdBJNkFHAGBLYwaqb/NydcqkG/Jze0SbhZh7lKvmA2a4VMa/2BHeSSe5cpsWZvhleztLLMdBMH+/lPNyiUq8n6sbKdZD37SpK/TJhFdOgTcVpkjMaIkaXsw88xQQYo4KIL6f4JWTiVkLyd6e14HIxdjmFUD1agxPHHzS3oi7Ewz7XqppC+nIVASruDzYensF2R18A/ajFFzHQcq
 /RN9U45B
 f+MgL38os0ChTqazV+xqsFyBa9exjEKvtfnkTtWegIw5JWdiQxnyTMloHeQyRNtpDGFN1H55QVo8pp56LuyTJ4idj1RAMXPZ2THMC5K/BB9avkWdLPv8LDUHi2PNIv51xEMQtKuvMTtQwIvQ86ModJOSKFFqjIGz6b11pxmDeDVWzwlkpDnMajffMZZ/ZBACErXjRPxwHdANRkxrIFimXY36FV4UE0jAPcpIFhTs2AEphaS6/YYI6OQDacbwOlNv7+2dvjuijR/Bkq5ent6QKN63+YIPl9PlEePpnYzfrmnxTlZoFFwmln55TgCU/6hX4Uw2UrtzpamZc5K+I56b795Y+sfNJFgwsuh5cOKnlFX/5ZXhRpeTQC46EBX2HfVmP0sBOGfo1Eeo0mdrdtIOmM6/7T8VKIa+5lBzgjW4ENKQ7KPbd0kL+lq6lS4MCro8KrIQB2oInCe4pyvLSpXPxc4CApk1Rakq1F936HH4TGu1vkwo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11-Feb-26 9:38 PM, Gregory Price wrote:
> On Wed, Feb 11, 2026 at 09:10:23PM +0530, Bharata B Rao wrote:
>> On 29-Jan-26 8:10 PM, Bharata B Rao wrote:
>>> +
>>> +/*
>>> + * Walks the PFNs of the zone, isolates and migrates them in batches.
>>> + */
>>> +static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
>>> +				int src_nid)
>>> +{
>>> +	int cur_nid = NUMA_NO_NODE;
>>> +	LIST_HEAD(migrate_list);
>>> +	int batch_count = 0;
>>> +	struct folio *folio;
>>> +	struct page *page;
>>> +	unsigned long pfn;
>>> +
>>> +	pfn = start_pfn;
>>> +	do {
>>> +		int nid = NUMA_NO_NODE, nr = 1;
>>> +		int freq = 0;
>>> +		unsigned long time = 0;
>>> +
>>> +		if (!pfn_valid(pfn))
>>> +			goto out_next;
>>> +
>>> +		page = pfn_to_online_page(pfn);
>>> +		if (!page)
>>> +			goto out_next;
>>> +
>>> +		folio = page_folio(page);
>>> +		nr = folio_nr_pages(folio);
>>> +		if (folio_nid(folio) != src_nid)
>>> +			goto out_next;
>>> +
>>> +		if (!folio_test_lru(folio))
>>> +			goto out_next;
>>> +
>>> +		if (pghot_get_hotness(pfn, &nid, &freq, &time))
>>> +			goto out_next;
>>> +
>>> +		if (nid == NUMA_NO_NODE)
>>> +			nid = pghot_target_nid;
>>> +
>>> +		if (folio_nid(folio) == nid)
>>> +			goto out_next;
>>> +
>>> +		if (migrate_misplaced_folio_prepare(folio, NULL, nid))
>>> +			goto out_next;
>>
>> We should hold a folio reference before the above call which will isolate the
>> folio from LRU. Otherwise we may hit
>>
> 
> Also relevant note from other work I'm doing, we may want a fast-out for
> zone-device folios here.  We should not bother tracking those at all.

Yes, zone device folios aren't not tracked by pghot. They get discarded
by pghot_record_access() itself.

> 
> (this may also become relevant for private-node memory as well, but I
> may try to generalize zone_device & private-node checks as the
> conditions are very similar).

Good.

Regards,
Bharata.


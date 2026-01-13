Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078C0D2D10F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9F3B6B0089; Tue, 13 Jan 2026 09:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D066B008A; Tue, 13 Jan 2026 09:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C041F6B008C; Tue, 13 Jan 2026 09:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD6F96B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:39:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 526C01A8E0
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:39:02 +0000 (UTC)
X-FDA: 84327197724.20.B7C31B3
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4C015140009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:38:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="GvPl6RO/";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of bharata@amd.com designates 52.101.56.69 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768315139; a=rsa-sha256;
	cv=pass;
	b=ag7H2wLvIQxdovo5pQLfrLhvx5rXmKF77VC6R3+T3AScvJNoMsbGBQn5szY8KWn5TX/69L
	h4DQlXlc03zmfW2J2GXIPorsSYmHmtfPDI9445dRP5Jow4w+2cIccDPTEcs/djpVPS1lOm
	/RTLzQuTb8LBo62BuM5SuB0UxLJC0QQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="GvPl6RO/";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of bharata@amd.com designates 52.101.56.69 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768315139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zaD8uaJZlqdMlGv8EyQkeyudzbLBsVpBie5SFxS/Eqo=;
	b=VDUMl2AQmxCoU26CyTp2u452F2OQECs2m5QLbWNbNV37S54m4N+5EaL8lIIF9v3PvYY4hP
	Lk9nDO8XXQC1vxiW7pZkEJZBVp7w6U/U5zhOA2X/hkudNG81KpS1r+JnEW9g+tANMmXa9F
	jEAOSoy84zA3veBWkZuSNFynGi34S2o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=srXd+TCjfJ6R/e1fl2YDh5QLIl18+TKZbFvNCdJjL3R5t4xxK4wIO8xVpjESEgteePqj3AEuBpmmHbxQvGQPxSoCMBaFugUiCUPba29fswkKikK1xYhnNoEko2eldkZVo8Yt2xeyC+mm7bugC/Dbc1mqTSgF5xaheJPhXPJ6G/jcJmPVYlfy/kns55kkuolAibbeZ0skmY/0sumLcqrbemVV5IT1kr3kF1fGW5y3/hgtWck886Ei1Y3e1XgWL3e0CumbukXn3tWFLNEe8/nEcWTbu201kdK1GbZ59j6osjzkl5cnecCbPSQtrmfJtK8E3abSdKx0DawPMOQ06kk0GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaD8uaJZlqdMlGv8EyQkeyudzbLBsVpBie5SFxS/Eqo=;
 b=ViUztTrS4hRAGAJV5RYqiqi66pkz4akfLdMZte2WCA7cw9gXZ3p778vXnHXkRTVsEAFyh50fgAmWt7jcB5jXvr/PHN8SQPcJ44x0Lr2A70JwUdX6UAM7qfyUpb/IIrI0RK5pjyYWRDpTMMCWCbsfE4dNUUoXNOmtoqY3ymXUIrQujI8fMb8Dfz2d1H8gEu09zOhFvAzzzSA7ynBISZtKpgSoFb2cN7vB1MS56tdYurT/9sh1cOpjiyh6bgGEIJOzGpUhAb9rbWBTwZNzRg5VdNE+uAokRGB5jmEwiPdLxrwofu8JCRZGicoEu8BMpZAaCPhIWahBTnSHR27cfc7BbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaD8uaJZlqdMlGv8EyQkeyudzbLBsVpBie5SFxS/Eqo=;
 b=GvPl6RO/Zyogamnam9YA/joe/o3tY3dVznIgNZv4dOO+RFd9MEBCzxfCNqpq3UVTdWYyqnNJRFE0F3xKx9OQ8jGVOqPld3TSdo5/1eZ8fpZcTuWnwJy8TKpp4U0kggto/Ghd+xdAc/wVB2Sjs5xpMnJDNBOgu7sg07T7Ub5nI7Y=
Received: from PH0PR07CA0094.namprd07.prod.outlook.com (2603:10b6:510:4::9) by
 DS7PR12MB6117.namprd12.prod.outlook.com (2603:10b6:8:9b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.7; Tue, 13 Jan 2026 14:38:55 +0000
Received: from CY4PEPF0000EDD1.namprd03.prod.outlook.com
 (2603:10b6:510:4:cafe::7a) by PH0PR07CA0094.outlook.office365.com
 (2603:10b6:510:4::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.4 via Frontend Transport; Tue,
 13 Jan 2026 14:38:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY4PEPF0000EDD1.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Tue, 13 Jan 2026 14:38:54 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 13 Jan
 2026 08:38:48 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 13 Jan
 2026 06:38:48 -0800
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 13 Jan 2026 06:38:40 -0800
Message-ID: <b9aafed7-f250-4ce9-b8c4-ec9053f30348@amd.com>
Date: Tue, 13 Jan 2026 20:08:34 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 0/9] mm: Hot page tracking and promotion
 infrastructure
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
References: <20251206101423.5004-1-bharata@amd.com>
 <aWZVqpyzO3BikuJM@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <aWZVqpyzO3BikuJM@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD1:EE_|DS7PR12MB6117:EE_
X-MS-Office365-Filtering-Correlation-Id: bba1febf-138f-483b-7222-08de52b17a77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFRMV1h3dm94clpSUmFjLytkUThnTjluQ2VWVU1sS09yc0s3Q090UE53TytI?=
 =?utf-8?B?cTJCQlJ5eGxlajhjWkdRRC96bzYySGo0dzhJMUw1K0xlZHhlZDY1ZU0yam0z?=
 =?utf-8?B?RlFSWUtxZGtQYkU1Z2pwd0IxQUM3a0pyQjZrNWFud0V3SEY1WnExUnF1b2VQ?=
 =?utf-8?B?R1JneEs3dTlQTjZvdVJMbHJXRDYvRkdsZWo5Rkx1bzRaUURpR3QxMjRkS2pj?=
 =?utf-8?B?VmxkdS9uTTQxT1M2WDhWUHludXdSdE9zTXVsTTJkdmQ2THY3dUJGS1N2cjU4?=
 =?utf-8?B?a05LZytXMHVUWEtNK09CUDZvN0lrd1YvcXpTWVV6N2cvTWMrRWU3MlVYU0Er?=
 =?utf-8?B?WENiZzdnalJkV2VtUno0ak5KUGpHWEZkNk1kR3hWc3A3OHg1V3NwaTFOeVU5?=
 =?utf-8?B?UWt5NXBSbmVJdFVQMkNkUUJ4UklsU3RURmtJdDZrclFSSXphVGdRcGxyWWs5?=
 =?utf-8?B?di95RHRDMkw5NHhyU3Uvb2ZlT2ZqOVpEV3RncWtPdENVSnJXbWRNTWZwZXhB?=
 =?utf-8?B?c1VNc1YwM2NLMXVQeWg4YUMzUVd2K2ZGZytKWVFNSjZOQWg3aXRoc1d6Z3FI?=
 =?utf-8?B?QW5QS0l6YytzbjZYQm8wdDNmRFkxWXZST2ViNWNyNkV6dUQ0bHdzTi81SWdm?=
 =?utf-8?B?L3NXdGtjVVFxdW9oRitORytzM3VJR1N1QkQ1dUphNFcwazh0c2FSMCtHMWs4?=
 =?utf-8?B?TDJkQWVkUjJVV25HQmR4enN3R29wL2d3WmNuYUhMd0plMi9QZDJ2ejdKM3hO?=
 =?utf-8?B?QkYzZytBbytNV0NxVU1JNTBOeGVJdWphWkRzMTZiOHY5Y3MvbExkcXdDaStw?=
 =?utf-8?B?UzhXMldEU3BKNTlGbERJZHhCV0ljaTZmTHJBQVlER01oVkR1N1RaUHBHUThK?=
 =?utf-8?B?SlFpb3ByNkZhYytGVC9RaFlUbUliT2dqeVhWU2F1K0wyV2RmOVlIRWdsQWFB?=
 =?utf-8?B?bjVBZ2JVM21GZXh1b3hYZzVwRU0zRUVjYUZCTUNNQTVqNjYwZ3FvUHFEb1NV?=
 =?utf-8?B?ZTF4emM4aVZvT2o0RjJURWdFc2drYXM0TEI5VXRWTnovRS93ZlYrT0x6WmNV?=
 =?utf-8?B?Yk5LcjloYlZKZ05kUVIwdjVMMmpndlZFSit0b1czSmVNZnB0MW1jMFZUZkxq?=
 =?utf-8?B?eFVrNXZpYXNNdTB6QUJlckIvSDdLRDNXOC9NUWt5eS9yNjQ4WUJEdHBxbWVz?=
 =?utf-8?B?bWFTMFNsUlBxSUErU2I4K2dGZGtZL3Q4ak0xRlZDUFhnMHRJQ1lDVVhaTCtP?=
 =?utf-8?B?bGZ2b2hQK0d1WEx6dnZZbUJleXN4akxaeE1BS2NLa2IybzZ5aWtrdFdjQWF5?=
 =?utf-8?B?ZVZWelZya1pMQWduZUVpb05xb0Z2VnBWTnQrcFhtajNLTXlWcmZJdHBWcmtn?=
 =?utf-8?B?eU1RdlV1cDhxaXZXYXo0TFRBWlVYQTFESklab1FMamZWMnY2ZVYvVFJYRUc0?=
 =?utf-8?B?endra21aRDRGdXBJUi9QZ0YzdnluTlg5cWRTREhsN3V0UVUwczNkN1ZKR2NZ?=
 =?utf-8?B?L3lhNm42RUdxbGtGS2lxS3lkc1lqbFpOWmJRTjd5eG56b1NBZUZjL2dsY3BU?=
 =?utf-8?B?Zk12ZVJuZkJZcnJsN3BrVWpBTWRTRVlWTm4zRXQyMTB3Tit2VlM2a1VUNkVI?=
 =?utf-8?B?NnZHT3crUEM3Y2NncXRMODBFaWE4SXpMVGVNc0NaRm5XREFhYTZ5ZUJXQ0Z2?=
 =?utf-8?B?WHFSQVI5a1FBdlp5d2piUkxKYkkzaGdGN002OE1uN0RqelN1ZUVobncraGdH?=
 =?utf-8?B?eDBScms1c3JvcHlteTZiMHYvaWFBR3JBVmJjTlRtbWh3SDhTMFRnYmo4SXJ1?=
 =?utf-8?B?TC8xc2s2NXlYSmgvVmpqV2FMMkM2Tm1LOXpWcTQvNmNtakIrNXpQaEFwYWhR?=
 =?utf-8?B?QU9ZWThZOXpqRktCZ2JtdWsvSkE1VEFOUFVoNmFVRG9TMmRvWWZZazcvQUhM?=
 =?utf-8?B?RG0rd0pPajEvQTlwZFJXS3h6Ukl6YWU5ZU9sWnFEZENXOHR2SDRJNmt1dFVH?=
 =?utf-8?B?NFc2clE2YWx1cXUwQ2VuWDFXTGxJbnBYTXRKTFFKRkYxb3A3TmoxQ3Q0UklQ?=
 =?utf-8?B?dDRwNk9yWGxKNE1ScjFyZ2FFc2QzWjI5SHlDMjVtSU5vM09YdDRpM01Sb3U3?=
 =?utf-8?Q?stLM=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2026 14:38:54.9083
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bba1febf-138f-483b-7222-08de52b17a77
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6117
X-Rspamd-Queue-Id: 4C015140009
X-Rspamd-Server: rspam06
X-Stat-Signature: e395py5mcmmy7st46iybq8eicngpx5kq
X-Rspam-User: 
X-HE-Tag: 1768315139-331764
X-HE-Meta: U2FsdGVkX1+EaYWB3LZWi7f4KZL5yNhAdZpnJlJmGOhmj+1t6dTFvTQaEovTMzn5kXDezjhNGD891pd5V0lYIeXH57GQPv0MtnZvvVuJlJFRkHtmHa8NdhkKwFg1uwRNP2VjbJfjrDOtSF3op1SrkABK6Bzc6WdG+8tIlK+kt08vGuCz/oGrUclc3zgPvH82eZluckXnAxKGm+Gv1Fp0fC1vnn/5drhRmWj7EVE98ANUHK5J3Mn0vqb3CHu6a0vCnNxEkRPWArNhFE/zeAWFviKgMMaRKgkkl/75qwywyE3IbnHGuo2zbNeJ66I7sT3qjwoflswt6ZXmVzdppdDSPVAQ/7aE/IvXXPH8uSnLtpc+xgE6cxRIzS2lVbVM6O/iqZzHiBIhambpF0IQao9y+PQggoVHnDbhuBw0oFx/cUJWPVeHEXAsfUCCmt7Fd6IY3KciFHm0qP34OAtLMJP2gu+qxkoZaRDfMOOLkQJTJMKnvuKaoxK9yZB4GtM+5sScrCtZqvKCky6A2+a8TvRf0g3/U9BHchzYhFdaxpjACKimjZxwnN321mh/wZFD05sLSolh+VjMAQ5vnigmPM4G6OPyrRQVkdkkntOhHuPCi8pI/DKXQ+koNPgyCHUTarCs8co9EjEwXhxpuycqzKcu9I4pNIwepql5uQ1kZn0W+m6h2JvEpg0CcEam3Ly2+L8Zefd42Y7RCxhyhscRAzG1B+1ZGlhiia4R6D0z/Ut8Pwf77/vmkt8QqTd1LxnCdQ30ms5rDkdB4txUGa/vyhurrcvjvpPsyxqoxZkXQm6muuLXjWXkC+rCmaF18BHMDEhRD+37/ncdg0Pouga/RXjJ93Vb8V8/oPKeC9vBq7gRlKYnJ93R3iHMtNom3znqRwm7nuYXBM5nTUl6gw61tlbqQMz/SMtzFK7WMjPzF2yTP9f3vzRPKyj7X2yMghaGMVC+2iZmw6xsqY4L27HVxxy
 Ui8VBSB6
 V7ZL4kA7dFQ5QVNR5Y7+vehAayi1/yrGYjAFfenRWW1FXADM6vk2u68+TqTKt6lZyDCAL9b1/pW0m3wF3Ep2wk18E07DcJhCcg4tCX+kzpveSLbB8Y9Cspmr9QM6MlcgbEOoWIR3DjaPOQ23zBxbZ+3U5Q69PF7W3xbcmw+gpg/qTeuJFdoE1NTzH0LQYR7pcurLk9DQGFUxvFH3vfzKGtzpnYEhk+gUHGBPcFqaZQCSa/KQns+9LgM/0y/kCiRPiGOvK1/NLNwYy4NLAC4eM1nvEm5W93b8mhqxXktqFcv4PPXKGt0b3nKvY35v278fpAjoQfTpfMbrk4TMNa1527Gg/GhZ62Vhy6KJIk6Zsh080F44niwYAhfr9CeZTnbA3/Wh9sMvD5gCYvHl6U9oz/WlT1TpCPRg8JnNJKxvTADeeXGSpdp7PC6arfT3EqxGU0Q5MTysidRF1FF2HwLthspHBYQiEqIQ3BCxpHp50uk8pJiI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13-Jan-26 7:54 PM, Gregory Price wrote:
> On Sat, Dec 06, 2025 at 03:44:14PM +0530, Bharata B Rao wrote:
>> Hi,
>>
>> This is v4 of page hotness tracking and promotion sub-system pghot.
>>
> 
> Just fyi, we haven't started real workload testing, but we're setting
> up the process soon.  Just wanted to let you know it's on the radar.
> 
> We want to test this at the same time with some fixes we've been
> working on for multi-tenant fairness in the demotion/reclaim path.

Thanks Gregory for taking this up for testing.

I am working on v5 with following enhancements:

1. Default mode: 1 byte per PFN for storing hotness info. NID isn't stored but
promotion will be done to a default toptier node(specifiable via sysfs/debugs).
Frequency and time are stored but due to paucity of bits, I will have to use
some sort of bucketing scheme for storing time like how current hot page
promotion logic does.

2. Precision mode: 4 bytes or 32bits per PFN where NID is stored in addition to
time and frequency.

2 is completed and 1 is in the works. Once I get it working correctly, I will
post v5.

Since there were a few bugs in v4, I think it makes sense to start testing on v5
itself.

Regards,
Bharata.





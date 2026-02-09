Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C81D4EF0702
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 03:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08AC6B0089; Sun,  8 Feb 2026 22:26:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6276B0092; Sun,  8 Feb 2026 22:26:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B136B0093; Sun,  8 Feb 2026 22:26:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4A196B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 22:26:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4262E566C2
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:26:09 +0000 (UTC)
X-FDA: 84423479658.25.16F9580
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011058.outbound.protection.outlook.com [52.101.62.58])
	by imf17.hostedemail.com (Postfix) with ESMTP id E526A40007
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 03:26:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gpyFunWl;
	spf=pass (imf17.hostedemail.com: domain of bharata@amd.com designates 52.101.62.58 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770607566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YfVgnFdrgMwDcI68SxeQ3JawHVwzclr6usNz7KDJecU=;
	b=y7Qw2t5zUwJLXwmoh0O84sE4YTYgIWhUz6Y/O8hpqSMQdIcl5fe6noBAiaDYM6ON28R2u8
	6+FWX6MrVL0pGSTZK0yz9l6x77JI+6OPxTFK+VF6r1nNaZcNDuLuv31YqzmWrfGVeWd/nJ
	FkR4LjdVASnVSor6eAVhJhHgdNUlTP8=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gpyFunWl;
	spf=pass (imf17.hostedemail.com: domain of bharata@amd.com designates 52.101.62.58 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770607566; a=rsa-sha256;
	cv=pass;
	b=tgwUXLsL80BBTqlGIX8rSFwdvi/aFqojSxDy8rwyC9diLHJvM/DVGzP2QnceP6CqfKNfcj
	/rTKsWS4JjFHmJyBvuBlvrk6NpC1TxCu51gNJJm94uVgJOpdcvoIDAEKUuJ4w/WRMGTZ+3
	ZJTsmDCLRTEH3TTHGkBcfarkLYQc3dA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VR17x5vjnITxfVn27sWgNlNKIEFe/xfHwFGrbQLIZpmEAru7WICtcDrmwratfvP3IzS52wzDox+15kHUJeeg/iMwHlnB0g8NnGw4YACOfrA2+tx45uwtkfR4VweSNhqYrwOsFCIEOKRgkwz1uedJMXB+nXVBLmdH5ifboSfeDfMEBaae13gM8VCYHi3BW/NJmOfequFKjmHo0+4C0feCUWgbnmNZhs0Ls4hw5oX6Ne44SbAFJQe/ZCda/ygo+hc/gSps1GkHUioh7UrH9N7dVn5HuazkGjUX4kE3g0RUWissHGMAGQe1kEaXS7bBln0KEhmw41kLZOeYu+F+KTVJhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YfVgnFdrgMwDcI68SxeQ3JawHVwzclr6usNz7KDJecU=;
 b=wfGiMfcuyABCqF/3qyA6/aR7djB9+GP91RLNhbYTujq1a2HeSzY29pN9L+ay76BnUTCNMCVARwvmX6wrst0nD2+UVjjuU1sK2Sqaz+QokAw4Eu6S2+sxgZKeXrOtpUloi2B4A2cLkkr2iDHDWeVkpkrIyCCrsKTjWyMuptYRFodplC/Z74YzB3Bvuv1Dw+2NY4et5/Ejfr2AOzOrw71bk0Tb6y88Mfqu519yL4//mQ623GLlEiOBk8CwXDk5BSePNNQcNwlt/EAtXEmM1GEF24mLmnh5L49Rd0XBV8B+Lo4WrUC1RBxwxsw6+oa6yPRfhjPNlMaXryMIm07UsZcUJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YfVgnFdrgMwDcI68SxeQ3JawHVwzclr6usNz7KDJecU=;
 b=gpyFunWlX/hFWn0CNVULjCkgGe+z4cClJmLqHsgh3YyCYP2AKdvHeswQQ8yZtX2YErJjgKuMmR7r9BpQqs+/lsvip5dfiUffzgGraoE1MxX+z+x8uXlLalJZrltFxBprEGqGrO1bxpTR+1PZnaJ+8jxXTiJ0PUdD/yXdvqaSWh0=
Received: from SJ0PR05CA0019.namprd05.prod.outlook.com (2603:10b6:a03:33b::24)
 by CH3PR12MB8934.namprd12.prod.outlook.com (2603:10b6:610:17a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 03:26:01 +0000
Received: from SJ1PEPF000026C9.namprd04.prod.outlook.com
 (2603:10b6:a03:33b:cafe::ac) by SJ0PR05CA0019.outlook.office365.com
 (2603:10b6:a03:33b::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.5 via Frontend Transport; Mon, 9
 Feb 2026 03:25:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000026C9.mail.protection.outlook.com (10.167.244.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Mon, 9 Feb 2026 03:26:00 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Sun, 8 Feb
 2026 21:25:59 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 8 Feb
 2026 21:25:59 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 8 Feb 2026 21:25:49 -0600
Message-ID: <c5f22c8a-ad7d-4a9f-bcd5-15cbee2e8f19@amd.com>
Date: Mon, 9 Feb 2026 08:55:44 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
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
	<shivankg@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: bharata@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000026C9:EE_|CH3PR12MB8934:EE_
X-MS-Office365-Filtering-Correlation-Id: 62f8561a-3b03-462c-9db3-08de678af28c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MWlMdGpxODh3dFVUTzRpdEtLRmJNcnlGT1g3b2xzTlRHSFlocC91M1ZEd08x?=
 =?utf-8?B?amZVSCtjbHRMblp0K2puTHZNcnN2OXpuZTZWY1ZpWFBtVW9VM1M3RndEcXE1?=
 =?utf-8?B?NjVHOFpKaUxic2NhenRsSXlLR1VqWlBQMm5xMzAybkpvYWJHcUQ4M1o3WlVp?=
 =?utf-8?B?Vzd5bHprTWJQODlVOTJuVUYyd3FqVDQ0ZGRqV0hjMTM1VGFiNHNZVTlBZmwx?=
 =?utf-8?B?c1hwR3Jsand0WEdVN2hxS3FMUitBbnZTWmF0QStGSmVmWmpudTI1bFc4b3JK?=
 =?utf-8?B?L3lVdjBhUEtWYjdDcE9rQVNYcWpqb2RhTnhMUXBKOG5SZ2Vlb040V2pGeHdE?=
 =?utf-8?B?ZWo5ZlNOL0N2NHRoMUZpQ3dGQnVWTzM0TzlGZ3V5ME5KMTY4RkZGMWJqUVRx?=
 =?utf-8?B?c1E4WmdRdlBNaS9FY1BVOGhIenRWV1ZSdlVhMzdvYkVaQWpNOElEZElwaXZW?=
 =?utf-8?B?bFhRd1JlZFRMT0NWWSt5QkZTU0ppQW9mSmpvVG5JaWRUemVUUGRRaE9TMm9V?=
 =?utf-8?B?ZWZpSnhKSDVjVEsvY2pxZVpKTGk2WndrcWg2TGMxa1dUSlRRNXBQMEtGMEl4?=
 =?utf-8?B?cm5PZXZpYUF6Z1VHK1ROS0svNDdHWW1xcFZSOHpIcytFOS9oWURTRk9RWk45?=
 =?utf-8?B?ekhpN3ZBSXg4ZWdOMlZTK3JQekk5c1U1T3RNZENkM05YZmcrYzdQS2c4dlkz?=
 =?utf-8?B?V2FSbzcya1MyVzVkZlQvaW9PUmF2Rm45TUVWaHFsTDBWZGxuVWR3ZzhrSE9x?=
 =?utf-8?B?eldoc0RVeENxZTBNV2dGVkRRbFB6WEFneHN4SHNnVHVrc1pQajcyRXEwVkpa?=
 =?utf-8?B?M3ovYjRwZEF6SUJrWlFtbWczWkw1REZSSVJyYjhxWTgrL1RIU2ZtZHEvd1oy?=
 =?utf-8?B?TXF1TzVFRVJJa2ZxZTFRUUhOK3llK0EvUU9GdmRrcnh2VDlHbmI3ZFYyMnVk?=
 =?utf-8?B?MmdmVS9JV0JxRlNWcVBVK3RZYW9XbjV0dW1TQ0VYRm9oZ2MrTWJyM3V5ZllV?=
 =?utf-8?B?NnQvazBnaUIrWEhPZ1IyRFBmVHM4Q1BRZUFucEhRU2d5WU5WYWVHTWx4QUJP?=
 =?utf-8?B?STVnNDVQdjBHOUxhdGxGcWJuSk5qZ004ZHFYdnZZRkZyWHFMNUozd0NqRkFL?=
 =?utf-8?B?NktZWE5ubmYwNHRQSVI0Mlh0aTJNbDVESGZsRUdDT3BMTU5YeTl0VjFRUXNu?=
 =?utf-8?B?TzlRWE44aDMxVDB4cVNaOEo5RlBsOG04cWpkR3RLbk5UaFBKNlZhN3UzVXlV?=
 =?utf-8?B?SmRDazkvaDZpY1l6b3FsK255ejEyRDhJQUJDM2tPR1FhOG9JWnZOaC9hS1dX?=
 =?utf-8?B?bksvc29HODhjSUhPYVVteGNieFAxVEJ6RERzYkh3emJtc3NidzUxbGZtd1l0?=
 =?utf-8?B?dlR0SXQyOWVEOHVQOVVCdlpqQjczLzVtUFdWZjhSWHdxQXVrdytGaEp4RVRw?=
 =?utf-8?B?WE4xT09GTzJyTGhaZmxPQkNjWjBZQ0hQbi9VRWttb3U0RFRFb1lMNVV1R25Y?=
 =?utf-8?B?VFpEc2NMVm9GRzBETE1CT2UxMEJ3Qk5OUG9qMEsvMzhKaDNSVzNaVHNLNVpK?=
 =?utf-8?B?blR3SkhpR1kwNXAzMTUrRzBybldpSlR0REoyOWtiSGhaQXZEN0xWS0swN0N6?=
 =?utf-8?B?Zm04Z3dzcjlHcTJ6Y1RGOXI1SXdTeVFjeGJhSU1BVkJRWWhuSnNYZUV2cjJQ?=
 =?utf-8?B?NWYzLzRxMXl4YzhFd2VHNGVVdi93dmljc3dIV3g4dDJiOFpqNjVERzhvUSti?=
 =?utf-8?B?Nm1Xd3B1d2RZbTN6QUVTbkV6MEF1a0xEemFIZW1NWFE4bTc1NzE3RC9vT2VI?=
 =?utf-8?B?TjdIZVpkczQzVmo4WStOTjdCa2xCaHZ1VWIzUUk4a0YxSG5kc2VkT2ZaSVpF?=
 =?utf-8?B?SDZXNkdRUDZxcHlRWHFEVythNk1hYnZZS2pMcGJRa3h3bmVmZlY1YklZY3N5?=
 =?utf-8?B?Q3kyL0hWYTRndlBzWmpKYWVubzVZMVVnd2JUZWpiUHMvb0dMbmFaSkJPWmQw?=
 =?utf-8?B?U2NXVDBMQTgzN3JSSkUwekY4MU5vZWhURS8zaEFSa0ZxdFk0d2xWNjlVUWMr?=
 =?utf-8?B?MWxzcEJ1WWZoNDBqc1NlRUFZQnhrQ0J6TW5wV3U1Z0RpQlA1b25iM29LZ3c5?=
 =?utf-8?B?RXQ1Mm1WTUl5SnBkaThhbC83elZQczZqd0xGYVhmQno1dEFoRTVTZmtIclhw?=
 =?utf-8?Q?QtNeAqKjsq9sYMfx5Vf+3ChufTb+bDzci1T3zmS+YipK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5eycIzYNqEuZbHlFcTR5k4ECFphBlPYGT713rEf++YIpmj3ZiHkCcz2MSGGTYdmXC93UsXrbRCzzJ9BOPSIAj6/rF4rxwZq2Vg1SGd1R9XN02ztrSyZVU5CKVEIuSWZz4m21oM0S7L983EcPLFbhEy9JVzljvAXwr/Fl8NQ/0i8cBziWAPdvH6lC5m3i6+tUDfh/kl2FaBb4TY4p8YWZKJPH90ax1+bz5eJMCywtSdIVqA5C8vfBCF8DQcfm/gA/ZmnLD5C/ZhZaopbED7g+hqP6d395z4pXlduOE0llwgIKYveexKgC+Pxkg30U2+gAz9cKbKDhbYivBiFqudocjjMUV2/c97AGbCTO+Cqaqmj3C87I02P3UVKI6BAlYpeD35ss/RBw4jDJP5yWrWOzUDv4Ijk7U8RmudgSDeiICj+6Vpr/lh+ts1I3ZotmLFK0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 03:26:00.4562
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f8561a-3b03-462c-9db3-08de678af28c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000026C9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8934
X-Stat-Signature: y1di6w91jj45cwbgm7cgoqtqig8no5ix
X-Rspamd-Queue-Id: E526A40007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770607565-133031
X-HE-Meta: U2FsdGVkX1/KCVCKtjIDO4scTEPccoyCKylYGC9UCiEdBDEpDn2ApN2m3WWyyJnQo2LmsNP0jiPdT6JRgS39h8eRu069SjojBaAZVV45eEFB7mYgA6VpMvvCh06oi8rTXO7kHOmLX4mUGaeFiyxj4oG5sC3jfrZVcpqbvCE3F9y++jZFeqKeiuC4EVG5h5VHWHje8kajhgfl993doI9h1sa/aCP535URUob1Ru9tCAQix5QY371Zy1hENZUVJuOAkMP6vWaT/LWU0Hy/dI4eWuqAqqqH/SZtjI+HBleqZ1y3UdXsKKNLs1QaxPTo6pA7TVZh/VZUf3Q4dwYnjjXq5+7cy4T5cdgGV5/wuxihBMGFc6JsUthtL/eirebBf+PntlSqeZMroaKxL+8ufCxanK2Qt8fhyG30Zp2xc+aBo9vbMMhJBCLnul2q4M0rrniyOnnm3AD1LimUDGP/SBdAmwIfeCyxou0aWcR3hTIe2TUVa7Kf0FJLCtVaFcmT59NspoUYSJ6ZPuRkWquz/8oyBgeHnCtmhKrjjCVZTYvZt/ZtC/JkiVvzpHLl2WYQwLNYIOU51VGD7RYjCDiGtNHtBm0Diq1HacpTtJ/5FusE+Ahk/CkU/P50Bqix88xCvGa/uNpAjk4vdVDsN8ZIvxrlYbO8A8drz6CwFADNabz4h1DE5/CpEvegyWMX1hYXSLPkZDQWRTLyQ5/zk3lqyFyNbOAjLt+bK3BnIRrm3c01loI5Unz1Rp+heX8flXCIeaFWmvfSHYuyr9r4Q8bqyTv0OMKNzF2aRa/qcirBSgtPcKp02V72Kzl7+62+BklZh8mOj3jrEUGT+w2wuvKUyzXL5hjWao9hM49epb99lIwfDeczz9eykDKHHmcVIvFwm+WtMTWVOUFt8iHP22G9UwtM0V0bDyIdl5bkaVA4FJK05FCso4V+P/VrFHZ7R+cdEkmCzxgWSLWHFym5VqydGss
 ljDdao+U
 qmjpFpj35mqX5kM8OOMTXFuJa964YqCEDxjsDlNLAXuRLD3C2RZ5UH+urVMZG3JibjpXArf7meHNVwy3p29JK9RSxnVby3aWcIpgUy+QT78rGPrt88XFBeqTbAKWglpcsIY0dkCL2ns0Gh6zHikQb1TTXtrkYLRyNlmrYXpAKHyE3P4VoKiUzhz8v/gn8mFoBMJ28s/BHwvlW8AgoA4nmwcEQaeA9g8qCkgM4v9/PIsQhma4Fp9ApJWlJ1n+WVViZO/tx4roHUhlAIFJxXX8zi5JwcTGqtm5AmvI+Ok9QZjR+IYKlXFKwFudwMmw5aj+KMgQUFpa/dwKLAbvpLcqlbf+y4uEdXrq4hxdlFy4jHF+b3fl1BQzw9dfIo3eTwIo9UYJNDrzMWGS8otyUhsgP4g/8QI/ycIb6/hnxaJnuXwdEJrT3656cQTvMmQwOvNG+QShUBAp2Z314TyAzsoGJ+ij/FtvBPvEK1bqcT7ODS6PWh0I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29-Jan-26 8:10 PM, Bharata B Rao wrote:
> 
> Results
> =======
> TODO: Will post benchmark nubmers as reply to this patchset soon.

Here is the first set of results from a microbenchmark:

Test system details
-------------------
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

Hotness sources
---------------
NUMAB0 - Without NUMA Balancing in base case and with no source enabled
         in the patched case. No migrations occur.
NUMAB2 - Existing hot page promotion for the base case and
         use of hint faults as source in the patched case.
pgtscan - Klruscand (MGLRU based PTE A bit scanning) source
hwhints - IBS as source

Pghot by default promotes after two accesses but for NUMAB2 source,
promotion is done after one access to match the base behaviour.
(/sys/kernel/debug/pghot/freq_threshold=1)

==============================================================
Scenario 1 - Enough memory in toptier and hence only promotion
==============================================================
Multi-threaded application with 64 threads that access memory at 4K granularity
repetitively and randomly. The number of accesses per thread and the randomness
pattern for each thread are fixed beforehand. The accesses are divided into
stores and loads in the ratio of 50:50.

Benchmark threads run on Node 0, while memory is initially provisioned on
CXL node 2 before the accesses start.

Repetitive accesses results in lowertier pages becoming hot and kmigrated
detecting and migrating them. The benchmark score is the time taken to finish
the accesses in microseconds. The sooner it finishes the better it is. All the
numbers shown below are average of 3 runs.

Default mode - Time taken (microseconds, lower is better)
---------------------------------------------------------
Source          Base            Pghot
---------------------------------------------------------
NUMAB0          117,069,417     115,802,776
NUMAB2          102,918,471     103,378,828
pgtscan         NA              110,203,286
hwhints         NA              92,880,388
---------------------------------------------------------

Default mode - Pages migrated (pgpromote_success)
---------------------------------------------------------
Source          Base            Pghot
---------------------------------------------------------
NUMAB0          0               0
NUMAB2          2097147         2097131
pgtscan         NA              2097130
hwhints         NA              1706556
---------------------------------------------------------

Precision mode - Time taken (microseconds, lower is better)
-----------------------------------------------------------
Source          Base            Pghot
-----------------------------------------------------------
NUMAB0          117,069,417     115,078,527
NUMAB2          102,918,471     101,742,985
pgtscan         NA              110,024,513     NA
hwhints         NA              101,163,603     NA
-----------------------------------------------------------

Precision mode - Pages migrated (pgpromote_success)
---------------------------------------------------
Source          Base            Pghot
---------------------------------------------------
NUMAB0          0               0
NUMAB2          2097147         2097144
pgtscan         NA              2097129
hwhints         NA              1144304
---------------------------------------------------

- The NUMAB2 benchmark numbers and pgpromote_success numbers more
  or less match in base and patched case.
- Though the pgtscan case promotes all possible pages, the
  benchmark number suffers. This source needs tuning.
- Hwhints case is able to provide benchmark numbers similar to
  base NUMAB2 even with less number of migrations.
- With both default and precision modes of pghot the benchmark
  behaves more or less similarly.

==============================================================
Scenario 2 - Toptier memory overcommited, promotion + demotion
==============================================================
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
All the numbers shown below are average of 3 runs.

DRAM-node                       = 1
CXL-node                        = 2
Initial DRAM alloc ratio        = 75%
Allocation-size                 = 171798691840
Initial DRAM Alloc-size         = 128849018880
Initial CXL Alloc-size          = 42949672960
Hot-region-size                 = 1073741824
Nr-regions                      = 160
Nr-regions DRAM                 = 120 (provisioned but not accessed)
Nr-hot-regions CXL              = 40
Access pattern                  = random
Access granularity              = 4096
Delay b/n accesses              = 0
Load/store ratio                = 50l50s
THP used                        = no
Nr accesses                     = 42949672960
Nr repetitions                  = 1024

Default mode - Time taken (microseconds, lower is better)
------------------------------------------------------
Source          Base            Pghot
------------------------------------------------------
NUMAB0          63,809,267      60,794,786
NUMAB2          67,541,601      62,376,991
pgtscan         NA              67,902,126
hwhints         NA              59,872,525
------------------------------------------------------

Default mode - Pages migrated (pgpromote_success)
-------------------------------------------------
Source          Base            Pghot
-------------------------------------------------
NUMAB0          0               0
NUMAB2          179635          932693  (High R2R variation in base)
pgtscan         NA              27487
hwhints         NA              274
---------------------------------------

Precision mode - Time taken (microseconds, lower is better)
------------------------------------------------------
Source          Base            Pghot
------------------------------------------------------
NUMAB0          63,809,267      64,553,914
NUMAB2          67,541,601      62,148,082
pgtscan         NA              65,073,396
hwhints         NA              59,958,655
------------------------------------------------------

Precision mode - Pages migrated (pgpromote_success)
---------------------------------------------------
Source          Base            Pghot
---------------------------------------------------
NUMAB0          0               0
NUMAB2          179635          988360  (High R2R variaion in base)
pgtscan         NA              21418   (High R2R variation in patched)
hwhints         NA              174     (High R2R variation in patched)
---------------------------------------------------

- The base case itself doesn't show any improvement in benchmark numbers due
  to hot page promotion. The same pattern is seen in pghot case with all
  the sources except hwhints. The benchmark itself may need tuning so that
  promotion helps.
- There is a high run to run variation in the number of pages promoted in
  base case.
- Most promotion attempts in base case fail because the NUMA hint fault
  latency is found to exceed the threshold value (default threshold
  is 1000ms) in majority of the promotion attempts.
- Unlike base NUMAB2 where the hint fault latency is the difference between the
  PTE update time (during scanning) and the access time (hint fault), pghot uses
  a single latency threshold (4000ms in pghot-default and 5000ms in
  pghot-precise) for two purposes.
        1. If the time difference between successive accesses are within the
           threshold, the page is marked as hot.
        2. Later when kmigrated picks up the page for migration, it will migrate
           only if the difference between the current time and the time when the
          page was marked hot is with the threshold.
  Because of the above difference in behaviour, more number of pages get
  qualified for promotion compared to base NUMAB2.



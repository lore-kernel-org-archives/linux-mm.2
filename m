Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E027E9E311
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 15:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F341E6B008A; Wed, 11 Feb 2026 10:40:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1D46B008C; Wed, 11 Feb 2026 10:40:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC34C6B0092; Wed, 11 Feb 2026 10:40:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C85016B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 10:40:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64D4FD693C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:40:48 +0000 (UTC)
X-FDA: 84432588576.10.E1F666C
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011028.outbound.protection.outlook.com [40.93.194.28])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8EB0C140003
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 15:40:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Ra8rSJkE;
	spf=pass (imf09.hostedemail.com: domain of bharata@amd.com designates 40.93.194.28 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770824445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGfiXZpq3NNEVqG6mTdtoZ+x/STFgG9p8aIfa09KLSo=;
	b=JXqitGCbegm2C86NCPQSruWJgERNCxpgcRbAOGA7OrY9d1cPUIyghgAj6dSmogWOZQjGJL
	Q9dWRiwGBfEZd08EhPxVsmPeXBzg1rl73TA0bCusPLT4qHn+XF5h9lRK5yDaSUztWnliND
	TkmNGI46YOilw1WVND3yXZ2LXuMmctk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Ra8rSJkE;
	spf=pass (imf09.hostedemail.com: domain of bharata@amd.com designates 40.93.194.28 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770824445; a=rsa-sha256;
	cv=pass;
	b=42SE6azRYOq1eRUnkLt1HWfT52WwdojuX+dN4ELWSzmwwzqELrh1SbpbFkpkAif9VFNQ1F
	pL+vhikqCGyY0EgYdTl1YLsMqUiYZ0D53ZV6QF30VJ3qpyhu8WKyqwN+JKycm7OFYQdRZD
	cGQA881OTK078XD1fqW95rfD0onkW24=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GGXzgr6XWnH3dQQ84/uMcE6sxggX2bB5/Y1v5dgP0xFtoNRFAxnv18rJeevxpe7jSKDY8iJzc0KJFgMd21JQNy1+2YZb2mtRFbGKldJd7eEJSDD3fl16k70I9qLhOgGI9fo1kSpG9kqlqxTaz3nZdvOuf1dVC3fIs9px7o2JaDgcgNq7kow3kv4vwUgc9pS3et+Srn/46ZN3tPwZ0nYm1X7cqRw6nbdvP3W98txlt7u9kNGBxlhUKWf9SFsrOY7EO2yGjVFZy5zKCIkCmW+Bb8SuxAeZAeOGkZZ6zRl/ifK75rdetITYF9ZAg3jE91zRKQgf4Q714vwxT4E6hB+ANQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGfiXZpq3NNEVqG6mTdtoZ+x/STFgG9p8aIfa09KLSo=;
 b=no06H8qvH9rrxuSM4nO8YsQyXcqQl1V+qDmkICMpfet7pi6Upv9yoq8Uv1CByfJnxGkViu8UqzY0qe8VImHAk0GfWj8f+4xNz4nX3n/hbyKZAhVHtXQh6p6LoK5lQ2RWapfSdFKqdS4iIp9X2kAxmefswcFvtgbvhwIupQ/ReVKyLPhDFF0fa9sdYHCPxWWq6xJXmdKun/zt8qHxeoZQ643e+CO0ISM4HJ8lG27WeTtPQe5pk+1bneH5hDR2OPLVfQcsP9XPnuABe3DmRtHDct4ol2lI5txkIpe+k9SJgSBLWkSjnVR7FTtk9VM6Ph1pby+wIr3NnKJjWGqf4IPyFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGfiXZpq3NNEVqG6mTdtoZ+x/STFgG9p8aIfa09KLSo=;
 b=Ra8rSJkEkhRluL7ez386pKNAHzX0Ux59MSVHEiWyd1PDqPo2ObqXNI0aQxXK45inqo+fpvgEpxfhpUlianXJPMjAdhbnrdCHY3zMPK0cna0Cr9prY2knOVIMd4qUkNCIYoE7QUqe0f3CGZgKrAif9rj+kKUkd/QdOl7Np3sBMwE=
Received: from SJ0PR03CA0235.namprd03.prod.outlook.com (2603:10b6:a03:39f::30)
 by IA1PR12MB9532.namprd12.prod.outlook.com (2603:10b6:208:595::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 15:40:38 +0000
Received: from CO1PEPF00012E84.namprd03.prod.outlook.com
 (2603:10b6:a03:39f:cafe::44) by SJ0PR03CA0235.outlook.office365.com
 (2603:10b6:a03:39f::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9611.8 via Frontend Transport; Wed,
 11 Feb 2026 15:40:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF00012E84.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Wed, 11 Feb 2026 15:40:38 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 11 Feb
 2026 09:40:37 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 11 Feb
 2026 07:40:37 -0800
Received: from [10.252.192.21] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 11 Feb 2026 09:40:29 -0600
Message-ID: <7c6d427a-9fe4-4af0-93c8-18ecb2296e36@amd.com>
Date: Wed, 11 Feb 2026 21:10:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 03/10] mm: Hot page tracking and promotion
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
 <20260129144043.231636-4-bharata@amd.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20260129144043.231636-4-bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E84:EE_|IA1PR12MB9532:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fce5dab-3c20-46ad-0839-08de6983e7b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RnFxVi95RlhvM1cwcFdVb2RZazd6V0VKcUs5ckQ1SGcwMWpFZG0rRFFZR09S?=
 =?utf-8?B?YVVJOWZrbFF5Z3huLzJ5Tm5FSURSOFJQN0VIQlh1M2ZvSkVPWVZXNStGc3ZP?=
 =?utf-8?B?eksycldva1pEcEp1aUVhL0U5WjRjemQ2NitKNzNTdVAra09iWlZMME4yd28y?=
 =?utf-8?B?WHVRb0kwMW9oYkIxVVlrNVZBYnZBcXlnZ05CMnlqSWpWNjExTjhRVFFGZmE0?=
 =?utf-8?B?dERFYnJ6S3JVQmt6aS9URzcxcXhSb2pHWm1kVmoxdm9RZVpla2FPNkdGa1U0?=
 =?utf-8?B?ZXVlT1BwODF5eUowN0h2NFdsYmFmWjNQZmEzQ3BpTFFJeE1GMFVmQlhScEFk?=
 =?utf-8?B?S2ZMZnJQMGdIMmF0MmpEWTg0cklpTklSd1hFcFlONFRMeDgzVUlhM04veUtz?=
 =?utf-8?B?SnNhdFZNVi9rVDFHMVlkdjBzNFZXL1BEMXZrS3dwQ3B5cldscjgwTENTMkZx?=
 =?utf-8?B?Y1JhSjgvcnZjcWVKdm11d2tMTDRlRFNCTFdxZzJzdGR2ZnpvaFc1ZEo1cUtG?=
 =?utf-8?B?bkp1K3J1UGp6OXRSUGpXaE02MTZFb2hMZVBYRmNaM3NTNCswcmFVZUw2cm5X?=
 =?utf-8?B?MFBXSE9RTFRGUyttRzBYREtYdnpvb3VuRTZTTnI3enJuSWJmSHRkL3RXekdq?=
 =?utf-8?B?T2szdmlVU0d1S04vN3JLUVJMSGQrdy9iSkExZW5QeC9pSGR6c0tkdkJIcjRH?=
 =?utf-8?B?RnVkQU9GNDEvbmFKNWJodmc4SzZ5eWg5SXEyVHFBNmJHTUpCc3ZLVjEvTmJ3?=
 =?utf-8?B?aW9YSzlkOXZyeVNER1RhQnRCUTJpeG9nQldUdFRZMFBlNkMrUXRqalYrSVp0?=
 =?utf-8?B?NWNsYVdlNm5XcjRnN1NXRUhzc3lVMk1vTnhYUml4TG42cG9UOW5MOHppRkg2?=
 =?utf-8?B?MitaTFRuaUlDRFhGUjREcmVXUGRjUnRTQnZQSWhGbDRicHpPdENIVXlkRjFM?=
 =?utf-8?B?RHFtVVZqcEI3emI0aE5WZE1zNEFORmtOUm16cUdiNEVqM0FCdVNzbHJXK0g5?=
 =?utf-8?B?LzUvYXc1M29FM3NTQ3NNTTVtNnlPRjU5UUIvaVFuM0kweUZveDZ2VU90Z29p?=
 =?utf-8?B?WnRGSHpSNFp3ZThLeXFsUG5pd05Fc1lnSk1TV3cwczdmUTdvUStSMCsxUnc3?=
 =?utf-8?B?ZUNkbWdvT2JTb2J6S2xJSUxEb1hBdnVEQjd4MStJbnhlcFpkd2Y3YUFBQy9R?=
 =?utf-8?B?T05hL0ZxQ2ZlaUV2d2tvWWpzZkxVVTZSNEZGYzNxRTFlZlpLSXBwbENPS1ZL?=
 =?utf-8?B?dWVzcHB4SFBBRFhOK2JtMU04UU1IdFh1M0lQRFI4RFNKQXpMMUVQSk9BTVdJ?=
 =?utf-8?B?U0lsNkh6SWovZ1gxYitkRjdJRi9sb0N6emRWNW9rbkEvU0tlYXpEeWpGU3Rv?=
 =?utf-8?B?alJvL21MMkpLdEo1ayszTGRSVllJM290OWV1YnRDKzhyd3lyYUpIeTFBaFh5?=
 =?utf-8?B?UzVXN0ovN3BYL2xkNWhucTZBOXZOZUtFb0RWNzR0UW9IbHhOUUUrMzF1dmRK?=
 =?utf-8?B?SmRNZ0JHWGdWWldEWW9RdTZJQmlxbzRzYm5vU0dOdVdoWmg5cnFLcFU0K0Qr?=
 =?utf-8?B?MU51blc2SVJvbDlQUTZyVHlMbjRlWVlXV0trZWhZWGRqSHVnckE1L3dqQUdR?=
 =?utf-8?B?N2pMYzlEdExXUUMwcSs4cDlSYSt2K1kxU1ZhV0dNbzVyTGVuOTVSRzFDWDN6?=
 =?utf-8?B?WkxNN1Z6SVlJMGpYQVQ3Q3RoeGM1b3hoSmdIQ1NRaGhHWU1DVzRsM0VmdEdX?=
 =?utf-8?B?RjZseERES3BHc29oZ3dKcnl4TE9mR0NoVlNVSVl4Zk9JVGhrWTJUd2hzTHBJ?=
 =?utf-8?B?MGVRTGJYa1RXUkE4aXlyQlNBTGhtZGFiTWpGT2tnVjdHWE1sUE1zVFdPTW9M?=
 =?utf-8?B?VWxHdXVvSk5MZit0SXd6ZUprSEZtUEtjZ1ZDKzAzNHBleGlGQ1NGOTh6UE9O?=
 =?utf-8?B?dG1yNnBYdStrRTQxUGJVOVhXRGpFb2ErVFN6N1hwbWYzN2tOSnoyWWZDWkdN?=
 =?utf-8?B?TElEdzdmS2JYaHhuTUZIaHZDWGc5VXNYbjRWVGFNWWVVdVZweUhlaUUvTk5o?=
 =?utf-8?B?VlRDMWhlMnFnSnVlS0VQd2w4cE9lQ3VvdE9ZUHJSbVc4dHhXazFha2I2a0h4?=
 =?utf-8?B?ZHJJQkZCU1Z4dlFJdlRFQVFjajk2b0NKSTJtT090dGVDSFRkQ0xJaFA0L2Yv?=
 =?utf-8?Q?BXgFa+MoeeAEEKDf7yB0EnQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/4Uvou78eQ234Z5owItnZ2KzCy3eNFXIN7k7b3IX7jnYFImzdss9LfN1oi7o+DFhjOG5KDIZcmcgQ46aGE9jot6N74CzxTG3Pzt9XBUqB+1pTdScmKquEdsXRSw2Ozj2maj96D2k0ip3LbYXfeGPInNrEwVEUBr6R0gI6UA7pLrPoFLPozTc0DbEKKZlu7IxVn4ZHjlZi9A4kmEFRIIhwqFCZxu/AvKpbQuvjdop8Yb4VTwxYGErF5mYUSqyd8UDW1u87elp46kFELirq7/DDEM+2eDQWsRREncfqtauaqyzoypuIHZ8lP+L4AD1hhBVbx/R5qwLESNMwESg01joPs+22TMd+ReJkFA+QZzWLQ+G6XJ2LyKrlmCcPx3RAP3/p4zIeusUmbY9DRgaEB6SqAHmxNTpG+/eweuytNsnVyHz+OdesdSX6rvsr5rA/IRq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 15:40:38.1004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fce5dab-3c20-46ad-0839-08de6983e7b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E84.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9532
X-Rspamd-Server: rspam12
X-Stat-Signature: nmi3of9inecae6wrdurd5ef34tg4k5wt
X-Rspamd-Queue-Id: 8EB0C140003
X-Rspam-User: 
X-HE-Tag: 1770824443-915265
X-HE-Meta: U2FsdGVkX1+LAQQ/IhFs9tkrdATqZUgJaumuvkvg1UOgVUZ39NMOj0mC3E9w8Ac0CU4yCeQaLm0M4op6pIeYh9dqp2VJX+5k9sO4haFm44k3LEjenRegeHkxVvn6NzVRk1T3iMti0jyg0QxOYz3O707eH41xEk6dkr1ZoOKbRT+X9vUld4Ap5gsykHbKbrkRuYXou4qRWMH2+/0pKAnYg0bARtG/KY71n2qgy9EmjJLE7nnmjKnXzI/x2ypwqEi8pSrrqWxrdM7vS3n7UT5VP8qdNNnO1FpkqvONX6y58EkfQZ21j/EdXjxrPjO6kB0U5JtFMuUagioMBaKtWWm1bWL4AMpbje2/xcq3h/s/Owvun/PS7moEJvSRO3e9nfR7HHcbbWOlg/YBndzQbyY406vqz4R9PeXITdFEiYZuXwd7Mo4LmrGzVBBVQfbHNjMVgWtHxifs1s5SFvwNpAtyVP1oA6v73sKf+vMtAn1uXQZH3etw6IVxEkqXVzMoJwkNsVD8PZqVtfrrGfO8cDGx1LRFVKu7Xgs+oOyiVYmRvSUo7C1MQ9gpEDhrO+rTHFaQYGIZEic3sB06fM0vAMpv3Cin+CIgqWPGl/nC0wNST9WVYDq9zkbcO17ZMkmP54LqKO5bpb7eihKhmAuYK5+vrzBiPuogxASl+SkZLE+JC7NElonrzd7EXFw75OKrBrOBK0ADaCO+NKzVruk51rAgYex5bnWUdWzZ/LtQ5OJ2Zkx54fYV4+1GlgM+K93sJRD0e5KvF/nBEyBcImAJILi3HOx0Qcsxt+P2XHlDSI/m2gOEXDKes/VAKbqht10hT+I0496VUXJIT9Frdqf+yqhj1Zdu1twHgo1fW50cR+syKgJYMf6SzE3JSm+ZMhyqscV4S1luX4/8hWDvHyEEUJHE3yTVvJMZIaA6syaUCTm2cDyP0IErtvZTynoX13WeX36HeM0B4a0fg1ToDL1wP4f
 4fmJ+D36
 rI920DbD0cZH6daonxYl3JyVaH4SyCKG1czOL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29-Jan-26 8:10 PM, Bharata B Rao wrote:
> +
> +/*
> + * Walks the PFNs of the zone, isolates and migrates them in batches.
> + */
> +static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
> +				int src_nid)
> +{
> +	int cur_nid = NUMA_NO_NODE;
> +	LIST_HEAD(migrate_list);
> +	int batch_count = 0;
> +	struct folio *folio;
> +	struct page *page;
> +	unsigned long pfn;
> +
> +	pfn = start_pfn;
> +	do {
> +		int nid = NUMA_NO_NODE, nr = 1;
> +		int freq = 0;
> +		unsigned long time = 0;
> +
> +		if (!pfn_valid(pfn))
> +			goto out_next;
> +
> +		page = pfn_to_online_page(pfn);
> +		if (!page)
> +			goto out_next;
> +
> +		folio = page_folio(page);
> +		nr = folio_nr_pages(folio);
> +		if (folio_nid(folio) != src_nid)
> +			goto out_next;
> +
> +		if (!folio_test_lru(folio))
> +			goto out_next;
> +
> +		if (pghot_get_hotness(pfn, &nid, &freq, &time))
> +			goto out_next;
> +
> +		if (nid == NUMA_NO_NODE)
> +			nid = pghot_target_nid;
> +
> +		if (folio_nid(folio) == nid)
> +			goto out_next;
> +
> +		if (migrate_misplaced_folio_prepare(folio, NULL, nid))
> +			goto out_next;

We should hold a folio reference before the above call which will isolate the
folio from LRU. Otherwise we may hit

VM_BUG_ON_FOLIO(!folio_ref_count(folio), folio)

in folio_isolate_lru().

I hit this only when running Graph500 benchmark and have fixed it in
the github at: https://github.com/AMDESE/linux-mm/tree/bharata/pghot-rfcv6-pre

The numbers that I have posted for micro-benchmarks and redis-memtier are
without this fix while Graph500 numbers are with this fix.

Regards,
Bharata.


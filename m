Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 795E2E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD346B00EF; Sun, 15 Feb 2026 23:16:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A616B0139; Sun, 15 Feb 2026 23:16:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452226B0141; Sun, 15 Feb 2026 23:16:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8A396B00EF
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:16:25 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E14BA13C068
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 03:00:47 +0000 (UTC)
X-FDA: 84448817334.25.6D0C112
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id AB2491C0014
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 03:00:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="F+IPj/NH";
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771210844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRPTqqluY+a9gNTWvirgpbpxBILGqsJqtNuvTmdGV5U=;
	b=mLE7h0+Q0u3Ogi9Jfy+xLMTxDqMThMzunQJya34y5nO95wFNL0c3HP3BBTYXjGBhV1sWlj
	E/CPFakMwLLbCxDoraJSvXRMGkaItYTzlTO4VldwmnDuq8nUvwVJ3rhe9Q9Iy1WnL3tdDE
	pp80MQV3QKv6L+BcxKlCL6HwdW9Ugrk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="F+IPj/NH";
	spf=pass (imf18.hostedemail.com: domain of bharata@amd.com designates 52.101.62.46 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771210844; a=rsa-sha256;
	cv=pass;
	b=rNbJPsWN0RU4Cqjz29a/nxB7iBeLHEwhTwjfeetWxncYy3xypW+nsnb3szaDdMi1VkAu/z
	L1p4/vaZrT+6QPm5u/2Ls/mPWDNs0MxRETdgStGrbY8p7GWPjzPtQ1dyi6ECa7mjOdhKyR
	jGRJJIZqlFXbKQ0nIIOHBTMIwKs6YWs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W5wLzRHR3h30QJT57w/OlPKlS2y8IFRQh4eTIu41MMy00ZJkrnqEEMIfxnvJQ7myDsDWH8HYrsKMX13Gs3zLDw5TTuL7XJ5T5a1Tsq1XY8UJcVQB94pCcMfn6lfyJLlbf43FMwVoGyZXFHrJItye68PMroHV/PDbu+Cvu/oZVQYow8HGvT6/GO2y4y8t34Jzy1WHEIdodu7rVJP9gQVG/RxD09npsr6o6Pdt4Jfls4hSVSJuZjgqzJlQ+mDDCCGhE5y2iWNxevrhetN24T27aZhLRwq5E0orlH4NW8lKDo3yayB0fBlDbuFjkCjt42gwPecXrK83q2ds2yPdvnIYKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NRPTqqluY+a9gNTWvirgpbpxBILGqsJqtNuvTmdGV5U=;
 b=ElxtpAmHshDcxpJdk6kplhmZGXN4cu1FjjrO//yHwffr926jcxVcF6TGkB/7g99SK+0CuYHUhYQ06N8YipeLzyC575q3paosN3bQ3bnA1I+6cd1eFM059Jc3i3m+N7aYP4aTDCaF7O4LcVSzUQtREGPmW20GpB5V1SuHMDWAqbqZO0LRIWjoE0QREdTLSeDPzDUTdptFLmVAgtDerrxW72LLjk6yPfSEiip0VEydQK79xzPskakkz20sAY0yew26WsgxyVlQvmlHggbfMZVHJMXKFt3gxBcayeRfKds4X/5ymZdoai1YxTSIHvqi3oyKX6Z16KDLoFwuvnZVSiyrzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gourry.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRPTqqluY+a9gNTWvirgpbpxBILGqsJqtNuvTmdGV5U=;
 b=F+IPj/NHbsGx4zRCdVdf2vjDHvpUTYWvxgcpHBtDek6ATo32c7hVpPJruUcPQHU73QJ8gOcI1H88qxFwZmEJ8kW7SGmjS4UpDp+eJUI0q5BQe+DOxV0fWLkm8nwSrTEMABHdh/gFsQH3EmDtLquIwc952zLhcvo7wtmRdYsiIVs=
Received: from SJ0PR13CA0171.namprd13.prod.outlook.com (2603:10b6:a03:2c7::26)
 by SA0PR12MB7004.namprd12.prod.outlook.com (2603:10b6:806:2c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 03:00:41 +0000
Received: from CO1PEPF000066EB.namprd05.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::59) by SJ0PR13CA0171.outlook.office365.com
 (2603:10b6:a03:2c7::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Mon,
 16 Feb 2026 03:00:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CO1PEPF000066EB.mail.protection.outlook.com (10.167.249.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Mon, 16 Feb 2026 03:00:40 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 15 Feb
 2026 21:00:30 -0600
Received: from [10.252.192.21] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 15 Feb 2026 21:00:22 -0600
Message-ID: <aeb717f7-60a0-4fe1-b34c-d4f8cea02f96@amd.com>
Date: Mon, 16 Feb 2026 08:30:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
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
References: <20260129144043.231636-1-bharata@amd.com>
 <aY87i3dG5xmDpWkE@gourry-fedora-PF4VCD3F>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <aY87i3dG5xmDpWkE@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066EB:EE_|SA0PR12MB7004:EE_
X-MS-Office365-Filtering-Correlation-Id: ab094f3e-6002-45a6-1427-08de6d079151
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bkVCaUd3RmJ6WHJNYmRId0RlbWhncEdnTVlzSTZHUTM1cFpkanQ5MHBGNlps?=
 =?utf-8?B?cmRsWHNKdnlsODk3ajRUZ2Z0OEgrL1gwQVdtVERLMCtIeGtESEEwZkZOSHZQ?=
 =?utf-8?B?TkVPd1VvMkhlOTFKbFY0SEpQSW11eW9ZMzJXRkxnUlp1Q0hMcFhGN2VYRWpI?=
 =?utf-8?B?UXg0dmExUk0vQnBSNVN3K1ZBOGFGbkNabFUrVHVzZGJzZ3FHaXlXemluS1JF?=
 =?utf-8?B?VVdBU2lNT04yUFVjRzFWd3ZJTU92Wlh4cDVYZy9TZUtjTGVJLzk1WUlLbjBM?=
 =?utf-8?B?MTd5ZUVWNEdRRkRZd2RzblZra0pvTHJnR1BHZGdqMHlhVWRxaE1DYVB1RjNn?=
 =?utf-8?B?T1h5QWxDcDY5QWtwNkFJRWw4RnAvNks2S1EyRWZMRkphcXp3ZnZUdnNreGF6?=
 =?utf-8?B?MzdTcGVCb0NoRXBlaThyVmp3bWJDNzhZcTlvS2RGNTdKYkJhdkpyNWNQSDMw?=
 =?utf-8?B?dGI4aFFSTnd4ak9pcUp4VkpEWUtGbFozdW9ScVlhOFFTK1dTOTcvTVdDR3l6?=
 =?utf-8?B?eTVXK3JXemVSMTA1SDh5SHoxRytmT1NrVjAxUGUxZW14K2xvTWVqTlI3MVZp?=
 =?utf-8?B?MVNYTzAzTUNZODJhR3l6YzIzajN5TWtlYUl5azRnWHdEMnNycHJNTWlucytp?=
 =?utf-8?B?b3c1ME92WGp1Qy9zQTRTTlVOZEltTTB0L01FcVcvVjlLcG9YRllEczU0OVlx?=
 =?utf-8?B?UUxvOXVPYUkrUm12MGpyQVIyVkpOMjdIV3hOV05qaGdqZDhiSnd6N0Rjc2tC?=
 =?utf-8?B?OXA0bWp1dFVjbURYZVBxLzhpTzZtc0NnS2RJN2dYbGdjRVB0dDhUTXplKzlU?=
 =?utf-8?B?OEFsdkE3Z0ppQU1PMFZZb2Jzc1dvNnZZUXVHU0w4OE1PZFRpNCtaZm1zU2p0?=
 =?utf-8?B?V2pZeEtYSXdyRkFOekVsZHVBSmxwWlI2WUhsVE5ONTBsM294c3ZBKy83b2tL?=
 =?utf-8?B?U3NVZnVOZjNZNkZ0MzAwWUhBckRsSVg5blBZZGdnd2tvNjNTb0N6U1hoSHdj?=
 =?utf-8?B?R3BLQ3RHQlRDYmh1N1d5dGlJMFM2czJEL3NOZDA0Ym4rbk5EMUNBSi9CS0pl?=
 =?utf-8?B?MHBzcjYxaDl3eENtMGtaY0hKYTgvVlUyWUdQTjNzNGloUnI0d3BFdkE5RnUv?=
 =?utf-8?B?RTI4WmdkUStyajJhRXpYSnJYTFIrRVpGYm5LVzI5QTVqM00yTFdFYjR2RGp3?=
 =?utf-8?B?bXdENzJTZFV6TTlUYWNpM2dYQnN3ZmRKbTI1UG56U3I1RXpvTVZJTnpFZmVQ?=
 =?utf-8?B?dmp3Nm8vcmxaeGdhT0FGb0NJVDdyQXRPQno3WDFmejBmMmVLNUtOZkNUVHl0?=
 =?utf-8?B?Z29WdExPVlVCU0Q5Y0JjZ0w5QkpETGpVcVhXMmZmeHkvSW9pSmNlTng1MWxr?=
 =?utf-8?B?ZTdtL0tQdGlCdXhxNGZDWmFwQ1RmZElHWXQvbnJBbFZtSWtad3d5N3YreUxQ?=
 =?utf-8?B?MTEzWUxhNmNBeE0va3lmVWxOZzY1MzIrNkFRZm5MQnpuZjduNnNKY0pyKzVx?=
 =?utf-8?B?NDJnT2pyekNDOFNhVS9UUWZEWFhiSllyNER4REF1eERoZ1FmMEJlbnlmWDF1?=
 =?utf-8?B?bVhIWHFReXEwSjkrRnc1WnNOaHQwTUxydlFHWVlkK3FJMmpCQUc3ZndkY281?=
 =?utf-8?B?QVFmZ2VWYjZCTG10QldzamlzVllWaVdzTXVDNzVwdjR1L08rcTJrN0o1MzVJ?=
 =?utf-8?B?dG8vMm1LQ1BQcUpROGlxV05kUVN5WWZpZ1hYanN6L3BubVZIeHN2VEJWK3dF?=
 =?utf-8?B?ODEvWFY5M0lHbDFIK0hUWkIwL3ZvaFJkbTVWOFlVWi9ETnRzY2VhbFA3WXZu?=
 =?utf-8?B?ME5KU2kyUnk4cVBZczRGTnJZeVloRWdRQnRicWFuQnBSK1QrMXVmM3MrQjVL?=
 =?utf-8?B?aEpZZ3NJaGhZMVNzZHNuWDdmNkw4OUZkRW1yZEgxakIyN3JUV3NvTEtYZVl6?=
 =?utf-8?B?d0drdWVTbG5JL2lKS3BlYi9URFZ0azRiYmdrNDc5VVZ3Y3BCbEJYeE12cTgv?=
 =?utf-8?B?UzFMM1lLSDFNQkQ0WExDMjZ6SnNyN2pONzVROXJYZk83ZTBpYTZjODhralI5?=
 =?utf-8?B?czV0YXhmUnBaRHpOc28xQ2JWeVAyY2l3YkYyaml5YWNWeDFsb1dZdmZSZGlM?=
 =?utf-8?B?eUptR05sY1lmQ2k0dFJVZk95alhTTUxmY0VSYXJFQjRjRXhrYXVsTW04Wi82?=
 =?utf-8?B?THpmMEZncE55S0Z6Y1JydUlIUFdrNDFRTmp0NlV1eUhWa0VHZUkxc1l1c1lQ?=
 =?utf-8?B?cllGYnNPVTF6ZlZuMFNFUDQ0aWF3PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	EgmTQvaBwwnchpUQ6noxuKAomLXx/v7khTVNoPX4wSq7EsvZ/2IPPY0UboeIEifhIPlAQKXHvyo2uly+5eG7IwUrB86TZ9MSLBLAHwePv3Ur7cSAMIo6haDYHYBfDYeTXhCRg5DMB16unKBbwvVpbpDMdhzf5/WrTqXZqhBdFbK3A/mHchr6PRlP2P4bi0VS3GcwsPTakKp4HJojB3gx5fEJHNpBKewMivcL0pEnyDoXs1p8v4M/i0EL+MWIQZGvsmktn7rOV6dlsuEE3QHu5//eH/GHLabNjYV3XMJ/rrT2DqtlbcGjdgyw7wKBNcuXZFLX0O6YHt5Wv4+q0epVC3p3yt1Fdrr3X0GDwrnfkYzJAIbFp9OoWu4u9u9dru+xVie1XVS7n/PNZ3nilDOEplfztPQ7ls5ycY0Izk0Id/woAdhq/mKA0SM1uJWZka8o
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 03:00:40.2065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab094f3e-6002-45a6-1427-08de6d079151
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066EB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7004
X-Rspamd-Server: rspam11
X-Stat-Signature: bwx6zxjuowt11f9dik5r14rukcuhgd9f
X-Rspam-User: 
X-Rspamd-Queue-Id: AB2491C0014
X-HE-Tag: 1771210844-76063
X-HE-Meta: U2FsdGVkX1+Bgj0lCo9co1dqAZKktE0Oea8UmQlsteG7xomnWkgsnJsIIOIuDbfJotk/Wx66QSKIYpQpMZcPv1LEzbNdmF8Yn9vZzbsn8qx+jcnnLzN1bxFC8bILNbPeRDnQfCLsfd1CQ65Pr0SOFYZn/WreqZX3VT+1KUi+1qkelUGMaVea6qbExCbH5K3mqsH+yM/WGwNwvl7IrTeDIw9IS38g7a9y3vmv0y20pwQ/hLtZJdDHLOovnXmQvZt/992Ic1mNndlNL1MPttFIFC84RqhS2spE9k8vayoDDMZ3yH4aH/r1ZfhX1CjGj708kcfSiyhSxefL5J+evSBTBxI5qzWPBFT+Db96piy/5nDenHMfF+TMqJ4Uy6z50LnHRT/tTL0ZhzSnSGdovm1JptfZvOlq4AkjFdZnLc7C4/uTQ/0Hhth8Armz/mAV8DeOibmjfimADJFfURkimRIcpShUQB7K2gH+B+6Mj+2LgSWh7KWtHQoBQhhdn8fBVz+1vr+8Q+qH8h9V30lBaYl8ms29B8FgI9zo8St1jPK/fQr+vRjDr3KqCcdDZsIf1HMQyx3nJZxFISg2m0KJx0ovn3vpQB5d+tfVc/TbDqx5J/uU+GJWcnpvuFe7NBIwDTgjxTL6rESq4bcMhJh9bRJsypF2zyYya8X+nuospxko+fIZkAVxOJtUiy9r9nd5O5e1WF0yGy/Bg7RduR8Vefb6jtvisQPBO/JzwkzXWqY/M3AOAOo2vAPChdgUHbSFcJGvljvHpbMpd4e9DcjoWBlMPhRNCi8/InFpAUwmVgzyxeTquPawKY6l5vS4K5lW+cheEYsKYDTxOYLofLYYA+3SUYmhiL17JkShqgavEr8p03Pp0TMrEF67Yv1hh8kjGu+q1Kqpciby3YdvYSwMOBCPGJ9EICnoW9ZRz4yuuZV9TwswaxFED47ctvgUQhnYmhpkEkXYjKrVXk2GoOD9BP1
 mitWkNxt
 3+jQTMRplmRn4qvHXUJWiUF1s52QsqWd5ctIfcS21pupH28K8jmH1pp2wKcHDvADohVNbNvUXJ0EY9sDIOyMD71XaiTe6hXwQXC1w9SWDirwVDAoaf3KojFI1bcjq44/ccqYaPSCmZY6gTJtF2YVns3uv2ocEI3hfvsuLub0031oYoaBTNreSc60G7uww9IzTCOICR1CwRtyNPMuwbYsF5GR7fDo1JwhEyKz/HxBTVjvQBg84M9MRRMnjJcUYnb6A7BhoPsJp+AUlCRPZ5rCsriN2lu4iMAw3F89q4Su4lW+G8XUthDHqwU2DA2hZOdQjoPX1WOrSoangEV++hIkRtLYNMt7FqINNCbah6P6x+QEIW/6teAz4R2cqkaOW7BVINbkqZKY35T55kx7VQQLlOJ2i9FEv86iBkdtMhDhis0C831svEfh9BAYUTGAVFTAw5cyNzsxC7JPxpd4/E09v762Y/bX91mH1E2gyKCTRx4fnqlskCyya45UUdUI6wSrTk4Qo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13-Feb-26 8:26 PM, Gregory Price wrote:
> On Thu, Jan 29, 2026 at 08:10:33PM +0530, Bharata B Rao wrote:
>> Hi,
>>
>> This is v5 of pghot, a hot-page tracking and promotion subsystem.
>> The major change in v5 is reducing the default hotness record size
>> to 1 byte per PFN and adding an optional precision mode
>> (CONFIG_PGHOT_PRECISE) that uses 4 bytes per PFN.
>>
> 
> In the future can you add a 
> 
> base-commit:
> 
> for the series?  Make's it easier to automate pulling it in for testing
> and backports etc.

Good suggestion, will do thanks.

BTW this series applies on f0b9d8eb98df.
Latest github branch:
https://github.com/AMDESE/linux-mm/tree/bharata/pghot-rfcv6-pre

Regards,
Bharata.


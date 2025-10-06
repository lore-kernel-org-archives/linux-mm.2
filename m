Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BDD2CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 04:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04D368E0003; Mon,  6 Oct 2025 00:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40028E0002; Mon,  6 Oct 2025 00:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07C08E0003; Mon,  6 Oct 2025 00:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7C348E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 00:13:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3509A16048F
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 04:13:26 +0000 (UTC)
X-FDA: 83966370012.30.C6AF0DF
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010069.outbound.protection.outlook.com [52.101.46.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D41D120008
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 04:13:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=up6W142C;
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 52.101.46.69 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759724003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JUA7HyMw9Jx9fyykcSoT98QmfnA5O41DKn5I5n/dSw=;
	b=3TsYz5Pw5B9bGRL+yysFVUWbULnTisFuqVrviyxkjiZk0pvsgMZaQTRcq2ygYssiQONCFp
	UzjsYBxnCXhb0EJTUDVRgCYxLCsceOw8+/yHZ9rgMlISfBU1xQIuO/7ocAx2Otc7EA7VKE
	Wiv5CM1Vv1m8+4K2JvGM0831q94bExE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=up6W142C;
	spf=pass (imf29.hostedemail.com: domain of bharata@amd.com designates 52.101.46.69 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759724003; a=rsa-sha256;
	cv=pass;
	b=ZsKqvqzMhYgqkt+SoCxrUKuCOz/SSepuD0S4U1JDZP6juYBODDkhM2w101ePsLCdDV/ARE
	6QIFc+OtdK4IH31SIWbFpQKX8MnQWVbreBTsPNcMcz1dBb/gvhCpi/skqzgahe12gN0Z9Q
	Flz9kq/eie9JSjIsyGqpDqIoWxdbMMY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o0aysbbrfJps0XXZxJsQQcVdxsmWeuuyb8qPnpoBXSmcoHb7Pbw5CIW5Y1v2u1cjtCy3DHCvWDs+MfrndMdHPxiPXJCmvrohQ2OOYabpD3kpR30VWKpks8huZ3VoPrARbXeWLMKuPJDxI8KEfRxbv655MDjPTAF1i/F24vpf9y6vWM4tHQ/MOJYkNHNAmz6m/cTsxU7NlWm2w5RDWwDidyCzAm1KCMd5O/1NC+OOG0VeZmXqcN0hZxhS66Jgs9cAFld5U9jh8jcXjS6atbfeB/8lzCoH7qomsBOaguTKVUKDfkl21Xc44ypaeL3X8NQ+UxyfVrw5pf4ZtGD27quUZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8JUA7HyMw9Jx9fyykcSoT98QmfnA5O41DKn5I5n/dSw=;
 b=mo7pUBPcsXDsl7VwU1OTmMQbr6RgWjpp2ftDGMywhKlTxK1e0OcGSZhtlCDqhsbah+bOGLvdjWcf6/RDlm79iB3cxPkWJs4X8TDgOgjKGtKtIK7Zs2Go/KbzYKN4xIka6gm7hkKxnRsEoACaGNyXBTDAEgET3P7r5GnMIWsrBdvkMkKGGAkjgwQfGeTFF+VsCgu3gQsVmhok9LrvqOvkUQNau2ibXiQ60O4ND+sQyvi1Am43DbGLvwRHpGhCJAySZndJvgajnBkb/OBPXS9eNTOIVP0kHvPDGaNJGBhDHA+4K4vxN8CQbu2C/wWSwO/mWTLzRmJM0PGG28EmGhiAxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=techsingularity.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8JUA7HyMw9Jx9fyykcSoT98QmfnA5O41DKn5I5n/dSw=;
 b=up6W142CS5JkgfMMv5zP6pcL7l4Xp+pACZdruUT7qvWl1L4P+q6Al6spuW0A15P1MDf3SL6GsmPmgKxjKBkc5hFtYvWrRt7u160/Mga2lnt1R66fNJDGErnrpWRFw82WvF2ocpVK2Ai+5o7yYCBSf3p1sJWU+cDFQdR9V6bkoxs=
Received: from BL1PR13CA0351.namprd13.prod.outlook.com (2603:10b6:208:2c6::26)
 by IA1PR12MB7712.namprd12.prod.outlook.com (2603:10b6:208:420::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 04:13:15 +0000
Received: from BL02EPF0002992D.namprd02.prod.outlook.com
 (2603:10b6:208:2c6:cafe::27) by BL1PR13CA0351.outlook.office365.com
 (2603:10b6:208:2c6::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.9 via Frontend Transport; Mon, 6
 Oct 2025 04:13:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL02EPF0002992D.mail.protection.outlook.com (10.167.249.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.9 via Frontend Transport; Mon, 6 Oct 2025 04:13:14 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 5 Oct
 2025 21:13:14 -0700
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 5 Oct
 2025 21:13:14 -0700
Received: from [10.252.192.21] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Sun, 5 Oct 2025 21:13:07 -0700
Message-ID: <037112a2-7984-4c5b-8430-df5f167d7f84@amd.com>
Date: Mon, 6 Oct 2025 09:43:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 3/8] mm: Hot page tracking and promotion
To: <mgorman@techsingularity.net>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <gourry@gourry.net>, <hannes@cmpxchg.org>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <rientjes@google.com>, <sj@kernel.org>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>
References: <20250910144653.212066-1-bharata@amd.com>
 <20250910144653.212066-4-bharata@amd.com>
 <20251003121724.00002e6b@huawei.com>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <20251003121724.00002e6b@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0002992D:EE_|IA1PR12MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: d104b508-d0ac-4aca-951e-08de048eabd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OVVVQzNNK3lSb1JqbmlObnNmUnVDOVcyMU43M3BIc053Q2FiVE1PQW1LQW9w?=
 =?utf-8?B?TGQ2Y29YUkJuSFF4ZTFaV3VaQnUzK1R6K2hqT1FzNTYyeW5EMkFQZE5tVUF6?=
 =?utf-8?B?RHdyL21Bc3piZ0tGRWVEZVQxckJWdVJxcFdpc1l5aCt6NkJLQ1cvSVd4OGV1?=
 =?utf-8?B?bGx5blNKZW1xejJ6dDF6UFBwSzlGbC9JSW9OTWNRZzg2dW1GTzVCMzVuTW80?=
 =?utf-8?B?ampBeThrNUZXZ2ZWSDIyREs1VXJtdkY5OHRMVGE3SUxkdzUwaEdSbHZrNERm?=
 =?utf-8?B?VE50OVc0K1MrVkc3ZVpKcjZoRHE5Sy8zdzBrVlJyYzdwS3JVU2g4bm9DYnhl?=
 =?utf-8?B?dWMwWDdvby9QYmM5Y1ZWYk1NZFo3ZjJxd0VzMzIrdmNScmcxRE9pZVB0dytR?=
 =?utf-8?B?RXRCOGNVRUM1S0ZaeDZDZUphdE5OeWc1NER0SS8vbllrS244Vk1vOEVUbEgr?=
 =?utf-8?B?bUNQdlR0QkcyRUVnRGRzM0t6SzdIRHlPRzQ3clp5QmpiMEYxOVVob082Um1I?=
 =?utf-8?B?Zy9ZUk1FWDlCWWVkTEpKalA1dGwxVk9Tb3B2RTgrVCtsdjdKTUZrOFF4YW1B?=
 =?utf-8?B?ZFBKZGdXKzQxSkIrZDJRWlIvSmkwWnJCSmdUMDZYVXV0UjFGMGNyWTNBRkR0?=
 =?utf-8?B?TFA5c1ZlQSsrYzNRWXlpREV3c20xbGF2YXBEaXJFcllPT2NtM0cranFFRVRk?=
 =?utf-8?B?SnhCYk5zVTgxbmNlZ0k0VXRsNEt1ejdWRDY5dWhiWUlORnlFVlIxd0VjdXhV?=
 =?utf-8?B?bGs4S1JYTkpBMGxxQlNNWTVndXdoWm9YWTFkNzRsdVVMeDBqS3VXZmNHNC9u?=
 =?utf-8?B?QjJNR3UvQkxUb29CMnZJOU04UXJmc1Fjb1I3RHVaNGw3QUpwbjJXV1FYUmsr?=
 =?utf-8?B?QmN5SXhIa0FacGhxL2pHdlFlRDNSeW1QOEZuOVljRHFTMVZjWWVLajVNQ0dq?=
 =?utf-8?B?ZTdhYVArMDhoLy8vNlU4VWMzUFdUSjZadzdqeHpiZjZPU0lvTVNKanMwT2VV?=
 =?utf-8?B?L3dsZmswR1NmcjJIaGFxSE9IODAzbTJOQUo2cUtVRTRYYWE2QlpTb1NnZk1w?=
 =?utf-8?B?cVg3ZUxnRG11MDlSa3lTbFdSYUZHaUpKYm1JVVVBb1BQMlVmdmRCaFJpMWVI?=
 =?utf-8?B?cVpCU3l2VEJoL3FMMGxadk9tNkZIMldQYTJTRWFvR0taeUgxME94OXppMmUw?=
 =?utf-8?B?YUJxeUtpVGFwWWN4STRsaVBFT2xRNjdrbGdvcmRqeVYyeElDR2lGOGs5MVI3?=
 =?utf-8?B?dDY4ajhpMjE3N1pRZHhvbkxzaEhWdFNFMlh6OU4yNFkxS0NCNWx2M3crR2tN?=
 =?utf-8?B?bkhPSW5udWFNZnd5ZFVQNmRna3FuM01qY1JMc3ZwSlA1WWZGMnhRWTZXS1RF?=
 =?utf-8?B?aEVqRjYyQ1BVcUFMeU5WSlVoZHRYUW1UYlcvR1EyZ1pIeTRXdjQzKzJZYWpS?=
 =?utf-8?B?VHNuSlprVHlLUXh5QkZuZUpWTDdpYnlueGhiZlhITkdJM3VhMHI2bDlhcFFX?=
 =?utf-8?B?bXRPYU1HbWg0eW05QlEwZkVBNmxpMTN0SGRZajM0dVk4V2QwWGMyQlY0VGhs?=
 =?utf-8?B?c1RmY0VhbVNTcVRZWk1vTXlrT2tIYUE4M2h0cXlOb3JkbTBleWlwN2FFRkxP?=
 =?utf-8?B?SHZZMG5uc3N5OE16bUNMMFJZdUk2THlyMkNVVGxGVUR0OXYwalk5VitBLzc4?=
 =?utf-8?B?WnJKVTlvejhFSHlPWlhvanl0QkRGQ0dQNG0zRWpSQXBYQWlPYmdOVkpMc0VF?=
 =?utf-8?B?WURMRkJCTmpwNDg1Zi95S1o1eUpZUmVSb0Jhc2U0M2RhMlJpZ1pQVGJIUnVO?=
 =?utf-8?B?eE9TTVU0QklOZTNLWm9hcUpIcjJ1RnUrVUFJeHhRR0R0WFVDcjZYb2F0QWgw?=
 =?utf-8?B?Rkl5aGhZM01KK3MybGFrODZLcjVNanJPaUIzYmQ0akVYV2RlTWRzT0dZM3pv?=
 =?utf-8?B?dkQrUWMzYWJYUXJ4a1BBMHdhVmZBMmR1S1JodWJ6RUJJWTJSZTZkSzJhZFJ4?=
 =?utf-8?B?STFMN2VzYS9VNmVmL3MyckppRHNDZEJuVHA3UUhNc2RNUEJwbWxjQThVdW95?=
 =?utf-8?B?RXBhMXo0S1p0cmZpN3puTVRTaVlOTE16V0J4M1VtUlljaVVnZ2ZNU1hxMm5x?=
 =?utf-8?Q?Eup0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 04:13:14.7214
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d104b508-d0ac-4aca-951e-08de048eabd2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0002992D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7712
X-Rspamd-Queue-Id: 1D41D120008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7wqadtxy7nqrfrfxb3iyd4gz9fqoub39
X-HE-Tag: 1759724002-951671
X-HE-Meta: U2FsdGVkX1+nsG+Nfd14CjlA57bXm9g+sqxfh9e7t64xi+tLZVQma/gX+LHGNsmK1kLmWvVDicCXk2OUbawgLgyJhBbO8QGXod1oQVY5C86lxH+ixXDYKOGPYPBrJv8pTL7c7LY4S6qKPIWqvdnaxLpryagmWHleIhx9Q09Y26Zt8TM3Es4I4k8cu5HFjt7ZXoBZuyAYetk83Y20XHHX6he39zNQwmzgXHwAD5XLDpvgaq3wcLuxwh/KtIN9ouQdmAhKoBrNIfNMurdnOkgR1nrUOM4Pg6LkSMdXiITO7vA7k8s41++7If63kzMKWGZvdzBZBRweljN0h/3PNE+w62F98PnUOGDuxs4YwSBnx/loMrAZ9HUeZQuWI5XizQaGd+/LQbEDYeJC9LstUyCgdDmoleg0ZzyEwDeus+zuMulpxcahwbXarcgs5m+efFWcyA+/P6kb6IzKEvnxJ0S7XNtSr/MJB8WuDblFt+cPmY2FOhAYfqiq7NrKc4fRaGetlgouNGx5trhkLD1GClEfuHnOM1SJ7VRG/UdXIuXSr4HmzeN85P0q4LSUuo8k/0h6LxrBF7ial8kcSsqrwdbMyxGa8Ad77jrdPvKn0iF0RJ5dB5IXTGpNE3zs1wc54CXIU94jY7b2lvJR2aUzt4OX1EFBlLHN5of/fpVzaNavQaxRMXnxygaBQPjI791pdwMsOfYByP1oFtWT7tcVIJjNnTRXcJwQXFTBxq7dBTTIDAlwymdJJrbG7+Z3CxxiwUBaVab+XOll8GaITlR+EbJm7GJtbk1hQbjnWnwR+2BNPSv7qysp/Dsn5DsL02U6CxGxCARuqB14BZKqQCjW76rJD+NNh/hxbaO+ZLZmmiF7H+yshIpFQgNEnWtEwQzfKJdZh9rFBBmLxLOIFnWLidBNWnBXs5TaxaA/L0IdFkunSheeuFv32SDLKZMpGsGE78JeOFkw4Z+2dWQF2OT7COP
 GHpMzj76
 ARYDmukAlc0MpZhNKVlA6iTqI5Lh0HySeAPtDn4qi+BvMrE4x1IKjEb1x3IC/zXXbvuCY0RvFgoEGF4HJ5uKk+u/U+87r5XEZ3oWcTsOgMuwsCHW5k31wXuxIqIlN4cIMFIBjTEudI12POIIDvAYC6vnwTJoRb79EbWXQ07hlSaYVYNAOZ5OYFgti8tjPzB1OOV1lVTUpw3EBlcbb5JM5qAHW72P9he6eElAOrHlPMgzIE0qXawZ+oYPhdnYx03PFDxa1xTTsFEQ4Ten3QNbqTRqUiC3IJ2sX/U57FXPxDCxoIJzq6rk539tIm5UCC6p1cbBwMPYYJCBKQJYXfBIqWqsYjtcr+cClyRICGQIEP5JN5QkuNNQWriHYwKce3DdeWVQgyl/TJqrpSfui7Z/SjbM/NepQetPYAXWIadTcVrRoY7t387tR9xBL22mlh9uiBi/hb4cmuHhSo0YyQDrEbcXKPuDfeJGrmcEA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03-Oct-25 4:47 PM, Jonathan Cameron wrote:
> On Wed, 10 Sep 2025 20:16:48 +0530
> Bharata B Rao <bharata@amd.com> wrote:
>> +
>> +struct max_heap {
>> +	size_t nr;
>> +	size_t size;
>> +	struct pghot_info **data;
>> +	DECLARE_FLEX_ARRAY(struct pghot_info *, preallocated);
> 
> That macro is all about use in unions rather than generally being needed.
> Do you need that here rather than
> 	struct pg_hot_info *preallocated[];
> 
> Can you add a __counted_by() marking?

I was using DEFINE_MIN_HEAP macro earlier which gave problems
when I had to define per-node instance of the heap with the
same name. The workaround for that resulted in the use of above
flex array.

Not needed, I will revert back to using array of pointers with
__counted_by() marking.

>> +
>> +	for (i = 0; i < hash_size; i++) {
>> +		INIT_HLIST_HEAD(&phi_hash[i].hash);
>> +		spin_lock_init(&phi_hash[i].lock);
>> +	}
>> +
>> +	phi_cache = KMEM_CACHE(pghot_info, 0);
>> +	if (unlikely(!phi_cache)) {
>> +		ret = -ENOMEM;
>> +		goto out;
> Whilst not strictly necessary I'd add multiple labels so only things
> that have been allocated are free rather than relying on them being
> NULL otherwise.  Whilst not a correctness thing it makes it slightly
> easier to check tear down paths are correct.

In general I agree but for freeing with a loop exit, the current
method appeared much simpler.

I will take care of rest of the review comments.

Regards,
Bharata.


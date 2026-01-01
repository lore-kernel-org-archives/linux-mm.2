Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D4BEE57CE
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 08:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E18046B0005; Thu,  1 Jan 2026 03:54:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5FD6B0089; Thu,  1 Jan 2026 03:54:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A696B008A; Thu,  1 Jan 2026 03:54:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B50E46B0005
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 03:54:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2FA211403A9
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 08:54:36 +0000 (UTC)
X-FDA: 84282784152.20.785505B
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012050.outbound.protection.outlook.com [40.107.209.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 12B20100003
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 08:54:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AHEmb2C0;
	spf=pass (imf05.hostedemail.com: domain of bharata@amd.com designates 40.107.209.50 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767257673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fc8aC9QJHD5H6wUDFiAJQ1ioX+HFT9RVjc6yTvTQo9o=;
	b=perHv0RV3vvHLitCovAWpzdH0rJ7M1NeyNL3D28V8YNIPkkKWQMQKHxxfIhcXaxjtdpuSB
	HKCtGZtXFjkLHtdH4xR7vgx5P/+C0mddoqRB/9ww/f8tr39ldu/1bBCZbBujxX9pHM0X2N
	hDVAQZnSk52B2GMAwMI08uU6knW3EXA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AHEmb2C0;
	spf=pass (imf05.hostedemail.com: domain of bharata@amd.com designates 40.107.209.50 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767257673; a=rsa-sha256;
	cv=pass;
	b=4Nk9dG0MFi+zfYCuHIJC3yyjW5d4ca+RGKog3yGsx+5FtcSG1RgXhVtY29GRYR7/S2HBmp
	y6rAheQjH3DsGL8XNeTI9zNfFLKZzbilQz7T4GIU007D9k6yUhLbFn1ZJtffp6iPmET5WZ
	TI5OJCQ+OngkYeGVshERtVYbhQao4HE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jdQRhApovGfU72j6uoeAvtrFZEIpu3ESzOndv73W4PVwa+48ffUabCSb2ScSCa+osnxPt2Q5RcZr6ngyFOq13DOr4N2CIeCfu7mMKcHg2rKUJ30q+0nmbLf9ObBfhOlftH6R/e1VOpXbsecjiI7pojFHpj86QOYzcpDqZkD4/U/EQ+Qul6Zz22tf/GQHu52qdNQvFtOEUan0JBXmGsJIeZfsomOO6PqjtnVl/q8ssf7FOau/7uctV52PXZgrmGlGwkpSci9w3CscMexnQP0nJwjKp+Hh2KVrYPIiuOi2eeTqjeqBdvyC16OXIMskza49LPc6CfAALKTBijbcGWOwOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fc8aC9QJHD5H6wUDFiAJQ1ioX+HFT9RVjc6yTvTQo9o=;
 b=rKeNseqgcK7+p8h4lvsULGrKcelpcerWAax2ctwfTteQlUNwgpsK9x/i1LSsSb1K8YkXlD2a6tjf7Q7YK04jTs8+FJbD+vpIxOc89wPJf8kxdfg7E1QX6tWlsbP6Ph6wxOItR5u/3KrABVfLGVZ2UV6US0Sl5mWqt57VTX4aGkTGln/MwXY+IiCt72IIljETJHs15SBby+GZq0ZWd6tRo9ooJcaFVu2NKAFbQ12RHlvoZCYZkFSQDKUZUHPiBy3UDFmeLRACgKbE5ze4zS3bIBK+hqTxZfSuujyFXAWQY629M6L9PZbx4sPqf/pFGQ38whEj9WNU1qG5TXn95sbyeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=samsung.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fc8aC9QJHD5H6wUDFiAJQ1ioX+HFT9RVjc6yTvTQo9o=;
 b=AHEmb2C0/MnA2hoKCGgje7mWCg76kuCT8q/MqG+Mv1ic/KxLkZD9ZJ0zn24GXFVVaZ281KtkaJpPEEBdKia4lXmGFhWifLejJXyxLkWgds8cj9S3LM4LdhBg9xNT+74KRm/zAAkxALFLliqC1svTgB3QyXCzz9ps01bzy9s2eGc=
Received: from MN2PR18CA0016.namprd18.prod.outlook.com (2603:10b6:208:23c::21)
 by MN2PR12MB4254.namprd12.prod.outlook.com (2603:10b6:208:1d0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Thu, 1 Jan
 2026 08:54:28 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:208:23c:cafe::37) by MN2PR18CA0016.outlook.office365.com
 (2603:10b6:208:23c::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Thu, 1
 Jan 2026 08:54:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9499.1 via Frontend Transport; Thu, 1 Jan 2026 08:54:27 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 1 Jan
 2026 02:54:27 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 1 Jan
 2026 00:54:26 -0800
Received: from [10.252.192.21] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 1 Jan 2026 02:54:19 -0600
Message-ID: <9bdc5926-5e6c-4468-a83a-9187a6888e15@amd.com>
Date: Thu, 1 Jan 2026 14:24:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 3/9] mm: Hot page tracking and promotion
To: Alok Rathore <alok.rathore@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>, <gourry@gourry.net>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <shivankg@amd.com>, <alokrathore20@gmail.com>,
	<gost.dev@samsung.com>, <cpgs@samsung.com>
References: <20251206101423.5004-1-bharata@amd.com>
 <20251206101423.5004-4-bharata@amd.com>
 <CGME20251222101745epcas5p43ca3a6a59efe996cd62769e8d57bb81d@epcas5p4.samsung.com>
 <158453976.61766398803526.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Bharata B Rao <bharata@amd.com>
In-Reply-To: <158453976.61766398803526.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|MN2PR12MB4254:EE_
X-MS-Office365-Filtering-Correlation-Id: f82a3b57-df8e-4118-e10c-08de49135ea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UURNNzVZM2tIN1EwOWhDcnVMZWNKMDdJczZHMnpBbG5GTGhWVWhpVC9xQWt6?=
 =?utf-8?B?QnBlRXdLZnJRa2ZCRW5rNHV5Ylo0cmEvbHRPNEdjME5Vc05KL0hXdlVXUE9O?=
 =?utf-8?B?Y28xU3hvNlFBUVRWL2hobDZIUXRoVkVSTVlHclppUCs1Z1ZnWkxuV2Nqem9z?=
 =?utf-8?B?ZjhraVVpL0ZwdloyVkxKQ2JQMjZzZkdIc3I2dkxOSStnUkdoWEZNVHc1UWdV?=
 =?utf-8?B?dCsvUkpqM0pZTnhCaEVXT29EWVJ4MGZzMFUrQXNtNHMvVTBYdDlBMnNIODhW?=
 =?utf-8?B?SVdwUkNuTy9LQTBxdmI4eUl2Q0hkUE9JNG1uYkQ2L1NrWTZDV2traTgwMXFO?=
 =?utf-8?B?WllrZzdkSllUVHJ3VnZlalQyWWhIUnp5d01Tcy91SDBaMlp3N0hiU3pCQUR1?=
 =?utf-8?B?N0JhclJnbWZJYy80bTgvVUVncGR4UVBzOTFRYjJMQy9LMHN4aFhKdWVtMnZh?=
 =?utf-8?B?NmxoSy9Fa1R1azFJN2o5RUVJMGtKZlJ6ZEJCajZWYXNrdUF1MThndG9UVEdV?=
 =?utf-8?B?d0FrTHNlNDBZWlVhWG5oeEwzY3VLK2FSc3A0SGppWHAxUHZCa05xRmI4TnIv?=
 =?utf-8?B?bWs3cXR4TW1wWnpPNWJLbmpxbTZVN05UR1pvQ2FWa1NCZ2ErNGRUQVpBNTBB?=
 =?utf-8?B?MFk2QUozM0pvcFNKazB6U0JiaWZQTkw2cnRTOHNYU2tpd0lUV016SktiemEz?=
 =?utf-8?B?WWdGS0N5clNoeHQ3d256Q0lLRG5NMUNzQjdJYlRYNWxhTm5CbXM5OTBwU2E5?=
 =?utf-8?B?MmQ2dzdEYStYSlNwVW1xSU9DNDBVRmY5VHE2R0VtUDdBQmVUZHZrZHdGcElY?=
 =?utf-8?B?dU9vdVBTUEhiTmlvaUVhRTVVVXVkL2pyQUxzVFJqTk52bUtwQ2duUVZjeVMv?=
 =?utf-8?B?NGx2K1BUREVid2d2WTd6QWhsNUo5SjJsV1FCTEp2R1c1S3hHQ0pNbjBNempO?=
 =?utf-8?B?UW5nRWIrWVhOTWpkK2UvWGI0Z1BWWFI4OWJsalp4RjB3RXFFWlBkT1Y1bHpi?=
 =?utf-8?B?VUhDRWF6VkFlRXJoK2xTMDB0TXVqSUJkWEZnZDlCNGZsY1ZIejNrd2Vlb0pL?=
 =?utf-8?B?bUcrdW8yOE1uWG5NNysrM29QSHUxTWtHSTR4WkRBblNNMnJ3b2xNR0lzb0FM?=
 =?utf-8?B?Vk1sRkdDeHZyaDJieHhySlFqZkRQMDh1eGRKNmY1cyttVkIvVXFBMXN2TUQy?=
 =?utf-8?B?TjBjbU5xZENxQUM2R1FWLzBhQTV6bklXZFlyWGtKdVRIdEdnWVBKcXFRTU5p?=
 =?utf-8?B?VDNjbHNYVm1IQVRadE53U3krWDdoVFlubkJ0dE90TkdNZ3V0elBkMUF3OTh5?=
 =?utf-8?B?N21SckhhL0pGWUxhZTBhTzkyUHF1TFBMUitMcTV0MExQRmZvVjdIS052UXRi?=
 =?utf-8?B?a1pSVTA5OVJBQTZJYm9mdFZTSCtZaC9uUU1uUzRRVU9Jb2dHWjMxTTF1SHAy?=
 =?utf-8?B?Y3VVODRlZDVLeTB0VWVXRFFVbFdiVDZtYTNiYVU2T2ZKR1hvdWg5cEJ1REN1?=
 =?utf-8?B?SXlvR2prM1d5RklwM1ZsMGZyNkV4QWxMRkpaNDJja2RqSGJueUtVbWlySlZj?=
 =?utf-8?B?QmJGUjhTaVhGbGtZWjl5WnA5UzZ6MjVFZHQ2NFk5dWF0QXpESlIxUGdlVTZI?=
 =?utf-8?B?dWtWYTQ4ZUN6SjZLVGZHa3lyTlg1UFdVTTJiTC9lVDYwVVVQQWc2ZEQyYkt3?=
 =?utf-8?B?bkdKdXI1aWwrSnlobEo1aTBhOHMrZHlQNGNmYkViU3Z1WEN5bkltOU1laGNa?=
 =?utf-8?B?MUtVWVhPREpkMThuS1FWRWllVTZGNENHeXp0d0F1V3JNZEY4Q0ZPK0g3cytX?=
 =?utf-8?B?djV1UkdHVHczaCtoa2pyTmp0RW5XdzdZWk0ybldycm4rVEJ2QThPdWNPZ1Ju?=
 =?utf-8?B?cUs3QTJCSzdHQ3owVGJJWVZtaUdWdkdhQ2xLMU04Y3ArQ2ZqcmhIUXdVeU5T?=
 =?utf-8?B?anRZR1JJSVVtb1hQMUNLaGRqNUF6blJwR2dFVC9yd1J1MnUwMWxJY1lWUHZL?=
 =?utf-8?B?Z2hwM0M2RW0wNCtNcWdySXF1dWlhR1lYdDBrVUZMR0FPTVJnYk5laUZuVnJB?=
 =?utf-8?B?OEJjWG9NVUZDK0dkeU9QT2IxNlFUaGc2b0g0T0Uvbnl1a21FcFR6YUpTZXlP?=
 =?utf-8?Q?pYKA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2026 08:54:27.4090
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f82a3b57-df8e-4118-e10c-08de49135ea8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4254
X-Rspamd-Server: rspam02
X-Stat-Signature: jwbhpsjxh6q84u1sqqi3ps4odk9t6h9j
X-Rspam-User: 
X-Rspamd-Queue-Id: 12B20100003
X-HE-Tag: 1767257672-391339
X-HE-Meta: U2FsdGVkX19ZenOUFaFo9wQWaDm4wCr4I3fLOCIklSvtp/nUgEf7xN0+MAbT0VtSpj+iW/ZxpzpxCaZZFWfGimb92gK2islq1wHCDfpcMV36YGowsq5hONWSdenO0bbChYsgr4uUAyiZseGzsWCpo2kthK7ui3R1a/1LACn1GnEVMjP4WPGYb8DkdX/1n1YhxOMQU4EWYzuMGKmprWJyCvZQgyyJPExGQnfoM+Dm6+EiDTKjKjegP920uDwpN4jwzjbMQue/4+R1b3Qtdml8FNIiHYEtReDt2Dt4VjqRn12sSjsUNWQJYzQA6e3gwraYYKTlXDFoCJGMZ0n+JNqqXt0tff1/ltp4hUQyEDqkgbo4Ew6XIdr67vO0tMynfHl9vyqpBEbR1BHOZSVNCR9wQcWOmT9Vmpp9ijSe4vnQczgIoUV54MPA7SmaQVr7NCP6gC31iUeqpaxL5GSUiLekK9rWggEEO40dHhmuY69UseTuBgj6emwUrAOzsQJVOkFdGpQ1vNWszwXKfLhEzYB+RhWduMl/N78rRtd6Ve6O5/DKvN27R4v7UsvuZt5dxPMV9OoaWJ7+E2h1TWrfn9bFw4zELDQjQNf/0wDfUAqrW7h1HO0+Bj4h5ojI30BeS3VTWlxdH6FDP4TlFHrU2WTcNaFesqS3f1G2rdHpMLrgiNaRH60OCUTEFknT3g++fYkkziJxFSJClsHJ2/MgpHGEypfO1E9Kou2WCjgqlyomTe00ev1KX2bF+PJpn5XVnXnwbOZcnBduFig9gsLZZo7syqKfEK5fh80iPD8+JYM+5gfcaYfIvdRTihYsmbyRhDU6N4s8v/ZKUHKKM3lB93W6sfDjTrkRTFBWrQ9lYw4tQ6E0t8sp2mhydchLTloUjyvwKLa/QXDNvmcvIo2/4cjaB+vU64Rs451ydVf+7d+GgXHAUu8AGbDq+Dm6JzmrBLYyX9sAReznXYD/3WVpcLh
 9cXZWQAD
 CO8fdzk3dIKBoksT1H20UOCltH76P/k66MqHA+nTC4SHzIkeUIEaEbTSOl3t5L86eOSReXaHcwMhWPBx97tvN1eDvvm7CnILptII033hSP2p6C81SEUBYCA2CU/j9jsGgMqw3MrWJhnuyXBiST5+6Im4M+ZIr7M2P6d0AVtGOc686rU8phO094BGCPfXHjeTRj2ya6FIqwc4+U6qOhvJdfktKkYBvCtsh9mXpAquVv1i8QzNRKVTZv+EwLLw8u5pu9FR/9I/HKVS+f8si+LQFl55r8MSj2hCY4/XyIS61bj3+kzt4j8tftR8Ye45KAcCihsUehH/9J24RzPYsHhXxm3LJx+7ZOh/8mPIVGhOrYwsSwWCbvmorLnKzOimMv8Dimn1JwKbZxGX/aRg5q5SehXV5o3i7qf5rly2D15LoDg8UZHucxzaGICJ5Aoh9Rg7Bm9otbNKnd7A4DbHDXf4gRpfG7O4egWyoH63IgdN+PTL9bv1g5RmeG7BD8hSK/H0RW9VQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22-Dec-25 3:47 PM, Alok Rathore wrote:
<snip>
>> +
>> +#define PGHOT_NID_WIDTH        10
>> +#define PGHOT_FREQ_WIDTH    3
>> +/* time is stored in 19 bits which can represent up to 8.73s with HZ=1000 */
> 
> If we consider HZ = 1000 then using 19 bit time is coming 8.73 mins. I think by
> mistake you commented as 8.73 secs.

Yes you are right.

> 
> Suggetion:
> If we are targeting to promote page in ~8 secs then 13 bits would be enough,
> that way we can handle hotness using 32 bits per pfn insead of 64 bits.

Right, we will have to figure out how many seconds would be ideal and it needn't
be in minutes and hence we should be able to fit everything within 32 bits.

Based on the discussions in Dec 18 Linux Memory Hotness and Promotion
call, I will check if I can reduce the overhead further and have a configurable
precision mode.

> 
> #define PGHOT_MIGRATE_READY    31
> #define PGHOT_NID_WIDTH        10
> #define PGHOT_FREQ_WIDTH    3
> /* time is stored in 13 bits which can represent up to 8.19s with HZ=1000 */
> #define PGHOT_TIME_WIDTH    13
> 
>> +#define PGHOT_TIME_WIDTH    19
>> +
>> +#define PGHOT_NID_SHIFT        0
>> +#define PGHOT_FREQ_SHIFT    (PGHOT_NID_SHIFT + PGHOT_NID_WIDTH)
>> +#define PGHOT_TIME_SHIFT    (PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
>> +
>> +#define PGHOT_NID_MASK        ((1UL << PGHOT_NID_SHIFT) - 1)
>> +#define PGHOT_FREQ_MASK        ((1UL << PGHOT_FREQ_SHIFT) - 1)
>> +#define PGHOT_TIME_MASK        ((1UL << PGHOT_TIME_SHIFT) - 1)
> 
> Mask generation of freq, nid and time seems not correct. It should be
>  
> #define PGHOT_NID_MASK         ((1UL << PGHOT_NID_WIDTH) - 1)
> #define PGHOT_FREQ_MASK        ((1UL << PGHOT_FREQ_WIDTH) - 1)
> #define PGHOT_TIME_MASK        ((1UL << PGHOT_TIME_WIDTH) - 1)
> 
> Can you please have a look?
Thanks for catching this. Will fix.

Regards,
Bharata.




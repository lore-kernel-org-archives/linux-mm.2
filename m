Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD3C9CA1014
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 04:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CDFE8E000A; Thu,  4 Sep 2025 00:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07EA28E0008; Thu,  4 Sep 2025 00:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A158E000A; Thu,  4 Sep 2025 00:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C6FA98E0008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:05:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73FF61A0993
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 04:05:26 +0000 (UTC)
X-FDA: 83850228252.28.2FACA0E
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013051.outbound.protection.outlook.com [40.107.159.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F873140008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 04:05:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ju+Kh4pD;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ju+Kh4pD;
	spf=pass (imf09.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.159.51 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756958723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEcYzUrBLoL9fvxpHRauic8mvnDVuTLMIzkLfXOwpmU=;
	b=zLmLJqG+1PFNUxhgRQtKko2lyNWmgrpr1NzwHzr5VCigz2LCfl1d8SyY1buplvWaqG5Asb
	4NbIquaq+VuMUjjPmQ4r0fk8VH4pi3TndcQgYqQEI5uVBSJEY8xQLHm7K1VPQhbUj8uDqC
	fonM+TarwuMgz+4RHrwq/DGmlR0h+jY=
ARC-Authentication-Results: i=3;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ju+Kh4pD;
	dkim=pass header.d=arm.com header.s=selector1 header.b=Ju+Kh4pD;
	spf=pass (imf09.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.159.51 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1756958723; a=rsa-sha256;
	cv=pass;
	b=JyiLCZs5PEGdSfqWclOCUqjrgDCDSmelTLSTHnS8JiKSehYww1IAsP/PwBREly0UXcB0dX
	8Yc9ZbWIZ50HknhOJKUzRceAAeqo0E7ag+tEuU2yEcM3CF4jpKHp7SZhji0ztF7Rmgd2/m
	qu9yk1gxC4eEV8cX9mIIY7hoorR4J9o=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=rlHu+lVABU4F+vaH4bLDqXJz0VTyx1lopJig6vvEb//hX/8OC4gsA36Hstaef5nwRty1BE2rCvyzJiYcsZ+oGEJbcf2R4hlj67w/6XoFbtekV2y+cT2Nt9HDqTYnWtwTN1pAIPFsEhCfPrSAcNqC7hugZdJmql2GZHYbQrEZ9KHrP8dPnsmrcfz3j1V6+PVi3iSW+5ePTf9ivzq56n5u82ZSK6/Ro2v9P4/5bPd23Ptx6X1K8G3ywGvUjPgUkJQYgf8KDuFtFNlgQAOlK/SguneOzteWEXAQVcKbvbh+NKnMUXOoiNm4GI3JC6ITwqpeGPbZAtPBVXHJmQCnQloxLw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEcYzUrBLoL9fvxpHRauic8mvnDVuTLMIzkLfXOwpmU=;
 b=dc9MvZCiNBK+jNA7Um6z8gsX2k6UcAyrHPVnbz1+lZXrGKfVixlVlp3Yeoj8LP9Cvq5wfWk4q5aRORIHkQ/BrRGZd0X1ogBDNM7xGGxB75zelw3GU8VMhD5mKyPI2BzsHey8acF3x9FIvc8zRQVl78U/ZAN6o0baoJljECPxjX9J1GDGoH4C96zUGkIwk7p5m+cSdv2fFRMWNho7tMEUjycJOivM2j/KtkPrbFeJfPPcIeKAHAjZ/TDngXdxJ7e8IQsooTAsuYpdz/QHIctd6tRisgyxaeMemxGN7qon8LZuoIZ/IfysvlH/xIYsusA4a2CnZcN6UkipVKN5tLFZyg==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=oracle.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEcYzUrBLoL9fvxpHRauic8mvnDVuTLMIzkLfXOwpmU=;
 b=Ju+Kh4pDG9/EVgphxkA2APtX5YV0GLdemQXEdT+7YdRuWwC5LhvXvDWKZxBhBYsQKQaF4pvNrXLxi5Dm68PqFd56P+8lcY6tH3Mh23LGIdzWWs1xEXe0MIUTvr8AxM5cD0t5Tg2czSHtetx5ZdKgNt1IU151JEovqBR7KZpYKEg=
Received: from DU7P194CA0004.EURP194.PROD.OUTLOOK.COM (2603:10a6:10:553::35)
 by DU5PR08MB10635.eurprd08.prod.outlook.com (2603:10a6:10:51d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 04:05:15 +0000
Received: from DU6PEPF0000A7DF.eurprd02.prod.outlook.com
 (2603:10a6:10:553:cafe::89) by DU7P194CA0004.outlook.office365.com
 (2603:10a6:10:553::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.27 via Frontend Transport; Thu,
 4 Sep 2025 04:05:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU6PEPF0000A7DF.mail.protection.outlook.com (10.167.8.36) with Microsoft SMTP
 Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.14 via
 Frontend Transport; Thu, 4 Sep 2025 04:05:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fvdVu8qnBlG9yaFBJShRZMBNh8sPGGr6bfsqPjSPjJfTvbYv5aP/pM03HCrpggG6QqNuGyNJuLYlZdEUzkpr7q947iZrNdwbAB8c14808gwx3dP4X6wQ4nttOuKcaJsmm3+t+s65HNHv06Z7VifHIArzuNA/iPqLfGA7GmwGhlj++HnyN4EFRqsoaFWrnIPq8YLZzW0VjsN1kTnIYmJmTIuoaZg6Gti7+rrfPt6J1lspeDEoSNE0pILYEpswQhSKhSjq2xtCNwwuHJ1M58rDbTBJD7AZQic0gW6iTACtDBYxxT2ajn2u5v/0CTg+waZcslOn+1sDtF0KMiSfqzktbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QEcYzUrBLoL9fvxpHRauic8mvnDVuTLMIzkLfXOwpmU=;
 b=pgZZRg97spT/ZNKRddvMwlt1oAlno4UhPLU7oUq9uxHoTz6ORppb25AjajbS0VN3wZ3VRkVBFLZj2odVBl4X7Zm4X8WDgd8IKEE7didY1ZeQT/1bv+oh/bU85rHMYkyq9+/Azme3NnAXoW+AnXYXMZYvCJ5P2vD5hguoE5EtVIJCsbyRgTvmP/nrt587FIKrFqh53ZFk9tSD1mO+AQZxbzB125Bl6u2Ov+0iv21BIos2zzqbwBinkxhMNuvUlGm9R6gWWF9hCbO7QbZTNUMGmm7xA5T29iUmNWYAuHrcItNRM4hYUVOGiH59VmlCOxrWmQuqsNkDQ3e72ukWxKIXqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QEcYzUrBLoL9fvxpHRauic8mvnDVuTLMIzkLfXOwpmU=;
 b=Ju+Kh4pDG9/EVgphxkA2APtX5YV0GLdemQXEdT+7YdRuWwC5LhvXvDWKZxBhBYsQKQaF4pvNrXLxi5Dm68PqFd56P+8lcY6tH3Mh23LGIdzWWs1xEXe0MIUTvr8AxM5cD0t5Tg2czSHtetx5ZdKgNt1IU151JEovqBR7KZpYKEg=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by PA6PR08MB10470.eurprd08.prod.outlook.com (2603:10a6:102:3d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.18; Thu, 4 Sep
 2025 04:04:41 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 04:04:41 +0000
Content-Type: multipart/alternative;
 boundary="------------auC0hCJI3d00D4noU0ENBizz"
Message-ID: <6abceb3f-e988-45cd-800f-2b54f9a92e26@arm.com>
Date: Thu, 4 Sep 2025 09:34:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: Enable khugepaged to operate on non-writable VMAs
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, kas@kernel.org,
 willy@infradead.org, hughd@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250903054635.19949-1-dev.jain@arm.com>
 <9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local>
X-ClientProxiedBy: MA0PR01CA0017.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::12) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|PA6PR08MB10470:EE_|DU6PEPF0000A7DF:EE_|DU5PR08MB10635:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e4826c4-ae57-4858-65ee-08ddeb6840aa
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|13003099007|8096899003;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?XHOWQwIhfXZNeDrLnLUL0PF0cY/vszaqFiiv73hR/U8H+pDvHYrKNzWK+0Zh?=
 =?us-ascii?Q?HZjSQmqiROxhaPIgTe9SOwG9Yn3ewVYe+siDwakknSwsTo7b6eGheamhoE+T?=
 =?us-ascii?Q?CCSFPG9ZYq9CuoS9KRsaa7hz+1/eWE9B827JmN4Jr9h87tg8X1tIfkjtRtQK?=
 =?us-ascii?Q?sm1+lZ5u56smixVh8zIvZ3CcvYfY/ru6d2CcqOyb0rGtLsPGc8st7MW8VnaR?=
 =?us-ascii?Q?k295alZAT87h1+r9Ieq23xYJzBlsRLY/Onx4xtXOKmIETp2tv50oghQM7V+C?=
 =?us-ascii?Q?mtW97i/ixbs/ADfbe+e2apS3WMDcIIUuvVqNA1b0zOKnUJzhBw2nrDKrcrk8?=
 =?us-ascii?Q?9fMa/24OjwaxwqHsxczyy9hRA23rp3XsESYr/ZCXtjN09Ty3ZEZAVOt8HEOR?=
 =?us-ascii?Q?wTI5QhlMoMiBx52DIXDD72eJBEjoaXFBdAQve7SQd0nFfEyVJh0h2q2cZRGI?=
 =?us-ascii?Q?FkGrtH7EVbUMRiYCCOy1ZrTGiVnA77F129xIEGc+JGau56IJjbXgofHB/PTt?=
 =?us-ascii?Q?syo8Hab0wjwDfNSUKjcOmnJRy+VjWCfgzHfoHlwDN6uxoy2m07qB2dIQGsLB?=
 =?us-ascii?Q?oeg2hVmmhEPiD5hywmviy3Ye+fT8L7EZH0Xz/924bOpHKgNQSKVfii6WzI75?=
 =?us-ascii?Q?Nk43TsMfnB5I7w69dSaEWVvQ1aeP6rxWjdoUaz5Psls1xg4qz1rcGAzjdO0h?=
 =?us-ascii?Q?B3iPLkI5mX7CU4Mk+5NFBsq99LwJJyizPT/414tvwc81nOHE1eJzZLDX0Ljn?=
 =?us-ascii?Q?7Slz4cMFBVxitK9R9K6rJ1wFuwu/FT3dmTrm+mExS5lFZcVTc+L9xWRrRMvE?=
 =?us-ascii?Q?TViKEPH4wplgiLxraj1k7fLSXFrtnRvKNvoHCdz4algJLL9WfhP7qLgBdzi7?=
 =?us-ascii?Q?IZtvY64o+WlbhfZbIORFw4wL8pB4LrK//Xc51ueOPyNjjNXqxSBKZhAn/Nz4?=
 =?us-ascii?Q?COsubyKm5Pl/KSRPd40wWwrpJcdxpekVzibMS/uIizDJCWgEDfscxIYgntiH?=
 =?us-ascii?Q?WCL3+ttZ3tds2qAH62UhGfDh/o31IuJ516fBcorS1Geh4W7O7o+5glKA0jTX?=
 =?us-ascii?Q?FWDXTQ4kmGIbfQakkfSu8JAz+wkvf+NYIf13bEut+Ox7TxmELoXlgmVdffsp?=
 =?us-ascii?Q?9wZWJw9aF8fDQGlE0aCzz2zKNbAz7QHUZwEWC537ZgiQHuca23smb4JPBUuu?=
 =?us-ascii?Q?xAw/WLvj9hG0A4HvXBOFMQyDgR60WkN1ZX9lsL7EGqZ2mHFwnvLUd0uiyZGM?=
 =?us-ascii?Q?oIYCrG0Hnv15BzKDZGcv1AA1gOQVKwPT7J3cmpzh4n5PkUICwyc/v7VnJ+Bk?=
 =?us-ascii?Q?m1VewpGAUM4ogHsPoIncEvG7iTyiNhc2vsJZQcSKaS+yGnCeLp+NlX3+cg7f?=
 =?us-ascii?Q?1KASJq3S7sgpDHKFVUCX1mUbTlj7820B4t5/sSsKtPk2UW6owLxKARgBsoV1?=
 =?us-ascii?Q?83zHwaGkrOI=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(13003099007)(8096899003);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10470
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU6PEPF0000A7DF.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a4616d37-51e1-454c-cf6c-08ddeb682c43
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|35042699022|82310400026|14060799003|7416014|376014|13003099007|8096899003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R3dRMHZEYmNNNnIxbTZ3UnYxSjA1UWtWYTgxays0Y010WDRvNHVHcUNtRnpY?=
 =?utf-8?B?dHJWSnUzK1Zmc2QzU0JzVFA1NXk4YXdabnQxajlSeGE2VGFxbzZWMldGR1R1?=
 =?utf-8?B?eklUeE9yd0FFVFBrUG1BellveGdPLzZocHNDdDY3eUd1Y1dUUkZFV1IwTVN4?=
 =?utf-8?B?YmRJQ1FqZm8yczJXenh2RmVWenp3bjdDWWxDK0dtL2FvOS9XdGMxUE5PMUJ5?=
 =?utf-8?B?TjdQemRueVNHZG03b1pOWW5pTmxUU1NSWTlYZU5MUmFwaytveXBXRHdQYW5r?=
 =?utf-8?B?aEo1VnVKNm5aU1VwL0FPcjhPRWxrYXY3YmlFOVZOTFN2YzFjdWlvbHozWHZh?=
 =?utf-8?B?Vkd4RlVzdXpJelhZSXFENUg5R1RMZ28wbjVuZWdGSVBzNGJFQVNsYldtVWVp?=
 =?utf-8?B?aXlaUm1sZ1A0REk3Z1A2SlpBOU91bkdkN1lLOWEzRlBERUZMYkJ0VXM1QVFU?=
 =?utf-8?B?dWNqekxncjRyYnlIUnFuczNkeVFYR3hZajJKWWFlY25XdlQ3WUlDMzg0eGlY?=
 =?utf-8?B?SFVDaU9tOHNlSzJlUnJhMDBzOTJLdkt4dHFBOXBBTkIvS0haeHdNU0h1WU1k?=
 =?utf-8?B?cEQwK3p2OWJsUk80NDVuR3FwOVRwOHJtNFFJVTFHam9lNzRQaGkvNTFXNjd1?=
 =?utf-8?B?bkRFSkNYU2s5VXFGN2xuN25CbnlKaSs4cWNycHhpakJjUHhuQ2VtNnNoaW42?=
 =?utf-8?B?enNzaTF1aUNtS1V1TURLZ3Y4UXpVSkRBL05mZU05VEJTK0Z4aWlwdGRMbUVF?=
 =?utf-8?B?YXpGUDREc0RlUXorS3JHWTJ1U3NQTnZGRWNxRHQzV0RpNnU5dUk2d1JDaVVR?=
 =?utf-8?B?RjZxWlh1T3Y1UzlocHNjb1dhTmFjM1h3d0R5czZkeGdaeHh0cW8wTEZldjJy?=
 =?utf-8?B?cnhENExzdmpiVzZJQXJLdVFDRDhvUDhCM2pEbmZvNHFndVpJVDZ2enE1bGlU?=
 =?utf-8?B?L2VHSkQrUGhydHNCZkVSeGFEUDVBWmx0SVA3T2lBMER3MG5CTVVpVzBib3hx?=
 =?utf-8?B?RHVLSC82cFQ3K1pIUXgwakpnTEFHbjFUMzVlS2RGaVdaMjRxdjdMQVFaMWV6?=
 =?utf-8?B?YnUwL29wb0RWbUlqWHN0OTJxS29ITk9LTXJmdDdMK3Q3TWFnYUdjazdpSE9t?=
 =?utf-8?B?Q0FMdkZ3eFl6a1JiRHgxK3Z6blZ3WGRZQVUyQWRvYWtjdFdSR0ozY0hUeUc5?=
 =?utf-8?B?bENSOTB3L3JOaWtaQWwva2NUNm5sdGlleVMyVU4ybWR2aHVvNjMrQzRxZWdu?=
 =?utf-8?B?NXNiQ0tqUCsxMkswdmhScmdlcHorbGhVbVprNzMvbFBmNTdBclgreWt3ZDVC?=
 =?utf-8?B?amVxaXM2amthZGlmVDdwOEU0NGlReW5DTVg2Z0g5TmVURWxyeTJJNElBdzlm?=
 =?utf-8?B?bStvelorY1hneE5zRnc2azhnMmNoRlQ4QjEyZFA5Tm81aFdqQWpFekw5UjB4?=
 =?utf-8?B?aTRmdXgwUUxDZWEwWVF4ZXdCbkVZKzhJeWJFbHJRMFUwUFBYVVNFeVR4UmJJ?=
 =?utf-8?B?RGVoYzJzQmhCRERuRGFEd0V2RjNJMFJOQ3hjVlpTekgwb1I1ZmpkZmFubGk1?=
 =?utf-8?B?TkhkV3J5L3VtdlM4dGZrWDVabm5rVVhERldoRkVaeWM1V1dFcmxYa3g5cTJL?=
 =?utf-8?B?TE1pcm1BYjlLSnZoOWU0S3hGV1N5SWMvVFFkNTRYYXRPWWhZbWIvb0hpbHlJ?=
 =?utf-8?B?cjdwNmxPNGErQi9TK2N0cXcvNEYvOTdRa3JlbHBvZ0xRd29nazBrTURKbnll?=
 =?utf-8?B?U284OU9SNHF0YTNVSElUclZldkRtaDRVenBBQVdlSjdiOGpicWUyYkxvMDM5?=
 =?utf-8?B?KzA1QmNsaWdqYStscWVsVmVyMzZ1VklZZmRBMzFnekZETHUzNEJqdGMxdndF?=
 =?utf-8?B?LzNsN216cEZuUSs0Mm01UWtzdnIyZUZacjZwNG1vL2Y2dkxkRWhsNExlMVZj?=
 =?utf-8?B?Mmp5MjRoUzg1VEJmVUxSMjVvSDR6K2lYY2hiM2Vib0FqdTllQVdwZU9saGww?=
 =?utf-8?B?Z3VmQUMyYnorMGtua3Q2TGRpQTJvNWcwSTJJWE9sRTI3SVYxSDRuQkJaU3pW?=
 =?utf-8?Q?gJmWbF?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(35042699022)(82310400026)(14060799003)(7416014)(376014)(13003099007)(8096899003);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:05:14.9430
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4826c4-ae57-4858-65ee-08ddeb6840aa
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU6PEPF0000A7DF.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU5PR08MB10635
X-Rspamd-Queue-Id: 8F873140008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 57rwqhbzbomfy9tgdipmcq9gtpmbzd93
X-HE-Tag: 1756958722-330381
X-HE-Meta: U2FsdGVkX18VaiTTLQa8qVapAaTwjOK6Un76VY3NJfO9i5AkqzCRlHf5dxsrJEaE+rgoAAmS0uXi2bNtDFuDkUKD4K2pHoSc/uv7a91hWMkaYg4+PUF5f3CpF5DNpeGl3EpWOMErojk7WeXYhMxs097x72fo/xfd1KUOiMLoDF1G9A/cTe+EXDyLouUi83KPkAsh3FbX2v6X548ucg5fnPev1PwAPZnTd7nTe8/phQDG+JkzkpDEUZqermOwo06vzULjoi8utnx2RGOXP1JtOgn+xJLXAICVXH4KLDIoml1ScjYNn1u2udh8vnaY00Oq8a4udR1/kpdWykrPehjjghE3hHw8Nxp2PjqGuzqQg44qYFluFkt5dq8yppZ6RO1jTHXqYcN/RTMvjRN/ghiybQpIz0qunt2lvZD472O+t25k+844X7QgvKP0Zm8OG+1LSwHGJZKcNqlooFAF0LgRmdv6ge4fK2HuYEPK1dfntfHg+fK17y44NnG5DQrLIZIb1I8RQfJVwoRVJDIn29hSgU6GWfLJ72BQUXTywVtmzwoUZZoZ1NdIWRf+Z4z+jxrl7KwfbDoJZ/7cf0HWy89usLZALM2N9IrwyMjva036opi5KHdXEpeKeasRomyJa0ZilBzTVMwaZYg3rnAugzWAcXwwaVWPlwPaPH6zKSMxnAB0mLpDi8IhHZdzZDdgSUlNwEQZFVrrwHKmgnMjVwgJVguq2B4D3QZ8C76i4KMUN8ARHLQQsGkBRnT4DEBAxlEITGDZwSEkkAa4t/2hOB99o8miONpzbIbosiENRIXMaBJ1bwD2RMKMbLb8fWjrszTv/ZZ0Bon9qIRsI3gfecalnm0ajIRxNuPwLQaky/qbWyRA+JKi5B9YH9gmUuCuv/pgfBJ1nhG/4OgjBRG0aJU2IJWJ8rsowxS8jdale998NvS5qTv09R5NVz2sIGnFExRY6SSeRUwXXTOmFAbaFGL
 7Y3UbXSH
 xp43x2Pdtc4XX11FPJo4/pYzFe0HHFc9hYJVPVw3F91QE8WhDbigg+vT+diPW1lsSUZzTY3QSF3ZkxUO97wEVNVS4FA9uYivUaetIMRArafhsVhIaqWda//dCGZM1QReO8aNRT8TXuqEZVKADiD2YT41ViT2arrXVgbdZrASJwHo7/W6Fdq197RopnF2c4YMbWCrOLm56ki9hwEWNAB1XQH7yLBz4oSKiEe+bbBAz2Vwtu6GLGABP76mCz+BRXQUPlf5ek5+aNW9XWRKbEUsU5Yv8sjR/Ky4IOMgY8N+pFiI89sjmCFJpupamoHGQlNMklWhg/vbHOJ2vND+cCECYSg1fEHXQ/fpQ4QmPLxVGbxVGbCfgeVgXB+azhCyxMwKP0POoloncFBPg4aEqSpZHBBIgVrOReSXnHc7pI2YDwuSKjHnIW7LPUO4fP0OugeCJeN60rEBQKwvbTKMZcAWsnWxjUV95nzHjJCFJHicSE79olIl+/C7NUY1itrdrF8SjPNrC1BVnBdyhDTZ8CD7+lagFqzqEWvnbHGaS3iwCJRY377+WaW4pq5rH1HEurVeaSUZ//p8jYXPNf/UM9RCCDd6kfs6ZGXZ8TDzVUDTOFO0RiuXfS2Zw/MGEXvaPuGDY/ou8fIM0P/6csXVfsQi9/ZfqnLShLxXvAyVR6A1vIyCwJhduRwSZpoBKNq5ixR81NzME6pExUUsPnc7grt/ZLVAOuT3vpVweUYJXD+s07qxDa0aM4M/PRVJ6JiJEcLBUWyR5YrFR4BwTqUqsnDZFtRj/Iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------auC0hCJI3d00D4noU0ENBizz
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 04/09/25 2:04 am, Lorenzo Stoakes wrote:
> On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
>> Currently khugepaged does not collapse a region which does not have a
>> single writable page. This is wasteful since non-writable VMAs mapped by
> As discussed elsewhere in the thread, you really need to clarify that you
> mean the PTE is writable. This is far too vague otherwise.

Okay.

>
>> the application won't benefit from THP collapse. Therefore, remove this
>> restriction and allow khugepaged to collapse a VMA with arbitrary
>> protections.
> It's weird thie history of this, it looks like we were super conservative
> at first, and then introduced this 'at least one PTE writable' thing in
> commit 10359213d05a ("mm: incorporate read-only pages into transparent huge
> pages"), but it doesn't really explain why you even need (at least) a
> writable page.
>
> Perhaps a pre-PAE thing... (David?) we already do the refcount stuff
> though, so it's hard to understand.
>
> It seems the main case for anon where it'd matter is swapped in pages
> read-faulting for a R/W mapping (as read-faulting R/W mappings would just
> get you the zero page which vm_normal_page() would exclude anyway).
>
> But not sure why we'd be reticent to collapse those anyway... you'd just
> cahnge R/W bit on PMD instead of PTE?
>
> Yeah it's bizarre.
>
> I can't really see why your change shouldn't be done...
>
>
>> Along with this, currently MADV_COLLAPSE does not perform a collapse on a
>> non-writable VMA, and this restriction is nowhere to be found on the
>> manpage - the restriction itself sounds wrong to me since the user knows
> I'm not sure why a man page would talk about PTE scanning implementation
> details?


Sure, the manpage shouldn't talk about that, but the consequence of this
PTE scanning implementation is that a read-only VMA won't be collapsed,
so the manpage should have at least talked about mapping protections.
So a user doing a PROT_READ mapping and then doing madvise(MADV_COLLAPSE)
will receive -EINVAL which is extremely bizarre.

>
> But I guess as you say you're thinking specifically of a read-only VMA that
> naturally has read-only PTE's as as result...
>
>> the protection of the memory it has mapped, so collapsing read-only
>> memory via madvise() should be a choice of the user which shouldn't
>> be overriden by the kernel.
> NIT: overriden -> overridden.
>
>> On an arm64 machine, an average of 5% improvement is seen on some mmtests
>> benchmarks, particularly hackbench, with a maximum improvement of 12%.
> Nice!
>
> Is this on a raw metal machine, or a VM? I thik it's important to clarify
> details like this.
>
> Please state precisely what you tested this on.

I am guessing these benchmarks run in a container but I'll clarify this.

>
>> Signed-off-by: Dev Jain<dev.jain@arm.com>
> Can't find any problem with this, and doesn't really seem like it'd be
> problematic so:
>
> Reviewed-by: Lorenzo Stoakes<lorenzo.stoakes@oracle.com>

Thanks.

>
>> ---
>> RFC->v1:
>> Drop writable references from tracepoints
>>
>> RFC:
>> https://lore.kernel.org/all/20250901074817.73012-1-dev.jain@arm.com/
>>
>> I can see performance improvements on mmtests run on an arm64 machine
>> comparing with 6.17-rc2. (I) denotes statistically significant improvement,
>> (R) denotes statistically significant regression (Please ignore the
>> numbers in the middle column):
> Let's drop the numbers in the middle column then please, this is going into the
> commit log, let's not put extranous information there.

I'll go study some Unix commands to drop that middle column :)

>
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
>> | mmtests/hackbench                  | process-pipes-1 (seconds)                                |                 0.145 |                   -0.06% |
>> |                                    | process-pipes-4 (seconds)                                |                0.4335 |                   -0.27% |
>> |                                    | process-pipes-7 (seconds)                                |                 0.823 |              (I) -12.13% |
>> |                                    | process-pipes-12 (seconds)                               |    1.3538333333333334 |               (I) -5.32% |
>> |                                    | process-pipes-21 (seconds)                               |    1.8971666666666664 |               (I) -2.87% |
>> |                                    | process-pipes-30 (seconds)                               |    2.5023333333333335 |               (I) -3.39% |
>> |                                    | process-pipes-48 (seconds)                               |                3.4305 |               (I) -5.65% |
>> |                                    | process-pipes-79 (seconds)                               |     4.245833333333334 |               (I) -6.74% |
>> |                                    | process-pipes-110 (seconds)                              |     5.114833333333333 |               (I) -6.26% |
>> |                                    | process-pipes-141 (seconds)                              |                6.1885 |               (I) -4.99% |
>> |                                    | process-pipes-172 (seconds)                              |     7.231833333333334 |               (I) -4.45% |
>> |                                    | process-pipes-203 (seconds)                              |     8.393166666666668 |               (I) -3.65% |
>> |                                    | process-pipes-234 (seconds)                              |     9.487499999999999 |               (I) -3.45% |
>> |                                    | process-pipes-256 (seconds)                              |    10.316166666666666 |               (I) -3.47% |
>> |                                    | process-sockets-1 (seconds)                              |                 0.289 |                    2.13% |
>> |                                    | process-sockets-4 (seconds)                              |    0.7596666666666666 |                    1.02% |
>> |                                    | process-sockets-7 (seconds)                              |    1.1663333333333334 |                   -0.26% |
>> |                                    | process-sockets-12 (seconds)                             |    1.8641666666666665 |                   -1.24% |
>> |                                    | process-sockets-21 (seconds)                             |    3.0773333333333333 |                    0.01% |
>> |                                    | process-sockets-30 (seconds)                             |                4.2405 |                   -0.15% |
>> |                                    | process-sockets-48 (seconds)                             |     6.459666666666666 |                    0.15% |
>> |                                    | process-sockets-79 (seconds)                             |    10.156833333333333 |                    1.45% |
>> |                                    | process-sockets-110 (seconds)                            |    14.317833333333333 |                   -1.64% |
>> |                                    | process-sockets-141 (seconds)                            |               20.8735 |               (I) -4.27% |
>> |                                    | process-sockets-172 (seconds)                            |    26.205333333333332 |                    0.30% |
>> |                                    | process-sockets-203 (seconds)                            |    31.298000000000002 |                   -1.71% |
>> |                                    | process-sockets-234 (seconds)                            |    36.104000000000006 |                   -1.94% |
>> |                                    | process-sockets-256 (seconds)                            |     39.44016666666667 |                   -0.71% |
>> |                                    | thread-pipes-1 (seconds)                                 |   0.17550000000000002 |                    0.66% |
>> |                                    | thread-pipes-4 (seconds)                                 |   0.44716666666666666 |                    1.66% |
>> |                                    | thread-pipes-7 (seconds)                                 |                0.7345 |                   -0.17% |
>> |                                    | thread-pipes-12 (seconds)                                |     1.405833333333333 |               (I) -4.12% |
>> |                                    | thread-pipes-21 (seconds)                                |    2.0113333333333334 |               (I) -2.13% |
>> |                                    | thread-pipes-30 (seconds)                                |    2.6648333333333336 |               (I) -3.78% |
>> |                                    | thread-pipes-48 (seconds)                                |    3.6341666666666668 |               (I) -5.77% |
>> |                                    | thread-pipes-79 (seconds)                                |                4.4085 |               (I) -5.31% |
>> |                                    | thread-pipes-110 (seconds)                               |     5.374666666666666 |               (I) -6.12% |
>> |                                    | thread-pipes-141 (seconds)                               |     6.385666666666666 |               (I) -4.00% |
>> |                                    | thread-pipes-172 (seconds)                               |     7.403000000000001 |               (I) -3.01% |
>> |                                    | thread-pipes-203 (seconds)                               |     8.570333333333332 |               (I) -2.62% |
>> |                                    | thread-pipes-234 (seconds)                               |     9.719166666666666 |               (I) -2.00% |
>> |                                    | thread-pipes-256 (seconds)                               |    10.552833333333334 |               (I) -2.30% |
>> |                                    | thread-sockets-1 (seconds)                               |                0.3065 |                (R) 2.39% |
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
>>
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
>> | mmtests/sysbench-mutex             | sysbenchmutex-1 (usec)                                   |    194.38333333333333 |                   -0.02% |
>> |                                    | sysbenchmutex-4 (usec)                                   |               200.875 |                   -0.02% |
>> |                                    | sysbenchmutex-7 (usec)                                   |    201.23000000000002 |                    0.00% |
>> |                                    | sysbenchmutex-12 (usec)                                  |    201.77666666666664 |                    0.12% |
>> |                                    | sysbenchmutex-21 (usec)                                  |                203.03 |                   -0.40% |
>> |                                    | sysbenchmutex-30 (usec)                                  |               203.285 |                    0.08% |
>> |                                    | sysbenchmutex-48 (usec)                                  |    231.30000000000004 |                    2.59% |
>> |                                    | sysbenchmutex-79 (usec)                                  |               362.075 |                   -0.80% |
>> |                                    | sysbenchmutex-110 (usec)                                 |     516.8233333333334 |                   -3.87% |
>> |                                    | sysbenchmutex-128 (usec)                                 |     593.3533333333334 |               (I) -4.46% |
>> +------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
> This is nice, but is clearly hugely exceeding the column width we should have in commit messages.
>
> Let me use emacs's nice features to make life easy for you :) -

Oh you did it for me, thank you so much!

>
> +-------------------------+--------------------------------+---------------+
> | mmtests/hackbench       | process-pipes-1 (seconds)      |        -0.06% |
> |                         | process-pipes-4 (seconds)      |        -0.27% |
> |                         | process-pipes-7 (seconds)      |   (I) -12.13% |
> |                         | process-pipes-12 (seconds)     |    (I) -5.32% |
> |                         | process-pipes-21 (seconds)     |    (I) -2.87% |
> |                         | process-pipes-30 (seconds)     |    (I) -3.39% |
> |                         | process-pipes-48 (seconds)     |    (I) -5.65% |
> |                         | process-pipes-79 (seconds)     |    (I) -6.74% |
> |                         | process-pipes-110 (seconds)    |    (I) -6.26% |
> |                         | process-pipes-141 (seconds)    |    (I) -4.99% |
> |                         | process-pipes-172 (seconds)    |    (I) -4.45% |
> |                         | process-pipes-203 (seconds)    |    (I) -3.65% |
> |                         | process-pipes-234 (seconds)    |    (I) -3.45% |
> |                         | process-pipes-256 (seconds)    |    (I) -3.47% |
> |                         | process-sockets-1 (seconds)    |         2.13% |
> |                         | process-sockets-4 (seconds)    |         1.02% |
> |                         | process-sockets-7 (seconds)    |        -0.26% |
> |                         | process-sockets-12 (seconds)   |        -1.24% |
> |                         | process-sockets-21 (seconds)   |         0.01% |
> |                         | process-sockets-30 (seconds)   |        -0.15% |
> |                         | process-sockets-48 (seconds)   |         0.15% |
> |                         | process-sockets-79 (seconds)   |         1.45% |
> |                         | process-sockets-110 (seconds)  |        -1.64% |
> |                         | process-sockets-141 (seconds)  |    (I) -4.27% |
> |                         | process-sockets-172 (seconds)  |         0.30% |
> |                         | process-sockets-203 (seconds)  |        -1.71% |
> |                         | process-sockets-234 (seconds)  |        -1.94% |
> |                         | process-sockets-256 (seconds)  |        -0.71% |
> |                         | thread-pipes-1 (seconds)       |         0.66% |
> |                         | thread-pipes-4 (seconds)       |         1.66% |
> |                         | thread-pipes-7 (seconds)       |        -0.17% |
> |                         | thread-pipes-12 (seconds)      |    (I) -4.12% |
> |                         | thread-pipes-21 (seconds)      |    (I) -2.13% |
> |                         | thread-pipes-30 (seconds)      |    (I) -3.78% |
> |                         | thread-pipes-48 (seconds)      |    (I) -5.77% |
> |                         | thread-pipes-79 (seconds)      |    (I) -5.31% |
> |                         | thread-pipes-110 (seconds)     |    (I) -6.12% |
> |                         | thread-pipes-141 (seconds)     |    (I) -4.00% |
> |                         | thread-pipes-172 (seconds)     |    (I) -3.01% |
> |                         | thread-pipes-203 (seconds)     |    (I) -2.62% |
> |                         | thread-pipes-234 (seconds)     |    (I) -2.00% |
> |                         | thread-pipes-256 (seconds)     |    (I) -2.30% |
> |                         | thread-sockets-1 (seconds)     |     (R) 2.39% |
> +-------------------------+--------------------------------+---------------+
>
> +-------------------------+------------------------------------------------+
> | mmtests/sysbench-mutex  | sysbenchmutex-1 (usec)         |        -0.02% |
> |                         | sysbenchmutex-4 (usec)         |        -0.02% |
> |                         | sysbenchmutex-7 (usec)         |         0.00% |
> |                         | sysbenchmutex-12 (usec)        |         0.12% |
> |                         | sysbenchmutex-21 (usec)        |        -0.40% |
> |                         | sysbenchmutex-30 (usec)        |         0.08% |
> |                         | sysbenchmutex-48 (usec)        |         2.59% |
> |                         | sysbenchmutex-79 (usec)        |        -0.80% |
> |                         | sysbenchmutex-110 (usec)       |        -3.87% |
> |                         | sysbenchmutex-128 (usec)       |    (I) -4.46% |
> +-------------------------+--------------------------------+---------------+
>
>
>>   mm/khugepaged.c | 9 ++-------
>>   1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4ec324a4c1fe..a0f1df2a7ae6 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>   			writable = true;
>>   	}
>>
>> -	if (unlikely(!writable)) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
>> +	if (unlikely(cc->is_khugepaged && !referenced)) {
>>   		result = SCAN_LACK_REFERENCED_PAGE;
>>   	} else {
>>   		result = SCAN_SUCCEED;
>> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>   		     mmu_notifier_test_young(vma->vm_mm, _address)))
>>   			referenced++;
>>   	}
>> -	if (!writable) {
>> -		result = SCAN_PAGE_RO;
>> -	} else if (cc->is_khugepaged &&
>> +	if (cc->is_khugepaged &&
>>   		   (!referenced ||
>>   		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
>>   		result = SCAN_LACK_REFERENCED_PAGE;
>> @@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>   		case SCAN_PMD_NULL:
>>   		case SCAN_PTE_NON_PRESENT:
>>   		case SCAN_PTE_UFFD_WP:
>> -		case SCAN_PAGE_RO:
>>   		case SCAN_LACK_REFERENCED_PAGE:
>>   		case SCAN_PAGE_NULL:
>>   		case SCAN_PAGE_COUNT:
>> --
>> 2.30.2
>>
> I guess you delay the final cleanup so you can combine it with tracepoint
> removal in next patch, not really sure why they're separate but meh not a
> big deal.
--------------auC0hCJI3d00D4noU0ENBizz
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html><html><head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 04/09/25 2:04 am, Lorenzo Stoakes
      wrote:<br>
    </div>
    <blockquote type="cite" cite="mid:9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local">
      <pre wrap="" class="moz-quote-pre">On Wed, Sep 03, 2025 at 11:16:34AM +0530, Dev Jain wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Currently khugepaged does not collapse a region which does not have a
single writable page. This is wasteful since non-writable VMAs mapped by
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
As discussed elsewhere in the thread, you really need to clarify that you
mean the PTE is writable. This is far too vague otherwise.</pre>
    </blockquote>
    <br>
    <pre wrap="" class="moz-quote-pre">Okay.

</pre>
    <blockquote type="cite" cite="mid:9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">the application won't benefit from THP collapse. Therefore, remove this
restriction and allow khugepaged to collapse a VMA with arbitrary
protections.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
It's weird thie history of this, it looks like we were super conservative
at first, and then introduced this 'at least one PTE writable' thing in
commit 10359213d05a (&quot;mm: incorporate read-only pages into transparent huge
pages&quot;), but it doesn't really explain why you even need (at least) a
writable page.

Perhaps a pre-PAE thing... (David?) we already do the refcount stuff
though, so it's hard to understand.

It seems the main case for anon where it'd matter is swapped in pages
read-faulting for a R/W mapping (as read-faulting R/W mappings would just
get you the zero page which vm_normal_page() would exclude anyway).

But not sure why we'd be reticent to collapse those anyway... you'd just
cahnge R/W bit on PMD instead of PTE?

Yeah it's bizarre.

I can't really see why your change shouldn't be done...


</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
Along with this, currently MADV_COLLAPSE does not perform a collapse on a
non-writable VMA, and this restriction is nowhere to be found on the
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">manpage - the restriction itself sounds wrong to me since the user knows
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
I'm not sure why a man page would talk about PTE scanning implementation
details?</pre>
    </blockquote>
    <p><br>
    </p>
    <pre wrap="" class="moz-quote-pre">Sure, the manpage shouldn't talk about that, but the consequence of this
PTE scanning implementation is that a read-only VMA won't be collapsed,
so the manpage should have at least talked about mapping protections.
<span style="white-space: pre-wrap">So a user doing a </span>PROT_READ mapping and then doing madvise(MADV_COLLAPSE)
will receive -EINVAL which is extremely bizarre.

</pre>
    <blockquote type="cite" cite="mid:9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local">
      <pre wrap="" class="moz-quote-pre">

But I guess as you say you're thinking specifically of a read-only VMA that
naturally has read-only PTE's as as result...

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">the protection of the memory it has mapped, so collapsing read-only
memory via madvise() should be a choice of the user which shouldn't
be overriden by the kernel.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
NIT: overriden -&gt; overridden.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
On an arm64 machine, an average of 5% improvement is seen on some mmtests
benchmarks, particularly hackbench, with a maximum improvement of 12%.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Nice!

Is this on a raw metal machine, or a VM? I thik it's important to clarify
details like this.

Please state precisely what you tested this on.</pre>
    </blockquote>
    <br>
    <pre wrap="" class="moz-quote-pre">I am guessing these benchmarks run in a container but I'll clarify this.

</pre>
    <blockquote type="cite" cite="mid:9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
Signed-off-by: Dev Jain <a class="moz-txt-link-rfc2396E" href="mailto:dev.jain@arm.com">&lt;dev.jain@arm.com&gt;</a>
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Can't find any problem with this, and doesn't really seem like it'd be
problematic so:

Reviewed-by: Lorenzo Stoakes <a class="moz-txt-link-rfc2396E" href="mailto:lorenzo.stoakes@oracle.com">&lt;lorenzo.stoakes@oracle.com&gt;</a></pre>
    </blockquote>
    <br>
    <pre wrap="" class="moz-quote-pre">Thanks.

</pre>
    <blockquote type="cite" cite="mid:9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">---
RFC-&gt;v1:
Drop writable references from tracepoints

RFC:
<a class="moz-txt-link-freetext" href="https://lore.kernel.org/all/20250901074817.73012-1-dev.jain@arm.com/">https://lore.kernel.org/all/20250901074817.73012-1-dev.jain@arm.com/</a>

I can see performance improvements on mmtests run on an arm64 machine
comparing with 6.17-rc2. (I) denotes statistically significant improvement,
(R) denotes statistically significant regression (Please ignore the
numbers in the middle column):
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Let's drop the numbers in the middle column then please, this is going into the
commit log, let's not put extranous information there.</pre>
    </blockquote>
    <br>
    <pre wrap="" class="moz-quote-pre">I'll go study some Unix commands to drop that middle column :)

</pre>
    <blockquote type="cite" cite="mid:9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
+------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
| mmtests/hackbench                  | process-pipes-1 (seconds)                                |                 0.145 |                   -0.06% |
|                                    | process-pipes-4 (seconds)                                |                0.4335 |                   -0.27% |
|                                    | process-pipes-7 (seconds)                                |                 0.823 |              (I) -12.13% |
|                                    | process-pipes-12 (seconds)                               |    1.3538333333333334 |               (I) -5.32% |
|                                    | process-pipes-21 (seconds)                               |    1.8971666666666664 |               (I) -2.87% |
|                                    | process-pipes-30 (seconds)                               |    2.5023333333333335 |               (I) -3.39% |
|                                    | process-pipes-48 (seconds)                               |                3.4305 |               (I) -5.65% |
|                                    | process-pipes-79 (seconds)                               |     4.245833333333334 |               (I) -6.74% |
|                                    | process-pipes-110 (seconds)                              |     5.114833333333333 |               (I) -6.26% |
|                                    | process-pipes-141 (seconds)                              |                6.1885 |               (I) -4.99% |
|                                    | process-pipes-172 (seconds)                              |     7.231833333333334 |               (I) -4.45% |
|                                    | process-pipes-203 (seconds)                              |     8.393166666666668 |               (I) -3.65% |
|                                    | process-pipes-234 (seconds)                              |     9.487499999999999 |               (I) -3.45% |
|                                    | process-pipes-256 (seconds)                              |    10.316166666666666 |               (I) -3.47% |
|                                    | process-sockets-1 (seconds)                              |                 0.289 |                    2.13% |
|                                    | process-sockets-4 (seconds)                              |    0.7596666666666666 |                    1.02% |
|                                    | process-sockets-7 (seconds)                              |    1.1663333333333334 |                   -0.26% |
|                                    | process-sockets-12 (seconds)                             |    1.8641666666666665 |                   -1.24% |
|                                    | process-sockets-21 (seconds)                             |    3.0773333333333333 |                    0.01% |
|                                    | process-sockets-30 (seconds)                             |                4.2405 |                   -0.15% |
|                                    | process-sockets-48 (seconds)                             |     6.459666666666666 |                    0.15% |
|                                    | process-sockets-79 (seconds)                             |    10.156833333333333 |                    1.45% |
|                                    | process-sockets-110 (seconds)                            |    14.317833333333333 |                   -1.64% |
|                                    | process-sockets-141 (seconds)                            |               20.8735 |               (I) -4.27% |
|                                    | process-sockets-172 (seconds)                            |    26.205333333333332 |                    0.30% |
|                                    | process-sockets-203 (seconds)                            |    31.298000000000002 |                   -1.71% |
|                                    | process-sockets-234 (seconds)                            |    36.104000000000006 |                   -1.94% |
|                                    | process-sockets-256 (seconds)                            |     39.44016666666667 |                   -0.71% |
|                                    | thread-pipes-1 (seconds)                                 |   0.17550000000000002 |                    0.66% |
|                                    | thread-pipes-4 (seconds)                                 |   0.44716666666666666 |                    1.66% |
|                                    | thread-pipes-7 (seconds)                                 |                0.7345 |                   -0.17% |
|                                    | thread-pipes-12 (seconds)                                |     1.405833333333333 |               (I) -4.12% |
|                                    | thread-pipes-21 (seconds)                                |    2.0113333333333334 |               (I) -2.13% |
|                                    | thread-pipes-30 (seconds)                                |    2.6648333333333336 |               (I) -3.78% |
|                                    | thread-pipes-48 (seconds)                                |    3.6341666666666668 |               (I) -5.77% |
|                                    | thread-pipes-79 (seconds)                                |                4.4085 |               (I) -5.31% |
|                                    | thread-pipes-110 (seconds)                               |     5.374666666666666 |               (I) -6.12% |
|                                    | thread-pipes-141 (seconds)                               |     6.385666666666666 |               (I) -4.00% |
|                                    | thread-pipes-172 (seconds)                               |     7.403000000000001 |               (I) -3.01% |
|                                    | thread-pipes-203 (seconds)                               |     8.570333333333332 |               (I) -2.62% |
|                                    | thread-pipes-234 (seconds)                               |     9.719166666666666 |               (I) -2.00% |
|                                    | thread-pipes-256 (seconds)                               |    10.552833333333334 |               (I) -2.30% |
|                                    | thread-sockets-1 (seconds)                               |                0.3065 |                (R) 2.39% |
+------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+

+------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
| mmtests/sysbench-mutex             | sysbenchmutex-1 (usec)                                   |    194.38333333333333 |                   -0.02% |
|                                    | sysbenchmutex-4 (usec)                                   |               200.875 |                   -0.02% |
|                                    | sysbenchmutex-7 (usec)                                   |    201.23000000000002 |                    0.00% |
|                                    | sysbenchmutex-12 (usec)                                  |    201.77666666666664 |                    0.12% |
|                                    | sysbenchmutex-21 (usec)                                  |                203.03 |                   -0.40% |
|                                    | sysbenchmutex-30 (usec)                                  |               203.285 |                    0.08% |
|                                    | sysbenchmutex-48 (usec)                                  |    231.30000000000004 |                    2.59% |
|                                    | sysbenchmutex-79 (usec)                                  |               362.075 |                   -0.80% |
|                                    | sysbenchmutex-110 (usec)                                 |     516.8233333333334 |                   -3.87% |
|                                    | sysbenchmutex-128 (usec)                                 |     593.3533333333334 |               (I) -4.46% |
+------------------------------------+----------------------------------------------------------+-----------------------+--------------------------+
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
This is nice, but is clearly hugely exceeding the column width we should have in commit messages.

Let me use emacs's nice features to make life easy for you :) -</pre>
    </blockquote>
    <br>
    <pre wrap="" class="moz-quote-pre">Oh you did it for me, thank you so much!

</pre>
    <blockquote type="cite" cite="mid:9536873f-08ea-4a60-bbec-3e7a832dc0e1@lucifer.local">
      <pre wrap="" class="moz-quote-pre">

+-------------------------+--------------------------------+---------------+
| mmtests/hackbench       | process-pipes-1 (seconds)      |        -0.06% |
|                         | process-pipes-4 (seconds)      |        -0.27% |
|                         | process-pipes-7 (seconds)      |   (I) -12.13% |
|                         | process-pipes-12 (seconds)     |    (I) -5.32% |
|                         | process-pipes-21 (seconds)     |    (I) -2.87% |
|                         | process-pipes-30 (seconds)     |    (I) -3.39% |
|                         | process-pipes-48 (seconds)     |    (I) -5.65% |
|                         | process-pipes-79 (seconds)     |    (I) -6.74% |
|                         | process-pipes-110 (seconds)    |    (I) -6.26% |
|                         | process-pipes-141 (seconds)    |    (I) -4.99% |
|                         | process-pipes-172 (seconds)    |    (I) -4.45% |
|                         | process-pipes-203 (seconds)    |    (I) -3.65% |
|                         | process-pipes-234 (seconds)    |    (I) -3.45% |
|                         | process-pipes-256 (seconds)    |    (I) -3.47% |
|                         | process-sockets-1 (seconds)    |         2.13% |
|                         | process-sockets-4 (seconds)    |         1.02% |
|                         | process-sockets-7 (seconds)    |        -0.26% |
|                         | process-sockets-12 (seconds)   |        -1.24% |
|                         | process-sockets-21 (seconds)   |         0.01% |
|                         | process-sockets-30 (seconds)   |        -0.15% |
|                         | process-sockets-48 (seconds)   |         0.15% |
|                         | process-sockets-79 (seconds)   |         1.45% |
|                         | process-sockets-110 (seconds)  |        -1.64% |
|                         | process-sockets-141 (seconds)  |    (I) -4.27% |
|                         | process-sockets-172 (seconds)  |         0.30% |
|                         | process-sockets-203 (seconds)  |        -1.71% |
|                         | process-sockets-234 (seconds)  |        -1.94% |
|                         | process-sockets-256 (seconds)  |        -0.71% |
|                         | thread-pipes-1 (seconds)       |         0.66% |
|                         | thread-pipes-4 (seconds)       |         1.66% |
|                         | thread-pipes-7 (seconds)       |        -0.17% |
|                         | thread-pipes-12 (seconds)      |    (I) -4.12% |
|                         | thread-pipes-21 (seconds)      |    (I) -2.13% |
|                         | thread-pipes-30 (seconds)      |    (I) -3.78% |
|                         | thread-pipes-48 (seconds)      |    (I) -5.77% |
|                         | thread-pipes-79 (seconds)      |    (I) -5.31% |
|                         | thread-pipes-110 (seconds)     |    (I) -6.12% |
|                         | thread-pipes-141 (seconds)     |    (I) -4.00% |
|                         | thread-pipes-172 (seconds)     |    (I) -3.01% |
|                         | thread-pipes-203 (seconds)     |    (I) -2.62% |
|                         | thread-pipes-234 (seconds)     |    (I) -2.00% |
|                         | thread-pipes-256 (seconds)     |    (I) -2.30% |
|                         | thread-sockets-1 (seconds)     |     (R) 2.39% |
+-------------------------+--------------------------------+---------------+

+-------------------------+------------------------------------------------+
| mmtests/sysbench-mutex  | sysbenchmutex-1 (usec)         |        -0.02% |
|                         | sysbenchmutex-4 (usec)         |        -0.02% |
|                         | sysbenchmutex-7 (usec)         |         0.00% |
|                         | sysbenchmutex-12 (usec)        |         0.12% |
|                         | sysbenchmutex-21 (usec)        |        -0.40% |
|                         | sysbenchmutex-30 (usec)        |         0.08% |
|                         | sysbenchmutex-48 (usec)        |         2.59% |
|                         | sysbenchmutex-79 (usec)        |        -0.80% |
|                         | sysbenchmutex-110 (usec)       |        -3.87% |
|                         | sysbenchmutex-128 (usec)       |    (I) -4.46% |
+-------------------------+--------------------------------+---------------+


</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
 mm/khugepaged.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4ec324a4c1fe..a0f1df2a7ae6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			writable = true;
 	}

-	if (unlikely(!writable)) {
-		result = SCAN_PAGE_RO;
-	} else if (unlikely(cc-&gt;is_khugepaged &amp;&amp; !referenced)) {
+	if (unlikely(cc-&gt;is_khugepaged &amp;&amp; !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 		     mmu_notifier_test_young(vma-&gt;vm_mm, _address)))
 			referenced++;
 	}
-	if (!writable) {
-		result = SCAN_PAGE_RO;
-	} else if (cc-&gt;is_khugepaged &amp;&amp;
+	if (cc-&gt;is_khugepaged &amp;&amp;
 		   (!referenced ||
 		    (unmapped &amp;&amp; referenced &lt; HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
@@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		case SCAN_PMD_NULL:
 		case SCAN_PTE_NON_PRESENT:
 		case SCAN_PTE_UFFD_WP:
-		case SCAN_PAGE_RO:
 		case SCAN_LACK_REFERENCED_PAGE:
 		case SCAN_PAGE_NULL:
 		case SCAN_PAGE_COUNT:
--
2.30.2

</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
I guess you delay the final cleanup so you can combine it with tracepoint
removal in next patch, not really sure why they're separate but meh not a
big deal.
</pre>
    </blockquote>
  </body>
</html>

--------------auC0hCJI3d00D4noU0ENBizz--


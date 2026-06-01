Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CE79CD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 00:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BD96B0192; Sun, 31 May 2026 20:09:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80C6E6B0193; Sun, 31 May 2026 20:09:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D1A06B0194; Sun, 31 May 2026 20:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBBD6B0192
	for <linux-mm@kvack.org>; Sun, 31 May 2026 20:09:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E52851C1A6B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:09:36 +0000 (UTC)
X-FDA: 84829409952.04.C8F7910
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013001.outbound.protection.outlook.com [40.93.201.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 291DEA0005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 00:09:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dpezZFJB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780272574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXvOXmoH94ctsAUAlNs2XBlcPKY38xDWXQCOSo8ZGh8=;
	b=16kzjzZyf9lP+wa5vO/eTai6S7aK8ROwXdlEpuzRiqHhOU1z/LusyqclT5D01es3i0Q53S
	MIhT21Fs8iNkGPljwWtpD4xOYrn1N0VyhmfcDMxiZdd8CMgMx6m3oA8bu8H33E4xzc1mNg
	FxXGua+z4d4Bmi5LM1NVyTCku9BOJ8M=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dpezZFJB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780272574; a=rsa-sha256;
	cv=pass;
	b=xfEfij91XT3bwSDXX8BRgysnqFrQfiqYpEcLd19BgcVwF7ieevTInCF8j6FY8SrL6f8wBR
	DLhFPpule2zX/ff+O7aJYl1nB5lkdGLf+tApnXrauBq07KORNyQbosU8nz4qbZ9q9C4UvW
	oQ/HME4atfcYDMyxeeXBCyCg7CsJfNk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RZrMn4yEOaHKgupsHQ0+GaJlra7CR+EvHs7tOy9QgVqRlwDqVG86blQgc587byepCjeo9yPG/zLRO+j9vbb520GQuAw1uLuM2wH3qEOFV19HAYNY0V4YOZObvVhSTvRH7jXuvscSNTVzu9mQIaVD6AiBntlgzZY/dJ8vmrOyVlkI8N8xvr0tD83rFL0/6+Nu9dbAB/H3Ah9nGVlPJ5BzFoatu4cAto/ql9keM/5VnJQhEzq2sL1SCJfYFEv/VYx1snvkN0qZyoEAqmF4rnXq1UpSN0/R2eM/YLx+piCEbzw411nDQHXr+/HQYlMY+89prefizrQ2Ew1YnAWLBtjfHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXvOXmoH94ctsAUAlNs2XBlcPKY38xDWXQCOSo8ZGh8=;
 b=w8EO1XyQRm3fM3VJzKzpgb2XNX+K8mgoDxxyecA2EP912cMb/opq6QZu2ZdOrLs2XYfMIuJWKC4aGns0myqbjmBEXgsLt8pkOYX1qmUvHAqESH9l3modxGVV4vQSOY8FTbLzesn12rjLkRCNg3P/Mszjhi1BH4PtRt3gREb4agp7VC9TC5O90jk5GNd9YEekV15J10llvZWqWYwf6aiiFl1Ax/7eiFJBxFa/KuofUJJQ6kWvtrX15nKhD1bSzRp/vfYMt8w5srNV1mtgmF+A/w1vUrx5k4Om0ufH47iuBlJ9fuuBjLGuR2cXxLoVftoN2GgrU6MRkg84+BW0IrCuhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXvOXmoH94ctsAUAlNs2XBlcPKY38xDWXQCOSo8ZGh8=;
 b=dpezZFJBMmiLxR06WrCsKPqv4VE7nik9NJLKHJxnQ6TY8vUJ3sCixVdYu4hz4hYdM1+9AvvbhMfTNkkeo2fmvMK0L/844w930mWSj7zM18VFbRjS6ylhdTyTvuUqOvpPCwHX/2i05viPyzg0rpiducez1YvAJ/Ke4qeu9H9T+Zw1zros6xWow+ctepaLf/NJnGp37n8nEIZS2FCeuuJEIPRX0UOkXbLPkoPpwMPurhgrWnuXxHLbP5Z+/F6sAyPRyu5suHB0BUx/j0UKCVgo4g/q2KYhwXRFnpL+vX/a1JEXpZ6nHHPGwIfOU0r0DHIHIOhZVxC9gG2D9gFrbJK9YA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS0PR12MB8319.namprd12.prod.outlook.com (2603:10b6:8:f7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 00:09:26 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 00:09:25 +0000
Message-ID: <9d8bffb5-bb07-4cde-8a20-8b9b9996f8cf@nvidia.com>
Date: Mon, 1 Jun 2026 10:09:16 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm/hmm-tests: test pagemap reads of PMD
 device-private entries
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 liam@infradead.org, ljs@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 david@kernel.org, shuah@kernel.org
Cc: vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-kselftest@vger.kernel.org, usama.arif@linux.dev,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260530085413.1270139-1-dev.jain@arm.com>
 <20260530085413.1270139-3-dev.jain@arm.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260530085413.1270139-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME0P300CA0072.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:220:20e::7) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS0PR12MB8319:EE_
X-MS-Office365-Filtering-Correlation-Id: cbd003fd-abc7-4e77-7982-08debf720a54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|18002099003|3023799007|6133799003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	bNNR4VD1sCGWhFTRm+1WX70ij/1X2Gfpzy6c+ckjWfijLcZ5YRB0ZA2Ul/KSSd99eL8nIqsWVuuth8pfhS0vOr+k79NA7z0TLH/kSL5qxp8xr4CLyoqof9ZT+9papptspaAnkZuzeZOo7d0+c/Zu3usXuqb+o0xWTJXwwtQ9sKdXet1V9gFzuY/WTC7zutlxQrGqLgHx4c9c3lUn/HFVuKNX9EMOCLbJG3RdK8mRXbPsZlEtNUGJSOw6SEA+QWtaIFTeNmVj32coDcCsocdbJAZOEvygJ0mK7yyJjLy/NUKQBbndpAGgzeOQwUt/bR9r0/Y2D08giJop3oXNAO8oDP8AxR8Pw8DiWYnkoNNS+ZOxRi2Xtcb6yDhqnebsA4wQHe8B4BpPvPpKRNCvZysGvQZDE7H+O2IGvqKc8Ql/hTzrceIq0ORtebUI5Za9J72wWF6cGnPKED9/lZMKtGcZLezpjX1xyH/IklguZVfjRFfhn8wkLU5tl1BA64Zq5xQ890YFw8UH5bNHwKguVDrCvNB7uo7HpAZ0hYFI5po1/N4v2P20MfLNP/pSHTcPyVMNhnhkfhym29RELxPwKfwFJcBtuwKC5zFoUC853P/QgrBjW6gfqZCvHYepiYCYiJ4R0TwDtiSUka0xGvPGT24nonhTVxGiG3ilGDSGHZXNV6+rO9+l8631p2tiDbdEkmIk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(18002099003)(3023799007)(6133799003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czg4S2VxVDJpYkEzUVZQMEpIUDQvRzdEQjcvN25FM0FKK1lMbVZhMWlZRDBh?=
 =?utf-8?B?MTZCL29QbVlnK3dpVzdvMStKdHl4NCtRSkRtSWJKS2lFczZ5UUlMRU42VVVi?=
 =?utf-8?B?c0NOQnZUbGs4VHQza3ZueGNOZnJSc2dpbXpjOStEemRpYk9PYUZIcC82enpk?=
 =?utf-8?B?QlZOb1FYOUJxcm5qd1cvSlQ4QUxIcXJwaWxVak4rTis1cFJndUZaYXE3SGJ1?=
 =?utf-8?B?WW51TFI4b21GTGtHWFBaUm11ME5MeU0zRDR6RjRNRWFycXp5enVUNk1TOTJR?=
 =?utf-8?B?R0RiK0U1S3F5aDFOanhpK3Y1czB1cml6c2FQYU04QW43a0ZaWFV3eEVncTdx?=
 =?utf-8?B?cGVBaUVxZ1BlQjBvREtGMlFEbU9yNklrNFRlbTZXdkRyeWJvTFhHaENWUVBl?=
 =?utf-8?B?VkdCcHJxL2l3WWptQWJMTnJVaXN3QkdGM09MTm1uZmZDRkNwT3V5YXk3V2Jy?=
 =?utf-8?B?dXRQOHBvdjBXQ3ZsSVBKdzFxRlR5RTdDNnN4bHE5ajVqaFhwYUF4cVl0Mm9M?=
 =?utf-8?B?SWw5aGZLUXlsN2lNbjlERGJPTVY1YWJjMVJuYmtNWlJ6REpENzE2dTNuMEht?=
 =?utf-8?B?azcvTWw4SnFSTExCWUw1Wk9GSjZweUY3d2xsbm1XNWw3UzFyQy82VHQ5MDlM?=
 =?utf-8?B?MjIwNExpd1l5dzNiOHhaUWRXcmpIbzNkWElQRzliblBRWFFTeW1rMDlaNG0w?=
 =?utf-8?B?OEUrSmlwL2pUSXdPR2dvYUxCZUk1SHkrSkdNeTJmY2MxaVVmN3hQMXR1dlE3?=
 =?utf-8?B?T0tnU0FEaVByRC92NHMzMHhva0VWWjlvNVVXaUtTZ0pydDV3Tm9JY25Lcm4w?=
 =?utf-8?B?bXRtNFN1Ly9WK3Q1Vlh5bXBFM0c5RmFMRUVFRkIycktPeDRDWVF4WVF1YmF2?=
 =?utf-8?B?V21KcE9kcTlxdjZUVVU3UGpCL2JFSDVpMytNNHU2cmhSZEwzVVpjb1ZaMW5V?=
 =?utf-8?B?ZFBJYWNKWlllYU5EcWpTM1dBek04bEIwZ21xbXkxWFZQRmF5WjdXNjZhdHg1?=
 =?utf-8?B?RDdNSGlzOE5BZmhGcjVLSUdFMmxJMnVlVUJ1WUwrS3grL3lKSDhHSSs3SzNw?=
 =?utf-8?B?N2gwVWc4b1M2VWx0OEFMaEhGRDBRRUI5TmZVek91bHZtV0g2ME1BQVZ2R3ds?=
 =?utf-8?B?bkJCRGRiWkxPYWVzR0gyRmNBazh2aElIRnNNaXFRYW9NWjgrem1UMHpISmZL?=
 =?utf-8?B?aFFvVDJhVUJuclB5TUtHcGdKSkNCeHBBT0hNbG9QNWRkaXA5eEpzZ2hoSzNU?=
 =?utf-8?B?S1ArRW9ETmhzY3dKZ1VJS2NRdWFVMDZoelhyQUxsM2hRR2xFUEJ5aHZFWXI3?=
 =?utf-8?B?Qlkwd2MrdVUwaHVPWldOR1V3ZzBYRTlJVEpOVy9sZXBNeGNVam9jLy81SkZm?=
 =?utf-8?B?ZzBRdWsyM3Q2WU43ZVlSV1pzUHlNbVVSM2IyMGxEZDJEeXFhS3hXUXVXK1VU?=
 =?utf-8?B?VUhxNlJ5T3RqbzN3dWlLUWpRT2t1Rml1L0dvYm41d0I4UFRxK056ejJxN2Er?=
 =?utf-8?B?VEtyaVo5WGY5U09Ua0FxQ1JvZTA4U052QWM0cUlEbTRtRlROcEhkdDRUUWN2?=
 =?utf-8?B?Nkxtd004YzlYdkJSdFZJc0FrVkIvaExMdVJhbVN5V2p3bDJZN1EyUzhlRU0z?=
 =?utf-8?B?UG5JQWhYcHJnWERHbFEzUStBY2w1dWpidWFnTVAzSTgxSTJIdWpkZGc2dDc3?=
 =?utf-8?B?VXI5WXY2aVFqODBEN00zQjZudTB6bWl0NnIrVkdMbk5KellWZ0Y1ckoxUDZJ?=
 =?utf-8?B?SUJ4TDZLUjRwelJURTdOam1qQWFzUHE4bmp3NzRWRlF4SW13QlNyU3o5cVBq?=
 =?utf-8?B?N05UZ3FVRDVDYmNNTnIrZ0xCZTk5Rk12dGF1QzhPczl1REZOQ1ZtYkhvSml0?=
 =?utf-8?B?MzRyOVY3MzdLOGJ0bkdqbzBOR2M2WDJyUG5US2N6S3NlMk41U3A5dUJ1Nktm?=
 =?utf-8?B?a0ZrZExuclRKTkNpRDZJWFBGOFFQUEpZdGwvWkF0SC9Xc2UrUTJxbStkYUU5?=
 =?utf-8?B?WFVDQUp6QmFXelBNUGNWMGFTU1RIeDM4RWx2bEY1N21TcjNudmRhQXNWVC9D?=
 =?utf-8?B?Uk1yRXZNbCtQTlBxckxMRVAxUWpBcWNmSHVqVmE3b0hxUzFsMkhvUUhPdm5B?=
 =?utf-8?B?L2toa3g5ZDFuSWcvSnFmSGxoUUlBL0ZTT3lGSzhpc0ZoOXpmRUJNNGY0QkJy?=
 =?utf-8?B?YmRQSzh0eXNDNlhKTk1TdTM2Mlh0NFFOamdQUCswK1JjK3MydlJmZ1hHaGZz?=
 =?utf-8?B?eHZkN2h6ckdHVnB6M3ovWlJ4OUs2NHQ3b1pJblk5cDJXTWxTY2ptSDhJUndx?=
 =?utf-8?Q?odyfQzZIPuiutUwoCu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd003fd-abc7-4e77-7982-08debf720a54
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 00:09:25.5485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nL2AOZumN7Apuavc39rdgXSTtBpH5q7er4mY1WzsvsVbPnGOc3xMF1LY3cDlaUvqDl9ZjuMnm3PgrwYlKJziCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8319
X-Stat-Signature: g474anpa4o5mow6ob17rx7o9mnzubqpi
X-Rspamd-Queue-Id: 291DEA0005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780272573-787888
X-HE-Meta: U2FsdGVkX1+LEFjTRH2F4G17Hxzw16PqBfRdvtLmdSHpZu9/gmEqVzKd7XBy5cqrzWyQWHSoT0aZVjSWwnUW9We/voGdGkUZxg+Y06+HIH4f1cEWwpCUldTCgFJsn5i+B8/nDg9Hf1pDpOKNRzRVH6lKFptNAKypJirnZpAYS86dFDZ530xVI5QPllhqgleR9vuuhwR+D893XI0u8lfo1lTbkriVx+9OxB34A9OIFIbLgu+tSKMW0lrFG05j6zRiaYnlPTmncZmi8wk673n3nvEps8Bu7yVxz5Oz2r5rnGuJig2ljk5FBnp8KKmeoXr04WV7Hh+svg3AUm1TrWLkLtmmYQKVolAdGISXxhrWAbNV+R87AJ/5kqCbUVM8Pqb8clCHedZIYaI94cAt9qQM9ikjuRIOpK9qidlaU079qpSnmbYf3Go+AwvG0dAVXpp0Hp95lBbp4KscCltNLxIBVaikWYUNlnky6cm7uzRo6Aj6c8CJvfMroi7twhWVfLGDjB7FOEZh+6PpbOtqhOGl5zWJaXzfVjVRbPyYsls5H/Kmr3lS8gBp7XE6Rj+UvTeebfBRQZfZNUWlUhCxhefIG+tnz43eAO81ctPN4yh6UwvBZiUq73lzQ9/IrPlyZBFeHnrRZ20Iq/KyRRImtrWRWcih1ZMRRiVx+castsBeXpCFOJQdOqqzvovC7n+K3qVecxWPbeYpsXvuPXfAsm9+jRwolyCbheZt0BUx3BFBJtlwrZPjeMtFjv2BNoRY4jYHXHv2yrhARyaBA47+pHgmnRybToMYBNO9wYQNYle4aC2Ao+isZhY48A8J/HqZ49AGxjR2xGdwuvflTXxRraVxyJV+Sq34pkiiZj05FVoqSh93Bhhn52PjKKUjaPaUTQ2/YZrJxDbsAI+A3VtIF4tNVYC2a1jmGuowsKwceLYr+jQKt1+nHD9DjSfqtZfB1Dlxgpz+ijlOgqA6GL5+w/j
 jeGF+xyX
 FaqIdmq/ZqOjgER3nHH3TaW5UWf9wgL5JHA7R8c8qEEMMj+QC9klRKtCs4fV4lM2uD4yvCJDtXAXve/t3sqgnNEAvM+SE/qVc9KQs8TXYeGbusHU3ZRsW7krtmE9CvfnjM9XjDKJ/O+XRBBK5cMhYoIfoQjE3kUlhd7CyTMz9B+4iuwMMUToBtkAYePZ48FrkKarOEY8cuoDPL8MdGNZchuUb3cqw+aeWxLyPzzc13BRlRxxdsW1LaNMjTl4uSKO3HISnEDZ85+y4ti1QnvBHfUlqgeaRoCatq2vWSS2mrIti/FXsOg/Z4H2H1BMjBgB8wNnhSD3DBUSVoxiaJ80/U7jZ/S61H56KpVMOSwCbgVLifZhZxhlbq6E5XHeEz0GzzvBQnPxt5H8AtsVVbgHTlXuPYzsBg4RY/+Smk9eCzGtLdg906DWWDZE5d2qOdA28PL3Zh3Sqvu7Pa3mJuq9OLxAuupx4gtCO6D5BT+J1Dd8y8qQjH1mvCn5w8omTiwZ5wiKX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/30/26 18:54, Dev Jain wrote:
> To cover pagemap paths scanning PMD entries, add assertions to check
> whether a device-private PMD entry has the correct pagemap information -
> the PM_SWAP bit must be on in the pagemap entry. Before that, we must
> assert through HMM_DMIRROR_SNAPSHOT snapshot that the leaf entry is
> at PMD level and not PTE level.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  tools/testing/selftests/mm/hmm-tests.c | 29 ++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e1c8a679a4cf3..d09d4a9081de1 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -2276,8 +2276,11 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	unsigned long npages;
>  	unsigned long size;
>  	unsigned long i;
> +	unsigned char *m;
> +	uint64_t entry;
>  	void *old_ptr;
>  	void *map;
> +	int pagemap_fd;
>  	int *ptr;
>  	int ret;
>  
> @@ -2318,6 +2321,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);
>  
> +	if (!hmm_is_coherent_type(variant->device_number)) {
> +		ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT,
> +				      buffer, npages);
> +		ASSERT_EQ(ret, 0);
> +		ASSERT_EQ(buffer->cpages, npages);
> +
> +		m = buffer->mirror;
> +		for (i = 0; i < npages; ++i)
> +			ASSERT_EQ(m[i], HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL |
> +					HMM_DMIRROR_PROT_WRITE |
> +					HMM_DMIRROR_PROT_PMD);

madvise(..., MADV_HUGEPAGE) is not sufficient to guarantee that the allocation
was indeed converted to THP. Might be worth using the kpageflags interface (but that
requires elevated privileges) and then KPF_THP? Otherwise the HMM_DMIRROR_PROT_PMD
can be a miss from time to time. One other option is not to assert, but to check
and inform?

> +
> +		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> +		ASSERT_GE(pagemap_fd, 0);
> +
> +		for (i = 0; i < npages; ++i) {
> +			entry = pagemap_get_entry(pagemap_fd,
> +					(char *)buffer->ptr + i * self->page_size);
> +

If this is a THP entry, do we have valid pagemap entries for offset of i * page_size?

> +			ASSERT_NE(entry & PM_SWAP, 0);
> +			ASSERT_EQ(entry & PM_PRESENT, 0);

Nit: You can use PAGEMAP_PRESENT()

> +		}
> +
> +		close(pagemap_fd);
> +	}
> +
>  	/* Fault pages back to system memory and check them. */
>  	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);

Balbir Singh


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2355EF31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1726B0005; Thu,  9 Apr 2026 11:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7628B6B0089; Thu,  9 Apr 2026 11:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62A8E6B008A; Thu,  9 Apr 2026 11:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 515686B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:05:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1541F1A0807
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:05:59 +0000 (UTC)
X-FDA: 84639342438.26.80BF43B
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010035.outbound.protection.outlook.com [52.101.61.35])
	by imf23.hostedemail.com (Postfix) with ESMTP id 24C1F14001B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:05:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mlVzt2f3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775747156; a=rsa-sha256;
	cv=pass;
	b=YMxbpoEeEaRBaoWEIx5MgXumncqUPp4EZdLtbsaLlOXOh2nZp0t+OmNXR38U+fAuLMa/TL
	vVyP+wxi5FwesqPLSRSilTVdzTrY5/VQDIhTNwT+q7E5NLbqkRhG/XvdBu+FaeWa/yM1p2
	Jsi7U5e1LJJiF8jxvAL3BjGuHR77rmA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mlVzt2f3;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.35 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775747156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RU11S8mrWHl5Ty9v0JFiC0oPEUOJ7xWiw9w7uZzsTwI=;
	b=W1I/YMBslopvdZkKsTOBWRCP8r2Q9jQKfBBcRzy7YhrwTsEcjAyKKWFX4HaCHPnX8zTThF
	JvBOJNegVeum0hbvBH8njIBEwIVrTJoX5dzWOpye5BC1yecp6FtUso/VkQXu+Vwl9X7Ceh
	TpH04QeVop9dUSxtIBvbZ4ahDSSNwQY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iS/O5n0IhBs3XPc153sXG7C4+cTM1mq5O2CR11r1OvvaBOQUJ3VlUg9NwngQim5KFAY7D2Uvrgqjc4/8e23Glapak6JkVpNYpl/4HvtAm2zIvJl+MVTnwO5c+3Fnw1XStta8LR/h+Yh8GxpG3gxmnNUnV8v8S+ekMra5Wl6OZVQfCgx7akakHCe+7kW16mY05yXFw96MS46IgLS2wFoTRUdmnlfLRuy6oyv9kxBzGdCHsCzASfnoYBUiVCNytImJuV77YVMnpcZ9+DXZQ6J5IyLjxe1J4G+6bIIbmxXv/PkiEbhU+txZE0j51sZPQ6xZqsSMgJTwsaX3hrHoI1IuUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RU11S8mrWHl5Ty9v0JFiC0oPEUOJ7xWiw9w7uZzsTwI=;
 b=bCKO17rJv3RPbsP3kDy5hGWJhMstsYOH4IgZ0w6dVmqwiSa3tHViNhx8GLvn2IH/2WqVyzDz9nqu0ZFpuEfhc2GmqFwK2CwwLe6MKRAQDDghDyXP1ss5r/Cr8fm3TZFFsfoXzfXD3GBJDPppR+dl9kAjYKgY+LFmDOSJ3DndJhjDidAlzbET27umjBN8J+AUU1TFLIWUhtIFq7VYtXTOUzr1CBWs+FdELqSZcFhBfNbbJ5GqzNyuqtyw3eRtrdzJJSapMNlSwl31AHlwjCbGPsx7ROAyURCvVLz4WLDRt9Bsoxhm/3AQRqC3I92oheX+s9AldBqf5/J1utpWL4V58g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RU11S8mrWHl5Ty9v0JFiC0oPEUOJ7xWiw9w7uZzsTwI=;
 b=mlVzt2f34hQnpkLAeeyhVKYe/texzAHDnCyMfrJRjQxarXfZEkZngRPLoUxd9Gb5a4Zu06cILq86crDi7DaGxtmBa7w3qzUyGJKaMQhK48H8C2Mzft4WTSRcrkXAzpeekmVmlxmSRpR3pF2mLjAisUUDxdjMHbJEcUwNktZxDIN0igXiP3jv/gkPclGmvCzUUlWfjbH5ovYms3NcsXP9WETDzq9mP6UPItxP6mMhyqE97i94hV+12yxr3RcVUzJRhzjjkOjq0aNoQg52DdK5Kn8Hj0JLGO9PCxuBhPOAdcEK7am51srvqm/wetSC1CbFB1kRMYU6YDgRXLXLZjLl/w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ1PR12MB6025.namprd12.prod.outlook.com (2603:10b6:a03:48c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.20; Thu, 9 Apr 2026 15:05:47 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Thu, 9 Apr 2026
 15:05:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
 Sourab Gupta <sougupta@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
Date: Thu, 09 Apr 2026 11:05:43 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D74E0809-E673-4CD0-84DC-46CBDBB06F03@nvidia.com>
In-Reply-To: <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR20CA0061.namprd20.prod.outlook.com
 (2603:10b6:208:235::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ1PR12MB6025:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c7d11c-e224-49be-d631-08de96497a3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Kc2oT8rsaBmLv3gwkwI2tysvJ8wyvo/H1HUnQCiok0uYrnAq4DyvSUjRDTyr2/qokW/cqmPmfd4TScVqt6AASah6XFdzyuRoPaA1G/p2Dj8XczYX1iVZLTPtAK3bclIIL9hdpvhUtihNPAuumhu7Us9ELYRpNotAg3LQC6W3ELB7RaQhe8zwXVQaJy7Jzzd9iDABhnLwEe0+5n+hzwbMr8tySB0poO1mMnwikvZ7N2Hhsv0j7OMXvxYNiHOOAi/Hos+pwU/e072dXK+iA2fGSZLLeDSsrqKGaNaI5hOpkcpA3SEaUR4ZmdG/aUueC/R3gkLJuPn606MNyWoR0Sh/n2jpdT0hNDhcm0rMl+houG7n6TdKEvQDSBJurGpTjpc67hz/GL+T3xgz+yUF4ovq1xk8J5uXo9e4nCKsYcWEpb98NwC94bsLhtRHgG4ZUxHYcp4cKOwrQXjGFEQjwHAMU9fjs3LHSm+Fy3w+WZPXf6QH3QluH99bNizlbBfFO3+fX8NITgs5fWjcoH+wsBjOkccxrJi+gH3rRCRIRl8pRG6ZXmz3yKZx7R6Okt9ydNj4NQCX835UF0ZgFoLUrkLTBlk7OdZJ14aJr9VF7HPSPnnOVgEQlxU7O0Xd1rg77yveBbqy466HLhXIZ4xZq3woj/yG3rE95BRLrg71wgSiqMBfMksZsyuuPZ5F3aGEDPjT6pKK9PaO9MzYbN8VpNZpUJIkQ7Cv5WuuYj2tAEGqrvQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWhwbm1KWmZ6Z2F0eVR5c1ltK3ZQMkxhbXk4eEp2TTZIU0l1SUtuRkFtZEJo?=
 =?utf-8?B?bHFzdG9EM2dFNWJwODByQmlMcW1pRGZJYjJxTlBxN01kdzlialdORGdnZndW?=
 =?utf-8?B?d3g5dDFDVFpuSkZVcWVjazFId0txSWR2WHFuV2NSdWxUTWxSUHpBSlpFS2Y5?=
 =?utf-8?B?ZlVhTmlkVWpXeW5mWmZIdzY0WGVwOXlZYm0rZHV5bHJVM0kyMHdHNUxyUHVD?=
 =?utf-8?B?Zk5UU0x1THEvNkFnOU5PNWQzQnYvcmtnT3Fla1dmU2ZQTVVMY0dBa2I4ekJK?=
 =?utf-8?B?ZzZJMElwUGVnY2hzZDhucWtQZ2xHTnhRQlFLdHBMdkJtUjRkMk1Lc3d0ZGFs?=
 =?utf-8?B?Nks5OTRzNmZpa1A2MmUwWTdYRk9IQ2Q1UEluZHoxUlNtbnIySHA5R0FneXIv?=
 =?utf-8?B?MldFZHo2YkJKTXhaTTBLbVFQYUlhdDVsWFJCNGhvRURUbEV4M1JSQkhaZGgz?=
 =?utf-8?B?WDNFa3lTVmRDc2NBU0VreVAzOUo5MGNPeTZjcFBSdU5pK1pMWVY0K0dBWlk3?=
 =?utf-8?B?bm81L1hOS2xYWHVHUCtIbE9pS0ZlR0tHVFlDQXdiK0c2L3N5QUJGUjVNOW85?=
 =?utf-8?B?MVpya1gvVTNqOFRRQXFjNjhLYm9lQTV2eFdZZUlGNzFhb0tHVWQ4Y0ZpaUpI?=
 =?utf-8?B?TFV5cmU3SHNrS0pmYmFGR1hzbnFRdnVzUWs4OEViNTc5YjhSQlJyMU82ZXJB?=
 =?utf-8?B?eUhkL2NKQnZtNXdkZ0EzN1ptVHlMemI0QjBrOWFkVkhWeXNtekZzVzEyK1dM?=
 =?utf-8?B?N0drbjl3WWgwZVFaY1YvR1MwSWQrcUJvQkczQzdYZjdaUkhjSEYxcWFXbG01?=
 =?utf-8?B?V010OHpIemZoYjAzZnZmWHBOMDk4L0hsUTcrNzE4MVNJUXBoakF4ZitxSWlr?=
 =?utf-8?B?aktCVnFUSEU3ak1VTTRQNnNvRmFEaHQ3VnlXSkp6N0s1TTV1OVQwZmZBNFp0?=
 =?utf-8?B?RmhDNERLVkNLbnRBVk4zRlNHMWtaSGpPVndNNTFNUzUzSjRPSFJwTitVWEpQ?=
 =?utf-8?B?TXdGTVNJWVRVSlZ6R21zR0dnaXVyMTRmUHVVclYrV29NZGV4WE95U2dFVXNt?=
 =?utf-8?B?eWxwY28yOFk4azZONDVJN3AzUmxKNlM5c0UzZ1ZMajAwaXR3VDE1UkNOYW1J?=
 =?utf-8?B?cmx1Z2hEYUFLdnM3d2QzQXpsU3BmUkxpa1EyMTl2aTZYZ045LytQdFdUTGdM?=
 =?utf-8?B?MnlvS0tEaFNVREJaSGhxckhpSU1NOXZRbGNWWEFNN0JOOHBRTCs2dkZzMDBO?=
 =?utf-8?B?ZEZnczY2MnhNb09ENjBuUnJ1MmN1cHViRkNESUs0eEhnUk5kWTBoc1pUS2dO?=
 =?utf-8?B?c3A1Ri81bGdPVCtiMDA3YVgwdUF5dTFkWE8xV2EzczVHZFp3YThzNXkvVkQw?=
 =?utf-8?B?QjI2QUdUc2FUNzdySDRCS3N4dS9vbGdGcUUwRldud2x4RkRsSkxVcGZ1dEFn?=
 =?utf-8?B?NUt0RFp3TytWSndFaC9JRlN3WjlTOU9Hd0M2cWNidWZWYW5HUDNxMGNsSE01?=
 =?utf-8?B?U0NWWi8xQkFMWFNMeDcxN2hLblo1NG0rOFYvZ1prU0dZaFBOUTZ5QmE1U0Fq?=
 =?utf-8?B?UDllSHFFUFdKM2pqU29OL0dWV1h1TlIzQkNGcGZHZVJrYzdpL2ZrdktrSThR?=
 =?utf-8?B?MTgzNXEwTnJTR0pZTUdDbXdXbzhpMCtLQjdiZEdJcDViQkxnOE9ZNFpTV3BR?=
 =?utf-8?B?UlNPVG1qMDA2bUlnRHFheUFqenJMak4yWXRvWm9ZR2FNM2RCTG1BVnBBb1Bu?=
 =?utf-8?B?QXEzbG5QV3BZby93OE8vMzdvWFdlZDZxZEEyWHVYYVJQejVkekJFQmhCeXJz?=
 =?utf-8?B?eHBtVi91cTNvNUg5WFYrYm4vaEp3dHRFQlAwUDNkOGl4Nm9zY0QwQkdyclpG?=
 =?utf-8?B?Y1FFbmlCelg3VElmWkJUWU9wM0ZCUkJZYVR3U3MxQWhENTVtR1hEeENFanQr?=
 =?utf-8?B?WWRFNURCbGo5ZjN0cWpoZ2w4bWtqejhNZklRR3hKckNub3RtSEFWaDJzM1Jr?=
 =?utf-8?B?SnFxclBITjVJZDRzbFlIcnY3Nk84Y2tva3Z1ay9YZDZmVUFqVTZ3dXhNMzJX?=
 =?utf-8?B?cW1uK3N5bmpSd2k0anFIVDg1WUtGc3dkTDRuZ0RCbDMvbDQvMU9YblN2dTJJ?=
 =?utf-8?B?RWlaK0dQSC9FU3N4KzNZOFRwdEpLNERsbjRMY3RkaUUxV3BJb1lRdTZURFVY?=
 =?utf-8?B?aWJVdk5zV0tSbWNxWnk1RlFGc292OXFxWXhXRHA3eE9CdExHNWdqNkNiU05m?=
 =?utf-8?B?WjB6ZVpha2VqRmhPclRuYThFTlpqUWZwTmJPQ0RmVXc4MElZR0YvOEhJZmRl?=
 =?utf-8?Q?/hz1elt17bY5Bq4gtC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c7d11c-e224-49be-d631-08de96497a3f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2026 15:05:46.2500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8h2r4IPUBwkCBFWwU1usWKqyr4GUPuMdgz8sTYO5+9lObAEIPEkOPcCft1p4JFJz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6025
X-Stat-Signature: mxgrwfdnqmsrnzgg8e4fnmwh1dmi8z7f
X-Rspamd-Queue-Id: 24C1F14001B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775747155-823879
X-HE-Meta: U2FsdGVkX19JWgk6Se38J5ADf8dvh2hIpNRS4s1F9SIHWgq4EPPzj5opJRpUWa2+f26gA174yhlSO8luFl/FR9a8QyznKjTvYv/8PrOmKjrSCDxPUaeF0rSTDbbgyxCnkMZ934nKyqmTzkVeKbQJ9E6MibUBPAiyQu/ig0pA4qXkzf/YSK2iS3k7q0UMz8P5/rotjTpaw4mw29rYt8RGNkNJEibmAIt8NtrsNKAcDnb/+qapzlIPrTM7tUqrVwHu9hE8I9FrHS7kJITT5ftEvvQNa8l74nMcW08NvCG0sCKTg6WqbMALkRvkCxXEjUUKtqf+CmucXNAGD0JFjdSr1Dgg/I9LauwUWZjIb5eHC+9oKbNnSlgI9eGdfL8R1TSEMi8zLJgME+b5jqq6BetCrb3neblNTZ7T+juQgUiXfepyDifLxA1GvaeRwE8CYE1q+kDga6wO2UnSi01KOMfAoOTEpnoi2I1W7HaCenKCVypOOATjRUAMMj9mLrKa2qWaczf19oM8ag0Kb3WnbrSrc4u29+J03rdHo/nQDG2mZ8if9kbkQvZl5vdDujHzBipd40VTljv5/ouU7XoX/pFAQ3qunud9YwAgFKJfxwzuM5DFplBnQbHFeCe49Wm38BPdLOyaxgFY2xH2KY+IdPSNCfFM4Gw7Unio7urJv4t099ArQMUAu0GxQmvzuiuXisjoEqLA9uIOsKsDfGwPfYQaHr3YbMKIA3pr40pu05pc5AEAEfqRu53HhhF9OJzlfZkPswB64LIzJu/e9/oKo4OprFGaq/Nm2hlOCiJlgSgCUjJP+JQji14uGciGOkazE21GVmOZrdivEHWSzicQNkU5w95JqoNUL+GAsT2Wp9INK0+XGjYyVBKXTcIeqvmpblt2MDNZxY6kIHhZEdi3xaa3jruFBRctb+1R5Z2eytDPoF1cYRQBfuK1d8CPTc435jkN3XUhoKHE9YFC5886vT1
 kRxjcEur
 POgxC0vfDv0mlyTsZE1CZxD6Edy7UwHUDy45K3u98YRy2DWgdvzf8bkD5XssBrQBCLkceTOUtDkyfczOHZTVxGXeX5YJFkuGJdn1R+kc/qLX6ENobZ+ypPsw/GBKkoeoalf0Xoo98I0PENoSGwrvSBY/xBwfYFRE4bwgHyp3Gl4/FziqGSqXZFQV1Ej/GA7PEQIztRRu+dzyzsdOwED6waao6wUTgfLMK9caUu2jKJOLp/4GomTtfY0bRjes0x7H7CCe4BFRsgrzYMDgkZy9qZFcO4K4+ArXwsN80ChZ8V4jGJH5QBh0Ns7Mv0dTLRyIIKu+tZsXMl8hOyGrX49VYrVNyl/Bh3KA5VOt2JwYKpguUm+kyy4WhUP7wL1G+us3bO5p/WJ96r9NGd6VR54aaoD2zNVkjPRAANbHzY6p6rUbbAHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Apr 2026, at 3:52, David Hildenbrand (Arm) wrote:

> On 4/9/26 03:46, John Hubbard wrote:
>> Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
>> folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
>> gup_fast_folio_allowed() falls back to the slow path for any order-0
>> folio with a NULL mapping when CONFIG_SECRETMEM=3Dy. This causes a
>> performance regression for drivers that allocate pages with alloc_page()
>> and insert them into VMAs via vm_insert_page(). These pages legitimately
>> have a NULL folio->mapping, but they cannot be secretmem pages.
>>
>> Secretmem pages are always added to the secretmem inode's page cache via
>> filemap_add_folio(), which sets folio->mapping to the inode's i_mapping.
>> A folio with a NULL mapping can never be a secretmem folio. The
>> NULL-mapping check was intended to handle truncated file-backed pages (a
>> reject_file_backed concern), not secretmem detection.
>>
>> When only check_secretmem is true (and reject_file_backed is false), a
>> NULL mapping is sufficient to prove the folio is not secretmem, so the
>> fast path can proceed.
>
> Hm, what if secretmem folio just got truncated? I hate to rely on some
> handling in the caller to detect truncation differently during GUP-fast,
> but this function returning "true".
>
> Zi is working on a way to distinguish folios from non-folio things: that
> we can identify whatever was added through vm_insert_page().

The idea is to give every allocated page a NotRmappable page_type and
1) let page_rmappable_folio() remove the page_type by setting mapcount
to 0, since page_type overlaps with mapcount;
2) allow callers of alloc_page*() to change page_type from NotRmappable
to other types.

After these, rmappable folios with any order is a folio without any
page_type. HugeTLB is an exception, but rmap code has special handling
for them, so it should be fine.

I have a draft[1], but have not had time to refresh it yet. I am planning
to work on this after my two other jobs (make READ_ONLY_THP_FOR_FS enabled
for all FS with large folio support and ensure ->private is 0 for tail page=
s).

[1] https://github.com/x-y-z/linux-dev/tree/remove_mapcount_for_non_folio-2=
026-02-16-23-27

>
> Because that's really the key problem here: vm_insert_page() pages are
> not actually folios, they just look like a folio today, but looking at
> fields like ->mapping does not make any sense.

Based on my understanding of some callers of alloc_page()/get_free_pages(),
vm_insert_page(), they use GFP_COMP to get a compound page and vm_insert_pa=
ge()
individual pages of the compound page. These pages might be pinned.
During past THP cabal meeting, we discussed about it if
1. we should disallow such uses and only allow order-0 allocations, or
2. we need a new type like new_type_folio for them and the type does not
have folio fields except ->pincount.

Willy (cc=E2=80=99d) said he coded some experiment on it some time ago. I d=
o not know if
he is able to recover the code.

>
>>
>> Tested-by: Sourab Gupta <sougupta@nvidia.com>
>> Fixes: f002882ca369 ("mm: merge folio_is_secretmem() and folio_fast_pin_=
allowed() into gup_fast_folio_allowed()")
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> ---
>>  mm/gup.c | 13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 8e7dc2c6ee73..3ea661e67eea 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2784,12 +2784,17 @@ static bool gup_fast_folio_allowed(struct folio =
*folio, unsigned int flags)
>>  	mapping =3D READ_ONCE(folio->mapping);
>>
>>  	/*
>> -	 * The mapping may have been truncated, in any case we cannot determin=
e
>> -	 * if this mapping is safe - fall back to slow path to determine how t=
o
>> -	 * proceed.
>> +	 * If the mapping is NULL (truncated, or never set), we cannot
>> +	 * determine whether the folio is file-backed, so a long-term writable
>> +	 * pin must fall back to the slow path.
>> +	 *
>> +	 * Otherwise, a NULL mapping proves this is not a secretmem folio
>> +	 * (secretmem folios always have a valid mapping to the secretmem
>> +	 * inode's address_space), so in that case, we can continue with the
>> +	 * fast path.
>>  	 */
>>  	if (!mapping)
>> -		return false;
>> +		return !reject_file_backed;
>>
>>  	/* Anonymous folios pose no problem. */
>>  	mapping_flags =3D (unsigned long)mapping & FOLIO_MAPPING_FLAGS;
>>
>> base-commit: 7f87a5ea75f011d2c9bc8ac0167e5e2d1adb1594
>
>
> --=20
> Cheers,
>
> David


Best Regards,
Yan, Zi


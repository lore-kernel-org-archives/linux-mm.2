Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AE6CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327C66B04C4; Mon,  1 Jun 2026 16:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7266B04C5; Mon,  1 Jun 2026 16:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A01B6B04C6; Mon,  1 Jun 2026 16:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 00B826B04C4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:31:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 99E331C1FEC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:31:02 +0000 (UTC)
X-FDA: 84832487964.25.4E1E42A
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013027.outbound.protection.outlook.com [40.93.201.27])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E977100015
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:30:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BPBQ3wOW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.27 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780345859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/zYg/b5lwKIxhCbar8f+rrxf5iT84cFfW2++e4NRNSE=;
	b=Hm4ug4r8xvitNDW70gPSe6DIOjoFytct/myOkryGlTMeFpWn2FkoEP6hqtTsZ6HdxLeatQ
	QQpMRhlj15z0OPCZHCKFbq0K/7e9Dj5Xm+5dRxipp0L0Qzs7j+oEM8ncEaZNUVseV8x1nt
	JXxbuvxpLSlNRB1QmUmGC1XS3sgD0CM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BPBQ3wOW;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of balbirs@nvidia.com designates 40.93.201.27 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780345859;
	b=MIMKlW6JsMLV4ADgeqklMjRnX/xwJNxx+B/h5C3LB2k4WMoXMvLOVq6o92NrY9yO8Fqfz1
	FZUdMbExauvZ4t9/3ByzQlBtDjStZR9VOTvz5aC1R5xGrEJ4a249u1RGzaydb9M78JbgCd
	ivcYisIEcM5H2fmRCh8LzYthc7xT5XI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a+5B4GbRO2DrLXDo/Ni5oR4RMkO+xasWNzfY4Rdy9S60U+L0XX88kVW53sMRUJMMN6rb+BJz3HbwAsVBPUdkR9MuErHWTDNg6R/prVnDg9e/Vwly0En5cFXj87t1+waMEuaiF/TLE6jvgFmk0jQ+dUHXhTyWYIPztz6s2viqp7X2pBo07PV2mIwESvZgVKUNR4vhByaTv2jt13R3bfgOo3PDK+ta/tFUZe0Hx8bTk5k77LbOQok8glviUCGMBt3cL1ltMBQloNMRH8sAAU3RQ1wmKyTgCMAB9qizmOiKL1bUFZ2N34UFdY2SnTAlBsXKawYey+1YoCOPvl1DMiuy2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/zYg/b5lwKIxhCbar8f+rrxf5iT84cFfW2++e4NRNSE=;
 b=UaFFPiUUmyVo8It+gb+QicEEnuYqTR34gH1Re5olGiZ/BtLanbokTR1c+t4N97s8up8tTQvADCARHhRJbTO4gM8DA5M8v8+Blx3AjkUBGwYVBrtByLr0lAGtewmdkz6u63JsNViXE1ZM1/EPKscgBV2aD2x8AhQaEf6/181STJigkpAZO2ElMEe2hYll0BFMcR5KjPBJTfj+xF6D5zK3ZGq0j8zjJ/PIqZVyoF7USoDf7/o4HdoNfSLOnaPmh3oCNDcCb4chh5d41rxo80Iz2QQ80UCAURJN+W+ak4OO+rhaXu8qf6LcIrS81P5UCRnk9hAY8skoYvurW8+o86BCDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zYg/b5lwKIxhCbar8f+rrxf5iT84cFfW2++e4NRNSE=;
 b=BPBQ3wOWy+53JrIlTMN1nsKCskxZLBQ/BAr44NsB/vuHsdLk3WlPBYv0q/b4t0NCimrcFU0xeWa8Irn9wszBjOBrqsZ6LYsfvZFe77RYIj6Ax7PD98rKkjjryJ58wnVASOF+NEwuJmaZlx+XDUPla8wF/xFfPmpU1crCPgYRIpkkjRk2OFsD5tH1i44KP3w6NvH/VE0fI9OeNyrUEiZSdVEl8v9mNqGCm/qlpz8QEOde0RSOv0DriNW2NAYb1Bi2Dk7jcc1NWMOAdu6KAw4iun3YcwLOTdnKAkk1Nq1KCJB6g4gcfvw0esr4TmKDxsps5S/emzxJfX/xXaftpoRyBQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by IA1PR12MB8223.namprd12.prod.outlook.com (2603:10b6:208:3f3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.13; Mon, 1 Jun 2026
 20:30:54 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 20:30:52 +0000
Message-ID: <8f7744e0-5729-4862-b5b0-401c2bca4d50@nvidia.com>
Date: Tue, 2 Jun 2026 06:30:45 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: use correct flags for device
 private PMD entry
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 SeongJae Park <sj@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260601083044.57132-1-ljs@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260601083044.57132-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0018.ausprd01.prod.outlook.com
 (2603:10c6:220:1e4::17) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|IA1PR12MB8223:EE_
X-MS-Office365-Filtering-Correlation-Id: e11b494b-9f4e-4aff-f242-08dec01cacd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|3023799007|56012099006|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xjFYB/pSjj3/AJ/HXgODGPirDl8te6A2H2VNRr/7ouEMqOmocjUDqBHWm57xAl/pcYQsdxuZDpXh8jDoaf5kHPbFe3rYMZ12Hxh08qF8UjFkiHDSpW2NN70jHJlt+hlT0k5IhI/nQ7a1MKAc8M5DLcihjHzO/UhQqJ76pGouRse2m114GHA6ohtZCFVV+2tZpHVpD2pDNWrLyOUR6QP7snF4NqnQmPyJJeOHjy4jMjAwuaG1eKSIu0jNs9bp3/uCl3w+Y7VCi5sgXSBIKmsgDtTsrxs7WJt2OxR6I0Cl++ZrqGczDJhaiu3DGRtXFknOecsM9vaXdIx1QYzmv0C8p09gjACE1IaSmjKjo4K17H2UFESn45IFsUaIdF1xkdaB9Oz8Fi3rXP57M7RTCrJOObpPbg0y2DVDW0P91NoloSqxpEK6Ld2YOBi2c3SC+b5u8FmHJIdE+8kiytZEJZRDu68ci5wVwb6w4xyDa7yKmUDD7TDVhbGBkXjvSt2SAeV6jCPsxy/8zTgtVARe4ArSQwL3wzLdMX7Fl8Q5YxYPggiHk4+bVeKd20ex7MCqRGK/Acr5ucDZvzadq8bk7f40uo5dnKIcS+te06y8Qebk7TaMlIOcYfx0+fTmRkXtfcy1vBrnNF7T/ihJXCNsHA7HaxUt5GV4xTFTz1ZEYIm8+7Lk5ea4qRPl3zBvdX99V7UJ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(3023799007)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDNhTHMvOXFqbnF6WmUrVzlYajFPd2Zwd3NlN2lIbzFFZlZkTEhraUtkcnR6?=
 =?utf-8?B?cEExQjNnMm0zNEtyWWlGclk0L05Fcnl6VmZ4VmowelQrS0RnOFJ1c0hZTjJz?=
 =?utf-8?B?LzZudTU5dVRtNDFyaDhTQ1YvQ2hiS0hzUGdNOVlnS1FQemVaWm5FV1U0RGQ5?=
 =?utf-8?B?NkFvTThaY2ZjU0NzaTM0cmExWXovRldtUUJiSDYzK2UyT1JkTElBVjRqQThQ?=
 =?utf-8?B?enZoeGhxemdRUCtRZHhXWk5WcVhUZUtpd0NJaEtQN0ErN29DSk5ZbCtta0NG?=
 =?utf-8?B?ZUUxcFkzNW1rTlIzSGQxYnptV3lta2ZXTHh3Njd1MWhQQzUwbThjVGRFeGlF?=
 =?utf-8?B?R3F3cmwrQ2hocFpKRi9DcHJzQ3lGR0p4Z3ZRMC9Xc254TlVsUEo1dm4xTktJ?=
 =?utf-8?B?RGFXcEpycFhmSlA5S0Uyd0tMalV2VC9SaDBzTTlsVFdLMnBGS2R2K25aNVBs?=
 =?utf-8?B?bXJoU0d6MEpqcUgvRXVWYUdqcnpFVzdNVlFXQ0hOUkkyQ1hUeFZ0ZGlFOGoz?=
 =?utf-8?B?OHNPblZNWTFFMnNld1hoNDJZM3c0NnpIaStkREQ4UUhzcGlWWUQ1WUovNk1Q?=
 =?utf-8?B?Qk1xT3FjZzVlNmdvbi9adU5ta3ZNMlYzNU0wbEIrQ0w5RkRzQUgwZ3RGYjJ1?=
 =?utf-8?B?RVVaTEtJKzhuSHp2YXRvSkU3NkdEZWprbENHUXIzU0xMZ0dJM253QkQ2R1pF?=
 =?utf-8?B?aUllQTFqOXB3NTBNRWZRWmw0Vm5OeUlxbm1PZUM1NXBlYWJIMS85Y3NLbS9r?=
 =?utf-8?B?aVlXbVRPTjVqb2ZvVmlId0VoLzFwTlNxNkZXelhZNVZzVkh6dE1zUjBuY3VF?=
 =?utf-8?B?Yk9ISENBYkhQaW1hZmIyZFJGQVc3dnlLZnI1ZENBbGhHMTRQRksrWEl0V1hF?=
 =?utf-8?B?dlVzTWUwNmVBMCtwVmVrOHIxMTk4dlgxKzZheWJ5WVBKOXZuVTNjZ0lZeWdV?=
 =?utf-8?B?aE1oeTlHSFdwNVEwUFdockVTTERiYW1MNW01dFp0aUV4dlJEdEFyYzZQbnNS?=
 =?utf-8?B?MExoeWtEbkpmak4xd1pBbnd1MWZMYUFFTHpCWW1QMTh3NjA4ODdSTmM2YmRp?=
 =?utf-8?B?aEM5dXpGS29hRW01TEpqWWZ4RXQ0ZVczbUtEMThoejN5eTgvK3Rha3h0UVN4?=
 =?utf-8?B?d1RLYXhPNGI4aDBEYVBRR2JlMjlBRFkyejFwKzlZbUE4SVlkSkE0VGlIK2xy?=
 =?utf-8?B?c1RRTGxOTlFhaEUvSGcramJyLzF4ZlJwcVZkVmRyanJZUHMxdjNBaDdiTmVw?=
 =?utf-8?B?NmJRNDE1R3cwcUR3TU1sS2kzaDZjb3NQejZ0cjBHSkV2NjZOZmJNQ0RnWkVk?=
 =?utf-8?B?TUM2T2daaEE2Uk1lRThNSEFGaW55R3VNK2FZd3RyMUxtUStKU0V0SVRuKytr?=
 =?utf-8?B?UEZLTmZxZ1J4aTAveG0wOFlZWFlOTVVzckVHM3J3ZS9KSngwQjVOREdGZW9w?=
 =?utf-8?B?R1hpUTNMemlNSHQ1d3pYbDQ1Sm5waEFYdWJaSlVBUi9jZURxN296bFdJbllq?=
 =?utf-8?B?ak5RZnYyQzJvMHVtczhQTzNlWGhRTWRiQkZJS0JHNzhRWHNJL0gvN0dhLzAz?=
 =?utf-8?B?aVNKZmFyeXI2eks0M2JrTUNKYnBXRXdMRzRSeGRnanN4d0NHY01hWHNPZUJy?=
 =?utf-8?B?aGhmazNkTDJteHpaUTJ2WGFRVW9OWEN0Y09Fd0paSjJJUEV0eDl0b1FPOVVx?=
 =?utf-8?B?UWJ6bXE5V252YUxPYlY5T3JQVDJqUDg3NDJEZllERHlnVTEzVUFja3V2eTk1?=
 =?utf-8?B?dndEdmlGVXo5b1JBdU44QzRENHJPQ1ZNSXYzSUN0QjBmT2t2eUNUSENSMmx2?=
 =?utf-8?B?Yk8yZ25vbjVFMENaWFZ1ZXJyRWU1R09wNThTQ1l4bXNiQmdSU3M2QWhOTENw?=
 =?utf-8?B?S3lQTXY3Q1FjTk1hejVmWFplODJZV2phYU9yQnBSS00wckZsc1hFTmxpck1q?=
 =?utf-8?B?Q0JDZEoyc1ZCUUxyZWh1bUEwTkovdEpCR2ZLR2ZZV2lYMndMd3lOb29WTFlZ?=
 =?utf-8?B?aTFMRmFSblRXUWFMeVlLWWtJSGRMOEZrc3pLT1BvRTk2UTU2T3B5Y3UzN2t2?=
 =?utf-8?B?NXc5WC8waFg0VjU2RW51UEViYjZHOGdoeitHbElYT3QxOVRkWFBod1pncHJy?=
 =?utf-8?B?ZXRhRW1razNuNGR2TGJPMlFEck9pOWZYaklzUmtHN01tdUM2TDJPRGdPbXdN?=
 =?utf-8?B?cVQ4Vjl0VlVpaStYcEwzanlKczhzK2dNemhFRHFFSjBvUmt0VmxCUHZWc1N6?=
 =?utf-8?B?UlJWYmpVOVo0bjBQdlpXRWFtUUJVc3ZQT2NsTXdXd1d1Y1UvTDVrQnIwTTcx?=
 =?utf-8?B?SWk3Ky91SXI4TjRlUEZyZ0dvUHdLNW9DUm55cU14TmVzVnBQaWVsdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11b494b-9f4e-4aff-f242-08dec01cacd0
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 20:30:52.6420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ybbU4bz1Tj51ihqFRrGEvrovOTMGUPtL1g7e6d85RxosvdLKJgTck4sJWJvpIE8HICTaMxtLxfiKGR0mXPkvjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8223
X-Rspamd-Queue-Id: 9E977100015
X-Rspam-User: 
X-Stat-Signature: dw1gxtjuc1ce95ni7xddfsfcbcf3w9w8
X-Rspamd-Server: rspam09
X-HE-Tag: 1780345859-602010
X-HE-Meta: U2FsdGVkX1+MLF8J0MTNQMLC5+tJc2Ykm90uCIFkSPBEY7I/MTHAynCDErSUspGVuVHQKWlrUDra4GYU9/aX8NRv/YIkm0fvuRz/5RHxNL4B/zybNfi5eOAT8VpdSlnbMVc/IagWFhluFyPNtHUBIsCNOLAZnhUkLptCZl4YRPn/93ARPVKmv6fEbyUeeMYNi5Hsa+af8i4KQzXSupyf1MhA1Cgnw2zOtCswxQB04TY68upnIFwQlU9pq+6KU5cuCLdK0wwJy+Q14GyV4Xd2s53SjXQ68QjJtx0KhIWC0CT7PJU7rA1APxKctm3of4LraLS2d9d4mBflQzjvv3BBpO11qoc7hPxrM57kRlwPxudlOLjMBAkVKDxAxiVqlzcGOTGNsL53MCwpPyPfcjn+5tmPtfqf+dvhb19emywhscC83AVIjs9PVukozyD7ELPzgiU8L9qlaAlpBqqSb6GvGQ2566JpSsQp/1PgxF6mhjtcS2cW9AMBbQOWJPcGn4a+3ySoHh971lCMr/aDzaK55bAWdLs8lQXFFFaD31vMBjXbqOhMjcFBmaAxsX93RQAM9fYPXOS54utiZx7ajaRCqEoilOmDRNRzRw4nnOi96w8pKvI92EkQV28AofIwJzWGp9uNDbE4TYQ933tt22cUXlUJ4/8qy9Xi72qc57g8UBRl6sVJrIktjGDlFkV3Ac8gwqfiAsRVMPUodVBcvVa1PTshqpb1zn3xqssrlQm6OtShCv1EAtHMwxyul9IZ4R3pXQiCcrpOMLT507JREUtNN3KMWGXTxEai9MxAFEN2dK0xsb89mGQIZA6bsiwjMDvZxSIchmay+Db3N2Px3bRXDsm260X2J+fi9J/6wu0yq1zpQqWm8sekGiNw2T2nlTXGaHp+Ma9b2fv/sT7kPh7HQgI4itWTT33v94ARZCr///BTZwP/AArnFO0tQf8mACtcyKNgrkhkcdSo5qHj6Hv
 EoKbO1KP
 yO1zGbJpILnL+2Cnp8XZERjx+EK8j6p0RIukQ1jAGlHmaykPoPkr6KfxSy02vdIZ95Dw03wKlk5e3Kr3ehjHkAOM9Oaonr187GCnuwbxthCrgr2T+HeziI9L/Ga/ia+oyt8mcvGXgVp83Uwmcmjy9c3QvLadzzgCowTjuKobViV0iyyiE/7aGq+q7zIq6ML/AgZSiSHhQploAXBj/ZevmINYDFYQywbB3DCst48/0J5gRxrCXvZF3AQVYw79wgZdq86Nq9B4Fe5mcFexRw02HKqwfQu/27x2t5o584fNy1SdMMDpdhhCte/8svcXRuQSiuFsecdfsiFzxF0ViccJtGMEq/ol54IQBrxvXieUYAfNE/rf/KatXv4YhKvVA+7wjSXK345ydWtotGRwGN0XxfKdSkot+aleGs2BI3w0jWgyNYc5gvnzmq6i65WZnTBRH7jhUVepIlIzAELuLpviJ8vmv4SWTZne6Z/xg67WhVeQQL06mKECul7seYpjjOYaw3u/6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 18:30, Lorenzo Stoakes wrote:
> Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") updated set_pmd_migration_entry() to use
> pmdp_huge_get_and_clear() in the softleaf case, but made no further
> adjustments to the function itself.
> 
> Therefore this function continues to incorrectly use pmd_write(),
> pmd_soft_dirty() and pmd_uffd_wp() to determine whether the installed
> migration entry should be marked writable, softdirty or uffd-wp
> respectively.
> 
> Whilst all are incorrect, the most problematic of these is pmd_write(), as
> this can lead to corrupted rmap state.
> 
> On x86-64 _PAGE_SWP_SOFT_DIRTY is aliased to _PAGE_RW. So calling
> pmd_write() on a softleaf will return the softdirty state encoded in the
> entry, assuming CONFIG_MEM_SOFT_DIRTY was enabled.
> 
> This was observed when running the hmm.hmm_device_private.anon_write_child
> selftest:
> 
> 1. The test faults in a range then migrates it such that a device-private
>    THP range is established.
> 
> 2. The parent then migrates it to a device-private writable PMD entry whose
>    folio is entirely AnonExclusive with entire_mapcount=1, softdirty set
>    (accidentally correct write state).
> 
> 3. The parent forks and the PMD entries are set to device-private read only
>    entries, entire_mapcount=2, softdirty still set.
> 
> 4. [BUG] The child writes to the range then migrates to RAM - intending to
>    install non-writable migration entries - but replacing parent and child
>    PMD mappings with WRITABLE entries due to misinterpreting the softdirty
>    bit.
> 
> 5. In remove_migration_pmd(), if !softleaf_is_migration_read(entry) we
>    set the RMAP_EXCLUSIVE flag when calling folio_add_anon_rmap_pmd() for
>    both parent and child, which are therefore AnonExclusive.
> 
> 6. [SPLAT] Child sets migrated folio entire_mapcount=1, parent sets
>    entire_mapcount=2 and we end up with an AnonExclusive folio with
>    entire_mapcount=2! Assert fires in __folio_add_anon_rmap():
> 
> 		VM_WARN_ON_FOLIO(folio_test_large(folio) &&
> 				 folio_entire_mapcount(folio) > 1 &&
> 				 PageAnonExclusive(cur_page), folio)
> 

Thanks for the explanation, I wonder why I've not run into this during
my testing, I do have DEBUG_VM enabled in my config. I wonder if I've
never had soft dirty set

> This patch fixes the issue by correctly referencing the softleaf entry
> fields for writable, softdirty and uffd-wp in set_pmd_migration_entry().
> 
> It also only updates A/D flags if the entry is present as these are
> otherwise not meaningful for a softleaf entry.
> 
> This patch also flips the if (!present) { ... } else { ... } logic in
> set_pmd_migration_entry() so it is easier to understand, and adds some
> comments to make things clearer.
> 
> I was able to bisect this to commit 775465fd26a3 ("lib/test_hmm: add zone
> device private THP test infrastructure") which first exposes this bug as it
> was the commit that permitted test_hmm to generate the test.
> 
> However commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> device-private entries") is the commit that actually enabled this
> behaviour.
> 
> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 45 +++++++++++++++++++++++++++++++++------------
>  1 file changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bf9b480bb3b0..79463c709c98 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4982,7 +4982,7 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  	struct vm_area_struct *vma = pvmw->vma;
>  	struct mm_struct *mm = vma->vm_mm;
>  	unsigned long address = pvmw->address;
> -	bool anon_exclusive;
> +	bool anon_exclusive, present, writable, softdirty, uffd_wp;
>  	pmd_t pmdval;
>  	swp_entry_t entry;
>  	pmd_t pmdswp;
> @@ -4990,12 +4990,26 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  	if (!(pvmw->pmd && !pvmw->pte))
>  		return 0;
> 
> -	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> -	if (unlikely(!pmd_present(*pvmw->pmd)))
> -		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
> -	else
> +	present = pmd_present(*pvmw->pmd);
> +	if (likely(present)) {
> +		flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
> +
>  		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
> 
> +		writable = pmd_write(pmdval);
> +		softdirty = pmd_soft_dirty(pmdval);
> +		uffd_wp = pmd_uffd_wp(pmdval);
> +	} else {
> +		softleaf_t old_entry;
> +
> +		pmdval = pmdp_huge_get_and_clear(vma->vm_mm, address, pvmw->pmd);
> +		old_entry = softleaf_from_pmd(pmdval);
> +
> +		writable = softleaf_is_device_private_write(old_entry);
> +		softdirty = pmd_swp_soft_dirty(pmdval);
> +		uffd_wp = pmd_swp_uffd_wp(pmdval);
> +	}
> +
>  	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
>  	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
>  	if (anon_exclusive && folio_try_share_anon_rmap_pmd(folio, page)) {
> @@ -5003,24 +5017,31 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
>  		return -EBUSY;
>  	}
> 
> -	if (pmd_dirty(pmdval))
> -		folio_mark_dirty(folio);
> -	if (pmd_write(pmdval))
> +	/* Determine type of migration entry. */
> +	if (writable)
>  		entry = make_writable_migration_entry(page_to_pfn(page));
>  	else if (anon_exclusive)
>  		entry = make_readable_exclusive_migration_entry(page_to_pfn(page));
>  	else
>  		entry = make_readable_migration_entry(page_to_pfn(page));
> -	if (pmd_young(pmdval))
> +
> +	/* Set A/D bits as necessary. */
> +	if (present && pmd_young(pmdval))
>  		entry = make_migration_entry_young(entry);
> -	if (pmd_dirty(pmdval))
> +	if (present && pmd_dirty(pmdval)) {
> +		folio_mark_dirty(folio);
>  		entry = make_migration_entry_dirty(entry);
> +	}
> +
> +	/* Set PMD. */
>  	pmdswp = swp_entry_to_pmd(entry);
> -	if (pmd_soft_dirty(pmdval))
> +	if (softdirty)
>  		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
> -	if (pmd_uffd_wp(pmdval))
> +	if (uffd_wp)
>  		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
>  	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
> +
> +	/* Migration entry installed: cleanup rmap, folio. */
>  	folio_remove_rmap_pmd(folio, page, vma);
>  	folio_put(folio);
>  	trace_set_migration_pmd(address, pmd_val(pmdswp));
> --


Reviewed-by: Balbir Singh <balbirs@nvidia.com>




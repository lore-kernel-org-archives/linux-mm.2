Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C7AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BEAA6B00B4; Mon, 29 Jun 2026 22:01:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170936B00B5; Mon, 29 Jun 2026 22:01:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0394E6B00B6; Mon, 29 Jun 2026 22:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C51D26B00B4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:01:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 01716167AA7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:01:18 +0000 (UTC)
X-FDA: 84934926678.23.B2C3FE8
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010060.outbound.protection.outlook.com [52.101.201.60])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2A11A1C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:01:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FQSIUqpc;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782784876;
	b=cnlNoTdQ/NSPD06vif7bKoUPiW7hDvvgVpNpL76fySeO8rDcK2k367dLjXARyL8PCRrKOk
	D7MfNqu3E1CJSalfWBpvU/+CbpBOzRftUDdX5RzoLy7ZCsGCGn9o/Rxy2x0SZT3fltzR60
	kkjD2ljXbYW5A3eJCDMXc0yAlNqHaPU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssBRI7F8IJ+B4oi+JwAYL0COLt1kqht5iTcURz5FL60=;
	b=QTIB/iL27AIp0M54/T+tQE3tEYeGIDxXWlc8n8gAlahaip/MU+NBOEWF7qUW/gzQMJHLwD
	9ibTyNe/H0TrbxQ8Cw7kyCgtLCq/l3CXaIGe4EO2XEuViFBO7dGRLJjfgiwPHtNvheiz2h
	mfoBfbTNYVByQVU1ibG1FRQhMAmAm2E=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FQSIUqpc;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=adw9+KMh14yZmBU9jhDZRICyAKVPnf3bI+QtMxRs03F8zSnR3UD9HpnnF8ljHJ89J5F7cqc8gJ9l/wPOkRBYzNnvSglzqq+ne7xaeUwfTZN6GSMjfLjmK3BM1mE3sP6yAWbR/MxlHqiCU6Kgl0QTI6ebEodIpHvvdvojNwjEXvmNMSH9oW7LBStJXADLJ7R5WSFDWOG5nc6IRPvtjZyXJfs+fxZl3gNzl4cfo8IzGqvw+g2kluOGcP139HidXm1SNQcHioWfnLkyc85hLlpb/gCfAkTld5ZQjzKqscIEYQxlOtHMy4cuLfWiOHaN6RXgkrD8Ha5JtzX5MWJzxC02Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssBRI7F8IJ+B4oi+JwAYL0COLt1kqht5iTcURz5FL60=;
 b=imm1v7m8M+JouwPiDKlNvegOANro3u7nMnGtKy+ZYUHJANdxegyHt/O1NGckHO4HHWXziIXmC5H1EGlSFlD3OBST+naYiDtJ5yHJ8xriEwbeI6bwl3MhWB9rVvO01efmB7fwGd8lBdDgdPcreS06BNsbRYgsnO1DPrRtQczy0FTNiAMBG9OVAYIM7J+YtgSRS/YqV8S/VP1DFf428Yza5gfQ3OWn576JlD5nWcgfxvHxuZpc6QzB+dfDxmRRUqZLrnmI1Do4wmj7XqnPV1dO+/3uSPdv8D9+JRflFsJnUcyhZcuzp5Lr3upfwzptltQkcbBVcxWCMwqm5R/F4vJn4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssBRI7F8IJ+B4oi+JwAYL0COLt1kqht5iTcURz5FL60=;
 b=FQSIUqpcG0/UwhS6hciSFp34JNR0Qo00ReBecWKPa0mntCU+TKZuh4f82vjVHrWAP3GP3HXy4fX0JzdgsGyYcXVEpGQ7v9/QDrOY+O1n+O3KNeyNR0acJv8VxQnT6tN3w2SD8Z1z8AZbA5aqxTf7dEBFt4L+PM0RUdGVq16yt8SaftQ6RS7QsVOSVsjEfMfhe96yLWHlKFV4NdBJQn7zEAwXOLFkaZPXjNT4UtE97+nLrh0WqcSyYjxeMvQ9zkL+U78H/dj31KKXDkfW2vWY92jGtFFKPmbK3/gFqbv4N0zHTC3S9yl2vZncOOwCPwcUH5KhvvMI0tjVXS9obmiyEQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV5PR12MB9802.namprd12.prod.outlook.com (2603:10b6:408:2f8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 02:01:12 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 02:01:12 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jun 2026 22:01:11 -0400
Message-Id: <DJM0HRELNVTL.2VYXK8PB4ROM6@nvidia.com>
Subject: Re: [PATCH v3 3/7] mm: use enum migrate_reason instead of int for
 migration reason parameters
Cc: "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Mathieu Desnoyers"
 <mathieu.desnoyers@efficios.com>, "Brendan Jackman" <jackmanb@google.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
To: "Ye Liu" <ye.liu@linux.dev>, "Muchun Song" <muchun.song@linux.dev>,
 "Oscar Salvador" <osalvador@suse.de>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Masami Hiramatsu"
 <mhiramat@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260630015331.147174-1-ye.liu@linux.dev>
 <20260630015331.147174-4-ye.liu@linux.dev>
In-Reply-To: <20260630015331.147174-4-ye.liu@linux.dev>
X-ClientProxiedBy: MN2PR18CA0008.namprd18.prod.outlook.com
 (2603:10b6:208:23c::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV5PR12MB9802:EE_
X-MS-Office365-Filtering-Correlation-Id: ac9630f3-a5b1-4767-fa18-08ded64b75f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|3023799007|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	mbFpn/Cw0WI72GVO7YzXr5Utdt8KM3otpdGDVv6kqAGJqnjkUc22FwadLJjdTzmv+r4RCX17tc0S9cQfxFbN9ZrN9QyQQ+r9/IQE9FAGhHScaQEcjCpk46x8jy14jrYhyJINwhGJzZYNhFfx67ZnEYDpFWla4lggKU0rsMOffWMdh7C11yvBToXDqpXbt9+xHBXHBbP1o3hB9+PYZU0L1GQSS0wisV4CCXHcqN6vnoEKrBTz/t+vygwM9zKYaIh87LYNxmIoJIVE/F+SEadgPMTrMklr6GplwaGXvsnXsTb7VwbuuvLDrsO+nxR0qcZ6IYSPvz/YPazwelLsMvc6es9fKK/E56YoZrEhaqTbrmZt+Q3mH/+bHWDu1aaR9W/lV4FtFPXwjnlssw0/tpfJc6bJR22SSynWO1O/DWZNut+BStwo2p+wAz/BFdK+olupRt+rVD+EgMOaSJdNGpFf2Fbx1+sVMrWTPjFwh09hppJ460zoWVIps7scOWOyrLSmF8ORrFoo6KEUURavq3C+t12xlryUqsKL5JlpMxygwMdvwTvx7W48XIo1m2tra/jIj4lQku2iXro9N0zbn/unHq2HL7RqDbB8qRdjG+KiW+qMdRbv0ohGINAHttuXn57rreoc1It3gRYywc7kK6tv0Du7SI07p93eQ4rM5L4LDH4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(3023799007)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVpNNk5wWmVISUEwZytuQ2cxUGtacWtYcUdLeEdqVFF2Q09ja3hUZWRJd0Iz?=
 =?utf-8?B?TnI1WklpOUoyc0dkYnBQM0ZhdWh6L3B4THZMZXk4YWVrNXV4ZGZwVjQxQlpk?=
 =?utf-8?B?c2tjZStkSXZud3pua1FFay9kdm1HbGtKL1pBZm8vL3k4ZTFVU3plU0ZkVkNp?=
 =?utf-8?B?UUcyUXlIM3REUmd4Z0NibHc3TCtDY3I4Q0lEbGk1cEZGNVg1NTRWM0VQQU1t?=
 =?utf-8?B?VVBESkhmOE1ZOUcrNFhNRjEvQktob0dxWFo5SnVVazdWMEEyUStpYzZOcFk5?=
 =?utf-8?B?V29zeFJteDF1REdINXZrQVd3bkVMOGJON1c4UXNlaGY3Wjg5cnBEcHVibklH?=
 =?utf-8?B?MnpLU25IMjBaRmlnSGVtVldLeklHTUlpdm1KM0N0aDF6bzQ5Z0hSZWNsamJW?=
 =?utf-8?B?blg2TGpYWFV0VVRPNWVqZ3k5VCt2UU5Zak91K0xheGw4RGZ1NE8wMFhNMUl5?=
 =?utf-8?B?aE1iNFR1WXFHcHZYd0R5L0tFaEE0a253U21YNmtJL1AzZXBycU10ejJFbGNv?=
 =?utf-8?B?WVZoUit0R2JjZTFhVTlNQVAvY2hTU21xTWVMYVpNVWlLUjVQUFNKZ1hXK0FF?=
 =?utf-8?B?WWFkL2hDSkRpOUtPMTE4SVIzaFZqemJLa25DQjkxNDVpVy90My8zMjM2ZlNM?=
 =?utf-8?B?WlVtR2JkZkdveHp4cGo3ekZZQmVrYmpDR3VEN0s3UVZZN2FGYVFtUXNDb0oz?=
 =?utf-8?B?b3JMQU9IKythNlpsYmRlWENNbEdTckxWUFdWS2tEZGs1b2ZZanZ2RWozTDBC?=
 =?utf-8?B?UlM0bVBweWVoazhpVVd2RFdsbFdDNkt4STRsb2pjMFFEbXBUYjVjSXNJYlVp?=
 =?utf-8?B?MXNFYlcydVN0V1BTaUpaYlE1NDIyTndycSt0d2hmQTNRZlBGenhMQWUxWHlk?=
 =?utf-8?B?UUJaQWl4enZub3hJM1ZaS3JiSjFsSElHcFBpcDhJeXp6cEpqQ0M2ZklYMzEy?=
 =?utf-8?B?bEdDbWhiYmRDcFFpZEJjckdHb1p3NlpCMjJUbU43VFBGWUU2NFJXeFBRN1lY?=
 =?utf-8?B?YVFhbTJLNmpNNEZySTVWQndDYWt2RFJPTi8vMzZib3YyTVRPZ0NFUEF3aEUr?=
 =?utf-8?B?OWcwdW1Nd2drTXpmaldTUW5yOS9heFhhWExLYmNCdW0zNFRvWThlZEVZbGZS?=
 =?utf-8?B?T1lDYUxTa3lQRjlqZXJRbVB4OS8zaHN6MUNsWjdaWjcrRUZCQkdaV1gwb20v?=
 =?utf-8?B?MVFFQkNWNWFVaTE4UkhTbVhPWklOdEFzTmxGWmtPT0M1WWd0SHc5b3J5czNZ?=
 =?utf-8?B?MHdNQ1hyaWxYYk9rc3JDVWRzaVprRFFGVjBKN1J5a3dsd0kyYzQ1NGt3dm9a?=
 =?utf-8?B?Z3FxekxjY2pLbFBPR1ZQYTBQbkFlMUpWS3BPdjZJQi9QQ2JyZ2Q2QUtBcVNP?=
 =?utf-8?B?SmFyTkhlVW1aS1lidDRnR0hyWXlraml5TjBJS3Fjclg4RHVlMFJWdFZ6OVJN?=
 =?utf-8?B?UUJzRVJTSDFqam9MQUtTREFkbkZGbnl3YS9JenFaazdMbDdGV3lSMnFtN2ts?=
 =?utf-8?B?dSt2OUdVRkgvTGloTXFVQVNuQjZRTFduN0ROT3VxNUxNcHpHVzdCbURJbGE2?=
 =?utf-8?B?TE9MOXo4LzBOQWtIb1hSeFpXb0hXSktqaTJPRHQvTWdxbXhXUFB6NkNYT1Jw?=
 =?utf-8?B?eUxDajZuNTJkRmxyaHNPWkQ5V1YybnFIYituc2tTZm1VSmNYd2JFUlRKSnFK?=
 =?utf-8?B?VHROaEpENEZYNGVCeVFMZzdxNVBXUHE5dncrU05JRmNVaEp1VHBUaWU1cVkv?=
 =?utf-8?B?VVd0b0Z2RWJyUk1ZRlJXMFM3eVE3NXl1RjduekJsM00vTVg5R3cxUG80Tmhh?=
 =?utf-8?B?MWpLazNIQWxtZk5XSmw1MExFcERUbDFFdHJqTDloRFdmaUExZTN6aFlDQzNG?=
 =?utf-8?B?Z1YvdG1EcFNwSHEwdXZNZGRTVG1NVk5HVktteURhMzlGVFBBUnNGNVRERmwr?=
 =?utf-8?B?R3RkcnpjMHJXcDRaaC80YkhUamN4UStMS1k0ekV4elBVT0pCWXNWcVJWQmhS?=
 =?utf-8?B?MjlPM0k3Y0pxVEZOMGs1cUR3SU4rY2JJVHc2cXhUTFp3NWhaM3BJbGRhQkIv?=
 =?utf-8?B?MjA4eUR6Q2NvcXlFOEFwSjlOT3ZmYUtFK2JEUTllNFdZUzRlZTNJRFQrQmwz?=
 =?utf-8?B?SE1tOGh0ZXg3YjZmVVVDR2NQaExXdDY1YXc2cGlDT1hrMHFXdXpjZnJLV0Z0?=
 =?utf-8?B?L213QjEvZXNYeHVSMkNwMnBNcWphZTJFOUttMUpzY2kycDNuYUwrZFlINnpY?=
 =?utf-8?B?c1hDSi9XaW03NklFNVVJV2tnSWVzaXd4SW1rcThqamo1WC9wRlpndW5ObVAv?=
 =?utf-8?Q?9ql6pfUfxUzGkuVrW8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac9630f3-a5b1-4767-fa18-08ded64b75f5
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 02:01:12.4473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLBnXUpwK02ohSaUthNwvFQ90nOJzubY/cpakK7+bVkAUAeveFL3J9D8Ez4LmlPD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV5PR12MB9802
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A11A1C0003
X-Rspam-User: 
X-Stat-Signature: r9939eeztr3rojg7e8adtgqdhgrdz9eh
X-HE-Tag: 1782784876-127145
X-HE-Meta: U2FsdGVkX18xi4G3hoZRHnmgzutxIwdYj19kJtxJVC1J/2K4TfGBK7GLS6BBXh6kxoS6/GoKnVeSvj3squt662P+k6Cm/Du3yrj8zikNiUPdWvzoIJVHdzgsOYAyGbkILloOMHY5xDOyLAG3AjPawYZ0Axad7MS3geunPtds8gYil22sgO63vJhd92YiCir2uzuaobASLj3GBTZxH20k/Iyn+Dw4E3fbvmmjWAENwEIXe4ecgT99jjBpps27cb3wEDylkf8Whz2EvqHcUipO/LZdbxyDS7GYUWp5ov5tG4BGhVqJRUptrC4KIq+7IsMHMK/0wA7cnsi3JgjdlxvVvysdhw079udhjcVHHFCF89ps5xkJx66rrP+xfEwi9RAASmO7bnWlQZixIo0USixaSZNXxV2F5zJ2Q7BCoat2K+rqetSvxT66zaDxF6yJwPxHfweKNg5gExYkZmbuthOCpMVJl40fmzanjOjkLhxuogJQppqBi2+EW248BWd1gzrRxVOVL6JkERp9vrhLYglRuyDicF8tWk55OllCekEGLT40LLngIziv0W0xPbUtSjVDlP6C7djE0FyceDpnao7Hd1sXCSBpwZJ6durOi3aXJelyHFgUS++74vVuOacxtjMMITH2oOgYIdo3fvqfIQbynsy9rHIDrkl/VJAD2MYVEQF/20cvV8DQCVWZqE0lbggFOTO8ZjVL3RU/Jl8nydlsivIFnvgKNkWI3bjK4waM8smg4NH/hW7arvNujHyAy6iJRk9+6hYGPe30NtfbLz5wuA+GkhywyFQ/ewbDZJmPiEdvU4evzJ23E9pxUZ490ro1Q/q0xoMclkbM5+zApGE9haQIORiWqxhhZGFGNgz5+yyZ0Gb7ne9ZKT3bhXgAM9uV4sfIy+eIjrOV/b5QF3IhKd1x2haVlRzmtulVeexuLRh45qPEQHY8K+duUc9n22c7LuV6DgMv/IoRPRkAp+n
 5iS2mLtY
 w+/ucICDy4gZcFVJakfgWoks20T24oQ1sGXElQbmt2z7AoLhw5ROVxfTK5RekRfDoV5aYQDg/v91NV/I24vrFTl5TTKglZkkubBL0VpGWXHVwMS9hP/o1jdFFoNWEZ/4WclUU1oZmgn6KWoDIRLgc8nphJPjNi+t8zA8PzwdKFjRxdQWBRo4/qNIAN76e2B5vWaxiSyzIp8wfPWCVJZfSLFCgwekktsYHikEjWka4tlmlB8pyDVy+9JJ8jIcBy98dC4+ivoaNco9Wys2HaURIaZeE1SVQYHUVJ1gzYIfP23XHQXNJxwr+0g4Ao2J3deM6XvHOEnArqWfdv7eiXH+BZZBQd2g9nni5tRmy70rUU9B2QxONoBde45J8FVnltKtT5JRaRZr6tTIXKs0N7WkOMj3rIKsmHlUoDs7ne09ty4qR/gdEl++95QVGIbmfhbxFPSkdEFFJwvdmPjL+FJftKEPt+6eWVkdLKzRoo7DLZNKH6gos1OK/CepUe/95u858p1foDwYUN+0DjAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 9:53 PM EDT, Ye Liu wrote:
> Replace all 'int reason' function parameters that carry migrate_reason
> values with the proper 'enum migrate_reason' type.  This makes the
> intent explicit and leverages compiler type checking.  The affected
> subsystems are:
>
>   - page_owner: __folio_set_owner_migrate_reason(),
>                 folio_set_owner_migrate_reason()
>   - migrate: migrate_pages(), migrate_pages_sync(),
>              migrate_pages_batch(), migrate_folios_move(),
>              migrate_hugetlbs(), unmap_and_move_huge_page()
>   - hugetlb: move_hugetlb_state(), htlb_allow_alloc_fallback()
>   - trace: mm_migrate_pages and mm_migrate_pages_start events
>
> The 'short last_migrate_reason' struct field and internal helper
> parameter in page_owner are intentionally left as 'short' since they
> store per-page metadata where size matters.
>
> No functional change.
>
> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> ---
>  include/linux/hugetlb.h        |  9 +++++----
>  include/linux/migrate.h        |  6 ++++--
>  include/linux/page_owner.h     |  7 ++++---
>  include/trace/events/migrate.h |  8 ++++----
>  mm/hugetlb.c                   |  3 ++-
>  mm/migrate.c                   | 12 ++++++------
>  mm/page_owner.c                |  2 +-
>  7 files changed, 26 insertions(+), 21 deletions(-)
>

LGTM. Thanks.
Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi



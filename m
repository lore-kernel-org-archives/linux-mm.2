Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67D6FC531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 16:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6716B007B; Thu, 23 Jul 2026 12:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BEEA6B0088; Thu, 23 Jul 2026 12:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2E26B008C; Thu, 23 Jul 2026 12:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E45C56B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:31:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75F218054B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:31:15 +0000 (UTC)
X-FDA: 85020581310.26.F4D2599
Received: from YQZPR01CU011.outbound.protection.outlook.com (mail-canadaeastazon11020093.outbound.protection.outlook.com [52.101.191.93])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2D38540003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:31:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=QRO4IOjK;
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.93 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784824272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzWKzHlmja/0Yoxzu+YbLBg1CWSDZsx6bJjsHl890GU=;
	b=YHSllq2GRssEZ6d9BS+/gno/MV3R1GeQjdyNeMD0HzJKOvHDrn7cKL1QTMNpfGxBOqfSo5
	/kT3zEXHYtF6j8ZecUeRiIfZSr/oqmuKlcakwrOXB0rqP6ki0XOUeP2emsdcVOlEAWB/tu
	cRR1AGGfhdUIk4FELqQsGlOAT3jfKqY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784824272;
	b=AJvWHnCXptFlYQWEVY6c+cA5snnrVV1cTzFz8sZlbFGDsHw6OxsB1rX1Y4E7OG2789SimZ
	TNRwCCUyM2nyhr+QrdW3Q6Y/6h8EuHl7iEhqGHfmiuRJNw8tGJhnDQDgHLpsuIjTwqRcwP
	03PY5Oa2nNHgPExiicJKyBazhgsYx60=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=selector1 header.b=QRO4IOjK;
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 52.101.191.93 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y1wK6/VThhrGM963CPwOaa0g9pSvvvat+Z6Xi/QE6pYTFjlvSN0AIywzZqEgvItMoXWGdeZtn4jKInEFNmXtOQ1GnUs7tmEx8Zz+VRpyFDFKhk1cfSf5vVF2MI9c919EdJySJ2xt8uzqP13IBC9mmQw86hkqCunYekMmU7afHkDCn8AMk5SucYw8f+PawDFUbWiKx3lAoiDqfhN0kJJnynYzt/UjN1emJWrAzNqcdBVCz79QSUT0pa4w81evLgT9rP/b/9CLvD9B5Y1dFKra6vrNQ5SloMxhd81zE42Nw/ZvbpgzeM20AsiwtvxJRCuJbQN2XAqt9Tt5afDKG5R6SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzWKzHlmja/0Yoxzu+YbLBg1CWSDZsx6bJjsHl890GU=;
 b=UKCz2Kxz4O8BzwUNjJPmoMVuPEfnEZT64/VVjQdlXbbmz8Z5RM6vG4tnwLunUUnx7qMg06C5kBrB2Hxrc2TPq3EJKJqaMmhH5Kej4HKz0kt5NoTA/XsCsN7Xph+8lHxnlN0H6A3kho9OqafbBao41pWqi1uZYPOOfnQ1fif3ajkjWoPGcxY6bmiSA7YBzYGhx4rS8c7IVKaDQPfu06NSBCYTrlx0eqqUIaXqBx80NLWjYDDt/mbhBe0B7ytSXybQHDKfLZo314ozvOugOKNQwIyJ3JTIRUhKnIpkftLzOKZ4+O3+cZ5sDcRDSKmNTL707vyC4p26lYXYCzvUd6Xs3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=efficios.com; dmarc=pass action=none header.from=efficios.com;
 dkim=pass header.d=efficios.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzWKzHlmja/0Yoxzu+YbLBg1CWSDZsx6bJjsHl890GU=;
 b=QRO4IOjKcvj9+b1gyu6fjs6Ot9803Ve4DQKmxg2QoPauoTut4fhD33bc7HAT7ggFzMSStX+irC2a40eGE0c3Z+U0cV/+NpIRBW1PU9CGDKUy6I2/iPrupZ+8tHatDomGw6pnwrQM+fohPAAxgQhFs81IF2YRC4fjEkr998k4kqPFZgngMHUskpApyBzv7Y1dLy1Qvg4n0XGPuX1l4PhaZg13jc/853JAnIXgv54oPwvEDbD9jjGP0D24+U1u6T+qyHoZ03YAp1SsG66Cc6p0vBnY0blwuFQBFSjLV/LmI/mvd7YHlljBLbCIAkIG3rpvFXQRZhQyRlrfwMNfpeP9AA==
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:be::5)
 by YT4PR01MB10692.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:102::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Thu, 23 Jul
 2026 16:31:05 +0000
Received: from YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1]) by YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6004:a862:d45d:90c1%4]) with mapi id 15.21.0245.010; Thu, 23 Jul 2026
 16:31:05 +0000
Message-ID: <21d24fc4-141d-4957-8b96-6d5887ef4027@efficios.com>
Date: Thu, 23 Jul 2026 12:31:03 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: use precise current RSS for high-water accounting
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260723134158.1473841-1-nirmoyd@nvidia.com>
 <bd3facf5-cc4e-4fa3-95cf-0f4aa926ae23@efficios.com>
 <20260723162133.877125-1-nirmoyd@nvidia.com>
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Language: en-US
In-Reply-To: <20260723162133.877125-1-nirmoyd@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQZPR01CA0049.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::13) To YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:be::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: YT2PR01MB9175:EE_|YT4PR01MB10692:EE_
X-MS-Office365-Filtering-Correlation-Id: d58e9a39-32ae-415d-b1b5-08dee8d7cab5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|56012099006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	r/9+T9PjITeFuYad5dJdLd39TQ34uXMUTzGcXkfYU7dF7hNFuItBIt2En/9+PTpRLhMc/Q2YNKEOHp2yj7EjhfDA8FDt2ajoZ0PPXrpKOwZncqKPp9lNkgfYIQlul0EYhQKDoFxEKsM6WUgVM3lGamPEgJm/z5uW25u7juV8LezsXAlmbNTeyGOE/UJQp+q00gC+9aELE8mh0RD0z6e2/dpnPxnsbWhqfofgVaVa1RKHLS8bUG3wd4g9gg6Y7oFnsJhelYljVUN96g3+GsGftVYX4r6BatnDh6EEZqufRXnGyCseU+6V2BM2EtFkYbbswgIgSBuRDEiUmBhxDRMusFsv16z2hJznGR+9VTu5Cderc15X6M9SV8KJG6CZJ5tUBiiGRG7hAB+HRfI9U3RkaWanaWWf3OZt0bl02L1Xlh9cftbYwcAwZjVwW6xf3xbSqvZZ1ovKoBtBD46myay9esdHEyQGku0JOhyGsfz23jEkv/IAyhO651XzxICe12kVyc/Mk9c8l1b/Ei0lWN2BIyeNMNNNi/VdmFb8Z86OTsYcgrwi3ZJdvzH5A++fTBoEHcK94itZnUpEDMwEhgqVgq6VubInwowh3cI59gqTYTA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(56012099006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Sm9JaXZOOERaSk5TUnRQdFg0L0hkTWtiZ1laSEtEUUZCMS8zdDZzQVl4WXZZ?=
 =?utf-8?B?VnlLdmNHT2JzNE1tbldLbVlDN2VQSzhHTTJqQ3hMdHI2MktaSXBjZmhxd2Jy?=
 =?utf-8?B?V2RLVVpTOHIwTmRyVXFZc1ZiZUo3ZE1kSW1vOWU0NEs5RlBlZ3pKV3lWUmhk?=
 =?utf-8?B?T1NFa053dmMxL1VuUkRjVDdocnoxT280ekZheTVMRnlkQ2NPRFlLbGNlKysv?=
 =?utf-8?B?MXpXOEU0WDBzQmZTcXV5WUdzSFVVSDlNcFNpSDZZaGxFVGtpRk56R0MwZXMv?=
 =?utf-8?B?RGV1bU9yeFZwdGVlN216M3AzUFJoN1FXZkxiNWwvVFpnMTJnR2VuZk96SDkw?=
 =?utf-8?B?aGl0VGczSHkwdzVNdHQ2blV2SjNqLzFOUW9GeUYxUUJ4WndhZDhBSFgvamlX?=
 =?utf-8?B?anVld2JuZkhkNHhuN3lDRWJRUDFXdzdMV3NYM0QwQ2hLWlBJRnNuSVgwQ2RF?=
 =?utf-8?B?bGFFYVJZbkNLZ0V1QjZsZWpaUmVqdU1ZMDBublhFY3ZUZHo5N3gwbEpLRktO?=
 =?utf-8?B?ZTlVZ1hjUml2SzNWKzk2UTBwZkhHTlZSTzRlKzBMS0htbXl3bEVCVnlLT2ZE?=
 =?utf-8?B?THdlRVo1cVJ4bTFKR3F5MWM4QklZbEw2VVlPUUM3eEcyZm5YR0JObG5ZK2Yx?=
 =?utf-8?B?cmxhZkx1Qy9CTklFTTZ1WGlYbzQ1dE11Sy92cm1wTWtybHY1b3o4VWt5WS8v?=
 =?utf-8?B?RVVUay9GNW51ODJCbGV3V1lra29lY2JSclN3aTIzMnI1MDlTUGZtcC91Z2dL?=
 =?utf-8?B?MlRuMkVsWFVDZFBFK0NjTHl1aS9xZkVOaUNlV3Jmc25zSEM3R3JDcEwrQlRh?=
 =?utf-8?B?OHpoL3NyWW1QL1RNVmo2NXY5VVhqM2VEcEIzZ2dtT3NGcDZ2Q0djR2lEaUtz?=
 =?utf-8?B?R3hwVDRpQVdOK3JhREJyV3Zad1Q0SHhSMXJtOW5QMzIvZW4xbTFsQ3JEL3Zx?=
 =?utf-8?B?ekFTK25pT1l3LzZ3ek1YMVZtYmROS1pVa3ZRM08vMDA5cTN4a00rblp3Tzd1?=
 =?utf-8?B?cHBGUlA5WGlEOVZuaWtqSFdHcHdmUEJZYTJINThsSjlGZDdGL05IaUM4OTFT?=
 =?utf-8?B?TFlSL1BoZm1PdHdVbVUrSjdNSGVVaXZyeUpMdzVRMmJmNEErOGNhc2UwWnVx?=
 =?utf-8?B?SVFPS1V4RmR0WTJsNENEbGR6NFJvOUxhM0VnSnFSZnE0VGZVSFFrVUlCYXV3?=
 =?utf-8?B?S3AvVUxiQWNFYnlBQVBxUGhQcUMxOWpCREx1NU5MSDVYaHBJQzlPbFJMSStH?=
 =?utf-8?B?c0lJVlJNNENSUS9MTTRaMWRtRFJlaCtzNzRmU2JCUGVWNGlOdWxVOG9TYUtl?=
 =?utf-8?B?VHdOT1UrWXZaUFR2M0NkWFFOUlRvY2dFTlZhMWZDcG1CZW1OR0VVNHRlZ2Vl?=
 =?utf-8?B?ZlExdk52Z3oxZ04rT3J2S2hkRnVSQXVBMDBKSHFxS3RkeWRMbnFtWjQ4YkhM?=
 =?utf-8?B?NzBQZ1lEcVovbnJFSmVTR0FCQUhnU1Fzc0Q0Um52V3RnSUpqUStQdkFpR0Vw?=
 =?utf-8?B?YW0xQk5wMEg5WXNRZ25Sa1JMb1dzd3JlWUJpY3lBeFBhTml6eE9lNkJBVjNM?=
 =?utf-8?B?Umpld2dvb1daTFhNT203SzlMZmlVcnV1bG80NXNiQ2dDdk52T2JtRVgxRjJa?=
 =?utf-8?B?YW5OZE9tMm1ydjF2a2xSMkZvSXhhYllmN0wyR2dzVVMxdHlyRGs1YUk2YUdJ?=
 =?utf-8?B?YVZYbGdpZWVzZW5XR3BsNDBkaUw0TmM2a1dHbDFnbkpMQ3oyZnMzbjZCUzBS?=
 =?utf-8?B?c0dhdkppV0trL2x1Rkl0U2dMMVdvaFFvRWYwbzkrUm11QVZTZjcrdjNKdEgw?=
 =?utf-8?B?NlJja3JpbFlhNDRNa2ZkU1FOYnhJSUlXRENJWnlvbm02eG9nNkkzSUVhS0dk?=
 =?utf-8?B?dmhPYUk2eTFJUFQ1aXpHeithbFlPNTA3b0RscUlEWlRSalBseWlVaHVlT2Z1?=
 =?utf-8?B?VEMvb0x2bU1HdDE4TXVMaDVYcTBtQy8zL2pQeExIbTREcDRtQm5rMW5qUVlr?=
 =?utf-8?B?UHJKSS9RNzRYOEFqcjdLcjVTU1lNcTRlVi9UVWk4ZEFGY1dYS3F4ekhWelV4?=
 =?utf-8?B?ZXovdFl3RTV3Q01MNElHMVozelZwd0FwcmU4RjllSmJ3WmN6aWduSFpseFRm?=
 =?utf-8?B?NmNyMjN3Z2NDblBReHNsVEFQQi9HREJ3L21JL2lLdGdlaExwenBKbk5DdzJ6?=
 =?utf-8?B?cDBhWEhIV3p3V2hsM3paR0Q5cFlYQUhRNGpwOWI0UEVLc1ZTSWdJYjBFSGR4?=
 =?utf-8?B?Sll6a1FtZWc0N2tOejkxMWRCZDMrN1NDclNPZzVValhMdGlrQi92RG53bjJ4?=
 =?utf-8?B?MmpJY0J1Y01WbWl0VTFSTUN0TGhDbTFNR2RXQ1QyMmZpNmpUQ2JzbWVaNDZJ?=
 =?utf-8?Q?7pWWApyWLIc1QJONiFtAKyJtLajkNpPgnOlhq?=
X-OriginatorOrg: efficios.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d58e9a39-32ae-415d-b1b5-08dee8d7cab5
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB9175.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2026 16:31:05.0936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4f278736-4ab6-415c-957e-1f55336bd31e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNHNPqwYLYL1xKIrK0VjAskxQipwhoKkYQUEaMyFjWPOuQGUxNycuwsA+uQuXRU0pmQ9xx8tAGq/TpXt3V2i4CSJx2BFNe+HBavdfPOX2CM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT4PR01MB10692
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2D38540003
X-Stat-Signature: oykyr4jaggzriwb71gqkcp937yzg5ojh
X-HE-Tag: 1784824271-723286
X-HE-Meta: U2FsdGVkX1+jsGQMhng52yCw1zDKfNTaMXFMsnoqwJ+P/alwjM48bCLUf9Z2s1IdEdvOSN+m/2Aug04aslcxpojXMRihO52J18uWFmKSExcQDOzeGaKF2qwEvxQkh8yR85cR1HxWxmgXsjGBzaw6d8YeizESo9Vz4ZCuaSZWT+QsPEfZRqfoX1rP3vEfbONSLcxrC2EJpZgavstMDn4ZKaKW/nFR9LHEamEyT5Bi2CurstIQ1SfnSwOeyV8R75WaAwn6wRUkxkBoEEgdnxnQTR57ItWl/4hsbHzluXqfECWY7UCsHJKG2jQuvCCxBOvyBGxhQeoclNaPmVpktb1xwfDg7aIsG7jgG24U0m/pAYI2yk6bT4DodRBAxTD24N9T9YHLJimo3oB0rDp/KQb/pU0jX4RZMhTkZwi25g0B0nHYlKfIpaS4gVhw6rilWZGssKweYAXE8pQl8sAbJsz+100lW+GNlCDy3vzin7EBfxOEp7J7MNGTNVz64IY3XTH5McbNQczYGgZ35853A4Xe5CaxuVzXseQJ8g1/xhmMZrFfSfgSwYjSDc2d+2ask91yx5fpfvT5IZeGZQxG0i65TzDZUdZ8Ir9NQvjZC4NWm9Shd8VF7paVHSB5YyBB2GFWT6MpPTWwjClIth4tb2E7857i6+Pgo1dNhezLV9Pl53wZMq9EQEg9SPpbkJCZJZvj78P6OU26DcPAz3FnRsECQ77F9V2PBfAZYzDTJSzdvkWBF0sbfkneQznxsDZYMq+0lG2L0wDzcNF7S1x5BAZGP1etIFcwpZXKO+tNmaJxmD1jbwHxJi38jBfr75F59WXdCOGsXYi1VjnD599XT84Hi7jsDGVH7JKanrbhpuHqb/uGny+B8z79xLsiu3yxuwK6Ael4JY9ruKbQnUuJO/TP6hNgQOC16HRC5VBM30aSl4IpZCOwk0M1XBGzMUnzFySm/6bzyrIvkYKkaf53trb
 Rhs7Ep2A
 D7WtMBjCZBM8y9UlX6BGcP2CK1KCFpZoZJNCj/I9z/meQE5qu9plVvimit7uQKeEhfiElYTMfo47moC2K1bGszkU15/THeLBSKrKFpRPuo9JAa0SrBX/hY93f7mBu5MIhGuFUiqyNcCe0IreqdaRg7JNrQh0M2c6zECnLBY9bhi300Fqiw8FphQnrk6p2bthyaH93i3/7XsuGPYHxB/DfKqp+A1KSZim2tMBfrW1/ThbV/9mQoOx7W0KRjcdnMsL/7qcIEZtwMGInPSUirllEPfFysurLEa+SPAps+vtP2WbXpGo8u0waM7NT/2Uycf6tMATmdHlpvGArWgdklWxiNTWgZTSlREzjO/cJ/1aDHqXqT6Ezr4yqWEfBaZZqMML9lLZcCCQSCEIMF/iLd486JYPEqQSjqxWT5rZIyHh8V9NIiayQ4hmxiggDWuBbAKcR/6e6zBtb3c/Sy8K1HGyUc+pbbv5O1lgcuXJVsyvzBhz9fdgj+frGnYWynw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-23 12:21, Nirmoy Das wrote:
> Hi Mathieu,
> 
> On 2026-07-23 09:47, Mathieu Desnoyers wrote:
>> Did you compare this with my hierarchical percpu counters series ?
>>
>> https://lore.kernel.org/lkml/20260707131544.75906-1-mathieu.desnoyers@efficios.com/
>>
>> I've sent it to Andrew two weeks ago but have not heard back from him
>> though. My series attack the same issue you are trying to solve without
>> increasing overhead when reading those counters.
> 
> I tested the v20 series on a dual-socket system with 352 CPUs and
> 64 KiB pages.
> 
> On the v7.2-rc4 test kernel without the series, getrusage03 failed
> 10/10:
> 
>    TFAIL: child.children = 270336, expected 307200
> 
> With v20, it also failed 10/10:
> 
>    TFAIL: initial.children = 0, expected 102400
>    TFAIL: child.children = 262144, expected 307200
> 
> In v20, get_mm_hiwater_rss() still calls get_mm_rss(), which uses an
> approximate counter read. The series did not help this test.

Correct, my hierarchical counters keep a approximation there, but is
improves the accuracy of the approximation (worse case inaccuracy
limited by the topology).

What is this test validating ? Does it actually matter for a real-life
use-case, or is it just the test being too strict ?

What is the overhead impact of your change from approximated counter
read to a precise sum on this /proc ABI ?

Thanks,

Mathieu

> 
> Let me know if you want to me to try out something else.
> 
> Thanks,
> Nirmoy


-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com


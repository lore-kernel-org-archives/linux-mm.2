Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E7EC5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 20:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993976B0095; Thu, 20 Aug 2026 16:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944716B009B; Thu, 20 Aug 2026 16:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B0E6B009D; Thu, 20 Aug 2026 16:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5547A6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 16:15:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E47DBC029A
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:15:49 +0000 (UTC)
X-FDA: 85122753618.21.D8E2540
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010013.outbound.protection.outlook.com [52.101.85.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0783E140003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:15:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GG5Bob5r;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787256947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voFEdklFpbDawJGGKFWlvf2S9LJvtsHIzE/SenwYTYc=;
	b=lgsp8RyO2SYBEb1USwClKeaay81m3f2Y8Iha/lCqs2hNiyXx8xCMnqaURITwmH81Uu7KLK
	EMqBvlovZa2nlhBfYtT5dpCrmXyv00B4C+TiJYSY9jbXwgi1vUj+vx/PKxz6vAWPtfSp04
	6RWGgH2mrEnETJcvCi56oAYFjG1EmVM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GG5Bob5r;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787256947;
	b=jaHEWT3kAKbs6bxY59FZV+pwX1AhkOXYfyRV6/Ss2ddkSvqZaft0OmOUuhAWcLHvyCZWQa
	SfxZY8ud0aAjjz+fMV60thrf34d1k+rFAuR+UTE2VqbSxrr7E4g7w8G/0Fdx3FoVuW5+as
	SAJKfW/3DtEpG6CWLLJ0xrq9rrYDUAY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tHAig43/q7UPQZLG4hgTO9o1+GBdgw3PajjCwjnjfyZf3tw7tmpPWNsrTDKW6XykqeaCzoxeCOH8oP6SHM4gTw/KBgKVgQ3LAn6jV9Ao6NqjRnTv97hPBaqxY0uuxHNjdoJ94YJtmWuqA9TLYaf/B5IMksLpsMB+Sfbv/5Dk+zFEfalEumZQ9o1SUa+eoJHWLYHGLnqbkphiuXzIKYMMUXQm6Rp52zhace/sAVHyTsuj6FC3KxLGm4CZCKTQpJoW+6Uxr9l6RNwfACvHUZSjtJUKGszUUoB7FroXAPFQEt6cuy4v/TC4XKE16GWPuso3P/k/fkODpsScm2s5I+D18w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=voFEdklFpbDawJGGKFWlvf2S9LJvtsHIzE/SenwYTYc=;
 b=SJEJLBTsQ4imABka6J/aXG8JFQqNE2C4F0kuuWBqon+FB+HkDZysAuRzsT9gAJCiIG/kJJFJoJKim2Mp++ubYuosXRGb56HZ2G9sD6AY0dJcbm4eyF8mYzis+xuSKjt5Atw3P8ExaChbYW8zt1yN1c5zquByBNkpx+TxaivmWKtx7X+lT1an+RyNw35O6l7NaUAkp7rlR0u+SH0HoHn8qRCn+kVk7pJ09s1Qgrl84Z+qDS4RQZ3LFpwFurpNAYLF5JvYK4uAMzzA7BT7nnncykuHVFSdE/JIrpXtXmYzZ25LvYQVDad5Lv5RLi6nZjQp3WLvPvF/KPkMUJDPzNLfng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=voFEdklFpbDawJGGKFWlvf2S9LJvtsHIzE/SenwYTYc=;
 b=GG5Bob5rj9b7WcvSrbqrf0q6JoUWslvjeHXCxZrcQmOy7kW2pa/QGx6P/NrPTrZaemZBZUe1lNs4b7wEySUtwN6nKRv4Rio27rcTWFUtMkTCvXlvv0hs7Q0KkO3qA+Sii5Sn8AC7nQfKUBeJ/HG2BZv8IWPfhUPf4wd5aaHvK+7gB7Y0jS7mp1dgM5Kd/YgW67bprvF8eJHM+cvL1hOVIWEjD+yZ4bdpRqbJZkSFlP765RWT8MZiGkQZnwW3JooMUK4B7EZ3IKfDmHm+6wdnGor8f12ljZoN/HBRl0h5hPK/mYxgiLkDj7KNHuUnpHHdjAA2IB7a2+lphWXctpmOig==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB7862.namprd12.prod.outlook.com (2603:10b6:510:26d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Thu, 20 Aug
 2026 20:15:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 20:15:31 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Aug 2026 16:15:30 -0400
Message-Id: <DKU1PF6DM6NN.YOF6NN3OWQUF@nvidia.com>
Subject: Re: [PATCH] mm: thp: default defrag mode to defer+madvise
Cc: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Ryan Roberts"
 <ryan.roberts@arm.com>, "Barry Song" <baohua@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Ferran Duarri" <ferran.duarri@me.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260820190825.221308-1-ferran.duarri@me.com>
In-Reply-To: <20260820190825.221308-1-ferran.duarri@me.com>
X-ClientProxiedBy: BL1PR13CA0367.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB7862:EE_
X-MS-Office365-Filtering-Correlation-Id: 42e8229d-e23b-4ccd-4883-08defef7c8ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|56012099006|5023799004|11063799006|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	1zB5FYuc3D5ruxDMYm/UcbfA9fWCCNET/2bOpt9yz1tmwULWQppdRS8cmLDpCbWyRJ9BLPAgfsyBlkVn8GFPDS8ltEIVDspj3CPqto3QcyR5OtifDOPn5IUNOlVED8BaPtml2OIhyKqtOFIXk7xeAU3WezDcSigA2VlKgGvX77gxfgg2Y4bxpksu1LO/3cmm+kybORPqPM47qKuAqlR+CQbKSHfPrIbfcotEtRoGwrZgTv4FfzKJMakx7Rhu6sj2Zfdy0h/18x4+Q8lC1Z4QKTzQ/ke2Kcr05CO34nwVeuRf6Dzf8/eHH3g8P1L/new5do+J5VWoOBVgoyYGJG2MK6Nv9KbCywimWsLuQyhr5kiTO4cTqqHlJne9NRXg5VkkTa0wlLBzdgmQcxHwDZl86AXZwE4fkZ6DCMJWGKSn/nWLRwLFmiGYUQwXF43BGcl/QIudR7r9KtPUuLpGCLXCM3z41JZes3Q5tT62Q5hF3h/kTDHy8/M2aSo81UOa7P8imo5Vg0zNEp0EsxbWOvjVN6vx6yHCW23d6xZ5ZaO0TFD0Pt+aL/0M6JTdmbddihiZIVbcnRY4Sm/dEmDrJeT2VmSdRj8mZjJ2ZfazPjggkJMJkytROf1ci6Sx8gcfwL3lCDN5d8bxB6i2953ySzyubnHQ/IXmQz0DbJHzTUpE1Uc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(56012099006)(5023799004)(11063799006)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anF2ZEZ5TU0xT1N2TDdUekdxQzR5aEMrZk5wckRadkZBeUs1aGNjUEhUTE1n?=
 =?utf-8?B?bmJRMGNRQzlyWFBHdzIwM1QzR2F2cTY2bVVjcWkxRkRIdU9BMFhpbVRtWmNj?=
 =?utf-8?B?clUwVjI1Q21BN2UwVHU4NkVxWlFkMTM0Mkp4RkNWY0ltUlpFTGdSRkVhVHpj?=
 =?utf-8?B?cjlQaU84cFNRRHBZQXp6aFczNEJNOWRvNGRiMXBDU1gwVzdYdkxXOU5wSWhh?=
 =?utf-8?B?RjVRcTgzWDdNUHVEQ0g1M1E4bmRGdmRYa011NFZDVGw5K0N5RVpxaXdlcFlh?=
 =?utf-8?B?V1p1NVlHRysySTA3dlZEc1ZhRVF5am1QWEptNzJCTmp2ekttcUlWT0llejNG?=
 =?utf-8?B?MGRtOG9FNVpIRjcxb0NWRHVuNnpkMFBIVXVyZnBUSWFLNjVjalEvUzlEdk5l?=
 =?utf-8?B?dnBBVlkyVk83WU9kaG1TM2t4amh3YkpxSllsUHN5UVk0dG42QlVxeUs0R0Fs?=
 =?utf-8?B?enFFcnp2b0ZQQXFxdHQ3bEJYM0p0Tk5ERDhQc0w3anBCdzRhVjc3d3Vhc1Js?=
 =?utf-8?B?YlNMdHJ0N3NsbWdKdXh4T2ZpUmFPaGVLbVNaY1RTZjVIWU81Y1k5SUk4R3hq?=
 =?utf-8?B?aFp1NHl3d3VBeGM0Yys5dFNTRjkraENBYm5kbE5Yd3FvVVpYZWtKOXN6cHJk?=
 =?utf-8?B?alByZDRxci9oM0M4aDBTS0p5dkcwa2k1TmNuZFlBdnlWMzl5cEc5K1hoZ0tE?=
 =?utf-8?B?VkZiVkFnd0RtY2V6NnNnekR0VzRSVDRBaGp5b3NZL1p5NlpvNENGU25NOU4x?=
 =?utf-8?B?T2x3cUl0TmwyM1hqb1ZaTmlwMTExN3E3MHZjeCtrSzVjMnQzbnEveTY2T2VY?=
 =?utf-8?B?ZE9sWWNHc0dLUjdEVENWSFVITzcvelRLa29xV3kxcXl4OFEvUVBsbG0vQTY5?=
 =?utf-8?B?Nm5BZSs3ZzhoL3piWFpVQVhhNGdCK0FQRFZ5YmRZeXN2aCt1VUsvZDg1dGVJ?=
 =?utf-8?B?WTg1bGRzekxwT08xZDcvNE5UamI1TGU0V0RTSm1lNkVYRjMwR2VXVFNNNkN2?=
 =?utf-8?B?YVVXajVIb2RxR3VqZ25ObVk1Qy82NzJoL3RNaEJiM1UxVTBpYlBBSVpIbDJZ?=
 =?utf-8?B?SmhXbkoreFo5Sno3S3F2a3FMSCthanIwRFBjcnhMV3luQUJDTC9kemJESzNi?=
 =?utf-8?B?bG9pMVY5ZXIxSUxVTy9McWwxOFhlU05sbUNCQlNMZlJEeEtMTzhWcTV0YUd0?=
 =?utf-8?B?REFFeEtFaXRRckpaQ3Q2YWtPb2c5Uk10VVNCSG1Fa2VpQTkxQmVwRmt0T2ty?=
 =?utf-8?B?N2FuMGptS0JIdGYxYWR2RWpuNWJ4eE9WbklWY3FHQVMxNWhOQVhNN3VuemRZ?=
 =?utf-8?B?ZldIQW1Ua2pWSmFpRWp5QzZoSTY0V0Vsa0p2RU1aTFE0RklMaVBXbFkzTlps?=
 =?utf-8?B?bVN0RXY2STFLNXZJQ3l2QTE4UGxwMndUMUVvamJJdHRVU3NieVNEaXdmaUxJ?=
 =?utf-8?B?enR5SGxOeHhOemJ1dDRJbXNXMCtaalJTcm04amtxOEhRYWFYV0ovSzZ2aHFP?=
 =?utf-8?B?TWJuWm96Y3k4Ulp6TEpaSVZNTDRJM3FTdlNEdnlFemJMYTdlSjRwcjd6WmUy?=
 =?utf-8?B?MkhhVERTVS9BMUhURU1HOXRzVWYrdkVQQlN3T2RFTzZaeEFtMEZKQUlBQU01?=
 =?utf-8?B?MWtHT01UQzh0aDNKNnU2dkYyQ2N0Qi9tS24xT0ZzdDZmZ2doa01ha1RORkU0?=
 =?utf-8?B?elpEaXo5aGxZZXZOUlVzbjdwMVFvSXd5dGsvM2pMeXR1UTZUTHNLYkN3WlZq?=
 =?utf-8?B?eFp2UWl4RFFZditCNjhxb0cxcC9xcnY4VENiNllpNk1RNnZteUNKZ1dPcC94?=
 =?utf-8?B?YWxtYjVibW1ZREFEc2NqUVByVGpWejlFbVMwcmZ6bGZGTlhSdy9XaW9zc0xt?=
 =?utf-8?B?YWdlVGhrYXRZV0tiRXZHb1g0Y0k2NGxibVFBZDQwNkh2Ung2elR0N1cxc2lI?=
 =?utf-8?B?bHMzYnVmb1J5eDRtNEIvdjlvNU5iUFMzWGZZNVBPNi9vNG1yUlNSNTEzKzRR?=
 =?utf-8?B?TFNpd1YxV3V6bGVDRDd5R21ZcmpRaFBkcnNpdG9UUEQxd1VLRTJ4MnljK0NR?=
 =?utf-8?B?dUd1TTFaYXlrWGJPWjRaMWJYWDFXVnUwTjZWNVA5SGJ2YVREcVorbkNwdWxG?=
 =?utf-8?B?dkxVY0hWTmoyZGdrQThHWHVHc3p2ajAzOUV0ZTM0M1drL0lqN1JBaUc1eFov?=
 =?utf-8?B?NG5ZRjYvMDQrNEJWcUw0bmttbEVmaHJzN1hHL2pLS2ZqVDN6STZUN1V0QnVm?=
 =?utf-8?B?RzIrSGJQOVNuUTNSK0NTcnhiRWg2c3pRN3NyL2oycTlCWGpvS0VwODVYTlFu?=
 =?utf-8?Q?ZzxEhqfnb/o1Tzye9u?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e8229d-e23b-4ccd-4883-08defef7c8ce
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 20:15:31.3944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xx8zlYGOrlPld4ns9jAOcyTpbLsuge/xo5p+tAf3yw/xy+tRn9f/tZ15h4vrg14g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7862
X-Stat-Signature: s9zhwkqaa76q3ekguj96wrdmaytkgihj
X-Rspamd-Queue-Id: 0783E140003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787256946-988933
X-HE-Meta: U2FsdGVkX1/TMHxSOkSR71NrHMZ7kCLlhrpVot+yF7sJSK1lwD2mI+ngdbc0Sve6sLdPZ8BN1Pf1piDRarhjYqN1ChwXwcuhkaVF2q7DlQ1aSFyj+CREhuPEMLiEBEL3W0rxt+Wq3mDoGiVjT0KAcwqusQeYTEDieClENBQQISh0P/bjU9vQWxj0vdPI8ItD/Z9eSOpcg7oDXQ5OPlPRSAlFdRgprLQ5CzQwqcBkLg8trKK+5l9VL5HksDF38IJvg9xQPYcJdOVGDYca2/xMmCv3Oa73bfaF8+yrY+7ccg+wetEWloS6l/HsFQ32CO/mvddgI8rH8SOhagkTFpDS8jS0Ul4IJtTh1XBApgFcf8f0etDV3+se7RjfvMiquTnXyz6t8lONu+OY55n0SI3LBkhFbwhbbofqtTMltBpaccBN8EPyWAM36rGnKO1zefCF9LNWViJKSgRXX0GJoFXet82z/V8QSEwIbcT4V/m5cqrVSKM557XC6dZZ2TmY6pHUccdWe7D7d96vI7rjXavehAhzqTz12jXcrzv0eqrFqOM6hAGY0pvbXm7PQySH9pemkpRT9g9uz1M5uogV6J72WlwCrk5eTi4Jmx8vsuAsa/yy9s4807tajsTYyN30hzSgw1HmloHlwz8U36uc2VrS01PeJwD/wTICvWjuvA/w14OeOKIi8OOmf5QipcEAWoq7lfwNzIvs5aNdLkhC+uYs0miXhLgGx9uIQEeCcMHA3DHeMhep1uXI+rq05Sq6K+eeAV+Bgg4X5sEJNP42g5sTb9OONUixx6Wo4l8H1jJ42FAQdux9Bk/luQQX9rT0tqR35ulrOVOWbEl0N7lqm+fBS5xj9ZcfY5wpWM05WpNIIjSW/a3xsdoZjA6ZEFlguowAOKFhSUtA6QJoQrI81j/vfWLYYg8ep3TTAd4k6tp9sHql3kPWsgpmMRySEod6HIyl38PflepX2VrHebGYKr/
 YVz6CtZ5
 EvcIktE36lAnRWjmBIHYecgXxA7tqfpYnBtdd0QL+G18yLmELkyvpyADFmb0qiXXmzswzqeCoizt2u8GgwwDb/DGWI/6BechGmc15Q3fw4eaTGTRNr2uDa++j1kBUT3mRvRvkHgoZk5CY8CVUlATabSOVkYGPLn8CTyjq1IQgShzVRe+W0JZt0Aql7V4HXJ4871zgMyLD7MyuqqLYatfpCQZ6d4s09IcrSHAN0DP5nmxuXr5LbQy29M4mKip4Uc68boSGIZlBWWQ7GaBU37+pY6N83UxrnkmAWfN3R7bBQ8pNWUlYKUtCKfyKkuaA2e8+H08F+TxqQM7Ws6Qxb1FWg1qK8QTGexqZftVfxRo9Hok54ZbVQgvfBnTwcpI2KuLh4BG8/6WMqVmS9Zto5lc2151vFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 3:08 PM EDT, Ferran Duarri wrote:
> transparent_hugepage_flags unconditionally sets
> TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, so the built-in defrag mode
> is always "madvise" regardless of which of CONFIG_TRANSPARENT_HUGEPAGE_
> ALWAYS or _MADVISE was selected. Those Kconfig options choose whether
> THP is applied by default; they do not express a preference about how
> hard the allocator should work to produce a huge page, yet the defrag
> default is pinned as if they did.
>
> In "madvise" mode a fault on a MADV_HUGEPAGE region performs direct
> compaction in the fault path. Paired with transparent_hugepage=3Dmadvise
> that is a bounded cost, since only regions that asked for it are
> affected. Paired with transparent_hugepage=3Dalways every anonymous fault
> becomes eligible, and under memory pressure the faulting thread can
> stall in compaction.
>
> "defer+madvise" keeps the same set of regions eligible for huge pages
> and the same allocation attempt, but on failure it wakes kswapd and
> khugepaged to compact in the background instead of doing it inline. The
> fault proceeds with small pages and the region is collapsed later. This
> is the configuration long recommended to users running THP=3Dalways with
> large anonymous working sets, and it is a strictly weaker stall
> guarantee to make the default.
>
> This changes only the compiled-in default;
> /sys/kernel/mm/transparent_hugepage/defrag continues to accept every
> existing mode, including the current "madvise" behaviour.
>
> No stall measurement is offered with this patch. On the machine that
> prompted it the fault path never reaches direct compaction at all:
> thp_fault_alloc is 60682 against thp_fault_fallback 0, and compact_stall
> is 0, because memory has stayed abundant enough that no huge-page
> allocation has had to fall back. That makes the box unable to testify
> either way, and a number gathered under those conditions would measure
> nothing. The argument above is a correctness one about which knob the
> Kconfig choice is entitled to set, and it should be judged on that.
>
> Signed-off-by: Ferran Duarri <ferran.duarri@me.com>
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b118bcd392cb..749f669cca56 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -63,7 +63,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
=3D
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
>  	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
>  #endif
> -	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG)|
> +	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG)|
>  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
>  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
> =20

+Johannes, since he said Meta heavily rely khugepaged to make good use
of THP, he might give more insight here.

The patch adds additional kswapd/kcompactd work when a system fails to
allocate THP for non madvised THP-eligible memory regions. If the
system's CPU utilization is high, kswapd/kcompactd can take CPU
resrouces from others, right? Performance numbers are needed to justify
this change.

--=20
Best Regards,
Yan, Zi



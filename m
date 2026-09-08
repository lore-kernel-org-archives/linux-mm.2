Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C58B7C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8EF76B0093; Tue,  8 Sep 2026 11:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C673E6B0096; Tue,  8 Sep 2026 11:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FD96B0098; Tue,  8 Sep 2026 11:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D21E6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:26:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CD9F1C1C7E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:26:48 +0000 (UTC)
X-FDA: 85190972496.27.A0DFF23
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010009.outbound.protection.outlook.com [52.101.193.9])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4496EC0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:26:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I3eq4kSK;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788881205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHEdA8P0yg8tiHrhLXuBJesT9FFMp+1krwG4gYhfeQ0=;
	b=KQFckgHr0e5ty8NWWuRRguIS65vIF5ZhRHbRRTGe0vc3iPqpimGNpXdtFvyx9aWkhh6in7
	u9PIwTdUW+knroySoyCWXrb3GblWRUJOF74txM06PUamWvKijHJ8F8VCTUDJHZZ0sGrjBe
	UUfMQU5cN4JyoRyaWoe9G6jJWhzwjv0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788881205;
	b=gnADP4JIfbHjLHAxRMmsz24ovM/zq4xbEj6FBgIVvJ9hwzosW0t05ZxwbxDLSFXp9jiaD+
	X8Yxd/FTXz8U5rKSaeateqBTCqTwFuI+RjRuKbuSWxvhVhVnl+Nmx8vJprVTDCJyWizFKi
	IS8mSDazBfkcawvF1UC+22jwQpoWMbw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=I3eq4kSK;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hQTWCa5OLXDJLzMVQUt7qjJjMykEkhBkffhgEjQOVbfDxbNY6vkFZx8GxWbO5zLTZZLKpATziVZLBcjnwMFp5xqK1WTKSHLpHB3FCffOWqm2ltiWMpameG0WU+rgO5nvhrW4Fc96dQflCKuAzorBjSytIKSfRMOFrch1meII2K2x4aVpOgZtV5KFsgMGqbmznDYvMynlTqQnIqtDDP8S5u1TIcA37FVKumuIuJVqJwZcVHe4zjkzJeztTRqAJw7v3Tdjz6az0agMJqfJ2FYdlDnEkadS1zONyuLPYz+k7ZsE+kFyWO2XFNShTIxlwnq6FQim5ItAwM7DYGGTsF9gHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tHEdA8P0yg8tiHrhLXuBJesT9FFMp+1krwG4gYhfeQ0=;
 b=MNNJAHIpO6deM+XPHxoXbJxiNQYXAxJdyxozbi6NUEjApcqDjChm9y0buOvGZjr14OTUXvjN65H0+Z8AnjkA/2T1dBQQukykTcQzX6cz46bgAs+uzPxXuIxBaCE78A++sSG/dIaugMUqwF0eK3IOhjkVXNqegboUNLWyXjjJKY54uK+PwwA2+lx+u59YBshExqkdAcoUGW9dNnY3kqieTWjPwL8HwITOrQ7T+Ie6XSxc9zfLPkOVSLo9dQ3hPWEjVZTVMA3DHuxlIj+qQKlqTPhKPwZI0NLuZkEhPR+CjzRLCIjkX40SHGjlyo0AaD9SL7KUPMdXSJvLMg34l+am7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tHEdA8P0yg8tiHrhLXuBJesT9FFMp+1krwG4gYhfeQ0=;
 b=I3eq4kSKHSRp9NJd3SEG0f0lEizV+ZMwvJrnKWmIFtsUdRNRXUSkakyd482nZD4bpwubBxHx6kjteSt4W27Ixe+PmPM3KmxeHw+il6XGyc1cjvXXCMgqE05u1XAfbwNuiSu/YddOLz301FjwY5gpIQenN/6e4sV8L1cbqXnWEO6VvOqHS8UnmA0o/tu9oiZ1LBSJy1bCcirlFMtUvgMVnk8GGIThSErnxNjBYTmpp+PFTnvIlnID75oUY5VzVFORgN5GmrrHuXeMN4MVtGKZwHfcmSkywqLvkzCx+S4Y7Im2GTjBhiZvsZRVeV5b7BGz897dkK7z6cBH3ZFVODQJVQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH8PR12MB7351.namprd12.prod.outlook.com (2603:10b6:510:215::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 15:26:39 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 15:26:39 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 11:26:36 -0400
Message-Id: <DLA1GKJG4RGP.3LKH58GGWE4N4@nvidia.com>
Subject: Re: [PATCH v2 2/8] mm/huge_memory: add a comment to the open-coded
 swap entry
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>
To: "Tal Zussman" <tz2294@columbia.edu>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Kairui Song"
 <kasong@tencent.com>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "David
 Hildenbrand" <david@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Rik van Riel" <riel@surriel.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Jann Horn"
 <jannh@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed"
 <yosry@kernel.org>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260908-folio_swap_entry-v2-0-ee6d01dfa5e1@columbia.edu>
 <20260908-folio_swap_entry-v2-2-ee6d01dfa5e1@columbia.edu>
In-Reply-To: <20260908-folio_swap_entry-v2-2-ee6d01dfa5e1@columbia.edu>
X-ClientProxiedBy: YQZPR01CA0189.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH8PR12MB7351:EE_
X-MS-Office365-Filtering-Correlation-Id: 50b9993f-6aa9-41dc-3e19-08df0dbd9392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|4143699003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/RmJG3mWeAb6ksiKtuITRIQeIhUGs5zJcoRy5UH9QJjT3KWm8AwoSGS+iZaUrod8lgJzclKH/qbbQX98ZDn6hzu0werEeIBh6oW9W/lw6KPQPB0LqgtMZymUUwJw+50D2uYCjUpNrnAY6gK7Jq5rh5lvP3lyopbR0zprqSA/oWgHRxtmhQs/3E65TgXBvdYScfmBakq5meDn4d/37IYKysq6IXQC8hPY2c930SfUEgNLvZP552xZ/AT/Hu5aTh1c+Yp/VywR1bX/u7XDm/8TRYzpU/UDBF127RxLe5FY6i9Lsrswb64UrhPWdUwMj0koJ4QF2Sr0LZFUku6SbkWvyM7nBco0ugLAw5Ou/jmTw9m2DuiwQIaYUl3Kzb7Fhgvb+vvsn6cL19nQDjp3DGZDg2rpiDSolavKchGtKYtTHr2RabBB9jow9Jc0IgVxCEnSxa6dYurDQEmKjEesWXAIHDlVcdB931SU9lNPCH2JaIG2ELzxwGmu/p+JsxzpD/6yzm5+ycc6tb2sGpYtwIHonr8DNyenkqDVQ56Sjsmxb3vF5szfpfNyuRdSdDx/4hQS0bsuRnwoSeYqo8TXias0ecHKVN0Jf2Mrp/v6IR0mIoLQvyf1OuhP2dYN0TObrAyFSgsirKglFlPRAxeVcNuOh0ELHcw7hCQ8DLzdrwAEIIRSBaRxPPDjQWXVY5sGKyJsxJZHi3LhJeh+/JeYujkarw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ym02dVNSSWFsQzJlQmo5ZVFzb2kwVndtU1VmUVJ5TGlKMlZOQmV0TlBGQldm?=
 =?utf-8?B?dnJZQXBZSzBSMW1LdGlleFVHbGlUQmdSd0xRVk4wT09ueXNIQUlIbndJM2cv?=
 =?utf-8?B?azFEYlRZY3pUYmN6dUVoQkZXMW11NFFLNEIyYXRJODZBOWp5Q3pUWStraFdl?=
 =?utf-8?B?ZHhpemhRNWowRi9rY21QZldmeDdKS3JBaHVGSSszWXpRMlBMQ2V4T0pBOStz?=
 =?utf-8?B?b0NRcFhkb1RHQkNHa2thWVVJandWUXRWUXRmWXhkeEZ0MFZ2cUMyK1kwUSt3?=
 =?utf-8?B?ek5iZ1BJQ0ZKaHZuelpmcFhYWVlvL0F5bVdzdkZhS1NrWkUzM1hmZ2ZhREor?=
 =?utf-8?B?MENWaXd6SGswVGNHdG9RUVdaaVNrNTY2aHFDZ3BHd0V3RmM4Y3FndmlVT01L?=
 =?utf-8?B?UGFmZ3ZseTdwanNZbmdDOVRwYVdzQi9OcVgxQndMdHRWSEo3RzFxU0hkYitp?=
 =?utf-8?B?ODNZSTlwWWlxcHQvL0ZxNVRmL0EwMWN3b2dsdVRJNThGbDV2a0RvM2VCcW8w?=
 =?utf-8?B?bmphYkduVW4yemhZemdvbktadmw2K1RYYVVYZjVtdmNNbXBHUEhHOElzb3hN?=
 =?utf-8?B?WUoxb2xyeUhkVzRPTER2Um1BSmFQRkZpZDI1Wk5nNmRGaC9SR3NjTE5HYitI?=
 =?utf-8?B?RmpyeUZxZ1h5WTZEOVJCQk9zWHhRSHhWc1pOQmNlMW13UlRaTS94QmVISEdX?=
 =?utf-8?B?cmFhSm9KTUZQbnhGTE1VZWJIUFltdjZrdmNFZm4zOTIvUEwxTFlWb1JUUFRm?=
 =?utf-8?B?bWFOWVNLaFFBam9DNGRJcU5BaU92dDFNVHVEK2RxM3J0WWp3TWR4dyt0cklR?=
 =?utf-8?B?Y2hINGpOdUg1VXVheG1DNVZJZXNhUEZveHhyUnlnMm1WNHZFTlNERzUyenQy?=
 =?utf-8?B?RFlXMXBUcE1xbitmR0prRHRySm81M3lncjZpVFY5WHRJbFh4YUhGNkhZK25X?=
 =?utf-8?B?NVhTOXhGTGo1Mk5vaTZMY09vYjBYc3ZBRklKNVZwL2YwSTRUaGxHTHFaSy9Y?=
 =?utf-8?B?WXZpcHV1UHU0ZHk5bWl3T1V1YlpobUViU3NrckNSREJCT2huTTd6TFRhak9h?=
 =?utf-8?B?M1BOcUg4OWJCYUNXUnc0UTh2MGtzL3hLd1FMQ0dqYnhyRUpMQ3BxaURIVUJL?=
 =?utf-8?B?SHlZVlBySlU5c2srZTNhNko5SFYxQVhOMjQxSG5kam94Tnhwbm44dWhDWW5o?=
 =?utf-8?B?cGlkNG9VT1lib29ab0dDQU91SmNBMVF4amxESC9mS0xLZk9URCs5Zys4SUhW?=
 =?utf-8?B?d2FzQi9LRXNCdWJzcUR6QTRHU1RoWGRIbzdpWVBZZnBNbXlGRW9KdWdKMWs5?=
 =?utf-8?B?Nlk1dWQ0cmt4bEFaY2tqYlJGMmZFSmswcGRaWlMxbU1iMWJtQmlYZUZrV0NS?=
 =?utf-8?B?bjlsOURxR08zdXlyeVY4OTBjc1lLWDN0OGc4SENGTDl5WjhsbjF5SEZINFBN?=
 =?utf-8?B?bWNycEFPSmFDREhLdklpeUYraWpZYVE5SnpubGo4VGo0Z2ZFUnVWbE5LM2sr?=
 =?utf-8?B?eTByQmcyVlVFMXdReGZsMzU3aXFQZ2NoMkgvSkRsejdJNmxzNDdsZ1M1bU11?=
 =?utf-8?B?eDNMODhQTExrUFlpS003MUVndU5IczA1RnQ0ejBEVllqQVBkbXU5blpKQ0tt?=
 =?utf-8?B?MDdkTnZ6aDB4VmRqWjZWNk11aS9VSGxhejJFNEZabUg1T203dHNCVTNDcEds?=
 =?utf-8?B?d21HQjlTSzllL2xiS05kYXFYanhGb1FZQ1BneXdValRwUzN2R3JDRGM0eXlv?=
 =?utf-8?B?VzlFMGlHclhCY3ZBNDVUNmhTQjZYcFREWnljSU5aQkR5SXl6WXRyL2NYRUNr?=
 =?utf-8?B?VG8xUlkvWnc5ZHIyeXp6dnlDYkppbzBOeUNWVXcxVDZsN1VXeUp6aUVWa3hs?=
 =?utf-8?B?dFR2NWQ2VTQrRlErUzBSYTgxaWEvS3lScE1iVVRsSjZUVUQ0WkR5emNrYWxu?=
 =?utf-8?B?SnBkU2FrWTlPbWYvSDAxTjBIZGFMRkp6Q21ZQVBpTW5Ec2RQYkpoaXJTQ2tz?=
 =?utf-8?B?N05EVXlTQzdpTm1OS1BGK0VaWktvZnJML1JWeEF0eG9MTlQ5dUVVeVJ0RzFz?=
 =?utf-8?B?Q1IyQ3A2Z012TlBEWTY3VWRoMnlOWlh4WUdBKys4ZWVHTG5xWk1FYm8wTFBN?=
 =?utf-8?B?NlBrZzB4Sm81NzRNejY0dmdhdmw1YzVLbDNockx1dzZmTzE5WjZKYmlybUoz?=
 =?utf-8?B?TkRtck9zQks1Undzd1ZnUlZpeVhScktBcW12OTFORW84RjR0ZlVGMXo5R1JB?=
 =?utf-8?B?WHBTTTRYRVdvaVJXWnpHR0N3TENJdytocjJTYlJRMmxQZFR5Rkw2Vy9EZWZD?=
 =?utf-8?Q?u1SmP+afSSt+N/N5Rl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b9993f-6aa9-41dc-3e19-08df0dbd9392
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:26:38.7474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tExtuLINP86N8JgbkBWglHM6o0VckITIfs5XMu7njwlQ+tzAU9B8bbkOf2dkydf1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7351
X-Stat-Signature: 9s5kp5xadhj7wg7bf3iufs8n41y1xkzt
X-Rspam-User: 
X-Rspamd-Queue-Id: 4496EC0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1788881205-735561
X-HE-Meta: U2FsdGVkX1/V8Df9DHCPx7wzCM/lqTH9gAk8H9hCLDP+yMEIhfVJHIAh1OfUvOCQR2FqCIVeGE1uuoN4mCqdjnG+ZWhfsrZVsqRSFAmn/uUAAFJZUYaIWLYXUxOIr5UUOmaIJTcmAtFppgeLRvUnj6JHFiXsiSpgbVSR9wbdcN9Gz9RnO3Vo/VKPmwxya4Iu/guk+e1ipOMFU1ybDwFtwt6jV3NDHXsyGmEVCO9Id/spLZ4/xnGaB8pT27Fh6u5H2vQXzT4bLBteqnXRaXsGDEVSTPlU07gg9bt7mi4OgJCg+CmMow4M5jAWvycNzk8i9QkFfQRzBzQNHrWhZAlKfwZRBbJNQprc8XEjLaZj62xOHpjSUCjv4PvKt69VSVgqYPw83IulZSw4OH/nnCmCcRBT+MFKClI5xSWSBl8UMouG6uBiQ/2zNVx+LEPT1wqyMxtQQaspQiciSgDSOaiZ56mqSYu3bVzSFZBaT75CenXT5yUrjabd9n+sL6Bb3HcMRnHdfvVDoG/LAPODmSQg+nBUMBdQb7ApE7j6gfInmMnwVIWQWXBXW59akIklbZ2jG0pz8/Sm5VT9VvLL/7/hIvRPgUVr+lebqqAg/ikwbiwOvPLtGWTi98zGKZQJNRvdDAFxHXWmQnI81CfLXzgc0bk/wKjYumTshSPTXrBG1jXzGmbs8+iOXTjt0X4DhLa+LOLNoSgpwNxd1Qe8Si317ClpvT0ak7clsKmwK+6RrzLufHKx1GR4qZECDaZ2ZTKBAjhY1t3zV2pFzG0YJlHfGaQqE1QpTTrQDSAbMTLOqyhhnd34v7x+CdfihvoUgux0v10QIC5EGWeyOHnFHmPTe0vBQaZ771ofbLerHvlCYob/9p6PYQBr9Yt1MVlE1RXQfec5THk0NUT0EZy2yiQ2K7Cc1eL9BULNBi9ngk3eAYszlM5aT6P20fAHHhyvNyDne8fpELXNNhTOlEBQJqg
 9ZdsfkSN
 1uDvB0qgeAePj2pNqJk8kisoFhKL5gXS6oLBHRF6jLQluJ2QRzaJynntpeqSfc7FP7BhQhQFkwvBrq3sc7+RGgiJOxOKmH07f0H+7GvOnfV14LpHFh8rZzpfhrs6ha/+f7Ws68lW8Rh7OXFdPDOd5ztl5LwTP+uDLZQNI6s2/dXQPqGNzvvcS6Af45iqiSX61+B1Iq14nLLXdewNmjnvDrqX6tboz1fwqE+5G8W9H18dAfxckAeknBsqfCLLliasJU7ygwqovPpqismeCUJMlyYZ1+YAEDI/c5wkPutPmy2bNFCbTZrvTMJMyR6/hCeRqn8pOQwGSf7K2S2q/J2Q6MwaKNsVluWrhezLg2k6loD2M6yQPxWJg6fpzF0AYe5J42EV6uCoAOq0EGmKJcVkOp0d15g6lB9W2RAYMxVbNpsiS7wxHNPqPdfmGVB4x24VSzk2/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 8, 2026 at 11:16 AM EDT, Tal Zussman wrote:
> The swap entry of each new folio in __split_folio_to_order() is
> computed by hand from folio->swap rather than with folio_swap_entry(),
> because the folio's page count is not valid while it is being split.
> Add a comment explaining this.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/huge_memory.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d1ce061601bc..1fabdcbd8c8f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3763,6 +3763,10 @@ static void __split_folio_to_order(struct folio *f=
olio, int old_order,
>  		 */
>  		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
> =20
> +		/*
> +		 * Not all folio fields are valid during a split, so open-code
> +		 * the swap entry rather than using folio_swap_entry().
> +		 */
>  		if (folio_test_swapcache(folio))
>  			new_folio->swap.val =3D folio->swap.val + i;
> =20

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi



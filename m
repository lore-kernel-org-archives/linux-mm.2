Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3CB2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 13:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2AC06B00A9; Wed,  1 Jul 2026 09:33:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADB056B00AB; Wed,  1 Jul 2026 09:33:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5436B00AC; Wed,  1 Jul 2026 09:33:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B13D6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:33:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF8E440347
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:33:18 +0000 (UTC)
X-FDA: 84940299276.08.82761A5
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012040.outbound.protection.outlook.com [52.101.48.40])
	by imf13.hostedemail.com (Postfix) with ESMTP id 17A4F20006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:33:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z2XJIJ2e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782912796;
	b=egiporuwtFmQ5fx05XRYcUCQdxpdpU85Kj34B40Sr+n3tgyB3WTvPHcjMS7T27wVGUYTse
	WWF1nnfXHIGp8IgGL7rKljpW0HtRHTTlzXYyAPO/QmRQ28Pe5/2RrWf5PxWR0k35ZQwby6
	hq8qZSz6uB58xzGSBFSfjzQ5iOTmbDM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782912796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSj/2qjAOV9c7RB7IdN4Cs4cJSWlM5jEBWjk/+7Waas=;
	b=OVqZc7BXlTTjgXHjOpRCkUNRY7P9FaI8G1dhoQh0HDsclzvcA2Ft+vToQasM6yjBAFFJKV
	ITLgyaI+XOyyo+vb0ZiERuoVsn5pc68gL541WZVUqKvg/FWmC2n73JFuRX+rON8X4EJD1t
	eptrg/lBVR3RtGdB+5LXJpmwL+4h/ss=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Z2XJIJ2e;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cx9Q+7vAI7p0khYrrDnXVefjEJfo7wam1/ICcKQpSGxEFZ4iXAaT7DNQ1XeQ/B8DV9Up59OsVpmC9UMMzqFc2oRXq0CwrCvnhS9cjMv4avi1YQXwD3Qi6/EE5L5YaSH6324fllAHv9dQqbYDJyUhX2zHZI6QvR/BkNFyjeJkFz7aYaR6JFG36X7JSI9eIVLjGVYeM1emwyPQRmEaZqzxW+WlXXYWDWjKXyc6uxww3uVslg5XvimKDqcCWowfilkDhScE5b9X1twHRPIl1Qw4sIWM/TRATEzSjqtmbpAdrGlc/HIUytr4NXDSlHY3nsOjyfglTQOr+0TsFuLcxNzX2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSj/2qjAOV9c7RB7IdN4Cs4cJSWlM5jEBWjk/+7Waas=;
 b=xvDRUDes6MIgmvzykz4WaXedyGfDiTdziPhyEpYyWwNfbl9p8O8N9C59Ppv9TWWKoSV9Qt9yTQmoYtGTf07Frk9KQNIxnhk+H+tQ30w5RUThU9x98dwgIkPT7AidLN3AMLlTvYudgrHoi4Cn9kW2a/Fl+CtUMbnKa3i6O4/lisSLMasvklcz8bwfMqMQqO6ViSFI8rdiLyyf/WUPR95ZmnV2FXb6ooa70qcvJVasHqbxkxq8dgMa9pe1JSJHjwVjH+/eQ1/RrWX1VBkU8KVU7wKmTo/gJ6SK839Yi60QAmNARW2DESQKcQRVye0A+FJSEorhUAX1GzwtTXRkNFmrDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSj/2qjAOV9c7RB7IdN4Cs4cJSWlM5jEBWjk/+7Waas=;
 b=Z2XJIJ2enRBSfNwiJQV5yDJaK4wUk/lCBBWoquW3O8+UjLpo89ZfiGGXM92/EbcsUY7J8X5sRVAhof14Kqkd302JaFmqUgtkmZHlMQaR8c5erUudb3JdMax+/7rAcw1XBbVy4fGtBu51Pr2rWorpihXnS6wNRnUhipNjui231mrktLWVbHxGHgedUnDn3gps4WTIjAYPlZ+hLNkjWOc7qmO9DYCgjSKtMO/Hw0yTKjxSZszpzEnQlGoU/4LnJF3MUEbhcSLmH5ie08UQU+NFvdJpxH2z0gZLGBWDSEQqOVCdQyrgcyNuhiFvyZDUQP6ztLj9AL+9JKZv6BI115gvZA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY8PR12MB7489.namprd12.prod.outlook.com (2603:10b6:930:90::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 13:33:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 13:33:08 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 01 Jul 2026 09:33:07 -0400
Message-Id: <DJN9U3JV5OPY.3HVOJNXOAYOO1@nvidia.com>
Subject: Re: [PATCH 4/4] mm/page_alloc: remove set_page_private() in
 prep_compound_tail()
Cc: <akpm@linux-foundation.org>, <vbabka@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <jackmanb@google.com>, <hannes@cmpxchg.org>,
 <ljs@kernel.org>, <baolin.wang@linux.alibaba.com>, <liam@infradead.org>,
 <npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
 <baohua@kernel.org>, <rppt@kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
To: "Lance Yang" <lance.yang@linux.dev>, <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <53edcc9b-e89a-440b-9d12-7142a561878e@kernel.org>
 <20260701122506.77115-1-lance.yang@linux.dev>
In-Reply-To: <20260701122506.77115-1-lance.yang@linux.dev>
X-ClientProxiedBy: BL1P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY8PR12MB7489:EE_
X-MS-Office365-Filtering-Correlation-Id: 292a778f-20d5-40fe-754f-08ded7754a14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|18002099003|22082099003|4143699003|11063799006|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	pceuOFa8Kf9XEMVZuqfOXHM80fBStsX/4TEChr0rdCSPEzSMN/JnKbkMNocP1KNd/s/m75v2LKhHszg66j3oV3vGAUn3aO2nZrXouKjy2RT4PBKmlgZiOWLCcTPqjQvx6/eZFs7KZmgXLD89XRRtjN+qXo23YG5mb/75cSPqjCS9K/PPP9e9YQ8lqFfNQfzD9yQrDvQW/ikJueC6UAA5P7JC7MkuwNOkrQYSWVLOskyLaYknw+hDCro84jiGOAWbVO8xr/zsc0UdZ0S3NRfwQe96XYh6JDmoWXjMEiAeogZoKhfK7trXixMBLRuC/98U/MuInocL2Ev4IHvyhF3O0mCUDhT+PUQVSnyw+q8VIRf9LT2bf6HvimI0Q0samxNVn3pQCxHNvC3jS2G6Vf1KARTePa8BW3pe9ae5idK+LOVyTmAKRaMMANqkaaoY5VUqXZKb2a+eiUhNxobPh1YgHwbgUj0rb6WCszRJqu3oAt5Zt1nMK/FnT2ukh6WdkNoSfZy4CfWqIYnuTUQqE4WnSr480D2Nf00EHNeCiQKmklJgpNkF6KkFLtwyDB2LCWyDrmUWJR0ryE4mxicJyK21x5n2t+zGMUNJDxHGf8HjxCpxkbDc8jBW8x8DNTrThnMjxtXow+xfrKm5pqfBW6Ndm+ULiMdWvghxyw3aq9m3Fdc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(18002099003)(22082099003)(4143699003)(11063799006)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0dWdFhtM0NTWmJpUWo2b1BrMnhrODdjT1RpRko2QTZsMmdqWjNNNWF3SlZk?=
 =?utf-8?B?amt6cS9HSDVYdEhMNXJlWlE5WVZZOTNHZEtIRkV2M0JCd0NZckZyNkZmaWVx?=
 =?utf-8?B?WXRFb2RaVXFjbjN4ZWc3MnowVUluUzE4NzI2dk1EenBaUzFablhwYkRnSDVW?=
 =?utf-8?B?L2hJVWFaUk9GenlyQzlwckdETHI5TWxHMFV1UEVpSHVHTmtzanI2VE1qVjFr?=
 =?utf-8?B?Z25ZdU9Qekx5NmV5ajJMQ2hUVHFSaURSd3AyYmJZVHlnMGw5QUNZSys5eHg5?=
 =?utf-8?B?TnRqbkw0b0YrQzRMM1ZCZmJsL0hjOFBxR2FIUDBXaDZpcGlybzIxeHJpZVA5?=
 =?utf-8?B?akpvWTAxSUpvK1p4akJPbTZzZ2swVVdseVZDeHBDTStVK1Fvb2IxNUNVQy9D?=
 =?utf-8?B?QU5ycUM3Z3hQY3YwUmp4NllyZWdPSzB1RkxpTDZXTlRsK0ZUWlVKMUdaV25j?=
 =?utf-8?B?YjBvVHJQbUV2TEpzeDNTSHRNMm50NTEwR0RRMGYwTUxwY2dKbmdnNkE5Qm04?=
 =?utf-8?B?U080d29LTUk3MXNNcWVZZUU0T2tGS1JKUi84bGFITE9HUzF6Ui9QZ1JzUGxU?=
 =?utf-8?B?RU8xY2RZcUduVjE3bTBIaktsalc4S1VTQmpTR0IvcWRKWVJVaWJYV2dpc0o1?=
 =?utf-8?B?bUp0cWxNd2JuQWJQTnV3czhnOTVHK0dEYkpZbkNhNWV2NlBXV2wzVVUvaGRj?=
 =?utf-8?B?OTEyc3JiMXEwYWlqeU05UUp5ZjQ2aXpFYVZHeEhJR1RQUDNkZXVHU3V6SmRu?=
 =?utf-8?B?aUowVi9qSzBmMjlOL2JYMWJRRUlUQjJZY0J4RlpKS1dUN01GMG93MXV2ZExC?=
 =?utf-8?B?SjZWTWdrL1JyTklPQy80ZGk1aG5hNTV6OXRlMHY3VEFxSzR5dEFwZjFtcmcz?=
 =?utf-8?B?ejRjRzcwMVljbit3djJ5MDhydldlU0kyOFRUdUxQT2x0d0dKYm5IUkNnUFFl?=
 =?utf-8?B?bzJWdVEzUDZqWitUVlJKeDZGVklhQXg2RDRlSVNpVnozOExjbXhsVnVaSTdG?=
 =?utf-8?B?Tll4d3M4SDFVR25UMDhGTGVHOEN4ZE9aNW5TVXdka2ZmMUt0bHQwSDAyamV2?=
 =?utf-8?B?ZmdKaWpWVlFGMHh6Qm05a09USFFFQWt3b3p1cFd0SzBWM3N2ZFBLWGd4cGxL?=
 =?utf-8?B?QlQyR2xQVjMzWjVKTXRxcUNJbmpHUlFldFoyZlkyYXBXaHl3eVFMUm1sRjBH?=
 =?utf-8?B?WDZ3dnk2NFo2cW4rcVBYNmZrK3hWemtXT2JCdzUySDMwNkx0blZGY29PTzQy?=
 =?utf-8?B?bWxIQUtyZUZkMnBvOTZveUFELzdoemhqcnpZZHdkbnlFMVZVcmdnTGdDZHJT?=
 =?utf-8?B?cEtoeldFdElWYktlNm1LSm9SdVpVcWVqZzdoMmVFQ1pwelN3djc4Nlh5U090?=
 =?utf-8?B?c1dtbnI0UDIzS2YzTDNiWWtBUDVram9QdXZwQ29WbzhqT0NEaHA5d0oyYTU0?=
 =?utf-8?B?dWtwUmJNWFVRaUgwRlZSaUR1bHpxdTJUb210RStOeFlmbTluQTNoa21CaHAz?=
 =?utf-8?B?YU0xS29YdUN4dENZZEpuNHVoSFQ2UEdob2h3emdIRG9HaVhYeFhIYkVQODZ1?=
 =?utf-8?B?RkdkUEpNd2sva0I0UTAzaFBna2FQK1YxODRXWUdLRHl2eXpBaG9WdFc5M2Qx?=
 =?utf-8?B?Tk93cGJKSjFLUjQwWEYvbFA2bHp3b0hoczdhU2ZibThEWVdacmxVcjVHNEEw?=
 =?utf-8?B?aTlUN05manVXUUtnOEN2djZzY0hHcThxSzV6aDBHc1JMUWtDUElHRGZJVi9q?=
 =?utf-8?B?NVVLaUJSalNwZnMyUWU2eWRhQy9kTHlaeCtmcnRlbzRxNERnaHcrR1crWEVP?=
 =?utf-8?B?UnQwMjVaVXQzN3JSNURJVWRHM2V4SVV5MFljK2hqQzNNMEZMaVlqWWJTNHFT?=
 =?utf-8?B?djNzMFdGYzgvczVzbURCM0k2QTJoVms1MW9ONWF0SW1NMDQ4MHBSSHROSW1h?=
 =?utf-8?B?Q1ZvREppQ2NvMVJXN0phemhpVGxlQzhtM2U3SnptYkliYWxzMG0rcGFtbDFS?=
 =?utf-8?B?YTgydC93N1lHRXRIOTI3T1FMd2kwZkhxbTJyOEN1dnI4SzJVV2puOGF5d3Ny?=
 =?utf-8?B?OVJyREdxZzhiMGJCUjFyMWZ3UmJGOEptK3l5T1djVmxQMEpPWlNnUFZTa1Nl?=
 =?utf-8?B?WG8yTUVmOG5hNnJGTDFVT05FMFpveDNpRUtFeWJ3UjNONWtGUmNFSHR3YWY2?=
 =?utf-8?B?cXFBOWswTnRxLyswWlduOVRacWROeDEvbFRmZ0t2Y2FIbTBlREZ2aUU5dEo2?=
 =?utf-8?B?c0NCUDhldmRBZEFtY3FFK3AxTVV0MUNWWXRXa2k3MjI5eTAwK3hDRDVyS0dX?=
 =?utf-8?Q?soPakbxRzN/QQGZb6m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292a778f-20d5-40fe-754f-08ded7754a14
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 13:33:08.9199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IfYRhRSoHvf4zRCl1pn1yqAIeHP4XSt+GFJM9YZJk171vij2ZcM/iqjlPH+vxU3Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7489
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 17A4F20006
X-Rspam-User: 
X-Stat-Signature: iusdw4385bk6d6hiibhoz5gpb1ted4pb
X-HE-Tag: 1782912795-794930
X-HE-Meta: U2FsdGVkX18Neu16w3enkXgfibkV7qhOIt9eobIVGJUFAVahkwAwsfHRM0mM4QbwyDX0F5VwfNsTHMX9Q4lcdyVfEbCLAVOX4THiNT6Mn9nfswVpX3V3Jo/bbRCdnoeGI5cj1AEW6G07fzQnPmCp+u7vi3qtUmzKf5u5LnMqwqt+NqxdE0TYcAhk59l0SX0NYiboM8OyWxJYxJUjgpsmU9f/3dZ2Bxaytg4W8qv4fH6IsPeLzxakgqeaRxdDjJxzMvADOAwa/w6XLFcALJ3UR7upbGcl3gpwpHvaWTugAAhqhvgRkdDmvqPjywnoA2ezQihhUOfDiguNSAz0NfQhnczkWsKIELe3wdj0BNP2MnPA0A9VdhWCQQLVB8gjzxa9tU5wyJ4bP/LiHbQumUFaO8J9gUz0++imV1SPBIM5Bs03iij1qCV9jMpnNrBSO1ROWJ/GICjm/xeP+iqGQdgZ0tq0fw0IXcmggyvIRSbYi4hc156Gw1HbX/wpP8NWneqcr8YbUvR+rBSWyxNTQIbuMg9eYHcYDR/I91VDM+jr8ebgttLwy7EC+4+B7NqgNc2XN+7h562ukIuNuHS97vEv5c8ZtGygZdRIlHEYEM22z4yHAjHAX5guMUmvj9u6u72hBn940kh7q52hkfoUSl7k3Si8Rx6cKmcemre3KXcJyys4W1Q/H9KdKt55rfcw7Ozc5rPdk0IsQKgiGDVjqVsl7ed0oW33sUacGNUAqRpckR4FJ6/NB3HOlu+Lgc/blS9qjUNXtvZP/bNdc+DZMIgSVDjCxfeM8eNpYLarr4xAEbRJy3Kl1d8u5iagre0URvRQf+gTfi1V1sJ7zrssj03i2Q8rZMegqZqAo5XDHTITzsOI542io5x+ZWdjKT8DVnIJGBVAYjKOVYLU+xLXL0GyYjHHnJQP2VLZ6dPW7lQMuDSCtXkTIxO0k6BZbvurIKxk7t3jYBrxSxYQ+ZtjkDG
 niQLvhJj
 RObsxdXq8Pog0tgOypNxd4FtkRL89kXkyN/ts7MsCAqcJX3AR8Aw8n6GRp0pwCfXsifxAtCyO/8yUJUhftLvu6+QcOHSKcCHuIwaKx1Hq8/AO8ZCEZznh4RAHqVki75XLAVKWw425/KWy3QkhUPfvQA4YsqpPvZF6mMtXMdZeVJsKb9kgD6JGdVxZCPNgMc34fhyVZLURxLypm5HhjPuzuf39LP2mqIVWw7UU6neOEe/yOGehQOJB8CDWuJ1mFFD62lhL/1KA/AlObU46wJ14QPqbnwj/X4/t6lr+3pgc4iEIKB3BtUBMKLO/VPuuH7EXOKXw6OwUI+56s++7LamchnxZqbNzab/6laoNjkdWhhcmbbhYn8tdJFrXQuKtJ0Cdo1Z5Rkh2xeSuXxYYWzf2zxRoYgMFVCtng0ZFePHdiyMi2TDLXkWlMf3y8t2HUgt+/1af
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 1, 2026 at 8:25 AM EDT, Lance Yang wrote:
>
> On Wed, Jul 01, 2026 at 10:58:21AM +0200, David Hildenbrand (Arm) wrote:
>>On 6/29/26 04:56, Zi Yan wrote:
>>> With the subpage->private =3D=3D 0 check added in a prior commit, any a=
llocated
>>> compound page should not have nonzero subpage->private. Remove the
>
> With Vlastimil's suggestion on patch #03, we still expect tail pages to
> have 0 ->private when freed, but only check it when check_pages_enabled
> is enabled :)
>
>>> unnecessary subpage->private initialization code in compound page
>>> preparation.
>>>=20
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  mm/internal.h | 1 -
>>>  1 file changed, 1 deletion(-)
>>>=20
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index 181e79f1d6a2..c96421ce9350 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -895,7 +895,6 @@ static inline void prep_compound_tail(struct page *=
tail,
>>>  {
>>>  	tail->mapping =3D TAIL_MAPPING;
>>>  	set_compound_head(tail, head, order);
>>> -	set_page_private(tail, 0);
>>
>>Do we want another safety check, maybe another VM_WARN_ON_ONCE?
>
> Right! I think such a check might still be useful. Same old footgun :P
>
> Cheers, Lance

Sure. Will add a VM_WARN_ON_ONCE(tail->private).



--=20
Best Regards,
Yan, Zi



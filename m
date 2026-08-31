Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46B62C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561386B0088; Mon, 31 Aug 2026 13:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539036B008A; Mon, 31 Aug 2026 13:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 401A66B0095; Mon, 31 Aug 2026 13:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1372A6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:09:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97ABD1201AD
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:09:09 +0000 (UTC)
X-FDA: 85162200018.13.66A2345
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012070.outbound.protection.outlook.com [52.101.53.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id C3A3F40009
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:09:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IZ7SuFSU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of noren@nvidia.com designates 52.101.53.70 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788196146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hjF70Ff+A0RbgolhUxiOx/4SU0/qa81iFU3mMsjLVw=;
	b=OmFwNMLTHkmmf5UQTvldqb4G/+ou0Mlb4rgODlkxEdYLiszaJp6QuYdXbB2r1UvmXfMUVl
	u6RTfczLwPntLi8uIlY8jCHWoxsIXoYXznjCvxt2XCUkuqtZs+d9C3LjIE6VMW96O/6taS
	oXi2Ws2XuYSKrO2lPnP3EZMIDJZdyzE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IZ7SuFSU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of noren@nvidia.com designates 52.101.53.70 as permitted sender) smtp.mailfrom=noren@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788196146;
	b=c5zoBJkYYkWlW8BXuaGZ+JEjHoInwtKChMJVI20+QxHw4OLMlI2CWQGmpi9N/BgpjaIpGp
	q8HeWV4YyNVLwMiuRVbd45gNxNJgsrlEyaloFwLUftdJ0EgsnvB+oeT9faeKijZ29Lpg8H
	KcEGY33UKDk6HiYn+grghyPQ7waoqZc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dt+WmW2nw/4CpG80p9EXvrM/bajXTbxmh6C7nLGh1aUwBGo98xdqSH5LMuZUjR+D79BJ5xx5/krrCAw0iZLZm0uQMzmGY8RpmHr08vVIjeWokP3W+nodGH64PaU2lOC/ylQjS2eAOr5VV433RHb9pQg1+hFj9fvjcVHpOv+Og334amh3Jw16OUFvjFYDtmJ6hRk8D7EIDoqVGFJC8RHGB3HwNUNB/HzN+zatZO/lfuA4T1Hu0TLZMpCaIEujvx4iJKf112d62mzVw8pD2b1xcPrbhSItaGQLyH2f+vSUOKC4vhGKiM3c/twPJ/9gs+4Vr8qLFKCWrvVLoVb0j9asvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hjF70Ff+A0RbgolhUxiOx/4SU0/qa81iFU3mMsjLVw=;
 b=q3kNkryJw7Sl7ZKCUbz+P9+Wjd43/JAQmpN9Xs0/sx04l/oaMnoXAEIlvxg5v/mdwcnIKwpUO9WgvbivHan2k3ZWG04xbuAuXoJ7g9EQwW8U3ZisaOVPc/c+BtG+f5uGI3NDT7n5Djiwqi8g8ERcGnfpD/IHKDiZh8ro1oGulKlBUJ0nJqsyEVPYA9UuM3qBn1JSD+4PtXdoMZYAQfXQC1tXHqtrNrky3TDJk6JiJYxk7fhDNR6apnqzc8QnXdmCC15ZQA1xX+l3pDF5965ekgz3DlgxYBoWr//A8lrdzK/I0D92gZGMc9OghACuzXi4xkBhIDlpK4SXD/OMuFYHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hjF70Ff+A0RbgolhUxiOx/4SU0/qa81iFU3mMsjLVw=;
 b=IZ7SuFSUNYfXwXDRcegADWzpkc7GZikzwulW5MQc6RMALs3s/R6moHrvtk8OnLIxFghaeqXmqWBwU1zoqBJNrs2JfcRapuUrbandNhlJ+OhPBQ1YODzAM+j1YbrzcsqNVSEb3VohbIEvK1upO9FqMwzTiRaCAukYQ0KGilRRD3Nq3vuk6EUMKDoN6Xbhn/fPyk/JoIqMU4Q9XncRH/IerLLirN+8qDDFUWzZ0+rrmUEPBeQ/1KhGOYr78aOu6jzjEMFh3S1v1dCDX8AKbfoKqdBpGkoIriLheNWgMMYSH77t2qfHacYXbKENGlYG4Jhgujzqw72hlO7Qe/UllgTHvw==
Received: from MW4PR12MB6802.namprd12.prod.outlook.com (2603:10b6:303:20f::19)
 by IA5PR12MB999323.namprd12.prod.outlook.com (2603:10b6:208:605::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 17:09:03 +0000
Received: from MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587]) by MW4PR12MB6802.namprd12.prod.outlook.com
 ([fe80::51f4:a3d9:b44e:9587%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 17:09:03 +0000
Message-ID: <526f3609-4ffe-4cfa-ad5e-d4e833a4c737@nvidia.com>
Date: Mon, 31 Aug 2026 20:08:53 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at 1
 GiB
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Nirmoy Das <nirmoyd@nvidia.com>,
 Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260831075635.2244437-1-noren@nvidia.com>
 <apVHXmSljK8HrIuA@tiehlicka> <apVKf8FgTG-l2EU_@gremlin>
 <784BE9B6-F891-4DFE-A4C5-D1986CE0F242@nvidia.com> <apWk0GYdNuPcE6zw@lucifer>
Content-Language: en-US
From: Nimrod Oren <noren@nvidia.com>
In-Reply-To: <apWk0GYdNuPcE6zw@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0239.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b2::10) To MW4PR12MB6802.namprd12.prod.outlook.com
 (2603:10b6:303:20f::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR12MB6802:EE_|IA5PR12MB999323:EE_
X-MS-Office365-Filtering-Correlation-Id: 298e92bc-a6ef-4814-6fb2-08df07828eab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|6133799003|4143699003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	0xsM3DKROFlRfi6XS6VCl+lmDLsKdU8mH6kUERuRDM5qhmGOD5pLv4IUwu9EqqFiEjrHaenB4J1LsN2KzWde2XwKb7xmz1U2ssGBkeATDdfoxhgo6y3t3hH+UlDwNoUiMIEMWGOK345ru6i+VKJDs/XDbkdoNap85333tZoqDPEPqefi/SmOZVTJmEwfOPZXFdFVP2qxBQRRPusUJYZ9XCxxluCles/sDU4LBkOj/Sh5xqnuSy0Tq/oz0vLLNogRpxlxCtKeVqRXsMSdtAVASKJnU27A+jvzwl9+2WB+xVu1PJONsiBMF2qx63bia2v3L+rBPznLxx6g5CMBsViQZHZCAqyZYrjahTo2iMGPhhpU7UftSFg/K5gxXk1G0wkTcZQsBSY039t+eEJYlz1hoLDCtiJt7QsPzmBerR5wy3N8nIKSGS6gwW6LNgbib4UtzScVG47ITZRMNhw2JsQbuGcjxRg6/CY7uvrGtdddYWP6CuflCDgFcL8K5xWKs6ulTcf4SH8Zp6U0GGEQ6icV9kesQk6HA/tThNbT/Oq5HlxsbfkQlCdPsoXUIkXXjWKYwnXqaQojhdVsyVrOC2PbMyFt3DHbXe3pyTMfnmfeyVGf7g+8VmCQyyg72joz6e/AHGbu4WA2NslcHCb9QPMDQBGC9QFYWYItkwXi1oyzaxw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR12MB6802.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(6133799003)(4143699003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDdWVVVJdXBHblJXT3p5WTFmNjhhZWl2SFp6dXpGOHNuSDB4SXY0Z20xSHVP?=
 =?utf-8?B?Q09OamVueU1hcERmMWYyeUxmSGVYcVVHMVFuUHBoSG5ncU9vc0RzQjh5VWRD?=
 =?utf-8?B?VDhKVnBacENqWCswOU0yamo4c1VOcCtHWHdDZDZ2L0ZCTHppUUdjNnBqVG5K?=
 =?utf-8?B?Zy90aEt3LzRteHc0VXdpckRvVldVcTJ2WXJKTHB5NmJCdGhBYWZCaGpCNnBH?=
 =?utf-8?B?M1NSdjBYaVF3czU4anV1UHgwWlNKcG5NSlpnNG03Y3g2UFh3aTRGTEtVNFU0?=
 =?utf-8?B?aVlFcVlLdDQ4UW1YcWR5VW1BVlRVYzhRdWY1anRDT3Uwa0UvZWV4OXRzT003?=
 =?utf-8?B?K3R4MEc0NTd4MGROa3JyLzJWeUdaMWRQUWR4Zy9UWlBzc3QzRkJiTjFaNUJi?=
 =?utf-8?B?WFd4VittMW0vcjRFUW1zYmtvSFY3bWhhUFpaVXdkaEl2L3o4akFka3BYYXhL?=
 =?utf-8?B?cTE0dUlVQSttRGs5aURnWFFJZlZsRDBGMlExbUhMVUFBN3BBcDYzVDQvSHlN?=
 =?utf-8?B?YjdSYkYxWFFpTVhRSnBjem51d004WnRxZkVWSUNSZUV0T214ejdMOXptTVNR?=
 =?utf-8?B?dzR6aTlUQStnc2V0NVcvZ1hWTmE2clliNHZFZ2tobmxtRUJ4QmNQeHcvUWx6?=
 =?utf-8?B?elhRYjA3cWl0bGJPTWx2ZlpIQ3drUktnWlY4QkxhZDMyQktBR2hJQThLb2Q0?=
 =?utf-8?B?dG1LbUZxUW51UU1TUCsxdVBMMW44OURkRFgrcG40YnBPM2xHLzhKSFJxQ202?=
 =?utf-8?B?MDM3VTBUcmJKVHYrVXgvY2ZCQzNJeTVxdjRKbTJpL1RsaUdmdE1YcUp3RVJu?=
 =?utf-8?B?U09YVG43S05DTW9nUTJuNm56bkplc21HcUl5WUtnV25rUzNReEVQdC9CSXI0?=
 =?utf-8?B?YTdxRGs1dHZUeUN6MmVvM0lXUVcvdGRES0hiaU05NFN6MGprU2hDYnBMUVA1?=
 =?utf-8?B?bnRLc1VndXhnNk9zNjFaRkwwcTRIYm9LYkkwRlM0T2F3bGhVbDEzL08xNHM3?=
 =?utf-8?B?bngxYm5PWWpVdDNOY2c1Ym9LOW4wbnZrK2ZVN0dkTmdHMWFpbmkrdWR3b1dB?=
 =?utf-8?B?VHVBZWR4Nkl4eWFzNm9NYys5R3dpVE1IOHZOZXZVaUFEQlA4Q21ZSXZwUXll?=
 =?utf-8?B?K1hjaW1aMEZvM2ZKSEo1UGlIYm1VaEt2M1hORFBKUG5XUHBRSGR1alJzZkpy?=
 =?utf-8?B?QnZQZDlzYlJFcmhSOHVMTXJ4Q21hRGk4NVpkQ2tTMS9XZy96emYrVmNWcnE4?=
 =?utf-8?B?VTRtaTFDdVBrR2lWSHVWWWNyNnlOM0RIQitObVNVUmxRcTM1dnBLZ3RGanJw?=
 =?utf-8?B?OXB5NmNLY1JVM0hKQSsrV05FM0F4QWVSM0c5Nzh5MmNXSmVqS0hGTWQwaUZa?=
 =?utf-8?B?T01FRHl1TEYzbDBiMFljMVFCcFRZMHZ3Q0RLbkVlT1ZVREJlZXhRWUtNaUJz?=
 =?utf-8?B?Zjk0UXlDK01yYzZtOU1aSGdiK2RrcDV3YVhLMTFGSGtkeW9jWTBIaWdtSEZE?=
 =?utf-8?B?QXkwNWQwMHJHUi9tSm9lSzBDc0g2a1E5OUpJcnJ5WGxiWEFoTUt2YXVjTlln?=
 =?utf-8?B?QWFPS1VVZnFJZ0xYc1VJMGJRNmRiMTcxN3h4Z1ZneXZkbkUyRksxQmxiZ3Vm?=
 =?utf-8?B?dEhjSGh6Qld6QllhdnMzR3FVT2hRQ0szU2xWMlBqRy9RQks0SjdDd3JWWW9U?=
 =?utf-8?B?MzFIQlYxYnFtR0N6RnYxNXVueWNIL293RnQvSmNwL09nQndMejZpcUV1aXR4?=
 =?utf-8?B?dXFTdFVsSlpMYXpCZitQQlVFYUIyajl6ZHBoaXBDVmhoYUFVSjhBNHRSRnRO?=
 =?utf-8?B?MnA0UW1tbGRmSm1CcDhxSTI5MHUxbkJPdDdKQmVlNG5ObXhHaC9RUTBUQUVQ?=
 =?utf-8?B?bFBud2srdUd6RWlaVEp0a3pHMGcvZHI3N0F1UGZ5Znl3bEdTc0dIVDBJS3Nw?=
 =?utf-8?B?d1p0bzE2Mjhxc2F3dzdhcmNjT25vcUxNWmxNRmo3T0NZZW9UYVN5S1pweDNz?=
 =?utf-8?B?eDdzLzFpWFVNeGE3THBUOUo5Wk1zWFBOWEp2YVUwTFlORUN3ZHBMTVZuak9y?=
 =?utf-8?B?T1EvcDRQM08wbEVLaTczS3I1SE9DZVRDQ21rVFdZakl2MjJheGYrT3VHd1BB?=
 =?utf-8?B?T2p6STVJWHdGYkgwWWY0SERNakRnc1JCOW00ME92WklJZXllVGtuaVgvUWVa?=
 =?utf-8?B?ZmVQZ0xDUlY1RFN5aUZPZkQrdjJ3N3VGOTk0dTZKaDNWVXNLaFladktQRmpO?=
 =?utf-8?B?SHg0WVlhY01KK1J6K1JHNlN5bmViWlFwQWFZYVc5WkhoakkvS2pUem5DV1Jy?=
 =?utf-8?Q?NLtQOVkfhji0cRyKQX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298e92bc-a6ef-4814-6fb2-08df07828eab
X-MS-Exchange-CrossTenant-AuthSource: MW4PR12MB6802.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 17:09:03.4039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B8mhKtr1mOp7WVe3RESkf/RK9OcIbLCmvgrCownLGC6MhJjBfcOfMPuAHuqLVKoTiSh8uHMZhPnF0TYDpB/qXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999323
X-Stat-Signature: xr873kz7us4zb4zjjm5mtnmemg9bpm1c
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3A3F40009
X-Rspam-User: 
X-HE-Tag: 1788196146-477620
X-HE-Meta: U2FsdGVkX1+Sj2QYj4KQK8UN7bJH31iV3OuafaswMLyyBOTS+jrINwRAarhj+9cj0poFZ3eCWWqGYthbyEHnTZY896j3pWcUo0KZMU88WFv5yIEE3/SsR0sXWnUPq7ObC/AVJ6T6ZocYcsVqVgzcrhtvd1loX39mq1TjuP60inT9Jgyivu6SKN6IAw/7zYObroYq9vKvGaWop8fGvmcxJUFBFZsq9oUy1Gigm/5Nr/tu2RVWysD1iyawZVfxS0MNz/uuDJcYlzoWYvnHRSmwAS3v1NwilltDX9MmJEi7wZBD813mR+xcClGFtw5Ml+uxuCRf9sZvii9tb0AXEPBXtr10Gu13+qJYBOg398Lxn2lT9I6GAMUpI9xQ5/E2Ur7E2m6nVx8HeyYEvpKB9bYF5Ts4zfnMCKxuK98CkoM5/WXV3eKcRkvFzos8saEdeXCK/pZA+ApLjyTJ1Ktpi27Sz18/AtzXRPEFHlYj17qE+1s7xhSCkUmWvHe8dcwsNO+4JQxTj26ej6HjBbpudJKh4W1mN6z3BVRhRO9YG1RPW33bUemKuhhmCjPVus6Ek6ZNTpmgkHruSDPD7Km/lntaZGM1MLRu4RgzVBinnfoIL2yZlERnoVxDzo4Rzkcddh6UTvoNDfgkjt4FEu1VqRdr+WFbsATG6BpwuyIY7lhOdmrvgOSQ5CMsJ9FBK8jy28rySlyO4VeASbCq0RvJy40VUq1Ep0sQ9fb5YMBKMBbpzTrEh5iDdTSgsMtfgl5r/T9OERxVQ06n0/OqodjUDdxt8WoDWAEKFeTYsBPS0RIwUSZ3N7rX9u6BALqzcOU5EPDCqUIMWX2i4CA0+bjPgpXIRmYJCjZ1OGTlTqpL9li1F8F10p/xxSFRuuq/Mu7OpNnWPvwJznUceuCLxXj17HGqm1lDuNTnne8PUSmsg/ouUkXVXdnyDINB/GMP6lU6Y8G0FSSwiBybx8KdyJegl+v
 zYeZZf9s
 rg+i9arj3Qen82FXCK/hiAA+Tmq34Twrbh7DhoTsZDLcbmgBR0bpmluxgbVYntCF87oSdk8+LGNqLnJ4Il+ubPavKj0zxS1bctrv+grlcs5aMUb0v+FL9PpVynbHQiWml8FOMDoJ38ZHXX+5pIMLPkogu0CzeSdCON7cOvPYOBRetgufUkBYlUYMoInDspxAnwB0Eg11YFNSmLBilskI/rsMCgLqUqcG7R1hLzG6k2pYkSaMFoDtI4hvF9YkjEmnrQh5N7vqnuaooqq0zCOZwLC1A+llz6gwQ2gYgDsvl28IbvVPdcD6S2bpD936fQShj8F7nE6p2YMhWcn7s6xXTb80h7kSK8kRb4t4qoYIXTzf9LXxAZbMaGCWbHY1izp3uumeYQrcWFcF6Dyhdus+29LWBT8UzgXTPR9U45OEAgHLlfnBC1K3NhJg6H0jEBcLr7ZrXJvGo9E0TTWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/08/2026 18:59, Lorenzo Stoakes (ARM) wrote:
> On Mon, Aug 31, 2026 at 11:00:13AM -0400, Zi Yan wrote:
>> On 31 Aug 2026, at 5:34, Lorenzo Stoakes (ARM) wrote:
>>> On Mon, Aug 31, 2026 at 11:20:30AM +0200, Michal Hocko wrote:
>>>> I would argue that the whole model of increasing min_free_kbytes for THP
>>>> is wrong. This will trigger memory reclaim sooner and make the THP
>>>> availability more likely but this was at times where we didn't have
>>>> pro-active compaction and many changes in the compaction. So is this
>>>> actually needed in general resp. only large pageblocks systems?
>>>
>>> Ohh even better :)
>>>
>>> I did find it strange that we increased accordingly.
>>>
>>> I'm more than happy to see this just die altogether if people agree that's
>>> a sensible way forward...
>>
>> It sounds reasonable to me.
>>
>> My first reaction was that THP generation might be hurt due to fewer
>> free pages. But probably the extra min_free_kbytes just moves reclaim earlier,
>> like Michal said.
>>
>> After removing this automatic min_free_kbytes bump, user can retain the old
>> behavior by setting a higher min_free_kbytes at boot time.
> 
> Nimrod - care to send a patch to just yank this min_free_kbytes change for
> thp out? :)
> 
> This solves your problem another way and is neater overall.

Absolutely :)
Thanks for the suggestion!



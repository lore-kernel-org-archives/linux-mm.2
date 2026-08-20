Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A470C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 19:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 810966B009B; Thu, 20 Aug 2026 15:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C1176B009D; Thu, 20 Aug 2026 15:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689A06B009F; Thu, 20 Aug 2026 15:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D14C6B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 15:56:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5A8614019F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:56:05 +0000 (UTC)
X-FDA: 85122703890.05.160FF92
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012038.outbound.protection.outlook.com [40.93.195.38])
	by imf16.hostedemail.com (Postfix) with ESMTP id E5283180005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 19:56:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MGyZHlRm;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787255763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RSQnotZWtaB/BwrErCR1OGDJ7XMOjpHH9YdngmBfG9Q=;
	b=A5Ik1xqYG80hxZeKl+rO5hMy4EOpUtIgzv0WhI19RPsChbqlc/WrGCiWHQqXB4LdGpy49z
	WZZ625lxNn7XTYPGwnfCBxcl9Mx2YpHDAcENqfGvWASZ9UcQ9xG6ElkpPCuIvJjzV5uES3
	JCvmJqdxx8cbmg7AxWPQdv2eQKgYXHQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787255763;
	b=0iP1LXYP9rPR82kOQ0cKDGVYNBV3Y9sarWxhFQkKQFcy9yaYMaHiGxbGncOWFAOfIxR5Mx
	GrsR5KAuZ7dkpJ6C3AibNcqz8plNEdWmHMnimREiLk6ffXWPdxUBqpgJB31G5BrQpkW2Ke
	/lAmq0nvzFgLuH0f2ikVfwp756EXhzo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=MGyZHlRm;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.38 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cKSIE3TW4kkN4j+v8GGzzUUy1UXrAJ7p6zlvUocFOyVhbX/NT4017tXKj3irbaOJQleLvzj6Tnj/ucvqqiQ9rJOcPbjM2H/qrofFLKlARda9J0ie+SP0HmQ7ebO/YG7rwOPrcPdzplNoY11mh+n8yz9wmOstt2lWBUv9kUtvJ1L9D3ceW7YIjqsPkjpgnHnJezXGBLTm31xH9lBxeCaM2lnhK8cCAFoUnHOLWINKKLvS1IxC0slVeeFfcIZ3rvqjIweapkrZOnblgHbYiOhvw2sVBHSzR+Ivl1r0sUqPpnqRanN47W9L6WfYgmQUbBIKciWSzdvzDXpoqQUytsjXSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RSQnotZWtaB/BwrErCR1OGDJ7XMOjpHH9YdngmBfG9Q=;
 b=XZDg7FX/UD7R14E9OPBBtwZcTut6IEcM7EOxRxf9xH7ih/P6Wl059Dz0VLcvucU8YG1usyzltrQV+M0mCi8eajBodlFgwiJkGiKanszB//oSdyIfLYbxoEw+D34MGmjUSMwqFwmf7A3eym5Td5ahsgbTSfb6vRtprxhNC+JXYUiF/0mo/5xZ3q7V6KwL527VPEiI7697y6qCsgxh9P7zen4QAP00dxWIfvFqN1PN4P7Yunrt2YxwyYz/in/qST4x9gZP0xYIjM+qXkcPpMjKdrFK7LFMFm3iQQuxWNWfwoKuMDkFhQznZosIovxRFd7rsf7zRcByn92xCQ/qEbr1Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RSQnotZWtaB/BwrErCR1OGDJ7XMOjpHH9YdngmBfG9Q=;
 b=MGyZHlRm3mdxZ7eSbeSJiJZRPnSF1/Vx/FB4CXTnx7+p5GOejZuVx3LDHXhNQYVN7Aexs9oEIHOuMq+MsQM1+JK/3ubgeya0cmunJR7ICayteR2vWJEUgQ1yRh5EWjxAKLgCXwa7GJUs0rMOI0iXknN9USkcbzoyEdR6hxXqyHW6meRJdKQOwHlbhJVr6qun92vz1tu6I53QYgFYYB31ilKOFdroB1zsfJAY4PpTTdDZtIRc5N9v9oGd4dLzs4zh+XB1nkUB4l9DmMq8h7oVMmnFT35AQctNeZub/9nmqcqVj4BVrYcW5XG5/PAxAkT4JC4nTeG9DJTBVlPy4HT2NA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB7797.namprd12.prod.outlook.com (2603:10b6:a03:4c5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.9; Thu, 20 Aug
 2026 19:55:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.008; Thu, 20 Aug 2026
 19:55:57 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 20 Aug 2026 15:55:55 -0400
Message-Id: <DKU1AFIKNMNE.2A0JUVSTKHHLC@nvidia.com>
Subject: Re: [PATCH 2/2] kselftest: mm: replace usage of /proc/self/smaps
 for check_huge_xxx() helper
Cc: <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
To: "Yeoreum Yun" <yeoreum.yun@arm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Shuah Khan" <shuah@kernel.org>, "Kevin Brodsky" <kevin.brodsky@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260820-fix_split-v1-0-ab430c58c7cf@arm.com>
 <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
In-Reply-To: <20260820-fix_split-v1-2-ab430c58c7cf@arm.com>
X-ClientProxiedBy: MN0P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:52e::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB7797:EE_
X-MS-Office365-Filtering-Correlation-Id: 802266c8-8b34-48a3-72a1-08defef50d08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|22082099003|18002099003|4143699003|56012099006|6133799003|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	Q3N5r34Py9PhlLVCZQueUXov23wogJFkFH/x6WZZKerbZlmdk23fSVR3B2zOBRfssDjRh2Ict+8KCIA1xuyLuw0tqe88zeYVL7nZRz/CioeQdl1QKWuawdcfE75JyeNNFmewICnbjojnwUge0O3k7KTbouZ3REtYwGPP1jYh+JzW/QyAAXeaiiGPU0SZdlewM+NI8Qkww49Ad3ZOKsuWDR0U74TjynViMATghT0zpcweE2Yg/nGbCPdNHJwbADbZkeORn30NzhE2F9kMsABqlRoSzrOsRMko0I7QQznYocZDQ/lPgRCJx/sIcT8a3jdCuFc+9VMtF2BFarqp68xcTWF9l/Ih/Z98evXBCI+GFFEW4sPxUhVwPyWUTX1tP171MTPXoxPiz79fUcycZSFmDs8MZlAvI390T0IO+kfMPkU4UkUIMdARAlvHb5ACEoLqBGv0IEiEfobHZfVlgNkGabdy7KdPGenf6ZPghnkP70VqcT4pvf7Rx2a+3bKNuNWro/fU0Z8V/AQoZZC90TUVdNWh719ila1zGMYoKb1b4uWsSFombTAoto5BL5CvsvcWBwqyGoWXiExGDF0M2zVpd88TKE2bdHgfe+PPtZ7fiXzYN5FsnMeUGsuMM1zm8/ZIhPfRU8kqCvbkxwY8K9JOcIQSlTGWZjg7wd7Q1NiMf/2fmNWlRIU4CoOttRSPvfUAYfQA9GpeWqNKU3ONReQqjg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(4143699003)(56012099006)(6133799003)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWRyR292NkZ6SnhmcGJXOWFvbEh0djd2eEJabUJLZVBTMzNWNHFXUVBjNHNs?=
 =?utf-8?B?SkM4MDFMQUtrRmc0T2lOU3JlQTlJYy9DUXU4bmtsTnFaNnQ1cVlkUi9QUFFV?=
 =?utf-8?B?Zk83dUZtVG1ZWWJ3Nkh0TTJhVlQvTys3dk52MDlmdW5qREpaeW9va0szQ1R1?=
 =?utf-8?B?RE44NFBZUW83MlZUSmdRWVl1UHdIMzBJbVFIblg0b1dsTXVBYkVWb3NxQm5O?=
 =?utf-8?B?S2F4REZ1a2Rkd2NTR0I5VDlDUnkyOEZZVFYraWxBaWZkMkVoY21jMCtpcHdI?=
 =?utf-8?B?L3FMdnFGRi9XbUxXUkRHWm5KMm92M2VVdGpHVk5CNmRGQnJkblEwdDV2UFdr?=
 =?utf-8?B?eDVhWUdiN050N3FZc2p3WTY0S1gvVjdFY0JJSmMwdGoyT05mMEFwcjdDNEIy?=
 =?utf-8?B?b1BFNVNsam5Namx5ckF0Q3BRV0xWb0I5b1ptOThVYUxuenpOdko0TTZMN3Nz?=
 =?utf-8?B?dWtka1puelhMTGt6eGx4V0p4QXRWTm9Gd0pud1drNHk0bmRHOUJZRExORFg0?=
 =?utf-8?B?cEJVREx4b0drU3lPaVE0NEdoQTJaVzZJYlcwdzRabDJZYldpM2krTjJxUWlz?=
 =?utf-8?B?QzNpZEM3RFA5MUVDbzl6M2VkdTF0NXE3bnlBRStBdTZ6T0JmMTQ4b1d2a1Ey?=
 =?utf-8?B?TkxuRjUvR0hXZzFDS3RoRzh1RSsvWHp5dFVqYW1wNkVpbnFDcHlGVHdWTDVy?=
 =?utf-8?B?alVZM29MQWVXbnRVZGIycVBuMmQrU083R0Rjbm9zcEdobkwvUnVlVFBIaUs3?=
 =?utf-8?B?bWh3RWFLM0IvYlZma2xkcjlVeVZhenNsd01tNHJvSlkvbDJkT3N3dVh5OStD?=
 =?utf-8?B?cWxQL2N1aHVkRDI1NStCdHhrZmJ3T0pmUWJOaEFFSlJEQVJZbWN3cHZHVCsx?=
 =?utf-8?B?b0RvNmUzcWxOU1NNQTBsbFN3dlZFSHA4a3dGN0cxWndXd05GOE9qZHN4NHNi?=
 =?utf-8?B?RlYxQ2VCTWF0Y3U0dU5ybEprY2g3bUQxNTIwTSs3VkcrdEFnTDNwZ2NOOHhP?=
 =?utf-8?B?S3FYMnVaaFR6b29wM2RrV051Yi9KUlJMbERPVmV2cW55eFdZQldpd1AxMTdm?=
 =?utf-8?B?SklmMkNVRzZwdnVlWk1FNGNqNjkvOWZ1UmZPK2s3YlY3R3QrTU9mb29Da0x4?=
 =?utf-8?B?NXRhYmhjeHp2S3JpR21uZzdBQXFpWjdQVmVZcEJtTjkveHp1Z3U3Zk9xNklG?=
 =?utf-8?B?cDJJRmFqT1RzT01xaFRzemVvUUxFQktPTFl0eFAxS1hQeEZtcm1ZeFg2WnE1?=
 =?utf-8?B?aEF1MGRWaE04aEl1ZWErNHlOQnVlNldjYlBBMUJSMEZOUXU1VkdWSlZpTDUy?=
 =?utf-8?B?aEJzdG82SlQrZ3lQUjU4bUkxRncxSTNFY001Q2VQTG40SkhYNHI3YTRXVnJ0?=
 =?utf-8?B?SkdyaDd3b2ZxWUxKdm1nZzN2WUVVVVNjU1hxL2ZGWlVOYUthRXpMeG12Uzl6?=
 =?utf-8?B?WSsvR0lPclFzbjZBUmRVN1ZIQUhWZmRibExxNXBaeGtYYXcraHJSNng0TVhx?=
 =?utf-8?B?dHRGY1I2MzNSNWswSG5JU2IrVW4zQW9reC82dUZIL0NLQ1BjR0FlcGJ6MUcv?=
 =?utf-8?B?ZjNmOHpEZkZWWm93MG9vVTErcFZ4STJFbHhscmN2bTBCN2ZyTys4NFhVSzR0?=
 =?utf-8?B?dW1kZlpsdUhSd1JJQ2VPWVovWkVXZ2lDSUxZM29LaHpYNzMrREd1REhMcENT?=
 =?utf-8?B?Tis3eDRlWmluQmNkNFlRR2RqTldNS0tIRDl2YUNmeUVodmYvSDVXWG4zMVFF?=
 =?utf-8?B?Q2J1UTJLdFZoZktWTXpMQkJ4eXpnT0plUGUvN1hCZUxMdjZLeHpaYlhyZmtn?=
 =?utf-8?B?eDhVbGpsYXE2elA0MFlVbmFwR3ZBZ0JRZXBKNVh4NU11d2xHRGEzcENObEpw?=
 =?utf-8?B?TVlwbHY0WWRaL1BNUXNRNjNzeVp1UXRFMnVISGNFMks4dXhmZG5BYWRhdUxH?=
 =?utf-8?B?VlJxbU5zbEV4bGZIcVoyMDlIVW5SaGZoL0lzVmJyMC9FbUJmWmRQT3NMdG9L?=
 =?utf-8?B?YnZIWHEvOEhtZXNxV0lMQXMrdWxyVE0vY3VrbEVJcm9uRWJGcUxjQXZrR1k3?=
 =?utf-8?B?bUV2SnZJYkNyLzYzYThrMVM2b0JIMm1sWWZ0S1hBSXBiVmFlZnhneTN6bmY3?=
 =?utf-8?B?SzMrYWhYL1hMWDM3MVV4Q3RlejFnYytqZ2FDL09zWEJNV1M4aExIM0FocU9X?=
 =?utf-8?B?ei8rbUZQcjF3VmJyNlMzU0tLUWRRWWRTQXZkeW5tMWdxdjRRL0tVOTFwTEcv?=
 =?utf-8?B?dnpRV1ViMUtYdTlaWTdNNnlGRUNnNDc5NG9paWpLemFDbTZyRlFMR0JYenBB?=
 =?utf-8?Q?InefA3Xfy3euzEgLl0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802266c8-8b34-48a3-72a1-08defef50d08
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2026 19:55:57.3401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fq6s46KNa/bbTSSe+ABWCbFwf8JhQdXFrDkEb2StdqGWQpUoNlzBVjnvHI/Ko9Vb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7797
X-Rspam-User: 
X-Stat-Signature: ebt19wegdgs4jik3nenndo6sat7x49wz
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E5283180005
X-HE-Tag: 1787255762-621965
X-HE-Meta: U2FsdGVkX18NjBN83jciEITaOp7d8BPuailfVlu+PoBeXgB4osBSwd0J7u8A6PUu2JyuQiQ2oZjsQWmC0OaAfCvnxGbBQXP0hWUPfK3SRbAxhMO2McNwmmaUNVzDkcfZlZDFy0CrjV6+9w58WeffE+yLkQUv+PjXBU5LMTDCdpOyb811SvO0CwgBAoXRQwwcFblXSG+1KFZiEhLLfWpeFiXJDjCKIAcXBRwaDuwsg5kUbIAmKW3g8MpRGr9+8rLi+EXUA/VquTPlWyHzaNmnJLYVKcd9LXN9IinfUj4pUgNz1VinXGJ6FqzLYeO1rpks/KgZmbkKiP+veDGCLQ4Y1BoQh8Abqyx4YsxBoXUPdsS7hRnob0H+QpVvUMQafNRaTf+gw8lWfEPtnZekJwVUYM5ESsGWZiQAQkjyG2VAeS4bbe+cWLNGHlli3tJB5ISC78lVfSWWzV+eu/CFz9IEXI3CQSOiJPnwh7XDK1U6sB/znH8zzHnSB1SVs0igeqtMG3tneSVgLe6GsFz39X+zRO0A4wrOnyLVCohvWfoXhTb9IJduIOFtuKauhaLg3m3+E6nj0ejTI5HakiGBzJh9QdI9c7jHP+YkWGDoquzTeUT1VGLO/fygWdvGWD8kwngjRNF6IOZpVUFnaSljRjZ3ZwujO3uNBsKRW93mNEaCwYs/UCkvYtkwRT07GYXJp84H3iDFU10Xy3GGDUrniZ8dEelMrhEeZHLaAs8+KdbG+P4QJnjbU1rF5pZyilf7lKaIOEyf34dyobZDCqOkB9vo72QKmzKvESNt0TenTYJ5z5aNRx9lwObri8PkV0/Ge7blzZntJl70wCT38C3xi/PRNmsiwaDeP0+blH9L1YZjcTzJOTkvwP+XOT3Bwwv9W1kK/fc1hQxz9vfJzGa2On8BEy3XYUFz5CIWqwbYxrG+e4UapagcqRG+1i8G8OER1nmcc1ZkjuITZ8sUa5qauRc
 WC7ReXl6
 98g2fBLt29cxZKKQHfzkobGcpw1CJsIS/hlqGeKwSefGQxEVaq+sXGy8vBmV0DtizV17kSEt3iGGu8ypU+8NNuAES10pkGIrh8BsbCMlr2ktC9OY0YP7x8o3PYBwZ2ZgarwetDwB5jVMB3w4CyGsoec0Sz5Bx084cBQXUIgvc/Nf9PtqFmYKGpcq3GgqId2s8SFdmoCZ/xgLRurq8uwvtLsmtYpy9EerP32Wsfwm+pg8kAKdrvR62xtzZmSzq4me61Vmp7tpTP9kCgVPmurU8ELT9PxOSXRIWKpjbqod49MXMz080RTODBMqm51HLUZDKW4QwO+i6D5yhI50oPGGujfqKUpvWM2Ym7FNRkuVqeDeZ3iV+wmvkbNjEF04mjrEi7ODztbj8LchQ+/FgZ8dy+IfK+T044ncj9nnTgRqMAMp/OZWrphUqIGzhfGsCr99y9DCGu1VX59/KAhd99Z86RXReXc5JRNG8cbT3xnFyPptavzXNCw9NbIYB4WSfCrgr20flzT01yrcd82B6OYO80Eu8uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 20, 2026 at 3:40 PM EDT, Yeoreum Yun wrote:
> Since glibc commit 321e1fc73f (=E2=80=9Cmalloc: Enable 2MB THP by default=
 on AArch64=E2=80=9D),
> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
> made by memalign().
>
> The underlying VMA may start at a different address from the aligned
> address returned by memalign(). Furthermore, a subsequent
> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
> already set.
>
> This causes split_huge_page_test to fail because the check_huge_xxx()
> helpers incorrectly require the address returned by memalign() to
> match the VMA start address reported in /proc/self/smaps.
>
> Fix this by using /proc/self/pagemap and /proc/kpageflags instead of
> /proc/self/smaps to detect huge pages and change the meaning of
> check_huge_xxx()'s nr_hpages argument:

Have you checked Baolin's patches[1] in mm-new? They resue
gather_after_split_folio_orders() to reimplement check_huge_xxx(), also
based on pagemap and kpageflags. Does it fix the issue?

[1] https://lore.kernel.org/all/cover.1785985999.git.baolin.wang@linux.alib=
aba.com/

>
>   - nr_hpages > 0: check all of pages in the range are huge page.
>   - nr_hpages < 0: check all of pages in the range are not huge page.
>   - nr_hpages =3D=3D 0: invalid.
>
> Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c           |  26 ++---
>  tools/testing/selftests/mm/split_huge_page_test.c |   6 +-
>  tools/testing/selftests/mm/vm_util.c              | 135 ++++++++++++++++=
++----
>  tools/testing/selftests/mm/vm_util.h              |   1 +
>  4 files changed, 131 insertions(+), 37 deletions(-)
>


--=20
Best Regards,
Yan, Zi



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E677C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A056B00A2; Mon,  3 Aug 2026 12:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CAD36B00A3; Mon,  3 Aug 2026 12:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 192786B00A4; Mon,  3 Aug 2026 12:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3BE36B00A2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:56:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77711120758
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:56:47 +0000 (UTC)
X-FDA: 85060562454.24.8118ABA
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A4F31C0006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:56:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WmnTFywc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785776204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRnY5tNaG/4K6dlwwkSnxbPqAghp1PbId++hkByIeAc=;
	b=Mu+1o5UilQUmMPwXrN4ytSmuYUQ/eAks3chQkxgXOOrO/q74t0F9dyDXc5Nlw2LIRutnbC
	PpUGTRbdiyZsPwVR5FHRlRJ31vAmQnIuj+THuh1TgoPbv/oW1ghZvje+zr413joFi/jAC9
	Cu0KE67ACx1tIWrzrwKmAx6UsF8XASk=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WmnTFywc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785776204;
	b=0I+olp18nRaXeISldMO3vfDQkjWtYDRJYWYoTczzO5AguHqZHqGhgK6ZbCykgfgifFOBSR
	zpu0dx3mgUVmBiAdaOjL0O9hnB3ZFsb3cZlfyOhVEwaCZGVVvyTTQ28stwGhbx2fY+ZoNJ
	H9Yj0fRfDFsXfYhp4awZ3gEHRJSAih4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nZ1aJIeCeXj87wJpD8o26XuofOQQT7aY6ORXc+WqCGuRqLuwK1gqhgZv2R8kzDHxroJpnlK/biTNoh7nRwheDS9DHnahYZyMjDlt0gay9T7k+pHRT8ULs+Dj0x+20k+XoKzLVSO5CttRMLrxf/EqXI2uc3IytQ4jzz9eI4OMC/2LNHUqape2e+YBKN9zlA7SvZ1wU6G6YiqppqnGtFCdKCnFQnEXegW9Pga9W1GH+W26LUClKkMn/YbuYG/a9c4LFwDBJ3aHbfF82LH59EGTPYD5qgemi73lheWMKgEpV19vi3jVgognko1CfzoJrQhWyFldvQyLXntogVNb+HWdiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FRnY5tNaG/4K6dlwwkSnxbPqAghp1PbId++hkByIeAc=;
 b=Kb8tVH++MK18ENDM0CLQnPrp4HgyAWFmQQuDpiI/+5DyCXTTsuvGFgDjbb2cZNlh3Kf3Ddxt2qfQowrMZucfsiKjogT06qCsf6c2T5Te759rHkY9XXmQtPyoTlNtPxTPasQGbFAMZc06h1CF4A0FMSitSGRBi/aIi3VRhvwFo7BIxFePBrW8skmF+7nAONgls0straQHK8VBpScpPiSEiiiMtEZNNP/YCvD1bov+Il4t751fFvauYCe3oFv4v3R8EE5dKJQHmh/TNRjUgDy+hoAmFPGB85fYado1PUUFyZat6xNHsXSWcfqd/qmAmULIoIarxcUqmRIk8JgoK2qtKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FRnY5tNaG/4K6dlwwkSnxbPqAghp1PbId++hkByIeAc=;
 b=WmnTFywc3df5N500P8K1ExxnDjZazTSOIIQrbb8g7DzLXy6VmLkRTHUDWXe7LPT41RjX+lTw9Tw0el95Pr1efsi2NcoC+7EyoDzDAZ8ALVc7XgaZWfE9cyKkum7vMkLXHKvlmfDTw1fscJhqeDkoklFk/rY9A3Xq6x8clRgyADP0aynIfE6EgB+En6Srhq0QjoEZJTF3r+298Y1ZMUvv5oG1qsA2U9nGK7ARjsN3ltl6M9whjyBafTnO7iGwVo4bTbS3M6pzo9mW2ganTmnAqyx6P+wvBRc6FrXLDGUlKovXBIeK8fPMLDxTr8Qt4JuvIJXmqxVE/6oQlFWzB/+8iA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB8790.namprd12.prod.outlook.com (2603:10b6:806:34b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 16:56:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 16:56:38 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Aug 2026 12:56:36 -0400
Message-Id: <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
To: "Jan Kara" <jack@suse.cz>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Gao Xiang" <xiang@kernel.org>, "Chao Yu"
 <chao@kernel.org>, "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu"
 <jefflexu@linux.alibaba.com>, "Sandeep Dhavale" <dhavale@google.com>,
 "Hongbo Li" <hongbohbli@tencent.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 <linux-erofs@lists.ozlabs.org>, <linux-fsdevel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
In-Reply-To: <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
X-ClientProxiedBy: MN2PR15CA0059.namprd15.prod.outlook.com
 (2603:10b6:208:237::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB8790:EE_
X-MS-Office365-Filtering-Correlation-Id: cfadc822-731c-4681-de73-08def1802edd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|6133799003|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	uMjPbOOz5zQTWODeOf5ICSmQN62AZmERr7frXnmE50AcwkQRQLfnWQoSvN0D2Yq6+nNl5gYpw3zgGNKuIOt+BdFgkI8Lk+v3BjjopGa95k5HEWMLcid7bm+yxEeVlB1xdHMzKGJvgxebBXXQzTp2Fe5sljDnOZZd8932C7t8b6TWdl2CEq729nZ87SLmRYVKPdTQFLyN48Ixuw5rQ3uNS0N/CsuFzcqlgVzrBzFrKfcefPprTqc4nnLCp9WQxyzEQ5d5zHMs4VepPieDS/I5n9869bEa/TPET25OTI3eTisFa6+GUins7lYP74l0jNjLgJARlDxl/F0PSYzDAqnDvE3lwdGLQiWAovKITJZ5NOpr1v+rPpTRf2rxDsR2BJVdOrKp2ZBKtUtQ3kbXXb4OpXJSb6Z7Gkeq403H1Ey4LSR7s+hEMwSoHOJUngsLJ+HjC4QXBGh67vCrQM8jyMH4F2mKIMHcawbnH2SmWJbb9ZN4Z3f/oo5yAKMl4kYcl1+LuW+tkauz9raQSaOrFCR530FLEopXfNeCi+yOQ/YuVk1Ts+OQTDR7QHXwXM8CfiG4CakXQPlRA03FSIvVM4Fupp3jkEz1PgcxQ8A4+64l+ko53Gx4/JfFkDJunKwD0KIGF7NsLqglTj3cFblplku5u14O1po7arLjUfq/pd8hcM0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SVljM2IxZzlnbjRPdjFLN2ZQbHN6QldmMlV2NGZDNXdYNEdvSkJSRUVITmo0?=
 =?utf-8?B?akRoN3BwZzlqOHEzN0J3NE5aVlBoVjdRWElucTEycVVsWUQwWVVOQmdQaERu?=
 =?utf-8?B?K0dTMEFDamdLWnE4K3FYSm4zMDFHank3SlpxNkNjb3Q5bjZ4cUNkVVdGRW4z?=
 =?utf-8?B?Um1yNWlzODZtaXM5NjdsNFZwRVdlK3IxV0RmSzlXUmxqdlNpL05hczRZQ1gz?=
 =?utf-8?B?Nm0xQ0p2cEIrS3QxaDE2REFZWE9HaXdTVC8wTlgxcFhiMVpSWnZXL1FwTkJ4?=
 =?utf-8?B?Ni9kUnhEZkxZWGFyRGpjMU40TUc3SDhYd2JJY0t2NkovVUU1M3RUSTVXNU5y?=
 =?utf-8?B?cUY1Y0JRZjZ5ZFBrY29TTnFiNlpvMVVQNDQ5UWJ3cERlSHZFamI5NjVGRVp6?=
 =?utf-8?B?Mk5qdkJReENkVENnejNtLzdRdUJTWUxZbjlVVXFMNjYyaUE0YmwxY2c2UVNI?=
 =?utf-8?B?cUk0aEF2Q3JGeWQrRWkrK1ZCcm1lVXdKRnlYWjhQQ3MrbTA5WENmbnl3Zno4?=
 =?utf-8?B?UmJWVTN4UjJHTWxOMFoxQzg5R1BSVHk0NlhHWC91L3NtbjJjVlYyalhJNEpp?=
 =?utf-8?B?cDNuaGZnYjBlYUN4anoyeGRGRUdHdVlRNU1RMDJHTG9IVndjMkttU1BSMDlp?=
 =?utf-8?B?K0MxeEE2emNIa29UTlR5VzF4ZkE1R2VvdUxDa2Q2VHR5b2RvNjNpQkoxbUhO?=
 =?utf-8?B?SWFLQStxOVhhR2ZxSnJ0clh5eHFSc1NweUplK3N6bDZDRTRPYUxXcitwYTcw?=
 =?utf-8?B?aUl2azhwQldEWi8yOFJDYmF2ZjJsVFpzRlQ3Z25BWUJXQ2R3eTdOaEN1U0xu?=
 =?utf-8?B?TTMvNEJnMHI2OTc1enFCdFlqTmJBRW55QVRzZXA1NDdyeUhKNyt0UnZjMUkv?=
 =?utf-8?B?SkxZaXo0ZTJacGkvZmtSUUVuTzhPOXFRTCtDbW9YVG5YRlF0QSsrWUYvaDUv?=
 =?utf-8?B?akFydmx4MmY0anV2ZnZEZzZjNTJaMG16VmdmbkNlNzhGY2lhTXI2aTIrN2FP?=
 =?utf-8?B?NGgwbWtLeFBhZENZQ1RXTy9ESHVMcDExM0V4a2NLdmpyU294aTlKV2dNaHZC?=
 =?utf-8?B?OXJLZE1HSVFLVlpvajByeVd2WjFqNEpRdjI5aVc4YVgwUFlpeWIyRjgvdUlx?=
 =?utf-8?B?UDI2b25ONXhUaWNKMjE5Rm5kdzNjSEt6dWdqK0gzUDhucGFhQlJIRHJGN0hN?=
 =?utf-8?B?cUIzcXV4OFpCM1Q3MjUySW5XY01IZk9pU056Vm5Ra0ZkRW9WNU1hZzJHVXFz?=
 =?utf-8?B?TVhKT2NxcE9pMkpwSVBpcUN6SFRyRGdVemVEa3dnVUFIam9yZUJOaG5lRjVN?=
 =?utf-8?B?TU5YU2dCdTJPRFNiRVRZL1hiSU9lNTEySk5iMlF2M2FaRkFMdk41c2pqaGRi?=
 =?utf-8?B?S1EvMTVYYXBySzVtdHJjRjBVQzB4dktpNGcwajV1ajVsdHRVWm5kU1FjNUlH?=
 =?utf-8?B?REJQbit3K1RpQy9NeXN2OHBmMjdTTERmTUlOUmZMdjAwLzRIbUxUbzNMN09P?=
 =?utf-8?B?R1owcVpxRzAxUmdzQXJFa1ZVZGV6NWZ4ZzRhbHFVR0lwM3pHMXh0cGFFNFFn?=
 =?utf-8?B?UUk1elBkbE54cU1CYkdNYlNXYjFoYXhlcW83Z1E2RjFYd0RDNTJRbUxYYm5m?=
 =?utf-8?B?SFZzc0RtNEVTNDJzUDNOdjB4WVRRSXVYZkpMWDRQR2tXVTNuWlVWODNoOEJ0?=
 =?utf-8?B?QnlwRXRNNVlTcGdDZlFRbDNiOVBoeXpjMDg5bFUyd3hBYnRwelBxcWJ3WHVR?=
 =?utf-8?B?SG0vY3RCVzhsU08ya0k3aWIvMlNvWEhqTDdTVTZYSXpLRWpZbmhBZWsrMVJo?=
 =?utf-8?B?T2xES2tyVnQwb3p5anhOR25JdlYvSUlDaWl2K0dZTWcrQVdMb1VCNGJXdkhO?=
 =?utf-8?B?RG16RFVWVDc4N0U1NnFUU2hMdjBFeG1mWmJadHVNaTc5blVKU0VWMHl3d29x?=
 =?utf-8?B?N3NNUWJqUUVhU2JzMytiSXhDeHBoM2JSS2xpZC95YUcwelBmeUtHY3Rrdjl6?=
 =?utf-8?B?TDBoaDhWc1NGZ3dwWUxFQWdqeEFONUxReXlRVWZkNEFBYVlCbzRtQ09EazVC?=
 =?utf-8?B?bVRLcDVuL054K1d5SUpRYlUrd0hxTC9pQXE3NmJVNWJyWnl6OU5TdUZ1TlRO?=
 =?utf-8?B?eVBTVkF2WEoxYmRYdWdsOGdSVFZyTjF2V1NweWt6RVVDVzBMQkpId1ROVHlC?=
 =?utf-8?B?V3RvTVV1bzdKc2tMUU8yWThmcU94MDkzWjZjWVN6bnc3VlVRbDc5WXh0YkN0?=
 =?utf-8?B?d00rSW5DODV4WnJyTXlaTDZoYWgyMk5tVDJrcnBGc2l4UUVJNC9pQ0QrUGFs?=
 =?utf-8?Q?ppWjsqrSQ8k/SVEWFw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfadc822-731c-4681-de73-08def1802edd
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:56:37.9461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cY3UY38o0uSrCwJe2Tz34p6FyT+o54RkwEgtEasnGWb9mBI+w8HTpIo2q6nHT/tX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8790
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A4F31C0006
X-Rspamd-Server: rspam01
X-Stat-Signature: ic1ok6ddgyutxsujybwfutm1r1tz58co
X-HE-Tag: 1785776204-636870
X-HE-Meta: U2FsdGVkX1+jfBfMG8sp97iCwlOTuUXw56N1JfE+cHuprJPwCkmTIfRJDNPcrR6ShDrCynrZz7o9+9byJmPcYETqSIlvyeY5DfDfk+lDdGiasQgfBrGPE+Q5Rx2rVSMe2JJQos+1KuBmKqk9RcvvzxBG/N4IE433TquhJBYNxyJgkOi+fM6fca6RpzymuET41k5IdbJN8c8FQ3f0xoKmo2ZjIlTxfl9bKROoKQycmY4N7xwQRrAo0qOdRDLJtcpqcTQ4LUaH5fQ3dTaderBmlxPd7/cg3cCVgOYXVqD3cdTEBnCC8GAYcqPigbOhyP3dx9L8NkxSQS5ezqDr0oXprw6RJJcXzUzNtBCR0KHPexJ/ciS8f+9nRPtWWjPAz+ZY0nByD1E/29fBjQNwosczvb51VppTL+IsD8Q62EDl4Xzh0AKCnTaFqHjXLmFdhjSovUoWjXcakMA5nDVTs7YtMv+S6ot163MB88GMMTsdFExICxLAEXEhvAGYFmN8OFzAZ5++am2ejN4/JcoJ2iir/Nwqh38ser54du9vij3l3d9LQFnR/EoBSpl1Ngdozf/beyE5ddHgDXBYjducpX1wTkl8+NbvlmUEj8t522LaFkQ5xTjL1CKieetWg1tNRHv4ZHv7tno4EqFreGuMRwFBI9W/IydMJS2BJKsCux1HVUQ7CRlHgGPL9YN/XYOeA2oqUqk6zots9EgSXfhjRiK7wJbYS0P/6flfE/iL09NMvsL7NzR7qjtdUjuRxZDgqKCUSpjGJyTAkCMnc8LPlA9bI7xennjluK6ckqTwMa/KwgXNCLg6LKVyqL8RedVXq1HuIkEsJeJqEKahC+vbeL7GUPUxLJzXzmOYsPeEBlJ5QY8xpWxyF41pB9xn6PF9cjGdk8PDsAs0tjeYrIj1lKosy4vrAIRCu6ERZi5/Q5KsNbkzqbGJ3ybnzjPTnsNKEdfsV5K4pbfUwI8aXYgYbdX
 qIa01fZB
 gPuNwVK7n4jr0CI809FG15I9GwQVIyVXnaxwLg8cGJXlrnyA0chYMPR/PXa2AFVdlZKehyNoMLQEAlS5P9TsN4ifbVT8zAdHb69Kdgv/r7bC3id79nQiJjp2hLK5MDSNgNOWEB12EO6/5ct+2wxQ/FGM/PrhFPG33ZmJBPCSx0GMmi2x8G4BjNbcrrwQs4BntaxTRs+IGCqeSV5dwxoHAoQAup133ThT8b75iwBcsNP045yMw540DO/DqZbeBoT+6KmTtuU8oPt7IoJ1EQw5DY4T3PPxQvoR7i0cJbTjPfKdqLGZxMvMTU73zy1GYgjDqY5TfmRS01s2hDABTsxFU6ytYN7zznzqMmvxeZTPicx23tcql4hVDapCib3XZk41Ohv/Mwy1whYUrdYwe3IYizU2yY8DYD+zuFsNS9glSU+sZJAJcrmtGVwOP5odaTOkN0ZrE52AfPgkVVKMysutB3rQfVfAtpXuzsONxyFvCmI1HQTXT/UoqvN+xqd5fCb+Sh0Aq4RNTky/VkDFEXTOHOsc8Y3hZmSE3dXlOgECQ4KRO894R6t1uWnjs3kjdKvsW+YmJ87x+erTL3aHaastxo9231AQXHzQ8Qh6l9N/fA1Tx9rl3YwQaz36sew7p++aCxhbgaRex1G8QdV2gr4Dh+AMjJywnFhAMnnUqDovgXHp81nx6GHlGPhKlOp/YmNEMQmO1cUHP59MkPLX1nQf7X0AMIW6ryScy3LU0fkxkXumE5u1GZRGCaUjUkiP+zSMy/wng
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
> On Fri 31-07-26 22:13:30, Zi Yan wrote:
>> erofs needs to traverse readahead folios in reverse order to achieve
>> maximum performance by
>> 1. reading all folios from readahead_folio();
>> 2. storing the prior folio pointer in folio->private;
>> 3. traverse from the last folio to the first one.
>>=20
>> Add readahead_folio_reverse() to achieve the same function without using
>> folio->private.
>>=20
>> It prepares for a future commit that replaces PG_private checks with
>> !folio->private checks. After switching the checks, erofs's use of
>> folio->private without bumping folio refcount can cause unexpected
>> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() become=
s
>> reachable.
>>=20
>> No funtional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Gao Xiang <xiang@kernel.org>
>> To: Chao Yu <chao@kernel.org>
>> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> To: Jan Kara <jack@suse.cz>
>> Cc: Yue Hu <zbestahu@gmail.com>
>> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
>> Cc: Sandeep Dhavale <dhavale@google.com>
>> Cc: Hongbo Li <hongbohbli@tencent.com>
>> Cc: Chunhai Guo <guochunhai@vivo.com>
>> Cc: linux-erofs@lists.ozlabs.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-fsdevel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>
> One comment regarding the generic infrastructure below.
>
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index 4e8b2b29f6d3e..90904a4d173b7 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -1549,6 +1549,37 @@ static inline struct folio *readahead_folio(struc=
t readahead_control *ractl)
>>  	return folio;
>>  }
>> =20
>> +/**
>> + * readahead_folio_reverse - Get the next folio to read, from the tail.
>> + * @ractl: The current readahead request.
>> + *
>> + * Like readahead_folio(), but walks the range back-to-front. The folio=
 is
>> + * returned locked with its refcount dropped; the caller unlocks it onc=
e I/O
>> + * completes. Compound folios are returned once, at their head index.
>> + *
>> + * Context: The folio is locked.
>> + * Return: A pointer to the next folio, or %NULL when done.
>> + */
>> +static inline struct folio *readahead_folio_reverse(struct readahead_co=
ntrol *ractl)
>> +{
>> +	struct folio *folio;
>> +
>> +	if (!ractl->_nr_pages)
>> +		return NULL;
>> +
>> +	/* xa_load() follows sibling entries, so a tail index returns the head=
 */
>> +	folio =3D xa_load(&ractl->mapping->i_pages,
>> +			ractl->_index + ractl->_nr_pages - 1);
>> +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
>> +
>> +	/* Shrink the window from the tail down to this folio's head index */
>> +	ractl->_nr_pages =3D folio->index - ractl->_index;
>> +	ractl->_batch_count =3D 0;
>
> Thanks for the patch! Currently there's the invariant that the returned
> folio is still inside the _index .. _index+_nr_pages range. I think when =
we
> are providing a generic helper, we should keep that to make code more
> robust for the future when more people start using it.

Definitely.

>
> What I'd suggest doing is add bool in struct readahead_control telling
> whether the last folio (batch) was taken from the head or tail of the
> range, advance _nr_pages and _index accordingly in the functions returnin=
g
> folios (probably hide this in a helper function __readahead_advance()
> because it will be used in 3 places) and maybe call this new function
> readahead_folio_last() instead of _reverse() (but I have only a slight
> preference here so .._reverse() is ok with me if other people prefer it).

The below is what I come up with. I did not add a bool to
readahead_control, since I think that is the decision of caller of
__readahead_advance(). But let me know if you disagree.


diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index b59f2745a8e72..23f423c22ac8c 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1908,8 +1908,8 @@ static void z_erofs_readahead(struct readahead_contro=
l *rac)
 	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
 	z_erofs_pcluster_readmore(&f, rac, true);
=20
-	/* traverse in reverse order for best metadata I/O performance */
-	while ((folio =3D readahead_folio_reverse(rac))) {
+	/* traverse from last to first for best metadata I/O performance */
+	while ((folio =3D readahead_folio_last(rac))) {
 		err =3D z_erofs_scan_folio(&f, folio, true);
 		if (err && err !=3D -EINTR)
 			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 5ca5aa365f319..2cc3de5594518 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1510,13 +1510,21 @@ void page_cache_async_readahead(struct address_spac=
e *mapping,
 	page_cache_async_ra(&ractl, folio, req_count);
 }
=20
+static inline void __readahead_advance(struct readahead_control *rac,
+		bool read_from_head)
+{
+	if (read_from_head)
+		rac->_index +=3D rac->_batch_count;
+
+	rac->_nr_pages -=3D rac->_batch_count;
+}
+
 static inline struct folio *__readahead_folio(struct readahead_control *ra=
ctl)
 {
-	struct folio *folio;
+	struct folio *folio =3D NULL;
=20
 	BUG_ON(ractl->_batch_count > ractl->_nr_pages);
-	ractl->_nr_pages -=3D ractl->_batch_count;
-	ractl->_index +=3D ractl->_batch_count;
+	__readahead_advance(ractl, /* read_from_head=3D */ true);
=20
 	if (!ractl->_nr_pages) {
 		ractl->_batch_count =3D 0;
@@ -1548,7 +1556,7 @@ static inline struct folio *readahead_folio(struct re=
adahead_control *ractl)
 }
=20
 /**
- * readahead_folio_reverse - Get the next folio to read, from the tail.
+ * readahead_folio_last - Get the next folio to read, from the tail.
  * @ractl: The current readahead request.
  *
  * Like readahead_folio(), but walks the range back-to-front. The folio is
@@ -1558,21 +1566,24 @@ static inline struct folio *readahead_folio(struct =
readahead_control *ractl)
  * Context: The folio is locked.
  * Return: A pointer to the next folio, or %NULL when done.
  */
-static inline struct folio *readahead_folio_reverse(struct readahead_contr=
ol *ractl)
+static inline struct folio *readahead_folio_last(struct readahead_control =
*ractl)
 {
 	struct folio *folio;
=20
-	if (!ractl->_nr_pages)
+	/* Shrink the window from the tail down to this folio's head index */
+	__readahead_advance(ractl, /* read_from_head=3D */ false);
+
+	if (!ractl->_nr_pages) {
+		ractl->_batch_count =3D 0;
 		return NULL;
+	}
=20
 	/* xa_load() follows sibling entries, so a tail index returns the head */
 	folio =3D xa_load(&ractl->mapping->i_pages,
 			ractl->_index + ractl->_nr_pages - 1);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
=20
-	/* Shrink the window from the tail down to this folio's head index */
-	ractl->_nr_pages =3D folio->index - ractl->_index;
-	ractl->_batch_count =3D 0;
+	ractl->_batch_count =3D folio_nr_pages(folio);
=20
 	folio_put(folio);
 	return folio;
@@ -1583,11 +1594,10 @@ static inline unsigned int __readahead_batch(struct=
 readahead_control *rac,
 {
 	unsigned int i =3D 0;
 	XA_STATE(xas, &rac->mapping->i_pages, 0);
-	struct folio *folio;
+	struct folio *folio =3D NULL;
=20
 	BUG_ON(rac->_batch_count > rac->_nr_pages);
-	rac->_nr_pages -=3D rac->_batch_count;
-	rac->_index +=3D rac->_batch_count;
+	__readahead_advance(rac, /* read_from_head=3D */ true);
 	rac->_batch_count =3D 0;
=20
 	xas_set(&xas, rac->_index);




--=20
Best Regards,
Yan, Zi



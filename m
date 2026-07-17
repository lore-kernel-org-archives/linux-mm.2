Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01D9BC4450F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 05:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94EC6B0093; Fri, 17 Jul 2026 01:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6CCD6B0095; Fri, 17 Jul 2026 01:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C496B0096; Fri, 17 Jul 2026 01:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9336B0093
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 01:32:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E852A1C022B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 05:32:53 +0000 (UTC)
X-FDA: 84997149426.12.1278E83
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010025.outbound.protection.outlook.com [52.101.46.25])
	by imf20.hostedemail.com (Postfix) with ESMTP id 238C91C0003
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 05:32:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="IwTsBWD/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.25 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784266371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8FWZEMRmLVGpnEzh4a6Irbq6b8iMLM1LA7L894WEDKo=;
	b=xhzRfxWrIOM0u7c1QxDsRdOY7GPqE4cuRXkbSJphUB1fLzwwf0a5qW9V0x+CD9rq0G7p8t
	GSZlzR/CG3NI4q6Nnj7pCnOR8N1Y9YiKxopGLH5iviekAlFcEROTUizj2h5BfbL33W7o9X
	VW7OdAYCJkPwlPTkj21AEA6EvlZGtjE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="IwTsBWD/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ynorov@nvidia.com designates 52.101.46.25 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784266371;
	b=rJfd9zLVcooFOHYQztLS3HZOxAo5tLx6AufjO1e6dfNLQJgOjB1OT0/69QUHrPoUKxMFaw
	mqzcxgJOQzKxRCUn6lhcrip7xrw1GN19J08iLB5/rnwZvu/NBeq6DO714LrmWdj7wxE+xi
	p8N50I1+Y0WMvvJKHwYnvRvRmlh21Zo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l4xKR0KmOjt4E8rpO3ALXb/3URWjKxkuDAWk8dP3PFj2LxZl4EhjM7WH65H6TqNkTcsXVhVdkvpfffQUJPzns6c1BGDWgJM8nYvC0O15ZIYlw1aE6eFoLQ/ty2kK7DaCnV+KdcjtlU+a/jhNlOmdAaqUkqjVfomT2hW5aj23glPm7gx4Y6sCtRW9AETXl9o1b75JeDR+8UEYTY3L9JSpJB4CHfE3XdeN0bkVyGBZJXrsduOCeo4peoi6EM/BjyEXOd592JRVXV3AiefiGBkxtmhPZOqODSEKbHJ6vSNy+WV1fkdJGIYh6lF8CZFjHRgDHO+Y++FIdbjL80WNz3k1nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8FWZEMRmLVGpnEzh4a6Irbq6b8iMLM1LA7L894WEDKo=;
 b=f9wmOMd2fxpS1cDkJnRNxZ+cPFp/lnmSuw5pbaNsiGbIPbkcPnRKnkah6tMKIift4MK0l5FxOdM9Pn4rUmS+5etlghpNZVDTRoV87+ehpHoMBLyb0/j7kX4+xbzF/6eLIAE0a3IhnVBf4fZzrIs4do/JU8pgre6PwDkFbcFpTkuQR5vL04neR5RsvMgwNHkmSOItuN/w7ZDUrjQnsuTgCLZbhPz8dSKxea9aGPcHqvDXEZ7lkcbFOOnHJk2ASPIQ+xKgspFsZZUSWreFMyh15Jjo0OcmOsXp5SLL7u4ACLzjFu+CsTklay+iLhl3DL2XdRga16YyHZNB3JSmvSA2uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FWZEMRmLVGpnEzh4a6Irbq6b8iMLM1LA7L894WEDKo=;
 b=IwTsBWD/SVnoCiWPBoHwiwX1CI2U8F9AnAUpE2AKY/6XnKFBYxtmcrxGIQLESPs8bGhpWU8maWwXzYgD67FU92Xpd9tfTlVj2qVDp92YqG7RgKmzF8R37YkG0hBSoceemyBptPAhZRW7op/V5+HBjEh6u9sk6klrV9HcDUxsYLZZPJAYWtiqtzxTkaLIoESlRvlxjA4s6VO0te8opCKSLWY59i8ZsJFnx+Xafbtnhg118WUf/68SH3jrZ6n0Ic+qk2dAHf9Br98Vr1j/j887pHllNruy5ABKvLppZ/8CIC53TbfN5/KiOuawDv0a3+mmkAFq/FRPBIPhlve5zlV6xg==
Received: from LV3PR12MB9356.namprd12.prod.outlook.com (2603:10b6:408:20c::21)
 by CYYPR12MB8853.namprd12.prod.outlook.com (2603:10b6:930:cb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Fri, 17 Jul
 2026 05:32:45 +0000
Received: from LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286]) by LV3PR12MB9356.namprd12.prod.outlook.com
 ([fe80::1c36:31b4:c420:6286%5]) with mapi id 15.21.0223.011; Fri, 17 Jul 2026
 05:32:45 +0000
From: Yury Norov <ynorov@nvidia.com>
To: Eliot Courtney <ecourtney@nvidia.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Burak Emir <bqe@google.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Pedro Falcato <pfalcato@suse.de>
Cc: Yury Norov <ynorov@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Benno Lossin <lossin@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Simona Vetter <simona@ffwll.ch>,
	Tamir Duberstein <tamird@kernel.org>,
	Timur Tabi <ttabi@nvidia.com>,
	Trevor Gross <tmgross@umich.edu>,
	Yury Norov <yury.norov@gmail.com>,
	Zhi Wang <zhiw@nvidia.com>,
	maple-tree@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	nova-gpu@lists.linux.dev,
	dri-devel@lists.freedesktop.org,
	rust-for-linux@vger.kernel.org
Subject: [PATCH v3] lib: test bitmap vs IDA vs Maple Tree performance for region allocations
Date: Fri, 17 Jul 2026 01:32:40 -0400
Message-ID: <20260717053241.916441-1-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:a03:333::24) To LV3PR12MB9356.namprd12.prod.outlook.com
 (2603:10b6:408:20c::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR12MB9356:EE_|CYYPR12MB8853:EE_
X-MS-Office365-Filtering-Correlation-Id: 1da552f4-d187-4bcf-4e05-08dee3c4d47b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|23010399003|376014|56012099006|6133799003|11063799006|3023799007|18002099003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	gxuKyB2bUOvaVGxQ6dbBLhkCYLmDCKaYurfIfFiTqHdIfo2EHVWGSFDGc+7Q/vS+/kodNJwTGJBY0qJnZYodGtwN3EVPBQ1y4JC2quS9Qj610QbHSk3P759fDDHntbDR+X41bUcwM29R7ZSDIeQaBmSMB5UdDPMWN3D228m3DVX2q0HUUaZnyJr2C7GeHQZrS4L0liwHuzrLApb25HiMg872QgiWrBnKkeu6av6uKA0lAFc7qLxwkBwvHFRmqbz0utUkiuMXbjOlWB6yNs5Urbp+/ALfYhzu46qfoIdAezUZK3dYxOKAtYoJbR5/WeY8jxdEJPuL+qohBcmXRPyV4d/vZ+2M3WY4xprgtFgeK3Li1sZZcdyPRYbSX4cKOQ23w66I17+28SWm/KCq58Dfvu70eBTZyWtTb16th0ABHruRlxe6tXEdsclOSjNJ6KW47iPCJSDDU8pSzwnv6HUPidkExi96iItHJhEcu/UCKLsUVQaYSuRSc73FCyIZ/EEiOM97/ZTYOxV1Uqi0XAEO8JELZz4ZYMys/xScVvlHQaVGC4a0DywkTXQveN3MZRp6EMkrjnYaT4GYNpcDX/IHoKKNd/nSyqEf1vRx8zP+HP9E9KgkjRjhSiIWOqe3a9HKvxmkGb3u4lq8Fve5qLsosNNLMw1pa7GVuKmZm8KAcqsfsy6KROuX1P/zK0VZir+AMVi36ltQqHKxy0EfpaDEkg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(23010399003)(376014)(56012099006)(6133799003)(11063799006)(3023799007)(18002099003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTFLcGNPU1hqVE1qTjBKSGtrN2ZHeXB0bk0xakF3S3Ezc3dDUk4vZVJkcnhZ?=
 =?utf-8?B?RHFUVmM2V0ZJYlZiMjlsd2JWRTV4c2V5WE9PWTNTbENTVUwvOEtFRHhIMHAw?=
 =?utf-8?B?UHVTeW5jcFdKc2VhSnUrblNmRXV0MUFFYmZhajBvMU94OE0vSWh0UUluWTgx?=
 =?utf-8?B?NllNRjR0aEVVdFVZNVp5ejdTZHYzckdkcXhIS1ZQKzF2anhra1J6OG9sVjFD?=
 =?utf-8?B?aHEwWFJUSmYzbDFLRDV6RjAvUXp6OTExVHJ5a3dZZUdxYVc3RkgxOHV5emNB?=
 =?utf-8?B?N3JpN0tmSWQwVk5qTUpJK0QxTlZUSHZJblZ1dlJyRElqSGpsT2VKR3EyNGJJ?=
 =?utf-8?B?cUVTUDIyU3JVUjZCd2RLdlpFVFp2cjJsV1pteDd3UG1obUpLSGtkeDN1RFhZ?=
 =?utf-8?B?S3RHdWlxbzh0enczTVBaYkJ5QVdIR3JObUIvTEtKSCtIamhaOGw1Snh5NTBr?=
 =?utf-8?B?eVJJS2YyKzV3dUdPQjZoQkE5TXorTkc1a0taNUc2cit6NittQVdVU291Y2ZR?=
 =?utf-8?B?TGFSd2hhWjlIcnlRU3Q0N2pTWjlHTzJDN1BKaHRFY2lsNG9iU094RWpsZmhK?=
 =?utf-8?B?SHUvVG9kQW56M1dSWThyNWwvOWkvd3plS2QrcEpJQUhCOXp1Ym5CS1plZE55?=
 =?utf-8?B?emVqRFAyVXJXeXU2QXJFK1hZYmN3Q3lFckw3Qm9lTTJjYnVxZGsxc2FibmZZ?=
 =?utf-8?B?WCtOU2N1bDU4dWJjOXZtZXFIT29TUEUxNE5RdTF4TnFRb21TSjdIRmtDb254?=
 =?utf-8?B?M00ydHkxZGhyYnI4V25XSFRnbThDaS9ZSkJCWThrdkhpbnBNRlJGQmRCRFcr?=
 =?utf-8?B?VXNkbDdEV3NqOGcxb0RZemRiUjhaT3l1K2VONFdSTFFjOVN4aHRuTFlrQ0lk?=
 =?utf-8?B?aVAyYjhxdEgvYWxZdVNMLzVzdnhhMmpOdmlTb2YrQnJwWlVXSzlzY0RPSFpq?=
 =?utf-8?B?RTFWR3VZQVV3KzdjeHJqcGFxNERCaVVVSmlBZk5kNGltYkhBQnNpbThlclVr?=
 =?utf-8?B?OUVSMjFIYjAza2RmU3hHQ3BuUjB1NzVpZTd0QzVvUXFKc1NDUUhpcFdrcW1K?=
 =?utf-8?B?Q1pTenkyNEtGOHIxbC9USVNWTERWdTF2aFZPY0dtSDMvZUdWU0ZHazI3YWVC?=
 =?utf-8?B?SUZyaEROK0tMUnlFeWY0MHZoMWNOSzl4RUNCcFE4NEpUbWFqc2F0T3ZyVHNP?=
 =?utf-8?B?cGRLQSs0MWxHSkVxK1djTVpjRmdCU01wK2Y2Qm5McVU3cjFFSml5cHo5ZUYx?=
 =?utf-8?B?MGdFdWh3THROQ3Z1Rm9ycS9nUnd2VGRrWEl6MDlEOE4wM1lhK0g1d3Z6bHdR?=
 =?utf-8?B?Z3RsOWRjbG1zb29nZytIMnFFaHVINTV2YkRlOUZZRzl1TkVZUUhpRnRYZDFw?=
 =?utf-8?B?WVpLZ1VDRTFOZXdhVEUwaEQxNzRVOFJNR05SK0pHUEZzY01mWTVHOWtxQnVi?=
 =?utf-8?B?RW9FdHgzU3crNi90NkZteVRDdjJVeng1SVZOM0gxVnFvWG1uQ29oMUlIakhq?=
 =?utf-8?B?SWFuTE8yaXFFRzJ5NW1SZHQ4Mlc1V3d6UmZmWHdqK0Uxa1QzRlVNdk1QZWdI?=
 =?utf-8?B?VGxuUmhyTlJMNG5xOUt1eDlnSnJRMDVaTnllcXo2aXlScHlFNjRvQzU4Q3hM?=
 =?utf-8?B?bndKLy8weGdaalNmT1BaVm51U3dlVGVQRC9Pc1RlUUxlajd0L2s5WEpmdHJi?=
 =?utf-8?B?bGhHNEFNVTNDdERpLytmdGVjbEFJUU9EcW45OC9iaUR5QnhKNTFGSlZCakRU?=
 =?utf-8?B?bmVxbnVMRStrb3FyWExwaUYweXQwYkxYcWtYV2YxY0NxVHJoVzdJWFlMYzNh?=
 =?utf-8?B?RnRra1ArSFNMOUFoeHE0VjhFZncyeUlrNkdlSlBUTHdUWjEyTXkrNE1pQ3pT?=
 =?utf-8?B?ajFQdklxQzhzdUtPV3hTbWlFUWw2dW84ZG5hWWtReUNVYitJZHhFUW5WU0xD?=
 =?utf-8?B?YVdjdXVaaXJQTXJqVWd6dWZZUWN2SnRDWVV4ZlpNT0JBcmlTZU9CaFJxZ0Q0?=
 =?utf-8?B?NDN0WjQ4M0lhcXFnY1JwY2lDUzU4cDFjVXRSVE1rK2txRW85ZkhtYldtSDdV?=
 =?utf-8?B?ZEZFSmhCeHh2TTBPdmFDRkJwaXlLMHV6enRia2lwTzdqMlRjYVlQYVh5RHAx?=
 =?utf-8?B?b0ZDb1FoOXhScFZ1cVlEVWtLeGgxVGR3MEpOS24xbFJsbVMvL3poRWRldW51?=
 =?utf-8?B?YUc3dHdWS0Ntcm9qb1BUYjN1QkhKekp5NUtnUm5mVGZ2cTA1WnVCa2dyNndE?=
 =?utf-8?B?YzczaGlMTDdHK1VxWWpNa0lPT0tOVTEzbmFwVVRLeWk1N1VEZFVKQS9YLzM2?=
 =?utf-8?B?cG1YSC9HRkVEQ1pDanhVNnk0NkJLbnpobkFCejZnZHc2akloZXdrQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1da552f4-d187-4bcf-4e05-08dee3c4d47b
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 05:32:45.2931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+cAvA5BPYf+nBKRvZdgdwqgb45xFp7K9SZ6JRSo9rUYN7BsZXoy01BJVV1eP5SM9LmyR4nXKRLoKWWd8sJRyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8853
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 238C91C0003
X-Stat-Signature: 1anpau7zbmaci69pptctsmewu4ihrkjd
X-HE-Tag: 1784266371-104499
X-HE-Meta: U2FsdGVkX1+54UjC4ckmcAkiiEWQa6nJ5UJ0Qa8JJzIWZARDTybPDYZKC+Oqxxy2riGMVqzXPoMBW87Ot5uPGZGUwdegERYM0U//MJVSXon/LccPsRuJuIYXTS1A49GqB7d1iHUEwqFWnc9vqcDahRsm0Tn7ENT3P/P5Zb31B2ADrDREAAXQBApcbVaNhO/rQTqhd6TpExJg2i1mYgae+Q3L2XIWX88opoRcxndoM2MLk17PgyiIXCSFZO9ioBuNH0ygnIW1nnA+Z/dFVXUcXaJSpEw2622Cw7P0NIU/3BiIULb5HrubUnIK1XgHkRAPwSso7BVZsiFvUUYXYPFZvY16f6PQJ+I6ck+6eF2pt5x96UyR5BgyD6LJgj7tf7m9CZR282j2pt9lAMGSq+bs8m5lS2vivLyVXuIPl0mupYXnJROV+8YfQg5vLVWomxeQd4HACf3usEfs0KX7tOOTmiht6aENI6aq+z/oU58eUb72aLAiXkz9prcrXpg06YEyBjcVgEUH9hjU/BGEG6jenmXs6g6H2c51h/OaFGpYyB2BzucmiMRg7v0FrQrv25nSGp1a29W+0nkavA4+3ibnh3RpcxyVP+IJs9ebllhJP/TnFDd3WJjmKlNgsIwaYHZOelAmP0QMPZL4UdF/rN56xTdoS/tMx28bCz26+qFXK5V2v2ieniPJIEpFbO3FsBDODVUl/niO3mg92vZaKTFvNi91bKNvBPMX3Vifq3qVXWKUJaol0SMMp37WfNSbiTEEZocKI3MwNwZbfjY/wvWEqHrefDDS9m9+3Ris+NdWfpBiqIoe3v9d+xZu3z23slO+dDEJPRLhN5+iA216rWYT56m0VrPyGrkTzbnjxpdGLehYxAX0KHKZId+gUA3Nem5kqS0Ej7tMOimPtHTHKTwHkJIPgwtv6I3AqEdGK9v20BvRckmQDPEuGpbqEQJpZKPJDXTZ3sfTnlWlvKAMQzb
 1n3Nk03S
 Qr3FX8Ld8UsAZyl+YrpaEBYmfbfAX6i40aGxkYIh8+hu3QlTGfdGyYbnT+R8KRphR71VbavxBurJZ8zrQD+8QmFhCkbCmEJA5RtKCHb76xDavJq6VNNrCMvmk1yZj/51VOmabKWcXHPQiNbCvGV1cyRWHHncr+DnxkD9usLuVtYa4BeWR7oJRVJC1DxO47zUMrvCgFLN6E/ZDWQgVC8tdS3a8/0xwPxoi9693ngt8irVXhp8hsbC48IkT/yOMlAIhtqDwi7ElZnPgWI4D+IBjXATyh81G45j1Tl/aafYuVscwalcRKZ+5pCN6MkO20Y3TJ2KUMC3giIhIaSgYrywclLhvrLqvVWry6ASeBoFeGNlfBLFPXWXgSURgetQxLS+y8tU8lhZrSIWOyZ6G10QDhGeJMhtLO/2asCwLoDyA4Lwxto8mZpxm/9ZbMuoUz2zT8yBo5FmleTHCYP6lAxnwHeG2C0BtxlX6BAAtFgPafs1DDd+zMFH1lL+KtAbK9bxZjw/qyEYt4aIUCps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compare the cost of allocating and freeing variable-sized regions using
a bitmap, IDA and a Maple Tree. All implementations process the same
randomly generated sequence of regions containing up to 32 entries, until
the configured capacity is exhausted.

The benchmark exercises monotonic allocation into an initially empty pool,
followed by reverse-order freeing. It does not model fragmentation or
interleaved allocation and freeing, nor does it isolate locking or RCU
overhead. Allocation time includes the terminal failed request that detects
exhaustion.

Run the benchmark at several capacities to show how the approaches scale.
Report allocation and free times separately because bitmap, IDA and Maple
Tree removal have substantially different costs.

On x86/kvm, the output example is:

Start testing bitmap vs IDA vs Maple Tree region allocation
memory: bitmap is exact; IDA and Maple Tree are lower bounds
Type      alloc (ns)     free (ns)   regions  capacity  memory (B)
Bitmap      93457345        176151     60644   1000000      125000
Maple       11758660      12870146     60644   1000000     1552656
IDA         31066416      20870824     60644   1000000      134864
Bitmap        919119         17679      6032    100000       12504
Maple        1158193       1187140      6032    100000      154640
IDA          2759670       2116004      6032    100000       14288
Bitmap         17120          2043       613     10000        1256
Maple         116350        117537       613     10000       15888
IDA           243396        202654       613     10000        1872
Bitmap          1220           262        55      1000         128
Maple          12076         10106        55      1000        1552
IDA            25730         20875        55      1000         144
Bitmap           593           124        18       100          16
Maple           3599          4782        18       100         528
IDA             3266          1960        18       100         144
Bitmap           414           129        10        10           8
Maple           2143          1385        10        10         272
IDA              892           648        10        10          16
Region allocation benchmark complete

Reported IDA and Maple Tree memory figures exclude slab overhead
and transient allocations. The Maple Tree figure is additionally
a lower-bound estimate that assumes fully occupied leaf nodes and
excludes internal nodes.

IDA has no region-allocation API, so each region is implemented as
a sequence of single-ID allocations. The IDs remain contiguous
because this benchmark fills an initially empty IDA monotonically.

The benchmark is motivated by the discussion linked below about choosing
the best data structure for the channel ID pool with the capacity of 2048
IDs for the nova GPU driver.

Specifically for 2048 IDs the result is:

Bitmap          5112           615       121      2048         256
Maple          78526         59592       121      2048        3344
IDA           165274        117761       121      2048         848

The benchmark accepts a list of up to 64 nonzero capacities to test.
For example:

  insmod region_alloc_benchmark.ko capacities=1024,2048,4096,65536

The list may contain duplicate capacities. Each occurrence generates a new
region-size sequence, which is useful for collecting statistical
characteristics of the benchmark results.

Link: https://lore.kernel.org/all/20260710-chid-maple-v1-1-4ee869055268@nvidia.com/
Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
v3:
- allow capacities to be configured through the module parameter (Yury Norov)
- document default and custom-capacity usage in Kconfig (Yury Norov)
- store and generate only the region sizes required by each run (Yury Norov)
- clarify the workload, timing semantics and memory estimates (Pedro Falcato, Onur Özkan)
- report region count and capacity while retaining raw timings (Gary Guo)
- add post-free integrity checks (Yury Norov)
- add default capacities of 10 and 100 IDs (Matthew Wilcox)
- bound generated region sizes appropriately for small capacities (Matthew Wilcox)
- report successful completion and return -EAGAIN for repeat runs (Yury Norov)
v2: https://lore.kernel.org/all/20260711063602.426311-1-ynorov@nvidia.com/
v1: https://lore.kernel.org/all/20260711013910.349586-1-ynorov@nvidia.com/

 MAINTAINERS                  |   3 +
 lib/Kconfig.debug            |  13 +++
 lib/Makefile                 |   1 +
 lib/region_alloc_benchmark.c | 217 +++++++++++++++++++++++++++++++++++
 4 files changed, 234 insertions(+)
 create mode 100644 lib/region_alloc_benchmark.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cc4bca5a2c5..9e487a94aba4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4615,6 +4615,7 @@ F:	lib/bitmap.c
 F:	lib/cpumask.c
 F:	lib/find_bit.c
 F:	lib/find_bit_benchmark.c
+F:	lib/region_alloc_benchmark.c
 F:	lib/test_bitmap.c
 F:	lib/tests/cpumask_kunit.c
 F:	tools/include/linux/bitfield.h
@@ -15581,6 +15582,7 @@ F:	Documentation/core-api/maple_tree.rst
 F:	include/linux/maple_tree.h
 F:	include/trace/events/maple_tree.h
 F:	lib/maple_tree.c
+F:	lib/region_alloc_benchmark.c
 F:	lib/test_maple_tree.c
 F:	rust/helpers/maple_tree.c
 F:	rust/kernel/maple_tree.rs
@@ -29323,6 +29325,7 @@ F:	Documentation/core-api/xarray.rst
 F:	include/linux/idr.h
 F:	include/linux/xarray.h
 F:	lib/idr.c
+F:	lib/region_alloc_benchmark.c
 F:	lib/test_xarray.c
 F:	lib/xarray.c
 F:	tools/testing/radix-tree
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1244dcac2294..0451dfca7098 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2683,6 +2683,19 @@ config FIND_BIT_BENCHMARK
 
 	  If unsure, say N.
 
+config REGION_ALLOC_BENCHMARK
+	tristate "Benchmark bitmap, IDA and Maple Tree region allocation"
+	help
+	  This builds a microbenchmark comparing variable-sized region
+	  allocation using bitmaps, IDA and Maple Tree. The benchmark
+	  runs at initialization time.
+
+	  Usage:
+	    insmod region_alloc_benchmark.ko
+	    insmod region_alloc_benchmark.ko capacities=1024,2048,4096,65536
+
+	  If unsure, say N.
+
 config FIND_BIT_BENCHMARK_RUST
 	tristate "Test find_bit functions in Rust"
 	depends on RUST
diff --git a/lib/Makefile b/lib/Makefile
index 7f75cc6edf94..adb18810e3f7 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -64,6 +64,7 @@ obj-y += hexdump.o
 obj-$(CONFIG_TEST_HEXDUMP) += test_hexdump.o
 obj-y += kstrtox.o
 obj-$(CONFIG_FIND_BIT_BENCHMARK) += find_bit_benchmark.o
+obj-$(CONFIG_REGION_ALLOC_BENCHMARK) += region_alloc_benchmark.o
 obj-$(CONFIG_FIND_BIT_BENCHMARK_RUST) += find_bit_benchmark_rust.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
 test_dhry-objs := dhry_1.o dhry_2.o dhry_run.o
diff --git a/lib/region_alloc_benchmark.c b/lib/region_alloc_benchmark.c
new file mode 100644
index 000000000000..e88b4cf55c62
--- /dev/null
+++ b/lib/region_alloc_benchmark.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Benchmark bitmap, IDA and Maple Tree allocation of variable-sized regions. */
+
+#include <linux/bitmap.h>
+#include <linux/idr.h>
+#include <linux/kernel.h>
+#include <linux/maple_tree.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/random.h>
+#include <linux/slab.h>
+#include <linux/xarray.h>
+
+#define REGION_MAX_SIZE	32
+
+static unsigned long *bitmap __initdata;
+/* One more request guarantees that even an all-ones trace reaches ENOSPC. */
+static u8 *reg_sz __initdata;
+static unsigned long *reg_idx __initdata;
+static unsigned long capacities[64] = { 1000000, 100000, 10000, 1000, 100, 10 };
+static unsigned int cap_cnt = 6;
+
+module_param_array(capacities, ulong, &cap_cnt, 0400);
+MODULE_PARM_DESC(capacities, "Region capacities to benchmark");
+
+static unsigned long __init benchmark_bitmap(unsigned long cap)
+{
+	unsigned long cnt, idx;
+	ktime_t alloc_time, free_time;
+	size_t sz;
+
+	bitmap_zero(bitmap, cap);
+	alloc_time = ktime_get();
+	for (cnt = 0; cnt <= cap; cnt++) {
+		idx = bitmap_find_next_zero_area(bitmap, cap, 0, reg_sz[cnt], 0);
+		if (idx >= cap)
+			break;
+
+		reg_idx[cnt] = idx;
+		bitmap_set(bitmap, idx, reg_sz[cnt]);
+	}
+	alloc_time = ktime_get() - alloc_time;
+
+	idx = cnt;
+
+	free_time = ktime_get();
+	while (idx--)
+		bitmap_clear(bitmap, reg_idx[idx], reg_sz[idx]);
+	free_time = ktime_get() - free_time;
+
+	WARN_ON(!bitmap_empty(bitmap, cap));
+
+	sz = BITS_TO_LONGS(cap) * sizeof(unsigned long);
+	pr_err("Bitmap  %12llu  %12llu  %8lu  %8lu  %10zu\n",
+	       alloc_time, free_time, cnt, cap, sz);
+
+	return cnt;
+}
+
+static size_t __init ida_size(unsigned long nr_ids)
+{
+	unsigned long entries = DIV_ROUND_UP(nr_ids, IDA_BITMAP_BITS);
+	unsigned long bitmaps = nr_ids / IDA_BITMAP_BITS;
+	unsigned long nodes = 0;
+
+	if (nr_ids % IDA_BITMAP_BITS > BITS_PER_XA_VALUE)
+		bitmaps++;
+
+	while (entries > 1) {
+		entries = DIV_ROUND_UP(entries, XA_CHUNK_SIZE);
+		nodes += entries;
+	}
+
+	return sizeof(struct ida) +
+		bitmaps * sizeof(struct ida_bitmap) +
+		nodes   * sizeof(struct xa_node);
+}
+
+static unsigned long __init benchmark_ida(unsigned long cap)
+{
+	struct ida ida = IDA_INIT(ida);
+	unsigned long cnt, idx, off, nr_ids = 0;
+	ktime_t alloc_time, free_time;
+	int id = -ENOSPC;
+
+	alloc_time = ktime_get();
+	for (cnt = 0; cnt <= cap; cnt++) {
+		for (off = 0; off < reg_sz[cnt]; off++) {
+			id = ida_alloc_max(&ida, cap - 1, GFP_KERNEL);
+			if (id < 0)
+				break;
+
+			if (!off)
+				reg_idx[cnt] = id;
+		}
+		if (id < 0) {
+			while (off--)
+				ida_free(&ida, reg_idx[cnt] + off);
+			break;
+		}
+		WARN_ON(id != reg_idx[cnt] + reg_sz[cnt] - 1);
+		nr_ids += reg_sz[cnt];
+	}
+	alloc_time = ktime_get() - alloc_time;
+
+	WARN_ON(id != -ENOSPC);
+
+	idx = cnt;
+
+	free_time = ktime_get();
+	while (idx--) {
+		for (off = 0; off < reg_sz[idx]; off++)
+			ida_free(&ida, reg_idx[idx] + off);
+	}
+	free_time = ktime_get() - free_time;
+
+	WARN_ON(!ida_is_empty(&ida));
+
+	pr_err("IDA     %12llu  %12llu  %8lu  %8lu  %10zu\n",
+	       alloc_time, free_time, cnt, cap, ida_size(nr_ids));
+
+	ida_destroy(&ida);
+	return cnt;
+}
+
+static unsigned long __init benchmark_maple_tree(unsigned long cap)
+{
+	struct maple_tree mt = MTREE_INIT(mt, MT_FLAGS_ALLOC_RANGE);
+	unsigned long cnt, idx;
+	ktime_t alloc_time, free_time;
+	size_t sz;
+	int ret;
+
+	alloc_time = ktime_get();
+	for (cnt = 0; cnt <= cap; cnt++) {
+		ret = mtree_alloc_range(&mt, &idx, xa_mk_value(cnt + 1),
+					reg_sz[cnt], 0, cap - 1, GFP_KERNEL);
+		if (ret)
+			break;
+
+		reg_idx[cnt] = idx;
+	}
+	alloc_time = ktime_get() - alloc_time;
+
+	WARN_ON(ret != -EBUSY);
+
+	idx = cnt;
+
+	free_time = ktime_get();
+	while (idx--)
+		mtree_erase(&mt, reg_idx[idx]);
+	free_time = ktime_get() - free_time;
+
+	WARN_ON(!mtree_empty(&mt));
+
+	/* Minimum storage assuming fully occupied allocation-range leaf nodes. */
+	sz = sizeof(mt) + DIV_ROUND_UP(cnt, MAPLE_ARANGE64_SLOTS) * sizeof(struct maple_node);
+	pr_err("Maple   %12llu  %12llu  %8lu  %8lu  %10zu\n",
+	       alloc_time, free_time, cnt, cap, sz);
+
+	mtree_destroy(&mt);
+	return cnt;
+}
+
+static int __init region_alloc_benchmark(void)
+{
+	unsigned long bitmap_count, ida_count, maple_count;
+	unsigned long i, max_cap = 0;
+	int ret = -ENOMEM;
+
+	for (i = 0; i < cap_cnt; i++) {
+		if (capacities[i] == 0) {
+			pr_err("capacity must be nonzero\n");
+			return -EINVAL;
+		}
+		max_cap = max(max_cap, capacities[i]);
+	}
+
+	bitmap = kvmalloc_array(BITS_TO_LONGS(max_cap), sizeof(*bitmap), GFP_KERNEL);
+	reg_sz = kvmalloc_array(max_cap + 1, sizeof(*reg_sz), GFP_KERNEL);
+	reg_idx = kvmalloc_array(max_cap, sizeof(*reg_idx), GFP_KERNEL);
+	if (!bitmap || !reg_sz || !reg_idx)
+		goto out;
+
+	pr_err("\nStart testing bitmap vs IDA vs Maple Tree region allocation\n");
+	pr_err("memory: bitmap is exact; IDA and Maple Tree are lower bounds\n");
+	pr_err("Type      alloc (ns)     free (ns)   regions  capacity  memory (B)\n");
+
+	for (i = 0; i < cap_cnt; i++) {
+		unsigned long idx, max_size;
+
+		max_size = min(REGION_MAX_SIZE, capacities[i] / 10) ? : 1;
+		for (idx = 0; idx <= capacities[i]; idx++)
+			reg_sz[idx] = get_random_u32_below(max_size) + 1;
+
+		bitmap_count = benchmark_bitmap(capacities[i]);
+		maple_count  = benchmark_maple_tree(capacities[i]);
+		ida_count    = benchmark_ida(capacities[i]);
+
+		WARN_ON(bitmap_count != ida_count);
+		WARN_ON(bitmap_count != maple_count);
+	}
+
+	/* Return an error so the benchmark can run repeatedly without rmmod. */
+	pr_info("Region allocation benchmark complete\n");
+	ret = -EAGAIN;
+out:
+	kvfree(reg_idx);
+	kvfree(reg_sz);
+	kvfree(bitmap);
+	return ret;
+}
+module_init(region_alloc_benchmark);
+
+MODULE_AUTHOR("Yury Norov <ynorov@nvidia.com>");
+MODULE_DESCRIPTION("Benchmark bitmap, IDA and Maple Tree region allocation");
+MODULE_LICENSE("GPL");
-- 
2.53.0


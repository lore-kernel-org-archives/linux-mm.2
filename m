Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3671DCA6004
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 02:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 278836B0092; Wed,  7 Oct 2026 22:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2296A6B0093; Wed,  7 Oct 2026 22:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117706B0095; Wed,  7 Oct 2026 22:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDD886B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:09:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 057461403C9
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:09:07 +0000 (UTC)
X-FDA: 85297826334.11.3052C47
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010014.outbound.protection.outlook.com [52.101.85.14])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96E2D160005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:09:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mrYcOevl;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791425344;
	b=sBbKw0b7Tjstk1xSGb4C+WaYOHH84QpxL3jNH9EsEWxLWMChYSUggdvROxeL+nuN5FEnFY
	GYFzFs0CcudXyYzn0Vcy83VSQIwctD1nWExdTB2raQvcFFKYJF0d2vkuWntxf8xvE07Laa
	r5ZxyJJXVCLr99rYQOtfjDrnjAlK6ro=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mrYcOevl;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791425344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+YBDccGqt/rMwXZF3YYWkdQXRmPCs/HX3Bzj33hv4U=;
	b=xVu1iGK1mxCBeygtDrKdshwcnB2hVnuLgBB34SbMUXf7SWauUfkqG//JztyjiGh6c+cEDF
	w4Ijy7Xp/tw/+FTLbz5dv38l5hXoi0WaWG9C1X0teO04M/SpjJ22RiP3+Kf3gFNK4Tyu87
	nrz/GU/aZUw957Z55LjCMmIRrwNY3Q8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xZCcnAtOSg3RhikVbNcEkwYzhPy2yYSUEOI9wU3INkjN42/dCdZkUiQfLHnNPZTi6DSMvqYFhYdo/VC/rFVWFpfkSrAx6pJ8ocQ9269g0vCfeqinLez/7NxD3ToRyC+LKKDlrv1MBz+wyQxDQCIbn+Un2iAKDV3MblXPM8jKBfsthZWF7yN4SSQQaDknt2sY/uGyLy5ph+5t5MHztgqbGz1nN1KII2iEwmDMMVE4Zp7ZPnk3LLCA2COeT5yFlOyc/5K9jXpjOjHaHqFVQGeCbACWvMxzjLASyxpKVMtEok8a6LJTiQMXJviXJ3gIWMnNXtvumeWkqvKvPlvHyAzX+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+YBDccGqt/rMwXZF3YYWkdQXRmPCs/HX3Bzj33hv4U=;
 b=cqJlZvyQOdsIl8ONujnjFigznv9QRICTXVgApP1rPkpjhdtjK7QvqOWkcGdI215Pm3sVqq6W+8hbRxziiYPYxxfSObTlYeIGhODh05JeN1J5rgGN9IbnvyA4z3m4Yi05CqiuLjM53SlINx+Y6QAGQ2tOSRBI/Rgq6RVd6C7BvC4U1XXsF4yrB2UhE7hjwxgHC2OeD1/ueFwa8Zs3yRQn3ngWefYrN35RF/USz4Ak0anV5Z2SB3sEeSfUoYB/23zLK0YFOirRwVYZJU6R2SfIiQyKD788oXe2BqzMyGwbNaqdLNiBAEdn/AJadsoDzNmaOWLx99yA860Hds19X7q2iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+YBDccGqt/rMwXZF3YYWkdQXRmPCs/HX3Bzj33hv4U=;
 b=mrYcOevl0Msid7SaL8tSaxrtVSMQrTIpxFpxLHxzH0UAGn6zCVRxC+Ee23aJIPu6QnNnPZq3c5OQLMUCwFXmEo3hE2loKDEP99dHHfXQhQCd9k671Eem7DyfxpB4yANxhwp/PSZ/KOhcF9XIjtSYL3a0Pa58hs4+V8LcDwPGa68BejboPvt5urWslT4wLHvgqTbi+uqduTYUBykgnOuSdbUgKRvXOiF5ehavEqLBW+ph9Zd8aYlVyW/YsUErVaVmByhNLof6ov8UI5geqDLGbY8qq7SRm69eOVlBWt2BOBLrSv7HEUfJ/FWkh1Q/uzJm+v6AUuQe1Ocfbq+JSA3Iqw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LVUPR12MB999135.namprd12.prod.outlook.com (2603:10b6:408:3a1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Thu, 8 Oct
 2026 02:07:04 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 8 Oct 2026
 02:06:58 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 07 Oct 2026 22:06:57 -0400
Message-Id: <DLZ38NR21UU6.QIKBG8SO7189@nvidia.com>
Subject: Re: [PATCH v8 08/30] mm: recognize PMD swap entries in the softleaf
 layer
Cc: <ying.huang@linux.alibaba.com>, "Baoquan He" <baoquan.he@linux.dev>,
 <willy@infradead.org>, <youngjun.park@lge.com>, <hannes@cmpxchg.org>,
 <riel@surriel.com>, <shakeel.butt@linux.dev>, <alex@ghiti.fr>,
 <kas@kernel.org>, <baohua@kernel.org>, <dev.jain@arm.com>,
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Liam
 R.Howlett" <liam@infradead.org>, <ryan.roberts@arm.com>, "Vlastimil Babka"
 <vbabka@kernel.org>, <lance.yang@linux.dev>,
 <linux-kernel@vger.kernel.org>, <nphamcs@gmail.com>,
 <shikemeng@huaweicloud.com>, <yosry@kernel.org>, <qi.zheng@linux.dev>,
 <luizcap@redhat.com>, <kernel-team@meta.com>
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, <david@kernel.org>, <chrisl@kernel.org>,
 <kasong@tencent.com>, <ljs@kernel.org>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20261002095503.3585565-1-usama.arif@linux.dev>
 <20261002095503.3585565-9-usama.arif@linux.dev>
In-Reply-To: <20261002095503.3585565-9-usama.arif@linux.dev>
X-ClientProxiedBy: MN0PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:208:52d::34) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LVUPR12MB999135:EE_
X-MS-Office365-Filtering-Correlation-Id: 0aa913c3-afa2-4e99-6c15-08df24e0d5b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|7416014|56012099006|4143699003|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	RsxxRqQlzIp/qSg3z/N9zATazEVVx+axYlkX8oioseERAEcKqQvGnFds3NE9OY4Ep3M9Kgwu8mb/GWu9fy3yp/FkkWcOXGqHAPFQKsF2PGDZbnhC0e6baKUkWoGbB3voynqD0vqO65l9AEUj2HtQm69LkU1LKFY4H1ipVACZVrmvEHYDcw7Yas2EJkIiH+OAwFpZZuHeSqHEIvR1WXFUk3npLipt3N6YYHxiZgJzuFFESlAGdr016tQFrPKXcy6+o7nuRJlcLOo5SH5fsEBCn2HqokdXgcvwz9Exy7+Zuhha1L1RUQmH5IEJiIKZ4A9s19eRyu7YLvVlz11HQWCyBLnquKCxku+JKjFg7LpPGxpH8/vLp8jQmBCAKqWE3YxI0UFEaWb09CT5N4A06E3/ukDuK85Y/H/V51kCOMVhBRgLJZZ884YT0J6GJqP7qv+/lNnWqWgW3YmfprIkIvYnUyhQDCnrOb4CTER36HIMCPjprJSIGLdHTjOhKKlROVcGOwGYIzU0Gv2+NioD4sQDBDvbUA0qj7rYoDuVAA9FgGGL+8Q7OfGbCYukIHH0fQR6jxw3/UjrQG5swv7d4zXGAOUKFLDbV9UrTSSuSsy+eRs1lmabDHOMl3Tqq9M7f+/1jkZRVp7G29kTsYC75MgChWNcuNS96lrpWGilkfC76WY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(7416014)(56012099006)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RyttTjVTVVh1aUhONmdjaGpYM3FxMmtLOEgrQTNuOHBxVmZwUTAzQzliR1BB?=
 =?utf-8?B?VXEwOThLYTVLZ1E5OUM0QnE5VjNNN2Q2Y0ttQjBYSjhwMHY4SVUydkFiMUxr?=
 =?utf-8?B?dWplT1Z0S2poWWU0QTdqSmdjbTZaUURreTFMWlZKNEtYaXBtZjdCM3RlUWp3?=
 =?utf-8?B?b2JUZWhxQ1ZGOUs5aXFvME1nWWlDeVlkbW9BMmhYQm9SdlZjU1BWb0NTeFRW?=
 =?utf-8?B?SnQxRy84andCdGI1cFh1V0hBK1RNQ01wSGUrMDVGWkJPWHBOU2ZKT0NxRExX?=
 =?utf-8?B?YTNvS0tEajdFdFVOd1MzMldHWnkvSTZPaDhsclFUSW54M2x6NmdHVlFra21P?=
 =?utf-8?B?ZTFhQlVSVHc4em8xalZ0MXdTbGNscUZFUmtISlBOYTZiU0VLM1pQRmh4QU90?=
 =?utf-8?B?VzcvVlRGSEhzVWE5L2g5VDBKdzhVZHBJTE8zOUFzdHpNaC9Za1k3RG93U1ht?=
 =?utf-8?B?RHZsWEVyWEVDL1BaOGQ1czloQ2NyTkN5Mm9mQktOc2lCWXJNNnBOSU1OTFF0?=
 =?utf-8?B?YU5talpHQUY3V0lBTmtRTjZrK0hZRCtYMXgvV1l3MFN4SUpOQ0hkVUZsTFZi?=
 =?utf-8?B?OXBZaTZldjUvb2NmdStZbzBwVmhtZkJjMWdqOGF1TDJEcm1jRDNWdkhFMjJz?=
 =?utf-8?B?dVVvdkNVSWtNbVZUQ0hLWGpVTExwRGJuV1lIejNFN2V6bEMybTROVVpMeTNn?=
 =?utf-8?B?ZGYveVlLeDJ6USsvM3NnUDZ3a3hERGxNOGgvbDZNN2ZjYVFjcWlab1U1Z3ZB?=
 =?utf-8?B?ZjNGdUI4U0lNMXlVZ0RVakg1OGI2bG5INWkyZEF4d0o2K3V4eXc0dXpXWkV4?=
 =?utf-8?B?M2d1eTFnUGkvZ2dyaWRsemdHSmJyZlJGRGpBVjVhQVlVeXhlMHZJSjFaVm8w?=
 =?utf-8?B?MWkvWlFKV2tDcW8zOWRNWGx1b1JaNGxWVlltT3RBQ0tpZ2lGbVpKWXkrdkxJ?=
 =?utf-8?B?ZDVZT0pJM0w3SEtXa2JrUkJzL2VuSU5KZTAzYzNhVjlLL0hmM0xNQStMN3Yx?=
 =?utf-8?B?dmlDOUNtemhmbWxXeGpmUkNQdGJLUUZ4NXJPbzFUdmcvWkRwd1M2OVY0eE9j?=
 =?utf-8?B?cGI5dlBQSXdrWll3VHRtaTRZTFlYS3BBZWJvclA2TiszaEhSSVl6blV1b2Qr?=
 =?utf-8?B?ZG1UOFdRYVBLYTRMaXVoYk9XRE1yOGVuVDFxOXkxWGppbThleHhDazk3YmJw?=
 =?utf-8?B?dzZIT0czc3VWeWpwNXhaYjRnTDR5Ym03dGIrV3k4bjNLVkdPME40M2hiSmNo?=
 =?utf-8?B?TzBjbXBhUnlhM0FMQTJKRnpPVFpJYXVOSXZXT1d5MnRZdXhoTmhncmJNSDlr?=
 =?utf-8?B?U2ROS0tzeGVmMVpZOXZqMXQxMmlVVVBMQkVheHJnU0t4Zlk5QlVUQi85UTAz?=
 =?utf-8?B?NW5LSENKU2V3dVRNRVM2TTNETjBHdFRkMmJBWTc1SjdCNDFISk9YRWFhd2tO?=
 =?utf-8?B?NDdhK2NBbE5CRk5jak1mMWlnRk5GK2VMVDJnb0F4d3RiMHM0NzlhbVFQK3o1?=
 =?utf-8?B?cDFOLzBuVytDdlZGcnhORWpXTGlZNW5jbUVBQllacWpOS21iRGdMT0N6Rjh2?=
 =?utf-8?B?RHE4NkdiZ0x5dm8yNmU0cGt6bzhmdUpFRno3VENhQ3NmRVJWTTdiN2w5TndL?=
 =?utf-8?B?ZExtUFp5UXM3RTFvWGRZQktPRnJ1clB4K1NJbzA4SnZESEpjc0Juc3Z0V0Fn?=
 =?utf-8?B?ektUUnUrZjFEVWFKbjFIS0VpSUVNZFdBdW9NYUtUbGNDcHV6VmxHK1NtMStI?=
 =?utf-8?B?aElVNzdCS0N5R1FxMmlYclFoNHhJcGhPQU1iTHVwV3pxcVVIYWhIeEo1K2FE?=
 =?utf-8?B?VjZScXJVdkl4YStvVFVMaTlSSzdmSXBjZ2Yyc2tKTUl1WnpTQ2dzVXdOVW1L?=
 =?utf-8?B?ekZTZ3FZVC9kZGFOVkpIbFY0UGQ5SzVMVWlOdS9ydEtWeHJESDVYWVpMeVJl?=
 =?utf-8?B?RXh6cysyNTQyV0t3SXdpU3FwTlI2aGJ3TDFCbXV4WW53SjNvckZSR3dSN1d3?=
 =?utf-8?B?b1o3RjVaeWVUcEJIK3lkandKOWxuUXV5Q2kzMnFrVFBMK21GMEVvbmNIamty?=
 =?utf-8?B?R2llekxES3pJZmVmdGswbFRDN2Y2NVQ5bkF6MTBuWkNXOE1HZElYa1pENnVh?=
 =?utf-8?B?Mzh3WU9HcXVQYUdUOUQ4a2RTV3B4MjlhaHN0NEpLcTd0VmQrVXU4T3pWVk9T?=
 =?utf-8?B?R0xIY1IyblR1VjZFVTdGem9STHpXV2g0dkRrVUxzQzdDYXpMWjBSamRxNExD?=
 =?utf-8?B?cVZtUW5QREpZVVFFM3JBRDg1Z0VjdlJlOW1yeDRBUk91bkZGL3dOblFOUFdX?=
 =?utf-8?Q?2gbBYgW6EJynzBdSdP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aa913c3-afa2-4e99-6c15-08df24e0d5b2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 02:06:58.8226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbP8pUvi3SVdimkI9jcXNM3cC5aIqF59pEfQ0m7A5Cy1wjZoVBjlncsm4Zbnwati
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LVUPR12MB999135
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 96E2D160005
X-Stat-Signature: 5egm63kuay48twx1qtrxxojqpabwm867
X-HE-Tag: 1791425342-513633
X-HE-Meta: U2FsdGVkX195fKCuNM7E7Ll18+swC8l6xzaLD/ApSD7BmQCVAumw9MS2E7KTOM0BjcZyBPNZkhCy1Js8etef1vPEI11F0wGrxY9VDUR6cNqvhqD7MpcUUJYYE5Y9pq/+FPeUSN0ObGGeVsaPW0O6LQgbEu3uA5uuMtx3aSoFBZD0arW7220pTbkzEkRQqd5n1VrigR0l2QfBzgJfw3bygBVv+g8VpCVv9vTAw+N3Jxo3uL41yZAaPgp+UvsWSUWhSYt6Z+6wr+RJgisjJkX/cuhmGbeVm/e9fehrB6hFcwQHc4Gmp/50Jq9L31Dxaups9fiVQplmQboQDz61Z/vvSexAlXj7UZw3sdjilziMxQaJTRwrrPlrNH6bQ7AZoidMt0ombj22Vt6et6BtVzj2LFx0jmN6K94IJjtHmHGtZUk49JekE3G2aLUgKGopyTcbWWNDd/E9kjyjRi2CWDohzoSzgsMTLhK3BxgoP31sHE7/c8pp5vCOIZufoYqVbvLB6PaYA/J9EYaeAMHRltDrklriTroyYjI85MNWhyIVB8ZqtQHbuxu637NE3d6tIeLk1folv6bWUSSzGBshmPA0O9nH1rllhZGvFe08pi0OtmaW0MNWwswY6/JD8aCoJwaF5p4GlpKY6Li/ByWRmMD9SlzUD8iSVnSnvAGbL7u2jpOzi7MdW1xHbo7M+inGctjK/KC/lxuB7pxWtmWxobDzbvCpboSg6sA1HCDT7NZ5rGRji7eUN6bOsxxqKGxBSPD2+w/7DhBS/tDIGsjjRcXM9jt1HTeiHqv3XxcsGSDZSfQGw8io8AtqmO9JbFcxw8rdVdl+ezeydp9UngnvRah9SVv73zbx950kMoOl9Mb5LVKnUL1hQVtec/QEwBuDN85WRR8KALFnA1tqPkByNZ3iwztzalZzBmzEcgf7UZDNQ5pCt5KCOwU11VEQ/zv8FzidYyPptkcNatN02KqnCiK
 Z0IrpW3d
 dWQ+pJQf0QEdUAyucvT9MqMjpCSvhVYj6OvRxADPkSFnq5F/syxzgczASEqw6vzYsA6TnwG6waB5i1797Yxd6G6d5r3UoUUMB+/00M1y2rrsQEc0HM3J1/XFFYu4CJjR08sTUGKrHQEEvrowHsvDkMgChjqWlRXr7nLxhdfHTsF2EpytQTnQ2MhrLEey996Qr1x0YJvuBPpyRRxP4Yq7hC5dUFsimEaJ67GNQbKGxefidOOmwarTIP3r1wyaOqS6IOkvaV87UWKrBQGZMUVvjMIK8zNBKJHoU5W5M5C3y7IF+J9+BE66A/0izy+GxAdzSk3NbMWMg18PiBeUNhGJoDHrLNPuyPB+D5nsV6hFkKgAQ6A1sqGGazXbwyc5LuJrNkvv46LPVot3AgjBTqz2kVKLzyftF29V+AZH7uZGy/6sRurc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Oct 2, 2026 at 5:52 AM EDT, Usama Arif wrote:
> Reclaim splits a PMD-mapped anonymous THP into PTE-level swap entries
> before unmapping it, so an ordinary swap entry has never had to appear in=
 a
> PMD. Prepare for installing one there instead: the softleaf layer is wher=
e
> every consumer decodes non-present PMDs.
>
> Accept swap entries as valid PMD softleaves and add pmd_is_swap_entry().
> A swap entry carries no PFN, so make pmd_softleaf_to_folio() warn and
> return NULL rather than interpret a swap offset as a page frame number.
>
> Unlike migration and device-private entries, a PMD swap entry can also
> carry the swap-exclusive marker, which softleaf_from_pmd() has to strip
> before decoding. Strip all three overlays unconditionally while we are
> here: each clear is a plain bit clear, so testing first only buys a branc=
h.
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  include/linux/leafops.h | 40 ++++++++++++++++++++++++++++------------
>  include/linux/pgtable.h | 17 +++++++++++++++++
>  2 files changed, 45 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index 7c13c58a5e218..ce176c78cefd4 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -98,10 +98,9 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
>  	if (pmd_present(pmd) || pmd_none(pmd))
>  		return softleaf_mk_none();
> =20
> -	if (pmd_swp_soft_dirty(pmd))
> -		pmd =3D pmd_swp_clear_soft_dirty(pmd);
> -	if (pmd_swp_uffd(pmd))
> -		pmd =3D pmd_swp_clear_uffd(pmd);
> +	pmd =3D pmd_swp_clear_soft_dirty(pmd);
> +	pmd =3D pmd_swp_clear_uffd(pmd);
> +	pmd =3D pmd_swp_clear_exclusive(pmd);

I notice there is pte_swp_clear_flags() and wonder if we want
pmd_swp_clear_flags() to match it.

>  	arch_entry =3D __pmd_to_swp_entry(pmd);
> =20
>  	/* Temporary until swp_entry_t eliminated. */
> @@ -634,18 +633,29 @@ static inline bool pmd_is_migration_entry(pmd_t pmd=
)
>   */
>  static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
>  {
> -	/* Only device private, migration entries valid for PMD. */
>  	return softleaf_is_device_private(entry) ||
> -		softleaf_is_migration(entry);
> +		softleaf_is_migration(entry) ||
> +		softleaf_is_swap(entry);

Using softleaf_is_swap() here makes softleaf_is_valid_pmd_entry() return
false positive when pmd swap entry is not possible at the moment. Adding
it only after pmd swap entry is possible can close the gap. But the
whole series should be applied together, so it should be fine.

Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8173C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 19:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6796B00D1; Mon, 13 Jul 2026 15:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78126B00D2; Mon, 13 Jul 2026 15:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F516B00D5; Mon, 13 Jul 2026 15:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85EEE6B00D1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:11:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A75E4017B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:11:08 +0000 (UTC)
X-FDA: 84984696216.16.A85A9C6
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012058.outbound.protection.outlook.com [40.107.200.58])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3812F4000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 19:11:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jlLUqi3h;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783969865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3Id9jusXDQvaJF0y1HjExO+OCdaafgx569gc2cYx4k=;
	b=vuGgoeo7ca6PFpGxq9cOGhLOZAk6tQpHfuw8wR4sRFU76wfGhqL2V028yD5kIyKck18MRI
	csfG3pRsaAHVMXEkmYQV8Ykl+IfqvvrlpV7k5Aof0tPb8eRUGnrBoLrW4mBSIXeUzCDiLL
	EwwQqSOzr1dGXjzQU1NuYR9HsQ/qv64=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=jlLUqi3h;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783969865;
	b=qFjVvs2r4Aq+P90CGAKQqL9FLMvLGTOFvdr/cDKgVDODFQpj0LsiYqnStPf6CF4pO1ECJQ
	VDPVetem6lp446fy0WG0lSc0m3CbyOblSTjp01C17crbMciTcP7PpF7jZXSLVbU4pNtuiu
	QZY/5ysfdXyvlHsySsKkKexhSlmILAE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nhNGgaEs9L/abujMbXlYjS+zXj2oWLe3OTNy0KSbhRPBwjz5nIipYq5emvFq5nVuIgM5e9U/iRg8Yirsu8N+oG+h2Xr0DpomB0eEx6fVBB4Rr5umMH/TlNDiR6JBxa/GVJpDzAT3xwA2M3/Ez/8sjg390Sa7jMl35Gxix97MmzH55uZ9eWeW6LufkA9BGb2d1+IJtD7qZMZxA4z6pMoM6Lfv5TUXie4cHP0iy7ulRgcOxdSmcWf7U58Jgmt8VuOVOFmn4S9GHfFV6NxZZKasy7jmpWLeTIALSic4w42Mlz+Go24OKvP36Cg6uYw1nc4DvNHTtqEEJn5yL4NOcLyR0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s3Id9jusXDQvaJF0y1HjExO+OCdaafgx569gc2cYx4k=;
 b=pmc5Eg/lJBivhWpdyaffmdId04JW5WjlrwwzsYqDQbpWVhzq3dyWBhHz/LY15m4RRbvkn2052xRu5zEr3f0Xefi0N9I64meoqYryBUrh6vbOnLS/o+m2w+wUXyPbHQFrjN+3OS9O0eGZ9cCrHxMTxDg93DDRXyMvxQgxLROC81Xn0jUd1+YSVW/Jpo8VaoS98wxMzQ/F06fw//miCFJmjxV76Q3NGcpb6jUTBbd+tTeiZgcvUdTtIIqtE1xOOu3qf6HIO/3RrfIv2VzDgpSqt2DS8xeafiET75yYfqw/AJpqx2arm6QJ7OF3044wLID8uDMP6HoR5puzI2Zaqtt9pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s3Id9jusXDQvaJF0y1HjExO+OCdaafgx569gc2cYx4k=;
 b=jlLUqi3h49zNeqGFqG35aVR9lQZf/eppRyJtjxQx00mIcIDIAXE2dheClyUcN1tFMRwCDZoxzp6GfKsgmHv5UuCqioScIb8oJlGeC4YHRT1ZZwJVUCiyioCIcny+s4rhBY7E3D7wcVASaIO1ciaT03Dw57p0TIBDYZFaJbsmm67bK5jHnnMMVaQvsdm0ACHnFA3C9e8Y9VHt84z+wlLalXkCPmYy1rXgvqO7jktK6JaEazb/mtT/eWjGac/KUaQfuuHSHlHk42G0kYIvs1/4mBvNf7dufro5M7N6Yi7/7gYy5r+mmbzee+ked7y3Zd96gyGlYQppgJGJRRqCgFy30A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS5PPF5C5D42165.namprd12.prod.outlook.com (2603:10b6:f:fc00::64f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Mon, 13 Jul
 2026 19:10:59 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.019; Mon, 13 Jul 2026
 19:10:59 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2026 15:10:56 -0400
Message-Id: <DJXOJAAJ6138.3UWVKY17QCS4G@nvidia.com>
Cc: "Hao Zhang" <hao_zhang_kdev@163.com>, "Hao Zhang"
 <zhanghao1@kylinos.cn>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
 "Nico Pache" <npache@redhat.com>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH] mm: thp: pin the inode across a file folio split
X-Mailer: aerc 0.21.0
References: <20260713170915.239819-1-kirill@shutemov.name>
In-Reply-To: <20260713170915.239819-1-kirill@shutemov.name>
X-ClientProxiedBy: DS1PR04CA0028.namprd04.prod.outlook.com
 (2603:10b6:8:243::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS5PPF5C5D42165:EE_
X-MS-Office365-Filtering-Correlation-Id: 114225df-488a-4cf1-c3a5-08dee1127904
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|56012099006|5023799004|11063799006|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	puRxKGjYDQtiX++S+0KK/wwjPRhOR4ZpMT10JPmoWzSqhGGOBZRGPt8Mjw+glCHYbMlKORrVn0QWcHFBRTmKUoBgaT1uwqiqfaaIQFhe4UUeTTs0slCMfmFOsgINHzeEjsIqrQbD74Td+gphPS/KDt3LS2od1UOD2wT94oh9xgAElxcvFA2KCG69yN46BDU5rm4NvBgTGtHxpjMAl0fXwlkVZ/LvYCSA2HY4enA6NusYlq4zy89ZmrP0x4my5ZLSkr/Oi5FNvbl+/K58/iNdO6KZpCQRLl7YWgXfZ08Ke/kaZm1N+hn1ciRTH1pkKaRxX+ITWKMnJNRL0G8SAoF8HFfp3mtIAPNSrUxPBkehGV30/264nCeKtE6uwqxjvIQnNYDby0TshHaOZ27g2MPAVVSza8IuFQSq/osuJmgMjFWlsSWos5yE6ZL6GQ9KU/DX91l2dE/TBWPn5nCHNJRgNNTvp1SUAEL31utKXShC9UhX+Dagy3vUtTuz7KrXmgLXJPg4BCI/GnqUUjWg36mkseV/8kL0W//ch1nqksISYVHP4zxzTljHBxK3OzGCfPLwPosbSVF2eL4McWDbwfa3GJ16luU0XkH9wcVu14MdVYi4c84dQpumw2BPD28C0dpSx2pXf9tKL172SbPFBL/37fHHNdwi135r0kW68nTOLV3EWMNGZKsnm0CyfGynWYdfeysD1XgZFTxjW3nHCXYolQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(56012099006)(5023799004)(11063799006)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bGJ5OWErVWN3cVZQVmltK09hN2taRG9zMHpOU3lyWWhLdUs5SUdBWHU5YTB0?=
 =?utf-8?B?akJRTVJJWFBDb3cybHc1bmkvcEtTSWpmVWVMWXdyRzFvd0FzcjV0ak1QT0Vx?=
 =?utf-8?B?KzYyN0ZvaS90a1hJUjhzU2lySDVJbFRBcDNOcXFXY2FEd0d4RVNCZjg1VGNt?=
 =?utf-8?B?eEpkVmZ2TGF4NkRLazhzemtkZExCczJqa1ZaWWFRUDBkaXlKWGZaOUYwWHJh?=
 =?utf-8?B?ajJkT1M3N2pwdGJSTjh6V2dsR29oajhtT2NMZkdRVXNWWnJzMGdFcFRKcW1B?=
 =?utf-8?B?dkUzb0tsYU44YUhsM1Ivak1leTRQNHZuYkVOTGE0cnd6NjZ0c0h4RU5rdHRn?=
 =?utf-8?B?ZTVTRlUzVlpUVVcwUHVuekRUaXZ3ZE1YUm5SNXRPUkhyYmM5RDBaQmUxVFgv?=
 =?utf-8?B?SDhDR3hHclJFOUdjMy92QWtwckdvNGlmTmdEWHZlemloa25MWVR0THg1R1ds?=
 =?utf-8?B?OVkrWkpmY2lnSk5RbjF6aHlRck9janoraytoRHFUZ3RZWlJROHkwd3VodmF0?=
 =?utf-8?B?UUhnaUo2NVMwSVlJSlJVQ2swalQ5RmQ1cmNVWEJSY2hvckVDNndNYXAzUmc5?=
 =?utf-8?B?TGtRMDFCckppbkplWjZsZStnc0ZqUGpsV211c2g1ZERIaGNJOUdzU3pKRjFH?=
 =?utf-8?B?RHhVK2NKQi82L2UyUEpyQjBYazVwbEpKaUZkbCtFNWpxSCtsaktRdzFVbzVm?=
 =?utf-8?B?cWYzT2FUNks2MkhkMksvc1ltR3FGUGRmY1NPaTFxR29iYkxXVGVMendkWEVX?=
 =?utf-8?B?TFVxSTFCOW5nL1hJQzBMeW5VWkFCQ1JlWDBXR1cwUDlIeTNNRGgzdm1BeGxk?=
 =?utf-8?B?V2xYR1ZMSlZHSWllaHMxTXFmUXVRb2R2M2NqK3k0YnZMeSt5c01FaHZodm1H?=
 =?utf-8?B?V2NOOWNXK2UweWEvNVU1RUpVWCtVM3Q0b2Z4YjZCZGRMeXI4QmJBL3d5aC9w?=
 =?utf-8?B?ZjVMaDZkQ3pTT0V0VzZaWDc5cW1LcXlPSjdEOXlSZ1Niem5YYkIyakZxWmU2?=
 =?utf-8?B?ZGRiR3lxK21BNE8rYThlRkJaekJuUDZzN1JZQ2cyd1YwQjlDK2kxZGF6R0o1?=
 =?utf-8?B?SStCVkpMREhSL3RKc09LZjFCelFyWDJVbTV1UTdhNWZMWVZ5dkRzNSswWit2?=
 =?utf-8?B?WVVMM3VMQXFmc01ySUVuRDgvb2RGTWtxajhZV1FVWGQvVHBZSjQrTmRlUXYz?=
 =?utf-8?B?Mm1oQng0ZUIzWEZPc1NCU2taT0tKdmZWSTRHQkpDMitNYVVUZlh0R1pjbU52?=
 =?utf-8?B?V2NyMEwySjlrZmJTQ3VNUERWb3E3clJqb05tWFgwSVlFTDB3SnpzZ3JFYnJO?=
 =?utf-8?B?SE15WHB1aHd4eXllTkhicExuK3JNRWorb0R0OEZrNWkvL29TVzJmaWg2Skgy?=
 =?utf-8?B?QWdLR2pRcGw3anFMc2xqU2w1dE9ScXp4Uk0vQnd4K25pbko3Vkw2WGJxU2V6?=
 =?utf-8?B?dW8xRDg4YllpRGlIUE5GVHhBUm0xanZjMk5pbGVRWmEzVld6K3N5K1BubndH?=
 =?utf-8?B?QzNxTUg2bEwwZytVd1RIRmNGNnZnVWhtM0lBdnJoUHlPcFBmaWVYWFNWZ0d4?=
 =?utf-8?B?OGxKMXJMWmFTM2tMRmtIZm9FNTFOTUFLbzNTVzVMdkFVTWhQb2RXSjgzeXJh?=
 =?utf-8?B?UmI3bGlucFRNOXFtYTZ6ZlRVczNXa2lNTGcraWhhaHNvNlorSTgrcGdWNW5v?=
 =?utf-8?B?VTlPL3FadUd4WVljcGlqWGhONXVRNVM4TFpza2dGbDdVTVpMVFhqUUJROFdS?=
 =?utf-8?B?eWt0aDhTeEVKYXlTSng2L1VPU3BLUnRyZytTRFB3TzdRZi9mUXRDRkpTVUxT?=
 =?utf-8?B?YnlTRFZhbC93VS8xUjVxcXNoTFQ4V1M2Qm95b01hbWJhRWhmZlBwcDlSN0lW?=
 =?utf-8?B?bE15U3luQXZ6Qjc3cGEybUFPelRQMmNUQll6bVQrN1hvZDZwY0hHdFJkMTRw?=
 =?utf-8?B?ajFBUTN4UlI5MzlaekpRc2hYblNNbktZdnB0ejZocStIY0JHNHRVV2dlT1Z0?=
 =?utf-8?B?MUE2QlcycTVwdi9hV0h2OHdEN0IxWGFBT2J4NDJsVk8vSk5mNnRxczNKc3VL?=
 =?utf-8?B?YmtqNmJCb3lrRHRUTldndmF2VmtsRjFBZm9rV0lDcjhLcDRUSHc4aXlQbXdW?=
 =?utf-8?B?ODJkY2RzM1Y3N1J2ZGQ0N3J0d0xYZkluQjRrQVptVDJVd0xzOEtyODFsWTFU?=
 =?utf-8?B?RnozQjhLMkREbmVDbzZUK3J5RXI5R0t5cmp1M3lzU1FHS0w0MUNPNWRaaVBG?=
 =?utf-8?B?VnQzd1pqZmJ1UkhuS0dmaG81K1dObWdOZEFvRXgyMlVMOXJSZnlLWVNhejdr?=
 =?utf-8?Q?7PSor4FN6nRV71GNbL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 114225df-488a-4cf1-c3a5-08dee1127904
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 19:10:59.0864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: acbW+TEcGhgkaUIdwq0zZFDuczgUmwOzf9V/4d4dmojtkxO2Yz2naO/ArMQe8iBf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5C5D42165
X-Stat-Signature: 979xak977dyjdpt3zogmsu979h7o319e
X-Rspamd-Queue-Id: 3812F4000E
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783969865-48162
X-HE-Meta: U2FsdGVkX1/j48yY2PrbMDRvLOgnmWdy6gyernxoqAGbPovdpvWGTQOaiitk1y9Utl8N3qmFarymZ/CU3nxhC+fm3dWvKbBEhJDdtjnSVBDqI166YfwqE7eqxSROX5eIwnhl9txtDoZjmMlK+ANgMq//lZCfD4eSL7JBcgBipzJrxTjx0ezvYblJuvnpArHtEOzyskKhDzKpSqYthgcdViZ56FrLXR8L6ERVQMtK4+qqejVCdfdLl+DYUGPSXWg1HLRrQ3YApwz94geq9GlNySUrtkr0Ni+L7p/a5n2x4ck64ws/MOQ8Wndxi87L29P5/OP4sUcLiXaVF5+8YvBdg0TI0E5maOr2wcgO6Em/Y4MKB6quqMSYNzvGbG3SxlANWluwpUw6CWcw0xdLhvBEhAQ35hpnZT7R0u93bTbli1Ud59WSgrKQnj5WRnP1txo2SleV0a5o6hlj+7PJ7cJ9NFpfQQB+szjxoNVYUQ3wJRMa+m4qFLAvpLVzeBD4gWqipyjBb/chwNyWfekdyZxWWHNgnHk3a7Q4eMGXcnnbvHInTPKQWVqBT0gEkOw1pb007tXjlTUuNh7VqCy/o9LxdVVYtT95X1ybZhVlyhUk7+IWFIgnon2vjIGpJGIURwDAzJN9Nq4PXfqNaxMNrSa/3iKbBkyufpMzu6OcGwsmcqvutVTo4nNzP3+ZyE/NgBazgypMDRt7RPoqwtWqEhcgvhyfkUJo8BKW5SL/jijimopmQxzHVSE/BTvSJf5F1u7LyUmV4clURIh9zUnNocFDlMv3LoqqM7fi91/75clawTPwwodTv1W0DHuExB7W7qATM3RcwZc6J5k0LmS6VSPTyx721UppmIBYtgNnKQjsLRRu6neQbZN00MmekPBPWB55AbPWcBKgLbxb6rsKfMvS9GXpjcQDaaC0zmjAu+DjKYpDIvScSYnPNc37UZss7+iSSyucJggp5FODUUKa1F/
 mGGRPO+9
 aYm+clzHexQkpOvLwIlMKsBfDLc17D/pL5ew1DaT3ar4Ty1m43m8e/+qRiHsK4bXW+AFzXVv2MPPl7GlJPj2tfciBMTdgHeOhPLwYJ3DMka70FFVB4Swpug4xZrvWc70sfbL9iB0kCgtMhe/JO734lXexdoMwSdXpWYuXQ2CwLYCWLeHJYmEo2+o0S0nV4eEe9KWesHNl64/ua3jbj+SvtqtM8790Qtm/jpQeuPcOtUEgf7348f0AyML7j7VSDPEYEgvpGNI6vjNn67tjYCPcE4wPDS83HUM/up7y0qauEvrYIXH1jiyNE8r4AZKNwsWInxTkekaKkHNuLNXGEzn636kkUtU3QuV41XLkfRzQmwj1XcNaqRFSvmr51s5h47Ff9EJ58iZQhxSqOiG7umUzQ/6kAqkVlIRFybgfi40jV1GBRbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 13, 2026 at 1:09 PM EDT, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kirill@shutemov.name>
>
> __folio_split() looks up mapping =3D folio->mapping for a file-backed
> folio and keeps dereferencing it after the split completes:
> shmem_uncharge(mapping->host) for folios dropped beyond EOF and
> i_mmap_unlock_read(mapping) on the way out.
>
> Nothing holds an inode reference for that duration. The split relies on
> the folio the caller keeps locked (@lock_at) to pin the inode through
> the page cache: while it is locked and present,
> truncate_inode_pages_final() in evict() cannot make progress. But the
> split drops @lock_at from the page cache when it falls beyond EOF (the
> @end handling in __folio_freeze_and_split_unmapped()), while keeping it
> locked for the caller. That removes the last pin, and a concurrent final
> iput() can then evict and RCU-free the inode before __folio_split() is
> done touching mapping.
>
> This is reachable from memory_failure(): poisoning a tail page of a
> shmem THP that straddles EOF makes try_to_split_thp_page() split at that
> page, so the dropped @lock_at is the folio returned locked. The result
> is a use-after-free, e.g.:
>
>   BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
>    i_mmap_unlock_read include/linux/fs.h:537 [inline]
>    __folio_split+0x732/0x1640 mm/huge_memory.c:4100
>    try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
>    memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470
>
>   Freed by task 4601:
>    shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
>    i_callback+0x4c/0xa0 fs/inode.c:326
>    destroy_inode+0x144/0x1e0 fs/inode.c:402
>    evict+0x57f/0xac0 fs/inode.c:870
>
> Pin the inode with igrab() before the split and drop the reference with
> iput() after the last mapping dereference. igrab() returns NULL only if
> the inode is already being evicted (i_count 0 and I_FREEING set), which
> a split racing eviction can observe; there is nothing safe to split
> then, so return -EBUSY, which callers already handle.

I was thinking maybe we could move the EOF folio drop code in the unlock
loop to avoid the shmem_uncharge() issue you mentioned in the Closes.
But that hides this implicit dependency (I did not know about this inode
lifetime issue until this patch comes out). So I agree that an explicit
inode pinning is a much better solution.

>
> Reported-by: Hao Zhang <zhanghao1@kylinos.cn>
> Closes: https://lore.kernel.org/linux-mm/20260710071344.GA106129@zh-pc
> Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kirill@shutemov.name>
> ---
>  mm/huge_memory.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2bccb0a53a0a..9bfa3a879453 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3982,6 +3982,7 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>  	bool is_anon =3D folio_test_anon(folio);
>  	struct address_space *mapping =3D NULL;
>  	struct anon_vma *anon_vma =3D NULL;
> +	struct inode *inode =3D NULL;
>  	int old_order =3D folio_order(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped =3D 0;
> @@ -4053,6 +4054,20 @@ static int __folio_split(struct folio *folio, unsi=
gned int new_order,
>  		}
> =20
>  		anon_vma =3D NULL;
> +
> +		/*
> +		 * The locked @lock_at folio keeps the inode alive: eviction
> +		 * cannot remove it from the page cache while it is locked. But
> +		 * the split drops it if it lies beyond EOF, after which we
> +		 * still touch @mapping (shmem_uncharge(), i_mmap_unlock_read()).
> +		 * Hold an inode reference across the split to be safe.
> +		 */
> +		inode =3D igrab(mapping->host);
> +		if (!inode) {
> +			/* Inode is being evicted; nothing to split. */
> +			ret =3D -EBUSY;
> +			goto out;
> +		}
>  		i_mmap_lock_read(mapping);
> =20
>  		/*
> @@ -4135,6 +4150,8 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>  	}
>  	if (mapping)
>  		i_mmap_unlock_read(mapping);
> +	if (inode)
> +		iput(inode);
>  out:
>  	xas_destroy(&xas);
>  	if (is_pmd_order(old_order))
>
> base-commit: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53

The change makes sense to me. Thank you.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi



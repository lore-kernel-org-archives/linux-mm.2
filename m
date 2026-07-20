Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEE28C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84E306B008C; Mon, 20 Jul 2026 15:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF136B0092; Mon, 20 Jul 2026 15:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C79F6B0093; Mon, 20 Jul 2026 15:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 20D926B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:13:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7AA4EA0264
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:13:00 +0000 (UTC)
X-FDA: 85010102520.16.0787E67
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011014.outbound.protection.outlook.com [52.101.52.14])
	by imf27.hostedemail.com (Postfix) with ESMTP id A8B994000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:12:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GjJldHT6;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784574777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GtDhRePc/d/7+vpcQuPWsUKy02vWVLss2qe86idKv9Q=;
	b=gQRGjcFf8rcwapReb9/2eUUY/XVIFy0HKJsx98B0VuD5KCKufyygrkfMzluoh+0XUYe4LR
	zLiCb1IwWbqVvKHSg0xWZ9kcysMhu+9JNgdRN+s1MhuDFhG/0Q5QJWZorm7z2nsZ0wWyPo
	CH2lxMdIGUyf3raF+VJdjAVA8gsMiE0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784574777;
	b=RNrs/w84uJHxw5s2xVvnDWPysU++4doGRX5hhgknCtsWxcSVFFq3kWSCzyoUcSSfOY8jYm
	FB4pybAkdkQ53p8Kvd2HdpInS5yR43IJAY8/1OsSzbABwdzx/Mr6Z3idWu/jFksdms9eox
	lsIELlWEDqruKua/cGK8vsKvQqlJAbw=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GjJldHT6;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N8IxTKxKhoY4aYEeefo2ildqncoWJKR3cFvjyNx0W77zb4/Hyu83Z49xkLwjbbu0nWqUzOa4tnIH3GYGdPpxLCRxIM1impjgKNZ6B0Dgp9TZUP1Z5f9MhSnF+X+khxjPPxzaYI7vu0v+WtaCISMLmtdKIClG+AJ+Omlje4QZg0BCr4DBUEhjLVXZKIqvBa8KU/e5lHhruunfYx7n6DPlsLKOrj2pxlt03duOeeQHXg1ecUwlQLMo1uHv3/c4Q6MX2TsA8a7dmBSP3KZGWtOZfkvMV/rRY/kGV34JJt1H1ya7evcH/Mseh8P9L2ErMrL5gGL8D3b7YZppLF0BaQVocA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GtDhRePc/d/7+vpcQuPWsUKy02vWVLss2qe86idKv9Q=;
 b=GKQgJJRngEbpqmWsoBk2+gE7WcI7UlKjoAfYWxgQSxQT2zrWPlFlSXp/1BzSPcAFMBky0SyP9oBIwWDUPwJ6bPMcR46htWvZ3Gx1xDBLowBOdUTKPBQWARvZqLoQw+5tNgBRLHe0cAwQ3ahMpKJm4jSZr18PXHvGQdkU5edFOGdh7kKaZbuUlWbHQdYBOgY5BuRrK091RAWKbn4BwpEeenjgbneXfFX1mjGA/n7Jae8UlHBIWG+eBbCFlVI0oj9aSkMXki6aaWWT3SaaZ5tANLvSokjvT8vZhLaxJMMWp3YW4Cq27hBGDjL6GmNwJTD2njiawYjahtOFbuJzW0zSDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GtDhRePc/d/7+vpcQuPWsUKy02vWVLss2qe86idKv9Q=;
 b=GjJldHT6/om6SSY7e22P0CFfglVCWidi7jkHIGPS+FgGakQY8Sp0eZe715bnjsM+7tj3YInrvYve0i4cEy/NmIuQpJmyy+VkGVnJzAR9fwO1W1uBLOKBGvQVFjqWXtrQezoCdcZKKICL1CgmE8Cc6Cy+W5SCXIbspATg9zjozlSrNsbKn36+TnGnaW8Bh8LJKtNxSrLi18fqRZwNBP5Jp6DrWrxntDzUSmhfObyXp+XmY1xOGoOtYg/QKgWDPSX4xwBnJvBUPkn0V4FVfAk9vgk0hLZ8LR93jDNP5RgqsZV2d+0tSEjhY7hNXw72kPOQvjTV7D5TMYawIPjqpx/lkg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB8980.namprd12.prod.outlook.com (2603:10b6:a03:542::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Mon, 20 Jul
 2026 19:12:51 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 19:12:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Jul 2026 15:12:50 -0400
Message-Id: <DK3MYJN8KSZ5.1U0STUJGETSJH@nvidia.com>
Cc: <damon@lists.linux.dev>, <linux-mm@kvack.org>, <sj@kernel.org>,
 <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
 <ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>,
 <rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
 <npache@redhat.com>, <baolin.wang@linux.alibaba.com>,
 <ryan.roberts@arm.com>, <daichaobing@sangfor.com.cn>,
 <wangkefeng.wang@huawei.com>, <gutierrez.asier@huawei-partners.com>,
 <zengheng4@huawei.com>, <kasong@tencent.com>, <corbet@lwn.net>,
 <skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <lianux.wang@processmission.com>,
 <kunwu.chan@linux.dev>
To: "Lian Wang" <lianux.mm@gmail.com>, <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [RFC PATCH v3 0/3] mm/damon: introduce DAMOS_SPLIT action
X-Mailer: aerc 0.21.0
References: <59292ba2-e0cc-4e50-bb26-be9c15843a41@kernel.org>
 <20260720095633.32281-1-lianux.mm@gmail.com>
In-Reply-To: <20260720095633.32281-1-lianux.mm@gmail.com>
X-ClientProxiedBy: MN0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:208:52f::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB8980:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b500aee-05e3-42b1-cf9a-08dee692e4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|10063799003|56012099006|11063799006|10067099003|4143699003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	rgvhRRLa9ZolsUp5r0voHcWRpkQSXLBNM4WIygbUtvEUfWBrGkWqnrsQYZWqUrxM/ECeoNJDeOgpHWCANUozIoAHapIViHF2FJziyRUXaEcAS/ZlXruTRjGAApSXDhHm4hUK04mvdHxRSuBKmSld3wGBMW6UftgipruGQ5rleVbd5UeIwmfv9Tx2W2nILi7aU/myJ7vHwHxL5HzRkWlZY/QDdUO2wpNUmwhypKBS6kNghYKNb9DARK6Bd72f9VnknFV0Qzb+lTzTme99n3d0SStQ16gXqI9j1CQoKfbfmZwj68ws6JWe+Gsjn3uslAe1vF6iRFPqAMQ8AAeWDK27q9yFNbXeW5kjegLSaWgbQMWdeN7d3+DaEIXl1yYK1xuWSP2ORB/DIE3wG0SMfjFKwFGvpFondyZS/FfrZfhT+63KeNuWYK55kkAEXkB4uPY8rCWnWzihV83L4Ry2f8kUGMiXfLiVc4O77PxFynlUBzmQRCBFeJOnPmqyrJSjYybF4UZfB0VE3CAIOVyRXeSIhRfhLg5sfeFp4REBvXeNYBsnJ4JLm7xDCoPR3JPFZM2rARD9tFwys0gIhSWKlWEtnIdYMVVmQi67gvqQYIfpmt765M8hGqMTre0fxe68Yvg/INRr87Df3VZt3aMH7mbokop86Gv6FyAuEYUYuUwXwn4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(10063799003)(56012099006)(11063799006)(10067099003)(4143699003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WS9JTGFQYXR5SG5qK2JNTTNZeEZEK1ZFb2RtalR2UldHZ0NWUkhkOVdSREJh?=
 =?utf-8?B?Sm04Rk9oYU95dWVlWEVCZFVzRGN0RGUwQXlObjNPcCtkeTNGanBNVTMrdWww?=
 =?utf-8?B?czNrSE9UTnJkV24yNk5ZenZFdnR4Qzg1U3JWa0RsVTZ0ZHpHYXBHRk11NzZE?=
 =?utf-8?B?U0ZTUDhrVlJzLzM2cGhDYXpEQkZSdS9YTHpib1grVk5pSk03b1YvckhGekJD?=
 =?utf-8?B?QnBhZUtGY1NiR25QaENrTERkcVR3b3p4RjZlQXdqblZqMWVEYjVZQlB6eWxM?=
 =?utf-8?B?c29ka2wxODJWQzhsQ2RPdTdlOHNGYXBnTlZEZWJWNGxuVmV0cnhtOHBlMXdp?=
 =?utf-8?B?VVZNa1R1TU1qRFdRTUdROXJ6NmxzZkdEU3Vkdi9jMnBxQk1Za0RiWStxWmxB?=
 =?utf-8?B?MjVPbVBEbzU1MU1naDFyYU5NT2FCVXNZNUVwYmtKR0JKcUhZZDB1MUR6ckh4?=
 =?utf-8?B?WWNHNXpDeUVKSkxWVUhPS2lSa2NwVURGSXEwQXYzclJUaVdHQkRDTHZVdVdU?=
 =?utf-8?B?QTkwV2tPTFBUY2ZNQ21saXJ1YThyYlh1YjdqdnFtU0dsQk1sQWJmU1hZQUIv?=
 =?utf-8?B?ZGM5ZFM3cXlqeFl6Vy9xdFVwS3RrbWI3TlZGT0NBT1NWeUc3NEd3MmluRHJP?=
 =?utf-8?B?djUxUWI2TkJ5NlI4VXRteHpKQlVBbTJ1QktYY1NiSUoyd3BPWWNiRDZrMDVp?=
 =?utf-8?B?WmZyUElMaHF3eVJTTTZOT1J0V2taZU9tSDhYNWJJVHREdzJpUlFMMnh3Z3Jp?=
 =?utf-8?B?ODZET29oYlpxS04xZzdjVCs2N05xWU80V0tiN1ovU1JWQ2hUMm9ja1BPQkM3?=
 =?utf-8?B?RTFLU1FEeUxYUEN4bVM5RnBLZGczZ2hlcmlqNzlXQmNqZ1dPRnJoR1l0UmdT?=
 =?utf-8?B?NHpLYUM4b250SVR4SFZITFg5TDMxLzZ1RUtSWGxFTjJwN0RGRWh1a29TUTlX?=
 =?utf-8?B?bmVXS3BMZDBLVzdBMXQrWCtyWXBoN2xxaWMwaVNMVU5yODByNi9lay9XOWVK?=
 =?utf-8?B?eFV0bGNqMm91dFMydjMzK0ZwMXVoN3FiajY2cWdBbENab2FObThqVnAwamRV?=
 =?utf-8?B?Mjh0bTArYVBKZzZ0T2ltSmpWMXRDWXBoMWg5ZVFOVXZSNUxBbDdnNEt0L1dS?=
 =?utf-8?B?VnJWQTVnNGtoMnpNb1FsNnhFb253UTRlYytoVWQwb2RLdUpqd3duRnhrcVEr?=
 =?utf-8?B?Q2J3dUdJemx4eUdMb0s2aC9SQXJ6WXR4SUVONy9OckpvbnAwVFFkdkJLK0NO?=
 =?utf-8?B?LzBaSjhtRWZCeStnSVBWVFpwME82TEpMaUd4VGpyMkQ5Tmd2ejFKaExhUy9Z?=
 =?utf-8?B?MGZBU3JjRjAwQWgrcWhrQzBoamdIVDdJd3pSWHBhYnZ0YWEyUXVBUUxHYmxu?=
 =?utf-8?B?VVlYbW9Xak40Mms2SStmZFo0UzhxcUhxWlFZNm51RUxucmtnczFQWVAvNC92?=
 =?utf-8?B?YUZscjdqYkt1N3hWL0ZaRURzbzgwMGswNmN4NkNKS3lubzV0aXM3dzdUNnRn?=
 =?utf-8?B?ZDZEY2tESjBvbitNSUxuUzF1VlFzS0tFWUJzR0VmQkcwT3dpanE1THVCWHNL?=
 =?utf-8?B?QUl6YWExdklxSFZVRnhPc2lhYWlrTVZIZDBpb1BiK3pWZHhBWWhGc0x0ZGJD?=
 =?utf-8?B?aFY5aVBVQURxbFVjanQ1RUtTZmVmWXBnTDJ4eUtpWWdnV2J2R3A5dUhWbUR3?=
 =?utf-8?B?MUJqL2JPQXVXZk9na1ZwSjd4VlBMWURQemk0R3ViQitCZ0hGeTA5eXplTzZK?=
 =?utf-8?B?OVRqRTNHeld3NldsMmVOUVNDMHB0ME0wdWY5T25Ob2JVRjlURFdQTkpreUhi?=
 =?utf-8?B?RTczWkw5UlluczBoY0x1RWNhcGhVVDEwQ1ZMUzFoY2lPN1pyVTlyblcvT3hT?=
 =?utf-8?B?MmdFVUlhZXpsTTJ4TzJPVXpRc3VQdVh2SzltNE9OWmh1V3UxYkVQa2lQWGlL?=
 =?utf-8?B?V0Y1a0lnSDA3N2o0RkpWbXZrK0R6M3hjdlFqN0ZBZ05veDRpclhYdit4RWxB?=
 =?utf-8?B?Q202bUxDTEY3b3VNeUtjb1MxRGJzSDExZ3pGU1VOdWZrK1RnN1lPWEU1ZW5S?=
 =?utf-8?B?aGhpTXZlNEo3SUdaVVU3M3E5andvZHM1Y3VtbGRxWEFtbXpVeDZubmUwd1pJ?=
 =?utf-8?B?YW82cnIxbHNrOVRTenlkUC9IZXV6a3FqVU0vV3VqUno2Qm1DUVBFZDUwWlJv?=
 =?utf-8?B?SG45OFJ0Qno5M0hmMUYwa1AxbWw1WVk1YmVLSVhsd25YNUNDb2FCV2hyMUMz?=
 =?utf-8?B?V3V6L2c2NVRPcGplNTB0VUJWVDZNM21DcTRmNVhkc1NqbWNsL2Q3TWtEYkh3?=
 =?utf-8?Q?tEsp/VB8u2yhGb25HO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b500aee-05e3-42b1-cf9a-08dee692e4c1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2026 19:12:51.1813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xVf4l0tWD/JojKbbsQlQZAFygabG9hlQIKUxQtA2golQKVCDQgSpR3wer/2+RkpF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8980
X-Stat-Signature: mmpogdr656fx5ahph15iasjnzkioztou
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A8B994000D
X-HE-Tag: 1784574777-168168
X-HE-Meta: U2FsdGVkX1/SVqHY8mbDcI+9sCk8BwcCO/UZe3Ok2JIGGGbeklmrIYfhZPkzWyFMby8G11BG2LAEl+KnAGmWg776Dg9XO2FnqsX5ge2zcwSEtAo/I0GU6ZiTXZBQFuuaSrP0D0rgQMQwI4bginBn8FwV2AUxHPoNFPjWC9wdk1TOaNhnHWCtA5Q1vfR5lriX0NFh3bSBu0kW1FuI8g7krQnmF9v2YCQ/9jY08jPDSPTSIImLmfAgXl1s85DFH0gyZF+SZDN63/sWjHelVjoQOBAn9XAIqgTWD8ybz8RjFtpnwlHtlbvaA0rRGSqcwrRrao/qEACcxt3YGXfO3WwVBMwtEUILPo9XUbVDNYG1q1DLam8mrUcpmWGJCwhvlmjVxUBwShq4+Zrqpdp2szkRJOPVa1I0riCCwNSCEMQLx8r4h3GQ/JLwYKS7EOY5wjy9Qp4lRBzd849CQIXrMOQiEWCGtycUrQ7zjd+gSxP64DnT8sCc4HsKM0mMBvKVUNAw0isH/ik4FDpi3FZtlT8d+YCp5deSxlrk3xF6P4BJpKQRctlj/EgxTTNsRXEuwtrV9KGJpixTpfFTDCgne1+UPFyUxasrO52X5wq0x9CEQbT+006jOrQVnDE2AUbcrR0RRyydoiuguBSDytRXkrronH0DsKaqWHiX8pnHJYFCwtPSo4ytvDr5odg+mUR1zRfhBrZ8Pdg1ViCxjgE3wzs6NRA5dNgD+zrB7pZkxnO7NvuGDuzdbMo1vjjPLljJddRRmF9zXN0bqbXy+Hk+sGVP4uAhCFHxz7MLCyIhMbJFQr9UCOVhec/QlFzt/ndBYEjB0/QqAjcq9lBA3WBXzN2LG1/V47aWmES1+jtuQPufcmtVdPMComWuVRjgqDWGh6tXzmVakt5jkXCiXIJ4m84K6TPdkvTZwwbSNRq/nDwM+1Grb9iWwTDeWyG5WIfe1rpThcXz+rIUQZSjtl4c6av
 nYGj8ih1
 mC8Tk2S5zXjn7RWIz5FjtUfk38N2jdhay9lpUrac6L2HoZUi/PUSoA29oSBCvYI7x5ihHd7Gd1lj8XxXEAC754594m79FFBJqnqFP/+z7z9zWu0KWmObNngtehsNGiBhPzqxHoqTlk/naRtCCYzkE0gwbfUWKsGIQgP698LoJOboNolLkn3vZVMR+QQSIU7wLN6ExFV3oh3dHW/EN6nrVaIjL3LLroMkxdqx+8QM3+oh4jo5C1Tr13gOzoNP15LS2G52zNvkuhjOXqQV+09+HQdA9+v4mNK9BGZtSXKE9r/Ffu/eiZWmUH/e54nF8VcJG+mdmp2m8JcJN7mynScABYQLfALP/1UTuyIEog3LKLIdqOtb+dhOm3Amn+1whNZErriMANQ084PtRh2fHFatHsVIMMCw9Ef2hSeNfqLt8irSVp170/eJ4Vts0Mc7HUvHpA3rEc65wJz41ePBkwzXL8tFiszcx5iXxTMqhh+kw0S6cyKxCbyBHEIzKI/x0L5z5T4NeoOwx36whvPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 20, 2026 at 5:56 AM EDT, Lian Wang wrote:
> Hi David,
>
> On 7/20/2026 10:44 AM, David Hildenbrand (Arm) wrote:
>> you give no real motivation and evaluation why this is required or
>> why this gives the user any benefit.
>> A SPLIT with an explicit order is not really want we want and it
>> does not fit the existing primitives.
>
> Thank you for the direct feedback.  Let me explain where this came
> from -- the cover letter should have included this context.
>
> This started from a real problem at Sangfor.  The scenario is:
>
>   KVM-QEMU virtualization on Kunpeng 920, with KVM guest memory
>   backed by tmpfs shared mappings (THP=3Dalways on the host).  An
>   Oracle database runs inside the VM.  DAMON monitors the KVM
>   process on the host to measure the hot-memory ratio.
>
>   The KVM process allocates and uses a large amount of memory.
>   Under the same workload, DAMON reports a significantly higher
>   hot-memory ratio with THP enabled versus THP disabled.  Direct
>   tmpfs write tests inside the VM -- touching at 4K and 2M
>   strides -- show a clear gap between the two cases.
>
>   DAMON parameters used:
>
>     operations=3Dvaddr
>     monitoring_attrs/nr_regions/min=3D500
>     monitoring_attrs/nr_regions/max=3D2000
>     monitoring_attrs/intervals/sample_us=3D500000
>     monitoring_attrs/intervals/aggr_us=3D20000000
>     monitoring_attrs/intervals/update_us=3D60000000
>     schemes/0/action=3Dstat
>     schemes/0/access_pattern/nr_accesses/min=3D1
>     schemes/0/access_pattern/nr_accesses/max=3Dmax
>
> The underlying issue is that under PMD-mapped THP, DAMON's monitoring
> granularity is coarser than the actual working set -- a single
> Accessed bit covers 512 base pages.  Before SJ's probe infrastructure
> arrives, there is a gap: DAMON cannot distinguish hot sub-pages from
> cold ones within a single THP.
>
> Split is one possible mechanism to bridge that gap -- by dismantling
> the PMD mapping, each base page gets its own PTE Accessed bit and
> DAMON recovers fine-grain monitoring.  It is not intended to be a
> permanent API, and certainly not "the opposite of collapse".

If you just want PTE level access bit information, why not split PMD
mapping instead of the THP itself?

In addition, the issue is about access monitoring granularity in DAMON,
why should user care and know about THP split operations? I would expect
DAMON detects the inability of getting fine grain access information and
split the PMD mapping itself instead of a user initiated DAMON_SPLIT. If
that is not possible with DAMON, an alternative is to provide something
more generic like DAMON_SAMPLE, which does the split under the hood,
instead of exposing MM internal operations.

>
> I did not write this scenario into the cover letter because our test
> results do not yet show a clear quantitative benefit worth claiming,
> and I did not want to oversell.  Without the context, I understand it
> looks like I randomly proposed a new primitive -- that was not the
> intention.
>
> SJ acknowledged [1] that the monitoring problem under THP is real.
> My RFC is a concrete proposal to start the discussion.  If split with
> an explicit order is not the right primitive, I would appreciate your
> thoughts on what the correct DAMOS abstraction for this should be.
>
> [1] https://lore.kernel.org/20260620203915.82947-1-sj@kernel.org/
>
> Thanks,
> Lian Wang




--=20
Best Regards,
Yan, Zi



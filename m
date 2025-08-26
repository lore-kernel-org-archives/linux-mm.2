Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 709F8CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:24:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3268E00EB; Tue, 26 Aug 2025 10:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAAC16B00BB; Tue, 26 Aug 2025 10:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A726F8E00EB; Tue, 26 Aug 2025 10:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 997D76B00B9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:24:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C4C71D72BB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:24:15 +0000 (UTC)
X-FDA: 83819128470.23.A24B605
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id BC6AE40015
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:24:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KKqI4WmU;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 40.107.220.48 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIpbWFOTljkMuvLta0DRkVsoSxoRV5Mg/NgfspkQf1M=;
	b=AD0pdaY0QoslYEOYAsXkaNkzukcBf1YC3i1IxdiRgSe7wgah2AL/+yseVo3CwEuJ3pnGmf
	ijhMS5/5P7Sfc7rQCSwiZrA5kTzmRv3KxHLtuxc6z1O9y5qoW0xw9On1uqda9wYKHeDYND
	EzERsCxdNaWGmQwUtMebUZScz9pjsjA=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KKqI4WmU;
	spf=pass (imf01.hostedemail.com: domain of jgg@nvidia.com designates 40.107.220.48 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756218252; a=rsa-sha256;
	cv=pass;
	b=13UzXMIMVQUiy6zPDkf5ot03wA8tHoqkyVNGe+b+yZYzYu3lQLX2P+K439wXlc/AjT4yXW
	wsgV1DMrOz+Vx0RpR04voVtF9YlMQrnfzZcLaK7gnb+SEaO1il/hfU+tR1oVOrek8AcS5Z
	UQOyMP9ru5O/W0a7rYUHMYgxWI/WIAY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VNt0LRZzl31TPuSFu8UVp6o6R+gRBYiFB9NpiXRnPXou8yZ3jreoPu0LxnM/n+jyxhOKlafjhUDUs9xTibWlymjDVDt3L5B4DnNl5H2kPFjyalKidltLFzoWxTJZKZpbSVnt4+hX+4Dsn4poQ7UVyKTnpl66QKRLFQbVEXQNIyqDXqHJSRbm72PcAAHPGQT8DR/8R5/3s2FrkiDaM4zXFE6gjNMSA3krphElqhA4Q+jv7TY9CoPDIPrj01HIuIu8zRsu+WxgNmaledNTdqBlClK3B/ytQyhpmqUYd1QapZ22BZT1x0DMOEgnGrQLcnyPxOarkG0IYMkmDyz+mRSIyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OIpbWFOTljkMuvLta0DRkVsoSxoRV5Mg/NgfspkQf1M=;
 b=e5XdSHx6SCEXh84jRdorq3DCIyDyxfOzO2TPYHELY8TLgMatVSfPhJiDW171nPps1rO4DTNRdBgHy94wH+d7YCC3smBlP5nMq6KBZz3qOuIrfJqLUVL3UxatO4bFw/Esski8dhGdsy1lRyFqoXyhZULB2gCLYP+7U39fLIvPMYgkdy4ONcnumvdpYuEoOHRefeY+JN6QkaL9t4Ker7qzlqJhRDbvfFZIe2lBZZXojoOJGIxbiEKBe98rjlGxffx4U+kJX166l+z0bK81iPBfcrHSk6r1YhNg2iSbfpmjaCIRxW7k0P0Pv8KojQKbTU0wrdc66MsErxhtQV/AxcysdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OIpbWFOTljkMuvLta0DRkVsoSxoRV5Mg/NgfspkQf1M=;
 b=KKqI4WmU6/i9BnRp8jGa1NQiRmEPnhuSMBfiGFwX7g5E6pGofTxNSveWMv+CXnvvuy1f5rLbmapcog3Uhr/YYNkwUPEFuJEVDSDCL/lhnlJRHegrxFF6ybP5P0hMqNYw6bMU5vvZz+wKILM8qapo+DOJggthnlnELdDsD6x/uYr0rYld85jd8kF+ErKKlFEz0N7Mt70inYO6DZf5mG5UreR/o38EV2ndjVLrsYSROvEHePiYHYBb/qB3juDHF5x3H0O6HjYJY2IIMndGh0/IxebqiYaVbDAj2cK8w6aGTWdTzJfBmnHq00hy6vvUnqGZevQNbseTJy7K/X7+hB/Y9A==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by LV8PR12MB9357.namprd12.prod.outlook.com (2603:10b6:408:1ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 14:24:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 14:24:07 +0000
Date: Tue, 26 Aug 2025 11:24:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, jasonmiu@google.com,
	graf@amazon.com, changyuanl@google.com, rppt@kernel.org,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com
Subject: Re: [PATCH v3 00/30] Live Update Orchestrator
Message-ID: <20250826142406.GE1970008@nvidia.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <mafs0ms7mxly1.fsf@kernel.org>
 <CA+CK2bBoLi9tYWHSFyDEHWd_cwvS_hR4q2HMmg-C+SJpQDNs=g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bBoLi9tYWHSFyDEHWd_cwvS_hR4q2HMmg-C+SJpQDNs=g@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0242.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::7) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|LV8PR12MB9357:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d86c664-36ac-422a-b733-08dde4ac37b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rjL3rCxGKOE70mTHN+xAob8dUkDjmb6ibWQFXPLA0FOgSeGT1dl2UeGkQIwK?=
 =?us-ascii?Q?wSUxNxalKzkmuaWlqe5aBF+QUncEs1KZPJh9WEknr9Pmx55TwWwLuIefPt1J?=
 =?us-ascii?Q?yGNeXddh9Pw5vKvjhce/e5mveine/5ApGLbl0QkIJKJwfZQIlF+au5yRpgBg?=
 =?us-ascii?Q?s+uuBuYAfzh39+jHr+LwskEN6LFqAEXx4Dtl5nL3LjhFPDDqyQ0R0qsMw54j?=
 =?us-ascii?Q?Ix7vsGUYUhEbIlgINKtMLZ7ZxgABM7hCL3UtH652geT3JX2sKlmeQLuEQQvT?=
 =?us-ascii?Q?jr6f9pxuWy9tFNnjcNLnmpgdwpRFruRDu1vZ9rfi5NoeqK7l4bCL8jp8Tah7?=
 =?us-ascii?Q?ukY4U1kX28iTl4rqq4pAD3YlKnum9zEh1xjtrqtgaZN50oeq9FeaPJBoRQoO?=
 =?us-ascii?Q?kMsRfr+4ayagL2eQKkTe/ffUrLxUqx2CtQUbgMG7Ee23RfkYrGKOk0pwfXoy?=
 =?us-ascii?Q?2n3VNEpGUUqJomTtuu2NFJsKLqOclkDvyj7QI6yIEfbfxKm6MBeeb6w5jzqb?=
 =?us-ascii?Q?IOxf+2jhKKQSRcBFqgnMSQiT37DgqjS2AZrB3GQm5smgFV5SeeAjBENiB7Ws?=
 =?us-ascii?Q?sUBb+ecbUF9o8Vxw5ODMGdmNVhts5ig4fZDjOFBWgIG4e0HXfvXIbdyH/D46?=
 =?us-ascii?Q?MYjiQ9LG/XkRe5GZZaHFPVpMHZHxuc7m+uBRnnc1WG9GzW5LoYTD8dKzIaW+?=
 =?us-ascii?Q?u+yVdlUnq8G7Qa58EoxO+HMdBuRMGGa+EP4Fl4N895ytDGbLiplMqHBFJ5eG?=
 =?us-ascii?Q?qfFsy+yn9OX2Euf2yaP+ePiD5Fvm2wAGXaMxafmc1HJ7w8zmLyteBS/gRLDI?=
 =?us-ascii?Q?xyxXmOF+LrIX3WkSlGAvv6/B7VIfiabppznOaCMkzqovXI2OAA0NczYiTFTS?=
 =?us-ascii?Q?bW/VyqwUDUz2l71Ry6fUeOi/+TEoWLmx02o+dOQB2aRphKYZqqpL3rT7t52B?=
 =?us-ascii?Q?awtJczzxn1lyg9AblQwuxoMLHa327+ToiegiTy9MuaJptSb/3orT9+ZgQRV5?=
 =?us-ascii?Q?YhBovGvx/kWAiGTTnBrqgOrp4+bVCI/HqbZvJpR9JhOjavQ781eF2tNDR7Em?=
 =?us-ascii?Q?u1Fq6KrwmvRj7nrVjmvnYZRI6vlXV7eI3tvY+D7DI1eIxHwHCuIRoDSVVjH1?=
 =?us-ascii?Q?CuxD+rAWRkPUDKvQsFiwpYmW4t2wXj10dTE6f5Kem3Xt4fhEW+OXFm4S0Jyd?=
 =?us-ascii?Q?KnOE8QhsrDV4D7Lty2gdNTVcbCBdP8Wy02BRKbwJs+6jBtfVWN+Yp9TPYz4G?=
 =?us-ascii?Q?gIx80Ztkjz6hPY2EtdICip6qszAuVGR8xmL4nLrWXeSGsaTz3fvIXlbMnQ1U?=
 =?us-ascii?Q?dBAGLwrd6x2ExhkoeL2eu0W7+rbfvilw2Q5po1MU6rlAZOfQxqQOQ8+E+ffH?=
 =?us-ascii?Q?zdIcVS1+bXw4IfwbLyEtdtPqePnmTkyd++PLjtU7ujfSs5PsjA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5E4XLxiPlj5SO8ft4AER2KybRj5Sfqfgc+pgnj3NuXPCaGqn5MHZlsmyuxH0?=
 =?us-ascii?Q?he0vRQOPsOmANbMpRq64Hk20f5nTXhIWI/cPXzENe6R6mXC6QkJWwKgiSlo9?=
 =?us-ascii?Q?bcjEcDClJQaoCkk5julpZgFSieuUThNCLDQ45L4Q6siwIRHTNlBXzJtQd5ss?=
 =?us-ascii?Q?qD1CVIjUi7PlXsR8QU9p0azDzqXqriqxUr9V2L5MClm3K7hlr+zIIAJohVaY?=
 =?us-ascii?Q?XXF8CTzMRrHq8q8Fl516KjAFnGvQE79485VNCZ62TwKKfVqVhmEG+oQ9zqDr?=
 =?us-ascii?Q?nX3VDxTWCFPMKG3h/Vrdu+lcFyexgBaWwh7QUfZfTJ4d9M3UFS8IpABINppx?=
 =?us-ascii?Q?/J0WmkRK08R4UDpsO0+eYK6UBjNE/E3thMLryrZBwrwznx5EJEZCTZq0wQdW?=
 =?us-ascii?Q?Frh9Vf5IftelbSQIoZRQryoI71KGdOKbQxMLy7/WZmPiML+az9kCaXY8mGCM?=
 =?us-ascii?Q?AJGwi0yytcyV2j01eAvce+K+SvtjZzDHAKFGTmn33v/UqCoKRzo/O4ljr4pz?=
 =?us-ascii?Q?x3WAe4JpB330uwi6lILCqRtAq4Veh/6lox8FgNbEpErZprZxgTIUm1vDUL6w?=
 =?us-ascii?Q?dzxbayTcDuHXR+qUeu/sxgWMK0nV0n8o7dO9CBIYyyr970guyKk1Q31dWcby?=
 =?us-ascii?Q?b4MspvtSkcHnaGBYN/c2NPjmWh+vivDyjvTI+yIk0uHomD9XtRlUqjD5qWSN?=
 =?us-ascii?Q?pDAyP2AUblgXnAR/YXYvQyIvq6XhDG/5Dzz91pB/VA+K3nCCTnYq6BKk9+hM?=
 =?us-ascii?Q?A28K356pGKHBK93YaVYLKrhymfvwwuo/LdS6ThQWM9aNPFX10ByviPehWYl1?=
 =?us-ascii?Q?UUsIa+oByqJrGho4K6Us/is1ihnT84RCb3j/wKkY02zsdQEBqcHrq7+8K9j2?=
 =?us-ascii?Q?EPUppT9s/f70RxRqG/eFqyrT/0B9QjpBaYulJCEyulwsQ85LdnKXHkiewN5b?=
 =?us-ascii?Q?iV49ccHtnNpHZzLDdhnm8GTkizWtcG31YnzGevxWvySTvDVidBUwFSzn7MIT?=
 =?us-ascii?Q?L9aIbkKeq3j4XLX4vwhhVeDHiW3V+giDJ1IzqCiC6Sv+zhfVDC2557uMTT29?=
 =?us-ascii?Q?DPcKtFnyLoGEHOeqDu1QaGZAsD1WXuPn/WEGCcwWmzwpBlakvw7FpMCIHNC3?=
 =?us-ascii?Q?CliWcQr5yaI87XqRbuGf0oGii7G1C+bVWoMFOTCVwSvtEO68mFFLuQ0ONce5?=
 =?us-ascii?Q?XW1ea1l3JVRBpiesJCrUvqdXJlqDPbP3dOFYjkosQmzxYEoJRvfejHUiX8NO?=
 =?us-ascii?Q?UL0VM3pxZp6NbYDiDN/XQYC0i0OPaQjIuKEHdDMKpWlDQcFIbFRYtjU4C324?=
 =?us-ascii?Q?SfwNSgEjC9lyMoqXWl2rHik3l+RVtLLTbQWuVY4fHFU94vRNcdI/UGRBsYdJ?=
 =?us-ascii?Q?5JYwMD2QjepqORej+kJG3gQrAkP6nfsZqFRmArdToYGwcCUK/JUJprstj4Zm?=
 =?us-ascii?Q?dRgKm1UFgxRvHlPBdyb3Jh6EYQbhcVsAwVn/T45zAneARaQO/yQf+aIo0/ZL?=
 =?us-ascii?Q?L4qq2aWwuyH6sS3FKtQWdOEECPwT6N9KP8BB4TNUdEOSiE65vkCwlN0P93MX?=
 =?us-ascii?Q?95Oo9DiOZcZxh1q2PWu3NafZ1Xq7uK1YRFD/QWI/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d86c664-36ac-422a-b733-08dde4ac37b3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 14:24:07.8632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3L3E0LULJekqNyODBsQXiF/Tam4+A8XdYhBPvpUO/3orizhql7MqOR3MZm1fsNb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9357
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BC6AE40015
X-Stat-Signature: 3qqdpc9jm8uyaki73e7q6uwx3gmn3an4
X-Rspam-User: 
X-HE-Tag: 1756218252-469019
X-HE-Meta: U2FsdGVkX1+SzorQ486KGhCj7ps3L0kYpBtHe7LH3llFhIVO+KX3fu3rhiQnEvSZKOvs28dgV5UMmR8I64U/jZnm3eJbE1gvc2lBsiYQ7lpexzojYkrNJwX0PQMzXTLa991byDZ0l3AFSljgdWNowpWnl4SEmA8kPsyN9NucQwEFxfdYB41uaVU0eXT8oUp4kLISrQgV1w97RGTKA3LAstZ6T8WcXpDV91FEbXJp4BKrAqRY9DKOANZ29zS8Jk4g6PPGJSUmNz45lSNaJ29UQyALADsDrofP5C0jsRhO1CZoEG079y4Qq+FZYYDt/+7DHdvNAKJbRcu8AA9BzmboY65K/K0e3dtin5/iAMqwmzZdWX3p8aKltJH5raUGt/WMa5r81YCUwZ3+0STmRa2W6L4El2erKatyyiO8OTRk6RiBbypNDjUnvdzhKzicje4WwJiDsQT0OfACwBzYV1IaWv6U0s7WVydM8yOULw61Kj+Ge1hAP26oZzsxjnj542zryCaeZBHceqSn33KyA+oO9ot8ScNyhXXhfOVWImqFhLFdE9tBo0/xOJDWyrbjkZ6t6v0l4uYplO5QwVQv9AHxWO5QIl70LgTQuigMxZYk445QvIrGrgKfeZljBh6uUbDeghm192W5UBDVWn1uoGHqXdhJHVF2TIwntbJjGo2VENTQFp6le/GQX4zmCTnxYST6w9C+EHvI5s/o/U+xISQ/USKQZADtQwkvYoDPcP7BR5UDLXtzs5g6v6TXzRVMcBC6CGhWe0tAV5R/39f4R7XRGZwitRqPnr0uPAbUmmD4+fGAr0noeyPwX9we45ou1G9YAi8e6MG5QHc/092YnvOxWf+F5B4Xr4yJPxdopQaSlFetEKxoHC7VQSoJfQDXZcorRSWE5clRZCAB3CmjwMuxUsDVOtRhfqgyadzD/PMlfMYS2cNtbY/gfIe7k3s4uoM7ngT31yOFtWY/sDLq317
 dAfnfjOp
 WiQLlu5W3pesbLxuUzKYaCkTvDoUoV1A0yF8a04qYhXiJomxr8Y/mBFZFDaK1Vb5GlJSU7QTdmnW/LjeAFIYzU5YxlBLsfq7wptKmcGSFqGnLkf0We01N+mf5tWtD2E/b5nqWi2Fe3n1H7MzhzBxUIAmFIkDPsQ+Vo8q46oo6FH1hW0mgdgqwcQwKiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 01:54:31PM +0000, Pasha Tatashin wrote:
> > > https://github.com/googleprodkernel/linux-liveupdate/tree/luo/v3
> > >
> > > Changelog from v2:
> > > - Addressed comments from Mike Rapoport and Jason Gunthorpe
> > > - Only one user agent (LiveupdateD) can open /dev/liveupdate
> > > - With the above changes, sessions are not needed, and should be
> > >   maintained by the user-agent itself, so removed support for
> > >   sessions.
> >
> > If all the FDs are restored in the agent's context, this assigns all the
> > resources to the agent. For example, if the agent restores a memfd, all
> > the memory gets charged to the agent's cgroup, and the client gets none
> > of it. This makes it impossible to do any kind of resource limits.
> >
> > This was one of the advantages of being able to pass around sessions
> > instead of FDs. The agent can pass on the right session to the right
> > client, and then the client does the restore, getting all the resources
> > charged to it.
> >
> > If we don't allow this, I think we will make LUO/LiveupdateD unsuitable
> > for many kinds of workloads. Do you have any ideas on how to do proper
> > resource attribution with the current patches? If not, then perhaps we
> > should reconsider this change?
> 
> Hi Pratyush,
> 
> That's an excellent point, and you're right that we must have a
> solution for correct resource charging.
> 
> I'd prefer to keep the session logic in the userspace agent (luod
> https://tinyurl.com/luoddesign).
> 
> For the charging problem, I believe there's a clear path forward with
> the current ioctl-based API. The design of the ioctl commands (with a
> size field in each struct) is intentionally extensible. In a follow-up
> patch, we can extend the liveupdate_ioctl_fd_restore struct to include
> a target pid field. The luod agent, would then be able to restore an
> FD on behalf of a client and instruct the kernel to charge the
> associated resources to that client's PID.

This wasn't quite the idea though..

The sessions sub FD were intended to be passed directly to other
processes though unix sockets and fd passing so they could run their
own ioctls in their own context for both save and restore. The ioctls
available on the sessions should be specifically narrowed to be safe
for this.

I can understand not implementing session FDs in the first version,
but when sessions FD are available they should work like this and
solve the namespace/cgroup/etc issues.

Passing some PID in an ioctl is not a great idea...

Jason


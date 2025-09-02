Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 153B2CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BFFB8E0023; Tue,  2 Sep 2025 11:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5611D8E0002; Tue,  2 Sep 2025 11:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437CE8E0023; Tue,  2 Sep 2025 11:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30FC68E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:42:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE8791A0266
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:42:58 +0000 (UTC)
X-FDA: 83844728436.28.0BC1334
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2075.outbound.protection.outlook.com [40.107.100.75])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0DE0E100009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:42:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=so8fdctT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.75 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756827776; a=rsa-sha256;
	cv=pass;
	b=N7WRfDwsMtoS+cr8lz4G92ir2C2A2PSFFvHXsYbnM6TtpiCXwSA52fBIs/ustvRD8DYLBW
	Fb8iJ0iapS5Qf7oyvEG0pxmoHIBHpQI8nMsMMYuOgjyGkh+MXxtcFDRy+lQNecfsYuslS8
	MfkqjHKhq6wmaRS4UGuk+EcAEoDPmUs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=so8fdctT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.75 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756827776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKZnkgJMpkay7wy65ujVjom1zbngxlkUPCKWsryirwg=;
	b=boz2yfGhakDgTpnmlAbhmcvI5MossT6W/U9NtJsnWfM33xREir3xwjPVP/8DmAw5M2ERLP
	bIGsGUQvO8+SxiEMh2/5/rvYMF8yHd5qPCbUU/1EN+gX+yvVdjNRMYPBodusx7y+V/yuM/
	s1j7Le2ILhk0BidhK/vttQIk1BYIkQ0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yGc6l9sIuz3rN1F1n5tMGOWux/0Nn1x6RMlYegyLDSWxQ26wnfSvracCfsaRKdvQLH/LvGBQXaqpF+s4/o5rXz2IEODtypAtJ3MfLcbD9zxlWMnahwnijBHEGbX3lLH+ZbYbenIeqrGa+O6lmJplFuENdLKoSK4dJ9r38GHo6so8YXLPEDnwKn/5R3J6yJuU9sglIKjs4qjMlFE/rOARUZL/DB0SFoUV7cvw1Nvu7QfJosH6v/ds0LOYL3WlAWqoXFgXASpiRIvNWUkTop6TBWmFltZHKNQCoy7E0mUi626vl6EgybpClX6U39eQD33SFOaWqgmQGh1k5SaRynWHNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKZnkgJMpkay7wy65ujVjom1zbngxlkUPCKWsryirwg=;
 b=Df3Fb9zF03YNCWYH+b6C5HdgINwrhz4c2Rm4cJ5tPAhz/dLxMRjj4Rjt6HgmBouOdokRs8Uo6JX82MKquD7nBfKWSH9avTMv8f2xLvdoMfIgXn61iGgCdtSU8Ymec7Wt9OZ5gVF6QskIR8QGBmQWLf0M1CmGKokVfnCVxnd3TtFi85ubBJD4tudDXtleKNIrL/dd4P2Kng3BjTPc280v7nn+rIJEiF5EF7vih9lrcQ/9mjfO1p7ONg39rf3Zx5cRh6j+MRHapqprnfr59lh72IIelgS2KYDTG6P/QkdxcVDwvCohWX0JkNYGP06zJ0+951nRj5yNea+STjGgLqKT3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKZnkgJMpkay7wy65ujVjom1zbngxlkUPCKWsryirwg=;
 b=so8fdctT88x4An4enE4VnA489uIIO2dQSIIasqIIqe+BHTX/f4gG9rZ6UuWIYcjbX9QXwTI61TM6DvEI9fCW2TpwUqw3bLqVJmAlefBO5GpcsaSqTOVX03KpcQMdUAaY1ICvbE/je0byxKrCxfMCdW7lymLvFB145rKLEAnQ/lxv+POwZNMfWlxf2jp6rG5WNCnz+ofQSf3PjX8e5ZXrUx7+3qr8BK0xZ100HMNQJ0GzIBCcOfeAgFPD+0sKNfS8SwQuwaGuV8u4GR4xZ5GyCo8mBUVIG8Ch3sHSBjLUWHC8Lu3/R+ByfVTdgIImTitH7lWRPEIVHjsXALUopGGTWg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV3PR12MB9412.namprd12.prod.outlook.com (2603:10b6:408:211::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 15:42:52 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9073.021; Tue, 2 Sep 2025
 15:42:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
Date: Tue, 02 Sep 2025 11:42:47 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <4057F5F0-0F84-4822-A431-EBC0A37EED6A@nvidia.com>
In-Reply-To: <d987da2b-1b27-41fb-8e30-cbe9a9fe1cc0@redhat.com>
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
 <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
 <27A308FD-C7D8-4C65-90BA-9B1DC117B014@nvidia.com>
 <1d7e9c30-343e-41c4-814d-f6254b042509@redhat.com>
 <d987da2b-1b27-41fb-8e30-cbe9a9fe1cc0@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0246.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV3PR12MB9412:EE_
X-MS-Office365-Filtering-Correlation-Id: bd447a62-0207-4cbd-a3b7-08ddea375f28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J9/8cPM6dzYRm1gerDOvSffNvJPQRyUV/3a3taOxB4UFJSGjQ+j/3qdiYhxA?=
 =?us-ascii?Q?tdMSUbKEBUsyDTKs/gWKLmwfFyn5A0Z4P9rbYNuDtpc1HC7Ww9xNb9yZNovh?=
 =?us-ascii?Q?yPPBTvGV0FwOJ9NZI2VaYlGpFz+5vQX63N10LoSzk8YM9Cd0KIGLb7hpszXF?=
 =?us-ascii?Q?NRAjJwrjXNb/+FBO1m8Qd7Hivk2cN5jt6MFVyIRRSP0bLYEdMUGtLe5J6PY1?=
 =?us-ascii?Q?SrGg0/FQFXdZ4SwRuLPU0+nsn8vhmqj9njWBif4IW8+z14kCp/26cK9KWZ20?=
 =?us-ascii?Q?Qf0A5y7fu/9Y+AJYyQ1Zc09CRRZYOBBhRlyJ/bV9TByrFjEGDumWdJcxdVKQ?=
 =?us-ascii?Q?TlvXkOsTlTRiEp0+7nmCYifrMf0rLnWJ0mnxD2nerpK5bdbe9BW+VML6W3uw?=
 =?us-ascii?Q?tMlWhzrsIbZmTZ24zFFTQQpjt2BMpi/TQgOhxceXgkIO08q3qu6IxXZMVb27?=
 =?us-ascii?Q?DAIfDoFeJzrsjF2GY3sz4Hk12FAjMezeraQr+J02uQlRYfI8gINxsKxEvN2E?=
 =?us-ascii?Q?hxkd6D3D/z0IXDnfvhGsDDkCHZMHE77fDcRMysZ/RQx/O0gOlWuxIOS7m/KJ?=
 =?us-ascii?Q?PeOprYu+5Em592FyV1TtxU23GirhPH0GpfOu+zzRr8Y05hxAi9DYFmX3SKwH?=
 =?us-ascii?Q?Zhz+aiTTkyY8EK59OK2vV/GfRq7HXKBYQVDSLmPzfjqtZYBAEddKWXQGPggV?=
 =?us-ascii?Q?sETH/EElnxGz4IhqB1oKZsyStM6hS1cb5S+VfBsFRyMRWAwNTAnnqcgrafUB?=
 =?us-ascii?Q?RR4fXtzLHh0X1I5rqq0GZVlFRVxd0791uyF4+PThpmOu0cajR6wjm8R0l3aF?=
 =?us-ascii?Q?DSK7JwXASDWbZc7FZpb6OxAItrpRoMjhrnBz1EpqeD3ZcD8Znw9ZTtmEltgz?=
 =?us-ascii?Q?9F2v2zaOKob8GB8XgLg+yZBvuozlHbhO8x7SvJZ+lhOeosjQs4dOZwOOKW5j?=
 =?us-ascii?Q?R9su9HwuN0lhixnAYj2EAJuyZyvbdN+DXtynXu1XkN2usAceKZfvNg1WtNxT?=
 =?us-ascii?Q?TYjA/8JduzTgDqYGO0n8+viw+y0jSNoqekdOX8R2CXuQhp8HYbVIzHITgU//?=
 =?us-ascii?Q?LGwxwZg/o5FejAyTWNYGcRT0tWr269kjq71P8vPxtKMyMocrv9/mUq+TcJvV?=
 =?us-ascii?Q?TqkMviSS1KX0cPOrmecVxfCCC6P1Yr9Cq29wH+/1rrBISudLkCYkm7xXTR0D?=
 =?us-ascii?Q?zynnSXczNKfNlhaqnM7vbsZrG5LBEqbHCO0/HQKcNLrjdIbgYBnMWCcie+O/?=
 =?us-ascii?Q?ZDmJfPFVEo1rsVGAJ9N5jRnfEXPp6Hsn+VtvyiwOBHYUjLidKQ+3RHCV7zqr?=
 =?us-ascii?Q?NfZmNTGOW7KIwrVQ64gFmY5zCSPuPIhUFPFwzHbAJF9OwBiQEeeiHoGdgh2D?=
 =?us-ascii?Q?LEWJWsxaqdmeWwEPfMfr9Lr8t6L/8VK6BkvvAFxn9sBvzTpK6iUQtdJTh6I/?=
 =?us-ascii?Q?i8oYaGUcvqM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7gF++LomoShmLGFPH0FHqnBk7aSYtBdmHsnkKFGgM1g1+jbZSgZjy5BJ3SvP?=
 =?us-ascii?Q?G+4ABtgFUnIp0u6f/iokAunmzYK3J49a0K+8sHgUz23belg+DWTAFjmWD+qZ?=
 =?us-ascii?Q?oBGIO+S8XyoL9Op14Wtemf+qdJIaP8gG7dc3bno7GJWQf+9Rgs3qEllj4/id?=
 =?us-ascii?Q?K+R7arNEN/1M0nkpkzcM5/2pKRyg7RsQiDi2G3W8sUlr+JzGB/zemBUOmiJp?=
 =?us-ascii?Q?zu9RPJrMZfU9ch05oNlzrQy/SPOAWpvlR9VRnukKnObEy2wnFf5Ri9BdzVNv?=
 =?us-ascii?Q?dKBrH6sauCaorPMMp6Gbh7zb60smWl2uggpqptD438CEzQEbOmSLoqxzxYVf?=
 =?us-ascii?Q?l5a0/WN/SRcqkb8y8vrI3kQKL2Tc95yr4biY0lSZ+i+QdYce7LTGIIjJSuUi?=
 =?us-ascii?Q?OUZ8L8Ay4kZJCVzgaoCWz54ipIT0WO7vEHeR3cBBj3GsgQXU1sPZQT1yWXpM?=
 =?us-ascii?Q?8pxwzKVV+4lEk1H2t0HP9jxBt5oGWD6mPQgrrzrYi9YUkHdZnHkicjTJ0o85?=
 =?us-ascii?Q?JeFKVjksJSZ7HdWPeBb91Wa+FtRwaRv9bpZV6rY3JWAVmr/8OBb77IlDBfJY?=
 =?us-ascii?Q?EMknA6OpA0ezipfO9RJ/XYB+fqV8afU9H6aegGGpdMvWsPcezni7WsPVHScx?=
 =?us-ascii?Q?/zjg64HLzIF6z+yuP85lzZRSkr3MbB4MSDkguV5Zq82DznGKLCaQ7gqZJiub?=
 =?us-ascii?Q?wt7GpvP2HK/4kChnh58upVLpeNeiIwa0mk63auOjEAB16HhR+88eSJ7FTgp5?=
 =?us-ascii?Q?6+F1V+PFbcCV0LcPgg8tjQyMS4TJiW6o3V3/zqkIPVOXgNz8yiueazpxCkfG?=
 =?us-ascii?Q?GrJABZTVorpmBWzEzcfAe+SQLVW6gNIa0FMhMD6N67qL2R7iz8VTjh8nzLkS?=
 =?us-ascii?Q?VkPQmlYXhQw8SPuMIiWgnK1+HXvnxAOIz2TwBcoACdS5Nb7VdRG4Gb3v8vyI?=
 =?us-ascii?Q?Z8p7PKB2mh/0Q2r1f44af2fNZt9ZgQETHLVlXqR13HE9S09QkpIiu9wh9ZSH?=
 =?us-ascii?Q?+aOXIyaTF2sgu6saYi22aqoUqKHdX5iRRmzvAO2iKOXR0xM90s6Gdh13xcBN?=
 =?us-ascii?Q?BLZapeNa5DhXOnvNaVPJVdbioo0KzJfdrLvlptSz4+piiswhP89k9k5GnLDy?=
 =?us-ascii?Q?7BnsznWbpGaa3Vq119WANFa4qoksDxCX5UAFn5z0E8gZqKEI6JqL/VRCp6Zi?=
 =?us-ascii?Q?FrFrQAwjbRCl4O5fMl3WBKFwVuv5CY+1Zj3XLUd1hqVgd4V8Hrb+pX3KClCT?=
 =?us-ascii?Q?fNzkN3QBE95ALoWmHE09Fmul9/spTsHJNecWYy5ejClZ12EMexU8ReCnlkXs?=
 =?us-ascii?Q?qjFO5SlnRpbjxGRntVJTH+R9BK85dhGbDKLQGlXRZauG4b9Sb8leUhHaQJ3K?=
 =?us-ascii?Q?ZWvTpw1pCfZ7f9GSSO0hdG++76dCwgjszAJ4wemsXpoBInw8+hfD8ezu2v4A?=
 =?us-ascii?Q?L6bZOVXyKtwdOXUia+X0GUcqKAt7Ugqdlzg0VDygn62G61I99UHXI0Zi7J2b?=
 =?us-ascii?Q?JhDPYwD5ZiVopNuGc/BVZEdNGrWUhI3LR5okQqg5bSeuJaJgcDR3ybz42RiF?=
 =?us-ascii?Q?6stYgoNWw4yfJ8sGXO9Xzxzika40CUPNYQQL6PyC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd447a62-0207-4cbd-a3b7-08ddea375f28
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 15:42:51.7693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXO7uufxAqamBXwfoBBOulYgL9wS/G/6EuNHNzUM/QfVUnQMFFMzCn65MiTJNudt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9412
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DE0E100009
X-Stat-Signature: a3t99wjd9hmeeq4f1abkznq6ssc7aswg
X-HE-Tag: 1756827775-423301
X-HE-Meta: U2FsdGVkX1/xU7ch6aXKV1opgAN8xZaxDICh4N54vFauQ3s69VaVbpESbrDhZr4ti/7dZNAyivJzkkhZcIVq7ZufyVRO1d9O66TqJ4LyZWQVbKV5j93ILWk1wheeobRgXqBsX0ly7GsT0jSADBB9/Fy6A/eK4u58PL2jexuVAB4YsegVR72/AHuPe/Vc4wuG57VIR69llFAVFkopMT2PYjxTysw/5q3G2iFYddxrb6DZ1kqLmIX3MxM+EOCv6j3p4tteAWUgHWkxOhzZV9m3ntuGCbmb5kdyHzm6IeNO+mj7eKd6xQoRiUNyDSIAqxbRllH9XVmyeOrJ/coxa2vC9aCKhkdiE6MGwsLhjKMmcGmF8zKXtnu9o7FXx5AIMJAFfS+W4VMgiEHCgwz46SN2Z6nNeqvSkb6L8RpNw51nHJUeeSDbR/bdIlN0WU+xPK2LUdA3dg+UpW67Uq2xzfCphWEX7jUweIS/p+06mZ8mREY/Z4mAoaDZ4Wc47BbDAfoYzXb+OfxA3yyvig7+suT0Odzn/GKoffD6ZUR9AbnBZ4YHN2z3g0hjG/WXxEDRx2zfLLGaBpkuJueagbcvgI7DXm+ZYqdTJlZ6lCSFiMiIEPqtcSyr0b4AUo29MWydo/L+YT/DDBRAXETwi8gxHJ9bckOiKSx3bxGPv9CLwZGVyZht/LHppg0fHw6KViWqIA9MpDdpZNKIblZ0L4s5OZ+zLLbW55MGNtJqzji/BV2iV19OlkHlK8eEy8UbSHHbcrWEe8a9kx8E70D4y6KO1/pJtJvuYfn7mif9m2HCEatuIrYhh0XFzGW+stttl+8gs3tayUs+j0DY/r7M40Zj+RHNFANNBSpT2JCoQEFIcrIUgPrVAC0rNwG2TWFaNIqSJYL+qEGeh7ryiNtWA/KbV1tD1SAQD5pTyugvm5j9iboC57HUr9nmCvDdRtXdhgCjBePzQmTuof3vunt7qYYgCUR
 1kf/SG2X
 ol5uhaJEnOnrVOIHmsYFuCDNEU3M6yRc5aPWy0G0hxsYiNeTOHVenjQmWzTS6jaOa8CTSb/5wXtNmfGo7rOjlCf7gGFOWNPb7JlcZPOJD2Gq6fUeRdFFm+kcLM6tYMBk04fHhpAkX4mQmQVhmvP55RyyDGbpuqUIm5spBAJpGv7y8wU9X94vq/9vnoiqqgdWik2V6giPY3GDtDFwlnmhSp17f75IbEznkyvskS0qvknHpPc/Z6toUqDhYdgeQCPDCJHDf93gyPP6zGoBQKoelfgocuGNOKfsMyQxssRT0TC8ph4akESJq0dQMaQpSoPuKYMHMw4jQ/5B9W5HwOzeOg53o7U9j2hUAL2Ca0AgTCNhr822j5yIHPgDjUwSbR8Fq5lN82hQ8TBMKL6wDln6Es7dD+kY01KwwFPza0o7t3wFeZvjIfNUrUy2GCdq9s3DWBn6go0Q0mgqUm4EMKJ8O0yHWI/Mozt/qpEgczareF2z5WTdoxxMpCDyh2xhd7F19w0bH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 11:40, David Hildenbrand wrote:

> On 02.09.25 17:28, David Hildenbrand wrote:
>> [...]
>>
>>>> @@ -390,67 +390,88 @@ static void split_pmd_thp_to_order(int order)
>>>>     static void split_pte_mapped_thp(void)
>>>>    {
>>>> -	char *one_page, *pte_mapped, *pte_mapped2;
>>>> -	size_t len =3D 4 * pmd_pagesize;
>>>> -	uint64_t thp_size;
>>>> +	const size_t nr_thps =3D 4;
>>>> +	const size_t thp_area_size =3D nr_thps * pmd_pagesize;
>>>> +	const size_t page_area_size =3D nr_thps * pagesize;
>>>> +	char *thp_area, *page_area =3D NULL, *tmp;
>>>>    	size_t i;
>>>>    -	one_page =3D mmap((void *)(1UL << 30), len, PROT_READ | PROT_WR=
ITE,
>>>> +	thp_area =3D mmap((void *)(1UL << 30), thp_area_size, PROT_READ | =
PROT_WRITE,
>>>>    			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>>>> -	if (one_page =3D=3D MAP_FAILED)
>>>> -		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errn=
o));
>>>> +	if (thp_area =3D=3D MAP_FAILED) {
>>>> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(e=
rrno));
>>>> +		goto out;
>>>
>>> thp_area mmap failed and out label will try to munmap MAP_FAILED, whi=
ch is
>>> (void *) -1. munmap will fail with -EINVAL.
>>
>> Indeed, should just be a "return;"
>>
>>>
>>>> +	}
>>>>    -	madvise(one_page, len, MADV_HUGEPAGE);
>>>> +	madvise(thp_area, thp_area_size, MADV_HUGEPAGE);
>>>>    -	for (i =3D 0; i < len; i++)
>>>> -		one_page[i] =3D (char)i;
>>>> +	for (i =3D 0; i < thp_area_size; i++)
>>>> +		thp_area[i] =3D (char)i;
>>>>    -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
>>>> -		ksft_exit_fail_msg("No THP is allocated\n");
>>>> +	if (!check_huge_anon(thp_area, nr_thps, pmd_pagesize)) {
>>>> +		ksft_test_result_skip("Not all THPs allocated\n");
>>>> +		goto out;
>>>> +	}
>>>>    -	/* remap the first pagesize of first THP */
>>>> -	pte_mapped =3D mremap(one_page, pagesize, pagesize, MREMAP_MAYMOVE=
);
>>>> -
>>>> -	/* remap the Nth pagesize of Nth THP */
>>>> -	for (i =3D 1; i < 4; i++) {
>>>> -		pte_mapped2 =3D mremap(one_page + pmd_pagesize * i + pagesize * i=
,
>>>> -				     pagesize, pagesize,
>>>> -				     MREMAP_MAYMOVE|MREMAP_FIXED,
>>>> -				     pte_mapped + pagesize * i);
>>>> -		if (pte_mapped2 =3D=3D MAP_FAILED)
>>>> -			ksft_exit_fail_msg("mremap failed: %s\n", strerror(errno));
>>>> -	}
>>>> -
>>>> -	/* smap does not show THPs after mremap, use kpageflags instead */=

>>>> -	thp_size =3D 0;
>>>> -	for (i =3D 0; i < pagesize * 4; i++)
>>>> -		if (i % pagesize =3D=3D 0 &&
>>>> -		    is_backed_by_folio(&pte_mapped[i], pmd_order, pagemap_fd, kpa=
geflags_fd))
>>>> -			thp_size++;
>>>> -
>>>> -	if (thp_size !=3D 4)
>>>> -		ksft_exit_fail_msg("Some THPs are missing during mremap\n");
>>>> -
>>>> -	/* split all remapped THPs */
>>>> -	write_debugfs(PID_FMT, getpid(), (uint64_t)pte_mapped,
>>>> -		      (uint64_t)pte_mapped + pagesize * 4, 0);
>>>> -
>>>> -	/* smap does not show THPs after mremap, use kpageflags instead */=

>>>> -	thp_size =3D 0;
>>>> -	for (i =3D 0; i < pagesize * 4; i++) {
>>>> -		if (pte_mapped[i] !=3D (char)i)
>>>> -			ksft_exit_fail_msg("%ld byte corrupted\n", i);
>>>> +	/*
>>>> +	 * To challenge spitting code, we will mremap page[x] of the
>>>> +	 * thp[x] into a smaller area, and trigger the split from that
>>>> +	 * smaller area. This will end up replacing the PMD mappings in
>>>> +	 * the thp_area by PTE mappings first, leaving the THPs unsplit.
>>>> +	 */
>>>> +	page_area =3D mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
>>>> +			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>>>> +	if (page_area =3D=3D MAP_FAILED) {
>>>> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(e=
rrno));
>>>> +		goto out;
>>>> +	}
>>>>    -		if (i % pagesize =3D=3D 0 &&
>>>> -		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags=
_fd))
>>>> -			thp_size++;
>>>> +	for (i =3D 0; i < nr_thps; i++) {
>>>> +		tmp =3D mremap(thp_area + pmd_pagesize * i + pagesize * i,
>>>> +			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
>>>> +			     page_area + pagesize * i);
>>>> +		if (tmp !=3D MAP_FAILED)
>>>> +			continue;
>>>> +		ksft_test_result_fail("mremap failed: %s\n", strerror(errno));
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * Verify that our THPs were not split yet. Note that
>>>> +	 * check_huge_anon() cannot be used as it checks for PMD mappings.=

>>>> +	 */
>>>> +	for (i =3D 0; i < nr_thps; i++) {
>>>> +		if (is_backed_by_folio(page_area + i * pagesize, pmd_order,
>>>> +				       pagemap_fd, kpageflags_fd))
>>>> +			continue;
>>>> +		ksft_test_result_fail("THP %zu missing after mremap\n", i);
>>>> +		goto out;
>>>>    	}
>>>>    -	if (thp_size)
>>>> -		ksft_exit_fail_msg("Still %ld THPs not split\n", thp_size);
>>>> +	/* Split all THPs through the remapped pages. */
>>>> +	write_debugfs(PID_FMT, getpid(), (uint64_t)page_area,
>>>> +		      (uint64_t)page_area + page_area_size, 0);
>>>> +
>>>> +	/* Corruption during mremap or split? */
>>>> +	for (i =3D 0; i < page_area_size; i++) {
>>>> +		if (page_area[i] =3D=3D (char)i)
>>>> +			continue;
>>>> +		ksft_test_result_fail("%zu byte corrupted\n", i);
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	/* Split failed? */
>>>> +	for (i =3D 0; i < nr_thps; i++) {
>>>> +		if (is_backed_by_folio(&page_area[i], 0, pagemap_fd, kpageflags_f=
d))
>>> 			=

>>> page_area + i * pagesize, like Wei pointed out in another email.
>>>
>>>> +			continue;
>>>> +		ksft_test_result_fail("THP %zu not split\n", i);
>>>> +	}
>>>>     	ksft_test_result_pass("Split PTE-mapped huge pages successful\n=
");
>>>> -	munmap(one_page, len);
>>>> +out:
>>>> +	munmap(thp_area, thp_area_size);
>>>> +	if (page_area)
>>>> +		munmap(page_area, page_area_size);
>>>>    }
>>>>     static void split_file_backed_thp(int order)
>>>> -- =

>>>> 2.50.1
>>>
>>> Otherwise, LGTM. With all the changes in this email and other email,
>>> feel free to add Reviewed-by: Zi Yan <ziy@nvidia.com> when you send i=
t
>>> out formally.
>>
>> Thanks!
>>
>> I'm currently chasing why I keep getting temporary
>>
>> Bail out! Some THPs are missing during mremap
>>
>> Already on the old test. Something doesn't work quite right as it seem=
s.
>>
>
> Ah, I think I know why:
>
>  diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools=
/testing/selftests/mm/split_huge_page_test.c
> index c94fd64066ef6..4051a5c98a97c 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -95,7 +95,7 @@ static bool is_backed_by_folio(char *vaddr, int order=
, int pagemap_fd,
>                 return true;
>          /* this folio is bigger than the given order */
> -       if (pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL))
> +       if (pfn_flags & (KPF_THP | KPF_COMPOUND_TAIL) =3D=3D KPF_THP | =
KPF_COMPOUND_TAIL)
>                 return false;
>          return true;
>
> Let me test with that.

Oh, so if next page is a THP head, this will report a false negative resu=
lt.

Best Regards,
Yan, Zi


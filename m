Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62801D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 16:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D876B0005; Sun,  7 Dec 2025 11:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CDA96B0007; Sun,  7 Dec 2025 11:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795796B0008; Sun,  7 Dec 2025 11:26:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68EEA6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 11:26:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E58991A0867
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 16:26:44 +0000 (UTC)
X-FDA: 84193203528.28.1F77F8C
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	by imf19.hostedemail.com (Postfix) with ESMTP id 313E81A000E
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 16:26:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="WKLdH/lD";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.93.194.30 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765124802; a=rsa-sha256;
	cv=pass;
	b=h/n/n8gs6zhmzuqCyAVnClrcqqCuHJTRAdMbOktqzvc7puFPIOvPaOO7sE4ctBOdAsYnce
	Cy3qptrnf/yNnDi/Pkob1a5MQgXzFmjUi4MLn88Aa23kB4JTZrBtStO5E2CMV3YkCPzO8V
	a2Hc5hbZxpY56/wgDpFAjNmvzxOefKw=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="WKLdH/lD";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.93.194.30 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765124802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jGIWkbRlS5G4LMwrXwRg2IE4ibLzrdbqlrBeT0dZ+f4=;
	b=RT22ztzoE8/j6VDf+u42mq/QWxmKO48OLtmq9Zo2ne7aTzkKHIiUcjfQPTGdZZBljF9CL5
	wpwhvKBy/PGzKhlhxow+XCuGukPgdBeQ86yTsUQLJeQ2Vc59JZWlS+5K0jBKumdqbIXkF7
	a4GoaW+vM6JZKppD4l7Kmr4xnNEMwHM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+s2CSFkuqwaOluauuzSQsE7gQOEp6vJzaRP3wnuWDopdCgXP+C6QnGn+aMGe17IB2fjt4dsZpsF6pFaY2F0fdJ9V70VpRMfpKxH4yDk5X85mUVLDXlUy+gwUbnoX/kReYi8gAhdpHu7+bgt/bnLjKT1sZw9yaZaAay5XHbNIZTQkoSqZuCciUP8OqziLTMTxh7ct7cWFKyKU+a4bVp7Cc1DtYDZXZ1J3jsjZTczCA2B3rtbLwwcDmoBUphreu6AhNrBw6WZ3xdOlVtt8fZNp2tzQzSvYR9Hu4v+WjKZ5NpbSdwSUISIOMgjIpPUxr2+Np0la5ZMU6sIdPm79IQ1uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGIWkbRlS5G4LMwrXwRg2IE4ibLzrdbqlrBeT0dZ+f4=;
 b=SnNJhvocUqo26VF4rJlbLcuzrEejdExyFU5PszAQNIEfz5GsVY/xnAHwnVE1Y3QMtT4ZldiufcW+keY1djbMxt0aPBRW+1gtZCp7PVwYfRr3LwwZ48hem7eSCM9qMLHMEescELwpNNDInlahK5vxhlYG76vuPNXtVW93vEandzb5cVWkamSbtcTOdkH+RyC6HtOq5BzrIfU6TpM9oL3q6YoPKNnkRZcgro4dI0FD2UtIg6cqtdaW2CHfiZxwcyx0ugyfJzNtyOjlUMVCditJdOQefAZJujtIPL7I7MksFDxhOZg+iUj1Xww+xCieV4OqJ2ezUgw7Dj58PxmQHBjm8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGIWkbRlS5G4LMwrXwRg2IE4ibLzrdbqlrBeT0dZ+f4=;
 b=WKLdH/lD8e35jKFvTwXln09xVSrFEl6G40UQuYSXYFPK1Bs0bKaGOuIeq36CuslBWvmOUAPNhexy2XnYrzHakD/5IbALwmFHeDLgKqTrV6dqchEttnwAxySwwNCMT8KZwV1DL3rLQ5ThP1iArugajIGAZtW5Gc7KNS7VWL1/UeJ3IrUFQ4q1Fy6cj8KoFyD9+PqgiL0hgZhnd2diU7VCoqsxnvwh7wrp/j4ZqhYelBwEnhkMj0Dz1FOgSyFIEEFTKokoR+qEBxvIZVtRwSxvwBhj1Y/cLkun1e+8wFejdqU9s/hG7LLs0mIEIBWbd2p/LTeHKhOHz3syef8WOFHmfw==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by SA5PPF9BB0D8619.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8d8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.10; Sun, 7 Dec
 2025 16:26:38 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9388.013; Sun, 7 Dec 2025
 16:26:38 +0000
Date: Sun, 7 Dec 2025 12:26:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <aTWqvfYHWWMgKHPQ@nvidia.com>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-5-peterx@redhat.com>
X-ClientProxiedBy: YQBPR0101CA0119.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:5::22) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|SA5PPF9BB0D8619:EE_
X-MS-Office365-Filtering-Correlation-Id: 40b1bfe9-53b5-4641-1d0b-08de35ad65be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jhwnHoScDj5B66BekSs9X83KknYeYLOfunXyzqz63Aqd7XUnP7zaS1MQn0Al?=
 =?us-ascii?Q?kEx6zzbLrgji81DR60hCy1kcF9VbdRV4ajRyh3P53lnvEADfQdEVjsSTuEoQ?=
 =?us-ascii?Q?XPbgeBO074PL4LNkkf1V31pN4EDyLRe4YyHaPAKOzmBPfhhDDV9OHtH7UDdc?=
 =?us-ascii?Q?sJxHNW8tIKiBCiQr1frZF3v/bBS+Yn0V2+cmFk/mZYbk+enboRQRQTHtiXU8?=
 =?us-ascii?Q?TNRprlCbfOVK/WjUd/lJ3Q/DnvJeN6uqpyzUx/LBeRkrw3yqLlzMAJyQpGqi?=
 =?us-ascii?Q?DlwS2LwwMgYvfYWySjTsZ1s7Z4h7GRTjumqqx2TlrSNlJtGBTdcYNLIic4yT?=
 =?us-ascii?Q?vHLdVh3vlJJIV1PsVWlA69ZGlQs7wXUlgyA3fDl0Sed5ArG5pS/eRqBfpOBA?=
 =?us-ascii?Q?kCW2BlLAtsILEIjTo5MRYq2TV1J8gWE7lv21TqdMnYJuhoAiQDjMDeQ9tlYj?=
 =?us-ascii?Q?bcs25oPk4yxyrVAfGkTeJOfAthPwZXlbdcrQf+xGqrHKL/YSj4w/DwBeir9F?=
 =?us-ascii?Q?Esi42xNdMQhREAplgKohV9cxV7+j/g4BvVYk92cNr7U+rTekMOqgzayWWouy?=
 =?us-ascii?Q?uEJ4bbLAXiiUApYbOS6tSkMiB/NT9bfPDKUAt0XX/8WJcVV5UmcaFg6WHu4y?=
 =?us-ascii?Q?6PDoqIoIz5hWxuNnzc4/fY39i2/6Osvq+X4aDnqqo4clK2fiQtGJw+dEamIO?=
 =?us-ascii?Q?1j41j1Xssk+N8ba8bVL/BU2+5d3SQNFWH6bZ7+4IOrpJDWEhPRzt83o+nGHl?=
 =?us-ascii?Q?WR6Hit8bPIeDiPd+d0/FIGKsUGcHlPDBhbCEYJQvU1t/QSfHmXXXLXECGZwt?=
 =?us-ascii?Q?rH2geffdzfXKfCLtBjBvv29OC/wY/54HOxJb+IeGeuowum16DVax7xr/Mkfe?=
 =?us-ascii?Q?0ZDK/K5yEZDBQmbgpucsJQSvWfnHpGIShPk3jXIdxfrnQTSooslgSbimOUlQ?=
 =?us-ascii?Q?358lmMKIFiodXubKP9hwp0geinT2IqqxmNKw2iGcgdgECpvZuzhvT3lQNXHb?=
 =?us-ascii?Q?ir7+G2rABMasymkl4zRGu62FdeHF35y2lSqJSKYFWu4YZ2nIIzvhkuLIg1Mh?=
 =?us-ascii?Q?rM/8DZwH1L5yHsd7qjNNIxV3wDy+SrHgnpu+U9ASgwoX3kzUt+qtA7Novsf3?=
 =?us-ascii?Q?Nnb2T/Pen/K2JFhW9JakzZkUI/Lpyr4tr4KP+pOb0TNH2VsON4fIcSvCoQvH?=
 =?us-ascii?Q?qq9lIlf4UsbRJCXrCvlx6HKSVQBzbKgwJcna21r6a7b8gAhINhTsaKVOk8mn?=
 =?us-ascii?Q?Rlf1RDdF/uSdtrNUfgIBzTW4vUu3hUIgsGlv4g5U+hcneu6WAzys6jx+g8m9?=
 =?us-ascii?Q?r2RNgE7Vm29Tmp1Fc9bGY/WIlBS4nEuz5tZaQWVBdiKuzbxY4PEnusQyaPE7?=
 =?us-ascii?Q?Erub62rMh+4tidBe6S3UME51nz5P4hBHZo4MRGIbLXJxC4eGilfqmiXKq/6H?=
 =?us-ascii?Q?tWX1bdwWN2Hy8KW5yjpQaO2YVhziIdp/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VzhUoWWhDNoNfhq8l0tUY5Z+KUx+UrfZZ/1G0tELVBKGFJTyiawky1ORg4AE?=
 =?us-ascii?Q?hCtpvGAQ71ZuQFg5jc2sXT3wihj+17wFypi1syWRFHHtqE4Qvs0EoiQbqrha?=
 =?us-ascii?Q?L7sD0R1R7rH6o0w/3TCbRNH0dfokAKvZ0UWuIJInedNIK1jT7L4RqCRHtxAq?=
 =?us-ascii?Q?cgW0lhUfGh5fLLACG5w00zVipwhKyDthB5Tga0pFDJWVomYAQ9dzUy4C4YXD?=
 =?us-ascii?Q?U3jYaYIPkUjcAM/vD6xI5qfaL53N1B77F91JBpxnmdfpMzIKWzZWg09zH5nK?=
 =?us-ascii?Q?ZLk4S7k/rjoXWCfapf7RSO6YLcLDvzi8rB760+TENf2f4UC9/BvTzghe4w6J?=
 =?us-ascii?Q?D7hkR3RMIhPHDxnem3ib7oZEt/Yo4MX1VzCNIrW6GC99vXvO9NB3iO9t4rMV?=
 =?us-ascii?Q?O5SQj2RnTyyW3UjgmIGXind8YhjZMTSFBuUhewiFkZbjPS25wUAHqgckO1pf?=
 =?us-ascii?Q?CkHyJ+F4wR6Df/H0junmn5IEXPfIQEVdWGkasT18F/Yf059vJdh1ACx1S6M6?=
 =?us-ascii?Q?MJM4+drn4TqwfE14Ga5FhovKbgBSeTVdbHoV6DnlKCr7KhGlV0dxVJeQenJH?=
 =?us-ascii?Q?ZMrAA1/boJ6+C/ciLR8KOYm21N9OWGlGsY6LYw4FUZLhrZGqGix5jROi7TzN?=
 =?us-ascii?Q?pI32pIWP6EIKFkT602o18erUmO7camPMnyAjO0iI6nTZYv2qJ6qZTeDjcGVs?=
 =?us-ascii?Q?moUTPbO1JoGjRG4Yw7Au5jbfJyQKKA6Zwbjwdv2FyIUnMx8iVDaNs4KQVZsv?=
 =?us-ascii?Q?k4A6BAk97JfVkAL7HI86yglqhyWqDdZ8x5RjoT8ppEKaodpAZ+ejLDKZ31kc?=
 =?us-ascii?Q?4hID76AoljKjeIDnvzGXrOtwTlvJoOcdYaLJhbqsqlU6qAzSZ7cs69RCTQ6o?=
 =?us-ascii?Q?jz5bwxUnDFMpRLuEDVrX4jejBWiLYiL3moyVCG5QSE+reAMzoj0ub8ZwabvS?=
 =?us-ascii?Q?ZhoKQEZ/k4W531RWV8WdhiG19TZVq7HUS7yw2xdwCkMyYuCms5gnOsWFH9pD?=
 =?us-ascii?Q?pGW8aPi27Q2y02lksqTtVEM/gou8o+mwRJ+t821n4+u78SQLvqHK79F0vPX3?=
 =?us-ascii?Q?mIUrfjtG/PzFDTzqoGh/oLCS8R4HP6WdqUgs8zUFhiGuSSayKYdKcauWY4ov?=
 =?us-ascii?Q?EIHjsHqw5yoEXDeHrACi7/+gZgNB4UdbFrXLEncVc1feyEhS2OLiNBO6qUnD?=
 =?us-ascii?Q?sgh8lySuQS2/zQB1Y4RRSsaYJ4lj8ctyOpCe9hWD/yzj0t0X9ykZZciuKZan?=
 =?us-ascii?Q?SGq3tfLjDsMbPHZY4bIGXUSlUa6pT3zpLgU2hZwVrWggPvkMnwAPXDp2nPON?=
 =?us-ascii?Q?Jwm51CQ5l+8wq/MxxAUvMq+S8vMmylUqJFteFX0bS9rF0YSY9SLB5cbh67p0?=
 =?us-ascii?Q?Oir+sYjKjS9yPA5JsUxvktlA4EX5/hdG/7fcO+BDyg0meaUjgXNFcQoLylA2?=
 =?us-ascii?Q?mG5xU2DGkTnjKZQwyj9hIg/scekL3yCOZU5wfyrmZjcvneJQD/5RbgJ280eD?=
 =?us-ascii?Q?8mEo3HNEcIPKnJCLHjTEAfef5H6SsPQ9+APnPnbzZxNkcFeFNFcwvFU+z1tF?=
 =?us-ascii?Q?KybUI51g+tmcuwl6MVMgkqZuL/rHkReikU5J0Lq5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b1bfe9-53b5-4641-1d0b-08de35ad65be
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2025 16:26:38.7409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hBZFWRO3DIWrjb9El90EW1FpIqFZ7pawq/nKiOjCSpX7FuyaGfTFQl3ldgRfszK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF9BB0D8619
X-Rspamd-Queue-Id: 313E81A000E
X-Stat-Signature: 67tco19rfyui1zkm1mnau1t5mjt9qynn
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765124801-769644
X-HE-Meta: U2FsdGVkX19Yb97862DV5CwVpkCJx9JtEtV4GytJMJRaHPGhjwPFkhxvfs4GYxGMn3B0gm+vWQfjEEZ+edfYWKbs9WjxGEzwkszIFpFL00pl0aYHM+NM4d0Kxxl0p0Jhh65EhW1dM0djiMTyzMx7SWO8hzQG4BsMG2xW9US7eUdz4YGd9RMXUdTdv2wbwwySbkXZjgT/dhgc/lai/GeLQ8tnjTPGhNH3rfgAv0qGeFgrJgsjpstspZ56MFSTnlnAI5TiAcU+OC/fSsxlLcz+00bXNE43jrygx+GjGFL2CpH6wmW9OvnD9P3SKCrFqupbeAGuBngkjvnRARUrHIGky1Qg/KgQetxh0WL8Kkuac2nAacDM13V+dT7g35cRwe7amNYwsnlVNZB6NtTknpMD5M3Zxz9Y16HSjUCGavmE/TxtBl2gpWAAMdTkXo/T2cZBFXIRsFzWP5oJtUi/UjrB6AyQI2l7gw3lIc+GCRLMjRnDe1SnbVdaUZfymIwza1j0CvoelDDYe6Dv514hE8VP+FVG0RfdVNT2UFzF0AFuF0MOyjQA5/uyZhQYbzG4vfCLJIAfww8oaVxjtz82EHBM1ZrT+prYwBp4eXf7BJotXFpb3uKZmK6C2PV1AHKY3NgeYGf/qMGXfwvm6EFZfSSPThM3qmh0Vi40BVJWNxQcpfyJOmsIlTq0oOHqPOumr564zM6Ni0sEfXNacqS6mk6clTH0ECvC9RISFKTLNtjyLozaPP6czeBcSU99JhU1yTWdNgBB0R3g+sjiT+XRW+tYI3OluVqd/hGIjF5pzq0xOrTzlip5SqbAmyHwmpW/iC3m3XdLI7vrCrFhY2aMYE6sdAdBn5UFWPxkXAKv7ogXPsEZNaU2Qn/qo2gObsRjoaFPXF6x/BO4VbOTHIVq6ms0z3PVi3nSh2na9EoFQn1d+giwpo/Qkl3gk8X8x/kTF4VduKzvJGi28Wa4RA4o+kh
 DswanRdZ
 WNuGLMo/9Lv1U/pcwNricwC46hnBB8moEyWhHDUOSbmxVuIxdE6mb3+66SskfGqrzPW9/no6Fw4l9tAHOK0zIEwOH5XZZfzRF+woF4xztUVhapBuAGsvsdEDr+YpJvZXhvRy2aC6oK0GwaQFfm1KMMdv/JfSyyIM0jv+045Lp4ZC0/5wos8HZVnqk6UM17PcR7DTLjAiRL53lOygTSXTpv9MDeHHQqMZ1xjNCIkO1qbaGRyFwsMf53yohA33cKa6ufPULSCT5yIESNUaBW3NS8Xl2nffv2chcrY2McwssebIE+832O5w3Eio1NjuPvih1vO8u2UIy4yr/NIuuKKhsH+8iCO7Oa0hv0n7ziB2Peh/dWQjxEjl6X+VYWX6k4sYZIn1l9/fKWBNQiXlVqycH+aSQC0dj0RsmthTt3O1oMs8iHxNvcbCXdjddJ6O34btZyMRWmiVf+778scdHkbKLHKxyzyZD1H9pejlRjzhIP1zEEvIuiprTu4tkiMXZu8qHrDy/F0GCG5DgDcY8/oAkL76t/rWnGYwwPeRJrRuJ7SxBofCbSpWNKdA39ubqAb20weVY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 10:10:03AM -0500, Peter Xu wrote:

> +/*
> + * Hint function for mmap() about the size of mapping to be carried out.
> + * This helps to enable huge pfnmaps as much as possible on BAR mappings.
> + *
> + * This function does the minimum check on mmap() parameters to make the
> + * hint valid only. The majority of mmap() sanity check will be done later
> + * in mmap().
> + */
> +int vfio_pci_core_get_mapping_order(struct vfio_device *device,
> +				    unsigned long pgoff, size_t len)
> +{
> +	struct vfio_pci_core_device *vdev =
> +	    container_of(device, struct vfio_pci_core_device, vdev);
> +	struct pci_dev *pdev = vdev->pdev;
> +	unsigned int index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	unsigned long req_start;
> +	size_t phys_len;
> +
> +	/* Currently, only bars 0-5 supports huge pfnmap */
> +	if (index >= VFIO_PCI_ROM_REGION_INDEX)
> +		return 0;
> +
> +	/*
> +	 * NOTE: we're keeping things simple as of now, assuming the
> +	 * physical address of BARs (aka, pci_resource_start(pdev, index))
> +	 * should always be aligned with pgoff in vfio-pci's address space.
> +	 */
> +	req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
> +	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
> +
> +	/*
> +	 * If this happens, it will probably fail mmap() later.. mapping
> +	 * hint isn't important anymore.
> +	 */
> +	if (req_start >= phys_len)
> +		return 0;
> +
> +	phys_len = MIN(phys_len - req_start, len);
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE)
> +		return PUD_ORDER;
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && phys_len >= PMD_SIZE)
> +		return PMD_ORDER;
> +

This seems a bit weird, the vma length is already known, it is len,
why do we go to all this trouble to recalculate len in terms of phys?

If the length is wrong the mmap will fail, so there is no issue with
returning a larger order here.

I feel this should just return the order based on pci_resource_len()?

And shouldn't the mm be the one aligning it to what the arch can do
not drives?

Jason


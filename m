Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F142CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 01:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C141A6B0005; Wed, 10 Jun 2026 21:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9DCE6B0088; Wed, 10 Jun 2026 21:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E9B6B008C; Wed, 10 Jun 2026 21:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE9B6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:13:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43AAA12042C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:13:00 +0000 (UTC)
X-FDA: 84865857720.12.943932C
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011012.outbound.protection.outlook.com [52.101.52.12])
	by imf02.hostedemail.com (Postfix) with ESMTP id 714AC80013
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:12:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BcmKw+si;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.12 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781140377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTr2cs3AZpk/9JR1LGQ0mPxm42C6MibLJNJUMvaZ3Wc=;
	b=VKoXBLokijasJRo43tm8RM3MLGBPXwd6ujlWc+c0qKEVSOx1pHtNGAnE5yOvxtM4PcKRDM
	MgnXpggSPFgs/FUPMloSqxxu4/WcvftA8gX5rdb/CO0O7V1HrCcLeKkDMZoJ0y7gMV1O2I
	GfgNbMmhhO+MYWDDpIEluLLuxes6GY4=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BcmKw+si;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.52.12 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781140377;
	b=sUuBeKg1G986mkHxnxDo8rTDdCx6MKn5RDp9K/2uMO+MkC5rr52lS0/JETZe0Jv7rGR8Y3
	PVveW00eiPGDKpIH0PPLV8LLOuFRMpaW1qyemS1zJUOOqEZQi3WtYAE1CB0w8nzEo0NzMU
	lXi/qv6W2U5M3PvkqSNzmL3Tiksmd2E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U+EQsWskjPvTc3cr6Vo1IjS5Qtzw1inCBwLzQUU+v3+GZ0e9O38ScKDP1nfPyZt7S5ICTT0GGtt8JUhOygCFv2JNdGE6DnpxQNaZ1KRHm5v7LLSi9eD5CcLIeiLR7gwWI+kBEXV04spUegjd1VQtDei6slHTl31WDNNXBi7q8AVXH0NQhe9AB9LBBDXfjiskKzPM6ahHZoIbfylrtgzrD4ZPHqnLLZEhTwon5KfydJv92R3Pak0olrWnohkaTBQ7EGMMDcA5wmk/xhfdts9RLmi2Q8MvcWkYv2NasMQz38nyZT9uy30+xOiZZ6AW8brEwrf5iIC1nIrrLo/rgFg0UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mTr2cs3AZpk/9JR1LGQ0mPxm42C6MibLJNJUMvaZ3Wc=;
 b=gOxOxAG1hlAxO23leyPBwy7CZnHS7J/uRJrVggdFn/QIqN+A3h+dfjNAVbnW2asjrsMeAQ0Ioq1tV0N4WFFb3RSek/Fr45mxDid0zoRwpW3wE5dRsQMikMwKMlZACmKmNO2NPuOUdj0YMgEic1X3C7T7jz5YcCYkJBrf9BrhqKv1L9gXESE+X0AS77vRfsXlI7qUc/WZO9N0+/jMYYAWYV7ED/koRhhISRO/MZDmU1aPzo7iCjJW/0EnDyCBjlpYOFL1GvDqOHZ2D0LaXoj/Myy9E/pOiusUay/LOi33/bD8xklTe6Uq1YrSMhQ/vw6EhuA1ZXvFd0W38ChIIeWfSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mTr2cs3AZpk/9JR1LGQ0mPxm42C6MibLJNJUMvaZ3Wc=;
 b=BcmKw+sitoRo4iVkzttZG6ARE2QwJIvO8753yucPqtEClOfpWbVr0BvQd4c+Y1ItEqoqZWAbGByunaNp7BmXz+ogUNzP0Q/xWtxPbQ5IO/CmV3eMWCH3EBwDsZ9frYZOvLvjndYUvArw5bryyriBOYcNXoPU1Mu5K2qnieJ/Rmg9xv6r0P5DXPozPIbEF+Ror4fLTh9JxvKg/XHhGZyIdI8TpP/xu6rySbIJyx8UTfihYcjyoqZN42RsbbcPxbgfHhS2UaCdIGcAfOkRnqRbsziqO4+ElUhLsFU1w/MuQuzVmyQqTCVgVfVGiWf8JnXLy9zXCvL0mLYZPu8yMiugPw==
Received: from CH2PR12MB5001.namprd12.prod.outlook.com (2603:10b6:610:61::18)
 by CY3PR12MB9677.namprd12.prod.outlook.com (2603:10b6:930:101::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Thu, 11 Jun
 2026 01:12:54 +0000
Received: from CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe]) by CH2PR12MB5001.namprd12.prod.outlook.com
 ([fe80::89e3:6df0:de90:8dfe%5]) with mapi id 15.21.0092.016; Thu, 11 Jun 2026
 01:12:54 +0000
Date: Thu, 11 Jun 2026 11:12:46 +1000
From: Balbir Singh <balbirs@nvidia.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Sourab Gupta <sougupta@nvidia.com>
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
Message-ID: <aioG_ko6HoOv8qlc@parvat>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
 <aiJbJVbD4W-y1XDg@nvdebian.thelocal>
 <5aae8c80-e886-47b1-a1e1-4e91771f3492@kernel.org>
 <7A8AEDE1-C28F-4490-8A2E-72E4E8D0E78F@nvidia.com>
 <aioFswTdZCdPGjag@nvdebian.thelocal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aioFswTdZCdPGjag@nvdebian.thelocal>
X-ClientProxiedBy: MEWP282CA0172.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1cd::19) To CH2PR12MB5001.namprd12.prod.outlook.com
 (2603:10b6:610:61::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB5001:EE_|CY3PR12MB9677:EE_
X-MS-Office365-Filtering-Correlation-Id: 34cfb142-8caf-432e-d6d1-08dec7568edd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iZxj8ollSr9fh06u3J/Qb50I88TuxVV5L6tn5I/WqcIyP8E3n7Hx7i8ZlZTXakXcMrFa0hbaY7amw4IoFmAWtCf5SLLUAj8+L73sshlN9XnJigV6wxZw1BctULNq4994JHCW4jkqL4+6npRRr5v/rYGvQ3wNus/rMaq0/TCOEVKjPfK911vq6fVT467ZLWzWiRuqfls+Q39Nhu4l1VflDbJOiyiEMzHBzlbdcQvEMV9KdiSZKHSQkU7f7Tfwf5f59vcKferqSGQrI7aXWy9+GCKb0lf15wiQ+m2C6yTofva4bm3x8dH/u9klFTDirHRvajnibWoJow2faZxFQX/YV0OLSZfNF3wNFTdG8uhqYh6Cf0qiMXf2Z15081Wn8zEXoOhj0jdiE7IiEv8nV+hjYwtg7bMWzRJK3jJWc9uMZMKggpQ0cOgrSWnKfpMwIBeqRt/VnnJwd9pK8Kg6F91xfOukXI/awZl6eLafFEwDvzMkmiU8U/VttKbPtlXtxJr4mjDx1i/kBBg8v5zXzKS1CZUua+kPiztH2xiSJ2ls9xImybt0Fj1qUMHpmNwN06uIM2zM1EIJ3FfMYdzhu/r5+ZpczPN8LlB6He/AJP5RSHllsdhlnL/faQK/4nCgjBIurrljSTk3DITsSpf3F2XRBm+Kqxvb1tAWnWPSyap83R5tIwG7sz1Jwme5MiVa3/rn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB5001.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ChmCl7mOCYL0Nzqa4ZToiLYKNBFT990XCsRqrZAZYBThHn323a12qiFwEcbk?=
 =?us-ascii?Q?/LBSRBo2JfaOBeMD/rPj9nvQS0eUhAdH+yzFLy3gwIvtCKnqD7A5AVEMdnEb?=
 =?us-ascii?Q?QJsoV5D0nbo4enTq0vps0PhBjLybOVxN/J9olwBELa5FEEi4wM4eHiJJXkd8?=
 =?us-ascii?Q?AIot8CgJASHrKAsJchwhfcuW8GQomMuzsyvW3n7g2MhB05wrElWRJPxvkkdu?=
 =?us-ascii?Q?DienV9KNUh4FJz4Liwxk+F1K0y8jlMpKUwThfuMl6u71iPSOpipW95aSHoKc?=
 =?us-ascii?Q?FSdxujWBxxDgTf0sWZkal8eLfba8RGEaMuE48u9fAxY2coitftlWT2XClAuU?=
 =?us-ascii?Q?vatx0iUOB6K0j+Mo8kiq2u5AQkqAuMBUeayQqZsLi+Xsw2RCxSbj/pPJ6bAt?=
 =?us-ascii?Q?bhb7SwzunwfGVkX9fatQfgnjOVzQHzkLOixW39cAxlNvPZ+vXCRQgKoOy0DI?=
 =?us-ascii?Q?xt3AeEwlpFb7E1T3KmZ+f/v5JM8su4ttaA6u1ei3V4SckjDHJzuhckRCPjcw?=
 =?us-ascii?Q?6WhWskUR6+k1vbLfAMzmT7GZji4nnj4S90Hsq5bC0HTogbQGb45RkYEXV2z1?=
 =?us-ascii?Q?M3UZY0xBRosBPxqPMhi14JT2z8jzdAdGRrFlV5QU4srGv3OxRGs/7e/G+a8C?=
 =?us-ascii?Q?Db+dDfSamNaI9EScBGqBKfaJlR9pktbRkAc5XecGikk+4UCrBGLJKvhpSJQ7?=
 =?us-ascii?Q?cw2MsquhxpPSZzogCzVSEkExeoQCq7RwrLOa6AQ02AR59NYYBmSCuiBALhTc?=
 =?us-ascii?Q?2ba0yv8rZGB48/bIxElwjk1AcTW2s/mb5GOwo8wGIYN2vGZxF77UBFx/4bOp?=
 =?us-ascii?Q?bHezRq7iXXcnypoGIHEjD/RPkcfRrbxsQ3R6EQ+fqp4X/YZoVHFON9yE3Bgu?=
 =?us-ascii?Q?1gLh52Cstr9oOgWgPBAqA1SKfU/a8xzl1Lcakoxlz/lZTMY3aO2X2uiUrjW9?=
 =?us-ascii?Q?VaS1NpUrCt0B9eY+xSbAS+cLkh0wVush8t8rJLXCGvliLh6rF02FVMP9Saz9?=
 =?us-ascii?Q?Vdy6jbVWaZK09uZGFHuo6uuTpEtU1FbRukx3J0vkBtp/2C9W1WFdarANn+p4?=
 =?us-ascii?Q?/Y4q/anvryeryoyf8nNyBkk5utz0KsCE6BuKPiOSLtS38xHlHLWPiR8fxBMI?=
 =?us-ascii?Q?gPQIXeAFMAS4J64/hxT7jdWPdWmSaF57KXaWPMtiVGfCVr/rvPeVk458IYDs?=
 =?us-ascii?Q?lHJ9mP+F0Wa3lCBw5qL7T3Ae60YqsDL8PPJl+ahNdooqO5xq7WQLcmdXHQ3h?=
 =?us-ascii?Q?57+P86h43AnTwZiL3eutbh56etrrntSPMLrxvXSUm2U9SwhlcQpZixQffdUc?=
 =?us-ascii?Q?4CBnpP4ACCXiE9DOyO/I1FgYhdeO5ZacOAVzUEX6IlCTIZZQ2yelDcvrPxmX?=
 =?us-ascii?Q?WJ8SUdM+FvMczhaI9dr7sNoSwMOm3qVWawSZLgczsSSsyVIecMnP7HvzPlKT?=
 =?us-ascii?Q?7H9MbW9AdRR1w2pKEwkqBR00kAxnxdpFBCy+MI4D3V2F2FphmsnvGoQLnQZi?=
 =?us-ascii?Q?+aos+trkWkv47bMPrAD75qdPID1j7Z88xDc+vBUvNVd+wl1QFOBoKeqNL1pb?=
 =?us-ascii?Q?FxxZhkoVfy8H9C9T3DMZ/qVYu0GKLqWjknT7+i/708eS38zKogAUJMaj3a8q?=
 =?us-ascii?Q?flgreTikV7U0B/S4iXSIzYQ558szOyeF1y6lncT4xh2dHtDGPOHjL5ik61WO?=
 =?us-ascii?Q?xNdN9pgt9e54ur/sxbxQmmqJMhZq5/Tr7frEP/FagnxqPSkzkZXkRV8AgdWi?=
 =?us-ascii?Q?4b2fB9nl8w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34cfb142-8caf-432e-d6d1-08dec7568edd
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB5001.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 01:12:54.1220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GAYQmE9sFJ4h56niPC57q182vjhjBWAvYzBhsGHq/1VKIdLcwJEESQAUDMBAGp/CsWvnNd/oU5V+3opBcIZyeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9677
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 714AC80013
X-Stat-Signature: 55bymyfhhjd1kt5uukock7arfa6cic8a
X-HE-Tag: 1781140377-637000
X-HE-Meta: U2FsdGVkX1/ifvSEZxZgIbiyVoi1f2sFyi22bHVkKc5korkoMVCcQHhn1mQeaf79UjdMJoIvqdsJhYv+EzDQkjCAJC361FYEBhXgZJEnrDkNDOWWTq63kUuUgbqd5eNHBOEYVCtCpVvi8mT7u8x4n4TzhitfyOScswp4i0qYmEoM6xXDBQdtkye9WYG7pWTgEv9Bf0Atv40jjiXnVmGCm+AnhS3szaSoYtLHTn2QgR7+Bx/gAHpDvXEfrcYp+zDyCOcsN2VT/dA0KW1i7yl4z1MelfRenp/2qk8orRpxtGB+dle/taplOq9w9uzXzsrDhmJeq2ZPgYXlMYTgoizmf4pAL3kyvOLSbq1rd2r4O/FbJOjY/jRChHvC7vN9xqk1VPeG+0c4tbpt8NttvVxvMadmfvMpGY6Vz9oZM+48j7EPhK9pIEI0KxgT3lPDU5XGiZcEuPSkp1dqTr6Oq+qVQ7uxcKHLzrOQ7tcqGGQniOdm2/QijRvAWcIcnnXAQiI0V2nwP0e0lk7KRBtHU/2MC3XA6PZzzdNWIVQTu8uyjUmiUj5v7tkAO8llkulbNbVTfIdTIflzmoZs8CDyRMxrOJywTY5ABrsRMD9EGyhErjFJV8VxhrQQ3dpGsxyijXNrkjtFbTcMtj+dOv5tTN9X/07r1BUyX1t0sJRlsqSdUPPPZvARJwJltlEEnjn9JsDcQnAtNCpKz1YFrbaln9rLiwzwNNtZ5/SaacuVbh0yP8AIyc0BrvY1lty6TprFiUaBLxSTheIvbtv+mUjarUg4ecjk0/CXGgZKnZiWMPv3m0DVTAmXZ+9Acl8bDK6ThiE4O792ZkwJxVrphYKbgEbR0AqXLi4p6gFaDXeWo/jTJTXKh+lxjtMCvxRbmC20VP96tDjt1pSTxJTI5tQPOJnbFj4An6BuhPqr5vut0EVh15Mbq0kRM+5FpVUOaS0FUYD0PQl1mMiwHcVlqdNICyX
 QSCGDRnr
 VQub8fbfJu1NZNGZ7idXN40jLb6U0z5i1cBz5OqqYV35hAgCHRoXzg2SfP4qhUpisx6XyOb3UZVZe3DRdCylHi37FyqK4qMfssiDRKhZ9yvFNQd2vjQ7Ba+fCT3b+Y+PGsHKYD6OEf4JAhKllyZ9u71eZkk/vR5oIYRu9WG6bZyNX0YkPwMWchVwYNrMPSlrRZgsXtRegF3N19yjyHPZ6C3QW9wxBlgT4oPV6tcuIdut+J6tRSMKgpb9TXOl0SetPF6MlBuEtzsDtNa31ueSLx9DGZPr0Di2ih+TKPpI/9nWteIMJObKuI3PK5l+k53LRidGktFWJwekb1vRHV9kpju5wIg4od34kMR8JQbc6GbYew2oHDaGd/RaMngbzfisHatEHzKp1LH+hOI1Mq5pqx+0rvmEKuF5d8z0vRKX5zufD2p3nCw1cjGsbIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 10:49:59AM +1000, Alistair Popple wrote:
> On 2026-06-06 at 02:20 +1000, Zi Yan <ziy@nvidia.com> wrote...
> > On 5 Jun 2026, at 5:22, David Hildenbrand (Arm) wrote:
> > 
> > > On 6/5/26 07:17, Alistair Popple wrote:
> > >> On 2026-05-15 at 10:09 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
> > >>> On 4/9/26 17:52, David Hildenbrand (Arm) wrote:
> > >>>>
> > >>>> Hm, what if secretmem folio just got truncated? I hate to rely on some
> > >>>> handling in the caller to detect truncation differently during GUP-fast,
> > >>>> but this function returning "true".
> > >>>>
> > >>>
> > >>> Can secretmem folios be truncated? I assume you are referring to
> > >>> ftruncate(), I am looking at the setattr implementation of secretmem
> > >>> and it does not seem like it can be truncated.
> > >>>
> > >>>> Zi is working on a way to distinguish folios from non-folio things: that
> > >>>> we can identify whatever was added through vm_insert_page().
> > >>>>
> > >>>> Because that's really the key problem here: vm_insert_page() pages are
> > >>>> not actually folios, they just look like a folio today, but looking at
> > >>>> fields like ->mapping does not make any sense.
> > >>>>
> > >>>
> > >>> I still think this is a short term fix worth having until we get
> > >>> Zi's fixes
> > >>
> > >> Agreed - this clearly results in a performance regression and we have customers
> > >> reporting it as such. I think Zi might be out of the office atm but when I last
> > >> spoke to him he agreed this fix should go in for now and his approach will come
> > >> later.
> > >
> > > He should be back now. But yeah, let's get this fix in.
> > 
> > Right, I will work on my solution soon. Meanwhile, this change
> > is simpler and can be easily back ported.
> 
> Thanks.
> 
> > BTW, should it be back ported to older kernels?
> 
> Yes to any with f002882ca369 ("mm: merge folio_is_secretmem() and
> folio_fast_pin_allowed() into gup_fast_folio_allowed()") - we have got bug
> reports as a result of the lowered perf that commit causes.
> 
>  - Alistair
> 

Ping @akpm to pick this up, if there is no objection @david

Balbir


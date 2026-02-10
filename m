Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D7B0EA810F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBCF76B0088; Tue, 10 Feb 2026 08:13:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D403A6B0089; Tue, 10 Feb 2026 08:13:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7566B008A; Tue, 10 Feb 2026 08:13:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABAF26B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:13:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 54762160567
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:13:20 +0000 (UTC)
X-FDA: 84428588160.27.651B543
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012051.outbound.protection.outlook.com [52.101.48.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8DB7D16000F
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:13:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NuO+aV2K;
	spf=pass (imf08.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770729197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4d38eeijqML1QQrQYHP0U44Ags7wvQs5ZCf5GP4Syc=;
	b=taqcHa3foMXQ2HlsGz1SSaN/v1xvKl4Rvxak8TXta4yptEifwEW9IqkPilvhPqnqlZY0IX
	GaJu8P10eXVK1OfzQwLRw4GMxz0vSSU1SINHBi5O6DiPNyj8UNNHdlYtGlbq4+k65WqYtJ
	FIF5lAJVbDeAB9ea+ubrfg1Px+RA8II=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NuO+aV2K;
	spf=pass (imf08.hostedemail.com: domain of jgg@nvidia.com designates 52.101.48.51 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770729197; a=rsa-sha256;
	cv=pass;
	b=xmhf3C4V5ofVuTD2fWYA5OvaSfClv3zmjL6/hJCYr8SlmQPUhu544jmXFbmqw/yCnfsj/F
	sP4bmnNZMaXRr0leXsGuvzgHiv6w49GhcMve+LYxaGq27Hqnf+cN5SWG8WYqSW7vurj4F8
	DGk5eC5FWPQldWfEnXy5G2FxsRIzwMA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MDYkENJZ7J49mdor3Neh4qXi8oGNAH/3p+Wm/dCMifQeVqFT44M2zWHwx1uN6QK1D9ahu5echh5S6HtQuDUZeH0NJJShZEJ5CXUj9KZOtffhQbUPCJ3ORMmwk9I/hDSUfOeqqiJGnbGD4mL1OZDI3xpRLTHiSE2A7SysPhZY81Wn7a4UBCIQryqnd4+wJtfGGxIgNVf2LYAFE0vR3gJUCeOr7DOm5P6MH5YxvcfR93kxTQaVgfnZiKdo77nYuDMegZZ92gPGWaCXBof0UvrvXlWPG+m6IeTEIQSM59sv5rLtv+j32aolzt121yd9HJ42z/Zi496j0KR7GBtGnHVAFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v4d38eeijqML1QQrQYHP0U44Ags7wvQs5ZCf5GP4Syc=;
 b=YgQd5w6qKM5TlQwwE6N4BFIGPvvo5gYWxdUrZMJzYrOIbtpv4LB36qTtL6r/3w/8xavFgxhc7TalK6qnRU6elloHJEnpIvvo7JzQkgYpyWMghGe/Pn8jslnH+8jHKCv7AfmPppn67FM05RiZyBcDsi7bUikVFl5RCHvHNzFqn7Fg4RzSzhBG1HGmpzVxHEMI7VlfpjijihwoCemJHeObSeZsT6XQPRYlnkDRvYydhpEEIl37/hWrwWLmQ5InvfY9hVE07FhgtHJXgwATJpljjFiJZ2xU97ZvnRK8rh40lqb6EN9l5kPmyKslY7HRZyryCDqSTjRwDDHQ8KRxQP5vuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v4d38eeijqML1QQrQYHP0U44Ags7wvQs5ZCf5GP4Syc=;
 b=NuO+aV2KtVrNEIX6Ppf4MnQTfadYXH0MdGWcsTsuPB2GfUUHopBdD3xhWwf0LAkuI7oUG1LvsEv01LEpDq/+BSHSd3AoagD1V/MFjesuaeXYHvBuqg+TRFWoo3EwCJb1qnWokOwDsc7NRtDIfnQLc/VBxsSN/Gx2qCDGmNLiOlR8ENkXVHoNFqOD/N7sBVTDpuckf4c1uAxPK1lkBN26XeG5YVD1gD9FqroMuHs5YHXm4uw3A9sS+Q45vI6mf1/4LgGq7IAnLRw5ApxbXIbg9qvviCjT0RCSsk5CRr1LFOlAz2ZoN3gPXc+Va6qgpKjExefad9WL5CRFde73L8VC9g==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS2PR12MB9591.namprd12.prod.outlook.com (2603:10b6:8:27c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 10 Feb
 2026 13:13:08 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9587.017; Tue, 10 Feb 2026
 13:13:08 +0000
Date: Tue, 10 Feb 2026 09:13:07 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: preserve file seals
Message-ID: <20260210131307.GD3076640@nvidia.com>
References: <20260123095854.535058-1-pratyush@kernel.org>
 <20260123095854.535058-3-pratyush@kernel.org>
 <aXYGkb-QtYNaWYw4@kernel.org>
 <20260126183115.GU1134360@nvidia.com>
 <2vxzseb8u4kq.fsf@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzseb8u4kq.fsf@kernel.org>
X-ClientProxiedBy: IA4P221CA0012.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS2PR12MB9591:EE_
X-MS-Office365-Filtering-Correlation-Id: 53ef2e98-069e-4e56-4460-08de68a62246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Pu+4zd8e9olI8mWycAlf9XkQou4t1BVKQdhS9YqGh30EloVmHSScgLA3++zC?=
 =?us-ascii?Q?0a5QpC6np59KJjF9WAjVbF8FXNYF3+4ekEpB/2vDkCabiyYw5QfYn3P+L455?=
 =?us-ascii?Q?AfCUoMvek9fHJPIzvXsCVm2xb4uEgCPkpc1+oglAWHVR+0h8s8WB1+ifHn12?=
 =?us-ascii?Q?pDxp3DLCZBr752RhXX2043UOKYDXQbJfdDeCwMZpNN9HQKDWW//+RhakfIri?=
 =?us-ascii?Q?OeJQJyQzx3oykIqt1krctS0b8UWYBjwtNGNJIRUJQeHIpZDKwsuRBPv336iU?=
 =?us-ascii?Q?hGxW1SInnyUBc1abaeDCjh0Kcy81/MMXK1NbqryI85GTptO72oiSv27tyjJN?=
 =?us-ascii?Q?qi+BxEu/H8d8nMxcFDQ0iiwXVnkHIw5Spgdf1qxF4FA+XVfnx6OlX7J1BD6X?=
 =?us-ascii?Q?7GhTJONkCchVIqZKpxWs9QPqTbxuvnUAZEztYGsNVkaYXjZNg1ihHA7XZO5a?=
 =?us-ascii?Q?80Z1BkT+n8elnbFapPh9Av7yciiQfIlyRB+/w4dFzaIG0w7v1exvRX5BwBh4?=
 =?us-ascii?Q?ANSJIBlTRp1oWsaWrKWU/cHrcyqTub6auZCVEaEDXWtqZn7W6FqH+lodKX4V?=
 =?us-ascii?Q?UuJZLtykffiLfi5gYRDQa6vaMRNDZRqWFliqgwspzmXGJu5rT8H3rPrYXsaI?=
 =?us-ascii?Q?zewdSWuY1SdwpsPyW42FHG72lCfPltlK5ZKiTUFBUy0tfBAdGCG5ooco6LOR?=
 =?us-ascii?Q?beFZ34UMLS52WOPSsmLs/guVi9WQMcogncr+lGfY5k+Z1MrQo9RvAT8Gi79x?=
 =?us-ascii?Q?QZNEcmB8GHx1gPM4xw/zE11GdkNqztkjhOcdK3CjHrYiNgEU/rl8x/1rrtNk?=
 =?us-ascii?Q?b0kuV5TY2EdnFNZ0Xv8o7KcQ8smlUSKJMjA5Evabhr9yzydWNrgwvy8/nhxw?=
 =?us-ascii?Q?YpcMCJLk4BtK01vxfX36z1axRw+TV8hZDeNJvcIbbquraYCMglMTmjpGMpUI?=
 =?us-ascii?Q?k01pIpGzHJEy2VDpDk82OZ7ZqCyeTqZb2sP0yEX15SW9pygN4DuQjio8h+In?=
 =?us-ascii?Q?FSm9c/XV4Nf6t58a5Yr46TYjeAFaPyq+8VWdd2CueLwXF7QOGZVZNpn79eih?=
 =?us-ascii?Q?uUL93QVrfMnTVaJyNlj/BSevI+EGrUUKwfHjf6ZfMoURHhZuARlQJjL2hBHy?=
 =?us-ascii?Q?lFFp9ur0Li7vw3EcuSNxE+jwUElqqXY/55PedzQAACzEdLAs16xgTrDz/awp?=
 =?us-ascii?Q?lxpRU7v1q25OoB4+NshX239DHnU7Sgy+aAUshCBczOY6gbx80nKKPhlypJWI?=
 =?us-ascii?Q?JRhhSGu1RCtfGq9knGL4YLikOMOk+XX17KyKROY6oauIldoNE2yi2JjzSITD?=
 =?us-ascii?Q?V48kLxi67bIsrm0LiY5azUWBW1fgmJM+SGBgga/YBWydi977Zt/qB89uoGjw?=
 =?us-ascii?Q?mfO1cBWaVcdaSpLu5wpDh6AtaRZGFWNnWgzdt2P4S0AGr3x1g5UsCok6X1vx?=
 =?us-ascii?Q?Y23sFiFGfaoONq3WE4Z0WCmmzO7/l3+MXLl6DqTgt91e0gdBC/jxy4Uj/k22?=
 =?us-ascii?Q?MiXZl5QTZ1MEvEvrX629zkn+jsNZzG1AxHQOqzIau68orda2EFRZC5WVE1ZG?=
 =?us-ascii?Q?AzIj6tNUVLumxTlWh+A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ym483R3xLaEVZqDHfTU7lIWhdIhnSkybptJsuyoORHg2qNa1isPHvY2k9DRo?=
 =?us-ascii?Q?A8HMQLTgtvVGdmI4juNUPVeAt6EP5eZtuFW2wkIwfbzsBAiKMaw/HyZsAKZZ?=
 =?us-ascii?Q?dsfLQm3F4a/w67BrSHV+rfH/ORGCa6m0FmPiMPSo6F2Nl7qkV1jeBDx9C0Fi?=
 =?us-ascii?Q?HZGBIpe96nAUrRcnUyryE1FYRID+/pubH8ydQRNfpMoXYsR6+II0f5sTrwJg?=
 =?us-ascii?Q?s+R1Y8JRTvpZUgAB0ALgTDY7DmvWMmC1cB0usUgyroHTRhqS48c5Iyor3VbI?=
 =?us-ascii?Q?HX8DUMvpkDrLMGHUIT5LkWlM/QUR7bgZC7wKxmtLjuT21x8JtLxVFTIkZxH+?=
 =?us-ascii?Q?tXvnH1J6X4FczwJD3vcSw5pXHAnYS0I+Y+1H8yDu2bh5o+KvovPgihfklDQ9?=
 =?us-ascii?Q?3zvVOxyoARrNYxdmXto6mQDSXhXXlMxyJC4jEX51TTZslE7eBJqKTiGYcns9?=
 =?us-ascii?Q?YCb6q1QwLJPdP27cp9WhtjsTEQ/lQV+BFtmjo2p/iILGnQAlmGsYJ5P31d3X?=
 =?us-ascii?Q?LxTG1w0qsRP5NLKDtjkExVASppkriWKWJDA1uB6Kfqabtzjg7o6nVWbmCDsJ?=
 =?us-ascii?Q?P073qOX4/2dNseGiQq4UkszkH5THQlqlMa///3BSMq5fSKSIcsOHgBN+xFF/?=
 =?us-ascii?Q?QiTK/M5uMASpnr//Y50wJhWeYrCSAEXOHXAWVBZlS+jm8r4sOLOR76lO78Et?=
 =?us-ascii?Q?njueqoUs3PnVZ2X/vz0B8Szzt1Wbz1dLrN5N5BBbvXkqpofRt/hqN+PwFB4i?=
 =?us-ascii?Q?9tWweqMSZaZMtaQ4+XrAY+jqoG2Q78zGX7kXkkWh56xstMnJLO0/yiCI78I5?=
 =?us-ascii?Q?T+Yob6N8U5t4ERmKehoMtXKe+mqkhhfQ/OaJ9Va9Fb9nb/YdDuHBZVU0VCUW?=
 =?us-ascii?Q?Gu5qUvoe646MrGNwfhq6SQEkl/BmvOHqgPS9uvLfjYxrfT+24xX5cTi+PdMz?=
 =?us-ascii?Q?0m5hEbPzc/B27K/VOn8gw/zsWE17rRqTLZYOtvuHocfsoVBzJS2NDzM/tNOR?=
 =?us-ascii?Q?I4lMy6xZ5ChHJukQ8EzFCeLU6jWbPxN6NBRfA9VC9tN9TaWomNYrjK/sNbhz?=
 =?us-ascii?Q?5mpevnkeU7xFBmrHlxHttto5bQPD1suiHZehlXFNCO+LRCYKg3ZlZi27YoPk?=
 =?us-ascii?Q?z/MPaMM3azU70KZXHB/WcA2NlzhCXvQOw4/9Zs9EcKk6KREKl/fjlP4yz5gc?=
 =?us-ascii?Q?HIQYHE5WebrM54NWwOcn4ShT+FpT6sEAIvpmlNeoJiA3shFdf41p3G2tHdRA?=
 =?us-ascii?Q?LCro5RiyxnXauzIzw1elUEE81olCR8Lgta5fxxdreARSI6VmrUDhmO0MAzIj?=
 =?us-ascii?Q?v34Bwpsid2JfOiIQZFBVCKg7v/6aSG+2Jw0ueR6zQsgk/5yWqWGfPs3jyfsu?=
 =?us-ascii?Q?XTpZxXxW1B0irW9ur9LmbK8gkFXWE/FgjARGMqGMm8yscmIbGV8xae0ozqH+?=
 =?us-ascii?Q?vnzsG789F1nmwznhGvnPV0zvicuYqya1oNuJVGk7ju5wr3LkQn2RaBeaLpx6?=
 =?us-ascii?Q?8UjTalxDKNqMwORUDYzx5q1N88E2DEmAsNQmbVsWba5jQJLOq5EFKcoRGhnf?=
 =?us-ascii?Q?lG0bnV4ckb82YBXm1st1mhW9UsNvtVfZYwB67Cko46ME5ICOenFtMzT+hldL?=
 =?us-ascii?Q?EYvMDzbrprbYYRkSK3JrKO1oxgUsON9KDDko8o58nMLbEl5Zf4S5tUlwBQ6k?=
 =?us-ascii?Q?qyBJZPWT5EFF8b5XRX06uXq3W8eikdljOwPRgbvC9/4Pfs9j9Usbovzadnxk?=
 =?us-ascii?Q?VlGJmGDkBw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53ef2e98-069e-4e56-4460-08de68a62246
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2026 13:13:08.3884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3uEcOYDG2VoaKlqbEJVKlvnyY/SdFuEf1LafflM1t49nje7Yaca3EatgWOB9i8/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9591
X-Stat-Signature: 9jyatk8nxy38bc3ha5fkku8hp85ob8j5
X-Rspamd-Queue-Id: 8DB7D16000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770729197-695260
X-HE-Meta: U2FsdGVkX19u8uPWE/Jo9uhyqtOGW+8r4/wrOP6R4OY/pux83l/7IxLJz/7KI7VHkYZxNbQso2h06K9CcmXt+aLJjGO0Z4joILwPoFLrwOr8kvOGo3WdF/oJ3K3bYMCp9XsU5ZIvGC/13xtmRjburYKUrMCh4+9g5NO+EkGLNK9qx8WXm1XA3tkXnCgcjwXXMxMrPtT6iGDefmQ12Cpm//X1EV+sJtYOQETpEwXJxjYjcqAQbbS77uDp/DTQxgT4CJOAhcPXqkFkBM8oQyuno783Dr+IjXq8YL2K36OMh3WBlZp8mBx9XOA5LRiCarQihom9XIN6ERvQYb97mnnm5bz7clzDgrPl0LeooWi2rEysUqoJt0DPIfrjwK760NNGcgQn64uewCBXza+7zCfyhyYcS2ClIiMMyG8kfixXXsCLYKjxY6FqeeVi+sgtb2rtVMLu9CbqANKv/py+XjEZm+hKY2TgMq8ZEZCpJghFFC/1ZuDpjLQkR6WSEE8ULj+fEYZgqwNCF92WmcGaZvAsXI72f0wNYSo81n/c++kBzKKzN65fY4IHFtIg7zb9Bj5uTS1UFPrY6IlaE0i9HD2K4lYR7gNTEgahICQ7wEnWVY5xRGnkctaBjnfYpVylavFZ/G6+tp++q69TGLvJsgddb2T/LaORl6K6I/9SXM5SjpcHzeQPTq4Z+KO2jNROQQKOpKf9NWyX4QCsmzr8wdN/ujFuxi/YDFTftBgpp88soU9ERzy1hBNM0d3Ryfip5enc2gxpFTHltCc3zWHgaGIn2GfPk9M4O9xDM0/R39gq13pXfrLzqqoQyORx9pdsXKkWzf86wpM6jbSOd8uWwop2P+oV6V0Bdpu13DWSYTlPGW4AGzHEOqyZYK8WGT8Thcc86ZhqAGWuz2XEP6Fdsx9VuXXMRRWoo2CqP8KWSmESMat4Yl/lVPSZfYO44QfS3ebLvKjpM1A6jLOCRgy3dUj
 38Cl7zja
 yVzMcjAGTcRzZbB3XukzrSP71S4V2Kkclsw8ozN/QRLFRhatnU96T4Mdp5z9qKvleyiTClWKohF+DN+j+0l1Zo4zEYbPT5wN/EIP9RWReZGSsEM3+Gc/q9pSWG9M1EY2dV9mjUqHgKil7zitc3ts1Krx09GnRh1MaPuZVmMkq82ybmehWZSKb388/czZfH6nKuLGpHITWNL+xO5LOw4uGCl15Le+3hTJM2kE8p+D48ULIhH/67b0CC4rKnYKCOIS1++KloUFwhkvMUSq8Thzcsmxi7p0PfYHw5eD9SUJctfw4jx42BTbM3YqmMi98Wku4s6OlhOaOaNjxiffcmksd9OUuDbpMxDCnqAJx29/YjBxPDMgmyrJv0USJ2CfjHg+p3xgNMNNwvdRUaEj7CNdl0uCl8xb4bIKckb9Su8GfKmtr1y+Lscg2pw8ppZqoYrwdq7NrVuMgbe8HupU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 02:10:45PM +0100, Pratyush Yadav wrote:
> Hi Jason,
> 
> On Mon, Jan 26 2026, Jason Gunthorpe wrote:
> 
> > On Sun, Jan 25, 2026 at 02:03:29PM +0200, Mike Rapoport wrote:
> >> > @@ -67,11 +72,13 @@ struct memfd_luo_folio_ser {
> >> >  struct memfd_luo_ser {
> >> >  	u64 pos;
> >> >  	u64 size;
> >> > +	u64 seals:8;
> >> 
> >> Kernel uABI defines seals as unsigned int, I think we can spare u32 for
> >> them and reserve a u32 flags for other memfd flags (MFD_CLOEXEC,
> >> MFD_HUGETLB etc).
> >
> > It is a bit worse than that, the "v2" version is only going to support
> > some set of seals (probably the set defined in v6.19) and if there are
> > new seals down the road then this needs a version bump.
> 
> If we are running say kernel X, then X + 1 will always support a
> superset of the seals, since the seals are UAPI. So it should be able to
> handle all the seals that are given to it by X. This only becomes a
> problem on rollbacks. Is this what you are worried about or am I missing
> something?

I think you need a check at some point only permitting seals that are
defined right now.

Eg some future v7.19 kernel has MEMFD_SEAL_XX it should not be allowed
through luo until the API is bumped to v3

Jason


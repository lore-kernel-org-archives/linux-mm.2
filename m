Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3B3D6CFD5
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AB56B03D8; Fri, 23 Jan 2026 01:24:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BFD6B03DA; Fri, 23 Jan 2026 01:24:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24226B03DB; Fri, 23 Jan 2026 01:24:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B18606B03D8
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:24:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64E281AF6E1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:24:01 +0000 (UTC)
X-FDA: 84362238282.10.E9DCB4F
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011052.outbound.protection.outlook.com [52.101.52.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id A454C1C0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:23:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aGSHLtTc;
	spf=pass (imf18.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.52.52 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svKuLk8T2SeFVvAWdUEoTSVnNraWK7+T3W5jbyZQoW8=;
	b=5yxg6u543yC9kAo63eYOceJAGIIOKX+2x1wwINifFVjSx/ZTXPUJSPMP81Tmv83y9XRHCq
	SDoXXkjHNBmam2u7kJeuVVbEfHOTQpbXaHrxftQDNN0iOxNHw9XzZ85goDhMN/eGyc7W3M
	ybgv36tMMHWCbfXXGjWW1AmlY9LhXaE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aGSHLtTc;
	spf=pass (imf18.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.52.52 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149438; a=rsa-sha256;
	cv=pass;
	b=cevF4floXnS0ZKJPOg749roVOidphACKYIQikv1Y1/K8bCR5PXu3fkFbHLF/t2Qvtun525
	lBI12GOBRna3U6AkOraZGboChEV9jy+axHYzjPV1by7wofSL/OMXIkyLKxdWJNj4BiH3g1
	+JbY3fF/d4G0pfSaubF1OBGlj9Pgj8Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kGiYnRTagp1v03iWNLs3XLgtP1iP8vfqf8zoV4jb4jyQ+lSi6sNUbZO0Uek4+2pjI6WIwoqnTl6aKVJ7ncphQOo6QeBIcSICOfyns/9ittcR8bStj08c/O6ksAcJ3fMlSzKgZ2xbbtQlYKRPG1bbI5KLSKINPSIJ+WsatUhXY4W6W88dX+teYQqZRkZc0ky1NHeD7smu1GOsVibRUkDCA3dmM1C94CMs8KY3Vk6L7YoKYnZAIOqv7M23Ger1WzoSSXqlvcJKnmk85COT6se3IoeZEqUQoFXsQls5po2frPFzyNygxCjKGaBr97xVDI1UcHMvR9nESNmaBwpq73KRzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=svKuLk8T2SeFVvAWdUEoTSVnNraWK7+T3W5jbyZQoW8=;
 b=Conf5XBCtymiZrOkeu9IVXQ2iBXVCR7Zp8zNDI2oVeWdqYyKUtc9RqMw3gOrQ+8/ZOH05F2ReXGhXN1NPMwSYkWQiljD7ohTg9j88v/H44UnOL5uuNRR+JTygDR36HRVnQGuKUIw2AWZpzli78cYa7NxPXg8EPxDXb1YzP+U11u3U9R6Y1cI9hYPBySDVqR9XYnhrBB86x65ltVkbImrpHJLbUVQEAr+C5w3Y/CGwAS5CAUtIdI2kSKhwfWZ2Bz2GMrY6wbTlgfpX6PP/tavH3wtf4nMYblkuSoLj+z5ENHrNbizZp+hME7ZeHNf1F1WTsPkTXKVcfriXe4vG4FRQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svKuLk8T2SeFVvAWdUEoTSVnNraWK7+T3W5jbyZQoW8=;
 b=aGSHLtTcM5Zsrp1k+6ObKbFdzNxc17WICueEgQU1LOww9LywX+WYqVP5DN8k+0Vu86w1CCQ9tWNvStk8UCTT75GJ87WK39bH/6UO3u8SHMJnGhBl9l2qCzd51zSYa0LrVFoZ2CDN8MvhubCXpyh/lNq8Pv7HDXC5zRW4lyiz6WfUhGDXDOGwaLT0cNxT7aARgTHUqYjjqMgBLtF5QY8Gduf69Q9tprHFIIx3R84li0UZQYAZ1uWJ94gI0migmcKZ/eLIBtN4COF+N+Cgnr/T3nNHixzqbFOZ+QrIHEjfgRVOK0MnVbkBNq1ZuCoO2DGnG3zJLgM6BWeKJNdiTq8Xjw==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.11; Fri, 23 Jan 2026 06:23:54 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 06:23:53 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH v3 05/13] mm/page_vma_mapped: Add flag to page_vma_mapped_walk::flags to track device private pages
Date: Fri, 23 Jan 2026 17:23:01 +1100
Message-Id: <20260123062309.23090-6-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123062309.23090-1-jniethe@nvidia.com>
References: <20260123062309.23090-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0209.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::34) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d7741f-1cd7-407b-5cbb-08de5a47faf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?P3vwI+Yx/RD6G3kTOhCR67RkV/UPAlI76DJBrlZahSrDvY5XeQP+1K0NTCne?=
 =?us-ascii?Q?nAcLOj0B29LMEsWZsSM7nbv/rUVIIF9cJ3wCvtPewDdWvJp6vnPUajtBUoUu?=
 =?us-ascii?Q?+s5h8xeR/rOy3lEh3djtJZhg00ZDljXSYJhHUmigScwQyI5ncOJMWf8E/2vq?=
 =?us-ascii?Q?D+rXkG4ofiqz/cVgI7TKAqC1DFplKQcD0YWtGyapUzlAH8zONAcEvRv8PPIE?=
 =?us-ascii?Q?1d/+eVlK7O/s0FGgAwZoq+Y0lJzfvXePX0Lx0/n1/8BagN+e3hU50gg1BBUk?=
 =?us-ascii?Q?vpCUCapxDGTLrSPHfQViX//qGfv9+VQOLeWuwlT0YB6MmL8uzW/A3KvNCRAs?=
 =?us-ascii?Q?5BlDQmimWKRSiQ9GzKFBKzO7T8o5jGBDMBADGEqcpRdumm3n0naoxkusll2z?=
 =?us-ascii?Q?O+Q1q9mEK18W3bHr2mgBGSFskxzVOOtd8ZUet6g62c9somOgW6aoO3tEYoy+?=
 =?us-ascii?Q?q+PrX4/JVbvVxdK995247tlrGJOcId+yyy+miS1s9BD5Ba2A3rD/jJ3wRo+b?=
 =?us-ascii?Q?RaUtrKYg5hsja5HF8TjF5bRbAg3it76ooSjeqaFaLAfFHf/7xpZYhP7GxnFR?=
 =?us-ascii?Q?a+aCh9k8F3D+129F27A6yIwzFmBuPj2EEcovWXo/h4HZhWUJZD6JsnTIXTRS?=
 =?us-ascii?Q?o6vtQTWs4em3evaaxVLHVqgwx5Obwnfl2MydcLEF0UyvhdfB2cGBceX8K6C5?=
 =?us-ascii?Q?EJ9hx8JBBxrYkujlgoDDiTRptukSfX085kR/itMxo7Ww9wy8cYiVqjOU0Dfb?=
 =?us-ascii?Q?DvMC39IR2FD9mUCMLIxZJp8UoQfU8ovFEYk0LgOjTTkQlSXc1vsnV3Dp94F2?=
 =?us-ascii?Q?DPlC1sGbQOgSPvEZw5Xbz5Yf18CvsgfnZ19iQnKahTwE+fcG2tAXh1If17XX?=
 =?us-ascii?Q?nkyKZ6IweGRmVu273gTt8uqmckAy+sefrui2kZ4C7jOi/Wz9ks7M5Y/ScSy6?=
 =?us-ascii?Q?t7KudBsA6Nd2RPRtbKBunJL9HQ4JdsZUHKZKE7n1oCIUdsFdoorayAXSSki3?=
 =?us-ascii?Q?QXzH1XgkgNT6DFIaSsW/UfcZra/3F6Bup/EFoOWR8ZiVAECsyjIPdsGO4qed?=
 =?us-ascii?Q?pMVQGnJF1cFadDaqHVi0ckI4qWtlhlcKuR1ZPkE3gT+FMY7vXxB50cVukSPJ?=
 =?us-ascii?Q?LnAfc+lGUC2McgJ9HS3S6QPEgNjZ+4ddmyxcR3PVtnZn471/tnpPy+IdEwyt?=
 =?us-ascii?Q?7x9tQUV+frCsGOB6wcbsyZATe3t95Nfn6gK7WO06Qk03gFYxVgjSFscFdcqi?=
 =?us-ascii?Q?iSOVXiZHsJu7xFmJH6oYPYbKwbBOs6qTZ1pIwXsV548J2Nm0ndQzw/ZDpnLG?=
 =?us-ascii?Q?GYboRyoIkZnxfIR2aUOvHofJEcrzwjwh8mySu6ivmtStMO1HwMIqSbcf+fzg?=
 =?us-ascii?Q?OSa2IkAcEL7qX6KkWWZTqhkl9YIc4E4NHPrIa9kfmqwEicMO7D064sSiK2QK?=
 =?us-ascii?Q?mQYOGN4hARgdsTQKn/DPbhEqdOQ6Qm13MJ1LPWVWiUG918IRDe/eRM6K1xFs?=
 =?us-ascii?Q?oZsuuZ6ctdVHAqGrmbqNZnJrw6P9Sz0eq9p6t6bEpaiVRuOPbq9iwvs0kviV?=
 =?us-ascii?Q?XEwAgnYGc7gxcTanyQU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fBr5X1GGTrvskiHYnwnI8gQt7D6TZ1xzS2OKskN7LMHoK+DTozTiKgoMU2Ls?=
 =?us-ascii?Q?JNmC38KZcsj64eCGH/WWrwXXRjDdlVIXece+DTc4Arkamt20RhmDjmYpE/n6?=
 =?us-ascii?Q?IhFoG/lG50lx19EVwfgXMD/txGbdK4WVNKPvhloQfRv5pFRbtdWk5riTnHky?=
 =?us-ascii?Q?2nnsxJ8X+RYJLJxBmKRyaIkLgzzGQCoDaCMsqaqWIzUVSB5/0fVosF+xy7zV?=
 =?us-ascii?Q?ie298vg4/SvbopH2u+EuViVln4sUp3VDTZksFTLruGqV06e/UOnubiQrc/BD?=
 =?us-ascii?Q?P6TisJBYXd6Skyq+uM+GBTIX7+382QGlmwEt2Gn+ee4iupqns8qFz6q5ueyJ?=
 =?us-ascii?Q?8F47Db9ZhvqYB7mesQCcTZSConVlwY55L7W7PUv28Fafas8b2+eqYmO7ogYt?=
 =?us-ascii?Q?Oxnc7CwEMr5l65e+fdV2z7PZn0VpHSz4R7vGAZO0l8ZN7IPJLkT1UdTBZLW2?=
 =?us-ascii?Q?gopLE3ZO/l/oaMk5bqevzMZI4x5ZAix6fD5nHrxmCFjPCq0O1qmG3+mArb9/?=
 =?us-ascii?Q?kvO92ru+Hfau5EuRy7lL+i2HIP/BwIVTPpYRlpDk0JnY/n0We0/bW8717FjB?=
 =?us-ascii?Q?b8PL0ZS5XBl5l8a7E4/8Dh5hMeCcm9qqiEAM7QuqVTmLAAJIjV5dtS78kmW6?=
 =?us-ascii?Q?p8PzIE+vTUJhRKRqDOSH6jqSR85wtmA3ANX2mvZfUBuifxzP7ayGJ0HnaruE?=
 =?us-ascii?Q?Zceu+cHXipilsdAHO2XK2KA5JHcAu94kH77JnLMffjQuKuWVWy2y9WJq9fHx?=
 =?us-ascii?Q?Mj5Mzt2mn1dvpFM4NDb+qrIYCChd5/bKtV3cA0qQMLZo2R0jY3xwyHD5MQr0?=
 =?us-ascii?Q?LnFdmlYgNwuFFhAGkXSzErx1ZCiugxYQfDApsXdTbLhzO1Z61qkwUfBJW79x?=
 =?us-ascii?Q?sek2IsLSKQGTEngCHTHz916/j1qt1pgXdv5VC4O3JUpGdiYHAsN3FnAVqd/1?=
 =?us-ascii?Q?pGWmC41DM42l+iHpcqQ/qhW9Crav1oNF2UBeXsY3OJWJyDJe5F6EOjn8Lsmi?=
 =?us-ascii?Q?7CS1HujIbIlwfg/SqPX/n1lWBdd47AoCfsbpq9gxJwd3mIsGRQnw74xWG01S?=
 =?us-ascii?Q?1MN2yC6sqrEWYb3cmAdiiUdxjwRWV4J/esXFDlfSuMMkSTi+Nj6Puf7ADQlS?=
 =?us-ascii?Q?UHYWTLtXSi8noMeUojq6Tf6Z/euzb4erm6ppxl0gKkU5vF6wNbfLi627fMcY?=
 =?us-ascii?Q?fX8P+BYn3GNriaZv7DGI906LBz2yKkiVMxw7HPetm06lRpvLr+2UpQjwU8Dr?=
 =?us-ascii?Q?8MJ1bo/Q8akvkRy/GboERvrdmDVXFRx4EucmbU+kuKs/+pyZcrWeIiEEC6dJ?=
 =?us-ascii?Q?Jf9Fm8F95fUh0nMgGqCrkmaS3gPTR4qLWRGRrnnLjuGc9pOxLUdENRSksdbZ?=
 =?us-ascii?Q?FZtvibW4S62dH1Lgd9cXpyvHBSDloWY7hCVBJ5K+zbl66ODHF9N/ailIXUAm?=
 =?us-ascii?Q?azons5Sdv7In/1+KKOOlwyvvZ5jDDnYtDfEuIlUPGqgO7Tx3oQXT6+Xc22uL?=
 =?us-ascii?Q?GWar7HAIe2YM4nBRK8oRM3Z1OIIYWKaboVd2w8ul41wnXur9ydMZFhCGEBdN?=
 =?us-ascii?Q?qBMUNFN950aXNCzoX9KJUE20OtQWL7fIz3nvI7QxQIstH8ea0hz8cSbHoioD?=
 =?us-ascii?Q?hI34itcmW6ALOvU4HhirdcZlB1PzqIhi/2Iwc9iBbjlFHj449dVIjseEzzC7?=
 =?us-ascii?Q?zNqaVxJ+JPAX+QbuF6FuMLrbHF15LutpeLBRAjK28yoi0yL14iUYrXhTJEfg?=
 =?us-ascii?Q?3PWMsYBCKA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d7741f-1cd7-407b-5cbb-08de5a47faf6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 06:23:53.7970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lKEvxNgki3Z53M4D31+dnhy9IbnZybSQTEfUIPphJi7DmpTeodSsiGtbQM+GFVITJLDhuJK3FxMuU5+w2VvuDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020
X-Stat-Signature: nyhcdcyes89wy7dehmre9wk9fyjcepei
X-Rspamd-Queue-Id: A454C1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769149438-215879
X-HE-Meta: U2FsdGVkX1/iQ7vcHPmrvSMsNnRceRAtGNAAz6Ky4WZZYd4Z7oEzMwqL7B1qBlMEdkNi9/9Z5bB1LpA2/qoHn89tvZnuRCnvqFGLz63Ueam2xg0mVFHHlT2bXvZR3H3hcyLg4T7rnuZ0H4cdsfxRFfamkn4qo2uCmlVkykI6HK/UnELwd0PRVRJ9zRuZpjjoeQIpWPtHgSEUTHfQgykSP2mWw9QQL3PSRxdD5ZeKNs8FU+KwQLxpMdFlAiLO/YxNZjCUUpUyKR9pt6snc2iC9TetuVZVjv0mtpagthr2+SNoHDGjS7hf9r3gEBmoCKk4x6zljWiK6B8Jq7rtR4ch0M5DluroGkDZTqYWwvBQ5piBmhJcausSyuAMW6eKK/paomcSTikDSpfOVpeUlmAiVjOX/nNQHb9VC6cNDCrZaNEmraxUwDkqGU7GU3e7XxcjS9iN37v0uF2swc0lxG9fxHlt4uql1dXylEFBtMzHWhL1ZsiijGLg6O79ou+XShBIVUX5OxYIo7tQZO/9N1xGNr94FOc+XHkCzXjMyUqtDp0GfMo8oh/87BUe/mTNpGUslDNb6UXgrH8mf0ayHPmbaYmfKzyi9eYPzJoXZLS2mhkaxxdbABsqBxQ6Ax+i8etk46rLOlRheevXuG04+W0K6JG+Nbw84uiXH5HkByH3wh7Z3s3Aj+Nw3C/O9RdWvQXxfAfDcvK/oOm9mpXAwUEQ8AlcDpYXJ57cCt7wTLmM9L8Yij8NVJtVAnLIqApg55NxyNj86/dLRIFxruIK1G92i6R6GAkBP/AhBm3tZfHdQYRLs0gd6Ju6EX/HcWHV4rrli47/SsWE2lAgCmTAGeBSSbZmXQpEeSZnwhR8//R+gMQnSvfm9Fqy7NqGAlaFhDufNC208EpTte0bh5hhTG0FcaJE8itdj5ZCKwwaJvt2OwiYUBsmRzEw5ChrY0kKb3o6xUHNWSQyDfRja6Kmj/t
 ZMxh2y7G
 /ZbhHIwi4yPzvb1Q1D/FgVTlOPNbeB3CKXMYWMZKWRr4LobPzezhfuTA/P08zbn+348vC77d6DOMkjhSPtZxG2zSJkqTVT/flH/qtTcNEtux/UuzM04TBoCTFpZv2G2jxIZS5S1bHVk2XwT0Vm2+DspHNkjkJZnvRrj8S0H+yMz7CFyMI0s6EgQPcjZT7LLJxA1dIZqkgFCRUs0AjJxThIsdzj2x0zme32VKyIbVR1Cc9qgCX//inlnldIO8fj30nWbqf/E32altCx33raf+vM3NWw8yEN32ZymdVB+HdhAaR8cIGOKQbHT/BkVzjcfUX7V7TAgkL2Wj7pyH3ydDF+ielThAoXSV6dmbxChsNY2UQLfscx3PBE7u2Pom1T+V/GDvoXYCgrjfVdC2dk6i2WsJM+enoLqG57q9MzajZ8s6bIOGxzkvvBeQY0tRyWiShzhQQvcTWr20ASZczEd62xWYhu05HUlXlZ9vtj4Bwe6yQs+Vb7MlDTahRPeLHXZd27Tz+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal PFN and must be handled separately.

Prepare for this by adding a PVMW_DEVICE_PRIVATE flag to
page_vma_mapped_walk::flags. This indicates that
page_vma_mapped_walk::pfn contains a device private offset rather than a
normal pfn.

Once the device private pages are removed from the physical address
space this flag will be used to ensure a device private offset is
returned.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
v1:
  - Update for HMM huge page support
v2:
  - Move adding device_private param to check_pmd() until final patch
v3:
  - Track device private offset in pvmw::flags instead of pvmw::pfn
---
 include/linux/rmap.h | 24 ++++++++++++++++++++++--
 mm/page_vma_mapped.c |  4 ++--
 mm/rmap.c            |  4 ++--
 mm/vmscan.c          |  2 +-
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d..1b03297f13dc 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -921,6 +921,8 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 #define PVMW_SYNC		(1 << 0)
 /* Look for migration entries rather than present PTEs */
 #define PVMW_MIGRATION		(1 << 1)
+/* pvmw::pfn is a device private offset */
+#define PVMW_DEVICE_PRIVATE	(1 << 2)
 
 /* Result flags */
 
@@ -939,14 +941,32 @@ struct page_vma_mapped_walk {
 	unsigned int flags;
 };
 
+static inline unsigned long page_vma_walk_flags(const struct folio *folio,
+						unsigned long flags)
+{
+	if (folio_is_device_private(folio))
+		return flags | PVMW_DEVICE_PRIVATE;
+	return flags;
+}
+
+static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
+{
+	return folio_pfn(folio);
+}
+
+static inline struct folio *page_vma_walk_pfn_to_folio(struct page_vma_mapped_walk *pvmw)
+{
+	return pfn_folio(pvmw->pfn);
+}
+
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
 	struct page_vma_mapped_walk name = {				\
-		.pfn = folio_pfn(_folio),				\
+		.pfn = folio_page_vma_walk_pfn(_folio),			\
 		.nr_pages = folio_nr_pages(_folio),			\
 		.pgoff = folio_pgoff(_folio),				\
 		.vma = _vma,						\
 		.address = _address,					\
-		.flags = _flags,					\
+		.flags = page_vma_walk_flags(_folio, _flags),		\
 	}
 
 static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index b38a1d00c971..039a2d71e92f 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -350,10 +350,10 @@ unsigned long page_mapped_in_vma(const struct page *page,
 {
 	const struct folio *folio = page_folio(page);
 	struct page_vma_mapped_walk pvmw = {
-		.pfn = page_to_pfn(page),
+		.pfn = folio_page_vma_walk_pfn(folio),
 		.nr_pages = 1,
 		.vma = vma,
-		.flags = PVMW_SYNC,
+		.flags = page_vma_walk_flags(folio, PVMW_SYNC),
 	};
 
 	pvmw.address = vma_address(vma, page_pgoff(folio, page), 1);
diff --git a/mm/rmap.c b/mm/rmap.c
index f955f02d570e..7f12934725d1 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1871,7 +1871,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
-		pvmw.flags = PVMW_SYNC;
+		pvmw.flags = page_vma_walk_flags(folio, PVMW_SYNC);
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
@@ -2299,7 +2299,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
-		pvmw.flags = PVMW_SYNC;
+		pvmw.flags = page_vma_walk_flags(folio, PVMW_SYNC);
 
 	/*
 	 * For THP, we have to assume the worse case ie pmd for invalidation.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..5d81939bf12a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4203,7 +4203,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
-	struct folio *folio = pfn_folio(pvmw->pfn);
+	struct folio *folio = page_vma_walk_pfn_to_folio(pvmw);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-- 
2.34.1



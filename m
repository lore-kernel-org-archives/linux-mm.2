Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7788ACA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 23:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC5F98E0006; Wed,  3 Sep 2025 19:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9E098E0001; Wed,  3 Sep 2025 19:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966068E0006; Wed,  3 Sep 2025 19:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 861418E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:00:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21F5C1A08F0
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:00:12 +0000 (UTC)
X-FDA: 83849459064.17.ADC18B2
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2067.outbound.protection.outlook.com [40.107.100.67])
	by imf15.hostedemail.com (Postfix) with ESMTP id 63E1EA0004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:00:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l7N1takA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of apopple@nvidia.com designates 40.107.100.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756940409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hU6+Ady6aLl2rVK7oQBFdMGCrF29m+xSa6Z9u8FWszQ=;
	b=e/Pf6zaVpPTW/T3kkx5bZWN+ygPaXmiAhRjTyeBQgI4z3Y2Q7G3DgSxK7hMif2GUiFuZr9
	yNZlyeKiTFxx+LsqXjCcJT0c9CogfKGPL+Isr6cwsOT1JYGWTD4BC9S7y2vFjiY/nQh2P5
	S78xthATIXhoOIXF7sCg8UDtZ6zSCyo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=l7N1takA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of apopple@nvidia.com designates 40.107.100.67 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756940409; a=rsa-sha256;
	cv=pass;
	b=FNUdb9pcFWH/wYI6V2HJDqOlZZzn1SWnUmt+Bgy20LVwjnN/LQRrFGN7o7VIU1NKfO/rSn
	mFAAc+9zX7OCCedbVbE7aEa4RZXI58nIZ4btXDTuwNPdwJL3fUPeMrDlaBgQE392zNOYtU
	hZrL7YK+l4kJS6U9JPUaLwy+lrKJyKU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RDsZnJPWg4oPEbqSXQZv2aDZhlmyvUVmOaVRwWWr8vhzTx0ri9J4phQ86i7kHFstEEcNK7rrtWsSzMJ1/UwA18Eat7Xo97B985D7pOHl9eZDYGYnOcbpnZqpSaj6XJSaVpGcgE24Gh7HrW2PtwKRv/uj/2fCam2y2MSXo43iWvHpDuGpHKFB0gYWJCnoj5r7qTp32cGsdowQPrcYQZle73GjU2NSauizyyLv/EmY9AVGJHZJo9uI2bql/nEIo4e6tDTYz36x3r98uqHL5K8JncLMqnyLHS6EQ5HRZtvJjcb761hArrJZYlzj09iqmsg2O/+8BstRZklu4rY9yV+PGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hU6+Ady6aLl2rVK7oQBFdMGCrF29m+xSa6Z9u8FWszQ=;
 b=NGRYGuamfNfmxKviA7bBQgmgTC6yvmsMGTG/XnwtbL0cGAwSjxAJbco2bH1aFri2tPMzxiiAXQfv4ppoZr0eYEb8jHd7zKYuMW9ic7nVH6LRwM8Yvj4kD9RVH3pLdDpOcCIjfdSK9FnJyc7TKeEDAbak/ltsWeyhpv2PlcW9S843QcRb+eP67OEzTqjRBJ7WJrNWS/YRNMKZKFiWGmSr7N48s1ZbgpyHOBl7f3djtAG7mjeQ7V31g0CN2lfwbohhi7EOEfHL4/Q4CuXmIijdpKZB6Ox77LMJDWv33O5gsDQhNirfpoLidnxOfjRIEEaTcYehZrofokQmzG0EsvWGJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hU6+Ady6aLl2rVK7oQBFdMGCrF29m+xSa6Z9u8FWszQ=;
 b=l7N1takAL/oddlxtXo9NYczyiasYky4eCR/Qq6RX+B3fb2yuRHRw88FZF8izJfrsAm9JvpbwCLx19dNTUI5vZIbuDv+FeObQ6urZDDBU8bzoRNDZQcGvWFn+ErUvH6ZW6mgRbvy9qk8RZba3o5OApdE6LIPnnLUlo8wd6rr0Oa9mYPmxez4zzHX1Y7kGG3AC9oDf93xnuO+YVwjb/qUPO5PlxybY47PyTixWVq5Jp/4j6rErZ0eioPsqsh5ITI+c34+juhjx6MjcA67ATMD9Xx/ZADhPrTHd810S/XH5v7LOVHPe2Ub0jRIje5sYUXv3N7r46Xr9YyeAAH9ICbmUbw==
Received: from DS1SPRMB0005.namprd12.prod.outlook.com (2603:10b6:8:1e3::12) by
 CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.17; Wed, 3 Sep 2025 22:59:55 +0000
Received: from DS1SPRMB0005.namprd12.prod.outlook.com
 ([fe80::7629:20ac:4306:5f4f]) by DS1SPRMB0005.namprd12.prod.outlook.com
 ([fe80::7629:20ac:4306:5f4f%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 22:59:55 +0000
From: Alistair Popple <apopple@nvidia.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: david@redhat.com,
	osalvador@suse.de,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com,
	Alistair Popple <apopple@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 2/2] mm/memremap: Remove unused get_dev_pagemap() parameter
Date: Thu,  4 Sep 2025 08:59:26 +1000
Message-ID: <20250903225926.34702-2-apopple@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250903225926.34702-1-apopple@nvidia.com>
References: <20250903225926.34702-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MEWPR01CA0174.ausprd01.prod.outlook.com
 (2603:10c6:220:1f2::15) To DS1SPRMB0005.namprd12.prod.outlook.com
 (2603:10b6:8:1e3::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1SPRMB0005:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: d59999d0-cff2-4d4f-e5b5-08ddeb3d9915
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F1CxV7IJG6T8GbYI8SClX3RGX74xV/U+Rj7GHu6P5iyCOLOUCN954NrkLUFr?=
 =?us-ascii?Q?7ubaxo2rShE2o/iRu8m+cqVgydmg/+zjUqygntLZyzKF0Mb5NLMz1HpFd5n3?=
 =?us-ascii?Q?gEjLyTLdSxDSQWUNqdCGIg8mwyyP+HuZaZgB3XpAZV6gs6mEUzMvWcLz9y2s?=
 =?us-ascii?Q?T8PHFFB+iXrvu8mqsY1Jz6/wSMjknxTmQ72cX8PvxU3eVGeVyvQ7WPo+g2iD?=
 =?us-ascii?Q?4DLORenWZoEnBc4nGHkxYGDi0hsqHtIPksFHsB9dfWrNF2uVEPzAAVxOePYw?=
 =?us-ascii?Q?2D6Kom13cgwIDfUZLrqpBh6PDeFN1+CVaHSSaoZIh4Uc/rEijtnBV2T5mD3D?=
 =?us-ascii?Q?OG10tazfrNC5JirTRorrIul7v1xQzp1FYlGHyBYemNakZmZqk/FTRQt/kq4v?=
 =?us-ascii?Q?kr5wfuEGCwyxBcg6tWHy3km8E063iJT92bc2LsLTDJTgncfSXneB/CBJvAmY?=
 =?us-ascii?Q?3xsFZ7litVRlXLkbED0qmDmxxwAccj4JVtpYjpDu32L9ZGUeZ6axcqicnX9G?=
 =?us-ascii?Q?l4sFVySZWoD9LBEn6WTCSlmIHOmZuN3JReJYZk9ylbJs0tzQu109GyEmgeMq?=
 =?us-ascii?Q?LJ/Em+1T8E86XuApviSDPOL1ctxqJSNGw0HHCQxBPSUcN2HGiUJ5WJ7OiEFi?=
 =?us-ascii?Q?x5HCO4XNgt6w67vjS9BgOqoxaRiNMIFrhcOQUBG5R/FqZPG49++ifkZUc1iQ?=
 =?us-ascii?Q?4fVmS2afqtqN5qKl3cunbBGkwabOHZZg/iluI8q93Q3eHHviIPfS9D5eKN0/?=
 =?us-ascii?Q?cn4+QFE1ceO5sCxMk4YSOTljMPf2pPG6qZedEf1F1zItW9aIBpjM8zN0830V?=
 =?us-ascii?Q?OJ5Oo3HWFhUi8qLFyWzSOC8RrZ7eOvctUvnKQ64rCNLflc8m0R/YVHimKa21?=
 =?us-ascii?Q?0/lwiXdRKswTdQTVSkeCOvsDDyiOXVmXeJNcS2j5CkZ6uEEiCo9UgEIdJ5ie?=
 =?us-ascii?Q?kVK3qMGhihQONr0d1MY6K8+DKp8QvYoeQ0kqOlkClOLGnjoxZhnPitiuDjXY?=
 =?us-ascii?Q?A3c0WkL8m/8o9k/f0TSbyN7ggfgnI44R2HinQvRcrj1y9TD4+RlBrgkV3SXY?=
 =?us-ascii?Q?srRIvUWHd76dJwv/9msafW3s3rX+apLhTXynYUVUCwzvt+L3D6gAs1f+FVgM?=
 =?us-ascii?Q?syt70zykiCZ2qoBKZD5pVrIrkl//AHSKda5M4I3ZkZ0/gPECJzVosoT7zRlr?=
 =?us-ascii?Q?nRKeWH36+jb9pzXDEteCaSTsdIrjAb9C0Mez689YpZCiarfaQvuM7rJ3Iny+?=
 =?us-ascii?Q?mMUR5lrvj1Y8E1ccavdjCUQitGHtXCcp5y019fRRjb3mgLgZfplpGzPFgAm+?=
 =?us-ascii?Q?vnFMPxO4fFRIjPaXDBaakRWp3dzUJUd9vYkpe8tQOWfkYdiWt1f34Hs+l3k9?=
 =?us-ascii?Q?b94r+JmeS9KhQBnJKOW80LE6sbKdJpzQwr5oxF+4h2t5eIRGQJqnP2VDFNv3?=
 =?us-ascii?Q?iSqEP0kChzU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS1SPRMB0005.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ewSBhqrLjHR8iOLGVBSvowjlNEsjGOy5Vrqr/03ahibHYru1KeEQJu8rbeso?=
 =?us-ascii?Q?nBN0T88Qek2tU3uP2eo2MLXYI5ns8dTQwcPtNNkkGPmqp/cBExcx9HQ/p9K3?=
 =?us-ascii?Q?XhXFqz31QEZs83WSMUinh4sEEjWMA7xza+m39CVVvLk9Daq4LCxbqoQ/3VI1?=
 =?us-ascii?Q?bZawrUEusg8PZj9pK+d0C83aNZDt0e7RVZaRC0bLn5P0/dqkPZQTVgDUwQJU?=
 =?us-ascii?Q?7S5GosAgtJqoKBt3gvM+6NRYibJKCQF3zU8nDlKcv4IgyGuBmVf/6eSbAUdy?=
 =?us-ascii?Q?75TIGA5unzhFc5FllEaz1ifSonA29GdBS/J3LOykv3vymfK2sA5Rpoik2sD3?=
 =?us-ascii?Q?jmTedCyINLyCJY/jtZi0HJp94HmdS//CbGrl5hzrho5/tUfxXXcWIy6CtlgA?=
 =?us-ascii?Q?nb5CuyuGIr4u6IoKQKSAM2rpy0OZKIjQlhUN8K0a2uZeMhu0yfn65h1CgXTS?=
 =?us-ascii?Q?17glvwq4dCCseGkqT//+jqfDpF5+SyKLmOCVTMy2hPa5AqfaZmLAM9Q57AzY?=
 =?us-ascii?Q?PMG88iDhMMmDz/bNkeG+oqUditb/KQLuLGOnwcEIo9F7LIhixPdvkgcIo4qi?=
 =?us-ascii?Q?mFiEvYLRYGaDoiap7A3I3bF5TkXcYlDEJKTZpJu0Xfx1DpdHHxernDtTzA0M?=
 =?us-ascii?Q?8nc/cSbujcvnSCnQ7rFIqtuaHPaGb7zh6CcceFZptp4vawMzeiSwVNe3qRjr?=
 =?us-ascii?Q?eRb6we5FIE4oPTzd6HCitufU3L1tuhbqie7Tb4TQv+uM/iRNxjJJCKv8c1UG?=
 =?us-ascii?Q?Nx2cxlpm6JdI9LaZH5kDtFxDsFGq9iunPKlwrhn2S2Cdmq5MG/1+95eAVTfM?=
 =?us-ascii?Q?Opxy22D5DgyS5HddoKLSsaK4s5FFCsSTlSAx/pMIL8/p1UvLaL19OFQemz92?=
 =?us-ascii?Q?0gP8tZ7jNEoSRP5R2s9CFfzSUrMVNUKGKCUUf85uKsbrEOSHuO/iwQHokxxF?=
 =?us-ascii?Q?PUZmY8bTLLBvbuVJ96zBrXmTCWMhkaXawr7z+4eus2EXROrOygkds+494jGg?=
 =?us-ascii?Q?r9GzBxoBYXmNEU8YyVTGa5LyGxud9DDsKZHR1iXNbUMPea46sDMxog5QfCbj?=
 =?us-ascii?Q?koxEU+3OS1KChprAeomf7RAHqvw3/JUPKt6QO3DinDyvzupXVUEZtvDRR3yc?=
 =?us-ascii?Q?bFb8jeFPMGrlACAy5yD2Or/xDUC+KxLpfSemVSW9RqUvW3muQSvvYLGwufDj?=
 =?us-ascii?Q?NsEnzmvub63Ilhg7yPBWUZLvKZwJfPmOmRuSsrhqEm3mauSjV/2fqzjGFGqg?=
 =?us-ascii?Q?L1+2DZVqzHsm/sfqUFXGdjnUNhUe/ulcUut01akMFJwTYcfj+HIWOtZa1b0r?=
 =?us-ascii?Q?cVmgQxWfnlGQt52w1A3pMLnJJGbJEX7EHVHr0TugAFbB4u6bh/8x4FwepQ+w?=
 =?us-ascii?Q?ihzmwKBLeP01y5oFNO0rW7rsXLvKiHEVhAJLzTWDsEX7icHL6E5Y2v0ZPxkD?=
 =?us-ascii?Q?xFiWFgLu98m5Z0ntEgiQgYr78TnZfMTgOBAZkrHoDvHG0zDLcLtIC5IzqRGg?=
 =?us-ascii?Q?s4seXUpSneNoa1qDg/JsLPjyGZQp3Fzb/sJ49fMqFrY4XIyChAL1i8tP17Qa?=
 =?us-ascii?Q?DWgdASV/WcDeEGgsHSfTH1lTKb/TXR8QyR9Mt1BK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59999d0-cff2-4d4f-e5b5-08ddeb3d9915
X-MS-Exchange-CrossTenant-AuthSource: DS1SPRMB0005.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 22:59:55.3740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AIx7aWbs6kmeSiQER17Uy+yDagyhJuqf6LAPCn6/7H31OOLKLCOCblAMPtT46CtiHJkWhlP/7pqVPWHf1oj6XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 63E1EA0004
X-Stat-Signature: i8nfe1cwkseijy4a5nnb86kkems8q1dy
X-Rspam-User: 
X-HE-Tag: 1756940409-925280
X-HE-Meta: U2FsdGVkX1/9KGK0Y1tOk13pRT1+zTilNJRMhGs5jO7h4A7Zfl6CVv2iG3gKBxyZAqCRFPbn5+x2iumq0JIkFzeHIMub18k+OgcdD5psXyG2wMiBE7vuTayAypkE0Z8ohza/hBUip6PKABOS4SYSeI60in26a74VkhwoEbw2DAmeVvFhYGNib/J1qE9uaoIzpwu/FcK1nZ9lPj1w68Xmf1BBBMLsCAf9xJ0foPVxb/1lRtr9E9E1p3+RYfV22W/2XR23dRhdJcivDV8FlyYZ44wbRZZGP+8hXrt3ebDg30z/0gGfl4ZMcGB+kuNbDbRkMHTQ8ebwTqbuoGjVLJjWCNzUC53Zi4GS65RRgSubFAg262l3Pl0yIA/t/y2nhyRbgn5D4RR6WPUOKfDynXDiDXafRnnAcJLIEizmDGRD0550HaOJXu4xmVmt2KVm4TPY2yHDCsccGt9vzTfknK9wD+H9tVqMrf/nuZEN1n/z4eDKs0tYOVK3SiRdB8uuuXk4VXG9sQBF/Aqw5XVrZTponmGuj0tvQ/Wmx5fozTm6v6YycNojF8nZCYHvKFP8yujStsCPCnmc8T3dDqwx5+LGsSHOy6G9G+k8uR0xxh7w8pCyxA+rz6IkC4SyXpoInuVU/LsCn5hAl6b4VVgY3Lmb+gXNcIBOPY78Th3vg4UNubY7XCM8dLnrtTpX+IQpeqdhPYMzYNJxBra7RD0UswT51LDgUdmYbNhviPuUouYlTL6zHakJNmchP4M4p0EcWTdpevoZPj5hO1g5ehv9cAEMnp8JqIC2g1K06Z5UaHIk7r+/TegH8cZAnC0RSB1BHUrPn4VbeIZFciIkUgCHbA/pcQCBlncvHrsbnqwhJBPGSBdrODZ8bSIHw3F6OEuc8u/v2lPxuj3+4EPQSbGVX297wFzeetNV8RE7yxSqoIvodzyCK0AN1NOWFZNvYPUHDkP5t1ZtqC1DT9JsOPJDQ4K
 gYQSA2II
 l8tr16uvU7UALTN9o8NtwRaVNnbjNqTBfMrUbMuKmFEAFYvFKZXQK8r3rs67mTobPLSrVPtqxxqrGVHvTjF49XZ+cHozPOOZ52+vVirxeGYFMCcv0qFGtMgEZ72gOrcTsOleikUBH7OPIcctjx5KL6Q913iO74Iw95/iqrXXqPLZ3S9ypAcAbUz9QuX0qb53pqLflY3FgK3ROWmABZ3UqDG/7QUTPMetrxJA9mSX/iKTo4FPPFaqG/Nsw0JSmVNjIGfOwCUI4wQo9//kKKUmP1qLbyHsjTT64XNMSx20k4B4M5PEDbjrBnPo1aJp5J55vh1JjNAHPqnPSUNQUGre+TbwhpxT4ms66kBjYEv8r8qrzEyx1qj/s47wsQIvE5MGoh+lfJChGUuR/H2aAVpIIezRZsZkR2CkDSduc/36E2qJSP7Kx1ujPXcLlcSYts7VmzGYRsjpkAEPSLwwOKIJMaR/QzvVGR6AgbU3Y/iMRNzZsnHTfMx+DODQx9Q54tX9j0dSi1nBpcd5jQaXSwOZLgmGNNKooIpdwwjZoGUk6E/46Oyghgeqn+vkWUHtSS2WhQnF+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GUP no longer uses get_dev_pagemap(). As it was the only user of the
get_dev_pagemap() pgmap caching feature it can be removed.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/memremap.h |  6 ++----
 mm/memory-failure.c      |  2 +-
 mm/memory_hotplug.c      |  2 +-
 mm/memremap.c            | 22 ++++------------------
 4 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 4aa151914eab..5cfc2ae6c98b 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -204,8 +204,7 @@ void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
 void devm_memunmap_pages(struct device *dev, struct dev_pagemap *pgmap);
-struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap);
+struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
 bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
@@ -227,8 +226,7 @@ static inline void devm_memunmap_pages(struct device *dev,
 {
 }
 
-static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap)
+static inline struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
 {
 	return NULL;
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fc30ca4804bf..21298f861a5a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2266,7 +2266,7 @@ int memory_failure(unsigned long pfn, int flags)
 			goto unlock_mutex;
 
 		if (pfn_valid(pfn)) {
-			pgmap = get_dev_pagemap(pfn, NULL);
+			pgmap = get_dev_pagemap(pfn);
 			put_ref_page(pfn, flags);
 			if (pgmap) {
 				res = memory_failure_dev_pagemap(pfn, flags,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 1f15af712bc3..14e98c89f5b4 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -375,7 +375,7 @@ struct page *pfn_to_online_page(unsigned long pfn)
 	 * the section may be 'offline' but 'valid'. Only
 	 * get_dev_pagemap() can determine sub-section online status.
 	 */
-	pgmap = get_dev_pagemap(pfn, NULL);
+	pgmap = get_dev_pagemap(pfn);
 	put_dev_pagemap(pgmap);
 
 	/* The presence of a pgmap indicates ZONE_DEVICE offline pfn */
diff --git a/mm/memremap.c b/mm/memremap.c
index b0ce0d8254bd..3b4717cf3a6b 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -153,14 +153,14 @@ static int pagemap_range(struct dev_pagemap *pgmap, struct mhp_params *params,
 				"altmap not supported for multiple ranges\n"))
 		return -EINVAL;
 
-	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->start), NULL);
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->start));
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
 		return -ENOMEM;
 	}
 
-	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->end), NULL);
+	conflict_pgmap = get_dev_pagemap(PHYS_PFN(range->end));
 	if (conflict_pgmap) {
 		WARN(1, "Conflicting mapping in same section\n");
 		put_dev_pagemap(conflict_pgmap);
@@ -394,26 +394,12 @@ EXPORT_SYMBOL_GPL(devm_memunmap_pages);
 /**
  * get_dev_pagemap() - take a new live reference on the dev_pagemap for @pfn
  * @pfn: page frame number to lookup page_map
- * @pgmap: optional known pgmap that already has a reference
- *
- * If @pgmap is non-NULL and covers @pfn it will be returned as-is.  If @pgmap
- * is non-NULL but does not cover @pfn the reference to it will be released.
  */
-struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
-		struct dev_pagemap *pgmap)
+struct dev_pagemap *get_dev_pagemap(unsigned long pfn)
 {
+	struct dev_pagemap *pgmap;
 	resource_size_t phys = PFN_PHYS(pfn);
 
-	/*
-	 * In the cached case we're already holding a live reference.
-	 */
-	if (pgmap) {
-		if (phys >= pgmap->range.start && phys <= pgmap->range.end)
-			return pgmap;
-		put_dev_pagemap(pgmap);
-	}
-
-	/* fall back to slow path lookup */
 	rcu_read_lock();
 	pgmap = xa_load(&pgmap_array, PHYS_PFN(phys));
 	if (pgmap && !percpu_ref_tryget_live_rcu(&pgmap->ref))
-- 
2.50.1



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C2C7D6CFDF
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF1B86B03CC; Fri, 23 Jan 2026 01:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC386B03CE; Fri, 23 Jan 2026 01:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1776B03CF; Fri, 23 Jan 2026 01:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7F6B6B03CC
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:23:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57E4F1AF6C9
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:23:27 +0000 (UTC)
X-FDA: 84362236854.17.0A88877
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013007.outbound.protection.outlook.com [40.107.201.7])
	by imf07.hostedemail.com (Postfix) with ESMTP id 99D5640004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:23:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dq9kIKi+;
	spf=pass (imf07.hostedemail.com: domain of jniethe@nvidia.com designates 40.107.201.7 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UgXpgu9Aw73r9+XTKFX5JlMMU11yDwiFIoU+Dujw3R4=;
	b=eDXSISKVY1O68agsl0vDf08yOQKfjl4o5AQkWSm0hX4vo9YnCTFpgDDM4OjPUnPWHUnP2G
	FyHwYvCLqgNW7c0LxaHb+tqBWKOD06GmFp3iV1rTMx9VhuScJ1z1s1NwMNu5F4qZDxWLqc
	OnbloCn4GbS2T7Q1pYu2GApF55Gesbc=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dq9kIKi+;
	spf=pass (imf07.hostedemail.com: domain of jniethe@nvidia.com designates 40.107.201.7 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149404; a=rsa-sha256;
	cv=pass;
	b=eYW69ivTbSuwaQMoyt8XW+5DaNMWRgdkdrXR7dcagCqlG0eAtuyBKF24VDMLxWj49RuOLO
	i507Baf3kqs2UelZr4U/LEh/qBhRWdcRs6LPdgm3ZvLEuIIhGGc6cKRUXFF6exmKcIQJNf
	m8A6h0fkzwYmf5Nlw0FWOhCrLwvz6P4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uQnsMyB1PjH3ZKhJGRvKu9OJlWqha5QTYd2J3Tdpa57E34khFtMTrGjLfPVdSGsqYPBJg31MEt/XHw6cmBNW5sVyMKZ7BqG+NW3wdarDoRIAizdAs1/cmHlstkKBf8AQ7stT1VsOBo17vZSxLn4zDQ5IgDnqMDaYGooOZ9sCQr9/pEWFKoom5xC/8KnqL1+Q04vkH1wuXFEgUarTAZE0QdyHAkbS8uUgyIPvVtipMe9yWJQEaauCl47efTCZWFE7XqvwNjkrfy5TlhdXtdMRviqiroi+dkByOhISsB6G+4TwNqQwv7w/8arYd529tJ2TTbynWYXO92+0Z3hd5COaLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgXpgu9Aw73r9+XTKFX5JlMMU11yDwiFIoU+Dujw3R4=;
 b=boK3YRGZlsh7zrEM1TbE7pddgMuJJTlIXehqRPE3wS1G55Jqf0wmC1JhLbf65XVAbM6md3aSSx+qH9pcFzh1Y7taHknVV5xhSe/jhXcVujJgn6OR5tGWCNCI9ad9dN40h97kJ2ZwmwYg6OjIWyX/HH68kDeYObPEV3V/s5LRhVQB+tDDlu7o96mp8pHNQl6c4POc89cqQuEf3a91He9T4p0zgIbtNFQAF3dtzeIPht96PRD04JsRLXtWCXlTVS4OlG9hhG61EjfcfIzcrV5mtFhz9/q4hRFU1ftN94VkywkmAkm66AzUfzZwRiJCCRQM+rttYg+2PDBkiEs7pItqLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgXpgu9Aw73r9+XTKFX5JlMMU11yDwiFIoU+Dujw3R4=;
 b=Dq9kIKi+KdpmGk21X1iSMWsK4kJaApWKHDbhioK9wf/7fA0aUAzJ8CnOaoZ4dbx3z7liIsAQ3abPOTi6JBzbkIrb6kCvA5deFuRb2i4UG+xiW+ZgDcMHkseIGNsOp61R/74YNTD/v4fkE2JwUhXpRY7up0BGwZ8fdAWGL0sEDYSonEX5Hn+BfzIYj7EPikjrHhJWofTKQ0kig9KNFtm1mtYCQcR4JvdrLPJBaazcopRIELES/tn7jNlCSmaCsCAAca9CpB9iRL+nFE6FCN1n81a/5XVSS7/WMSQjS8fER4enwG1JozKB6Gzel9uwWujwBY4Sg8lEDxwSB11/PLHenA==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.11; Fri, 23 Jan 2026 06:23:19 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 06:23:19 +0000
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
Subject: [PATCH v3 00/13] Remove device private pages from physical address space
Date: Fri, 23 Jan 2026 17:22:56 +1100
Message-Id: <20260123062309.23090-1-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:a03:332::10) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: a0240c47-8c13-4578-1cee-08de5a47e41b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ra1FBNv+Tv6rdmslAxWK+1qgseglW07dxc+vIxx0ujdeD7So0XVBmPuC2JEM?=
 =?us-ascii?Q?wOAl+GIqbnxJmbIzSOgh66og4s4oNCV5UiVJAy2WvMHId9ZJjC6uSsccdsiI?=
 =?us-ascii?Q?uzdfoOieV4m/nvbqzbOqqTMNnKyFzMU7LjqPMw/2/cR+9nTNSXENukXBwTaS?=
 =?us-ascii?Q?hLP19MSC1gHvpnFufgSaeLimNCLMdWJMcfa+yCiFCFf8KxkhKNNweViqTLOL?=
 =?us-ascii?Q?NLJpSScRQ2cvvDhEAUaSM3BGikeqTbXGR1pLXl11PyY7zfxtN2UQ3emRW8jO?=
 =?us-ascii?Q?jsdkY5UvxlOHcys9T3CWJABxMFDu4qCJ8ANAVCzLz9cUMclMI58V8rctFNTv?=
 =?us-ascii?Q?4s8UWM5YQdHV1/YUvFLYuFujbtqPt6rGU6g1LtoI+1kMJhEqe1PtqzqnNyOe?=
 =?us-ascii?Q?AS7iR1curYAdBTyKVDrnzKxEs9eG56lJofCW+bvI60mwmv/yHwfmR0mw/ruq?=
 =?us-ascii?Q?ZFYam/fWgfRnoQRTSyhRBJ6SUQGUBfo/Ii+CY0z85XZLKZhaWdw3trr4J9BI?=
 =?us-ascii?Q?z318RJObXEBlFD8PpLOQg9stoSU6wD2dYjXXYL1TN1WujDnFibD38ISMJZQs?=
 =?us-ascii?Q?bWW/+UbQRc6h2cPN4llVtXvQlLlWL1NDAuG21jk1HHB3OFoUwgmiY8F24yN/?=
 =?us-ascii?Q?2nc7icUyZBw6BIPaIDPeBVo5jyrWE+dqcX3Xj08JZSQU3rnoV8ahLpNyDTBZ?=
 =?us-ascii?Q?kFasZv2UrhbzeNbJ98aXm4+QEWjMg4Uhl1zXtjWdrziuMqZ9mkSe+JOuO1p3?=
 =?us-ascii?Q?eS4Kok2mlNgLdE50oJGXnJNIXSoZJij+gPyXnwmY82idy2kZqxfFRXwpTZcz?=
 =?us-ascii?Q?6y3PFND9ehoEv8dCHKDawvGhzsF8MoDcMd+Wxs5XlLXdWHawy19a6QuFej+0?=
 =?us-ascii?Q?qc7G3PL1C9cjWQrHFfIO+5eA7E1oFaRGFdLuNwv5z/QRWtRnkgcQReMMce+s?=
 =?us-ascii?Q?EE4LF3WwUJorvr6j7r2d6nraZm7dFX52Ajv00DpM3OeKFN4m8j2D5wuguslA?=
 =?us-ascii?Q?etROOtgN2c0nPljZqcQV3tDuYaqZ7C+JWZmnUmkN1QubedvkFQNqvLTO4KBI?=
 =?us-ascii?Q?XrCdLRySg8hRqbs7sBNLkDW760F6BwuCz3U3Bj0G2I+EJC1a3xLEoYXQVgll?=
 =?us-ascii?Q?P+dL6sApcynhKzDHWWuJ5guMGgh030V66a9/4pAJ4sfloXQvG68/gZoL5APe?=
 =?us-ascii?Q?bAF5QcoAv66cuUNAdLyN40we63gTQB0FEs4EB5/HFQXszgQt7TMwXXhUpbui?=
 =?us-ascii?Q?5tipgwgHhPUzZ+Qajz4xpfJdH83cuD2BrR3p/Hxn6Q1/75/wEFeJSAieprMw?=
 =?us-ascii?Q?u4d/tQYKd1eeQwA4yAxRFocxbEZqQ/4D/FkAbajwBjXKVrpatRHQdBRGJFtd?=
 =?us-ascii?Q?69l38g+L4Re1Zyba7zRYtkYVhDc+XB+c+Ps9sHmeYJyjhnpg45hFSi9fB9X6?=
 =?us-ascii?Q?8vGchq2Z8hQnXMKAGGwdBCbpHCim/wi90U8VmYzR4stG3EzsvBsRo4HsAwow?=
 =?us-ascii?Q?6j9Nrdg6c0LiAGMau4KX2pvV2KWw89M7qebmLK4NJy9EYI9DX7dK85sLYdG6?=
 =?us-ascii?Q?WD/yomuoXtUqCd2BBlOPy0lD/4euePTkghjxt0P3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jeKkaIcBb0gYf71JktXOs/Rrrc47ktwgIUE4B+8V27zuJJYc/KlJbAnkYutj?=
 =?us-ascii?Q?A9qXWcWsnZTQSjxc8p2SRAGTvYi5Df3g4+/8hNsnc2maSvyHBDAkGqzROS1V?=
 =?us-ascii?Q?w2YhDMIT8UN7oXn8vEzzm2s0JYzknq60TPTI9dHGSZ5SBbkkvadJrxEF405p?=
 =?us-ascii?Q?UkGgf9TuRK+l/6seB13XK7M9Vl/iElDQ2e5G9oPfiaQsBoEBNcEXqm+R8dkM?=
 =?us-ascii?Q?5pM5HWemBatku/hpxcpvPTyMM5OeTKCVluakht5GH6TO1fS42WkV/CqLYpaW?=
 =?us-ascii?Q?4mYl+Va3rSU4PA0jKFlDNSV37FKt0gVEYtVKtfmwoiDW8tRbhOnXkkz4x/ul?=
 =?us-ascii?Q?UDEQ4d8BnwPBkxr9pg1SYE3TAg+nWNOn3t/ijp75ebWpZjBWsTHDEphHRPRP?=
 =?us-ascii?Q?bH0ciKjJPs/MoBO6Z/LK+LImlAcPOkeuCpbACAbzHGTP/TQWSOl1A+WlbU7B?=
 =?us-ascii?Q?koSx5+qq0T0kdBekUljH8GulhIhynFSbShMboSZwihbcuKCF4yrKPXEHca3F?=
 =?us-ascii?Q?Fu+T9vros34yzFLq1deAWPzchK1szzVavFPyQUYWa6mdH1inxacvOayYo9yw?=
 =?us-ascii?Q?yZnbPiPiZTMR/KXZHyAI0xdx3UuIQjk01eXpBhdMBmGFydviIV1spvfvehyw?=
 =?us-ascii?Q?IoGEt5Z1q3BxiPNO1C4v2j2yox7Z17WcKG4FJ4Ckl7ifkQfzNmGMFudPs/NL?=
 =?us-ascii?Q?N8Q6bn6pKUsNvx8u4yEt5akrSEYsF/beDwD3lxrY/b+ZSAeNT/xD99q9wP5Y?=
 =?us-ascii?Q?B9UFea1yPq8Rnem2Ncj/09HappMjJ8unNCekVCuQwKcqLgi14z46QTQYLhkg?=
 =?us-ascii?Q?ZM6iN0jUGYZYkgRs/gU+EmHgUkqeEXyFcNSpSw+7NQmJo+tkSmFKi4l5/EpQ?=
 =?us-ascii?Q?4W2CgOfELHqfH9ZM5TeeRzEG2HJVREjXUw1TJRt32ky2AW9DZdDxXfghEgJa?=
 =?us-ascii?Q?BuBYBSLOERdAIgkZyB+FZXbOhbTIRss3ufhnTDGxN5B1NM95W9LG9bRqZ1PF?=
 =?us-ascii?Q?8Zye+ow/BrmO1FxdwGa+bQDh+fkhBOzFOeRcNBS/h9kLGllKr20vCdtInZ1C?=
 =?us-ascii?Q?ieEaCIv/YWAbimcEtchJREWcoAUecTupVYDX9pDSyLprKZ0DTDINucn/zeVl?=
 =?us-ascii?Q?ufrk1XP6qEuOcKteorx+V+aLni7tYdpaDAVN3lSZ0Kf/SYPUEbfpI+6DbXSX?=
 =?us-ascii?Q?JCHY/AzhaT9gB8xrkYUB6iaJFO5XX/3vb7P0BNMgLAmVn8XBNaID3jeTwLjf?=
 =?us-ascii?Q?7Tg0ZJgq16mdNGTK9xFPBKywmq+Py2dbTigmVbXTwn0K665DOf8+H7ltkijd?=
 =?us-ascii?Q?DK7Oa3JON9PdK7gGHZPCOQ/f2PqapCpAaC+aR4FtS6LOL5GCm55BPxsCDA8/?=
 =?us-ascii?Q?mpoLiO+sUPy9JWCJizid1ASoEQA3Cq4ycP2GHoDoxhXav819DD/Xl0b3p4VI?=
 =?us-ascii?Q?YI3qdzRfewxZqGpJ5BX4xC+Sqh4uZpdfMWgsBXWhTjom6kKzowJZRDWcV0Oz?=
 =?us-ascii?Q?TRF9mLVmEg9cXAXS0Ee3J+4czBEfbRRqEo54mo9AmZGj6hXrt/RXfhymJ4BQ?=
 =?us-ascii?Q?QPWi6QuN2zrG9SMiSvVLVZ4GIhgr0T9rITJKH/V4cN0lMIE+uRdbug6vplQ8?=
 =?us-ascii?Q?dEghzwoH9snmZ7Lu9AJUzJqNK5v4YdFbAzj3chk1f9WWKClP2lMjJEAViS22?=
 =?us-ascii?Q?yUx0x3WC2jC6TCF+TZaGGtcKpB7X/8eaWI+G/oz2KkprfA89b3WEYr6OSrPw?=
 =?us-ascii?Q?OH2okpzOYQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0240c47-8c13-4578-1cee-08de5a47e41b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 06:23:18.2589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1HwQOu0elptO5cAjoBa5UVOPb3T8tG1Duft2RlienVmZh3gb9jVopNvaXt1xtELGhTr/3EbGe4BGuyW7RkM8xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 99D5640004
X-Stat-Signature: o5m77tejh9at8g4898zmua9ufy9abf7z
X-Rspam-User: 
X-HE-Tag: 1769149404-369502
X-HE-Meta: U2FsdGVkX19Ie1rWgMwif8JONTZfU9bgwMBJTKZGyo4OIfKMlK22ozKpwmWgwvLfb6QoycbCFNyMI18/WXiQTMLK8eCXQfDxhKun/BI+EGYH5pa5QFDtl+4Tj2uY1ulqY58futc6mArLvdfWqYO/ybK1RT6io8NS8T/G6Usf7Tfg7Bq7lqN42Z02f55hTraONmNRFmtQLht+8Eo0Q9QKq6FHAkzU5Gnx7TkA4S6C9qYXjemUC21j0lmQ9UXwHFlNrGzEj6x8/yg/ceEt5HWaQADPSRRiouq1krSA6mFPYIAKXWbgl8eWftrdoFIyF6inos4kGZRKyYfBzjNRl5Mob6WY9Cm74yRtN+0wwNqzj1OPQQivGhnVk6DKFEqVA7Barz1wmzZkXvPfiTAtWxn13rirg49joyb60fSH9Ae5cIzEQzXZ0bQ8nGYV2Mp/Jkr8V3w6xd1M1HtVzW3zfShWt+KEioggR9khAfKJ/8Z3Z0aZ89q9yh9b8kiXzlZjDyLs5HUJxa+DlYM60ekY4hxzphfJdf+yhCEWCzn4ddOBYQLAc2UBJSxHFFN+xlcNE76W0af6Vdto+yk6sJ3b+gTGCMC2zKmHAySINpsivCB6Z/jq0wiobtesbifwsEtNv8USaxc6idoDs+UkwBD1I9umVJsveZQ2xxcAVHVDtl8rgjq9pCAram0Mji4KCD03TZ17tmu/il7qgDjB36mQazZoJiBQrZpaRitp0W1vPu4DjoADlSJ3JBAwHX1pGYcnUUhbdubVvgN2Lheown75KXl9zoZC0+iayi5VVyKAFzB1+dkBxWI3X7Xya90m/6nIyF1ePnFNwDniZAKv2Vkky0JupgSJ3xGZ/mqYvHX0EHqdWrV8q6hL/g+JWoujbSOT2FGtDAs4+56Hay9yYCf6Alln6f2eqZde7XJ6AMvQ82ed6soILtI5ghOZp5ciDcXqeCgBaYqTnBe/HBfrCJus+xw
 rMaS+YNU
 s7KXNQAlVC1omS+ztAJan0TjwvCghVzR915OprVeC63azCiX9bx7937MyeIwDVI2H4/U0TRJD5xfZV7nmr1ngblpJWevWq6qypGhbHMHDpgyvjnl2cYJhqF6MZsdRLp/LYqNALCwoi7FtICqHE5AUkaRa7Tg+6LSOaYaiRP3+VB2bQ1DAFvHMqUYTRDB0kaM4H79X+RMG3WnhtPljS+TyLq0CSABqYe6JpUaiwrgJbj3wmD3SXMvAMuoHxbit8wCb9Go5X2t5oTquJAAfOlIJQvdh0F12Y/tJdpab257Z1nMoS9VaUBA11FdqxcohOEbAoodopy93uAL7Kc6ssmM4gi4wTpIkNNhQSF8cmAf2np2d/pErXv0xRkB/DzRyJSZpAI0hfwiIFiMMDKJ1wEInc+aCa9IDcoXSKL/SkYi5OG1uXdlazV5xy9nglg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduction
------------

The existing design of device private memory imposes limitations which
render it non functional for certain systems and configurations - this
series removes those limitations. These issues are:

  1) Limited available physical address space 
  2) Conflicts with arch64 mm implementation

Limited available address space
-------------------------------

Device private memory is implemented by first reserving a region of the
physical address space. This is a problem. The physical address space is
not a resource that is directly under the kernel's control. Availability
of suitable physical address space is constrained by the underlying
hardware and firmware and may not always be available. 

Device private memory assumes that it will be able to reserve a device
memory sized chunk of physical address space. However, there is nothing
guaranteeing that this will succeed, and there a number of factors that
increase the likelihood of failure. We need to consider what else may
exist in the physical address space. It is observed that certain VM
configurations place very large PCI windows immediately after RAM. Large
enough that there is no physical address space available at all for
device private memory. This is more likely to occur on 43 bit physical
width systems which have less physical address space.

The fundamental issue is the physical address space is not a resource
the kernel can rely on being to allocate from at will.  

aarch64 issues
--------------

The current device private memory implementation has further issues on
aarch64. On aarch64, vmemmap is sized to cover the ram only. Adding
device private pages to the linear map then means that for device
private page, pfn_to_page() will read beyond the end of vmemmap region
leading to potential memory corruption. This means that device private
memory does not work reliably on aarch64 [0].  

New implementation
------------------

This series changes device private memory so that it does not require
allocation of physical address space and these problems are avoided.
Instead of using the physical address space, we introduce a "device
private address space" and allocate from there.

A consequence of placing the device private pages outside of the
physical address space is that they no longer have a PFN. However, it is
still necessary to be able to look up a corresponding device private
page from a device private PTE entry, which means that we still require
some way to index into this device private address space. Instead of a
PFN, device private pages use an offset into this device private address
space to look up device private struct pages.

The problem that then needs to be addressed is how to avoid confusing
these device private offsets with PFNs. It is the limited usage
of the device private pages themselves which make this possible. A
device private page is only used for userspace mappings, we do not need
to be concerned with them being used within the mm more broadly. This
means that the only way that the core kernel looks up these pages is via
the page table, where their PTE already indicates if they refer to a
device private page via their swap type, e.g.  SWP_DEVICE_WRITE. We can
use this information to determine if the PTE contains a PFN which should
be looked up in the page map, or a device private offset which should be
looked up elsewhere.

This applies when we are creating PTE entries for device private pages -
because they have their own type there are already must be handled
separately, so it is a small step to convert them to a device private
PFN now too.

The first part of the series updates callers where device private
offsets might now be encountered to track this extra state.

The last patch contains the bulk of the work where we change how we
convert between device private pages to device private offsets and then
use a new interface for allocating device private pages without the need
for reserving physical address space.

By removing the device private pages from the physical address space,
this series also opens up the possibility to moving away from tracking
device private memory using struct pages in the future. This is
desirable as on systems with large amounts of memory these device
private struct pages use a signifiant amount of memory and take a
significant amount of time to initialize.

Changes in v3
-------------

Thanks all for feedback and suggestions on v2.

Most significant change is fixing an null pointer redef when
memremap_device_private_pagemap() was called with NUMA_NO_NODE.

Details:

  - mm/migrate_device: Add migrate PFN flag to track device private pages
    - Use adev->kfd.pgmap.type == MEMORY_DEVICE_PRIVATE
  - mm/page_vma_mapped: Add flag to page_vma_mapped_walk::flags to track
    device private pages
      - Track device private offset in pvmw::flags instead of pvmw::pfn
  - mm: Add a new swap type for migration entries of device private pages
      - Move softleaf changes to new patch
      - Update commit message to explain the change reduces the number of
        swap files.
      - Move creating the device private migration changes to a separate
        patch
      - Remove predicates - we'll rely on softleaf predicates entirely
  - mm: Add softleaf support for device private migration entries
    - Separated from previous patch
    - s/SOFTLEAF_MIGRATION_DEVICE_/SOFTLEAF_MIGRATION_DEVICE_PRIVATE_/
    - Update comment for softleaf_is_migration_read()
  - mm: Begin creating device private migration entries
      - Provided as an individual patch
  - mm: Remove device private pages from the physical address space
    - Use numa_mem_id() if memremap_device_private_pagemap is called with
      NUMA_NO_NODE. This fixes a null pointer deref in
      lruvec_stat_mod_folio().
    - drm/xe: Remove call to devm_release_mem_region() in xe_pagemap_destroy_work()
    - s/VM_BUG/VM_WARN/


Testing:
- selftests/mm/hmm-tests on an amd64 VM

Revisions:
- RFC: https://lore.kernel.org/all/20251128044146.80050-1-jniethe@nvidia.com/
- v1: https://lore.kernel.org/all/20251231043154.42931-1-jniethe@nvidia.com/
- v2: https://lore.kernel.org/all/20260107091823.68974-1-jniethe@nvidia.com/

[0] https://lore.kernel.org/lkml/CAMj1kXGtFyugzi9MZW=4_oVTy==eAF6283fwvX9fdZhO98ZA3g@mail.gmail.com/

Jordan Niethe (13):
  mm/migrate_device: Introduce migrate_pfn_from_page() helper
  drm/amdkfd: Use migrate pfns internally
  mm/migrate_device: Make migrate_device_{pfns,range}() take mpfns
  mm/migrate_device: Add migrate PFN flag to track device private pages
  mm/page_vma_mapped: Add flag to page_vma_mapped_walk::flags to track
    device private pages
  mm: Add helpers to create migration entries from struct pages
  mm: Add a new swap type for migration entries of device private pages
  mm: Add softleaf support for device private migration entries
  mm: Begin creating device private migration entries
  mm: Add helpers to create device private entries from struct pages
  mm/util: Add flag to track device private pages in page snapshots
  mm/hmm: Add flag to track device private pages
  mm: Remove device private pages from the physical address space

 Documentation/mm/hmm.rst                 |  11 +-
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  43 ++---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  45 +++---
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.h |   2 +-
 drivers/gpu/drm/drm_pagemap.c            |  11 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  45 ++----
 drivers/gpu/drm/xe/xe_svm.c              |  37 ++---
 fs/proc/page.c                           |   6 +-
 include/drm/drm_pagemap.h                |   8 +-
 include/linux/hmm.h                      |   7 +-
 include/linux/leafops.h                  | 120 ++++++++++++--
 include/linux/memremap.h                 |  64 +++++++-
 include/linux/migrate.h                  |  23 ++-
 include/linux/mm.h                       |   9 +-
 include/linux/rmap.h                     |  29 +++-
 include/linux/swap.h                     |   8 +-
 include/linux/swapops.h                  |  99 ++++++++++++
 lib/test_hmm.c                           |  87 ++++++----
 mm/debug.c                               |   9 +-
 mm/hmm.c                                 |   5 +-
 mm/huge_memory.c                         |  43 ++---
 mm/hugetlb.c                             |  15 +-
 mm/memory.c                              |   5 +-
 mm/memremap.c                            | 196 ++++++++++++++++++-----
 mm/migrate.c                             |   6 +-
 mm/migrate_device.c                      |  76 +++++----
 mm/mm_init.c                             |   8 +-
 mm/mprotect.c                            |  10 +-
 mm/page_vma_mapped.c                     |  26 ++-
 mm/rmap.c                                |  59 ++++---
 mm/util.c                                |   8 +-
 mm/vmscan.c                              |   2 +-
 32 files changed, 781 insertions(+), 341 deletions(-)


base-commit: 7a45b8f10286a29b005fdcf1e4eb0ecff8675c75
-- 
2.34.1



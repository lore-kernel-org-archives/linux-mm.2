Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ED6BCA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 20:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3FA8E0003; Fri, 29 Aug 2025 16:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB868E0001; Fri, 29 Aug 2025 16:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAACB8E0003; Fri, 29 Aug 2025 16:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B7F258E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:42:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56138119532
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 20:42:57 +0000 (UTC)
X-FDA: 83830969194.09.A5666B3
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8C56AA0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 20:42:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mhb23AOY;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.73 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756500174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkFMlfXR9WqPfFrdoED+y96LHByEWfT5IG3Woyzkqe0=;
	b=b87QwqwctsuNClgMf3LKiWSlYR7K2cGnmC8HWpir9K471Z118OIr8RQIs2M+EVAaBeKSZk
	yaGBV6tu1X8wf/7CUJcvTqFuLS4C4w7/vUAVTtsJ1dufkmSUdpaOPpdq+EqXCkP9Hpnjpn
	Z1sV/g9yCd+W/aYSIP0dppWBN34BBng=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mhb23AOY;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 40.107.100.73 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756500174; a=rsa-sha256;
	cv=pass;
	b=PDmPv/qg7IAUYjoP51G3No2mzCfLqPkbD/P1VRG+ltD3bOubkxEGJJBsMT6W22snTIbM1m
	IV7myiwnHkxLJYC/mMlkwa5PlLysinXvQrugby1Baw5TV4L1elGPfYmhn2+wmnn/T2NeiF
	m+c2GuN5onDZDu4aSeokkcjHBAOvllo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gn8Ivhb/8rHZULBq1OJ9UV83FXL3X7NletC4DTXJgzEsGIAGXq1WwbRJNiI2lVv//jOYvG9AF8IZjlNE2RTnl48KFntld2NYJxTImGugXi7kDhBoP8BKOFWW8cbbyoXxHTzA0LQSMizahszwpJG1pGgVe9P3hXYJ+B3rOp5RfIzud+5mvEXGzO8NSXWnTKulZjXDCaguxV2UY0d0OS5Wk+V6QPQn74HAM1plAXs6OK4qQFYWtp3EOODaNTYe/ueudyu4lNJ510mLMzVgAO6FKcSpkctO5hTQwjEBQWUFu+ID/45IB5YI+wTY0dDN+WlO3NBBlJ95t0jEZDRls26n+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MkFMlfXR9WqPfFrdoED+y96LHByEWfT5IG3Woyzkqe0=;
 b=OJIKUu/Yggc4T7ahMsQak3rVHptOuQB5FBB2vcrIUaa7x7B7/yvpLyzKfSRhJtBmdQ6857hpdsbC7LMOcfPKaFkDLd56lGhSj0JVKfmeemIIxOrRvxWo31s56Doo3jyrMhPL11mCErPVvNxO3mSjR+R+4GlOB6TNsDVczCpoywjueiKrTtSOGlwflWQhBPBXOe9TnS/yzIVSOeMYcYWX+ndRbK9peLk+xXqD1MV2YLHqdS4R3xUKlKTzRLMvfCWKssM4pBRc5mElBW1iT+hAFjErGHmmLY+niS5AF8DTiZG/vrXZFS2o7iVuliCGFmQBm7y9zp3mLh7YUjgzWkkzJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MkFMlfXR9WqPfFrdoED+y96LHByEWfT5IG3Woyzkqe0=;
 b=mhb23AOYUVNjylRIKqYsMuM/Mi7X68UUGJc3YZz+dnx6UX9vzKTItE5sqvpf2O8ZQeyXl6teDJP4rOhqant+qvRSD6+RAcTE1QZiZq4bBDTo2DlYya0D9/fdVn5g6CWfaqK+qowyOmV4WShki1vZmzkrsOCxcoiUVRteCQAAHhmnwkeAovGzhFLCbDt2iSpQPme5EZ1vELDMiFe37tEqPZkl21zHhJSRm/aBcsbygKM3n20ZFNMQpQKPdOpA8q70hW+QFaO38Oe2ukIQm91TjVVgm5tpH49Ig3irsoRW7GYW6O2M9ZQF5L6NjL2cZz27z7Y1625ALrDOcuPryTXUNA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW6PR12MB8833.namprd12.prod.outlook.com (2603:10b6:303:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Fri, 29 Aug
 2025 20:42:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 20:42:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
Subject: Re: [PATCH 05/22] mm: Constify compound_order() and page_size()
Date: Fri, 29 Aug 2025 16:42:43 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <8A306C85-D97C-4665-A683-0AA69122AEF3@nvidia.com>
In-Reply-To: <20250829154728.3397606-6-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-6-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:236::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW6PR12MB8833:EE_
X-MS-Office365-Filtering-Correlation-Id: 889e2be3-733a-465f-cfea-08dde73c9ba5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E5dOYP7KF2In2WLwYvGZYks/mU8MzampmAovxbooZIM0jt8EtrRFyNQFz6Y2?=
 =?us-ascii?Q?zVpelCEQA+1NaXkTxxdPtcnSxUvO6nqV/lFleBSxZ/c/w4boEZfsB5ewkhNS?=
 =?us-ascii?Q?8Q0eTfCziRPsS16TMow8E13/yY9OBqMXjcQ6AbwOUIhfb+BkGdRr9m0T9VIM?=
 =?us-ascii?Q?aq/6u/zZKfl3mGCvcy0CF9SnSe0hOYHvTKVC6AFTmr5Jei0P+sxPsYsHbFLi?=
 =?us-ascii?Q?yIo0/dEki/cpP2TWCtjc+r8HaMIzVqJRFA+dunQVWWUZfebp5ouaRV3i2N02?=
 =?us-ascii?Q?Fkf6BuS54nVAWiCKt7Hmk9euuzk0GcdZ4N7APspgRDJsufXTu1xN/6dBHnw5?=
 =?us-ascii?Q?2NbxoORIEkBZWsrmK2ezBs6GkDIvVMCFc6NK21C9L0DzTepR0yK6/ll3WzbM?=
 =?us-ascii?Q?p9bAn8zdbAQw1Tfm1pgSNtz/Kq2d3gvKOFnkxrBqPJUDyQ+9KG0qOJdcAg9c?=
 =?us-ascii?Q?QOBjA/ZHZcKGfwBqE8FH1/KYi6dVHj6Tixk/T1Nw21SDQrjKna8Fgd16r7Go?=
 =?us-ascii?Q?sVbaIXvBWicwjiIEauqiVqOSix6jHxtIr/IGwDntKfV2KFQ4i4FTXT/s07sj?=
 =?us-ascii?Q?exzfRpSHH6TxU9sOAiC/ryqmxQ5Y0DwSprB0uGft1UIaPbZkD9B+jsv6YeAf?=
 =?us-ascii?Q?cQk0/XW2r9njECJ5uI1o65wDHUyqxvXZlY8utQ/l7V/owCxJrj4gFWxZSr7N?=
 =?us-ascii?Q?hEhMSUpDNOdUSsnAdL8V71+JisDYjIaXXHrOSU/ia8SYkQ7MtsKekjxHzy7X?=
 =?us-ascii?Q?MrAdubLoY7kInBElna13m0hd2oTh0WfbY4YxfHNy0b8A3NKCTQ1r/iXP/28R?=
 =?us-ascii?Q?bPyGorV4XdvukrNdn9Ws6BpLN48P9kVrIo7YKczf767gesl/+fip9wCEt62u?=
 =?us-ascii?Q?PIIO/38mx/iF3txddQVppOZGA4U1PoGQEGoNvbKppNSqqKWryQgHeA+u5+H2?=
 =?us-ascii?Q?hju4LEwEbU0RqgpAFpQi2p/Wg/3mZH3eddnUOTl1I2DkfflqVe0QGWFet6je?=
 =?us-ascii?Q?2ICyNS0eEGkwsPYZpxHaOvZQlmd51H6uGEwKKcoJVQxHaJHVVC9oG8FhBhw0?=
 =?us-ascii?Q?7mE7SfiWfkFg5AIgylNz4f8gaFqPrNS5RMMDErKLp5Nvk0txyTqKjiJ+JUmL?=
 =?us-ascii?Q?7I2hQ9U99QXbigxhvKmMVa+DW9bUnzTCPGiMlqcMuF9ulHrFGH/xnBWdUBdu?=
 =?us-ascii?Q?TiukqRfNLYDWDTjoez3lBVTlKWe5a7q8UnouevY2fdy6A7xeBnabC+QwwBkm?=
 =?us-ascii?Q?AasrkfJSGJIyaPoOMdJWm6H6FvBLIxgaycoamxB5ajBIuRQrw42DdiheU6Ct?=
 =?us-ascii?Q?oD8kZVRRnVY+35K5Gaq4pYNfxKQQC40az/XMJ345YMlZcTr3hNhgU75tga2l?=
 =?us-ascii?Q?VCp143/gLauwNWFtOPbPcqEtFZzW5KESWDyYJ8d4EB8mPAXoiQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tTDuUXqDBosbPtKI0Fo4fPfNoGzWpORxDVOzQG991emYkV7zGqPNd7d9E4HL?=
 =?us-ascii?Q?rclr0+lUmYaN9c7LpTKltW4hI+dhI8n9b0dia3sSAq1urbXD67zVFRxEVxjQ?=
 =?us-ascii?Q?AvJC99uwDoSwetAOhKhEF2HhwW7TWAJj10OW/VVmyNKOQbWtTazNx6WaTr2J?=
 =?us-ascii?Q?MCKZTIdY+dOmjH/14JNQaSvZJhEmkC1fgP8ZBkxPIPK1rvODRqA91dfsj1Cr?=
 =?us-ascii?Q?C1eKMaTqcAz6aIDeVG94WWDTAipjxPvoFLGiZQaHfpOIqLRcjLExq8Ta7C7X?=
 =?us-ascii?Q?0F7fB8b3QBxd/t2G9x4haf22IJ+f2loPH6Kauldau+2ITRaQRl/HVU7jcnd3?=
 =?us-ascii?Q?dizPZFRO2mne5BfPDQ/oWzBS2hWegzFFqZ/UlA5AvlFvYdPvauXTd188nbmW?=
 =?us-ascii?Q?LZLPfQEsb6WbG3ev1Jq+9U4vdfH8Kgbf3t45f8JEjW7OQ8mgcqhd+GSm2SG6?=
 =?us-ascii?Q?SIrc5l7+OrWCXO+UNdd64V0Yo10Cuw/3cbQi69/keFKIOG1SkUPj92Z5KZ2e?=
 =?us-ascii?Q?194J2LnlWTKMlfML14YH5llx28N+i8RW3/TWZxPa+zVaqb/7JT8DAFQr6udS?=
 =?us-ascii?Q?SvgmFgHG556dmE1K1rAp38jc3aY9vLUQy5fme18eDbDFmKJFkERwJg8aEFMB?=
 =?us-ascii?Q?RQV80jLymXxhnl5mwkedpbgOWaCGwzemWb4YBEiREPL1ijCY1NgL8mXkYaNB?=
 =?us-ascii?Q?Tg0WflKV07+jYEEXCpwIRWNo8dVECcOuZQL1DfWySXu+ZfWVnyVbbf2BYCJj?=
 =?us-ascii?Q?PVcEquTsmctfm70fJ9RPne7O8sAJMc62GE7LuvcxiUDAY5Iu5oJWzOwUWoE1?=
 =?us-ascii?Q?hF7zFcOiaaZO7BsAyNSM/kHnByh6DhqDNtf5kArOnO12yuKrApRymXcHVoPA?=
 =?us-ascii?Q?9JBOdyuVRqLktlDjicQmUV+gaj3gvrIABFJUQ+75rV1Uspjb+6nPqxj51Ulz?=
 =?us-ascii?Q?/vG1TJ5QPSi0Taa4Tn7D3mpgL+T2/k+OfobNinv8pqnNDMZYruhqsLsqX3hU?=
 =?us-ascii?Q?g+Jh2J2cQ9GFKZwvDuc9jkEFnpRSGyQ0k8PylIG6fQvhIlLG2Gsnn9oF4QUj?=
 =?us-ascii?Q?122+OkBLCzS19QpqZ+s8jUMHsw0eOLk9CfrSn5wkvaWb4XlBEnN9ZQfNEN1S?=
 =?us-ascii?Q?TAfv0buxpfn4U734kW4CaoTmUys4zWTXjsZHKZxOHwEk+1zryfnQfRdaWms5?=
 =?us-ascii?Q?XgOlUfarx4skbJDrc1+ndVnJQcQUQoVJwxWITOlEKR0QIQ4hhTM2BSE4jPQM?=
 =?us-ascii?Q?jzQ23Lkc+1SXBL7vca76hbzPjJwUw7PNbFfFOLxj1VWPSV4GuRCLp5BPwQat?=
 =?us-ascii?Q?cilZCL8Lamr65zIJh+D/pSNsxf9mLq8doohlAI4mBepMfyUZiEU2NkZ73ZIn?=
 =?us-ascii?Q?k0hByivHcA/Z3UmFpDyZGEeq6Papdm7H87U1S+xnuB3Xq8gW3//SOkaxEyZN?=
 =?us-ascii?Q?j7E3Iz+F1ZVEom3Iw68noXx90q7YHZZxe4NuC8CE5tYbwXcRsFD/pGkx8BIn?=
 =?us-ascii?Q?RVqAzHWZb+e3owAQJFnRuvLPSPqjuYOkJVwkrgSHsv8ho9h2NPUPt9W4A71R?=
 =?us-ascii?Q?itPZVJwnizh/aVlEk8TAdZQKz/iSmfsQV8qPPZHp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889e2be3-733a-465f-cfea-08dde73c9ba5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 20:42:45.3340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZsOng3ZEi/F5ORBwjvZIYTe0iubFivDsGxImqIZGy5yq6hE/S97+iMfWalNFmwZ3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8833
X-Rspamd-Queue-Id: 8C56AA0007
X-Rspam-User: 
X-Stat-Signature: uwxcupjwfjppuy87y34eycfyg4drwxes
X-Rspamd-Server: rspam09
X-HE-Tag: 1756500174-634971
X-HE-Meta: U2FsdGVkX1+2Zk0hwf3IfQ7n9HSmZ1Gtb7SSGQ6yVh9v0NEsR4jXpJBk39BwXByH6cQISJBFmsICnsrxK7aeykvVmlNw3CHgzj6b9gl24qZ4ULSTFxotWQF1Zs8YIuhzk8FxgtvEFmSb1RtvmeMwlfQio6ocIqCKCJ7aqPlSRB+xtFCxtt/hBD3H3tYmSEd1VmsZHKiB6vEkXGTbc8rngB949TIw0EL6srxZLkbCNPjXNdY62IoCSONLvDncW9x0hl5/8CKMXhTa5qGoXUGRNYg5DHvM/4ezJ7mwWCNC2zRzEK769T1z3r3gtisVGoqQQ4B74XnSExG1B/tPEjQ8SxKAydhx8gWR66pIQV8TTMV4JtsSFtlaiSHVXophvSuIQckKXp1HBAB+cMq6rXpJ/EeyVPkyVTXkCSljklD8faxCyagHVEh7U5lI58CFS8u2d+qs6+YCBBIxVGURY7TYZjc7vq7tSWjKBDsYPLDlZQjAnxr/fdZEFjieRGA6OYPp4rEA/WUpHco0k22y00hBhYHlwrqfkXO4Aa/v4vfto8bngVKbeEm18qsQoMMhMvJkfinCt4mXx4HWjl0+/vMr2GzBI1/FkNRR5xU7R7IU81fRmwmARpxFEGQ6djTdH5dY3iItAs1lCqnX3aC4jqA+0QUc76WmL7HxOE4RUsAMOA+nQ7K9PAxBzRLdG9zu4Owe2eRjpy1OaWLJfSQ3UWcgTka0WBIclm7KOicrvoOlEnrlv5eLUYirlDhnoxt4g2Abffrfy4O17Pvqocb3nB3Y/QN63vnf3zRQ94ab+q6kvtEMmhzuxC+TWxd2xP6O8xTV58fBTa2B0gwcSOBzV3Nb7I4FUTYi6jUxZFiEbj8fQ7zVufE/5ZSKMaP8yD2+8ztIedwMigRmVoJp8I4+cEwy+Jq2xFK00vs6QVCsR7kSqsSwjem24Uf8wBvF+kwScU6cG2MH6tu8WBWow2DC3ND
 uppk8hI6
 O6GIE5/aQII7z4kGQuC/urCUhO0mpC7Gvd0goG0/DOmD4STTaJBgrOINC3l7sZknC5fTcPPSBQZJrXbj5hNCMlPNOEnhEX2e6lbVcUsgwkEWX1z0PnUW6+H3hDgwK6xmZ0h15aQFKx+N9oqCdVupa4VAS8zHN22u781dZJSqK9t7O4cVhauN712jmTOqtM2cC/NLh8IwYqeXdAgVBtd2clPHnmsW5z9M9a7/4IYIsth1yJJTbverNnnWX+UyKkxumFz1ehpoKdDp8KE2fpP1eyoXFhN2G2dIJbVNF5+ZZBzVizelNCodSRgqa7aS9WnxtBUBlT4sdlFHr0Xdd5DSSZEIDIHwej24oHyVzWjQR4YedwdZMUTe9icYLl3UL848+X5X86oOiC/nP0Si/L/n0QmC4SmdOR02fEtNtHZ9Yr/cuHub1+82SuVbjERpXcL5cx2rSYiUVYI9bNjF+leI2h+UQ8HuOvFrwDisLWrrWaEYobuTlcn569HCx85q0l6ABPVkttFm8KIbeyMgHqOupZv5PfDpU0TFnZe93JPVV2JbyspLa+BbUWB+iK2Kz4DUPCKJSSd89PDilZhc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29 Aug 2025, at 11:47, Matthew Wilcox (Oracle) wrote:

> These functions do not modify their arguments.  Telling the compiler
> this may improve code generation, and allows us to pass const arguments
> from other functions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 00c8a54127d3..02fddbc38647 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1020,9 +1020,9 @@ static inline long folio_large_nr_pages(const struct folio *folio)
>   * set before the order is initialised, or this may be a tail page.
>   * See compaction.c for some good examples.
>   */
> -static inline unsigned int compound_order(struct page *page)
> +static inline unsigned int compound_order(const struct page *page)
>  {
> -	struct folio *folio = (struct folio *)page;
> +	const struct folio *folio = (struct folio *)page;

Why not
const struct folio *folio = (const struct folio *)page;
?

page is already a const pointer.

>
>  	if (!test_bit(PG_head, &folio->flags.f))
>  		return 0;
> @@ -1240,7 +1240,7 @@ int folio_mc_copy(struct folio *dst, struct folio *src);
>  unsigned long nr_free_buffer_pages(void);
>
>  /* Returns the number of bytes in this potentially compound page. */
> -static inline unsigned long page_size(struct page *page)
> +static inline unsigned long page_size(const struct page *page)
>  {
>  	return PAGE_SIZE << compound_order(page);
>  }

Otherwise, LGTM. Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


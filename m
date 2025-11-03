Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FA0CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED8D8E00A2; Mon,  3 Nov 2025 11:19:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC5E18E0057; Mon,  3 Nov 2025 11:19:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4628E00A2; Mon,  3 Nov 2025 11:19:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8F008E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:19:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 868821DFF7A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:19:34 +0000 (UTC)
X-FDA: 84069806268.21.5269486
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011052.outbound.protection.outlook.com [52.101.52.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6BB8120013
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:19:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Uc0Hu4MQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762186771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmTYw1Aq0Ypon9bTGX+9f+NGVf2sdXjT6qo6hFvvGIo=;
	b=qa1kkLUcRwV3LN7u8MYAp5hmYR5UPMRq+xmxDObaXTzetb9509isXW/p6N4jJ7lxIoKnrb
	8qM1268QtoDCh/h+U+rbQGO+48dl+9RnAEyWECN2UpUHotmjl8btZfzaRXKzbBCS/alfKo
	Tf2iqcHfMF8hGe0X0ZKDHTFtDPZecRc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Uc0Hu4MQ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762186771; a=rsa-sha256;
	cv=pass;
	b=xg7dU/Z61UBNIFkT7wT9PiO6idVt+5rsb/JRb/Ev4lrOKz0LQamIWvNIbTssCBfCRiClC5
	Mnw2Q82Io+zVuhdgeRp9+GDpIu2UJ8D1ObZBbz2DFc78pP6Yx4OfUkU96UDK1ags7f+ZDC
	1Ns6+b0Mg5fGsQH9gyRH+Ri4SQli0Js=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h5Tr8vU3Hh65oOiSsVnVBuUgMZ6gZg/9rsf4oY4XpwI3OygS8zMhI8STPlOsi4HZ6AmjLdr0ndbR3Al335VMtM458SNVtqyWfa+Phfw17H76qnyzuMpcdt3JWBvKKtk827xUdwVwEuTYn2pGptfsMlYy34RxvFWZvmwuzk7mO7weMWziR77TX+FlUTsxkci3yJD+COY8Sj+xLAFjLMgcr/bff9wnk/aDfXfO2xi69YEFkreLkTe8kSpiIHiFiYaPBvu7VUAK+beLYikBuzgdehy1Wwy6WZJ/qlZjkc93kE2apLTXEujriIw2jKOi7zZtO399OyLDjZ5iAkuplyhOmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OmTYw1Aq0Ypon9bTGX+9f+NGVf2sdXjT6qo6hFvvGIo=;
 b=t6wgYLnEL8aGd6MunKQwBovGCeKXX6yWpMYvQgVZH+S8GhBNz+7rVmaiAC0dKqeekewQHLK5x1ZPHZbOzPy+Rw+aO0KiPwrqQvP6BOMy8B3PoVV3VmHnoyd3B7ZUfsyqqQ9r6UNV6q7ldwgWrnY3IVOOGzHI/AvaA+qszZ/epnnC6dxrpJB5MVlHoKUTM2IDJ4CUJl/XZnWEWsHde25zSfYG8S0iAl4F+U/4iYcqQFAULZFBo8Qvt3FkQn+TqjdXVd+Dkhj02YLWFmbRwmvwbLXLW0BytqCHsrs4NRdFeMvA/u5OR6q1sWGhvh2xsJw20pkdwcL/ekX4YH2v4GrKdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OmTYw1Aq0Ypon9bTGX+9f+NGVf2sdXjT6qo6hFvvGIo=;
 b=Uc0Hu4MQuG30y7z/7JSEsZ6Ct3LdYrn/MvhV2V/iipeM8Tq2Lwvy/NiQ97AbcQt8N3ITwlsExy/ZwwXSdC+PoDDVSO2yAGEypfsZCulB6EA1Xp3DEEWgJ5Y4WGJNqMMRQg47/8UmGMhDaZviKMjznHnnTwolTXmxdizjUbRWqM4s6cyYA24kkWGcd8X2WEPf7cF8347GDOYwEysKHGq1jI7wNE7wvgw3Yd0qBH+Y6FrsaByZjulym/bIB31EDJOFsuBOOOk50fjFm8JAZyERJTZ6vlQJsjN2sPUyP0/SXNyQiZsWwBrL0WgeUZWahJvu7ELp0ZH3uOw57GiJDlR0mA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9450.namprd12.prod.outlook.com (2603:10b6:408:202::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Mon, 3 Nov
 2025 16:19:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9275.015; Mon, 3 Nov 2025
 16:19:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: merge uniform_split_supported() and
 non_uniform_split_supported()
Date: Mon, 03 Nov 2025 11:19:23 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <BDDD91BB-FC30-418B-88FC-9118E483EE2E@nvidia.com>
In-Reply-To: <0d79bb63-38c8-4dc8-9ee5-13e13820fb75@arm.com>
References: <20251101021145.3676-1-richard.weiyang@gmail.com>
 <0d79bb63-38c8-4dc8-9ee5-13e13820fb75@arm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0357.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9450:EE_
X-MS-Office365-Filtering-Correlation-Id: a9b18810-e173-4222-037a-08de1af4c197
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?li1yRJQyiMEz2R03x1Ehqux+isloU+Q3RGgYw4a563fy9wyGvbZlbkkUtBcy?=
 =?us-ascii?Q?PT/c1CAkzNy6MokVbcid4Y4qvAOYbDfLsnAH8K6Epmh1ri4qbogBIBC+D33+?=
 =?us-ascii?Q?7xxe9kMVurHjKGvDKOl3NyJ1NthbYTBi18iO4OVL5hcD3w5BrdTJdfq8sjFY?=
 =?us-ascii?Q?agrKCvi9qzCRCd3eq1xCsOYLUS+cXLJwb5QTta9/hFyX/YdSJZM6WCHs6NE5?=
 =?us-ascii?Q?yCSZmv9BuQY+dcKADoKGwNMOw/XCuOvBOQAPrKU0u2c1wNyCPU7x9mEqsvyk?=
 =?us-ascii?Q?StjXyC7uDe5FbwvWWt21eN00Qb2naYK/+HVMrQEiMUurAJXNEcrEJFr4vAS/?=
 =?us-ascii?Q?80ywnfKbOMhp0v+6/64NPgWMnnXE76w+2dplONgm1MWA1HG+K2QkUvBLr9y6?=
 =?us-ascii?Q?OKAblVzblSjuRr/nQeQKJqLW5nine/cEwsNWY5SWMJzaun3kNJ+aooXh5l0w?=
 =?us-ascii?Q?I2ldXaYhuSuV81ccjsf+XHobE1Lse3uso9ctvmLRbsQY+unTbdeEClAN2Qhv?=
 =?us-ascii?Q?fMGzFg9mvVaWQjDL/0WN8FERsd5aqzNwrXdvXpfMUsIkXuYI+XBD+vZNtw0N?=
 =?us-ascii?Q?GMDSUhSMDY2mRmrRqDBOv/+W0tayL3ucUEJx2h/Z83VOAAxhbs0rD4gLhcr8?=
 =?us-ascii?Q?wnoWCpRfdqzmAKssVW6RywleMRxhUFIp8tD76RBcKq56Q3wOjsA7RlO0ynZ9?=
 =?us-ascii?Q?Ug58KuZ0g6TPJ2prk4n9MzGf0sHwBJ+JEKCpz6cdIY7VrNzT1lFLeLmgcB7/?=
 =?us-ascii?Q?ayS+/VFOPFwnhMkm99tA1NDRR39U56oUuBmIjv3wDwID+553ZPN+4p9m7mU1?=
 =?us-ascii?Q?B7BLPWlhzQnQyeDgiwJzlxGeounNptGbtEcA91Tl/ztsqGX07vGlY2b+FH/M?=
 =?us-ascii?Q?ubc5f5qm9cgoxODgkiAz1yPXhHsfNsPpgdUpbHsno9U2hBri9eL+CxE8NCv1?=
 =?us-ascii?Q?xqBf7TW27pIgaVaudyoeL0I0NGUNWHnyyoEXkKfiUsgDoGPqGnLeLAR6v9PH?=
 =?us-ascii?Q?QpUQqrX23B4yOZzICBfsKKndwYzkwZy2rMjDimxmUZ0dxYXOtk43pRld7ecK?=
 =?us-ascii?Q?zxjDQQuZ7Lve49bhKs4kwydfmjAqNXKMwnEhfzHlSFH1jubCF6pg58vRFBLB?=
 =?us-ascii?Q?TR2pF5BU6C+BR8+Md1mz5PmxKx49kPmiycsCInQnix7UMBweyKIzQYCRopus?=
 =?us-ascii?Q?D3TSqmmRyk0ttx6PtLuJROk3GAHdek//YYbWvB5Qp3z7WgDsCzmBp8ZJ0qMX?=
 =?us-ascii?Q?bmzXuNiE5FqnJZvWByrSyYjcYv0D0ab1DSexc3YP0CEocA9wxmSLmqAUEUaK?=
 =?us-ascii?Q?VuEIZTrlejzAbgkyrXERb+YbxKfDOBVXQ3tAIpSydS7EAK6ub5L+g2yR9QxA?=
 =?us-ascii?Q?5aw0IgOuNrJ8PugqKOtaVpsPYtGFp81sxzOOaAKs4FwkdixyliONg7awlfUr?=
 =?us-ascii?Q?BUkNqkMYiCAPGEL0RwvsRPxQXxIc+b4b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K/jRaZT54xH9+z7QulcsOmb2M5sPOM5NTLg7siM1O/hLrUHfcGL2jSreIcIi?=
 =?us-ascii?Q?GXRr5MY+cPql/SsPjh1aEH+Lb8xBcIam7l4trY3UA1BoYBNEGGS2zGFdlB1k?=
 =?us-ascii?Q?O7RH61Zk0EIKySy84/HpysRfMhLWldJXFQaNwmdtvtMu6oJHRVryIcpfr6Jj?=
 =?us-ascii?Q?M+txVsFUvCIF9Urrskq4NVnrZFdnlb6dzaGdyuHmr0EqLRLEJTbkutE1sE0s?=
 =?us-ascii?Q?BjCj7YEVUs8XUJSyU+LJkzAChRLUiu7S2pYBjA9TtoIJV88ZdG13uttU2h0+?=
 =?us-ascii?Q?9r+K1/45roNFAsbQtyemQQjvOl6l3wDQtq4N2l+XsZonFu89ZUNVJVEOi3XY?=
 =?us-ascii?Q?qn1msSz8j6Sso9VpKFHjvI3GFfhvTw7PY3xnftqNT+oR1HcQwWms5oqyJiPD?=
 =?us-ascii?Q?Q7Z2RrMXvutPXZk7r2k8yxBKi8mPpc9fqhvlEHm0iG8ZizYGphszqYyLNY7S?=
 =?us-ascii?Q?9xe81NwaUFRF1a1EEKYCDcM4MsM2iR2MJ+xxPTGgy7DLSgWHRbDbTfQk/3Z4?=
 =?us-ascii?Q?vuJYGL80DCclHnYYPXc2Cn2ougzyCtlYZjdnD+h6GIfEwCakgJMQsUPE9a27?=
 =?us-ascii?Q?5ykjDPK7OFdVpRmQIiDMLIwFNgpVwH9pdcFcPk57h2QMRWRWgqJAjYsrEecq?=
 =?us-ascii?Q?XgQEdYchQzIy7OBeJrXhkVp90khKHK5oCibCLDiIWkt9wKvDM83U3iTfwyKr?=
 =?us-ascii?Q?/z0ltWxueY5rVRgNQKJuyMAYYXOIXUcBwpl6NC+dKwE0r8Q+JqYczW87qxNY?=
 =?us-ascii?Q?dQLf0kUOXuT56oe4OpwXdLXJRktmpYlF4aR1vt535ykXbkq+Yx01kByhAC1Q?=
 =?us-ascii?Q?9foPzVVKK1vXKhcLISa/pSPJJe9hmBxPLZs0OrsTxGjdCOBP+TuH+P+1A+H8?=
 =?us-ascii?Q?cuEDwrYsYtVSrBfd+jZ/eVY7Vui0/rnfMPT+Jc+GREERIRGKrmtHB2G7zhLI?=
 =?us-ascii?Q?Xd0EyD9lFpJxjvNNqEspm431NYVvEQUV5eBQ9erCH9XLN/Vtx3Xo7rTBOTdU?=
 =?us-ascii?Q?+Ed9j/HIOgZx2MLakg52zOD0nWYGnKs2mcsJsyu+EtN1zRMyjJV36GLf2/uT?=
 =?us-ascii?Q?EKz5UJs2R64icyr95MmhPlnm7qabzTKkQzzYNFnCvemN8J5JXtVxiwp8kwUO?=
 =?us-ascii?Q?v89GY8kHvWSY+vACmuN2impmL3jxRzF+3JyggK0+80Vee4lkkvScoziZggGk?=
 =?us-ascii?Q?Ekq1VQupO+4ghDuuxc3+CTFjPTfBxC0eUxiGMlpOGwnaQMuQFN5a/c1MRzfP?=
 =?us-ascii?Q?OP11B/DR/97/hosQQrrajPUemJjhAJ0Z56dRLq8PUuTr6DX2ljpKSYkkZpSD?=
 =?us-ascii?Q?X/KLxtBOnIq1hVOGI3mPIpEBkgKKvr0h9teqalolNopzXT/Hpb+ZPTDcMwZc?=
 =?us-ascii?Q?skOFVk+cNBI6KrzcxctzHaoSrDsc1BGsJDzDPDsld6fzd19SV04a6zYepjz6?=
 =?us-ascii?Q?4lZy88uxWt32t435kVEbz2yIJr1tXlz/26gy/z5c7VhC7pR6IhzOuVNgXBSu?=
 =?us-ascii?Q?ImItLpJOiWoLi39GOppUlewF4QOgtsRgUnnUCfGeIyGXGdkAYAJO1qucAMu8?=
 =?us-ascii?Q?K/P7U/OSk2NtSiHwRB4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9b18810-e173-4222-037a-08de1af4c197
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 16:19:25.7106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOJqxdJOnGd1yet1TMrEZ9dc4HDOu0mRak1BQkbRR+SEh+DXzFyxY6wQRzDrJfR1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9450
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6BB8120013
X-Stat-Signature: 6mthz546s6tdqraywismy7wy8zsh4jfr
X-Rspam-User: 
X-HE-Tag: 1762186771-322551
X-HE-Meta: U2FsdGVkX19ZlJ3ABCN1R78mqF0BpCk4t6aL/kCTFrfvfjrW+pqUj5jadb3Ts00YJlhywAscg2s9hiNXatr4imaOUu5wokKJmMuCdOIC454XF6bbXZ+LYiCK8LBLiOQOb0EzaH9+Dpv43vhWW22m7/uoBU1iMLZKqiQAz5LQTUMWQfodWFDn2Q5BZhoMDQHJzCUw5JAv7N5E8IHNRM46eM9DH4w1NFSHefWg5TmBEhe9X1wLseUYeub0rtQmoXvC4VkcG4O70xJ021LCh6lTdaZb827teV6S6rFhxYPOXxxU5eFzfegafXpO8Sgz7+ex/mkDgmjdI59INlsC5zX7feJgYrz1PDahOlB1n7pR6KcZarvjtxFKuT7esgyWvdtd7u/gd7u9wOSfdHeg82YFZULLOxsJH/Axi8LL6NeSI+MuSyA7DeXjw49Z2y/FddyAhPYL10olWSwcy/9IYscwNXJsqoLCXgnzsfZ5RPTLI96xxqtm7zbSkT8KZ0zi2PeQIMqQ3whZBJezjd29FjO0/6qc/y2tZk/y47nk1dbVtVyxB4RUtzyjas9gPFHNAR5ntLxIC1YEekxIuwKtSnne1seygevOVFs96xOFscakeQImNwgK/PWIt1LeMaUfjPuewcviovdPyu0vvc6chz92aXUv8HT9SMVqjBYfmq2nlXEgLqQM9BTNL5FjKvHUMrR4lI3d5K1Pacev/n0eu7yj0i0Xz2s1Y0HDBkjlLh5czoiGpUHdETsa45bBHwby3JP3peTvHTgfN/sLPND+vDWBps7waMyauSy3QCNVyxwGJqdZ5xSWTAZ/Eo+2Q5p+phnPCoE82CbEWtHhTNFN0f9s67pNiIZ94FQolcKo+ebAVAmewvfNTcWemPeVli+HRov/LgCLCGLzMcd/Cp3UASP63KJEn0BJzfqWWND/l7iEb1bjlcFbRwDii2GcAC6hLXIlDXkbz2tHXysnennFMh/
 mEJMKNg0
 tmGW4ia/LzyOWnExjHWz5dxesd6p205JodrcPHzKbo7GvB6nM99EjIwEp82JQAknPXqaC5X2MiwdfXKbAK80AXS7kbSp8gmnh2ex6BGLn6xFgIfYnCbyTSTv/xUB4SPr61pySePA2Ryh+hxoyDnBgrOdfKlKK9MxCzAPCGIqZZkK1FpQvICx53YatOQXvmB3rauFiqABnVtRtavOYAqkmSeE0E5Y8Yr4aQWOG9dJ/lG6gzH98RPG3WpHt+BVoCReF3mb/vv5IitPvaCmiJXXE+z8fS+74NvDWiTJLCwzaXua9KUZpZf04aZce7HQTJUuY4Zz67jZnnfGAygjYti16w/TUg4hYEEHfx/SI3nScZn/FOmdeLpExajKO85Jp7md4if4OAIlKjj7gxI3OwkWUAIzN0REuZul+8X5TE9ZhKeyi8Nf/6j/cIpJtNbmRVQ2Wjb5h5EbiTXqYwwG2six6sWYikN9Efzl0CQs+58fwh9sjAFSGDtbm+auALTQx0eG/qC7UkUPdR1zIUIUbPLc436R2wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Nov 2025, at 4:04, Dev Jain wrote:

> On 01/11/25 7:41 am, Wei Yang wrote:
>> The functions uniform_split_supported() and
>> non_uniform_split_supported() share significantly similar logic.
>>
>> The only functional difference is that uniform_split_supported()
>> includes an additional check on the requested @new_order before
>> proceeding with further validation.
>>
>> This commit unifies the logic by introducing a new variable,
>> @need_check, which is conditionally set based on whether a uniform
>> split is requested. This allows us to merge the two functions into
>> a single, combined helper, removing redundant code and simplifying
>> the split support checking mechanism.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> ---
>>   include/linux/huge_mm.h |  8 +++---
>>   mm/huge_memory.c        | 55 +++++++++++----------------------------=
--
>>   2 files changed, 18 insertions(+), 45 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index cbb2243f8e56..79343809a7be 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -369,10 +369,8 @@ int __split_huge_page_to_list_to_order(struct pag=
e *page, struct list_head *list
>>   		unsigned int new_order, bool unmapped);
>>   int min_order_for_split(struct folio *folio);
>>   int split_folio_to_list(struct folio *folio, struct list_head *list)=
;
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_or=
der,
>> -		bool warns);
>> -bool non_uniform_split_supported(struct folio *folio, unsigned int ne=
w_order,
>> -		bool warns);
>> +bool folio_split_supported(struct folio *folio, unsigned int new_orde=
r,
>> +		bool uniform_split, bool warns);
>>   int folio_split(struct folio *folio, unsigned int new_order, struct =
page *page,
>>   		struct list_head *list);
>>  @@ -403,7 +401,7 @@ static inline int split_huge_page_to_order(struct=
 page *page, unsigned int new_o
>>   static inline int try_folio_split_to_order(struct folio *folio,
>>   		struct page *page, unsigned int new_order)
>>   {
>> -	if (!non_uniform_split_supported(folio, new_order, /* warns=3D */ fa=
lse))
>> +	if (!folio_split_supported(folio, new_order, /* uniform_split =3D */=
 false, /* warns=3D */ false))
>>   		return split_huge_page_to_order(&folio->page, new_order);
>>   	return folio_split(folio, new_order, page, NULL);
>>   }
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index d1fa0d2d9b44..f6d2cb2a5ca0 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3673,55 +3673,34 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>   	return 0;
>>   }
>>  -bool non_uniform_split_supported(struct folio *folio, unsigned int n=
ew_order,
>> -		bool warns)
>> +bool folio_split_supported(struct folio *folio, unsigned int new_orde=
r,
>> +		bool uniform_split, bool warns)
>>   {
>> -	if (folio_test_anon(folio)) {
>> -		/* order-1 is not supported for anonymous THP. */
>> -		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>> -				"Cannot split to order-1 folio");
>> -		return new_order !=3D 1;
>> -	} else if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -	    !mapping_large_folio_support(folio->mapping)) {
>> -		/*
>> -		 * No split if the file system does not support large folio.
>> -		 * Note that we might still have THPs in such mappings due to
>> -		 * CONFIG_READ_ONLY_THP_FOR_FS. But in that case, the mapping
>> -		 * does not actually support large folios properly.
>> -		 */
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split file folio to non-0 order");
>> -		return false;
>> -	}
>> -
>> -	/* Only swapping a whole PMD-mapped folio is supported */
>> -	if (folio_test_swapcache(folio)) {
>> -		VM_WARN_ONCE(warns,
>> -			"Cannot split swapcache folio to non-0 order");
>> -		return false;
>> -	}
>> +	bool need_check =3D uniform_split ? new_order : true;
>>  -	return true;
>> -}
>> -
>> -/* See comments in non_uniform_split_supported() */
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_or=
der,
>> -		bool warns)
>> -{
>>   	if (folio_test_anon(folio)) {
>> +		/* order-1 is not supported for anonymous THP. */
>>   		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>>   				"Cannot split to order-1 folio");
>>   		return new_order !=3D 1;
>> -	} else  if (new_order) {
>> +	} else if (need_check) {
>>   		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>   		    !mapping_large_folio_support(folio->mapping)) {
>> +			/*
>> +			 * No split if the file system does not support large
>> +			 * folio.  Note that we might still have THPs in such
>> +			 * mappings due to CONFIG_READ_ONLY_THP_FOR_FS. But in
>> +			 * that case, the mapping does not actually support
>> +			 * large folios properly.
>> +			 */
>>   			VM_WARN_ONCE(warns,
>>   				"Cannot split file folio to non-0 order");
>>   			return false;
>>   		}
>>   	}
>>  -	if (new_order && folio_test_swapcache(folio)) {
>> +	/* Only swapping a whole PMD-mapped folio is supported */
>> +	if (need_check && folio_test_swapcache(folio)) {
>>   		VM_WARN_ONCE(warns,
>>   			"Cannot split swapcache folio to non-0 order");
>>   		return false;
>> @@ -3779,11 +3758,7 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>>   	if (new_order >=3D old_order)
>>   		return -EINVAL;
>>  -	if (uniform_split && !uniform_split_supported(folio, new_order, tru=
e))
>> -		return -EINVAL;
>> -
>> -	if (!uniform_split &&
>> -	    !non_uniform_split_supported(folio, new_order, true))
>> +	if (!folio_split_supported(folio, new_order, uniform_split, /* warn =
=3D */ true))
>>   		return -EINVAL;
>>    	is_hzp =3D is_huge_zero_folio(folio);
>
> @Zi, I am confused on the code. Is there something stopping us from pas=
sing a zero new_order to
> non_uniform_split_supported()?

Yes, for filesystems without large folio support and a PMD size file-back=
ed THP
is created via khugepaged (with CONFIG_READ_ONLY_THP_FOR_FS), the THP can=
 only
be split to order-0. Non uniform split would create other orders and caus=
es
issues.

Best Regards,
Yan, Zi


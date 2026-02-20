Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417FAE9A049
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 02:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4A76B0088; Thu, 19 Feb 2026 21:55:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2D86B0089; Thu, 19 Feb 2026 21:55:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C8A6B008A; Thu, 19 Feb 2026 21:55:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8066B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 21:55:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B57891B6169
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 02:55:18 +0000 (UTC)
X-FDA: 84463318716.01.B025758
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010056.outbound.protection.outlook.com [52.101.201.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC364100008
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 02:55:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Be1/SiGD";
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771556115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ccNbNKtvvfSmcYQofnTIvSJ1WMn2d1ic/6WdSYAeOk=;
	b=JwHBi6u8ABA/hCaRT19lD1MrMJbPrUgD/prCkDqD/a4WjCQ6qOYJ1Vn7ftAbyKIlk9Nwq0
	5etoQ8HhbMsYiWQBc2lLMDhWEIF/QUtQMwgw3myyj5OPbiumV648GOlP02emkFkk3qYhLt
	Ph34AGlbfc2oXWxO4b/HzUvWbOQqv3k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Be1/SiGD";
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771556116; a=rsa-sha256;
	cv=pass;
	b=yN6lDZ2NVvo2fETsCd2wX+Ut1ZX5nOnTgw+nThI7tMopBN6dh6taG5DiW0cS9J0I6mPWVs
	zMvBQ0+kE6Nc964fpV8AwbOPJ4XDk3uwm0G40wTgDTi47VCwS2TUtkmQnLu6deyV8RfKQC
	KEUmpHCIdeIAOiBT/NKk+oYCYFOeV7o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cpegPtuz+Y9yO6uyWmAok0QBABFAFkcYr4s65PeuSwe7GmOPMFKfFNk+0OfdLmIiz7WJJhmki54vyB4hQ1euMU2SNUW7wLWkKPbAV/qaT0mll9BOIDComFaL8kA0LEuIHtS3LjkOeWIxQx95E/sYgJZQR6g507mzb5XrsTgJ4cgz5NLTFEo337ATDoQj9qrk+XPctde1A8rEreQkemzW2cJ49BRfmg1Jgv+BZXkrmsZr9bxA10X2yB1mTunUQZVn17YfPk4mYcrVqXTnypYSwEF7MzZ4WtgSEcOx7knYAe4ipcrNv0imDffmmMFIdUYMyLzWzjQ55p1atuhQVdDbrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ccNbNKtvvfSmcYQofnTIvSJ1WMn2d1ic/6WdSYAeOk=;
 b=RLbC7nt46msByhgs7yOjh4dVtXsg38DOAkbUKY0yy79RbooORTQyo2s74lbh409rML2eB53qd8135s8eDXnAsp7qYrhPOgIiQTvd6hpIcg1lI2IYsVMGh0GxdiW8vUZGrHKe4Nec1K65s8fLAMooUXUrAb7t3IG/YElKwn5HGa2ibffx+8gAOY0HfuBNH2KKcA8TfptyFbCg78IIfB0ubUV12rDurT18sj5jCeJOCEZ54bKgb12TFYcTQ1UozQdJXaj7DkF3jsDJb/j479lUKLK94holTiiFE1beop8H+iWpxf2HdF7ixGJbSpOb1O+ywSlH2vxjz8PVAepW3ycjOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ccNbNKtvvfSmcYQofnTIvSJ1WMn2d1ic/6WdSYAeOk=;
 b=Be1/SiGDpJtQwHioKFtIJd1P3lOLidHq15rj3CKq8K0xMNNcBi9LOAd/X/pPdnNon6lU08GjTBMwHgkmW1PuINjE0NtWt9M0MDwihJLiDnCKGD8ND1Hm9dE4sTI7YFAoJ9O24sjfo2TlwvybgBPM8X/ROZoyaose7TKvYK6gAqCfXnH/LzfFeflKPPuMvQP377GqjBFErj22gDgOFnohsylEZtGM0QpUT/rhlcCbfNut5++on1UG+fVT+kG3NK5UIRBlhHeF3yw0ZdF3Xm1ZoiF83Q+GS9OxoDCvCr4KXp9EMd0XyUEukhB1CpYp5xzld0wKmfjYk2LQk7hnXESFJQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7237.namprd12.prod.outlook.com (2603:10b6:303:22a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.15; Fri, 20 Feb 2026 02:55:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.015; Fri, 20 Feb 2026
 02:55:08 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, lsf-pc@lists.linux-foundation.org,
 linux-mm@kvack.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Date: Thu, 19 Feb 2026 21:55:05 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <34730030-48F6-4D0C-91EA-998A5AF93F5F@nvidia.com>
In-Reply-To: <f261995f-a45a-448d-b72d-18d476697d88@kernel.org>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <915aafb3-d1ff-4ae9-8751-f78e333a1f5f@kernel.org>
 <aZcxWsWO7AxQW6JC@thinkstation>
 <f261995f-a45a-448d-b72d-18d476697d88@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7237:EE_
X-MS-Office365-Filtering-Correlation-Id: e89bf9d6-3e37-4ce5-239d-08de702b7547
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+kQhpny1gg+S6xOU5UkoC25B6AjDJfPo1RhAuQoorAblEaFlJTubjNlgjHw3?=
 =?us-ascii?Q?HV/1QoCgS2yxhlY+qCykZSOPunwkwkzcObt6tm0ty28t/K8/ifs8ORhZGP2D?=
 =?us-ascii?Q?fXTn2M3pFsTiTIgMUhgUzwTKYP77nwuT1OClcBqL5gkfI95qtMaO11V0SaaD?=
 =?us-ascii?Q?slvpswcuIUygeJAjCyQN3VbpXpNb7b+kU3MBbdObePwcJ7nTB2PmMm8OzfhL?=
 =?us-ascii?Q?hORSxf1iXKy488fvUgbQZWcCpKue1BpD6m3g/4wG/kEy1ltVfehOb2vvhFeY?=
 =?us-ascii?Q?wmc7+oM76AcQajcjfYgGzTFsRaejfBeNtl/Y3QyJEkOzAeG7DCvXwR7t0ztL?=
 =?us-ascii?Q?XnCLGV/zxn70AeH6PmRE0ZyQI/DBg/rEyLXxAVBy7SGysckMH5o9CitDvctC?=
 =?us-ascii?Q?QDVjE2hd6gDXX/v1A2707nKD76zAhUCO2V/ttpjU2XbJm2Ehw7M3opuTq+UF?=
 =?us-ascii?Q?50ggH/wvdUIIarKWnFUK2JwTgioPCtx0k3Y4sr2cPSvydIk6gzVUpXyI4NVm?=
 =?us-ascii?Q?2ApW+BF1i/Z9bMR6NBOgHh45/yqfBrdjZm5rrVOlykfC74Nz10of2H0Wbmoc?=
 =?us-ascii?Q?pzpbzaV0XPlLmOBU0HxRpaBhISzKePnQ7Xh3FHpdC7eSwl7ePxAkpdk487AG?=
 =?us-ascii?Q?orE3MY9ceSP2qK1GPOvv4Qw2hfrv9BjkP/f/UesmJ7VNfqZuIlWJQMn28KWR?=
 =?us-ascii?Q?GL31Ha3daZrT30ZYWEs9ZEVxkCz1uShlZuODvTmJrPU80Wjf8i8KbvkvJdVE?=
 =?us-ascii?Q?9mdAZkbybdaYWeuakgGmdWCKb3+PCIpiuAlEPJGmUlgCTnSs3dVv9A/s9NOi?=
 =?us-ascii?Q?UvkLD5tY+I0UwGSOQYR/oaXnsianIkO/zNVP8Ru9NeT1PbKPYB1HLezkkx50?=
 =?us-ascii?Q?62EkbnBBAG35IsXfo9sNoU7yR+ggHkFt86luKSvgfEGXGOinWHfY2myDfHW9?=
 =?us-ascii?Q?xd6eR3bS/enAaRiZM78CNpPC0GvzHHSnHHm0VmCzL5F2fLtViNfOFSp6UM2S?=
 =?us-ascii?Q?8NEbcJW3rj+lPWQmRvjI1wxqw+h6cdz+zcDiCsCRLwcBoyUSPQQEBVcONro7?=
 =?us-ascii?Q?dUtoiNnPAdqN+R9xjPUaOXOKMjzly2zM85ubQaazuGKKP892IPkRocDHPjTq?=
 =?us-ascii?Q?7eWxqTUpA5lGkRtvGjzVozT/V6ic9oTnMimeVOqE7Uu5i2Yw2RqZJKoLnyxd?=
 =?us-ascii?Q?uhoCq0FnMD4v179DP+sqU3cCsobqqpcqMMbb/aSWjymLvlS/0+JFmWusCwjy?=
 =?us-ascii?Q?KEPsqD9MdGdfSq+zanO+r8hGE5p/VYmcr6U0fRsVZfYVuM/w3gM7Ln8gkPay?=
 =?us-ascii?Q?8Ze22uq12JhWZsnrq4vDjuZkUh8Q4VLGZeBJv/VnyzcRT8py1bKjHzh+BKIh?=
 =?us-ascii?Q?gyLOOXNB9nk1DDYITnFS6rMwh7Ezcw96zCvmD+veCCOS8kCFOazcv5xMzV2B?=
 =?us-ascii?Q?7gXR9asdbJOMx16D1S2qLzf1pzKD/Ra4OA1vKjgpZhBjPuGqDE+gR/JGNaNH?=
 =?us-ascii?Q?OHfu9bNlN0QRkL+zbfQ9gSlOTgxocB31Eynm0nPrbkRsbtsTGBp+nzUu96s1?=
 =?us-ascii?Q?Qx1cGsUnJxVAHBPqWmU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fFpXHyi7rAwFvVebbmToj4Yxl6PILHaXziJY3XRnCpZ1tnrDLrqt0e25U1+B?=
 =?us-ascii?Q?MgApKDihxsVG3vVKf9kFNmU7bU52kkvWIBdyjxnIh2AYS6zDfe4elqfbIUoA?=
 =?us-ascii?Q?kIqE2xJt7cgQq3Zz1Xrqx0VRcYeEK5bJCf4l2E9C79aZ2RYjsRBeALS8E5bk?=
 =?us-ascii?Q?3zrkMEqMF2cAS7D2BJbXSXey/GwCXwiFt9q2ssbTWUbl/RcySvY6DmOQeG+P?=
 =?us-ascii?Q?FE1OS/wK0UQ4DqL6e/nndHxpraYnGY7et3vkOvEekmuIfLnc46SgXog7K9DM?=
 =?us-ascii?Q?2GuPupYVfarO0+tzqI8+1PRlP6WilE5hForgp/SBNqTvaxMSZV4mME3S2bbw?=
 =?us-ascii?Q?jZxpkHYvM531bZSQ8BkUW4a3/iZ4Ij4yHpi6WNgErsR4sQcG+LviEYLumKui?=
 =?us-ascii?Q?9IkRPviEK7YwIy0dn8ulMQ/HTFkLu8d0941Mn+ek1zQKgk6+5g92nCz6oVqk?=
 =?us-ascii?Q?BTQIivkMUzw/PGXHCxx107rCRo31ryexRNIKL49HvBR7X75nJ+ucSWgZMcSX?=
 =?us-ascii?Q?Q0PL/QRvZF0i7CDxwWjJut5YklMk9o0H0eGHyICdqvtSE0hKZfHUm3JQeKeC?=
 =?us-ascii?Q?JZVAdIHTXM+/cb9+QZQABVVY4iwpHMP+3lfvj/8O3GbgaPVGzQqFhhVArsBF?=
 =?us-ascii?Q?00MVqOKYnaA8vL2mpZNGn9oDHKv53SCBVzIfzVgV50EtbY3SaUdFG5Lfepmk?=
 =?us-ascii?Q?8tLHGTB6ZBa5FKs2YC3fhUaxae7Ov56T1oIDe0FaQXsmXHzprBDKD0TDgJmE?=
 =?us-ascii?Q?Rrc25inzKBqEclrfBRdXWfZERmX1j8SxeWMKWrUPILESLiMztUTgmZaBY2/i?=
 =?us-ascii?Q?dNqNblbYGdGKkzD9+3e4l01wjP8TcJBxL+qdjqnc9EPNNDSedl71cirF9POm?=
 =?us-ascii?Q?E3Qk08FnSHA8wjgYWypP8xkaaageVOXlpRg/jX4A+yIKVtv1T9ba3fnwFs47?=
 =?us-ascii?Q?POX0yMUgbgDF4HdnShm8f2P1uHOCkeJLU7J1CpHhmAThSNhmIAbRjqU1g9cQ?=
 =?us-ascii?Q?BN3ZUgSoxt074z9FqJ2pUbqa/O4b3J3jLI+E28N3BtPFbtMYQJDOlY+8/FJf?=
 =?us-ascii?Q?VWX/x3F34/i/PQeFfwT7gwX6/3ogNCbQfCmyMcHDEyWEJPxsac4AhU6qG29i?=
 =?us-ascii?Q?abhjFO+zC2Z1q84sRgfBbJRVRlg5g4OdVAVpWGH7pRNUigMd1GqI2oU7f9aO?=
 =?us-ascii?Q?utAKBSXYlWBkzEl5SR0dpR0NhUT1B3vqoIWIxTs2zN9b87v2nFuUDe66js8a?=
 =?us-ascii?Q?csP5k4bwUru3pO0Jde392oiQIvJkwZa9Pq6NjDcoPgO3A+CfwLxmva27yLGU?=
 =?us-ascii?Q?5TyYMrgMVExwrFmDTjJEnj2Mmb9ddusgV3KfmGnJW/mqup9PUPn4HnNeB1Gi?=
 =?us-ascii?Q?jwdUdykV/b+MflY5wesCgmwDA2aeTEk5pLLXq2iVy/m7H0pBWYozOVnsMqa5?=
 =?us-ascii?Q?LoVmphE5OfVq75pliFPqIie+65zt+5Vh/OSJruqXNNNzU16cGhzkvLdfJbJI?=
 =?us-ascii?Q?+a73JeDOjx20NA+/J6BE0jNAMzrshg6guT6dr5L6QX7sCZDryiReq6BLP7oS?=
 =?us-ascii?Q?vs6WUQxBqdBRQ9c3qSnoFsjoQykzN9WDsakqcVcmtZfwExLbgWSjtSnpdz40?=
 =?us-ascii?Q?JkxWlVB/i/M2P/LDQRYOblTy/hrL3Z1soBHXTHRIcZT/p8cHcbrVpYoDCNSv?=
 =?us-ascii?Q?rreGKaXMzSe5UD3I5E5P8ksOYsvVeH26JNyKEExF1ZRU+wFA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89bf9d6-3e37-4ce5-239d-08de702b7547
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2026 02:55:08.7981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ucY+d6Jpo7706V2MEG9l9iuFflSgtftjUqvaRbACbogxHj6jgaUxIRaUYkyJAKYj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7237
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC364100008
X-Stat-Signature: ipizbe1muci4xieqjq5c7deucbxksdta
X-Rspam-User: 
X-HE-Tag: 1771556115-687244
X-HE-Meta: U2FsdGVkX18E1GOBH8Gd28GPdjn4EeUbyyW5/mwUuYzIzZR0MmRxR4oZ4+qXRD1lboW+BAMJyVlqWVWPL+nQwQ1QtR0BY3z/YE2UfLmttLaZIJMfhlGavkFxmAri4VQde4qkvlTTdvctE7hTkdiqohqYH9dCFQB0n0Kn7dJ7mMWi7KYmrGD9U+cGhzrG0uuTgW28VKnodcUjbBnAXDgqTi7YkbLz35H+PKm6z4tV6EJ8AFEXbE4EZUsxte0BfEBUfr7RyA/nb8kbNDpC+vx8a+7rJJgDcUNQ+GAO1hd54kwu/2n5ANDda1CrTmH2iiPfbf7GRkgUIIdlwqCa4jWWA5nzgGaCQVMfFBvzZrFq+0c6COYqHcZW2UFhCO4k3CGyRkHJzwYNalyOmIT3vkvwygiifAua86bYIrLkC98MIbwMtnnviIZooXi6kb12fD7deIeRXnxM4K5Rq/t74545C122OUiHSlToTfmLWpZXy94zFyYmHlXDi/zOBEjM2ZTAk5SXeMHwl+GVMuJJo8m+BV18Ub2r0tAPsZfGAzcDQzoZ4vPK4PBpDc4LpEyO6lqTVntqFHzeq44OPwob04Gx6/TlwAVRHDwfK2BoI9w64Fnyn0b2nwikNRj8bZZdlt9cIKsZm8Ha6stxlJ/eEcBL+mwSf2EnKM4+qz7lTUgW9KdkmtY03KpwD5mvSof0YKZsoge2NJjDEVUZyGn+PsVyqaYPn9DwwjCESfsMW8uBkC4W+lmQutZxWCfYO8DWQw2SkD7lxHXINACQuUd5vJWSWtZaH/DZmuv5KTnWn245GM5rveO/M60aSwB68blwFI4yNPlrZe41FiDcF8rrYGmS4pLXBr3wa0XxE4fQL9mI34oJX0lC8d0/dOEgw59awxp6iGzZwDFsBRvrvg/Dgtx241RR1KxN5uVZA5YaTyzlmbzWVIoVULzs2fvOS0me6tK446EbF7ffsCDUzWgiq0C
 UwPEMvri
 PdNO1w9pQLLNv2ly3wLHAUY/E0v0mshUE+m5y39voN8mvRubddKeDqSThDwXdB3vuttpiKCdoTLxL/Ka2hDRuwYbZydxqr6OJ5xknB4ULBs6l20TVyrbO0td4QZHXqTT3CyjAfTC+tuReUzuygWLMsdNw7HdZ5pY5ye8fvqhzwTBKTvQ11+XtoPtrMq5IvzMqUmRo8L/+IU3Che8INZ8PpiMCi+UKI0TDfkr2g7LwrASv67Ns8jXV4ZplW8RDDLmF2VRl7m57l4VAnCIY3qlS4FdOao09lqLC7bfwUi2UUfqaJEplqZai1MECWAkkkcPD0cqE4y1ZJIOpAE5KFc0l+9idx57uqXXaJZuwyL7edbHJWR87KBPs2hCgdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Feb 2026, at 11:09, David Hildenbrand (Arm) wrote:

> On 2/19/26 16:54, Kiryl Shutsemau wrote:
>> On Thu, Feb 19, 2026 at 04:39:34PM +0100, David Hildenbrand (Arm) wrot=
e:
>>> On 2/19/26 16:08, Kiryl Shutsemau wrote:
>>>> No, there's no new hardware (that I know of). I want to explore what=
 page size
>>>> means.
>>>>
>>>> The kernel uses the same value - PAGE_SIZE - for two things:
>>>>
>>>>     - the order-0 buddy allocation size;
>>>>
>>>>     - the granularity of virtual address space mapping;
>>>>
>>>> I think we can benefit from separating these two meanings and allowi=
ng
>>>> order-0 allocations to be larger than the virtual address space cove=
red by a
>>>> PTE entry.
>>>>
>>>> The main motivation is scalability. Managing memory on multi-terabyt=
e
>>>> machines in 4k is suboptimal, to say the least.
>>>>
>>>> Potential benefits of the approach (assuming 64k pages):
>>>>
>>>>     - The order-0 page size cuts struct page overhead by a factor of=
 16. From
>>>>       ~1.6% of RAM to ~0.1%;
>>>>
>>>>     - TLB wins on machines with TLB coalescing as long as mapping is=
 naturally
>>>>       aligned;
>>>>
>>>>     - Order-5 allocation is 2M, resulting in less pressure on the zo=
ne lock;
>>>>
>>>>     - 1G pages are within possibility for the buddy allocator - orde=
r-14
>>>>       allocation. It can open the road to 1G THPs.
>>>>
>>>>     - As with THP, fewer pages - less pressure on the LRU lock;
>>>>
>>>>     - ...
>>>>
>>>> The trade-off is memory waste (similar to what we have on architectu=
res with
>>>> native 64k pages today) and complexity, mostly in the core-MM code.
>>>>
>>>> =3D=3D Design considerations =3D=3D
>>>>
>>>> I want to split PAGE_SIZE into two distinct values:
>>>>
>>>>     - PTE_SIZE defines the virtual address space granularity;
>>>>
>>>>     - PG_SIZE defines the size of the order-0 buddy allocation;
>>>>
>>>> PAGE_SIZE is only defined if PTE_SIZE =3D=3D PG_SIZE. It will flag w=
hich code
>>>> requires conversion, and keep existing code working while conversion=
 is in
>>>> progress.
>>>>
>>>> The same split happens for other page-related macros: mask, shift,
>>>> alignment helpers, etc.
>>>>
>>>> PFNs are in PTE_SIZE units.
>>>>
>>>> The buddy allocator and page cache (as well as all I/O) operate in P=
G_SIZE
>>>> units.
>>>>
>>>> Userspace mappings are maintained with PTE_SIZE granularity. No ABI =
changes
>>>> for userspace. But we might want to communicate PG_SIZE to userspace=
 to
>>>> get the optimal results for userspace that cares.
>>>>
>>>> PTE_SIZE granularity requires a substantial rework of page fault and=
 VMA
>>>> handling:
>>>>
>>>>     - A struct page pointer and pgprot_t are not enough to create a =
PTE entry.
>>>>       We also need the offset within the page we are creating the PT=
E for.
>>>>
>>>>     - Since the VMA start can be aligned arbitrarily with respect to=
 the
>>>>       underlying page, vma->vm_pgoff has to be changed to vma->vm_pt=
eoff,
>>>>       which is in PTE_SIZE units.
>>>>
>>>>     - The page fault handler needs to handle PTE_SIZE < PG_SIZE, inc=
luding
>>>>       misaligned cases;
>>>>
>>>> Page faults into file mappings are relatively simple to handle as we=

>>>> always have the page cache to refer to. So you can map only the part=
 of the
>>>> page that fits in the page table, similarly to fault-around.
>>>>
>>>> Anonymous and file-CoW faults should also be simple as long as the V=
MA is
>>>> aligned to PG_SIZE in both the virtual address space and with respec=
t to
>>>> vm_pgoff. We might waste some memory on the ends of the VMA, but it =
is
>>>> tolerable.
>>>>
>>>> Misaligned anonymous and file-CoW faults are a pain. Specifically, m=
apping
>>>> pages across a page table boundary. In the worst case, a page is map=
ped across
>>>> a PGD entry boundary and PTEs for the page have to be put in two sep=
arate
>>>> subtrees of page tables.
>>>>
>>>> A naive implementation would map different pages on different sides =
of a
>>>> page table boundary and accept the waste of one page per page table =
crossing.
>>>> The hope is that misaligned mappings are rare, but this is suboptima=
l.
>>>>
>>>> mremap(2) is the ultimate stress test for the design.
>>>>
>>>> On x86, page tables are allocated from the buddy allocator and if PG=
_SIZE
>>>> is greater than 4 KB, we need a way to pack multiple page tables int=
o a
>>>> single page. We could use the slab allocator for this, but it would
>>>> require relocating the page-table metadata out of struct page.
>>>
>>> When discussing per-process page sizes with Ryan and Dev, I mentioned=
 that
>>> having a larger emulated page size could be interesting for other
>>> architectures as well.
>>>
>>> That is, we would emulate a 64K page size on Intel for user space as =
well,
>>> but let the OS work with 4K pages.
>>>
>>> We'd only allocate+map large folios into user space + pagecache, but =
still
>>> allow for page tables etc. to not waste memory.
>>>
>>> So "most" of your allocations in the system would actually be at leas=
t 64k,
>>> reducing zone lock contention etc.
>>
>> I am not convinced emulation would help zone lock contention. I expect=

>> contention to be higher if page allocator would see a mix of 4k and 64=
k
>> requests. It sounds like constant split/merge under the lock.
>
> If most your allocations are larger, then there isn't that much splitti=
ng/merging.
>
> There will be some for the < 64k allocations of course, but when all us=
er space+page cache is >=3D 64 then the split/merge + zone lock should be=
 heavily reduced.
>
>>
>>> It doesn't solve all the problems you wanted to tackle on your list (=
e.g.,
>>> "struct page" overhead, which will be sorted out by memdescs).
>>
>> I don't think we can serve 1G pages out of buddy allocator with 4k
>> order-0. And without it, I don't see how to get to a viable 1G THPs.
>
> Zi Yan was one working on this, and I think we had ideas on how to make=
 that work in the long run.

Right. The idea is to add super pageblock (or whatever name), which consi=
sts of N consecutive
pageblocks, so that anti fragmentation can work at larger granularity, e.=
g., 1GB, to create
free pages. Whether 1GB free pages from memory compaction need to go into=
 buddy allocator
or not is debatable.

--
Best Regards,
Yan, Zi


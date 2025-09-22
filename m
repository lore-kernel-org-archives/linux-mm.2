Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B59CAC5AA
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8598E000D; Mon, 22 Sep 2025 09:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D895F8E0001; Mon, 22 Sep 2025 09:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F788E000D; Mon, 22 Sep 2025 09:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B96E68E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:14:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AD4B876E5
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:14:12 +0000 (UTC)
X-FDA: 83916929544.28.44C9AA1
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010032.outbound.protection.outlook.com [52.101.201.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E377100003
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:14:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N0h64Fls;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.32 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758546849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBsiI8bPXZ+ecqCC8s5yZP07lfqQS5GoGWq5a6P3tuk=;
	b=NaLPIDz7tgfITebAw2EFCK9ufJBZ1Pxdi3Ya8flKrMHL5sAY80MFkGpEJxW8ydwRV1Rsq5
	N4vSyX1GEovoa+uZ4/rJTSP4eNEcGOrW2/wIWS4kTCmleONmUeTBs8vaqx2OXbXq9OeUKq
	gHAHEn7ai1vUvN95yWV8Cj/cu2zd8qs=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=N0h64Fls;
	spf=pass (imf14.hostedemail.com: domain of jgg@nvidia.com designates 52.101.201.32 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758546849; a=rsa-sha256;
	cv=pass;
	b=gMkuD4H8ZgX5s07lLnk3A4MdKetw7fIqY3E+cdlvfGg/3c5s8Sy1muIO8mtPQVWsVe7ZR3
	m0JeP7ryesZSrphbkarSKqQaFQn4qPoEbM/YIZjQ1qZKlgcW9lnT/QSPyMYN3L1Qh+cXww
	OnSSGAgQ55vZBKxYBMLEKX3RpTQY7+w=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R8A5PY5+BnqpMjXX+bqJVaT78qQqdU26Rs7R/8TB2oR4IdrEh7TO1hVURPSAGrwci/Nfl4k6VLrDLCPv7luzB2hECxi63rH1ZgF2CwpOxVzdArAaTJvF3V9KV4GDWEANtA1FITkJSRxbrJKnOLmvY77gBw1AVyyTdJlST1xz/a1+681/rSd72sUE1V9lweS8Iwt+EsjgA4BWbLcKasXLrGv/ihMNiNtkWQbS+98Z18Z+WrSmr75XYWGfeI3sqK/d7wBCFpexJAX2stAm9AE1UWkujsRL/O27RFkhh2SY9xvYhb8obFZuAlPne2p/ie5E8kiV3yScVtgJ5Mcbe5YNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBsiI8bPXZ+ecqCC8s5yZP07lfqQS5GoGWq5a6P3tuk=;
 b=kE+4/7TOg3rZI9Y7i7GzEtTmePt/Y0pzPkZkGh6AT1D320sTwAEQlph8GfCnSk6EZid3OFuUCUWU47h2Uso9ofvr2kuXwIlPB9e68tVaoFiBUrOBW37Org3rNsw1LXfUP9F9dj1Ua4SSrNYNG1uGIEonfty4nvPeFoKRFtJ6pntLbIH0Hx8nPFyTEkBKXxalpozZTzxmsOSurUxTSAv6NG0mCmTp9aAgGpJEOe63qG0Yar9xPWkHW8uLtYenH43y7lQbcJ96vPdVMm0BmwRnUq3E5c9Tq68cAglmiA8Fpr0kjBpKVIhWmSnuL29+bI/85vtnVuPLA0H/RHe0vWHbRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBsiI8bPXZ+ecqCC8s5yZP07lfqQS5GoGWq5a6P3tuk=;
 b=N0h64Flsc2VFYCrS33WuGZ8FHRLBuI0uKKvg6DUvFoiFQxtAHKO0OKHrr3MSQE9KYB9oBPGrOZyKDFlu0e3b29wKtBsQXAyUes4v6M3gIKqAPCDvcKUz1mCZuqSNPEpawT9cFXZeMdpDJdiXuC3l/j4FNGJQN1x1xZiLprJ1Kale+zaWC7cku6yp0CH5uznxNXsIHpjtxR2erpLnz7qtYNrH+NR8hA8VGrcaohMbQ1vImO2eL0qSakXtpxMPJK9xRApujnUA/crrvfLewaezK3YNDzb1o0a1jEVJ1xtGxSzAUzgSeGgVgV0OYDRjNplhMFlpBDVLI8I87q1QlN15NA==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB7198.namprd12.prod.outlook.com (2603:10b6:806:2bf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 13:14:05 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 13:14:05 +0000
Date: Mon, 22 Sep 2025 10:14:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/4] kho: replace kho_preserve_phys() with
 kho_preserve_pages()
Message-ID: <20250922131402.GW1391379@nvidia.com>
References: <20250921054458.4043761-1-rppt@kernel.org>
 <20250921054458.4043761-3-rppt@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250921054458.4043761-3-rppt@kernel.org>
X-ClientProxiedBy: BN9PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:408:fc::10) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB7198:EE_
X-MS-Office365-Filtering-Correlation-Id: 24a9687d-fad2-47a0-2c35-08ddf9d9e7c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dvPDz2dPY+/g87MAwkXaZjaRwiPCmZSFKVuTbXcO8u2bd1ieq+fENn5CdMqb?=
 =?us-ascii?Q?dH0Oi7vA5ianti0yzrV1udamYqWnPtqjX6R2VjE3uVqyV6OeNopwhR6/8Xg5?=
 =?us-ascii?Q?FAiPCyyWj2KJjrofepxJi15coyo9CqrBmZNxUwzU+cK2jie/js1w2Wk5UL47?=
 =?us-ascii?Q?q2dfB3IXjKCknT4ZYFiNeFUtd33NVhu5JSKoqKiiKAT3e4glRND4qQ7WJaYZ?=
 =?us-ascii?Q?gQJhcK7ex0mbUSvXtkS/c3Yprnid1Yl0d8pMT2qGuF5ZcszKf647E9D/2JJt?=
 =?us-ascii?Q?WK2PPrOA5621aukjv+LeeO8B2KAs8YYznArTgSatGK5CO4AsvkLKPcXFhROq?=
 =?us-ascii?Q?E+4f52GCS3jUzY+SvwYnx3emeGi1WYH6bS6LgLR0S2pbVZGgO2yEvLbhxO51?=
 =?us-ascii?Q?1sNKGAF4F8rMdcjwOv5Gp7uoQEU7ofHMlCrK028FDzQYdcziQ+hu6CaTXrmy?=
 =?us-ascii?Q?rPIkF54T2KseMgSKhsqzeomLZ28srrCIghG1sGgbcxpSsZ2axBm8F4j/WAhc?=
 =?us-ascii?Q?tWixfVNiFvdXg1BtBDJu2bjYlBRbt0me4TbJ4G62soE6A/rpLQWA0n4XRoV5?=
 =?us-ascii?Q?7/jygNTD3drlZ+7K//jGMn56K3vzfEQZrbJ7d41e60V2XrmvrRGPBiui9NL2?=
 =?us-ascii?Q?PVYBlw7nPHuS+iX+lrf1e0kMos1uML8cheRt43QRCH1Dh32KemV1ZNm40IJT?=
 =?us-ascii?Q?oiBirWmO/LqOsBZODjj7LR13FcSXzYSYKuQbnmCu3rduAwHkKeLx7EFLagkf?=
 =?us-ascii?Q?W5V8I+sB8f2kqEbZZLYwOTrRavNpJxgEQC3RP/d8wmiG2vk2vzoLRAJIHHUq?=
 =?us-ascii?Q?hagqTQy9n/0O+eFIkM//yjJpHsU/3+NUmankXVfaXZH63DPE0bPt47rDQ7Op?=
 =?us-ascii?Q?yRDQhwGi1ffjBZqit7K2z6C82sMcLIw+8nxr5FjLzTkB1wLmd6UR0XAAj98h?=
 =?us-ascii?Q?MJfZkLhwb3msw2z1xSk/ti89GM06Y275C8ziWIcToPA00Jk2/HpXAmx5f/ze?=
 =?us-ascii?Q?WNQ/CwUds1jnTAwEmxZ05DONKyLSlRV4BcwEISx27LW4XK0eMUm4OfpqpWn4?=
 =?us-ascii?Q?bi73XUPBCumNI6V1kNBqp5dBxm3HzNXVtgM3EwjX9bQoejhY85nBLzUaGm8q?=
 =?us-ascii?Q?Je6/0l0yy7Yt+sz/DxbayqKhqUk7TJxE9lbic1H+SWXpQC4MCxg0NE8oE4LQ?=
 =?us-ascii?Q?yUFSZqlmxEbGkbT5G35jF8rMGmj/qaetYOHf6OjTPcxyhIo/3dGiXbKJ6VKd?=
 =?us-ascii?Q?dm+ypyGULITFA9joVGk4MxnvxV6gcjJ+Jomqi1anbf7/Gs612FEQOCWgwohK?=
 =?us-ascii?Q?X7zwOjoBPMjB3T1Z3GM7++kIcYqnKTxHNzpw/DhVL5NZs87IsSaw02N1Mvv/?=
 =?us-ascii?Q?/Ng7hYgUpPC4JpIz6UAybhJqMpDphBD3uHLJnJR1AYzWVOhIKpdLeHWfYB+B?=
 =?us-ascii?Q?xuWSdFghnjA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8Z1b4aPONTjX6Or8lYQXjJCECuGWS+5SeOqvs5CC/cJjeIqUoB5y9PXQjuJh?=
 =?us-ascii?Q?XA0eGRzu/lMbUzJDw638JaxPwLXWdlF2OvJImH6Dh5Rz+qt3FiAAZe03ZuLx?=
 =?us-ascii?Q?8ImVirP6tUa2BtvUIK7t+46BaBlsdjslkGgI0vJR3H1HIa6mbRaevslTC1K7?=
 =?us-ascii?Q?KuZdDCG/lVUlC5WkgnoO3ZyM+K/MXyRLGFZFk2CHSx3Z2ZoIbQpOmBNZRRJH?=
 =?us-ascii?Q?37O+W2vMf1zhmzJk8LO8UjJdYyNB6R8+kQ+OIIjqVmLW9yWnvSo/BmSdO8Jd?=
 =?us-ascii?Q?ka5MikiZL2xipt7+druBA52Nk9pwQObQQGV0ZfEJowsSRuudkGgm9lvLFEkl?=
 =?us-ascii?Q?a0gYS+AOiSCKADpQPGLlKS+EiVpoi2HpVWeXZ4uutl+kmHPAFan2YapCMxoL?=
 =?us-ascii?Q?KOXRlFdZHJT2f9JVikCq0oXgFF1+esb6z20AmN3ab0Xg97uDQ001hGOIZqny?=
 =?us-ascii?Q?cosVVlKhUdZhwypZCl5Bz7cfEQ3FqZ5t/p8ZQP1nNUeyD67FCGdN721jxftv?=
 =?us-ascii?Q?BZJzX+0oxyXtL3jpE4k7HyNcZBaukAAiTcH8qbg0sJah0CFSClTBUQdU/KL6?=
 =?us-ascii?Q?9NHHOMAcQi7nj814OXgAJ1DpXn8PTYkpA0C1LkvpRDaWfqMwbyA0QDls+lVF?=
 =?us-ascii?Q?jbrebPSXJEwswcqY9/nE0k3kGX/jTuHRKm5vwcJOSEV9IPCYXxMNE9M5T2Ah?=
 =?us-ascii?Q?1dqXamrcRP0auvbSpMh6a31CLkHgR6i0vbmKDCwrdB/z8wzCxN5qEs8gQFIG?=
 =?us-ascii?Q?YH+/F0LShQ5e+NvpIOJci+UfeZLWEi3iVd5JtWaKz/StHNlbd2Uf04MzpmkC?=
 =?us-ascii?Q?Pjju4defxlURlmeDnS5PfwVT6vWP1cLYPCUuiiRnWgeI0gtVpGPIhnGUbtAB?=
 =?us-ascii?Q?o9kSYsN0FoFhrIOylSHMOJk4W5eQoEvbFgh0ApWD+wCAy6a8yqSD9lJnyrT1?=
 =?us-ascii?Q?TfQX56Qel6lktjln2KhawEVNzyjWNwJTJZEVgdf6hOvDNOPItjtfsMMokqju?=
 =?us-ascii?Q?fMQ6zKR6afWlDQDRVZd8vbvt/7A0/cnTJRrtaBZVTwpISqbYTIyQk0RiInYK?=
 =?us-ascii?Q?QV8ZE69w8CxlHsWyiAQ7VdbBO60YNPdVGwKIvU9R53dsu52koa36zmCJnV+i?=
 =?us-ascii?Q?GLbupDE3Ulx0GFBojSDL/yikOEUTLliFWVjp4Y5Q+epi3ZtId2hRHQB6x0F0?=
 =?us-ascii?Q?AM+h+SDxqz1x9/8+hO9cLva5GNc/HpO3cBKOf9HRdSl/wx5SyA/ui+VA4rHh?=
 =?us-ascii?Q?7un30sDl6s41rGBeagE0oMiEQTL10FLB4T1qbLgIrh69TyALy23xVeN/Vst6?=
 =?us-ascii?Q?RJzrOezawKyrb7Wu8qnDzv+ZOuEyFL9AYHCT78hu95pThpVxnx0Ietr2GAZk?=
 =?us-ascii?Q?CYX4u8JZEfAXtSHZW6pG1V/td1CksejnOUOgkJC8UUnEzMfn7guSOnQwHiCm?=
 =?us-ascii?Q?Ovq63Xlw4+IeyGvmJFqmEvcziZZgDN7f+ziBXQXWI+nuAZ98v1a5eEkbRJzD?=
 =?us-ascii?Q?7jjejM5+GhApDQzwEWEReTap2COH7jXDh7XHrnzeKgVi980e/kVoZjE+tVrI?=
 =?us-ascii?Q?/v02dolRNayMgvPMorit5YRcwkfblzHsilIB8CVg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a9687d-fad2-47a0-2c35-08ddf9d9e7c4
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 13:14:04.9718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e2IkIT6b0i8+R+y2PmZ2Vnzo8+NeHFMVf3/l63UoIqRwIam6lJpY7ymPUUnWmMey
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7198
X-Rspamd-Queue-Id: 9E377100003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kjnqkeo8n79gfsyqoydjq9otpxeh4iuc
X-HE-Tag: 1758546849-837470
X-HE-Meta: U2FsdGVkX1919k4qluEkPq3mB9BgMO2vo+hLM1RFzy2bUvftmS7/hbWSQcbzFkO6cK/t84RqufUY+kf8Lu7akiLyeZgTgB14tku9L+pbsnoD3se75kXRf+WAhN2MJsJX7XIkSCrnNIwb+3O3nDFE1obhWKErBhmyTj9YfHAvLVgieq1HM7RaPEsCzw7cX9TiAj5D0M/0ywUtl7hH5YgyF9TWl1YumzFWmWNoDQvcORuD1p09oY0BMM+Q/GoI9zkUXMlqCU1gyHyx9HckPWcGR2maVFFYSrEtqgs43rQN2tGf7Gx42MAWePQqOeAuWrycjvPU2EJcFqQf7Sh3wmYWs4OwPnufNWBZeVOQL6shgyTRW5CdhzanTKrD9FPE23Aqb/Y9dA8vb0SLupIuM33Dd1ka/Mt6Y4sNA80JkSyweI8yHCtiCFdNErBF8EJyqLE/8yfQTOOuNYZ4tI19a0TvKpkpvI+h/W0Log2Hq7cUiD+gtUKxBIv8CtDVAedNrlZBgMpYpbCuXp1ChWYyjofk7NMM51p7fmZHwUqCeWdl9BLfkUBnWOgh7ahvrjTTnkYIphIcEoQyIV1jrjBKUSjysuZnYLJyj4osZruElOaxl4O7a5Z1CN3cgaasnkGqQBwtD75QNru7RbMoJ1C0WAIdB2hqtd9vme1LYdyQ1grFuQQQ9B2CD61+9GbJVVTI88w2h6xGPHjqmJ2FU/q83kg4DLZ89IEU4+ucSP8WA9s9Qg/GYTwGMZ3WFtJHmDQIM0mxiiFnPyAe8u4cSdX7+ecc0VEfghge0Ya8wHh3FXJk/0z/ZFzq6n+21rDpoVk6Dpgyx8EdfoIPV3zhwBnsiRbR45ztSp2NbPk2RKBM+1DfnleQ2K7HhFJS8caLOs8QvRQh4LX9IMm005v3/FqUr1tsSaUUpMIOmGh3csBYksnHJxyw3Bh3BKKOjh58AX1n24+pRDtxP0TWs47DNoYfPue
 RYfvmISA
 iz1GZTnHG3Z7T8ePuC47ddKSsE8UiE5XcAwNPrLHnext/v7iDboOawR3Yv1yLPe4J7cSp8iDVQsHjY0uzKRuvzs4IJCRSYrNs1YESNN/0tx0YgmrVRZKCXncG/P55UySSokTMGLJUHR+u6BjKvmxV0GQiF5WNdhALjZ629EMOO1JP4gNvzUdZVut7ZqU2mNHZBuMIprmcoIw88a0PPFWV+SzgKzIFZqtskYRXBEuMlbmmVcu1ySAR26WMLHjR5Mr8/ZUaVwGDSLF7D+iB7Uo2Jjkqm2eFbnXSl5Sb1fc+5nstfkPrDd6AIYaxBGDCFZei2q87+2EX71uByJA1S/Gjgzx2agR5hMJlj3qVhpVtxNqUSrY8cyS0+CbJc/Yo/eG3GNm2J0emKYnQpiOzg1BGSMMSvGjyhhov/qHW5YeNl71fGWPsXsFzdc2PIHSbsdlScCAQh56+nIkEASfr5EJKtYlKswrbIBaQd7FMj73WGeiGnxbHW6JN6DsTuti9Qq1PxUoa4LshCy9ImSk3s9S5VWVsKwdA7TBSuPm+el1s9xKz+/8R4eu5OEUjj1P9JAEsoPepj0v/rfQrKGQJCKyHU5Msug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 08:44:56AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> to make it clear that KHO operates on pages rather than on a random
> physical address.
> 
> The kho_preserve_pages() will be also used in upcoming support for
> vmalloc preservation.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/kexec_handover.h |  5 +++--
>  kernel/kexec_handover.c        | 25 +++++++++++--------------
>  mm/memblock.c                  |  4 +++-
>  3 files changed, 17 insertions(+), 17 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason


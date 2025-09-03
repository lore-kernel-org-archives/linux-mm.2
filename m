Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 726D4CA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 23:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929D28E0008; Wed,  3 Sep 2025 19:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 901258E0001; Wed,  3 Sep 2025 19:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8174B8E0008; Wed,  3 Sep 2025 19:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C9018E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:07:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 256E0160944
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:07:41 +0000 (UTC)
X-FDA: 83849477922.04.0A33B0C
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	by imf13.hostedemail.com (Postfix) with ESMTP id 692F62000B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:07:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JhkNwbtB;
	spf=pass (imf13.hostedemail.com: domain of apopple@nvidia.com designates 40.107.243.84 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756940858; a=rsa-sha256;
	cv=pass;
	b=Jg2A8xp1Im6mlNfueI8N+00intXlY4fPT5phERZNQW4CTZm2AAytl/jcIjdkjvZ7UIQv9y
	c2hHHB2ZOoXTNO6yE4v1ojdlxTwbtF3vH3+dDrR9aO+6F/9VfSzAllUJiX/RfMyVu3j3Ex
	EqA6BrRKrbiuSqEbgnJQvITwsDxg2NQ=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JhkNwbtB;
	spf=pass (imf13.hostedemail.com: domain of apopple@nvidia.com designates 40.107.243.84 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756940858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8civ0GXI8bqaPeLVMsv4hyQv400J6PS0dN051JSRGgE=;
	b=Irj11vf+61SetS9dDuGVuc+qXCUu+rKgSXEa0rXFh8FwM1ni2kkZeUhj18RrE0pUgULN95
	oVnmJVUKZqyFEOD7KSaLsLxAiKuPjcnO21FFbjIGeN2c1bi3/ABwVQc2tfRUEAgJv4strp
	PkQ3myPu0kfY8H92KeA6J1Ey47s7MOI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qu5f3YVXa/hhFdKg9meG+MhtNhMGD6aObukTIp9+x+ZNXcWvVTKk6Wq9I7FXs8B80N9dh1xP5zY7MxLYJVs/yJNhNm/vzPetvViwPSflkykKqgyn1Um+nSvPeF6vBWzfEMBOcj6fKb63ncUd1CGPwfgVAEqBN0vlkidYFRX3UuGOeCsTWUh8yBBeqObHg1yP9wOnQp86rWEvzgwoQX1qmS/XHY5kDfsnaxx4zYo+KAkGFSUTJxaky5BkzdfXjK/BRaN4wzBJamYNb6LRcvz2ZCs266Q36SMEMnadqq1w+PjNzSdfWXnJuINJuRXaOeIH0VVABiq+SG5p275Fi5AN4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8civ0GXI8bqaPeLVMsv4hyQv400J6PS0dN051JSRGgE=;
 b=WLmABguy00JXGPJ9r8MGd1HUQ9SDsQLJstiTuTs8T7PzGg2rOtoOnG1v5X+kknolFQPE6hv+msIE7Oq+6Cs8o3KZ7yuDvTb/iwOIS2/ZVF6/77W9iVpECOQsXNnjyK7IE5TA4ha6WX7AIzuKUmU26qUGUl5EHqvelv0tdA72/42FqLat3JAo61j93ULud3S2gIfY4WL59EucH0g6Fd6w9KPx8rH8pcNoNcUF0I2ax0T4IaxqyjpJnGqfFxT6mN+eZrbDqe0/8zHqER+jK6ozhKlGBg0QOClQ3OOTbFweFKfvdVgYjXjqX6Q3Nr3FWDb0IpbTSS3A0Lj6S70wUycNfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8civ0GXI8bqaPeLVMsv4hyQv400J6PS0dN051JSRGgE=;
 b=JhkNwbtBSilaz4Myk+zPDraDiik878bdXQkkl8jWdzERs8k0EmyONPp0n71NVZZgILKvTei2tFf98rgXWAcFIYYNcKjyx7+gabf5X2JzxgUStXi4tnxjg0RlRloty4RMzkvnnx3Gn7vOulIbbTntVd1H/yRKS0MepmpHNnMxeTQyyKFeq9jSErRZsZbCmNQRuX4D87JbQwjycxlg98v3XucOhuYJijewH6oLLq/4G2mROVGjROOiFuCvAYW58p21EQ1Mrtw+3STsYwanVJooNldd/auJZz1a6J03gBxsHJ9NmrmR8wi9eDTuWrIZLfIYLxg+FpqQUv+xTBK3u7v7SQ==
Received: from DS1SPRMB0005.namprd12.prod.outlook.com (2603:10b6:8:1e3::12) by
 CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.17; Wed, 3 Sep 2025 23:07:35 +0000
Received: from DS1SPRMB0005.namprd12.prod.outlook.com
 ([fe80::7629:20ac:4306:5f4f]) by DS1SPRMB0005.namprd12.prod.outlook.com
 ([fe80::7629:20ac:4306:5f4f%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 23:07:35 +0000
Date: Thu, 4 Sep 2025 09:07:29 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@redhat.com, 
	osalvador@suse.de, jhubbard@nvidia.com, peterx@redhat.com, 
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Subject: Re: [PATCH 1/2] mm/gup: Remove dead pgmap refcounting code
Message-ID: <2eavixbzaofgm7ufqrotoii2ljs3yvz3sax7377k5pjq3q2jgt@m2trxwsnfpo6>
References: <20250902051421.162498-1-apopple@nvidia.com>
 <20250902120626.GA184112@ziepe.ca>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902120626.GA184112@ziepe.ca>
X-ClientProxiedBy: MEWP282CA0107.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:1d4::14) To DS1SPRMB0005.namprd12.prod.outlook.com
 (2603:10b6:8:1e3::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1SPRMB0005:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dbae8c7-ae69-4040-8dcd-08ddeb3eab2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ol0WfyAb3f1odpNCSLZULOgOT3bHzxP3T0EUgSM1kaojqPnAgDAFEdbjnU6i?=
 =?us-ascii?Q?nmW49twDM7Q5ShJn+/G2/lo15EFmyB4sHusGUhL2SW75xUivta7uQZg3al4f?=
 =?us-ascii?Q?oEFcxz2MIIOql/+GTKpbUEfgWQLe9Hdwh2DmyPoYXFWUOcQkkE0YaYZ6HIVt?=
 =?us-ascii?Q?BpqmbYleRv0a6KtuxY0a+mUgkxCHiPIuqHcilExDq0xIQ5gzQJ+mBEM9cDBo?=
 =?us-ascii?Q?fYr8BSrFkWVL9XgYXiOClcz5YCGAVhxtGXvwXACSz/8swo2ThxwYZLrRs2u1?=
 =?us-ascii?Q?A49kOMEiNMTlPAUrsx1KmgD9sC0fbcT+QVL5NChWtQYcg1v49vRHSHutxPoK?=
 =?us-ascii?Q?34jZgwXYonBK0n77jsWax4BcfgOCs8YRq5JqGYEZWMOWOhK1ZFk+CAMbB/bF?=
 =?us-ascii?Q?nIboueZ2ebqJBbtnaIrGOnREekB44sernVWFwpVzdlGJNYPAX35ko8i/CrlS?=
 =?us-ascii?Q?pMfNn+/sSvAc478ziqJL4idnIxXIwrYw8X7P5lnBXxB3EY0hrPnAVuS/FHcU?=
 =?us-ascii?Q?I3Rpi59zvzFdNLoTYiXSbnGw4reyl5CqcFGCZUqKPPMvZYhVecfZ5f5R/Lt+?=
 =?us-ascii?Q?xvWSo2GkpWKcyR+UXtuPJMGKT8E7x6UdyVflH7SxLtL17ep/7mJIlRTmqbH/?=
 =?us-ascii?Q?QfsZwCxRcWxBuqqUPDaqEG4Uy9WWpzuh1j3YHTbQIIQOYtmR680XGTO8HAXu?=
 =?us-ascii?Q?7cWEGhvL0ZBJsPY20ZaokgqHpGob6qT8ky0gaTFb8pLTC1eHqEHA8D2KyV6b?=
 =?us-ascii?Q?IUKEbG9VN1LP/OTbMPxii6MbJpzzMTiwnSNikUpVIloTSINKNF5vg5qK4SDW?=
 =?us-ascii?Q?65an3l86v1XMS9ukAu3ubo0xIdxc/15GmZccxewzCS4d6TXopI0CklSCgZhd?=
 =?us-ascii?Q?QMtG4QAEisnzfaQ11EhDNTtHjem2JWnu4BI1t5OAgFAv5k+PbYmmrBg9Vfaw?=
 =?us-ascii?Q?/hpKcDirY+1MoS7fg2J98v9FgvNKHPtJveEGN1G5dZo/pQODVAm2ak4Skgap?=
 =?us-ascii?Q?6ejOuk/5oSiby4xHVkF4mLepGYaN7Vha4TZsa9C/Al87VDs0+Y9oV8si4l4J?=
 =?us-ascii?Q?snvJ6ONDhgwHIl1NlUt8F8FpB3uNgBBR5ZyM2ncoXf213AtoE6ShaT55iwR7?=
 =?us-ascii?Q?5JGvQgY87bOY1wlxY7LTf0IYlVkbSCCAgfj4fd7KmPzMf/kP4EjLqVR1ChBo?=
 =?us-ascii?Q?PDOfBP9i255MCxwfvFxu7qSIxUPWub2gNUCvM3JHYu5faz6ORyClGL2Y+ZeA?=
 =?us-ascii?Q?8An3JbgpzvqiIc19BQBYHoYUJ9qfEMrYHqWz7wO7OsO+mJ4UvqmSAL1x37q6?=
 =?us-ascii?Q?tl0Ay4IVM7deU+KrSHvAGHDWiUmEA21JvReE7UTQWmv2iAOykbaHFZZVjy57?=
 =?us-ascii?Q?xHMgRCOK+9TTSA260D+KIHnT7pMMgv8A4JG442E5/gdlLBc1nLR149osDXJM?=
 =?us-ascii?Q?Jce9NHztPGg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS1SPRMB0005.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y9ZvDXFPJGTSNykFp/lB3SIuWSLEPU+b64BjwauEhRN2/bq0bueuWe+8s08v?=
 =?us-ascii?Q?/mkg4Dc+P5O16h+E0xYvmd+WJaSl7IG+0W+UdironQPzm3ehLdJ7vHhT1tNL?=
 =?us-ascii?Q?DUkJ3ntJOFKwqF6Hm/X4KpH3MEtkUbAwUVrYdGHDXYZUp1yz4sKxEh73xLPZ?=
 =?us-ascii?Q?t9QS3vp3nENXheZQbLtljXrhk9frNsmm7ia7SuUXuCAdsuVmrXLgv5GiK3Uo?=
 =?us-ascii?Q?HMD/TWc2x6/VbInCBPLqCu/pYii2NIO6ElaXtLhJ6siI+bC7Cbimgt5T4/Z/?=
 =?us-ascii?Q?tvDvv/crOBc1/QEB8NRd2QoKnOK8wsxjBXQrvWGgNE1jBvU43Hqh9a8xnjWC?=
 =?us-ascii?Q?FyF3zPav8ZDOPvY5fVA9u4YK4scaZQRWB+9ts2HCMCYDYHtFpYU8UYkGmSQz?=
 =?us-ascii?Q?VpGyyYOJk844tbutn6/D4KNUi8rkwEAdquS0VVh8OXvwUdDQSHlPMqheqdjo?=
 =?us-ascii?Q?VQqWaRyauwTPLTc9km09I6oQ1PzfVF0lKz13SBZlVUtfhg/a9MhAG3hI7XQC?=
 =?us-ascii?Q?DxV8+OKS/RRXHPIzrvvo9VXN3AR6Falv05uLeM/qPq440ErRegZig/wkvEgF?=
 =?us-ascii?Q?6hyASB9Y00A8GA+z0MGeOQVvI5YLog5h/7dHSzLsCz+cpfQAmt6JGcv7bTAa?=
 =?us-ascii?Q?Kvk0L9z2+sgBv4vcp13OZob6MAxQmvXfwSDbx9qecQWv6oyvlJe2Aloy8TbW?=
 =?us-ascii?Q?VPA8Atrwwl1P2dsziA31DltoS41TvhvCAg1Y8pa+pxhq7l+hwsrY/9oChYZm?=
 =?us-ascii?Q?W+WEjJEN5MyklPSTG+p0N26sER67kcUwyKmFk++cX4VGAOcjU9IjC1uX9bZC?=
 =?us-ascii?Q?JpJ8QQXrGjTFH8OEIrmZ2a9t60Oiz8oIU7ljv1bx3khHkr2bk2u8s2NspMaq?=
 =?us-ascii?Q?Cs0sRJuQ1oWVszG29En/nGuB1ppkKO3+oVGaAG4XuifMP1kbbwKg9D1uAnrE?=
 =?us-ascii?Q?oT1vAe8W5pd5S6D55kWlMM7nLVZZpDtdd1o9P39Lv5TtSZfacGjq4AZiGK7B?=
 =?us-ascii?Q?uqS59XoAzFNg3zOlEOYSG1ESTxspqeL2nYwjFCSSwr/VHoqGTsHdmZ21ENpb?=
 =?us-ascii?Q?8NCuJ/vB44TrUbru3Eop8UEZ5FQ72I52XfyST0bprKQGFe8az4UDycRpp6vX?=
 =?us-ascii?Q?Ng0hakzL+Ex7tVuQ5RG9dVHjslIqob11muui4SIm3FtPnAWKfpWTC7nibGHP?=
 =?us-ascii?Q?r9RoC8GJYRXpPhuomFSO8gjSB7G5/g3fZhjoYN41U2KKVJlz/8HwY/98isUf?=
 =?us-ascii?Q?6H7IIW1nCigXbGgY3JJUTPfkosxmHDfSoF+Tln3miuVyB18xye0ZatKCw4Z/?=
 =?us-ascii?Q?3hNNp+b5H7hBb8OsagxMeCRrRz9aDSOIJwRJgzFtjq7Y2ZjQvWEe6kYZfVTl?=
 =?us-ascii?Q?VLpRWVxqbtwRmk7LwsJoE2yN3EXF8Q1Xv9okpguyRZ43qiAy+LvZrzi+pW+F?=
 =?us-ascii?Q?Deeey6mwGCKxBwhiJeSkS8V7WfzfEQxj0CjzUs9dG404R6UWGHrMuEWdS88m?=
 =?us-ascii?Q?mrFI6Ihu4f8wP2Vv7oy3cPm2uJX42R6DL3saCVxVkLukidNPzQujZQ4hOxj9?=
 =?us-ascii?Q?I9zlr0eLqR6BEm3seYQ0KUsllqp6igWU5nyUHWjZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dbae8c7-ae69-4040-8dcd-08ddeb3eab2d
X-MS-Exchange-CrossTenant-AuthSource: DS1SPRMB0005.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 23:07:35.1432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Py/Z3dBBe9g9bUqm8mvXjMlR1pMc5sCfhDFDwT4T7bQ1XxF3dTdWXJScm3N/Z5JGuKFgEhQNd9CWoGqRjofrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 692F62000B
X-Stat-Signature: mao9ejshf9e199jgh78b3fq7a9dg8x6x
X-Rspam-User: 
X-HE-Tag: 1756940858-743157
X-HE-Meta: U2FsdGVkX1+PhQ8j3qo9k/1E51et4EW90yURIbI6ewzBBjcA8FiYcdqNQWmj22wVY81+iUWmZ6BSkiL84xiVeU/ESHpP0csTRsfbcIARwllmFb+MlMoIByIm623XYxlK48LogJwFWqpk5xsZUHfb7zU665ql30QujkI3DPlCSny03v/89zWowZ8AZhl7dMRURYG0XnUsq6OWcZgO0Ve1uO+jskdzRMo0j0A0w8bx7bdjZ1qFybcqmpaNjkeWWYgVOefgVE5YAy7DeyUwHE0JNsZ83V+TlB7RZuFzu7Y++ZCxhgt3H/7ExZ+84I/0ngOhJaM/nPNIFgZ5VgZyP2SJrw8BnXfilpVdvMjhW94sUrQEBBr5lYILP97bjGZdFdb8ObUzes9MUhd1Xoa651hV9XNNeW0nKjSL+ddKOI3AqI1Umxksc/clg2uxpjdhDsXX5O3aers+csHqvLkUbIGKNLhfvEhGflC+5iJVsTtuHopQric4HMUMyQ3VJ8kuIR5G5iKH4i+ZKK3hIqABy5ZyD87HsKTH3nrIreQtGp0lwC/hdo6oDKB/BRS/fbp0Tab7aLnLm9uli72Hr5wAROEszEepyqe7+VwiarwwB2JIx52RJLX3YQO7KrTso3FAF2Go16ZJWNyFBC6bCekG0wMnaz33LciVxsdlfRD3vJNEStDCf9EAXfpkr8HLehsY5swiU2WPkfbl9pWM0bdLKbwim2/WziWaO90FIRdXLGKqokSzvmmCy0ZpsGyY2viByJ76v0xIcamVVs1PbCqq8dBTz5t07ig+IqRPM/QFhMCsPG5nC54Km1PKeJEn+cYsysIOaW3nCTbzXd6QNzh686V7vsyAIMIuya79SeVieMIHytnActHaVLvESZbEEuaRBaJqeUqVuWSZK44qnstFlSWPBIJ2kjWA43szcAeJEdUlJ/G1HnkJFWcDaaYc0lGmGikcK9QvGaPeKhhnS3JOv7i
 NzHE7oDJ
 cXQVfJSfuCbcConX7FNml/x3i2WGBVOlcL/hyF6RBlVfOjCQjW7CA0TUKF+haMGdglm6vGvNCI1S5JWUPAXiz+teByDCC6Szyp1O6GhoQ8jHOhWtTc1a+b5DiOTwtuLyHPB/xl+gwHZ26LWcLZsti/PgbRu5nA8HU7GTcKb9oPnugSuUXw1nzARyE6i6VEtkTSE4Z0I+qJGOcfKEKi0Zlj//ARI2MbgfTOhHwAIDCmvxIrRTb9chZ3PZtUMxkcyYdE3+wgi4uqb0RGh1MxXJ9HEYqG4PF5Rzin/f7ObfaQvvW7/01RcvqEx0UGKfJz/aXSi1V7mKorfjpnCzIbrOeKLwHahZhTpZQ/k+TqtG87HOl/zxU5oZwvHbr9ETtCvwj5UgmYxUbjKurJ24HlfCh5/+aap3AV/7UsOgp6vMzICvGRhY2pz7cBOUofYaHnueWsXbbiDi56T0yNY2APu4VS9MGorxoOkD0qUDOtIqZitMM42ZbM4J2wUfAZ1JShC/crQ9ojUIQKwRgcoM2CQEfyb05S0j9ULTqobSRqSO1prJ3cmcUF+vBJj89Q9J+BNfMS0n99u0BGFNUCc8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-02 at 22:06 +1000, Jason Gunthorpe <jgg@ziepe.ca> wrote...
> On Tue, Sep 02, 2025 at 03:14:20PM +1000, Alistair Popple wrote:
> > Prior to aed877c2b425 ("device/dax: properly refcount device dax pages
> > when mapping") ZONE_DEVICE pages were not fully reference counted when
> > mapped into user page tables. Instead GUP would take a reference on the
> > associated pgmap to ensure the results of pfn_to_page() remained valid.
> > 
> > This is no longer required and most of the code was removed by
> > fd2825b0760a ("mm/gup: remove pXX_devmap usage from get_user_pages()").
> > Finish cleaning this up by removing the dead calls to put_dev_pagemap()
> > and the temporary context struct.
> > 
> > Signed-off-by: Alistair Popple <apopple@nvidia.com>
> > ---
> >  mm/gup.c | 67 ++++++++++++++++++++++----------------------------------
> >  1 file changed, 26 insertions(+), 41 deletions(-)
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Yay! This never made alot of sense :\

Yeah. We could probably get rid of the pagemap refcounting entirely, but that's
on my backlog for now as it doesn't seem super important.

> Jason


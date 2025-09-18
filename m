Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86EADCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 23:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A250928000F; Thu, 18 Sep 2025 19:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB0D8E0008; Thu, 18 Sep 2025 19:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA3328000F; Thu, 18 Sep 2025 19:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5308E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:14:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E21481DEEAE
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:14:27 +0000 (UTC)
X-FDA: 83903926974.05.DE8C7C8
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011067.outbound.protection.outlook.com [40.93.194.67])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2BBAA1A0009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:14:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RCuZ3aek;
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.93.194.67 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758237265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fxpnlvy5mnwoWkxk1JDR86chtNcnnXQv+EF7nSmUv+E=;
	b=Qo//vpkVDnUlnpHnk94j36CsnAoQ/ul2S6TSBZ/qdvIUWJOn14qXFLUTTHmRDa/SL5X7Z6
	VV/s/X5pIiSYSlEtenM0+qEz0+xmutLQLpB+hWrLKA5qgd7LIWeAFHgpY8YQx3x5C9Arkk
	A1RvptlDKyOTxHnzkgeGnb4eZBlm4NY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RCuZ3aek;
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 40.93.194.67 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758237265; a=rsa-sha256;
	cv=pass;
	b=GQdiBV3s21Nl0pD2irZu2yXf7B48yIEKCqThqrzcZRLHJe3KQswonPGGp91D2dWQVVx8/a
	k8KaroJQv5ReBijPV0qHMrvREHyyFCgtACmAmzCNT35nDwUUd2nNQbW6ROISIFa5PoObr1
	TH5ZmnKhuo7ZGmxnTuONYtoDF5C6JIo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uYgu/koOq5bnVttslx6tMioWHwys38fCiYKNnJqdDh1jJzuiv2UA7cbk9RPSCQZZU/iDFyTVMma9ltMMTdg4licEfie9T1QUXjMnAE0ypkrc2AiddMLSdyjRdFNBdx5VNaNhvd8osyYqU4jzsgjw7oyytB7pKncorej1S9YcJBFrZ6ujmw2eih8JN1q+Tqi/uPDn0ngCa9fUoygsTBKDzQIbw0i650fmPSicx7/KJAe0ipIpwDU6avaQ68c7uxMUqEKqipifZG/UrG8OvCSqaBEsJzOcLE4eDzDlWX0azNwMiF0ff8IeiXBayQgwdfP3zBrlfBxRnXc8o0Go1gzrjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fxpnlvy5mnwoWkxk1JDR86chtNcnnXQv+EF7nSmUv+E=;
 b=F4weQz9VJWJ9sJn8XjGgcdX5kJ39gMgP8Xz5a0nJaxpedB0MTTVZKeBRkdaMXclcRXoHFsJZyaYZ67uTZKtTH7gbKig0m6Y3ZbWfLhDPAFFz3yncLIzc4WCx9ilMlNjZzDWaYdLNpSk7vn1+Sa866WZ+537G2aMF8F0Vjq+OVl9ZglvumP93eugTbMQ1aMi+xx+LPzJbey4d143ArKjaE93z1VW2jPnxi1Acie+WDIjILnrMikVCBY8pm1R17Dj/9jKKXjJVTFYm6iKh5S9s2JK9MD0TJ3yjtACeu5dFec+/BvizZwiaE1YowedWmcDVAa62KdrxTeLIbwhraR5cTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fxpnlvy5mnwoWkxk1JDR86chtNcnnXQv+EF7nSmUv+E=;
 b=RCuZ3aekRqwLuT/lRtz1H4dhZfW8oWDYzrt1izTZk/tMJT+1MT8CPupcl0SlwTQr7iq08kZPHh0YbI5IGfJplQ9+9iH1EwU87CsjvilutD+73BVnpZn0co4+3vxNBOR3KA+B1ecTXhqDfEs2wHH7XmKsCW4d9f9urSsAyfb4Hw9Fe6jKNIcfUWXYg7VCtwmp952gU9loUQM6y4wgUbtf8q7sd2AL68XvgYo0laObW8Qj51u52Idpsh1jgkcuU0PC4ul+pxUJxvKcyVcpucL8rdvu5zFXj4b2g9gqMngfGwJO0G08sQme/xWhORn/dlBxzAxaJvOpw4AAgBTxTJ9g9A==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by PH7PR12MB5975.namprd12.prod.outlook.com (2603:10b6:510:1da::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 18 Sep
 2025 23:14:20 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 23:14:20 +0000
Date: Thu, 18 Sep 2025 20:14:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrey Ryabinin <arbn@yandex-team.com>, linux-kernel@vger.kernel.org,
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org, Pratyush Yadav <ptyadav@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Chris Li <chrisl@kernel.org>, Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>, David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 6/7] mm/memblock: Use KSTATE instead of kho to
 preserve preserved_mem_table
Message-ID: <20250918231419.GQ1391379@nvidia.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
 <20250909201446.13138-7-arbn@yandex-team.com>
 <20250915114707.GB1024672@nvidia.com>
 <893401bc-4754-4c67-a82a-0c49c8e7f447@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <893401bc-4754-4c67-a82a-0c49c8e7f447@gmail.com>
X-ClientProxiedBy: BLAPR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:208:329::28) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|PH7PR12MB5975:EE_
X-MS-Office365-Filtering-Correlation-Id: 39175efd-73ad-42c6-ee58-08ddf709190e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2sFaQ2uvlTIEM1Eje7tTCSNzb/+lGOOwqzm7eM4wMJ7MWSyqJ9XZlNeShHAu?=
 =?us-ascii?Q?8PF5/6Qb5SE8gG5q062aydlnMiCKGc72aGjgcxgbmhjbYVT4fTlqFurZM5Pk?=
 =?us-ascii?Q?APgqHO19cESaD6HuJ0rSxm69wVtKIFY0PP6PfwIK8Pjv/UZWqiWytbBGEJxz?=
 =?us-ascii?Q?PRfp60Obzw4w9t0yN2+EVld7kzm42Lcr0PIqnVhZ7KCtIKUnSLp6gIQhP8gn?=
 =?us-ascii?Q?vMbIfuynZcCbmbVor0EfggO3VSK9QlEezxDn620pFGjbjww8R7xsQYfJhswX?=
 =?us-ascii?Q?2YTj6bgsKx/L8QD3dLoshapcEjcXvLeyXoSg++MsqDSIfEhuCQ5psfSEpXjb?=
 =?us-ascii?Q?cOFXAndtj/fIEfes2+RwPJ1eRbSbon6xqHfMp/Yy8llzx63s7drSehImqaGN?=
 =?us-ascii?Q?IsxwI7vc925uf3ab+v+dIxKcZNm4xwcZwJeoAI4WPQpYLgpeAaeKBRAJWP4y?=
 =?us-ascii?Q?fh0+xzxZclHI/7Oc9G+gtRsuUk5x7zD1uV7E5iikyKRrMLH1i2m8sWWYO/Bo?=
 =?us-ascii?Q?YzROrPj0Bpkny/Z8ryZ0yYVWP0wT7aPSArtlUw5ykdZRFujgD0qT+g0BOg5j?=
 =?us-ascii?Q?wXOL9uJuQ41r/9j1awsTkIezPijRAzPEaI2r0fzIaTipKaO18CCOrHH9mAEy?=
 =?us-ascii?Q?/YSgQzHYOKFHJPLglpaYj8Z1S+ydW/8+mwljy8klkYp/ebqpHrXySXIZAii5?=
 =?us-ascii?Q?Ocoj2J8SFZnPc0hSaMquqFO9wt8ip2WyTBBJ97q1c6op4uL140Dfsc9q6ZG8?=
 =?us-ascii?Q?uX48P9AsCeM2XI5TcsvmuRkyj+6PJ+Y0UlbUjg1kusC6mhXSwpDxDIPWoQVg?=
 =?us-ascii?Q?4rABRWkVC8MmStNgAobL+SfXIDNTqmLnMEQK0s90eN8GTfAB4qmaM7yXuDQK?=
 =?us-ascii?Q?m93BAMySShqbuLcdX+94S7osKirOPHFUP6bCgs5RqOXaPkJlPcrnApOnZziC?=
 =?us-ascii?Q?04fJqvcP/n4LZ9yO6FFDIqHrKvvnwq9kea/u8kKygkcUZUGCMoiumwjTRjm0?=
 =?us-ascii?Q?amUoM1OkwXk00Qd0Npx7TuF9GhCd68wwyiTSGNYrpSp7+Axnee6oEhJNqAvP?=
 =?us-ascii?Q?rFqUdfvp3HxI/ViSjldLM5qV1+PrATTNAMuZc+le2prpBlANnY2aJFx+G6mK?=
 =?us-ascii?Q?Ob0ZIxWwpOrQQtGPAuBWqMc2nhUqg7o3xizywXqK1AIB+ZzInuJiMd9ZR9vk?=
 =?us-ascii?Q?goLHizW+WIr2w6iYFC7yEURPR6nsXPsycg/zlZItdu+jW5CEJ84zMKvS/++E?=
 =?us-ascii?Q?PJhZWlaEzZU2LLrZGAE0MMBm1UBxJESHsj6C3CB/dSFIzcUTLdLMN6zrmr29?=
 =?us-ascii?Q?C74NTSVim+EjBu9Mo+jvgbdiblKwRJpumbbI72uhG1LZ7QWWD+pyMzwixFjw?=
 =?us-ascii?Q?1H/eoc77gR0v+Lgu519XLN87jNX1S/mMrbfnlPItFiEaYAsE2BYgCCQpYDmV?=
 =?us-ascii?Q?TjIsxG9dCBU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dzou9WuhTbWbJQCGuya75rjNET8SHZKTN0UD/YE7l1rLfo82HIp4OdDS8bZI?=
 =?us-ascii?Q?BOcgFGz5OFeQjWQjeC274re6U0zr+XxwD8bM0RHWrhwll27vdAiN3zhVO27F?=
 =?us-ascii?Q?OV8gukxEi3ltQffC0waN+Hh5NVaKUEsM5vOLKGGKXSDq0AH6whusIa/LE4YA?=
 =?us-ascii?Q?hRYsSIJdve+SyNCTBtJn7NHlDDL2adIrU80K9RF0bWGbMAgTuemCsQjRkwwf?=
 =?us-ascii?Q?Ksaaa9g482MPxwZBcseAN40T/h3ufYwS3B2/GJtPwukn2Aiz4ODZvpS0WCxb?=
 =?us-ascii?Q?NYzP/5zeXNpKIXCbjBltnSpkzHQjHfBi1+iZvfYrU+q8wYRe+Dj6l4MkU3hq?=
 =?us-ascii?Q?pyq+Ue/bfZXzP6gIuNzTLdvWpXkbtdlM4NHF2JQroxRHAszwxseu+xy+4h+f?=
 =?us-ascii?Q?PPD5sQRJM6ewc+8YuQ0dk8qxexnHxWIjMn4Xqctki8pCDUXYz+8cRu7rEl5l?=
 =?us-ascii?Q?9g4Ot2rCgg6MZGzW8hF5KQYnNlmdmtN79YOHJbzn8GRd4Xjm5R6MBMg6+EMq?=
 =?us-ascii?Q?brJX39oF+8bFNF1fHPtcsTb9wBjpsSqCmdKk45RABtlnKxwgl9Yjm9K60OAH?=
 =?us-ascii?Q?ySlBZZjWaj3S6V30yPfUOebv2hGFbLFQZOlG4mFfieYtB0SgZz8HSQcvGvS3?=
 =?us-ascii?Q?W0q7CL3tgYgMJzoy+GfmckUDIGBCcECS9vLyrYa2NzH9GXXzPYLpNlp0/syF?=
 =?us-ascii?Q?WDhvVNHCIMQdx74O8kXXz+/YEq2I/xbMzfiZC7himgPJlCz4oIjSTuKhc1uR?=
 =?us-ascii?Q?I/s5fS1/qCsBOM0v0GbJBnwdXIMY+uf6HhakWFRIcNx5DPAqXEv1QUmOqgI9?=
 =?us-ascii?Q?2JIth04vUu87VlCTRy1VjXWXWyMp5dVA3ERy9mVxHyzMfo+R9c0L+s9FMdN8?=
 =?us-ascii?Q?2xZv/ze3vfcGbPtRYzqfXiWJzgO1BxatK4wNCV8Teq1qEnBx3cltGuaLPk31?=
 =?us-ascii?Q?xDLiKclAH2lY1krfVTlFwGgI41W+F16ntGISbu8Oi+eZQWaUkyjBb3X/BWSN?=
 =?us-ascii?Q?70SuPweTsBIvsMrWFi/diqRXa523TJ73VyZYC02FQd/87pah/t0kVFB/hlms?=
 =?us-ascii?Q?zdelrjzBJlSUziRDO94ycRBIpwLyMuQbx9mYJqVrsH30yom6oU6x9gVQqINC?=
 =?us-ascii?Q?K5t9T1VCj0ikeinmlp8p81hHsP2CL6Q6uMGL7LyRI3DWLxe6nuqNLxSy1zWV?=
 =?us-ascii?Q?uKlJd+XdlU4iHb60dNA0YCEBxXRFu/e1NQ8oQm5lz+Ziq7JM+FljFCdxxNeh?=
 =?us-ascii?Q?nB5LC8xCyTGg9qs3IXeTw1DngPLymlJn+uYkXlhS2fSryVzKSQAP+Da5SdL7?=
 =?us-ascii?Q?jGeoda7bq4ybl9njvlGO96sMuWb6vD+pVzJs1ehTyFodDLh6t+s4GIqt+9BT?=
 =?us-ascii?Q?qffhLApEI+/zAqJW4VeDfX0pnDciKLchhYvpBoyXXMvC4nchfPyYHQAPsXKT?=
 =?us-ascii?Q?rRKtSKvwzACnvuPPclcA48lCWVzS8H2HdoB+3yvx5Y9GtuEsa9CMKrqnZV0Q?=
 =?us-ascii?Q?EKGxU0RaRUzpp9tfXHEtGZ3RVwvyxypoQOtcLe2dYpCUxG+IZijkfy4cmQwT?=
 =?us-ascii?Q?u60wKYiNf2HM03NTYtDIRT1z796KuEhnFQWZ4Vy6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39175efd-73ad-42c6-ee58-08ddf709190e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 23:14:20.5819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJfg/8Wf2a5KpQ0/NleD3PUV0WffnnzFmfSzWSwHDccUbtWf/LLz1ZF6SWNnhtSf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5975
X-Rspamd-Queue-Id: 2BBAA1A0009
X-Stat-Signature: ms7bfeoitf9wggscrh6oj6iorcntbcud
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758237264-912873
X-HE-Meta: U2FsdGVkX1+kmiAN4f8EMucBJL/lMj6IhdbQbfNvVBrjJ4aY+hlXGm19D9iTiImqTVktajOQ+kIKlNJZyVEp9tpKKpxq8JJZM9qmc4VVJdiDeVjIXLT9i3VqpuKJQ4+Sdqb3XGcJmDao+O8h2qiMCsHXfnpF0fUxhg/wP2Xya0ufUqoYw5JnzFlnEa7HwGlQMb99SP7v36VNgbTiB9eEGiYN1jEX59TaxilGgaD6CCB66tXB6ZrprP80oneN7glsikUez4JL5jVVQ3/wPbDgOcdovUOMi0ltHOHcNjDu92Jr4LdEYQo7poNuaXrzgxBm+jiEUq8V4vKdktulq64D1aX3nBBo/0GPkE4y41bX0iKjeKUhfQ4o7rAG1oRtxsoOGjYLDfrGn2qfqcR6+Nd4S3f93ChVZKuGdtbMj/o+bYlE+6TtJnXeANdY2bVtrPV4H9Fjxh9Hk/4DVqMhZ8KaGLMrbKYw7fF3jaI5JQ7TQsqm3S7IKtPiCCWYladUlZYxLRK0DpLCuCWaftPxtw3VgKumagoG6ysznJeBj0GumXe5pbHv4bgnyme/uv/zkk/KYWW1gjQe8TwvWatv8ypUIQoMjz+VC/pXsvE8KAmUZS/o9cudklwr6chU0LK5mYLJVJiASjhQ4QZj6RGr+YEjPm8zmvA7UjhLeTzIl/63PSBkzPVsjkj9X3x/fe+/+X6C1W77KlWa0mOKbpFNHk0v3+VdE6YPoXxXxKQvT/qzlU6WmaK+ZZH34huBKExYevuL1vC1vVfsm6xncmEVf7tgdf2q3lWXu76y8ZST16xj9GbZTzD2uJ6ejy9ae4FnW9dNgnk+4N/ENvPkYbbNBn48Sk4KeRts8YxueECziH9xIMkyJYocaakVTsLM0XTvE8lx6AnWtTLorDvoHLvpkAuJEH7XRgUJkPNrkWmvsXnkEeRgcncov7Mnh8rXC6Lxnji/YbQ2gULI9JJcbgWIqBZ
 gXqNIRVb
 yp42ivNnTLSF14UoDI3o/h+bkdOjiJklEEsJMQIZjUkz66VIosb1SYLwYvSmgrNF/oFyOvq3YlKpsTuhRlKsG7sBxut9SKAcKrjkm3hCsXV9ioU32mHZN7C7VN/JTsA+l1vg/d5eAm/HMBW/qvwv4DnNtB6mvtYoW/YjWtcLImYapUL/VcdHUNDF1ARl7+EmrgdAkFoaTKPv7Ib/aLo6tCfw+j6iOWFMACHemM1Vqm7yjWa7IEa0bszgHFash4jnq9zlOkofkVbBK15tuByQ7iUtluUvTUeI2FD3zdCMRCjb/gxQ44o7xlpPdwYOyTLVlMp6Wo4X5fBkmGF9St1FyPlaSOrp6mg1zpDcfSci7Gjflt0Wce/3ZvGwYfCLJjNPJiaMGT9UYLiW3LrMDB/B2BI+Ieo9gha8ksF3IOVury+PHCK3xKf8hB52zhLpdbk2dM8mSwhIvYOGV/r/1LACj5W35FPxz7JNYxIDRzxFrUfgYSXzZPZ8o44vGa5opdWe6Sm73tM6P/cXYxnQLUUxyOS1CMEdPBFsvRQanVwdFUvC9NGRAIqRvN9FSKuGBxd2cSzFEquuhoEHoBVYVHs9jcu03/Yvv047CCNx9pZJ1C33MoOE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 09:00:31PM +0200, Andrey Ryabinin wrote:

> By contrast, KSTATE centralizes this logic. It avoids duplicating code
> and lets us express the preservation details declaratively instead
> of re-implementing them per struct.

I didn't really see it centralize much of anything, it is just a long
way to spell "memcpy" the way it is being shown here.

I'm all for consolidating, but please do actually show some
consolidation..

> On the versioning side:
> With this approach, introducing a new ABI version (say, abi_map_v1)
> would require us to maintain restore logic for each supported version,
> and carefully handle upgrades between them.

Yes, you MUST do this. It cannot be magically avoided.
 
> With KSTATE, versioning is built in. For example, adding a new field can
> simply be expressed as:

No, it isn't. The code still has to process versions and still has to
understand what to do when the unpacked struct didn't have its fields
written.

If anything it is making it more obfuscated and complicated to tell if
the comparability is done correctly or not.

Jason


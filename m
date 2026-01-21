Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E4FC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16D96B00A2; Wed, 21 Jan 2026 11:35:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE2A6B00A3; Wed, 21 Jan 2026 11:35:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D01C6B00A6; Wed, 21 Jan 2026 11:35:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE926B00A2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:35:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39B5013BA8F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:35:16 +0000 (UTC)
X-FDA: 84356521032.08.AB548C3
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010067.outbound.protection.outlook.com [52.101.201.67])
	by imf14.hostedemail.com (Postfix) with ESMTP id 68D6310000F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:35:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SDuAajEy;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769013313; a=rsa-sha256;
	cv=pass;
	b=H46AwE/+VY8gkhTtqhUwxP1NLc4mBVj+RIanCiTVK5Ozlp6xHE4nGBIBmNz7YtsQz3fct1
	evAUbyD5gtyOQKnPCyl7n9U3riTwmugKsX91Rg0YoZ09vA5gwvwuN6avc5wAJvFmMjV4Fs
	7qxYSVd9v/MLYE1UmntOjLNtRRo1mh8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SDuAajEy;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769013313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBC/PYxX/XQmOTgeMrxpczbtbL6ugmfcD1NwGeTcWFo=;
	b=paNjNp4/KPYqzWLu2nNTdxdNWrXpiohlTfj4ZhYjKVya55HvstBmEXnFS1690leQVocYmf
	4lK/d74G7IpybJq1cKkXqUZRh9em4zYQNg3pH3WzhdeJxblEpB1Im6tGxioxSlhvw9iCqs
	w7DXDuXRKtJSPCKnaArlG/lNKTUVXOs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YGO/2tTyEt01n3uFr0jzG1k7YZEICi0NQ3/TYHdmIcKIvm3DZRPw5cZn7XN7qs/2NUsugypAmXeLNEEFpLc61ETHgDSRcLmOR8twe/RRsU5E5ALhSEXTO448JCU/jLBQvdbl2+AfE+6iTAcc+iFjgAD9krJND7WiDIqKNPwSfc8PHxufv9/SMMdjfgDi15396zxfUF2bXy2YElX/IAJDce2YDORvskYuG0iOKaQ89Kmy18BLr0yBPRkJz8BNYlmI5TtCkXsS1pGu748cl99MuA66w9Gdr48o7DIc8yocqp+6GjBC6B/H1AtpT6IMtvoSuCOXkktJIlN1kQNO3qlITA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBC/PYxX/XQmOTgeMrxpczbtbL6ugmfcD1NwGeTcWFo=;
 b=SvVn6cc1G7SpXnBrXuNwW87sHm7qmVCU5vFr3r/xhsDeABI+8+2FINTsMXU0OaFWhcRyWYg4qgSkmkFZMLLRdCvfH/V00AW+8bwdAEdFp3HTYxdP9YvT1NJIhruszYd6FA85jlJ3kZZGpwWMnNZ2Hmez19pUMZ1FqoqFMvFudLO2T/J9YNUQeCYQr+EFqSJ1d6plvYd1ih60Jp7FY1NuVYXp4jBi10p0sax1wjLY885X41vSUrLNmPlvEcU0KHqa5E6DrXOaXSs3boHanxLqVE/yMyaiN/YDIQGbeUfWbksSMaif36om9iWynt1x8Q+C5duCVQRaUs7HyY84Qmks4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBC/PYxX/XQmOTgeMrxpczbtbL6ugmfcD1NwGeTcWFo=;
 b=SDuAajEyHxBanNb+wevKGvljXz2KhdZ+ZHlPhC6Mct9EJXh36P+0ZTrT/qye4HGXFR4HIi1Bcp+a+27EX+e86WuwoW71WlLCNXqa+EjRPENhNqmhjM3hGAU9ZM+DJyWNS1F21vbOOx5X0KmiM2JQ40jkoIQXicQbsxA1JJhEG6dmx32ZEqpDuKLcR7X3tGY32TZ15DcNM4n8cu4IVzBkiDo95dwdm6dFVXqzYZEVC0CecgwXv8BqaFHsJRiKV1v7HZ0Ut7Sf18zfy0Jo1KWE8sVMxHGb20B/usL3uyGlbsdNL14Y7Rbb8mfOkl58++KjecDqaZN1/lxheErs5FV7SQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS5PPFEC0C6BDA1.namprd12.prod.outlook.com (2603:10b6:f:fc00::668) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:35:06 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:35:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 03/14] mm: Rename the 'compound_head' field in the
 'struct page' to 'compound_info'
Date: Wed, 21 Jan 2026 11:34:57 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <AD4F2D9D-CBD7-4751-B00A-4C832D17E970@nvidia.com>
In-Reply-To: <20260121162253.2216580-4-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-4-kas@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0025.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS5PPFEC0C6BDA1:EE_
X-MS-Office365-Filtering-Correlation-Id: 32619080-2596-4dd6-2484-08de590b089c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iUPv3QL8yxdIrFH3SAqd7gbp+BZPPW2KoQZkMXnNa0GudNPr/LIqE2KbZV5B?=
 =?us-ascii?Q?TLorfSkR8clD5UljFKlu5Wj2agNnTKZDFaw3Frfy5Be4zJXu0VnrHb8P7upT?=
 =?us-ascii?Q?n4Wjv82LAC0j+Ys9pJ/jo3KVLd9Zq+RbK2Conby/574oJe7XwkGZpuHva5dl?=
 =?us-ascii?Q?BR7dQ34nYcPYVpeywsj4u8H7CHWGsgxaP8l7BR7oOXgnW3KSn2f24v37HBJP?=
 =?us-ascii?Q?gADGNY3yU3mBh4x2zDjvd3+5K6XJLDZzKjPEb2MxUuvaK0ZtbA1/87V+KO2P?=
 =?us-ascii?Q?kW7Uon25rYL8L+9Z5JfK95U11CIPPtQ8pYM6+zLSCTp+WKy76qWGg60TtOfg?=
 =?us-ascii?Q?rFaHgfM21rrIWjjMFI3kdB2DV8KWMgburwDBW/SvSPzacdxakSvD97wx5SqC?=
 =?us-ascii?Q?Xb7cLruy18+dPpYkf9rD93nOkTnIvXM0tJtMG7G94ZfqthpHgZWf5aEEHbJT?=
 =?us-ascii?Q?cDnLwg0kmU6kGj68Vos0LpQiq0cQHiGeqTgLpFsZUific4yZ6M2erPVUg8wt?=
 =?us-ascii?Q?GBIPIhpBsxMgJ40bR85fe/N0WgyuHurSKjMgOWjecKIldG6lJzWSbMk4Dju8?=
 =?us-ascii?Q?PkUBko09OXKOmx80Vyl3GQA4jJaOx0wfn0APEBwJ3ASdKxUAZuAgD2jlWRud?=
 =?us-ascii?Q?HVhfa0Gv6WfToQkWb2m2IwZsDDN067Wl3d2Tju9vNYlEVIxqbNBmOYCd+w8y?=
 =?us-ascii?Q?vvTA7koSuUISKIoIvDT7RRpUEElqAD8KeeRudnZ2cbEpXv14yPv+MFOwmnDC?=
 =?us-ascii?Q?upU4wQTIYPqW8W93YEOng2H0IMQNRdzkZIdir1lh3BWaWscDpLGds/yMolPD?=
 =?us-ascii?Q?B9gKNbxfMQKMXO9it2noBD1s5hTZmo9xbASjrJc5fTJBCur8Q1w5MFp3OC5K?=
 =?us-ascii?Q?E3cXSZ+ejr/ek6ilkTTy9tb7A7p72azfpZqDdYEGJ4PL323lIuVFilNOPmgj?=
 =?us-ascii?Q?P40XF+QUwqwoZCebjmas1IdQNclEyFxJyyTsL2zVlHR24knt4K6TFXmjFewW?=
 =?us-ascii?Q?XHq7SSur53/JlsoqLWGGn7oKr58X7a+81WX+IpqoTBhsJiZeyK+7eW43RHUB?=
 =?us-ascii?Q?uMZO/4+ox6zfxRz2hJyqRWuimPKtV5KyVaATHaNgM7JxNHc80oLZCUT4Ay0P?=
 =?us-ascii?Q?ZOWC4dUT1fUmNx9YsQKmwnjAW9GT9cxZwo/ksvsFh1yqDRrIz5ZuFTLajH1z?=
 =?us-ascii?Q?hjlFMyLbmoRZhPJljMONX4F2MElmQvJFuwE/go1rPQ2bKctVM6D3o2Y33Yab?=
 =?us-ascii?Q?QofwCVCtKy2wRhQeUiHegJHA3vitU4vgH8GlkyvcGjjQQ4N55NA8jHZuJOk3?=
 =?us-ascii?Q?uaHY4TlgOcnReqXjY3T8O9hcWK4LEotwwfURKgjj73T8jqbeMxokEkTrRIVj?=
 =?us-ascii?Q?YLlSeUOzhd6QzjRb/3JuchYOUd2TXU+yEwqgTjZY7VdfrXQz2qV4rr2WqqVV?=
 =?us-ascii?Q?Iv4PQKiw2SqDCE87OndnmXOg9ymOJbhgTfTeZL/HWBCt/Dnh2hbcE+fCj2/g?=
 =?us-ascii?Q?ymkBYSdfAclDc/FevFWMa+dXOgHhMiXF4uUNddFq1rg7c4t/tAWnj54UtHw0?=
 =?us-ascii?Q?RCsiEyWpeltSlX/2eWQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ffl7d6XRvffZd9NyqLQGcZD1U3GspIIOt0yxYEm+q9njRwZVPze3WCsse06t?=
 =?us-ascii?Q?hho/3K/g2rfrR0FgwDMwADUSoonUdqHEXWEL4K18GHbtNmtmQSPW6jjEyLuu?=
 =?us-ascii?Q?phepz8DN51EVgUSz9N0pDnPA7ejLwACULT6ZFQVnMdH3csGZmntKvwgOuRTm?=
 =?us-ascii?Q?v/57ZFsTPFC6bJ7gMUVx3E5YFJY5i5W7ggVViwkrX5InocRWN4wPtdE7fJgT?=
 =?us-ascii?Q?CMbtaxZI8By4TNSOhhJ4otuhJ025CFlJH5B/i08nqEj4581MHdYPOuv4qXMa?=
 =?us-ascii?Q?U3H3kgZ29yLo8SDH9rZAm1bAwdXfJiolt/kF2XfVUaXRsGQLEUnTijdipS/B?=
 =?us-ascii?Q?qij0isAavAs7rxma0/g5R3EJB6oI2bDnmVRiQT+luDVetEEpkDuDELlzsxlE?=
 =?us-ascii?Q?Kkx50L6VpDaT1URu7jilZJgZ79vgi4PqiH2YalXdhnXCoEbsC/+1c+bmuyGt?=
 =?us-ascii?Q?dJpRg2CMv6qC0Phlos15MNU3AHibsNlLBXmbqXFGaxmYj5e9OecNKPZXvKZs?=
 =?us-ascii?Q?BvWRJDaSAzUdU+6zXEe3XSOQy/L65RA0lHYB/iHSWPBuLYNv8ugm7wX+/74j?=
 =?us-ascii?Q?BjKgemCQ/NYgK2W+wKpm1Up7kdPZgKxN3raETvdkS4FbsJvIhQZ7WMajGGQ4?=
 =?us-ascii?Q?ePXsU67BmZa5PBDuKTou5p2Owoa2ViD1ey1rbuUJ5yZdmUPfz9ySxJ75u2Zt?=
 =?us-ascii?Q?8p+9JqS6OyLv7UyaAgVIke9otDZaEOlhQitKoIbPiW1Ge0+QSEoFq0dukAMF?=
 =?us-ascii?Q?za5dXKCtbKYRAOSEygF2TR6nGY0Icafrf4Org8eS4zYbJpPDwtLOmQY/YyGJ?=
 =?us-ascii?Q?Rz5oaOMZSBA5oOsS5SBKVM2GWkwUfyJPHfgRuQDzA9VTaWe6MjAg3LF+ErIK?=
 =?us-ascii?Q?8JCWyDIhvDP4Wj6B9jJ8Ahe2Qk1t8oAAUIcR3zFlo59i4t5qMS6f/9nvyXar?=
 =?us-ascii?Q?+UNEGdUlCTxfbvlfmiNpjqVf8I7v34Gi29hRXn6uj0OgNaWOoTqU19yJX0kq?=
 =?us-ascii?Q?DbyK45J655VlSWcJHz2gG/iW3jBPof/QO+/uQ2jc3Trs7LoqeQw90Qyhr4NE?=
 =?us-ascii?Q?pBxLzvbznbiGGja/oi0crA/obrUG8scmfQtjHw85QX+oDRKOJvT0UDCVleWf?=
 =?us-ascii?Q?sgg8uO8hpk2d7YAMpfy9Y0+bMc1bQE/HQ8bj9iZRyY+dXzH9/Dnnrecy3VZ/?=
 =?us-ascii?Q?Q9jOBwhg3u5gjLPz/cjzghVtS2zpPQWxr6tCd8uN2fcD99KEQQVdNbDtbe2K?=
 =?us-ascii?Q?NmMlcELAlNpAr4PohzYmqFeTQTzmKLgdoSinQyikVOW3cI1LY+wnnTrzAKGC?=
 =?us-ascii?Q?IwWizKiLLMpP77Ac5MGCkktqJljXS7rxOL/a6y49E0GtNvFz+XRJgvKIsVV+?=
 =?us-ascii?Q?jJsOfAl0dqVvrIfIIroe4x9dkRCzHBcDrCrrZFw7D+uTNXNbSlnoi8zn6sAh?=
 =?us-ascii?Q?uhZuQz/Nm1A+WgnVLqIuYATlGgcSuFEsGUHxwpIwcDRzGRIAncnDQwrzP6Zs?=
 =?us-ascii?Q?sA07QzzOPZIp1EnLySjX+5+0U+HwAhcz/Em4Oi8I8ZYg/DQq5iOhmFlcY9D4?=
 =?us-ascii?Q?4w7WsJTuaAr43YigjPCUBPZXAF5kL5I2b0CWxCUtQrZB2dJHIzk2jnU7xwVk?=
 =?us-ascii?Q?0/GlliJ58Ozr/73cv0nrrsBU8knHz+qOekK+9xD26NqlR+r2zfvSJbj1LZ97?=
 =?us-ascii?Q?K9O32ZNaq5NPc3iR0d8LO9rK5u2x3QKEa21GbEFIe5zQaMFv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32619080-2596-4dd6-2484-08de590b089c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:35:05.8622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUsOR1Ho25waK/7elpZLvWEYXHMQPouquZp7eFcjWaD/jGkV4wKe/rOeLmRDHH35
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFEC0C6BDA1
X-Stat-Signature: nctstspd6u1h7dsia6eseptro39p7czi
X-Rspamd-Queue-Id: 68D6310000F
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1769013313-153776
X-HE-Meta: U2FsdGVkX1/w6N4G7jjwRuNtvMjJhz0M2xrw0Jhw5ixDCLHYXu5v7OTu2hgpr2Q0OikZt18o937sQ9PqhNbKE7Tac8bXV1Ey43Dn/VKD17in5aksAJ/KIuBU95j9PDJlJlIhcO694JCW6VM+ccc9nO4n5WDx+1N3tj29UTRWZEw9ZPg0WRxDmQ/+/oYO86C35sh4eOuNIlODk+gvmF1KL0XN5b5o97VXhLrF52okHvGY5jtp+efkj1RhU+TDKz5+wD9Mg5DnXsqYR/LI9hUxvv8ZYJKJfO02UpyGYumqDYSo0oeR1KqN5gOl8sYBGugxT4QETbFf15aR1xDGSoEvm0NRX4qeW+LiCJ2vYth8Wikv6Nym+ZWivOCNB4ZtNqfcvd0h6HkLazudhEi/5tsivOm25j2t5jVSHbN94wqnl5JW7N8WpQ6SKq9YxSH3YD8Yw4rtM+6cqhoNjXBAwQwk/99DRijthz3kH1nAyiX8qQCEgyK1m26d/2SNeSKcxdAS+vvnSzb8tsRNOeUNfC9K/vgejbi7PtH8ElM0vrMdJzKnCjoozRmWLos+67V3tQb+R899WjsFgrANr9Ky8jJVsXiY/scnsaCCSXpM6oD0dt8MN5kwE9KVzRjbL4yu7RUfKj+c/4ZHFXVBxbmQ8nkrxGW3c+sksj4STzU1uLZEFwhlLUK3imWIGttOWwpQcH3SqW8/GjS2koYdGC1D7Zy7Zb9KFPSDbczgZqdrJRKKr4lr+mLGs6DsK33O/sI42H6wdMefzP3xjbE9NMtyzslKzfJh0O762DBV7P1Jwp6CsLkAd4E9yaxswf+1hDJXEP+7SrcZaxDy+ixzxDMlLP0kQ5lUhztQgIYUHiOi8N/YQYc2D+YnmOKmzM8NkXY49siJUH/exN8p9kiRHfMyQOPYJkHUkZVRvgte5GkC/e5MB9bC/Xv6abKNV5qbeRST4rJoTWjDFAcCXtSYzQV/b0C
 Lgk4FHw0
 nb+7LDERmfgj21uwfU6wLapIUhs563WoAWSjS42bVNmymk92Mh+e+kbNUYGSiNBf+BkLaul5H57vLgJP5Yjrr1DpNcQlm0d4Xwg4hMYqKOS6am/gpJjImsSc8g0qiFSp9PpXIb44ky9lz18oyF+F22wZ32dm0NAo4qdT97BbnQx3XzaDFivILxzUGKoHhmGCxYZNIMvUmMgGa7/CN80w4F0vdIgatqih7MUi/1q0oo6t0CPdKJ4wGjlbgZA84E+soydIuPjUjMODXuFNOBLFxG3bzC3lKGG2H0PoCEuD8aRksPTXxNe4jyxtbjM/gOO2si/Vb8lGylF33ddgy04JW+eGxGNK9gxMCSb5C2LrD4EC1HiejsVYWNJZXqM+gU+XKoXObJGoROXP6IKcKC69XF3dY1fJzKgdTG368
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jan 2026, at 11:22, Kiryl Shutsemau wrote:

> The 'compound_head' field in the 'struct page' encodes whether the page
> is a tail and where to locate the head page. Bit 0 is set if the page is
> a tail, and the remaining bits in the field point to the head page.
>
> As preparation for changing how the field encodes information about the
> head page, rename the field to 'compound_info'.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---
>  .../admin-guide/kdump/vmcoreinfo.rst          |  2 +-
>  Documentation/mm/vmemmap_dedup.rst            |  6 +++---
>  include/linux/mm_types.h                      | 20 +++++++++----------
>  include/linux/page-flags.h                    | 18 ++++++++---------
>  include/linux/types.h                         |  2 +-
>  kernel/vmcore_info.c                          |  2 +-
>  mm/page_alloc.c                               |  2 +-
>  mm/slab.h                                     |  2 +-
>  mm/util.c                                     |  2 +-
>  9 files changed, 28 insertions(+), 28 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


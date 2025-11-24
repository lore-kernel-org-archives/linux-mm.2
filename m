Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BF9BCFD31F
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB1F66B000D; Mon, 24 Nov 2025 12:05:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B631A6B000E; Mon, 24 Nov 2025 12:05:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A7F6B0011; Mon, 24 Nov 2025 12:05:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CFAE6B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:05:38 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF418B9C5C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:05:34 +0000 (UTC)
X-FDA: 84146126988.13.5B327DA
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010033.outbound.protection.outlook.com [52.101.61.33])
	by imf24.hostedemail.com (Postfix) with ESMTP id EFF7818001D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:05:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sw0hSUUc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764003932; a=rsa-sha256;
	cv=pass;
	b=DBEdiWkDX/+Yw6/SqevJAddiXO3y0fpqliUZvCp0sgdRQnVKY/Bg1CRCTRBrEeAOQoYjUH
	9UKhXs3pMaHbO+lIHQ8rdItet/MMAwsEUFZikprD2FSPP9rtGpsdAE1a+hoRybYsaDdEna
	39InMSRQzTIQH4yvIFML4VH6EWsLZd8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sw0hSUUc;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764003932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdQHL+L1ZkRpXkLYDMUkPKJDbJby/ff9HzCYwmiIHGE=;
	b=iCECh+GPgSd91ra7upOCvaeDQ0Ah4WGPePLFOHm6xo7euXGMjQre3v6w4hSJnglP94QPas
	s7dyzcVQ5R3mTiqnKjbbkRVpSVtIacMVEC4SSlP0x6yYL1Yp3llytC0eCHotW4HGPsc69o
	hGcO6CBPBnyL2RBUTnkJOGLAam7EyVE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M5m5Tx3l+ZarvMxZXbnJ+5BYBbsbWEI7pjPUKDHtOeakE3qhLCa/24HNl+9/5w/FkqlldhFDjKQYnJtE4VwlXfi3p2Bx6pLBid5Vpn1E1z3vxfz66IX8/ADGkHIlsObQtEtFw8LJdJ/hSSux3LfVFgEYRYAkLbw8kHxIGOt3JA6byjuQuROfQCQzvKxA2lnfe6w/PcfhJ1xsuY1uB29U/JY+MAjtTsjZC+Y7OwTADwgJJSU+Yjz5YGeVKpEs7OwtfMWIPlPwDd1MNXytDdBfZ0vbXVyzRoSfmQWR7U9lHXMuD+ylKjKdZXALjlI7d9dJJ1qA8MBmMW5cUF305GogIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fdQHL+L1ZkRpXkLYDMUkPKJDbJby/ff9HzCYwmiIHGE=;
 b=uzck8iQ4rmHNsLnhDDwLubHLMd8irxIeN/zd4duN7iXCUi8xwl9G53HxbGfactTLYaSrMADnXGDVB5Hh7PPs/q8GzY4Xjvdd8/UsEVcIAtQUet8e826FkCDKgpR5hDbPZzo0LmVZj+E++6AzhsbVGjoQS+FhgZDO3NWxcRVYTHZs/0k0fb+urYvjt7+/RDBmYeI1Gi21juvON/lmatGYpBjUjO/9kynoAnVBb5Ay+KCRG14GYqs5I5Mnxec3wDfti3+pk5FxJgOqaP8UlwWrnnyoZxSVZ8MqGlU5cf416IlNQdObOA8UtuwY2AXC+eSp6qG9KxWX9ZC9ZFRFFz8gZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fdQHL+L1ZkRpXkLYDMUkPKJDbJby/ff9HzCYwmiIHGE=;
 b=sw0hSUUcMs130Y+bbCPdI8L/SMLoTZ+tObf5tVgqcOZsKqRwqkYwmFZ6PhCluyuDRUfD9ssFVaU+H5+U67/oNgrPzg/1WyY/efNlLGc/d2qE9FCFlZpL/9U2AkICZOOSXpYtjIn7ef4wcNoeDG5J8F+WeZZvXzZI2C7/w1Wq4NIMHD1EdUhLybUiM8Md22UjTptJmtdSwFhVN7bb+o4H+lL8KYb12rihUDsL08A07MoVK7pVq73VyrHv0zQVpT1reSEyZSTsJFcgzdZmUCjPmaDKyth5ab2Bj6d0fkVTBV63Fnw0ACnxtM2TzFssLz4n6s16OHJxYhG3NPYNBj2awQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB7594.namprd12.prod.outlook.com (2603:10b6:610:140::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 17:05:27 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 17:05:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Wei Yang <richard.weiyang@gmail.com>, Balbir Singh <balbirs@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm/huge_memory: replace can_split_folio() with
 direct refcount calculation
Date: Mon, 24 Nov 2025 12:05:23 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <33A929D1-7438-43C1-AA4A-398183976F8F@nvidia.com>
In-Reply-To: <df92a886-069a-450d-a551-dbfc3f629ead@kernel.org>
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-3-ziy@nvidia.com>
 <df92a886-069a-450d-a551-dbfc3f629ead@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0185.namprd04.prod.outlook.com
 (2603:10b6:408:e9::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB7594:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e9f1de7-a467-4db2-7ce7-08de2b7ba982
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1bdR2g2ditCirGXZ0gzqWK+QF6/eRcwVHQvObiFgYx7KeR7oiAkY35gwzzEL?=
 =?us-ascii?Q?NWhoZ+MF6jRy5uflO/xEJFth98WJwxysg+IMJ288+AOuWljLAXb1uqnnXFgF?=
 =?us-ascii?Q?eZQ/TC6MKM6Btvm5PNu+KLopz5k0BBidCPwRmFdyHd/Sbd7UtbyqHJTZp/eu?=
 =?us-ascii?Q?z7c7u39N/omvI5AePMKCqpCjHsFvbr9VDFYDyvA3wTL2wx1BQGMo5iwKpePr?=
 =?us-ascii?Q?e3RKK4oM0rfPQS2oD6k2s0Gb1SVKsk7EfFGLYS+SChibii/krhGja3vAGZ9u?=
 =?us-ascii?Q?W0+g0ScLld6whOan2jwBqVSnyrksYzNFwQRt7YvdR8e1reaWrQ17ihmz3VgG?=
 =?us-ascii?Q?0BrsvoXR4jTJq4UewUnU822na0Qkh7C0bALP0hy9F5NkioKfYmfHIwhJiTyw?=
 =?us-ascii?Q?4zkVgWNiO/a12HItA/zMPJUUtMwkzBt5nh67D/7t179NL/FodGbGY4M9D0WN?=
 =?us-ascii?Q?nYTp27uVWSjO/XGVR8l439ND+EIkZH19ikswV9anrNoMe6ujOBiSkZDTCvfu?=
 =?us-ascii?Q?t/Aw9nvIANet1YWwM/WGWnvMDQH/iXxXjObNhNc/TzBnjQSErjB/9cQVuvdX?=
 =?us-ascii?Q?IxoISvlxt8iFw76oFSLIzYrWlo7PTsC+L66wSa/9QV/rLkNX9z1/IZA2bhXv?=
 =?us-ascii?Q?FkuCH/q5KIJfWXpXhj3vtHmSRMcGOKRLNqybLTXTuM06UijyT1Zu+8I/vF8r?=
 =?us-ascii?Q?LsHTYMRSL6gb4FIOSCaFD37W47UD4kw/4qQEtynPvDvcPyG4gxj9eQOUtHdX?=
 =?us-ascii?Q?ltb3tCI69zo9LaXv4M6NQdWGGiwy9j/P38+knz5OyIxg2F4X4Nts2bGA5IXD?=
 =?us-ascii?Q?mwuWTWNjZ+a3JymUDffJOVrkj59dU9kidAvXzgihwVl27uhkSecGDSPe75ud?=
 =?us-ascii?Q?zoBy463FDSoLWt5WRpjdt3rlCpn3Iy2nHuf80xM2hYnMJPaC5fNPKm3JCkLT?=
 =?us-ascii?Q?PnuBJ3XS/xlVqTSJqCBOmyEZrNqsB1ELt7kSkEhKZhBH7N1B2+s4JYOijhnK?=
 =?us-ascii?Q?4kOB2X34hl7SN23kR8KaJZ2JOlN6VmI/PBnP7UhSptfisXDYM4i8FLXRQtEh?=
 =?us-ascii?Q?Do+sCcpyAgxVvIrD22GuKu5Zz8nc/8MrjaLvaCaNKY5kxR30kyOHQGNFuft7?=
 =?us-ascii?Q?smZr1cvxrdW0jcpveFYUF8+3uBa/K9s1SIvxTmktzEgh/eW/Mw0uXx3fih3j?=
 =?us-ascii?Q?OX8NIJarsUm8++7gYzVx3zUFJ1113K0RzprE2XP0SsAzlJ6DIlOVQAlyj9rW?=
 =?us-ascii?Q?XrZIcf2xGPuHXIokyW4cPWZmyzSHOiBBrQnMa/PZ88rqqilzexA95WZoLR5l?=
 =?us-ascii?Q?a5YA0GO/eA8irvkXBq5dqq6eu9p6ZU3QfplTDPd9Kq+V1ZST0x62hsuoPz6u?=
 =?us-ascii?Q?OMOkz51OflRaQOZ4uy9zHKZ1WtIRULArbUlfSlEdrxWwsWrnTBtEowZjqeI6?=
 =?us-ascii?Q?xGw1mj81AMSpvtWwqjwi+2FlbAqsM+Cg?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WzR6ozWlcFCmSWd0R5CMIw6czStM6oT191zLmBdcHnBq8LS21QXfMCFINBuK?=
 =?us-ascii?Q?QQeBYzYod04RxjJXJkvju0E1KjA77Bk1nYwQitqkXBg9LaIcLcigkXiXh8fm?=
 =?us-ascii?Q?IGa4ArdyTG0vIVJ39ri6kuaanVQtG62kI4clSVVP8D6EWts54G99tt3RRQl9?=
 =?us-ascii?Q?J2YSnNbtgD4OhV6fJaRG0LNN1HEBHJLJEo9seUGG5KAAzo4aOD6LotskbTP9?=
 =?us-ascii?Q?4qgfVoyMUYcaC8rlGbJcECFbyxvD3gxuegUfqDBXtFSkSeuy6VZEPk8YkqfG?=
 =?us-ascii?Q?4YVo4Po0jXY66QlKeC1zgQ1eYLDVzFIIgAi6gfxaHZNiEFwBG5Sij8DEfTo2?=
 =?us-ascii?Q?GRs2MjiJ+6N3sTJnYQ0LbaF59K2MWmH6+pDOLRc5bizBsg0IdOfLk1r1nLqU?=
 =?us-ascii?Q?OdugrlbpR+k9IiRLcJkXYgdTqZHfYLABdFCcKiezqlEdgR3pGIDnLPuIyo9k?=
 =?us-ascii?Q?StpUGSMcmLT0u92ODIvYdlCi8iVG32UxlQGw82CkgfYF/+O9iBBAGKObgImK?=
 =?us-ascii?Q?hGAKD81eZNd77dygj6JEyyYhd6LJpVxwJ/ImQMIxVAUp+nuNPl1L+5iidpUc?=
 =?us-ascii?Q?nr88rchDGZWNFbe/oAquec95bkbgWQ5x/RCcFg2hxEBD6/f8ioE0gjDESFAg?=
 =?us-ascii?Q?2o0xC5AtGPrl5M5qHGwf2R7YyMF+/M7bkC58zIfB2kaPWwSPWWBVL102gzPd?=
 =?us-ascii?Q?N43V34rpdb5iK0WPwWtUvm/bq57RyGKk6ySRrrg/fJCGQUb5S7IV37GhV2Sh?=
 =?us-ascii?Q?zf950PNMbRRrXMZHQHHHf8RMrnEs8NNZfLWMOEm38dRfx9EHGjHRssbUI79I?=
 =?us-ascii?Q?IOxttVR0gpFIvXCEHR825Ca8GJ4OBsPOkxf1wfunuq1Ri2IXOne1oc+pFUcg?=
 =?us-ascii?Q?wY/Q4KpYeD252VSUt3mlm+h0k6QKUOLvGEQj/MdPlgTzfxuxyLfCLLgmXd/2?=
 =?us-ascii?Q?C28y0O5OPBdPHlSKG1BQGfDk6ui+6/HE40ebZAmA0Gn2rgx966JAIqqDMbpT?=
 =?us-ascii?Q?uyhovOXq3GVd3yumlPG1tkquoHUSV1yThnWbvC5fMbHq27VEKEN7qT7Yj0x/?=
 =?us-ascii?Q?MLBFSqUysMnXU5OL4ThbCCp+RLDm8Nc9q97xQ/7gSu2K00XuesUSeBgJaKMr?=
 =?us-ascii?Q?LWpNAbTuGGWE71p1NsrNJgsdItKYaQA2krRM/PdNHtxwFpliOmRO6z58ylO/?=
 =?us-ascii?Q?f6UPlYjWPAfLwanWtv0d+CL6KoInwnBfdTUXgwa9SORg5L7z0m7+n164i+hZ?=
 =?us-ascii?Q?a/UN5tl5gXuCcCKUtvajnbywEdBZuVi77BkryDTn2/WBAHGuUxoXBld9ss8d?=
 =?us-ascii?Q?BEJ9oSR1Nx2YLzGSSLB4giblsvDMP/nbBo76hB07BaSWBDHYbK7NLELXpOms?=
 =?us-ascii?Q?ycMnC3/WU70EWzq7uNXukrTGFUoQPRelO7r1qOKxi+bWIug4kvQ6TnBocwO/?=
 =?us-ascii?Q?djnO+BoMM353hOJlIf21j+fnxR8GuHCRvjZRBCDsXUfu3DNgCkMNBpe4txMX?=
 =?us-ascii?Q?kWc2u5KeBfOdD6xaZOksAerVq6ACB9Laq5jwIn6aTA4ViLH8dgFZ41D6fK37?=
 =?us-ascii?Q?y/3NJGmCyyxx5GBEvcwO2Y6D/6i/Oaw8upvkjqSM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e9f1de7-a467-4db2-7ce7-08de2b7ba982
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 17:05:25.9060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7htX/HqdzhmOfl8FBHfgWov0V9HhFQDa7+px8aLc/y54+N6i4f/WLSF8CjbBFGoc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7594
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EFF7818001D
X-Stat-Signature: offdc5qrdiksr7bo9xpw8dqb37dkyai8
X-Rspam-User: 
X-HE-Tag: 1764003931-678085
X-HE-Meta: U2FsdGVkX18tQ4gxzCYZ8kwDppgnKqMxFX0mEGgGj7zntsjFcZkrSxAhjyKWm9GtP3+24HnVA10UwueMzQNLU6L9S5wxPPanNjiUHwBKMaa99zABCUMRVk25VLUuEJu7LNW8TFT0/jSOVTxEviQaJKkWIz4XxvN4JVzT0gkss+MCPBMvEkc75DMV/TjfKoemQh65BxOjvDbj7Blr/GPmiMVc87OY3ZCf2ZvVeeoFIeLHvepmdleVtjodmeHeyTdK0H0ovDcnTZaKcOu4yas4K6dg6ql7jlHWA8MpPHF+VGnlIYd+eB8/RWZCvgGbcdldchwOA0IzO3G5bRLU8t8bAbsQhZ4/lcZLdbLd72VZQidU7A9+vQKuUEnWzhlcu1HHAtgTeQjSOkVC86jwHtEqyAGYzRmXM8jPDhAJg2aXJz7N+SKQoHcYHSjm7f2NB6MdWx+vbAP7zqxiAcutfDhfVKjU4RyS63+Rt8hPlYkzVATkj1rQ8BVqfYKsba8+h0fcMopai836rRNnVgdKBMT/X6C2R6D6aTd98yz/KRSa3RPvR11r+yMx9OHncwqhNMd5ekI95rrgCnMqUWLImQitJpKPIiyxI9v+FbwLQCAaf3a5ReGG2PTfqbOtpbxoNOrROEaVxsPU3KRYn1lc7zpee3vBtzvQ24pkqUXb3+R+J28v++0//s9JAe3fDumefypSl/I15cfaz6ePWw0yDyQpqNl0GSPTJHV+SaMOaswmLqSCyyfvO1d+ESJAwRa0xv1wmS6IQGenpERXyghrQLUC09OrV8zo2QVNVXnpbKSHbaeiZse1WJnPW4nyC6SpjYxk3HGQpJNXfPQozNRl4qFKhC+2r24sJiI7Cx/LN58/+vM2GKQ9yEAo2EIP6U0+1GC2Wze26zlNejXK+r4ZdXt9ROLNVxgp5hCv0ofMtXDOejMtsi738FbAcH3ccDBUIxrzwE9IXSFNev0JrXNauD+
 fKUsRaV5
 OURuHBLJmxHQG0oyWPzcXqORSBsEV2cFD09oI2w4TrXTJYKzFLeHtqLfDxnz4132tBLyqjr9+RPCPvztY9qOYZjWNGKLLWSDnbet1c1dtSFCmVUiRBwE7LPGbwrKtuP0F3wWvgiuVHjg7aSsMFMLIMB0aNgAtgCEToC7FFf3Il51oSl4GXagvfDlO4ZhIEyoDTt7CtmD5HDHT9+VLdUIMOfNWq0tNS/J0VCu/5VPAwZqe6hx3I1OMx2ItworfHvyqBKSnsrhyg5lBES7hHv/dR3TlKIuQPwUTe6MtmBo6gqeuACyjkZM6at/ebUEhRAO8JCg0CtGp84+uiNPTo2SxEXcy1vOfT/h8SY0Xhde3BS1fattxfiNfgstEiXlWBjFGk2ww+tBCrkewnYBxqglrMBj5UgvbOBJws99VhaXP21j6LPU7mLkKMYxs8JMNUxU4zIn8OAGJPgstAh/0BTP18YuwGtNR6NCeKKwAj9itRu+W7ns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Nov 2025, at 5:41, David Hildenbrand (Red Hat) wrote:

> On 11/22/25 03:55, Zi Yan wrote:
>> can_split_folio() is just a refcount comparison, making sure only the
>> split caller holds an extra pin. Open code it with
>> folio_expected_ref_count() !=3D folio_ref_count() - 1. For the extra_p=
ins
>> used by folio_ref_freeze(), add folio_cache_references() to calculate =
it.
>>
>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   include/linux/huge_mm.h |  1 -
>>   mm/huge_memory.c        | 43 ++++++++++++++++-----------------------=
--
>>   mm/vmscan.c             |  3 ++-
>>   3 files changed, 19 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index 97686fb46e30..1ecaeccf39c9 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -369,7 +369,6 @@ enum split_type {
>>   	SPLIT_TYPE_NON_UNIFORM,
>>   };
>>  -bool can_split_folio(struct folio *folio, int caller_pins, int *pext=
ra_pins);
>>   int __split_huge_page_to_list_to_order(struct page *page, struct lis=
t_head *list,
>>   		unsigned int new_order);
>>   int folio_split_unmapped(struct folio *folio, unsigned int new_order=
);
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index c1f1055165dd..6c821c1c0ac3 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *f=
olio, struct folio *new_folio,
>>   	}
>>   }
>>  -/* Racy check whether the huge page can be split */
>> -bool can_split_folio(struct folio *folio, int caller_pins, int *pextr=
a_pins)
>> -{
>> -	int extra_pins;
>> -
>> -	/* Additional pins from page cache */
>> -	if (folio_test_anon(folio))
>> -		extra_pins =3D folio_test_swapcache(folio) ?
>> -				folio_nr_pages(folio) : 0;
>> -	else
>> -		extra_pins =3D folio_nr_pages(folio);
>> -	if (pextra_pins)
>> -		*pextra_pins =3D extra_pins;
>> -	return folio_mapcount(folio) =3D=3D folio_ref_count(folio) - extra_p=
ins -
>> -					caller_pins;
>> -}
>> -
>>   static bool page_range_has_hwpoisoned(struct page *page, long nr_pag=
es)
>>   {
>>   	for (; nr_pages; page++, nr_pages--)
>> @@ -3776,17 +3759,26 @@ int folio_check_splittable(struct folio *folio=
, unsigned int new_order,
>>   	return 0;
>>   }
>>  +/* Number of folio references from the pagecache or the swapcache. *=
/
>> +static unsigned int folio_cache_references(const struct folio *folio)=

>> +{
>> +	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
>> +		return 0;
>> +	return folio_nr_pages(folio);
>> +}
>> +
>>   static int __folio_freeze_and_split_unmapped(struct folio *folio, un=
signed int new_order,
>>   					     struct page *split_at, struct xa_state *xas,
>>   					     struct address_space *mapping, bool do_lru,
>>   					     struct list_head *list, enum split_type split_type,
>> -					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
>> +					     pgoff_t end, int *nr_shmem_dropped)
>>   {
>>   	struct folio *end_folio =3D folio_next(folio);
>>   	struct folio *new_folio, *next;
>>   	int old_order =3D folio_order(folio);
>>   	int ret =3D 0;
>>   	struct deferred_split *ds_queue;
>> +	int extra_pins =3D folio_cache_references(folio);
>
> Can we just inline the call do folio_cache_references() and get rid of =
extra_pins.
> (which is a bad name either way)
>
>
> if (folio_ref_freeze(folio, folio_cache_references(folio) + 1) {
>
>
> BTW, now that we have this helper, I wonder if we should then also do f=
or
> clarification on the unfreeze path:
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0acdc2f26ee0c..7cbcf61b7971d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3824,8 +3824,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>                          zone_device_private_split_cb(folio, new_folio)=
;
>  -                       expected_refs =3D folio_expected_ref_count(new=
_folio) + 1;
> -                       folio_ref_unfreeze(new_folio, expected_refs);
> +                       folio_ref_unfreeze(new_folio, folio_cache_refer=
ences(new_folio) + 1);
>                          if (do_lru)
>                                 lru_add_split_folio(folio, new_folio, l=
ruvec, list);
> @@ -3868,8 +3867,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>                  * Otherwise, a parallel folio_try_get() can grab @foli=
o
>                  * and its caller can see stale page cache entries.
>                  */
> -               expected_refs =3D folio_expected_ref_count(folio) + 1;
> -               folio_ref_unfreeze(folio, expected_refs);
> +               folio_ref_unfreeze(folio, folio_cache_references(folio)=
 + 1);
>                  if (do_lru)
>                         unlock_page_lruvec(lruvec);
>
>

Both make sense to me. Will make the change.

By comparing folio_cache_references() with folio_expected_ref_count(),
one difference is that folio_expected_ref_count() does not give right
refcount for shmem in swapcache.

This is the folio_expected_ref_count() code:

        if (folio_test_anon(folio)) {
                /* One reference per page from the swapcache. */
                ref_count +=3D folio_test_swapcache(folio) << order;
        } else {
                /* One reference per page from the pagecache. */
                ref_count +=3D !!folio->mapping << order;
                /* One reference from PG_private. */
                ref_count +=3D folio_test_private(folio);
        }

shmem in swapcache mean !folio_test_anon(folio) && folio_test_swapcache(f=
olio).
The above code gives 0, but folio_cache_references() gives folio_nr_pages=
(folio).
It should not cause any issue, since IIUC shmem in swapcache happens
when the folio has an additional ref,
folio_expected_ref_count() !=3D folio_ref_count() anyway. For split, it i=
s
not supported yet, so folio_expected_ref_count() in split code does not
affect shmem in swapcache. But folio_expected_ref_count() should be
fixed, right?

Like:

        if (folio_test_anon(folio)) {
                /* One reference per page from the swapcache. */
                ref_count +=3D folio_test_swapcache(folio) << order;
        } else {
				/* One reference per page from shmem in the swapcache. */
                ref_count +=3D folio_test_swapcache(folio) << order;
                /* One reference per page from the pagecache. */
                ref_count +=3D !!folio->mapping << order;
                /* One reference from PG_private. */
                ref_count +=3D folio_test_private(folio);
        }

or simplified into

   		if (!folio_test_anon(folio)) {
                /* One reference per page from the pagecache. */
                ref_count +=3D !!folio->mapping << order;
                /* One reference from PG_private. */
                ref_count +=3D folio_test_private(folio);
        }
		/* One reference per page from the swapcache (anon or shmem). */
        ref_count +=3D folio_test_swapcache(folio) << order;
?

Best Regards,
Yan, Zi


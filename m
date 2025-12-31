Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E083EE49BD
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 03:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787C26B0089; Tue, 30 Dec 2025 22:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731F16B008A; Tue, 30 Dec 2025 22:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5406B008C; Tue, 30 Dec 2025 22:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 512096B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 22:00:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F060F1A0392
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 03:00:22 +0000 (UTC)
X-FDA: 84278262684.19.21431E6
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010021.outbound.protection.outlook.com [52.101.193.21])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4AE5B140009
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 03:00:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SDZtJQbR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767150020; a=rsa-sha256;
	cv=pass;
	b=Omr1SrgXHISX6SsMiKBLBNfMfK3qFClX32JeoeUJM1RthTUmJJM4dtr4dCCMd+vDt7gH3F
	VGe6TZUmfQqz8L+0Jbe7MXe4hHpLB+Kmi9dfmm2FNH/WnAtV4wkG/0pIs/ZSI1p+6JNvuK
	ojsKBxFvuo4JzxxaPOwKxN07GPUeNOc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SDZtJQbR;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767150020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWdrR336Ped0hPSNgnTR0ZsUaZG+C5Qy4Vo5tw89Y68=;
	b=O8in9eiVlj4GTxpJMPKS+sux2ZUJvka96LwLZk9fZbXlrjBu+i5aYJqV5suIehI934giom
	uDx62/wkKjZ2Hsa5jJ+vcmizk9PKo0ym75OKR+izVgPuNIQacOKxfwHqFVl0azDQFF4Iav
	eV04bUpJOUx1ak0aHWKpSMYbgihdJ9c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pKyBnWXwksHde2iJjjasOM8FCrSoBN3B+/imVPkHW6NrlIFD6Cq49zTS2lvqhU15XxyuI4HovN/+IUSAu7jQbCjtOesuaSYxje9a97XEuFJz4mm5B7TxXQE3OMCmDxgsNew1PtkukBMfc+SdH3Qlsv4ssGEHqyJotoKaKkJhTtySuYyRnKKMTVmd5HTFnuy/gpfV7Nl3iwou2QqtzoQXoKpDAAOeH7CuAdypfwDjqBkz3Fn6rXMZC3kVGweVt3J8Mc1ygGHobh1vSUBrmsyIl1uFXaYyhxmtejE8zEzV4ksF9sO+Ykt00VVQZdHWmqj/QKg5drDEyjumY+6Btt6Ddg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWdrR336Ped0hPSNgnTR0ZsUaZG+C5Qy4Vo5tw89Y68=;
 b=x3D6ZHx4S4ergiyeH7ukFtOiedvJUJcPHiEOiz0XCAcPT8ELxOz4qB/ViPKBAkkU8Jor6UNJzDNNkbJspIcnMuDQ1Q06jLQvI7EFR9iqn9asAPYu/cd3jLxWVnSH1xLPjveUHAq19855NZ2BoQxdRyHfkWceOUZk4We+R3um+yeN+x7z4izfgiLyGknF28QQQwN6ZXNWUGgTdZr+4AbsAZJGAzph/OfLne0e1yqSVHV+vI6nIR8q9jUtDtpRxyqlcSukkIX56UphrlB1FE09n3Eo3eP9pYaIwXVmUqnxYVRthqDFv/KIPxVzSF9/CRC5gKXNfgnEHriK49SJXpp4Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWdrR336Ped0hPSNgnTR0ZsUaZG+C5Qy4Vo5tw89Y68=;
 b=SDZtJQbRtUIWMRX/h99CztVpAsSI/xSZLMQEVKik1QHNTsdnI2b4dA1hALEyqoK+me8jP7PPo4VWTHOfnJcvUj1dMDHPqobX2hSsn2DO9lTtcn7xcYk/uZcBgdsCZmGZZoWfoEG+lShbS/wQV+Vd1Eb9CIIQa9geggvjEe9CzLYEGe4g5m9raoNmOGFTc7Qvs4aYQwlBZJjxYpl7T2TfFAIi/bVTaX+HD3omd/odahPnV+K5xv76i3u5UWbBRjiGIbLvEaqM7T+CXoBP52jEXTgsvXCVIpeOcPCCe8zgHvtOL2AEl8sCH33tnblw8fkTTtXiLjb2BjzYXUGLCp9/XA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6752.namprd12.prod.outlook.com (2603:10b6:806:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Wed, 31 Dec
 2025 03:00:17 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Wed, 31 Dec 2025
 03:00:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Oscar Salvador <osalvador@suse.de>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v5 6/6] mm: hugetlb: allocate frozen pages for gigantic
 allocation
Date: Tue, 30 Dec 2025 22:00:14 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <DC375867-8D63-4EB0-BE7F-0D21B4155450@nvidia.com>
In-Reply-To: <20251230072422.265265-7-wangkefeng.wang@huawei.com>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <20251230072422.265265-7-wangkefeng.wang@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:208:91::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: c7ca498b-3a90-483d-679a-08de4818b9f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LTxP8cYM+u+mPzl2tz+JXhu1thTmBqEeayF1slC7Bv7REBP+FK9IT5+wHOOf?=
 =?us-ascii?Q?+LTP61a+MMwQldUPsJUUDDr8rvr2levJIo7T9uCyVGb74t9jNQ/5U9CmAYRW?=
 =?us-ascii?Q?DufTI8TmAP57e3gJKOLqH7RBg080MGysSJUVcOJ/0wH67wt1yQsPffpP6rf6?=
 =?us-ascii?Q?CboBBpjZaunfqsHw9gAp6yMvq+D86e9d3fiayViJjTmViL09ZAFPnOPlC9CS?=
 =?us-ascii?Q?Pr3+JAD9ImB63h+JjWpyBEZyUgrpI49flLYdpbv7a48mlSmi/v0a+of8euLO?=
 =?us-ascii?Q?5Zq0VOFLU3s1FOiGanAb2LUf1WnUOlZfxhfwAt/6zkGL1fpSKnFxOyLnzJog?=
 =?us-ascii?Q?E0p5hlapgNW5DnURTVjBFBQf89/w8t/PstPSgJwUJAN2qQ6NPamPwFvCtpTk?=
 =?us-ascii?Q?mVBlLLglyPzBBSruaNs8kTCgMTJJdvz2Aoa0/SofRhjunHrdo/SrwPyW8t6w?=
 =?us-ascii?Q?S6auHLI+rbpJOEFevnuJjoD1ejSwn6V7GL8susNjyPW9EvGQeQBrXrz2OBby?=
 =?us-ascii?Q?NSYsH5+KTp4MorworaO6EHaTmTRabk0jF7C4WOOBFg5KAVTpFm/dQW7ituqV?=
 =?us-ascii?Q?Il7qDWWvoIDdf+vNnsgAbSeU3Ie8VTm//glwBA0jPVHyjyBdDA1rweZkap4f?=
 =?us-ascii?Q?c1GzXTl/HlGgsG//dv8S+oRoVjkyu73DpQGbvlerKCXN5Vpp4w6OxXurvVRu?=
 =?us-ascii?Q?BcqDPGcDkDwf9zE6aAnC06oVUCmOzT4h6KnLthc0kPToDnWto1QN2ySKzAzw?=
 =?us-ascii?Q?K1w5tZpD8QDm2Y+s955RtTiiv+GPTra1EOn38ejgSGH+115htYtl+GVeIJbs?=
 =?us-ascii?Q?AZVCJ8/vaad8putAfkl6fpidHhKMcJQQtRpughvTywqjyCBawPuQvlUAfdYR?=
 =?us-ascii?Q?ZEKmppbilwa3EnkuIMzoLaRISz3EusEqFVw3jQK3aeE/DOIAFNTxyO4DIpkl?=
 =?us-ascii?Q?/35SYZykQwRCCKvZ1exzh/vzx2syl7Ges0OfbOL2ZLsxJor975EbZZeGLC1/?=
 =?us-ascii?Q?cVOkb7DVg8Sg5ysFGc5XzEiy6xm8kAg/LR5KYyS0IHWkJ4BkeqRObcozxDT9?=
 =?us-ascii?Q?b3WIv2OZWBlilXHLf31wIYrHhnIp5ea0kl3jYAh0WDTx1bJBc1faa9yuQH55?=
 =?us-ascii?Q?yM4UkwmiFy/8LkUU4wMLDHCBtEYMyUzQo3Bkxm000fblCvPM8iygfIQJLCYZ?=
 =?us-ascii?Q?zBCNefpkHoFKC0M36p6o/BOjijnMZMiV5vT0237DpTx3krGX+Gi56Ozgp5xo?=
 =?us-ascii?Q?T5mloDfj4xyJ7Lfz1piSmUAXO4ym0d+LW9p1RQ390hfFBcUriRj+TkNrnhW0?=
 =?us-ascii?Q?+lHICAxexIBt61elXYJddEpiyRtox0KcfuGNd0ERXKryvGmOv5ERmrfXxYGJ?=
 =?us-ascii?Q?Bxzg5wOLMOzjnKfOg6qy+npepa95qLhDr0Uu5cuPMhv/MdtY2JbtxdAhCdDU?=
 =?us-ascii?Q?cTR4Ef3Qge5PFVxkR+HOBx3h2Az8pVzR?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K/KNSrdbHE1upiYFndvf1BXwJS6RqkpK/e+0QU8no+io7PFKT7GtnWQahrwE?=
 =?us-ascii?Q?QzK97MInNx2QbjF5WBdQuFroq2JyBz1JL4ak2WTmARDkup0d4yI04nInkiGW?=
 =?us-ascii?Q?RSJUoX438Xi0ICr5Sqrtjox6jFIY+XQ4ryv0XEiBMCU4/CdzdrbcjLLIxqi+?=
 =?us-ascii?Q?M3CucPvcAz0o58erCkz436m4lrUjKoOOaNF50zYlM9JISvquhhcR7UJURmQx?=
 =?us-ascii?Q?LKpzHDX6t+cuSSm38vgAuHrMft+dkPJvrKYlZnyP40Vy2ld2WbdW68voThj8?=
 =?us-ascii?Q?ppXmy55xD8iRQzywDJrAeuwE2r6/HkY0JBon0u6YsWkokOnsZYwU2aQzPief?=
 =?us-ascii?Q?2JGsK0NEGO2eXXA6LxzS0qqLQRpxHV0auv+08NrlAdsbPWNyrwP4eCVrlfZp?=
 =?us-ascii?Q?AejRCkjDtEKqakEjQ5hGWl39sTYXahxt5FXUpiP19tZa1DZdRXZoKzKDbJi4?=
 =?us-ascii?Q?tJlu6lYc65d7pydHe2thYkiKX9QuYe0q/uEpWhDCryjdAAer73BHfjTazrwW?=
 =?us-ascii?Q?JWqkNNvd3F+tS/SRs0l/2tJg/frHSPMpRoSIJb+O+1soXXYf5dk8L8kAKind?=
 =?us-ascii?Q?x9IBY2IZaWeKuMAW3oUnRAwJWZ/YERuONMLICsrjJ0giAYAX73L/uwLC41/E?=
 =?us-ascii?Q?Uo0H+o9oLgnRzE+IvRyBmZOHmHit0lScHuGSgA9TtQhPt4x0QoAa3+Wm2dkg?=
 =?us-ascii?Q?l04V5y4mhxc1dxRqzudLDTsM/SqHBSJ98aqEglv6ypO9ADY0pWOJI34RQv17?=
 =?us-ascii?Q?gvj8TzhiDLVAcBYvn3eFx36DvqETs1HwocKparsqCUwSIo0Rf9VHtcpfGN1q?=
 =?us-ascii?Q?qmSoI8s2S1za7ZhLAruhp4CIC2i0Ye9BniR8UNiDxVJx9JncVy4AJFYnJzn4?=
 =?us-ascii?Q?EMrM8YMeuAuBRQ0q/xacaeUjEM7OvmQEKela6jZ/YqMNQv2vCmEc6d3Bk2yW?=
 =?us-ascii?Q?V9JJkn2i1TJOQ/vgZlkKRTtLcA1PAyWKLvjSkWI6cUEx1URZbUW0fMr0y/1P?=
 =?us-ascii?Q?SZq2Fg7e37HqTfa/BMNW8aSNhUMVTwW8e+KQJGgSdu9CJJq3j5EqP1QO8KUk?=
 =?us-ascii?Q?eHR9kEUT+O9Ivnsn4Tzmgw7aM1iWydqeEGE3dsMNCl9w3fzofw7Ww7q0qRC0?=
 =?us-ascii?Q?JiqU1Pc54u49NoZx23KLhJbTpg1kCGEu88tcAPQ2uNgw4PEINGcFtrkRm5U7?=
 =?us-ascii?Q?uqrNFiVkdN58145/oUJbGpdQx0LIBgsjSAQfgFbrGWUuq0EA+ahwMRU/W8xN?=
 =?us-ascii?Q?pPo1YxXnqw3ltMIpqL2sUYIgRjgHv6m30gNAiwq3t+YpX4k5dFltXJy/0/t1?=
 =?us-ascii?Q?XZemMIjuz6xM9FKfao1UT69Wx07C21E590clW4yBLHXYF/u0kIl70jyc4YwA?=
 =?us-ascii?Q?PpfkGsyVTwvF3utYWlojKgNdtGUI1P7TRpkJNdj4WIaPBV52HsnCaFbpXFVR?=
 =?us-ascii?Q?0xyjj8Z4IPDKRaUwvDHpLPZlxooiRD/aciEfEWt7H4cH98APjWGeDDwnPaH9?=
 =?us-ascii?Q?bIk/r3C/I5lVdncJUif8IFyT6VtO1Cek/n1aaSiR5niUL/Bw7JPVvhlKDAt5?=
 =?us-ascii?Q?shkIZdfGQYnlsqBB3jnXfIPvtqWrwUpm2Ub9og1tUZLG17UP3JAd3sRqKUwj?=
 =?us-ascii?Q?dvR260Wdh1oeHvm6IMQDuelgoPZOToasc1OE2WMMVunIbZmPHmiiVlSwvOfH?=
 =?us-ascii?Q?IOH/JVdvugDeu2msqm5uAgOiqOjZ9oK7Nzbk91jKJuq580lY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7ca498b-3a90-483d-679a-08de4818b9f0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 03:00:17.0041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: heTmFRfX1JYy8yfHpQzrnWi5o1OwyQnPsHDerbJDQ+T0JAVV1f1fHO2LcTAh9AMf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6752
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4AE5B140009
X-Stat-Signature: bkpagr3769akx5hgnexdrhx67xzgdmoe
X-HE-Tag: 1767150020-835576
X-HE-Meta: U2FsdGVkX1/ff0se4IsSSPSpCXTdObdazXLkfMBBz0DRZMnqgaucz6zYcT3llAAqvBOIkvU4KF6CrOKD5ko2txr9eJWXT47wzeZb+oSLxWzEvpXUv5fE/7f0JkoBy7wbG0x/IddfZGgXqrcVvrO7K6WDvHcms4VIvoThxJ24xmvrqcdtUP5iIZTc0kgTd82/vpDhQtkFXLMakiJrmYMaCZGSU3wvNesrTLQoKcfcF+Er3ueDAgyCy77mhRyGXpUTXTg9SNI+T/CvfKepkTvcx2pFBic3lWzNdD/NTA22KC8Xk+EfeGqqTO8/2/NRfoFd8PN3Dtsoq0vRggobOrq/BitxIyHy9rA/DxY/StWRaD9KqvM0YBULMrFkeUtFj3vjd8iQE6eh0zKW/x92c7u09xeNAdJjdliGemcwsi4BL6YRh3kpqVChGiBp/0pH42LTSUILNLNSchdKxKD2rS3q8IiSYeh0FVqqOxq66hqngxIqRDemqe8jf+4o93zEPY+6ltJ3Wvp3tZIdjZKNIs9GZhGr+VphaaRK7FDfHR4j8SV6KoaMl9Jmkyqr4fXETAvor7pXawTtuLFpATT1FB0ojCgGeipOCJtjKLzP6FigE/9pQ+Olq2TCVz5d6xadw5cJj/p4xU7XZJaZPymPVOml/SvkJhp17cve4ISMmiE1R/ev2Qv9RmN66EXAK0rBpixwc7+tax58NfSnNb5+xN5+Zg4xpcpoD99VAmhS1N8vAP/3bGI7nZ5rhIDuveSQx/1d+NF0mXt6bSEPwlMVL0jskHecXDYqAeq+YuuCJIaKPiPEIAB0SKEfRv8JRuxCzNny/ByyLB4JSY8UwYtqqwk71gumjX+9VJlG5kD27Jw0JWf4EGMt4AauCOY2VpOZ3YIR7A17grKUF4s4Bzhx5wy+CCPrOw5pxqw4N50OQOPIhVd3Jgk2AV7k713r8xR3/VGUA8TCqgkNc74KU0G7XvJ
 acsQ4U3f
 //zqRmKnLU1n5cz0q9bVNzESFX/KiLoX8hnneodUEEkyoNOmYVG1+wlEpn0rWZEiRbgRKvDv/bIOB5rm6w/2FKoZE1NBCw+kx8fdB2eASgbunU6h5bkusHNvW/UKAVDwTDsa9B+oe6rAgcXjpDTWIkZFwC3t1WvOB9Nurtqj+DeesTUmtdZWCUxI40375ZiQ5uoVwsStpswJ/kqDUMTRM4JVwMMHCRigndib1XVo9fGRu7xyRPW16mHCVrdWcbtlYGIpRfhVczSISqc2DXocwVmRe7yPcLDEIihCJK3JXFNmKGOA7gtBso29td+JFx+nOA5KeP7ek0W88h2OqAoke2IZWr7HokH4Yg/fPWdqEsQcLXI1HnBk1CN0rvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30 Dec 2025, at 2:24, Kefeng Wang wrote:

> The alloc_gigantic_folio() allocates a folio with refcount increated
> and then freeze it, convert to allocate a frozen folio to remove the
> atomic operation about folio refcount, and saving atomic operation
> during __update_and_free_hugetlb_folio() too.
>
> Besides, rename hugetlb_cma_{alloc,free}_folio(), alloc_gigantic_folio()
> and alloc_buddy_hugetlb_folio() with frozen which make them more
> self-explanatory.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb.c     | 75 +++++++++++++-----------------------------------
>  mm/hugetlb_cma.c |  9 ++----
>  mm/hugetlb_cma.h | 10 +++----
>  3 files changed, 28 insertions(+), 66 deletions(-)
>
LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi


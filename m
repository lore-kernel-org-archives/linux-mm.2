Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 633C7C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 18:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB55F8E0003; Wed,  6 Aug 2025 14:24:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65878E0002; Wed,  6 Aug 2025 14:24:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DF28E0003; Wed,  6 Aug 2025 14:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FD048E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 14:24:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50178115DD9
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:24:11 +0000 (UTC)
X-FDA: 83747157102.21.9440E2C
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2078.outbound.protection.outlook.com [40.107.243.78])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8CD594000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 18:24:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UUwy+bZ/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.78 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754504648; a=rsa-sha256;
	cv=pass;
	b=XXvRVOwezms+bm4K5nn/63P3dLOyiWoZgtKGUa+LxD21ocXr4FAAu2DI/9u98LjLHLI0qG
	CdruSL02GfoA+yFjNz7bTOm2uwGg3cdxdi8hVI9GxfwLTmqrcdXPHLbYMf9RcUcznNZmGA
	uN4UXXBcJhKi4ar2QMteivSgmuqcSb0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UUwy+bZ/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.243.78 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754504648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emT28XY0bSX1/QjEU4warsUIJOi0H7Aj+9J/jkEn78Y=;
	b=vvd2sztWBbHy0f9lZhdIXXs0oqTHiYlEctREWtBctw8z6rpz8rGzdjEVOzl3mEcCUaIHQT
	EfHro4wH2gC6cR36bAuaNhiYWtaa+lUieTW8VicBO1iXTWZ2s28lAEZGoJH+0RZH0unCoL
	SJ+sctJzXFBvMDwWAMB2Ubbt70x3DzQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qrP3EyKMi6zW49awTvPex1cLwiNt0iymN2RGRC+e9B0D0CyyH1v7C53xODL8o14sEK+BJDDb/INr5naVK2usEzolSGogZ+KhHjJmwqYX29xP+LIpOt7VMxDDlsEI/95PRq0oCPgNJUOeVjLZKz92wVE5f9nFqYUm0gjsLttChy6CZYoif/lgXbevJjti7HirMAoiRYa9Qfta0iO9O8ChA2jPxHchcBVr48hA+2IU6V2371X0SxZHP3iL4QyYs77YUbqEoGIClwl5EcjRUy+uj6buDG8WSIv4Rcbnu3XzDeb2HrQlM6GObvqgavNWkYpF/qEs9IpXXNyCot5EfDMS8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=emT28XY0bSX1/QjEU4warsUIJOi0H7Aj+9J/jkEn78Y=;
 b=psrfJ/96Kt3gd67DCmUsgTXX7yTk3ljNMcuKWzohZeJ/tNwCpPkYOpjsvNFZQpzel3Htl2qaspwpagYWsxdBMJgyzO12J5Ll3l8BMkUOHeHvX8B77fl04148bDvcR013AR8D+G5WNOy1wK2/ymVK/xCCnpXVbMBV8ZJYXHgW4LZyxr79IvLSS0hlaLI7sEtMOeOFyTDqORJQfXka1RpZ0FoQhp82rcWTj2UlukEnQTvReDIKc6imV8z6lx4oW3IjZP3Bro18AIWuChA6HA44qrFH0iBVeZvB2Lf3hk1TwvmabMioTlv1mRebFAh9z5msxzAlm0SBTobwyqPfv0gYzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=emT28XY0bSX1/QjEU4warsUIJOi0H7Aj+9J/jkEn78Y=;
 b=UUwy+bZ/kkPpbd66c/LO2I+C3jmgc1aJQNW6xgBIiMZ2ikkiPpS/dmv9z0y4OHIUp7O6NveO1/tIc6Aa/2EZYKhsfCT5tUdYigi3wfSAzClwwvpbEh2CVWq3HTBdU4lBPaZ0hUc1MBwhj1rX+Uj4UImaieuCzdLUON97/akT0NKtjDE3kzL1PVthb8RO33h8fpFdpQGRHDem2c72PA/ywRpiJsHIgRi8LsPWwPYBZYAG24TESR8/4Y+bn+tnZpnhODM+dJlnMZccKLQ6L2xXMhJNw2MLm03q1+tkNDl2xx2LlBtb9Gedov03xjPmx/Gl75v78+zBJc4qxJyKWRgemQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA4PR12MB9787.namprd12.prod.outlook.com (2603:10b6:208:54d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.14; Wed, 6 Aug 2025 18:24:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 18:24:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 01/11] mm: Introduce memdesc_flags_t
Date: Wed, 06 Aug 2025 14:24:03 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <26FC57F0-BF7D-4F02-9736-F15B4B56466A@nvidia.com>
In-Reply-To: <20250805172307.1302730-2-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
 <20250805172307.1302730-2-willy@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0582.namprd03.prod.outlook.com
 (2603:10b6:408:10d::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA4PR12MB9787:EE_
X-MS-Office365-Filtering-Correlation-Id: bb0fe803-eb34-4d7a-58ab-08ddd5166d43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NrzSZtS9ztgOg5X04fJ9JlOg4mky8VukKdY6IrOFZ30Pqe6tobUJrviND5pR?=
 =?us-ascii?Q?Daeg4NHw5icfDCNn2MA7WHdNBHWzl1hef5sWgPxVr5uWSkNqUU/HPDzCZ3Rx?=
 =?us-ascii?Q?caaJpDzmk1qsC1W1ERrQ/IQetyrxu/uBPSabZRlWgefKTdQ2wDS3CU/KAe1a?=
 =?us-ascii?Q?w2orPvB2dUqzQWtQvM2UZjRKvhRP4kQV2hGzoVhnUK4vBuJpAWN7po38nvd9?=
 =?us-ascii?Q?YNXOrwdChA3CmvuPi+Lfd7MRO11pzkIIJnCpERikFAl6AMZkkHbxrSAZG1Ih?=
 =?us-ascii?Q?MDpbDFDbYi2h/yJYuyja0+2E/talMYCj70vsz0zkdGODNQTH8ngdweMwzEZM?=
 =?us-ascii?Q?nWFsRTTL2+Nx0QTZIzgpafZEWDT+oV4VjakXfDIws7OUWKN2EvhvfRIvoAtk?=
 =?us-ascii?Q?OwkDGB7SAOs9u6M82sb+c03tg2niWEiH6plX2WlYb+3/mdaOY3Wd/xqsWGRm?=
 =?us-ascii?Q?Oq8ockP0HdM9mIXrut0h+lo9RPW+Z/VdBzaByz6d0eTWsn3A/r/y8BYQHvAn?=
 =?us-ascii?Q?QnKV29798fIJpudbjQhIOl/ctjEYkvtxLbv5O603izCTlqk+rfn9WuxFP7lO?=
 =?us-ascii?Q?s0EOz7iGkLRM5xd5QtJaR3pj/3dsPQh4ZK/H6sXr2gCXuSAt03sfwRZhtu5b?=
 =?us-ascii?Q?VpA/QhpPTUoE1mzcqwe9Yf1VhKjj3GTNrBhGoGt695+JY1X0kRi5pd7wsyf0?=
 =?us-ascii?Q?wqCF5VUwA7Zle1aXtKEoLjxVoglY8BG99iaJSYpYciJbrasW12tbBYgMh7yo?=
 =?us-ascii?Q?Zk+PZwPDiy3dpxrjq9m7yuJBjB9mCCFySCQMzenJLk2FdxuhvtxJQzLjP38R?=
 =?us-ascii?Q?ye4yTD4Ve9op1WSKsSEciz4QQGMyAJfTJETzR+Rj8Ii9eJ7euc3WUGVhyijB?=
 =?us-ascii?Q?eZ55irTykqfi9CFIa1t/DMrQideQT1Q6m6jkMQsRmjI6Dvp8busQo8saiBGd?=
 =?us-ascii?Q?iRgofiFcuXJVbyGDveT/L6wB7MQgXUxI5f348DEegbVzJmENnpi8irnTE473?=
 =?us-ascii?Q?rghR1MRdwRB9RIo00iRkNO7A7EceyFYuXiRiS0GHSyHtEPcWtiNKT/FAQFm7?=
 =?us-ascii?Q?9oQA3lE+0mjU2oA5pXlpe9X33jqCh81UDHa5cA1AQMxreEoc1Kj+1Pi6G0X8?=
 =?us-ascii?Q?EFVgpJtxofDgxOBhZmddJzZZbXfaYB4ULl7pne8WLd7w3+QW9oleaqkcp91q?=
 =?us-ascii?Q?SzhUHN/mpDm303V2/7NM+Z2FXNQMWJyWrkkpG9+Kz40oSOvKqbO2n5z6FN+t?=
 =?us-ascii?Q?WOguKP83+WZ0E47MHSOIY0tiWJE7mcr2eWJrPUjkA+8mpV9tlm5/rAanjYcv?=
 =?us-ascii?Q?C6r3ykuLslv/I1iFB3V843txDCXfSjRTHQ1Z5BsQ0C9WxAaGW9fTpNTglkPs?=
 =?us-ascii?Q?1xF0WAWFLdMY637agTikDlxardMfhTMZPJ5MR9ps1eUKopXWZpKjh6ZrRrKs?=
 =?us-ascii?Q?BWqkASc03xY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eqSLvfdBOqUlIBsWOb64R0SQdQNKSCnmh5NQjXn99674XFapE0e9acJTDdcQ?=
 =?us-ascii?Q?kLT81FQuyo67BQXicAP3euy2viIdJ56BOqBzgZCQPXOXo9qBbAi+cjaifaCE?=
 =?us-ascii?Q?CuqJ9bq+ABSAyCbYXKE7IQrIE4/YsXiR/88TjzY+PvG7lsajHhEGitRtW7Us?=
 =?us-ascii?Q?xzclDjbxKd0/O1JsyP4IkwZjoSGXSgyKCwVXflEVULhc0kLl8lH5d0vW4dMg?=
 =?us-ascii?Q?eQM/UcU0mXn2jMwYxUPglBCQkyiBK303/YXie1M8kNEzqIdZ8Oef8El+VyHZ?=
 =?us-ascii?Q?zuOYQlSNmKfFKEQvTAoLkDBbB0YnVuAKWHQu0ufDSa5qtIPlCwA0T1pnFbxk?=
 =?us-ascii?Q?Tj3KxDu0cepOFzpjiAmmEgcN8bSSwAkQswQAeMGzz9uH8Phq2wVD0yl85BqO?=
 =?us-ascii?Q?BtVSV8GvaSFFFBuyC5eEDmiO+2wTd3Vf0/pEcBNg5WnvurjYHnTcOle/ObWB?=
 =?us-ascii?Q?5vQ6aQhHasFIuDeDCG9FZFVI9VPPZlwTh8yFTdih6fCmzTPFB6DLXVcfy3SB?=
 =?us-ascii?Q?CjZU+DDvx2bNeN4MiZN0MWhHE9oBvFNu1/KCr9MRwElnzgqeR5c3rEuoWQL2?=
 =?us-ascii?Q?uy1ZnurD5YFVYg78yDMl7YQGYm5P8q6BZMUwB9a5yD42sjNv5dQYKeH8ZKRv?=
 =?us-ascii?Q?Rv0azLj/FqsgCxwQ6s7cPd0gS+BF9eGJUfMuxb+DsbIl81fCPIWj1BH/vsgk?=
 =?us-ascii?Q?e+n8yD7rfdzJeGC+NcQKnxqLMqVDfKs6ByzqA7dgcZPLV3mfcRFhknbV7+B4?=
 =?us-ascii?Q?41LEDwu4PQiNvDvP56dSlDsub2hEk5O+DG00/fqw9Xxa45KgaeMMMFPpjykO?=
 =?us-ascii?Q?yMzIz1k15jOvAM+ytX7s6PPZWORURzcwXoR8QHtREU/pi2uvEC5g1QUGwDgh?=
 =?us-ascii?Q?nILvlA9At2nRBSm823gD+UKEVH8JLufBQ1nWEJ15EGnm7c0zHuhurnkAh9Qq?=
 =?us-ascii?Q?zs2TUjviUKysyBPphPs0W/D3FGK6qdl1qAMwhnUMCyepM3CgNXIUiBp/Jf8J?=
 =?us-ascii?Q?+0ImyUO0YdqZcVlpQQ7gav4KPvQDDHkYf99AhCrLOZ8pLJFbWjiZMzMeVAaJ?=
 =?us-ascii?Q?Par15YUmi3/riFLVF7oiAERE7JgC3/a9kClGezqMpyp0Wp3pqBo98v0pkgLR?=
 =?us-ascii?Q?nP1i7JRNR4WDuQ0NciO7c5sJkMgIVpb3b32yle4GI1dJue7k79Ey5v+WFVEE?=
 =?us-ascii?Q?3oUoiTO4u7LfKstJB61jxbP1AyNvOG4m6ugYm05fqVQuuwx1CmAQoM55JLxt?=
 =?us-ascii?Q?+uPixNuhdw1ReaYk+gHF3wDYHs7Q40mjT8eKP6f/ln/CYtRU0LTpQQaEKOLe?=
 =?us-ascii?Q?pkGSKOvag3F4UrmK8r/llCl8QO60dVW2csLbrRXA05t8Nj9es0t6oXWF1UkU?=
 =?us-ascii?Q?mSnL95bJcd4jYWvtnThSDFN+0XAaKyoK9yEAML23XSe4AomW8vwyKCWsrvpK?=
 =?us-ascii?Q?g9Tx9HuAEXrr2lEdOHueNZm8CkrEkfYh7/WmHGdEem4b07cUTEheHV3auD6i?=
 =?us-ascii?Q?bnQzYVw0/t1y7ewyiHlUx06KZfbjqhdJAXAHjSNGjgDe83WtVqbteGtRpZdB?=
 =?us-ascii?Q?Q5+DsH/SsewAYVWOcHeT97TkzFgyRBsw8xrqsTxF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb0fe803-eb34-4d7a-58ab-08ddd5166d43
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 18:24:05.6926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWnb0jYqS95iHGe/ku3TliAzFSadI9NAF0299uNgztEBqPwUlPAkU09j+WKbge6P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9787
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8CD594000F
X-Stat-Signature: hbuoafnhh9ao9hea1griph9xhoi1sbwx
X-Rspam-User: 
X-HE-Tag: 1754504648-474214
X-HE-Meta: U2FsdGVkX19rQAXMdqO57ulhYs7YYSzk+ZfJDmIkgYLULTN2hMhYbIVBKz6UbBsCsMbVcaDBn+KhCS79vTI8L0t0j/lJ5MG5J6NmLR6IXv/KkZMpPkTV5vGyeArpHuWDDSTt4jfvqzOLP2kQ2vL1UJvpCdEhKTajoAqbepX/ZTxNowsvPoR9FuDa2flD2VcQooeqwnbSSFbDmCnZaJxZrxbDrZKwFqIQNwa+SZcP/W+E6EuJWM2zgbBDe4THd7dGGI0Xr4aqD4adaHG3Y7mKG+fwBDzfSkEVmvYNwUIIxnXcbb2LvytDEDbYgzkxOVUYKxR3ktvYjccetJ72sEUQb6zGPz3Pbn4F5XVUwF359Zm+Lx+uOAXifPMzzSCNO/A0tVzjyx5ZrOgN8dFIv4A9WpiVo6qFCfS0NDbSKJbeHNlmwAnu0KXBLpWrihz8BHIwhOjQcdhCrimm3ui/G4SJc4N98HMjCJ1UDXTIqJCZAKKsvxkQuRb26e6i1GZVo6uby9/C2tKaxm8DR2pXC0EPHsB+55sbUM9qEG1b2coRXpVQGrWNfS0hZAz3Z5q8lGDQmyTLhaCqjdGnVqOkTmTmv08MvLQIQaXASkHzo1UN02Q08zSFP/adQ3cCXOP701Sfx2hgXs3eOHcV1Hr6US0/KUvlmGj1sj8ibMhAO/sXb/L6Jq447QK3Qes6kgjEZE5SE0YrUA8JvNX/TilV7XqmF9YSX16+xd9cJ4A9KZ3mUjpzF6kSpBMUEeEnXeDKVaqtyy13Tp79LNY7IsupWJ4/j583xxxo3DPGCRhew7N9tO2jL6RVTTRuKicqfBBtEaSyYGll2bEU6H+sBg2iu45j6YiXNo84Lo7V4bTsHMyBLDWr7QuxrKRmuwhv+kPIUsK7G+/js3kog6g7V0rd44vhx9CiSnt8KDHyTp79mDv4EIVa+hanLmOTF+kqL55xJQw0HypCYITzhBd8cXFQliF
 P0DqzyoY
 jBvs2IWwf8eOjcz8DvShNUMbWr3HPYrQvsCWH30vmn3Dbpii0eUgs0zLy2BLRP+HyJHOA0+m/if+pwfUGxb0PMCYcZL7lPe3MHcHWMybXRRp9m8wOPx7i6D9NxcGMCpWJG1j0cCPQhadNfq0yyaRPS7VIUjgOCuQRoMrBNc5jXsUtJBF/md0TcQ5HgTHI+mMBqOmtIJJ9eKw9KdChYiI+ToUOoJUKBK5OhhiGQtHqeWKjCkwLmp0JUNF4cRSF4n3v7lPBPIsqgoCf7fSjVg1yukYCtLwCS/EyXAD0oY75dsIV20RGCvpYklGb4PUr4aJK3ukhKhvEhPdemC0x3UGUhqEvsXBiiS2gkaSjgnP1cMihUWJKVfp1QNEg2lP0QCwPngl/Kaz0hO5D2fd2JdHkZf+kd0RQUuGz61CBHVToyVic6awjwxbaNNtHcxZLdpNwRYZzlwpgTe3ePCfwB7vBLacX05/dMoXl5qrOF+dlCXuGe7xsjD309IqYJlq/0oh99vemT+bo3klanUIag0HPwXCZGaaUMumw5+Zm0olYrrNZpr9jwzkiODar3MeqdZxlkeDWUtxiGF5fhmE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Aug 2025, at 13:22, Matthew Wilcox (Oracle) wrote:

> Wrap the unsigned long flags in a typedef.  In upcoming patches, this
> will provide a strong hint that you can't just pass a random unsigned
> long to functions which take this as an argument.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  arch/x86/mm/pat/memtype.c       |  6 ++---
>  fs/fuse/dev.c                   |  2 +-
>  fs/gfs2/glops.c                 |  2 +-
>  fs/jffs2/file.c                 |  4 ++--
>  fs/nilfs2/page.c                |  2 +-
>  fs/proc/page.c                  |  4 ++--
>  fs/ubifs/file.c                 |  6 ++---
>  include/linux/mm.h              | 32 +++++++++++++-------------
>  include/linux/mm_inline.h       | 12 +++++-----
>  include/linux/mm_types.h        |  8 +++++--
>  include/linux/mmzone.h          |  2 +-
>  include/linux/page-flags.h      | 40 ++++++++++++++++-----------------
>  include/linux/pgalloc_tag.h     |  7 +++---
>  include/trace/events/page_ref.h |  4 ++--
>  mm/filemap.c                    |  8 +++----
>  mm/huge_memory.c                |  4 ++--
>  mm/memory-failure.c             | 12 +++++-----
>  mm/mmzone.c                     |  4 ++--
>  mm/page_alloc.c                 | 12 +++++-----
>  mm/swap.c                       |  8 +++----
>  mm/vmscan.c                     | 18 +++++++--------
>  mm/workingset.c                 |  2 +-
>  22 files changed, 102 insertions(+), 97 deletions(-)

LGTM. The change also compiles.

Acked-by: Zi Yan <ziy@nvidia.com>


--
Best Regards,
Yan, Zi


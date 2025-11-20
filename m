Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F978CF8860
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913456B0010; Thu, 20 Nov 2025 09:59:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C35C6B0011; Thu, 20 Nov 2025 09:59:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AE16B0012; Thu, 20 Nov 2025 09:59:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 614246B0010
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:59:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BAA414018E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:59:35 +0000 (UTC)
X-FDA: 84131294310.15.BD91C20
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2A379A0004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:59:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BlkcK9zN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763650772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okKDoiRa8XJlin71aRKzGW+yWmg5eIJfB8O99Jn2318=;
	b=z2JI/RTOCxtkRNAoVVvS7PgKVIj+X3lWvbit5xCgOld8hJLEEUr/t6AMARSllCdTwRRMA9
	4lzKf0H17ihvYBWw5N4jpVihDfdZFwz9sK03LF3CdGfqgmRcp2mkkzHzrnI307keXIFObu
	hy6riCntdqylE0puDNW5WCgePsVfUKQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763650772; a=rsa-sha256;
	cv=pass;
	b=W0HtIIvO3yWKt9YkJhoemG3TS2aW/82p5noKUyILvZCpyjJZzrp0GT9BnFKqXqsn7yh8ky
	4qYuwr47I8OVcViVnA8h+NFT4S6gZoXdYQIlurRgGQUL5BXIntfeMPyIt5lTv77tMiYgmM
	GWv/0Ef9sfJ94nmHqUF86D0FCPqgkqk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BlkcK9zN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.2 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gOclfN6bVKop2kNZ7FtYAvjLxuc04F+8fHvwPa4KBTaucpjPrVUH7B9/3IwL08C47/FR9huSmW8UWW9Zd8PMFBi6qQbd3zqmKfnZZTIXJ2ajlczN0lphVMyqgi1ITaHGLL/j/p/gzT2by9lmOUnRRkpN6h38gurWvjiB3Gy0M9oW6ewYYHVQ1SYb8lCDMuApYIovbPM6VtW2ia4dkuVJj7wiH6sjftJdytf9kaTrrGgQ+cwseCwX1pgmtzW5E/RDXjDSZxAb1QS/WAw1WVTwfOmSaT6DOBWHv/DtwJURuDisCKjfkJswp3t6GP/vEx7AxW38yT7jW0NpIW01yUW1Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=okKDoiRa8XJlin71aRKzGW+yWmg5eIJfB8O99Jn2318=;
 b=rW/+bKu2grMdK2ITR1fgQJbJiGMrHY2re+qb5ZwaRXtF3V2EohtV976H/9fGoPma9z+wYcaJMWn4ycKq5/wOt/fCbB6B/oije+m+RQbJo58pE/b/2qWltOJ8qXFrwV5RUJf+fj/lzhI0GTzKdszOL3xMlqiWVCfCLXIMo0JMdCQbdjWrkFZW08Fp+xWOA8cPdwlMbx0BRBQ2NsF7yaA5YyW7MMFRFbY74IeTkjuCku+b+UYVx8CKkVyoZ3MPqwZ/zXDgIDRDALowvTt4j3faNg6bOMtfAmgHKrcyatNV2C0F0QZJH5C5d6gHt3k3Y+tN9R+6Ao99ZtwrNfpFFEICsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=okKDoiRa8XJlin71aRKzGW+yWmg5eIJfB8O99Jn2318=;
 b=BlkcK9zN2syxmCEslUw1pfgP9T/qlnQGV7HEtnjzYyvbXbj0oYoPWzr3LqLDQQmVdroghKoMvzz2xj/B6VwouBgqc/xpOlJsej5z0gv0gQ8t/E20N9uS8hSyuzNgAI8ZCoUtRpMQTSZkw0o+FZNIz0zteWxe/XwN4/RrwzvHCR0rmN7ncxfMAT9msIUinKmCB+xc/Yo4Q7/W25Ty8vlrPbUaOlr2DQu0XKyB0JbjyUtci83+dvs9BnnN7h2V/X6n0RcPWR+50ViOP0xX2PPgELHUpqr3ilF+EF/7WiOOIOnHppZVwCPEG+aUrG33UgxUoAFFXs0p4fBn4AFxtfztbw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH2PR12MB4119.namprd12.prod.outlook.com (2603:10b6:610:aa::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.11; Thu, 20 Nov 2025 14:59:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 14:59:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] mm/memory-failure: handle min_order_for_split()
 error code properly
Date: Thu, 20 Nov 2025 09:59:23 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <03B7D3C4-F954-4CF1-9585-38D4E5B113E4@nvidia.com>
In-Reply-To: <bec37700-8176-45b1-91b3-fb47420679ab@kernel.org>
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-4-ziy@nvidia.com>
 <bec37700-8176-45b1-91b3-fb47420679ab@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN1PR14CA0027.namprd14.prod.outlook.com
 (2603:10b6:408:e3::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH2PR12MB4119:EE_
X-MS-Office365-Filtering-Correlation-Id: f5edc3ba-a344-4fca-cc75-08de284565f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6ArVoFn2jnEV91QsnMwoEh/6hrwbJd7PDZEtUG0s2Xv4O8IMvPLVV9pxzrg1?=
 =?us-ascii?Q?yngZGpDkNpjo5gE4uctmWexZEieBDAUjV5arjroo11AT2mjrrxQ059bBB4Kw?=
 =?us-ascii?Q?/xG2k1/DFdOwqxeeCaJtBqoTmeCbQXDJ1XmNYpur1/NVf/1pA9H09tiugZbp?=
 =?us-ascii?Q?5mAq+192Z3U8nr1ZyKWzgy2NKAy+HGEx9+z1SgyKdh3BId4gbOaNL/mGpo4u?=
 =?us-ascii?Q?glVT8I1ij8rZ53H2xn7t6H4Fu0sJspo4OTdy9h0XvLbH5QI9oq6aBt5Wwn8V?=
 =?us-ascii?Q?tpGxnJIJrq5oGDQlHmRqORo9f2VqxPfFZ/Sq79Q3DaTZv0PL8V4UlYmDLmko?=
 =?us-ascii?Q?gYaP6+TL1WjAvpYlrpnaDLgPxC/5oy8Sw9CiMtbiM9iSNxKu7Mr0+9ZadsCA?=
 =?us-ascii?Q?Mr7RjHc5d1dOzp/0UEgcppTNxI0BlrhhttI8gM0a9KqFNWiuVBljLoA4BMvY?=
 =?us-ascii?Q?/DNPw8bCWvCR3dFFLo17fxCCRIfnp33lVAEUz6iIx51nEj/Ako+IwzPbSAfw?=
 =?us-ascii?Q?jFyqXRac70eHBnBz8+JAPvKCxbJRLQpN1uz0lMyzofZF5PN2w5CQS6V64WoZ?=
 =?us-ascii?Q?xq43QyYJv18Qjkb5gStg8c6Q4RBZ1pf9c2jVarYrJHY1N9idkJP5TTwMMb7B?=
 =?us-ascii?Q?lxaoHJOxylMSw+yiseFI5o1f7E4ughMN44YdyzORYYm2nrUA6GaLXqVOsNhf?=
 =?us-ascii?Q?7LH/THG56BMO4Xb5qN+CdtNr5jNuCePIIXe9a5qneiWlUM7laqu+GaEfb6Ce?=
 =?us-ascii?Q?RHiPYjEK6J8UcWop1ScyUAasTXLjvuj7CLv9wfDpu80vmp19kOm1hnxEvucz?=
 =?us-ascii?Q?wYK+VozI4k8KmwQ6zP2HuuZXAJcj/+Vndib2yhIsqAewqkejTOfDEN1V/DdP?=
 =?us-ascii?Q?Z/JlVB5gAgfdIxofyeKOGKJAraYg/TyoejJsDnaRFyGTyXJFi291SaKmnFlP?=
 =?us-ascii?Q?kQhj2tD/yzeOflDwwsKCZr03xiASiHDW4QIegeAr3uyCybcks6WX/FhBsTef?=
 =?us-ascii?Q?its4qojKayhEquxWbJOV26XUwN543wsKFAOjjLZrjCNEsZ+1sttA+WzQgTo7?=
 =?us-ascii?Q?8wrfLCqursUWLfREAJplY5QKQ102oFZ41aF95bYoibizY+x9yBt04QVuDVAJ?=
 =?us-ascii?Q?s3yrLUX3JDPdDQISrF387Zp16HxIkbHFncxsBUL61FUulZCqzFWlcPD/HIUU?=
 =?us-ascii?Q?qlVnQMbSCWJqkE8hmYcgcTBOtE+pTLSr2BZACd6DYwyldOEZta6wGiIW57Fl?=
 =?us-ascii?Q?nTYz3GAxOfEg+IBAcu7euFSYBG+GJRPBPjB6OMuekKquAwPu9ncWFEUV2Zg4?=
 =?us-ascii?Q?mAzdKFem+A2rXsaNOlfp3L0wF+UpWv5zX6exdja/EgetBk3W6iD6z8KzZTRf?=
 =?us-ascii?Q?/o8XWJsGMMnChyISUBWzrVtEeyTcUQlB1ld6JleI/St9Ymr+1xrJwP2FHXXO?=
 =?us-ascii?Q?UBIojJSkwHdCU9SrTgtsg59r7y8RmPxl?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D6tBPDeaz+Qp1nJvP9yscW50Mv1QmtrDJCJ0mXQvkJmTaYVhTShiA6Ob2T2h?=
 =?us-ascii?Q?ee/0LJLx/z9E4BtS1DbDVScEt3m9BZExK74GIOOj9nomW893J9JMMwLLtTZK?=
 =?us-ascii?Q?K8k5l7iBaC+r9bh/I9pSgoBs4Ui5EYeRujomIzgWwkq6atyY7MmMRgp9yEgp?=
 =?us-ascii?Q?TPsE1cRiMg+tp1IrppHTn4Ymi5ohrSLP4aa4O4kLe9o7QDAAyQEnbmlwrK69?=
 =?us-ascii?Q?2XEQRdIH9Tz1ZUdr6N4ylvsI9giwC6IDjtafTLZ2Gqj95kZkbAnPTHbYPbOf?=
 =?us-ascii?Q?5Pu3e7XouwSUMbK6J8VrWJjrMnq1bbtCY2luUSPFalDCHWr/d65stnrZ5te7?=
 =?us-ascii?Q?KByS2vJHC0jdBkiOqjjEoT/b9wFrq8zFPKO0WgS5m3K2wuP11UOEPPvnWm7B?=
 =?us-ascii?Q?c6OrmanZ3maclTHPPYdXhfAnQhoSTh901dzEoKe1/uUpkXNPfAaD2mKPVkS1?=
 =?us-ascii?Q?ktZyqiut+VXtWun67jfscpRxbxMppwbkD71xPudwK3sahPoTjWXT8DD9K5GE?=
 =?us-ascii?Q?MxZ/+jbuujX/tBBj0PQ2r93xZAFxWttHHeHLvLk1LuIQU23ntuqiqRsCfxNZ?=
 =?us-ascii?Q?eigYQmvILh0GkeaCQjndO396q7kl0j/mid9p/uHH2W5yifnUTdtOA1t6rPvj?=
 =?us-ascii?Q?9CEOjQSwQ4DbabkkWL2+xeeuSOGK4WLnYWYPB7QZq8vXF5UWF5+PAW2pDyVQ?=
 =?us-ascii?Q?o77j0hxL7cnrFOnCqBxT8RP3KWYYTnVdTCA6pV2d/1LZs14GkOYzadi3eYjv?=
 =?us-ascii?Q?OEZTWKLnQrKq1WzP1IZMb0cdAZw7z9rsUWAFSNam4FBp/toCM8TIbLzgt2WG?=
 =?us-ascii?Q?vfY2zRTCqJgl1cHG7gQnTyXqwFjIWEwtdfbkvxWMIr2U2SjOxhZoL7BzQovM?=
 =?us-ascii?Q?gLMQtSHC8pvIveBejYftP/NwwdKefpmKwtu9k+I9+gAwJG2INOOI/wb4waob?=
 =?us-ascii?Q?GftqEZbwz5wAfGazow5YPVO5SpsGC+/WXXEaaU8Hge1lfpfGKXewawk2uf9h?=
 =?us-ascii?Q?HEDu1VGZ2lXEqKEMMiQScZwemzaa73s1fYHy1DMEDPJe3d8kb8VHtZ/i480z?=
 =?us-ascii?Q?9osEZeKELRWlhC+AXY5P5MoOT+rAh0fEIhfQQe/TQKOP/XcAO9d1XEPNQM3G?=
 =?us-ascii?Q?L+UMkkLVUWGkb93TXjcaep7iHz/laDXRj2B7VegQl8Yd32xqmn5X1SB9KeMx?=
 =?us-ascii?Q?HVD3nLZ1qESYhCrXEvEjiMeVwdpHpYy4vmLZuBn1u62aUOkFagRnkq30uppa?=
 =?us-ascii?Q?Xt0+CrX1p2ckI0Rcgg5uOwvNWVGnB+vucJrlxTdiTdERg0NbW0njZGdmH5h+?=
 =?us-ascii?Q?0aLwXJYDC7jOXmUBFd+QZ4C1NivTDVPThlv3EL11uxv4hdl2K1xSKWJdGDnr?=
 =?us-ascii?Q?DIyZDz7HyaCFivLobh266l7f0Wsj8Vj+2tebFeoQgUOx70ul3bhcmlnBcEGp?=
 =?us-ascii?Q?ptmHylMoeZRmhSBYfljJUhb83avyqLo3UQz8Ht+eaL9Cuv6mHqPEOxxUK/fv?=
 =?us-ascii?Q?QpU9oNoV7r6/yUJB6lSIi7gRvTz6JbPaUkxBqvYPgjH7d1TYd5q9sNrb46cT?=
 =?us-ascii?Q?nBD91TgFygTcb/DJlAojKjNZnUJ5g8xVNBHGiHum?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5edc3ba-a344-4fca-cc75-08de284565f4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 14:59:26.3058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r07kMuKSfxmwrTWLnvBInuK0QNOPKD+MVicEJvZ6bkwNtHo4Tj4d+dq2HunBNbvn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4119
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A379A0004
X-Stat-Signature: nyey9oooxyqrke6ji11oonjhbjs1mtjc
X-HE-Tag: 1763650771-543678
X-HE-Meta: U2FsdGVkX18fAjZs08Sf8CjIqyIShuSTvvRpn7h8uvsqLxI5zpFkP7vhEGKtTG+eCaZD32NpheJfp9oXvJj50a5JyzqqcqszNA1KVarDjkdtomXZf9D3kQ3fx/buGPKeD2OuASADZuWqzY6grvdRwgXyuySpypZQJbMdgtIbaPqkrKVILRf2sMEtu3Q80oDA7Vi/s0JeFVaQPuzB7yFi7auqbN3E0IoK9As5tIrK6GzKwKbNgGOA/LlsKfESqaYU5bNRdDDpJMoTFyjgWZQWGWUZpnt99nkodEJ7u7RrINd6nlrrYHPJgaa1QIlGnGsFP+uq86pvrOZGsLr+3qTVroPvuW2e1Iqz0I/QvYJYFYxRxgdE3FzaInxaCoqBvGr0Beo8mIbHT+HmSjINUmU8D4cPtbVOWnNYoGCXguvTpTF4RHziuZyt042kKSjToFd/IU+viWbA4YtXXwDdIy2n664J0uRzSfH+h+dvuGGEDkPKzTtt+YUoss3/iLTV3r9XPhIGhlXGf1MvE/uH6RGJhExpbyPkt97vJq/d8+L+eSd20DeJvTSVHANacCRCwi/k+SC05ZXZFFziF4BXu2TDseP5XjzgIkQFzGPeB06QGN0dE49mUV80EyoAzBRgH6+B/URZh7VquQNZMDv/qpEWyPpXZ5Qm/P/9swbU0T85si/cqIjaN2kzm57KXHWfhAopqxyZ/jKg0N8wmkDlMsE+2Oggx0xLpKbytgyadJ2BgPK97Ea7lfAHX+3eojGy6eccrejZuRzlAv8LHZOlW8SYnIBy/FTjBiNzQlETUD3ACGBcwFA90oJH+4+/gdk67wPJUqJ053coiJBxiXdnly9JBRa2T+u1yySvBqK2WcrJ5tKfF/8uhWhYALLv4qDTT+k8zoAIhRS8irVQyhuNeuGwhRuE01Ypu9lgUUgd6knvOx6o9i1L55ILuxgMcXNciJgTWyjhcoTZgf8tG+m/+Zs
 h3dnDdtu
 8jye+OU+hCLqb+szhdDhqTUCXejYgZPH6K0j9AIh5TD6qyPEwDfQSH/Ci49HBhgYp+L0/VDylS4mWqbH1h7vYvOytXPP2pOEnuZ9j8XrKdZbWDIXWVXi5PLO2NmqdvdEn3HDfo9tmWFZZjUZN+EntCcb9wM8p4Sl7ASUcWhCIvJFEiQGw9E25NI6QamyOHT3nfk9fntVM1IXavkTtcgrj0UVq7aUglE20wfoBEo+t0yFrecOgVu+7xZUmmbOL03axeQsLMBvJe6+nDF1cB1AefKJVlGO9FN6usZW6bG+kSTNLeTps9NQDAlcIXHt56DjgJ/BIg9HxwsPAbNoaVaLZBSAgtPd+9332qtjFQTidSx7OUrXl6afC5ehzTVSQ7ylZ2bb/TzXghYmOtFcXyolbIvPV5oLrDpZ0rgMqoWFC0JOBkjF/oyd1QyLYJnnHGqUdxL+G6sfifin0BWQ0yVBD4ol+rhk9PcLw+m5b/K0YYTzNlmU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Nov 2025, at 4:37, David Hildenbrand (Red Hat) wrote:

> On 11/20/25 04:59, Zi Yan wrote:
>> min_order_for_split() returns -EBUSY when the folio is truncated and c=
annot
>> be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
>> split_huge_page*() target order silently"), memory_failure() does not
>> handle it and pass -EBUSY to try_to_split_thp_page() directly.
>> try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff=
0 as
>
> I'm wondering whether we should change min_order_for_split() to somethi=
ng like:
>
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 7c69572b6c3f5..34eb6fec9a059 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4210,16 +4210,19 @@ int folio_split(struct folio *folio, unsigned i=
nt new_order,
>                              SPLIT_TYPE_NON_UNIFORM);
>  }
>  -int min_order_for_split(struct folio *folio)
> +unsigned int min_order_for_split(struct folio *folio)
>  {
>         if (folio_test_anon(folio))
>                 return 0;
>  +       /*
> +        * If the folio got truncated, we don't know the previous mappi=
ng and
> +        * consequently the old min order. But it doesn't matter, as an=
y split
> +        * attempt will immediately fail with -EBUSY as the folio canno=
t get
> +        * split until freed.
> +        */
>         if (!folio->mapping) {
> -               if (folio_test_pmd_mappable(folio))
> -                       count_vm_event(THP_SPLIT_PAGE_FAILED);
> -               return -EBUSY;
> -       }
> +               return 0;
>          return mapping_min_folio_order(folio->mapping);
>  }

I thought about it. My concern was that what if the returned order is not=

immediately used for split, maybe for some calculation. I might think too=
 much.
Your approach is much simpler.

I am also going to add a kernel-doc and change the return type to unsigne=
d int:

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 0d55354e3a34..e0731e01df27 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -373,7 +373,7 @@ bool can_split_folio(struct folio *folio, int caller_=
pins, int *pextra_pins);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_he=
ad *list,
                unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
-int min_order_for_split(struct folio *folio);
+unsigned int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool folio_split_supported(struct folio *folio, unsigned int new_order,
                enum split_type split_type, bool warns);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 23239c19b36e..f45560b53210 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4238,7 +4238,18 @@ int folio_split(struct folio *folio, unsigned int =
new_order,
                             SPLIT_TYPE_NON_UNIFORM);
 }

-int min_order_for_split(struct folio *folio)
+/**
+ * min_order_for_split() - get the minimum order @folio can be split to
+ * @folio: folio to split
+ *
+ * min_order_for_split() tells the minimum order @folio can be split to.=

+ * Anonymous folios can be split to order 0, file-backed folios might ha=
ve
+ * limitations at file system level. If the folio is truncated, 0 will b=
e
+ * returned and any split attempt will get -EBUSY.
+ *
+ * Return: @folio's minimum order
+ */
+unsigned int min_order_for_split(struct folio *folio)
 {
        if (folio_test_anon(folio))
                return 0;

Best Regards,
Yan, Zi


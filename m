Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D3FBCD6E74
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 05:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3058B6B0005; Fri,  5 Jun 2026 01:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5EE6B0088; Fri,  5 Jun 2026 01:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4636B008A; Fri,  5 Jun 2026 01:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5716B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:17:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8332F1C278F
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:17:50 +0000 (UTC)
X-FDA: 84844701900.16.D6F235E
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010055.outbound.protection.outlook.com [52.101.61.55])
	by imf02.hostedemail.com (Postfix) with ESMTP id C28418000D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:17:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oHmXrkDm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.55 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780636667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kVGjuyNW6PtTD9rx3nuqtJOchGRH6xNORU7tewied3k=;
	b=LlKYuTmeQ9UnwurbNT+XToXCfCQz5YnPz43GpOImpe6XavQV5B4rITsJqcg1vNkpBtcYU7
	uRLgRDKYnwBBTdICnLHqJLUit4DDVTSqLxgckxXytm/LDga8rk/WaQkCypknpaVfipb7/4
	EmSj4TLme4TRqCuJG3BHcxnEVVtmE1k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=oHmXrkDm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of apopple@nvidia.com designates 52.101.61.55 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780636667;
	b=VzLMuGoElwQ/3p2LnVRpSb3VSv3IdCXQJtK1PoEnoA9ReQCiJXNFYJJcuQAz3pIAa5gXcq
	J9pgN8pGrcvErkrQerxeBvZSUgpGoSIaCirkbmP0jFKmCfPaF9hRL6hleWxlr8N4pGBN/v
	O5TPMWd1yMVEj4n9KZLmse/AU/LJQyw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oWMVfDKlaXiyVrXc0mQ7FCNGXPMHLi4OMOku8UYq6ztJq4dXkDHsSgUJK5mcAEwkSauq+gQZ+v6PXnV2Q6UNr7f3F73kTXnKKmlf4JvYAApsrlGWcKxTrI25Mxx5D9aa0JEzGNm6PKdvpqA7KiQTHlByDJBcQc2sa+TsKhleUpUTqhurccBSh+eQLdzM7pFUf5F6iy3Gb9sXeXzxG9oyxzHvwTyyN53jCYuWbO19L1R71hCG4CsHe7xiZtNKllrdGif5kMSB4L3aIMMeF04PZPFj+oER/DnUPpGw7WhjCEJh7pIZ1mmlbO/aXxORCQRZBDaToeQPA45UOogh3+1waQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVGjuyNW6PtTD9rx3nuqtJOchGRH6xNORU7tewied3k=;
 b=RLR4VzCKw+lzEcj6TsEVMnM9W31r7wVt3hkaKdHlNG4ICwfTqZkcSaml5TksDsO40GCP0da3zqIS0iXgWX/pVothYhMqvx/1T0FxJOBP13awlPqMBbYKu9K+bgGkugTwjoEy4c9dMChA3iltr+OCw2Uuf72QutW0CLHYpFG72e5iYj/h+xb1A5bqfYJHBQY81n6VBq/OdvuDVDOFRmZCr1TNXmh6hOEZ8mmtQFwehzOMBnRjI8mj2ayNcmp96j7gXdlWAt7r5VLN8ry9lua3KeJktK/pg30Rfj4hxnGlpYaCuyqqZlg0eyvd93J4+9HNJDUx/SjcD12EAfdaX4QgcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVGjuyNW6PtTD9rx3nuqtJOchGRH6xNORU7tewied3k=;
 b=oHmXrkDmNglYKSQlVL9YM358feryQLCHWZu970hT6TPY3buJBSh2an/6N1iSqqYWQTALYO1hhoDroBCJhJTOT4NAeMn8sDAjVlhXWqsQRaK46z3No79QOanja+D2bKOwpAFbsk482ND9a0rZXGJWSUpXdigYVPdov82PCak2kPCJtgZiu5hdZmQ3eR5dwSPswtW60pikZF3H/OW8Ft/gTQUMl2WLisYabHdH1j2WuV97rRaixZfGzBA7Q0kjCeMZ84iuSRlIsVaSk/JHBcapQcNpjdJMNEXlUPMPVjqGSax8UeYpIBgzCtt9Ax/3DHxJB4P2HA1xu5HqJYmOwS4UMw==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DS7PR12MB8203.namprd12.prod.outlook.com (2603:10b6:8:e1::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.8; Fri, 5 Jun 2026 05:17:43 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 05:17:43 +0000
Date: Fri, 5 Jun 2026 15:17:28 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Sourab Gupta <sougupta@nvidia.com>, 
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
Message-ID: <aiJbJVbD4W-y1XDg@nvdebian.thelocal>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
X-ClientProxiedBy: SY6PR01CA0072.ausprd01.prod.outlook.com
 (2603:10c6:10:ea::23) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DS7PR12MB8203:EE_
X-MS-Office365-Filtering-Correlation-Id: a0ef39ac-ab74-414f-0186-08dec2c1c53d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	mBOgQeNpRA7WdAIHV8AK4SMP9cmwOoB+FXY0StAmya+0+sSILUF1pRXQl4kOlREKGCzPCDTdrojXMYQQLnCLG/vaOCk1/hy895H3bj82ouiZd2tUijKzTGASKmDRoQD93LMcD8QRxohXaM7NlbTcJo/gnPKXU/q0zWvK3yjPAId5TcmqYPbPKgxzOzwsuc4nuchSB5tJ/r9swOVxiOjAFZ7Ldjjlbnam3xcJoU8kP6YBkAh0ORklXOHOQ5DyEd5tf+e/WuRxdtIFU15BmA4e7SmahniKlDHDjs4KALFKxMHwr6yLIimsMUS1pZDr4CmlMllNlS0+gBdriksjfRAFVbSvPs8KGLEGdlH92SGbw0iEDYeVTDkXnslBprJ//AfMEtGKvJVzJQ+7bGU6orx40Tyf3GZ6buFJNSlBZhZQOBJri+DEA6JKcHiQ6oWoRUw0Y1A4GrczTXL4hXQcZasVdiwysPsG6zTBWYW0+yF3WJ/RhmNT1qjRqiLkOq3Onj+56pcMqns8IoHOpOzB0Cv+DajpI2zSYS8JTJUhaCejvydUrOZVFJPskOIsvGvp2hJP3kqKVbdti+h9UdnS6rCtmcDmjaW/jb1szc4D3eh6trU1vfXee8Ccu7uZagOGnRhtgAoo7grfIsWDLNZbOs6hNF7/jaY6jJ43bXTs1hS2r8K+WEmLDvKJLUuBgvc4XcqZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vHZVyg2yVW7lXOoi8O8o8mgfatswCcdg8i750Rx8zTSTCAzZOV0/3JRjbVaR?=
 =?us-ascii?Q?RsMpNBTqsxpQALFzY+bzGpxWs8+guvhOKcbEPVTzzpoYgs0Tpu6hi3QUvhZj?=
 =?us-ascii?Q?eobIOp/SMriQNbzZR/GeLCc4A7kibUqzH8xcI5TJn5YDjdVmIVFhS5CqmnFs?=
 =?us-ascii?Q?pCilwNEHkDOJ3V44xh40JEwVJFBeWHCKvDZyNVMbUw1DXvfoyYpGCfrBdmkq?=
 =?us-ascii?Q?xijfPNRLExEG6gkVEIcyeeZ9zwSIb55RFwsBhBzZGpkFK6DTFBD+h406yyFf?=
 =?us-ascii?Q?o8o83ctl1FDFyf49BoLaaE4VaJRrrw0bcT8iuphi0LeklXBNjxVTAysm+tIl?=
 =?us-ascii?Q?5061oqVHCjEgJKcRPrdNyDGI12n55BEk2UKFWb/WDEE3ZAU1Cu9xccVpsLqV?=
 =?us-ascii?Q?TTTVlyRRDXrEsIZyargEc3k7i/iMP02WpslQppcdq8WTwvKvhCO2XXBCBwgm?=
 =?us-ascii?Q?LmFZQewB5w067b6QEkMNaCLWOg1kKn7lh+VopT09mK+G4F+KIG+qVsggJJ1U?=
 =?us-ascii?Q?QADMZiWxUYu/Lwzz8gcdo7DOd6D38JQ/vhk6FskziBb9zKC5irFSDDV845aN?=
 =?us-ascii?Q?pwpW9ZZ+5uOUrfXD/7qteEt3DfQZ0brzhe/CfTl4iW827VtNtwiqgIBLyxlU?=
 =?us-ascii?Q?dtLmSWyGtAcr4ZR85gTMw+lXO90nKiqGRU0i2whfgow066BK2y/CdSQ29xj+?=
 =?us-ascii?Q?XazYJyrZmF9UYWriTmMwbhl0fjEiHd8gKzqAvUqajIrxHqyu1gIFz9CyRVA8?=
 =?us-ascii?Q?yGuDvgzDlnV4EmYASGK1CIEVsXLODB16d9Iq5/n3v0oOD9ygNSfSkyQ/fsci?=
 =?us-ascii?Q?HvLItlKtRCIm5qnm08dUbwKaDmzYHkAnU5NVs0qp/JRBnpwrEQTS2oyZL9n7?=
 =?us-ascii?Q?xRZC4lkOLrOG7OFLuEs2dm7vb5Qz/D5oDsxgiTkyiRTjhNwtaXidgXh2EmOa?=
 =?us-ascii?Q?XiH7QrWcQfQjGZJjvRWRAnsIe2DZLqlWigA3VQ/LSSFVeCWEicbLjqf0o4fD?=
 =?us-ascii?Q?G3uIfSmkT1KxkwoyTJ7Ljpl6HFVp+vQozfLGqWBH/lv1n9CCAc022I8JJQlJ?=
 =?us-ascii?Q?eX12nD4fzxcvXC9Z2zPvqciuluFJNziGpKEw+24IfTOA/d9GGpmqFvFGySMu?=
 =?us-ascii?Q?FYAjH6mMSbi2aJ+0CjFGAPTAhp9XTxBo2LFIF0Ow3D0VfYPyPQiRTSY6R3s7?=
 =?us-ascii?Q?KlMsufftjguZyIwHrPewqJ3nLxoueloBrOU7aTcCSjFtYU0TPY294M+Ulviy?=
 =?us-ascii?Q?xaIlax+u0LrcmtafoB11cpojw2NzGCL01acn30Xv7ax+V6HyBqsm95kfJxwk?=
 =?us-ascii?Q?fARbLwNyogi8WCYLbRvnJsKjCJSsTkY2Lp5OkAIYSJu+PXx6TtJLgtA6U6ZG?=
 =?us-ascii?Q?XotjH0E3es3TdUjrsGlbbFLev4zEUJZmmNVJ3LjVF9OoTzh5DGEqCwSkOgj2?=
 =?us-ascii?Q?OnmHMETBtuDTns2uJKr2dLk/QVjvhWKxYWKgI8MRYa3u7ERGUCoSabpmyIKY?=
 =?us-ascii?Q?CaSj8TwBcxNwVcxsdaN61Ebi6CgCXZVFDdH53zDjgusy4eOwKQO/4CmK7o3O?=
 =?us-ascii?Q?fjfJNoihQx2533jYeODt7NDSn/RML+o1zRhLieDmN5+eTcscLifBiOdWpm4m?=
 =?us-ascii?Q?xlboV9rOCoy39quEUdK6yj5N8D5VScgoD177RMDkATYTBYUYWNnayM+LCh6v?=
 =?us-ascii?Q?SMGkvLrtQorGwqcnwn9V4Q7Q+GddLP2ulC+YAiRN/4yxMPuL/NTEULEuutT/?=
 =?us-ascii?Q?Jc+LSDlvAQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0ef39ac-ab74-414f-0186-08dec2c1c53d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 05:17:43.0776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XysZiXQjKuU3TUICsveSQewEDZ2bAGVEzqH+gRfTZiJGoAyXuf6kKarre3YV8PRXFLU7+99Yo43qe3fubkWxoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8203
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C28418000D
X-Stat-Signature: wj7zkufdysrseocddwra8ez8cei5epmz
X-HE-Tag: 1780636667-79219
X-HE-Meta: U2FsdGVkX19p4qfrCTSujU/k7t72bD9g//Ov5frq0Vx+TPRp3knP/L6dLolxioFr22+cADo5C7rREsF9LfYFjvs33knQQP9Dn1ub2oF/G0WCzwpifouQ/G3D9ik4+b1ncno0kM7xa8Ea8AJR25fOFaJ4hOJmPMDKuxt5zFkXBINWQLQXKbQ4O16Qaxaxt0cQGJP6YDzkR/7z6FEs9IxEgsZoCwIzmZmewpQAbx9+yVnNNKKJ0/WMfkjI3uhcRhu918QU4pCJecIdm+UMne5TDITvAIZFR+9SdXC7gq5eR3cGK/xQ6uTNsccelKXesWzd4Konh9VLCqwSYeRSYFueKgoIQNRpltOYmRjnTGyuV/X5WtYC4jLi/n+7qwbBKuySOoPSyCK4CsLI0KIqOWmMJrv92/JGWe9Ruw+ejEqbkeOkZoZFoPRMZKD/k3h//aeRNhXqAAkwtNycoVM5mlZhloudlYu1dh2A3HLnDwRvpiOd4EkwIzN8ejDhTTsd4fkmk2LXXsFb+kRP3F6JtzpeMO9Q+OaZYQXjnDd3aMJMAEmGXBNSWjzjV5q0UFKGrDCaVi4QsV6W81sWNg+ccqm8FO6+SJpj3Z1+R+bumx1ZQzNA4X7xfz4v4nGBzQMfTmkUa6HhoW0CG7U0vm09zNePx7UvLum786eOdJKgrYu0sNIJmTY5I+4263sGbiblSUH6+lrX57j4m2DSkHDfqwSv9wFye9qCCKlqX0xwaOys1AYuxSjwbmcQqsPWAwKLGuEzjcOO5iow11GmdWPNQEcnu8HK9QVyHrfT7Eqatwl2+k1s/giT44HIj6HOBi4u1U5Ic+vULDLcnb3/IvFB4nJzzljdefOo1978hIW3bzkqXQxKFnpJmkBTxicVii65AzpHz//bR/tkTWvFkw+xOn+4P5/55bxn+w512j+psU8lXvwRbsEkZ5iU+tSvSYn665AmCz+tqh7CWSb8G6DLJeH
 Gn1WLkX+
 xcDin+vnzhMEZZr9cWINgopdu6sS+TxJrKVvR6nWGQUMh/jLnmeQ9/DRK7SfLl26B6vwlb+vYfd3Hy26B8dFL2xO4JA3Dc9uWgPdBquAwfaTPp4T0US47bf0YJb+EAxhQ+YEZm0hI5fUbEv9FCaFi1pJzDyCECxJUJAgcvcRiGVbEZsedTZKUfetRu76Hpxr/k4P0BO8XGw0FkHiD/3GaHzD8bm5+c2akuQflwA+IO6WhvcqUOzKFuUmAVMuzg3lN2KlTzAQQ0TcOrldHIwseBgeo6skUj4S+4fQg+Ni6L1RiKfZGM2exV0Pt8+6QaoZiRFvmLelbm7ZsuB61cCBnCyNXKbWQM/yaqyH3C3vLF/5D8j6FAV+kGr/SveXL3XQqiYvLyA1vm19pY9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-15 at 10:09 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
> On 4/9/26 17:52, David Hildenbrand (Arm) wrote:
> > On 4/9/26 03:46, John Hubbard wrote:
> >> Since commit f002882ca369 ("mm: merge folio_is_secretmem() and
> >> folio_fast_pin_allowed() into gup_fast_folio_allowed()"),
> >> gup_fast_folio_allowed() falls back to the slow path for any order-0
> >> folio with a NULL mapping when CONFIG_SECRETMEM=y. This causes a
> >> performance regression for drivers that allocate pages with alloc_page()
> >> and insert them into VMAs via vm_insert_page(). These pages legitimately
> >> have a NULL folio->mapping, but they cannot be secretmem pages.
> >>
> >> Secretmem pages are always added to the secretmem inode's page cache via
> >> filemap_add_folio(), which sets folio->mapping to the inode's i_mapping.
> >> A folio with a NULL mapping can never be a secretmem folio. The
> >> NULL-mapping check was intended to handle truncated file-backed pages (a
> >> reject_file_backed concern), not secretmem detection.
> >>
> >> When only check_secretmem is true (and reject_file_backed is false), a
> >> NULL mapping is sufficient to prove the folio is not secretmem, so the
> >> fast path can proceed.
> > 
> > Hm, what if secretmem folio just got truncated? I hate to rely on some
> > handling in the caller to detect truncation differently during GUP-fast,
> > but this function returning "true".
> > 
> 
> Can secretmem folios be truncated? I assume you are referring to
> ftruncate(), I am looking at the setattr implementation of secretmem
> and it does not seem like it can be truncated.
> 
> > Zi is working on a way to distinguish folios from non-folio things: that
> > we can identify whatever was added through vm_insert_page().
> > 
> > Because that's really the key problem here: vm_insert_page() pages are
> > not actually folios, they just look like a folio today, but looking at
> > fields like ->mapping does not make any sense.
> > 
> 
> I still think this is a short term fix worth having until we get
> Zi's fixes

Agreed - this clearly results in a performance regression and we have customers
reporting it as such. I think Zi might be out of the office atm but when I last
spoke to him he agreed this fix should go in for now and his approach will come
later.

 - Alistair

> >>
> >> Tested-by: Sourab Gupta <sougupta@nvidia.com>
> >> Fixes: f002882ca369 ("mm: merge folio_is_secretmem() and folio_fast_pin_allowed() into gup_fast_folio_allowed()")
> >> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> >> ---
> >>  mm/gup.c | 13 +++++++++----
> >>  1 file changed, 9 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/mm/gup.c b/mm/gup.c
> >> index 8e7dc2c6ee73..3ea661e67eea 100644
> >> --- a/mm/gup.c
> >> +++ b/mm/gup.c
> >> @@ -2784,12 +2784,17 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
> >>  	mapping = READ_ONCE(folio->mapping);
> >>  
> >>  	/*
> >> -	 * The mapping may have been truncated, in any case we cannot determine
> >> -	 * if this mapping is safe - fall back to slow path to determine how to
> >> -	 * proceed.
> >> +	 * If the mapping is NULL (truncated, or never set), we cannot
> >> +	 * determine whether the folio is file-backed, so a long-term writable
> >> +	 * pin must fall back to the slow path.
> >> +	 *
> >> +	 * Otherwise, a NULL mapping proves this is not a secretmem folio
> >> +	 * (secretmem folios always have a valid mapping to the secretmem
> >> +	 * inode's address_space), so in that case, we can continue with the
> >> +	 * fast path.
> >>  	 */
> >>  	if (!mapping)
> >> -		return false;
> >> +		return !reject_file_backed;
> >>  
> >>  	/* Anonymous folios pose no problem. */
> >>  	mapping_flags = (unsigned long)mapping & FOLIO_MAPPING_FLAGS;
> >>
> >> base-commit: 7f87a5ea75f011d2c9bc8ac0167e5e2d1adb1594
> > 
> > 
> 
> 


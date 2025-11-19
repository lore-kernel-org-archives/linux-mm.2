Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 743EDCF34B7
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 14:47:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1BC56B00AF; Wed, 19 Nov 2025 09:47:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC116B00B0; Wed, 19 Nov 2025 09:47:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B93F76B00B1; Wed, 19 Nov 2025 09:47:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4DE56B00AF
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 09:47:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 543B01A0514
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:47:15 +0000 (UTC)
X-FDA: 84127634430.01.55F93E6
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010033.outbound.protection.outlook.com [52.101.193.33])
	by imf20.hostedemail.com (Postfix) with ESMTP id 777E71C000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 14:47:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aem0fS46;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763563632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v6TBoGDheUhq59Fdt7TPRSMgGcpCRm0VFfNRhTbGDOc=;
	b=PV+OWem6+CWPsm/qjCHHeOgCmacoJf/ePgB5sLlBDF2MfXNf2acTEQVXFrCR9+tebNWHvh
	lw9qqf+UJwwB6WcMnrSGy1Q24qc2hTfwhafrj4my1w1BaCUErxN7c1LgdNx+OpEGl/WOMj
	3Wyar8BdmJDNI0iiBy3Zr7r6B+rMjlA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763563632; a=rsa-sha256;
	cv=pass;
	b=v94vYpfaKtvaQ3X68F4SuG5MEKJmfQrb6Znz8KBgXPxqNbe/6zbRkJZ2kFjDpE7mLK6mmy
	p6/ZlIQjwMFYo/beYMZyJS3Y6KB1XmLYrGMwmGDKUONgIDX3NPC69AyqOKoZ/a/HP3h5SR
	LH1fq5HmRLiQ4PP6tQcQtGoV8UNHnkc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=aem0fS46;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EXPvgpBCM6QzsStnCyro+dPQE2SZ8EFn7dyTQufh1j4XB11v5NC9EcJE+9zjoPCuFjtnCBhQs64aQ8tnfPjcJ0jm0KvZEn7KvkNbbU5qmd2mZZntzW1mmvWYa8ZmslzjUNxZNy1FeKgPuwL3cYEd0kGal0jgFsZ0uSHEM4IzABJwRfFKB2P9MAfvnIJxz6Roin8kW/CDn1+CrjO5cNjeXH+PwssC2ote5U54gaLocpwI7sijmS8olIGIfK7V6H/DUl16ZfMWTr5im8FeppoNfHR7dXe+8WVENeS7/GJWMi9rRvK6JSiynhaCI+MqHMr9m66coSxdk8+B4i9apOuKvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v6TBoGDheUhq59Fdt7TPRSMgGcpCRm0VFfNRhTbGDOc=;
 b=Qi9INXMrKeRd588IRmOX8DDJiotyzIIfoyAaHcQmRW4FXqiotbU127BdLviWf2zEy00iMSVKpsWA2xD7kHZWzpnVth9ZQMnpKXBmjnFWkdMBMOqGaz+jdOE+Bwwd00foUwKVKODsQ3uWo4dOie+szbjYeh/f36VGDxFK+6ALikMyNkvKtJ9OyFXi1fWFeKL+dlPrPVQxiSypmMaECjLOH+P167SzPdxQKbjCDDJi8zdy8JcwYvebHnJawE1s/IFDile3uzKPidEHc3xomc1+sk44D67KB7YcxbZdal7CNIcyRZgK5DD/mJHu7TfGSByoIMb55XjWslwE4h0oDdIUMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v6TBoGDheUhq59Fdt7TPRSMgGcpCRm0VFfNRhTbGDOc=;
 b=aem0fS46vtu2jfLn+pMkflFJM9kLZfgYyxewauK+P6taG2ukgwvDlKxA/uKOBGNldoSRWWa8DnkmzazTK557hfvqIrOIwMSjIV4vun3V8Z0TFo51bcgBc2PUNwq+JGjtMfylfIhtPCta2hW6TiqGWr3TU94e8eCdfazXTFSGdqZvMC3Clh+PVz3/ztRcxNly3NrMVX8t+jDLKm1PFR8wbjwFrra2Y056OnpVTA6S12DNjoswf+ANkkKpcLvmkwRP1p4FZrZpFWkoAjbDJh0eJAMC9gzIduIuuN2cMKHmq+SSPaQsf13N4aUaM39Kf6TYYZ4KCrSxzWRshviu+TXQqw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA3PR12MB8761.namprd12.prod.outlook.com (2603:10b6:806:312::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 14:47:08 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 14:47:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix NULL pointer deference when splitting
 shmem folio in swap cache
Date: Wed, 19 Nov 2025 09:47:04 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <034F3861-EF4E-45BD-8E45-DD551A1DE20C@nvidia.com>
In-Reply-To: <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
References: <20251119012630.14701-1-richard.weiyang@gmail.com>
 <a5437eb1-0d5f-48eb-ba20-70ef9d02396b@kernel.org>
 <20251119122325.cxolq3kalokhlvop@master>
 <59b1d49f-42f5-4e7e-ae23-7d96cff5b035@kernel.org>
 <950DEF53-2447-46FA-83D4-5D119C660521@nvidia.com>
 <4f9df538-f918-4036-b72c-3356a4fff81e@kernel.org>
 <FA37F8FD-DDAB-43B0-9BEA-2AC25986767E@nvidia.com>
 <822641bc-daea-46e1-b2cb-77528c32dae6@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0016.namprd13.prod.outlook.com
 (2603:10b6:208:256::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA3PR12MB8761:EE_
X-MS-Office365-Filtering-Correlation-Id: c44dd62c-f315-4696-b929-08de277a8304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RyS6+owQmlnPIZwSKmPWu9aNZ4eDiKiMn5z2CblahbiLpUSrEz/uua3ONGU3?=
 =?us-ascii?Q?78dFuDADjZREK4R9wwURD+jTo3/2EGh/XD39eG1RDGwffxOl8gdUC9focfWq?=
 =?us-ascii?Q?W1c3sl03jqetorshUSIj3NLhzbMWACBnCBo5pdk5TXOC2L9AE+zogyFyXl1Y?=
 =?us-ascii?Q?M5a2Qh42Ja35NbLw9WqNTOrKZwLQoZYlNOaLPS+J17d4TwnuDriVOXFsFX9u?=
 =?us-ascii?Q?ufYP0BgJ+648UjiLPPItPxslqTKCJUY4VFEPT40Fo6XPm7Lib5+ScqarB5R+?=
 =?us-ascii?Q?TyIHmAztdOvt3Y37RiKARdR/AWfH09h9hQRQvyHgzhJB5vlCiNCUw6H5Xf+6?=
 =?us-ascii?Q?/OI39ef++cxnm4hk/ddgss7UinF5H6KsfsTGXI0/f33IKacbuCo3VkZX+EIJ?=
 =?us-ascii?Q?mmjkXbUrWu7GRovvvIWcr5e+7ov+kpbnEBWWQ2nMNja4b0kHubu/T3p0dl4Y?=
 =?us-ascii?Q?YSRMGV9qKMuIewV32+VI5AHtRyDrQ3fgt9Rj9lP4GfBU6D9r5JR5j35FTySR?=
 =?us-ascii?Q?ijYB7qN4lFNWCidS180WSzb7BJgHD52ljTFo7ZV7FW7Cy1IA9qBY8WJ7pd8L?=
 =?us-ascii?Q?CwYCHN0yVNl2Hbyl7sFV7ndsYIXU7zUMEgxOniBnBEyL1yLE8K/W/houxPeU?=
 =?us-ascii?Q?flRzeewZMkZJjEpaYP7uSEOJ4gI1rUgpJ/DusnnHNALB1d/3FBL9KTb5vDrQ?=
 =?us-ascii?Q?Ovh+8ficd/UrPo2QR1+slhJNkqbgSubEIna8fSETza3U6EhMJGGvVJw3XoVD?=
 =?us-ascii?Q?bkEKkDgr9G/YnCjdZHZPgoeSqg4IjDzOu8FVmiE/sCF5xRwOtZMHHCmC+582?=
 =?us-ascii?Q?VuBcc5gMoVSfGcXX4l67Pf9V61Kzb3dLN5WLjocTkGTVjyYAZIgTwSWKSiIA?=
 =?us-ascii?Q?TSRSPvEN5K9NpffojjUgtY3DvivcQp6JP9xg0BjfVPqjCunVTMC2Wo1Fc5xO?=
 =?us-ascii?Q?ux383ZSq0Y3zIeA6ie7pA3YwQQuK7yZudoSEav7Y0/jnKN5/hLWE8CGHqyFS?=
 =?us-ascii?Q?6dDXFRMbqK/zVslftpIMtJX/4dAOuvmVn5cN958os7zehOkPhFm8WZqudgzN?=
 =?us-ascii?Q?OTjdW4QP3LT9/VrzNu3OGemazx0B0bI1oW8i7lJQlanphmTOE8Vyy6ra7B6O?=
 =?us-ascii?Q?4DsF0VtGUkWX7Jr0C9aoZbPws33gKTPJe9sFLcti8YFin2cBKaI3J1DamMdJ?=
 =?us-ascii?Q?sJbC+URc2zr94Xy5LGpVijgq9QCKQqsrHK6VWt+NowV+oFYbO7htsUOqw4Bp?=
 =?us-ascii?Q?OMh0Sg0Wa+dyIFcr87ZrwNup38mg58h7axt3bpBCAWLD2zq2J6NUWABq4x+/?=
 =?us-ascii?Q?TOZzJ/tOBZi8c11BEKb7gXhVaVesoHz1z7Gaez8ItFzyakCTddhwhbK9o4u6?=
 =?us-ascii?Q?phH3z37Q+aBDFmAc/byF38xxupCb0hPhcg+3DZU0iryxXEsi4N7EJj+ZzALD?=
 =?us-ascii?Q?ooaqZ193Kj3D02OP9hfnQnVFxx8VLojc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8qOmFxq60cZg0lnu+dDke8O/pFOdHz0N0BVu+ja/JogyJfkUPYxpCQgpNmX2?=
 =?us-ascii?Q?swxYkCYgt2zZGXsIeEL/zMgNtveCWjTa7aOnOAgD+EjRBHffdpwwVMxRNiK5?=
 =?us-ascii?Q?ojrKWMR69rTp+IDcTRU3JYZUbd5wCP6x8tdJw9pb6rJqIhr0/7KpZ8Jw8wtj?=
 =?us-ascii?Q?PrcwCuIpinIZvE1NcR6CNmREXAYpgMh1R++2U77Uu+NsK6zvYD5ehMhSmwH+?=
 =?us-ascii?Q?vEuJmp5ruG4vmu9zRUuPUzQ6SRPtBBIkpm/3QuXuHZilzvXKiOpukLSprtsc?=
 =?us-ascii?Q?oG78MRzdQKrHaMnvSXywDcfWG3OkIO7SX4AbRN9GVaRbTFM3UkLH+/D668Sq?=
 =?us-ascii?Q?itYeG1jtClmNIE8YF5tp3lYnhl77X517yDFiKq7rS0HGwMXdyg1RFjSqarqR?=
 =?us-ascii?Q?DWm0/YThl32hdMD3nqLBqdvXEVDXuAvu0JyXXXQ4cSUWnjbXlP2eSuTNgjrE?=
 =?us-ascii?Q?MfdP7OK+cCY8JQNZsceGEfc+ENO6+NJEMA3N/uWjmSdurXRkfnKmjMvcQ9Ri?=
 =?us-ascii?Q?5t35zUO/6aTXIQluvmds5pyBkFUjOQnF75CLUkOF90EQePfIuEf346iVIoJf?=
 =?us-ascii?Q?5CHT2jg532jhLMZi9RTFU+63jfQfvKQYZp6bPaCURu7IJFty/Rv4Y1Sv6DJx?=
 =?us-ascii?Q?cQyjyHoy6zGIV90XOJqDmp8b7o5o7dD0A3pGkd+/mi6NgAD1ByuYCTsZ9MZO?=
 =?us-ascii?Q?3z/mrsFrSduVyIplknUsNvuEnE+ATemiArFGaN0AopqAlvkhL2spBA86At24?=
 =?us-ascii?Q?iMRuJtY1D8Sq+gogdSQ2AS29EgQcmYRGZEyFf6xilpZlqPufqIhZ2rUK8ynx?=
 =?us-ascii?Q?UL2uwFwPq2YRnxzu+5sFBBfYxfzF1BjyhN8UAf3RXQBi/YTFQFH9Nu2imoHm?=
 =?us-ascii?Q?1z3y9f4GXgxelBw7QkhLo4ELdsAmL8NkO1e/DjR66eLzUpP03gZCPZdAmeMj?=
 =?us-ascii?Q?xnx3dpFBTc3LSMX/45MQ4CLoXIecR10zbL/qXhhoSFS4bGqi3nDM6HpLqULF?=
 =?us-ascii?Q?k6HdGDXtRRXnZEUAZ99U9SkihHrjCrMOpx0NcLH2uwMx0ehoyCTvbj6PFk3U?=
 =?us-ascii?Q?JcVgz2s3fYp+xshiB71UhI5B1PhnwWjZpy56q5hx+OTIaoI6zHYAIxeo96GW?=
 =?us-ascii?Q?jOhBth/1kPS9JLUDnAYRxTCCqioCbGerCIHrrFPZ/HialJz19XIMs+rULbOY?=
 =?us-ascii?Q?x7bp3B8Df6WE/bPo8rZvaB1mNmTbj/fzhh8C0Zdb6KtNGn66rEZfytXtI0WF?=
 =?us-ascii?Q?Jgwz5DCvFXs1+/e20DlLt4TJHgZMa6opk9KGq7DkcIOU2qBXnriGGzvhjUeV?=
 =?us-ascii?Q?lwmdvzgVqcwEB+D7vph1gVFaI4a85oxzbSNvolKjhz3vCkbdo84/08j4Rjbn?=
 =?us-ascii?Q?/ikyhwYYcIA/ZPGNLWAEzsqINBRKQCn8oFlnrsyuVIKzEBL8D9bjyjuqxs6v?=
 =?us-ascii?Q?xZid9e9AgcZt0EwOuhVTFm3RLl4j6CaMbCsg2yVMQDsR2x45NOFLoJCNQibK?=
 =?us-ascii?Q?X6E5NEhKX72TWoy22v3VIcIrqeCJ/lf0g2OnprNXNzALHMhaiPtzMRkLGwXB?=
 =?us-ascii?Q?XNrE1zoQKLud/cGEdbYrgb1Q9n2pWYG/rjZnKilK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c44dd62c-f315-4696-b929-08de277a8304
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 14:47:07.2136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7UbnDJunwjLdmRyYjgbKlltRxAbnqycsYbLzQv33vL246/dXaEDT3HB1L5HjY1t
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8761
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 777E71C000E
X-Stat-Signature: sowgpohgu178jkypbnr9x7h1ikhduimq
X-Rspam-User: 
X-HE-Tag: 1763563632-786856
X-HE-Meta: U2FsdGVkX19deoe68U+5W+m807VQyNcIWeMNCAdr+NL/S9Gks7KACR3LRmFFogI1crCRnnNHmxVPoupMEDJzBYLSyt8+kH6pGBiknqUOGrXL4uIUMCrRmfrOOs3gTOEpHFSHbXYF89lRDoQvrtwZ6KU+wu1o/Fhdxr2Ehj5k72mpaX+bb0ww8TFnnjnKDZvQa9ME1NRNJQE0ABZ0Kah+bbBXcZeZIpa4llmWml3DIpVG/U8bsI9t5uIaJP+yeQOx0ifd1Dq0qYViGk6z61ABvjhvw420bTgs5wfpmL3129dj68UM68WqzK2gCweM0oWnFHDHqcD4wtHwnVr+IYC+hy3gnUYsSffZnslbiFB+sWuFWwVA+LFLC1VKg2wOgUjVKFbqLO39paTXjFg00vywURoA3fKT/3YOxfuKbqr3EUZd7LP4RKwUpR+YuGQ44pc6j2PuGUqQiMCRCD/vXAR/vhwxUlyKmAx8JSrZ5ZRXlC+Tbghqdf9Inoibsq+ndFbL7V8G/MagPZW/KbaXsor/zHyC1kLyGyt1U8vomWA57tBVePEzVUJ1/CNWoeU1cNk3i6Q0kSnI2Cv2DfkasQaJiuFq0IdIXTqFpC6JctUrGY9QCqpiVwZ66NxAsAgcZpkF09tVUBqsTVduFGyqdKq3lrLbg9g8EyNma7YAKZfjj2AxCcSw/1yQyzWsHt7yC3mnv/rIHfBXzzvVla5JneD1fqxjVa90J7YL8NyqZyzGOd9AEVNShyExV6Nv4KBRHXUm9SXEKcwHsNs4evqfHObhX/icvFw+7ppmyrJSguzFUxf/QN3pJ2oqdgsOr/KeE7KWRqgIhyL2PNqPhHw+cRRc6JlGf7k7N4YWtmlcRE4Jiqd2vsY6fbnfslLILYQPyn08c+F5hJSYWPYH0Uw70/lZ5fFGTtPpvBDyRHvCVfOIXsykVLxcbTs9Q4sD8P24ryoSJvlZxuG40kgMgHJBmY9
 DkJoV4Ft
 kZmSGha/wcUVJUJmkuaDE1C0o/fak4Fu5sqMYuMSIDu94HAwjObezQFLLfWsEOIK+UY9IEgJlsOSzj5ghIhEMc43USeUZe9HVwQZBpjAWglWrxjM2+UGcn1HcQO2nN1MD1MG1ywPt74lxHZ2mQmVBX3sJ1fYqXl5LOmgUGcYMEWqjL5DPu8MoOW5Ap9SXa7haQq9IegryhfmjuKwTQvkc075BEw+GEP1fTmYgxC0ME8k4t2k3jPoWaKus8oysqMJaQJKP2tUovD5E4TjalgjKZA8e8xHi6U2gJiZ4GOBSPfkrD3XTqZT6lA0lhWFx37RnOhgYPLotwwp3gY+dy4CNlUkZyEXyRzyjuIq946vc5vBJ+ZFohZxyeqSEGkyqD6Dmb9jI0DyDhwlESQpGqeDW9ufDxpXcvkLlcujGaunAhewuIxfsc1eO4+5/E1/hlj+hEbg//07Oern0STGd1db9Saw1Ahv9RGP9qmNBluBCaQEj7Ds+4CNmy6XrnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Nov 2025, at 9:37, David Hildenbrand (Red Hat) wrote:

>>> Given folio_test_swapcache() might have false positives,
>>> I assume we'd need a
>>>
>>> 	folio_test_swapbacked() && folio_test_swapcache(folio)
>>>
>>> To detect large large shmem folios in the swapcache in all cases here=
=2E
>>>
>>> Something like the following would hopefully do:
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 2f2a521e5d683..57aab66bedbea 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3515,6 +3515,13 @@ static int __split_unmapped_folio(struct folio=
 *folio, int new_order,
>>>          return ret;
>>>   }
>>>   +static bool folio_test_shmem_swapcache(struct folio *folio)
>>> +{
>>> +       VM_WARN_ON_ONCE_FOLIO(folio_test_anon(folio), folio);
>>> +       /* These folios do not have folio->mapping set. */
>>> +       return folio_test_swapbacked(folio) && folio_test_swapcache(f=
olio);
>>> +}
>>> +
>>>   bool non_uniform_split_supported(struct folio *folio, unsigned int =
new_order,
>>>                  bool warns)
>>>   {
>>> @@ -3524,6 +3531,9 @@ bool non_uniform_split_supported(struct folio *=
folio, unsigned int new_order,
>>>                                  "Cannot split to order-1 folio");
>>>                  if (new_order =3D=3D 1)
>>>                          return false;
>>> +       } else if (folio_test_shmem_swapcache(folio)) {
>>> +               /* TODO: support shmem folios that are in the swapcac=
he. */
>>> +               return false;
>>
>> With this, truncated shmem returns -EINVALID instead of -EBUSY now.
>> Can s390_wiggle_split_folio() such folios?
>
> [noting that s390_wiggle_split_folio() was just one caller where I new =
the return value differs. I suspect there might be more.]
>
> I am still not clear on that one.
>
> s390x obtains the folio while walking the page tables. In case it gets =
-EBUSY it simply retries to obtain the folio from the page tables.
>
> So assuming there was concurrent truncation and we returned -EBUSY, it =
would just retry walking the page tables (trigger a fault to map a folio)=
 and retry with that one.
>
> I would assume that the shmem folio in the swapcache could never have w=
orked before, and that there is no way to make progress really.
>
> In other words: do we know how we can end up with a shmem folio that is=
 in the swapcache and does not have folio->mapping set?
>
> Could that think still be mapped into the page tables? (I hope not, but=
 right now I am confused how that can happen )

IIUC, in shrink_folio_list(), pageout()[1] calls writeout(), which calls
shmem_writeout(). shmem_writeout() allocates swapcache and removes the fo=
lio
from pagecache[2]. Between pageout() and the folio is freed, folio->mappi=
ng
is NULL. Before pageout(), the folio should be unmapped.


[1] https://elixir.bootlin.com/linux/v6.17.8/source/mm/vmscan.c#L1452
[2] https://elixir.bootlin.com/linux/v6.17.8/source/mm/shmem.c#L963
Best Regards,
Yan, Zi


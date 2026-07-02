Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFA48C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D326B00EE; Thu,  2 Jul 2026 21:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5DF6B010B; Thu,  2 Jul 2026 21:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6AE6B018C; Thu,  2 Jul 2026 21:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA4316B018C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:11:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAD668C124
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:51:31 +0000 (UTC)
X-FDA: 84944427582.19.02643DA
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013045.outbound.protection.outlook.com [40.93.196.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 08DAB14000E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:51:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XZuYts5V;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783011089;
	b=cGOQMORBrDEpGM9SfJKPcFgbWK1dnD17X1ntOcat+KqDBvYFaC/YOi2U0P0zEkYi2eZJWa
	vxEkiNVH7WQz/xjvMZjSsOBgoieXSJwql+6FYWCLSICo0tu0MMyDELpwwjDCTlTgxHAkDB
	eq6kQGgKrKzHz4iw4dcEg3rcLKNsx+E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783011089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAAkFNP+ANgCEvdeWwteFwMammq8vR/aDjEtStbQetg=;
	b=TieaT6Rqrw2K7TxGMW/mJmZK467m8J5tHQkMB6rX7YkkxhY8NCcrhLOYrgVMaenNPgMRd6
	Q+u6NjGAftpSKljQtniyk0lL54+Bg/7eAiUSgB3Ouozy5wsjmd7miqZL3mMZTRtfD/oymK
	iwB9NIhJTUCht7GSNvLd2skuqHrVc1g=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XZuYts5V;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DcxaStf169z9dOLA+XgsDwNAKE15bGRroWd8VtEad4UycaRoRLyd3NT6Y2dRN1bvKanV4LPTNKjtK7dlYpaagx1hGn76l14/C1WAl7VLQ5gbQtakec4zmNC8Npe6jXvXPPc+tjTUfIjeM2NbqHI1qDJUjHzeVVyLa82Hw1pGfSd0Uk4ZwdPN1kUPMif1IKW+1Hymn2jaIXCxuhGLiXkrCInlAbeWH3OGihuJH4DLxbHrJ4m3qfkXsazW9KtVoI9CmqNgYqF2VaUve4yREjVbdPF7iodz/fD6aXHOBnjdwnkdPTTCpkMg93CqNW1FU5p+zaz4FrimUf7GpQZsWEErNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAAkFNP+ANgCEvdeWwteFwMammq8vR/aDjEtStbQetg=;
 b=n+EgRGSd5svdiWd7W4QoaSREP1HN64CWqqBT0/f5kHRT6qESvLV5GiQ6L+8fh9RtXEfv6mSLKsMtGlI2tbfTthDAsGbAXWsTG7nHk7vVjeExJV0VEwzDSv3KHWuvWWHRRZwBxWC9HhoKKZFB+y13z4q22UUXHZ59lkPegmMHndxuEUb/6MKdwvpXFB1MRsFc2i5JvcLqy/R2+VOQDrPimnFeAzEvukz5VQp/b5Vq9kimTFFbX95/lZNpQOz1CXIHnEcXhVjbYNkz864M+87fxam8Qfi9dTszmw/sMe+qlkUdeps4pXP5kH93y4dGfTc5omtj/bDrPY4ccX2kh3z5sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAAkFNP+ANgCEvdeWwteFwMammq8vR/aDjEtStbQetg=;
 b=XZuYts5V3ezNbBJHpm9nNyHtFBCNS7L5AwA7afTQ0rJTEYtxe7oKmZcJuf7uRGsnzthUmIyvokOo8w4jxtD0SUBfms8qC9ZEwNpRWbCzdz9UjO25FaaCB0m7+7Xy/TBblXiUp78QhIOoC9jLniLre2UEoRmc94opXzBIGuv2YVPvnfVVb/y2tJaGD9wb7TU4YLcveg2O61+cD/bemPDiOaGZGL00IQs7u5oU6FjBYnG3OHO7jU2g6OH5pO7CkXgJfgqD9rgEDOC8uoUz4EcH7o+Hcc2N/Et5ZDRKucurSlFUuPEglZw/11GCWZ+al9H3UeNfBRciCg6DgyeoRINUPA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 2 Jul
 2026 16:51:22 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Thu, 2 Jul 2026
 16:51:22 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ackerley Tng <ackerleytng@google.com>, Qi Zheng <qi.zheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com,
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com,
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com,
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org,
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev,
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com,
 vannapurve@google.com, yan.y.zhao@intel.com,
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] Open HugeTLB allocation routine for more generic
 use
Date: Thu, 02 Jul 2026 12:51:20 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <5BCC635A-9CB2-42AF-B7CA-43886CF2BEC7@nvidia.com>
In-Reply-To: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
References: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:208:256::32) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB4384:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d137283-51a0-4acd-f131-08ded85a258f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|3023799007|11063799006|6133799003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	G1akPo1/nHQsQVQOe4uOKF7Fftl/MNc39je7jBsVNAqwRRsu8ifNg+hOFBBOXR2AhEyqSWdQzKsKANgAI9cAmGgLJue6YytIDPQ3+uoBcCKLTCs0/b50gx8A+0UQIbEXk/S3QgltGeYfgzlReM1WUfvaKYLZw6WQ1bP6Pu+fDEbXLKQZkn31RAKoi5ONoE5mndgOiRpXJt+dhIvXNv7n58Ig+JssgV0eRHaXmVBcqYQ/rzdWccilCaxYscNCU8RppaxyQcuEdRkk01nz6n0C0j+CH/pHH5Nm7VGd71IdaCCh++02//LmJSjAd2cHQays7iccfoGwZb9Gsnc1J2Vin5LgjY9ToqGg7b7FrrtztnLwCX4w56NYVOGkM3dMxvafRlD9RPmc15Bf/vkyO/+ZMQQgp8EjaUjU6oatrpst3RfLS9xrAC+k9TT/Lt87+nWOaR2D1+TpGi16vmy4NrrovZoe2ZJ5FVcSotf072Eh6C4P2HJWGL9sveAx7+2fNnhkDWbolovzG8LRk4G3oTXRXieVzApWpq0PjZOlPjFzFwVMMSDNJw+5/FKFY0WQB3Y9sY7RqppdMS02GUO4D5MPmxGoGOdSZUeBRhq0pHSo0dpBSyihxPl88P0Eb7gIS2mld7VJEr9c8Rg1/JOiHzQffB0omI1CnnUROsHqbmTV18g=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(3023799007)(11063799006)(6133799003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?As7OlaKpwp/9SbD5k+J1+L/1EC5UL0eF8VKlIYbVoKiDJ0u/jKJHhSbbli1F?=
 =?us-ascii?Q?YGqHzufXPZZqdylne6RtGsb12Ecss9UsQ4yEa1R1BqgHRaToegUOuizHjz9s?=
 =?us-ascii?Q?0h2UNuTUPv/Jy9DsXldlZO1pwBz1yyXrgkv1XUJgFt+0psH0nAmSkTULClbc?=
 =?us-ascii?Q?5yQWdMwKcDtYIMeI+EIxDpJ3Tz38DoPFnXupc7yAnt5dugZZQ8vclleLmlyl?=
 =?us-ascii?Q?ZFJq7/pCEQ/H+Zsk2pF1ini43X03ydBSorD5bhimPCPJhy97gp/pLWNujUmA?=
 =?us-ascii?Q?/CcAXDI6GfqrL1rOoMMLdF6rBkWSLh07M6Y7n1jK1iW403tY0ThON6+1e76R?=
 =?us-ascii?Q?dzd1kSx+gJw5c8c5GB6ewc6QC5Li/3RHTsWoEKBFieiTS7b/l1ldNGmmt2Df?=
 =?us-ascii?Q?Ovebfi1DA2H7KaliOef76/fCLgPCGu4B8peSLj004UdzInLoYmYbWAy+tw1u?=
 =?us-ascii?Q?QQV2ZPmAAXEMiJZ4Oseh736/4/RptrI8sl1kzC4quw0de0CuA0DvD+wnvCxR?=
 =?us-ascii?Q?w+UcmIKeI1NOHCYg/L7/Er4+Wne0F437JjqVaOAN7kukbvME/y/PjC8jEeEL?=
 =?us-ascii?Q?IQVvzyt5M0wQWtih7u2egxbgZp9liqD2uGNA9aq9ips+uJVed0IZ6wwevbAs?=
 =?us-ascii?Q?Zcj2/5aUtopKj4vjtmhrVIGqcUcNRU40bW/KE0BSPSQ/wus1BfbfT90DVl1D?=
 =?us-ascii?Q?vc8Gh+lOF3yI3t+fniMrcSiCWbGW09EGsGCacIP7LoLHwge1UqXl2W6goiPI?=
 =?us-ascii?Q?SDHxDbVoyyZHEkEW45tgW7OJlhUkIEhliifwwnnQDfDEwSzKHk9ckt+iMT//?=
 =?us-ascii?Q?CQUNwOZMHOLt4sfbwvhknouEx3/jpRia50DFYSBrYPWFR0SwRI2xXN0fEVD7?=
 =?us-ascii?Q?ssJvXE6ptZlwHV72RdLF+HUtWKUJH+b8yc0Tewak1+xlOYxW4cxVZqVgCRfY?=
 =?us-ascii?Q?82GQ1ZrP+Stl8hQF5CWu4oHV6/YMZW4qnTSs0LZJsE6dFlAR6TUno8QKUNba?=
 =?us-ascii?Q?uxgXQF7O3LHFpomlHl4eVfm0AnH8ckvEWI0pNWC3K6N1bNsgWraY0KQLYHx2?=
 =?us-ascii?Q?hoMuIemsSrOfJQr2BhdkibkSwYTKloeKvSmhIIHgUp+1CQMDww9o/QgGRNW7?=
 =?us-ascii?Q?cAdFzPxYJMtAiRssSBZ3vLP88MwDYpIGREvgDmPPYTPbyA6jYgOzjoo8V/UE?=
 =?us-ascii?Q?GaaUA57GjBbDSnuZ4DnlD+rVaC++FJHD+gVc2qQAuz+1mA0K/lRGcV1/Tdas?=
 =?us-ascii?Q?DMDV4nyo/DKqT51Nvm5tqLiRGLnMJaMrHyFEJEFn7cj/GKT1QzcBy+IkaQw7?=
 =?us-ascii?Q?cFXaagFkHcBiu92jx3Wd3z38sWW5SpL4tgXYC58q2iqR/B8dmiI0WX4mUDtv?=
 =?us-ascii?Q?nPKOkCQBt3MMycJbzwRgVPb9Q2EWqZfDtVAF/7gSDeJqdbuC3Yqq1uGQl4c1?=
 =?us-ascii?Q?udECl+IYHoVv9ADuDZI82hoiyy5YiDYQBBOcp2WVo1422cRM6bf+J0wD1yiu?=
 =?us-ascii?Q?nt+X8W53I6wMbWX2vRUn42NAr8OYJ/YkkHfbX9lMhmI7yr36/JdY44YZAP+i?=
 =?us-ascii?Q?NJMd1EXxwi0/vQaBbFTe6J01jSOYeeGxN31b5FcwmcKN2i7cK0MfMyuTE9Es?=
 =?us-ascii?Q?7YY/+hT5YoximIHrA51nk8ykvenHwwHxoZYl84SHuV7W17eVIKgdFgDS6DW5?=
 =?us-ascii?Q?cvD+oPAIMwN+m0zZa2K05jqxR2wI9EGULDUJ8LNoi9vPBBkztrYHmEY9Iltp?=
 =?us-ascii?Q?Xfs0HaLj4Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d137283-51a0-4acd-f131-08ded85a258f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2026 16:51:22.4028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cmfLNM/eMUFiqMhbe7FVeDEgekvoyZ0ThTbKXDMw5tqsxk8SC6py8wQh7X01aAt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
X-Rspamd-Queue-Id: 08DAB14000E
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: h75hfw11tx4e3kfxur58uz3borpnubxd
X-HE-Tag: 1783011088-942530
X-HE-Meta: U2FsdGVkX18GkvBK0xPxEqRGtt6z12Z1+aUX/chmfAoxVm9dXO2cTsKFqkjeEfWgyvxBG1AuVTCKPdghvFoigetBXCpBzh1B9rEzWjrw5kuig7RpxGTmi3z1ESUpAw0Le6LcQ576sA+EVUMfIMtq/R6X185GDY8X1E4OZK66q7bIpnh3+a3rWv3rdYLxo6TNWywobGwWR35L7GEkmVlgKuBxQm4+cgrbZbE7DgaJiqeZS5aNoTysu5eXe96udoEnEz+vFaeldc54c6dR7lK1XbMRLRg9eBtMuwzqsuztg0nLPdsJf3TdJEbqK3krzIP1WqCZjcdM3d55gl+7S4ktGnpBgQmJ8+4D6rdA0u0ppqqysWCTe3a6KXTvb3VS61RRadQYBQHTRNZWY0FmK51xe+9+aQuG7/+PJ9fnP0hGD2XjU3o8F2rmQ04FlVmB/wVB6autLYz4FA/WmmxbLnlsvtGaBj1dSA+kZCPyyyDZjobMyF6wDZIZ7MpxCKUTFjzTPdAZmefK+lcfZ7hY/X5cncCEtGx9T4RuVVHsaJHkibdQFWKTjmoSTvj50VePIzSkXpCMfZPAUWoWUi5NvkGbpMMhDHyyYQ0QI8NtX+G6Ix4mVq4eflSsNdV4YLAxZeI9JNsnuyXX95dLQNptSqrb2LDdTL0L07sUE0K87o2rEQtjVE1fnjnIlkjVnoBG0jAMPlUCGBG8R8DFmAJrUCMCIzpgpeuVxJes14N6TXt43eMYT0gTllyoqRlzV3Ig7gpRRiOMv4IFQ/vo3AEXdP2Mdx/YLHMZlfANZdf4/6Ye0GXLLJbVxw/d3ChbJ4qy0Gwm3hZOBIgXTIEmjtVPeouTEiymIFPOyTGztiyGWl1w+3whcr4s1WuVVQfqDnzQv9Ccr1AKWcyP8JJQ55xytIf4+KC0wNu45DJ5ADPCsUjE8eioQ6DeeLDcpHEhskQ4WDtk3tmfOd6lKgKuUcAue93
 eKbIwMgK
 RfZX+DcF54my37pRtV4QnvXWM3CdNw9GjQXmDqsnwsrlxHoILZNN108zOcMedkWq4qQLDsu/6UQQMtzGyuj7vdIrm2TWr2yjIXjrzBs45chWTG3YPsykORWLClmVHwUTmTXlg9tJoJDkYPcsjnwURa2ICOd1Ukq8c8UUUsd6B+P+4XmZ8gxGUMtl+J6TELsEXG0HqG8ko1B9A1UdeIcus2jAjY7dm55V2H8IhGL+5dJkmuBe4/Daz+TInq0jfdJwBdT4NULp3zXqVhC0+00YFkRVe5RVQTfQ1giBKe75o7WO25hsls9mLedSNLJIiHHOI1HWzbnKzr24KThwJhgOWtAHp5MF42bxZVkwk9kYfRfr3ABD3W/Jl8XRFmfQK8dqskz5ft3IaRrDG1tJAhuOavygiNLZTwYR6tkcBm2PVYLY+adl1rEkzLNPJ3Yy7KSdThiPVEE5CNqUr6qKZF1L1Q1ohlt2TSZgQ9m4myEMXdLL07VzwrvbMuC68pl12+WHAXUXAXZ3wiKGx+eLZ/+hXvNyYu+yncYYZPhenHM1/XbudhTkODupBcqai59SRLBL4FzBTtsfl3RewqKmU8YuBquuu1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Qi

Since he is looking into adding memory reservation functionality to THP[1=
]
and this looks related.

[1] https://lore.kernel.org/all/cover.1782538002.git.zhengqi.arch@bytedan=
ce.com/

On 2 Jul 2026, at 12:21, Ackerley Tng via B4 Relay wrote:

> Hi,
>
> The motivation for this patch series is guest_memfd, which would like
> to use HugeTLB as a generic source of huge pages but not adopt
> HugeTLB's reservation at mmap() time.
>
> By refactoring alloc_hugetlb_folio() and some dependent functions,
> there is now an option to allocate HugeTLB folios without providing a
> VMA. Specifically, HugeTLB allocation used to be dependent on the VMA
> to
>
> 1. Look up reservations in the resv_map
> 2. Get mpol, stored at vma->vm_policy
>
> This refactoring provides hugetlb_alloc_folio(), which focuses on just
> the allocation itself, and associated memory and HugeTLB charging
> (cgroups). alloc_hugetlb_folio() still handles reservations in the
> resv_map and subpools.
>
> Regarding naming, I'm definitely open to alternative names :) I chose
> hugetlb_alloc_folio() because I'm seeing this function as a general
> allocation function that is provided by the HugeTLB subsystem (hence
> the hugetlb_ prefix). I'm intending for alloc_hugetlb_folio() to be
> later refactored as a static function for use just by HugeTLB, and
> HugeTLBfs should probably use hugetlb_alloc_folio() directly.
>
> To see how hugetlb_alloc_folio() is used by guest_memfd, the most
> recent patch series that uses this more generic HugeTLB allocation
> routine is at [1], and a newer revision of that patch series is at
> [2].
>
> Independently of guest_memfd, I believe this change is useful in
> simplifying alloc_hugetlb_folio(). alloc_hugetlb_folio() was so
> coupled to a VMA that even HugeTLBfs allocates HugeTLB folios using a
> pseudo-VMA.
>
> Testing:
>
> + libhugetlbfs tests pass
> + ./tools/testing/selftests/mm/ksft_hugetlb.sh passes
>
> Andrew, thanks for nudging me to send a v4!
>
> Oscar, you mentioned that you wanted to do a closer review on v3, hope =
you
> find time to review v4 soon!
>
> Changes in this revision:
>
> + Define gfp within hugetlb_alloc_folio() instead of having it as a
>   parameter so users aren't able to override gfp arbitrarily as Oscar
>   requested.
> + Addressed some of Sashiko's comments [4]. Some of the issues I didn't=
 address
>   were pre-existing issues. Since v3 of this series Sashiko was updated=
 to
>   actually send mails. I'd let Sashiko point them out again and then we=
 should
>   discuss those!
>
> [1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google=
=2Ecom/T/
> [2] https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversi=
ons-hugetlb-restructuring-12-08-25
> [3] https://lore.kernel.org/all/agqaUcVp_hwH-VXr@localhost.localdomain/=

> [4] https://sashiko.dev/#/patchset/20260518-hugetlb-open-up-v3-0-e14b30=
2477f8@google.com
>
> RFC v1: https://lore.kernel.org/all/bb35a69a-5be9-45f5-a557-1902487a1bc=
2@linux.dev/
> v2: https://lore.kernel.org/r/20260506-hugetlb-open-up-v2-0-826a0c5f28f=
c@google.com
> v3: https://lore.kernel.org/r/20260518-hugetlb-open-up-v3-0-e14b302477f=
8@google.com
>
> ---
> Ackerley Tng (6):
>       mm: hugetlb: Consolidate interpretation of gbl_chg within alloc_h=
ugetlb_folio()
>       mm: hugetlb: Move mpol interpretation out of alloc_buddy_hugetlb_=
folio_with_mpol()
>       mm: hugetlb: Move mpol interpretation out of dequeue_hugetlb_foli=
o_vma()
>       mm: hugetlb: Use error variable in alloc_hugetlb_folio
>       mm: hugetlb: Move mem_cgroup_charge_hugetlb() earlier in allocati=
on
>       mm: hugetlb: Refactor out hugetlb_alloc_folio()
>
>  include/linux/hugetlb.h        |  18 +++
>  include/uapi/linux/mempolicy.h |   2 +-
>  mm/hugetlb.c                   | 269 ++++++++++++++++++++++++---------=
--------
>  3 files changed, 175 insertions(+), 114 deletions(-)
> ---
> base-commit: 4a50a141f05a8d1737661b19ee22ff8455b94409
> change-id: 20260504-hugetlb-open-up-eaba80571b09
>
> Best regards,
> --
> Ackerley Tng <ackerleytng@google.com>


Best Regards,
Yan, Zi


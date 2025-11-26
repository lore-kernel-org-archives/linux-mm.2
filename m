Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6D4D10379
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 03:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C7306B0024; Tue, 25 Nov 2025 22:50:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F286B0026; Tue, 25 Nov 2025 22:50:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E1C6B0027; Tue, 25 Nov 2025 22:50:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1511E6B0024
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:50:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9EEAC0496
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:50:33 +0000 (UTC)
X-FDA: 84151381146.09.D0B47E6
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012059.outbound.protection.outlook.com [52.101.53.59])
	by imf11.hostedemail.com (Postfix) with ESMTP id F3BEF40009
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:50:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s1EvkbSF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764129031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2P1yQHrSQ8wYt8JUlrzWkgTxC3OBaMcPdNhnea1veKI=;
	b=r7hpUpSZNGYlpJld+TxdG6xI1DvXVIdCqJ94ztmbSRd/7E4cKTieLVTmfQRUjzPBWir9+5
	1L8do/sGks87j/lXSF7a2w7+TeSP/OQZDcsSxc0+kKqrK1AdH/Mwl8Wkwe3C5yA/IiPjpV
	Mordpmj5+lwD2YB7TymxAgh4xlC0Flg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764129031; a=rsa-sha256;
	cv=pass;
	b=X9f8ZrhZUZ80Opi3pEywFd+s/rau0uj2H5EX7u9xma36TvNF88LFUdBi8mZfoKgft2s4wc
	hXvtU7jZC6swK+Tn1HBDITiRUrOEYMfPICjJBj8TZf19FHQkRA6h3yohlHbuPQzb9gcvX5
	rd3Ik/QRPZoekuKXEw4r0Q9cqmC9W/A=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s1EvkbSF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.59 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bpm33deH5UJ1XS57qh4dYeuWJiX2Lc0S0gLnZtiacfioPedg1JurbtA0PTTIm6agEBEdOavXDPgqvMjEwsLBJJZxrg/eDXnjS0muc1/AbCoaSt7XN6ElGk5B67Pby02BGcKxen64hl6JKZ3+yJepYQi4cAesOtCkTy6zwaXTYwIYyErOH+ONchgtKC55TR6iGq3UWXijHqWyXMQFVjINwS2lqih768HspHDUc2M3ESVtgQ9LnPlUPQ5zwJdh86WUvot75wG0pmhAPU4n0pX7yi8SFt5rkWhxKOGlS9Ufx0Ag2CATKdHx1AMNHrAXVOH+04mqF+klxBNH5SLpNCmDzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2P1yQHrSQ8wYt8JUlrzWkgTxC3OBaMcPdNhnea1veKI=;
 b=oshPPUGSHytixQaoN+PxPAT6HVo7qo3HybWxBbJ94HIPkKCYr3TbpvKzWjKU8jN7SMXk8U2W6mPlP+tPHNt9GomEAjEbW92QELUkTHwZ4YsCsTUaskJzF0Y18SrMEw/OdCUeo8mBLw3CFHL4WL4CcYlTBVnbm88aRR7oLFcON/d9MLZD0yNyshO1EIMKSY6lZfHx5luec3FGd6F415ZRrpfXc/+Szl67O9f6k2H/ODZppoWO8F2aSzBcmADVwJHCR6GQUmc4Y9wBwNMImQBwqOiTzztNvjcC2kLIqI/7Hq/L3qvBWB9xRL20LECApdEgeceVg7tmLJBzobhElwGz/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2P1yQHrSQ8wYt8JUlrzWkgTxC3OBaMcPdNhnea1veKI=;
 b=s1EvkbSFB+NuaXY0IpZpj6464Y5nCRhaC6Qu3cWeeDs9OzeCIPW0sjYp9BrIQUVScm6GpKwFJsJJXHCQ4Fu6vVA4rMjCXc6DbC3Vm8hO4v2nE17ycYbWxDIskbNkQ0hB3A7GhF2KKA34xhCrut4E7Hm+9t9Ra5+iTgXYsIFI9E4HWXx2jc+XX6kRCALrWuyaPgbjNH7MQZRZwZRfd0mxwsWQ26ifyvG6AZsxKifid37HueDyOWrhLkvSHbuk/LoNE8KLkPyh51vN5rw/ZCUZWaEs9+SRNQsdayfaRR6SvPQ9mGh4x/xbF9wCIf0TiwgtODWwAc9Ax+KDFx33u5Jjjg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 03:50:16 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 03:50:16 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] mm/huge_memory: replace can_split_folio() with direct refcount calculation
Date: Tue, 25 Nov 2025 22:50:06 -0500
Message-ID: <20251126035008.1919461-3-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126035008.1919461-1-ziy@nvidia.com>
References: <20251126035008.1919461-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:91::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: f97c6235-5273-441b-1da5-08de2c9ee960
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PJShp25z7yScCvrYuiTVPNK/2gpIdoJN+gN5+3sKlJEeFLMKf9L9ASafvLhu?=
 =?us-ascii?Q?h3MypWmCGEk+TQC+ixt06ih8JoCXGCDnJHzYOXrxJIsZVwDk18uMj/xHLfyV?=
 =?us-ascii?Q?nlRgYMIWDliA+Ceme/YVGKIROmYkHkZJLL1akx1t7dvykhMuu3XiZ65e1C6m?=
 =?us-ascii?Q?w3j07r95PsVuThhJtNVX78TZ5SoqP//P9LXhfSZxk9REblIiEyvnc8vB5H4m?=
 =?us-ascii?Q?zF9O1x/Do/ET5+RZtrIjDekGupSmc2g7DtLPxe5PVeiDKUq51P9AYBRkmLb+?=
 =?us-ascii?Q?o0ReM/de76KqBK85aTJJTe4CyNw6NO4VlxQUeBGlO1ic954hzAOVsydJ6R3Q?=
 =?us-ascii?Q?DJfXNORwRflDN0DymWhd1/uJoMrMlBgnSbCTbJrqWzwNg0x6vjGjpVm2j2e+?=
 =?us-ascii?Q?9rKAH+0f2Yj4xgjK27RDhww73mZZ1c9n5t81i+TjxCCBaib6DD8bjf++Aw9K?=
 =?us-ascii?Q?LJmKpWvwNJC7Vl0nfdTxGWJxMu7f4p++m+RSV9XMVm/SQJQ7kJYZv4t814ab?=
 =?us-ascii?Q?Q7fGW3idc9gQee3Kz453pkXzSdxPQMSTIY4MzCmpPFkx7NMKxPQU4v01Grc2?=
 =?us-ascii?Q?hDPc4VqXJKxPQ6ACE9JlkCmfSgfHNxVhno2FUDIEAT9pPgxBKibMBLWMil0W?=
 =?us-ascii?Q?UKBLrApl54uA6HjbKjGvu1QdCUu0UhQCPKLn8zDXmf9G6OuvD6o1b8pJFWGh?=
 =?us-ascii?Q?e6jluYKoMDlUZ5af1mqGhKPpaivLrYB3uEP916gif0to2hk6ou7dC3TOBgYT?=
 =?us-ascii?Q?bRz5MfAJu3vilIAhdjx3Lv0zLP0ne4Qy2xS/CPWNjQ276yqhiIC8MvtxKJvD?=
 =?us-ascii?Q?E0/VRaMxZtYOnhFQAuAvxd0TMAgW15RykFFYZqbb7TfMUYC4s8W890oZNvYv?=
 =?us-ascii?Q?cbibOD3zCLrmrFYE1aACbZVS/y1lhwLH7+4CdR1m3sv92diVfzNbx6QvgQZt?=
 =?us-ascii?Q?Arq14EWwIoiNFACa31z50AVsPZL06JT7XOPYKr/eBJe6gXT1WYQ86Ju/2tDu?=
 =?us-ascii?Q?Vf2GHmDxWkPyyW4d+v/1ckyZGaUxV/xbanroA+YcEV6wi/dXnp6WyTzCAFzr?=
 =?us-ascii?Q?dqD+gWU65IUVGSz0H52qRgTp4qUkMkemWHco6ZAzwj8IPG0G2OYwJvQkfK32?=
 =?us-ascii?Q?4Zte58G/SyY+XUcvu0Z7kK8lXHNetfkQss7BXGmllFe5DcopksWSpIWrFJh5?=
 =?us-ascii?Q?buCviCf2nvXLDl+pN6qFhjlqunL/L0VuKCA+H5d+zBGEUoNsoQ+x9Q5oK9VB?=
 =?us-ascii?Q?98iAJV8a1xhjn8lls5vKdDf+gVaObAcOOnzr6Yy4dcIiFBJoMWXK6ihdIzgI?=
 =?us-ascii?Q?vq128HH7k3d726tbbq7tJzAEkUfMB2+hvwdGI5in5iUbcqcXCHzDnNbpT0vj?=
 =?us-ascii?Q?ewdYVMO9aXFLcgt0VMbqaNz1LiGc2xQmoRzukckBsuh4HbyH6l+SIVj2Ot6p?=
 =?us-ascii?Q?r6fxMcgS29aoGyPKsfhWtwIYo3hB3FH0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xN05OfFhQ89YhweYmzj5PrddRxTzEV++JhplNVI09uupFDtbE3SC3OJ52Xpg?=
 =?us-ascii?Q?tpHTbpzosx/XvupQWYerllWf6OtlJhyPCld/c4pUNcorzlC31rTOxCZAm7ei?=
 =?us-ascii?Q?z22Gj7rNMa/ba3lGHwIlmmtH62cTxAWtAggP7NVTCKYSHKFNmi3tAxOznzu5?=
 =?us-ascii?Q?jdFUeLje//5+Ud7Barl9fB24BIYshmWEGmxOGKQJ1OUFvmKt1mPZCvbPk/gA?=
 =?us-ascii?Q?1t5XPl1RDQZ9jEl04sMMyAlfo/TDwQa7oZRWQw9DKKeG6LygxxHwMvFNjFyi?=
 =?us-ascii?Q?9SaQSE3yPzhINzu+31aPaBX9IgP1ZK8Yw7lB8IfMDBhZFApWdQhrY7TpDQbY?=
 =?us-ascii?Q?HEYYYKDELc4ljuwovqZ/KrKZHcwKS3WtFb3F5gJ18+7CLGl7yBCLgo4Dm3U6?=
 =?us-ascii?Q?4lFH7S5kUda/VvHOFP9HcrL/E6P9la2asdyQaO196mMWXFKL2eKSnDeyjk7R?=
 =?us-ascii?Q?kckJJfQX5UuF68AdtP3dTmPcFFcmgh3bebFuU9uokdT7N2TjnmZSrxTc+LSH?=
 =?us-ascii?Q?bWZah/xN3sRDD7boebAQTyRAyICrauhTQB/0KujyxBzkqIEi98MUmDSgkqP9?=
 =?us-ascii?Q?nb5P7p6da5/wJ6k+IK2UXS53BuQkODVgkRWQHoQEnBMi/Ovy+pYrF05Z2jYI?=
 =?us-ascii?Q?Saq+bvltt673q1SN8rcCrlwawO5itJZbYaie+YJcC5Z3SyxHoeqpDJgbcx2U?=
 =?us-ascii?Q?7Pv31hu1TFyk29r9LgC//uNVVMj3fy1VesUnAP1GYmfC6ywTvG08VV8btJB1?=
 =?us-ascii?Q?3AHO+5d9GvDWCwxnlCnum0D14Ctc9+HF3bC7oUQeihVs3OGAZhf6DbwtOyYv?=
 =?us-ascii?Q?ZWTf11UMXI9NM+EZXscg+FL6sU6ZLBpTESJY1AnxO3mzu9OhdX39BAiT8q1t?=
 =?us-ascii?Q?83bRlEVsSOYoU3Gv1VfhQjvkhSFqA1ccvgD8vIuvy12Dg+3rcIYESsK60hJb?=
 =?us-ascii?Q?bcVcQbypLwucpUTvCR49xYig9WjEyrpc8p5tqq9ApxazLrmFvttfGFNQQcTU?=
 =?us-ascii?Q?Ot1DMqZOrxYlp0MmSwMWJvpWHvEenr2wpLaPNNCBjpZtPA5uQJ44CGloK2sF?=
 =?us-ascii?Q?b0yrNgncHSTXxWluUPxU/XqTG1IsttAT3lL5VZD2/zxoJW+yavXTmo7wR3tf?=
 =?us-ascii?Q?fnAqnq1QtD6xYhgzChA8EYSqUQnE4+RgcmYj0OQYYfymaVXBP5jYCMfVF+Y3?=
 =?us-ascii?Q?uHfRB+hx7YB8SgqaLGRUkkXBSpZcLLkI1jo55Zk6gKmkuCKK7P6UmvOHenbw?=
 =?us-ascii?Q?mFf140BrD7XCeAHUr/BY9ntPrVdhR6G1Hk6OAgQLjAj7n6zjfztLeQoO+vBt?=
 =?us-ascii?Q?JN8p+QsG/YYd5IRahT80ZgflPlrZZYrOu8l1GFiJ382YKg32WkiiQbaoAZZO?=
 =?us-ascii?Q?e7IbA+P4cj46b7Q+z/fovZMtmF7Qv2vG82T2zVFqV0S9EK40GyoLxs1eCQ9x?=
 =?us-ascii?Q?u4sYMOs0Y27hEVBPoxXgrLVdX7Ek0ZH8h5SS1Ue52nMxfkSbOskTRLuMoGSM?=
 =?us-ascii?Q?aA7Y3HrFIFxqnxlYDPDyjpDRHrSyO95FnXusMiBO2gGUPQxFRaUFm4XFMnUo?=
 =?us-ascii?Q?5MH1e/gmVPCT44T45IU5PfqYPqUOe+jGc9OdB/9i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97c6235-5273-441b-1da5-08de2c9ee960
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 03:50:16.6052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xMj67KATvK/hGHUXbu57lSEG5y8T+b8NwHPU1NSXCvD9ms1Zxrh/1z6VF+9+7u/4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782
X-Rspam-User: 
X-Stat-Signature: k5nngnppaefomupk9qbw35jn6zb9k6a9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F3BEF40009
X-HE-Tag: 1764129030-317729
X-HE-Meta: U2FsdGVkX1/R4n+IAhVAvyAmAsLLmHVzX7JJV5qE6ajk9GGwA4d0Di5YzPISX1dBoPnLsks+9Jg8ZmZLIiMYb9IbcKCNcyjJ/hPxK0mFgVrNKe1Klvj/+7vf57jtdwR07s4kzBONpEj/cxYoKBXgf0Lj1vxcBi4DpiICDpXK34uwqmJmeB0SYYivp06lMAmqzH2AKgAW0OXyW9YWtz2YGKukX0TG2KBG+6EZmHo2L4FgtV2sr3hCa1JJZmQr8j7ZThJSJyWRBgbkCjBmEuLbJBI89lwAFLZU9nBx01MUTHMjmslq3Ik6J8leGseE4f9EWiQAeJOuXrG9SfZFY6cpj+dNscZDUaciwpchwyXgAJeCOcFiBljBBwfPhXvtu+/wqEu/DitB57rYNtZXQ+5XbUjfz/4V6Sc0i51g14Y3mtLc3HXJ7Q3w/yCHYATYzcNudhZ35nr+0E8Fs8RGAcBZlWcX8L0LmRqJKsyGud9/QuyKtgeLUckw5eXgLFzIN6MVHIcVffaDJrIfbt9yLrvBuSKKbLNjQ/DbXIKw3B/7NOvk67DcMkjPTtbLsxb8hnfPJPSwTyPDDFAcGCfYB40MHKi7GTb1BPHfUciFgbFph6y5TWQPT6uAhLDc8P2Q2DwrS7+iQKEmrIYGlgMoUuujGrGe0OLi6r58cDHUcVRDceT5mswhFytg3g7a433JJP2syqsWm7rZKgjdYuZaNQnVH9y8gP1ztu14NoT3+jCd0pwFWt1ZpEootWkaiuJGeuSLBh71/4zWRE3v37sCDZv+G+oZTCXE1hlVDo6Oq4dZ0cAm80pgBHklyHywpPbZcdKO5TQqKyHHkSK+utVG8OGGlSo8ic+owmytatKai4Bavru1GdRmqvgutU6+gnDijE2T1JIWn3RhbASbBpKNCR2G30G3C0LlGjC3J9BJVxWdgNktYe1pXB4WlNKuKSC4lP+QuHPxAXt6m0z9HeVY98X
 g1BxHy9i
 N6yAsp204IF0qy4o6ZqnnwwddjVGVvufHpSgw52n8FxCrPzE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

can_split_folio() is just a refcount comparison, making sure only the
split caller holds an extra pin. Open code it with
folio_expected_ref_count() != folio_ref_count() - 1. For the extra_pins
used by folio_ref_freeze(), add folio_cache_ref_count() to calculate it.
Also replace folio_expected_ref_count() with folio_cache_ref_count() used
by folio_ref_unfreeze(), since they are returning the same values when
a folio is frozen and folio_cache_ref_count() does not have unnecessary
folio_mapcount() in its implementation.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/huge_mm.h |  1 -
 mm/huge_memory.c        | 48 ++++++++++++++++-------------------------
 mm/vmscan.c             |  3 ++-
 3 files changed, 21 insertions(+), 31 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 66105a90b4c3..8a52e20387b0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -369,7 +369,6 @@ enum split_type {
 	SPLIT_TYPE_NON_UNIFORM,
 };
 
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
 int folio_split_unmapped(struct folio *folio, unsigned int new_order);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 771df0c02a4a..cab429d8fe83 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3455,23 +3455,6 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
 	}
 }
 
-/* Racy check whether the huge page can be split */
-bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins)
-{
-	int extra_pins;
-
-	/* Additional pins from page cache */
-	if (folio_test_anon(folio))
-		extra_pins = folio_test_swapcache(folio) ?
-				folio_nr_pages(folio) : 0;
-	else
-		extra_pins = folio_nr_pages(folio);
-	if (pextra_pins)
-		*pextra_pins = extra_pins;
-	return folio_mapcount(folio) == folio_ref_count(folio) - extra_pins -
-					caller_pins;
-}
-
 static bool page_range_has_hwpoisoned(struct page *page, long nr_pages)
 {
 	for (; nr_pages; page++, nr_pages--)
@@ -3767,11 +3750,19 @@ int folio_check_splittable(struct folio *folio, unsigned int new_order,
 	return 0;
 }
 
+/* Number of folio references from the pagecache or the swapcache. */
+static unsigned int folio_cache_ref_count(const struct folio *folio)
+{
+	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
+		return 0;
+	return folio_nr_pages(folio);
+}
+
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
 					     struct page *split_at, struct xa_state *xas,
 					     struct address_space *mapping, bool do_lru,
 					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped, int extra_pins)
+					     pgoff_t end, int *nr_shmem_dropped)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct folio *new_folio, *next;
@@ -3782,7 +3773,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	VM_WARN_ON_ONCE(!mapping && end);
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	ds_queue = folio_split_queue_lock(folio);
-	if (folio_ref_freeze(folio, 1 + extra_pins)) {
+	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		struct swap_cluster_info *ci = NULL;
 		struct lruvec *lruvec;
 		int expected_refs;
@@ -3853,7 +3844,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 			zone_device_private_split_cb(folio, new_folio);
 
-			expected_refs = folio_expected_ref_count(new_folio) + 1;
+			expected_refs = folio_cache_ref_count(new_folio) + 1;
 			folio_ref_unfreeze(new_folio, expected_refs);
 
 			if (do_lru)
@@ -3897,7 +3888,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		 * Otherwise, a parallel folio_try_get() can grab @folio
 		 * and its caller can see stale page cache entries.
 		 */
-		expected_refs = folio_expected_ref_count(folio) + 1;
+		expected_refs = folio_cache_ref_count(folio) + 1;
 		folio_ref_unfreeze(folio, expected_refs);
 
 		if (do_lru)
@@ -3947,7 +3938,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	struct folio *new_folio, *next;
 	int nr_shmem_dropped = 0;
 	int remap_flags = 0;
-	int extra_pins, ret;
+	int ret;
 	pgoff_t end = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
@@ -4028,7 +4019,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	 * Racy check if we can split the page, before unmap_folio() will
 	 * split PMDs
 	 */
-	if (!can_split_folio(folio, 1, &extra_pins)) {
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -4051,8 +4042,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	}
 
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped,
-						extra_pins);
+						true, list, split_type, end, &nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4126,20 +4116,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
  */
 int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 {
-	int extra_pins, ret = 0;
+	int ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (!can_split_folio(folio, 1, &extra_pins))
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
 
 	local_irq_disable();
 	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
 						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL, extra_pins);
+						0, NULL);
 	local_irq_enable();
 	return ret;
 }
@@ -4632,7 +4622,7 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		 * can be split or not. So skip the check here.
 		 */
 		if (!folio_test_private(folio) &&
-		    !can_split_folio(folio, 0, NULL))
+		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
 		if (!folio_trylock(folio))
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 92980b072121..3b85652a42b9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1284,7 +1284,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					goto keep_locked;
 				if (folio_test_large(folio)) {
 					/* cannot split folio, skip it */
-					if (!can_split_folio(folio, 1, NULL))
+					if (folio_expected_ref_count(folio) !=
+					    folio_ref_count(folio) - 1)
 						goto activate_locked;
 					/*
 					 * Split partially mapped folios right away.
-- 
2.51.0



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2A94CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 17:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BDC544015C; Fri, 22 Aug 2025 13:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26EAF8E009D; Fri, 22 Aug 2025 13:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135B344015C; Fri, 22 Aug 2025 13:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 026E08E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:24:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA742140289
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:24:11 +0000 (UTC)
X-FDA: 83805066702.29.FB24303
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB5A610000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:24:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VzZTQuF6;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.87 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755883449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bsyhm4lSCJ91hmv5PyyRZ1swVMlGRddBEHhCCIWWR4=;
	b=0nXP4eGPpr0Cii7Ml7aXwVF7riyjMvmYCFEjhBhiJRb6lkHHWykAN9kkfXYbRD+KsbHE5t
	5KIw8TNZUzQLgqUUHyGGDBjK6jwxXguz/FPguP8ITLeS2X/3nOu0yeUmB4Sw7BxyLvoW2k
	e0j7B0Bq1lJ7AQb+xxMMl4qOxB0jTVw=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VzZTQuF6;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.223.87 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755883449; a=rsa-sha256;
	cv=pass;
	b=NHyBfSBAFeIUgReWxk7MoJ3kHLNi3Fmwsz9adcJiUGuQAD+0b+26LvxnHwYCBlhQN6yeEV
	j2x/ak6t9/mQ3dyllu7IONpNh2TPwDSINRRwsMpFam84Xm6N9dFxy9c41yfTUy/s9it3iI
	bGJAziMGvM0H9QgOb16EvVFz9xHdWrM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e5E2RUnL6VsfHx3+lBfj3Xg69YPCH5dg+e6PHzA30cDHfGox1H+7ThssyS4pLUD8RoByfy4BUcWInyLhRXI17y85k2J1G2/5c7xRg6yMZwHzTxlxgMMzwu8o0lUrjN6Jf6Z1jlsCpGPYWgCBezntqzgTiGt7Y9zRb20sLIV+XUdPVjooUbykqnJPA70nJgswJoF0N05Ku4v0WPYSAYWglGLISTWCl521vVl8yeV7dwXzzcwBhFPkSyp0i19l7/Q879Xmttbk+69k2exsS5JF/Z5WK4k+ksApv8zc2qQDWKtxr0NT8JIATb3oGP4b2rsk1isPr8Ki7iw2BurKiXFPgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9bsyhm4lSCJ91hmv5PyyRZ1swVMlGRddBEHhCCIWWR4=;
 b=nxueVlM/sJVF/M189E+j/IGaJ8D+DYEQuHmr1sa2Nlj5SXYe2kKsXc2HDTWAN2ieU/tWZZ8ukyiK3ZxSLJ1XUfC93R0LrJ9IBWmuN9eeem4Sr44tOrVeN1wWLZseEXrNkgTaHIPoQzdFgmecJJfFhBdPLfyVEysMwuF+bmY0GYaTGqImbjINYZeK5ZqO5AljzMabqhBGRgIRJRmo+3n2T4e5//vnbMtcb1kzOCWPqZbQcnNB4AFb64pbPDY/+5pLcejMLsqC/QsYEqNW6CFTJSuR+IZmcywj46HHCtuzt+fkgzLeiX8bpko0oYasNNvUwYDzfxWUfI8sNjuoNB6QpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9bsyhm4lSCJ91hmv5PyyRZ1swVMlGRddBEHhCCIWWR4=;
 b=VzZTQuF6loJiBG7xhMgkKG5HoSwhWkMri08uf20wcHXqclhIVpjzRvNUSIDqbuzUgz0XBQfv7liigl1Wc513sH7fzBAVYopwMeYawc2McnTZYzCCSlZGSqbghG/UJmRBH2vodGmh7ECOdZ5YWGnucirgQq6kL5HMZhY9iUtDf6IzWAxnQoQPv49a7z3c9E4NoWdcRVaEiCo/ElA5hxmyp4qE2uAjlrJ/w6p6xXnjfSp2XryF190p6VxSGTQ66zuXKu5wjHfM7DylDFC4G7G+v9iXrMP+vD/oxYW3Slqd3hPJh2bnZG2rZj+wxjl4twhJg/nY6xPi6IeWGJEQeAZIlg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH0PR12MB8507.namprd12.prod.outlook.com (2603:10b6:610:189::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.19; Fri, 22 Aug 2025 17:24:05 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9052.013; Fri, 22 Aug 2025
 17:24:05 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>,
 Jinjiang Tu <tujinjiang@huawei.com>, Oscar Salvador <osalvador@suse.de>,
 linmiaohe@huawei.com, mhocko@kernel.org, linux-mm@kvack.org,
 wangkefeng.wang@huawei.com
Subject: Re: [PATCH v2 2/2] mm/memory_hotplug: fix hwpoisoned large folio
 handling in do_migrate_range
Date: Fri, 22 Aug 2025 13:24:03 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <15506AAB-D1B7-4C9A-BA59-20EC3AE819A7@nvidia.com>
In-Reply-To: <3c214dff-9649-4015-840f-10de0e03ebe4@redhat.com>
References: <61325284-d1d6-a973-8aa7-c0f226db95fa@huawei.com>
 <eb6a4203-1555-4aae-8320-99679cec90bc@redhat.com>
 <4c5d4fd5-5582-11d8-9fee-24828ac1913d@huawei.com>
 <8c9719f0-c072-40bb-b7f6-6f2cc41a31dc@redhat.com>
 <1D589FE5-3515-4ED5-B12E-D5CE23BA5D13@nvidia.com>
 <e505c25d-c4bf-4d87-8284-6aa0da2fd979@pankajraghav.com>
 <641F5B0B-2B48-46FA-AC58-3A8A4BEB1448@nvidia.com>
 <3702f6b0-27a9-4ca1-adbd-fb1e2985b2d3@redhat.com>
 <ocgxb3ggoaza3irdpea7xhcw3is4vbt24omy2qki36cxkmtecb@jpn7qtco3lvx>
 <345f7ae6-b2d6-44cd-b8b6-2bdd4b33e9d6@redhat.com>
 <CFAECEE9-24CE-42FD-8D55-FCE832D65DD3@nvidia.com>
 <A1B06D4B-5B39-47C3-94E9-93FE3F0A758D@nvidia.com>
 <c0f5492c-f9fe-48c8-98bc-d8cc8e7e00b3@redhat.com>
 <E0D87F2B-20AD-4AE4-943E-C126395C3CE5@nvidia.com>
 <66bc7274-ec2a-423a-8094-b8d4cc9438fe@redhat.com>
 <20250719192300.9e32c35ddc49f11c7954306b@linux-foundation.org>
 <a65acb01-282b-4b6e-979e-e3bc2fcd9b15@redhat.com>
 <20250820220212.bac0423a778d3b04b05d8bec@linux-foundation.org>
 <3c214dff-9649-4015-840f-10de0e03ebe4@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:208:fc::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH0PR12MB8507:EE_
X-MS-Office365-Filtering-Correlation-Id: d6e7c2db-177d-4753-ec1f-08dde1a0b218
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X8r4B5Hno8GCg1PF31ouN/76m7ep1yQdYfp/odm/Fi5yzbrpreHUv3gL6SD9?=
 =?us-ascii?Q?+DwP1LnnB4zu6J8fFfJq0yUicGnKVDVwHHb4uP3MGwLDs5YCdrdvRNJOuLGt?=
 =?us-ascii?Q?BXrl9+lN8FXbFyA75afpJxHHQfcNPAjBVipJqVA7xlBUi/i/RFf7vXirRFi/?=
 =?us-ascii?Q?8WYPjdQlUpmSwuW6OG/2vU3FpjtgB+rka66aVwcX9RszwocK7FsnYK+NwNBt?=
 =?us-ascii?Q?XywL/M0RymytRrNCF9vLwkH9wVC1dFY7nxDWvF9lvSyA4P+EINTMgc3oJ2dO?=
 =?us-ascii?Q?IH1mMmongvhnAhYKGucJ4S8ULr0ydJ23hC8ESRx9IzhCTSI4cFdsRL0wEtpl?=
 =?us-ascii?Q?A4N1WpDG9gilO22nUNa+mJY2WjwOPUNtNNXqh3xiDzXCDNFXrxb54lbHc8CJ?=
 =?us-ascii?Q?hrzuzuTxC8Vb6mnrGladsboKxSsIXYG3nPq8VWz5gPDyoQJDSRAxKgA6WmyU?=
 =?us-ascii?Q?uHiayO+KAd4ByGWGUF+O9I9UYpU0XXeyU0fGJIsMHriusFjxVQw6NSvJoXBi?=
 =?us-ascii?Q?dZX4WN5HeGvghtcb/CEVyElwR0akZQDxWZZXTsIXJNCavTNo6ePoCIJkHXiu?=
 =?us-ascii?Q?PNyLVhyqejft6gZKKQmE1rtvHYHHZ/BmTJobHNkRtbe6zb6PhK0+KkY4K5zT?=
 =?us-ascii?Q?+zr2cgnlaJwgsvLyG59PLTXbTZ4VljEfpji5e34WsvJq/dxhtSRj5eXEcRmG?=
 =?us-ascii?Q?HjFJZhqeRSoNmSP9aQQUyDPQJO0r1A4QDRaOec60rgS/b9qD1VVPPB25nCE8?=
 =?us-ascii?Q?Xjlsv4jrSlFB1Fi5Nr4bJujAq93Lq3FPHSMO6AiE+JYP1+Ifdteci/Vmn7Fc?=
 =?us-ascii?Q?/Wo4c96FOCaEhJ9vdY9fhFBKoTXckENDf/DDmWPfO10j+shv2kxCUfq3ETFO?=
 =?us-ascii?Q?h98zK2aUStdcCXxMANLcD3Uj08pcBWSgglnN3chWSpGZKE3A2u5EyuKkhGyg?=
 =?us-ascii?Q?vD86XgAIr2LXHvImz6P1FzwYru8O7mbII8h4vF5iY9fOvQ7wT8U43dzmvkMu?=
 =?us-ascii?Q?4xtKtJbUnUfW7ZtOCqu7+Ab4oobcjNsihsPqYhtAOUztrLgHqvIVgFkkkS7S?=
 =?us-ascii?Q?gnpKG5ByxDccCGzVNlKXQRLpp0eBQaThNp+mXdrfo8JGol3i8X6zc5znhehr?=
 =?us-ascii?Q?ucGqKbWsnHry8h4bdiJ2+doa5qh8AqxDaYbM1jlX+GUHzUzr3QbHdX74/Zkg?=
 =?us-ascii?Q?XNVebR4IaDdqDBLXQ7BzmTBoRGIYGsdvGFrcnEdjzgrmlmLnlwjIN16tEjLv?=
 =?us-ascii?Q?BfNVr7CLHGOTjGuSPzKJz6I81HFOGlMGK1JHBiF7KJ9Wp2Ua1l/E041zZZ9y?=
 =?us-ascii?Q?UwJZ937VFjtUVTmUlfvNHbtRgJy1+Wmxjs6cAMTYB+KhmHN1q+sJ+BCeRZOc?=
 =?us-ascii?Q?AjmA9oUAv35cbhs3eJ0S1WB4ID7FpV/x9z0z5bLnuT6bb52bJ7wnkdH+YQiZ?=
 =?us-ascii?Q?WfeXzkPg3ao=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y68UkTNb6bHzIj8IhB8dPzWe+nPGYCq/QbfuuNza+6Tc4wBi2DAG2u3Jk2wJ?=
 =?us-ascii?Q?oq6qbbYkfrV+9awDnbWXUcEWOd4tvPJPVVHk89dCBkKEhl/RRUGvtAYBB4qV?=
 =?us-ascii?Q?UexeYiJiEhxv+KB1gZTeXxPc05ACHfiv/HWBkE+tBcf1Bg+XVgWnbGp9gO2h?=
 =?us-ascii?Q?OdLyMkHrig9PTh6SwLf+H7+6C4X1nQEvOSaQJWOvaV8MQWlQlf10pG8651ec?=
 =?us-ascii?Q?WLd3D2T2asfSGsdDZeFvf7uRLI+jDYjWWqhxmfZGkGqNfKS3ZkTKCgvcICBV?=
 =?us-ascii?Q?mbn1yFrZP+R4TCTAfHdchlF/Ug58GYEmgDso8/hOyR+Ut1tnqYhFPHxX3mzS?=
 =?us-ascii?Q?4drafIgLP/ZDJBgfdsedaG9kNWw7B3O8Jd4c4rkGYgoc+1gWf5l5vU5+v58k?=
 =?us-ascii?Q?pgN7rSyy7XG8nI3WY3iU+c35zCCBtEzidAc43xWBHoBNzC4PPL8jEhgpuyau?=
 =?us-ascii?Q?rOqI1PLqS020Q+BShI6a1jyOZobZWPHMMWUJOmG4h0LTwmST5lJOoeqSaCu1?=
 =?us-ascii?Q?b4fUS9MqgqFNlRe2ndaEX5kS4Y7taRvHhO3lbSj2BHVSyAyCqNTHsn7RKbUB?=
 =?us-ascii?Q?L6rqYAZJPbP7DoTfqXnIPqzodXSJBwrt96lz2coZR5AdkEO9J1QVmdW0zpCo?=
 =?us-ascii?Q?0J8WyL3QdmoqV2hG2pDJn/cXtVqfwhIjxUv9VePjkoZSeUC+P5T9bE8tFX0f?=
 =?us-ascii?Q?60f+jzUl4+7W/7tLMt6s1FpxfFWFUTbq0er1sNsSOunTdqgbBSQK959aldYs?=
 =?us-ascii?Q?oyKjXf/EgM1jYzKVCKuoXTC/8rnEX+ZMyQ9uv31h75E8RL0G89DWP/hDe6t7?=
 =?us-ascii?Q?M2QXSCq5h/IUbX9CvCnR/PtBxcK16L3zfl5fJ2B4IyDC2WrVzVpt80nLmJVN?=
 =?us-ascii?Q?NbJoSxf63lZhUspu0r8cIfm/rdZgfD6pZVQ9hWuptG8qaVNqNxQ4gDdChZ9q?=
 =?us-ascii?Q?pMJoLxsMyp2tS+5hjVMhpoeVmxFKaRdXVcZ/0O1LHDl/D14U7JhvlBYBn0R6?=
 =?us-ascii?Q?9qbZidCG8WdbPyzB9fWDeAUjFCqtdr+Niyvfe5/lKVij8v0H1b51DUmNE4As?=
 =?us-ascii?Q?DBkQGveoI4Cb9qtcNJpbniO6KYppmIaOmANPzWyB0ngSWc+WE99DyszGh2ZI?=
 =?us-ascii?Q?DraCqa29U1tvcgdSDxNdyOEuRhFygEC7L39hb2XUIFP4J9tDToHcGZkqCtBw?=
 =?us-ascii?Q?M3LPO7c3gjCnHT7xb43puTS/mg8rkf6QLGh/wWH4blhVlH6MatcnUGy4is9/?=
 =?us-ascii?Q?V87hsAdqqKwJnYNhe73Fo8zpQSoi0Of4L9yoKpmOc2iwneCPoSWbPoSdKgLk?=
 =?us-ascii?Q?6exm2AxTrVB9D2c3ORBlSEbwtb6Hh4Ilw+2uTg5/5BgNgXnw4FcY6V52L7Qe?=
 =?us-ascii?Q?DOkb7qcSa3OKN2wpTCbzZQZYtzpKqpK/6u38UkOGnAoKKdLLZS5X96vmOm3W?=
 =?us-ascii?Q?ibPV5rFIqZrRiN19amEnVgm9+ok6am7gvVP58NC2TPcMjH0MEzb7i+5obI4W?=
 =?us-ascii?Q?wNgzzPvdvAZ4tzHGol8rllOE48hRJYaPsCM4q/oYr20Vb3D+qjq1O2J84WhE?=
 =?us-ascii?Q?0DXq/0XliyU62iwDAXVryLFEPKUFsiE0KddnujaX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e7c2db-177d-4753-ec1f-08dde1a0b218
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 17:24:05.7027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9rS2tcDvEtYatcV869VXWm9Qz1grmjGLcMav+l/IrlWNyqJYx2XW8ao5fW7TICNf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8507
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB5A610000B
X-Stat-Signature: 98kh3jncymy1brq5bocebq3n9emr4y47
X-Rspam-User: 
X-HE-Tag: 1755883448-755258
X-HE-Meta: U2FsdGVkX1+9rcz1y+1r/TNu+JspTDGcPTb+84Y9tV5J619c7aKgxP+NNHthtp2Z5YuqZozg0d4BprF+tH/HfrRBaVpLY8yH3XgOTosnBI3m38hxMZJHnnKVRpx4d8EY0nNx88xMQkm60Srjyit+LMjGdB6QhNqbkRdq/gxl0UXNDEa9gOKZmi2TWc94VktzSD6w10QollPQVlCTQNmWJ437SPVP42mwIN+bikntfwGQjCkq+4GDlBNLF/yXINUMzo7ThHApRE20F/dxsB+SFfx0IG9QnhkLj7KXiZQ3SBFnDeUOepM1qnflOxcJTTBw6X8H2krdtUyLTDca6XwBBNCmLwAFKidi41z2bNpQScNvVh+Tge7aWhSpuJBE2hR/fmoljNoYXMVTH9t0NcI+32giWpVc/kMzWEOwY2WVsy9PcU3OJ/2OpLB8IfztfoNzrJkUos2v4NQ29NRQjw8IX3LQMoP7R/PMe6HS2QOmL3HzuKzFnpIFbuTMfH3Mgc1jgJdVsT2+FPa0kWrVRaoqVczQYoSEVZ3hccHUy5GyG6v+EWf+PxRrnglnDt9VmrnXi+idDp9lxT/KmEYV7R1DsgMbaeJLj//pGbBnmJ4vtxCVjZqhVtJPhpv2MQnP5ZxrxS+lHcQAv8IDQIuoY0GirI1WIhu9IJ28szAKERBw7Hy96u4wnieNy9kqwmI7sW5GZmrCJJLNsnSDUKcFEytVxjwxY4CsdyPA8C14cZssX8a+UuBFBzD/uNOsSwxtTQJsLRGOPGAY4NZjNEFlXGylbyOxwQJfxJfcMlpM/Mz2BTcYj7aaEyt2w24SJBOY71kWQTkYWLGGFY4CUw/pPd19I1wo3MfR26yIUEUaWohp0gBSlo7VkOOWXMpL0d9Rfu5dqHn7A+LCwCG5irfrEDvvj/hsbm64quBFp0Ft/cYHm61HwnbkBej9rd6NeqhZLVMlkcAJe107LntYj5OKCUg
 OX7ka7Ot
 F3H6wRGS1BVmrcu8T9G88FI2S18t0yM/tNRN9j2LvdVQpH2VRFbGysZeJHs3MRnH01GwVwUwJV8EDoJ69IDNe0iKLA9ymFHeukwFTGqhyl12QcF4RSfJfdkBmKcr3HpmkhlPZnLjx0iNCoQqoOIk6bee31w+6TEFFKfp/TDlmyDb6dPKY60O6qESUC6pgnGDnN8hJaqSdy6n/n7pd7oerU1AR3vLL61eGpIeAv2zdUg+GJ83mKCg9zQ/1Fpc5uyXldTvcQaWtp3qT1evjjDrWXZp7O7BpPBIzXPJMf4V4A6Uw0kCxqj1dtK3u1QNxOgOGiOF/ACQp29t/vmp1iHcbpeN9M6EUUcXwaCimBiGMmog3jmryYrun8ntCplxhGnR7MT9hRzt/RQ9Cn5GUxv8d+PmtEy5rWQqiGVebPV6B9mcubkHjh/ZzZBW0d5SG2DX+M3BGmTzl7Gxu2zZ/7PNpuHYFmmLl0Zq5mmdYELFwbvLYCf+tFKj8IqPtaaMF/SOTOS5ve3q0Xs35MR6bQIL4SJAawxxTzMwXqojEnrGq/TqHzC4WWOxDvDqx6iaKVLe/i3v5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Aug 2025, at 18:07, David Hildenbrand wrote:

> On 21.08.25 07:02, Andrew Morton wrote:
>> On Tue, 22 Jul 2025 17:30:06 +0200 David Hildenbrand <david@redhat.com=
> wrote:
>>
>>> On 20.07.25 04:23, Andrew Morton wrote:
>>>>
>>>> I continue to retain the original patch in mm-hotfixes as part of
>>>> akpm's lame bug-tracking system.  3 weeks in -next.
>>>>
>>>> And I just added a cc:stable to it because December 2018.
>>>>
>>>> I don't expect many real-world users will be putting fake delays in
>>>> memory_failure(), but it's there.
>>>>
>>>> So what do we do here?  Add a TODO, merge it under the
>>>> better-than-it-was-before theory and move on?
>>>
>>> I would feel better if we could just not fail memory offlining. Memor=
y
>>> offlining is documented to loop forever if something bad happens, and=

>>> user space can cancel it.
>>>
>>
>> Pathetic monthly prod to keep this on people's radar.
>>
>
> Let's do something minimal for now:
>
> From 403b2a375a10c17fd6e2aeffbe0fdaf623faa621 Mon Sep 17 00:00:00 2001
> From: Jinjiang Tu <tujinjiang@huawei.com>
> Date: Fri, 27 Jun 2025 20:57:47 +0800
> Subject: [PATCH] mm/memory_hotplug: fix hwpoisoned large folio handling=
 in
>  do_migrate_range
>
> In do_migrate_range(), the hwpoisoned folio may be large folio, which
> can't be handled by unmap_poisoned_folio().
>
> I can reproduce this issue in qemu after adding delay in memory_failure=
()
>
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> Workqueue: kacpi_hotplug acpi_hotplug_work_fn
> RIP: 0010:try_to_unmap_one+0x16a/0xfc0
>  <TASK>
>  rmap_walk_anon+0xda/0x1f0
>  try_to_unmap+0x78/0x80
>  ? __pfx_try_to_unmap_one+0x10/0x10
>  ? __pfx_folio_not_mapped+0x10/0x10
>  ? __pfx_folio_lock_anon_vma_read+0x10/0x10
>  unmap_poisoned_folio+0x60/0x140
>  do_migrate_range+0x4d1/0x600
>  ? slab_memory_callback+0x6a/0x190
>  ? notifier_call_chain+0x56/0xb0
>  offline_pages+0x3e6/0x460
>  memory_subsys_offline+0x130/0x1f0
>  device_offline+0xba/0x110
>  acpi_bus_offline+0xb7/0x130
>  acpi_scan_hot_remove+0x77/0x290
>  acpi_device_hotplug+0x1e0/0x240
>  acpi_hotplug_work_fn+0x1a/0x30
>  process_one_work+0x186/0x340
>
> Besides, do_migrate_range() may be called between memory_failure set
> hwpoison flag and isolate the folio from lru, so remove WARN_ON(). In o=
ther
> places, unmap_poisoned_folio() is called when the folio is isolated, ob=
ey
> it in do_migrate_range() too.
>
> Fixes: b15c87263a69 ("hwpoison, memory_hotplug: allow hwpoisoned pages =
to be offlined")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> [ David: don't abort offlining, fixed typo, added comment ]
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/memory_hotplug.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Acked-by: Zi Yan <ziy@nvidia.com>

>
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 1f15af712bc34..74318c7877156 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1815,8 +1815,14 @@ static void do_migrate_range(unsigned long start=
_pfn, unsigned long end_pfn)
>  			pfn =3D folio_pfn(folio) + folio_nr_pages(folio) - 1;
>   		if (folio_contain_hwpoisoned_page(folio)) {
> -			if (WARN_ON(folio_test_lru(folio)))
> -				folio_isolate_lru(folio);
> +			/*
> +			 * unmap_poisoned_folio() cannot handle large folios
> +			 * in all cases yet.
> +			 */
> +			if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> +				goto put_folio;
> +			if (folio_test_lru(folio) && !folio_isolate_lru(folio))
> +				goto put_folio;
>  			if (folio_mapped(folio)) {
>  				folio_lock(folio);
>  				unmap_poisoned_folio(folio, pfn, false);
> -- =

> 2.50.1
>
>
> Man oh man, is hwpoison handling a mess.
>



--
Best Regards,
Yan, Zi


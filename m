Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BADCD8C9C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 16:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6DE8E0003; Thu, 13 Nov 2025 11:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E818E0002; Thu, 13 Nov 2025 11:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D808E0003; Thu, 13 Nov 2025 11:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00D018E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:24:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8A975C0A76
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:24:31 +0000 (UTC)
X-FDA: 84106106742.23.D51F80F
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010069.outbound.protection.outlook.com [40.93.198.69])
	by imf22.hostedemail.com (Postfix) with ESMTP id C398BC000E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 16:24:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WMplJWs4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763051068; a=rsa-sha256;
	cv=pass;
	b=KBalref6gFiwhp4dQri+EXYyz8qpskZ6vElD4N5hukOT9HbVKd7rwTFE5+3zjzTYAam8ry
	iierNjyHl2rzUqaDW6K8Ts/cFV4FTigys7KYUN5c/U8hCG/9lgGAWCKeAi/nvtr4GvMq90
	PIs5oX3aM6f7QqWEm0Dn2fXsFoYIpVQ=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WMplJWs4;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.69 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763051068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRcyiYQJEvHFFpPfOgoGJD4jyYcSVyx60+vZuQjA0HY=;
	b=JdOacn5yx1rauoj4CeJKIzzlLqbfgs9B01RBvTcjr/HoMxtDuTQANEWbgoV0UZkt5nKWsc
	phmhfZt4ESeE07gRsP8XRnD0qkvpM4AZsIMOL67AQU6AzJGKKwbzdi4noEy5dwO9H+gH3y
	hKQSmFn62f6WOtINLeylhmSRxDEX5Xc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kHDLsr1a7Zg+6gEI1KZFn1hSxO+R7IAw07exRbh09sR7+UNUAlsEOIO5hxQLCq32GIYtRKSuq2xF56ZjjAQ1RICPkZcfVizmTHIgg1xyOCeZpnV5gm+V538X/SNitlciDJ6ZTQGG5dajZ6ynpQD2irn0yYOM+gym2noKTT/sUApZU60xqFAlOfSWpC4bdM1yulVbRU0dXGmvHmkNu/NHCf8WxbHKle/tSJNTV4b/iGTKuMRoGx2s5CpMwRljqbCTb4CvGLM3KPXdOuGnWCDXnYb4/pwcrBZeN9e4f5CvRSLhRLc77NQH1XrHkNf/WUAkS+lilvdMfhpez/AlTW3xNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRcyiYQJEvHFFpPfOgoGJD4jyYcSVyx60+vZuQjA0HY=;
 b=jvbxudT/lAQAhGKfjh/S1q3EvlxswRksmz4KuExLs14mwUqN+9NIwKT/s7J0eS85QHUHfth2Yp1jagUTGv4lExOUqvBfj6yz2bU2b8Qo9xLcWTnxdsut3QSQkGO4/w1PN+YwD6fyJwmYwg/4VRRX9WJQFRUF1SVpuMz9xrotkvK4MXGrx/h+pJRCrWSk4/tR7oZ7lpu/104pa8hfaWglEdkDqZIgQEFeFsVz2fFQp+a8t+Y8Kkl8WZpzcj8FVH4SVlIDZ0xGjKIWp6XDJqCIecYuJ5BZiWa1SWhFVsV9Mdb0/4aofNnFyO7D55ZUeQvQK5c98P7SntAnUQKZ44UWqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRcyiYQJEvHFFpPfOgoGJD4jyYcSVyx60+vZuQjA0HY=;
 b=WMplJWs4ZCxqLKkbgrhSNwEGEPspFnBmuzU1+wrUru/eVYv3vTrXIYGVnfeDpTyRBnxCbSNAzAZlrZv3I5WNEDgLo6Z/78b+RQz38MKS1KvQCvRT+I4Lqu2EQDWviEuL+NcJiTiHaFXshNHcz6vBv1rrqxMY5MJf3AXEjYCfhUz0+LVDfVRPhtvgySeVoWfTZhVnqoruq80tr15qQXKXQwY3OncEjyS0OsY25rSL6lOSC0mnOWFvYKcQJD/CuvXPj5iv3mhwt6KNPGwSK4eRmy6OTREa4EP8uNZoV6vVwboFJHzCxUEqIFeoNLqHrm7TUB6Hy6ucENTIJjqq15hcAw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4237.namprd12.prod.outlook.com (2603:10b6:208:1d6::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.16; Thu, 13 Nov 2025 16:24:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 16:24:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Francois Dugast <francois.dugast@intel.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 David Hildenbrand <david@redhat.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH] mm/huge_memory.c: introduce split_unmapped_folio_to_order
Date: Thu, 13 Nov 2025 11:24:20 -0500
X-Mailer: MailMate (2.0r6283)
Message-ID: <389A23ED-106B-413C-B13F-BB0F1E90B6C8@nvidia.com>
In-Reply-To: <8ffcbd7a-511e-499b-919d-0c56ccc3c63b@lucifer.local>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <aRX62SR8NLps2NWH@fdugast-desk>
 <8ffcbd7a-511e-499b-919d-0c56ccc3c63b@lucifer.local>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0398.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4237:EE_
X-MS-Office365-Filtering-Correlation-Id: 692ce656-96ea-4cc8-c822-08de22d11b85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D58eiOjJj82eF+Xz7xU8PRm7GyDiSGzMvCF+qRvt0PoJ/V7lnhpCoRYesH0R?=
 =?us-ascii?Q?Y40pVE3Bojt/KdcL25YuqREXdPjp73334c5D0JFFhDGvN4c5VcsOJgbICvkA?=
 =?us-ascii?Q?vdg1TUMlRVD+wXotz7k1eqU6txM3a30NbVuCZsqoujKiBeKt7OKMoiZUw4P/?=
 =?us-ascii?Q?fHao7N/yztzu8u6lvh80DH1ys5bnnnA67xQuhUx6ST4HUZrRjzuaOHNbGJrG?=
 =?us-ascii?Q?AARTWlickEHOLCHlAR9CxyddRkUA4hUNkILtA58Nhb1ycKjna8q93HHCJPNO?=
 =?us-ascii?Q?VlJ0ku2IErxNtnROF199bbCUqzz81PZQgrhkAWNSWefift7YCVAKNwhEya+N?=
 =?us-ascii?Q?9lOqkxAASs8nSro45W6nFmrwpIKHapi1DzbhLOMT3TbHfspieqyVJByc1eWP?=
 =?us-ascii?Q?0PF4eQ4HFNupBQ4UU8IUMBKItJAcI+y5vy0/lUEcHr+pxobAlxmQtgFQ6M0T?=
 =?us-ascii?Q?uulS9DKxMyioDST1ML+BCQVBNlfcuqSUUM8+1qZb/YeKIhuVYMk/2RgSiSoa?=
 =?us-ascii?Q?yPgomuNYyfKobp0V/F0flyNM4DdCD1jRQn83AVpZtsZV7fLa3gjBEH+1SfPV?=
 =?us-ascii?Q?GG6Rp3VEGBmEbrdbVabsWk9W8yZq/FMFvXR3PonvUvoYIYeLkUD9gG7FKN3v?=
 =?us-ascii?Q?ZAeOseEezV3mLKsrAE2jcyk21W4ug60ShGf/TEdxrKYSD4PltOJm+oljuAgf?=
 =?us-ascii?Q?wE0eyOAJRFQqmqjxZmrTGBgKfG/w9j88srEHreUMaKjoJl97C50PbCtT2KTj?=
 =?us-ascii?Q?VvgOEkes1UY6sHf/BIfmZmFGjX+DfEuF2/5g9tpptCI6IGtPx6y5NYueH+29?=
 =?us-ascii?Q?dCtkCQ0sOLIS6aVXB0sCpXU3JyoTo+Z3T0MBRcvycLkx5PhXaIOgM9EZ6rFv?=
 =?us-ascii?Q?YMFdeRJ+CWU9lRxiGwnNYOBkiEHpjzTG9XafwW/DvlNXVjhuVVR/TwWddE1p?=
 =?us-ascii?Q?kVMdDK5XVhsqGzrP+9F0LLESqezm29W8XHL573qwJz/4pGXcTcnxmAH8tP0D?=
 =?us-ascii?Q?ac3/0Zn0kFTv//mAAxsXHtmgDeq3+yIUCQPGwGlItRXSTUT0tD/8NJ/tprUl?=
 =?us-ascii?Q?JsPWupeAcUyc/vS3aebf4ehZfY38Gz5REh67lnxjkcqyEZ/U7e+jSozwkDSV?=
 =?us-ascii?Q?tWRU10mS13qd2P+tevik7YjRt+8eMyYC6Y3B4yCCg98mt5e26gu9WMWgWXe+?=
 =?us-ascii?Q?A3udRb5sKVvebUpxsDZtxm0SnDXffB1Cs76Iu3X5ZPtcErOXYQTy5Jf5qBpM?=
 =?us-ascii?Q?foeCOvVC2cbbou+zFzYEMf0IsIVk4hfIlTpDDtpn87A3dJX7w7uZYM4rGYxg?=
 =?us-ascii?Q?BRLDyuhIXjeqzlVahtuyt0krwQg5a4toqobJKP2pkf+yvgT/GA741FhdFaRU?=
 =?us-ascii?Q?tqHHb50A8LNoEnYVDvxPzKjQyQbAHD33RYfNNOKw9xMZaodcejbn+cVFmmcr?=
 =?us-ascii?Q?UWBIdzIMlLFGSsj1kkjp0sUpzOwAD9/0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DhjjWVESUyS6WC0efEv9WZAsumj+9hTTNu5Q/tgUJ5nuf/o066PsRQvXyhxP?=
 =?us-ascii?Q?2sYwTeZ+NiKEeKbH3IMK1JOwyStDrnRXSCXdVvWQih35OFRPB2Ocbx6vEf+N?=
 =?us-ascii?Q?8EP5s9wZWLl1tvzqljgYcbX0cUxrlkkRRSardTGhqolqqxzL3snu9+q7Vyhq?=
 =?us-ascii?Q?MsUo2P3hqDM969r+1IkKoK3Pl2Uh4HjiBRjRLqB10ekVnmv+PFqnnDVgcarf?=
 =?us-ascii?Q?2A15aveZm74mloPYXGjw3Ctg/vQka0PnRRkYqwk+rnNiDjszkSrHWoEw16Hk?=
 =?us-ascii?Q?s2lJwkbpuwEyOxjZ5wkxdTB6KXC0ca1g928WmkgedfXZoW201W99XZLo4mA1?=
 =?us-ascii?Q?LYjwKZo2msIS5zekrRSvGHAyGbdsA/mCzQaG1yGKMPoPIPtoZt5n6mXIXpJ/?=
 =?us-ascii?Q?LQBcCpWFwvIo5NLoZLc/AblS8Iu/ZpJgJJqK+W/fkBtYzi7wzdom0jMY47rr?=
 =?us-ascii?Q?x1Ku0sKmidv5qBISWqKfMWLafc5VlPbsFDcXM/TOEn8p4mYL7ONWnwtyYzHw?=
 =?us-ascii?Q?4pz7NHPm/4qlMm4H9seZxvS5cPKUzfN0djacWdpK0GbAejpuAtpbedWHr/zg?=
 =?us-ascii?Q?e3GP/4+NMdXsHk1goKFvRNHvYgKvHWw1GIfXsbJ7RKdwUkxS4fIHGEQc+fna?=
 =?us-ascii?Q?nWS5PhlY7i2I48Kpi/TTy/DiHmVvrdkb78ssNeORZYMPAe93/c1ylzxvj3oI?=
 =?us-ascii?Q?bp3b0+Gjick3lAgvOPR7AYyzPcL9ETnXyc0UIX1PZS5FCGPbI2QD9QRSijxq?=
 =?us-ascii?Q?uqpNpohKOtMPZlz5QDUNsu1umFmm97RsKDyqE2H10SsSMDDFWWNcHi9T06lQ?=
 =?us-ascii?Q?7Skw/VaQruORhNVpIOU+7WtUijlHX/jj47s7CrKwS6B1U0LMQB/ZgJIBx1DY?=
 =?us-ascii?Q?R7bbnYJtK4bwOcbHglXLSoNdu/LQYGZdjhZwuC9nhUabkiJPknXWeIYNZeOA?=
 =?us-ascii?Q?/6CvpKQq494fswaiDw8rXD0W93rxb9qypxL+XN5itiayqD7FqrQgQCW5j+YQ?=
 =?us-ascii?Q?cfl6XPY1sb1pHarxLlYSXAfIvsH++qZ6q1BewU6++6ZdxRM8xrBu3m8AfmTh?=
 =?us-ascii?Q?HF+tiuNsBGL8n+DRhD0GmevuQFtxB4ISzWy9t3M6FWL5udDIZ1qzbQgX63oe?=
 =?us-ascii?Q?YbiBUifVj/MHMmypZZpLxdCsTLjw+KlUDYO/HT90nDfnKi1h/UxKKDVnmys6?=
 =?us-ascii?Q?OQN2oBD+VAuLrLR1Xo3W0PwiUZ2WGubN7LWsigFZIJW/r5cd7SPPI05rzYvh?=
 =?us-ascii?Q?lYQ2i8wuPaBmrXdC5GfaNs8SMg3OwuKERnGIJ3Bnfe94EHugY0onnkL3VnQa?=
 =?us-ascii?Q?o2dYrFMz/1oBRoU6vOjoeUiW1RDY7dBA6uTrBSlZNIIk6riHvMaM75lOEyA9?=
 =?us-ascii?Q?b0hhIgEWxh1x7fZUop8Egf/2oSSI3hPw8OAmeKqSFMgBwKNNzAZkRS5HpP5q?=
 =?us-ascii?Q?3zi9PjTDARiMsa2csSRAk/maDq6ZDlgU6+2lTFiPBxSjLW5QvinsdA+/YL7n?=
 =?us-ascii?Q?cQ5OseHeK/4N/4bCuKHx4SJMlfj9pH84a4vpQBvhABLrL+vrppZO09H7ASkX?=
 =?us-ascii?Q?2ej3rDtY89cDVVWD+Bn/3b+Ow53PF/Lz4uooGmHu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 692ce656-96ea-4cc8-c822-08de22d11b85
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 16:24:24.0163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: srUInuUWdwsddlbD87+EHC3IlbKOWEvo61iLE0oc23/empBYzK21aroaWPyt4+Sk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4237
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C398BC000E
X-Stat-Signature: wy3cyyxzy7z7rdq3uxs4wgj8c7qa7sb4
X-HE-Tag: 1763051068-113732
X-HE-Meta: U2FsdGVkX1+xZr2+E+mpdlYlXQczK1p3xmPsmqXW7xMC5AKxbducjztNy6RZegpaWSAT9KRu7mNEPlVC9R+3CwYzv2vUS/5GyDkfWCcSxgkD41rjT95AVJkIwMh3mhE81ojRzLM5A1+U2qBIzA8eQ1ZXCcDInM76qqjcc+PG7z70eCwJQbT1/YIE7++nT+T+TSPafZOlYQqQsLoiZWG9/Kv+61wypIKAzGLvnlnKRhlU7jiSo/RYbpnjiGDts/M0oKsnZyYZhaQqmVTAmmkEXfu5dwmOx/8mL0gAE5h4zBvqQSBhnu5iqs08EYykjDf89xeka8cPdyU9SKcSmnMQer8Ta7LFL2yKhLHS3Bh6ccky2U4o4k06QF98loZHlOxSIDwJ5OQiykpwL+dVNaymwqCbyqXd/3/wFAAtDhvRKRXNfjIkuQ+pxrzmfFv41PWaZbh+Zci6bdz/QVtY1k80CLDj5i4qBBKlLX0//ZYwdxTngV6QbNSZsLlfkyg0eiGXzqfpXI+fhSVsDNN1gHSG8DiSx0BdbLv+i7V5avrF18C+wPC4N92bds4HO6792Fe9Nt2vvYT6K9rnzM0BgOw8bAFr7AUWI8vOvgI59sUepLizS6dbEWnE6Zns8WYD5zf8pRkfCpZhTyHTNrTfA+HOeFOOAYYi/cUcXPnBhz5CHNmC5Yl3WFUt6hbmTqnVnJxs21Zfv7xwAVzWnk+c9bwxSguR5HstvrRnrBDbiRMswqerGhCOTkGZBhDpxbU9XO7XGXQINleLFntOqxicjEblkH29l3XVT4nJSpAKuO6HU39TsvBuSRM0kmWrpfFgAwEORAesgzkqmXIYzHsCkwUe1+cgc3gn3Ggo+EwnMXe5tOjbQ6zjM7cwEnSsOJZ2266uXxRcGdvEW5XiXqkIpX8etI9XWpNRpNZEu7V/kekBmCynJMbU44tRsJtn7qp5yMMaV3zVQgFd7/swOpRJeQw
 SLvV/fJo
 Ttc9pVp/tKMMl+OWg0bPN/lb/PVWfd3W1cXdEyqrYB0hQHfhWny4MkC5YYCyIsQff5sRu9xv3PYqMbz8E1RWd9bWAegehIVKKyO93X+J6WYX2r8FcwPEU3DmS06XEPxpWPtWwcS8nEIYv0aRhj2KyhzqRMtxmRv+zeAkQSmZ+cPp5/vtHESb6Y/bSZqEXDzNxUNypwCycYCrgmsyy1n0O9Jk42Q5eYtA0mJvAsW3ZRTrJJFnBIE5bPd7BNhgbKEvNw6WRYlvH2dFS3M1uFVW3gfJMOdtj9CiU5Lj7z22P8rV/TCPbYlE43+x5cqNO0V+UuhuCzXVZkJVhexIR4y2nZFy3tD2g+TwQUcGCJKa/gd4FU0Ph3PaLnADvIwYCBwolW5EC7l4va0fvChKueIbUKRMAfCnxrIq57g8A9HdeSkdsBhMDpxPq3qna77QJ7Pggf9+S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Nov 2025, at 11:02, Lorenzo Stoakes wrote:

> On Thu, Nov 13, 2025 at 04:36:01PM +0100, Francois Dugast wrote:
>> Hi Balbir,
>>
>> On Wed, Nov 12, 2025 at 03:46:33PM +1100, Balbir Singh wrote:
>>> Unmapped was added as a parameter to __folio_split() and related
>>> call sites to support splitting of folios already in the midst
>>> of a migration. This special case arose for device private folio
>>> migration since during migration there could be a disconnect between
>>> source and destination on the folio size.
>>>
>>> Introduce split_unmapped_folio_to_order() to handle this special case.
>>> This in turn removes the special casing introduced by the unmapped
>>> parameter in __folio_split().
>>
>> Such a helper would be needed in drm_pagemap_migrate_to_devmem when
>> reallocating a device folio to smaller pages.
>>
>> Could we export it (EXPORT_SYMBOL)?

drm_pagemap_migrate_to_devmem() is a function defined in tree, you
just need to include huge_mm.h to use split_unmapped_folio_to_order().
Why do you need to export split_unmapped_folio_to_order()?

>
> As a rule we don't export things from core mm. And certainly not to non-GPL
> modules.
>
> Unless David feels very differently or there's some enormously compelling
> reason for it I'd really rather we didn't.


Best Regards,
Yan, Zi


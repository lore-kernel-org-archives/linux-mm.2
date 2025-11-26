Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA8DAD10379
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 03:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159C56B0012; Tue, 25 Nov 2025 22:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131666B0027; Tue, 25 Nov 2025 22:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020926B0028; Tue, 25 Nov 2025 22:52:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E388E6B0012
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 22:52:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A85FFB9EB1
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:52:00 +0000 (UTC)
X-FDA: 84151384800.18.7B9E327
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012024.outbound.protection.outlook.com [40.107.200.24])
	by imf27.hostedemail.com (Postfix) with ESMTP id E19CC4000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 03:51:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GcdeXpOW;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764129118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+G66bJstCt+lztKl1UgXEHcLQ9ZTZEtKHy5ZQ8w9ek=;
	b=gDNxGXjUZgYXmVmroE6oib3d9Y1gch00Sa9rRd7hq8TcWa3HJvcoK3HJKVsgHLYNPCd+eP
	onYKQbZFsQQLS+PQMy2+S4dVehvdordg651MlQunvkOLAA1h3SptF3DFGg+D36LtUaaZ1Q
	vE13UKfFF0jcGzlvcJxZazWV3IuLB1I=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GcdeXpOW;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.24 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764129118; a=rsa-sha256;
	cv=pass;
	b=27wfoArt+5SIpYwEKXDSyOYMPbajiTJ57q6qPkG6XLjqY7DaennTzZduso+HFzBTjwe9GS
	Uk2hqOendXL9MVbujkWwuaRgnA++mGFyXu4Jrd18SlaOCyg6x8/JS9ULYbg8p52u2U8sLr
	hQf55SV75SAiuNdwoeEq1bIWaEdgpaE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vQfVN12VTeeZfBrC3o1DGQqyh7/m7kYJyJtO4O9/mSIG+orhIWgE9AL6wDDYmqqnkR6YHpUjZC5AYnSRePcLb7WD4XAKP5dTaokcdwcLeKvHT4SudEe9Rpn2QxNfOnHT/OR2a0zxi+HyRayiqrFyJ8mNt2UjC0dct816m4X6Pfbk+zAozcVa27CVXf5/Npx/eSNWcvtOnpycQv2DBBOFnRBlbWQ6+PvZ6G+D++cFrZTez1SiV2cknOc1TNg1ESUQU0bZpoGhebRWUVYJFC2a/r4FrLtCyUxqjCOHeKywlMDgUmto5wAv93szr60XNDQKYCZTS4rQlkt1oY2PtsAOoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y+G66bJstCt+lztKl1UgXEHcLQ9ZTZEtKHy5ZQ8w9ek=;
 b=csCTQV4XtkTBdPzTgQc8UK5R2jLABHEPOFLd6YCKvOzNR3Tj/lTWu2zsQHQyFPJUBsR6Dsxhn9ftHRAb+/tBu0E4wrZaZJBb7dGMsDeaQ/h5yzgKkfQ+1FRVfK3rLPHZxzwMBoChQMEAcI7wDkUdQowyuVuHt2OUPaSoOf+bw9djTPHvrxwIprLI9QDkSUMXtONj8HIH6mNdaHAJ0V+swmTPJ8zmdFA96A1Ga6Q4dV/znIJomhYPkoVeNh0f721cQZa0mc6hzpyBfxUBp5ieVLzL5FoGUDImyByux8r0ZCJPMtGXAfo9vmeVWuKsKWgmRYxPnon/ccEiQfD1f0uxfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y+G66bJstCt+lztKl1UgXEHcLQ9ZTZEtKHy5ZQ8w9ek=;
 b=GcdeXpOW1M+VmVg9c0JQg4HlZg/uwJoXuOTLpVx+Oaud8jbxY4WBuubA+dr9+li0dVCuCH5ciLFVFrD5l8jbuZQDExoMZw6X2Fbbt5asDiynQD9ed5Kv65CpIxvWQK3kK+kTbtzfas5eco2JWd3IsYfbJQUF5iH2HmH1X8f99UPq8RYUnDkCL2ZR7gYCanRVnjNVJpBbWzL5FTAomyhZP+7Sn43ZMVgdHcCmMzINTso9hWth5o+PIMitjpFJ0tLLG2ga01psFnqWcV0T+11yHIEsfif7akcFL1WYLhhJrEMw6oBoDuUR8xQcMbyxFx10wmDYELKeAHlJRKjQvXp5PA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV9PR12MB9782.namprd12.prod.outlook.com (2603:10b6:408:2f2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 03:50:19 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 03:50:19 +0000
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
Subject: [PATCH v3 4/4] mm/huge_memory: fix folio split stats counting
Date: Tue, 25 Nov 2025 22:50:08 -0500
Message-ID: <20251126035008.1919461-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251126035008.1919461-1-ziy@nvidia.com>
References: <20251126035008.1919461-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:91::35) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV9PR12MB9782:EE_
X-MS-Office365-Filtering-Correlation-Id: ee06f07c-8520-49a5-00b8-08de2c9eeb22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IDeSUwJ0RANnwmhjgBYr5X2h+EcDIV0OX5otm3jr0sR/3SwdlpAVPlaXoTnY?=
 =?us-ascii?Q?J5mxt37gkLE31+ABOPQXrIoNdYHaKJalX/ga0V9VXyYriF3kpTUtwQIzqwSc?=
 =?us-ascii?Q?U5aOhMFKrzqvxZnqPGvWdxfMHDtTfzC/gEXegkDZ1UVnGLrE0EqK6jwOxY0R?=
 =?us-ascii?Q?3DZa1KiLrMnLM3CumsSOQeYOk9MlIV+idcT0QY6NGlLFaXgN0lBXpqW5/y9J?=
 =?us-ascii?Q?eH65txO9J9acJI3uZL1wXukNcmLmX3lPCqaule+PsukuBOHcw+tjhzRT9Uo5?=
 =?us-ascii?Q?itI8JBM2HivwzOqeV0IRC8GIV0S1S5361zfgUnPeOpDFzOz9fPNWDv2NNiET?=
 =?us-ascii?Q?l3jbB8Y6xtoUWtggk2+cuRsUoel0ZwMD/o1EdJQ353NG2wBU1BO8SLfNM/kf?=
 =?us-ascii?Q?tdGQOkX5AiY+VW1hd8rS97neqtaWVBgDBDwJj92WNyzG2KFddILZHhKHUHK4?=
 =?us-ascii?Q?RTTcyY+KivHQ1K9gN8B170uhMQj+7lsNqBsvK/j3HJQ7A/qhCqvwQ0yibUI2?=
 =?us-ascii?Q?A1rTaz3f/oNcF6Vjj239uwA8fdlDaSa9ejOzrL0rDt/6j0zihDTyZBCwmC3H?=
 =?us-ascii?Q?atDGp8li4W/nny+1h2Vstk7rXQgVfihzF2BhxjhD7AYQqHhPzyaAT00hNnXz?=
 =?us-ascii?Q?991jMcKRUv33ZKJ36GFFa5uFXlqlxEYzOVceSJ9Q29MveuPa68XSIzqgTSAN?=
 =?us-ascii?Q?2Z8T1wNTLd9ONKy4ZSSMaYnyty5vLNwpfUVKEKzn8TAsS870kdUEAI7FCryu?=
 =?us-ascii?Q?KLfhji4UR3e02CQn/KdLmpKh455z6mbhENO4LQQ7iZaRQ0MXECmU5j5s5/Db?=
 =?us-ascii?Q?G15IH4rk27MScdfnTrHrxODgmsC3zo/JzCbFuzLlfRP20mrlT4v0WygGUNU+?=
 =?us-ascii?Q?g4TNb/PpLDIrY4wA+eqyfVhGmFRC4rv3eCXPkZI7l/2NNaL7JBNyasU7jV7s?=
 =?us-ascii?Q?EY0uBMCy7Hryj3rA+TnEASjxS1l3GYzhFULScVvFZLF4W5oYnRWA8+Cz1CIV?=
 =?us-ascii?Q?D+6Fm8iisuNkRDT4GMLffijp5NF5qWUoLFYfViAnQB5bkBbJzWZ0TPPYgE6U?=
 =?us-ascii?Q?sKTStxcobI8+Lgi9sfBXPvmn/99Iwh7ITJMS0g6PPk07stunlFL23hvBzpE9?=
 =?us-ascii?Q?aT8q7xp39EP+VcJYB4BZPoqvG8oBwuAqmDxHXUwnZpm42yJX+JdnV1CUaY1u?=
 =?us-ascii?Q?O9vH4mNdpl+bjKqkB7X7bAZ2kmdU2CxFcOqdfdkd34/2SbEsfWOOmvGAf91c?=
 =?us-ascii?Q?jfnz2czy4QJ+IP4C1XaAHEw5KGuYdJ94qlvYOMNdiYluctmDf2PBNUJFR+6Y?=
 =?us-ascii?Q?1xWzPNFMp6fSBaZKahclMksF++aa2Kx9MVcE1aKmkohWzob2XdDN9bhFYJlV?=
 =?us-ascii?Q?7KKMCpDWdNL6VIqVjfS9T39Fhb7I9wsbTuZym0fswj/HRHZiJ+5F+JjMYSyu?=
 =?us-ascii?Q?EPJJs59lB77lC9zvv3wvjkKGI27glyES?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xb5yjV842NeC3MsKQTxlTovK1b5XDnndTQZx3EN6jH28JiJtDbdxpRODpTaH?=
 =?us-ascii?Q?Lfuj+G3wQGhHNtsP22WwoxH9VzcX1QiJeHa/1f7hruCMQ/YtCBY4o2SeLqV2?=
 =?us-ascii?Q?+cTpzstab79En/4mCPdSlCZazMr2T+MJiL0TxewESsPLriPgm3a8cNcGsYyg?=
 =?us-ascii?Q?mt/As5PyBcApP+u6W7rVZkzwCP9QJCJ+mFBAxzDEhvQQfTbfE0XfDg5CqPSy?=
 =?us-ascii?Q?Yoi+9ern1B0NqurdqPrwclXwczbkY+uA5ykM0qh5HcaPjXrw72ByjWSpOoIm?=
 =?us-ascii?Q?c2+WhzoQM81YVzbHUE3it49WA0XU1c8mFdk70NnrpsyS7GzW71zkWhSkFV0w?=
 =?us-ascii?Q?M/fqd0s8x2rY4N1m9HTUW4sMtQ6+0qAEkpPim1XTIZtKPfSeMvh//GLTqrZF?=
 =?us-ascii?Q?BUMy5prjFRI0ZGXP70CMYMMK5RwYCmQX4/YiC1ACLY+HefSF5p/JTOxDNgCr?=
 =?us-ascii?Q?FrlwzEmGf7P7yUhFikjUOq1fL6GZLknXEULvIseDlz3AfUaUxJZOUcRn0XnU?=
 =?us-ascii?Q?svIRLqEnys637zRQSW5YStabSfqt1Bmbh3aA5+PcFCgeOmSjHmQ5ixKIfx3q?=
 =?us-ascii?Q?DWhhRl1BP85boxJlC94ewk1Sbj5emZ1iMfstY7t0OK5wolDfuHUWor5Bne6b?=
 =?us-ascii?Q?8N+ZOdD1Lrz0IQzJmAubJ3xp5d2W7TchDwMioKk4Iox0wdtIixGORvDqMI5+?=
 =?us-ascii?Q?NTtNcpFlq9BeTz9NH0dWdfERO1eY6FAPZr0ZGOy14m0HAburSFiXSFzo9fbL?=
 =?us-ascii?Q?Fbj10fxllk/BgTAZPJGFUfzUKOKCgxZx2Aw9UfOzA7uexhAKkuETbnHjBEBj?=
 =?us-ascii?Q?1/K2rBLc2M0OlS8qvZt1vtGiMxP7bZvE/x1r//xK23rLqK4+XaxQpKdMC8oS?=
 =?us-ascii?Q?YBO7mNywE+b21Ncp4/pAcScH/vJnoJxBEQef31QdYCvJ14/s7yrMT09MSLIv?=
 =?us-ascii?Q?2uslUjkuy0JpHVYdw14jEcOJmNL6cbzlXzyXm/SESUTW3XbPzZFFShNh+KbD?=
 =?us-ascii?Q?wPeAd98hR7awVL755Ti/Mwpe1skY+FsNAyBGZxzgG8Om68xV9SAeP1OQztW4?=
 =?us-ascii?Q?7uphglFKOsPh3lUB5aBnMKL2wquGUtHVjmGw/cU75xpx7AYLSh+u0WPjup7H?=
 =?us-ascii?Q?JyK44GUyWdtHG8gRkQ+Sz8LQh06RyBKEB7TYRutiO6KgG3TL6jtH1ELrhuc3?=
 =?us-ascii?Q?xlg8hIaxapyuJbqfpWtjSYvi6xbXqQCIoA54yE/6FdrBCE6ZkbzSLeeMHR8w?=
 =?us-ascii?Q?vHp5afi18idAg/5RgP1H7uNDURew3lVCLvkIRTU9axeeB1Q3ksJYnxtVxkRM?=
 =?us-ascii?Q?TXKn1n21TEcQ+x19k0BttWRjaQLROFzOaW/Bm74xJllGOSHiGUuFWYZbmM+V?=
 =?us-ascii?Q?3YoSktQ8Yl2VN+Pn5av+wxS+I3zmEcylTYMzt66sqj/+jwihatlpOoG2MPW/?=
 =?us-ascii?Q?eorAS+Nj6Jb5aVYuOwrq5ro7pSp+UUnDMSQ9yGpYGhQFcy0d6ml6obpPUFiR?=
 =?us-ascii?Q?WHolIsDx2orF8zC0IGHLWypYZCGuBVBGXouEsMSeklF76AVtA0hYFMrxkPLu?=
 =?us-ascii?Q?oGmQUuA1I4TS4YKehXC8QgOlQHbjzDwN6tS4XHQo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee06f07c-8520-49a5-00b8-08de2c9eeb22
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 03:50:19.5459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fupJ9/3meQRK9ihrUJJXJAcFY37uxVt4Y95lV1qdrwXNDvvd4BzNqJyWHMFt7oxf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9782
X-Rspamd-Queue-Id: E19CC4000A
X-Rspamd-Server: rspam02
X-Stat-Signature: cbz8s7gbk6pxginkbqif39bhgyc137xz
X-Rspam-User: 
X-HE-Tag: 1764129117-942863
X-HE-Meta: U2FsdGVkX1+4/sfz+DQ/KuftlnOVFG1lI8bZN1YZGfdfFvut1UI8nu7gBNLP0EexQdJgSgC/4FuJvPkfY/PfeiOKYqoV/x+bbME4Jk0cN4zLcrnknxMznQSGPiJidrEcBuFFBVI7tUHpR+zuJkJoEAhk+jEqgYuAb4kPECb7PjMwNjZCBLE83VWxq9GKTsTtcA5Mm5sJuJ1D+HWXc9sLPNpxdA7mkOUUhvDNu8neUGjGL4WB2IfC8y/tAEiAL04ZbHVgWcqeCA3ieKQXkP8s2phz7mlO1bbPnJHsgI+BBLRm1+B21Mxjtm+ivdzjodg16Re2pGfTqXYxyxX6CWYSTF2FsuH5tEPoskduEKx7qMhsBjHkSPxFp/d4KN/USbFMkBSWAAzgyS502tx4cu0allIcX7IQGlzSAcM0pj5kM9U7MXOjW29Nli4RaxKXvrV7G8/JpgCuaYww2lAPC6gc3bayFO3gCeqW5mE7wi1vsF9KsDliomOfyRa0GQRHnRftuqdQWseJQB0RYZx+ymp+h8kTzh/Ob1b9jRbiKxTyEAIog8lMeFAGvBrEcZKPcAmdMwzxU2k2/3FmEL38QyqcmzWk6m9Lu35nG9TWBQXds12N3a43w/dnbA7xFeiyagupC20AP6P609oPyzHb4+7N98Oghi/Ocg1c3FrN9BAqaBYzPBnJk8fK21Z54JxcgTMFzWRs4TqqzZfJfXp8CWZdvCqgUjuVx/QlU/ecmrM0fAPahGvMKbmRrYaELnLpDLcvbtw2f7ogWi1aXxlUPVv1joUr9ee5lmg/Xawa0b+cQRN/Uhq9nB4rqRiUL1hZ5EMIz5YBe0wC4RV9X7NGlD+rWRQ17CS7/OY4RsdQ2H2hGuyqVGhvPUYqh86w5I6QehrCSkxl7Knj5prLNGLf8oLVCxtl0s/+bbQpb801gtJacXtrn0l3fIC1vDHMce5TzVVD0uvL8N96aExM5DZoE06
 qgE40k10
 56dHhgrDznao6HqDHADkEGkOZQVsXx7VBJnjnsW0lKHgCHUgTUBOF5O+Xkegju7kjN4c8mA/hAAJHolw+tSVN1NarPoUse2sjZgK4bC783UBMPom9XO8A9y8ykziqdVBJ+WcO/Rw5HK9i74dOLozrRXFXoyZ7aDkx15zmSlOi/c3WuU/WE0pJBqCyi+BTZ9Hb2RzpOF4WF+5Su0370ndaMiM/gBg7+7Y0+nsEgcrZppk1a3unFmSh5NiuYZ7eot9Nrdf09WeeWbZ342Gl7hpDPPwZ4qigDaw14FjKJDgfhQlEs+E7HbseIjbSyrf4K3chPsqQi9fZLaEsEry5NwUaa5UtfeeO1ew3Mux9Qx1gIPwCl6dn2mMhwqGBNwgZ0CeODxdGHXFacwWOj0sbCwzc8d7xpv5VAiVzqP8pKRkR327TFU7tQMUp1MlsM61lny2CJ6l9+z8dTyGX3IJfWrfeSXbHcUlVpuMPk7j1JMdQC/iTjAHIsVhB5lmh5Pp+f4FqET/4XV3eih9nE74Nn0miiNeAk/p34N4Rk+yaGdR6st9F/dkUnfLJSo50mVaVSb8j6KUH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "return <error code>" statements for error checks at the beginning of
__folio_split() skip necessary count_vm_event() and count_mthp_stat() at
the end of the function. Fix these by replacing them with
"ret = <error code>; goto out;".

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/huge_memory.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3d2396bf5763..9e984608da81 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3944,16 +3944,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
-	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
-		return -EINVAL;
+	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (new_order >= old_order)
-		return -EINVAL;
+	if (new_order >= old_order) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = folio_check_splittable(folio, new_order, split_type);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
-		return ret;
+		goto out;
 	}
 
 	if (is_anon) {
-- 
2.51.0



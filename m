Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F78D116F1
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 04:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FAC66B002B; Thu, 27 Nov 2025 23:42:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1916B002C; Thu, 27 Nov 2025 23:42:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199C86B002E; Thu, 27 Nov 2025 23:42:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 03F406B002B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:42:50 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9EF431311A5
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:42:49 +0000 (UTC)
X-FDA: 84158770458.06.7836D0E
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011052.outbound.protection.outlook.com [40.93.194.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC25D4000F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:42:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BWyqxuBX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.194.52 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764304966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NR/puIQWtRRGPq8UicCYMmQO8w2eMsSWf3EGcjyMrVQ=;
	b=lL4niv+gsxOqJFTboYaUW7Gk1+z4ddmyWiZR9ORTAAzPOcgSmVCZFuWDSl7bA+G/VzEHCL
	NnSum8ThWVOAw4/cCKxxlwIwoLMNURYW2E69iqYmypLYghAOnTjz5SUKG5+DYtYGkQLatn
	+ObJ6Xw1zv4J7ws3tp5YQQJGiWjPMS0=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BWyqxuBX;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.194.52 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764304966; a=rsa-sha256;
	cv=pass;
	b=FzBsCyrUwuCrdFOXuARZRasssI9GpW8YrorYMeWFAtiWfjhPIPWc+eRQ8VODEGFh+GFyAp
	8idVkXMqtJnNs5cmJpt5RtrQZyDe2LsqcoT+W3ztX9p5cJKmDuqPbIjIgeWuD9xE+SEPDI
	+MTRAt2fSlst29PqpKsZBXz5GBmRbDM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OujqEzTuyiqrDyzUL4S9ZSbNdhjk1rKgVf6ev4sXFeVYZjjKif/MyKzjY7zXAYxjWUZCu0jdnZ7XffCVL7K9ozRi6ZKITtysjnf3dPxpObZ2c+lSDNa0Rs5B3GJcCmsUYGI/atgB3RejWVA2pzkI+x+3XUTFiK2lyqF6lqoLzj47WeBnTz79ii/vFrVY4YWbOB+N/649NDbAj/+J/8pqaU3ql0lVqb1cJut7sL0UrR1XYg2upb1bm+B8b1AA68SMUyu0ef32yjmLsZ7NMNQza8xJvFgQOuPfbquHB65UZr7xLGvZO/mfpvuFoGOwp2KIz0QGEIcSb7VH4Pjl4xWuwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NR/puIQWtRRGPq8UicCYMmQO8w2eMsSWf3EGcjyMrVQ=;
 b=xWxt7Ic3j9v/CMmLKAo6C+WWkRoI35hyFoE6eIX+pyjnXnOwmii9e5JxZQ3eJUNffEFHuAgWo9vOrYtaM/8EwcdhxR4yPn2TwDI6OG7lMz961kbGe4gXnWUAm2kIx9JxrZp9pnkEzU0cXpICh4ypGir7r2UffKWw670NJn9WtSPE0+Urjz0ADRDRus7wtEZ1OkArfqOqTAh95DGqOqrUylRO6r0Lb6711tGJ7OF7KpvUROOH6b0DWkviPg/c9wl1PSiFFovvABWvrV3yfzg/enMJ3irCDTSFszR1wjpAbkMkaZ/NyIKscD8N+9g5R/vpLZMGG2vsADdTkiOzx6OR1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NR/puIQWtRRGPq8UicCYMmQO8w2eMsSWf3EGcjyMrVQ=;
 b=BWyqxuBXXFeRU723AV7nrcIuI8rURSKU6BqFqUQUliQyxBlREDYGPAqjtCNpcepMI9KV9NwmcYryrCBDp/HlwkfhlRulzzDjZUxVLSdx1XcrZhKHBhwD7n6h46abwsFcekRYcw84V00FrA874Q8hzLNxFuLElzwJBnBdrSQBrGQtNXci+XvcZMdf+ke9l5rmxPaQimyOQFuCpvoYFjSI78bF9LLldV3IDfERtIoeL1XZ7+ykfUxdezVQ2WXOkJqcagQkYAidnvI/grwOzMA60YuXYmccf9N0M0KvFF+Bzie71Kp0zBWB8DgQH9e7lyrMc/m0lps874mdReTVVL6IjQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 MW6PR12MB8735.namprd12.prod.outlook.com (2603:10b6:303:245::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Fri, 28 Nov
 2025 04:42:43 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%3]) with mapi id 15.20.9343.016; Fri, 28 Nov 2025
 04:42:43 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org
Subject: [RFC PATCH 3/6] mm/page_vma_mapped: Add flags to page_vma_mapped_walk::pfn to track device private PFNs
Date: Fri, 28 Nov 2025 15:41:43 +1100
Message-Id: <20251128044146.80050-4-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251128044146.80050-1-jniethe@nvidia.com>
References: <20251128044146.80050-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0297.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::32) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|MW6PR12MB8735:EE_
X-MS-Office365-Filtering-Correlation-Id: 20c53a5c-a002-476a-2480-08de2e3891c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S+xbHesd+n2R8I7wITbhHd4DpQ/bW64h0DxWeqdmW1NqrKwKvDkAAVraYeUN?=
 =?us-ascii?Q?YXskEXaHdpvmD2vRQPwDTVZDsxWjs3d2A+G3hAjgn5BZUYMDh7zhg+lbDk5M?=
 =?us-ascii?Q?9HwRC097ux+KOOpabXpjZwZuRqCARH3YN5Z361ymsWJeQFbp5gBcRY5CjqOf?=
 =?us-ascii?Q?P2b2MpzKY8GWzoY4ZRI5OrE9aKy6UdvmHG/ovspcemuHo91S/3GFTu6sfSCn?=
 =?us-ascii?Q?Nfd4BnGkK6KDQEXPQUclTEEzFuI/AguPxyWWVf/5Z2QpplTI0zMBonRWoN2M?=
 =?us-ascii?Q?n07AcYSLb+NSoeAj0Qgnmn+dwo8GCEbp7MQ29B/eUqorVrRdAiHU28djoflS?=
 =?us-ascii?Q?fOe+h8vR9T0AsOZ3Uxz3VxllQ/uECqCz/HRjjAua+eCv5QJEyYecW3aRRt3l?=
 =?us-ascii?Q?n5g/yelAsjjjk5mfMbtuPwZsWm0C2w/qDwuZHFaVYyxPltEHT309qSbb+wFg?=
 =?us-ascii?Q?o6Gf7vpxZJRCzmCDcaxtO33BNRscxwgpaBgH68+bpCSVrCiJDmFe5yno9nw1?=
 =?us-ascii?Q?lnXfMje8QUgD+D1wrdxeNW9EuHyXwrCXYiIA+tAewpqG/XvemAPgYp0MbZHB?=
 =?us-ascii?Q?qiYP2TizlFodzXBAY5J2tyz1s7zwxJ7cc7+d1lcbgzVdVp0XZ5+Dur55MaNm?=
 =?us-ascii?Q?dwEyRACWsydbvF+FigQWi1P0Zbpz5qwbUJXS1Vhcgw4ben36o1+ue5as9zgH?=
 =?us-ascii?Q?xrDxu51sRDMurP2ES7OyoP6WYHoUHgw4DGQrXz3rGA6Hfq1VfDw+vO12jZG3?=
 =?us-ascii?Q?t9BQQxg+lIl7dLb2iBrx0xc4Txv4RU0AR+WlbNCxSoJcoEOx29TStt74/6Wx?=
 =?us-ascii?Q?d6/5QQtsbM7GqMveHxjXsYHNusPerus+Tz3zNvG9sBPBAzg9nL3WgBVVmmFd?=
 =?us-ascii?Q?QMiGDjEjuarmn10ul9PB/BixUpV6P+3uiexSwZBblumKKHWPK9cDwNCn1a9b?=
 =?us-ascii?Q?FahrV9pap1inpbFjLv0S6Plp/CAfexC1wtOSRUk1aw6XbMDQN0ypT+Yk43t4?=
 =?us-ascii?Q?Y9W9B/jdIFuBmhjoslSZwad59puj+tjJ8qDqpRPQhb54FGQd1j3HGy049/Yp?=
 =?us-ascii?Q?JuvV7V36xtoJjIYc5ceyCarxhcRg3BuimzA23b7YPWhNlEnPiST5NFROlrEA?=
 =?us-ascii?Q?i7e40L9iRov+4lx1XPyDAHWPDyOAWOiqJKeBjkX/UzFeZiB85zkAHUtyUhpa?=
 =?us-ascii?Q?HdhPP4OQ35jS2Gto7Pd/ESVqcNDHE/ILYqHr5KYKOpYPZC8EhKT9l7qagl0d?=
 =?us-ascii?Q?z7uM6b2wUwNilX9dpCGzG5/Fm3+Nx55rQ3UUOVB46ESDo2TbKM10C+ksuuUo?=
 =?us-ascii?Q?E+XnmHeTXVNtYr1Am/08E3yQoUKEGNiyhVUHiVDWd/Wlm5pvEs3pywXrM20s?=
 =?us-ascii?Q?0TUdaZfaBDxNlEL5sdo0LMxUpV+JCIcXgqEzmaODvKJAd772ZPpjVVvdxgyQ?=
 =?us-ascii?Q?s/v5PvwY/1WKj8hP9YbF5VPxcqM04Mx6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uSksldqXTjqsVMlzW57be+kf2qY9Qa7YpLm4g0ZRu6kC9rvJiL6uiMqEkGYF?=
 =?us-ascii?Q?KE53dAci+t/K7ykIab7mXCggGZtFnQKw6pZTruBx2XA3T1eX956a6+//yKyq?=
 =?us-ascii?Q?VY6KpBGPhlBnYNTQIJYo7pWYrGwuRfjZCfsgtCR7UnA0TGiKHbXs1Iv95Z3k?=
 =?us-ascii?Q?nXrzYdjaSMIEItIOsBqatQfYpFwQX43CSFo1NzjyZma7LZ7tszbMD9JYwPD8?=
 =?us-ascii?Q?90rWBUac73iNOnE9Y9vEbKwx5Iu+9KGUdz6UDjs08qtsemnuderk0lrBCOXf?=
 =?us-ascii?Q?MRHQo+0yMbj7SJ+mhL89ruomRQB28lb1/x994tmwewP7zZhHLWLKR+E5/RHr?=
 =?us-ascii?Q?rO0xDM/KUMuwQSU1tvOsHxbcuR/SLPTajaxxwQkpjDC803rEZSP2LUPAj8le?=
 =?us-ascii?Q?NQOLJCkig7qUq4izsK+cLPqx+D/mQpeezN8AJR9Ogo/9ciXqPD93b17PdQBq?=
 =?us-ascii?Q?LjIMMgtZPiu180ER6lcD3m0/H9Xu4xn0DRqRO92hPcsRRSLcT2Z2Jwp0Y6gW?=
 =?us-ascii?Q?xiSBctdHPUg+qb2p7HqpQxzKHD9TMNgVpOO/8MPALYDt1WRfBcFmlFBkErda?=
 =?us-ascii?Q?AUYwGROGqQ0H6hJH0Ovy77axhxiUsuYE62wwIeDWbQ44u/tKJZKfWXX73ReM?=
 =?us-ascii?Q?jD71G2v+i0ERAxx2LTJtwEprSVCNblPXrAxinuzn3ZNo84vm1mSG9C+CNd+y?=
 =?us-ascii?Q?2kh/sjzrMh89FQFwdHL9qv0pR140PiHRPJvM9f5aEpQjmWUR1WTZ5MvVq/G0?=
 =?us-ascii?Q?r5jTn2wHHViYPiHdelfIHVZwOzlDfy/9hYrCPzcHaTkZ4MRLgCtFnGYocHKQ?=
 =?us-ascii?Q?lawwqYVMO9lHI8egHNNk9QdScaXTT5jkGJRKcOoIioPjSfysTLpz/t6+pFxH?=
 =?us-ascii?Q?fH9SyHVODx7/Ek9zhZoDertKAZzE5+tFUBxpTQlp8eO9uCuThobApAchGV+2?=
 =?us-ascii?Q?H3VOTILXy+URl/Oka1PTX+zhcYOoHUL7qglDrsii37yH1XN1pQoxTkT0msrj?=
 =?us-ascii?Q?HkG9E9tIbCr8+O3E3j5Y2qPBPA5iyOXrl7dFNpnsS+OKL8ITTn7AEHKuqGIZ?=
 =?us-ascii?Q?NAl3Kr4xq84DoEPVzzJFjJWTEqV+QyRwggPjmfyRdilHsN9h4sb3R7f3YtKY?=
 =?us-ascii?Q?fOJ+XiztJUwpW3mzCFamZuwKhFdx7y3zWvOWWinwgZ2EQJgv4fvqbvY1WQ/K?=
 =?us-ascii?Q?VWB8I8Znlgry4Ftme8vRhKaw8LuchBdFPz8qA9heX/XKIJTLuef4o1K6Aoy1?=
 =?us-ascii?Q?Hfiuq4Kmq1gc3UIj1LSw2Y0M+LNz3s1fzyZqlLc1SvPHafj9FIJgh6DqyIl0?=
 =?us-ascii?Q?2qv9ebOweaBNi5GurJ84UVzlTD4PAZCRw4nRgO+mJVeuaTdI0vrA2cRw48Pz?=
 =?us-ascii?Q?NorYRoSQyMAIChWVeUlEdhw+q8OjM249qUW5U+YABDxkCN02cQN/t2zC/A6Q?=
 =?us-ascii?Q?RDRjDsTYgJJugbwxmPfgaKP7SrjS2K8bGalVD4eejPix/HwIqydOnohT8FZ+?=
 =?us-ascii?Q?agNlh/HdEAee7jk+kXQ6+pKMR6+FDlh4+mNply+ALGblkByArvoljxAjlyjH?=
 =?us-ascii?Q?Sg3g092Xx/U5pldJxRzfWm2aqtppwNt0jmSNA+WO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c53a5c-a002-476a-2480-08de2e3891c4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 04:42:43.5186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5oJrcPTRRTgdEpQaGd5+G2CpbIVkC0mxd/pB7bmPcWGTEo09hDziIBA1luec+nvN0qyR5GF0sY1hEQDMZSeikw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8735
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CC25D4000F
X-Stat-Signature: zg7iz3ix4d8nqsgsfceypfa8ufab7z5x
X-Rspam-User: 
X-HE-Tag: 1764304966-792246
X-HE-Meta: U2FsdGVkX18eZOw7sAyjvnf0WjDgXF+Nzr3DUldYXcqGuRCnaAYwHDTkRgKC/5ytiQswrUmwJrPF53he2GZwh0HikfkTuCH8YIOSwKKfGiY6TQ4OEa5vokpseaykZDmXJclfR+6xegZoB+P3kfWhdhM8D9Vh8CgA+F4hzA99n1mVS5xS8S87Quy8XvkJvHGxWxOuxNDJ1zu+b9T+SjRQIdmYhay8rHeqOUhsTqJboJUbZ52WPAadYAw5YAkT8XsGMcsLIdG/KmmX1Fih/5JcUFoh73UgTnWWq2ihmYg08y7wkhV84JJEuEV/64qJvDNvnHMRkcHodM3LFu40+hQxRlnC+Ypv5z+gjXXGGs4ci/0MWAWwO1ca5jjA9y40q4dKf7YxR5gsn8V6npv3GX7Sgrir8mvcqO1zizqrxFXnD04hyDqc+v1OHo9pdlwBPOXOfGxN802RUZ6g369S9L3ITGtsj3TVynIt4y5nRnqO4dYYWhLeK/ukBa+YDZbJSTlieAoy9xykK9WYX2K0tx5sCIHAFu0suulsNyBcL1RWmxSFbN+2RFdQdQGWSiuXcZDzcon18SEimdnNiZoRzewYeX6sOuzAjyv+OPy5x8NBL4wBFe3bs6yTzJhb5NYTp4sk/ozsL8pBZCMp3aybTrGm+rCsgXTnGMJTQGyfZrzLaF0yynPmNb5jrEaR3dn6jn+5JB6QmHYJYubNQue2GuwYE8wiTNof1Ea4VTwlsveGvx40kOz+CMBLDjPEaCvxAYRUCuRIgXV7y4dUDpVBLNe4YjzSpUs61OpAMeIRn1nlnbysXgWPvq6twz9JtqwkET8Da5j7cX3oq9pCkg3Ha9aqQGkKo3GliP6yN2WcvPVVkro2zAiUz0QzghCNw3EAB2MpLwpDWbs/T0tXeY9/uoo2ZxTnJLp4xRFaM33EK2VeCprkDLhy2/1MkGVIBCVahCYIi2Em2kvg08mMH2H9UI3
 82Vb7fpR
 LakPXmDempk6i9t8q/0Jh3bI7kPM5th3fi6kRNyjPUJs0WMUiAsBjeimTc7zyTcfDx9GLTF8OGr/iBe7T9+PPtv23hT1FyYeFk/SWzlqWgU2airmygvRxsDY2urXvLHU0gl4qRrecq0nwaPs12a0Gx578A+P2Wqsz7rCADocdPSq1japUO60MOfdK32WzdDWYakzN2ivsDbQ2Hn7bGkjmj7Fdr+A2n/qb1BSgStLd22JhmJyWoePNQCxivmp1VRL/vlr5mcs0MOgiKNmdLdBsLhIf/O/NVZIieABtj3cs0tAqChk96Nt/L29fcuM9PhLFPmdidGGtysVBJ7PDsSCcCnnBBJ4sQ9qmQDrBUV96yT0OMUtXqdoiVcLkQa/qO2re2X51qSa351GjRSGdQ9anWePzWB+XjL01gOwJJ6v9nrlF0wZHupQG5yULs8TOLBt6tUC8TDdfpApaxYKZHYKDYHbvvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
normal PFN and must be handled separately.

Prepare for this by modifying page_vma_mapped_walk::pfn to contain flags
as well as a PFN. Introduce a PVMW_PFN_DEVICE_PRIVATE flag to indicate
that a page_vma_mapped_walk::pfn contains a PFN for a device private
page.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 include/linux/rmap.h | 26 +++++++++++++++++++++++++-
 mm/page_vma_mapped.c |  6 +++---
 mm/rmap.c            |  4 ++--
 mm/vmscan.c          |  2 +-
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d..79e5c733d9c8 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -939,9 +939,33 @@ struct page_vma_mapped_walk {
 	unsigned int flags;
 };
 
+/* pfn is a device private offset */
+#define PVMW_PFN_DEVICE_PRIVATE	(1UL << 0)
+#define PVMW_PFN_SHIFT		1
+
+static inline unsigned long page_vma_walk_pfn(unsigned long pfn)
+{
+	return (pfn << PVMW_PFN_SHIFT);
+}
+
+static inline unsigned long folio_page_vma_walk_pfn(const struct folio *folio)
+{
+	return page_vma_walk_pfn(folio_pfn(folio));
+}
+
+static inline struct page *page_vma_walk_pfn_to_page(unsigned long pvmw_pfn)
+{
+	return pfn_to_page(pvmw_pfn >> PVMW_PFN_SHIFT);
+}
+
+static inline struct folio *page_vma_walk_pfn_to_folio(unsigned long pvmw_pfn)
+{
+	return page_folio(page_vma_walk_pfn_to_page(pvmw_pfn));
+}
+
 #define DEFINE_FOLIO_VMA_WALK(name, _folio, _vma, _address, _flags)	\
 	struct page_vma_mapped_walk name = {				\
-		.pfn = folio_pfn(_folio),				\
+		.pfn = folio_page_vma_walk_pfn(_folio),			\
 		.nr_pages = folio_nr_pages(_folio),			\
 		.pgoff = folio_pgoff(_folio),				\
 		.vma = _vma,						\
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index c498a91b6706..9146bd084435 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -133,9 +133,9 @@ static bool check_pte(struct page_vma_mapped_walk *pvmw, unsigned long pte_nr)
 		pfn = pte_pfn(ptent);
 	}
 
-	if ((pfn + pte_nr - 1) < pvmw->pfn)
+	if ((pfn + pte_nr - 1) < (pvmw->pfn >> PVMW_PFN_SHIFT))
 		return false;
-	if (pfn > (pvmw->pfn + pvmw->nr_pages - 1))
+	if (pfn > ((pvmw->pfn >> PVMW_PFN_SHIFT) + pvmw->nr_pages - 1))
 		return false;
 	return true;
 }
@@ -346,7 +346,7 @@ unsigned long page_mapped_in_vma(const struct page *page,
 {
 	const struct folio *folio = page_folio(page);
 	struct page_vma_mapped_walk pvmw = {
-		.pfn = page_to_pfn(page),
+		.pfn = folio_page_vma_walk_pfn(folio),
 		.nr_pages = 1,
 		.vma = vma,
 		.flags = PVMW_SYNC,
diff --git a/mm/rmap.c b/mm/rmap.c
index ac4f783d6ec2..e94500318f92 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1129,7 +1129,7 @@ static bool mapping_wrprotect_range_one(struct folio *folio,
 {
 	struct wrprotect_file_state *state = (struct wrprotect_file_state *)arg;
 	struct page_vma_mapped_walk pvmw = {
-		.pfn		= state->pfn,
+		.pfn		= page_vma_walk_pfn(state->pfn),
 		.nr_pages	= state->nr_pages,
 		.pgoff		= state->pgoff,
 		.vma		= vma,
@@ -1207,7 +1207,7 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
 		      struct vm_area_struct *vma)
 {
 	struct page_vma_mapped_walk pvmw = {
-		.pfn		= pfn,
+		.pfn		= page_vma_walk_pfn(pfn),
 		.nr_pages	= nr_pages,
 		.pgoff		= pgoff,
 		.vma		= vma,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..e07ad830e30a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4238,7 +4238,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
-	struct folio *folio = pfn_folio(pvmw->pfn);
+	struct folio *folio = page_vma_walk_pfn_to_folio(pvmw->pfn);
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
-- 
2.34.1



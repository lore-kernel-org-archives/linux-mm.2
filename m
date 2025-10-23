Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0D21CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 17:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401F18E000D; Thu, 23 Oct 2025 13:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9928E0007; Thu, 23 Oct 2025 13:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8008E000D; Thu, 23 Oct 2025 13:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5108E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:20:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABFFC129C61
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:20:51 +0000 (UTC)
X-FDA: 84030043902.16.E882631
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010009.outbound.protection.outlook.com [40.93.198.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id 05EAB80003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:20:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fMdYbJmy;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761240049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1ZbECFndbv+RaPSINPdgBcHoM6xJLYrWN5uHJsDJyA=;
	b=hrrMLhpGitf+O9Kbb3823/mgZPEVa3lXXduiPCNckKMbYQ5TJP/Bs71bwEpMnmbu7gz4E+
	hKAHiFslmImZh455ve4ZnRpEqrKPTucx/90LNAIXMiIQmj9zbScw7uzhnh2+Q2nICkDcQX
	6uI/IIg8jMZRdjduXRk+nrgSXiRJXh0=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fMdYbJmy;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761240049; a=rsa-sha256;
	cv=pass;
	b=xF+gEMYJ2XZVnCzUIPH2QXmZMrzHGX5YgaX5uxFdCWQ8wuKFX/OKAK2/YF46THeN7Werza
	KAxh70ya1oZdJ8nL7Hf4WbP64EvMO/ZX7rYlTKNXjrXtMDDvQijtse/lorOhafwCSMyjwj
	wCfehY7KZTNBsD61F7+JgbbxyU2CJ8c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZEDepDwqtBzA/pfyehCQ6mtHOMz04CUfOcin/F2YQAp1o4CNyk9qhnvir0XT7EL+xVQ5YgeSEO8dlXx/CF0No7oHGCnuKem5bVCHNoA17TCOBZ1JpwZKMtmkKigugREjB55vNjx8VABqvafqzVW3RrZ5Icj8E0Wm8OKmPdAWjvRAMeXk1wzNkwp6AJM1eFKzJfbWCZt8t/DGZayvINixV1WQY/AtEy4PhtwOyubmSvYmLy80JEwYWJJh2ljR2e09y2nkp9di+xVGVLHY3ZLpbFP9MSCdI4H48JRXDt1Zcudx3ujv5xJe1xhDZhZC/bja94jBO8QiWBz5mQGtjC+wlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1ZbECFndbv+RaPSINPdgBcHoM6xJLYrWN5uHJsDJyA=;
 b=jMwncHlDj4IxOZI9EGt+C1FfCS/rTspRc9fkngdCDjFUv51j3EswB+MPJbaP4670GUNajCThDpMRJCZ9qoc0Q6tiNciOGil/m3Woq3pOWaNQTlkt00R+NoToM8PwB2tK8knhs02F+oVHiK/pGqzYrIKU/8cDH6kbWJhdZdV0ZPW5PsGSOjc8mVVVreb6g3FUbsnhQGCfPullNPTCbVa2DJinxZVGkzQZ3CGzM/AMU7V35bB6aUO6sOWq14D8S4aqn7/u3uzxZcst5KhSeXbYe9ywkkt1AnWdSEBHG7NDIk/ENvUEL7VMgIz8apkYqZbIkbOybcinn7KMIUYHNaMDyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1ZbECFndbv+RaPSINPdgBcHoM6xJLYrWN5uHJsDJyA=;
 b=fMdYbJmyhtAF1w79MXWPK+BnPArSmJQgYHJYZrImcyqSN6ROZog3z8WiZFYcCItNZr/5DIhbL7Huxm7yJyXYRJ9F6Xc5XExQI9VKtNFJUUUQ3un71bSQIBoy5/xDluZwQW/uI/3ms7/yrcSXfQ8cVaVmQqa3NDMrsXI1/FexY9OL4UsmgrL5sqKsXi396JsNtpNa+nXW4RfdkD3Rw6XMOoFBOU73/pyxs0iXoKtitGemfeAwD+fZh66CW2l96uMSw4aU3YUBRig3ueVClLidGljwoVgbnI+Hl1bej2zKJ/mf+4WRdOgPuieA3NDABwvZ/okCV35s2efdQRESr2/27w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB6924.namprd12.prod.outlook.com (2603:10b6:303:207::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 17:20:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 17:20:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: Pankaj Raghav <kernel@pankajraghav.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 akpm@linux-foundation.org, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio
 is split to >0 order
Date: Thu, 23 Oct 2025 13:20:40 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <B60BDD1F-EABF-47D2-9FA5-146B53C2A304@nvidia.com>
In-Reply-To: <d0362c9d-67f9-4ea5-a5c1-792f960da70b@pankajraghav.com>
References: <20251023030521.473097-1-ziy@nvidia.com>
 <d0362c9d-67f9-4ea5-a5c1-792f960da70b@pankajraghav.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0428.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB6924:EE_
X-MS-Office365-Filtering-Correlation-Id: 92e0ab3a-6fa0-4592-d28a-08de12587fda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AyJYhY/EH6hAd11XHne/YkrpC/epVsqzZI8gV/gjC1f9w+V2ZNy78UYXJxWb?=
 =?us-ascii?Q?+wkt2tFHqRFy75ENfwL1+0ZfVLopOGqpjz0HsyMY1x24bV6F0ao/bW/djISD?=
 =?us-ascii?Q?dxqlnU99xPo/QiDKWAty8+mMHT133tKYY7eTTBVWIE+xEDtpjps6ptCpzssb?=
 =?us-ascii?Q?VVOz3pSmmyy9Wgr911LoiK8FTmwBw8733sFCVFy7gF90nL3PvqcN8Jomt/V2?=
 =?us-ascii?Q?LonQnAV1Cn6UeQS1dZieCcibxDmvcLTxl6qqVURS/GG7UZ2zid39rg/HrPDf?=
 =?us-ascii?Q?W/5IdT8jfCynfaIO/Lb3Aorbk64LUXiwcApMYTshmMSxm/kYYLWOGWxDbvy5?=
 =?us-ascii?Q?ulxWzKSOl5EQPi8j/q5KMJjJmh3eDCGlFeqcdqNW56YHiwbcRzMtlXsNpTiD?=
 =?us-ascii?Q?a27ijqX1y7fTWLvCMZLvjMKDXaSrlBVTHp5gtwMr8sT6Oai6E+QjzL31p3Y3?=
 =?us-ascii?Q?X6G3yAxAOJBLnvSEDXKe/CRSy/YAmNX+vNL8zU396N9pxKTN2QMrtPNd72Ri?=
 =?us-ascii?Q?8I+gGzwl/Ml5dwRKHnKv0hFmdtqt+eafskLeK5erVoOdgZELoJhDXdwxpXlr?=
 =?us-ascii?Q?AGtw/JJNey2JFqIdpEhLJ+RLit7pXYalLajTCTzVc+0txH+yjcHxdSui/oWN?=
 =?us-ascii?Q?kNqewvlO/nwwRBbkWytYdlJWtbDy+NZdGO9cVU79RUYoD72GF0Unn7tilVNs?=
 =?us-ascii?Q?MYmMLauU3V/p8ZdkvMco+TvuYahWI2bpZU6zt9pZ6HPEf6Ct7X2JrMclartW?=
 =?us-ascii?Q?z62ifP9jPyBZWny6UPR+jh0777i/HvHhENs2zPVYFXuu9d4Rj1sDX3h0YZI2?=
 =?us-ascii?Q?jaWW86PgJTk94dnkNNDZlmiML2UnvTro5g+qTJ3vBROEQXQ14usGAIek+r0o?=
 =?us-ascii?Q?cGNZFtr28YUogyVAqki1jQn+MOfgzWlX0n+C1PECP7pv8p+VsF28lg7Px1do?=
 =?us-ascii?Q?cF1l50LsNqyVE9R8ZV2PpEfxg6CehTaYQP/A0ppxZ15mpljMOGFXKS57ZTmn?=
 =?us-ascii?Q?aFYw6/8kqbt56g1nK2VAYUNWUm3gEi/xZbzqgaNlF6bibeeeqFHM2IELsMQL?=
 =?us-ascii?Q?ghiJZ5kG8CLPrZDAgaicdAmWdUp9/JDYsaDZMa90Mfb8TIZU3IJ5LLOzbop3?=
 =?us-ascii?Q?CdxKsvIvWWuh5LyCwJdSHemNLxHcME2FaiXdb5+9XE6tHiIBbCIWa1omkTef?=
 =?us-ascii?Q?w8brRE1yXQijrM35scpqxyZFGgKvslYr3oa7DD7XjvgXCaQGQqksooEurV3s?=
 =?us-ascii?Q?HpV4jP8M6IWrre8UP+CkMByZb1yBzCCMNhMn5jgPkhV+7mbKA0AgelKBrV7/?=
 =?us-ascii?Q?JVDcowVLBcjEdksvlT7YkuVgPpYpq0XtZtXjq7P+RItabNfmGchIpm7P6FNe?=
 =?us-ascii?Q?YT17wCNvvymn6f2eYeoA0rU2WQSNKQIl8RbPjjtt2TRDBCQv4kjMrPIvXDMI?=
 =?us-ascii?Q?ckBxhy1wo4i1iokPHMSpXAp6X6DZBNYX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KGDHmm2F4MCX0ShkZ3CW8nal0iR6jEsI21OKSWn1kc+48Z+R20PGmLkGT02a?=
 =?us-ascii?Q?JEMebL5yRF+ML3M/Jm61a8FQ9UPz/Eh9hYhs5FloNT6ZZOyhlUPYLekxkifD?=
 =?us-ascii?Q?0M3UgUTXtg1qjPXC8AJKlqdvpvH6gKRsw66GXaoJAkkr1wK0QyzFPcTgvVr4?=
 =?us-ascii?Q?46V4sUdzeUlDrop3TPPRTfr9KYVvgKKdffsKSDlIQFBG5ClOMK0kBdMYZeBc?=
 =?us-ascii?Q?f7s7GMkS/k0i46lviWNIrSK5pgZUPl41h2/2bXM/7FFAZgOZPh61YK3k3qsm?=
 =?us-ascii?Q?cdTxE4x73zrB6Q1y+zuFItunA74XnvMIErlixwi7lrqjZydYcqbKQ2apcomv?=
 =?us-ascii?Q?IHP8ZJjAT199+hWlLqmqJLpk0E/kbU4Ce7reAPUFFRDQNm7K7F72RqwOIiyW?=
 =?us-ascii?Q?7yz6jGruH3g/Ipl8RQtzA1fA6hbTIeG7a5Wnc/Zrlip7bziBhOLvMry3G10j?=
 =?us-ascii?Q?WvllzUM93B0zXw5tA/PoPXOHPsiHRmbe4WemZw66Cfi6DEFkk9nbrHC0UdnZ?=
 =?us-ascii?Q?+cQXA3wJbBPn0ehCIYVff1/Ev/63sr8gFXuS2NwP1R4OQoGSwoKAAokKvbwr?=
 =?us-ascii?Q?moJW2JI7SNeoexLdR/bgnUkME0fnhNHnZmsRAH/gbGBaogTCRHXGOH6X+JUT?=
 =?us-ascii?Q?edW0F71F4IAKyn3sGM64AxQ9Ok2v2DxJF2BSIJR9CBY+3RrpqtIeoA7CeI7H?=
 =?us-ascii?Q?P+8Ssdj97yALFrK3h1jFIJGBPS1AXUkBGgIaH6udySCZQGQ7HUFsN2naMWpg?=
 =?us-ascii?Q?3NO22w8nZ69UAGoSH34vp+axZJOz22XFxn8Jbtx3jV9Pnwk3QUBlTLJBKbUw?=
 =?us-ascii?Q?JZuoGO0cQXseJA4sa5S8nmGQsEW3RJFGM8qXILBrPGMcl4HcVbHjoce1uIGR?=
 =?us-ascii?Q?xXcYhN0Ajh+jI64zbk2m1OY8T274Qeq66kWXVPqswg8oPtVNdyvSOTiQHNuc?=
 =?us-ascii?Q?1OMV3mQjPAavgOB0qw82EaSNxLjv1aQ4xuy7bce+4b3dEIOPS0gfW7Ph9uIX?=
 =?us-ascii?Q?Oklz2cdJ1N40nQtzyLfqDIE+f94vO1Xs5mAjKW6xjt4KYT0LyBZaWSVY1tOW?=
 =?us-ascii?Q?B+tVP7HP+cuA/29jSBnlC4ANDq7Ov4aZCHJp+yKP5dK1pCmjkVbsJCdfvPIV?=
 =?us-ascii?Q?HoXOl2nE54QMvwl/CwTjprBrLO7LrTLFlGrVZ+eAusyFuamNORg3fWilT+w7?=
 =?us-ascii?Q?M4mEqWHyJ1d4D0IxkcWlYqa6VDw4yyC3xnKwQ723p05dto5kb3RsZX+lUcum?=
 =?us-ascii?Q?uilLEcfIiL1q/2MXBPyNBzhOEd2OzwSeV2b3g8xK50XBq3i650MILxYp8NWz?=
 =?us-ascii?Q?69y0mLq+DvmMH6cCL/3BbAFve2mqIdtkTxkzNxDxUlsRXEwDPIVJdB2vDTF6?=
 =?us-ascii?Q?faq1NJkl10vZrmJSsl/Q7CrDmZL2LqFU9a/Cw+gIHZeIDCqanH4ATCXuUoyV?=
 =?us-ascii?Q?ks4ac0If5Jeg5EkL3kdrg9NzL11jXE4UuxdG6LH9O1XbK7G8sU/74WYj9/ow?=
 =?us-ascii?Q?ODiJyZ2x+VfWSofNZM9Zkcbcgxk6ogFUAlLobvjQJBkZM0+wSeiEr1KcCuDJ?=
 =?us-ascii?Q?7wiTxaMoR/dVlv4VbuZt3048G1O7ueJR7i/7a61r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e0ab3a-6fa0-4592-d28a-08de12587fda
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:20:44.8349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6qWaovXQadnmmJK5NIsdO5EqZzyKICaZK0jK+cnDWM+lNs1bc6GrVeZuLpvmB0YY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6924
X-Stat-Signature: uhjqj6oa13g65geh856z9fi84jdnjbuc
X-Rspamd-Queue-Id: 05EAB80003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761240048-30306
X-HE-Meta: U2FsdGVkX18gdrVJVScqFa+rOT+lkWZo17hopCuRlzMRFVlNRWjDbdNa0BjFTDofoBSKpqJtkFD83cNPFj7aPbqj0meHtTSq8xD1KB1VzLvFf9S/9DqhCxuvIrIrK6guNV9M5XfAJUoDbweZbygySbLF3fcZDZuNSNiMAP86/PHdX7SyUpwOUHYVA0yEqgoTJmhUzOL0yOrtVLAcuXJYdv1eQOA5hkbK6rZU6Cof+F/AsFcSqzYKvrv7hc/FQlzQsbxDmoISzAbao5gnWLTsvOJ9najUMo5n5+Mh+Wd8lTyDp5qZBpmeuQykbUu2IBCi7T3dhnbSHo/4ziyE0F4sMNJ/sFRRKix/lGSfsTOAGu0miXvPUxCUXM8isHPBgfTZZ24pAPR1OG4cs46vqf5cE5vJwNDxz6O6CfYdwDCoQJBN3TrI0L40ZVwBYOSUOVsOmRssuiI44AXq7Zrk5dFwSeStTZdgcPiedLQrfe+QNsw1XtYsZpcafGp8Lg8MfAaIeoUMYvORCrsc0FQBMV8cRPGBMoudwMAH4LCV5kKIkAJwZNpl64O7mFeVWtKKIXjUbNGJGzGT90FtWaHNe/hiSpdOXE0rXjcbTp9mm7bYkcHAt5pC+4lfc2AqXo3nv8MPV/kSloq/HSRfQ+46dP5HZn53GDvSQoMNgRbeNLDNI/a84hWKs981+hAnx003hg4XUaP1T5LEEpwepojdwZwuNOpZIVpAWBLk7U2oS/Opq+2U7olMzUh3bLEYIGxPvsaQAyA31H1Ys11vUvZjuVZjQrLTlSonXLN98XPzetYKNP1a+RLSCXpXo2OmO74S5NAvp18/+3Aus1HsoaNgFv8ItNBpIqfBoJQFz8vs442BDdw5Nc7/bG52Cf5lEwjRMejPuTEng92kYNc5ORwY37fhN0m5SPIjpSuYIK+8/Xp4V3UNVo1So4wz2vUW5IEDq+IZbxU2kXRL3nt3n6hc/Y+
 uci6pKXH
 1bBXG8XO9zh27Tnmwp73Eu8BTog4E4RAkk/VwZboc6mkODAI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Oct 2025, at 7:10, Pankaj Raghav wrote:

> On 10/23/25 05:05, Zi Yan wrote:
>> folio split clears PG_has_hwpoisoned, but the flag should be preserved in
>> after-split folios containing pages with PG_hwpoisoned flag if the folio is
>> split to >0 order folios. Scan all pages in a to-be-split folio to
>> determine which after-split folios need the flag.
>>
>> An alternatives is to change PG_has_hwpoisoned to PG_maybe_hwpoisoned to
>> avoid the scan and set it on all after-split folios, but resulting false
>> positive has undesirable negative impact. To remove false positive, caller
>> of folio_test_has_hwpoisoned() and folio_contain_hwpoisoned_page() needs to
>> do the scan. That might be causing a hassle for current and future callers
>> and more costly than doing the scan in the split code. More details are
>> discussed in [1].
>>
>> This issue can be exposed via:
>> 1. splitting a has_hwpoisoned folio to >0 order from debugfs interface;
>
> Is it easy to add a selftest in split_huge_page_test for this scenario?

Probably, but I prefer to do this in a separate memory failure test.
I think the steps are:
0. set up a SIGBUS handler,
1. get a XFS image, like split_huge_page_test does,
2. set block size > page size,
3. fault in a large folio bigger than block size,
4. madvise(MADV_HWPOISON),
5. catch SIGBUS since the folio cannot be split to order-0 and check
   the corresponding folio's has_hwpoison flag.

I will put this on my TODO list.

>
>> 2. truncating part of a has_hwpoisoned folio in
>>    truncate_inode_partial_folio().
>>
> --
> Pankaj


--
Best Regards,
Yan, Zi


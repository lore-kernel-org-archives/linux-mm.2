Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEAB9CFC518
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 02:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F0B6B0022; Fri, 21 Nov 2025 21:57:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446336B002C; Fri, 21 Nov 2025 21:57:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3355C6B002D; Fri, 21 Nov 2025 21:57:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23D206B0022
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 21:57:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59B7D5AE25
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:57:29 +0000 (UTC)
X-FDA: 84136732218.15.748E8DB
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010039.outbound.protection.outlook.com [40.93.198.39])
	by imf28.hostedemail.com (Postfix) with ESMTP id A7B74C000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:57:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hhQxn+3f;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763780246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xBJCxjnu10vrMgxm4wOSGPIS0FWme8rf8I/o3kTFE9k=;
	b=OfG/U2p5RG0PphMRnRBjqO4WEBs7jmmU2PdzJhYYx9MBoUb0R4bzz9nA7P3oa9tMu9l6Mw
	Fahu2iVO++84mF9MgmjduMDqYrSfSypHdm4+xshGmmIh1YWddgoqApzuJQ86ORck/01jq8
	8/1gKn/YGEl6l7z1s/SIHocCrf27OVM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hhQxn+3f;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763780246; a=rsa-sha256;
	cv=pass;
	b=pvunWxnFPQwYdg94YU4rP+cFIwCRXS5pYY0JHbtJ2xTvAU6SV8NSk8ByJ170Y4Dr3ZkANN
	ce3GjERGXuKMvozjTSbBokRn6EapDXbna8cA+iDiwAx8qya9TYr9Q059Pkh5b8JBTxZbOb
	FYBOS0+8kN7uUPasLu1p18BH+SKgxPY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wOUFGROqPfv47iRi+YtUlU4V6v3ErUKxGxR58ENUwMeDjtXCdBJEloO4xqnO32PufJHFd5WQl6SbmkjiV7ERAIk8UHls4nm+e8CkHgODDWP7QaUANxxPqcXAZ1Uk3pgQmlBKfcQm/mf5sTUDLdbeC9F6bLWxUkwutB5MUY/7f67atTIM80Qu4CMdPBPT2Zql175hG0mAr/7C2A4Sr2pnQga6+4VAobNOLyugF7z3ZeUkwobSVk6dytDZHSE0Tm1/sfSfexA3+qHti9b0Ot3MZYdaZUm1y5n8lZZEmLXR8uTLj7kY6r5CtUmXhuPWCrLSCeCBn0K4oAKFO1cBZm9ZMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xBJCxjnu10vrMgxm4wOSGPIS0FWme8rf8I/o3kTFE9k=;
 b=A99jQW7f6ETcJi7Jgls4yvv5lxne9/2JlNEPRpUt2Nc8neNHc/Hjr5spkyY9YQlLoYuLVKxxasIEOrTjbeBxFdQPhYdw/gPCvMRHvxMWNTsr9fgihs+mwGVdsMGgopqrB/rHUHRXtgLn0Xgtw04T0nwdJ1mETCfO9uVnLJ8Yg9L+l85/6jhO8FR6/LjeeIbq8D+TAO1k29KQn+d2A6k1yyS5Ef1FF0qMym8/fJpPYPSt7OljSRJxO2bpEJoFOirDCZ3bCEVILUXuKjgYt6GQ8Ahy7S09AC46HTLwMGB2SQBd3U4eR54BmgKs6gZu3fQ105Mn736hZDZPCdwX7kGMzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xBJCxjnu10vrMgxm4wOSGPIS0FWme8rf8I/o3kTFE9k=;
 b=hhQxn+3fciAPlQFDBeTMPun0ZSv/VtQ0Go+gjUwkbX8BqmtZpdlyc0V9y1fEoXduAbhveOH2JvvWS8mG5DzLBZqmtDQzzNr7gHELyYm5GmfeC1nQmAu8WCmDXiktx9fRaqd6SiWHcVGU7JhrYOg2pGTYLpaybnZI1k2hbaDSQRCUZDWO/tZthTSPKZelJ2FS6RAGqVZ5Sa8ao0mqNmUWbmokBdmBqAlYht1+b4WEdu9P1SaJ5iJ76wM7DYjBmgY5N79JyLpg0fiQ+JlpWHAPYCv/a79d2bFVg+owY5CyQmSg3LomfJYveJE9mm5x74Q7Kb5vKUzcjv186F1yeq+p3Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6994.namprd12.prod.outlook.com (2603:10b6:806:24d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.12; Sat, 22 Nov
 2025 02:55:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Sat, 22 Nov 2025
 02:55:46 +0000
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
Subject: [PATCH v2 4/4] mm/huge_memory: fix folio split stats counting
Date: Fri, 21 Nov 2025 21:55:29 -0500
Message-ID: <20251122025529.1562592-5-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251122025529.1562592-1-ziy@nvidia.com>
References: <20251122025529.1562592-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:208:236::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6994:EE_
X-MS-Office365-Filtering-Correlation-Id: d2152e9c-1f9f-45f4-d66a-08de2972a24b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OOURs0GB2ljFB2THnZY4OVxUH66CBCsTDa6DkY4e45o/A9/kDy8S1wiFRTTK?=
 =?us-ascii?Q?piiCvigDaKZ7ppflH95AU1YweBkyqrEIQr/Fgre39zbBCBtcDt1SlTVDlHka?=
 =?us-ascii?Q?EOT2q4Ez9fP3b5iqOQE3Md/Tcnd72YpdN9OWL5wUU1qgeECuLHbprKsTg4Cr?=
 =?us-ascii?Q?ncWRs+fD2YJ1h/VKoKyxD7l7uu6OG8gPgmtfdwRTvsJL4UaAf2kWOTE505t1?=
 =?us-ascii?Q?BAP4BwbBthWNo04ZmiN1w4XUzuXmBL5ghPewAy8wWvxImFfPDoxI9YdgWnTr?=
 =?us-ascii?Q?jfTabptHhsrvHxSL579QC6LMcKyf/OYmAuU5uO9cSwVJQko1M6+gdX+n90bC?=
 =?us-ascii?Q?NSabKAeJNyNn16YRfMV0kJ8ltrNcuXQkhGjNW7gwuttqVw2JLO6SxmW5QYkZ?=
 =?us-ascii?Q?KKsP3WEa8Gil8XJ1JofvywWAiTb4xYWyWiW32aB5dYnIZSdD3hHfJ1uhETo7?=
 =?us-ascii?Q?nHbOw15k2+qAOy4+GONDpghcfS7y41P9bsvlRh7QDL9R55Sq/oGDqEHg1ozO?=
 =?us-ascii?Q?sC/Hkhm5dz0xnqVkn8IcdFp13L1AWHxv5LnAVQiG5rVmuYAU7wRKRuBVT9ah?=
 =?us-ascii?Q?r2gUzn7tkWvbOIm6aFMkNqxRwtEr6G9uzKPA7BT2XtDdeQKjEOQw4+SbhGVD?=
 =?us-ascii?Q?hKf1t6SSjTcUf+IsXtutVQZ1XH0ralKkL3igRwRfMS41hMZjnsdk6SoArAxb?=
 =?us-ascii?Q?T3OUybR7ThjlK01kX0tlYkdgaL+/D0qcwyLPf7EHc80DCupMBtT00frHFYrX?=
 =?us-ascii?Q?xJ+CGfrotbl6aUDIJ+cr8arNGl2wKCG7X1krlhNgIcrrt9LLxxZSPJlt+BeR?=
 =?us-ascii?Q?SW+ZzTAJGufGBhOd0HkYooz6j5ikiHG/3pZBYMpp2mONRT/xrd6mtlnMu7tp?=
 =?us-ascii?Q?Mv9p8Xbqy8dHVFbq/lVOCSLewtvjncy1keg17lWdLxwtg2Cn8l4wzxTw3pkS?=
 =?us-ascii?Q?40EvBntYQyM/GTcfxNk+9yXXQHeLxKutrynE28Hzo2dGDnt6jJiHi3/jSz5U?=
 =?us-ascii?Q?4leeqi3m9ES4tbcPGW8ua4EYmpEma8QXFRP7U4CPt3Xnr438x9BjNaHoVi2I?=
 =?us-ascii?Q?wwx0axcWyFTqOjY8644rcDUOkezw9Oc3PiCG3+Sr2M0GIVQytA4Q/R1gVQVe?=
 =?us-ascii?Q?omOCwgc001g+AxUmblMEPo+VOwGzfDnk5tw2ukiYcMoHulzfb3Ea7HuIbcp2?=
 =?us-ascii?Q?8sJ+J566UoF4hqSrkMHzxD2bt9j7N/XlzDPwDmuB2cGpSzCvokSrxESnyqMJ?=
 =?us-ascii?Q?XZBsADvScr/e1CiLRG9fnO5mjlaxJpgkbsWDmNHf3hEbEa4aVREqDreUE4hs?=
 =?us-ascii?Q?wXqXZy9kHQHE7cjSrZELIjXg8b0pl8KhbXzM1IC3iltazyA8lfbyC4A0IOay?=
 =?us-ascii?Q?e+NT4FrjhyOrW9PwKyNg7Bu328qsbKGGODZbnLXiiGQIUPncTbc3zgpnuE3U?=
 =?us-ascii?Q?nvhkpq2gIwYJgk2yPxijhVyuqOnysQJF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1KPFWT3P1l2lsIE3EoLBWexzJxL7xMW4sLqXrEUqivSvG4sLa79/DcABVekl?=
 =?us-ascii?Q?wysQmgCxpzgAERp7O+Siej1AholrJng55RR1W3eCNYMFTkt5aE3PwjlPvFo3?=
 =?us-ascii?Q?fITS/5pnTGVlqyhigWaEv/KjBqmm1/rq3cDFdw9/pl1a116PjJFXROg1azbZ?=
 =?us-ascii?Q?g7iKlTuZ1h7bmlyrAMhRuNR9PKlZiF+Jff5CNp1t9EbjVKBtBDbtkTYcl/yW?=
 =?us-ascii?Q?texB/061uV5AWvfjlMr7P1sZwjToPTgXcH0sR1pMm68iu10ynP1n9Dl0jNCb?=
 =?us-ascii?Q?rRlDMX6YiJrLed/6hjlil0hYcaIM8pm2hnYR7naPF+nVcA19d18Tf5ND51DW?=
 =?us-ascii?Q?q7AHAwpH6JHfWP4TGVrPcj0PY36OLRLQZqgpDmN6Mg+J6x7pgCF/85cCeXx7?=
 =?us-ascii?Q?d+fX1dZczN+B/xbjVr5sLqohDKEnbQu725NSBWziangW0bEn9VwpcRP78eLV?=
 =?us-ascii?Q?F3xRDkeAgJpcfn6blAMBI9KY6GtZ1wHictxIKM6v0H1Sog0Ux2oSivMmDF86?=
 =?us-ascii?Q?BlsmQ6nYb/5h712SS6wiW1QxEwYK1Ko6bGNP6PtpwEMfZYzeR4kwSBkUpWiC?=
 =?us-ascii?Q?P24jOwercFlcoFN732mNQRbua0Q0G/lGK9GwgRwhnbu1Na0Oso9c1vPQqXdA?=
 =?us-ascii?Q?iy+OF5ldZmqPHFzSumIdFG/2F55++oqAgnQjWD/bO9/Sz+GKH6gcapo6uFjd?=
 =?us-ascii?Q?Nh/jrfPBoieWIb9KLhj+J+/Mgm/HY5oRwYRy0MmFQfL9diEA/DDYQNL3oHNq?=
 =?us-ascii?Q?Bd9K9VrO33saekslLcNHWjqIHQyK9GDREC8EGlqwBt4qwVu7TWnskL7e6UrD?=
 =?us-ascii?Q?SBSLVoir0S62mvMANnRLSXPDhVLqKVTk+Hqq9RWV2qzCR1seeFt4HPkD4efR?=
 =?us-ascii?Q?lokOOtmeOoQaYYYQhOAZ1VpiwkC3k8W3c1w7jRw8hhsSgcltLVuDAzem2IFP?=
 =?us-ascii?Q?nAn7uN27OVhuTTfnOYllzvXzLxxWMnxx3Fy372CMD2IetNP+ObsCtmSilr0O?=
 =?us-ascii?Q?QfSqoZQHmrnvctAQROrTjyryAfcjjgospB0vU1+h0bNbndtOXYgIihI6PMt0?=
 =?us-ascii?Q?i9bhovJHtPGASH1bJ8yEmRQfEm0KDat1Iw4pQCs6BHfZ0VpbDkqwdOc+gyJx?=
 =?us-ascii?Q?m+d9i1tUznioJ+49+odmj95dqTtSdLw7G61Xk98yOro4s+Wp+lZu3us2G0M6?=
 =?us-ascii?Q?CllOsEF5UfgoaxaQ+5NSKynVIP8T/MzZQyCeBVfrwjM8d5xy+ItwUpgHPY2q?=
 =?us-ascii?Q?oyHrvpAOclEgdlJtsGxmt6fPQYpPiXarAOx2TQ7lquLI/bTvppSnOIMqiq2f?=
 =?us-ascii?Q?cIcK+Q/Fp7rFvjN47zhLcAGeEz/VcTCsvYzsliPMlP2ndHKg5v3s3vlos1ka?=
 =?us-ascii?Q?iTZKdNl+H7G6TI2p8wd4UXRuNUK96SigzD7UY7Of3OULJxE70oCig1BlmGEh?=
 =?us-ascii?Q?3mmB+xJlai6fa/jDrQz65mTa/gkH771wt5jRUISRxA82asNzHtRH0yvE3muU?=
 =?us-ascii?Q?Y0wvvlCIUdLln3204lCiCr8vw2S2xeomdpvSyyWAg5VtPbOOdVzNBTeZQ0oR?=
 =?us-ascii?Q?LXg22onNg2a75h+8zg4aY5s7D/er2Z63srIIqPKT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2152e9c-1f9f-45f4-d66a-08de2972a24b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2025 02:55:45.9962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8rHSf/xBtbQ1MFt2vyiAAP1LlOO/bs+A3cDRDEYM5vymbRITfjdvZdx0gTxL1qDa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6994
X-Rspamd-Queue-Id: A7B74C000C
X-Stat-Signature: mu5b1gy5o198tpp78689awkuhge94bh6
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763780246-192281
X-HE-Meta: U2FsdGVkX19z3rIVQYtBY3jeiHXS4QYNG3LSKxwzNU+oEet2JIjd5unt0pZ8uLuEtrj3NvsMYmsBzYrSN8pBzU6no104A3TDASpc53PnfmW8zTAlFZ+reCXH1kDVBZgteMCRknNDbnJ+LSVBt0Dj6nOE+be/YofNNdI72GxnlL4VHEctFG538qIEzEA2zxY2g27FhzCBYgip8iNIwfJ7WEScgYOSgqktffLcR6XudXp0jteIRA68Nd6uQcn9Cr+vbcdGcszJtfCwKSHrmE5PsBE99EA4Tmb6AEQSl77kAc6WUz51HK+5au1L+7a7KA2Kt1ErYzOzdd8ToL5X5ZvktS43ZbyVpO98GrefanvW1U/xcG0fpqvfteVS3snV7ux/oURsG/sOlY15rYLlgpN9dgOYIuFaYxjkjaxnYtI7WDynlT5apbuUpvIEqXk+StXBw4n8DDkZbqCbjacYf/90UHQI36OkxtQvYNKYWePxaLCpFTAP8KSiIM2KVcwyBPAhow31Rrge02X1QQ1RgU/sm0J2xLND+sJvv/2t2yVg7lSj2woaCHMGEleeasMZC6L1StdtI0z+TPkNqp/0o4rxdZe3Kz5Oo3mcA5CLOEkE0a7GIZueVuNulXuCIc4H2r9qch3ZDQOdxQ5xK2eho7hxWmlKyNIFfr7XuJSWQ+XLPiag6zzCs7VT+p4oedlpER4FhotZzOUV39qhnoSK0/nZS9T/lVAm2V+M/+8LdcTRXWYyWnpsL7hz2Yk+EMmVtu5Kpp/HeCprwwJuAD5XdPe/Yv7bj147UiCP4HpigfQnGAjwdLFhYwtmw5TdeY5ocK+09EgM/pf/OmVnkL0YKghz2lVIiacxSdzVyA62RSzrJhlwWT+MjX8ncHDt5EJY0ITCEXxNuw98M4JjHTmkw8aU3nnmj0a1cvl0nBH3hRr79YKsFt0omOdWZX1osNhgoH8z9cI6x7P7eFI7+FrWCO0
 k5pUk7/M
 at6YfJjj/Bv+6RJgQUxeqDvNzJgWCfmZrM5wlaG3z08xirNLFWDLrrxqhaUvIf6WqPkdMpS6jvLCOwaEVjr6/yo+oQFL7h/aDLs42RJ6pBfuX2oNXiskcENUD+AB2lPuhXZXu3a6PRDwTffKHKz9BssdfrrtecMP9xXvjKy7nzJWKx/LaAErb8TBXTpTpWff+RzvodO8lCTYt31mAwHTyhtr5Bwah0kM5dht4F6rZpN4q2xlux05Bl1yhwpoPf9t7+XkM3kj2KxC+fFeKioJdxZYg9a9QKt1frdK/YKAk5o086+/eNwy9F/OQeW5CvZ+huLA6/X3j6QJW1miNsEbJr36/jnMUuGV6eTgPjcV2DnT3z3HFJ6taYZ9WGP2jP0vJsZZAjowgrRS1LVd/IqMolH9e+WoswaTfLBw6XJWXvZj0znTo4j/xubk896ZqO1NM3YJh7ZbAcfZIw+f9h+3SDYT7aKJ1LnsG3ExExVcwfuIZzznH7vgdI1WvEA==
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
---
 mm/huge_memory.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ebc3ba0907fd..a42c4f29ce4f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3954,16 +3954,20 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
 
 	ret = folio_check_splittable(folio, new_order, split_type,
 				     /* warn = */ true);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (is_anon) {
 		/*
-- 
2.51.0



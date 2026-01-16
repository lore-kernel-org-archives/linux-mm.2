Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A012EC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D126B0088; Fri, 16 Jan 2026 11:29:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBEC6B008A; Fri, 16 Jan 2026 11:29:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF51E6B0092; Fri, 16 Jan 2026 11:29:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA3256B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:29:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E6BE1ADA07
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:29:41 +0000 (UTC)
X-FDA: 84338362962.15.53626A5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1B8424000D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:29:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UQYR0YWQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mR7SZOQq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768580978; a=rsa-sha256;
	cv=pass;
	b=0T+VDzsw9Rz7ILhp3gwEO/wK+NbZiOhBTJ8uLWi9kbqCcxjgRMO1/2zQHIMzEPXYC9NCQQ
	rEBy82vIdoJi6ygzcWT6gqlC5njogi/VNbe9HswGDY9i0eFOqIsbfKjE8pJwTaQbK56Fce
	WbFENTEcbEn+f088Ajn0oPR88siX+Zo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UQYR0YWQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mR7SZOQq;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768580978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wr31TpgpMpGL7AgPEOglhSL8DupVbujpqyj/H9rp0G0=;
	b=dFuk9p4HYvNTm1hVnYoq4IqpOtLWBEqptxwVeZun6z/kbAvHmN6VRtzAyysVoPXycjGW8q
	qq+Z7rDuVHAslqONEeuVxHxSJXDhueDSYkrhY3XYszNBKN2nOvIiFOpqMI+jNZAZadEV5a
	O36wgWA1aB7zZ0D6D5AN8wRnkmrUObY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GEbEHx1432554;
	Fri, 16 Jan 2026 16:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wr31TpgpMpGL7AgPEO
	glhSL8DupVbujpqyj/H9rp0G0=; b=UQYR0YWQeouIAygHdxIdeEWX2n1Dszfo/h
	3N9S3rXBypi4DxqDdey6XTP1ZcdO7vGz6EIzD3iF/NOFxPjpFNTIe+5RstLkCFTm
	wol9eato/Slgrnk27AsJspY/8Yc8hhdkHbYGccjCBFzyWqTsNNw06YuRKRIRg0Gz
	rCH9MzQBgt0agD09pjnCLldrrao9hcNnHrJV3ISKEoqgOZ9qsd+4pCguTcpiSnvf
	5MMR29b0QqtRqPL6FUtvsFWRBizBKDjlcZLe3FEyWd9PujodnJJPClkrAGHPoriT
	ePE+StCaT3j7HCwl/qJQcZNVpxuQoZkPu5igf2CYmIgx/kDxTFVA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq5a771-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 16:29:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GEiQg2029164;
	Fri, 16 Jan 2026 16:29:25 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010008.outbound.protection.outlook.com [52.101.46.8])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7pvc1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 16:29:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JY9h+Q+tpaZCTc51IO+2OzIwzrwoEGqFdjt8EH1E1U0cU73NbicchSIxmTZlbuxaRVrDkOxnRydN+TVYQKpaLEnRuT6M/mi1po7J/2+ms6nRkuisGBa+wRNvszPbyftNXs07QPsDqMnp5WGTc8pwSoP7wANpmljID/n1StZq3dXImj16QmD7c8kv8M/If55DUHzgV80B57ImiTyefTvMLsjtyNLwyefTjp3xU4ifFDT4OtKJrrN1MWdkRVvGeDOY55lTQ16DEF6b41/eayjY+6F5rKvKzTWErYJYFszCS3E1ExNt4BPBB7Zt14CTNYaV5yDti0Th8RS/6eFuZzBkJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wr31TpgpMpGL7AgPEOglhSL8DupVbujpqyj/H9rp0G0=;
 b=xxM1xFaHY68aXva1HBgy/u1zfuDAssUkoLkF/K9RU61X47qpTkdglicjefVtd0U8zCAb0uO4iXM45XAys9cM/OfxlMwObCz87mb3vYUgrYuG+iRfOxX+79kp21iPiy6hLETmB0M8E08aaMi8+oKJnjV4wMCq2OaRTCckF+FtP/438X7iX1fqrDKKfO6LXZ09vmFYwccZefdKGs2H75gbQxQH9yia5abExddBAbB9mMGqC8w0AhSTBe4sxpN4tmam3d2desTkoC9EofnEruUN6fKhKbD4tzkDG/EvkV7l+/LWNUJ8DGFD3NehjmEXTfJ4uRmSjhClXEkl06DlpU+ygw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr31TpgpMpGL7AgPEOglhSL8DupVbujpqyj/H9rp0G0=;
 b=mR7SZOQqmylsOkIbB4AXPbJ8sH2Gwt3BWlEyw6o0Cp7puyKdWGnDbxKm7bx6pGcKxX5AloINGJMI0uhIFt80bshgLYCw8TM7bRAzimagikWk4TcvAq0OavkNc885jFwLtdE2pAlKu3Lm2l4tJD9CEhyMSsVoe+54Sb7aHgirj04=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SN7PR10MB6571.namprd10.prod.outlook.com (2603:10b6:806:2aa::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Fri, 16 Jan
 2026 16:29:22 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 16:29:22 +0000
Date: Fri, 16 Jan 2026 16:29:25 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND 1/3] locking: add rwsem_is_write_locked(), update
 non-lockdep asserts
Message-ID: <c9f8bed8-c0d9-4fc2-ac9d-4e7b78418438@lucifer.local>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
 <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
 <84A469CA-3497-42A3-A3BB-42B7CB1195DC@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84A469CA-3497-42A3-A3BB-42B7CB1195DC@nvidia.com>
X-ClientProxiedBy: LO2P265CA0153.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9::21) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SN7PR10MB6571:EE_
X-MS-Office365-Filtering-Correlation-Id: def5c6ab-de35-4812-82d0-08de551c67ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rP52iBbztZynxx4iuvkxW7UC2ypLLHOcxRXFfSW0d7pAP6zqGRnr9ES/LSV0?=
 =?us-ascii?Q?t2y6BqMPmywKwne+G3GEK5QmU7lGxVlW8+Hp2Q7rZ92Wep+APUHidKkvjiyP?=
 =?us-ascii?Q?cICyJyIOlwpIxELMP7KaUXRBxquRid4UYa5vPlX5Eyy2RupnjpJEQZFn/oFC?=
 =?us-ascii?Q?FiZ1gFKFi5iFLcUhLknbS1SsV2t6Anho9/X9NDSgocSQrqg5ZDhi8i2qRZAG?=
 =?us-ascii?Q?BWgd26pUMbK9/XPePE6eQrhCpktxkyRlSMQo0HAToyn2bU5+iKr+RkzTfZRn?=
 =?us-ascii?Q?XnrH1+2VcZu946FPFMN45I4cK+Bf4ff0m3uwAdFuea0co9W85mHz0TGpdeN1?=
 =?us-ascii?Q?Zlq1JqESEJm8PhufAgHL6fw6ZcxpOLNhhc2PdrVqS2ZJk7AH3LsiTTJ6Q9LV?=
 =?us-ascii?Q?qv5NFRXkZHxA+N8uAKANHPEI03WgnhWt3aQViRSPvBiX1nAU/x6SzAQeUQVp?=
 =?us-ascii?Q?MLSX8EqxlnpOAAGANPUzbv1yGpBgMs0Ys5B6crvAOhoZqdutaA3jMRh6MIpt?=
 =?us-ascii?Q?teXAg8b+ym155+gmR4nzaAG1onnYDI0K9y5gLQ6CPbps9HbR48ZkBrfxH7dm?=
 =?us-ascii?Q?jITZ2WfXAjzDuMb1azUpO41sxqPDAFIdAAEl6Szh45O/Gv9O1nDPP70THtjc?=
 =?us-ascii?Q?6HU7s0ggXAK4LgPdUehdoP/Bra204EZcEW+rZUcbu1Zlwvr0ziBlozUt+t1e?=
 =?us-ascii?Q?hZS/Tp4RfYa1ElS5rHHlBJ33q6GIZowjdJpSM4iqv/RHVjgM6x9eKNloupjr?=
 =?us-ascii?Q?csd57bctYQpN6jMtxP20Btp5kB29ZlZJrdB0krPoRVb78yvyhOW+qfpAuJeI?=
 =?us-ascii?Q?Qg3xU1CySwbFohreu79qfFOYdGboC4GSz6Hn6vSBveav32bbm2DLEPUeRW5A?=
 =?us-ascii?Q?due6EK22uHpfmNTUnbY6ADHZMUxB8qqheOSwrZq1UMZKluQJwjrCTHuXGmSY?=
 =?us-ascii?Q?ydAlwCHHbBYRNL4LJNUNiyC850BIy4GVbMjnIA/+pu5dCBQKJcek/9k2YFOK?=
 =?us-ascii?Q?n5R0ZKtvPys3Xl4Q1FXSobxb/oVWFlRAsabbUUKSwGekQMkSPUWdZZLMqRP0?=
 =?us-ascii?Q?/cCbkkUveCVc4ETVOcktnLMFXykjSahXB7AbMVqoXiS+mJD/qxAJo0XDAoSF?=
 =?us-ascii?Q?YppPFtaJV70CwCZYTuziR1Kt3r3dw67qvGDESXLMH09eDWt2c3neyIL35Jod?=
 =?us-ascii?Q?rFWd4AnhWuy2gZpYsLNw3VVWdu1tbc0oZf6A8hL4mG5Yv3iRIHa7HBI8vacJ?=
 =?us-ascii?Q?0N7hSCMB8M1Ss6xulT2qrB+vRxs5CBypCnEbEWmar5qWOKhRYJDsMZdggA+5?=
 =?us-ascii?Q?zzu0DEq+H5+OGPz1yLsaSQNs+BNmyIC2mIgsFPCk0YHFWPHC4SN7A6D5vph0?=
 =?us-ascii?Q?zuKM6ax7r7WSIt/kWysla9ob6KNxWhb8mWGyIYCo5HZG+GoehqKXL0/9H2FD?=
 =?us-ascii?Q?CVjoB9atJNeDlfuDE+ZEXYY2TTJASqku6szMLg8yTiaYwuCv2uNGNs/FJ4CJ?=
 =?us-ascii?Q?XtYs0HUIlHA7rkgJIYH4BAlm+s05/9apH50OWBeRuNv8bIfVMtYw+BIqxKg2?=
 =?us-ascii?Q?KwVaGPO+ZYsjlOWhbn4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7957oR4F1TpdKj6ggsYw3CNXPVzNntrd3+OXW3f6a3gQO3dFxpsfjQMLZh1q?=
 =?us-ascii?Q?ujxW7AuZNl31f1aYIPFfeoQqBdR+pTaC1BiBxB7al3tck1dc+i47xXlUFMqc?=
 =?us-ascii?Q?8W+HHkoXELkKszJNQOPhbY2y68NOAbnPb75uL/u19negz9danBFEQzkQjNXQ?=
 =?us-ascii?Q?aOhtzzbweZpEpjup/S9+ys1W3WLt+khgMKfgt/w3oOYWLcVSP6cl/orlhvkb?=
 =?us-ascii?Q?mTkYqvQRH5B2STtfEQWqjv8l6VSQnOL8Xj3iLpWChxuI8MbzmlC1rZAATyb3?=
 =?us-ascii?Q?++faOYGwnlbG2tHtNhrz6x+K23Q1kCskpDqXdzyWCvrTgbj2sfrFjPv4eFRP?=
 =?us-ascii?Q?U/ar2GAOHj0B3fgyi0JnRlURvzsqnebMw6opGF+8P1XqZctGloW1+Z3Dm+o3?=
 =?us-ascii?Q?sOVD53HazTMV8t2zDsMrlAScTjJKejbufJr1i+AlzbYna3FUYnek8YiAqz93?=
 =?us-ascii?Q?E2mq7anmKjY+ppLPc1Ydlpg8jiRyHafdXbHAOxN+T66Uqg9RSEIgXVcLWndO?=
 =?us-ascii?Q?hElYI/YUZQeOX3GZElcncTCu8SDMJ2NsCTsHYwZsO4DEK3IHWiTHfD+rnksX?=
 =?us-ascii?Q?Yef4BohfHkUXIwI5gNdu1QrBP6Atm/hgi95r/YtPiJFkDsWv+hRzQavFfGgV?=
 =?us-ascii?Q?Vh9D/M45ORPtmoICbNl3vbEeYcg+2tE68+o6A432QRXrwe3+1l9H6pbHXv8W?=
 =?us-ascii?Q?P2JfCkDm2i86wUdGK2GGHlRqyMz2Ril9KKYk4u8O1nkiPXk0siPfIUy98Mwk?=
 =?us-ascii?Q?ne2cT6P2Ei5izOfnAcTdGccd0jH8nzp2hHZQJqnbiUsbjwhzCrmCERkroQ3M?=
 =?us-ascii?Q?V1f3XrMOImpuGSnThxtfKHcD4ySEQEwZqHHOY2NRGSTU46rY8Zkn3c+T1GOZ?=
 =?us-ascii?Q?uFeIzDpQEfwGaufVppWA4D/E9pA1vLluzwqgdpp8FQ0NUekhuK4Zf8bT+B8B?=
 =?us-ascii?Q?Ccm6L06Ck22gvLt/Y9KiHvjYUSKI7pdR7C3oIK8J1zMfK5FiDujQQ0ty59p1?=
 =?us-ascii?Q?8tSaNN1130bXBKLWNcYkJLPs9e/joY+AlBY78C7o41Ln5VgF2FZoKZFs5KK9?=
 =?us-ascii?Q?1N9om007JS0MBf2/xQXiZfK1AQ1/bdfWMsO5vVl6lAklFpuAVZWavl+/+U++?=
 =?us-ascii?Q?dWCu4e/NbYJ0A4K121TjP1GJl5qSqhAJV1T5W9rO+MTMdvHvuKQKq/PyvNR4?=
 =?us-ascii?Q?w8g1wCau/Pb+WFJxgDY8nS8QGSDkjQn4QjcOkfLktJuKpuANzGFr7hqGOvqd?=
 =?us-ascii?Q?c8Rbz64HD98gr81sfsPmH2bq42wszxmEFffp/2PlMqVhgsrg90ksybgY2DQx?=
 =?us-ascii?Q?dIY72++M3WAMUuSRvTxV6tZhRZS4yM+oStjmodiFrUNz2Oxuh15PJ4XxEzHP?=
 =?us-ascii?Q?+vaEXsTAlxYvGkS041vTZQw5l7rxsrjYe9raUJ8Ho5r2AqcZ+Ie7bXVRtg0H?=
 =?us-ascii?Q?r0G113OiC92YjVW4w4nInhIF86sHJZ61+2GyGwkaeB4KPFDfYY+taBTGRbbE?=
 =?us-ascii?Q?+3VeUEzh+zZkm4lb6kx/9e1RETacY2mYcsl0Ufy5SG6AHd0VUZGP0mlBO5Sf?=
 =?us-ascii?Q?1V9jFC4F+1sCDMvIyHb46b9w+UYyujCWrrhmoAdE0u+4H7IgJVN0/BWQUUgy?=
 =?us-ascii?Q?XDVwp6c+hPe/+Z0LBdxUKKJz0LnKpwc7QhfKFdpIV/Pu+2dDcGHAGLD7uSTw?=
 =?us-ascii?Q?GRC9WCFBQYnCXuen1ThimK043yoFReHGpPaQ1tz0SWbT14d5Uy6ImkN6T9ZY?=
 =?us-ascii?Q?GpJ2Ad9J9P80SqpxVSX8rgQ8O7VDHi4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rQKBxAN5mQ/tFha5nkbd5DxCCfFaaaGg0XZm7hfKa30uCRhbft1KyRBXf946Py11eqiMGJbdW2uZZ6yUD4t3GwWOWjBKZtQVJmtFgC9unStWBveM/qHuMKiEalkyflNUl5q427xeWlwSItE72MD783jNTlcncEaKPT58LId8SEcYGHorpDOLiRhGvblXim+Ls4TRDCmV50TviHM3UqPPW3KKjwPKniwxdOLL2pmorrEDFZpprQ9wWzJdSGFqA9WxOjP6ePTLWBOWirKBg1zN+PufyOGy0dO6U2sDxCK25Z5Jh7/vDk82Ofcf3KuhnX1AWxxJYzkAt1RrDvOsMlrGCHG/ki5a47nezuawruJI+iqmZI6MZvPwCcGxwFHnQ8nBpOC20C3DE6oDBulFZJIPXhw2u0f9SP9QhuLHDlkc7iquCVeZXJ3U2nrawDFVjqBN+OaN4BFI8cRsi6p5L94e7iz8zXz8M/s5ibBeB9697Z7ede9T2aedjLPsfBmLUGqCj9ezHxR7OxuvkpieYlVoSSjxPhLvmWcDgowubtAmwDz4bnUB8zRJudtd8i5k1nMHW0WMTUvC9WBpWrk4fFt04vEXJvTAdnl8TSJu3UTLBLQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def5c6ab-de35-4812-82d0-08de551c67ae
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 16:29:22.0964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cWLcv9DgXlTqlsBlAHnAD4VvrJMEw3LK366nzYMm6+cTgON5z4enV6Trr3REzHotFyrIHnov4ULh4PvkPa3g/v5dVUbOl3Zj3GrWUfz1dKM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6571
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160119
X-Proofpoint-ORIG-GUID: puM5bry2U18JeCZm-x38gNgAEqxwv6gq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDExOSBTYWx0ZWRfXx/b2x0dURmzt
 okP5o7cG885eA4YevNI5lpNlDyzZOnLtObT422hVWzpB6xtuprjvKC70yeoTmUa8v6Lyyv3YJoM
 yzjLA76R9F4+phTRJZtu7c2fK8rsz50TZzU0i2HzshKHpcWLNSLk7FihlX+TecS7f1OCVZ0J9/M
 UywQ8fEtcWtMQanokmImlRrJvTudQsTv6yHIwFm0wXYm89W5TMfQ8oxzg8UaMeplB+m2bgB5kYL
 NTR6dqH7b1ThXv0a6NNH0uuS1d/SAKkYJY+ABEW8LFS5fpSx/74JGmNJkPAkd9uPG+NKFnyF9r/
 ZlhGEvoP9wNXGAlwDAXcxS+qQJPcXXF99PHeYwC7KhhtGged1B4qS7xFJt26DYMMXg8Jnpbap+0
 VA7FSJAHb1Eh/5rTwtKxO+Mq1BNIj0gSoFz5dY5OMaFfBkrA034oyOEhTjxQTYP1bFDZYfoQkHw
 jjZHGfuKZFEnebLQAH6BoovIjXaUaJe+wWSlOibM=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=696a6767 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8 a=oRdqwO-spBd1wXWhiFwA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12109
X-Proofpoint-GUID: puM5bry2U18JeCZm-x38gNgAEqxwv6gq
X-Rspam-User: 
X-Stat-Signature: dpddaapkpa6819n7xg641jbrjdwm5jca
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B8424000D
X-HE-Tag: 1768580977-188854
X-HE-Meta: U2FsdGVkX19p32D+IypK3GbXo5YvZ7+T9NRiOenOI2vrYRNPVeF8ZptGJolQuOCmiDPDTprru2NJPveL7g1bovRL2Dy1bXcCaLb0rjmIPyxL1D0a0NCb0P18a0Uf2mHfP26DN3anDdDC0TEaiePumzy053zG8kZBQ0Mg9NcM/zfkVQix+GNiZjQSrDSB6C5EYXjPeafvQcK6PeK5iyNmOi9kMY+uAFbAGQgbK4pj0/ADofbAxsSk52BD0mINEhM+2EixPPEMu2ePzndDn3S1c84M4HRV9bkWYraniqCzHhZrWYDPyF2HGFabBFR0YhsjpdmGlAD/Mjndmzh2YFkTASlPx05Xug+SSTjTSanL4B6ZsooOU0jQ8TuhDa/HfaSeRSjw8ZDTabSoZvD3fDTbhyRF5RjPp8ZLbP2wHQlsQvcE6QMuPP/Wjzbq4CxmTOCZTtdgKJFE9wwZAGWdrCWueqxNuYwHChT3vVQXcNYMrWEJ8q2BHYR+Utq+8lks5arpzJDoybgAF/OF9DxmXU0VTF3HXefGkWmz9Vqrlvvw76ytO25Mktt1XOU1s9vBffe+zjMvIpgj1DaahC8K6W8Q3+re8bwDgBgsuLiIKnfpirzjuRFJQpgGu7PGlAySPAFhZRpaxF4ez2PU24p9lfJ0ds1tyRMzK3dMBX988/T/BLmrNr5vrcD2ecucrchKCmranUbsp6wPQGX+f9kWsHK5PWbVBJ8+Gh1PiGDzIQNqspT1F9vVO46pqhIuvIg6hAUlU5l9svukVj6Ie1HuYLLEpX8QecuC7wPyhWhjp5I8C9t8/ze+3r623tR+EW8wocL4Nt9ra2WZdrLibiZa/UY/nN4jA9JCZFDqZeM1YtFVARncqBX9vqe4CL8bpOMh7lYTPBN1fZ1z3qOGTLWDS63sQBL0ZtxlxA4wgsLzk7bDfwfPCj8JlrthERaI/gbaLH2k2zGEn1mq3D86XxX/weL
 mCGVxXsy
 AeRfoG9ZOFSDQF84auWr6BaEGoHnYRcwx0Uzw/YJ1zq/1HCCAom8Ihsi6xVUFZcZ4lys7nLoiONcCs2cOpsuAbVhhwYhRrSiWtosobo21s3nF2rB66RlkLW8TxSQ2wwyd/TMJJMLmXVEkODNGG+KgNSzVe9Hb5bBSOvc9MylwoUPf4nsQMGr3lhGCaldXcJJDVntWjPe+euKX2qVQatnHekRxU2621KO1AvH04ObAz3L9f+p5di8jShnM6gPc34zIDAYnZ5rr2QWHYYZvm+WvmUhaGJpOHcLeRwbhSJYmjBNDNQeVDNGjvLscmCr4w6kuSEY5ew+tdwOruGwU9u5AFApGiqx7Iju6xb7e2Sz4U5BwhAafomm+YWIb49lDKN1yf30VQEyhdgOygBl1r39tHuhywzqp8Y4tAlTwezvC1Nndz6CfMKM0rKT9Rh8AOIuXN+DLR3XuhUuBp4eTmSrAUfc4E3PNlVCF93gWRxs+8zutgT26kW0P1OczRRPPKxMTa/d2NXJLpQCFuNBqU/zcbXxQzSX2Y+iJBDsIG2Miaf9GwbhkcvhSyZ4pEahyHxIHqzeP4F3r1ue4T84usUgKFkfiV1JM6M7iwfaywVj+iMlloF/lyzIGJadmsCG0QpAQKt5YikCQZt5lDTHe18Q8PVEab5fsqPgBxkCfJNA06bJDntFmYkPjgWs6UkZ3tURJbUFS15YiefiQDnmM0GgEZfMXJ9ncnActr80uWtSUeWK9Hfmk3bq0kg0B+NO2NPewHJjH7+reWxyF+DGcFEOvqUQWex6GVcEBVARq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 10:08:00AM -0500, Zi Yan wrote:
> On 16 Jan 2026, at 8:36, Lorenzo Stoakes wrote:
>
> > As part of adding some additional lock asserts in mm, we wish to be able to
> > determine if a read/write semaphore is write-locked, so add
> > rwsem_is_write_locked() to do the write-lock equivalent of
> > rwsem_is_locked().
> >
> > While we're here, update rwsem_assert_[write_]held_nolockdep() to utilise
> > the rwsem_is_[write_]locked() helpers directly to reduce code duplication,
> > and also update rwsem_is_locked() to take a const rwsem and return a
> > boolean.
> >
> > This patch also updates the CONFIG_PREEMPT_RT helpers to do the same thing
> > there.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  include/linux/rwsem.h | 20 +++++++++++++++-----
> >  1 file changed, 15 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
> > index f1aaf676a874..b25b7944ad99 100644
> > --- a/include/linux/rwsem.h
> > +++ b/include/linux/rwsem.h
> > @@ -70,19 +70,24 @@ struct rw_semaphore {
> >  #define RWSEM_WRITER_LOCKED		(1UL << 0)
> >  #define __RWSEM_COUNT_INIT(name)	.count = ATOMIC_LONG_INIT(RWSEM_UNLOCKED_VALUE)
> >
> > -static inline int rwsem_is_locked(struct rw_semaphore *sem)
> > +static inline bool rwsem_is_locked(const struct rw_semaphore *sem)
> >  {
> >  	return atomic_long_read(&sem->count) != RWSEM_UNLOCKED_VALUE;
> >  }
> >
> > +static inline bool rwsem_is_write_locked(const struct rw_semaphore *sem)
> > +{
> > +	return atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED;
> > +}
> > +
> >  static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
> >  {
> > -	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
> > +	WARN_ON(!rwsem_is_locked(sem));
> >  }
> >
> >  static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
> >  {
> > -	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
> > +	WARN_ON(!rwsem_is_write_locked(sem));
> >  }
> >
> >  /* Common initializer macros and functions */
> > @@ -174,11 +179,16 @@ do {								\
> >  	__init_rwsem((sem), #sem, &__key);			\
> >  } while (0)
> >
> > -static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
> > +static __always_inline bool rwsem_is_locked(const struct rw_semaphore *sem)
> >  {
> >  	return rw_base_is_locked(&sem->rwbase);
> >  }
> >
> > +static __always_inline bool rwsem_is_write_locked(const struct rw_semaphore *sem)
> > +{
> > +	return rw_base_is_write_locked(&sem->rwbase);
> > +}
> > +
> >  static __always_inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
> >  {
> >  	WARN_ON(!rwsem_is_locked(sem));
> > @@ -186,7 +196,7 @@ static __always_inline void rwsem_assert_held_nolockdep(const struct rw_semaphor
> >
> >  static __always_inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
> >  {
> > -	WARN_ON(!rw_base_is_write_locked(&sem->rwbase));
> > +	WARN_ON(!rwsem_is_write_locked(sem));
>
> I thought it was wrong since rwsem_is_write_locked() at the top reads ->count
> instead of ->rwbase until I see there is another rwsem_is_write_locked() above.

:)

>
>
> >  }
> >
> >  static __always_inline int rwsem_is_contended(struct rw_semaphore *sem)
> > --
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

>
>
> --
> Best Regards,
> Yan, Zi


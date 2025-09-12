Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA45CAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 01:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8668E0006; Thu, 11 Sep 2025 21:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441B58E0001; Thu, 11 Sep 2025 21:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2168E0006; Thu, 11 Sep 2025 21:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15E038E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:13:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFB0BBA5E8
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:13:40 +0000 (UTC)
X-FDA: 83878825800.25.A030B91
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
	by imf27.hostedemail.com (Postfix) with ESMTP id 070F140005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:13:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ul38ViS7;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757639618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HL1Vy3tsWZD1aW4hLZDXM0LRjZbEUw7ynjN/7K4P2YI=;
	b=zr/AFEyOzmgtdY+Nj51XQkJSeL6f2+b5ZsuuVQBxYAOk94Icpjq0zP4QM/QEf9H3pubvt4
	2jK5hNf1RyZ3kIMrtLckBI2f+sRW7421wX8VCxAZ66g40iEo4UyqG7ngCujKkSJQqgAZvL
	wnZW7YQ5wfjFEDN4tpxpX1OzaTY1wmY=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ul38ViS7;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 40.107.93.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757639618; a=rsa-sha256;
	cv=pass;
	b=FIhoZcyE88Btr1VLkhK4gS3OK6McYrFnjbRmrxfbpVjn4rd7C/K5vbpjOufwWWIfVozRxA
	tccwRC2B2kbs/4Xmo22wQrKxBiRcie8otDYXUrwukkpQTKtjOwV00siZaCmQAaupxwxbMV
	jiDHzd5XmqmVfQDIckFrD9bDYkIwlwI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SROl8fQZkHtCfDDUk0lmNu/R2me7pgrrldXua83Q1C8dWQpZ3kLUVSjnmiwJ7PYpKexr9SjN20qt1KTsE3cxkwQskNhdmlWtbLHCx2YR5Y+HzCGNJllbbMf3YNnvQcowRrgqdCgBGSTB/PIIN4i1fzOJHca+/uSqx+SLjNAU8jidnx8Rk9o9QJ76xfI0JqMp81yNPLOttb8YFqJ0abdyXmyL0cKJY4KSYJyB642GbP2LoRJ7UZFJDWmJrq2IwXZuBzPr9qaagHqWODAJPITOEYwvGxdfMzWk1YoU82fRWOH8xOUDmStT7CH2MHnOf4D5ViZxo348777Ie4Ieb3IAog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HL1Vy3tsWZD1aW4hLZDXM0LRjZbEUw7ynjN/7K4P2YI=;
 b=l6RiIFEjJDvOiN5avqfxxnSFeJ08LsUzW074eOcABa3PuKOHOpoEdKCvmshYNWnlhRXKUHrO/vZB8z80BKj5WkPxj4UaY8HS5W/XmrQmkfSmUMAo4ZpYijtOFm25C176WQXkHTCvcLfMN8+cnbMqj/bcAaXyCeyFAEN4t9gJfSmXri9uzEuSSgzzSPuX30FNew6Gh8AU7EvAJ6V5to5KegdqFoOsy3yZrXuz6jmYmDoH+MTYM8yjatAYLRK0g9jEflceruMauCZptcjITjDRZZFNzoDmn4ND75Hov+GwU4/Xmh1ggcSnZpTgOgcEZvwohBBFr+p8SqyscTESYnLG3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HL1Vy3tsWZD1aW4hLZDXM0LRjZbEUw7ynjN/7K4P2YI=;
 b=Ul38ViS7RCxB/a+qP+6b/GzVSaej9qIWI3WdV3nP5gL6k2iMN7/ipZ2erhN8Bwauxi0zpiQekPWvuys1t/D0uf0RCVaRuBmf9mdHvVWnnfTg/wJux6wJ9N6Rb9njFSiwlYa+jC0g9COl+Es8pPU3RdqBq2brI6uFgTwCQ3fqhFcdANBWTvNtsczqaiYYek7mPxfClmFGkl/d+9waNHoE0qH2X4bY/YfuOMJir5PnemihO+6XFJHqCy1s2I0kguGaUQ3IN0PPnRpH2vZWCb8FJdDy1Hre9HhJB4N/9wK9hs8KZY3VVPZRIZ6n6wcSAHp+/VKkoARxsTOOEjyLX3AcNg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB9037.namprd12.prod.outlook.com (2603:10b6:8:f1::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Fri, 12 Sep 2025 01:13:34 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 01:13:33 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Date: Thu, 11 Sep 2025 21:13:30 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <0D6DB0F3-A893-4B60-9939-FF4575FEE3CB@nvidia.com>
In-Reply-To: <20250912002854.plq5uhy432xq6puv@master>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
 <2A28BE8E-E62D-4ED2-8A35-759BFAE4C52C@nvidia.com>
 <20250911033413.qcs74q4n6n6767zj@master>
 <20250911063034.uafc5mmnf7k4d7km@master>
 <EBA618FC-889E-48A1-AC02-9A18F6B5943E@nvidia.com>
 <20250912002854.plq5uhy432xq6puv@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9P220CA0012.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB9037:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c631651-0623-4656-c6aa-08ddf1999733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVkyQmJ5YmpQQlFUT0hFeThmRk9uSVB1VE5MQkJVMVhWc2w2MXE2STgzZFc3?=
 =?utf-8?B?Q0ZiOG1EVEhKRW53bzROdnJaTklsVC9uR3AveE1lSk83ZkJnSm9sLyt3UVNr?=
 =?utf-8?B?djNjaGl6cVkzV2ZFd3poaFNnQ3Q3a2c1SWlrSkluc3htcG03ZUxnbmVaQTFi?=
 =?utf-8?B?d21ZWmtXb0V1MHJmckhMVkVuV3AvYkRlS3FtdDFKVEtFYzk4aUlOWWp6SFlj?=
 =?utf-8?B?NTBnUnNQMHJCNXJjWnlaaDRlUUY5dlk2aTBoc3ZoV0I1cWcvc1RCWGZNOTA4?=
 =?utf-8?B?RWN2eW5lNndDamhzVHNLOEs3RzNveDFNYzVZWGt3QVptSHBKTHFSRml3a3dP?=
 =?utf-8?B?Q2dvWG0zUHlYdHFBL0s5L0RHaUZWQnhSYU1wWDVCOTdLbmVOZ1Nxd2RBSWdW?=
 =?utf-8?B?L2oySVpadVB2VFBTRkdoUzNRaWYyS080bm1ib2JRL3pIQktUY2ZlZS9uNjNB?=
 =?utf-8?B?a1R6NDZFODlJVGFKS3BMTVFsSloyTVNLbW1CUU1ON3hSVkVYdit1OHJGMHJC?=
 =?utf-8?B?MmI0VTh4emc5elZ0MVk3WEVSdTNmTUpYUkZqMVprN3JkQlNBaXEwUHF3LzA5?=
 =?utf-8?B?NUhiOTVEbUNLeFVkdGx1MGo4dnR2MDhmaDM5cWZ3RjlURzZZT3BLNWNlSVVB?=
 =?utf-8?B?aFZXaUlTTmVFVUordEtCVVExaXZQSHpxWS9UNENxdjNuOUo4emwzaU1NWDNM?=
 =?utf-8?B?M3NVWlJrdmxjNE85RjdCaVk0VXF3V2dvbHorYk5IMHpWbFQzdm9QVmdNTklu?=
 =?utf-8?B?MkkxOG1qZEp1QUF4WGtoQk9Qa24zY092Wjg4WXJTTmZEejFYNUhBSUV3dmxX?=
 =?utf-8?B?UzFhZmFsZ2ZoSDQwTmEvR0RlVTA2UENIOWtaSm5vSzBScFpQMk56eEJSZEM4?=
 =?utf-8?B?ZU5Hb2FpL1RZMTd1N1U0Q08xdUJySGFQRTBDTVNDZWpwNGtManRpMjQzWnRN?=
 =?utf-8?B?WDZIM3ZFbFJodi9ZVGs4dVNQd01Vb3pSWjBzbTFQZVh6WkpRYlZRNFVHOGdF?=
 =?utf-8?B?eHZUSEhUUHBiQWpiY29rZ3E4WW0zSDZmNHZpWXJDL0JZQkVFM3N4N0RteExE?=
 =?utf-8?B?RnRBaTYxRjdBV1I0WWsyNXRNNFVZbDhVazZhUjM0WkpTQm5KWk9sN2RpL3Nj?=
 =?utf-8?B?K1pFbk1Dc2t4cW42WmhFa2ZpUWt6dzFBQUFtWElGcTR1dEx4eklsN0xlbVBC?=
 =?utf-8?B?UHYydlJQcXVsRjZRamtZWEE3L3Z5MGNaUHV3Q1FBdkdPdHJwMDlRTHhrZTU4?=
 =?utf-8?B?aGFpRUJqMUFOUEpmVkgweFBJbjFMZzZmTXZQY2x4STlIbldaRy9oaXRuN1Nr?=
 =?utf-8?B?Z3p3d25rZzlrR293ZVdhTkhuUUNJazBwZ2dVWnJyODU1OFYzdVpZTXJ0Skx6?=
 =?utf-8?B?MkFjSW1iZlp3MTg0OWMvc3NodnNPZGU1NkFERXhMdVQzSVFGZU9UT3JaSjFJ?=
 =?utf-8?B?MXBsV1Zhc254K2Rzd1M3UGt4TlBzV0gyaXpmb1VmenhYOXljVEEza3orcVMr?=
 =?utf-8?B?dWNaRzNaR3lUUW4wUFhDekRrT3ZraG9XVEQxRUVMNlp0RkV4cXlwYnlOdVg0?=
 =?utf-8?B?SzdGb0xocE1lN3JMbXZIUzdqV2FVQllaSGtRZnZJcFRFbHhmKzdXcWpiWmVx?=
 =?utf-8?B?dGNWSFU4NStqN1orQUxqMzVMTjFSc2tqZUZ2enhBcTF1bjRPWDNpNGw5UWxy?=
 =?utf-8?B?aTU4V0xWTDRJRFM3cnNwVHZFcFB0eWFxVjFRNHR0MmdNbGdtcGkxOFpKTXR5?=
 =?utf-8?B?cEt3and0RlRnY0plRXNPNGo4RDlCeGdubGJ3RlR1QWppY1h4d2N3TmtjY1hY?=
 =?utf-8?B?WU5jVnhmdS9ra1dnREl1UnJ4TmVDSlN2RUdWNUhqVjMvSUQ0cy9ibW45QXVD?=
 =?utf-8?B?cS9XUG9EQmJzamtnU0NUeGxvSm5aWnRSdk9ybHpmeTNDY0xGdjN0Tnc0aGdl?=
 =?utf-8?Q?idgQdpIbsBs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFl5YUR4dWRMTElzWjBWVE0xRzlSdkpmaXVxSTBUdEJRc2xDRHIzZXcreWJG?=
 =?utf-8?B?Ym41VzZ3WU42THJEeUFKVFg2c3lzUVJWS2s0L2lkd01IOXM0VTR1NEZGclJu?=
 =?utf-8?B?V0pTMDlUNElBYTFEbDBzRDRHT2NsanZuWmVOM0xSOGJ2ODhuNGE4b0huaU1U?=
 =?utf-8?B?UjJMYm5BY2lnRFRKc050QTRvMEZiR2UzTkVncCtydXQxbkRydURCNTBOWGx2?=
 =?utf-8?B?ejlsTy9Kbi9ScmdHWmEyOEZ2VVU1Q2NITXFhQkNBSkRDYk5vNWZEclZkKzZW?=
 =?utf-8?B?blBqVjZvTHlZdXo0UFF6OWJFamMxQnpHNkRLeHVZMFZjTjdEb2VVbHU2Z3NS?=
 =?utf-8?B?WjdmWXhTdUQyV1BOMWszNHhrd3dlTWpVaEkvUGJsY1c0WVFYcmJZeUM0aU43?=
 =?utf-8?B?YVByRUdSaWxjRnloOGtSQmorVHFIQzZFZ0tlc0tnOFh2NVlEV2szcUswdmhU?=
 =?utf-8?B?RDhlblE3K1g4N2RuZFVtVVYrN3MxR0NWV3hINmlGenJ5QTNEb1NkOVNLTmg0?=
 =?utf-8?B?YzYvRW9qNlVxaTlpUFNTSGhIaTBrakkvenBuWmFhTGhDRVJCL2piSXhhL3lh?=
 =?utf-8?B?TGpxQ0s4YUg0YTBWajJaQXFBdkF4SFptSllSNlhzcDcrK09rU2VlTURRZThU?=
 =?utf-8?B?bnRDWGlmUThRQ3IyRTlJTEFsQ1psZWFQSHVvUTZERkdOdHdrVkJINVVrTjNm?=
 =?utf-8?B?dDdFNnZzdEdKK0d5UEtzWDcydG80eENScEdWaWxma3BlOW9xY3l5YURXbFdQ?=
 =?utf-8?B?QzAyTmtyN1dzNUNkazFnVDJQU2F5LzMyanZPeVlnVi9KRitiY3ZBRDlrOWFh?=
 =?utf-8?B?RUpWQzI1MURNQ3plOW43Zy9vbFFkOFhlRW5GT2dqeExTQWxtU0NYT04xMXhl?=
 =?utf-8?B?SnZSTmxrNzB3YXZVOWFtQUlqeTFIL2lEaEUyRWZPcWhqdzQrM3YvTG9Sc1VJ?=
 =?utf-8?B?bnVFSEExd25OU0xZckRSRk5VOTAwd2ZqblhRODZmN3pBUFF0TEQ2bXVKWnNw?=
 =?utf-8?B?c2Npdk1QM3pBRVF0OGV0em1xUnBiMzlQTWtMNTZ6Q0FoQjNOdHdmTWlhZ0gv?=
 =?utf-8?B?OTVvdVdxYmZpdXoweDdGYTQzNURZb2htRkIzMDlpRzJhZTlpVENucENldm9i?=
 =?utf-8?B?ejBUYVA3WGUxczdhOVdZZEI1a1A1dTQybklDZkI3SHlRZzhzbmNIL2x4MzlO?=
 =?utf-8?B?eklrQXQrZHcraEFJWjRBdDFyekxXenZ6cUhWNFBpT1ZCdUpSd1ZicDAraCs2?=
 =?utf-8?B?eVN1eTVSclZSREg2bkJTWldjSzE0T3ZERndOTTlzTVZlejY1YmQ2VFZSWkp4?=
 =?utf-8?B?MVdQaTJ2a3I3NnJtaDBqejZCT21WRlRUZHl3aTF1cW92c2lBb05kR0NHQnNU?=
 =?utf-8?B?WklRblRMMVBUM3NNVVIySTUrNllyZ1p5bVdqSUpTMHNRQzJVZXZCamNaUWdH?=
 =?utf-8?B?MVJUeDhLQ1J2MjRhRzZFV2RrcHIxUy93TlF6Z1VlRlBPTFdyZFE4bzBWYnNy?=
 =?utf-8?B?dE1pMWhBM012VzlmRFdBZWRKcHJ2MkprY1lmNGoySGNQaFVwMHBNYVdyZXJl?=
 =?utf-8?B?QWc1U1huUW1kdWZYbnVHWksvOFczOVhSWEpWcUoxTGl4K1JRek5uaFg5QjBm?=
 =?utf-8?B?emNkdStSRkdOZCtiVW1rVmhxM2Z4RCsvRkdFRFVzcEl1T1I0N1BsUjZMeEhM?=
 =?utf-8?B?UFNEdGZ6bTl2MExGVmpSNytkckJGcGJSUDQ5VTZ1aXd2OGU1bnpvaVY1YXdn?=
 =?utf-8?B?VVh6emFLN3NlQzMrQXJqNEEybTR2L0tHUUViSXNFU0NBWDNmVFBYSXoraFds?=
 =?utf-8?B?Wjl2UzNEK2pndnhQK3hDV1Fyc3dVbkFoYUlrV0FaWU1zREN2VzdGL01JcDFm?=
 =?utf-8?B?dVlIMnNoeUpJOWJHT3FDbnZJN2FYbmcvdlo5Y2ZlNWhvZWgwQ1EwMGpWWGpi?=
 =?utf-8?B?eEtvSzlBNzBNUHNiNDdJSlZTcm5LZHJ3V2xMUFBON0ZKRWh6cVo0NkdSbUQ3?=
 =?utf-8?B?a3AwSzFUeVZ3YmhjUWZGK28yaWVacXBMVWY2a0pGWHVOVW9YRzFwMXI2L2cw?=
 =?utf-8?B?ZmpsbzFRMXdVd3QxQ2F5cDdsdkxOZTdOQmszcml6UFNTVGlZYm15cVdVTE14?=
 =?utf-8?Q?8yzs0+PQ7zsuOWEhnH2jqEftn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c631651-0623-4656-c6aa-08ddf1999733
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 01:13:33.3501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u7FvqQQMqXsZGKKb5OE80EHxn3ZCixjhmG4Cq3rnzfViMfjbiTLbwr66Z3cxRXbZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9037
X-Rspamd-Queue-Id: 070F140005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 67sipiyiapp3m64ekg7b78s6f5mo1873
X-HE-Tag: 1757639617-203160
X-HE-Meta: U2FsdGVkX18TutoAn+tDmXyUs1EwUyerA8msS9OZ2vsAGYErk3RwCI2vFZCI9Li56M3D8YIXo+0JTdNGqCQxlnicL9f8PcMauIoev81VXtGpuNtglWkMbcK85HuqwaYeijdlhkh93eXAlDD2BaAF4Z2PL9ZO8oIZ9AcvgE4xqmAZgWOdUNMKFgPwamwAnpvKTUIPgAAABOb9ka4vzl1YmlZVzBh0fNHjBMT4mi7fKQ439x+sQHO2BIiCvzI0sGfsa+NZcknltvFHxI7AumL1hg/TUZIORn/80RRX6k7E43uXZra7nhy/c6Y0rOKN255lD9jQYg8PZzoWCB1qVNtCsanUMwomw7jbhieAAigVXZ+AjG7lAAvxvcbr9GkqRpIp+ZGAmYPXczO0gbvl58OxUkBE8ChdgOSHNSs8PGCQgiJ9D0sxVUFXYCwaif+rq465BuqTo7MdjtsgoIu7Y3bJSV5+FbvuRbyclCR4II2S0y3GBlFWgNAYTTiGijEZNyM3idZO149mtnbEWmkCyazyaN2zvmRk005VVO8+a7vH8/JlbHtfExeqaKvcWlOT1qWORW9DSRTxfmoukVOLtjgrJFvl9ehhHKZG/8cK/Fo/rT8eJw8okYWeyFyh/etEuUInQgH4uAH4lc0dyq3K1Tv1YGvk5O3v+4v9UEj/wUndrE5hv35d94IIHaKhOCERe01RmlOC40Q6UKCuBjUo5pm7j1YVK4WbBA9xnfnH0DnKEEro2yBYAu3ORYzjS/HES/hI/5kyXqErLuRecw6CvgxLQGdeu0wTm+22Wskq1NZPp0TQFfhY78dn3h1gPIeqTBUAvNZ41yXKVPXQz8CQK1sFTGR+fFtg0bnohkTFS6Y2cywkeP4PcWEFoVdzQd+aHFHMtM2bgAdcCvWOUXkZ7pwC18RbEFHMqXcycfOctI9fhhSZN4pGb8JojZljO8oGWnQZVOc9foOq4MAyNWx/+TP
 L9Vh8uNq
 BHe29GBnCaJz3hfJgOVOIjk6/nfu46ScjeLPLH2tl0VRqTTqZZ93fUzVofC0gWSC3IuC0GjTqK8rhi3q1xpJ5Ezu2DrbEiw0YoUJHi0u+vbKr3pqnR13cYL241GvyUMDH/n3Oyi0/KDEkTlyo0OG+mBkCUyL1/odwm6Tfke7bNgE4qnkYB+YdPpoe5OzjldgjbVD4exs3R4Qy/YOYGs5doEOwegwXJQrJPVlXU+A7CduaYylM77yUWdSye5DQMOgfW1o3IIH9liJqWfcWoL6M7BYA2JRE4RFRt75/S5VqwIBwiMarmIy3JXuF2xXk7jsCy4nMH0rZryMUJWfv+dzpAMZEKqTT3DJoDy/v2vyWzMtS6pAyuXI5gwPjV8RV5gxeEU1R8U4IVBKRVCgApXMFV9ugD0S7qUkSwISznxkOpSccQ5ym/rvzaW08kcFiWrzOBNPGq1zIISLEaqlILEuEZMAt8g6Bvy3mUOJfZgO+jaKUD45i+mCsCd2r1VzNQv2C4jKut12e+01p3eupAzWTAiHyvwjVO2zKluhavMdbGCBJCmYwuLMDEX81PnCulmeTP6t+XvpHiV3PdSfcye43pzZi7xcEbiGu6aqeyu2fCUreXvu/inPEoAuuF2vOR/o+6zJUvbDB0Y6fDbQo1Zvj0sOTLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2025, at 20:28, Wei Yang wrote:

> On Thu, Sep 11, 2025 at 12:28:24PM -0400, Zi Yan wrote:
>> On 11 Sep 2025, at 2:30, Wei Yang wrote:
>>
>>> On Thu, Sep 11, 2025 at 03:34:13AM +0000, Wei Yang wrote:
>>>> On Wed, Sep 10, 2025 at 09:50:09PM -0400, Zi Yan wrote:
>>>>> On 10 Sep 2025, at 21:38, Zi Yan wrote:
>>>>>
>>>>>> On 10 Sep 2025, at 21:35, Zi Yan wrote:
>>>>>>
>>>>>>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>>>>>>
>>>>>>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>>>>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>>>>>>> isolate_migratepages_block()") converts api from page to folio. B=
ut the
>>>>>>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't=
 point
>>>>>>>>> to head page.
>>>>>>>>>
>>>>>>>>> Originally, if page is a hugetlb tail page, compound_nr() return =
1,
>>>>>>>>> which means low_pfn only advance one in next iteration. After the
>>>>>>>>> change, low_pfn would advance more than the hugetlb range, since
>>>>>>>>> folio_nr_pages() always return total number of the large page. Th=
is
>>>>>>>>> results in skipping some range to isolate and then to migrate.
>>>>>>>>>
>>>>>>>>> The worst case for alloc_contig is it does all the isolation and
>>>>>>>>> migration, but finally find some range is still not isolated. And=
 then
>>>>>>>>> undo all the work and try a new range.
>>>>>>>>>
>>>>>>>>> Advance low_pfn to the end of hugetlb.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in i=
solate_migratepages_block()")
>>>>>
>>>>> This behavior seems to be introduced by commit 369fa227c219 ("mm: mak=
e
>>>>> alloc_contig_range handle free hugetlb pages=E2=80=9D). The related c=
hange is:
>>>>>
>>>>> +               if (PageHuge(page) && cc->alloc_contig) {
>>>>> +                       ret =3D isolate_or_dissolve_huge_page(page);
>>>>> +
>>>>> +                       /*
>>>>> +                        * Fail isolation in case isolate_or_dissolve=
_huge_page()
>>>>> +                        * reports an error. In case of -ENOMEM, abor=
t right away.
>>>>> +                        */
>>>>> +                       if (ret < 0) {
>>>>> +                                /* Do not report -EBUSY down the cha=
in */
>>>>> +                               if (ret =3D=3D -EBUSY)
>>>>> +                                       ret =3D 0;
>>>>> +                               low_pfn +=3D (1UL << compound_order(p=
age)) - 1;
>>>>
>>>> The compound_order(page) return 1 for a tail page.
>>>>
>>>> See below.
>>>>
>>>>> +                               goto isolate_fail;
>>>>> +                       }
>>>>> +
>>>>> +                       /*
>>>>> +                        * Ok, the hugepage was dissolved. Now these =
pages are
>>>>> +                        * Buddy and cannot be re-allocated because t=
hey are
>>>>> +                        * isolated. Fall-through as the check below =
handles
>>>>> +                        * Buddy pages.
>>>>> +                        */
>>>>> +               }
>>>>> +
>>>>>
>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>>>
>>>>>>>> Forgot to cc stable.
>>>>>>>>
>>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>>
>>>>>>> Is there any bug report to justify the backport? Since it is more l=
ikely
>>>>>>> to be a performance issue instead of a correctness issue.
>>>>>>>
>>>>>>>>
>>>>>>>>> ---
>>>>>>>>> mm/compaction.c | 2 +-
>>>>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>>>
>>>>>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>>>>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>>>>>>> --- a/mm/compaction.c
>>>>>>>>> +++ b/mm/compaction.c
>>>>>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_con=
trol *cc, unsigned long low_pfn,
>>>>>>>>> 				 * Hugepage was successfully isolated and placed
>>>>>>>>> 				 * on the cc->migratepages list.
>>>>>>>>> 				 */
>>>>>>>>> -				low_pfn +=3D folio_nr_pages(folio) - 1;
>>>>>>>>> +				low_pfn +=3D folio_nr_pages(folio) - folio_page_idx(folio, p=
age) - 1;
>>>>>>>>
>>>>>>>> One question is why we advance compound_nr() in original version.
>>>>>>>>
>>>>>>>> Yes, there are several places advancing compound_nr(), but it seem=
s to iterate
>>>>>>>> on the same large page and do the same thing and advance 1 again.
>>>>>>>>
>>>>>>>> Not sure which part story I missed.
>>>>>>>
>>>>>>> isolate_migratepages_block() starts from the beginning of a pageblo=
ck.
>>>>>>> How likely the code hit in the middle of a hugetlb?
>>>>>>>
>>>>>>
>>>>>> In addition, there are two other =E2=80=9Clow_pfn +=3D (1UL << order=
) - 1=E2=80=9D
>>>>>> in the if (PageHuge(page)), why not change them too if you think
>>>>>> page can point to the middle of a hugetlb?
>>>>>>
>>>>
>>>> The order here is get from compound_order(page), which is 1 for a tail=
 page.
>>>>
>>>> So it looks right. Maybe I misunderstand it?
>>>
>>> Oops, compound_order(page) returns 0 for tail page.
>>>
>>> What I want to say is low_pfn advance by 1 for tail page. Sorry for the
>>> misleading.
>>
>> OK, that sounds inefficient and inconsistent with your fix.
>>
>> While at it, can you also change two =E2=80=9Clow_pfn +=3D (1UL << order=
) - 1=E2=80=9D to skip
>> the rest of hugetlb?
>>
>
> Sure, glad to.
>
> You prefer do the fix in one patch or have a separate one?

A separate one is better, since these are optimizations, whereas your curre=
nt
patch is a fix.


--
Best Regards,
Yan, Zi


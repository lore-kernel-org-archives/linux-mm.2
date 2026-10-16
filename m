Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF069CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BED6B0088; Thu, 15 Oct 2026 22:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C996B0092; Thu, 15 Oct 2026 22:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A149E6B0095; Thu, 15 Oct 2026 22:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8089D6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:47:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1359A120287
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:47:22 +0000 (UTC)
X-FDA: 85326953124.15.DEFBAF0
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012055.outbound.protection.outlook.com [52.101.53.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C09C180002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:47:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FTqAzh0e;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792118839;
	b=ic5Qrg05G2eJo3rcfSC1p0hUIHMKZin/IqbmaQsWZBHBLSMciv9vOvY76B9h1gz+G1RL1a
	qrKHcCa70y79fluRz1O6vomiaSk/DMo28JdvtlKo2liAupVs+KRTB8WiNy9Z2Zl7b8Twtd
	yv7S5TleSOf4oOnklxAbiI91S/P9Jmc=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FTqAzh0e;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.55 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792118839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gd+wJ8e/raeP/kYrCpqeiQEpUNcMrUpqW5ZvvKS2Rs=;
	b=nh4Kb30E6Q1oTYaHOOCk+oJWLmv7lwlKXss2EmzhDnF0hUUqOfsEqXgrh4gO9OBob3sJAn
	r3U0zY/BJudHEtcBNZu/B4vhN+xAJ+1YEGMKr1Lbog3whpxCXPbdOJxaQ1+RTbraC4/ZLr
	1+nLhL68jqg8KpOIcnTMWjXxSsvWc6U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wrvJ4gwJBxzpqHMBcYTAVgKje9UFfwltAwn18qrULoOevzjXE6Fomu1EXC8NPe9OW36q7fdv81QPaNMdvXmEt21fK6gbeHpeXWHZHvQxG6VPymTnUmBPi/N9t1f5FePmrAugMWs+3g+AxfubMP1EBFTlvJZogBsXqpZOgIz5A3trKP3t9GzGnm2wkwQeQwZclPDBBJot8HJWmcaBgWV1cPhFJC4hAlrepRAxR0RUJmI8bT+B5PH1WIs/kNxGjLdNxZi0Eh3Lu0v+c7VkIilWOYANh8nn0DaFPLHkeW040zKM7RYqlctfZCMcHsXNoZffuwuzxroVE5G7JSb62PXZVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gd+wJ8e/raeP/kYrCpqeiQEpUNcMrUpqW5ZvvKS2Rs=;
 b=DYxhHgmfor7Nt1BKvoqToSGy3NLajuK3DkdeUZ1tHA5qyWME88quBC/sWwwj+2VXJTjYTQufv44KvtoalhIE04YCfZaCFxCNhg+njwR6JBlJAYHqIH33zwEPCN+HlvnDMhCJAmYsFNNkXI/FTBZdxBK3DW7kXYVzfAt0z/JlZ7X+Bl4Y6ivK7eiuSExpzHCym9V4HRN9JTClkn5MGURdrg/+8wQZ6vtOhKI8lDq3L34PsaTBRS4yjr6fGbWrFdfAyIrZdiX1l8vbHoTBf2M/hK7SUgiQlSf8/1XGdxRiXRBAdZ3nSWExofTZsXNJqEbs0cLDpeKtKQJ2ZAE8O5HjUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gd+wJ8e/raeP/kYrCpqeiQEpUNcMrUpqW5ZvvKS2Rs=;
 b=FTqAzh0eoHtfHa84KS84sbt9TpcXbmAjmqfiJGfnp8JSxiXMWmIjweIjT82sFchl7JFjJO0QPldWqRMRUX9Lug2Df+RATTHLCCxcFsR4yEYHbWGCc1hBHePYhetO6UD8+a0i7HJnacQAZvgigrmX8PlOHamg8snrNGhH8t9Ib7Eiez0y8LnFIMes3bfB++x7f1bIl0fbaxYYi3Y9hCrRpc1C7g1XiYNRUQHh6ieBP+oPp6+l8eV9y2blLq0iVubxd2kBRQyayUGLZkLrunMPr5lg5ho6kTH/UNlo0EBTxtLvH+boeiB/X6t3uYbdHyXIlBo5sIv4ks0lD396sbMKAQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7765.namprd12.prod.outlook.com (2603:10b6:8:113::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.23; Fri, 16 Oct
 2026 02:47:10 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Fri, 16 Oct 2026
 02:47:10 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Oct 2026 22:47:09 -0400
Message-Id: <DM5X3STSH0MA.334PCP2CJFVG3@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH for 7.4-rc2+ 7/7] mm/rmap: re-enable discarding lazyfree
 THPs at PMD level
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Zi Yan"
 <ziy@nvidia.com>
To: "David Hildenbrand" <david@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Rik van
 Riel" <riel@surriel.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Jann Horn" <jannh@google.com>, "Kyle Zeng"
 <kylebot@openai.com>, "Andrew Morton" <akpm@linux-foundation.org>
X-Mailer: aerc 0.22.0
References: <20261015-anon_vma_uaf_fix-v1-0-7b977303b42b@nvidia.com>
 <20261015-anon_vma_uaf_fix-v1-7-7b977303b42b@nvidia.com>
In-Reply-To: <20261015-anon_vma_uaf_fix-v1-7-7b977303b42b@nvidia.com>
X-ClientProxiedBy: MN0PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:208:530::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7765:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d5fd1cd-4167-478d-0af9-08df2b2fc698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|7416014|366016|261009223027099003|10067099003|921020|11063799006|4143699003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	002UsCpMs/qgrEUVY16oyLK0ASnAKEH1oIk5RAVnxAMIKXsEhPZy2qbSbqFbA407IFOsBeAiUhIs9Ld9NrglauFgcvMa+wmEr9Etw3/AzONKHpRKrvva5PKtDAY2mJx0C6GdUVLzILkXipLROgcWm8d+rpX1nkYvfWMr44M4/V7LCTxl0bc4EEvs0sSBkfV3lWzRCGl7UkakCchLTZMco1Yo/WJTlpEORQXdYk0lOHT/g7PHdrygXG0p1r+AniKuLLKLiGyqnIb+RP5LEtMXrBh8QFqQupYNvnqKnR7glTpZE5eZofF/G3Hi3CFO4RMSpjv/3vq9xOQhQZsAM6odOfHJ95UpCABTzvC95bN4kTiRTMiWt5vptGcshw6BM/Op8lMoW3lXN834eVaq81YylguCpFjcRFOdKgM8r9nAH6PeJE8wp9qHTPN7awlvNoPu7+Ac2Bjn8OYBMZjTyvjzxMidGy+T2hGDNKq5IGxEs02B/0mdukKsA2s2NtmyqZ3e5Rd1Io8wYlTD8c7t0BpwJpVDE9RQ/CbK0lNGlV3lg2SIg0aolcT5uD9OVhq9zo36hyF2kb6AYdaA+HU9W4t4a5hJVdVXIi9ys+pbr3zUGnhXuhK76e+mKrFQ/cfT96IecI3uccNi3uq6EE1gh/lvUM7zaTpBKUp9ISl2Ufj0+wQqfAPxqSTNwXkiE7cCnpQadgUzeHxO+jVTdjaNaS+uRA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(7416014)(366016)(261009223027099003)(10067099003)(921020)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WE4zaXFONWpkY1ZwYlN0ZlVmT21yTWh1Zmo5bEdaNndXbGJuMkpEWHJGSmJB?=
 =?utf-8?B?RVdCelM5N1liMitaZ0VvV0diVWM3TWVmeUlPMVNTQTU1TTZiM1ZpNjlaTVpm?=
 =?utf-8?B?NVl1amw1QkRyQXQ0SEFqcTFRWFloeXE4cWR2a2o0dlkvWk5kZmFHOG5XTzhW?=
 =?utf-8?B?UGhOVEFaNnNUQ3BpYzhQaVRndFFIV2VxYVFsVTVSN0FDWlh5OC9KS0ZPZXd4?=
 =?utf-8?B?djUxZWxRQnVzZDFqNmF2N2FRMzQ0N2lCMVFOc2lQVUdMOVFYUmZwdWlyNTly?=
 =?utf-8?B?MDlSM0RJRUUzeURvMnZqRXhzWWx5VERUd1JhRVZTTkFVTnlRMEY2ZU9hZmZT?=
 =?utf-8?B?MVVGT1VYMDZNWHduWm5POFp3MVBKRkNUczl6Z29tTkxXOFlhREJWWklKdkg3?=
 =?utf-8?B?ZmE2MDY0OWQ1YzdZVTVQNndZeTFVd0NFZXNQdnRTT09oSzN6WXpwQnppb0Zs?=
 =?utf-8?B?ZHZ1NjVWdXZTcFpVU3pTRzh3bklQV3lLUCtSTytyRkh2cWZYNEVrTk14eGF3?=
 =?utf-8?B?MFRTVU8vWUVVQUFoNjg1U01ycHRXbEdrak1Od0NCUVRTekRiUjY2bjRLczB1?=
 =?utf-8?B?QlkvclZDVlltSWFuSXdUQ1dPWjk2WGp3WGpWcGd6Y1pCeW1PSXZ3UzJnbGlp?=
 =?utf-8?B?OEMwVFpZbnBNdzNGcDNrTXE3RS9INE1PWlN5NzhaS0FOWWJIQkRNbGVZaHp2?=
 =?utf-8?B?ZmIydGROWHUzZWRkMHRDaGQ0bzgvT2FTNHAvcXZWemZpS3VzK2RzUGdDakVT?=
 =?utf-8?B?T2U0bnJMQk1MVWJnMER0Qm8rR1BoSWwwZGs0VXRlSThmRW5ramUvK0Ntbytz?=
 =?utf-8?B?UllpWVVaWmhFd1VpaG5YS1B0dmU0QlBjR052QlJ0RnZEQXBBNWtMbjFEbyto?=
 =?utf-8?B?Mm5rM04vQmo2SFpiN0NtcHBvaWNPQUhjUjU5K2t2dm5JcGpCNVBHSVIvYmls?=
 =?utf-8?B?V0NLOGcxdnppL29oQ2JyK2pZMXpTLzAwdmdUSHFjMUtsTU5iQ3N1WEJDVWdy?=
 =?utf-8?B?TytlOWFoL2h5V1N4b012VnNVKy9IeDRUdTV3blVwZEYxbWtHZjlZNnZJYWZ3?=
 =?utf-8?B?enNGNHUwWWVLRUU1UDR2eGd5T3JYZmhFYVhjTEhUckNIVnIxUkNwNGtnTkJx?=
 =?utf-8?B?b2RTTlRQTU4yOUcxUjFSMUExSkxUYUVsWkE5aS91ZitiaThBekUrM1pNVkxv?=
 =?utf-8?B?RTRPZVhyd1RCNHZlQWMzQWJtb3ovQ04yMldVckk1UTdaa3JTT083NElEMjQz?=
 =?utf-8?B?cnNYb3dJZmI5MzZoMGdWQjJYcGtXVHk1MTRFdEFIRzNRaTIxaDlSNnhNWUNJ?=
 =?utf-8?B?cDBCYXV6MW5RRUNINm5COTVnTlFSM2NpZW1RbzhtZ2FpNnU4WjA1a2tGSysy?=
 =?utf-8?B?SzN5Y1IzRXJjL0FvRTRidGsvQ0pCUzhacEpncE9ZQ2F3Tm5DMjA2YWpYMmlv?=
 =?utf-8?B?MDhiWnk2VG8wcjFRaUpBNGEzRGwycDY2MXJ4THZnOWRVQWFDZlNCakZKd2VB?=
 =?utf-8?B?dkQ5K1UyeG11dXJabExIcUpuSWJ5NWNuWlBMc3ZVN0lZd3NWaHB5L1RqVkll?=
 =?utf-8?B?QXErVHIzMU5aUi93c3MwNlNRL0Y3ZnlNK1I4S1hkVzRXQ2FpeTdRcWlXb1lE?=
 =?utf-8?B?dEJRYUFuZFhEQmk0WmlsY1NDcnc0czR1a01KVkRGbkNIUHl1dTJPMU5pQnhj?=
 =?utf-8?B?TlFIQjd6eGh2a2dvWFp1dzZKNnRtYXFwRWdXdVFPV0RSeERBNWpCd2E2bDg3?=
 =?utf-8?B?TS9jSlJ6MW0xRzhEcEFQMENqY0llUnN6eFIyS3RpVi9HZ2grWmQydkNOU2Fv?=
 =?utf-8?B?Q3cwTStJUTVZekxIbzdGd0VkOFo2dVJ2L2dUanZQdTNKb0NRa1ZtUTc0OTJJ?=
 =?utf-8?B?akpQNjVPTGc3NXAwTktpUlpwSkxIYWppQzVzY3RHL0cyUFBLN3Z6Z0ZEYWZV?=
 =?utf-8?B?L3M3TGhQdWNMU3RzTmpId0RXY1c3cHVpTXpUYWp4Q3ZsbjFlcnZMKzh3QlpI?=
 =?utf-8?B?NGQ2V2hTYk9aaDBvNmI0alNqbW1RNnJQWEhBMHJEcERCUHEzSFo3RFdONDJy?=
 =?utf-8?B?cnQwVHpmSU1pQkcvV2RxR1VWd2cwNG53OStObjlld0JrNlhSd1JZZVRoakkr?=
 =?utf-8?B?cCs0c296dUhZTUNoWkd3Nm82RTE0cWJPSVVmNjU4YmhwemFOQ1Z4d3Z3bDZw?=
 =?utf-8?B?WEdNSHVzdHc4MzAzSXFsKzBYWkxodWVTaWh6alVtY3p1alpKcmNQSW1CTUtL?=
 =?utf-8?B?dkxIcGQyR3EzdjJXTjZOYTl3b1lqMnFOYldlUDBUN1dSTkQ1NHZyb1RpRkp1?=
 =?utf-8?Q?iSu8CsbvG/GHV6H6x3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d5fd1cd-4167-478d-0af9-08df2b2fc698
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 02:47:10.6055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qNR9uwq7DVmd9VWb5T9OynntOwX4BB2VlAUBagEiLPKimOKhng3ftJicr04irULi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7765
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2C09C180002
X-Stat-Signature: hj46t6w9thnzaeynwq4zbf1ie4g7xgee
X-HE-Tag: 1792118839-950016
X-HE-Meta: U2FsdGVkX1+o8Rw0cwkzfZeuR4rSWS9XEInut0H7+5GoBofZS4vQzea4VBAF6F/Xv1/milkOJ81n8RmY/K63JuPySmp0anwrB6XqozkNlPHFagusgb4NMb2y/Zuwtd56OLeKzgNRVZDFjWnFK9kBXXUDy4okuvv5+8yLTfA1REJUXuhyVKYXxJXOaUtRsw2c66x3t7sfHtx56EUc2FpZZD8Y7jrst678hK0P8dXgkrO5npPyaLGOMz1RyhK2OOA8w6HjRG+GhPuTx3nMtyUldz//Z1hU1irmsav1wDJP0uv92iNd9S/xCsJ0yDooo4BKqaPJdszeIhkGT1X4RkzSjXl8pQfMZsytgIjytom51pICSDUvMpjUoezpCyNNsKLOJxqFgcNS3klTYfktISHoA5uo03zYiZFVX6h211rm0nbt0qqxKDzy1FluHdaPP4Gi5mL4tPEIRSuWIU/oVOoSPYNdngNFDVVRO76t+GzoOuhkfjsp4XH8mIpvjSYHFl6hpe4cYRvg535vn+q/1iUt2qKkgBXCPTJ89IHbQcDZgdpRDLKUwn2JP2QxM846SAg7JrbTRS3tx4B/YY9tL6lHzbtFuLRpfGZYLMu2VhAsaD4WPkr02gJZg9qZpiPchjlMuloiq15GhdvNcV7NA56+zmbVvRwJm2tXLcue4/HerBF13OjfxQFpYLHqxF7M73XprdXHcR+8bXMjmwAA8nFKhx8ih7G0ggkzecwNdGcoj7vuLxn9RXdkVliDcNLZ+L0S4xlasvdhRwvIl4PgOyju6mIg+j5r1QKXDdyT6QOIibrMKHEo2luDxpS5usF12xk9kIrYAF2yuflYjsY2Pyxs2xKTySzI0Qov4PRaZlDm+qgohf7sM6lb3QauzIDGHUlZGtgHKuWgSbCszutkjrAas0chWzaXjdjzk9XzIdb07fbBTMYETeWSm97lQuUiJ1BoIjH5Uzc5tmLkDfvWMUm
 6HYpb9vp
 hrdnX9Xjp3WWUW6Y3SkJclafFvaTkWVntqQHgm+tI6yB7Cfs6mrccaBg1KbOoNTf3Du2sr79ry0uok8xBBRINwKy8KCKpsAIrObjBqGXF7Ni2Ey/uxnEfDrv5lHtXSGHV/fCkWilO19enBLbG1WC+BYAWG9vPy3JkIoLtk6ZYDV0nRC3TmEY8VSVP71ukTe13cEfiv2Ce/scJ576UBvbOppvGXvsVu1IR5GKtVIpfsG+BvsUNgG9FellwIubImTu7zoGDswwJA5KOU4AQpBAFON2SWR7W4s10u4KbtCu8vyhXSUP1VqwsncJg9kOx2mRCgQQttxVvLiqtYU6WoZ4niz598rBeAvMCsu8uGIxN1fURLkfNAg9G1BvUPRsX8CMRgwRYh2B9TmeMlzNf+u5CICUiW/wj0nm8cvMulHain1gFxSICT9b9RwRhuyTmfrxfbqEZ701MX0XFbfs4dYtDZ/L77N1aeEo4DoR8OPgskB6/vez0k4JqZMPE36VsZQFGWG0MQZ0L8hVVxh1xTipRGgcSO77sE1Syh2QHbiH315LlG0d0I0qh+mbV2SGMKemc3ZXPtirknSeLcynn8uWhicEhYHor/BVz7nmp71mbzGR9/wR03s/oTT7CyxilYfzy4Bw7NwLZJVItaYygpf8hF/AGNLPo9Afcv4EohMVmPH+BQBXiT83KHwGDqPos8t3/57lTTvIszoMECFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Oct 15, 2026 at 2:13 PM EDT, Zi Yan wrote:
> The patch "mm/rmap: don't discard lazyfree THPs at PMD level" disabled
> the PMD-level discard, because it cleared the PMD before checking whether
> the folio could be discarded, and munmap() or mremap() could skip that
> transiently none PMD.
>
> __discard_anon_folio_pmd_locked() now keeps the PMD invalidated, not
> cleared, until the discard is committed, GUP-fast no longer follows an
> invalidated PMD on any architecture, powerpc page table check no longer
> counts an invalidated PMD as mapped, and sparc64 keeps thp_pte_count
> balanced when an invalidated PMD is set again or cleared. Discard lazyfre=
e
> THPs at PMD level again.
>
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Rik van Riel <riel@surriel.com>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Harry Yoo <harry@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Kyle Zeng <kylebot@openai.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/rmap.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1131b76bbbc28..805db93fe0428 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2275,6 +2275,17 @@ static bool try_to_unmap_one(struct folio *folio, =
struct vm_area_struct *vma,
>  		}
> =20
>  		if (!pvmw.pte) {
> +			if (folio_test_lazyfree(folio)) {
> +				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))

Sashiko mentioned that unmap_huge_pmd_locked() does add_mm_counter()
without calling update_hiwater_rss() first so that peak RSS can be
under-reported.

Answer:

yes, I fixed it locally by calling update_hiwater_rss() before
unmap_huge_pmd_locked().

> +					goto walk_done;
> +				/*
> +				 * unmap_huge_pmd_locked has either already marked
> +				 * the folio as swap-backed or decided to retain it
> +				 * due to GUP or speculative references.
> +				 */
> +				goto walk_abort;
> +			}
> +
>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>  				/*
>  				 * We temporarily have to drop the PTL and




--=20
Best Regards,
Yan, Zi



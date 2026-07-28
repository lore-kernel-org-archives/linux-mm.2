Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE26BC531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 02:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015216B007B; Mon, 27 Jul 2026 22:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F084E6B0088; Mon, 27 Jul 2026 22:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFD76B008A; Mon, 27 Jul 2026 22:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 998916B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:40:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D869212028E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:40:58 +0000 (UTC)
X-FDA: 85036632996.07.44CBA6B
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012018.outbound.protection.outlook.com [52.101.43.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id ED79140005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 02:40:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bEO1VTkq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.43.18 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785206456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7F5LaWlObFue62tg2JRyZ8hTZ+XvMIdJX+IGVrEIE0=;
	b=EUreaJ3m3boqmGLK/Rf3gqra9Irp+YMj7V1Lj6YWdGhbgzseSJ637WHx3+MZttw+ss/6y1
	SFBRxY8OKji8DUkGYC9rPRdfY4A7fvxpohSmqozF2OBAHoNv57XlpSG8JO0VXS1dHUffVD
	gzKc9LM+PE/kkDZYvl8pJaRBNnEF5mM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bEO1VTkq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of jhubbard@nvidia.com designates 52.101.43.18 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785206456;
	b=BkAZCNI1avTIx78TApWIR+YylxG+0S7h3QiXvn+/z0d7WCjprhB9Mfk45JruCrpHaVV7IM
	k/DfoIIsPyWjSfo2pOZlKvXiUUpr289nLAN/zzh2LjA2o9shJVm8hB1fZRil3oOopEFDKg
	NyXabqL/oxBNEOISdiEFYLeyg7dGPNc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KrQwz4Tww8394ZbxqfwXJdg8WA7jJNFc6UrlYnktu+0Br6/2Q3pKnmNHwrMyhaO4iH9tWvh/AdmuQExpbKF7rGDYzddYGGJpMUhrhggu1BZYLzLFRLEURiZCtKopaKcwxp795Di/CvOobJnf4b+g/IxSULMyyMN0LT/9WtHLXtjk+gsrLlCRBCemZIqNOF/reucJgubUPGaq6nl59tl7lefqc9e4YmLKz2iA1Y6wg0821d2cjvzPhJXqSOeF6bqrwFJiVzk5PBVAFg1htU8658BzdCASyUr4Ir9cBHGIu5PEi05XmbOaQjbsM0Z7pWEklVOiY9PvYjSKDnIB2pPUlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7F5LaWlObFue62tg2JRyZ8hTZ+XvMIdJX+IGVrEIE0=;
 b=rqlC+k2gIFldHOrsZqmIjb/pJSI0IaXYNJvFXefaB4DUFnN6q2v+0pp4DUSSs3VniOfOrfuEbfcPJg4kBEimmJr2cf+O1Zhet99EhlVJNOk47F0Wz7Cqkk2XasH4/iO44NwGcgp9M7AESLb47sdyV3QIBuOYRTCoHvecEunhW/6ZLmie7iGUHzrPVgOxPFChZcJPYMoQi2D5ECmg0UkjGiNAUwbBH0C7xJ6bqekv2Bog0nPoAxvrCsdx3sB2D9zzQxW024UajuHrifQHP9/M7Lrih+uuU1xVtLxFlRhJgsDN2fJ9sxW4HvCoqP68aHu8Rm341RBO+eMuWnn4KJth0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7F5LaWlObFue62tg2JRyZ8hTZ+XvMIdJX+IGVrEIE0=;
 b=bEO1VTkqEOhaSXI1jwXStny2pAQ+vcjs/wd/+ru3e6EBtxIeXxPNBS1xFwwKIfz7uT7QnX+VZxHBK1vGXrZ0eb6JQ2SmrZkZvFXvm6gWU444HJrJ7k4s+c+ybCAbOsqSV9AOe+nyDYhfBi5s0YOovpYeRTH1rtY84jxmkJy9dtXZ9GT98M6TMqbE0qaIw5CdduydB/YF54rLjg5JFGiB3wYn+Gm/v1I3QTsQfzz4kTHR4SKD/BSakBFENF0RBL1hp1+68Tg9Xta79/UCwh2wwzAJjp4fCgV/QBQDtVBf4R9lhwKTgWuGi4/0cbz3zEhkoH7YEKHwNB8Z+9l7mXCmgg==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 SA1PR12MB999083.namprd12.prod.outlook.com (2603:10b6:806:49e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 02:40:52 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%4]) with mapi id 15.21.0245.012; Tue, 28 Jul 2026
 02:40:52 +0000
Message-ID: <510410af-dfb6-403a-a864-50afdeceb896@nvidia.com>
Date: Mon, 27 Jul 2026 19:40:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4 04/12] mm/gup: let check_vma_flags() ignore
 selected VMA flags
To: Rik van Riel <riel@surriel.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>
References: <20260724222934.1463812-1-riel@surriel.com>
 <20260724222934.1463812-5-riel@surriel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20260724222934.1463812-5-riel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::17) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|SA1PR12MB999083:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e083249-f01b-4ffe-0f54-08deec51a41b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|18002099003|22082099003|10067099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	0gI/ZxOEufYv9QEhVskCQUBnsv7fL8umbuYNXd6wWD/RUuKEEo/93QqCWCA5I4QQgM2t/4S8nZwHEUi2lWLXJyGly/FHN5xd0wtA9zlFD5yaJsmlAfxD1qcbQxW+ZGNkyzkVbEjFNmInq6w9YQ3iJE7nudLK6EYsdaxEEhmPu9hCGjihclPHpUQwamwuJXeubnsJdTJ4SjyokUiIlv4faO2NAQOjaSddsZ8ti10p17h103HQlZpfERk08JeBAwv16YvTIkgA0UtwOyD0y+Z7mwmmCYGp5JQoPxsA6jxGHX5l+SG9NnWAi/HZeaX7gfI4owt0qHFY0aoR4qC04dw2Y9O5RR1Fylx0uCpBycKelF3ewdo/e9wM5Q4aCOK82LNvGqXKf79opA6K00aVgPQ14jBdrzdZ8/xDhSoe8MHa5ZZZEpEgEkLPmAb4DtIZY71HZngcRPAKJRi1C7mL/av9fFoHq4eHaS7TUYzUGfJQUz2jaeIVg79eL9FTxSMQbBrsVqkRPHzfAOE8hOrWUhPcL+6Wlb6gIeg8w0X4cySHq0xVk15nv221m1/1qwNkk+4EmewbPAH5qJxfdYRLyFCNOzszNHEGgFHvxyvRFhat7MIGsCpyJpXw4lHnCzZrEZ321trfETDVgxmMKNCCAMNExTtetZre0bgWDxUttOwiG7U=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDJLYytFTUd2eHhqaTUvTGJMeU5id1pMWDhrVGpucG1tNFVSVm1JR24vcUJX?=
 =?utf-8?B?aTdTTDRlNGY2Wm9qTFNybVBnWE9DYWFUY1l2TTI3dldoMXRhZlQvTGZQY2pF?=
 =?utf-8?B?QUYzdEJaZzd3M01WR0pERkwrcTdUbkNwaGFwQWc0MjJHT1pnZVlJTWNIUzBT?=
 =?utf-8?B?REExNXl6UjN4UGQyNkQ1RTQvRzRId2czS1dpTDN4UVhsdG1TSy9DbitzMUdU?=
 =?utf-8?B?bWo3ZUpyMVdRb0htbytjNU1zTENiUVk5MmVYMnpxYmY3UTYvYnovbUlmTGJP?=
 =?utf-8?B?akMyRXJmNmFPTUhmYTdRakQwZ2VyU0NCVWpKRGV6YkIyK3lITmpGRjA5Njl4?=
 =?utf-8?B?dVlNKzN5N0dFVHpQZ0FZODRxWGg0c0dJQmpHZEJKWFAzOFB0cThrMDRtZFZR?=
 =?utf-8?B?ajRXRko1Ym81aW5xWWVMOVhPeW94anBHdnZWQWZDTnpkY2hYeXpQNWxUaXMy?=
 =?utf-8?B?UmtLYlNBMjBYUllla3hSQStDbXZGNUN4dHE4bC9Lcm1tTEZnVnFPRjArNUIv?=
 =?utf-8?B?QmhzZmJiaGQ2TndnNzZwMFpxRDEyMDczOFgreXFGR3I1UStuQkEvWHg2M09Z?=
 =?utf-8?B?czY0MGNtMDBaa3cwb3lRdWxPMlduZGxFbWx1dDNyMC9yM3VSTDI0WFFEajhB?=
 =?utf-8?B?Y2Y1VGpHRVhVZTFQMG42VzV2RmJaU3oxWVRpekx4d0ZYb2NqUy95UmJtN0sx?=
 =?utf-8?B?ZWt1QkxTQlpuOGx6elVRTVJtVEJscTlaN09FTVFNYkg5YW1uQnhrYVI1VFVI?=
 =?utf-8?B?RFp4dHZZdHdIM1cybC9UMWNtaFJqWTgxYzd0dlFaU1ZWb1dLWDZKUW1LeTEy?=
 =?utf-8?B?S2hlNEJjM3JzNjJndEJPRVJGQnRWSFJuS1dsUDJ4Z2pDcDRHdCtINDFVd0Np?=
 =?utf-8?B?RFpwVVJ4b2tkS2JHVTFkbFIzbmZIZmhzZU5kUEwzQzErcGQwamhIZE1RMWpp?=
 =?utf-8?B?a3dkRGxmNXdkekQwWEh6SW9yNlhrcXJiUStlb0Y5RHJ2WDZCUEhDaE1XdmVS?=
 =?utf-8?B?UzVGa2t4QmRRVXNOcW1iWFJybm9pakpHWjlySmlxUTUzVU5KcHU4VnJPWUVo?=
 =?utf-8?B?aUxqNkRLMnhoTXE4MUZTUFN2Q0dYcVhEQlJOdGZXVk5WaE1ObHpELzI4d0dP?=
 =?utf-8?B?bTRlclV4QkNmZUg3R0RreHVoZTNMTlBnbFRNQVJJU3AzV01TeTh5WWNIWk96?=
 =?utf-8?B?am9taVFtREpONXJzZWV1V1VSNFVPTFZicVBiUE1hMVFyRXRaeTNFQjhJKzVy?=
 =?utf-8?B?a3JlZHdHWWV5YTduVjdNUVZtd3FRNlhJWklpWWF3bnpENTdnU08wT1JkSXZs?=
 =?utf-8?B?clpLT1hwRmcwRDhxRGhmc1dGMit5a0JIdlZiQTZoNmp4UmlCR0lnWWpnVm5q?=
 =?utf-8?B?d3RrcUVtd3RmUUN5R0ExdEV1bVlIZFVFWlBkRnE4ZEdwdHlMRHdHeUQ3Z3h2?=
 =?utf-8?B?M1JCVnFSRjdWN1NxM3BURjc1a05JY0tTSDU2TmQySWw2MVpBRTAxZW5HcDhT?=
 =?utf-8?B?Y1JNcXpMbVkrMG02L2liMDJ0Zmh6dEhXaDRLaTRGMTN1TmV4bFhOSDdybTRt?=
 =?utf-8?B?NFdZMitXTWIrbTQ0L09McFd1Ym1LM1pqUGt5SU5taFZkVmN2UUt4cmVSQnNT?=
 =?utf-8?B?ZThlWGxPQ3FEbXdxZkJ3cTh4VWxuOEJqWGpSUUU2YkZMR0ZENGw5ZStUT0Vn?=
 =?utf-8?B?eHB1YmVsNjFCYjhhZWtTY3JpUnZiUUVNZVhlc0pCUEJiaDlQKzZMZHpOM2Jw?=
 =?utf-8?B?QUFjdldRd1l0RTZCcFI0UGR2SnVpeFVpWWQ2RkMveFIrOU9UcWphSHlKSGhs?=
 =?utf-8?B?bjJVQisvKzRuZ04vR3pXTFprSnN6VEl0b3h5U09HN0cwbEcxU2Z6NkxkM3hE?=
 =?utf-8?B?azVQMll2OXZnbXF4Z3hzVDVTNFQwNVJ3VzZva0h2YUlIcnZudEs3NnNmZjZ4?=
 =?utf-8?B?WG1BYTQvN0hqa2VRMFNSdFpLWTF0ZllrOTNRS0ZTUUxQTDRvak43SC9zTG9s?=
 =?utf-8?B?VTFWcEo2QTByQjBCUkJSd0hBeFVNczdwL2t3ZlF0Y0NPWklPeU94aVkwTHJE?=
 =?utf-8?B?K1VXZm1UaXA3SjJ3NGpJeWt3K21peUZSVzl4dlh2VVlMenBjd3RWK0twR0xx?=
 =?utf-8?B?M05xUDY2RFlHeFNQSmlkZWd3QWd1dVhsSXIzdUJnL0kxTHBEeGZEK1NNQmdM?=
 =?utf-8?B?dy9Qamp2dTRtbmNlR1Y5ZW9HM0g1eXdqSTdObVBxVzhCWUx0THcxcFdSMXU2?=
 =?utf-8?B?MlgxVjdFOXBROVQ4alFYYmUxMC9HZjllL25PNlV6Y1dQelVMaUVha2ZVTkFr?=
 =?utf-8?B?eG03cG00UU9OVlA5azhIb1JIVlp4dEJnTWs2UEI0dGVZcmJRdEtGUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e083249-f01b-4ffe-0f54-08deec51a41b
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 02:40:52.4411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBhuDoPIKg8VlI/Knaw+1+t4ATaA4o2kzvC2HSOW48nVjPVMynWPFYBB3tEDcKnrE42kg4Csfe98uvAPRC55rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB999083
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ED79140005
X-Stat-Signature: nuce8itxdudo53btpng53n8f6omisow6
X-HE-Tag: 1785206455-611937
X-HE-Meta: U2FsdGVkX18eEMfX1lyPe0HiVxPZmPgxPnfDhBFOwcw2nthDeNesxf/uws7ed/QIAXs9Tx4TV1+Mpv4V5wi2ZJtA6LfeafVfgpRzWM/tcrewLIazqhf5if4fKZmBoTDNXCQosrhOxgO4IrmuWrzP63fKjIvrrMdP/MH9PwGfirKdJlYS8GVk4cDzZvRazINu9n7mc7bROM3Hsn16nAwHLihJBmL78XkYq96KmtKYzSWyZi69HNsz6gw85WH3RcW2ireMG65GUCJffLvq+0bhQFIjgFV44HG2jNJtEj0LHX3mcmrvLAi3GKo/XZ4LzoVvI/585KKlxoRtua+mJtc28aBzEtAB13cAlVTa6DJ8/ZbRKsq//76a5C7bLPnUFO3r1vHMT1nZ59M/WTZS7iQWK1Zy8GF+0luhdGk1gBIugJlaVqcscapf4xllZN1V6h7hlAvFQo3QHoBkd8cEI+pPvhEuDw+hR9SfYsVlMmQPRREb69xwMBxpWIALVq/fRGkvkj/3D1Z4qCus0LleFtJTrXsjELOIGBFI5h8YVAWN3pqSwaR4hhypSb4D+CX/wXskIPhmGYUL3io87nuM0cJXxbWi4KRQAlspIrrywNjWQzGLcgKpUFBMm7xa0FGl8qMTYTzlGLD7+o7q+6kCcAfiX+BIQxxvnL9TIU7Oll8WB8dF/qkjp0x6+STr4BMWOHQy8NODkM1rDXSSCLantK6pvT9t3Zo6PSZssoaqI6rfN09sRox0FjG2vcqUzDWt1XuI4wB0Yvyr3BV6Xyu7lhvwWJxuIFzEqgB/CmQJdvmVlDG66NPUe6MF84oO4qlg9zNtxoq/1TFyt5pxqgLoUR60ZctLdEZfFows890STUa7fFnHuuBUwra1Ih6n5gITm0/r+Q9JbiVlHyVInkAtN1DMVKu3tv8/kCstdLn3D4CMfPdJ8E9pNLVJ49+h34+/z262WE7tTrhDS24rvzmHuYo
 y5gOICn/
 TgfTxR2GRWtXYiwfhLQCyBuOsUoy+E66xLKAzkumHmSofqC6kjVED2Jbvj4Flm2mFuvtK8Pf/9Ipe61lD5+GsxQygiZcHtRGn79vJhAEkCgXlWe20Cu9BAIemk2n35VG6c1wpaKQj2mfW6DLnyNF6vKV4Wtyl7UqnwVWs60dnxwayknAAbReZwLx+hkijQd+TyWqKvCFyIZx345IoTADnUHkzWOAfK+v4jT5pIrKPbCuM7PrrejNC7nHInEgPd9BajOwSCKz7f2ObJIHcP7FnJ5AVQvfNWOfhcTr+uKZxbMpqaaXA2NvLUJP7sUxwD1LEIwZ2LEutl88xeBeYk+ggP5uLBrXjp7mxGGLPmMPjMTBHBQuaIUiYV4q+XtGSvwLBv6YrrKwL3e4BUi48V1c6mnQ16gkFOHaE1S2Tww2TcEPb0V/g27/MCE53UdIHaIIr6oWUME5VpsZy8InEoqFJ9TXmLyfYw6A829Xl38g4NCutka1jBoxVqVvfKNeBymPAue6r8kQ6o0kQhbU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 3:29 PM, Rik van Riel wrote:
> check_vma_flags() rejects a VMA whose flags gup cannot handle. A caller
> that wants to reach a COWed page in a VM_IO or VM_PFNMAP VMA, where that
> page does have a struct page, cannot express the exception and has to
> repeat the flag test itself.
> 
> Add an ignore_flags argument that check_vma_flags() clears from its local
> copy of vma->vm_flags before the flag checks. A caller can drop a single
> rejection this way while keeping every other check. All current callers
> pass 0.
> 
> This prepares for get_user_page_vma(), which passes VM_IO | VM_PFNMAP to
> reach those COWed pages.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4.8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 0692119b7904..dcece7b5253c 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1197,13 +1197,21 @@ static bool writable_file_mapping_allowed(struct vm_area_struct *vma,
>  	return !vma_needs_dirty_tracking(vma);
>  }
>  
> -static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
> +static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags,
> +			   vm_flags_t ignore_flags)

All callers pass zero in this patch, so there is no behavior change yet.
The problem is the interface being added.

The same local vm_flags value is used for the VM_IO/VM_PFNMAP gate,
VM_WRITE, VM_SHADOW_STACK, VM_READ, VM_MAYREAD, and is_cow_mapping().

An arbitrary mask can therefore alter permission, shadow-stack, and COW
validation. For example, masking VM_SHARED changes the result of
is_cow_mapping(), while masking VM_SHADOW_STACK removes its write
rejection. Checks implemented through helpers still read the original
vma->vm_flags, so the meaning of ignore_flags also depends on how each
check happens to be implemented.

Perhaps it is best to replace the mask with a single-purpose internal
GUP flag, such as FOLL_PFNMAP_COW, and apply it only to the
special-mapping gate:

	if (vm_flags & (VM_IO | VM_PFNMAP) &&
	    (!(gup_flags & FOLL_PFNMAP_COW) ||
	     !(vm_flags & VM_PFNMAP)))
		return -EFAULT;

This permits the later caller to examine a VM_PFNMAP mapping while
keeping VM_IO-only mappings and every other VMA check unchanged.



thanks,
-- 
John Hubbard



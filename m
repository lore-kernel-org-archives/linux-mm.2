Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BB7DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D433D6B00A8; Mon, 29 Jun 2026 21:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A5B6B00A9; Mon, 29 Jun 2026 21:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1FE6B00AB; Mon, 29 Jun 2026 21:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80C166B00A8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:37:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE33940322
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:37:56 +0000 (UTC)
X-FDA: 84934867752.29.45CC58F
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011065.outbound.protection.outlook.com [40.93.194.65])
	by imf09.hostedemail.com (Postfix) with ESMTP id 27377140005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:37:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VJrxZ5gR;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782783474;
	b=LbB9xn3995FA8meqjVgRmkUNLlojE+auIyrcYpRpE3OlUfizpSY71qsZlkidaWJ8OWOvzV
	J3Gkt/L62pTpmKGrZTlc1XjWSkoCwUAoerR5YSnOvrd96jzIx200ZGux308Gk6d5+nL3oa
	oXQI0mQ3G7f10ZmOt/wUojb+/4+/dd4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782783474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zEkb3K909qffGzuYTogtFYdizurjMEgRvboLUKmH3Eo=;
	b=ZgxEMoIO9t0L8MKFoUIDbGNFRlBBM3USjv9hjjzyYdF4Opx4+TXOjwZz8IvUvcKKidwNwl
	eEFiSXKq8fCm5MKXZrkl9VnyHeujzsS8zErpr5NX10pEN4muE3vOaECvcD/0TQkgXMZGX1
	HVuXmgMUnCKJD5eB/vMcxYhEdJxp0ZM=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VJrxZ5gR;
	spf=pass (imf09.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qUhZfmf6KsHSbZ+6c+r4NJiu4xqjE9T2U7rK+ppLYPjoO7v2Xu7vviH+kEopgj4p1LLi3AKQIJievtbccB0kA3/NvULyx4yAvGMRzWm2MA+2I01moE0uAkF2r15n6cSZje2XN1N+2M1BXIvlMm5dtZ03eyXRFSa8vD+tqQTMzy2ZwrHVwngTS6Khdy5CGDxr4mm5l6ZZ1o8KijlbedrhVZTPQ3woZFktl7kaksCyR8lNbCFmfbst7ll95EcCfXl38hD9189javzFp4warUIUpiHO/OtpaRBIg6crtaLWz3MBqE6Rt5EgFNM/xEPZ3D6QmRLRz/u0MknRx/FCNk1Ykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEkb3K909qffGzuYTogtFYdizurjMEgRvboLUKmH3Eo=;
 b=UrW+jizb2aT3CKGyAsU0E1o+97aSnKTlyZUADTIKN3oQyDWc/TyB9dx9wt/LTcwOLx5PujFo4YjjgH57KdDYidJcrDNWDpyQHbLvnhQ3vJzrAkoUZLPJLasce/jLJU1O8WXudDWs85h/Yf3JFiHnEypxJwyA0yaC7j7RgvEt/XhFre8fDRAhTgtbrVfmdXCz/w/M/zI4xdO8ajJYTxO21h0e+bgbVx9L0RshCd6jsc4cqxZo7HwgH8z1hIP2cF469HEQ+cR+29Irb24nyn1rDCPRFQr9E6VQoGKTPEXQ/wSI1HUQhWqn3MkQPozKM2a3SrzPe4c77dJIV9l1S9dXOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEkb3K909qffGzuYTogtFYdizurjMEgRvboLUKmH3Eo=;
 b=VJrxZ5gRa8e/3ShT5fIosRajxGP5dugRqk8MZnmw9r6dmep+YxG+5NfBvLr98yF8OnmP2BnUAhMREyFZXx+e0StnFbKHThfeH1af0hl2OXoIcotVe/MePL5J4aX8PKGfeXAO9Dk39Fx6fLHwoi2pqPO4XI6UfyDWtaZeOefNHCvPZ19/LmdnQVNP81CvzGRCgSEF4Fnp9Nroi7Qz5Nx9zMgXeIBT4dtVXaONNMo/i8TLMUJv88CzKJmqd+YSDPyENTkzC/9h0gHSjfh59vdgZYyztvw9et/z9UfPIJt9pvCMl8enqr/xkWNzZetlx9uaqJYVrGF6JcCQL4j+uMXB6w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CYYPR12MB8871.namprd12.prod.outlook.com (2603:10b6:930:c2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Tue, 30 Jun
 2026 01:37:48 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 01:37:48 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 29 Jun 2026 21:37:46 -0400
Message-Id: <DJLZZTX7E1X9.34WYVOYEX83TK@nvidia.com>
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <jackmanb@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Nico
 Pache" <npache@redhat.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance Yang"
 <lance.yang@linux.dev>, "Mike Rapoport" <rppt@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 1/4] mm/compaction: stop recording free page order in
 page->private
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com> <20260628-keep-subpage-private-zero-at-free-v1-1-f4ce3930d10f@nvidia.com> <4154c23d-faac-4d84-990e-a9a0aec5ed46@linux.alibaba.com>
In-Reply-To: <4154c23d-faac-4d84-990e-a9a0aec5ed46@linux.alibaba.com>
X-ClientProxiedBy: YQBP288CA0034.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9d::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CYYPR12MB8871:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a6d4d16-a1da-4ecd-2994-08ded64830f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|921020|22082099003|18002099003|4143699003|6133799003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	mCSy007LtfRXG7KX++VEHEpQZ17LpWlx0TfgqzV+XGe43NA9KjZdNgIVkzfbJ974K0uflwqaDPA8sX6K1a/PiUivRdSL1T3CXDg4X9vLJj3eLTau50wJyLbgNBzwPu9mdBaXbZb//n/+Y4T+7hdgTZpVcsM+P0PW15o+ccEEt7XRP9GjmUTWLx0qzCTFN+CnL0Z/WGincxidAY/GRsYpFo08rVUJ810+yG29aBLH8835ShVcIOGty3zdIFvobCe+zPFOpsHKNJ437pHrUsgozCpPKlxfONauYVGBhJ+P30E6zS2UtwbjIrHJq5sAxm2gzKbAUCrMZBS175oxMiNzVF2gyisWuK6JQ664P17oCJ9hBJJZQDLgt1nn11NfY+fBG1ZSSsjRL7ex3lnRygzgI2Z5t49HeOMqlW79Lh1pL7eB+YgZkWrH8iGqFE4V9BUFnjaBGpiQp89PKiPYKeJ+exCQgGTWz/5MOATV7E1GzNi7uS3Nab51Z6TvktuZcfJf9P2vGbR2+B6MU0UQv51Z3kvXmwjpmtde8/MR87ve7jBGLRJdEO9mqcTJ2b0uWhCsT6Sic/blFV+snKIwQcMGu+SlITxsK/Rqmt0a6ava6y+1TcZjJJhf/aIsAqDb5rOGO373cOLh1wJJr+vqz7kKPBY/UzoDcVUGeyz985wkhcQgxYabV33OVoiQFSW0al8KIbK44mGpa3IwEbvEMsUk1Q==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(921020)(22082099003)(18002099003)(4143699003)(6133799003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cityd1F2WWdwOG0vV1F0WWd1dWsxSDJVVTlwNWFvZTFtNGM3RXF1d3hFWERC?=
 =?utf-8?B?QlUvNnAzck9ZQlZCVTR5YjkyWXh3RHVKOWxBWkhNa3Z4S0Q0eW9TMWpHTjJN?=
 =?utf-8?B?cE5yVUdoa0tLYzdtd0FmOHh2ZmlTalQ0YVpHNG5WTjBxdjRXMmJ3SDE1KzNK?=
 =?utf-8?B?YWRZSlVwU2JucUJoKzM2dDZ2VXI2STB6ZkFSdk1wenkydGJIWWlPWGFaMXdQ?=
 =?utf-8?B?eGhycFdoRjZvM1ZuTDhhMzhVWnBwenh6QU8vemczRXpsU3JVcjRMY2t3WXJ4?=
 =?utf-8?B?aWVmS0RkRGxHYkdGUlAvQTFjWi9HeUt6Rk1QWmJ2a3FLRnRZTmFSWnB5elpp?=
 =?utf-8?B?SUdpVjlvYVgyRFJ2ZnltVk5PcGg3ZkJEYzloWjMwR2hqK0F2ZHdoV1dLLzha?=
 =?utf-8?B?b1F1VzcvaFdEL2lVTVpWL3JROW9vbHNDZ0FwR2hnbE8wWmVDR0gvNm0vSDN4?=
 =?utf-8?B?V3N2R2dYWWdib042c1NQU09kR2ZjaTcvOStIQ1hjeGpxclA2SUthYnF2VGZp?=
 =?utf-8?B?SHhnYWppcUxFRUkraUpMTkpmUnYzNXpJMVFPYU45Yk9KV1pxY094dDF5TDBI?=
 =?utf-8?B?NDZ6L2V0amdOT09NTnRLTEdiZWNBMXBYancwc05KL3RsTWlWSlkvSWt2VGF1?=
 =?utf-8?B?YlYzQ3ZpN0NzaWQzSWg3RENEQVl6cmYxVk9obWRDS0V1TjgzSm92VkdnV1ds?=
 =?utf-8?B?TWFWNjRqaHRiazQ4OWNhS3JzdUVwZHppaG0waVBDblZXbjVOUTh6cWU3cEht?=
 =?utf-8?B?VE8xQ0hWc0dzVkc1cytYVmVGOHNhQnJLTjFXUzRjbktVNVVDSWpmQndqTjV2?=
 =?utf-8?B?NE4yQmVNb0QrZWRDS2hKU3BZUDdaWG16WHQ3TnA1MGxNOGFpS2RCS0dlNEdh?=
 =?utf-8?B?YzI5WTNFcm8zWlJETFRWR0pXL0xWRVBxWktoeTV5aW1OVXNDMVJPUVhlTEVO?=
 =?utf-8?B?dXJSbHNuSWpHcGR5clgwUEVqWGVIL2w3WVE5anZiL2FNWHZOOEF3N0pnL1gv?=
 =?utf-8?B?eXIvWXJKK3JvaTh5andKejN4MndESEsrK1g0Y2tyM3BqMWRCckZOTmoxaDl0?=
 =?utf-8?B?WmFUNHU5M1E3T3lkZmQrSG12RGdYMTBZL1VGQVZuS1dNOFZrbTVDTnJKYWlx?=
 =?utf-8?B?cTRxSDRtRVhTQkd0dEVvcDluby90UzVLZzRQNWl5RWptRXd1S3JYZ3Q2MW84?=
 =?utf-8?B?M1c0ZjJ4WHUxKzdqRFhSKzliVmdrWmNZc3RyWi9sWHM4Wk9lOXVvOSthYXl4?=
 =?utf-8?B?Q2tqMGxwODM5RmJxZXV2eHdhVXB1TVVWSlRETWVoaXJjVUNLRmZGVWtUeXJq?=
 =?utf-8?B?S1JmbXVSS2lEc0tWWldCU1FuVzZpNnNPbk9oQk53TExuVVFSMllsZHB3R1Zl?=
 =?utf-8?B?aFRtMXpWbHFpRUJtVEtLcnhsNUVCMnpxM3FoQVJ6bGZrMlhRRGZNa3J5YzFY?=
 =?utf-8?B?Uzh4MldlZkFHUFZwbGU1d2R5blFJWkFPTDB0aG9QaUJsV0pDS2Qyd3V3eXov?=
 =?utf-8?B?NE1ReDhPbjhWb1pWQXgxOXg0WTR4UDh2b0d4VHRiZkdzOXdnU3o0NzNIVklQ?=
 =?utf-8?B?bzdBMXljMHN3bzlZMGMxSmhPLzFIVHdhOHQwK1pMZVZOZ2piR0lHSHRHbk9m?=
 =?utf-8?B?b2ZuRE9UTUlUMnRISjgxMjVWT2syMFQ1L3FZdXRlMXNHaVc4SXY0SVBtekdU?=
 =?utf-8?B?TFBQcUR5R3A5cHlNaEEyR0VFdm9lSVdYM1FMRmhkMjlISHV5YmtraVBidmdR?=
 =?utf-8?B?QXQwWWpJc0JMR1dDbkk2SExiKzJzaUQ1VnNqdlV3SG0zVlUzc1FxaWk2TXI2?=
 =?utf-8?B?dlRQQ1A4NHFLVGYrdnN3cFoxak5qZElwRy9RaDlMWHRORUlva0tBTGFQYXJ6?=
 =?utf-8?B?WjlwTDdmR2JNa0F4K2t2YmhRSEx1QkpoWE9GNlNVQnYwdWpkUmY5NWw4MFc3?=
 =?utf-8?B?RGw1Y2J1c1d3RGhsMjlKNlZMKzFxdy9rTFNGRUNUNXBYV3Ntd3Vya1M0TU13?=
 =?utf-8?B?Vi85aDJnT3QxcGtGaDMxRFNadndwVGY1Mnk2ck9WamVZd1VWWiswMFlHWTlj?=
 =?utf-8?B?VnpTa2NBSXBEbjhaR0VIbTVITXNNQlZEbTJGNmdhZ1pKZ1FMbmFXM01NTDlv?=
 =?utf-8?B?cmwwZzJXT0JyTVM3S0szYSt5S3RTMUIrdU1DVkIwQ2p0RjFhSU1QZXY5T1po?=
 =?utf-8?B?dEE5L0wzaDV0UkFXblFvd0xWQmN1THBXb2x6aUx6Ulhsci9xeGc3RHZsODJt?=
 =?utf-8?B?aUk5R2dQMjJ5a2pCOWtIeTRiTGFLWHNUeHJsYjJONGN1TGVyODBjR2pTTmRE?=
 =?utf-8?Q?JwUPf1FNQASE0vxhwg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6d4d16-a1da-4ecd-2994-08ded64830f0
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 01:37:48.3501
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IRV9Qlz2hwjHiry4L9NiviQ1pR+PqyXq2cbpCsGSNbegyMz1dYImHVM1cWNboEiQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8871
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27377140005
X-Rspam-User: 
X-Stat-Signature: o97n7f4e8zgf9ns464one8omowspj3ra
X-HE-Tag: 1782783474-848445
X-HE-Meta: U2FsdGVkX1973jeuugKTrqVmlSeo3g/Ano82gETQoZtNmVEagIbzK4EP5h2ZKmR4kMcFbVYyR2se1+j3Y+aSzlJbw1AdR9ETwP0TegufFGG6EXWs3Teb4FtRifDUZWmEJWYtZqQm6CsfGQJYgKtQxdxsWvEwG09l5H98MUZFfnDaMKXm01QmmCeMwQ+d8BqwDoFww5vOZYb9akp8tMXa43nE341yPJP06fc78pYet1IfzIzVEtndl/Zl6PES0XwgMjQndDRW0ItjwLwqfRs915U36Vigk6dkey96tU+OxPADjtnTyDD1nunRoH9pcr8neD4kBrgXC5o8UkZosnbGoPPHP0PvndcJf2lcVTbt9WXHKSr78KHQRbququZ4xmaIaljfoOzt0MwrHQ3sdf17i/T8Zqni85NsT/tYCRbNthnFLCT8Zi35Uv7HmLP+BUpAoSgEVn1+69HoKkbNkU3yosNZdFT9S3ym4bk3OGJSW1Zzz1DY2M8LneX+jEtQg5vbv+x+FUs7K5jStR3vD9U0588ecuTiqyIWdcxZbVcyp2EY34+P0Y/xAKRlopgLEjfp1SBBJ01eJPrrKADX8A5Md2R4xuYud11UjGjn1XeuPihdiEKNElhNfrhSGcBiLpnAlBW1t0+Uljtaftsu7f4ZtZz7vm1gQQ+0S5EC2zWpdHUpKqGkeSxXBvTmgRupiQTzcuwAGPaaq9lBxDz+tdGi0jI+AiASk/QGCUt/vPqAmNfl3fBps3btOvGHGVwSWQCEFTV2hqCjChqxuggcSf0NDNLnBAwaJ135ohd9zt4FytrLxKTsp5RGc2E2cOaZCVfqudZgO7W1IQnQe2HSJONjhcQEtZt8Gag2BgNMIPlZIJTNjfbG0LejaWPZTjIE5EMq1a51PwPx/MZ2VSiOzbyFaXivA/zmV125VTZwmtB8CzwAQ+BIy9J764ALF26s/AHQLUKKmeoluHSHqF+QPBa
 bxXj7PaO
 N2Rdx8bCUcHCO2vEl5ljOrY+xFn9nMxzi1GL5qIBy0fVjWIJrxnLUu6pSRaFswJR6lTJa+J5kWi2/EwOQtCmI9rzjRAZ49m2M2ulZTDT6qR7vXnykdyYMm5kM84Cc7BN+egAoUI9MfkH6FPqrHJCPwpsrwT7ONEMZBo24F6SoIxmJXXhbGxlARQfsKDzzzsScuMvNhOeSqDtcWIyGeje4v/DX0SsUt+2KTJVQH/2J/43kz+wdT+izwA2j+x84NcvBQw/pqnqWr8/fagE76TfhGFRLOx97RYY061fEEgY/SQ9fTEGnDRgVzyEAUbWDUsyXbT14zqJdpx6xt2EkACkuxIPCby0GG7ztJfOSEFIxD1D8HmYckJoWChMRM7WN3SK10HUm2S/ePj7mTnPe9Zw7LLa88QDY8MgaYK54DK4Kbqn4Tgt5xpHQjnVBD0SG5tFu/5T9NyNuRT9wxHok9WJIviXZROCkQjrtGtLVScLNF9AaQbDZ25onFHi8kSnZffn7yQI8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 29, 2026 at 9:32 PM EDT, Baolin Wang wrote:
>
>
> On 6/29/26 10:56 AM, Zi Yan wrote:
>> Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
>> memory compaction.") stores isolated free pages in an array indexed by f=
ree
>> page orders, it is no longer needed to store the order in each page's
>> ->private field. And there is no code using the stored order. Stop doing
>> that.
>>=20
>> It also prepares for an upcoming change that ensures subpage->private is
>
> I noticed that people tend to avoid using the term "subpage" now, though=
=20
> I understand what you mean by it here. :)
>
> [1] https://lore.kernel.org/all/20260623125723.2503832-1-dev.jain@arm.com=
/

Thanks. I was confused which to use subpage or tail page. Now I know
tail page is the way to go.

>
>> zero at page free time and the removal of set_page_private(0) from
>> prep_compound_tail(). In alloc_contig_frozen_range_noprof(),
>> isolate_freepages_range() is used to grab free pages from buddy allocato=
r
>> and it leaves the aforementioned page->private set until
>> either split_free_frozen_pages() or prep_new_page() is called. That
>> triggers the upcoming subpage->private nonzero check along once
>> set_page_private(0) is removed from prep_compound_tail(), which is calle=
d
>> via prep_new_page().
>>=20
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>
> LGTM.
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks.

--=20
Best Regards,
Yan, Zi



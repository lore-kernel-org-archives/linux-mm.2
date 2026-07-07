Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8181C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486BC6B009E; Tue,  7 Jul 2026 16:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45EF36B00A0; Tue,  7 Jul 2026 16:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374946B00A1; Tue,  7 Jul 2026 16:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE386B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:42:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B5461C3A32
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:42:12 +0000 (UTC)
X-FDA: 84963152904.01.63E85D4
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013018.outbound.protection.outlook.com [40.93.201.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id B081610000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:42:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KQ9rPLqR;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783456929;
	b=MfuXnsuAYtnkV/XVTogaDMl1xNHoS4A3XH2ToR/ZxCeGXFnv/a2J5N4D/3P8yROtDqYChU
	xZ0IAUOHhQhXyiWRFL4w0nWx7cw+CEmTh4FgYP/uK9l6DM5OEdItiVjh6vomAumUOkPNuM
	BBJ7RbSx1ifRhBOLY/miYHwWwFLMdkQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KQ9rPLqR;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783456929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugmMxfS78HNMMjE0X0cZnPREjTpoYE4JYDJuNtt+KDQ=;
	b=RysWEo7mwKKKpOtuyrxbxhlqKKZE2pPbmMde4B6XU1vgw19Hc330K6Jk1+3vz4b4GoErKn
	rWGKelPN8ICoOoHX6A1NrEoZDdELWalInH68ArMtu8+yBOQcB3jG9yucgenSl8HpsTWtse
	kFAhcp53ji9gLZSZgVPrygN3J4BpPTc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mO5iIEEp39iahNsVNL2IDcUZw5utkZQIsAAlhxVVyNh+Z6sxmdzMC3ibzonsAeTjG5d1LH+ySx6L/wFPmEYcsFbTXJdrt9J+hDA85XfxgWmmd2xEDd/B2Z8GYHU1jJ9v/l/r1LS/GMTA2DC/0IsgTpTNTuITgj2mnOI/+3XAREKZLGcV89DRX/521QzxFxIIGTsJShzNwx+E6S4UjZrnqpiQnTtPVzuTq1P8AVEsZoSOHlnt3L7kLlFk88JSC21mwLJz2gwb3Oz2hiLPZxaLx/XoZRG7d8h43sLAY86qi2yJ8FUzZXCgDSXs+caeZ2L+KMTTdwSuNHnFDE7Zwv86eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugmMxfS78HNMMjE0X0cZnPREjTpoYE4JYDJuNtt+KDQ=;
 b=RnftSeE9XrCYwcdLx/5hkFmLmrt1isHX6UAnUbE4WfdB/p2KAzbAnM8uA7KekDG1cDzwe8/eU87HR2yJBKDaD6SZe0g6LBwY1fINDlWsMTgvi6bx03hMHeuXvrOgYXeHb3Wf4mTTjcpC1QVdC6MuQy2z7g+tNf0Z1DpX0d0htLDqGZCJwdedLLWsjjO4h4kfnlMC1L8NpTQpHDyx4AE6ecUvfjg/emy/bpJp32HFWp31JBdHJxK/HF3zXxcPjZ2o9+vMT+piifjCcn3/DdCp07ByGd6Ol0QYE4xG4fAS/fCihgRwleJfjIsI7eEoviH1PNKdFoUxKJEiY53tMIgD9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugmMxfS78HNMMjE0X0cZnPREjTpoYE4JYDJuNtt+KDQ=;
 b=KQ9rPLqRH+hTMtMA6dz0mC5Uza+Igp4YXmKLuDuVW1BAH1DfRfigf26qAJZgGbTry+5EE0Igmd9wRR9N4r1sbIz4ai/ik1O6o01DkUczJ9MPWl93VwVxauX0bvpJyHuuhIqBYzO8RKOh0hxA0mB6b4nDdnasarFq5Heviej2ZM2mLG6q3VQWW3TFGzY22ilRcd12ZAVy/hCWcU910/zcKuXVK3BzlLIlbuFVG3Mht4WCOf9LunpAwL8b5KQk573J4j/Pn/N0t72+I62Il0Mx51MbMmUmB3GEJTAtHHNduG1R/pZUXsjGUTkA28z0yjF60cq3iMee/v4IMXtty0zhAg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4471.namprd12.prod.outlook.com (2603:10b6:208:26f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.13; Tue, 7 Jul
 2026 20:42:04 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Tue, 7 Jul 2026
 20:42:04 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2026 16:41:25 -0400
Message-Id: <DJSMPABTNYB1.R7X8QUOA2HUB@nvidia.com>
Cc: "sashiko-bot" <sashiko-bot@kernel.org>
To: "Usama Arif" <usama.arif@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, <apopple@nvidia.com>, <baohua@kernel.org>,
 <baolin.wang@linux.alibaba.com>, <byungchul@sk.com>, <david@kernel.org>,
 <dev.jain@arm.com>, <gourry@gourry.net>, <jannh@google.com>,
 <joshua.hahnjy@gmail.com>, <lance.yang@linux.dev>, <liam@infradead.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <ljs@kernel.org>,
 <matthew.brost@intel.com>, <npache@redhat.com>, <rakie.kim@sk.com>,
 <ryan.roberts@arm.com>, <vbabka@kernel.org>,
 <ying.huang@linux.alibaba.com>, <shakeel.butt@linux.dev>,
 <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 2/3] mm/madvise: skip device-private PMDs in cold and
 pageout walks
X-Mailer: aerc 0.21.0
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <20260707135255.292870-3-usama.arif@linux.dev>
In-Reply-To: <20260707135255.292870-3-usama.arif@linux.dev>
X-ClientProxiedBy: YQBPR0101CA0348.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::25) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4471:EE_
X-MS-Office365-Filtering-Correlation-Id: e6a07c7f-2843-4c19-7821-08dedc6833fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|4143699003|6133799003|22082099003|18002099003|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	UTQioZdATPHWs827aOlTzKl32RxCuyavp2mWjmDTmSixdmXtlN+GsC3D1xMM6vR2mkhZ0T0QvqeezjDnObmomdK5HjXaHmVBKcRMOYo0JcNKzH22eoGZ94AOhdUhxWjSAPZGRK3UU/MeFNrHSGTogzO8Jem+h+JGvu3g2+j8ZnrW9ji7/74b5b04dhdwJWGQPDshvdAw2BNJkvH2u7BxDeVk+obyJJXh+MiEy4AVYCyC6kwokdqig6rYBIi928jTfil7WuLJGLbK4XVyx43wFZk9lpu1C4BCQBbHvx7OENzXWs1t0i87RmtcBcQzlAJzcrFio60lO4iW6ipZ5vMV71VO7xVs8pNz1vLFQUFP7hPxbw4mTkkoQ+TIe/piwgs9kunaamSnZH1Sa46viKyTVW/ET1zw+k9Ay+HHlFWY1Ojd0S2P3zqCh7Um73t1tNBqmJcakbu9/s/5E1ru/B79uOw4IzBLcp8sPwWRO3t+sPPWgFFD4wDQv4f2oEsTNEUy8kPK60Ofa2A8qLp8OSwQVl0L07W/SN+t8obCVHcF5/oyWVaeEE1a+l/sVpnzsQbEG/PFolx7QI4DB2OsLfo/eduVDJNpWH8FxXAKmSQEk4Pv1DKuB+q3dlFY3AbNpCES7ymrzFV7Crg4BnI7qr0G8+5l6G04dLLdP949DG0sXGlbA/nHMgkqoubVnLQL9fi14Rhy6eu0u8pIrqZ9qP1TxQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(4143699003)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTcycWF1NFBDZGNVT1BVZ0RERytNS3FPYmZhKzdEQ2ROY2JqMFpYMDcyZ0ky?=
 =?utf-8?B?V0l2VmwxUkVmV2JzV09xODMzN0oyeGd5cUljdEJyK3JValBFbTUzd1A1Znpx?=
 =?utf-8?B?cmk4OFBYTllER1NLOEF4K3JNRGdwOVdWNk1VRzQrVGFiM2tnaWlZOCtRQ1dR?=
 =?utf-8?B?RGlqQ0RzNjFFckt3NXhiSFhDS1Z3YUJBRWZuLzNoeE1hcWdnZUFaKzUyc2ZY?=
 =?utf-8?B?a0FvOHZLVXROSjB5MElaWERySExNZGxrUHUvZUo3WGdjS1dhY0JpUHZhcTYy?=
 =?utf-8?B?NTlhTmY2TEdnWVNDOFNaV3l2RFg5RTVTYVpFWHJlMU1pUGEyMnk4VUE5MDBm?=
 =?utf-8?B?UzRQOWNad0hvUHBEWDBrWDR5SndwUlpYUCtENElreE9oSkdNQUNsVWx5aHgr?=
 =?utf-8?B?NlBNOUVIWldjbEJPeUd6a0loU0Q2cGJBYnl6U2tIMWdnTUdTUWtlUW5lT3dM?=
 =?utf-8?B?MFZ2T2VSMzVkVlorb1VacXZFbkY5eHEycUZrbEZmU01Qc1ZkYW11MFNWK3Qw?=
 =?utf-8?B?L3Rtam9LKzRZS0drUEhSQmoxSmpZQVFNZUx5ejVFZncxWXpZWnkrL1ZrRTRy?=
 =?utf-8?B?UzYyeTlJUlliVVRBbjdHRFIvSGRUaWFoOVJ5RzgyeEFPdzZOdUNud2ZwWE9C?=
 =?utf-8?B?YmZsZTRFZkZzWDJHMTlFQzlGc01OQ3JOWWo1WU5CNW83QlVNZStRazFiUU54?=
 =?utf-8?B?cHBRKzlyR215aGhyaFN4YXlaZWZIenFwa2RWSHBEZzdtUmZ4ZVU5cStPZ2ZL?=
 =?utf-8?B?MUVjVG9aTmE0TmlUWUpzeWhxdmtHNndQRmowd0ZMQXVSVHBkZXhFOHRreURj?=
 =?utf-8?B?c05aejFuUmZwY2ZKTmJ3NUc3ZnlwNHlDZzU3RkJPaGJCUlJ0SjIxREdTTEQr?=
 =?utf-8?B?T0c5K1JOT2lJUVQzWGhtSi80aG9SUkxMVW1nVUJqcWVEVnhHTjNIWVd0NmE2?=
 =?utf-8?B?Tm9rZEQrMUJPd0lRTUVyRDdJQXlrMlZnOExLU04zUk9KVzIvZlpCUEc0MHRV?=
 =?utf-8?B?cVQzS0ZmYVh4WnhmU2o0V2hoTmFFTFkwcldtN3RwMXlSVmVWbStpTGl3T2hQ?=
 =?utf-8?B?Qm1GZXJuWVN6UHNJVVlPbWVnZTRBenBFMVc4aEkrcG4rYWRQUUVHR1F3U0wv?=
 =?utf-8?B?VlhmZElJaGpjSTNvcDlHYXNKSDZDc2tTUlpMdlJ4dENzblcrWE1GcG5pNmNF?=
 =?utf-8?B?Q2o5d3FpQWtVdGRvSEs4bTFqckc2OE1HMTlhb0JoTWxrODBLSGZzbjRBWUJx?=
 =?utf-8?B?VDhmSE5JQkRBNWdHWHZ3NkJ6cjVzU210YjV5MlBiejd2NnRCdktlUEhCaVBl?=
 =?utf-8?B?SGp2azYySURXNURLVG54bXlBdVA0Nlp3Z3lxTklNY3Jua1Q0OFhmSVBFNmRj?=
 =?utf-8?B?SnFFaytHcXBiUVF6RVhROU1zQ3RScVg1c1RzR3BqQ2MyOXk4N3krc1ZPelFZ?=
 =?utf-8?B?dEMvUTNMSHU1UVg3dU1Oa2VsRkdLdzRvQ214Qnp4cTRUMXdLcTVSeVRubGpa?=
 =?utf-8?B?VjRJY2Q3blZJQWliTklMYVR0bjVFTmYvRnNuU1lzK0VWSHUzeFp6U3kvUDRu?=
 =?utf-8?B?ZzlPZlNtUWNsdC9Rdm8rTVJEZVZiTWhaWTNNSlRQd0sybDExOEppYk54RjFz?=
 =?utf-8?B?UnQ4ZTB2emI3ZkVEWHV6dnVTbHJ5U1VmaGFNQU15b3VoUnI4Wnc4TndjN3NJ?=
 =?utf-8?B?QmkzcGdzLzZtUnliTnM4WkU4M0FuYXNuRE1PUWwrTHZRS2Fhd293NFdnQXZR?=
 =?utf-8?B?NEJYT3R5SzRIOGtFeDJGQUNTdVdDRmVoWWk0cGRIZHdybGRKbVM1Zzc1VEJE?=
 =?utf-8?B?OGpmVDFJZ3hlYzN6TWtNU2hReU9uV2FUS1p3MGN5azRhY0ZwRGJmTUlKZGhV?=
 =?utf-8?B?YjVCYXJ2Z1FjaEYwbTNSb3o3ME4yVU5lTnZtaVN2aVBCNVBYYlREb1pSWDNo?=
 =?utf-8?B?VGt0OWtKSHJXaTVRWXpxWW1YN1lHUGNUUUNMRE1QbHYzNlB1Vm5hTDFLNGda?=
 =?utf-8?B?YVA3RTh6WFBLVndqOGJiK29BdDI5cmwrcGxRd21iVmIyZk9wVVFJd3BZaWVp?=
 =?utf-8?B?V0FUZ3hoRUxyN1duMExRaDQ0eTUxTnUreXpEYTB2eG9nU2dzdlEzNytXL01I?=
 =?utf-8?B?aXhybzk3K0RZb0JUa2RkNG81Z2lKdENOMkR6YXhNQ3NiUS9LTmc4TDFGU0FQ?=
 =?utf-8?B?ZGRhVTFUSFFUNWk3b3pFVEJGTzJlQmJtbnNWYzJMRElIRENhWGdQcDU2b0Fh?=
 =?utf-8?B?SCs5bW5MallScnZPQ2lKRVZTeW9uYnRROWh1MTMwWUMyNDI2bmxPZlpzdkhX?=
 =?utf-8?Q?gLPKjcbNKkqhOxJDLY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a07c7f-2843-4c19-7821-08dedc6833fc
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 20:42:04.2032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K5JGHuiXNWeRaTXDJxcPWUcwJJLY1xBNP6ItWfNtvSbOdkhT9WjqZwJaRKQkW9OA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4471
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B081610000D
X-Stat-Signature: gyof97w87y49ygedhdwiqoj7kfkhfgsc
X-HE-Tag: 1783456929-946746
X-HE-Meta: U2FsdGVkX19lwOQGSeNyptQHctTQXP6MkypUlZXGw7jeFcStK4NePLO42TaikonukmX+3UFTZwCjy/YOXM2PZfYPpHV1AgsD13F7aIaUFAmsWDYTPWRNjgB0eu3eyncfz+OWXziz3ALKJ8g+m6BierFo8lTXykKk9kK0CARNhc3U8DOeKQORNKgBgUZvSJifhE7WtnYiPeV/JIpuRHZ/eMGnjXwaBkHdjA6/Pfw4qL+xHpo6vo4+VGZOwHa296zdC/rm8kOYPEVp9NIyln8HGkFC1P2eUa0T9kv+091Kmef+2jKfLVIOwvdAHV846yIxSxeBDkLPoYAP71zLPIgfhX35tJpOnn6ANgf74VGKrHGcizGY0KtPzgesSVRhWG5QH1C53IpMoY1uMp51lXCw+i565X54UaXZm9Y+kCk3TEiUrFdo4cVRGQvR/X5JoxMhEtrGTIELBQi82yKxJmL5MbeD/rvfcjc8Faep2St/RzElP/4liupmhLK+X+e5CrGZZxiWJ4QP9RzzEI6vNkrr/J671LmfOzcQgct8WIEcmUc8rmroNW8Fyp8IgnlJzYJ1iqFTeV5P/okbStt3NZkF6tw5gB3Qrnq+FUI3hTWN/F6M9pP6zn+vmyheZuk7nPEGVhTNEJbhs3Y7YJcfBZxAMucRAyNFDIUzuPRlBZTOK6J6qpcy2t/vZ1hJVcIH0ghm7ZRNMDhb2HETxJ984YKAPmWQ+W9kIridHCh7GPF+Veecnu9UWQR1v49d8PdjaDO+4GZvNLv1/chEU+t5xt9XW+EfIkdPwwYDLLoHUb1bsbBexXHb8buY3Jiyd9IEF8e3GqSj0g8p6QYihDtj7BOZBC7Dr5CKHmPPmYbBr70JADAJ1vXAzoKHarK0VDQRYlmruYl3YK6A72/CEIo+P0a+PIG1ro5Izxg23E2GlSvnH1Q6x70x9OjJp21mSlXoVkISmU6NpdzK37ix83mrBjX
 uu++jhL2
 ghzTZIPQ367Jjbdhb8Nh4YydjFy/lc+TMLoPWJdYvQyLXtXslwekuHY6bz1CwyaRVZLUfLql2RbIp0RS7Q28efuskCpIjpZVSZYg4wrgQVn3GJzh5eF/b2MyYKDifD4Ch4S3D253A427Ex06W5lemyU28CsnwVHTnWSuwIUu963noSE1IhhYTs5AOa4uX8aF1Loj/AlWfu+uDL2gWKNGLzm4ApeYAdyik3LpWCrPdwMX09K9S2vCTbHDOmj/3cX3ZjQV9mN8IDnP7Nb2OYWRfMyUZPCQb1NE8V1OwR9lqNteCrGgj5HR8/h0NCYawS+TCgy4Ab7lfDOpkMR48MEdgCbTbMom0i00t5UR+/Sk715EfEXI0X7+dG1PwnYV8+62uHexAIYw9Ixk6GOeCObrJ6mZeRmflRAIk+J3xU5D+DhTATku/6gXR/A3wlOgXmau6IXV8hF5cZN9rdryQoGnDiJGsZSxSzOTPhOJiqXE3WRtsjA8A47SIeNzMZN15Fs0lkGjDWDFdmtW6SZmhNbZJk6OdtXCWQ9Q0ZGwnu8gDsrqIHRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 7, 2026 at 9:45 AM EDT, Usama Arif wrote:
> madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
> pmd_is_huge() check returns true for a device-private PMD. The subsequent
> !pmd_present() branch has a VM_BUG_ON() asserting migration is the only
> allowed non-present case; a device-private PMD trips it.
>
> Potential trigger: an HMM-based GPU driver races with
> madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
> migrate_vma_pages() flips the PMD to a device-private entry before the
> PMD lock is acquired.
>
> Skip device-private PMDs after taking the lock, before the !pmd_present()
> check.
>
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%=
40linux.dev?part=3D6
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to P=
MD operations")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/madvise.c | 3 +++
>  1 file changed, 3 insertions(+)
>

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Since it could trigger VM_BUG_ON(), probably cc stable?


--=20
Best Regards,
Yan, Zi



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A66FCD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23556B0005; Wed, 27 May 2026 03:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB1A6B008A; Wed, 27 May 2026 03:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C116A6B008C; Wed, 27 May 2026 03:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B34816B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:54:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F8191A0518
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:54:10 +0000 (UTC)
X-FDA: 84812436660.05.75D0F1D
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010049.outbound.protection.outlook.com [52.101.61.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8AA16180002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:54:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZEn0bb39;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779868447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2vPYd1FwT9hBn+eYVP9WTgN6us8+EOM0NFb6LCTcvQ=;
	b=o75x8zlYp7SFqpBEFP+Hbv9iNOI6qgjQDlV1h8NFjQxIMkGtij9QZ/kS2bs4ilBSye3p9B
	CMc9OiDUv+mzFo1XuV4bOhJBulKzTNy3kTWE54CDsAnaZhtilakR4Wdc+BqvdP+4ADe5tw
	t+2UIMN+zJYD1wwZ32CUoNkQvIuqRMo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ZEn0bb39;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779868447; a=rsa-sha256;
	cv=pass;
	b=mjwuM5bclndbqs1dSsFQ5Lb8ppYpsEl4XkK1lckHnqj3aM0+H1LjRZ0D6tKVpLFQGcDzby
	ca6FG48+vBdlvTnpzmLU+bYelpCu+BEaOxKUwiolg8phDijzyffaT/hmMoILQuR4Wu+7Ez
	sUPdwzRYsH+D+mM5M3Zbo3bVyZWEjFM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lf7lKOMt/cnOE5xyH3F7ZBLMYU4kE+RezrDL+tT6r1MkiII7dP+gMslpvIT4Ive3YZTmd3yuxXBlBjPIIQgeybOwkDeN2MrVDsqYpk8jlMev67ZWkWGNgwYVDK5zQdPrCB90pWu80ioptRxvZQfrITzkAhOWTX5jYe2hVIcqz4WVDGfzr8scEKuQKEHIWLwEFlHm8SOjP2kdQrLag0FdIjjc09raqYHUlo+US6jyURhp63eLSJmE+ESrqGf7lzF6qhZ8hYkcHXUPfiIezwfW9oBu5QEsuAO6PuJywMNtW6u1pSNi+nwuIUriqcYFMFLeNpSQ9ltC7GfQduXotgkiMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2vPYd1FwT9hBn+eYVP9WTgN6us8+EOM0NFb6LCTcvQ=;
 b=ae/KeBtfw1FYu0XO8teS8ieStvQsVggtB2Y2G6VfrJnnv9gWplnJ5SJ5VFvj+qLaKM4knI0R8w6PzWnTC7oA82Dsy9e8PXm0DlQ1+p/+bgmYmYnp3VJJ5pzD7DZWzFb6POj9aTUnJtdZB+N82W2V1oeEZDv+srqETS6mqS5WWlg7jxUAcSrl70eJK6e/aLQkAKOKJTld1fIfNRo8r7YvN2pCAXeKhBpg726gxqc5NTSGwbnlhS0vaRJ6v4BeuoePEarbbjIkp9dIBCFLisD23u9dQNyL7bGIOq2HFMVTzinELQP2Vy7HnoiWax/c7VBOV+MYNpFliE//KBuacXAUfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2vPYd1FwT9hBn+eYVP9WTgN6us8+EOM0NFb6LCTcvQ=;
 b=ZEn0bb394YBLMJXdJw57FLhmXfvl2Y94eM5RhSE4raXWfIub9U06AeWkDuVdl7NXpTkIRyC52qxju1bxTwfawBycGcS7j230Vpj/DCEoKZRNC3H7AyQxJty6G6wQ3EuO1hTbx02Fch/UHFdAbuiBrk8ju6941g1uxX6xjT76oRZbGANVVT0Gdm3znCcqEH35n2/WPTDPnwr5B8ycoNfaFsRXPV+EWSUZVSySeo6dGhKPGKlOlpePJviip77rJqQdxTDfOv7hM/GLran+gnOlrcMPXlWdHCahoHB4o7rxfOou76w4SGKHk+kgHrnMw4d9rie7/PYRAeq6n1Zch1j29g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB6459.namprd12.prod.outlook.com (2603:10b6:208:3a9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.20; Wed, 27 May
 2026 07:54:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0071.011; Wed, 27 May 2026
 07:54:02 +0000
From: Zi Yan <ziy@nvidia.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Chuck Lever <chuck.lever@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-nfs@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: revisiting alloc_pages_bulks semantics?
Date: Wed, 27 May 2026 15:53:53 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <A68C1B33-053C-4406-B78E-871ECD7293B3@nvidia.com>
In-Reply-To: <20260527071816.GA17632@lst.de>
References: <20260527071816.GA17632@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0108.apcprd02.prod.outlook.com
 (2603:1096:4:92::24) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB6459:EE_
X-MS-Office365-Filtering-Correlation-Id: e4f56031-b591-4c70-7a36-08debbc51e75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|10070799003|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	HqDYao+yR38lSlUKPbxpyrlQLrJ9C6WXiIjatSV939nuoVIr2EzSFYMzrIsyzGCreTQO12J9A0ku+ALaTLB9y0XmMm4KdLjohm/DbRda+JOzFzYWUi5GL/GmaRWE6ORu5+ultoRSLb1sHbm570lEXEDbrgujOCVlCJCivbUqbc3216VDaZAPBFe9vDNwCDMbDNtZsI9ed7eXHeOrj+IRTKm64sl3od/qE3kfLqccNXPfinzJ5tB1ilO7L8S+q3S4WfY1ML0UjsfmDZ9oXSFLsAT4/EVXHN4/aDTo3QqkglCUCHECfuFSfE67QjRxSVRCyKWDrtyqstNFx7GY4QtFiM9rZEZxZI6BQS1411UoSJ30iG8yUsTUmiQLJ7JtkeYDCHAdCDP3WPmC+Nt9qBTWauo+uLNuula4PDH+zaOIMcR/L4WddNnpkWvP9m+yKHsEiS+fjAnS/EAxQdDqxlXIzCywZarz5cRYwYjXHxUvPTrR/3cPmCy1sAYHqMKGrxON3QFfV0oa+UCnRs6At7un7kd2tkSjqqcqtpLXcnAONNV5DUo5nRSg0gLnarIteq6xHsKR71Rigfld2Zwcx+Qbl4QBIEaz3Zy+CJejBTR8OrDfz6/D9VYD0DRT7Wo8sK1hvL7OgO3lCr9H/+zkAapxLAgCb5GPfNadSHdQBSXz9BdwEbOmvkd+/QnJrZwSwk53
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(10070799003)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkEvOUhvM0pwanE0OCtKT0V4NGc4cDBqVVVLUFZMSkhUWkU0WmlnWXg2ejRp?=
 =?utf-8?B?NWlRaDNCeTVlQjE0TmZ5UXZRM0dkS0JUTGhzWlhyUUxZdGtNTTJaeEJJUnFL?=
 =?utf-8?B?ZnMyQUh4SVArRFRZNjl1RkJLUXBIVFQ2VjJJRnNyK2ViUzJjNE1CMnVYZFBr?=
 =?utf-8?B?YVh4Z1JoV3IxSmJVemlqUGpGZksvcVBPaFBtRFEybHBqaFNBZnpMbFZEM1Zj?=
 =?utf-8?B?MVRFQmFxMkdZNUxJM2xNenA3clBZcGNDUE94cHIranZHelJEVUhzVGFMSTVU?=
 =?utf-8?B?Z0dOUGhGaGVSZXltaVJPbW1IaXFscUM0SitaR2I2MHF4V2xvYWNSTnFsZ2pu?=
 =?utf-8?B?dndoWEhNN2NhQW1oTk9PUUZhdU5QUVZxSERKUEZ5SFFRNFN4Q1JIcVpQNS84?=
 =?utf-8?B?dGp1dzBEaS9HVGgwdExNWkdSaW1TV1U1eDdlRWlnd2ZIZ0pkRjNsVCtqNUFO?=
 =?utf-8?B?Q05qM3pmKzVMRzhTWkpEUE1sRmIrbitFTkZFZzNxbmIyc1JtVmFBRjA2SnNH?=
 =?utf-8?B?Yzd6L3NuNEFzaVliV3RheEpJcE5QRkMwcXQ1dmlwV2kzcHhHNTFsMnJNVlkv?=
 =?utf-8?B?K0VRc3JDa29SSkE2cWJiK094ZE4wOXN5eGtVdytieWs2TlFrS0R5UFhvby81?=
 =?utf-8?B?OHlSMEttMmlCV05NcEJ0cXVvd1Q0ZmJ5cVFxam1BNjBJek9aZ2FSZSt4TDEy?=
 =?utf-8?B?MWEwQzBuMEJHTHJVK0d3Z2ZsQVlBWEdhMit6d05ISngrYWhjM3NVR1JxTVdE?=
 =?utf-8?B?aVBvM0Zzb2gyQmVxNnJpZEdhNUdKZm90aE1ZTWhEaC81L293alNLb3l4Rm5K?=
 =?utf-8?B?N0hJWXJjUGFsbHRKSmlTL2ZsMmRHWHlEeDJlT01jNXRGdisvZ1p2OHp1ZXdj?=
 =?utf-8?B?K21yQ0lsZWdoK2d4WGpmNEJ3UkhSVzFYZUtRV2hLNHI1N29iUnFTR2JxS1pq?=
 =?utf-8?B?RHFtcncvUFM2RUo1am0rdHFsdEtKUFVDWit1ejUzakhCbFFWNmlWdmxHQmJ5?=
 =?utf-8?B?REliTHZwRk5Oa2JWY01JMkZETUo2Uy9jcDR0WDM1c2pIYm9yaXdwNmYyNVRE?=
 =?utf-8?B?QlU5TGR4NUd6YXhGTXc5a0tRemttcE56ZjFvcVYzNmhjVFRxN3o0ZS9WaFZq?=
 =?utf-8?B?bk1qSjQzMWNvc0J0WTBnbGNNOWoyNDNjK0lLRGd6Z09Qay9aRHlUY0pXc1Vt?=
 =?utf-8?B?VVFReis2Y2dNbzkzOGpocjZvWEdrRnUxaURNWjV3TTRCZG5NUmtPb3czNlRH?=
 =?utf-8?B?LzN4VzNlY25NbU5DZXNTTkZab2RacW9UTmNrRHBsMjZmNUN4VThmditRaXE4?=
 =?utf-8?B?akhHU1dubDc3RklSODFSTTJsSFVPSUordjJsc0JOL2NoNEFoZERtZG85NkRu?=
 =?utf-8?B?S0NaS0oxdFI2eTlwUnpISzVtTVNJNUcwQVc1US93L0ZkTFYrVlZwbUM5eXBr?=
 =?utf-8?B?OEt5QklXeG9mYlhuRzdkMm91UDVUTkxRbXVqSzhTNFZsL3EwQkZacU9YWWs3?=
 =?utf-8?B?Y05YK2lWMGVlTFZmZU94c1VveFIvMjJkM2FubXdzbXF5UTZhNHZ3RHhXaFFj?=
 =?utf-8?B?QkhRUTRHK3RPMm1vdld3RFlWc01UWnhHdjFWK0M1Yk1EazdYcFFGNjJiZHpx?=
 =?utf-8?B?UldIMzVvd1VkUG1uMWRxalR2ajhmaEFkV2xndDhmamtEdlFRVWRibHNrTzc5?=
 =?utf-8?B?MlBGb2JIdU93R3pnL3NLaWFPN0dDRDkyZW4xaDFqZ25wUE9id3dFYXpnNm1L?=
 =?utf-8?B?ZUdkVEZlU0s3NFJhT2gwaUUybDNqelhMNTRKWGpmVkhPMnlPQ3NyVFdENzFC?=
 =?utf-8?B?cHVNdFpXWkxEZnZVc2RlSEs4UW5mQUlQMWM4cTBZOTBya3ZXdjc4dnpQSWUz?=
 =?utf-8?B?Q1k3bTluUVl4ejU4ZVRsa1lIQWxKV2dPWmhlS2pDazc2VjViK0l3akdzbnFU?=
 =?utf-8?B?T25Zd3pWZThlaW9rcWFHQlpZUUl5Z3hMN0s0aTcvZ253R2s5eXE4eXRnOTRv?=
 =?utf-8?B?bTBOd1c3cEdpOTQvajduZUhQeHFLcEw3ZWtVZFJ2RmhOaFhMamVaMEFVT0o3?=
 =?utf-8?B?TGtDN1l3bjZiZi9mb0E5UTNUL0Y2MENQQVFRRjNwb0N2WUJCNVRBb3Z4bFlJ?=
 =?utf-8?B?R1o3YXNtUHNCU3RDbW5acHB3MlVWNlhNQ0dURWZvKzhWWXJvaWNpM3BMa2kz?=
 =?utf-8?B?YlZaMUwzVk1rd01RQlZUeWhFQVZEUnlydDFqK1ZVdzJ0YkFZaXVVRVVXZEZX?=
 =?utf-8?B?WTlldUNVc1hjMUlHOWdFdkNRcEFpZUdYR2EvdkZtSnV4RDFYRGlCUDg2N2VK?=
 =?utf-8?B?V21HcmFsMDJGU3NVOXovQ0hDREFWbFFZdUs2Wk16SXNyRjl6dms2U3hBRWdG?=
 =?utf-8?Q?8iDBj3vJSuDAAKQCn+2CRgUZuw1ju4x8oLBqT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f56031-b591-4c70-7a36-08debbc51e75
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2026 07:54:02.8126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ws3/tDWlAutTMBP5zJ7kiLP/O2w3R0CefCzplwuiL35k42LVkL4wQdwtr6s5gmt8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6459
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8AA16180002
X-Stat-Signature: gi3x3u1wxf7yx1idemiewmq9rcet67zm
X-HE-Tag: 1779868447-267837
X-HE-Meta: U2FsdGVkX18yU6L3OxXpiJNOaMqL9rv0lLiKKo/QsSekNbX3s5KImL6egFY4WCBQahO/l4qCGcsY+PtGhTJL5yorsakpR0TSFfZBg9EK9v8wJU3f3e0gPbLx4SCTXpjbNvqu3Dhqaeb4gwWrvCPFEkPwqcTKg9AuW3ixhrKSM5TCXxj8Nanc9jgDecnfXjd4uKnAlSelCaQb6U5GOby7ZToHZ2e+ucqgoh0J+2wEqm8Kxv0J5dJqIVcO4ChPRV+AFk0WZjgp5TVRWbkK18gHIjVyvZgz6n8vMB3biPE0+Zw5iaiU5uhwHo72dchwTYupg3KqbTpz/G9+QwAkHCzkx2WPNEeTMkq/nTE6RfLEm1Etm+rEFaGERC8nNzFn1mdr54Zaz8HGDsS228hrM5Qbvy3sGFUT/TZ2pMkTZvvAnqQsdlnxsWZBdKLDz2OaeYumUm5XR+IyGUulRbQ4Zeiu/UP8Mykm5tRNZfnDB1piRpt71mgOMygNE8IrHHONYidyI46tJU+CF8GOBPjG+4bUDipTYz93CYtkBioiCEX0+Tv+HU0TRqL0V9T5OLdDS+Xmb/kLZARzpdl1onMdgm7OJTnEvx8uMrfMLEmIb4nRVx/5n3ahzt8AQQbBc/KBg7GB2p1K+Jz1RJCx3Itx4zkb6e95uf4x4/l3rnZNy4R7zPlXJKeBKUDJg5POA0sTsJEDWdOZ81F5S+5p/yRPMvUpOF1MIRoct23S3ZlkYn21tgcl/VT8x68siiopSv2y0JwPrGFG9K5cXRBlmdOTC+XKWV5jIXNamXl9tksvf/qIQ/QggECDULnljf2MQPURFyfCRD2DNk2yW/3m8TDqkqr5NKI+cJjchnOdV+8orszLwBDV4rWNEt+Dhl16ASni4MLzg+YUgkHnB3SF2Kqa+Zq7KtPVqSsd/dZhEhpAk+UT+DYhxI38EX8Dlyh2kF/GZo2FnWKYqcF3jpJc4ewTLxp
 3HQWf8q1
 kcfSBQoXdHOx0cjOh/7+p7ilulu1BpDm52ymBHp9gF7gYFPny3mrqJHU+zUCTlYW8/5CDw1FKNpHl1FmCvqaZ6dIUk6O/OvKPYT1SfBZPhDj626asYkg9VfLouyZi7Qc2c0SupCKL6dEWO8GWoXDEJusZJlPHfkI0+SWse3FZw64CeohdWLV92i7Sl1na/bny6mX1s/na9+EoIflFWe2OAOHDAB30SG3yLZeP2pNqZO+h8w5BD2LQv3YTl8ZM1JNRDui0lg/SowUWQ8w3IugzXOdcEIUiSgD4TQmYqSY/0dagP6thFuaHYipcUvKDhnPRwcquaRRfMxdeYtEZaEtWx62DwAHJZRh4nFN8Jfv1XUQcnr3s3aSeGSbgGb3IsohILaer7iG/1uRHOAOSa5E7ON1cbpegB7y6xYGSUYorMCP/hzjOlDfBc+NUnc/K0Qpd4AOg3RttxiHSKLo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 May 2026, at 15:18, Christoph Hellwig wrote:

> Hi all,
>
> I've been looking into using alloc_pages_bulks in a few places lately,
> and have run into issues with the API.  Here is my suggestions for how
> to make this more useful, although only some of them are something
> I'd feel comfortable to do myself:

I have some questions below to get more details on your needs.

>
> 1) early fail semantics
>
> alloc_pages_bulks can do partial allocations for some reasons, and
> users usually have a fallback by either looping and calling it again
> or falling back to single page allocations.  This sucks!  Why can't
> we get our usual try as hard as you can semantics, requiring
> GFP_NORETRY or similar to relax it?

IIUC, current alloc_pages_bulks() tries to get free pages without doing
compaction or reclaim unless none can be allocated. Does your “usual try”
mean possible invocation of compaction and/or reclaim for every page
allocation? I guess it also relates to the order > 0 bulk allocation
below? My gut feeling is that if one “usual try” fails, the following
“usual try” might not work. So making alloc_pages_bulks() do heavy
allocation might not buy you much.

But can you elaborate on why looping alloc_pages_bulks() does not work
well? That is essentially triggering compaction/reclaim repeatedly
like your proposed “usual try” idea.

>
> 2) pre-zeroed page array
>
> There is one single user (svc_fill_pages in sunrpc) that relies on it.
> For everyone else it creates extra burden and is very error prone
> (speaking from experience).

No comment for this one.

>
> 3) page instead of folio
>
> We're allocating folios, so we should have a folio API.

Sounds reasonable to me.

>
> 4) > order 0 support
>
> The bulk allocator is limited to order 0 which limits it's usefulness
> these days.  It would be really helpful to do bulk allocations for
> the pagecache or bounce buffering.

Sounds reasonable to me, but when under memory pressure, I wonder
how many > order 0 folios you can get in the end. And that might
cause a storm of compaction and/or reclaim if combined with Idea 1.
For > order 0 bulk allocations, are you thinking about 1)
a try and bail-out early model or 2) a keep-trying model?
For the latter, I wonder how large the allocation latency can be
and if that is tolerable or even makes sense, since for THP
allocations, we have seen >30s allocation latency when under
memory pressure. Is waiting minutes for bulk > order 0 allocation
making sense in your use cases?

Thanks.


Best Regards,
Yan, Zi


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE31AC982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29CF6B00E9; Sun, 20 Sep 2026 22:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8CE6B00EA; Sun, 20 Sep 2026 22:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8050B6B00EC; Sun, 20 Sep 2026 22:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9766B00E9
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D9DC41A0509
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:53 +0000 (UTC)
X-FDA: 85236186546.15.B149293
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1680F1C0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gYAq5oUu;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957731;
	b=iIu3GtXPu0cnLRleBeIWUZaN1HRLHDEYwMPCL33CC5mwVZRoeCEQwsG3yyvQWT6bRVn33W
	x/dSyivQHvWzyuUqHaYu/+TQJ1G8ujD74Di+0VWDrxuwZ65YxxN+P+nWTa+Tpa8oxpg6PI
	v19Q0+QlBjjhCtuTPgXvCQScHWNFvqo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gYAq5oUu;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pxl8REd7pjZ/pxg+5RJBiZwMjGvhapxp0OyAm4Ema5Q=;
	b=pVL164kn+YuBudKjEQJBvW25bOmQQQDd0dWCotOAIGcuvBHGSGfbr9HsqS35cnKMkN+kxo
	jCErVl4gWokERQwQcQ6NzFphazF30hPvoZQ0HhT+simyh8yi8Z6lrWUw8EYMDXv3WzOi6+
	4kYHmFHrNGmkWl77zW1NokVf+FOsZM4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oB+wHi9seeFz8ImexI1xoth6n8AiUel626z3Ltvbbr84iqrQuMvDFfEGrCRlgB8ce+y0I1pAt1MOktiwEi/5aeScvvmYf7emQ698HFruw3xtImBXZut3kw9mzqn9BlurTrBbMz92TjPii5KyaCaBqvOdrheVhN81txbal/uT9MmpFKgiK5qI6OSarxMUFbxhyTC8FZY+w6X37UDoelPli3BCCSmE0aXnjPur16JoJ8VAJ9Zvzrk0ivP3LxXHUTSA8RBlQQhWO0+V63G4OGXBeHaXeTvqpuDSxpV0iKSK7oH4heZmfoOyhoQ3BWAWk6GwI5FDW899shk86t5bqSAc2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pxl8REd7pjZ/pxg+5RJBiZwMjGvhapxp0OyAm4Ema5Q=;
 b=cnDMoAvOVCD/Zs7QOcpNLtERIebf6mlq8JIXjo1+7H0qsSLnaRWY03RRIk8mmEdfLiCM2Xq0gTKFgMznvbT7WQR6k7MRR4NhhaWD5OXGuRK+Cj/uehHP9BUN6Olj374eX4R1IGyHstex9/yPjKxwhd0T3WE88t/TF+BwDj1UaTRdVkV5y22JVYnskzdpBRKfRHQkxg+PH9jjwe+k+Bl3vY9WgvpyxX4Q2Kp0SD2GkZ2vvQPuPqVPGguGD5YZ3Oi+duobwGzztgB8oty5Ep1HyLG0XsdX/z+RLzWEZXvIjlPn7LRvHXSsBbuo+fEgiXE+TBlwT9j5ZqNaR3h0LP/VHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pxl8REd7pjZ/pxg+5RJBiZwMjGvhapxp0OyAm4Ema5Q=;
 b=gYAq5oUu2gxLN6Z1XQeCmu3pfJlpVa/u08Qdm12QDGwm7os3Sh2lJ2vDkKqYDzUAg6/oGaD5WO8ndpX6XH1PLioyt79AP9BKzGv8Yd6CIxwjAiog8Jv3Ml1zje39ZFiHH8pJjcLf0zGkldjS5zm7grfJGgG0WTJdGU2FkmM/MVSQsq27eM7zhfEUBlxnG1iGxyabGboA1OmV/n68FyclKme1dbrsJTK8ZR00hdRxAnag1lQGuf/L6qs33DBXLiV6dYrsKX9/gEzyI/QNR04s5O04FPZpaI1FmKmkOdTil1Ky3PBtCPJIpetqWolkgiLtnv8Z/skxT3t0mhATRTvhrQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:36 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:36 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:07 -0400
Subject: [PATCH v5 11/17] treewide: remove folio_set/clear_private() usage
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-11-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Trond Myklebust <trondmy@kernel.org>, 
 Anna Schumaker <anna@kernel.org>, Jan Kara <jack@suse.cz>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, linux-nfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQBPR0101CA0184.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 82f64fae-83d2-4850-ed32-08df178809d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xoUJ97aMxh2RIKe5uUm2PKK0IzHvTsvDTcvmgGDWr7AMvx6Kh93LtMp8efmHMbEj7Oht7ehD09cdnK8HSyGjqEK52LPGs0bkODBb8+xk9zrR5n/ilmVfC1BFV0XOgORqC7eXtrReofzWOlIm+2c22RNHDD55276NKAN9uOnkzWBa98jgZGiDmdXFygqaciPZuYxiQATKue23/BS/tWl35OxyKDa+nicdCRAmtkA6Bx03kWkoTMH9AQ2SQxmgM2Oo2L6l/b6uzN4s4bgdtV9xL7m2dj5334YEyfkgBSnIfMl7CHDBmuWBz5wDhLJSZILXo7rxLyxDIh+fVpvC43CHsNdCS+0M7WTkg6wB3c56W4Ju0iKYXP36keTqE2GujB+bb5ZVT74IKvhZjfuQ1GKXhtaybVxttI5WJ1hpEZlZojI0ItXM9xmMGEdQSBB4bdwTaFaW7Lwv/vXAWeRP+LXnUAlLV0PtXZgESLg6o0LSiT3GIs5lTmE3DPU4yHaTkbVw3+x5Z6L7hCadqsDwh2iSSdvQ87K0kN8+dpgbvG1QtLMl5xqV7p7R8zF4cxrqVdeZBGXhrzm1UqIINaUmc9tNPYmDqCH87VtHOUUaVzl7agir39hGLklJGxlptBYkZSpywDsl5ckd/LFJt4dktuY/+1LwMe0pcBmGAgOkKNdjXT9Pi7dJXTfUnU9BdyAjvROUv38AbLK/oKb2zijgB3lrUg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXNPYkU4NWJTNGV3MVE1bXd6OStzZE54b0pHZk9COXVFUFZ3dk14YjZsL1BH?=
 =?utf-8?B?Yzk3T2FtVSs3cXMrTDd6ZEVibHNmZS92TzZYOGxVUEdsQ0JZY2dKcUpiV2pP?=
 =?utf-8?B?N0I3S3JwY2JlUmV6amROdGZGemlpalAvb1I0NEdNNGlTeFJ0eis4QUZkQzBQ?=
 =?utf-8?B?QkszNHBQRU8rNlNXSlFHdGNCQjNucnRwdzFxbml6WVN1M2h4REJBU1V1cS9Q?=
 =?utf-8?B?eXJiNHowdUJkQ3N1L09TbFgyTjgzaHNWZmhqUzNyVHFWOFFMVUVqdGhJcHMv?=
 =?utf-8?B?T2dUR1N0anU1NzVUNUpZYjZ3eDBmejluM1NxRUhBck5lNTJWbG5FSURmNWt3?=
 =?utf-8?B?RmR3Nk5RbnZidXYwRGpxcWdiVzgyMTFpb2wyVDdNUUdHQXA0TFdTNzEyTEdV?=
 =?utf-8?B?Mk0rNnhvellUZjJNUGFCYVkwZ1hhSmRSL2plYUZkRk1nRkUxTGEzVHBiQW5Z?=
 =?utf-8?B?eElxaFpPUU1nWkxtbjRTWVQreGJJRUFxMDQwZmVORU5zbXVrQ24xMXFqbFlN?=
 =?utf-8?B?NXoxbVo1aEdBdXQ5NTRNVTkwUktYMmdrdmFSdllnQVRYRHB1RkJ1U3pyV09n?=
 =?utf-8?B?Ymp5SkJoeFF5a012ZXJLMnFnMC9xTGEyZDJ5a2VMa0x5RTQzQjNFZXdQc004?=
 =?utf-8?B?aGV0REtDRHhzT1FkejA0bzVPRERneXMwbFc4TFBMYmxpYzdsbSt1Tzg2YThv?=
 =?utf-8?B?M0lhb1BHdGNvbFhSNEM2VUZFVE5QdzE4Y0U4ZEVBemFWU0ZyUWlaci8zdm5W?=
 =?utf-8?B?QndjaUVKYVNvWXZWd2g5NjFDSmpGalMwU0grMVZFTWRIT1IrdHFZZmJKb08v?=
 =?utf-8?B?Zy9VeCtWY1BiRGlHMjlETFpIL05MZHBwRkJsZ2NsdTV4Zis5ZWk0R1BJczJq?=
 =?utf-8?B?K1ErUW5GSGtBZjEzMzBKNU5tVklScjFNZjVVa3hYQ204UG1nUnlBaDFtSEJq?=
 =?utf-8?B?SkxrVEh5SlNKbjd1UHpnQTJ1eCtiUVBpQi9Fb0NrRW01NThOZVhreTF6bWhs?=
 =?utf-8?B?djI0ZWl5SWlXVzcrV0J5UEVGekdVd0JwNGZBN2xnaTFNUi9vUlA3aWxsMnFI?=
 =?utf-8?B?TTBidUNaWXg5WWZGZW9NL3pZRXc2bWhjUHIxUXV5YnBydVhUZ0JVbjZ0dzBn?=
 =?utf-8?B?VlM0NjhPU0xieE9ZYVhpZGVTeXVUNkFuajVkcTFrbWtXdHVGZTRVRzdTTGZm?=
 =?utf-8?B?QkNNVXhFc2s1WWE3NVZsLytuY0s2SDVjSkcwM29iZ0RHcjBLa1c4YW41VUNO?=
 =?utf-8?B?UUV4UDFaamxvTVR3VmFwMXdyZHZMeTl2TUJUc1hFMEZxMDI4Ui9PeWZidkpR?=
 =?utf-8?B?TEZtaFI1dkdxSHRCQVk3cGVvWGVXVU5yNk40b0VMa2p3akVkTWZQbU9KSEVH?=
 =?utf-8?B?Z0k4bTZFaDVrdDl3Vi85SVZ6Y2JRQncxUU1TZDU2a1ZxU3JBOWhXRUM2OWVn?=
 =?utf-8?B?T0VGcncrb2JqN25qb0R0V0ZrY2RTRDJCeXkzTkc4STFZWkk4Nk55TVNtOTV6?=
 =?utf-8?B?MEtmV05XdDR6Tm5mc2E4TGgyVFlSaThRZUs3cTMwSGMrdVJqR3ZEemJTVlgx?=
 =?utf-8?B?NDd4bjBrL1U4VjBsMlhIYjBmVUVCcEdZdDBKUzl3QU9RcWg5SmwvaG9MZHBm?=
 =?utf-8?B?RHpaWHFqNWJ0TjdLSDBTZ0pUS0RHM05ENDF5SVI5cU9qWDQ1bGFMZmlSYmc0?=
 =?utf-8?B?L3dnQ2twME9zQ2JES2xubTRJUWsvWGlFVHJwMWtUSG9BZEJmQWJJVFhnNDBy?=
 =?utf-8?B?SE9MRnN4Mk9uN2tmaU5LMWRxS2pBNkY4dXBSTVBHZU5YN0RCUHZPcm14U09U?=
 =?utf-8?B?UmJ3c2lOUi85WEFRbjlQTVNoOEZ2TUZvNmlocitrYllRMXhmdURhZjFDdEhV?=
 =?utf-8?B?dm5UM091SytIU3dLVGNvWVhycWdaT3gva01OR09RbTBQVTE1MVRqQXJVUU5r?=
 =?utf-8?B?ZCtuRzhIQlNpSEUwd1dXWmV4ZFhYMUdTb1A1N2RTU0JzMDlrUm5wZXhDeVNN?=
 =?utf-8?B?UFFJMzUyY0Z6Z3BpQnVsNTd6djVpSk0ydVN6K0MxOFB4UFZTVVdWemRNS1pu?=
 =?utf-8?B?WC9SSnVLOWszYmdWeUpSak9sS20vUnNoRmJ6MW9DUU9CaXI2Y0NiUG5WSGFj?=
 =?utf-8?B?Tm8zWTVmd1lwUDF2Lzd5YmJKUHBRYlpVZXdRc253MjJHVnNpYnRMY1lIdWYz?=
 =?utf-8?B?ZHVzbTlTcndtU0UySWRHZW43MkhUaURRVmtGdzI0dHVhMEp1eXBaYlZwRG13?=
 =?utf-8?B?VlBkWFBJcURuZjFSWVM0dXhxeXFQYXFubCtOWUxNN05HanhpR0xCSHEydjF0?=
 =?utf-8?Q?V0mfDhb1og4q58h0T1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f64fae-83d2-4850-ed32-08df178809d8
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:35.9243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b83UN34jkDAO4XkRsQUZ16SBpo6aWrfBosnW7a/Qx7jFhwsx7eyNWV5TxxsER0Vd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1680F1C0005
X-Rspam-User: 
X-Stat-Signature: n8q6ddgkfega31monptcudztxejmq6uh
X-HE-Tag: 1789957730-587226
X-HE-Meta: U2FsdGVkX19v1aGH2Meth9LUGdcXtZyhhjDk8AOKBWwWr+jOoit98g9VZke7toP5PwxTmBEfAN7Defqm4LetIvf5cIONVfzU1R6C53O0GZis66bCJh8Zwb6yAjKrkgpUxZA3+Nu9XQH+qCO6ISoJXMSOlZkn9fu3bjSCxYVTAdKCY3ffO2C3YZ3wRZlXdwcKDptonl6to5gUf0fD1TJUyuZps9p9VysJPb5W+uCiJAnCm8mzkl2ugqGT3zdSqjj9Ifby2uiq64YmNBQKOIooB5dAwPCuQq3LQSOAfz5ZD7bib+Shov3NGE+Jqyzqot3ffr27q7t96MTqWiB2vgae7AfEQ1Xk71LhG/zbmMRInms+Qklxqmfc5lwlSaO6ZA0NmtkuCCvwUQeyfKUYRaaljICO0mBnKGrH8vVBLVmDODkzTuFrApa9ZRIUh0lOml8IV6jI0WKTf7H2AYKCeo0z17BT4R8SxaBDCWlmj3eAcrshRA8QWqPniHdTecrO4Nw/fLlb1kovP6mXILC11pRvSNmqung4SwJiUD3RRgvaoSwOVhrzGKsCBXm2EMNDqOiH7/qUF3Oj2b7TwFhcs6eVhLeYPjOonN2D+/VI1g7NDSjJJLXpJV2iyjOJuf6wWP4rh1/cabkQtXUODnNLNb28t4ZCwHm1qqw8ksF9Z+ISFraaoAqNXHctwRYxCFGxG2aBUNMu4xTmajyZEjtgufRWnGNYP9S3CAvnO3wKmGSeY+IxkEzfO8J8GVSzkhmH9mMaXkItWRJevijJYfORjrI9J3Zbr38r2p5NycBXBmW5e7MT2yYB4iG8aS7P8vG5kHWRtFHkRojVCcpyZUUbCOSsCnA759EhNgcwLb97aJYRTu/4uBPV0u8fg/9yjG0QXHJFJ3y8+0ctbyjex+LoDAZ/VP2iwhtd5x0KTSZOUEc3QcmudMSFL0sCaLV4mEjJIZHc2fW+jPX+msKGQbgrOhq
 dVV8qpCV
 xnAiYqX7Zs+Lps7DJWs+zUtQQhCeuGpYoTYEjGtLCB+4C7BrS/JZoZXoLVHfuAkMz4fjCzi/co+kEzru0bs+PrWxDgpxC90lSj2RdAUJt8FPdELLbANmiADWng12ThXolvzNCub2tt8I4SmMzd/nMKILcaRDu4ckNjqg97jscwo+MeaaBHoR1ODhehCbiQIDG3W//vuU8rQF9p0bMRShUXJA5tlXFd6mXliu4MVPllTllrR6/onv29+YxNG0sUxe5q1sKVLxQLdn4yeMQG5xJ6hLStIlM5gzUWJq4HrBYnzoujGBlGfbIbKYcar7i47S/v6JKHRGbsnCJB/Xv6e/zUbGpwtbatdbnPxgvwTd1knRXkQc5/6Zm9AmFAaaQAovUmCipU6YJvKbxBfFER6lgRSb12aDo/Kum9f/Rww5tXh8iZC0O548axM5FJi5HY7pGZ1TTaZum0IIxnxYJ4t2Ox1k90MX0oS8NFLuhHvsx9wN20dhua43zFN9l/vxD8RgjIZ6JIwN0NObJnn4kCUj7WO1n0ZNWJNn/r9UU2GdiJAItQPO7nXtWNBY/ONtehi1PSWryLt/e0SiG80JJ7pwb0qKaGJuMXxtw+PksrIcwRWxlTsvYuYyIGYrbgQnwNnSCcQL6jjoy/6ibS/suzFwcmE1u8GUgxRsQVa+maq/pL/SodWv4LCmUpKo6lM5OWKZfUmAjBKjAdxYBoxspZm5eY5+0RiFfd3cUfmqca0Dr9kAWL7axy5Wvo8LgUX2hAS1sMPIOCxd2bS16aNV+GYjkV6Q5WpZCFOFuQ80HEm/aFv2FA8DVusGimpF70Ay7tjOSp6Kw4CJxIHvd30CJjV6keaMgvNA0g6dAJewWx1i8yf0SnRlA+CPv01As3i//Qs7HXRlmOjeKXK/wr+Adthi5MRG26A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

They are no-ops now. Remove them.

Assisted-by: LLM
To: Trond Myklebust <trondmy@kernel.org>
To: Anna Schumaker <anna@kernel.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 fs/nfs/write.c          | 2 --
 include/linux/pagemap.h | 4 +---
 mm/migrate.c            | 1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 623e7ef1f73d5..b6967b5286691 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -717,7 +717,6 @@ static void nfs_inode_add_request(struct nfs_page *req)
 	nfs_lock_request(req);
 	spin_lock(&mapping->i_private_lock);
 	set_bit(PG_MAPPED, &req->wb_flags);
-	folio_set_private(folio);
 	folio->private = req;
 	spin_unlock(&mapping->i_private_lock);
 	atomic_long_inc(&nfsi->nrequests);
@@ -745,7 +744,6 @@ static void nfs_inode_remove_request(struct nfs_page *req)
 
 			spin_lock(&mapping->i_private_lock);
 			folio->private = NULL;
-			folio_clear_private(folio);
 			clear_bit(PG_MAPPED, &req->wb_head->wb_flags);
 			spin_unlock(&mapping->i_private_lock);
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1e3462357aaa4..bcbb0afe1a681 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -594,7 +594,6 @@ static inline void folio_attach_private(struct folio *folio, void *data)
 {
 	folio_get(folio);
 	folio->private = data;
-	folio_set_private(folio);
 }
 
 /**
@@ -629,9 +628,8 @@ static inline void *folio_detach_private(struct folio *folio)
 {
 	void *data = folio_get_private(folio);
 
-	if (!folio_test_private(folio))
+	if (!data)
 		return NULL;
-	folio_clear_private(folio);
 	folio->private = NULL;
 	folio_put(folio);
 
diff --git a/mm/migrate.c b/mm/migrate.c
index b7b92925a28c3..7e3a81f069744 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -835,7 +835,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	 */
 	if (folio_test_swapcache(folio))
 		folio_clear_swapcache(folio);
-	folio_clear_private(folio);
 
 	/* page->private contains hugetlb specific flags */
 	if (!folio_test_hugetlb(folio))

-- 
2.53.0



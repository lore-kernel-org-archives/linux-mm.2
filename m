Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C2D7C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C796B008C; Wed, 14 Oct 2026 13:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CDC6B0092; Wed, 14 Oct 2026 13:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD346B0095; Wed, 14 Oct 2026 13:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6886B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:51:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 929E1120709
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:51:15 +0000 (UTC)
X-FDA: 85321973310.04.E744A12
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010031.outbound.protection.outlook.com [52.101.56.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 96B331C0005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:51:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cM5EmzzT;
	spf=pass (imf20.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.56.31 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mq/CqTyBBCzihJZtGt0D8lTwvPcrcT7cZ6MxffIikI=;
	b=FyGr89XXe+OOaMmRSxdCYkMPfACuBLQ7vZtv4aCHPBDm8nuSmY8wZ8ItNDkRdYAT8Jwvyf
	dOSSHpKyNG4uEEUmxgdBb/Xd0rhEYMNtNghHv+DbhM62N4D9N1XL0QgoY4fbyZeSDG7OvT
	6FiYWBxtsz+zj0kNZZ2yklByYbu1g9A=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792000272;
	b=SPOfJzlK3yyaUqsET4zGICijnPCrR6Ta9Sgj4uValmd7FJfbTKag99ZNLBrYnn0wZv4/CF
	NZcD94u+AFwh4bgZ35gv461nBpR3xXEQ5MRpDhL55fab6WIOj4AnXIUpBu32/gSJjj2xcJ
	oeOvNGxwD39g7obceh3uxPN9fl7puSY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cM5EmzzT;
	spf=pass (imf20.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.56.31 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NGBQSMOeVHXy3PCmDXjac7PM64zpP3M60B+nalsJWgSJ4ZW6VgdKHlHb3JFge5F8GuBY1bqPLZuUyBbjkedm/BH5DPuUtdW9KDYeLyOqLEEBPmmn3SFbgvMhBPOaoEZVJIUOlXGPkbyi8wUV/cED1VkYlLHF42jbh6UOwTwpMWNT/dzATQOpsFLv+igkSDIi+jfuycR6epxNnPEBwQNL6WmdLiWulYbSt9okXHdZatKlFhyGHn3IuS9dFQDwkSO5HZ9ACrN7GizvTH9TxdGMyRCkeGuoM5jqVl0TxZaAhK1b0DcgXGXj+tPmXQ5QXoygXeZAA2MF4rMuo6w9Eh8D/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3mq/CqTyBBCzihJZtGt0D8lTwvPcrcT7cZ6MxffIikI=;
 b=rKuxjhqNGdAzEmqWuXILjmuxkIXYxMzTgChfNz2+fwVWfmAxGao/cfAZkbTia2JGAuOJz3WVZ9/Kvg9jim0JNhEG5caqyXGfk8qfv+QWw/fbSYCOtTd8+aRhB6hnffhrKTvIDiuWj/kaKDwLELTwIe35CHkWoHLl5Euui2RsRydQuUWu6gJRkgoT9+TnD3fda7x9HFpLHn/mHVBDq/az8CQRoT44BTJhbXIG6RmEaNzJWqYc5IlyWTQ/mLvRsd3H63CyimD/USBIAOFOr9sPAremdD2acyzDyEsan3+UWWdUVz1sHFtwtpNLTe3ZsvlfKRb3VTTtBxaAWLt/FbYedg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mq/CqTyBBCzihJZtGt0D8lTwvPcrcT7cZ6MxffIikI=;
 b=cM5EmzzTKi1BXtcBUz7+LTz+zfHw8djTKHFi4NZWXxJQBN1uq/BZmDlnak8C7TzWS8FdBR8lYyTuNy7D7HHQZRDZmPrfQB/3FKW3B4fmhWfRn9knzrSl9JuEjxikGJ5DAjgX+lJxIPiNJVSewvGQwqfg1toeX0A7ywoBaqE1NRqdtmJQQa+mSw+O1U8F2w5g/MF5aPtRQ+4dPu4m0loVtyH3qXb94ONAe7w/R9d/a0IfcmLfuzKBisHTQVtgsKnQkZfGsR2QFf6Z4R/yLedzniQ7CvOxSt5BvLLh6nSItfVa/8J2LNrp5okd0lOHbi57snSbhtDiubKcobAaVbFlgA==
Received: from CH1PR12MB9647.namprd12.prod.outlook.com (2603:10b6:610:2b0::10)
 by DS0PR12MB7583.namprd12.prod.outlook.com (2603:10b6:8:13f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Wed, 14 Oct
 2026 17:51:04 +0000
Received: from CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2]) by CH1PR12MB9647.namprd12.prod.outlook.com
 ([fe80::228c:766a:191d:77b2%3]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 17:51:04 +0000
Message-ID: <afff5a1f-000a-4216-b4df-dd3d0406047c@nvidia.com>
Date: Wed, 14 Oct 2026 19:50:55 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC: DMA_PMD 19/22] net/mlx5e: Use DMA_PMD memory for tx header
 bounce buffers
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Luigi Rizzo <lrizzo@google.com>, Luigi Rizzo <rizzo.unipi@gmail.com>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, Joshua Washington <joshwash@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
 netdev@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261003212241.3432303-1-lrizzo@google.com>
 <20261003212241.3432303-20-lrizzo@google.com>
 <52a702a4-14eb-4617-bd29-e3140fd36780@nvidia.com>
Content-Language: en-US
In-Reply-To: <52a702a4-14eb-4617-bd29-e3140fd36780@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0238.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e9::17) To CH1PR12MB9647.namprd12.prod.outlook.com
 (2603:10b6:610:2b0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9647:EE_|DS0PR12MB7583:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c23e81-7b5a-4899-5b1f-08df2a1bb78a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|23010399003|56012099006|921020|4143699003|261009223027099003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	oVFDTws5nvjVH8vrQyLgsfySZL+FktAjfQZlR4/HQDJKPJRgEbID34pN4U9HgAHLGGodBV054B7J35mt1T4PPGg1SbyonKFzH4M68tj+gE8nLD7JdQs8xayLKRifdndSaoTijT9Uh4//Wpf85/wsSYBBdYv0hRJr21VeLINsnFnHPieKb2m1qy3VGqSCB7fxR2W98pjmYMzlZDCKSp8MxXGOGf818daHeZVmTq/ZDbi9juHwaDUzlGd7A0UT0Bf8MrHxIhvLUgfs+xvuIMICTPx37N0RrL3Q1r/kzYs2IzqMp+sWpHjDuSnPlUHxyi8faAZ5VA606zetcFCalTfrFyc0XCJxJXltbf/Zn+1RitQdsTB4cEaGyzm26M3JRKF3Fb/yRxXuHLAYmdDWmSkXbpAASHCMPL31TZ4UE9/1qBUfaNEa4ZYOLUq5Ib45sB/iQZEgtIpo2HylIra8eSf1MAYHEly6X/zUh51EjqTxCHcjyOWH1+iUn9gjtoLZbDSZCjA8odO7HxHd5oAYGLKRBcH4GS/3jFY9ShnKPO5V7btJNP6yRm31jcYYh570ngw0lZqKZVyePCrImOXK5BlUtupHgGeZPMeIAwNI05pQ4m+zMR0q+itoBW2mXArxh1c6mCCcGMJp4Re/zQDqfKTKUOugpeEbDYw6Wapml4V3eMdLJ8R6nSLscP7u77WcUs/FCzzoSgJQY+ID8bVorN5i8w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9647.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(23010399003)(56012099006)(921020)(4143699003)(261009223027099003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M2Rwck5hdFFUek9OckpRVW1Vd3gzT1V1di9vSWFLbk5IWEZmT2lwRU1ROWNI?=
 =?utf-8?B?L3VnUnZKd09yUkQ1OXJNTFdWcjFSQjVRYkY2OFpQZ01ZTExhUytpSmI1akt0?=
 =?utf-8?B?cnVxVFBWcWR4V3hBS3VBTVNkOWlGSlAxdmpmNUdWOVRtVEF2b2ZETGJxVy81?=
 =?utf-8?B?ai80TEdVMHZTcG5pS1ZIMzltNkNvczhqcGxldHFMR1hheDBhQmx3S3EzMmxP?=
 =?utf-8?B?UkZBOEYrVFFONjErVVhjVUFiWk5YZ1B5dWtGUW1KUkxYUGxxVm92dThobSth?=
 =?utf-8?B?WGlPRVltMWViRGJac2FmTHF2cGtsWjBqR0JCNE1icEFFeENFbUpqeTlKUENp?=
 =?utf-8?B?bDhSREMzRmRYb1pGbi9JYWpwRGEvWnE1T0NXUmtRenozbEtmYSt3KysrYWN0?=
 =?utf-8?B?UjVuOUMxK2UvdGVWcmQyR1oyRTRXeWdld1hDNDR6eWx5dEQ3ejM5aTh0SVdY?=
 =?utf-8?B?dFc2Q3ZveEQ2UG8xV3kwWlQzTk02WUZOZ1JMN1I2c3o2VTFNSTVvT2NUdlh0?=
 =?utf-8?B?Vm5obXhadEc4OWFxanQxcjF0blVubE1NU2xxVzF6WHNqcTkxMG90aUJ3QStn?=
 =?utf-8?B?ODlvSUsveEIyeGV2QlFHcStMbzFYVXF0cXRXYUtTTDJsNDVhaElHRjVyMHBM?=
 =?utf-8?B?NGtSdXc3L0NzOW9VZlFXdHNDUXRoZk1hL1RmL1BIVTVLb2ZwdE9wdi9tU2Iw?=
 =?utf-8?B?UHZHTzQxdmlDaitGMi9kTk1zUFl0RUVmTkp4cDNVeGI1M2dNN0ZhK0pJdU93?=
 =?utf-8?B?a0phZ1VWL0I2K1RFUFE2aEx5Y09tNkJleHBkUERmWWIxTFdQZmRXOHBmdlhy?=
 =?utf-8?B?eTl6NGdmczlwU25Tek1kOHFKWVZRK1NrbU1pU3NNd08zWXMybUV6R0xualFv?=
 =?utf-8?B?d1RhYmtFdUtDZHJDRHVKQjhzQ3FVR0FWWjhGWEhiOExhUk5JWXkyQlQ5bTZ5?=
 =?utf-8?B?OUlZcmFsZ1h3RVIvdWdLSzFzUHdVeWx5NXFmWkFLekJveDQxSEpNMW56Y09U?=
 =?utf-8?B?TkdBeXBJKzE1ZTZYaXFZeDJ0THJBSjFicm9Wek9IK0xFc0NBWXRQSW9Pa0JI?=
 =?utf-8?B?OFZOYWZjQ25pVTBDd1daMUFuR2pqZU1NTy9vc1BXS1VtdzJXZk5qM3ZPdk9j?=
 =?utf-8?B?c3lCazFVVXJMMVpSR0FBUUljS2hwRVZmUFY5d3BJblY1a0kvUGpDaEZpYlFH?=
 =?utf-8?B?ZEpRNXhTSU42QkxUN08zV2VhMHlRQVNMMzAyYWVHRWZ3dFFmRjVXZW1Vc29r?=
 =?utf-8?B?emtpbjVSVFRpMkdSZkpoRDJtZ0E4SmtNeGFRR0Y5ODBFcjVRWTdjMWRibGRs?=
 =?utf-8?B?enJRYTJHR3Q2SWV6L3VuVGFvMDFoYTFLb2o4aFRJNlVOd3J1WnM0QU9XRGlV?=
 =?utf-8?B?L1NhN0ZuTjFwbXpQby9YeW1icndrVjFnYTJIbkVhdjRBZlhjZi9sbC9PeEps?=
 =?utf-8?B?UkRGeGJkaHVWc2JEdDdMekhVdWg2YWx1RU40MDNERzl3WWpnL25ra2tWends?=
 =?utf-8?B?aTZCMkppbGpDS3BPMWxheGs1UHN2WkNIaVRWb3ZNdUdrdGtZV2tCYitENlpS?=
 =?utf-8?B?MStMN1F3TElRMWwzNWR0R1J2L1ZCL2s2cFFzTjJWMFBYZll3bGVSMFZlN1ht?=
 =?utf-8?B?cVZEN0xrWTRoV2FwNDN3VVJzclpoMXVaTEF6ZHpKSUczUTJidG1JQ0FPbVpq?=
 =?utf-8?B?UG51WUJ2ZklYUURGNU5RbDdyTExoNEdYaDBtbk82VEJJYmdON0lIOU9rbkQ3?=
 =?utf-8?B?aDdMVWkxWFUvSW5LNEk2VU9TUnU1K29NL0ZsYVRUQTNWVWR4NFVuREVicWIv?=
 =?utf-8?B?MUM5NEJIVHUxbkhaMy8zMEZXUGhsejkwSWNOR052TE1HMWtIY0tBRDR5Mm82?=
 =?utf-8?B?TzNwa2JndUlzMVRhdldRcVVmQU9BWXRiQnQ2YWZ6a2krZkxpUlhBRml2RWlu?=
 =?utf-8?B?Z2x3Y0F3MUFnZ2p5eFZGWUpJZnhYbzAyMjJhajAvTnVDRmkzMFdKVVUrUldh?=
 =?utf-8?B?RGYyRnFTMVE3S29ZVXpSbi9mS3FBaGQ3YlRObG1WZzJXZHZldHNnUTVCTEcz?=
 =?utf-8?B?OHBUVjVQZ2pxUlNjQWdUN09QZ3p3OXpnRldpMVY0cGlaREdqTm50cWdQa1lH?=
 =?utf-8?B?ZUR2L05lY2pOdGhXbVA0UjBacjRqMXdFTGZIYTZEcEdwbmZXZEw4TDBUTXN0?=
 =?utf-8?B?SFk3YWU0NzhSOUMzYURNdnBFVXlLY3I4VXZSaVIwb0Mzd09HVVlIZXJrNCtq?=
 =?utf-8?B?UFNaRW4xVGdQbWR1aThoUDRxWVdxOTBLZmFKUkhDcUQxcUhMdTJpL01RSCtN?=
 =?utf-8?B?c3NhaHB2elNPa0dWa2wvV3o5elpsZjhYak96NklFUExQNnVpRVA5dz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c23e81-7b5a-4899-5b1f-08df2a1bb78a
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9647.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 17:51:04.3011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dfbh/Y6WbgiVJ4GCuwPwxp+S02Sw8h4Eyi6bZcWgFIwsRXh6vn405is6iDBGHZaWySjgZG6/0iQSvITv3eeBJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7583
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96B331C0005
X-Rspam-User: 
X-Stat-Signature: euozd3gp95zzo8opjrc6etz7iyxioexn
X-HE-Tag: 1792000272-33931
X-HE-Meta: U2FsdGVkX1/jCFNxeNhbDf+/CniOgeFslyo/wIzzehX0Q0y5FQZorCFkbZuE9gi8U6zZ4s9ZMSnnrCabijA8Nway11nkNkCG6dI9rz0A0R23xVtkf47I3u41fFLd7zDh9mDi6npC+l6HARfcOsl85Q8JMgtcq3++yXnE4lPXISJpBrIDHary88cdtfAFmu+OQzTkp1fpvI4GEqGEX6Bb9lygnGSqYme48qeWsWGR+l0wPwHhipWvcFAaWV1VbZmnOnCvl+cFmYRjY+06Ll3DC5lg6chTq97GyEpah0mWTZhbPN9JVRCtN7J5JQGiuy5HFeuUlKDjo3kFJayWJUGJCjvt49WkDdjJkG2uwVjGiZo1kYQzpZ1A+03KsuffFTp37VV4UU0elGqL+T42wXXieL3MYQoPy+FUWPwoZFHas7IDkHjTr7jo7ZtTQtx65E+vo3A21L1xn1xQfTfxASWYjuzPTb+N9iIoG0yxLHiqnl5qm+k68WIlx6GogzCLwnvKe/ggRuJeN1ak1TtAFg/F0+fTFXLdr/vS8BmW921NDmAjO6HiBt4S4SWcgS+f1KadahPitX10g8B5i+Ohne3BKRCiUwX+sg/pecW8OPkl3qIdUktSSTKDrDElBDpBgiPlQ1T5izIkd5Q2jKfEZr0cdCPThpoe3qYzFsHmXW3dC1tklStivj2S4aUFucywu5dfVM0PPLT0XcS/TFWXYzPvNVmUx8g+AE6ndogPn0eFfnmJ/3hqn+Vb7dWhs3NoxbaFY44F6y8MV4afMrODVqPPzmEvITIIhL2V2pI6hU/xXxyR0+I9KlfVbIl4hcZ6//J4Zr1BqnSekX3bfGkw6HRnzmLV4sPlCyUDEjBV1YkDVwEKlTPMLOaQNPhkAUFlL3TsBNGR4ijvWCt+Tex1O1PmZaTJ+qRhktGhfqtSjKzgXg/yrg5EgQIRaCpbezrGjwZ4AZbA9NGhwCCavynMd7g
 Kjh+QHok
 bVKs2PNXavzprzVKdllUfAbuUmQ120CHsVxa9JhjvQxUH07nud5nSbQ40PNziVqNod5RXyaAQ+cRBr5BM461eBfU2/D4LDKpI2ebQjUHe0cVLlmh6JOS/M4lmggin78PkAdX1Y0YoyLpMaZW3YPK7/ZbGI3tuCGoum3cje5TX3EMaQiwd6B5rgFZd9cdejk+6jlLZ2z/PNnIqpUk8O6nr1UqPN+hhs0+7cTFyP8DDRC4IKiSM/5uwq0cuKA+UQ6HstTTm4iUkZZVgLlRt8cLX3RepPcWP/Y0blARX0kXhoX1Kc7VQcAsMREtr+onxGgMQcXXC/shp/+mrVwrnule7JZuCCkG1+6CoCVxT3uwYDttlMRA6xKWUO53fuMyJyfZH+wX4SyulwfcEM31M+lC55YhNkhImADvaYFQd2ZN2g4nOkXL0JqWqeFeB0ksMhOsbecCOfw2ASASzI6/rnon9aFSGe+JWT7tzf6eABaGz1o5rGZiw4YZtWYar9/YIw3V6i2GHb0v/3IbrJCST/PA6AlaMi9DsVrmo6EdWgTprZKqVpGfnPlLP9XK31Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14.10.26 19:22, Dragos Tatulea wrote:
> 
> 
> On 03.10.26 23:22, Luigi Rizzo wrote:
>> When dev->dma_pmd_tx_hdrs is enabled, allocate a MAX_TCP_HEADER
>> bounce buffer per TX DMA FIFO slot out of the DMA_PMD arena. When the
>> linear portion of a transmitted packet is at most MAX_TCP_HEADER bytes,
>> copy it into the pre-mapped bounce buffer instead of calling
>> dma_map_single()/dma_unmap_single() on every packet.
>>
> What is the difference between using the DMA_PMD pool or one (or a few)
> coherent DMA (2MB) buffers allocated by the driver?
> 
The patch was actually using the coherent buffer. My bad, sorry.

>> Signed-off-by: Luigi Rizzo <lrizzo@google.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 ++
>>  .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 ++-
>>  .../net/ethernet/mellanox/mlx5/core/en_main.c | 14 ++++++++++
>>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 28 +++++++++++++++----
>>  4 files changed, 42 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> index a3945195f454e..d762ad1c1ffaf 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> @@ -442,6 +442,8 @@ struct mlx5e_txqsq {
>>  		struct mlx5e_sq_dma       *dma_fifo;
>>  		struct mlx5e_skb_fifo      skb_fifo;
>>  		struct mlx5e_tx_wqe_info  *wqe_info;
>> +		void                      *tx_hdr_bufs;
>> +		dma_addr_t                 tx_hdr_bufs_dma;
> Why are only headers considered for bouncing? Because they have the
> highest mapping overhead?

I meant to say headers and small packets.

> 
> Note that TSO/GSO packets will copy the header inline in the WQE
> already. But not for small packets.
> 
>>  	} db;
>>  	void __iomem              *uar_map;
>>  	struct netdev_queue       *txq;
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> index f2a8453d8dce0..6de7a2a430d72 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
>> @@ -365,7 +365,9 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
>>  {
>>  	switch (dma->type) {
>>  	case MLX5E_DMA_MAP_SINGLE:
>> -		dma_unmap_single(pdev, dma->addr, dma->size, DMA_TO_DEVICE);
>> +		if (dma->size)
>> +			dma_unmap_single(pdev, dma->addr, dma->size,
>> +					 DMA_TO_DEVICE);
>>  		break;
>>  	case MLX5E_DMA_MAP_PAGE:
>>  		netmem_dma_unmap_page_attrs(pdev, dma->addr, dma->size,
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> index 4c6060d54fbed..efd766aa43a02 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>> @@ -1666,6 +1666,13 @@ static void mlx5e_free_icosq(struct mlx5e_icosq *sq)
>>  
>>  void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq)
>>  {
>> +	if (sq->db.tx_hdr_bufs) {
>> +		int wq_sz = mlx5_wq_cyc_get_size(&sq->wq);
>> +		int df_sz = wq_sz * MLX5_SEND_WQEBB_NUM_DS;
>> +
>> +		dma_free_coherent(sq->pdev, df_sz * MAX_TCP_HEADER,
>> +				  sq->db.tx_hdr_bufs, sq->db.tx_hdr_bufs_dma);
>> +	}
>>  	kvfree(sq->db.wqe_info);
>>  	kvfree(sq->db.skb_fifo.fifo);
>>  	kvfree(sq->db.dma_fifo);
>> @@ -1690,6 +1697,13 @@ int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa)
>>  		return -ENOMEM;
>>  	}
>>  
>> +	if (sq->pdev->dma_pmd_tx_hdrs)
>> +		sq->db.tx_hdr_bufs =
>> +			dma_alloc_coherent(sq->pdev,
>> +					   df_sz * MAX_TCP_HEADER,
>> +					   &sq->db.tx_hdr_bufs_dma,
>> +					   GFP_KERNEL | __GFP_NOWARN);
>> +
>>  	sq->dma_fifo_mask = df_sz - 1;
>>  
>>  	sq->db.skb_fifo.pc   = &sq->skb_fifo_pc;
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> index 0b5e600e4a6a9..3b6a7a8b0128e 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
>> @@ -177,6 +177,27 @@ mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
>>  	return ihs;
>>  }
>>  
>> +static inline dma_addr_t
>> +mlx5e_tx_map_hdr(struct mlx5e_txqsq *sq, unsigned char *data, u32 len)
>> +{
>> +	dma_addr_t dma_addr;
>> +
>> +	if (sq->db.tx_hdr_bufs && len <= MAX_TCP_HEADER) {
>> +		u32 off = (sq->dma_fifo_pc & sq->dma_fifo_mask) *
>> +			  MAX_TCP_HEADER;
>> +
>> +		memcpy(sq->db.tx_hdr_bufs + off, data, len);
>> +		dma_addr = sq->db.tx_hdr_bufs_dma + off;
>> +		mlx5e_dma_push_single(sq, dma_addr, 0);
>> +		return dma_addr;
>> +	}
>> +
>> +	dma_addr = dma_map_single(sq->pdev, data, len, DMA_TO_DEVICE);
>> +	if (likely(!dma_mapping_error(sq->pdev, dma_addr)))
>> +		mlx5e_dma_push_single(sq, dma_addr, len);
>> +	return dma_addr;
>> +}
>> +
> This looks like a form of tx-copybreak.
> 
> Thanks,
> Dragos



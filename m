Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3380CD98F0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 11:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECF26B0005; Wed, 17 Jun 2026 07:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E526B0088; Wed, 17 Jun 2026 07:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765266B008A; Wed, 17 Jun 2026 07:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3903E6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:33:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6D1DA03B8
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:33:15 +0000 (UTC)
X-FDA: 84889193550.10.E70F5F1
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010038.outbound.protection.outlook.com [52.101.46.38])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7D69A18000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 11:33:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=U9MnqBg4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.46.38 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781695992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yRJboO0RjurOfZXyxiyJgF8K4+7/HUvvXkSIayyWwnU=;
	b=zDOp73Cx1HsC9B63Qg0yFOMVa1x9hG+/KkPK2tj8l1Luujm3hqh4xTojaKUk266g7/Qgtx
	WdKDyTO+UlfXnElDILAVIRHPZk0OAMNIQL8RDqwj4Ywt+iMU/WA+wtgCBgyIVcqTE4FuQt
	vrb9dzO0qWb8ZcsGKejrHDz0XORtz1Y=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=U9MnqBg4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of Pankaj.Gupta@amd.com designates 52.101.46.38 as permitted sender) smtp.mailfrom=Pankaj.Gupta@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781695992;
	b=bJlshdCtCi0w/19mZo5QL5SaL616ziedGDMfcxt09l0/UhZ9/urmgwVUhM8YNIzgbCL9Bj
	NgIYiNI96wMb2p63iFYTQU8aKEAGaeIOmX2KNMwAinNZ3kyHCxEVqyUczvcb4RDQie2KUx
	xmSAfz5mdO20rIv2eVl+7WhxYRXaQYY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yzo8hTYyi1PNV87pFTraIKBbQ48X+XaRUKUF9vO3IBViuOBKJGIy8Jkv9P9EabCrU8413mMeL0ls18HWyrgY5lxTe5znj9c95AlSmwW71TOcVOb9LUwYJTc8XRCOV2h4TIcPq7UT28clqmNrwc7X1Rl+pGKmaWPxZT6y+kBlwKQelOUNNn0bMDSdoybcIYHNIDJRFif5fKGXUMLFaUjRR31p/o7tzVFWdAfEHMMnSLb2Al9ENRKfZy1FGNWUNWFQrsnOOSCP1ClYAVMZM/rFHBsmsi1IInuxAue8S/MORHyuSa6cJoXUBjV5/EZqRlFDP2OTCM0dz8RCqUOt3W4Mrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRJboO0RjurOfZXyxiyJgF8K4+7/HUvvXkSIayyWwnU=;
 b=pIMda/neUCB+x65Ky9F6GWloLGhgFjERLqbpqy7Tx9GQpeQvqsOEka53/zJ7fQzLn344RhNUCf9ecuyU//xj+nS2b1PZg1fo7CBM6DDVetjo8CgFTrhUMt1EjGS0fXyZx4PjivdBVsyrbuC+GKKIFxnI5ME1bBSGagtTkKs55AO5SAtWjYR80OZDbwxDMm+WL8uEI8jdtDek7eRPuRYoxDSN+dsuI8ShB3fRms9rEgHlxEnuXqw8+znQIN6ubzlroPVyQdoNhEZN09tFCM01mhgIR1d+y9gJFIKa/31BxYjCekJS0gOjUzYZQKKFq/PhEXSP9icE3FdnhK6olVmqIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRJboO0RjurOfZXyxiyJgF8K4+7/HUvvXkSIayyWwnU=;
 b=U9MnqBg47C2dKZ+3qcIuuYW9LdJIX4jElwE9QcllEXdaVsIURaUxAttY1k0ewJjcSJhwNWDr6u6fCIxsE6ECA9ytSqlP8MokUhK7DmHamcQrB5vpQ6g5JzW5yrd3pqY2WJ30oVIPA2urIZcx/yjnjMQDBOx0vJhqRYD9Zw7jBLY=
Received: from CY8PR12MB7433.namprd12.prod.outlook.com (2603:10b6:930:53::22)
 by SN7PR12MB6837.namprd12.prod.outlook.com (2603:10b6:806:267::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 11:33:06 +0000
Received: from CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6]) by CY8PR12MB7433.namprd12.prod.outlook.com
 ([fe80::faae:d638:bdc9:4bf6%3]) with mapi id 15.21.0113.015; Wed, 17 Jun 2026
 11:33:06 +0000
Message-ID: <fe191e75-29b3-49c1-8c54-55d41b3e786d@amd.com>
Date: Wed, 17 Jun 2026 13:32:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/22] mm/page_alloc: implement
 __GFP_UNMAPPED|__GFP_ZERO allocations
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-20-28bf1bd54f41@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20260320-page_alloc-unmapped-v2-20-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0353.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f4::16) To CY8PR12MB7433.namprd12.prod.outlook.com
 (2603:10b6:930:53::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB7433:EE_|SN7PR12MB6837:EE_
X-MS-Office365-Filtering-Correlation-Id: b7040658-84ca-4350-fd3b-08decc64335b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|23010399003|1800799024|921020|18002099003|22082099003|3023799007|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	KLJzD4lexIcDIrvqXYQnyHqaHDLG9r0n2Nzi4PGZWE43eAwybJZ1gQB7CXzaQVx822/bN1EE7sStar4jI2EqB+G9tDA8WOObVrswS67F/XxYlQep+kEMJCSdk/vVij4rq/u3z8ijf0L0b+VOJP56MELxcDNYLi+DMFlMrb5QOkHFghXD6nTuYDZVNZXgq23HSOVardFpaouZZWzSCqAl//ujt6DqCLeNRDEGgSDfNdV+RRXmd6MmlccXcsNV1IVWw00w4d6WqkODGmoi7uPSaEUaftOwyjaMXuDi6qzmEIfk/Zdl1SZpUOhvDP87yJbsPwN6+NcVSWqLJzNyC9m7oLzU4VPbeoNEkS2JVGcmlIAryBGk2HQMfyMYcwWi9f735JtyruGLah/FoIccpWGscpHraByG5XN+9P8Sa1ULnihqg/UIcbyjMdZT/QB/yIC7TlmRiFnjq2FReQ+tewF7LB1qOZTd3/s6juzSh+yznItlHMwbP9KJe717pqMk2jU3Vz+LaSGXaKs764AS92BL2xOSv4GMamaWZf8RS1+udbipv7xJLls4J+8hmR95k6mGUuVKosmmnNNIGTsmbcgmVFBI9+SB1/ltRny7Br2vA6r0eBsItSkpG6XpRbNb9noE4Mp/FnDPN7d2XrZ0jmV+ykNLb9+CYKmoMUMEdNwsfhvCx6nxKIc6gwv+YiKV6w/W9I3ws5YDUnTrAyuGLY4E+ez33A+4IxqrJQyr+jn+zrA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB7433.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(23010399003)(1800799024)(921020)(18002099003)(22082099003)(3023799007)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SXh6Y3VUVWRHYlFDVng2TzBOWmRFT1BpWXRvdjgxT0lYVW5oM1RxTjRVdXI0?=
 =?utf-8?B?SzdsK3lxaE9ncVJnZEhsMWxMSnJzaDFGa0VhREZSdm9KMXRtSkQxNHF5Skt1?=
 =?utf-8?B?OFY2ZXZTVVZmdWJpWnZzZlFiUVB1V1dTclVZTlNGVER2K2tNUXVTcWI2N1FF?=
 =?utf-8?B?WmttSDRvMis0Z3o0Vi9rMGFGbTFvZDBzdGYvT25SMDN2VndFQnBXbTlqZ0JK?=
 =?utf-8?B?NzFQQlJUekxhaHI2VnhTVnlOWlBJNnFnMUNYMGtKd2Z2S3ZXSWxFeDlvOERj?=
 =?utf-8?B?Vy96Wi9kOFh4V3p2M2tleEhaRzZnNGQxK056cnVaM0NRMk1WVUk4b3N5dXha?=
 =?utf-8?B?dWZSUk1sZFFLZFNIUm1mUlNhSk9hMkp2dWx2eXRmdlVRM3FwQmx2dWhHMFBy?=
 =?utf-8?B?Q2NvQlgwVE5iKzg4dmU4VTZKbmZtQ3liT0xXZEJPZFYvTU5odSt2OFZVKzk3?=
 =?utf-8?B?Vkt6Tmh5T2owdEFLdCtIMHpaOGxJTG8xYlYrRWNaUVQ3UFRHWWhzZlNxUDc4?=
 =?utf-8?B?TzNTS3daaDFJTFdCMEFYNllSSEhOTFAzNGhrOGk5WG5HSlJ5b0xBK2lYTkQx?=
 =?utf-8?B?OFUzOElNeHFETklvYUFVYkVRY1VZVUtDRjZUOVFzaDUwaEdnRUVxMHQ5dVhD?=
 =?utf-8?B?NjJuKzBUcFhzM0pUMktrVlBSTzhESk81Wk1ETHVHS3NxSnAzWFZMd3JjTGJs?=
 =?utf-8?B?VlFWTHovb3lCK08rZEcxT2VwV0RkVFEwL0lBVFVNTEdWd3ZLOWFaaENGMW1a?=
 =?utf-8?B?Zk1BSUhvOVY3b29mT2wyOFExT1hnMUt1ZHpuT05RT2dZSUhVVGgraWg0cGpZ?=
 =?utf-8?B?Y2JKWTZOSmYvVmNtREhGaG5iN2twcGZCazc4eENsaVNNbzB1ZDl3dktsRUNE?=
 =?utf-8?B?OGIwaVllaVY0Ymc2MTRCZzR2MS9RT0VVR3JTNXlsbXViejF6STZDWFU1WjZV?=
 =?utf-8?B?aUNTd3dsd2hWZVZ6OXFtWk9uWXZLVitWMkRid2QycS9kOThHelNkeTJWd1Ru?=
 =?utf-8?B?eVBQWkh2V1hiM0M3U2g1RGw2RDBBeCsvTlVsU2QrejM2YVM4K0pwTUxPa1Y5?=
 =?utf-8?B?Y2F6K2czMnFXak90dGFTeUFQblgxMEE3bFNwM2FSNk1LdjFvZHg5dDl1NkNQ?=
 =?utf-8?B?SnJtTW1SY0llQ3NleTVLRHlaS3dRWUtUeS8yVDlKc0wybjE0Qll2TzZnZWQz?=
 =?utf-8?B?WG9sQW54akdCL1lVbStnVzRxSFZxUHZ6SkF3SW9vZWpvQTlqN011UVBQUG05?=
 =?utf-8?B?TUN6eEVtbnZDSE1hV09Pdm9idGxVc01BYTZqb1Rndktxb2hlaTY1cmFqWVMx?=
 =?utf-8?B?bHp4RzhaM0dMaGdqZFlPa0srMEFGOE5tNnVnOXlGUGRHcmVsTkgrWmxPWDVH?=
 =?utf-8?B?dFR5aSsvelJHSkw4aE4xUDByWHFWY3BnY3d4TFNLamQwTmthRFREMDV1MzdO?=
 =?utf-8?B?QUVvOW96MXRmSWx6MDBzYityQTJsMkRKQ3VFRlU5bWZWbmY5ZzduaFhOWU5J?=
 =?utf-8?B?TlJzNmljKytReGlYWnhBWmsvdXMvOS9leUtXOVdKSE5MbC9yWGhxMFJKblJz?=
 =?utf-8?B?OHJVYjBvWVYxd2pueHFrSW9FUUFlNW9HZTUzYVFVQkpXVlZLdjR0WCtERDlD?=
 =?utf-8?B?UFc1VFpVaUxhQmhiYk5oNnZOc3M5YkxSWm9IUlE1V1Z4TkloMWp1RHBBT3Nz?=
 =?utf-8?B?STh0bnJnZldqVGRMdlQvMkdza2N2dHhDNDB0Zi9nbmZQRHJHZjEyVmszRWtY?=
 =?utf-8?B?WVBxNG9lS2NuSitKaWtYdThzNGw1T0Qwd0prbTRNeFdUcWtCK3BRWTQ5aTZV?=
 =?utf-8?B?WnpaMkdyalBHZWdlL0pJK3BBRGJaRmcwZnkzTmd2cUNRR3FlbFdqUXcxYTdh?=
 =?utf-8?B?Y2lEbWNOdGxkTHV3dmM4SmxBNk9UTGRkZGlXU3VIL2Q3TXlrWnplZTdSYm5w?=
 =?utf-8?B?WEJTY21IZXFBeERqdEc3WEtwM25FM2ZNSmplVkRtcXRWNHdRVTBYYmo3MHls?=
 =?utf-8?B?bndMQnNRMFIzQWxDVXFqQ2RPakhrVTNYTXEwVTBKa3JwR2lWNjBzQ2REdmNL?=
 =?utf-8?B?bGYzSitTRGJidFQ2cUl5VHJUYlU0RlpZbU8veGZPVGFvcFdvNDRVdklUSmsw?=
 =?utf-8?B?Z2J0VmhKSEMvVlUrUmlkMnlMRFBWL2NQa0dZcVc2akZlS0R0QnU3SThmRTA1?=
 =?utf-8?B?ejFIUmlOVUsvQVltMTFBd0pxaytwbUdBc3RGZVV4WHdnTi91RWZNYkFtU3Yw?=
 =?utf-8?B?eUtxVHZEUHI5OXpjbElsdXBoTlFMTDRWZHUwR1huaXFweitsTlhjTUY3RjZG?=
 =?utf-8?Q?tim2cyu7Crmh9xhFYG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7040658-84ca-4350-fd3b-08decc64335b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB7433.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 11:33:06.6383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4B4/OllLEJmI4AkWkHou7PfPf2FdzON79V9B5qu0c6vkxi1Pds3WJC1wOgC7xonl76oGdGWu2ADNnDMdEZ3kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6837
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7D69A18000A
X-Stat-Signature: 65bj9easj8i158wh6pnjgygzz63o9fzc
X-Rspam-User: 
X-HE-Tag: 1781695992-159470
X-HE-Meta: U2FsdGVkX18A72YLnr2ODCTTAU4+ZYtv3h6TfR711dAMuq3xo9Dwrd+o2UVIet+SsMebEZ4M8qNx39Shz+qkOQYNlK+hORmr5zFcY0Ifda5qu1zT2tMFQWY6jhTpurAUmileFq4uSg9R6oqty9F7GeyfZORsN/7xa8zT54L86OHuaZiuxqRwukacjodFAOMy3ohdPiG938FAUyi0kSvWU5+6KKhsSlIwXVHs/+0yAKCXBHNxru2lVj8sP6j82w4+jg804m3KjvDDaoCHjiUSZl86Y4Z4J9EjAj2fdF0bCR1R6vroERYTYC4GDb2+SvUVeSCLcFDzd8N6D/WBwpaa3EZ03+vk80pg54OI1WtxKWtuMn35wrznHpcfTotJI/Wai8ySK4iWUf+HK0YvWbjX3X2gVAHHgjbAvQURRsPg3+jp/x7kIS8y1jqwJEc4KRyxtWqW4G4HytsZvGC1SVaH3dzVKaEQbpEQBPiyk6pvmcf7iBgvWddhgfGuexre/d37B5qEI/jmuvhlLxuvwp92ENcR+YVbOZ6J8QGfc636VrnG+elSVuEYuOHBuPlnJuozhDmpc4nIfus8zgDwxO4V+BY8Acdap+yw1RWUv3CFO/SyuM0Hv9WMOQDYKrkkl/v/mUvYXmaPs04NuFsJ/HEvfb9aDgcTwnMJf6Qi21hf4jNcVVHU6QysKHHmx2CEObPRZ8qtkHOeXnRMOOZpjA1Z3PsEwzXist3+cZa8ykKYbEe3Q6NYj3GL4t3hYcMlwoGO7Iml7V/YATzL+k1/LZRKe24qEekSy/4ianHCYGrgpUQhgFia149W4maKUckg3PGyYSsRzgW8MOJ1LbdH8OwSrW23Y7g9pGDkLpSihAXHEr0zZLOoyuq0wsaOXthbeFTkADmT+MzVvwfkMRNllp3jRF7YwUo0vUbnuZ25/xTLG9xTu45GJ+pHCGSxdS/tkMVIK7T+TBzYNVLYJNUcCYb
 B+w2uWjE
 8bNKBTOrkjGDs1QJpYhtHegBM61EK+DDUza/7LIFWn8XCdUCqBSpbjED/WvAUK+nGz0DgU+4Uwy2thERc5tSkKLxeiVnKhOgozqb2ryBroAq76JxdcKNrGY0AEzrsPbBd7Pg/WNDYIx2QoPs6/7qJDp32IJj7n1Zd1I+BV4U6j3ryaztdIE6C4AN2ssmue2nZt9Jj+SA+SsUxnU2nu1eDPLtbaE8byhvICT71eLLCs6NCJACUZKMH9lsAcCZEgQ4M4FQ21OjI8l6NcxJcJ5G92/gco66iEs167TD3oorq9Zu0FWhsDZXPlwSPFmVi9P1edXXRrxgcvo6a7tsYsrZlfwGoN7tmKj5nzrFDS+1cvESG7irq/jKb2r70GJ1YC9QI4Xa+RP0AHvEBQANmrILn/E+WiximtkzFMQhIR2mLoSHvu/Nu6/Cw/F1ML4VStvNhOxT7tMDSDswSRQN954eLHWVB4IaObGxBIlxLyuTRQiK/SEwsZhzbb5ZV6bT08yYJUc+N5owHU9jRRzo4NMzato1Dfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> The pages being zeroed here are unmapped, so they can't be zeroed via
> the direct map. Temporarily mapping them in the direct map is not
> possible because:
>
> - In general this requires allocating pagetables,
>
> - Unmapping them would require a TLB shootdown, which can't be done in
>    general from the allocator (x86 requires IRQs on).
>
> Therefore, use the new mermap mechanism to zero these pages.
>
> The main mermap API is expected to fail very often. In order to avoid
> needing to fail allocations when that happens, instead fallback to the
> special mermap_get_reserved() variant, which is less efficient.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>   arch/x86/include/asm/pgtable_types.h |  2 +
>   mm/Kconfig                           | 11 +++++-
>   mm/page_alloc.c                      | 76 +++++++++++++++++++++++++++++++-----
>   3 files changed, 78 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
> index 2ec250ba467e2..c3d73bdfff1fa 100644
> --- a/arch/x86/include/asm/pgtable_types.h
> +++ b/arch/x86/include/asm/pgtable_types.h
> @@ -223,6 +223,7 @@ enum page_cache_mode {
>   #define __PAGE_KERNEL_RO	 (__PP|   0|   0|___A|__NX|   0|   0|___G)
>   #define __PAGE_KERNEL_ROX	 (__PP|   0|   0|___A|   0|   0|   0|___G)
>   #define __PAGE_KERNEL		 (__PP|__RW|   0|___A|__NX|___D|   0|___G)
> +#define __PAGE_KERNEL_NOGLOBAL	 (__PP|__RW|   0|___A|__NX|___D|   0|   0)
>   #define __PAGE_KERNEL_EXEC	 (__PP|__RW|   0|___A|   0|___D|   0|___G)
>   #define __PAGE_KERNEL_NOCACHE	 (__PP|__RW|   0|___A|__NX|___D|   0|___G| __NC)
>   #define __PAGE_KERNEL_VVAR	 (__PP|   0|_USR|___A|__NX|   0|   0|___G)
> @@ -245,6 +246,7 @@ enum page_cache_mode {
>   #define __pgprot_mask(x)	__pgprot((x) & __default_kernel_pte_mask)
>   
>   #define PAGE_KERNEL		__pgprot_mask(__PAGE_KERNEL            | _ENC)
> +#define PAGE_KERNEL_NOGLOBAL	__pgprot_mask(__PAGE_KERNEL_NOGLOBAL   | _ENC)
>   #define PAGE_KERNEL_NOENC	__pgprot_mask(__PAGE_KERNEL            |    0)
>   #define PAGE_KERNEL_RO		__pgprot_mask(__PAGE_KERNEL_RO         | _ENC)
>   #define PAGE_KERNEL_EXEC	__pgprot_mask(__PAGE_KERNEL_EXEC       | _ENC)
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e4cb52149acad..05b2bb841d0e0 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1506,7 +1506,14 @@ config MERMAP_KUNIT_TEST
>   	  If unsure, say N.
>   
>   config PAGE_ALLOC_UNMAPPED
> -	bool "Support allocating pages that aren't in the direct map" if COMPILE_TEST
> -	default COMPILE_TEST
> +	bool "Support allocating pages that aren't in the direct map"
> +	depends on MERMAP
> +
> +config PAGE_ALLOC_KUNIT_TESTS
> +	tristate "KUnit tests for the page allocator" if !KUNIT_ALL_TESTS
> +	depends on KUNIT
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Builds KUnit tests for the page allocator.
>   
>   endmenu
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 710ee9f46d467..7c91dcbe32576 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -14,6 +14,7 @@
>    *          (lots of bits borrowed from Ingo Molnar & Andrew Morton)
>    */
>   
> +#include <linux/mermap.h>
>   #include <linux/stddef.h>
>   #include <linux/mm.h>
>   #include <linux/highmem.h>
> @@ -1327,15 +1328,72 @@ static inline bool should_skip_kasan_poison(struct page *page)
>   	return page_kasan_tag(page) == KASAN_TAG_KERNEL;
>   }
>   
> -static void kernel_init_pages(struct page *page, int numpages)
> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> +static inline bool pageblock_unmapped(struct page *page)
>   {
> -	int i;
> +	return freetype_flags(get_pageblock_freetype(page)) & FREETYPE_UNMAPPED;
> +}
>   
> -	/* s390's use of memset() could override KASAN redzones. */
> -	kasan_disable_current();
> -	for (i = 0; i < numpages; i++)
> -		clear_highpage_kasan_tagged(page + i);
> -	kasan_enable_current();
> +static inline void clear_page_mermap(struct page *page, unsigned int numpages)
> +{
> +	void *mermap;
> +
> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHMEM));
> +

I was thinking — would the fast path read better if we moved 
migrate_disable()/migrate_enable() up a level, into clear_page_mermap() 
itself? i.e

migrate_disable() -> here

> +	/* Fast path: single mapping (may fail under preemption). */
> +	mermap = mermap_get(page, numpages << PAGE_SHIFT, PAGE_KERNEL_NOGLOBAL);
> +	if (mermap) {
> +		void *buf = kasan_reset_tag(mermap_addr(mermap));
> +
> +		for (int i = 0; i < numpages; i++)
> +			clear_page(buf + (i << PAGE_SHIFT));
> +		mermap_put(mermap);

migrate_enable() -> here

Right now we split the migrate_disable/enable() a layer below across 
mermap_get() and mermap_put().

Would it make sense to embed that in the clear_page_mermap() API itself 
— mirroring how we already disable IRQs at this level for the 
mermap_get_reserved()?

Thanks,

Pankaj

> +		return;
> +	}
> +
> +	/* Slow path, map each page individually (always succeeds). */
> +	for (int i = 0; i < numpages; i++) {
> +		unsigned long flags;
> +
> +		local_irq_save(flags);
> +		mermap = mermap_get_reserved(page + i, PAGE_KERNEL_NOGLOBAL);
> +		clear_page(kasan_reset_tag(mermap_addr(mermap)));
> +		mermap_put(mermap);
> +		local_irq_restore(flags);
> +	}
> +}
> +#else
> +static inline bool pageblock_unmapped(struct page *page)
> +{
> +	return false;
> +}
> +
> +static inline void clear_page_mermap(struct page *page, unsigned int numpages)
> +{
> +	BUG();
> +}
> +#endif
> +
> +static void kernel_init_pages(struct page *page, unsigned int numpages)
> +{
> +	int num_blocks = DIV_ROUND_UP(numpages, pageblock_nr_pages);
> +
> +	for (int block = 0; block < num_blocks; block++) {
> +		struct page *block_page = page + (block << pageblock_order);
> +		bool unmapped = pageblock_unmapped(block_page);
> +
> +		/* s390's use of memset() could override KASAN redzones. */
> +		kasan_disable_current();
> +		if (unmapped) {
> +			clear_page_mermap(block_page, numpages);
> +		} else {
> +			for (int i = 0; i < min(numpages, pageblock_nr_pages); i++)
> +				clear_highpage_kasan_tagged(block_page + i);
> +		}
> +		kasan_enable_current();
> +
> +		numpages -= pageblock_nr_pages;
> +	}
>   }
>   
>   #ifdef CONFIG_MEM_ALLOC_PROFILING
> @@ -5250,8 +5308,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>   	ac->nodemask = nodemask;
>   	ac->freetype = gfp_freetype(gfp_mask);
>   
> -	/* Not implemented yet. */
> -	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED && gfp_mask & __GFP_ZERO)
> +	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED &&
> +	    WARN_ON(!mermap_ready()))
>   		return false;
>   
>   	if (cpusets_enabled()) {
>


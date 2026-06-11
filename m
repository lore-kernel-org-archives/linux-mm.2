Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BFA9CD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 01:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 242476B008C; Wed, 10 Jun 2026 21:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F31B6B0092; Wed, 10 Jun 2026 21:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB8D6B0093; Wed, 10 Jun 2026 21:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB8FC6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:56:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 874EF40203
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:56:17 +0000 (UTC)
X-FDA: 84865966794.07.D39E4D5
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011036.outbound.protection.outlook.com [52.101.52.36])
	by imf29.hostedemail.com (Postfix) with ESMTP id A4B11120005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:56:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dFRgqNMF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781142974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gMhaU1rcwWd5y7h7VyG44wBjpQRaVYLz9XuTx7cm6Vk=;
	b=VY41XMBfi5pidOs9BAPIPc/GZ6XmaiAFSX+zktiDEWdzK7Bmj+YjOAnaRDdiP5ftLo5Xod
	qr//KnkLAwhyjwkcAvbaDSblD1AfpRR6FjZbVDy4faFT0cr/WuyYYvjiFKRdzWtq+nyf4y
	nZzxlFf2o5Y+IlSMe3kJuI0MYFak1LA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dFRgqNMF;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781142974;
	b=vAItPGs7G/d8fDzcuvttSkq8mFBUhk17WD2SASw5e6yrHKfih3joItuHWlKOUYtqI5kLq8
	r2VcNV9R6Hzj0tLs7iDcIGcECMZzq06IyMFSTd+ersrGiEEViOpePxkotk1Ltu9QmB5JqH
	zrDt1orYWsGvWF+ZoXNzPhVb6OssJYo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gry8uqeYWTueD38qSXvwwokPsLc4ywKWssP4INjej/ZoaF0sapsrYxdBs7v8lwbYusdGQFBIm/eUuvxE48sbmLm5A/kHTJygMNS7F3abcHIWbzT41q7yHWVdA+79x+9YBGklAlYk2mSxQgWEdrvNbCBmK1r4mQQdcB8WwYuyEkmFyH2Tm6570a7s/vqmKOeg3T9UQEFuR/Ql/s4xIpfTpA+3gW2RF6E6ELuP++uPPgMCjnjopLxI1WI0xHGexpmDxpbg9GYh6myNRoBAx0sPJJJrJ26v3TgzAWMpRlgd4CVExJ0k2T+LM5NuiIg6ILUd7fF1PCdXQ1TWr/L8uoNyMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMhaU1rcwWd5y7h7VyG44wBjpQRaVYLz9XuTx7cm6Vk=;
 b=vip6CmKTMZX9wcdx+Ilemq1Due6EEeR2yHgtyGpb1XJWCjjY51qP/rQKfNDzLUJH6/iAp4JYn6Q7gDwq1XRV1YhjEwT349j7CM0HPq9m7PH5dRUE242hTinJDx4dGYDUTDq8SYpqI4WDz6ihAU/2JEW56mTB6bKxuDB83lLKc4k7e948mrQsYSs1htF3mYLdHwmxDstJllVBETlvSXzHDh7B/G1fTJmrt9/UZ+VFprtmM7Ru8UkDIJsrHp3La0p78BPqDg0tJdkGkyqUagMtrY1YU0uBBs75Bq81ZNs4jd3RWapZ2eVix6zc0w1s330c3FkiyIgTXISy4zyfyrvHbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMhaU1rcwWd5y7h7VyG44wBjpQRaVYLz9XuTx7cm6Vk=;
 b=dFRgqNMFZZ4u1jl4nU6tgd9EMpwXUcWmx1uTsnup6jOKWs9Mo6VExxOxwONsLjuXuhBp4zjrzSQvdj6S1lSsG1jhT82rFU2xro+VBW0oVIqrLxwvIwzv2+Tn4Y791OFU6CdhL57HHYxRYvAu/rI4vUnTLcR5pq83m+MOfuMFiwzPAXh8j3ibCkxBHWjJ6qqPOMswc1KQJ/y8+hDTM4lEUEN/9Z99TXso8LOR5ytYf7IKHzrGpcCtIy0Z/Gll4ILXL///SIwJshLCQaJWIpgZRdDYBTR+YLO6d8Z0uKiUcIA2EiCDnZ/wIvbyqCCJBMLc7AbflIvim8gN94DtOtvlIg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8972.namprd12.prod.outlook.com (2603:10b6:610:169::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Thu, 11 Jun
 2026 01:56:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Thu, 11 Jun 2026
 01:56:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com,
 xiuhong.wang@unisoc.com, hao_hao.wang@unisoc.com
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
Date: Wed, 10 Jun 2026 21:56:04 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <2F9A72CC-772C-4691-9F18-77306EADC6CB@nvidia.com>
In-Reply-To: <CAGWkznFQH65gJO=xvxZLoDGWLu7YTCnSyfoy7JdLKV5eY8qLzg@mail.gmail.com>
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org>
 <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <CAGWkznFQH65gJO=xvxZLoDGWLu7YTCnSyfoy7JdLKV5eY8qLzg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR0101CA0136.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8972:EE_
X-MS-Office365-Filtering-Correlation-Id: b34825c1-e16b-4079-cb95-08dec75c9a3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|18002099003|22082099003|6133799003|56012099006|11063799006|5023799004|4143699003;
X-Microsoft-Antispam-Message-Info:
	39KdKSWtb5VyElOythI5g73cAxaN4Q5xMoQZCXc9UVfe7UqC+BxCYbq0neoTX1jQm1+EG3NxLIb2cvkisTmHGWedmcHN4MuKsotdWnNTAZ8FQo1LiwYGRUKutb/NN8VQLP4A/B6EIh/A96yNhrt/YxBBmSiTSdZ3BL8Vq1fserrBGkl9TGBmc6nxfSu5+ThofW7S75D1fW8P9CK+1tYQG0S9DUlHfsPWnT94idqNK4LQfA5n5SQSapK8pSXhmiL7Su8CE25i7qMwsnrrc8+X7awW200gsOXaEcROE8JHHYsFQBxOdX2CEw4AfOnsDVsljBMG8I3HL2NtWP6zOWSpEzo2AKsIFuDfHsKuJL5KK4jf07NwLOH4x6kAsZYNkUKFoo/5JVPchUC0eqvbqSGG7y9Pkffa2/0SKEqS3x/aNFVKHeqZC27SyLTOR9YnpVB6rQZuhIY5yyLERtvOXmtMddO3I2SNAb6gR3f1usT1MO6wyL7tDPjR6CvV+6TNNhm8+k8lkPaCyPMLeuHbqp6uX9zsI2uzcjIBtBHkxRUuPSmFjVA275TmfJP1OFkXmfvP8zslA6AhgAAtz2hrUU/uVWiJ6o5To7r1FHGrL2LnEX/l97O5F2QW7Ht+jSG7foVYsbj/iwMfje/6GXsW2gUWwlARispxu8FwANnreEIrgPHYre8Aq81CV7HWKIuh4+M1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(6133799003)(56012099006)(11063799006)(5023799004)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1A0WG1EdlFWZ09TN21XbStyQnZNQkNWeUpCQWZXRzROYllRMHdsU2FqRjIz?=
 =?utf-8?B?ZnpVbmZkOE1sZVQvdW8rSWtLVSttdlFjYStsQk5kME85TlBtS0sxNkhwc3E1?=
 =?utf-8?B?VU9oTTN1OU1Ea3pPWEhRNGRoRk1VMGlFT1B1M2lVL29RZi9Zbks4Sm5zVWww?=
 =?utf-8?B?TTNqdFhJSjI3ai9ObVR3Nyt0S3JCN2JSYjgyQjBUNDdsS21JMXpsZnd5cUtW?=
 =?utf-8?B?Sm9NVmcrbm0yYlh6bEI3RC9NV2VSS3ZzTmRGU3B5OXpWdU81OVBoOCtyZXZH?=
 =?utf-8?B?WFpEZmZMc3FDUmp3VWk0MXd5M2s1Z01JcUlzNXpQcWwwT0wreHFhMDArZ2RW?=
 =?utf-8?B?MzVxL1laQ0M4c0hSWlNiNnhHTEUrUG9uT2JvTTZXekVMOGx1alhjWjYzS2k5?=
 =?utf-8?B?MGUxdTlzVXlTUGt3Sm5RY3dzbVI2R1RZQW1PMi8yWE81cG1KbGRNUnZMUi9J?=
 =?utf-8?B?bmpMSllxTEdtcE9mS3lvKzRWS3Ezcy9kWkpyMndjZ3gyd2Nvc2FkTzFjMlNT?=
 =?utf-8?B?d0VpVWhOVXVYMWpUQUZNM1Y0SDFnS2dQdy9hNGhKTlFrbDFaWTFJd0xyQ28z?=
 =?utf-8?B?TFFoQWo1ejlzaU54cWpsdThhV01DcC9XcXdOemxmSXR3OEJTUG53TnhHN2ZN?=
 =?utf-8?B?SnFETzJzVFh3b1RyMjhtRzBNUHZJT0ZaTTM1ay83STl1dnRLMExLek5YSW9L?=
 =?utf-8?B?andWZU1kREhzUUxhK2hPTityRmJpS2Jzd2R5V0xNV2JsSDdFSEJ0Y3FkUW5r?=
 =?utf-8?B?U0JsUGlmNktjVDVFOHdQMGszR1pSbjVMSWtyZ2gyTnN0YXFuM1VCNTh6Smp5?=
 =?utf-8?B?UVhseFBnUkNOWlk3RlVCSytCQWRVU1gzZGhYdE9FcUR3ZGtPT1dNRG0yb1Ir?=
 =?utf-8?B?b0JmVk83SzV3RlFBMEZGeFdySGRjWUw0WThVM3dqaDh6WVVCa2NDa2I2bkRT?=
 =?utf-8?B?N2laS2Y4MUthcU5MS2N5RzBORGFUam54TVNVdEFScFV6Uk0rOUM1YVNvWk5Y?=
 =?utf-8?B?OEVnRHd1bFNkSUxKVlBOZnNFOFNUOHgzdXJ4UjEvVjUrUmp2QkQ0MzZyWGE5?=
 =?utf-8?B?WG40OEMxWUd4UWxkWWRDZCtXcEtYeEZOQWdPL0NUSVNoNmtEK0NBTWIyY24y?=
 =?utf-8?B?RjJaVDdMZ2d2SnF2ZzhEQnZKNDBuU3NCUXM1N09SN0ZtRDd6QTR0V1hEb1E5?=
 =?utf-8?B?b2dhZFlOQ2l5dHd0d0xGclNkRzZqNVhjVjkwaEVkREJlbW1PdHkxSFNxZTZB?=
 =?utf-8?B?MkMwSk1pUjRJbU1nckJQWFhPQ3VPZEc5VGpVUnREeWhHeFN4eFNPanV2bXNQ?=
 =?utf-8?B?M1RNU2pSWlZlb1Y5Ui9jNkxlSnhlSFNOQnJHWjNlQXdPOVhtNTR3RW1aajNJ?=
 =?utf-8?B?bjdMYktBMCtjaUU1MFdSRlRxV1R4MGp4RTdPcUhIemphTFJrSkxwak5YZVpU?=
 =?utf-8?B?dEJURmFRQ3doNXNZUFV6MVVHdVpYOU9IY3BxVm9oWDFJdmJZOU80ZEFNdnA2?=
 =?utf-8?B?ZzkwNSsxN2dIZXV6dWVjekhOVVdhUUQ0ZU9OSmJTWERRRTNZTHBhZ0F5MHE3?=
 =?utf-8?B?YXltV3hDVUtsdVhlNXhnWkk3VlpZWW1GWUNQSElqSGFrTC9nT0Q0ZUtlaGt6?=
 =?utf-8?B?N2VkK3YxQk9OY1BZRUVRSGRaWTRUUStRcUxpQWFKOFNsM0VYWTUvL2pOR2VO?=
 =?utf-8?B?d3ppbzEva01iZC84c1JmSUZkWG8wRjY5OUNmd0doSWxPWXN6alRwQXJyaFE0?=
 =?utf-8?B?U0dYbGU0MmdBd2tSemE0OUFFem9kWTFaOW5pTjhsTldJUUZJTnpNQ2pmL01l?=
 =?utf-8?B?NGk2SFNqeEZ6UlBqaTZNazBvVHRJbXlhNnpZT3QxaEU1QjNjc3pQZzhJaTF2?=
 =?utf-8?B?a24reWJwNk9kWVBvcmRZWmJhM0NVb0hVRUlUSW0xRGhwQVV1TW9GL2pyZlhj?=
 =?utf-8?B?WTFBaktpUjB0U2FPVzFJOGIxbWVjaTUydHY0YzlxWVNaQlo1ZEtWTXk5elBz?=
 =?utf-8?B?SWFZK09rQmxnRzczdFhLNTFuL3lPUnMzSzkxY1N5dld2M2lBOThrbG9IOHJZ?=
 =?utf-8?B?RzNmM2JmUkVyMEpnUEl5M3BSNWtHbGM5T2xCejZxWFFmSDRrdzNmKzN4YnlY?=
 =?utf-8?B?cnRoOHViN216VzI4RFZpMUQ5T0F0ek1GYUxpbkxtR3I1RXk0UmIrSzZoSUZx?=
 =?utf-8?B?RUo1OHJyNURZMTFuMEFtM2JuZ3IyZDRrM1dTSEtrNDVYWEZsM1p4VVBaclp0?=
 =?utf-8?B?OWhuVXd6aG9Tdk9UdjdGdmpOb0ZVYXI3REZSc3Fla1lDVFRCR01jK3RRRXhj?=
 =?utf-8?Q?ei4gNccipmOmlUc78h?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b34825c1-e16b-4079-cb95-08dec75c9a3e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 01:56:07.3237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3JW0KgFdvFUxfAUclOxpvusWagzX7un1r2mM0pCJRqsL/NUwb1pBHMrQGkVA99Qd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8972
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7eysf51mp6x31sk9f9ucbceog5pd4r8f
X-Rspamd-Queue-Id: A4B11120005
X-HE-Tag: 1781142974-596966
X-HE-Meta: U2FsdGVkX19Q3g3vPkwNgCBcnZGdeUSZJxKsN4D9y2RBU+phlvhk83j7dofohcrdsF+JBJPd3DfVI9yYo54wzH2tQfkx/PT8G1KINsclkLa4I1/sv7wDUfP9sssL2JxbfOrtlcwYoA3kwQ+OcyvkAd5+hZ5vc/fqTznbL92O9+7UkaBQ+K1O0I/T7VAR2r8JGkTSlwqCkNuo1hIz+UDgu7iO/dLeyj7zGSJZG1irq9XLGoEeMHvWV/sFVfmvYyQpJMLYHnvKbeHJFHhv0H9JeS7OJNSS7dRorfyUiueCjKOHQ24p+bdJdALPAFzslEvvXeAslBRiHZJIukT6MmNixZ1R+pFu2uNHh59dDeWRMqyQ5SbfuOYgT6aWpyPnD15BzIdn8etDMwG+jkGnh6Iw0HzBXXyzziFOw4dCxh/+aOcHB7R5LgGyz7ANGnxFl8AnfMaK4iVqAe05FEgqA/vQ4dXoxSVP+QmnKiCVu8E/EwyNZtON0/u1Vf7o/eGhf7OvfoMRjOerv796Vz4IKMIMpGUEDWxr4yrUxPCaJNSduRbmPDmiMHD3kJ/9A2HSMp1s1reyFTemS15hlB7Mgu5k5DysviATkTRs8OCAKgqRjyt2bs5gGPJ3LgMZ55++wB4BiPskKoSnq3GXQogRu6tvnzV9zWlGv6ta/hhXCzDS8yQzksZnsQAnHgNolwDelLJyqf/xcoHPeos6v1BgBgFhnnhHY65KPpPi+0mhT/DXUr90rWJL6d1d3Qu6ZyOHzCcqEM+fvrWq2+wKATVPmnl94kX4mddaTfZBPZ2EqH/bKsoNaxg3Kgc9kZI9uOx8+yULLY0PwjRQY68+vN1BBC8AB6bioxKyDxaofy3qhpFNq0BFJkSVV2xZDf5hMcRde+SyxyV4pr7VELguIcKTNKLhAhlkJ4t1rgaDVIqmWNCEOGOIIgrVhE025amgT0nePAXJdlJbKJqUe1LC7FTvrC0
 YLT0vL45
 Zr6jCY5JuMyTe+aqeBAeRbe6l60srBhth/wW1ZA9iroJ2SjRZJUYFarr+Ro+Ztmv0pl6BJU9ABuPeTugx9Rvl1RHv6jxWE+AzBzWtDEau3RadaK4Sl/AFEDNToaGKgo8o6fWhhhVFD8bmjNZGw+skGiJtJKHHdyXdYclhzubwAbGr3evIRHH8yIFkF3zUcf1Fx+ZC2lljYSPM9NugfTUThfhnJ24X04MHXa1q0Ny+aQX7xxopuPjSpAmTjtCmTFzakw2/7yvlfmryGmvmbgUPYqEyUedVfBZIgQvJwDQbRYT//aQjf/FkaE9JS+BwYhsHeLpvgPrKZbA06YD6U9v6b16E6sGUgMuOyo8fsxuSFB7DFerFXYuqZVvIJA/ctu3IB9Wwj9hlyA48mheHhVIUtUWMIant5vx0pKNme1D6+zr7AwESfD/30kVyruuMVbQhSsIfRM7Vk8plJf4JUi+mLFgFWwsmS20hLNP3lsg2Fu0PMUWmy8Y77MqGOnFNkMlrhPJF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Jun 2026, at 21:39, Zhaoyang Huang wrote:

> On Wed, Jun 10, 2026 at 10:38=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 10 Jun 2026, at 8:50, David Hildenbrand (Arm) wrote:
>>
>>> On 6/10/26 14:05, zhaoyang.huang wrote:
>>>> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>>
>>>> The kernel panics are keeping to be reported especially when the f2fs
>>>> partition get almost full. By investigation, we find that the reason i=
s
>>>> one f2fs page got freed to buddy without being deleted from LRU and th=
e
>>>> root cause is the race happened in [2] which is enrolled by this commi=
t.
>>>> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: re=
move
>>>> non-uptodate folio from the page cache in move_data_block").
>>>
>>> But I assume, that other FSes can trigger this as well? Any insights?
>
> Yes, I think all FSes support big folio could suffer from this defect.
>
>>>
>>>>
>>>> There are 3 race processes in this scenario, please find below for the=
ir
>>>> main activities. However, by further investigation over the code, I
>>>> think there is a common race window for the truncated folios between
>>>> split_folio_to_order and folio_isolate_lru, where the folios lost the
>>>> refcount on page cache and remains the transient one of the split
>>>> caller, under which the folio could enter free path and compete with t=
he
>>>> isolation process. This commit would like to suggest to have the folio=
s
>>>> beyond EOF stay out of LRU.
>>>>
>>>> Truncate:
>>>> The changed code in move_data_block() lets the GC path evict the tail-=
end
>>>> folio from the page cache through folio_end_dropbehind().  Once
>>>> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
>>>> page-cache references for all pages in the folio are dropped.  The fol=
io
>>>> is then kept alive only by temporary external references, which allows=
 a
>>>> later split to operate on a folio whose subpages are no longer protect=
ed
>>>> by page-cache references.
>>>>
>>>> Split:
>>>> After the page-cache references are gone, split_folio_to_order() can
>>>> split the big folio into individual pages and put the resulting subpag=
es
>>>> back on the LRU.  For tail pages beyond EOF, split removes them from t=
he
>>>> page cache and drops their page-cache references.  A tail page can the=
n
>>>> remain on the LRU with PG_lru set while holding only the split caller'=
s
>>>> temporary reference.  When free_folio_and_swap_cache() drops that fina=
l
>>>> reference, the page enters the final folio_put() release path.
>>>>
>>>> Isolate:
>>>> In parallel, folio_isolate_lru() can observe the same tail page with a
>>>> non-zero refcount and PG_lru set.  It clears PG_lru before taking its =
own
>>>> reference.  If this races with the final folio_put() from the split pa=
th,
>>>> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio()=
.
>>>> The page is then freed back to the allocator while its lru links are
>>>> still present in the LRU list.  A later LRU operation on a neighboring
>>>> page detects the stale link and reports list corruption.
>>>
>>> Complicated mess :(
>>>
>>> So, folio_isolate_lru() really only requires the caller to hold a folio
>>> reference, which can happen given that we did the folio_ref_unfreeze().=
 It can,
>>> for example, be triggered by memory offlining or page migration.
>>>
>>> So we really want to not allow folio_isolate_lru() while we are still p=
rocessing
>>> the folio.
>>
>> Or we should defer adding split folios to LRU after unfreeze.
>>
>>>
>>> What your patch does is, simply not add folios that we will drop from t=
he page
>>> cache to the LRU?
>>>
>>>
>>> You should describe here how you are fixing it: "Let's fix it by..."
> Yes. This commit would like to suggest to fix it by having the folio
> skip the lru_add_split_folio

Skipping it causes more issues like LRU counter mismatch, firing up bad_pag=
e()
since PG_active, PG_unevictable, or MGLRU fields in ->flags.f could stay
uncleared at page free time.

>>>
>>>>
>>>> [1]
>>>> [   22.486082] list_del corruption. next->prev should be fffffffec10e0=
ac8, but was dead000000000122. (next=3Dfffffffec10e0a88)
>>>> [   22.486130] ------------[ cut here ]------------
>>>> [   22.486134] kernel BUG at lib/list_debug.c:67!
>>>> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>>>> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
>>>> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
>>>> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS B=
TYPE=3D--)
>>>> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
>>>> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
>>>> [   22.488539] sp : ffffffc08006b830
>>>> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 000000=
0000000000
>>>> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: ffffff=
fec10e0ac0
>>>> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead00=
0000000122
>>>> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffff=
c080061060
>>>> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 000000=
0000000058
>>>> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 000000=
0000000003
>>>> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe857=
21f0e25f00
>>>> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c6564=
5f7473696c
>>>> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 000000=
0000000010
>>>> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 000000=
000000006d
>>>> [   22.488647] Call trace:
>>>> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
>>>> [   22.488661]  __folio_put+0x2bc/0x434
>>>> [   22.488670]  folio_put+0x28/0x58
>>>> [   22.488678]  do_garbage_collect+0x1a34/0x2584
>>>> [   22.488689]  f2fs_gc+0x230/0x9b4
>>>> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
>>>> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
>>>> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
>>>> [   22.488725]  invoke_syscall+0x58/0xe4
>>>> [   22.488732]  do_el0_svc+0x48/0xdc
>>>> [   22.488739]  el0_svc+0x3c/0x98
>>>> [   22.488747]  el0t_64_sync_handler+0x20/0x130
>>>> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>>>>
>>>> [2]
>>>> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 =
(folio_isolate_lru)
>>>>
>>>> F: pagecache refs =3D n
>>>> F: extra refs =3D GC + split
>>>> F: PG_lru set
>>>> move_data_block()
>>>> folio =3D f2fs_grab_cache_folio(F)
>>>> ...
>>>> __folio_set_dropbehind(F)
>>>> folio_unlock(F)
>>>> folio_end_dropbehind(F)
>>>>   folio_unmap_invalidate(F)
>>>>     __filemap_remove_folio(F)
>>>>     folio_put_refs(F, n)
>>>> folio_put(F)
>>>>                             split_folio_to_order(F)
>>>>                               folio_ref_freeze(F, 1)
>>>>                               ...
>>>>                               lru_add_split_folio(T)
>>>>                                 list_add_tail(&T->lru, &F->lru)
>>>>                                 folio_set_lru(T)
>>>>                               __filemap_remove_folio(T)
>>>>                               folio_put_refs(T, 1)
>>>>                               /* T refcount =3D=3D 1, PageLRU set */
>>>>                             free_folio_and_swap_cache(T)
>>>>                               folio_put(T)
>>>>                                 /* refcount: 1 -> 0 */
>>>>                                                                   foli=
o_isolate_lru(T)
>>
>> If refcount is 0 at this point, VM_BUG_ON_FOLIO(!folio_ref_count(folio),=
 folio) in
>> folio_isolate_lru() would be triggered. Maybe we could just return false=
 in that case.
> No, isolate caller will grab one refcount.

As I said in another email, isolate caller cannot grab a refcount when foli=
o refcount
is 0.

>>
>>>>                                                                     fo=
lio_test_clear_lru(T)
>>>>                                 __folio_put(T)
>>>>                                   __page_cache_release(T)
>>>>                                     folio_test_lru(T) =3D=3D false
>>>>                                     /* skip lruvec_del_folio(T) */
>>>>                                   free_frozen_pages(T)
>>>>                                                                   foli=
o_get(T)
>>>>                                                                   lruv=
ec_del_folio(T)
>>
>> But in CPU2 (folio_isolate_lru), lruvec_del_folio(T) should remove T fro=
m LRU list.
>>
>>>> later:
>>>>   list_del(adjacent->lru)
>>>>     next =3D=3D &T->lru
>>>>     next->prev =3D=3D LIST_POISON / PCP freelist
>>>>     BUG
>>>>
>>
>> Why does CPU0 still see the stale link from adjacent?
> The staled link should be from LRU since the folio never be deleted from =
lru.
>>
>>>> Assisted-by: Cursor:claude-opus-4-8
>>>> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>>>
>>> I'm wondering if this has been broken the whole time, or if some rework=
 allowed
>>> this to trigger.
> This issue is from AOSP with v6.18 which just supports big folio in
> f2fs. Besides, it is triggered by the timing of f2fs's partition get
> almost full during the test case of filling f2fs's partition(should be
> the trigger factor of f2fs's gc which enroll truncate thing)

Are you able to reproduce it with other FSes supporting large folio?

>>>
>>> I assume the issue can be triggered for other FSes, and we want Fixes: =
+ CC: stable?
>>>
>>> Looking into the history, I think we always unconditionally did the
>>> lru_add_split_folio()/lru_add_page_tail().
>>>
>>>> ---
>>>>  mm/huge_memory.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 970e077019b7..7465525a94a8 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -3966,7 +3966,7 @@ static int __folio_freeze_and_split_unmapped(str=
uct folio *folio, unsigned int n
>>>>                      folio_ref_unfreeze(new_folio,
>>>>                                         folio_cache_ref_count(new_foli=
o) + 1);
>>>>
>>>> -                    if (do_lru)
>>>> +                    if (do_lru && !(mapping && new_folio->index >=3D =
end))
>>>
>>> It might be clearer to write this as
>>>
>>>       do_lru && (!mapping || new_folio->index < end)
>>>
>>> To match the page-cache check further below
>>>
>>>       if (!mapping)
>>>               continue
>>>
>>>       ...
>>>       if (new_folio->index < end)
>>>               ...
>>>
>>>>                              lru_add_split_folio(folio, new_folio, lru=
vec, list);
>>>>
>>>>                      /*
>>>
>>> folio_check_splittable() makes sure that we have a mapping for non-anon=
 folios.
>>> (no truncation). end is then only set for non-anon folios.
>>>
>>> @Zi, any thoughts?
>>
>> The fix works but I feel that it is masking the race between folio_isola=
te_lru() and
>> folio_put(). I worry that the same issue might be triggered in other way=
s or
>> in new code if we do not fix the race.
>>
>> To summarize my thoughts above:
>> 1. adding frozen folios in LRU might be problematic, since folio_isolate=
_lru()
>> has a VM_BUG_ON_FOLIO() for it but still chooses to proceed the isolatio=
n.
>>
>> 2. the race analysis is not clear, since both folio_isolate_lru() and fo=
lio_put()
>> do lruvec_del_folio() if folio is on LRU. When list_del(adjacent->lru) s=
ees
>> the stale link, the folio is already in buddy and page->lru is modified =
for
>> PageBuddy use? So even without CPU0, folio_isolate_lru()'s lruvec_del_fo=
lio()
>> can do the wrong thing on pages on buddy?
>>
>>
>> --
>> Best Regards,
>> Yan, Zi


--
Best Regards,
Yan, Zi


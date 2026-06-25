Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A08A1CDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 18:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526826B0098; Thu, 25 Jun 2026 14:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8656B0099; Thu, 25 Jun 2026 14:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378C26B009F; Thu, 25 Jun 2026 14:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF14B6B0098
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:22:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B87F1C51B9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:22:48 +0000 (UTC)
X-FDA: 84919256016.10.EC406EB
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011050.outbound.protection.outlook.com [52.101.57.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6A6AC4000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 18:22:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W4kaRlfF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782411765;
	b=q7LA16kBMBXq+JWQhG3I0e1aSaEpopATVJShlrRe0LTY6PRWzde+3pknrArhu/aKyYG4J3
	ygvw83568mnb8BsyU6ZNd76IoP3O3jjiy4EFgzkUyVtpYFjfY/zpSH/S32wHbvhUz6ZuF/
	VSYce5LDnHfeLck4T09e9w0WRYuGDLY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782411765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p5vRBI+OFdjXP8L11GG3q/ahE57Av22zBNw0rbQYsM0=;
	b=lk0IuHsx8MLnaFxaBXFKDs7WqaDz/jZF+5XnV1hpmQ467DU68mKnPxzhwdSW8WCVkXy20U
	MG1D+aMrX7OIZLEwHNrvx2mT14bG0Z+WUcoQxu74yFs/LhiGsWQ22xo82UKqewn1Dwr1ma
	SDzwbKAubGZRJh5q9gLjyOMXO6pTxb8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=W4kaRlfF;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DU+22nnRAkgsGzhgPaIqNDXitB4qq3Dr2k4/HixBzDKnUxRMCH6XJvEYkpkkcQVmCn4Vk7aschDIqsQIOHmvJeUsroJT6iY+sQreRiKN8MGFy4lV+wUmj7v2vBCl80aqAcOYgiYoZXdVbm+Cihgtd1B5lQ8m7ZtQUhxA3i1/reZzZN294gFrp6v/VYR1FyYwFWeT9B/bwVnyRdoXCDovT1ZF60HaQ2ACVS58n/saKZLiP78Ir4+V1k8iCm6y+o0rmMyE09/VeLXVrxrLG/KF1ECU1huKTQqp/nrfJsnFF6YqRLQN/ztm8At//w5embwyi5W8FvMLnZnrbUL1nblxLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5vRBI+OFdjXP8L11GG3q/ahE57Av22zBNw0rbQYsM0=;
 b=UudYH/aYxOptIxWVn8fNMlBMSdpEhG4Z1TXScMfpfVZ0/F/KZbPPdc6KMmMU88Sx5RRAxEHxGpsFosGYC1897En5SB3JHt+Ihte/Kd0RazMvWSr6uQkAXp5tl7+aQkA5coLvqfO0Rc0oBsMkVEeogaIeTegg4DNnCJqUDkp9srXhW+BLdhASscYHb0c3XUEBAQc5iQKqQHW2/ts1F3S6iMn+Z/iKJc4AlqMtqBwHkV3y2H+6mAKoIAmuyERnW1B66agcRMy7VxEeMtzWFAmf5kLhX1ean5PgArEGGPSDvTXAWGRY406uLd2Ipp9/WT6njFn+BiRUBkL2T5ZP+QSx7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5vRBI+OFdjXP8L11GG3q/ahE57Av22zBNw0rbQYsM0=;
 b=W4kaRlfF6ttHtfc7jeQJnkATkvyZ6AfoYrYbJDALjygiqzQs6pLseYX6O5Pmg6aYsw62zwYLhuOYe3NWuMpNDZyA+16uQKpIZPRF347Idf2xurVtDiMEOchAzufgNPS4tyvJRBshkjr2Gj6yQw89IKch88WKXb0f8zmLDTLh7l0XMj2gdiLsPG2lQ7kgewG+Dh+JHxuwuF0L7Fiwjzt1lB/1s+5k5L4mS0LQgHTFjK7R5Ivmj7a/FLNjMCJf18NZ87TzbowE5bwgeXxcEbCG62aezNAp7NYyp6kPK+OodMlWe8Ab0zTZp1U5J+r1v7Y3hqvbYre38B2967YL6M8OXQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4330.namprd12.prod.outlook.com (2603:10b6:5:21d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Thu, 25 Jun
 2026 18:22:34 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0159.016; Thu, 25 Jun 2026
 18:22:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 25 Jun 2026 14:22:33 -0400
Message-Id: <DJIC8FHUE508.1H55DFNUVM9EE@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v11 0/4] mm/page_owner: add per-fd filter infrastructure
 for print_mode and NUMA filtering
Cc: <surenb@google.com>, <mhocko@suse.com>, <jackmanb@google.com>,
 <hannes@cmpxchg.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Zhen Ni" <zhen.ni@easystack.cn>, <akpm@linux-foundation.org>,
 <vbabka@kernel.org>
X-Mailer: aerc 0.21.0
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
In-Reply-To: <20260625043101.338794-1-zhen.ni@easystack.cn>
X-ClientProxiedBy: BL1PR13CA0432.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::17) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4330:EE_
X-MS-Office365-Filtering-Correlation-Id: 9abc3497-8100-43d7-6f8f-08ded2e6ba3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|6133799003|3023799007|18002099003|22082099003|5023799004|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	VAa/gPU25SoS3aCO2W7oBAJX3tnQpikgRYJBV9Mr3IS5PwCrjKSNVlhTbXgPNomYUTEFbByRHNh+hL9V41RBdalDe1aPqfQqJzvpAzOE+hKJz5Mqt8KpvMQ9WQLP5PMWpsZWzrekFp/3U/uMchjXVzKdGlQygeyf9+62yZyo5EqLxeDnqSc2/JKRyWyQImthNJ2iy0i3RpAvxSnioPxNf+NH99cBSg9UInRxaMZ1nSojBZaigl5saDJ3+GBm3Icf4FC40GIrA6IkMKFFSzFy/Yl3W+292iGD9HFNbK2LGWu56koU/huLtDZGZP4Tz3+eTINncmUicWolIsCQ6bgW0j95J7G4623iObkI1CLH+eZIDZUWsDFKczArGKsvE+/QJ74LfwIi4mJJhDBd3ufq9Okox7ovq0AeIdypG9zPpA099z+9cKmV4suTXeuD7JnANobeG7+V3+bPyygKUrjO6Or/H/eHujKs493uHu8sP1EHsYqm146yc74frnMzsACYvGmNibczBmiK7OJ3munwDc+HwbY935SuLJDGAGchL/5+A5Hlw9rI0UTWMyEkEUJ9pww9jBIfM5qFNHVD8uN35JJdxOGi5ezg4pXncvFY4Rc1ap3TOxDO4g/DNduHnyu5Zojf97voW2Nln3ILs6qIs3/Mm3c4T58Wj21eW3to0cw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(6133799003)(3023799007)(18002099003)(22082099003)(5023799004)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YWVyOEFXakFGbU4yaFpXQ0Iva2ZUT0s1SzAzdktaZEJta2gzZ0Q1akgzanl2?=
 =?utf-8?B?S3dEaVYva1BXSVNxb0xLb3pXZ0d5ZmhOdklpSWt5emRJQUMyNm15Y0xKZ2kx?=
 =?utf-8?B?eDhBRlFNNnpzVFhxTkdtWmhaVWhVNmR4T0RXemVmNzVnQVJTK1NnYlA5MUt4?=
 =?utf-8?B?bk5JaDR0bTdyTDFhbHJiWmZlV0ZkNXlESXFKc01KMVA2MG5BV1YrbkpGTG80?=
 =?utf-8?B?cGJrWDA5S0x2Y1JzUjdQQjRIVFE4NWVJM1hYUHNaUTJYKzJZWXRCYitJU28z?=
 =?utf-8?B?WnBveFNaa2FtVmdHdEtiZFI2bXFmWGZsQ04vR0RKQXhMOGRPdUd1Qy9ueWlL?=
 =?utf-8?B?Z3lxRUMzUWtPempPdDJWaVhuT1piZmJUZ2FhR2QzV0FVUFN0K2FRem9XcVlS?=
 =?utf-8?B?aGJLZ1loOVhNVm5BczJpNWd5WnVzZjhGMlhCMHdDK2RiTVM4NFVCaDkyY2RJ?=
 =?utf-8?B?cWFzaS9VR2hBU0lVQ2JMbHpacWl1T1QzUkxaTGhaK0ovZW9LYjBBVkthOWlN?=
 =?utf-8?B?d3Bzejk3RWxpQlNTTlhicFNHWnZxMk9OWDk4c1UrbzZxKzBhMlJDZnZ5eXpw?=
 =?utf-8?B?REp5WUwzalhZd1MvbDNkVHhPTmlubDNvd2FlOGZROVZEa1luVUNhbWZlNEw3?=
 =?utf-8?B?SjRMVXVES1ZRN2tlb1hSR2l5ZVNnVklrZXB3Y3FVRHFrdWNWUzRLaE04bGtD?=
 =?utf-8?B?ZFFrZG9VSUNRTFpYbkRpNTdBZUthNFUrNFl3akEwYnh5TjE0Yk5nUHROWVh1?=
 =?utf-8?B?eURPeWVNL0ZGL25ML0lvTVdQeFUyUllLdTRkRC9jb3RuRWlMckZhMTVvQ0xa?=
 =?utf-8?B?MS9ITmFFVzVZZm8rMEFiamJMUU1xdHhsVnZhWGNCQVMyeVFjeFNvNC9nMVhJ?=
 =?utf-8?B?aTRTRHltRkRuQ1VyTGl4MERMenBuVnJUU2lyZTQvMVNOazVNc2lSdC9Hc2x6?=
 =?utf-8?B?N3FjdFZnSVhwWW1VSnRnSzAwTXBkSFgrbWc4dHVrYkQ1cEZ6RUpDdTM0Y1o2?=
 =?utf-8?B?WG81Nkk2Y3hwUWQ1TXBSUHlXZG5ZZ2FsRXU0Mm4xbnpLVklyUE8wWW00N1dx?=
 =?utf-8?B?VVBFbGp3a3liSkVLZVM1ZHRsSlpuVHkya0ZOTDgwVlpHbkphbTM5MG5RL2x6?=
 =?utf-8?B?S0VFWHlCRkxXd2hUTW41ekFNTmFpdlR2ZUdzUENOWWdFNFIwVWNDbVRZSHVU?=
 =?utf-8?B?NzBRc1Y4K3NwYlc1U3dwWC9oZjFsY21zd3JMaVV0clQyT1VkaGs1cnFvaDMx?=
 =?utf-8?B?V3p2RmErcmEyeTFtN2RRMmN6RGxIYjlFVFJsRW44aVg5ZnJmWUxhY1N6QkJu?=
 =?utf-8?B?bFZNdGFvNi9CcHdZeW0zSzhzcVZpRSt4Z1Z0ZzFLMjdEcndIV2dxZ0U0eEp0?=
 =?utf-8?B?THhnSTZpYzczckJiQUhIaUVIdTFPdG9DUTlTLzJtTmFmSjBvY1d3ZTB0K1k3?=
 =?utf-8?B?S3JRY2RVQmxMWDM1T0I2NFNuZjM0ZGtMTFVxSXp2bkJ3TFRzRzRBQkdpbjhS?=
 =?utf-8?B?WTdVSGQrQksvZ3BqRlNqYTliUFdpS2Jla1VrU1lCL0l0ZzlHTFVtUVZCWG1t?=
 =?utf-8?B?ckZ2TStaMDdyYzJydlhxVXJoSFZSSlVwellFT1VIWHBnRTV3a1NpeWJwb2tQ?=
 =?utf-8?B?ZjZucEFCMFFLZjcxTjNML2hSWDdjaGsvY1dUZytvb3ZxQ2sySXprOGlPSU1X?=
 =?utf-8?B?WEE3SG1xRVkvVHJQTGNvNDR1K1RoYlNsSTBwd3BQNmdkcVhiUUE1dGNZZE5Y?=
 =?utf-8?B?YUtQNGVmOGpCalpRUHNTUWpZWDRoc3AxbXFDbmRHZDFyTC9vWkp3d2g5ckF3?=
 =?utf-8?B?NEhCajJoeDFWUVl4aERoWElBbjhhOXlLZUNWVzRFRnFVVlBLYld1ZTBMb2RJ?=
 =?utf-8?B?cUVoZFVGSEdJL3U4TGVGYlNJVFVGbk12SjNRendMai8xWDlLOGF3TTN5amFT?=
 =?utf-8?B?UE5XSFZkR202M0RwUzlEeDFYUTEvd2VxNDRMOVJEZUIwWnEzYVBuMFcyT3ky?=
 =?utf-8?B?azRpS215eEJLK0gwRWNER2FEdmRWM0hlcnJXTHRQRzFIVC9RV25wV1huNHNH?=
 =?utf-8?B?NXQ2SzhvSnk4bTMzcm5iRHVxc0tzQTZZTVBrS2ZtQVVOQVlwNklrRXI2UHY1?=
 =?utf-8?B?V0lLOFFhQWhOMXMwRFNYWUJnQmhMNSs4c0ZYWHBKeFM1d0UrOUVHOEpLRUl6?=
 =?utf-8?B?TFVmMnpiRXlkaTA5TXVBMTF5Nm0wZEtjbnA5Y3hMMGJMVWtoZms3amNYSTRJ?=
 =?utf-8?B?emlJTEh2WHlZSTkvOEZoeUtwSlgwZ09vUVlEUUdWRlFmY24xSE1OZTdCdVAx?=
 =?utf-8?Q?gCZJCN5iW4QUXDoQBK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9abc3497-8100-43d7-6f8f-08ded2e6ba3b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 18:22:34.3706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 663Hxb6m0aWHbC563aXAE75D0kdh9MeRho0o/ZO/uvVlRQXaKvw9TDTrIXbrLdrl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4330
X-Stat-Signature: cnpjo6tk4wuk4punhmdtr1tnrz3y1g63
X-Rspamd-Queue-Id: 6A6AC4000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782411765-386311
X-HE-Meta: U2FsdGVkX1/ZqmNYuYyiE3QRNK7Bs5GUzRKsYafwRNPxZL/9dp63OlGpBZj7/tIV7POAo1QF4JZTAEJhjEBrfsj/OfE7ZQDJ1jy3SuM/g9RsdiB/DoK1XFed2FcRLMqx0jUOWb4ue/t2zJnmbM20rTuiUjQqRVspsnOikS0CmWC+bbL+EU+ob0Oz87BcOefW5b5HpLzj5FtrxtQWaRgCNaW+ZtOJXDnMMxX6LOA5Tnd/SHmanicWxYguHYTPv+O8/dNRHt8yAMImRLCERwpip9MOCQAw056Br1b0z2ZmNqH70hTd3EWAW2EL8JM1wIWB2Gu23NKlLOmVNZtQkbbVQsSSYu9cVg9lj92oxtTuipJecwyyudEtJz4JlMZWCubOrjm8r74C0dSXbr1lVAb6RkgOwzYUspWf2mFEYbFGcGzEbm27s9X76Ia8zm50vVpPIXYwMg1qOW9l61SbJMh2VdJVArWs5EBCUKZ1exfmMEHNVLl4lrpMdR9Yxf/YAITbXzD6u2DBCH2wdPsD6UZYk1uT6x6rQ5UmTpUJkepuxzxkjBebJ+0RyKgbzNl3ccb6uY4NEFBat8i2Nkzn35B9KlF/im/XHifR6NLhxhm/VbpJiVRnRnCGAf67b4FyD51nZUMi/yMijDMk/vssgRoIeXCB9y/r+zEY1mRM2m+49g9Ol8wHMq/eiMveoAu1WJTJldRVmysv9Sv8F9Eind5G1ZLlesy5zDGC9gnilP41Dz8Jl2Mp8q2AIvZwPX4QmH5MY+AH1paQLFI5/uo2+NGgbEKcDRW8VX6zMC52XhlPnAG7U9LXz1On/iQZcKSUY+5/pWMa8IR5dsMm73Hpvk6V3P/0ozvegUsl/d0tJ9l49RFKKjVNERaDaRh7amE72HwUq5Yvq5vuD227v33qNFal4uzUxW69OQYbvlO+jjVgGbrMk9WoaUazO11p6qrq639nEmCfaoSVLg3miXuru+/
 xtHQ9BK0
 862a633Jfjd0FXBfyusU0QIdNc4Cc3ANG6CoSesf33crQrusoJUXdFYA8ap3duDkQyfvAEMGAozkU4V3BHqgT9kiEeGPi+BhkJb/wqyVtXFu+9EhpQe+kU4e1qapZFxKcbDd9SPgLJImSQTCgVL5qc+ycQhuvMMCOu6deyeGyRBrqcxnpOm+jmTQsfYIZknxckS4u5Ae7+PRSofZEvY1ImTwBHO/K7V2deQEoLdU/EQCcMbpHUYrZ1Z+T3xY+9BbRUsg+I2DTikeV9sYfioL5AbelbrRC1f2PGKwnLSBNfATPrWAwgsGpBchtcfsjJ1eZPKSKfCHrg4fUXKl7Q7ksWtEj0ZC1L4L0QiTrohKUHUlFxzM6gDqwVcd/COQ5gA5q6OxI/ZG0ep3S8OXUCMDMiVPUqOaKrtle8ZMpBvfmDe7piiF2QKJbpO4/FCTTrT8rST76gIdHcs7fJvtEbpNDjpO2QwFwNVMAwSmJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 25, 2026 at 12:30 AM EDT, Zhen Ni wrote:
> This patch series introduces per-file-descriptor filtering capabilities t=
o the
> page_owner feature.
>
> Changes in v11:
> - Remove 'nid' member from struct page_owner to save memory
> - Read page->flags directly with poison checking
> - Add signal(SIGPIPE, SIG_IGN) to ignore SIGPIPE and handle EPIPE gracefu=
lly
> - Treat EPIPE from fwrite() and fflush() as success (broken pipe case)
>
> Changes in v10:
> - Add 'nid' member to struct page_owner and record it at allocation time
> - Remove cond_resched() in page iteration loop (unconditional call)
> - Improve error handling: check fwrite() and fflush() return values
> - Handle EPIPE correctly: treat broken pipe as success
>
> Changes in v9:
> - Add spinlock_t lock to struct page_owner_filter_state
> - Use memdesc_nid() instead of page_to_nid()
> - Fix isdigit() usage
> - Optimize I/O performance
>
> Changes in v8:
> - Fix buffer overflow, strsep() memory corruption, and unsafe string hand=
ling issues
> - Add cond_resched() to prevent RCU stalls in page iteration loop
> - Improve validation and error handling (e.g., "1-2-3") in userspace tool
> - Fix documentation warnings and improve code comments
>
> v8 additional testing with invalid inputs:
>   ./page_owner_filter -n 1-2-3
>   Error: Multiple dashes in nid_list
>
>   ./page_owner_filter -n 0,1-2-3
>   Error: Multiple dashes in nid_list
>
>   ./page_owner_filter -n 1-2-3,2-3
>   Error: Multiple dashes in nid_list
>
> Changes in v7:
> - print_mode and NUMA node filter implementation (patches 1-2)
> - Add page_owner_filter userspace tool (patch 3)
> - Update documentation for per-fd interface (patch 4)
>
> Changes in v6:
> - Address SeongJae Park's review comments for patch 1/3:
>   * Remove unnecessary braces in if/else statement
>   * Use stack array instead of kmalloc for input buffer
> - Address SeongJae Park's review comments for patch 2/3:
>   * Add node validity check using nodes_subset() to reject non-existent n=
odes
>   * Separate variable declaration and statement
>   * Use kmalloc_objs() for consistency with kernel patterns
>   * Remove 100 bytes overhead
> - Add lore links to all previous versions
>
> Changes in v5:
> - Optimize nodes_empty() check in page iteration loop
> - Add __data_racy qualifier to nid_mask field
>
> Changes in v4:
> - Change print_mode from numeric (0/1) to string-based interface
>   * Use "full_stack"/"stack_handle" strings instead of numbers
>   * Display current mode with bracket notation: "[full_stack] stack_handl=
e"
> - Remove "-1" support from NUMA filter
>   * Use empty string to clear filter (echo > nid)
> - Use strncpy_from_user() instead of copy_from_user()
> - Rename nid_filter_fops to page_owner_nid_filter_fops for consistency
> - Merge patch 1 (infrastructure) and patch 2 (print_mode) from v3
> - Update documentation to match new interface
>   * String-based examples
>   * Tab indentation in code blocks
>
> Changes in v3:
> - Remove READ_ONCE/WRITE_ONCE for nodemask_t (fixes compilation errors)
>   * nodemask_t is a large structure (128 bytes) that triggers compile-tim=
e asserts
>   * Direct assignment is safe for this use case
> - Add comment explaining input length calculation formula
>   * 6 bytes =3D ",NNNNN" (comma + 5-digit node number)
> - Simplify "-1" check using kstrtoint() instead of dual strcmp()
> - Move nodemask_t mask read outside PFN iteration loop for performance
>   * Avoids 128-byte structure copy on each iteration
> - Add documentation for filter features (patch 3/3)
>
> Changes in v2:
> - Renamed 'compact' to 'print_mode' with enum type for better clarity
>   * PAGE_OWNER_PRINT_FULL_STACK (0): print full stack traces
>   * PAGE_OWNER_PRINT_STACK_HANDLE (1): print only stack handles
> - Changed NUMA filter from single node to nodelist with bitmask support
>   * Uses nodelist_parse() to support "0", "0,2", "0-3", "0,2-4,7" formats
>   * Uses nodemask_t internally for efficient multi-node filtering
>   * Output uses %*pbl format (e.g., "0-2", "0,2-4,7")
> - Improved memory handling in nid_filter_write using dynamic allocation
>   * Limit: (100 + 6 * MAX_NUMNODES) to handle worst-case input
>
>
> Problem Statement
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> In production environments with large memory configurations (e.g., 250GB+=
),
> collecting page_owner information often results in files ranging from
> several gigabytes to over 10GB. This creates significant challenges:
>
> 1. Storage pressure on production systems
> 2. Difficulty transferring large files from production environments
> 3. Post-processing overhead with tools/mm/page_owner_sort.c
>
> The primary contributor to file size is redundant stack trace
> information. While the kernel already deduplicates stacks via
> stackdepot, page_owner retrieves and stores full stack traces for
> each page, only to deduplicate them again during post-processing.
>
> Additionally, in NUMA-aware environments (e.g., DPDK-based cloud
> deployments where QEMU processes are bound to specific NUMA nodes),
> OOM events are often node-specific rather than system-wide.
> Previously, page_owner could not filter by NUMA node, forcing users to
> collect and analyze data for all nodes.
>
> Solution
> =3D=3D=3D=3D=3D=3D=3D=3D
>
> This patch series introduces a per-file-descriptor filter infrastructure
> with two initial filters:
>
> 1. **Print Mode Filter**: Outputs only stack handles instead of
>    full stack traces. The handle-to-stack mapping can be retrieved
>    from the existing show_stacks_handles interface. This dramatically
>    reduces output size while preserving all allocation metadata.
>
> 2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
>    using flexible nodelist format, enabling targeted analysis of memory
>    issues in NUMA-aware deployments.
>
> The per-fd design allows multiple concurrent page_owner reads with
> different filters, solving coordination issues in multi-user production
> environments.
>
> Implementation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> The series is structured as follows:
>
> - Patch 1: Implement print_mode filter infrastructure
>   * Add file->private_data to store per-fd filter state
>   * Add .open, .release, and .write file operations
>   * Support "stack", "handle", and "stack_handle" modes via "mode=3D" wri=
te commands
> - Patch 2: Implement NUMA node filter infrastructure
>   * Add nid_filter field to per-fd state
>   * Support flexible nodelist format via "nid=3D" write commands (single,=
 multiple, ranges)
>   * Validate nodes and reject non-existent nodes using nodes_subset()
> - Patch 3: Add page_owner_filter userspace tool
>   * Manages per-fd filters via write() interface
>   * Provides user-friendly command-line interface
>   * Includes comprehensive input validation
> - Patch 4: Document filter features and usage
>
> Usage Example
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Using the page_owner_filter tool with per-fd filters:
>
>     # ./page_owner_filter -m stack_handle -n "0,2-3" -o page_owner.txt
>
> The tool opens /sys/kernel/debug/page_owner, sets filters via write(),
> then reads the filtered output to the specified file (or stdout).
>
> Sample print_mode output (showing handles only):
>
>     Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper),
>     ts 0 ns PFN 0x40000 type Unmovable Block 512 type Unmovable
>     Flags 0x3fffe0000000000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     handle: 1048577
>
>     Page allocated via order 0, mask 0x252000(__GFP_NOWARN|
>     __GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 0, tgid 0 (swapper),
>     ts 0 ns PFN 0x40002 type Unmovable Block 512 type Unmovable
>     Flags 0x23fffe0000000200(workingset|node=3D0|zone=3D0|lastcpupid=3D0x=
1ffff)
>     handle: 1048577
>
> Testing
> =3D=3D=3D=3D=3D=3D=3D
>
> Tested on a 4-node NUMA system. Verified that:
>
> 1. **Kernel without page_owner enabled**:
>    Tool properly detects and reports missing page_owner support:
>    ```
>    $ ./page_owner_filter -m stack
>    Error: /sys/kernel/debug/page_owner does not exist
>    Make sure page_owner is enabled in kernel
>    ```
>
> 2. **Kernel without per-fd filter support**:
>    Tool properly detects and reports missing filter support:
>    ```
>    $ ./page_owner_filter -m stack
>    Error: Kernel rejected the filter command.
>    Possible causes:
>      - Kernel does not support per-fd filtering
>      - NUMA node has no memory
>      - Unknown reason
>    ```
>
> 3. **Comprehensive userspace tool testing**:
>    Tested 26 test cases covering:
>    - Help messages (-h, --help)
>    - Invalid inputs (mode, nid format, range validation)
>    - Valid modes (stack, handle, stack_handle)
>    - Valid nid filters (single node, multiple nodes, ranges)
>    - Combined mode and nid filters
>    - Node validity verification (grep-based verification)
>    - Error handling for out-of-range nodes
>
>    Test script (test_page_owner_filter.sh):
>    ```bash
>    #!/bin/bash
>    # Test script for page_owner_filter tool
>
>    cd "$(dirname "$0")"
>
>    echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D"
>    echo "page_owner_filter Test Suite"
>    echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D"
>    echo
>
>    echo "Test 1: -h"
>    echo "./page_owner_filter -h"
>    ./page_owner_filter -h
>    echo
>
>    echo "Test 2: --help"
>    echo "./page_owner_filter --help"
>    ./page_owner_filter --help
>    echo
>
>    echo "Test 3: Invalid mode"
>    echo ./page_owner_filter -m invalid
>    ./page_owner_filter -m invalid
>    echo
>
>    echo "Test 4: Invalid nid with letters"
>    echo ./page_owner_filter -n 0,a,2
>    ./page_owner_filter -n 0,a,2
>    echo
>
>    echo "Test 5: Invalid nid with double comma"
>    echo ./page_owner_filter -n 0,,2
>    ./page_owner_filter -n 0,,2
>    echo
>
>    echo "Test 6: Invalid nid starting with comma"
>    echo ./page_owner_filter -n ,0,1
>    ./page_owner_filter -n ,0,1
>    echo
>
>    echo "Test 7: Invalid nid ending with comma"
>    echo ./page_owner_filter -n "0,1,"
>    ./page_owner_filter -n "0,1,"
>    echo
>
>    echo "Test 8: No filters specified"
>    echo ./page_owner_filter
>    ./page_owner_filter
>    echo
>
>    echo "Test 9: Invalid nid - node 4 (out of range)"
>    echo ./page_owner_filter -n 4
>    ./page_owner_filter -n 4
>    echo
>
>    echo "Test 10: Invalid nid - large number"
>    echo './page_owner_filter -n 65535'
>    ./page_owner_filter -n 65535
>    echo
>
>    echo "Test 11: Invalid mode AND invalid nid"
>    echo ./page_owner_filter -m wrong -n abc
>    ./page_owner_filter -m wrong -n abc
>    echo
>
>    echo "Test 12: Two invalid modes (try both)"
>    echo ./page_owner_filter -m wrong1 -m wrong2
>    ./page_owner_filter -m wrong1 -m wrong2
>    echo
>
>    echo "Test 13: Valid mode - stack"
>    echo './page_owner_filter -m stack | head -20'
>    ./page_owner_filter -m stack | head -20
>    echo
>
>    echo "Test 14: Valid mode - handle"
>    echo './page_owner_filter -m handle | head -20'
>    ./page_owner_filter -m handle | head -20
>    echo
>
>    echo "Test 15: Valid mode - stack_handle"
>    echo './page_owner_filter -m stack_handle | head -20'
>    ./page_owner_filter -m stack_handle | head -20
>    echo
>
>    echo "Test 16: All modes"
>    echo './page_owner_filter -m stack -m handle -m stack_handle | head -2=
0'
>    ./page_owner_filter -m stack -m handle -m stack_handle | head -20
>    echo
>
>    echo "Test 17: Valid nid - single"
>    echo './page_owner_filter -n 0 | head -20'
>    ./page_owner_filter -n 0 | head -20
>    echo 'Verify: should have node=3D0, should NOT have node=3D1,2,3'
>    echo './page_owner_filter -n 0 | grep "PFN" | grep -o "node=3D[0-9]" |=
 sort | uniq -c'
>    ./page_owner_filter -n 0 | grep "PFN" | grep -o "node=3D[0-9]" | sort =
| uniq -c
>    echo
>
>    echo "Test 18: Valid nid - multiple"
>    echo 'Verify: should have node=3D0,1,3, should NOT have node=3D2'
>    echo './page_owner_filter -n 0,1,3 | grep "PFN" | grep -o "node=3D[0-9=
]" | sort | uniq -c'
>    ./page_owner_filter -n 0,1,3 | grep "PFN" | grep -o "node=3D[0-9]" | s=
ort | uniq -c
>    echo
>
>    echo "Test 19: Valid nid - range"
>    echo 'Verify: should have node=3D2,3, should NOT have node=3D0,1'
>    echo './page_owner_filter -n 2-3 | grep "PFN" | grep -o "node=3D[0-9]"=
 | sort | uniq -c'
>    ./page_owner_filter -n 2-3 | grep "PFN" | grep -o "node=3D[0-9]" | sor=
t | uniq -c
>    echo
>
>    echo "Test 20: Valid nid - range"
>    echo 'Verify: should have node=3D0,1,2,3'
>    echo './page_owner_filter -n 2-3,0-1 | grep "PFN" | grep -o "node=3D[0=
-9]" | sort | uniq -c'
>    ./page_owner_filter -n 2-3,0-1 | grep "PFN" | grep -o "node=3D[0-9]" |=
 sort | uniq -c
>    echo
>
>    echo "Test 21: Valid nid - range"
>    echo 'Verify: should have node=3D2, should NOT have node=3D0,1,3'
>    echo './page_owner_filter -n 2-2 | grep "PFN" | grep -o "node=3D[0-9]"=
 | sort | uniq -c'
>    ./page_owner_filter -n 2-2 | grep "PFN" | grep -o "node=3D[0-9]" | sor=
t | uniq -c
>    echo
>
>    echo "Test 22: Invalid nid - range start must be <=3D end"
>    echo './page_owner_filter -n 3-0'
>    ./page_owner_filter -n 3-0
>    echo
>
>    echo './page_owner_filter -n 1-0,0-1'
>    ./page_owner_filter -n 1-0,0-1
>    echo
>
>    echo './page_owner_filter -n 2-3,1-0,0-1'
>    ./page_owner_filter -n 2-3,1-0,0-1
>    echo
>
>    echo './page_owner_filter -n 3,1-0,1'
>    ./page_owner_filter -n 3,1-0,1
>    echo
>
>    echo "Test 23: Invalid nid - NUMA node 4 and above have no memory"
>    echo './page_owner_filter -n 0-4'
>    ./page_owner_filter -n 0-4
>    echo
>
>    echo './page_owner_filter -n 1,0-4'
>    ./page_owner_filter -n 1,0-4
>    echo
>
>    echo './page_owner_filter -n 7-8'
>    ./page_owner_filter -n 7-8
>    echo
>
>    echo './page_owner_filter -n 8-1'
>    ./page_owner_filter -n 8-1
>    echo
>
>    echo "Test 24: Valid nid - range and comma mixed"
>    echo 'Verify: should have node=3D0,2,3, should NOT have node=3D1'
>    echo './page_owner_filter -n 2-3,0| grep "PFN" | grep -o "node=3D[0-9]=
" | sort | uniq -c'
>    ./page_owner_filter -n 2-3,0 | grep "PFN" | grep -o "node=3D[0-9]" | s=
ort | uniq -c
>    echo
>
>    echo "Test 25: Valid nid - range and comma mixed"
>    echo 'Verify: should have node=3D1,2,3, should NOT have node=3D0'
>    echo './page_owner_filter -n 1,2-3| grep "PFN" | grep -o "node=3D[0-9]=
" | sort | uniq -c'
>    ./page_owner_filter -n 1,2-3 | grep "PFN" | grep -o "node=3D[0-9]" | s=
ort | uniq -c
>    echo
>
>    echo "Test 26: Valid handle mode + nid filter"
>    echo './page_owner_filter -m handle -n "0,1" | head -20'
>    ./page_owner_filter -m handle -n "0,1" | head -20
>    echo 'Verify: should show stacks, and only node=3D0,1 (not 2,3)'
>    echo './page_owner_filter -m handle -n "0,1" | grep "PFN" | grep -o "n=
ode=3D[0-9]" | sort | uniq -c'
>    ./page_owner_filter -m handle -n "0,1" | grep "PFN" | grep -o "node=3D=
[0-9]" | sort | uniq -c
>    echo
>
>
>    echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D"
>    echo "Tests completed. Please check output above."
>    echo "=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D"
>    ```
>       =20
>    Test output:
>    ```
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    page_owner_filter Test Suite
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>    Test 1: -h
>    ./page_owner_filter -h
>    Usage: ./page_owner_filter [OPTIONS]
>
>    Options:
>      -m, --mode MODE      : print_mode (stack, handle, or stack_handle)
>      -n, --nid NID_LIST   : NUMA node IDs (comma-separated or ranges)
>      -o, --output FILE    : output file (default: stdout)
>      -h, --help           : show this help message
>
>    Examples:
>      ./page_owner_filter -m stack
>      ./page_owner_filter -m handle
>      ./page_owner_filter -m stack_handle
>      ./page_owner_filter -m stack -o output.txt
>      ./page_owner_filter -n 0,1,2
>      ./page_owner_filter -m stack -n 0
>
>    Test 2: --help
>    ./page_owner_filter --help
>    Usage: ./page_owner_filter [OPTIONS]
>
>    Options:
>      -m, --mode MODE      : print_mode (stack, handle, or stack_handle)
>      -n, --nid NID_LIST   : NUMA node IDs (comma-separated or ranges)
>      -o, --output FILE    : output file (default: stdout)
>      -h, --help           : show this help message
>
>    Examples:
>      ./page_owner_filter -m stack
>      ./page_owner_filter -m handle
>      ./page_owner_filter -m stack_handle
>      ./page_owner_filter -m stack -o output.txt
>      ./page_owner_filter -n 0,1,2
>      ./page_owner_filter -m stack -n 0
>
>    Test 3: Invalid mode
>    ./page_owner_filter -m invalid
>    Error: Invalid mode 'invalid'
>    Valid modes: stack, handle, stack_handle
>
>    Test 4: Invalid nid with letters
>    ./page_owner_filter -n 0,a,2
>    Error: Invalid character 'a' in nid_list
>
>    Test 5: Invalid nid with double comma
>    ./page_owner_filter -n 0,,2
>    Error: Invalid nid_list format
>
>    Test 6: Invalid nid starting with comma
>    ./page_owner_filter -n ,0,1
>    Error: Invalid nid_list format
>
>    Test 7: Invalid nid ending with comma
>    ./page_owner_filter -n 0,1,
>    Error: Invalid nid_list format
>
>    Test 8: No filters specified
>    ./page_owner_filter
>    Error: At least one filter (-m or -n) must be specified
>
>    Usage: ./page_owner_filter [OPTIONS]
>
>    Options:
>      -m, --mode MODE      : print_mode (stack, handle, or stack_handle)
>      -n, --nid NID_LIST   : NUMA node IDs (comma-separated or ranges)
>      -o, --output FILE    : output file (default: stdout)
>      -h, --help           : show this help message
>
>    Examples:
>      ./page_owner_filter -m stack
>      ./page_owner_filter -m handle
>      ./page_owner_filter -m stack_handle
>      ./page_owner_filter -m stack -o output.txt
>      ./page_owner_filter -n 0,1,2
>      ./page_owner_filter -m stack -n 0
>
>    Test 9: Invalid nid - node 4 (out of range)
>    ./page_owner_filter -n 4
>    Error: Kernel rejected the filter command.
>    Possible causes:
>      - Kernel does not support per-fd filtering
>      - NUMA node has no memory
>      - Unknown reason
>
>    Test 10: Invalid nid - large number
>    ./page_owner_filter -n 65535
>    write filter command: Numerical result out of range
>
>    Test 11: Invalid mode AND invalid nid
>    ./page_owner_filter -m wrong -n abc
>    Error: Invalid mode 'wrong'
>    Valid modes: stack, handle, stack_handle
>
>    Test 12: Two invalid modes (try both)
>    ./page_owner_filter -m wrong1 -m wrong2
>    Error: Invalid mode 'wrong1'
>    Valid modes: stack, handle, stack_handle
>
>    Test 13: Valid mode - stack
>    ./page_owner_filter -m stack | head -20
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>
>    Test 14: Valid mode - handle
>    ./page_owner_filter -m handle | head -20
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40003 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40004 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00040(head|node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>
>    Test 15: Valid mode - stack_handle
>    ./page_owner_filter -m stack_handle | head -20
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>
>    Test 16: All modes
>    ./page_owner_filter -m stack -m handle -m stack_handle | head -20
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>
>    Test 17: Valid nid - single
>    ./page_owner_filter -n 0 | head -20
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>     register_early_stack+0x2c/0x70
>     init_page_owner+0x2c/0x460
>     page_ext_init+0x204/0x298
>     mm_core_init+0xdc/0x14c
>    Verify: should have node=3D0, should NOT have node=3D1,2,3
>    ./page_owner_filter -n 0 | grep "PFN" | grep -o "node=3D[0-9]" | sort =
| uniq -c
>      91327 node=3D0
>
>    Test 18: Valid nid - multiple
>    Verify: should have node=3D0,1,3, should NOT have node=3D2
>    ./page_owner_filter -n 0,1,3 | grep "PFN" | grep -o "node=3D[0-9]" | s=
ort | uniq -c
>      91299 node=3D0
>      43515 node=3D1
>     110404 node=3D3
>
>    Test 19: Valid nid - range
>    Verify: should have node=3D2,3, should NOT have node=3D0,1
>    ./page_owner_filter -n 2-3 | grep "PFN" | grep -o "node=3D[0-9]" | sor=
t | uniq -c
>      19391 node=3D2
>     110287 node=3D3
>
>    Test 20: Valid nid - range
>    Verify: should have node=3D0,1,2,3
>    ./page_owner_filter -n 2-3,0-1 | grep "PFN" | grep -o "node=3D[0-9]" |=
 sort | uniq -c
>      91562 node=3D0
>      43527 node=3D1
>      19495 node=3D2
>     110286 node=3D3
>
>    Test 21: Valid nid - range
>    Verify: should have node=3D2, should NOT have node=3D0,1,3
>    ./page_owner_filter -n 2-2 | grep "PFN" | grep -o "node=3D[0-9]" | sor=
t | uniq -c
>      19505 node=3D2
>
>    Test 22: Invalid nid - range start must be <=3D end
>    ./page_owner_filter -n 3-0
>    Error: Invalid range 3-0 (start must be <=3D end)
>
>    ./page_owner_filter -n 1-0,0-1
>    Error: Invalid range 1-0 (start must be <=3D end)
>
>    ./page_owner_filter -n 2-3,1-0,0-1
>    Error: Invalid range 1-0 (start must be <=3D end)
>
>    ./page_owner_filter -n 3,1-0,1
>    Error: Invalid range 1-0 (start must be <=3D end)
>
>    Test 23: Invalid nid - NUMA node 4 and above have no memory
>    ./page_owner_filter -n 0-4
>    Error: Kernel rejected the filter command.
>    Possible causes:
>      - Kernel does not support per-fd filtering
>      - NUMA node has no memory
>      - Unknown reason
>
>    ./page_owner_filter -n 1,0-4
>    Error: Kernel rejected the filter command.
>    Possible causes:
>      - Kernel does not support per-fd filtering
>      - NUMA node has no memory
>      - Unknown reason
>
>    ./page_owner_filter -n 7-8
>    Error: Kernel rejected the filter command.
>    Possible causes:
>      - Kernel does not support per-fd filtering
>      - NUMA node has no memory
>      - Unknown reason
>
>    ./page_owner_filter -n 8-1
>    Error: Invalid range 8-1 (start must be <=3D end)
>
>    Test 24: Valid nid - range and comma mixed
>    Verify: should have node=3D0,2,3, should NOT have node=3D1
>    ./page_owner_filter -n 2-3,0| grep "PFN" | grep -o "node=3D[0-9]" | so=
rt | uniq -c
>      91741 node=3D0
>      19389 node=3D2
>     110286 node=3D3
>
>    Test 25: Valid nid - range and comma mixed
>    Verify: should have node=3D1,2,3, should NOT have node=3D0
>    ./page_owner_filter -n 1,2-3| grep "PFN" | grep -o "node=3D[0-9]" | so=
rt | uniq -c
>      43462 node=3D1
>      19402 node=3D2
>     110288 node=3D3
>
>    Test 26: Valid handle mode + nid filter
>    ./page_owner_filter -m handle -n "0,1" | head -20
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40003 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00000(node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 =
ns
>    PFN 0x40004 type Unmovable Block 512 type Unmovable Flags 0x3fffe00000=
00040(head|node=3D0|zone=3D0|lastcpupid=3D0x1ffff)
>    handle: 1048577
>
>    Verify: should show stacks, and only node=3D0,1 (not 2,3)
>    ./page_owner_filter -m handle -n "0,1" | grep "PFN" | grep -o "node=3D=
[0-9]" | sort | uniq -c
>      91677 node=3D0
>      43458 node=3D1
>
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    Tests completed. Please check output above.
>    =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    ```

I ran the test script and also ran page_owner_filter program myself. I
did not observe any issue. Feel free to add:
Tested-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi



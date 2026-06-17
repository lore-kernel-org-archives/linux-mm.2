Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B170CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EAEE6B0099; Wed, 17 Jun 2026 10:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C646B009B; Wed, 17 Jun 2026 10:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B4E6B009D; Wed, 17 Jun 2026 10:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C70846B0099
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:37:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 482B51A0489
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:37:47 +0000 (UTC)
X-FDA: 84889658574.02.17E1437
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011031.outbound.protection.outlook.com [52.101.62.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 76740140002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:37:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J+oJjBr8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXy9+eoqBGkuZ1U6lG1Crs4VtIa5GriWtnCV98d17A4=;
	b=KtVDQcIBmrqk2CgSkfhW8Wwdu44kVA/QbOzKIDVw0tWYzblydtefdZFPws9+w6Op3RxlP1
	jgzA3OU/IKxFHQlF1eZNLSR1Cl+LvK7Q48ql5ZaodshXXlpVhbpyMyLvpWo+lQOc3gRuA6
	4AVq8iuptarOTovR3jCRGEL0rVQwG6I=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=J+oJjBr8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781707064;
	b=pRyrW+THHhhxxOA2dKlgOC0SvxwAxj2RCnB3hwuze1lJ4XhOk8rCHx6oaQpZLgzQ0Ysba/
	mz25oabCZWGmVL8lYIHHxaRSh0lC/yA/lxE2atCy19QKu3qA1SlhfFbdsx8km80Oi8OugD
	uLnUkO4KzAO9F5+w+mlmga+ji55dNxI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kb7CWD0G9DxqaT9pKmGJFOUtq3soDstYmdnWSq3E49DP7uYVJLUQqAFNz4cFNNOxs86qw4KxP6mM5I4xtgic5IIdGNmg6ZoE3qDWSOr3rsqNstOqeluJ2F3dHRgEa3REfs7iOpkMl/L7sbW/seTt5Ux0Ao8h8TBxWhQX2mnN4liXhS549Vz6+iiEqae2lrs2CUSD5o1yZeJlzEU5osWJsPRPWDAgfcl55SaeFVslTfWEPlTFjKekuUGLZFX0oz2Vh8ulbPwX3IyYfH9RrzbbNzDBdO/4KfycwyUhlv4N5i+g3y5xrRY2jZ/Bcsbzt8FAh3zalMbNhWtznAleZdJn4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXy9+eoqBGkuZ1U6lG1Crs4VtIa5GriWtnCV98d17A4=;
 b=o0/A+CGT9hWIUs3690Y8dbodvtrI789Z0Jd62XHsQAvJnZW3gyUNueAhHAayu7YTW9W90SjDEtA1/xFUrOI2oJjpcey98Z4OThm7+Jhq90Pt212Y7HH+NADh5yLZoGsxMImn5cfLeYJlYZKypyFbBzTzpbQWjskGk7mcLb8aOVJK5mtZIgOt73KEDRrhvFQUg1SzYedegWB1oXTAQJNWJ6n85oLNlA+dGas5OJ4jHijCjAg9M8A2a3kbdLw5tZjcVXhm4uor52OKnz/d/TdL+DgaKK+JRYQFkuA0F5tp7P+8kcZbj/SXw53ZI01aY9A75BVt9HoWzgASdQr1tNOFXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXy9+eoqBGkuZ1U6lG1Crs4VtIa5GriWtnCV98d17A4=;
 b=J+oJjBr867akoqaq2p7y3B+va4epRX9wRgRjlnXYO6AVMIO6LuFUG8GhXn5XT1HrNGFlHI20+rf1sMpjjALb3xNK5eiWFhjVl+LOBwDg+jzF5B1FkRFxBuEZ94hhmoezRHHDFqzeaMcntVLHzbTt8/n5t43dh0nOj3UzzAQdoJDR9GYhaFIKvIaBwkQxrDUyzJV3hh6HvRRp7/6Be0pc3GZWMRp88bzDcJF2nVbfNVwkNYIrjAreiQiwnOBWCIUGyLTuXorDuEkwR7EciF7Xoct1aiYoE9pk67CK9GJ7luXqPP2Qb42cPShJkRim+ekfJBpS7erhsFAI2f+2Q1AVBg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Wed, 17 Jun
 2026 14:37:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.011; Wed, 17 Jun 2026
 14:37:37 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jun 2026 10:37:36 -0400
Message-Id: <DJBEFU4GU2XN.2R2VIUH7TSAGG@nvidia.com>
Subject: Re: [PATCH 4/4] mm: migrate_device: use walk_page_range_vma() in
 migrate_vma_collect()
Cc: "David Hildenbrand" <david@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, <linux-mm@kvack.org>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-5-wangkefeng.wang@huawei.com>
In-Reply-To: <20260617082622.3397584-5-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: CH0PR03CA0277.namprd03.prod.outlook.com
 (2603:10b6:610:e6::12) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 825c8fa6-e4d5-49cf-0abd-08decc7dfa53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|22082099003|18002099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	WtaTHoWIoLThXvypJha0iO9Q3saoSujSpYB4NdldhzXYMrhQpMCo1CXkkRYWu/UgsbAyfSUxZOA64MHRkVbp6hNPyaFoSiLWhwys7lPQO2tFSZFGMM4oMdRF2vKV3Yu9gKv74ysOpeAN7lHzjZTmsSq7tRate5lbZgsQSCoCgKBmJU/Kzhpy9DJi1/cc65bfXzMll8BgLE7LuADHrN7MlF0CFudDNRZ0wkeNpShvC/5mLd5gUlj4EDkWa3a6A45LnVN91aou1eAbX8onFizbc2F9xKRWCsY9MxjBg42+RL/f3ojEUKYz2LRHbobU9c7wg4i9H3WL0EqpuBZ4XITCCpivmI27ockPWUmN2Umx4DfbeS51Cx7ADx0251KIc8rfmucvlFIRpcllNTqjSGdLBrWg0t2kmh4wckx58FEFa1uBOQC6YYHzoFT/Le2uEEAbhCosr7OWfELuKKrzJ2egEYI4ZZM+8xVNqAFRXpgF3O46aJ7ZFhShpo89YUQKjvOtC4BKp4JQbhSoPN/VQT7IEVkw2HYOuIJ2Bx7I8cmSqGTP1ikh8uFxY39Ef1WpEIQx+r0m514bq8TlX7mkvkbGvMlYpzoaLF+WMZV4WhWYoUohQA9pxu+xigVMGxqjHznnBd76OJsIkZrcgSrSgqtc0+Dq7liB4SJQUGEVH0VqylTJ1XIAmQuig1P1kEVrW375
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(22082099003)(18002099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1NZMFkycWFBQUJhRXNqUXN3eHVuY3VGcDg0WGEwTFFvRFFQZEdRcEdhY1lv?=
 =?utf-8?B?Q0s1M0xGN1Nka1hSY0h2ZkdZanJNajFyTnlLaDl1Z0h0ZCtVcStHQmN2VFF1?=
 =?utf-8?B?aGRsQUFBR0FHVmlTZG5scEMyaEovSUNKQVp3eDdGQXhnNWoxM0x1M2NMQklz?=
 =?utf-8?B?SldJc2dVRVhDVW8yUEVDQzcyeVlXM3F5SVdGK1VCbWlJWnplcWs3cjVRbE45?=
 =?utf-8?B?M1E5cmdIK21JRUtUUmZURGsrbEkxZCs0RmNaeWNqVStYWitPbFkzRnBlQkta?=
 =?utf-8?B?MXo1S05CY0wzM2QwRlpYNkF2eW9xNnpSaEFoa3VZOG9KZzFMWFZkQmEyU1Nl?=
 =?utf-8?B?d29xU29qOHlmQlc2M3pobkhTUEtJanNwTUZrclVzalQvTnV0QkdVU2JCZGJG?=
 =?utf-8?B?QVBaQmYyTllPZUVBMVl1ZnpleUdoNjdYb3BFVTlGa2pGNHZMZFRZRG0zcHEr?=
 =?utf-8?B?MUhPdndJN0d2Yk1QR2RHZVU5WGJsRzFHd0ZJNVFNZlhYakJFdUhsUXRYSU0w?=
 =?utf-8?B?ZFp5WW5TWDRHcUZlUXp4NmgzRDBYWUJMb09XVUdQaDRyRThjWUpUb29vczJX?=
 =?utf-8?B?S0d0UmgrSlUzRXlRZGExaVhWSCtyakJ6S2NoWXpjREZ5VjNjZ2lMSUVFT0Uz?=
 =?utf-8?B?OCtMSUtjS3IzUVJwUHhOa2RNdHhBdzNGaWEvcjBaaHBGU01VdzU4R3lhQWRZ?=
 =?utf-8?B?V2Q5TGZaUFBOUU1ydzRLN253TDFmWDNzUmIxc1hXaEFkaFNBMVA0SXJwS1hv?=
 =?utf-8?B?Zk45K25PK3Q2UVBVQmVVUlVIRmlhUVFPRGtBNGMyTkdnbDM0eFpOV1FrNTIr?=
 =?utf-8?B?S3N0b1dna3NoRkJ5TVlTcmFFWUg3ZmxQUGdGdHY3YUZVc1NDYUR3MkFHTWtR?=
 =?utf-8?B?RDVsKzdCeFpPYkhwdnh1ZXpWQlE4aE1CZVpHem9RN1FqMDFVekVpeG1GQWE2?=
 =?utf-8?B?a3BzMlFUSWtCUzYxQTRPOXdjZjU0MGRLOHhRdXhsUzlrY012ekNMTWNEeWYz?=
 =?utf-8?B?NlQ1MDNTR0hNRlFuSUJsZDN6MmNCL096cHk5a1VrMVJxUUV1VExhQUdzSlNY?=
 =?utf-8?B?anZ6RGNlOXdTS1UrQXNNZFBQbjBUUW1TTmZiSG1FOWw1LzJwbnpUYnMzYitS?=
 =?utf-8?B?U2ZCMy9rTHRDMExDakhWaHI5VXdKb0NETEtxM0x3TkFtU3FLYTBqeG1WdFRa?=
 =?utf-8?B?SEhGaVRGaFRpbk5RTnhpbHpZU2tHanJoTDllZW9zVVMyZkpmWDF3ZklYaXE4?=
 =?utf-8?B?Qnp2bU93VUlxVWRjSExIdzRxekt6azlRRUp4QmV3MWpPSHIxdFhjKzljeTVw?=
 =?utf-8?B?d01KSmQyNVZDaTdGUVlZekNwMFUrVGoxVjl4aDhzcXJHRWNDU2NUZ2RucXlC?=
 =?utf-8?B?OVJKM1lRWnZETnJYUXJTTWQvYjNtK1Y5VDJFUGx1SjRCKy9NdytiVmZPM2pB?=
 =?utf-8?B?MGYyaC9YdHhZNkg1QVVTS3d5bWZ1UTJhNHJsWGJTbmc3eExTQzMrR1lMTFNL?=
 =?utf-8?B?ZSsrT2VpVmNCZUZkMWd2RHRoKy9SOGZqbjFKVDVHTk53cG9MZjBscXZ4N3hq?=
 =?utf-8?B?aVdzaG5ZSzRBWXNUeDlkR2ZGVTArOFlXcWphUXlrM1Z1aDBCdlByUDc4MFVs?=
 =?utf-8?B?bU5GWE9ZL0MrUWZRVDg1a2x0S0xHUHF4UndZQTcwN3dFNkFZODVFWk1pTGNv?=
 =?utf-8?B?Rm9sZkhyb1NqVDRCNkZpNlB2b1Q1bE5sc3ZocVB2VStCU2ZKZnFGMFRKeUNX?=
 =?utf-8?B?TXFxOUI4YnRWNnlVY3hNSTN4bm5aQndla3NhNThZZk5sejVid3JNOVY2bU92?=
 =?utf-8?B?K2JFdFUxcE90ZEVtUGpxNzNMV1FjZHZRV1lpSjJQYjJFUk9rUGZBcDJCbkpS?=
 =?utf-8?B?MGcwMVNrSlM2Vzd0V2E3VDIzMDFUQ1hRVjBYUG03N1ZzUWdJYUsycUxWcTRl?=
 =?utf-8?B?eXFOR1c2M2NudkFNNG13cVQ5UVorMURHMDR4WExsN01NMHlOVUc3eHJNeUJp?=
 =?utf-8?B?RjJ1aXZoSFU0TnBWQjB4MG5ibWVRSTR2RkhyK2NMYW9vQUdDNDBRTXhNVXVn?=
 =?utf-8?B?VjJsZC8vNjFLclQzTDYxZGhLOUE2Ui9KWnQ4Ympxcnd0QXdFQS8xUWFqc1Zq?=
 =?utf-8?B?bjBqRHE5K21rOVBCSitJSnY1NkhBSG9UQ0svZzZSTFRUWTdJQ1Bra29WR2lY?=
 =?utf-8?B?Q3FQdDEzOFlNWm0zcE1xN1o4Ujh4UERKRU5iRVk4T0Noa1ovQkNpb0JJbkxj?=
 =?utf-8?B?RmttYUtyWmxvRitGMFJ4dGM4cVM2M3EzSmQ3Y3Bka1FmaTVCcFFrR21jWFIv?=
 =?utf-8?Q?ng6AOKX9dOq6q07Zn9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825c8fa6-e4d5-49cf-0abd-08decc7dfa53
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2026 14:37:37.7480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AWJ5je/+Sw4iDrmSiGn6vc6fpPVgNW2mP+XO5cGMDmiJHOdauEBDs6TGumxoosOT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 76740140002
X-Stat-Signature: e1qbo5auyi8f48mps8i7qhkr3pjn6qfa
X-Rspam-User: 
X-HE-Tag: 1781707064-631486
X-HE-Meta: U2FsdGVkX198ZvX/kYf/F0kCExCZ1yTzMh+TclKJ9JuKFHOs06x0LHaURsfB/wrIyfhRMaKGjUMFYXQTEo1of1nM8CbmTfYQXNdwcGTHfaZoVHfeRIABm2U2wFwzHLW+qgCEeG+MKNOh07rtn8ok9dej+hjOYOxWiU/E2voijgC6YTw2OLiqJmQttgnybYIiOZMId4KoblkpcCRjm4ED3N+K1KCM7qub0DiZH5T7WD08qmSXY1omSp5Vc8u06+0i8QyaIS/rBWUzYmC4+7oVpNyVKRKLD1IItlGbvAgxMD1zKAN1hsW49nrdT+HDsk/q6I++AC0WVSZIZUs6u1WaThrn00wwhV/FHtP/piVYpTqP0mkWr1+0h7cPwFT/wKuPeNBhs/mhZKvT5gxaGc+ZeMlgmm28f2ys4tnnS9z8EJsJrGppedn7ollK29MfdSzBFluJr/GJ/Reby/SSGiFBod9Yqj2bc6muYfWne+mD2e2i+FDmUVlm78qGpRZe3tkU/byCRZTrCBILRnojgoKWETuAyzgmoRUl7kY7/xo7ia9abYe+2fJQVOhUNTzAGmsZ8boDT5oj7i80jBD2zSmo1y5Y04ov7zikErd40Cw2wfKF1tIpohi4MFmE+lT5SBRPrc8iTvXAZ2ZX3eUnDyCGcgY3ucGBdpJsLfM2b+9EiyMK3vrWi1arxFHvbNhQKS6mIDWquJQaOzYYWIn5reoNSa89m055uc/joKv3uk1qpR/4C9mi74s+oKc9sBDGfTcpXbrXrHholfOV+OiDgvOPeBzVTDIHmu0Atpcu5whdS7nxFJLvwbgkE2BhwRxBaHvpO0IEbGhlK+fYhdrNY/FFq4F+/ezx0YuLplYil7V7/a4wwmKEjyde5MZ/jcwRFItgJ/Ugy0ZYs/3AtvSboOu/LuKTzaio3eNNTuwDKWU22fhPgq8bK2b5EpVgG5DYp79qXDfcrMloi4RawZxM6dZ
 enyy+5Te
 w5998w9ULfls1eFxkcMLVV7YL8t+ZForgZ2DVzB9rzaxPVIhVCWSQwtBjANsVMISfxJNPv2ozdOqy4fPxVETACVLtMr5pIrgdD1g+Dnxrn3wa/YbAkpVvmYT2qgjAQxAoC7sjpTQNHbZxLpIwqPc4JfOk3SVX2L2TxWYML9tpPXKz/gUhJ8TLVOtfIU9dCFLDcdRh3lE6iSMU5eQk2OnGNSHv0gjlkGNUgIZwrVe9/1HawLYmljPxB3LGmKDOeghXkKk9TxAjANhXqMJkmXhkLr1VKHYkAWSf3BEL7ZBJoLhUOenicTEO9ZtdNbjVnNmsY+LT6NL8nH2RZx/A+K1p7mgoVMkAReyaZEbxkeT5oorf08wwfpxkTpI7V4SE2/gO6kze1TGDIYtO68swADZ0JdqHra2l7x4hXnhcBPpWtf2VDJnR3+MxlfDNFtC8j6yjZ3Zk+hD3COWkcLwow7CkWEDa+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 17, 2026 at 4:26 AM EDT, Kefeng Wang wrote:
> The migrate_vma_collect() uses walk_page_range() to walk the page
> table. Fortunately, migrate_vma_setup() already validates that the
> entire range falls within a single VMA.
>
> Since there is no .test_walk in migrate_vma_walk_ops and VM_PFNMAP
> VM_PFNMAP has filtered by  migrate_vma_setup(), it's safetly replace
> walk_page_range() with walk_page_range_vma() to eliminates an
> unnecessary find_vma() lookup.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/migrate_device.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi



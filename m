Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD70F103A9A0
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 03:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9A56B0005; Tue, 24 Mar 2026 23:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38C906B0089; Tue, 24 Mar 2026 23:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252B06B008A; Tue, 24 Mar 2026 23:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9616B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 23:03:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA22A14068C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:03:02 +0000 (UTC)
X-FDA: 84583088604.02.6640828
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013050.outbound.protection.outlook.com [40.107.201.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id CE51C80003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:02:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dYh9cPd2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.107.201.50 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774407779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1q9VOPSjn4SbjBBsire0l/DMEOXf9LqcBJEy/3dxKc=;
	b=NS8DYyudYbuixDnAN1rtrdKFREEz4DXL5I2cErzj8OEt37K+JU1thwsk7Jt5sCOyQPsEGS
	/91qwJuoqspdGTNR1JK2Gq9Mxt0RYNrRaB8pukb367hH5RbvT0+iyMx7JQJgfjVHmBop6s
	/kJKVrbOGllCjFBAiD/hbIj3Ku7bl+Q=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774407779; a=rsa-sha256;
	cv=pass;
	b=pO4vzevy4V7Z/Xmjw4kBEnKr8IPyv7M+DI0EkaWsqQpf6ETXrTYjes8rrgyKHz7HNG4eaJ
	Kcu1jmCpH5l83Fb5eJ9zX9nj9aFbIl2HNNyBdgHT3okoxitormIEsd5CxgThTEICxvOQ+G
	Iab3qCVqAVRlXmgbtk0vUVwW9knNlso=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dYh9cPd2;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.107.201.50 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3QIq12Fq61mH2B8ipGyXVuK2gJsMgQ53UVGAgEsznfQP/hZG2H45SeqX0Ka/kV94KxgageYr+eMRNgWP2d0LWI/aEnVChdV7256G9irR8U5tvykz1ZaVjLgmrEVSJ8WqOudHQ8CO2bghduAUhKiLVgfO7QK6jbFFwtpQ7CNjjHn/O2sJy//Az+HBIOTG8yv8TXDdbmMaP9FFnwURU0R4Ir6DUC9TClyZvNJn+T2/n/p7EHclZmQ0VZMiPVvnoN394YbrOdrjidFIVPj5+2pG/UceBmT9wgHyik0fkFx1VVLQP0ao8WYR63d5DiY09W0ZQdeiEDiXDKiiHzAhAp0NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1q9VOPSjn4SbjBBsire0l/DMEOXf9LqcBJEy/3dxKc=;
 b=WRQ3uRbT2HNuOdX2kt58lawwtwGfvTLR5Q7bOnQl407YWq3mRQDhobg8nn8nFzRfn6TFoqqMaY2TKKSwltoTX2GmeY+UYSAh9vHoE+Ile+VpanIbxeREE3ieL9uN4d1sq0AMUUQ2RhXrQSmYfb1Y/zYM/oZuHyr51+WxtqC13Mi+vgPQ43Oo8iJxDi3W39x5vANMKpEl0EMkdFSpoX4I/Xf+DgV4FswrhY/I/k7CQTM/iBjH4jIrGGrsnkiilHy5n/q2+H9jLivs/p3DQCCZ1E+iGPO3/V97DmwpP2IZm2dl9bFntDu8E1muwAKJJKijRqlfmd6+GdMJFnqEYPjn/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1q9VOPSjn4SbjBBsire0l/DMEOXf9LqcBJEy/3dxKc=;
 b=dYh9cPd2Sg04TVNo0rboSemdsa5X+9JC1kB6oPopPXpOg6Weccr3SdrTl/lYXXzREZW+5mp3t55bvWokOzMGSVmVPGsqcN7wEsOphyAdzTIS5mkednlfk0eR5oOIgD/92pGaKmdtFjr9AmBy3hIWYIW8EJQTO8BOnBB+yY6vTSMNO6XMcVYseS8Lm9ql3IyBhD68+sb5sLa3pSrUssTtLCgsvUoG0DaeTg3+jiA3kwFEbrztMyXfBsOg7sCc6CkfReAJUmvfx7ur4RwsL4gzKBirB0Jb8wcLeNqjEJpYMMRwnRicBr39i+z5u7NguPiFafas5fQE3rr415WRQxUHmg==
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 CYYPR12MB8889.namprd12.prod.outlook.com (2603:10b6:930:cb::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.14; Wed, 25 Mar 2026 03:02:53 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%4]) with mapi id 15.20.9745.019; Wed, 25 Mar 2026
 03:02:53 +0000
Message-ID: <f2e2a9d1-8540-4aa8-b9fe-f2ed46391801@nvidia.com>
Date: Tue, 24 Mar 2026 23:02:47 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab,rcu: disable KVFREE_RCU_BATCHED for strict grace
 period
To: Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry.yoo@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Dmitry Vyukov <dvyukov@google.com>, rcu@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
Content-Language: en-US
From: Joel Fernandes <joelagnelf@nvidia.com>
In-Reply-To: <20260324-kasan-kfree-rcu-v1-1-ac58a7a13d03@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CYZPR12CA0009.namprd12.prod.outlook.com
 (2603:10b6:930:8b::24) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|CYYPR12MB8889:EE_
X-MS-Office365-Filtering-Correlation-Id: c9a5c7fc-397b-41ae-3303-08de8a1b01b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|22082099003|18002099003|7053199007|56012099003;
X-Microsoft-Antispam-Message-Info:
	Gq2W1Px/bUd/u8bEjnFQjX3g5CYLX8GK/ujhI0ScM+fgjYuEs2fxa/f9GoiVH5FT/7wXPlImOBmKTsPMhHV4qArvBzBe86xp0cpsIM3kQy9w/WZgjadPXxo00hM1d8v3rUFTXNIDu0qhlXPAXgtSE+yVB3P2kZKi/GkcD+lRKndFd05+E6ghWA0dAB9tNkDfuYlY5tBBvAKbNUy29n0Pxs+V9yE+0j+NBAQPjQWRKeHeCKS653LgK2TngIrgVOrdo74XqPAyyEhNMUtj+4BpYBm3wCSFv1sNH3tuH7kHw7/ARG3Uvawf7zY0IM12qXx16JmibZCiKvJPlI9iL35P/Gzgxx1cvtTXbqwJ6MlF00gnhuPg8pIUJ5UaI0n06+DK8zcNF+G3xDKJj2GyT6C7m8uuJ458dm/gDeKFiIR60fdbSHe/vZjggiHnJJsUNhm7l7ouBfxUO2RJHyv5nECSUHdEDReLMw5WZEWgbYFXTBxMzo4CcOEueGlU9LBgw2j9mOGChLYPOBm6SqT7sEyADiY1g44UaltL5lYzoGIqGsc8A4BHhCk5+nPboQ0JojAoieY/H+6oJmfGxUNykCoiL7ZYp6qQObN9qFHAGbvlxhYebKuy3MyVfcwWGwg8igDRKYABgCSIBZtGw+rjhw9MnVhZEpVL4XsICYONoCfmOVb5rayCVd+aUQ8GLlwVT8CJogzqYpoWyp7VXRi6ly+xc5rOPTUAiuw5Lk2YfugoMDU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(22082099003)(18002099003)(7053199007)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RzJ6YjFkdTIzck1KV2IyKzlNT0JCaGc2aTdYMmFlZFNub2JpU0tmMFRZTkVC?=
 =?utf-8?B?ME5wNFRCU3kvUHFCdnJTd0pvODE3d3Y5YTZhMU9SeTNVY1FqcHlmNlNoUC81?=
 =?utf-8?B?bDNpVVlLTWNTMkszYlhVVTlyL1J0QVNPTWlHbnhaZXAreXl5ZVFmWTBzOThK?=
 =?utf-8?B?NXBuckhyOHRiWmh2R1AwODBLeThoMHhXN0l6bm9ETXBEdVpxMEJOYVhUMTNi?=
 =?utf-8?B?cmNwRFhidEtOdVQwSUFENy95YjdZZ0pBc3JqWHpWY25MMEtMdWF1V2hFUVlj?=
 =?utf-8?B?eE9GOHRwSVFDVlVkSU9ZMlJjZkh4eXpFVTdOTzc5eXNTbjBjakVpVDFpSktL?=
 =?utf-8?B?MXhZQUgrUlJReEZaQWFTb2h4OVNEdnhUYWdEVVpoZXA1UWhVU2Y5bTRBSERi?=
 =?utf-8?B?bzNsbWVTMk1CTkFsR3VuS2I0UUZWZzZBMXkxOWMzdjlkUUhGOUs3S0JDdzJn?=
 =?utf-8?B?MVhNMWJhVitrNGZiVXVpMFh1b1BRdzUrKzNiTmZsalpDQ3hlNGhHZ2FMUUYy?=
 =?utf-8?B?eDU0TS8wRTNEUUFCaGRVQnUzSTBKNUowdmRQNWJKWjkwbzc0Q0FxaW9LdGQw?=
 =?utf-8?B?NElCMDVMVDVYUmtCZjF3eHJkTjV2dDJBeURsZHNINi9JRHFaODJjQUV0bk16?=
 =?utf-8?B?Y2ZqNlgxRElOWVUxRjBsSVBUT1BmNE4zY0NtZTl3MWZNNDc0SzFpUzEzaDc0?=
 =?utf-8?B?UG4xM2lRRnc1QkkrQUQ3OWVrbWRCN2FKVzBKNnZoUEw3blZpVDBPKzhOZFhn?=
 =?utf-8?B?TklWM1hDSUlBekwvZW01cW5vRmZqVXVWQzFUYXVlNFpicXBzODJ5U1J2Skhr?=
 =?utf-8?B?QWM4emw1UCtHVjhPTXNRL3dnOFU2WXdkQlRnRG9UbHVWeHNVczZNNFlMaXIv?=
 =?utf-8?B?N0dmWGZ6OXJPSmZXZk5FWnhEU0FWbURkRy80b29HRnp5MkhZQlZGVlZDanpj?=
 =?utf-8?B?VXlMdXl2R0psejY3ZXlaZ0FSVERCK1o0WU84dk8zSXZDVm1YYUVsUm91SE0y?=
 =?utf-8?B?YjhCYUd1UXZyYldMaFFkZTZjL29mc0VPYUhTclV6SDBZTkZIREZneG5WYjNk?=
 =?utf-8?B?WXF1VVJLN0t4UUVqSzhVWmpaNE9LRnZTN3Z5MnM5ekM5U2JEWUpvdWc5dk11?=
 =?utf-8?B?NVRNRUNWN1RzYVJYRW1rcnhBMU1vY0prTjJTZnJLRlA0ckRhRnM3TThUZC9G?=
 =?utf-8?B?UWlTTFdrOFpXcE5pdVpxemZnTWxuUTBsMG92UEVMUGk2ekVqcmRsbDNJMkM5?=
 =?utf-8?B?dU9EVE50MENZbDJLTEhRekpBTVMzUjFRdkd6QUZTeTRxaVZIdU1hS1hPWG9X?=
 =?utf-8?B?Qlh3R2xxbTYwdEZ1bFJlM3h3Q2VnM1NaZ05YNzRwS09rTk0vQTM1Y1poSlIv?=
 =?utf-8?B?eUZvNW5xbWZaMW5xTlNkUUFEMituSFpFT0xic3ZCYjkvLzB4OFdPRm56WW5m?=
 =?utf-8?B?c2Q1YURMYTBkRzdRdlhoaXFEdENNUHppSXY1SzZYU2VWaEF1SWFFSVJYTFEv?=
 =?utf-8?B?bGdhWVR1cy9PemY3dmlyaTlhS3Q4V2x5d2hpOGJSVGtnQVZEZlJwQkVNNDhu?=
 =?utf-8?B?UkJrYXhkbVM2TFAzVHova0lOQk1WUzJ5ZlZ3YnhsdjVqSE5XaE41NnFRTUlj?=
 =?utf-8?B?Ny9qZVlRakdzODNPd08wVzRXYUNBc3M0N2RJTE5ZOWRIWnRna3Fwd2NMdW5k?=
 =?utf-8?B?ekZxTDVRUDNOaHlWOWptaTluZ0ZhV05CbVRRNGJpRjNUOXBaZ0QyNnJnMlpN?=
 =?utf-8?B?bkF2TGpBbVlwa1Mzb0dNNVRJM29GZ3RvTWNNcUxyWE1adE9wVmUzeENSZmxZ?=
 =?utf-8?B?RTBrUTZHMVZzS2tZeTYvK2VNVDBJZ3lkZEVlUWFtOUhaR1luZWpQaUQ1MlJK?=
 =?utf-8?B?Z2tmTXBXcTdLM2toTnRoVFU0MktaYmgzOUZ0NmZhaW5GU3V5ZjYzcnVnMUl2?=
 =?utf-8?B?cU1XNzZWS3d6bDRVUFJvQVhBMS94Y2lmbmgwRkpQTHdPOHh0OFZ4QngxY1Jw?=
 =?utf-8?B?U2VPM1NaUmppKzU3Z01jVmxNSmJUUnF0cjY5K05qTzcrSUgyaVNvQ0JSLytO?=
 =?utf-8?B?M3I0TW8zeHdBd2tBTld5OElOK0VpQkRlYStJQXpkaThzN2Z5RWduSm9hWHl3?=
 =?utf-8?B?TlFNeXVkMWNVYlg4bEIrek5IbHczTXZZZC9XaE9EMjF3WnRXRG1HaWFLYzFq?=
 =?utf-8?B?a2lpeEE4MlNTQlo2QkFQdzFFbjdUYmRPVzBvb3FrOWVxeS94VnU3SkZUcXU4?=
 =?utf-8?B?Qm1JVUY4WVZZSFhaQWNSaXkzdlZhUUVoWFl1UVp5TlVLZHpUeVY0cTJlamxE?=
 =?utf-8?B?Sk1IaWI4dVUyeUd2MlJLV2ZFOW1hNDNWcVBwT1A2OUVNUVRFaHkxUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9a5c7fc-397b-41ae-3303-08de8a1b01b7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 03:02:53.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QBpmygZ/WeDJhqz9h+vFTsai9ghDNDct05ZMeXV/ptwIBx/3bz3hVRM51EzNwtuXKj0SnMWzgs84fwwOq70O3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8889
X-Rspamd-Queue-Id: CE51C80003
X-Stat-Signature: jeeq7ag5o6un1qqpk9oubbxojsj5mynm
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774407779-788960
X-HE-Meta: U2FsdGVkX1+YvqYcrfJeeurn4dgamNGvrxjZh75KEi+Yw9pGuphSvOOlH2K3MtvzLOjZTa5WtVh8+CyYALV0Tg3z2/F3yvfRvLer178JFe8XDNjMiPgUIHfwVunQSn4unxmmmLzq0RJSOHEX1m5+7chDVwz19VEwHNG4OKbRouTuehliXsX6yU5CnMgd7wkWFDuaV+NDeSLfJSk8+5A5f5aTAZTIHVXLzrxfxvmXC2VI11vQ7V6xOTsyiQ1IPxAciN4vEZWCg4Ww7QjGPlPZx5JmPKPdOL8yra8GAT11hyLvUJZFKWK9TKaJvCGa/39QfMP4GEoi5w04l3p5hUAI1hy4F5kNg0N8aYrpc/lPh2X0j8ArNkeeHfTBh6kiVZ92C0FrM0nFmegsQwXcx1BcOnsXSDV06f1yhgVJK1IwZ5u36MKkM2Pl1Z5OdY51Sz8JkXMInST+V5h1b8audD8R3WykQj4TmR5wEobeQhEncIDr0CQDlAyuh5JPoIFax1rM2jeVzevJy1zF8KcgasubS/nbFmGtR4pyrdPf/O3R2AtnwAIeYAdTNIkWTC3es9aN+Okb403kACQLTbFSMUlg4kTfzZDHDpeRS13P/tZk8WpPXlgTvTPPteqZzrSecH4dQks0nOmHn313wF/Er/BfDerZ2zOBPSL6GKoGEJtU38aP2s+SRyhMwBPWyBT0q+WVEaffYvFr5aLlwRaYBBtEPqHUcjSqrzUnyrJcLtFVtdgs4eSi+mZz3JMEskYtT+5vQwzoKAZszySJ3ginGBxD4/qTU5svUoicJqT7sf0s0NGAvu/+yN/xPwcod/Oe9UcNUnqrayo+OLZfAs3k1fpFnMZAyPKFPuV87HlFGcR0w/1VtCJkY201nYkIfzDdX8iPNOir5mfb6m3+Lao+UI2OCAPyCvqCtoOaHlqEqzsM9QhnX1VKmtxV7m48CqmPPpW4M0B8w/ruozjVwAEbZmi
 AQibBaYe
 9JPxt6BajYUJzhxPyoeDMPwX6sy2P/0lRxWO1GR4K+nlm25D0G3TdlLANKKvnHd19NrNcxsBEHtcMkKTON+D3lKNaYfiIgT3daawDEboEQSn/eDqfpMEPBMyWpmnYkg39wY/Rk4zBdxsQAbE7Dxj4NiAlhhBUQhYMVmn01bFMOvt0K9deVpYQimQtWY6z+inTn3sJe7pWN7zRR6lLjjCZjLUvbq2RFp5uYXm8RWKKfu02hPkaRDsnI1a3M0Xrr61GcTE8RWNxB3XWf2ngoVo5exWhpi1PVzTQnR6PVGCe6dtLYeWgrzeozbqGxTEocHu6L62Z4+RxpDwgRam/6nXduxmSs10e4O4sIw6XLrK0iOAJEHa8F1IKxHJ4cBHhv4v8y5frNbZGI3BydSpKjM+13FZ4TPp262phrZevFOor+gxdQh5xcbmOwAO+96T+Bmqg3pmuGRWp+sW3cw0KzDu0hoCM2c1kXdDnMseDdXVne3CWnEJsIZm1gytMjDGPVVPqgSEj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 5:35 PM, Jann Horn wrote:
> Disable CONFIG_KVFREE_RCU_BATCHED in CONFIG_RCU_STRICT_GRACE_PERIOD builds
> so that kernel fuzzers have an easier time finding use-after-free involving
> kfree_rcu().
> 
> The intent behind CONFIG_RCU_STRICT_GRACE_PERIOD is that RCU should invoke
> callbacks and free objects as soon as possible (at a large performance
> cost) so that kernel fuzzers and such have an easier time detecting
> use-after-free bugs in objects with RCU lifetime.
> 
> CONFIG_KVFREE_RCU_BATCHED is a performance optimization that queues
> RCU-freed objects in ways that CONFIG_RCU_STRICT_GRACE_PERIOD can't
> expedite; for example, the following testcase doesn't trigger a KASAN splat
> when CONFIG_KVFREE_RCU_BATCHED is enabled:
> ```
> struct foo_struct {
>   struct rcu_head rcu;
>   int a;
> };
> struct foo_struct *foo = kmalloc(sizeof(*foo),
>     GFP_KERNEL | __GFP_NOFAIL | __GFP_ZERO);
> 
> pr_info("%s: calling kfree_rcu()\n", __func__);
> kfree_rcu(foo, rcu);
> msleep(10);
> pr_info("%s: start UAF access\n", __func__);
> READ_ONCE(foo->a);
> pr_info("%s: end UAF access\n", __func__);
> ```
> 
> Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>



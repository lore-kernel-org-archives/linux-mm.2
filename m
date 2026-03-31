Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0AFEFF60D0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6856B008C; Tue, 31 Mar 2026 04:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD736B0095; Tue, 31 Mar 2026 04:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3B76B0096; Tue, 31 Mar 2026 04:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1576B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:53:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6E1B5C972
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:53:23 +0000 (UTC)
X-FDA: 84605744286.25.21044FA
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012027.outbound.protection.outlook.com [40.107.209.27])
	by imf03.hostedemail.com (Postfix) with ESMTP id BF02C2000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:53:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E1t27CJl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.209.27 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774947201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxOdWp6/wXKPGDHPF0J/yFuuDk2+PXrdIYFhCvjHkNQ=;
	b=QooQJda8EO90u7t/9rSb2YsVXTK5R3wMoBGwG/NRmvBhSJEEdlB/TS5EQKfXAKflqWgMRj
	y5i9RdLTZpQ4LIfWziAYIyjfWJvr9gLnfK0LeNsLZEM3srm3gGweFvFDfFiFdozRPknyn/
	gVJW6ZyhCpFgGwe+8DltvRxGTUxZCRg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774947201; a=rsa-sha256;
	cv=pass;
	b=kw7DriNGNrQH26O+iqUM+8XyfUvCG3ILax1RG2RnKLDKwROO2Ox7dU2tgsy9f+vnYR0jJ7
	+uUsSv5+qDDOp2RXvqBBIrgxP+iE8BMiuF/eQUAyBgzeiXM02t8UYBF7raWwOf9Zg5vVoB
	WxAmyjJ8hozy2iWBu7HbQB+qI5/qrtg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E1t27CJl;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.209.27 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uf8xB61kU2/Y2p6jH8ml7dbFDcZOcppKwqp3EibndmH8zTQA9FSZ1nFIkFxOO1R35Q80H5ftFiP65LFf5OKBeOokvmm2o5o9tA0yn74FGgdfTZJ/sZd+7RGhY5OYiUuYAyNyTxGnCXgX+C1jIXg97QrOUPSlHQuF6heQ0US0nASCqqX7iFK+NoqseZVZr2OymDH74Ujs3FU1Pk326vsaJXJ1RQsxRm+n5MVcP75ROz8KnLCGngkAoWkh8eMd3VHcHXzsZHn4yzf1AvbcFq0b7UKUZNgqxXOFS2BFlOipFOAfZcr8o51Syy6XqDMK+yiemmeDvbDz8imBtd0mCLNGWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxOdWp6/wXKPGDHPF0J/yFuuDk2+PXrdIYFhCvjHkNQ=;
 b=m/F76ANLCcpNSgK02rMRYflv779QkAzJYof9P7zJF+cHDjFyxg0iOEHsyuKVJKv9WA+hKEDahwCY0eTgdW8paWhoAmS4TQ4H4nwOQ9pTovBM075wZGrHVeE/1JKPRoRFFIbQK1IA011Ycb98yxgk5JTowe/7VQu8dg66lS+vd6wXYtAhhS0V91Ut6aCgqOi1dZxnJ4xiQ2Dr8f2pcsGvem6MU8yak0J+ZJJOcPBolkhw4XNCCstehDD3pgpUUxdeO/rVUMoJORiczxA+9+ky66+n5JRDI6jaKz4aPI/2kQzilkx1qL7xvIN25AqcqVMziKUbD0aNB43KbaAZkHDqRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxOdWp6/wXKPGDHPF0J/yFuuDk2+PXrdIYFhCvjHkNQ=;
 b=E1t27CJlHFHk4GW4wSSVMCHmOrhdDKL0fjC4xakHl9PaLt2MYYdKt9+bjopdNwsraWEjEBd5AdwwEplxsZNkuTG74ZGo2iviEUIadRV5LGZ3fxPgLovEEuZOxiSlA4ax/sEttxowO0xxmF+eiZ/BwkBvZpp8sf64n96jbI5H/LfpzTdY/cfuSwZnjeAEbod4CvO9yvNAd3fCy3sP00j7YJay2HCs4VoqUCuBZ76EfLQvlYFRZbSJoFUE9Pw0enRsVnVD+k7P3yBfAOajg3AaJ7z1cHHoHUQbSHYXQ3XjSNXxLfvpraR4GglRkZ59mttFldXNGl68TCoZrg7GRkClgw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SA1PR12MB7444.namprd12.prod.outlook.com (2603:10b6:806:2b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Tue, 31 Mar
 2026 08:53:12 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 08:53:12 +0000
Message-ID: <59e7882f-2fbb-4e8d-9986-e0f70d902d44@nvidia.com>
Date: Tue, 31 Mar 2026 19:53:07 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] lib: test_hmm: Implement a device release method
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: zenghui.yu@linux.dev, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 david@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 dri-devel@lists.freedesktop.org
References: <20260331063445.3551404-1-apopple@nvidia.com>
 <20260331063445.3551404-4-apopple@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260331063445.3551404-4-apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0042.namprd05.prod.outlook.com
 (2603:10b6:a03:74::19) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SA1PR12MB7444:EE_
X-MS-Office365-Filtering-Correlation-Id: 09ebce38-01d3-4e5c-f1a5-08de8f02f0ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	HyhYd6Zfrp9uICCQHTwkgR8+HY1131TDlXisyXlaNHb5aIHfAENmArUN85kO4B4rzj9lFVXiOQm+Vtxr9wLSnGzfOwMxIgQzsP3V47vne4nuQwRldgVneyHaZpqlQPXmeheztW79+RwX/dK39v5fu0B+TIi0z8aOysF01P2mZE11Jk3QrKjadW9+2nigKM4faXsrKRnLnlZANF9ce/JrqIMm/L3E7cndcoM99CsL/b9MG4RWVrepX+6joky7GYbpqutj6ynSuTHolLgKY9nZk05a2+gbW8c6Lg4iCFNdZdWvJ2Q41H7Z9muIhl8HBESb+b7vBpcyDXJrldwb/tQuTo2KafqKB/BCvNARPzlVtsxTNDGbjhhtPZMBV7Cu1/vJYBjMsVZb0xY2GcXeVtDkAcoqlUOTWnb44MJ43901VutqOIUFg7VwRXUUkfle+CZPbyzP6AV0OmBWbSfM9Gm7N8oFJmCFqhQ3GNN6DZUw3n7pB7hB17d8nJFKPfbjhnamnagLLwTp+329NT0j/MZDU4hRvj5jbvyPo6iHS8cuomaCNk+s2qGrTgLZ47NiF3F7LT2k1BmKeUeqxOulWX6c2wS8XA4w+v/j5x94x/hHAlzS24c4r0orrbWfut+PqlwFybRxVkgybOpITTtkNlBQ7/Utr83zOdBDoEiKZJX+PaO7nKqQpirxTRn5Ofrzkh7a+2MAMr/S3khXx8UIUQWNM9cHQC4EAvcohyDEuFqGzv4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aDRIc2xvOGhBM1ROc01YN3dlNE80N0F1cHNXMExsc2xOK2dJTEhBWFRITEhB?=
 =?utf-8?B?Q3hjZ01PR0VHQlliNlBSQWdoWkpsOWZma2F3L1ZuUFNLRmJEZU1EdW9md2p5?=
 =?utf-8?B?Nm5VNVJwclE1dUlFTUpBUTlod0kvNFc3UUlLbE5Kbmh1RXljVXgycy9kVk10?=
 =?utf-8?B?UFM2SVJYK1dXQlJFY0tJcEF3SEVlbUVIOFg3UXJTalBXMWFBNHM1aHJoZmpr?=
 =?utf-8?B?c1NJS3BVRTc5R3B2Ty9Jd3BUWW90a2VNMDNXR01BR0hLbG1pdXpxVkRXN2VV?=
 =?utf-8?B?d3VUYlZtTWl2L1FmNEpRamRlTnZlaTF6QXN0Lzh3SW16cEpWSWFiT3M3dkw1?=
 =?utf-8?B?dzlGN01NVTNPY28weW9aUXdTc2ZmSDNBd2FNeHdQWDF2enNHQmxybXlMdDRF?=
 =?utf-8?B?WkN5TWJiYURDdVArdlVRa0ZiSjNvak1iWkhyM0ljK1pUbVNBdU1udVpScWJN?=
 =?utf-8?B?M2gvYmtOcS82MVhkalJiSUEvKzlNR29wRmh2MC96bDM4bk5zZTdMZ2JianZT?=
 =?utf-8?B?VTNmM1hqQXIrZ3RrS0xqL1dDZEZKeEgzUXpZRmE4YWFUOVQweG9mY0dTWC9i?=
 =?utf-8?B?Z3AvZkFhY3dHcWVSbHY4SnpDVHNlYjI3WmNGOWRHQ2NxeDYyV2NjSlB2SmdQ?=
 =?utf-8?B?bmJBRG9RUEp4MVMxMGxWSDNvVEFYbW1KTmNETmczRmpMY1hqdVhoOXBlWXpa?=
 =?utf-8?B?WmI4Y2ZJdDNLMzYyWFFLVmtiOEVwSXFtdUp0SldoelQwc28zajJ1NW5yRW04?=
 =?utf-8?B?Nld0Q2RQWUxxWlVwQURQMUN3TWtEeTdRemRJRkFleFNFajgrMm1qS2JWU25q?=
 =?utf-8?B?dVIzTHVGODluNXFCbGgxY01JallCcDhUNzVHaTZoZTFlbFBQYjhGYXUyamJO?=
 =?utf-8?B?YzRPcnN5ZUhPVUVhM2EzelV0akNyaGIrKy9SN3Zpc0VsdXg3TE1BNjFWSW93?=
 =?utf-8?B?enVmUGNGWkovbzlHYThsam83QkhRZ0FSN245NFlUb3RIVXdNV1FTc2dtaVhQ?=
 =?utf-8?B?UDRhaVFuUXNIeUFCL1lqYU5lSXN3OWhpYWZuWit6S1NrdjJKaG9XU2YyRGNa?=
 =?utf-8?B?NVBCNXRZODAzbUU3QWpGekVHaCtldW9OTFBUZG1JcUUxcFhwZ3phVzZyWm9E?=
 =?utf-8?B?cjgzN1N6OFd6SU9wK3crRjdNZG9PZDhYM3lFT1lxNzgzRGFTR0t3Mlc3blZk?=
 =?utf-8?B?cHdscElrUkJCZmhndDJaVTkyMVdBeDdseWNLQVg1dkJlMVl6ZytCdS82VFZx?=
 =?utf-8?B?THNvNGlPbHQzNkVuOTlNc05GS2ZXd0RvT1dyUTBYWDV1V3hiT3VxWndtSUs4?=
 =?utf-8?B?ZVVqZ0QxWjd4TEI1cVdhdnBBVzU4cW1UZ091OGdlMEtUMitVS2NpSGNBQVhv?=
 =?utf-8?B?KzVRZWlxU3JpNTRZRmlQK3g2S0pRWnhiSjJLSDZaekxWcndCRzdsZTRKYy9N?=
 =?utf-8?B?SnZ4Wk5sMU1uSE5XQzZVYWhPSjhqOWRVb3Z1amk5Ky9QNVBlOTRrUitwYVVq?=
 =?utf-8?B?dCtOcm9sWHN1Tlc0ekZ1eWI4TmhlNm02b1c5YjU0VDllQmVEZE9JQVkzU0d4?=
 =?utf-8?B?NSthZjZBbUJTMmJmZjBxTnFYdkZKeE9rQ1dYSkpmMjV1ZzEzekVadDZ0bm1s?=
 =?utf-8?B?dStyZ3VXaklsbFhteUVIVDJTanZzczBObjhXbWMybDREUVNiM3pHUXM1bjV4?=
 =?utf-8?B?MjgxbE80R211Rm52RVFoU0NiTzkxOTlXZmMzV1UweFM5cnhJUjFtejYzbjJa?=
 =?utf-8?B?WklOOTdyYUljcjFTVFc3eTQwV2tBTEpnR3BocCtWRUhtSUZ5RzFsOStINlM2?=
 =?utf-8?B?MjlEN012OUc1cVVHN0ZGTWJPN1pJeVdZVWJXaUhvR3N3dkNweGhDcWtLcitV?=
 =?utf-8?B?d0FzTHJDVG8vVEEyKzhUT1NtRDREVlc5cmhXMHBSMWhBdzkwbW9ZdDBPRG1J?=
 =?utf-8?B?akZ6UFpua29xWitsb3ZkTTk4bnVpUGduV3lZcmI1S0x3NnpkOWlOdld0R2ti?=
 =?utf-8?B?MFRJV0xKL0kwWmhUandaM2Vramg0R1dtcUdVa2J5c0dQZ2JoamxwT1FRb1Jw?=
 =?utf-8?B?UDVISXZtUitxbmhFQUhTWGtqNmFaS3hlTWNKdmVwSE5YTjBLK0tjOWxob0dE?=
 =?utf-8?B?R1BhTkNyOFBLeFloaE5IR1VZL0JZMUZhZ0psdTVUZ1FSbk1SOXhmOU9CblE0?=
 =?utf-8?B?RWw0UlN2enBuNEN4VmQ4dzlzUGZzUjBqU2dmRitKUW5qSUxEd1Y0TVBIRTI3?=
 =?utf-8?B?blE5cS9NOS9nY0hRTTlyZXl4RzNlUlRWa09jd1NJUW5JTnBaTnJZVUtHQy9p?=
 =?utf-8?B?NHpiNW5jdFpBdlV1YVRYNityOHFlT05yZEJHbE4xYmEwTDdjclJTQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09ebce38-01d3-4e5c-f1a5-08de8f02f0ae
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 08:53:12.4730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNlkB7DFZudelzK2micN0kCjq57Wga3x9Nt8NkmLlU4D2bZtLhhDvJssqZwb6qTwn5YQKAnLgjnafxjUy1c/6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7444
X-Rspamd-Server: rspam12
X-Stat-Signature: ja1hyg9dcgb9itjwmdhqawdqp7smhjir
X-Rspamd-Queue-Id: BF02C2000A
X-Rspam-User: 
X-HE-Tag: 1774947200-746578
X-HE-Meta: U2FsdGVkX1+ky+Tq/QFpyCjT7D7/Aw/J2O5lG9DGaOkboynR+57dhc6bsxUJ+CF3fj5pofKPIPe4Imt4Dl4Lmb3mOB1tbpGfVm1MBLFBXOCpVdMxTn0Jl01eT3HSY0jEatnQ+dsqr6l0WTFM4r2PqTIJD6C9FT8QzWxNNunstCaOoSQtEKfObO0Jx8nBr4J56/q+t7eVsVehNgRyRfAV+e3/lBA5IWcNmcYTOJcGjxz4vhucT/oJX09FjPMg3bt66SneNSE5VoONC6IbGv8JJaGcAfTgOH7h20Yg5X/OdlcnB54bPBQqggoZMONik7gOXsfRovguWZnyGvBa9wFzMo0F6lYAZ2ZfKfTUdj1t1ThW00XA8zP78lIlnsTHOpOsjL0MzLfomy+/kteRuTlPynrda3UFwhxbyf/UVHOmoNIbOwmak4Pbc/dboc/62GKzGfQ5LQNHMaOSPpjTZfGX52KbX1M6viZmTumri3CCZaWmZNSERVE2epXv65TaQLkLgLJQK/HEuWxe15N0KySZuikSc0yqs6pG10XsQFcs2p7Q1FTgsd5nZ5N46n901j8hhA0U0TKAHfGDFKJvhUCqjlMs8tLUKJ9pnIO+y90Qb26a1V7u+ozPHgUi2pHsaIuvL+oF2rH47MeaowuIcTB5hUMll/JvRjfmOKY4T6p+ojd+ZHrRLYhlWh78nC1tqDLjBXRfvuMR5fja2G/Y6Dz5NxHwUYoCN0ahUM1XonklKfSNntF11yr8nAK/wlihYElzKlVenSbPbmxcsdrg3RVcaEFr2zAADim1Jwc+J/zM5gKjC/Dw6WXSj/xd1Ie9IAzz8K3gUGVSCpkB3mpi5moruNqhCOqux6A05dqYWBIXfgTpUX+veyrDA5K4OcjaFkU2WcvTjHg5HgflXjrs9VH6BYyZNVax0ywrAc+15qVJCdbHHlI+7C5FsR5NAkVPitCGfUJWYfqNWxOiCpgTfql
 /emYnoQt
 DRs1JnaStr0lAAYZa+ErDnVrIZUfHpkax8y0lyjoslTxBxbVWvmzI7TaHnULSUTatXob0QF6CunUIp6U+klrIU1yO/dMDuxw72WqAn/SY9C7X8kKO2HOMDvbS8oGcTgQSpV7dW67255GvPaj6tLBkzYEL/Rg6tM45weJOxJsj7P8OCttlryxJcFogZcN9dWSq8TIbUwiGAYBLL049qND9bjFhsHKtFzCTe8lcBRrTtGcki4ealkLK4vXrJXJVUWBRePoBdxM/UH2DGOz19h7NasnzZ2NPXCWdcx4378vJLyU44GkIRggkz66OhthQZt5baldNh7xnctH/4+B1vgZWJU5l15Ifv1Pu2VJYpr0O5HrNlqnhZAkRzT1bRwPjrPMhVwmIEkQuyG3kbUGio7rYOHwkTK0/vdrLVPEaUSPq2VbSQLsU65WrxjA8oH4lNqmpQZI+1A6KzhwqHRRVxb9hY7nmjPIez0RAD6uUhc6Pg4fLL9PMIg06R8peWW7X1m/LYRn5PmVQKjrjemnOQgIJMiMZnAz0888HBWbM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 17:34, Alistair Popple wrote:
> Unloading the HMM test module produces the following warning:
> 
> [ 3782.224783] ------------[ cut here ]------------
> [ 3782.226323] Device 'hmm_dmirror0' does not have a release() function, it is broken and must be fixed. See Documentation/core-api/kobject.rst.
> [ 3782.230570] WARNING: drivers/base/core.c:2567 at device_release+0x185/0x210, CPU#20: rmmod/1924
> [ 3782.233949] Modules linked in: test_hmm(-) nvidia_uvm(O) nvidia(O)
> [ 3782.236321] CPU: 20 UID: 0 PID: 1924 Comm: rmmod Tainted: G           O        7.0.0-rc1+ #374 PREEMPT(full)
> [ 3782.240226] Tainted: [O]=OOT_MODULE
> [ 3782.241639] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> [ 3782.246193] RIP: 0010:device_release+0x185/0x210
> [ 3782.247860] Code: 00 00 fc ff df 48 8d 7b 50 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 86 00 00 00 48 8b 73 50 48 85 f6 74 11 48 8d 3d db 25 29 03 <67> 48 0f b9 3a e9 0d ff ff ff 48 b8 00 00 00 00 00 fc ff df 48 89
> [ 3782.254211] RSP: 0018:ffff888126577d98 EFLAGS: 00010246
> [ 3782.256054] RAX: dffffc0000000000 RBX: ffffffffc2b70310 RCX: ffffffff8fe61ba1
> [ 3782.258512] RDX: 1ffffffff856e062 RSI: ffff88811341eea0 RDI: ffffffff91bbacb0
> [ 3782.261041] RBP: ffff888111475000 R08: 0000000000000001 R09: fffffbfff856e069
> [ 3782.263471] R10: ffffffffc2b7034b R11: 00000000ffffffff R12: 0000000000000000
> [ 3782.265983] R13: dffffc0000000000 R14: ffff88811341eea0 R15: 0000000000000000
> [ 3782.268443] FS:  00007fd5a3689040(0000) GS:ffff88842c8d0000(0000) knlGS:0000000000000000
> [ 3782.271236] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 3782.273251] CR2: 00007fd5a36d2c10 CR3: 00000001242b8000 CR4: 00000000000006f0
> [ 3782.275362] Call Trace:
> [ 3782.276071]  <TASK>
> [ 3782.276678]  kobject_put+0x146/0x270
> [ 3782.277731]  hmm_dmirror_exit+0x7a/0x130 [test_hmm]
> [ 3782.279135]  __do_sys_delete_module+0x341/0x510
> [ 3782.280438]  ? module_flags+0x300/0x300
> [ 3782.281547]  do_syscall_64+0x111/0x670
> [ 3782.282620]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [ 3782.284091] RIP: 0033:0x7fd5a3793b37
> [ 3782.285303] Code: 73 01 c3 48 8b 0d c9 82 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 b0 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 99 82 0c 00 f7 d8 64 89 01 48
> [ 3782.290708] RSP: 002b:00007ffd68b7dc68 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
> [ 3782.292817] RAX: ffffffffffffffda RBX: 000055e3c0d1c770 RCX: 00007fd5a3793b37
> [ 3782.294735] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000055e3c0d1c7d8
> [ 3782.296661] RBP: 0000000000000000 R08: 1999999999999999 R09: 0000000000000000
> [ 3782.298622] R10: 00007fd5a3806ac0 R11: 0000000000000206 R12: 00007ffd68b7deb0
> [ 3782.300576] R13: 00007ffd68b7e781 R14: 000055e3c0d1b2a0 R15: 00007ffd68b7deb8
> [ 3782.301963]  </TASK>
> [ 3782.302371] irq event stamp: 5019
> [ 3782.302987] hardirqs last  enabled at (5027): [<ffffffff8cf1f062>] __up_console_sem+0x52/0x60
> [ 3782.304507] hardirqs last disabled at (5036): [<ffffffff8cf1f047>] __up_console_sem+0x37/0x60
> [ 3782.306086] softirqs last  enabled at (4940): [<ffffffff8cd9a4b0>] __irq_exit_rcu+0xc0/0xf0
> [ 3782.307567] softirqs last disabled at (4929): [<ffffffff8cd9a4b0>] __irq_exit_rcu+0xc0/0xf0
> [ 3782.309105] ---[ end trace 0000000000000000 ]---
> 
> This is because the test module doesn't have a device.release method. In
> this case one probably isn't needed for correctness - the device structs
> are in a static array so don't need freeing when the final reference
> goes away.
> 
> However some device state is freed on exit, so to ensure this happens at
> the right time and to silence the warning move the deinitialisation to
> a release method and assign that as the device release callback. Whilst
> here also fix a minor error handling bug where cdev_device_del() wasn't
> being called if allocation failed.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>


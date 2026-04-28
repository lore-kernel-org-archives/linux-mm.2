Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FC5BFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 12:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09746B008C; Tue, 28 Apr 2026 08:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93616B0092; Tue, 28 Apr 2026 08:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9341B6B0093; Tue, 28 Apr 2026 08:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0BF6B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:11:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 236AA140138
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:11:21 +0000 (UTC)
X-FDA: 84707849562.03.4C7AF61
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1196B160012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:11:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=N9hfJcDL;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777378278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pusGoY1TNiOLL9nRkJ59swYHbVVS96nowf03OZ8RIVM=;
	b=eg62o6e/Os0AHIazHZ/bHWE5a+YXWAtU0v6AYc5fD5+yDmqL1NsqXWu1cht3XuM9lRGpE2
	kPq+Umary6EfFLDGrhe3+M3CSQ11+MLybjMAGnYcL6a/o2cxpTK7AmF4lavxXZGdlPSWJx
	e8Tj41hRfT8YKZR/HvfTf9681ms1vaA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=N9hfJcDL;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.48.41 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777378278; a=rsa-sha256;
	cv=pass;
	b=luf47TR9MnYEeyGPgpOoWH/uQablxaPHKjfviNF+B9wafdudAsKVaBGbjQ8KQ2+MODnqQl
	Uc+tYTkjArO/1+6ed+JmQ6tC333ZN+Rp3tVTXRrakvtrXrcuRmgvimY4L0dyy7uvhH9Tb7
	LhIHWbrsPqUvAq9cPODGaB8DXlCZPPg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=avIdnVDRw+65AaE89VNmIS3YxNpM5xSVc6fIQvOlQA+qHDeie/PSUMpFbnOKlp8w9h+aVUo6V4fJA81aGhZW6g9Rbmszvbsa1+2OLQMPr1bte4xPIJgpCpmB+z28o+Plpc9GlBRdWDIp24gzaLVY200X5RcT865ioKtIcryCzsmZW6rtm/G717FPCs8CfECeoNVglaNZIRgfd7+P9RRfYyjjNrvI/iR54tw0L/8DITUs2sdztTBmSyOQ4i+B6DVa9a0SuuemXHvcUZ44q8gytR/hPAZaPOxmQCYgLBn3DWROnilJlZoh/9APUip0YWFot4b3NXICgJdffpY99tH2OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pusGoY1TNiOLL9nRkJ59swYHbVVS96nowf03OZ8RIVM=;
 b=g2hsfMPXMWn8KJ4Gt8PPhi+P5phXiyPjwwYamHm56hEAW+6vvTzE0QA1wYiHjPfIT6oV6vuLdxOsN6DEqmZpYKzgyii0wno6jnrjWr8osvevnExwVqwuFtWJ2/LOhZ0ta6hubFw2TJuBMieLY0VddCK6/PErhqvwjSiKerFegm4KFtM7iWrsb0w3HMqnKf7G5OBwwo0crL7U12IaInmeYH9d1eBCPiB3k1E1CWe6Z5dsxtB0zf5+Kp6fBp/lqugwCxb+ESrjpuYRdQhiqvaDAlYYhs9KZ6Ne3ykMrWpd4w5HvZm3zlyGKz3hoilasoIzACTD4rHy/kQgGZe49/Fq9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pusGoY1TNiOLL9nRkJ59swYHbVVS96nowf03OZ8RIVM=;
 b=N9hfJcDL2vxfiWieTNJXSdojgY5UR8YxKzTV0yqgzdGeH76lxhacBIDAlsVnuMjUKvDnJ3Ynxdjr3jsrA/mynxkcyF58/kpjtjx8aG2GKjyWJSFBXESIaqhh5+H4CWivrvM3KqlbKOTV92Pr1opWUlfH0bNooxeSTQ0mZNtb9AE=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by IA1PR12MB8493.namprd12.prod.outlook.com (2603:10b6:208:447::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.16; Tue, 28 Apr
 2026 12:11:06 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9870.016; Tue, 28 Apr 2026
 12:11:06 +0000
Message-ID: <4652f10e-1993-4151-a0f2-1d1623de79f7@amd.com>
Date: Tue, 28 Apr 2026 17:40:53 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 4/6] mm/migrate: add copy offload registration
 infrastructure
From: "Garg, Shivank" <shivankg@amd.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, weixugc@google.com,
 dan.j.williams@intel.com, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Mike Day <michael.day@amd.com>
References: <20260309120725.308854-3-shivankg@amd.com>
 <20260309120725.308854-12-shivankg@amd.com> <87o6kdzeei.fsf@DESKTOP-5N7EMDA>
 <70414c31-d928-41a6-89db-eeb0f34ec07d@amd.com>
Content-Language: en-US
In-Reply-To: <70414c31-d928-41a6-89db-eeb0f34ec07d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0096.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::36) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|IA1PR12MB8493:EE_
X-MS-Office365-Filtering-Correlation-Id: 1029ae5a-f88b-4757-60ea-08dea51f396a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	6sZ8ZP6kV/bPLaFUFaVeBP1EdoJqsNVNtPOAKEiYsDCnsWFMpT7SNPxboVXKwinivpmxFlXyzFiHNhrxxRhZAexMjMKXGsgqbP6/jhisSrJcD2pCGal+KhwTqkw96bsRARQ1aGeVDH2PPwii7jJQ78mcUICxZNeEc6N9XGXTQQKBWsA7JAgBZ3yZoIHBhe0XFRLAwQqu2LWLeeFbNJ6f+CD6jsUrDLwFCLvOszDYfaeR+PyydPts2LA9KAl1U1D5zFPtnMi9BGOP8jzTD792pDiQ7A8jHpcPYB9+igvXD/VvvT6+jjaG2GqzNpM8xOYGtxQ49VLOWTtNVp//uP0UsxBWMdxjGlT7ru66qi15t9/BmT/VAgPHeMtSbARofBVi1S2Kjbz5ab6kS7Ec3gqborkWAbZwdFzl+e7i7CGk0Q9CbhL2AU61JL4GBGfnO/x9nTaegpZz+0BG0Pux/OiDotzpTHsXIDgfrFYMeaoGv9S+9FnJshvVZc9Rn+fI3N9PdMoeGhQ2bcH8wzJ7wZYVf8sBlQAEUIhoj/zRTevosD2twVZ+oMjswOfAXO12Z8QIPxmq2qbvM2u/jJzUL9pc9Y0qOsgL2sCwDDoljTBJOTJhixpMZIw3zTfwB5LSS/AuoF6CaGiB0fFl0wE/pb4yfTU+V5sz+EZpig1n83lRPWSO89b9HWD59FnRgc2Rnvvc+PFIz/PvvbQkDwB/2J9pnEsf4V6RXxLmJEJZbsgYqkg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S0M5S05HK3V4QTBGMzE2MWNzRE81ODhVNStYTHFoUjZxdHdoWS9Lby9DaHRS?=
 =?utf-8?B?citzN3FadkV5U1ljM1Q1bkgxdW1ZTGZ3V3pTZkorUW9PaFhXalhyN0wwdDdt?=
 =?utf-8?B?aThHUjBSbksvNEVXZEg5TE1ydksvYktOa3B3UGJEVU1Oc2krdVZoWDhPZzQr?=
 =?utf-8?B?VGNpMGpsOUdmTjJFL0hheUtqbTZUclNMMFNtMGpFdlgwT3d0VTdIclZmekhF?=
 =?utf-8?B?WHk4NWIwam1EMitpMjd2ZGF3NENTOXFaVENad2g0ZUV2Ukl5TGdNajBoa2Mr?=
 =?utf-8?B?a0daSGozc0Vra2RIR1VXZy9CUXFwMTF1bi9HZkJmV1NKaU5oaGpyZkdZSUVq?=
 =?utf-8?B?WDc0akwvQ0d5azNodmxGTmpNN2NBVDF6bmd3SUVjREpsL0d5cEVrZjlBUEVY?=
 =?utf-8?B?RlJ3d1FITWtSWkVkQlVVOEJUeFRHcEQxMnJoYW93M2RkaGU5T29VdFRXMjhX?=
 =?utf-8?B?bEhvWUVFWEUyZ21obDlKM29Rb0EzTzREZTV0TXRwZ0czeEQvclFWRVpPUXRq?=
 =?utf-8?B?Z3czZUZORVhFRG9CVFJpQ2gvUDB5STR5b05XUjhRM2l6eGx6eG1jM2xLQ3NP?=
 =?utf-8?B?eFlmMXV0eHZ1Q1NNNVplaVBRMW9vZ3YwUEt5TEpIU0JiVnRxT2VvVURUT0t5?=
 =?utf-8?B?dy9jb1lLVmpnMW9nUndXMElIRjVwS2FTU0E4VDZZNGZQSmc3eVBQemFPQ1FD?=
 =?utf-8?B?V0FqT3dUMkJGbzNENFc0VEQybmY4Vmd2bUJ0b21aQTF1SUwzVmxJMzVSZWlV?=
 =?utf-8?B?Q2JySUFGY3hkdmRZRFliQWVFcEgwaHp1Z1pGYmNUR0lTQ2RPMkNsUWh2dnQ4?=
 =?utf-8?B?QkRib3B5eG16VmFVT1pSRUE1Q3FSS0lDR0JVZS9NMEU4SkI2RlNwVzM4YW1R?=
 =?utf-8?B?U2NvU24zeEFadVNjcUxNOWh2TlhWVGZVK2hELzljQ2F4elpCRm9GRzRvN0RR?=
 =?utf-8?B?ZzIvVFp5Qng4NTlhR3RqSUdFcVQ3eDJGbnk3ZTEzY1I5SEZhSjNQQ0p1TkFP?=
 =?utf-8?B?Ry9VOHI3ZnFYcnpvR01mU3VUMjZ4WHZyTm9pamJtZ0FjR2V5RnpORjZaZlVl?=
 =?utf-8?B?dkQ3bzM5RDBKZGN5WGN4NGtLZEJLbyttamlIWFNGa3R4dkJzeE9BNHZZdXkz?=
 =?utf-8?B?c1ZxL1hZckVuTWJFQWtGSWlQRmV1ZE9SSWlRYVlhUnRVZVYxRG50MlRIRkt1?=
 =?utf-8?B?SU5YcGFuWVNFQmJkdFRaT3lBajd6UzdraUllTUZFdnRwWDhIMXZoTGdpTUZL?=
 =?utf-8?B?OGN5RFpvYVpSN283QzBhclNVeUlBRkRKMXRFTk5nTHd1KzIrMERIVGJ2TFZm?=
 =?utf-8?B?TGQveHlqWHNFOTZHRlJjUTZ2eUtOSGs0UG5jZDRPMmFUWFAzalZVVDV4V1Zq?=
 =?utf-8?B?bTRtUzVJbi9rRDJkNmFvQlF2ajNpMjhpVmovQkx0QTJad01OY2h0bXA1MG1X?=
 =?utf-8?B?UyticDM0Mm4vK05QSC93OFpsamlxbVVtb2hBM1NEVWN4dnAyRDBVRURtRis2?=
 =?utf-8?B?UHRkNjVkelk1R3k2Z2gvUGYwVHhiZVNTM1NMVWhOVlpGQU9FWTVnUEdjb1ll?=
 =?utf-8?B?NHl5aEFFY21VeTJqVnJIUlIvZHpQLzZPdW5XM2Z4M3F0bk5xYitSdEl6VDJU?=
 =?utf-8?B?Q2lGclQ1ZDR6MnFuS0dZbHVvMGswbTgxL2ZyaktjbTA3ampYdVlmUzhLK21v?=
 =?utf-8?B?NVFFUlNFYmFRbDBZUS82STN3YjBMRWFCb2RHNWRQSlJxZHF5OWJiUGJQSWY1?=
 =?utf-8?B?Y0FtdW1JaDVTSGI4dEUvVzlFVDAxMC9DSVpvUzZSV0tXZVRLZDlVa1k5YlJv?=
 =?utf-8?B?bVB5VWVWNmZoSnZaMVBWM1FtTW1zM0ZCYnhsMlJLejI4QVI5MzFhTHNPSEY3?=
 =?utf-8?B?OGNiUGZDSTA1OU5jWWZzdCtMUzd5RGxVaW9ranhDeHZVeC9RZzRQSGV2NVEv?=
 =?utf-8?B?SWp0anE5aEx2dGYzcnNaeFY4Wis3MlovbDdJNXQwRWtKSVJqOWRyN2p1YktL?=
 =?utf-8?B?RW1HTlorSEttd3dzcXpWWEUzcFVob0x5WVJEM3J5Q1Z4MHJWMHUvVmxZd2pl?=
 =?utf-8?B?eVZzR1lVUzFDaVBjTkluZGhvZnhuRUZtV2xDbWJpSy9OS0RONTEyeEorWXBo?=
 =?utf-8?B?TTU3UVZlOVR1alM5aDdsbzNpcTZINjk3REtwZml1NWlYWlZNSGV6dlVKbUtH?=
 =?utf-8?B?L1U2MVp2YTlZNSswcGMyTXBuaHB2Lzd1Y0NrVExZbWFMOUhSNkJ0ZFBLdmx5?=
 =?utf-8?B?SDJ3SWdJYnJvWDBUSXBNTE1aa2Y4TEVTZUpCYy9tSDNCZE5Bb0pQY054QVBM?=
 =?utf-8?B?YTZkWlM1WkluMjQ2R3QybWpwRXRRNnM1aUx1L3BIU1ZBTEZOM3A5UT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1029ae5a-f88b-4757-60ea-08dea51f396a
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 12:11:06.0933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQ5ZEyBfyow4rhLPExv0Wmaa4qWY6WCwmxBpV4L7fvkcIwrB7n+SYcmzeVPx4h8UeIr3h8WdXw29ksIXQ3oVGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8493
X-Rspam-User: 
X-Rspamd-Queue-Id: 1196B160012
X-Rspamd-Server: rspam06
X-Stat-Signature: 549s48umo6xfb1q9qfutyo6rzstujqxp
X-HE-Tag: 1777378277-567992
X-HE-Meta: U2FsdGVkX1/SAG2sVG8rTri75JukgNrL8Te7qNvo4puNS4FnBz43w7N56PuLPeN6t75F93aR67NBOHvuqz+IC0UMog3xXPYOvzCIybfBScZAzgOyb1f7tuxAHwbCR8P+eCTfZFjrcWc+LNzwlTqeub8gkHwtrfrJBfj7U+pnL6XU81SYdItYwAcroJk6+aKDWf+XmlZU3N1ud1tRVNv/xi8oI8PBFop3eWfRhHvYraSuNOaX+6QU3KP30efZk+/wGNLjEMNJqnyKVNPQNC2B5rJ0CotHt6B5IakXoag77qqBYNwOFIK7m4Pi+OmtnAJLt9QXCmIeE09TyMVpJIH7+07OFy1VqZZ9vYqeVaHH+Gp+EZSz42eKcvyKfSI9cu5X0nab66w6lVZj55j4MUMALsFRPJ1uFlcrMoN+1xlpNZ6t/o19rwmSPZQDSqoo68gMpPQLCTvGJ7hN7psYftW8fx6Nlet9K397znYCTpDcNcFcS4Heh0H/HMzGnJTzZPAN737UWmgOa81EKKR7YEpu+1NJqWvLyxBfe6+5nfyDcqygDFo5qLrhSkSJfmI0wc7/7PiXwNIey7XbxZ2b6+1/7l+gkUUvRLuKBduOQx26+dV7f0cj2wJxv/1Q7pBNUV+zY30jqCsoKnC4CLdLPjzxP56t3iJBQ3yz8bOQPut49sDXv9ZfQYnxC/OoLGib378GDM/9Y5M0eM95GyDYGH1cA8e2VBdFELOxtlZvO2GIqKh54yjo34+Exa/jeU6Q+zwE7FVKfaPhphCNfYMkxTQQbTbeO3xkTevk6AQP5xNfTqZpMyVcban1B81wniCnJEYMURJgbnwJYB96sijVk9PE87JKd7Rf9sfhAMTSgYrfLIpDY3vbSaxcrNZvATmqRBXjFnfhXHAvuvLO5XxjgBVB3m58XT4tZ7GKPPyxgp7UNcYFv4fR/P03dKEwFyzgKsPim0ei/C1TyZinaL9JO/y
 YXH8prFE
 MQw8HjiRAfMUCmOgDLpJCrzehiyfnli+V9RkeWIW4AlvCYZBFanhaYggIWEx1ilKPNDnsBoqg+dQlZPg7gp6qmLkwElpmppkp8L/1AHuAh2bfpPnwuUd3T2U9JS/XoX/uIUT9aZq5qOCg8IICnCmS2u11ziUdAKh5JEKBKh9OL4xvEJlghTZyn/+ybwRdawsHgHOVgSWlMLXW8ru/m4SfPx9QNOrr8dAmBSc36hgLeHADfY/mTbn48hyboJxjERQjKk3rL2eo4YxG7bFsd2pP+BFcm1aPwJr+X3atnR95oC7izyCnlGiHum5NtvOhM7jsZiu88S3U6ZNTth/pIr5tGSnHCAF6BIAmC41NxupY1E1D5obLQ/bvG+fDNuBGXtnyABs9wcgwnMuMawkDMlC7sgPoNxHcysElWalKUQZ65VaiiuLhH2Wp5xPIGZOCN9hM7itxRGJP9St5ZLiA2MJmICl98tjvotRxhOqO2Zc0aPpsht4GzIF8Wl1unw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/3/2026 4:41 PM, Garg, Shivank wrote:
> 
> 
> On 3/24/2026 4:24 PM, Huang, Ying wrote:
>> Shivank Garg <shivankg@amd.com> writes:
>>
>>> Introduce CONFIG_MIGRATION_COPY_OFFLOAD, which lets offload driver
>>
>> Do we really need a new kconfig option?  IMHO, we have too many now.
>> Because we have a jump label already, the performance difference should
>> be trivial.  Can you measure the size difference?
> 
> BASELINE (offload=n)
>    text    data     bss     dec  filename
>   23577    1632      32   25241  mm/migrate.o
> 39202900        14159750        6502152 59864802     vmlinux
> 
> WITH OFFLOAD (offload=y)
>    text    data     bss     dec  filename
>   24444    2568      32   27044  mm/migrate.o
>     676      64       8     748  mm/migrate_copy_offload.o
> 39208218        14163942        6498120 59870280     vmlinux
> 
> WITHOUT CONFIG (always-on)
>    text    data     bss     dec  filename
>   24444    2568      32   27044  mm/migrate.o
>     676      64       8     748  mm/migrate_copy_offload.o
> 39208405        14163942        6498120 59870467     vmlinux
> 
> It saves around 5.5KB of size, when offload support is disabled.
> Is it meaningful savings? What do you think?
> 
>>
>>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>> +extern struct static_key_false migrate_offload_enabled;
>>> +extern struct srcu_struct migrate_offload_srcu;
>>> +bool migrate_should_batch_default(int reason);
>>> +int migrate_offload_start(struct migrator *m);
>>> +int migrate_offload_stop(struct migrator *m);
>>
>> Why not naming the function migrate_offload_register/unregister()?
>> IMHO, that sounds more natural.
> 
> Ack. I'll rename to migrate_offload_register/unregister().
> 
>>
>>>  
>>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>> +	/* Check if the offload driver wants to batch for this reason */
>>> +	if (static_branch_unlikely(&migrate_offload_enabled))
>>> +		do_batch = static_call(migrate_should_batch)(reason);
>>
>> Should batching based on "reason" be determined by the general migrate
>> code instead of the migrator implementation?  For example, if we only
>> batch copying for ASYNC migration, we should determine that in
>> migrate_pages_batch() instead of the migreation implementation.  Or am I
>> missed something?  If so, can you provide an example?
>>
> 
> My idea was that different drivers may have different cost/benefit
> profiles(e.g. setup cost, migrate batch-size, etc..) 
> 
> For instance, a DMA driver may want to target only bulk migration usecase.
> And a CPU-thread based driver can be used more broadly, without worrying
> about setup-costs.
> 
> But I agree it's premature with only one-driver.
> I'll move the reason check with target usecases into migrate_pages_batch()
> and drop the should_batch() callback. If a future driver needs different
> filtering, we can add it back then.
> 
>>>  
>>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>>  	/* Batch-copy eligible folios before the move phase */
>>>  	if (!list_empty(&src_batch)) {
>>
>> Guard with "static_branch_unlikely(&migrate_offload_enabled)" first?
>> Better to define a inline function to shorten the expression.
>>
> 
> Sure, will add the static_branch_unlikely guard and wrap in a helper
> function. Thanks.

Coming back to this while reworking the patch.
I think the static branch guard here is actually redundant. We already check it at
the per-folio classification that builds src_batch,
so when offload is disabled src_batch stays empty and the list_empty() check
short-circuits. I'll still wrap the SRCU + static_call into a helper at this call
site, as you suggested. Sorry for the flip-flop.

Thanks,
Shivank




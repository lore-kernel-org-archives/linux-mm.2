Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BEA7E6529E
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 20:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF346B0005; Sun,  1 Feb 2026 15:49:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662936B0089; Sun,  1 Feb 2026 15:49:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519F86B008A; Sun,  1 Feb 2026 15:49:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5916B0005
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 15:49:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD6701B1FF9
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 20:49:12 +0000 (UTC)
X-FDA: 84397077744.25.8CB51C0
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011065.outbound.protection.outlook.com [40.107.208.65])
	by imf30.hostedemail.com (Postfix) with ESMTP id 97C3480006
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 20:49:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=anyzAZjM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.208.65 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769978949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qc8BxuIdQuCu6p8puGCu3Ix62wcZnFd8+TyK5awbBzA=;
	b=1UsTFis1tdCCZW0xtJNj3rVCqzj/QxsWs0JzKB+bAj5KoYBHgmVZunrkPdzTx5NrXZqRE1
	hVQLVuslvpJKoZw3QmAszx5qOHmlVgW+38Cv5TsaXK110gXC2VaxmMgfNKWovW3At747W0
	BmeiBLeoWgmxPypGla+Y4RvocI9zMo4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769978949; a=rsa-sha256;
	cv=pass;
	b=K10HAIQhxESDTzdODMOBtMBdakwxS+Gcfl3UfD86YhMulxJoZt991FAJCLBAogCKagW4jc
	QWZAHwonKlvHtv4VAWcakAzc7O+WtQ+wl9+H6S1Thn9d+hD1Jq0hraAjpGG6aQ/4Jbr1XB
	hMzGdhZWDoZEeb54d8EjP6jks/RAbHc=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=anyzAZjM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jhubbard@nvidia.com designates 40.107.208.65 as permitted sender) smtp.mailfrom=jhubbard@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=slTKyiePjGLlSkMU8/zATnCORYpaWBzcKSNEez8a2RNNibfEYNz8Cz11WIkoIoE89U3ounZ4sVWtmV70BjTM3f9Cm/ft8DQTrkB92THCqEUHV4EotLdNJ7CcOMjM8OQinb4evxORdgWMGk4eDcWsVeDv1yrbsz6A5UXk+1nAKi81qBEPiu9NY2BTuvAGgluH9GgjfCL3xi+I+PEmuBEys4SlGDzALNtrbxip2taBKqXZYN72rQDXkg5s2zwu4XKWQ4fwUcYcMdR3ONWGwAie9x7XEyqqY3XhKVWppQSRO5j+GoDxeQgu/zi/vQv4DDfP7GKUVyHsj45EbrsUjv+cgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qc8BxuIdQuCu6p8puGCu3Ix62wcZnFd8+TyK5awbBzA=;
 b=VkFKxJJQsguFQ7VbC/WaOlQ2sJtCNWAmRW+ePwfUkJbpxzCfCigtB+krZPFWueuDgSEWeUxMktLzGzteoRfV5ozJCoHLFqCT5SSpPVaDUHqymngGKzblA29CYX1rFuxldiI9Id9OCKYdSYzICmBDzSgY1loFJsOtN06KRDIZpLAry4RPuUxUKIIfh9SJkLiE/qEc/3lY8YGfkimUeAlRV4c8uTWhiiz3uSFjDyC+6dcdCpH9FMNUbww7ZHWqFmVd1Pj52zhJ3ThW920fd4/P8B6FdMDRV9Hfrbt56uZsLXhIcOGepezhnYbZG+Mgs6al3TiEuIDonba86uv6aKmryQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qc8BxuIdQuCu6p8puGCu3Ix62wcZnFd8+TyK5awbBzA=;
 b=anyzAZjMO8CzANqgrQkl8TpBIjF9xJ8U3JbPrPKnSnLU/E8tp9PXnw5M1i6n4LV99gImdVo/j+OhMXAN5CCpNLcZE9PZSGZ9jjQ+kQs8oBpBxYD0hXmV1Grt5ncrrZoBIFVRVrivyVV8eoymtzOkKivUS/E4MPD3mS03odBE5Ejr40616C7u5ZRRiUu3Y4XMXGDpsw1UwiLrobNYRmfd8j2paULB6s6C2MfE7KyYQnFT0ITkJ4LSjMrJR28HKmyc7t+O5FwxnRCYFz5lke2w85c+HgnTqzqe40JipUKFOOj9DLOUeLaOslSEcUNW3n3DYeWBxjNjVn3Eh5spp8NBKA==
Received: from DM3PR12MB9416.namprd12.prod.outlook.com (2603:10b6:0:4b::8) by
 BN7PPFA42F4F89B.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6dd) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.12; Sun, 1 Feb
 2026 20:49:04 +0000
Received: from DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8]) by DM3PR12MB9416.namprd12.prod.outlook.com
 ([fe80::8cdd:504c:7d2a:59c8%7]) with mapi id 15.20.9564.016; Sun, 1 Feb 2026
 20:49:04 +0000
Message-ID: <81b9ffa6-7624-4ab0-89b7-5502bc6c711a@nvidia.com>
Date: Sun, 1 Feb 2026 12:48:33 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: Fix a hmm_range_fault() livelock / starvation
 problem
To: Matthew Brost <matthew.brost@intel.com>
Cc: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, intel-xe@lists.freedesktop.org,
 Ralph Campbell <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>,
 Jason Gunthorpe <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, linux-mm@kvack.org,
 stable@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20260130144529.79909-1-thomas.hellstrom@linux.intel.com>
 <20260130100013.fb1ce1cd5bd7a440087c7b37@linux-foundation.org>
 <57fd7f99-fa21-41eb-b484-56778ded457a@nvidia.com>
 <2d96c9318f2a5fc594dc6b4772b6ce7017a45ad9.camel@linux.intel.com>
 <aX5RQBxYB029/dkt@lstrano-desk.jf.intel.com>
 <0025ee21-2a6c-4c6e-a49a-2df525d3faa1@nvidia.com>
 <aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com>
Content-Language: en-US
From: John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <aX+oUorOWPt1xbgw@lstrano-desk.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY1P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::15) To DM3PR12MB9416.namprd12.prod.outlook.com
 (2603:10b6:0:4b::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR12MB9416:EE_|BN7PPFA42F4F89B:EE_
X-MS-Office365-Filtering-Correlation-Id: 097ebbb3-100d-493f-df6a-08de61d355dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|10070799003|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N21sb2hFT1dpYVJoYUdGa25mdzZ5d0NzblRabFk2TE9wMEdDcFdUbWsvTmhr?=
 =?utf-8?B?bDh3eS9zMnRaaWtjREZ0NzhvTUFnajdmM2xaQ2NRT1Npb0Zja2dVUDVrQVI2?=
 =?utf-8?B?dlNCY2xycEJsYVR0bWNqeDhBS2l6Ym5udFM2SGhGY3Y3VDR0UUpRVFZXZHhy?=
 =?utf-8?B?eDFZTnRubXA5Qm9YbHJXT01hcmZBSTRPdzhxc3BSa0Uva0ZBT2N4UUFrbGVs?=
 =?utf-8?B?eWRTLzR5NEIxRTNwQWdkaStJamlmd2dFOFExTE80ZmNzUGJERm01M0NaUEl0?=
 =?utf-8?B?T0lIWnRKcHhScUEwbnoxOEJydEhqcVE2eVRJSDJTaDBjL1Z4RjhuUHk0cjZx?=
 =?utf-8?B?aTR2Mm1yTCs3ajZVYWZVOHoxQnUyeUVEQ1NEVjFRN1BpTUltamtqd20yYzFB?=
 =?utf-8?B?eEtDZHEwU2ROWWlXcExYdzg1RFd1WlhHV1VpMStPekxyN05lUW9NQlRHQ3Ez?=
 =?utf-8?B?bktCWlhNQTRaRVBmOGxpMDUyZk9pTnlKTDFsRDV0MTJkY1JtazczdE9Xd1pK?=
 =?utf-8?B?dGp1WkNJcUJpT2pSU21xZ0JTTHNldGlMTzFSV1lJYytiQk14aWZRWHgvNjAv?=
 =?utf-8?B?OGl0ZnJqZHVQTkdGeEl5MXg5YUNQTFVRVE56K1h6WG5UaUZhbmFCUVlFRVBl?=
 =?utf-8?B?Qk1Fa01KQUNTK1FBNXp3NTJFSVRXbEtDQnRkTjRObWpQTk9BaEw1OXFvdWlJ?=
 =?utf-8?B?MU5rR2ZQMy90L1F1QzVoN0wrVnZSdmRpWUUrY1czVGNvby9KOG0xTDVpOWpl?=
 =?utf-8?B?d2F6b3YyazhqL0s1WkE1ZXkxc2R3TGlrOVFDM1JJeFdVQzBMWE1WamlweTVL?=
 =?utf-8?B?T1hyRjlBV0M2Z1loL3VDQ0FEQWRnMjFUMGFMY1RCY3dlaGMwVkNSeDN1d0l2?=
 =?utf-8?B?c0pFL3A5ZUxxMVdacjc5cUVUNzZxbGdBUXNCdHFHZFVjRkltNjY5MnIxd1Fn?=
 =?utf-8?B?cEZ3eWZXWDZIUGl1TStQaFh5ZmxkcTdUYlBFam1qM1ptWTk5L01jaVJVNGhi?=
 =?utf-8?B?ZmlFVlhaM3ZFS0dveGlUMzVNWDZ1QmZobnd2RU1XdDJtMWt0WjJ0aTl4dUVJ?=
 =?utf-8?B?VUpxVW1YaG9LQVpNb2l2blV5bjRaakJtcDRKWGh6Yk55QmZZZGpJUzdBbjRX?=
 =?utf-8?B?VmlQa08yR1FTZEo4aS92eG1iTUEyaStPYUNYWEhaWmtuMTFLZ0xNaXo1NnFs?=
 =?utf-8?B?ZFYxdjYrNSsvODBLcGM4YnFTdDB3NnFXNUtvLzhVUW9EZ3Frb09NYWkxK3c0?=
 =?utf-8?B?c21NRVJTK0xWeWtUNU42RlZkbW1hQXJqNHFRczIwV0paUkdhSS9hRFdTM1lG?=
 =?utf-8?B?YXRRaDVraTU0b1oydDBsU0czUFpGcm5HTWVXWGdzNGMxWjJMeGppamQ5WU42?=
 =?utf-8?B?T0V1NGs3VTE3cmJjUzl3Rm5lKzhxQjFFMk1KY201L2Z2ZG9IOHh5NGp4eXhi?=
 =?utf-8?B?TzF5Z2YxRTVPVWFvWHY5WEpnZlhwM1ZNSE5SZzYrZitwRTlOWFpuUk1aS2Jl?=
 =?utf-8?B?VE5BWkE2UWQwNmNBMFRGUzdSUFN1SWUxZDBvS2VCM2MzUE5ORmZkOEZVODZq?=
 =?utf-8?B?SnhDdGVDTVh1T0FWSkk1Si8yL3JFSW9neStaMFFQWi9CcHVrazBzc1JjTVJK?=
 =?utf-8?B?bUg2MkNEVHprT0RSVkZqSXVOTi9Semo1c3FCeDNpcXB2ZEJXTW9sYW1ndVJx?=
 =?utf-8?B?V1NNck4rWmNoSW8xY2xXVVQveVZ0cGJuRmJ3N0hTdkcvTEVaQjZvVyt3MHpB?=
 =?utf-8?B?WkM1V2xpY2R5cnpxVklmN2piNlptLzlJdjIzaEtmQ2VhRkVwL3dDMHRrM0Ix?=
 =?utf-8?B?Zy9ORHhqcmFnUHY3T3FFTmpGYThpMitWaUhQcnM4WDhlSklsL3paV3kxWkg1?=
 =?utf-8?B?S2tkU05tOWxwVFBHaXo3RmlncnM1VW5wQzZaeFp0TVl1Y3luZmVmVmJtaFFo?=
 =?utf-8?B?K1g3MWZ4TVIyZkZnU2ptdnVrUVduMDJSVy96aDlXR0s2N2JJcFJFRGJrbGhY?=
 =?utf-8?B?bXNpME9Kd3ZVWnR3Q1dGODhoYmpFdEN4MFY4Q3RoUE85MTBaaFhZaDVNSGdR?=
 =?utf-8?B?cnpjQ0tmcDhRTnNQZzh5dGNhK25JSWdrc1poN3pGOFk2Skh4U3owR0IyTTY1?=
 =?utf-8?Q?wVBg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR12MB9416.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(10070799003)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGhxeDhQL0F6S2krL1NydzR2VTIzaHViaENJT3RsOUNRNGVkakJ1ZzA2OWlu?=
 =?utf-8?B?d2dLRittRjBTR1Jkc3R3ejJ6Qnd0b3JvM2l6YkxYNy9zNXVKL2RIc293dmJP?=
 =?utf-8?B?dmdaSlh4WEhpMHNRa3BvWjJVYWFjNFdhbDU4Qk9SWFFpa2gwYUYxM1k4ci9P?=
 =?utf-8?B?NXM1c3R5S3JoNmFoUnpaUXEwckEyQkVnRlNjS1c2bU1uR1Qxdkd3SFg5YjM5?=
 =?utf-8?B?ajFqQWk5M1ZzNkN1U1lpSXgxaFNtTzRWS1cvQ05QL2swYWVHM0cveFNHYnJH?=
 =?utf-8?B?Mkp4VFc5RjJwWWhjVnpKOFRWNEVqaFFFckJYdlNtYnprWktnZ0dCa0tUeWpQ?=
 =?utf-8?B?REhCQm5JY2s2R2FSWTh0U3UyWnhmVW5wdTRnRWZaNkNMLzRRYTE2YUJXQlJl?=
 =?utf-8?B?NE5VZU5OOE9Td1V6dU9BbGtKejFtTjQ2bW0rNDV6Nm9pWnVMN3ZUeFRlekh5?=
 =?utf-8?B?Q1EwVWk0TDFqNkJDSHg2YnNPTHI0Y1hzWVMwVTNNQmJIbDluU0M4YTRPcE5v?=
 =?utf-8?B?RHo4c2xVN0YrMjNMZ3l5bWFoZENsNUg0SFB0T0cyZlNjTjNSeU9JQ0VKVXNV?=
 =?utf-8?B?cEc3L0c0VTdyMDhLT2Z5dmtMcWYvb0FIU2E5SzV4R2NyclhMRXhXa1dWWE1V?=
 =?utf-8?B?ZkpvdUc5R2l0REQvc1paOWh2RkFLYkhPdEU0em0rL2UrL3BuZ29QRW4xcS9N?=
 =?utf-8?B?N0pyak52UHpRdTRzNUZETHlIeE1MN0JscGJXdHV5TkFiS2lhejlVZmNDakli?=
 =?utf-8?B?MThjSmduM1FFMjBnR3BWeWlvS2pRQUpOUlpMY3Q4ZzRLR0pOS2h0K3pkMXVP?=
 =?utf-8?B?ZHB0TFVMWEJzTWMzTXd0bWYvZzV6QXl5UjB4VExqTkJycVpRZWhhR3VORTlW?=
 =?utf-8?B?NVJobmlpOEdxTnJvWjJPSi9ZSVUyek5FcDRybG0yWWpCZXhzejNnTHlaSXBq?=
 =?utf-8?B?UEFDOWRhcWFTMS9uNkdURzFsSTlDbmIyelpYQnBHOEl4L0hmWE5RNTJ0Ym9I?=
 =?utf-8?B?emRjam81L09VZHI0QXB6RExBS2lVZE12UHYwV3ZOOTkzSTk5SDBCYTBVaS9l?=
 =?utf-8?B?L1h1WFdlTDNCc0pHUktheHhGUExtSStWMkozSE9iRkcxVGxqWkJUWkY2SWFL?=
 =?utf-8?B?MGxIbTZlK1lWWW1TamVuMUNUTDNNOExDMWxQbTBsOEY1eDd2em1vSy9BaVA0?=
 =?utf-8?B?MUtwdVg0YU42RldHZnhOTGFKTkpIanN2YWJ0b0hRamlVV2JQamxzUUZ4TE1G?=
 =?utf-8?B?czRsbVFLVUdUSTJLamMyUDNiOHd6WXBTOVlNZTVmazVPSHBMRjhvSXF1eUww?=
 =?utf-8?B?MVRVSmxhcFh4ODExVlhBck5nenU0MnRFeFY5d0F3UUhqbCt5NUJ3RUtNbUVs?=
 =?utf-8?B?VzZtdkI3WGhCWEQ3bEdmcDA0N0poUEpMZkpPVEY4aldsOUtEeUxITkpROFNU?=
 =?utf-8?B?MUZQZ2xWQlBHWWVEL0FRc2ZoNEM0UW5xVEJsVGg2VktuYU5NUGhOeXl3Mktp?=
 =?utf-8?B?TUdJVlIxNWZ3ZnFvMW4xOU9uK2ZiMDVYL2J0akNnSmt0dHJZWlpWVnB0QTV4?=
 =?utf-8?B?b21BZE9IWEJUL0dXQmtNUEc2YUdEUW04RXF4RjVHUzdpb2ZMOXRqWHA0L0pJ?=
 =?utf-8?B?Zyt5dGZFT0xUZmhGZ245ZHZ5SFNBWDB6UG54em1zb2FhenlJMFg2VHpieldH?=
 =?utf-8?B?dEJiY054Wkw5VENiZkZlczBWQjZpYUFiay8rOUxnYk9WSkZsdExnQ0tkaGg2?=
 =?utf-8?B?MG1jUUluNWtnWGhaQ1lObFNtZjdWcVFBK1NYNnVaY1JNTExBeGcwM1k4T2lo?=
 =?utf-8?B?eGxoN3dVRTgzTU1MRUxoZC9LQy9PdU1rOTNsT1EvZTRxcXhtTzU5allISFht?=
 =?utf-8?B?Qyt0cFZnQWR2Z0FXMUMvOHEzUTNqbkUyUnlISW05MW9PaVVrc2NDbHVzaThl?=
 =?utf-8?B?elJ1OW1BZVRkVkVIdE40d1doWkppbVhtMlBJVHp1aU5vdVIvenNBaFBoYzhX?=
 =?utf-8?B?aEE5ZGJuQ2dRWENodjFtSlpibHlpbkI0cFFtRWlyQWtNbEJaWlNOaENIczRC?=
 =?utf-8?B?bGlqTG9nUmU5WWpUaElZRWNSUWZMSFM2VG8zVC9penhWWWlZeUZ0ZGdKb2o2?=
 =?utf-8?B?NTRhU2ZEVSttRzFKM3ZOSnBpL3B2c3RkQzZXL3BVYnY2b2tvU0tGbnFkTW9W?=
 =?utf-8?B?dU1qWS9VRjRPL1JlV1hBZ1BseFJRclE0QmVsQ201RDZtRG13SUtEa3MxZUJX?=
 =?utf-8?B?NTFHWlBTYjFoK01GbDY4RldCZGR2Y2tXZFpvd1lWK3ZqaThtUnhhSm5haVox?=
 =?utf-8?B?N0hZdGt5bkRsb2hJT25PRHAzQTg5UEJiSHFRa1pzTldHTFlScEMzVnQ4c3V2?=
 =?utf-8?Q?kumzGkAjmmiYQVKc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 097ebbb3-100d-493f-df6a-08de61d355dd
X-MS-Exchange-CrossTenant-AuthSource: DM3PR12MB9416.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2026 20:49:04.1692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gS0qag0KVj2iWjPTJRUWxDqGuS+mdOR27pPDsTKJQeGPgN1OYXajkTaoExjeIH/y4Nu93qYc9J/HMdwOaTEXsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFA42F4F89B
X-Rspamd-Queue-Id: 97C3480006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1bebcoukr3x5mwp51qtyguei15np6wke
X-HE-Tag: 1769978949-257010
X-HE-Meta: U2FsdGVkX19UYt3B01Z8eH2D0r2lx8OEFasxhhIHSpidHVyLy6zD9Gco+iLzibObconjQfwpwQh+YF4LiRCN0PCwYQArUyeEOApTWyWv/ddcABKoOh1xgU/sejIAL3N48PDQ0gAuOu9kbD3wsXC9YjqCRj26lvpLkxndSDwSEGi3aR5XNlUcOuatgSmjQskHuY6MtoTpVcRmKy0+EaRWwebWPXnasP4ZDWSp+t80igkliMGDXifFQtQLOvJ13hXIBEhgFf1n+zk/or0eAn7l1wL1ZxN1WcNO7B2Xxbrbi8Cx0+VjD23UxFpsjE/1q16EZ5ufSvVG98n4d6eqcXzWUrlAeWHBYSdQqh0X2gt/zcL62z9b+57/kSncDxvUQJWup/yUfYU/ipWRasLR9PFU1ap/JoqAgcEYRsOCjpUSffqwTemiiyFjbpelNLkghxoA6YukxnxPcscKgN3sB0JDJ6NEBnqF1D+hf0TId1R49BYOTe4EK1/IghBRvs0Nnm3iaqHWlbFfgEkQJslikzQzIyTiZYEf3IxZS3LGd+Tzx0hAEZySypaOJuO/iYKS2Y4kuL3k0WOoaR5kvodTrBVVE6QG30IHmEii8pSGm+IDklVTXViJ1hluOmUZKGYPv8V0/J2C6E3uV8MfiggcrSkb+DShjoXKJxmjxQg13c9nBqVcCH1IHg+De+FiqfYXjgqzFFtggopu82WplzGRaQVxhmKs5dgbJ6/zFqT+99mThC1Mi4dW3r78IIXZYirINaBFErQoHGttGEEpXIFfIYruu6BKysptJANimG5szBxjrW9dh3QKdKiBuG0AP9sFJCwbmnaiuuaVHATv8L0XPHO17yKFeYBu7DAZy1lpx42ENdPu9JogaXAHakbWyOpMkTKdM063nIge2L6tQgKwC7SOsWnXs3z9wWAhwLUmQ+EbhGdU92DhQdkpmrRyTAkBFBWht1ce4l1vtJTBe6WC2yY
 iSJCxUmx
 h80U9tx+leOuEAHfHXDEkRUHdWOCeDQtavfYf2rLPC6nhV15Hq3wy6aeYmAWmpgvdWMmNGAZ13OMZvu/yaca4ndvKkQ6+/yUOLmo6BBkO0Q3yad+Yby2wToHREHgv4m6EKzUbzmpsH3mNBTgG6yi36V9icrk7qCN5daSPOB5ElJOvi5zgww6YtpkLEJHh2pv6z2Z0yj/hGoknmpIMXKmgh8vI/4iRr75Hm0KFjHilQlhlTl/AX6YT866jSK4iNynaxhWljYZ5vgx5m7/WQaXw6AM3cXWExJgzs39mry/11nM8j4ehWPhojQGAQXsMkPQg5aEIlVS+vAXkdPlItIibPKZfPiiKSQqYpde+Bf0A9hsELYQLp5cef62knfppEcurJZkMNGi/sWObuaKiYGd70K8OcaABKBxEoDTEhIv3IRyL+UM37kaPzU96cjqphJWDhs++
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/1/26 11:24 AM, Matthew Brost wrote:
> On Sat, Jan 31, 2026 at 01:42:20PM -0800, John Hubbard wrote:
>> On 1/31/26 11:00 AM, Matthew Brost wrote:
>>> On Sat, Jan 31, 2026 at 01:57:21PM +0100, Thomas Hellström wrote:
>>>> On Fri, 2026-01-30 at 19:01 -0800, John Hubbard wrote:
>>>>> On 1/30/26 10:00 AM, Andrew Morton wrote:
>>>>>> On Fri, 30 Jan 2026 15:45:29 +0100 Thomas Hellström wrote:
>>>>> ...
>>> I’m not convinced the folio refcount has any bearing if we can take a
>>> sleeping lock in do_swap_page, but perhaps I’m missing something.
>>
>> So far, I am not able to find a problem with your proposal. So,
>> something like this I believe could actually work:
> 
> I did something slightly more defensive with a refcount protection, but
> this seems to work + fix the raised by Thomas and shows no noticeable
> performance difference. If we go this route, do_huge_pmd_device_private
> would need to be updated with the same pattern as well - I don't have
> large device pages enabled in current test branch but would have to test
> that part out too.
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a4..1e7ccc4a1a6c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4652,6 +4652,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                          vmf->page = softleaf_to_page(entry);
>                          ret = remove_device_exclusive_entry(vmf);
>                  } else if (softleaf_is_device_private(entry)) {
> +                       struct dev_pagemap *pgmap;
> +
>                          if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
>                                  /*
>                                   * migrate_to_ram is not yet ready to operate
> @@ -4670,21 +4672,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                                                          vmf->orig_pte)))
>                                  goto unlock;
> 
> -                       /*
> -                        * Get a page reference while we know the page can't be
> -                        * freed.
> -                        */
> -                       if (trylock_page(vmf->page)) {
> -                               struct dev_pagemap *pgmap;
> -
> -                               get_page(vmf->page);
> -                               pte_unmap_unlock(vmf->pte, vmf->ptl);
> +                       pte_unmap_unlock(vmf->pte, vmf->ptl);
> +                       lock_page(vmf->page);
> +                       if (get_page_unless_zero(vmf->page)) {

I think this ordering has a problem, because it releases the PTL before
getting a refcount. That allows another thread to free the page, and
then the lock_page() call here will be doing a use-after-free.

That's why I reversed the order of those, and then as a result the
get_page_unless_zero() also becomes unnecessary.

>                                  pgmap = page_pgmap(vmf->page);
>                                  ret = pgmap->ops->migrate_to_ram(vmf);
>                                  unlock_page(vmf->page);
>                                  put_page(vmf->page);
>                          } else {
> -                               pte_unmap_unlock(vmf->pte, vmf->ptl);
> +                               unlock_page(vmf->page);
>                          }
>                  } else if (softleaf_is_hwpoison(entry)) {
>                          ret = VM_FAULT_HWPOISON;
> 
>> diff --git a/mm/memory.c b/mm/memory.c
>> index da360a6eb8a4..af73430e7888 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4652,6 +4652,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>   			vmf->page = softleaf_to_page(entry);
>>   			ret = remove_device_exclusive_entry(vmf);
>>   		} else if (softleaf_is_device_private(entry)) {
>> +			struct dev_pagemap *pgmap;
>> +
>>   			if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
>>   				/*
>>   				 * migrate_to_ram is not yet ready to operate
>> @@ -4674,18 +4676,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>   			 * Get a page reference while we know the page can't be
>>   			 * freed.
>>   			 */
>> -			if (trylock_page(vmf->page)) {
>> -				struct dev_pagemap *pgmap;
>> -
>> -				get_page(vmf->page);
>> -				pte_unmap_unlock(vmf->pte, vmf->ptl);
>> -				pgmap = page_pgmap(vmf->page);
>> -				ret = pgmap->ops->migrate_to_ram(vmf);
>> -				unlock_page(vmf->page);
>> -				put_page(vmf->page);
>> -			} else {
>> -				pte_unmap_unlock(vmf->pte, vmf->ptl);
>> -			}
>> +			get_page(vmf->page);
>> +			pte_unmap_unlock(vmf->pte, vmf->ptl);
>> +			lock_page(vmf->page);
>> +			pgmap = page_pgmap(vmf->page);
>> +			ret = pgmap->ops->migrate_to_ram(vmf);
>> +			unlock_page(vmf->page);
>> +			put_page(vmf->page);
>>   		} else if (softleaf_is_hwpoison(entry)) {
>>   			ret = VM_FAULT_HWPOISON;
>>   		} else if (softleaf_is_marker(entry)) {
>>
>>>
>>>> But it looks like an AR for us to try to check how bad
>>>> lru_cache_disable() really is. And perhaps compare with an
>>>> unconditional lru_add_drain_all() at migration start.
>>>>
>>>> Does anybody know who would be able to tell whether a page refcount
>>>> still should block migration (like today) or whether that could
>>>> actually be relaxed to a page pincount?
>>
>> Yes, it really should block migration, see my response above: both
>> pincount and refcount literally mean "do not move this page".
>>
>> As an aside because it might help at some point, I'm just now testing a
>> tiny patchset that uses:
>>
>>      wait_var_event_killable(&folio->_refcount,
>>                              folio_ref_count(folio) <= expected)
>>
>> during migration, paired with:
>>
>>       wake_up_var(&folio->_refcount) in put_page().
>>
>> This waits for the expected refcount, instead of doing a blind, tight
>> retry loop during migration attempts. This lets migration succeed even
>> when waiting a long time for another caller to release a refcount.
>>
>> It works well, but of course, it also has a potentially serious
>> performance cost (which I need to quantify), because it adds cycles to
>> the put_page() hot path. Which is why I haven't posted it yet, even as
>> an RFC. It's still in the "is this even reasonable" stage, just food
>> for thought here.
>>
> 
> If you post an RFC we (Intel) can give it try as we have tests that
> really stress migration in odd ways and have fairly good metrics to
> catch perf issues too.
> 

That would be wonderful, thanks! Testing is hard.

thanks,
-- 
John Hubbard



Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F40E81BDC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2D06B008C; Mon,  9 Feb 2026 10:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAE36B0092; Mon,  9 Feb 2026 10:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D8D6B0093; Mon,  9 Feb 2026 10:47:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E49C86B008C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:47:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFA53B6258
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:47:07 +0000 (UTC)
X-FDA: 84425346894.04.2734B59
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012045.outbound.protection.outlook.com [52.101.53.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F71980003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:47:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yAoiW20Z;
	spf=pass (imf02.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.53.45 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770652024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wlku9x2UlLTD5XLthUkVdtcIPmFGAE7y4IdhaKs0d30=;
	b=WycUNsSCm4/Xdi/fxMNW0V8pMBJyDIHRXnzlI0YaamlqHfVhDKx5s0Xvj86p78FzJKecgT
	Nx/ue/NSY5ISgKI2RiWsTLJ76xj0KbIJ/Tx9/GixtOw4Y5oIElsfvwN4Yc8ptDQjDvnng/
	b2YXUZEzilWN4fswBGtI5nYLOSyxJaM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=yAoiW20Z;
	spf=pass (imf02.hostedemail.com: domain of Honglei1.Huang@amd.com designates 52.101.53.45 as permitted sender) smtp.mailfrom=Honglei1.Huang@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770652024; a=rsa-sha256;
	cv=pass;
	b=XWfwpeYcf4zxfFQFEhnTqRdjANfsCMNmQtLMZaqWfZNfbwUUvc74AlhIhVryOXDQ0JaSOi
	U4q0uhjcuLZemUIjTaLlQ9jgPrUYj6wULIQhZctqK5GWyQLR+c689Xn18vkpYQv7FFXHz8
	T12tkcfbQZRkri/QBP990FG8mFDYFl8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G6WQRSCwk8NhHNPb9+NbgkY6WcVbH+dTmNGUt/af6h3ZUkwvyR7v+cWqvFiIkeyJN3PGLHpIa14A8z/fXWiNZLIYU8uP9cFR6qtX4aFFrhG1fr4gbuUYbOF9c45g/L/Wlz9Jc5kV6DxN+fWu0kpa9X/8Eh74IRF7U5qD5/7SYngLOBiXI5PfuUVGCtmFX6t1QBi6Myv9vulUNUNRFib4G6q/7EfD5M2w2UFkVOCPUsG63uJLiHMQmQJo4vd9TuedtQut4gbkDEfWYO+p260O8VOyAkGhgM0wpQhDE6XRguA558B5lORhKObBkP4c5lxzjuKzmj0Ft/zOLujJH6MGVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlku9x2UlLTD5XLthUkVdtcIPmFGAE7y4IdhaKs0d30=;
 b=FF7QSEfgXzcEA7s1O341027mpCQBL/rhem6hZzRsgwk9Ky7SdfBANpJD8eK/EzJsqRyB+bWzYIMYPcW6GFyoXmKtxwdq7ERjDeQxg/+oiSxjmJ6Bovc/q13rM3Gj5GcqpKyEIFCmAlkzc9Im8GsnoI658g9rnYmArv+ajFGKBNC0Megm8Nh64w0Wb6OvaH5phCkz4C1V1c+D3EwFsB3OIpbqCeGhE2WhaUpMRIhyaNExs/DoabGH2LieiP7hE2Ne7xUVhoUPfvj8I3tgrozW3wGIV9+oHNwyqVeRdAosULc8IK1TPHQktvQnhm/HS7EKXL+mtqV9uRGk2xdVONI2iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlku9x2UlLTD5XLthUkVdtcIPmFGAE7y4IdhaKs0d30=;
 b=yAoiW20ZUXn9GiVbd1jR+IbIHz7P5btk1Nv3W+qPcac6j6VSfoyAJx4bguAKbI7878SG9B0LFp9kN0zyteaOiECfAk6sa8pNS6lkLhFSvmRWHadhmgnE9Tqjxzzn0PaTL9HHqRkZ4oybgkqU31peVJD1exX6KIc9St334wui8CQ=
Received: from IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10)
 by DM6PR12MB4417.namprd12.prod.outlook.com (2603:10b6:5:2a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Mon, 9 Feb
 2026 15:46:58 +0000
Received: from IA1PR12MB6435.namprd12.prod.outlook.com
 ([fe80::8b77:7cdb:b17a:a8e2]) by IA1PR12MB6435.namprd12.prod.outlook.com
 ([fe80::8b77:7cdb:b17a:a8e2%5]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 15:46:56 +0000
Message-ID: <cffdd191-2fdd-4b5d-abf2-4cf77b96b681@amd.com>
Date: Mon, 9 Feb 2026 23:46:46 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] drm/amdkfd: Add batch userptr allocation support
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Felix.Kuehling@amd.com, Philip.Yang@amd.com, Ray.Huang@amd.com,
 alexander.deucher@amd.com, dmitry.osipenko@collabora.com,
 Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org
References: <20260206062557.3718801-1-honglei1.huang@amd.com>
 <da75eadd-865e-41fe-a86b-ed9d9aa45e5a@amd.com>
 <8ba8e4f2-89f2-4968-a291-e36e6fc8ab9b@amd.com>
 <f296a928-1ef6-4201-9326-eab43da79a84@amd.com>
 <38264429-a256-4c2f-bcfd-8a021d9603b2@amd.com>
 <451400e6-bbe0-4186-bae6-1bf64181c378@amd.com>
 <0eaf1785-0f84-45e5-b960-c995c1b1cf1e@amd.com>
 <a31082ab-e0f9-45ea-9a8d-cfdef39fc507@amd.com>
 <648e06d1-b854-466f-bf13-0c36ee2c36a1@amd.com>
 <9c7ab1b2-1a78-43d7-b4a7-5bc561158380@amd.com>
 <410040f0-d7eb-4a35-9e4b-54a3517a5cfe@amd.com>
 <bb62077f-38a5-4d1f-9a8d-f63e35ae1f10@amd.com>
Content-Language: en-US
From: Honglei Huang <honghuan@amd.com>
In-Reply-To: <bb62077f-38a5-4d1f-9a8d-f63e35ae1f10@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0223.apcprd06.prod.outlook.com
 (2603:1096:4:68::31) To IA1PR12MB6435.namprd12.prod.outlook.com
 (2603:10b6:208:3ad::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6435:EE_|DM6PR12MB4417:EE_
X-MS-Office365-Filtering-Correlation-Id: cd8f6da9-e3e3-4b3c-1e41-08de67f27362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|14052099004;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SlVvUjM0TEpVek9UcnR0aTh1UEJ4d3Njd3o3ZlU2MSt4ZGJCSUxFNmxINWRJ?=
 =?utf-8?B?VExYaVN4bnNBRVYyNnhpQ25EVWc4OFZ5YVJGTmxxOVlpN1RYc3lNR212UC9q?=
 =?utf-8?B?eDhxSVpKQVhZYlJ6UFg5TER1d3krZUlEVmFBbElTQlFPZ2FMaWJNM0VvQmR4?=
 =?utf-8?B?eXJFOS8vVjAzNld0NXNVVDNycmdjM25qM1BEbHlHeDd6WjZVY1pvelFVTWgz?=
 =?utf-8?B?L0N4ZXY4M0JxRE9CYWtGS3VUYWFOMjNxLzZFQlRDcEphZlpkZE16M1FLMjUr?=
 =?utf-8?B?ODlSSEhYN3ZqM0tGSXBhSDdiREpyT01HbTVUazJXaEhpM2tDYVlZSzdaSjY4?=
 =?utf-8?B?VDljc0tFV2NpK3hYTlhETkZEVXVFY0c0V2o1RWd1SFRGMVg4SHR2V2hKeU9P?=
 =?utf-8?B?bkFRT1FPWHh5MWNJK1NuMVpReGo4TGdJanZMZ3N1OGE5aTdhanBJSElGTHVD?=
 =?utf-8?B?WVZCS0RqcVdxUDNkNlpLQTJ0d0M1bm1mMTFEYlNRaEZhTEVobjA4alhBdWt1?=
 =?utf-8?B?amo1L2xmY2d2MEtjdFcwOTE3NUwrb0ZrcUlDRE1uZktycHVkaTR0eTZjZ2pP?=
 =?utf-8?B?d05Sclk0NHo0cDN0eWt1SDNNb2J3QklvNUp1VmVPZVFFU2xZem52eUhZWHdw?=
 =?utf-8?B?Z2k2L0ZqSHpISFlHdTh3R3Y3NEFscDVXRmgxSjFOcXpLLzlDRUlqeGhXdFJk?=
 =?utf-8?B?dDR0MXE3cmZOdXZkcHovcUUyQXo5aUFUUXB2b0RTU0RoMGwzK3JXenJnQmpq?=
 =?utf-8?B?VEZEK3A2blVrZ3lhWTdSaFh4bU1qaXlNa2JXK1Bid29FQ3lDbThCU0lDRUxD?=
 =?utf-8?B?eE52VWNCbTl4bTl4cWY1dm9NY2lVTC9HS01hRzZMLzY1Q0NPOFhpeEFyamc1?=
 =?utf-8?B?cTJsT1BPZ3VteGdlZ3RsRi9vL1gxWCtRVkdxaHZIbUVKYWJwZlhOamRHWitS?=
 =?utf-8?B?cGw5MUpvdjk1QmRJS2VrTlhDTlNoT2FZWXRNVEM3K0NpSmxRNEI3Z3pHL3Vh?=
 =?utf-8?B?VVQ2Ym9ubVVWd0NpZVZDUWdJcmExWUZmWWZHUjg2OFdwcnNoMDBxSnFXRXNz?=
 =?utf-8?B?Nlg5YWNkbkVoRlhvZWZVUmVzM3MwMHk3ZXpvcEJxYyt5ZStObGorQ0RJeVdQ?=
 =?utf-8?B?by9KK091cmo2anRIMzNoMktzb3JLSHVGWFN6SCtvRjJJalhMSFFRVjd5aFhH?=
 =?utf-8?B?WGtObG9rVWtseE1yd2Jpd0E4NjZ5Y21XMkI3SG55b0U3Yk5wUjNIZWlMWHBT?=
 =?utf-8?B?MkkxZXdoc2VmVVM2NjNnQ2dlKzJUQTV3dTk2WFh6Q0QzT05vcFBWYXpnTXA2?=
 =?utf-8?B?SDhBamE4RDMva01EWDh2UHBlaFVrSU9WWnJBclFJNHJpNDBRT0RQWmdVN3NP?=
 =?utf-8?B?M1lUUXdjWnIxNERYTlZMQml5TVdtalVqSGUwWW01eU0zWUxkMUdhRVg5T1Jy?=
 =?utf-8?B?Y0lod0lVaU9UWTVTSS9wUVNvSW5vYTlMeEUycDlVckRQY1g1NU9iV1pWUVZx?=
 =?utf-8?B?Wkd3R29na3pMeFRIamx6RlhScmxVZlllQmNKTFVRcG9QUURTd0hYemNLZjZh?=
 =?utf-8?B?bDlCcG16QzlxSkViaC9iNWl0MGFhcVlIdW5MdjkvM0xSeW0xK1RnNElEZ3dt?=
 =?utf-8?B?SkgyK2VVZWpwUTZmL3Z5UUtVVEQ0SjFqZGV2bmNMNVlxbFpEaDgwRklGL3BH?=
 =?utf-8?B?ZVVxUEt3enAzbXJyZysxbU92dFJ5Qm5jNlRlcHVhcERVbkVjb3Ztc2hoZzVU?=
 =?utf-8?B?ell4eCtKYktVVVFWT1I0Q2ROVU1rZXNjcENJc0xmMVZlTHIrS2RLa3lFM1Vp?=
 =?utf-8?B?MlNCenpNT3J3TklVU0dEQ2E1OHYzRUQrQjdqeWIxdmp0N3VIRU1jYmVTMlRH?=
 =?utf-8?B?bTlpMWlHakRxRWhFRkp1Rk04ZTZuaGdsbUEycHQzQW5ON1FWM2JiWHltaUtG?=
 =?utf-8?B?Z0h2bm5vQjZkYkNWc0szUE5xQWpGK1BzYlpRUEM4QVlUSy9GNllOcjVML3h5?=
 =?utf-8?B?Q0FVQWNLaDhoOTBadEdDRkxMOVRrcFV6OTlEZitwZlc5ZkI1SEdyS3gvMFo0?=
 =?utf-8?B?MjZnNGp2R1k0dXRDRHloYlN1SlJkUkdEVTNQaTUvREdIQklrYUlVZS9lb0Fx?=
 =?utf-8?Q?UeDs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6435.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(14052099004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0xIMmorVmkzTW1CWHl2ZXBmakROaUIva1Frcis2SjR6a0Ruc055Y0FkZENp?=
 =?utf-8?B?K0hiektzY3lMVlFPZHl3RGMrWUVkUlVoTXI2eWFXZTdKSmZMVEhxSDZOOEdX?=
 =?utf-8?B?cm9NS0krOEJmUzYzZUJIdVA5SHFWS0IxL1NOQk5kaXY5TWpaMTl1bDRMeWZP?=
 =?utf-8?B?NkU5eXdsZGgrTWp5MlZham1jaXhCWlVGUFRUTWdwSTlCbzFWSitIcG5lVVpp?=
 =?utf-8?B?NkxXblRuZjkrWVB4ZDZHUXc5aGRHMjFZQVJkR1AyN2U0b3ZQeW9OY2ZFb0g0?=
 =?utf-8?B?MnhrR0lXdDVXc2IzYm5RQzdXQnFGMlczT1hHaFNDblFUbWl3YW1WQTBMcHE0?=
 =?utf-8?B?YzhpcG04Y2hIKzFyZHpkdnp0RkRNZnFiYUUyV1F0clg3M3NBQ1drQ1dOTkhz?=
 =?utf-8?B?V2dLdXIwMUcwNWRBMmkxdVhrWFp1anFIQlh0SjdPTHV5bGlNRFBKNlh2clVn?=
 =?utf-8?B?V1pBc2pSMEJ5bG9xSHI3QjQrTUtTVUE3TU1Bb2ZUWk55RXczNVpFNFFNQzJk?=
 =?utf-8?B?OWZGRnZaRDlHU3ZNbnoxQnNuRjlkL0JGbkVZeTRiUVN3ejdtZncvT1Z5L2hW?=
 =?utf-8?B?aFZ0aXZXNnNkVG4zT1BBck1qSEJOeVpGUVNjYlh0Q0hVMWY1K3c4MC9DaEF1?=
 =?utf-8?B?aElCMmVQMnl6R1h2d2hNTEpVdnZZNGlwdE0yMkU4T1Q4OFpxS2tYZ2hibWo5?=
 =?utf-8?B?WlFSRVBVUzZscGFSLzdUU01nRkZsR1ArV2dWT0ltRWhtQ0hlYmU0R20xYmY0?=
 =?utf-8?B?aFc4RWYvNmx5SDBkQkFsOHhpekc3VFdMWi9NeEI2dlo5RGw5a2dMNE1iM2Zi?=
 =?utf-8?B?MXpXY0pjaHBNK2NublZRUGFwODFJays2UFRCSDBRek05OFVoY1YwTjJnNUJi?=
 =?utf-8?B?MHJhazlpcjEyQ0wvWDBpOHR5NG80d09UK3c3SnFCRGQzSWU4azdBYWpUency?=
 =?utf-8?B?SXlKSmhTb1dsSWwwKy9wbzZuMlBsd2s2ZVpYNDZ6d2ZPNnpESnhESVExMStC?=
 =?utf-8?B?SlNtcnA5R1RRcjgybUkzRHdvTEdVNDQ0RTJ2ZjlxcnNwNG1Ya2loRE1JWDVT?=
 =?utf-8?B?MWFmZTYrTDlheDVUUkxxNHlnNTB6aXV3TG44eUVDQVlUWk1UL2JwcURnTHc5?=
 =?utf-8?B?Q0g4WXkxU1IxdFUvT3RRK3hiVDBhSXV3UTFBWWNENnBrVUZ0NzRGNS9kRFJV?=
 =?utf-8?B?NWh2YUxrdU44UHBTVGlDajFDUDBTOXhlMFJXbmQ5L0tHb1lGcUY0ekVHVFBq?=
 =?utf-8?B?Vnc0cjltaUdsVVdEQ1gycnh4emRFd2tPeXdzRGFaTGlCL3NOUlV5TUMxM2Rs?=
 =?utf-8?B?blJiVzFtdUJ2NDlKWHU2Y2lGNTk2cUdjNWJQMnNNbnFBYWhtWlltUXpqVFdq?=
 =?utf-8?B?aGR3WXNlNkFiOGJyMUliSXRXaEFudEJlcUdRY2pGSVBTUS8zWkJ2OHB0VWJt?=
 =?utf-8?B?Rnd6UTZDZGhsUWJXa2daVG5aZzM0QlJkVTlLV1NoZXhUOHhxZlp0MjVEUlNp?=
 =?utf-8?B?WXpob3FtQjNqT09KR1h4L0lWbzZUQ283WHVVOHk4NXorekYzV1dTcDNIMEZr?=
 =?utf-8?B?Z05wUWhOdXE3TERuTkt5ZDI3OXRjeDc0Z1BHaVhMWFdYZFU4OWRHMGxlTjRr?=
 =?utf-8?B?R1lnd3JjK2Vod1o3Y2RqTDRkL2p6SmJkUitUc3hVL1lCQmRvbnloQ0ZOY1ZO?=
 =?utf-8?B?N1Q0ajArQXhjUHFSUWVDcDZOaGI5Ui82dFBaTitzd3NUZWV5dVRkQjBwSWlh?=
 =?utf-8?B?NFBGbmgzUjFZV21QcjZVSDRaaHB3TzF6UENHays1bVB5RjEwb3hrcXpJWjZs?=
 =?utf-8?B?TmFKOVBNWnQ1bkdOTEZEVUJ0M3dLcVdEeFlmU05CTC9DaGxQYjRESDJIYXpB?=
 =?utf-8?B?RjFLRDErN2dyajE3bkR4MmJweFZpeXJzYUJzRXIwdDIzNC8vSjJJaFQrbWJH?=
 =?utf-8?B?M0RLaTRWandQbVlHZ0hFKzI1UFBMSWllNjFxY0JseFhBTXErNGNqb1V2bldt?=
 =?utf-8?B?ckoxcHlJWmZjWmRpV00wVGhTV0Q4SjMxZU16VE50R3NNQUxzOHBqVkNoc0Vk?=
 =?utf-8?B?TlJhK1BiakdDVHZrQmJEdmt6NHpXc055ZnFkSGVDeTZibWpGQ3VvcmFJQjdI?=
 =?utf-8?B?RFp0M01HNTBZWjV2NHpudU44V1pldERQMlN3c1lrRFBrazZ5bEVuUkpJeEN5?=
 =?utf-8?B?ejZVRmZpcExjeFg5UjVwNlJEZ0U1WXp6WEM1NnhwSG52bDNYN1FqWXc3TDFD?=
 =?utf-8?B?eVIxVUx4OVVmT0thR2VaUGg1NGZFaVpJcytVQmpvU3VUSlpRbFpIZVgvQUJB?=
 =?utf-8?B?QzFNbFdPYXprR3JsSG1YcUpuR1lha1hZRnh2cnNhZmJaaFNJM1c3QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd8f6da9-e3e3-4b3c-1e41-08de67f27362
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6435.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 15:46:56.1134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z3XQ3UKjAas6AqF0W88OIxO4nqs3caTSdv2KKlQ0CL76jCALnA0lkTsdOBWb6NC92SKbN/++N+1xxYBXL3NrKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4417
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F71980003
X-Stat-Signature: hpdez6b1z4m8ztn3ixtxum7sotxtizc5
X-Rspam-User: 
X-HE-Tag: 1770652024-611693
X-HE-Meta: U2FsdGVkX19nDy6AdCmic1CzkIuudbmEEUdhsb1RBdPRInppwVd2VBkO55Cf6W4sMoRERXyC+3OVWSu9iioWIuUrQIU6zRGCU8XcSADi/hd3rJwSc3RU3dNujIKlMEkuIp421Nv5JWJva4zHCwl4SXrsMXaOpMRv06A5qCMro4TXQZEMDOmaEBaaVHkHJloKa+F65+XdEUkh/yD6VKRLkYrvs7vVSBIrmo9+yJ7WAb5a1KvJNa1kUE2/HrHxDlp/L7f5077lyCfOPDfn/G6CDMbldtZimYJe3pQxjOEzMO3TAi+antHyUxOo9NtgSYdIsCJXplXRGj3bxBd8OkC27uOnrkYhPX6lrlQAu/jxde+cD0lLqqUOLkfUQOBwIikt0rAwjp16uqFzS7Z0ahQ2RBQW3hbd5YfE4AT20lJ7dWAJlbHsxzPLNgHB82wVwoJKt0CuBFeEqZ3izD0F2uCxQ8r0+a1UtDm1+bMajZHxeEx71ncxyk8LnsEGE/XPOpqae4vy4tHxJMKaReGnc6u2qZX4+Xf6A2vCKnWyI194MQAvEpmnKANZIpuGk6fA5MiKk+h8mINecIYZKVsULi8ppGTJYneB7rgCM0bIFKXQ3fbtTH5bEfTLndJCXJ0mX8njh7SykyRQ9dtie4UkXYU6IcAMgGoj2RBM+AjKSNQQ0Q6BWTzGlYxITBpwoCPvjZKbRnCwBWxZ292pIK9UpUmC2/gMaR6m0TNpSTyfkuxZRKFqWdzKGkaOPsAxzlkgrkKnzkabUNW7csb3YoNCe/Q2RbhKmiclE2BgRjI83x+GCJJASb7EjbOvPl6YMEHUZxXHQ9C9RX0wCwtakmOkR3cUamGgN9pQT9c5p955GpSCbVJ2I6cdvcd/zhT6KCHX8pflOMhxcd+gfMztla0utcSTtyFoBADh+UHnmOQypgewu7nNDiV6I07aEg5AuH8qv0qDnudh2VmSlDh32c2mQWt
 0jRH79j1
 lqJO9OsqYs+LdMBFI+d3TQqqSDTZMFjgY3HtlMXG9lLb7RnowkYKU6x09jUdyuDRk/3+Mj3maBXyoz+WUp5ydFxglAqZsoXGJ7/y+CmQy7owisQUfxO8jYz4Vvuo3lbRcrHJkCEZBr+SyqJe7uh6suUl20CT0V0ojPuPne8S7JHxMyEWlXLIjdIt+fg5eUQ6EiNkgAJEocU7CaaCFvlCmHTaE1cnD4G/R99puun4HOHG3LmLeBlTZ5C4OPK6YaPVqOKvzWOWI0ghBf8yNtWB7adGcQ7VjpQQCiW27b0RLJ8jJYZLth34VqLN5Cv9e3DKOPlxeA+hJ3Mt25xbVl8tMackhf/M4svyMhIrfSx/mijcKN7Ici1bhieJ+6YzlO0nE87nsEgEmUk8vZsbdB7AlCWBRdkJucewpf7X5xCnMT42jeOvTuUkQHSx+iIZR0JVy7DIighmC0Qczw1vGgdVuqcH4nhVVVmkyWTMZtNLoNur8a+8r9fF2ZpIY9p8qSxmcwYUhEGjrOgbYuY+M360aiPQyo0iKuDfqMjI7GJThYHAjUAztdlNgt8j6hQsdg4i+zPCckZ5nEWT+iRjtQZh7l4C2ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Agreed with you that with many ranges, the probability of
cross-invalidation during sequential hmm_range_fault() calls
increases, and in a extreme scenario this could lead to excessive
retries. I had been focused on proving correctness and missed the
scalability.

I propose the further plan:

Will add a retry limit similar to what DRM GPU SVM does with
DRM_GPUSVM_MAX_RETRIES. This bounds the worst case.
This maybe ok to make the current batch userptr usable.

And I agree that teaching walk_page_range() to handle
non-contiguous VA sets in a single walk would be the proper
long-term solution. That work would benefit not only KFD batch
userptr. Will keep digging out the better solution.

Regards,
Honglei

On 2026/2/9 23:07, Christian König wrote:
> On 2/9/26 15:44, Honglei Huang wrote:
>> you said that DRM GPU SVM has the same pattern, but argued
>> that it is not designed for "batch userptr". However, this distinction
>> has no technical significance. The core problem is "multiple ranges
>> under one wide notifier doing per-range hmm_range_fault". Whether
>> these ranges are dynamically created by GPU page faults or
>> batch-specified via ioctl, the concurrency safety mechanism is
>> same.
>>
>> You said "each hmm_range_fault() can invalidate the other ranges
>> while faulting them in". Yes, this can happen but this is precisely
>> the scenario that mem->invalid catches:
>>
>>    1. hmm_range_fault(A) succeeds
>>    2. hmm_range_fault(B) triggers reclaim → A's pages swapped out
>>       → MMU notifier callback:
>>         mutex_lock(notifier_lock)
>>           range_A->valid = false
>>           mem->invalid++
>>         mutex_unlock(notifier_lock)
>>    3. hmm_range_fault(B) completes
>>    4. Commit phase:
>>         mutex_lock(notifier_lock)
>>           mem->invalid != saved_invalid
>>           → return -EAGAIN, retry entire batch
>>         mutex_unlock(notifier_lock)
>>
>>   invalid pages are never committed.
> 
> Once more that is not the problem. I completely agree that this is all correctly handled.
> 
> The problem is that the more hmm_ranges you get the more likely it is that getting another pfn invalidates a pfn you previously acquired.
> 
> So this can end up in an endless loop, and that's why the GPUSVM code also has a timeout on the retry.
> 
> 
> What you need to figure out is how to teach hmm_range_fault() and the underlying walk_page_range() how to skip entries which you are not interested in.
> 
> Just a trivial example, assuming you have the following VAs you want your userptr to be filled in with: 3, 1, 5, 8, 7, 2
> 
> To handle this case you need to build a data structure which tells you what is the smalest, largest and where each VA in the middle comes in. So you need something like: 1->1, 2->5, 3->0, 5->2, 7->4, 8->3
> 
> Then you would call walk_page_range(mm, 1, 8, ops, data), the pud walk decides if it needs to go into pmd or eventually fault, the pmd walk decides if ptes needs to be filled in etc...
> 
> The final pte handler then fills in the pfns linearly for the addresses you need.
> 
> And yeah I perfectly know that this is horrible complicated, but as far as I can see everything else will just not scale.
> 
> Creating hundreds of separate userptrs only scales up to a few megabyte and then falls apart.
> 
> Regards,
> Christian.
> 
>>
>> Regards,
>> Honglei
>>
>>
>> On 2026/2/9 22:25, Christian König wrote:
>>> On 2/9/26 15:16, Honglei Huang wrote:
>>>> The case you described: one hmm_range_fault() invalidating another's
>>>> seq under the same notifier, is already handled in the implementation.
>>>>
>>>>    example: suppose ranges A, B, C share one notifier:
>>>>
>>>>     1. hmm_range_fault(A) succeeds, seq_A recorded
>>>>     2. External invalidation occurs, triggers callback:
>>>>        mutex_lock(notifier_lock)
>>>>          → mmu_interval_set_seq()
>>>>          → range_A->valid = false
>>>>          → mem->invalid++
>>>>        mutex_unlock(notifier_lock)
>>>>     3. hmm_range_fault(B) succeeds
>>>>     4. Commit phase:
>>>>        mutex_lock(notifier_lock)
>>>>          → check mem->invalid != saved_invalid
>>>>          → return -EAGAIN, retry the entire batch
>>>>        mutex_unlock(notifier_lock)
>>>>
>>>> All concurrent invalidations are caught by the mem->invalid counter.
>>>> Additionally, amdgpu_ttm_tt_get_user_pages_done() in confirm_valid_user_pages_locked
>>>> performs a per-range mmu_interval_read_retry() as a final safety check.
>>>>
>>>> DRM GPU SVM uses the same approach: drm_gpusvm_get_pages() also calls
>>>> hmm_range_fault() per-range independently there is no array version
>>>> of hmm_range_fault in DRM GPU SVM either. If you consider this approach
>>>> unworkable, then DRM GPU SVM would be unworkable too, yet it has been
>>>> accepted upstream.
>>>>
>>>> The number of batch ranges is controllable. And even if it
>>>> scales to thousands, DRM GPU SVM faces exactly the same situation:
>>>> it does not need an array version of hmm_range_fault either, which
>>>> shows this is a correctness question, not a performance one. For
>>>> correctness, I believe DRM GPU SVM already demonstrates the approach
>>>> is ok.
>>>
>>> Well yes, GPU SVM would have exactly the same problems. But that also doesn't have a create bulk userptr interface.
>>>
>>> The implementation is simply not made for this use case, and as far as I know no current upstream implementation is.
>>>
>>>> For performance, I have tested with thousands of ranges present:
>>>> performance reaches 80%~95% of the native driver, and all OpenCL
>>>> and ROCr test suites pass with no correctness issues.
>>>
>>> Testing can only falsify a system and not verify it.
>>>
>>>> Here is how DRM GPU SVM handles correctness with multiple ranges
>>>> under one wide notifier doing per-range hmm_range_fault:
>>>>
>>>>     Invalidation: drm_gpusvm_notifier_invalidate()
>>>>       - Acquires notifier_lock
>>>>       - Calls mmu_interval_set_seq()
>>>>       - Iterates affected ranges via driver callback (xe_svm_invalidate)
>>>>       - Clears has_dma_mapping = false for each affected range (under lock)
>>>>       - Releases notifier_lock
>>>>
>>>>     Fault: drm_gpusvm_get_pages()  (called per-range independently)
>>>>       - mmu_interval_read_begin() to get seq
>>>>       - hmm_range_fault() outside lock
>>>>       - Acquires notifier_lock
>>>>       - mmu_interval_read_retry() → if stale, release lock and retry
>>>>       - DMA map pages + set has_dma_mapping = true (under lock)
>>>>       - Releases notifier_lock
>>>>
>>>>     Validation: drm_gpusvm_pages_valid()
>>>>       - Checks has_dma_mapping flag (under lock), NOT seq
>>>>
>>>> If invalidation occurs between two per-range faults, the flag is
>>>> cleared under lock, and either mmu_interval_read_retry catches it
>>>> in the current fault, or drm_gpusvm_pages_valid() catches it at
>>>> validation time. No stale pages are ever committed.
>>>>
>>>> KFD batch userptr uses the same three-step pattern:
>>>>
>>>>     Invalidation: amdgpu_amdkfd_evict_userptr_batch()
>>>>       - Acquires notifier_lock
>>>>       - Calls mmu_interval_set_seq()
>>>>       - Iterates affected ranges via interval_tree
>>>>       - Sets range->valid = false for each affected range (under lock)
>>>>       - Increments mem->invalid (under lock)
>>>>       - Releases notifier_lock
>>>>
>>>>     Fault: update_invalid_user_pages()
>>>>       - Per-range hmm_range_fault() outside lock
>>>
>>> And here the idea falls apart. Each hmm_range_fault() can invalidate the other ranges while faulting them in.
>>>
>>> That is not fundamentally solveable, but by moving the handling further into hmm_range_fault it makes it much less likely that something goes wrong.
>>>
>>> So once more as long as this still uses this hacky approach I will clearly reject this implementation.
>>>
>>> Regards,
>>> Christian.
>>>
>>>>       - Acquires notifier_lock
>>>>       - Checks mem->invalid != saved_invalid → if changed, -EAGAIN retry
>>>>       - Sets range->valid = true for faulted ranges (under lock)
>>>>       - Releases notifier_lock
>>>>
>>>>     Validation: valid_user_pages_batch()
>>>>       - Checks range->valid flag
>>>>       - Calls amdgpu_ttm_tt_get_user_pages_done() (mmu_interval_read_retry)
>>>>
>>>> The logic is equivalent as far as I can see.
>>>>
>>>> Regards,
>>>> Honglei
>>>>
>>>>
>>>>
>>>> On 2026/2/9 21:27, Christian König wrote:
>>>>> On 2/9/26 14:11, Honglei Huang wrote:
>>>>>>
>>>>>> So the drm svm is also a NAK?
>>>>>>
>>>>>> These codes have passed local testing, opencl and rocr， I also provided a detailed code path and analysis.
>>>>>> You only said the conclusion without providing any reasons or evidence. Your statement has no justifiable reasons and is difficult to convince
>>>>>> so far.
>>>>>
>>>>> That sounds like you don't understand what the issue here is, I will try to explain this once more on pseudo-code.
>>>>>
>>>>> Page tables are updated without holding a lock, so when you want to grab physical addresses from the then you need to use an opportunistically retry based approach to make sure that the data you got is still valid.
>>>>>
>>>>> In other words something like this here is needed:
>>>>>
>>>>> retry:
>>>>>       hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
>>>>>       hmm_range.hmm_pfns = kvmalloc_array(npages, ...);
>>>>> ...
>>>>>       while (true) {
>>>>>           mmap_read_lock(mm);
>>>>>           err = hmm_range_fault(&hmm_range);
>>>>>           mmap_read_unlock(mm);
>>>>>
>>>>>           if (err == -EBUSY) {
>>>>>               if (time_after(jiffies, timeout))
>>>>>                   break;
>>>>>
>>>>>               hmm_range.notifier_seq =
>>>>>                   mmu_interval_read_begin(notifier);
>>>>>               continue;
>>>>>           }
>>>>>           break;
>>>>>       }
>>>>> ...
>>>>>       for (i = 0, j = 0; i < npages; ++j) {
>>>>> ...
>>>>>           dma_map_page(...)
>>>>> ...
>>>>>       grab_notifier_lock();
>>>>>       if (mmu_interval_read_retry(notifier, hmm_range.notifier_seq))
>>>>>           goto retry;
>>>>>       restart_queues();
>>>>>       drop_notifier_lock();
>>>>> ...
>>>>>
>>>>> Now hmm_range.notifier_seq indicates if your DMA addresses are still valid or not after you grabbed the notifier lock.
>>>>>
>>>>> The problem is that hmm_range works only on a single range/sequence combination, so when you do multiple calls to hmm_range_fault() for scattered VA is can easily be that one call invalidates the ranges of another call.
>>>>>
>>>>> So as long as you only have a few hundred hmm_ranges for your userptrs that kind of works, but it doesn't scale up into the thousands of different VA addresses you get for scattered handling.
>>>>>
>>>>> That's why hmm_range_fault needs to be modified to handle an array of VA addresses instead of just a A..B range.
>>>>>
>>>>> Regards,
>>>>> Christian.
>>>>>
>>>>>
>>>>>>
>>>>>> On 2026/2/9 20:59, Christian König wrote:
>>>>>>> On 2/9/26 13:52, Honglei Huang wrote:
>>>>>>>> DRM GPU SVM does use hmm_range_fault(), see drm_gpusvm_get_pages()
>>>>>>>
>>>>>>> I'm not sure what you are talking about, drm_gpusvm_get_pages() only supports a single range as well and not scatter gather of VA addresses.
>>>>>>>
>>>>>>> As far as I can see that doesn't help the slightest.
>>>>>>>
>>>>>>>> My implementation follows the same pattern. The detailed comparison
>>>>>>>> of invalidation path was provided in the second half of my previous mail.
>>>>>>>
>>>>>>> Yeah and as I said that is not very valuable because it doesn't solves the sequence problem.
>>>>>>>
>>>>>>> As far as I can see the approach you try here is a clear NAK from my side.
>>>>>>>
>>>>>>> Regards,
>>>>>>> Christian.
>>>>>>>
>>>>>>>>
>>>>>>>> On 2026/2/9 18:16, Christian König wrote:
>>>>>>>>> On 2/9/26 07:14, Honglei Huang wrote:
>>>>>>>>>>
>>>>>>>>>> I've reworked the implementation in v4. The fix is actually inspired
>>>>>>>>>> by the DRM GPU SVM framework (drivers/gpu/drm/drm_gpusvm.c).
>>>>>>>>>>
>>>>>>>>>> DRM GPU SVM uses wide notifiers (recommended 512M or larger) to track
>>>>>>>>>> multiple user virtual address ranges under a single mmu_interval_notifier,
>>>>>>>>>> and these ranges can be non-contiguous which is essentially the same
>>>>>>>>>> problem that batch userptr needs to solve: one BO backed by multiple
>>>>>>>>>> non-contiguous CPU VA ranges sharing one notifier.
>>>>>>>>>
>>>>>>>>> That still doesn't solve the sequencing problem.
>>>>>>>>>
>>>>>>>>> As far as I can see you can't use hmm_range_fault with this approach or it would just not be very valuable.
>>>>>>>>>
>>>>>>>>> So how should that work with your patch set?
>>>>>>>>>
>>>>>>>>> Regards,
>>>>>>>>> Christian.
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> The wide notifier is created in drm_gpusvm_notifier_alloc:
>>>>>>>>>>        notifier->itree.start = ALIGN_DOWN(fault_addr, gpusvm->notifier_size);
>>>>>>>>>>        notifier->itree.last = ALIGN(fault_addr + 1, gpusvm->notifier_size) - 1;
>>>>>>>>>> The Xe driver passes
>>>>>>>>>>        xe_modparam.svm_notifier_size * SZ_1M in xe_svm_init
>>>>>>>>>> as the notifier_size, so one notifier can cover many of MB of VA space
>>>>>>>>>> containing multiple non-contiguous ranges.
>>>>>>>>>>
>>>>>>>>>> And DRM GPU SVM solves the per-range validity problem with flag-based
>>>>>>>>>> validation instead of seq-based validation in:
>>>>>>>>>>        - drm_gpusvm_pages_valid() checks
>>>>>>>>>>            flags.has_dma_mapping
>>>>>>>>>>          not notifier_seq. The comment explicitly states:
>>>>>>>>>>            "This is akin to a notifier seqno check in the HMM documentation
>>>>>>>>>>             but due to wider notifiers (i.e., notifiers which span multiple
>>>>>>>>>>             ranges) this function is required for finer grained checking"
>>>>>>>>>>        - __drm_gpusvm_unmap_pages() clears
>>>>>>>>>>            flags.has_dma_mapping = false  under notifier_lock
>>>>>>>>>>        - drm_gpusvm_get_pages() sets
>>>>>>>>>>            flags.has_dma_mapping = true  under notifier_lock
>>>>>>>>>> I adopted the same approach.
>>>>>>>>>>
>>>>>>>>>> DRM GPU SVM:
>>>>>>>>>>        drm_gpusvm_notifier_invalidate()
>>>>>>>>>>          down_write(&gpusvm->notifier_lock);
>>>>>>>>>>          mmu_interval_set_seq(mni, cur_seq);
>>>>>>>>>>          gpusvm->ops->invalidate()
>>>>>>>>>>            -> xe_svm_invalidate()
>>>>>>>>>>               drm_gpusvm_for_each_range()
>>>>>>>>>>                 -> __drm_gpusvm_unmap_pages()
>>>>>>>>>>                    WRITE_ONCE(flags.has_dma_mapping = false);  // clear flag
>>>>>>>>>>          up_write(&gpusvm->notifier_lock);
>>>>>>>>>>
>>>>>>>>>> KFD batch userptr:
>>>>>>>>>>        amdgpu_amdkfd_evict_userptr_batch()
>>>>>>>>>>          mutex_lock(&process_info->notifier_lock);
>>>>>>>>>>          mmu_interval_set_seq(mni, cur_seq);
>>>>>>>>>>          discard_invalid_ranges()
>>>>>>>>>>            interval_tree_iter_first/next()
>>>>>>>>>>              range_info->valid = false;          // clear flag
>>>>>>>>>>          mutex_unlock(&process_info->notifier_lock);
>>>>>>>>>>
>>>>>>>>>> Both implementations:
>>>>>>>>>>        - Acquire notifier_lock FIRST, before any flag changes
>>>>>>>>>>        - Call mmu_interval_set_seq() under the lock
>>>>>>>>>>        - Use interval tree to find affected ranges within the wide notifier
>>>>>>>>>>        - Mark per-range flag as invalid/valid under the lock
>>>>>>>>>>
>>>>>>>>>> The page fault path and final validation path also follow the same
>>>>>>>>>> pattern as DRM GPU SVM: fault outside the lock, set/check per-range
>>>>>>>>>> flag under the lock.
>>>>>>>>>>
>>>>>>>>>> Regards,
>>>>>>>>>> Honglei
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> On 2026/2/6 21:56, Christian König wrote:
>>>>>>>>>>> On 2/6/26 07:25, Honglei Huang wrote:
>>>>>>>>>>>> From: Honglei Huang <honghuan@amd.com>
>>>>>>>>>>>>
>>>>>>>>>>>> Hi all,
>>>>>>>>>>>>
>>>>>>>>>>>> This is v3 of the patch series to support allocating multiple non-contiguous
>>>>>>>>>>>> CPU virtual address ranges that map to a single contiguous GPU virtual address.
>>>>>>>>>>>>
>>>>>>>>>>>> v3:
>>>>>>>>>>>> 1. No new ioctl: Reuses existing AMDKFD_IOC_ALLOC_MEMORY_OF_GPU
>>>>>>>>>>>>          - Adds only one flag: KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH
>>>>>>>>>>>
>>>>>>>>>>> That is most likely not the best approach, but Felix or Philip need to comment here since I don't know such IOCTLs well either.
>>>>>>>>>>>
>>>>>>>>>>>>          - When flag is set, mmap_offset field points to range array
>>>>>>>>>>>>          - Minimal API surface change
>>>>>>>>>>>
>>>>>>>>>>> Why range of VA space for each entry?
>>>>>>>>>>>
>>>>>>>>>>>> 2. Improved MMU notifier handling:
>>>>>>>>>>>>          - Single mmu_interval_notifier covering the VA span [va_min, va_max]
>>>>>>>>>>>>          - Interval tree for efficient lookup of affected ranges during invalidation
>>>>>>>>>>>>          - Avoids per-range notifier overhead mentioned in v2 review
>>>>>>>>>>>
>>>>>>>>>>> That won't work unless you also modify hmm_range_fault() to take multiple VA addresses (or ranges) at the same time.
>>>>>>>>>>>
>>>>>>>>>>> The problem is that we must rely on hmm_range.notifier_seq to detect changes to the page tables in question, but that in turn works only if you have one hmm_range structure and not multiple.
>>>>>>>>>>>
>>>>>>>>>>> What might work is doing an XOR or CRC over all hmm_range.notifier_seq you have, but that is a bit flaky.
>>>>>>>>>>>
>>>>>>>>>>> Regards,
>>>>>>>>>>> Christian.
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> 3. Better code organization: Split into 8 focused patches for easier review
>>>>>>>>>>>>
>>>>>>>>>>>> v2:
>>>>>>>>>>>>          - Each CPU VA range gets its own mmu_interval_notifier for invalidation
>>>>>>>>>>>>          - All ranges validated together and mapped to contiguous GPU VA
>>>>>>>>>>>>          - Single kgd_mem object with array of user_range_info structures
>>>>>>>>>>>>          - Unified eviction/restore path for all ranges in a batch
>>>>>>>>>>>>
>>>>>>>>>>>> Current Implementation Approach
>>>>>>>>>>>> ===============================
>>>>>>>>>>>>
>>>>>>>>>>>> This series implements a practical solution within existing kernel constraints:
>>>>>>>>>>>>
>>>>>>>>>>>> 1. Single MMU notifier for VA span: Register one notifier covering the
>>>>>>>>>>>>          entire range from lowest to highest address in the batch
>>>>>>>>>>>>
>>>>>>>>>>>> 2. Interval tree filtering: Use interval tree to efficiently identify
>>>>>>>>>>>>          which specific ranges are affected during invalidation callbacks,
>>>>>>>>>>>>          avoiding unnecessary processing for unrelated address changes
>>>>>>>>>>>>
>>>>>>>>>>>> 3. Unified eviction/restore: All ranges in a batch share eviction and
>>>>>>>>>>>>          restore paths, maintaining consistency with existing userptr handling
>>>>>>>>>>>>
>>>>>>>>>>>> Patch Series Overview
>>>>>>>>>>>> =====================
>>>>>>>>>>>>
>>>>>>>>>>>> Patch 1/8: Add userptr batch allocation UAPI structures
>>>>>>>>>>>>           - KFD_IOC_ALLOC_MEM_FLAGS_USERPTR_BATCH flag
>>>>>>>>>>>>           - kfd_ioctl_userptr_range and kfd_ioctl_userptr_ranges_data structures
>>>>>>>>>>>>
>>>>>>>>>>>> Patch 2/8: Add user_range_info infrastructure to kgd_mem
>>>>>>>>>>>>           - user_range_info structure for per-range tracking
>>>>>>>>>>>>           - Fields for batch allocation in kgd_mem
>>>>>>>>>>>>
>>>>>>>>>>>> Patch 3/8: Implement interval tree for userptr ranges
>>>>>>>>>>>>           - Interval tree for efficient range lookup during invalidation
>>>>>>>>>>>>           - mark_invalid_ranges() function
>>>>>>>>>>>>
>>>>>>>>>>>> Patch 4/8: Add batch MMU notifier support
>>>>>>>>>>>>           - Single notifier for entire VA span
>>>>>>>>>>>>           - Invalidation callback using interval tree filtering
>>>>>>>>>>>>
>>>>>>>>>>>> Patch 5/8: Implement batch userptr page management
>>>>>>>>>>>>           - get_user_pages_batch() and set_user_pages_batch()
>>>>>>>>>>>>           - Per-range page array management
>>>>>>>>>>>>
>>>>>>>>>>>> Patch 6/8: Add batch allocation function and export API
>>>>>>>>>>>>           - init_user_pages_batch() main initialization
>>>>>>>>>>>>           - amdgpu_amdkfd_gpuvm_alloc_memory_of_gpu_batch() entry point
>>>>>>>>>>>>
>>>>>>>>>>>> Patch 7/8: Unify userptr cleanup and update paths
>>>>>>>>>>>>           - Shared eviction/restore handling for batch allocations
>>>>>>>>>>>>           - Integration with existing userptr validation flows
>>>>>>>>>>>>
>>>>>>>>>>>> Patch 8/8: Wire up batch allocation in ioctl handler
>>>>>>>>>>>>           - Input validation and range array parsing
>>>>>>>>>>>>           - Integration with existing alloc_memory_of_gpu path
>>>>>>>>>>>>
>>>>>>>>>>>> Testing
>>>>>>>>>>>> =======
>>>>>>>>>>>>
>>>>>>>>>>>> - Multiple scattered malloc() allocations (2-4000+ ranges)
>>>>>>>>>>>> - Various allocation sizes (4KB to 1G+ per range)
>>>>>>>>>>>> - Memory pressure scenarios and eviction/restore cycles
>>>>>>>>>>>> - OpenCL CTS and HIP catch tests in KVM guest environment
>>>>>>>>>>>> - AI workloads: Stable Diffusion, ComfyUI in virtualized environments
>>>>>>>>>>>> - Small LLM inference (3B-7B models)
>>>>>>>>>>>> - Benchmark score: 160,000 - 190,000 (80%-95% of bare metal)
>>>>>>>>>>>> - Performance improvement: 2x-2.4x faster than userspace approach
>>>>>>>>>>>>
>>>>>>>>>>>> Thank you for your review and feedback.
>>>>>>>>>>>>
>>>>>>>>>>>> Best regards,
>>>>>>>>>>>> Honglei Huang
>>>>>>>>>>>>
>>>>>>>>>>>> Honglei Huang (8):
>>>>>>>>>>>>         drm/amdkfd: Add userptr batch allocation UAPI structures
>>>>>>>>>>>>         drm/amdkfd: Add user_range_info infrastructure to kgd_mem
>>>>>>>>>>>>         drm/amdkfd: Implement interval tree for userptr ranges
>>>>>>>>>>>>         drm/amdkfd: Add batch MMU notifier support
>>>>>>>>>>>>         drm/amdkfd: Implement batch userptr page management
>>>>>>>>>>>>         drm/amdkfd: Add batch allocation function and export API
>>>>>>>>>>>>         drm/amdkfd: Unify userptr cleanup and update paths
>>>>>>>>>>>>         drm/amdkfd: Wire up batch allocation in ioctl handler
>>>>>>>>>>>>
>>>>>>>>>>>>        drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  23 +
>>>>>>>>>>>>        .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 539 +++++++++++++++++-
>>>>>>>>>>>>        drivers/gpu/drm/amd/amdkfd/kfd_chardev.c      | 128 ++++-
>>>>>>>>>>>>        include/uapi/linux/kfd_ioctl.h                |  31 +-
>>>>>>>>>>>>        4 files changed, 697 insertions(+), 24 deletions(-)
>>>>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
> 



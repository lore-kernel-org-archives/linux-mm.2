Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7593CCAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B61C28E000B; Tue, 23 Sep 2025 04:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39558E0001; Tue, 23 Sep 2025 04:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27B78E000B; Tue, 23 Sep 2025 04:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FBA48E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:37:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2EDD51403F4
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:37:00 +0000 (UTC)
X-FDA: 83919859800.24.542668D
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011006.outbound.protection.outlook.com [52.101.52.6])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4BE8940003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:36:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=teLO8FaW;
	spf=pass (imf11.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 52.101.52.6 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758616617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdIJ7BqTWxjXEIUFX4zshCKmyeks7W+an+sDVTnNrcY=;
	b=TWv0phAmSxk0IKSscN5NwdlzgaM1v61DqKZ1rehLwXq0BXlh4zIKYY+ee0w9SSG2DvLlk1
	/2F2WWCCZLxluYXxuTcCbEDNmksbN1/MT3QgacXNVXCIvs6MoImskgXEL+Dc3UwtpoYBBZ
	AOyi9YIERYwfzlZSGR1CZhgdt68gCDE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=teLO8FaW;
	spf=pass (imf11.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 52.101.52.6 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758616617; a=rsa-sha256;
	cv=pass;
	b=SzdwLHAba2pJ/8WgaG5P4xkQCPnAI0opsjh6ntKhUVyPJ51STZlGq8FEJaPTxqA5/PpzEf
	c7JwLMrV6ISbA+reZJQh7Dxme7TGcyAgjHMhmOJqsmegthF5Rb3tG6PREs0sWej/X/PUGQ
	MaAqSOkr4NypLkgbE3pV229jcLsvmSA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jF4p5wMxdsLQKfmZlMdYoMYTJzW/0DF7gi8uD2Zd94XFcGIB6tHyruz0edhpia+UElpGE0IDilsLvHtSX/HkXU3AEQBgN9wHDLmDdRmYqQzVQeR3crVgK887OfJ55K6qbkr32pkvpNnqLNic6GYQ25aCZN0r5aU+Sh7lRPbGEsdnT1JO+9TPub1UWrFa3HXs58ixzSwghmJ/2N3T4UULsAxBZY0XQ8vNJGW/afRw6A+wrYcKqoJFqdONhPjZa4vsj0h9WqpYEgunowO6BZPC/AqYP2HjMkzXhhwEx6u4/P4GSVLflaBHgcaiYfAh/B74vgKYzEAVE5LxdPs2FD09gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdIJ7BqTWxjXEIUFX4zshCKmyeks7W+an+sDVTnNrcY=;
 b=AQ6yy9gsANDQ8nJFbJGT5xUVIZgqRACYqdy8gywlEK548JTT/EmAWMbJyQGLNev4F/D4gTpfDdYXJoNGH6exwc5A48cSQQM08RvYN3v9yFpTZ06VrngBpJGho1nTTTBW6cTFQRKok+9rsgMRv2icO62z3EbVsbygmDMV3My47IiCoZEc3anp6jZcyRI/tBE4wP6IgQZPE/nYIWW2OSRbJMemUtGAIG6LL4gcWae1XJG550mtJ4d18M6LzPvk7QPCUrgWJ/PrZnM2jndCl1fmFv8oAkpSPhob/vNQ46PL9fsRnO0KigrxAoiFLYU9pB8rsrPCgjGRyUKniwgHW6VQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdIJ7BqTWxjXEIUFX4zshCKmyeks7W+an+sDVTnNrcY=;
 b=teLO8FaWJArMBisgEYgVXZfvns1KQNXX9DlywF4NaGrrD7iXU/XPD1tNvDmjfE26EiA3zW5WaB7co1oRBLeAadSzmI0YCYNlEoT5Mrc2bvOYq0Jg1TB+2QK4/vZ55q6Csx/FtpcUeJmt30nnXTdeLCNTFscMyn9znyZT4Dt3f/E=
Received: from PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13)
 by SA3PR12MB8045.namprd12.prod.outlook.com (2603:10b6:806:31d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 08:36:53 +0000
Received: from PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1]) by PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::35dc:5b7a:52da:c8f1%5]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 08:36:53 +0000
Message-ID: <02da5912-b77e-42fa-be1c-d10c915730d2@amd.com>
Date: Tue, 23 Sep 2025 14:06:42 +0530
User-Agent: Mozilla Thunderbird
From: Raghavendra K T <rkodsara@amd.com>
Subject: Re: [PATCH v7 13/16] mm: memory: support clearing page ranges
To: Andrew Morton <akpm@linux-foundation.org>,
 Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
 willy@infradead.org, raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
 konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-14-ankur.a.arora@oracle.com>
 <20250917144418.25cb9117d64b32cb0c7908d9@linux-foundation.org>
Content-Language: en-US
In-Reply-To: <20250917144418.25cb9117d64b32cb0c7908d9@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0110.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2ad::11) To PH7PR12MB5805.namprd12.prod.outlook.com
 (2603:10b6:510:1d1::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5805:EE_|SA3PR12MB8045:EE_
X-MS-Office365-Filtering-Correlation-Id: f971f4cc-8262-420e-82d0-08ddfa7c5898
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2lKTjJ1WmRBa1JDZ0FHaFFJcy9FTDRabDdSdDhZNnl1MW04eEFkTURjaGQ5?=
 =?utf-8?B?VHBqNTUyUTl5VTZBZC9tdEZ6RS90aGRIT0xpQ29oazZTWEFHUGkwOGovWUJi?=
 =?utf-8?B?RWFLUTgwS1lycHo5NCtuWUliemllbk9MRnlUMjU4WngwS0QrV0tsUFE5eEFT?=
 =?utf-8?B?WHFiam9uRHNTSnBjWW1wN0FhdStickVQc3JweU13R3I0MUFMVmF3alRocmtj?=
 =?utf-8?B?eldESml1QjhwdEhqKzQyb2ppdFVraWZrK1Jqd2NrYU9RVTJwaGdNUWdmZGNw?=
 =?utf-8?B?bTFxWWxOME5BVXlQMnU2b2xULzVlNDBlckRYRmtaZGlNMWg5V1N0NnZVc3V3?=
 =?utf-8?B?aHlHUVR3ZUgzNWwyOVlBODd1QnRMeVJrOFhUVWdSWG14NFZGWU9XZGhseEg4?=
 =?utf-8?B?aTFUdXFKOW9aUG16M0NrSWl0cVI4OEpRRnRkdzlSZnhLbkw5RDNlLzZQU3da?=
 =?utf-8?B?MmppTVJKZGg4NmFpV0N2V25pSjRJU0hFMGRqalFEdDJvYXBsTEhTN2xGMkNt?=
 =?utf-8?B?dms5b0FrZitoc2crblA3N21ZZ0tPWk8zYWw2dlJBOEVQOGc4dWRrakhrUVZi?=
 =?utf-8?B?YW9VRmM2ZWxwQWdRTHhpSTN6TXh1cGJuVDFzL3piMlVpRDBxQzVxalpOQzVo?=
 =?utf-8?B?RDZrdXhSY1VNWXA5bUhENGVkb281Mk01SnFQbk92Vm5WV0lXLysvVU9OQnJI?=
 =?utf-8?B?cWY0aFEvL0QvTDBwKzdpdU4xVHRxUmhmekdBeVJqYzcwclRBV1FmYjdvTUhl?=
 =?utf-8?B?b1huR1Azd2FZajVwMU1zd01CR3Zrd3EybVk3RzdYc0YvT08rVlBwbUdpM2Uy?=
 =?utf-8?B?ZWdFSGhsV244bHVpeE9RL2Zqczg0K09TemdJZmxBMzFBTzg5N0FFOWwveXY1?=
 =?utf-8?B?Wk9Hdzh6VkFzalE2UVYwNnV4TmwxOUNzcklDR2FKTU53dmRoc2hLaVF1QzBU?=
 =?utf-8?B?eldUb1BGSUhFVlVOSzNPTUI5RjNNaTNucTZJQ1lDdDVrUU5JcXlYUU1HY3Vv?=
 =?utf-8?B?NW1GR3R4a1Y3UjV1VG1hOHpLRkJvaGF3d3IyYzZTTGJTUnA1SnNnbFgvSGRv?=
 =?utf-8?B?L3pLVG5HbjRxOWVXTFQ5RmJBc0ZpZWhEcTlwMmlxeUhlNXBnSDQvYUc4Vk9O?=
 =?utf-8?B?OHJyYUJTTCt2cnh5NU42QU9HbWZ6M2d0VzVaZVJNaWFwc0tIUnNxaXFjVzN0?=
 =?utf-8?B?TkpRVkdVcU1jMlhyZXZFUnZEcVRIOFNpL2lNSlEyelpoUkZRUExxb0ZZMk40?=
 =?utf-8?B?ZWttOWZGdVl2YnI4REl5YTI5c1J1RGpHeFl2MXg5SFd1Rm05bnpLa20rN09B?=
 =?utf-8?B?Sm5uOTdGVmhPTXJWOHZGbFVRVHVUZWhvaGw2WFdKTGdNRE1xN1lqSW01VDll?=
 =?utf-8?B?Zkg3dXZ3Um8xWTM5LzFDdC9ON2NHWEh1TU51dTdXN3BhUlRJNkNkcjVhN1Bt?=
 =?utf-8?B?a1JUQ0QzRVFVTUlMQ0dkQmtSa2M1U0xNYmhTdEJEV1h5STZxSlV0eDl2cmlN?=
 =?utf-8?B?UVo2SXM5eFBoeWFxR2VXM3kzMDI2UU9Fak5UZ0VtRlZkN29YdkZ5TXk4a0JO?=
 =?utf-8?B?UGl2dnlSUHhDaStxbTg2aVNzZ1V5QkU5NndqL2J4U0dIOVQ4WUVSTWJra2pQ?=
 =?utf-8?B?d1Fmd1hTWDZuYWwwMDNzRlhoTmdmczBnelM4am94TTBMb2YvV1FLMEdYakVz?=
 =?utf-8?B?TXhoVGN5Tm95Mm9kYmxsOVFsdlF6dHNWdUhtSjJXcVZyNUtBeFEyUUJha2hZ?=
 =?utf-8?B?NVgybVpOZVpNY05jS3cwNm5nR1U3MUdPbjBRamxCbjJkV0xEc3BuQ1ZtdVNv?=
 =?utf-8?B?bVhtK3NqR3dmN0I2QzIraTdkOE10ZjVNa201RXpDUGRwWmNwbndGWTUwNDZT?=
 =?utf-8?B?cUFpcEZsZVZSYldqQkFOVFJZSS92Sm55VG44cWtEQWVxUkE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5805.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elhqbVhqT2g4RHk3VER2cWVPMFRuTlRzZFZYUzJxT2diRnN0aHNiaTFYVno5?=
 =?utf-8?B?MGhsS3dIc0c2dkRhU1BwRHpLOHJiWW5Ldk40bmwzaDMvKzhuYml3R2JCaVA3?=
 =?utf-8?B?MWRZcjhpYVRINVBTQVYrYVpXbkxtK2luYXVHb1pxd082TlExMVF5OWFmS0xR?=
 =?utf-8?B?U1Y4bm5HL04yb3JuVDRoSjMwc1dyQ3gyaGcwN3FRRGd3MEErUys5VGZjVzZV?=
 =?utf-8?B?ZW90d0pOcGFrbTNvb09wSzJCTGx1dHg3STFHOWVJQzdXcWxBVzY0UzR1V3Na?=
 =?utf-8?B?dmNRblMyR2dwT2dBNEhTcGlxT3V4VlYxMG5zV2UveHlnTEYvR1BIazlBVWVk?=
 =?utf-8?B?R0cwYU5semNXWlMyQ2xmRGNYNGV1RDl6TWVjU1p1YUFGUWF2K0ZpMVpsU1Ro?=
 =?utf-8?B?ckF6cTBCMVRXTHNCNStERDFZR2FMbWc4ZVVwL1lXcnVLMFV5TnZKa01iaTVP?=
 =?utf-8?B?RmVQbG14WkdFb3VUVFZCNkNJVnhnSkh5Njh5Q1BNUFU0UDc1K3VsaC9BbGpI?=
 =?utf-8?B?UjFMK0NERHZaNjlrZjhxWnNiUk92MG9oam00TGtCZzB2MCtzNGpqM1NOb0NC?=
 =?utf-8?B?V0Mrd2tvMHhyQ3UreXRzZlc2VXY5WUNVNFpPemZmQzBIMTdTTy82SlBZaCtB?=
 =?utf-8?B?UW5oQWF5UGp1MGhwSFVVQzl0K2w0Z3llUDBpRGltUjV1U3RGdlRTTEt4KzQy?=
 =?utf-8?B?Z0NLanU4ZWxmemFDbFg4eGt0am5nRWszMzJmSWVReUtCWUZXZWFtWmUrUXZG?=
 =?utf-8?B?WENEaldoZysvaFRLMHNqMktnSGJDR1FVMHdPNU4wdTQ3R0l2cmMrYlg2R0sr?=
 =?utf-8?B?T2tzTmR6USt5aFB6c1laNk9ORTNMRGhzV1VTM1IyU2w1Unc1c3dTckhLaSsx?=
 =?utf-8?B?UGhRSFFYaEtzSzZobEE5MzRHTW5oZ0cxVkkwa2w3NEg0dlRjejZGeTVCelIy?=
 =?utf-8?B?VnFtSHl2SC9GRmNaYlhwUGI2SGhma0x2by9DZkJTVWlaaHNHVTR0Wkw4VEw4?=
 =?utf-8?B?Z3NHaFpxcWFwSHRiZFk3d21vK1JmZEV3elRVMExNeUxrSEp5UVVVZTNneGNO?=
 =?utf-8?B?QkRveE1oU3h3ZU1JYVFVYVdtT01idzNlcGxnZlBhRENLRm5UNnBoTTRhbUZL?=
 =?utf-8?B?bkZyczhEdVdjckZHQmNLd3pJUWJQZDlsSUc4Vm1OUzBLMW5LelFhK1A1MlRH?=
 =?utf-8?B?cFA1L0pkYTI0K2RVaFJCZU9CcHBhek54Y0pzQ0xxUkVTWEZveFpRVkFQRE5I?=
 =?utf-8?B?bWtweHN4Z2tpbEpzY0JNb1ROdU9CMUprUTBZaFk2bzRQZ3JPdmpJQjJRNEV0?=
 =?utf-8?B?VEZjYWIzSG1jc2V1ZEdPZDY4MmExRVIxb2xuQjUwYVRydDZ4d1o2c1F2RjJK?=
 =?utf-8?B?RVUvUy9DMGMxT3pFUDUxN2ZRYWNtRDFIZm12eXpxZWNSbUdjUUpQT3JiY0M2?=
 =?utf-8?B?d2kzck5JUGVoQVdnV1VxdHhvUG1GWURsU2dnd0hkdldpa2ZURXhGMVRndDBI?=
 =?utf-8?B?aktiTkFpdVErRDlKcWpuempVamZsbmdhWXF1UnFRUkduR3lFWFFyMks2Y3Y1?=
 =?utf-8?B?dVl4dldwVmxxSXozeTF6ZE85Yk1UeVd4NXRxTjVGdFV3ZTd5SEY2SFF0OXhj?=
 =?utf-8?B?M2FSMlcwd28vTm1uOEkvN0g1NFFaNnVhQ2Mrd2tlUFdOaUNmc2FCT1RxOUVV?=
 =?utf-8?B?YVBtV3R1T0lMeVh3ZDd6QUwzNitxV056WlRzWHFEZG9UM0tTcmZRaWN6bHR4?=
 =?utf-8?B?SWUvVVd2VGJPM3E4NkxITEhhbXJ3SGNHZHpINlM4dEhDY2ZvaWg2UE42ODFp?=
 =?utf-8?B?MmhkVG41dFpQb3hPSHpVWmx1UkpYNVRSdmRzbWRnS0dEUWtuV1RPdmpPejZN?=
 =?utf-8?B?SnNycHQ0dEQ5TDU2aU5udkxOaEhZRzlpWXZMNHA5dzZvM3N0UUdFbUY2QTdi?=
 =?utf-8?B?L1V0L3VwMG1KUE1tWS9NaFdHMWJLWjJUOUgyMzIyRFp4bndhd0NnOU5xTWN5?=
 =?utf-8?B?eHVSLzhwK0RST2xZN1JWQzIvVUVSMEhUV0ZWd2I0S3Y1YUs5R2pJWkdZS1JZ?=
 =?utf-8?B?SHBhSWNqQ0g4S0NaemUvMlY1c3lvRzdQbnVpTnRwZndGSGxENWpGVnZyckw3?=
 =?utf-8?Q?Fm1ur0UTSxBHlA/l4KDo6XuBz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f971f4cc-8262-420e-82d0-08ddfa7c5898
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5805.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 08:36:52.9665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGft2egnUdVAmQJxYUZOik5mTsxghL2rRCqQZQMSO3qsQFjW8qiDFQ2rwSBCgCzPI4X2Q+nMRJSC84CbsCvoGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8045
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4BE8940003
X-Stat-Signature: enfp94u9sdjsq3c7m9zsd7q8jwto9gtw
X-HE-Tag: 1758616617-183595
X-HE-Meta: U2FsdGVkX1/nU4pIoPHrU12vVsEAAQ+idBMnTzUm6uSkJYOpaMbCL49yp2XR1nolRbZRHT9Gul4GNykIOezdZuK/65C8lxGBj+2gqAFGvznDJG0UKkSLAwO6hHiLlZp9dI6diSpspSzOQ2o0/JmL/uLj7RIb9lRH+ACOHW5MDaAHsQxT+025GI2q8n4R3aLdXfiKgYMnVRWhI0QrMQ90lKtSK8GfT46Yl/gDVR29CZtz/llMR3Zi9DWCBALVq8zzzJ2rkRs3DhfdJNUl4ogCQVFhzriBDUl+ylhCJ8j+kqMX3vuq92/PrBCZC0xE8Io0GJ+M2Wk4wirqhhd+FXT1xhD5zkPAnUbdpJEnc47m6EEf9nggNqQDr4lgvMjQZj3pUq9NCQHy0QmR9utxRh73KrCM/vTpogqoulY9eizQlVxYxfSszjHWDSRIQykG1/4YH7+E7GCBdV3uXiy5SrYWHCngABp/9Jc8JlM2Pm7+yR2O1FXOrbglPrrh0V8eWtbO9M9kbtRxI741IVOeTacjRBO88/4J2ozW6cjzMPbMHwTHcvecIlXkQ5UWWpRUQkaWZyFmkhLfgh6NR8TF0l42iqG25et+fqmRT221k7YxKGWLyf0x/KfFrq5wVXdyljo6D8zDnakO24K2YBi3G0dUGn9vJIi4BeymoD0ybw3QZfQivPo/Hr2rkgm7QI79g/26tDAyfugXitGzndjhbBV64IjvTDd3MISVVNWi67rTV5cEV9YErcVUpfjELaRLUuwRK+FDDQegOydgGN4emHzwkdTwgUJUHw2nFypGZsGDrmoFXptR9enPJvxljntMyan+SHL7M1d7EjH+biMEw5+wWshUMMpp9f5UyEQAZAVDZux+J1YLwS3o/yrT1xmsIHhaRRzdFKxZl3CvBpDHjMOXLeYAdekVUC3m70iLjucaW2dr6ft7y9ZCFNCyIVySwRSa5+d8M/YrzO7dgXMpaRp
 aC2L8RpV
 /y9aL70J7thOvNfRCLsXO5/qHqj0mXh+itiN+nQmJ+iLGavKm3l/GQuQFg7nVs0wd8p2MWyu2orDvn1CRMbJaYKWjCIWw2A8/HoHHA25HND+W8itykvFfT/BUtkJX7E8PiFHGrklzZ1ff0p8isCKdIZH7C27UQcekkvRgWGy+I48+bIuM97kvFIv+vnCm+dicRBPn6lucMkb+ZOW7vAKbThcXALj45oo4CVMiXVm49Ng6KW+FOqD4upTgL4gaWT74yZNWGnW/Y49SNy/zV0tqMftkGRRz+iSbr0UIKafelqHQHYeIuaNEf3SkLKb/eU1wRliHF8hSvj0ZS8qRbtOZeoRvUCo6TQ2vxn5SMlDgSee29R2RjRPtNCx24OH2HVYFdY8G+6kXfcDVj9yK/2SVtaTlWUn7BSPvNz6glLjXMnchEQqa7C1xOFCuyUcOfWQo2irBDRz/f9lgWXgXxrvOgxevAKlCY6mhv+m4JhZgXfpJSsj3PIL9yQb4YbZ+jvwt1z+JLGie76thcIWKpgnEq2pPQ6QKoW4sNx0cMLyRh4XLldwv6zZd366cWZxxW04T58CIm0TNzTuxqnOvqHaggYYonRhbc0O/HCWRwIac1bAOXdtq45dJVXcxwqOrTShe1WzY0LLqZlRG08jZDWZc8lxwg/EISxAWEhjhtVF1cyrk91z/BVY8KvYKCIq4p/fCEl6fjc83UvA++fFuBvR/1avepw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/2025 3:14 AM, Andrew Morton wrote:
> On Wed, 17 Sep 2025 08:24:15 -0700 Ankur Arora <ankur.a.arora@oracle.com> wrote:
> 
>> Change folio_zero_user() to clear contiguous page ranges instead of
>> clearing using the current page-at-a-time approach. Exposing the largest
>> feasible length can be useful in enabling processors to optimize based
>> on extent.
> 
> This patch is something which MM developers might care to take a closer
> look at.
> 
>> However, clearing in large chunks can have two problems:
>>
>>   - cache locality when clearing small folios (< MAX_ORDER_NR_PAGES)
>>     (larger folios don't have any expectation of cache locality).
>>
>>   - preemption latency when clearing large folios.
>>
>> Handle the first by splitting the clearing in three parts: the
>> faulting page and its immediate locality, its left and right
>> regions; with the local neighbourhood cleared last.
> 
> Has this optimization been shown to be beneficial?
> 
> If so, are you able to share some measurements?
> 
> If not, maybe it should be removed?
> 

I reverted the effect of this patch by hard coding

#define PAGE_CONTIG_NR 1

I see that benefit for voluntary kernel is lost without this change

(for rep stosb)

with PAGE_CONTIG_NR equivalent to 8MB

Preempt mode: voluntary

# Running 'mem/mmap' benchmark:
# function 'demand' (Demand loaded mmap())
# Copying 64GB bytes ...

       34.533414 GB/sec


with PAGE_CONTIG_NR equivalent to 4KB

# Running 'mem/mmap' benchmark:
# function 'demand' (Demand loaded mmap())
# Copying 64GB bytes ...

       20.766059 GB/sec

For now (barring David's recommendations),
feel free to add

Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>




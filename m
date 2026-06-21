Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED8ECDB466
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 02:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6146B0005; Sat, 20 Jun 2026 22:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FCF6B008A; Sat, 20 Jun 2026 22:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 931196B008C; Sat, 20 Jun 2026 22:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 598B56B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 22:20:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0D851C19E8
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:20:32 +0000 (UTC)
X-FDA: 84902315904.26.90C28D0
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010054.outbound.protection.outlook.com [40.93.198.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id D862220002
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 02:20:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mBNrf4od;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782008430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VH+9XMeDrCPCwLbBkBriDx0l97DtIduYf3XikY7cSg4=;
	b=WWUactSTXnxpis/6bpiP5O7lf19ivZUQJ5aDSFOdycX3dmpZin2WqK81tglvtsC4BaV9Tj
	5oGWjy5P1imcW+g3cDxMKMUlnDVRykrWL52W8H5iUbYl6EwgntAfes5SRdxyRFDSNTHUjY
	NPIQiXKGi0WC1uI0aC/JnbgepadN1jM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mBNrf4od;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf03.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782008430;
	b=AZUkPWS3jq0vH7Ke8LZgsaCC4MSKOkJoedSHEn1YwvS7DhHWPS3VBqk22pDGrUKgRSWC2b
	1b7owAGiQIFKs+JoUdkmSpg37QX3icafgN9M9VEgNsKqxMKMwKySOCRVdOd+QTn1MzRH6K
	XOCcxSf7iix5saR6ymx+kAPc54ekb20=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XYfpjZWW7rITC8p8ldMxx7MbuKGDESi9nvlg77RCYAx9ru8oys9qkI/xMtUJv21w4iOEO3jTTPxC0BKEZjlHaVsber3T5sxA2gqT9xUZcqiU06Y3+FADrNhLYoSMUdM4YuMlj+1ntWSkgjsHXdmje5m8Wrl3tJ1zV6tMCdiDWbhJcst2QoWsR6JZsQE9VlRbHbNqavP+lXDDHP9knQtz8DaGBuktzTgn/nx4ZYN929EtGlbvyRtD739+a6IoOsn4y3pjH3vGkGNB8XG9uXMR1ZJusunGVqwC/1QIvlK7508nCgyfopZCYEaq8WNwDGXjuFAWWDnJGyyGUkRlEKf1CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VH+9XMeDrCPCwLbBkBriDx0l97DtIduYf3XikY7cSg4=;
 b=LvDv2P6XskIoC7+/FHRjIKF5+kqjcxpwJa1ylRoVOe+hn2UGP4k7fmUapwJ+8AntS3VRT2KdaK3Ly2z4iBXPwFyAnE5y9u7U1eKVrCJ+mB/Wf8UXI1X1OyYhRGwSQvdVKqQKT181qnBjJ6IFlamngFg1DWhrj5lQp9suRIRMMPrfE25DY4jyHXFfCnK8OdWXh9dN9b9y8nDseiSL5NzGx5lFOJMFnQkPJGkY0pPerCNrY/nrdLnqW2+ts/LlbWZ7DKlbfeprjnQ/R4XRqcPwNALpf4xQu8h7o0oIdHHWAlxxEzEf3e45f7QjvdefvtPP4cVCrddLP6vPCBlBw9ntIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VH+9XMeDrCPCwLbBkBriDx0l97DtIduYf3XikY7cSg4=;
 b=mBNrf4odVNHxEle8Eah86Ilosvt62eow7DFcd2S66XHYVNqbcBG50V9pMIobEcbvEm3JXnhrjbdJQpM6truOwOIG4IbxybZ6UKjPUn8DvmSoPQ0ZLQLkOZS6i5jQAtq5iEm1oVxIHiSmq8g7uKl0zuC7nf0/Gyfo4Gx3d6UHi5TOVtP5rKvQ3XzpoUKv+LI9s6wAw96M9bbQNrciEWZe4701zxUkEaJFPV94Jz8BK3htoRbdhwe1bKlldeekNGVqMdQD+9x0PQOQE2POZIvl2i5l1n87+ex14rzf8J3Qf4e0fB4LmCCq2WFIa6FbM9x+4F8LFjCdqUtZGNLZQ9lD6w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7599.namprd12.prod.outlook.com (2603:10b6:8:109::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.18; Sun, 21 Jun
 2026 02:05:53 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0139.018; Sun, 21 Jun 2026
 02:05:51 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 20 Jun 2026 22:05:49 -0400
Message-Id: <DJECYEXHNDCT.3779ICP1UOOCM@nvidia.com>
Subject: Re: [PATCH v2] mm: remove PageTransCompound()
Cc: <linux-mm@kvack.org>, "David Hildenbrand" <david@kernel.org>, "Xu Xin"
 <xu.xin16@zte.com.cn>, "Chengming Zhou" <chengming.zhou@linux.dev>
To: "Kefeng Wang" <wangkefeng.wang@huawei.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260618113523.3913307-1-wangkefeng.wang@huawei.com>
In-Reply-To: <20260618113523.3913307-1-wangkefeng.wang@huawei.com>
X-ClientProxiedBy: YQBPR0101CA0337.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::22) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7599:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f287863-4c2e-4605-ebfc-08decf399e5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	dUSGoT6XHJpUP2mnGPjEuqi03kbYdd1K3VtVmp9oxAuOBqilpIgsKAn0WeFcXxbrOUPOb/ZIppwCviMctYsUqLyBELb5fGppvGyyJsDL/Am0ilR0mydDaTuKqKV7iZYSvuUwA1364G8HrrpjbR2N3w5F4vti+c/P3faRST4pKKXXtZN7dtQgEbiFrQqTbNCUlyKU8nyBpcj/FBaNT9tKmAbk+AqUa6O/hKwaxhnk1AsUe0yXiJ7VBTWqDjH8a4NToVkhWXc1GwG2ix5EnNOgAeyVtY58/u8Y5rv2GKa+NMFXeGog7Uxj8mtic1cRhklhl5uLcqeiYy9/NyB5br4xE6CEHDGvBH48XG1gC4+ZqV25w+oGpLqv358eSTBIqsiCycaCzkGLzhCM/HFSHKADf8wBDVTbHd5GVuwIJcVocy//CY0QSxSiiImUvWFueWg4GwQhSgoKoi7YfABsET+Jnbmwpt0RHykw2uyP71xM3CHAgSVxlLGs/M417J2SD2OGznBNwEY3wdhwY61Ol+4z9Vvaqq+sX1QGUc5h0LIqjOC4mjn134iCOhetCL4pS7JOexUWr/2AT0f+PG0CfxcBaYybiikFteW29JYAwtiRHr6Yn6rDzSEetjCncugSud2Ph3qBp/i4yZIMXCWbrG7ZKtg4YLZxIYrD5VHfvxguKko=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cGRmT2ZvTmx1QjBoM1JtNVJCSERtcm1BVUw1MW1GNWxrVHBEaTRIb01XV3pq?=
 =?utf-8?B?RmVrVnRpU3dKYWxJVTExbWRuSXJDclhicHk0eFhIbUlXSGx0RmkzN1Z4eUsx?=
 =?utf-8?B?VndsbFlNL3lGeVV2MERFSk5OUW1VdElib3loN1FsTGNTSkNCeTNPamlzYTVG?=
 =?utf-8?B?QW5mdWNLdlg1Vk5lQlh4Nno3RkVnTytGaEZaOWhyRGhldTM3NUsrczU5eld6?=
 =?utf-8?B?QzAwUTFRL3ZtY3lOblVqeExrQW40N2hIdGh5T3ZwbjZYNkcrSDFCVSt0Mzhs?=
 =?utf-8?B?MEtBNm1zKzhxNUIyWE5Ec0VzT242MlJ5ZWVJSjdYWnZDTks4anRRTkVBeldQ?=
 =?utf-8?B?N1hveUY0a0I4SzBTa0hONmpiNXUxdFBvTVlETVVFN1FyeUJTMmJFWHk5NExL?=
 =?utf-8?B?ajg5UUhXOTZOdEdhL0hNekVqYThPVlN2SXk2cE82U2VqSlQ4RGJ2N1N4dnRN?=
 =?utf-8?B?RWZVOHdIQUlSQ0N0aVZ2czdOaE5ubDVCSUxabVJzMzRnZmxhenc1U1FLY0hz?=
 =?utf-8?B?YnF2R1JKZXpRWTlZRXo1MUFlTmJpTzBFVGtXNk1ia2wyWGVld0ZPYytVWFhI?=
 =?utf-8?B?V3pGVVBzc0VEdDFuRWZBVnQzbFBOTVZqZEdUZHpMU3NqMG51MEtCNTJkb215?=
 =?utf-8?B?My9PWEs1L3RybWpia2c1OWYyd1N6TXNHM215bzZtK21JL1RVS0ZtblpOSFZI?=
 =?utf-8?B?V1Bpb2FqbForTnZqZ2hpSC9nWGNTdEpoK2Uvbk1YQmlUTzBlZnVLeVJJdEJ6?=
 =?utf-8?B?ak0xNElHTXdRS3pWREMvd0gwZmRMTzUybkpnS3NpeVBQeUNxdHZ5ZnNNaHQ4?=
 =?utf-8?B?dmVUTVl5b21UYWJLTnh5T0pZbVMwOG9mN1ZwNkdnV1F0SE8zczRHQU1OTTRp?=
 =?utf-8?B?RXRGWlI4azY5eHk3VU5CL2t3azdwbVhleTBCcHJhcmEzak5XT2FVY2h1TzZm?=
 =?utf-8?B?Q2RxNlRiSFlHU3pJdElHNXhTbzZDSHhOSFdmbEM0L1QzUEZZajlWM05pVkNK?=
 =?utf-8?B?Lzc4ZHJKK3luR202cjhQb0dyWlBYL0pVVGZscW5ScmZxcDhGa2lYeStvWUVW?=
 =?utf-8?B?WVhNTkRwakFvSmNlQW9pNk0rQ3gzZkg5bjZwL3BNdGgyNmcrRFRkYkN5OTZB?=
 =?utf-8?B?STI1UTF2N2ZzdmlQYVVwUVlsUTRFWWRha29UdkVzaFdaWTNJS0QraWlEMCtU?=
 =?utf-8?B?RWtLa0ZPTXp4dGllajd5OVBvZWdaNFl6ZXRkbUp5WDdlY2ZXTE5ud2RvR3Mw?=
 =?utf-8?B?QzZjWXpubzlHLzBKd05HbEkvVHpyYVdGUWlMTzEwbGpwWHZjRmV4elNXY0w2?=
 =?utf-8?B?RGNMdEh3dTBEUUxkOGtNMU1hcXRhS0lFMS8xZGtkbndydCsxR3crZFp3Q01U?=
 =?utf-8?B?KzZpZ2R1S3U2RkxCbi84ajRUcFZhRHdtcWkrZVgzU1ZBN0NtSmQwRFQ0YlRZ?=
 =?utf-8?B?T0RLb1E3d1NQYTJOYTNyb3B1Z1FNOEV3UTFpb2V0ZVU4czB6TkFTbnJ6a3FC?=
 =?utf-8?B?bXhzS1ZzWjFRYVFTL2pQaWgyenRxYTg1T1pSckhXRXBtM3M5eldIbGJTcm9v?=
 =?utf-8?B?aEVnbURHY1lLZmRaQjhNTDd0YXVQczByZ1RSM0srTHhhZEhiMmowRE0zSVFh?=
 =?utf-8?B?eVBsb0orcVdWSW9nUGZteG5TYmZ4SW9sWmkzT29IbzRnOW5YcGdBRnA1WEl3?=
 =?utf-8?B?cElKME1NZWdVOUtEYUsrNktKY3RPajJ4WFFaTDBXVUtIV0ZEc243UVo2YVFE?=
 =?utf-8?B?UkFTa1NJR0dOU2o2clM3dXRuV2M5N05oanAxN3hqbUVOR2xHa0lxQlVXVS9p?=
 =?utf-8?B?R0R4YmFTeEt0cTFwdSs5UktLd1JqNEliV3l5RXFFNkdSWGFJWGw5MEZsQWZW?=
 =?utf-8?B?QTkzS2J6ZGJTWEpUdmVGT1hpRldVRzlOQ1FCLzBNV2VZNzFmNW1VVjdvYXYy?=
 =?utf-8?B?V2R1ejFJL0RCWk1kMlVCbWpOMDZNM2ZadjR6S3VZMFpQanRHQmRBSDRIcWRN?=
 =?utf-8?B?UkxXTUNXaThLMUJIL1kzcXlkQklaNkk0VXYxSW5SaXNUVGkzL3k2alh2a1lV?=
 =?utf-8?B?a2NHM2E2NkNiWFVBWHZ0UHFKR1plTmlqWElWSGlMK3NDejVhN2dsSHNzWGhT?=
 =?utf-8?B?cTFFNGhORHRUZ1ZGSkxYS01ITkRHbVEwQ2J0bUlRUzM5Z1JYb3h6M3AySkNX?=
 =?utf-8?B?cWJlcXZpUmRTMDBCL2JqbkFhVTJJellmTUpEdEdsZTlYWWlQQ3dORG9DQmVZ?=
 =?utf-8?B?RFlwVU54RU1OajQ2Tm9lbW5uUlpvenZvR2JRZHJ5WE5RQXNqOFE0NC9YZFZi?=
 =?utf-8?Q?/ztnDIuVxCxaFe9swI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f287863-4c2e-4605-ebfc-08decf399e5c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2026 02:05:51.1475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PoBQUpt2+GtWgj0g2AROsceo/DYEYd6m0go2D0ebGbCDCWwSEtbhi/4l+a1GC2Zs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7599
X-Rspam-User: 
X-Stat-Signature: cw8que6ds4d4w1ueyxrz9a8pdgodj5h7
X-Rspamd-Queue-Id: D862220002
X-Rspamd-Server: rspam11
X-HE-Tag: 1782008429-631503
X-HE-Meta: U2FsdGVkX186IB6M+rzFIK1FRB488BMpy18+i0txRdW2XBDjkbKo7hJDxJ6IyHQ1UzuyPolnuJhaGIPfVl2QgQeblkB0adhxnwd63tutJhEIcj6JWWQOwgESnbjWB981vDWZ2HrfY072pr3SMfjwap9Tv64N0L2GA+V8CkVX6mnUVkOri5L70+deLEksVH6Ai1jfncTwayGkIeC4+9sKGJOQKUDFXidQgI0vfFqlTbHFmMMckX+2MlViRMlf3yg/+kJeX+EDn1S5rfGu4Pc/sJ8wiSgb+WFNFOjleTaaCFzv83+TLM8dxXAkMMB/ukU2uU6yvz09veO5uQgr9oBNPu85f2XwnwhfylbpEWbcst8U05Fn08Ae0Z7cT2FJkqD0UBAdWcTyDjug2xYDevfv4X/igKss2jL/eJOsgor3Ar9GpQt+GaSnBEphfbnbSHYVUGwf9T3PmZn33IWH69QdsWlaByFYeBZxGuWRAVnpnbSq9zUIe757MmUrnUbhj1oZqyul9ElbSLVyoz7XiUTFscryZzKcEdnyjN2WSspvV3wCfiq4HtV4+iL13TqxGXeL5+AzYKh7bEZZA75qePZq0Ra3pbp8uzU0ty9nwcjTQB0CLzXgsb7IA5vzEmOE6huQz4ygKB4uxK7q5FRQ/kTSFuVDnLuR2uTJCc5CPYapiRKL9SGDeScsL2FhOEMk2nrEd9/8Pjh7KwZLgBV/2WunbaYolqgUtlAu2tu1z+mBoyl7HBKzvAWZALxqYUBbwDFYUJIYN9WPqhnamfLq+CgxyNmgEE07iZ4PJMzzOdxl6jGKuHxRTiS+Yd6cH+UEE2JqHDsl5gXzEqik4Ykqnkg1pZXVYBFEVx+K/QUjQEFP02s1F4B6wa2nk2uWuSAwNAj7sZMZFH+MTqQSB0GBdPOhvaKfwUZnS9/djiqMOYJDUMCWCRODlFBJJ5M7Ee8ZPbroa1/c7Qo3xdS5UTpjPPQ
 oU817bjL
 0fR53HYvGA7QUuyEzhJjiLWzk3/Oqtfrc/Kq4N1PAvQJWgj2rTD7TAQjN7c9WdMpCvxhaZc7NT8Ks0veur/0j1ycWPdru3dr5Ap9kD1ZbWdSFTQLcDGxE01I9ilVl6k0edufpCX5KyRHJLFzmuyF4TU3d40iEeGibSENQNhmiam3LAlXrB0hSXM2k78FJjZD5ruqP18CWB7Xyd9buM86nFBdmMCSTs3VWJ+a5qVRE6bpWN6CnlUuwkjIayAgA+jKgmUifqU73DnKm19RN3zDrK7rRR7ljQ1M0ip88pqLz+sASpuKPti5NC2esCj1iaSAFt2JeJaeaGzDjQRj9QrB7b7aNH1T9NIRaA1e9nMhxj9uN5/nfixrF+oVxQD/VETtRgJ/GJgJd4gOzJtWZ5L1QXe5iyWIPXP9BvxN7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 18, 2026 at 7:35 AM EDT, Kefeng Wang wrote:
> Remove the last user of PageTransCompound() in ksm and
> get rid of PageTransCompound().
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
> v2:
> - use more folio in cmp_and_merge_page(), suggested by David
>
>  include/linux/page-flags.h | 14 --------------
>  mm/ksm.c                   | 17 +++++++++--------
>  2 files changed, 9 insertions(+), 22 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi



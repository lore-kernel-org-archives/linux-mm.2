Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9734F433D0
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 01:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F9E6B0005; Wed, 15 Apr 2026 21:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A9FE6B0088; Wed, 15 Apr 2026 21:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149FD6B0089; Wed, 15 Apr 2026 21:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F36D66B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 21:36:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6D01C25DC
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:36:48 +0000 (UTC)
X-FDA: 84662704896.08.78D01EB
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010036.outbound.protection.outlook.com [52.101.85.36])
	by imf24.hostedemail.com (Postfix) with ESMTP id 861B5180005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:36:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lrBN4hyh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776303406; a=rsa-sha256;
	cv=pass;
	b=6WQsgzJMJWtLYzWZTYyXMqY7QHjThimf8JaNxZGnht7CnT3nlWpYgfLS+SWwaw+0fpnGjA
	93qHOCiX2QT3yX5x3vli1YQEfocYWKp2bc7SpcpUa3yqc7hsDunahdUVzbXIwnluIxu7IF
	V6lxdU5bro7wVyPMg/q4743VBaunSqU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lrBN4hyh;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.36 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776303406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+S56gw7yiSToApxfLCbr+m2iCXuBGzxuLWAXptNmU0=;
	b=cgCsaeh3cwvDvyNSGPmSngk6jFFruU6a1ANY7hhRGVH6tEeAcGgdOiSMRuhoDUclgQwOUi
	l1TakFN+21Ra9fvnOplDTJMwXXDcY+U4Nr7nfPTwWJ+5Qq2wbbaw6pdqdoUI04dr1UYOV9
	GaxCioZ5KqqkWO9fGZB7BB40atD4xGM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JVTdtVTjoqHmRwXF+2sj89/iKGDta3yUPtN1VsS2UWG+HGxFgHCmuVjj74mSa456tQ2jKfF8UcpgCi0EsGS8du8ZWkCjrboRS/1QnrHFam4EtIsoKF/vfn09766pm/ysEf+UUaCMVjnHAo+haEjobMohv3Ehh7o5qkREU/EBfigREFEjDIrfIC35bhUuklFiIaz3lGxgd69UvA1yL5nf2GfULbrHlzYkZLLh5gCfwcderIEckkWYp9EycZDfmXeF+1j4dVwqvg+tChXESyREi0IMldDptG+jZ+mycfnT6aLMF2yMmEQvjfo9PKCEYtCfjI1JVqiF0JgfBYiiNoxaNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+S56gw7yiSToApxfLCbr+m2iCXuBGzxuLWAXptNmU0=;
 b=PzuwOsdNqfwg4RkME6i1sDOnXJ/4YSaCa6YXpSPAo2Z3xzS4F5brF/vcAnSx1P8q4v1fGx9LhleYXbOGfrdZFaQu3dNZ6c8+1Z5lA7bldd8pAn7znpW6Qkg6nwKZERLM8Cu+NQE+lvIdxCKuhqFlz/LwzTTqCkZhHYNW29moc9BY9UP3cdS7WpiIfhDoyHQBTDtsqkZm6f5Vddtv3ngZGy3/rNzKIwn7WCXX8YN2BruL4Zqf9a9WvzVKx9UE1n44oeXMUOdr8wQk+MN7CjFlSY7O2H3aVmd8KcnQRzU6oyhR2MPAafhC4/m7fvzwmMbcawXCrMyGKlYG9exK1rSNaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+S56gw7yiSToApxfLCbr+m2iCXuBGzxuLWAXptNmU0=;
 b=lrBN4hyhSMtVfOZk+MjgSCAQGgKvkk18cDsC4Nm4reDiL755OL1p5HYZDFTYvXd3IObek2zD+7UnS5Fybj5KZpogxRhHYyEMbekklKHhqzLQ71hKv+JagUb/YwzgolFUHajTqicNJ8kx8Mux94722eLPS+9atJHifQzavyInmAIFqOeGl55lDbfFz2fo37MoLKNGgtX3NmptMIKWkLKtYu1cH2cqs3PGZnL6KFSTwcHWnZKNWhzshf3OJo7eB2xY0NnL7v9SSHhw2rmRKxk99UrQz6LIxEqTLzk5LQQyD+nZOfrejCqZlcgUb+7sD8a2HH2c9+AcW2kPgEWl0Q3vYg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6585.namprd12.prod.outlook.com (2603:10b6:510:213::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Thu, 16 Apr
 2026 01:36:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 01:36:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, willy@infradead.org
Cc: akpm@linux-foundation.org, hughd@google.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: shmem: don't set large-order range for internal
 shmem mount
Date: Wed, 15 Apr 2026 21:36:32 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <4AD72E13-C4AE-4ADA-8AB2-DDB3CEE6A527@nvidia.com>
In-Reply-To: <16745f2b-b008-4df1-ac76-f18b4a826dbd@linux.alibaba.com>
References: <ef418d0f8c17a949952f1f023bef658041956ecd.1776241278.git.baolin.wang@linux.alibaba.com>
 <c5d0643f-1850-47a2-87ac-a249b2463bb4@kernel.org>
 <e07071fc-15b7-495f-b6d5-96004aa0f8b6@linux.alibaba.com>
 <c88ea567-6b03-4540-8173-7fceeac23f7d@kernel.org>
 <2d138a3f-0006-4a01-852a-4570d7ba781d@linux.alibaba.com>
 <eda13ed2-117a-488b-9120-d64e0fe0b731@kernel.org>
 <1a3cb6b2-94e0-4268-8cd9-1f9a9deb6c6b@linux.alibaba.com>
 <875dc63b-0cd2-49e5-8b0d-3fb062789813@kernel.org>
 <b3257e56-b202-40b4-94a8-0f4ba5e24cfd@linux.alibaba.com>
 <846B17B0-1BAF-4959-8FC2-42744C44B1D6@nvidia.com>
 <16745f2b-b008-4df1-ac76-f18b4a826dbd@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:208:335::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6585:EE_
X-MS-Office365-Filtering-Correlation-Id: 3881b5be-5268-44f3-0c0b-08de9b589898
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	K/EzMVOhyh5Lj3jQ9lOlTGad2unCQ1eivYE31DFCOLOE/XgSiG2K2GXVNxGbrTrpjMaiGJVIW3Ujekbc7MOdsNLIOS/xF5+OARKvvJnqNAfEgfWq5TOMZrQQ9MPMqLVMAimXXRkVGjrq5Vyv3xhDVrJYtaEYte3lLEphiHz9Owa6DWeC0cRRH8yaOBE2T9niGfJtiHj2a+bzF3JcApmnX7GaZ/eqMVkc7+oKO/zXkFyjyTy5cbvDF5yRnSXTw3jkGqC4jkHh8534WACuSKo7Iv6W4dHDs2k8U0toGzMzk82BFmDwml1VG13s+LVyXsSvyYOB9qjeRoaclKXeOLfPYIvg/ooArZ2rZVjRTWQOdBxsRVtqSEJmmE6ZQtGRT4qk9c4gNnUJge4i1CofLzBAhV3ZH+5pvTgtg9rUqMRI6nGbqBcjRDM9I059batj+WFtP6JnXJBtWE4DtcBC0Du/1cHfgpQtszvxCWk02kyJrRh+CC807KarvXDvVlCi1ryJfOen9eEvLWVQZA1orV7sCenzKNKErzVzcTRaQEme1mpB7bu3Ob/g0y6u1fcjz80j5KqVujBopIakigV+sqBr4JoSGtHXnJjygQbabEnX0BNSEHOlgOVQfXOMILl/eCiaLlMcMgJeh/QGY556HaRKXv7fipHqxHfCv0cTNOPl2QAfByY7+6BYr9B6NG15GUd9IiPJN0KWufs1z3C5/+byVOWZVvBoNnf0U+ku0AWndl4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVR1bGxib3AzbjJrWnJWWS92MFdwTDN0OGgvNVJYTWFDNFpuWEs5ckd0aGxB?=
 =?utf-8?B?ejVGR1FIZ1gwOEc5R2dzZlVRbmJROXRDTzNkTDF6RHBzcTc3d3ZYTGdQOWI4?=
 =?utf-8?B?WHBxUWxQOFd3ZVg5cWR3U0F3VGcrdFd3dGJMMlgyMmxnY2pFb0pReXBES2VX?=
 =?utf-8?B?Y2Z5WjZmNWxObm9kM0hRUnZZMWtFOUd1VVJmTjNnVXFpMU5FZFZEUXkwMEdQ?=
 =?utf-8?B?TEN3NW9HTkprZWlYQTczS3dYNE03d0ZuMy9JN1NFVGwyVHNvRms4ei9Md2Rm?=
 =?utf-8?B?K2srUGVsWGUrMS9QMjF2N0JkTkJmYXV6NTFzWk1lQkZYd3gwYVJ2NEZ6cVQ0?=
 =?utf-8?B?VUV2L25jQ1dGWngzM3YzMUpxZ0FjTzV3bDBiM0NqTThNZTljSmdKL0g4VkZT?=
 =?utf-8?B?b3VDRWdFb2FwUVVjWncyT0xhY2l2VDVyTGpvUkZpcUZUWXRvSkxHNU1zNGxC?=
 =?utf-8?B?U3ZlSERQRTVudGUyeHNsMDM4cVhiVHBLSHNJMGxQU0ZMbHg2YlcxN1lNWm9j?=
 =?utf-8?B?M2FiSElhajlkSjR1Z1Z6QzNOSGlwRG4rMytVbFgzYWJCUEc3Y3hXcVA0V0RC?=
 =?utf-8?B?MUNRMTdZeHZTQXpNeHlkNlRHMzdKQ2ptV1U5OWY0N054SWxrWjRmM0F6elAx?=
 =?utf-8?B?VDVwdC9uU2VLdHZuYkNmSHlOOXo1VVA3REJybWN2ZFQvTVJtMkUzdUJFbW0w?=
 =?utf-8?B?L0Z4S0VjYWVkdi80bWE0Z2RQTU1GeWlsOExCNWVTaWk2RncrdVE5V2VKMUh2?=
 =?utf-8?B?TVAzRzc1a1JFb1ppNEFhaG5vanRCVCt6KzdYUllqVmRKRTU0V0FVTC9qTTdI?=
 =?utf-8?B?MmhucFNMblBOS1UwYjQrNlkwMFlmQ0paNHZBZTBxMWRLKzhWUEhGclllZ1Vn?=
 =?utf-8?B?d0wwUnU5MXpTQThaQ3RSUjkrNVpOdHdGUy9EQnNBV2QyRVpYM05Qdy9McldW?=
 =?utf-8?B?eFNrVkFINDRaUStUVUdhNzdhd2NFQUwzV09QeDg0Mm4wSTNDam45Y2JxY3dZ?=
 =?utf-8?B?THlSMDlXc2tpN05SUXVocVY1QVVRbXBhdmd4UlptMnZhRGhLYmJoWnpQSTI0?=
 =?utf-8?B?aFRBT1NjcStxZW80M1ZOd1AwK1dQMVRONU0xeWlIRExJc1dabWhSWis3bVNK?=
 =?utf-8?B?T2lYS2FrU0lnRFFyOGdCKzJPT0tZQ0dadUJsN2RHUTUxdElWemZiWkI4RHFz?=
 =?utf-8?B?eXZZMHVVWnJPUTU4aHhLeUdDYjArS01vVEYxV1NQR1QwcWh4MCtJQm9lemps?=
 =?utf-8?B?Z1R4bDBxS3BiQmRTazNPY3RqOEY5RVlWVDhlNHJpeUJWR3JESjJERU9jSExR?=
 =?utf-8?B?QkRMS2VqVS85NTVZM2tBb2p6c2dhMjBDamlqcy9tdWo1RlRTWTFJa09iWnRx?=
 =?utf-8?B?NU16c0FQWUlLTWMxUDQ3RmZxZzBVdXJaejNiblRrYTY1TW0wamhVRUpKb3Ft?=
 =?utf-8?B?WnZaaVhyWi9DdjB0aVhPTDNpcDg1bUZRQngvVmJmL1k1OC8yeG93VFFqOUFo?=
 =?utf-8?B?ZVNOblN3ZDRlZzN0cW1nQkFGejNSaC84YUJ0ME1PaFlPWGc4UEJUbmRWTlhj?=
 =?utf-8?B?SlB5ZHFTU0FhS3c1VWUvTTJ3WWhsVDl2R1lCSnZLZGRYQUZyWEN0Y1pDakpH?=
 =?utf-8?B?T0hMbjVtWUFFN0xRWHp4czBNRnpiNnluanJMVTNlQnJ1N2FvV2FzdGZzV1RI?=
 =?utf-8?B?QzJwdnJhem5wck1aNG5PS1ZsaWJEc3pJRi9KQ3Flc2tqVzRYTWFscTBicllm?=
 =?utf-8?B?VU55dVdXSmxpYXBRRktQNjcrdk1hOHZZVmFFdWRrSWIyVnA2UG9pVGVGNTlQ?=
 =?utf-8?B?djl3cjlTYyt4TWoxUDVHSXNsNFdURnd5ZTRTK21QWWdRK2RUbHRkZFdaVUg5?=
 =?utf-8?B?a0dBeGFBTFUrYWoxaGtkVkJ6b2habXlRdUlLdit4dHFpM0x0Zk42RGJsM0tT?=
 =?utf-8?B?M2hrdWYvZDZqeGM0L0J0dWdXYU8wTi81cTkwV2NQNWMrTWxJekNNdFlhbTNp?=
 =?utf-8?B?ZUR2UGdGOWpod1p0c213TGtoU2l2VUJ4ck5oL1pCbGRaZWFqMnFTSTNHL0Vx?=
 =?utf-8?B?UFVWbkc3OERmWXZOUGtaSkMzUXVGVjZyWWpmVFA2R0ZIZldGaFdXdHFRNU5M?=
 =?utf-8?B?cDNBeW5iOUpRMlRKK2VGekFTd2lYSnRYY1Z3NUZqQ0xoOG9pb1NMOUxpeGlu?=
 =?utf-8?B?cUxLY2R3L1o0ODFKeGxFbUhrYUhCR1ZXYWZzRVhwUklKMEVMNDB3Zmo1aXNL?=
 =?utf-8?B?TFhRL0lOZUZ3QzlXM0oxQVZNL3ZuTERsN0ZNVk1QR0Z5dVpIcWpIdnJXRVZF?=
 =?utf-8?B?TjZVcERUWHl5a1NVbFA5T1daaVAzdmhHSWtHNjF5cEUvWTFJeTJsZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3881b5be-5268-44f3-0c0b-08de9b589898
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 01:36:35.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHEfJjdRzf9ngXbfd910RyHwrFa1d/1e8aJO/XTPKcgBunJPFNVV2gMBJHQ8G5rP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6585
X-Rspamd-Server: rspam10
X-Stat-Signature: f79kg8o4id78f93id7amcchosmcxxukj
X-Rspam-User: 
X-Rspamd-Queue-Id: 861B5180005
X-HE-Tag: 1776303403-817677
X-HE-Meta: U2FsdGVkX1+H0rznxjgW0CYy2oQbj0zqZnImeJAHtYGHPeyTqX09Mu6oi4t6VbWDoCH0yrNUHN/on/0Xi9Do2250swmvZbCTJYJlQFbeUXgirH0MqJWt6ZPYlQpLrs8WjHOzNNgCHAQXy7TpAFh4c5FcaPNFEE6r3Si/X+ITiiQGkgN1jNXlCkWDEe7IAM2veL+l6aN9OBcOvRiF1o5G3BkLDsz4Mp6eUXWP50F1/TuoHp61V6H02P8WCXn+LK2klW4pVcqwIW35mDX7CYCfewetIQHt873/ayzID/E20AfgbfBbF2MLGTc6XYngOgbIxib2/r/AWX4bAIUN+R4/TK813q2an/OYIvS/B4i4PYPREn4J3IbraFcgJuWDe5NrrxJbDL3MjQE5GpKiJ6l7PfUfFmeo/mXRLh7o9By31Xwa5+UwHSmOka9WvE88UkXP1mQlQfZy9YWBlW2DgQlLZyQy6OLdM3kq10BX3zRPBDW/xtkli6McZKjBSQhWR23co2Qgx1DSsZKAdgLk8Xg0JQXSB3TG/57AX8hgy667ZSeQbJEkU9SPYWJZN/pwZeAgEhzkAtxaLAQghOi6p9lTTgFjkF659z5y6soyaCjGwqaVVk7kBuz0MJw6uOZ7E6GImyYkaZATwr9GSE+gRZ3SNdWQaKafmTw3EMgVRazQ6sUodEkEplE2zhzJXeSN3juUFQLTSLWQ5U7uHCUgl2ltl4e+J0VToO5gydFN7FE67NufDGTC9elFSAd3qjQwhJgNOrplVrf3XtW9VaKAxJhtbIl9fVG+fVZoawrx7eCbMdlz7bssuG0BXNTkcTTnsQGP9kvz1HXl/l4IrvKPlr7dSYZZsIEyB5xJ1ZusS5Ulh0JTerrkDBeMOGMgo+pBWc9OIssva9VdbVG2bJ1VJyhOn/SdZEtF4lPv4vwnm2mc3I/jWBVjwtZcWBtqNWEZQZvwi/SXA/DdA2vQCpccEm4
 8mz24+h+
 5nGoFMgTQu1n4bjocRMItJIOtDsgNTBRPkuVqrTaUpc0iKwyq++2B+eR5KkhWzyAQAasW2xfVBlI1woGWmBalwjnOrcw/We3bmEpq/LwDOpcWr3+nSh9ZVUAAWNRZElxPR2lE9mtf9VHeo68Zec8SpqYl7Dfr/cnSn0An4GlxLw2FGolELtKj42hObovhYaDRF4QKHz2vdTGTO1oIFVmeYECeWOEhdrvxb+5T0Eqi6RbvfsIQM1F2I95I0YNW7l0JtBAe2XVKkOiv7Yx6ok0r61+awdhYPLoiP6Y+QUiwiQMsVErxw0uD2kArppX4nG0okdKpqmesPL5rNoJ1amDSHifSD2crIm8vSkVJEsrCejykJvEfdmGMUazeLHELVdQLO9NsFIshrb6mTfJU+veUA/OKrcni3Q41ScMn2d7fSEhaN6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15 Apr 2026, at 21:22, Baolin Wang wrote:

> On 4/16/26 9:11 AM, Zi Yan wrote:
>> On 15 Apr 2026, at 21:05, Baolin Wang wrote:
>>
>>> On 4/15/26 10:36 PM, David Hildenbrand (Arm) wrote:
>>>> On 4/15/26 12:05, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 4/15/26 5:54 PM, David Hildenbrand (Arm) wrote:
>>>>>>>
>>>>>>> Yes, that makes sense.
>>>>>>>
>>>>>>> However, it=E2=80=99s also possible that the mapping does not suppo=
rt large
>>>>>>> folios, yet anonymous shmem can still allocate large folios via the
>>>>>>> sysfs interfaces. That doesn't make sense, right?
>>>>>>
>>>>>> That's what I am saying: if there could be large folios in there, th=
en
>>>>>> let's tell the world.
>>>>>>
>>>>>> Getting in a scenario where the mapping claims to not support large
>>>>>> folios, but then we have large folios in there is inconsistent, not?
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>>
>>>>>>> For the current anonymous shmem (tmpfs is already clear, no questio=
ns),
>>>>>>> I don=E2=80=99t think there will be any "will never have/does never=
 allow"
>>>>>>> cases, because it can be changed dynamically via the sysfs interfac=
es.
>>>>>>
>>>>>> Right. It's about non-anon shmem with huge=3Doff.
>>>>>>
>>>>>>>
>>>>>>> If we still want that logic, then for anonymous shmem we can treat =
it as
>>>>>>> always "might have large folios".
>>>>>
>>>>> OK. To resolve the confusion about 1, the logic should be changed as
>>>>> follows. Does that make sense to you?
>>>>>
>>>>> if (sbinfo->huge || (sb->s_flags & SB_KERNMOUNT))
>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0mapping_set_large_folios(inode->i_mapping);
>>>>
>>>> I think that's better.
>>>
>>> Thanks for your valuable input.
>>>
>>> But has Willy says, maybe we can just
>>>> unconditionally set it and have it even simpler.
>>>
>>> However, for tmpfs mounts, we should still respect the 'huge=3D' mount =
option. See commit 5a90c155defa ("tmpfs: don't enable large folios if not s=
upported").
>>
>> Is it possible to get sbinfo->huge during tmpfs=E2=80=99s folio allocati=
on time, so that
>> even if all tmpfs has mapping_set_large_folios() but sbinfo->huge can st=
ill
>> decide whether huge page will be allocated for a tmpfs?
>
> Yes, of course. However, the issue isn=E2=80=99t whether tmpfs allows all=
ocating large folios.
>
> The problem commit 5a90c155defa tries to fix is that when tmpfs is mounte=
d with the 'huge=3Dnever' option, we will not allocate large folios for it.=
 Then when writing tmpfs files, generic_perform_write() will call mapping_m=
ax_folio_size() to get the chunk size and ends up with an order-9 size for =
writing tmpfs files. However, this tmpfs file is populated only with small =
folios, resulting in a performance regression.

IIUC, generic_perform_write() needs to use a small chunk if tmpfs denies hu=
ge.
It seems that Kefeng did that in the first try[1]. But willy suggested
the current fix.

I wonder if we should revisit Kefeng=E2=80=99s first version.

[1] https://lore.kernel.org/all/20240914140613.2334139-1-wangkefeng.wang@hu=
awei.com/

Best Regards,
Yan, Zi


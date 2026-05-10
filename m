Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA0EECD3427
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 15:04:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962D76B0088; Sun, 10 May 2026 11:04:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913906B008A; Sun, 10 May 2026 11:04:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB176B008C; Sun, 10 May 2026 11:04:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1F96B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 11:04:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9F821C11CE
	for <linux-mm@kvack.org>; Sun, 10 May 2026 15:04:13 +0000 (UTC)
X-FDA: 84751830786.18.842995D
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010001.outbound.protection.outlook.com [40.93.198.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2858100020
	for <linux-mm@kvack.org>; Sun, 10 May 2026 15:04:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=T3Ndsa4T;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.1 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778425451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+fIVG3qnuec4ARh1Nqb6CoK8+qXFgFh97AHHSEJUzc=;
	b=8pP4wGs09VQqGuQb2Fb7zaZUYWOiBO6keSLBsJBIzd3EGgwer8uprXwJHce7lIIfqg+F30
	ICfyZ6Zh6Ic+NRTSCttKxpmN88DV2wShwANq5uMAY6kbOTByRcfFKOwnvx9yreaQ1vyhzM
	mfMlaF+PaOJNSMr0BVL4Q2sKDoqbr1A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778425451; a=rsa-sha256;
	cv=pass;
	b=xdK+hTBvWICKKeAD0dogViXN217+dQaoDcRksk7dlAhM031HCmm0u3ZuPJfUDX/7p2TUF8
	aJdzonCqdWTyzhLLf6qzD/D0yL71m1N+9k7pw1sNS0vQovfzAEZE9mU4ReWNuWHYh7vsd7
	rc32zS/bC8qKL73Me6gAyFoH8CAjKSo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=T3Ndsa4T;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf14.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.1 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MwTcccdH+wAgQEcfW1OhmxbtguoTZJ3cfQLnt4UhtcKu9BPs4EjjaMnT9Di6UJ/Y8t3DGzioP2u6atKc6HMSd8qCX50JNEv48nZrIVyuVKrmsoNXMEETNys2huPfKDmMP+gvtmJFRndcaYmRKbTpRLNGwYxkslbzlxUsp+C+9NVAdRFaaG/wxzMBwAeMSnaC6LoLrq9zDMd21yeoVLWD4IhqNsyC2U3fuvoO+aluw+djdyN6HWTrEYoTBGuJO3LpsxXe5LZmUtPYHzMKv8+B9/l8sUv+p4pYN6H5rAV4P9LO61TJo4AiqzTrV6M0PtWMLGORGsvQx5+Fjd8JJhQtkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+fIVG3qnuec4ARh1Nqb6CoK8+qXFgFh97AHHSEJUzc=;
 b=W/06PbLgpgidGPm1NKeHYh0G5B47783800mlsOmyHaqwoV8C4kyIakxrIJsahFhS7OdPPZvfK2iOIpH70J+aQUheyhQVqb11CCTpDMA2wqIsQ8vLEw/f5vPupccNpoon/TYy0UhbpAPYs/MF00BacMElT+IWhlujgKL+ZG6wrYd91T1H4jqy6lJpUrAmSIrVJSg+c9CoUbM5OWYdQv3iGtth0RMejd7XWElGLz6hXxjEyuBDMeLES5I8RQgaJdKOlzBT2wYX9rNH5TuxB7naLnewBxknfqMS4jWOvL3Yt6/gqZOx4+YavNbbIRWjbBwKFe6szORG65GuFLCChzzlyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+fIVG3qnuec4ARh1Nqb6CoK8+qXFgFh97AHHSEJUzc=;
 b=T3Ndsa4TV4cbrXMPBOvMpj4QPcC79XBsqksrXLwG4HpK4pcvI57IDfdZdGINMnUernaoNJwuabY5Nj1wR2YbYKYMWCf1O8HwsZT/ifDNcXewTEzLdsb9IiKEsY88m390tO3A+AHGoHQOE6uN8JddVJiyOduY44Mb+NbiMWt7PCc=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CH2PR12MB4184.namprd12.prod.outlook.com (2603:10b6:610:a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.22; Sun, 10 May
 2026 15:04:02 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%4]) with mapi id 15.20.9891.021; Sun, 10 May 2026
 15:04:02 +0000
Message-ID: <22157c87-1465-46de-8e1c-5d99a90152a6@amd.com>
Date: Sun, 10 May 2026 20:33:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kinseyho@google.com,
 weixugc@google.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, willy@infradead.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, apopple@nvidia.com, dave@stgolabs.net,
 Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
 bharata@amd.com, sj@kernel.org, rientjes@google.com, xuezhengchu@huawei.com,
 yiannis@zptcorp.com, dave.hansen@intel.com, hannes@cmpxchg.org,
 jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, jic23@kernel.org, aneesh.kumar@kernel.org,
 nathan.lynch@amd.com, Frank.li@nxp.com, djbw@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260428155043.39251-2-shivankg@amd.com>
 <87zf2kvnqy.fsf@DESKTOP-5N7EMDA>
 <152b9b5d-67c8-4a13-b8a8-be576a16eb8f@amd.com>
 <87mryaqgwg.fsf@DESKTOP-5N7EMDA>
 <c4d00222-5caf-47bf-801c-ae1dd439ad0f@amd.com>
 <87cxz5rpi3.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <87cxz5rpi3.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5PR01CA0180.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1a9::6) To BN9PR12MB5259.namprd12.prod.outlook.com
 (2603:10b6:408:100::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN9PR12MB5259:EE_|CH2PR12MB4184:EE_
X-MS-Office365-Filtering-Correlation-Id: b9f763ad-69cc-4fe6-7659-08deaea55f46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	MD6Y7dme01WtoH0DiSgvzySTDXwN/FuPvcFmSTiDxCozItnkcukff1vCH+wNyIVu4OOXlPerJa1b0QoYMK/3YUJF1CI7llIMaVVY89tO06uabjgShndrqJs1Thf+n/kwTktC310LF62e2N5j1U5wfdYLeQABPKt6JwNr/nhCg1VRwCS/5mkyZe3tldCEF7ej9pPWUyBbt0jmTgim8nJdkRPAXw6ZiWxmn3CJexJB6M4eGAdZK7Q+i8k970kvR3VgMmsciw6DFNKJ6AouQ9quZC84eSVNSBJlBawY3jQobHGiSgrAaaYQd2OsjCYEzDVpJkPmTDftb77gaZ+pTXBsPkfYkmFD/lVdHaVI9M6A3YOPFjb5zsBvl/engtDNRh0NnUhvPHfLTZf3GbL++A7eeHO0fZt2v+6QbbXgENaXmMx6n1G1qNkqjiQWAmsLSxJ+rIj+GXXk1NxZnjawYNPZoY7yyIQBVrkneqL/4PG0fHEosJO4C8tphNrZILIg33pb9EDWygeY4GSjXugAnfuhIOicy0c1+1oWH/Ajl7jYjSeThiN3c5fhuJKgFftH+5yO8797iivOtIDYaQUyklBp9PTM+WmJRN/rCvxE+65g9SxqNNc47xgibrMntWfP9wJPHQJb23lKMBbZZvTkL8OyWxZexElqlkxXPCT59RDufU/w8AwzdEQeVPwaE6FE7j6/+j6CJn8G+LYLNxx5EdAnCQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZnJCWlNSVkRVci84bUViRTNtRTlvbnhEQzIvb1h5Z0V1SVVTNjNxY1VNTWx1?=
 =?utf-8?B?TWxTeEF3TmxaY096TjRYMUtmd1lYeXp0WWFCY0hOVk01T0JYRm1WQ0Z5eG5v?=
 =?utf-8?B?dlVOdkJDQ1pjRW0yNTNnWjYybTUrMGR5MzBvbjFTbXYwbFpISVpxMzdwOHFL?=
 =?utf-8?B?UDZmS0lsUnQyS241SnNqR3BvTFBzZVEvTXU1U0RuWnR6WWUxaWcvbi96a1ZC?=
 =?utf-8?B?bDJNbVlkS25MbmZBeHExeWhuekM1REZpa0xjOVlIcmdqN0lwc3dwOVJpaWRt?=
 =?utf-8?B?MVZHR1RvOHRHU1NiODc3ZDJiVFdDQWNnTmRuQytwNmRGOUUxVVhhZnZweGFK?=
 =?utf-8?B?NW1rUjZOOEEvbW12M0VMbkVkTmpXQlF2R0x1MDFad2ZnSHgyampRU3MycWZL?=
 =?utf-8?B?V25WUXpFRk1GMWcxY092WG1zVUNIcGZncFUxTFliRk0zdUc0eHl0ZzcxT0p5?=
 =?utf-8?B?L2RCODNhMG51blZ5M1dGcXVFVGJudVhQck54WmpGbzljMTQrLzhjeWd6VG9O?=
 =?utf-8?B?d1FjZ0JvbTFqMWRLSktWbHA4ZUJ6Z1hvYk9mL1EyVVNoOXRMNDlFM0kzSjd0?=
 =?utf-8?B?UE8xUHoyUjkwM3I1M1pxS05JTWJhQ29YcUpWZHY0TjQzcVc3K1E2Q1Q4RWlI?=
 =?utf-8?B?Vm5ZWnhNSmZpVkRBL29XOFFXQ3hBTFdmdmVGbldISFlTaGYyaFRPcVdVaHAw?=
 =?utf-8?B?WXZRUTZQR2pBejNPUnZOeTQ4eHhZZmQ2MEhpS3MwOUw1aFJTaGFNTnR4U0Ju?=
 =?utf-8?B?bWxVSkoxUjlMQjlnSnhRYlpJOU5NTTkvMzIyTERzeXpjWVk5YlN0L2hmeUpa?=
 =?utf-8?B?T2hqL2NyQjB0aU9RamR1VWcrSVJHT3RXZStiZjVvZm00dFkwVktvRGZ4R25l?=
 =?utf-8?B?N0J2UnZ0VGpyTGQxU2tMMHVSNGJXS2dhbVpWZzlFNUhzQTAxTWI2bW51aXhu?=
 =?utf-8?B?M0E3dlZ6WEF4b2lnbnRoRlVGRTJYRk9TeThFY0Z3YkVhOGVydXVsczIwVnRM?=
 =?utf-8?B?aGdoc0wvUlhhMmVVMlV3cXh1aTl6N0lhQ21Bc0tlZjNuaU8zU3dKMFU1b0tX?=
 =?utf-8?B?aURqaEZyS1NxaG1VZmNiRmhYYnpxQ2d0bVA5ZWxzcG1XcW9saU5zbDh5eTdv?=
 =?utf-8?B?dTNGMWQ1VzNMUkhNK0V6ei9oVkg2eE81MGkxOTNBYWkyZjU5dy9tWEE2OGlt?=
 =?utf-8?B?ZGJEWm0rbGRxc2V3LzlYRkZZdnNuYlNzZEJBa1p6UWZyYzM4SW1RV3c2d0Ra?=
 =?utf-8?B?NWQrblhtdEwvaDZzYWY5ajJralQ5bTM4dlVPMUx0UDFHWjBvMDR5ajVIcFRr?=
 =?utf-8?B?QmsxUCt5Z25kYXRiMUVscEtqY1EybWxyR3pEWTk2emZBTFROd0d2U3FmTUly?=
 =?utf-8?B?Wk1tT2Q3WnQwa3owTys4bnY1VDd6NDdhakFqNE9QQVZsRzlXMFFDdktRaklB?=
 =?utf-8?B?VCt0NzFnZnI5a2dTcFBKVW5Kc3lUdWVzRTFHd3QxVzhPcWtjOFVIMTVuUHgz?=
 =?utf-8?B?eENJU2hILy8xYjQwbTZ0SGhFS04xZDRUeW5mdW42TmgyKytsdGdKTFBEdkpM?=
 =?utf-8?B?T2FMVEFnNGU0VFBhWndxSGhodDY1eHc5eWpKL1NkLzBjMENxQnBHZnltTGtS?=
 =?utf-8?B?TURWczlZVjBFR25kQkFtN2RqUmdZMVlIT2I1bXJQL0FYdzYvK25ETnJMOXZW?=
 =?utf-8?B?NTlRalk4M1BCYklWbzYyRUttMU44T0F0UktnTW9HbTFiN3R3cHZQaGFxdEJa?=
 =?utf-8?B?Wko1U3RBM3h0eEw2endGSDhBb1BQTW1vcFJqT2lHZjBHMDFIWHFMZ1hlWi95?=
 =?utf-8?B?U2t2MU42dUs4K1BGM2xtUjRuYk1hZCt3V2NJd0JlTlBDQzJNYWpFc3NEWnJu?=
 =?utf-8?B?anFYenF1N0RUQWZDamJDaGlmVERjREtBV1BzMlpkaUJsTzBzVE1Zb2JMdlpm?=
 =?utf-8?B?QS9hWUpGTkhPaUhtYXZxcndaS3A3MWFjWkdHQ3lsb3hiOVN4UXpNNS93Yk92?=
 =?utf-8?B?Yk92bWtsRnI2cStyMnJqYlBrc0NnQm4rcGtHL2NPTFJuOHVZWE5qWVoxSW5q?=
 =?utf-8?B?TFovVFY0cG9BSWp0aWRVQk44OG9jTEhLYXBtcnJVS1lTZ25XYnZZUmtqa1BY?=
 =?utf-8?B?dlVHVHRncHM0UGljUU9HNTdKTzNjUTg5NFIxOG5qbHZtUzI0T3FwY05CWjQz?=
 =?utf-8?B?WXBDQUxCY01qWm9sM0laaWtzbEROSTFQdnZEQkk5NjZleDNoZjVEZ00rcXU4?=
 =?utf-8?B?bXFya2IzckgyOFpEWC9QUzBiYXQwUXRCa0tUTWtaYXNhV0FjVFNna0lqNElX?=
 =?utf-8?B?bXhoa0JkZ1VPNGVBV3NrTk1DTUxWUjQrMmMvbnQ0TDVaMkd4OEVmQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9f763ad-69cc-4fe6-7659-08deaea55f46
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2026 15:04:02.5842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfxLkAqTbmF2pvpUkmjXy+HZu1pDcnO9a+qjK3gg2we00cdUxk9GytRXEO2ALXetZAzQvfUjn6SJqjsCi7wLbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4184
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2858100020
X-Stat-Signature: jdfptud3ner7agjpijfz4zkwc4pobepa
X-Rspam-User: 
X-HE-Tag: 1778425450-623489
X-HE-Meta: U2FsdGVkX18Bs/foidbM4TzjScYsd5o4PBFK4ro0PzQJ8mB95hpC8sYspjcCE6FYE7UsMvnzj19PHnMOdrxX7gozWze3s356w6g2kHZg5FpaxJG36BVzl//vsNIuaXscuiNXPuq4MziNWtVPglSS52LbEXNNO22D5Fleefz2bU+DinEfj3oxh95U5msBBiJWEYSWZW9HQvmGgLeGDs/nss5J06BkLwGZcVA0t5Jax0f/DBqxKV59bZk5uNrhguUl+Tb6fm7F8lXrVLx2Gdwfvm0I+JaTPhvFAREGvd6cS0VupwV7SMKTEIzMpU/9RZ6qQZzwFHqOIkHWdo43qOgEnlh3ny0JxTjVSikrxmcBTiOhIlFaJu8pYDY4dTesEKQZk1Mxio238+oEvSnPFc16tBzeyT1RObI3i4/9B+0Iz90mF6q5RWvl8mIm3qk2wWvnoPlEVha+mQg+wliN9LctZFdDdVSYE1jNiwxIM8lkG1re+ZuO2u071T25wAGfHc6Hk1vyr/qYSBWKdeRReq0rtf9p8B7iHQE85eQEhNsnp9CgriK/Wd0GxhKADL0Eut09dY7vJk1jV3gxsVswUXsAnyTYM6gcwH067Tr/0LCuPfKNauX6jJmpd/t0pvOv3jhHm+XqZYx2DB/im8gCs+UrlXzY5h5wLZPI+zOfI6XkiyDTslB8CZ0blyC9csDTmcGUC47C2V6ra8ctp3kaYSiYVgWOZXsj0JwJ8eYqXvIoMUC0m6QmTLr4ECGeuc1eW+t8mv7/i9mSpz/hyRGOuJpckBvo59UxMXzMRtKRdyuo08jJBNDKmUWPRkpnKQ7mGwazNr48jxWOuCTfQkGDdQ+H3jZIVW5aoUzWMRoqKSrWRRvAVW0r4C3s9yrd9N2mwS/wqcIVdMc1JVQKcknheo8uibKYWMu21cxKWzWWPM5jDVEkd4JhP0fJBFsLP4VEN3M/J27NwMy8XcWoKzzFpxO
 QibqPhki
 /fp1DutQWRFpu0m+F3+6i/t02SndluW3xjCIC0VndBBxBOwmsmX42Okc0IqKrd8N6bLN6FOCrx5yhOkASAAXB5QwBTFnWP6g1G/ar4fJIHN2nepT3fhKyio/q6aRrYw0gz2BzQr4EFMH5p8ZA9mawuZ7e+W+HalhHiyvsbPJzYmE74MEIZAKpc0y1ik/5HeeXvhuFYat4ifp5DII9oZXpucICkgWAUV8FWYpz2rC5kxYYOteG6uZl4XpqDhuKPrvLkot2BVzxz+LwURGm3oiPboyXt+uWdbd1uixpe76rRRU41nVqxYol6ksQ+Nc+789SfvKMc3LxfKgyPLiIHN4v5ARFSo/MIt5VSSJVM2Zs9wdvWUj0j+rxU16kClHrgBE1jVZ99Nc619wI06k51ZWFZ64uLnRT+MrN5GPHpHN2kB8fcFJ319Jd+ypC24daBNX11TN+aNzb0+zPahLOxqkXyY2prLTVHMR8PYtO96z0YN0VPHlNWEOiLFVV+055P/1rx5NFOkgn84ThgJQLY1PFVueVQUpiy+nF3V+VB3UwOiw6dpA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/9/2026 1:19 PM, Huang, Ying wrote:
> "Garg, Shivank" <shivankg@amd.com> writes:
> 
>> On 5/8/2026 4:58 PM, Huang, Ying wrote:
>>> Hi, Shivank,
>>>
>>> "Garg, Shivank" <shivankg@amd.com> writes:
>>>
>>>> On 4/30/2026 2:17 PM, Huang, Ying wrote:
>>>>> Shivank Garg <shivankg@amd.com> writes:
>>>>
>>>>>> PERFORMANCE RESULTS:
>>>>>> --------------------
>>>>>>
>>>>>> Re-ran the V4 workload on v7.1-rc1 with this series; relative
>>>>>> speedups match V4 (~6x for 2MB folios at 16 DMA channels). No design
>>>>>> change in V5 alters this picture; please refer to the V4 cover letter
>>>>>> for the throughput tables [1].
>>>>>
>>>>> IMHO, it's better to copy performance data here.
>>>>>
>>>>> In addition to the performance benefit, I want to know the downside as
>>>>> well.  For example, the migration latency of the first folio may be
>>>>> longer.  If so, by how much?  Can you measure the batch number vs. total
>>>>> migration time (benefit) and first folio migration time (downside)?
>>>>> That can be used to determine the optimal batch number.
>>>>>
>>>>
>>>> System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
>>>> 1 NUMA node per socket, v7.1-rc1, DVFS set to Performance, PTDMA hardware.
>>>>
>>>> Benchmark: move_pages() syscall to move pages between two NUMA nodes.
>>>>
>>>> 1). Moving different sized folios such that total transfer size is constant
>>>> (1GB), with different number of DMA channels. Throughput in GB/s.
>>>>
>>>> a. Baseline (vanilla kernel, single-threaded, serial folio_copy):
>>>>
>>>> ================================================================================
>>>> 4K          | 16K        | 64K        | 256K       | 1M          | 2M          |
>>>> ================================================================================
>>>> 3.31±0.18   | 5.61±0.07  | 6.66±0.03  | 7.01±0.03  | 7.13±0.08   | 11.02±0.17  |
>>>>
>>>>
>>>> b. DMA offload (Patched Kernel, dcbm driver, N DMA channels):
>>>>
>>>> ============================================================================================
>>>> N channel| 4K        | 16K         | 64K         | 256K        | 1M          | 2M          |
>>>> ============================================================================================
>>>> 1      | 2.16±0.14   | 2.58±0.02   | 3.00±0.04   | 4.56±0.28   | 4.62±0.02   | 12.65±0.08  |
>>>> 2      | 2.68±0.09   | 3.69±0.15   | 4.52±0.04   | 6.75±0.06   | 7.19±0.19   | 14.38±0.06  |
>>>> 4      | 3.07±0.13   | 4.62±0.09   | 6.47±0.56   | 9.22±0.15   | 10.24±0.47  | 27.01±0.11  |
>>>> 8      | 3.43±0.09   | 5.40±0.16   | 7.67±0.08   | 11.25±0.17  | 12.60±0.60  | 45.62±0.52  |
>>>> 12     | 3.50±0.11   | 5.66±0.16   | 8.12±0.10   | 11.97±0.19  | 13.43±0.08  | 61.02±0.92  |
>>>> 16     | 3.54±0.12   | 5.79±0.14   | 8.50±0.13   | 12.59±0.15  | 17.21±6.40  | 65.23±1.70  |
>>>>
>>>>
>>>> 2).  First-folio latency: Instrumented with custom tracepoints to
>>>> measure latency per migrate_pages_batch() call.
>>>>     Result: throughput (GB/s) and first-folio latency (in microseconds), median of 10 runs.
>>>
>>> Thanks for detailed data.  Per my understanding, the run time of
>>> migrate_pages_batch() may be not good enough for measuring first folio
>>> latency.  IIUC, the migration procedure is something like,
>>>
>>>   for each folio
>>>         unmap
>>>   flush
>>>   for each folio
>>>         copy
>>>         remap ===> first folio migrated
>>>
>>> Some tracepoint should be better to measure it.
>>
>> Sorry, my earlier write-up was unclear.
>> For first folio latency, I add two tracepoints: one at the start of migrate_pages_batch()
>> and one in migrate_folio_done(). 
>>
>> I agree that the user-accessible point tracepoint should be right after remove_migration_ptes().
>> Though, migrate_folio_done() runs only a few operations later, and will have a constant
>> offset, so it's unlikely to change the shape of the trade-off curve.
>> I'll move the tracepoint right after remove_migration_ptes() for new posting.
> 
> Thanks for explanation.  Trace point in migrate_folio_done() should be OK.
> 
>>>
>>>> A). Vanilla Kernel:
>>>>
>>>> Here, n = workload size passed to move_pages() in folios. Move n number of folios with move_pages().
>>>> NR_MAX_BATCHED_MIGRATION is upstream default value 512.
>>>>
>>>> --- Order 0 (4K folios) ---
>>>>      n      vanilla/cpu
>>>> (folios)    GB/s | first(us)
>>>> --------------------------
>>>>      1       0.04 |     24
>>>>      4       0.16 |     25
>>>>      8       0.29 |     31
>>>>     16       0.54 |     27
>>>>     64       1.15 |     68
>>>>    256       1.86 |    162
>>>>    512       2.21 |    264
>>>>   2048       2.62 |    208
>>>>   4096       2.74 |    182
>>>>  16384       2.73 |    173
>>>>  65536       3.28 |    166
>>>> 262144       3.20 |    167
>>>>
>>>> --- Order 9 (2M folios) ---
>>>>      n      vanilla/cpu
>>>> (folios)    GB/s | first(us)
>>>> --------------------------
>>>>      1       7.05 |    194
>>>>      4       8.78 |    186
>>>>      8       8.47 |    188
>>>>     16       7.20 |    193
>>>>     64       8.23 |    191
>>>>    256      10.51 |    180
>>>>    512      10.88 |    173
>>>>
>>>> Takeaway:
>>>> In each migrate_pages_batch() call, folios are first unmapped, then try_to_unmap_flush(),
>>>> and only then folios enter move_to_new_folio(). So first-folio latency is bounded by the
>>>> per-batch unmap+flush cost, and then plateaus once workload is large enough.
>>>>
>>>>
>>>> B). Patched kernel:
>>>>
>>>> Here, N = NR_MAX_BATCHED_MIGRATION (in page). Total migrated data is fixed at 1 GB.
>>>
>>> Emm, so NR_MAX_BATCHED_MIGRATION could be very large?  I think that it
>>> needs to be bounded.  If it is too large, too many pages may be in an
>>> inaccessible state for a longer time.  That will hurt the workload
>>> performance, although it is optimal for migration performance.
>>>
>>
>> Agreed, it must be bounded.
> 
> Thanks!  Could you retest with bounded NR_MAX_BATCHED_MIGRATION.  If the
> upstream default doesn't work well for you.  We can find a better one
> that balances throughput and latency well.
> 

Thanks. Below tables sweep NR_MAX_BATCHED_MIGRATION from 512 up to 262144. On 2M folios,
16-channel PTDMA, the knee is at N=8192-16384 (= {16 to 32} * 512 ).

>>>>   8192         12.56 |   2424        26.57 |   1118        58.72 |    470 *

One thing worth flagging on the "bounded default": at the upstream cap of 512 pages,
migrate_pages_batch() receives at most one 2M folio per call, so PTDMA can only use
one of its 16 channels per batch and the offload reduces to vanilla. (DCBM offloads
one 2M folio to each channel).
The larger-N rows are what exercise the channel parallelism for PTDMA case.

"SDXI"[1] like memory-to-memory data movers should reach good throughput with just 1 channel, 
and thus may not require increasing the NR_MAX_BATCHED_MIGRATION for good throughput.

I'm not tying series this to specific perf default for now, the design review (batch-copy
path, migrator interface, registration, static_call dispatch) is the part I'd like to converge
on first, then tune the threshold after it. Does that ordering work?

[1] https://lore.kernel.org/all/20260410-sdxi-base-v1-0-1d184cb5c60a@amd.com

Best regards,
Shivank

>>>> Change N with a knob to measure impact of different max batched size.
>>>>
>>>> --- ORDER 0 (4K folios) ---
>>>>      N         offload/dma1          offload/dma4          offload/dma16
>>>>                GB/s | first(us)      GB/s | first(us)      GB/s | first(us)
>>>> ------------------------------------------------------------------------
>>>>    512         2.13 |    639         3.23 |    290         3.27 |    253
>>>>   1024         2.17 |   1261         3.44 |    582         3.58 |    536
>>>>   2048         2.01 |   2769         3.09 |   1360         3.45 |   1083
>>>>   4096         2.10 |   5059         3.13 |   2737         3.58 |   2115 
>>>>   8192         2.21 |   9320         3.17 |   5015         3.75 |   3617 
>>>>  16384         2.15 |  18689         3.31 |   9623         3.87 |   6937
>>>>  32768         2.12 |  42692         3.38 |  18893         3.83 |  14255
>>>>  65536         2.09 |  81956         3.38 |  38556         3.64 |  29003
>>>> 131072         2.02 | 169563         3.22 |  81082         3.63 |  62236
>>>> 262144         2.21 | 318424         3.12 | 170174         3.50 | 129413
>>>>
>>>> --- ORDER 9 (2M folios) ---
>>>>      N         offload/dma1          offload/dma4          offload/dma16
>>>>                GB/s | first(us)      GB/s | first(us)      GB/s | first(us)
>>>> -------------------------------------------------------------------------
>>>>    512         11.66 |    160        11.68 |    160        11.65 |    160
>>>>   1024         12.16 |    310        13.67 |    275        13.64 |    276
>>>>   2048         12.30 |    613        25.47 |    290        25.48 |    291
>>>>   4096         12.48 |   1215        26.19 |    566        42.59 |    335
>>>>   8192         12.56 |   2424        26.57 |   1118        58.72 |    470 *
>>>>  16384         12.61 |   4839        26.77 |   2218        61.94 |    896
>>>>  32768         12.60 |   9667        26.98 |   4422        63.75 |   1748
>>>>  65536         12.63 |  19318        26.99 |   8838        60.66 |   3543
>>>> 131072         12.64 |  38935        27.02 |  17935        61.06 |   7178
>>>> 262144         12.66 |  77694        26.85 |  35871        65.06 |  14129
>>>>
>>>> In the batch-copy offload approach, DMA copy phase is inserted between unmap/flush and move,
>>>> So larger N increases first-folio wall clock latency. Throughput improves but with diminishing
>>>> returns.
>>>>
>>>> For DCBM+PTDMA setup, the optimal batch for 2M folios sits around N=8192-16384,
>>>> because a larger batch allows the driver to distribute more folios across available DMA channels.
>>>> This is where we get most throughput while keeping the first folio latency in check.
>>>>
>>>> This optimal batch value is hardware-specific. Other engines (eg. SDXI) and memory tier (eg. CXL)
>>>> will likely have different curves.
>>>>
>>>> Does this approach and experiment look good to you?
> 
> ---
> Best Regards,
> Huang, Ying



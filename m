Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2124DC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1901B6B0287; Thu, 13 Aug 2026 10:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1406A6B0292; Thu, 13 Aug 2026 10:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02EE06B0297; Thu, 13 Aug 2026 10:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE79A6B0287
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:22:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 380FE80183
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:22:20 +0000 (UTC)
X-FDA: 85096461240.28.ABF4378
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013020.outbound.protection.outlook.com [40.93.196.20])
	by imf12.hostedemail.com (Postfix) with ESMTP id A9D9940005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:22:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DN+cRvJL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786630936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ox8dHiqJPvi2Aiw3gwuzWJ5/RyisvlI4ubogmjJXEzU=;
	b=ht5qHf30Wkysdk2DJ8+NJv18IiuYBs4/4nEoCTXBF1Ys+2k/dPFQumPpYc55tOrqpI17UC
	1S8ss+Aiyo/2G4cVA4yb0fGtcLkNu9VvPzNEdebIAxUXkIfrn4LYzLvqMOnO2m07I+6FTb
	Das6tNMYCmhk8677hlUzAvtqy/95ozQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DN+cRvJL;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786630936;
	b=IrM0rslnMfdYcbNM+AdakWtnBzE79f0LKhXiTQZWXbBG1amTCpWsMwsbY0dUV5q39kge8N
	i3YEgHIe8puL7GfyPghVc7vKE57i69SX7BGMWS/dOFGheLZ/5sHKxwriAkJsxuPtWfZ5e3
	uxo8RkaBgPOlbztiEHJRPWIdr/Tyl10=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NSplDDyXhznG19zw6SQ/UdIDT7tq9aPO0FeYqxk4gLh5DYSFc1x+RtOyczBs0fVxT2A0jaQ7fnpR6mGxhrL5KH9CY+i26Z7EY6UeBXJAdtLHR1X4gvk9D4L1PWpy0wcwsxlfTpb6X5SpcyYkHRl1SxFLE17RA3Hh2pAUSL995D8HN1ZviOxpfpSjco4mHf6UWP3E6u1S+sW1HyVDpD5bJo8Gin2rh0y1LF3pvqokY2d8eEo96tLeFJoAIKZQazl3B7MYX1xt432qmCEROebwdZTeWgAVaudnMHXvMglvdf70BEm0xbfldwlNScpY/3VljfyaHVs5knbW3JxJW33xTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ox8dHiqJPvi2Aiw3gwuzWJ5/RyisvlI4ubogmjJXEzU=;
 b=yhCJ3EOTLRqvkaVjBDT8YDA/LHW/qakclT9mCQwjkkM24QgypKsErS+yhFXvdWqWqzMK+sMwteKnhbUMRdcwjIBHAwtaunyUjb0ogV8MitdPTOwnTWfM7oFMP42SbfQn7vgimdF2cc5OSijFflc8l/u4W951u/lWl6802iqeweyRxeagtVhfSYEFHICC0kSy81aR5TAeRMi84j319pzov+b14ReHkTPHXZ8grJgmAiUBqBScQDV46MVpfiX/hv3KgXceDQ0I4ffo0AsMRFIdmrBA2Q0n/fF8S9hMyXYi0NN48aLKJCGwBfpSK7wANHj900/4CT6Zmrh9bVfFCYE5nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ox8dHiqJPvi2Aiw3gwuzWJ5/RyisvlI4ubogmjJXEzU=;
 b=DN+cRvJLXMS7Van3sJXYiyIQMiwFLHLnhOnSfvvADdXlZlsoiseDSHkcTyTZOH1M17gqvUh648eGb87/y1wjOaTL0//zbSup1hzR5d6AozCija7tWytkeDjReyfvsYAU5iEGwnSxKdrj+lijmz0e6q5B+7RJ1lw+KoDW5TIdd2skbsyLxx4tngWEMsr4PIjCTqmEdH4Uqk716G2aA5SGn+AB9m1fiwijCnXHRbhl3waarI9gwvOIrGq2zO1C/VN25MHhNtpOIqi/aNfdt65HNEWcPSKRzIxYudrJgg0Ae3cSa1oxBt3CBu2wcfyD43Esddm/LK4opRExoshVCZifsw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB9053.namprd12.prod.outlook.com (2603:10b6:930:37::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Thu, 13 Aug
 2026 14:22:11 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 14:22:10 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 10:22:02 -0400
Message-Id: <DKNVSYUMTUPT.34RYOEAV9L76D@nvidia.com>
To: "Xie Yuanbin" <xieyuanbin1@huawei.com>, <akpm@linux-foundation.org>,
 <david@kernel.org>, <linmiaohe@huawei.com>, <matthew.brost@intel.com>,
 <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
 <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
 <nao.horiguchi@gmail.com>, <ljs@kernel.org>, <liam@infradead.org>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <gourry@gourry.net>, <tony.luck@intel.com>,
 <bp@alien8.de>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2] mm/Kconfig: make MEMORY_FAILURE select MIGRATION
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <liaohua4@huawei.com>, <lilinjie8@huawei.com>
X-Mailer: aerc 0.21.0
References: <20260813134916.292733-1-xieyuanbin1@huawei.com>
In-Reply-To: <20260813134916.292733-1-xieyuanbin1@huawei.com>
X-ClientProxiedBy: LV3P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB9053:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b5d4354-cf08-472c-a0b4-08def9464362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|921020|6133799003|22082099003|18002099003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	aVOEgFEijX7GT/C9ULAUTqJvXueog8qgRVczWPmizdXq0v+rQLn5QMnT3sOOn8sL+w3YpMZbFFAAAHv1h+naZImcSCUfFCEJHzuifvoMVObAzTetNZHjk1tjEuGaqQhkke3fn2PsCdxlYAVSIoAVymbB3Y8nRU635QYvY+3bu0JcW8eQQ2WC3hJpdiCCF1JMd9b+VFNwbYgCCsCuRMwCvny+R7AEJ61JyOOC6vVCctJIQ1jE3yo3ehzuy7y1NSjD7wjMZR3GH8/93GbJfSYxSjNITDEfIqE8xPIr0htSYeFzT/NtBq7H0kXyVBJUlnDU/WQeB24ampJ+mGBcpUqotRshgChb9kB+8JQmsCQXLKZydk7MyrdeYaZ8Mg2Sb1M0I3tKO97ScN+UQJvUhjH80I7Z8Z22XFviF79us3Ifa35QJwhQG8s5TyStpgWwX3LBAV3qnEIfgRmIQWTLj283q2SWiuP0G6lw/DrKG7S4sUhvvqqePbYq6LHSh9Gx17d90lWJg+1Wta0Ji07jaJuAmwBr04wandq/caZ8Gyr38ZVHHvR6UiI3aOEqQPkfNLqsWozh1qU5kU66bVNMr4fDVsjDrxSQ1KV/r52uBUw0Sa6Mxrhcxf/Q8SQk9XsbMxvnFV58SCdGRmaxbloG89yanNQTpRqs6QGYZ8B/KyEwbEMH98/hQBFTZZ0gGGUxiu8Lx6azqY8PNDg299vSlU8xpQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(921020)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUM0OHBMTTJ5RFpVb1UxMzVranJPMnBKaVRzekViU0huZk5JRzJyNWRrb3lj?=
 =?utf-8?B?azZYZnJuTkpIbVMvb1JVYlNITzFVbTN2WWM4WFQwdXRlVzVLbmp4RmJmL1do?=
 =?utf-8?B?TENvcFdibzBsTWUrSU9nZU8zOUR1OEp3Z1VBRGZxZXM5c0JrQlZxSWdHajZ6?=
 =?utf-8?B?K3RhakNPS3dSblJvOC9wR3JibVlnY1c0RXhZS1BCYjEvUUtXZnNvYnlRaVJy?=
 =?utf-8?B?V1BWVWQzaktHWi9QWUZSV2lPc0J1clhGMFZmZG9mZUtpdkR3SzJBK2U1RUxI?=
 =?utf-8?B?V1dtVFdLRnJ1dlJvbDN1Z1A4ZUJCOWRWN0xkaU1ydVRUTnBXSmlrVzYwMTV1?=
 =?utf-8?B?VWRiT3laMW80YTFVT1czNStsUGhxQkkvN3hJSFRTSE1VaDVMQndITnNVM01N?=
 =?utf-8?B?d1M1V09Uc0F4RitVWVpVS2NkWDBYQ2h4eGVtY2xnZXFGUUJ6R3VnNStoUjU4?=
 =?utf-8?B?QWJnOE1jbVFLcU1Ncjk1RzFXWFVKS2U5cTljSWg4bGhmTU5uaWdQOUtIZ0I4?=
 =?utf-8?B?bVVubE5RK0UvclpLTkxFL3c1UGhteHFvQUxkVmNGYnBSamEyNHR0U09GRElT?=
 =?utf-8?B?Qnl5WGdBRkZJOEtKK2h0RTRuUTFNNmQweHBUYVpUOEI0NUtYdmo5bUNGNEI3?=
 =?utf-8?B?bXdWTTFhNDVLZkEveXFBRmJVZCtETm82YTBiOEUzT3JnR3hGR3RjZjNRU1Rl?=
 =?utf-8?B?WGZpY2l5YUpoWHhtbW52N3BsWHlxYUp3Z3NWc2FrQlpwRktic3dsUHRQclND?=
 =?utf-8?B?MCtsaHgwc2tOMEFxODZQaWYyQVp6dWV0UjdKL3MvTUdBOTJ6dE9NM1ppWkk5?=
 =?utf-8?B?TXhtR1cxOFBkMWZ1dFVFTEtNblFRd25wRm9aY25FOUFrbG9HVklQc0x3NlNi?=
 =?utf-8?B?RG5XdTlCRm9RK0l1VE5JaUJ5d3JoY3V3YXFWNUJJd2cvajZYRHhZRVV5UkRs?=
 =?utf-8?B?eVBpOGwwWWpHS05QVlo2SmNGcmJjYTVObTJoaWpraEtQaFRmc3AzbWNVTDZv?=
 =?utf-8?B?NDBXUkVZNE11QTBUZGZJWjNLUjBGckYxNkcwa1QyOFExYnRGdW92WDYwUjRu?=
 =?utf-8?B?SWFETWgwUmpBMVdqOVNsbjMreWR6VUFkTGN1LzFqdmZuTU5DZVBPc1VhdVd3?=
 =?utf-8?B?L2ZmQmEzeXFxU3F2Mm9jOTlEOSt5WEZaT3ljYmtQdERQaFpWejFtV2ZBR2tR?=
 =?utf-8?B?ZGRnc2crUFpIMjZNYktSMys2UDAzSXZramNJMnpWbTZpaDdzUFpjSTFYT3pR?=
 =?utf-8?B?UnRXZ2YwU1cvellGM2hqT2I4L0xhUThwMFJlUEtjbTJzY1RwTUdUcnJmUWRM?=
 =?utf-8?B?STU5TndmZEFmQkN3VHNVd1BGRDBDdHRZSk9yNy9pSXY0ZXAxRy9hOEdXQWVh?=
 =?utf-8?B?STRDaWJtU0diMkhSMElxNlNpYVEzcVZlcHVLNkRPeEkwSXdQQUlvai9KVklo?=
 =?utf-8?B?OXpQY3hSVG52ZWRneVJDY0FuQVBwQ3NlanRhZnFxQ3hkdm1oZWx0WjAybXk5?=
 =?utf-8?B?QjZhQTlRcWluT29SN0hKZlVRTjQrSW5KMVBEQm9LOVUrcFl0cElDbldQblpB?=
 =?utf-8?B?QXZwRUloWlRDdityanA2NlMyYnBIL290RTRjMlpkNlRLd0tvVGE2c3lUNk1s?=
 =?utf-8?B?aFZHcHVGT0NSd0UrcEVTdUkzcDc3eFA2ak5RZjRydG1OOEYvMzdyS0hNS0xV?=
 =?utf-8?B?bEN6ZVl5YThQOGp1djBJNkUyMEpublV0bzRUdjI2aEV0QnFVNEhtalM4WVpO?=
 =?utf-8?B?MXUxSnVtMmdrU2xSb0FPUHRmMks4Q1U2VzdFTmlEVFVsOGgvY0dMWUtibVYr?=
 =?utf-8?B?Q1I5dy9lRHRFUnZNbXNoMzNQTE1QcmdvZkZqL1dvVFY5VVBmeXUxYitEVnRO?=
 =?utf-8?B?WUVuZU5nNG9nUmxndjE3SWQwUHJLSDFKWis2blZjNnVLbGFSYjB1YmJDZXlD?=
 =?utf-8?B?dUFkYjhYbkVSMUdCd2FpcVk3Y2ZnckUrZVBHdTJ1b1NwS2pnb09vT2VDSXVD?=
 =?utf-8?B?U1pSWkpSVm5PbkpYYlVWd05qaWpMMkZLck1XcmRZN2IvdUMyd1l6RERVRCtB?=
 =?utf-8?B?cHpxT1VKZSsxYmNpTE5sRTlRNm1aRkViU3JsK0hLS1Z5MFdBeHppU1ZobThm?=
 =?utf-8?B?WlRUUGwvaW8wOEp6L1d1a0xJcEF5cjhmeFBLaHJqUERWTllCdTR6VGNXRGk3?=
 =?utf-8?B?aFRQSHZOUzdib1FTQ0I0YyswOW9NOHNNZUI4enFxU1lzWWlDdTZONXdaQ0Uw?=
 =?utf-8?B?MmJQQlR2SUhXREYrZTNLdkpUSFA4ZmFKWURyak5rMVNKcTB5dytkeGtCclV6?=
 =?utf-8?Q?gaYN+l3w1pkinvsJYz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5d4354-cf08-472c-a0b4-08def9464362
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 14:22:10.8374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32f8hz6T/AhrvrL5BLX5JQBp7PTd/g1xyooh+6VoXcgs0TXLbKAf5pZ49b5ZqjwW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB9053
X-Rspam-User: 
X-Rspamd-Queue-Id: A9D9940005
X-Rspamd-Server: rspam07
X-Stat-Signature: zcmsdcufhr83z75nc47utaupmm87ycbb
X-HE-Tag: 1786630936-797407
X-HE-Meta: U2FsdGVkX1+9xkdoIvUxbHEmD1FAIJz7rJprkw1z+YCeqQpomZ4FSSvruJoirzj6hvQADxPtJbHPRuhGomNKMq5WAFT98+T9WhYAu5QnhpMWu+ppbyT5kXVtL+gdoHFV/uWaUcj3Wo0plnY337bpq9lwsgWAdm9npjHukqdKq8tbKYo2ayHli98NG54f0XFzU9mNF+KQyrYXxc9IG3OjOcOlCg3xxN6BVaQiC5AMZKaEXwAZlNtnkLzowdcAvssFP2CNa2A0rF6Sl7Fq9b05jPIMlDtxWyT2DrqsGrgWFYu4NdTPzfMao9hCrR0QMIp2cqbgwQQ2dX0fNJoK64SFaje7Rbasfk2Oiq5oiBES73lN++oQ6QoQYR3o84vjQMnaPQJnXSDhfo6xnKoxTUZ95rN7qyPFWihtwAR2SGRfE64guIyKuWoFHEqVGfdZZLKiG6DIdvCp660tn/aD5nGIKbpS35NYJ8H7speiVfMMYjn0aQsqwaD8DpCCyV0mw6WPzkbVVBTRfzpA974CIePFiN3ZbUEMQazGyBpVCRUv7VMmdNV4Gapa4fGKOPhbUC1vpYCckcoAWafPNtkOb1GyBJPLw+bIHkeNGXpbfsvnJ1he4/AWzgr0Mv/u7OVcUL3pmzME75zjBqyqqKDzm2k2DJKx1SmO+AQvhK8R498340QfMn3KHF87OFJEE7v0YQTTfO5DbWHB/ZTX9PWfN0Mj5avw/wiouUZYophyujbuV9qcnv14eo7U/e+rdDss3K1fgSOoKQUuQ0TsgW5iJMPjcRX7t44WVj6skmPYtphUxqNSEGYwt1TEVSNWtBa5SAq+24jWKXkhqO7gSKd4riUjtL7EQ8no3HpEbkoZ0jhzbNAgMjSqoF2MwhCjUx0Q5Dv6PM2JEStAbjEVgRfSKrB+WhfrOQ/Y+ZAZQy54qgdEGwxZsknAHA9vFm9UaYLPBwOlrRed5Xwx81hr64G3aKe
 3LaOjaN+
 aoMjXGvTDGmwE/RkmuJkUyV5ulL4aZWoRqG4HLdpQ+N4NeY+J9+kr7vpHsMeiWMvaSXLm7rQP0ueT0zuASBToRX1VAMADQj7OIyvWz8w1u/niVJLe+H2QG/01vAUPh8FhAF0mkWuqTFeMpV2+IdtF14BeEH8Aq6CWbo4KcwIFTEm6aZOBkRSXrpWS+V14r2x4LtLfTHMbaHiUZmW9WdePF4Z+hA+fDrEhgWQzkFp6XlRNNPli19SdpyWI4pFVmb82balj2LQ2FcS7n3sDzDoz2BwcFHs3FpaOcwBcH0k/QXwtqqkBAt84LYPt7RjgkCVPPlEam+FfdHaGKwqmm8LzO7G0qoIubtrM8wElH9zLmELGRmeXTLw+B/UO0cAc3A9sMnz8P+g9ElFqJ95XVnaNd8/RQMkUFeanVhoqliG+raqh5opbbonCeJb6u+op0PyO2QrVtdzhU/kxQQVXm4sMB83gr1owU0GzIwgdQvNSQe+oTksFDZ2TU05hTAM8UgG2mkdCwWzLAwJ26uh3NudxQ7vSZECoUaB097PNIV1Svg/XxNFtJ5mvbgjnCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 13, 2026 at 9:49 AM EDT, Xie Yuanbin wrote:
> For embedded devices, lacking support for NUMA, memory hotplug/hotremove,
> CMA and huge pages is a quite common scenario. In this scenario, the
> demand for contiguous physical memory allocation is very low. To reduce
> the kernel image size, some devices disable the compaction. However,
> their SoCs do support DDR ECC, meaning that memory-failure may be needed.
>
> Migration is very useful for soft_offline_page() in memory-failure, which
> may be triggered by correctable memory errors. Most anonymous and
> file-mapped faulty pages can be migrated to other healthy pages.
>
> Currently, MEMORY_FAILURE does not explicitly select MIGRATION. When
> COMPACTION, MEMORY_HOTREMOVE, NUMA_MIGRATION and CMA are all disabled,
> MEMORY_FAILURE can be enabled, but MIGRATION cannot be selected.
>
> Make MEMORY_FAILURE select MIGRATION to handle this situation.
>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> ---
> By the way, as DRAM prices continue to rise, memory-failure becomes
> more important, and we are trying to enable this feature on more devices.
>
> V1->V2: https://lore.kernel.org/20260812091644.224299-1-xieyuanbin1@huawe=
i.com
>         Do not expose the MIGRATION config to users.
>
>  mm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>

Make sense to me.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi



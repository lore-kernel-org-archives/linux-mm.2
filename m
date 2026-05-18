Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E58CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD83C6B00A8; Mon, 18 May 2026 19:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C892E6B00AC; Mon, 18 May 2026 19:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B510A6B00B1; Mon, 18 May 2026 19:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A41CD6B00A8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:51:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C634A092E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:51:32 +0000 (UTC)
X-FDA: 84782190024.20.00B129B
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9958D1A0009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:51:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LNOibBzy;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779148289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PBxJ8a/xtS4nGTfrseMwRgAF8RHUdUOkxDaVTkxJJFE=;
	b=7tTim1MyB1JnGN+2/IxPaugHHN3SR5kAP3NqsU1BUKUJE928ApOMSk3swPUr/3L3WrtnlS
	bg9BkVBeAEM2jcbG7q5OpLkjqUIaFygZ36Uu70xLluGJtqp9MO6accum/aGBH18NfOUIpg
	FOCXcNpLbdanRQqP4jnK1JeN+bnZF4k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779148289; a=rsa-sha256;
	cv=fail;
	b=OmZualsQeujCWd/sWZ2fU84WtHkv5Hk5V4cPQUHLwzQerbBe4VJDTFb5+0fREGP/aPalfM
	qWLTG4kH2kHARu4gl93otdl5sXV206JJqTvrAkienPmYnIwxuAikzaTOqLwj5ogjlIEPW2
	oN9s4X2hnlyPZBkLYccYOZUaqalYio8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LNOibBzy;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf19.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OQc6K7cyc1+kr562PgANcNd9txyBnuUOr3xS6pGwhuceJndnssYISo4DBBmJSWAfYfPxOmc57e6H7yT+4i7fvrvQ58CeBObs3yC3HuroRE56h1zs7XQh7FMiIjwHwUWr2ikxYRSLBIjtiXNOx33CCHFnuZISz2DLtbgICnVtzW4wv+YWqkMBVUTz7tK1xwpEXYVa9J7RJLdGk9gJaslKLLM2MzDVIRQyxhAwCWRNnP1AgVnmx7JnlUD4SC6TDs5dCiiTgNYzkzu9FYhKG5dqYHf1kX2tvRHF43wt3U+6E/JIoh5brFu+TbHHtZQahqwqKY0k4/S8frwWA7I1NDo/hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBxJ8a/xtS4nGTfrseMwRgAF8RHUdUOkxDaVTkxJJFE=;
 b=Qjba0IK0FH0nyAwDNIdz9hdq5AfVRI8PXwtV8/2iqN+i0k0bCcRjQFiuFciFK5iOkFgjGzGumg5Jv6td5j84JK3ACaeOqaYQgygFBDi9iC07Aw9m1w3pRqwDcz1mT2lBbyFrl1IPIKMCFfxA+C3+wUuwMGgIV2fRPfofdMFrHiRRcv4U5+iXFa5j/up+j3fpofHI3uuL0kQp5cWbj7fiv/6zXutqRaqTFlrlIm6AEQZ61fv+DOpFrDhG7o8g3HaIk0t9tDTJJX5CwOrdRnHMRolF0o9sgAEARX3tIOWM+b1aYBtbfeGiRigXX5BIbcYu4hKLG+5jSkLAcxo629YLlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBxJ8a/xtS4nGTfrseMwRgAF8RHUdUOkxDaVTkxJJFE=;
 b=LNOibBzyoox5eotANJrtQDEqQuVKeIHS1C0hkiMyfYqSBVMRyfxlEDEr108ifox9sjyO4GMxifeOdMHnHWGfFVmqJ3AoR7mo8S89J2tVwR0tS6xt8B70jHV63YFPyZQ+MCBnTpUNEChZ1agiJRaEj8vq0Hf+RvERNL/27z0X0tIyIGSS/+CJ8NNazTpjHsafIDEGGeVntyYrEWO0+9EQCykFtAXT02Cu8mHqt31YP1TvhtmJe2MMBussHJsJ3ivFvC7+h7O4Nac6Ewzu6jXNBm+10o81ppml10+f64HiIo5TyzZrx1HQJUB7Vy9NyoXam8j/JPliYDnfWKKWvfHw0A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA0PR12MB4463.namprd12.prod.outlook.com (2603:10b6:806:92::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Mon, 18 May 2026 23:51:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Mon, 18 May 2026
 23:51:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>, akpm@linux-foundation.org,
 david@kernel.org, kinseyho@google.com, weixugc@google.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, willy@infradead.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com, rkodsara@amd.com,
 vkoul@kernel.org, bharata@amd.com, sj@kernel.org, rientjes@google.com,
 xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com,
 hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com, riel@surriel.com,
 shakeel.butt@linux.dev, stalexan@redhat.com, tj@kernel.org,
 nifan.cxl@gmail.com, aneesh.kumar@kernel.org, nathan.lynch@amd.com,
 Frank.li@nxp.com, djbw@kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 1/7] mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Tue, 19 May 2026 07:51:07 +0800
X-Mailer: MailMate (2.0r6292)
Message-ID: <F560720C-D627-49F3-B3B9-976BFB8D79EC@nvidia.com>
In-Reply-To: <20260518175429.1b28e8c1@jic23-huawei>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-4-shivankg@amd.com>
 <20260518175429.1b28e8c1@jic23-huawei>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR08CA0062.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::36) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA0PR12MB4463:EE_
X-MS-Office365-Filtering-Correlation-Id: 4098561d-ce56-429b-ef53-08deb5385e8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|366016|376014|7416014|1800799024|4143699003|11063799003|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6MZRTklrCXYaKj+xJBVaYRZteWRfB4apBaem5if7Nsqb0JPv51HbuPjGvfWYB3bWpyWJ8pzRo6e3+ZrSE3xLaMqcnSSxqA2dpS1FlOf/2akUrtzl/SqoD3VGD+x9hTbplFZR6aGOYlscPCtjiLsj3OiK3oZMSbcD5LQdyWQGlsehX4uxzQQUcTQccCRsO0Z9o6NG2j+rd57AoKK7x8aoi4E3sgrqIQI5/hdGIMWFvbH9dpNPlLwOLnkFnlo0Owb2F0CYXoU0/oIgWRXhghI031VPKkGXG88d4GVuaP2+lR1Zwx6QMNYhjxgNrWFzKNWwAXG67LWWe4coD8N6WBzAYF7eiTzcev5zoGN8YMchyPJTBTsSY7Ge9vPHafj2d3RWpcaVppUYqrheFqjb3cji0IjFumBzubQU3I03EveLm393QkMDgoVoxu19lQ62kyOm34xxAViDMQK/rYr5kptgvg4gk/fFBHQgIXi3hAKDyv9jZO/pObwhKRp/kdL7uuf0DM2kKI3p34BPdFjrYITS+U7M63zXcCz2Loy8QdPcSGcbhGpkG5TQS3pUbdrzN6OrAmwRzKhwrWjDB/0D1/I+nXDOQJb+AlT2xv9Jrg5BnTIFvRTtGrdCSdxVIVGK0P/rO4ENHZ0EtBZ4JFeVnu5sGv3+k6Pa4yU8AgjrKmW4H5iwqX3T3a1wMKof9jiyNEcR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(366016)(376014)(7416014)(1800799024)(4143699003)(11063799003)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?LzhsYks2VU5MTkdmdHpRZ0kvREVPSXlWdXprbEorM1hhdVNHWGdBdUtyS0hx?=
 =?utf-8?B?Ui9DeFc0RmhJaFp6S3M3M2JsVUJQeW1UamJlbGVjWnI5N1hKVjc3VTVUN0ZP?=
 =?utf-8?B?Q1h6QitwVE9oR0dpTnNYMkloTzErV2VqbW53TWN2S1dQSHZMTXdWZGdWMWcy?=
 =?utf-8?B?d3czbXNCc3I5OXI3cjZUZkxEOEdWdmRvbExsbVdob0g4WUJ5WGZ2aHhOM3lm?=
 =?utf-8?B?ejhJTXd4VzcxQy84QTIyUXhTaVB4QndjcXlIMUNWeXArcHN6eVIvdHBPc3Fa?=
 =?utf-8?B?bFpZSzJlejRIdU5FWjJzTnc0VFlkUGZ3clRJVUc4UWhpY1BlWGhRY3YvOG1M?=
 =?utf-8?B?bWlUdXZjeEQxRUJscWpzYUlveHY0bGFhNXBEaEkyNkRGem51QWhoSHB3MGFE?=
 =?utf-8?B?Ti9OZjVZTUFxbTZPK09aRTdkakxCWXl4VkV6WGJJNytBZ1J6SzVkdVZTLzJs?=
 =?utf-8?B?MXpnTFBvK051ZEd2SGw0T1pFcFVId1VnSzZkKzdQNEhQZDFrRXQ5Mk42TWNU?=
 =?utf-8?B?ME9hQnJ6RENPOEtxM0prMUZMNWdEU1pDc1pFY01wY2lxOVN0bWU4T2g4Yzk4?=
 =?utf-8?B?dDVGaHYxUlk4KzdneU8waXJlTHBTMUM5bWtFNHZmZHpGTkxuUlpoSHJXcGIz?=
 =?utf-8?B?QWZIU2tNeXpSNURpbHBFemhDUmdQWDhqOFJ1dTR1MDlmeU1ZTklyVGVGTjdz?=
 =?utf-8?B?NXczWURPQzRmSmluaFFlcmhsaWNUV3Vyd2FmeXVTd3J5ZzdRNEM2UTJlYk9v?=
 =?utf-8?B?WVFvajJsRXUybmIwRzRnRFNzRnBRL1J0QnNpbmV6M0NWckwvV0lWaHMyYlht?=
 =?utf-8?B?SzJoUTlnWENybllldjVDVGU1YldHQlRQajBHNkp2V1UyeTlsM0dxUlBpRE84?=
 =?utf-8?B?TGM3dXo5Ly9tYnlwNjdmemtieVF2amU1cGNEMXFHVFUyRFByUWxab2JMM1Jq?=
 =?utf-8?B?ZCt0bHZROC9XTkhMYWpoSndXM0JQNGdtMW11SVZuUFc4dEZZaXFLVjRHTno0?=
 =?utf-8?B?TGJmOEVlbEF0NXZyMUdzUFhMYkFjYXJCcjdEOGw2Wmt0Yis5WTFiTmlCTnJu?=
 =?utf-8?B?MHp4TVlvSmZnaG9SOFc5ZXNyOUtQdUNWMk1YRVJBaS9zMjNMNldCWkFVaTA2?=
 =?utf-8?B?blFIdDlQTlZNcjhFeDFkZHlkSEVkT3BIaW9lUFFJMVY5a0FZTndCWjhIVmtV?=
 =?utf-8?B?dXltNGIzMmxEcXlFcHQ2VlpIU0NnWDBWL3VGWDlTU0VPZkhGZ1NVVUtBMmNh?=
 =?utf-8?B?NjJtNDFqeVk4d0NhN2dKeDRtTmJtblUzaGlqbHAxaVpNSktDTjZZTSszZVRX?=
 =?utf-8?B?U0MxL2FtUlB1cldmZG1wMm9yR0w2RTI3MGQ5S3ZWN2oyQktpWUVwZVBmMjZq?=
 =?utf-8?B?MFpXTzJXQ0diak5oUmg0dHp3MlZZeWMxNDIzckIzNFUrUmk4bmJ3VzJQM0s2?=
 =?utf-8?B?ZGF5aWIxUm04NVN1WnVwWFN2R0ZUMUsvak1tQWM2M2Z4OWhiMzREVUNMZnh5?=
 =?utf-8?B?SFRZRVNYNDhUaHhQV2JKNDgzYjB4dC9vbHBYMUc5cm5YdFR4amJSdUgwaG1K?=
 =?utf-8?B?UW9rekJJSXRKQXZLYUptMGZ2NFJYUmhnWGhqSEJWVXBjeFBkWnpKdEEyc3p2?=
 =?utf-8?B?eUgrY1N1NCtHV2pGd1ZFWE5qcFBQeW9KamlGVXNDYmpiT1lrQzlidlFkOFBX?=
 =?utf-8?B?MjFHb3J0dm12enplU2RwSWxhZ0dyRXZzQmp3cGovNkpoUkJobFJ5dzdqZ1ht?=
 =?utf-8?B?Q0tVZDhIUFZiTDM3OFZ5Wm95cFRvd3JKVWVWVEFKelo4eStXT2hUQndyTDhC?=
 =?utf-8?B?clFXdldhbk4zcUhZMWpjNEJJZnhMeFBPbk1YUDlndSs2YUxrbnhXeThsZUE2?=
 =?utf-8?B?R1cvMDFpQ2MwdHo4N1ZBaEdaUWVlTmhRNFN3UXlyMDFvZTdKeWhSM2tZTFdD?=
 =?utf-8?B?MzAzbDFvR1JmbHJPT3NzV2ZucFQxNkZrbk9kMlJDUnc1LzcvUENUV3MvK1k1?=
 =?utf-8?B?cGk2cGFBc0lRcmR6ZXZtRWRMYVN1RDF2SnpURjE1dlc2SUY5Qmt4RUcyazNu?=
 =?utf-8?B?eUF0eTZEelI0OFU1RTZ2dWNlMkVlOS83WWsydDlNTXo3cFJEL2Q2cXZWQzBS?=
 =?utf-8?B?ODVxeU5OUUFSQmRxWG9heVdEcFVtaVp6R3ljL3RiTWlpclBGWUFBMG5MYnBC?=
 =?utf-8?B?QTBic0V6UnA0SE9pTWtYY3F1R2dqdmVVeWtVcms1ZE5kMDBaK2lIeWNoM3hv?=
 =?utf-8?B?T2MyNDJJbmc4ZDNIWkJ3ZWJERTRObzgwdFpHZ0tlcnZOQWZ3b3dQd0JFbEIx?=
 =?utf-8?B?VnBpTkJSa3B0bzJhQkJmNjNraWdZRXRlREtJR2lJbCtjYnRqekFkL0hybVAr?=
 =?utf-8?Q?k7B4vXBLU7xJ0vjOM53hNXHqlumEMp3Z6J1rt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4098561d-ce56-429b-ef53-08deb5385e8e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 23:51:24.3650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tQ1B1PijCYTbIccyseI0fGdytpXvACamf8s5peb1v40GK4vZf84xPzOaQ2pipc5H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4463
X-Rspam-User: 
X-Rspamd-Queue-Id: 9958D1A0009
X-Rspamd-Server: rspam04
X-Stat-Signature: 96raptdmpbaeabnr6tn9gcze59553n3s
X-HE-Tag: 1779148289-159086
X-HE-Meta: U2FsdGVkX1/isq4qgUOWZD60bud89eYTJt6zXFjCtiEIxt2gFusojs+32QHKHl/eZat8EZt5X1fx9LJls6j7nUa3QBO5LnMMCFgfqPO9Ee/8Pw9saNEYxGdbE4yGq7WSFozzcTqQ9OtTxLng6OH7eeb51amFw7yPeBkb6/7q3tpEl/JQzFX6mq7Oyh87/peVDqRnCd2YGZjz5mJwJ613QA554I/n5fU8YQZvGrP9eeqOrn7m65laSd5IWSBNHTTCcKAIyeskIOerB3wK8C9Pv0ZKwBgUiDiXu4Wwn/V8k8bD+3U7Io+vSRBDE5BwFYA78wVFiYn84orgB7Y7aprONKgaIm4MGWMuX+dz+F/scMvJ5uzE5h+GEhsz+I5CwCmCQB6kKQOjsZ0zDtMuyUYNLGZSpseH5qV4Qef74ajIl0za+L9G+yrjeBYrOnnj4kI24mWB2sFF4ccL7TbsP32/hSCSoagj3PWbV2qtOICK8SFUnnQHJ56B2ta7GpFU1hdEecq3d7uY2YPU6VmgHMzFvchsMRzVRvRd4kqYsWMAl0PEwazr5RX0erb9A88lPF/fIezDMIomWCDj37tlQ2bvVo/Gu50rtJjfNnwiPPyA3l7nOD5E9GOnuufdViOWGD+oE4UW2YmdfyxoBuPnzc8Iz9KGFFS4l1Zoid9gSGwd+G6POXOghBHc3ODQpO+RO0sUkJWoTCPVC9IB9DnhaNRocPBkWgLUC7FY4dTdlVbFChC60oH2SLKu6SalI7sL5s+GyYXDaAXzd5nq+OtN5vLKsPtQj0+CkAQMzEslwHkh7ATuj7KR9sLNIyrl5CR7NubOXmfr+3dl4WPVYU8NnZBCH4O5ecG7omR50vvhI5CX5ZHUrSIwu6TAiRpyxXS5SayAMURauvKCcI0ohSvAgJjV/uS1DxhlwbPfG8KyI5aPvLsufWJYnlO0HiLlTpptf/txPlIwfdaDWQR8n6jI6U9
 W43PD1bf
 mvn9OoIrnn9P5Th3GfiKxV/2jWTl8zigpw0NsbqHSGjc5EtyutDwK8STkGZl7iQnrUPmkVxlGqBgSyvu9wIka1QGy4LdSySWiLNfr/VGbmjQQhJoeoFsdApClW4d5CqhofYAExuyvwmxT40+zfk2HGETmwBqypCTgDQYm1+8Hu+DMn2wIh4IMi5T+3OZRDo+Fk4BPXgH+lTS8iDpDDcqZ39DxxZpxy2dbVhq+NtV08Y1e+MiNXPKtM/8pvRJO0Dw1NogwtOvyVVZ1x+xfhlTO+Ja1BAmMwjwXN7ZxOSuDNPQeWl3igw4cMevJMOv2ghe5W/s0UlKXztB7XeauMOPvwoVLStrtFi6hjn+iQpRsSweNgumii3Xo/XtZ205FVRMx4GZAocn5TpdM744We0b+xCQZ3pQlQM+0vsQVXIJsuzk/D+yETTNCAHdLLJQPxTHwnUAWbhyaDX356MNHBYx4VPN4kgKhwe/Mdj2t9EQo+sXxqZ1Gw2+F0MQQ0z8f2fb0vpXxu4PJjQp+Bn+RLt/2Yld858e+qhC+Y4TqmF5Vml1S9BqIBjXtw7tx4blnLJZInE4Q2/SiIlefs/aX3rXZACV7E8ZUoAoTKoQWyZ5FbATrg56nOGgMYeQr3kJr0+kt2weR0/3ixzz7oK4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 May 2026, at 0:54, Jonathan Cameron wrote:

> On Tue, 28 Apr 2026 15:50:39 +0000
> Shivank Garg <shivankg@amd.com> wrote:
>
>> These flags only track folio-specific state during migration and are
>> not used for movable_ops pages. Rename the enum values and the
>> old_page_state variable to match.
>>
>> No functional change.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
> Hi.
>
> A few trivial things inline.
>
> Thanks,
>> ---
>>  mm/migrate.c | 48 +++++++++++++++++++++++-------------------------
>>  1 file changed, 23 insertions(+), 25 deletions(-)
>>
>> diff --git a/mm/migrate.c b/mm/migrate.c
>
>>  static void __migrate_folio_record(struct folio *dst,
>> -				   int old_page_state,
>> -				   struct anon_vma *anon_vma)
>> +		int old_folio_state, struct anon_vma *anon_vma)
>
> Trivial but why the formatting change?
> This is all well under 80 chars and it makes the diff
> a tiny bit worse than it would otherwise be.
>
>>  {
>> -	dst->private = (void *)anon_vma + old_page_state;
>> +	dst->private = (void *)anon_vma + old_folio_state;
>>  }
>>
>>  static void __migrate_folio_extract(struct folio *dst,
>> -				   int *old_page_state,
>> -				   struct anon_vma **anon_vmap)
>> +		int *old_folio_state, struct anon_vma **anon_vmap)
>
> Same as above - avoid the reformat.

This format is preferred by mm and it is different from
kernel’s clang-format.

>
>>  {
>>  	unsigned long private = (unsigned long)dst->private;
>>


Best Regards,
Yan, Zi


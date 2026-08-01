Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9DBC5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 23:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADECF6B007B; Sat,  1 Aug 2026 19:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8EE36B0088; Sat,  1 Aug 2026 19:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932E26B008A; Sat,  1 Aug 2026 19:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AD096B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 19:49:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC4F41603EA
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 23:49:23 +0000 (UTC)
X-FDA: 85054344606.28.BA02D70
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011023.outbound.protection.outlook.com [40.93.194.23])
	by imf26.hostedemail.com (Postfix) with ESMTP id C2DD3140002
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 23:49:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pc+afZLV;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785628161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30xn7m+YWLcrrPLRcpfSBfFygOd84hTKO+ow1FprtnQ=;
	b=iKsU0SpXSZg2FfR108MVrOpVannqspm1JcDaZWFsdaE/FbJJwElW0du1lz+OlrUFPxJeOO
	XEWhDe3ExyJKIYiapjejv0jIdYZ8R6zq3h86WPKtwWYp+QVJfMkmel5II64u4tN6lJRdz4
	QNblvN32gAXd04/ue6ntwnYm6nt9nSs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785628161;
	b=0iolEJfCFhc+fD87SVSlZUFEzM7eGt8Ark7Mem/YdiCyIVG7Uq7GL7A9QeUsyd+TY1ZG2A
	LoRJcd80mFMDsLVJPivS5hun51t7/6hKt/qzgZWgDwzYKBLvkNMozbe3ng18VfIV8iTBje
	vnAwX3EUTofD7UIhl76WdSHowac0pN0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=pc+afZLV;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.23 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZfq3lL/EFyEjwA7FA9Ng8mI4EWDDkOoBTVgG0+soqsd9vZx5ZWtvwS9tz/Em81KCWVAdBxgSg2338OYXXhGIbwTrizo6y9LDeIHdpEa5+dTKUJMxweZJ5/eFFUtjdlCG0QYzpvza820Y0Z3h6UloLtTq2/XvAqc1CrBviRmaWOJliIAr1kjGpBrw12FuyRnC/teZkc4z2DVVTNZ6H/RxuoIEG4aciKttfARx3Ccooii7g6myGYUkGNbqm5wSkNV00jEqF1XSRZav8zI1ZxqvqyQFjA7MY52Qwepy5ipYESPViaHyOPfzBjfmPFirgyyOKswmnQa0Bi49e9pyfcc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30xn7m+YWLcrrPLRcpfSBfFygOd84hTKO+ow1FprtnQ=;
 b=FEXS5/BSGJiMcDLte5JzcChZpYVb/KmmmiiXT5z4jmbUrf7tFrr4wdBLpIqa1+7FnC6JGqHCRV+D9lpXfTH2SrkD9qefn8PHVnHfaDGuYL0eRdn/gWwKul56PH3ebxsM9lu1DAhpdxuYVV/CsDXjImOVzs71hiUfq0jmtGtx7BCuSdBlsTxVok+RrlEJ9e+zwbYmtblYPWMJdiev7lKhJYBV6ubaZNMkRx/NLLtYx6TlaBLbaEQF9l6O8Vg6VJZVGjB1kXWmf3k5t8CMtPgg36nXMyyVgMEb8g6c090czvhi4U5eTvTBuHeKo7SoVhReYLog11AhRSnetgqd7GajAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30xn7m+YWLcrrPLRcpfSBfFygOd84hTKO+ow1FprtnQ=;
 b=pc+afZLVCFnDlLWmw3rwHSfqRQEDK3ZPX0/7M480pPjGvT8LxbpYLTfgfzncB75OajS4OyAauz2Cu4rs8lcbXeigGc+Z0Iw7puWRHPibtINiwUJKnceFk+nejNHIxo3eFSk/dzSavATCyQUfCQD5UHGfxnzH1G0n3+bpfCD/73JrmktVkhWZx697MfJaPRP+2A9O2pErKjGd1h3Ia9ONAgM8WowW76hbtmeZ4s0Cp7QqZn6+LlmCPP2JfFEv/xNU1/thWvu/4EYRYR92NfcJu8rf9LALAK53lOSVBWm/+sRE8mqcSWmD38cj/y1GzcHyvYUf/aIDuUTqs/Tb2j//hw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW4PR12MB7467.namprd12.prod.outlook.com (2603:10b6:303:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sat, 1 Aug
 2026 23:49:16 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.016; Sat, 1 Aug 2026
 23:49:15 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 01 Aug 2026 19:49:11 -0400
Message-Id: <DKE0CO9RE3TN.KYL8VQE6QW66@nvidia.com>
Subject: Re: [PATCH RFC 01/14] mm/zsmalloc: replace PG_private with pointer
 comparison
Cc: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Gregory
 Price" <gourry@gourry.net>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 "Alistair Popple" <apopple@nvidia.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt"
 <shakeel.butt@linux.dev>, "Kairui Song" <kasong@tencent.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Minchan Kim"
 <minchan@kernel.org>, "Sergey Senozhatsky" <senozhatsky@chromium.org>
To: "Usama Arif" <usama.arif@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-1-142c97ba3562@nvidia.com>
 <20260801141259.627022-1-usama.arif@linux.dev>
In-Reply-To: <20260801141259.627022-1-usama.arif@linux.dev>
X-ClientProxiedBy: CYZPR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:930:a1::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW4PR12MB7467:EE_
X-MS-Office365-Filtering-Correlation-Id: bb8b7019-c806-4af3-84f2-08def0277ef1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|4143699003|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3TT4/zYVPX8Q4JNTlm9h44A02F2jcV1W3V639OUf+Cldam2UNdvR5er4uwIThTwvlZh+YDf2u88aP0n8e8hVJz5vGUnrMYNcEkVm/VsEcdUiSQm4m/6LQMs9lO4NhgY9Wiv+q225vVk2NcPJyfb1XpUdF265sOTBcNE5RRHWNkOg+PXq9VZTFl5NxKmc5imPPjaLd0TGwtwNCGsMlME0BuC/p13/gecloGPnl0jnjKnWo1MYd6xBeg7psHoqu/3IFEWKHkO/JZIHuTUR9R3IId2sOAi5RVcUr5YGJXvOOHOs3JMq+x5TXv41S5yc+XvKvu+LJ3qhCPt0R85ut5pne73WeyJrAzWFQ3ZVZomOFoj6Or/Gb2U/7Q3ZsjXhT1+JUlDAJZGDJjf0gdUGJJXDHti9C1guWveKwQbzeAPZo55E06OvlSW6pVe7P2vCoMWeIaAjog1bFhte3qQDI4KVpssvQ/kd/Aes6qkIH7dI7+iggk5jSX2BBMoQ2YdO6wqxX+/O2cXL/jhWFqyoLb8V6W+IUrUVt6femqm6EZFbHhF31aTlrfN2t0/mNF+gRHqZGBb2THxXtH3PrYuBHwpI3qjefS+LPw9OEcJvPBhBYJuCSyF5Z2q/ON7runu6p9QcgMjmrJ4ptUe6bAOvp3a28pCG2AWp+ysBFCOzy+pz+Vg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(4143699003)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SnVRSjNvd1JWeENEYW5RQ1FHYXhYVHRvbzB1enRFd0NFUW4wV1pOTTA0cXNi?=
 =?utf-8?B?L0xPaENpdXRUUjZUZkszb0owejdpc2l0a3FSVUNrT3hDanUyQ3dOeGJsNTV1?=
 =?utf-8?B?ejFjTTNvS3Z0aGZmRkEzelhWQWhUSGpjM1FnekdpTXQ0OFZXa3UrSkxzbklo?=
 =?utf-8?B?K2srcytzcmdDeXB0M2lMWXBPL0w0THByRlhtWHEybXpiM090SUpUSzRMTjA2?=
 =?utf-8?B?VEVqbEp5cHU5d2V2Yk5xaGJWbjZlRFR2cWIwUFFLUXdDNE4rUzFydVdTazIz?=
 =?utf-8?B?azZySUtFZ0ZIUUdtY1RnSG80TFRYQndpR0pHYUpiMEdRKytCNTVqUzB5em1E?=
 =?utf-8?B?R2ZjaHJ4Ujl6Sm56aEpXRERXampFVHB0c1NpOHpLRzFoNTVWZlBDdDRMQ244?=
 =?utf-8?B?RGlXVWdvdkpwOGVXMWxKMVdKYVFZRHNvOUloaXFZMm1qN2tOTEFrdUhjL29V?=
 =?utf-8?B?Uk9JaEZrN0o0NktHV29WMEtCd3cwcDRDcnZBcG11WDdyOHgwNkJhbjlKRGRQ?=
 =?utf-8?B?d2V0Rkp0MXQ4cVZZdTZKZXYxTFZGamxiaDlzZE42VE53YXhSaUxwNGYzYVhp?=
 =?utf-8?B?R2pxSENtTHBJLzQ4cXFEZCtuNU5UZ2VwOGtVc2FtRVVucUhqYVk3NTVlczQ4?=
 =?utf-8?B?R21HVFNMaFVXVVAwTVhqa3N5ayszNEFJeVBoYUNSZ0FkcitrbUFxejVCakJk?=
 =?utf-8?B?UDZjeU92N1JIRUduWW02SW1yK2JsRjh5SDJGNFpWUTQ2am51VzRmRzN1cVJx?=
 =?utf-8?B?WWdkM3RyUUJuNmQySGR6ZjNpeHRPTU84YlBlK2xCb05hdnZCaC9PWGVnMjR1?=
 =?utf-8?B?VUtJVCswZ3J1UWQ0bW1hTldZWHR0eGN1ZktLMXJJcGlGUi9YRUdMa0J1Zy9R?=
 =?utf-8?B?Ylk0c3FTeldhODFMWFVzdHNCVTAxY0FjbGNYZlNkRE9qMVcwc3JwS1lsZldO?=
 =?utf-8?B?MkVRN2NPSFhLYmZQZ2l6M0ZWbjFWNFpOeWhWUkVGaDJSb0p5TjIzTUVrTHYx?=
 =?utf-8?B?QmFpc2l4cENoeEhIcENzWE5TRXR0UlB6ZzdnZGNTUGwrRDdYNW5ENHpabkhl?=
 =?utf-8?B?VWhqcFdHbUtBV1FWcWJIMzJDUW9vN3B1WGM4cFNqMUF4dDVwVnYwK0tkcFdr?=
 =?utf-8?B?Q0pXMlg5Y2tMR09RM1piVmd0c01WanFJQjUxalgzVUhudnVyOFZPazBSMGJ0?=
 =?utf-8?B?M1hMczE4NXF0UVVEUzlxM1NNbWdaOVVnU1RMM0RLZ2xlWGYyWUxTRG4xeE1p?=
 =?utf-8?B?Y0c1V3pqRnNETXNRUmhHQnBmVHArOFkrNWxhK3pMaUdsbmxyU1lXT0w1ZEhS?=
 =?utf-8?B?SFNmeVJ6UDM3YWxMaXZiY0R1elQ1dk9HNXN4Wkt0RlhnZm5mNlJQR21kNXJq?=
 =?utf-8?B?NUxHWlJaK1lMQXZMeEV3T1g2Y0I2NkZQUnh0U0FRbUtlaXpKdm9YcTU3eXlG?=
 =?utf-8?B?c3MxQUt5dHVVNVhHd0tMRlJZdGNmelRrWEd3WEE2Yy9abVRwVmFqV0ZyRVpP?=
 =?utf-8?B?SmtYV1UyNk4vNHpRcS85YzV6eGRpQ0Z1NndkbkZTNUpqSUxSV1NnK2R2bVhv?=
 =?utf-8?B?KzJIUXMrMGNLVDdOaEVrdVlOYko3L0FENCtTYlllckZsSHhLTmZlem1oclhl?=
 =?utf-8?B?UHdYZndTdGdLbEt6dTBQRUxMMFlleXIzcHdTNjdlR3pKQTB5cU42STVSdGIz?=
 =?utf-8?B?VEVDc01jeWtOYmpTYm5hME43VURLT2R1bHFiREl4dUVjd0hPZmg5OWRROUk4?=
 =?utf-8?B?K1lFMjI5UzlFVWVYZ0o1VHBQVkdZNjR3dlJzTnlDZFVOOGxzUHhqRHNab2dK?=
 =?utf-8?B?U3pVN1lsWTdQMCtxaHNOSFFIUmFwb2lFV0pQSUJMRDB0TXlJMTJFUHFQejJS?=
 =?utf-8?B?eTBNRW84cFlHUGFHM2ZtTkhUY1ROdTlMdDFoOFJLaStBVWxnRHJURjVTQVpv?=
 =?utf-8?B?NDI2NWVoY09aSnNOZkFVbzNqbVlMd2FSY2NiV1k3MDZDRjZBS3hMSFpyVDZI?=
 =?utf-8?B?SDdyTHVXSTBkZktTR2xLV0FvdXp1Wk1DbE9nanNxbktzdFhPbmNzR0YyRkxW?=
 =?utf-8?B?bGN1SXFYeUZhWFNtbTlvN1EvTEIvMk1Sc290QmNaRUNUUUwxVHJEZVZaTytY?=
 =?utf-8?B?TGNsS0prcDVBZTZTYVRBQnRsT3NyZUp6N2FnSldWZmhNeC92UHFMWkxaNzY2?=
 =?utf-8?B?V1o1Sm5FaWltc3FkeFAzbHFDTWlWdVF0bDVsNkExYU1QOHFwenE3RUhaSllm?=
 =?utf-8?B?UHhNbTNIbXRabUhvNmFYc0RYUlZ5YWIybEVzOVBWMHRweDJDa05GLzJHaFlO?=
 =?utf-8?Q?w3jRrbCvtXXdzyYg5f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8b7019-c806-4af3-84f2-08def0277ef1
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2026 23:49:15.8699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91eg2Ou0WFBDlG3WmW4xUSOcDcrVFFAhnGJt6ase5+2XiS2MqdSP2N7GuE9B1Gzj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7467
X-Rspamd-Queue-Id: C2DD3140002
X-Stat-Signature: r39juxuqfj1xj59fbuybwg7j4odu57ek
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785628160-478800
X-HE-Meta: U2FsdGVkX1/iPX/YSt1godVCEvMLJN1G6psoUQUzjVJNeRpSG+Kr1Y3bmBeXn0qrTOGLG19fdRCJjguUe29bRh17BHCbO61T0+VYHFsHMwusZVNE+hLxr+hXLBZalgng4+kAZgNteNtfV3H7pMMldGHaTWKxI6eAFO/+BfcZO9PLXyQhb7lQVuEfTOfjUy7wtHrjZgLIajx+dUR+3xVXNFJsdL9OJm+TF8uTy0NG8OLuTZj1/RI2tIIyrxz5/Nb5UWeA/TvXCgwX55KHxZQVbLkZSeauX8u9boDk7ESLWVMQNh//z9NwOSGfxg0AbGG7wES3QxpUwhYkTs2LM1p+a57lbwUdblYWT8EbjTG03gY0S8iPKnkHbQRO4f2MBl6OdOY5FbHn/wWaLjW2CtUBualQg4MaR+lifhmDe6kpGRffDfGHJPQwjcRKPxvwx7KWzgNv6fR9APGx9Kb7tuHbrKDayMfe2asrnsRjnjGgwhZV9X9fmp6AtyIRwnlIQA7NKV/t1mzapwNgyBVWXfNv+3AfY3MVV/x7+Zp8IgydxMWwSgLlNg9qewywQELIGG2MMnrEWgK2+gKQHqsayElBXceDuWZdDlLCRxiqXs5Lcn7R0HQzKSUpdIKIHJ4/H1ITMYcomFxSauWq8cj3jLVoWAN5NpI6ZQa1IpDhKjkaqPJxATPCOnYo6qUmaL7RYyD2CykYtZq4VDO2NLVYGBVb9wHym8WNHVvysMBpwMb6mnghNA/0h9Rg0j1FePXkeQqT+1f0afE/2AWBpgAV9bvIEE6KO7pP+ealUPg3W2ljV4iHEB0gDi+Jzpgo0xiAu9twcfmxZxQOH5Y73R7/hAJEkmx/szmQKhYZ8iX1NJyE+OdMWMvRCAczne6VqFsSrOmcS/3+1l2iRHydldr2Z+Xv9J6W/szm6s5MDLkvVtz70E64BkX8cAPMrMnCuQeI1EGRCuyv+t2iUeocL0bu9X3
 pJOQVvSH
 EO/i/VfYXHDo51V/s50kWuFF6zdVpu85yzZzS3881BbWI0vjrjqsq3Lu7G+1hj46VdU8U9ps9LTAJhI6OhK+qNx8USsOjP5ys07QpGGY4uc7d6uW9fKBcZ/JOJamnJNab+RBnIqp39+OJefuCJUbCaW/pjh2yXTJdQsO9XLzBgecYQbxMpN9o9qBVr42Fy6a7jknjeET1Riyb+VV3zrXdNxxaM27+83znzqvCBnKk2O6d85q0L9tgWXVgocGGub2ok38Yj88gqZg0sGXjaufqdy6B+iPhd0UwGcNgQIUhn//Knaj1ny6kI6AoQKkrwiYPCTaJWXSVqP+WAJkj2DIWLxrNTzpKtPusJDTxmznsh9qZatW9LdgCcF4z7lrV0zsFxSeDMfN/dByLXRRluTDC8yRSX2uFHpxo6pFxvi0uPTisvR1BHOWhqEPpXEswJaB10RK1z8YZBIcpAL33I1UFMAgcDxUGbeH4WtgiHMRIqmdURB39gzYJVUeMhYsZEXvB+vHkv4K4pIG8spluQVwxLIaBFCnG99L29DGW/ndXB4ePCCVTmbGqQq6oS/EV1On6VWxxxqggRDu6uWvLUHnY5Yjv0m6j1Lfjkgbp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 1, 2026 at 10:12 AM EDT, Usama Arif wrote:
> On Fri, 31 Jul 2026 22:13:24 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> zsmalloc uses PG_private to indicate first zpdesc in the zspage chain.
>> Replace it with zpdesc->zspage->first_zpdesc =3D=3D zpdesc. The check,
>> is_first_zpdesc(), is only used in VM_BUG_ON(), so performance impact
>> should be negligible.
>>=20
>> It prepares for a future commit that remove PG_private.
>>=20
>> No functional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> To: Minchan Kim <minchan@kernel.org>
>> To: Sergey Senozhatsky <senozhatsky@chromium.org>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  mm/zpdesc.h   |  2 +-
>>  mm/zsmalloc.c | 15 +++------------
>>  2 files changed, 4 insertions(+), 13 deletions(-)
>>=20
>
> create_page_chain() sets zpdesc->zspage =3D zspage before assigning zspag=
e->first_zpdesc,
> so LGTM.
>
> I think the assertion in get_first_zpdesc()
> should be changed to
>
> VM_BUG_ON_PAGE(first_zpdesc->zspage !=3D zspage, zpdesc_page(first_zpdesc=
));
>
> in the current check, we are checking
>
> zspage->first_zpdesc->zspage->first_zpdesc =3D=3D zspage->first_zpdesc
>
> which is just testing the backpointer.

Got it. Thank you for pointing this out.

is_first_zpdesc() is also used in obj_allocated() for the same check and
getting rid of it in get_first_zpdesc() causes inconsistency.

How about the changes below on top of this patch? is_first_zpdesc() can
be used for both sites and looks cleaner. And VM_BUG_ON_PAGE is replaced
with VM_WARN_ON_ONCE_PAGE.


diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index e8ef227624efa..f021d2df99404 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -471,9 +471,10 @@ static void record_obj(unsigned long handle, unsigned =
long obj)
 	WRITE_ONCE(*(unsigned long *)handle, obj);
 }
=20
-static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc)
+static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc,
+						  struct zspage *zspage)
 {
-	return zpdesc->zspage->first_zpdesc =3D=3D zpdesc;
+	return zpdesc->zspage =3D=3D zspage && zspage->first_zpdesc =3D=3D zpdesc=
;
 }
=20
 /* Protected by class->lock */
@@ -491,7 +492,7 @@ static struct zpdesc *get_first_zpdesc(struct zspage *z=
spage)
 {
 	struct zpdesc *first_zpdesc =3D zspage->first_zpdesc;
=20
-	VM_BUG_ON_PAGE(!is_first_zpdesc(first_zpdesc), zpdesc_page(first_zpdesc))=
;
+	VM_WARN_ON_ONCE_PAGE(is_first_zpdesc(first_zpdesc, zspage), zpdesc_page(f=
irst_zpdesc));
 	return first_zpdesc;
 }
=20
@@ -828,7 +829,7 @@ static inline bool obj_allocated(struct zpdesc *zpdesc,=
 void *obj,
 	struct zspage *zspage =3D get_zspage(zpdesc);
=20
 	if (unlikely(ZsHugePage(zspage))) {
-		VM_BUG_ON_PAGE(!is_first_zpdesc(zpdesc), zpdesc_page(zpdesc));
+		VM_WARN_ON_ONCE_PAGE(is_first_zpdesc(zpdesc, zspage), zpdesc_page(zpdesc=
));
 		handle =3D zpdesc->handle;
 	} else
 		handle =3D *(unsigned long *)obj;

>
> With the above VM_BUG_ON check change, please feel free to add:
>
> Acked-by: Usama Arif <usama.arif@linux.dev>
>
>
>> diff --git a/mm/zpdesc.h b/mm/zpdesc.h
>> index b8258dc78548d..4fd81c2e80769 100644
>> --- a/mm/zpdesc.h
>> +++ b/mm/zpdesc.h
>> @@ -26,8 +26,8 @@
>>   * with memcg_data.
>>   *
>>   * Page flags used:
>> - * * PG_private identifies the first component page.
>>   * * PG_locked is used by page migration code.
>> + * The first component page has zpdesc->zspage->first_zpdesc =3D=3D zpd=
esc
>>   */
>>  struct zpdesc {
>>  	unsigned long flags;
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> index 8204b76f78308..e8ef227624efa 100644
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -290,11 +290,6 @@ struct zs_pool {
>>  	atomic_t compaction_in_progress;
>>  };
>> =20
>> -static inline void zpdesc_set_first(struct zpdesc *zpdesc)
>> -{
>> -	SetPagePrivate(zpdesc_page(zpdesc));
>> -}
>> -
>>  static inline void zpdesc_inc_zone_page_state(struct zpdesc *zpdesc)
>>  {
>>  	inc_zone_page_state(zpdesc_page(zpdesc), NR_ZSPAGES);
>> @@ -478,7 +473,7 @@ static void record_obj(unsigned long handle, unsigne=
d long obj)
>> =20
>>  static inline bool __maybe_unused is_first_zpdesc(struct zpdesc *zpdesc=
)
>>  {
>> -	return PagePrivate(zpdesc_page(zpdesc));
>> +	return zpdesc->zspage->first_zpdesc =3D=3D zpdesc;
>>  }
>> =20
>>  /* Protected by class->lock */
>> @@ -848,9 +843,6 @@ static inline bool obj_allocated(struct zpdesc *zpde=
sc, void *obj,
>> =20
>>  static void reset_zpdesc(struct zpdesc *zpdesc)
>>  {
>> -	struct page *page =3D zpdesc_page(zpdesc);
>> -
>> -	ClearPagePrivate(page);
>>  	zpdesc->zspage =3D NULL;
>>  	zpdesc->next =3D NULL;
>>  	/* PageZsmalloc is sticky until the page is freed to the buddy. */
>> @@ -1001,8 +993,8 @@ static void create_page_chain(struct size_class *cl=
ass, struct zspage *zspage,
>>  	 * 1. all pages are linked together using zpdesc->next
>>  	 * 2. each sub-page point to zspage using zpdesc->zspage
>>  	 *
>> -	 * we set PG_private to identify the first zpdesc (i.e. no other zpdes=
c
>> -	 * has this flag set).
>> +	 * The first zpdesc has its zspage->first_zpdesc set to itself, no
>> +	 * other zpdesc has this set.
>>  	 */
>>  	for (i =3D 0; i < nr_zpdescs; i++) {
>>  		zpdesc =3D zpdescs[i];
>> @@ -1010,7 +1002,6 @@ static void create_page_chain(struct size_class *c=
lass, struct zspage *zspage,
>>  		zpdesc->next =3D NULL;
>>  		if (i =3D=3D 0) {
>>  			zspage->first_zpdesc =3D zpdesc;
>> -			zpdesc_set_first(zpdesc);
>>  			if (unlikely(class->objs_per_zspage =3D=3D 1 &&
>>  					class->pages_per_zspage =3D=3D 1))
>>  				SetZsHugePage(zspage);
>>=20
>> --=20
>> 2.53.0
>>=20
>>=20




--=20
Best Regards,
Yan, Zi



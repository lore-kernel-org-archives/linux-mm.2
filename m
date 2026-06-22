Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE4BCDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485C16B008A; Mon, 22 Jun 2026 19:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45DA26B008C; Mon, 22 Jun 2026 19:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FDE86B0092; Mon, 22 Jun 2026 19:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED23A6B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:27:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6647F1C511C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:27:31 +0000 (UTC)
X-FDA: 84909137502.07.02AC837
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011029.outbound.protection.outlook.com [40.107.208.29])
	by imf17.hostedemail.com (Postfix) with ESMTP id 73E5440007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:27:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TV36fMNu;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782170848;
	b=xerD5DUxt+yvLkI1TNxMpAd+b7CJ8XSJpbjqqW5P7Vc8URqh/j++GDSUq7eEaW9+IzZ+D9
	1baIEh0fE19WXDJTT/6wxIiKwg2kiDruPAPJWAwCK2+O8kW/ZarlljRqKHmj5An1EJADbm
	Ui3iCU+Wftwi6cA4e4llNpFQ7DNxm5k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782170848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tl0FxxTLApGO2yYYxlBD4UH5HLe2xw7zM1N+4f7Qmes=;
	b=pwoZx6og7ymXNgdQDfsKJZhrUxqeuFoUxiEqtWbD4JwkzXf+5huyzR+xcs6dT3mcWyzqPP
	H8S8gCFCFN1Rq8vadvz5A54OLDXfAosg9h5jsu4tTL/sOFGuBteOYh4ZJkLKUDOBND2BJc
	1B1pg3cM6O5DooTWoC07kSdyBZJjU1w=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TV36fMNu;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rrDVVx6eewqcSKJ8/1GqaKSBJj6pfv2SEpDyzAzVPcT/khwLOAoVUu8y7Z6aROdLs2HOiJiISqLtiBsO+oIwqZ58Ia3RQuffFA5/yoXAKpxiQClZSzEULuffAakjFJ4p/vYsjHO1zho8H/O142nV/xuQ4WaQFcoWNzIWyFcD8PPiCOTO/IS6HW/Pn6bXGub3bEHoOuij13z2tqajGEydrgSKv+Nz6QXBzV34dAbVpXpf2KmTUYOPsHKb9l3bozvl/ahye/tHmN71e1G6C8KSrCB8awnIuuHufMt2rrJLPcmZskQBMYXy3Z2/nhL7aGpx3Z8Riflv8QJAt3+8Apub6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tl0FxxTLApGO2yYYxlBD4UH5HLe2xw7zM1N+4f7Qmes=;
 b=VyxNXInmG8bUXXZyoVMSwMacbrGfUe8lCEuyRkHlUPT3pi/ypg9r/b49gJCjlAJjAvaIeiQ23i3R0YJfHuQS1k8HjTGfkpN/rWD2eJRUQq6KG6YH7HB6wYzGdG9cALSmig5Cbl2AqfcN6gZo0rYXSUOdpj5Kk5kPrXhdZAQ9f2gl8oGmZ3BqQaCrdGHcIg5DJBScqr+R+WWAwyCimoCRAxGFmNr1SEYG6lfim7c0iwrA0FW716ClSNDLMmt/iVmfa8vUu1Y+Bc0x5S1zxsxS+ZqYqv4iP9PdxPQUXceMipVW7+frKlruQeoaF7h0z65UDFMi301MDHW5oQnpLWNz6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tl0FxxTLApGO2yYYxlBD4UH5HLe2xw7zM1N+4f7Qmes=;
 b=TV36fMNuKsdUqrGhxdKpQbBgSxHa7f9c7TEA5/e6+d/V84lr48OHN38Oq4AJNsovOaIMwobjiHXzb6Pw8qA3BMRCexivx3QHp1IR/HSuJSx7whklc0QBA020eOl9GLYFGYIoo5vYMLoNsp3Gm7g73cnMY6PaLpDbyvoDcsyQiw5A/Yf+zA7Fe8azOR/NDyXMQo9R48lHVQc5VEIQzKrwN19/FWZ295/jnMm5CdDEWhL2iQxPuYe9SOluLnfxwBWFkx+j5vDp3QfK16C+AYeTft1JU2NptpbGWxNUt+JZ50Y9Jtqh8AQTMbE6HoG00puWw3Df/7Bd3a7BhkOjuE34Rw==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 SJ2PR12MB9189.namprd12.prod.outlook.com (2603:10b6:a03:55b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.20; Mon, 22 Jun
 2026 23:27:23 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%6]) with mapi id 15.21.0139.018; Mon, 22 Jun 2026
 23:27:23 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 22 Jun 2026 19:27:21 -0400
Message-Id: <DJFYU5ZU3S15.2TM0XSBEOB2EM@nvidia.com>
Cc: <kernel@oss.qualcomm.com>, <stable@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Matthew Wilcox"
 <willy@infradead.org>, <syzbot@syzkaller.appspotmail.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>
To: "Ketan" <ketan.kishore@oss.qualcomm.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <jackmanb@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Luiz Capitulino" <luizcap@redhat.com>, "David
 Hildenbrand" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3] mm: page_ext: add count limit to page_ext_iter_next
 to prevent invalid PFN access
X-Mailer: aerc 0.21.0
References: <20260623-page_ext-v3-1-a89799a5367c@oss.qualcomm.com>
In-Reply-To: <20260623-page_ext-v3-1-a89799a5367c@oss.qualcomm.com>
X-ClientProxiedBy: CH5P220CA0010.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::14) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|SJ2PR12MB9189:EE_
X-MS-Office365-Filtering-Correlation-Id: f290bdc0-7dcb-43dc-a508-08ded0b5cff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|22082099003|18002099003|11063799006|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	6fZVqYI59HzYiLiljuYjx6TqKktlCKErJv9uXCYSUBzLjQrEeSA4ew6neZroNmDGdT2WZkIrHrvAJ2xZUxBrOkIf+/gAjazW4P5mEfv1bf0e1s5no4jyi0V0GKSt2vWKUEUPz4YGdIKvpDPeXxCG7AnNAbOL1DoGjp47MoYIHxINoTQF5+zV2Udn4rMk7N56PAY3ddk7Ek14c4Wh7U9NsQcLEz5MQTepQHwlPxCjQQ13Sq3eitOA3oFnn5XyiKXI8wSKwmiYE4143OQlHMQVpzKPIJZ+OnESsKoGR0utGaTjNFSQd5HOyvvaw2F3je6rdkV475ihGqGXBHTs8f4A3cOVif5+4O3AxEJISWOCX09tWICuIF5P4R1smwLRC5ebQ2ju8mZWnYiC4/QcKQq06G/Nh8m5bYMjiizchTB5IWDGQvoK9U/eh7pfoBa8DSl1ybPQTSaEYlRdX35Q/HtAQ3Z0zEn6b0CPDD2povN6E94HE7yNfU7rf7gQqK6fdQbEYkFOQFzQWLIEJwEw+CV9cd1xNQ29noQKGiEQSQKQkp5xu4vHb70fqIWQKWk26sabvh7W9oQinNYRRMINPhwk4THqXQSuf2rUK4uQlQdYK4Ttk/y+ERSjInk1VtWHeyiywXdb2Vky7P60F6KCKEAIzym1jxSgm5/ISXMd3esxjuc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(11063799006)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDF5bWhLVTRmcEtmWHpTSDlvejYxVDNjTmdJMW44S2M4Y3BDM2dSdVFmczQx?=
 =?utf-8?B?OWRRY21iVHJyQnJrVS9UUFAzVTY1ODIwZS9CSG9sQWR0cjJGUkJHTGJPTGNl?=
 =?utf-8?B?aDg1cjhTM1YyRFVvVFFudXFkMVpFQitONTlmVVNKSms4eXBaN01xdktaYS9U?=
 =?utf-8?B?cGFtMzFtZ09ERFllaFoxMXhETFpHK2RQbWNMZFp2VTMwYVZGdXh2VUR5TU5o?=
 =?utf-8?B?N0lKdXJOdHFhVllXNmZuVEFoYjlHZGRmMjQxYXgwanpHRGxBU3B6U2VxcFJJ?=
 =?utf-8?B?Q3k2SEhObHJ5YXJvWTRLVFlkczlHVnJXTXZjT25WbTJKUXY0djVaSFNuZXRn?=
 =?utf-8?B?OHpsejdiOFhya1RJeTlMU3doenY5NkNERTMwdjV2c0NRODF5WnFCc3hObUh1?=
 =?utf-8?B?ZHVvcS9WOUxZUThNbFk1WUs3OTRTZ3VpZytIa2p6YkVWT0x6Y2RFby8rNnQ1?=
 =?utf-8?B?VjNtWXFLZm5qclRYNzNEY3g2QW1kTEplbEFOUGEvVFVsOERFWFNxQVBJSCtu?=
 =?utf-8?B?TDhNT29jNzBwcXhWV0RVa0Q2Yi9vNDlrZ0FmdER3NE80TDVEUEpxRlB1V1pI?=
 =?utf-8?B?dU1rdmU4UHpsTE9BZkh5RjZWanM3TDA0N3ZFMzRNYUJZSGl5bVJrTXpRZEFC?=
 =?utf-8?B?bGpyK01CR0N4RktrSlJnYkxyd3REV0RkWWFNaFpPVlNQUnBwYXMwZzZsZkNy?=
 =?utf-8?B?eXhjZmdJUnIrSk95cndQTkpYQzFuQUtxZ29zdUFhNnFWa0pLZ2paNlNLdGFo?=
 =?utf-8?B?WU1yK01Jemx3aTZVcTdtWENvd1MraDdGYnBPT1V0NTN3ZkZRNkFzeUh6dkNF?=
 =?utf-8?B?ZnZORmlKREJtaHFaQ28vdHdoY0kvZjNhUDcwUVdtNVh1MXBxOUxkN2Y3UTBl?=
 =?utf-8?B?QWk4YVVscUFVOUZMTENkZGJ0VjFSOUpud2VyMlNLWjZreStyR293L3JWbGFK?=
 =?utf-8?B?MkwwQ1VrZlo0ajlNbEI0dzVOL0hiaU1qQ3FCVjhlRHI4SDJ6SGRBeG5TdFFr?=
 =?utf-8?B?b2sxRzdoa3ZVeXVSa21mNE9ZWDlIWksyQnhob3I1T3NKQ3lSazBLeVBVSUI5?=
 =?utf-8?B?VnBOVGdwdjg0dUdzSVZZN1o3MWd1YzBFcTYwV1R6SVNwQ2Y1Q25xRnl6UFZs?=
 =?utf-8?B?aUtzTGI1a3FtQ1VFZUVweUF3N0hlbHVvRXVRMG40cWQxeFVaTTExekp1T1VS?=
 =?utf-8?B?cHprM1huVU90aG1KVXE1SXZPU0Z4QzNyVHQzRTdKZEdjTEdPVnl2OUlNMkZJ?=
 =?utf-8?B?YUNkSnJxaU1HM2RNOVZCak9yaG5FNzZXa2RaekE1SDV4dlZHazJJajBzcFIr?=
 =?utf-8?B?V2syTVNRREVvYTlSWXh6a3JxSWNZK3pSbW56RGREcnppeTJsc2g1TitSTVBO?=
 =?utf-8?B?VnJ6U1RGUmR1cHhsRXg2eFp2eXNadUNrSXpYeENkdlJibE1jdkFxT0hQL3ps?=
 =?utf-8?B?am43MTNCTTEvZTc1R3dMS3lXT1l6SjJmaTQ2RXB4T0ZieWVkU0svaUhQejNQ?=
 =?utf-8?B?UHB3NDlFSXpTcWVKNExZQUc4TVhyT1Y5SG9KMFpBVitjVWY0T3dmRzRRM0VK?=
 =?utf-8?B?V2JIck5pSHpRL2tzenZqZVV0a3l5MlJHbHhZVWlVa3hCUDkzei9uejN0a2di?=
 =?utf-8?B?WE84MFo0dktubDZVa2t3TFNQTTN3NG90UGwwNWpndzlqbjRIdlZDbTdyakxo?=
 =?utf-8?B?VWlMdTQ3Rlh0RFRFMTlzYUFJSjhrK3ZSYUxWZUZldW5XZVh4VENXcFB6TlBw?=
 =?utf-8?B?V2I5WUN5OUd0SW50R0dreEdkd3JsWXgxbzI0Sk16RWxzL1dNcG02WWYzZkV3?=
 =?utf-8?B?cmFxaFZPdHhBQTB2Wk9Sa0NYSDd1ekltalc5V0tnQTNYbWordFA4Mk1CT3I3?=
 =?utf-8?B?R1lRaUxTL1JMZVZDU1dBVldHZ1NMRmZMU1hNNlUxWm0xSHBxUW1FOHoya2FM?=
 =?utf-8?B?dG1tV2s4SGMzcVMwd0J0QWlqeENoMGpIQU9yKzZVN0FnMHJXVkFsWllTOEVm?=
 =?utf-8?B?V1lrTDl4amk1aEpBeFpETnZWK0o0d2g5cFB3Vk5nQk8wMGl4Zk1Fa2NMVG1K?=
 =?utf-8?B?V3BYTmRRUUx2OTZGMXIvYkRTcmNTK3BhbGZZd2k4VG4wOXExbTZmL3dFYXdM?=
 =?utf-8?B?WlJvNkJEWXZpZWlxU1BmbkFXSGZyNHk5Q1UvVlpienhvNEZUZUtZMFJJajcz?=
 =?utf-8?B?U0g3RVV0L0RmRndzdnVtWFhzczE1L2N4c0VvMWJ5R1RmVEJjS0dEak9tczRv?=
 =?utf-8?B?dVpQcjA0UjAyY25qOHlOWXdmYkJqNm5JeWlPekVwRmVqZDB2OXdOTkN4RWo2?=
 =?utf-8?Q?GBxcdyTrE5/QPMFpHT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f290bdc0-7dcb-43dc-a508-08ded0b5cff6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2026 23:27:23.1306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Po38ii1wB64rInrDvCyAX3Ykl3rnAxu4KM9rLQ3riKpj/nVJCcVijxGiOczNmKl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9189
X-Stat-Signature: j9kzneg5s9b9ngy3ors46bszb5mnfch4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 73E5440007
X-HE-Tag: 1782170848-654097
X-HE-Meta: U2FsdGVkX1+eXLC/e4syAic7tnL6O4C4i0l5myoLCMOTZynpe5iPizDa8P9TBorINmouyV5uYeDIQzoOZMTflGM7vtYTAAZea1eHomUtEOHunIjS8HeReLPa7NYx+dpD0HzArTUqkqQOboRlclEB8/8+Hp5ls4yn9XOiPglI/9QMhfD57G1ZhSV7l8QxDPZ2WH8+vNmwNpLZjhxEDutqfKxE9niqdT3dLYDktwYPke7d8CrAa7mckrb9DJw2otof9XRmkmLRtBX2cmt8wVi6qJjQwDdtUDcExZEeVlH/EdeDaaWp7BcdzUQ2hkXXee740j9LkUEs6Vb/9R9mpdfDE7YGSK+/yysPush/tafv1st+O8sSbPH913h7zGjZ79lD4hG6p+t6OPLQBMly4GMAIh2YHrxg8pv0w+PRpLlzIt3IoMjGvfV9B0oxNTL8izuPNV6t5VzgHPRofOm9L7WDfEOm/d4GUu1JzDC1rPQxdGijY/5605FLOBwz59jRssd4R+ZpFCsu4nVuZ2SCz5JLjDG+5SpuaS8mlJXvFfzU7qY3fw+GtIbJECR8nM2nHGh5iU0OtaVtD5wY36upsSNrJ513//APJ5ybGJPTMda2PyedNzO16nE1r2sjILNoifiol3CDL1LKR+ocK+CkLxa91dfyqKaEUpPB/jSLpoQQ6XcDbGNd4wGUvpFA51Qpqbg3CxPtL1Z+IMFsxb0jA2vd8v/hc2a9bS233tqMVlKsPqODvJxX8A+TFdIX2Dzy88ibuvac9p9DzQZZs8dNo8nEcOPrRlhsCS3FV2HYSeATal3APLq9I4C6/3MMFOMO9wSSGfU0auQW/ObVG4XoLux1P0tyfXEPRTP+SQcRXxvQ4wGGGS9GcBPcPNNZLbM/lvgfJWuR1xzaghOpJIZkl7vYJkFJ3OnVQ9cAWySkTYby2vVxA1MNNAfORUt/X61aXMl16+NgEH2DY+atgmfYNeg
 ZJX/czny
 cpKwhvgmj0x+3tq08V8BnPK0asvjzYnhV4dl2bhrNEocyowro8a91yr9buAKb2GJCtEzRRNm8nzXN69mUNyKh8cEtICCJaC59nsUjyOMymdERP5cDGZXb8yLXzUKSG3cBksw6QISKzB+7N2rv/sPSeQPqGvJl1Na18bXVXH+OugLlvnyxnsf2XSpImQBXYaZe8zex92+X3RcsSLOMwtzzdE71EeaXVEsgHo7WBlkADVPiJA4gJl/EAY34lxWlQ27m1C5B/6VTXgytNcLY0wco/D2tKt2a5hFn4zADK8ijd+c3BL3T8sQp7aRwYqiLYgBme4cOvCKu3VE8cdoyRRsJJG38BqPWEsKFfOlW0iSouLQDHwf/nLj2fLdcGtVs0Wuee0PD1CC6vqrZJ1M3ezLN1lPZm7ElOcZtmrz6xFp/1euttc1z6Mno/m/9fSJXpv9MaGjjV/8enk0xLpFGqsu1axWHAU1RBarmI2rg+/IbcX8CG9k8IictKTsF+LwVu+ofVoO6O6AbClxS9mVD29dDYYsxwiGl1aYKlcn9YvJPRSbWRoG7KYvUdi28RN1+My7wNQRXZZrJKzwXQgqWKDA04v0mT/iVKrcFjPSNi4bHLKWxTx/Mv3cykB5qQ/TgrMgWqMHqRpJ/Ni+7LaHgtgcB7bk64KDACT8UKqtPbRZoTdVQj4aU+nxFYk1srf2hynGKjiJnSUZjI99DlVvfM7yuwHh61Ffa7VPhX0ryfjNanDg2GFE6GdIxd1UHJ/+S4IZYcrWqe4cDy8XZOct1iFOz1EdBcjYkVd6VmbIuCyoe8RUXm/dq8qIB/ZvrLCsUumcHp8i12MvKSEyQYOf+SUMLbW9q6L3/P6/MDvipGxjJJPSNRbrlVzwOOYpiLutcQ6oQJUM5d96qJNXiapUlYZAlKzTvZ2TcBb3htK5U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 22, 2026 at 5:18 PM EDT, Ketan wrote:
> The page_ext iteration API does not validate if the PFN still
> belongs to a valid section while advancing the iterator. When
> dynamically adding memory in the hotplug path, it can lead to a
> NULL pointer dereference during page_ext_lookup at the boundary
> of the last valid section when iterator count equals __pgcount.
>
> The for_each_page_ext() macro calls page_ext_iter_next() as its
> loop increment. for_each_page_ext() does a
> "__page_ext =3D page_ext_iter_next(&__iter)" at the end. This
> causes page_ext_iter_next() to increment iter->index past
> __pgcount and call page_ext_lookup(start_pfn + __pgcount).
> During memory hotplug (online), the PFN at start_pfn + __pgcount
> may belong to a section that has not yet been initialized,
> causing page_ext_lookup() to trigger a NULL pointer dereference.
>
> [   14.555124][  T846] Call trace:
> [   14.555125][  T846]  lookup_page_ext+0x6c/0x108 (P)
> [   14.555127][  T846]  page_ext_lookup+0x30/0x3c
> [   14.555129][  T846]  __reset_page_owner+0x11c/0x260
> [   14.571201][  T846]  __free_pages_ok+0x5e8/0x8e0
> [   14.571204][  T846]  __free_pages_core+0x78/0xf0
> [   14.571206][  T846]  generic_online_page+0x14/0x24
> [   14.597782][  T846]  online_pages+0x178/0x30c
> [   14.597784][  T846]  memory_block_change_state+0x284/0x32c
> [   14.597787][  T846]  memory_subsys_online+0x4c/0x64
> [   14.597789][  T846]  device_online+0x88/0xb0
> [   14.597791][  T846]  online_memory_block+0x30/0x40
> [   14.597793][  T846]  walk_memory_blocks+0xac/0xe8
> [   14.597794][  T846]  add_memory_resource+0x280/0x298
> [   14.656161][  T846]  add_memory+0x60/0x98
>
> Move the iteration boundary enforcement inside the iterator
> functions, so callers cannot inadvertently access beyond the
> requested range.
>
> Fixes: 9039b9096ea2 ("mm: page_owner: use new iteration API")
> Cc: stable@vger.kernel.org
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Ketan Kishore <ketan.kishore@oss.qualcomm.com>
> Tested-by: syzbot@syzkaller.appspotmail.com
This is probably not needed.
> ---
> Changes in v3:
> - Fix the iter->index++ increment to pre increment(++iter->index)
> - modify the (count =3D=3D 0) check to (!count)
> - Link to v2: https://patch.msgid.link/20260622-page_ext-v2-1-135d4cfbc42=
f@oss.qualcomm.com
>
> Changes in v2:
> - Incorporated comments from David and Matthew to check for invalid PFN
>   in page_ext iterator rather than checking for NULL section in
>   page_ext_lookup.
> - Minor improvement in commit description to include the issue with
>   page_ext_iter_next
> - Link to v1: https://patch.msgid.link/20260617-page_ext-v1-1-37ad802b1a3=
8@oss.qualcomm.com
>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> To: "Liam R. Howlett" <liam@infradead.org>
> To: Vlastimil Babka <vbabka@kernel.org>
> To: Mike Rapoport <rppt@kernel.org>
> To: Suren Baghdasaryan <surenb@google.com>
> To: Michal Hocko <mhocko@suse.com>
> To: Luiz Capitulino <luizcap@redhat.com>
> Cc: kernel@oss.qualcomm.com
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/page_ext.h | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>

LGTM.
Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi



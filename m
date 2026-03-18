Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 565AE103E195
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861896B026A; Wed, 18 Mar 2026 11:03:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811B26B0269; Wed, 18 Mar 2026 11:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664F96B026B; Wed, 18 Mar 2026 11:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 562946B0269
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:03:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3BC313BB18
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:03:17 +0000 (UTC)
X-FDA: 84559502034.30.7F67CAC
Received: from GV3P280CU013.outbound.protection.outlook.com (mail-swedencentralazon11020135.outbound.protection.outlook.com [52.101.75.135])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9172740021
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:03:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of andreas.larsson@gaisler.com designates 52.101.75.135 as permitted sender) smtp.mailfrom=andreas.larsson@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773846194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r6ZTtq4nXRk6+KhGJu/weqPZ7z4ays1SpgVejxGvxGA=;
	b=i4VXGSU+Xy9AzUJWrd4vNvRyv0rUf2GVwQRRRFkPzvYkqP1oSDpKyfkb4pGOLSCvgWcaZv
	Bk0n28hTGkZPREvcx4CRf20EOOG9mtywBwZXsvUwN845BY50VQjR9zykXruN87Ga/ID/4Y
	O1Z9SeA60kqr7gwDkui+aV/NOZUk4Es=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of andreas.larsson@gaisler.com designates 52.101.75.135 as permitted sender) smtp.mailfrom=andreas.larsson@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773846194; a=rsa-sha256;
	cv=pass;
	b=4hw6NDEEYcoF1ieknpQPfAMhifppjPqJ4nkgPH7OwTdcqjyhe2FzNkzXNLrMOeA8S9hUpp
	mVNGQbQRjKr/tWpE5YMpjGh695Q3kxe6lChMvNKdIJOmQroGl/GymCeIXCuVJIRgfA2A2k
	kfAC21iRdhCH7HRy96CTicSciWqjkY4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I5kv/AOeKY0Ijm1H8eZJjjgnPSbZHH2dCk+QH2KD+hdIYUorUxc//wpffMYXhmv7njNjM+rm50CbAGuZzRWExNJCCIqwi4eo02su3dc/hzkJSe5qLYn5/O0jV0T/5ZYGcR/mR+h3ffpiBRo6Kbxclf9yFGhhkEWL2OCJoSQRVVEIwslZs+6BtqNsmNOS/Est/lxvy0tKw87cjxEGI2pxCecICp2+HcLD+kjsLph1JuqaFCJKO0wfwaIkgfUn0l0XiWMVZFF1dwYfKVTgsyQZFKS1ErqPw9G9rQVDqcmK3hsTJbKUT1/SDLt4Al9X6sGNW28DZovH6npW2xqXS7W3xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6ZTtq4nXRk6+KhGJu/weqPZ7z4ays1SpgVejxGvxGA=;
 b=QUfHzjnhF+mVBQBnOhU2eJq2gM+Ofl2JQh5gpNZky5Dmkq0J/llU3jXocqKcEaA7N7R4Or9/3u/ZD8yIdz0lF45C4ifQuaXkbFISN4JilbgdvNFtVIh++CqM+jPsQy2wAQUo3zo/EhBbtsFpEmboipld2ENoSxaVcKpUp9Ii1sZ6a3K1pMqpBgNUAvEA8NduwaeroH0MBW53Ae0j7LxR3VCAwYG9kKaDmd6izL7+85mcFKm4DKiDhBcVSAk/eheZ7Ja3PrRnJD9ZfDU2ImK65bcPKev93SKPU0hZ+tpJn94LIq6AupMixZ+GA4icHv3+VSowOpbib4HjHPcUDB7uIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gaisler.com; dmarc=pass action=none header.from=gaisler.com;
 dkim=pass header.d=gaisler.com; arc=none
Received: from GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:195::18)
 by GVZP280MB0010.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:49::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 15:03:09 +0000
Received: from GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM
 ([fe80::be76:7636:f4ac:6773]) by GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM
 ([fe80::be76:7636:f4ac:6773%5]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 15:03:08 +0000
Message-ID: <0f67e5e4-5331-4205-9bed-3e43104fed11@gaisler.com>
Date: Wed, 18 Mar 2026 16:03:07 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
To: Chengkaitao <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com,
 dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn,
 willy@infradead.org, zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260111074453.66728-1-pilgrimtao@gmail.com>
 <20260111074453.66728-2-pilgrimtao@gmail.com>
 <aaf30e1e-be55-4212-b096-69f71bafd406@gaisler.com>
 <CAAWJmAYmMtdE7nSJ8BWSnt2DObipqGi_KdXdMJrHfwc0ANBSPQ@mail.gmail.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <CAAWJmAYmMtdE7nSJ8BWSnt2DObipqGi_KdXdMJrHfwc0ANBSPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: GV3PEPF0001DC31.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:400::10d) To GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:195::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GVYP280MB1290:EE_|GVZP280MB0010:EE_
X-MS-Office365-Filtering-Correlation-Id: d61c7ff7-7892-4d5d-68d0-08de84ff7723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	x0mqh8EoU+D2h9AOxsp7/fJ5A7qiXRv40vv9tJpY3WChtox0pMqPiCfatDHZFHVM0quLI6299deDem02GVPlyKkxzTwd2ojA6UAHfy8p2Li2jhYyXbRc7KbmFCuasPJsj2P1evd5XP3N2r9bi0OR3v/h3XCnMj49WRUlTLJWefjp0EtFdvo+CTxLPVC52KSPi0UxPqAEaTp4CmcfXD6+JgtMQwHIW7UnNZFSSzyU1Tl/11s0zHpexppmRlsFYSwSc+le+irp6TzmP1IpIwYHA3A8f9E3Z03MrraA1NIm8GgDHKMMonv2030DdOJw8rXu8vN6UFwPZ2DAvO+tgJr3OXIcO+pFnGGzGQlR4TOgtfywchY2ZXIu4hhieK/Y2Qpv148Usu3tUk6SIMPHe0Ekad4uP6StA+xCSeKibqyThK/1Yp1eqfMBtLn+qFiI+mbStNL7UJ6ZAlfLi3tVVhyAmkY+NmuFonixHPCfbLS9el+3/kwE5WGi+UR2ZIK7Km8poQbOpCjNgPl7vmNZaEwi2htL2Ye74xHk3J6FnKKS1IMjaQC8c2CXArdITbKBNjYZiGdtAWX3NM+CzXcrHkfxMVEmVxM7n5BPyyHxVqBVXrWPEC9MmMLqCZR+nk2eYykOhEZll2GkvV/tFBMrubfLb0sk/4RYtbnEOygZytlCwMYlONob1vrRk31DQ4PuKxR3SvfYDV6YTsleGCJmCBRfa6xKPLDjFpfHxC0x4zmY3V4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VlcrVDB6WTVWVG5LUHVwOXA0RzlJUTVtYVFBNDFycjJsV2l0NEc3V2NKa1gv?=
 =?utf-8?B?QmdsMi9KU1FsWFpLVXIyUDNQalBXYnFTMlZuMW11anQybHdHZ3FZQnpwY1hK?=
 =?utf-8?B?THZpbWc3MGhVUG5VOTZ3YmNyUXozMnZNUUZOZU4yZ3VNMWFPSkpBTG9XOTV6?=
 =?utf-8?B?NHFlK3FXNVEyOTlHc3FTRGVOUVhjVkkyaUlyZ1pDdm9HUGg5dFNmM3UzOVNp?=
 =?utf-8?B?TlNORXNreDZheVVQRVZXcFhDNmp2N1JRTXlwSG1FWkl6Rm1sN2Noa2l2Q0tk?=
 =?utf-8?B?UVZpWDJkTS92YSt1K1NJaDBtQ0pYZzRNRTQ0TXBvQTJUaDFYVFh4MmFwbDEw?=
 =?utf-8?B?ejgrc2ExS3BxNzZ6L09EcE9aN1JuakxmRVFXTmhOdmxXaGt1ajZUbEduRFN6?=
 =?utf-8?B?amtCZllLa2JDTkdwUDk1UFo3ek5NTmdZUS81NVRqck05UDNyMks0S3N3ckI2?=
 =?utf-8?B?dnBQcWNoVXBZYlVEYVlOQ044VjZydFZQb2lKd29QZFM0Z0xWSVB5Zk5KRkFU?=
 =?utf-8?B?bzFwVUFFelFDdGN0L2tnRjc1aHBtd0ltTmkvMlV2Q00yNTNTNE1LN2ZEaWhN?=
 =?utf-8?B?UnFFQm5DdWlYUHZId1VDUSszdFNIUlJvM0F6MktKS25Lc0paQURSZCtSSnZL?=
 =?utf-8?B?cXM0VVY4ZUhhZ2xIR3RDR083T05YRTJLendhb20xYUsrQ1hDazFnKzVTOURs?=
 =?utf-8?B?cjNKK3BNTHBTa0I1UUNYdlU3TitTRVlxY0R6a2YycGgwQm9NSkJhRHdhbHhh?=
 =?utf-8?B?TnNRbjdBQ0VqZElBRE5WUlJLZGFYb3JYYmNBVmpVbXdaNEFpWXAxWXFkcFhW?=
 =?utf-8?B?ZXRwemoyM1NoQ2pzclFmRWFsQWxycmNOcEdCcjNnZkQzUUV4cUpEYXIrNHZh?=
 =?utf-8?B?RVhMMlRZWk5paWNMeDdpWnZkN1AwaHF1VjQyTXJveFJEeCs5UlhuNFhQUlVm?=
 =?utf-8?B?YjZZNm81OEtXeWVFdkFuYTYxdzVZK2VpTGM0SU9PdkFwOE9BZXZGbWltbktR?=
 =?utf-8?B?Q2JaTW1xS3JQbmNjK1VER1R3ZzRlRXZIc1hxWVg4WVZLRnZ5VkVFUTVUM2pD?=
 =?utf-8?B?YnBzRjlNaW5LaG42cTJ1cDltOEN1TVh2V1pzSDRXQ0ZXbGlnbFh6T1BqZUFs?=
 =?utf-8?B?cTVuQ2dBbHA5cVdhT25GT3JWdk5hbTRMMWhmOUVYM0htL1l0UjZFWVZQcSts?=
 =?utf-8?B?dyswa0JReFBvVjBKcmRrZ2FnM0VTeXpXQURtMWhWTUdBb01yNlBRWFliVWhi?=
 =?utf-8?B?ZnUvQXZ1K3NOQTlHS0ZZZWVOb0dIRXdKM0FwK1Y0aUlZbHltODcwb3A1Z3lY?=
 =?utf-8?B?NVdTOVI3UVhubW1GVytDbXh0Z0wxWTFTUmsva0tXTnhhQ2l6NlFSaytsZHlk?=
 =?utf-8?B?Ryt1NXNlWSsxSk55L1hGWndxb3hjZjdKSDhWRmRWRjZqSjA1OFc1MTN5alVw?=
 =?utf-8?B?MHhvUmpIZm1YU3NsMGY2MFU0OSt1MjFUZWZmYkVJdHY2UUNmeWlFclI1N25S?=
 =?utf-8?B?NTB4NTVLbXpMTXR1d0NuckZIc1J2RnZpd2hwS09rK29HUk9uZVlpclVLMHNR?=
 =?utf-8?B?Vk5taEpNV2d3Q2RmQTN2TzUyc2VqZ1l4TUhIUGltVDFaVGZYVnhEVnZnUnc0?=
 =?utf-8?B?cnFUWWdKaHlXbHYwZVJ1c3FYblhIVm1HejhMMUpmaFZaMFVRaWxkTXk2L3hp?=
 =?utf-8?B?NkxjSzI5cU0ySnIxS2FJQ04zRDRhY1BIRzBUaFF3SFA2YlNVN3NaaU1CY096?=
 =?utf-8?B?Ym9xR001eEhOMnpDTSs2MGNCUHJMdmF6K0pBVGJSNUIyVHZuMjIwd3VoL0Yx?=
 =?utf-8?B?TzNvbUx0NEtWUUlCYU1MSUlSaTVYY0M5WGhyS0JaL3l2ME4xaHlwYmg4UzFk?=
 =?utf-8?B?OEpVR1Y3UEN0TmdvNXpFZkIwOEMvWWRwY29UWmliNXBicE85UmNHamRQTHVD?=
 =?utf-8?B?MVM3S0w3SDJ0dy9OdmFyL1FHYWQxT0dRell2U0R5Nm9rMjBHODBuWWY2NEM2?=
 =?utf-8?B?REkzZmZYckRIR2YySSs0R01lMGhmbDBrNjY0VTc3YWhDWjloenZ0MUN2Z1BS?=
 =?utf-8?B?K3R6NnJ1cUxXdlc5UThnMGd4Z2N1aENDeHFod05HSVd0Ykg1RkVOMnY1UTM0?=
 =?utf-8?B?VnU2V0p4QmpwQnVsTGFlTlh3aGRsbEhtZG9NVUJYM08zakRHbmxhK1pKTDdh?=
 =?utf-8?B?RUNZbUlvQkpGVG1RckZyVGloYWlBaWZkL2w1SlZzSUFxNjl6UnVYdXdZQWxt?=
 =?utf-8?B?MEdJSGdvY1pPekxUeTUwbHNOdmN0KytJelF3UWlyUEkxTDl4SjkvOXZhUmFr?=
 =?utf-8?B?NStYTXdrUktFRmxyR21rRkxoSVFIQmJJTnZqZnhsNmtpdTc2VnU0ejczYmNV?=
 =?utf-8?Q?wV/w0mN0qo3w2Spo=3D?=
X-OriginatorOrg: gaisler.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d61c7ff7-7892-4d5d-68d0-08de84ff7723
X-MS-Exchange-CrossTenant-AuthSource: GVYP280MB1290.SWEP280.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 15:03:08.5820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 91fa4a59-2167-458a-8318-e45d80469d7e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hq9j07x+PHRGKLKmcuuv6UAhJ9k6lWj+wmFjb16qfopIREn06aXR9OQv968MKdUzSPFYGa6F6TTjw/p6aMCi9IdvbpNQyIrIfGFBE82r2ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVZP280MB0010
X-Rspamd-Queue-Id: 9172740021
X-Stat-Signature: sszosood4hi51pcu9zxefj8uwtq9f391
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773846194-950337
X-HE-Meta: U2FsdGVkX1+UeJpIaFxIdHq+TK/eM5rR1x3WrNSau7o2/H+AfxDea8umAUWRQ//N726qE7SF4QQQrBCAB9sZS4Ua7wDQ8TaAlSrog2DWhBPf9ryC/Z/ycgC0iTqjemiMey4cMj71/npu8y3XtkGY0VJmm0MEH18xPAE5nu8LhvM5KIs3vtwBGOvBNYMAAmj1VBx3GavB/v0f14kODBOu76Y0zhIPBwgpBrn4/+V4H5ykFT85GqgTTbs6f3pKOSq51AM0wrnklC6boVbmW7N8J0VOQvntMBqOsLBETK/shQeEv3KKZkJBPC5Dkcr+aNO9fHDgYEPbI01IWfdLodKSgHXoptnFZFA+EtdjjK1hXfID9qF1eFkxYlf1iiv3VRvlIaAWSzwhELH4MWKnz4k4krzVulEV0kRxrYuu8BwQOxuXuRpvUM3ir9Zl8uVIYR+vwqhVoBXrUAbOkV5ua+brRKOaqt1qdJFxqoDw8ZgTBFGaKWsGHHTZ/b9B+S5pd6QTaiXWJR1hYsBHhxH+sY8e6wqECsXtz9T9lGsyJcpNmrFVndDglyUacf4+JW6JeHOVec/4IyMfozn/GGW4Eg3Zn4lVImxrQfsEZlYNnR2ujyViiBdVWYomDTAohF7zxWTEpUilweZaWrNbpagP9K9Iromr7gBVOueVoIZMlF/MvppHZ3VcJOSHv1mBHGYkg0vgP4mcDk0LLk4j/jMcAr+qPkenR3WT3fMXTo8cWpRJWOB11gC5t4iYYO4ffU/Q10MCIDMqZLNLYTINcdFfqMn6Pq/0oo6T93QQS90OCYfGGlEuxTWPyJ3oAI7Q/SEX2hzStOCuhMvyRWc3DP+Hj4/2jZ1ThDG2cp0HsQbG6OSJXosvSo7oHcSOrSJzbln+niP41fX3+r33f1skajnojEY98Oj2BOBavsYQ1V8b3X5tnUVOWEiqumRQrczhuy4gja3JKsRasOY49xGAsV7yRFj
 aUgZ9GVg
 9492msIrnwJZNa2/y9w5x8IlMKBAHRZ4oJaXm89uYHJQ/iL6puFsMLLR6F18dzi9G45LnXDizvmGf3+INRzq9M5WQOoQ1as9Q00uWwog9txHsq00xBMSX552uZisv4QRikP9zmvO+Q63TGEPD3AedkuC48ytipyYD0mJlEdvDf256xrTvnHalj8VYpdrL11MeGlaKlOW1V8/U8nx5t2YTb9b9NoCVpH7J+UT9hjzFpV8lFtYDpvXjXnYOlDF/4qfyJL6GIE2Bcj+3wmYeGeP9Od1/6ftrnSd2xneRl7TIsNMCwBAwIdZrGNPpPFnJzolHKvOY1SRTf3R+KdQ50JU3/P0XdBRe/dbSMDtBCpx/XdKQpnjIUzP+TwN21MtdOycnB3/bmG4IIZ+5jTu9vxvKJhOflnOry7Z//FnA2/dNXtmVpUehq5C+usKr05gn8rRLkekVhkmLAV+7B6rzX/oJSgSl07hOSQDErhUH8k64KjtRRs9VprCSiL4QwJlCuECm5itm0d3rGPYZX43MFbDsdp9kUWBASEguR0LnYXYD4pDB2GzkWHhFe3TeQzcgmOY+xa62K045N/A9xfAC4ToD6Sasp/IYHzkDpQleFAGhUtd2QyoNViV57EWeag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-28 04:25, Chengkaitao wrote:
> On Mon, Jan 26, 2026 at 10:50 PM Andreas Larsson <andreas@gaisler.com> wrote:
>>
>> On 2026-01-11 08:44, chengkaitao wrote:
>>> From: Chengkaitao <chengkaitao@kylinos.cn>
>>>
>>> 1. In the SPARC architecture, reimplemented vmemmap_populate using
>>> vmemmap_populate_hugepages.
>>> 2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
>>> when vmemmap_alloc_block returns NULL.
>>
>> This patch seems to potentially make more functional changes than what
>> the descriptions gives impression of.
>>
>> Given the amount of changes this seems to introduce, more on that below,
>> I'd like to see more description on the changes and why they can be done
>> than this.
>>
>> Nit: use active language, "reimplement", not "reimplemented".
>>
>>
>>> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>  arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
>>>  1 file changed, 16 insertions(+), 31 deletions(-)
>>>
>>> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
>>> index df9f7c444c39..858eaa6615ea 100644
>>> --- a/arch/sparc/mm/init_64.c
>>> +++ b/arch/sparc/mm/init_64.c
>>> @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
>>>  EXPORT_SYMBOL(_PAGE_CACHE);
>>>
>>>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>>> -int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>>> -                            int node, struct vmem_altmap *altmap)
>>> +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>>> +                            unsigned long addr, unsigned long next)
>>>  {
>>>       unsigned long pte_base;
>>>
>>> @@ -2595,39 +2595,24 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>>>
>>>       pte_base |= _PAGE_PMD_HUGE;
>>>
>>> -     vstart = vstart & PMD_MASK;
>>> -     vend = ALIGN(vend, PMD_SIZE);
>>
>> It seems that this patch removes alignment of both start and end. Is
>> this a functional change in practice or are these always aligned for
>> some other reason?
>>
> Whether vstart and vend are aligned with PMD_SIZE doesn't seem to
> affect the behavior pattern or output of vmemmap_populate_hugepages.
> The vmemmap_populate_hugepages function performs necessary alignment
> processing internally, such as pmd_addr_end and pmd/pte_index?
> 
>>> -     for (; vstart < vend; vstart += PMD_SIZE) {
>>> -             pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
>>> -             unsigned long pte;
>>> -             p4d_t *p4d;
>>> -             pud_t *pud;
>>> -             pmd_t *pmd;
>>> -
>>> -             if (!pgd)
>>> -                     return -ENOMEM;
>>> -
>>> -             p4d = vmemmap_p4d_populate(pgd, vstart, node);
>>> -             if (!p4d)
>>> -                     return -ENOMEM;
>>> -
>>> -             pud = vmemmap_pud_populate(p4d, vstart, node);
>>> -             if (!pud)
>>> -                     return -ENOMEM;
>>> +     pmd_val(*pmd) = pte_base | __pa(p);
>>> +}
>>>
>>> -             pmd = pmd_offset(pud, vstart);
>>> -             pte = pmd_val(*pmd);
>>> -             if (!(pte & _PAGE_VALID)) {
>>
>> It is not the same thing, but is this equivalent to if
>> (pmd_none(pmdp_get(pmd))) at this point?
>>
> For PMD entries, there shouldn't be cases where pmd_none and
> _PAGE_VALID exhibit inconsistent behavior. I've observed that
> pmd_none is widely used in the SPARC architecture.
> 
>>> -                     void *block = vmemmap_alloc_block(PMD_SIZE, node);
>>> +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>>> +                             unsigned long addr, unsigned long next)
>>> +{
>>> +     int large = pmd_leaf(*pmdp);
>>>
>>> -                     if (!block)
>>> -                             return -ENOMEM;
>>> +     if (large)
>>> +             vmemmap_verify((pte_t *)pmdp, node, addr, next);
>>>
>>> -                     pmd_val(*pmd) = pte_base | __pa(block);
>>> -             }
>>> -     }
>>> +     return large;
>>> +}
>>>
>>> -     return 0;
>>> +int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>>> +                            int node, struct vmem_altmap *altmap)
>>> +{
>>> +     return vmemmap_populate_hugepages(vstart, vend, node, altmap);
>>>  }
>>>  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>>>
>>
>>
>> This change introduces using vmemmap_alloc_block_buf() instead of
>> vmemmap_alloc_block() seems to introduce two new behaviours that was not
>> in use for sparc64 before:
>>
>> 1) Using altmap_alloc_block_buf() for a non-null altmap, that was not
>>    used before. Also the fallback to vmemmap_populate_basepages() passes
>>    on altmap.
> 
> If altmap validation isn't required, I can retain the original code
> logic by setting altmap to NULL.
> 
>> 2) Trying sparse_buffer_alloc() before vmemmap_alloc_block(), which was
>>    not done before.
> 
> In SPARC, sparse_init() is called to initialize the sparsemap_buf.
> If the SPARC architecture doesn't support using sparse_buffer_alloc,
> we can remove the sparse_init() call path.

Thank you for the details.

>> Neither the commit message nor the cover letter touches upon this. Could
>> you elaborate here?
>>
>> Given all the (at least seeming) functional changes could you share how
>> you tested this change?
> 
> My original intention was to help architectures adopt more generic
> kernel APIs to reduce maintenance costs. However, due to my lack of
> physical SPARC devices, I couldn't perform comprehensive testing,
> I've only verified compilation correctness based on code analysis.
> I sincerely apologize for this limitation. If you have access to
> physical SPARC hardware, could you kindly help with testing?

Yes, I have tested v6 on SPARC hardware.

Cheers,
Andreas



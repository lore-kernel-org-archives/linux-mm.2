Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471EEC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:00:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E816B008A; Wed,  5 Aug 2026 12:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F256B0092; Wed,  5 Aug 2026 12:00:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0089D6B0093; Wed,  5 Aug 2026 12:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B896C6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:00:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4AA4DA188A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:00:15 +0000 (UTC)
X-FDA: 85067677590.04.37C4322
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012071.outbound.protection.outlook.com [40.93.195.71])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4A35140008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:00:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ewRXtWGY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785945612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1u/G3r2JaX5QaxcioHoI4gyB+Ar4Ocwk1kfs7HTCXW8=;
	b=miSLcHBJFksj+sfdXNCJVXrhHyU6YL7GiiMkZ9Hx8BhKW90OhrHMzcUTximW4qnKAPfheO
	WiQFFPpEssEg/68TLZeqPyuc7/XkpI18YbH6efERORzJCYuZcPWm9VebbxHFyEH4/Xmu62
	VidvaxaF09ZpD34PegbDtLoqIKQ3Fwc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ewRXtWGY;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785945612;
	b=PurYAHRQRdk1WD4j/STU82x7aTAz5/hvkWEdFkWEjtkkSBPb3M6diawi4+RIvfmM8EDj3T
	wVxOvZmseOe9rXhp4u6Q3coYmCvtmqFl5jrp1yv/sJWKq6xpvS/MnMRR6y67XMkelSRV/H
	vDADeZFTj+8XdrW8HpRnBUJOW1zssPs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hsHtN73QArecYhDYt+CWRcvZf4B3m3Arj/6RCQsqGOV2Yo4wXpxwtUPpLuBWChk6LmqscsqsRtHgesYwPwg9OkGeWogNuqyEDD5O0xHfdxqiEqzhfESBqTX3iSq/GkKq+JsSW4229ZV1N405lk8S5WLeRpO1WDG7fcyOtPMACjBvg98J4xt6sGa/QIoXhitqL8GG1whRHqCL5ZB3oTOvtm0w1AcmyL39f4BuD6y0cy2hitN/YFO1LZbQdN2HHvVNN7eCsi4fMTZZTEYrBiCLm1GTaryjWECvf4Yy8/CpHk2f1W9EC/H3jRgTpyShfyrgdaYuty7PQXlI+c1SqMy+NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1u/G3r2JaX5QaxcioHoI4gyB+Ar4Ocwk1kfs7HTCXW8=;
 b=VeahmdaSYSASHNEJMqZ6fEamlQtA0DHzndPrHZG8FLXgfEPgS5FYv1FObnNMmrK4Kx1O5ywepuZGgtpuwF1XxM2L5y9KRFtepSLa6TnS/VhW9W69nEYeYcrqzKC8Z48hYyLEvngbg2Dfv5tepB6tgzNBJDm/oipwepHRiroYhw8hlCuyfDfWJR3HK/JJKrl8M++E+sQado7QBTAyNqcgVAGRJ/rk99+P0wEdciPE/RF8FcV4/ij1KsjEa0wHMiU+nn264FOD7sH7Ps2g1sloDgxMdEvJvUgykflXhtyj/M3D7j0vJtlWEEHXorUmMXhJV9Fe1mdV39kmYdX7CGMvEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1u/G3r2JaX5QaxcioHoI4gyB+Ar4Ocwk1kfs7HTCXW8=;
 b=ewRXtWGY7wWQmnLHs13xCviC22b/Rs8ZacM3b/jquS/C1FV11ZK6Q1AIWhsTGekwSHGZ5Ir8KrIfOown0xZqLVTFVuGjJMYUspoFo0l/A0ZT2aOub7t57z7IG4A4LeeH2kLLRUMedQKyeJu8gd341GeBh8dn4AYHCuwAb5CsNbnbhvgGLo5hKdwX9ewayLs+uYTI2+03fg8dYgsWYZ6rARDTrQwVAX+Oqm3Op4wu3FqpWMm7MpToyYDpeTQOzIKV9I8cGMB+o+Tm5FRPmlId8w0BQ8kADK6G92AnwDE5F9dds3z//wrZJregzaW4Xx4JSrJm5V0Bqrp4eaGxNpYO2A==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB6415.namprd12.prod.outlook.com (2603:10b6:8:cc::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 15:59:56 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 15:59:56 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Aug 2026 11:59:55 -0400
Message-Id: <DKH4VJXGIUNU.2ZENW7583Q6K5@nvidia.com>
Subject: Re: [PATCH v2 3/4] selftests: mm: implement the mTHP-sized hugepage
 check helpers
Cc: <liam@infradead.org>, <nico.pache@linux.dev>, <dev.jain@arm.com>,
 <ryan.roberts@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
 <usama.arif@linux.dev>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <eb75f6d510fb48f14e25fde85e5a5e2b67cef394.1785564857.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <eb75f6d510fb48f14e25fde85e5a5e2b67cef394.1785564857.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: BN9P223CA0005.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB6415:EE_
X-MS-Office365-Filtering-Correlation-Id: dfbbee43-c51e-4e70-9bd7-08def30a9836
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|7416014|366016|6133799003|22082099003|18002099003|11063799006|56012099006|10067099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	Fic+FQ33od9wiLkbsp2sagtgDGB+oaNSPe+bd87+audz57hx2SUYzzUhPavTqo5mCf7hEIdsU95l/PLLCY5aMxW8yDyLtPP1YKFNda5cPAlrSGu5swZFNfPCEevwGJyJBt+7txzmurOFGdWdPhtV8KiJO2eMkYLLy2SKQ8kJ1/1of2TUXBWQUQabBPQIRZR6QscdRZ61WZ7URHDIe6RwHm61EZ31r86iKeKPme0JPqASA8sDhGgBqK2jxrgskHXNnleUvEKMCgvpGkqXsy7l53ijALdEhT0QNZLAqSwInQQLzZcHcbmqI6b61RNYNNdtwUijHFkmJ3mQKB5DTDSxhTIXWaMkmbFtqBpTalG7ejNihOfhoDCRC6eihpi1xVex57MDVbbmZs13MlwHasJh33YYvd4ISshOfguK9i723O0aWs2F+lXHMU8spJT+Pv4LWebwX//Ks9lcx8q7Rjw+WlYMyH8UZ2l1XdsE5L4ILzNLpnwz3H+jtafdJobBJYhQHMU5tWX+BXkFm6OF8XRclGNugwUnDy6o/+hKSCHstg+fswu40Axhhjci8/zvjqsu/34pzM+ps234uEEF7bC8hItwmrUKgQbfz8GrvDCgXJ8ucSoxEJHoR4gFpLiOf0wu7Q/ukOh4KbDZdDlWn/VASRvQOA/M9ZjXHYZCGUQhjGM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(7416014)(366016)(6133799003)(22082099003)(18002099003)(11063799006)(56012099006)(10067099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MS9ZV0lXYnlKWmxudS9WZHE0eUtnNXc5RVZLelpFVGYzZU9KZnBhMStXWGRy?=
 =?utf-8?B?NzgxTElsM0htbDVaUkduQ2JoYkdDTUlzWjc5clZnemdHbDMzbjZ1dlRGeW1G?=
 =?utf-8?B?cWJVd3hBMGdXcTZ0ZzZjb0piYzNpdU50MW12REg4eUNjTWUxS1owWVA0Y201?=
 =?utf-8?B?dnVXa0pib0MrVnFQamxsU1N1cFB3QTB3WVhjekI2emgzNWx6dFU5QzAzMWY1?=
 =?utf-8?B?UnJYY3N1VzJ6RXlwK0E0OGxMNzdMcE1qc1lsK2oxWU9KQW1UcHp1MFd6V05E?=
 =?utf-8?B?TlFaaFhJYWMrWWM1SnFyNGZqYjRXeSt6RlVHYjZtTnF5S2N2WmNLbkxVaXg5?=
 =?utf-8?B?ODNuRE9wY2h5Y2JySzBhOHpSWmp1VUEvTmhnTm5JWW1xbUY2TVpSeU9ydURs?=
 =?utf-8?B?anhxd1BjRmJtakF6UTRsVGhYTTNMekVQQk5VT1lidFY0MFcyT0hod0xiMk1X?=
 =?utf-8?B?aUZzZ21NRUNuVG1PT1JjR0VaTXZvOUg3ZkRZTVZLWUxJVkhzekFoV3dXUjhE?=
 =?utf-8?B?YStyK01aSXRnOUx0ZHpIRlQzUHRsNmxBR1NrbWV3b1RWRVNqMURpMERaMmo4?=
 =?utf-8?B?UDVHOG5ZNCtuRUxNMmR6TVVKUEFCQmFReUpUdVdxbGRWVHhSTHpndWU3dDk1?=
 =?utf-8?B?ZWNXbTg0Y3BrWmZaSUgwNzdvZE00MURGaytGQ2V0NHAzUVBBbXQ3RWUrR1JY?=
 =?utf-8?B?L1ZiVVNDUlVzamFlZ3VQUzNPQm0vT0Z6cWJFTXArMkdjR2NPZ3d4WmJpYUtu?=
 =?utf-8?B?RGxkbFVyRFlSYnFtRmZXUnBoYlBuMmdxQlBxRWQrSVZPUGZFUURCZmhXRmND?=
 =?utf-8?B?RWlyaHJQK3h6OU5NM1BRN243Q0VseEEwekdvNDYrME5LVW9PVFZvekNEaWsw?=
 =?utf-8?B?Uk1SUHc4VHVGb2sxeklqYWRRc3BCUnd1bytpNnBaUjNrNmxYNlRidnFjYVFa?=
 =?utf-8?B?VW8zYmFoaFhzeWRKa2t1WlpReHd6d3piWk56eWJZbCs4L3VRd2xYcHoxT3Fz?=
 =?utf-8?B?NGh2Wm9zYjBCTzBWMG1YV0xVM1YxenhDZTA1ZDl6aHllazg3ajZDanJIYi9z?=
 =?utf-8?B?VEM0TG8xVHY2aFg1SWxiazJlZVZVMjM4RjNxWVdmaGxlRjNmMVZtbURCTFBR?=
 =?utf-8?B?akZ0OEswTzFFTHM3aFp3U0sxL2xmdkFoWkFZYnlpbnRkOWprS25rWVN0Z0xy?=
 =?utf-8?B?clZ6WFpSVmNFZ25TQXFOc20xNWRJejNGcTRMOEUwREwrM0FrVi9SMzdnTUwy?=
 =?utf-8?B?a1ViWm5iUWx2TDMyTzZxSG9qdGlHUmhma2M2NHZVTHRlM2pIK0ExUDFmcFU4?=
 =?utf-8?B?QlpHbEZwaGppM3Ira2ttSEJGVU9mZ1dwMUt1S0NTMTJTdmlOV3BOQkdPTWJk?=
 =?utf-8?B?RmVYNy9vMjFvRTdid0lsQjRCYys4cjZSdXpReG1vWGo4ZDNBYUlqalU5enJL?=
 =?utf-8?B?ZTlSMXNyT28wWmNubjJYM3EwektYazg2c0N6bjNSNkVCNU5GZkhHK3BjOTRt?=
 =?utf-8?B?cjRBVlkvRTZXTzRaNjVlbXJhU3NMaVZtYTlUdUQ2V2hMbTlKYVRvSitMNXdW?=
 =?utf-8?B?ZVRDTkZ3RFJEeHlhcUo5OHFSSXZLUEt2dWxoeVFaY0xndnFTWk52aHI2UmV6?=
 =?utf-8?B?RzdxWXkxazFOOXIyeDJqdlJ2ZmRvS1BxM2JvZ2hLamVuT0RGZVJxTFNMSHk2?=
 =?utf-8?B?eFd1UDhrYWtmd1VGWmlYb2tMMlJYZTZIZ0QxRVEzbmtLNmtXcG9hM3pzNjh0?=
 =?utf-8?B?cEw1WkxPQkN6WWRZWWtiVU1La2FubHJuL2gzMDRhYlhLS1FYNFdCRjJaVGVp?=
 =?utf-8?B?Nks1ZTljQ1NIZXBIYVdQMXZ3c2RiK3FRN2FiOGpQSyt3V0NXd2dreHVxanBO?=
 =?utf-8?B?akMzN09hS0xuNG1IVXlIMGZnVm9UaUtBdnZsME5SVVpuNXVEdHB2MUpOSkdB?=
 =?utf-8?B?S1lYUm1zZDc3MG8wNWRtQmVMdlJtenJ2WjUxU1NUbnV4bFlJVGtnVlFXd3B6?=
 =?utf-8?B?YUsyVmpmb2ZuNnN1MFJqRE9uQTBzdUtHMzFMUnRPWWFrdjNrSmNWdUJZZVI3?=
 =?utf-8?B?RnNFeFZ1TlJEZ055Sm9mMUpUeWdxNHFoRHlwOVRpMjhmVkp6MWMrcG9wVS9U?=
 =?utf-8?B?S0djeXVJK0I5NUVScjVXWVNzeXlWLzVMZnNxait6WTJOd2xDVXVLM1BTLy9M?=
 =?utf-8?B?MUNCU3gvRmRlVDk5Q2NWMWFlNnRNYTFlTzVzU2xkUDFZc0NoeXlRQ2g0NFhH?=
 =?utf-8?B?ZHMrdFZyZ2w0OFVLYkszWW8wZk90MWtMdGRuaFhUa2ltazRBc1VsbFVyS2hk?=
 =?utf-8?Q?QMDRExw49GILYb9la3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfbbee43-c51e-4e70-9bd7-08def30a9836
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 15:59:56.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: las6dw8QnBGGAlgNZKGinLRV7KydeogSa+xeHVkt/N6UpsYDzqtWF/UjI58kk6y2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6415
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A35140008
X-Stat-Signature: d4jbqskn1nf6z4uzhoud9cxdzzcqtbzh
X-HE-Tag: 1785945612-337462
X-HE-Meta: U2FsdGVkX1/Od5WOLJFGKc8dVpYAdrmAMRmGxtXrkD2pGsS65vJ6dJ1Srlx4lwS25DD3qVQgT8Uo/J4fUwqz/4Sgq/moeU+aSP0CytpwI+hg0V2HNrJ+aZahcS7RbiTMBRUOTlwdyr10vjSNelaWas1zWxuKa9vA64xO2Fn3U/oCleAtci/QpYcTYRjbkjZwmvwTdexqWUDA4brhV03/SaS1YGrzFyx4S4WWvqCZGje431jQZ+YXWin4Hn5jff8XLHQddYHI8LY0PwEcGOLFl2GBDFcINu7+1cGmsGBo9HZBao2NmboIpm57kjWV3pss6TULVeZGUv55yDgsSYRUiMQeSwj3Ikbkgh2NNnisI50rbkBg2Dh5JH2E2xSGzUQ4VwAaAiYNB2qoLNgQ9UYvY6K6NUdwtRPxkkEno/eFYkrdpU5eejf6p0BFQzvGu5GbiImdeQISOWfe0N7zxaCuIvxB4zk5mXE4hL/+AvC9jt4ti+mrP4r4lxugxmZ+m2hpeFgibF5enAO87QhOJ7ThnSlPekANd+HzcypIszyfY8XXB1Wu56+7pDZi0JyR8wxXA1eQAmrDBYLVjm162PMdauLBzTwY9YMIWv9owxX4y6zoLKXeryCiWijcLSUBCGQfe8eqt2EDxo1uIH82AdRG2ei6a78FzFpai30uPhlj1peIlldrstundoLM2LpQeWfb+tiQEQAemU9kq6Q1+L3ObsvfEGygIbrr+YuE0Ly/zkqL4l2H0/V66/iA7J+NAEcvFdWzLjiOuYqnYMcqYDZJ70lfN75B2BBHKDqfBPh6FmTgAviRfiHVXH5ShzyC+L4waaVW316aXaOJ5tLsPGMTqpJNKAztfUDUH3x2kbZ2vxMw273rSdToswMueCTAVW50aZOcDcFQdAd6Y3TigoerRHN34k/dqxyC3c71lr998kjGmNsiiZVcmZFh0hnvh2OjD0usrdoFsDlr5EowDIw
 anoG8NMM
 yuDk0mnSkSlfxdPmknuHb4AR7TiJk0AtfNVWxMQSnP52K6vPSgj/PX51Bw/GcT6b9ibT/1vHwhek/zTr1ZGdcCxjgqvmBQY0mJ26hUa05xq+e3INDI+dfxnbYGeZJvSa06JQ8LAdFXwWSeDuvgTUqBz1bwjk7vdWPBcjUPe5QB6Ajm3rLZIoU5DWtqlBSvWbuILQZHhNPc/og8VOGfv6qSqCftLD4LFfXL3udI+yaa8fnFQOn/qkhUEFlh0Wk+E5Y056C50o2fzqSWaka5shXV8QqTOYM01q+T1uDkwEACLdINuk7tN4y91S4W/muvbfoGMb2V+s10/NeArllBQbM86hmcH6fslZYpI+7uF/G/aYSIKk5s3CoD/7PXMFNy4W+SHMbM7sYu4WWAKUfr/dcnMreQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 1, 2026 at 2:26 AM EDT, Baolin Wang wrote:
> Implement mTHP-sized hugepage checking helpers using gather_folio_orders(=
).
> Also rename the existing PMD-sized huge page check function to
> __check_pmd_huge() for clarity.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  tools/testing/selftests/mm/vm_util.c | 60 ++++++++++++++++++++++++++--
>  1 file changed, 56 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftes=
ts/mm/vm_util.c
> index 09e5d5cabe21..1240d783669c 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -15,6 +15,10 @@
>  #define SMAP_FILE_PATH "/proc/self/smaps"
>  #define STATUS_FILE_PATH "/proc/self/status"
>  #define MAX_LINE_LENGTH 500
> +#define PAGEMAP_PATH "/proc/self/pagemap"
> +#define KPAGEFLAGS_PATH "/proc/kpageflags"
> +#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))

This is a fast way of getting log2, but there is no check of the type of
nr_pages. What prevents one using it on a long variable?

At least you can convert nr_pages to unsigned int and add a comment.

> +#define NR_ORDERS 20

Why 20? mTHP orders can only be in [1, pmd_order - 1] and different arch
has different pmd_orders. check_large_folios() probably should just cap
NR_ORDERS at pmd_order.

> =20
>  unsigned int __page_size;
>  unsigned int __page_shift;
> @@ -348,7 +352,7 @@ char *__get_smap_entry(void *addr, const char *patter=
n, char *buf, size_t len)
>  	return entry;
>  }
> =20
> -bool __check_huge(void *addr, char *pattern, int nr_hpages,
> +static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
>  		  uint64_t hpage_size)
>  {
>  	char buffer[MAX_LINE_LENGTH];
> @@ -366,19 +370,67 @@ bool __check_huge(void *addr, char *pattern, int nr=
_hpages,
>  	return thp =3D=3D (nr_hpages * (hpage_size >> 10));
>  }
> =20
> +static bool check_large_folios(void *addr, unsigned long size, int nr_hp=
ages, uint64_t hpage_size)
> +{
> +	int order =3D 0, pagesize =3D getpagesize();
> +	int nr_pages =3D hpage_size / pagesize;
> +	int pagemap_fd, kpageflags_fd;
> +	int orders[NR_ORDERS], status;

NR_ORDERS is a constant, so you can put orders on stack. I think you can
rename it to MAX_NR_ORDERS, use 20, and check pmd_order is not bigger
than MAX_NR_ORDERS.

> +	bool ret =3D false;
> +
> +	if (nr_pages > 0)
> +		order =3D GET_ORDER(nr_pages);

This funciton can fail early if nr_pages is 0.

> +
> +	if (!order || order >=3D NR_ORDERS)
> +		ksft_exit_fail_msg("invalid order\n");

It should check against pmd_order.

> +
> +	memset(orders, 0, sizeof(int) * NR_ORDERS);
> +	pagemap_fd =3D open(PAGEMAP_PATH, O_RDONLY);
> +	if (pagemap_fd =3D=3D -1)
> +		ksft_exit_fail_msg("read pagemap fail\n");
> +
> +	kpageflags_fd =3D open(KPAGEFLAGS_PATH, O_RDONLY);
> +	if (kpageflags_fd =3D=3D -1) {
> +		close(pagemap_fd);
> +		ksft_exit_fail_msg("read kpageflags fail\n");
> +	}
> +
> +	status =3D gather_folio_orders(addr, size, pagemap_fd,
> +			kpageflags_fd, orders, NR_ORDERS);
> +	if (status)
> +		goto out;
> +
> +	if (orders[order] =3D=3D nr_hpages)
> +		ret =3D true;
> +
> +out:
> +	close(pagemap_fd);
> +	close(kpageflags_fd);
> +	return ret;
> +}
> +
>  bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint=
64_t hpage_size)
>  {
> -	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
> +	if (hpage_size =3D=3D read_pmd_pagesize())

read_pmd_pagesize() can fail and return 0. Either you need a check here
or add a ksft_exit_fail_msg() in read_pmd_pagesize() to remove the
burden from all callers.

> +		return __check_pmd_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size=
);
> +
> +	return check_large_folios(addr, size, nr_hpages, hpage_size);
>  }
> =20
>  bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint=
64_t hpage_size)
>  {
> -	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
> +	if (hpage_size =3D=3D read_pmd_pagesize())
> +		return __check_pmd_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size)=
;
> +
> +	return check_large_folios(addr, size, nr_hpages, hpage_size);
>  }
> =20
>  bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uin=
t64_t hpage_size)
>  {
> -	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
> +	if (hpage_size =3D=3D read_pmd_pagesize())
> +		return __check_pmd_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size=
);
> +
> +	return check_large_folios(addr, size, nr_hpages, hpage_size);
>  }
> =20
>  int64_t allocate_transhuge(void *ptr, int pagemap_fd)

All read_pmd_pagesize()s above need to be handled.


--=20
Best Regards,
Yan, Zi



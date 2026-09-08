Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C4AC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A979A6B0092; Tue,  8 Sep 2026 11:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48616B0096; Tue,  8 Sep 2026 11:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937F56B0098; Tue,  8 Sep 2026 11:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1996B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:29:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A34AF402CC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:29:46 +0000 (UTC)
X-FDA: 85190979972.24.9517BED
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011067.outbound.protection.outlook.com [52.101.52.67])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4FB0F40005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:29:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=n9NqWbt7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=n9NqWbt7;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788881383;
	b=8G0LMN3b1PugGkNjZeuz61I1bqduqwFouk3MJ83COfa4x8YHOmUfLY7RfrhobjM21rE/Tv
	DcQCgy7m22g0ZeRUwEUgxfZCaY5pPz2P80M0ZvxuDXWeT9DsGBdtzUxhdAEyHn+dqS579I
	R2ZulKlP6SwGZ3yvicfZwvyLY6nGrAg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788881383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYdfURcM05Srfne0YBFdTtcAKg4K3aTt02JcmJL+IRw=;
	b=gia2M9ETdNwq+USU4dtgtHBMXaFB5LBm6WXuIB2eIvvjfDM8Z9yBSj7NuYUZc22ARNlBoe
	C0JrC/eDVJhTiltqLfXoujXWp1S0JyzjRLHxPdLXN/GJxOvn5xf9l5pArMRIqsHDdiVLE1
	HBqx7N0aUAbAhJCjkSRVW6MLKaaPpCQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gZRZ3t30nyRcK5Z4NzbXbOaCk/krQB4JN9NyDUZySluXU73vy6W5J0lo2aryEe/l13Nl4ThGiQ8Qt+eo5H2U2UO9i2sx8w8SofaR1392NxevWpA5FrccvAqP9P7ZiRYnFluO3eZpWSnRCcxPzQa+2L/KNiTxMT/hsebVBRRODmtk/XBQj2QTIGI3ujiJo6y3BW0MsZzaFVdr3ZRpOWEPgZW6dk+TDmiPPLOcXcyy3CoRh7CpA2i2icZiakN4ivZphYYwnVYaq5ebOhVrEdNZ3ljiHZEahtJ0tzhfw87HiEfqbIgEn+MoRXJJBU6vuriGeEl3Y/HhZlU5A4CSKthK7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xYdfURcM05Srfne0YBFdTtcAKg4K3aTt02JcmJL+IRw=;
 b=VvPX/ewBl7AUdU5vlL3pATA0kL0z8fuSRJ2CiieRYyyhcjERkKeIUrMysZMN3WoXktXLqliUmzfSMON/95PMVIWTJforI6rqnoKaQi1+gNBvKC/QIxzKoMb60IMdHKkUtJCfY93R03JfmkQTyUYha9Ya5ov4prJUn+eeP6zWwN3zBN+iTKM3vHhvnvLQ0QbmEiK6ozov/PkNv8PCA75rLFyBBF/dJjX7dc22pTiRUozcI9A8+rVGxoseUmFIZqScIk+FTaCJbIaKAn0UZIJ7WEakZ9bgTsDqsikQHpt1zd589AB8CkX85s/QOdWcQzPoYQP7mlMfwmmpimvglJgo4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xYdfURcM05Srfne0YBFdTtcAKg4K3aTt02JcmJL+IRw=;
 b=n9NqWbt7U7jYTLTm67V5ufJebAnkYaJ0liYvEEacJu7ybXPaTL4thJG/uC1m4Xhqoq4zUG6eIHMG7WfP5sCPfo5+vLrUrUcLpK036munaF3P+JiB8aALZS7p1fHSfqSfjDSss3VNFTA0Xeao/D/vsu3Kx3b3Zo6/HOf5Rl+0ybzhXoFGWXFKWO7I1vxrBF89Yo2lLe3UHkIrOD7qErqUjHlNncqm1NbMK+lU9W98gcsCJLzo16Dg+QSucKeoedmSOJk8RWYrUENKD7Um0tm0G7WYKOS+kz+jbPiqlaZvErlNUcYKInhUoT1RbOAXby77aIVJiezA8eAwSXXoM+qkrw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV3PR12MB9216.namprd12.prod.outlook.com (2603:10b6:408:1a5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.6; Tue, 8 Sep 2026
 15:29:01 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.005; Tue, 8 Sep 2026
 15:29:01 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 11:28:59 -0400
Message-Id: <DLA1IE5IS2R3.3GCTKEF3YX83Q@nvidia.com>
Subject: Re: [PATCH v3 05/14] mm/hugetlb: use direct assignment instead of
 folio_change_private()
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Oscar Salvador"
 <osalvador@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-5-6ae22f9d9272@nvidia.com>
 <54d6b1f8-7fbd-4a08-a9b1-a688f75d82cc@kernel.org>
In-Reply-To: <54d6b1f8-7fbd-4a08-a9b1-a688f75d82cc@kernel.org>
X-ClientProxiedBy: YQBPR0101CA0350.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6b::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV3PR12MB9216:EE_
X-MS-Office365-Filtering-Correlation-Id: ff7b035e-1626-4ffe-cf45-08df0dbde88b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|10067099003|18002099003|22082099003|4143699003|11063799006|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	WhAxGEsNMT881N+QcRUEU8QHggCR5cu2rTU8Jd5mnAiXnm4vtpGlIaXQZJ5MbMxGrrbcpcVfIxNshKimy2pf+SswT0A7OjBh4tXoLW+YTZR+rBRFy7OQchHrPrdadJioWG7S77fnnB+25AAU0CYtWSA83NP6jl1CzrIEvVTHcbhuWmaJ09pSAE3ZFB/9LqD0T77BA1jyYd2SVP39qWNkriVqRi6e+IBe9dgO9/BFO/oaS7gIhLFPxIJJpK+oBAb7VK5Bv1wXxMhiPBnxq42lvW2k7JWfoKPXfQQoGIu8HvZOPxNZ8W4B5VzLyLml25KEkBzcTUP/S5DS+j/0LP/VJiHg58u6YHctK0vAJL9UNiIwVaeyeOVUD3152NL/C10lH5umTEZjf++ZeNQ6ZNm2TN78+XUL8OFWQx195wazPBLpGx4u2IGH+r7ikOO7XzQLhMmDjY9IfRhCG+tZHhZbPzCcqQEihoM+Cbe3DEetUM4ELhcZmghl/sod1U86AkhQVAQGiuwLxhzoPZnrDZjE4irOr+1b8Mgrbxzs17//zvfGFmNdI2i6taGoBLYS8B/aJBkDaIG+svfDYuhXA7rIxOHqhr2qgDcjArrSCaceT/JQ3RnSeN5CIBtwbuvj24/cG2DtYMavo3tmk+nhNSU6yAKpWRU/rzZ1Q5aGCUtKJobAR0WGsXpRJ6i6MBnTtazD5TopDb7FDOg1j3ktjHaVZw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(10067099003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cWQ2V014a3RhZnJ0TzdqOXdsYjhRZEE1QXBpQmM1TXAzTUhkQlZUbDkxcHdZ?=
 =?utf-8?B?THVIZUdHWFFXU09SVEtSa0YvNG1ycDFMZVloaUJ6ZTZzWUhDSS9mMlhsTU1B?=
 =?utf-8?B?OC9kamFYMG1ETkdvSjVtdWsrZHY5M2JqNGR4U0FzZUtPSWZoZXBzQTUyZVha?=
 =?utf-8?B?WDlMbkNZRjMvRzlqejJrOWZZTHdMWUdNZWVPbWZjemNBZDE1dGVISWZSditI?=
 =?utf-8?B?TXRWQXNxcXpRNitKbmthUHk3amRzSlA3RFRwZHIyWW84TXk0MkdBc2d4Nmxi?=
 =?utf-8?B?YkpoUkJBbUdlcmc5MVc4UXJaV2RQSGEzQTdESGo1Y0RLcU9CdHVFWjMzU2dv?=
 =?utf-8?B?VkVzNE9vVHBYY3dnbjF0QisvemQ5czQ2dnpmOGFOOXduMVpYOHpKRU9FbzBv?=
 =?utf-8?B?YjN4eUpHNXBHb0crK2xQQXJqZmFmTElJSXN4Q1BRRlJHSVRWQzlOb1M2SXFu?=
 =?utf-8?B?ZHdqOTJZT21BeVJCaWdLZ3QzU3kvUnNNWWxaWGVnLzBHeVV5LzRjT2FpUGlt?=
 =?utf-8?B?QSs2cHg2dTdybGFVZ25uRGMxVDJ6UnIxaXJJdEhmWWYzdVlkOW1yQW9IYXh1?=
 =?utf-8?B?ck91YklEZ2tyaUxPMklWQ21BUk13cENVcHliRUtmYnFyVWJON3Bsa0NvZ2NE?=
 =?utf-8?B?QzZUUjBwQmo3YXl4N01hVFcxUDFSZjNPMnoyYWovVWVYdld2cmJaaVNzaVVv?=
 =?utf-8?B?YXRvQjNTQ1RlMFBMcCtsTGZBc0FheXNVckwza21Tc3hHN0NrVTRUZEREbXRL?=
 =?utf-8?B?VFNXMGJLUTU0OW1HNFpSSkh0TlJtQS9ibmIzTkdtUnVRbmRTd0FGd25GblhY?=
 =?utf-8?B?cEpNTjBFUEhpRmFUanM5VUxhMktLVFI0aGdPSHdjdmptYUQvaTZDNkJPNVpu?=
 =?utf-8?B?K0lET1RqQ0wxNDU4VjFGcXVnMFBQR3hTMTMrcG43b3BvZ3lKL0JqZG15cS9T?=
 =?utf-8?B?dEZMU3dYMk9HdDNrNXZPdHoydUxrZGVYV3VHMHJJWklXaFM4RmErdTFiSjNI?=
 =?utf-8?B?UGRIVENERGM2cFRGWnU0V1dkMThLMWJKUkpNTkxRQ0ZrbDJiZ1VhMStaZTdn?=
 =?utf-8?B?VVFZN201QS9NZXdHRTRwcE4vaWZMeElDWGpHR2dhRmtCbHRIK0JUSUFWNnBq?=
 =?utf-8?B?R1JiVzRlNVUrRWVJVncydVZrSy8zS3JtaERJMzF1ZXFQSnI2MzNna3I3c3lJ?=
 =?utf-8?B?QmVjcG9CWFYveE1ERTRxTzdWcDBra3BMMisrWDF0U1JRODhCYVI1OHJHZWk4?=
 =?utf-8?B?OFpuUDRkRGpuV1UvVDlKWWNDVFpDbnVJWm9vYkNZV1F0YVNXTVVXc0dDWjYv?=
 =?utf-8?B?SDNCSmx5Tm9UdDl1bUw3UDV2eDFPbEYzTTNrVVpDT2JMd0d4QzRKeXdBQWZC?=
 =?utf-8?B?aE9XRUY1dEdqdkt2VEo0OFdqYWk5RXNVKzViVnhyTkFFeXRsdStmYmU5MUlE?=
 =?utf-8?B?VFN3T0FudnNpME1ha3JwVStYUGtkRTFtN0grWHdGTVZvbzJlTk1nblRCOFg0?=
 =?utf-8?B?eTNNWHdtaUFKaVRsMU9NZURhOFJJazhjK0FSTFNFWXMyd3BlQ0FOeVNOVnFY?=
 =?utf-8?B?d0tlUGNFZEMwUkpwbnNpZ2RvZXZpWnh0QWl0KzBGTzlsM1h2cHgzaXJuRStN?=
 =?utf-8?B?RnFGTGMvQVRQVi9SQkp4bDQyU2JROVBVTDRiZ1p6clVwL3N0RUNqcllHTEh3?=
 =?utf-8?B?amhlbGJOTEtRRDAvaGNwdEdQcWVOZXByTmFybVljdnRCb1lqMnp0WGxwU3lp?=
 =?utf-8?B?VnpFdXhtblYvT3F6ZW5seURVak55dUFpZjRDTUpXb2FPMDUrYTlJeFM4SHl3?=
 =?utf-8?B?Sm1nblN1eEw5cFVZMnBiZ3RzNzlJc2hkb0lyVERnblJVUWpPKy9VVUg0Si9B?=
 =?utf-8?B?K3pIZE5YVTU2Q3o5MllDd2xWRm1TSWcwSWRwclZUWTNwcy9qNnAwVkpKQjJK?=
 =?utf-8?B?KzJYeG1GWURsakU2TmF0K3g0Q1lFbWEzT3lTc2ZOL2hSKzljZ2ExUk5ZaTNI?=
 =?utf-8?B?N1I3RW8wVUZNYmZFN0VjYzZ4SkkxYUtHYSs2Myt0L3BOK0p3cy9naWdaMXpM?=
 =?utf-8?B?OThxYWhFQW54bWt3dmFUOWJRY0hOZ3NFSnRFOUlkOHdBL0pJT0dNUlkxckY2?=
 =?utf-8?B?MXE2b2dBN280dndQRjlGRGtXU29SOERGMW1YQS9PNE45eG1NVit3a09lSW1o?=
 =?utf-8?B?NTkyRUZMZFo3WTVoN1VLcjh3cDZGOHRrWlIxZU5Id1FXTWl1NUYzdktkb21G?=
 =?utf-8?B?VXMwUlErYVM3MURXLytPN2M4T2lhOTBBdk0yMi9tcWxDMFVRVll4SC9xejlx?=
 =?utf-8?Q?8vS29PDwMwshn8Rgla?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff7b035e-1626-4ffe-cf45-08df0dbde88b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 15:29:01.2807
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wNR3hBY/kuhB/Opal72Lu8vRMkW70UzYufgqky2ACddA8GjIdvieP/qJAcbIe5Bh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9216
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FB0F40005
X-Stat-Signature: 6pi8o1rad44qazt5qtpfhwkcqswmps5u
X-Rspamd-Server: rspam01
X-HE-Tag: 1788881382-566320
X-HE-Meta: U2FsdGVkX1+SPu+bPKBeyqLSYeY2hdlr3XlnNtxv/+ihKQBqIhsXEFI1NCCOslTzAET+KCTMF7TXqgetaa5hIDLa5fNFxtNrPjyujaHVMasu/ooem2UA9lgt0QdD8QFromf3yhkJAXbcbeA1i7lgNx6GsNHekHsaxnHsPo1kPdGaW7ewmVQSwz0a+XlAd9GH2cSJZrKQNAu2CWFhXV6AQuz8Sb0uBZe7xNfd+ijO2EACj8c/F7IZltdzT+KZOfuca/+J1jQaHKbZbuZa67eqij/CokrPnY6tTIAfmKOkeIkl2IH3kMLh3Ss7cRBJCfqUTDuseMQU+a02Ff6Rk3OentVHAlkmUQiv8a0ta7Jk4nMNlxIuJBmmP4nOebasHxhLQdRwMgxoWW6V2P+LC83aCQAQLusqeq8MbkfXuNNYl8NCNys/R+47uGdgmrbZFjBxWNqDtTDYux9jPWZ4YkQpVZ/4riE5qQfifOgFg6ybdGcL+wyQ9G+xFHCOk2n9WEVfOPlJloKgqJXqT6kLXF99APj7+YQQneNjQztnwh0VCtWE+3YNYvV53yfP1+BSQrBa+W2tLYEZWbRrpbHZ28ukmXdlaQOxVC5id9HQ+BbI4fLLfADBF7apDygpuumTnO6loHFYQhghUeB43kWSKknMM8YHfrkXxy0au9RcjBuwCNecE/v1w555Vcdb6/zs8/L+hFnwvMSwBqu0djeBMR5AGCgjvXmFg56wuBl4rTJi9hPSvOK3iTWGnLVfyiORQgt1YXTs9NYa3U0XqAmUHpRch6W3gcGMkHWEbRukIAO5hUNwmhl0jQ5B/QzoemqJPOnqVDHbR6LWJgM48Jua7JRLRL+lOhnZnXBGH2Rad3F/WFCCzwb/oDpWp2xnLOzHMCvTUTTw16FR9WIOKa0PkoNOJ/INntBZ4A5212CJ/qSC20MDfWOSlRiukcudQdqIgq7Fz/DDWkjVVIYr3LHYcHV
 5qtsKQ7k
 jXV4QTCqIHBUajruTn2r5lbn4ZhJYUW82Iakcmyu2qQytuNxMgcrGh/xoPex2Je3/+p9DS9oqH83pXd78OdyLtNl3OcP9Lpd79NfgoV6QPsW+B6gyehdKG9ZggvvXfcrZxK3aehibGSR5uhL/vX47zeoc/rtCVeBax0wernqlGNCjQhjPgrygrIMAEu4cZTiGyOC7hZPSbBlvxVY8FxefrAA/B6edcXsVf0DfVEbsutROK6ztmxYIgRIJXrAsQuiX51njx/ttpkbB9kGD/RUzPmAmlWG7MB7Rz8ah7l4nuCwvfbRHajThq4i2d2wKQgGa62YDMpRGet54t83gCl/RI8K/cDXiW8+dO7KmlxPzx/WoIx7Dz4jXIkZQgxOFck50MDfIjkabDAjornkheHefUr7Gkybl3MpwDM/fhv/I7/j32ZJ5JqKGq3cDktADZYGwxRmfI9Pr81+h8e2OeQw3mUbWP6totE7R8CXAlA5MJDu7DQMEgsyWNEa5cLzlD+G/4EHhu256g69DMrIv6bcH8kujI+qAqheaujGcvhtpXsxRRGXnY2KakK/21wGfBKdVrK5o8pAO7mEE/vbZHG0ZFY8J+4OeWS3fJ0oml/UOhb5wKTfTSYBXQfewNv3VznUpidXAzxoCUWtQtSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Sep 8, 2026 at 11:26 AM EDT, David Hildenbrand (Arm) wrote:
> On 9/8/26 04:56, Zi Yan wrote:
>> folio_change_private() should be used along with folio_attach_private() =
and
>> folio_detach_private(), where adding and remove ->private content requir=
es
>> folio refcount change. add_hugetlb_folio() simply sets folio->private to
>> NULL without refcount manipulation. Change it to direct assignment to av=
oid
>> semantic confusion.
>>=20
>> It prepares for a future commit that remove PG_private.
>>=20
>> No functional change intended.
>>=20
>> Assisted-by: Claude:claude-opus-4-8
>> Assisted-by: Codex:gpt-5
>> To: Muchun Song <muchun.song@linux.dev>
>> To: Oscar Salvador <osalvador@suse.de>
>> To: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Acked-by: Usama Arif <usama.arif@linux.dev>
>> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/hugetlb.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index a69bd463b1aef..08a538739d785 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1445,10 +1445,10 @@ void add_hugetlb_folio(struct hstate *h, struct =
folio *folio,
>>  	}
>> =20
>>  	__folio_set_hugetlb(folio);
>> -	folio_change_private(folio, NULL);
>> +	folio->private =3D NULL;
>>  	/*
>> -	 * We have to set hugetlb_vmemmap_optimized again as above
>> -	 * folio_change_private(folio, NULL) cleared it.
>> +	 * The hugetlb flags live in folio->private and are cleared by the abo=
ve
>> +	 * assignment. Restore the hugetlb_vmemmap_optimized flag.
>
> "are cleared by the above assignment" ... isn't "folio->private =3D NULL;=
" as
> self-documenting as it gets? :)
>
> 	"Clear all folio->private flags except hugetlb_vmemmap_optimized."

It looks better. Will change it.

> 	folio->private =3D NULL;
> 	folio_set_hugetlb_vmemmap_optimized(folio);
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks.
>
> It's also pretty odd that we use an atomic here, when just erasing all fl=
ags ...
> but that's something for another day.




--=20
Best Regards,
Yan, Zi



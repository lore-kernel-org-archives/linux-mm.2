Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4B50C5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 02:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799A56B00FE; Sat,  8 Aug 2026 22:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71DDF6B00FF; Sat,  8 Aug 2026 22:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4FD6B0100; Sat,  8 Aug 2026 22:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 178866B00FE
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:49:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79DE51204B0
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:49:16 +0000 (UTC)
X-FDA: 85080199512.01.ACDC3E9
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010068.outbound.protection.outlook.com [52.101.201.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id A44FDC0007
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:49:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ezYIqBqB;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786243753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJXyu+TquOJ1ya5KJRuqKJ8njB1KvnuMZqdWXn6nU/Y=;
	b=3/00lIT7XFMT3R0tlsEPdJsi1VmciWAwoB6gJ0Tz9dcqYwA9vkevK8vv3FzVCJAwJ9rejT
	orue71T7TURUOpf3mUQkSx6Onf/rshCQesjO2rdcBuS+Z1Nt4YK2Yo/ce48lc/OIgJFHP9
	VwgJuXOU6NMaABHo6kCz8BZPh4zkHNQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786243753;
	b=DQaG4A7Q5vizXBYp2V6jf6VhaPorXZgzQmvMaJ64I2OxpGhxNk9akIdXxfKj5uU/s75A/e
	ECvR3EuI9FC1SRVCHlAC20xrxNMl2/0ICRS+Wv27r6r0i0XXIbXXTlLtSkprxvBy8SCMOe
	hR9J2Ne0seZwipvzxH77D27OQZ0IDcY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ezYIqBqB;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.68 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUCU9C/sYYnmaga8XUNAYiF2yD5iRLNDoXazbR26QB0uRgVXyLl8pUbjfvhDwckY3KGJlAM0s0qZq1Mbfljnm/wRGEDZ8cvWaubbRCXd2Wgfv31xuvRAylmqo6ht1O3OZwzAWrizC8tYVvbPLJRoh5aGaBQUiMO3g2QH44RZ+LLzyQeD/AHavrdFqlISif/jVbpvut6MLpykzGNG8Vu9L/GvRzf7H2MzZ1/Bd9JiXkWY0c8J27RKPXXdQijikTJatPsa/u9kOFmfnsrOJh6GneF6DlNRc2rfBG3tGlcj+0uPuOAdqG3/whssE4ydcMG94kfQY1WbOzGVlFuxHaOW7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJXyu+TquOJ1ya5KJRuqKJ8njB1KvnuMZqdWXn6nU/Y=;
 b=OS748A8xdSz6GgZDIgdFR4dOlgjLxmcQlJ0QAHXyR2h2ybFazju7PyvrBQ3dmzOU2vpJAbPInZCpvJgaZNVuPcePncCP7OgVLGVrfgOTNYeBaxmTipqX2hjvI2GFkSJhIL4KCpx4RWhKzOXalXkHMBZN55zR4iPnGayhs4SRyrgB/w6TMGyeILkKyvjB643J6V1cuMDwVRZClaGQIm987ZcOkIyrvUMK7vdoyEuu+2V1jpp8rXINP31JDNHD7ypENjWORD7hdXzTyHDdJzdGvj9uP02OUIZfQ9lWUcm+xDiHOMf69dkh28ZIQLWl50XfWSTg33mibf6NZcPVYFyyhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJXyu+TquOJ1ya5KJRuqKJ8njB1KvnuMZqdWXn6nU/Y=;
 b=ezYIqBqBR5T9fcpZi3k26/oReIHZuZKRW4LnWBNYdmwOuy9fLsEKDyz+Hx5jPZmVV96tGujPi5GrRH7RFF5kOVHPUTpRMEmalJt7u9QTgiew66vol5NpLm6OJEq7VzcjskDfFeoJWShcwbhDTbBjPdSH9FEu3ZYZRhOhsYy626BL+1qYjuckJeUt1wFDXUaGXfySZMlZESs+4QNFc4HGOHE8WOLCnAiYvkuiucbrGoSuUE4Z9MhImuLRyq9tEF9LUGf59NqTZTqOI0n6ZF915GeY+sJ7jSfxj7pycMvbmSgu6ft+zqX883wkO2eltEsMg505IMG1fYFKuR7RvNcmmQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS0PR12MB999263.namprd12.prod.outlook.com (2603:10b6:8:424::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Sun, 9 Aug
 2026 02:49:08 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sun, 9 Aug 2026
 02:49:08 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 22:49:07 -0400
Message-Id: <DKK2K9D40SLC.Y6JS97HWCRVJ@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 13/13] mm/huge_memory: count only swap cache refs in
 anon folio split
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-13-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-13-689939a7ccc3@tencent.com>
X-ClientProxiedBy: BL1PR13CA0412.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS0PR12MB999263:EE_
X-MS-Office365-Filtering-Correlation-Id: cef0b0b2-0e48-4fd3-56f3-08def5c0c8cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|6133799003|4143699003|11063799006|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QmYT6JSANI94D7Wxu59f4t7AOf+ABDm+5olJJz2PlhpK2A5Pto+/qCOB3utKuT2iv8q/0bh2nXa9ymPNWPuG4SXZ1tUfpI23KwW3xc/A8axhybs1d4P5gkagDVWzu1Tek5CERhfkt+X763uWSkoQbUK3OM3TCrXS30pbFm/41q27HNNpFJSOqChLZrD3xcrmzUzzZA2eH6x1KGiZp0SHOxyS2kkdf6lE3bUX/GL7pMTpHKRkzhEXZsuHHzCmduESUhA391tvYKqv0KbvC5NfPc6EeUU5bxzf9g5rQ4m96ZIpyTm/j1GqzJDSvEbVjFrfEIvICPWmLaeTFOXxvGMu9DhVA4/Esmophfzz6W9+LvMCb5iy983wcnc9+eAlyYoGinfL0TNsGe+nxrriiI9CXoTg8syreKZZFOORBgSwTDvhycoCkhANPkcZUntDmt7VDAVCQPBFVu9FatMJBCn8tt4MpMozHzqMBEX1prZqDubc5E0UXOG9Jjfcj0YFkeg0DBkFt4acCb9R0LkIun3vxwzoVTSgQZwaKX0Zueks6yZC9IfcRceGBwYEapqiZETWRKDFt9abyJs8iPWHnPdNQ+lFiURGPYBBL0fSXYAs5sohsJ6qfZ7Y4c5U6hZD5YIa3h4QYoLVrW8mHpKHP0FWSOovTYUiWf3FwU88NaOXeXY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(6133799003)(4143699003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGFiaE9ydElFR3pGSzdSMFJERGFVN0k4cURSZkVCeElDak1sT29qdWFFMTd6?=
 =?utf-8?B?NWwzSU5jOWYwdlZhL25XbVYveUxSMnNvaGc4ZkUxSzlyRzgwVnFnUmE3aE01?=
 =?utf-8?B?TjlaenlMUGRMWUIrY0pPZE5lS09Mem4yazV4V2JIQlBscDRtcFl2REdHQjlR?=
 =?utf-8?B?TE1FbEMxWHpOOUJKVFNRR1lpclhVc1hpS1JWMVpvV0dxb0h2U0prWjFETk4w?=
 =?utf-8?B?UGVNemJrR3hSYW5DZ3JBa1VmdDY1SzZZZ1NJZEJlVzBnU1ZSV3ArRTBhVEhl?=
 =?utf-8?B?UG1COHZxRzlKMXNzKzdqM2VtOG9Bc2ROckpOL0FRdFh4aUVaNnJoQ1pkTDNV?=
 =?utf-8?B?bnRhbG5jTnRTTFBrZG5qRitoSXVWUE1qL3U4V040aG92YU9WTTh4azZmYTNS?=
 =?utf-8?B?VU5kek1zU0cwaTNNOXExb20zQ2tUL3M4T0lVc21xVGZ6RUo2UVBiUDEvRXNo?=
 =?utf-8?B?QU0vbFNpWjYzR3V6ZUN5V0M4TkQ0cXVFblFsOHlxSG03RW8zSHFna1RDaGEy?=
 =?utf-8?B?eGR0M1FDcHA5SU1KUFR4MFNHbHdMb2ZmVGFLQ3h2aUY4RXF1Zmp5Q2JWUzRG?=
 =?utf-8?B?UTBtM3NvcjNnOWxYR1B0ZURPQXlPVUdvdVFJbldRTFRUTVpFcUdzanJpeHRq?=
 =?utf-8?B?VTdzb1lEUjBZb2lRcSt6TFhwU1BZWGlibnBnWE1KUmpVZlBMVk1aSll6Q2J3?=
 =?utf-8?B?bytCZURzNXBCUElQaXhCSlRVUXVYVW10WXEvWkM4WHRSQ2dTUzNJU0dYbGNS?=
 =?utf-8?B?MHIwakNaalpiR2ZUQWJuaHliV055aE1xMDRDUldSY21wMHhUMkNmV053ck1v?=
 =?utf-8?B?diszUGF4Y0hlNDR6V2pTVThMakpCR3B5NTdTaURpVDdrY1UwOWluMjd0alRZ?=
 =?utf-8?B?RzljVmNhTWZ4bjN6d2JUblVXS2J4U0hhZktwM0xjbENUcnE4ZG4wQUJlYy96?=
 =?utf-8?B?QkxiSFFrL1FWa2doVTdSR1Z0aElkaHpJbXRTWXozTW13K1BpOVpkdzQvdnRw?=
 =?utf-8?B?bTZ4eDY0U2pSYVJKaHJ3QlhlNGdVbUl1L2RQNG5qaTNqWHM5MytRMjZiZHlN?=
 =?utf-8?B?Y0lneEEyYWFpMmF6czUvQ3VTMDQ3dStjeDRSLzFiT2pEdlAvR2UwcE5oaGJs?=
 =?utf-8?B?U2tTdGZNUzFkbi81RndxTnZKdkJ4SGtwWmorYVZDbHNNN1pyam9ZSWE0b1pa?=
 =?utf-8?B?UGNDbmdYSTdudk1qVktWRXI3VWlEVi9EVEpuTHNoQjZhaFRCaUg1cHBmTTNs?=
 =?utf-8?B?TW44cWdrNlVBcnV5UTdkcHFkb2xpSEY4dDlCQVBNR2czZUN4Zmh5SVF3VXlo?=
 =?utf-8?B?YzVBMnBiWGVRK2MxV2JZRTBkRUF4ZE5hbEptSk5xbEpDOHRHT1h2YWJhdGQy?=
 =?utf-8?B?U3BPN3Y1eHdLUHU4WnlHTmNWYjF4RXBmaGFFd05pYUtQZDVLWDNFTEZBdUsv?=
 =?utf-8?B?VnBEb2JlbHE5NXJIbG9wN2xUVWV1cDB6WlZPSTl2cEZmMGZQek1OREREOXA4?=
 =?utf-8?B?eVpBWHdIUWF5ditFMVNCTHJRc0ZFOFBDeFpLVXBJVWN2VU1wTDZEaERXTmlM?=
 =?utf-8?B?a2VvV3MwU2ZFUTVURG5ObERFemtrbVBmTEt4N3BWZUpRMUFuczM2blprZ3dW?=
 =?utf-8?B?Nlc0L1kwaWZwa3cwTlhIellFYWRwS0VUZU5wdklPcGVuMTNncm5rVEZnT3gz?=
 =?utf-8?B?dkhHMGdUS1NoVTRja1hvUEN0V2tvOEIvMXMrUHQyeVBuc0xiVFJKRFlYUVpx?=
 =?utf-8?B?d1cvcU45OUozbUh4YmhKODlwb2FaSDJUOTlZdk5QL2VlekpYSzhvcXRlMU1W?=
 =?utf-8?B?cWdqanNHTkJXNTZZOThEakpFeG5oR096Sk52bGdHMk5UN29GSzNwSWdGR2pZ?=
 =?utf-8?B?T09HYmNkR25QS0hBcTQ5K0RmSWJzQkV4djRQckx2YzVMQktUNWpGdE5aZTVR?=
 =?utf-8?B?WWZCN25UUTcwcUZLSGJsV3ZYbVYyd1JwZitaQ0RUditCUTlvcVkrdGFVdnFX?=
 =?utf-8?B?MFZiMnRpeDM3RkJhMCs2RnJOOEJsZXBLVjdJbVF0U0Y1R0FJVnhtR1hkQTN5?=
 =?utf-8?B?QW8yaTg0R1dhTHNVS3B3d1FVaVNiM1Y1MGdWN0NZTU5ja2JtRi90SkFMSys2?=
 =?utf-8?B?TGt2NS9PanNZSUxxMW4yQk1DRGJuUXREbzA3bytkWWRwUWRtWldhRVdlZTcy?=
 =?utf-8?B?ei9CWXF4RnhZckhhb2wxdW0ycjhLalR2YjFySVF5YkVNNWxDQ0hBQ1NJVEdQ?=
 =?utf-8?B?M2tzWFRxYmVyb1ozSk44K083Q2w1REdwSW9ITEozTG5hQmVqTTVKbDhrMGdi?=
 =?utf-8?Q?jDdJuqFv3P3tP4+vc/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef0b0b2-0e48-4fd3-56f3-08def5c0c8cf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2026 02:49:08.5340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvSWjy2PRqLUR3QsFIyYXStwVwkC402R8OxVRJswYqVURTqSjdR+ARw+7kYFXPuS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB999263
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: bjkk96m7min33zhb9kgseex7ww3ckk5n
X-Rspamd-Queue-Id: A44FDC0007
X-HE-Tag: 1786243753-732
X-HE-Meta: U2FsdGVkX18IR1V6dwM/6wT3V3AicN0rkUXw0PVpxx/A5koevimpuYjTrWeF/8FMuWaie39/ek29YmLeo9yGeyFrYNGol48xKuRzjJypeQtGp4cGAoHjVZ5bQ/l/11pLqX/HWbmFBDTeLpiroP//KtqqX70Q9HIuoo1KPPogtD4cClOSJ0a9PlLzWF+SM1opsGFLwDc2ow+0CzyX7W3+MPmreuUwuOSLg1eJqRvBoMi+h7bTeBxesZzhsSBvFqps5tpD/TV6XWgx3rCBnZdbECwFwZaKzY6AfybDLx10ur5w/FMxDOuElOs89Jk/dxhiwrM4z2oIqbt8UBCZu1vCNEqhdkmj7gTuUaPClbuT2yGjpHA8eUbj0FQfcni60ZJqdNEBY+eyRVhcEHgH7n/EL09oxNS7R+OBoNbEtW3siXtPrinu/zvPH4Fus7+fXuhR0ohVAoFU07oW1mnpnvUh6xu8hlfwD0B91Et0QBytdvyiqjs3yKGTowei10bvPW6SboP1z3DvRa6ivqdm27Ztr9zmnvq73HKXTDruai0JBGxlkUaIjavPoW+ujkriNiI3ZwLTlD6NuY6MwqNzg6ey8m+OlnRoaJZBCdE9XEbEgci1bNUV9BBYFlSa6d0LmOxzD83K+i5UqBgtC7uV/8Fnu6Ci5cXmyI3DjSnGHpKqIBWg6iYXmjL/cZuNb4RIQwis0ek3rXpJFNcEsPGDd3AYcy336XE0woAaDmlGYC4OQFBS1MIFm+nYoav/Yzap7eCujl2xHsqyaJkUN2XgLVQQtu2eTmjnUzLAoHVTdW/ldlCWEODmvJFmiolD6a4fzgsBFEODvOM2YOPpKekiLupDdFNvHHsPYPH6tFoM9OLwQsDFZfQDpfKlllgMy6AdbS9cLgFhVE2c+OMU2/sU/suOHsIxFm2t2I2/glh1dabHsWosEA0ipQh0ImAjKEvJtsLVRY7NPOkKA6og3laXz8v
 nh34oDzU
 v1WUO1nZhYBp5KHRAKquLU3nl5u/sFoDTq7Xob8W8p4aDm8GOYNPVAwe4TKcRJDrM3XStcaVrimzvDnzk3VvWzunxvQkVCFhrdJi3cnAOuzqouKRO13IKZeUTGSZn2ICbeTPOyn3DOrMjdOxnbrGtyJDuYeNuxw20o/KEOP48Oo7TsksNDR/QTu2Y2X9JCkM5ZdaXs05i7o3KQj/sMdhUQcPMRGkopPBuDSO9leUGx4W8guh2WUpYDhvRAM8TBJdmykf4c8ZXJQz4H5ai2zbf9FywVVvsbf0pixLG6TWL5yeNSogbg5/oI8MruXsw86P1CY5Zn2j0t/DwZIQgL/jxtvpLidc7jguTUR389PwfLqaqS7wqpzSVCvnA32a8Ba6HVjw906/otyLv49YOXyz8MyMenzMRYKLwAChuluDkEm+L0h/t7McXqvV/xJgou3OXrKKJuhKa4wypbMrOq88G+YScUGqEhyFNLVexuKDVLRqkqYqVKc7+Ebg7+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Only __folio_freeze_split_unmap() sees anon folios and swap cache folios
> now. The file split helper only handles page cache folios, which hold
> exactly folio_nr_pages() references.
>
> Rename folio_cache_ref_count() to folio_swapcache_ref_count() and drop
> the anon check so the helper counts what its name says. The file split
> helper now uses folio_nr_pages() directly.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 35 +++++++++++++++--------------------
>  1 file changed, 15 insertions(+), 20 deletions(-)
>

LGTM. Thanks.

Reviewed-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi



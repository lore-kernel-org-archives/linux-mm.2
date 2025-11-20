Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67B53CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72136B0008; Thu, 20 Nov 2025 10:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C22B26B0026; Thu, 20 Nov 2025 10:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3C06B0030; Thu, 20 Nov 2025 10:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97AA26B0008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:01:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 873001A01A9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:01:14 +0000 (UTC)
X-FDA: 84131298468.03.261053E
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012043.outbound.protection.outlook.com [40.107.200.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7373EC0027
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:01:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cJKK+qSi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763650871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjdz1xBRiW5GN2fSky6bNaPjbqx1FljVmmCUSqbeWXE=;
	b=uxkj0slXRcmBveQkJjWY3E5UFkiXCFnO8woWIWuUivrZCUW7pPEDdxYiHBiQVBrwgVX/uP
	67TDYoVHrDRsCYMdF2yizH5UWK/oLwdxxlbi9Hhn0/vOFMvPpC2je9ALZXbeIeTZEFy02e
	OEUN6+qORMQh2tGuB1eoSStuHUKGTZs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763650871; a=rsa-sha256;
	cv=pass;
	b=aPyQYU/Cv8H/UvobzTvbV4Coxw2NTvwhCaEzD00Jdr3jqoid5ZZXD4DzjRDl+BWaXvd7p3
	RpkQeA8rMK8pO+RUX6bWmRi9wuEi8U9rNpb4l9KKduFRm/m/vfGpuOA+l20IVqSKF+aB/z
	gZ87/PrC1cFnwOvzklxKkpAsxXMIHLs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=cJKK+qSi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RfDGJ5OHxKHz9vUtubf29cTWzzAqVphc8XAT/mgfapCKy1p1pjbvWffKAw4NHvRpQ69zRogRDx8xeGmXKfQ4ckDzgyKMWVyVv2AWS3/50aAZ7UR4r40FxutgUoouMZWiDrIo1YhtxcxIq/RLnw+ofOUw6vMfHvIkztFNI0UHZIt6DZ6ja+9lFVM900+qFU3H4yswsON4bQ/c+MKZkkOLGCDIhcHEfgb3alRMr2eLvPmtrCPjdFIeunoH7QlGczxtnJpSCqg1F95QvcR9sR5MpEt85yxr0YSEtnkGn8FGM8NpaviOlDGmA9FaiTABGKGJh1N3bGVO9T8lqowbShvk+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjdz1xBRiW5GN2fSky6bNaPjbqx1FljVmmCUSqbeWXE=;
 b=yP/sV3NIiGnQiSFA/aOVBq2flN8i496yKAGeA3zRyzMcnViBfmMlz+iE7ImMeC9m9UYtbfGg8Sd2XGsso2kXsBypNTi6C4jkIX7d8xjDSA0JHeks0ku3TnEu66CRxs4MxNV7tfriTFHYRjJRtrjka1RolHUxrrhbwvCPR/iFJbzcb5uwpzhqL1wNIviX+2KWuR8x3NMGrhC+6GWC0MHhWyxr3MxKvpYqjmVifTdMa1CTP2bvoZ77nnMmpRFgfGCVRbBHplQ22L01GNxRSKVLPGIdGGlqW8Oh7UEIxKUamy2UWrR53igxgVVEts2groies+u4eTuDN4e0k0p3qZqOGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vjdz1xBRiW5GN2fSky6bNaPjbqx1FljVmmCUSqbeWXE=;
 b=cJKK+qSiQ1g6dmRcIxoZwfMcuYQiFoxPJIpxb/xgxDRNkORRJvHHS9NVQXDw/aIVmXJJsQDMKu2abfTXP+JY4x1y/RKKdDvK7m40o3oEGUJVM+2v+OeIZWzw+FocV2vJlAbOHY/HVSA/Gbc18WtKsWc9Je5DUgn1IK61nN4eO+3l5X+DHi8nrrhadNPiB+LPvGgvSpsK7i+jDuRrBAi1T9FYjtRbcWlt/0U5jFIHSfHpgltZPDRwN8J6F5nY6gT7V5+ZKc+22Nsx74j7+SH63hIJ44wsYO6xyyfwIeMWIPcL6sEaIpygujF6SKd9i4DqlV5MCq/HGqYXPnpWv5xRbQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH2PR12MB4119.namprd12.prod.outlook.com (2603:10b6:610:aa::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.11; Thu, 20 Nov 2025 15:00:58 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 15:00:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] mm/memory-failure: handle min_order_for_split()
 error code properly
Date: Thu, 20 Nov 2025 10:00:55 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <86CBD3DE-2245-4C79-BDA3-4977548898E3@nvidia.com>
In-Reply-To: <b7af446a-eb74-483f-8a88-d48266278f05@nvidia.com>
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-4-ziy@nvidia.com>
 <b7af446a-eb74-483f-8a88-d48266278f05@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR11CA0012.namprd11.prod.outlook.com
 (2603:10b6:208:23b::17) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH2PR12MB4119:EE_
X-MS-Office365-Filtering-Correlation-Id: fd56df45-a2e0-4e87-020a-08de28459caf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Nlgxb0hIRU1wQVA5eHVwOFpmeG9FUmVmdi9oQ2FnVGcwK3pyenk0eHo3TkZJ?=
 =?utf-8?B?ZEE0TzVTampSeUVQWTM1MGN1MXAvOW1mU0FtVy9kRis2cjdDYjZ0QkpVd3Ra?=
 =?utf-8?B?d1MzRWpPdmZUdndlV052d25OamFWTjB5d0puWXNEZTV3K0lsWFp2TjRFNjdD?=
 =?utf-8?B?TWVXQ2NMOTJzM0ppTEJweVlsWlFqSXpic1Q5V085VUppRFd2TjhEeUZDK2NP?=
 =?utf-8?B?dEhObHg2cmd3TkR1bUdLWDRWWU53S0xlYmVYTDlSWTMvNWxBVzI0VGhhakJz?=
 =?utf-8?B?eUdBM0RObkZsVWpCREFicXNZQTI1d3REYitNNW9BREJ0NHJmenZ3M1BnU0hN?=
 =?utf-8?B?bFNDRVhjOHRqU0RwK0V1NDR6YnRZazBGZnM4V3hyZFJCRXVTcVFKZFRBUmdn?=
 =?utf-8?B?VXNqaG9ka1kzd2N6U1hXZytFZElMUW5yemNLcWR5TlJDYzBCanRTVE03eExy?=
 =?utf-8?B?eDRmUUVLYzNKdzE3YWQyRlc3eW56NEdsVTVMaU5LMXZSR2htc3RzNW9iVE5N?=
 =?utf-8?B?b0dVRnllNS9nSktwZ1NEMGlZTG1TdmNHSzJpZ1o1eFJaTWhEVG5vNndvZVVK?=
 =?utf-8?B?a3NMUVhUd1MreG5QRDNUSFV1aGM2VlJSY0tORCs0ZzhUSzNXaXl2bEJLV2oy?=
 =?utf-8?B?cnBZblI1d1N5SEw5MndvYlNQb0NTQXg3SWZIeHQxY1B4enhybldWZENhTkRs?=
 =?utf-8?B?UTlOL2pBeDNaaCtneHk3MTFZNW5ISlVBU3E4MWczdDZlb0RIOFQxTjZEbmV0?=
 =?utf-8?B?ZGMxS0o0bWt6amhOZE9VOG9aNHVBRC9UYWpndDYxTHhxS0pYb2pPRHlhMVJ3?=
 =?utf-8?B?Z2NCTng4TE1qTkxlRm9tVGJ0UFVFWlNBQ0xnbk50TmplQ3lZV3Ewdi9lRjNI?=
 =?utf-8?B?c1E1dkxMdHd0SlNFcEI1SVdoUEg4UUZ0UTA2VzhLeHh0T3pFdFNFdFFjZ2V6?=
 =?utf-8?B?SG5aOHVxeTVnSEJhTzV0ODBETkZTL1ozaldocnVYUmN6L05GdnZKdGhscU9C?=
 =?utf-8?B?ZFRSdklGY2g1OVlqbnpzVzREQkJyWG9MLzMvTzZVRTV0U0RRY0NBSFZWVzJj?=
 =?utf-8?B?b1BPRW9wRlZyaXY1Q2I5TFppdDdpZTM2ZE84bHB4amh5QVUxU1pDNnZ5V0RQ?=
 =?utf-8?B?TFJjYUMrUDhKRW5mZ1JSaVEvSmlYSkZRbUt0SHpHcHNDTmkxTjlHTEdPUnBa?=
 =?utf-8?B?OGRZNXIreUJoVlNDc3l6YmNJb0VQaDF3YXhGNGtvcUxQcmZ3eis3cEhpWG1X?=
 =?utf-8?B?RXlrWEpqcjJZbHlqYmRTaFBMM1RQTERsYWt1VHduWXJEc0NwN2ZDQ09BeWFF?=
 =?utf-8?B?OVFPUCsyam95OTNHeU4ra0JVMkdiK0Q4NFExa3MvTEZ5bVhWaXFjK05PeW1Q?=
 =?utf-8?B?OUJ3cjFmR3BVYlNpTW1RUTcvR0R6Y2o0TTJNWFE2RFhrRFlHRncrWlF0K3k5?=
 =?utf-8?B?OTdGU3NNS2hPQ3pZN3JyNzlFUTR4VVYrcS8zcldsUTUwaHpBWkVZbGwxZ2Zr?=
 =?utf-8?B?c2VWU3JKRmJOckkyd1FhbGVMaklESXYwbkJyMndLVzI4a3FSQUxRUTY3QXpU?=
 =?utf-8?B?OUJPSkYxaUZIdUxyZmI3UjJNZDgzak9OcEIyeDFzZHU1MmNBNEVYUCtoSTZT?=
 =?utf-8?B?VmpJbTQwMk1mWkxLeVUyZEg4R1Z3ZU4vcnBwLytlTFJxeTZFcEVETCt0Znli?=
 =?utf-8?B?TlIySllUWXpSRE12Vlh5WFJKSjhGU0xhUkFLcXRpWEkwWnI5bVBCK1VaZE1i?=
 =?utf-8?B?MDdVN2FnQmt0NnlhOEtpMDY2cVJrYS8vN25OMWJFUU5LZzNkYUlZZ1FaYksw?=
 =?utf-8?B?QjUxVzJ0Ym9BRmhTSmkrN2haT2FNQnV2dURka1hweU4vcVcxL2o2d2tWS0U3?=
 =?utf-8?B?VXhTU0t1dUt6c1NqckRRMDY2QmllZHUyYkVkRTVtSEJoKzBnSEI1TjM0ZkFi?=
 =?utf-8?Q?uOYBUgMuQAeox7Rv2276sc1UF9KRDfBo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGRxM08xeDlwUXBSWnZCUlJ3M21uZVJ4T0FMTTA1dkF1YTZVdDZrTElReUZT?=
 =?utf-8?B?aURkS1ZzaVZmMUdUY1ExR2xWcitoTU5zVktVd0Z4VklUYmdJVlYvUWl4UFRn?=
 =?utf-8?B?dC84YndMc3Zaa3VLdDU2TXNqcXFpWGxRSS9US3dDTkUycVAvTTFYRW1UQkF6?=
 =?utf-8?B?Vno4ZmdadStoeVMrbVVGN0p5SzJWRVBCR2tKcW5WZGtYSDJtaHIrL2k2RVdR?=
 =?utf-8?B?YUkyM1IrZExrTjBjQThGeG1NdEhNTGtsd01oWEtTNjcyMEcyRnZET29uNU81?=
 =?utf-8?B?M21GcVluOUVCUVFsR0dZREZGNHpHT1B3MHNLQm9HZXhNZERJV1hpRWFERXlF?=
 =?utf-8?B?TXl6N3pmQ1Y5Ri8zRHYyd2ZPeW1uVGNDQXV1UHJDeGlVenRTNmRkdTVFbkJW?=
 =?utf-8?B?ZEc3SXFMVnJLTnJaTGU1cEtIUkRYdjFuUnVqeUpERjVnck5RS1NQeVZMNHdw?=
 =?utf-8?B?T2liRTk2SDFReWZ5aEZtZklJSEFLOXR6LzFzVVJ0VzFoOVlwZFcrVVRxVUFZ?=
 =?utf-8?B?Wmd2UzduZm9XbUI5eTlPQU9zeGdZWjhOWWRRaVFZYTFmZkt4ckt2Wkk1c3Er?=
 =?utf-8?B?dHNVblZ4ZEdHa2FxTlRlLzU0bkc1WDhEYWo4WHRaQ1JLWnhDNkpEc2UrZEpU?=
 =?utf-8?B?WkVkNWpMSFF0WGp1Zk80ZGUxVXFLcDJqWnpqZjUrVllrVWhLM2w3TzBZUGpG?=
 =?utf-8?B?bGJaUW1tMzhmTGVPNVNSME9leGFBU3ZXbWVKL1JXTHoxWkovSU1BMkRjNVp5?=
 =?utf-8?B?dUVpTmNJeXY5SUxDSlRtNmtaMmx0ZVVCMW5UOUpjVlpJQXdzUThZbXZMLyt5?=
 =?utf-8?B?YWVXc2haRGVOQ2Z6MkJ4NU5Layt2SEFhbzlJZ2pYb1V3d2pia3kzbEFUbVUw?=
 =?utf-8?B?akNqa1ppaWFicWhJbW1ka0lQU2pIU0orZEo3QWtvWUM2M3d6SGlzTWdnNlo4?=
 =?utf-8?B?Vks2aVI3T0gybENLV0pIYTVyWUl3MUcyWjRuMVRiRmQ4c3JTTTNZVTBzZ0hv?=
 =?utf-8?B?eWRScFp1WlFwZmxLQ0lZdDJBc3ZVK0xhS2U4WGQ0bXBMbEJMamw3c0dCZ1c3?=
 =?utf-8?B?M2RwNFpZUlN2S2VTaXhqOXRlSUVQa0VHQXdzVkVWVjZOTDRheUZqZUkyeHVB?=
 =?utf-8?B?VEp3M2RSenJEQm55RGl4cmhtdURIVVlTT0g3WmRBZDdvMU9ZSmdlcUszTUxR?=
 =?utf-8?B?WE5FTkpKNmtEWWJTK2d1T3JUa3d2dnZubTFDamxVS0IxeHgyeTU4ajBxVTRi?=
 =?utf-8?B?TjB0WHVyc2VlMm1GQ09WWXFSTDUxMktpazBxMURNUG80b0JFSWQrSFZ0MGxw?=
 =?utf-8?B?SUlkblQ2RmwwZjFhbGgrTDAyOEFZRzhCQnBEbDUveWJjY0tVWFFKVFVOQW42?=
 =?utf-8?B?enNIcjdSNUc4SXkzRWJYNjNUVmRNZjE2emh2bE9SUkZNK2VVdU9WM2ZNUGhw?=
 =?utf-8?B?b2tjOFlWMlIwM1pQYlVuek0zRzdsZG9RT3ZaZ0VJMGtoaTdXT2x4Wk04R29w?=
 =?utf-8?B?M1BBd2ZwZGFoMnlPWEUrc2JwSHJiV2IxQjhkbCtrMUF5cC9pUGo2dHM3R1B6?=
 =?utf-8?B?MEdBZVJGN3pGaFZrdm83Y3J0YnREVVFndEhxYUNoUU1HdXhjTHllamhTeDJJ?=
 =?utf-8?B?b3dLWHE3M3lEcHRWL0NIMXR6eEo1d0dYMU56TnkyR202QjVUY1VJNG0vc2M3?=
 =?utf-8?B?V2Fxdyt2aUtadGhZS28yU3RkdkoxZjhjQnpmaTN4UFRQVXVDSFR5SkUvbWJS?=
 =?utf-8?B?c084a1FMb013OUxkcDkyT29ncERNWCsvYlh0bW04ZkNJZ1UzSERTSStRMGUr?=
 =?utf-8?B?V1kxTnIxK29KUW1XRHk5QjZnQVpOMW80S2NvSlVvQnlnSzVOUzRMOWZXOFo0?=
 =?utf-8?B?SWFqUVRZcFp5dGIvWnlzUVJWNHNHanZTSEJoRDlnMy9Fei9ZY2l3eUdvQ3dM?=
 =?utf-8?B?Vnk2MkNSRmgxekhJS0xUYXFPMkpia3h5bUp5aHlTNVowdmhzd25GUjBqbFlx?=
 =?utf-8?B?cmltYzdVa0gxWXd4bjAreVlBMm5Vc3RCRzZrUURnZEc4d2xnWVNUc2JRYmhW?=
 =?utf-8?B?NFd2UG1Lb2xJeUhnV05CZ0Z5Q2lkdlkyL1psUVBBY3NudnlkdFcrT01WWDVR?=
 =?utf-8?Q?z8KmBgt3FK0RmDSpaeSz/DSN/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd56df45-a2e0-4e87-020a-08de28459caf
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 15:00:58.0939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbWES2B7x3DVGzfcmEAOkTh65+OA5LYdRu5jkXdTHGJqi3rNUcYyaE2qoCAJe3tT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4119
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7373EC0027
X-Stat-Signature: 4zgfizgmeudryk8hycbhr6nn96gduc46
X-HE-Tag: 1763650871-292088
X-HE-Meta: U2FsdGVkX18/+TMhSjBQK1F2oJucX+TWBzcAJBS7WU7NDQvEH1lL5njsRIfAsXF5gF2guhkjiqJJW1Wc1NRU7TGnb9dbiFMQOPR2IV6rCRJnKGfu7rPQvFwM8/Iks0JonQ5qFHxRgivk0ga4bs/kjXYVF7leIzEKR+phG+HB7jJfG/3R4Sc9nvLl8FY6z1UcxzfJPue4qniaIjtqtPFXl869BNyb6LszpfPiaNxSkZcyan3mBlPK1/AMERerVea31Aq4uhv5Uevrs0ptsEshQ0T1MGUlAe/GYRMM6y56AzCsf4iO+OZePOIwwQOkEtEorG6KL9oNCWNn+LMiaSu9bBaxMWYUlJ3ghF8ctEAzXGJkuMRXggfDViBhNEl2DS1Os8E0CSBsNVL9hGcg7DvsxkZANvzCJ4dABil8vUCOK5+1Iw9bkasc5Q3O+xZuF9kSli18jy8hqCSWaK2z8fp3uq2IvnijMwizeu96fV4kBn4ShjKz84/sPTwJCo5tS5PSHPvismP7D2c/EeBn6cJORCz+lNyAO5PuybNPtL7/nFiTMf61izPVZVzLRJ5/ijx9zBHKGR7IC2nCeDxoAzoAfcHyV0Mi8yRgUKFYM9SLgsSnFHWHVJkrvgXpMVaJ39CzeYxe2BgTyrZ4H1YRwgxGXh9UxztNgySw+7852XpNiFA9BNRYTWJV6h++eutA9nDfSLmv08HTi88qi6Ma8zU+iE5hJtUGnxp7hIlstlA/5fXjw2GVZRkOialBe/23fBgwe1fzKRVMscocV4J1tY3Z7nPlpKkzVxIVpc1lHTjeCGJYEmNAcD+gt1/OSNnbTMM5tF95GWfTM6xauEPwcmxn0axyTKdbWzTLk2yKsIwVy3vNHqaYnC9qyTY3OVmAkLQ+P2nDKTSSUOxZy1NmCJ3RGSM0/4Zp9DbKKwO0XZGd90L4SfLgejNqaErbe08/OvUn6VRjjHCVzgwPb7OGOIm
 uwxoHfkE
 tzB2hHczrD4CqfJrOjeW7gcVkpNf9qw35ZKIynF/6wxBzrKcEsWUL812TLiCsYR0TWurQxFTObUR8ROEbmuWV5Q3E+DTl6Xp3KdnARVuj+RZlrObbJV2/SLTD/+KTXZFhk3sq0e/bd9VbNcdbVFTav/qOs8ErlhStBtlUfBD07F3XafHodu2FmIt42cboivn6DGWPprweNXnQOPZbFOUjGY0tVDKWZj6h3vKxWskPPveuNsEhdIJVIX7A4CrPHP/wXqqF3Kf4QVfLZ4GDPjTvMSm+uvHUWDSbhqOdx3m1xjvh76SJehSxTBYoUlhe1lJauQmpqQbq5k/qY02TScFMEmqOXEpcVS9HJw+Vz8CVz4chw6RG73ysrl7vscNp1KckrC4ph79kcUc5hYi/yQZgFt2D4OwqvzsvWz+fHUd8JoE4dsRXzVqvTJQguSrChIk3F2mCwU9WY8SvvfEt1ti91EAPsxKLhaDUnI43AWAuL1jCnGc/qIG0IV1slt/o4TPmEcL3dlClVPmwGrBEkeeFMfZkumUsDfUaO5KLiinkwr0DQBVdgWaRP/CHc/r0ZXKaRtCt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Nov 2025, at 23:45, Balbir Singh wrote:

> On 11/20/25 14:59, Zi Yan wrote:
>> min_order_for_split() returns -EBUSY when the folio is truncated and cannot
>> be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
>> split_huge_page*() target order silently"), memory_failure() does not
>> handle it and pass -EBUSY to try_to_split_thp_page() directly.
>> try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
>> new_order is unsigned int in __folio_split() and this large new_order is
>> rejected as an invalid input. The code does not cause a bug.
>> soft_offline_in_use_page() also uses min_order_for_split() but it always
>> passes 0 as new_order for split.
>>
>> Handle it properly by checking min_order_for_split() return value and not
>> calling try_to_split_thp_page() if the value is negative. Add a comment
>> in soft_offline_in_use_page() to clarify the possible negative new_order
>> value.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/memory-failure.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 7f908ad795ad..86582f030159 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -2437,8 +2437,11 @@ int memory_failure(unsigned long pfn, int flags)
>>  		 * or unhandlable page.  The refcount is bumped iff the
>>  		 * page is a valid handlable page.
>>  		 */
>> -		folio_set_has_hwpoisoned(folio);
>> -		err = try_to_split_thp_page(p, new_order, /* release= */ false);
>> +		if (new_order >= 0) {
>> +			folio_set_has_hwpoisoned(folio);
>
> if new_order < 0, do we skip setting hwpoisioned bit on the folio?

The bit should be set. Anyway, I am going to take David’s approach to
change min_order_for_split().

Thanks.

>
>> +			err = try_to_split_thp_page(p, new_order, /* release= */ false);
>> +		} else
>> +			err = new_order;
>>  		/*
>>  		 * If splitting a folio to order-0 fails, kill the process.
>>  		 * Split the folio regardless to minimize unusable pages.
>> @@ -2779,6 +2782,7 @@ static int soft_offline_in_use_page(struct page *page)
>>  		/*
>>  		 * If new_order (target split order) is not 0, do not split the
>>  		 * folio at all to retain the still accessible large folio.
>> +		 * new_order can be -EBUSY, meaning the folio cannot be split.
>>  		 * NOTE: if minimizing the number of soft offline pages is
>>  		 * preferred, split it to non-zero new_order like it is done in
>>  		 * memory_failure().
>
> Balbir


Best Regards,
Yan, Zi


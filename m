Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159CBC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 09:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04266B0093; Wed, 30 Jul 2025 05:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98CAA6B0095; Wed, 30 Jul 2025 05:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806716B0096; Wed, 30 Jul 2025 05:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6746B6B0093
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 05:22:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36630113D1C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:22:11 +0000 (UTC)
X-FDA: 83720389662.15.A91D38F
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4FC8840007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 09:22:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lul5whos;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.85 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753867328; a=rsa-sha256;
	cv=pass;
	b=0x3kFVzdprTiZwbtd7UT2Qr3l23Ws3I1f13fQWYjDALwIKbkDXAII+siXX5z44RaKoSUua
	XRx+zoYLDz7oVFIelwRSyghsgMDY2ZjAWBIiEdMcLsifyQZxu1ZpxF8X0ZkNx2v5zRIySc
	41YCdmouLB9zDp0tMlxO5J0aRlxV5OA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lul5whos;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.85 as permitted sender) smtp.mailfrom=balbirs@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753867328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQFLP1vdwsP12G8DITebyL6kd5esT3RinkF+NTIHXWc=;
	b=2ny/BXjglqGk4yEtwifVAebl68V52LaV+AHcNevxyvQ/0x1ieyBlE5T3SvHDAcZpLXrQsk
	yJ/WH36Fd+M7QfkjLj5cQDD8K4ifPuyJG5IehkI0evkWNumsnHvjIsxRiNUHwd6dpMLNV1
	PabkMv5XeKtMM6m0c10Lo5Upm3EBA9Y=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SrWbN5z4ChzF5+cwiUuutSUm/8CGj6IGOBmNyMJJJ9E2D3px8tYAIajOWyT9ty6AH2l9KorhMdD/r/dRpXROhxmJYOjHMSbRNbYoEPGsb1INBsBANZYSUk80GJbOmRjA2Q1zsgPpbOrCRw13zWnFIVv0ZMvzvnzAYXCxSdIktOCsUXFYE3a2LyDGkJIdLqbtH7DkyPDwHK/byMbykkwwWcM5kFanbnZmstFwdJ5KRDMZKvoQ/guNf1hvP0G2ej0IUV76YQM7XnDj8/Q4ez2LFl41OfavSQ4pY0xcCD5HG2+phF9NqxroiYnR1ZUfnbZoPzsXyfNRqC0CjxAxInTh8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KQFLP1vdwsP12G8DITebyL6kd5esT3RinkF+NTIHXWc=;
 b=KzVa9TNHWMeOh2muP6zPbRjbiZ1y/iKFsKcVj1+WT1aK0no77mR5Ov5wvDC4fl0TvixzSvIqlHRZQXre2UJSY2B3NA/3afhlmyHUAICv81GeBGjyB9Gmk/jJas2hDRGqdMer19B0C139FiVkPiOeZh9Gn+xI7MpzR8QP+2MH+krtyUqI9AmSHTtusip/9KX7J7zF9d0LiiOCu95YWSaQo2PJBRV8bjF3VGxnoB5ecNcAOlU68xqA5Q8uVNbg0Kc2HzwOO9TBRZ9d3jSMD0QHAlNnk2x2tnpRi69Rp9I2xETCcLPqlVcSzR+YB4ogvwL370jxlo4yHA0Tn7rtjuE/rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KQFLP1vdwsP12G8DITebyL6kd5esT3RinkF+NTIHXWc=;
 b=Lul5whos3sEufO1FY5941nZJgFaibF/Ii8w1OKMCxxjyJyV0lKDz1+2jMCXA75V3H4AUP9Mv6SiunN9mbg4SgpV6fMsdMdu1Hj1CX6EL1+C7BwaBGKfVnjsGWGS8D87INNsmgYvmPjyl1g1h3pd1pV4boVuFkZVfw3kuyZINL3g7EgSH6/SmoQkLqiRYy0aXBggmVdfngyuCLDPl6mbArQSI0XzVTBxNJuHcg7zmka8J06iZfKK9zYiZEuruaFNp4ASnCFzTrw8U3sVHNZtoBGFSTkDUGN5Lv+xLHqdwhhpfd8vqg16SmGXkxgnCTnPEBOOAlg3X+nhwV9xe1GH0JQ==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB8428.namprd12.prod.outlook.com (2603:10b6:510:243::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Wed, 30 Jul
 2025 09:21:57 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 09:21:57 +0000
From: Balbir Singh <balbirs@nvidia.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Balbir Singh <balbirs@nvidia.com>,
	Karol Herbst <kherbst@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Matthew Wilcox <willy@infradead.org>,
	Peter Xu <peterx@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Jane Chu <jane.chu@oracle.com>,
	Alistair Popple <apopple@nvidia.com>,
	Donet Tom <donettom@linux.ibm.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	Ralph Campbell <rcampbell@nvidia.com>
Subject: [v2 02/11] mm/thp: zone_device awareness in THP handling code
Date: Wed, 30 Jul 2025 19:21:30 +1000
Message-ID: <20250730092139.3890844-3-balbirs@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730092139.3890844-1-balbirs@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0127.namprd13.prod.outlook.com
 (2603:10b6:806:27::12) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB8428:EE_
X-MS-Office365-Filtering-Correlation-Id: 65e94830-d9b3-481c-195b-08ddcf4a87d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHBZREo4UVRxUHhTZEYzZlhlWHVUMlVVVWZnSmRIM2MzQmJ3WjV2ZlNZMFFl?=
 =?utf-8?B?SDdCYnNkQkpKdHByNkR6NllvVDdjRHUxY2t4NkRrTEhXMnFKejVuREFHZHdK?=
 =?utf-8?B?Vk55UHdjN3VlTHNtTGxIdWI0Wng4aWNQdzFnQ09Va0hENWo1VlUzQzNLMURx?=
 =?utf-8?B?azJlTE12SWcyS1Y2OFhwQUFDckc2ZW1lWW9CVlQzcGppVXRBRkUwdEVuVGhr?=
 =?utf-8?B?blRKK3UrVGFUMzJ3b1B2d2FpdnArUXdYUjRlaFYva1RUQkx1bmNESm1CN2RD?=
 =?utf-8?B?NVpvUVEwTzJQd3hCblRJTklVajl6VzVZK0VMdWNKMWFBaWhrcy9yTXBNbmZS?=
 =?utf-8?B?Q2NGN2sxNTgyYkFtTGxiVm5lMmk0WmtGdnBhWUdZUG1BNEpHdXl5dUkyM2NI?=
 =?utf-8?B?UGdkZGFZNUx0VEhYMUVOVWRBWk9wN2dYQnRHSDhtWVAwQytFUVd5b0tRcXlk?=
 =?utf-8?B?NXhSMXFQR3crenlDS2tjbk9neUdXSzUzRkcwSGl3TUczQ20xZWJDS0crRXZI?=
 =?utf-8?B?L1dXK2tMcU1jLzA1RFZvTmFjYmdnWDBXQzYrTFlKWkxXaWxRdGhYazJwLyt1?=
 =?utf-8?B?aGV3QldMYTJEV2VtUnNVNGZxa1lGL0h2Z1R0Q3M2a3FGekIrRGlBTlRrOG16?=
 =?utf-8?B?bHltZkJkVDI5WjRncGRlbHF4eFZhQ1hWRzgxcWNZa2tlQ1VpMzdiYmNmb1Jt?=
 =?utf-8?B?bFZUVFd4V3N2Qm9WNktuZ0R5bnpjd2lCajh2eFdpWTNiVW5KbWU2N1JycCtM?=
 =?utf-8?B?THNNUWhGWm9SbEVCSHJ3ZjZHNFA1cnZrcFNjMGJGOU5NVkdrV01zcUpkSU9x?=
 =?utf-8?B?WW1HZElvcGdYbW5jQVUzL1gxcXBVOHNGNElhcmhNN0xBaDdheWVYeU5xU0wy?=
 =?utf-8?B?WFcxTWFqUnN1QW1mSFJtNnlBYXBFSjhOUDVmaW5IdkxRMEk4K2NlUWxlV1Vt?=
 =?utf-8?B?bVZ2WVhUS1JvbzdGUGh0YjhCOUg0c040YzdEdzNJcEJyYldKcnlQMm83VXFz?=
 =?utf-8?B?T05qZlFtSTZIV1ZOZVN5bXY3VlVVWjNWNG1BZXFoaVNadW9YRU96S3lGbnN2?=
 =?utf-8?B?SFZtSTAvNmlCVHVBcWZ1ZUZ5YWtIV3Ivbng5NFFUQVAwc1JsWFdwUUwzUjJP?=
 =?utf-8?B?eFBUZzltY0FKUEZPTytnbVpyQTN0Vmw0clRjS29yUjczMnlESmRub2c5d1VP?=
 =?utf-8?B?VUdESjFsSkFXREFDVmVEa1VlVGZPdHBQS1QvVnlDV20rcDFWVi9MZzIzM1Jh?=
 =?utf-8?B?cDFHcFltR1daVDhLRkN5V1czd0U4NStFOGpuRkI4R2ZFZkNIajJieXNzT3dG?=
 =?utf-8?B?ZkozK0pncm9tZWZMUUNET3JnQ2QwUG40dkFBTVVHWmI2TlRTQWpySzFyN09z?=
 =?utf-8?B?bVh3a05Qak1HSFdRcW1KNGVRU2RyRkFjOEZEYVZ1aUJjR25GbjJadkxBYmth?=
 =?utf-8?B?TWpUNWQrLzhhNXBFdnBMUllRUm5Pcm9tMjYrWStoeittVW1Pd0lRNXArc0V5?=
 =?utf-8?B?WDQyMUppb0ZtdnFXTlVacGlDSGFrTzlsN2I1MThtQTVscDl0TmFWZU1PQ1BP?=
 =?utf-8?B?M0g1VFVRc0lKKzloQVBRNlBoUFFPOVlVVjlwdnp5eEtKd3JlaVV0QnRxck4w?=
 =?utf-8?B?MWN5MDU4c3Qxb0JxeGpEWjFaU25TQ3pLTkJlM0dUYWw5dVFmMjFqbDE4Nkxz?=
 =?utf-8?B?c2g4RmFvd1F1a1dEQm1TNjhYaFFOQlFrc0J2YU94UHUxVDJwL0hnZXd1eStp?=
 =?utf-8?B?Y1ZGa0dtakMyTTA5dFgvZHM0THJRN3dlUkxiVi9GOUsrSDRpNUU2VU51R3dW?=
 =?utf-8?B?VkFuNXlCWWgxaldEa2dKcjh0dU9JT09SWENKZ3lqSVo5anFkQjVYNnM5Q2p6?=
 =?utf-8?B?cVdRbk85UFVDZ1l6dEZESjBEMFlTdVNrcTZIYnRuU2FZM1VPUmZ4dkl2dFM2?=
 =?utf-8?Q?ZqKzqtYzCIg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WmE3ZkgyL0JyMWkyNWROU01jbnBLQW9LbEc3RkNHYkJ2V2dnb25FaGo4eGdT?=
 =?utf-8?B?Z05EaThLVG5yaUlxd3h0dlFheHpZS1liczZ0QlE3U3lYS2FrTUZFVzRwa1pC?=
 =?utf-8?B?SUUybUJMWEFxM0V0aGNDaERSeks4RWJtZi85RVM3NE85b0lodGo0SU5TSWNa?=
 =?utf-8?B?VlFzVmYvdmhWRVl5U2RnVWpwcEYrSjI3ZTRObXJBZzhVUGtwb3ZYZXQ0bTdz?=
 =?utf-8?B?U2I3RmFSOE9OS0NsWnhoOVNieDAxWDAzMWZ6WTRJQ1FLYjJxSkJsdHRBdytX?=
 =?utf-8?B?cWQ5RWw5VjBWNmNEL2JHZ1VrcndCVThBZWtubTdlbWZTZ2Jud3RESnlDUWZY?=
 =?utf-8?B?RXdUekg1T05hVDllaGdOblBta2hZSlhpSVViZHJ1cXBJV1NJTUxXQXNIMW01?=
 =?utf-8?B?ME42MEZnNk1ER1hMeTlId2phb0xMVlRJUUpmTWhEREVzd1h6Kzc4QTEya01x?=
 =?utf-8?B?TVNsYWV1NXRQVFRNOVgveTc0RDA4SFZWOFUxVzAwbXdSTTJweWJFOFRNbGx3?=
 =?utf-8?B?Zlk0SUtPWWovbGtBN1AwanNBYUNPcFlFOWNubnd6dmY3empyQkt3S3VheEY1?=
 =?utf-8?B?U1BoNlZaMXBzMGdvTjhDcm5mSVRoeTZqODFoNWpQaE1qYWMwZDFWSDdtT1I0?=
 =?utf-8?B?TEJSbmtYeitoSHh2QWd2YkVNUVRIL05RK2E1T3VOaCtSNTZBV1BVc1MvRnBx?=
 =?utf-8?B?RTFSeTF0aHgxK2RqRGpUUStRNys4d0hlWlhwNGtZb0tSNmIwTGMvb2dtK3NW?=
 =?utf-8?B?T3JaWEdMVHV6ZWRmRWdveXRlcm00RFdJZFdPTGk1L2N6WitSRC8wT2VWOTVK?=
 =?utf-8?B?ZDJOTHBsSzZaL21Jamh5NXl6TVJObnoxdXpBK25DUHFvT3ZxVjYvM1BmZWlu?=
 =?utf-8?B?VjA0Z05pZSt1MmhrRkFTRlo0NmlYeTBZYVZvZ1JlMzNQVDRjVXh0UXN1MmhR?=
 =?utf-8?B?QzB1TU56TDFBNzU1aVlObEQxQndEa2pBbEdxZ3l0SW0vcnVZL2pIMmRaRGlP?=
 =?utf-8?B?a2hKL2g2aXZzNzA2dWhyRVFlZis4SlpNcEFpanVOYW12WUxCNitVQ25PSG9Q?=
 =?utf-8?B?RkFqL3drdnNOWDdXcDB5SDZ4WjVJS0pOUXJ3dnlMcXNTYXVFQTlVcHBSRDFN?=
 =?utf-8?B?QkJqaEFJZERXNW9XRFpRM2pKSFJONDhJM3NGaTY2UmNNc0xYOW9hdUhtSHhs?=
 =?utf-8?B?SFZFL2FSVlVkaWg3bWNpSkNXVkUwZXIrYzM5VHlxVmtGUUZnWnhMbjdYYjJZ?=
 =?utf-8?B?Tmx6cXEvL21EOFVCcjJ6YzlQZzk5WXBMdG9XN3RWeGJ3TjhxVHBBQXYrVWlQ?=
 =?utf-8?B?Um42WXowdkpuR0JzNTZ1a094QzB5UWk3Y3NhSEZNdEUxdHNTWlBTQlVaZU0z?=
 =?utf-8?B?SW55eEVVMG9aaW1KbnhsTzJMTHAvVXUydVBFWDJZLzRsQlFlSnp0OW51Vmtl?=
 =?utf-8?B?QzR0M3pLZ0lXMlQvN3JQbFpxSEd2K25KWEwwTVVGUUFpbFVVOVJ2MXpGODBP?=
 =?utf-8?B?em1jRjFWQXpweldMV0EybXV5dHZiNVNRa05QanQ1OHRaTFFLc01SWDRQL3hH?=
 =?utf-8?B?UCttK050TERJdFozUDJISUVFbHorM2QxSm5sVWR4aHY4d1FTb2JrbmNtZFpw?=
 =?utf-8?B?WVlCQmo3dW5HQmRqdGxHc1QvaE5rODQ1TTd3UHMwODBkVkMrbjlQYkR5YU5L?=
 =?utf-8?B?OEpvd0lYT0VOcUVqdDVQVkQ4cURsRmFGYmF2T2YveUJJbFRobDRWNWFmdGY4?=
 =?utf-8?B?RlRoUG9CQmdKcEZTbDV3UllDdFkyY2JGMnpva2ZXWEV4UEtrdERxQkxjUytL?=
 =?utf-8?B?anFUSXcxRWQ2WTBtcW1FYlI4L2pyKzJ3dVdKWmlkUjd2Q1B6ZHdsajl3dXRQ?=
 =?utf-8?B?cWZYNURKYzJLUDVmK3EwNkp5RzkxcGZ5cU1yclB0RG5jZFg5QzJLNnR5SC9a?=
 =?utf-8?B?UUwvT0p4TjdqYktJUFN5MzVrYm4xOFFtWlJuaTZ3TlEzQmlpU0J5VldjWnNY?=
 =?utf-8?B?Tk82Tjh6WXpvV1dFOWxVemc3L3RFNXpzY0JIR0FRdm0vWE5NVzR2Wi9FOVZC?=
 =?utf-8?B?VUY4R3Vnb2NDcm9xL2Q0b2ZjenFkTS9GYWlBYU8wNk5BNjVSd2tqUTEzQ3NC?=
 =?utf-8?Q?K4+qsUh+eQNSNjEih+jjQuJGd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65e94830-d9b3-481c-195b-08ddcf4a87d7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 09:21:57.3493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7N9zLin79x4R/DL+6DMssTceZIgJEIVSDgW+j/Zluvsc6J1ef8TzHYSt8WKd9RKUWOAlt6vINcN9mTD5zN2Idw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8428
X-Rspamd-Queue-Id: 4FC8840007
X-Stat-Signature: g4ies54a6s6kpemoknhc67ng4497nhnq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753867328-651243
X-HE-Meta: U2FsdGVkX1+IlYIuoG0/LxmddMqusKzF85eOeVTybZXEClUs7R27BBdUJzaWmsQfBZ6r/zpcqPGMFE9PM4HZ1runufGWHW4OsWnAfOqweunckH9Df9dGqz+Bsv/3BviJ4bH3TfHQZ9ZTMYidvBpDtlEo2eYWIBnBNNzPoofSwJvFLkynXpWHQxd8QFIZmNlkGiESJtHgPxLcEqoRSUCsMa+JT3GQszMbAGr+0+GW5nAmOjb3viGMUEVnMUIoY88r8Cv9Qh2BTcwfIR9IpYInF4CoNcnHxedASwSZMDXCQ8Mo0ThhwcHMvJBhxGVabkX88OUmc8oiYEx0WzplYjIR0GRrnJVe6hhyN/Gcfo8aajEuNYRr8qxlQvoKLglr4MoBfQMpddn92adT03JUnkS3A4uE2ygkscpWASkcAlK0pDhNzmRjFhVCRo4exp0dEtMUn+l0umqRdIS3vEQMC/vodG+mSgm2JnK0viK8b405giDBcL01VARvMgTubNnBd1cSITP1RVormOfAhS/GPu3WJclb4YmSCiS9tbl807XcumOt9T/njDBBQbAPR8dp7vzub9eP85++e8pXwVm6rohF1z1jvToXlthXiuqtioEL4iQhNkU7HabXSOYGUNseWqA/QVDzNR1+9RmrwsT+D2F+snBLTGXBgDWzjpKkLKvR0xHHylLxHZyUYM8JBttNMEbNVIbxdG/kbwObU8WFJ0C9wuCmPqRpQSW+8nhU2/xKVTjp6U4BqMKlvK3Rci5Bg7kP1SF5k2Zl+2ul2SU9/QEWFdq4ysW7TzZ92IILak29DBw3U1cEN6ZKqGsngj2V/N2i5Yj/EYnsKz5TYigDcW9An6pQnISNOLNAWfjXxb9KwgPpdJ6Bm0m1ojJnbTi4l9j/+yRaqoA4xlycvOeKbqtY4hBVs2mQVpb91+YDAM58Ymn5ShPWrsfP3NSUww4+RGIv0ab21jg1t66tm5CjlML
 L3DB9QF0
 FDUwi0oACqubrsPXnNkzIKyZqz+umxIcCiaiDbXJ2wr7aimUk5D18HIZXVrDIXXFwOYfA5uoSA6MrSkeuAGB7LXlrmVboe+7FlnUGpfEiTgHKf7wiWnufHbSEOyYYxXe1Hkpyg7ksgMHntWgpGanMoZc/c5551Agm9YINXidzPOeX8I6NUNgXk0CKXndgGnlWBoT5cyamJfEFhq9iM+xInnncHO47Jtne/gCb9yD9uYG7tKH7OBk0v23mBXCQLQH8dqBkL7JGwPxN46wUkYmqBp8daVAWmEvAJg8swrfGnRGjS/Rxwtz/WxCo3a5C/10gpT7RFHsBMdOU2TPJ02PCxOTeBndh7PD8yi7CZ2NiHKPwD3cfx82Xs8Dba0OvoaVyU9IQoRKljsM4niqADJpos4YxumfGjbwtAef0DCUVdKgfPRS5J9kxAwxbmrhch6tlz++wFFi2r+teH+56lx9PQIGYMjz2FnO9ZbeS70AzSKnWQPYLUy1COct2McGynKhSw8UCRwOsfln42ShjUB/HoUx/srlN1VfMZUvembqFs8h6HWeavLYoZQXGDEG9zpyTQZ+kHDKdVT0aA+6j6Rn08seEyAEenfNrEi8FdfdM/FXPDQD6QzzPY7hx5/b/acs3d9uvgDaxJhGewhzjOK/+I3+9Qj4G/SEJ1yNdZej/PDEnNkPVsNiBFO6MuouvPYmEcqfhe0d6PqrkwIIEOmvKpg9RZckf+L8VeIs4vfPTQ2yReJZrMguzm3WQzN1YiLUaXTakZHJQUKzeaApFAnXryip59hSD9XBONrbnPqLj/CHWltNXOoiuurwbJlTYks5yaElHlZQuyO19K16Av1uF6l8Uq8rUE+SMCXiDvPv0iMSwTO0UlkxxzmYoYLo6suGV5hlGEuWqYParSsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make THP handling code in the mm subsystem for THP pages aware of zone
device pages. Although the code is designed to be generic when it comes
to handling splitting of pages, the code is designed to work for THP
page sizes corresponding to HPAGE_PMD_NR.

Modify page_vma_mapped_walk() to return true when a zone device huge
entry is present, enabling try_to_migrate() and other code migration
paths to appropriately process the entry. page_vma_mapped_walk() will
return true for zone device private large folios only when
PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
not zone device private pages from having to add awareness. The key
callback that needs this flag is try_to_migrate_one(). The other
callbacks page idle, damon use it for setting young/dirty bits, which is
not significant when it comes to pmd level bit harvesting.

pmd_pfn() does not work well with zone device entries, use
pfn_pmd_entry_to_swap() for checking and comparison as for zone device
entries.

Zone device private entries when split via munmap go through pmd split,
but need to go through a folio split, deferred split does not work if a
fault is encountered because fault handling involves migration entries
(via folio_migrate_mapping) and the folio sizes are expected to be the
same there. This introduces the need to split the folio while handling
the pmd split. Because the folio is still mapped, but calling
folio_split() will cause lock recursion, the __split_unmapped_folio()
code is used with a new helper to wrap the code
split_device_private_folio(), which skips the checks around
folio->mapping, swapcache and the need to go through unmap and remap
folio.

Cc: Karol Herbst <kherbst@redhat.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Francois Dugast <francois.dugast@intel.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Balbir Singh <balbirs@nvidia.com>
---
 include/linux/huge_mm.h |   1 +
 include/linux/rmap.h    |   2 +
 include/linux/swapops.h |  17 +++
 mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
 mm/page_vma_mapped.c    |  13 +-
 mm/pgtable-generic.c    |   6 +
 mm/rmap.c               |  22 +++-
 7 files changed, 278 insertions(+), 51 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 7748489fde1b..2a6f5ff7bca3 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -345,6 +345,7 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order);
+int split_device_private_folio(struct folio *folio);
 int min_order_for_split(struct folio *folio);
 int split_folio_to_list(struct folio *folio, struct list_head *list);
 bool uniform_split_supported(struct folio *folio, unsigned int new_order,
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 20803fcb49a7..625f36dcc121 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -905,6 +905,8 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 #define PVMW_SYNC		(1 << 0)
 /* Look for migration entries rather than present PTEs */
 #define PVMW_MIGRATION		(1 << 1)
+/* Look for device private THP entries */
+#define PVMW_THP_DEVICE_PRIVATE	(1 << 2)
 
 struct page_vma_mapped_walk {
 	unsigned long pfn;
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index 64ea151a7ae3..2641c01bd5d2 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -563,6 +563,7 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
 {
 	return is_swap_pmd(pmd) && is_migration_entry(pmd_to_swp_entry(pmd));
 }
+
 #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
@@ -594,6 +595,22 @@ static inline int is_pmd_migration_entry(pmd_t pmd)
 }
 #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+#if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_ARCH_ENABLE_THP_MIGRATION)
+
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return is_swap_pmd(pmd) && is_device_private_entry(pmd_to_swp_entry(pmd));
+}
+
+#else /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
+static inline int is_pmd_device_private_entry(pmd_t pmd)
+{
+	return 0;
+}
+
+#endif /* CONFIG_ZONE_DEVICE && CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
 static inline int non_swap_entry(swp_entry_t entry)
 {
 	return swp_type(entry) >= MAX_SWAPFILES;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f09..e373c6578894 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -72,6 +72,10 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
 					  struct shrink_control *sc);
 static unsigned long deferred_split_scan(struct shrinker *shrink,
 					 struct shrink_control *sc);
+static int __split_unmapped_folio(struct folio *folio, int new_order,
+		struct page *split_at, struct xa_state *xas,
+		struct address_space *mapping, bool uniform_split);
+
 static bool split_underused_thp = true;
 
 static atomic_t huge_zero_refcount;
@@ -1711,8 +1715,11 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	if (unlikely(is_swap_pmd(pmd))) {
 		swp_entry_t entry = pmd_to_swp_entry(pmd);
 
-		VM_BUG_ON(!is_pmd_migration_entry(pmd));
-		if (!is_readable_migration_entry(entry)) {
+		VM_WARN_ON(!is_pmd_migration_entry(pmd) &&
+				!is_pmd_device_private_entry(pmd));
+
+		if (is_migration_entry(entry) &&
+			is_writable_migration_entry(entry)) {
 			entry = make_readable_migration_entry(
 							swp_offset(entry));
 			pmd = swp_entry_to_pmd(entry);
@@ -1722,6 +1729,32 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 				pmd = pmd_swp_mkuffd_wp(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
+
+		if (is_device_private_entry(entry)) {
+			if (is_writable_device_private_entry(entry)) {
+				entry = make_readable_device_private_entry(
+					swp_offset(entry));
+				pmd = swp_entry_to_pmd(entry);
+
+				if (pmd_swp_soft_dirty(*src_pmd))
+					pmd = pmd_swp_mksoft_dirty(pmd);
+				if (pmd_swp_uffd_wp(*src_pmd))
+					pmd = pmd_swp_mkuffd_wp(pmd);
+				set_pmd_at(src_mm, addr, src_pmd, pmd);
+			}
+
+			src_folio = pfn_swap_entry_folio(entry);
+			VM_WARN_ON(!folio_test_large(src_folio));
+
+			folio_get(src_folio);
+			/*
+			 * folio_try_dup_anon_rmap_pmd does not fail for
+			 * device private entries.
+			 */
+			VM_WARN_ON(folio_try_dup_anon_rmap_pmd(src_folio,
+					  &src_folio->page, dst_vma, src_vma));
+		}
+
 		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
@@ -2219,15 +2252,22 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			folio_remove_rmap_pmd(folio, page, vma);
 			WARN_ON_ONCE(folio_mapcount(folio) < 0);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
-		} else if (thp_migration_supported()) {
+		} else if (is_pmd_migration_entry(orig_pmd) ||
+				is_pmd_device_private_entry(orig_pmd)) {
 			swp_entry_t entry;
 
-			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
 			entry = pmd_to_swp_entry(orig_pmd);
 			folio = pfn_swap_entry_folio(entry);
 			flush_needed = 0;
-		} else
-			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+
+			if (!thp_migration_supported())
+				WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
+
+			if (is_pmd_device_private_entry(orig_pmd)) {
+				folio_remove_rmap_pmd(folio, &folio->page, vma);
+				WARN_ON_ONCE(folio_mapcount(folio) < 0);
+			}
+		}
 
 		if (folio_test_anon(folio)) {
 			zap_deposited_table(tlb->mm, pmd);
@@ -2247,6 +2287,15 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 				folio_mark_accessed(folio);
 		}
 
+		/*
+		 * Do a folio put on zone device private pages after
+		 * changes to mm_counter, because the folio_put() will
+		 * clean folio->mapping and the folio_test_anon() check
+		 * will not be usable.
+		 */
+		if (folio_is_device_private(folio))
+			folio_put(folio);
+
 		spin_unlock(ptl);
 		if (flush_needed)
 			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
@@ -2375,7 +2424,8 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		struct folio *folio = pfn_swap_entry_folio(entry);
 		pmd_t newpmd;
 
-		VM_BUG_ON(!is_pmd_migration_entry(*pmd));
+		VM_WARN_ON(!is_pmd_migration_entry(*pmd) &&
+			   !folio_is_device_private(folio));
 		if (is_writable_migration_entry(entry)) {
 			/*
 			 * A protection check is difficult so
@@ -2388,6 +2438,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			newpmd = swp_entry_to_pmd(entry);
 			if (pmd_swp_soft_dirty(*pmd))
 				newpmd = pmd_swp_mksoft_dirty(newpmd);
+		} else if (is_writable_device_private_entry(entry)) {
+			entry = make_readable_device_private_entry(
+							swp_offset(entry));
+			newpmd = swp_entry_to_pmd(entry);
 		} else {
 			newpmd = *pmd;
 		}
@@ -2834,6 +2888,44 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	pmd_populate(mm, pmd, pgtable);
 }
 
+/**
+ * split_huge_device_private_folio - split a huge device private folio into
+ * smaller pages (of order 0), currently used by migrate_device logic to
+ * split folios for pages that are partially mapped
+ *
+ * @folio: the folio to split
+ *
+ * The caller has to hold the folio_lock and a reference via folio_get
+ */
+int split_device_private_folio(struct folio *folio)
+{
+	struct folio *end_folio = folio_next(folio);
+	struct folio *new_folio;
+	int ret = 0;
+
+	/*
+	 * Split the folio now. In the case of device
+	 * private pages, this path is executed when
+	 * the pmd is split and since freeze is not true
+	 * it is likely the folio will be deferred_split.
+	 *
+	 * With device private pages, deferred splits of
+	 * folios should be handled here to prevent partial
+	 * unmaps from causing issues later on in migration
+	 * and fault handling flows.
+	 */
+	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
+	ret = __split_unmapped_folio(folio, 0, &folio->page, NULL, NULL, true);
+	VM_WARN_ON(ret);
+	for (new_folio = folio_next(folio); new_folio != end_folio;
+					new_folio = folio_next(new_folio)) {
+		folio_ref_unfreeze(new_folio, 1 + folio_expected_ref_count(
+								new_folio));
+	}
+	folio_ref_unfreeze(folio, 1 + folio_expected_ref_count(folio));
+	return ret;
+}
+
 static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long haddr, bool freeze)
 {
@@ -2842,16 +2934,19 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	struct page *page;
 	pgtable_t pgtable;
 	pmd_t old_pmd, _pmd;
-	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
-	bool anon_exclusive = false, dirty = false;
+	bool young, write, soft_dirty, uffd_wp = false;
+	bool anon_exclusive = false, dirty = false, present = false;
 	unsigned long addr;
 	pte_t *pte;
 	int i;
+	swp_entry_t swp_entry;
 
 	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
-	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
+
+	VM_WARN_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd)
+			&& !(is_pmd_device_private_entry(*pmd)));
 
 	count_vm_event(THP_SPLIT_PMD);
 
@@ -2899,18 +2994,60 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		return __split_huge_zero_page_pmd(vma, haddr, pmd);
 	}
 
-	pmd_migration = is_pmd_migration_entry(*pmd);
-	if (unlikely(pmd_migration)) {
-		swp_entry_t entry;
 
+	present = pmd_present(*pmd);
+	if (unlikely(!present)) {
+		swp_entry = pmd_to_swp_entry(*pmd);
 		old_pmd = *pmd;
-		entry = pmd_to_swp_entry(old_pmd);
-		page = pfn_swap_entry_to_page(entry);
-		write = is_writable_migration_entry(entry);
-		if (PageAnon(page))
-			anon_exclusive = is_readable_exclusive_migration_entry(entry);
-		young = is_migration_entry_young(entry);
-		dirty = is_migration_entry_dirty(entry);
+
+		folio = pfn_swap_entry_folio(swp_entry);
+		VM_WARN_ON(!is_migration_entry(swp_entry) &&
+				!is_device_private_entry(swp_entry));
+		page = pfn_swap_entry_to_page(swp_entry);
+
+		if (is_pmd_migration_entry(old_pmd)) {
+			write = is_writable_migration_entry(swp_entry);
+			if (PageAnon(page))
+				anon_exclusive =
+					is_readable_exclusive_migration_entry(
+								swp_entry);
+			young = is_migration_entry_young(swp_entry);
+			dirty = is_migration_entry_dirty(swp_entry);
+		} else if (is_pmd_device_private_entry(old_pmd)) {
+			write = is_writable_device_private_entry(swp_entry);
+			anon_exclusive = PageAnonExclusive(page);
+			if (freeze && anon_exclusive &&
+			    folio_try_share_anon_rmap_pmd(folio, page))
+				freeze = false;
+			if (!freeze) {
+				rmap_t rmap_flags = RMAP_NONE;
+				unsigned long addr = haddr;
+				struct folio *new_folio;
+				struct folio *end_folio = folio_next(folio);
+
+				if (anon_exclusive)
+					rmap_flags |= RMAP_EXCLUSIVE;
+
+				folio_lock(folio);
+				folio_get(folio);
+
+				split_device_private_folio(folio);
+
+				for (new_folio = folio_next(folio);
+					new_folio != end_folio;
+					new_folio = folio_next(new_folio)) {
+					addr += PAGE_SIZE;
+					folio_unlock(new_folio);
+					folio_add_anon_rmap_ptes(new_folio,
+						&new_folio->page, 1,
+						vma, addr, rmap_flags);
+				}
+				folio_unlock(folio);
+				folio_add_anon_rmap_ptes(folio, &folio->page,
+						1, vma, haddr, rmap_flags);
+			}
+		}
+
 		soft_dirty = pmd_swp_soft_dirty(old_pmd);
 		uffd_wp = pmd_swp_uffd_wp(old_pmd);
 	} else {
@@ -2996,30 +3133,49 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	 * Note that NUMA hinting access restrictions are not transferred to
 	 * avoid any possibility of altering permissions across VMAs.
 	 */
-	if (freeze || pmd_migration) {
+	if (freeze || !present) {
 		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
 			pte_t entry;
-			swp_entry_t swp_entry;
-
-			if (write)
-				swp_entry = make_writable_migration_entry(
-							page_to_pfn(page + i));
-			else if (anon_exclusive)
-				swp_entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page + i));
-			else
-				swp_entry = make_readable_migration_entry(
-							page_to_pfn(page + i));
-			if (young)
-				swp_entry = make_migration_entry_young(swp_entry);
-			if (dirty)
-				swp_entry = make_migration_entry_dirty(swp_entry);
-			entry = swp_entry_to_pte(swp_entry);
-			if (soft_dirty)
-				entry = pte_swp_mksoft_dirty(entry);
-			if (uffd_wp)
-				entry = pte_swp_mkuffd_wp(entry);
-
+			if (freeze || is_migration_entry(swp_entry)) {
+				if (write)
+					swp_entry = make_writable_migration_entry(
+								page_to_pfn(page + i));
+				else if (anon_exclusive)
+					swp_entry = make_readable_exclusive_migration_entry(
+								page_to_pfn(page + i));
+				else
+					swp_entry = make_readable_migration_entry(
+								page_to_pfn(page + i));
+				if (young)
+					swp_entry = make_migration_entry_young(swp_entry);
+				if (dirty)
+					swp_entry = make_migration_entry_dirty(swp_entry);
+				entry = swp_entry_to_pte(swp_entry);
+				if (soft_dirty)
+					entry = pte_swp_mksoft_dirty(entry);
+				if (uffd_wp)
+					entry = pte_swp_mkuffd_wp(entry);
+			} else {
+				/*
+				 * anon_exclusive was already propagated to the relevant
+				 * pages corresponding to the pte entries when freeze
+				 * is false.
+				 */
+				if (write)
+					swp_entry = make_writable_device_private_entry(
+								page_to_pfn(page + i));
+				else
+					swp_entry = make_readable_device_private_entry(
+								page_to_pfn(page + i));
+				/*
+				 * Young and dirty bits are not progated via swp_entry
+				 */
+				entry = swp_entry_to_pte(swp_entry);
+				if (soft_dirty)
+					entry = pte_swp_mksoft_dirty(entry);
+				if (uffd_wp)
+					entry = pte_swp_mkuffd_wp(entry);
+			}
 			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
 			set_pte_at(mm, addr, pte + i, entry);
 		}
@@ -3046,7 +3202,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 	}
 	pte_unmap(pte);
 
-	if (!pmd_migration)
+	if (present)
 		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
@@ -3058,8 +3214,10 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
 			   pmd_t *pmd, bool freeze)
 {
+
 	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
-	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd))
+	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd) ||
+			(is_pmd_device_private_entry(*pmd)))
 		__split_huge_pmd_locked(vma, pmd, address, freeze);
 }
 
@@ -3238,6 +3396,9 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
 	VM_BUG_ON_FOLIO(folio_test_lru(new_folio), folio);
 	lockdep_assert_held(&lruvec->lru_lock);
 
+	if (folio_is_device_private(folio))
+		return;
+
 	if (list) {
 		/* page reclaim is reclaiming a huge page */
 		VM_WARN_ON(folio_test_lru(folio));
@@ -3252,6 +3413,7 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
 			list_add_tail(&new_folio->lru, &folio->lru);
 		folio_set_lru(new_folio);
 	}
+
 }
 
 /* Racy check whether the huge page can be split */
@@ -3727,7 +3889,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
-	if (folio_ref_freeze(folio, 1 + extra_pins)) {
+	if (folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio))) {
 		struct address_space *swap_cache = NULL;
 		struct lruvec *lruvec;
 		int expected_refs;
@@ -4603,7 +4765,10 @@ int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		return 0;
 
 	flush_cache_range(vma, address, address + HPAGE_PMD_SIZE);
-	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
+	if (unlikely(is_pmd_device_private_entry(*pvmw->pmd)))
+		pmdval = pmdp_huge_clear_flush(vma, address, pvmw->pmd);
+	else
+		pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
 	/* See folio_try_share_anon_rmap_pmd(): invalidate PMD first. */
 	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
@@ -4653,6 +4818,17 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	entry = pmd_to_swp_entry(*pvmw->pmd);
 	folio_get(folio);
 	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
+
+	if (folio_is_device_private(folio)) {
+		if (pmd_write(pmde))
+			entry = make_writable_device_private_entry(
+							page_to_pfn(new));
+		else
+			entry = make_readable_device_private_entry(
+							page_to_pfn(new));
+		pmde = swp_entry_to_pmd(entry);
+	}
+
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_writable_migration_entry(entry))
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index e981a1a292d2..246e6c211f34 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -250,12 +250,11 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
 			if (!pmd_present(pmde)) {
-				swp_entry_t entry;
+				swp_entry_t entry = pmd_to_swp_entry(pmde);
 
 				if (!thp_migration_supported() ||
 				    !(pvmw->flags & PVMW_MIGRATION))
 					return not_found(pvmw);
-				entry = pmd_to_swp_entry(pmde);
 				if (!is_migration_entry(entry) ||
 				    !check_pmd(swp_offset_pfn(entry), pvmw))
 					return not_found(pvmw);
@@ -277,6 +276,16 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			 * cannot return prematurely, while zap_huge_pmd() has
 			 * cleared *pmd but not decremented compound_mapcount().
 			 */
+			swp_entry_t entry;
+
+			entry = pmd_to_swp_entry(pmde);
+
+			if (is_device_private_entry(entry) &&
+				(pvmw->flags & PVMW_THP_DEVICE_PRIVATE)) {
+				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
+				return true;
+			}
+
 			if ((pvmw->flags & PVMW_SYNC) &&
 			    thp_vma_suitable_order(vma, pvmw->address,
 						   PMD_ORDER) &&
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 567e2d084071..604e8206a2ec 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -292,6 +292,12 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 		*pmdvalp = pmdval;
 	if (unlikely(pmd_none(pmdval) || is_pmd_migration_entry(pmdval)))
 		goto nomap;
+	if (is_swap_pmd(pmdval)) {
+		swp_entry_t entry = pmd_to_swp_entry(pmdval);
+
+		if (is_device_private_entry(entry))
+			goto nomap;
+	}
 	if (unlikely(pmd_trans_huge(pmdval)))
 		goto nomap;
 	if (unlikely(pmd_bad(pmdval))) {
diff --git a/mm/rmap.c b/mm/rmap.c
index f93ce27132ab..5c5c1c777ce3 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2281,7 +2281,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		     unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address,
+				PVMW_THP_DEVICE_PRIVATE);
 	bool anon_exclusive, writable, ret = true;
 	pte_t pteval;
 	struct page *subpage;
@@ -2326,6 +2327,8 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	while (page_vma_mapped_walk(&pvmw)) {
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
+			unsigned long pfn;
+
 			if (flags & TTU_SPLIT_HUGE_PMD) {
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
@@ -2334,8 +2337,21 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				break;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-			subpage = folio_page(folio,
-				pmd_pfn(*pvmw.pmd) - folio_pfn(folio));
+			/*
+			 * Zone device private folios do not work well with
+			 * pmd_pfn() on some architectures due to pte
+			 * inversion.
+			 */
+			if (is_pmd_device_private_entry(*pvmw.pmd)) {
+				swp_entry_t entry = pmd_to_swp_entry(*pvmw.pmd);
+
+				pfn = swp_offset_pfn(entry);
+			} else {
+				pfn = pmd_pfn(*pvmw.pmd);
+			}
+
+			subpage = folio_page(folio, pfn - folio_pfn(folio));
+
 			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
 					!folio_test_pmd_mappable(folio), folio);
 
-- 
2.50.1



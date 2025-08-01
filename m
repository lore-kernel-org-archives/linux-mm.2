Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7108C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 00:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1978E0003; Thu, 31 Jul 2025 20:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663068E0001; Thu, 31 Jul 2025 20:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5020F8E0003; Thu, 31 Jul 2025 20:49:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3357F8E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:49:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA20ABDE94
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:49:25 +0000 (UTC)
X-FDA: 83726355090.26.500679D
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1347240002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:49:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r5dX8+pk;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.43 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754009363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qF3snHVnPxUBWevCkXoQos08/KZIw98YEtfJB87s9/U=;
	b=zURpl/eMccud/TcFm0sR4JW8PqwEj/nAB6yLNndS5LT/ldVG3Slg2cxRvYDnAea9K6sDkZ
	F/YoNYzrqqsSlN/7zhHRGfQQcLKtDK7ga3a/MVvtgpUdnzNAW/hmO9niWYFuUhK9RAHHTN
	aknBbNxfU+y4EoNFrS1in3nmzKLEo+0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754009363; a=rsa-sha256;
	cv=pass;
	b=SJs/wlnYSzxCJpHgkGJG+JZmBk5XfLo53167tqjBApWzLnjjlnPtEd1NrTNxDRqoojTnDn
	Nvs/aUXirxrlR4ysCzsrwKQgV+qrOuubaLYF2F+b9n+wP/B7ZKeGOAAjMdwErTQNNuoCKq
	9fnkObstMCXbzdTTeOIVJo+wQa/drzk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=r5dX8+pk;
	spf=pass (imf07.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.243.43 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eTiR5KNfEu2jt7F1ibg3/hDp6rdzdeEDQmU2vfDhTH3D4sUiiCOjLjZ7D9uZTl9tQORYI5SiV9PXXuoiYyzEnTJLv4YBTwR+ZKHK7+fm445uotRNfngaLh3xgWLt0Zq7x0Q7dGTtCCKepCTQDyRWIJ5uGmgwlF8LTa3hC1VuobdiVn7/tMer8s+JVe1lxgusnkNDDTW1SsoJh5xV0Lcx2GAfYr3a97hUjLxJaQNOWQbFAkV+jRgbuYK2Erj7p/S9coigYWTzRXe2cCvNg8YSxlL4DtthxqPh3hq9e72dpocEV2+hfQG/I9HdOWLrBCkYTzxxyMRPOnE10qmPSShiGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qF3snHVnPxUBWevCkXoQos08/KZIw98YEtfJB87s9/U=;
 b=NVNEvlOJu5ccy8u/V9zattLmDEY8zpoxtXEL+4UTf4OzzI/BRNa297Nmz5d88hc1Q2fHdYgAYSuRkm0K8BecW3YkviOvzqSox0Ican0zA/lWraA0MkxhlKJhe95AumDGKiENOoISyVuILOVmYLs1GwSaDcgJ4M07rNTeduamEV+wWXXRQUrBGO3Qmzd/GqGzZ1UlWcOsEGFWjt+p3Ka/uT6/chlCIOrpMpcwgyrpNh1a3N7DA8ZPhSK+RcEWAYrVs344tWs2S3qUkEqt9xl/uUT+eGZrwxADT6AUUupBWS8hyc1K9KgEWjw1Bt8Lw/25i2P4E6giHjneQLVfiX2kYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qF3snHVnPxUBWevCkXoQos08/KZIw98YEtfJB87s9/U=;
 b=r5dX8+pkX/bnmhRnorTOvqhqqeJSWNtMVN4PBDhMLcaZyg/EsoIPDZaNpg0ILZi7gdL1YE4Hw8Cud+kUj7q1WrzwWbPntuAup9kTYPqHtahixtg+DAcW5zqA90narYDYPXzebsSxk/qHxmQ6V553+tMeegT/UlhEh5W3qB9BnyQK0XpLNIjx7azwdBCaGlGF8c36mK7+3Yc8LU7CZmlUlCj+9kStMgGnW+oHViehQptPeKZWwNr6Cc6zptDVR4adM/j0eY0ygOAG8DztnOJvcDm6v2dEVwwSMD0xJZN0gwwvzscO2Z30ZZlTNDY85RxsRjueQueE3MApo0HC1vjiUA==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by PH7PR12MB7187.namprd12.prod.outlook.com (2603:10b6:510:203::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Fri, 1 Aug
 2025 00:49:18 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%5]) with mapi id 15.20.8989.011; Fri, 1 Aug 2025
 00:49:18 +0000
Message-ID: <14aeaecc-c394-41bf-ae30-24537eb299d9@nvidia.com>
Date: Fri, 1 Aug 2025 10:49:10 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 02/11] mm/thp: zone_device awareness in THP handling code
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Karol Herbst <kherbst@redhat.com>,
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Shuah Khan <shuah@kernel.org>, Barry Song <baohua@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Matthew Wilcox <willy@infradead.org>,
 Peter Xu <peterx@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
 Jane Chu <jane.chu@oracle.com>, Alistair Popple <apopple@nvidia.com>,
 Donet Tom <donettom@linux.ibm.com>, Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>,
 Ralph Campbell <rcampbell@nvidia.com>
References: <20250730092139.3890844-1-balbirs@nvidia.com>
 <20250730092139.3890844-3-balbirs@nvidia.com>
 <c2f2fe52-a358-489e-a1f2-5c0a6f5b4db5@redhat.com>
 <22D1AD52-F7DA-4184-85A7-0F14D2413591@nvidia.com>
 <F60614E1-28D1-466B-A434-7FF1061B0778@nvidia.com>
 <9f836828-4f53-41a0-b5f7-bbcd2084086e@redhat.com>
 <884b9246-de7c-4536-821f-1bf35efe31c8@redhat.com>
 <6291D401-1A45-4203-B552-79FE26E151E4@nvidia.com>
 <b62234fc-051f-4b2a-b7da-0c0959fb269b@redhat.com>
 <8E2CE1DF-4C37-4690-B968-AEA180FF44A1@nvidia.com>
 <2308291f-3afc-44b4-bfc9-c6cf0cdd6295@redhat.com>
 <9FBDBFB9-8B27-459C-8047-055F90607D60@nvidia.com>
 <11ee9c5e-3e74-4858-bf8d-94daf1530314@redhat.com>
 <b5fa0989-a64a-4c91-ac34-6fb29ee6d132@redhat.com>
 <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <EC99D49E-86FF-4A50-A1AA-FC43A7D3716C@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|PH7PR12MB7187:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e20accd-6018-40d8-d17b-08ddd0953ede
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b3lXRktiTU1SVms1Szd0TDlKUnNHZWNrRTZCUVV0RklSU1pMc2tSUUVoZUpG?=
 =?utf-8?B?M0E3M0lyeERnb1RGOEJHOWpyS1NWdms4YXIzU2E4cldBdjNINjJGd3lxZkZ3?=
 =?utf-8?B?YWxGcFlXT1hJSWtGY2g0WUl5K0tsMXZjelVLaDJucGc4UHh2T0FDZkZFamFm?=
 =?utf-8?B?WmhEYVRvZGkvTVJIbXFLUlpjNEJ6eDRjVFpqMWZqMkljdFJoR25TK1pQbGdJ?=
 =?utf-8?B?bU5BUW9OK0hCZm00QWdOdmF1MWhBT1VQeUxMUG0zQzIxSzNtR0FpOElFTmlW?=
 =?utf-8?B?N2lxNlY2NGVKUlI4K09seGtCSS9TRURrUVFIay9rMDVocG4vUytScCtOblhB?=
 =?utf-8?B?VG5DU2ZPS2NWdmVETnZHWHF3SExYTURzWStHcVIyZ2hqUFRjMmhPZmdjZzBM?=
 =?utf-8?B?U0pZUFZQQUVSUWc3T2Q4QzNFb0pPSy9wSzJDbFhUZXRVZ3NYQURxRE1HUGJZ?=
 =?utf-8?B?RHNwcmNLcEJ6MmUvbS9KbFA5STB5VUEvRCtzSCtENE5EazZjZFYzY0xRTUl4?=
 =?utf-8?B?b1luN3A2SkY2dkNpRktyeXlDN1dDZGoyNHcvQTZQejBzcXI4YnJZZXJaSlJF?=
 =?utf-8?B?SjBNSlg3SzgwQ0Y0VFUrdGxlclN5OFNkM0tXRzJEZTEydVhUVkRCbmM5bkVi?=
 =?utf-8?B?TVYwblJMd0o1NWtFeDZaclNlYTBKZEMveHRJWHIvaFY2SHAxQkZJRUIyUm80?=
 =?utf-8?B?NVdFK0YxdVN5MXJuK0VaZ2VlRldGUkJjVUFtd2xGZ1B5V0l4TXlHOGJzRFZk?=
 =?utf-8?B?S29jSDdjdmhlM3BaRDNPUlI4UTBrSm16cVBzb2NrRmlaUkorK0FpRnFRR2kr?=
 =?utf-8?B?akRtdTNvcUZSeW9WMVdibTJxeDV1WnpFaDVNeEVGblI4dHFneHUzeXMxQk5i?=
 =?utf-8?B?akxGUmxYMmI4a0RYUHU2OUgzMlpQK0QrY1cxQkYvaTNmTC9DSEpTL2dYR2Zh?=
 =?utf-8?B?WFNNR0NVNTZxSStqbm5OSWMzTTZxWkZPeWlrWGhQSjdlbWVYeHFnZ20wendQ?=
 =?utf-8?B?b1RxUENjdW1pdXV4bEVTQmJoSVdLSXdtVmJUZTQvcE5JS3ZSdVRSUldBWnNO?=
 =?utf-8?B?RUtMOE91NTJLMGg1Rm54VEpoUjg0cE5HQUE2WXRzT2IySTBxM0R5MmZlUHI0?=
 =?utf-8?B?STZ0a2Z5VU1JSlQ2VVpuZzJQYk0vVG43Mm1icmh2WCt0czg3R2pwNk5xTVVW?=
 =?utf-8?B?S3dnaVF5VDNINHQvc2N2UzJuOGpaSFFPWWlBWExWZll5NEw1TDNETDBBYWI2?=
 =?utf-8?B?akgvVmVGeThEWWw3UkZoeFRLTTh5YUhwcjc1UmFIM002a1RHUHd6cEhXVE5x?=
 =?utf-8?B?VGVjZk1hRktERUtKMllRQURRZGR1ckF6eXQzdTUvZnl0RzB3Wnp0V1ZEVGY4?=
 =?utf-8?B?WXJuWHhNMENqcVlOYjF3N2dPZE9uYlNOVWxsNjJHRWYrN1p0NmJiU05lWHZj?=
 =?utf-8?B?QkhDMHJzOUhQYmlrQ1pPOG1iN2kvMXBXMldtUWxiU2VqZVJ1MDVSRzZTbjNp?=
 =?utf-8?B?Q1lKV0JhZ21KYjVoVXFNckpzTEhJZ3JlNjZXYUhQb0lhZlQ0clhrakt5dnNx?=
 =?utf-8?B?a2xjOWY5K1J1QUNzZDN2d2JYZzIwN1oxdEc0SkdUeUJYK2E4Y1QwWEdxRk5T?=
 =?utf-8?B?UGZjbUJVK0FVYUZSUjEyS1BDU1dibEdWQlBSQm1UejFoY0ZUaU1TMFRNZTNR?=
 =?utf-8?B?algwQVBIUlBIUCs1aC9rcGxUREc3aHpKSXNvZ3hCQytSK05vSFRrUnhpMXho?=
 =?utf-8?B?NXR4NDlZNjdVak5FMU0yN2pPRlJRcXhuQnpFeHR6MDlreTF2Y1lPQzlxUkpm?=
 =?utf-8?B?YTNrRHNNSkFEYXpzVDdleHV2ZzEzLzBoL1NNc1hFT1U3RE11TjFYWDJUOXpi?=
 =?utf-8?B?TEpyMis0d29HTWg5K1JmaXEwRSswM3lQeUdLa2JuUWFaZmVraW1MYS9ZMGdK?=
 =?utf-8?Q?hzIP9NXH7bI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eHF6WWVLMkRyYW43NFBPbzBpVE1ZR0QwdEJoNXBML0Z0Y09vU2xvV3g4Mjh5?=
 =?utf-8?B?N1lyN0RIa2Ivb3RJTEtmekkwd3ZzeGYrY3c5aWNBWXhXM1BXa2pvNldibzMw?=
 =?utf-8?B?WnA4N3hrQWFrcmdieHpWSHUvVU0xN3JkdU9ackw2SHluTDZwZkVpeGM2dFVv?=
 =?utf-8?B?cmE3YzBYd3pKeG16SXdxM3hEZ1RYY29vUlJGaGl2QWlNbUsrNTBsUUxvdS9O?=
 =?utf-8?B?WFl1UGlidnpOc2VGdDZpUGpUUzlGS0JzUkZaRlZSMExSMGF3VkJMaWp3M3dU?=
 =?utf-8?B?b09MZWFVa1RYU3pCd3VZUERRM0dPbEVxeU83S0syUGl6ZllOYXFmc3hBMGpy?=
 =?utf-8?B?WFp0b0l4YThEMXZza0ZBTllQbThuSkViV1VaUkdUUFFXKzluSkNwa1Vlbi9X?=
 =?utf-8?B?dmdWc1RBeXk3aHBvanFCOWZqOVpBUkdTU0NYWHJrdGJRSjd3VE1Kbk9jVi9h?=
 =?utf-8?B?NmdJS2dxYzJLamhtdHpWZ2dWdkt5RkxyZTFtRFBGSkpSbzhDS3p4MUwrTklH?=
 =?utf-8?B?dWNKK0NDTzFkeEV6Ym9jakFlV0VzaE5yZWdKSjBzaVFwSGV0L3hmQXVUQURL?=
 =?utf-8?B?bjcrS3c0SzRHckg2dU1FS21WODEvbGdRQVFwMVljOFdqK1VmY0NTZUJsbHlU?=
 =?utf-8?B?ZXkwb2FzZ3Z1VGtUdTRHUXZxWDVlc1MrTC9uRHRDem9tNXg0RmxNSXRYbzRt?=
 =?utf-8?B?eG9ienNHdjZzYld3cy9rOTF3dGFhSDI0dXVsWHBFNDFZeUc3Y1VrcEg0RXJM?=
 =?utf-8?B?MlNGaVRXTnRaOCtSVEI2RXFsSVg1OXM5QXFNWm9LZGZNQWxMK0JnRWoyZHI3?=
 =?utf-8?B?eWd0VWU0L0FsYStNdzI1VEtUWlRaVDlJdy8zTG9uQWx3amhKUXBtaVVwQUVR?=
 =?utf-8?B?WGtaZzJadGlMSE9YenYzSUl6eEltcDk3ZWU2V2tJZWwydHpicGs4NnV5Yy93?=
 =?utf-8?B?ZjVJYjRsZEpxL0lJSlUzWWFQZHpsRktKN1hreHlSZEZ0amk5YzA2UUUxVll6?=
 =?utf-8?B?bTlaODM5NWJrUmU5VmNDZkJlTERTZStpbUs0Zk9OQUZMRmRqaHlmK2oybm1O?=
 =?utf-8?B?bjQwS2F4b3U1UC8wZEoyLy9QRHBqMHJYbkUwNUhvcXZ3L2laSFNZM0h3eFM0?=
 =?utf-8?B?QUdPdXd2c0pZclNTL1F6MkgxYUxYeEhsNnFYSE93ek5yaGR2Q1FscmhtVC9l?=
 =?utf-8?B?VEVRK3AreVhLcmNIekJWTVFZYzVkTGpqMzllc1gxNlhtMGZyb1ZKUkNhVlNI?=
 =?utf-8?B?WFdUZGtPVU1jTk5ZRU85d055TlRGbmpXTGgra2FoQlRqSVZ5S01iRlRvK051?=
 =?utf-8?B?VC9vZFJFcGoraGhmT2hRbnpkYkRPdDNoRURLNmlkbzJyMWlVZUxORldPajc1?=
 =?utf-8?B?eXk5OHpDQlh1QTRqWjJvektMeWJwOFJIQ1MwUFpvUnU1RHc0NDBuTWJZajQ5?=
 =?utf-8?B?U0h5TEpLN2ZkUWJDTlpUMGwySUtHL0pxOEgzWEgwakhmck9NWUFrUGFWVEdT?=
 =?utf-8?B?MXQ3WWE0UjVndWVydDk4NS9XeEJWVUR0ckVMSDZQSmEzVllzSVZYQXQ0Mks2?=
 =?utf-8?B?ZW9HcGtlY0tIM3VLYjY3Q0gzbVhUeUVBT3dIejVMRTJudlJBZEJXMVRaUFRI?=
 =?utf-8?B?bFJQOEEvYlp6OUJiMWJOaytwZzJEM2UrN3pXUitpeHBaWjNNMnZvUnNQZWk1?=
 =?utf-8?B?cERlQ1lPNEhtOHdrdWpZekQycXFQNzNCblR2eUY0Y1JIaG9sNWxPOVVVWUQ1?=
 =?utf-8?B?VEVzOElwcC91UjJzc2dVS09xRWgxVVh0bjdWZUVnbG9XODcrckFET3BUYldx?=
 =?utf-8?B?WFRyenVQWlJGZ3c1aEJJb0w1ejNzUDlHV045NVc3UnRVYS9xRmhxbzJpTXVu?=
 =?utf-8?B?MndlVS9rWU5JZmhidnFMVVdOejNFeW45UGpXdHBwUDdtcHBaa2V2QWo5Q2ZQ?=
 =?utf-8?B?NWtuR3VOS1BoSExLRlBrRFFMN0Z0YmtIb3dCQzREMU5HemFpVS82dG1pVUlj?=
 =?utf-8?B?d005QTh4MWE3WXZ1M1RveC9uaG1XcDAxQVBINjdTR3hvR3FUODY5ZmhBUVMy?=
 =?utf-8?B?ejY2dFhMQ1ZRZlNRaEp1ckpPYmZKWG1oU0F6WmM3OFNUVU5yTjFKZHVFZXFY?=
 =?utf-8?Q?OFOcQarGrWyEdoP+PZogi3fnX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e20accd-6018-40d8-d17b-08ddd0953ede
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2025 00:49:18.3223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xfhpo9H5LFj+Fqzjst5AoC9I6ltzV7x58UZWT5bI3IQFkqRWqGm8DyCJ4J+f0Z3sxrTeQNY27PZr66/P1HY/UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7187
X-Rspamd-Queue-Id: 1347240002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: qzz1ahpecprxm47io19hiqq5ki7iyyyg
X-HE-Tag: 1754009362-71877
X-HE-Meta: U2FsdGVkX18gN3SNP0B2hKKrUGfTvgjUXxa9Pv+SBVdkAXwicou+LMPPWZM7AuDaE8IRoz0ejVQgwHMDa/jNIpqph4oGa+AgwHxaBFHzBiGii6m0KABwtelwdIJLRaxj4YewKuQgwtGwD2OInO7HKRIPgLFZOS8Kwt6JKaTJ4oiUCoVx13TDUEjbCd1BvGwoc0z2OhWlxk6VhG98H+n+84TwmE2+eB9pBdQmjn3Dxu1azVLMLqzy3Ots3gIjnyM3ClfiScuCoiMCEVQsw1ubHLRAXQS+zRrt+7JgjNJ+N64k/VQfzLt6XIQ+fFboFweyfAgVSsPHtnR0XZJYLV0NXf1qyBoZJdf3YDoAInMVfuId2esCS30G/yUe65O/0B7o2N/IwW6mhUWIyEh+vNLgNBt62Tiury8pfZlybbhymdFCRVZhRzbJJDy3m7+isG2GhH8C2JuNcmE2xWLDZiFd21P5asZTZaGDCjmsFRssJjWJSpoA+dmZXdBUQss17v1i24JKjA422rQg+U1WLAbbIxBptff+9ojzNQpxqmrdpbngruCk2TckgQ/QXFt3LMKNhmH9Ntnsf/2R2D5XH0scgYhSQ8aSuW2xaxgOdvCxiEaz9AINwhZmWDzxA08GliBKNZ/QBW4sXT7zyyY0K5azk2MljHlfOuCeBph0fYMWPCrbdnLJtXlLF5Wy2ntXhmG6MBHEN1YlOK2/+Xbn6El+a2NkLJSacdJJonCFowfTzCtsv+5NAXdElmXLJbSdRUwy3BbL4+dmXMeIgX5UYi+bWqZ3abxCk72oHhkUgwxCXmqzzwLcYm40Zd6FrMr5zKHhQe7NIKCgo60gEyldqn9XxIDg1NA22nKHl5mTHozHGHcyQD4IHfGx7qw4Y84YcBV4FtqJucjiBJ4oPAM4ID4UIN3Waa3iOLtIO2ssULKFZoRjdjhIJ9nmWqPkL4iS14kdpdCW/y24EWECpl1rGac
 kl5R36o0
 TXmwwT4nqdTN4ggp3eYvvfsmBxnwuthelhIAeNVdytBA4FVp7v6QvN2OqARy47am3l47O3XFoivsnkvD711B2FDSR8YAwmVi03LVZ8CqVnmwUlAjj3cEW2dVNuDgYV94kXsj92LjMxG/N9A9j5xJJnAM21JpEFYgaFBLiXlwSSBhDl5A6VSJW9O0qeVOGtxy+kYw07FAvboheDPP3rCA9FQHvaSz+r3YJ1bvZFTYXYJM2UWiTFklZu0/c8iVX1cXjRZh74cdNSsXoMXqCi9v8nvsXK8hCHPWH5HYXAnkdFNhfnFkQgmlTJQXh8TC2iVFlcxFARdBvz7MaA2tCsyQaXyOBnEzjN+XKSEeFAc7R40YW9H9UWjEF5s8+OU0371qByA+2/z5X37TUDQHZcCKTgN47T9QeU4yegQk6UMxq+Rr9i/Rmv/of5ZH+EqHki0QPDBJoBr1fJje9jQjBaE6Oa5Z8ncA3FJPDHf+himoeHeuz5q52GjG7W2Bj/UOd6dn0edsZLwwk4MigdJSlHHe2+hs2+SMP032cGKRYE0o/nDh5qB1p9UttJeemTG9Z4XFjMl3qmZq/P4NIs7BComtdqjmlcpjZ7giZ8zhwG7YTepYHYZjdXQCpguQNT4j7pNjpzAPZq19sh/FdFviFW1J+VE0N/uDD7BcU4o7gzbcfx5o78GEULdLSTRYZU0ZG9wJn9UTqZ41M8udMAZ3mzi39kNEb/DlVcnuv+7tQc2m/VQl73xrXH48MKvqUVCVUQmXdpcGurse4cOnG4RcMmBP/vOdRTKJXHZv2QlYpUZcgHz2ya1HRyuPEDhFt5EPUITM3I4NjR+myQ3Zq8Fe3AVxw5/HxEzyEnNomRp5oDk6hDaTqPKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 21:26, Zi Yan wrote:
> On 31 Jul 2025, at 3:15, David Hildenbrand wrote:
> 
>> On 30.07.25 18:29, Mika Penttilä wrote:
>>>
>>> On 7/30/25 18:58, Zi Yan wrote:
>>>> On 30 Jul 2025, at 11:40, Mika Penttilä wrote:
>>>>
>>>>> On 7/30/25 18:10, Zi Yan wrote:
>>>>>> On 30 Jul 2025, at 8:49, Mika Penttilä wrote:
>>>>>>
>>>>>>> On 7/30/25 15:25, Zi Yan wrote:
>>>>>>>> On 30 Jul 2025, at 8:08, Mika Penttilä wrote:
>>>>>>>>
>>>>>>>>> On 7/30/25 14:42, Mika Penttilä wrote:
>>>>>>>>>> On 7/30/25 14:30, Zi Yan wrote:
>>>>>>>>>>> On 30 Jul 2025, at 7:27, Zi Yan wrote:
>>>>>>>>>>>
>>>>>>>>>>>> On 30 Jul 2025, at 7:16, Mika Penttilä wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 7/30/25 12:21, Balbir Singh wrote:
>>>>>>>>>>>>>> Make THP handling code in the mm subsystem for THP pages aware of zone
>>>>>>>>>>>>>> device pages. Although the code is designed to be generic when it comes
>>>>>>>>>>>>>> to handling splitting of pages, the code is designed to work for THP
>>>>>>>>>>>>>> page sizes corresponding to HPAGE_PMD_NR.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Modify page_vma_mapped_walk() to return true when a zone device huge
>>>>>>>>>>>>>> entry is present, enabling try_to_migrate() and other code migration
>>>>>>>>>>>>>> paths to appropriately process the entry. page_vma_mapped_walk() will
>>>>>>>>>>>>>> return true for zone device private large folios only when
>>>>>>>>>>>>>> PVMW_THP_DEVICE_PRIVATE is passed. This is to prevent locations that are
>>>>>>>>>>>>>> not zone device private pages from having to add awareness. The key
>>>>>>>>>>>>>> callback that needs this flag is try_to_migrate_one(). The other
>>>>>>>>>>>>>> callbacks page idle, damon use it for setting young/dirty bits, which is
>>>>>>>>>>>>>> not significant when it comes to pmd level bit harvesting.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> pmd_pfn() does not work well with zone device entries, use
>>>>>>>>>>>>>> pfn_pmd_entry_to_swap() for checking and comparison as for zone device
>>>>>>>>>>>>>> entries.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Zone device private entries when split via munmap go through pmd split,
>>>>>>>>>>>>>> but need to go through a folio split, deferred split does not work if a
>>>>>>>>>>>>>> fault is encountered because fault handling involves migration entries
>>>>>>>>>>>>>> (via folio_migrate_mapping) and the folio sizes are expected to be the
>>>>>>>>>>>>>> same there. This introduces the need to split the folio while handling
>>>>>>>>>>>>>> the pmd split. Because the folio is still mapped, but calling
>>>>>>>>>>>>>> folio_split() will cause lock recursion, the __split_unmapped_folio()
>>>>>>>>>>>>>> code is used with a new helper to wrap the code
>>>>>>>>>>>>>> split_device_private_folio(), which skips the checks around
>>>>>>>>>>>>>> folio->mapping, swapcache and the need to go through unmap and remap
>>>>>>>>>>>>>> folio.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Cc: Karol Herbst <kherbst@redhat.com>
>>>>>>>>>>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>>>>>>>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>>>>>>>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>>>>>>>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>>>>>>>>>>> Cc: "Jérôme Glisse" <jglisse@redhat.com>
>>>>>>>>>>>>>> Cc: Shuah Khan <shuah@kernel.org>
>>>>>>>>>>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>>>>>>>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>>>>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>>>>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>>>>>>>>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>>>>>>>>>>> Cc: Peter Xu <peterx@redhat.com>
>>>>>>>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>>>>>>>> Cc: Jane Chu <jane.chu@oracle.com>
>>>>>>>>>>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>>>>>>>>>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>>>>>>>>>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>>>>>>>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>>>>>>>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
>>>>>>>>>>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>   include/linux/huge_mm.h |   1 +
>>>>>>>>>>>>>>   include/linux/rmap.h    |   2 +
>>>>>>>>>>>>>>   include/linux/swapops.h |  17 +++
>>>>>>>>>>>>>>   mm/huge_memory.c        | 268 +++++++++++++++++++++++++++++++++-------
>>>>>>>>>>>>>>   mm/page_vma_mapped.c    |  13 +-
>>>>>>>>>>>>>>   mm/pgtable-generic.c    |   6 +
>>>>>>>>>>>>>>   mm/rmap.c               |  22 +++-
>>>>>>>>>>>>>>   7 files changed, 278 insertions(+), 51 deletions(-)
>>>>>>>>>>>>>>
>>>>>>>>>>>> <snip>
>>>>>>>>>>>>
>>>>>>>>>>>>>> +/**
>>>>>>>>>>>>>> + * split_huge_device_private_folio - split a huge device private folio into
>>>>>>>>>>>>>> + * smaller pages (of order 0), currently used by migrate_device logic to
>>>>>>>>>>>>>> + * split folios for pages that are partially mapped
>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>> + * @folio: the folio to split
>>>>>>>>>>>>>> + *
>>>>>>>>>>>>>> + * The caller has to hold the folio_lock and a reference via folio_get
>>>>>>>>>>>>>> + */
>>>>>>>>>>>>>> +int split_device_private_folio(struct folio *folio)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +	struct folio *end_folio = folio_next(folio);
>>>>>>>>>>>>>> +	struct folio *new_folio;
>>>>>>>>>>>>>> +	int ret = 0;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +	/*
>>>>>>>>>>>>>> +	 * Split the folio now. In the case of device
>>>>>>>>>>>>>> +	 * private pages, this path is executed when
>>>>>>>>>>>>>> +	 * the pmd is split and since freeze is not true
>>>>>>>>>>>>>> +	 * it is likely the folio will be deferred_split.
>>>>>>>>>>>>>> +	 *
>>>>>>>>>>>>>> +	 * With device private pages, deferred splits of
>>>>>>>>>>>>>> +	 * folios should be handled here to prevent partial
>>>>>>>>>>>>>> +	 * unmaps from causing issues later on in migration
>>>>>>>>>>>>>> +	 * and fault handling flows.
>>>>>>>>>>>>>> +	 */
>>>>>>>>>>>>>> +	folio_ref_freeze(folio, 1 + folio_expected_ref_count(folio));
>>>>>>>>>>>>> Why can't this freeze fail? The folio is still mapped afaics, why can't there be other references in addition to the caller?
>>>>>>>>>>>> Based on my off-list conversation with Balbir, the folio is unmapped in
>>>>>>>>>>>> CPU side but mapped in the device. folio_ref_freeeze() is not aware of
>>>>>>>>>>>> device side mapping.
>>>>>>>>>>> Maybe we should make it aware of device private mapping? So that the
>>>>>>>>>>> process mirrors CPU side folio split: 1) unmap device private mapping,
>>>>>>>>>>> 2) freeze device private folio, 3) split unmapped folio, 4) unfreeze,
>>>>>>>>>>> 5) remap device private mapping.
>>>>>>>>>> Ah ok this was about device private page obviously here, nevermind..
>>>>>>>>> Still, isn't this reachable from split_huge_pmd() paths and folio is mapped to CPU page tables as a huge device page by one or more task?
>>>>>>>> The folio only has migration entries pointing to it. From CPU perspective,
>>>>>>>> it is not mapped. The unmap_folio() used by __folio_split() unmaps a to-be-split
>>>>>>>> folio by replacing existing page table entries with migration entries
>>>>>>>> and after that the folio is regarded as “unmapped”.
>>>>>>>>
>>>>>>>> The migration entry is an invalid CPU page table entry, so it is not a CPU
>>>>>>> split_device_private_folio() is called for device private entry, not migrate entry afaics.
>>>>>> Yes, but from CPU perspective, both device private entry and migration entry
>>>>>> are invalid CPU page table entries, so the device private folio is “unmapped”
>>>>>> at CPU side.
>>>>> Yes both are "swap entries" but there's difference, the device private ones contribute to mapcount and refcount.
>>>> Right. That confused me when I was talking to Balbir and looking at v1.
>>>> When a device private folio is processed in __folio_split(), Balbir needed to
>>>> add code to skip CPU mapping handling code. Basically device private folios are
>>>> CPU unmapped and device mapped.
>>>>
>>>> Here are my questions on device private folios:
>>>> 1. How is mapcount used for device private folios? Why is it needed from CPU
>>>>     perspective? Can it be stored in a device private specific data structure?
>>>
>>> Mostly like for normal folios, for instance rmap when doing migrate. I think it would make
>>> common code more messy if not done that way but sure possible.
>>> And not consuming pfns (address space) at all would have benefits.
>>>
>>>> 2. When a device private folio is mapped on device, can someone other than
>>>>     the device driver manipulate it assuming core-mm just skips device private
>>>>     folios (barring the CPU access fault handling)?
>>>>
>>>> Where I am going is that can device private folios be treated as unmapped folios
>>>> by CPU and only device driver manipulates their mappings?
>>>>
>>> Yes not present by CPU but mm has bookkeeping on them. The private page has no content
>>> someone could change while in device, it's just pfn.
>>
>> Just to clarify: a device-private entry, like a device-exclusive entry, is a *page table mapping* tracked through the rmap -- even though they are not present page table entries.
>>
>> It would be better if they would be present page table entries that are PROT_NONE, but it's tricky to mark them as being "special" device-private, device-exclusive etc. Maybe there are ways to do that in the future.
>>
>> Maybe device-private could just be PROT_NONE, because we can identify the entry type based on the folio. device-exclusive is harder ...
>>
>>
>> So consider device-private entries just like PROT_NONE present page table entries. Refcount and mapcount is adjusted accordingly by rmap functions.
> 
> Thanks for the clarification.
> 
> So folio_mapcount() for device private folios should be treated the same
> as normal folios, even if the corresponding PTEs are not accessible from CPUs.
> Then I wonder if the device private large folio split should go through
> __folio_split(), the same as normal folios: unmap, freeze, split, unfreeze,
> remap. Otherwise, how can we prevent rmap changes during the split?
> 

That is true in general, the special cases I mentioned are:

1. split during migration (where we the sizes on source/destination do not
   match) and so we need to split in the middle of migration. The entries
   there are already unmapped and hence the special handling
2. Partial unmap case, where we need to split in the context of the unmap
   due to the isses mentioned in the patch. I expanded the folio split code
   for device private can be expanded into its own helper, which does not
   need to do the xas/mapped/lru folio handling. During partial unmap the
   original folio does get replaced by new anon rmap ptes (split_huge_pmd_locked)

For (2), I spent some time examining the implications of not unmapping the
folios prior to split and in the partial unmap path, once we split the PMD
the folios diverge. I did not run into any particular race either with the
tests.

Balbir Singh


Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7892CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 15:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ECAB8E0006; Thu, 21 Aug 2025 11:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4ED8E0001; Thu, 21 Aug 2025 11:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7318E0006; Thu, 21 Aug 2025 11:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3A768E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:40:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F38F8367B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:40:24 +0000 (UTC)
X-FDA: 83801176368.14.7D9505B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id F372E40008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:40:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IWNVttqT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YYj3dErj;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755790821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9u0JsVdKYSmgLWoURpuBX81HM7SeVT22HnTN3T1habc=;
	b=zDD0fRTARjMwEWVh2YMeMAfXb1d3sjEf/vcY4oId/F+mfoIHuwc5897rUOlqaNAtG0KM8d
	zaUk2Om39X/4xzxBu+CQPPgbtJ0ZY287bF4JmVwxusFz8ZC7mUlpvih0GB4YB0H0C6fEWM
	KwKKwwl8t1S+kIEdWPplLFofEiDbPHc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IWNVttqT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YYj3dErj;
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755790821; a=rsa-sha256;
	cv=pass;
	b=wCLC4luKxUuam77jsZNPHZHbPd6bROAUphEfMf31TUC80R/ndLpDrUYpXwifvtY4W+TPr1
	Z4aia2dZS/Gsi8T0J69immkkF95noQ5gC492ArVSDQUrpM0OkyXP6pFzYBFEWCCHDt4SXG
	JSxKanBiGpeIKWFluZZK31gIr+xMSCs=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LFWepL022454;
	Thu, 21 Aug 2025 15:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=9u0JsVdKYSmgLWoURpuBX81HM7SeVT22HnTN3T1habc=; b=
	IWNVttqTq27xuflSUwzN1rsagEvibvY/ZjVd0g/fhMS4i/iE9tuPb9GgVodqoAFC
	sM//qntYzJIRPGmzjRCEg6sYZ5xgDokrk1VzDSfiDJOpWQ7bGlupjCzWd94K3J0z
	qNkfGmAO3UqOHVjJqyz9C9EFb9NlCipCMIJW1tTI3sCTxPVMCBKJFTpWl3Hb847+
	GkXDGxa2MEL+ucDKx+hf+IcBFR0o9Wi/ZY4hPND5oRO+GWbbviSnOF+PqpF8Xzl1
	etO/KK+hKKKCrdi51L/TRSF7blyTmLtlO3jh5VHZhCVKJs2Q8lpQwfe163SyXmRp
	+zfhZobsP0rlX+UtpHYiLw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsbvft-9
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 15:39:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LEaPfp025479;
	Thu, 21 Aug 2025 15:33:09 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013029.outbound.protection.outlook.com [40.93.196.29])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my42s7qa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 15:33:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j6PBih+t0JDEim4IFlD70nU0LvSKpoZUyuQe2HpTn+yCClR0M0rY+d+7zK5qKQoa+A+OXvD0T3gTBS83FoAGY/Y1JZ72AhZgKFX2tHNMfslWZjx6WEm09lWZrYT8XS2/U3HV8Km1ihD9WLKMeP7qXoaLnGL2NbFPZTQoi7jKdEN0KOyazV+y4ySawCjosW20NYnZobk693hfXYR1SpEg0m6QHFbeOSFS/CjdWBxlB2nEBtUaA8nn0Ejczm5nRqYbg5GHk5j98Lzv6OxvJkmN/+FZEoTHUjPQGZN1WViN2KNAUScEXItYJYRl2P+oOB2NZhjDNSO2kdxgQmMuOOjcOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9u0JsVdKYSmgLWoURpuBX81HM7SeVT22HnTN3T1habc=;
 b=rkidV3SDaEz3omkkk8qkk1cewwwyP+YzfpYSuzgajY9wxJK9wVIYSesHZCsGoP3m/nq3qY4bxokqgAlyKggu2hoMwvx9f1r/fa0x9Y2A/ZY891y414rWc1/N8W+kAIaBP4HmL8z6zmK891/ihkJQcOKmVBSQEW5iXsgBBG4/Bk8nTqaxLa4a9QttmhLh2ywxvHRp/k+8xkTBVUgjVEjJaFiVkyT+86h2luGHoOicus+smh/ibI4xNmAVpAm+Ef/YKCTnJCsY9vU6EkyeUVuhVbQUbCjUrPd85xA4keECNoj0Pm3OMHIjstG1VcSY49ZFLFDkwDhxC3d9WGOrrRtA6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9u0JsVdKYSmgLWoURpuBX81HM7SeVT22HnTN3T1habc=;
 b=YYj3dErj6ixfR+kSVJj6TNZIx+w+f2p96zIndCzOijwxPqTq5lwbaiOTnTt0TQOvzy4QbeISDCEiVzs4Z2/6roab5bc9g9Y4lBNEKpyowW1Wb3QNLfsgMwL5M2hwSXxqHbYOWCfQ0U4yB9VxhA1BarjZQZGfiLG6xNq8++ygrP0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6488.namprd10.prod.outlook.com (2603:10b6:303:219::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 21 Aug
 2025 15:32:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 15:32:42 +0000
Date: Thu, 21 Aug 2025 16:32:39 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
Message-ID: <5bea5efa-2efc-4c01-8aa1-a8711482153c@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <e971c7e0-70f0-4ce0-b288-4b581e8c15d3@lucifer.local>
 <38b37195-28c8-4471-bd06-951083118efd@arm.com>
 <0d9c6088-536b-4d7a-8f75-9be5f0faa86f@lucifer.local>
 <CAA1CXcCqhFoGBvFK-ox2sJw7QHaFt+-Lw09BDYsAGKg4qc8nSw@mail.gmail.com>
 <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcAXTL811VJxqyL18CUw8FNek6ibPr6pKJ_7rfGn-ZU-1A@mail.gmail.com>
X-ClientProxiedBy: MM0P280CA0098.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:9::30) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6488:EE_
X-MS-Office365-Filtering-Correlation-Id: 6273d274-494c-4032-6abd-08dde0c7f849
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NVlMYUFVTTNVMFBnSCtGZkF0Qy84N3p1N2ZlWUp1RERPM3JUcnN5bk8xUEVV?=
 =?utf-8?B?Mk1LVm5nQVNYbjlZUi8zSVRZaTlrNzFxWGVVUWNlSzV2UEE1akc2MVlja3lF?=
 =?utf-8?B?WnZLMW8wbEVqb3J4TE1vdSt2ZEZ5czlQRXRJQjlTWEh4V0VUNmplUjg1VU4x?=
 =?utf-8?B?YjlOOGdnSnV6djBPYUlyU0NqSFR5YXlPd3BpZG5LbmNXVnpyVkNwMUtNM3hJ?=
 =?utf-8?B?dFVVdnJSd2I5N2YxQ2VtMzhSSG5kV2kvWHJNWWdEanVPQVhOOUtCMFdoelVa?=
 =?utf-8?B?enFrblVpT01uaE5Ic2xWd2pTeTBHOXhpWUFTVUJHQ3BRczBzUDk0dnppOTVC?=
 =?utf-8?B?emM2SllVakV5anZGQ0pNeC9VKzJ4TThubzI3cEtFbjN0WklQZ3l3di9oQmtn?=
 =?utf-8?B?ZzlIUDFGaWxNUERpVjZ2WERDeW5WOTA4NytlM1NOREpkZkZ6dE1YTEwvbDla?=
 =?utf-8?B?ZDc5V1BaRGVZUTNkYTBuU3BDTTJHcGtDNUU3WG56ZWNMeUhzcjZkNGIzWE9G?=
 =?utf-8?B?OFNZR2xyM2RwYUhEZ1RITjdVWCt6OUFlTGJoTUNVNTkzRkZmbG5DdlpkcTR4?=
 =?utf-8?B?Qkx0amRkenNLNWFCQkF3OVdKS2tQZUtqbjY1MTdUZGhNNnN2MGR1VEtrK0N0?=
 =?utf-8?B?OWk3NU5OeGtydm5TTFhCTGdkVWUzSnZjWDhjRFRHRC9KbFNZbWtma3gyOHk1?=
 =?utf-8?B?T3VQbjBaNm9RWUpLdkxzNzN2cW40dTFYZ1p4NmtiSjlEc2FFZXU0aHJhQzZ0?=
 =?utf-8?B?Y1dLdEZTUjJnSUNpTldiczFCZTVoZ2F1QjkxZDgvbGRwdGRQdVZ5a244K1JX?=
 =?utf-8?B?QXpDOUhXaXBITXVjS3Z3Q2hzWVFxK3VVOTBlTXZtRDlublBWS2tsbjBKcjlI?=
 =?utf-8?B?aTMxZ2V2VU5IWW5OMm1mcmJsWnIxS0M5WGZrMHJETGpjNnpBUnE5NnRoVHdV?=
 =?utf-8?B?OGVBWXN0eUFzdmU1ZWgwNGRJbFErbm1lUjJycEJlY1ZhVFZGa1NWc05vSHFF?=
 =?utf-8?B?MG0zeVVLeFY2VFFkM1BKZ21qd2N6bG1RWUhwU05TYkpBV0wxYmVHbWNKOVNN?=
 =?utf-8?B?SjFPREpneWVUVEdhOHRQUGs2OXpFcWxwaDBhL1RMM1BHMVVta0Q0VkFuSUlv?=
 =?utf-8?B?aCt1YzNQOGw0V3FSRWF1bHhRMTNVVEtWR3UxejVKaUdIYW1vcXgrOThNNnVC?=
 =?utf-8?B?TE9tRXZraTJYZHZac2hSNVUyeDR2djhGVnBGNFpjdzFvYldzOWpaN0xJeEw5?=
 =?utf-8?B?aXN2MFVxM3MyTFlFL2JJazZWU1N0Rkdka0JidDlIUHRFODdTWStJVyt2Z0VB?=
 =?utf-8?B?Q1FzdVlXU3llOUhuUnNxNzdyM0MxZktXNktxbjdHb3JxaHBYQitTQWJ2MFhZ?=
 =?utf-8?B?ZkhLaTRJY0tsWFdtdTRWbG5jSFpnKzEvZWtiNEg3RkRJZStheFhiUDZnT01Q?=
 =?utf-8?B?cEpzb0NHYkZqeWNXN1VValpHQXNCbGhBcDJJSUtUVGg0US9LT0dzSElXVkp2?=
 =?utf-8?B?WklUV1pRSEpDZE5VMG1pK2k2eUtlNjQyVUFVT2lCWEVSa0FzRE9hU2M5VU5v?=
 =?utf-8?B?S0dTUjJDY3JTUVFkNmtvWk9za25IVWZwaDhXYUV1TVJoWWpOcURWaTdvdmhC?=
 =?utf-8?B?d1phODFEQXR5Y0luUkJqTjRhSDdiZzh5ODFlZnBsMjlsMU8vWVBHbEVKV0Q4?=
 =?utf-8?B?OVREaFBwbE54cGs3YXMrRHVZNEFKRjVSQWpacVYyM1BFazh0aUZ5TkJaeU1r?=
 =?utf-8?B?YjRlZElIQkEvTU85b2luOWZyUXVyRkMxeWZ2ajhvTnBlalNNazZTNDVzSjNs?=
 =?utf-8?B?Y3kwVWlDS3RaTzZYUHYzSnhvdUlOTzFjeWJPQW93Tklsa2g3OEd2cFQwS1hn?=
 =?utf-8?B?UVZKc3pZa2NzVDV5eThuR2RtOVpseVdTMXA5YUhDcC9pZ2c1aFBsL2xxZDFM?=
 =?utf-8?Q?/PRSleE8ALQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dzVjQnF4KzdYTnQ4THJQbG41TzRSaXlGL205b3hHbFV0TW5SS2xKMGc3R3ZE?=
 =?utf-8?B?WkFGajNneTBLamZraTEzbitXNm5MWXVCM0YwYUV0S011VWhsSlozTHd4QjdI?=
 =?utf-8?B?WXRkejVkTEljMVBvdlkwaVlaK29taDNkeGJFTVB4Zzh6RnZoS3k3VndPNFlo?=
 =?utf-8?B?cThLWFh2dXBDc1pBSmpwbUVoa21lVjlSL3loMEpYeXEwZWVEb2ZrMzJYTnRa?=
 =?utf-8?B?Tk9odUlYeEQvaDJhVnZNM3BCMzhxS2lSRG5LOFJXUERkaXE0V3Jrb01BaFkv?=
 =?utf-8?B?VFhXbmtPQnVtOVozRlB5VjRpaE5xNXAwUWRHeWw4SU9oNEhWbXhaNmEvTWlO?=
 =?utf-8?B?aFVMY1BqTGw2QWdXNGplcGtqbmZZbHVkb0Vabmk0S0lOd2Q1VnFlTUtISjMx?=
 =?utf-8?B?a08vbFFyV2RUc0hYTGxEU2o3R1NHT09GRldydmVzOE5tSFlaOTgrYVQ4R3hq?=
 =?utf-8?B?TjF3alRmcWcvWU1KYytobFVRTlo2UGEybVhVVUIxMXVtNFVhYVhvWDhNbzJa?=
 =?utf-8?B?S2ZPaExSVll1OFJoYk1yNmZFSU1TWmZaZEVoQlFOQ3dBZ0F4WndPeUZ6MmZT?=
 =?utf-8?B?bVM3WXZWSHV5N1kya2xmTnJXYVBrTlpJRDVjZlNNZW1sK1BDR1dET1p5Ymhi?=
 =?utf-8?B?RkVJeEFLMEVZaldkQitLMnl2dEpWblh0ck1VN1lVWEdQVGsyNEhFRmluTFdx?=
 =?utf-8?B?ZFFuQnlaa3JBcDN2bENYRjBTZnFOYkVrSjZzUDk2SW9mY3JpUEFkUzJwRUdV?=
 =?utf-8?B?ejZxQzVzYmhIbDNJN1FPUTM4SlhVMGtJKzE4bmRrTDhmWExXWC9Dd1c5WEUr?=
 =?utf-8?B?ZkZKd0RuWDByeEhZY3k2ZGtmcjNLVGtxTjlQVWpVT1BicEdHWnpicXVTeDFy?=
 =?utf-8?B?bVlxRzlPazR0TzNMcnNkK210aHI1V3lmMURSbmp5eGdUT0l3K205cEhtYzhh?=
 =?utf-8?B?WFVKQ3prOWQ4a0VRVll0ZXg2ZkgxU0FuU0lCOVpsY2dObVFuZVdublQvUWtB?=
 =?utf-8?B?L2VLbTVvYTFQYnRHUzZNVG5wMkVNdjNlem5tY1BiNzZXZ0ZsbXhPS1lmb0kr?=
 =?utf-8?B?U1YwQ0VYaDd3TGJYSkZWaVRITmxKbzlMU2RaOElXYndQZCtWODk1enN6M3JC?=
 =?utf-8?B?eEdEbHFmSE5QakhZZ3BneGJEQ253by9rSnpaNC9MdTBDaktaRmVHSDZ0Uy9P?=
 =?utf-8?B?cnRpckYzWjdrdmhSKzFiTjlHRDgxNCszTTRReVU3VDhJS3R0TzlJMUk0Yzd1?=
 =?utf-8?B?TXl6ZTJVdFNGUEFnd1hUZWE2MGpCZ1QzY2MybkdQdGVFUFBiNzhJL05BcCto?=
 =?utf-8?B?Q1FXcGUxYWJwRFBzZHN6WGErdzZNUTgrMFdGcEo4RHlMVkhteHo1bUdjSjE3?=
 =?utf-8?B?Wk90Q1poSTB6Q1hzSm1ITUxFNnpVelp2SnZuV29RSTY1UWJTbzhMTkFJWGI5?=
 =?utf-8?B?ZUNRZm1EVDhsd0R6WDNYai9qcmpralZLUWJDWURNZnVjRUNKaW8xa3VncSty?=
 =?utf-8?B?aWJEWCs0UUhJb1dSVWlCb3owcFM5RkdoZEY4KzlRbDlLbWNLR2dLMWFBOVhy?=
 =?utf-8?B?WkdLMHhlNWdPL25DWjNsckRtbXhsMVhla3VsNUx1NFM2SjdkNXNnaG8vK2RF?=
 =?utf-8?B?WklqQUlJdHp1dFlJUnB0ZDdYQUg2cHpCQ0xVc3BiOXRZdUFvS2EybHpSVTY2?=
 =?utf-8?B?S0xObk1mVVZoZXE1eHNSUHpPVDk2Z1BFUnhkbE92QTcxZnFPRTNCMHFXblZk?=
 =?utf-8?B?RHdLRUQvcnRoTlJmbUtUWEU2L1VSOExyRjBWcmVRaVNzK3ExdmNibS9yK0ZC?=
 =?utf-8?B?M3greHY4S0VET1ZYR0VYdWY2eVp0WnAvaWRMWWVEd2Z5TEZWWFU4Z2FvcXND?=
 =?utf-8?B?S2pkNHpHa3Ird29NMkFEdUN2MUd2OGJCNGE2dmxtbk91b0Mvc010KzFyQy9w?=
 =?utf-8?B?NWhjb1REWVhkSkVNM0hjQzQwMnk2NVA5cG5FTmRFVElDRmNiZ3VwRmJFMW93?=
 =?utf-8?B?Z2gySE9yWEZaYzVrRGh1N01PZlJta0Vpc2RFNkowM2NSejVpZG9xV1ZIVzg5?=
 =?utf-8?B?OVV1bXlzU2V4UlROYU11RjA5c1Yrbjhzc3Z1UWtjZWF5NFR4THgxTVl0WUU1?=
 =?utf-8?B?dUdqbVhOdWdIZ1FYeTVRTHhPS0pCK1hWU3l3M2lrNnlvSmFSRHJnRmFuVkV4?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YD8rRJinvaGx+pAR8Ah0UqDY9kfHX5mPpnWc1HKMgqnfDoNvw0kqOBELXdwN2onBp4p8zz+PCe2ZAYUFQyDoh4waNAm/xqttxcOKDPOv7rLBgBm93T0MRYX2vnmrKB+jwF2VzAhWpGw1smf0rgkGPzF/b2AigLE64KdFbPpGZzV+YzhtblbFS2h00YY3F8fU2QvN0rWq2aLbXGnNl2y6mq9NDVx+4FNq+BDlonhWQKTIRao0p1hhp3Vi3Z9pQjRCEYZaJpH+2rONBdpBqj9cZ40sRWbC4iFo6BvaJxbYhP0Y3E622hotrnWxuPNG6hTkRyUFqAvv0vqXh/jkzRsFRP2r4fkQKnMAcYsMvrrGr/NtqkpetxKvBZQ475eEojk4nwd3zSL7Vu3lxBR3SEs7tBPRZcTQQxH+NlaaaigGjSHlhBPCmDbsXfpQ/IdWuXhU4ZNYyhvpBQ68sNjerCwkINiVT/U6yoYdRXSNmR9K24A6kD3XDh2iSVft0J1kAYNjYdWdVyg6ifLsKsSm2d+ODp66kzoSlLSXATBpi0X6dSlW2L18keQ/4qV5bj4IOGY3ttucCNKyALXxB/Ded9Ab/E1hLJhnGZD2Z7LJPvCuRfo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6273d274-494c-4032-6abd-08dde0c7f849
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 15:32:42.5886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZOBSuqhvEMGTl15/rYsbd5SC8BoSobK370i7sCOhEq7rGWxVg/9pfYnMGot2/Hcp09vsuX54f1EEjh/PgKhAgNTdZyR+VSrawFL0O6HrtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6488
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508210127
X-Proofpoint-GUID: L8-XRRWIMtN4WV2PyDI04KvXPu4D0OWA
X-Proofpoint-ORIG-GUID: L8-XRRWIMtN4WV2PyDI04KvXPu4D0OWA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXxKjQO4p0z//T
 St1sjQIWpMsvzEkWrfwt/tT/85HnO1AKGBnRZizfucSvqfdEkaRnClBXgT4LeWcYdbT+cMUvqoU
 EevFwpGBd6A80ceJ6jIdyk8lSYb9Vn0sh1GVHMPpwD1cxRP4zNY8QHezu3nDKvpTs/sz64j8DWq
 2oWTMZhRny8R0uMoEkKaiN/kl/bk+xOTIyEW6WkVBAGePT8w9v8B9vEssJC4sj5yKMR50XZ37xo
 1ym0aqh9oH1jwhityzj794POLvhtF8kEdb/QR9HuTmg0JAZ1vRxQNKTZDatlZsBKWVoGRWE/J1E
 F6firvjuOoysiRtSpTkKNyzVSnIR9Mdn1I+Eu6cnW5sl7Q+1LIdPZofZA3UaGhyOb4h2LinYGlj
 uTJparJZpcLaM2dyKJyZrQb9utrPzDTG7ABa/LDUvDvl9Koh+PM=
X-Authority-Analysis: v=2.4 cv=HKOa1otv c=1 sm=1 tr=0 ts=68a73dcb b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=yULLcJmizOL5wX4KjA0A:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:12070
X-Stat-Signature: 5gqay3mthr7gswei1hz1zk3x5zdsf4ha
X-Rspam-User: 
X-Rspamd-Queue-Id: F372E40008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755790820-85653
X-HE-Meta: U2FsdGVkX1/ubJDgkQ6zAACzJIFOCfAJa7jqR2zrN0r/VMji4YCMX35ou+3CkA9YvzDsEtDV2tLZ5UyrZHFcMgoGplcWS+P8PSuQgarJZeIc2MqRgO4nWWzPRkA/do4ivx/4cqQyGlced7nnfIny9oDN1Vzulz5RwFKfC4M2K3tpI9+ZVbPznMVUGkRbq3zbYFq9+LBLjaKlXZODu74sfjLvr89lYpr+ilakbJXaEYL7upNYKKDdVQhfWKsGlSVQP2ZlDpH2ygZyYtwL2GLzVWUcPbKgmcBvY29Wdz1r0SAHvpwhQ+IeJE+2q1PecaeXDB0sEdH6yytaGR1E5rqUYxATI8KYTSoGOsOv/eySMTHCwNGQOc5klN85vNuDozJx67QiJOAbdHaxGgXdc/dALqHvkRjdRM51nXxkVU49kQ/MemAOshjpIS7Wfu+bZFTQAck+eYHinjHgdmqnHpHcvzpa7pT4NRm9O3vktXLSaMpd2w09cdYyjVt9sKRIkI55puZgygONTq64XSc54uwOCdC1h4dg0rFJHRXnhhVvRYOmqL7YB8iLeAc33iQeuKXlv4KgD4G63w9/9XGtz6vfA1GerS788e5Jcql4GTNSiF6cRbBVnuGV7lx5g05ykEfLBqrA0e7D0lLOySRmrQyuqYOrb+QEw/yBo/KE+2kFj96PNVymLKoaMwALrVDW1fw7uacl8aOEVAAop7tOIfHbsROPv/Asi4XVTJ6R/JCl8KmSFKlfO3ecs+zIz6m8mWnT5YFSx44Znb8+8kBDsn91pZe9+A6cy7STR2WxRoX0wwufTw9f3Te/ALXMyxcVDh/KCcbnV9taien0TUEweOSaeKHD7rxKLJwDhJphWreUmPi/Dn+No5Y+DhHU+jbpjEiHIzXTrVBUZFrgzpJdsIm3k0fDqWFVYnaNThvWE2J0hFPaQeYaeve43N4brRGqZNgUvqBZAExrjnWZIvx2hH4
 WB1gnK/T
 1G3iekoMeEpRayrFw28MjcfcFLgGK3SXm+G1FrR2u2WAZmHk3SJRaVjZWYfiUmijqZUyaqVENTFcyjRKSPLN1hhFbCrxhBp3SpUUXSgGVu+CB1EU9Zbk6CULtos91M7++XA4zfXY2PBHxzv2NpRsTDtChpXaYauU7eqGCHH77dnJTFyfw8dWV/bYdXQfR4C6EKyY54ZuUQtS0S9bB9bK26ZPYuZQCP4H+OUCuYa14K1iqTg+VyYGTBTQeo2ne6UfX6gPmX8VlME666fe+IeAa7ORZPgSYZPgICBrf1sUWCGr/0c1iNagF+kgXd/HGdzSXVyO6l1QNwqXH8v+7YJHBOoFhSmepcqoe54aC+GMgDsBDt6mKw9mXCRQy2qUmbWRBnTjxryX7dX5E4bWSpbZF9h3smbiotmceGZytTWBR9jWLCQPN5QvNSVfv3qfgNxfT5ybIn/rY68IYvd1cHFZ33amiDEdSPzyZ4jkf/IAE0dI2PztrumGln7Gmgj39AIUaDiYsBe6w2mK3Iwp50b4YLpZ6/0pVkTASGVX50tma818E3UvUG1Ir44vi6/9QSITeQzR2gmHdIS0o3z/Dhinw2m/h0xrk11irSmdAOLIXavEUcMgzpCmcZn+WCrTZmllD+31+lSBeCANEwwFGG594WistIHmJfx/EIJMFVMMeYukTbyqL9uSkCFfBp9F/xq/tAdCDSUlZJ1fpgGg+yU4gW2OoBEZ5r9ACu/f//Nf2HHFg72Hc+OzlDZ8wP+gA4l79ZxrKu3KtGPlg2gE1aEzw3H3OvB6l+hM0cecSFl+c/z/0yUJO3IlUHHhEiZI7U739r08AZRRhPmXx1yYJ/8eOiCRbUM04fONu+1kQJD1vj4VNrJNMkE9gG6iJENf5WHu5sL6PexNcdU2j+EiXh5E6d+gBwise9SK7+2VbNPwlFSZKeB2fj6A7bCfhSAGyjw8v6DjL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 09:27:19AM -0600, Nico Pache wrote:
> On Thu, Aug 21, 2025 at 9:25 AM Nico Pache <npache@redhat.com> wrote:
> >
> > On Thu, Aug 21, 2025 at 9:20 AM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Thu, Aug 21, 2025 at 08:43:18PM +0530, Dev Jain wrote:
> > > >
> > > > On 21/08/25 8:31 pm, Lorenzo Stoakes wrote:
> > > > > OK so I noticed in patch 13/13 (!) where you change the documentation that you
> > > > > essentially state that the whole method used to determine the ratio of PTEs to
> > > > > collapse to mTHP is broken:
> > > > >
> > > > >     khugepaged uses max_ptes_none scaled to the order of the enabled
> > > > >     mTHP size to determine collapses. When using mTHPs it's recommended
> > > > >     to set max_ptes_none low-- ideally less than HPAGE_PMD_NR / 2 (255
> > > > >     on 4k page size). This will prevent undesired "creep" behavior that
> > > > >     leads to continuously collapsing to the largest mTHP size; when we
> > > > >     collapse, we are bringing in new non-zero pages that will, on a
> > > > >     subsequent scan, cause the max_ptes_none check of the +1 order to
> > > > >     always be satisfied. By limiting this to less than half the current
> > > > >     order, we make sure we don't cause this feedback
> > > > >     loop. max_ptes_shared and max_ptes_swap have no effect when
> > > > >     collapsing to a mTHP, and mTHP collapse will fail on shared or
> > > > >     swapped out pages.
> > > > >
> > > > > This seems to me to suggest that using
> > > > > /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none as some means
> > > > > of establishing a 'ratio' to do this calculation is fundamentally flawed.
> > > > >
> > > > > So surely we ought to introduce a new sysfs tunable for this? Perhaps
> > > > >
> > > > > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_ratio
> > > > >
> > > > > Or something like this?
> > > > >
> > > > > It's already questionable that we are taking a value that is expressed
> > > > > essentially in terms of PTE entries per PMD and then use it implicitly to
> > > > > determine the ratio for mTHP, but to then say 'oh but the default value is
> > > > > known-broken' is just a blocker for the series in my opinion.
> > > > >
> > > > > This really has to be done a different way I think.
> > > > >
> > > > > Cheers, Lorenzo
> > > >
> > > > FWIW this was my version of the documentation patch:
> > > > https://lore.kernel.org/all/20250211111326.14295-18-dev.jain@arm.com/
> > > >
> > > > The discussion about the creep problem started here:
> > > > https://lore.kernel.org/all/7098654a-776d-413b-8aca-28f811620df7@arm.com/
> > > >
> > > > and the discussion continuing here:
> > > > https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@redhat.com/
> > > >
> > > > ending with a summary I gave here:
> > > > https://lore.kernel.org/all/8114d47b-b383-4d6e-ab65-a0e88b99c873@arm.com/
> > > >
> > > > This should help you with the context.
> > > >
> > > >
> > >
> > > Thanks and I"ll have a look, but this series is unmergeable with a broken
> > > default in
> > > /sys/kernel/mm/transparent_hugepage/khugepaged/mthp_max_ptes_none_ratio
> > > sorry.
> > >
> > > We need to have a new tunable as far as I can tell. I also find the use of
> > > this PMD-specific value as an arbitrary way of expressing a ratio pretty
> > > gross.
> > The first thing that comes to mind is that we can pin max_ptes_none to
> > 255 if it exceeds 255. It's worth noting that the issue occurs only
> > for adjacently enabled mTHP sizes.

No! Presumably the default of 511 (for PMDs with 512 entries) is set for a
reason, arbitrarily changing this to suit a specific case seems crazy no?

> >
> > ie)
> > if order!=HPAGE_PMD_ORDER && khugepaged_max_ptes_none > 255
> >       temp_max_ptes_none = 255;
> Oh and my second point, introducing a new tunable to control mTHP
> collapse may become exceedingly complex from a tuning and code
> management standpoint.

Umm right now you hve a ratio expressed in PTES per mTHP * ((PTEs per PMD) /
PMD) 'except please don't set to the usual default when using mTHP' and it's
currently default-broken.

I'm really not sure how that is simpler than a seprate tunable that can be
expressed as a ratio (e.g. percentage) that actually makes some kind of sense?

And we can make anything workable from a code management point of view by
refactoring/developing appropriately.

And given you're now proposing changing the default for even THP pages with a
cap or perhaps having mTHP being used silently change the cap - that is clearly
_far_ worse from a tuning standpoint.

With a new tunable you can just set a sensible default and people don't even
necessarily have to think about it.


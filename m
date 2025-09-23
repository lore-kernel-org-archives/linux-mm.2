Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F621CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 01:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CADCB8E000C; Mon, 22 Sep 2025 21:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85208E0001; Mon, 22 Sep 2025 21:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C288E000C; Mon, 22 Sep 2025 21:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9EF8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:50:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3106385E98
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:50:27 +0000 (UTC)
X-FDA: 83918835294.18.C1AFE82
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012025.outbound.protection.outlook.com [52.101.53.25])
	by imf25.hostedemail.com (Postfix) with ESMTP id 56914A0002
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:50:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DbXLeQwv;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.25 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758592224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnBvyUKA3mANAD1FsK3AefscEc7Tv3No4XpYG0Hfa78=;
	b=q0GQTk+IcyEXaqXiaZgf6dNiqvIliZsN/kLTPDK2Gvkf3HCvdhtpY/Kh5r9Y5OVHW85dE8
	nDM1doHHMpfEc1KFUeoxVTcbpt4yOSGP4krxK/tUkJpIefK4u8CBNLBnXewxgc/khqKXz3
	e4MVSbntfSReXIvnEhXeuCIVhTyUM2M=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DbXLeQwv;
	spf=pass (imf25.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.53.25 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758592224; a=rsa-sha256;
	cv=pass;
	b=DDE1dPcpJV7W80XSvCKNTUEoePQUMO3oZN7xkrnolVhHFlCrQ1tL07d7krxB0QB8Dytzhw
	JhsQaEvOxI3Fu+Uj8ZypKkTJ+tRVaaxsExYXlkDSxik2hTB4Sac1ita9uVhR+QKNfxXPRl
	NlVEbCfpVwngL6QpSQ+B3gl0QRbtHj8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jcJ7m89ICxaP5FShxitV3jfSsb1VazToaW8FJMdSIoxTB4bjoScWlB7/wMZfyq6HDv8tUVVaDxeUPVdRJsWRisHh8o2xlHmh9L9I2+9eAi876B/Dnv0xHhSoR8sgzWtjbHvuOCBYusMyElchtW4P2NPrYIwYKndTbmsCsNfFQGVh+0NgE69UsbZaEJjkIFZClxZPK336TSTakgxQ4kS9fm+L1xqul6gDGJoFTjOlChACA7giUHrCq5viFIVqGjYiZTb7r/G3087MsGtoYzwTIbME6d9ehEFi94abjlG9wl8tv7PC/qEgYxBd+Gjjmz7oiSneWp/d4zM71zSdmNg+oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WnBvyUKA3mANAD1FsK3AefscEc7Tv3No4XpYG0Hfa78=;
 b=TFBSu6X8keIlE+oFpcV/z3W0gic3RoZOzWTIxsnS10ZYb75KtZmapYLmfD6oLCaZV1LSWLUWRQ+VbKwdKFGNFCNSlyUz87ljLZ8CcIyUyVbJY3/ObnjcwzWXdzXXvZooVEldqytRZ3zwhX7MSCiHgQVC1/Onah8fAZhnW7gq3Hg5Xsf5SC2JBotTb652ffGJbVG+TBci617vSbxZdYLcWgQTfhXRkmtDli7LQjTbDQvh4/PizI+2QgkbdOuvXL00MELeaOlfdpqyiz5fsFeqDmEoWj5MJSctM5twHc9vfqX3aa9ZpmMMMdoLrTSsWRaWxzwI0FreHGAIlw7TFzPtQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WnBvyUKA3mANAD1FsK3AefscEc7Tv3No4XpYG0Hfa78=;
 b=DbXLeQwvQ3GYFDfrsprVh1kzJvOYo3QjIES/OMO9U+awpqz/XVCIoBY9b7MG0bkSjzHvhGbyt2Kqdx2uxqWrOxh2AUDFocG8WgFyxSXlvW3m/cvC/1h0dww5J3fvDb6FlVQ63rC5U0qWlYyeZU6vR1XOJX74MHmZ4YNZbQ2FPBn3MBHDq+Wu6iG/RQM9fPqKJnbOHlKs/bqU7HiV1Vpn/4Sdc0ynzOBv/6SCsofnbVqyZCuSGl1pQ6Z7TYe9d5xC/k9mm2DzEaMvDJbtlryvMjyM1gC6+CJiHWypnp3pk4CT6tsYnLYkYwfCRMC/FNY+LD+t7qKP7X1veJ41OSGw7w==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by CH3PR12MB8849.namprd12.prod.outlook.com (2603:10b6:610:178::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Tue, 23 Sep
 2025 01:50:20 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::3a4:70ea:ff05:1251%7]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 01:50:20 +0000
Message-ID: <a77b03b8-508b-4bad-8913-fb825ecd8a0d@nvidia.com>
Date: Tue, 23 Sep 2025 11:50:12 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [v6 04/15] mm/huge_memory: implement device-private THP splitting
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 dri-devel@lists.freedesktop.org, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-5-balbirs@nvidia.com>
 <7987AB89-4E80-4A0D-8736-E95F998698DA@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <7987AB89-4E80-4A0D-8736-E95F998698DA@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0185.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::10) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|CH3PR12MB8849:EE_
X-MS-Office365-Filtering-Correlation-Id: 86faa32f-13b9-4634-4ef0-08ddfa438d5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SUFnVjFSemVvSThHVWdaNXlhSm04MENKVHNtcy94Uk9XdU92ZW5QVmJCWTNP?=
 =?utf-8?B?RVlYTXpXVEpGOU9qcFg4d0cvcXdwSWNJVlRrcEMrTkpEOE9xWDBlNXQ2R0JB?=
 =?utf-8?B?VmU2Wm1xNHZ3MU51anU3b0R0bzZqT1FIc3A4bVZKdG5RcHFNaXlzNXd6QU40?=
 =?utf-8?B?L1ZuaTczeTZJSVRRYUJtaEhvQXBBK2dCNWtLSU9lNXpaUFM5WlcvQi95VkUr?=
 =?utf-8?B?c1NvbmxGbDNSWmZKMStrbFV1dzV0SlhCMGRoWko3UTRBRnJRNUwyVnVDT2Z0?=
 =?utf-8?B?Wlp4SjQwS3pzTmhibnBEajFKQXRSVGp1TExoelZOZGpPQUpCSDNkdTRUZlYx?=
 =?utf-8?B?bVFmdVI0V3BQR0RrcENVZlB4RzRuTHRuREZCYjdqVVpXRkwvVStQd1QxcURK?=
 =?utf-8?B?UHBQWUo5YWtmTGxrK21jR2N6OFdOR29PV1Fic1pzcEtFMGVqQXFVeWhOaVda?=
 =?utf-8?B?UFZBTmswaHNiQW9BTkdoSFVNRHZqdVJnQ1ArKys2RWRYRWt0UFBsS0pOTW1K?=
 =?utf-8?B?MC9vUWFseVRMQnJQcVEyd21UTmRNVTdoeEhQcDJzbGd4U1A1YmxUZDAyQ1Rh?=
 =?utf-8?B?TzNZOXFBaXVVN2RYQmc0cVc3TXRicHEvYmhmSUVqeHNqeDJhK3BJd3lZVXAx?=
 =?utf-8?B?RFQ1akJvUHBxQk1TOWlJNzNxWEUxMnMvUnpBUlhtMk55c2IwWERPM29tcmZI?=
 =?utf-8?B?akRmTy83YU1EUVJ5clprbERpSGpsMWJHa3RlNHUwTWtmckNkRUlWUTNGN29E?=
 =?utf-8?B?NjNyK0lGVlVuelZnMUw3ajdlVTFzdWx6eWFkd2NNWE9KRSt1NWl3Wi8yUlZ1?=
 =?utf-8?B?TGY0b1VYVlA0SWtQa3AzekdFbDZGbndkRUtBNHF5cjhaeERtTlREZ3F1MWJ0?=
 =?utf-8?B?OWRJTm9VZ25IS1oxSFZ3VUtLejIybmd1YSthMUNXbzhrYVVUWTNQM1FTbThn?=
 =?utf-8?B?S0w3Ny9LWWZRY1FNY21vWUNGVDY1L3hCcTRNSW5mRnVDU3FSSGgvdjJjT0or?=
 =?utf-8?B?QmxLSE9WTDhnNW9oR0Q3SzdpMXR4SjNuZXd6TlRvZnBkWWc2VkpKZEREOHdj?=
 =?utf-8?B?bVNXNTBhYlZWVWEvY2lpS0ZUekhSeVY4akVPZmx6aDl5U05RNWhSRTlSc3RV?=
 =?utf-8?B?OHFSWGpYd0w0ODM1MlBONGo2MjZvTk4rYzRzZzY5YWMxZE81cjF3bWVTeTQz?=
 =?utf-8?B?SGk2WEQvZUljZnhJa1BmN2ZjdXVjUDhpM0oxQjJ4VGQxU3RqdW1KY0VOeExB?=
 =?utf-8?B?dFQvL0VOQ0dBVVY1V3BWUDNrNWNnKzErVlZMa2hyVXlQNHdFdVdsSk1ua2xJ?=
 =?utf-8?B?Vjh0alg0eWF6MUttRHlrWVhXZmlXemJla0JRRTJQZ3Z1elN0YmhqR1YzN3Aw?=
 =?utf-8?B?OEFIWjN2WWpGU2NMczFzQWJZZk93YWpXaThsSVE2L2ZGMVMzRU5YS2FPQ2dP?=
 =?utf-8?B?ZnFNVDdJYis4d0lYd1BkYVN1MkE5ZTRwQ25qNWxZY1R5WlBoY1huTHBFOTRy?=
 =?utf-8?B?Q3Rhc3M1MWVVV1VhYlZCQ0g3dlhuNUZiZkJHdUNLaGJoWmN6aG95QTcyZGsx?=
 =?utf-8?B?ZlB1NUNTemc4SEd6TU1qaXdmZjNzMTZuditTdVJrM3F1WTg4K0F1VU40eEtO?=
 =?utf-8?B?dy9mRWhleDFndi9QVzNFdmF4NG1vanlxVUo3aS9NOUx2cXNTNW8yQk1UTWU0?=
 =?utf-8?B?U2RHdTNaVml1NXEzM2UwQUdCaGNFREluVVpsUDM3cU5XTlVvVEJuZWk2QkVM?=
 =?utf-8?B?Yi9tc3VTSXVyV3ZTWjRmT3B1czVVOTJvRkpRZi9NTVJlRnZHM2Y1V3UrdEpk?=
 =?utf-8?B?NmkrdEtxMmkyWmp6SXpiMGEva2YzVkpubFM4RituWGxZVlpKblU1Umo3TkVm?=
 =?utf-8?B?K28xWHRaMktrV28zcFhLWTV0S1J0ZlQvbVFLc29TRmJINEIyaTZ6Nm5qR2x0?=
 =?utf-8?Q?3N6ctUMr30k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eGU0NlBBalhxbzUzRU9kQk9tclllQmN1ZE1Cb1IxVDd4dWpuY09zZEd0NHc0?=
 =?utf-8?B?Z3NXSGlXZVVNcHIwWnE1cVBUamdreVYyZktsUFE0QmVnNHFUUWs4a3NDYXZ0?=
 =?utf-8?B?NmQrU1hmRDkyT1o1ZEdkT212TFNPdUxuaC96L3FNcXdycEJndk1QYVNZUHRj?=
 =?utf-8?B?bElybmZiTXpXeHlJWjF6ZkdXZUhrcUw1TzViRlc3T3NONytMOG9iNGxldFJ4?=
 =?utf-8?B?TDBhYzVwejMzRlVVU2QvcURlZ3JzTnVqZW02bk0rY093YnBoUTN2WHNIbnJs?=
 =?utf-8?B?N3o5SFZ2eXE1bjZCZWpFeHMzeGszL0N0aFByejBDeVZVY0s2ampwYlhyeGw1?=
 =?utf-8?B?cjI5aXJvSEtaUFVieXkxampwcUlJR1VJa2M5d3U5S0JxZWNnbHhtTHhjbkEx?=
 =?utf-8?B?TjZXSmI1QnNLVjBJY1lRRDB2UnhkcytzN0dXRERZNGIxR3pxQzUxYTdwOHVm?=
 =?utf-8?B?djlMQ1V1Wm9kOWo4azBOOFVwaFc3bnRnbEF1cmNXTEx5S1NHWkZEWGlCbFZu?=
 =?utf-8?B?VkpQK3J1ZzlzbGhHNUx5c0E1M1I4MCtEQXI5aE1UU09lYmRqdjdqcGx4NEp3?=
 =?utf-8?B?eWVERE5zUmNwSlpNZ0ZYZStmdUplSlZyYjZjLzhOYURpaGRnRnFLZkQ1M0lO?=
 =?utf-8?B?UnVZTVlLSWhNSjRPNnVSVjlqQ2NXajNFMXl0RlI0NGxxL3FxNW05UzlKeCth?=
 =?utf-8?B?L0hzN0ttbTU5d2lUYTFaOUs5VkNvOU5jcFNRbFpRL01aZTNrODUycUxhM1BW?=
 =?utf-8?B?WEhwQmg1N1NqZmJSQkdJYUprMnpUU2NzK0EyRGVxSExvajFqd1pHQWZVQkl2?=
 =?utf-8?B?T05XNU1TMkhBdEhwUkk4YVptbStKbW5TYVFaVkZnelllaGxTTEJVTnVtbWVT?=
 =?utf-8?B?Y2pOMUVMeTNYNWdHa1FNV2U1R0IwNFNvOHlGYm45bk5Sc0VTM2NLVGVnUWl2?=
 =?utf-8?B?eno0S3ltUzQ0dDVKZXp3emNYRlB6cDdlay8rTzhHSWx5S0YwRGxFSUxBZjU2?=
 =?utf-8?B?VC9rZzZ0UEQ1dHcreGVCVE5GSG1hSkE1M2tNMlBieUFSQ1pkdWw3SzJwRXJC?=
 =?utf-8?B?ejV0cWdDZVJjNEh3aEUzTlZ4S2Z5RGcweTVETFhIbk9rcE5hcWg3TVpYUDgv?=
 =?utf-8?B?Y1pFc0NzbHhTa2VGakJtNE5YKzFtUmJQTGJrWlQ2ekNTQWFFOU5RZkdNWDdZ?=
 =?utf-8?B?a2pmcUtNWGpoVk55T2lJdk9YaWhndGJXcUpPWkoybHFCOWNYNkZBSE5IcEMr?=
 =?utf-8?B?QTl4WlhESU8xMVM3VVVhNVBMTXNoMVZnT3lSSFY1cFdrZTBJTk1vSDBVOG9P?=
 =?utf-8?B?dkd5MG9LNXg1N0RDKzJZbWdmNkhjbitzdXM3ei9MQUgrUHVDMTZoc01zTTZT?=
 =?utf-8?B?cVI3OUM4RS9vcVowcHVmNmQ2aFI5Mk5RdmVNbHBDRG05ZHFCODlyNUZJd2tT?=
 =?utf-8?B?MjdTR2VwVEZxeWFBbDZuKytqTjRHYU1wTVhQRUNINzR0RDkrYkJrc0wrNVpV?=
 =?utf-8?B?MVVFUmt2NURiejJOMU8vT0pJd0hrRDdBRk5zemtucUtRYm9qT2QvbGxpOTFu?=
 =?utf-8?B?WDJUcGpGR0M3N3NKVTI3TWRIRkNiL2hWaHpPM1lNdS84WUo1anRPc2dPVUhJ?=
 =?utf-8?B?ci96ZnFHWGJSeCtzR0VwenEzTU5JQzcvcERCVkNGYmdQdHI1S3BFNFV1UnlX?=
 =?utf-8?B?WUtJdW9NbFdvTjBaUnhmUjBCMmVCMEMyNGd4ZmMyVUdWWjRUNGxoakJFa3Vy?=
 =?utf-8?B?NFVEdTFRTkNqaWNhSWMyVExIcVdod1FYYmV1WEgzMXM0dnJQdlVWUC81MjJi?=
 =?utf-8?B?ZnhFeDJCZk44dUplMkpvRHljUmMzZU15ZGs3UFZsUFZUZDZPSytZbFFzSitF?=
 =?utf-8?B?NHpvdGZBU3VuUnVIbFVRZ1prQXZuZk1SNWJ6MWxFVlI0L0p5VW5ZS0IweVRF?=
 =?utf-8?B?cXpjTUlkM1VZQS9NSlZ0RmFBbzUzNVREWW5xRUo5cFBsSEgzMWhqYVZodVZU?=
 =?utf-8?B?bzF2SUpuT1hJTVU1TWtzUFVzSGZCYlFvdFJ6N3k2MTVlbFpCUGJ3VXBMUkVZ?=
 =?utf-8?B?UGtLWTJWN2MwdHVROTVkc0hFVW1TOUxCaFpaTnliVisvZ09NNlArT3dWL3NL?=
 =?utf-8?B?ZkR3aFBwbXM3SzlCTUN2Q2VQQy83MTN0UU0wRHBzNHFNMVZQK2puZ3dmWmZv?=
 =?utf-8?Q?UzqVTyC3Jxvqn2kj1bbLEfqDAgQuEe/iHzK1rHgDLr5v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86faa32f-13b9-4634-4ef0-08ddfa438d5e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 01:50:19.9662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PNFPPxK3gejzUr+16+42g8v1TAN9T+RyFb5Y9ZXVInMuPf09SSD5NLh1KbUJ6LH+xl43gxstGcIDHkY4v0aUfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8849
X-Rspamd-Queue-Id: 56914A0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: iah4bc316xazt5ubyx6ysdxz8bjsjup3
X-HE-Tag: 1758592224-384485
X-HE-Meta: U2FsdGVkX193osfgryKhpMeNnsDGYGX+50og9+lH17OTsJV/rbN6bFLg0kqL40BUQ5GSZ13+uNP3IplKCb/1iYHUd9TtnHf2ylZkrD/rXWhZtzX9bhojJl4pRl4UEgtfVe9eIIamYzekw6ZWQ+VVuMuUvMvC2qIluTN8P9eH0ZC9yem8KBaRilrBRXxcCc01i5SQJw5rGQ0xrv8UqyHQlx06D/xHjvYe+6raTYpwXigycsazr//3s3pIbo8c2Go3LEWYdhs6NyDNRuxMggFv8dllfVx/ROn9A2uwIRtqg8/stq5QtdN0MOBDhLOoieCBHWq16lIk+mhYVIjxsSdrOjCphBrtqYFIrcMCAaMHkxw/hQRaDMlYfOGAvcexsVCanH+lcAwCvtz7YjXeyTukCTDCqDIw/BSc+YejYfuuI3wkNCIRJldm0Fu7fLW1UxLDrjYpDYta3A/VfQoG0HBJjwbhmiaOMQc/KQjVyMOskK/5YK9nsKfE/+9DTQIzPAdfKYRxbJG1hG3eOWVhHmnxeYTksrwZJpSkb/k4o8AlYti91lrpGvB2ZOdNdWfyMtiC3WXkl6uWM5jPyDywo944jqndYBgrbSwiOtk66OV9SkdIzdOn9VZJYMgrN+SDGh5OWMtfP5+De7yo/oQHmviocJe+oDJC4IfBjuYhG8/G5rxQ1U1oa/2TJQUaUJNQ5FiazGePlnuRTlCVewFgIyUpoO6gK3eO7paT4+SYYEqQWK2ZoidkRrcig+wtVKFOICTluiF35y/j/4V9w3oVUXBbkZ7kG466r5sUWTrEtF67+sBz0cFQSoy16cAFfzDH1RZ3P9mmyIJqGhhXEXQ/Q2XQIP+Pf8XmJFEk0DUQ2kgnWZ+BPtUVlYJ2sFcxJZk+SSIdH9GX1tp5JO+OMKNWGkVYH1i+mi+Dgi/JZZfiBwGFJwFkCmux4koxcqXqrVgmwinPRShL05XLaZGX5gfAXKl
 Z9xh/ztC
 RZd2P4j/8JVR7AxWyTUxvpztjVL5M0vIRG2AkSaaVr7PL+0bd7HVJTDGNGvBxuQERNvgnxap4B997EpRk70yCRHKMqiiSjrpCzi+P7JZGEGzA2DE90tu1Kc6LRXxvnVuSkd842MO4nrrrl21mYGhLwKPo4dB7hWgYXK+ybMtK9Sxka/s8crmIlQ37DJMQ/Wt+BJetFCzizoq0w3xj+6VpHUHE7sCwH/k3QZoVVLJNHmU6OI3am6dZnJohFoT7XRKTycYQzQxV8LsYS32qZ19bf6EfMnp3avqm+2xrG82ZBhEDlW/ARLzE9fAOioa2sbFuqtF1XR+LAJKPi3yGzPZOJWT8nPJmCDprNQL2YILtHhljU17d7cjV4NASbHuCKsYRRfWNqI3+fIXxRlBlWywVxxSq6e4kkMJ2ShNxzbG+UAly5apLizDxzZbfklh8o7pju8qr4BzrSjP4KY1XHglWxiZyPunGZTY4Z+UXlzWgleMEdEgTGakt1gB0ku2FoWNFChzYUI9T8xjWrG9tG6uGRHYxmpAR1lpdrzAN7vQqy5FAHR9cpueTaQYez+zPjSuA8fLvu+v2zIjFpGBg2nj8M4M5elt3DFwrt2eReEzj41nYQ1Nn6UjgJw9mCS52o4nONFZtOMaiw7n/i4avmcAk9LEt19wha7msX/MoV4AXt4Y5aewqkRT1iwNNroY0X5TjwmsAdOGj7gyv2ghdE8dd2kf9kDCuumLiEBKsqwRylQ3v2Hf192zeapRgSE2fZm/pQ8EGcoayK+VTWQHEkJ2Irc93osAqk/LzP6ZH9QQ6D/iQsW0Lh0FV6hjHH09dRENGBq09nRci5un7kqSr7EzNkaHExEGBQFlL35TAlrTRBaI+JOXSfvhcBKes5hdD6BF23wOP9Os+fJ567LO1lgKRNo/yosrki8emued2POLakxJNrzqJcHXarxy2B+3ccS1X6jRRMDuFPYfC6o7QwEr+oIC9JUen
 HGCqOWwB
 ejvj9Pi0W6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/25 07:09, Zi Yan wrote:
> On 16 Sep 2025, at 8:21, Balbir Singh wrote:
> 
>> Add support for splitting device-private THP folios, enabling fallback
>> to smaller page sizes when large page allocation or migration fails.
>>
>> Key changes:
>> - split_huge_pmd(): Handle device-private PMD entries during splitting
>> - Preserve RMAP_EXCLUSIVE semantics for anonymous exclusive folios
>> - Skip RMP_USE_SHARED_ZEROPAGE for device-private entries as they
>>   don't support shared zero page semantics
>>
>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>> Cc: Rakie Kim <rakie.kim@sk.com>
>> Cc: Byungchul Park <byungchul@sk.com>
>> Cc: Gregory Price <gourry@gourry.net>
>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>> Cc: Alistair Popple <apopple@nvidia.com>
>> Cc: Oscar Salvador <osalvador@suse.de>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>> Cc: Nico Pache <npache@redhat.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Lyude Paul <lyude@redhat.com>
>> Cc: Danilo Krummrich <dakr@kernel.org>
>> Cc: David Airlie <airlied@gmail.com>
>> Cc: Simona Vetter <simona@ffwll.ch>
>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>> Cc: Mika Penttilä <mpenttil@redhat.com>
>> Cc: Matthew Brost <matthew.brost@intel.com>
>> Cc: Francois Dugast <francois.dugast@intel.com>
>> ---
>>  mm/huge_memory.c | 138 +++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 98 insertions(+), 40 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 78166db72f4d..5291ee155a02 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2872,16 +2872,18 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  	struct page *page;
>>  	pgtable_t pgtable;
>>  	pmd_t old_pmd, _pmd;
>> -	bool young, write, soft_dirty, pmd_migration = false, uffd_wp = false;
>> -	bool anon_exclusive = false, dirty = false;
>> +	bool soft_dirty, uffd_wp = false, young = false, write = false;
>> +	bool anon_exclusive = false, dirty = false, present = false;
>>  	unsigned long addr;
>>  	pte_t *pte;
>>  	int i;
>> +	swp_entry_t swp_entry;
>>
>>  	VM_BUG_ON(haddr & ~HPAGE_PMD_MASK);
>>  	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
>>  	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PMD_SIZE, vma);
>> -	VM_BUG_ON(!is_pmd_migration_entry(*pmd) && !pmd_trans_huge(*pmd));
>> +
>> +	VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd) && !pmd_trans_huge(*pmd));
>>
>>  	count_vm_event(THP_SPLIT_PMD);
>>
>> @@ -2929,20 +2931,47 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  		return __split_huge_zero_page_pmd(vma, haddr, pmd);
>>  	}
>>
>> -	pmd_migration = is_pmd_migration_entry(*pmd);
>> -	if (unlikely(pmd_migration)) {
>> -		swp_entry_t entry;
>>
>> +	present = pmd_present(*pmd);
>> +	if (is_pmd_migration_entry(*pmd)) {
>>  		old_pmd = *pmd;
>> -		entry = pmd_to_swp_entry(old_pmd);
>> -		page = pfn_swap_entry_to_page(entry);
>> -		write = is_writable_migration_entry(entry);
>> +		swp_entry = pmd_to_swp_entry(old_pmd);
>> +		page = pfn_swap_entry_to_page(swp_entry);
>> +		folio = page_folio(page);
>> +
>> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>> +		uffd_wp = pmd_swp_uffd_wp(old_pmd);
>> +
>> +		write = is_writable_migration_entry(swp_entry);
>>  		if (PageAnon(page))
>> -			anon_exclusive = is_readable_exclusive_migration_entry(entry);
>> -		young = is_migration_entry_young(entry);
>> -		dirty = is_migration_entry_dirty(entry);
>> +			anon_exclusive = is_readable_exclusive_migration_entry(swp_entry);
>> +		young = is_migration_entry_young(swp_entry);
>> +		dirty = is_migration_entry_dirty(swp_entry);
>> +	} else if (is_pmd_device_private_entry(*pmd)) {
>> +		old_pmd = *pmd;
>> +		swp_entry = pmd_to_swp_entry(old_pmd);
>> +		page = pfn_swap_entry_to_page(swp_entry);
>> +		folio = page_folio(page);
>> +
>>  		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>>  		uffd_wp = pmd_swp_uffd_wp(old_pmd);
>> +
>> +		write = is_writable_device_private_entry(swp_entry);
>> +		anon_exclusive = PageAnonExclusive(page);
>> +
>> +		if (freeze && anon_exclusive &&
>> +		    folio_try_share_anon_rmap_pmd(folio, page))
>> +			freeze = false;
> 
> Why is it OK to change the freeze request? OK, it is replicating
> the code for present PMD folios. Either add a comment to point
> to the explanation in the comment below, or move
> “if (is_pmd_device_private_entry(*pmd))“ branch in the else below
> to deduplicate this code.

Similar to the code for present pages, ideally folio_try_share_anon_rmap_pmd()
should never fail.

> 
>> +		if (!freeze) {
>> +			rmap_t rmap_flags = RMAP_NONE;
>> +
>> +			folio_ref_add(folio, HPAGE_PMD_NR - 1);
>> +			if (anon_exclusive)
>> +				rmap_flags |= RMAP_EXCLUSIVE;
>> +
>> +			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
>> +						 vma, haddr, rmap_flags);
>> +		}
>>  	} else {
>>  		/*
>>  		 * Up to this point the pmd is present and huge and userland has
>> @@ -3026,32 +3055,57 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  	 * Note that NUMA hinting access restrictions are not transferred to
>>  	 * avoid any possibility of altering permissions across VMAs.
>>  	 */
>> -	if (freeze || pmd_migration) {
>> -		for (i = 0, addr = haddr; i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE) {
>> -			pte_t entry;
>> -			swp_entry_t swp_entry;
>> -
>> -			if (write)
>> -				swp_entry = make_writable_migration_entry(
>> -							page_to_pfn(page + i));
>> -			else if (anon_exclusive)
>> -				swp_entry = make_readable_exclusive_migration_entry(
>> -							page_to_pfn(page + i));
>> -			else
>> -				swp_entry = make_readable_migration_entry(
>> -							page_to_pfn(page + i));
>> -			if (young)
>> -				swp_entry = make_migration_entry_young(swp_entry);
>> -			if (dirty)
>> -				swp_entry = make_migration_entry_dirty(swp_entry);
>> -			entry = swp_entry_to_pte(swp_entry);
>> -			if (soft_dirty)
>> -				entry = pte_swp_mksoft_dirty(entry);
>> -			if (uffd_wp)
>> -				entry = pte_swp_mkuffd_wp(entry);
>> +	if (freeze || !present) {
>> +		pte_t entry;
>>
>> -			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>> -			set_pte_at(mm, addr, pte + i, entry);
>> +		if (freeze || is_migration_entry(swp_entry)) {
>>
> <snip>
>> +		} else {
> <snip>
>>  		}
>>  	} else {
>>  		pte_t entry;
> 
> David already pointed this out in v5. It can be done such as:
> 
> if (freeze || pmd_migration) {
> ...
> } else if (is_pmd_device_private_entry(old_pmd)) {
> ...

No.. freeze can be true for device private entries as well

> } else {
> /* for present, non freeze case */
> }
> 
>> @@ -3076,7 +3130,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>  	}
>>  	pte_unmap(pte);
>>
>> -	if (!pmd_migration)
>> +	if (!is_pmd_migration_entry(*pmd))
>>  		folio_remove_rmap_pmd(folio, page, vma);
>>  	if (freeze)
>>  		put_page(page);
>> @@ -3089,7 +3143,7 @@ void split_huge_pmd_locked(struct vm_area_struct *vma, unsigned long address,
>>  			   pmd_t *pmd, bool freeze)
>>  {
>>  	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PMD_SIZE));
>> -	if (pmd_trans_huge(*pmd) || is_pmd_migration_entry(*pmd))
>> +	if (pmd_trans_huge(*pmd) || is_pmd_non_present_folio_entry(*pmd))
>>  		__split_huge_pmd_locked(vma, pmd, address, freeze);
>>  }
>>
>> @@ -3268,6 +3322,9 @@ static void lru_add_split_folio(struct folio *folio, struct folio *new_folio,
>>  	VM_BUG_ON_FOLIO(folio_test_lru(new_folio), folio);
>>  	lockdep_assert_held(&lruvec->lru_lock);
>>
>> +	if (folio_is_device_private(folio))
>> +		return;
>> +
>>  	if (list) {
>>  		/* page reclaim is reclaiming a huge page */
>>  		VM_WARN_ON(folio_test_lru(folio));
>> @@ -3885,8 +3942,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>>  	if (nr_shmem_dropped)
>>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>>
>> -	if (!ret && is_anon)
>> +	if (!ret && is_anon && !folio_is_device_private(folio))
>>  		remap_flags = RMP_USE_SHARED_ZEROPAGE;
>> +
> 
> You should remove this and add
> 
> if (folio_is_device_private(folio))
> 	return false;
> 
> in try_to_map_unused_to_zeropage(). Otherwise, no one would know
> device private folios need to be excluded from mapping unused to
> zero page.
> 

I had that upto v2 and then David asked me to remove it. FYI, this
is the only call site for RMP_USE_SHARED_ZEROPAGE

>>  	remap_page(folio, 1 << order, remap_flags);
>>
>>  	/*
>> -- 
>> 2.50.1
> 
> 

Thanks for the review
Balbir



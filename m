Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A06CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 17:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C61E8E0003; Thu,  2 Oct 2025 13:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DD88E0001; Thu,  2 Oct 2025 13:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C738E0003; Thu,  2 Oct 2025 13:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 713558E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:11:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1BC00BA14C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:11:19 +0000 (UTC)
X-FDA: 83953815078.21.1F0BBE7
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013071.outbound.protection.outlook.com [40.93.201.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id 077908000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:11:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=P4v99KR9;
	spf=pass (imf02.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.71 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759425076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huNcEIewhipS44zElWNdT3WqoFwT0Wl2BEoh8hmrdfQ=;
	b=yF0F+6i1jSEJbra7Nk684yMLAxmElNc7pX8ONytWI46uxtccU83yf8v5/BKy/M0UWMVAPA
	5LVTKBr9wMxD/OqFLhLfh70wm3r3ObUriCgMyHqIvtXNX0ojMOS4OjEFujxAUkfV1NR5B7
	I96UWoOpfyDgwn3a8XK0MyBBB0TeJCs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=P4v99KR9;
	spf=pass (imf02.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.71 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759425076; a=rsa-sha256;
	cv=pass;
	b=6MxDeTHj0bm5zwbV8fH1PIm2GMdlvdOgFa2iQg+br2ysUlfDYgiPAwfzm4ONYxaeIKQn2+
	sb/K4NvErzl4wrLTnT4UghzwiH8ewUOQi1ozkkRr6lMlO6aPCvSzlYFzu6qsIwlZBxypHB
	JsjKAgImL5l7+OUFRxnQm9aSC7Gy27E=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w1K7A4k3W61DqMrpihrXsiNyVFSO8Iuqc1MRwAKHT8qoowApDhwyAiesL84HUzjgbrMYtvJUtLSYctH4LXKLtjTIEgcGgdPF4d3XFr+5TTicTnjIH8b2vxfjHZF/5UwlQyiPctth7K9VROmnojCUo0VENimdYwQsCXvlen9ugtkJkt4gbS6xI9j3boE4QBcQmRHMMOZiOKlWizPYhZWlSBHvyu13i49aBNhXDvWx5v1geWNO7ihKy6JouK3RAGf2KrZnyXfE7Qcymli5kMdFPvijmYH0kSR/oQUKaPryoR0k/hRpf87X7hs2+SbrHhjJ0B7nO7rKUNQCL8GOqcbqYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=huNcEIewhipS44zElWNdT3WqoFwT0Wl2BEoh8hmrdfQ=;
 b=phhi2zzcnAs3doiu6n9DHqNeOgYEdVVHxRyPkVtoslbjjmXMtDFiSBw1Xcpht0g8+QSta+ZgT4KZVDO8YHt3TbBHPgd21ibAz7NLcEuUTZV6TehEmsl5B9XyLarfoNsY63XuGNTO7b39vVFF8ydRWqMSQRAmvI7iY5kNWEf9RHFu908OA8vpl1HiQRkfQ3GVoRlLqYhtBMyTmqa2Bh2VThwC1159HFuClZtLsa67gn4J7uq1fnR2NAiLp9A4oJ30AVeUnbMiSgFhcGOPgkNxfkVwLwCdKpYl6jAvBa8UJaej4yC0+X+VMIXSVa3zxXYjCvZsQBx2xlPuYVz9shuZaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=huNcEIewhipS44zElWNdT3WqoFwT0Wl2BEoh8hmrdfQ=;
 b=P4v99KR98wn3UWbp0t2x9HT7CTxV3wYcne+cgmORzu2Uy00a5ufEKbNtCEGEHSwfIHxYL0yieBKoyxUiqYoiJTNdevWitibQ378UGLA5d9C2q4iUs/oDNczCzm1GjiWeRp7v0jCC6ctcsrXirH76FshpMIfeYYoyf9lIEyj9+aY=
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by MN0PR12MB6001.namprd12.prod.outlook.com (2603:10b6:208:37d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Thu, 2 Oct
 2025 17:11:07 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 17:11:07 +0000
Message-ID: <1c8c91a7-9f6d-442f-8e20-736fd5d41ef3@amd.com>
Date: Thu, 2 Oct 2025 22:40:48 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 0/9] Accelerate page migration with batch copying and
 hardware offload
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@redhat.com, willy@infradead.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 vkoul@kernel.org, lucas.demarchi@intel.com, rdunlap@infradead.org,
 jgg@ziepe.ca, kuba@kernel.org, justonli@chromium.org, ivecera@redhat.com,
 dave.jiang@intel.com, Jonathan.Cameron@huawei.com, dan.j.williams@intel.com,
 rientjes@google.com, Raghavendra.KodsaraThimmappa@amd.com, bharata@amd.com,
 alirad.malek@zptcorp.com, yiannis@zptcorp.com, weixugc@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250923174752.35701-1-shivankg@amd.com>
 <633F4EFC-13A9-40DF-A27D-DBBDD0AF44F3@nvidia.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <633F4EFC-13A9-40DF-A27D-DBBDD0AF44F3@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1P287CA0001.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:40::21) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|MN0PR12MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a6eedd7-7334-45e2-95bd-08de01d6acee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFJxb2hiZXpDc2V4eUZRK2lGYTZCMlU2clJob0g1Q1hxN0taZ04zTjI0eDJs?=
 =?utf-8?B?NGpmZGhtTC90bXdGUXJFbjZYNFkyNXRwZ0h6Y090bWxnYzc5R2FMcGQrTGlG?=
 =?utf-8?B?dld0eHQ5WmtIM05FWHJ2NEh1YkVHVGNkVDBQL09aTWQ2bVAxSXhpc1A1bEs3?=
 =?utf-8?B?NXliRjlwdEdFYkFra3MwNHAzYXRKY0I1K2g0NW9wL2RUcEM3M2xFT2dOQXZQ?=
 =?utf-8?B?TkIyZ3lyaGlvY05TZEVtTmNFN3NuV3o4SmV6ZkZQdzU4VWZFb2lZN2JCbmJn?=
 =?utf-8?B?WWxPSE5hVHF1RFAxWGU5bmtkVEFBcG95MnZtdS9OdEtXQVB6MGJIcm1BR0Y5?=
 =?utf-8?B?ZHpZaWRaYU42TWVKcWpuTVE3bWFLZ2JucGJzQnhHamFndFN5RDM2ZHlEMTJs?=
 =?utf-8?B?MWpvMG1HYWFubG5xckZibW8yUXhPazcwYnJWWSsyZ1N2TFlyM1ZWdHBFakpu?=
 =?utf-8?B?aVZLdDIzK09ZQzRYL2pNOXFYRlJuL0hUSlZXWlhmU0JGNlRPV0ZiS0g2Rm83?=
 =?utf-8?B?dlo1MXFXTFZMOTU1OG43b0NDbnZIT1d3dlBUT0E0ZkJTOWprcjNKNmVZZE5L?=
 =?utf-8?B?eTZTTkhFNFVoR1JjNzlNek94Wm5EeTE3SnJKQVFxcmZFb1M5ZXBqbWhTWjN0?=
 =?utf-8?B?ckRZUmJxU1VkUUNHNHVwRyt0RG1IejBrL3ErMlhmMC90MnAwbExRamIxckFV?=
 =?utf-8?B?OGk3UjRyeEJUUnhhTnplRThyUEp1b0lVaUtPbUEzM0hNVXBUYUh6ZWxvOHZ2?=
 =?utf-8?B?dXFwMHg0TFZ6SWowNzBDS0tHZXBxYUtXVFJ3aVZEVUhBSnBhaUNuRUVwL0p0?=
 =?utf-8?B?QnJYWW9rcTRsYXhpRFVqS0lKT3Q5MjA5M1JkeUttNExIU0xUY01vNis3UzdJ?=
 =?utf-8?B?a0hncFNob01uWXh2QlZJRjRPaGg3czlIQk8xOWZEdndvcVpLbjFHTkc0NUxl?=
 =?utf-8?B?SXZHZGhiV0ZUUjVGWkN4OGdWN0IxWXJoYkZibThPTmpwTVVSYmJOeU1FWXVx?=
 =?utf-8?B?Z3dDeFhZaTN1R0tOQ3R1LzRvT2ZsaXBHaTZHWkM1ZkljakZCeit5MzR0RVJG?=
 =?utf-8?B?NEZibHdVTHljSHlQMmxRazFUN0NlMTlIMnFwZlBZdm81WkVTOU4vNUw3OVhC?=
 =?utf-8?B?SjVxNXYrLyt5bVo1VTk3ZEI1ZXB1U2R6MURuRkpFTis0RDBKUHQxalNHc3Fk?=
 =?utf-8?B?UkwrYWl1Q1JFc0tGR3BPdXJKaG43ZTY0V3ZxNGRSVTJydm1WVCtQVFJjUHpK?=
 =?utf-8?B?Skx6a1QyVm9takF0bnhPLzZJUU5CaCtTUDZKdkRLRzUyYWJ2UTJGNjV1RDdC?=
 =?utf-8?B?MmtkUmNvbmt0bHBSMTZnNE1LYTVsWi9wRkJ6elg3MERrc1dCZ0JkS21iTi9L?=
 =?utf-8?B?S01DMHlyNEFBSFJRUGhCTEFTSzhqT0RiS3VNQXV0eTRRbXNLaDRWTUh3eGxJ?=
 =?utf-8?B?UjhkZzVTZU9qaktmemYyemJBaHNCMFVkWFNNeEIwb3d1dG1qeGRZdmFSaXRi?=
 =?utf-8?B?eER0YzZXN0tJcjludE5ZREdZbExrYTZLNmVWRUd2eVoxVHJudmhHWHlDVkNu?=
 =?utf-8?B?V2NLUS8rMTNCVGEyUDJCVXNySEpNMDI1d0ZySTlNUFc2TEtjSHp2SElvYVhN?=
 =?utf-8?B?b3pDbmdXb1MyN3RzbStkTnZ6R1ppNStlcXdHei9TMXpkaW10TmZNdWZxa3Zo?=
 =?utf-8?B?SjJiSHc3OEQzVXN2NGlUa2NmUW1ObWJFZktuZlFXVHNKY1NqV3hIWDdKakxP?=
 =?utf-8?B?T3grQVVsRk9kSnN2cTdtdDNnWElvL0luY285NUkzMHZwaE53WmVwWkF2cXl6?=
 =?utf-8?B?SFVpR2xYcC9FNzZYQkVUSUNWWHVENk43Q1pxZGwrd001TlZ3R1NwM3BqTHgr?=
 =?utf-8?B?RkhjVjd6VnNBNUJUK0NUUE9ZakRSeHpXbDljNnBGVVRtL2RYS0R3Zk55MzM4?=
 =?utf-8?Q?zEx8q3fNScw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N3RWeUxzRjlSNmhrTUJjb2dyOWNJTFFYS3ArK3pFbmh6d05Dd0sxVS82YWxV?=
 =?utf-8?B?V2Y0SXpQemEvNlVLWmZmOXJEWUs1NGJHNFBUaHoxTXJlRC9QdlNGY1RVL1Nw?=
 =?utf-8?B?ZmlhaW4yeVZ0bzByR3lFV08va1NQdHhpWjlYQUNtajVZWFdDVlcvWTdRZmtE?=
 =?utf-8?B?ZGxkdGtxcHpHa1grWWhqR1NYanlyWXh4UE1tS2ZINDVzWTZYYk9sUVdVRlZJ?=
 =?utf-8?B?MHh5YytQNXZRSDh2YVNLUVdBUm9QdEtBVFJHV3dBaGZCOFFFMDI4ZDZIQnpH?=
 =?utf-8?B?RFNteXJOMlV0QjZyT0IydVVkMTRSdy90ZGJVT3RLQzBnLzltOVlpbkRuWXlB?=
 =?utf-8?B?RXpWN2R0cFgwbTFWWXF6Q1VNeHcyZFY1Ty85N0ZJaVQxcU15T2k2cnZQTFMz?=
 =?utf-8?B?MVBIeEIwaGh3dmlEeGNGWHFXdGtXQk9oZXpyeWdyNFdFV2tubnRrdkgrSWc0?=
 =?utf-8?B?OC9aaExoZFdLaHJEMmlYQ2N3WkQ2c3ZyQjVhcXI5Z2V1d0lIWmpiMjVKeGFF?=
 =?utf-8?B?bHFJbGpmSGpSck9DaXJINC9Ndk5xZUlya0NUR0loZ083YUNvUklWLzdHWUQy?=
 =?utf-8?B?dmtoM1lTTFozTmdtK01VRzZ1VVlYWDZtUEdZUmVmRGtFQUdVTzdhNEp2M3g5?=
 =?utf-8?B?WGVEWnZvbFF5MmpyV1J3RTBBNXpBcXROMlNlYnUvODl2WTcrWWgrZW1ZTXNu?=
 =?utf-8?B?Wm05cjRSbjdoTnVjdDZBbDkwZllldDhha3N6d1ZzeXUwbUdUME9mZlN2QSsw?=
 =?utf-8?B?TkovZW5Nb0lrb2gwMW5hWmJIUEQySTJ5Wkx3a2ZRR0ZvT21kVmE4YWZGVGVP?=
 =?utf-8?B?RUN2UGpVczZiWktoSmVFQ2IvSlFpalpxUlJYSkpqd3NYcEZSK055MjhUTlAy?=
 =?utf-8?B?S09vem04NzlZRTdyTEtwTmZkbEtleVMyTTNNWmtJaUFRSDlPYUE1dDBwNUh1?=
 =?utf-8?B?cStsc0R6M2tIQWFKNWljRFA4VE15dkkwdk1DUGF5aFp4Rzg3L2JMdHBhOGox?=
 =?utf-8?B?MUpMMS9MZUltaHVBRTh5MlFJSEJ1blU1NEwvMDJDOE94MnlPS01ZeTgxcnJ1?=
 =?utf-8?B?OFJ0MHdUODlTR3NlYXZHWkwwalRBRHZrV0hzeVdhZTEwOUpnYlBtNTdGVE54?=
 =?utf-8?B?SzVlbVUzTjE1U3U5RGwzakU3ZitJTWtUZUdET2dzSCtxbCthd1VaMzNGMEd1?=
 =?utf-8?B?ZlAzWHdLNjg5YmxUb2VrTDV6eWFnMURDdEtzVDJsNFVUbUVlMHNoNXlRUk5S?=
 =?utf-8?B?VDlER05BSWpSZUc5N0hveHNsVFdJREwrR0daOHRFVDB0MkRjSTF5Unl0VGhF?=
 =?utf-8?B?RTdZU09KR3JoanBzcC9veitickRFR3MyUGdsV1NvMXY0WG9uK0M5Unh0M2ZF?=
 =?utf-8?B?Y25zSEY4b3lnaVE1UWlVQ0lDRDBKeGZ3aTJEcVdsWm1oV2tDeS9hSVpSVzVY?=
 =?utf-8?B?LzhoSzI5QWw2alVFYnR4N0NlczQwZlVyNzBPT2kyYlArWlRtZU1JTVVhd2x5?=
 =?utf-8?B?dm1lK3BURG1nUTRzNmgrb3MzZFNGL0xVZnVwUjkrMVFhOThZd1NjcmtaV3N0?=
 =?utf-8?B?R25FUGhkY1U2elYzSnJTZ2ZUT0ZsbDBvN21MeTNOL2hlRUV2UjgyU2Jncjdr?=
 =?utf-8?B?TGhyNGRLb1BkdEVVeStXNFZVSVlzVTNvd29lZEdpUGc3VkVKQkIxb1ZweWhl?=
 =?utf-8?B?aFI3aFBGRDJDU3dyK3Z6U2dIT2RJK0xwR3JtczRwaEJOb0F1TGY0RzZrelAy?=
 =?utf-8?B?c2pZUVVSMDdMbUtJcnNveTFsMW1BNGhCNGx2YUpIc3FjNnA0d1B6Vk5BUC8y?=
 =?utf-8?B?bTFZaGVNeG5iU0VCSlZHYXBNWlFVR3NrZkZveE5OOUdCcjJMdzZVbjJuZGQv?=
 =?utf-8?B?OVVSbjlsTFJqNE5yOWdCeUZVSTZxOHQ5NkhxK1FyV2RhMUJ1VWJENlZOMU1k?=
 =?utf-8?B?TkxyZkNqWk1yVngyTjU4S3NrZWhveXJHSElJcFBBZWpqWHhhWFVDNHFCUjhS?=
 =?utf-8?B?L3F4L21PVlJURU5ETUplNWdNTkFMWkZQQ2pla2Q0N2ozUE9RY25CK09aaE44?=
 =?utf-8?B?Tk5sNnRqKzhoMG5WTk5vQjI1emxpQVZMMnRPTHo0S3NKUGU2OHhNeTR2MDVC?=
 =?utf-8?Q?h67s5UanUwqLQCIJbqcZB0oKF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6eedd7-7334-45e2-95bd-08de01d6acee
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 17:11:07.4524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4RQP2vanFjCXXpNRQJkjgjeWTOzOAxFg0bpCVGXRaGIKppmIZN/sAZf4PS90QBC+VH4wLZ+t/dfoCwrQh8w0VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6001
X-Rspamd-Queue-Id: 077908000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: d1pnbgofcbswsbyjcgnnaaj5k41mutoj
X-HE-Tag: 1759425075-889235
X-HE-Meta: U2FsdGVkX1/eOi2ZpBFm91cbRKJpyYYgUEFuEfW3L6JhtBqxxn3j+mRmdmU17nOe4RyKAzgA76aAuS5HjV3zZMTp1KA87R0tzWrPTAD/W7buV0mPROcMK8LC1cdR6wGceOwZ9Nj5PdGInM+9EutsKhNCZxt7cw3NJPWZBrSPPyf4lfOhprGn8PG568w4qRdTbq32yt5NPP46AQOgAvUJbRh0mBAGC7fGqTJxpgM8FVhxK7J3MG2oAs3HXpX0pu4MwpFZ7H4cg1WOYqPaY0sBiiLo+2lgpP2KpbgrIiRTgsgIbRbJ9luI7X2VReaqJ7UO6OgtI8Cwbbukg9dnl9SL+i+d8H5tcxGo1fCJEd08YojzBRhiEz7J5DBI9Wxgseny457DhX2mH3sdWBmezqdoLVyJSFOX5VS8etT2alIWfe0JQBfKvgDYb+d93fQzxqW55L6AKNJaLLdVPwm/hn3WxGWtfJ9Vbp2KrIz0egr6f248/9ZNemM4VL8PT16z/D2DEmSBVrWS5RRGlaYywLnxSSAj3bsxXQWAqgDNQBlXevYFxha9MJo73w/yYYovaMexld7SWGjBCzjlfXL5M8LxfAXUMuc0hCpxhgGyXsk2LOuly7A3yTq2YWNtuBaT6HjCAXiLNeP39Ll6/k1L3Mn6/Goy4w8jyEw47MDrBCO9wUlhJoMBSNHw5QsDvz/7ggATDLIw2j2tXX10hOARqnDlZK48E+OMi0VUna+9+seks7u9y1W3S9BQA2d2j294lGkIp53iQG8ywVfFSsEnaU2kEbDfCJqMMNzbNcBeZ2vvyNXCalKn0O5Rm5DmH5PR4nxvBSPsPAcgQz3tuwC/gBILbfX1vecHHOdBEt1O3PKwbmtqGLw2/q3mo76MTAgwgk39yFkyCH4cVInlms6kScQ/BgPX4bHTk+if+jcX3kiJibCzAm1fXe2z3mGJPK6eASFXLdZTQwxmbeEGECKeBH3
 R7zXIvF/
 G2uizipDZHsRgP4k0dpRnT87KjNxIUnC+lYEsFeEFaGVq9MXFQ2UOcyrGSPyZ3obaG9z88jx6wAsHLLgv4D296zWCwtBgQ0cGB4FyfGnEcUzYtB/Ly0n3vOzMbtkiZaLxNey4dY6zPpfoGphVsNlQ9FiCH059GiJajsEDvMsYxrqLtesWWs5B4bRpbmhUKbTMuj6nvx1kVPaoKSKJIJKnYCtwVLFRgU4Xj4sxP3gsx9dOpJeaP4i+I5REy/WDXiSZzPrBrm3/9BQ/pQ/EJiwgpwpuoyxLmKC25WyJE1olAPTTW/Am3yeIRmEyCtLYSjrbppF75WtDhAOhpzTgAONTLISJbBVyoY0zZgO7sAvmNrwPwLS0UHNHswNhiupX9kh+DlIBwuVtD1kheT4Dave8OQT6BvcVG7YMkqXBEK6fZMw+F9C4BMNrDrnQR5vQWQ5AtxHKbGkhOSl67so7ssjqcW9JiiPwuqTop4K2AGljWYeRVqV0UEAnOi6mR/Hk+IoXKp7/UbCPeDaUhkQ4q99D7Vx8W9FmpkYIXsYmvfCfS9NPPGNfp5GLf588LdZHYw7sY06aMOW5EGE7d6+OUurrrqYCn+dUq7iI+wywSRDHSHHoukM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/24/2025 8:52 AM, Zi Yan wrote:
> On 23 Sep 2025, at 13:47, Shivank Garg wrote:
> 
>> This is the third RFC of the patchset to enhance page migration by batching
>> folio-copy operations and enabling acceleration via multi-threaded CPU or
>> DMA offload.
>>
>> Single-threaded, folio-by-folio copying bottlenecks page migration
>> in modern systems with deep memory hierarchies, especially for large
>> folios where copy overhead dominates, leaving significant hardware
>> potential untapped.
>>
>> By batching the copy phase, we create an opportunity for significant
>> hardware acceleration. This series builds a framework for this acceleration
>> and provides two initial offload driver implementations: one using multiple
>> CPU threads (mtcopy) and another leveraging the DMAEngine subsystem (dcbm).
>>
>> This version incorporates significant feedback to improve correctness,
>> robustness, and the efficiency of the DMA offload path.
>>
>> Changelog since V2:
>>
>> 1. DMA Engine Rewrite:
>>    - Switched from per-folio dma_map_page() to batch dma_map_sgtable()
>>    - Single completion interrupt per batch (reduced overhead)
>>    - Order of magnitude improvement in setup time for large batches
>> 2. Code cleanups and refactoring
>> 3. Rebased on latest mainline (6.17-rc6+)
> 
> Thanks for working on this.
> 
> It is better to rebase on top of Andrew’s mm-new tree.
> 
> I have a version at: https://github.com/x-y-z/linux-dev/tree/batched_page_migration_copy_amd_v3-mm-everything-2025-09-23-00-13.
> 
> The difference is that I changed Patch 6 to use padata_do_multithreaded()
> instead of my own implementation, since padata is a nice framework
> for doing multithreaded jobs. The downside is that your patch 9
> no longer applies and you will need to hack kernel/padata.c to
> achieve the same thing.

This looks good. For now, I'll hack padata.c locally.

Currently, with numa_aware=true, padata round-robins work items across
NUMA nodes using queue_work_node().
For an upstream-able solution, I think we need a similar mechanism to
spread work across CCDs.

> I also tried to attribute back page copy kthread time to the initiating
> thread so that page copy time does not disappear when it is parallelized
> using CPU threads. It is currently a hack in the last patch from
> the above repo. With the patch, I can see system time of a page migration
> process with multithreaded page copy looks almost the same as without it,
> while wall clock time is smaller. But I have not found time to ask
> scheduler people about a proper implementation yet.
> 
> 
>>
>> MOTIVATION:
>> -----------
>>
>> Current Migration Flow:
>> [ move_pages(), Compaction, Tiering, etc. ]
>>               |
>>               v
>>      [ migrate_pages() ] // Common entry point
>>               |
>>               v
>>     [ migrate_pages_batch() ] // NR_MAX_BATCHED_MIGRATION (512) folios at a time
>>       |
>>       |--> [ migrate_folio_unmap() ]
>>       |
>>       |--> [ try_to_unmap_flush() ] // Perform a single, batched TLB flush
>>       |
>>       |--> [ migrate_folios_move() ] // Bottleneck: Interleaved copy
>>            - For each folio:
>>              - Metadata prep: Copy flags, mappings, etc.
>>              - folio_copy()  <-- Single-threaded, serial data copy.
>>              - Update PTEs & finalize for that single folio.
>>
>> Understanding overheads in page migration (move_pages() syscall):
>>
>> Total move_pages() overheads = folio_copy() + Other overheads
>> 1. folio_copy() is the core copy operation that interests us.
>> 2. The remaining operations are user/kernel transitions, page table walks,
>> locking, folio unmap, dst folio alloc, TLB flush, copying flags, updating
>> mappings and PTEs etc. that contribute to the remaining overheads.
>>
>> Percentage of folio_copy() overheads in move_pages(N pages) syscall time:
>> Number of pages being migrated and folio size:
>>             4KB     2MB
>> 1 page     <1%     ~66%
>> 512 page   ~35%    ~97%
>>
>> Based on Amdahl's Law, optimizing folio_copy() for large pages offers a
>> substantial performance opportunity.
>>
>> move_pages() syscall speedup = 1 / ((1 - F) + (F / S))
>> Where F is the fraction of time spent in folio_copy() and S is the speedup of
>> folio_copy().
>>
>> For 4KB folios, folio copy overheads are significantly small in single-page
>> migrations to impact overall speedup, even for 512 pages, maximum theoretical
>> speedup is limited to ~1.54x with infinite folio_copy() speedup.
>>
>> For 2MB THPs, folio copy overheads are significant even in single page
>> migrations, with a theoretical speedup of ~3x with infinite folio_copy()
>> speedup and up to ~33x for 512 pages.
>>
>> A realistic value of S (speedup of folio_copy()) is 7.5x for DMA offload
>> based on my measurements for copying 512 2MB pages.
>> This gives move_pages(), a practical speedup of 6.3x for 512 2MB page (also
>> observed in the experiments below).
>>
>> DESIGN: A Pluggable Migrator Framework
>> ---------------------------------------
>>
>> Introduce migrate_folios_batch_move():
>>
>> [ migrate_pages_batch() ]
>>     |
>>     |--> migrate_folio_unmap()
>>     |
>>     |--> try_to_unmap_flush()
>>     |
>>     +--> [ migrate_folios_batch_move() ] // new batched design
>>             |
>>             |--> Metadata migration
>>             |    - Metadata prep: Copy flags, mappings, etc.
>>             |    - Use MIGRATE_NO_COPY to skip the actual data copy.
>>             |
>>             |--> Batch copy folio data
>>             |    - Migrator is configurable at runtime via sysfs.
>>             |
>>             |          static_call(_folios_copy) // Pluggable migrators
>>             |          /          |            \
>>             |         v           v             v
>>             | [ Default ]  [ MT CPU copy ]  [ DMA Offload ]
>>             |
>>             +--> Update PTEs to point to dst folios and complete migration.
>>
>>
>> User Control of Migrator:
>>
>> # echo 1 > /sys/kernel/dcbm/offloading
>>    |
>>    +--> Driver's sysfs handler
>>         |
>>         +--> calls start_offloading(&cpu_migrator)
>>               |
>>               +--> calls offc_update_migrator()
>>                     |
>>                     +--> static_call_update(_folios_copy, mig->migrate_offc)
>>
>> Later, During Migration ...
>> migrate_folios_batch_move()
>>     |
>>     +--> static_call(_folios_copy) // Now dispatches to the selected migrator
>>           |
>>           +-> [ mtcopy | dcbm | kernel_default ]
>>
>>
>> PERFORMANCE RESULTS:
>> --------------------
>>
>> System Info: AMD Zen 3 EPYC server (2-sockets, 32 cores, SMT Enabled),
>> 1 NUMA node per socket, Linux Kernel 6.16.0-rc6, DVFS set to Performance,
>> PTDMA hardware.
>>
>> Benchmark: Use move_pages() syscall to move pages between two NUMA nodes.
>>
>> 1. Moving different sized folios (4KB, 16KB,..., 2MB) such that total transfer size is constant
>> (1GB), with different number of parallel threads/channels.
>> Metric: Throughput is reported in GB/s.
>>
>> a. Baseline (Vanilla kernel, single-threaded, folio-by-folio migration):
>>
>> Folio size|4K       | 16K       | 64K        | 128K       | 256K       | 512K       | 1M         | 2M         |
>> ===============================================================================================================
>> Tput(GB/s)|3.73±0.33| 5.53±0.36 | 5.90±0.56  | 6.34±0.08  | 6.50±0.05  | 6.86±0.61  | 6.92±0.71  | 10.67±0.36 |
>>
>> b. Multi-threaded CPU copy offload (mtcopy driver, use N Parallel Threads=1,2,4,8,12,16):
>>
>> Thread | 4K         | 16K       | 64K        | 128K       | 256K       | 512K       | 1M         | 2M         |
>> ===============================================================================================================
>> 1      | 3.84±0.10  | 5.23±0.31 | 6.01±0.55  | 6.34±0.60  | 7.16±1.00  | 7.12±0.78  | 7.10±0.86  | 10.94±0.13 |
>> 2      | 4.04±0.19  | 6.72±0.38 | 7.68±0.12  | 8.15±0.06  | 8.45±0.09  | 9.29±0.17  | 9.87±1.01  | 17.80±0.12 |
>> 4      | 4.72±0.21  | 8.41±0.70 | 10.08±1.67 | 11.44±2.42 | 10.45±0.17 | 12.60±1.97 | 12.38±1.73 | 31.41±1.14 |
>> 8      | 4.91±0.28  | 8.62±0.13 | 10.40±0.20 | 13.94±3.75 | 11.03±0.61 | 14.96±3.29 | 12.84±0.63 | 33.50±3.29 |
>> 12     | 4.84±0.24  | 8.75±0.08 | 10.16±0.26 | 10.92±0.22 | 11.72±0.14 | 14.02±2.51 | 14.09±2.65 | 34.70±2.38 |
>> 16     | 4.77±0.22  | 8.95±0.69 | 10.36±0.26 | 11.03±0.22 | 11.58±0.30 | 13.88±2.71 | 13.00±0.75 | 35.89±2.07 |
>>
>> c. DMA offload (dcbm driver, use N DMA Channels=1,2,4,8,12,16):
>>
>> Chan Cnt| 4K        | 16K       | 64K        | 128K       | 256K       | 512K       | 1M         | 2M         |
>> ===============================================================================================================
>> 1      | 2.75±0.19  | 2.86±0.13 | 3.28±0.20  | 4.57±0.72  | 5.03±0.62  | 4.69±0.25  | 4.78±0.34  | 12.50±0.24 |
>> 2      | 3.35±0.19  | 4.57±0.19 | 5.35±0.55  | 6.71±0.71  | 7.40±1.07  | 7.38±0.61  | 7.21±0.73  | 14.23±0.34 |
>> 4      | 4.01±0.17  | 6.36±0.26 | 7.71±0.89  | 9.40±1.35  | 10.27±1.96 | 10.60±1.42 | 12.35±2.64 | 26.84±0.91 |
>> 8      | 4.46±0.16  | 7.74±0.13 | 9.72±1.29  | 10.88±0.16 | 12.12±2.54 | 15.62±3.96 | 13.29±2.65 | 45.27±2.60 |
>> 12     | 4.60±0.22  | 8.90±0.84 | 11.26±2.19 | 16.00±4.41 | 14.90±4.38 | 14.57±2.84 | 13.79±3.18 | 59.94±4.19 |
>> 16     | 4.61±0.25  | 9.08±0.79 | 11.14±1.75 | 13.95±3.85 | 13.69±3.39 | 15.47±3.44 | 15.44±4.65 | 63.69±5.01 |
>>
>> - Throughput increases with folio size. Larger folios benefit more from DMA.
>> - Scaling shows diminishing returns beyond 8-12 threads/channels.
>> - Multi-threading and DMA offloading both provide significant gains - up to 3.4x and 6x respectively.
>>
>> 2. Varying total move size: (folio count = 1,8,..8192) for a fixed folio size of 2MB
>>    using only single thread/channel
>>
>> folio_cnt | Baseline    | MTCPU      | DMA
>> ====================================================
>> 1         | 7.96±2.22   | 6.43±0.66  | 6.52±0.45   |
>> 8         | 8.20±0.75   | 8.82±1.10  | 8.88±0.54   |
>> 16        | 7.54±0.61   | 9.06±0.95  | 9.03±0.62   |
>> 32        | 8.68±0.77   | 10.11±0.42 | 10.17±0.50  |
>> 64        | 9.08±1.03   | 10.12±0.44 | 11.21±0.24  |
>> 256       | 10.53±0.39  | 10.77±0.28 | 12.43±0.12  |
>> 512       | 10.59±0.29  | 10.81±0.19 | 12.61±0.07  |
>> 2048      | 10.86±0.26  | 11.05±0.05 | 12.75±0.03  |
>> 8192      | 10.84±0.18  | 11.12±0.05 | 12.81±0.02  |
>>
>> - Throughput increases with folios count but plateaus after a threshold.
>>   (The migrate_pages function uses a folio batch size of 512)
>>
>> Performance Analysis (V2 vs V3):
>>
>> The new SG-based DMA driver dramatically reduces software overhead. By
>> switching from per-folio dma_map_page() to batch dma_map_sgtable(), setup
>> time improves by an order of magnitude for large batches.
>> This is most visible with 4KB folios, making DMA viable even for smaller
>> page sizes. For 2MB THP migrations, where hardware transfer time is more
>> dominant, the gains are more modest.
>>
>> OPEN QUESTIONS:
>> ---------------
>>
>> User-Interface:
>>
>> 1. Control Interface Design:
>> The current interface creates separate sysfs files
>> for each driver, which can be confusing. Should we implement a unified interface
>> (/sys/kernel/mm/migration/offload_migrator), which accepts the name of the desired migrator
>> ("kernel", "mtcopy", "dcbm"). This would ensure only one migrator is active at a time.
>> Is this the right approach?
>>
>> 2. Dynamic Migrator Selection:
>> Currently, active migrator is a global state, and only one can be active a time.
>> A more flexible approach might be for the caller of migrate_pages() to specify/hint which
>> offload mechanism to use, if any. This would allow a CXL driver to explicitly request DMA while a GPU driver might prefer
>> multi-threaded CPU copy.
>>
>> 3. Tuning Parameters: Expose parameters like number of threads/channels, batch size,
>> and thresholds for using migrators. Who should own these parameters?
>>
>> 4. Resources Accounting[3]:
>> a. CPU cgroups accounting and fairness
>> b. Migration cost attribution
>>
>> FUTURE WORK:
>> ------------
>>
>> 1. Enhance DMA drivers for bulk copying (e.g., SDXi Engine).
>> 2. Enhance multi-threaded CPU copying for platform-specific scheduling of worker threads to optimize bandwidth utilization. Explore sched-ext for this. [2]
>> 3. Enable kpromoted [4] to use the migration offload infrastructure.
>>
>> EARLIER POSTINGS:
>> -----------------
>>
>> - RFC V2: https://lore.kernel.org/all/20250319192211.10092-1-shivankg@amd.com
>> - RFC V1: https://lore.kernel.org/all/20240614221525.19170-1-shivankg@amd.com
>>
>> REFERENCES:
>> -----------
>>
>> [1] RFC from Zi Yan: https://lore.kernel.org/all/20250103172419.4148674-1-ziy@nvidia.com
>> [2] LSFMM: https://lore.kernel.org/all/cf6fc05d-c0b0-4de3-985e-5403977aa3aa@amd.com
>> [3] https://lore.kernel.org/all/CAHbLzkpoKP0fVZP5b10wdzAMDLWysDy7oH0qaUssiUXj80R6bw@mail.gmail.com
>> [4] https://lore.kernel.org/all/20250910144653.212066-1-bharata@amd.com
>>
>> Mike Day (1):
>>   mm: add support for copy offload for folio Migration
>>
>> Shivank Garg (4):
>>   mm: Introduce folios_mc_copy() for batch copying folios
>>   mm/migrate: add migrate_folios_batch_move to  batch the folio move
>>     operations
>>   dcbm: add dma core batch migrator for batch page offloading
>>   mtcopy: spread threads across die for testing
>>
>> Zi Yan (4):
>>   mm/migrate: factor out code in move_to_new_folio() and
>>     migrate_folio_move()
>>   mm/migrate: revive MIGRATE_NO_COPY in migrate_mode
>>   mtcopy: introduce multi-threaded page copy routine
>>   adjust NR_MAX_BATCHED_MIGRATION for testing
>>
>>  drivers/Kconfig                        |   2 +
>>  drivers/Makefile                       |   3 +
>>  drivers/migoffcopy/Kconfig             |  17 +
>>  drivers/migoffcopy/Makefile            |   2 +
>>  drivers/migoffcopy/dcbm/Makefile       |   1 +
>>  drivers/migoffcopy/dcbm/dcbm.c         | 415 +++++++++++++++++++++++++
>>  drivers/migoffcopy/mtcopy/Makefile     |   1 +
>>  drivers/migoffcopy/mtcopy/copy_pages.c | 397 +++++++++++++++++++++++
>>  include/linux/migrate_mode.h           |   2 +
>>  include/linux/migrate_offc.h           |  34 ++
>>  include/linux/mm.h                     |   2 +
>>  mm/Kconfig                             |   8 +
>>  mm/Makefile                            |   1 +
>>  mm/migrate.c                           | 358 ++++++++++++++++++---
>>  mm/migrate_offc.c                      |  58 ++++
>>  mm/util.c                              |  29 ++
>>  16 files changed, 1284 insertions(+), 46 deletions(-)
>>  create mode 100644 drivers/migoffcopy/Kconfig
>>  create mode 100644 drivers/migoffcopy/Makefile
>>  create mode 100644 drivers/migoffcopy/dcbm/Makefile
>>  create mode 100644 drivers/migoffcopy/dcbm/dcbm.c
>>  create mode 100644 drivers/migoffcopy/mtcopy/Makefile
>>  create mode 100644 drivers/migoffcopy/mtcopy/copy_pages.c
>>  create mode 100644 include/linux/migrate_offc.h
>>  create mode 100644 mm/migrate_offc.c
>>
>> -- 
>> 2.43.0
> 
> 
> Best Regards,
> Yan, Zi



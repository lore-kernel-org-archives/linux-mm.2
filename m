Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7037CC79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 21:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094DB6B0092; Thu, 10 Sep 2026 17:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 046176B0093; Thu, 10 Sep 2026 17:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCE16B0095; Thu, 10 Sep 2026 17:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84C026B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:11:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 462F5805D2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:11:18 +0000 (UTC)
X-FDA: 85199098236.22.C9555F9
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012028.outbound.protection.outlook.com [52.101.48.28])
	by imf16.hostedemail.com (Postfix) with ESMTP id AFC64180006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:11:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eI5r66DW;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789074675;
	b=aPwT7S5/OiA+dmWtO5aaJ1SlEIInxRIG/jJW38qjrEpAym+ZZXFfGjZi64HmpLOpow+Igr
	BGYwvFFx1tq2oM3JEw5Kk/zvS5Yu4xBHVs3J6jBoXPDd26/la1IunF49CztAxykn536hxK
	cY7049/6raUjkGsreIahkmtM77DIKis=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eI5r66DW;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789074675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIyqDYP7AxEmXhnq3xjsTqzWSHlQtNl8mhDQY3Mv8uw=;
	b=pt+8ucyCwRoJEtBQ38l1ozdK8r1AGmHrn9JB+8MqXKXuuvLWErZeZ3rMf1p/1CGogNN3S8
	XlEjBklllapWTRzf7fiWyzC5drEJ6uKokzAR+CBhVeLKyDBnXrMbnrjC/opLOHdwdHX09Z
	trhRBI3OHZkelK1jlClo+xInrpmomC8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ifTzMPC85lF7CpwJdf+bdxo9OUSCaqWlkbMH07wAyWXNOCQbLG/23QqVv0Keng7fWdOrUvjWv9Hnjfs3B65piP6viidMRrpKlzZeZ5ZD6gSeYsNz5JoJdf05WRuwohkUWDKFEI6bvBHgfyWHd3WczsWHDPw8eE5HJWt6PI2ETuU5Kr0GpxzQDePcxYnlt/1pbDayMgGbLFWypFAaX5xdIiMh26TjI6fyxU6XDEaFaOp5tF8IOn8pIbqezQw4nFkg8rt7mSxTX+242i8fY/ZyU5P9rPpQW6ntsqTCCgfFPhmar2AUuiSD8Rg5fGCJcS15S2/fLGyrUvNX2DIL0jLPQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PIyqDYP7AxEmXhnq3xjsTqzWSHlQtNl8mhDQY3Mv8uw=;
 b=JTMVNS5w8hf6Fx1v7LwW4svAIekMLBbJ7D79FDt+0+VgixfHG/uTE6gqzRg4NN7vqx9M7ZM8K9TEgop2qiqCubWqFcss2qmkirNMhK3BNT+dAUiY4p4G+IcNsXRsuGpJaIu05CAyDmU8EYKllHrVCnwMjxGtmx4xzHaCl1oLDoO6PZYn3knP17/y/k5CcFu6Ue6B5zvmGiYXO5dpBtTLslZg0Z1Ev1InsSRX/HEf40Q38ZVgWGr0G9f8D9GEeFMb/Vt/S8o/fvnFg4UvM/EPT/DMJaFXpoiuwmWbSDpgYqOOn0olRTw9InWrV7wH2d132wpbm/CiTNrk+FmCAGkZyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PIyqDYP7AxEmXhnq3xjsTqzWSHlQtNl8mhDQY3Mv8uw=;
 b=eI5r66DWUchdmyro5SfaM+R+34VvsQZPjpZLBAOPsDMnBYzuWXCaWZGIgmDeP+3Vi/wX8367p4vQbGEB3RtO31SDK+k08zEF72Du79sOKngNGIO8QwcPAt9URyFoTzPQhZA7SAg+PrsVzfoHRKF6GRnFagnfZaP8FmiYgQPjHVcGVtQoupta//Yw4gSlnJWfhJkFCiLJmXbO1og6JcwuvQrsjHJ1z/JyEZAMANMixwK2mvBWE26tlY9GhLHDTV8BIyJHXgmuW/NIwO3mzlcX3DLubotauXRURifUSOFxNqh8VTVhIuHI+OWgpeS0kgjE86ilMisX84UbkIJyHR0Vwg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 21:11:06 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 21:11:05 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 10 Sep 2026 17:11:04 -0400
Message-Id: <DLBY1EIZD8G9.3O0LMDKCMNPIB@nvidia.com>
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
Cc: "Tal Zussman" <tz2294@columbia.edu>, "Matthew Wilcox (Oracle)"
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
 Song" <kasong@tencent.com>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, "Jaegeuk Kim" <jaegeuk@kernel.org>, "Chao
 Yu" <chao@kernel.org>, <linux-f2fs-devel@lists.sourceforge.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <178889163877.1334491.3646957026033534678.b4-reply@b4>
 <83a8743b-9cbb-42a5-9ff5-718297916a76@kernel.org>
 <3dfab5df-c205-4853-bf48-86351a02b4e2@columbia.edu>
 <927c0ec3-4183-4355-9269-721d79f4983c@kernel.org>
 <30DEBE66-9E26-4468-9A12-123539ED68A3@nvidia.com>
In-Reply-To: <30DEBE66-9E26-4468-9A12-123539ED68A3@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0356.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::31) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: 3449b962-c051-4a85-ae53-08df0f8006fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|5023799004|11063799006|56012099006|4143699003|6133799003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	DHbYsCBdSeXBBBFadFFj7CNxqlMA5OfZXddNRPZnQDjZK4zAeSfi8TnRd+fqEWAGD8oTOlJiQL8lZdB5MYDOp1/ofhEBPIIIQnLWy6pEjkFGtQEcqlS9Fpc5tY4qxBDXwmqtFh7Eb8YYW2COwMAXtYqfGjfDFLoOzoj5IDINUySuJo7Rf6U/4fGEYvqjIPOkx3C4Abi03PLmpQnjv6J3Wyv4zOLTMIU4bFA3hTEAbZJ2qv08NQCAnmod4pziQPJnY/cbqJ5B1x7Xnlw+4DTKaTXY7MFQQFpnBa4rEcWfpAWugYZ/VVQoVzhYOGdA+wwCvIdvM09HTZ77dCYnuVpRJ+UZdqMRZZIKHatkZ7DABelGPNq42J7fEDAtbc1+6xmfog4mhK6phzrwJ/RA+QLf/u+Mxr/zUYQ0Fj+Ob7acwXER5liQbpJYRBXKz1YQucUSPLLiRUGHew5t9vlr2E/dYkTxT//Ldk3WuCaIpkfeGAL0FZNl7t1OKHywikqckuFQTEsa4t7ayIGcd/sdvmmOaAk/v6RHwE+Z/XA+HDYSlk+IAt797bT1RzPP27E+k0Ni41YIZTqDa0q2HlnZ5/6QcyyoOd7nIDzoRwUVpQjJ9GOllc5JlfEnYoRuNFgpyUVlSmXOSywf7gKBBX5/m0PgI95bL4RGr/o+TsHiYIf6u3k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(5023799004)(11063799006)(56012099006)(4143699003)(6133799003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3J4NnVhbGd4L25IYmlOU243R0Z3Q0hwNDhCYW1RKzNkUUJSNEgrT1JFWW5n?=
 =?utf-8?B?bUFXNWxQbWt1VnE0RXErTEF6OW9iV0RDQmE4S0Fpdjc3M3VBdGhwUWhnTUFx?=
 =?utf-8?B?NnJrc2ZtMVU2ZUZMallrd01JL290VVBoN2NOUHZSc0pzSk1IWDM4OW9QNTU4?=
 =?utf-8?B?Z216cWJHaDNOTVI2KytreXZQUk9QOUlPd2drckErNm9MVEhOZVRaZml6UXRL?=
 =?utf-8?B?MzMyQ1ZHTnUwRXBsSTZ2QThPM0diakRQOFBCSVlsc0UzU0N3Yk1qYk9KeEdG?=
 =?utf-8?B?N1VYMUE1bys1ek9ERm9DU3VqV0JkRStvbzdlMDV5OExpYkV2Tk0zTkJYL01J?=
 =?utf-8?B?ckpmZkpReDI1czRMMDdSdEU4ckMwb1BMdWNjT1VtUU5YZmR3dWxhd2NETW8w?=
 =?utf-8?B?clpOL2VvSWtzSGRaNTcyR1BySzZDRHkzWUJyQk9wdTBvMXFLMnBxb01HS0Fz?=
 =?utf-8?B?b1l1Y29sR2tYTEhTakNoTk9EVk9Db3hEdTVCUjZXRjdXL1RBampFaCtsSEZo?=
 =?utf-8?B?TWl1OWk1eGJ5U0tZOU9tUmJFRzljWTV2M3FUUy9GTWNKTjZkUWIrR1NjNC92?=
 =?utf-8?B?L3Z0MXU1VzgxSG1mK0dwc1JzTmpjQ2p4T2tpRHhTREZaWFc2V3pkOFQ4ZDFt?=
 =?utf-8?B?V2FIK3NRcWRhVi9DRWJDZHRtcWRwVjBBaFNqdVVNZk5JalF4UjIyZksyTmVI?=
 =?utf-8?B?Z1RYdmZ4VW1Oa0dSL2M3TFIxRFZPa0ticEIzYW9BcEpDYXBEZnNqb1EvL2Ir?=
 =?utf-8?B?WTBIelJHWS81OGRJbmZ6RVBqQnk5V3lyQzJqS0QvMVUzb0RpeVBEWjFLbXNy?=
 =?utf-8?B?K2VqbHBBWVJid2NLa3p0OGFPZ2JxNE9xaytyNFJ1WW00TmdDenBtZTB1Z3Jo?=
 =?utf-8?B?ZG5RV0ZFYW1mNmMxbHhvRFJkUjc5ZnM3Tk9EYnk1cHB2MDl3d1VpVjU2cldr?=
 =?utf-8?B?Z0UyeEpqQklucHdTMzM3QUw1OVRYOVNhVFRaR0lESVEyZVN2MVN6eEd0d2h5?=
 =?utf-8?B?T3NPN2hVSTJ6Wk0vZkNXTFh0ZGR4MTBBWlVhUVYvbkNlcnk4eG5iUFFuVFJR?=
 =?utf-8?B?aGwwWEUzZGR4UjY2cEJZUk02VVVNbmhaWWxPKzQyTnh2UlJ0N0M1ZHR5Y1Q3?=
 =?utf-8?B?bWE0RzYxbWpkU0E0UXQ4S2lCUEVFT0hkQnJWUlhlZENsK3R0RHBudGNjS2px?=
 =?utf-8?B?NXB3aWFYdmFvSGtyTjYrS3V6dmN3TmYxMXZqYy9qa2JMUzhyZy9kVnowQkZB?=
 =?utf-8?B?Z1pRdHREVHJiVnNHVVVOVHUzT2NmRjN3Q21xeTNhSy9sMXlmSVl4VGhXRzZx?=
 =?utf-8?B?akwrRzFKOUNEUG5DWVlKRGMwOHBHSFlKV29FejNzSEhDQzVzcys2ZnNjbUhT?=
 =?utf-8?B?aHlZOXp3OVZ4ZXg3dmF4R0ZlSlNFbjVseU5URWZNdCswdnpUbmU4TElZYmxm?=
 =?utf-8?B?cHdIcExiVXVPbkVUdStuRi84cks2ZEw2T0RVUnNJeDNuK1NnYUxsTWNEZWRl?=
 =?utf-8?B?eDl5ajJzQkpRcG5xYXpIMGJzU2tYNkp2L0lZRTlTKzVZb0F3ZzdzM1d5a0o1?=
 =?utf-8?B?V09kampKeTk0blUrN3JHY3U1ZmtPN1FiMFNFQUt3VTZvUEloWlBENUZlWmZQ?=
 =?utf-8?B?cEpmT0F0VS9GNVIvMXhLU3ByOWpROXN0T1EyL1JBSjgza0p2dWk3MGc5WS9a?=
 =?utf-8?B?RVk0RW1jeHNpdVZoS1gwTDdVUkp4aVJQejRLdWxjcDJJUEdHdDFJdGhRTE1I?=
 =?utf-8?B?LzVwMFl4NExEcC9hNDZQTzlwSy9vVUNCaW9jbTJzcENnUmNpaTA3Sk1Eam9L?=
 =?utf-8?B?WE05R2dMZmw5Z1cweUErdWJvTzNpZzVkeDlnV2E4alVFL09Hbm5pdVlsVWVL?=
 =?utf-8?B?NnFLR3I1a1g2OHd4bytmSVZ6c0hBNkl3RGxpK2pSRUEza04way9OZzRSbVZN?=
 =?utf-8?B?UFBiUXQvOTZBR1pJUWxJdkRNaXo4SzNyVHQ2R2VCNkpISTZFZ3JBM1ZtY2Nq?=
 =?utf-8?B?VU8zc1krYmpkUWFyQnV4L2xIMitRUTNFeWp5Z2llc3hXY2dTNGxlc3NKNGlL?=
 =?utf-8?B?NU1sRUZSNXlNMk11eEtEbEtINEN3VnNXdFl3MUZYbFhweHNDYmMwWkJ6bnF1?=
 =?utf-8?B?bmR3eU5ZSEdmWDJLd3YrZDd5NjNSTkp6MkdDUXVEc1I3Y0pvdW5aYnZEQWpo?=
 =?utf-8?B?STljT0VJT3h3ZGNxM0lwdTB5SHNBOFRQZG94UmR3eTNOdDVmbkh5MUxvbTJw?=
 =?utf-8?B?UFNwSnF0WDUwSEpXUzAxWFlVLytyTEt6QXdpOU5GcDV4TkNBTEJBV1VrVGpq?=
 =?utf-8?Q?WUgmNkSuMphnPt8eih?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3449b962-c051-4a85-ae53-08df0f8006fe
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 21:11:05.9002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26RDEENSUiOiOWKNaFZxSWXgpjE/82dyCRclMW1Ofp/SorA7PKOec4zq0izNUuGa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AFC64180006
X-Stat-Signature: u5thzshiiknbfwxrebfnx33mp6q9ojdk
X-HE-Tag: 1789074672-165302
X-HE-Meta: U2FsdGVkX1/lIPR1G3ONKGlA/HU4oYmd5EnGD/nCosehVELbKmfQUdAZ5/YuPXLAwHOREkxu+ZgJ85GQZiITvPMI+CZFyQoyIme+q3ZzzzTy+jtHFFkEwH9cTy/7i1R1X5pW5nV+DnMo4rpi5F1QsAutwnN7WqE7jd+u+opI6HnrWXladlJbXmxbTfbKifjT1/jzipIWIvi51dJQIweZUVGhV2OUS0Nf08E9KX/eOLyoVAJkCX6Hf6TGv4jcYrT0u41qE7fyGg6gzhXgs//upPCkzT8SgaySVIcWG6j7VgMbJ5jbZLxh/NuoQtOiSkM5RPXctwMYptOWB4I+UIWVjjhyV07eXIKsqsU5zf3hjhOK9vICMfVZeAMPYR0bXWiz67qaq4rpqDs75QAeqY738i1QrC6BgdvPmIiGQhkd/yYGkHEPF6KUlDZsgYQNGeMoN54OobGQasw11vuZikIyjIkxZM2vsU5jkeLj4QPT5gzQ8seDqjG5uQ6IxWyy5aWM2TkQI9LRtklMMtiwXhaZzFEeKM7R1+MUjGJOwD/d7X+RDvsJ2bWwVG3TN13WUxBsbN+df/OtB/rRC8XLpw176EnhmQM5Ho6JLt5dSjpmKtIe58xVgk69LEu3rBjoxoHbA1dfTJ8iSY/tY3aa0b5j7tyajf6u3Y1Ih8tFzMBzJDbP31P42DKOs66psTM5LDqbP07GZtCUCA0kmfwIQ2MBURf/2HgT/zjCT+Y/fa4GWW2jPFPCOSfOBOn/+LiJyKuaPVR1AB6qF430Mc3ZroRwC89nEfFVq97Osnnpne1RbAfsa3C4GWn+m3yJ3Pg5TPvM17vEFlko0ihCKvaenmJGUG8ZwhXaMEox282Kv+dHAHK/re/0ECHh2ddX+yZ6RZ052Q3IB5rLF3W4jAoxYbz7hS8H4YPEEQu96HjLZ1g0mVSW/iYVK9SVXHYVkkO5q3TnFsCC/GJnBPx9z6QJqa/
 bPqviVCE
 aL/W+LxXGF4m4tDG+CsMZuAcLQFRl27wYfE51vtLcguUjKRGGjj16Kh80HBZME+rckzd1GOGC7yehbThbAvp9tpdyu19jBv+WHjbxFe/hDN/5faqIFeFv6n6vfivp34omp7D8YvBpNGMglenQ/BE9PU+kqUOztM45hQk9F9q3iI7iqB2Yvoyq84a/5H0laAIkHPtUVNOleN37HCtUPNu+FdrgETyKMHFAqliL9mSENGaW1fNkbIvekwu2Xd2FfFpmPY5NOoBlQFu/mwTd04YMizoP2HDk8bPfyGhvWLvH8yvh6bhGju+A95JTPKfl2Sr/JPbkI/IsOcZsZTRCNZeJlv8BNZDsZY1JLlbzdkPw+IdsznLYzx4gMAdUCWxFV+49Y3ukzdbFwBqwaRwIPnFx8VFMdBR11fOby5PoP92WyKrQPcJw+eE9+8WUvRFVg/pe4ND8PPaEYbZXyO14ogjFH5IpVg0Ayo87JvqJWZEQqSAe40TOKtNt/53DgA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 10, 2026 at 8:21 AM EDT, Zi Yan wrote:
> On 10 Sep 2026, at 3:35, David Hildenbrand (Arm) wrote:
>
>> On 9/9/26 19:47, Tal Zussman wrote:
>>> On 9/9/26 3:48 PM, David Hildenbrand (Arm) wrote:
>>>> On 9/8/26 20:20, Tal Zussman wrote:
>>>>>
>>>>> I have a WIP series of ~30 patches converting much of the remaining p=
age
>>>>> users in f2fs (including the below) to folios. Still have to do some
>>>>> testing and clean it up, but hoping to send it out in the next couple=
 of
>>>>> weeks (in the hopes of eliminating some more folio_compat.c functions=
 by
>>>>> next cycle...)
>>>>
>>>> Indeed best to wait a bit before flooding -mm even more, it's rather a=
 lot at
>>>> this point.
>>>>
>>>> In the context of this series, it would be great if you could review w=
hether the
>>>> diff I proposed would get the job done, thanks!
>>>>
>>>
>>> What it changes looks good, but I would go a little further.
>>
>> Thanks!
>>
>>>
>>> There are only two more users of page_private_gcing(), which pass fio->=
page.
>>> Those could easily be converted to folio_test_f2fs_gcing() by passing f=
io->folio,
>>> which is in a union with fio->page. That would let you delete the
>>> page_private_##name() implementation in PAGE_PRIVATE_GET_FUNC() as well=
 and just
>>> remove the entire family. At that point PAGE_PRIVATE_{GET,SET,CLEAR}_FU=
NC()
>>> could be renamed to something like F2FS_FOLIO_PRIVATE_{GET,SET,CLEAR}_F=
UNC() and
>>> all of this cruft is gone and folio-based, with no more f2fs use of pag=
e_private()
>>> either.
>>>
>>> The renaming could be done as a later step, but I would get rid of the =
accessors
>>> as well in one swoop.
>>
>> Yes, either as part of the same patch or as a separate patch. Zi, can yo=
u take
>> care of that? Thanks!
>
> OK, I will come up with a patch based on your patch plus the suggestion h=
ere
> on top of this =E2=80=9Cf2fs: stop using PG_private=E2=80=9D. I will post=
 the patch here
> for feedback to avoid extra churn of the whole series.
>

OK, here is the patch. In addition to David's patch and Tal' suggestion,
I also
1. converted PAGE_PRIVATE_* flags to F2FS_FOLIO_PRIVATE_*,
2. converted page/folio union in f2fs_io_info to folio only, since no
one is using fio->page any more.

Let me know your feedback. I will add this to my patch series once you
are OK with it. Thanks.

From 3bae5c494459b3dd05893df6051e3eb37164f810 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Thu, 10 Sep 2026 16:42:39 -0400
Subject: [PATCH] f2fs: convert the ->private flag helpers to folio-only

page-based ->private flag helpers are used in the compression path, where
large folios are not enabled. They can use folio versions with
page_folio(). The two remaining users in data.c and segment.c can use
fio->folio instead of fio->page (two are in a union).

Drop page-based helpers after the conversion and rename
PAGE_PRIVATE_{GET,SET,CLEAR}_FUNC() and the PAGE_PRIVATE_* flags to
F2FS_FOLIO_PRIVATE_* to match. Convert the folio/page union from
f2fs_io_info union to folio only, since no page user is left.

The folio helpers do a plain read-modify-write where the page ones used
set_bit()/clear_bit(). It is fine because the converted code either holds
folio lock or, in f2fs_compress_write_end_io(), matches what the
non-compressed code does in f2fs_write_end_bio().

Assisted-by: Claude:claude-opus-5
Suggested-by: Tal Zussman <tz2294@columbia.edu>
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 fs/f2fs/compress.c | 35 ++++++++++------
 fs/f2fs/data.c     |  2 +-
 fs/f2fs/f2fs.h     | 99 ++++++++++++++++++----------------------------
 fs/f2fs/segment.c  |  2 +-
 4 files changed, 63 insertions(+), 75 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index ce88092d9ce26..09d9b8d0fdcce 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1064,13 +1064,15 @@ static void cancel_cluster_writeback(struct compres=
s_ctx *cc,
=20
 	/* Cancel writeback and stay locked. */
 	for (i =3D 0; i < cc->cluster_size; i++) {
+		struct folio *folio =3D page_folio(cc->rpages[i]);
+
 		if (i < submitted) {
 			inode_inc_dirty_pages(cc->inode);
-			lock_page(cc->rpages[i]);
+			folio_lock(folio);
 		}
-		clear_page_private_gcing(cc->rpages[i]);
-		if (folio_test_writeback(page_folio(cc->rpages[i])))
-			end_page_writeback(cc->rpages[i]);
+		folio_clear_f2fs_gcing(folio);
+		if (folio_test_writeback(folio))
+			folio_end_writeback(folio);
 	}
 }
=20
@@ -1078,11 +1080,15 @@ static void set_cluster_dirty(struct compress_ctx *=
cc)
 {
 	int i;
=20
-	for (i =3D 0; i < cc->cluster_size; i++)
-		if (cc->rpages[i]) {
-			set_page_dirty(cc->rpages[i]);
-			set_page_private_gcing(cc->rpages[i]);
-		}
+	for (i =3D 0; i < cc->cluster_size; i++) {
+		struct folio *folio;
+
+		if (!cc->rpages[i])
+			continue;
+		folio =3D page_folio(cc->rpages[i]);
+		folio_mark_dirty(folio);
+		folio_set_f2fs_gcing(folio);
+	}
 }
=20
 static int prepare_compress_overwrite(struct compress_ctx *cc,
@@ -1281,7 +1287,7 @@ static int f2fs_write_compressed_pages(struct compres=
s_ctx *cc,
 		.op =3D REQ_OP_WRITE,
 		.op_flags =3D wbc_to_write_flags(wbc),
 		.old_blkaddr =3D NEW_ADDR,
-		.page =3D NULL,
+		.folio =3D NULL,
 		.encrypted_page =3D NULL,
 		.compressed_page =3D NULL,
 		.io_type =3D io_type,
@@ -1370,7 +1376,7 @@ static int f2fs_write_compressed_pages(struct compres=
s_ctx *cc,
 		block_t blkaddr;
=20
 		blkaddr =3D f2fs_data_blkaddr(&dn);
-		fio.page =3D cc->rpages[i];
+		fio.folio =3D page_folio(cc->rpages[i]);
 		fio.old_blkaddr =3D blkaddr;
=20
 		/* cluster header */
@@ -1476,9 +1482,12 @@ void f2fs_compress_write_end_io(struct bio *bio, str=
uct folio *folio)
 	}
=20
 	for (i =3D 0; i < cic->nr_rpages; i++) {
+		struct folio *rfolio;
+
 		WARN_ON(!cic->rpages[i]);
-		clear_page_private_gcing(cic->rpages[i]);
-		end_page_writeback(cic->rpages[i]);
+		rfolio =3D page_folio(cic->rpages[i]);
+		folio_clear_f2fs_gcing(rfolio);
+		folio_end_writeback(rfolio);
 	}
=20
 	page_array_free(sbi, cic->rpages, cic->nr_rpages);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 21f396ebe22ca..ca8232a9095f8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2923,7 +2923,7 @@ bool f2fs_should_update_outplace(struct inode *inode,=
 struct f2fs_io_info *fio)
 		return true;
=20
 	if (fio) {
-		if (page_private_gcing(fio->page))
+		if (folio_test_f2fs_gcing(fio->folio))
 			return true;
 		if (unlikely(is_sbi_flag_set(sbi, SBI_CP_DISABLED) &&
 			f2fs_is_checkpointed_data(sbi, fio->old_blkaddr)))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2f7ab5888b078..85937de3d7016 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1357,10 +1357,7 @@ struct f2fs_io_info {
 	blk_opf_t op_flags;	/* req_flag_bits */
 	block_t new_blkaddr;	/* new block address to be written */
 	block_t old_blkaddr;	/* old block address before Cow */
-	union {
-		struct page *page;	/* page to be written */
-		struct folio *folio;
-	};
+	struct folio *folio;	/* folio to be written */
 	struct page *encrypted_page;	/* encrypted page */
 	struct page *compressed_page;	/* compressed page */
 	struct list_head list;		/* serialize IOs */
@@ -1613,27 +1610,27 @@ static inline void f2fs_set_bit(unsigned int nr, ch=
ar *addr);
 static inline void f2fs_clear_bit(unsigned int nr, char *addr);
=20
 /*
- * Layout of f2fs page.private:
+ * Layout of f2fs folio->private:
  *
  * Layout A: lowest bit should be 1
  * | bit0 =3D 1 | bit1 | bit2 | ... | bit MAX | private data .... |
- * bit 0	PAGE_PRIVATE_NOT_POINTER
- * bit 1	PAGE_PRIVATE_ONGOING_MIGRATION
- * bit 2	PAGE_PRIVATE_INLINE_INODE
- * bit 3	PAGE_PRIVATE_REF_RESOURCE
- * bit 4	PAGE_PRIVATE_ATOMIC_WRITE
+ * bit 0	F2FS_FOLIO_PRIVATE_NOT_POINTER
+ * bit 1	F2FS_FOLIO_PRIVATE_ONGOING_MIGRATION
+ * bit 2	F2FS_FOLIO_PRIVATE_INLINE_INODE
+ * bit 3	F2FS_FOLIO_PRIVATE_REF_RESOURCE
+ * bit 4	F2FS_FOLIO_PRIVATE_ATOMIC_WRITE
  * bit 5-	f2fs private data
  *
  * Layout B: lowest bit should be 0
- * page.private is a wrapped pointer.
+ * folio->private is a wrapped pointer.
  */
 enum {
-	PAGE_PRIVATE_NOT_POINTER,		/* private contains non-pointer data */
-	PAGE_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating=
 */
-	PAGE_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
-	PAGE_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
-	PAGE_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
-	PAGE_PRIVATE_MAX
+	F2FS_FOLIO_PRIVATE_NOT_POINTER,		/* private contains non-pointer data */
+	F2FS_FOLIO_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going mig=
rating */
+	F2FS_FOLIO_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
+	F2FS_FOLIO_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources =
*/
+	F2FS_FOLIO_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
+	F2FS_FOLIO_PRIVATE_MAX
 };
=20
 /* For compression */
@@ -2681,86 +2678,68 @@ static inline int inc_valid_block_count(struct f2fs=
_sb_info *sbi,
 	return -ENOSPC;
 }
=20
-#define PAGE_PRIVATE_GET_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_GET_FUNC(name, flagname) \
 static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
 {									\
 	unsigned long priv =3D (unsigned long)folio->private;		\
-	unsigned long v =3D (1UL << PAGE_PRIVATE_NOT_POINTER) |		\
-			     (1UL << PAGE_PRIVATE_##flagname);		\
+	unsigned long v =3D (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |	\
+			     (1UL << F2FS_FOLIO_PRIVATE_##flagname);	\
 	return (priv & v) =3D=3D v;						\
-}									\
-static inline bool page_private_##name(struct page *page) \
-{ \
-	return page_private(page) && \
-		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
-		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
=20
-#define PAGE_PRIVATE_SET_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_SET_FUNC(name, flagname) \
 static inline void folio_set_f2fs_##name(struct folio *folio)		\
 {									\
-	unsigned long v =3D (1UL << PAGE_PRIVATE_NOT_POINTER) |		\
-			     (1UL << PAGE_PRIVATE_##flagname);		\
+	unsigned long v =3D (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |	\
+			     (1UL << F2FS_FOLIO_PRIVATE_##flagname);	\
 	if (!folio->private)						\
 		folio_attach_private(folio, (void *)v);			\
 	else {								\
 		v |=3D (unsigned long)folio->private;			\
 		folio->private =3D (void *)v;				\
 	}								\
-}									\
-static inline void set_page_private_##name(struct page *page) \
-{ \
-	if (!page_private(page)) \
-		attach_page_private(page, \
-				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
-	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
 }
=20
-#define PAGE_PRIVATE_CLEAR_FUNC(name, flagname) \
+#define F2FS_FOLIO_PRIVATE_CLEAR_FUNC(name, flagname) \
 static inline void folio_clear_f2fs_##name(struct folio *folio)		\
 {									\
 	unsigned long v =3D (unsigned long)folio->private;		\
 									\
-	v &=3D ~(1UL << PAGE_PRIVATE_##flagname);				\
-	if (v =3D=3D (1UL << PAGE_PRIVATE_NOT_POINTER))			\
+	v &=3D ~(1UL << F2FS_FOLIO_PRIVATE_##flagname);			\
+	if (v =3D=3D (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER))		\
 		folio_detach_private(folio);				\
 	else								\
 		folio->private =3D (void *)v;				\
-}									\
-static inline void clear_page_private_##name(struct page *page) \
-{ \
-	clear_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
-	if (page_private(page) =3D=3D BIT(PAGE_PRIVATE_NOT_POINTER)) \
-		detach_page_private(page); \
 }
=20
-PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
-PAGE_PRIVATE_GET_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
+F2FS_FOLIO_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
+F2FS_FOLIO_PRIVATE_GET_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
=20
-PAGE_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
-PAGE_PRIVATE_SET_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
=20
-PAGE_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
-PAGE_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
-PAGE_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
-PAGE_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
+F2FS_FOLIO_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
=20
 static inline unsigned long folio_get_f2fs_data(struct folio *folio)
 {
 	unsigned long data =3D (unsigned long)folio->private;
=20
-	if (!test_bit(PAGE_PRIVATE_NOT_POINTER, &data))
+	if (!test_bit(F2FS_FOLIO_PRIVATE_NOT_POINTER, &data))
 		return 0;
-	return data >> PAGE_PRIVATE_MAX;
+	return data >> F2FS_FOLIO_PRIVATE_MAX;
 }
=20
 static inline void folio_set_f2fs_data(struct folio *folio, unsigned long =
data)
 {
-	data =3D (1UL << PAGE_PRIVATE_NOT_POINTER) | (data << PAGE_PRIVATE_MAX);
+	data =3D (1UL << F2FS_FOLIO_PRIVATE_NOT_POINTER) |
+	       (data << F2FS_FOLIO_PRIVATE_MAX);
=20
 	if (!folio_test_private(folio))
 		folio_attach_private(folio, (void *)data);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 63b712d3d599e..8c156e1fd37d0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3803,7 +3803,7 @@ static int __get_segment_type_6(struct f2fs_io_info *=
fio)
 		if (is_inode_flag_set(inode, FI_ALIGNED_WRITE))
 			return CURSEG_COLD_DATA_PINNED;
=20
-		if (page_private_gcing(fio->page)) {
+		if (folio_test_f2fs_gcing(fio->folio)) {
 			if (fio->sbi->am.atgc_enabled &&
 				(fio->io_type =3D=3D FS_DATA_IO) &&
 				(fio->sbi->gc_mode !=3D GC_URGENT_HIGH) &&
--=20
2.53.0




--=20
Best Regards,
Yan, Zi


